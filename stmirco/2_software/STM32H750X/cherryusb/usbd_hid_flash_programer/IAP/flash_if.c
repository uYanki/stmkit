#include "flash_if.h"

#if 0

#define ADDR_FLASH_SECTOR_0_BANK1 (FLASH_BANK1_BASE)
#define ADDR_FLASH_SECTOR_1_BANK1 (ADDR_FLASH_SECTOR_0_BANK1 + 0x2000)  // 8KB
#define ADDR_FLASH_SECTOR_2_BANK1 (ADDR_FLASH_SECTOR_1_BANK1 + 0x2000)  // 8KB
#define ADDR_FLASH_SECTOR_3_BANK1 (ADDR_FLASH_SECTOR_2_BANK1 + 0x2000)  // 8KB
#define ADDR_FLASH_SECTOR_4_BANK1 (ADDR_FLASH_SECTOR_3_BANK1 + 0x2000)  // 8KB
#define ADDR_FLASH_SECTOR_5_BANK1 (ADDR_FLASH_SECTOR_4_BANK1 + 0x2000)  // 8KB
#define ADDR_FLASH_SECTOR_6_BANK1 (ADDR_FLASH_SECTOR_5_BANK1 + 0x2000)  // 8KB
#define ADDR_FLASH_SECTOR_7_BANK1 (ADDR_FLASH_SECTOR_6_BANK1 + 0x2000)  // 8KB

uint16_t STMFLASH_GetFlashSector(uint32_t addr)
{
    if (addr < ADDR_FLASH_SECTOR_1_BANK1)
    {
        return FLASH_SECTOR_0;
    }
    else if (addr < ADDR_FLASH_SECTOR_2_BANK1)
    {
        return FLASH_SECTOR_1;
    }
    else if (addr < ADDR_FLASH_SECTOR_3_BANK1)
    {
        return FLASH_SECTOR_2;
    }
    else if (addr < ADDR_FLASH_SECTOR_4_BANK1)
    {
        return FLASH_SECTOR_3;
    }
    else if (addr < ADDR_FLASH_SECTOR_5_BANK1)
    {
        return FLASH_SECTOR_4;
    }
    else if (addr < ADDR_FLASH_SECTOR_6_BANK1)
    {
        return FLASH_SECTOR_5;
    }
    else if (addr < ADDR_FLASH_SECTOR_7_BANK1)
    {
        return FLASH_SECTOR_6;
    }

    return FLASH_SECTOR_7;
}

static bool flash_init()
{
    return false;
}

static bool flash_lock()
{
    return HAL_FLASH_Lock() == HAL_OK;
}

static bool flash_unlock()
{
    return HAL_FLASH_Unlock() == HAL_OK;
}

static bool flash_read(uint32_t address, uint32_t length, uint8_t* buffer)
{
    return false;
}

static bool flash_write(uint32_t address, uint32_t length, uint8_t* buffer)
{
    while (length > 0)
    {
        if (HAL_FLASH_Program(FLASH_TYPEPROGRAM_FLASHWORD, address, (uint32_t)buffer) != HAL_OK)
        {
            return true;
        }

        address += 16;
        buffer += 4;
        length -= 4;
    }

    return false;
}

static bool flash_earse(uint32_t address, uint32_t length)
{
    FLASH_EraseInitTypeDef FlashEarse;
    uint32_t               SectorError;

    if (IS_FLASH_PROGRAM_ADDRESS_BANK1(address))
    {
        FlashEarse.Banks  = FLASH_BANK_1;
        FlashEarse.Sector = (address - FLASH_BANK1_BASE) / FLASH_SECTOR_SIZE;
    }

#if defined(DUAL_BANK)

    else if (IS_FLASH_PROGRAM_ADDRESS_BANK2(address))
    {
        FlashEarse.Banks  = FLASH_BANK_2;
        FlashEarse.Sector = (address - FLASH_BANK2_BASE) / FLASH_SECTOR_SIZE;
    }

#endif

    else
    {
        return false;
    }

    FlashEarse.NbSectors = length / FLASH_SECTOR_SIZE;

    if (FlashEarse.NbSectors == 0)
    {
        FlashEarse.NbSectors = 1;
    }

    FlashEarse.TypeErase    = FLASH_TYPEERASE_SECTORS;
    FlashEarse.VoltageRange = FLASH_VOLTAGE_RANGE_2;

    return HAL_FLASHEx_Erase(&FlashEarse, &SectorError) == HAL_OK;
}

#else

#include "sfud.h"

static bool flash_init()
{
    if (sfud_init() == SFUD_SUCCESS)
    {
        sfud_flash* flash = sfud_get_device(SFUD_W25Q64_DEVICE_INDEX);

        return true;
    }

    return false;
}

static bool flash_lock()
{
    return true;
}

static bool flash_unlock()
{
    return true;
}

static bool flash_read(uint32_t address, uint32_t length, uint8_t* buffer)
{
    sfud_flash* flash = sfud_get_device(SFUD_W25Q64_DEVICE_INDEX);

    return sfud_read(flash, address, length, buffer) == SFUD_SUCCESS;
}

static bool flash_write(uint32_t address, uint32_t length, uint8_t* buffer)
{
    sfud_flash* flash = sfud_get_device(SFUD_W25Q64_DEVICE_INDEX);

    return sfud_write(flash, address, length, buffer) == SFUD_SUCCESS;
}

static bool flash_earse(uint32_t address, uint32_t length)
{
    sfud_flash* flash = sfud_get_device(SFUD_W25Q64_DEVICE_INDEX);

    return sfud_erase(flash, address, length) == SFUD_SUCCESS;
}

#endif

flash_if_t flashif = {
    .init   = flash_init,
    .lock   = flash_lock,
    .unlock = flash_unlock,
    .read   = flash_read,
    .write  = flash_write,
    .earse  = flash_earse,
};
