#ifndef __SCHEDULER_H__
#define __SCHEDULER_H__

#include "typebasic.h"
#include "axis.h"
#include "func.h"
#include "delay.h"
#include "paratbl.h"
#include "scope.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void SchedCreat(void);
void SchedInit(void);
void SchedCycle(void);
void SchedIsrA(void);
void SchedIsrB(void);

#ifdef __cplusplus
}
#endif

#endif  // !__SCHEDULER_H__
