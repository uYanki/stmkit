#ifndef __SCHEDULER_H__
#define __SCHEDULER_H__

#include "common.h"
#include "func.h"
#include "delay.h"
#include "paratbl.h"
#include "bsp.h"

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
void SchedIsr(void);

#ifdef __cplusplus
}
#endif

#endif  // !__SCHEDULER_H__
