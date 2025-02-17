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

static const pin_attr_t sIOMap[__IO_NUM__] = {
    [ENCODER_SPI_CS_O] = {SPI_CS_GPIO_PORT, SPI_CS_PIN, false, true},
};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void PinSetLvl(pin_no_e ePinNo, switch_e eNewState)
{
    if (ePinNo < __IO_NUM__)
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
    if (ePinNo < __IO_NUM__)
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
