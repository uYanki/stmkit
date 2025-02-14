#include "bsp_tim.h"
#include "delay.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_tim"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO
#define BOOTSTRAP_INIT  0  // 自举充电.准备
#define BOOTSTRAP_DOING 1  // 自举充电.进行中
#define BOOTSTRAP_DONE  2  // 自举充电.完成


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
    return su32SysTickMs * 10000 + tmr_counter_value_get(TIM_BASE);
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

    tmr_channel_value_set(TIM_SCAN_A, TMR_SELECT_CHANNEL_1, u16DutyA);
    tmr_channel_value_set(TIM_SCAN_A, TMR_SELECT_CHANNEL_2, u16DutyB);
    tmr_channel_value_set(TIM_SCAN_A, TMR_SELECT_CHANNEL_3, u16DutyC);
}

bool PwrBootstrap(bool bBootSw, u16 u16AxisInd)
{
    static u16 su16BootSts = BOOTSTRAP_INIT;
    static u16 su16BootCnt = 0;

    if (bBootSw)
    {
        if (su16BootSts == BOOTSTRAP_INIT)
        {
            PwmDuty(0, 0, 0);

            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1, FALSE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2, FALSE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3, FALSE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1C, FALSE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2C, FALSE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3C, FALSE);
            tmr_output_enable(TIM_SCAN_A, TRUE);

            su16BootCnt = 0;
            su16BootSts = BOOTSTRAP_DOING;
        }
        else  // 自举充电中
        {
#if 1

            // 下桥交替打开

            u8 i = su16BootCnt % 3;

            if (i == 0)  // U
            {
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1C, TRUE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2C, FALSE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3C, FALSE);
            }
            else if (i == 1)  // V
            {
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1C, FALSE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2C, TRUE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3C, FALSE);
            }
            else if (i == 2)  // W
            {
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1C, FALSE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2C, FALSE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3C, TRUE);
            }

#else

            // 下桥绕组短接

            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1, FALSE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2, FALSE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3, FALSE);

            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1C, TRUE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2C, TRUE);
            tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3C, TRUE);

#endif

            if (su16BootCnt < 1)
            {
                PeriodicTask(UNIT_MS, su16BootCnt++);
            }
            else
            {
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1, TRUE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1C, TRUE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2, TRUE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2C, TRUE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3, TRUE);
                tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3C, TRUE);

                su16BootSts = BOOTSTRAP_DONE;  // 自举充电完成
            }
        }
    }
    else
    {
			
        tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1, FALSE);
        tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2, FALSE);
        tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3, FALSE);
        tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_1C, FALSE);
        tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_2C, FALSE);
        tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_3C, FALSE);
        tmr_output_enable(TIM_SCAN_A, FALSE);

        su16BootSts = BOOTSTRAP_INIT;
    }

    if (su16BootSts == BOOTSTRAP_DONE)
    {
        return true;
    }
    else
    {
        return false;
    }
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
