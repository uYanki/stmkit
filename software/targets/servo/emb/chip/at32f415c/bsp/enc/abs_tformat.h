#ifndef __TFORMAT_H__
#define __TFORMAT_H__

#include "typebasic.h"
#include "bsp.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

/**
 * @brief Data ID Code
 * Unique code for each command. Defined in the T-Format specification.
 * IDx = code (4-bits) + parity (1-bit)
 */

/**
 * msb first
 */

// sink code
#define TFORMAT_SINK 0x02u

// id parity + data id code
#define TFORMAT_DID0 (0x00u << 3u)
#define TFORMAT_DID1 (0x11u << 3u)
#define TFORMAT_DID2 (0x12u << 3u)
#define TFORMAT_DID3 (0x03u << 3u)
#define TFORMAT_DID6 (0x06u << 3u)
#define TFORMAT_DIDD (0x1Du << 3u)
#define TFORMAT_DID7 (0x17u << 3u)
#define TFORMAT_DID8 (0x18u << 3u)
#define TFORMAT_DIDC (0x0Cu << 3u)

// sink code + data id code + id parity
#define TFORMAT_CF_ID0 (TFORMAT_DID0 | TFORMAT_SINK)  // CF: parity:code0:sink = 0b0:0000:010 = 0x02 读取单圈
#define TFORMAT_CF_ID1 (TFORMAT_DID1 | TFORMAT_SINK)  // CF: parity:code1:sink = 0b1:0001:010 = 0x8A 读取圈数
#define TFORMAT_CF_ID2 (TFORMAT_DID2 | TFORMAT_SINK)  // CF: parity:code2:sink = 0b1:0010:010 = 0x92 读取编码器编号
#define TFORMAT_CF_ID3 (TFORMAT_DID3 | TFORMAT_SINK)  // CF: parity:code3:sink = 0b0:0011:010 = 0x1A 读取单圈+圈数
#define TFORMAT_CF_ID6 (TFORMAT_DID6 | TFORMAT_SINK)  // CF: parity:code6:sink = 0b0:0110:010 = 0x32 写EEPROM
#define TFORMAT_CF_IDD (TFORMAT_DIDD | TFORMAT_SINK)  // CF: parity:codeD:sink = 0b1:1101:010 = 0xEA 读EEPEOM
#define TFORMAT_CF_ID7 (TFORMAT_DID7 | TFORMAT_SINK)  // CF: parity:code7:sink = 0b1:0111:010 = 0xBA 重置错误
#define TFORMAT_CF_ID8 (TFORMAT_DID8 | TFORMAT_SINK)  // CF: parity:code8:sink = 0b1:1000:010 = 0xC2 重置圈数
#define TFORMAT_CF_IDC (TFORMAT_DIDC | TFORMAT_SINK)  // CF: parity:codeC:sink = 0b0:1100:010 = 0x62 重置圈数和错误

/**
 * @brief Status Field
 */
#define TFORMAT_SF_DD0 0x01u  // information. fixed to '0'
#define TFORMAT_SF_DD1 0x02u  // information. fixed to '0'
#define TFORMAT_SF_DD2 0x04u  // information. fixed to '0'
#define TFORMAT_SF_DD3 0x08u  // information. fixed to '0'
#define TFORMAT_SF_EA0 0x10u  // encoder error. counting error
#define TFORMAT_SF_EA1 0x20u  // encoder error. over speed、counter overflow、over heat、multi turn error、battery alarm or battery error
#define TFORMAT_SF_CA0 0x40u  // communication error. parity error.
#define TFORMAT_SF_CA1 0x80u  // communication error. delomiter error.

/**
 * @brief Encoder Error
 */
#define TFORMAT_ALMC_OS 0x01u  // over speed
#define TFORMAT_ALMC_FS 0x02u  // full absolute status
#define TFORMAT_ALMC_CE 0x04u  // counting error
#define TFORMAT_ALMC_OF 0x08u  // counter overflow
#define TFORMAT_ALMC_OH 0x10u  // over heat
#define TFORMAT_ALMC_ME 0x20u  // multi turn error
#define TFORMAT_ALMC_BE 0x40u  // battery error
#define TFORMAT_ALMC_BA 0x80u  // battery alarm

/**
 * Command fields and expected response fields for each Data ID code.
 * Each field is 10-bits including start (1-bit) and delimiter (1-bit)
 * Abbreviations are from the T-Format specification:
 *
 *      CF:     Control Field
 *      SF:     Status Field
 *      DFx:    Data Field
 *      CRC:    Cyclic-redundancy check Field
 *      ABSx:   Absolute data in 1 revolution
 *      ABMx:   Multi-turn data
 *      ADF:    Address data field
 *      EDF:    EEPROM data field
 *      ENID:   Encoder ID
 *      ALMC:   Encoder error
 *
 * [doc-library-tformat-command-format-start]
 *
 * Transmit packet (request)
 *
 *      Number of 10-bit fields (command) for each Data ID code:
 *
 *      ID0: TX 1 field    CF
 *      ID1: TX 1 field    CF
 *      ID2: TX 1 field    CF
 *      ID3: TX 1 field    CF
 *      ID7: TX 1 field    CF
 *      ID8: TX 1 field    CF
 *      IDC: TX 1 field    CF
 *      ID6: TX 4 fields   CF + ADF + EDF + CRC      (EEPROM write)
 *      IDD: TX 3 fields   CF + ADF + CRC            (EEPROM read)
 *
 * Receive packet (response)
 *
 *      Number of 10-bit fields received for each request
 *
 *      ID0: RX 6 fields:  CF + SF + DF0 + DF1 + DF2 + CRC
 *                                   DF0-DF2: ABS0-ABS2
 *
 *      ID1: RX 6 fields:  CF + SF + DF0 + DF1 + DF2 + CRC
 *                                   DF0-DF2: ABM0-ABM2
 *
 *      ID2: RX 4 fields:  CF + SF + DF0 + CRC
 *                                   DF0: ENID
 *
 *      ID3: RX 11 fields: CF + SF + DF0 + DF1 + DF2....DF7 + CRC
 *                                   DF0-DF2: ABS0-ABS2
 *                                   DF3: ENID
 *                                   DF4-DF6: ABM0-ABM2
 *                                   DF7: ALMC
 *
 *      ID7: RX 6 fields:  CF + SF + DF0 + DF1 + DF2 + CRC
 *                                   DF0-DF2: ABS0-ABS2
 *
 *      ID8: RX 6 fields:  CF + SF + DF0 + DF1 + DF2 + CRC
 *                                   DF0-DF2: ABS0-ABS2
 *
 *      IDC: RX 6 fields:  CF + SF + DF0 + DF1 + DF2 + CRC
 *                                   DF0-DF2: ABS0-ABS2
 *
 *      ID6: RX 4 fields:  CF + ADF + EDF + CRC
 *
 *      IDD: RX 4 fields:  CF + ADF + EDF + CRC
 *
 */

#define TFORMAT_TX_FIELDS_ID0 1u
#define TFORMAT_TX_FIELDS_ID1 1u
#define TFORMAT_TX_FIELDS_ID2 1u
#define TFORMAT_TX_FIELDS_ID3 1u
#define TFORMAT_TX_FIELDS_ID7 1u
#define TFORMAT_TX_FIELDS_ID8 1u
#define TFORMAT_TX_FIELDS_IDC 1u
#define TFORMAT_TX_FIELDS_ID6 4u
#define TFORMAT_TX_FIELDS_IDD 3u

#define TFORMAT_RX_FIELDS_ID0 6u
#define TFORMAT_RX_FIELDS_ID1 6u
#define TFORMAT_RX_FIELDS_ID2 4u
#define TFORMAT_RX_FIELDS_ID3 11u
#define TFORMAT_RX_FIELDS_ID7 6u
#define TFORMAT_RX_FIELDS_ID8 6u
#define TFORMAT_RX_FIELDS_IDC 6u
#define TFORMAT_RX_FIELDS_ID6 4u
#define TFORMAT_RX_FIELDS_IDD 4u

#define TFORMAT_RX_FIELDS_MAX 11u
#define TFORMAT_TX_FIELDS_MAX 4u
#define TFORMAT_FIELDS_MAX    (TFORMAT_TX_FIELDS_ID3 + TFORMAT_RX_FIELDS_ID3)

/**
 * @brief CRC related declarations
 *
 * T-format polynomial: x^8 + 1
 *
 */

#define PM_TFORMAT_CRC_START     0      // CRC初始值
#define PM_TFORMAT_NBITS_POLY    8u     // CRC多项式位数
#define PM_TFORMAT_POLY          0x01u  // 多项式
#define PM_TFORMAT_CRCTABLE_SIZE 256u   // 查表法中表中的元素个数
#define PM_TFORMAT_CRC_MASK      0xFFu  // 掩码

/**
 * @brief This defines the number of bytes used to calculate the CRC.
 * The number of bytes used is one less than the total bytes in the packet.
 * The extra byte received is the CRC sent from the encoder.
 *
 * For example:
 *     ID7: RX 6 fields:  CF + SF + DF0 + DF1 + DF2 + CRC
 *                        -------------------------
 *                        5 fields used to calc CRC
 */

#define TFORMAT_RX_CRC_BYTES_ID0 (TFORMAT_RX_FIELDS_ID0 - 1u)
#define TFORMAT_RX_CRC_BYTES_ID1 (TFORMAT_RX_FIELDS_ID1 - 1u)
#define TFORMAT_RX_CRC_BYTES_ID2 (TFORMAT_RX_FIELDS_ID2 - 1u)
#define TFORMAT_RX_CRC_BYTES_ID3 (TFORMAT_RX_FIELDS_ID3 - 1u)
#define TFORMAT_RX_CRC_BYTES_ID6 (TFORMAT_RX_FIELDS_ID6 - 1u)
#define TFORMAT_RX_CRC_BYTES_IDD (TFORMAT_RX_FIELDS_IDD - 1u)
#define TFORMAT_RX_CRC_BYTES_ID7 (TFORMAT_RX_FIELDS_ID7 - 1u)
#define TFORMAT_RX_CRC_BYTES_ID8 (TFORMAT_RX_FIELDS_ID8 - 1u)
#define TFORMAT_RX_CRC_BYTES_IDC (TFORMAT_RX_FIELDS_IDC - 1u)

/**
 * @brief The number of transmitted bytes used to calculate the CRC
 * for the EEPROM read/write commands. Other commands do not have a transmit
 * CRC.
 */
#define TFORMAT_TX_CRC_BYTES_ID6 (TFORMAT_TX_FIELDS_ID6 - 1u)
#define TFORMAT_TX_CRC_BYTES_IDD (TFORMAT_TX_FIELDS_IDD - 1u)

typedef enum {
    TFORMAT_ERROR_NONE,
    TFORMAT_ERROR_CF_NOT_MATCH,       // 收发的CF不匹配
    TFORMAT_ERROR_CRC_CHECK_FAIL,     // CRC校验失败
    TFORMAT_ERROR_RX_TIMEOUT,         // 接收超时
    TFORMAT_ERROR_RX_SIZE_INCORRECT,  // 接收长度不正确
    TFORMAT_ERROR_EEPROM_BUSY,
} tformat_error_e;

typedef enum {
    TFORMAT_STATE_RX_READY,
    TFORMAT_STATE_RX_RUNING,
    TFORMAT_STATE_RX_COMPLETE,
} tformat_rx_state_e;

typedef struct {
    tformat_rx_state_e rxFsm;
    tformat_error_e    error;

    uint8_t controlField;  // CF
    uint8_t statusField;   // SF
    uint8_t dataField0;    // DF
    uint8_t dataField1;    // DF
    uint8_t dataField2;    // DF
    uint8_t dataField3;    // DF
    uint8_t dataField4;    // DF
    uint8_t dataField5;    // DF
    uint8_t dataField6;    // DF
    uint8_t dataField7;    // DF
    uint8_t crcField;      // CRC
    uint8_t crcCheck;
    uint8_t eepromAddressField;  // ADF
    uint8_t eepromDataField;     // EDF

    uint8_t txData[TFORMAT_TX_FIELDS_MAX];
    uint8_t rxData[TFORMAT_RX_FIELDS_MAX];

    uint8_t txLen;     // 实际发送字节数
    uint8_t rxLen;     // 实际接收字节数
    uint8_t rxTgtLen;  // 期望接收字节数

    uint32_t pos;    // 单圈位置
    uint32_t turns;  // 多圈数
    uint32_t alm;    // 编码器错误
    uint32_t id;     // 编码器ID

} tformat_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void TFormatSetupCommand(tformat_t* pTformat, uint8_t cf);
void TFormatSetupCommandReadEEPROM(tformat_t* pTformat, uint8_t eepromAddr);
void TFormatSetupCommandWriteEEPROM(tformat_t* pTformat, uint8_t eepromAddr, uint8_t eepromData);
bool TFormatStartOperation(tformat_t* pTformat);

void TformatReceiveData(tformat_t* pTformat);
void TformatDealRxData(tformat_t* pTformat, uint8_t rxLen);

bool TformatCheckOperationComplete(tformat_t* pTformat, tformat_error_e* error);

#ifdef __cplusplus
}
#endif

#endif  // !__TFORMAT_H__
