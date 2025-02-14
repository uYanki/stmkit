#include "bsp_tim.h"
#include "delay.h"
#include "tim.h"

#define BOOTSTRAP_INIT  0  // 自举充电.准备
#define BOOTSTRAP_DOING 1  // 自举充电.进行中
#define BOOTSTRAP_DONE  2  // 自举充电.完成

#define BOOTSTRAP_TIMES 1

#define PWM_CH_UH       0
#define PWM_CH_UL       1
#define PWM_CH_VH       2
#define PWM_CH_VL       3
#define PWM_CH_WH       4
#define PWM_CH_WL       5

//
// TIM
//

static u32 su32SysTickMs = 0;

void IncTickMs(void)
{
    ++su32SysTickMs;
}

u32 GetTick100ns(void)
{
    return su32SysTickMs * 10000 + TIM_BASE->Instance->CNT * 16 / 10;
}

u32 GetTickUs(void)
{
    return GetTick100ns() / 10;
}

u32 GetTickMs(void)
{
    return su32SysTickMs;
}

void $Sub$$HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef* htim)
{
    extern void $Super$$HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef * htim);

    if (htim == TIM_BASE)  // period = 1ms
    {
        IncTickMs();
    }

    $Super$$HAL_TIM_PeriodElapsedCallback(htim);
}

//
// PWM
//

static void PwmOpen(u8 u8PwmCh)
{
    switch (u8PwmCh)
    {
        case PWM_CH_UH: HAL_TIM_PWM_Start(TIM_SCAN_A, TIM_CHANNEL_1); break;
        case PWM_CH_UL: HAL_TIMEx_PWMN_Start(TIM_SCAN_A, TIM_CHANNEL_1); break;
        case PWM_CH_VH: HAL_TIM_PWM_Start(TIM_SCAN_A, TIM_CHANNEL_2); break;
        case PWM_CH_VL: HAL_TIMEx_PWMN_Start(TIM_SCAN_A, TIM_CHANNEL_2); break;
        case PWM_CH_WH: HAL_TIM_PWM_Start(TIM_SCAN_A, TIM_CHANNEL_3); break;
        case PWM_CH_WL: HAL_TIMEx_PWMN_Start(TIM_SCAN_A, TIM_CHANNEL_3); break;
        default: break;
    }
}

static void PwmClose(u8 u8PwmCh)
{
    switch (u8PwmCh)
    {
        case PWM_CH_UH: HAL_TIM_PWM_Stop(TIM_SCAN_A, TIM_CHANNEL_1); break;
        case PWM_CH_UL: HAL_TIMEx_PWMN_Stop(TIM_SCAN_A, TIM_CHANNEL_1); break;
        case PWM_CH_VH: HAL_TIM_PWM_Stop(TIM_SCAN_A, TIM_CHANNEL_2); break;
        case PWM_CH_VL: HAL_TIMEx_PWMN_Stop(TIM_SCAN_A, TIM_CHANNEL_2); break;
        case PWM_CH_WH: HAL_TIM_PWM_Stop(TIM_SCAN_A, TIM_CHANNEL_3); break;
        case PWM_CH_WL: HAL_TIMEx_PWMN_Stop(TIM_SCAN_A, TIM_CHANNEL_3); break;
        default: break;
    }
}

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

    __HAL_TIM_SetCompare(TIM_SCAN_A, TIM_CHANNEL_1, u16DutyA);
    __HAL_TIM_SetCompare(TIM_SCAN_A, TIM_CHANNEL_2, u16DutyB);
    __HAL_TIM_SetCompare(TIM_SCAN_A, TIM_CHANNEL_3, u16DutyC);
}

bool PwrBootstrap(bool bBootSw, int eAxisNo)
{
    static u16 su16BootSts = BOOTSTRAP_INIT;
    static u16 su16BootCnt = 0;

    if (bBootSw)
    {
        if (su16BootSts == BOOTSTRAP_INIT)
        {
            PwmDuty(0, 0, 0);

            PwmClose(PWM_CH_UH);
            PwmClose(PWM_CH_UL);
            PwmClose(PWM_CH_VH);
            PwmClose(PWM_CH_VL);
            PwmClose(PWM_CH_WH);
            PwmClose(PWM_CH_WL);

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
                PwmClose(PWM_CH_VL);
                PwmClose(PWM_CH_WL);
                PwmOpen(PWM_CH_UL);
            }
            else if (i == 1)  // V
            {
                PwmClose(PWM_CH_UL);
                PwmClose(PWM_CH_WL);
                PwmOpen(PWM_CH_VL);
            }
            else if (i == 2)  // W
            {
                PwmClose(PWM_CH_UL);
                PwmClose(PWM_CH_VL);
                PwmOpen(PWM_CH_WL);
            }

#else

            // 下桥绕组短接

            PwmClose(PWM_CH_UH);
            PwmClose(PWM_CH_VH);
            PwmClose(PWM_CH_WH);

            PwmOpen(PWM_CH_UL);
            PwmOpen(PWM_CH_VL);
            PwmOpen(PWM_CH_WL);

#endif

            if (su16BootCnt < BOOTSTRAP_TIMES)
            {
                PeriodicTask(UNIT_MS, su16BootCnt++);
            }
            else
            {
                PwmOpen(PWM_CH_UH);
                PwmOpen(PWM_CH_UL);
                PwmOpen(PWM_CH_VH);
                PwmOpen(PWM_CH_VL);
                PwmOpen(PWM_CH_WH);
                PwmOpen(PWM_CH_WL);

                su16BootSts = BOOTSTRAP_DONE;  // 自举充电完成
            }
        }
    }
    else
    {
        PwmClose(PWM_CH_UH);
        PwmClose(PWM_CH_UL);
        PwmClose(PWM_CH_VH);
        PwmClose(PWM_CH_VL);
        PwmClose(PWM_CH_WH);
        PwmClose(PWM_CH_WL);

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

bool PwmGen(bool bPwmSw, int eAxisNo)
{
    static bool sbPwmSts = false;

    if (bPwmSw != sbPwmSts)
    {
        if (bPwmSw)
        {
            if (PwrBootstrap(true, eAxisNo))
            {
                sbPwmSts = true;
            }
        }
        else
        {
            PwrBootstrap(false, eAxisNo);
            sbPwmSts = false;
        }
    }

    return sbPwmSts;
}
