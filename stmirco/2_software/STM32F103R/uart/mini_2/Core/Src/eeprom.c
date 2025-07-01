#include "eeprom.h"

/**
 * 有些型号的设备地址段的某些位用于内存地址（P）页寻址，
 * 设备地址的可设定位数（A）决定了同一总线上所挂载的器件数量
 */

static RO eeprom_attr_t saEepromAttrs[] = {
    {0xFE,    128, 1,   0}, // [ ]  AT24C01, 1010 + A2|A1|A0 + R/W
    {0xFE,    256, 1,   8}, // [√]  AT24C02, 1010 + A2|A1|A0 + R/W
    {0xFC,    512, 1,  16}, // [ ]  AT24C04, 1010 + A2|A1|P0 + R/W
    {0xF8,   1024, 1,  16}, // [ ]  AT24C08, 1010 + A2|P1|P0 + R/W
    {0xF0,   2048, 1,  16}, // [ ]  AT24C16, 1010 + P2|P1|P0 + R/W
    {0xFE,   4096, 2,  32}, // [ ]  AT24C32, 1010 + A2|A1|A0 + R/W
    {0xFE,   8192, 2,  32}, // [√]  AT24C64, 1010 + A2|A1|A0 + R/W
    {0xFE,  16384, 2,  64}, // [ ] AT24C128, 1010 + A2|A1|A0 + R/W
    {0xFE,  32768, 2,  64}, // [ ] AT24C256, 1010 + A2|A1|A0 + R/W
    {0xFE,  65536, 2, 128}, // [ ] AT24C512, 1010 + A2|A1|A0 + R/W
    {0xFC, 131072, 2,   0}, // [ ] AT24CM01, 1010 + A2|A1|P0 + R/W
    {0xF8, 262144, 2,   0}, // [ ] AT24CM02, 1010 + A2|P1|P0 + R/W
};

u8 higbit(u32 n)
{
    f32 b = n;
    return (*((u32*)&b) >> 23 & 255) - 127;
}

//

static bool eeprom_is_ready(eeprom_t* pEeprom)
{
    u8 u8Timeout = pEeprom->u8Timeout;

    while (1)
    {
#ifdef USE_HAL_DRIVER  // STM32
        if (HAL_I2C_IsDeviceReady(pEeprom->pPort, pEeprom->u8DevAddr, 5, HAL_MAX_DELAY) == HAL_OK)
#else
#error "unsupported"
#endif
        {
            return true;
        }

        if (u8Timeout == 0)
        {
            return false;
        }

        --u8Timeout;

        HAL_Delay(1);
    }
}

//-----------------------------------------------------------------------------

static void __eeprom_generate_address(__IN eeprom_attr_t* pAttr, __IN u8 u8DevAddr, __IN u32 u32MemAddr, __OUT u8* pu8DevAddr, __OUT u16* pu16MemAddr, __OUT u16* pu16MemAddrSize)
{
    // 内存地址的部分位可能占据了部分设备地址位 !!

#if 1

    u16 u16MemAddrHi;
    u16 u16MemAddrLo;
    u16 u16MemAddrSize;

    u8DevAddr &= pAttr->u8DevAddrMask;

    if (pAttr->u8MemAddrSize == 1)  // 8BIT
    {
        u16MemAddrSize = I2C_MEMADD_SIZE_8BIT;
        u16MemAddrHi   = (u8)(u32MemAddr >> 7) & 0x0E;
        u16MemAddrLo   = (u16)(u32MemAddr & 0xFF);
    }
    else  // 16BIT
    {
        u16MemAddrSize = I2C_MEMADD_SIZE_16BIT;
        u16MemAddrHi   = (u8)(u32MemAddr >> 15) & 0x0E;
        u16MemAddrLo   = (u16)(u32MemAddr & 0xFFFF);
    }

    // u8DevAddr |= u16MemAddrHi & ~(pAttr->u8DevAddrMask);

    // output

    *pu8DevAddr      = u8DevAddr;
    *pu16MemAddr     = u16MemAddrLo;
    *pu16MemAddrSize = u16MemAddrSize;

#else

    *pu8DevAddr      = u8DevAddr;
    *pu16MemAddr     = u32MemAddr;
    *pu16MemAddrSize = I2C_MEMADD_SIZE_16BIT;

#endif
}

static bool __eeprom_read_block(eeprom_t* pEeprom, u32 u32MemAddr, u8* pu8ReadBuf, u16 u16NumToRead)
{
    u8  u8DevAddr;
    u16 u16MemAddr;
    u16 u16MemAddrSize;

    __eeprom_generate_address(&pEeprom->sEepromAttr, pEeprom->u8DevAddr, u32MemAddr, &u8DevAddr, &u16MemAddr, &u16MemAddrSize);

#ifdef USE_HAL_DRIVER  // STM32
    return HAL_I2C_Mem_Read(pEeprom->pPort, u8DevAddr, u16MemAddr, u16MemAddrSize, pu8ReadBuf, u16NumToRead, HAL_MAX_DELAY) == HAL_OK;
#else
#error "unsupported"
#endif
}

static bool __eeprom_write_block(eeprom_t* pEeprom, u32 u32MemAddr, u8* pu8WriteBuf, u16 u16NumToWrite)
{
    u8  u8DevAddr;
    u16 u16MemAddr;
    u16 u16MemAddrSize;

    __eeprom_generate_address(&pEeprom->sEepromAttr, pEeprom->u8DevAddr, u32MemAddr, &u8DevAddr, &u16MemAddr, &u16MemAddrSize);

#ifdef USE_HAL_DRIVER  // STM32
    return HAL_I2C_Mem_Write(pEeprom->pPort, u8DevAddr, u16MemAddr, u16MemAddrSize, pu8WriteBuf, u16NumToWrite, HAL_MAX_DELAY) == HAL_OK;
#else
#error "unsupported"
#endif
}

//-----------------------------------------------------------------------------

bool eeprom_set_type(eeprom_t* pEeprom, eeprom_type_e eType)
{
    if (eType < __EEPROM_TYPE_COUNT)
    {
        pEeprom->sEepromAttr = saEepromAttrs[eType];
        return true;
    }

    return false;
}

/**
 * @brief EEPROM 参数辨识
 */
bool eeprom_identify(eeprom_t* pEeprom)
{
    //
    // 识别原理:
    //
    // - 容量：往超出容量范围的字地址写入数据，等同于往最大边界地址写入数据。
    // - 页地址：单次页写周期内，字地址达到该页边界地址时，字地址将回转到该页的首字节，随后写入的字节将会被覆盖先前的字节。
    //

    if (eeprom_is_ready(pEeprom) == false)
    {
        __eeprom_error("device doesn't exist");  // 设备不存在
        return false;
    }

    HAL_Delay(10);

    //-------------------------------------------------------------------------
    //

    eeprom_attr_t* pAttr = &pEeprom->sEepromAttr;

    pAttr->u16PageSize   = 0;  // 待辨识项
    pAttr->u32MemSize    = 0;  // 待辨识项
    pAttr->u8MemAddrSize = 0;  // 待辨识项
    pAttr->u8DevAddrMask = 0xF0;

    u16 u16MaxMemAddr;

    RO u8 cu8BytesWritten[] = {0xA8, 0xAF, 0xF1};  // 用于测试内存边界地址的字节序列
    u32   u32ScanedMemAddr  = 0;                   // 扫描到的内存边界地址(byte)

    for (u8 u8Times = 0; u8Times < ARRAY_SIZE(cu8BytesWritten); ++u8Times)
    {
        RO u8 cu8ByteWritten = cu8BytesWritten[u8Times];

        if (pAttr->u8MemAddrSize == 0)
        {
            // 地址位宽识别

            pAttr->u8MemAddrSize = 2;
            u16MaxMemAddr        = 0xFFFF;

            if (__eeprom_write_block(pEeprom, u16MaxMemAddr, (u8*)&cu8ByteWritten, 1) == false)
            {
                pAttr->u8MemAddrSize = 1;
                u16MaxMemAddr        = 0xFF;

                HAL_Delay(50);

                if (__eeprom_write_block(pEeprom, u16MaxMemAddr, (u8*)&cu8ByteWritten, 1) == false)
                {
                    __eeprom_error("i2c write fail");
                    return false;
                }
            }
        }
        else
        {
            if (__eeprom_write_block(pEeprom, u16MaxMemAddr, (u8*)&cu8ByteWritten, 1) == false)
            {
                __eeprom_error("i2c write fail");
                return false;
            }
        }

        if (eeprom_is_ready(pEeprom) == false)
        {
            __eeprom_error("timeout");
            return false;  // 器件超时未应答
        }

        for (u32 u32MemAddr = CONFIG_MIN_MEM_SIZE - 1; u32MemAddr <= CONFIG_MAX_MEM_SIZE; u32MemAddr += CONFIG_MIN_MEM_SIZE)
        {
            u8 u8ReadBuffer = 0;  // 读缓冲

            if (__eeprom_read_block(pEeprom, u32MemAddr, (u8*)&u8ReadBuffer, 1) == false)
            {
                __eeprom_error("i2c read fail");
                return false;
            }

            if (u8ReadBuffer == cu8ByteWritten)
            {
                if (u8Times > 0 && u32ScanedMemAddr != u32MemAddr)
                {
                    // 前后两次识别到的边界不同, 需修改用于测试的边界字节序列
                    __eeprom_error("different memory address -%d -%d", u32ScanedMemAddr, u32MemAddr);
                    return false;
                }

                u32ScanedMemAddr = u32MemAddr;
                __eeprom_printf("[%d]", u32ScanedMemAddr);

                break;
            }
        }

        if (u32ScanedMemAddr < CONFIG_MIN_MEM_SIZE)
        {
            __eeprom_error("fail to scan");
            return false;
        }
    }

    pAttr->u32MemSize = u32ScanedMemAddr + 1;

    //-------------------------------------------------------------------------
    //

    RO u8 cu8WritePageBuffer[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129};  // 页写

    for (u16 u16MemAddr = 0; u16MemAddr < CONFIG_MAX_PAGE_SIZE; u16MemAddr += CONFIG_MIN_PAGE_SIZE)  // 最小页大小 8Byte
    {
        u8 u8ReadBuffer = 0;

        if (__eeprom_write_block(pEeprom, u16MemAddr, (u8*)&cu8WritePageBuffer[u16MemAddr], CONFIG_MIN_PAGE_SIZE + 1) == false)
        {
            __eeprom_error("i2c write");
            return false;  // I2C写错误
        }

        if (eeprom_is_ready(pEeprom) == false)
        {
            __eeprom_error("timeout");
            return false;  // 器件超时未应答
        }

        if (__eeprom_read_block(pEeprom, 0, (u8*)&u8ReadBuffer, 1) == false)
        {
            __eeprom_error("i2c read fail");
            return false;  // I2C读错误
        }

        if (u8ReadBuffer != cu8WritePageBuffer[0])
        {
            pAttr->u16PageSize = u8ReadBuffer;
            break;
        }
    }

    //-------------------------------------------------------------------------
    //

    __eeprom_printf("EEPROM");
    __eeprom_printf("- MemSize = %d byte / %d kbit", pAttr->u32MemSize, pAttr->u32MemSize * 8 / 1024);  // 容量
    __eeprom_printf("- MemAddrWidth = %d bit", higbit(pAttr->u32MemSize));                              // 内存地址位宽
    __eeprom_printf("- MemAddrSize = %d byte", pAttr->u8MemAddrSize);                                   // 内存地址大小
    __eeprom_printf("- PageSize = %d byte", pAttr->u16PageSize);                                        // 页大小
    __eeprom_printf("- PageCount = %d", pAttr->u32MemSize / pAttr->u16PageSize);                        // 页数

    return true;
}

bool eeprom_read_bytes(eeprom_t* pEeprom, u32 u32MemAddr, u8* pu8ReadBuf, u16 u16NumToRead)  // 能连读
{
    return __eeprom_read_block(pEeprom, u32MemAddr, pu8ReadBuf, u16NumToRead);
}

/**
 * @note 为提高读写效率，采用按页填充方式
 */
bool eeprom_write_bytes(eeprom_t* pEeprom, u32 u32MemAddr, u8* pu8WriteBuf, u16 u16NumToWrite)  // 不能连写
{
    eeprom_attr_t* pAttr = &pEeprom->sEepromAttr;

    //-----------------------------------------------------
    // 检查内存地址范围是否合法

    if ((u32MemAddr + (u32)u16NumToWrite) > pAttr->u32MemSize)
    {
        __eeprom_error("out of memeroy");
        return false;
    }

    //-----------------------------------------------------
    // 计算需要往起始地址所在页写入的字节数

    u8 u16PageSize  = pAttr->u16PageSize;
    u8 u8PageRemain = (u16PageSize - u32MemAddr % u16PageSize);  // 每页写入字节数

    if (u16NumToWrite <= u8PageRemain)
    {
        u8PageRemain = (u8)u16NumToWrite;
    }

    //-----------------------------------------------------
    // 阻塞写入数据

    u16 u16MemAddr;

    while (1)
    {
        if (eeprom_is_ready(pEeprom) == false)
        {
            __eeprom_error("device doesn't exist");
            return false;
        }

        if (__eeprom_write_block(pEeprom, u32MemAddr, pu8WriteBuf, u8PageRemain) == false)
        {
            // error: read failed
            return false;
        }

        if (u8PageRemain == u16NumToWrite)
        {
            break;  // 已全部写入
        }

        u16MemAddr += u8PageRemain;
        pu8WriteBuf += u8PageRemain;
        u16NumToWrite -= u8PageRemain;  // 剩余字节数

        if (u16NumToWrite < u16PageSize)
        {
            u8PageRemain = (u8)u16NumToWrite;  // 末尾
        }
        else
        {
            u8PageRemain = u16PageSize;  // 中间(按页填充)
        }
    }

    eeprom_is_ready(pEeprom);

    return true;
}

#if 0

/**
 * @param wrap_num number of displays per line, range: [1,64]
 */
bool at24cxx_print(eeprom_type_e chip, u16 start, u16 len, u8 wrap_num)
{
    if (wrap_num == 0)
    {
        return false;
    }

    u8 buff[64];

    if (wrap_num > 64)
    {
        wrap_num = 64;
    }

    u16 end = start + len;

    while (start < end)
    {
        // read data to buff
        if (!eeprom_read_bytes(chip, start, buff, wrap_num))
        {
            println("fail to read at24cxx [%05d]", start);
            return false;
        }

        // print pos and len
        printf("[%05d,%05d,%02d]", start, start + wrap_num, wrap_num);

        // set next reading pos
        start += wrap_num;

        // print buffer
        for (u8 j = 0; j < wrap_num; ++j)
        {
            printf("%5d", buff[j]);
        }
        println("");

        // count of rest
        if (start + wrap_num > end)
        {
            wrap_num = end - start;
        }
    }

    return true;
}

#endif

//

#define READ_CMD  1
#define WRITE_CMD 0

#define x24C256        // 器件名称，AT24C32、AT24C64、AT24C128、AT24C256、AT24C512
#define DEV_ADDR 0xA0  // 设备硬件地址

#ifdef x24C32
#define PAGE_NUM      128                     // 页数
#define PAGE_SIZE     32                      // 页面大小(字节)
#define CAPACITY_SIZE (PAGE_NUM * PAGE_SIZE)  // 总容量(字节)
#define ADDR_BYTE_NUM 2                       // 地址字节个数
#endif

#ifdef x24C64
#define PAGE_NUM      256                     // 页数
#define PAGE_SIZE     32                      // 页面大小(字节)
#define CAPACITY_SIZE (PAGE_NUM * PAGE_SIZE)  // 总容量(字节)
#define ADDR_BYTE_NUM 2                       // 地址字节个数
#endif

#ifdef x24C128
#define PAGE_NUM      256                     // 页数
#define PAGE_SIZE     64                      // 页面大小(字节)
#define CAPACITY_SIZE (PAGE_NUM * PAGE_SIZE)  // 总容量(字节)
#define ADDR_BYTE_NUM 2                       // 地址字节个数
#endif

#ifdef x24C256
#define PAGE_NUM      512                     // 页数
#define PAGE_SIZE     64                      // 页面大小(字节)
#define CAPACITY_SIZE (PAGE_NUM * PAGE_SIZE)  // 总容量(字节)
#define ADDR_BYTE_NUM 2                       // 地址字节个数
#endif

#ifdef x24C512
#define PAGE_NUM      512                     // 页数
#define PAGE_SIZE     128                     // 页面大小(字节)
#define CAPACITY_SIZE (PAGE_NUM * PAGE_SIZE)  // 总容量(字节)
#define ADDR_BYTE_NUM 2                       // 地址字节个数
#endif

void x24Cxx_WriteByte(uint16_t u16Addr, uint8_t u8Data)
{
    HAL_I2C_Mem_Write(&hi2c2, DEV_ADDR, u16Addr, I2C_MEMADD_SIZE_16BIT, &u8Data, 1, HAL_MAX_DELAY);
}

// 最多写入1页，防止翻卷，如果地址跨页则去掉跨页的部分
void x24Cxx_WritePage(uint16_t u16Addr, uint8_t u8Len, uint8_t* pData)
{
    uint8_t i;

    if (u8Len > PAGE_SIZE)  // 长度大于页的长度
    {
        u8Len = PAGE_SIZE;
    }
    if ((u16Addr + (uint16_t)u8Len) > CAPACITY_SIZE)  // 超过容量
    {
        u8Len = (uint8_t)(CAPACITY_SIZE - u16Addr);
    }
    if (((u16Addr % PAGE_SIZE) + (uint16_t)u8Len) > PAGE_SIZE)  // 判断是否跨页
    {
        u8Len -= (uint8_t)((u16Addr + (uint16_t)u8Len) % PAGE_SIZE);  // 跨页，截掉跨页的部分
    }

    HAL_I2C_Mem_Write(&hi2c2, DEV_ADDR, u16Addr, I2C_MEMADD_SIZE_16BIT, pData, u8Len, HAL_MAX_DELAY);
}

uint8_t x24Cxx_ReadByte(uint16_t u16Addr)
{
    uint8_t u8Data = 0;

    HAL_I2C_Mem_Read(&hi2c2, DEV_ADDR, u16Addr, I2C_MEMADD_SIZE_16BIT, &u8Data, 1, HAL_MAX_DELAY);

    return u8Data;
}

// 最多读1页，防止翻卷，如果地址跨页则去掉跨页的部分
void x24Cxx_ReadPage(uint16_t u16Addr, uint8_t u8Len, uint8_t* pBuff)
{
    if (u8Len > PAGE_SIZE)  // 长度大于页的长度
    {
        u8Len = PAGE_SIZE;
    }
    if ((u16Addr + (uint16_t)u8Len) > CAPACITY_SIZE)  // 超过容量
    {
        u8Len = (uint8_t)(CAPACITY_SIZE - u16Addr);
    }
    if (((u16Addr % PAGE_SIZE) + (uint16_t)u8Len) > PAGE_SIZE)  // 判断是否跨页
    {
        u8Len -= (uint8_t)((u16Addr + (uint16_t)u8Len) % PAGE_SIZE);  // 跨页，截掉跨页的部分
    }

    HAL_I2C_Mem_Read(&hi2c2, DEV_ADDR, u16Addr, I2C_MEMADD_SIZE_16BIT, pBuff, u8Len, HAL_MAX_DELAY);
}
