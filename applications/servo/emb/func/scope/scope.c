#include "scope.h"
#include "storage.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "scope"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

s64 as64ScopeBuffer[SCOPE_SAMP_BUFF_SIZE] = {0};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

static void ScopeRecordData(u16* pu16DstAddr, RO u16* pu16SrcAddr, u8 u8WordCnt)
{
    switch (u8WordCnt)
    {
        case 1:  // word
        {
            pu16DstAddr[0] = pu16SrcAddr[0];
            break;
        }
        case 2:  // dword
        {
            pu16DstAddr[0] = pu16SrcAddr[0];
            pu16DstAddr[1] = pu16SrcAddr[1];
            break;
        }
        case 4:  // qword
        {
            pu16DstAddr[0] = pu16SrcAddr[0];
            pu16DstAddr[1] = pu16SrcAddr[1];
            pu16DstAddr[2] = pu16SrcAddr[2];
            pu16DstAddr[3] = pu16SrcAddr[3];
            break;
        }
    }
}

static s64 ScopeGetSignData(RO u16* pu16SrcAddr, u8 u8WordCnt)
{
    s64 s64Dat = 0;

    switch (u8WordCnt)
    {
        case 1:
        {
            s64Dat = (s16)he16(pu16SrcAddr);
            break;
        }
        case 2:
        {
            s64Dat = (s32)he32(pu16SrcAddr);
            break;
        }
        case 4:
        {
            s64Dat = (s64)he64(pu16SrcAddr);
            break;
        }
    }

    return s64Dat;
}

static u64 ScopeGetUnsiData(RO u16* pu16SrcAddr, u8 u8WordCnt)
{
    s64 u64Dat = 0;

    switch (u8WordCnt)
    {
        case 1:
        {
            u64Dat = (u16)he16(pu16SrcAddr);
            break;
        }
        case 2:
        {
            u64Dat = (u32)he32(pu16SrcAddr);
            break;
        }
        case 4:
        {
            u64Dat = (u64)he64(pu16SrcAddr);
            break;
        }
    }

    return u64Dat;
}

void ScopeInitSampObj(scope_t* pScope)
{
    device_para_t* pDevicePara = pScope->pDevicePara;
    axis_para_t*   pAxisPara   = pScope->pAxisPara[0];

    pScope->u16SampIdx    = 0;
    pScope->u16SampCnt    = pDevicePara->u16ScopeSampPts;
    pScope->u16SampPrd    = pDevicePara->u16ScopeSampPrd;
    pScope->u16SampPrdCnt = 0;

    pScope->u8SampChanNum = 0;

    for (u8 i = 0; i < SCOPE_SAMP_CHAN_NUM; ++i)
    {
        scope_samp_obj_t* pObj = &pScope->aSampObj[i];

        //
        // 通道配置
        //

        scope_samp_obj_sel_e eSampSrc   = (scope_samp_obj_sel_e)(&pDevicePara->u16ScopeSampSrc1)[i];  // 预置对象
        u16                  u16ParaInd = (&pDevicePara->u16ScopeSampAddr1)[i];                       // 参数索引

        //
        // 数据源
        //

        switch (eSampSrc)
        {
            default:
            case SCOPE_SAMP_OBJ_NONE:
            {
                return;
            }
            case SCOPE_SAMP_OBJ_UMDC_SI:
            {
                pObj->pu16ParaAddr  = (u16*)&pDevicePara->u16UmdcSi;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;
                break;
            }
            case SCOPE_SAMP_OBJ_USER_TRQ_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16UserTrqRef;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_USER_TRQ_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16UserTrqFb;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_USER_SPD_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s32UserSpdRef;
                pObj->u8ParaWordCnt = 2;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_USER_SPD_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s32UserSpdFb;
                pObj->u8ParaWordCnt = 2;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_USER_POS_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s64UserPosRef;
                pObj->u8ParaWordCnt = 4;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_USER_POS_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s64UserPosFb;
                pObj->u8ParaWordCnt = 4;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_DRV_SPD_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s32DrvSpdRef;
                pObj->u8ParaWordCnt = 2;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_DRV_SPD_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s32DrvSpdFb;
                pObj->u8ParaWordCnt = 2;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_DRV_POS_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s64DrvPosRef;
                pObj->u8ParaWordCnt = 4;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_DRV_POS_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s64DrvPosFb;
                pObj->u8ParaWordCnt = 4;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_ELEC_ANGLE_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->u16ElecAngRef;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;
                break;
            }
            case SCOPE_SAMP_OBJ_ELEC_ANGLE_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->u16ElecAngFb;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;
                break;
            }
            case SCOPE_SAMP_OBJ_PWM_CMP_A:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->u16PwmaComp;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;
                break;
            }
            case SCOPE_SAMP_OBJ_PWM_CMP_B:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->u16PwmbComp;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;
                break;
            }
            case SCOPE_SAMP_OBJ_PWM_CMP_C:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->u16PwmcComp;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;
                break;
            }
            case SCOPE_SAMP_OBJ_CUR_A_PU_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16IaFbPu;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_CUR_B_PU_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16IbFbPu;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_CUR_C_PU_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16IcFbPu;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_D_AXIS_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16IdFb;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_Q_AXIS_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16IqFb;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_D_AXIS_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16IdRef;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_SAMP_OBJ_Q_AXIS_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16IqRef;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }

            case SCOPE_SAMP_OBJ_S64_DBG_BUF1:
            case SCOPE_SAMP_OBJ_S64_DBG_BUF2:
            case SCOPE_SAMP_OBJ_S64_DBG_BUF3:
            case SCOPE_SAMP_OBJ_S64_DBG_BUF4:
            {
                pObj->pu16ParaAddr  = (u16*)(&pDevicePara->s64DbgBuf1 + eSampSrc - SCOPE_SAMP_OBJ_S64_DBG_BUF1);
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }

            case SCOPE_SAMP_OBJ_U64_DBG_BUF1:
            case SCOPE_SAMP_OBJ_U64_DBG_BUF2:
            case SCOPE_SAMP_OBJ_U64_DBG_BUF3:
            case SCOPE_SAMP_OBJ_U64_DBG_BUF4:
            {
                pObj->pu16ParaAddr  = (u16*)(&pDevicePara->u64DbgBuf1 + eSampSrc - SCOPE_SAMP_OBJ_U64_DBG_BUF1);
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;
                break;
            }

            case SCOPE_SAMP_OBJ_ANYONE:
            {
                para_attr_t* cpParaAttr = ParaAttr(u16ParaInd);

                if (cpParaAttr == nullptr)
                {
                    return;
                }

                u32 u32ParaLen = cpParaAttr->uSubAttr.u16Bit.Length;

                pObj->u8ParaSign    = cpParaAttr->uSubAttr.u16Bit.Sign;
                pObj->u8ParaWordCnt = ParaWordSize(cpParaAttr);
                pObj->pu16ParaAddr  = ParaAddr(u16ParaInd);

                break;
            }
        }

        //
        // 数据缓冲
        //

        if (i == 0)
        {
            pObj->pu16BuffAddr = pScope->pu16SampBuff;
        }
        else
        {
            pObj->pu16BuffAddr = pScope->aSampObj[i - 1].pu16BuffAddr + pScope->aSampObj[i - 1].u8ParaWordCnt * pScope->u16SampCnt;
        }

        //
        // 通道计数
        //

        pScope->u8SampChanNum++;
    }
}

static void ScopeInitTrigObj(scope_t* pScope)
{
    device_para_t* pDevicePara = pScope->pDevicePara;
    axis_para_t*   pAxisPara   = pScope->pAxisPara[0];

    pScope->eTrigMode = (scope_trig_mode_e)pDevicePara->u16ScopeTrigMode;  // 触发模式, 此处备份以防触发过程中被更改

    pScope->u8TrigChanNum = 0;

    pScope->aTrigObj[0].u64ParaThold = pDevicePara->u64ScopeTrigThold1;
    pScope->aTrigObj[1].u64ParaThold = pDevicePara->u64ScopeTrigThold2;

    for (u8 i = 0; i < SCOPE_TRIG_CHAN_NUM; ++i)
    {
        scope_trig_obj_t* pObj = &pScope->aTrigObj[i];

        //
        // 触发参数
        //

        scope_trig_obj_sel_e eObjSrc    = (scope_trig_obj_sel_e)((&pDevicePara->u16ScopeTrigSrc1)[i]);  // 触发对象
        u16                  u16ParaInd = (&pDevicePara->u16ScopeTrigAddr1)[i];                         // 参数索引

        pObj->eTrigCond = (scope_trig_cond_e)((&pDevicePara->u16ScopeTrigCond1)[i]);  // 触发条件, 此处备份以防触发过程中被更改

        //
        // 数据源
        //

        switch (eObjSrc)
        {
            default:
            case SCOPE_TRIG_OBJ_NONE:
            {
                return;
            }
            case SCOPE_TRIG_OBJ_SERVO_ON:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->bLogicDrvEnCmd;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;

                break;
            }
            case SCOPE_TRIG_OBJ_PWM_ON:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->bPwmSwSts;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;

                break;
            }
            case SCOPE_TRIG_OBJ_USER_TRQ_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16UserTrqRef;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_TRIG_OBJ_USER_TRQ_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s16UserTrqFb;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_TRIG_OBJ_USER_SPD_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s32UserSpdRef;
                pObj->u8ParaWordCnt = 2;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_TRIG_OBJ_USER_SPD_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s32UserSpdFb;
                pObj->u8ParaWordCnt = 2;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_TRIG_OBJ_USER_POS_REF:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s64UserPosRef;
                pObj->u8ParaWordCnt = 4;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_TRIG_OBJ_USER_POS_FB:
            {
                pObj->pu16ParaAddr  = (u16*)&pAxisPara->s64UserPosFb;
                pObj->u8ParaWordCnt = 4;
                pObj->u8ParaSign    = V_SIGN;
                break;
            }
            case SCOPE_TRIG_OBJ_UMDC_SI:
            {
                pObj->pu16ParaAddr  = (u16*)&pDevicePara->u16UmdcSi;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;

                break;
            }
            case SCOPE_TRIG_OBJ_ALARM:
            {
                pObj->pu16ParaAddr  = (u16*)&pDevicePara->u16LastAlmCode;
                pObj->u8ParaWordCnt = 1;
                pObj->u8ParaSign    = V_UNSI;

                break;
            }
            case SCOPE_SAMP_OBJ_ANYONE:
            {
                para_attr_t* cpParaAttr = ParaAttr(u16ParaInd);

                if (cpParaAttr == nullptr)
                {
                    return;
                }

                u32 u32ParaLen = cpParaAttr->uSubAttr.u16Bit.Length;

                pObj->u8ParaSign    = cpParaAttr->uSubAttr.u16Bit.Sign;
                pObj->u8ParaWordCnt = ParaWordSize(cpParaAttr);
                pObj->pu16ParaAddr  = ParaAddr(u16ParaInd);

                break;
            }
        }

        //
        // 起始值
        //

        ScopeRecordData(pObj->au16ParaPreVal, pObj->pu16ParaAddr, pObj->u8ParaWordCnt);

        //
        // 通道计数
        //

        pScope->u8TrigChanNum++;
    }
}

void ScopeRecordSampObj(scope_t* pScope)
{
    for (u8 i = 0; i < pScope->u8SampChanNum; ++i)
    {
        scope_samp_obj_t* pObj = &pScope->aSampObj[i];

        ScopeRecordData(pObj->pu16BuffAddr + pObj->u8ParaWordCnt * pScope->u16SampIdx, pObj->pu16ParaAddr, pObj->u8ParaWordCnt);
    }
}

static bool ScopeDetectTrig(scope_t* pScope)
{
    bool bTrigState = false;  // 触发状态

    device_para_t* pDevicePara = pScope->pDevicePara;
    axis_para_t*   pAxisPara   = pScope->pAxisPara[0];

    u8 u8TrigMask = 0;

    for (u8 i = 0; i < pScope->u8TrigChanNum; ++i)
    {
        scope_trig_obj_t* pObj = &pScope->aTrigObj[i];

        if (pObj->u8ParaSign == V_UNSI)
        {
            u64 u64PreVal = ScopeGetUnsiData(pObj->au16ParaPreVal, pObj->u8ParaWordCnt);
            u64 u64CurVal = ScopeGetUnsiData(pObj->pu16ParaAddr, pObj->u8ParaWordCnt);
            u64 u64Thold  = (u64)pObj->u64ParaThold;

            ScopeRecordData(pObj->au16ParaPreVal, (const u16*)&u64CurVal, pObj->u8ParaWordCnt);

            switch (pObj->eTrigCond)
            {
                case SCOPE_TRIG_COND_RISING_EDGE:
                case SCOPE_TRIG_COND_RISING_EDGE_ABS:
                {
                    if ((u64PreVal < u64Thold) && (u64CurVal >= u64Thold))
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }
                case SCOPE_TRIG_COND_FALLING_EDGE:
                case SCOPE_TRIG_COND_FALLING_EDGE_ABS:
                {
                    if ((u64PreVal > u64Thold) && (u64CurVal <= u64Thold))
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_LESS_THAN:
                case SCOPE_TRIG_COND_LESS_THAN_ABS:
                {
                    if (u64Thold > u64CurVal)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_GREATER_THAN:
                case SCOPE_TRIG_COND_GREATER_THAN_ABS:
                {
                    if (u64Thold < u64CurVal)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_NOT_LESS_THAN:
                case SCOPE_TRIG_COND_NOT_LESS_THAN_ABS:
                {
                    if (u64Thold <= u64CurVal)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_NOT_GREATER_THAN:
                case SCOPE_TRIG_COND_NOT_GREATER_THAN_ABS:
                {
                    if (u64Thold >= u64CurVal)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }
            }
        }
        else  // V_SIGN
        {
            s64 s64PreVal = ScopeGetSignData(pObj->au16ParaPreVal, pObj->u8ParaWordCnt);
            s64 s64CurVal = ScopeGetSignData(pObj->pu16ParaAddr, pObj->u8ParaWordCnt);
            s64 s64Thold  = (s64)pObj->u64ParaThold;

            s64 s64PreValAbs = ABS(s64PreVal);
            s64 s64CurValAbs = ABS(s64CurVal);
            s64 s64TholdAbs  = ABS(s64Thold);

            ScopeRecordData(pObj->au16ParaPreVal, (const u16*)&s64CurVal, pObj->u8ParaWordCnt);

            switch (pObj->eTrigCond)
            {
                case SCOPE_TRIG_COND_RISING_EDGE:
                {
                    if ((s64PreVal < s64Thold) && (s64CurVal >= s64Thold))
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_FALLING_EDGE:
                {
                    if ((s64PreVal > s64Thold) && (s64CurVal <= s64Thold))
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_LESS_THAN:
                {
                    if (s64Thold > s64CurVal)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_GREATER_THAN:
                {
                    if (s64Thold < s64CurVal)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_NOT_LESS_THAN:
                {
                    if (s64Thold <= s64CurVal)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_NOT_GREATER_THAN:
                {
                    if (s64Thold >= s64CurVal)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_RISING_EDGE_ABS:
                {
                    //
                    // 速度反馈高于 1500rpm 时触发 (不分方向)
                    // 阈值为 +1500rpm/-1500rpm 时：
                    //      +1400rpm -> +1600rpm 时触发
                    //      -1400rpm -> -1600rpm 时触发
                    //      -1400rpm -> +1600rpm 时触发
                    //      +1400rpm -> -1600rpm 时触发
                    //      -1400rpm -> +1400rpm 时不触发
                    //      +1400rpm -> -1400rpm 时不触发
                    //

                    if ((s64PreValAbs < s64TholdAbs) && (s64CurValAbs >= s64TholdAbs))
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_FALLING_EDGE_ABS:
                {
                    if ((s64PreValAbs > s64TholdAbs) && (s64CurValAbs <= s64TholdAbs))
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_LESS_THAN_ABS:
                {
                    if (s64TholdAbs > s64CurValAbs)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_GREATER_THAN_ABS:
                {
                    if (s64TholdAbs < s64CurValAbs)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_NOT_LESS_THAN_ABS:
                {
                    if (s64TholdAbs <= s64CurValAbs)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }

                case SCOPE_TRIG_COND_NOT_GREATER_THAN_ABS:
                {
                    if (s64TholdAbs >= s64CurValAbs)
                    {
                        SETBIT(u8TrigMask, i);
                    }

                    break;
                }
            }
        }
    }

    for (u8 i = pScope->u8TrigChanNum; i < SCOPE_TRIG_CHAN_NUM; ++i)
    {
        SETBIT(u8TrigMask, i);
    }

    switch (pScope->eTrigMode)
    {
        case SCOPE_TRIG_MODE_A:
        {
            if (CHKBIT(u8TrigMask, 0))
            {
                bTrigState = true;
            }

            break;
        }

        case SCOPE_TRIG_MODE_A_AND_B:
        {
            if (CHKBIT(u8TrigMask, 0) && CHKBIT(u8TrigMask, 1))
            {
                bTrigState = true;
            }

            break;
        }

        case SCOPE_TRIG_MODE_A_OR_B:
        {
            if (CHKBIT(u8TrigMask, 0) || CHKBIT(u8TrigMask, 1))
            {
                bTrigState = true;
            }

            break;
        }
    }

    return bTrigState;
}

void ScopeCreat(scope_t* pScope)
{
    pScope->pu16SampBuff = (u16*)as64ScopeBuffer;
}

void ScopeInit(scope_t* pScope)
{
    pScope->bEnable = true;
}

void ScopeCycle(scope_t* pScope)
{
    if (pScope->bEnable == false)
    {
        return;
    }
}

void ScopeIsr(scope_t* pScope)
{
    device_para_t* pDevicePara = pScope->pDevicePara;
    axis_para_t*   pAxisPara   = pScope->pAxisPara[0];

    if (pScope->bEnable == false)
    {
        return;
    }

    switch (pDevicePara->u16ScopeSampSts)
    {
        case SCOPE_STATE_IDLE:
        {
            break;
        }
        case SCOPE_STATE_INIT:  // set by external command
        {
            // 采样对象
            ScopeInitSampObj(pScope);

            // 触发对象
            ScopeInitTrigObj(pScope);

            // 预触发点数
            pScope->u16PointsBeforeTrig = (pScope->u8TrigChanNum == 0) ? (u16)(0) : (u16)((u32)pScope->u16SampCnt * (u32)pDevicePara->u16ScopeTrigPreset / 100);
            pScope->u16PointsAfterTrig  = pScope->u16SampCnt - pScope->u16PointsBeforeTrig;
            pScope->bPointsEnough       = false;

            pDevicePara->u16ScopeUploadSts = SCOPE_UPLOAD_PREPARE;
            pDevicePara->u16ScopeSampSts   = SCOPE_STATE_WAITING;

            break;
        }
        case SCOPE_STATE_WAITING:  // waiting for trig signal
        {
            if (++pScope->u16SampPrdCnt == pScope->u16SampPrd)
            {
                pScope->u16SampPrdCnt = 0;

                // 数据点采样
                ScopeRecordSampObj(pScope);

                // 下一个点的索引
                pScope->u16SampIdx++;

                // 预触发完成状态
                if ((pScope->bPointsEnough == false) && (pScope->u16SampIdx >= pScope->u16PointsBeforeTrig))
                {
                    pScope->bPointsEnough = true;
                }

                if (pScope->u16SampIdx == pScope->u16SampCnt)
                {
                    pScope->u16SampIdx = 0;
                }

                // 触发检测
                if (ScopeDetectTrig(pScope) == true)
                {
                    if (pScope->bPointsEnough == false)
                    {
                        pScope->u16PointsAfterTrig = pScope->u16SampCnt - pScope->u16SampIdx;
                    }

                    pDevicePara->u16ScopeSampEndIdx = (pScope->u16SampIdx + pScope->u16PointsAfterTrig) % pScope->u16SampCnt;
                    pDevicePara->u16ScopeSampSts    = SCOPE_STATE_BUSY;
                }
            }

            break;
        }
        case SCOPE_STATE_BUSY:  // sample process
        {
            if (++pScope->u16SampPrdCnt == pScope->u16SampPrd)
            {
                pScope->u16SampPrdCnt = 0;

                if (pScope->u16PointsAfterTrig > 0)
                {
                    pScope->u16PointsAfterTrig--;

                    // 数据点采样
                    ScopeRecordSampObj(pScope);

                    if (++pScope->u16SampIdx == pScope->u16SampCnt)
                    {
                        pScope->u16SampIdx = 0;
                    }
                }

                if (pScope->u16PointsAfterTrig == 0)
                {
                    pDevicePara->u16ScopeUploadSts = SCOPE_UPLOAD_READY;
                    pDevicePara->u16ScopeSampSts   = SCOPE_STATE_UPLOAD;
                }
            }

            break;
        }
        case SCOPE_STATE_UPLOAD:  // wait until external device read over.
        {
            if (pDevicePara->u16ScopeUploadSts == SCOPE_UPLOAD_BUSY)  // set busy by external device.
            {
            }
            else if (pDevicePara->u16ScopeUploadSts == SCOPE_UPLOAD_OVER)  // wait external device read over.
            {
                pDevicePara->u16ScopeUploadSts = SCOPE_UPLOAD_STANDBY;
                pDevicePara->u16ScopeSampSts   = SCOPE_STATE_IDLE;
            }

            break;
        }
        default:
        {
            break;
        }
    }
}
