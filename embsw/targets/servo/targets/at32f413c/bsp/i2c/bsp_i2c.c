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
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C02
#define EEPROM_CAPACITY  (1024 * 2 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C04
#define EEPROM_CAPACITY  (1024 * 4 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C08
#define EEPROM_CAPACITY  (1024 * 8 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C16
#define EEPROM_CAPACITY  (1024 * 16 / 8)
#define EEPROM_ADDR_SIZE 1
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C32
#define EEPROM_CAPACITY  (1024 * 32 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C64
#define EEPROM_CAPACITY  (1024 * 64 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C128
#define EEPROM_CAPACITY  (1024 * 128 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C256
#define EEPROM_CAPACITY  (1024 * 256 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24C512
#define EEPROM_CAPACITY  (1024 * 512 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24M01
#define EEPROM_CAPACITY  (1024 * 1024 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE
#endif

#if CONFIG_EEPROM_TYPE == EEPROM_AT24M02
#define EEPROM_CAPACITY  (1024 * 2048 / 8)
#define EEPROM_ADDR_SIZE 2
#define EEPROM_PAGE_SIZE
#endif

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

i2c_handle_type hI2C = {
    .i2cx = EEPROM_I2C_BASE,
};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

bool EEPROM_ReadBlock(u16 u16MemAddr, u16* pu16Buff, u16 u16WordCnt)
{
    return i2c_memory_read(&hI2C, I2C_MEM_ADDR_WIDIH_16, CONFIG_EEPROM_DEVADDR, u16MemAddr, (u8*)pu16Buff, u16WordCnt << 1, 0xFF) == I2C_OK;
}

bool EEPROM_WriteBlock(u16 u16MemAddr, u16* pu16Buff, u16 u16WordCnt)
{
    return i2c_memory_write(&hI2C, I2C_MEM_ADDR_WIDIH_16, CONFIG_EEPROM_DEVADDR, u16MemAddr, (u8*)pu16Buff, u16WordCnt << 1, 0xFF) == I2C_OK;
}
