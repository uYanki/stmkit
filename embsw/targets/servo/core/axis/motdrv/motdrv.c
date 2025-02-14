#include "motdrv.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG       "motdrv"
#define LOG_LOCAL_LEVEL     LOG_LEVEL_INFO

#define CUR_LOOP_GAIN_COEFF 4096
#define SPD_LOOP_GAIN_COEFF 1000
#define POS_LOOP_GAIN_COEFF 10

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void MotDrvCreat(motdrv_t* pMotDrv, axis_para_t* pAxisPara)
{
    pMotDrv->pAxisPara = pAxisPara;

    //
    // 位置环
    //

    //
    // 速度环
    //

    pMotDrv->sSpdRefFltr.x0 = &pAxisPara->s32DrvSpdRef;
    pMotDrv->sSpdRefFltr.Ts = SPD_LOOP_PERIOD_100NS;
    // pMotDrv->sSpdFbFltr.x0  = &pAxisPara->s32DrvSpdFb;
    // pMotDrv->sSpdFbFltr.Ts  = SPD_LOOP_PERIOD_100NS;

    //
    // 电流环
    //

    pMotDrv->sIdRefFltr.x0 = &pAxisPara->s16IdRef;
    pMotDrv->sIqRefFltr.x0 = &pAxisPara->s16IqRef;
    pMotDrv->sIdFbFltr.x0  = &pMotDrv->sPark.Id;
    pMotDrv->sIqFbFltr.x0  = &pMotDrv->sPark.Iq;

    pMotDrv->sIdRefFltr.Ts = CUR_LOOP_PERIOD_100NS;
    pMotDrv->sIqRefFltr.Ts = CUR_LOOP_PERIOD_100NS;
    pMotDrv->sIdFbFltr.Ts  = CUR_LOOP_PERIOD_100NS;
    pMotDrv->sIqFbFltr.Ts  = CUR_LOOP_PERIOD_100NS;

    EncSampCreat(&pMotDrv->sEncSamp, pAxisPara);
    CurSampCreat(&pMotDrv->sCurSamp, pAxisPara);
}

void MotDrvInit(motdrv_t* pMotDrv)
{
    EncSampInit(&pMotDrv->sEncSamp);
    CurSampInit(&pMotDrv->sCurSamp);
}

void MotDrvCycle(motdrv_t* pMotDrv)
{
    EncSampCycle(&pMotDrv->sEncSamp);
    CurSampCycle(&pMotDrv->sCurSamp);
}

static void _PosPiCtrl(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    pAxisPara->s32DrvPosErr = pAxisPara->s64DrvPosRef - pAxisPara->s64DrvPosFb;

    s64 s64PosSat     = (s64)pAxisPara->u32EncRes * (s64)pAxisPara->u16PosPlanSpdMax / MIN_SEC_COEFF;  // pulse/s
    s64 s64PosLoopOut = (s64)pAxisPara->s32DrvPosErr * (s64)pAxisPara->s32DrvPosPropGain / (s64)POS_LOOP_GAIN_COEFF;

    if (s64PosLoopOut >= s64PosSat)
    {
        pMotDrv->u8PosPiSatFlag = 1;
        s64PosLoopOut           = s64PosSat;
    }
    else if (s64PosLoopOut <= -s64PosSat)
    {
        pMotDrv->u8PosPiSatFlag = 2;
        s64PosLoopOut           = -s64PosSat;
    }
    else
    {
        pMotDrv->u8PosPiSatFlag = 0;
        // s64PosLoopOut
    }

    pMotDrv->s64PosLoopOut = s64PosLoopOut;
}

static void _CurRefLim(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    // lpf_s16_t* pIdRefFltr = &pMotDrv->sIdRefFltr;
    lpf_s16_t* pIqRefFltr = &pMotDrv->sIqRefFltr;

    //
    // D轴
    //

    s16 s16IdRef = pAxisPara->s16PlanIdRef;

    //
    // Q轴
    //

    trq_lim_sts_e eTrqLimSts;  // 转矩限制状态

    s16 s16IqRef;  // 转矩指令输入

    if (pAxisPara->eLogicCtrlMode == CTRL_MODE_TRQ)
    {
        s16IqRef = pAxisPara->s16PlanIqRef;  // 规划处指令
    }
    else  // CTRL_MODE_POS、CTRL_MODE_SPD
    {
        s16IqRef = pAxisPara->s32SpdLoopOut;  // 速度环输出
    }

    // 转矩斜率限制
    s32 s32IqMin    = (s32)pAxisPara->s16IqRef - (s32)pAxisPara->u16CurRateDigMot * (s32)pAxisPara->u16TrqSlopeLim / 1000;
    s32 s32IqMax    = (s32)pAxisPara->s16IqRef + (s32)pAxisPara->u16CurRateDigMot * (s32)pAxisPara->u16TrqSlopeLim / 1000;
    s16 s16IqRefLim = CLAMP(s16IqRef, s32IqMin, s32IqMax);

    // 转矩范围限制
    s16 s16IqLimFwd = (s32)pAxisPara->s16LogicTrqLimFwd * (s32)pAxisPara->u16CurRateDigMot / 1000;
    s16 s16IqLimRev = (s32)pAxisPara->s16LogicTrqLimRev * (s32)pAxisPara->u16CurRateDigMot / 1000;

    if (s16IqRefLim >= s16IqLimFwd)
    {
        eTrqLimSts  = TRQ_LIM_STATUS_FWD;
        s16IqRefLim = s16IqLimFwd;
    }
    else if (s16IqRefLim <= s16IqLimRev)
    {
        eTrqLimSts  = TRQ_LIM_STATUS_REV;
        s16IqRefLim = s16IqLimRev;
    }
    else
    {
        eTrqLimSts  = TRQ_LIM_STATUS_NO;
        s16IqRefLim = s16IqRef;
    }

    // 指令滤波
    pIqRefFltr->Tc = pAxisPara->u16IqRefFltrTc * 100;
    pIqRefFltr->x0 = &s16IqRefLim;
    LpfProc(pIqRefFltr);

    // 驱动层输出
    pAxisPara->s16IdRef   = s16IdRef;
    pAxisPara->s16IqRef   = s16IqRefLim;
    pAxisPara->eTrqLimSts = eTrqLimSts;
}

static void _SpdRefLim(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    s32           s32SpdRefLim;
    spd_lim_sts_e eSpdLimSts;

    lpf_s32_t* pSpdRefFltr = &pMotDrv->sSpdRefFltr;

    if (pAxisPara->eLogicCtrlMode == CTRL_MODE_POS)
    {
        // 位置模式由规划速度上限限制
        eSpdLimSts   = SPD_LIM_STATUS_NO;
        s32SpdRefLim = pMotDrv->s64PosLoopOut * MIN_SEC_COEFF * DRV_SPD_ZOOM_COEFF / (s32)pAxisPara->u32EncRes;
    }
    else
    {
        s32 s32SpdRef    = pAxisPara->s32PlanSpdRef * DRV_SPD_ZOOM_COEFF;
        s32 s32SpdLimFwd = pAxisPara->s32LogicSpdLimFwd * DRV_SPD_ZOOM_COEFF;
        s32 s32SpdLimRev = pAxisPara->s32LogicSpdLimRev * DRV_SPD_ZOOM_COEFF;

        if (s32SpdRef >= s32SpdLimFwd)
        {
            eSpdLimSts   = SPD_LIM_STATUS_FWD;
            s32SpdRefLim = s32SpdLimFwd;
        }
        else if (s32SpdRef <= s32SpdLimRev)
        {
            eSpdLimSts   = SPD_LIM_STATUS_REV;
            s32SpdRefLim = s32SpdLimRev;
        }
        else
        {
            eSpdLimSts   = SPD_LIM_STATUS_NO;
            s32SpdRefLim = s32SpdRef;
        }
    }

    // 速度指令滤波
    pSpdRefFltr->Tc = pAxisPara->u16SpdRefFltrTc * 100;  // 0.01 (ms) = 100 (0.1us);
    pSpdRefFltr->x0 = &s32SpdRefLim;
    LpfProc(pSpdRefFltr);

    // 驱动层输出
    pAxisPara->s32DrvSpdRef = s32SpdRefLim;
    pAxisPara->eSpdLimSts   = eSpdLimSts;
}

static s32 _SpdPiCtrl(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    static const s32 s32SatPos = 32767;
    static const s32 s32SatNeg = -32767;

    pAxisPara->s32DrvSpdErr = pMotDrv->sSpdRefFltr.y0 - pAxisPara->s32DrvSpdFb;

    // Kp,Ki 单位：千分比
    s64 s64Prop = (s64)pAxisPara->s32DrvSpdPropGain * (s64)pAxisPara->s32DrvSpdErr / DRV_SPD_ZOOM_COEFF;
    s64 s64Inte = (s64)pAxisPara->s32DrvSpdInteGain * (s64)pAxisPara->s32DrvSpdErr / DRV_SPD_ZOOM_COEFF;

    pAxisPara->s32SpdLoopProp = (s32)s64Prop;

    // 输出饱和积分分离
    if ((pMotDrv->u8SpdPiSatFlag == 0) || (pMotDrv->u8SpdPiSatFlag == 1 && s64Inte < 0) || (pMotDrv->u8SpdPiSatFlag == 2 && s64Inte > 0))
    {
        pAxisPara->s32SpdLoopInte += (s32)s64Inte;
    }

    s32 s32SpdOut = ((s64)pAxisPara->s32SpdLoopProp + (s64)pAxisPara->s32SpdLoopInte) / (s64)1000;

    if (s32SpdOut >= s32SatPos)
    {
        s32SpdOut               = s32SatPos;
        pMotDrv->u8SpdPiSatFlag = 1;
    }
    else if (s32SpdOut <= s32SatNeg)
    {
        s32SpdOut               = s32SatNeg;
        pMotDrv->u8SpdPiSatFlag = 2;
    }
    else
    {
        s32SpdOut               = s32SpdOut;
        pMotDrv->u8SpdPiSatFlag = 0;
    }

    return s32SpdOut;
}

//  FB: pMotDrv->sIqFbFltr.y0;

static s16 _IqPiCtrl(motdrv_t* pMotDrv, s16 s16IqRef)
{
    // https://blog.csdn.net/jdhfusk/article/details/120646346
    // *pi->ps32Inte = CLAMP(*pi->ps32Inte, -32768 * 1.73f / 3, 32768 * 1.73f / 3);

    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    s16 s16IqErr = s16IqRef - pMotDrv->sIqFbFltr.y0;
    s16 s16Sat   = 27000;

    pAxisPara->s32CurLoopIqProp = pAxisPara->s16DrvIqPropGain * s16IqErr;
    pAxisPara->s32CurLoopIqInte += pAxisPara->s16DrvIqInteGain * s16IqErr;

    s32 s32IqOut = (pAxisPara->s32CurLoopIqProp + pAxisPara->s32CurLoopIqInte) / 100;

    return CLAMP(s32IqOut, -s16Sat, s16Sat);
}

static s16 _IdPiCtrl(motdrv_t* pMotDrv, s16 s16IdRef)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    s16 s16IdErr = s16IdRef - pMotDrv->sIdFbFltr.y0;
    s16 s16Sat   = 500;

    pAxisPara->s32CurLoopIdProp = pAxisPara->s16DrvIdPropGain * s16IdErr;
    pAxisPara->s32CurLoopIdInte += pAxisPara->s16DrvIdInteGain * s16IdErr;

    s32 s32IdOut = (pAxisPara->s32CurLoopIdProp + pAxisPara->s32CurLoopIdInte) / 100;

    return CLAMP(s32IdOut, -s16Sat, s16Sat);
}

static void _SpdPiClr(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    pAxisPara->s32DrvSpdErr   = 0;
    pAxisPara->s32SpdLoopProp = 0;
    pAxisPara->s32SpdLoopInte = 0;
    pAxisPara->s32SpdLoopOut  = 0;

    pMotDrv->u8SpdPiSatFlag = 0;
}

static void _CurPiClr(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    pAxisPara->s16DrvIdErr = 0;
    pAxisPara->s16DrvIqErr = 0;

    pAxisPara->s32CurLoopIqProp = 0;
    pAxisPara->s32CurLoopIqInte = 0;
    pAxisPara->s32CurLoopIdProp = 0;
    pAxisPara->s32CurLoopIdInte = 0;

    // 驱动层输出
    pAxisPara->u16ElecAngRef = 0;
    pAxisPara->s16IdRef      = 0;
    pAxisPara->s16IqRef      = 0;
}

static void _SpdLoop(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    if (pAxisPara->eLogicCtrlMode == CTRL_MODE_TRQ)
    {
        // 驱动层输出
        pAxisPara->s32SpdLoopOut = 0;
    }
    else
    {
        _SpdRefLim(pMotDrv);

        // 驱动层输出
        pAxisPara->s32SpdLoopOut = _SpdPiCtrl(pMotDrv);
    }
}

static void _PosLoop(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    // 驱动层输出
    pAxisPara->s64DrvPosFb  = pAxisPara->s64EncMultPos;
    pAxisPara->s64DrvPosRef = pAxisPara->s64PlanPosRef;

    // PI
    if (pAxisPara->eLogicCtrlMode == CTRL_MODE_POS)
    {
        // pi->s64Sat = (s64)pAxisPara->u32EncRes * (s64)pAxisPara->u16MotSpdMax * (s64)pAxisPara->u16SpdMaxGain / 100 / MIN_SEC_COEFF;  // pulse/s
        // pi->s64Sat = (s64)pAxisPara->u32EncRes * (s64)pAxisPara->u16PosPlanSpdMax / MIN_SEC_COEFF;  // pulse/s

        _PosPiCtrl(pMotDrv);
    }
}

static void _CurLoopFb(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    mc_park_t*   park      = &pMotDrv->sPark;
    mc_clarke_t* clarke    = &pMotDrv->sClarke;
    lpf_s16_t*   pIdFbFltr = &pMotDrv->sIdFbFltr;
    lpf_s16_t*   pIqFbFltr = &pMotDrv->sIqFbFltr;

    clarke->Ia = pAxisPara->s16IaFbPu;
    clarke->Ib = pAxisPara->s16IbFbPu;
    clarke->Ic = pAxisPara->s16IcFbPu;
    MC_Clarke(clarke);

    park->Ialpha = clarke->Ialpha;
    park->Ibeta  = clarke->Ibeta;
    park->theta  = pAxisPara->u16ElecAngFb;
    MC_Park(park);

    // 反馈滤波
    pIdFbFltr->Tc = pAxisPara->u16IdFbFltrTc * 100;
    pIqFbFltr->Tc = pAxisPara->u16IqFbFltrTc * 100;
    pIdFbFltr->x0 = &park->Id;
    pIqFbFltr->x0 = &park->Iq;
    LpfProc(pIdFbFltr);
    LpfProc(pIqFbFltr);

    // 驱动层输出
    pAxisPara->s16IalphaFb = park->Ialpha;
    pAxisPara->s16IbetaFb  = park->Ibeta;
    pAxisPara->s16IdFb     = park->Id;       // 滤波前
    pAxisPara->s16IqFb     = park->Iq;       // 滤波前
    pAxisPara->s16DrvIdFb  = pIdFbFltr->y0;  // 滤波后
    pAxisPara->s16DrvIqFb  = pIqFbFltr->y0;  // 滤波后
}

static void _CurLoopOut(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    mc_svgen_t* svpwm   = &pMotDrv->sSvpwm;
    mc_park_t*  revpark = &pMotDrv->sRevPark;
    // mc_clarke_t* revclarke = &pCurLoop->sRevClarke;

    MC_RevPark(revpark);

    svpwm->Ualpha = revpark->Ialpha;
    svpwm->Ubeta  = revpark->Ibeta;
    svpwm->Umdc   = D.u16UmdcPu;

    MC_Svgen(svpwm);

    PwmDuty(svpwm->Ta, svpwm->Tb, svpwm->Tc);

    // 驱动层输出
    pAxisPara->u16ElecAngRef = revpark->theta;   // 电角度指令
    pAxisPara->s16IalphaRef  = revpark->Ialpha;  // α轴电压指令
    pAxisPara->s16IbetaRef   = revpark->Ibeta;   // β轴电压指令
    pAxisPara->u16PwmaComp   = svpwm->Ta;
    pAxisPara->u16PwmbComp   = svpwm->Tb;
    pAxisPara->u16PwmcComp   = svpwm->Tc;
}

void _RefClr(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    pAxisPara->s64DrvPosRef = 0;
    pAxisPara->s32DrvSpdRef = 0;

    pAxisPara->u16ElecAngRef = 0;
    pAxisPara->s16IalphaRef  = 0;
    pAxisPara->s16IbetaRef   = 0;
    pAxisPara->s16IqRef      = 0;
    pAxisPara->s16IdRef      = 0;

    pAxisPara->u16PwmaComp = 0;
    pAxisPara->u16PwmbComp = 0;
    pAxisPara->u16PwmcComp = 0;
}

void AlphaBetaFromPwmComp(axis_para_t* pAxisPara)  // 占空比重构 alpha beta 电压
{
#if 0

    // TI: math_blocks\include\v4.3\volt_calc.h

    // 最大线电压:
    // SPWM: M_SQRT3_2 * Umdc
    // SPWM注入零序分量(与SVPWM等效): Umdc

    f32 f32Vdc         = (f32)D.u16UmdcSi;  // 母线电压物理值
    f32 f32ValphaRecst = (2.0f * (f32)pAxisPara->u16PwmaComp - (f32)pAxisPara->u16PwmbComp - (f32)pAxisPara->u16PwmcComp) * f32Vdc / ((f32)PWM_PERIOD * 3.0f);
    f32 f32VbetaRecst  = ((f32)pAxisPara->u16PwmbComp - (f32)pAxisPara->u16PwmcComp) * f32Vdc / ((f32)PWM_PERIOD * M_SQRT3);

#define BUF_SEL 2

#if BUF_SEL == 0
    D.s16DbgBuf1 = 100 * (s32)pAxisPara->s16IalphaRef * (s32)D.u16UmdcSi / 10 / 32767 / 0.333f;
    D.s16DbgBuf2 = 100 * (s32)pAxisPara->s16IbetaRef * (s32)D.u16UmdcSi / 10 / 32767 / 0.333f;
    D.s16DbgBuf3 = 100 * f32ValphaRecst;
    D.s16DbgBuf4 = 100 * f32VbetaRecst;
#elif BUF_SEL == 1
    D.s16DbgBuf1 = 100 * (s32)pAxisPara->s16IalphaFb * (s32)D.u16UmdcSi * M_SQRT2 / 32767;
    D.s16DbgBuf2 = 100 * (s32)pAxisPara->s16IbetaFb * (s32)D.u16UmdcSi * M_SQRT2 / 32767;
    D.s16DbgBuf3 = 100 * f32ValphaRecst;
    D.s16DbgBuf4 = 100 * f32VbetaRecst;
#elif BUF_SEL == 2
    // 除10是由于变换前传入的Umdc单位是0.1V 而不是V
    D.s16DbgBuf1 = pAxisPara->s16IalphaRef * 3 / 10;
    D.s16DbgBuf2 = pAxisPara->s16IbetaRef * 3 / 10;
    D.s16DbgBuf3 = pAxisPara->s16IalphaFb * M_SQRT2;  // 瞬时值=有效值*SQRT2
    D.s16DbgBuf4 = pAxisPara->s16IbetaFb * M_SQRT2;
#endif

#endif
}

void MotDrvIsr(motdrv_t* pMotDrv)
{
    axis_para_t* pAxisPara = pMotDrv->pAxisPara;

    if (pAxisPara->bPwmSwSts)
    {
        // 电流反馈
        _CurLoopFb(pMotDrv);

        {
            AlphaBetaFromPwmComp(pAxisPara);
        }

        mc_park_t* revpark = &pMotDrv->sRevPark;

        switch (pAxisPara->eLogicCtrlMethod)
        {
            default:
            case CTRL_METHOD_FOC_CLOSED:  // FOC 闭环
            {
                StartEventRecorder(EVENT_POS_LOOP);
                _PosLoop(pMotDrv);
                StopEventRecorder(EVENT_POS_LOOP);

                StartEventRecorder(EVENT_SPD_LOOP);
                _SpdLoop(pMotDrv);
                StopEventRecorder(EVENT_SPD_LOOP);

                StartEventRecorder(EVENT_CUR_LOOP);
                _CurRefLim(pMotDrv);

                {
                    s16 s16IdRef, s16IqRef;

                    if (pAxisPara->eAppSel == AXIS_APP_LOOPRSP && pAxisPara->eLoopRspModeSel == 0)
                    {
                        s16IdRef = pAxisPara->s16IdRef = **pMotDrv->input.pps16IdRef;
                        s16IqRef = pAxisPara->s16IqRef = **pMotDrv->input.pps16IqRef;
                        pAxisPara->u16ElecAngRef       = pAxisPara->u16ElecAngFb;  //  **pMotDrv->input.ppu16ElecAngRef;
                    }
                    else if (pAxisPara->eAppSel == AXIS_APP_OFFMOTIDNET)
                    {
                        s16IdRef = pAxisPara->s16IdRef = **pMotDrv->input.pps16IdRef;
                        s16IqRef = pAxisPara->s16IqRef = **pMotDrv->input.pps16IqRef;
                        pAxisPara->u16ElecAngRef       = **pMotDrv->input.ppu16ElecAngRef;
                    }
                    else
                    {
                        s16IdRef                 = pAxisPara->s16IdRef;
                        s16IqRef                 = pMotDrv->sIqRefFltr.y0;  // &pAxisPara->s16IqRef;
                        pAxisPara->u16ElecAngRef = pAxisPara->u16ElecAngFb;
                    }

                    revpark->theta = pAxisPara->u16ElecAngRef;
                    revpark->Iq    = _IqPiCtrl(pMotDrv, s16IqRef);
                    revpark->Id    = _IdPiCtrl(pMotDrv, s16IdRef);

                    _CurLoopOut(pMotDrv);
                }

                StopEventRecorder(EVENT_CUR_LOOP);

                break;
            }

            case CTRL_METHOD_FOC_OPEN:  // FOC 开环
            {
                StartEventRecorder(EVENT_CUR_LOOP);

                {
                    revpark->theta = **pMotDrv->input.ppu16ElecAngRef;
                    revpark->Id    = **pMotDrv->input.pps16IdRef;
                    revpark->Iq    = **pMotDrv->input.pps16IqRef;

                    pAxisPara->s16IdRef = revpark->Id;
                    pAxisPara->s16IqRef = revpark->Iq;

                    _CurLoopOut(pMotDrv);
                }

                StopEventRecorder(EVENT_CUR_LOOP);

                break;
            }
        }
    }
    else
    {
        // pos pi clr
       // pMotDrv->s64PosLoopOut = 0;
			  pMotDrv->u8PosPiSatFlag = 0;

        _SpdPiClr(pMotDrv);
        _CurPiClr(pMotDrv);

        pMotDrv->sSpdRefFltr.y0 = 0;
        pMotDrv->sSpdRefFltr.y1 = 0;

        pMotDrv->sIqRefFltr.y0 = 0;
        pMotDrv->sIqRefFltr.y1 = 0;

        pMotDrv->sIdRefFltr.y0 = 0;
        pMotDrv->sIdRefFltr.y1 = 0;

        pMotDrv->s16SpdLoopIqRef = 0;

        _RefClr(pMotDrv);
    }
}
