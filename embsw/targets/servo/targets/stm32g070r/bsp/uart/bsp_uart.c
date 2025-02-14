#include "bsp_uart.h"
#include "delay.h"

#include "usart.h"
#include "dma.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_uart"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

bool sbFrameRxOver   = false;
bool sbFrameTxOver   = true;
u16  su16RxFrameSize = 0;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

//
// modbus-rtu over rs485
//

void HAL_UART_IdleCpltCallback(UART_HandleTypeDef* huart)
{
    extern DMA_HandleTypeDef MODBUS_UART_RXDMA_BASE;

    if (huart == MODBUS_UART_BASE)
    {
        if (__HAL_UART_GET_FLAG(huart, UART_FLAG_IDLE))
        {
            __HAL_UART_CLEAR_IDLEFLAG(huart);

            HAL_UART_DMAStop(huart);

            extern bool sbFrameRxOver;
            extern u16  su16RxFrameSize;

            sbFrameRxOver   = true;
            su16RxFrameSize = 256 - __HAL_DMA_GET_COUNTER(&MODBUS_UART_RXDMA_BASE);

            // 禁用空闲中断
            __HAL_UART_DISABLE_IT(MODBUS_UART_BASE, UART_IT_IDLE);
        }
    }
}

void HAL_UART_TxCpltCallback(UART_HandleTypeDef* huart)
{
    if (huart == MODBUS_UART_BASE)
    {
        sbFrameTxOver = true;

        // 禁用发送完成中断
        __HAL_UART_DISABLE_IT(huart, UART_IT_TC);
    }
}

void ModbusStartTx(u8* pu8Data, u16 u16Len)
{
    sbFrameTxOver = false;

    // 发送完成中断
    __HAL_UART_ENABLE_IT(MODBUS_UART_BASE, UART_IT_TC);

    HAL_UART_Transmit_DMA(MODBUS_UART_BASE, pu8Data, u16Len);
}

void ModbusStartRx(u8* pu8Buff, u16 u16MaxLen)
{
    sbFrameRxOver   = false;
    su16RxFrameSize = 0;

    // 空闲中断断帧
    __HAL_UART_ENABLE_IT(MODBUS_UART_BASE, UART_IT_IDLE);

    HAL_UART_Receive_DMA(MODBUS_UART_BASE, pu8Buff, u16MaxLen);
}

u16 ModbusGetRxLen(void)
{
    return su16RxFrameSize;
}

void ModbusTxFrame(u8* pu8Data, u16 u16Len)
{
}

void ModbusRxFrame(u8* pu8Buff, u16 u16MaxLen)
{
}

bool ModbusIsTxOver(void)
{
    return sbFrameTxOver;
}

bool ModbusIsRxOver(void)
{
    return sbFrameRxOver;
}

//
// tformat encoder over rs485
//

void TformatTxData(u8* pu8Data, u8 u8Len)
{
}

void TformatRxData(u8* pu8Buff, u8 u8Len)
{
}
