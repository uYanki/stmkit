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

    CUR_U_Q15,  // CurU
    CUR_V_Q15,  // CurV
    CUR_W_Q15,  // CurW

    U_MAIN_DC_Q15,  // 动力线母线电压 Umdc
    U_CTRL_DC_Q15,  // 控制电电压 Ucdc

    U_TEMP_INVT_Q15,

    U_AI0_Q15,
    U_AI1_Q15,
    U_AI2_Q15,

} ad_ind_e;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

s16 AdcGet(ad_ind_e eIndex);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_ADC_H__
