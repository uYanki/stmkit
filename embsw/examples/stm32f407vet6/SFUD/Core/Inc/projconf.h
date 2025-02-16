#ifndef __PROJ_CONF_H__
#define __PROJ_CONF_H__

#include "stm32f4xx_hal.h"
#include "sdkopts.h"
#include "board.h"

/**
 * @brief SDK Conf
 * @{
 */

#define CONFIG_ARCH_TYPE ARCH_ARM_CM4

/**
 * @}
 */

/**
 * @brief Project Conf
 * @{
 */

#define CONFIG_DEMOS_SW         1

#define CONFIG_HWUART_MODULE_SW 1
#define CONFIG_HWI2C_MODULE_SW  0
#define CONFIG_HWSPI_MODULE_SW  0

#define CONFIG_SWUART_MODULE_SW 0
#define CONFIG_SWI2C_MODULE_SW  0
#define CONFIG_SWSPI_MODULE_SW  1

/**
 * @}
 */

#endif  // !__PROJ_CONF_H__
