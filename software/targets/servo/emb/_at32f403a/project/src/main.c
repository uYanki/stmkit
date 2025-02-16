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
#include "at32f403a_407_wk_config.h"
#include "wk_system.h"

/* private includes ----------------------------------------------------------*/
/* add user code begin private includes */
#include "bsp.h"
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

/* add user code end private variables */

/* private function prototypes --------------------------------------------*/
/* add user code begin function prototypes */

/* add user code end function prototypes */

/* private user code ---------------------------------------------------------*/
/* add user code begin 0 */
__IO u16 au16AdcSampBuff[4] = {0};

#include "at32f403a_407_dma.h"

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

    /* init dma1 channel1 */
    wk_dma1_channel1_init();

    /* init dma1 channel2 */
    wk_dma1_channel2_init();

    /* init dma1 channel3 */
    wk_dma1_channel3_init();

    /* init usart3 function. */
    wk_usart3_init();

    /* init spi1 function. */
    wk_spi1_init();

    /* init adc2 function. */
    wk_adc2_init();

    /* init adc1 function. */
    wk_adc1_init();

    /* init adc3 function. */
    wk_adc3_init();

    /* init tmr1 function. */
    wk_tmr1_init();

    /* init tmr2 function. */
    wk_tmr2_init();

    /* init tmr6 function. */
    wk_tmr6_init();

    /* init tmr7 function. */
    wk_tmr7_init();

    /* init acc function. */
    wk_acc_init();

    /* init usbfs function. */
    // wk_usbfs_init();

    /* init can2 function. */
    wk_can2_init();

    /* init crc function. */
    wk_crc_init();

    /* init gpio function. */
    wk_gpio_config();

    /* add user code begin 2 */

    // ADC 转换时间 = 采样时间 + 12.5 (unit: ADC cycle)
    // (7.5 + 12.5) * (1 /20MHz) = 1us
    // 4通道 => 4us
    // ADC 转换序列触发时刻 = (1 - 4/62.5) * PWM_PERIOD = 0.936 * 15000 = 14040
    // 但是下桥采样就不提前采了，噪声有点明显

    tmr_counter_enable(TIM_BASE, FALSE);
    tmr_interrupt_enable(TIM_BASE, TMR_OVF_INT, TRUE);
    tmr_counter_enable(TIM_BASE, TRUE);

    SchedCreat();
    SchedInit();

    tmr_interrupt_enable(TIM_SCAN_A, TMR_OVF_INT, TRUE);
    tmr_interrupt_enable(TIM_SCAN_B, TMR_OVF_INT, TRUE);

    tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_4, TRUE);
    // tmr_channel_enable(TIM_SCAN_A, TMR_SELECT_CHANNEL_4, FALSE);

    // after adc caili
    wk_dma_channel_config(DMA1_CHANNEL1,
                          (uint32_t)&ADC1->odt,
                          (uint32_t)&au16AdcSampBuff[0],
                          ARRAY_SIZE(au16AdcSampBuff));
    dma_channel_enable(DMA1_CHANNEL1, TRUE);

    dma_interrupt_enable(DMA1_CHANNEL1, DMA_FDT_INT, TRUE);  // adc dma

#if 1  // debug only

    P(0).eAppSel     = 0;
    P(0).s32EncTurns = 0;

    P(0).eLoopRspModeSel = LOOP_RSP_MODE_SPD;
    P(0).s64LoopRspStep  = 1000;

    P(0).eCtrlMode = 1;
		
		
    D.u16ScopeSampSrc1 = 15;
    D.u16ScopeSampSrc2 = 16;
    D.u16ScopeSampSrc3 = 17;  // SCOPE_SAMP_OBJ_DRV_POS_REF;
    D.u16ScopeSampSrc4 = 18;  // SCOPE_SAMP_OBJ_DRV_POS_FB;
		
		D.u16ScopeTrigSrc1 = SCOPE_TRIG_OBJ_PWM_ON;

//    D.u16ScopeChAddr01 = 353;
//    D.u16ScopeChAddr02 = 355;
//    D.u16ScopeChAddr03 = 365;
//    D.u16ScopeChAddr04 = 367;

    //    D.u16ScopeChAddr01 = 357;
    //    D.u16ScopeChAddr02 = 358;
    //    D.u16ScopeChAddr03 = 358;

    P(0).s16SpdDigRef = 500;
    P(0).u16TrqLimFwd = 1000;

#endif

    /* add user code end 2 */

    while (1)
    {
        /* add user code begin 3 */

        SchedCycle();

#if 0

    // 定时器频率计数
    PeriodicTask(UNIT_S, {
            D._Resv250 = D._Resv249;
            D._Resv249 = 0;
        });

#if 1
        static u8 a = 0;
        PeriodicTask(UNIT_S, { a++; });

        if (a > 3)
        {
            P(0).u32CommCmd = 1;
        }

#endif

        PeriodicTask(UNIT_MS, {
            // static u8 u8CanMsg[] = {0x22, 0x66, 0x11};
            //   CanTxMsg(0x12223 | CAN_ID_STD | CAN_FF_DATA, u8CanMsg, ARRAY_SIZE(u8CanMsg));
            //   u8CanMsg[0]++;
            // printf("hello\n");

            //  printf("%d,%d,%d,%d\n", a[0], a[1], a[2], a[3]);

 
            // printf("%d,%d,%d,%d\n",  au16AdcSampBuff[0 ],-au16AdcSampBuff[1 + 1]- au16AdcSampBuff[2 + 1], au16AdcSampBuff[1 + 1], au16AdcSampBuff[2 + 1]);
        });

#endif
        /* add user code end 3 */
    }
}

/* add user code begin 4 */
void __aeabi_assert(const char* a, const char* b, int c) {};

/* add user code end 4 */
