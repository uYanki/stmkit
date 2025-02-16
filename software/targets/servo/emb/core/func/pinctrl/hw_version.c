#include "hw_version.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

/**
 * @brief hardware version
 */
u8 GetHwVersion(void)
{
#if CONFIG_HWREV_NUM > 0

    u8 u8HwVerCur = 0, u8HwVerPrev = U8_MAX;

    do
    {
        u8HwVerPrev = u8HwVerCur;
        u8HwVerCur  = 0;

        if (PinGetLvl(HW_REV0_PIN_I) == B_ON)
        {
            u8HwVerCur |= BV(0);
        }

#if CONFIG_HWREV_NUM > 1

        if (PinGetLvl(HW_REV1_PIN_I) == B_ON)
        {
            u8HwVerCur |= BV(1);
        }

#endif

#if CONFIG_HWREV_NUM > 2

        if (PinGetLvl(HW_REV2_PIN_I == B_ON))
        {
            u8HwVerCur |= BV(2);
        }

#endif

    } while (u8HwVerCur != u8HwVerPrev);

    return u8HwVerCur;

#else

    return 0;

#endif
}
