#ifndef __PARA_TABLE_H__
#define __PARA_TABLE_H__

#include "paraattr.h"
#include "axis_defs.h"
#include "arm_math.h"

// https://www.armbbs.cn/forum.php?mod=viewthread
// https://www.cnblogs.com/CodeWorkerLiMing/p/12076701.html

/**
 * @note #pragma pack(x)
 *
 * GCC手册: 6.62.11 Structure-Layout Pragmas
 * For compatibility with Microsoft Windows compilers, GCC supports a set of #pragma directives that change the maximum alignment of members of structures (other than zero-width
 * bit-fields), unions, and classes subsequently defined. The n value below always is required
 * to be a small power of two and specifies the new alignment in bytes.
 *
 * 该指令改变结构成员的最大对齐方式
 *
 * @note __packed typedef struct {} info_t;
 *
 * __packed 的作用是取消字节对齐。
 *
 * @note M0/M0+/M1 不支持32位/64位的非对齐访问（直接访问会触发硬件异常），M3/M4/M7 可以直接访问非对齐地址。
 *
 */

#define ARM_CORTEX_M0   0
#define ARM_CORTEX_M0P  1
#define ARM_CORTEX_M1P  2

#define ARM_CORTEX_M3   3
#define ARM_CORTEX_M4   4
#define ARM_CORTEX_M7   5

#define ARM_CORTEX      ARM_CORTEX_M0P

#define __ALIGNED_BYTE  1
#define __ALIGNED_WORD  2
#define __ALIGNED_DWORD 4
#define __ALIGNED_QWORD 8

#if (ARM_CORTEX == ARM_CORTEX_M0 || ARM_CORTEX == ARM_CORTEX_M0P || ARM_CORTEX == ARM_CORTEX_M1P)
// #define __PARATBL_MEMBER_ALIGNED __ALIGNED_DWORD  // 4字节对齐
#elif (ARM_CORTEX == ARM_CORTEX_M3 || ARM_CORTEX == ARM_CORTEX_M4 || ARM_CORTEX == ARM_CORTEX_M7)
// #define __PARATBL_MEMBER_ALIGNED __ALIGNED_WORD
#endif

#if 0

(((s|u)\d\d)\w+_i)\(eAxisNo\)  =>  __get_$2(pSpdCtrl->p$1)
(((s|u)\d\d)\w+_o)\(eAxisNo\) +?=(.*?);   =>   __set_$2(pSpdCtrl->p$1,$4);

#endif

// clang-format off

static inline s64 __get_s64(s64* p) { return (s64)he64((const u8*)p); }
static inline u64 __get_u64(u64* p) { return (u64)he64((const u8*)p); }

static inline void __set_s64(s64* p, s64 x) { memcpy((u8*)p, &x, sizeof(x)); }
static inline void __set_u64(u64* p, u64 x) { memcpy((u8*)p, &x, sizeof(x)); }

// clang-format on