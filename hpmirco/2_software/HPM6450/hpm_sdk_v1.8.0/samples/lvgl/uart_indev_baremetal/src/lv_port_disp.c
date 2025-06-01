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
#include "lv_conf.h"
#include "board.h"
#include "hpm_dma_mgr.h"
#include "hpm_spi.h"
#include "hpm_uart_drv.h"

#if (LV_USE_OS != LV_OS_NONE)
#include <FreeRTOS.h>
#include <task.h>
#include <semphr.h>
#endif

#include "lv_port_disp.h"
#include "src/drivers/display/st7789/lv_st7789.h"

#define LCD_DC_PIN          HPM_GPIO0, GPIO_DI_GPIOB, 10
#define LCD_RST_PIN         HPM_GPIO0, GPIO_DI_GPIOB, 11
#define LCD_BL_PIN          HPM_GPIO0, GPIO_DI_GPIOA, 23
#define LCD_CS_PIN          HPM_GPIO0, GPIO_OE_GPIOA, 18
#define LCD_SPI_BASE        HPM_SPI1
#define LCD_SPI_CLK_NAME    clock_spi1
#define LCD_SPI_SCLK_FREQ   10000000UL

#define TIM_BASE            HPM_GPTMR5
#define TIM_CH              1
#define TIM_IRQ             IRQn_GPTMR5
#define TIM_CLK_NAME        clock_gptmr5

#define INDEV_UART          HPM_UART9
#define INDEV_UART_IRQ      IRQn_UART9
#define INDEV_UART_CLK_NAME clock_uart9

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
static void    lcd_color_transfer_ready_cb();
static int32_t lcd_io_init(void);
static void    lcd_send_cmd(lv_display_t* disp, const uint8_t* cmd, size_t cmd_size, const uint8_t* param, size_t param_size);
static void    lcd_send_color(lv_display_t* disp, const uint8_t* cmd, size_t cmd_size, uint8_t* param, size_t param_size);
static void    uart_mouse_indev_init(void);

/**********************
 *  STATIC VARIABLES
 **********************/
lv_display_t*                      lcd_disp;
uart_mouse_indev_t                 mouse_indev;
ATTR_PLACE_AT_NONCACHEABLE uint8_t indev_uart_rxbuf[128U] = {0};

#ifndef USE_DMA_MGR
#define USE_DMA_MGR 0
#endif

#if USE_DMA_MGR
static volatile bool txdma_complete = true;
// ATTR_PLACE_AT_NONCACHEABLE_WITH_ALIGNMENT(4)
ATTR_PLACE_AT_FAST_RAM_WITH_ALIGNMENT(4)
uint8_t framebuf[MY_DISP_HOR_RES * MY_DISP_VER_RES * sizeof(lv_color_t) / 10] = {0};
#endif

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
    lv_display_set_rotation(lcd_disp, LV_DISPLAY_ROTATION_0); /* set landscape orientation */
    lv_st7789_set_gap(lcd_disp, 36, 0);

    /* Example: two dynamically allocated buffers for partial rendering */
    lv_color_t* buf1 = NULL;
    lv_color_t* buf2 = NULL;

#if USE_DMA_MGR

    uint32_t buf_size = sizeof(framebuf);

    buf1 = (lv_color_t*)&framebuf[0];
    buf2 = (lv_color_t*)&framebuf[buf_size / 2];

#else

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

#endif

    lv_display_set_buffers(lcd_disp, buf1, buf2, buf_size, LV_DISPLAY_RENDER_MODE_PARTIAL);

    // indev
    uart_mouse_indev_init();
}

/**********************
 *   STATIC FUNCTIONS
 **********************/

static void indev_mouse_read_cb(lv_indev_t* indev_drv, lv_indev_data_t* data)
{
    int16_t width  = MY_DISP_HOR_RES;
    int16_t height = MY_DISP_VER_RES;

    uart_mouse_indev_t _mouse_indev = mouse_indev;

    if (_mouse_indev.x < 0)
    {
        _mouse_indev.x = 0;
    }
    else if (_mouse_indev.x >= width * _mouse_indev.sensitivity)
    {
        _mouse_indev.x = (width * _mouse_indev.sensitivity) - 1;
    }

    if (_mouse_indev.y < 0)
    {
        _mouse_indev.y = 0;
    }
    else if (_mouse_indev.y >= height * _mouse_indev.sensitivity)
    {
        _mouse_indev.y = (height * _mouse_indev.sensitivity) - 1;
    }

    /* Get coordinates by rotation with sensitivity */
    switch (lv_disp_get_rotation(lcd_disp))
    {
        case LV_DISPLAY_ROTATION_0:
            data->point.x = _mouse_indev.x / _mouse_indev.sensitivity;
            data->point.y = _mouse_indev.y / _mouse_indev.sensitivity;
            break;
        case LV_DISPLAY_ROTATION_90:
            data->point.y = width - _mouse_indev.x / _mouse_indev.sensitivity;
            data->point.x = _mouse_indev.y / _mouse_indev.sensitivity;
            break;
        case LV_DISPLAY_ROTATION_180:
            data->point.x = width - _mouse_indev.x / _mouse_indev.sensitivity;
            data->point.y = height - _mouse_indev.y / _mouse_indev.sensitivity;
            break;
        case LV_DISPLAY_ROTATION_270:
            data->point.y = _mouse_indev.x / _mouse_indev.sensitivity;
            data->point.x = height - _mouse_indev.y / _mouse_indev.sensitivity;
            break;
    }

    if (_mouse_indev.left_button)
    {
        data->state = LV_INDEV_STATE_PRESSED;
    }
    else
    {
        data->state = LV_INDEV_STATE_RELEASED;
    }
}

SDK_DECLARE_EXT_ISR_M(INDEV_UART_IRQ, uart_isr)

uint16_t byteIndex = 0;

void uart_isr(void)
{
    uint8_t count = 0;

    uint8_t irq_id = uart_get_irq_id(INDEV_UART);

    if (irq_id == uart_intr_id_rx_data_avail)
    {
        while (uart_check_status(INDEV_UART, uart_stat_data_ready))
        {
            count++;
            indev_uart_rxbuf[byteIndex++] = uart_read_byte(INDEV_UART);
            /*in order to ensure rx fifo there are remaining bytes*/
            if (count > 12)
            {
                break;
            }
        }
    }

    if (irq_id == uart_intr_id_rx_timeout)
    {
        while ((uart_check_status(INDEV_UART, uart_stat_data_ready)) || (uart_check_status(INDEV_UART, uart_stat_overrun_error)))
        {
            indev_uart_rxbuf[byteIndex++] = uart_read_byte(INDEV_UART);
        }

        {
            char xc[4] = {0}, yc[4] = {0};

            xc[0] = indev_uart_rxbuf[2];
            xc[1] = indev_uart_rxbuf[3];
            xc[2] = indev_uart_rxbuf[4];
            yc[0] = indev_uart_rxbuf[8];
            yc[1] = indev_uart_rxbuf[9];
            yc[2] = indev_uart_rxbuf[10];

            mouse_indev.x = atoi(xc);
            mouse_indev.y = atoi(yc);

            if (indev_uart_rxbuf[12] == '1')
            {
                mouse_indev.left_button = 1;
            }
            else
            {
                mouse_indev.left_button = 0;
            }
        }
 
        byteIndex = 0;

    }
}

static void uart_mouse_indev_init(void)
{
    uart_config_t config = {0};

    HPM_IOC->PAD[IOC_PAD_PA29].FUNC_CTL = IOC_PA29_FUNC_CTL_UART9_RXD;
    HPM_IOC->PAD[IOC_PAD_PA30].FUNC_CTL = IOC_PA30_FUNC_CTL_UART9_TXD;
    clock_add_to_group(INDEV_UART_CLK_NAME, 0);

    uart_default_config(INDEV_UART, &config);
    config.fifo_enable    = true;
    config.dma_enable     = true;
    config.src_freq_in_hz = clock_get_frequency(INDEV_UART_CLK_NAME);
    config.tx_fifo_level  = uart_tx_fifo_trg_not_full;
    config.rx_fifo_level  = uart_rx_fifo_trg_gt_three_quarters;

    uart_init(INDEV_UART, &config);

    uart_enable_irq(INDEV_UART, uart_intr_rx_data_avail_or_timeout);
    intc_m_enable_irq_with_priority(INDEV_UART_IRQ, 2);

    mouse_indev.sensitivity = 1;

    mouse_indev.x = MY_DISP_HOR_RES * mouse_indev.sensitivity / 2;  // center
    mouse_indev.y = MY_DISP_VER_RES * mouse_indev.sensitivity / 2;  // center

    lv_indev_t* indev = lv_indev_create();
    lv_indev_set_type(indev, LV_INDEV_TYPE_POINTER);
    lv_indev_set_read_cb(indev, indev_mouse_read_cb);
    lv_indev_set_driver_data(indev, &mouse_indev);

    mouse_indev.indev = indev;

    /* Set cursor. For simplicity set a HOME symbol now.*/
    lv_obj_t* mouse_cursor = lv_img_create(lv_disp_get_scr_act(NULL));
    lv_img_set_src(mouse_cursor, LV_SYMBOL_PLAY);
    lv_indev_set_cursor(indev, mouse_cursor);
}

#if USE_DMA_MGR
void spi_txdma_complete_callback(uint32_t channel)
{
    (void)channel;
    txdma_complete = true;
}
#endif

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

#if USE_DMA_MGR
    dma_mgr_init();
    hpm_spi_dma_install_callback(LCD_SPI_BASE, spi_txdma_complete_callback, NULL);
#endif

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

#if USE_DMA_MGR

        uint32_t remain_size   = param_size;
        uint32_t transfer_size = 0;

        while (remain_size > 0)
        {
            transfer_size = (remain_size > SPI_SOC_TRANSFER_COUNT_MAX) ? SPI_SOC_TRANSFER_COUNT_MAX : remain_size;

            txdma_complete = false;
            if (hpm_spi_transmit_nonblocking(LCD_SPI_BASE, (uint8_t*)param, transfer_size) != status_success)
            {
                printf("hpm_spi_transmit_nonblocking fail\n");
                break;
            }

            while (txdma_complete == false);

            remain_size -= transfer_size;
            param += transfer_size;
        }

#else

        uint32_t remain_size   = param_size;
        uint32_t transfer_size = 0;

        while (remain_size > 0)
        {
            transfer_size = (remain_size > SPI_SOC_TRANSFER_COUNT_MAX) ? SPI_SOC_TRANSFER_COUNT_MAX : remain_size;
            hpm_spi_transmit_blocking(LCD_SPI_BASE, param, transfer_size, BUS_SPI_POLL_TIMEOUT);
            remain_size -= transfer_size;
            param += transfer_size;
        }

#endif
    }

    /* CS high */
    gpio_write_pin(LCD_CS_PIN, 1);

    lv_display_flush_ready(lcd_disp);
}

#else /*Enable this file at the top*/

/*This dummy typedef exists purely to silence -Wpedantic.*/
typedef int keep_pedantic_happy;
#endif
