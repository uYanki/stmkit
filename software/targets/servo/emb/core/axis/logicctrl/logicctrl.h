#ifndef __LOGIC_CTRL_H__
#define __LOGIC_CTRL_H__

#include "paratbl.h"
#include "bsp.h"
#include "appmgr.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef struct {
    device_para_t* pDevicePara;
    axis_para_t*   pAxisPara;
    app_conf_t*    pAppConf;

    u16 u16MultiRefSelPre;  ///< 多段指令选择(上一个周期)
    u16 ePosRefSetPre;      ///< 位置指令触发标志(上一个周期)

    u16 u16MotEncSelPre;   ///< 电机选择(上一个周期)
    u16 u16MotCurRatePre;  ///< 电机额定电流(上一个周期)

    bool bTrqArrive;  ///< 转矩到达信号

} logic_ctrl_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void LogicCtrlCreat(logic_ctrl_t* pLogicCtrl, device_para_t* pDevicePara, axis_para_t* pAxisPara);
void LogicCtrlInit(logic_ctrl_t* pLogicCtrl);
void LogicCtrlCycle(logic_ctrl_t* pLogicCtrl);
void LogicCtrlIsr(logic_ctrl_t* pLogicCtrl);

#ifdef __cplusplus
}
#endif

#endif
