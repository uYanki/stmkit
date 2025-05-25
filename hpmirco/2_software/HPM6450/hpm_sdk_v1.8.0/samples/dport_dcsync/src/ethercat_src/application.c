
#include "DPort.h"
#include "hw_access.h"

extern TOBJ7000 PDOChannel0x7000;
void outputMapping(uint8_t* pData)
{
	/* PDOChannel0x7000 include a variable in type UINT16,
	 * boolean variables are not allow to take address,
	 * so we move two bytes to the address of PDOChannel0x7000.LED1,
	 * attention:
	 * Guaranteed byte alignment,if PDO use a boolean type
	*/
	memcpy( ((uint8_t*)(&PDOChannel0x7000) + 2),pData,1 );
}
extern TOBJ6000 PDIChannel0x7000;
void inputMapping(uint8_t* pData)
{
	memcpy( pData,&(PDIChannel0x6000.IN1),6 );
}

void applicationLoop(){


led_set(PDOChannel0x7000.LED1);
	//HAL_GPIO_WritePin(LED1_GPIO_Port, LED1_Pin, !PDOChannel0x7000.LED1);
	//HAL_GPIO_WritePin(LED2_GPIO_Port, LED2_Pin, !PDOChannel0x7000.LED2);
	//HAL_GPIO_WritePin(LED3_GPIO_Port, LED3_Pin, !PDOChannel0x7000.LED3);
	//HAL_GPIO_WritePin(LED4_GPIO_Port, LED4_Pin, !PDOChannel0x7000.LED4);
	//HAL_GPIO_WritePin(LED5_GPIO_Port, LED5_Pin, !PDOChannel0x7000.LED5);
	//HAL_GPIO_WritePin(LED6_GPIO_Port, LED6_Pin, !PDOChannel0x7000.LED6);
	//HAL_GPIO_WritePin(LED7_GPIO_Port, LED7_Pin, !PDOChannel0x7000.LED7);
	//HAL_GPIO_WritePin(LED8_GPIO_Port, LED8_Pin, !PDOChannel0x7000.LED8);

	PDIChannel0x6000.IN1 ++;//HAL_GPIO_ReadPin(IN1_GPIO_Port,IN1_Pin);
        PDIChannel0x6000.IN2 ++;
        PDIChannel0x6000.IN3 ++;
	//PDIChannel0x6000.IN2 = HAL_GPIO_ReadPin(IN2_GPIO_Port,IN2_Pin);
	//PDIChannel0x6000.IN3 = HAL_GPIO_ReadPin(IN3_GPIO_Port,IN3_Pin);
	//PDIChannel0x6000.IN4 = HAL_GPIO_ReadPin(IN4_GPIO_Port,IN4_Pin);
	//PDIChannel0x6000.IN5 = HAL_GPIO_ReadPin(IN5_GPIO_Port,IN5_Pin);
	//PDIChannel0x6000.IN6 = HAL_GPIO_ReadPin(IN6_GPIO_Port,IN6_Pin);
}
///////////////////////////////////////////////////////////////////////////////////////////
///**
//\param      pData  pointer to input process data
//
//\brief      This function will copies the inputs from the local memory to the ESC memory
//            to the hardware
//*////////////////////////////////////////////////////////////////////////////////////////
//void APPL_InputMapping(UINT16* pData)
//{
//	extern void inputMapping(uint8_t*pData);
//	inputMapping((UINT8*)pData);
//}
//
///////////////////////////////////////////////////////////////////////////////////////////
///**
//\param      pData  pointer to output process data
//
//\brief    This function will copies the outputs from the ESC memory to the local memory
//            to the hardware
//*////////////////////////////////////////////////////////////////////////////////////////
//void APPL_OutputMapping(UINT16* pData)
//{
//	extern void outputMapping(uint8_t*pData);
//	outputMapping((UINT8*)pData);
//}
//
///////////////////////////////////////////////////////////////////////////////////////////
///**
//\brief    This function will called from the synchronisation ISR
//            or from the mainloop if no synchronisation is supported
//*////////////////////////////////////////////////////////////////////////////////////////
//void APPL_Application(void)
//{
//	extern void applicationLoop();
//	applicationLoop();
//}
