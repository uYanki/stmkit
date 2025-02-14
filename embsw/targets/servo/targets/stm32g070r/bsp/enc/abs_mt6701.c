#include "abs_mt6701.h"

#include "spi.h"
#define ENC_SPI (&hspi1)

abs_mt6701_t mt6701;

void MT6701RdPos(abs_mt6701_t* pMT6701)
{
    u32 u32Data = 0;

    HAL_GPIO_WritePin(SPI1_CS_GPIO_Port, SPI1_CS_Pin, GPIO_PIN_RESET);

#if 1

    __HAL_SPI_ENABLE(ENC_SPI);

    while (!__HAL_SPI_GET_FLAG(ENC_SPI, SPI_FLAG_RXNE));
    pMT6701->au8RxData[0] = *(__IO uint8_t*)&ENC_SPI->Instance->DR;

    while (!__HAL_SPI_GET_FLAG(ENC_SPI, SPI_FLAG_RXNE));
    pMT6701->au8RxData[1] = *(__IO uint8_t*)&ENC_SPI->Instance->DR;

    while (!__HAL_SPI_GET_FLAG(ENC_SPI, SPI_FLAG_RXNE));
    pMT6701->au8RxData[2] = *(__IO uint8_t*)&ENC_SPI->Instance->DR;

    __HAL_SPI_DISABLE(ENC_SPI);

    HAL_GetTick();  // 此处不调用会导致编码器读出值不正常

    while ((ENC_SPI->Instance->SR & SPI_FLAG_FRLVL) != SPI_FRLVL_EMPTY)
    {
        /* Flush Data Register by a blank read */
        __IO uint8_t u8TmpBuf = *(__IO uint8_t*)&ENC_SPI->Instance->DR;
    }

#else
    HAL_SPI_Receive2(ENC_SPI, pMT6701->au8RxData, 3, 1);
#endif

    HAL_GPIO_WritePin(SPI1_CS_GPIO_Port, SPI1_CS_Pin, GPIO_PIN_SET);

    u32Data = (u32)pMT6701->au8RxData[0] << 16;
    u32Data |= (u32)pMT6701->au8RxData[1] << 8;
    u32Data |= (u32)pMT6701->au8RxData[2] << 0;

    // u8 u6Crc = GETBITS(u32Data, 0, 6);
    // u8 u4Sts = GETBITS(u32Data, 6, 4);

    pMT6701->u32Pos = GETBITS(u32Data, 10, 14);

#if 0
    // crc error
    pMT6701->u8CommSts = 0;

#endif

    pMT6701->u8CommSts = 1;
}
