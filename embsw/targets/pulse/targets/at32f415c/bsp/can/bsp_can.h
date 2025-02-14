#ifndef __BSP_CAN_H__
#define __BSP_CAN_H__

#include "common.h"

#define CAN_ID_Pos  30
#define CAN_ID_STD  (0 << CAN_ID_Pos)  // 11 bits standard identifier
#define CAN_ID_EXT  (1 << CAN_ID_Pos)  // 29 bits extended identifier

#define CAN_FF_Pos  31
#define CAN_FF_DATA (0 << CAN_FF_Pos)  // data frame
#define CAN_FF_RTR  (1 << CAN_FF_Pos)  // remote frame

bool CanTxMsg(u32 u32Id, u8* pu8Data, u8 u8Len);
bool CanRxMsg(u32* pu32Id, u8* pu8Data, u8* pu8Len);

#endif  // !__BSP_CAN_H__
