#ifndef __BSP_TIM_H__
#define __BSP_TIM_H__

#include "typebasic.h"

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
u32  GetTick100ns(void);
u32  GetTickUs(void);
u32  GetTickMs(void);

void PwmDuty(u16 u16DutyA, u16 u16DutyB, u16 u16DutyC);
bool PwmGen(bool bPwmSw, u16 u16AxisInd);
bool PwrBootstrap(bool bBootSw, u16 u16AxisInd);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_TIM_H__
