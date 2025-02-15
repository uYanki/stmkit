#ifndef __EASY_MATH_H__
#define __EASY_MATH_H__

#include "./typebasic.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Math Constant
 * @{
 */

// clang-format off

#ifndef M_PI
#define M_PI       3.1415926f  /*!< 圆周率   π = 3.14159265358979323846 */
#endif
#define M_E        2.7182818f  /*!< 自然常数 e = 2.71828182845904523536 = (1+1/n)^n */
#define M_PHI      1.618033f   /*!< 黄金比例 φ = 1.61803398874989484820 = (1+sqrt(5))/2 */

#define M_PI_X2    6.2831852f  /*!< 2π */
#define M_PI_X100  314         /*!< 100π */

#define M_LOG2E    1.4426950f  /*!<  log2(e) = 1.44269504088896340736 */
#define M_LOG10E   0.4342944f  /*!<  log10(e) = 0.434294481903251827651 */
#define M_LN2      0.6931471f  /*!<  ln(2) = 0.693147180559945309417 */
#define M_LN10     2.3025850f  /*!<  ln(10) = 2.30258509299404568402 */

#define M_RAD2DEG  57.295779f  /*!< 1 radians to 57.295780 degress */
#define M_DEG2RAD  0.017453f   /*!< 1 degress to  0.017453 radians */

#define M_SIN15    0.258819f
#define M_SIN30    0.5f
#define M_SIN45    0.707106f  /*!< sqrt(2)/2 */
#define M_SIN60    0.866025f  /*!< sqrt(3)/2 */
#define M_SIN75    0.965925f

#define M_COS15    SIN75
#define M_COS30    SIN60
#define M_COS45    SIN45
#define M_COS60    SIN30
#define M_COS75    SIN15

#define M_SQRT2    1.414213f
#define M_SQRT3    1.732050f
#define M_SQRT3_2  0.866025f
#define M_SQRT5    2.236067f
#define M_INVSQRT2 0.707106f  /*!< 1/sqrt(2) */
#define M_INVSQRT3 0.577350f  /*!< 1/sqrt(3) */
#define M_INVSQRT5 0.447213f  /*!< 1/sqrt(5) */

// clang-format on

/**
 * @}
 */

/**
 * @brief Limit Marcos
 * @{
 */

/**
 * @param lhs: left-hand side
 * @param rhs: right-hand side
 */
#ifndef MIN
#define MIN(lhs, rhs) (((lhs) < (rhs)) ? (lhs) : (rhs))
#endif
#ifndef MAX
#define MAX(lhs, rhs) (((lhs) > (rhs)) ? (lhs) : (rhs))
#endif

#define MIN3(a, b, c) (MIN(a, MIN(b, c)))
#define MAX3(a, b, c) (MAX(a, MAX(b, c)))

/**
 * @param LO: lowest allowable value
 * @param HI: highest allowable value
 */
#define CLAMP(DAT, LO, HI)   (MAX(LO, MIN(DAT, HI)))
#define INOPEN(DAT, LO, HI)  (((LO) < (DAT)) && ((DAT) < (HI)))   /*!< check if the data is within the open range */
#define INCLOSE(DAT, LO, HI) (((LO) <= (DAT)) && ((DAT) <= (HI))) /*!< check if the data is within the closed range */

/**
 *              outMax - outMin
 *  outVal  = -------------------  x  ( inVal - inMin ) + outMin
 *               inMax - inMin
 */
#define MapTo(inVal, inMin, inMax, outMin, outMax) ((((outMax) - (outMin)) / (f32)((inMax) - (inMin))) * ((inVal) - (inMin)) + (outMin))

/**
 * @}
 */

#define AbsDelta(lhs, rhs) ((lhs) > (rhs)) ? ((lhs) - (rhs)) : ((rhs) - (lhs))

#define ABS(n)             (((n) > 0) ? (n) : (-n))

/*!< count of elements in an array */
#define ARRAY_SIZE(array) (sizeof(array) / sizeof(*(array)))
/*!< byte offset of member in structure (OFFSETOF) */
#define MEMBER_OFFSET(structure, member) ((u32)(char*)&(((structure*)0)->member))
/*!< size of a member of a structure */
#define MEMBER_SIZE(structure, member) (sizeof(((structure*)0)->member))

#define ALIGN_DOWN(address, align)     ((address) & ~((align) - 1))
#define ALIGN_UP(address, align)       (((address) + ((align) - 1)) & ~((align) - 1))

#ifdef __cplusplus
}
#endif

#endif  // !__CONSTANT_H__
