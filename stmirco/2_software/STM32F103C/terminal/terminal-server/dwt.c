#include "dwt.h"

static uint32_t HCLK_Frequency = 0;

void DWT_Delay_Init(void)
{
		HCLK_Frequency = HAL_RCC_GetHCLKFreq();
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    DWT->CYCCNT = 0;
}

void DWT_Delay_us(uint32_t delay)
{
    uint32_t initial_ticks = DWT->CYCCNT;
    delay *= (HCLK_Frequency / 1000000);
    while (DWT->CYCCNT - initial_ticks < delay);
}

void DWT_Delay_ms(uint32_t delay)
{
    uint32_t initial_ticks = DWT->CYCCNT;
    delay *= (HCLK_Frequency / 1000);
    while (DWT->CYCCNT - initial_ticks < delay);
}

void array_copy_8(volatile uint8_t* dst, volatile uint8_t* src, volatile uint8_t size)
{
    while (size--)
    {
        *dst++ = *src++;
    }
}

void array_copy_32(volatile uint32_t* dst, volatile uint32_t* src, volatile uint8_t size)
{
    while (size--)
    {
        *dst++ = *src++;
    }
}
