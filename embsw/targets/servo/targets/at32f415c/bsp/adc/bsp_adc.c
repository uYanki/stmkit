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

extern __IO u16 au16AdcSampBuff[2];

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
            return (s16)(au16AdcSampBuff[0] << 4) - 0x8000;
        }
        case CUR_V_Q15:
        {
            return (s16)(au16AdcSampBuff[1] << 4) - 0x8000;
        }
        case CUR_W_Q15:
        {
            return 0;
        }

#else  // 调制器采样

        case CUR_U_Q15:
        {
            return (s16)(au16AdcSampBuff[1]);
        }
        case CUR_V_Q15:
        {
            return (s16)(au16AdcSampBuff[2]);
        }
        case CUR_W_Q15:
        {
            return (s16)(au16AdcSampBuff[3]);
        }

#endif

        case U_MAIN_DC_Q15:
        case U_CTRL_DC_Q15:
        {
            return 1354<<3;
        }

        case U_TEMP_INVT_Q15:

        case U_AI0_Q15:
        case U_AI1_Q15:
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
