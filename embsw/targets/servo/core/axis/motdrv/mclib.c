#include "mclib.h"
#include "paratbl.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define SIN_MASK       0x0300
#define U0_90          0x0200
#define U90_180        0x0300
#define U180_270       0x0000
#define U270_360       0x0100

#define Q15_MAX        32767

#define START_INDEX    63

#define M_Q15_INVSQRT3 (s16)(0.5773502691 * Q15_MAX)
#define M_Q15_SQRT3_2  (s16)(0.86602540378443 * Q15_MAX)
#define M_Q15_1_2      (s16)(0.5 * Q15_MAX)

#define Q15Mul(q1, q2) (s16)((s32)(q1) * (s32)(q2) / Q15_MAX)

#define M_INVSQRT3_Q15 18918  // [Q1.15] 1/sqrt(3)
#define M_INV3_Q15     10922  // [Q1.15] 1/3

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static RO s16 aSinTbl[256] = {
    0x0000, 0x00C9, 0x0192, 0x025B, 0x0324, 0x03ED, 0x04B6, 0x057F,
    0x0648, 0x0711, 0x07D9, 0x08A2, 0x096A, 0x0A33, 0x0AFB, 0x0BC4,
    0x0C8C, 0x0D54, 0x0E1C, 0x0EE3, 0x0FAB, 0x1072, 0x113A, 0x1201,
    0x12C8, 0x138F, 0x1455, 0x151C, 0x15E2, 0x16A8, 0x176E, 0x1833,
    0x18F9, 0x19BE, 0x1A82, 0x1B47, 0x1C0B, 0x1CCF, 0x1D93, 0x1E57,
    0x1F1A, 0x1FDD, 0x209F, 0x2161, 0x2223, 0x22E5, 0x23A6, 0x2467,
    0x2528, 0x25E8, 0x26A8, 0x2767, 0x2826, 0x28E5, 0x29A3, 0x2A61,
    0x2B1F, 0x2BDC, 0x2C99, 0x2D55, 0x2E11, 0x2ECC, 0x2F87, 0x3041,
    0x30FB, 0x31B5, 0x326E, 0x3326, 0x33DF, 0x3496, 0x354D, 0x3604,
    0x36BA, 0x376F, 0x3824, 0x38D9, 0x398C, 0x3A40, 0x3AF2, 0x3BA5,
    0x3C56, 0x3D07, 0x3DB8, 0x3E68, 0x3F17, 0x3FC5, 0x4073, 0x4121,
    0x41CE, 0x427A, 0x4325, 0x43D0, 0x447A, 0x4524, 0x45CD, 0x4675,
    0x471C, 0x47C3, 0x4869, 0x490F, 0x49B4, 0x4A58, 0x4AFB, 0x4B9D,
    0x4C3F, 0x4CE0, 0x4D81, 0x4E20, 0x4EBF, 0x4F5D, 0x4FFB, 0x5097,
    0x5133, 0x51CE, 0x5268, 0x5302, 0x539B, 0x5432, 0x54C9, 0x5560,
    0x55F5, 0x568A, 0x571D, 0x57B0, 0x5842, 0x58D3, 0x5964, 0x59F3,
    0x5A82, 0x5B0F, 0x5B9C, 0x5C28, 0x5CB3, 0x5D3E, 0x5DC7, 0x5E4F,
    0x5ED7, 0x5F5D, 0x5FE3, 0x6068, 0x60EB, 0x616E, 0x61F0, 0x6271,
    0x62F1, 0x6370, 0x63EE, 0x646C, 0x64E8, 0x6563, 0x65DD, 0x6656,
    0x66CF, 0x6746, 0x67BC, 0x6832, 0x68A6, 0x6919, 0x698B, 0x69FD,
    0x6A6D, 0x6ADC, 0x6B4A, 0x6BB7, 0x6C23, 0x6C8E, 0x6CF8, 0x6D61,
    0x6DC9, 0x6E30, 0x6E96, 0x6EFB, 0x6F5E, 0x6FC1, 0x7022, 0x7083,
    0x70E2, 0x7140, 0x719D, 0x71F9, 0x7254, 0x72AE, 0x7307, 0x735E,
    0x73B5, 0x740A, 0x745F, 0x74B2, 0x7504, 0x7555, 0x75A5, 0x75F3,
    0x7641, 0x768D, 0x76D8, 0x7722, 0x776B, 0x77B3, 0x77FA, 0x783F,
    0x7884, 0x78C7, 0x7909, 0x794A, 0x7989, 0x79C8, 0x7A05, 0x7A41,
    0x7A7C, 0x7AB6, 0x7AEE, 0x7B26, 0x7B5C, 0x7B91, 0x7BC5, 0x7BF8,
    0x7C29, 0x7C59, 0x7C88, 0x7CB6, 0x7CE3, 0x7D0E, 0x7D39, 0x7D62,
    0x7D89, 0x7DB0, 0x7DD5, 0x7DFA, 0x7E1D, 0x7E3E, 0x7E5F, 0x7E7E,
    0x7E9C, 0x7EB9, 0x7ED5, 0x7EEF, 0x7F09, 0x7F21, 0x7F37, 0x7F4D,
    0x7F61, 0x7F74, 0x7F86, 0x7F97, 0x7FA6, 0x7FB4, 0x7FC1, 0x7FCD,
    0x7FD8, 0x7FE1, 0x7FE9, 0x7FF0, 0x7FF5, 0x7FF9, 0x7FFD, 0x7FFE};

static RO u16 aCirLimTbl[65] = {
    32767, 32390, 32146, 31907, 31673, 31444, 31220, 31001, 30787, 30577,
    30371, 30169, 29971, 29777, 29587, 29400, 29217, 29037, 28861, 28687,
    28517, 28350, 28185, 28024, 27865, 27709, 27555, 27404, 27256, 27110,
    26966, 26824, 26685, 26548, 26413, 26280, 26149, 26019, 25892, 25767,
    25643, 25521, 25401, 25283, 25166, 25051, 24937, 24825, 24715, 24606,
    24498, 24392, 24287, 24183, 24081, 23980, 23880, 23782, 23684, 23588,
    23493, 23400, 23307, 23215, 23125};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void MC_SinCos(s16 Angle, s16* Sin, s16* Cos)
{
    u16 index = (u16)(Angle + 32768) >> 6;

    switch (index & SIN_MASK)
    {
        case U0_90:
            *Sin = aSinTbl[(u8)(index)];
            *Cos = aSinTbl[(u8)(0xFF - (u8)(index))];
            break;

        case U90_180:
            *Sin = aSinTbl[(u8)(0xFF - (u8)(index))];
            *Cos = -aSinTbl[(u8)(index)];
            break;

        case U180_270:
            *Sin = -aSinTbl[(u8)(index)];
            *Cos = -aSinTbl[(u8)(0xFF - (u8)(index))];
            break;

        case U270_360:
            *Sin = -aSinTbl[(u8)(0xFF - (u8)(index))];
            *Cos = aSinTbl[(u8)(index)];
            break;
    }
}

/**
 * alpha = As
 * beta  = (As + Bs * 2) * 0.57735026918
 */
void MC_Clarke(mc_clarke_t* this)
{
#if CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_DOWN_BRG || CONFIG_CUR_SAMP_TYPE == CUR_SAMP_UVW_LINE
    this->Ialpha = ((s32)M_INV3_Q15 * (s32)(2 * this->Ia - this->Ib - this->Ic)) >> 15;
    this->Ibeta  = ((s32)M_INVSQRT3_Q15 * (s32)(this->Ib - this->Ic)) >> 15;
#else
    this->Ialpha = this->Ia;
    this->Ibeta  = ((s32)M_INVSQRT3_Q15 * (s32)(this->Ia + this->Ib + this->Ib)) >> 15;
#endif
}

void MC_RevClarke(mc_clarke_t* this)
{
    s32 m = (s32)M_Q15_SQRT3_2 * (s32)this->Ibeta;
    s32 n = (s32)M_Q15_1_2 * (s32)this->Ialpha;

    this->Ia = this->Ialpha;
    this->Ib = (-n + m) >> 15;
    this->Ic = (-n - m) >> 15;
}

/**
 * d = alpha * cos + beta * sin
 * q = beta * cos - alpha * sin
 */
void MC_Park(mc_park_t* this)
{
    s16 Sin, Cos;

    MC_SinCos(this->theta, &Sin, &Cos);

    this->Id = ((s32)this->Ialpha * (s32)Cos + (s32)this->Ibeta * (s32)Sin) >> 15;
    this->Iq = ((s32)this->Ibeta * (s32)Cos - (s32)this->Ialpha * (s32)Sin) >> 15;
}

/**
 * alpha = d * cos - q * sin
 * beta  = d * sin + q * cos
 */
void MC_RevPark(mc_park_t* this)
{
    s16 Sin, Cos;

    MC_SinCos(this->theta, &Sin, &Cos);

    this->Ialpha = ((s32)this->Id * (s32)Cos - (s32)this->Iq * (s32)Sin) >> 15;
    this->Ibeta  = ((s32)this->Iq * (s32)Cos + (s32)this->Id * (s32)Sin) >> 15;
}

void MC_CirLim(mc_park_t* this)
{
    u32 square = (s32)this->Iq * (s32)this->Iq + (s32)this->Id * (s32)this->Id;

    if (square > ((u32)Q15_MAX * (u32)Q15_MAX))
    {
        // min value 0, max value 127 - START_INDEX
        u8 index = square / (512 * 32768) - START_INDEX;
        this->Iq = this->Iq * aCirLimTbl[index] / 32768;
        this->Id = this->Id * aCirLimTbl[index] / 32768;
    }
}

// TI: math_blocks\include\v4.3\svgen_comm
void MC_Svgen(mc_svgen_t* this)
{
    mc_clarke_t revclarke;

    revclarke.Ialpha = this->Ualpha;
    revclarke.Ibeta  = this->Ubeta;

    MC_RevClarke(&revclarke);

    s16 v_min = MIN3(revclarke.Ia, revclarke.Ib, revclarke.Ic);
    s16 v_max = MAX3(revclarke.Ia, revclarke.Ib, revclarke.Ic);
    s16 v_com = (v_max + v_min) / 2;

    const u32 u32UmdcRateSi = 120;                                                                 // 驱动器额定电压 0.1V
    u32       u32UmdcPu     = M_SQRT3 * (u32)D.u16UmdcPu * (u32)D.u16UmdcHwCoeff / u32UmdcRateSi;  // Q15

    // u32UmdcPu = CLAMP(u32UmdcPu, 4818535UL, 6553500UL) / 100;

    // Ia\Ib\Ic, v_com 已是 Q15 格式

    // 2 / 1.73 = 1.15 最大调制比

    this->Ta = 2 * (s32)PWM_PERIOD * (s32)(revclarke.Ia - v_com) / (s32)u32UmdcPu + PWM_PERIOD / 2;
    this->Tb = 2 * (s32)PWM_PERIOD * (s32)(revclarke.Ib - v_com) / (s32)u32UmdcPu + PWM_PERIOD / 2;
    this->Tc = 2 * (s32)PWM_PERIOD * (s32)(revclarke.Ic - v_com) / (s32)u32UmdcPu + PWM_PERIOD / 2;
}
