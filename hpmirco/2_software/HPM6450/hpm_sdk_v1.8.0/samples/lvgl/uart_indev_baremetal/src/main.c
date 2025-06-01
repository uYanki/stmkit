/*
 * Copyright (c) 2024 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

#include <stdio.h>
#include "board.h"
#include "hpm_debug_console.h"
#include "hpm_clock_drv.h"

#include "lv_port_disp.h"
#include "demos/lv_demos.h"

int main(void)
{
    board_init();

    lv_init();
    lv_port_disp_init();
    lv_demo_benchmark();
    printf("hello lvgl9\r");

    while (1) {
        lv_timer_periodic_handler();
    }

    return 0;
}
