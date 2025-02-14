#include "hrtim.h"
#include "paratbl.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "hrtim"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static u16 au16EventTickStart[__EVENT_COUNT] = {0};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void StartEventRecorder(EventID_e eEventID)
{
    au16EventTickStart[eEventID] = GetTick100ns();
}

void StopEventRecorder(EventID_e eEventID)
{
    (&D.u16CycleScanTime)[eEventID] = GetTick100ns() - au16EventTickStart[eEventID];
}
