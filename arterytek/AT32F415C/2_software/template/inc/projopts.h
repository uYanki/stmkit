#ifndef __PROJ_OPTS_H__
#define __PROJ_OPTS_H__

/**
 * @brief 电流采样类型 CONFIG_CUR_SAMP_TYPE
 */
#define CUR_SAMP_NULL         0 /* 无电流采样 no current sample*/
#define CUR_SAMP_UV_LINE      1 /* 双电阻线采样 sample UV-phase line current */
#define CUR_SAMP_VW_LINE      2 /* 双电阻线采样 sample VW-phase line current */
#define CUR_SAMP_UW_LINE      3 /* 双电阻线采样 sample UW-phase line current */
#define CUR_SAMP_UVW_LINE     4 /* 三电阻线采样 sample UVW-phase line current */
#define CUR_SAMP_S_DOWN_BRG   5 /* 单电阻逆变下桥采样 sample single down bridge current */
#define CUR_SAMP_UV_DOWN_BRG  6 /* 双电阻逆变下桥采样 sample UV-phase down bridge line current */
#define CUR_SAMP_VW_DOWN_BRG  7 /* 双电阻逆变下桥采样 sample VW-phase down bridge line current */
#define CUR_SAMP_UW_DOWN_BRG  8 /* 双电阻逆变下桥采样 sample UW-phase down bridge line current */
#define CUR_SAMP_UVW_DOWN_BRG 9 /* 三电阻逆变下桥采样 sample UVW-phase down bridge line current */

/**
 * @brief ADC类型
 */
#define ADC_SDADC   // sigma-delta adc
#define ADC_SARADC  // successive approximation adc 逐次逼近型

/**
 * @brief 通讯类型 CONFIG_COMM_TYPE
 */
#define COMM_MODBUS   0  // modbus-rtu over rs485
#define COMM_CANOPEN  1  // canopen over can
#define COMM_ETHERCAT 2  // ethercat
#define COMM_PROFIBUS 3  // profibus
#define COMM_PROFINET 4  // profinet

/**
 * @brief 面板类型 CONFIG_PANEL_TYPE
 */

#define PANEL_NULL     0
#define PANEL_LED_SPI  1  // 数码管
#define PANEL_OLED_I2C 2
#define PANEL_OLED_SPI 3

/**
 * @brief 控制电类型 CONFIG_CTRL_POWER_TYPE
 */
#define POWER_MAIN_DC 0  // 控制板由主回路母线供电
#define POWER_CTRL_DC 1  // 控制板由独立电源供电

/**
 * @brief 温度采样类型 CONFIG_TEMP_SAMP_TYPE
 */
#define TEMP_NULL   0  // 无模块温度采样
#define TEMP_NTC_AI 1  // NTC模拟量温度采样
#define TEMP_PTC_AI 2  // PTC模拟量温度采样
#define TEMP_NTC_SW 3  // NTC开关量过温采样
#define TEMP_PTC_SW 4  // PTC开关量过温采样

/**
 * @brief 编码器分频输出类型 CONFIG_ENC_FREQ_DIV_OUT_TYPE
 */
#define ENC_FREQ_DIV_OUT_NULL    0  // 无编码器分频输出
#define ENC_FREQ_DIV_OUT_PUL_A   1  // 编码器分频单相脉冲输出
#define ENC_FREQ_DIV_OUT_PUL_AB  2  // 编码器分频AB两相正交脉冲输出
#define ENC_FREQ_DIV_OUT_PUL_ABZ 3  // 编码器分频AB两相正交+Z(INDEX)信号脉冲输出
#define ENC_FREQ_DIV_OUT_PUL_Z   4  // 编码器分频Z(INDEX)信号脉冲输出

/**
 * @brief EEPROM类型 CONFIG_EEPROM_TYPE
 */

#define EEPROM_NULL     0   // 无
#define EEPROM_AT24C01  1   // 1Kbit
#define EEPROM_AT24C02  2   // 2Kbit
#define EEPROM_AT24C04  3   // 4Kbit
#define EEPROM_AT24C08  4   // 8Kbit
#define EEPROM_AT24C16  5   // 16Kbit
#define EEPROM_AT24C32  6   // 32Kbit
#define EEPROM_AT24C64  7   // 64Kbit
#define EEPROM_AT24C128 8   // 128Kbit
#define EEPROM_AT24C256 9   // 256Kbit
#define EEPROM_AT24C512 10  // 512Kbit
#define EEPROM_AT24M01  11  // 01Kbit
#define EEPROM_AT24M02  12  // 02Kbit

#endif
