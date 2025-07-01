#include "cmdline.h"
#include "led.h"

/**
 * @brief  LED init
 * @param  нч
 * @retval нч
 */
void LED_Init(void)
{
    // LED_GPIO_Config();
}

/**
 * @brief  LED command init
 * @param  null
 * @retval return True means ok
 */
uint8_t CLI_LED_Init(void)
{
    LED_Init();

    return true;
}

/**
 * @brief  LED command line
 * @param  null
 * @retval null
 */
uint8_t CLI_LED(void* para, uint8_t len)
{
    uint8_t* pTemp;
    pTemp = (uint8_t*)para;
    if ((0 < len) && (NULL != pTemp))
    {
        pTemp++; /* skip a blank space */
        if ('1' == *pTemp)
        {
            /* LED ON */
            HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
            NL1();
            DBG("led on\r\n");
        }
        else if ('0' == *pTemp)
        {
            /* LED OFF */
            HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
            NL1();
            DBG("led off\r\n");
        }
        else
        {
            /* para. wrong */
            return false;
        }
    }

    /* led command ok */
    return true;
}

/*********************************************END OF FILE**********************/
