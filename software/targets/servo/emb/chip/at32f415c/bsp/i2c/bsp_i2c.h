#ifndef __BSP_I2C_H__
#define __BSP_I2C_H__

#include "typebasic.h"
#include "i2c_application.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

bool EEPROM_ReadBlock(u16 u16MemAddr, u16* pu16Buff, u16 u16WordCnt);
bool EEPROM_WriteBlock(u16 u16MemAddr, u16* pu16Buff, u16 u16WordCnt);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_I2C_H__
