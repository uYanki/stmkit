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

    ERR_HW_OC,          ///< 硬件保护检出过流 (hardware over current)
    ERR_SW_OC,          ///< 软件保护检出过流 (software over current)
    ERR_UVW_SHORT_GND,  ///< 相线对地短路 (short ground)
    ERR_PHASE_LOST,     ///< 电机缺相
    ERR_ENC_COMM_FAIL,  ///< 编码器通讯异常
    ERR_NEED_RESTORE,   ///< 需恢复出厂 (restore factory)
    ERR_NEED_REBOOT,    ///< 需上电重启 (reboot)
    ERR_MAIN_DC_OV,     ///< 主回路过压 (main DC power over voltage)
    ERR_MAIN_DC_UV,     ///< 主回路欠压 (main DC power under voltage)
    ERR_CTRL_DC_OV,     ///< 控制电过压 (control DC power over voltage)
    ERR_CTRL_DC_UV,     ///< 控制电欠压 (control DC power under voltage)
    ERR_OVERSPEED,      ///< 过速 (over speed), 超过指定速度
    ERR_OVERHEAT,       ///< 过热 (over heat)
    ERR_FLYING_RUN,     ///< 飞车 (flying run), 给定转矩和速度变化方向相反
    ERR_OVERLOAD,       ///< 过载 (over load)

    WRN_MAIN_DC_OV,
    WRN_MAIN_DC_UV,
    WRN_CTRL_DC_OV,
    WRN_CTRL_DC_UV,

    WRN_MOT_PHASE_WS,  ///< 电机线序异常

    WRN_CCW_OT,  ///< 正向超程警告 over travel limit
    WRN_CW_OT,   ///< 反向超程警告 over travel limit

    ERR_SCHED_UNMATCHED,  // 驱动器方案变更
    WRN_NEED_REBOOT,      // 需要重启

    ALM_NUM,

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
    u16         u16Code;
    stop_mode_e eStopMode;
    bool        bMaskable;
    bool        bAutoClr;
} alarm_attr_t;

typedef struct {
    // 历史报警
    u16* pau16HisAlmCode;
    u32* pau32HisAlmTime;

    // 报警状态
    u16 au16AlmTrigTbl[ALM_SRC_NUM][ALM_TAB_NUM];  // 已触发
    u16 au16AlmMaskTbl[ALM_SRC_NUM][ALM_TAB_NUM];  // 被屏蔽
    u16 au16AlmActTbl[ALM_SRC_NUM][ALM_TAB_NUM];   // 已激活

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

void AlmSet(alm_id_e eAlmID, u16 u16AlmSrc);
void AlmRst(alm_id_e eAlmID, u16 u16AlmSrc);
bool AlmChk(alm_id_e eAlmID, u16 u16AlmSrc);
bool AlmHas(u16 u16AlmSrc);
void AlmClr(void);

#ifdef __cplusplus
}
#endif

#endif
