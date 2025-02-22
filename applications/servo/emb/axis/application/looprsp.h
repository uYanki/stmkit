#ifndef __LOOP_RSP_H__
#define __LOOP_RSP_H__

// loop response trace

#include "paratbl.h"
#include "scope.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef enum {
    LOOP_RSP_MODE_TRQ,  ///< 转矩控制
    LOOP_RSP_MODE_SPD,  ///< 速度控制
    LOOP_RSP_MODE_POS,  ///< 位置控制
} loop_rsp_mode_e;

typedef enum {
    LOOP_RSP_STATE_IDLE,    ///< 空闲
    LOOP_RSP_STATE_INIT,    ///< 初始化
    LOOP_RSP_STATE_DELAY,   ///< 等待
    LOOP_RSP_STATE_BUSY,    ///< 忙碌
    LOOP_RSP_STATE_UPLOAD,  ///< 数据上传
} loop_rsp_state_e;

typedef struct {
    axis_para_t*   pAxisPara;
    device_para_t* pDevicePara;

    ctrl_method_e   eCtrlMethod_o;   ///< 控制方式
    ctrl_mode_e     eCtrlMode_o;     ///< 控制模式
    pos_plan_mode_e ePosPlanMode_o;  ///< 位置规划模式
    spd_plan_mode_e eSpdPlanMode_o;  ///< 速度规划模式
    ctrlword_u      uCtrlCmd_o;
    s64             s64PosOut_o;
    s16             s16SpdOut_o;
    s16             s16IqOut_o;

    scope_t* pScope;

} loop_rsp_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void LoopRspCreat(loop_rsp_t* pLoopRsp, axis_para_t* pAxisPara);
void LoopRspInit(loop_rsp_t* pLoopRsp);
void LoopRspEnter(loop_rsp_t* pLoopRsp);
void LoopRspExit(loop_rsp_t* pLoopRsp);
void LoopRspCycle(loop_rsp_t* pLoopRsp);
void LoopRspIsr(loop_rsp_t* pLoopRsp);

#ifdef __cplusplus
}
#endif

#endif
