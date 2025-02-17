#ifndef __MCLIB_H__
#define __MCLIB_H__

#include "typebasic.h"

typedef struct {
    s16 Ia;
    s16 Ib;
    s16 Ic;
    s16 Ialpha;
    s16 Ibeta;
} mc_clarke_t;

typedef struct {
    s16 Ialpha;
    s16 Ibeta;
    s16 Id;
    s16 Iq;
    s16 theta;
} mc_park_t;

typedef struct {
    float Ualpha;
    float Ubeta;
    float Ta;
    float Tb;
    float Tc;
    u16   Umdc;
} mc_svgen_t;

void MC_SinCos(s16 angle, s16* sin_, s16* cos_);

void MC_Clarke(mc_clarke_t* this);
void MC_RevClarke(mc_clarke_t* this);
void MC_Park(mc_park_t* this);
void MC_RevPark(mc_park_t* this);
void MC_CirLim(mc_park_t* this);
void MC_Svgen(mc_svgen_t* this);

#endif  // !__MCLIB_H__
