#include "candrv.h"

void CAN_Open(CAN_HandleTypeDef* hcan)
{
    /**
     * CAN1: RXFIFO0
     * CAN2: RXFIFO1
     */

    CAN_FilterTypeDef sFilterConfig = {
        .FilterIdHigh         = 0x0000,
        .FilterIdLow          = 0x0000,
        .FilterMaskIdHigh     = 0x0000,
        .FilterMaskIdLow      = 0x0000,
        .FilterMode           = CAN_FILTERMODE_IDMASK,
        .FilterScale          = CAN_FILTERSCALE_32BIT,
        .FilterActivation     = CAN_FILTER_ENABLE,
        .SlaveStartFilterBank = 14,
    };

    if (hcan->Instance == CAN1)
    {
        sFilterConfig.FilterBank           = 0;
        sFilterConfig.FilterFIFOAssignment = CAN_FILTER_FIFO0;
    }
#ifdef CAN2
    else if (hcan->Instance == CAN2)
    {
        sFilterConfig.FilterBank           = 14;
        sFilterConfig.FilterFIFOAssignment = CAN_FILTER_FIFO1;
    }
#endif

    // CAN_SetMode(hcan, CAN_MODE_NORMAL);
    CAN_SetBtr(hcan, CAN_BTR_250K);

    // 0 < CAN1 FilterBank < SlaveStartFilterBank
    // SlaveStartFilterBank <= CAN2 FilterBank < 27
    HAL_CAN_ConfigFilter(hcan, &sFilterConfig);

    if (hcan->Instance == CAN1)
    {
        HAL_CAN_ActivateNotification(hcan, CAN_IT_RX_FIFO0_MSG_PENDING);
    }
#ifdef CAN2
    else if (hcan->Instance == CAN2)
    {
        HAL_CAN_ActivateNotification(hcan, CAN_IT_RX_FIFO1_MSG_PENDING);
    }
#endif

    HAL_CAN_Start(hcan);
}

void CAN_Close(CAN_HandleTypeDef* hcan)
{
    HAL_CAN_Stop(hcan);
}

/**
 * @brief set CAN bitrate
 */
void CAN_SetBtr(CAN_HandleTypeDef* hcan, uint32_t btr)
{
    HAL_CAN_Stop(hcan);

    hcan->Instance->MCR |= CAN_MCR_INRQ;
    hcan->Instance->BTR &= ~0x3FFFFFFF;
    hcan->Instance->BTR |= btr & 0x3FFFFFFF;
    hcan->Instance->MCR &= ~CAN_MCR_INRQ;

    if (hcan->ErrorCode & HAL_CAN_ERROR_NOT_STARTED)
    {
        return;  // no start
    }

    HAL_CAN_Start(hcan);
}

void CAN_SetMode(CAN_HandleTypeDef* hcan, uint32_t mode)
{
    HAL_CAN_Stop(hcan);

    hcan->Instance->MCR |= CAN_MCR_INRQ;
    hcan->Instance->BTR &= ~0xC0000000;
    hcan->Instance->BTR |= mode & 0xC0000000;
    hcan->Instance->MCR &= ~CAN_MCR_INRQ;

    if (hcan->ErrorCode & HAL_CAN_ERROR_NOT_STARTED)
    {
        return;  // no start
    }

    HAL_CAN_Start(hcan);
}

bool CAN_TxMsg(CAN_HandleTypeDef* hcan, can_msg_t* msg)
{
    CAN_TxHeaderTypeDef hdr;
    uint32_t            mb;

    hdr.DLC = msg->length;
    hdr.RTR = (msg->flags.rtr == 0) ? CAN_RTR_DATA : CAN_RTR_REMOTE;

    if (msg->flags.extended == 0)
    {
        hdr.IDE   = CAN_ID_STD;
        hdr.StdId = msg->id;
    }
    else
    {
        hdr.IDE   = CAN_ID_EXT;
        hdr.ExtId = msg->id;
    }

    hdr.TransmitGlobalTime = DISABLE;

    if (HAL_CAN_AddTxMessage(hcan, &hdr, msg->data, &mb) != HAL_OK)
    {
        return false;
    }

    return true;
}

bool CAN_RxMsg(CAN_HandleTypeDef* hcan, uint32_t fifo, can_msg_t* msg)
{
    CAN_RxHeaderTypeDef hdr;

    if (HAL_CAN_GetRxMessage(hcan, fifo, &hdr, msg->data) != HAL_OK)
    {
        return false;
    }

    msg->timestamp = HAL_GetTick();

    if (hdr.IDE == CAN_ID_STD)
    {
        msg->id             = hdr.StdId;
        msg->flags.extended = 0;
    }
    else  // if (hdr.IDE == CAN_ID_EXT)
    {
        msg->id             = hdr.ExtId;
        msg->flags.extended = 1;
    }

    msg->flags.rtr = (hdr.RTR == CAN_RTR_DATA) ? 0 : 1;
    msg->length    = hdr.DLC;

    return true;
}

void HAL_CAN_RxFifo0MsgPendingCallback(CAN_HandleTypeDef* hcan)
{
    can_msg_t msg;

    if (CAN_RxMsg(hcan, CAN_RX_FIFO0, &msg) == false)
    {
        return;
    }

		 PacketEncode(&msg);
  //  Serial_LogCanMsg((hcan->Instance == CAN1) ? 1 : 2, CAN_DIR_RX, &msg);
}

#ifdef CAN2

void HAL_CAN_RxFifo1MsgPendingCallback(CAN_HandleTypeDef* hcan)
{
    can_msg_t msg;

    if (CAN_RxMsg(hcan, CAN_RX_FIFO1, &msg) == false)
    {
        return;
    }

		PacketEncode(&msg);
    // Serial_LogCanMsg((hcan->Instance == CAN1) ? 1 : 2, CAN_DIR_RX, &msg);
}

#endif
