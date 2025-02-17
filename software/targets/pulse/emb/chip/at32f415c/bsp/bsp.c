#include "bsp.h"

void SystemSoftReset(void)
{
    __NVIC_SystemReset();

    while (1)
    {
    }
}
