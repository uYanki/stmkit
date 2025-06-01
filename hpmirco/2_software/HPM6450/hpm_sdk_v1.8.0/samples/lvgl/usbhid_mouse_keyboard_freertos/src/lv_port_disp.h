/**
 * @file lv_port_lcd_stm32_template.h
 *
 */

/*Copy this file as "lv_port_disp.h" and set this value to "1" to enable content*/
#if 1

#ifndef LV_PORT_LCD_STM32_TEMPL_H
#define LV_PORT_LCD_STM32_TEMPL_H

#ifdef __cplusplus
extern "C" {
#endif

/*********************
 *      INCLUDES
 *********************/
#if !defined(LV_LVGL_H_INCLUDE_SIMPLE)
#include "lvgl.h"
#else
#include "lvgl/lvgl.h"
#endif

/*********************
 *      DEFINES
 *********************/
#define MY_DISP_HOR_RES 170
#define MY_DISP_VER_RES 320
/**********************
 *      TYPEDEFS
 **********************/

typedef struct usbhid_mouse_indev {
    lv_indev_t* indev;       /* LVGL mouse input device driver*/
    uint8_t     sensitivity; /*。Mouse sensitivity (cannot be zero) */
    int16_t     x;           /* Mouse X coordinate */
    int16_t     y;           /* Mouse Y coordinate */
    bool        left_button; /* Mouse left button state */
} usbhid_mouse_indev_t;

typedef struct usbhid_keyboard_indev {
    lv_indev_t* indev; /* LVGL keyboard input device driver.*/
    uint32_t    last_key;
    bool        pressed;
} usbhid_keyboard_indev_t;

extern usbhid_mouse_indev_t    mouse_indev;
extern usbhid_keyboard_indev_t kb_indev;

/**********************
 * GLOBAL PROTOTYPES
 **********************/
extern lv_display_t*        lcd_disp;
extern struct usbh_hid_lvgl hid_indev;

/* Initialize low level display driver */
void lv_port_disp_init(void);

/**********************
 *      MACROS
 **********************/

#ifdef __cplusplus
} /*extern "C"*/
#endif

#endif /*LV_PORT_LCD_STM32_TEMPL_H*/

#endif /*Disable/Enable content*/
