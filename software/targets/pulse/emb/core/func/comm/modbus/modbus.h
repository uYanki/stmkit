#ifndef __MODBUS_H__
#define __MODBUS_H__

#include "bsp.h"
#include "delay.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define MODBUS_FRAME_MIN_SIZE   4  // id(1) + fn(1) + data(n) + crc(2)
#define MODBUS_FRAME_MAX_SIZE   256
#define MODBUS_SLAVEID_BUF_SZIE 32

/*!
 * Constants which defines the format of a modbus frame. The example is
 * shown for a Modbus RTU/ASCII frame. Note that the Modbus PDU is not
 * dependent on the underlying transport.
 *
 * <code>
 * <------------------------ MODBUS SERIAL LINE PDU (1) ------------------->
 *              <----------- MODBUS PDU (1') ---------------->
 *  +-----------+---------------+----------------------------+-------------+
 *  | Address   | Function Code | Data                       | CRC/LRC     |
 *  +-----------+---------------+----------------------------+-------------+
 *  |           |               |                                   |
 * (2)        (3/2')           (3')                                (4)
 *
 * (1)  ... MODBUS_SER_PDU_SIZE_MAX = 256
 * (2)  ... MODBUS_SER_PDU_ADDR_OFF = 0
 * (3)  ... MODBUS_SER_PDU_PDU_OFF  = 1
 * (4)  ... MODBUS_SER_PDU_SIZE_CRC = 2
 *
 * (1') ... MODBUS_PDU_SIZE_MAX     = 253
 * (2') ... MODBUS_PDU_FUNC_OFF     = 0
 * (3') ... MODBUS_PDU_DATA_OFF     = 1
 * </code>
 */

/**
 * @brief 原始帧结构
 */
#define MODBUS_ADDR_OFFSET 0  // offset of slave address
#define MODBUS_FUNC_OFFSET 1  // offset of function code
#define MODBUS_DATA_OFFSET 2  // offset of data

/**
 * @brief PDU帧结构
 */
#define MODBUS_PDU_SIZE_MAX    253  // maximum size of a pdu
#define MODBUS_PDU_SIZE_MIN    1    // function code
#define MODBUS_PDU_FUNC_OFFSET 0    // offset of function code in pdu
#define MODBUS_PDU_DATA_OFFSET 1    // offset for response data in pdu

/**
 * @brief 从站地址
 */
#define MODBUS_ADDR_BROADCAST 0    // modbus broadcast address
#define MODBUS_ADDR_MIN       1    // smallest possible slave address
#define MODBUS_ADDR_MAX       247  // biggest possible slave address

/**
 * @brief 功能码
 */

typedef u8 mb_func_t;

#define MODBUS_FUNC_ERROR_MASK 0x80  // 错误标志

// #define MODBUS_FUNC_READ_DISCRETE_INPUTS         0x02  // 读输入状态

// #define MODBUS_FUNC_READ_COILS                   0x01  // 读线圈状态
// #define MODBUS_FUNC_WRITE_SINGLE_COIL            0x05  // 写单个线圈
// #define MODBUS_FUNC_WRITE_MULTIPLE_COILS         0x0F  // 写多个线圈

// #define MODBUS_FUNC_READ_INPUT_REGISTER          0x04  // 读输入寄存器

#define MODBUS_FUNC_READ_HOLDING_REGISTER        0x03  // 读保持寄存器
#define MODBUS_FUNC_WRITE_REGISTER               0x06  // 写单个保持寄存器
#define MODBUS_FUNC_WRITE_MULTIPLE_REGISTERS     0x10  // 写多个保持寄存器
#define MODBUS_FUNC_READWRITE_MULTIPLE_REGISTERS 0x17  // 读写多个保持寄存器

// #define MODBUS_FUNC_DIAG_READ_EXCEPTION          0x07
// #define MODBUS_FUNC_DIAG_DIAGNOSTIC              0x08  // 回路诊断
// #define MODBUS_FUNC_DIAG_GET_COM_EVENT_CNT       0x0B
// #define MODBUS_FUNC_DIAG_GET_COM_EVENT_LOG       0x0C

#define MODBUS_FUNC_REPORT_SLAVEID 0x11

/**
 * @brief 读写状态
 */

// tuner 是根据读地址0返回的错误码9 来识别设备类型的

typedef enum {
    MODBUS_ERROR_NONE                 = 0,
    MODBUS_ERROR_FUNC_NOT_SUPPORT     = 1,   // 功能.不支持
    MODBUS_ERROR_RXPDU_ILLEGAL_LENGTH = 2,   // PDU.长度非法
    MODBUS_ERROR_DATA_ILLEGAL_ADDRESS = 5,   // 参数.地址非法
    MODBUS_ERROR_DATA_ILLEGAL_VALUE   = 10,  // 参数.值非法
    MODBUS_ERROR_DATA_ILLEGAL_LENGTH  = 9,   // 参数.长度非法
    MODBUS_ERROR_DATA_READ_ONLY       = 7,   // 参数.只读
    MODBUS_ERROR_DATA_MODIFY_AT_STOP  = 6,   // 参数.停机更改
    MODBUS_ERROR_DATA_NO_ACCESS       = 11,  // 参数.无访问权限
} mb_error_e;

/**
 * @brief 状态机
 */
typedef enum {
    MODBUS_STATE_TX_START,
    MODBUS_STATE_TX_BUSY,
    MODBUS_STATE_RX_START,
    MODBUS_STATE_RX_BUSY,
    MODBUS_STATE_RX_PROC,
} mb_state_e;

/**
 * @brief 函数回调
 */

typedef mb_error_e (*mb_cbk_t)(u8* pu8Frame, u16* pu16Length);

typedef struct {
    mb_func_t eFuncCode;
    mb_cbk_t  pfnCallback;
} mb_handler_t;

/**
 * @brief 访问方式
 */
typedef enum {
    MODBUS_REG_READ,
    MODBUS_REG_WRITE,
} mb_access_e;

/**
 * @brief 从站
 */
typedef struct {
    // 从机地址
    u8 u8SlaveAddr;

    // 状态机
    mb_state_e eFSM;

    // 485换向延时
    u32 u32DirSwTick;

    // 帧缓冲
    u8* pu8BuffAddr;
    u16 u16BuffSize;
    u16 u16FrameSize;

    // 帧请求地址
    u8 u8RcvAddr;

} mbslave_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

mb_error_e ModbusSetSlaveID(mbslave_t* pModbusSlave, u8 u8SlaveID, bool bIsRunning, RO u8* pu8Additional, u16 u16AdditionalLen);

void ModbusCreat(mbslave_t* pModbusSlave);
void ModbusInit(mbslave_t* pModbusSlave);
void ModbusCycle(mbslave_t* pModbusSlave);
void ModbusIsr(mbslave_t* pModbusSlave);

#ifdef __cplusplus
}
#endif

#endif  // !__MODBUS_H__
