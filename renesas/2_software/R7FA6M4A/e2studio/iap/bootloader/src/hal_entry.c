/***********************************************************************************************************************
 * File Name    : hal_entry.c
 * Description  : Contains data structures and functions used in hal_entry.c.
 **********************************************************************************************************************/
/***********************************************************************************************************************
 * DISCLAIMER
 * This software is supplied by Renesas Electronics Corporation and is only intended for use with Renesas products. No
 * other uses are authorized. This software is owned by Renesas Electronics Corporation and is protected under all
 * applicable laws, including copyright laws.
 * THIS SOFTWARE IS PROVIDED "AS IS" AND RENESAS MAKES NO WARRANTIES REGARDING
 * THIS SOFTWARE, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. ALL SUCH WARRANTIES ARE EXPRESSLY DISCLAIMED. TO THE MAXIMUM
 * EXTENT PERMITTED NOT PROHIBITED BY LAW, NEITHER RENESAS ELECTRONICS CORPORATION NOR ANY OF ITS AFFILIATED COMPANIES
 * SHALL BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES FOR ANY REASON RELATED TO THIS
 * SOFTWARE, EVEN IF RENESAS OR ITS AFFILIATES HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
 * Renesas reserves the right, without notice, to make changes to this software and to discontinue the availability of
 * this software. By using this software, you agree to the additional terms and conditions found by accessing the
 * following link:
 * http://www.renesas.com/disclaimer
 *
 * Copyright (C) 2020 Renesas Electronics Corporation. All rights reserved.
 ***********************************************************************************************************************/

#include "common_utils.h"
#include "flash_hp_ep.h"

void R_BSP_WarmStart(bsp_warm_start_event_t event);

/*******************************************************************************************************************//**
 * The RA Configuration tool generates main() and uses it to generate threads if an RTOS is used.  This function is
 * called by main() when no RTOS is used.
 **********************************************************************************************************************/
void hal_entry(void)
{
    fsp_err_t err = FSP_SUCCESS;

    uint32_t read_data = RESET_VALUE;

    err = R_SCI_UART_Open(&g_uart7_ctrl, &g_uart7_cfg);
    assert(FSP_SUCCESS == err);

    /* Setup MCU port settings after C runtime environment and system clocks are setup*/
    R_BSP_WarmStart(BSP_WARM_START_POST_C);

    /* Open Flash_HP */
    err = R_FLASH_HP_Open(&g_flash_ctrl, &g_flash_cfg);
    /* Handle Error */
    if (FSP_SUCCESS != err)
    {
        APP_PRINT("\r\n Flah_HP_Open API failed");
        APP_ERR_TRAP(err);
    }

    /* Setup Default  Block 0 as Startup Setup Block */
    err = R_FLASH_HP_StartUpAreaSelect(&g_flash_ctrl, FLASH_STARTUP_AREA_BLOCK0, true);
    if (err != FSP_SUCCESS)
    {
        APP_PRINT("\r\n Flah_HP_StartUpAreaSelect API failed");
        APP_ERR_TRAP(err);
    }

   APP_PRINT("\n\r>>> Entering to code flash operations");
   err = flash_hp_code_flash_operations();
   if( FSP_SUCCESS != err)
   {
       flash_hp_deinit();
       APP_ERR_TRAP(err);
   }

    APP_PRINT("\n\r>>> Entering to data flash operations");
    err = flash_hp_data_flash_operations();
    if (FSP_SUCCESS != err)
    {
        flash_hp_deinit();
        APP_ERR_TRAP(err);
    }

    APP_PRINT("\n\r>>> Exiting the flash_hp, User has to restart the application");
    flash_hp_deinit();

    while (EXIT != read_data)
    {

    }

}

/*******************************************************************************************************************//**
 * This function is called at various points during the startup process.  This implementation uses the event that is
 * called right before main() to set up the pins.
 *
 * @param[in]  event    Where at in the start up process the code is currently at
 **********************************************************************************************************************/
void R_BSP_WarmStart(bsp_warm_start_event_t event)
{
    if (BSP_WARM_START_POST_C == event)
    {
        /* C runtime environment and system clocks are setup. */

        /* Configure pins. */
        R_IOPORT_Open(&g_ioport_ctrl, &g_bsp_pin_cfg);
    }
}


// 串口重定向
#ifdef __GNUC__
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE* f)
#endif

PUTCHAR_PROTOTYPE
{
    fsp_err_t err = R_SCI_UART_Write(&g_uart7_ctrl, (uint8_t*)&ch, 1);

    if (FSP_SUCCESS != err)
    {
        __BKPT();
    }

    while (! g_uart7_ctrl.p_reg->SSR_b.TEND) {}


    return ch;
}

int _write(int fd, char* pBuffer, int size)
{
    for (int i = 0; i < size; i++)
    {
        __io_putchar(*pBuffer++);
    }
    return size;
}
