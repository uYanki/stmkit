#include "analog.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "analog"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void AnalogCreat(analog_t* pAnalog)
{
    pAnalog->pDevicePara = &D;
}

void AnalogInit(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;
}

#if CONFIG_TEMP_SAMP_NUM > 0
void AnalogTempSamp(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

    // ????
#if CONFIG_TEMP_MCU_SAMP_SW
    pDevicePara->u16TempMcuPu = (s32)AdcGet(U_TEMP_MCU_Q12);
#endif
}

void AnalogTempSi(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

#if CONFIG_TEMP_MCU_SAMP_SW
    pDevicePara->s16TempMcuSi = pDevicePara->u16TempMcuPu * CONFIG_TEMP_MCU_ZOOM / 1000 - CONFIG_TEMP_MCU_OFFSET;
#endif
}

#endif
#if CONFIG_EXT_AI_NUM > 0

void AnalogUaiSamp(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

#if CONFIG_EXT_AI_NUM > 0
    pDevicePara->s16Uai0Pu = (s32)(AdcGet(U_AI0_Q15)) * (s32)pDevicePara->u16Uai0Zoom / 1000 + (s32)pDevicePara->s16Uai0Offset;
#endif

#if CONFIG_EXT_AI_NUM > 1
    pDevicePara->s16Uai1Pu = (s32)(AdcGet(U_AI1_Q15)) * (s32)pDevicePara->u16Uai1Zoom / 1000 + (s32)pDevicePara->s16Uai1Offset;
#endif

#if CONFIG_EXT_AI_NUM > 2
    pDevicePara->s16Uai2Pu = (s32)(AdcGet(U_AI2_Q15)) * (s32)pDevicePara->u16Uai2Zoom / 1000 + (s32)pDevicePara->s16Uai2Offset;
#endif

#if CONFIG_EXT_AI_NUM > 3
    pDevicePara->s16Uai3Pu = (s32)(AdcGet(U_AI3_Q15)) * (s32)pDevicePara->u16Uai3Zoom / 1000 + (s32)pDevicePara->s16Uai3Offset;
#endif
}

void AnalogUaiSi(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

#if CONFIG_EXT_AI_NUM > 0

    if (INOPEN(pDevicePara->s16Uai0Pu, -(s16)pDevicePara->u16Uai0DeadZone, +(s16)pDevicePara->u16Uai0DeadZone))
    {
        pDevicePara->s16Uai0Si = 0;
    }
    else
    {
        pDevicePara->s16Uai0Si = (s16)((s32)pDevicePara->s16Uai0Pu * (s32)pDevicePara->u16UaiHwCoeff / 32768);
    }

#endif

#if CONFIG_EXT_AI_NUM > 1

    if (INOPEN(pDevicePara->s16Uai1Pu, -(s16)pDevicePara->u16Uai1DeadZone, +(s16)pDevicePara->u16Uai1DeadZone))
    {
        pDevicePara->s16Uai1Si = 0;
    }
    else
    {
        pDevicePara->s16Uai1Si = (s16)((s32)pDevicePara->s16Uai1Pu * (s32)pDevicePara->u16UaiHwCoeff / 32768);
    }

#endif

#if CONFIG_EXT_AI_NUM > 2

    if (INOPEN(pDevicePara->s16Uai2Pu, -(s16)pDevicePara->u16Uai2DeadZone, +(s16)pDevicePara->u16Uai2DeadZone))
    {
        pDevicePara->s16Uai2Si = 0;
    }
    else
    {
        pDevicePara->s16Uai2Si = (s16)((s32)pDevicePara->s16Uai2Pu * (s32)pDevicePara->u16UaiHwCoeff / 32768);
    }

#endif

#if CONFIG_EXT_AI_NUM > 2

    if (INOPEN(pDevicePara->s16Uai3Pu, -(s16)pDevicePara->u16Uai3DeadZone, +(s16)pDevicePara->u16Uai3DeadZone))
    {
        pDevicePara->s16Uai3Si = 0;
    }
    else
    {
        pDevicePara->s16Uai3Si = (s16)((s32)pDevicePara->s16Uai3Pu * (s32)pDevicePara->u16UaiHwCoeff / 32768);
    }

#endif
}

#endif
