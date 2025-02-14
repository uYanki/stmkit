#include "looprsp.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG         "LoopRsp"
#define LOG_LOCAL_LEVEL       LOG_LEVEL_INFO

#define LOOP_RSP_DELAY_POINTS 20

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void LoopRspCreat(loop_rsp_t* pLoopRsp, axis_para_t* pAxisPara)
{
    extern scope_t sScope;

    pLoopRsp->pAxisPara   = pAxisPara;
    pLoopRsp->pDevicePara = &D;
    pLoopRsp->pScope      = &sScope;
}

void LoopRspInit(loop_rsp_t* pLoopRsp)
{
    pLoopRsp->ePosPlanMode_o = POS_PLAN_MODE_STEP;  // 阶跃
    pLoopRsp->eSpdPlanMode_o = SPD_PLAN_MODE_STEP;  // 阶跃

    // pLoopRsp->AppOut.ePosPlanMode = POS_PLAN_MODE_CURVE_X2;
    // pLoopRsp->AppOut.eSpdPlanMode = SPD_PLAN_MODE_CURVE_X2;

    pLoopRsp->eCtrlMethod_o = CTRL_METHOD_FOC_CLOSED;
}

void LoopRspEnter(loop_rsp_t* pLoopRsp)
{
    pLoopRsp->pScope->bEnable = false;
}

void LoopRspExit(loop_rsp_t* pLoopRsp)
{
    pLoopRsp->pScope->bEnable = true;
}

void LoopRspCycle(loop_rsp_t* pLoopRsp) {}

void LoopRspIsr(loop_rsp_t* pLoopRsp)
{
    axis_para_t*   pAxisPara   = pLoopRsp->pAxisPara;
    device_para_t* pDevicePara = pLoopRsp->pDevicePara;

    scope_t* pScope = pLoopRsp->pScope;

    switch (pAxisPara->eLoopRspState)
    {
        case LOOP_RSP_STATE_IDLE:
        {
            break;
        }

        case LOOP_RSP_STATE_INIT:
        {
            if (pAxisPara->bPwmSwSts == false)
            {
                switch (pAxisPara->eLoopRspModeSel)
                {
                    case LOOP_RSP_MODE_TRQ:
                    {
                        pLoopRsp->eCtrlMode_o = CTRL_MODE_TRQ;
                        pLoopRsp->s16IqOut_o  = 0;
                        break;
                    }
                    case LOOP_RSP_MODE_SPD:
                    {
                        pLoopRsp->eCtrlMode_o = CTRL_MODE_SPD;
                        pLoopRsp->s16SpdOut_o = 0;
                        break;
                    }
                    case LOOP_RSP_MODE_POS:
                    {
                        pLoopRsp->eCtrlMode_o = CTRL_MODE_POS;
                        break;
                    }
                }

                pLoopRsp->uCtrlCmd_o.u32Bit.Enable = true;
            }
            else  // 等待自举完成
            {
                // 采样对象
                ScopeInitSampObj(pScope);

                // 上传状态
                pDevicePara->u16ScopeUploadSts = SCOPE_UPLOAD_PREPARE;

                pAxisPara->eLoopRspState = LOOP_RSP_STATE_DELAY;
            }

            break;
        }

        case LOOP_RSP_STATE_DELAY:
        {
            if (++pScope->u16SampPrdCnt == pScope->u16SampPrd)
            {
                pScope->u16SampPrdCnt = 0;

                ScopeRecordSampObj(pScope);

                if (++pScope->u16SampIdx == LOOP_RSP_DELAY_POINTS)
                {
                    switch (pAxisPara->eLoopRspModeSel)
                    {
                        case LOOP_RSP_MODE_TRQ:
                        {
                            pLoopRsp->s16IqOut_o = pAxisPara->s64LoopRspStep;
                            break;
                        }
                        case LOOP_RSP_MODE_SPD:
                        {
                            pLoopRsp->s16SpdOut_o = pAxisPara->s64LoopRspStep;
                            break;
                        }
                        case LOOP_RSP_MODE_POS:
                        {
                            pLoopRsp->s64PosOut_o += pAxisPara->s64LoopRspStep;
                            break;
                        }
                    }

                    pAxisPara->eLoopRspState = LOOP_RSP_STATE_BUSY;
                }
            }

            break;
        }

        case LOOP_RSP_STATE_BUSY:
        {
            if (++pScope->u16SampPrdCnt == pScope->u16SampPrd)
            {
                pScope->u16SampPrdCnt = 0;

                ScopeRecordSampObj(pScope);

                if (++pScope->u16SampIdx == pScope->u16SampCnt)
                {
                    pLoopRsp->uCtrlCmd_o.u32Bit.Enable = false;  // 失能

                    pDevicePara->u16ScopeUploadSts = SCOPE_UPLOAD_READY;
                    pAxisPara->eLoopRspState       = LOOP_RSP_STATE_UPLOAD;
                }
            }

            break;
        }

        case LOOP_RSP_STATE_UPLOAD:
        {
            if (pDevicePara->u16ScopeUploadSts == SCOPE_UPLOAD_BUSY)  // set busy by external device.
            {
            }
            else if (pDevicePara->u16ScopeUploadSts == SCOPE_UPLOAD_OVER)  // wait external device read over.
            {
                pDevicePara->u16ScopeUploadSts = SCOPE_UPLOAD_STANDBY;
                pAxisPara->eLoopRspState       = LOOP_RSP_STATE_IDLE;
            }

            break;
        }

        default:
        {
            pAxisPara->eLoopRspState = LOOP_RSP_STATE_IDLE;

            break;
        }
    }
}
