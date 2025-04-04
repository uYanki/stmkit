#include "i2cmst.h"

#if CONFIG_DEMOS_SW

#include "u8g2.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "u8g2"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static i2c_mst_t i2c = {
    .SDA  = {GPIOC, GPIO_PIN_7},
    .SCL  = {GPIOA, GPIO_PIN_8},
    .I2Cx = nullptr,
};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

static void* memcpy_byte(void* dst, const void* src, int n)
{
    if (dst == NULL || src == NULL || n <= 0)
    {
        return NULL;
    }

    char* pdst = (char*)dst;
    char* psrc = (char*)src;

    if (pdst > psrc && pdst < psrc + n)
    {
        pdst = pdst + n - 1;
        psrc = psrc + n - 1;
        while (n--)
        {
            *pdst-- = *psrc--;
        }
    }
    else
    {
        while (n--)
        {
            *pdst++ = *psrc++;
        }
    }
    return dst;
}

static uint8_t u8x8_byte_hw_i2c(u8x8_t* u8x8, uint8_t msg, uint8_t arg_int, void* arg_ptr)
{
    /* u8g2/u8x8 will never send more than 32 bytes
     * between START_TRANSFER and END_TRANSFER */

    static uint8_t buffer[128];
    static uint8_t length;

    switch (msg)
    {
        case U8X8_MSG_BYTE_INIT:  // i2c init
        {
            break;
        }
        case U8X8_MSG_BYTE_START_TRANSFER:
        {
            length = 0;
            break;
        }
        case U8X8_MSG_BYTE_SEND:
        {
            memcpy_byte(buffer + length, arg_ptr, arg_int);
            length += arg_int;
            break;
        }
        case U8X8_MSG_BYTE_END_TRANSFER:
        {
            if (I2C_Master_TransmitBlock(&i2c, 0x3C, buffer, length, I2C_FLAG_SLVADDR_7BIT | I2C_FLAG_MEMADDR_8BIT) != ERR_NONE)
            {
                return 0;
            }
            break;
        }
        case U8X8_MSG_BYTE_SET_DC:
        {
            break;
        }
        default:
        {
            return 0;
        }
    }

    return 1;
}

static uint8_t u8x8_gpio_and_delay(u8x8_t* u8x8, uint8_t msg, uint8_t arg_int, void* arg_ptr)
{
#if 0
	
    switch (msg)
    {
        case U8X8_MSG_DELAY_100NANO:  // delay arg_int * 100 nano seconds
            __NOP();
            break;
        case U8X8_MSG_DELAY_10MICRO:  // delay arg_int * 10 micro seconds
            for (uint16_t n = 0; n < 320; n++)
            {
                __NOP();
            }
            break;
        case U8X8_MSG_DELAY_MILLI:  // delay arg_int * 1 milli second
            DelayBlockMs(1);
            break;
        case U8X8_MSG_DELAY_I2C:  // arg_int is the I2C speed in 100KHz, e.g. 4 = 400 KHz
            DelayBlockUs(5);
            break;                     // arg_int=1: delay by 5us, arg_int = 4: delay by 1.25us
        case U8X8_MSG_GPIO_I2C_CLOCK:  // arg_int=0: Output low at I2C clock pin
            break;                     // arg_int=1: Input dir with pullup high for I2C clock pin
        case U8X8_MSG_GPIO_I2C_DATA:   // arg_int=0: Output low at I2C data pin
            break;                     // arg_int=1: Input dir with pullup high for I2C data pin
        case U8X8_MSG_GPIO_MENU_SELECT:
            u8x8_SetGPIOResult(u8x8, /* get menu select pin state */ 0);
            break;
        case U8X8_MSG_GPIO_MENU_NEXT:
            u8x8_SetGPIOResult(u8x8, /* get menu next pin state */ 0);
            break;
        case U8X8_MSG_GPIO_MENU_PREV:
            u8x8_SetGPIOResult(u8x8, /* get menu prev pin state */ 0);
            break;
        case U8X8_MSG_GPIO_MENU_HOME:
            u8x8_SetGPIOResult(u8x8, /* get menu home pin state */ 0);
            break;
        default:
            u8x8_SetGPIOResult(u8x8, 1);  // default return value
            break;
    }

#endif
    return 1;
}

void U8G2_Test()
{
    u8g2_t u8g2;

    I2C_Master_Init(&i2c, 1e7, I2C_DUTYCYCLE_50_50);
    I2C_Master_ScanAddress(&i2c);

    u8g2_Setup_ssd1306_i2c_128x64_noname_f(&u8g2, U8G2_R0, u8x8_byte_hw_i2c, u8x8_gpio_and_delay);
    u8g2_InitDisplay(&u8g2);
    u8g2_SetPowerSave(&u8g2, 0);  // 使能
    u8g2_ClearBuffer(&u8g2);
    u8g2_SendBuffer(&u8g2);
    u8g2_DrawBox(&u8g2, 0, 0, 20, 20);
    u8g2_DrawBox(&u8g2, 20, 20, 20, 20);
    u8g2_SendBuffer(&u8g2);
    u8g2_DrawFrame(&u8g2, 10, 40, 20, 20);
    u8g2_SendBuffer(&u8g2);
    u8g2_SetFont(&u8g2, u8g2_font_DigitalDiscoThin_tf);
    u8g2_DrawStr(&u8g2, 30, 10, "free");
    u8g2_SendBuffer(&u8g2);
}

#endif
