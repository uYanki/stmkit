#ifndef __DIDO_H__
#define __DIDO_H__

#include "bsp.h"
#include "axis.h"
#include "paratbl.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define EXT_GEN_DO_SW (CONFIG_GEN_DO_NUM > 0)
#define EXT_GEN_DI_SW (CONFIG_GEN_DI_NUM > 0)
#define VIR_DO_SW     (CONFIG_VIRTUAL_DO_NUM > 0)
#define VIR_DI_SW     (CONFIG_VIRTUAL_DI_NUM > 0)

typedef enum {
    DI_SRC_EXT,
    DI_SRC_VIR,
} di_src_e;

typedef enum {
    DO_SRC_EXT,
    DO_SRC_VIR,
} do_src_e;

typedef enum {
    DI_LOGIC_LOW,      ///< low level is valid
    DI_LOGIC_HIGH,     ///< high level is valid
    DI_LOGIC_UP_EDGE,  ///< up edge is valid
    DI_LOGIC_DN_EDGE,  ///< down edge is valid
    DI_LOGIC_EDGE,     ///< both low and high edge is valid
} di_logic_e;

typedef enum {
    DO_LOGIC_HIGH,  ///< high level is valid
    DO_LOGIC_LOW,   ///< low level is valid
} do_logic_e;

typedef enum {
    DI_FUNC_NONE,
    DI_FUNC_PLC_I,         ///< 电平输入,I点
    DI_FUNC_QUICK_STOP,    ///< 急停
    DI_FUNC_ALM_CLR,       ///< 清除报警
    DI_FUNC_JOG_FWD,       ///< 正向点动
    DI_FUNC_JOG_REV,       ///< 反向点动
    DI_FUNC_POS_LIM_FWD,   ///< 正向限位
    DI_FUNC_POS_LIM_REV,   ///< 反向限位
    DI_FUNC_ENC_TURN_CLR,  ///< 多圈清除
} di_func_e;

typedef enum {
    DO_FUNC_NONE,
    DO_FUNC_PLC_Q,         ///< 电平输出,Q点
    DO_FUNC_AXIS_ENABLE,   ///< 伺服使能
    DO_FUNC_ALM,           ///< 存在报警
    DO_FUNC_TARGET_REACH,  ///< 目标到达(转矩/速度/位置)
} do_func_e;

#if CONFIG_GEN_DI_NUM > 0

typedef struct {
    u16 u16FuncSel;     ///< 选中功能
    u16 u16FltrTime;    ///< 滤波时间
    u16 u16LogicLevel;  ///< 逻辑电平
} extdi_config_t;

typedef struct {
    RO extdi_config_t* aConfig[CONFIG_GEN_DI_NUM];  ///< 端子配置

    u16  au16FuncSel[CONFIG_GEN_DI_NUM];  ///< 选中功能
    u16  au16FltrCnt[CONFIG_GEN_DI_NUM];  ///< 滤波计数
    u16  u16RawInMsk;                     ///< 原始输入
    u16  u16FltrMsk;                      ///< 滤波后状态
    u16* pu16LogicMsk_o;                  ///< 逻辑状态

    u32 u32CtrlWord;
} extdi_t;

#endif

#if CONFIG_GEN_DO_NUM > 0

typedef struct {
    u16 u16FuncSel;     ///< 选中功能
    u16 u16LogicLevel;  ///< 逻辑电平
} extdo_config_t;

typedef struct {
    RO extdo_config_t* aConfig[CONFIG_GEN_DO_NUM];

    u16  au16FuncSel[CONFIG_GEN_DO_NUM];  ///< 选中功能
    u16* pu16LogicMsk_o;                  ///< 逻辑状态
} extdo_t;

#endif

#if VIR_DI_SW

typedef struct {
    u16 u16FuncSel;     ///< 选中功能
    u16 u16LogicLevel;  ///< 逻辑电平
} virdi_config_t;

typedef struct {
    RO virdi_config_t* aConfig[CONFIG_VIRTUAL_DI_NUM];  ///< 端子配置

    u16     au16FuncSel[CONFIG_VIRTUAL_DI_NUM];  ///< 选中功能
    RO u16* pu16SetMsk_i;                        ///< 设定值
    u16*    pu16LogicMsk_o;                      ///< 逻辑状态

    u32 u32CtrlWord;
} virdi_t;

#endif

#if VIR_DO_SW

typedef struct {
    u16 u16FuncSel;     ///< 选中功能
    u16 u16LogicLevel;  ///< 逻辑电平
} virdo_config_t;

typedef struct {
    RO virdo_config_t* aConfig[CONFIG_VIRTUAL_DO_NUM];  ///< 端子配置

    u16     au16FuncSel[CONFIG_VIRTUAL_DO_NUM];  ///< 选中功能
    RO u16* pu16SetMsk_i;                        ///< 设定值
    u16*    pu16LogicMsk_o;                      ///< 逻辑状态
} virdo_t;

#endif

typedef struct {
    RO di_src_e* peDiSrc_i;
    RO do_src_e* peDoSrc_i;

    u32* pu32CtrlWord_o;

#if EXT_GEN_DI_SW
    extdi_t sExtDi;
#endif
#if EXT_GEN_DO_SW
    extdo_t sExtDo;
#endif
#if VIR_DI_SW
    virdi_t sVirDi;
#endif
#if VIR_DO_SW  // 自定义状态字
    virdo_t sVirDo;
#endif

} dido_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void DiDoCreat(dido_t* pDiDo, axis_para_t* pAxisPara);
void DiDoInit(dido_t* pDiDo);
void DiDoCycle(dido_t* pDiDo);
void DiDoIsr(dido_t* pDiDo);

#ifdef __cplusplus
}
#endif

#endif
