#include "hpm_dport.h"

#include "ethercat_src/ecat_def.h"
#include "ethercat_src/hw_access.h"
#include "ethercat_src/ecatappl.h"

#include "hpm_gpio_drv.h"
#include "hpm_gpiom_drv.h"
#include "hpm_clock_drv.h"
#include "hpm_gptmr_drv.h"
#include "hpm_spi.h"

#define DPORT_SPI_CLK      clock_spi0
#define DPORT_SPI_BASE     HPM_SPI0

#define DPORT_SPI_CS_PIN   HPM_GPIO0, GPIO_DI_GPIOZ, 2

#define DPORT_TIM_BASE     HPM_GPTMR5
#define DPORT_TIM_CH       1
#define DPORT_TIM_IRQ      IRQn_GPTMR5
#define DPORT_TIM_CLK_NAME clock_gptmr5

#define DPORT_SYNC0_PIN    HPM_GPIO0, GPIO_IE_GPIOB, 13
#define DPORT_SYNC1_PIN    HPM_GPIO0, GPIO_IE_GPIOB, 14
#define DPORT_SYNCx_IRQ    IRQn_GPIO0_B

#define DPORT_PDI_PIN      HPM_GPIO0, GPIO_IE_GPIOD, 15
#define DPORT_PDI_IRQ      IRQn_GPIO0_D

static uint32_t ms = 0;

//
// SPI
//

static void dport_spi_init(void)
{
    spi_initialize_config_t init_config;

    // clock
    clock_add_to_group(DPORT_SPI_CLK, 0);

    // pinmux
    HPM_BIOC->PAD[IOC_PAD_PZ02].FUNC_CTL = BIOC_PZ02_FUNC_CTL_SOC_PZ_02;
    HPM_BIOC->PAD[IOC_PAD_PZ05].FUNC_CTL = BIOC_PZ05_FUNC_CTL_SOC_PZ_05;
    HPM_BIOC->PAD[IOC_PAD_PZ04].FUNC_CTL = BIOC_PZ04_FUNC_CTL_SOC_PZ_04;
    HPM_BIOC->PAD[IOC_PAD_PZ03].FUNC_CTL = BIOC_PZ03_FUNC_CTL_SOC_PZ_03 | IOC_PAD_FUNC_CTL_LOOP_BACK_MASK;
    HPM_IOC->PAD[IOC_PAD_PZ02].FUNC_CTL  = IOC_PZ02_FUNC_CTL_GPIO_Z_02;
    HPM_IOC->PAD[IOC_PAD_PZ05].FUNC_CTL  = IOC_PZ05_FUNC_CTL_SPI0_MISO;
    HPM_IOC->PAD[IOC_PAD_PZ04].FUNC_CTL  = IOC_PZ04_FUNC_CTL_SPI0_MOSI;
    HPM_IOC->PAD[IOC_PAD_PZ03].FUNC_CTL  = IOC_PZ03_FUNC_CTL_SPI0_SCLK | IOC_PAD_FUNC_CTL_LOOP_BACK_MASK;

    gpio_set_pin_output_with_initial(DPORT_SPI_CS_PIN, 1);

    // spi
    hpm_spi_get_default_init_config(&init_config);
    init_config.direction    = msb_first;
    init_config.mode         = spi_master_mode;
    init_config.clk_phase    = spi_sclk_sampling_odd_clk_edges;
    init_config.clk_polarity = spi_sclk_low_idle;
    init_config.data_len     = 8;

    hpm_spi_initialize(DPORT_SPI_BASE, &init_config);
    hpm_spi_set_sclk_frequency(DPORT_SPI_BASE, 16000000UL);  // 16M
}

static void dport_tim_init(void)
{
    uint32_t               gptmr_freq;
    gptmr_channel_config_t config;

    gptmr_channel_get_default_config(DPORT_TIM_BASE, &config);

    clock_add_to_group(DPORT_TIM_CLK_NAME, 0);
    gptmr_freq = clock_get_frequency(DPORT_TIM_CLK_NAME);

    config.reload = gptmr_freq / 1000 * 1;  // 1 ms
    gptmr_channel_config(DPORT_TIM_BASE, DPORT_TIM_CH, &config, false);
    gptmr_enable_irq(DPORT_TIM_BASE, GPTMR_CH_RLD_IRQ_MASK(DPORT_TIM_CH));
    intc_m_enable_irq_with_priority(DPORT_TIM_IRQ, 1);
}

void _Timisr(void)
{
    if (gptmr_check_status(DPORT_TIM_BASE, GPTMR_CH_RLD_STAT_MASK(DPORT_TIM_CH)))
    {
        gptmr_clear_status(DPORT_TIM_BASE, GPTMR_CH_RLD_STAT_MASK(DPORT_TIM_CH));
        ms++;
        ECAT_CheckTimer();
    }
}

SDK_DECLARE_EXT_ISR_M(DPORT_TIM_IRQ, _Timisr)

unsigned int HW_GetTimer(void)
{
    return ms * ECAT_TIMER_INC_P_MS + gptmr_channel_get_counter(DPORT_TIM_BASE, DPORT_TIM_CH, gptmr_counter_type_normal);
}

void HW_ClearTimer(void)
{
    gptmr_channel_reset_count(DPORT_TIM_BASE, DPORT_TIM_CH);
    ms = 0;
}

//
// Sync & PDI Isr
//

static void dport_exti_init(void)
{
#if DC_SUPPORTED

    HPM_IOC->PAD[IOC_PAD_PB13].FUNC_CTL = IOC_PB13_FUNC_CTL_GPIO_B_13;
    HPM_IOC->PAD[IOC_PAD_PB14].FUNC_CTL = IOC_PB14_FUNC_CTL_GPIO_B_14;

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOB, 13, gpiom_soc_gpio0);
    gpio_set_pin_input(DPORT_SYNC0_PIN);
    gpio_config_pin_interrupt(DPORT_SYNC0_PIN, gpio_interrupt_trigger_edge_falling);
    gpio_enable_pin_interrupt(DPORT_SYNC0_PIN);

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOB, 14, gpiom_soc_gpio0);
    gpio_set_pin_input(DPORT_SYNC1_PIN);
    gpio_config_pin_interrupt(DPORT_SYNC1_PIN, gpio_interrupt_trigger_edge_falling);
    gpio_enable_pin_interrupt(DPORT_SYNC1_PIN);

    intc_m_enable_irq(DPORT_SYNCx_IRQ);

#endif

#if AL_EVENT_ENABLED

    HPM_IOC->PAD[IOC_PAD_PD15].FUNC_CTL = IOC_PD15_FUNC_CTL_GPIO_D_15;

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOD, 15, gpiom_soc_gpio0);
    gpio_set_pin_input(DPORT_PDI_PIN);
    gpio_config_pin_interrupt(DPORT_PDI_PIN, gpio_interrupt_trigger_edge_falling);
    gpio_enable_pin_interrupt(DPORT_PDI_PIN);

    intc_m_enable_irq(DPORT_PDI_IRQ);

#endif
}

void _SyncIsr(void)
{
#if DC_SUPPORTED
    extern void Sync0_Isr(void);
    extern void Sync1_Isr(void);

    if (gpio_check_clear_interrupt_flag(DPORT_SYNC0_PIN))
    {
        Sync0_Isr();
        // printf("sync 0\n");
    }
    if (gpio_check_clear_interrupt_flag(DPORT_SYNC1_PIN))
    {
        Sync1_Isr();
        // printf("sync 1\n");
    }
#endif
}

#if DC_SUPPORTED
SDK_DECLARE_EXT_ISR_M(DPORT_SYNCx_IRQ, _SyncIsr)
#endif

void _PDI_Isr(void)
{
#if AL_EVENT_ENABLED
    extern void PDI_Isr(void);

    if (gpio_check_clear_interrupt_flag(DPORT_PDI_PIN))
    {
        // printf("pdi\n");
        PDI_Isr();
    }

#endif
}

#if AL_EVENT_ENABLED
SDK_DECLARE_EXT_ISR_M(DPORT_PDI_IRQ, _PDI_Isr)
#endif


void DISABLE_ESC_INT(void)
{
#if AL_EVENT_ENABLED
    gpio_disable_pin_interrupt(DPORT_PDI_PIN);
#endif
}

void ENABLE_ESC_INT(void)
{
#if AL_EVENT_ENABLED
    gpio_enable_pin_interrupt(DPORT_PDI_PIN);
#endif
}


//
//
//

void dport_init(void)
{
    dport_spi_init();
    dport_tim_init();
    dport_exti_init();
}

void dport_start(void)
{
    gptmr_start_counter(DPORT_TIM_BASE, DPORT_TIM_CH);
}

void dport_esc_init(void)
{
    HW_Init();
    MainInit();
}

void dport_esc_cycle(void)
{
    MainLoop();
}