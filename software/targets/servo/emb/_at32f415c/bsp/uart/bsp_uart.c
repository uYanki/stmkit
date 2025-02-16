#include "bsp_uart.h"
#include "delay.h"

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

void ModbusStartTx(u8* pu8Data, u16 u16Len)
{
    sbFrameTxOver = false;

    dma_channel_enable(MODBUS_TXDMA_CH, FALSE);

    // 串口数据源
    wk_dma_channel_config(MODBUS_TXDMA_CH,
                          (uint32_t)&MODBUS_UART_BASE->dt,
                          (uint32_t)pu8Data,
                          u16Len);

    dma_channel_enable(MODBUS_TXDMA_CH, TRUE);

    // DMA发送完成中断
    dma_interrupt_enable(MODBUS_TXDMA_CH, DMA_FDT_INT, TRUE);
}

void ModbusStartRx(u8* pu8Buff, u16 u16MaxLen)
{
    sbFrameRxOver   = false;
    su16RxFrameSize = 0;

    dma_channel_enable(MODBUS_RXDMA_CH, FALSE);

    // 串口数据源
    wk_dma_channel_config(MODBUS_RXDMA_CH,
                          (uint32_t)&MODBUS_UART_BASE->dt,
                          (uint32_t)pu8Buff,
                          u16MaxLen);

    dma_channel_enable(MODBUS_RXDMA_CH, TRUE);

    // 串口空闲中断
    usart_interrupt_enable(MODBUS_UART_BASE, USART_IDLE_INT, TRUE);
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
