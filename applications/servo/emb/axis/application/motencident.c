#include "motencident.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG          "encident"
#define LOG_LOCAL_LEVEL        LOG_LEVEL_INFO

#define CONFIG_ELEC_ANGLE_STEP 32    // 电角度步进值，需为65536的整数因子
#define CONFIG_LOCK_MAX_TIMES  1600  // 零电角度锁定计数，等待编码器位置反馈稳定 (1600*0.125us=0.1s)

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void MotEncIdentCreat(mot_enc_ident_t* pMotEncIdent, axis_para_t* pAxisPara)
{
    pMotEncIdent->pAxisPara  = pAxisPara;
    pMotEncIdent->peIdentCmd = &pAxisPara->u16MotEncIdentEn;  // 控制字
}

void MotEncIdentInit(mot_enc_ident_t* pMotEncIdent)
{
    pMotEncIdent->eCtrlMethod_o = CTRL_METHOD_FOC_OPEN;
    pMotEncIdent->eCtrlMode_o   = CTRL_MODE_TRQ;
}

void MotEncIdentEnter(mot_enc_ident_t* pMotEncIdent)
{
    axis_para_t* pAxisPara = pMotEncIdent->pAxisPara;

    pMotEncIdent->uCtrlCmd_o.u32Bit.Enable  = false;
    pMotEncIdent->peIdentCmd->u16Bit.Enable = false;

    pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_INIT;
}

void MotEncIdentExit(mot_enc_ident_t* pMotEncIdent)
{
    pMotEncIdent->uCtrlCmd_o.u32Bit.Enable  = false;
    pMotEncIdent->peIdentCmd->u16Bit.Enable = false;
}

void MotEncIdentCycle(mot_enc_ident_t* pMotEncIdent)
{
    axis_para_t* pAxisPara = pMotEncIdent->pAxisPara;

    pMotEncIdent->uCtrlCmd_o.u32Bit.Enable = pMotEncIdent->peIdentCmd->u16Bit.Enable;

    switch (pAxisPara->u16MotEncIdentState)
    {
        case MOT_ENC_IDENT_STATE_INIT:  // 初始化
        {
            if (pMotEncIdent->peIdentCmd->u16Bit.Enable)  // 使能信号
            {
                if (pAxisPara->bPwmSwSts)  // 轴使能后再开始辨识
                {
                    pMotEncIdent->u16CycleTimes     = 0;
                    pMotEncIdent->u16EncPosIncTimes = 0;
                    pMotEncIdent->u16EncPosDecTimes = 0;
                    pMotEncIdent->u32EncPosMax      = 0;
                    pMotEncIdent->u32EncPosPre      = 0;
                    pMotEncIdent->u16LockTimes      = 0;
                    pMotEncIdent->u32EncPosCcwInit  = 0;
                    pMotEncIdent->u16RotTimes       = 0;
                    pMotEncIdent->u16CwRotTimes     = 0;
                    memset(pMotEncIdent->u32ZeroAngPos, 0, sizeof(pMotEncIdent->u32ZeroAngPos));

                    pAxisPara->u16MotEncIdentDirMatched = MOT_ENC_ROT_DIR_NONE;
                    pAxisPara->u32MotEncIdentRes        = 0;  // 编码器分辨率
                    pAxisPara->u32MotEncIdentOffset     = 0;  // 编码器偏置
                    pAxisPara->u16MotEncIdentPolePairs  = 0;  // 编码器极对数
                    pAxisPara->u16MotEncIdentErr        = MOT_ENC_IDENT_ERR_NONE;

                    pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_ADAPT_VOLT;
                }
            }

            break;
        }

        case MOT_ENC_IDENT_STATE_ANALYSE:  // 状态分析
        {
            pMotEncIdent->peIdentCmd->u16Bit.Enable = false;  // 退使能

            u32 u32ElecAngOffset = 0;

            for (u8 i = 0; i < pMotEncIdent->u16RotTimes; i++)
            {
                u32ElecAngOffset += pMotEncIdent->u32ZeroAngPos[i] % (pAxisPara->u32MotEncIdentRes / pAxisPara->u16MotEncIdentPolePairs);
            }

            pAxisPara->u32MotEncIdentOffset = u32ElecAngOffset / pMotEncIdent->u16RotTimes;

            pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_FINISH;  // 辨识完成

#if 1  // debug only
            pAxisPara->u16MotPolePairs = pAxisPara->u16MotEncIdentPolePairs;
            pAxisPara->u32EncRes       = pAxisPara->u32MotEncIdentRes;
            pAxisPara->u32EncPosOffset = pAxisPara->u32MotEncIdentOffset;
#endif

            break;
        }
    }

    switch (pAxisPara->u16MotEncIdentState)
    {
        case MOT_ENC_IDENT_STATE_ERR:     // 功能错误退使能
        case MOT_ENC_IDENT_STATE_FINISH:  // 功能结束退使能
        {
            if (pMotEncIdent->peIdentCmd->u16Bit.Enable)  // 退使能后再次辨识使能
            {
                pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_INIT;
            }

            break;
        }

        default:  // 功能辨识阶段意外断使能时
        {
            if (pMotEncIdent->peIdentCmd->u16Bit.Enable == false)
            {
                pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_ERR;  // 辨识失败
                pAxisPara->u16MotEncIdentErr   = MOT_ENC_IDNET_ERR_BREAK;
            }

            break;
        }
    }
}

void MotEncIdentIsr(mot_enc_ident_t* pMotEncIdent)
{
    axis_para_t*        pAxisPara  = pMotEncIdent->pAxisPara;
    mot_enc_ctrlword_u* peIdentCmd = pMotEncIdent->peIdentCmd;

    switch (pAxisPara->u16MotEncIdentState)
    {
        case MOT_ENC_IDENT_STATE_ADAPT_VOLT:  // 电压自适应
        {
            s16* ps16LockAxisRef;

            pMotEncIdent->u16ElecAngRef_o = 0;

            if (peIdentCmd->u16Bit.AxisLock)  // lock q-axis 转矩
            {
                pMotEncIdent->s16IqRef_o += 4;
                pMotEncIdent->s16IdRef_o = 0;

                ps16LockAxisRef = &pMotEncIdent->s16IqRef_o;
            }
            else  // lock d-axis 磁通
            {
                pMotEncIdent->s16IqRef_o = 0;
                pMotEncIdent->s16IdRef_o += 4;

                ps16LockAxisRef = &pMotEncIdent->s16IdRef_o;
            }

            // 20% 的额定电流
            if (*ps16LockAxisRef > (pAxisPara->u16CurRateDigMot / 4))  // TODO: 等待电流反馈进入区间稳定后再切入下一步
            {
                pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_DIR_CONFIRM;
            }

            break;
        }

        case MOT_ENC_IDENT_STATE_DIR_CONFIRM:  // 旋转方向辨识
        {
            if (++pMotEncIdent->u16CycleTimes < 1000)
            {
                if (pMotEncIdent->u16CycleTimes % 20 == 0)  // 每20个周期采样1次, 减少因编码器数据抖动而带来的误差
                {
                    u32 u32EncPos = pAxisPara->u32EncPos;

                    if (u32EncPos > pMotEncIdent->u32EncPosPre)
                    {
                        pMotEncIdent->u16EncPosIncTimes++;  // 编码器位置递增次数
                    }
                    else if (u32EncPos < pMotEncIdent->u32EncPosPre)
                    {
                        pMotEncIdent->u16EncPosDecTimes++;  // 编码器位置递减次数
                    }

                    pMotEncIdent->u32EncPosPre = u32EncPos;
                }

                pMotEncIdent->u16ElecAngRef_o += CONFIG_ELEC_ANGLE_STEP;
            }
            else
            {
                if (pMotEncIdent->u16EncPosIncTimes > pMotEncIdent->u16EncPosDecTimes)
                {
                    // 编码器递增方向与电角度递增方向相同, 电机相序正常
                    pAxisPara->u16MotEncIdentDirMatched = MOT_ENC_ROT_DIR_SAME;
                }
                else
                {
                    // 编码器递增方向与电角度递增方向相反, 电机相序异常
                    pAxisPara->u16MotEncIdentDirMatched = MOT_ENC_ROT_DIR_DIFF;

                    // 电机相序异常警告（解决方法: 调换任意两根相线）
                    peIdentCmd->u16Bit.Enable      = false;
                    pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_ERR;
                    pAxisPara->u16MotEncIdentErr   = MOT_ENC_IDENT_ERR_PHASE_WRONG;
                    AlmSet(WRN_MOT_PHASE_WS, pAxisPara->u16AxisNo);
                    return;
                }

                pMotEncIdent->u32EncPosPre     = pAxisPara->u32EncPos;
                pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_RES_IND;
            }

            break;
        }

        case MOT_ENC_IDENT_STATE_RES_IND:  // 最大分辨率辨识 (主要用于多摩川编码器)
        {
            u32 u32EncPos = pAxisPara->u32EncPos;

            if (pMotEncIdent->u32EncPosMax < u32EncPos)  // 记录最大位置
            {
                pMotEncIdent->u32EncPosMax = u32EncPos;
            }

            if (((pAxisPara->u16MotEncIdentDirMatched == MOT_ENC_ROT_DIR_SAME) && (((s32)pMotEncIdent->u32EncPosPre - (s32)u32EncPos) > (s32)(pMotEncIdent->u32EncPosMax >> 2))) ||  // 检测到下降沿
                ((pAxisPara->u16MotEncIdentDirMatched == MOT_ENC_ROT_DIR_DIFF) && (((s32)u32EncPos - (s32)pMotEncIdent->u32EncPosPre) > (s32)(pMotEncIdent->u32EncPosMax >> 2))))    // 检测到上升沿
            {
                u8 u8EncResBit = 0;

                while (pMotEncIdent->u32EncPosMax)
                {
                    pMotEncIdent->u32EncPosMax >>= 1;
                    u8EncResBit++;
                }

                pAxisPara->u32MotEncIdentRes   = 1UL << u8EncResBit;
                pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_RETURN;
            }
            else
            {
                pMotEncIdent->u32EncPosPre = u32EncPos;
                pMotEncIdent->u16ElecAngRef_o += CONFIG_ELEC_ANGLE_STEP;
            }

            break;
        }

        case MOT_ENC_IDENT_STATE_RETURN:  // 电角度回零位
        {
            if (pMotEncIdent->u16ElecAngRef_o == 0)
            {
                if (++pMotEncIdent->u16LockTimes == CONFIG_LOCK_MAX_TIMES)  // 锁定在零电角度, 等待编码器位置反馈稳定
                {
                    pMotEncIdent->u16LockTimes = 0;

                    pMotEncIdent->u32EncPosCcwInit = pAxisPara->u32EncPos;    // 正转起始位置
                    pMotEncIdent->u16ElecAngRef_o += CONFIG_ELEC_ANGLE_STEP;  // 正转离开零电角度
                    pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_CCW;
                }
            }
            else
            {
                pMotEncIdent->u16ElecAngRef_o += CONFIG_ELEC_ANGLE_STEP;
            }

            break;
        }

        case MOT_ENC_IDENT_STATE_CCW:  // 极对数识别
        {
            // 原理：N对极的电机，机械角度转1圈，电角度转N圈

            if (pMotEncIdent->u16ElecAngRef_o == 0)
            {
                if (++pMotEncIdent->u16LockTimes == CONFIG_LOCK_MAX_TIMES)
                {
                    pMotEncIdent->u16LockTimes = 0;

                    if (pMotEncIdent->u16RotTimes == ARRAY_SIZE(pMotEncIdent->u32ZeroAngPos))
                    {
                        // 极对数过多, 缓冲数组过小
                        pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_ERR;
                        pAxisPara->u16MotEncIdentErr   = MOT_ENC_IDENT_ERR_POLE_PAIRS_TOO_MANY;
                        peIdentCmd->u16Bit.Enable      = false;
                        break;
                    }

                    pMotEncIdent->u32ZeroAngPos[pMotEncIdent->u16RotTimes++] = pAxisPara->u32EncPos;  // 零电角度对应的编码器位置

                    u32 u32EncPosAbsErr = AbsDelta(pMotEncIdent->u32EncPosCcwInit, pAxisPara->u32EncPos);

                    // 回到正转起点
                    if ((pAxisPara->u32MotEncIdentRes / 10 > u32EncPosAbsErr) ||                                 // [0, u32EncRes*0.1)
                        (pAxisPara->u32MotEncIdentRes / 10 > (pAxisPara->u32MotEncIdentRes - u32EncPosAbsErr)))  // (u32EncRes*0.9, u32EncRes]
                    {
                        pAxisPara->u16MotEncIdentPolePairs = pMotEncIdent->u16RotTimes;  // 旋转次数即极对数

                        if (pAxisPara->u16MotEncIdentPolePairs > (ARRAY_SIZE(pMotEncIdent->u32ZeroAngPos) / 2))
                        {
                            // 极对数过多, 直接进入数据分析阶段
                            pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_ANALYSE;
                        }
                        else
                        {
                            pMotEncIdent->u16CwRotTimes = pMotEncIdent->u16RotTimes;  // 设定反转次数
                            pMotEncIdent->u16ElecAngRef_o -= CONFIG_ELEC_ANGLE_STEP;  // 反转离开零电角度
                            pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_CW;
                        }
                    }
                    else
                    {
                        pMotEncIdent->u16ElecAngRef_o += CONFIG_ELEC_ANGLE_STEP;  // 正转离开零电角度
                    }
                }
            }
            else
            {
                pMotEncIdent->u16ElecAngRef_o += CONFIG_ELEC_ANGLE_STEP;
            }

            break;
        }

        case MOT_ENC_IDENT_STATE_CW:
        {
            if (pMotEncIdent->u16ElecAngRef_o == 0)
            {
                if (++pMotEncIdent->u16LockTimes == CONFIG_LOCK_MAX_TIMES)
                {
                    pMotEncIdent->u16LockTimes = 0;

                    pMotEncIdent->u32ZeroAngPos[pMotEncIdent->u16RotTimes++] = pAxisPara->u32EncPos;

                    if (--pMotEncIdent->u16CwRotTimes == 0)  // 回到反转起点
                    {
                        pAxisPara->u16MotEncIdentState = MOT_ENC_IDENT_STATE_ANALYSE;
                    }
                    else
                    {
                        pMotEncIdent->u16ElecAngRef_o -= CONFIG_ELEC_ANGLE_STEP;  // 反转离开零电角度
                    }
                }
            }
            else
            {
                pMotEncIdent->u16ElecAngRef_o -= CONFIG_ELEC_ANGLE_STEP;
            }
        }

        default:
        {
            break;
        }
    }
}
