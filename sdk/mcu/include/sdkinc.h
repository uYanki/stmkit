#ifndef __SDK_INC_H__
#define __SDK_INC_H__

#include "./types.h"
#include "./easymath.h"
#include "./endian.h"
#include "./qmath.h"
#include "./errno.h"
#include "./compiler.h"

#include <string.h>

#ifndef CONFIG_NOT_INCLUDE_STDARG
#include <stdarg.h>
#endif

#ifndef CONFIG_NOT_INCLUDE_STDLIB
#include <stdlib.h>
#endif

#ifndef CONFIG_NOT_INCLUDE_STDIO
#include <stdio.h>
#endif

/**
 * @brief printf
 */

#ifndef PRINTF
#define PRINTF(...) printf(__VA_ARGS__)
#endif

#ifndef PRINTLN
#define PRINTLN(format, ...) PRINTF(format "\n", ##__VA_ARGS__)
#endif

#endif  // !__SDK_INC_H__
