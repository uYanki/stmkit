#ifndef __SCOPE_H__
#define __SCOPE_H__

#include "paratbl.h"

#ifdef __cplusplus
extern "C" {
#endif

// 触发通道数量
#define SCOPE_TRIG_CHAN_NUM 2

// 采样通道数量
#ifdef CONFIG_SCOPE_SAMP_CHAN_NUM
#define SCOPE_SAMP_CHAN_NUM CONFIG_SCOPE_SAMP_CHAN_NUM
#else
#define SCOPE_SAMP_CHAN_NUM 4
#endif

// 单通道最大采样点数
#ifdef CONFIG_SCOPE_SAMP_CHAN_PRD_MAX_CNT
#define SCOPE_SAMP_CHAN_PRD_MAX_CNT CONFIG_SCOPE_SAMP_CHAN_PRD_MAX_CNT
#else
#define SCOPE_SAMP_CHAN_PRD_MAX_CNT 1000
#endif

#define SCOPE_SAMP_BUFF_SIZE (SCOPE_SAMP_CHAN_NUM * SCOPE_SAMP_CHAN_PRD_MAX_CNT)

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef enum {
    SCOPE_SAMP_OBJ_NONE,            // 00-无
    SCOPE_SAMP_OBJ_ANYONE,          // 01-自定义地址
    SCOPE_SAMP_OBJ_UMDC_SI,         // 02-主回路母线电压
    SCOPE_SAMP_OBJ_USER_TRQ_REF,    // 03-用户转矩指令
    SCOPE_SAMP_OBJ_USER_TRQ_FB,     // 04-用户转矩反馈
    SCOPE_SAMP_OBJ_USER_SPD_REF,    // 05-用户速度指令
    SCOPE_SAMP_OBJ_USER_SPD_FB,     // 06-用户速度反馈
    SCOPE_SAMP_OBJ_USER_POS_REF,    // 07-用户位置指令
    SCOPE_SAMP_OBJ_USER_POS_FB,     // 08-用户位置反馈
    SCOPE_SAMP_OBJ_DRV_SPD_REF,     // 09-驱动层速度指令
    SCOPE_SAMP_OBJ_DRV_SPD_FB,      // 10-驱动层速度反馈
    SCOPE_SAMP_OBJ_DRV_POS_REF,     // 11-驱动层位置指令
    SCOPE_SAMP_OBJ_DRV_POS_FB,      // 12-驱动层位置反馈
    SCOPE_SAMP_OBJ_ELEC_ANGLE_REF,  // 13-电角度指令
    SCOPE_SAMP_OBJ_ELEC_ANGLE_FB,   // 14-电角度反馈
    SCOPE_SAMP_OBJ_PWM_CMP_A,       // 15-U相占空比
    SCOPE_SAMP_OBJ_PWM_CMP_B,       // 16-V相占空比
    SCOPE_SAMP_OBJ_PWM_CMP_C,       // 17-W相占空比
    SCOPE_SAMP_OBJ_CUR_A_PU_FB,     // 18-U相电流反馈
    SCOPE_SAMP_OBJ_CUR_B_PU_FB,     // 19-V相电流反馈
    SCOPE_SAMP_OBJ_CUR_C_PU_FB,     // 20-W相电流反馈
    SCOPE_SAMP_OBJ_Q_AXIS_REF,      // 21-Q轴电流指令
    SCOPE_SAMP_OBJ_Q_AXIS_FB,       // 22-Q轴电流反馈
    SCOPE_SAMP_OBJ_D_AXIS_REF,      // 23-D轴电流指令
    SCOPE_SAMP_OBJ_D_AXIS_FB,       // 24-D轴电流反馈
    SCOPE_SAMP_OBJ_S64_DBG_BUF1,    // 25-调试缓冲数据1（有符号64位）
    SCOPE_SAMP_OBJ_S64_DBG_BUF2,    // 26-调试缓冲数据2（有符号64位）
    SCOPE_SAMP_OBJ_S64_DBG_BUF3,    // 27-调试缓冲数据3（有符号64位）
    SCOPE_SAMP_OBJ_S64_DBG_BUF4,    // 28-调试缓冲数据4（有符号64位）
    SCOPE_SAMP_OBJ_U64_DBG_BUF1,    // 29-调试缓冲数据1（无符号64位）
    SCOPE_SAMP_OBJ_U64_DBG_BUF2,    // 30-调试缓冲数据2（无符号64位）
    SCOPE_SAMP_OBJ_U64_DBG_BUF3,    // 31-调试缓冲数据3（无符号64位）
    SCOPE_SAMP_OBJ_U64_DBG_BUF4,    // 32-调试缓冲数据4（无符号64位）
} scope_samp_obj_sel_e;

typedef enum {
    SCOPE_TRIG_OBJ_NONE,          // 00-无
    SCOPE_TRIG_OBJ_ANYONE,        // 01-用户自定义
    SCOPE_TRIG_OBJ_SERVO_ON,      // 02-伺服使能信号
    SCOPE_TRIG_OBJ_PWM_ON,        // 03-PWM使能信号
    SCOPE_TRIG_OBJ_USER_TRQ_REF,  // 04-用户转矩指令
    SCOPE_TRIG_OBJ_USER_TRQ_FB,   // 05-用户转矩反馈
    SCOPE_TRIG_OBJ_USER_SPD_REF,  // 06-用户速度指令
    SCOPE_TRIG_OBJ_USER_SPD_FB,   // 07-用户速度反馈
    SCOPE_TRIG_OBJ_USER_POS_REF,  // 08-用户位置指令
    SCOPE_TRIG_OBJ_USER_POS_FB,   // 09-用户位置反馈
    SCOPE_TRIG_OBJ_UMDC_SI,       // 10-主回路母线电压
    SCOPE_TRIG_OBJ_ALARM,         // 11-报警代码
} scope_trig_obj_sel_e;

typedef enum {
    SCOPE_STATE_IDLE,
    SCOPE_STATE_INIT,
    SCOPE_STATE_WAITING,  ///< waiting for trig signal
    SCOPE_STATE_BUSY,     ///< sample data
    SCOPE_STATE_UPLOAD,   ///< upload sample data to external device
} scope_state_e;

typedef enum {
    SCOPE_UPLOAD_STANDBY,
    SCOPE_UPLOAD_PREPARE,
    SCOPE_UPLOAD_READY,
    SCOPE_UPLOAD_BUSY,
    SCOPE_UPLOAD_OVER,
} scope_upload_state_e;

typedef enum {
    SCOPE_TRIG_MODE_A,
    SCOPE_TRIG_MODE_A_AND_B,
    SCOPE_TRIG_MODE_A_OR_B,
} scope_trig_mode_e;

typedef enum {
    SCOPE_TRIG_COND_RISING_EDGE,           // 上升沿
    SCOPE_TRIG_COND_FALLING_EDGE,          // 下降沿
    SCOPE_TRIG_COND_LESS_THAN,             // 小于
    SCOPE_TRIG_COND_GREATER_THAN,          // 大于
    SCOPE_TRIG_COND_NOT_LESS_THAN,         // 小于等于
    SCOPE_TRIG_COND_NOT_GREATER_THAN,      // 大于等于
    SCOPE_TRIG_COND_RISING_EDGE_ABS,       // 上升沿(绝对值)
    SCOPE_TRIG_COND_FALLING_EDGE_ABS,      // 下降沿(绝对值)
    SCOPE_TRIG_COND_LESS_THAN_ABS,         // 小于(绝对值)
    SCOPE_TRIG_COND_GREATER_THAN_ABS,      // 大于(绝对值)
    SCOPE_TRIG_COND_NOT_LESS_THAN_ABS,     // 小于等于(绝对值)
    SCOPE_TRIG_COND_NOT_GREATER_THAN_ABS,  // 大于等于(绝对值)
} scope_trig_cond_e;

typedef struct {
    RO u16* pu16ParaAddr;
    u16*    pu16BuffAddr;
    u8      u8ParaSign;
    u8      u8ParaWordCnt;
} scope_samp_obj_t;

typedef struct {
    scope_trig_cond_e eTrigCond;  // 触发条件

    RO u16* pu16ParaAddr;  // 参数地址
    u8      u8ParaSign;
    u8      u8ParaWordCnt;
    u16     au16ParaPreVal[4];  // 初始值
    u64     u64ParaThold;       // 触发阈值
} scope_trig_obj_t;

typedef struct {
    bool bEnable;

    device_para_t* pDevicePara;
    axis_para_t*   pAxisPara[CONFIG_AXIS_NUM];

    u16 u16SampIdx;     // 当前采样点索引
    u16 u16SampCnt;     // 采样点数
    u16 u16SampPrd;     // 采样周期
    u16 u16SampPrdCnt;  // 采样周期间隔计数

    u16* pu16SampBuff;  // 采样缓冲区

    u8 u8SampChanNum;  // 采样对象数
    u8 u8TrigChanNum;  // 触发对象数

    u16  u16PointsBeforeTrig;
    u16  u16PointsAfterTrig;
    bool bPointsEnough;

    scope_trig_mode_e eTrigMode;  // 触发模式

    scope_samp_obj_t aSampObj[SCOPE_SAMP_CHAN_NUM];  // 采样对象
    scope_trig_obj_t aTrigObj[SCOPE_TRIG_CHAN_NUM];  // 触发对象

} scope_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void ScopeCreat(scope_t* pScope);
void ScopeInit(scope_t* pScope);
void ScopeCycle(scope_t* pScope);
void ScopeIsr(scope_t* pScope);

void ScopeInitSampObj(scope_t* pScope);
void ScopeRecordSampObj(scope_t* pScope);

#ifdef __cplusplus
}
#endif

#endif  // !__SCOPE_H__

