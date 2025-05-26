#include <stdio.h>
#include "board.h"

#include "iap.h"
#include "flash_if.h"
#include "delay.h"

#include "hpm_gptmr_drv.h"
#include "hpm_l1c_drv.h"
#include "hpm_clock_drv.h"

// 1ms 定时器
#define SYSTICK_TIM_BASE     HPM_GPTMR1
#define SYSTICK_TIM_CH       1
#define SYSTICK_TIM_IRQ      IRQn_GPTMR1
#define SYSTICK_TIM_CLK      clock_gptmr1
#define SYSTICK_TIM_IRQ_PRIO 1

#define DEBUG_UART_CLK       BOARD_CONSOLE_UART_CLK_NAME

extern iap_if_t iapif_uart_rs485;
extern iap_if_t iapif_usbd_hid;

volatile uint32_t u32SysTick1ms = 0; // 计时

iap_if_t* iapifs[] = {
    &iapif_uart_rs485,
    &iapif_usbd_hid,
};

void jump_to_app(void)
{
    gptmr_stop_counter(SYSTICK_TIM_BASE, SYSTICK_TIM_CH);
    clock_remove_from_group(SYSTICK_TIM_CLK, 0);
    clock_remove_from_group(DEBUG_UART_CLK, 0);

    for (int i = 0; i < ARRAY_SIZE(iapifs); i++)
    {
        iapifs[i]->lowlevel_deinit();
    }

    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    // disable_global_irq(CSR_MSTATUS_SIE_MASK);
    disable_global_irq(CSR_MSTATUS_UIE_MASK);
    l1c_dc_invalidate_all();
    l1c_dc_disable();
    l1c_ic_disable();
    fencei();

#if 0
    // 动态地址跳转
    typedef void (*app_entry_t)(void);
    app_entry_t app_entry = (app_entry_t)(FLASH_APP_ADDRESS);
    app_entry();
#else
    // 汇编跳转只能给定常量
    __asm("la a0, %0" ::"i"(FLASH_APP_ADDRESS));
    __asm("jr a0");
#endif
}

static void tim_init(void)
{
    uint32_t               gptmr_freq;
    gptmr_channel_config_t config = {0};

    //
    // 1ms
    //

    clock_add_to_group(SYSTICK_TIM_CLK, 0);
    gptmr_freq = clock_get_frequency(SYSTICK_TIM_CLK);

    gptmr_channel_get_default_config(SYSTICK_TIM_BASE, &config);
    config.mode   = gptmr_work_mode_no_capture;
    config.reload = gptmr_freq / 1000;
    gptmr_channel_config(SYSTICK_TIM_BASE, SYSTICK_TIM_CH, &config, false);
    gptmr_start_counter(SYSTICK_TIM_BASE, SYSTICK_TIM_CH);

    gptmr_enable_irq(SYSTICK_TIM_BASE, GPTMR_CH_RLD_IRQ_MASK(SYSTICK_TIM_CH));
    intc_m_enable_irq_with_priority(SYSTICK_TIM_IRQ, SYSTICK_TIM_IRQ_PRIO);
}

void tim_ms_isr(void)
{
    if (gptmr_check_status(SYSTICK_TIM_BASE, GPTMR_CH_RLD_STAT_MASK(SYSTICK_TIM_CH)))
    {
        gptmr_clear_status(SYSTICK_TIM_BASE, GPTMR_CH_RLD_STAT_MASK(SYSTICK_TIM_CH));

        u32SysTick1ms++;  // ms 计数器
    }
}

SDK_DECLARE_EXT_ISR_M(SYSTICK_TIM_IRQ, tim_ms_isr);

void enter_stop_mode(void)
{
    board_delay_ms(100);
    disable_irq_from_intc();

    while (1)
    {
    }
}

int main(void)
{
    uint8_t  i;
    uint32_t iap_time;
    
    board_delay_ms(100);

    board_init_clock();
    board_init_console();
    board_init_pmp();

    printf("bios init\r\n");

    flashif.init();

    enable_irq_from_intc();

    tim_init();

    for (i = 0; i < ARRAY_SIZE(iapifs); i++)
    {
        iapifs[i]->lowlevel_init();
    }

    printf("bios run\r\n");

__boot_start:

    iap_time = u32_GetTick();
     
    while (1)
    {
        for (i = 0; i < ARRAY_SIZE(iapifs); i++)
        {
            if (iapifs[i]->try_shakehand())
            {
#if 0  // disable other interfaces
                for (int j = 0; j < ARRAY_SIZE(iapifs); j++)
                {
                    if (i != j)
                    {
                        iapifs[j]->lowlevel_deinit();
                    }
                }
#endif

                iapifs[i]->transfer();

                enter_stop_mode();
            }
        }

        if (E_DelayNonBlock(iap_time, 2000) == true)
        {
            goto __app_start;
        }
    }

__app_start:

    printf("app run\r\n");

    jump_to_app();
    enter_stop_mode();

    return 0;
}
