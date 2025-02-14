#ifndef __BSP_UART_H__
#define __BSP_UART_H__

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

void ModbusStartTx(u8* pu8Data, u16 u16Len);
void ModbusStartRx(u8* pu8Buff, u16 u16MaxLen);
void ModbusTxFrame(u8* pu8Data, u16 u16Len);
void ModbusRxFrame(u8* pu8Buff, u16 u16MaxLen);
bool ModbusIsTxOver(void);
bool ModbusIsRxOver(void);
u16  ModbusGetRxLen(void);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_UART_H__
