#ifndef __PROJ_CONF_H__
#define __PROJ_CONF_H__

#include "at32f413_wk_config.h"
#include "projopts.h"

#define __attr_packed(x) __packed x

/**
 * @brief sdk conf
 */

#define CONFIG_NOT_DECLARE_FLOAT_RANGE

#define CONFIG_ARCH_TYPE ARCH_ARM_CM4

/**
 * @brief proj conf
 */

#define FREQ_10MHZ         10000000

#define MIN_SEC_COEFF      60    // 1min=60s
#define DRV_SPD_ZOOM_COEFF 1000  // 驱动层速度缩放系数

#define HALL_ENC_SW        1

/**
 * @brief 外设
 */

#define DEBUG_UART_BASE  USART2

#define MODBUS_UART_BASE USART2
#define MODBUS_RXDMA_CH  DMA1_CHANNEL2
#define MODBUS_TXDMA_CH  DMA1_CHANNEL3

#define TIM_SYSTICK_BASE TMR10  // Period = 1MS, Tick = 50ns
#define TIM_SCANA_BASE   TMR1
#define TIM_SCANB_BASE   TMR11
#define TIM_SCANA_BASE   TMR1

#define CAN_BASE         CAN2

#define ENC_SPI_BASE     SPI2

#define EEPROM_I2C_BASE  I2C2

/**
 * @brief 硬件接口
 */

#define CONFIG_LED_NUM       2  // 指示灯数量
#define CONFIG_HWREV_NUM     0  // 硬件版本数量
#define CONFIG_GEN_DO_NUM    5  // 外部数字量输出数量
#define CONFIG_GEN_DI_NUM    5  // 外部数字量输入数量
#define CONFIG_HDI_NUM       0  // 高速外部输入数量
#define CONFIG_EXT_PROBE_NUM 2  // 外部探针数量
#define CONFIG_EXT_AI_NUM    0  // 外部模拟量输入数量
#define CONFIG_TEMP_SAMP_NUM 0  // 温度采样数量
#define CONFIG_FAN_SW        0  // 风扇

#if CONFIG_TEMP_SAMP_NUM > 0
#define CONFIG_TEMP_INVT_SAMP_SW 1  // 逆变桥温度采样
#define CONFIG_TEMP_RECT_SAMP_SW 1  // 整流桥温度采样
#endif

#define CONFIG_PANEL_TYPE    0  // 面板类型

#define CONFIG_CUR_SAMP_TYPE CUR_SAMP_UV_DOWN_BRG
#define CONFIG_BOOTSTRAP_SW  0  // 自举模块

/**
 * @brief 软件功能
 */

#define PWM_CLK_HZ              200000000  // PWM外设时钟
#define PWM_FREQ_HZ             8000
#define PWM_DEADZONE_US         2

#define PWM_PERIOD              (PWM_CLK_HZ / PWM_FREQ_HZ / 2)
#define PWM_DEADZONE            (PWM_CLK_HZ * PWM_DEADZONE_US / 1000000)

#define CONFIG_CUR_LOOP_FREQ_HZ 8000
#define CONFIG_SPD_LOOP_FREQ_HZ 8000
#define CONFIG_POS_LOOP_FREQ_HZ 8000

#define SPD_LOOP_FREQ_KHZ       (CONFIG_SPD_LOOP_FREQ_HZ / 1000)

// 周期: 1/FREQ_HZ (s) = 1000/FREQ_HZ (s) = 1000000/FREQ_HZ (us) = 10000000/FREQ_HZ (0.1us)
#define CUR_LOOP_PERIOD_100NS      (FREQ_10MHZ / CONFIG_CUR_LOOP_FREQ_HZ)
#define SPD_LOOP_PERIOD_100NS      (FREQ_10MHZ / CONFIG_SPD_LOOP_FREQ_HZ)
#define POS_LOOP_PERIOD_100NS      (FREQ_10MHZ / CONFIG_POS_LOOP_FREQ_HZ)

#define CONFIG_AXIS_NUM            1  // 轴数量

#define CONFIG_VIRTUAL_DI_NUM      0  // 虚拟数字量输入数量
#define CONFIG_VIRTUAL_DO_NUM      0  // 虚拟数字量输出数量

#define CONFIG_UCDC_SAMP_SW        0  // 控制电电压采样

#define CONFIG_DS402_CTRL_SW       1  // 控制协议 DS402
#define CONFIG_PROFINET_CTRL_SW    0  // 控制协议 PN

#define CONFIG_SCOPE_SAMP_CHAN_NUM 2

#define CONFIG_EEPROM_TYPE         EEPROM_AT24C64
#define CONFIG_EEPROM_DEVADDR      (0x50 << 1)

#endif
