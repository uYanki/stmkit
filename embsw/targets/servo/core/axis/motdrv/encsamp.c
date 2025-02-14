#include "encsamp.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "encsamp"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

static void _EncPosSamp(enc_samp_t* pEncSamp)
{
    axis_para_t* pAxisPara = pEncSamp->pAxisPara;

    switch (pAxisPara->u16EncType)
    {
        case ENC_HALL_UVW:
        {
            break;
        }

#if (CONFIG_ENCODER_TYPE == ENC_ABS)

        case ENC_ABS_TFORMAT:
        {
            break;
        }
        case ENC_ABS_AS5600:
        {
            break;
        }
        case ENC_ABS_MT6701:
        {
            abs_mt6701_t* pEnc = &pEncSamp->sAbsMT6701;

            MT6701RdPos(pEnc);

            pEncSamp->s32Pos = pEnc->u32Pos;

            break;
        }
        case ENC_ABS_MT6816:
        {
            break;
        }
        case ENC_ABS_MT6835:
        {
            break;
        }

#elif (CONFIG_ENCODER_TYPE == ENC_INC)

        case ENC_INC_2500:
        {
            break;
        }
        case ENC_INC_1000:
        {
            break;
        }

#elif (CONFIG_ENCODER_TYPE == ENC_ROT)

#endif

        default:
        {
            break;
        }
    }
}

static void _EncSpdCalc(enc_samp_t* pEncSamp)
{
    axis_para_t* pAxisPara = pEncSamp->pAxisPara;

    // 这样不会溢出！！！
    s32 s32DrvSpdFb = (s32)DRV_SPD_ZOOM_COEFF * (s32)CONFIG_SPD_LOOP_FREQ_HZ * pEncSamp->s32PosDelt / (s32)pAxisPara->u32EncRes;  // unit: 0.001rps
    s32DrvSpdFb *= (s32)MIN_SEC_COEFF;                                                                                            // unit: 0.001rpm

    lpf_s32_t* pLpf = &pEncSamp->sSpdFbFltr;

    pLpf->Tc = pAxisPara->u16SpdFbFltrTc * 100;
    pLpf->x0 = &s32DrvSpdFb;
    LpfProc(pLpf);

    // 驱动层输出
    pAxisPara->s32DrvSpdFb = pLpf->y0;
}

static void _ElecAngCalc(enc_samp_t* pEncSamp)
{
    axis_para_t* pAxisPara = pEncSamp->pAxisPara;

#if 1

    // [0,EncRes)=>[0,U32_MAX)=>[0,U16_MAX)

    u32 u32ElecAngTmp;
    u32ElecAngTmp = ((s32)pAxisPara->u32EncPos - (s32)pAxisPara->u32EncPosOffset + (s32)pEncSamp->s32PosDelt + (s32)pAxisPara->u32EncRes) % pAxisPara->u32EncRes;
    u32ElecAngTmp *= (U32_MAX / (u32)pAxisPara->u32EncRes);
    pAxisPara->u16ElecAngFb = (u16)((u32ElecAngTmp >> 16) * pAxisPara->u16MotPolePairs);

#else

    *pEncSamp->pu16ElecAngleFb = ((*pEncSamp->pu32EncPos + pAxisPara->u32EncRes - *pEncSamp->cpu32EncPosOffset) % pAxisPara->u32EncRes) * (65536 / pAxisPara->u32EncRes) * (s32)*pEncSamp->cpu16MotPolePairs;

#endif
}

void EncSampCreat(enc_samp_t* pEncSamp, axis_para_t* pAxisPara)
{
    pEncSamp->pAxisPara = pAxisPara;
}

void EncSampInit(enc_samp_t* pEncSamp)
{
    // Fc = 1 / (2 * pi * 50 * 10 ^ -6) = 318hz
    // pSpdFbFltr->s32Ts = 1000;  // us
    // pSpdFbFltr->s32Tc = 500;   // us
    pEncSamp->sSpdFbFltr.Ts = SPD_LOOP_PERIOD_100NS;

    lpf_s32_t* pLpf = &pEncSamp->sSpdFbFltr;
    LpfInit(pLpf);
}

void EncSampCycle(enc_samp_t* pEncSamp)
{
    axis_para_t* pAxisPara = pEncSamp->pAxisPara;

    if (pEncSamp->uEncCmdPre.u16All ^ pAxisPara->u16EncCmd)  // 边沿触发
    {
        enc_cmd_u*    pEncCmdPre = &pEncSamp->uEncCmdPre;
        RO enc_cmd_u* pEncCmdCur = (RO enc_cmd_u*)&pAxisPara->u16EncCmd;

        // 编码器多圈值复位
        if (pEncCmdCur->u16Bit.TurnsReset && !pEncCmdPre->u16Bit.TurnsReset)
        {
            pAxisPara->s32EncTurns = 0;
        }

        // 编码器故障状态复位
        if (pEncCmdCur->u16Bit.ErrorClear && !pEncCmdPre->u16Bit.ErrorClear)
        {
            pAxisPara->u16EncErrCode   = 0;
            pAxisPara->u16EncComErrSum = 0;
#if (CONFIG_ENCODER_TYPE == ENC_ABS)
            // AbsEncErrClr(&pEncSamp->sAbsEnc);
#endif
        }

        if (pEncCmdCur->u16Bit.StateReset && !pEncCmdPre->u16Bit.StateReset)
        {
            // pEncSamp->eState = ABS_ENC_STATE_INIT;
        }

        pEncCmdPre->u16All = pEncCmdCur->u16All;
    }
}

void EncSampIsr(enc_samp_t* pEncSamp)
{
    axis_para_t* pAxisPara = pEncSamp->pAxisPara;

    s32 s32PosPre = pEncSamp->s32Pos;
    s32 s32PosDelt;

    //
    // 位置采样
    //

    _EncPosSamp(pEncSamp);

    //
    // 单圈值
    //

    pAxisPara->u32EncPos = pEncSamp->s32Pos;

    //
    // 圈数(跳变沿检测)
    //

    s32PosDelt = pEncSamp->s32Pos - s32PosPre;

    if (s32PosDelt > (s32)(pAxisPara->u32EncRes >> 1))
    {
        pAxisPara->s32EncTurns--;
        s32PosDelt -= (s32)pAxisPara->u32EncRes;
    }
    else if (s32PosDelt < -(s32)(pAxisPara->u32EncRes >> 1))
    {
        pAxisPara->s32EncTurns++;
        s32PosDelt += (s32)pAxisPara->u32EncRes;
    }

    pEncSamp->s32PosDelt = s32PosDelt;  // 位置差

    //
    // 多圈值
    //

    pAxisPara->s64EncMultPos = (s64)pAxisPara->s32EncTurns * (s64)pAxisPara->u32EncRes + (s64)pEncSamp->s32Pos;

    //
    // 电角度计算
    //

    _ElecAngCalc(pEncSamp);

    //
    // 速度计算
    //

    _EncSpdCalc(pEncSamp);
}
