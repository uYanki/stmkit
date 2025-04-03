#ifndef __FLASH_IF_H__
#define __FLASH_IF_H__

#include <stdint.h>
#include <stdbool.h>

typedef struct {
    bool (*init)();
    bool (*lock)();
    bool (*unlock)();
    bool (*read)(uint32_t address, uint32_t length, uint8_t* buffer);
    bool (*write)(uint32_t address, uint32_t length, uint8_t* buffer);
    bool (*earse)(uint32_t address, uint32_t length);
} flash_if_t;

extern flash_if_t flashif;

#endif
