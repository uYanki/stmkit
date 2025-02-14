#ifndef __BSP_TIM_H__
#define __BSP_TIM_H__

#include "common.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void IncTickMs(void);
u16  GetTick100ns(void);
u32  GetTickMs(void);

void PulInConfig(u16 u16Mode);
void PulInEnable(void);
void PulInDisable(void);
void PulInRstCnt(void);
s32  PulInGetCnt(void);

void PulOutConfig(u32 u32Cnt, u32 u32Freq, u16 u16Duty);
void PulOutEnable(void);
void PulOutDisable(void);
bool PulOutIsOver(void);
void PulOutUpdate(void);

void FlexPulOutConfig(u32 u32Freq, u16* pu16DataSrc, u16 u16DataSize);
void FlexPulOutEnable(void);
void FlexPulOutDisable(void);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_TIM_H__
