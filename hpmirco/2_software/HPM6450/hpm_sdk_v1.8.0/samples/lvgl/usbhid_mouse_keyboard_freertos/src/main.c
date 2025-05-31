/*
 * Copyright (c) 2022 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

/* FreeRTOS kernel includes. */
#include "FreeRTOS.h"
#include "task.h"

/*  HPM example includes. */
#include <stdio.h>
#include "board.h"
#include "usbh_core.h"
#include "lv_port_disp.h"

static void lvgl_mouse_keyboard_demo(lv_indev_t* indev)
{
    lv_obj_t* ta = NULL;

    lv_group_t* group = lv_group_create();  // 创建输入组
    lv_indev_set_group(indev, group);       // 绑定键盘输入设备到组

    // 编辑框1
    ta = lv_textarea_create(lv_scr_act());
    lv_textarea_set_one_line(ta, true);  // 单行模式
    lv_obj_set_size(ta, 200, 50);
    lv_obj_align(ta, LV_ALIGN_CENTER, 0, -30);  // 居中偏上对齐
    lv_group_add_obj(group, ta);                // 添加文本框到输入组

    // 编辑框2
    ta = lv_textarea_create(lv_scr_act());
    lv_textarea_set_one_line(ta, true);  // 单行模式
    lv_obj_set_size(ta, 200, 50);
    lv_obj_align(ta, LV_ALIGN_BOTTOM_MID, 0, -30);  // 居中偏上对齐
    lv_group_add_obj(group, ta);                    // 添加文本框到输入组
}

static void lvgl_task(void* pvParameters)
{
    (void)pvParameters;
    uint32_t delay;

    lv_init();
    lv_port_disp_init();

    lvgl_mouse_keyboard_demo(kb_indev.indev);

    while (1)
    {
        delay = lv_timer_handler();
        vTaskDelay(delay);
    }
}
 
int main(void)
{
    board_init();

    HPM_IOC->PAD[IOC_PAD_PF10].FUNC_CTL = IOC_PF10_FUNC_CTL_USB0_ID;
    HPM_IOC->PAD[IOC_PAD_PF08].FUNC_CTL = IOC_PF08_FUNC_CTL_USB0_OC;
    clock_add_to_group(clock_usb0, 0);
    intc_set_irq_priority(CONFIG_HPM_USBH_IRQn, 1);
    usbh_initialize(0, CONFIG_HPM_USBH_BASE);

    if (xTaskCreate(lvgl_task, "lvgl", 2048, NULL, 5, NULL) != pdPASS)
    {
        printf("Task creation failed!.\n");
        for (;;)
        {
        }
    }

    vTaskStartScheduler();

    while (1);

    return 0;
}