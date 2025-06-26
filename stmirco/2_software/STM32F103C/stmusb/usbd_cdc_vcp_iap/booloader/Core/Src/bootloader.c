/*
 * bootloader.c
 *
 *  Created on: Oct 16, 2020
 *      Author: Viktor Vano
 */

#include "bootloader.h"

uint32_t    Flashed_offset = 0;
FlashStatus flashStatus    = Unerased;

void bootloaderInit()
{
    Flashed_offset = 0;
    flashStatus    = Unerased;

    if (HAL_GPIO_ReadPin(BOOT1_GPIO_Port, BOOT1_Pin) == GPIO_PIN_SET)
    {
			  // Bootloader Mode
        for (uint8_t i = 0; i < 10; i++)
        {
            HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
            HAL_Delay(10);
            HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
            HAL_Delay(90);
        }
    }
    else
    {
        // Check if the application is there
        uint8_t emptyCellCount = 0;
        for (uint8_t i = 0; i < 10; i++)
        {
            if ((int)readWord(APP1_START + (i * 4)) == -1)
            {
                emptyCellCount++;
            }
        }

        if (emptyCellCount != 10)
        {
            jumpToApp(APP1_START);
        }
        else
        {
            errorBlink();
        }
    }
}

void flashWord(uint32_t dataToFlash)
{
    if (flashStatus == Unlocked)
    {
        volatile HAL_StatusTypeDef status;
        uint8_t                    flash_attempt = 0;
        uint32_t                   address;
        do
        {
            address = APP1_START + Flashed_offset;
            status  = HAL_FLASH_Program(FLASH_TYPEPROGRAM_WORD, address, dataToFlash);
            flash_attempt++;
        } while (status != HAL_OK && flash_attempt < 10 && dataToFlash != readWord(address));
        if (status != HAL_OK)
        {
            CDC_Transmit_FS((uint8_t*)&"Flashing Error!\n", strlen("Flashing Error!\n"));
        }
        else
        {  // Word Flash Successful
            Flashed_offset += 4;
            CDC_Transmit_FS((uint8_t*)&"Flash: OK\n", strlen("Flash: OK\n"));
        }
    }
    else
    {
        CDC_Transmit_FS((uint8_t*)&"Error: Memory not unlocked nor erased!\n",
                        strlen("Error: Memory not unlocked nor erased!\n"));
    }
}

uint32_t readWord(uint32_t address)
{
    uint32_t read_data;
    read_data = *(uint32_t*)(address);
    return read_data;
}

void eraseMemory(void)
{
    /* Unock the Flash to enable the flash control register access *************/
    while (HAL_FLASH_Unlock() != HAL_OK)
    {
        while (HAL_FLASH_Lock() != HAL_OK);  // Weird fix attempt
    }

    /* Allow Access to option bytes sector */
    while (HAL_FLASH_OB_Unlock() != HAL_OK)
    {
        while (HAL_FLASH_OB_Lock() != HAL_OK);  // Weird fix attempt
    }

    /* Fill EraseInit structure*/
    FLASH_EraseInitTypeDef EraseInitStruct;
    EraseInitStruct.TypeErase   = FLASH_TYPEERASE_PAGES;
    EraseInitStruct.PageAddress = APP1_START;
    EraseInitStruct.NbPages     = FLASH_BANK_SIZE / FLASH_PAGE_SIZE_USER;
    uint32_t PageError;

    volatile HAL_StatusTypeDef status_erase;
    status_erase = HAL_FLASHEx_Erase(&EraseInitStruct, &PageError);

    /* Lock the Flash to enable the flash control register access *************/
    while (HAL_FLASH_Lock() != HAL_OK)
    {
        while (HAL_FLASH_Unlock() != HAL_OK);  // Weird fix attempt
    }

    /* Lock Access to option bytes sector */
    while (HAL_FLASH_OB_Lock() != HAL_OK)
    {
        while (HAL_FLASH_OB_Unlock() != HAL_OK);  // Weird fix attempt
    }

    if (status_erase != HAL_OK)
    {
        errorBlink();
    }
    flashStatus    = Erased;
    Flashed_offset = 0;
}

void unlockFlashAndEraseMemory(void)
{
    /* Unock the Flash to enable the flash control register access *************/
    while (HAL_FLASH_Unlock() != HAL_OK)
    {
        while (HAL_FLASH_Lock() != HAL_OK);  // Weird fix attempt
    }

    /* Allow Access to option bytes sector */
    while (HAL_FLASH_OB_Unlock() != HAL_OK)
    {
        while (HAL_FLASH_OB_Lock() != HAL_OK);  // Weird fix attempt
    }

    if (flashStatus != Erased)
    {
        /* Fill EraseInit structure*/
        FLASH_EraseInitTypeDef EraseInitStruct;
        EraseInitStruct.TypeErase   = FLASH_TYPEERASE_PAGES;
        EraseInitStruct.PageAddress = APP1_START;
        EraseInitStruct.NbPages     = FLASH_BANK_SIZE / FLASH_PAGE_SIZE_USER;
        uint32_t PageError;

        volatile HAL_StatusTypeDef status_erase;
        status_erase = HAL_FLASHEx_Erase(&EraseInitStruct, &PageError);

        if (status_erase != HAL_OK)
        {
            errorBlink();
        }
    }

    flashStatus = Unlocked;
}

void lockFlash(void)
{
    /* Lock the Flash to enable the flash control register access *************/
    while (HAL_FLASH_Lock() != HAL_OK)
    {
        while (HAL_FLASH_Unlock() != HAL_OK);  // Weird fix attempt
    }

    /* Lock Access to option bytes sector */
    while (HAL_FLASH_OB_Lock() != HAL_OK)
    {
        while (HAL_FLASH_OB_Unlock() != HAL_OK);  // Weird fix attempt
    }

    flashStatus = Locked;
}

void jumpToApp(const uint32_t AppAddr)
{
    typedef void (*app_t)(void);

    uint8_t i = 0;
    app_t   AppJump;

    __disable_irq();

    HAL_RCC_DeInit();

    SysTick->CTRL = 0;
    SysTick->LOAD = 0;
    SysTick->VAL  = 0;

    for (i = 0; i < 8; i++)
    {
        NVIC->ICER[i] = 0xFFFFFFFF;
        NVIC->ICPR[i] = 0xFFFFFFFF;
    }

    __enable_irq();

    AppJump = *(app_t*)(AppAddr + 4);

    /* Initialize user application's Main Stack Pointer */
    __set_MSP(*(uint32_t*)AppAddr);

    __set_CONTROL(0);

    // Jump to user application
    AppJump();
}

uint8_t string_compare(char array1[], char array2[], uint16_t length)
{
    uint8_t comVAR = 0, i;
    for (i = 0; i < length; i++)
    {
        if (array1[i] == array2[i])
        {
            comVAR++;
        }
        else
        {
            comVAR = 0;
        }
    }
    if (comVAR == length)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void errorBlink(void)
{
    HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
    while (1)
    {
        HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
        HAL_Delay(50);
        HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
        HAL_Delay(50);
    }
}

void messageHandler(uint8_t* Buf)
{
    if (string_compare((char*)Buf, ERASE_FLASH_MEMORY, strlen(ERASE_FLASH_MEMORY)) && flashStatus != Unlocked)
    {
        eraseMemory();
        CDC_Transmit_FS((uint8_t*)&"Flash: Erased!\n", strlen("Flash: Erased!\n"));
    }
    else if (string_compare((char*)Buf, FLASHING_START, strlen(FLASHING_START)))
    {
        unlockFlashAndEraseMemory();
        CDC_Transmit_FS((uint8_t*)&"Flash: Unlocked!\n", strlen("Flash: Unlocked!\n"));
    }
    else if (string_compare((char*)Buf, FLASHING_FINISH, strlen(FLASHING_FINISH)) && flashStatus == Unlocked)
    {
        lockFlash();
        CDC_Transmit_FS((uint8_t*)&"Flash: Success!\n", strlen("Flash: Success!\n"));
    }
    else if (string_compare((char*)Buf, FLASHING_ABORT, strlen(FLASHING_ABORT)) && flashStatus == Unlocked)
    {
        lockFlash();
        eraseMemory();
        CDC_Transmit_FS((uint8_t*)&"Flash: Aborted!\n", strlen("Flash: Aborted!\n"));
    }
    else
    {
        CDC_Transmit_FS((uint8_t*)&"Error: Incorrect step or unknown command!\n",
                        strlen("Error: Incorrect step or unknown command!\n"));
    }
}
