#include "board.h"
#include "cdc_acm.h"
#include "slcan.h"

int main(void)
{
    board_init_clock();
    board_init_console();
    board_init_pmp();

    cdc_acm_init(USB_BUS_ID, CONFIG_HPM_USBD_BASE);
    slcan_init();

    while (1)
    {
#if SLCAN_NUM > 0
        slcan_process_task(&slcan[0]);
#endif
#if SLCAN_NUM > 1
        slcan_process_task(&slcan[1]);
#endif
#if SLCAN_NUM > 2
        slcan_process_task(&slcan[2]);
#endif
#if SLCAN_NUM > 3
        slcan_process_task(&slcan[3]);
#endif
    }
    return 0;
}
