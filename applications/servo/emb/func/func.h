#ifndef __FUNC_H__
#define __FUNC_H__

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void FuncCreat(void);
void FuncInit(void);
void FuncInputIsr(void);
void FuncOutputIsr(void);
void FuncIsr(void);
void FuncCycle(void);

#ifdef __cplusplus
}
#endif

#endif  // !__FUNC_H__
