#include "serdrv.h"

#include <stdio.h>

/**
 * @brief display can frame
 *
 * @example
 *             DIR PORT ID(STD/EXT) DLC DATA
 *   - RX, STD: > CAN1      0x123 [8] 55 66 77 88 99 AA BB CC
 *   - TX, EXT: < CAN1 0x12345678 [8] 55 66 77 88 99 AA BB CC
 *
 */
bool Serial_LogCanMsg(uint8_t can, can_dir_e dir, can_msg_t* msg)
{
    static char buff[64];  // 静态变量，退出函数不会被释放，DMA上传的数据才正确
    uint8_t     len = 0;

    uint8_t i = 0;

#if CONFIG_UART_TXDMA_SW & 0
    HAL_DMA_PollForTransfer(huart1.hdmatx, HAL_DMA_FULL_TRANSFER, 0xFFFF);
#endif

    if (msg->length > 8)
    {
        return false;
    }

    if (dir == CAN_DIR_RX)
    {
        buff[len++] = '>';
    }
    else if (dir == CAN_DIR_TX)
    {
        buff[len++] = '<';
    }
    else
    {
        return false;
    }

    len += sprintf(&buff[len], " CAN%d", can);

    if (msg->flags.extended == 0)
    {
        len += sprintf(&buff[len], "      0x%03X", msg->id & 0x7FF);  // std
    }
    else
    {
        len += sprintf(&buff[len], " 0x%08X", msg->id & 0x1FFFFFFF);  // ext
    }

    len += sprintf(&buff[len], " [%d]", msg->length);

    for (i = 0; i < msg->length; i++)
    {
        len += sprintf(&buff[len], " %02X", msg->data[i]);
    }

    buff[len++] = '\r';
    buff[len++] = '\n';
    buff[len]   = '\0';

#if CONFIG_UART_TXDMA_SW
    if (HAL_UART_Transmit_DMA(&huart1, (uint8_t*)buff, len) != HAL_OK)
#else
    if (HAL_UART_Transmit(&huart1, (uint8_t*)buff, len, 0xFFFF) != HAL_OK)
#endif
    {
        return false;
    }

    return true;
}
