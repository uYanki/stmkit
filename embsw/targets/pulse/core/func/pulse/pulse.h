#ifndef __PULSE_H__
#define __PULSE_H__

#include "paratbl.h"
#include "bsp.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef struct {
    device_para_t* pDevicePara;

    bool bPulOutEn;
    bool bPulInEn;
    bool bFlexPulOutEn;
} pulse_t;

extern pulse_t Pulse;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void PulseCreat(pulse_t* pPulse);
void PulseInit(pulse_t* pPulse);
void PulseCycle(pulse_t* pPulse);
void PulseIsr(pulse_t* pPulse);

#ifdef __cplusplus
}
#endif

#endif
