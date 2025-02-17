#include "paratbl.h"
#include "storage.h"
#include "paraattr.h"

#include "bsp.h"
#include "alarm.h"
#include "scope.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "tformat"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

typedef struct {
    RO u16       u16Offset;
    RO u16       u16Size;  // unit: word
    u16*         pu16Buffer;
    para_attr_t* pAttrTbl;
} paratbl_t;

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

extern s64 as64ScopeBuffer[SCOPE_SAMP_BUFF_SIZE];

RO paratbl_t aParatblEntry[] = {
    {0,    sizeof(sDevicePara) / sizeof(u16),     (u16*)&sDevicePara,        (para_attr_t*)&sDeviceAttr[0]}, // 设备参数
    {400,  sizeof(sAxisPara) / sizeof(u16),       (u16*)&sAxisPara[0],       (para_attr_t*)&sAxisAttr[0]  }, // 轴参数
    {8192, sizeof(as64ScopeBuffer) / sizeof(u16), (u16*)&as64ScopeBuffer[0], nullptr                      }, // 轴参数
};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

para_attr_t* ParaAttr(u16 u16Index)
{
    for (u8 i = 0; i < ARRAY_SIZE(aParatblEntry); i++)
    {
        RO paratbl_t* pParaTbl = &aParatblEntry[i];

        if ((pParaTbl->u16Offset <= u16Index) && (u16Index < (pParaTbl->u16Offset + pParaTbl->u16Size)))
        {
            return (para_attr_t*)(pParaTbl->pAttrTbl + u16Index - pParaTbl->u16Offset);
        }
    }

    return nullptr;
}

u16* ParaAddr(u16 u16Index)
{
    for (u8 i = 0; i < ARRAY_SIZE(aParatblEntry); i++)
    {
        RO paratbl_t* pParaTbl = &aParatblEntry[i];

        if ((pParaTbl->u16Offset <= u16Index) && (u16Index < (pParaTbl->u16Offset + pParaTbl->u16Size)))
        {
            return (u16*)(pParaTbl->pu16Buffer + u16Index - pParaTbl->u16Offset);
        }
    }

    return nullptr;
}

u8 ParaWordSize(para_attr_t* pAttr)
{
    switch (pAttr->uSubAttr.u16Bit.Length)
    {
        case V_SIG:
        {
            return 1;
        }
        case V_DOB0:
        case V_DOB1:
        {
            return 2;
        }
        case V_QUD0:
        case V_QUD1:
        case V_QUD2:
        case V_QUD3:
        {
            return 4;
        }
        default:
        {
            return 0;
        }
    }
}

u16 ParaData16(u8* pu8Buff)
{
    u16 u16Data = 0;

#if 1  // be
    u16Data |= (u16)pu8Buff[0] << 8;
    u16Data |= (u16)pu8Buff[1] << 0;
#else  // le
    u16Data = *(u16*)pu8Buff;
#endif

    return u16Data;
}

u32 ParaData32(u8* pu8Buff)
{
    u32 u32Data = 0;

    u32Data |= (u32)ParaData16(pu8Buff + 0) << 16;
    u32Data |= (u32)ParaData16(pu8Buff + 2) << 0;

    return u32Data;
}

u64 ParaData64(u8* pu8Buff)
{
    u64 u64Data = 0;

    u64Data |= (u64)ParaData32(pu8Buff + 0) << 32;
    u64Data |= (u64)ParaData32(pu8Buff + 4) << 0;

    return u64Data;
}

static u16 ParaAttr16(u16* pu16Buff)
{
    u16 u16Data = 0;

    u16Data |= (u16)pu16Buff[sizeof(para_attr_t) * 0 / 2] << 0;

    return u16Data;
}

static u32 ParaAttr32(u16* pu16Buff)
{
    u32 u32Data = 0;

    u32Data |= (u32)pu16Buff[sizeof(para_attr_t) * 0 / 2] << 0;
    u32Data |= (u32)pu16Buff[sizeof(para_attr_t) * 1 / 2] << 16;

    return u32Data;
}

static u64 ParaAttr64(u16* pu16Buff)
{
    u64 u64Data = 0;

    u64Data |= (u64)pu16Buff[sizeof(para_attr_t) * 0 / 2] << 0;
    u64Data |= (u64)pu16Buff[sizeof(para_attr_t) * 1 / 2] << 16;
    u64Data |= (u64)pu16Buff[sizeof(para_attr_t) * 2 / 2] << 32;
    u64Data |= (u64)pu16Buff[sizeof(para_attr_t) * 3 / 2] << 48;

    return u64Data;
}

para_rw_status_e ParaRead(u16 u16Index, u16* pu16Buffer, u16 u16WordCnt)
{
    para_attr_t* pParaAttr    = nullptr;
    u16*         pu16ParaAddr = nullptr;

    u8 *pu8DstAddr, *pu8SrcAddr;
    u16 u16ParaWordSize = 0;

    for (u8 i = 0; i < ARRAY_SIZE(aParatblEntry); i++)
    {
        RO paratbl_t* pParaTbl = &aParatblEntry[i];

        if ((pParaTbl->u16Offset <= u16Index) && (u16Index < (pParaTbl->u16Offset + pParaTbl->u16Size)))
        {
            pu16ParaAddr = pParaTbl->pu16Buffer + u16Index - pParaTbl->u16Offset;

            if (pParaTbl->pAttrTbl != nullptr)
            {
                pParaAttr = pParaTbl->pAttrTbl + u16Index - pParaTbl->u16Offset;
            }
        }
    }

    if (pu16ParaAddr == nullptr)
    {
        return PARA_RW_ILLEGAL_ADDRESS;  // 地址异常
    }

    if (pParaAttr == nullptr)
    {
        while (u16WordCnt--)
        {
            *pu16Buffer++ = *pu16ParaAddr++;
        }
    }
    else
    {
        while (u16WordCnt > 0)
        {
            switch (pParaAttr->uSubAttr.u16Bit.Length)
            {
                case V_SIG:
                {
                    u16ParaWordSize = 1;
                    break;
                }
                case V_DOB0:
                {
                    u16ParaWordSize = 2;
                    break;
                }
                case V_QUD0:
                {
                    u16ParaWordSize = 4;
                    break;
                }
                case V_DOB1:
                case V_QUD1:
                case V_QUD2:
                case V_QUD3:
                {
                    return PARA_RW_ILLEGAL_ADDRESS;  // 地址未对齐
                }
            }

            if (u16WordCnt < u16ParaWordSize)
            {
                return PARA_RW_ILLEGAL_LENGTH;  // 数据缺失
            }

            pu8DstAddr = (u8*)pu16Buffer;
            pu8SrcAddr = (u8*)pu16ParaAddr;

#if 0
        switch (u16ParaSize)
        {
            case 1:
            {
                pu8DstAddr[0] = pu8SrcAddr[0];
                pu8DstAddr[1] = pu8SrcAddr[1];
                break;
            }
            case 2:
            {
                pu8DstAddr[0] = pu8SrcAddr[0];
                pu8DstAddr[1] = pu8SrcAddr[1];
                pu8DstAddr[2] = pu8SrcAddr[2];
                pu8DstAddr[3] = pu8SrcAddr[3];
                break;
            }
            case 4:
            {
                pu8DstAddr[0] = pu8SrcAddr[0];
                pu8DstAddr[1] = pu8SrcAddr[1];
                pu8DstAddr[2] = pu8SrcAddr[2];
                pu8DstAddr[3] = pu8SrcAddr[3];
                pu8DstAddr[4] = pu8SrcAddr[4];
                pu8DstAddr[5] = pu8SrcAddr[5];
                pu8DstAddr[6] = pu8SrcAddr[6];
                pu8DstAddr[7] = pu8SrcAddr[7];
                break;
            }
        }
#else

            switch (u16ParaWordSize)
            {
                case 1:
                {
                    pu8DstAddr[0] = pu8SrcAddr[1];
                    pu8DstAddr[1] = pu8SrcAddr[0];
                    break;
                }
                case 2:
                {
                    pu8DstAddr[0] = pu8SrcAddr[3];
                    pu8DstAddr[1] = pu8SrcAddr[2];
                    pu8DstAddr[2] = pu8SrcAddr[1];
                    pu8DstAddr[3] = pu8SrcAddr[0];
                    break;
                }
                case 4:
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
            }
#endif

            pParaAttr += u16ParaWordSize;
            pu16ParaAddr += u16ParaWordSize;
            pu16Buffer += u16ParaWordSize;
            u16WordCnt -= u16ParaWordSize;
        }
    }

    return PARA_RW_SUCCESS;
}

para_rw_status_e ParaWrite(u16 u16Index, u16* pu16Buffer, u16 u16WordCnt)
{
    para_attr_t* pParaAttr    = nullptr;
    u16*         pu16ParaAddr = nullptr;

    u16  u16ParaWordSize = 0;
    bool bSyncEeprom     = false;

    for (u8 i = 0; i < ARRAY_SIZE(aParatblEntry); i++)
    {
        RO paratbl_t* pParaTbl = &aParatblEntry[i];

        if ((pParaTbl->u16Offset <= u16Index) && (u16Index < (pParaTbl->u16Offset + pParaTbl->u16Size)))
        {
            pu16ParaAddr = pParaTbl->pu16Buffer + u16Index - pParaTbl->u16Offset;
            pParaAttr    = pParaTbl->pAttrTbl + u16Index - pParaTbl->u16Offset;
        }
    }

    if (pParaAttr == nullptr || pu16ParaAddr == nullptr)
    {
        return PARA_RW_ILLEGAL_ADDRESS;  // 地址异常
    }

    while (u16WordCnt > 0)
    {
        if (D.u16SysAccess > pParaAttr->uSubAttr.u16Bit.Access)
        {
            return PARA_RW_NO_ACCESS;  // 权限不够, 值越低权限越高
        }

        switch (pParaAttr->uSubAttr.u16Bit.Mode)
        {
            case V_RO:
            {
                return PARA_RW_READ_ONLY;  // 只读
            }
            case V_RW_M0:
            {
                break;  // 任意修改
            }
            case V_RW_M1:
            {
                bSyncEeprom = true;  // 重启生效
                break;
            }
            case V_RW_M2:
            {
                if (D.eSysState == SYSTEM_STATE_OPERATION_ENABLE)
                {
                    return PARA_RW_MODIFY_AT_STOP;  // 仅停机可改
                }

                break;
            }
        }

        switch (pParaAttr->uSubAttr.u16Bit.Length)
        {
            case V_SIG:
            {
                u16ParaWordSize = 1;
                break;
            }
            case V_DOB0:
            {
                u16ParaWordSize = 2;
                break;
            }
            case V_QUD0:
            {
                u16ParaWordSize = 4;
                break;
            }
            case V_DOB1:
            case V_QUD1:
            case V_QUD2:
            case V_QUD3:
            {
                return PARA_RW_ILLEGAL_ADDRESS;  // 地址未对齐
            }
        }

        if (u16WordCnt < u16ParaWordSize)
        {
            return PARA_RW_ILLEGAL_LENGTH;  // 数据缺失
        }

        switch (u16ParaWordSize)
        {
            case 1:
            {
                u16 x16Min = ParaAttr16(&pParaAttr->u16MinVal);
                u16 x16Max = ParaAttr16(&pParaAttr->u16MaxVal);
                u16 x16Dat = ParaData16((u8*)pu16Buffer);

                if ((pParaAttr->uSubAttr.u16Bit.Sign == V_SIGN && INCLOSE((s16)x16Dat, (s16)x16Min, (s16)x16Max)) ||
                    (pParaAttr->uSubAttr.u16Bit.Sign == V_UNSI && INCLOSE((u16)x16Dat, (u16)x16Min, (u16)x16Max)))
                {
                    pu16ParaAddr[0] = W(x16Dat);
                }
                else
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }

                break;
            }
            case 2:
            {
                u32 x32Min = ParaAttr32(&pParaAttr->u16MinVal);
                u32 x32Max = ParaAttr32(&pParaAttr->u16MaxVal);
                u32 x32Dat = ParaData32((u8*)pu16Buffer);

                if (((pParaAttr->uSubAttr.u16Bit.Sign == V_SIGN) && INCLOSE((s32)x32Dat, (s32)x32Min, (s32)x32Max)) ||
                    ((pParaAttr->uSubAttr.u16Bit.Sign == V_UNSI) && INCLOSE((u32)x32Dat, (u32)x32Min, (u32)x32Max)))
                {
                    pu16ParaAddr[0] = WL(x32Dat);
                    pu16ParaAddr[1] = WH(x32Dat);
                }
                else
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }

                break;
            }
            case 4:
            {
                u64 x64Min = ParaAttr64(&pParaAttr->u16MinVal);
                u64 x64Max = ParaAttr64(&pParaAttr->u16MaxVal);
                u64 x64Dat = ParaData64((u8*)pu16Buffer);

                if ((pParaAttr->uSubAttr.u16Bit.Sign == V_SIGN && INCLOSE((s64)x64Dat, (s64)x64Min, (s64)x64Max)) ||
                    (pParaAttr->uSubAttr.u16Bit.Sign == V_UNSI && INCLOSE((u64)x64Dat, (u64)x64Min, (u64)x64Max)))
                {
                    pu16ParaAddr[0] = W0(x64Dat);
                    pu16ParaAddr[1] = W1(x64Dat);
                    pu16ParaAddr[2] = W2(x64Dat);
                    pu16ParaAddr[3] = W3(x64Dat);
                }
                else
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }

                break;
            }
        }

        if (bSyncEeprom == true)  // 重启生效
        {
            bSyncEeprom = false;

            // return RW_STORAGE_FAILED;
        }

        pParaAttr += u16ParaWordSize;
        pu16ParaAddr += u16ParaWordSize;
        pu16Buffer += u16ParaWordSize;
        u16WordCnt -= u16ParaWordSize;
    }

    return PARA_RW_SUCCESS;
}

para_rw_status_e ParatblRst(u8 u8RstMode)
{
    bool bParaRst;

    if (D.eSysState == SYSTEM_STATE_OPERATION_ENABLE)
    {
        return PARA_RW_MODIFY_AT_STOP;  // 仅停机可改
    }

    for (u8 i = 0; i < ARRAY_SIZE(aParatblEntry); i++)
    {
        RO paratbl_t*   pParaTbl  = &aParatblEntry[i];
        RO para_attr_t* pParaAttr = pParaTbl->pAttrTbl;
        u16*            pParaBuff = (u16*)pParaTbl->pu16Buffer;

        for (u16 j = 0; j < pParaTbl->u16Size;)
        {
            if (u8RstMode == 1)  // 复位所有参数
            {
                bParaRst = true;
            }
            else if (pParaAttr[j].uSubAttr.u16Bit.Cover)
            {
                bParaRst = true;
            }
            else
            {
                bParaRst = false;
            }

            if (bParaRst == true)
            {
                switch (pParaAttr[j].uSubAttr.u16Bit.Length)
                {
                    case V_SIG:
                    {
                        pParaBuff[j + 0] = pParaAttr[j + 0].u16InitVal;
                        j += 1;
                        break;
                    }
                    case V_DOB0:
                    {
                        pParaBuff[j + 0] = pParaAttr[j + 0].u16InitVal;
                        pParaBuff[j + 1] = pParaAttr[j + 1].u16InitVal;
                        j += 2;
                        break;
                    }
                    case V_QUD0:
                    {
                        pParaBuff[j + 0] = pParaAttr[j + 0].u16InitVal;
                        pParaBuff[j + 1] = pParaAttr[j + 1].u16InitVal;
                        pParaBuff[j + 2] = pParaAttr[j + 2].u16InitVal;
                        pParaBuff[j + 3] = pParaAttr[j + 3].u16InitVal;
                        j += 4;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
        }
    }

    return PARA_RW_SUCCESS;
}

void ParaTblInit(void)
{
    bool bSync = false;

    for (u8 i = 0; i < ARRAY_SIZE(aParatblEntry); i++)
    {
        RO paratbl_t*   pParaTbl  = &aParatblEntry[i];
        RO para_attr_t* pAttrTbl  = pParaTbl->pAttrTbl;
        u16*            pParaBuff = (u16*)pParaTbl->pu16Buffer;
			
			if( pAttrTbl == nullptr )
			{
			break;
			}

        for (u16 j = 0; j < pParaTbl->u16Size;)
        {
#if 1
            if (pAttrTbl[j].uSubAttr.u16Bit.Sync == V_SYNC)  // 从EEPROM读取
            {
          
            }
            else
#endif
            {
                bSync = false;
            }

            if (bSync == false)  // 加载初始值
            {
                switch (pAttrTbl[j].uSubAttr.u16Bit.Length)
                {
                    case V_SIG:
                    {
                        pParaBuff[j + 0] = pAttrTbl[j + 0].u16InitVal;
                        j += 1;
                        break;
                    }
                    case V_DOB0:
                    {
                        pParaBuff[j + 0] = pAttrTbl[j + 0].u16InitVal;
                        pParaBuff[j + 1] = pAttrTbl[j + 1].u16InitVal;
                        j += 2;
                        break;
                    }
                    case V_QUD0:
                    {
                        pParaBuff[j + 0] = pAttrTbl[j + 0].u16InitVal;
                        pParaBuff[j + 1] = pAttrTbl[j + 1].u16InitVal;
                        pParaBuff[j + 2] = pAttrTbl[j + 2].u16InitVal;
                        pParaBuff[j + 3] = pAttrTbl[j + 3].u16InitVal;
                        j += 4;
                        break;
                    }
                    default:
                    {
                        j = j;
                        break;
                    }
                }
            }
        }
    }

    //
    //
    //

    u32 u32DrvScheme = LINK32(sDeviceAttr[1].u16InitVal, sDeviceAttr[0].u16InitVal);

    if (D.u32DrvScheme != u32DrvScheme)
    {
        AlmSet(ERR_SCHED_UNMATCHED, 0);
        // AlmSet(WRN_NEED_REBOOT, 0);
    }
}

void ParatblCycle(void)
{}
