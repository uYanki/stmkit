#include "bsp_can.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_can"
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

bool CanTxMsg(u32 u32Id, u8* pu8Data, u8 u8Len)
{
    u8                  u8Ind;
    u8                  u8TxMailBox;
    can_tx_message_type sTxMsg;

    if (CHKBIT(u32Id, CAN_ID_Pos) == 0)  // CAN_ID_STD
    {
        sTxMsg.id_type     = CAN_ID_STANDARD;
        sTxMsg.standard_id = u32Id & 0x7FF;
        sTxMsg.extended_id = 0;
    }
    else  // CAN_FF_EXT
    {
        sTxMsg.id_type     = CAN_ID_EXTENDED;
        sTxMsg.standard_id = 0;
        sTxMsg.extended_id = u32Id & 0x1FFFFFFF;
    }

    if (CHKBIT(u32Id, CAN_FF_Pos) == 0)  // CAN_FF_DATA
    {
        sTxMsg.frame_type = CAN_TFT_DATA;
        sTxMsg.dlc        = MIN(u8Len, 8);

        for (u8Ind = 0; u8Ind < sTxMsg.dlc; ++u8Ind)
        {
            sTxMsg.data[u8Ind] = pu8Data[u8Ind];
        }
    }
    else  // CAN_FF_RTR
    {
        sTxMsg.frame_type = CAN_TFT_REMOTE;
        sTxMsg.dlc        = 0;
    }

    u8TxMailBox = can_message_transmit(CAN_BASE, &sTxMsg);

    if (u8TxMailBox == CAN_TX_STATUS_NO_EMPTY)
    {
        return false;
    }

    // while (can_transmit_status_get(CAN_BASE, (can_tx_mailbox_num_type) u8TxMailBox) != CAN_TX_STATUS_SUCCESSFUL);

    return true;
}

bool CanRxMsg(u32* pu32Id, u8* pu8Data, u8* pu8Len)
{
    return false;
}
