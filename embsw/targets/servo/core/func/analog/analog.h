#ifndef __ANALOG_H__
#define __ANALOG_H__

#include "paratbl.h"
#include "bsp.h"
#include "lpf.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef struct {
    device_para_t* pDevicePara;

    //
    // 主电
    //
    u16 u16UmdcLpfPu;

    //
    // 控制电
    //
#if CONFIG_UCDC_SAMP_SW
    u16 u16UcdcLpfPu;
#endif

    //
    // 模拟量输入
    //
#if CONFIG_EXT_AI_NUM > 0

#endif

    //
    // 温度采样
    //
#if CONFIG_TEMP_SAMP_NUM > 0

#endif

} analog_t;

extern analog_t Analog;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void AnalogCreat(analog_t* pAnalog);
void AnalogInit(analog_t* pAnalog);

void AnalogUmdcSamp(analog_t* pAnalog);
void AnalogUmdcSi(analog_t* pAnalog);

void AnalogUcdcSamp(analog_t* pAnalog);
void AnalogUcdcSi(analog_t* pAnalog);

void AnalogTempSamp(analog_t* pAnalog);
void AnalogTempSi(analog_t* pAnalog);

void AnalogUaiSamp(analog_t* pAnalog);
void AnalogUaiSi(analog_t* pAnalog);

#ifdef __cplusplus
}
#endif

#endif
