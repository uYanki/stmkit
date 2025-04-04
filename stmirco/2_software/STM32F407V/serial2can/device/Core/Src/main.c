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
#include "can.h"
#include "dma.h"
#include "usart.h"
#include "usb_device.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include <stdio.h>
#include <stdbool.h>
#include "serdrv.h"
#include "candrv.h"
#include "usbd_cdc_if.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

#define COMM_TX_UART_BLOCK    1
#define COMM_TX_UART_DMA      2
#define COMM_TX_USB_CDC       3

#define CONFIG_COMM_TX_METHOD COMM_TX_USB_CDC
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

#define CONFIG_RXBUF_SIZE 256

uint8_t m_rxbuf[CONFIG_RXBUF_SIZE] = {'1', '2', '3'};

uint8_t  len  = 0;
uint8_t* pbuf = m_rxbuf;

int fputc(int ch, FILE* f)
{
    HAL_UART_Transmit(&huart1, (uint8_t*)&ch, 1, 0xFF);
    return ch;
}

void UART_IRQHandlerEx(UART_HandleTypeDef* huart)
{
#if 0
	
    if (huart->Instance == USART1)
    {
        if (__HAL_UART_GET_FLAG(huart, UART_FLAG_IDLE) == SET)
        {
            __HAL_UART_CLEAR_IDLEFLAG(huart);
            HAL_UART_DMAStop(huart);

            // shell callback
					 len  = CONFIG_RXBUF_SIZE - __HAL_DMA_GET_COUNTER(&hdma_usart1_rx);
					pbuf = m_rxbuf;
					
            HAL_UART_Receive_DMA(huart, m_rxbuf, CONFIG_RXBUF_SIZE);
        }
    }

#endif
}

bool Serial_TxMsg(uint8_t* pbuf, uint16_t len)
{
#if CONFIG_COMM_TX_METHOD == COMM_TX_UART_BLOCK
    if (HAL_UART_Transmit(&huart1, (uint8_t*)pbuf, len, 0xFFFF) != HAL_OK)
#elif CONFIG_COMM_TX_METHOD == COMM_TX_UART_DMA
    if (HAL_UART_Transmit_DMA(&huart1, (uint8_t*)pbuf, len) != HAL_OK)
#elif CONFIG_COMM_TX_METHOD == COMM_TX_USB_CDC
    if (CDC_Transmit_HS(pbuf, len) != USBD_OK)
#endif
    {
        return false;
    }

    return true;
}

#if 1

bool PacketDecode(uint8_t* data, uint16_t len, can_msg_t* msg)
{
    return 0;
}

bool PacketEncode(can_msg_t* msg)
{
    uint8_t  frame[30];
    uint32_t caninfo  = 0;
    uint8_t  checksum = 0;

    frame[0] = 0xAA;
    frame[1] = 0x55;
    frame[2] = 0x03;

    caninfo |= (msg->flags.rtr << 1);
    caninfo |= (msg->flags.extended << 2);

    if (msg->flags.extended == 1)
    {
        caninfo |= (msg->id << 3);
    }
    else
    {
        caninfo |= (msg->id << 21);
    }

    frame[3] = (caninfo >> 24) & 0xFF;
    frame[4] = (caninfo >> 16) & 0xFF;
    frame[5] = (caninfo >> 8) & 0xFF;
    frame[6] = (caninfo >> 0) & 0xFF;

    frame[7]  = 0x00;
    frame[8]  = 0x00;
    frame[9]  = 0x00;
    frame[10] = msg->length & 0x0F;

    frame[11] = msg->data[7];
    frame[12] = msg->data[6];
    frame[13] = msg->data[5];
    frame[14] = msg->data[4];
    frame[15] = msg->data[3];
    frame[16] = msg->data[2];
    frame[17] = msg->data[1];
    frame[18] = msg->data[0];

    for (uint8_t i = 0; i < 28; i++)
    {
        checksum += frame[i];
    }

    frame[28] = checksum;
    frame[29] = 0x88;

    return Serial_TxMsg(frame, sizeof(frame));
}

typedef enum {
    CMD_GET_START,
    CMD_GET_HRAD,
    CMD_GET_DATA,
    CMD_GET_CRC,
    CMD_GET_END
} cmd_rxfsm_e;

uint8_t checksum(uint8_t* pbuf)
{
    uint8_t res = 0;
    uint8_t i   = 0;

    for (i = 0; i < 28; i++)
    {
        res += pbuf[i];
    }

    return res;
}

bool PacketRxFSM(cmd_rxfsm_e* fsm, uint8_t* frame, uint16_t* index2, uint8_t input)
{
    static uint16_t index = 0;
    switch (*fsm)
    {
        case CMD_GET_START:
            if (input == 0x55)
            {
                *fsm     = CMD_GET_HRAD;
                frame[0] = input;
                index++;
            }
            break;
        case CMD_GET_HRAD:
            if (input == 0xAA)
            {
                *fsm     = CMD_GET_DATA;
                frame[1] = input;
                index++;
            }
            else
            {
                index = 0;
                *fsm  = CMD_GET_START;
            }
            break;
        case CMD_GET_DATA:
            frame[index] = input;
            index++;
            if (index > 27)
            {
                *fsm = CMD_GET_CRC;
            }
            break;
        case CMD_GET_CRC:
            // ĺ¤ć­ć ĄéŞĺ?
            if (input == checksum(frame))
            {
                frame[index] = input;
                index++;
                *fsm = CMD_GET_END;
            }
            else
            {
                index = 0;
                *fsm  = CMD_GET_START;
            }
            break;
        case CMD_GET_END:
            frame[index] = input;
            index        = 0;
            *fsm         = CMD_GET_START;

            if (input == 0x88)
            {
                return true;
            }

            break;
    }

    return false;
}

bool Handshark_connected = false;
void a123(uint8_t byte)
{
    uint16_t           index = 0;
    uint8_t            frame[30];
    static cmd_rxfsm_e fsm = CMD_GET_START;

    if (PacketRxFSM(&fsm, &frame[0], &index, byte))
    {
        Handshark_connected = 1;

        switch (frame[2])
        {
            case 0xFF:
            {
                if (frame[3])
                {
                    Handshark_connected = 1;
                    HAL_GPIO_WritePin(LED1_GPIO_Port, LED1_Pin, GPIO_PIN_RESET);
                }
                else
                {
                    Handshark_connected = 0;
                    HAL_GPIO_WritePin(LED1_GPIO_Port, LED1_Pin, GPIO_PIN_SET);
                }
                // ćĄć
                break;
            }
            case 0x01:  // set bitrate
            {
                uint8_t  MODE  = frame[3];
                uint8_t  TSEG1 = frame[4];
                uint8_t  TSEG2 = frame[5];
                uint32_t BRP   = (frame[6] << 8) | (frame[7] << 0);

                switch (MODE)
                {
                    default:
                    case 1: CAN_SetMode(&hcan1, CAN_MODE_NORMAL); break;
                    case 2: CAN_SetMode(&hcan1, CAN_MODE_LOOPBACK); break;
                    case 3: CAN_SetMode(&hcan1, CAN_MODE_SILENT); break;
                    case 4: CAN_SetMode(&hcan1, CAN_MODE_SILENT_LOOPBACK); break;
                }

                switch (TSEG1)
                {
                    default:
                    case 1: CAN_SetBtr(&hcan1, CAN_BTR_1000K); break;
                    case 2: CAN_SetBtr(&hcan1, CAN_BTR_500K); break;
                    case 3: CAN_SetBtr(&hcan1, CAN_BTR_250K); break;
                    case 4: CAN_SetBtr(&hcan1, CAN_BTR_125K); break;
                    case 5: CAN_SetBtr(&hcan1, CAN_BTR_100K); break;
                    case 6: CAN_SetBtr(&hcan1, CAN_BTR_50K); break;
                    // case 7: CAN_SetBtr(&hcan1, CAN_BTR_20K); break;
                    case 8: CAN_SetBtr(&hcan1, CAN_BTR_10K); break;
                    case 9: CAN_SetBtr(&hcan1, CAN_BTR_800K); break;
                }

                break;
            }
            case 0x02:  // set filter
            {
                uint32_t acceptance_code = 0;
                uint32_t acceptance_mask = 0;

                if (frame[4])
                {
                    acceptance_code = (frame[5] << 24) + (frame[6] << 16) + (frame[7] << 8) + (frame[8] << 0);
                    acceptance_mask = (frame[9] << 24) + (frame[10] << 16) + (frame[11] << 8) + (frame[12] << 0);
                }
                else
                {
                    acceptance_code = 0;
                    acceptance_mask = 0xFFFFFFFF;
                }

                break;
            }
            case 0x03:  // cantx
            {
                can_msg_t msg;

                uint32_t caninfo = (frame[3] << 24) + (frame[4] << 16) + (frame[5] << 8) + (frame[6] << 0);

                msg.flags.rtr      = (caninfo >> 1) & 0x01;
                msg.flags.extended = (caninfo >> 2) & 0x01;

                if (msg.flags.extended == 1)
                {
                    msg.id = (caninfo >> 3) & 0x1FFFFFFF;
                }
                else
                {
                    msg.id = (caninfo >> 21) & 0x7FF;
                }

                msg.length = frame[10] & 0x0F;

                msg.data[7] = frame[11];
                msg.data[6] = frame[12];
                msg.data[5] = frame[13];
                msg.data[4] = frame[14];
                msg.data[3] = frame[15];
                msg.data[2] = frame[16];
                msg.data[1] = frame[17];
                msg.data[0] = frame[18];

                // txcount++;
                if (CAN_TxMsg(&hcan1, &msg))
                {
                    // PacketEncode(&msg);
                    // txcount_success++;
                }

                break;
            }
            case 0x04:  // softreset
            {
                HAL_NVIC_SystemReset();
                break;
            }
            case 0x05:  // clear frame counter
            {
                // ć¸é¤ĺ¸§čŽĄć?
                break;
            }
        }
    }
}

#if 0

uint8_t CDC_CMD_TX_INFO_pack(void)
{
    uint32_t           baudrate = 0;
    twai_status_info_t info;
    uint8_t            data[30];
    memset(data, 0x00, sizeof(data));
    if (data == NULL)
    {
        return 0;
    }
    data[0] = 0xAA;
    data[1] = 0x55;
    data[2] = 0x01;
    // ćť¤ćł˘ĺ¨ä˝żč˝ä¸Şć?
    data[3] = 0x00;
    data[6] = TWAI_BUS_OFF;
    data[7] = ERROR_CODE;
    if (twai_get_status_info(&info) == ESP_OK)
    {
        // ĺé?éčŻŻčŽĄć?
        data[8] = info.tx_error_counter;
        // ćĽćśéčŻŻčŽĄć°
        data[9] = info.rx_error_counter;
    }
    // čŽĄçŽćł˘çšç?
    baudrate = caluate_baudrate();
    data[10] = (baudrate >> 16) & 0xFF;
    data[11] = (baudrate >> 8) & 0xFF;
    data[12] = (baudrate >> 0) & 0xFF;
    // ĺé?čŽĄć?
    data[13] = (twai_count.TX_COUNT >> 24) & 0xFF;
    data[14] = (twai_count.TX_COUNT >> 16) & 0xFF;
    data[15] = (twai_count.TX_COUNT >> 8) & 0xFF;
    data[16] = (twai_count.TX_COUNT >> 0) & 0xFF;

    // ĺé?ćĺčŽĄć?
    data[17] = (twai_count.TX_SUCCESS >> 24) & 0xFF;
    data[18] = (twai_count.TX_SUCCESS >> 16) & 0xFF;
    data[19] = (twai_count.TX_SUCCESS >> 8) & 0xFF;
    data[20] = (twai_count.TX_SUCCESS >> 0) & 0xFF;

    // ĺé?ĺ¤ąč´ĽčŽĄć?
    data[21] = ((twai_count.TX_COUNT - twai_count.TX_SUCCESS) >> 24) & 0xFF;
    data[22] = ((twai_count.TX_COUNT - twai_count.TX_SUCCESS) >> 16) & 0xFF;
    data[23] = ((twai_count.TX_COUNT - twai_count.TX_SUCCESS) >> 8) & 0xFF;
    data[24] = ((twai_count.TX_COUNT - twai_count.TX_SUCCESS) >> 0) & 0xFF;

    data[28] = caluate_CRC(data);
    data[29] = 0x88;
    if (Handshark_connected)
    {
        if (CDC_TX_MSG(data, sizeof(data)) == 0)
        {
            return 0;
        }
    }
    return 1;
}

uint8_t CDC_CMD_RX_INFO_pack(void)
{
    uint8_t data[30];
    memset(data, 0x00, sizeof(data));
    if (data == NULL)
    {
        return 0;
    }
    data[0] = 0xAA;
    data[1] = 0x55;
    data[2] = 0x02;

    data[3] = ((twai_count.RX_OK) >> 24) & 0xFF;
    data[4] = ((twai_count.RX_OK) >> 16) & 0xFF;
    data[5] = ((twai_count.RX_OK) >> 8) & 0xFF;
    data[6] = ((twai_count.RX_OK) >> 0) & 0xFF;

    data[28] = caluate_CRC(data);
    data[29] = 0x88;
    if (Handshark_connected)
    {
        if (CDC_TX_MSG(data, sizeof(data)) == 0)
        {
            return 0;
        }
    }
    return 1;
}

static void CDC_UPDATE_task(void* arg)
{
    while (1)
    {
        CDC_CMD_TX_INFO_pack();
        vTaskDelay(100);
        CDC_CMD_RX_INFO_pack();
        vTaskDelay(100);
    }
}

#endif

#endif

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
    MX_CAN1_Init();
    MX_CAN2_Init();
    MX_USB_DEVICE_Init();
    /* USER CODE BEGIN 2 */

#if 0
    __HAL_UART_ENABLE_IT(&huart1, UART_IT_IDLE);
    HAL_UART_Receive_DMA(&huart1, m_rxbuf, CONFIG_RXBUF_SIZE);
#endif

    CAN_Open(&hcan1);
    CAN_Open(&hcan2);

    uint32_t  t = 0;
    can_msg_t msg, msg2;

    msg.id             = 0x78;
    msg.flags.rtr      = 0;
    msg.flags.extended = 0;
    msg.length         = 4;
    msg.data[0]        = 0xFF;
    msg.data[1]        = 0xEE;
    msg.data[2]        = 0xDD;
    msg.data[3]        = 0xCC;

    msg2.id             = 0x12347856;
    msg2.flags.rtr      = 0;
    msg2.flags.extended = 1;
    msg2.length         = 8;
    msg2.data[0]        = 0x01;
    msg2.data[1]        = 0x11;
    msg2.data[2]        = 0x22;
    msg2.data[3]        = 0x33;
    msg2.data[4]        = 0x00;
    msg2.data[5]        = 0x11;
    msg2.data[6]        = 0x22;
    msg2.data[7]        = 0x33;

    /* USER CODE END 2 */

    /* Infinite loop */
    /* USER CODE BEGIN WHILE */
    while (1)
    {
        if ((HAL_GetTick() - t) > 1000)
        {
            t = HAL_GetTick();

//            PacketEncode(&msg);
//            HAL_Delay(10);
//            PacketEncode(&msg2);
//            HAL_Delay(10);
#if 0
            
            if (CAN_TxMsg(&hcan1, &msg))
            {
                HAL_Delay(10);
              
                Serial_LogCanMsg(1, CAN_DIR_TX, &msg);
               HAL_Delay(10);
            }
          
            if (CAN_TxMsg(&hcan2, &msg2))
            {
         
                HAL_Delay(10);
                Serial_LogCanMsg(2, CAN_DIR_TX, &msg2);
                HAL_Delay(10);
            }

#endif
        }

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
    RCC_OscInitStruct.HSEState       = RCC_HSE_ON;
    RCC_OscInitStruct.PLL.PLLState   = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource  = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLM       = 25;
    RCC_OscInitStruct.PLL.PLLN       = 336;
    RCC_OscInitStruct.PLL.PLLP       = RCC_PLLP_DIV2;
    RCC_OscInitStruct.PLL.PLLQ       = 7;
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
}

/* USER CODE BEGIN 4 */

void CAN_SetFltrMsk(CAN_HandleTypeDef* hcan, uint32_t filter, uint32_t mask) {}

// typedef enum {
//     CAN_MODE_LISTEN_ONLY,  //!< der CAN Contoller empfĂ¤ngt nur und verhĂ¤lt sich vĂśllig passiv
//     CAN_MODE_LOOPBACK,     //!< alle Nachrichten direkt auf die Empfangsregister umleiten ohne sie zu senden
//     CAN_MODE_NORMAL,       //!< normaler Modus, CAN Controller ist aktiv
//     CAN_MODE_SLEEP,        //!< sleep mode
// } can_mode_e;

void CAN_Scan() {}
void CAN_Dump() {}

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
