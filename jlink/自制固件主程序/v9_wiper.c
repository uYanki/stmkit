/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2021 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include <string.h>
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */
__no_init uint32_t btl_magic @ 0x20000000;
__no_init uint32_t btl_magic1 @ 0x20000004;
#pragma location=0x08010210
__root const char fwversion[] = "J-Link V9 compiled Mr4 11 2019 19:34:10";
__no_init uint8_t flashcache16k[16*1024];
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
void MX_GPIO_Init(void);
void FillOTSFlash();
int main(void)
{
  /* USER CODE BEGIN 1 */
  // TODO: HCLK>=1MHz
  __disable_irq();
  FillOTSFlash();
  __enable_irq();
  __set_BASEPRI(0x80);
  btl_magic = 0x12344321;
  __disable_irq();
  SCB->VTOR = 0x08000000;
  SCB->AIRCR = 0x05FA0000 | 4;
  while (1);
}


/* USER CODE BEGIN 4 */
void flash_unlock()
{
    if (FLASH->CR & FLASH_CR_LOCK) {
        FLASH->KEYR = 0x45670123;
        FLASH->KEYR = 0xCDEF89AB;
    }
}

void flash_lock()
{
    FLASH->CR |= FLASH_CR_LOCK;
}

void flash_waitbusy()
{
    while (FLASH->SR & FLASH_SR_BSY);
}

void FillOTSFlash()
{
    // Read 16k from sector2
    memcpy(flashcache16k, (void*)0x08008000, 16*1024);
    // Fill OTS content
    // TODO: only remove RDI/JFlash based on serial?
    memset(&flashcache16k[0xBF00-0x8000], 0xFF, 0x100);
    // Erase sector2 (0x0800 8000 - 0x0800 BFFF)
    flash_unlock();
    flash_waitbusy();
    FLASH->CR = FLASH->CR & ~FLASH_CR_PSIZE | 2 << FLASH_CR_PSIZE_Pos; // 2.7~3.6V, Psize = WORD
    FLASH->CR = FLASH->CR & ~FLASH_CR_SNB | 2 << FLASH_CR_SNB_Pos | FLASH_CR_SER; // Sector erase, sector number 2
    FLASH->CR |= FLASH_CR_STRT;
    flash_waitbusy();
    // Earse done, do write
    __IO uint32_t* flash = (uint32_t*)0x08008000;
    uint32_t* cache = (uint32_t*)flashcache16k;
    for (int i = 0; i < 16*1024/4; i++) {
        FLASH->CR |= FLASH_CR_PG;
        *flash++ = *cache++;
        flash_waitbusy();
    }

    flash_lock();
}
/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */

  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{ 
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     tex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
