#include "pulse.h"
#include "bsp.h"
#include "delay.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "Pulse"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

static void PulInCycle(pulse_t* pPulse);
static void PulInIsr(pulse_t* pPulse);

static void PulOutCycle(pulse_t* pPulse);

static void FlexPulOutCycle(pulse_t* pPulse);

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void PulseCreat(pulse_t* pPulse)
{
    pPulse->pDevicePara = &D;
}

void PulseInit(pulse_t* pPulse)
{
    pPulse->bPulOutEn = false;
    pPulse->bPulInEn  = false;

    pPulse->pDevicePara->u16PulInMode = 1;
    pPulse->pDevicePara->bPulInEn     = 1;
}

void PulseCycle(pulse_t* pPulse)
{
    PulInCycle(pPulse);
    PulOutCycle(pPulse);
    FlexPulOutCycle(pPulse);
}

void PulseIsr(pulse_t* pPulse)
{
    PulInIsr(pPulse);
}

static void PulInCycle(pulse_t* pPulse)
{
    device_para_t* pDevicePara = pPulse->pDevicePara;

    if (pPulse->bPulInEn != pDevicePara->bPulInEn)
    {
        pPulse->bPulInEn = pDevicePara->bPulInEn ? true : false;

        if (pPulse->bPulInEn)
        {
            PulInConfig(pDevicePara->u16PulInMode);
            PulInRstCnt();
            PulInEnable();
        }
        else
        {
            pDevicePara->s64PulInCnt = 0;
            pDevicePara->s32EncTurns = 0;
            pDevicePara->u32EncPos   = 0;
            PulInDisable();
        }
    }
}

static void PulInIsr(pulse_t* pPulse)
{
    device_para_t* pDevicePara = pPulse->pDevicePara;

    if (pPulse->bPulInEn)
    {
        // 读取后立即清除计数
        s32 s32TmrCnt = PulInGetCnt();
        PulInRstCnt();
        pDevicePara->s64PulInCnt += s32TmrCnt;

        s64 s64EncPos = pDevicePara->s64PulInCnt;
        s64 s64EncRes = (s64)pDevicePara->u32EncRes;

        pDevicePara->s32EncTurns = s64EncPos / s64EncRes;
        pDevicePara->u32EncPos   = (s64EncPos % s64EncRes) + (s64EncPos < 0 ? s64EncRes : 0);
    }
}

static void PulOutCycle(pulse_t* pPulse)
{
    device_para_t* pDevicePara = pPulse->pDevicePara;

    if (pPulse->bPulOutEn != pDevicePara->bPulOutEn)
    {
        pPulse->bPulOutEn = pDevicePara->bPulOutEn ? true : false;

        if (pPulse->bPulOutEn)
        {
            PulOutConfig(pDevicePara->u32PulOutCnt, pDevicePara->u32PulOutFreq, pDevicePara->u16PulOutDuty);
            PulOutEnable();
        }
        else
        {
            PulOutDisable();
        }
    }
    else if (pPulse->bPulOutEn)
    {
        if (PulOutIsOver())
        {
            pDevicePara->bPulOutEn = false;
            pPulse->bPulOutEn      = false;
        }
    }
}

static void FlexPulOutCycle(pulse_t* pPulse)
{
    device_para_t* pDevicePara = pPulse->pDevicePara;

    if (pPulse->bFlexPulOutEn != pDevicePara->bFlexPulOutEn)
    {
        pPulse->bFlexPulOutEn = pDevicePara->bFlexPulOutEn ? true : false;

        if (pPulse->bFlexPulOutEn)
        {
            FlexPulOutConfig(pDevicePara->u32FlexPulOutFreq,
                             (u16*)&pDevicePara->u16FlexPulData00 + pDevicePara->u16FlexPulStartIndex,
                             pDevicePara->u16FlexPulStopIndex - pDevicePara->u16FlexPulStartIndex + 1);
            FlexPulOutEnable();
        }
        else
        {
            FlexPulOutDisable();
        }
    }
    else if (pPulse->bFlexPulOutEn)
    {
    }
}
