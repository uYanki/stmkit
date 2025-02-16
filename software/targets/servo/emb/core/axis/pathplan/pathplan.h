#ifndef __PATH_PLAN_H__
#define __PATH_PLAN_H__

#include "paratbl.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

/**
 * @brief  斜坡速度规划
 */
typedef struct {
    RO s32* ps32SpdTgt_i;   ///< 规划速度输入
    RO u16* pu16AccTime_i;  ///< 规划加速度时间输入
    RO u16* pu16DecTime_i;  ///< 规划减速度时间输入

    s32  s32SpdOut_o;  ///< 规划速度输出
    bool bFinish;      ///< 规划完成标志

    s32 s32SpdTgt;   ///< 当前给定速度
    u16 u16AccTime;  ///< 当前给定加速时间 [ms]
    u16 u16DecTime;  ///< 当前给定减速时间 [ms]

    u16 u16AccRate;    ///< 加速度变化率
    u16 u16DecRate;    ///< 减速度变化率
    u16 u16AccTick;    ///< 单次加速时间
    u16 u16DecTick;    ///< 单次减速时间
    u16 u16TimeTicks;  ///< 加减速计时

    s32 s32SpdOutZoom;  ///< 规划速度输出(放大后)

} spd_plan_slope_t;

typedef struct {
    //
    // 速度环周期 Tspd (s), 速度环频率 Fspd (hz)
    //

    RO s32* ps32SpdTgt_i;   ///< 规划速度输入
    RO u16* pu16AccTime_i;  ///< 规划加速度时间输入
    RO u16* pu16DecTime_i;  ///< 规划减速度时间输入

    bool bFinish;      ///< 规划完成标志
    s32  s32SpdOut_o;  ///< 规划速度输出 [rpm]

    s32 s32V0;  ///< 初速度 [rpm]
    f32 f32J;   ///< 加加速度 [rpm / Tspd^2]
    f32 f32T1;  ///< 半时间 [Tspd]
    u32 u32T2;  ///< 总时间 [Tspd]
    u32 u32Tn;  ///< 当前时间 [Tspd]

    f32 f32T1Sq;
    f32 f32T1Cu;

    bool bDecToZero;  ///< 反向时减速到0

    s32 s32SpdTgt;   ///< 当前给定速度
    u16 u16AccTime;  ///< 当前给定加速时间 [ms]
    u16 u16DecTime;  ///< 当前给定减速时间 [ms]

    spd_plan_mode_e eMode;

} spd_plan_curve_t;

typedef struct {
    //
    // 位置环周期 Tpos (s), 位置环频率 Fpos (hz)
    //

    RO s16* ps16SpdLim_i;   ///< 规划最大速度输入
    RO u16* pu16AccTime_i;  ///< 规划加速度时间输入
    RO u16* pu16DecTime_i;  ///< 规划减速度时间输入
    RO u32* pu32EncRes_i;   ///< 编码器分辨率

    s64 s64PosRef_i;  ///< 规划位置输入 [pulse]
    f32 f32PosOut;    ///< 规划位置输出 [pulse]
    s64 s64PosOut_o;  ///< 规划位置输出 [pulse]

    u16 u16AccTime;  ///< 当前给定加速时间 [ms]
    u16 u16DecTime;  ///< 当前给定减速时间 [ms]
    s16 s16SpdLim;   ///< 规划最大速度

    s32 s32SpdMax;  ///< 规划最大速度 [pulse/Tpos]
    f32 f32SpdRef;  ///< 规划速度 [pulse/Tpos]
    f32 f32Acc;     ///< 规划加速度 [pulse/Tpos^2]
    f32 f32Dec;     ///< 规划减速度 [pulse/Tpos^2]

    s64 s64DecPos;  ///< 开始减速位置规划点

    axis_para_t* pAxisPara;

} pos_plan_curve_t;

typedef struct {
    axis_para_t*     pAxisPara;
    spd_plan_slope_t sSpdPlanSlope;
    spd_plan_curve_t sSpdPlanCurveX2;
    spd_plan_curve_t sSpdPlanCurveX3;
    pos_plan_curve_t sPosPlanCurveX2;
} path_plan_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void PathPlanCreat(path_plan_t* pPlanPlan, axis_para_t* pAxisPara);
void PathPlanInit(path_plan_t* pPlanPlan);
void PathPlanCycle(path_plan_t* pPlanPlan);
void PathPlanIsr(path_plan_t* pPlanPlan);

#ifdef __cplusplus
}
#endif

#endif
