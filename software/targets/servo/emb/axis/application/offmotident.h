#ifndef __OFF_MOT_IDENT_H__
#define __OFF_MOT_IDENT_H__

#include "paratbl.h"
#include "typebasic.h"

#define CONFIG_CURSAMP_SW 0

/**
 * @brief 电机编码器参数辨识
 *
 * 使用前提：
 * - 1.电机空载
 * - 2.编码器读数正常
 * - 3.动力线UVW正常(无对地短路)
 *
 * 可辨识信息：
 * - 1.电机相序
 * - 2.编码器分辨率
 * - 3.电机极对数
 * - 4.编码器安装偏置
 */

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

/**
 * @brief 辨识状态
 */
// typedef enum {
//     OFLN_MOT_PARA_INIT,     ///< 初始化阶段
//     OFLN_MOT_PARA_R_ALPHA,  ///< alpha轴电阻辨识阶段
//     OFLN_MOT_PARA_R_BETA,   ///< beta轴电阻辨识阶段
//     OFLN_MOT_PARA_LD,       ///< d轴电感辨识阶段
//     OFLN_MOT_PARA_LQ,       ///< q轴电感辨识阶段
//     OFLN_MOT_PARA_FLUX,     ///< 磁链辨识阶段
//     OFLN_MOT_PARA_ANALYSE,  ///< 完成辨识流程，计算结果
//     OFLN_MOT_PARA_FINISH,   ///< 辨识结束
// } off_mot_ident_state_e;

typedef enum {
    OFLN_MOTPARA_INIT,  ///< 初始化阶段

    OFLN_MOTPARA_R_ALPHA_ADAPT_R,  ///< alpha轴电阻辨识阶段
    OFLN_MOTPARA_R_BETA_ADAPT_R,   ///< beta轴电阻辨识阶段
    OFLN_MOTPARA_LD,               ///< d轴电感辨识阶段
    OFLN_MOTPARA_LQ,               ///< q轴电感辨识阶段
    OFLN_MOTPARA_FLUX,             ///< 磁链辨识阶段
    OFLN_MOTPARA_ANALYSE,          ///< 完成辨识流程，计算结果
    OFLN_MOTPARA_FINISH,           ///< 辨识结束
} OfflineMotPara_E;

#define HIGH_FREQ_INJE_CALC_CNT 4                                         // 高频注入计算周期
#define Flux_IDENT_FREQ         10                                        // 磁链辨识电速度频率
#define FLUX_IDENT_SPD          Flux_IDENT_FREQ * 65535 / CUR_LOOP_FREQ;  // 磁链辨识电角度增量

/**
 * @brief 控制字
 */
typedef union {
    struct {
        u16 Enable : 1;  ///< 0: disable; 1: enable;
        u16 _Resv  : 15;
    } u16Bit;
    u16 u16All;
} off_mot_ctrlword_u;

typedef struct {
    axis_para_t* pAxisPara;

    // 应用层输出
    // struct {
    //     ctrl_method_e eCtrlMethod;    ///< 控制方式
    //     ctrl_mode_e   eCtrlMode;      ///< 控制模式
    //     ctrlword_u    uCtrlCmd;       ///< 控制命令
    //     s16           s16IdRef;       ///< 转矩指令
    //     s16           s16IqRef;       ///< 磁通指令
    //     u16           u16ElecAngRef;  ///< 电角度指令
    // } AppOut;

    // RO MotEncPara0_Str* RO* cppMot;
    RO bool* cpeEnState;  ///< 驱动器使能状态
                          //  RO s16* cps16IalphaFb;
                          //  RO s16* cps16IbetaFb;
                          //  RO s16* cps16IqFb;
                          //  RO s16* cps16IdFb;
    // 电压重构参数
    RO u16*  cpu16UmdcLpf1;  // 母线电压数字量
    RO u16*  cpu16PwmaComp;  // A相PWM比较器值
    RO u16*  cpu16PwmbComp;  // B相PWM比较器值
    RO u16*  cpu16PwmcComp;  // C相PWM比较器值

    // CtrlCmdSrc_U uCmdSrc;
    ctrl_mode_e   eCtrlMode;
    ctrlword_u    uCtrlCmd;  ///< 控制命令
    ctrl_method_e eCtrlMethod;

    u16 u16CtrlCmdSrcRec;  ///< 控制命令来源记录

    bool* peEnable;  ///< 使能命令

    OfflineMotPara_E eState;  ///< 辨识状态

    // 指令参数
    s16 s16UdRef;
    s16 s16UqRef;
    u16 u16ElecAngRef;

    s16 s16IdRef;
    s16 s16IdRefLim;  // d轴电流需要做变化斜率变化
    s16 s16IqRef;

    // 状态参数
    bool eAdaptVoltStep;  // B_TURE:第一段电压锁定已完成 B_FALSE:第一段电压锁定未完成
    u32  u32LockCnt;      //< 电机进入稳定状态时间
    u32  u32CurLockCntMax;
    u16  u16FreqCnt;

    bool eCurRstFlag;         // 完成电阻辨识之后，需要将d轴电流回零才能进行电阻辨识 B_TURE:电流回零 B_FALSE:电流未回零
    bool eCurLockFlag;        // q轴电感辨识需要锁在d轴（d轴保持较大电流），再在q轴进行高频注入 B_TURE:电流稳定 B_FALSE:电流未稳定
    bool eInjStabFlag;        // 高频注入电流变化稳定（每周期最大值差距小），才开始进行有效数据记录 B_TURE:注入稳定 B_FALSE:注入不稳定
    u32  u32HighFreqInjCnt;   // 高频注入计数器
    u16  u16HighFreqInjTime;  // 高频注入脉冲宽度
    s16  s16CurPre;           // 上一时刻电流
    s16  s16CurPre1;          // 上两时刻电流
    s16  s16CurDeltPre;       // 上一时刻电流增量
    s16  s16CurMax;           // 高频注入周期电流最大值
    s16  s16CurMaxPre;        // 上一高频注入周期电流最大值
    u16  u16InjStabCnt;       // 高频注入电流变化稳定周期计数，以波动峰值为参照

    // 参数记录
    f32 s16VoltAlphaR[2];  // Alpha电压锁定时重构电压记录
    f32 s16CurAlphaR[2];   // Alpha电压锁定时反馈电流记录
    f32 s16VoltBetaR[2];   // Beta电压锁定时重构电压记录
    f32 s16CurBetaR[2];    // Beta电压锁定时反馈电流记录
    f32 s16VoltDigQ[2];    // Q电压锁定时电压指令记录
    f32 s16VoltDigD[2];    // D电压锁定时电压指令记录

    u16 u16CurRecMaxCnt;                          // 电流最大值计数值
    u16 u16CurRecMinCnt;                          // 电流最小值计数值
    s16 s16CurDMax[HIGH_FREQ_INJE_CALC_CNT];      // D轴高频注入时反馈电流记录(最大值)
    s16 s16CurDMin[HIGH_FREQ_INJE_CALC_CNT + 1];  // D轴高频注入时反馈电流记录(最小值)
    s16 s16CurQMax[HIGH_FREQ_INJE_CALC_CNT];      // Q轴高频注入时反馈电流记录(最大值)
    s16 s16CurQMin[HIGH_FREQ_INJE_CALC_CNT + 1];  // Q轴高频注入时反馈电流记录(最小值)
    s16 s16VoltD[2];                              // D轴高频注入时重构电压记录 s16VoltQL[0]为正向电压 s16VoltQL[1]为负向电压
    s16 s16VoltQ[2];                              // Q轴高频注入时反馈电流记录(峰值)

    u32 u32LdRiseCnt;  // D轴电流上升时间记录（电感辨识）

    // 内建clark-park变化参数
    // Clarke_Str iClarke;  //< 电流环VA模式下，应当依据给定电角度经行IDIQ计算
    // Park_Str   iPark;

    // IF强拉控制需要电流闭环
    // Pid16_Str idPid;  //< D轴电流PI控制
    // Pid16_Str iqPid;  //< Q轴电流PI控制

    // FltrIIR1S16_Str idFbFltr;   //< D轴电流反馈低通滤波器
    // FltrIIR1S16_Str uqRefFltr;  //< D轴电压指令低通滤波器

    s16 s16IdOut;
    s16 s16IqOut;

    bool eIfCurLockFlag;         // 磁链辨识需要用到两个速度，分成两阶段辨识 B_TURE:锁定 B_FALSE:未锁定
    bool eFluxIdentStep;         // 磁链辨识需要用到两个速度，分成两阶段辨识 B_TURE:阶段二 B_FALSE:阶段一
    bool eFluxIdentRecFlag;      // 磁链辨识阶段数据记录 B_TURE:记录 B_FALSE:不记录
    u16  u16ElecAngDelt;         // 电角度每周期增量
    u16  u16SameElecAngDeltCnt;  // 电角度保持同一增量的周期，与斜坡加速规划有关联

    s16 s16UqSiRef;  // 指令电压物理量 单位0.01V

    u16  u16FluxRecCnt;
    s16  s16FluxVq[2];  // 磁链辨识q轴电压记录
    s16  s16FluxId[2];  // 磁链辨识d轴电流记录
    // 辨识结果
    u16* pu16Rs;  // 电阻辨识结果，单位0.001欧姆

    u16  u16LdPos;
    u16  u16LdNeg;
    u16  u16LqPos;
    u16  u16LqNeg;
    u16* pu16Ld;      // d轴电感辨识结果，单位0.01mH
    u16* pu16Lq;      // q轴电感辨识结果
    u16* pu16FluxLk;  // 磁链辨识结果

} off_mot_ident_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void OffMotIdentCreat(off_mot_ident_t* pOffMotIdent, axis_para_t* pAxisPara);
void OffMotIdentInit(off_mot_ident_t* pOffMotIdent);
void OffMotIdentEnter(off_mot_ident_t* pOffMotIdent);
void OffMotIdentExit(off_mot_ident_t* pOffMotIdent);
void OffMotIdentCycle(off_mot_ident_t* pOffMotIdent);
void OffMotIdentIsr(off_mot_ident_t* pOffMotIdent);

#ifdef __cplusplus
}
#endif

#endif
