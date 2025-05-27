/*
 * Copyright (c) 2021 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

#include <stdio.h>
#include "board.h"
#include "hpm_debug_console.h"

#include "hpm_gpio_drv.h"

#define LED_PIN HPM_GPIO0, GPIO_DI_GPIOB, 4

void led_init(void)
{
    HPM_IOC->PAD[IOC_PAD_PB04].FUNC_CTL = IOC_PB04_FUNC_CTL_GPIO_B_04;

    gpio_set_pin_output(LED_PIN);
}

int main(void)
{
    board_init_clock();
    board_init_console();
    board_init_pmp();

    led_init();

    while (1)
    {
        board_delay_ms(1000);
        printf("hello world\n");
        gpio_toggle_pin(LED_PIN);
   
    }

    return 0;
}
