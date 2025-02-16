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
#include "at32f413_wk_config.h"
#include "wk_system.h"

/* private includes ----------------------------------------------------------*/
/* add user code begin private includes */

#include "at32f413_dma.h"

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
__IO u16 au16AdcSampBuff[2] = {0};

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

    /* init dma1 channel4 */
    wk_dma1_channel4_init();

    /* init dma1 channel5 */
    wk_dma1_channel5_init();
    /* init usart2 function. */
    wk_usart2_init();

    /* init spi2 function. */
    wk_spi2_init();

    /* init i2c1 function. */
    wk_i2c1_init();

    /* init i2c2 function. */
    wk_i2c2_init();

    /* init adc1 function. */
    wk_adc1_init();

    /* init exint function. */
    wk_exint_config();

    /* init tmr1 function. */
    wk_tmr1_init();

    /* init tmr2 function. */
    wk_tmr2_init();

    /* init tmr10 function. */
    wk_tmr10_init();

    /* init tmr11 function. */
    wk_tmr11_init();

    /* init can1 function. */
    wk_can1_init();

    /* init crc function. */
    wk_crc_init();

    /* init gpio function. */
    wk_gpio_config();

    /* add user code begin 2 */

#if 0

    while (1)
    {
		u16 b = 20;

    EEPROM_WriteBlock(0, &b, 1);
    b = 0;

    EEPROM_ReadBlock(0, &b, 1);
    }
		
#endif

    tmr_counter_enable(TIM_SYSTICK_BASE, FALSE);
    tmr_interrupt_enable(TIM_SYSTICK_BASE, TMR_OVF_INT, TRUE);
    tmr_counter_enable(TIM_SYSTICK_BASE, TRUE);

    SchedCreat();
    SchedInit();

    // 15180

    // tmr_interrupt_enable(TIM_SCANA_BASE, TMR_OVF_INT, TRUE);
    tmr_interrupt_enable(TIM_SCANB_BASE, TMR_OVF_INT, TRUE);

    tmr_channel_enable(TIM_SCANA_BASE, TMR_SELECT_CHANNEL_1, TRUE);
    tmr_channel_enable(TIM_SCANA_BASE, TMR_SELECT_CHANNEL_2, TRUE);
    tmr_channel_enable(TIM_SCANA_BASE, TMR_SELECT_CHANNEL_3, TRUE);
    tmr_channel_enable(TIM_SCANA_BASE, TMR_SELECT_CHANNEL_4, TRUE);
    // tmr_channel_enable(TIM_SCANA_BASE, TMR_SELECT_CHANNEL_4, FALSE);

    // after adc caili
    wk_dma_channel_config(DMA1_CHANNEL1,
                          (uint32_t)&ADC1->odt,
                          (uint32_t)&au16AdcSampBuff[0],
                          ARRAY_SIZE(au16AdcSampBuff));
    dma_channel_enable(DMA1_CHANNEL1, TRUE);

    dma_interrupt_enable(DMA1_CHANNEL1, DMA_FDT_INT, TRUE);  // adc dma

#if 1  // debug only

    D.u16UmdcHwCoeff = 363;

    P(0).eAppSel     = 0;
    P(0).s32EncTurns = 0;

    P(0).eLoopRspModeSel = LOOP_RSP_MODE_SPD;
    P(0).s64LoopRspStep  = 1000;

    P(0).eCtrlMode = 0;

    D.u16DrvCurRate = 100;

    D.u16ScopeSampSrc1 = SCOPE_SAMP_OBJ_CUR_A_PU_FB;
    D.u16ScopeSampSrc2 = SCOPE_SAMP_OBJ_CUR_B_PU_FB;
    D.u16ScopeSampSrc3 = SCOPE_SAMP_OBJ_CUR_C_PU_FB;  // SCOPE_SAMP_OBJ_DRV_POS_REF;
    D.u16ScopeSampSrc4 = 18;                          // SCOPE_SAMP_OBJ_DRV_POS_FB;

    // D.u16ScopeTrigSrc1 = SCOPE_TRIG_OBJ_PWM_ON;

    P(0).s16SpdDigRef = 500;
    P(0).u16TrqLimFwd = 500;

#endif
    /* add user code end 2 */

    while (1)
    {
        /* add user code begin 3 */

        SchedCycle();

#if 0
        PeriodicTask(UNIT_MS, {
            printf("%d,%d,%d\n", P(0).s16IaFbPu,P(0).s16IbFbPu,P(0).s16IcFbPu);
        });
#endif
        /* add user code end 3 */
    }
}

/* add user code begin 4 */

#if 0

#include "i2c_application.h"

#define EEPROM_DEV_ADDR 0x20

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
                    i2c_memory_read_dma(EEPROM_I2C_BASE, I2C_MEM_ADDR_WIDIH_16, EEPROM_DEV_ADDR, pRequest->u16MemAddr, pRequest->pu16BufAddr, pRequest->u16BufSize, 0xFF);
                    eFsm = EEPROM_READ_BUSY;

                    break;
                }
                case EEPROM_WEITE_MEM:
                {
                    i2c_memory_write_dma(EEPROM_I2C_BASE, I2C_MEM_ADDR_WIDIH_16, EEPROM_DEV_ADDR, pRequest->u16MemAddr, pRequest->pu16BufAddr, pRequest->u16BufSize, 0xFF);
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

/* add user code end 4 */
