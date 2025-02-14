#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <time.h>

#define TIM_CLK_FREQ_HZ 144000000

typedef float          f32;
typedef unsigned char  u8;
typedef unsigned short u16;
typedef unsigned int   u32;
typedef int            s32;

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <time.h>

#define TIM_CLK_FREQ_HZ 144000000

typedef float          f32;
typedef unsigned char  u8;
typedef unsigned short u16;
typedef unsigned int   u32;
typedef int            s32;

#define U32_MAX 0xFFFFFFFFUL

#define SCALE   10ull

/**
 * @brief
 * @param[in]  u32Freq unit: 0.1hz
 * @param[out] pu16Clkdiv
 * @param[out] pu16Reload
 */
void GetTimParaByFreq(u32 u32Freq, u16* pu16Clkdiv, u16* pu16Reload)
{
    u32 u32Mid = SCALE * TIM_CLK_FREQ_HZ / u32Freq;  // clkdiv x relaod
    u32 u32Err = 1;

    u32 u32Ref = u32Mid;

    u32  u32Clkdiv, u32Reload;
    bool bSymbolOpt = false;

    while (1)
    {
        //
        // 1<PSC<=65535
        // 0<ARR<=65535
        // TIMCLK=FREQ*(PSC+1)*(ARR+1)
        //

        // 0xFFFFFFFF / 0x10000 = 0xFFFF < 65536

        for (u32Clkdiv = (u32Ref / 65536) + 1; u32Clkdiv <= 0x10000; u32Clkdiv++)
        {
            if ((u32Ref % u32Clkdiv) == 0)
            {
                u32Reload = u32Ref / u32Clkdiv;

                *pu16Clkdiv = u32Clkdiv - 1;
                *pu16Reload = u32Reload - 1;

                return;
            }
        }

        //
        // 调整偏差, 直到找出可被整除的数值
        //

        if ((u32Mid <= (U32_MAX - u32Err)) && (bSymbolOpt == false))
        {
            u32Ref     = u32Mid + u32Err;  // 增大
            bSymbolOpt = true;
        }
        else if ((u32Mid >= u32Err) && (bSymbolOpt == true))
        {
            u32Ref     = u32Mid - u32Err;  // 减小
            bSymbolOpt = false;
            u32Err++;
        }
    }
}

int main()
{
    u16 clkdiv, reload;

    f32 frq_err_max = 0.f;
    u32 frq_ind;

    FILE* fp;  // 建立一个文件操作指针

    if (fopen_s(&fp, "array.h", "w") != 0)
    {
        printf("fail to open file\n");
        exit(0);  // 终止程序
    }

    fprintf(fp, "0.1hz, 0.1hz,   err(%%)\n");

    for (u32 frq = 1; frq < 10000; frq++)  // 期望频率
    {
        GetTimParaByFreq(frq, &clkdiv, &reload);

        u32 frq_out = SCALE * TIM_CLK_FREQ_HZ / (clkdiv + 1) / (reload + 1);  // 实际频率

        f32 frq_err = fabs((f32)frq_out - (f32)frq) / (f32)frq;  // 频率误差

        if (frq_err_max < frq_err)
        {
            frq_err_max = frq_err;
            frq_ind     = frq;
        }

        if (frq_out != frq)
        {
            // 实际频率, 期望频率, 误差百分比
            fprintf(fp, "%5d, %5d, %.6f\n", frq_out, frq, frq_err * 100);
        }
    }

    fclose(fp);

    printf("errmax = %.6f%% @ %d (0.1hz)", frq_err_max * 100, frq_ind);

    return 0;
}
