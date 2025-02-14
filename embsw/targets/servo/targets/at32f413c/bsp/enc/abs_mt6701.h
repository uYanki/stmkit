#ifndef __ABS_MT6701_H__
#define __ABS_MT6701_H__

#include "bsp.h"

typedef struct {
    u8  u8CommSts;  // 通讯状态
    u8  au8RxData[3];
    u32 u32Pos;
} abs_mt6701_t;

void MT6701RdPos(abs_mt6701_t* pMT6701);

#endif  // !__ABS_MT6701_H__
