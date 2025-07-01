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

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include <stdio.h>
#include "string.h"
#include "socket.h"
#include "dhcp.h"

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#ifndef DATA_BUF_SIZE
#define DATA_BUF_SIZE 2048
#endif

#define LOOPBACK_MAIN_NOBLOCK 0
#define LOOPBACK_MODE         LOOPBACK_MAIN_NOBLOCK

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
SPI_HandleTypeDef hspi1;

UART_HandleTypeDef huart1;

/* USER CODE BEGIN PV */
uint8_t     destip[4] = {192, 168, 137, 1};
uint16_t    destport  = 3333;
uint8_t     rxbuf[DATA_BUF_SIZE]= {0};
uint8_t     txbuf[1024] = {0};
wiz_NetInfo gWIZNETINFO;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void        SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_USART1_UART_Init(void);
static void MX_SPI1_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

void Load_Net_Parameters(void)
{
    gWIZNETINFO.gw[0] = 192;  // Gateway
    gWIZNETINFO.gw[1] = 168;
    gWIZNETINFO.gw[2] = 137;
    gWIZNETINFO.gw[3] = 1;

    gWIZNETINFO.sn[0] = 255;  // Mask
    gWIZNETINFO.sn[1] = 255;
    gWIZNETINFO.sn[2] = 255;
    gWIZNETINFO.sn[3] = 0;

    gWIZNETINFO.mac[0] = 0x0c;  // MAC
    gWIZNETINFO.mac[1] = 0x29;
    gWIZNETINFO.mac[2] = 0xab;
    gWIZNETINFO.mac[3] = 0x7c;
    gWIZNETINFO.mac[4] = 0x00;
    gWIZNETINFO.mac[5] = 0x01;

    gWIZNETINFO.ip[0] = 192;  // IP
    gWIZNETINFO.ip[1] = 168;
    gWIZNETINFO.ip[2] = 137;
    gWIZNETINFO.ip[3] = 204;

    gWIZNETINFO.dhcp = NETINFO_STATIC;
}

int32_t loopback_tcpc(uint8_t sn, uint8_t* buf, uint8_t* destip, uint16_t destport)
{
    int32_t  ret;  // return value for SOCK_ERRORs
    uint16_t size = 0, sentsize = 0;

    // Destination (TCP Server) IP info (will be connected)
    // >> loopback_tcpc() function parameter
    // >> Ex)
    //	uint8_t destip[4] = 	{192, 168, 0, 214};
    //	uint16_t destport = 	5000;

    // Port number for TCP client (will be increased)
    static uint16_t any_port = 50000;

    // Socket Status Transitions
    // Check the W5500 Socket n status register (Sn_SR, The 'Sn_SR' controlled by Sn_CR command or Packet send/recv status)
    switch (getSn_SR(sn))
    {
        case SOCK_ESTABLISHED:
            if (getSn_IR(sn) & Sn_IR_CON)
            {  // Socket n interrupt register mask; TCP CON interrupt = connection with peer is successful
#ifdef _LOOPBACK_DEBUG_
                printf("%d:Connected to - %d.%d.%d.%d : %d\r\n", sn, destip[0], destip[1], destip[2], destip[3], destport);
#endif
                setSn_IR(sn, Sn_IR_CON);  // this interrupt should be write the bit cleared to '1'
            }

            //////////////////////////////////////////////////////////////////////////////////////////////
            // Data Transaction Parts; Handle the [data receive and send] process
            //////////////////////////////////////////////////////////////////////////////////////////////
            if ((size = getSn_RX_RSR(sn)) > 0)
            {  // Sn_RX_RSR: Socket n Received Size Register, Receiving data length
                if (size > DATA_BUF_SIZE)
                {
                    size = DATA_BUF_SIZE;  // DATA_BUF_SIZE means user defined buffer size (array)
                }
                ret = recv(sn, buf, size);  // Data Receive process (H/W Rx socket buffer -> User's buffer)
                if (ret <= 0)
                {
                    return ret;  // If the received data length <= 0, receive failed and process end
                }
                size = (uint16_t)ret;

                // Data sentsize control
                sentsize = 0;
                while (size != sentsize)
                {
                    ret = send(sn, buf + sentsize, size - sentsize);  // Data send process (User's buffer -> Destination through H/W Tx socket buffer)
                    if (ret < 0)
                    {               // Send Error occurred (sent data length < 0)
                        close(sn);  // socket close
                        return ret;
                    }
                    sentsize += ret;  // Don't care SOCKERR_BUSY, because it is zero.
                }
            }
            //////////////////////////////////////////////////////////////////////////////////////////////
            break;

        case SOCK_CLOSE_WAIT:
#ifdef _LOOPBACK_DEBUG_
            printf("%d:CloseWait\r\n", sn);
#endif
            if ((ret = disconnect(sn)) != SOCK_OK)
            {
                return ret;
            }
#ifdef _LOOPBACK_DEBUG_
            printf("%d:Socket Closed\r\n", sn);
#endif
            break;

        case SOCK_INIT:
#ifdef _LOOPBACK_DEBUG_
            printf("%d:Try to connect to the %d.%d.%d.%d : %d\r\n", sn, destip[0], destip[1], destip[2], destip[3], destport);
#endif
            if ((ret = connect(sn, destip, destport)) != SOCK_OK)
            {
                return ret;  //	Try to TCP connect to the TCP server (destination)
            }
            break;

        case SOCK_CLOSED:
            close(sn);
            if ((ret = socket(sn, Sn_MR_TCP, any_port++, 0x00)) != sn)
            {
                if (any_port == 0xffff)
                {
                    any_port = 50000;
                }
                return ret;  // TCP socket open with 'any_port' port number
            }
#ifdef _LOOPBACK_DEBUG_
            printf("%d:TCP client loopback start\r\n", sn);
            printf("%d:Socket opened\r\n", sn);
#endif
            break;

        default:
            break;
    }
    return 1;
}

void network_init(void)
{
    wiz_NetTimeout gWIZNETTIME = {.retry_cnt = 3, .time_100us = 2000};
    ctlnetwork(CN_SET_TIMEOUT, (void*)&gWIZNETTIME);
    ctlnetwork(CN_GET_TIMEOUT, (void*)&gWIZNETTIME);
    printf("TIMEOUT: %d, %d\r\n", gWIZNETTIME.retry_cnt, gWIZNETTIME.time_100us);

    ctlnetwork(CN_SET_NETINFO, (void*)&gWIZNETINFO);
    ctlnetwork(CN_GET_NETINFO, (void*)&gWIZNETINFO);
    // Display Network Information
    uint8_t tmpstr[6];
    ctlwizchip(CW_GET_ID, (void*)tmpstr);
    printf("\r\n=== %s NET CONF ===\r\n", (char*)tmpstr);
    printf("MAC: %02X:%02X:%02X:%02X:%02X:%02X\r\n",
           gWIZNETINFO.mac[0], gWIZNETINFO.mac[1], gWIZNETINFO.mac[2], gWIZNETINFO.mac[3], gWIZNETINFO.mac[4], gWIZNETINFO.mac[5]);
    printf("SIP: %d.%d.%d.%d\r\n", gWIZNETINFO.ip[0], gWIZNETINFO.ip[1], gWIZNETINFO.ip[2], gWIZNETINFO.ip[3]);
    printf("GAR: %d.%d.%d.%d\r\n", gWIZNETINFO.gw[0], gWIZNETINFO.gw[1], gWIZNETINFO.gw[2], gWIZNETINFO.gw[3]);
    printf("SUB: %d.%d.%d.%d\r\n", gWIZNETINFO.sn[0], gWIZNETINFO.sn[1], gWIZNETINFO.sn[2], gWIZNETINFO.sn[3]);
    printf("DNS: %d.%d.%d.%d\r\n", gWIZNETINFO.dns[0], gWIZNETINFO.dns[1], gWIZNETINFO.dns[2], gWIZNETINFO.dns[3]);
    printf("======================\r\n");
}

void my_ip_assign(void)
{
    getIPfromDHCP(gWIZNETINFO.ip);
    getGWfromDHCP(gWIZNETINFO.gw);
    getSNfromDHCP(gWIZNETINFO.sn);
    getDNSfromDHCP(gWIZNETINFO.dns);
    gWIZNETINFO.dhcp = NETINFO_DHCP;
    /* Network initialization */
    network_init();  // apply from dhcp
    printf("DHCP LEASED TIME : %d Sec.\r\n", getDHCPLeasetime());
}

void my_ip_conflict(void)
{
    printf("CONFLICT IP from DHCP\r\n");
    // halt or reset or any...
    while (1);  // this example is halt.
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
    MX_USART1_UART_Init();
    MX_SPI1_Init();
    /* USER CODE BEGIN 2 */
    uint8_t memsize[2][8] = {
        {2, 2, 2, 2, 2, 2, 2, 2},
        {2, 2, 2, 2, 2, 2, 2, 2}
    };

    printf("WIZCHIP start.\r\n");

    register_wizchip();

    Load_Net_Parameters();

    /* WIZCHIP SOCKET Buffer initialize */
    if (ctlwizchip(0, (void*)memsize) == -1)
    {
        printf("WIZCHIP Initialized fail.\r\n");
        while (1);
    }

    printf("WIZCHIP Initialized ok.\r\n");

    setSHAR(gWIZNETINFO.mac);
    DHCP_init(0, txbuf);
    reg_dhcp_cbfunc(my_ip_assign, my_ip_assign, my_ip_conflict);

    printf("DHCP run.\r\n");

    uint8_t dhcp_ret = DHCP_run();

    while (dhcp_ret != DHCP_IP_LEASED)
    {
        printf("Waiting DHCP: %d\r\n", dhcp_ret);
        HAL_GPIO_TogglePin(LED_GPIO_Port, LED_Pin);
        HAL_Delay(500);
        dhcp_ret = DHCP_run();
    }

    printf("DHCP pass.\r\n");

    /* USER CODE END 2 */

    /* Infinite loop */
    /* USER CODE BEGIN WHILE */
    uint8_t ret = 0;

    ctlnetwork(CN_GET_NETINFO, (void*)&gWIZNETINFO);
    printf("MAC: %02X:%02X:%02X:%02X:%02X:%02X\r\n", gWIZNETINFO.mac[0], gWIZNETINFO.mac[1], gWIZNETINFO.mac[2],
           gWIZNETINFO.mac[3], gWIZNETINFO.mac[4], gWIZNETINFO.mac[5]);
    printf("SIP: %d.%d.%d.%d\r\n", gWIZNETINFO.ip[0], gWIZNETINFO.ip[1], gWIZNETINFO.ip[2], gWIZNETINFO.ip[3]);
    printf("GAR: %d.%d.%d.%d\r\n", gWIZNETINFO.gw[0], gWIZNETINFO.gw[1], gWIZNETINFO.gw[2], gWIZNETINFO.gw[3]);
    printf("SUB: %d.%d.%d.%d\r\n", gWIZNETINFO.sn[0], gWIZNETINFO.sn[1], gWIZNETINFO.sn[2], gWIZNETINFO.sn[3]);
    printf("DNS: %d.%d.%d.%d\r\n", gWIZNETINFO.dns[0], gWIZNETINFO.dns[1], gWIZNETINFO.dns[2], gWIZNETINFO.dns[3]);

    while (1)
    {
        HAL_Delay(500);
        int rev = loopback_tcpc(1, rxbuf, destip, destport);
        switch (rev)
        {
            case SOCK_OK:
                ctlnetwork(CN_GET_NETINFO, (void*)&gWIZNETINFO);
                sprintf((char*)txbuf, "Message from %d.%d.%d.%d\r\n", gWIZNETINFO.ip[0], gWIZNETINFO.ip[1], gWIZNETINFO.ip[2], gWIZNETINFO.ip[3]);
                send(1, txbuf, 30);
						#if 0
								// process ex buffer
                send(1, rxbuf, strlen(rxbuf));
						#endif
                break;
            case SOCKERR_TIMEOUT:
                printf("REV: TIMEOUT\r\n");
                break;
            case SOCKERR_SOCKSTATUS:
                printf("REV: SOCKSTATUS\r\n");
                break;
            default:
                printf("REV: SOCK ERROR\r\n");
                break;
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

    /** Initializes the RCC Oscillators according to the specified parameters
     * in the RCC_OscInitTypeDef structure.
     */
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState       = RCC_HSE_ON;
    RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
    RCC_OscInitStruct.HSIState       = RCC_HSI_ON;
    RCC_OscInitStruct.PLL.PLLState   = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource  = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLMUL     = RCC_PLL_MUL9;
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /** Initializes the CPU, AHB and APB buses clocks
     */
    RCC_ClkInitStruct.ClockType      = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource   = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider  = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
    {
        Error_Handler();
    }
}

/**
 * @brief SPI1 Initialization Function
 * @param None
 * @retval None
 */
static void MX_SPI1_Init(void)
{
    /* USER CODE BEGIN SPI1_Init 0 */

    /* USER CODE END SPI1_Init 0 */

    /* USER CODE BEGIN SPI1_Init 1 */

    /* USER CODE END SPI1_Init 1 */
    /* SPI1 parameter configuration*/
    hspi1.Instance               = SPI1;
    hspi1.Init.Mode              = SPI_MODE_MASTER;
    hspi1.Init.Direction         = SPI_DIRECTION_2LINES;
    hspi1.Init.DataSize          = SPI_DATASIZE_8BIT;
    hspi1.Init.CLKPolarity       = SPI_POLARITY_HIGH;
    hspi1.Init.CLKPhase          = SPI_PHASE_2EDGE;
    hspi1.Init.NSS               = SPI_NSS_SOFT;
    hspi1.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_8;
    hspi1.Init.FirstBit          = SPI_FIRSTBIT_MSB;
    hspi1.Init.TIMode            = SPI_TIMODE_DISABLE;
    hspi1.Init.CRCCalculation    = SPI_CRCCALCULATION_DISABLE;
    hspi1.Init.CRCPolynomial     = 10;
    if (HAL_SPI_Init(&hspi1) != HAL_OK)
    {
        Error_Handler();
    }
    /* USER CODE BEGIN SPI1_Init 2 */

    /* USER CODE END SPI1_Init 2 */
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
    __HAL_RCC_GPIOD_CLK_ENABLE();
    __HAL_RCC_GPIOA_CLK_ENABLE();

    /*Configure GPIO pin Output Level */
    HAL_GPIO_WritePin(GPIOA, LED_Pin | SPI_CS_W5500_Pin, GPIO_PIN_RESET);

    /*Configure GPIO pins : LED_Pin SPI_CS_W5500_Pin */
    GPIO_InitStruct.Pin   = LED_Pin | SPI_CS_W5500_Pin;
    GPIO_InitStruct.Mode  = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull  = GPIO_PULLUP;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
    HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

    /* USER CODE BEGIN MX_GPIO_Init_2 */
    /* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */
int fputc(int ch, FILE* f)
{
    HAL_UART_Transmit(&huart1, (uint8_t*)&ch, 1, 0xFF);
    return ch;
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
