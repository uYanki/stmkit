#include "delay.h"

extern volatile uint32_t u32SysTick1ms;

uint32_t u32_GetTick(void)
{
    return u32SysTick1ms;
}

bool E_DelayNonBlock(uint32_t u32TickStart, uint32_t u32T)
{
    if ((u32_GetTick() - u32TickStart) < u32T)
    {
        return false;
    }
    else
    {
        return true;
    }
}
