#include "alarm.h"
#include "tim/bsp_tim.h"
#include "scheduler.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "alarm"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

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
    [ERR_NEED_RESTORE]     = {106, false},
    [ERR_NEED_REBOOT]      = {107, false},
    [ERR_PARA_RW_ERR]      = {521, false},
    [ERR_DI_FUNC_CONFLICT] = {800, false},
    [ERR_DO_FUNC_CONFLICT] = {801, false},
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
    pAlmMgr->pau32HisAlmTime[0] = GetTickMs();

    AlmHisSave();
}

void AlmSet(alm_id_e eAlmID)
{
    u16* pAlmTrigTbl = pAlmMgr->au16AlmTrigTbl;
    u16* pAlmMaskTbl = pAlmMgr->au16AlmMaskTbl;
    u16* pAlmActTbl  = pAlmMgr->au16AlmActTbl;

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
    // D.eSysState = SYSTEM_STATE_FAULT_DIAGNOSE;

    // 最新报警
    D.u16LastAlmCode = aAlmTbl[eAlmID].u16Code;

#if 1
    // 轮询报警 (debug only)
    D.u16AlmCodeSeq = D.u16LastAlmCode;
#endif

    // 历史报警记录
    AlmHisUpdate();
}

void AlmRst(alm_id_e eAlmID)
{
    u16* pAlmTrigTbl = pAlmMgr->au16AlmTrigTbl;
    // u16* pAlmMaskTbl = pAlmMgr->au16AlmMaskTbl;
    // u16* pAlmActTbl  = pAlmMgr->au16AlmActTbl;

    // 仅清除报警触发状态
    CLRBITTAB(pAlmTrigTbl, eAlmID);

    // TODO: 清除报警激活状态(这个用户写入清除错误指令才执行), 不自动清除
    // CLRBITTAB(pAlmActTbl, eAlmID);
}

bool AlmChk(alm_id_e eAlmID)
{
    if (eAlmID == ALM_NONE)
    {
        u8   u8AlmTab;
        u16* pAlmActTbl;

        pAlmActTbl = pAlmMgr->au16AlmActTbl;

        for (u8AlmTab = 0; u8AlmTab < ALM_TAB_NUM; ++u8AlmTab)
        {
            if (pAlmActTbl[u8AlmTab] != 0)
            {
                return true;
            }
        }

        return false;
    }
    else
    {
        u16* pAlmActTbl = pAlmMgr->au16AlmActTbl;

        return CHKBITTAB(pAlmActTbl, eAlmID);
    }
}

/**
 * @brief 清除已恢复正常的报警
 */
void AlmClr(void)
{
    u16* pAlmTrigTbl = pAlmMgr->au16AlmTrigTbl;
    u16* pAlmActTbl  = pAlmMgr->au16AlmActTbl;

    for (u8 u8AlmTab = 0; u8AlmTab < ALM_TAB_NUM; ++u8AlmTab)
    {
        // 清除不处于触发状态的但已激活报警
        pAlmActTbl[u8AlmTab] &= pAlmTrigTbl[u8AlmTab];
    }
}
