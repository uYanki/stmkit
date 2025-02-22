#ifndef __LPF_H__
#define __LPF_H__

#include "typebasic.h"

typedef struct {
    s32* x0;  ///< x(n)
    s32  y0;  ///< y(n)
    s32  y1;  ///< y(n-1)
    s32  Ts;  ///< 采样频率 unit：0.1us
    s32  Tc;  ///< 截止频率 unit：0.1us
    s64  diff;
} lpf_s32_t;

typedef struct {
    s16* x0;  ///< x(n)
    s16  y0;  ///< y(n)
    s16  y1;  ///< y(n-1)
    s32  Ts;  ///< 采样频率 unit：0.1us
    s32  Tc;  ///< 截止频率 unit：0.1us
    s32  diff;
} lpf_s16_t;

/**
 * @brief 一阶低通
 *
 *   y(n) = a x(n) + (1-a) y(n-1)
 *        = a (x(n) - y(n-1)) + y(n-1)
 *
 *   a = 1/(1+Tc/Ts)
 *
 *   => y(n) = (x(n) - y(n-1)) * Ts/(Ts+Tc) + y(n-1)
 *
 */

#define LpfInit(pFltr)   \
    do {                 \
        pFltr->y0   = 0; \
        pFltr->y1   = 0; \
        pFltr->diff = 0; \
    } while (0)

#define LpfProc(pFltr)                                                             \
    do {                                                                           \
        if (pFltr->Ts == 0)                                                        \
        {                                                                          \
            pFltr->y0 = *pFltr->x0;                                                \
            break;                                                                 \
        }                                                                          \
        pFltr->diff = *pFltr->x0 - pFltr->y1;                                      \
        if (pFltr->diff == 0)                                                      \
        {                                                                          \
            break;                                                                 \
        }                                                                          \
        pFltr->y0 = pFltr->diff * pFltr->Ts / (pFltr->Tc + pFltr->Ts) + pFltr->y1; \
        pFltr->y1 = pFltr->y0;                                                     \
    } while (0)

#endif  // !__LPF_H__
