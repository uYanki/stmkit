#ifndef __OPENLOOP_H__
#define __OPENLOOP_H__

#include "paratbl.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef struct {
    axis_para_t* pAxisPara;

    ctrl_method_e eCtrlMethod_o;    ///< 控制方式
    ctrl_mode_e   eCtrlMode_o;      ///< 控制模式
    ctrlword_u    uCtrlCmd_o;       ///< 控制命令
    s16           s16IdRef_o;       ///< 转矩指令
    s16           s16IqRef_o;       ///< 磁通指令
    u16           u16ElecAngRef_o;  ///< 电角度指令

    u16 u16ElecAngIncCnt;  ///< 电角度递增间隔计数

} open_loop_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void OpenLoopCreat(open_loop_t* pOpenLoop, axis_para_t* pAxisPara);
void OpenLoopInit(open_loop_t* pOpenLoop);
void OpenLoopEnter(open_loop_t* pOpenLoop);
void OpenLoopExit(open_loop_t* pOpenLoop);
void OpenLoopCycle(open_loop_t* pOpenLoop);
void OpenLoopIsr(open_loop_t* pOpenLoop);

#ifdef __cplusplus
}
#endif

#endif
