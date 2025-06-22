/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2025 STMicroelectronics.
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
#include "fatfs.h"
#include "usart.h"
#include "usb_host.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

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
extern char USBHPath[4];   /* USBH logical drive path */
extern FATFS USBHFatFS;    /* File system object for USBH logical drive */
extern FIL USBHFile;       /* File object for USBH */
extern ApplicationTypeDef Appli_state;

#define BUFF_LEN	256
uint8_t buttonFlag = 0;
uint8_t buffer[BUFF_LEN];
uint32_t bytesWritten, bytesRead;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
void MX_USB_HOST_Process(void);

/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	static uint32_t debounce = 0;
	static uint32_t now = 0;
printf("%d bytes read\r\n", Appli_state);
	if(GPIO_Pin == KEY_Pin)
	{
		now = HAL_GetTick();
		if(now - debounce < 200) return;
		debounce = HAL_GetTick();
		buttonFlag = 1;
	}
}

void MountUSB(void)
{
	FRESULT res = f_mount(&USBHFatFS, USBHPath, 0);
	if(res != FR_OK) Error_Handler();

	HAL_GPIO_WritePin(LED0_GPIO_Port, LED0_Pin, GPIO_PIN_SET);
	HAL_GPIO_WritePin(LED1_GPIO_Port, LED1_Pin, GPIO_PIN_RESET);
}

void UnMountUSB(void)
{
	FRESULT res = f_mount(NULL, "", 0);
	if(res != FR_OK) Error_Handler();

	HAL_GPIO_WritePin(LED0_GPIO_Port, LED0_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(LED1_GPIO_Port, LED1_Pin, GPIO_PIN_SET);
}

void OpenFile()
{
	FRESULT res = f_open(&USBHFile, "hello.txt", FA_OPEN_ALWAYS | FA_READ | FA_WRITE);
	if(res != FR_OK) Error_Handler();
}

void CloseFile()
{
	FRESULT res = f_close(&USBHFile);
	if(res != FR_OK) Error_Handler();
}

uint32_t ReadFile(uint8_t *buff, uint16_t len)
{
	memset(buff, 0, len);
	FRESULT res = f_read(&USBHFile, buff, len, (void*)&bytesRead);
	if(res != FR_OK) Error_Handler();

	return bytesRead;
}

uint32_t WriteFile(uint8_t *buff, uint16_t len)
{
	FRESULT res;
	res = f_lseek(&USBHFile, f_size(&USBHFile));
	if(res != FR_OK) Error_Handler();

	res = f_write(&USBHFile, buff, len, (void*)&bytesWritten);
	if(res != FR_OK) Error_Handler();

	return bytesWritten;
}

void TruncateFile()
{
	FRESULT res;
	res = f_open(&USBHFile, "hello.txt", FA_OPEN_ALWAYS | FA_READ | FA_WRITE);
	if(res != FR_OK) Error_Handler();

	res = f_lseek(&USBHFile, 0);
	if(res != FR_OK) Error_Handler();

	res = f_truncate(&USBHFile);
	if(res != FR_OK) Error_Handler();

	res = f_close(&USBHFile);
	if(res != FR_OK) Error_Handler();
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
  MX_USB_HOST_Init();
  MX_FATFS_Init();
  MX_USART1_UART_Init();
  /* USER CODE BEGIN 2 */
	
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */
    MX_USB_HOST_Process();

    /* USER CODE BEGIN 3 */
		if(Appli_state == APPLICATION_READY && buttonFlag)
		{
			buttonFlag = 0;

			OpenFile();
			char *msg = "Hello! STM32 Mass Storage Testing...\r\n";
			uint32_t nWritten = WriteFile((uint8_t*)msg, strlen(msg));
			printf("%d bytes written\r\n", nWritten);
			CloseFile();

			OpenFile();
			uint32_t nRead = ReadFile(buffer, BUFF_LEN);
			printf("%d bytes read\r\n", nRead);
			CloseFile();

			printf("%s", buffer);
			fflush(stdout);

			if(nRead >=  BUFF_LEN)
			{
				TruncateFile();
			}
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

int fputc(int ch, FILE* f)
{
    if (ch == '\n')
    {
        HAL_UART_Transmit(&huart1, (uint8_t*)"\r", 1, 0xFF);
    }

    HAL_UART_Transmit(&huart1, (uint8_t*)&ch, 1, 0xFF);

    return (ch);
}

int fgetc(FILE* f)
{
    uint8_t ch = '\0';
    HAL_UART_Receive(&huart1, &ch, 1, 0xFF);
    return ch;
}

void putchar_(char ch)
{
    HAL_UART_Transmit(&huart1, (uint8_t*)&ch, 1, 0xFF);
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
