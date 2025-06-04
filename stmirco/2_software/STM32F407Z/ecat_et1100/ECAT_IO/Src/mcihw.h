/*
* This source file is part of the EtherCAT Slave Stack Code licensed by Beckhoff Automation GmbH & Co KG, 33415 Verl, Germany.
* The corresponding license agreement applies. This hint shall not be removed.
* https://www.beckhoff.com/media/downloads/slave-stack-code/ethercat_ssc_license.pdf
*/

/**
 * \addtogroup MCI_HW Parallel ESC Access
 * @{
 */

/**
\file mcihw.h
\author EthercatSSC@beckhoff.com
\brief Defines and Macros to access the ESC via a parallel interface

\version 5.10

<br>Changes to version V5.01:<br>
V5.10 HW4: Add volatile directive for direct ESC DWORD/WORD/BYTE access<br>
           Add missing swapping in mcihw.c<br>
           Add "volatile" directive vor dummy vairables in enable and disable SyncManger functions<br>
           Add missing swapping in EL9800hw files<br>
<br>Changes to version - :<br>
V5.01 : Start file change log
 */


#ifndef _MCIHW_H_
#define _MCIHW_H_


/*-----------------------------------------------------------------------------------------
------
------    Includes
------
-----------------------------------------------------------------------------------------*/
#include <string.h>
#include "esc.h"
#include "stm32f4xx_hal.h"

/*-----------------------------------------------------------------------------------------
------
------    Defines and Types
------
-----------------------------------------------------------------------------------------*/

#define ESC_MEM_ADDR    UINT16 /**< \brief ESC address type (16Bit)*/
#define ESC_MEM_SHIFT   1 /**< \brief shift to convert Byte address to ESC address type*/

#ifndef HW_GetTimer
/**
 * \todo Define a macro or implement a function to get the hardware timer value.<br>See SSC Application Note for further details, http://www.beckhoff.com/english.asp?download/ethercat_development_products.htm?id=71003127100387
 */
#define HW_GetTimer()   HAL_GetTick()
#endif

#ifndef HW_ClearTimer
/**
 * \todo Define a macro or implement a function to clear the hardware timer value.<br>See SSC Application Note for further details, http://www.beckhoff.com/english.asp?download/ethercat_development_products.htm?id=71003127100387
 */
#define HW_ClearTimer()
#endif

#define ENABLE_ESC_INT()   HAL_NVIC_EnableIRQ(EXTI3_IRQn) 
#define DISABLE_ESC_INT()  HAL_NVIC_DisableIRQ(EXTI3_IRQn)

#define INIT_ESC_INT

/**
 * \todo Define the hardware timer ticks per millisecond.
 */
#define ECAT_TIMER_INC_P_MS 1


//#warning "define access to timer register(counter)"
#define     HW_GetALEventRegister()             ((((volatile UINT16 ESCMEM *)pEsc)[((ESC_AL_EVENT_OFFSET)>>1)])) /**< \brief Returns the first 16Bit of the AL Event register (0x220)*/
#define     HW_GetALEventRegister_Isr           HW_GetALEventRegister /**< \brief Returns the first 16Bit of the AL Event register (0x220).<br>Called from ISRs.*/

#define     HW_EscRead(pData,Address,Len)       ESCMEMCPY((MEM_ADDR *)(pData), &((ESC_MEM_ADDR ESCMEM *) pEsc)[((Address) >> ESC_MEM_SHIFT)], (Len)) /**< \brief Generic ESC (register and DPRAM) read access.*/
#define     HW_EscReadIsr                       HW_EscRead /**< \brief Generic ESC (register and DPRAM) read access.<br>Called for ISRs.*/
#define     HW_EscReadDWord(DWordValue, Address)    ((DWordValue) = (UINT32)(((volatile UINT32 *)pEsc)[(Address>>2)])) /**< \brief 32Bit specific ESC (register and DPRAM) read access.*/
#define     HW_EscReadDWordIsr(DWordValue, Address) ((DWordValue) = (UINT32)(((volatile UINT32 *)pEsc)[(Address>>2)])) /**< \brief 32Bit specific ESC (register and DPRAM) read access.<br>Called from ISRs.*/
#define     HW_EscReadWord(WordValue, Address)  ((WordValue) = (((volatile UINT16 *)pEsc)[((Address)>>1)])) /**< \brief 16Bit specific ESC (register and DPRAM) read access.*/
#define     HW_EscReadWordIsr(WordValue, Address) HW_EscReadWord(WordValue, Address) /**< \brief 16Bit specific ESC (register and DPRAM) read access.<br>Called from ISRs.*/
#define     HW_EscReadMbxMem(pData,Address,Len) ESCMBXMEMCPY((MEM_ADDR *)(pData), &((ESC_MEM_ADDR ESCMEM *) pEsc)[((Address) >> ESC_MEM_SHIFT)], (Len)) /**< \brief Macro to copy data from the application mailbox memory(not the ESC memory, this access is handled by HW_EscRead).*/


#define     HW_EscWrite(pData,Address,Len)      ESCMEMCPY(&((ESC_MEM_ADDR ESCMEM *) pEsc)[((Address)>>ESC_MEM_SHIFT)], (MEM_ADDR *)(pData), (Len)) /**< \brief Generic ESC (register and DPRAM) write access.*/
#define     HW_EscWriteIsr                      HW_EscWrite /**< \brief Generic ESC (register and DPRAM) write access.<br>Called for ISRs.*/
#define     HW_EscWriteDWord(DWordValue, Address)   ((((volatile UINT32 *)pEsc)[(Address>>2)]) = (DWordValue)) /**< \brief 32Bit specific ESC (register and DPRAM) write access.*/
#define     HW_EscWriteDWordIsr(DWordValue, Address)((((volatile UINT32 *)pEsc)[(Address>>2)]) = (DWordValue)) /**< \brief 32Bit specific ESC (register and DPRAM) write access.<br>Called from ISRs.*/
#define     HW_EscWriteWord(WordValue, Address) ((((volatile UINT16 *)pEsc)[((Address)>>1)]) = (WordValue)) /**< \brief 16Bit specific ESC (register and DPRAM) write access.*/
#define     HW_EscWriteWordIsr(WordValue, Address) HW_EscWriteWord(WordValue, Address) /**< \brief 16Bit specific ESC (register and DPRAM) write access.<br>Called from ISRs.*/
#define     HW_EscWriteMbxMem(pData,Address,Len)    ESCMBXMEMCPY(&((ESC_MEM_ADDR ESCMEM *) pEsc)[((Address)>>ESC_MEM_SHIFT)],(MEM_ADDR *)(pData), (Len)) /**< \brief Macro to copy data from the application mailbox memory (not the ESC memory, this access is handled by HW_EscWrite).*/


#ifndef TIMER_INT_HEADER
#define    TIMER_INT_HEADER /**< \brief Compiler directive before the hardware timer ISR function*/
#endif

#define     ESC_RD                    0x02 /**< \brief Indicates a read access to ESC or EEPROM*/
#define     ESC_WR                    0x04 /**< \brief Indicates a write access to ESC or EEPROM.*/

#endif//_MCIHW_H_


/*-----------------------------------------------------------------------------------------
------
------    Global variables
------
-----------------------------------------------------------------------------------------*/

#if _MCIHW_
    #define PROTO
#else
    #define PROTO extern
#endif

PROTO ESC_MEM_ADDR ESCMEM *            pEsc;            /**< \brief Pointer to the ESC.<br>Shall be initialized in HW_Init().*/


/*-----------------------------------------------------------------------------------------
------
------    Global functions
------
-----------------------------------------------------------------------------------------*/
PROTO void HW_SetLed(BOOL RunLed,BOOL ErrLed);

PROTO UINT16 HW_Init(void);
PROTO void HW_Release(void);



#undef PROTO
/** @}*/
