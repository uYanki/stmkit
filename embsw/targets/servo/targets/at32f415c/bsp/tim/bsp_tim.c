#include "bsp_tim.h"
#include "delay.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_tim"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static u32 su32SysTickMs = 0;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

//
// TIM
//

void IncTickMs(void)
{
    ++su32SysTickMs;
}

u32 GetTick100ns(void)
{
    return su32SysTickMs * 10000 + tmr_counter_value_get(TIM_SYSTICK_BASE) * 10 / 36;
}

u32 GetTickUs(void)
{
    return GetTick100ns() / 10;
}

u32 GetTickMs(void)
{
    return su32SysTickMs;
}

//
// PWM
//

void PwmDuty(u16 u16DutyA, u16 u16DutyB, u16 u16DutyC)
{
    // PWM1:
    // DIR=0 (向上计数), TMRx_CNT<TMRx_CCx 时, OCxREF = 1.  TMRx_CNT>=TMRx_CCx 时, OCxREF = 0.
    // DIR=1 (向下计数), TMRx_CNT>TMRx_CCx 时, OCxREF = 0.  TMRx_CNT<=TMRx_CCx 时, OCxREF = 1.

    /**
     *
     *       CNT
     *    RLD |         /|\
     *        |        / | \
     *    CCx +       /  |  \
     *        |   \  /|  |  |\  /
     *        |    \/ |  |  | \/
     *        +------------------> OCxREF
     *               1  0  0  1
     *
     */

    tmr_channel_value_set(TIM_SCANA_BASE, TMR_SELECT_CHANNEL_1, u16DutyA);
    tmr_channel_value_set(TIM_SCANA_BASE, TMR_SELECT_CHANNEL_2, u16DutyB);
    tmr_channel_value_set(TIM_SCANA_BASE, TMR_SELECT_CHANNEL_3, u16DutyC);
}

bool PwrBootstrap(bool bBootSw, u16 u16AxisInd)
{
    if (bBootSw)
    {
        tmr_output_enable(TIM_SCANA_BASE, TRUE);
    }
    else
    {
        tmr_output_enable(TIM_SCANA_BASE, FALSE);
    }

    return bBootSw;
}

bool PwmGen(bool bPwmSw, u16 u16AxisInd)
{
    static bool sbPwmSts[CONFIG_AXIS_NUM] = {false};

    if (sbPwmSts[u16AxisInd] != bPwmSw)
    {
        sbPwmSts[u16AxisInd] = PwrBootstrap(bPwmSw, u16AxisInd);
    }

    return sbPwmSts[u16AxisInd];
}
