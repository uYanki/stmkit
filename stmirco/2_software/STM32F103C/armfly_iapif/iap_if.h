#ifndef __IAP_IF_H__
#define __IAP_IF_H__

#include <stdbool.h>
#include "stm32f1xx_hal.h"

bool IsAppExist(uint32_t AppAddr);
void JumpToApp(uint32_t AppAddr);
void JumpToSysboot(void);

#endif /* __IAP_IF_H__ */
