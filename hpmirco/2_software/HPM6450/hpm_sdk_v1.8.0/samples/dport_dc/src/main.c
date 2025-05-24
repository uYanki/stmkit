

#include <stdio.h>
#include "board.h"
#include "hpm_debug_console.h"

#include "hpm_dport.h"

#include "hpm_gpio_drv.h"

#define LED_PIN HPM_GPIO0, GPIO_DI_GPIOB, 4

void led_init(void)
{
    HPM_IOC->PAD[IOC_PAD_PB04].FUNC_CTL = IOC_PB04_FUNC_CTL_GPIO_B_04;

    gpio_set_pin_output(LED_PIN);
}

void led_toggle(void)
{
    gpio_toggle_pin(LED_PIN);
}

void led_set(uint8_t n)
{
    gpio_write_pin(LED_PIN, n ? 1 : 0);
}

int main(void)
{
    board_init_clock();
    board_init_console();
    board_init_pmp();
#if BOARD_SHOW_CLOCK
    board_print_clock_freq();
#endif

    led_init();

    dport_init();
    dport_esc_init();
    dport_start();

    printf("coe run\n");

    while (1)
    {
        dport_esc_cycle();
    }

    return 0;
}
