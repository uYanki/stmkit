#ifndef __BSP_H__
#define __BSP_H__

#include <stdlib.h>

#include "projconf.h"

#include "./uart/bsp_uart.h"
#include "./tim/bsp_tim.h"
#include "./spi/bsp_spi.h"
#include "./i2c/bsp_i2c.h"
#include "./gpio/bsp_gpio.h"
#include "./adc/bsp_adc.h"
#include "./qei/bsp_qei.h"
#include "./crc/bsp_crc.h"

void SystemSoftReset(void);

#endif  // !__BSP_H__
