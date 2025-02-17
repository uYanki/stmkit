/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 * @file           : main.c
 * @brief          : Main program body
 ******************************************************************************
 * @attention
 *
 * Copyright (c) 2024 STMicroelectronics.
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
#include "adc.h"
#include "crc.h"
#include "dma.h"
#include "i2c.h"
#include "spi.h"
#include "tim.h"
#include "usart.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "typebasic.h"
#include "scheduler.h"
#include "bsp.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#define LOG_LOCAL_TAG   "main"
#define LOG_LOCAL_LEVEL LOG_LEVEL_VERBOSE

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */
__IO u16 ADConv[6];
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef* htim)
{
    if (htim == TIM_SCAN_B)  // period = 250us
    {
        SchedIsrB();
    }
}

#define ONE_ADC_VOLTAGE 806  // unit uV
#define AMP_GAIN        11.0

int phase_current_from_adcval(uint32_t ADCValue)
{
    PWM_PERIOD;

    int amp_gain = AMP_GAIN;

    int shunt_conductance = 500;  // 100 means 1 mOh, current sensing resistor

    int amp_out_volt = ONE_ADC_VOLTAGE * ADCValue;
    int shunt_volt   = amp_out_volt / amp_gain;
    int current      = (shunt_volt * 100) / shunt_conductance;  // unit mA
    return current;
}

void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc)
{
    static u32 a = 0;

    if (a == 0)
    {
        a = GetTickUs();
    }
    else
    {
      //  D._Resv266 = GetTickUs() - a;
    //    a          = GetTickUs();
    }

    SchedIsrA();

//    D._Resv262++;
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
    HAL_NVIC_DisableIRQ(SysTick_IRQn);
    /* USER CODE END SysInit */

    /* Initialize all configured peripherals */
    MX_GPIO_Init();
    MX_DMA_Init();
    MX_ADC1_Init();
    MX_I2C1_Init();
    MX_I2C2_Init();
    MX_TIM1_Init();
    MX_USART1_UART_Init();
    MX_USART3_UART_Init();
    MX_CRC_Init();
    MX_TIM6_Init();
    MX_USART2_UART_Init();
    MX_SPI1_Init();
    MX_TIM3_Init();
    MX_TIM14_Init();
    MX_TIM7_Init();
    /* USER CODE BEGIN 2 */

    // clkin = 64MHz
    // psc = 4 => tick = 16MHz = 1/16 us
    // arr = 16000 => irq freq = arr * psc = 1KHz;
    // GetTick100ns(){ n * tick * 16 / 10 }
    HAL_TIM_Base_Start_IT(TIM_BASE);

#if 0

    I2C_Master_Init(&i2c, 4e6, I2C_DUTYCYCLE_50_50);
    I2C_Master_ScanAddress(&i2c);

    // oled
    SSD1306_Reset();
    SSD1306_Init(&ssd1306);

    MonoFramebuf_FillRectangle(&fb, 10, 10, 20, 20, MONO_COLOR_WHITE);
    MonoFramebuf_FillRectangle(&fb, 20, 20, 20, 20, MONO_COLOR_XOR);
    MonoFramebuf_SetCursor(&fb, 0, 0);
    MonoFramebuf_PutString(&fb, "Servo", &g_Font_Conslons_8x16_CpuFlash, MONO_COLOR_WHITE, MONO_COLOR_BLACK);

    SSD1306_FillBuffer(&ssd1306, MonoFramebuf_GetBuffer(&fb));

#endif

    SchedCreat();
    SchedInit();

    D.u16UmdcHwCoeff = 3.3f * 10 * (470 + 10000) / 470;

    // adc
    HAL_ADCEx_Calibration_Start(&hadc1);
    HAL_ADC_Start_DMA(&hadc1, (uint32_t*)&ADConv[0], ARRAY_SIZE(ADConv));

    //	HAL_TIM_Base_Start(&htim1); // TRGO for ADC
    HAL_TIM_OC_Start(TIM_SCAN_A, TIM_CHANNEL_4);  // TRGO for ADC

    HAL_TIM_Base_Start_IT(TIM_SCAN_B);

#if 1  // debug only

    P(AXIS_0).eAppSel     = 0;
    P(AXIS_0).s32EncTurns = 0;

    P(AXIS_0).u32ElecGearDeno = 0;

    P(AXIS_0).eLoopRspModeSel = LOOP_RSP_MODE_SPD;
    P(AXIS_0).s64LoopRspStep  = 1000;

    P(AXIS_0).eCtrlMode = 1;

//    D.u16ScopeChSrc01 = SCOPE_SAMP_OBJ_USER_SPD_REF;
//    D.u16ScopeChSrc02 = SCOPE_SAMP_OBJ_USER_SPD_FB;
//    D.u16ScopeChSrc03 = 1;  // SCOPE_SAMP_OBJ_DRV_POS_REF;
//    D.u16ScopeChSrc04 = 1;  // SCOPE_SAMP_OBJ_DRV_POS_FB;

//    D.u16ScopeChAddr01 = 353;
//    D.u16ScopeChAddr02 = 355;
//    D.u16ScopeChAddr03 = 365;
//    D.u16ScopeChAddr04 = 367;

    //    D.u16ScopeChAddr01 = 357;
    //    D.u16ScopeChAddr02 = 358;
    //    D.u16ScopeChAddr03 = 358;

    P(AXIS_0).s16SpdDigRef = 500;
    P(AXIS_0).u16TrqLimFwd = 1000;

#endif

    /* USER CODE END 2 */

    /* Infinite loop */
    /* USER CODE BEGIN WHILE */

    while (1)
    {
        SchedCycle();

      //  PeriodicTask(3 * UNIT_S, { D._Resv261 = D._Resv262 / 3; D._Resv262=0; });

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
    HAL_PWREx_ControlVoltageScaling(PWR_REGULATOR_VOLTAGE_SCALE1);

    /** Initializes the RCC Oscillators according to the specified parameters
     * in the RCC_OscInitTypeDef structure.
     */
    RCC_OscInitStruct.OscillatorType      = RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState            = RCC_HSI_ON;
    RCC_OscInitStruct.HSIDiv              = RCC_HSI_DIV1;
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
    RCC_OscInitStruct.PLL.PLLState        = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource       = RCC_PLLSOURCE_HSI;
    RCC_OscInitStruct.PLL.PLLM            = RCC_PLLM_DIV1;
    RCC_OscInitStruct.PLL.PLLN            = 8;
    RCC_OscInitStruct.PLL.PLLP            = RCC_PLLP_DIV2;
    RCC_OscInitStruct.PLL.PLLR            = RCC_PLLR_DIV2;
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /** Initializes the CPU, AHB and APB buses clocks
     */
    RCC_ClkInitStruct.ClockType      = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1;
    RCC_ClkInitStruct.SYSCLKSource   = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider  = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;

    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
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
       ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
    /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
