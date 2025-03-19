#include "main.h"

#define SYSTEMTICK_PERIOD_MS 10

__IO uint32_t LocalTime = 0; /* this variable is used to create a time reference incremented by 10ms */

uint32_t timingdelay;

int main(void)
{
    ETH_BSP_Config();     // 配置网络接口
    ADC_Configuration();  // ADC配置
    LED_Configuration();  // LED控制管脚配置

    LwIP_Init();  // LWIP初始化

    httpd_init();  // WEB服务器初始化

    while (1)
    {
        LwIP_Periodic_Handle(LocalTime); /* 轮询LWIP是否接收到数据或有数据要发送   */
    }
}

/**
 * @brief  Inserts a delay time.
 * @param  nCount: number of 10ms periods to wait for.
 * @retval None
 */
void Delay(uint32_t nCount)
{
    /* Capture the current local time */
    timingdelay = LocalTime + nCount;

    /* wait until the desired delay finish */
    while (timingdelay > LocalTime)
    {
    }
}

/**
 * @brief  Updates the system local time
 * @param  None
 * @retval None
 */
void Time_Update(void)
{
    LocalTime += SYSTEMTICK_PERIOD_MS;
}

#ifdef USE_FULL_ASSERT

/**
 * @brief  Reports the name of the source file and the source line number
 *   where the assert_param error has occurred.
 * @param  file: pointer to the source file name
 * @param  line: assert_param error line source number
 * @retval None
 */
void assert_failed(uint8_t* file, uint32_t line)
{
    /* User can add his own implementation to report the file name and line number,
       ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

    /* Infinite loop */
    while (1)
    {}
}
#endif

/******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE****/
