/* add user code begin Header */
/**
 **************************************************************************
 * @file     main.c
 * @brief    main program
 **************************************************************************
 *                       Copyright notice & Disclaimer
 *
 * The software Board Support Package (BSP) that is made available to
 * download from Artery official website is the copyrighted work of Artery.
 * Artery authorizes customers to use, copy, and distribute the BSP
 * software and its related documentation for the purpose of design and
 * development in conjunction with Artery microcontrollers. Use of the
 * software is governed by this copyright notice and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED ON "AS IS" BASIS WITHOUT WARRANTIES,
 * GUARANTEES OR REPRESENTATIONS OF ANY KIND. ARTERY EXPRESSLY DISCLAIMS,
 * TO THE FULLEST EXTENT PERMITTED BY LAW, ALL EXPRESS, IMPLIED OR
 * STATUTORY OR OTHER WARRANTIES, GUARANTEES OR REPRESENTATIONS,
 * INCLUDING BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.
 *
 **************************************************************************
 */
/* add user code end Header */

/* Includes ------------------------------------------------------------------*/
#include "at32f415_wk_config.h"
#include "wk_system.h"

/* private includes ----------------------------------------------------------*/
/* add user code begin private includes */

#include "at32f415_dma.h"

#include "scheduler.h"

/* add user code end private includes */

/* private typedef -----------------------------------------------------------*/
/* add user code begin private typedef */

/* add user code end private typedef */

/* private define ------------------------------------------------------------*/
/* add user code begin private define */

/* add user code end private define */

/* private macro -------------------------------------------------------------*/
/* add user code begin private macro */

/* add user code end private macro */

/* private variables ---------------------------------------------------------*/
/* add user code begin private variables */
__IO u16 au16AdcSampBuff[5] = {0};

/* add user code end private variables */

/* private function prototypes --------------------------------------------*/
/* add user code begin function prototypes */

/* add user code end function prototypes */

/* private user code ---------------------------------------------------------*/
/* add user code begin 0 */

static void UartInit(void)
{
    //
    // gpio
    //

    gpio_init_type gpio_tx_init_struct = {
        .gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE,
        .gpio_out_type       = GPIO_OUTPUT_PUSH_PULL,
        .gpio_mode           = GPIO_MODE_MUX,
        .gpio_pins           = GPIO_PINS_9,
        .gpio_pull           = GPIO_PULL_NONE,
    };

    gpio_init_type gpio_rx_init_struct = {
        .gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE,
        .gpio_out_type       = GPIO_OUTPUT_PUSH_PULL,
        .gpio_mode           = GPIO_MODE_INPUT,
        .gpio_pins           = GPIO_PINS_10,
        .gpio_pull           = GPIO_PULL_NONE,
    };

    gpio_init(GPIOA, &gpio_tx_init_struct);
    gpio_init(GPIOA, &gpio_rx_init_struct);

    //
    // txdma
    //

    dma_init_type txdma_init_struct = {
        .direction             = DMA_DIR_MEMORY_TO_PERIPHERAL,
        .memory_data_width     = DMA_MEMORY_DATA_WIDTH_BYTE,
        .memory_inc_enable     = TRUE,
        .peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE,
        .peripheral_inc_enable = FALSE,
        .priority              = DMA_PRIORITY_LOW,
        .loop_mode_enable      = FALSE,
    };

    dma_reset(DMA1_CHANNEL3);
    dma_init(DMA1_CHANNEL3, &txdma_init_struct);

    /* flexible function enable */
    dma_flexible_config(DMA1, FLEX_CHANNEL3, DMA_FLEXIBLE_UART1_TX);

    //
    // rxdma
    //

    dma_init_type rxdma_init_struct = {
        .direction             = DMA_DIR_PERIPHERAL_TO_MEMORY,
        .memory_data_width     = DMA_MEMORY_DATA_WIDTH_BYTE,
        .memory_inc_enable     = TRUE,
        .peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE,
        .peripheral_inc_enable = FALSE,
        .priority              = DMA_PRIORITY_LOW,
        .loop_mode_enable      = FALSE,
    };

    dma_reset(DMA1_CHANNEL2);
    dma_init(DMA1_CHANNEL2, &rxdma_init_struct);

    /* flexible function enable */
    dma_flexible_config(DMA1, FLEX_CHANNEL2, DMA_FLEXIBLE_UART1_RX);

    //
    // uart
    //

    /* configure param */
    usart_init(MODBUS_UART_BASE, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
    usart_transmitter_enable(MODBUS_UART_BASE, TRUE);
    usart_receiver_enable(MODBUS_UART_BASE, TRUE);
    usart_parity_selection_config(MODBUS_UART_BASE, USART_PARITY_NONE);
    usart_dma_transmitter_enable(MODBUS_UART_BASE, TRUE);
    usart_dma_receiver_enable(MODBUS_UART_BASE, TRUE);
    usart_hardware_flow_control_set(MODBUS_UART_BASE, USART_HARDWARE_FLOW_NONE);

    usart_enable(MODBUS_UART_BASE, TRUE);

    //
    // crc
    //

    crc_init_data_set(0xFFFFF);
    crc_poly_size_set(CRC_POLY_SIZE_16B);
    crc_poly_value_set(0x8005);
    crc_reverse_input_data_set(CRC_REVERSE_INPUT_BY_BYTE);
    crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_DATA);
    crc_data_reset();
}

static void TimInit(void)
{
    //
    // systick (1khz)
    //

    tmr_base_init(TIM_SYSTICK_BASE, 35999, 3);
    tmr_cnt_dir_set(TIM_SYSTICK_BASE, TMR_COUNT_UP);
    tmr_clock_source_div_set(TIM_SYSTICK_BASE, TMR_CLOCK_DIV1);
    tmr_period_buffer_enable(TIM_SYSTICK_BASE, FALSE);

    /* configure overflow event */
    tmr_overflow_request_source_set(TIM_SYSTICK_BASE, TRUE);

    tmr_counter_enable(TIM_SYSTICK_BASE, FALSE);
    tmr_interrupt_enable(TIM_SYSTICK_BASE, TMR_OVF_INT, TRUE);

    //
    // scan isr (4khz)
    //

    tmr_base_init(TIM_SCAN_BASE, 35999, 0);
    tmr_cnt_dir_set(TIM_SCAN_BASE, TMR_COUNT_UP);
    tmr_clock_source_div_set(TIM_SCAN_BASE, TMR_CLOCK_DIV1);
    tmr_period_buffer_enable(TIM_SCAN_BASE, FALSE);

    /* configure overflow event */
    tmr_overflow_request_source_set(TIM_SCAN_BASE, TRUE);

    tmr_counter_enable(TIM_SCAN_BASE, FALSE);
    tmr_interrupt_enable(TIM_SCAN_BASE, TMR_OVF_INT, TRUE);
}

static void AdcInit(void)
{
    //
    // clk
    //

    crm_adc_clock_div_set(CRM_ADC_DIV_4);

    //
    // gpio
    //

    gpio_init_type gpio_init_struct = {
        .gpio_mode = GPIO_MODE_ANALOG,
        .gpio_pins = GPIO_PINS_2 | GPIO_PINS_3 | GPIO_PINS_4 | GPIO_PINS_5,
    };

    gpio_init(GPIOA, &gpio_init_struct);

    //
    // dma
    //

    dma_init_type dma_init_struct = {
        .direction             = DMA_DIR_PERIPHERAL_TO_MEMORY,
        .memory_data_width     = DMA_MEMORY_DATA_WIDTH_HALFWORD,
        .memory_inc_enable     = TRUE,
        .peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD,
        .peripheral_inc_enable = FALSE,
        .loop_mode_enable      = TRUE,
        .priority              = DMA_PRIORITY_LOW,
        .peripheral_base_addr  = (uint32_t)&ADC1->odt,
        .memory_base_addr      = (uint32_t)&au16AdcSampBuff[0],
        .buffer_size           = ARRAY_SIZE(au16AdcSampBuff),
    };

    dma_reset(DMA1_CHANNEL1);
    dma_init(DMA1_CHANNEL1, &dma_init_struct);

    /* flexible function enable */
    dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_ADC1);

    //
    // adc
    //

    adc_base_config_type adc_base_struct = {
        .sequence_mode           = TRUE,
        .repeat_mode             = TRUE,
        .data_align              = ADC_RIGHT_ALIGNMENT,
        .ordinary_channel_length = 5,
    };

    adc_tempersensor_vintrv_enable(TRUE);  // temp sensor
    adc_base_config(ADC1, &adc_base_struct);

    // channel
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_2, 1, ADC_SAMPLETIME_239_5);
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_3, 2, ADC_SAMPLETIME_239_5);
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_4, 3, ADC_SAMPLETIME_239_5);
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_5, 4, ADC_SAMPLETIME_239_5);
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_16, 5, ADC_SAMPLETIME_239_5);

    adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
    adc_ordinary_part_mode_enable(ADC1, FALSE);
    adc_dma_mode_enable(ADC1, TRUE);

    adc_enable(ADC1, TRUE);

    // calibration
    adc_calibration_init(ADC1);
    while (adc_calibration_init_status_get(ADC1));
    adc_calibration_start(ADC1);
    while (adc_calibration_status_get(ADC1));
}

static void AdcEnable(void)
{
    dma_channel_enable(DMA1_CHANNEL1, TRUE);
    dma_interrupt_enable(DMA1_CHANNEL1, DMA_FDT_INT, TRUE);  // adc dma
    adc_enable(ADC1, TRUE);
}

static void I2cInit(void)
{
    //
    // clk
    //

#if 0
    crm_periph_clock_enable(CRM_I2C1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
#endif

    //
    // gpio
    //

    gpio_init_type gpio_init_struct = {
        .gpio_out_type       = GPIO_OUTPUT_OPEN_DRAIN,
        .gpio_pull           = GPIO_PULL_NONE,
        .gpio_mode           = GPIO_MODE_MUX,
        .gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE,
        .gpio_pins           = GPIO_PINS_6 | GPIO_PINS_7,
    };

    gpio_init(GPIOB, &gpio_init_struct);

    //
    // dma
    //

    //
    // i2c
    //

    i2c_init(EEPROM_I2C_BASE, I2C_FSMODE_DUTY_2_1, 400000);  // 400k
    i2c_own_address1_set(EEPROM_I2C_BASE, I2C_ADDRESS_MODE_7BIT, 0x0);
    i2c_ack_enable(EEPROM_I2C_BASE, TRUE);
    i2c_clock_stretch_enable(EEPROM_I2C_BASE, TRUE);
    i2c_general_call_enable(EEPROM_I2C_BASE, FALSE);

    i2c_enable(EEPROM_I2C_BASE, TRUE);
}

static void FlexPulInit(void)
{
    //
    // gpio
    //

    gpio_init_type gpio_init_struct = {
        .gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER,
        .gpio_out_type       = GPIO_OUTPUT_PUSH_PULL,
        .gpio_mode           = GPIO_MODE_OUTPUT,
        .gpio_pins           = FlexCH0_PIN | FlexCH1_PIN | FlexCH2_PIN | FlexCH3_PIN,
        .gpio_pull           = GPIO_PULL_NONE,
    };

    gpio_bits_reset(GPIOB, gpio_init_struct.gpio_pins);
    gpio_init(GPIOB, &gpio_init_struct);

    //
    // dma
    //

    dma_init_type dma_init_struct = {
        .peripheral_base_addr  = 0,
        .memory_base_addr      = 0,
        .direction             = DMA_DIR_MEMORY_TO_PERIPHERAL,
        .buffer_size           = 0,
        .peripheral_inc_enable = FALSE,
        .memory_inc_enable     = TRUE,
        .peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_WORD,
        .memory_data_width     = DMA_MEMORY_DATA_WIDTH_HALFWORD,
        .loop_mode_enable      = TRUE,
        .priority              = DMA_PRIORITY_LOW,
    };

    dma_reset(FLEXPUL_DMA_CH);
    dma_init(FLEXPUL_DMA_CH, &dma_init_struct);
    dma_flexible_config(DMA1, FLEXPUL_DMA_FLEXCH, DMA_FLEXIBLE_TMR5_OVERFLOW);  // 触发源
    dma_channel_enable(FLEXPUL_DMA_CH, TRUE);

    //
    // tmr
    //

    tmr_base_init(FLEXPUL_TMR_BASE, 0, 0);
    tmr_cnt_dir_set(FLEXPUL_TMR_BASE, TMR_COUNT_UP);
    tmr_clock_source_div_set(FLEXPUL_TMR_BASE, TMR_CLOCK_DIV1);
    tmr_period_buffer_enable(FLEXPUL_TMR_BASE, FALSE);

    /* configure primary mode settings */
    tmr_sub_sync_mode_set(FLEXPUL_TMR_BASE, FALSE);
    tmr_primary_mode_select(FLEXPUL_TMR_BASE, TMR_PRIMARY_SEL_RESET);

    /* configure dma overflow */
    tmr_dma_request_enable(FLEXPUL_TMR_BASE, TMR_OVERFLOW_DMA_REQUEST, TRUE);

    tmr_counter_enable(FLEXPUL_TMR_BASE, FALSE);
    tmr_counter_value_set(FLEXPUL_TMR_BASE, 0);
}

static void GpioInit(void)
{
    gpio_init_type gpio_init_struct;
    gpio_default_para_init(&gpio_init_struct);

    /* gpio input config */

#if CONFIG_GEN_DI_NUM > 0

    gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pins = DI4_PIN;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(DI4_GPIO_PORT, &gpio_init_struct);

    gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pins = DI5_PIN;
    gpio_init_struct.gpio_pull = GPIO_PULL_DOWN;
    gpio_init(DI5_GPIO_PORT, &gpio_init_struct);

    gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pins = DI2_PIN | DI3_PIN | DI0_PIN | DI1_PIN;
    gpio_init_struct.gpio_pull = GPIO_PULL_DOWN;
    gpio_init(GPIOB, &gpio_init_struct);

#endif

    /* gpio output config */

#if CONFIG_GEN_DO_NUM > 0

    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_OUTPUT;
    gpio_init_struct.gpio_pins           = DO0_PIN | DO1_PIN;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_bits_reset(GPIOB, gpio_init_struct.gpio_pins);
    gpio_init(GPIOB, &gpio_init_struct);

#endif

#if CONFIG_LED_NUM > 0

    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_OUTPUT;
    gpio_init_struct.gpio_pins           = LED1_PIN | LED2_PIN;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_bits_reset(GPIOF, gpio_init_struct.gpio_pins);
    gpio_init(GPIOF, &gpio_init_struct);

#endif
}

/* add user code end 0 */

/**
 * @brief main function.
 * @param  none
 * @retval none
 */
int main(void)
{
    /* add user code begin 1 */

    /* add user code end 1 */

    /* system clock config. */
    wk_system_clock_config();

    /* config periph clock. */
    wk_periph_clock_config();

    /* init debug function. */
    wk_debug_config();

    /* nvic config. */
    wk_nvic_config();

    /* timebase config. */
    wk_timebase_init();

    /* add user code begin 2 */

    GpioInit();
    UartInit();
    TimInit();
    I2cInit();
    AdcInit();
    FlexPulInit();

    tmr_counter_enable(TIM_SYSTICK_BASE, TRUE);

    SchedCreat();
    SchedInit();

    tmr_counter_enable(TIM_SCAN_BASE, TRUE);

    AdcEnable();

    switch (4)  // 预设脉冲
    {
        case 0:
        {
            // AB 正向
            D.u16FlexPulStartIndex = 0;
            D.u16FlexPulStopIndex  = 3;
            D.u16FlexPulData00     = 0b10;
            D.u16FlexPulData01     = 0b00;
            D.u16FlexPulData02     = 0b01;
            D.u16FlexPulData03     = 0b11;

            break;
        }
        case 1:
        {
            // AB 反向
            D.u16FlexPulStartIndex = 0;
            D.u16FlexPulStopIndex  = 3;
            D.u16FlexPulData00     = 0b11;
            D.u16FlexPulData01     = 0b01;
            D.u16FlexPulData02     = 0b00;
            D.u16FlexPulData03     = 0b10;

            break;
        }
        case 2:
        {
            // PD 正向
            D.u16FlexPulStartIndex = 0;
            D.u16FlexPulStopIndex  = 3;
            D.u16FlexPulData00     = 0b11;
            D.u16FlexPulData01     = 0b10;
            D.u16FlexPulData02     = 0b11;
            D.u16FlexPulData03     = 0b10;

            break;
        }
        case 3:
        {
            // PD 反向
            D.u16FlexPulStartIndex = 0;
            D.u16FlexPulStopIndex  = 3;
            D.u16FlexPulData00     = 0b11;
            D.u16FlexPulData01     = 0b01;
            D.u16FlexPulData02     = 0b11;
            D.u16FlexPulData03     = 0b01;

            break;
        }
        case 4:
        {
            // CW/CCW 正向
            D.u16FlexPulStartIndex = 0;
            D.u16FlexPulStopIndex  = 3;
            D.u16FlexPulData00     = 0b10;
            D.u16FlexPulData01     = 0b00;
            D.u16FlexPulData02     = 0b10;
            D.u16FlexPulData03     = 0b00;

            break;
        }
        case 5:
        {
            // CW/CCW 反向
            D.u16FlexPulStartIndex = 0;
            D.u16FlexPulStopIndex  = 3;
            D.u16FlexPulData00     = 0b01;
            D.u16FlexPulData01     = 0b00;
            D.u16FlexPulData02     = 0b01;
            D.u16FlexPulData03     = 0b00;

            break;
        }
    }

    // D.bFlexPulOutEn = 1;

    /* add user code end 2 */

    while (1)
    {
        /* add user code begin 3 */

        SchedCycle();
        /* add user code end 3 */
    }
}

/* add user code begin 4 */

#if 0

typedef enum {
    EEPROM_IDLE,
    EEPROM_WRITE_BUSY,
    EEPROM_READ_BUSY,
    EEPROM_VERIFY,
    EEPROM_BUSY,
} eeprom_state_e;

typedef enum {
    EEPROM_READ_MEM,
    EEPROM_WEITE_MEM,
} eeprom_access_e;

u16* u16MemAddr[];
u16* u16BufAddr[];
u16  u16BufSize[];

typedef struct {
    eeprom_access_e eAccessMode;
    u16             u16MemAddr;
    u16*            pu16BufAddr;
    u16             u16BufSize;
} eeprom_request_t;

eeprom_request_t aEepromRequest[10];

void EepromWr()
{
    eeprom_state_e eFsm;

    // i2c_memory_read_dma();

    int i = 0;

    eeprom_request_t* pRequest;

    switch (eFsm)
    {
        case EEPROM_IDLE:
        {
            switch (pRequest->eAccessMode)
            {
                case EEPROM_READ_MEM:
                {
                    // i2c_memory_read_dma(EEPROM_I2C_BASE, I2C_MEM_ADDR_WIDIH_16, EEPROM_DEV_ADDR, pRequest->u16MemAddr, pRequest->pu16BufAddr, pRequest->u16BufSize, 0xFF);
                    eFsm = EEPROM_READ_BUSY;
                    break;
                }
                case EEPROM_WEITE_MEM:
                {
                    // i2c_memory_write_dma(EEPROM_I2C_BASE, I2C_MEM_ADDR_WIDIH_16, EEPROM_DEV_ADDR, pRequest->u16MemAddr, pRequest->pu16BufAddr, pRequest->u16BufSize, 0xFF);
                    eFsm = EEPROM_WRITE_BUSY;
                    break;
                }
                default:
                {
                    break;
                }
            }

            break;
        }

        case EEPROM_WRITE_BUSY:
        {
            eFsm = EEPROM_VERIFY;
            break;
        }

        case EEPROM_READ_BUSY:
        {
            eFsm = EEPROM_IDLE;

            i2c_wait_end();
            break;
        }

        case EEPROM_VERIFY:
        {
            eFsm = EEPROM_IDLE;
            break;
        }
    }
}

#endif

para_rw_status_e ParaData_UserCheck(u16 u16Index, u16* pu16Data)
{
    switch (u16Index)
    {
        case PARA_INDEX_U16_PUL_IN_MODE:
        {
            if (D.bPulInEn != 0)
            {
                return PARA_RW_MODIFY_AT_STOP;
            }

            switch (he16(pu16Data))
            {
                case 0:  // PD
                case 2:  // CW/CCW
                case 3:  // UVW
                {
                    return PARA_RW_ILLEGAL_VALUE;
                }

                default:
                {
                    break;
                }
            }

            break;
        }

        case PARA_INDEX_U32_PUL_OUT_CNT:
        case PARA_INDEX_U32_PUL_OUT_FREQ:
        case PARA_INDEX_U16_PUL_OUT_DUTY:
        {
            if (D.bPulOutEn != 0)
            {
                return PARA_RW_MODIFY_AT_STOP;
            }

            break;
        }

        case PARA_INDEX_U32_FLEX_PUL_OUT_FREQ:
        case PARA_INDEX_U16_FLEX_PUL_START_INDEX:
        case PARA_INDEX_U16_FLEX_PUL_STOP_INDEX:
        {
            if (D.bFlexPulOutEn != 0 || D.bPulOutEn != 0)
            {
                return PARA_RW_MODIFY_AT_STOP;
            }

            break;
        }

        default:
        {
            break;
        }
    }

    return PARA_RW_SUCCESS;
}

/* add user code end 4 */
