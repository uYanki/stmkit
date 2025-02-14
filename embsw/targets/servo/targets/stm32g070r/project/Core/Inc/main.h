/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32g0xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define I2C_OLED hi2c1
#define TIM_HALL htim3
#define UART_TFORMAT huart3
#define TIM_PERIOD 8000
#define N_FAULT_Pin GPIO_PIN_13
#define N_FAULT_GPIO_Port GPIOC
#define SWI2C_SDA_Pin GPIO_PIN_1
#define SWI2C_SDA_GPIO_Port GPIOC
#define SWI2C_SCL_Pin GPIO_PIN_2
#define SWI2C_SCL_GPIO_Port GPIOC
#define ADC_IW_Pin GPIO_PIN_0
#define ADC_IW_GPIO_Port GPIOA
#define ADC_IU_Pin GPIO_PIN_1
#define ADC_IU_GPIO_Port GPIOA
#define ADC_TEMP_Pin GPIO_PIN_2
#define ADC_TEMP_GPIO_Port GPIOA
#define ADC_VBUS_Pin GPIO_PIN_3
#define ADC_VBUS_GPIO_Port GPIOA
#define AI_POT1_Pin GPIO_PIN_4
#define AI_POT1_GPIO_Port GPIOA
#define AI_POT2_Pin GPIO_PIN_5
#define AI_POT2_GPIO_Port GPIOA
#define RS485_TX1_Pin GPIO_PIN_4
#define RS485_TX1_GPIO_Port GPIOC
#define RS485_RX1_Pin GPIO_PIN_5
#define RS485_RX1_GPIO_Port GPIOC
#define RS485_RTS1_Pin GPIO_PIN_1
#define RS485_RTS1_GPIO_Port GPIOB
#define RS485_TX2_Pin GPIO_PIN_10
#define RS485_TX2_GPIO_Port GPIOB
#define RS485_RX2_Pin GPIO_PIN_11
#define RS485_RX2_GPIO_Port GPIOB
#define RS485_RTS2_Pin GPIO_PIN_12
#define RS485_RTS2_GPIO_Port GPIOB
#define PWM_UL_Pin GPIO_PIN_13
#define PWM_UL_GPIO_Port GPIOB
#define PWM_VL_Pin GPIO_PIN_14
#define PWM_VL_GPIO_Port GPIOB
#define PWM_WL_Pin GPIO_PIN_15
#define PWM_WL_GPIO_Port GPIOB
#define PWM_UH_Pin GPIO_PIN_8
#define PWM_UH_GPIO_Port GPIOA
#define PWM_VLA9_Pin GPIO_PIN_9
#define PWM_VLA9_GPIO_Port GPIOA
#define PWM_WH_Pin GPIO_PIN_10
#define PWM_WH_GPIO_Port GPIOA
#define LED1_Pin GPIO_PIN_9
#define LED1_GPIO_Port GPIOC
#define LED2_Pin GPIO_PIN_0
#define LED2_GPIO_Port GPIOD
#define KEY1_Pin GPIO_PIN_1
#define KEY1_GPIO_Port GPIOD
#define KEY2_Pin GPIO_PIN_2
#define KEY2_GPIO_Port GPIOD
#define KEY3_Pin GPIO_PIN_3
#define KEY3_GPIO_Port GPIOD
#define SPI1_CS_Pin GPIO_PIN_6
#define SPI1_CS_GPIO_Port GPIOB
#define OLED_RST_Pin GPIO_PIN_9
#define OLED_RST_GPIO_Port GPIOB

/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
