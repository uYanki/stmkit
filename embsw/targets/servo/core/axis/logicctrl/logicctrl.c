#include "logicctrl.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "logicctrl"
#define LOG_LOCAL_LEVEL LOG_LEVELNFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

typedef struct {
    u16 u16CurRate;  // 额定电流

    u16 u16VoltRateIn;  // 额定电压

    u16 u16IphHwCoeff;   // 相电流采样系数
    u16 u16UmdcHwCoeff;  // 主回路母线电压采样系数

    u16 u16PwmCarryFreq;  // 载波频率 [0.1Hz]
    u16 u16PwmDeadzone;   // 死区时间 [0.1us]
} DrvPara_t;

// clang-format off

static const DrvPara_t aDrvPara[2] = {
    {0},
};

static const MotEncPara_t aMotEncPara[2] = {
    [0] = { // MOT_2804_ENC_MT6701
        .u16MotPolePairs  = 7,
        .u32MotInertia    = 0,
        .u16MotStatorRes  = 5100,  // 相电阻 5.1Ω
        .u16MotStatorLd   = 280,   // 相电感 2.8mH
        .u16MotStatorLq   = 280,
        .u16MotEmfCoeff   = 0,
        .u16MotTrqCoeff   = 0,
        .u16MotTm         = 0,
        .u16MotVoltInRate = 12,  // 12V
        .u16MotPowerRate  = 0,
        .u16MotCurRate    = 100, // 1.5A
        .u16MotCurMax     = 300, // 3.0A
        .u16MotTrqRate    = 0,
        .u16MotTrqMax     = 0,
        .u16MotSpdRate    = 3000,  // rpm
        .u16MotSpdMax     = 4000,  // rpm
        .u16MotAccMax     = 0,
        .u16EncSN         = 0,
        .u16EncMethod     = 2,      // 磁编
        .u16EncType       = ENC_ABS_MT6701,  // 14b mt6701
        .u32EncRes        = 16384,  // pulse
        .u32EncPosOffset  = 656,
    },
    [1] = { 
        0,
    },
};

// clang-format on

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

static void _PosRefSelGear(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    s64 s64PosRef = 0;

    if (pAxisPara->bLogicStopCmd)  // 停机启动
    {
        s64PosRef = pAxisPara->s32StopPosRef;
    }
    else if (pAxisPara->bLogicJogFwdCmd || pAxisPara->bLogicJogRevCmd)
    {
        // 以防点动信号撤销后跑原位置
        s64PosRef = pAxisPara->s64DrvPosFb;
    }
#if CONFIG_DS402_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_DS402)
    {
    }
#endif
#if CONFIG_PROFINET_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_PROFINET)
    {
    }
#endif
    else
    {
        switch (pAxisPara->ePosRefSrc)
        {
            case POS_REF_SRC_DIGITAL:  // 数字指令
            {
                ///< @note 需要判断触发方式

                switch (pAxisPara->ePosDigRefType)
                {
                    case POS_REF_TYPE_ABSOLUTE:  // 绝对位置
                    {
                        switch (pAxisPara->ePosRefSet)
                        {
                            case POS_REF_SET_IMMEDIATELY:  // 立即生效
                            {
                                s64PosRef = he64(pLogicCtrl->pAppConf->ps64PosRef);
                                break;
                            }
                            case POS_REF_SET_TRIGGER:  // 触发生效
                            {
#if 0  // 触发用哪个变量??

                                if (pLogicCtrl->ePosRefSetPre ^ ePosRefSet)
                                {
                                    pLogicCtrl->ePosRefSetPre = ePosRefSet;

                                    if (pAxisPara->bPosRefSet)  // 上升沿触发
                                    {
                                        OBJCPY64(&s64PosRef, pLogicCtrl->ps64PosDigRef);
                                        break;
                                    }
                                }

#else

                                return;

#endif
                            }
                        }
                        break;
                    }

                    case POS_REF_TYPE_RELATIVE:  // 相对位置
                    {
                        bool ePosRefSet = pAxisPara->ePosRefSet;

                        if (pAxisPara->bLogicPosRevokeCmd)
                        {
                            {
                                // 相对位置指令撤销命令, 赋反馈位置
                                s64PosRef = pAxisPara->s64DrvPosFb;
                            }
                        }
                        else if (pLogicCtrl->ePosRefSetPre ^ ePosRefSet)  // 触发指令
                        {
                            pLogicCtrl->ePosRefSetPre = ePosRefSet;

                            if (ePosRefSet)  // 上升沿触发
                            {
                                s64PosRef = pAxisPara->s64DrvPosFb + *pLogicCtrl->pAppConf->ps64PosRef;
                            }
                        }

                        break;
                    }
                }

                break;
            }

            case POS_REF_SRC_MULTI_DIGITAL:  // 多段数字指令
            {
                ///< @note 不需要判断触发方式

                if (pAxisPara->bLogicMultMotionEn)  // 多段启动
                {
                    u16 u16PosMulRefSel = pAxisPara->u16PosMulRefSel;

                    switch (pAxisPara->ePosDigRefType)
                    {
                        case POS_REF_TYPE_ABSOLUTE:  // 绝对位置
                        {
                            s64PosRef = (&pAxisPara->s64PosDigRef01)[u16PosMulRefSel];
                            break;
                        }

                        case POS_REF_TYPE_RELATIVE:  // 相对位置
                        {
                            if (pAxisPara->bLogicPosRevokeCmd)
                            {
                                // 相对位置指令撤销命令, 赋反馈位置
                                s64PosRef = pAxisPara->s64DrvPosFb;
                            }
                            else if (pLogicCtrl->u16MultiRefSelPre ^ u16PosMulRefSel)  // 多段切换
                            {
                                pLogicCtrl->u16MultiRefSelPre = u16PosMulRefSel;

                                s64PosRef = (&pAxisPara->s64PosDigRef01)[u16PosMulRefSel] + pAxisPara->s64DrvPosFb;
                            }

                            break;
                        }
                    }
                }
                else  // 多段停止, 赋反馈位置
                {
                    s64PosRef = pAxisPara->s64DrvPosFb;
                }

                break;
            }

            case POS_REF_SRC_PULSE:  // 外部脉冲指令(预留)
            {
                // s64PosRef = pLogicCtrl->PosCtrlIn.sPulseRef.s64Out;
                break;
            }
        }
    }

    // 齿轮比
    s64 s64LogicPosRefGear = s64PosRef;

    if (pAxisPara->u32ElecGearDeno > 0)
    {
        s64LogicPosRefGear = s64LogicPosRefGear * (s64)pAxisPara->u32ElecGearNum / (s64)pAxisPara->u32ElecGearDeno;
    }

    // 逻辑层输出
    pAxisPara->s64LogicPosRef     = s64PosRef;
    pAxisPara->s64LogicPosRefGear = s64LogicPosRefGear;
}

static void _PosLimSelGear(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    s64 s64PosDigLimFwdGear = pAxisPara->s64PosLimFwd;
    s64 s64PosDigLimRevGear = pAxisPara->s64PosLimRev;

    if (pAxisPara->u32ElecGearDeno > 0)
    {
        s64PosDigLimFwdGear = s64PosDigLimFwdGear * (s64)(pAxisPara->u32ElecGearNum) / (s64)(pAxisPara->u32ElecGearDeno);
        s64PosDigLimRevGear = s64PosDigLimRevGear * (s64)(pAxisPara->u32ElecGearNum) / (s64)(pAxisPara->u32ElecGearDeno);
    }

    // 逻辑层输出
    pAxisPara->s64LogicPosDigLimFwdGear = s64PosDigLimFwdGear;
    pAxisPara->s64LogicPosDigLimRevGear = s64PosDigLimRevGear;
}

static void _PosPlanModeSel(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    pos_plan_mode_e ePosPlanMode = *pLogicCtrl->pAppConf->pePosPlanMode;

    // 逻辑层输出
    pAxisPara->eLogicPosPlanMode = ePosPlanMode;
}

static void _SpdRefSel(logic_ctrl_t* pLogicCtrl)
{
    device_para_t* pDevicePara = pLogicCtrl->pDevicePara;
    axis_para_t*   pAxisPara   = pLogicCtrl->pAxisPara;

    s32 s32SpdRef = 0;

    if (pAxisPara->bLogicStopCmd)  // 停机
    {
        s32SpdRef = 0;
    }
    else if (pAxisPara->bLogicJogFwdCmd)  // 正向点动
    {
        s32SpdRef = (s32)pAxisPara->u16JogSpdDigRef;
    }
    else if (pAxisPara->bLogicJogRevCmd)  // 反向点动
    {
        s32SpdRef = -(s32)pAxisPara->u16JogSpdDigRef;
    }
#if CONFIG_DS402_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_DS402)
    {
        s32SpdRef = pAxisPara->slTargetVelocity_60FF;  // 速度指令

        if (pAxisPara->sbModesOperaDisp_6061 == DS402_MODE_CSV)
        {
            s32SpdRef += pAxisPara->slVelocityOffset_60B1;  // 速度偏置
        }

        if (pAxisPara->ubPolarity_607E & BV(5))  // 指令极性
        {
            s32SpdRef = -s32SpdRef;
        }

        s32SpdRef = s32SpdRef * MIN_SEC_COEFF / (s32)pAxisPara->u32EncRes;  // pulse/s => rpm
    }
#endif
#if CONFIG_PROFINET_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_PROFINET)
    {
    }
#endif
    else  // 通用控制
    {
        switch (pAxisPara->eSpdRefSrc)
        {
            case SPD_REF_SRC_DIGITAL:  // 数字量
            {
                s32SpdRef = *pLogicCtrl->pAppConf->ps16SpdRef;
                break;
            }

            case SPD_REF_SRC_MULTI_DIGITAL:  // 多段数字量
            {
                if (pAxisPara->bLogicMultMotionEn)  // 多段启动
                {
                    s32SpdRef = (&pAxisPara->s16SpdDigRef01)[pAxisPara->u16SpdMulRefSel];
                }

                break;
            }

#if CONFIG_EXT_AI_NUM > 0
            case SPD_REF_SRC_AI_1:  // 模拟量
            {
                s32SpdRef = (s32)pDevicePara->s16UaiSi0 * (s32)pAxisPara->u16AiSpdCoeff0 / 100;
                break;
            }
#endif

#if CONFIG_EXT_AI_NUM > 1
            case SPD_REF_SRC_AI_2:  // 模拟量
            {
                s32SpdRef = (s32)pDevicePara->s16UaiSi1 * (s32)pAxisPara->u16AiSpdCoeff1 / 100;
                break;
            }
#endif
        }
    }

    // 逻辑层输出
    pAxisPara->s32LogicSpdRef = s32SpdRef;
}

static void _SpdLimSel(logic_ctrl_t* pLogicCtrl)
{
    device_para_t* pDevicePara = pLogicCtrl->pDevicePara;
    axis_para_t*   pAxisPara   = pLogicCtrl->pAxisPara;

    s32 s32LimFwd = 0;
    s32 s32LimRev = 0;

    s32 s32MotMaxSpd;

#if CONFIG_DS402_CTRL_SW
    if (pAxisPara->eLogicCtrlMode == CTRL_MODE_DS402)
    {
        if (pAxisPara->sbModesOperaDisp_6061 == DS402_MODE_PVM ||
            pAxisPara->sbModesOperaDisp_6061 == DS402_MODE_CSV)
        {
            s32LimFwd = (s32)pAxisPara->ulMaxProfileVelocity_607F * MIN_SEC_COEFF / (s32)pAxisPara->u32EncRes;  // 速度限制, pulse/s => rpm
        }

        s32LimRev = -s32LimFwd;
    }
#endif
#if CONFIG_PROFINET_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_PROFINET)
    {
    }
#endif
    else
    {
        switch (pAxisPara->eSpdLimSrc)
        {
            default:
            case SPD_LIM_S:  // 单数字量
            {
                s32LimFwd = +(s32)pAxisPara->u16SpdLimFwd;
                s32LimRev = -s32LimFwd;
                break;
            }
            case SPD_LIM_M:  // 双数字量
            {
                s32LimFwd = +(s32)pAxisPara->u16SpdLimFwd;
                s32LimRev = -(s32)pAxisPara->u16SpdLimRev;
                break;
            }
#if CONFIG_EXT_AI_NUM > 0
            case SPD_LIM_AI_S:  // 单模拟量
            {
                s32LimFwd = +(s32)pDevicePara->s16UaiSi0 * (s32)pAxisPara->u16AiSpdCoeff0 / 100;
                s32LimRev = -s32LimRev;
                break;
            }
#endif
#if CONFIG_EXT_AI_NUM > 1
            case SPD_LIM_AI_M:  // 双模拟量
            {
                s32LimFwd = +(s32)pDevicePara->s16UaiSi0 * (s32)pAxisPara->u16AiSpdCoeff0 / 100;
                s32LimRev = -(s32)pDevicePara->s16UaiSi1 * (s32)pAxisPara->u16AiSpdCoeff1 / 100;
                break;
            }
#endif
        }
    }

    // 电机最大速度
    s32MotMaxSpd = (s32)pAxisPara->u16MotSpdMax;

    if (s32LimFwd > s32MotMaxSpd)
    {
        s32LimFwd = s32MotMaxSpd;
    }
    if (s32LimFwd < -s32MotMaxSpd)
    {
        s32LimFwd = -s32MotMaxSpd;
    }

    // 最大速度缩放
    s32LimFwd = s32LimFwd * (s32)pAxisPara->u16SpdMaxGain / 100;
    s32LimRev = s32LimRev * (s32)pAxisPara->u16SpdMaxGain / 100;

    // 逻辑层输出
    pAxisPara->s32LogicSpdLimFwd = s32LimFwd;
    pAxisPara->s32LogicSpdLimRev = s32LimRev;
}

static void _SpdAccDecTimeSel(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    u16 u16SpdAccTime = 0;
    u16 u16SpdDecTime = 0;

    if (pAxisPara->bLogicStopCmd)  // 停机
    {
        u16SpdDecTime = pAxisPara->u16DecTime0;  // TODO: 待确认用哪个减速时间
    }
    else if (pAxisPara->bLogicJogFwdCmd || pAxisPara->bLogicJogRevCmd)  // 点动
    {
        u16SpdAccTime = pAxisPara->u16JogAccDecTime;
        u16SpdDecTime = pAxisPara->u16JogAccDecTime;
    }
#if CONFIG_DS402_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_DS402)
    {
        switch (pAxisPara->sbModesOperaDisp_6061)
        {
            case DS402_MODE_PPM:
            case DS402_MODE_PVM:
            {
                //
                // 加速到目标速度所需时间 t：
                //
                //                     1s = 1000ms                         rpm = rev/60s
                //    t * ms/1000rpm -----------------> t * s/1000000rpm -----------------> t * 60s^2/1000000rev ----> t * 60/1000000 * s^2/rev
                //
                //    => 转换系数 1000*1000/60
                //
                // u32EncRes/u32SpdAcc: s^2/rev
                //

                u32 u32SpdAcc = pAxisPara->ulProfileAcceleration_6083;     // 给定加速度 pulse/s^2
                u32 u32SpdDec = pAxisPara->ulProfileDeceleration_6084;     // 给定减速度 pulse/s^2
                u32 u32MaxAcc = pAxisPara->ulMaxProfileAcceleration_60C5;  // 最大加速度 pulse/s^2
                u32 u32MaxDec = pAxisPara->ulMaxProfileDeceleration_60C6;  // 最大减速度 pulse/s^2

                u32SpdAcc = CLAMP(u32SpdAcc, 1, u32MaxAcc);
                u32SpdDec = CLAMP(u32SpdDec, 1, u32MaxDec);

                // 加速到1000RPM所需时间
                u32 u32AccTime = 1000 * 1000 * pAxisPara->u32EncRes / MIN_SEC_COEFF / u32SpdAcc;  // ms
                u32 u32DecTime = 1000 * 1000 * pAxisPara->u32EncRes / MIN_SEC_COEFF / u32SpdDec;  // ms

                if (u32AccTime > U16_MAX)
                {
                    u32AccTime = U16_MAX;
                }

                if (u32DecTime > U16_MAX)
                {
                    u32DecTime = U16_MAX;
                }

                u16SpdAccTime = (u16)u32AccTime;
                u16SpdDecTime = (u16)u32DecTime;

                break;
            }

            case DS402_MODE_HMM:
            {
                u32 u32SpdAcc = pAxisPara->ulHomingAcceleration_609A;  // 回原加速度 pulse/s^2

                if (u32SpdAcc == 0)
                {
                    u32SpdAcc = 1;
                }

                u32 u32Time = 1000 * 1000 * pAxisPara->u32EncRes / MIN_SEC_COEFF / u32SpdAcc;  // ms

                if (u32Time > U16_MAX)
                {
                    u32Time = U16_MAX;
                }

                u16SpdAccTime = (u16)u32Time;
                u16SpdDecTime = (u16)u32Time;

                break;
            }

            case DS402_MODE_CSP:
            case DS402_MODE_CSV:
            {
                u16SpdAccTime = 50;  // 经验值
                u16SpdDecTime = 50;  // 经验值
                break;
            }
        }
    }
#endif
#if CONFIG_PROFINET_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_PROFINET)
    {
    }
#endif
    else  // 默认值
    {
        u16SpdAccTime = pAxisPara->u16AccTime0;
        u16SpdDecTime = pAxisPara->u16DecTime0;
    }

    // 逻辑层输出
    pAxisPara->u16LogicSpdAccTime = u16SpdAccTime;
    pAxisPara->u16LogicSpdDecTime = u16SpdDecTime;
}

static void _SpdPlanModeSel(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    spd_plan_mode_e ePlanMode;

    // TODO: 回原 SPD_PLAN_MODE_SLOPE

    if (pAxisPara->bLogicStopCmd)  // 停机
    {
        ePlanMode = (spd_plan_mode_e)pAxisPara->eStopPlanMode;
    }
    else if (pAxisPara->bLogicJogFwdCmd || pAxisPara->bLogicJogRevCmd)  // 点动
    {
        ePlanMode = SPD_PLAN_MODE_SLOPE;
    }
#if CONFIG_DS402_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_DS402)
    {
        if (pAxisPara->sbModesOperaDisp_6061 == DS402_MODE_CSV)
        {
            ePlanMode = (spd_plan_mode_e)pAxisPara->swMotionProfileType_6086;  // 速度规划模式

            if (ePlanMode > SPD_PLAN_MODE_STEP)
            {
                ePlanMode = SPD_PLAN_MODE_SLOPE;
            }
        }
        else
        {
            ePlanMode = SPD_PLAN_MODE_SLOPE;
        }
    }
#endif
#if CONFIG_PROFINET_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_PROFINET)
    {
    }
#endif
    else  // 默认
    {
        ePlanMode = *pLogicCtrl->pAppConf->peSpdPlanMode;
    }

    // 逻辑层输出
    pAxisPara->eLogicSpdPlanMode = ePlanMode;
}

static void _FluxRefSel(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    s16 s16FluxRef = 0;

    if (pAxisPara->bLogicStopCmd && pAxisPara->eStopMode == STOP_MODE_DB_FLUX)  // 磁通制动停机
    {
        s16FluxRef = 300;  // 自定义值
    }

    // 逻辑层输出
    pAxisPara->s16LogicFluxRef = s16FluxRef;
}

static void _TrqRefSel(logic_ctrl_t* pLogicCtrl)
{
    device_para_t* pDevicePara = pLogicCtrl->pDevicePara;
    axis_para_t*   pAxisPara   = pLogicCtrl->pAxisPara;

    s16 s16TrqRef = 0;

    if (pAxisPara->bLogicStopCmd)  // 反向转矩停机
    {
        if (pAxisPara->eStopMode == STOP_MODE_DB_TRQ)  // 反向转矩停机
        {
            if (pAxisPara->s32DrvSpdFb > 0)
            {
                s16TrqRef = -pAxisPara->u16EmStopTrqDigRef;
            }
            else
            {
                s16TrqRef = pAxisPara->u16EmStopTrqDigRef;
            }
        }
    }
#if CONFIG_DS402_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_DS402)
    {
        s16TrqRef = pAxisPara->swTargetTorque_6071;  // 目标转矩

        if (pAxisPara->sbModesOperaDisp_6061 == DS402_MODE_CST)
        {
            s16TrqRef += pAxisPara->slTorqueOffset_60B2;  // 转矩偏置
        }

        if (pAxisPara->ubPolarity_607E & BV(5))  // 指令极性
        {
            s16TrqRef = -s16TrqRef;
        }
    }
#endif
#if CONFIG_PROFINET_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_PROFINET)
    {}
#endif
    else
    {
        switch ((trq_ref_src_e)pAxisPara->eTrqRefSrc)
        {
            case TRQ_REF_SRC_DIGITAL:
            {
                s16TrqRef = *pLogicCtrl->pAppConf->ps16TrqRef;
                break;
            }
            case TRQ_REF_SRC_MULTI_DIGITAL:
            {
                if (pAxisPara->bLogicMultMotionEn)  // 多段启动
                {
                    s16TrqRef = (&pAxisPara->s16TrqDigRef01)[pAxisPara->u16TrqMulRefSel];
                }
                break;
            }
#if CONFIG_EXT_AI_NUM > 0
            case TRQ_REF_SRC_AI_1:
            {
                s16TrqRef = (s16)((s32)pDevicePara->s16UaiSi0 * (s32)pAxisPara->u16AiTrqCoeff0 / 100);
                break;
            }
#endif
#if CONFIG_EXT_AI_NUM > 1
            case TRQ_REF_SRC_AI_2:
            {
                s16TrqRef = (s16)((s32)pDevicePara->s16UaiSi1 * (s32)pAxisPara->u16AiTrqCoeff1 / 100);
                break;
            }
#endif
        }
    }

    // 逻辑层输出
    pAxisPara->s16LogicTrqRef = s16TrqRef;
}

static void _TrqLimSel(logic_ctrl_t* pLogicCtrl)
{
    device_para_t* pDevicePara = pLogicCtrl->pDevicePara;
    axis_para_t*   pAxisPara   = pLogicCtrl->pAxisPara;

    s16 s16LimFwd = 0;
    s16 s16LimRev = 0;

    u16 u16HomingMode;

#if CONFIG_DS402_CTRL_SW
    if (pAxisPara->eLogicCtrlMode == CTRL_MODE_DS402)
    {
        u16HomingMode = pAxisPara->sbHomingMethod_6098;  // 回原模式

        UNUSED(u16HomingMode);
    }
#endif

    if (0)
    {
        // TODO: 回原模式下的转矩限制
    }
#if CONFIG_DS402_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_DS402)
    {
        // TODO: 402模式下的转矩限制

        // s16LimFwd = pAxisPara->H60E0;  // 正向转矩限制
        // s16LimRev = pAxisPara->H60E1;  // 反向转矩限制
    }
#endif
#if CONFIG_PROFINET_CTRL_SW
    else if (pAxisPara->eLogicCtrlMode == CTRL_MODE_PROFINET)
    {
    }
#endif
    else
    {
        switch ((trq_lim_src_e)pAxisPara->eTrqLimSrc)
        {
            default:
            case TRQ_LIM_S:
            {
                s16LimFwd = (s16)pAxisPara->u16TrqLimFwd;
                s16LimRev = -s16LimFwd;
                break;
            }

            case TRQ_LIM_M:
            {
                s16LimFwd = +(s16)pAxisPara->u16TrqLimFwd;
                s16LimRev = -(s16)pAxisPara->u16TrqLimRev;
                break;
            }

#if CONFIG_EXT_AI_NUM > 0
            case TRQ_LIM_AI_S:
            {
                s16LimFwd = (s16)((s32)pDevicePara->s16UaiSi0 * (s32)pAxisPara->u16AiTrqCoeff0 / 100);
                s16LimRev = s16LimFwd;
                break;
            }
#endif

#if CONFIG_EXT_AI_NUM > 1
            case TRQ_LIM_AI_M:
            {
                s16LimFwd = (s16)((s32)pDevicePara->s16UaiSi0 * (s32)pAxisPara->u16AiTrqCoeff0 / 100);
                s16LimRev = (s16)((s32)pDevicePara->s16UaiSi1 * (s32)pAxisPara->u16AiTrqCoeff1 / 100);
                break;
            }
#endif
        }
    }

    // 逻辑层输出
    pAxisPara->s16LogicTrqLimFwd = s16LimFwd;
    pAxisPara->s16LogicTrqLimRev = s16LimRev;
}

static void _CtrlModeSel(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    ctrl_mode_e eCtrlMode = *pLogicCtrl->pAppConf->peCtrlMode;

    // 逻辑层输出
    pAxisPara->eLogicCtrlMode = eCtrlMode;
}

static void _CtrlWord(logic_ctrl_t* pLogicCtrl)
{
    static u32 u32DiCmd = 0;  // debug only

    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    RO ctrlword_u* puCommCmd = (RO ctrlword_u*)pLogicCtrl->pAppConf->puCtrlCmd;
    RO ctrlword_u* puDiCmd   = (RO ctrlword_u*)&u32DiCmd;

    //    RO pwron_cmd_conf_u* puPwrOnCmd = (RO pwron_cmd_conf_u*) &pAxisPara->u16PwrOnConf;

#if 0  // TODO: 上电配置控制字
    if (puPwrOnCmd->u16Bit.DrvEnable && pLogicCtrl->CtrlCmdIn.peAxisAppSel == AXIS_APP_GENERIC)
    {
       // pLogicCtrl->CtrlCmdOut.pbEnableCmd = true;  // 上电自运行
    }
    else
#endif
    if (pAxisPara->eCtrlCmdSrc == CTRL_CMD_SRC_COMM)
    {
        pAxisPara->bLogicDrvEnCmd = puCommCmd->u32Bit.Enable;
    }
    else if (pAxisPara->eCtrlCmdSrc == CTRL_CMD_SRC_DI)
    {
        pAxisPara->bLogicDrvEnCmd = puDiCmd->u32Bit.Enable;
    }
		
    // 点动指令(或)
    pAxisPara->bLogicJogFwdCmd = puCommCmd->u32Bit.JogFwd || puDiCmd->u32Bit.JogFwd;
    pAxisPara->bLogicJogRevCmd = puCommCmd->u32Bit.JogRev || puDiCmd->u32Bit.JogRev;

    // 多端启动(或)
    pAxisPara->bLogicMultMotionEn = puCommCmd->u32Bit.MultEn || puDiCmd->u32Bit.MultEn;

    // 数字限位(或)
    pAxisPara->bLogicPosLimFwd = puCommCmd->u32Bit.PosLimFwd || puDiCmd->u32Bit.PosLimFwd;
    pAxisPara->bLogicPosLimRev = puCommCmd->u32Bit.PosLimRev || puDiCmd->u32Bit.PosLimRev;

    // 故障复位(或)
    pAxisPara->bLogicAlmRst = puCommCmd->u32Bit.AlmRst || puDiCmd->u32Bit.AlmRst;

    // 多圈复位(或)
    pAxisPara->bLogicEncTurnClr = puCommCmd->u32Bit.EncTurnClr || puDiCmd->u32Bit.EncTurnClr;

    // 原点信号(或)
    pAxisPara->bLogicHomeSig = puCommCmd->u32Bit.Home || puDiCmd->u32Bit.Home;

    // 回原启动(或)
    pAxisPara->bLogicHomingCmd = puCommCmd->u32Bit.HomeEn || puDiCmd->u32Bit.HomeEn;  // || puPwrOnCmd->u16Bit.HomingEn;

    // 选择方向(或)
    pAxisPara->bLogicRotDirSel = puCommCmd->u32Bit.RotDir || puDiCmd->u32Bit.RotDir;
}

static void _CtrlCmd(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    bool bPwmSw = false;

    if (pAxisPara->bLogicStopCmd)
    {
        // TODO: 停机时根据停机模式 判断是否要开启关闭 PWM
        bPwmSw = false;
    }
    else if (AXIS_STATE_STANDBY <= pAxisPara->eAxisFSM && pAxisPara->eAxisFSM <= AXIS_STATE_ENABLE)
    {
        bPwmSw = pAxisPara->bLogicDrvEnCmd;
    }
		

    // PWM输出
    pAxisPara->bPwmSwSts = PwmGen(bPwmSw, pAxisPara->u16AxisNo);
}

static void _TrqUserInfo(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    if (pAxisPara->bPwmSwSts)
    {
        // 转矩千分比
        pAxisPara->s16UserTrqRef = (s32)1000 * (s32)pAxisPara->s16IqRef / (s32)pAxisPara->u16CurRateDigMot;
        pAxisPara->s16UserTrqFb  = (s32)1000 * (s32)pAxisPara->s16IqFb / (s32)pAxisPara->u16CurRateDigMot;

        // 转矩到达检测
        pLogicCtrl->bTrqArrive = (pAxisPara->u16TrqArriveTh >= abs(pAxisPara->s16UserTrqFb)) ? true : false;
    }
    else
    {
        // 状态清除
        pAxisPara->s16UserTrqRef = 0;
        pAxisPara->s16UserTrqFb  = 0;

        pLogicCtrl->bTrqArrive = false;
    }
}

static void _SpdUserInfo(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    // 逻辑层输出
    pAxisPara->s32UserSpdRef = pAxisPara->s32DrvSpdRef / DRV_SPD_ZOOM_COEFF;
    pAxisPara->s32UserSpdFb  = pAxisPara->s32DrvSpdFb / DRV_SPD_ZOOM_COEFF;
}

static void _PosUserInfo(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    // 逻辑层输出
    pAxisPara->s64UserPosRef = pAxisPara->s64DrvPosRef;
    pAxisPara->s64UserPosFb  = pAxisPara->s64DrvPosFb;
    pAxisPara->s32UserPosErr = pAxisPara->s32DrvPosErr;
}

static void _AxisMotConf(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    if (pLogicCtrl->u16MotEncSelPre != pAxisPara->u16MotEncSel)
    {
        if (pAxisPara->u16MotEncSel != 0)
        {
            memcpy((void*)&pAxisPara->u16MotPolePairs, (void*)&aMotEncPara[pAxisPara->u16MotEncSel - 1], sizeof(MotEncPara_t));
        }

        pLogicCtrl->u16MotEncSelPre = pAxisPara->u16MotEncSel;
    }
}

static void _AxisCurConf(logic_ctrl_t* pLogicCtrl)
{
    device_para_t* pDevicePara = pLogicCtrl->pDevicePara;
    axis_para_t*   pAxisPara   = pLogicCtrl->pAxisPara;

    if (pLogicCtrl->u16MotCurRatePre != pAxisPara->u16MotCurRate)
    {
        // 额定电流数字量(标幺到8192) = 电机额定电流 / 驱动器额定电流 * 32768 / 4

        if (pAxisPara->u16MotCurRate < pDevicePara->u16DrvCurRate)
        {
            pAxisPara->u16CurRateDigMot = (u16)(((u32)pAxisPara->u16MotCurRate << 13) / (u32)pDevicePara->u16DrvCurRate);
        }
        else
        {
            pAxisPara->u16CurRateDigMot = 8192;
        }

        // 软件过流点
        if (pAxisPara->u16CurRateDigMot < 8192)
        {
            pAxisPara->u16OverCurrTh = (u16)((u32)pAxisPara->u16CurRateDigMot * 39 / 10);
        }
        else
        {
            pAxisPara->u16OverCurrTh = 32000;
        }

        pLogicCtrl->u16MotCurRatePre = pAxisPara->u16MotCurRate;
    }
}

static void _LoopGainSel(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    // 逻辑层输出
    pAxisPara->s16DrvIdPropGain  = pAxisPara->u16CurLoopIdKp;
    pAxisPara->s16DrvIdInteGain  = pAxisPara->u16CurLoopIdKi;
    pAxisPara->s16DrvIqPropGain  = pAxisPara->u16CurLoopIqKp;
    pAxisPara->s16DrvIqInteGain  = pAxisPara->u16CurLoopIqKi;
    pAxisPara->s32DrvSpdPropGain = pAxisPara->u16SpdLoopKp;
    pAxisPara->s32DrvSpdInteGain = pAxisPara->u16SpdLoopKi;
    pAxisPara->s32DrvPosPropGain = pAxisPara->u16PosLoopKp;
    pAxisPara->s32DrvPosInteGain = pAxisPara->u16PosLoopKi;
}

static void _CtrlMode(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    ctrl_method_e eCtrlMethod = *pLogicCtrl->pAppConf->peCtrlMethod;
    ctrl_mode_e   eCtrlMode   = *pLogicCtrl->pAppConf->peCtrlMode;

    // 逻辑层输出
    pAxisPara->eLogicCtrlMethod = eCtrlMethod;
    pAxisPara->eLogicCtrlMode   = eCtrlMode;
}

void LogicCtrlCreat(logic_ctrl_t* pLogicCtrl, device_para_t* pDevicePara, axis_para_t* pAxisPara)
{
    pLogicCtrl->pDevicePara = pDevicePara;
    pLogicCtrl->pAxisPara   = pAxisPara;
}

void LogicCtrlInit(logic_ctrl_t* pLogicCtrl)
{
    axis_para_t* pAxisPara = pLogicCtrl->pAxisPara;

    pAxisPara->eAxisFSM = AXIS_STATE_INITIAL;

    // 电机选择
    _AxisMotConf(pLogicCtrl);

    // 额定电流
    _AxisCurConf(pLogicCtrl);
}

void LogicCtrlCycle(logic_ctrl_t* pLogicCtrl)
{
    // 电机选择
    _AxisMotConf(pLogicCtrl);

    // 额定电流
    _AxisCurConf(pLogicCtrl);

    // 控制模式
    _CtrlMode(pLogicCtrl);

    // 控制字分解
    _CtrlWord(pLogicCtrl);

    // 控制指令
    _CtrlCmd(pLogicCtrl);

    // 环路增益选择
    _LoopGainSel(pLogicCtrl);

    // 位置限制
    _PosLimSelGear(pLogicCtrl);

    // 位置规划模式
    _PosPlanModeSel(pLogicCtrl);

    // 速度限制
    _SpdLimSel(pLogicCtrl);

    // 加减速时间
    _SpdAccDecTimeSel(pLogicCtrl);

    // 速度规划模式
    _SpdPlanModeSel(pLogicCtrl);

    // 转矩限制
    _TrqLimSel(pLogicCtrl);
}

void LogicCtrlIsr(logic_ctrl_t* pLogicCtrl)
{
    // 控制模式
    _CtrlModeSel(pLogicCtrl);

    // 位置指令
    _PosRefSelGear(pLogicCtrl);

    // 速度指令
    _SpdRefSel(pLogicCtrl);

    // 磁通指令
    _FluxRefSel(pLogicCtrl);

    // 转矩指令
    _TrqRefSel(pLogicCtrl);

    // 用户位置信息
    _PosUserInfo(pLogicCtrl);

    // 用户速度信息
    _SpdUserInfo(pLogicCtrl);

    // 用户转矩信息
    _TrqUserInfo(pLogicCtrl);
}
