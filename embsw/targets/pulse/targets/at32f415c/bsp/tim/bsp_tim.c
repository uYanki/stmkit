#include "bsp_tim.h"
#include "paratbl.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "bsp_tim"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

#define TIM_CLK_FREQ_HZ 144000000

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static u32 su32SysTickMs = 0;
static u32 su32PulOutCnt = 0;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

//
// TIM
//

void IncTickMs(void)
{
    ++su32SysTickMs;
}

u16 GetTick100ns(void)
{
    return tmr_counter_value_get(TIM_SYSTICK_BASE) * 10 / 36;
}

u32 GetTickMs(void)
{
    return su32SysTickMs;
}

//
// External pulse counter
//

void PulInConfig(u16 u16Mode)
{
    switch (u16Mode)
    {
#if 0

        case 0:  // PD
        {
            break;
        }

#endif

        case 1:  // AB (4倍频)
        {
            //
            // gpio
            //

            gpio_init_type gpio_init_struct = {
                .gpio_pins           = GPIO_PINS_6 | GPIO_PINS_7,
                .gpio_out_type       = GPIO_OUTPUT_PUSH_PULL,
                .gpio_pull           = GPIO_PULL_NONE,
                .gpio_mode           = GPIO_MODE_INPUT,
                .gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER,
            };

            gpio_init(GPIOA, &gpio_init_struct);

            //
            // tmr
            //

            tmr_base_init(PULIN_TMR_BASE, 65535, 0);
            tmr_cnt_dir_set(PULIN_TMR_BASE, TMR_COUNT_UP);
            tmr_clock_source_div_set(PULIN_TMR_BASE, TMR_CLOCK_DIV1);

            tmr_input_channel_filter_set(PULIN_TMR_BASE, TMR_SELECT_CHANNEL_1, 5);
            tmr_input_channel_filter_set(PULIN_TMR_BASE, TMR_SELECT_CHANNEL_2, 5);
            tmr_encoder_mode_config(PULIN_TMR_BASE, TMR_ENCODER_MODE_C, TMR_INPUT_RISING_EDGE, TMR_INPUT_RISING_EDGE);
            tmr_cnt_dir_set(PULIN_TMR_BASE, TMR_COUNT_UP);

            break;
        }

#if 0

        case 3:  // UVW
        {
            break;
        }

#endif
    }
}

void PulInEnable(void)
{
    tmr_counter_enable(PULIN_TMR_BASE, TRUE);
}

void PulInDisable(void)
{
    tmr_counter_enable(PULIN_TMR_BASE, FALSE);
}

void PulInRstCnt(void)
{
    tmr_counter_value_set(PULIN_TMR_BASE, 0);
}

s32 PulInGetCnt(void)
{
    return (s16)tmr_counter_value_get(PULIN_TMR_BASE);
}

//
// Generate a specified number of pulses
// 搭配 PulseView 中的 PWM 和 Counter 来测试 !!!
//

void PulOutUpdate(void)  // call in irq (TMR_OVF_INT)
{
    if (su32PulOutCnt > 0)
    {
        if (su32PulOutCnt <= 256)
        {
            /* dsiable irq */
            tmr_interrupt_enable(PULOUT_TMR_BASE, TMR_OVF_INT, FALSE);

            /* set the repetition counter value */
            tmr_repetition_counter_set(PULOUT_TMR_BASE, su32PulOutCnt - 1);

            su32PulOutCnt = 0;
        }
        else
        {
            /* set the repetition counter value */
            tmr_repetition_counter_set(PULOUT_TMR_BASE, 256 - 1);

            su32PulOutCnt -= 256;
        }

        /* update repetition counter */
        PULOUT_TMR_BASE->swevt_bit.ovfswtr = TRUE;

        /* tmr counter enable */
        tmr_counter_enable(PULOUT_TMR_BASE, TRUE);
    }
}

void PulOutEnable(void)
{
    if (su32PulOutCnt > 256)
    {
        /* enable irq */
        tmr_interrupt_enable(PULOUT_TMR_BASE, TMR_OVF_INT, TRUE);
    }
    else
    {
        su32PulOutCnt = 0;
    }

    tmr_counter_value_set(PULOUT_TMR_BASE, 0);
    tmr_counter_enable(PULOUT_TMR_BASE, TRUE);
}

void PulOutDisable(void)
{
    tmr_counter_enable(PULOUT_TMR_BASE, FALSE);

    // 清除计数, 中断发波后，将输出置为空闲电平
    tmr_counter_value_set(PULOUT_TMR_BASE, 0);
}

bool PulOutIsOver(void)
{
    return (su32PulOutCnt == 0) && (PULOUT_TMR_BASE->ctrl1_bit.tmren == 0);
}

/**
 * @brief
 * @param[in]  u32Freq unit: 0.1hz
 * @param[out] pu16Clkdiv
 * @param[out] pu16Reload
 */
void GetTimParaByFreq(u32 u32Freq, u16* pu16Clkdiv, u16* pu16Reload)
{
    u32 u32Mid = 10 * TIM_CLK_FREQ_HZ / u32Freq;  // clkdiv x relaod
    u32 u32Err = 1;

    u32 u32Ref = u32Mid;

    u32  u32Clkdiv, u32Reload;
    bool bSymbolOpt = false;

    while (1)
    {
        //
        // 1<PSC<=65535
        // 0<ARR<=65535
        // TIMCLK=FREQ*(PSC+1)*(ARR+1)
        //

        // 0xFFFFFFFF / 0x10000 = 0xFFFF < 65536

        for (u32Clkdiv = (u32Ref / 0x10000) + 1; u32Clkdiv <= 0x10000; u32Clkdiv++)
        {
            if ((u32Ref % u32Clkdiv) == 0)
            {
                u32Reload = u32Ref / u32Clkdiv;

                *pu16Clkdiv = u32Clkdiv - 1;
                *pu16Reload = u32Reload - 1;

                return;
            }
        }

        //
        // 调整偏差, 直到找出可被整除的数值
        //

        if ((u32Mid <= (U32_MAX - u32Err)) && (bSymbolOpt == false))
        {
            u32Ref     = u32Mid + u32Err;  // 增大
            bSymbolOpt = true;
        }
        else if ((u32Mid >= u32Err) && (bSymbolOpt == true))
        {
            u32Ref     = u32Mid - u32Err;  // 减小
            bSymbolOpt = false;
            u32Err++;
        }
    }
}

void PulOutConfig(u32 u32Cnt, u32 u32Freq, u16 u16Duty)
{
    //
    // gpio
    //

    gpio_init_type gpio_init_struct = {
        .gpio_pins           = GPIO_PINS_8,
        .gpio_out_type       = GPIO_OUTPUT_PUSH_PULL,
        .gpio_pull           = GPIO_PULL_NONE,
        .gpio_mode           = GPIO_MODE_MUX,
        .gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER,
    };

    gpio_init(GPIOA, &gpio_init_struct);

    //
    // tmr
    //

    u16 u16Reload;
    u16 u16Clkdiv;

    /* tmr configuration generate pwm signal*/
    /* compute the value to be set in arr regiter to generate signal frequency */

    GetTimParaByFreq(u32Freq, &u16Clkdiv, &u16Reload);

    /* compute c1dt value to generate a duty cycle */
    u16 channel_pulse = (u16)((u32)u16Duty * (u32)(u16Reload) / 1000);

    /* tmr base configuration */

    u8 u8RepCnt;

    if (u32Cnt > 0)
    {
        u8RepCnt = MIN(u32Cnt, 256) - 1;
    }
    else
    {
        u8RepCnt = 0;
    }

    tmr_interrupt_enable(PULOUT_TMR_BASE, TMR_OVF_INT, FALSE);
    tmr_repetition_counter_set(PULOUT_TMR_BASE, u8RepCnt);
    tmr_base_init(PULOUT_TMR_BASE, u16Reload, u16Clkdiv);
    tmr_cnt_dir_set(PULOUT_TMR_BASE, TMR_COUNT_UP);
    tmr_clock_source_div_set(PULOUT_TMR_BASE, TMR_CLOCK_DIV1);

    /* channel configuration in output mode */
    tmr_output_config_type tmr_output_struct = {
        .oc_mode         = TMR_OUTPUT_CONTROL_PWM_MODE_A,
        .oc_output_state = TRUE,
        .oc_polarity     = TMR_OUTPUT_ACTIVE_HIGH,
        .oc_idle_state   = FALSE,
    };

    tmr_output_channel_config(PULOUT_TMR_BASE, PULOUT_TMR_CHAN, &tmr_output_struct);
    tmr_channel_value_set(PULOUT_TMR_BASE, PULOUT_TMR_CHAN, channel_pulse);

    su32PulOutCnt = u32Cnt;

    if (su32PulOutCnt > 0)
    {
        /* one cycle mode selection */
        tmr_one_cycle_mode_enable(PULOUT_TMR_BASE, TRUE);
    }
    else
    {
        tmr_one_cycle_mode_enable(PULOUT_TMR_BASE, FALSE);
    }

    /* ADVTMR output enable */
    tmr_output_enable(PULOUT_TMR_BASE, TRUE);
}

//
// Flexible Pulse output
//

void FlexPulOutConfig(u32 u32Freq, u16* pu16DataSrc, u16 u16DataSize)
{
    u16 u16Reload;
    u16 u16Clkdiv;

    dma_channel_enable(FLEXPUL_DMA_CH, FALSE);
    wk_dma_channel_config(FLEXPUL_DMA_CH,
                          (uint32_t)&FLEXPUL_GPIO_BASE->odt,
                          (uint32_t)pu16DataSrc,
                          u16DataSize);
    dma_channel_enable(FLEXPUL_DMA_CH, TRUE);

    GetTimParaByFreq(u32Freq, &u16Clkdiv, &u16Reload);
    tmr_base_init(FLEXPUL_TMR_BASE, u16Reload, u16Clkdiv);
}

void FlexPulOutEnable(void)
{
    tmr_counter_enable(FLEXPUL_TMR_BASE, TRUE);
    tmr_counter_value_set(FLEXPUL_TMR_BASE, 0);
}

void FlexPulOutDisable(void)
{
    tmr_counter_enable(FLEXPUL_TMR_BASE, FALSE);
    tmr_counter_value_set(FLEXPUL_TMR_BASE, 0);
    gpio_port_write(FLEXPUL_GPIO_BASE, 0);
}
