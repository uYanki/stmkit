#include "bsp_adc.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_adc"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

extern __IO u16 ADConv[6];

#define AD_CUR_C (ADConv[0])
#define AD_CUR_A (ADConv[1])
#define AD_NTC   (ADConv[2])
#define AD_VBUS  (ADConv[3])
#define AD_POT1  (ADConv[4])
#define AD_POT2  (ADConv[5])

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

s16 AdcGet(ad_ind_e eIndex)
{
    switch (eIndex)
    {
#if 1  // 片内ADC采样

        case CUR_U_Q15:
        {
            // 13405 是对应运放的 1.35V 偏置电压
            return (s16)(AD_CUR_A << 4) - 0x8000;
        }
        case CUR_V_Q15:
        {
            // return (s16)(adc1_ordinary_valuetab[2] << 4) - 0x8000;
            return 0;
        }
        case CUR_W_Q15:
        {
            return (s16)(AD_CUR_C << 4) - 0x8000;
        }

#else  // 调制器采样

        case CUR_U_Q15:
        {
            return (s16)(adc1_ordinary_valuetab[1]);
        }
        case CUR_V_Q15:
        {
            return (s16)(adc1_ordinary_valuetab[2]);
        }
        case CUR_W_Q15:
        {
            return (s16)(adc1_ordinary_valuetab[3]);
        }

#endif

        case U_MAIN_DC_Q15:
        case U_CTRL_DC_Q15:
        {
            return (s16)(AD_VBUS << 3);
        }

        case U_TEMP_INVT_Q15:
        {
            return AD_NTC;
        }

        case U_AI0_Q15:
        {
            return AD_POT1;
        }
        case U_AI1_Q15:
        {
            return AD_POT2;
        }
        case U_AI2_Q15:
        {
            break;
        }

        default:
        {
            break;
        }
    }

    return 0;
}
