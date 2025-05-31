/**
 * @file lv_port_lcd_stm32_template.c
 *
 * Example implementation of the LVGL LCD display drivers on the STM32 platform
 */

/*Copy this file as "lv_port_disp.c" and set this value to "1" to enable content*/
#if 1

/*********************
 *      INCLUDES
 *********************/
/* Include STM32Cube files here, e.g.:
#include "stm32f7xx_hal.h"
*/

#include "hpm_gpio_drv.h"
#include "hpm_gpiom_drv.h"
#include "hpm_clock_drv.h"
#include "hpm_gptmr_drv.h"
#include "hpm_spi.h"
#include "lv_conf.h"
#include "board.h"

#include "lv_port_disp.h"
#include "src/drivers/display/st7789/lv_st7789.h"

#define LCD_DC_PIN           HPM_GPIO0, GPIO_DI_GPIOB, 10
#define LCD_RST_PIN          HPM_GPIO0, GPIO_DI_GPIOB, 11
#define LCD_BL_PIN           HPM_GPIO0, GPIO_DI_GPIOA, 23
#define LCD_CS_PIN           HPM_GPIO0, GPIO_OE_GPIOA, 18
#define LCD_SPI_BASE         HPM_SPI1
#define LCD_SPI_CLK_NAME     clock_spi1
#define LCD_SPI_SCLK_FREQ    10000000UL
#define LCD_SPI_DMA          HPM_HDMA
#define LCD_SPI_DMAMUX       HPM_DMAMUX
#define LCD_SPI_RX_DMA_REQ   HPM_DMA_SRC_SPI1_RX
#define LCD_SPI_TX_DMA_REQ   HPM_DMA_SRC_SPI1_TX
#define LCD_SPI_RX_DMA_CH    0
#define LCD_SPI_TX_DMA_CH    1
#define LCD_SPI_RX_DMAMUX_CH DMA_SOC_CHN_TO_DMAMUX_CHN(LCD_SPI_DMA, LCD_SPI_RX_DMA_CH)
#define LCD_SPI_TX_DMAMUX_CH DMA_SOC_CHN_TO_DMAMUX_CHN(LCD_SPI_DMA, LCD_SPI_TX_DMA_CH)

#define TIM_BASE             HPM_GPTMR5
#define TIM_CH               1
#define TIM_IRQ              IRQn_GPTMR5
#define TIM_CLK_NAME         clock_gptmr5

/*********************
 *      DEFINES
 *********************/
#ifndef MY_DISP_HOR_RES
#warning Please define or replace the macro MY_DISP_HOR_RES with the actual screen width, default value 320 is used for now.
#define MY_DISP_HOR_RES 320
#endif

#ifndef MY_DISP_VER_RES
#warning Please define or replace the macro MY_DISP_VER_RES with the actual screen height, default value 240 is used for now.
#define MY_DISP_VER_RES 240
#endif

#define BUS_SPI_POLL_TIMEOUT 0x1000U

/**********************
 *      TYPEDEFS
 **********************/

/**********************
 *  STATIC PROTOTYPES
 **********************/
static void         lcd_color_transfer_ready_cb();
static int32_t      lcd_io_init(void);
static void         lcd_send_cmd(lv_display_t* disp, const uint8_t* cmd, size_t cmd_size, const uint8_t* param, size_t param_size);
static void         lcd_send_color(lv_display_t* disp, const uint8_t* cmd, size_t cmd_size, uint8_t* param, size_t param_size);
/**********************
 *  STATIC VARIABLES
 **********************/
lv_display_t*       lcd_disp;

/**********************
 *      MACROS
 **********************/

/**********************
 *   GLOBAL FUNCTIONS
 **********************/

static void tim_init(void)
{
    uint32_t               gptmr_freq;
    gptmr_channel_config_t config;

    gptmr_channel_get_default_config(TIM_BASE, &config);

    clock_add_to_group(TIM_CLK_NAME, 0);
    gptmr_freq = clock_get_frequency(TIM_CLK_NAME);

    config.reload = gptmr_freq / 1000 * 1;  // 1 ms
    gptmr_channel_config(TIM_BASE, TIM_CH, &config, false);
    gptmr_enable_irq(TIM_BASE, GPTMR_CH_RLD_IRQ_MASK(TIM_CH));
    intc_m_enable_irq_with_priority(TIM_IRQ, 1);

    gptmr_start_counter(TIM_BASE, TIM_CH);
}

void tim_isr(void)
{
    if (gptmr_check_status(TIM_BASE, GPTMR_CH_RLD_STAT_MASK(TIM_CH)))
    {
        lv_tick_inc(1);
        gptmr_clear_status(TIM_BASE, GPTMR_CH_RLD_STAT_MASK(TIM_CH));
    }
}

SDK_DECLARE_EXT_ISR_M(TIM_IRQ, tim_isr)

void lv_port_disp_init(void)
{
    tim_init();

    /* Initialize LCD I/O */
    if (lcd_io_init() != 0)
    {
        return;
    }

    /* Create the LVGL display object and the ST7789 LCD display driver */
    lcd_disp = lv_st7789_create(MY_DISP_HOR_RES, MY_DISP_VER_RES, LV_LCD_FLAG_NONE, lcd_send_cmd, lcd_send_color);
    lv_st7789_set_invert(lcd_disp, true);
    lv_display_set_rotation(lcd_disp, LV_DISPLAY_ROTATION_270); /* set landscape orientation */
    lv_st7789_set_gap(lcd_disp, 0, 36);

    /* Example: two dynamically allocated buffers for partial rendering */
    lv_color_t* buf1 = NULL;
    lv_color_t* buf2 = NULL;

    uint32_t buf_size = MY_DISP_HOR_RES * MY_DISP_VER_RES / 10 * lv_color_format_get_size(lv_display_get_color_format(lcd_disp));

    buf1 = lv_malloc(buf_size);
    if (buf1 == NULL)
    {
        LV_LOG_ERROR("display draw buffer malloc failed");
        return;
    }

    buf2 = lv_malloc(buf_size);
    if (buf2 == NULL)
    {
        LV_LOG_ERROR("display buffer malloc failed");
        lv_free(buf1);
        return;
    }
    lv_display_set_buffers(lcd_disp, buf1, buf2, buf_size, LV_DISPLAY_RENDER_MODE_PARTIAL);
}

/**********************
 *   STATIC FUNCTIONS
 **********************/

/* Initialize LCD I/O bus, reset LCD */
static int32_t lcd_io_init(void)
{
    spi_initialize_config_t init_config;

    HPM_IOC->PAD[IOC_PAD_PB10].FUNC_CTL = IOC_PB10_FUNC_CTL_GPIO_B_10;
    HPM_IOC->PAD[IOC_PAD_PB11].FUNC_CTL = IOC_PB11_FUNC_CTL_GPIO_B_11;
    HPM_IOC->PAD[IOC_PAD_PA23].FUNC_CTL = IOC_PA23_FUNC_CTL_GPIO_A_23;
    HPM_IOC->PAD[IOC_PAD_PA18].FUNC_CTL = IOC_PA18_FUNC_CTL_GPIO_A_18;

    HPM_IOC->PAD[IOC_PAD_PA16].FUNC_CTL = IOC_PA16_FUNC_CTL_SPI1_MOSI;
    HPM_IOC->PAD[IOC_PAD_PA21].FUNC_CTL = IOC_PA21_FUNC_CTL_SPI1_SCLK | IOC_PAD_FUNC_CTL_LOOP_BACK_MASK;

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOB, 10, gpiom_soc_gpio0);
    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOB, 11, gpiom_soc_gpio0);
    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOA, 18, gpiom_soc_gpio0);
    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOA, 23, gpiom_soc_gpio0);

    gpio_set_pin_output_with_initial(LCD_DC_PIN, 1);
    gpio_set_pin_output_with_initial(LCD_CS_PIN, 1);
    gpio_set_pin_output_with_initial(LCD_RST_PIN, 0);
    gpio_set_pin_output_with_initial(LCD_BL_PIN, 1);

    /* spi */
    clock_add_to_group(LCD_SPI_CLK_NAME, 0);

    hpm_spi_get_default_init_config(&init_config);
    init_config.direction    = msb_first;
    init_config.mode         = spi_master_mode;
    init_config.clk_phase    = spi_sclk_sampling_odd_clk_edges;
    init_config.clk_polarity = spi_sclk_low_idle;
    init_config.data_len     = 8;
    init_config.io_mode      = spi_single_io_mode;

    hpm_spi_initialize(LCD_SPI_BASE, &init_config);
    hpm_spi_set_sclk_frequency(LCD_SPI_BASE, LCD_SPI_SCLK_FREQ);

    /* reset LCD */
    gpio_write_pin(LCD_RST_PIN, 0);
    board_delay_ms(50);
    gpio_write_pin(LCD_RST_PIN, 1);
    board_delay_ms(50);

    return status_success;
}

/* Platform-specific implementation of the LCD send command function. In general this should use polling transfer. */
static void lcd_send_cmd(lv_display_t* disp, const uint8_t* cmd, size_t cmd_size, const uint8_t* param, size_t param_size)
{
    LV_UNUSED(disp);

    /* DC low (command) */
    gpio_write_pin(LCD_DC_PIN, 0);
    /* CS low */
    gpio_write_pin(LCD_CS_PIN, 0);
    /* send command */
    if (hpm_spi_transmit_blocking(LCD_SPI_BASE, (uint8_t*)cmd, cmd_size, BUS_SPI_POLL_TIMEOUT) == status_success)
    {
        /* DC high (data) */
        gpio_write_pin(LCD_DC_PIN, 1);
        /* for short data blocks we use polling transfer */
        hpm_spi_transmit_blocking(LCD_SPI_BASE, (uint8_t*)param, (uint16_t)param_size, BUS_SPI_POLL_TIMEOUT);
    }

    /* CS high */
    gpio_write_pin(LCD_CS_PIN, 1);

    lv_display_flush_ready(lcd_disp);
}

/* Platform-specific implementation of the LCD send color function. For better performance this should use DMA transfer.
 * In case of a DMA transfer a callback must be installed to notify LVGL about the end of the transfer.
 */
static void lcd_send_color(lv_display_t* disp, const uint8_t* cmd, size_t cmd_size, uint8_t* param, size_t param_size)
{
    LV_UNUSED(disp);

    /* DC low (command) */
    gpio_write_pin(LCD_DC_PIN, 0);

    /* CS low */
    gpio_write_pin(LCD_CS_PIN, 0);

    /* send command */
    if (hpm_spi_transmit_blocking(LCD_SPI_BASE, (uint8_t*)cmd, cmd_size, BUS_SPI_POLL_TIMEOUT) == status_success)
    {
        /* DC high (data) */
        gpio_write_pin(LCD_DC_PIN, 1);

        while (param_size > SPI_SOC_TRANSFER_COUNT_MAX)
        {
            hpm_spi_transmit_blocking(LCD_SPI_BASE, param, SPI_SOC_TRANSFER_COUNT_MAX, BUS_SPI_POLL_TIMEOUT);
            param += SPI_SOC_TRANSFER_COUNT_MAX;
            param_size -= SPI_SOC_TRANSFER_COUNT_MAX;
        }

        hpm_spi_transmit_blocking(LCD_SPI_BASE, param, param_size, BUS_SPI_POLL_TIMEOUT);
    }

    /* CS high */
    gpio_write_pin(LCD_CS_PIN, 1);

    lv_display_flush_ready(lcd_disp);
}

#else /*Enable this file at the top*/

/*This dummy typedef exists purely to silence -Wpedantic.*/
typedef int keep_pedantic_happy;
#endif
