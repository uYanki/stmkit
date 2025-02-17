#ifndef __BSP_GPIO_H__
#define __BSP_GPIO_H__

#include "typebasic.h"
#include "main.h"

typedef enum {

    LED1_PIN_O,
    LED2_PIN_O,
    LED3_PIN_O,

    KEY1_PIN_I,
    KEY2_PIN_I,
    KEY3_PIN_I,

    FAN_PIN_O,

    //
    // 硬件版本
    //
    HW_REV0_PIN_I,
    HW_REV1_PIN_I,

    //
    // 外部数字量输入
    //
    DI0_PIN_I,
    DI1_PIN_I,
    DI2_PIN_I,
    DI3_PIN_I,
    DI4_PIN_I,
    DI5_PIN_I,

    //
    // 外部数字量输出
    //
    DO0_PIN_O,
    DO1_PIN_O,
    DO2_PIN_O,
    DO3_PIN_O,
    DO4_PIN_O,
    DO5_PIN_O,

    //
    // 探针
    //
    PROBE0_PIN_I,
    PROBE1_PIN_I,
    PROBE2_PIN_I,
    PROBE3_PIN_I,

    //
    // 霍尔真值状态
    //
    HALL_A_PIN_I,
    HALL_B_PIN_I,
    HALL_C_PIN_I,

    //
    // 其他...
    //

    RS485_RTS_O,  // Modbus-RTU over RS485

    PANEL_SPI_CS_O,
    NORFLASH_SPI_CS_O,
    ENCODER_SPI_CS_O,

    DC_RELAY_PIN_O,  // 缓起继电器
    DC_BREAK_PIN_O,  // 动态制动

    __IO_NUM__,

} io_ind_e;

typedef enum {
    B_OFF,
    B_ON,
} io_sts_e;

typedef struct {
    GPIO_TypeDef* gpio;
    uint16_t      pin;
} io_def_t;

void     PinSetLvl(io_ind_e eIndex, io_sts_e eState);
io_sts_e PinGetLvl(io_ind_e eIndex);

#endif  // !__BSP_GPIO_H__
