#include "flash_if.h"
#include "hpm_platform.h"

static bool flash_init(void)
{
    return hpm_platform_flash_init() == 0;
}

static bool flash_lock(void)
{
    return true;
}

static bool flash_unlock(void)
{
    return true;
}

static bool flash_read(uint32_t address, uint32_t length, uint8_t* buffer)
{
    if( address > FLASH_ADDR_BASE)
    {
        address -= FLASH_ADDR_BASE;
    }

    return hpm_flash_read(address, buffer, length) == length;
}

static bool flash_write(uint32_t address, uint32_t length, uint8_t* buffer)
{
    if( address > FLASH_ADDR_BASE)
    {
        address -= FLASH_ADDR_BASE;
    }

    return hpm_flash_write(address, buffer, length) == length;
}

static bool flash_earse(uint32_t address, uint32_t length)
{
    if( address > FLASH_ADDR_BASE)
    {
        address -= FLASH_ADDR_BASE;
    }

#if 1

    uint32_t msk = FLASH_SECTOR_SIZE - 1; 

    if( (length & msk)  > 0 )
    {
        length = (length & ~msk ) + FLASH_SECTOR_SIZE; // align up
    }

#endif

    return hpm_flash_erase(address, length) == length;
}

const flash_if_t flashif = {
    .init   = flash_init,
    .lock   = flash_lock,
    .unlock = flash_unlock,
    .read   = flash_read,
    .write  = flash_write,
    .earse  = flash_earse,
};
