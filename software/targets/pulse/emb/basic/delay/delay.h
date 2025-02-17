#ifndef __DELAY_H__
#define __DELAY_H__

#include "common.h"
#include "tim/bsp_tim.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define PeriodicTask100ns(u16TickWait, CodeBlock)         \
    {                                                     \
        static u16 u16LastTick = 0;                       \
        if (DelayNonBlock100ns(u16LastTick, u16TickWait)) \
        {                                                 \
            LastTick = GetTick100ns();                    \
            CodeBlock;                                    \
        }                                                 \
    }

#define PeriodicTaskMs(u32TickWait, CodeBlock)         \
    {                                                  \
        static u32 u32LastTick = 0;                    \
        if (DelayNonBlockMs(u32LastTick, u32TickWait)) \
        {                                              \
            u32LastTick = GetTickMs();                 \
            CodeBlock;                                 \
        }                                              \
    }

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

// unit: 0.1us => max delay 6553.5ms
void DelayBlock100ns(u16 u16TickWait);
bool DelayNonBlock100ns(u16 u16TickStart, u16 u16TickWait);

void DelayBlockMs(u32 u32TickWait);
bool DelayNonBlockMs(u32 u32TickStart, u32 u32TickWait);

#ifdef __cplusplus
}
#endif

#endif /* __DELAY_H__ */
