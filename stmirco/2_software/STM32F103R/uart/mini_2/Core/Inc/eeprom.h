#ifndef __EEPROM_H__
#define __EEPROM_H__

#include "defs.h"
// #include "gconf.h"

#include "i2c.h"

//-----------------------------------------------------------------------------
//

#if 1
#include <stdio.h>
#define __eeprom_error(fmt, ...)  printf("[%5d] error: " fmt "\n", __LINE__, ##__VA_ARGS__)
#define __eeprom_printf(fmt, ...) printf("[%5d] " fmt "\n", __LINE__, ##__VA_ARGS__)
#else
#define __eeprom_error(fmt, ...)
#define __eeprom_printf(fmt, ...)
#endif

#define CONFIG_MIN_MEM_SIZE  128    // 最小容量/最小步进 (byte)
#define CONFIG_MAX_MEM_SIZE  65535  // 最大容量 (byte)
#define CONFIG_MIN_PAGE_SIZE 8      // 最小页容量 (byte)
#define CONFIG_MAX_PAGE_SIZE 128    // 最大页容量 (byte)

//-----------------------------------------------------------------------------
//

/**
 * @brief 设备类型
 */
typedef enum {
    AT24C01,
    AT24C02,
    AT24C04,
    AT24C08,
    AT24C16,
    AT24C32,
    AT24C64,
    AT24C128,
    AT24C256,
    AT24C512,
    AT24CM01,
    AT24CM02,
    __EEPROM_TYPE_COUNT,
} eeprom_type_e;

/**
 * @brief 设备属性
 */
typedef struct {
    u8  u8DevAddrMask;  // 设备地址掩码
    u32 u32MemSize;     // 内存大小（byte）
    u8  u8MemAddrSize;  // 内存地址大小（byte）
    u16 u16PageSize;    // 页大小（byte）
} eeprom_attr_t;

/**
 * @brief 设备接口
 */
typedef struct {
    u8            u8DevAddr;  // 设备地址(8bit)
    u8            u8Timeout;  // 应答超时时间(ms)
    eeprom_attr_t sEepromAttr;
#ifdef USE_HAL_DRIVER
    I2C_HandleTypeDef* pPort;  // 设备接口
#endif
} eeprom_t;

//-----------------------------------------------------------------------------
//

extern bool eeprom_identify(eeprom_t* pEeprom);
extern bool eeprom_set_type(eeprom_t* pEeprom, eeprom_type_e eType);

extern bool eeprom_read_bytes(eeprom_t* pEeprom, u32 u32MemAddr, u8* pu8ReadBuf, u16 u16NumToRead);
extern bool eeprom_write_bytes(eeprom_t* pEeprom, u32 u32MemAddr, u8* pu8WriteBuf, u16 u16NumToWrite);

#define eeprom_write_object(pEeprom, u32MemAddr, xObject) eeprom_write_bytes(pEeprom, u32MemAddr, (u8*)&xObject, sizeof(xObject))
#define eeprom_read_object(pEeprom, u32MemAddr, xObject)  eeprom_read_bytes(pEeprom, u32MemAddr, (u8*)&xObject, sizeof(xObject))

#endif
