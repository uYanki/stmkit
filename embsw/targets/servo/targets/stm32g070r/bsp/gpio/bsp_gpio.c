#include "bsp_gpio.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_gpio"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static const io_def_t sIOMap[__IO_NUM__] = {
    [ENCODER_SPI_CS_O] = {SPI1_CS_GPIO_Port, SPI1_CS_Pin},
};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void PinSetLvl(io_ind_e eIndex, io_sts_e eState)
{
    switch (eIndex)
    {
        case LED1_PIN_O:
        case LED2_PIN_O:
        case LED3_PIN_O:

        case FAN_PIN_O:

        case RS485_RTS_O:

        case DO0_PIN_O:
        case DO1_PIN_O:
        case DO2_PIN_O:
        case DO3_PIN_O:
        case DO4_PIN_O:
        case DO5_PIN_O:

        case DC_RELAY_PIN_O:
        case DC_BREAK_PIN_O:

        case PANEL_SPI_CS_O:
        case NORFLASH_SPI_CS_O:
        {
            break;
        }

        case ENCODER_SPI_CS_O:
        {
            if (sIOMap[eIndex].gpio != nullptr)
            {
                HAL_GPIO_WritePin(sIOMap[eIndex].gpio, sIOMap[eIndex].pin, (eState == B_OFF) ? GPIO_PIN_RESET : GPIO_PIN_SET);
            }

            break;
        }

        default:
        {
            break;
        }
    }
}

io_sts_e PinGetLvl(io_ind_e eIndex)
{
    switch (eIndex)
    {
        case KEY1_PIN_I:
        case KEY2_PIN_I:
        case KEY3_PIN_I:

        case HW_REV0_PIN_I:
        case HW_REV1_PIN_I:

        case DI0_PIN_I:
        case DI1_PIN_I:
        case DI2_PIN_I:
        case DI3_PIN_I:
        case DI4_PIN_I:
        case DI5_PIN_I:

        case PROBE0_PIN_I:
        case PROBE1_PIN_I:
        case PROBE2_PIN_I:
        case PROBE3_PIN_I:

        case HALL_A_PIN_I:
        case HALL_B_PIN_I:
        case HALL_C_PIN_I:

        {
            if (sIOMap[eIndex].gpio != nullptr)
            {
                return HAL_GPIO_ReadPin(sIOMap[eIndex].gpio, sIOMap[eIndex].pin) == GPIO_PIN_RESET ? B_OFF : B_ON;
            }

            break;
        }

        case LED1_PIN_O:
        case LED2_PIN_O:
        case LED3_PIN_O:

        case FAN_PIN_O:

        case RS485_RTS_O:

        case DO0_PIN_O:
        case DO1_PIN_O:
        case DO2_PIN_O:
        case DO3_PIN_O:
        case DO4_PIN_O:
        case DO5_PIN_O:

        case DC_RELAY_PIN_O:
        case DC_BREAK_PIN_O:

        case PANEL_SPI_CS_O:
        case NORFLASH_SPI_CS_O:
        case ENCODER_SPI_CS_O:

        {
            if (sIOMap[eIndex].gpio != nullptr)
            {
                return HAL_GPIO_ReadPin(sIOMap[eIndex].gpio, sIOMap[eIndex].pin) == GPIO_PIN_RESET ? B_OFF : B_ON;
            }

            break;
        }

        default:
        {
            break;
        }
    }

    return B_OFF;
}
