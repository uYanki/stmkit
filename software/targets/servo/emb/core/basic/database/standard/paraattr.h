#ifndef __PARA_ATTR_H__
#define __PARA_ATTR_H__

#include "common.h"

/**
 * @brief
 *
 */
#define ATTR_MODE_Pos 0
#define ATTR_MODE_Len 2

#define V_RO          0U
#define V_RW_M0       1U
#define V_RW_M1       2U
#define V_RW_M2       3U

#define B_RO          (V_RO << ATTR_MODE_Pos)    /* read only  - cannot be changed */
#define B_RW_M0       (V_RW_M0 << ATTR_MODE_Pos) /* read write - change immediately, take effect immediately */
#define B_RW_M1       (V_RW_M1 << ATTR_MODE_Pos) /* read write - change immediately, restart takes effect */
#define B_RW_M2       (V_RW_M2 << ATTR_MODE_Pos) /* read write - stop changes, effective immediately */

/**
 * @brief sign
 */
#define ATTR_SIGN_Pos (ATTR_MODE_Pos + ATTR_MODE_Len)
#define ATTR_SIGN_Len 1

#define V_SIGN        0U
#define V_UNSI        1U

#define B_SIGN        (V_SIGN << ATTR_SIGN_Pos)
#define B_UNSI        (V_UNSI << ATTR_SIGN_Pos)

/**
 * @brief
 *
 */
#define ATTR_SYNC_Pos (ATTR_SIGN_Pos + ATTR_SIGN_Len)
#define ATTR_SYNC_Len 1

#define V_SYNC        0U
#define V_NSYNC       1U

#define B_SYNC        (V_SYNC << ATTR_SYNC_Pos)
#define B_NSYNC       (V_NSYNC << ATTR_SYNC_Pos)

/**
 * @brief
 *
 */
#define ATTR_COVER_Pos (ATTR_SYNC_Pos + ATTR_SYNC_Len)
#define ATTR_COVER_Len 1

#define V_COV          0U
#define V_NCOV         1U

#define B_COV          (V_COV << ATTR_COVER_Pos)  /* cover (over write) when parameters table reset */
#define B_NCOV         (V_NCOV << ATTR_COVER_Pos) /* do not cover(don't over write) */

/**
 * @brief
 *
 */
#define ATTR_LENGTH_Pos (ATTR_COVER_Pos + ATTR_COVER_Len)
#define ATTR_LENGTH_Len 3

#define V_SIG           0U
#define V_DOB0          1U
#define V_DOB1          2U
#define V_QUD0          3U
#define V_QUD1          4U
#define V_QUD2          5U
#define V_QUD3          6U

#define B_SIG           (V_SIG << ATTR_LENGTH_Pos)  /* single word (16bits) */
#define B_DOB0          (V_DOB0 << ATTR_LENGTH_Pos) /* double word (32bits) */
#define B_DOB1          (V_DOB1 << ATTR_LENGTH_Pos) /* double word (32bits) */
#define B_QUD0          (V_QUD0 << ATTR_LENGTH_Pos) /* quadruple word (64bits) */
#define B_QUD1          (V_QUD1 << ATTR_LENGTH_Pos) /* quadruple word (64bits) */
#define B_QUD2          (V_QUD2 << ATTR_LENGTH_Pos) /* quadruple word (64bits) */
#define B_QUD3          (V_QUD3 << ATTR_LENGTH_Pos) /* quadruple word (64bits) */

/**
 * @brief
 *
 */
#define ATTR_ACCESS_Pos (ATTR_LENGTH_Pos + ATTR_LENGTH_Len)
#define ATTR_ACCESS_Len 2

#define V_ADMIN         0U
#define V_USER          1U
#define V_ANYONE        2U

#define B_ADMIN         (V_ADMIN << ATTR_ACCESS_Pos)  /* administrator */
#define B_USER          (V_USER << ATTR_ACCESS_Pos)   /* user */
#define B_ANYONE        (V_ANYONE << ATTR_ACCESS_Pos) /* anyone (guest) */

/**
 * @brief physical unit
 */
#define ATTR_UNIT_Pos (ATTR_ACCESS_Pos + ATTR_ACCESS_Len)
#define ATTR_UNIT_Len 1

#define B_Null        0 /* no unit. */
#define B_A_1         0 /* current ampere x 1A. */
#define B_A_01        0 /* current ampere x 0.1A. */
#define B_A_001       0 /* current ampere x 0.01A. */
#define B_V_1         0 /* voltage volts x 1V. */
#define B_V_01        0 /* voltage volts x 0.1V. */
#define B_V_001       0 /* voltage volts x 0.01V. */
#define B_rpm         0 /* rotation per minitue. */
#define B_rpm_01      0 /* 0.1rotation per minitue. */
#define B_kHz_01      0 /* frequency 0.1kHz. */
#define B_Hz          0 /* frequency Hz. */
#define B_Hz_01       0 /* frequency 0.1Hz. */
#define B_rad_s       0 /* rad/s. */
#define B_m_min       0 /* m/min. */
#define B_m_min_01    0 /* 0.1m/min. */
#define B_mm_s        0 /* mm/s. */
#define B_oC          0 /* temperature 'C. */
#define B_oC_01       0 /* temperature 0.1'C. */
#define B_Nm          0 /* torque Nm. */
#define B_Nm_001      0 /* torque 0.01Nm. */
#define B_kW          0 /* power kW. */
#define B_Watt        0 /* power W. */
#define B_kW_001      0 /* power 0.01kW. */
#define B_Ohm         0 /* resistance ohm */
#define B_Ohm_001     0 /* resistance 0.01ohm.time ms. */
#define B_Ohm_0001    0 /* resistance 0.001ohm or 1 mohm. */
#define B_mH          0 /* inductance mH. */
#define B_mH_001      0 /* inductance 0.01mH. */
#define B_hour        0 /* time hour. */
#define B_hour_01     0 /* time 0.1hour. */
#define B_min         0 /* time minute. */
#define B_sec         0 /* time second. */
#define B_sec_01      0 /* time 0.1second. */
#define B_ms          0 /* time ms. */
#define B_ms_01       0 /* time 0.1ms. */
#define B_ms_001      0 /* time 0.01ms. */
#define B_us          0 /* time us. */
#define B_us_01       0 /* time 0.1us. */
#define B_ns          0 /* time ns. */
#define B_kgcm2_0001  0 /* inertia kg*cm^2*10^-3. */
#define B_percent     0 /* percentage. */
#define B_permill     0 /* permillage. */
#define B_rpm_s       0 /* acceleration rpm/s. */
#define B_m_s2        0 /* acceleration m/s^2. */
#define B_deg_01      0 /* 0.1degree. */
#define B_rad         0 /* rad. */
#define B_r           0 /* r-revolution. */
#define B_r_001       0 /* 0.01r-revolution. */
#define B_m           0 /* m. */
#define B_m_01        0 /* 0.1m. */
#define B_cm          0 /* cm. */
#define B_mm          0 /* mm. */
#define B_mm_01       0 /* 0.1mm. */
#define B_mm_001      0 /* 0.01mm. */
#define B_um          0 /* um. */
#define B_pulse       0 /* encoder pulse. */
#define B_V_ms_rad_01 0 /* 0.1V*ms/rad */
#define B_uF          0 /* uF */

/**
 * @brief
 *
 */

#define W(DATA)  (u16)(DATA) /* bit[15, 0] */

#define WL(DATA) (u16) GETBITS((u32)DATA, 0, 16)  /* bit[15, 0] */
#define WH(DATA) (u16) GETBITS((u32)DATA, 16, 16) /* bit[31,16] */

#define W0(DATA) (u16) GETBITS64((u64)DATA, 0, 16)  /* bit[15, 0] */
#define W1(DATA) (u16) GETBITS64((u64)DATA, 16, 16) /* bit[31,16] */
#define W2(DATA) (u16) GETBITS64((u64)DATA, 32, 16) /* bit[47,32] */
#define W3(DATA) (u16) GETBITS64((u64)DATA, 48, 16) /* bit[63,48] */

/**
 * @brief
 *
 */

typedef struct {
    u16 u16InitVal; /* initial value */
    u16 u16MinVal;  /* minimum value */
    u16 u16MaxVal;  /* maximum value */

    union {
        u16 u16All;
        struct {
            u16 Mode : ATTR_MODE_Len;     /* time when parameter can be wrote and when it will work */
            u16 Sign : ATTR_SIGN_Len;     /* signed or unsigned */
            u16 Sync : ATTR_SYNC_Len;     /* synchronized to eeprom */
            u16 Cover : ATTR_COVER_Len;   /* allowed to restore to the initial value */
            u16 Length : ATTR_LENGTH_Len; /* word length */
            u16 Access : ATTR_ACCESS_Len; /* access permission */
            u16 Unit : ATTR_UNIT_Len;     /* physical unit */
        } u16Bit;
    } uSubAttr;

} para_attr_t;

#endif
