#include "cursamp.h"
#include "alarm.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "cursamp"
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

void CurSampCreat(cur_samp_t* pCurSamp, axis_para_t* pAxisPara)
{
    // pAxisPara->u16CurSampType = CONFIG_CUR_SAMP_TYPE;
    pCurSamp->pAxisPara = pAxisPara;

    pCurSamp->cpeSysSts = (RO system_state_e*)&D.eSysState;

    pCurSamp->cps16IaOffset = &pAxisPara->s16IaOffset;
    pCurSamp->cps16IbOffset = &pAxisPara->s16IbOffset;
    pCurSamp->cps16IcOffset = &pAxisPara->s16IcOffset;

    pCurSamp->cpu16IphHwCoeff = &pAxisPara->u16IphHwCoeff;
    pCurSamp->cpu16IphZoom    = &pAxisPara->u16IphZoom;

#if CUR_SAMP_DOWN_BRG_SW
    pCurSamp->cpeSector = (sector_e*)&pAxisPara->eSvpwmSector;
#endif

    pCurSamp->ps16IaPu = &pAxisPara->s16IaFbPu;
    pCurSamp->ps16IbPu = &pAxisPara->s16IbFbPu;
    pCurSamp->ps16IcPu = &pAxisPara->s16IcFbPu;

    pCurSamp->ps16IaSi = &pAxisPara->s16IaFbSi;
    pCurSamp->ps16IbSi = &pAxisPara->s16IbFbSi;
    pCurSamp->ps16IcSi = &pAxisPara->s16IcFbSi;

    pCurSamp->ps16IaZero = &pAxisPara->s16IaZeroPu;
    pCurSamp->ps16IbZero = &pAxisPara->s16IbZeroPu;
    pCurSamp->ps16IcZero = &pAxisPara->s16IcZeroPu;
}

void CurSampInit(cur_samp_t* pCurSamp)
{
#if CONFIG_BOOTSTRAP_SW
    pCurSamp->bChargeOver = false;
#endif

    pCurSamp->bZeroDriftOver = false;
}

void CurSampCycle(cur_samp_t* pCurSamp)
{
}

#if CUR_SAMP_LINE_SW

/**
 * @brief 线采样
 */
static void LineCurSampPu(cur_samp_t* pCurSamp)
{
#if CUR_SAMP_PHASE_U_SW
    *pCurSamp->ps16IaPu = AdcGet(CUR_U_Q15) - *pCurSamp->ps16IaZero;
#endif
#if CUR_SAMP_PHASE_V_SW
    *pCurSamp->ps16IbPu = AdcGet(CUR_V_Q15) - *pCurSamp->ps16IbZero;
#endif
#if CUR_SAMP_PHASE_W_SW
    *pCurSamp->ps16IcPu = AdcGet(CUR_W_Q15) - *pCurSamp->ps16IcZero;
#endif

#if (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UV_LINE)
    *pCurSamp->ps16IcPu = 0 - *pCurSamp->ps16IaPu - *pCurSamp->ps16IbPu;
#elif (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_VW_LINE)
    *pCurSamp->ps16IaPu = 0 - *pCurSamp->ps16IbPu - *pCurSamp->ps16IcPu;
#elif (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UW_LINE)
    *pCurSamp->ps16IbPu = 0 - *pCurSamp->ps16IaPu - *pCurSamp->ps16IcPu;
#elif (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_LINE)
    // nothing to do
#endif
}

#elif CUR_SAMP_DOWN_BRG_SW

/**
 * @brief 下桥采样
 */
static void DownBrdgCurSampPu(cur_samp_t* pCurSamp)
{
#if (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_S_DOWN_BRG)  // 单电阻采样

    *pCurSamp->pas16IxPu[0] = GetCur(0) - *pCurSamp->ps16IxZero;
    *pCurSamp->pas16IxPu[1] = GetCur(1) - *pCurSamp->ps16IxZero;

    // Rebuild Current

    switch (*pCurSamp->cpeSector)
    {
        case SECTOR_1:  // -ic ia
            *pCurSamp->ps16IaPu = *pCurSamp->pas16IxPu[1];
            *pCurSamp->ps16IbPu = *pCurSamp->pas16IxPu[0] - *pCurSamp->pas16IxPu[1];
            *pCurSamp->ps16IcPu = 0 - *pCurSamp->pas16IxPu[0];
            break;
        case SECTOR_2:  // -ic ib
            *pCurSamp->ps16IaPu = *pCurSamp->pas16IxPu[0] - *pCurSamp->pas16IxPu[1];
            *pCurSamp->ps16IbPu = *pCurSamp->pas16IxPu[1];
            *pCurSamp->ps16IcPu = 0 - *pCurSamp->pas16IxPu[0];
            break;
        case SECTOR_3:  // -ia ib
            *pCurSamp->ps16IaPu = 0 - *pCurSamp->pas16IxPu[0];
            *pCurSamp->ps16IbPu = *pCurSamp->pas16IxPu[1];
            *pCurSamp->ps16IcPu = *pCurSamp->pas16IxPu[0] - *pCurSamp->pas16IxPu[1];
            break;
        case SECTOR_4:  // -ia ic
            *pCurSamp->ps16IaPu = 0 - *pCurSamp->pas16IxPu[0];
            *pCurSamp->ps16IbPu = *pCurSamp->pas16IxPu[0] - *pCurSamp->pas16IxPu[1];
            *pCurSamp->ps16IcPu = *pCurSamp->pas16IxPu[1];
            break;
        case SECTOR_5:  // -ib ic
            *pCurSamp->ps16IaPu = *pCurSamp->pas16IxPu[0] - *pCurSamp->pas16IxPu[1];
            *pCurSamp->ps16IbPu = 0 - *pCurSamp->pas16IxPu[0];
            *pCurSamp->ps16IcPu = *pCurSamp->pas16IxPu[1];
            break;
        case SECTOR_6:  // -ib ia
            *pCurSamp->ps16IaPu = *pCurSamp->pas16IxPu[1];
            *pCurSamp->ps16IbPu = 0 - *pCurSamp->pas16IxPu[0];
            *pCurSamp->ps16IcPu = *pCurSamp->pas16IxPu[0] - *pCurSamp->pas16IxPu[1];
            break;
        default:
            break;
    }

#elif (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UV_DOWN_BRG)  // 双电阻采样

    *pCurSamp->ps16IaPu = AdcGet(CUR_U_Q15) - *pCurSamp->ps16IaZero;
    *pCurSamp->ps16IbPu = AdcGet(CUR_V_Q15) - *pCurSamp->ps16IbZero;
    *pCurSamp->ps16IcPu = - *pCurSamp->ps16IaPu - *pCurSamp->ps16IbPu;

#elif (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_VW_DOWN_BRG)  // 双电阻采样

    *pCurSamp->ps16IbPu = AdcGet(CUR_V_Q15) - *pCurSamp->ps16IbZero;
    *pCurSamp->ps16IcPu = AdcGet(CUR_W_Q15) - *pCurSamp->ps16IcZero;
    *pCurSamp->ps16IaPu = 0 - *pCurSamp->ps16IbPu - *pCurSamp->ps16IcPu;

#elif (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UW_DOWN_BRG)  // 双电阻采样

    *pCurSamp->ps16IaPu = AdcGet(CUR_U_Q15) - *pCurSamp->ps16IaZero;
    *pCurSamp->ps16IcPu = AdcGet(CUR_W_Q15) - *pCurSamp->ps16IcZero;
    *pCurSamp->ps16IbPu = 0 - *pCurSamp->ps16IaPu - *pCurSamp->ps16IcPu;

#elif (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_DOWN_BRG)  // 三电阻采样

    *pCurSamp->ps16IaPu = AdcGet(CUR_U_Q15) - *pCurSamp->ps16IaZero;
    *pCurSamp->ps16IbPu = AdcGet(CUR_V_Q15) - *pCurSamp->ps16IbZero;
    *pCurSamp->ps16IcPu = AdcGet(CUR_W_Q15) - *pCurSamp->ps16IcZero;

#endif
}

#endif

static void CurSampSi(cur_samp_t* pCurSamp)  // 物理值
{
#if 0

    // INAx181 增益选项：
    // – A1: 20V/V
    // – A2: 50V/V
    // – A3: 100V/V
    // – A4: 200V/V

    // V/32768*3.3/50/0.005;

    P(AXIS_1).u16IphHwCoeff = 3.3 / 50 / 0.005 * 2 * 100;  // debug only

    D.s16UaiPu1 = MAX3(abs(*pCurSamp->ps16IaPu), abs(*pCurSamp->ps16IbPu), abs(*pCurSamp->ps16IcPu));
    D.s16UaiPu2 = ((s32)D.s16UaiPu1 * (s32)*pCurSamp->cpu16IphHwCoeff) >> 15;  // 0.01A

#endif

    // 电流=ADC原始值/2048∗1.65/采样电阻阻值/运放放大倍数
    // 电流=ADC原始值/2048∗ 1.65/0.005R/50
    // *pCurSamp->cpu16IphHwCoeff = 6.6

    s32 s32IphCoeff = (s32)(*pCurSamp->cpu16IphHwCoeff) * (s32)(*pCurSamp->cpu16IphZoom) / 1000;

    *pCurSamp->ps16IaSi = (s16)((s32IphCoeff * (s32)*pCurSamp->ps16IaPu + (s32)*pCurSamp->cps16IaOffset) >> 15);
    *pCurSamp->ps16IbSi = (s16)((s32IphCoeff * (s32)*pCurSamp->ps16IbPu + (s32)*pCurSamp->cps16IbOffset) >> 15);
    *pCurSamp->ps16IcSi = (s16)((s32IphCoeff * (s32)*pCurSamp->ps16IcPu + (s32)*pCurSamp->cps16IcOffset) >> 15);
}

/**
 * @brief 计算电流零漂 (采样电流的均值)
 */
static void CurSampZeroDrift(cur_samp_t* pCurSamp)
{
    axis_para_t* pAxisPara = pCurSamp->pAxisPara;

#if CONFIG_BOOTSTRAP_SW
    if (pCurSamp->bChargeOver == false)
    {
        // 充电未完成前, 不采集电流
        if (PwrBootstrap(true, AXIS_NO2IND(pAxisPara->u16AxisNo)))
        {
            pCurSamp->bChargeOver = true;
        }

        return;
    }
#endif

    if (pCurSamp->u32ZeroDriftCnt < CONFIG_CUR_ZERO_DRIFT_SAMP_TIME)
    {
#if CUR_SAMP_PHASE_U_SW
        pCurSamp->s32IaZeroDriftSum += AdcGet(CUR_U_Q15);
#endif
#if CUR_SAMP_PHASE_V_SW
        pCurSamp->s32IbZeroDriftSum += AdcGet(CUR_V_Q15);
#endif
#if CUR_SAMP_PHASE_W_SW
        pCurSamp->s32IcZeroDriftSum += AdcGet(CUR_W_Q15);
#endif
        pCurSamp->u32ZeroDriftCnt++;
    }
    else
    {
        // 更新零漂值

#if CUR_SAMP_PHASE_U_SW
        *pCurSamp->ps16IaZero = pCurSamp->s32IaZeroDriftSum / pCurSamp->u32ZeroDriftCnt;
#endif
#if CUR_SAMP_PHASE_V_SW
        *pCurSamp->ps16IbZero = pCurSamp->s32IbZeroDriftSum / pCurSamp->u32ZeroDriftCnt;
#endif
#if CUR_SAMP_PHASE_W_SW
        *pCurSamp->ps16IcZero = pCurSamp->s32IcZeroDriftSum / pCurSamp->u32ZeroDriftCnt;
#endif

        pCurSamp->bZeroDriftOver = true;

        PwrBootstrap(false, AXIS_NO2IND(pAxisPara->u16AxisNo));
    }
}

void CurSampIsr(cur_samp_t* pCurSamp)
{
    axis_para_t* pAxisPara = pCurSamp->pAxisPara;

    if (pCurSamp->bZeroDriftOver == false)
    {
        // 缓起继电器闭合 -> 自举充电(若有) ->  电流零漂采样
        if (*pCurSamp->cpeSysSts >= SYSTEM_STATE_READY_TO_SWITCH_ON)
        {
            CurSampZeroDrift(pCurSamp);
        }
    }
    else
    {
#if CUR_SAMP_LINE_SW
        LineCurSampPu(pCurSamp);
#elif CUR_SAMP_DOWN_BRG_SW
        DownBrdgCurSampPu(pCurSamp);
#endif
    }

    // 软件过流检测
    if (abs(pAxisPara->s16IaFbPu) > pAxisPara->u16OverCurrTh ||
        abs(pAxisPara->s16IbFbPu) > pAxisPara->u16OverCurrTh ||
        abs(pAxisPara->s16IcFbPu) > pAxisPara->u16OverCurrTh)
    {
        AlmSet(ERR_SW_OC, pAxisPara->u16AxisNo);  // 软件过流
    }

    CurSampSi(pCurSamp);
}
