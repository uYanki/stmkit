#include "axis.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "axis"
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

void AxisCreat(axis_t* pAxis, device_para_t* pDevicePara, axis_para_t* pAxisPara)
{
    app_mgr_t*    pAppMgr    = &pAxis->sAppMgr;
    logic_ctrl_t* pLogicCtrl = &pAxis->sLogicCtrl;
    path_plan_t*  pPathPlan  = &pAxis->sPathPlan;
    motdrv_t*     pMotDrv    = &pAxis->sMotDrv;

    pAxis->pDevicePara = pDevicePara;
    pAxis->pAxisPara   = pAxisPara;

    AppMgrCreat(pAppMgr, pAxisPara);

    //
    // 规划层.位置规划
    //

    pLogicCtrl->pAppConf = &pAppMgr->sAppOut;

    LogicCtrlCreat(pLogicCtrl, pDevicePara, pAxisPara);
    PathPlanCreat(pPathPlan, pAxisPara);

    //
    // 驱动层.应用层指令
    //
    pMotDrv->input.pps16IqRef      = &pAppMgr->sAppOut.ps16IqRef;
    pMotDrv->input.pps16IdRef      = &pAppMgr->sAppOut.ps16IdRef;
    pMotDrv->input.ppu16ElecAngRef = &pAppMgr->sAppOut.pu16ElecAngRef;

    MotDrvCreat(&pAxis->sMotDrv, pAxisPara);
}

static void AxisStateCycle(axis_t* pAxis)
{
    device_para_t* pDevicePara = pAxis->pDevicePara;
    axis_para_t*   pAxisPara   = pAxis->pAxisPara;

    switch (pAxisPara->eAxisFSM)
    {
        case AXIS_STATE_INITIAL:
        {
            if (pDevicePara->eSysState >= SYSTEM_STATE_READY_TO_SWITCH_ON)
            {
                if (pAxis->sMotDrv.sCurSamp.bZeroDriftOver)  // 零漂采集完成
                {
                    pAxisPara->eAxisFSM = AXIS_STATE_STANDBY;
                }
            }

            break;
        }
        case AXIS_STATE_STANDBY:
        {
            if (pAxisPara->bPwmSwSts == true)
            {
                pAxisPara->eAxisFSM = AXIS_STATE_ENABLE;
            }

            break;
        }
        case AXIS_STATE_ENABLE:
        {
            if (pAxisPara->bPwmSwSts == false)
            {
                pAxisPara->eAxisFSM = AXIS_STATE_STANDBY;
            }

            break;
        }
        case AXIS_STATE_FAULT:
        {
            PeriodicTask(10 * UNIT_MS, {
                if (AlmHas(pAxisPara->u16AxisNo) == false)
                {
                    pAxisPara->eAxisFSM = AXIS_STATE_STANDBY;
                }
            });

            break;
        }

        default: break;
    }
}

void AxisInit(axis_t* pAxis)
{
    AppMgrInit(&pAxis->sAppMgr);
    LogicCtrlInit(&pAxis->sLogicCtrl);
    PathPlanInit(&pAxis->sPathPlan);
    MotDrvInit(&pAxis->sMotDrv);
}

void AxisCycle(axis_t* pAxis)
{
    AxisStateCycle(pAxis);
    AppMgrCycle(&pAxis->sAppMgr);
    LogicCtrlCycle(&pAxis->sLogicCtrl);
    PathPlanCycle(&pAxis->sPathPlan);
    MotDrvCycle(&pAxis->sMotDrv);
}

void AxisFeedBackIsr(axis_t* pAxis)  // 轴反馈
{
    EncSampIsr(&pAxis->sMotDrv.sEncSamp);
    CurSampIsr(&pAxis->sMotDrv.sCurSamp);
}

void AxisIsr(axis_t* pAxis)
{
    StartEventRecorder(EVENT_ISR_SCAN_A);

    AppMgrIsr(&pAxis->sAppMgr);
    LogicCtrlIsr(&pAxis->sLogicCtrl);
    PathPlanIsr(&pAxis->sPathPlan);
    MotDrvIsr(&pAxis->sMotDrv);

    StopEventRecorder(EVENT_ISR_SCAN_A);
}
