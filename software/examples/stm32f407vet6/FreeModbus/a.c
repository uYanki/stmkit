#include "stdio.h"
#include "stdint.h"

#define HAL_DeltaTick   3000

#define SystemCoreClock 168e6

#define s32DeltaPos     (-207328)
#define s32EncRes       1e4

#define s32             int32_t

int main()
{
    s32 s32Tmp;

    s32Tmp = 60 * (s32)(100);
    s32Tmp = s32Tmp * (s32)s32DeltaPos * (s32)SystemCoreClock;
    s32Tmp = s32Tmp / (s32)s32EncRes / (s32)HAL_DeltaTick;

    printf("%d\n", s32Tmp);
}