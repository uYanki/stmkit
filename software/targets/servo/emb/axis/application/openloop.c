#include "openloop.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "openloop"
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

void OpenLoopCreat(open_loop_t* pOpenLoop, axis_para_t* pAxisPara)
{
    pOpenLoop->pAxisPara = pAxisPara;
}

void OpenLoopInit(open_loop_t* pOpenLoop)
{
    pOpenLoop->eCtrlMode_o   = CTRL_MODE_TRQ;
    pOpenLoop->eCtrlMethod_o = CTRL_METHOD_FOC_OPEN;
}

void OpenLoopEnter(open_loop_t* pOpenLoop)
{
    pOpenLoop->u16ElecAngIncCnt = 0;
}

void OpenLoopExit(open_loop_t* pOpenLoop)
{
}

void OpenLoopCycle(open_loop_t* pOpenLoop)
{
    axis_para_t* pAxisPara = pOpenLoop->pAxisPara;

    if (pAxisPara->u16OpenLoopEn == 0)
    {
        pOpenLoop->uCtrlCmd_o.u32Bit.Enable = false;
    }
    else
    {
        pOpenLoop->uCtrlCmd_o.u32Bit.Enable = true;
    }
}

void OpenLoopIsr(open_loop_t* pOpenLoop)
{
    axis_para_t* pAxisPara = pOpenLoop->pAxisPara;

    if (pAxisPara->bPwmSwSts)  // 轴使能后再执行
    {
        if (pAxisPara->u16OpenPeriod == 0)
        {
            pOpenLoop->u16ElecAngRef_o = pAxisPara->u16OpenElecAngLock;  // 锁定电角度
        }
        else if (pAxisPara->u16OpenPeriod == ++pOpenLoop->u16ElecAngIncCnt)
        {
            pOpenLoop->u16ElecAngRef_o += pAxisPara->s16OpenElecAngInc;  // 递增电角度
            pOpenLoop->u16ElecAngIncCnt = 0;
        }

        pOpenLoop->s16IqRef_o = pAxisPara->s16OpenUqRef;
        pOpenLoop->s16IdRef_o = pAxisPara->s16OpenUdRef;
    }
}
