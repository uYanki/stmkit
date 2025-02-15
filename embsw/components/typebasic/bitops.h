#ifndef __BITOPS_H__
#define __BITOPS_H__

#include "./typebasic.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Bitwise Operations
 * @{
 */

typedef enum {
    LSBFirst, /*!< least significant bit */
    MSBFirst, /*!< most significant bit */
} bit_order_e;

#ifndef BV
#define BV(n) (1UL << (n))
#endif

#define MASK8(LEN)               (~(U8_MAX << (LEN)))
#define MASK16(LEN)              (~(U16_MAX << (LEN)))
#define MASK32(LEN)              (~(U32_MAX << (LEN)))
#define MASK64(LEN)              (~(U64_MAX << (LEN)))

#define BITMASK8(STB, LEN)       (MASK8(LEN) << (STB))
#define BITMASK16(STB, LEN)      (MASK16(LEN) << (STB))
#define BITMASK32(STB, LEN)      (MASK32(LEN) << (STB))
#define BITMASK64(STB, LEN)      (MASK64(LEN) << (STB))

#define SETBIT(DAT, BIT)         ((DAT) |= (1U << (BIT)))    /*!< set a bit */
#define CLRBIT(DAT, BIT)         ((DAT) &= (~(1U << (BIT)))) /*!< clear a bit */
#define CHKBIT(DAT, BIT)         (((DAT) >> (BIT)) & 1U)     /*!< get a bit */

#define SETBIT64(DAT, BIT)       ((DAT) |= (1ULL << (BIT)))    /*!< set a bit */
#define CLRBIT64(DAT, BIT)       ((DAT) &= (~(1ULL << (BIT)))) /*!< clear a bit */
#define CHKBIT64(DAT, BIT)       (((DAT) >> (BIT)) & 1ULL)     /*!< get a bit */

#define SETBITS(DAT, STB, LEN)   ((DAT) |= (MASK32(LEN) << (STB)))  /*!< set bits (bit-32) */
#define CLRBITS(DAT, STB, LEN)   ((DAT) &= ~(MASK32(LEN) << (STB))) /*!< clear bits (bit-32) */
#define GETBITS(DAT, STB, LEN)   (((DAT) >> (STB)) & MASK32(LEN))   /*!< get bits (bit-32) */

#define SETBITS64(DAT, STB, LEN) ((DAT) |= (MASK64(LEN) << (STB)))  /*!< set bits (bit-32) */
#define CLRBITS64(DAT, STB, LEN) ((DAT) &= ~(MASK64(LEN) << (STB))) /*!< clear bits (bit-32) */
#define GETBITS64(DAT, STB, LEN) (((DAT) >> (STB)) & MASK64(LEN))   /*!< get bits (bit-32) */

#define CHKMSK8(DAT, MSK, VAL)   (((u8)(DAT) & (u8)(MSK)) == (u8)(VAL))
#define CHKMSK16(DAT, MSK, VAL)  (((u16)(DAT) & (u16)(MSK)) == (u16)(VAL))
#define CHKMSK32(DAT, MSK, VAL)  (((u32)(DAT) & (u32)(MSK)) == (u32)(VAL))
#define CHKMSK64(DAT, MSK, VAL)  (((u64)(DAT) & (u64)(MSK)) == (u64)(VAL))

#define LOBYTE(DAT)              (u8)(0xFF & (DAT))
#define HIBYTE(DAT)              (u8)(0xFF & ((DAT) >> 8))
#define LOWORD(DAT)              (u16)(0xFFFF & (DAT))
#define HIWORD(DAT)              (u16)(0xFFFF & ((DAT) >> 16))

/*!< link two 16bits data to a 32bits data */
#define LINK32(HI, LO) (((u32)(HI) << 16) | ((u32)(LO)))
/*!< link two 32bits data to a 64bits data */
#define LINK64_2(HI, LO) (((u64)(HI) << 32) | ((u64)(LO)))
/*!< link four 16bits data to a 64bits data */
#define LINK64_4(W3, W2, W1, W0)             (((u64)(W3) << 48) | ((u64)(W2) << 32) | ((u64)(W1) << 16) | ((u64)(W0)))

#define GET_MACRO(_1, _2, _3, _4, NAME, ...) NAME
#define LINK64(...)                          GET_MACRO(__VA_ARGS__, LINK64_4, LINK64_2, LINK64_2)(__VA_ARGS__)

/**
 * @}
 */

#ifdef __cplusplus
}
#endif

#endif  // !__BITOPS_H__
