#include "bsp_gpio.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_gpio"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

typedef struct {
    gpio_type* GPIO;
    uint16_t   PIN;
    bool       bInvert;  // 电平取反
    bool       bOutput;
} pin_attr_t;

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static const pin_attr_t sIOMap[PIN_CNT] = {
    [LED1_PIN_O] = {LED1_GPIO_PORT, LED1_PIN, false, true },
    [LED2_PIN_O] = {LED2_GPIO_PORT, LED2_PIN, false, true },
    [DO0_PIN_O]  = {DO0_GPIO_PORT,  DO0_PIN,  false, false},
    [DO1_PIN_O]  = {DO1_GPIO_PORT,  DO1_PIN,  false, false},
    [DI0_PIN_I]  = {DI0_GPIO_PORT,  DI0_PIN,  false, false},
    [DI1_PIN_I]  = {DI1_GPIO_PORT,  DI1_PIN,  false, false},
    [DI2_PIN_I]  = {DI2_GPIO_PORT,  DI2_PIN,  false, false},
    [DI3_PIN_I]  = {DI3_GPIO_PORT,  DI3_PIN,  false, false},
    [DI4_PIN_I]  = {DI4_GPIO_PORT,  DI4_PIN,  false, false},
    [DI5_PIN_I]  = {DI5_GPIO_PORT,  DI5_PIN,  false, false},
};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void PinSetLvl(pin_no_e ePinNo, switch_e eNewState)
{
    if (ePinNo < PIN_CNT)
    {
        const pin_attr_t* pAttr = &sIOMap[ePinNo];

        if (pAttr->GPIO != nullptr)
        {
            switch_e      eTargetState  = pAttr->bInvert ? B_OFF : B_ON;
            confirm_state eConfirmState = (eNewState == eTargetState) ? TRUE : FALSE;

            gpio_bits_write(pAttr->GPIO, pAttr->PIN, eConfirmState);
        }
    }
}

switch_e PinGetLvl(pin_no_e ePinNo)
{
    if (ePinNo < PIN_CNT)
    {
        const pin_attr_t* pAttr = &sIOMap[ePinNo];

        if (pAttr->GPIO != nullptr)
        {
            flag_status eFlagStatus;

            if (pAttr->bOutput)
            {
                eFlagStatus = gpio_output_data_bit_read(pAttr->GPIO, pAttr->PIN);
            }
            else
            {
                eFlagStatus = gpio_input_data_bit_read(pAttr->GPIO, pAttr->PIN);
            }

            flag_status eTargetStatus = pAttr->bInvert ? RESET : SET;

            return (eFlagStatus == eTargetStatus) ? B_ON : B_OFF;
        }
    }

    return B_OFF;
}

void PinTgtLvl(pin_no_e ePinNo)
{
    if (ePinNo < PIN_CNT)
    {
        const pin_attr_t* pAttr = &sIOMap[ePinNo];

        if (pAttr->GPIO != nullptr && pAttr->bOutput == true)
        {
            flag_status eFlagStatus = gpio_output_data_bit_read(pAttr->GPIO, pAttr->PIN);

            gpio_bits_write(pAttr->GPIO, pAttr->PIN, (eFlagStatus == TRUE) ? FALSE : TRUE);
        }
    }
}
