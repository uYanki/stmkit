#ifndef __AXIS_H__
#define __AXIS_H__

#include "typebasic.h"
#include "paratbl.h"
#include "application/appmgr.h"
#include "logicctrl/logicctrl.h"
#include "pathplan/pathplan.h"
#include "motdrv/motdrv.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef struct {
    u8           u16AxisNo;
    app_mgr_t    sAppMgr;
    logic_ctrl_t sLogicCtrl;
    path_plan_t  sPathPlan;
    motdrv_t     sMotDrv;

    axis_para_t*   pAxisPara;
    device_para_t* pDevicePara;

    u16 u16MotEncSel;

} axis_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void AxisCreat(axis_t* pAxis, device_para_t* pDevicePara, axis_para_t* pAxisPara);
void AxisInit(axis_t* pAxis);
void AxisCycle(axis_t* pAxis);
void AxisIsr(axis_t* pAxis);

#ifdef __cplusplus
}
#endif

#endif
