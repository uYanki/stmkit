#ifndef __OLED_UI_DRIVER_H
#define __OLED_UI_DRIVER_H

#include "main.h"

// ��ȡȷ�ϣ�ȡ�����ϣ��°���״̬�ĺ���(��Q��Ϊʲôʹ�ú궨������Ǻ�����A����Ϊ�����������Ч�ʣ����ٴ�������)
#define Key_GetEnterStatus() HAL_GPIO_ReadPin(KEY1_GPIO_Port, KEY1_Pin)
#define Key_GetBackStatus()  HAL_GPIO_ReadPin(KEY2_GPIO_Port, KEY2_Pin)
#define Key_GetUpStatus()    HAL_GPIO_ReadPin(KEY3_GPIO_Port, KEY4_Pin)
#define Key_GetDownStatus()  HAL_GPIO_ReadPin(KEY4_GPIO_Port, KEY3_Pin)

// ��ʱ���жϳ�ʼ������
void Timer_Init(void);

// ������ʹ�ܺ���
void Encoder_Enable(void);

// ������ʧ�ܺ���
void Encoder_Disable(void);

// ��ȡ������������ֵ
int16_t Encoder_Get(void);

// ��ʱ����
void Delay_ms(uint32_t xms);
void Delay_s(uint32_t xs);

#endif
