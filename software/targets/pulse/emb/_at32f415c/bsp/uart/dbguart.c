#include "common.h"
#include <stdio.h>

//
// 调试串口
//

#if defined(DEBUG_UART_BASE)

#undef __GNUC__

// clang-format off

/* support printf function, usemicrolib is unnecessary */
#if (__ARMCC_VERSION > 6000000)
  __asm (".global __use_no_semihosting\n\t");
  void _sys_exit(int x)
  {
    x = x;
  }
  /* __use_no_semihosting was requested, but _ttywrch was */
  void _ttywrch(int ch)
  {
    ch = ch;
  }
  FILE __stdout;
#else
 #ifdef __CC_ARM
  #pragma import(__use_no_semihosting)
  struct __FILE
  {
    int handle;
  };
  FILE __stdout;
  void _sys_exit(int x)
  {
    x = x;
  }
  /* __use_no_semihosting was requested, but _ttywrch was */
  void _ttywrch(int ch)
  {
    ch = ch;
  }
 #endif
#endif

#if defined (__GNUC__) && !defined (__clang__)
  #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
  #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif

/**
  * @brief  retargets the c library printf function to the usart.
  * @param  none
  * @retval none
  */
PUTCHAR_PROTOTYPE
{
  while(usart_flag_get(DEBUG_UART_BASE, USART_TDBE_FLAG) == RESET);
  usart_data_transmit(DEBUG_UART_BASE, (uint16_t)ch);
  while(usart_flag_get(DEBUG_UART_BASE, USART_TDC_FLAG) == RESET);
  return ch;
}

#if (defined (__GNUC__) && !defined (__clang__)) || (defined (__ICCARM__))
#if defined (__GNUC__) && !defined (__clang__)
int _write(int fd, char *pbuffer, int size)
#elif defined ( __ICCARM__ )
#pragma module_name = "?__write"
int __write(int fd, char *pbuffer, int size)
#endif
{
	int i;

  for(i = 0; i < size; i ++)
  {
    while(usart_flag_get(DEBUG_UART_BASE, USART_TDBE_FLAG) == RESET);
    usart_data_transmit(DEBUG_UART_BASE, (uint16_t)(*pbuffer++));
    while(usart_flag_get(DEBUG_UART_BASE, USART_TDC_FLAG) == RESET);
  }

  return size;
}
#endif

/**
  * @brief  initialize uart
  * @param  baudrate: uart baudrate
  * @retval none
  */
void uart_print_init()
{
#if defined (__GNUC__) && !defined (__clang__)
  setvbuf(stdout, NULL, _IONBF, 0);
#endif
}

// clang-format on

#endif
