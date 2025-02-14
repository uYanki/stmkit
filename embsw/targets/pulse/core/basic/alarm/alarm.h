#ifndef __ALARM_H__
#define __ALARM_H__

#include "paratbl.h"
#include "delay.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define ALM_TAB_NUM 2
#define ALM_SRC_NUM (CONFIG_AXIS_NUM + 1)  // 0: DEVICE, 1~n:AXIS_N

#define HIS_ALM_CNT 15  // 历史报警记录数

typedef enum {

    ERR_NEED_RESTORE,  ///< 设备方案变更需恢复出厂 (restore factory)
    ERR_NEED_REBOOT,   ///< 恢复出厂后需上电重启 (reboot)
    ERR_PARA_RW_ERR,   ///< EEPROM读写异常

    ERR_DI_FUNC_CONFLICT,  ///< DI功能配置冲突
    ERR_DO_FUNC_CONFLICT,  ///< DO功能配置冲突

    ALM_NUM,

    ALM_NONE,

} alm_id_e;

typedef union {
    u16 u16All;
    struct {
        u16 Maskable : 1;  ///< 报警能否被屏蔽 0:不可屏蔽 1:可屏蔽
        u16 StopSrc  : 2;  ///< 报警后的停机触发源 0:S4触发源  1:S5触发源 2:S6触发源 3:S7触发源 4:S8触发源
        u16 RstType  : 3;  ///< 报警解除方式 0:立即可触发解除 1:10s后可触发解除  2:状态正常自动解除 3:不可解除
    } u16Bit;
} alm_attr_u;

typedef struct {
    u16  u16Code;
    bool bMaskable;
    bool bAutoClr;
} alarm_attr_t;

typedef struct {
    // 历史报警
    u16* pau16HisAlmCode;
    u32* pau32HisAlmTime;

    // 报警状态
    u16 au16AlmTrigTbl[ALM_TAB_NUM];  // 已触发
    u16 au16AlmMaskTbl[ALM_TAB_NUM];  // 被屏蔽
    u16 au16AlmActTbl[ALM_TAB_NUM];   // 已激活

    // 最新报警
    // u16 u16LastAlmSrc;
    // u16 u16LastAlmCode;

    // 报警轮询

} alm_mgr_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void AlmCreat(void);
void AlmInit(void);
void AlmCycle(void);

void AlmSet(alm_id_e eAlmID);
void AlmRst(alm_id_e eAlmID);
bool AlmChk(alm_id_e eAlmID);
void AlmClr(void);

#ifdef __cplusplus
}
#endif

#endif
