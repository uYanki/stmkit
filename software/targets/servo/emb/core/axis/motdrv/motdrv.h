#ifndef __MOT_DRV_H__
#define __MOT_DRV_H__

#include "paratbl.h"
#include "delay.h"
#include "mclib.h"
#include "lpf.h"
#include "encsamp.h"
#include "cursamp.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

// typedef struct {
//     RO s16* ps16Ref;
//     RO s16* ps16Fb;
//     RO s16* ps16Kp;
//     RO s16* ps16Ki;
//     s16*    ps16Err;   // 误差项
//     s32*    ps32Prop;  // 比例项
//     s32*    ps32Inte;  // 积分项
//     s16     s16Out;
//     s16     s16Sat;
//     u8      u8SatFlag;  // 积分饱和标志
// } pi_s16_t;

// typedef struct {
//     RO s32* ps32Ref;
//     RO s32* ps32Fb;
//     RO s32* ps32Kp;
//     RO s32* ps32Ki;
//     s32*    ps32Err;   // 误差项
//     s32*    ps32Prop;  // 比例项
//     s32*    ps32Inte;  // 积分项
//     s32     s32Out;
//     s32     s32SatPos;
//     s32     s32SatNeg;
//     u8      u8SatFlag;  // 积分饱和标志
// } pi_s32_t;

// typedef struct {
//     s64 s64Err;  // 误差项
//     s64 s64Fb;
//     s64 s64Ref;
//     s64 s64Prop;  // 比例项
//     s64 s64Sat;
//     s64 s64Out;
//     u8  u8SatFlag;  // 积分饱和标志
// } pi_s64_t;

typedef struct {
    enc_samp_t sEncSamp;
    cur_samp_t sCurSamp;

    struct {
        RO s16** pps16IqRef;       ///< 应用层转矩指令
        RO s16** pps16IdRef;       ///< 应用层磁通指令
        RO s16** ppu16ElecAngRef;  ///< 应用层电角度指令
    } input;

    // 速度环滤波
    lpf_s32_t sSpdRefFltr;
    lpf_s32_t sSpdFbFltr;

    // 速度环PI
    // pi_s32_t sSpdPi;

    // FOC
    mc_park_t   sPark;
    mc_park_t   sRevPark;
    mc_clarke_t sRevClarke;
    mc_clarke_t sClarke;
    mc_svgen_t  sSvpwm;

    // 电流环滤波
    lpf_s16_t sIdRefFltr;
    lpf_s16_t sIqRefFltr;
    lpf_s16_t sIdFbFltr;
    lpf_s16_t sIqFbFltr;

    // 速度环输出
    s16 s16SpdLoopIqRef;

    axis_para_t* pAxisPara;

    u8 u8SpdPiSatFlag;
    u8 u8PosPiSatFlag;

    s64 s64PosLoopOut;

} motdrv_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void MotDrvCreat(motdrv_t* pTrqLoop, axis_para_t* pAxisPara);
void MotDrvInit(motdrv_t* pTrqLoop);
void MotDrvCycle(motdrv_t* pTrqLoop);
void MotDrvIsr(motdrv_t* pTrqLoop);

#ifdef __cplusplus
}
#endif

#endif
