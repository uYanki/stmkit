#ifndef __TYPE_BASIC_H__
#define __TYPE_BASIC_H__

#if __has_include
#include "projconf.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

#ifndef NULL
#define NULL 0
#endif

#ifndef __cplusplus
#ifndef nullptr
#define nullptr (void*)0
#endif
#endif

/**
 * @brief Modifiers
 * @{
 */

#define RW         /*!< read write */
#define RO   const /*!< read only */
#define WO         /*!< write only */

#define __R  volatile const /* Define "read-only" permission */
#define __RW volatile       /* Define "read-write" permission */
#define __W  volatile       /* Define "write-only" permission */

#ifndef __I
#define __I __R
#endif

#ifndef __IO
#define __IO __RW
#endif

#ifndef __O
#define __O __W
#endif

/*!< variables attribute */
#define __IN
#define __OUT
#define __INOUT

/*!< function interface */
#define __IMPL

/*!< unused variable */
#ifndef UNUSED
#define UNUSED(...) (void)(__VA_ARGS__)
#endif

/*!< c declare */
#ifdef __cplusplus
#define EXTERN_C extern "C"
#else
#define EXTERN_C
#endif

/**
 * @}
 */

/**
 * @brief Basic Types
 * @{
 */

/**
 * @brief 布尔型
 */

#if __STDC_VERSION__ >= 199901L
#include <stdbool.h>  // for C99 and later
#else
#define bool  int
#define true  1
#define false 0
#endif

/**
 * @brief 整数型
 */

#ifndef CONFIG_NOT_INCLUDE_STDINT

#include <stdint.h>

#endif

#ifndef CONFIG_NOT_DECLARE_INT_ABBR

typedef int8_t  s8;
typedef int16_t s16;
typedef int32_t s32;
typedef int64_t s64;

typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

typedef volatile uint8_t  vu8;
typedef volatile uint16_t vu16;
typedef volatile uint32_t vu32;
typedef volatile uint64_t vu64;

typedef volatile int8_t  vs8;
typedef volatile int16_t vs16;
typedef volatile int32_t vs32;
typedef volatile int64_t vs64;

#endif

/**
 * @brief 浮点型
 */

typedef float  float32_t;
typedef double float64_t;

#ifndef CONFIG_NOT_DECLARE_FLOAT_ABBR

typedef float32_t f32;
typedef float64_t f64;

typedef volatile float32_t vf32;
typedef volatile float64_t vf64;

#endif

/**
 * @}
 */

/**
 * @brief Numeric Range
 * @{
 */

#ifndef CONFIG_NOT_DECLARE_INT_RANGE

#define S8_MIN  0x80                  /*!< -128 */
#define S16_MIN 0x8000                /*!< -32678 */
#define S32_MIN 0x80000000            /*!< -2147483648 */
#define S64_MIN 0x8000000000000000ull /*!< -9223372036854775808 */

#define S8_MAX  0x7F               /*!< +127 */
#define S16_MAX 0x7FFF             /*!< +32767 */
#define S32_MAX 0x7FFFFFFF         /*!< +2147483647 */
#define S64_MAX 0x7FFFFFFFFFFFFFFF /*!< +9223372036854775807 */

#define U8_MIN  0x00               /*!< 0 */
#define U16_MIN 0x0000             /*!< 0 */
#define U32_MIN 0x00000000         /*!< 0 */
#define U64_MIN 0x0000000000000000 /*!< 0 */

#define U8_MAX  0xFFU                 /*!< +255 */
#define U16_MAX 0xFFFFU               /*!< +65535 */
#define U32_MAX 0xFFFFFFFFUL          /*!< +4294967295 */
#define U64_MAX 0xFFFFFFFFFFFFFFFFULL /*!< +18446744073709551615 */

#endif

#ifndef CONFIG_NOT_DECLARE_FLOAT_RANGE

#define F16_MIN
#define F32_MIN 3.40282347e+38F
#define F64_MIN 1.79769313486231571e+308

#define F16_MAX
#define F32_MAX 1.175494351e-38F
#define F64_MAX 2.22507385850720138e-308

#endif

/**
 * @}
 */

#ifdef __cplusplus
}
#endif

#endif  // __TYPES_H__
