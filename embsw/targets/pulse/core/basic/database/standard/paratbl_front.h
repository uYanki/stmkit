#ifndef __PARA_TABLE_H__
#define __PARA_TABLE_H__

#include "common.h"
#include "paraattr.h"
#include "paraidx.h"

#include "paratbl/storage.h"

#define PARATBL_SIZE (sizeof(device_para_t) / 2)

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
