#include "iap_if.h"
#include "main.h"

typedef void (*app_t)(void);

bool IsAppExist(uint32_t AppAddr)
{
    /* STM32F407 MSP 0x20020000, So I've changed 0x2FFE0000 => 0x2FFD0000 */
    return (*(__IO uint32_t*)AppAddr & 0x2FFD0000) == 0x20000000;
}

void JumpToApp(uint32_t AppAddr)
{
    uint8_t i = 0;
    app_t   AppJump;

    /* 关闭全局中断 */
    __disable_irq();

    /* 设置所有时钟到默认状态，使用HSI时钟 */
    HAL_RCC_DeInit();

    /* 关闭滴答定时器，复位到默认值 */
    SysTick->CTRL = 0;
    SysTick->LOAD = 0;
    SysTick->VAL  = 0;

    /* 关闭所有中断，清除所有中断挂起标志 */
    for (i = 0; i < 8; i++)
    {
        NVIC->ICER[i] = 0xFFFFFFFF;
        NVIC->ICPR[i] = 0xFFFFFFFF;
    }

    /* 使能全局中断 */
    __enable_irq();

    /* 跳转到应用程序，首地址是MSP，地址+4是复位中断服务程序地址 */
    AppJump = *(app_t*)(AppAddr + 4);

    /* Initialize user application's Main Stack Pointer */
    __set_MSP(*(uint32_t*)AppAddr);

    /* 在RTOS工程，设置为特权级模式，使用MSP指针 */
    __set_CONTROL(0);

    // Jump to user application
    AppJump();
}

/**
 * @brief 跳转至出厂自带的 Bootloader, 使用 STM32CubeProgrammer 编程（支持UART1和USB）
 */
void JumpToSysboot(void)
{
    // System Memory Bootloader
    JumpToApp(0x1FFF0000);
}
