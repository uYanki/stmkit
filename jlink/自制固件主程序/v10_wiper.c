#include <string.h>
#include <stdio.h>
#include "lpc43xx.h"

__no_init uint32_t btl_magic @ 0x20000000;
__no_init uint32_t btl_magic1 @ 0x20000004;
#pragma location=0x1A008130
__root const char fwversion[] = "J-Link V10 ";

__no_init char iapmem[16] @ 0x10089FF0;

#define IAP_LOCATION *(volatile unsigned int *)(0x10400100);
typedef void (*IAP)(unsigned int [],unsigned int[]);

#define CMD_SUCCESS 0

__no_init char pagecache[0x200];

void FeedWWDT();

void InitUSART3()
{
    LPC_CCU1->CLK_M4_GPIO_CFG |= 1;
    while (!(LPC_CCU1->CLK_M4_GPIO_STAT & 1));
    LPC_CCU2->CLK_APB2_USART3_CFG |= 1;
    while (!(LPC_CCU2->CLK_APB2_USART3_STAT & 1U))
    LPC_CCU1->CLK_M4_USART3_CFG |= 1; // autoen,wakeupen
    while (!(LPC_CCU1->CLK_M4_USART3_STAT & 1U));
    LPC_SCU->SFSP2_3 = 0x242; // P2_3 -> Fun2, EUPN, EZI, ZIF
    LPC_USART3->IER = 0; // Disable interrupts
    LPC_USART3->LCR = 0x83; // 8Bit, DLAB
    // 12M/16=750000 750000/6.51=115207
    // 750000/12*13/24=33854
    // 750000/3/(1+13/11)=114650??
    // 750000/6*12/13=115384
    LPC_USART3->DLL = 6;
    LPC_USART3->DLM = 0;
    LPC_USART3->FDR = 1 | (12 << 4); // ·Ö×ÓÔÚ×ó?!
    LPC_USART3->LCR = 0x3; // DLAB=0
}

void delay200ms()
{
    for (uint32_t i = 400; i; i--) {
        for (uint32_t j = 1500; j; j--) __NOP();
    }
}

void __iar_program_start()
{
    __disable_irq();
    //InitUSART3();
    LPC_CCU1->CLK_M4_GPIO_CFG |= 3;
    while (!(LPC_CCU1->CLK_M4_GPIO_STAT & 1U));
    LPC_SCU->SFSP2_4 = 0x54; // P2_4 -> Fun4, No Pullup
    LPC_GPIO_PORT->DIR[5] |= 1 << 4; // GPIO5[4] Output
    for (int loop = 12; loop; loop--) {
        LPC_GPIO_PORT->CLR[5] = 1 << 4; // ON
        delay200ms();
        LPC_GPIO_PORT->SET[5] = 1 << 4; // OFF
        delay200ms();
    }

    /*IAP iap_entry=(IAP)IAP_LOCATION;
    unsigned int cmd[5] = {0,};
    unsigned int status[5] = {0,};
    cmd[0] = 49; // init
    iap_entry(cmd, status);
    cmd[0] = 50;        // Prepare
    cmd[1] = 2;         // sector2, 8k
    cmd[2] = 2;         // same
    cmd[3] = 0;         // bankA
    iap_entry(cmd, status);
    if (status[0] == CMD_SUCCESS) {
        // 0x1A005E00-0x1A005FFF
        memcpy(pagecache, (void*)0x1A005E00, 0x200);
        memset(pagecache + 0x10, 0xFF, 0x90); // fill features
        cmd[0] = 59;      // Earse page
        cmd[1] = 0x1A005E00;
        cmd[2] = 0x1A005E00;
        cmd[3] = 12000;   // 180Mhz PLL, 12M IRC
        cmd[4] = 0;       // bankA
        iap_entry(cmd, status);
        if (status[0] == CMD_SUCCESS) {
            cmd[0] = 50;        // Prepare
            cmd[1] = 2;         // sector2, 8k
            cmd[2] = 2;         // same
            cmd[3] = 0;         // bankA
            iap_entry(cmd, status);
            if (status[0] == CMD_SUCCESS) {
                cmd[0] = 51;    // Copy RAM to Flash
                cmd[1] = 0x1A005E00;
                cmd[2] = (uint32_t)pagecache;
                cmd[3] = 0x200; // Page
                cmd[4] = 12000;
                iap_entry(cmd, status);
                if (status[0] == CMD_SUCCESS) {
                    printf("Copy RAM to Flash OK!\n");
                } else {
                    printf("Copy RAM to Flash faied: %d\n", status[0]);
                }
            } else {
                printf("Prepare copy failed: %d\n", status[0]);
            }
        } else {
            printf("Erase page failed: %d\n", status[0]);
        }
    } else {
        printf("Prepare erase failed: %d\n", status[0]);
    }
    */
    //__enable_irq();
    __set_BASEPRI(0x80);
    btl_magic = 0x12344321;
    //__disable_irq();
    SCB->VTOR = 0x1A000000;
    SCB->AIRCR = 0x05FA0000 | 4;
    LPC_RGU->RESET_CTRL0 = 7; // CORE_RST | PERIPH_RST | MASTER_RST
    while (1);
}

void FeedWWDT()
{
    if (LPC_WWDT->MOD & 1) {
        LPC_WWDT->FEED = 0xAA;
        LPC_WWDT->FEED = 0x55;
    }
}

