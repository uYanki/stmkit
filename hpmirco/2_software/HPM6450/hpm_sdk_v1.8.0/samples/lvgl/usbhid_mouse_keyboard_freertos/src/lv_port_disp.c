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

#if (LV_USE_OS != LV_OS_NONE)
#include <FreeRTOS.h>
#include <task.h>
#include <semphr.h>
#endif

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
static void    usbhid_mouse_indev_init(void);
static void    usbhid_keyboard_indev_init(void);

/**********************
 *  STATIC VARIABLES
 **********************/
lv_display_t*           lcd_disp;
usbhid_mouse_indev_t    mouse_indev;
usbhid_keyboard_indev_t kb_indev;

/**********************
 *      MACROS
 **********************/

/**********************
 *   GLOBAL FUNCTIONS
 **********************/

ATTR_RAMFUNC uint32_t lvgl_tick_get_cb(void)
{
    return xTaskGetTickCount();
}

ATTR_RAMFUNC void lvgl_delay_cb(uint32_t ms)
{
    vTaskDelay(ms);
}

void lv_port_disp_init(void)
{
    /* Initialize LCD I/O */
    if (lcd_io_init() != 0)
    {
        return;
    }

    lv_tick_set_cb(lvgl_tick_get_cb);
    lv_delay_set_cb(lvgl_delay_cb);

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

    // indev
    usbhid_mouse_indev_init();
    usbhid_keyboard_indev_init();
}

static void indev_mouse_read_cb(lv_indev_t* indev_drv, lv_indev_data_t* data)
{
    int16_t width  = MY_DISP_HOR_RES;
    int16_t height = MY_DISP_VER_RES;

    if (mouse_indev.x < 0)
    {
        mouse_indev.x = 0;
    }
    else if (mouse_indev.x >= width * mouse_indev.sensitivity)
    {
        mouse_indev.x = (width * mouse_indev.sensitivity) - 1;
    }

    if (mouse_indev.y < 0)
    {
        mouse_indev.y = 0;
    }
    else if (mouse_indev.y >= height * mouse_indev.sensitivity)
    {
        mouse_indev.y = (height * mouse_indev.sensitivity) - 1;
    }

    /* Get coordinates by rotation with sensitivity */
    switch (lv_disp_get_rotation(lcd_disp))
    {
        case LV_DISPLAY_ROTATION_0:
            data->point.x = mouse_indev.x / mouse_indev.sensitivity;
            data->point.y = mouse_indev.y / mouse_indev.sensitivity;
            break;
        case LV_DISPLAY_ROTATION_90:
            data->point.y = width - mouse_indev.x / mouse_indev.sensitivity;
            data->point.x = mouse_indev.y / mouse_indev.sensitivity;
            break;
        case LV_DISPLAY_ROTATION_180:
            data->point.x = width - mouse_indev.x / mouse_indev.sensitivity;
            data->point.y = height - mouse_indev.y / mouse_indev.sensitivity;
            break;
        case LV_DISPLAY_ROTATION_270:
            data->point.y = mouse_indev.x / mouse_indev.sensitivity;
            data->point.x = height - mouse_indev.y / mouse_indev.sensitivity;
            break;
    }

    if (mouse_indev.left_button)
    {
        data->state = LV_INDEV_STATE_PRESSED;
    }
    else
    {
        data->state = LV_INDEV_STATE_RELEASED;
    }
}

static void usbhid_mouse_indev_init(void)
{
    mouse_indev.sensitivity = 1;

    mouse_indev.x = MY_DISP_HOR_RES * mouse_indev.sensitivity / 2;  // center
    mouse_indev.y = MY_DISP_VER_RES * mouse_indev.sensitivity / 2;  // center

    lv_indev_t* indev = lv_indev_create();
    lv_indev_set_type(indev, LV_INDEV_TYPE_POINTER);
    lv_indev_set_read_cb(indev, indev_mouse_read_cb);
    lv_indev_set_driver_data(indev, &mouse_indev);

    mouse_indev.indev = indev;

    /*Set cursor. For simplicity set a HOME symbol now.*/
    lv_obj_t* mouse_cursor = lv_img_create(lv_disp_get_scr_act(NULL));
    lv_img_set_src(mouse_cursor, LV_SYMBOL_PLAY);
    lv_indev_set_cursor(indev, mouse_cursor);
}

static void indev_keyboard_read_cb(lv_indev_t* indev_drv, lv_indev_data_t* data)
{
    data->key = kb_indev.last_key;

    if (kb_indev.pressed)
    {
        data->state      = LV_INDEV_STATE_PRESSED;
        kb_indev.pressed = false;
    }
    else
    {
        data->state       = LV_INDEV_STATE_RELEASED;
        kb_indev.last_key = 0;
    }
}

static void usbhid_keyboard_indev_init(void)
{
    lv_indev_t* indev = lv_indev_create();
    lv_indev_set_type(indev, LV_INDEV_TYPE_KEYPAD);
    lv_indev_set_read_cb(indev, indev_keyboard_read_cb);
    lv_indev_set_driver_data(indev, &kb_indev);
    kb_indev.indev = indev;
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
