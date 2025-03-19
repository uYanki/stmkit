#ifndef __SERDRV_H__
#define __SERDRV_H__

#define CONFIG_UART_TXDMA_SW 1

#include <stdbool.h>

#include "stm32f4xx_hal.h"
#include "usart.h"
#include "candrv.h"

bool Serial_LogCanMsg(uint8_t can, can_dir_e dir, can_msg_t* msg);

#endif  // !__SERDRV_H__
