#include "time.h"

time_t time(time_t* time) { return 0; }

int system(const char* string) { return 0; }

void exit(int status) {}

//--------------------

#include "stdio.h"
#include "stm32f4xx_hal.h"

extern UART_HandleTypeDef huart1;

int fputc(int ch, FILE* f)
{
    // HAL_UART_Transmit(&huart1, (uint8_t*)&ch, 1, HAL_MAX_DELAY);
    HAL_UART_Transmit(&huart1, (uint8_t*)&ch, 1, HAL_MAX_DELAY);
    return ch;
}
