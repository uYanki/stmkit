/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f4xx_hal.h"

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
#define LED1_Pin GPIO_PIN_8
#define LED1_GPIO_Port GPIOF
#define LED0_Pin GPIO_PIN_1
#define LED0_GPIO_Port GPIOC
#define ECAT_RST_Pin GPIO_PIN_1
#define ECAT_RST_GPIO_Port GPIOB
#define ECAT_EP_LOADED_Pin GPIO_PIN_4
#define ECAT_EP_LOADED_GPIO_Port GPIOG
#define ET1100_INT_Pin GPIO_PIN_3
#define ET1100_INT_GPIO_Port GPIOD
#define ET1100_INT_EXTI_IRQn EXTI3_IRQn
#define FSMC_NE1_ECAT_Pin GPIO_PIN_7
#define FSMC_NE1_ECAT_GPIO_Port GPIOD
#define ECAT_SYNC0_Pin GPIO_PIN_10
#define ECAT_SYNC0_GPIO_Port GPIOG
#define ECAT_SYNC0_EXTI_IRQn EXTI15_10_IRQn
#define ECAT_SYNC1_Pin GPIO_PIN_11
#define ECAT_SYNC1_GPIO_Port GPIOG
#define ECAT_SYNC1_EXTI_IRQn EXTI15_10_IRQn
#define ECAT_EP_WP_Pin GPIO_PIN_14
#define ECAT_EP_WP_GPIO_Port GPIOG
#define ECAT_EP_SCL_Pin GPIO_PIN_6
#define ECAT_EP_SCL_GPIO_Port GPIOB
#define ECAT_EP_SDA_Pin GPIO_PIN_7
#define ECAT_EP_SDA_GPIO_Port GPIOB

/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
