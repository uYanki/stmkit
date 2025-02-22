#include "scheduler.h"
#include "alarm.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "scheduler"
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

static void _SystemCycle(void)
{
    device_para_t* pDevicePara = &D;

#if CONFIG_LED_NUM > 0
    static u32 u32BlinkPrd = 0;  // 系统状态LED闪烁周期 [ms]
#endif

    //
    // 系统状态
    //
    switch (pDevicePara->eSysState)
    {
        case SYSTEM_STATE_INITIAL:
        {
#if CONFIG_LED_NUM > 0
            u32BlinkPrd = 50;
#endif

            pDevicePara->eSysState = SYSTEM_STATE_READY_TO_SWITCH_ON;

            break;
        }

        case SYSTEM_STATE_READY_TO_SWITCH_ON:
        {
#if CONFIG_LED_NUM > 0
            u32BlinkPrd = 300;
#endif

            pDevicePara->eSysState = SYSTEM_STATE_SWITCHED_ON;

            break;
        }

        case SYSTEM_STATE_SWITCHED_ON:
        {
#if CONFIG_LED_NUM > 0
            u32BlinkPrd = 500;
#endif

            if (AlmChk(ALM_NONE) == false)
            {
                pDevicePara->eSysState = SYSTEM_STATE_FAULT_DIAGNOSE;
            }

            break;
        }

        case SYSTEM_STATE_FAULT_DIAGNOSE:
        {
#if CONFIG_LED_NUM > 0
            u32BlinkPrd = U32_MAX;
#endif

            if (AlmChk(ALM_NONE) == true)
            {
                pDevicePara->eSysState = SYSTEM_STATE_SWITCHED_ON;
            }

            break;
        }

        default:
        case SYSTEM_STATE_OPERATION_ENABLE:
        {
            break;
        }
    }

    //
    // 软复位
    //

    if (pDevicePara->bSwRstCmd)
    {
        SystemSoftReset();
    }

    //
    // Status LED
    //
#if CONFIG_LED_NUM > 0

    static u32 u32LastTick = 0;

    if (u32BlinkPrd == 0)
    {
        PinSetLvl(LED1_PIN_O, B_OFF);
    }
    else if (u32BlinkPrd == U32_MAX)
    {
        PinSetLvl(LED1_PIN_O, B_ON);
    }
    else if (DelayNonBlockMs(u32LastTick, u32BlinkPrd))
    {
        u32LastTick = GetTickMs();
        PinTgtLvl(LED1_PIN_O);
    }

#endif
}

void SchedCreat(void)
{
    ParaTblCreat();
    AlmCreat();
    FuncCreat();
}

void SchedInit(void)
{
    ParaTblInit();
    AlmInit();
    FuncInit();
}

void SchedCycle(void)
{
    StartEventRecorder(EVENT_CYCLE_SCAN);

    D.u32SysRunTime = GetTickMs();

    FuncCycle();
    ParaTblCycle();

    PeriodicTaskMs(10, _SystemCycle());

    AlmCycle();

    StopEventRecorder(EVENT_CYCLE_SCAN);
}

void SchedIsr(void)
{
    StartEventRecorder(EVENT_ISR_SCAN);
    // FuncInputIsr();
    FuncIsr();
    // FuncOutputIsr();
    StopEventRecorder(EVENT_ISR_SCAN);
}
