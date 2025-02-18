#include "modbus.h"
#include "storage.h"
#include <string.h>

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG                         "modbus"
#define LOG_LOCAL_LEVEL                       LOG_LEVEL_INFO

#define MB_PDU_READ_COILS_REQ_SIZE            (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_WRITE_COILS_REQ_SIZE           (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_READ_DISC_REQ_SIZE             (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_WRITE_MUL_COILS_REQ_MIN_SIZE   (MODBUS_PDU_SIZE_MIN + 2 + 2 + 1)
#define MB_PDU_READ_INPUT_REQ_SIZE            (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_READ_HOLDING_REQ_SIZE          (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_WRITE_HOLDING_REQ_SIZE         (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_WRITE_MUL_HOLDING_REQ_MIN_SIZE (MODBUS_PDU_SIZE_MIN + 2 + 2 + 1)
#define MB_PDU_READWRITE_HOLDING_REQ_MIN_SIZE (MODBUS_PDU_SIZE_MIN + 2 + 2 + 2 + 2 + 1)
#define MB_PDU_MASK_WRITE_HOLDING_REQ_SIZE    (MODBUS_PDU_SIZE_MIN + 2 + 2 + 2)

#define MB_PDU_READ_COILS_RSP_MIN_SIZE        (MODBUS_PDU_SIZE_MIN + 1)
#define MB_PDU_WRITE_COILS_RSP_SIZE           (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_READ_DISC_RSP_MIN_SIZE         (MODBUS_PDU_SIZE_MIN + 1)
#define MB_PDU_WRITE_MUL_COILS_RSP_SIZE       (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_READ_INPUT_RSP_MIN_SIZE        (MODBUS_PDU_SIZE_MIN + 1)
#define MB_PDU_READ_HOLDING_RSP_MIN_SIZE      (MODBUS_PDU_SIZE_MIN + 1)
#define MB_PDU_WRITE_HOLDING_RSP_SIZE         (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_WRITE_MUL_HOLDING_RSP_SIZE     (MODBUS_PDU_SIZE_MIN + 2 + 2)
#define MB_PDU_READWRITE_HOLDING_RSP_MIN_SIZE (MODBUS_PDU_SIZE_MIN + 1)
#define MB_PDU_MASK_WRITE_HOLDING_RSP_SIZE    (MODBUS_PDU_SIZE_MIN + 2 + 2 + 2)

#define MB_PDU_REPORT_SLAVEID_RSP_MIN_SIZE    (MODBUS_PDU_SIZE_MIN + 1)

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

mb_error_e eMBFuncReportSlaveID(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncReadInputRegister(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncReadHoldingRegister(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncWriteHoldingRegister(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncWriteMultipleHoldingRegister(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncReadWriteMultipleHoldingRegister(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncReadCoils(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncWriteCoil(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncWriteMultipleCoils(u8* u8PduBuff, u16* u16PduSize);
mb_error_e eMBFuncReadDiscreteInputs(u8* u8PduBuff, u16* u16PduSize);

static mb_error_e eMBRegInputCB(uint8_t* pu8Buff, u16 u16Addr, u16 u16Count);
static mb_error_e eMBRegHoldingCB(uint8_t* pu8Buff, u16 u16Addr, u16 u16Count, mb_access_e eAccess);
static mb_error_e eMBRegCoilsCB(uint8_t* pu8Buff, u16 u16Addr, u16 u16Count, mb_access_e eAccess);
static mb_error_e eMBRegDiscreteCB(uint8_t* pu8Buff, u16 u16Addr, u16 u16Count);

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static u8 au8RxFrame[MODBUS_FRAME_MAX_SIZE];

static RO u8 au8CrcHi[] = {
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40};

static RO u8 au8CrcLo[] = {
    0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7, 0x05, 0xC5, 0xC4, 0x04, 0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09, 0x08, 0xC8,
    0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD, 0x1D, 0x1C, 0xDC, 0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3, 0x11, 0xD1, 0xD0, 0x10,
    0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32, 0x36, 0xF6, 0xF7, 0x37, 0xF5, 0x35, 0x34, 0xF4, 0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A, 0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38,
    0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE, 0x2E, 0x2F, 0xEF, 0x2D, 0xED, 0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26, 0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0,
    0xA0, 0x60, 0x61, 0xA1, 0x63, 0xA3, 0xA2, 0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4, 0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F, 0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68,
    0x78, 0xB8, 0xB9, 0x79, 0xBB, 0x7B, 0x7A, 0xBA, 0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5, 0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0,
    0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C, 0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98,
    0x88, 0x48, 0x49, 0x89, 0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C, 0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80, 0x40};

static RO mb_handler_t aFuncHandlers[] = {
    {MODBUS_FUNC_REPORT_SLAVEID,               eMBFuncReportSlaveID                   },
    // {MODBUS_FUNC_READ_INPUT_REGISTER,          eMBFuncReadInputRegister               },
    {MODBUS_FUNC_READ_HOLDING_REGISTER,        eMBFuncReadHoldingRegister             },
    {MODBUS_FUNC_WRITE_MULTIPLE_REGISTERS,     eMBFuncWriteMultipleHoldingRegister    },
    {MODBUS_FUNC_WRITE_REGISTER,               eMBFuncWriteHoldingRegister            },
    {MODBUS_FUNC_READWRITE_MULTIPLE_REGISTERS, eMBFuncReadWriteMultipleHoldingRegister},
    // {MODBUS_FUNC_READ_COILS,                   eMBFuncReadCoils                       },
    // {MODBUS_FUNC_WRITE_SINGLE_COIL,            eMBFuncWriteCoil                       },
    // {MODBUS_FUNC_WRITE_MULTIPLE_COILS,         eMBFuncWriteMultipleCoils              },
    // {MODBUS_FUNC_READ_DISCRETE_INPUTS,         eMBFuncReadDiscreteInputs              },
};

#ifdef MODBUS_FUNC_REPORT_SLAVEID
static u8  sau8SlaveIdBuff[MODBUS_SLAVEID_BUF_SZIE] = {0};
static u16 su16SlaveIdLen                           = 0;
#endif

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

u16 ModbusCrc16(u8* pu8Data, u16 u16Len)
{
#if CONFIG_MODBUS_HWCRC_SW

    return Crc16_ModbusRtu(pu8Data, u16Len);

#else

    u8 u8CrcHi = 0xFF;
    u8 u8CrcLo = 0xFF;
    u8 u8Index;

    while (u16Len--)
    {
        u8Index = u8CrcLo ^ *(pu8Data++);
        u8CrcLo = (u8)(u8CrcHi ^ au8CrcHi[u8Index]);
        u8CrcHi = au8CrcLo[u8Index];
    }

    return (u16)(u8CrcHi << 8 | u8CrcLo);

#endif
}

void Rs485SetRxDir()
{
    PinSetLvl(RS485_RTS_O, B_OFF);
}

void Rs485SetTxDir()
{
    PinSetLvl(RS485_RTS_O, B_ON);
}

void ModbusCreat(mbslave_t* pModbusSlave)
{
    pModbusSlave->eFSM = MODBUS_STATE_RX_START;

    pModbusSlave->u32DirSwTick = 0;

    pModbusSlave->pu8BuffAddr = au8RxFrame;
    pModbusSlave->u16BuffSize = ARRAY_SIZE(au8RxFrame);
}

void ModbusInit(mbslave_t* pModbusSlave)
{
    pModbusSlave->u8SlaveAddr = 1; // D.u16MbSlvId;
    ModbusSetSlaveID(pModbusSlave, 0xA1, true, "uyk", 3);
}

void ModbusCycle(mbslave_t* pModbusSlave)
{
    switch (pModbusSlave->eFSM)
    {
        case MODBUS_STATE_TX_START:
        {
            if (DelayNonBlock100ns(pModbusSlave->u32DirSwTick, 100) == true)  // 10us
            {
                ModbusStartTx(pModbusSlave->pu8BuffAddr, pModbusSlave->u16FrameSize);
                pModbusSlave->eFSM = MODBUS_STATE_TX_BUSY;
            }

            break;
        }

        case MODBUS_STATE_TX_BUSY:
        {
            ModbusTxFrame(pModbusSlave->pu8BuffAddr, pModbusSlave->u16FrameSize);

            // 发送完成和发送超时检测
            if (ModbusIsTxOver() == true || DelayNonBlockMs(pModbusSlave->u32DirSwTick, 5000) == true)
            {
                Rs485SetRxDir();
                pModbusSlave->u32DirSwTick = GetTick100ns();  // wait 40us for rs485 dir-pin's steady

                pModbusSlave->eFSM = MODBUS_STATE_RX_START;
            }

            break;
        }

        case MODBUS_STATE_RX_START:
        {
            if (DelayNonBlock100ns(pModbusSlave->u32DirSwTick, 100) == true)  // 10us
            {
                ModbusStartRx(pModbusSlave->pu8BuffAddr, pModbusSlave->u16BuffSize);
                pModbusSlave->eFSM = MODBUS_STATE_RX_BUSY;
            }

            break;
        }

        case MODBUS_STATE_RX_BUSY:
        {
            ModbusRxFrame(pModbusSlave->pu8BuffAddr, pModbusSlave->u16BuffSize);

            if (ModbusIsRxOver() == true)
            {
                pModbusSlave->u16FrameSize = ModbusGetRxLen();

                if ((pModbusSlave->u16FrameSize >= MODBUS_FRAME_MIN_SIZE) && (ModbusCrc16(pModbusSlave->pu8BuffAddr, pModbusSlave->u16FrameSize) == 0))
                {
                    pModbusSlave->u8RcvAddr    = pModbusSlave->pu8BuffAddr[MODBUS_ADDR_OFFSET];
                    pModbusSlave->u16FrameSize = pModbusSlave->u16FrameSize - 1 /* slvid */ - 2 /* crc */;  // PDU size

                    if (pModbusSlave->u8RcvAddr == pModbusSlave->u8SlaveAddr ||
                        pModbusSlave->u8RcvAddr == MODBUS_ADDR_BROADCAST)
                    {
                        pModbusSlave->eFSM = MODBUS_STATE_RX_PROC;
                        break;
                    }
                }

                pModbusSlave->eFSM = MODBUS_STATE_RX_START;
            }

            break;
        }

        case MODBUS_STATE_RX_PROC:
        {
            mb_error_e eError = MODBUS_ERROR_FUNC_NOT_SUPPORT;

            for (u8 u8FuncIndex = 0; u8FuncIndex < ARRAY_SIZE(aFuncHandlers); u8FuncIndex++)
            {
                if (aFuncHandlers[u8FuncIndex].eFuncCode == pModbusSlave->pu8BuffAddr[MODBUS_FUNC_OFFSET])
                {
                    // function code is macthed, call it's handler and get PDU size
                    eError = aFuncHandlers[u8FuncIndex].pfnCallback(&pModbusSlave->pu8BuffAddr[MODBUS_FUNC_OFFSET], &pModbusSlave->u16FrameSize);

                    break;
                }
            }

            if (pModbusSlave->u8RcvAddr != MODBUS_ADDR_BROADCAST)
            {
                u16 u16FrameCrc;

                if (eError != MODBUS_ERROR_NONE)
                {
                    // an exception occured. build an error frame.
                    pModbusSlave->u16FrameSize = 2;  // PDU size
                    pModbusSlave->pu8BuffAddr[MODBUS_FUNC_OFFSET] |= MODBUS_FUNC_ERROR_MASK;
                    pModbusSlave->pu8BuffAddr[MODBUS_DATA_OFFSET] = eError;
                }

                // first byte is slave address
                pModbusSlave->u16FrameSize += 1;

                // calculate crc16
                u16FrameCrc = ModbusCrc16(pModbusSlave->pu8BuffAddr, pModbusSlave->u16FrameSize);

                pModbusSlave->pu8BuffAddr[pModbusSlave->u16FrameSize++] = (u8)(u16FrameCrc & 0xFF);
                pModbusSlave->pu8BuffAddr[pModbusSlave->u16FrameSize++] = (u8)(u16FrameCrc >> 8);

                Rs485SetTxDir();
                pModbusSlave->u32DirSwTick = GetTick100ns();  // wait 10us for rs485 dir-pin's steady

                pModbusSlave->eFSM = MODBUS_STATE_TX_START;
            }
            else
            {
                pModbusSlave->eFSM = MODBUS_STATE_RX_START;
            }

            break;
        }
    }
}

void ModbusIsr(mbslave_t* pModbusSlave)
{
}

//
// function callback
//

#ifdef MODBUS_FUNC_REPORT_SLAVEID

mb_error_e eMBFuncReportSlaveID(u8* u8PduBuff, u16* u16PduSize)
{
    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];

    pu8PduData[0] = su16SlaveIdLen;                                             // 字节数
    memcpy((void*)&pu8PduData[1], (void*)&sau8SlaveIdBuff[0], su16SlaveIdLen);  // 从站信息

    *u16PduSize = (u16)(MB_PDU_REPORT_SLAVEID_RSP_MIN_SIZE + su16SlaveIdLen);

    return MODBUS_ERROR_NONE;
}

#endif

//
// input register
//

#ifdef MODBUS_FUNC_READ_INPUT_REGISTER

mb_error_e eMBFuncReadInputRegister(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u16 u16ReadAddress;
    u16 u16ReadQuantity;

    if (*u16PduSize == MB_PDU_READ_INPUT_REQ_SIZE)
    {
        u16ReadAddress  = be16(pu8PduData + 0);
        u16ReadQuantity = be16(pu8PduData + 2);

        if (INCLOSE(u16ReadQuantity, 1, 0x7D))
        {
            pu8PduData[0] = (u8)(u16ReadQuantity * 2);

            eStatus = eMBRegInputCB(&pu8PduData[1], u16ReadAddress, u16ReadQuantity);

            if (eStatus == MODBUS_ERROR_NONE)
            {
                *u16PduSize = MB_PDU_READ_INPUT_RSP_MIN_SIZE + u16ReadQuantity * 2;
            }
        }
        else
        {
            eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
        }
    }
    else
    {
        eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

//
// holding register
//

#ifdef MODBUS_FUNC_READ_HOLDING_REGISTER

mb_error_e eMBFuncReadHoldingRegister(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];

    u16 u16ReadAddress;
    u16 u16ReadQuantity;

    if (*u16PduSize == MB_PDU_READ_HOLDING_REQ_SIZE)
    {
        u16ReadAddress  = be16(pu8PduData + 0);
        u16ReadQuantity = be16(pu8PduData + 2);

        if (INCLOSE(u16ReadQuantity, 1, 0x7D))
        {
            pu8PduData[0] = (u8)(u16ReadQuantity * 2);

            eStatus = eMBRegHoldingCB(&pu8PduData[1], u16ReadAddress, u16ReadQuantity, MODBUS_REG_READ);

            if (eStatus == MODBUS_ERROR_NONE)
            {
                *u16PduSize = MB_PDU_READ_HOLDING_RSP_MIN_SIZE + u16ReadQuantity * 2;
            }
        }
        else
        {
            eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
        }
    }
    else
    {
        eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

#ifdef MODBUS_FUNC_WRITE_REGISTER

mb_error_e eMBFuncWriteHoldingRegister(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];
    u16 u16WriteAddress;

    if (*u16PduSize == MB_PDU_WRITE_HOLDING_REQ_SIZE)
    {
        u16WriteAddress = be16(pu8PduData + 0);

        eStatus = eMBRegHoldingCB(&pu8PduData[2], u16WriteAddress, 1, MODBUS_REG_WRITE);

        *u16PduSize = MB_PDU_WRITE_HOLDING_RSP_SIZE;
    }
    else
    {
        eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

#ifdef MODBUS_FUNC_WRITE_MULTIPLE_REGISTERS

mb_error_e eMBFuncWriteMultipleHoldingRegister(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];

    u16 u16WriteAddress;
    u16 u16WriteQuantity;
    u8  u8WriteByteQuantity;

    if (*u16PduSize >= MB_PDU_WRITE_MUL_HOLDING_REQ_MIN_SIZE)
    {
        u16WriteAddress     = be16(pu8PduData + 0);
        u16WriteQuantity    = be16(pu8PduData + 2);
        u8WriteByteQuantity = *(pu8PduData + 4);

        if (INCLOSE(u16WriteQuantity, 1, 0x78) && (u8WriteByteQuantity == (u8)(u16WriteQuantity * 2)))
        {
            eStatus = eMBRegHoldingCB(&pu8PduData[5], u16WriteAddress, u16WriteQuantity, MODBUS_REG_WRITE);

            if (eStatus == MODBUS_ERROR_NONE)
            {
                *u16PduSize = MB_PDU_WRITE_MUL_HOLDING_RSP_SIZE;
            }
        }
        else
        {
            eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
        }
    }
    else
    {
        eStatus = MODBUS_ERROR_RXPDU_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

#ifdef MODBUS_FUNC_READWRITE_MULTIPLE_REGISTERS

mb_error_e eMBFuncReadWriteMultipleHoldingRegister(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];

    u16 u16ReadAddress;
    u16 u16ReadQuantity;
    u16 u16WriteAddress;
    u16 u16WriteQuantity;
    u8  u8WriteByteQuantity;

    if (*u16PduSize >= MB_PDU_READWRITE_HOLDING_REQ_MIN_SIZE)
    {
        u16ReadAddress      = be16(pu8PduData + 0);
        u16ReadQuantity     = be16(pu8PduData + 2);
        u16WriteAddress     = be16(pu8PduData + 4);
        u16WriteQuantity    = be16(pu8PduData + 6);
        u8WriteByteQuantity = *(pu8PduData + 8);

        if (INCLOSE(u16ReadQuantity, 1, 0x7D) && INCLOSE(u16WriteQuantity, 1, 0x79) && (u8WriteByteQuantity == (2 * u16WriteQuantity)))
        {
            eStatus = eMBRegHoldingCB(&pu8PduData[9], u16WriteAddress, u16WriteQuantity, MODBUS_REG_WRITE);

            if (eStatus == MODBUS_ERROR_NONE)
            {
                pu8PduData[0] = (u8)(u16ReadQuantity * 2);

                eStatus = eMBRegHoldingCB(&pu8PduData[1], u16ReadAddress, u16ReadQuantity, MODBUS_REG_READ);

                if (eStatus == MODBUS_ERROR_NONE)
                {
                    *u16PduSize = MB_PDU_READWRITE_HOLDING_RSP_MIN_SIZE + 2 * u16ReadQuantity;
                }
            }
        }
        else
        {
            eStatus = MODBUS_ERROR_RXPDU_ILLEGAL_LENGTH;
        }
    }

    return eStatus;
}

#endif

//
// coils
//

#ifdef MODBUS_FUNC_READ_COILS

mb_error_e eMBFuncReadCoils(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];

    u16 u16ReadAddress;
    u16 u16ReadQuantity;
    u8  u8WriteByteQuantity;

    if (*u16PduSize == MB_PDU_READ_COILS_REQ_SIZE)
    {
        u16ReadAddress  = be16(pu8PduData + 0);
        u16ReadQuantity = be16(pu8PduData + 2);

        if (INCLOSE(u16ReadQuantity, 1, 2000))
        {
            u8WriteByteQuantity = (u8)((u16ReadQuantity / 8) + (u16ReadQuantity & 0x0007 ? 1 : 0));

            pu8PduData[0] = u8WriteByteQuantity;

            eStatus = eMBRegCoilsCB(&pu8PduData[1], u16ReadAddress, u16ReadQuantity, MODBUS_REG_READ);

            if (eStatus == MODBUS_ERROR_NONE)
            {
                *u16PduSize = MB_PDU_READ_COILS_RSP_MIN_SIZE + u8WriteByteQuantity;
            }
        }
        else
        {
            eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
        }
    }
    else
    {
        eStatus = MODBUS_ERROR_RXPDU_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

#ifdef MODBUS_FUNC_WRITE_SINGLE_COIL

mb_error_e eMBFuncWriteCoil(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];

    u16 u16WriteAddress;
    u16 u16WriteValue;

    if (*u16PduSize == MB_PDU_WRITE_COILS_REQ_SIZE)
    {
        u16WriteAddress = be16(pu8PduData + 0);
        u16WriteValue   = be16(pu8PduData + 2);

        if (u16WriteValue == 0xFF00)
        {
            u16WriteValue = 0;
        }
        else if (u16WriteValue == 0xFFFF)
        {
            u16WriteValue = 1;
        }
        else
        {
            eStatus = MODBUS_ERROR_DATA_ILLEGAL_VALUE;
        }

        if (eStatus == MODBUS_ERROR_NONE)
        {
            eStatus = eMBRegCoilsCB(&u16WriteValue, u16WriteAddress, 1, MODBUS_REG_WRITE);

            if (eStatus == MODBUS_ERROR_NONE)
            {
                *u16PduSize = MB_PDU_WRITE_COILS_RSP_SIZE;
            }
        }
    }
    else
    {
        eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

#ifdef MODBUS_FUNC_WRITE_MULTIPLE_COILS

mb_error_e eMBFuncWriteMultipleCoils(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];

    u16 u16WriteAddress;
    u16 u16WriteQuantity;
    u8  u8WriteByteQuantity;
    u8  u8WriteByteQuantityVerify;

    if (*u16PduSize >= MB_PDU_WRITE_MUL_COILS_REQ_MIN_SIZE)
    {
        u16WriteAddress     = be16(pu8PduData + 0);
        u16WriteQuantity    = be16(pu8PduData + 2);
        u8WriteByteQuantity = *(pu8PduData + 4);

        u8WriteByteQuantityVerify = (u8)((u16WriteQuantity / 8) + (u16WriteQuantity & 0x0007 ? 1 : 0));

        if (INCLOSE(u16WriteQuantity, 1, 1968) && (u8WriteByteQuantityVerify == u8WriteByteQuantity))
        {
            eStatus = eMBRegCoilsCB(&pu8PduData[5], u16WriteAddress, u16WriteQuantity, MODBUS_REG_WRITE);

            if (eStatus == MODBUS_ERROR_NONE)
            {
                *u16PduSize = MB_PDU_WRITE_MUL_COILS_RSP_SIZE;
            }
        }
        else
        {
            eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
        }
    }
    else
    {
        eStatus = MODBUS_ERROR_RXPDU_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

//
// discrete inputs
//

#ifdef MODBUS_FUNC_READ_DISCRETE_INPUTS

mb_error_e eMBFuncReadDiscreteInputs(u8* u8PduBuff, u16* u16PduSize)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    u8* pu8PduData = &u8PduBuff[MODBUS_PDU_DATA_OFFSET];

    u16 u16ReadAddress;
    u16 u16ReadQuantity;
    u8  u8ByteCount;

    if (*u16PduSize == MB_PDU_READ_DISC_REQ_SIZE)
    {
        u16ReadAddress  = be16(pu8PduData + 0);
        u16ReadQuantity = be16(pu8PduData + 2);

        if (INCLOSE(u16ReadQuantity, 1, 2000))
        {
            u8ByteCount = (u8)((u16ReadQuantity / 8) + (u16ReadQuantity & 0x0007 ? 1 : 0));

            pu8PduData[0] = u8ByteCount;

            eStatus = eMBRegDiscreteCB(&pu8PduData[1], u16ReadAddress, u16ReadQuantity);

            if (eStatus == MODBUS_ERROR_NONE)
            {
                *u16PduSize = MB_PDU_READ_DISC_RSP_MIN_SIZE + u8ByteCount;
            }
        }
        else
        {
            eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
        }
    }
    else
    {
        eStatus = MODBUS_ERROR_RXPDU_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

//
// slave id
//

#ifdef MODBUS_FUNC_REPORT_SLAVEID

mb_error_e ModbusSetSlaveID(mbslave_t* pModbusSlave, u8 u8SlaveID, bool bIsRunning, RO u8* pu8Additional, u16 u16AdditionalLen)
{
    mb_error_e eStatus = MODBUS_ERROR_NONE;

    /* the first byte and second byte in the buffer is reserved for
     * the parameter u8SlaveID and the running flag. The rest of
     * the buffer is available for additional data. */
    if ((u16AdditionalLen + 2) < MODBUS_SLAVEID_BUF_SZIE)
    {
        su16SlaveIdLen     = 2;
        sau8SlaveIdBuff[0] = u8SlaveID;
        sau8SlaveIdBuff[1] = bIsRunning ? 0xFF : 0x00;

        if (u16AdditionalLen > 0)
        {
            memcpy((void*)&sau8SlaveIdBuff[su16SlaveIdLen], (void*)pu8Additional, u16AdditionalLen);
            su16SlaveIdLen += u16AdditionalLen;
        }
    }
    else
    {
        eStatus = MODBUS_ERROR_DATA_ILLEGAL_LENGTH;
    }

    return eStatus;
}

#endif

//
// user callback
//

static mb_error_e eMBRegInputCB(uint8_t* pu8Buff, u16 u16Addr, u16 u16Count)
{
    return MODBUS_ERROR_DATA_ILLEGAL_ADDRESS;
}

static mb_error_e eMBRegHoldingCB(uint8_t* pu8Buff, u16 u16Addr, u16 u16Count, mb_access_e eAccess)
{
    mb_error_e eStatus;

    if (eAccess == MODBUS_REG_READ)
    {
        eStatus = (mb_error_e)ParaRead(u16Addr, (u16*)pu8Buff, u16Count);
    }
    else
    {
        eStatus = (mb_error_e)ParaWrite(u16Addr, (u16*)pu8Buff, u16Count);
    }

    return eStatus;
}

static mb_error_e eMBRegCoilsCB(uint8_t* pu8Buff, u16 u16Addr, u16 u16Count, mb_access_e eAccess)
{
    return MODBUS_ERROR_DATA_ILLEGAL_ADDRESS;
}

static mb_error_e eMBRegDiscreteCB(uint8_t* pu8Buff, u16 u16Addr, u16 u16Count)
{
    return MODBUS_ERROR_DATA_ILLEGAL_ADDRESS;
}
