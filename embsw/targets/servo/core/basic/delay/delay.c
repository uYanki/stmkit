#include "delay.h"
#include "paratbl.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static tick_t aEventTickStart[__EVENT_COUNT] = {0};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void DelayBlock(tick_t TickWait)
{
    tick_t TickEnd;

    if (TickWait == 0)
    {
        return;
    }

    TickEnd = GetTickUs() + TickWait;

    while (GetTickUs() < TickEnd)
    {
    }
}

bool DelayNonBlock(tick_t TickStart, tick_t TickWait)
{
    tick_t TickEnd = TickStart + TickWait;

    if (GetTickUs() < TickEnd)
    {
        return false;  // waiting
    }
    else
    {
        return true;  // time is up
    }
}

void StartEventRecorder(event_id_t eEventId)
{
    aEventTickStart[eEventId] = GetTick100ns();
}

void StopEventRecorder(event_id_t eEventId)
{
    (&D.u16CycleScanTime)[eEventId] = GetTick100ns() - aEventTickStart[eEventId];
}
