#include "appmgr.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "appmgr"
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

void AppMgrCreat(app_mgr_t* pAppMgr, axis_para_t* pAxisPara)
{
    pAppMgr->eAppSelPre = AXIS_APP_INVAILD;
    pAppMgr->pAxisPara  = pAxisPara;

    OpenLoopCreat(&pAppMgr->sOpenLoop, pAxisPara);
    MotEncIdentCreat(&pAppMgr->sMotEncIdent, pAxisPara);
    LoopRspCreat(&pAppMgr->sLoopRsp, pAxisPara);
    OffMotIdentCreat(&pAppMgr->sOffMotIdent, pAxisPara);
}

void AppMgrInit(app_mgr_t* pAppMgr)
{
    OpenLoopInit(&pAppMgr->sOpenLoop);
    MotEncIdentInit(&pAppMgr->sMotEncIdent);
    LoopRspInit(&pAppMgr->sLoopRsp);
    OffMotIdentInit(&pAppMgr->sOffMotIdent);

    AppMgrCycle(pAppMgr);  // 切换APP
}

void AppMgrCycle(app_mgr_t* pAppMgr)
{
    axis_para_t* pAxisPara = pAppMgr->pAxisPara;

    if (pAppMgr->eAppSelPre != pAxisPara->eAppSel)
    {
        // 切换 APP

        switch (pAppMgr->eAppSelPre)
        {
            case AXIS_APP_GENERIC:
            {
                break;
            }

            case AXIS_APP_OPENLOOP:
            {
                OpenLoopExit(&pAppMgr->sOpenLoop);
                break;
            }

            case AXIS_APP_ENCIDENT:
            {
                MotEncIdentExit(&pAppMgr->sMotEncIdent);
                break;
            }

            case AXIS_APP_LOOPRSP:
            {
                LoopRspExit(&pAppMgr->sLoopRsp);
                break;
            }

            case AXIS_APP_OFFMOTIDNET:
            {
                OffMotIdentExit(&pAppMgr->sOffMotIdent);
                break;
            }

            default:
            {
                break;
            }
        }

        switch (pAxisPara->eAppSel)
        {
            case AXIS_APP_GENERIC:
            {
                pAppMgr->sAppOut.peCtrlMethod   = &pAxisPara->eCtrlMethod;
                pAppMgr->sAppOut.peCtrlMode     = &pAxisPara->eCtrlMode;
                pAppMgr->sAppOut.puCtrlCmd      = &pAxisPara->u32CommCmd;
                pAppMgr->sAppOut.pu16ElecAngRef = &pAxisPara->u16ElecAngRef;

                pAppMgr->sAppOut.pePosPlanMode = &pAxisPara->ePosPlanMode;
                pAppMgr->sAppOut.peSpdPlanMode = &pAxisPara->eSpdPlanMode;

                pAppMgr->sAppOut.ps64PosRef = &pAxisPara->s64PosDigRef;
                pAppMgr->sAppOut.ps16SpdRef = &pAxisPara->s16SpdDigRef;
                pAppMgr->sAppOut.ps16TrqRef = &pAxisPara->s16TrqDigRef;

                // pAppMgr->sAppOut.ps16IqRef
                // pAppMgr->sAppOut.ps16IdRef

                break;
            }

            case AXIS_APP_OPENLOOP:
            {
                open_loop_t* pOpenLoop = &pAppMgr->sOpenLoop;

                pAppMgr->sAppOut.peCtrlMethod   = &pOpenLoop->eCtrlMethod_o;
                pAppMgr->sAppOut.peCtrlMode     = &pOpenLoop->eCtrlMode_o;
                pAppMgr->sAppOut.puCtrlCmd      = &pOpenLoop->uCtrlCmd_o;
                pAppMgr->sAppOut.pu16ElecAngRef = &pOpenLoop->u16ElecAngRef_o;
                pAppMgr->sAppOut.ps16IqRef      = &pOpenLoop->s16IqRef_o;
                pAppMgr->sAppOut.ps16IdRef      = &pOpenLoop->s16IdRef_o;

                OpenLoopEnter(pOpenLoop);

                break;
            }

            case AXIS_APP_ENCIDENT:
            {
                mot_enc_ident_t* pMotEncIdent = &pAppMgr->sMotEncIdent;

                pAppMgr->sAppOut.peCtrlMethod   = &pMotEncIdent->eCtrlMethod_o;
                pAppMgr->sAppOut.peCtrlMode     = &pMotEncIdent->eCtrlMode_o;
                pAppMgr->sAppOut.puCtrlCmd      = &pMotEncIdent->uCtrlCmd_o;
                pAppMgr->sAppOut.pu16ElecAngRef = &pMotEncIdent->u16ElecAngRef_o;
                pAppMgr->sAppOut.ps16IqRef      = &pMotEncIdent->s16IqRef_o;
                pAppMgr->sAppOut.ps16IdRef      = &pMotEncIdent->s16IdRef_o;

                MotEncIdentEnter(pMotEncIdent);

                break;
            }

            case AXIS_APP_LOOPRSP:
            {
                static RO s16 s16Zero = 0;

                loop_rsp_t* pLoopRsp = &pAppMgr->sLoopRsp;

                pAppMgr->sAppOut.pu16ElecAngRef = &pLoopRsp->pAxisPara->u16ElecAngRef;

                pAppMgr->sAppOut.peCtrlMethod = &pLoopRsp->eCtrlMethod_o;
                pAppMgr->sAppOut.peCtrlMode   = &pLoopRsp->eCtrlMode_o;
                pAppMgr->sAppOut.puCtrlCmd    = &pLoopRsp->uCtrlCmd_o;

                pAppMgr->sAppOut.pePosPlanMode = &pLoopRsp->ePosPlanMode_o;
                pAppMgr->sAppOut.peSpdPlanMode = &pLoopRsp->eSpdPlanMode_o;

                pAppMgr->sAppOut.ps64PosRef = &pLoopRsp->s64PosOut_o;
                pAppMgr->sAppOut.ps16SpdRef = &pLoopRsp->s16SpdOut_o;
                pAppMgr->sAppOut.ps16IqRef  = &pLoopRsp->s16IqOut_o;
                pAppMgr->sAppOut.ps16IdRef  = &s16Zero;

                LoopRspEnter(pLoopRsp);

                break;
            }

            case AXIS_APP_OFFMOTIDNET:
            {
                off_mot_ident_t* pOffMotIdent = &pAppMgr->sOffMotIdent;

                // pAppMgr->sAppOut.peCtrlMethod   = &pOffMotIdent->AppOut.eCtrlMethod;
                // pAppMgr->sAppOut.peCtrlMode     = &pOffMotIdent->AppOut.eCtrlMode;
                // pAppMgr->sAppOut.puCtrlCmd      = &pOffMotIdent->AppOut.uCtrlCmd;
                // pAppMgr->sAppOut.pu16ElecAngRef = &pOffMotIdent->AppOut.u16ElecAngRef;
                // pAppMgr->sAppOut.ps16IqRef      = &pOffMotIdent->AppOut.s16IqRef;
                // pAppMgr->sAppOut.ps16IdRef      = &pOffMotIdent->AppOut.s16IdRef;

                pAppMgr->sAppOut.peCtrlMethod   = &pOffMotIdent->eCtrlMethod;
                pAppMgr->sAppOut.peCtrlMode     = &pOffMotIdent->eCtrlMode;
                pAppMgr->sAppOut.puCtrlCmd      = &pOffMotIdent->uCtrlCmd;
                pAppMgr->sAppOut.pu16ElecAngRef = &pOffMotIdent->u16ElecAngRef;
                pAppMgr->sAppOut.ps16IqRef      = &pOffMotIdent->s16UqRef;
                pAppMgr->sAppOut.ps16IdRef      = &pOffMotIdent->s16UdRef;

                OffMotIdentEnter(pOffMotIdent);

                break;
            }

            default:
            {
                break;
            }
        }

        pAppMgr->eAppSelPre = (axis_app_e)pAxisPara->eAppSel;
    }
    else
    {
        switch (pAxisPara->eAppSel)
        {
            case AXIS_APP_GENERIC:
            {
                break;
            }

            case AXIS_APP_OPENLOOP:
            {
                OpenLoopCycle(&pAppMgr->sOpenLoop);
                break;
            }

            case AXIS_APP_ENCIDENT:
            {
                MotEncIdentCycle(&pAppMgr->sMotEncIdent);
                break;
            }

            case AXIS_APP_LOOPRSP:
            {
                LoopRspCycle(&pAppMgr->sLoopRsp);
                break;
            }

            case AXIS_APP_OFFMOTIDNET:
            {
                OffMotIdentCycle(&pAppMgr->sOffMotIdent);
                break;
            }

            default:
            {
                break;
            }
        }
    }
}

void AppMgrIsr(app_mgr_t* pAppMgr)
{
    axis_para_t* pAxisPara = pAppMgr->pAxisPara;

    switch (pAxisPara->eAppSel)
    {
        case AXIS_APP_GENERIC:
        {
            break;
        }

        case AXIS_APP_OPENLOOP:
        {
            OpenLoopIsr(&pAppMgr->sOpenLoop);
            break;
        }

        case AXIS_APP_ENCIDENT:
        {
            MotEncIdentIsr(&pAppMgr->sMotEncIdent);
            break;
        }

        case AXIS_APP_LOOPRSP:
        {
            LoopRspIsr(&pAppMgr->sLoopRsp);
            break;
        }

        case AXIS_APP_OFFMOTIDNET:
        {
            OffMotIdentIsr(&pAppMgr->sOffMotIdent);
            break;
        }

        default:
        {
            break;
        }
    }
}
