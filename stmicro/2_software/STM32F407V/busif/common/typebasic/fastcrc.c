#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

typedef enum {
    CRC4_ITU = 0,
    CRC5_EPC,
    CRC5_ITU,
    CRC5_USB,
    CRC6_ITU,
    CRC7_MMC,
    CRC8,
    CRC8_ITU,
    CRC8_ROHC,
    CRC8_MAXIM,
    CRC16_IBM,
    CRC16_MAXIM,
    CRC16_USB,
    CRC16_MODBUS,
    CRC16_CCITT,
    CRC16_CCITT_FALSE,
    CRC16_X25,
    CRC16_XMODEM,
    CRC16_DNP,
    CRC32,
    CRC32_MPEG2,
    CRC_NUM
} crc_type_e;

typedef struct {
    const char* name;
    uint8_t     width;    // 宽度，即CRC比特数。
    uint32_t    poly;     // 生成多项式的简写，以16进制表示。例如：CRC-32即是0x04C11DB7，忽略了最高位的"1"，即完整的生成项是0x104C11DB7。
    uint32_t    init;     // 初始值,这是算法开始时寄存器（crc）的初始化预置值，十六进制表示。
    uint32_t    xor_out;  // 计算结果与此参数异或后得到最终的CRC值。
    bool        ref_in;   // 待测数据的每个字节是否按位反转。
    bool        ref_out;  // 在计算后之后，异或输出之前，整个数据是否按位反转。
} crc_info_t;

const static crc_info_t crc_map[CRC_NUM] = {
    // CRC算法名称		宽度  多项式       初始值   结果异或值    输入反转  输出反转
    {"CRC4_ITU",          4,  0x03,       0x00,       0x00,       true,  true },
    {"CRC5_EPC",          5,  0x09,       0x09,       0x00,       false, false},
    {"CRC5_ITU",          5,  0x15,       0x00,       0x00,       true,  true },
    {"CRC5_USB",          5,  0x05,       0x1F,       0x1F,       true,  true },
    {"CRC6_ITU",          6,  0x03,       0x00,       0x00,       true,  true },
    {"CRC7_MMC",          7,  0x09,       0x00,       0x00,       false, false},
    {"CRC8",              8,  0x07,       0x00,       0x00,       false, false},
    {"CRC8_ITU",          8,  0x07,       0x00,       0x55,       false, false},
    {"CRC8_ROHC",         8,  0x07,       0xFF,       0x00,       true,  true },
    {"CRC8_MAXIM",        8,  0x31,       0x00,       0x00,       true,  true },
    {"CRC16_IBM",         16, 0x8005,     0x0000,     0x0000,     true,  true },
    {"CRC16_MAXIM",       16, 0x8005,     0x0000,     0xFFFF,     true,  true },
    {"CRC16_USB",         16, 0x8005,     0xFFFF,     0xFFFF,     true,  true },
    {"CRC16_MODBUS",      16, 0x8005,     0xFFFF,     0x0000,     true,  true },
    {"CRC16_CCITT",       16, 0x1021,     0x0000,     0x0000,     true,  true },
    {"CRC16_CCITT_FALSE", 16, 0x1021,     0xFFFF,     0x0000,     false, false},
    {"CRC16_X25",         16, 0x1021,     0xFFFF,     0xFFFF,     true,  true },
    {"CRC16_XMODEM",      16, 0x1021,     0x0000,     0x0000,     false, false},
    {"CRC16_DNP",         16, 0x3D65,     0x0000,     0xFFFF,     true,  true },
    {"CRC32",             32, 0x04C11DB7, 0xFFFFFFFF, 0xFFFFFFFF, true,  true },
    {"CRC32_MPEG2",       32, 0x04C11DB7, 0xFFFFFFFF, 0x00000000, false, false}
};

static uint32_t crc_tbl[256];

uint32_t reverse_bits(uint32_t input, uint8_t bits)  // 位反转
{
    // 0x0 -> 0x0 | 0x4 -> 0x2 | 0x8 -> 0x1 | 0xC -> 0x3
    // 0x1 -> 0x8 | 0x5 -> 0xA | 0x9 -> 0x9 | 0xD -> 0xB
    // 0x2 -> 0x4 | 0x6 -> 0x6 | 0xA -> 0x5 | 0xE -> 0x7
    // 0x3 -> 0xC | 0x7 -> 0xE | 0xB -> 0xD | 0xF -> 0xF

    static const uint8_t revtab[] = {0x0, 0x8, 0x4, 0xC, 0x2, 0xA, 0x6, 0xE, 0x1, 0x9, 0x5, 0xD, 0x3, 0xB, 0x7, 0xF};

    uint32_t output = 0;

    while (bits)
    {
        output <<= 4;
        output |= revtab[input & 0xF];

        if (bits >= 4)
        {
            bits -= 4;
            input >>= 4;
        }
        else
        {
            output >>= (4 - bits);
            bits = 0;
        }
    }

    return output;
}

uint32_t crc(crc_type_e type, uint8_t* buff, uint16_t size)
{
    uint8_t  width  = crc_map[type].width;
    uint32_t crc    = crc_map[type].init;
    uint32_t xorout = crc_map[type].xor_out;
    uint8_t  refin  = crc_map[type].ref_in;
    uint8_t  refout = crc_map[type].ref_out;
    uint8_t  high;

    if (refin)  // 逆序 LSB 输入
    {
        crc = reverse_bits(crc, width);  // 先逆序;

        if (width > 8)  // 为了减少移位等操作，width大于8和小于8的分开处理
        {
            while (size--)
            {
                crc = (crc >> 8) ^ crc_tbl[(crc & 0xFF) ^ *buff++];
            }
        }
        else
        {
            while (size--)
            {
                crc = crc_tbl[crc ^ *buff++];
            }
        }
    }
    else  // 正序 MSB 输入
    {
        if (width > 8)  // 为了减少移位等操作，width大于8和小于8的分开处理
        {
            while (size--)
            {
                high = crc >> (width - 8);
                crc  = (crc << 8) ^ crc_tbl[high ^ *buff++];
            }
        }
        else
        {
            crc = crc << (8 - width);

            while (size--)
            {
                crc = crc_tbl[crc ^ *buff++];
            }

            crc >>= 8 - width;  // 位数小于8时，crc在高width位，要右移到原位
        }
    }

    if (refout != refin)  // 逆序输出
    {
        crc = reverse_bits(crc, width);
    }

    crc ^= xorout;  // 异或输出

    return crc & ((2 << (width - 1)) - 1);
}

/**
 *******************************************************************************
 * @brief   打印CRC表 函数
 * @param   [in] type	- CRC算法类型
 * @return  None
 * @note
 *******************************************************************************
 */
void PrintfCrcTab(uint8_t type)
{
    uint32_t i;

    printf("crc tbl = \n{//%s", crc_map[type].name);

    for (i = 0; i < 256; i++)
    {
        if (i % 16 == 0)
        {
            printf("\n    ");
        }
        if (crc_map[type].width <= 8)
        {
            printf("0x%02X, ", crc_tbl[i]);
        }
        else if (crc_map[type].width <= 16)
        {
            printf("0x%04X, ", crc_tbl[i]);
        }
        else
        {
            printf("0x%08X, ", crc_tbl[i]);
        }
    }

    printf("\n};\n\n");
}

void MakeCrcTable(uint8_t type)
{
    uint8_t  width  = crc_map[type].width;   // 宽度，即CRC比特数。
    uint32_t poly   = crc_map[type].poly;    // 生成多项式的简写，以16进制表示。例如：CRC-32即是0x04C11DB7，忽略了最高位的"1"，即完整的生成项是0x104C11DB7。
    uint8_t  ref_in = crc_map[type].ref_in;  // 待测数据的每个字节是否按位反转，true或false。
    uint32_t bitmsk = (2 << (width - 1)) - 1;
    uint32_t value;
    uint32_t bit;
    uint32_t i;
    uint8_t  j;

    if (ref_in)  // 逆序LSB输入
    {
        poly = reverse_bits(poly, width);  // poly先逆序

        for (i = 0; i < 256; i++)
        {
            value = i;

            for (j = 0; j < 8; j++)
            {
                if (value & 1)
                {
                    value = (value >> 1) ^ poly;
                }
                else
                {
                    value = (value >> 1);
                }
            }

            crc_tbl[i] = value & bitmsk;
        }
    }
    else  // 正序MSB输入
    {
        poly = (width < 8) ? (poly << (8 - width)) : poly;  // 如果位数小于8，poly要左移到最高位
        bit  = (width > 8) ? (1 << (width - 1)) : 0x80;

        for (i = 0; i < 256; i++)
        {
            value = (width > 8) ? (i << (width - 8)) : i;

            for (j = 0; j < 8; j++)
            {
                if (value & bit)
                {
                    value = (value << 1) ^ poly;
                }
                else
                {
                    value = (value << 1);
                }
            }

            crc_tbl[i] = value & ((width < 8) ? 0xFF : bitmsk);
        }
    }

    PrintfCrcTab(type);
}

#if 0

void main()
{
    char*    str = "Hello World!";
    uint32_t i;

    uint32_t result[] = {
        [CRC4_ITU]          = 0x9,
        [CRC5_EPC]          = 0x1F,
        [CRC5_ITU]          = 0x10,
        [CRC5_USB]          = 0xD,
        [CRC6_ITU]          = 0x3D,
        [CRC7_MMC]          = 0x3B,
        [CRC8]              = 0x1C,
        [CRC8_ITU]          = 0x49,
        [CRC8_ROHC]         = 0x4C,
        [CRC8_MAXIM]        = 0x9E,
        [CRC16_IBM]         = 0x57BE,
        [CRC16_MAXIM]       = 0xA841,
        [CRC16_USB]         = 0xAA25,
        [CRC16_MODBUS]      = 0x55DA,
        [CRC16_CCITT]       = 0x6B65,
        [CRC16_CCITT_FALSE] = 0x882A,
        [CRC16_X25]         = 0xBBB,
        [CRC16_XMODEM]      = 0xCD3,
        [CRC16_DNP]         = 0x8A5A,
        [CRC32]             = 0x1C291CA3,
        [CRC32_MPEG2]       = 0x94E58351,
    };

    for (i = 0; i < CRC_NUM; i++)
    {
        MakeCrcTable(i);  // CRC表创建
        printf("%s = %d\n", crc_map[i].name, crc(i, (uint8_t*)str, strlen(str)) == result[i]);
    }
}

#endif