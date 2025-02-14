#include "dido.h"
#include "alarm.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "dido"
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

#if EXT_GEN_DI_SW

static bool ExtDi(extdi_t* pExtDi)
{
    device_para_t* pDevicePara = &D;

    u32 u32FuncSet = 0;  ///< 功能选中状态

    for (u8 i = 0; i < CONFIG_GEN_DI_NUM; ++i)
    {
        RO extdi_config_t* pConfig = (extdi_config_t*)&pDevicePara->eDi0FuncSel + i;

        if (pExtDi->au16FuncSel[i] != pConfig->eFuncSel)
        {
            // 功能变更，清除已生效的状态
            pExtDi->au16FuncSel[i] = pConfig->eFuncSel;
        }

        if (pConfig->eFuncSel != DI_FUNC_NONE)
        {
            if (pConfig->eFuncSel > DI_FUNC_PLC_I)
            {
                // 功能配置冲突
                if (CHKBIT(u32FuncSet, pConfig->eFuncSel - DI_FUNC_PLC_I))
                {
                    AlmSet(ERR_DI_FUNC_CONFLICT);
                    return false;
                }
                else
                {
                    SETBIT(u32FuncSet, pConfig->eFuncSel - DI_FUNC_PLC_I);
                    AlmRst(ERR_DI_FUNC_CONFLICT);
                }
            }

            // 输入滤波 (持续N个主中断周期)
            if (PinGetLvl((pin_no_e)(DI0_PIN_I + i)) == B_ON)
            {
                if (CHKBIT(pExtDi->u16RawInMsk, i) == 0)
                {
                    SETBIT(pExtDi->u16RawInMsk, i);
                    pExtDi->au16FltrCnt[i] = 0;
                }

                if (++pExtDi->au16FltrCnt[i] > pConfig->u16FltrTime)
                {
                    SETBIT(pExtDi->u16FltrMsk, i);
                    pExtDi->au16FltrCnt[i] = 0;
                }
            }
            else  // B_OFF
            {
                if (CHKBIT(pExtDi->u16RawInMsk, i) == 1)
                {
                    CLRBIT(pExtDi->u16RawInMsk, i);
                    pExtDi->au16FltrCnt[i] = 0;
                }

                if (++pExtDi->au16FltrCnt[i] > pConfig->u16FltrTime)
                {
                    CLRBIT(pExtDi->u16FltrMsk, i);
                    pExtDi->au16FltrCnt[i] = 0;
                }
            }

            // 检查逻辑电平
            switch ((di_logic_e)(pConfig->eLogicLevel))
            {
                case DI_LOGIC_LOW:
                {
                    if (CHKBIT(pExtDi->u16FltrMsk, i) == 0)
                    {
                        SETBIT(pDevicePara->u16DiState, i);
                    }
                    else
                    {
                        CLRBIT(pDevicePara->u16DiState, i);
                    }

                    break;
                }
                case DI_LOGIC_HIGH:
                {
                    if (CHKBIT(pExtDi->u16FltrMsk, i) == 1)
                    {
                        SETBIT(pDevicePara->u16DiState, i);
                    }
                    else
                    {
                        CLRBIT(pDevicePara->u16DiState, i);
                    }

                    break;
                }
                case DI_LOGIC_UP_EDGE:
                case DI_LOGIC_DN_EDGE:
                case DI_LOGIC_EDGE:
                default:
                {
                    break;
                }
            }
        }
    }

    return true;
}

#endif

#if EXT_GEN_DO_SW

static bool ExtDo(extdo_t* pExtDo)
{
    device_para_t* pDevicePara = &D;

    u32 u32FuncSet   = 0;  ///< 功能选中状态
    u16 u16RawOutMsk = 0;  ///< 逻辑状态

    for (u8 i = 0; i < CONFIG_GEN_DO_NUM; ++i)
    {
        RO extdo_config_t* pConfig = (extdo_config_t*)&pDevicePara->eDo0FuncSel + i;

        if (pConfig->eFuncSel != 0)
        {
            if (pConfig->eFuncSel > DO_FUNC_PLC_Q)
            {
                // 功能配置冲突
                if (CHKBIT(u32FuncSet, pConfig->eFuncSel - DO_FUNC_PLC_Q))
                {
                    AlmSet(ERR_DO_FUNC_CONFLICT);
                    return false;
                }
                else
                {
                    SETBIT(u32FuncSet, pConfig->eFuncSel - DO_FUNC_PLC_Q);
                    AlmRst(ERR_DO_FUNC_CONFLICT);
                }
            }

            switch ((do_func_e)pConfig->eFuncSel)
            {
                case DO_FUNC_PLC_Q:
                {
                    if (CHKBIT(D.u16DoStateSet, i))
                    {
                        SETBIT(pDevicePara->u16DoState, i);
                    }
                    else
                    {
                        CLRBIT(pDevicePara->u16DoState, i);
                    }

                    break;
                }
                case DO_FUNC_SYNC_DI0:
                case DO_FUNC_SYNC_DI1:
                case DO_FUNC_SYNC_DI2:
                case DO_FUNC_SYNC_DI3:
                case DO_FUNC_SYNC_DI4:
                case DO_FUNC_SYNC_DI5:
                {
                    if (CHKBIT(D.u16DiState, (pConfig->eFuncSel - DO_FUNC_SYNC_DI0)) == 1)
                    {
                        SETBIT(pDevicePara->u16DoState, i);
                    }
                    else
                    {
                        CLRBIT(pDevicePara->u16DoState, i);
                    }

                    break;
                }
            }

            switch ((do_logic_e)(pConfig->eLogicLevel))
            {
                case DO_LOGIC_LOW:
                {
                    if (CHKBIT(pDevicePara->u16DoState, i) == 0)
                    {
                        SETBIT(u16RawOutMsk, i);
                    }
                    else
                    {
                        CLRBIT(u16RawOutMsk, i);
                    }

                    break;
                }
                case DO_LOGIC_HIGH:
                {
                    if (CHKBIT(pDevicePara->u16DoState, i) == 1)
                    {
                        SETBIT(u16RawOutMsk, i);
                    }
                    else
                    {
                        CLRBIT(u16RawOutMsk, i);
                    }

                    break;
                }
                default:
                {
                    break;
                }
            }

            PinSetLvl((pin_no_e)(DO0_PIN_O + i), CHKBIT(u16RawOutMsk, i) ? B_ON : B_OFF);
        }
    }

    return true;
}

#endif

void DiDoCreat(dido_t* pDiDo)
{
    pDiDo->pDevicePara = &D;
}

void DiDoInit(dido_t* pDiDo)
{
}

void DiDoCycle(dido_t* pDiDo)
{
}

void DiDoIsr(dido_t* pDiDo)
{
#if EXT_GEN_DI_SW
    ExtDi(&pDiDo->sExtDi);
#endif
#if EXT_GEN_DO_SW
    ExtDo(&pDiDo->sExtDo);
#endif
}
