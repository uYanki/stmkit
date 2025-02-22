#include "dido.h"

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

static void ExtDiFunc(extdi_t* pExtDi, di_func_e eFuncSel, bool bState)
{
    switch (eFuncSel)
    {
        case DI_FUNC_PLC_I:
        {
            break;
        }

        default:
        {
            if (bState)
            {
                SETBIT(pExtDi->u32CtrlWord, eFuncSel - 1);
            }
            else
            {
                CLRBIT(pExtDi->u32CtrlWord, eFuncSel - 1);
            }

            break;
        }
    }
}

static bool ExtDi(extdi_t* pExtDi)
{
    u32 u32FuncSet = 0;  ///< 功能选中状态

    u16* pu16InputMsk = &pExtDi->u16RawInMsk;    // 原始输入
    u16* pu16FltrMsk  = &pExtDi->u16FltrMsk;     // 滤波后
    u16* pu16LogicMsk = pExtDi->pu16LogicMsk_o;  // 逻辑状态

    u16* au16FuncSel = pExtDi->au16FuncSel;
    u16* au16FltrCnt = pExtDi->au16FltrCnt;

    for (u8 i = 0; i < CONFIG_GEN_DI_NUM; ++i)
    {
        RO extdi_config_t* pConfig = pExtDi->aConfig[i];

        if (au16FuncSel[i] != pConfig->u16FuncSel)
        {
            // 功能变更，清除已生效的状态
            ExtDiFunc(pExtDi, (di_func_e)au16FuncSel[i], false);
            au16FuncSel[i] = pConfig->u16FuncSel;
        }

        if (pConfig->u16FuncSel != 0)
        {
            // 功能配置冲突
            if (CHKBIT(u32FuncSet, pConfig->u16FuncSel - 1))
            {
                ExtDiFunc(pExtDi, (di_func_e)au16FuncSel[i], false);
                // TODO: AlmSet(ERR_DI_FUNC_CONFLICT);
                return false;
            }
            else
            {
                SETBIT(u32FuncSet, pConfig->u16FuncSel - 1);
                // TODO: AlmClr(ERR_DI_FUNC_CONFLICT);
            }

            // 输入滤波 (持续N个载波周期)
            if (PinGetLvl((pin_no_e)(DI0_PIN_I + i)) == B_ON)
            {
                if (CHKBIT(*pu16InputMsk, i) == 0)
                {
                    SETBIT(*pu16InputMsk, i);
                    au16FltrCnt[i] = 0;
                }

                if (++au16FltrCnt[i] > pConfig->u16FltrTime)
                {
                    SETBIT(*pu16FltrMsk, i);
                    au16FltrCnt[i] = 0;
                }
            }
            else  // B_OFF
            {
                if (CHKBIT(*pu16InputMsk, i) == 1)
                {
                    CLRBIT(*pu16InputMsk, i);
                    au16FltrCnt[i] = 0;
                }

                if (++au16FltrCnt[i] > pConfig->u16FltrTime)
                {
                    CLRBIT(*pu16FltrMsk, i);
                    au16FltrCnt[i] = 0;
                }
            }

            // 检查逻辑电平
            switch ((di_logic_e)(pConfig->u16LogicLevel))
            {
                case DI_LOGIC_LOW:
                {
                    if (CHKBIT(*pu16FltrMsk, i) == 1)
                    {
                        SETBIT(*pu16LogicMsk, i);
                    }
                    else
                    {
                        CLRBIT(*pu16LogicMsk, i);
                    }

                    break;
                }
                case DI_LOGIC_HIGH:
                {
                    if (CHKBIT(*pu16FltrMsk, i) == 0)
                    {
                        SETBIT(*pu16LogicMsk, i);
                    }
                    else
                    {
                        CLRBIT(*pu16LogicMsk, i);
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

            // 变更功能状态
            ExtDiFunc(pExtDi, (di_func_e)pConfig->u16FuncSel, CHKBIT(*pu16LogicMsk, i) ? true : false);
        }
    }

    return true;
}

#endif

#if EXT_GEN_DO_SW  // TODO

static void ExtDoFunc(extdo_t* pExtDi, do_func_e eFuncSel, bool bState)
{
    switch (eFuncSel)
    {
        case DO_FUNC_PLC_Q:
        {
            break;
        }

        default:
        {
            break;
        }
    }
}

static bool ExtDo(extdo_t* pExtDo)
{
    return false;
}

#endif

#if VIR_DI_SW

static void VirDiFunc(virdi_t* pVirDi, di_func_e eFuncSel, bool bState)
{
    if (bState)
    {
        SETBIT(pVirDi->u32CtrlWord, eFuncSel - 1);
    }
    else
    {
        CLRBIT(pVirDi->u32CtrlWord, eFuncSel - 1);
    }
}

static bool VirDi(virdi_t* pVirDi)
{
    u32 u32FuncSet = 0;  ///< 功能选中状态

    RO u16* pu16InputMsk = pVirDi->pu16SetMsk_i;    // 原始输入
    u16*    pu16LogicMsk = pVirDi->pu16LogicMsk_o;  // 逻辑状态

    u16* au16FuncSel = pVirDi->au16FuncSel;

    for (u8 i = 0; i < CONFIG_VIRTUAL_DI_NUM; ++i)
    {
        RO virdi_config_t* pConfig = pVirDi->aConfig[i];

        if (pConfig->u16FuncSel != au16FuncSel[i])
        {
            // 功能变更，清除已生效的状态
            VirDiFunc(pVirDi, (di_func_e)au16FuncSel[i], false);
            au16FuncSel[i] = pConfig->u16FuncSel;
        }

        if (pConfig->u16FuncSel != 0)
        {
            // 功能配置冲突
            if (CHKBIT(u32FuncSet, pConfig->u16FuncSel - 1))
            {
                VirDiFunc(pVirDi, (di_func_e)pConfig->u16FuncSel, false);
                // TODO: AlmSet(ERR_DI_FUNC_CONFLICT);
                return false;
            }
            else
            {
                SETBIT(u32FuncSet, pConfig->u16FuncSel - 1);
                // TODO: AlmClr(ERR_DI_FUNC_CONFLICT);
            }

            // 检查逻辑电平
            switch ((di_logic_e)(pConfig->u16LogicLevel))
            {
                case DI_LOGIC_LOW:
                {
                    if (CHKBIT(*pu16InputMsk, i) == 1)
                    {
                        SETBIT(*pu16LogicMsk, i);
                    }
                    else
                    {
                        CLRBIT(*pu16LogicMsk, i);
                    }

                    break;
                }
                case DI_LOGIC_HIGH:
                {
                    if (CHKBIT(*pu16InputMsk, i) == 0)
                    {
                        SETBIT(*pu16LogicMsk, i);
                    }
                    else
                    {
                        CLRBIT(*pu16LogicMsk, i);
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

            // 变更功能状态
            VirDiFunc(pVirDi, (di_func_e)pConfig->u16FuncSel, CHKBIT(*pu16LogicMsk, i) ? true : false);
        }
    }

    return true;
}

#endif

#if VIR_DO_SW  // TODO

static bool VirDo(virdo_t* pVirDo)
{
    return false;
}

#endif

void DiDoCreat(dido_t* pDiDo, axis_para_t* pAxisPara)
{
    u8 i;

    pDiDo->peDiSrc_i = (RO di_src_e*)&pAxisPara->eDiSrc;
    pDiDo->peDoSrc_i = (RO do_src_e*)&pAxisPara->eDoSrc;

    // 选DiDo命令字!!
    pDiDo->pu32CtrlWord_o = &pAxisPara->u32DiCmd;

#if EXT_GEN_DI_SW

    extdi_t* pExtDi = &pDiDo->sExtDi;

    // pExtDi->pu16LogicMsk_o;

    for (i = 0; i < CONFIG_GEN_DI_NUM; ++i)
    {
        // pExtDi->aConfig[i];
    }

#endif

#if EXT_GEN_DO_SW

    extdo_t* pExtDo = &pDiDo->sExtDo;

    // pExtDo->pu16LogicMsk_o;

    for (i = 0; i < CONFIG_GEN_DO_NUM; ++i)
    {
        // pExtDo->aConfig[i];
    }

#endif

#if VIR_DI_SW

    virdi_t* pVirDi = &pDiDo->sVirDi;

    pVirDi->pu16SetMsk_i;
    pVirDi->pu16LogicMsk_o;

    for (i = 0; i < CONFIG_VIRTUAL_DI_NUM; ++i)
    {
        pVirDi->aConfig[i];
    }

#endif

#if VIR_DO_SW

    virdo_t* pVirDo = &pDiDo->sVirDo;

    pVirDo->pu16SetMsk_i;    ///< 设定值
    pVirDo->pu16LogicMsk_o;  ///< 逻辑状态

    for (i = 0; i < CONFIG_VIRTUAL_DO_NUM; ++i)
    {
        pVirDo->aConfig[i];
    }

#endif
}

void DiDoInit(dido_t* pDiDo)
{
}

void DiDoCycle(dido_t* pDiDo)
{
#if VIR_DI_SW
    if (*pDiDo->peDiSrc_i == DI_SRC_VIR)
    {
        virdi_t* pVirDi = &pDiDo->sVirDi;
        VirDi(pVirDi);
    }
#endif
#if VIR_DO_SW
    if (*pDiDo->peDoSrc_i == DO_SRC_VIR)
    {
        virdo_t* pVirDo = &pDiDo->sVirDo;
        VirDo(pVirDo);
    }
#endif
}

void DiDoIsr(dido_t* pDiDo)
{
#if EXT_GEN_DI_SW
    if (*pDiDo->peDiSrc_i == DI_SRC_EXT)
    {
        extdi_t* pExtDi = &pDiDo->sExtDi;
        ExtDi(pExtDi);
    }
#endif
#if EXT_GEN_DO_SW
    if (*pDiDo->peDoSrc_i == DO_SRC_EXT)
    {
        extdo_t* pExtDo = &pDiDo->sExtDo;
        ExtDo(pExtDo);
    }
#endif
}
