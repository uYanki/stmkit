#include "bsp_i2c.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_i2c"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

// #define EEPROM_CAPACITY   // 容量(字节)
// #define EEPROM_ADDR_SIZE  // 地址大小(字节)
// #define EEPROM_PAGE_SIZE  // 页大小(字节)

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C01

#define EEPROM_CAPACITY  (1024 * 1 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE 8

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C02

#define EEPROM_CAPACITY  (1024 * 2 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE 8

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C04

#define EEPROM_CAPACITY  (1024 * 4 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE 16

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C08

#define EEPROM_CAPACITY  (1024 * 8 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE 16

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C16

#define EEPROM_CAPACITY  (1024 * 16 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE 16

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C32

#define EEPROM_CAPACITY  (1024 * 32 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE 32

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C64

#define EEPROM_CAPACITY  (1024 * 64 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE 32

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C128

#define EEPROM_CAPACITY  (1024 * 128 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE 64

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C256

#define EEPROM_CAPACITY  (1024 * 256 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE 64

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24C512

#define EEPROM_CAPACITY  (1024 * 512 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE 128

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24M01

#define EEPROM_CAPACITY  (1024 * 1024 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE 256

#elif CONFIG_EEPROM_TYPE == EEPROM_AT24M02

#define EEPROM_CAPACITY  (1024 * 2048 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE 256

#endif

#if EEPROM_ADDR_SIZE == 1
#define I2C_MEM_ADDR_WIDIH I2C_MEM_ADDR_WIDIH_8
#elif EEPROM_ADDR_SIZE == 2
#define I2C_MEM_ADDR_WIDIH I2C_MEM_ADDR_WIDIH_16
#endif

#define I2C_TIMEOUT 0xFFFFFF

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

i2c_handle_type hI2C = {
    .i2cx = EEPROM_I2C_BASE,
};

#include "paratbl.h"

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

bool EEPROM_WriteBlock(u32 u32MemAddr, u8* pu8Data, u16 u16Size)  // 按页写
{
    if ((u32MemAddr + (u32)u16Size) > EEPROM_CAPACITY)
    {
        return false;
    }

    u16 u16Timeout = 0;

    u16 u16SlvAddr;
    u16 u16MemAddr;

    u16 u16XferSize = EEPROM_PAGE_SIZE - (u32MemAddr % EEPROM_PAGE_SIZE);  // front

    if (u16XferSize > u16Size)
    {
        u16XferSize = u16Size;
    }

    while (u16Size > 0)
    {
#if CONFIG_EEPROM_TYPE < EEPROM_AT24C16
        u16SlvAddr = CONFIG_EEPROM_DEVADDR;
        u16SlvAddr |= (u32MemAddr >> 8) & 0x07;
        u16MemAddr = u32MemAddr & 0x000000FF;
#else
        u16SlvAddr = CONFIG_EEPROM_DEVADDR;
        u16SlvAddr |= (u32MemAddr >> 16) & 0x07;
        u16MemAddr = u32MemAddr & 0x0000FFFF;
#endif

    __retry:

        if (i2c_memory_write(&hI2C, I2C_MEM_ADDR_WIDIH, u16SlvAddr << 1, u16MemAddr, pu8Data, u16XferSize, 0xFFFFFFFF) != I2C_OK)
        {
            if (++u16Timeout > 10)
            {
                return false;
            }
            else
            {
                DelayBlockMs(1);
                goto __retry;
            }
        }

        u32MemAddr += (u32)u16XferSize;
        pu8Data += u16XferSize;
        u16Size -= u16XferSize;

        if (u16Size >= EEPROM_PAGE_SIZE)  // middle
        {
            u16XferSize = EEPROM_PAGE_SIZE;
        }
        else  // back
        {
            u16XferSize = u16Size;
        }
    }

    return true;
}

bool EEPROM_ReadBlock(u32 u32MemAddr, u8* pu8Buff, u16 u16Size)  // 连读
{
    if ((u32MemAddr + (u32)u16Size) > EEPROM_CAPACITY)
    {
        return false;
    }

    u16 u16SlvAddr;
    u16 u16MemAddr;
    u16 u16Flags;

#if CONFIG_EEPROM_TYPE < EEPROM_AT24C16
    u16SlvAddr = CONFIG_EEPROM_DEVADDR;
    u16SlvAddr |= (u32MemAddr >> 8) & 0x07;
    u16MemAddr = u32MemAddr & 0x000000FF;
#else
    u16SlvAddr = CONFIG_EEPROM_DEVADDR;
    u16SlvAddr |= (u32MemAddr >> 16) & 0x07;
    u16MemAddr = u32MemAddr & 0x0000FFFF;
#endif

    return i2c_memory_read(&hI2C, I2C_MEM_ADDR_WIDIH, u16SlvAddr << 1, u16MemAddr, pu8Buff, u16Size, I2C_TIMEOUT) == I2C_OK;
}
