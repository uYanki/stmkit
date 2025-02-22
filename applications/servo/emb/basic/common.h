#ifndef __COMMON_H__
#define __COMMON_H__

#include "typebasic.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define MOT_CUSTOM_ENC_CUSTOM 0
#define MOT_2804_ENC_MT6701   1

/**
 * @note 轮廓模式：上位机给定目标值，轨迹由伺服内部规划
 * @note 周期同步模式：上位机给定过程值，轨迹由上位机规划
 */
#define DS402_MODE_PPM 1   // PPM: Profile Position             轮廓位置模式
#define DS402_MODE_PVM 3   // PVM: Profile Velocity             轮廓速度模式
#define DS402_MODE_HMM 6   // HMM: Homing                       回原模式
#define DS402_MODE_CSP 8   // CSP: Cyclic Synchronous Position  周期同步位置模式
#define DS402_MODE_CSV 9   // CSV: Cyclic Synchronous Velocity  周期同步速度模式
#define DS402_MODE_CST 10  // CST: Cyclic Synchronous Torque    周期同步转矩模式

typedef enum {
    SYSTEM_STATE_INITIAL,             ///< system initial
    SYSTEM_STATE_READY_TO_SWITCH_ON,  ///< system ready to switch on
    SYSTEM_STATE_SWITCHED_ON,         ///< system switched on, waiting for command
    SYSTEM_STATE_OPERATION_ENABLE,    ///< system operation enabled
    SYSTEM_STATE_FAULT_DIAGNOSE,      ///< fault or warning occured, need to diagnose
} system_state_e;

typedef enum {
    AXIS_STATE_INITIAL,  ///< axis initial
    AXIS_STATE_STANDBY,  ///< axis status is ok, waiting for command
    AXIS_STATE_ENABLE,   ///< axis is enabled
    AXIS_STATE_FAULT,    ///< axis fault
} axis_state_e;

typedef enum {
    AXIS_APP_GENERIC,      // 通用控制
    AXIS_APP_OPENLOOP,     // 开环测试
    AXIS_APP_ENCIDENT,     // 编码器辨识
    AXIS_APP_LOOPRSP,      // 响应测试
    AXIS_APP_OFFMOTIDNET,  // 离线电机参数辨识
    AXIS_APP_INVAILD,
} axis_app_e;

typedef enum {
    SECTOR_1,
    SECTOR_2,
    SECTOR_3,
    SECTOR_4,
    SECTOR_5,
    SECTOR_6,
} sector_e;

/**
 * @brief 编码器类型
 */
typedef enum {
    ENC_HALL_UVW,     // 0-Hall
    ENC_ABS_TFORMAT,  // 1-Tformat
    ENC_ABS_AS5600,   // 2-12B磁编 AS5600
    ENC_ABS_MT6701,   // 3-14B磁编 MT6701
    ENC_ABS_MT6816,   // 4-14B磁编 MT6816
    ENC_ABS_MT6835,   // 5-21B磁编 MT6835
    ENC_INC_2500,     // 6-ABZ光编 2500线
    ENC_INC_1000,     // 7-ABZ光编 1000线
} enc_type_e;

/**
 * @brief 控制方法
 */
typedef enum {
    CTRL_METHOD_FOC_CLOSED,
    CTRL_METHOD_FOC_OPEN,
} ctrl_method_e;

/**
 * @brief 控制模式
 */
typedef enum {
    CTRL_MODE_POS,       ///< position mode
    CTRL_MODE_SPD,       ///< speed mode
    CTRL_MODE_TRQ,       ///< torque mode
    CTRL_MODE_DS402,     ///< ds402 over CANopen/EtherCAT mode
    CTRL_MODE_PROFINET,  ///< pn
} ctrl_mode_e;

/**
 * @brief 控制指令来源
 */
typedef enum {
    CTRL_CMD_SRC_COMM,  ///< communication parameter
    CTRL_CMD_SRC_DI,    ///< digital input
} ctrl_cmd_src_e;

/**
 * @brief 控制字
 */
typedef union {
    struct {
        u32 Enable     : 1;
        u32 JogFwd     : 1;
        u32 JogRev     : 1;
        u32 MultEn     : 1;
        u32 PosLimRev  : 1;
        u32 PosLimFwd  : 1;
        u32 AlmRst     : 1;
        u32 EncTurnClr : 1;  // 多圈清除
        u32 Home       : 1;  // 原点信号
        u32 HomeEn     : 1;  // 回原启动
        u32 RotDir     : 1;  // 旋转方向
        u32 _Resv      : 24;
    } u32Bit;
    u32 u32All;
} ctrlword_u;

/**
 * @brief 上电控制
 */
typedef union {
    struct {
        u16 DrvEnable : 1;  // 自动使能
        u16 HomingEn  : 1;  // 自动回原
        u16 _Resv     : 14;
    } u16Bit;
    u16 u16All;
} pwron_cmd_conf_u;

/**
 * @brief 状态字
 */
typedef struct {
    u32 ServoOn : 1;
    u32 _Resv   : 31;
} statusword_t;

/**
 * @brief 速度指令源
 */
typedef enum {
    SPD_REF_SRC_DIGITAL,
    SPD_REF_SRC_MULTI_DIGITAL,
    SPD_REF_SRC_AI_1,
    SPD_REF_SRC_AI_2,
} spd_ref_src_e;

/**
 * @brief 速度限制源
 */
typedef enum {
    SPD_LIM_NONE,
    SPD_LIM_S,     ///< 正反向均为速度限制0
    SPD_LIM_M,     ///< 正向为速度限制0，反向为速度限制1
    SPD_LIM_AI_S,  ///< 正反向速度限制均由AI1决定
    SPD_LIM_AI_M,  ///< 正反速度限制均由AI1决定，反向为速度限制均由AI2决定
} spd_lim_src_e;

/**
 * @brief  速度限制状态
 */
typedef enum {
    SPD_LIM_STATUS_NO,   ///< 速度限制未触发
    SPD_LIM_STATUS_FWD,  ///< 正向速度限制触发
    SPD_LIM_STATUS_REV,  ///< 反向速度限制触发
} spd_lim_sts_e;

/**
 * @brief  速度规划模式
 */
typedef enum {
    SPD_PLAN_MODE_SLOPE,     ///< 斜坡规划
    SPD_PLAN_MODE_CURVE_X3,  ///< S曲线, 三次多项式规划
    SPD_PLAN_MODE_CURVE_X2,  ///< S曲线, 二次多项式规划
    SPD_PLAN_MODE_STEP,      ///< 无规划，直接阶跃
} spd_plan_mode_e;

typedef enum {
    TRQ_LIM_S,     ///< 正反向均为转矩限制0
    TRQ_LIM_M,     ///< 正向为转矩限制0，反向为转矩限制1
    TRQ_LIM_AI_S,  ///< 正反向转矩限制均由AI1决定
    TRQ_LIM_AI_M,  ///< 正反转矩限制均由AI1决定，反向为转矩限制均由AI2决定
} trq_lim_src_e;

/**
 * @brief 转矩指令来源
 */
typedef enum {
    TRQ_REF_SRC_DIGITAL,
    TRQ_REF_SRC_MULTI_DIGITAL,
    TRQ_REF_SRC_AI_1,
    TRQ_REF_SRC_AI_2,
} trq_ref_src_e;

/**
 * @brief 停机过程方式
 */
typedef enum {
    STOP_MODE_NO,        ///< 不停机
    STOP_MODE_FREE,      ///< 自由停机(关闭PWM输出)
    STOP_MODE_DEC,       ///< 减速停机(按减速时间DEC停机)
    STOP_MODE_ZERO_SPD,  ///< 零速停机(给0速度阶跃指令)
    STOP_MODE_DB_TRQ,    ///< 动态转矩制动停机(给定反向转矩指令)
    STOP_MODE_DB_FLUX,   ///< 动态磁通制动停机(给定磁通指令)
    STOP_MODE_DB_RES,    ///< 动态能耗制动停机(永磁电机有效,需硬件支持,电机相线并电阻短接)
} stop_mode_e;

/**
 * @brief 停机完成后动作
 */
typedef enum {
    STOP_OVER_MODE_INVALID,    ///< 无效
    STOP_OVER_MODE_FREE,       ///< 自由运行(关闭PWM输出)
    STOP_OVER_MODE_ZERO_LOCK,  ///< 零位锁定
    STOP_OVER_MODE_DB_RES,     ///< 动态能耗制动(永磁电机有效,需硬件支持,电机相线并电阻短接)
} stop_over_mode_e;

/**
 * @brief 位置指令源
 */
typedef enum {
    POS_REF_SRC_DIGITAL,        ///< 数字位置指令
    POS_REF_SRC_MULTI_DIGITAL,  ///< 多段数字位置指令
    POS_REF_SRC_PULSE,          ///< 脉冲位置指令
} pos_ref_src_e;

/**
 * @brief 相对位置指令生效模式
 */
typedef enum {
    POS_REF_SET_IMMEDIATELY,  ///< 位置指令立即生效
    POS_REF_SET_TRIGGER,      ///< 位置指令触发生效
} pos_ref_set_e;

/**
 * @brief 位置指令类型
 */
typedef enum {
    POS_REF_TYPE_ABSOLUTE,
    POS_REF_TYPE_RELATIVE,
} pos_ref_type_e;

/**
 * @brief 行程限位源
 */
typedef enum {
    POS_LIM_SRC_NONE,            ///< 无位置限定
    POS_LIM_SRC_DIGITAL_REGION,  ///< 数字边界位置限制
    POS_LIM_SRC_SWITCH_SIGNAL,   ///< 开关信号位置限制(DI/通信命令)
} pos_lim_src_e;

/**
 * @brief 行程限位状态
 */
typedef enum {
    POS_LIM_STATUS_NO,   ///< 位置限制未触发
    POS_LIM_STATUS_FWD,  ///< 正向位置限制触发
    POS_LIM_STATUS_REV,  ///< 反向位置限制触发
} pos_lim_sts_e;

/**
 * @brief  转矩限制状态
 */
typedef enum {
    TRQ_LIM_STATUS_NO,   ///< 转矩限制未触发
    TRQ_LIM_STATUS_FWD,  ///< 正向转矩限制触发
    TRQ_LIM_STATUS_REV,  ///< 反向转矩限制触发
} trq_lim_sts_e;

/**
 * @brief 位置规划模式
 */
typedef enum {
    POS_PLAN_MODE_CURVE_X2,   ///< 二次曲线规划(速度一次曲线(斜坡)，位置二次曲线)
    POS_PLAN_MODE_CURVE_SIN,  ///< SIN曲线规划(速度COS曲线，位置SIN曲线)
    POS_PLAN_MODE_STEP,       ///< 无规划，直接阶跃
    POS_PLAN_MODE_SLOPE,      ///< 一次斜坡规划(直线插补)
} pos_plan_mode_e;

__attr_packed(typedef struct)
{
    u16 u16MotPolePairs;   // 电机极对数
    u32 u32MotInertia;     // 电机转动惯量 [0.001kg/cm2]
    u16 u16MotStatorRes;   // 电机定子电阻 [mΩ]
    u16 u16MotStatorLd;    // 电机定子D轴电感 [0.01mH]
    u16 u16MotStatorLq;    // 电机定子Q轴电感 [0.01mH]
    u16 u16MotEmfCoeff;    // 电机反电动势常数
    u16 u16MotTrqCoeff;    // 电机转矩系数
    u16 u16MotTm;          // 电机机械时间常数
    u16 u16MotVoltInRate;  // 电机额定输入电压 [V]
    u16 u16MotPowerRate;   // 电机额定功率 [0.01kW]
    u16 u16MotCurRate;     // 电机额定电流 [0.01A]
    u16 u16MotCurMax;      // 电机最大电流 [0.01A]
    u16 u16MotTrqRate;     // 电机额定转矩 [0.01N/m]
    u16 u16MotTrqMax;      // 电机最大转矩 [0.01N/m]
    u16 u16MotSpdRate;     // 电机额定转速 [rpm]
    u16 u16MotSpdMax;      // 电机最大转速 [rpm]
    u16 u16MotAccMax;      // 电机最大加速度 [m/s2]
    u16 u16EncSN;          // 编码器序列号
    u16 u16EncMethod;      // 编码器原理
    u16 u16EncType;        // 编码器类型
    u32 u32EncRes;         // 编码器分辨率 [pulse]
    u32 u32EncPosOffset;   // 编码器电角度偏置
}
MotEncPara_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

#ifdef __cplusplus
}
#endif

#endif  // ! __COMMON_H__
