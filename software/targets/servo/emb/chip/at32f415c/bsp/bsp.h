#ifndef __BSP_H__
#define __BSP_H__

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#include "./uart/bsp_uart.h"
#include "./tim/bsp_tim.h"
#include "./i2c/bsp_i2c.h"
#include "./gpio/bsp_gpio.h"
#include "./adc/bsp_adc.h"
#include "./can/bsp_can.h"
#include "./qei/bsp_qei.h"
#include "./enc/bsp_absenc.h"
#include "./crc/bsp_crc.h"

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void SystemSoftReset(void);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_H__
