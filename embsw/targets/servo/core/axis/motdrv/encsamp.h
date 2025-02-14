#ifndef __ENC_SAMP_H__
#define __ENC_SAMP_H__

#include "paratbl.h"
#include "abs_mt6701.h"
#include "bsp.h"
#include "lpf.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef struct {
    s32 s32Pos;
    s32 s32PosDelt;
    s32 s32PosPre;
} abs_enc_t;

typedef union {
    u16 u16All;
    struct {
        u16 ErrorClear : 1;
        u16 TurnsReset : 1;
        u16 StateReset : 1;
        u16 _Resv      : 13;
    } u16Bit;
} enc_cmd_u;

typedef struct {
    axis_para_t* pAxisPara;

    s32 s32Pos;
    s32 s32PosDelt;

    enc_cmd_u uEncCmdPre;

    lpf_s32_t sSpdFbFltr;

#if (CONFIG_ENCODER_TYPE == ENC_ABS)
    abs_mt6701_t sAbsMT6701;
#elif (CONFIG_ENCODER_TYPE == ENC_INC)
#elif (CONFIG_ENCODER_TYPE == ENC_ROT)
#endif
} enc_samp_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void EncSampCreat(enc_samp_t* pEncSamp, axis_para_t* pAxisPara);
void EncSampInit(enc_samp_t* pEncSamp);
void EncSampCycle(enc_samp_t* pEncSamp);
void EncSampIsr(enc_samp_t* pEncSamp);

#ifdef __cplusplus
}
#endif

#endif
