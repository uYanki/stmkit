#include "paratbl.h"
// #include "paraattr.c"
#include "alarm.h"
#include "paratbl/storage.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "paratbl"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

#define ASCII_0_DEC     48

typedef enum {
    PARATBL_CMD_NONE        = 0,
    PARATBL_CMD_RST_RSTABLE = 1,  // 所有可恢复出厂参数恢复出厂(非使能状态)
    PARATBL_CMD_RST_ALL     = 2,  // 所有可恢复及不可恢复出厂参数恢复出厂(非使能状态)
    PARATBL_CMD_SAVE_ALL    = 5,  // 保存所有可保存参数到EEPROM
} ParaTblCmd_e;

typedef enum {
    PARATBL_STATE_IDLE,
    PARATBL_STATE_BUSY,
    PARATBL_STATE_SUCCESS,
    PARATBL_STATE_ERROR,
} ParaTblSts_e;

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

extern para_rw_status_e ParaData_UserCheck(u16 u16Index, u16* pu16Data);

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

u16 au16ParaTbl[PARATBL_SIZE * 2] = {0};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

static u32 GetCompileDate(void)  // 编译日期
{
    static s8    as8BuildDate[]  = __DATE__;  // ascii format "Sep  1 2022"
    static RO s8 cas8MonthList[] = "anebarprayunulugepctovec";
    u8           u8Year, u8Month, u8Day;

    /*return software compile date, decimal format: yy-mm-dd*/
    if (as8BuildDate[4] == ' ')
    {
        as8BuildDate[4] = 0;
    }
    else
    {
        as8BuildDate[4] -= '0';
    }
    for (u8Day = 5; u8Day < 11; u8Day++)
    {
        as8BuildDate[u8Day] -= '0';
    }

    u8Year = as8BuildDate[9] * 10 + as8BuildDate[10];  // year

    for (u8Day = 0; u8Day < 23; u8Day += 2)  // month
    {
        if (as8BuildDate[1] == cas8MonthList[u8Day] &&
            as8BuildDate[2] == cas8MonthList[u8Day + 1])
        {
            u8Month = (u8Day >> 1) + 1;
            break;
        }
    }
    u8Day = as8BuildDate[4] * 10 + as8BuildDate[5];  // day

    return (u32)u8Year * 10000 + (u32)u8Month * 100 + (u32)u8Day;
}

bool ParaBoundChk(u16 u16Index)
{
    if (u16Index < PARATBL_SIZE)
    {
        return true;
    }
    else
    {
        return false;
    }
}

static inline const para_attr_t* ParaAttr(u16 u16Index)
{
    return &aDeviceAttr[u16Index];
}

u16* ParaAddr(u16 u16Index)
{
    return &au16ParaTbl[u16Index];
}

u16* ParaAddrM2(u16 u16Index)
{
    return &au16ParaTbl[PARATBL_SIZE + u16Index];
}

u16 ParaSubAttr_Sync(u16 u16Index)
{
    return ParaAttr(u16Index)->uSubAttr.u16Bit.Sync;
}

u16 ParaSubAttr_Relate(u16 u16Index)
{
    return ParaAttr(u16Index)->uSubAttr.u16Bit.Relate;
}

u16 ParaSubAttr_Mode(u16 u16Index)
{
    return ParaAttr(u16Index)->uSubAttr.u16Bit.Mode;
}

u16 ParaSubAttr_Sign(u16 u16Index)
{
    return ParaAttr(u16Index)->uSubAttr.u16Bit.Sign;
}

u16 ParaSubAttr_Offset(u16 u16Index)
{
    // eeprom memory address
    return u16Index * 2;
}

u16 ParaSubAttr_Cover(u16 u16Index)
{
    if (ParaSubAttr_Sync(u16Index) != V_SYNC)
    {
        return V_NCOV;
    }

    return ParaAttr(u16Index)->uSubAttr.u16Bit.Cover;
}

u16 ParaSubAttr_WordCnt(u16 u16Index)  // unit: word count
{
    switch (ParaAttr(u16Index)->uSubAttr.u16Bit.Length)
    {
        case V_SIG:
        {
            return 1;
        }
        case V_DOB0:
        {
            return 2;
        }
        case V_QUD0:
        {
            return 4;
        }
        default:
        case V_DOB1:
        case V_QUD1:
        case V_QUD2:
        case V_QUD3:
        {
            return 0;
        }
    }
}

u16 ParaSubAttr_ByteCnt(u16 u16Index)  // unit: word count
{
    return ParaSubAttr_WordCnt(u16Index) << 1;
}

u16 ParaSubAttr_Access(u16 u16Index)
{
    return ParaAttr(u16Index)->uSubAttr.u16Bit.Access;
}

u16 ParaAttr16_GetInitVal(u16 u16Index)
{
    switch (u16Index)
    {
        case PARA_INDEX_U16_MCU_SW_VER0:
        {
            return 0;
        }
        case PARA_INDEX_U16_MCU_SW_VER1:
        {
            return 0;
        }

        case PARA_INDEX_U16_LED_NUM:
        {
            return CONFIG_LED_NUM;
        }
        case PARA_INDEX_U16_EXT_DI_NUM:
        {
            return CONFIG_GEN_DI_NUM;
        }
        case PARA_INDEX_U16_EXT_DO_NUM:
        {
            return CONFIG_GEN_DO_NUM;
        }
        case PARA_INDEX_U16_EXT_H_DI_NUM:
        {
            return CONFIG_HDI_NUM;
        }
        case PARA_INDEX_U16_EXT_H_DO_NUM:
        {
            return CONFIG_HDO_NUM;
        }
        case PARA_INDEX_U16_EXT_AI_NUM:
        {
            return CONFIG_EXT_AI_NUM;
        }
        case PARA_INDEX_U16_EXT_AO_NUM:
        {
            return CONFIG_EXT_AO_NUM;
        }
        default:
        {
            return ParaAttr(u16Index)->u16InitVal;
        }
    }
}

u16 ParaAttr16_GetMinVal(u16 u16Index)
{
    u16 u16Relate = ParaSubAttr_Relate(u16Index);

    if (u16Relate == V_NR || u16Relate == V_RL_UP)
    {
        return ParaAttr(u16Index)->u16MinVal;
    }
    else  // if (u16Relate == V_RL_DN || u16Relate == V_RL)
    {
        u16Index = ParaAttr(u16Index)->u16MinVal;

        return he16(&au16ParaTbl[u16Index]);
    }
}

u16 ParaAttr16_GetMaxVal(u16 u16Index)
{
    u16 u16Relate = ParaSubAttr_Relate(u16Index);

    if (u16Relate == V_NR || u16Relate == V_RL_DN)
    {
        return ParaAttr(u16Index)->u16MaxVal;
    }
    else  // if (u16Relate == V_RL_UP || u16Relate == V_RL)
    {
        u16Index = ParaAttr(u16Index)->u16MaxVal;

        return he16(&au16ParaTbl[u16Index]);
    }
}

u32 ParaAttr32_GetInitVal(u16 u16Index)
{
    switch (u16Index)
    {
        case PARA_INDEX_U32_MCU_SW_BUILD_DATE:
        {
            return GetCompileDate();
        }
        case PARA_INDEX_U32_MCU_SW_BUILD_TIME:
        {
            return 0;
        }
        default:
        {
            return LINK32(ParaAttr(u16Index + 1)->u16InitVal, ParaAttr(u16Index + 0)->u16InitVal);
        }
    }
}

u32 ParaAttr32_GetMinVal(u16 u16Index)
{
    u16 u16Relate = ParaSubAttr_Relate(u16Index);

    if (u16Relate == V_NR || u16Relate == V_RL_UP)
    {
        return LINK32(ParaAttr(u16Index + 1)->u16MinVal, ParaAttr(u16Index + 0)->u16MinVal);
    }
    else  // if (u16Relate == V_RL_DN || u16Relate == V_RL)
    {
        u16Index = ParaAttr(u16Index)->u16MinVal;

        return he32(&au16ParaTbl[u16Index]);
    }
}

u32 ParaAttr32_GetMaxVal(u16 u16Index)
{
    u16 u16Relate = ParaSubAttr_Relate(u16Index);

    if (u16Relate == V_NR || u16Relate == V_RL_DN)
    {
        return LINK32(ParaAttr(u16Index + 1)->u16MaxVal, ParaAttr(u16Index + 0)->u16MaxVal);
    }
    else  // if (u16Relate == V_RL_UP || u16Relate == V_RL)
    {
        u16Index = ParaAttr(u16Index)->u16MaxVal;

        return he32(&au16ParaTbl[u16Index]);
    }
}

u64 ParaAttr64_GetInitVal(u16 u16Index)
{
    return LINK64(ParaAttr(u16Index + 3)->u16InitVal, ParaAttr(u16Index + 2)->u16InitVal,
                  ParaAttr(u16Index + 1)->u16InitVal, ParaAttr(u16Index + 0)->u16InitVal);
}

u64 ParaAttr64_GetMinVal(u16 u16Index)
{
    u16 u16Relate = ParaSubAttr_Relate(u16Index);

    if (u16Relate == V_NR || u16Relate == V_RL_UP)
    {
        return LINK64(ParaAttr(u16Index + 3)->u16MinVal, ParaAttr(u16Index + 2)->u16MinVal,
                      ParaAttr(u16Index + 1)->u16MinVal, ParaAttr(u16Index + 0)->u16MinVal);
    }
    else  // if (u16Relate == V_RL_DN || u16Relate == V_RL)
    {
        u16Index = ParaAttr(u16Index)->u16MinVal;

        return he64(&au16ParaTbl[u16Index]);
    }
}

u64 ParaAttr64_GetMaxVal(u16 u16Index)
{
    u16 u16Relate = ParaSubAttr_Relate(u16Index);

    if (u16Relate == V_NR || u16Relate == V_RL_DN)
    {
        return LINK64(ParaAttr(u16Index + 3)->u16MaxVal, ParaAttr(u16Index + 2)->u16MaxVal,
                      ParaAttr(u16Index + 1)->u16MaxVal, ParaAttr(u16Index + 0)->u16MaxVal);
    }
    else  // if (u16Relate == V_RL_UP || u16Relate == V_RL)
    {
        u16Index = ParaAttr(u16Index)->u16MaxVal;

        return he64(&au16ParaTbl[u16Index]);
    }
}

void ParaAttr_GetInitVal(u16 u16Index, u16* pu16Buff)
{
    u16 u16WordCnt = ParaSubAttr_WordCnt(u16Index);

    switch (u16WordCnt)
    {
        case 1:
        {
            u16 u16Data = ParaAttr16_GetInitVal(u16Index);

            pu16Buff[0] = W(u16Data);

            break;
        }
        case 2:
        {
            u32 u32Data = ParaAttr32_GetInitVal(u16Index);

#if HOST_ENDIAN == LITTLE_ENDIAN
            pu16Buff[0] = WL(u32Data);
            pu16Buff[1] = WH(u32Data);
#else  // HOST_ENDIAN == BIG_ENDIAN
            pu16Buff[1] = WL(u32Data);
            pu16Buff[0] = WH(u32Data);
#endif

            break;
        }
        case 4:
        {
            u64 u64Data = ParaAttr64_GetInitVal(u16Index);

#if HOST_ENDIAN == LITTLE_ENDIAN
            pu16Buff[0] = W0(u64Data);
            pu16Buff[1] = W1(u64Data);
            pu16Buff[2] = W2(u64Data);
            pu16Buff[3] = W3(u64Data);
#else  // HOST_ENDIAN == BIG_ENDIAN
            pu16Buff[3] = W0(u64Data);
            pu16Buff[2] = W1(u64Data);
            pu16Buff[1] = W2(u64Data);
            pu16Buff[0] = W3(u64Data);
#endif

            break;
        }
        default:
        {
            return;
        }
    }
}

static void ParaData_SetInitVal(u16 u16Index, u16* pu16Data)
{
    u16 u16ByteCnt = ParaSubAttr_ByteCnt(u16Index);

    memcpy(ParaAddr(u16Index), pu16Data, u16ByteCnt);

    if (ParaSubAttr_Mode(u16Index) == V_RW_M2)
    {
        memcpy(ParaAddrM2(u16Index), pu16Data, u16ByteCnt);
    }
}

para_rw_status_e ParaData_WriteFrom(u16 u16Index, u16* pu16Data)
{
    u16 u16WordCnt = 0;

    // 检查访问权限
    if (ParaSubAttr_Access(u16Index) < D.u16SysAccess)
    {
        return PARA_RW_NO_ACCESS;  // 无写入权限
    }

    // 检查读写权限
    if (ParaSubAttr_Mode(u16Index) == V_RO)
    {
        return PARA_RW_READ_ONLY;  // 只读
    }
    else if (ParaSubAttr_Mode(u16Index) == V_RW_M1)
    {
        if (D.eSysState == SYSTEM_STATE_OPERATION_ENABLE)
        {
            return PARA_RW_MODIFY_AT_STOP;  // 仅停机可改
        }
    }

    // 检查写入位置
    u16WordCnt = ParaSubAttr_WordCnt(u16Index);

    switch (u16WordCnt)
    {
        case 1:
        {
            u16 u16Min = ParaAttr16_GetMinVal(u16Index);
            u16 u16Max = ParaAttr16_GetMaxVal(u16Index);
            u16 u16Dat = *(u16*)pu16Data;

            if (ParaSubAttr_Sign(u16Index) == V_UNSI)
            {
                if (!INCLOSE(u16Dat, u16Min, u16Max))
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }
            }
            else
            {
                if (!INCLOSE((s16)u16Dat, (s16)u16Min, (s16)u16Max))
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }
            }

            break;
        }
        case 2:
        {
            u32 u32Min = ParaAttr32_GetMinVal(u16Index);
            u32 u32Max = ParaAttr32_GetMaxVal(u16Index);
            u32 u32Dat = *(u32*)pu16Data;

            if (ParaSubAttr_Sign(u16Index) == V_UNSI)
            {
                if (!INCLOSE(u32Dat, u32Min, u32Max))
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }
            }
            else
            {
                if (!INCLOSE((s32)u32Dat, (s32)u32Min, (s32)u32Max))
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }
            }

            break;
        }
        case 4:
        {
            u64 u64Min = ParaAttr64_GetMinVal(u16Index);
            u64 u64Max = ParaAttr64_GetMaxVal(u16Index);
            u64 u64Dat = *(u64*)pu16Data;

            if (ParaSubAttr_Sign(u16Index) == V_UNSI)
            {
                if (!INCLOSE(u64Dat, u64Min, u64Max))
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }
            }
            else
            {
                if (!INCLOSE((s64)u64Dat, (s64)u64Min, (s64)u64Max))
                {
                    return PARA_RW_ILLEGAL_VALUE;  // 超出范围
                }
            }

            break;
        }

        default:
        {
            return PARA_RW_ILLEGAL_ADDRESS;  // 地址未对齐
        }
    }

    // 用户检查
    para_rw_status_e eStatue = ParaData_UserCheck(u16Index, pu16Data);
    if (eStatue != PARA_RW_SUCCESS)
    {
        return eStatue;
    }

    u16 u16ByteCnt = ParaSubAttr_ByteCnt(u16Index);

    if (ParaSubAttr_Mode(u16Index) == V_RW_M2)
    {
        memcpy(ParaAddrM2(u16Index), pu16Data, u16ByteCnt);
        ParaStoreWr(u16Index, pu16Data);
    }
    else
    {
        memcpy(ParaAddr(u16Index), pu16Data, u16ByteCnt);
    }

    return PARA_RW_SUCCESS;
}

para_rw_status_e ParaData_ReadInto(u16 u16Index, u16* pu16Data)
{
    // 检查读取位置

    u16 u16WordCnt = ParaSubAttr_WordCnt(u16Index);

    if (u16WordCnt == 0)
    {
        return PARA_RW_ILLEGAL_ADDRESS;  // 地址未对齐
    }

    if (ParaSubAttr_Mode(u16Index) == V_RW_M2)
    {
        memcpy(pu16Data, ParaAddrM2(u16Index), u16WordCnt * 2);
    }
    else
    {
        memcpy(pu16Data, ParaAddr(u16Index), u16WordCnt * 2);
    }

    return PARA_RW_SUCCESS;
}

//

bool ParaStoreWr(u16 u16Index, u16* pu16Buff)
{
    return EEPROM_WriteBlock(ParaSubAttr_Offset(u16Index), (u8*)pu16Buff, ParaSubAttr_ByteCnt(u16Index));
}

bool ParaStoreRd(u16 u16Index, u16* pu16Buff)
{
    return EEPROM_ReadBlock(ParaSubAttr_Offset(u16Index), (u8*)pu16Buff, ParaSubAttr_ByteCnt(u16Index));
}

void ParaTblCreat(void)
{
}

void ParaTblInit(void)
{
    u16 au16InitVal[4];

    for (u16 u16ParaIndex = 0, u16WordCnt = 0; u16ParaIndex < PARATBL_SIZE; u16ParaIndex += ParaSubAttr_WordCnt(u16ParaIndex))
    {
        if (ParaSubAttr_Sync(u16ParaIndex) == V_SYNC)
        {
            if (ParaStoreRd(u16ParaIndex, au16InitVal) == false)
            {
                AlmSet(ERR_PARA_RW_ERR);
                ParaAttr_GetInitVal(u16ParaIndex, au16InitVal);
                ParaData_SetInitVal(u16ParaIndex, au16InitVal);
            }
            else
            {
                ParaData_SetInitVal(u16ParaIndex, au16InitVal);

                switch (u16ParaIndex)
                {
                    case PARA_INDEX_U32_DEV_SCHEME:
                    {
                        if (D.u32DevScheme != ParaAttr32_GetInitVal(PARA_INDEX_U32_DEV_SCHEME))
                        {
                            AlmSet(ERR_NEED_RESTORE);
                            break;
                        }
                    }

                    default:
                    {
                        break;
                    }
                }
            }
        }
        else  // V_NSYNC
        {
            ParaAttr_GetInitVal(u16ParaIndex, au16InitVal);
            ParaData_SetInitVal(u16ParaIndex, au16InitVal);
        }
    }
}

void ParaTblCycle(void)
{
    static ParaTblSts_e seParaTblSts = PARATBL_STATE_IDLE;
    static ParaTblCmd_e seParaTblCmd = PARATBL_CMD_NONE;

    static u16 u16ParaIndex = 0;

    u16 au16InitVal[4];

    if (seParaTblSts == PARATBL_STATE_IDLE)
    {
        seParaTblCmd = (ParaTblCmd_e) D.eParaTblCmd;
        u16ParaIndex = 0;
    }

    if (seParaTblSts != PARATBL_STATE_ERROR)
    {
        switch (seParaTblCmd)
        {
            case PARATBL_CMD_NONE:
            {
                break;
            }
            case PARATBL_CMD_RST_RSTABLE:
            {
                seParaTblSts = PARATBL_STATE_BUSY;

                if (ParaSubAttr_Cover(u16ParaIndex) == V_COV)
                {
                    ParaAttr_GetInitVal(u16ParaIndex, au16InitVal);

                    if (ParaStoreWr(u16ParaIndex, au16InitVal) == true)
                    {
                        ParaData_SetInitVal(u16ParaIndex, au16InitVal);
                        u16ParaIndex += ParaSubAttr_WordCnt(u16ParaIndex);
                    }
                    else
                    {
                        seParaTblSts = PARATBL_STATE_ERROR;
                    }
                }
                else
                {
                    u16ParaIndex += ParaSubAttr_WordCnt(u16ParaIndex);
                }

                if (u16ParaIndex > PARATBL_SIZE)
                {
                    AlmRst(ERR_NEED_RESTORE);
                    AlmSet(ERR_NEED_REBOOT);
                    seParaTblSts = PARATBL_STATE_SUCCESS;
                }

                break;
            }
            case PARATBL_CMD_RST_ALL:
            {
                seParaTblSts = PARATBL_STATE_BUSY;

                if (ParaSubAttr_Cover(u16ParaIndex) == V_SYNC)
                {
                    ParaAttr_GetInitVal(u16ParaIndex, au16InitVal);

                    if (ParaStoreWr(u16ParaIndex, au16InitVal) == true)
                    {
                        ParaData_SetInitVal(u16ParaIndex, au16InitVal);
                        u16ParaIndex += ParaSubAttr_WordCnt(u16ParaIndex);
                    }
                    else
                    {
                        seParaTblSts = PARATBL_STATE_ERROR;
                    }
                }
                else
                {
                    u16ParaIndex += ParaSubAttr_WordCnt(u16ParaIndex);
                }

                if (u16ParaIndex > PARATBL_SIZE)
                {
                    AlmRst(ERR_NEED_RESTORE);
                    AlmSet(ERR_NEED_REBOOT);
                    seParaTblSts = PARATBL_STATE_SUCCESS;
                }

                break;
            }
            case PARATBL_CMD_SAVE_ALL:
            {
                seParaTblSts = PARATBL_STATE_BUSY;

                if (ParaSubAttr_Cover(u16ParaIndex) == V_SYNC && ParaSubAttr_Mode(u16ParaIndex) != V_RW_M2)
                {
                    u16* pu16Data = ParaAddr(u16ParaIndex);

                    if (ParaStoreWr(u16ParaIndex, pu16Data) == true)
                    {
                        u16ParaIndex += ParaSubAttr_WordCnt(u16ParaIndex);
                    }
                    else
                    {
                        seParaTblSts = PARATBL_STATE_ERROR;
                    }
                }
                else
                {
                    u16ParaIndex += ParaSubAttr_WordCnt(u16ParaIndex);
                }

                if (u16ParaIndex > PARATBL_SIZE)
                {
                    seParaTblSts = PARATBL_STATE_SUCCESS;
                }

                break;
            }

            default:
            {
                seParaTblSts = PARATBL_STATE_SUCCESS;
                break;
            }
        }
    }

    // 持续至少1个扫描周期, 以确保可被Scope捕捉到
    D.eParaTblSts = seParaTblSts;

    switch (seParaTblSts)
    {
        case PARATBL_STATE_IDLE:
        case PARATBL_STATE_BUSY:
        {
            break;
        }
        case PARATBL_STATE_SUCCESS:
        {
            seParaTblSts  = PARATBL_STATE_IDLE;
            D.eParaTblCmd = PARATBL_CMD_NONE;
            break;
        }
        case PARATBL_STATE_ERROR:
        {
            seParaTblSts = PARATBL_STATE_IDLE;
            break;
        }
    }
}
