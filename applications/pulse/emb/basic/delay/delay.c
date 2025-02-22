#include "delay.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void DelayBlock100ns(u16 u16TickWait)
{
    u16 u16TickNow = GetTick100ns();

    while ((GetTick100ns() - u16TickNow) < u16TickWait)
    {
    }
}

bool DelayNonBlock100ns(u16 u16TickStart, u16 u16TickWait)
{
    u16 u16TickNow = GetTick100ns();

    if (u16TickNow < u16TickStart)
    {
        u16TickNow += U16_MAX - u16TickStart;
    }
    else
    {
        u16TickNow -= u16TickStart;
    }

    if (u16TickNow < u16TickWait)
    {
        return false;  // waiting
    }
    else
    {
        return true;  // time is up
    }
}

void DelayBlockMs(u32 u32TickWait)
{
    u32 u32TickNow = GetTickMs();

    while ((GetTickMs() - u32TickNow) < u32TickWait)
    {
    }
}

bool DelayNonBlockMs(u32 u32TickStart, u32 u32TickWait)
{
    if ((GetTickMs() - u32TickStart) < u32TickWait)
    {
        return false;  // waiting
    }
    else
    {
        return true;  // time is up
    }
}
