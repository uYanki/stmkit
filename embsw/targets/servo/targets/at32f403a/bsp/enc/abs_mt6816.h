#ifndef __ABS_MT6816_H__
#define __ABS_MT6816_H__

#include "sdkinc.h"
#include "bsp.h"

typedef struct {
    u8  u8CommSts;  // 通讯状态
    u32 u32Pos;
} abs_mt6816_t;

#endif  // !__ABS_MT6816_H__
