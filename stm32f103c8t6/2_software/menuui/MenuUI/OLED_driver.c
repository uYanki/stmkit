/*

 * ���ͷ�ļ���oled��� [Ӳ����] ʵ���ļ�����ֲ��ʱ����Ҫ��������ļ�������

*/

#include "OLED_driver.h"
#define OLED_DEV_ADDR (0x3C << 1)

uint8_t OLED_DisplayBuf[64 / 8][128];
bool    OLED_ColorMode = true;

extern I2C_HandleTypeDef hi2c1;

void OLED_Write_DATA(uint8_t data)
{
#if OLED_IF_MODE == OLED_IF_HWI2C

    HAL_I2C_Mem_Write(&hi2c1, OLED_DEV_ADDR, 0x40, I2C_MEMADD_SIZE_8BIT, &data, 1, 0xFF);

#elif OLED_IF_MODE == OLED_IF_SWSPI
    OLED_DC_Set();  // ��������������Ϊ����ģʽ
    OLED_CS_Clr();  // ѡ��OLED

    for (uint8_t i = 0; i < 8; i++)
    {
        OLED_SCL_Clr();   // ʱ�����õͣ�׼����������λ
        if (data & 0x80)  // ������λ
        {
            OLED_SDA_Set();  // �����1�����������߸�
        }
        else
        {
            OLED_SDA_Clr();  // �����0�����������ߵ�
        }

        OLED_SCL_Set();  // ʱ�����øߣ�������״̬����ȡ
        data <<= 1;      // ��������׼����һλ
    }

    OLED_CS_Set();  // ȡ��ѡ��OLED
#endif
}

/**
 * ��    ����OLEDд����
 * ��    ����Data Ҫд�����ݵ���ʼ��ַ
 * ��    ����Count Ҫд�����ݵ�����
 * �� �� ֵ����
 */
void OLED_WriteDataArr(uint8_t* Data, uint8_t Count)
{
#if OLED_IF_MODE == OLED_IF_HWI2C

    HAL_I2C_Mem_Write(&hi2c1, OLED_DEV_ADDR, 0x40, I2C_MEMADD_SIZE_8BIT, Data, Count, 0xFF);

#elif OLED_IF_MODE == OLED_IF_SWSPI

    OLED_DC_Set();  // ��������������Ϊ����ģʽ
    OLED_CS_Clr();  // ѡ��OLED

    /*ѭ��Count�Σ���������������д��*/
    for (uint8_t i = 0; i < Count; i++)
    {
        if (OLED_ColorMode)
        {
            OLED_Write_DATA(Data[i]);  // ���η���Data��ÿһ������
        }
        else
        {
            OLED_Write_DATA(~Data[i]);  // ����Ƿ�ɫģʽ����ÿ������ȡ���ٷ���
        }
    }
    OLED_CS_Set();  // ȡ��ѡ��OLED

#endif
}

void OLED_Write_CMD(uint8_t data)
{
#if OLED_IF_MODE == OLED_IF_HWI2C
    HAL_I2C_Mem_Write(&hi2c1, OLED_DEV_ADDR, 0x00, I2C_MEMADD_SIZE_8BIT, &data, 1, 0xFF);
#elif OLED_IF_MODE == OLED_IF_SWSPI
    OLED_DC_Clr();
    OLED_CS_Clr();
    for (uint8_t i = 0; i < 8; i++)
    {
        OLED_SCL_Clr();
        if (data & 0x80)
        {
            OLED_SDA_Set();
        }
        else
        {
            OLED_SDA_Clr();
        }
        OLED_SCL_Set();
        data <<= 1;
    }
    OLED_CS_Set();
#endif
}

// ���Ժ���
void OLED_ColorTurn(uint8_t i)
{
    if (i == 0)
    {
        OLED_Write_CMD(0xA6);  // ������ʾ
    }
    if (i == 1)
    {
        OLED_Write_CMD(0xA7);  // ��ɫ��ʾ
    }
}

// ����OLED��ʾ
void OLED_DisPlay_On(void)
{
    OLED_Write_CMD(0x8D);  // ��ɱ�ʹ��
    OLED_Write_CMD(0x14);  // ������ɱ�
    OLED_Write_CMD(0xAF);  // ������Ļ
}

// �ر�OLED��ʾ
void OLED_DisPlay_Off(void)
{
    OLED_Write_CMD(0x8D);  // ��ɱ�ʹ��
    OLED_Write_CMD(0x10);  // �رյ�ɱ�
    OLED_Write_CMD(0xAE);  // �ر���Ļ
}
/**
 * ��    ����OLED������ʾ���λ��
 * ��    ����Page ָ��������ڵ�ҳ����Χ��0~15
 * ��    ����X ָ��������ڵ�X�����꣬��Χ��0~127
 * �� �� ֵ����
 * ˵    ����OLEDĬ�ϵ�Y�ᣬֻ��8��BitΪһ��д�룬��1ҳ����8��Y������
 */
void OLED_SetCursor(uint8_t Page, uint8_t X)
{
    /*���ʹ�ô˳�������1.3���OLED��ʾ��������Ҫ�����ע��*/
    /*��Ϊ1.3���OLED����оƬ��SH1106����132��*/
    /*��Ļ����ʼ�н����˵�2�У������ǵ�0��*/
    /*������Ҫ��X��2������������ʾ*/
    //	X += 2;

    /*ͨ��ָ������ҳ��ַ���е�ַ*/
    OLED_Write_CMD(0xB0 | Page);               // ����ҳλ��
    OLED_Write_CMD(0x10 | ((X & 0xF0) >> 4));  // ����Xλ�ø�4λ
    OLED_Write_CMD(0x00 | (X & 0x0F));         // ����Xλ�õ�4λ
}

// �����Դ浽OLED
void OLED_Update(void)
{
    uint8_t j;
    /*����ÿһҳ*/
    for (j = 0; j < 8; j++)
    {
        /*���ù��λ��Ϊÿһҳ�ĵ�һ��*/
        OLED_SetCursor(j, 0);
        /*����д��128�����ݣ����Դ����������д�뵽OLEDӲ��*/
        OLED_WriteDataArr(OLED_DisplayBuf[j], 128);
    }
}
/**
 * ��    ������OLED�Դ����鲿�ָ��µ�OLED��Ļ
 * ��    ����X ָ���������Ͻǵĺ����꣬��Χ��0~127
 * ��    ����Y ָ���������Ͻǵ������꣬��Χ��0~127
 * ��    ����Width ָ������Ŀ�ȣ���Χ��0~128
 * ��    ����Height ָ������ĸ߶ȣ���Χ��0~127
 * �� �� ֵ����
 * ˵    �����˺��������ٸ��²���ָ��������
 *           �����������Y��ֻ��������ҳ����ͬһҳ��ʣ�ಿ�ֻ����һ�����
 * ˵    �������е���ʾ��������ֻ�Ƕ�OLED�Դ�������ж�д
 *           ������OLED_Update������OLED_UpdateArea����
 *           �ŻὫ�Դ���������ݷ��͵�OLEDӲ����������ʾ
 *           �ʵ�����ʾ������Ҫ�������س�������Ļ�ϣ�������ø��º���
 */

void OLED_UpdateArea(uint8_t X, uint8_t Y, uint8_t Width, uint8_t Height)
{
    uint8_t j;

    /*������飬��ָ֤�����򲻻ᳬ����Ļ��Χ*/
    if (X > 128 - 1) { return; }
    if (Y > 64 - 1) { return; }
    if (X + Width > 128) { Width = 128 - X; }
    if (Y + Height > 64) { Height = 64 - Y; }

    /*����ָ�������漰�����ҳ*/
    /*(Y + Height - 1) / 8 + 1��Ŀ����(Y + Height) / 8������ȡ��*/
    for (j = Y / 8; j < (Y + Height - 1) / 8 + 1; j++)
    {
        /*���ù��λ��Ϊ���ҳ��ָ����*/
        OLED_SetCursor(j, X);
        /*����д��Width�����ݣ����Դ����������д�뵽OLEDӲ��*/
        OLED_WriteDataArr(&OLED_DisplayBuf[j][X], Width);
    }
}
extern void OLED_Clear(void);

// OLED�ĳ�ʼ��
void OLED_Init(void)
{
#if OLED_IF_MODE == OLED_IF_SWSPI
    OLED_RES_Clr();
#endif
    for (int i = 0; i < 1000; i++)
    {
        for (int j = 0; j < 1000; j++)
        {
        }
    }
#if OLED_IF_MODE == OLED_IF_SWSPI
    OLED_RES_Set();
#endif

    OLED_Write_CMD(0xAE);
    OLED_Write_CMD(0x00);
    OLED_Write_CMD(0x10);
    OLED_Write_CMD(0x40);
    OLED_Write_CMD(0x81);
    OLED_Write_CMD(0xCF);
    OLED_Write_CMD(0xA1);
    OLED_Write_CMD(0xC8);
    OLED_Write_CMD(0xA6);
    OLED_Write_CMD(0xA8);
    OLED_Write_CMD(0x3f);
    OLED_Write_CMD(0xD3);
    OLED_Write_CMD(0x00);
    OLED_Write_CMD(0xd5);
    OLED_Write_CMD(0x80);
    OLED_Write_CMD(0xD9);
    OLED_Write_CMD(0xF1);
    OLED_Write_CMD(0xDA);
    OLED_Write_CMD(0x12);
    OLED_Write_CMD(0xDB);
    OLED_Write_CMD(0x40);
    OLED_Write_CMD(0x20);
    OLED_Write_CMD(0x02);
    OLED_Write_CMD(0x8D);
    OLED_Write_CMD(0x14);
    OLED_Write_CMD(0xA4);
    OLED_Write_CMD(0xA6);
    OLED_Write_CMD(0xAF);
    OLED_Clear();
    OLED_Write_CMD(0xAF);  // Display ON
    for (int i = 0; i < 1000; i++)
    {
        for (int j = 0; j < 1000; j++)
        {
        }
    }
}

/**
 * ��    ����OLED��������
 * ��    ����Brightness ��0-255����ͬ��ʾоƬЧ�����ܲ���ͬ��
 * �� �� ֵ����
 * ˵    ������Ҫ���ù�����߹�С��
 */
void OLED_Brightness(int16_t Brightness)
{
    if (Brightness > 255)
    {
        Brightness = 255;
    }
    if (Brightness < 0)
    {
        Brightness = 0;
    }
    OLED_Write_CMD(0x81);
    OLED_Write_CMD(Brightness);
}

/**
 * @brief ������ʾģʽ
 * @param colormode true: ��ɫģʽ��false: ��ɫģʽ
 * @return ��
 */
void OLED_SetColorMode(bool colormode)
{
    OLED_ColorMode = colormode;
}
