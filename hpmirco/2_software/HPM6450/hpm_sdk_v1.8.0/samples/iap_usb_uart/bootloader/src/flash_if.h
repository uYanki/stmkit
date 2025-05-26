#ifndef __FLASH_IF_H__
#define __FLASH_IF_H__

#include <stdint.h>
#include <stdbool.h>

#include "hpm_flashmap.h"

typedef struct {
    bool (*init)(void);
    bool (*lock)(void);
    bool (*unlock)(void);
    bool (*read)(uint32_t address, uint32_t length, uint8_t* buffer);
    bool (*write)(uint32_t address, uint32_t length, uint8_t* buffer);
    bool (*earse)(uint32_t address, uint32_t length);
} flash_if_t;

extern const flash_if_t flashif;

#endif
