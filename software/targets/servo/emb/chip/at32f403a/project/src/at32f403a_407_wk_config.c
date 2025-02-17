/* add user code begin Header */
/**
 **************************************************************************
 * @file     at32f403a_407_wk_config.c
 * @brief    work bench config program
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

#include "at32f403a_407_wk_config.h"
#include "typebasic.h"
/* private includes ----------------------------------------------------------*/
/* add user code begin private includes */

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

/* add user code end private variables */

/* private function prototypes --------------------------------------------*/
/* add user code begin function prototypes */

/* add user code end function prototypes */

/* private user code ---------------------------------------------------------*/
/* add user code begin 0 */

/* add user code end 0 */

/**
 * @brief  system clock config program
 * @note   the system clock is configured as follow:
 *         system clock (sclk)   = hick / 12 * pll_mult
 *         system clock source   = HICK_VALUE
 *         - sclk                = 240000000
 *         - ahbdiv              = 1
 *         - ahbclk              = 240000000
 *         - apb1div             = 2
 *         - apb1clk             = 120000000
 *         - apb2div             = 2
 *         - apb2clk             = 120000000
 *         - pll_mult            = 60
 *         - pll_range           = GT72MHZ (greater than 72 mhz)
 * @param  none
 * @retval none
 */
void wk_system_clock_config(void)
{
    /* reset crm */
    crm_reset();

    /* enable lick */
    crm_clock_source_enable(CRM_CLOCK_SOURCE_LICK, TRUE);

    /* wait till lick is ready */
    while (crm_flag_get(CRM_LICK_STABLE_FLAG) != SET)
    {
    }

    /* enable hick */
    crm_clock_source_enable(CRM_CLOCK_SOURCE_HICK, TRUE);

    /* wait till hick is ready */
    while (crm_flag_get(CRM_HICK_STABLE_FLAG) != SET)
    {
    }

    /* config pll clock resource */
    crm_pll_config(CRM_PLL_SOURCE_HICK, CRM_PLL_MULT_60, CRM_PLL_OUTPUT_RANGE_GT72MHZ);

    /* enable pll */
    crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);

    /* wait till pll is ready */
    while (crm_flag_get(CRM_PLL_STABLE_FLAG) != SET)
    {
    }

    /* config ahbclk */
    crm_ahb_div_set(CRM_AHB_DIV_1);

    /* config apb2clk, the maximum frequency of APB2 clock is 120 MHz  */
    crm_apb2_div_set(CRM_APB2_DIV_2);

    /* config apb1clk, the maximum frequency of APB1 clock is 120 MHz  */
    crm_apb1_div_set(CRM_APB1_DIV_2);

    /* enable auto step mode */
    crm_auto_step_mode_enable(TRUE);

    /* select pll as system clock source */
    crm_sysclk_switch(CRM_SCLK_PLL);

    /* wait till pll is used as system clock source */
    while (crm_sysclk_switch_status_get() != CRM_SCLK_PLL)
    {
    }

    /* disable auto step mode */
    crm_auto_step_mode_enable(FALSE);

    /* update system_core_clock global variable */
    system_core_clock_update();
}

/**
 * @brief  config periph clock
 * @param  none
 * @retval none
 */
void wk_periph_clock_config(void)
{
    /* enable dma1 periph clock */
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);

    /* enable crc periph clock */
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);

    /* enable iomux periph clock */
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);

    /* enable gpioa periph clock */
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);

    /* enable gpiob periph clock */
    crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

    /* enable gpioc periph clock */
    crm_periph_clock_enable(CRM_GPIOC_PERIPH_CLOCK, TRUE);

    /* enable adc1 periph clock */
    crm_periph_clock_enable(CRM_ADC1_PERIPH_CLOCK, TRUE);

    /* enable adc2 periph clock */
    crm_periph_clock_enable(CRM_ADC2_PERIPH_CLOCK, TRUE);

    /* enable tmr1 periph clock */
    crm_periph_clock_enable(CRM_TMR1_PERIPH_CLOCK, TRUE);

    /* enable spi1 periph clock */
    crm_periph_clock_enable(CRM_SPI1_PERIPH_CLOCK, TRUE);

    /* enable adc3 periph clock */
    crm_periph_clock_enable(CRM_ADC3_PERIPH_CLOCK, TRUE);

    /* enable acc periph clock */
    crm_periph_clock_enable(CRM_ACC_PERIPH_CLOCK, TRUE);

    /* enable tmr2 periph clock */
    crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);

    /* enable tmr6 periph clock */
    crm_periph_clock_enable(CRM_TMR6_PERIPH_CLOCK, TRUE);

    /* enable tmr7 periph clock */
    crm_periph_clock_enable(CRM_TMR7_PERIPH_CLOCK, TRUE);

    /* enable usart3 periph clock */
    crm_periph_clock_enable(CRM_USART3_PERIPH_CLOCK, TRUE);

    /* enable usb periph clock */
    crm_periph_clock_enable(CRM_USB_PERIPH_CLOCK, TRUE);

    /* enable can2 periph clock */
    crm_periph_clock_enable(CRM_CAN2_PERIPH_CLOCK, TRUE);
}

/**
 * @brief  init debug function.
 * @param  none
 * @retval none
 */
void wk_debug_config(void)
{
    /* jtag-dp disabled and sw-dp enabled */
    gpio_pin_remap_config(SWJTAG_GMUX_010, TRUE);
}

/**
 * @brief  nvic config
 * @param  none
 * @retval none
 */
void wk_nvic_config(void)
{
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);

    NVIC_SetPriority(MemoryManagement_IRQn, NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 0, 0));
    NVIC_SetPriority(BusFault_IRQn, NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 0, 0));
    NVIC_SetPriority(UsageFault_IRQn, NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 0, 0));
    NVIC_SetPriority(SVCall_IRQn, NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 0, 0));
    NVIC_SetPriority(DebugMonitor_IRQn, NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 0, 0));
    NVIC_SetPriority(PendSV_IRQn, NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 0, 0));
    NVIC_SetPriority(SysTick_IRQn, NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 15, 0));
    nvic_irq_enable(DMA1_Channel1_IRQn, 0, 0);
    nvic_irq_enable(DMA1_Channel3_IRQn, 0, 0);
    nvic_irq_enable(TMR1_OVF_TMR10_IRQn, 0, 0);
    nvic_irq_enable(USART3_IRQn, 0, 0);
    nvic_irq_enable(TMR6_GLOBAL_IRQn, 0, 0);
    nvic_irq_enable(TMR7_GLOBAL_IRQn, 0, 0);
}

/**
 * @brief  init gpio_input/gpio_output/gpio_analog/eventout function.
 * @param  none
 * @retval none
 */
void wk_gpio_config(void)
{
    /* add user code begin gpio_config 0 */

    /* add user code end gpio_config 0 */

    gpio_init_type gpio_init_struct;
    gpio_default_para_init(&gpio_init_struct);

    /* add user code begin gpio_config 1 */

    /* add user code end gpio_config 1 */

    /* gpio output config */
    gpio_bits_reset(SPI_CS_GPIO_PORT, SPI_CS_PIN);

    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_OUTPUT;
    gpio_init_struct.gpio_pins           = SPI_CS_PIN;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init(SPI_CS_GPIO_PORT, &gpio_init_struct);

    /* add user code begin gpio_config 2 */

    /* add user code end gpio_config 2 */
}

/**
 * @brief  init spi1 function
 * @param  none
 * @retval none
 */
void wk_spi1_init(void)
{
    /* add user code begin spi1_init 0 */

    /* add user code end spi1_init 0 */

    gpio_init_type gpio_init_struct;
    spi_init_type  spi_init_struct;

    gpio_default_para_init(&gpio_init_struct);
    spi_default_para_init(&spi_init_struct);

    /* add user code begin spi1_init 1 */

    /* add user code end spi1_init 1 */

    /* configure the SCK pin */
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_pins           = GPIO_PINS_5;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);

    /* configure the MISO pin */
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pins           = GPIO_PINS_6;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);

    /* configure the MOSI pin */
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_pins           = GPIO_PINS_7;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);

    /* configure param */
    spi_init_struct.transmission_mode      = SPI_TRANSMIT_FULL_DUPLEX;
    spi_init_struct.master_slave_mode      = SPI_MODE_MASTER;
    spi_init_struct.frame_bit_num          = SPI_FRAME_8BIT;
    spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_MSB;
    spi_init_struct.mclk_freq_division     = SPI_MCLK_DIV_8;
    spi_init_struct.clock_polarity         = SPI_CLOCK_POLARITY_LOW;
    spi_init_struct.clock_phase            = SPI_CLOCK_PHASE_2EDGE;
    spi_init_struct.cs_mode_selection      = SPI_CS_SOFTWARE_MODE;
    spi_init(SPI1, &spi_init_struct);

    /* add user code begin spi1_init 2 */

    /* add user code end spi1_init 2 */

    spi_enable(SPI1, TRUE);

    /* add user code begin spi1_init 3 */

    /* add user code end spi1_init 3 */
}

/**
 * @brief  init usart3 function
 * @param  none
 * @retval none
 */
void wk_usart3_init(void)
{
    /* add user code begin usart3_init 0 */

    /* add user code end usart3_init 0 */

    gpio_init_type gpio_init_struct;
    gpio_default_para_init(&gpio_init_struct);

    /* add user code begin usart3_init 1 */

    /* add user code end usart3_init 1 */

    /* configure the TX pin */
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_pins           = GPIO_PINS_10;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init(GPIOB, &gpio_init_struct);

    /* configure the RX pin */
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pins           = GPIO_PINS_11;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init(GPIOB, &gpio_init_struct);

    /* configure param */
    usart_init(USART3, 691200, USART_DATA_8BITS, USART_STOP_1_BIT);
    usart_transmitter_enable(USART3, TRUE);
    usart_receiver_enable(USART3, TRUE);
    usart_parity_selection_config(USART3, USART_PARITY_NONE);

    usart_dma_transmitter_enable(USART3, TRUE);

    usart_dma_receiver_enable(USART3, TRUE);

    usart_hardware_flow_control_set(USART3, USART_HARDWARE_FLOW_NONE);

    /**
     * Users need to configure USART3 interrupt functions according to the actual application.
     * 1. Call the below function to enable the corresponding USART3 interrupt.
     *     --usart_interrupt_enable(...)
     * 2. Add the user's interrupt handler code into the below function in the at32f403a_407_int.c file.
     *     --void USART3_IRQHandler(void)
     */

    /* add user code begin usart3_init 2 */

    /* add user code end usart3_init 2 */

    usart_enable(USART3, TRUE);

    /* add user code begin usart3_init 3 */

    /* add user code end usart3_init 3 */
}

/**
 * @brief  init tmr1 function.
 * @param  none
 * @retval none
 */
void wk_tmr1_init(void)
{
    /* add user code begin tmr1_init 0 */

    /* add user code end tmr1_init 0 */

    gpio_init_type         gpio_init_struct;
    tmr_output_config_type tmr_output_struct;
    tmr_brkdt_config_type  tmr_brkdt_struct;

    gpio_default_para_init(&gpio_init_struct);

    /* add user code begin tmr1_init 1 */

    /* add user code end tmr1_init 1 */

    /* configure the CH1C pin */
    gpio_init_struct.gpio_pins           = GPIO_PINS_13;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init(GPIOB, &gpio_init_struct);

    /* configure the CH2C pin */
    gpio_init_struct.gpio_pins           = GPIO_PINS_14;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init(GPIOB, &gpio_init_struct);

    /* configure the CH3C pin */
    gpio_init_struct.gpio_pins           = GPIO_PINS_15;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init(GPIOB, &gpio_init_struct);

    /* configure the CH1 pin */
    gpio_init_struct.gpio_pins           = GPIO_PINS_8;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init(GPIOA, &gpio_init_struct);

    /* configure the CH2 pin */
    gpio_init_struct.gpio_pins           = GPIO_PINS_9;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init(GPIOA, &gpio_init_struct);

    /* configure the CH3 pin */
    gpio_init_struct.gpio_pins           = GPIO_PINS_10;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init(GPIOA, &gpio_init_struct);

    /* configure counter settings */
    tmr_base_init(TMR1, 14999, 0);
    tmr_cnt_dir_set(TMR1, TMR_COUNT_TWO_WAY_2);
    tmr_clock_source_div_set(TMR1, TMR_CLOCK_DIV1);
    tmr_repetition_counter_set(TMR1, 0);
    tmr_period_buffer_enable(TMR1, FALSE);

    /* configure primary mode settings */
    tmr_sub_sync_mode_set(TMR1, FALSE);
    tmr_primary_mode_select(TMR1, TMR_PRIMARY_SEL_C4ORAW);

    /* configure channel 1 output settings */
    tmr_output_struct.oc_mode          = TMR_OUTPUT_CONTROL_PWM_MODE_A;
    tmr_output_struct.oc_output_state  = TRUE;
    tmr_output_struct.occ_output_state = TRUE;
    tmr_output_struct.oc_polarity      = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.occ_polarity     = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.oc_idle_state    = FALSE;
    tmr_output_struct.occ_idle_state   = FALSE;
    tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
    tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_1, 0);
    tmr_output_channel_buffer_enable(TMR1, TMR_SELECT_CHANNEL_1, TRUE);

    tmr_output_channel_immediately_set(TMR1, TMR_SELECT_CHANNEL_1, FALSE);

    /* configure channel 2 output settings */
    tmr_output_struct.oc_mode          = TMR_OUTPUT_CONTROL_PWM_MODE_A;
    tmr_output_struct.oc_output_state  = TRUE;
    tmr_output_struct.occ_output_state = TRUE;
    tmr_output_struct.oc_polarity      = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.occ_polarity     = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.oc_idle_state    = FALSE;
    tmr_output_struct.occ_idle_state   = FALSE;
    tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_2, &tmr_output_struct);
    tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_2, 0);
    tmr_output_channel_buffer_enable(TMR1, TMR_SELECT_CHANNEL_2, TRUE);

    tmr_output_channel_immediately_set(TMR1, TMR_SELECT_CHANNEL_2, FALSE);

    /* configure channel 3 output settings */
    tmr_output_struct.oc_mode          = TMR_OUTPUT_CONTROL_PWM_MODE_A;
    tmr_output_struct.oc_output_state  = TRUE;
    tmr_output_struct.occ_output_state = TRUE;
    tmr_output_struct.oc_polarity      = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.occ_polarity     = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.oc_idle_state    = FALSE;
    tmr_output_struct.occ_idle_state   = FALSE;
    tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_3, &tmr_output_struct);
    tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_3, 0);
    tmr_output_channel_buffer_enable(TMR1, TMR_SELECT_CHANNEL_3, TRUE);

    tmr_output_channel_immediately_set(TMR1, TMR_SELECT_CHANNEL_3, FALSE);

    /* configure channel 4 output settings */
    tmr_output_struct.oc_mode          = TMR_OUTPUT_CONTROL_PWM_MODE_A;
    tmr_output_struct.oc_output_state  = TRUE;
    tmr_output_struct.occ_output_state = FALSE;
    tmr_output_struct.oc_polarity      = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.occ_polarity     = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.oc_idle_state    = FALSE;
    tmr_output_struct.occ_idle_state   = FALSE;
    tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_4, &tmr_output_struct);
    tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_4, PWM_PERIOD - 2);
    tmr_output_channel_buffer_enable(TMR1, TMR_SELECT_CHANNEL_4, FALSE);

    tmr_output_channel_immediately_set(TMR1, TMR_SELECT_CHANNEL_4, FALSE);

    /* configure break and dead-time settings */
    tmr_brkdt_struct.brk_enable         = FALSE;
    tmr_brkdt_struct.auto_output_enable = FALSE;
    tmr_brkdt_struct.brk_polarity       = TMR_BRK_INPUT_ACTIVE_LOW;
    tmr_brkdt_struct.fcsoen_state       = FALSE;
    tmr_brkdt_struct.fcsodis_state      = FALSE;
    tmr_brkdt_struct.wp_level           = TMR_WP_OFF;
    tmr_brkdt_struct.deadtime           = 205;
    tmr_brkdt_config(TMR1, &tmr_brkdt_struct);

    tmr_output_enable(TMR1, TRUE);

    tmr_counter_enable(TMR1, TRUE);

    /**
     * Users need to configure TMR1 interrupt functions according to the actual application.
     * 1. Call the below function to enable the corresponding TMR1 interrupt.
     *     --tmr_interrupt_enable(...)
     * 2. Add the user's interrupt handler code into the below function in the at32f403a_407_int.c file.
     *     --void TMR1_OVF_TMR10_IRQHandler(void)
     */

    /* add user code begin tmr1_init 2 */

    /* add user code end tmr1_init 2 */
}

/**
 * @brief  init tmr2 function.
 * @param  none
 * @retval none
 */
void wk_tmr2_init(void)
{
    /* add user code begin tmr2_init 0 */

    /* add user code end tmr2_init 0 */

    gpio_init_type         gpio_init_struct;
    tmr_output_config_type tmr_output_struct;

    gpio_default_para_init(&gpio_init_struct);

    /* add user code begin tmr2_init 1 */

    /* add user code end tmr2_init 1 */

    /* configure the CH1 pin */
    gpio_init_struct.gpio_pins           = GPIO_PINS_0;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init(GPIOA, &gpio_init_struct);

    /* configure counter settings */
    tmr_base_init(TMR2, 65535, 0);
    tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
    tmr_clock_source_div_set(TMR2, TMR_CLOCK_DIV1);
    tmr_period_buffer_enable(TMR2, FALSE);

    /* configure primary mode settings */
    tmr_sub_sync_mode_set(TMR2, FALSE);
    tmr_primary_mode_select(TMR2, TMR_PRIMARY_SEL_RESET);

    /* configure channel 1 output settings */
    tmr_output_struct.oc_mode          = TMR_OUTPUT_CONTROL_OFF;
    tmr_output_struct.oc_output_state  = TRUE;
    tmr_output_struct.occ_output_state = FALSE;
    tmr_output_struct.oc_polarity      = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.occ_polarity     = TMR_OUTPUT_ACTIVE_HIGH;
    tmr_output_struct.oc_idle_state    = FALSE;
    tmr_output_struct.occ_idle_state   = FALSE;
    tmr_output_channel_config(TMR2, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
    tmr_channel_value_set(TMR2, TMR_SELECT_CHANNEL_1, 0);
    tmr_output_channel_buffer_enable(TMR2, TMR_SELECT_CHANNEL_1, FALSE);

    tmr_counter_enable(TMR2, TRUE);

    /* add user code begin tmr2_init 2 */

    /* add user code end tmr2_init 2 */
}

/**
 * @brief  init tmr6 function.
 * @param  none
 * @retval none
 */
void wk_tmr6_init(void)
{
    /* add user code begin tmr6_init 0 */

    /* add user code end tmr6_init 0 */

    /* add user code begin tmr6_init 1 */

    /* add user code end tmr6_init 1 */

    /* configure counter settings */
    tmr_base_init(TMR6, 9999, 23);
    tmr_cnt_dir_set(TMR6, TMR_COUNT_UP);
    tmr_period_buffer_enable(TMR6, FALSE);

    /* configure primary mode settings */
    tmr_primary_mode_select(TMR6, TMR_PRIMARY_SEL_RESET);

    /* configure overflow event */
    tmr_overflow_request_source_set(TMR6, TRUE);

    tmr_counter_enable(TMR6, TRUE);

    /**
     * Users need to configure TMR6 interrupt functions according to the actual application.
     * 1. Call the below function to enable the corresponding TMR6 interrupt.
     *     --tmr_interrupt_enable(...)
     * 2. Add the user's interrupt handler code into the below function in the at32f403a_407_int.c file.
     *     --void TMR6_GLOBAL_IRQHandler(void)
     */

    /* add user code begin tmr6_init 2 */

    /* add user code end tmr6_init 2 */
}

/**
 * @brief  init tmr7 function.
 * @param  none
 * @retval none
 */
void wk_tmr7_init(void)
{
    /* add user code begin tmr7_init 0 */

    /* add user code end tmr7_init 0 */

    /* add user code begin tmr7_init 1 */

    /* add user code end tmr7_init 1 */

    /* configure counter settings */
    tmr_base_init(TMR7, 59999, 0);
    tmr_cnt_dir_set(TMR7, TMR_COUNT_UP);
    tmr_period_buffer_enable(TMR7, FALSE);

    /* configure primary mode settings */
    tmr_primary_mode_select(TMR7, TMR_PRIMARY_SEL_RESET);

    tmr_counter_enable(TMR7, TRUE);

    /**
     * Users need to configure TMR7 interrupt functions according to the actual application.
     * 1. Call the below function to enable the corresponding TMR7 interrupt.
     *     --tmr_interrupt_enable(...)
     * 2. Add the user's interrupt handler code into the below function in the at32f403a_407_int.c file.
     *     --void TMR7_GLOBAL_IRQHandler(void)
     */

    /* add user code begin tmr7_init 2 */

    /* add user code end tmr7_init 2 */
}

/**
 * @brief  init usbfs function
 * @param  none
 * @retval none
 */
void wk_usbfs_init(void)
{
    /* add user code begin usbfs_init 0 */

    /* add user code end usbfs_init 0 */
    /* add user code begin usbfs_init 1 */

    /* add user code end usbfs_init 1 */

    crm_usb_interrupt_remapping_set(CRM_USB_INT73_INT74);

    crm_usb_clock_source_select(CRM_USB_CLOCK_SOURCE_HICK);

    /* add user code begin usbfs_init 2 */

    /* add user code end usbfs_init 2 */
}

/**
 * @brief  init acc function
 * @param  none
 * @retval none
 */
void wk_acc_init(void)
{
    /* add user code begin acc_init 0 */

    /* add user code end acc_init 0 */

    /* update the c1\c2\c3 value */
    acc_write_c1(7980);
    acc_write_c2(8000);
    acc_write_c3(8020);

    /* add user code begin acc_init 1 */

    /* add user code end acc_init 1 */

    /* open acc calibration */
    acc_calibration_mode_enable(ACC_CAL_HICKTRIM, TRUE);

    /* add user code begin acc_init 2 */

    /* add user code end acc_init 2 */
}

/**
 * @brief  init can2 function.
 * @param  none
 * @retval none
 */
void wk_can2_init(void)
{
    /* add user code begin can2_init 0 */

    /* add user code end can2_init 0 */

    gpio_init_type       gpio_init_struct;
    can_base_type        can_base_struct;
    can_baudrate_type    can_baudrate_struct;
    can_filter_init_type can_filter_init_struct;

    /* add user code begin can2_init 1 */

    /* add user code end can2_init 1 */

    /*gpio-----------------------------------------------------------------------------*/
    gpio_default_para_init(&gpio_init_struct);

    /* configure the CAN2 TX pin */
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_MUX;
    gpio_init_struct.gpio_pins           = GPIO_PINS_6;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init(GPIOB, &gpio_init_struct);

    /* configure the CAN2 RX pin */
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
    gpio_init_struct.gpio_out_type       = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode           = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pins           = GPIO_PINS_5;
    gpio_init_struct.gpio_pull           = GPIO_PULL_NONE;
    gpio_init(GPIOB, &gpio_init_struct);

    /* GPIO PIN remap */
    gpio_pin_remap_config(CAN2_GMUX_0001, TRUE);

    /*can_base_init--------------------------------------------------------------------*/
    can_default_para_init(&can_base_struct);
    can_base_struct.mode_selection   = CAN_MODE_COMMUNICATE;
    can_base_struct.ttc_enable       = FALSE;
    can_base_struct.aebo_enable      = TRUE;
    can_base_struct.aed_enable       = TRUE;
    can_base_struct.prsf_enable      = FALSE;
    can_base_struct.mdrsel_selection = CAN_DISCARDING_FIRST_RECEIVED;
    can_base_struct.mmssr_selection  = CAN_SENDING_BY_ID;

    can_base_init(CAN2, &can_base_struct);

    /*can_baudrate_setting-------------------------------------------------------------*/
    /*set baudrate = pclk/(baudrate_div *(1 + bts1_size + bts2_size))------------------*/
    can_baudrate_struct.baudrate_div = 10;           /*value: 1~0xFFF*/
    can_baudrate_struct.rsaw_size    = CAN_RSAW_3TQ; /*value: 1~4*/
    can_baudrate_struct.bts1_size    = CAN_BTS1_8TQ; /*value: 1~16*/
    can_baudrate_struct.bts2_size    = CAN_BTS2_3TQ; /*value: 1~8*/
    can_baudrate_set(CAN2, &can_baudrate_struct);

    /*can_filter_0_config--------------------------------------------------------------*/
    can_filter_init_struct.filter_activate_enable = TRUE;
    can_filter_init_struct.filter_number          = 0;
    can_filter_init_struct.filter_fifo            = CAN_FILTER_FIFO0;
    can_filter_init_struct.filter_bit             = CAN_FILTER_16BIT;
    can_filter_init_struct.filter_mode            = CAN_FILTER_MODE_ID_LIST;
    /*Standard identifier + List Mode + Data frame: id/mask 11bit ---------------------*/
    can_filter_init_struct.filter_id_high         = 0x080 << 5;
    can_filter_init_struct.filter_id_low          = 0x000 << 5;
    can_filter_init_struct.filter_mask_high       = 0x600 << 5;
    can_filter_init_struct.filter_mask_low        = 0x77F << 5;

    can_filter_init(CAN2, &can_filter_init_struct);

    /*can_filter_1_config--------------------------------------------------------------*/
    can_filter_init_struct.filter_activate_enable = TRUE;
    can_filter_init_struct.filter_number          = 1;
    can_filter_init_struct.filter_fifo            = CAN_FILTER_FIFO1;
    can_filter_init_struct.filter_bit             = CAN_FILTER_16BIT;
    can_filter_init_struct.filter_mode            = CAN_FILTER_MODE_ID_LIST;
    /*Standard identifier + List Mode + Data frame: id/mask 11bit ---------------------*/
    can_filter_init_struct.filter_id_high         = 0x300 << 5;
    can_filter_init_struct.filter_id_low          = 0x200 << 5;
    can_filter_init_struct.filter_mask_high       = 0x500 << 5;
    can_filter_init_struct.filter_mask_low        = 0x400 << 5;

    can_filter_init(CAN2, &can_filter_init_struct);

    /* add user code begin can2_init 2 */

    /* add user code end can2_init 2 */
}

/**
 * @brief  init crc function.
 * @param  none
 * @retval none
 */
void wk_crc_init(void)
{
    /* add user code begin crc_init 0 */

    /* add user code end crc_init 0 */

    crc_init_data_set(0xFFFF);
    crc_poly_size_set(CRC_POLY_SIZE_16B);
    crc_poly_value_set(0x8005);
    crc_reverse_input_data_set(CRC_REVERSE_INPUT_BY_BYTE);
    crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_DATA);
    crc_data_reset();

    /* add user code begin crc_init 1 */

    /* add user code end crc_init 1 */
}

/**
 * @brief  init adc1 function.
 * @param  none
 * @retval none
 */
void wk_adc1_init(void)
{
    /* add user code begin adc1_init 0 */

    /* add user code end adc1_init 0 */

    gpio_init_type       gpio_init_struct;
    adc_base_config_type adc_base_struct;

    gpio_default_para_init(&gpio_init_struct);

    /* add user code begin adc1_init 1 */

    /* add user code end adc1_init 1 */

    /*gpio--------------------------------------------------------------------*/
    /* configure the IN3 pin */
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pins = ADC_CUR_W_PIN;
    gpio_init(ADC_CUR_W_GPIO_PORT, &gpio_init_struct);

    /* configure the IN4 pin */
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pins = ADC_CUR_V_PIN;
    gpio_init(ADC_CUR_V_GPIO_PORT, &gpio_init_struct);

    /* configure the IN8 pin */
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pins = ADC_CUR_U_PIN;
    gpio_init(ADC_CUR_U_GPIO_PORT, &gpio_init_struct);

    /* configure the IN9 pin */
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pins = ADC_UMDC_PIN;
    gpio_init(ADC_UMDC_GPIO_PORT, &gpio_init_struct);

    crm_adc_clock_div_set(CRM_ADC_DIV_6);

    /*adc_common_settings-------------------------------------------------------------*/
    adc_combine_mode_select(ADC_INDEPENDENT_MODE);

    /*adc_settings--------------------------------------------------------------------*/
    adc_base_default_para_init(&adc_base_struct);
    adc_base_struct.sequence_mode           = TRUE;
    adc_base_struct.repeat_mode             = FALSE;
    adc_base_struct.data_align              = ADC_RIGHT_ALIGNMENT;
    adc_base_struct.ordinary_channel_length = 4;
    adc_base_config(ADC1, &adc_base_struct);

    /* adc_ordinary_conversionmode-------------------------------------------- */
    //  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_9, 1, ADC_SAMPLETIME_7_5);
    //  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_8, 2, ADC_SAMPLETIME_7_5);
    //  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_4, 3, ADC_SAMPLETIME_7_5);
    //  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_3, 4, ADC_SAMPLETIME_7_5);
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_9, 4, ADC_SAMPLETIME_7_5);  // dma buff0
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_8, 1, ADC_SAMPLETIME_7_5);  // u dma buff1
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_4, 2, ADC_SAMPLETIME_7_5);  // v dma buff2
    adc_ordinary_channel_set(ADC1, ADC_CHANNEL_3, 3, ADC_SAMPLETIME_7_5);  // w dma buff3

    adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_TMR1TRGOUT, TRUE);

    adc_ordinary_part_mode_enable(ADC1, FALSE);

    adc_dma_mode_enable(ADC1, TRUE);
    /* add user code begin adc1_init 2 */

    /* add user code end adc1_init 2 */

    adc_enable(ADC1, TRUE);

    /* adc calibration-------------------------------------------------------- */
    adc_calibration_init(ADC1);
    while (adc_calibration_init_status_get(ADC1));
    adc_calibration_start(ADC1);
    while (adc_calibration_status_get(ADC1));

    /* add user code begin adc1_init 3 */

    /* add user code end adc1_init 3 */
}

/**
 * @brief  init adc2 function.
 * @param  none
 * @retval none
 */
void wk_adc2_init(void)
{
    /* add user code begin adc2_init 0 */

    /* add user code end adc2_init 0 */

    gpio_init_type       gpio_init_struct;
    adc_base_config_type adc_base_struct;

    gpio_default_para_init(&gpio_init_struct);

    /* add user code begin adc2_init 1 */

    /* add user code end adc2_init 1 */

    /*gpio--------------------------------------------------------------------*/
    /* configure the IN1 pin */
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pins = GPIO_PINS_1;
    gpio_init(GPIOA, &gpio_init_struct);

    crm_adc_clock_div_set(CRM_ADC_DIV_6);

    /*adc_settings--------------------------------------------------------------------*/
    adc_base_default_para_init(&adc_base_struct);
    adc_base_struct.sequence_mode           = FALSE;
    adc_base_struct.repeat_mode             = FALSE;
    adc_base_struct.data_align              = ADC_RIGHT_ALIGNMENT;
    adc_base_struct.ordinary_channel_length = 1;
    adc_base_config(ADC2, &adc_base_struct);

    /* adc_ordinary_conversionmode-------------------------------------------- */
    adc_ordinary_channel_set(ADC2, ADC_CHANNEL_1, 1, ADC_SAMPLETIME_1_5);

    adc_ordinary_conversion_trigger_set(ADC2, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
    adc_ordinary_part_mode_enable(ADC2, FALSE);

    /* add user code begin adc2_init 2 */

    /* add user code end adc2_init 2 */

    adc_enable(ADC2, TRUE);

    /* adc calibration-------------------------------------------------------- */
    adc_calibration_init(ADC2);
    while (adc_calibration_init_status_get(ADC2));
    adc_calibration_start(ADC2);
    while (adc_calibration_status_get(ADC2));

    /* add user code begin adc2_init 3 */

    /* add user code end adc2_init 3 */
}

/**
 * @brief  init adc3 function.
 * @param  none
 * @retval none
 */
void wk_adc3_init(void)
{
    /* add user code begin adc3_init 0 */

    /* add user code end adc3_init 0 */

    gpio_init_type       gpio_init_struct;
    adc_base_config_type adc_base_struct;

    gpio_default_para_init(&gpio_init_struct);

    /* add user code begin adc3_init 1 */

    /* add user code end adc3_init 1 */

    /*gpio--------------------------------------------------------------------*/
    /* configure the IN2 pin */
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pins = GPIO_PINS_2;
    gpio_init(GPIOA, &gpio_init_struct);

    crm_adc_clock_div_set(CRM_ADC_DIV_6);

    /*adc_settings--------------------------------------------------------------------*/
    adc_base_default_para_init(&adc_base_struct);
    adc_base_struct.sequence_mode           = TRUE;
    adc_base_struct.repeat_mode             = FALSE;
    adc_base_struct.data_align              = ADC_RIGHT_ALIGNMENT;
    adc_base_struct.ordinary_channel_length = 2;
    adc_base_config(ADC3, &adc_base_struct);

    /* adc_ordinary_conversionmode-------------------------------------------- */
    adc_ordinary_channel_set(ADC3, ADC_CHANNEL_2, 1, ADC_SAMPLETIME_13_5);
    adc_ordinary_channel_set(ADC3, ADC_CHANNEL_2, 2, ADC_SAMPLETIME_13_5);

    adc_ordinary_conversion_trigger_set(ADC3, ADC3_ORDINARY_TRIG_SOFTWARE, TRUE);

    adc_ordinary_part_mode_enable(ADC3, FALSE);

    /* add user code begin adc3_init 2 */

    /* add user code end adc3_init 2 */

    adc_enable(ADC3, TRUE);

    /* adc calibration-------------------------------------------------------- */
    adc_calibration_init(ADC3);
    while (adc_calibration_init_status_get(ADC3));
    adc_calibration_start(ADC3);
    while (adc_calibration_status_get(ADC3));

    /* add user code begin adc3_init 3 */

    /* add user code end adc3_init 3 */
}

/**
 * @brief  init dma1 channel1 for "adc1"
 * @param  none
 * @retval none
 */
void wk_dma1_channel1_init(void)
{
    /* add user code begin dma1_channel1 0 */

    /* add user code end dma1_channel1 0 */

    dma_init_type dma_init_struct;

    dma_reset(DMA1_CHANNEL1);
    dma_default_para_init(&dma_init_struct);
    dma_init_struct.direction             = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init_struct.memory_data_width     = DMA_MEMORY_DATA_WIDTH_HALFWORD;
    dma_init_struct.memory_inc_enable     = TRUE;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority              = DMA_PRIORITY_LOW;
    dma_init_struct.loop_mode_enable      = TRUE;
    dma_init(DMA1_CHANNEL1, &dma_init_struct);

    /* flexible function enable */
    dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_ADC1);
    /**
     * Users need to configure DMA1 interrupt functions according to the actual application.
     * 1. Call the below function to enable the corresponding DMA1 interrupt.
     *     --dma_interrupt_enable(...)
     * 2. Add the user's interrupt handler code into the below function in the at32f403a_407_int.c file.
     *     --void DMA1_Channel1_IRQHandler(void)
     */
    /* add user code begin dma1_channel1 1 */

    /* add user code end dma1_channel1 1 */
}

/**
 * @brief  init dma1 channel2 for "usart3_rx"
 * @param  none
 * @retval none
 */
void wk_dma1_channel2_init(void)
{
    /* add user code begin dma1_channel2 0 */

    /* add user code end dma1_channel2 0 */

    dma_init_type dma_init_struct;

    dma_reset(DMA1_CHANNEL2);
    dma_default_para_init(&dma_init_struct);
    dma_init_struct.direction             = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init_struct.memory_data_width     = DMA_MEMORY_DATA_WIDTH_BYTE;
    dma_init_struct.memory_inc_enable     = TRUE;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority              = DMA_PRIORITY_LOW;
    dma_init_struct.loop_mode_enable      = FALSE;
    dma_init(DMA1_CHANNEL2, &dma_init_struct);

    /* flexible function enable */
    dma_flexible_config(DMA1, FLEX_CHANNEL2, DMA_FLEXIBLE_UART3_RX);
    /* add user code begin dma1_channel2 1 */

    /* add user code end dma1_channel2 1 */
}

/**
 * @brief  init dma1 channel3 for "usart3_tx"
 * @param  none
 * @retval none
 */
void wk_dma1_channel3_init(void)
{
    /* add user code begin dma1_channel3 0 */

    /* add user code end dma1_channel3 0 */

    dma_init_type dma_init_struct;

    dma_reset(DMA1_CHANNEL3);
    dma_default_para_init(&dma_init_struct);
    dma_init_struct.direction             = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_data_width     = DMA_MEMORY_DATA_WIDTH_BYTE;
    dma_init_struct.memory_inc_enable     = TRUE;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority              = DMA_PRIORITY_LOW;
    dma_init_struct.loop_mode_enable      = FALSE;
    dma_init(DMA1_CHANNEL3, &dma_init_struct);

    /* flexible function enable */
    dma_flexible_config(DMA1, FLEX_CHANNEL3, DMA_FLEXIBLE_UART3_TX);
    /**
     * Users need to configure DMA1 interrupt functions according to the actual application.
     * 1. Call the below function to enable the corresponding DMA1 interrupt.
     *     --dma_interrupt_enable(...)
     * 2. Add the user's interrupt handler code into the below function in the at32f403a_407_int.c file.
     *     --void DMA1_Channel3_IRQHandler(void)
     */
    /* add user code begin dma1_channel3 1 */

    /* add user code end dma1_channel3 1 */
}

/**
 * @brief  config dma channel transfer parameter
 * @param  dmax_channely: DMAx_CHANNELy
 * @param  peripheral_base_addr: peripheral address.
 * @param  memory_base_addr: memory address.
 * @param  buffer_size: buffer size.
 * @retval none
 */
void wk_dma_channel_config(dma_channel_type* dmax_channely, uint32_t peripheral_base_addr, uint32_t memory_base_addr, uint16_t buffer_size)
{
    /* add user code begin dma_channel_config 0 */

    /* add user code end dma_channel_config 0 */

    dmax_channely->dtcnt = buffer_size;
    dmax_channely->paddr = peripheral_base_addr;
    dmax_channely->maddr = memory_base_addr;

    /* add user code begin dma_channel_config 1 */

    /* add user code end dma_channel_config 1 */
}

/* add user code begin 1 */

/* add user code end 1 */
