#ifndef __PARA_STORAGE_H__
#define __PARA_STORAGE_H__

#include "modbus.h"
#include "paratbl.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef enum {

    PARA_RW_SUCCESS = MODBUS_ERROR_NONE,

    PARA_RW_ILLEGAL_ADDRESS = MODBUS_ERROR_DATA_ILLEGAL_ADDRESS,  // 地址非法
    PARA_RW_ILLEGAL_VALUE   = MODBUS_ERROR_DATA_ILLEGAL_VALUE,    // 值非法
    PARA_RW_ILLEGAL_LENGTH  = MODBUS_ERROR_DATA_ILLEGAL_LENGTH,   // 长度非法
    PARA_RW_READ_ONLY       = MODBUS_ERROR_DATA_READ_ONLY,        // 只读
    PARA_RW_MODIFY_AT_STOP  = MODBUS_ERROR_DATA_MODIFY_AT_STOP,   // 停机更改
    PARA_RW_NO_ACCESS       = MODBUS_ERROR_DATA_NO_ACCESS,        // 无访问权限

    PARA_RW_FAILURE = 20,  // 通用错误
    PARA_RW_SVAE_FAILED,   // 保存失败

} para_rw_status_e;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

u16 ParaData16(u8* pu8Buff);
u32 ParaData32(u8* pu8Buff);
u64 ParaData64(u8* pu8Buff);

para_attr_t* ParaAttr(u16 u16Index);
u16*         ParaAddr(u16 u16Index);
u8           ParaWordSize(para_attr_t* pAttr);

para_rw_status_e ParaRead(u16 u16Index, u16* pu16Buffer, u16 u16WordCnt);
para_rw_status_e ParaWrite(u16 u16Index, u16* pu16Buffer, u16 u16WordCnt);

#ifdef __cplusplus
}
#endif

#endif  // !__PARA_STORAGE_H__
