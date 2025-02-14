#include "abs_tformat.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "tformat"
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

static uint8_t TFormatCalcCrc(uint8_t* pu8Data, uint8_t u8Len)
{
    // 异或校验

#if 1

    uint8_t u8Ind;
    uint8_t u8Crc;

    u8Crc = pu8Data[0];

    for (u8Ind = 1; u8Ind < u8Len; ++u8Ind)
    {
        u8Crc ^= pu8Data[u8Ind];
    }

#else

    uint8_t u8Bit;
    uint8_t u8Crc = 0;

    while (u8Len--)
    {
        u8Crc ^= *pu8Data++;

        for (u8Bit = 0; u8Bit < 8; u8Bit++)
        {
            if (u8Crc & 0x01)
            {
                u8Crc = (u8Crc >> 1) ^ 0x80;
            }
            else
            {
                u8Crc >>= 1;
            }
        }
    }

#endif

    return u8Crc;
}

void TFormatSetupCommand(tformat_t* pTformat, uint8_t cf)
{
    pTformat->txData[0] = cf;
}

void TFormatSetupCommandReadEEPROM(tformat_t* pTformat, uint8_t eepromAddr)
{
    pTformat->txData[0] = TFORMAT_CF_IDD;
    pTformat->txData[1] = eepromAddr;
    pTformat->txData[2] = TFormatCalcCrc(pTformat->txData, TFORMAT_TX_CRC_BYTES_IDD);
}

void TFormatSetupCommandWriteEEPROM(tformat_t* pTformat, uint8_t eepromAddr, uint8_t eepromData)
{
    pTformat->txData[0] = TFORMAT_CF_ID6;
    pTformat->txData[1] = eepromAddr;
    pTformat->txData[2] = eepromData;
    pTformat->txData[3] = TFormatCalcCrc(pTformat->txData, TFORMAT_TX_CRC_BYTES_ID6);
}

bool TFormatStartOperation(tformat_t* pTformat)
{
    pTformat->error = TFORMAT_ERROR_NONE;

    switch (pTformat->controlField)
    {
        case TFORMAT_CF_ID0:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_ID0;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_ID0;
            break;
        }
        case TFORMAT_CF_ID1:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_ID1;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_ID1;
            break;
        }
        case TFORMAT_CF_ID7:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_ID7;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_ID7;
            break;
        }
        case TFORMAT_CF_ID8:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_ID8;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_ID8;
            break;
        }
        case TFORMAT_CF_IDC:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_IDC;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_IDC;
            break;
        }
        case TFORMAT_CF_ID2:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_ID2;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_ID2;
            break;
        }
        case TFORMAT_CF_ID3:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_ID3;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_ID3;
            break;
        }
        case TFORMAT_CF_ID6:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_ID6;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_ID6;
            break;
        }
        case TFORMAT_CF_IDD:
        {
            pTformat->txLen    = TFORMAT_TX_FIELDS_IDD;
            pTformat->rxTgtLen = TFORMAT_RX_FIELDS_IDD;
            break;
        }
        default:
        {
            return false;
        }
    }

    TformatTxData(pTformat->txData, pTformat->txLen);

    pTformat->error = TFORMAT_ERROR_NONE;
    pTformat->rxFsm = TFORMAT_STATE_RX_READY;

    return true;
}

void TformatReceiveData(tformat_t* pTformat)
{
    pTformat->rxFsm = TFORMAT_STATE_RX_RUNING;

    TformatRxData(pTformat->rxData, pTformat->rxTgtLen);
}

void TformatDealRxData(tformat_t* pTformat, uint8_t rxLen)
{
    if (pTformat->rxFsm != TFORMAT_STATE_RX_RUNING)
    {
        return;
    }

    pTformat->rxFsm = TFORMAT_STATE_RX_COMPLETE;

    //
    // check rx status
    //

    pTformat->rxLen = rxLen;

    if (pTformat->rxLen == 0)
    {
        pTformat->error = TFORMAT_ERROR_RX_TIMEOUT;
        return;
    }
    else if (pTformat->rxLen != pTformat->rxTgtLen)
    {
        pTformat->error = TFORMAT_ERROR_RX_SIZE_INCORRECT;
        return;
    }

    //
    // check cf
    //

    if (pTformat->controlField != pTformat->rxData[0])
    {
        pTformat->error = TFORMAT_ERROR_CF_NOT_MATCH;
        return;
    }

    //
    // check crc
    //

    pTformat->crcField = pTformat->rxData[pTformat->rxTgtLen - 1];
    pTformat->crcCheck = TFormatCalcCrc(pTformat->rxData, pTformat->rxTgtLen - 1);

    if (pTformat->crcField != pTformat->crcCheck)
    {
        pTformat->error = TFORMAT_ERROR_CRC_CHECK_FAIL;
        return;
    }

    //
    // deal data
    //

    switch (pTformat->controlField)
    {
        case TFORMAT_CF_ID0:
        case TFORMAT_CF_ID7:
        case TFORMAT_CF_ID8:
        case TFORMAT_CF_IDC:
        {
            pTformat->statusField = pTformat->rxData[1];
            pTformat->dataField0  = pTformat->rxData[2];
            pTformat->dataField1  = pTformat->rxData[3];
            pTformat->dataField2  = pTformat->rxData[4];

            pTformat->pos = (pTformat->dataField2 << 16) | (pTformat->dataField1 << 8) | (pTformat->dataField0);

            break;
        }
        case TFORMAT_CF_ID1:
        {
            pTformat->statusField = pTformat->rxData[1];
            pTformat->dataField0  = pTformat->rxData[2];
            pTformat->dataField1  = pTformat->rxData[3];
            pTformat->dataField2  = pTformat->rxData[4];

            pTformat->turns = (pTformat->dataField2 << 16) | (pTformat->dataField1 << 8) | (pTformat->dataField0);

            break;
        }
        case TFORMAT_CF_ID2:
        {
            pTformat->id = pTformat->rxData[1];

            break;
        }
        case TFORMAT_CF_ID3:
        {
            pTformat->statusField = pTformat->rxData[1];
            pTformat->dataField0  = pTformat->rxData[2];
            pTformat->dataField1  = pTformat->rxData[3];
            pTformat->dataField2  = pTformat->rxData[4];
            pTformat->dataField3  = pTformat->rxData[5];
            pTformat->dataField4  = pTformat->rxData[6];
            pTformat->dataField5  = pTformat->rxData[7];
            pTformat->dataField6  = pTformat->rxData[8];
            pTformat->dataField7  = pTformat->rxData[9];

            pTformat->pos   = (pTformat->dataField2 << 16) | (pTformat->dataField1 << 8) | (pTformat->dataField0);
            pTformat->id    = pTformat->dataField3;
            pTformat->turns = (pTformat->dataField6 << 16) | (pTformat->dataField5 << 8) | (pTformat->dataField4);
            pTformat->alm   = pTformat->dataField7;

            break;
        }
        case TFORMAT_CF_ID6:
        case TFORMAT_CF_IDD:
        {
            pTformat->eepromAddressField = pTformat->rxData[1];
            pTformat->eepromDataField    = pTformat->rxData[2];

            break;
        }
    }

    pTformat->error = TFORMAT_ERROR_NONE;
}

bool TformatCheckOperationComplete(tformat_t* pTformat, tformat_error_e* error)
{
    if (error != nullptr)
    {
        *error = pTformat->error;
    }

    return pTformat->rxFsm == TFORMAT_STATE_RX_COMPLETE;
}
