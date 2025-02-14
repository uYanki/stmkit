#ifndef __PROJ_CONF_H__
#define __PROJ_CONF_H__

#include "at32f415_wk_config.h"
#include "sdkopts.h"
#include "projopts.h"

#define __attr_packed(x) __packed x

/**
 * @brief sdk conf
 */

#define CONFIG_NOT_DECLARE_FLOAT_RANGE

#define CONFIG_ARCH_TYPE ARCH_ARM_CM4

/**
 * @brief 外设
 */

#define CONFIG_MODBUS_HWCRC_SW 1

#define DEBUG_UART_BASE        USART1

#define MODBUS_UART_BASE       USART1
#define MODBUS_RXDMA_CH        DMA1_CHANNEL2
#define MODBUS_TXDMA_CH        DMA1_CHANNEL3

#define TIM_SYSTICK_BASE       TMR10  // Period = 1MS, Tick = 50ns
#define TIM_SCAN_BASE          TMR11

#define CAN_BASE               CAN1

#define EEPROM_I2C_BASE        I2C1

// 任意频率任意个数脉冲输出
#define PULOUT_TMR_BASE TMR1
#define PULOUT_TMR_CHAN TMR_SELECT_CHANNEL_1

// 外部脉冲计数
#define PULIN_TMR_BASE TMR3
#define PULIN_TMR_CHAN TMR_SELECT_CHANNEL_3

// 可编程脉冲输出
#define FLEXPUL_TMR_BASE   TMR5
#define FLEXPUL_GPIO_BASE  GPIOB
#define FLEXPUL_DMA_CH     DMA1_CHANNEL4
#define FLEXPUL_DMA_FLEXCH FLEX_CHANNEL4

/**
 * @brief 硬件接口
 */

#define CONFIG_LED_NUM       2  // 指示灯数量
#define CONFIG_HWREV_NUM     0  // 硬件版本数量
#define CONFIG_GEN_DO_NUM    2  // 外部数字量输出数量
#define CONFIG_GEN_DI_NUM    6  // 外部数字量输入数量
#define CONFIG_HDI_NUM       2  // 高速外部输入数量
#define CONFIG_HDO_NUM       5  // 高速外部输出数量
#define CONFIG_EXT_AI_NUM    4  // 外部模拟量输入数量
#define CONFIG_EXT_AO_NUM    0  // 外部模拟量输出数量
#define CONFIG_TEMP_SAMP_NUM 1  // 温度采样数量

#if CONFIG_TEMP_SAMP_NUM > 0
#define CONFIG_TEMP_MCU_SAMP_SW 1
#endif

#if CONFIG_TEMP_MCU_SAMP_SW

// 在线公式化简 https://mathcracker.com/simplify-calculator#results
// AT32: AN0019_User_Guide_of_the_Temperature_Sensor_ZH_V2.0.1.pdf
// TempMcuSi = 10 * (1280 - TempMcuPu * 3300 / 4096) / (-4.2) + 250;
//          = TempMcuPu * 1918 / 1000 - 2798;

#define CONFIG_TEMP_MCU_ZOOM   1918
#define CONFIG_TEMP_MCU_OFFSET 2798

#endif

#define CONFIG_EEPROM_TYPE    EEPROM_AT24C64
#define CONFIG_EEPROM_DEVADDR (0x50)

#endif
