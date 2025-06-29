/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 * @file           : main.c
 * @brief          : Main program body
 ******************************************************************************
 * @attention
 *
 * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics.
 * All rights reserved.</center></h2>
 *
 * This software component is licensed by ST under Ultimate Liberty license
 * SLA0044, the "License"; You may not use this file except in compliance with
 * the License. You may obtain a copy of the License at:
 *                             www.st.com/SLA0044
 *
 ******************************************************************************
 */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "fatfs.h"
#include "usb_host.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "usbh_msc_scsi.h"
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
UART_HandleTypeDef huart1;

/* USER CODE BEGIN PV */
FATFS   fs;
FIL     UsbDataFile;
FRESULT FSresult;

uint32_t byteswritten, bytesread;                /* File write/read counts */
char     wtext[256] = "APP download was done! "; /* File write buffer */

#define IAP_PAGE_SIZE 2048  // 为了兼容F103

const char APP_FILE_NAME[] = "demo.bin";
FIL        UpdateFiles;
BYTE       iap_buffer[IAP_PAGE_SIZE];
UINT       BytesRead;
typedef void (*pFunction)(void);
pFunction     Jump_To_Application;
uint32_t      JumpAddress;
__IO uint32_t FlashProtection = 0;
uint8_t       tab_1024[1024]  = {0};

extern ApplicationTypeDef Appli_state;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void        SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_USART1_UART_Init(void);
void        MX_USB_HOST_Process(void);

/* USER CODE BEGIN PFP */
void FirmwareUpdate(void);
/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

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
    MX_FATFS_Init();
    MX_USB_HOST_Init();
    MX_USART1_UART_Init();
    /* USER CODE BEGIN 2 */

    uint32_t timeout = HAL_GetTick() + 5000;  // 5s

    __HAL_FLASH_CLEAR_FLAG(FLASH_FLAG_EOP | FLASH_FLAG_OPERR | FLASH_FLAG_WRPERR |
                           FLASH_FLAG_PGAERR | FLASH_FLAG_PGPERR | FLASH_FLAG_PGSERR);
    printf("start program...\r\n");

    if (FLASH_If_GetWriteProtectionStatus() == 0)
    {
        printf("Flash Write protection is enabled.");
			
        if (FLASH_If_DisableWriteProtection() == 1)
        {
            printf("\n\rWrite protection is disabled.\n\r");
        }
        else
        {
            printf("Failed to disable write protection.\r\n");
        }
    }
    /* USER CODE END 2 */

    /* Infinite loop */
    /* USER CODE BEGIN WHILE */
    while (1)
    {
        /* USER CODE END WHILE */
        MX_USB_HOST_Process();

        /* USER CODE BEGIN 3 */
        if (Appli_state == APPLICATION_READY)
        {
            if (f_mount(&fs, (TCHAR const*)USBHPath, 1) != FR_OK)  // 这里USBHPath="0:/" {0x30,0x3a,0x2f,0x00}
            {
                /* efs initialisation fails*/
                USBH_ErrLog("> Failed to load file system ");
            }
            USBH_UsrLog("> Load file system OK");
            USBH_UsrLog("> start to iap ");
            FirmwareUpdate();
            FSresult = f_open(&UsbDataFile, "APPresult.txt", FA_CREATE_ALWAYS | FA_WRITE | FA_READ);
            if (FSresult == FR_OK)
            {
                USBH_UsrLog("> opne/create file OK");
            }
            else if (FSresult == FR_EXIST)
            {
                USBH_UsrLog("> file is already existed. Overwire it.");
            }
            else
            {
                USBH_ErrLog("> Failed to open/create file ");
            }
            FSresult = f_write(&UsbDataFile, wtext, strlen(wtext), (void*)&byteswritten);
            sprintf(wtext, "app name is %s.", APP_FILE_NAME);
            f_write(&UsbDataFile, wtext, strlen(wtext), (void*)&byteswritten);
            if (FSresult == FR_OK)
            {
                USBH_UsrLog("> write file OK");
            }
            else
            {
                USBH_ErrLog("> Failed to write file ");
            }
            f_close(&UsbDataFile);
            USBH_UsrLog("> close file ");
            FATFS_UnLinkDriver(USBHPath);
            USBH_UsrLog("> disconnect file system ");
            Appli_state = APPLICATION_IDLE;
        }
        else if (Appli_state == APPLICATION_IDLE && (HAL_GetTick() > timeout))
        {
            printf("No USB Disk, Jump_To_Application~\n\r");
#if defined(USE_HAL_DRIVER)
            HAL_RCC_DeInit();
#endif /* defined(USE_HAL_DRIVER) */
#if defined(USE_STDPERIPH_DRIVER)
            RCC_DeInit();
#endif
            HAL_NVIC_DisableIRQ(TIM1_TRG_COM_TIM11_IRQn);
            HAL_NVIC_DisableIRQ(OTG_HS_IRQn);
            JumpAddress = *(__IO uint32_t*)(APPLICATION_ADDRESS + 4);

            Jump_To_Application = (pFunction)JumpAddress;
            __set_MSP(*(__IO uint32_t*)APPLICATION_ADDRESS);
            Jump_To_Application();
        }
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
    RCC_OscInitStruct.OscillatorType      = RCC_OSCILLATORTYPE_HSI | RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState            = RCC_HSE_ON;
    RCC_OscInitStruct.HSIState            = RCC_HSI_ON;
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
    RCC_OscInitStruct.PLL.PLLState        = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource       = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLM            = 25;
    RCC_OscInitStruct.PLL.PLLN            = 336;
    RCC_OscInitStruct.PLL.PLLP            = RCC_PLLP_DIV2;
    RCC_OscInitStruct.PLL.PLLQ            = 7;
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /** Initializes the CPU, AHB and APB buses clocks
     */
    RCC_ClkInitStruct.ClockType      = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource   = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider  = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;

    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) != HAL_OK)
    {
        Error_Handler();
    }
    HAL_RCC_MCOConfig(RCC_MCO1, RCC_MCO1SOURCE_HSI, RCC_MCODIV_1);
}

/**
 * @brief USART1 Initialization Function
 * @param None
 * @retval None
 */
static void MX_USART1_UART_Init(void)
{
    /* USER CODE BEGIN USART1_Init 0 */

    /* USER CODE END USART1_Init 0 */

    /* USER CODE BEGIN USART1_Init 1 */

    /* USER CODE END USART1_Init 1 */
    huart1.Instance          = USART1;
    huart1.Init.BaudRate     = 115200;
    huart1.Init.WordLength   = UART_WORDLENGTH_8B;
    huart1.Init.StopBits     = UART_STOPBITS_1;
    huart1.Init.Parity       = UART_PARITY_NONE;
    huart1.Init.Mode         = UART_MODE_TX_RX;
    huart1.Init.HwFlowCtl    = UART_HWCONTROL_NONE;
    huart1.Init.OverSampling = UART_OVERSAMPLING_16;
    if (HAL_UART_Init(&huart1) != HAL_OK)
    {
        Error_Handler();
    }
    /* USER CODE BEGIN USART1_Init 2 */

    /* USER CODE END USART1_Init 2 */
}

/**
 * @brief GPIO Initialization Function
 * @param None
 * @retval None
 */
static void MX_GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};
    /* USER CODE BEGIN MX_GPIO_Init_1 */
    /* USER CODE END MX_GPIO_Init_1 */

    /* GPIO Ports Clock Enable */
    __HAL_RCC_GPIOC_CLK_ENABLE();
    __HAL_RCC_GPIOH_CLK_ENABLE();
    __HAL_RCC_GPIOB_CLK_ENABLE();
    __HAL_RCC_GPIOA_CLK_ENABLE();

    /*Configure GPIO pin : PA8 */
    GPIO_InitStruct.Pin       = GPIO_PIN_8;
    GPIO_InitStruct.Mode      = GPIO_MODE_AF_PP;
    GPIO_InitStruct.Pull      = GPIO_NOPULL;
    GPIO_InitStruct.Speed     = GPIO_SPEED_FREQ_VERY_HIGH;
    GPIO_InitStruct.Alternate = GPIO_AF0_MCO;
    HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

    /* USER CODE BEGIN MX_GPIO_Init_2 */
    /* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */
int fputc(int ch, FILE* f)
{
    HAL_UART_Transmit(&huart1, (unsigned char*)&ch, 1, 1000);
    return (ch);
}

int fgetc(FILE* f)
{
    uint8_t ch = 0;
    HAL_UART_Receive(&huart1, &ch, 1, 0xffff);
    return ch;
}

void FirmwareUpdate(void)
{
    uint8_t   iap_status = HAL_OK;
    uint32_t  addrx, endaddr;
    uint32_t  iap_offset;
    uint32_t* pBuffer;

    {
        FSresult = f_open(&UpdateFiles, APP_FILE_NAME, FA_OPEN_EXISTING | FA_READ);

        if (FR_OK != FSresult)
        {
            printf("Not Find new App file :  ");
            printf(APP_FILE_NAME);
            printf("\n\r");
            return;
        }

        printf("Open app file Ok.\n\r");
        HAL_FLASH_Unlock();
        __HAL_FLASH_DATA_CACHE_DISABLE();
        printf("Unlock app flie Ok.\n\r");

        addrx      = APPLICATION_ADDRESS;              // 设置起始地址
        endaddr    = addrx + UpdateFiles.obj.objsize;  // 结束地址为起始地址加上文件大小。
        iap_status = STM32F4FLASH_CheckEmpty(addrx, endaddr);
        if (iap_status == HAL_FLASH_ERROR_NONE)
        {
            while (1)
            {
                FSresult = f_read(&UpdateFiles, iap_buffer, IAP_PAGE_SIZE, &BytesRead);
                if (FSresult || BytesRead == 0)
                {
                    break;
                }
                pBuffer = (uint32_t*)iap_buffer;
                for (iap_offset = 0; iap_offset < IAP_PAGE_SIZE || iap_offset < BytesRead; iap_offset += 4)
                {
                    if (HAL_FLASH_Program(FLASH_TYPEPROGRAM_WORD, addrx, *pBuffer) != HAL_OK)
                    {
                        printf("Flash download is wrong at %04x\n\r", addrx);
                        break;
                    }
                    addrx += 4;
                    pBuffer++;
                }
                if ((addrx - APPLICATION_ADDRESS) % (1024 * 64) == 0)
                {
                    printf("Flash download has been done for %dKB ...\n\r", (addrx - APPLICATION_ADDRESS) / 1024);
                }
                // LED1^=1;
                if (addrx >= endaddr)
                {
                    break;
                }
            }
            f_close(&UpdateFiles);
        }
        f_mount(&fs, (TCHAR const*)USBHPath, 0);

        printf("Download APP file is Ok.\n\r");
        __HAL_FLASH_DATA_CACHE_ENABLE();
        HAL_FLASH_Lock();
        printf("Flash Lock is Ok!\n\r");
    }
}

/* USER CODE END 4 */

/**
 * @brief  Period elapsed callback in non blocking mode
 * @note   This function is called  when TIM11 interrupt took place, inside
 * HAL_TIM_IRQHandler(). It makes a direct call to HAL_IncTick() to increment
 * a global variable "uwTick" used as application time base.
 * @param  htim : TIM handle
 * @retval None
 */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef* htim)
{
    /* USER CODE BEGIN Callback 0 */

    /* USER CODE END Callback 0 */
    if (htim->Instance == TIM11)
    {
        HAL_IncTick();
    }
    /* USER CODE BEGIN Callback 1 */

    /* USER CODE END Callback 1 */
}

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

#ifdef USE_FULL_ASSERT
/**
 * @brief  Reports the name of the source file and the source line number
 *         where the assert_param error has occurred.
 * @param  file: pointer to the source file name
 * @param  line: assert_param error line source number
 * @retval None
 */
void assert_failed(uint8_t* file, uint32_t line)
{
    /* USER CODE BEGIN 6 */
    /* User can add his own implementation to report the file name and line number,
       tex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
    /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
