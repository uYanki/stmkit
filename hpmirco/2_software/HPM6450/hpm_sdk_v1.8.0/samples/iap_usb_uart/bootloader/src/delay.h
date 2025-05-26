#ifndef __DELAY_H
#define __DELAY_H

#include "stdbool.h"
#include "stdint.h"

// 1ms based timer, max to 2^32 ms delay.
extern uint32_t u32_GetTick(void);
extern bool     E_DelayNonBlock(uint32_t u32TickStart, uint32_t u32T);

#endif
