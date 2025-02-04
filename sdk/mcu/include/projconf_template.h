#ifndef __PROJ_CONF_H__
#define __PROJ_CONF_H__

#include "driverlib.h"
#include "sdkopts.h"
#include "projopts.h"

/**
 * @brief SDK Conf
 * @{
 */

#define CONFIG_ARCH_TYPE ARCH_ARM_CM4

/**
 * @brief Include header files
 */
// #define CONFIG_NOT_INCLUDE_STDINT   // 不导入头文件 <stdint.h>
// #define CONFIG_NOT_INCLUDE_STDARG   // 不导入头文件 <stdarg.h>
// #define CONFIG_NOT_INCLUDE_STDLIB   // 不导入头文件 <stdlib.h>

/**
 * @brief Type abbreviations
 */
// #define CONFIG_NOT_DECLARE_INT_ABBR    // 不声明整数类型缩写
// #define CONFIG_NOT_DECLARE_FLOAT_ABBR  // 不声明浮点类型缩写

/**
 * @brief Constant
 */
// #define CONFIG_NOT_DECLARE_INT_RANGE    // 不声明整数范围
// #define CONFIG_NOT_DECLARE_FLOAT_RANGE  // 不声明浮点范围

/**
 * @}
 */

/**
 * @brief Project Conf
 * @{
 */

/**
 * @}
 */

#endif  // !__PROJ_CONF_H__
