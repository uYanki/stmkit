#ifndef __CUR_SAMP_H__
#define __CUR_SAMP_H__

#include "paratbl.h"
#include "bsp.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define CONFIG_CUR_ZERO_DRIFT_SAMP_TIME 16u  // 零偏电流采样次数

// clang-format off

#define CUR_SAMP_PHASE_U_SW                            \
    ((CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UV_LINE    ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UW_LINE    ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_LINE   ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UV_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UW_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_DOWN_BRG))

#define CUR_SAMP_PHASE_V_SW                            \
    ((CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UV_LINE    ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_VW_LINE    ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_LINE   ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UV_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_VW_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_DOWN_BRG))

#define CUR_SAMP_PHASE_W_SW                            \
    ((CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UW_LINE    ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_VW_LINE    ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_LINE   ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UW_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_VW_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_DOWN_BRG))

#define CUR_SAMP_LINE_SW                            \
    ((CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UV_LINE ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_VW_LINE ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UW_LINE ) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_LINE))

#define CUR_SAMP_DOWN_BRG_SW                           \
    ((CONFIG_CUR_SAMP_TYPE == CUR_SAMP_S_DOWN_BRG)  || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UV_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_VW_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UW_DOWN_BRG) || \
     (CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_DOWN_BRG))

// clang-format on

typedef struct {
    axis_para_t* pAxisPara;

    RO system_state_e* cpeSysSts;  ///< 系统状态

#if CUR_SAMP_DOWN_BRG_SW
    RO sector_e* cpeSector;  ///< 空间矢量扇区
#endif

    RO u16* cpu16IphHwCoeff;  ///< 相电流硬件系数
    RO u16* cpu16IphZoom;     ///< 电流缩放千分比
    RO s16* cps16IaOffset;    ///< 电流偏置值 <Q15>
    RO s16* cps16IbOffset;    ///< 电流偏置值 <Q15>
    RO s16* cps16IcOffset;    ///< 电流偏置值 <Q15>

    s16* ps16IaPu;  ///< 电流标幺值 <Q15>
    s16* ps16IbPu;  ///< 电流标幺值 <Q15>
    s16* ps16IcPu;  ///< 电流标幺值 <Q15>

    s16* ps16IaSi;  ///< 电流物理值 <SI>
    s16* ps16IbSi;  ///< 电流物理值 <SI>
    s16* ps16IcSi;  ///< 电流物理值 <SI>

    s16* ps16IaZero;  ///< 电流零漂值 <Q15>
    s16* ps16IbZero;  ///< 电流零漂值 <Q15>
    s16* ps16IcZero;  ///< 电流零漂值 <Q15>

#if CONFIG_BOOTSTRAP_SW
    bool bChargeOver;  ///< 自举充电完成标志
#endif

    s32  s32IaZeroDriftSum;  ///< 电流零漂值总和
    s32  s32IbZeroDriftSum;  ///< 电流零漂值总和
    s32  s32IcZeroDriftSum;  ///< 电流零漂值总和
    u32  u32ZeroDriftCnt;    ///< 电流零漂采集次数
    bool bZeroDriftOver;     ///< 电流零漂采集完成标志

} cur_samp_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void CurSampCreat(cur_samp_t* pCurSamp, axis_para_t* pAxisPara);
void CurSampInit(cur_samp_t* pCurSamp);
void CurSampCycle(cur_samp_t* pCurSamp);
void CurSampIsr(cur_samp_t* pCurSamp);

#ifdef __cplusplus
}
#endif

#endif
