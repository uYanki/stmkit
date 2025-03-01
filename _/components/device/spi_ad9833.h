#ifndef __SPI_ST7735_H__
#define __SPI_ST7735_H__

#include "spimst.h"

/**
 * @brief DDS
 *
 * 输出频率：0~12.5MHz（12.5MHz在时钟25MHz时达到）；
 * 工作电压：2.3V~5.5V（最大不超过6V）；
 * 输出电压：非方波:38mV~650mv,方波:0~VCC
 * 通信方式：三线SPI（最大通信速率40MHz）；
 * 输出波形：正弦、三角、方波；也可软件控制输出复杂波形；
 * 睡眠模式（唤醒时间1ms）、脉冲直接输出、DAC关断等。
 *
 * https://blog.csdn.net/weixin_56608779/article/details/125654260
 *
 */

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define CONFIG_AD9833_FMCLK 25000000UL  //  Master Clock On AD9833, 25MHz

#define AD9833_SPI_TIMING   (SPI_FLAG_3WIRE | SPI_FLAG_DATAWIDTH_8B | SPI_FLAG_CPOL_HIGH | SPI_FLAG_CPHA_1EDGE | SPI_FLAG_MSBFIRST | SPI_FLAG_CS_ACTIVE_LOW)
// #define AD9833_SPI_TIMING (SPI_FLAG_3WIRE | SPI_FLAG_DATAWIDTH_16B | SPI_FLAG_CPOL_HIGH | SPI_FLAG_CPHA_1EDGE | SPI_FLAG_MSBFIRST |  SPI_FLAG_CS_ACTIVE_LOW)

/***********************************************************************
                            Control Register:
------------------------------------------------------------------------
D15,D14(MSB)	10 = FREQ1 write, 01 = FREQ0 write,
                11 = PHASE write, 00 = control write
D13	If D15,D14 = 00, 0 = individual LSB and MSB FREQ write, 频率寄存器的写入方式（单独写入/连续写入）
                     1 = both LSB and MSB FREQ writes consecutively
    If D15,D14 = 11, 0 = PHASE0 write, 1 = PHASE1 write
D12	0 = writing LSB independently 频率寄存器高低位选择
    1 = writing MSB independently
D11	0 = output FREQ0 [Frequency Select] 输出频率选择
    1 = output FREQ1
D10	0 = output PHASE0 [Phase Select] 输出相位选择
    1 = output PHASE1
D9	Reserved. Must be 0. [Reserved]
D8	0 = RESET disabled [Reset]
    1 = RESET enabled
D7	0 = internal clock is enabled MCLK控制
    1 = internal clock is disabled
D6	0 = onboard DAC is active for sine and triangle wave output, DAC输出控制
    1 = put DAC to sleep for square wave output
D5	0 = output depends on D1 输出连接方式选择
    1 = output is a square wave
D4	Reserved. Must be 0.
D3	0 = square wave of half frequency output  方波输出大小选择
    1 = square wave output
D2	Reserved. Must be 0. [Reserved]
D1	If D5 = 1, D1 = 0.
    Otherwise 0 = sine output, 1 = triangle output 输出模式选择
D0	Reserved. Must be 0. [Reserved]
***********************************************************************/

typedef enum {
    AD9833_CTRL_B28     = 13,
    AD9833_CTRL_HLB     = 12,
    AD9833_CTRL_FSELECT = 11,
    AD9833_CTRL_PSELECT = 10,
    AD9833_CTRL_RESET   = 8,
    AD9833_CTRL_SLEEP1  = 7,
    AD9833_CTRL_SLEEP12 = 6,
    AD9833_CTRL_OPBITEN = 5,
    AD9833_CTRL_DIV2    = 3,
    AD9833_CTRL_MODE    = 1,
} ad9833_control_bit;  // Bit For Control Register

typedef enum {  // 可单独执行的命令：

    // Resets internal registers to 0
    AD9833_CMD_RESET = (1 << AD9833_CTRL_RESET),  // 0x0100

    // Disable DAC and MCLK
    AD9833_CMD_SLEEP = 0x2000 | (1 << AD9833_CTRL_SLEEP1) | (1 << AD9833_CTRL_SLEEP12),  // 0x20C0

} ad9833_control_cmd_e;

typedef enum {
    // Wirte Frequency
    AD9833_FREQ0_SELECT = 0x4000,  // 0100 0000 0000 0000
    AD9833_FREQ1_SELECT = 0x8000,  // 1000 0000 0000 0000
} ad9833_freq_select_e;

typedef enum {
    // Wirte Phase
    AD9833_PHASE0_SELECT = 0xC000,  // 1100 0000 0000 0000
    AD9833_PHASE1_SELECT = 0xE000,  // 1110 0000 0000 0000
} ad9833_phase_select_e;

typedef enum {
    // Selcet Output Frequency
    AD9833_FREQ0_OUTPUT = 0x2000 | (0 << AD9833_CTRL_FSELECT),
    AD9833_FREQ1_OUTPUT = 0x2000 | (1 << AD9833_CTRL_FSELECT),
} ad9833_freq_output_e;

typedef enum {
    // Selcet Output Phase
    AD9833_PHASE0_OUTPUT = 0x2000 | (0 << AD9833_CTRL_PSELECT),
    AD9833_PHASE1_OUTPUT = 0x2000 | (1 << AD9833_CTRL_PSELECT),
} ad9833_phase_output_e;

typedef enum {
    // Set Output Waveform
    AD9833_WAVEFORM_NONE        = AD9833_CMD_SLEEP,
    AD9833_WAVEFORM_SINE        = 0x2000 | (0 << AD9833_CTRL_OPBITEN) | (0 << AD9833_CTRL_MODE),
    AD9833_WAVEFORM_TRIANGLE    = 0x2000 | (0 << AD9833_CTRL_OPBITEN) | (1 << AD9833_CTRL_MODE),
    AD9833_WAVEFORM_HALF_SQUARE = 0x2000 | (1 << AD9833_CTRL_OPBITEN) | (0 << AD9833_CTRL_DIV2),  // 频率减半
    AD9833_WAVEFORM_SQUARE      = 0x2000 | (1 << AD9833_CTRL_OPBITEN) | (1 << AD9833_CTRL_DIV2),
} ad9833_waveform_e;

typedef struct {
    spi_mst_t* hSPI;
} spi_ad9833_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void AD9833_Init(spi_ad9833_t* pHandle);
void AD9833_Reset(spi_ad9833_t* pHandle);

float32_t AD9833_GetResolution(spi_ad9833_t* pHandle);

void AD9833_SetWaveform(spi_ad9833_t* pHandle, ad9833_waveform_e eWavefrom);

/**
 * @param[in] f32Frequency [0,12.5MHz] @25M
 */
void AD9833_SetFrequency(spi_ad9833_t* pHandle, ad9833_freq_select_e eFreqDst, float32_t f32Frequency);

/**
 * @param[in] f32PhaseShift [0,360]
 */
void AD9833_SetPhase(spi_ad9833_t* pHandle, ad9833_phase_select_e ePhaseDst, float32_t f32PhaseShift);

void AD9833_SetOutput(spi_ad9833_t* pHandle, ad9833_freq_output_e eFreqSrc, ad9833_phase_output_e ePhaseSrc);

//---------------------------------------------------------------------------
// Example
//---------------------------------------------------------------------------

#if CONFIG_DEMOS_SW
void AD9833_Test(void);
#endif

#ifdef __cplusplus
}
#endif

#endif
