#ifndef __APPL_H__
#define __APPL_H__

#include "paratbl.h"

#include "openloop.h"
#include "motencident.h"
#include "looprsp.h"
#include "offmotident.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef struct {
    RO ctrl_method_e* peCtrlMethod;  ///< 驱动层.控制方法

    RO ctrl_mode_e* peCtrlMode;  ///< 逻辑层.控制模式
    RO ctrlword_u*  puCtrlCmd;   ///< 逻辑层.控制指令

    RO s64*             ps64PosRef;     ///< 逻辑层.位置指令
    RO pos_plan_mode_e* pePosPlanMode;  ///< 逻辑层.位置规划模式
    RO s16*             ps16SpdRef;     ///< 逻辑层.速度指令
    RO spd_plan_mode_e* peSpdPlanMode;  ///< 逻辑层.速度规划模式
    RO s16*             ps16TrqRef;     ///< 逻辑层.转矩指令

    RO u16* pu16ElecAngRef;  ///< 驱动层.电角度指令
    RO s16* ps16IqRef;       ///< 驱动层.转矩指令
    RO s16* ps16IdRef;       ///< 驱动层.磁通指令

} app_conf_t;

typedef struct {
    axis_para_t* pAxisPara;

    axis_app_e      eAppSelPre;
    open_loop_t     sOpenLoop;
    mot_enc_ident_t sMotEncIdent;
    loop_rsp_t      sLoopRsp;
    off_mot_ident_t sOffMotIdent;

    app_conf_t sAppOut;

} app_mgr_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void AppMgrCreat(app_mgr_t* pAppMgr, axis_para_t* pAxisPara);
void AppMgrInit(app_mgr_t* pAppMgr);
void AppMgrCycle(app_mgr_t* pAppMgr);
void AppMgrIsr(app_mgr_t* pAppMgr);

#ifdef __cplusplus
}
#endif

#endif
