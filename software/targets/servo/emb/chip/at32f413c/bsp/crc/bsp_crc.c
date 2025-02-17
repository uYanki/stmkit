#include "bsp_crc.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_crc"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

u16 Crc16_ModbusRtu(u8* pu8Data, u16 u16Len)
{
    u16 u16Ind;

    crc_init_data_set(0xFFFF);
    crc_poly_size_set(CRC_POLY_SIZE_16B);
    crc_poly_value_set(0x8005);
    crc_reverse_input_data_set(CRC_REVERSE_INPUT_BY_BYTE);
    crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_DATA);
    crc_data_reset();

    for (u16Ind = 0; u16Ind < u16Len; u16Ind++)
    {
        REG8(CRC) = pu8Data[u16Ind];
    }

    return CRC->dt;
}
