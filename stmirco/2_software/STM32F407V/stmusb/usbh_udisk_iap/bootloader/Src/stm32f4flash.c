#include "stm32f4flash.h"


uint32_t STM32F4FLASH_ReadWord(uint32_t FlashAddr)
{
	return *(__IO uint32_t*)FlashAddr;
}

uint32_t STM32F4FLASH_GetFlashSector(uint32_t addr)
{
	if(addr < ADDR_FLASH_SECTOR_1)
		return FLASH_SECTOR_0;
	else if(addr < ADDR_FLASH_SECTOR_2)
		return FLASH_SECTOR_1;
	else if(addr < ADDR_FLASH_SECTOR_3)
		return FLASH_SECTOR_2;
	else if(addr < ADDR_FLASH_SECTOR_4)
		return FLASH_SECTOR_3;
	else if(addr < ADDR_FLASH_SECTOR_5)
		return FLASH_SECTOR_4;
	else if(addr < ADDR_FLASH_SECTOR_6)
		return FLASH_SECTOR_5;
	else if(addr < ADDR_FLASH_SECTOR_7)
		return FLASH_SECTOR_6;
	else if(addr < ADDR_FLASH_SECTOR_8)
		return FLASH_SECTOR_7;
	else if(addr < ADDR_FLASH_SECTOR_9)
		return FLASH_SECTOR_8;
	else if(addr < ADDR_FLASH_SECTOR_10)
		return FLASH_SECTOR_9;
	else if(addr < ADDR_FLASH_SECTOR_11)
		return FLASH_SECTOR_10;
	else return FLASH_SECTOR_11;
}

uint8_t STM32F4FLASH_CheckEmpty(uint32_t StartAddr,uint32_t EndAddr)
{
	uint8_t status = HAL_FLASH_ERROR_NONE;
	
	if(StartAddr < 0x1fff0000)
	{
		while(StartAddr < EndAddr)
		{
			if(STM32F4FLASH_ReadWord(StartAddr) != 0xffffffff)
			{
				FLASH_Erase_Sector(STM32F4FLASH_GetFlashSector(StartAddr),FLASH_VOLTAGE_RANGE_3);
			}
			else
				StartAddr+=4;
		}
	}
	else
	{
		status = FLASH_ERROR_PGS;
	}
	return status;
}
