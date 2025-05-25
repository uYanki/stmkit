//
// Created by wenwe on 2024/2/28.
//

#include "hw_access.h"

#define ESC_AL_EVENTMASK_OFFSET   0x0204



typedef union
{
    unsigned short    Word;
    unsigned char    Byte[2];
} UBYTETOWORD;

typedef union
{
    uint8_t           Byte[2];
    uint16_t          Word;
}UALEVENT;

#include "hpm_gpio_drv.h"
#include "hpm_interrupt.h"
#define DPORT_SPI_BASE     HPM_SPI0
#define DPORT_SPI_CS_PIN   HPM_GPIO0, GPIO_DO_GPIOZ, 2

#define SELECT_SPI           gpio_write_pin(DPORT_SPI_CS_PIN, 0)
#define DESELECT_SPI         gpio_write_pin(DPORT_SPI_CS_PIN, 1)
#define SPI_WRITE_AND_READ(TX_BUFFER,RX_BUFFER,Size)   hpm_spi_transmit_receive_blocking(DPORT_SPI_BASE, TX_BUFFER, RX_BUFFER, Size, 0xFFFFFFFF);

#define DISABLE_AL_EVENT_INT          DISABLE_ESC_INT
#define ENABLE_AL_EVENT_INT           ENABLE_ESC_INT
#define ENABLE_GLOBAL_INT            enable_global_irq(CSR_MSTATUS_MIE_MASK)
#define DISABLE_GLOBAL_INT           disable_global_irq(CSR_MSTATUS_MIE_MASK)


UALEVENT         EscALEvent;            //contains the content of the ALEvent register (0x220), this variable is updated on each Access to the Esc

static void GetInterruptRegister(void)
{
  HW_EscRead((void*)&EscALEvent.Word,0x220,2);
}
/*ET9300 Project Handler :(#if !INTERRUPTS_SUPPORTED) lines 404 to 406 deleted*/
static void ISR_GetInterruptRegister(void)
{
  HW_EscReadIsr((void*)&EscALEvent.Word,0x220,2);
}


/////////////////////////////////////////////////////////////////////////////////////////
/**
 \param Address     EtherCAT ASIC address ( upper limit is 0x1FFF )    for access.
 \param Command    ESC_WR performs a write access; ESC_RD performs a read access.

 \brief The function addresses the EtherCAT ASIC via SPI for a following SPI access.
*////////////////////////////////////////////////////////////////////////////////////////
static uint32_t ESC_ADDR( uint16_t Address, uint8_t Command ,uint8_t *buffer)
{
  uint32_t head_len=0;
  buffer[0]=Address>>5;
  head_len+=1;
  if((Address+8) & ~0x1fff){
    buffer[1]=(Address << 3)+0x06;
    head_len+=1;
    buffer[2]=( (Address >> 8) & 0x0e)+(Command << 2);
    head_len+=1;
  } else{
    buffer[1]=(Address << 3) | Command;
    head_len+=1;
  }
  if(Command == ESC_RWS){
    buffer[head_len] = 0xff;
    head_len+=1;
  }
  return head_len;
}

uint8_t HW_Init(void)
{
  uint32_t intMask;
  do
  {
    intMask = 0x93;
    HW_EscWriteDWordIsr(intMask, ESC_AL_EVENTMASK_OFFSET);
    intMask = 0;
    HW_EscReadDWordIsr(intMask, ESC_AL_EVENTMASK_OFFSET);
  } while (intMask != 0x93);

  intMask = 0x00;

  return 0;
}


/////////////////////////////////////////////////////////////////////////////////////////
/**
 \brief    This function shall be implemented if hardware resources need to be release
        when the sample application stops
*////////////////////////////////////////////////////////////////////////////////////////
void HW_Release(void)
{

}

/////////////////////////////////////////////////////////////////////////////////////////
/**
 \return    first two Bytes of ALEvent register (0x220)

 \brief  This function gets the current content of ALEvent register
*////////////////////////////////////////////////////////////////////////////////////////
uint16_t HW_GetALEventRegister(void)
{
  GetInterruptRegister();
  return EscALEvent.Word;
}

/////////////////////////////////////////////////////////////////////////////////////////
/**
 \return    first two Bytes of ALEvent register (0x220)

 \brief  The SPI PDI requires an extra ESC read access functions from interrupts service routines.
        The behaviour is equal to "HW_GetALEventRegister()"
*////////////////////////////////////////////////////////////////////////////////////////
/*ET9300 Project Handler :(#if _PIC18 && AL_EVENT_ENABLED) lines 682 to 686 deleted*/
uint16_t HW_GetALEventRegister_Isr(void)
{
  ISR_GetInterruptRegister();
  return EscALEvent.Word;
}
void HW_EscRead( void *pData, uint16_t Address, uint16_t Len )
{
  uint8_t  head_len;
  uint16_t i = Len;
  uint8_t* temp_pData = (uint8_t *)pData;
  uint8_t TX_BUFFER[5];/*Head_len:max is 4,and a topbyte */
  uint8_t RX_BUFFER[5];

  while (i-->0){
    head_len = ESC_ADDR(Address,ESC_RWS,TX_BUFFER);
    TX_BUFFER[head_len] = 0xff;
    DISABLE_GLOBAL_INT;
    SELECT_SPI;
    SPI_WRITE_AND_READ(TX_BUFFER,RX_BUFFER,head_len+1);
    DESELECT_SPI;
    ENABLE_GLOBAL_INT;
    *temp_pData = RX_BUFFER[head_len];
    Address++;
    temp_pData++;
  }
}

/////////////////////////////////////////////////////////////////////////////////////////
/**
 \param pData        Pointer to a byte array which holds data to write or saves read data.
 \param Address     EtherCAT ASIC address ( upper limit is 0x1FFF )    for access.
 \param Len            Access size in Bytes.

\brief  The SPI PDI requires an extra ESC read access functions from interrupts service routines.
        The behaviour is equal to "HW_EscRead()"
*////////////////////////////////////////////////////////////////////////////////////////
/*ET9300 Project Handler :(#if _PIC18 && AL_EVENT_ENABLED) lines 775 to 779 deleted*/
void HW_EscReadIsr( void *pData, uint16_t Address, uint16_t Len )
{
  uint8_t head_len;
  uint8_t TX_BUFFER[Len + 4];
  uint8_t RX_BUFFER[Len + 4];
  memset(TX_BUFFER, 0, Len + 4);
  head_len = ESC_ADDR(Address, ESC_RWS, TX_BUFFER);
  SELECT_SPI;
  SPI_WRITE_AND_READ(TX_BUFFER,RX_BUFFER, head_len + Len);
  DESELECT_SPI;
  memcpy(pData,&RX_BUFFER[head_len],Len);
}
/////////////////////////////////////////////////////////////////////////////////////////
/**
 \param pData        Pointer to a byte array which holds data to write or saves write data.
 \param Address     EtherCAT ASIC address ( upper limit is 0x1FFF )    for access.
 \param Len            Access size in Bytes.

  \brief  This function operates the SPI write access to the EtherCAT ASIC.
*////////////////////////////////////////////////////////////////////////////////////////
void HW_EscWrite( void *pData, uint16_t Address, uint16_t Len )
{
  uint8_t head_len;
  uint16_t i = Len;
  uint8_t* pTmpData = (uint8_t *)pData;
  uint8_t TX_BUFFER[4];
  uint8_t RX_BUFFER[4];
  while(i-- > 0){
    head_len = ESC_ADDR(Address,ESC_WR,TX_BUFFER);
    TX_BUFFER[head_len] = *pTmpData;
    DISABLE_GLOBAL_INT;
    SELECT_SPI;
    SPI_WRITE_AND_READ(TX_BUFFER,RX_BUFFER,head_len + 1);
    DESELECT_SPI;
    ENABLE_GLOBAL_INT;
    Address++;
    pTmpData++;
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
/**
 \param pData        Pointer to a byte array which holds data to write or saves write data.
 \param Address     EtherCAT ASIC address ( upper limit is 0x1FFF )    for access.
 \param Len            Access size in Bytes.

 \brief  The SPI PDI requires an extra ESC write access functions from interrupts service routines.
        The behaviour is equal to "HW_EscWrite()"
*////////////////////////////////////////////////////////////////////////////////////////
/*ET9300 Project Handler :(#if _PIC18 && AL_EVENT_ENABLED) lines 873 to 877 deleted*/
void HW_EscWriteIsr( void *pData, uint16_t Address, uint16_t Len )
{
  uint8_t head_len;
  uint8_t TX_BUFFER[Len + 3];
  uint8_t RX_BUFFER[Len + 3];
  head_len = ESC_ADDR(Address,ESC_WR,TX_BUFFER);
  memcpy(&TX_BUFFER[head_len],pData,Len);

  //DISABLE_GLOBAL_INT;
  SELECT_SPI;
  SPI_WRITE_AND_READ(TX_BUFFER,RX_BUFFER, head_len + Len);
  DESELECT_SPI;
    //ENABLE_GLOBAL_INT;

}
void HW_SetLed(uint8_t RunLed,uint8_t ErrorLed){
	//HAL_GPIO_WritePin(RUN_GPIO_Port,RUN_Pin,!RunLed);
	//HAL_GPIO_WritePin(ERR_GPIO_Port,ERR_Pin,!ErrorLed);
}
