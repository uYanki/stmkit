#include "main.h"

extern SPI_HandleTypeDef hspi1;

static void SPI_WriteByte(uint8_t TxData)
{
    HAL_SPI_Transmit(&hspi1, &TxData, 1, 0xFFFF);
}

static uint8_t SPI_ReadByte()
{
    uint8_t RxData = 0;
    while (HAL_SPI_Receive(&hspi1, &RxData, 1, 0xFFFF) != HAL_OK);
    return RxData;
}

void SPI_CrisEnter(void)
{
    __set_PRIMASK(1);
}

void SPI_CrisExit(void)
{
    __set_PRIMASK(0);
}

void SPI_CS_Select(void)
{
    HAL_GPIO_WritePin(SPI_CS_W5500_GPIO_Port, SPI_CS_W5500_Pin, GPIO_PIN_RESET);
}

void SPI_CS_Deselect(void)
{
    HAL_GPIO_WritePin(SPI_CS_W5500_GPIO_Port, SPI_CS_W5500_Pin, GPIO_PIN_SET);
}

void register_wizchip()
{
    // First of all, Should register SPI callback functions implemented by user for accessing WIZCHIP
    /* Critical section callback */
    reg_wizchip_cris_cbfunc(SPI_CrisEnter, SPI_CrisExit);
    /* Chip selection call back */
    reg_wizchip_cs_cbfunc(SPI_CS_Select, SPI_CS_Deselect);

    /* SPI Read & Write callback function */
    reg_wizchip_spi_cbfunc(SPI_ReadByte, SPI_WriteByte);
}
