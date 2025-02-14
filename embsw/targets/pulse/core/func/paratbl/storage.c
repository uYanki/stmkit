#include "paratbl.h"
#include "storage.h"

#include "bsp.h"
#include "alarm.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "tformat"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

extern para_rw_status_e ParaData_ReadInto(u16 u16Index, u16* pu16Data);
extern para_rw_status_e ParaData_WriteFrom(u16 u16Index, u16* pu16Data);

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

para_rw_status_e ParaWrite(u16 u16Index, u16* pu16Buffer, u16 u16WordCnt)
{
    u16 u16ParaWordCnt;

    u64 u64Data;

    while (u16WordCnt > 0)
    {
        const para_attr_t* pParaAttr = &aDeviceAttr[u16Index];

        u8* pu8SrcAddr = (u8*)pu16Buffer;
        u8* pu8DstAddr = (u8*)&u64Data;

        switch (pParaAttr->uSubAttr.u16Bit.Length)
        {
            case V_SIG:
            {
                u16ParaWordCnt = 1;

                u64Data = be16(pu8SrcAddr);

                break;
            }
            case V_DOB0:
            {
                u16ParaWordCnt = 2;

                u64Data = be32(pu8SrcAddr);

                break;
            }
            case V_QUD0:
            {
                u16ParaWordCnt = 4;

                u64Data = be64(pu8SrcAddr);

                break;
            }

            default:
            {
                return PARA_RW_ILLEGAL_ADDRESS;  // 地址未对齐
            }
        }

        if (u16ParaWordCnt > u16WordCnt)
        {
            return PARA_RW_ILLEGAL_LENGTH;  // 数据缺失
        }

        para_rw_status_e eStatus = ParaData_WriteFrom(u16Index, (u16*)&u64Data);

        if (eStatus != PARA_RW_SUCCESS)
        {
            return eStatus;
        }

        u16Index += u16ParaWordCnt;
        pu16Buffer += u16ParaWordCnt;
        u16WordCnt -= u16ParaWordCnt;
    }

    return PARA_RW_SUCCESS;
}

para_rw_status_e ParaRead(u16 u16Index, u16* pu16Buffer, u16 u16WordCnt)
{
    u16 u16ParaWordCnt;

    u64 u64Data;

    while (u16WordCnt > 0)
    {
        const para_attr_t* pParaAttr = &aDeviceAttr[u16Index];

        switch (pParaAttr->uSubAttr.u16Bit.Length)
        {
            case V_SIG:
            {
                u16ParaWordCnt = 1;
                break;
            }
            case V_DOB0:
            {
                u16ParaWordCnt = 2;
                break;
            }
            case V_QUD0:
            {
                u16ParaWordCnt = 4;
                break;
            }

            default:
            {
                return PARA_RW_ILLEGAL_ADDRESS;  // 地址未对齐
            }
        }

        if (u16ParaWordCnt > u16WordCnt)
        {
            return PARA_RW_ILLEGAL_LENGTH;  // 数据缺失
        }

        para_rw_status_e eStatus = ParaData_ReadInto(u16Index, (u16*)&u64Data);

        if (eStatus != PARA_RW_SUCCESS)
        {
            return eStatus;
        }

        u8* pu8SrcAddr = (u8*)&u64Data;
        u8* pu8DstAddr = (u8*)pu16Buffer;

        switch (pParaAttr->uSubAttr.u16Bit.Length)
        {
            case V_SIG:
            {
                pu8DstAddr[0] = pu8SrcAddr[1];
                pu8DstAddr[1] = pu8SrcAddr[0];

                break;
            }
            case V_DOB0:
            {
                pu8DstAddr[0] = pu8SrcAddr[3];
                pu8DstAddr[1] = pu8SrcAddr[2];
                pu8DstAddr[2] = pu8SrcAddr[1];
                pu8DstAddr[3] = pu8SrcAddr[0];
                break;
            }
            case V_QUD0:
            {
                pu8DstAddr[0] = pu8SrcAddr[7];
                pu8DstAddr[1] = pu8SrcAddr[6];
                pu8DstAddr[2] = pu8SrcAddr[5];
                pu8DstAddr[3] = pu8SrcAddr[4];
                pu8DstAddr[4] = pu8SrcAddr[3];
                pu8DstAddr[5] = pu8SrcAddr[2];
                pu8DstAddr[6] = pu8SrcAddr[1];
                pu8DstAddr[7] = pu8SrcAddr[0];

                break;
            }

            default:
            {
                return PARA_RW_ILLEGAL_ADDRESS;  // 地址未对齐
            }
        }

        u16Index += u16ParaWordCnt;
        pu16Buffer += u16ParaWordCnt;
        u16WordCnt -= u16ParaWordCnt;
    }

    return PARA_RW_SUCCESS;
}
