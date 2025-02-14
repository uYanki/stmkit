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

analog_t Analog = {0};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void AnalogCreat(analog_t* pAnalog)
{
    pAnalog->pDevicePara = &D;
}

void AnalogInit(analog_t* pAnalog)
{
    // device_para_t* pDevicePara = pAnalog->pDevicePara;
}

void AnalogUmdcSamp(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

    pDevicePara->u16UmdcPu = (s32)AdcGet(U_MAIN_DC_Q15) * (s32)pDevicePara->u16UmdcZoom / 1000 + (s32)pDevicePara->s16UmdcOffset;

    pAnalog->u16UmdcLpfPu = pDevicePara->u16UmdcPu;  // TODO: low pass filter
}

void AnalogUmdcSi(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

    pDevicePara->u16UmdcSi = (u16)(((s32)(pDevicePara->u16UmdcHwCoeff) * (s32)(pAnalog->u16UmdcLpfPu)) >> 15);
}

#if CONFIG_UCDC_SAMP_SW

void AnalogUcdcSamp(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

    pDevicePara->u16UcdcPu = (s32)AdcGet(U_CTRL_DC_Q15) * (s32)pDevicePara->u16UcdcZoom / 1000 + (s32)pDevicePara->s16UcdcOffset;

    pAnalog->u16UcdcLpfPu = pDevicePara->u16UcdcPu;  // TODO: low pass filter
}

void AnalogUcdcSi(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

    pDevicePara->u16UcdcSi = (u16)(((u32)(pDevicePara->u16UcdcHwCoeff) * (u32)(pAnalog->u16UcdcLpfPu)) >> 15);
}

#endif

#if CONFIG_TEMP_SAMP_NUM > 0

static u16 NTC_GetTempSi(u16 adconv)  // unit: 0.1℃
{
    int ntc_resistance = 1000 * adconv / (4096 - adconv);

    // B = 3380K, 10k , from 0 degree to 100 degree, table, the step is 5 degree
    static RO u16 tbl[] = {2749, 2218, 1802, 1472, 1210, 1000, 831, 694, 583, 491, 416, 354, 302, 259, 223, 193, 167, 146, 127, 111, 98};

    u16 min = 0, max = sizeof(tbl) / 2 - 1, mid;  // index

    if (ntc_resistance > tbl[min])
    {
        return 100.f;
    }
    else if (ntc_resistance < tbl[max])
    {
        return 0.f;
    }

    while ((max - min) > 1)  // 二分法
    {
        mid = (max + min) >> 1;
        (tbl[mid] < ntc_resistance) ? (max = mid) : (min = mid);
    }

    return 50 * min + 50 * (tbl[min] - ntc_resistance) / (tbl[min] - tbl[min + 1]);
}

void AnalogTempSamp(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

    // 逆变模块
#if CONFIG_TEMP_INVT_SAMP_SW
    pDevicePara->s16TempInvtPu = (s32)AdcGet(U_TEMP_INVT_Q15) * (s32)pDevicePara->u16TempInvtZoom / 1000 + (s32)pDevicePara->s16TempInvtOffset;
#endif

    // 整流模块
#if CONFIG_TEMP_RECT_SAMP_SW
    pDevicePara->s16TempRectPu = 0;
#endif
}

void AnalogTempSi(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

    // 二分法查表
#if CONFIG_TEMP_INVT_SAMP_SW
    pDevicePara->s16TempInvtSi = NTC_GetTempSi(pDevicePara->s16TempInvtPu);
#endif
#if CONFIG_TEMP_RECT_SAMP_SW
#endif
}

#endif

#if CONFIG_EXT_AI_NUM > 0

void AnalogUaiSamp(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

#if CONFIG_EXT_AI_NUM > 0
    pDevicePara->s16UaiPu0 = (s32)(AdcGet(U_AI0_Q15)) * (s32)pDevicePara->u16Uai0Zoom / 1000 + (s32)pDevicePara->s16Uai0Offset - 16384;
#endif

#if CONFIG_EXT_AI_NUM > 1
    pDevicePara->s16UaiPu1 = (s32)(AdcGet(U_AI1_Q15)) * (s32)pDevicePara->u16Uai1Zoom / 1000 + (s32)pDevicePara->s16Uai1Offset - 16384;
#endif

#if CONFIG_EXT_AI_NUM > 2
    pDevicePara->s16UaiPu2 = (s32)(AdcGet(U_AI2_Q15)) * (s32)pDevicePara->u16Uai2Zoom / 1000 + (s32)pDevicePara->s16Uai2Offset - 16384;
#endif
}

void AnalogUaiSi(analog_t* pAnalog)
{
    device_para_t* pDevicePara = pAnalog->pDevicePara;

#if CONFIG_EXT_AI_NUM > 0

    if (INOPEN(pDevicePara->s16UaiPu0, -(s16)pDevicePara->u16Uai0DeadZone, +(s16)pDevicePara->u16Uai0DeadZone))
    {
        pDevicePara->s16UaiSi0 = 0;
    }
    else
    {
        pDevicePara->s16UaiSi0 = (s16)((s32)pDevicePara->s16UaiPu0 * (s32)pDevicePara->u16Uai0HwCoeff / 16384);
    }

#endif

#if CONFIG_EXT_AI_NUM > 1

    if (INOPEN(pDevicePara->s16UaiPu1, -(s16)pDevicePara->u16Uai1DeadZone, +(s16)pDevicePara->u16Uai1DeadZone))
    {
        pDevicePara->s16UaiSi1 = 0;
    }
    else
    {
        pDevicePara->s16UaiSi1 = (s16)((s32)pDevicePara->s16UaiPu1 * (s32)pDevicePara->u16Uai1HwCoeff / 16384);
    }

#endif

#if CONFIG_EXT_AI_NUM > 2

    if (INOPEN(pDevicePara->s16UaiPu2, -(s16)pDevicePara->u16Uai2DeadZone, +(s16)pDevicePara->u16Uai2DeadZone))
    {
        pDevicePara->s16UaiSi2 = 0;
    }
    else
    {
        pDevicePara->s16UaiSi2 = (s16)((s32)pDevicePara->s16UaiPu2 * (s32)pDevicePara->u16Uai2HwCoeff / 16384);
    }

#endif
}

#endif
