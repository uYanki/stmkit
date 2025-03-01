#include "OLED_UI_Driver.h"

/*
���ļ�˵������[Ӳ�������]
���ļ�������������������������������Ҫ��ֲ����Ŀ�������ʵ������޸���ش��롣
����ȷ��oled��Ļ�ܹ����������������ܹ���ȷ�����л�������ʱ������ʾ�ַ����ȣ����Ϳ��Կ�ʼ��ֲ
�йذ�����������ȵ����������ˡ�
*/

extern TIM_HandleTypeDef ENC_TIM;

/**
 * @brief ������ʹ�ܺ���
 * @param ��
 * @return ��
 */
void Encoder_Enable(void)
{
    HAL_TIM_Encoder_Start(&ENC_TIM, TIM_CHANNEL_ALL);
}

/**
 * @brief ������ʧ�ܺ���
 * @param ��
 * @return ��
 */
void Encoder_Disable(void)
{
    HAL_TIM_Encoder_Stop(&ENC_TIM, TIM_CHANNEL_ALL);
}

/**
 * @brief ��ȡ����������������ֵ���ı�Ƶ���룩
 *
 * @details �ú���ͨ����ȡ��ʱ��TIM1�ļ���ֵ���Ա������źŽ����ı�Ƶ���봦��
 *          ʹ�þ�̬�����ۻ���������ͨ��������ȡģ����ȥ��������������֣�
 *          ȷ�����ؾ�ȷ������ֵ����Ҫ���ڵ�����ơ�λ�ü���Ӧ�ó�����
 *
 * @note   �����ڲ����Զ����㶨ʱ������ֵ��ȷ���´ζ�ȡ��׼ȷ��
 *
 * @return int16_t ���ؽ����ı���������ֵ
 */
int16_t Encoder_Get(void)
{
    // ��̬�����������ں������ü䱣��δ��4����������
    static int32_t encoderAccumulator = 0;

    // ��ȡ��ǰ��ʱ������ֵ
    int16_t temp = __HAL_TIM_GET_COUNTER(&ENC_TIM);

    // ���㶨ʱ����������Ϊ�´ζ�ȡ��׼��
    __HAL_TIM_SET_COUNTER(&ENC_TIM, 0);

    // ����ǰ��ȡֵ�ۼӵ��ۼ�����
    encoderAccumulator += temp;

    // �����ı�Ƶ����������ֵ��ȥ��δ��ɵĲ��֣�
    int16_t result = encoderAccumulator / 4;

    // ����δ��4��������������֤����
    encoderAccumulator %= 4;

    // ���ؽ���������ֵ
    return result;
}

/**
 * @brief  ���뼶��ʱ
 * @param  xms ��ʱʱ������Χ��0~4294967295
 * @retval ��
 */
void Delay_ms(uint32_t xms)
{
    HAL_Delay(xms);
}

/**
 * @brief  �뼶��ʱ
 * @param  xs ��ʱʱ������Χ��0~4294967295
 * @retval ��
 */
void Delay_s(uint32_t xs)
{
    while (xs--)
    {
        Delay_ms(1000);
    }
}
