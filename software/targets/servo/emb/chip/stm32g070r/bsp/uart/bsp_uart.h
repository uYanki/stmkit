#ifndef __BSP_UART_H__
#define __BSP_UART_H__

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

void ModbusStartTx(u8* pu8Data, u16 u16Len);
void ModbusStartRx(u8* pu8Buff, u16 u16MaxLen);
void ModbusTxFrame(u8* pu8Data, u16 u16Len);
void ModbusRxFrame(u8* pu8Buff, u16 u16MaxLen);
bool ModbusIsTxOver(void);
bool ModbusIsRxOver(void);
u16  ModbusGetRxLen(void);

void TformatTxData(u8* pu8Data, u8 u8Len);
void TformatRxData(u8* pu8Buff, u8 u8Len);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_UART_H__
