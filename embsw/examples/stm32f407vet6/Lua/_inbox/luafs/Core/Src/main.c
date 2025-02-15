/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 * @file           : main.c
 * @brief          : Main program body
 ******************************************************************************
 * @attention
 *
 * Copyright (c) 2023 STMicroelectronics.
 * All rights reserved.
 *
 * This software is licensed under terms that can be found in the LICENSE file
 * in the root directory of this software component.
 * If no LICENSE file comes with this software, it is provided AS-IS.
 *
 ******************************************************************************
 */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "dma.h"
#include "fatfs.h"
#include "sdio.h"
#include "usart.h"
#include "usb_device.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "lua/api.h"
#include "stdbool.h"
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

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

const char lua_test[] = {
    "t_off = 500\n"
    "t_on = 500\n"
    "while 1 do\n"
    " led_on()\n"
    " sleep(t_on)\n"
    " led_off()\n"
    " sleep(t_off)\n"
    " print(\".\")\n"
    "end"};

void lua_run(void)
{
    lua_State* L;
    L = luaL_newstate();
    if (L == NULL)
    {
        printf("ERR");
        while (1) {};
    }
    luaopen_base(L);
    luaL_setfuncs(L, luaLib, 0);
    luaL_dostring(L, lua_test);
    lua_close(L);

    // luaL_dofile();
}

#include "fatfs.h"

FATFS    fs;
FATFS*   pfs;
FIL      fil;
FRESULT  fres;
DWORD    fre_clust;
uint32_t totalSpace, freeSpace;
char     buffer[100];

void SD_Error_Handler(char* file, int line)
{
    printf("%s:%d\r\n", file, line);
    while (1) {}
}

/**
 * @brief
 *
 * @param path the directory to be scanned
 * @param depth recursively searching sub-directory
 *
 */
FRESULT EnumFiles(char* path, uint8_t depth)
{
    FRESULT res;
    DIR     dir;
    UINT    i;

    static FILINFO fno;

    static char    cur_path[128];  // buffer
    static uint8_t cur_depth = 0;

    if (cur_depth == 0)
    {
        strcpy(cur_path, path);
    }

    /* Open the directory */
    res = f_opendir(&dir, cur_path);

    if (res == FR_OK)
    {
        for (;;)
        {
            /* Read a directory item */
            res = f_readdir(&dir, &fno);

            if (res != FR_OK || fno.fname[0] == 0)
            {
                /* Break on error or end of dir */
                break;
            }

            if (fno.fattrib & AM_DIR)
            {
                /* It is a directory */
                i = strlen(cur_path);
                sprintf(&cur_path[i], "/%s", fno.fname);

                if (cur_depth < depth)
                {
                    cur_depth++;

                    /* Enter the directory */
                    res = EnumFiles("", depth);

                    cur_depth--;

                    if (res != FR_OK)
                    {
                        break;
                    }
                }

                cur_path[i] = 0;
            }
            else
            {
                /* It is a file */
                printf("%s/%s %u\r\n", cur_path, fno.fname, fno.fsize);
            }
        }

        f_closedir(&dir);
    }
#if 0
    else
    {
        printf("err");
    }
#endif

    return res;
}

void SDTst()
{
    if (f_mount(&fs, "", 0) != FR_OK)
    {
        SD_Error_Handler(__FILE__, __LINE__);
    }

    /* Check freeSpace space */
    if (f_getfree("", &fre_clust, &pfs) != FR_OK)
    {
        SD_Error_Handler(__FILE__, __LINE__);
    }

    totalSpace = (uint32_t)((pfs->n_fatent - 2) * pfs->csize * 0.5);
    freeSpace  = (uint32_t)(fre_clust * pfs->csize * 0.5);

    printf("free space: %.2f MB\r\n", freeSpace / 1024.f);
    printf("total space: %.2f MB\r\n", totalSpace / 1024.f);

    /* free space is less than 1kb */
    if (freeSpace < 1)
    {
        SD_Error_Handler(__FILE__, __LINE__);
    }

    //	scan_files("/");

    /* Open file to write */

    if (f_open(&fil, "first.txt", FA_OPEN_ALWAYS | FA_READ | FA_WRITE) != FR_OK)
    {
        SD_Error_Handler(__FILE__, __LINE__);
    }

    /* Writing text */
    f_puts("STM32 SD Card I/O Example via SDIO\n", &fil);
    f_puts("Save OK!!!", &fil);

    /* Close file */
    if (f_close(&fil) != FR_OK)
    {
        SD_Error_Handler(__FILE__, __LINE__);
    }

    /* Open file to read */
    if (f_open(&fil, "first.txt", FA_READ) != FR_OK)
    {
        SD_Error_Handler(__FILE__, __LINE__);
    }

    while (f_gets(buffer, sizeof(buffer), &fil))
    {
        /* SWV output */
        printf("%s", buffer);
        fflush(stdout);
    }

    /* Close file */
    if (f_close(&fil) != FR_OK)
    {
        SD_Error_Handler(__FILE__, __LINE__);
    }

    /* scan file in dir*/

    // https://blog.csdn.net/unsv29/article/details/83301615
    // 这里�? fafts �? lock �? 2 改为 0 了，要不然有些地方搜索不�?, 报错�? FR_TOO_MANY_OPEN_FILES

    printf("\r\n[scan]:\r\n");
    EnumFiles("0:", 3);

    printf("\r\n[scan]:\r\n");
    EnumFiles("0:", 2);

    printf("\r\n[scan]:\r\n");
    EnumFiles("0:", 3);

    printf("\r\n[scan]:\r\n");
    EnumFiles("0:/dir", 1);

    /* Unmount SDCARD */
    //    if (f_mount(NULL, "", 1) != FR_OK)
    //        SD_Error_Handler(__FILE__, __LINE__);
}

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_USART1_UART_Init();
  MX_USB_DEVICE_Init();
  MX_SDIO_SD_Init();
  MX_FATFS_Init();
  /* USER CODE BEGIN 2 */
    SDTst();
    //  lua_run();
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
    while (1)
    {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
    }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 25;
  RCC_OscInitStruct.PLL.PLLN = 336;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 7;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) != HAL_OK)
  {
    Error_Handler();
  }
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
    /* User can add his own implementation to report the HAL error return state */
    __disable_irq();
    while (1)
    {
    }
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
       ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
