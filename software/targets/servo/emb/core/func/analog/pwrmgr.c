#include "pwrmgr.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "pwrmgr"
#define LOG_LOCAL_LEVEL LOG_LEVELNFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

static void _UmdcAlmDet(pwr_mgr_t* pPwrMgr)
{
    device_para_t* pDevicePara = pPwrMgr->pDevicePara;

    RO u16 u16Zone = 20;  // 0.1V

    if (pDevicePara->u16UmdcSi > pDevicePara->u16UmdcErrOVSi)  // 过压报警
    {
        AlmRst(WRN_MAIN_DC_UV, 0);
        AlmRst(ERR_MAIN_DC_UV, 0);
        AlmSet(ERR_MAIN_DC_OV, 0);
    }
    else if (pDevicePara->eSysState == SYSTEM_STATE_OPERATION_ENABLE)
    {
        // 非使能状态不检测欠压, 避免上下电误报

        if (pDevicePara->u16UmdcSi < pDevicePara->u16UmdcErrUVSi)  // 欠压报警
        {
            AlmRst(ERR_MAIN_DC_OV, 0);
            AlmRst(WRN_MAIN_DC_UV, 0);
            AlmSet(ERR_MAIN_DC_UV, 0);
        }
        else if (pDevicePara->u16UmdcSi < pDevicePara->u16UmdcWrnUVSi)  // 欠压警告
        {
            AlmRst(ERR_MAIN_DC_OV, 0);
            AlmRst(ERR_MAIN_DC_UV, 0);
            AlmSet(WRN_MAIN_DC_UV, 0);
        }
        else if (pDevicePara->u16UmdcSi > (pDevicePara->u16UmdcWrnUVSi + u16Zone))  // 解除警告
        {
            // 留有迟滞空间, 避免采样噪声导致过早地解除报警
            AlmRst(ERR_MAIN_DC_OV, 0);
            AlmRst(ERR_MAIN_DC_UV, 0);
            AlmRst(WRN_MAIN_DC_UV, 0);
        }
    }
    else
    {
        // 解除过压警告
        AlmRst(ERR_MAIN_DC_OV, 0);

        // 解除欠压警告
        if (pDevicePara->u16UmdcSi > (pDevicePara->u16UmdcWrnUVSi + u16Zone))
        {
            AlmRst(ERR_MAIN_DC_UV, 0);
            AlmRst(WRN_MAIN_DC_UV, 0);
        }
    }
}

static void _UcdcAlmDet(pwr_mgr_t* pPwrMgr)
{}

static void _BrkResCtrl(pwr_mgr_t* pPwrMgr) {}

static void _PwrRlyCtrl(pwr_mgr_t* pPwrMgr) {}

static void _FanCtrl(pwr_mgr_t* pPwrMgr) {}

void PwrMgrCreat(pwr_mgr_t* pPwrMgr, device_para_t* pDevicePara)
{
    pPwrMgr->pDevicePara = pDevicePara;
}

void PwrMgrInit(pwr_mgr_t* pPwrMgr)
{
}

void PwrMgrIsr(pwr_mgr_t* pPwrMgr)
{
    // 电源状态
    _UmdcAlmDet(pPwrMgr);
    _UcdcAlmDet(pPwrMgr);

    // 制动电阻
    _BrkResCtrl(pPwrMgr);
}
void PwrMgrCycle(pwr_mgr_t* pPwrMgr)
{
    // 缓起继电器
    _PwrRlyCtrl(pPwrMgr);

    // 风扇
    _FanCtrl(pPwrMgr);
}
