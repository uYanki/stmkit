#include "pathplan.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG       "pathplan"
#define LOG_LOCAL_LEVEL     LOG_LEVEL_INFO

#define __SPD_LOOP_MS(time) (time * CONFIG_SPD_LOOP_FREQ_HZ / 1000)

#define __ACC_DEC_SPD_ZOOM  100   // 加减速缩放系数
#define __ACC_DEC_SPD_REF   1000  // 加减速参考速度 (rpm)

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

static void _PosPlanCurveParaCalc(pos_plan_curve_t* pCurve)
{
    axis_para_t* pAxisPara = pCurve->pAxisPara;

    if ((pCurve->u16AccTime != *pCurve->pu16AccTime_i) ||
        (pCurve->u16DecTime != *pCurve->pu16DecTime_i) ||
        (pCurve->s16SpdLim != *pCurve->ps16SpdLim_i))
    {
        pCurve->u16AccTime = *pCurve->pu16AccTime_i;
        pCurve->u16DecTime = *pCurve->pu16DecTime_i;
        pCurve->s16SpdLim  = *pCurve->ps16SpdLim_i;

        // pulse/r * r/min / 60s/min = 0.01666pulse/s

        //               Tpos(s)=1/Fpos(Hz)
        // 1 (pulse/s) ---------------------> Fpos*Fpos (pulse/Tpos)
        //
        // !! 此处 Fpos 为纯数值, 不带单位
        //

        pCurve->s32SpdMax = (s32)pAxisPara->u32EncRes * (s32)pCurve->s16SpdLim / (MIN_SEC_COEFF * CONFIG_POS_LOOP_FREQ_HZ);

        //                       1ms = 0.001s
        // 1 (pulse/s) / 1 (ms) --------------> 1000 (pulse/s^2)

        //                Tpos(s)=1/Fpos(Hz)
        // 1 (pulse/s^2) -------------------> Fpos*Fpos (pulse/Tpos^2)
        //

        pCurve->f32Acc = (f32)pAxisPara->u32EncRes * 1000 * __ACC_DEC_SPD_REF / MIN_SEC_COEFF / CONFIG_POS_LOOP_FREQ_HZ / CONFIG_POS_LOOP_FREQ_HZ / (s32)pCurve->u16AccTime;
        pCurve->f32Dec = (f32)pAxisPara->u32EncRes * 1000 * __ACC_DEC_SPD_REF / MIN_SEC_COEFF / CONFIG_POS_LOOP_FREQ_HZ / CONFIG_POS_LOOP_FREQ_HZ / (s32)pCurve->u16DecTime;
    }
}

static void _PosPlanCurveX2Proc(pos_plan_curve_t* pCurveX2)  // 积分法
{
    s64 s64PosDelta = pCurveX2->s64PosRef_i - pCurveX2->s64PosOut_o;  // 剩余未走位置

    if (s64PosDelta > 0)  // 正向运动
    {
        if (s64PosDelta > pCurveX2->s64DecPos)  // 加速/匀速
        {
            if (pCurveX2->f32SpdRef < pCurveX2->s32SpdMax)
            {
                pCurveX2->f32SpdRef += pCurveX2->f32Acc;
            }

            if (pCurveX2->f32SpdRef > pCurveX2->s32SpdMax)
            {
                pCurveX2->f32SpdRef = pCurveX2->s32SpdMax;
            }

            // v^2 = 2ax
            pCurveX2->s64DecPos = pCurveX2->f32SpdRef * pCurveX2->f32SpdRef / pCurveX2->f32Dec / 2;  // 开始减速位置
        }
        else  // 减速
        {
            pCurveX2->f32SpdRef -= pCurveX2->f32Dec;

            if (pCurveX2->f32SpdRef < 0)
            {
                pCurveX2->f32SpdRef = 0;
            }
        }

        pCurveX2->f32PosOut += pCurveX2->f32SpdRef;

        pCurveX2->s64PosOut_o = pCurveX2->f32PosOut;

        if (pCurveX2->s64PosOut_o > pCurveX2->s64PosRef_i)
        {
            pCurveX2->s64PosOut_o = pCurveX2->s64PosRef_i;
        }
    }
    else if (s64PosDelta < 0)  // 反向运动
    {
        if (s64PosDelta < pCurveX2->s64DecPos)  // 加速/匀速
        {
            if (pCurveX2->f32SpdRef > -pCurveX2->s32SpdMax)
            {
                pCurveX2->f32SpdRef -= pCurveX2->f32Acc;
            }

            if (pCurveX2->f32SpdRef < -pCurveX2->s32SpdMax)
            {
                pCurveX2->f32SpdRef = -pCurveX2->s32SpdMax;
            }

            // v^2 = 2ax
            pCurveX2->s64DecPos = -pCurveX2->f32SpdRef * pCurveX2->f32SpdRef / pCurveX2->f32Dec / 2;  // 开始减速位置
        }
        else  // 减速
        {
            pCurveX2->f32SpdRef += pCurveX2->f32Dec;

            if (pCurveX2->f32SpdRef > 0)
            {
                pCurveX2->f32SpdRef = 0;
            }
        }

        pCurveX2->f32PosOut += pCurveX2->f32SpdRef;

        pCurveX2->s64PosOut_o = pCurveX2->f32PosOut;

        if (pCurveX2->s64PosOut_o < pCurveX2->s64PosRef_i)
        {
            pCurveX2->s64PosOut_o = pCurveX2->s64PosRef_i;
        }
    }
    else
    {
        pCurveX2->f32SpdRef   = 0;
        pCurveX2->s64PosOut_o = pCurveX2->s64PosRef_i;
    }
}

static void _PosRefSel(path_plan_t* pPathPlan)
{
    axis_para_t* pAxisPara = pPathPlan->pAxisPara;

    pos_plan_curve_t* pCurveX2 = &pPathPlan->sPosPlanCurveX2;

    s64 s64PosRef = 0;

    if (pAxisPara->bPwmSwSts)
    {
        switch (pAxisPara->eLogicPosPlanMode)
        {
            case POS_PLAN_MODE_CURVE_X2:
            {
                pCurveX2->s64PosRef_i = pAxisPara->s64LogicPosRef;  // TODO 传入数字限位后的指令

                _PosPlanCurveParaCalc(pCurveX2);
                _PosPlanCurveX2Proc(pCurveX2);

                s64PosRef = pCurveX2->s64PosOut_o;

                break;
            }
            case POS_PLAN_MODE_CURVE_SIN:
            {
                break;
            }
            default:
            case POS_PLAN_MODE_STEP:
            {
                s64PosRef = pAxisPara->s64LogicPosRef;
                break;
            }
            case POS_PLAN_MODE_SLOPE:
            {
                break;
            }
        }
    }

    // 规划层输出
    pAxisPara->s64PlanPosRef = s64PosRef;
}

static void _SpdPlanSlopeParaCalc(spd_plan_slope_t* pSlope)
{
    if ((pSlope->u16AccTime != *pSlope->pu16AccTime_i) || (pSlope->u16DecTime != *pSlope->pu16DecTime_i) || (pSlope->s32SpdTgt != *pSlope->ps32SpdTgt_i))
    {
        pSlope->u16AccTime = *pSlope->pu16AccTime_i;
        pSlope->u16DecTime = *pSlope->pu16DecTime_i;
        pSlope->s32SpdTgt  = *pSlope->ps32SpdTgt_i;

        /**
         * @note AccTime/DecTime
         *
         *  指的是速度指令从'0'到'加减速参考速度'所需要的时间
         *  而不是指速度指令从'0'到'给定速度'所需要的时间
         *
         */

        if (pSlope->u16AccTime <= 1e2)  // [0ms,100ms] => 每次速度环中断都规划1次
        {
            pSlope->u16AccTick = 0;
            pSlope->u16AccRate = __ACC_DEC_SPD_ZOOM * __ACC_DEC_SPD_REF / __SPD_LOOP_MS(pSlope->u16AccTime);
        }
        else if (pSlope->u16AccTime <= 1e4)  // (100ms,10s] => 速度规划次数/1ms
        {
            pSlope->u16AccTick = __SPD_LOOP_MS(1);
            pSlope->u16AccRate = 1 * __ACC_DEC_SPD_ZOOM * __ACC_DEC_SPD_REF / pSlope->u16AccTime;
        }
        else if (pSlope->u16AccTime <= 4e4)  // (10s,40s] => 速度规划次数/4ms
        {
            pSlope->u16AccTick = __SPD_LOOP_MS(4);
            pSlope->u16AccRate = 4 * __ACC_DEC_SPD_ZOOM * __ACC_DEC_SPD_REF / pSlope->u16AccTime;
        }
        else  // (40s,65.535s] => 速度规划次数/8ms
        {
            pSlope->u16AccTick = __SPD_LOOP_MS(8);
            pSlope->u16AccRate = 8 * __ACC_DEC_SPD_ZOOM * __ACC_DEC_SPD_REF / pSlope->u16AccTime;
        }

        if (pSlope->u16DecTime <= 1e2)  // [0ms,100ms] => 每次速度环中断都规划1次
        {
            pSlope->u16DecTick = 0;
            pSlope->u16DecRate = __ACC_DEC_SPD_ZOOM * __ACC_DEC_SPD_REF / __SPD_LOOP_MS(pSlope->u16DecTime);
        }
        else if (pSlope->u16DecTime <= 1e4)  // (100ms,10s] => 速度规划次数/1ms
        {
            pSlope->u16DecTick = __SPD_LOOP_MS(1);
            pSlope->u16DecRate = 1 * __ACC_DEC_SPD_ZOOM * __ACC_DEC_SPD_REF / pSlope->u16DecTime;
        }
        else if (pSlope->u16DecTime <= 4e4)  // (10s,40s] => 速度规划次数/4ms
        {
            pSlope->u16DecTick = __SPD_LOOP_MS(4);
            pSlope->u16DecRate = 4 * __ACC_DEC_SPD_ZOOM * __ACC_DEC_SPD_REF / pSlope->u16DecTime;
        }
        else  // (40s,65.535s] => 速度规划次数/8ms
        {
            pSlope->u16DecTick = __SPD_LOOP_MS(8);
            pSlope->u16DecRate = 8 * __ACC_DEC_SPD_ZOOM * __ACC_DEC_SPD_REF / pSlope->u16AccTime;
        }

        pSlope->bFinish = false;
    }
}

static void _SpdPlanSlopeProc(spd_plan_slope_t* pSlope)
{
    if (pSlope->bFinish == true)
    {
        return;
    }

    if (pSlope->u16TimeTicks > 0)
    {
        pSlope->u16TimeTicks--;

        if (pSlope->u16TimeTicks > 0)
        {
            return;
        }
    }

    RO s32 s32SpdDelta = pSlope->s32SpdTgt - pSlope->s32SpdOut_o;

    if (s32SpdDelta > 0)
    {
        if (pSlope->s32SpdTgt > 0)
        {
            if (pSlope->s32SpdOut_o >= 0)  // 加速
            {
                /**
                 *        |       *        *
                 *   ---- 0 ---- Out ---- Tgt ----
                 */

                pSlope->u16TimeTicks = pSlope->u16AccTick;
                pSlope->s32SpdOutZoom += pSlope->u16AccRate;
            }
            else  // 先减后加
            {
                /**
                 *         *       |       *
                 *   ---- Out ---- 0 ---- Tgt ----
                 */

                pSlope->u16TimeTicks = pSlope->u16DecTick;
                pSlope->s32SpdOutZoom += pSlope->u16DecRate;
            }
        }
        else  // 减速
        {
            /**
             *         *        *       |
             *   ---- Out ---- Tgt ---- 0 ----
             */

            pSlope->u16TimeTicks = pSlope->u16DecTick;
            pSlope->s32SpdOutZoom += pSlope->u16DecRate;
        }

        if (pSlope->s32SpdOutZoom > pSlope->s32SpdTgt * __ACC_DEC_SPD_ZOOM)
        {
            pSlope->s32SpdOutZoom = pSlope->s32SpdTgt * __ACC_DEC_SPD_ZOOM;
        }
    }
    else if (s32SpdDelta < 0)
    {
        if (pSlope->s32SpdTgt >= 0)  // 减速
        {
            /**
             *        |       *        *
             *   ---- 0 ---- Tgt ---- Out ----
             */

            pSlope->u16TimeTicks = pSlope->u16DecTick;
            pSlope->s32SpdOutZoom -= pSlope->u16DecRate;
        }
        else
        {
            if (pSlope->s32SpdOut_o <= 0)  // 加速
            {
                /**
                 *         *        *       |
                 *   ---- Tgt ---- Out ---- 0 ----
                 */

                pSlope->u16TimeTicks = pSlope->u16AccTick;
                pSlope->s32SpdOutZoom -= pSlope->u16AccRate;
            }
            else  // 先减后加
            {
                /**
                 *         *       |       *
                 *   ---- Tgt ---- 0 ---- Out ----
                 */

                pSlope->u16TimeTicks = pSlope->u16DecTick;
                pSlope->s32SpdOutZoom -= pSlope->u16DecRate;
            }
        }

        if (pSlope->s32SpdOutZoom < pSlope->s32SpdTgt * __ACC_DEC_SPD_ZOOM)
        {
            pSlope->s32SpdOutZoom = pSlope->s32SpdTgt * __ACC_DEC_SPD_ZOOM;
        }
    }
    else
    {
        pSlope->bFinish = true;  // 规划完成
        return;
    }

    // 对于没有硬件除法的 MCU，除法很耗时，应当少执行。
    pSlope->s32SpdOut_o = pSlope->s32SpdOutZoom / __ACC_DEC_SPD_ZOOM;
}

static void _SpdPlanCurveParaCalc(spd_plan_curve_t* pCurve)
{
    if ((pCurve->bDecToZero == true && pCurve->bFinish == true) ||
        (pCurve->u16AccTime != *pCurve->pu16AccTime_i) ||
        (pCurve->u16DecTime != *pCurve->pu16DecTime_i) ||
        (pCurve->s32SpdTgt != *pCurve->ps32SpdTgt_i))
    {
        s32 s32SpdDelta;
        u32 u32AccDecTime;

        pCurve->s32V0 = pCurve->s32SpdOut_o;  // 初速度

        pCurve->u16AccTime = *pCurve->pu16AccTime_i;
        pCurve->u16DecTime = *pCurve->pu16DecTime_i;
        pCurve->s32SpdTgt  = *pCurve->ps32SpdTgt_i;

        if (pCurve->s32V0 > 0)
        {
            if (pCurve->s32SpdTgt < 0)  // 反向减速
            {
                pCurve->bDecToZero = true;
                u32AccDecTime      = pCurve->u16DecTime;
                s32SpdDelta        = 0 - pCurve->s32V0;
            }
            else if (pCurve->s32SpdTgt >= pCurve->s32V0)  // 同向加速
            {
                pCurve->bDecToZero = false;
                u32AccDecTime      = pCurve->u16AccTime;
                s32SpdDelta        = pCurve->s32SpdTgt - pCurve->s32V0;
            }
            else  // 同向减速
            {
                pCurve->bDecToZero = false;
                u32AccDecTime      = pCurve->u16DecTime;
                s32SpdDelta        = pCurve->s32SpdTgt - pCurve->s32V0;
            }
        }
        else if (pCurve->s32V0 < 0)
        {
            if (pCurve->s32SpdTgt > 0)  // 反向减速
            {
                pCurve->bDecToZero = true;
                u32AccDecTime      = pCurve->u16DecTime;
                s32SpdDelta        = 0 - pCurve->s32V0;
            }
            else if (pCurve->s32SpdTgt <= pCurve->s32V0)  // 同向加速
            {
                pCurve->bDecToZero = false;
                u32AccDecTime      = pCurve->u16AccTime;
                s32SpdDelta        = pCurve->s32SpdTgt - pCurve->s32V0;
            }
            else  // 同向减速
            {
                pCurve->bDecToZero = false;
                u32AccDecTime      = pCurve->u16DecTime;
                s32SpdDelta        = pCurve->s32SpdTgt - pCurve->s32V0;
            }
        }
        else  // 加速
        {
            pCurve->bDecToZero = false;
            u32AccDecTime      = pCurve->u16AccTime;
            s32SpdDelta        = pCurve->s32SpdTgt - pCurve->s32V0;
        }

        pCurve->u32T2 = CONFIG_SPD_LOOP_FREQ_HZ * abs(s32SpdDelta) * u32AccDecTime / 1000 / __ACC_DEC_SPD_REF;
        pCurve->f32T1 = pCurve->u32T2 * 0.5f;
        pCurve->u32Tn = 0;

        if (pCurve->u32T2 == 0)
        {
            pCurve->f32T1Sq = 0.f;
            pCurve->f32T1Cu = 0.f;

            pCurve->f32J = s32SpdDelta;
        }
        else
        {
            pCurve->f32T1Sq = pCurve->f32T1 * pCurve->f32T1;
            pCurve->f32T1Cu = pCurve->f32T1Sq * pCurve->f32T1;

            if (pCurve->eMode == SPD_PLAN_MODE_CURVE_X2)
            {
                // 单位: rpm/Tspd^2
                pCurve->f32J = s32SpdDelta / pCurve->f32T1Sq;  // 加加速度
            }
            else  // SPD_PLAN_MODE_CURVE_X3
            {
                // 单位: rpm/Tspd^3
                pCurve->f32J = s32SpdDelta / pCurve->f32T1Cu * 1.5f;  // 加加速度
            }
        }

        pCurve->bFinish = false;
    }
}

static void _SpdPlanCurveX2Proc(spd_plan_curve_t* pCurveX2)
{
    if (pCurveX2->bFinish == true)
    {
        return;
    }

    if (pCurveX2->u32Tn == 0)
    {
        pCurveX2->s32SpdOut_o = pCurveX2->s32V0;
    }
    else if (pCurveX2->u32Tn <= (pCurveX2->u32T2 / 2))
    {
        // V = V0 + J * Tn * Tn / 2;
        pCurveX2->s32SpdOut_o = pCurveX2->s32V0 + pCurveX2->f32J * pCurveX2->u32Tn * pCurveX2->u32Tn / 2;
    }
    else if (pCurveX2->u32Tn <= pCurveX2->u32T2)
    {
        // V = V0 + J * T2 * Tn - J * T1 * T1 - J * Tn * Tn / 2;

        // V = V0 + J * T1 * 2 * T - J * T1 * T1 - J * T * T / 2;

        pCurveX2->s32SpdOut_o = pCurveX2->s32V0 +
                                pCurveX2->f32J * pCurveX2->u32T2 * pCurveX2->u32Tn -
                                pCurveX2->f32J * pCurveX2->f32T1 * pCurveX2->f32T1 -
                                pCurveX2->f32J * pCurveX2->u32Tn * pCurveX2->u32Tn / 2;
    }
    else
    {
        pCurveX2->bFinish = true;
    }

    pCurveX2->u32Tn++;
}

static void _SpdPlanCurveX3Proc(spd_plan_curve_t* pCurveX3)
{
    if (pCurveX3->bFinish == true)
    {
        return;
    }

#if 0

    u32 u32TnSq = pCurveX3->u32Tn * pCurveX3->u32Tn;
    u32 u32TnCu = u32TnSq * pCurveX3->u32Tn;

    if (pCurveX3->u32Tn == 0)
    {
        pCurveX3->s32SpdOut_o = pCurveX3->s32V0;
    }
    else if (pCurveX3->u32Tn <= (pCurveX3->u32T2 / 2))
    {
        // V = V0 + J * T1 * Tn * Tn / 2 - J * Tn * Tn * Tn / 6;
        pCurveX3->s32SpdOut_o = pCurveX3->s32V0 + pCurveX3->f32J * pCurveX3->f32T1 * u32TnSq / 2 - pCurveX3->f32J * u32TnCu / 6;
    }
    else if (pCurveX3->u32Tn <= pCurveX3->u32T2)
    {
        // V = V0 + J * T1Cu / 3 + J * T1Sq * (Tn - T1) / 2 - J * (Tn - T1) * (Tn - T1) * (Tn - T1) / 6;
        pCurveX3->s32SpdOut_o = pCurveX3->s32V0 +
                                pCurveX3->f32J * pCurveX3->f32T1Cu / 3 +
                                pCurveX3->f32J * pCurveX3->f32T1Sq * (pCurveX3->u32Tn - pCurveX3->f32T1) / 2 -
                                pCurveX3->f32J * (pCurveX3->u32Tn - pCurveX3->f32T1) * (pCurveX3->u32Tn - pCurveX3->f32T1) * (pCurveX3->u32Tn - pCurveX3->f32T1) / 6;
    }
    else
    {
        pCurveX3->bFinish = true;
    }

#else

    // https://zh.numberempire.com/simplifyexpression.php

    // V = V0 + J * T1 * Tn * Tn / 2 - J * Tn * Tn * Tn / 6;
    //   = V0 + (3 * J * T1 * Tn * Tn - J * Tn * Tn * Tn) / 6;

    // V = V0 + J * T1 * T1 * T1 / 3 + J * T1 * T1 * (T - T1) / 2 - J * (T - T1) * (T - T1) * (T - T1) / 6;
    //   = V0 + (3 * J * Tn * Tn * T1 - J * Tn * Tn * Tn) / 6

    if (pCurveX3->u32Tn <= pCurveX3->u32T2)
    {
        pCurveX3->s32SpdOut_o = pCurveX3->s32V0 + pCurveX3->f32J * pCurveX3->u32Tn * pCurveX3->u32Tn * (3 * pCurveX3->f32T1 - pCurveX3->u32Tn) / 6;
    }
    else
    {
        pCurveX3->bFinish = true;
    }

#endif

    pCurveX3->u32Tn++;
}

static void _SpdRefSel(path_plan_t* pPathPlan)
{
    axis_para_t* pAxisPara = pPathPlan->pAxisPara;

    s32 s32SpdRef = 0;

    spd_plan_slope_t* pSlope   = &pPathPlan->sSpdPlanSlope;
    spd_plan_curve_t* pCurveX2 = &pPathPlan->sSpdPlanCurveX2;
    spd_plan_curve_t* pCurveX3 = &pPathPlan->sSpdPlanCurveX3;

    if (pAxisPara->bPwmSwSts)
    {
        switch (pAxisPara->eLogicCtrlMode)
        {
            case CTRL_MODE_SPD:
            {
                switch (pAxisPara->eLogicSpdPlanMode)
                {
                    case SPD_PLAN_MODE_SLOPE:  // 一次斜坡函数规划
                    {
                        _SpdPlanSlopeParaCalc(pSlope);
                        _SpdPlanSlopeProc(pSlope);

                        s32SpdRef = pSlope->s32SpdOut_o;

                        break;
                    }

                    case SPD_PLAN_MODE_CURVE_X3:  // 三次多项式曲线规划
                    {
                        _SpdPlanCurveParaCalc(pCurveX3);
                        _SpdPlanCurveX3Proc(pCurveX3);

                        s32SpdRef = pCurveX3->s32SpdOut_o;

                        break;
                    }

                    case SPD_PLAN_MODE_CURVE_X2:  // 二次多项式曲线规划
                    {
                        _SpdPlanCurveParaCalc(pCurveX2);
                        _SpdPlanCurveX2Proc(pCurveX2);

                        s32SpdRef = pCurveX2->s32SpdOut_o;

                        break;
                    }

                    default:
                    case SPD_PLAN_MODE_STEP:  // 阶跃
                    {
                        s32SpdRef = pAxisPara->s32LogicSpdRef;

                        break;
                    }
                }

                break;
            }
        }
    }
    else
    {
        pSlope->s32SpdOut_o   = 0;
        pSlope->s32SpdTgt     = 0;
        pSlope->s32SpdOutZoom = 0;
        pSlope->u16TimeTicks  = 0;

        pCurveX2->s32SpdOut_o = 0;
        pCurveX2->s32SpdTgt   = 0;

        pCurveX3->s32SpdOut_o = 0;
        pCurveX3->s32SpdTgt   = 0;
    }

    // 规划层输出
    pAxisPara->s32PlanSpdRef = s32SpdRef;
}

static void _TrqRefPu(path_plan_t* pPathPlan)
{
    axis_para_t* pAxisPara = pPathPlan->pAxisPara;

    s16 s16IqRef = 0;
    s16 s16IdRef = 0;

    if (pAxisPara->bPwmSwSts)
    {
        s16IqRef = (s32)pAxisPara->u16CurRateDigMot * (s32)pAxisPara->s16LogicTrqRef / 1000;   // 千分比转Q15标幺值
        s16IdRef = (s32)pAxisPara->u16CurRateDigMot * (s32)pAxisPara->s16LogicFluxRef / 1000;  // 千分比转Q15标幺值
    }

    // 规划层输出
    pAxisPara->s16PlanIqRef = s16IqRef;
    pAxisPara->s16PlanIdRef = s16IdRef;
}

void PathPlanCreat(path_plan_t* pPathPlan, axis_para_t* pAxisPara)
{
    pPathPlan->pAxisPara = pAxisPara;

    {
        spd_plan_slope_t* pSlope   = &pPathPlan->sSpdPlanSlope;
        spd_plan_curve_t* pCurveX2 = &pPathPlan->sSpdPlanCurveX2;
        spd_plan_curve_t* pCurveX3 = &pPathPlan->sSpdPlanCurveX3;

        pSlope->ps32SpdTgt_i  = &pAxisPara->s32LogicSpdRef;
        pSlope->pu16AccTime_i = &pAxisPara->u16LogicSpdAccTime;
        pSlope->pu16DecTime_i = &pAxisPara->u16LogicSpdDecTime;

        pCurveX2->eMode         = SPD_PLAN_MODE_CURVE_X2;
        pCurveX2->ps32SpdTgt_i  = pSlope->ps32SpdTgt_i;
        pCurveX2->pu16AccTime_i = pSlope->pu16AccTime_i;
        pCurveX2->pu16DecTime_i = pSlope->pu16DecTime_i;

        pCurveX3->eMode         = SPD_PLAN_MODE_CURVE_X3;
        pCurveX3->ps32SpdTgt_i  = pSlope->ps32SpdTgt_i;
        pCurveX3->pu16AccTime_i = pSlope->pu16AccTime_i;
        pCurveX3->pu16DecTime_i = pSlope->pu16DecTime_i;
    }

    {
        pos_plan_curve_t* pCurveX2 = &pPathPlan->sPosPlanCurveX2;

        pCurveX2->ps16SpdLim_i  = &pAxisPara->u16PosPlanSpdMax;
        pCurveX2->pu32EncRes_i  = &pAxisPara->u32EncRes;
        pCurveX2->pu16AccTime_i = &pAxisPara->u16LogicSpdAccTime;
        pCurveX2->pu16DecTime_i = &pAxisPara->u16LogicSpdDecTime;

        pCurveX2->pAxisPara = pAxisPara;
    }
}

void PathPlanInit(path_plan_t* pPathPlan)
{
}

void PathPlanCycle(path_plan_t* pPathPlan)
{
    axis_para_t* pAxisPara = pPathPlan->pAxisPara;

    switch (pAxisPara->eLogicCtrlMode)
    {
        case CTRL_MODE_POS:
        {
            break;
        }

        case CTRL_MODE_SPD:
        {
            // 速度反馈达到检测
            // 零速检测到达
            break;
        }

        case CTRL_MODE_TRQ:
        {
            break;
        }
    }
}

void PathPlanIsr(path_plan_t* pPathPlan)
{
    axis_para_t* pAxisPara = pPathPlan->pAxisPara;

    switch (pAxisPara->eLogicCtrlMode)
    {
        case CTRL_MODE_POS:
        {
            // 位置指令
            _PosRefSel(pPathPlan);

            break;
        }

        case CTRL_MODE_SPD:
        {
            // 速度指令
            _SpdRefSel(pPathPlan);

            break;
        }

        case CTRL_MODE_TRQ:
        {
            // 转矩指令
            _TrqRefPu(pPathPlan);

            break;
        }
    }
}
