#include "stm32f4xx.h"

#include "system/autoinit.h"
#include "system/swrst.h"

#include "bsp/key.h"
#include "bsp/led.h"
#include "bsp/uart.h"

#include "usdk.defs.h"

int main()
{
    u32 blink = 0;

    printf("\n");

    DelayInit();
    sleep_s(2);

    while (1)
    {
        if (DelayNonBlockS(blink, 1))
        {
            led_tgl(LED1);
            blink = HAL_GetTick();
        }

        if (key_is_press(KEY2))
        {
            NVIC_CoreReset_C();
        }
        if (key_is_press(KEY3))
        {
            NVIC_SystemReset_C();
        }
    }
}

#if 0

void init_fpu()
{
    // This enables the floating point unit
    SCB->CPACR |= 0xF << 20;
}

#endif

//

void usdk_preinit(void)
{
    // sleep
    sleep_init();
    // hw_uart
    USART_InitTypeDef USART_InitStructure;
    USART_InitStructure.USART_BaudRate            = 115200;
    USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    USART_InitStructure.USART_Mode                = USART_Mode_Tx | USART_Mode_Rx;
    USART_InitStructure.USART_Parity              = USART_Parity_No;
    USART_InitStructure.USART_StopBits            = USART_StopBits_1;
    USART_InitStructure.USART_WordLength          = USART_WordLength_8b;
    UART_Config(&USART_InitStructure);
}

//

int display_reset_reason(void)
{
    // �ϵ��ӡ�Ĵ���ֵ
    printf("<*> CSR = 0x%X\n", RCC->CSR);

    if (RCC->CSR & BV(31))
    {  // 1.�͹��Ĺ���λ
        printf("<*> 1.Low-power reset\n");
    }
    if (RCC->CSR & BV(30))
    {  // 2.���ڿ��Ź���λ
        printf("<*> 2.Window watchdog reset\n");
    }
    if (RCC->CSR & BV(29))
    {  // 3.�������Ź���λ
        printf("<*> 3.(Independent watchdog reset\n");
    }
    if (RCC->CSR & BV(28))
    {  // 4.�����λ
        printf("<*> 4.Software reset\n");
    }
    if (RCC->CSR & BV(27))
    {  // 5.�ϵ�/���縴λ
        printf("<*> 5.POR/PDR reset\n");
    }
    if (RCC->CSR & BV(26))
    {  // 6.PIN���Ÿ�λ
        printf("<*> 6.PIN reset\n");
    }

    // �����λ��־
    RCC->CSR = 0x01000000;

    return INIT_RESULT_SUCCESS;
}

USDK_INIT_EXPORT(display_reset_reason, INIT_LEVEL_DEVICE)

//

static int display_system_clock(void)
{
    RCC_ClocksTypeDef RCC_Clocks;

    RCC_GetClocksFreq(&RCC_Clocks);

    printf("<*> SYSCLK:%luHz\n", RCC_Clocks.SYSCLK_Frequency);
    printf("<*> HCLK:%luHz\n", RCC_Clocks.HCLK_Frequency);    // AHB
    printf("<*> PCLK1:%luHz\n", RCC_Clocks.PCLK1_Frequency);  // APB1
    printf("<*> PCLK2:%luHz\n", RCC_Clocks.PCLK2_Frequency);  // APB2

    return INIT_RESULT_SUCCESS;
}

USDK_INIT_EXPORT(display_system_clock, INIT_LEVEL_DEVICE)
