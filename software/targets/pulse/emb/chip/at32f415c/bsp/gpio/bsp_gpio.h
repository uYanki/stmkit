#ifndef __BSP_GPIO_H__
#define __BSP_GPIO_H__

#include "common.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef enum {

    LED1_PIN_O,
    LED2_PIN_O,

    KEY1_PIN_I,
    KEY2_PIN_I,
    KEY3_PIN_I,

    RS485_RTS_O,

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

    //
    // 探针
    //
    PROBE0_PIN_I,
    PROBE1_PIN_I,

    PIN_CNT,

} pin_no_e;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void     PinSetLvl(pin_no_e ePinNo, switch_e eNewState);
switch_e PinGetLvl(pin_no_e ePinNo);
void     PinTgtLvl(pin_no_e ePinNo);

#ifdef __cplusplus
}
#endif

#endif  // !__BSP_GPIO_H__
