#include "scheduler.h"

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

static axis_t aAxis[CONFIG_AXIS_NUM] = {0};

device_para_t sDevicePara                = {0};
axis_para_t   sAxisPara[CONFIG_AXIS_NUM] = {0};

scope_t sScope = {0};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

u32 GetBuildData()  // 编译日期
{
    static s8    as8BuildDate[]  = __DATE__;  // ascii format "Sep  1 2022"
    static RO s8 cas8MonthList[] = "anebarprayunulugepctovec";
    u8           u8Year, u8Month, u8Day;

    /*return software compile date, decimal format: yy-mm-dd*/
    if (as8BuildDate[4] == ' ')
    {
        as8BuildDate[4] = 0;
    }
    else
    {
        as8BuildDate[4] -= '0';
    }
    for (u8Day = 5; u8Day < 11; u8Day++)
    {
        as8BuildDate[u8Day] -= '0';
    }

    u8Year = as8BuildDate[9] * 10 + as8BuildDate[10];  // year

    for (u8Day = 0; u8Day < 23; u8Day += 2)  // month
    {
        if (as8BuildDate[1] == cas8MonthList[u8Day] &&
            as8BuildDate[2] == cas8MonthList[u8Day + 1])
        {
            u8Month = (u8Day >> 1) + 1;
            break;
        }
    }
    u8Day = as8BuildDate[4] * 10 + as8BuildDate[5];  // day

    return (u32)u8Year * 10000 + (u32)u8Month * 100 + (u32)u8Day;
}

void ParaTblCreat(void)
{}

void ParaTblInit_(void)
{
    u16* pParaTbl;

    // device paratbl

    pParaTbl = (u16*)&D;

    for (u16 i = 0; i < sizeof(device_para_t) / sizeof(u16); ++i)
    {
        pParaTbl[i] = sDeviceAttr[i].u16InitVal;
    }

    D.u32McuSwBuildDate = GetBuildData();

    // axis paratbl

    for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
    {
        axis_para_t* pAxisPara = aAxis[u16AxisInd].pAxisPara;

        pParaTbl = (u16*)pAxisPara;

        for (u16 i = 0; i < sizeof(axis_para_t) / sizeof(u16); ++i)
        {
            pParaTbl[i] = sAxisAttr[i].u16InitVal;
        }

        // TIM freq / Carry freq / 2
        pAxisPara->u16PwmDutyMax = PWM_PERIOD;
        pAxisPara->u16AxisNo     = AXIS_IND2NO(u16AxisInd);
    }
}

void ParaTblCycle(void) {}

static void _ParaFormula(void)
{
#if 0
    device_para_t* pDevicePara = pLogicCtrl->pDevicePara;
    axis_para_t*   pAxisPara   = pLogicCtrl->pAxisPara;

    if (pDevicePara->u16ParaFormula != pDevicePara->u16ParaFormula)
    {}
#endif
}

static void _SystemCycle(void)
{
    device_para_t* pDevicePara = &D;

#if CONFIG_LED_NUM > 0
    static u32 u16BlinkPrd = 0;  // 系统状态LED闪烁周期 [ms]
#endif

    //
    // 系统状态
    //
    switch (pDevicePara->eSysState)
    {
        case SYSTEM_STATE_INITIAL:
        {
#if CONFIG_LED_NUM > 0
            u16BlinkPrd = 50;
#endif

            if (pDevicePara->u16UmdcSi > pDevicePara->u16UmdcRlyOnSi)  // check power state
            {
                pDevicePara->eSysState = SYSTEM_STATE_READY_TO_SWITCH_ON;
            }

            break;
        }
        case SYSTEM_STATE_READY_TO_SWITCH_ON:
        {
#if CONFIG_LED_NUM > 0
            u16BlinkPrd = 300;
#endif

            for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
            {
                axis_para_t* pAxisPara = aAxis[u16AxisInd].pAxisPara;

                if (pAxisPara->eAxisFSM == AXIS_STATE_STANDBY)
                {
                    pDevicePara->eSysState = SYSTEM_STATE_SWITCHED_ON;
                }
            }

            break;
        }
        case SYSTEM_STATE_SWITCHED_ON:
        {
#if CONFIG_LED_NUM > 0
            u16BlinkPrd = 500;
#endif

            for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
            {
                axis_para_t* pAxisPara = aAxis[u16AxisInd].pAxisPara;

                if (pAxisPara->eAxisFSM == AXIS_STATE_ENABLE)
                {
                    pDevicePara->eSysState = SYSTEM_STATE_OPERATION_ENABLE;
                }
            }

            break;
        }
        case SYSTEM_STATE_OPERATION_ENABLE:
        {
#if CONFIG_LED_NUM > 0
            u16BlinkPrd = 100;
#endif

            for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
            {
                axis_para_t* pAxisPara = aAxis[u16AxisInd].pAxisPara;

                if (pAxisPara->eAxisFSM == AXIS_STATE_FAULT)
                {
                    pDevicePara->eSysState = SYSTEM_STATE_FAULT_DIAGNOSE;
                }
                else if (pAxisPara->eAxisFSM != AXIS_STATE_ENABLE)
                {
                    pDevicePara->eSysState = SYSTEM_STATE_READY_TO_SWITCH_ON;
                }
            }

            break;
        }
        case SYSTEM_STATE_FAULT_DIAGNOSE:
        {
#if CONFIG_LED_NUM > 0
            u16BlinkPrd = U16_MAX;
#endif

            bool bAxisFault = false;

            for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)  // check axis state
            {
                axis_para_t* pAxisPara = aAxis[u16AxisInd].pAxisPara;

                if (pAxisPara->eAxisFSM == AXIS_STATE_FAULT)
                {
                    bAxisFault = true;
                    break;
                }
            }

            if (bAxisFault == false)
            {
                pDevicePara->eSysState = SYSTEM_STATE_SWITCHED_ON;
            }

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

    static tick_t u32LastTick = 0;

    if (u16BlinkPrd == 0)
    {
        PinSetLvl(LED1_PIN_O, B_OFF);
    }
    else if (u16BlinkPrd == U16_MAX)
    {
        PinSetLvl(LED1_PIN_O, B_ON);
    }
    else if (DelayNonBlockMs(u32LastTick, u16BlinkPrd))
    {
        u32LastTick = GetTickUs();
        PinTgtLvl(LED1_PIN_O);
    }

#endif
}

void SchedCreat(void)
{
    scope_t* pScope = &sScope;
    axis_t*  pAxis;

    ParaTblCreat();
    AlmCreat();
    FuncCreat();

    for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
    {
        pAxis = &aAxis[u16AxisInd];

        AxisCreat(&aAxis[u16AxisInd], &D, &P(u16AxisInd));

        pScope->pDevicePara           = pAxis->pDevicePara;
        pScope->pAxisPara[u16AxisInd] = pAxis->pAxisPara;
    }

    ScopeCreat(pScope);
}

void SchedInit(void)
{
    ParaTblInit();
    AlmInit();
    FuncInit();

    for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
    {
        AxisInit(&aAxis[u16AxisInd]);
    }

    ScopeInit(&sScope);
}

void SchedCycle(void)
{
    D.u32SysRunTime = GetTickMs();

    FuncCycle();
    ParaTblCycle();

    for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
    {
        AxisCycle(&aAxis[u16AxisInd]);
    }

    PeriodicTask(10 * UNIT_MS, _SystemCycle());

    AlmCycle();
    ScopeCycle(&sScope);

    // 配方
    _ParaFormula();
}

void SchedIsrA(void)
{

	#if 1
	 PeriodicTask( UNIT_S, {D._Resv106 = D._Resv105;	D._Resv105 = 0; });
		 D._Resv105++ ;
	 #endif
	 
    FuncInputIsr();

    for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
    {
        AxisFeedBackIsr(&aAxis[u16AxisInd]);
    }

    // 所有轴就绪
    if (D.eSysState < SYSTEM_STATE_SWITCHED_ON)
    {
        return;
    }

    for (u16 u16AxisInd = 0; u16AxisInd < CONFIG_AXIS_NUM; ++u16AxisInd)
    {
        AxisIsr(&aAxis[u16AxisInd]);
    }

    FuncOutputIsr();
    ScopeIsr(&sScope);
}

void SchedIsrB(void)
{
    FuncIsr();
}
