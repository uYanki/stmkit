#ifndef __BSP_I2C_H__
#define __BSP_I2C_H__

#include "common.h"
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

bool EEPROM_ReadBlock(u32 u32MemAddr, u8* pu8Buff, u16 u16ByteCnt);
bool EEPROM_WriteBlock(u32 u32MemAddr, u8* pu8Data, u16 u16ByteCnt);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_I2C_H__
