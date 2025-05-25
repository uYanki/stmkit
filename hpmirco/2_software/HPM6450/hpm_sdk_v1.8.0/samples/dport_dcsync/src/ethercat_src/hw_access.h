//
// Created by wenwe on 2024/2/28.
//
#define ESC_RD                    0x02 /**< \brief Indicates a read access to ESC or EEPROM*/
#define ESC_RWS                   0x03
#define ESC_WR                    0x04
#ifndef ETHERCAT_SSC_STM32H750_HW_ACCESS_H
#define ETHERCAT_SSC_STM32H750_HW_ACCESS_H

#include <string.h>
#include <stdint.h>
#include "stdbool.h"
#include "ecat_def.h"
#include "../hpm_spi.h"

extern unsigned char HW_Init(void);
extern void HW_Release(void);
extern unsigned short HW_GetALEventRegister(void);
extern unsigned short HW_GetALEventRegister_Isr(void);
extern void HW_EscRead( void * pData, unsigned short Address, unsigned short Len );
extern void HW_EscReadIsr( void *pData, unsigned short Address, unsigned short Len );
extern void HW_EscWrite( void *pData, unsigned short Address, unsigned short Len );
extern void HW_EscWriteIsr( void *pData, unsigned short Address, unsigned short Len );
extern unsigned int HW_GetTimer(void);
extern void DISABLE_ESC_INT(void);
extern void ENABLE_ESC_INT(void);
extern void HW_SetLed(unsigned char RunLed,unsigned char ErrorLed);
#define HW_EscReadWord(WordValue, Address) HW_EscRead(((void *)&(WordValue)),((unsigned short)(Address)),2) /**< \brief 16Bit ESC read access*/
#define HW_EscReadDWord(DWordValue, Address) HW_EscRead(((void *)&(DWordValue)),((unsigned short)(Address)),4) /**< \brief 32Bit ESC read access*/

#define HW_EscReadMbxMem(pData,Address,Len) HW_EscRead(((void *)(pData)),((unsigned short)(Address)),(Len)) /**< \brief The mailbox data is stored in the local uC memory therefore the default read function is used.*/
#define HW_EscReadWordIsr(WordValue, Address) HW_EscReadIsr(((void *)&(WordValue)),((unsigned short)(Address)),2) /**< \brief Interrupt specific 16Bit ESC read access*/
#define HW_EscReadDWordIsr(DWordValue, Address) HW_EscReadIsr(((void *)&(DWordValue)),((unsigned short)(Address)),4) /**< \brief Interrupt specific 32Bit ESC read access*/


#define HW_EscWriteWord(WordValue, Address) HW_EscWrite(((void *)&(WordValue)),((unsigned short)(Address)),2) /**< \brief 16Bit ESC write access*/
#define HW_EscWriteDWord(DWordValue, Address) HW_EscWrite(((void *)&(DWordValue)),((unsigned short)(Address)),4) /**< \brief 32Bit ESC write access*/

#define HW_EscWriteMbxMem(pData,Address,Len) HW_EscWrite(((void *)(pData)),((unsigned short)(Address)),(Len)) /**< \brief The mailbox data is stored in the local uC memory therefore the default write function is used.*/
#define HW_EscWriteWordIsr(WordValue, Address) HW_EscWriteIsr(((void *)&(WordValue)),((unsigned short)(Address)),2) /**< \brief Interrupt specific 16Bit ESC write access*/
#define HW_EscWriteDWordIsr(DWordValue, Address) HW_EscWriteIsr(((void *)&(DWordValue)),((unsigned short)(Address)),4)

#define HW_EscReadByte(ByteValue,Address) HW_EscRead(((void *)&(ByteValue)),((UINT16)(Address)),1)
#define HW_EscReadByteIsr(ByteValue,Address) HW_EscReadIsr(((void *)&(ByteValue)),((UINT16)(Address)),1)

#define HW_EscWriteByte(ByteValue,Address) HW_EscWrite(((void *)&(ByteValue)),((UINT16)(Address)),1)
#define HW_EscWriteByteIsr(ByteValue,Address) HW_EscWriteIsr(((void *)&(ByteValue)),((UINT16)(Address)),1)

#define ECAT_TIMER_INC_P_MS 100000U
#endif //ETHERCAT_SSC_STM32H750_HW_ACCESS_H
