#include "abs_mt6701.h"

abs_mt6701_t mt6701;

void MT6701RdPos(abs_mt6701_t* pMT6701)
{
    u32 u32Data = 0;

    PinSetLvl(ENCODER_SPI_CS_O, B_OFF);

    for (u8 i = 0; i < 3; ++i)
    {
        while (spi_i2s_flag_get(ENC_SPI_BASE, SPI_I2S_TDBE_FLAG) == RESET);
        spi_i2s_data_transmit(ENC_SPI_BASE, 0xFF);
        while (spi_i2s_flag_get(ENC_SPI_BASE, SPI_I2S_RDBF_FLAG) == RESET);
        pMT6701->au8RxData[i] = spi_i2s_data_receive(ENC_SPI_BASE);
    }

    PinSetLvl(ENCODER_SPI_CS_O, B_ON);

    u32Data = pMT6701->au8RxData[0] << 16;
    u32Data |= pMT6701->au8RxData[1] << 8;
    u32Data |= pMT6701->au8RxData[2] << 0;

    // u8 u6Crc = GETBITS(u32Data, 0, 6);
    // u8 u4Sts = GETBITS(u32Data, 6, 4);

    pMT6701->u32Pos = GETBITS(u32Data, 10, 14);

#if 0
    // crc error
    pMT6701->u8CommSts = 0;

#endif

    pMT6701->u8CommSts = 1;
}
