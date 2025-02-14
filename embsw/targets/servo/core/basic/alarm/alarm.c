#include "alarm.h"
#include "tim/bsp_tim.h"
#include "scheduler.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG       "alarm"
#define LOG_LOCAL_LEVEL     LOG_LEVEL_INFO

#define MOT_2804_ENC_MT6701 1

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

alm_mgr_t sAlmMgr = {0};

alm_mgr_t* pAlmMgr = &sAlmMgr;

// 报警代码数值越小，错误越严重
alarm_attr_t aAlmTbl[ALM_NUM] = {
    [ERR_HW_OC]           = {100, STOP_MODE_FREE, false},
    [ERR_SW_OC]           = {101, STOP_MODE_FREE, false},
    [ERR_UVW_SHORT_GND]   = {102, STOP_MODE_FREE, false},
    [ERR_PHASE_LOST]      = {103, STOP_MODE_FREE, false},
    [ERR_ENC_COMM_FAIL]   = {105, STOP_MODE_FREE, false},
    [ERR_NEED_RESTORE]    = {106, STOP_MODE_FREE, false},
    [ERR_NEED_REBOOT]     = {107, STOP_MODE_FREE, false},
    [ERR_MAIN_DC_OV]      = {108, STOP_MODE_FREE, false},
    [ERR_MAIN_DC_UV]      = {109, STOP_MODE_FREE, false},
    [ERR_CTRL_DC_OV]      = {110, STOP_MODE_FREE, false},
    [ERR_CTRL_DC_UV]      = {111, STOP_MODE_FREE, false},
    [ERR_OVERSPEED]       = {112, STOP_MODE_FREE, false},
    [ERR_OVERHEAT]        = {113, STOP_MODE_FREE, false},
    [ERR_FLYING_RUN]      = {114, STOP_MODE_FREE, false},
    [ERR_OVERLOAD]        = {115, STOP_MODE_FREE, false},
    [WRN_MAIN_DC_OV]      = {516, STOP_MODE_FREE, false},
    [WRN_MAIN_DC_UV]      = {517, STOP_MODE_FREE, false},
    [WRN_CTRL_DC_OV]      = {518, STOP_MODE_FREE, false},
    [WRN_CTRL_DC_UV]      = {519, STOP_MODE_FREE, false},
    [WRN_MOT_PHASE_WS]    = {520, STOP_MODE_FREE, false},
    [WRN_CCW_OT]          = {521, STOP_MODE_FREE, false},
    [WRN_CW_OT]           = {522, STOP_MODE_FREE, false},
    [ERR_SCHED_UNMATCHED] = {523, STOP_MODE_FREE, false},
    [WRN_NEED_REBOOT]     = {524, STOP_MODE_FREE, false},
};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void SETBITTAB(u16* pu16Tab, u8 u8Bit)
{
    pu16Tab[u8Bit >> 4] |= (1 << (u8Bit & 0xF));
}

void CLRBITTAB(u16* pu16Tab, u8 u8Bit)
{
    pu16Tab[u8Bit >> 4] &= ~(1 << (u8Bit & 0xF));
}

bool CHKBITTAB(u16* pu16Tab, u8 u8Bit)
{
    return pu16Tab[u8Bit >> 4] & (1 << (u8Bit & 0xF));
}

void AlmCreat(void)
{
    pAlmMgr->pau16HisAlmCode = &D.u16HisAlmCode01;
    pAlmMgr->pau32HisAlmTime = &D.u32HisAlmTime01;
}

void AlmInit(void) {}

void AlmCycle(void) {}

/**
 * @brief 保存历史报警记录
 */
static void AlmHisSave(void)
{
}

/**
 * @brief 清除历史报警记录
 */
static void AlmHisClr(void)
{
    for (u8 i = 0; i < HIS_ALM_CNT; ++i)
    {
        pAlmMgr->pau16HisAlmCode[i] = 0;
        pAlmMgr->pau32HisAlmTime[i] = 0;
    }

    AlmHisSave();
}

/**
 * @brief 更新历史报警记录
 */
static void AlmHisUpdate()
{
    for (u8 i = HIS_ALM_CNT - 1; i > 0; --i)
    {
        pAlmMgr->pau16HisAlmCode[i] = pAlmMgr->pau16HisAlmCode[i - 1];
        pAlmMgr->pau32HisAlmTime[i] = pAlmMgr->pau32HisAlmTime[i - 1];
    }

    pAlmMgr->pau16HisAlmCode[0] = D.u16LastAlmCode;
    pAlmMgr->pau32HisAlmTime[0] = GetTickUs();

    AlmHisSave();
}

void AlmSet(alm_id_e eAlmID, u16 u16AlmSrc)
{
    u16* pAlmTrigTbl = pAlmMgr->au16AlmTrigTbl[u16AlmSrc];
    u16* pAlmMaskTbl = pAlmMgr->au16AlmMaskTbl[u16AlmSrc];
    u16* pAlmActTbl  = pAlmMgr->au16AlmActTbl[u16AlmSrc];

    // 设置报警触发状态
    SETBITTAB(pAlmTrigTbl, eAlmID);

    // 检查报警激活状态
    if (CHKBITTAB(pAlmActTbl, eAlmID))
    {
        return;  // 报警已激活
    }

    // 检查报警屏蔽状态
    if (CHKBITTAB(pAlmMaskTbl, eAlmID))
    {
        return;  // 报警被屏蔽
    }

    // 设置报警激活状态
    SETBITTAB(pAlmActTbl, eAlmID);

    // 根据报警属性的停机模式来停机
    if (eAlmID <= ERR_OVERLOAD)
    {
        // 关闭PWM, 自由滑行
        PwmGen(false, 0);  // P(u16AlmSrc).u16AxisNo
        P(0).eAxisFSM = AXIS_STATE_FAULT;
        // D.u16SysState = SYSTEM_STATE_FAULT_DIAGNOSE;
    }

    // 最新报警
    D.u16LastAlmCode = 1000 * u16AlmSrc + aAlmTbl[eAlmID].u16Code;

#if 1
    // 轮询报警 (debug only)
    D.u16AlmCodeSeq = D.u16LastAlmCode;
#endif

    // 历史报警记录
    AlmHisUpdate();
}

void AlmRst(alm_id_e eAlmID, u16 u16AlmSrc)
{
    u16* pAlmTrigTbl = pAlmMgr->au16AlmTrigTbl[u16AlmSrc];
    // u16* pAlmMaskTbl = pAlmMgr->au16AlmMaskTbl[u16AlmSrc];
    // u16* pAlmActTbl  = pAlmMgr->au16AlmActTbl[u16AlmSrc];

    // 仅清除报警触发状态
    CLRBITTAB(pAlmTrigTbl, eAlmID);

    // TODO: 清除报警激活状态(这个用户写入清除错误指令才执行), 不自动清除
    // CLRBITTAB(pAlmActTbl, eAlmID);
}

bool AlmChk(alm_id_e eAlmID, u16 u16AlmSrc)
{
    u16* pAlmActTbl = pAlmMgr->au16AlmActTbl[u16AlmSrc];

    return CHKBITTAB(pAlmActTbl, eAlmID);
}

bool AlmHas(u16 u16AlmSrc)
{
    u8   u8AlmTab;
    u16* pAlmActTbl;

    pAlmActTbl = pAlmMgr->au16AlmActTbl[0];

    for (u8AlmTab = 0; u8AlmTab < ALM_TAB_NUM; ++u8AlmTab)
    {
        if (pAlmActTbl[u8AlmTab] != 0)
        {
            return true;
        }
    }

    if (u16AlmSrc > 0)
    {
        pAlmActTbl = pAlmMgr->au16AlmActTbl[u16AlmSrc];

        for (u8AlmTab = 0; u8AlmTab < ALM_TAB_NUM; ++u8AlmTab)
        {
            if (pAlmActTbl[u8AlmTab] != 0)
            {
                return true;
            }
        }
    }

    return false;
}

/**
 * @brief 清除已恢复正常的报警
 */
void AlmClr(void)
{
    for (u16 u16AlmSrc = 0; u16AlmSrc < ALM_SRC_NUM; ++u16AlmSrc)
    {
        u16* pAlmTrigTbl = pAlmMgr->au16AlmTrigTbl[u16AlmSrc];
        u16* pAlmActTbl  = pAlmMgr->au16AlmActTbl[u16AlmSrc];

        for (u8 u8AlmTab = 0; u8AlmTab < ALM_TAB_NUM; ++u8AlmTab)
        {
            // 清除不处于触发状态的但已激活报警
            pAlmActTbl[u8AlmTab] &= pAlmTrigTbl[u8AlmTab];
        }
    }
}
