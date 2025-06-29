#ifndef __STM32F4FLASH_H
#define __STM32F4FLASH_H

#include "stm32f4xx.h"

#define STM32_FLASH_BASE 0x08000000 //STM32的FLASH起始地址

#define ADDR_FLASH_SECTOR_0  ((uint32_t)0x08000000)//16KB
#define ADDR_FLASH_SECTOR_1  ((uint32_t)0x08004000)//16KB
#define ADDR_FLASH_SECTOR_2  ((uint32_t)0x08008000)//16KB
#define ADDR_FLASH_SECTOR_3  ((uint32_t)0x0800C000)//16KB
#define ADDR_FLASH_SECTOR_4  ((uint32_t)0x08010000)//64KB
#define ADDR_FLASH_SECTOR_5  ((uint32_t)0x08020000)//128KB
#define ADDR_FLASH_SECTOR_6  ((uint32_t)0x08040000)//128KB
#define ADDR_FLASH_SECTOR_7  ((uint32_t)0x08060000)//128KB
#define ADDR_FLASH_SECTOR_8  ((uint32_t)0x08080000)//128KB
#define ADDR_FLASH_SECTOR_9  ((uint32_t)0x080A0000)//128KB
#define ADDR_FLASH_SECTOR_10 ((uint32_t)0x080C0000)//128KB
#define ADDR_FLASH_SECTOR_11 ((uint32_t)0x080E0000)//128KB

uint32_t STM32F4FLASH_ReadWord(uint32_t FlashAddr);
uint8_t STM32F4FLASH_CheckEmpty(uint32_t StartAddr,uint32_t EndAddr);
//void STM32F4FLASH_Write(uint32_t WriteAddr,uint32_t *pBuffer,uint32_t NumToWrite);
//void STM32F4FLASH_Read(uint32_t ReadAddr,uint32_t *pBuffer,uint32_t NumToRead);



#endif
