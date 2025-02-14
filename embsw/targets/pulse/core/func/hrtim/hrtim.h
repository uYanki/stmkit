#ifndef __HRTIM_H__  // high resolution timer
#define __HRTIM_H__

#include "delay.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef enum {
    EVENT_CYCLE_SCAN,
    EVENT_ISR_SCAN,
    EVENT_CUSTOM_TIME0,
    EVENT_CUSTOM_TIME1,
    __EVENT_COUNT,
} EventID_e;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void StartEventRecorder(EventID_e eEventId);
void StopEventRecorder(EventID_e eEventId);

#ifdef __cplusplus
}
#endif

#endif /* __HRTIM_H__ */
