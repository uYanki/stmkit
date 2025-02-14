#ifndef __DIDO_H__
#define __DIDO_H__

#include "bsp.h"
#include "paratbl.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define EXT_GEN_DO_SW (CONFIG_GEN_DO_NUM > 0)
#define EXT_GEN_DI_SW (CONFIG_GEN_DI_NUM > 0)

typedef enum {
    DI_LOGIC_HIGH,     ///< high level is valid
    DI_LOGIC_LOW,      ///< low level is valid
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
    DI_FUNC_PLC_I,  ///< 电平输入,I点
} di_func_e;

typedef enum {
    DO_FUNC_NONE,
    DO_FUNC_PLC_Q,     ///< 电平输出,Q点
    DO_FUNC_SYNC_DI0,  ///< 和DI0同步
    DO_FUNC_SYNC_DI1,  ///< 和DI1同步
    DO_FUNC_SYNC_DI2,  ///< 和DI2同步
    DO_FUNC_SYNC_DI3,  ///< 和DI3同步
    DO_FUNC_SYNC_DI4,  ///< 和DI4同步
    DO_FUNC_SYNC_DI5,  ///< 和DI5同步
} do_func_e;

#if CONFIG_GEN_DI_NUM > 0

typedef struct {
    u16 eFuncSel;     ///< 选中功能
    u16 u16FltrTime;  ///< 滤波时间
    u16 eLogicLevel;  ///< 逻辑电平
} extdi_config_t;

typedef struct {
    u16 au16FuncSel[CONFIG_GEN_DI_NUM];  ///< 选中功能
    u16 au16FltrCnt[CONFIG_GEN_DI_NUM];  ///< 滤波计数
    u16 u16RawInMsk;                     ///< 原始输入
    u16 u16FltrMsk;                      ///< 滤波后状态
} extdi_t;

#endif

#if CONFIG_GEN_DO_NUM > 0

typedef struct {
    u16 eFuncSel;     ///< 选中功能
    u16 eLogicLevel;  ///< 逻辑电平
} extdo_config_t;

typedef struct {
    u16  au16FuncSel[CONFIG_GEN_DO_NUM];  ///< 选中功能
    u16* pu16LogicMsk_o;                  ///< 逻辑状态
} extdo_t;

#endif

typedef struct {
    device_para_t* pDevicePara;

#if EXT_GEN_DI_SW
    extdi_t sExtDi;
#endif
#if EXT_GEN_DO_SW
    extdo_t sExtDo;
#endif

} dido_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void DiDoCreat(dido_t* pDiDo);
void DiDoInit(dido_t* pDiDo);
void DiDoCycle(dido_t* pDiDo);
void DiDoIsr(dido_t* pDiDo);

#ifdef __cplusplus
}
#endif

#endif
