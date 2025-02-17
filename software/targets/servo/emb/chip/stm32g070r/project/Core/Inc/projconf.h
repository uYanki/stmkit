#ifndef __PROJ_CONF_H__
#define __PROJ_CONF_H__

#include "stm32g0xx_hal.h"
#include "sdkopts.h"
#include "projopts.h"

#define __attr_packed(x) x __packed

/**
 * @brief sdk conf
 */

#define CONFIG_NOT_DECLARE_FLOAT_RANGE

#define CONFIG_ARCH_TYPE ARCH_ARM_CM0

/**
 * @brief proj conf
 */

#define CONFIG_SCOPE_SAMP_CHAN_NUM 2

#define LED_NUM                    1  // LED
#define HW_REV_NUM                 6

#define EXT_GEN_DO_NUM             6
#define EXT_GEN_DI_NUM             6  // 外部数字量输入
#define EXT_PROBE_NUM              2  // 外部探针
#define VIRTUAL_DI_NUM             5
#define VIRTUAL_DO_NUM             5

#define CONFIG_EXT_AI_NUM          0

#define CONFIG_DS402_CTRL_SW       1
#define CONFIG_PROFINET_CTRL_SW    0

#define EXT_AI_NUM                 CONFIG_EXT_AI_NUM
#define TEMP_SAMP_NUM              0

#if TEMP_SAMP_NUM > 0
#define TEMP_INVT_SAMP_SW 0
#define TEMP_RECT_SAMP_SW 0
#endif

#define UCDC_SAMP_SW                 1

#define HALL_ENC_SW                  1

#define CONFIG_CUR_SAMP_TYPE         CUR_SAMP_UW_DOWN_BRG
#define CONFIG_CUR_SAMP_BOOTSTRAP_SW 1

#define FREQ_10MHZ                   10000000

#define CONFIG_CUR_LOOP_FREQ_HZ      4000
#define CONFIG_SPD_LOOP_FREQ_HZ      4000
#define CONFIG_POS_LOOP_FREQ_HZ      4000

#define SPD_LOOP_FREQ_KHZ            (CONFIG_SPD_LOOP_FREQ_HZ / 1000)

// 周期: 1/FREQ_HZ (s) = 1000/FREQ_HZ (s) = 1000000/FREQ_HZ (us) = 10000000/FREQ_HZ (0.1us)
#define CUR_LOOP_PERIOD_100NS  (FREQ_10MHZ / CONFIG_CUR_LOOP_FREQ_HZ)
#define SPD_LOOP_PERIOD_100NS  (FREQ_10MHZ / CONFIG_SPD_LOOP_FREQ_HZ)
#define POS_LOOP_PERIOD_100NS  (FREQ_10MHZ / CONFIG_POS_LOOP_FREQ_HZ)

#define MIN_SEC_COEFF          60    // 1min=60s
#define DRV_SPD_ZOOM_COEFF     1000  // 驱动层速度缩放系数

#define CONFIG_AXIS_NUM        1

#define MODBUS_UART_BASE       (&huart2)
#define MODBUS_UART_RXDMA_BASE (hdma_usart2_rx)

#define CAN_BASE               CAN2

#define TIM_BASE               (&htim14)  // Period = 1MS, Tick = 100ns
#define TIM_SCAN_A             (&htim1)
#define TIM_SCAN_B             (&htim7)

#define ADC_CUR_U              0
#define ADC_CUR_V              0
#define ADC_CUR_W              0

#define ADC_U_MDC              0          // 母线电压
#define ADC_U_CDC              ADC_U_MDC  // 控制电电压

#define PWM_CLK_HZ             64000000
#define PWM_FREQ_HZ            4000
#define PWM_DEADZONE_US        2

#define PWM_PERIOD             (PWM_CLK_HZ / PWM_FREQ_HZ / 2)
#define PWM_DEADZONE           (PWM_CLK_HZ * PWM_DEADZONE_US / 1000000)

#endif
