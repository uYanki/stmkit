#ifndef __FUNC_H__
#define __FUNC_H__

#ifdef __cplusplus
extern "C" {
#endif

#include "analog/analog.h"
#include "pulse/pulse.h"
#include "pinctrl/dido.h"
#include "comm/modbus/modbus.h"
#include "paratbl/storage.h"
#include "hrtim/hrtim.h"
	
//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void FuncCreat(void);
void FuncInit(void);
void FuncIsr(void);
void FuncCycle(void);

#ifdef __cplusplus
}
#endif

#endif  // !__FUNC_H__
