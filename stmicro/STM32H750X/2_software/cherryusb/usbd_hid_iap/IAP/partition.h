#ifndef __PARTITION_H__
#define __PARTITION_H__

#include <stdint.h>
#include "flash_if.h"

#define PARTITION_FLAG_READONLY  1U  // 只读
#define PARTITION_FLAG_ENCRYPTED 2U  // 加密

typedef struct {
    char        name[32];
    flash_if_t* flashif;
    uint32_t    offset;
    uint32_t    size;
    uint32_t    flags;
} partition_t;

#endif
