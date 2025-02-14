#ifndef __BSP_ADC_H__
#define __BSP_ADC_H__

#include "common.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef enum {

    U_AI0_Q15,
    U_AI1_Q15,
    U_AI2_Q15,
    U_AI3_Q15,

    U_TEMP_MCU_Q12,  // TempSensor

} adc_src_e;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

s16 AdcGet(adc_src_e eIndex);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_ADC_H__
