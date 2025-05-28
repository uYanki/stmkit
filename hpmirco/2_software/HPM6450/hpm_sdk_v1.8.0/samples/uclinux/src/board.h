/*
 * Copyright (c) 2021-2024 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

#ifndef _HPM_BOARD_H
#define _HPM_BOARD_H

#include <stdio.h>
#include "hpm_common.h"
#include "hpm_soc.h"
#include "hpm_soc_feature.h"
#include "hpm_clock_drv.h"

#if !defined(CONFIG_NDEBUG_CONSOLE) || !CONFIG_NDEBUG_CONSOLE
#include "hpm_debug_console.h"
#endif

#define BOARD_NAME          "hpm6450evkmini"
#define BOARD_UF2_SIGNATURE (0x0A4D5048UL)

#define SEC_CORE_IMG_START ILM_LOCAL_BASE

#ifndef BOARD_RUNNING_CORE
#define BOARD_RUNNING_CORE HPM_CORE0
#endif

#if !defined(CONFIG_NDEBUG_CONSOLE) || !CONFIG_NDEBUG_CONSOLE
#ifndef BOARD_CONSOLE_TYPE
#define BOARD_CONSOLE_TYPE CONSOLE_TYPE_UART
#endif

#if BOARD_CONSOLE_TYPE == CONSOLE_TYPE_UART
#ifndef BOARD_CONSOLE_UART_BASE
#if BOARD_RUNNING_CORE == HPM_CORE0
#define BOARD_CONSOLE_UART_BASE       HPM_UART0
#define BOARD_CONSOLE_UART_CLK_NAME   clock_uart0
#define BOARD_CONSOLE_UART_IRQ        IRQn_UART0
#define BOARD_CONSOLE_UART_TX_DMA_REQ HPM_DMA_SRC_UART0_TX
#define BOARD_CONSOLE_UART_RX_DMA_REQ HPM_DMA_SRC_UART0_RX
#else
#define BOARD_CONSOLE_UART_BASE       HPM_UART13
#define BOARD_CONSOLE_UART_CLK_NAME   clock_uart13
#define BOARD_CONSOLE_UART_IRQ        IRQn_UART13
#define BOARD_CONSOLE_UART_TX_DMA_REQ HPM_DMA_SRC_UART13_TX
#define BOARD_CONSOLE_UART_RX_DMA_REQ HPM_DMA_SRC_UART13_RX
#endif
#endif
#define BOARD_CONSOLE_UART_BAUDRATE (115200UL)
#endif
#endif

/* sdram section */
#define BOARD_SDRAM_ADDRESS          (0x40000000UL)
#define BOARD_SDRAM_SIZE             (16 * SIZE_1MB)
#define BOARD_SDRAM_CS               FEMC_SDRAM_CS0
#define BOARD_SDRAM_PORT_SIZE        FEMC_SDRAM_PORT_SIZE_16_BITS
#define BOARD_SDRAM_COLUMN_ADDR_BITS FEMC_SDRAM_COLUMN_ADDR_9_BITS
#define BOARD_SDRAM_REFRESH_COUNT    (4096UL)
#define BOARD_SDRAM_REFRESH_IN_MS    (64UL)

/* Flash section */
#define BOARD_APP_XPI_NOR_XPI_BASE     (HPM_XPI0)
#define BOARD_APP_XPI_NOR_CFG_OPT_HDR  (0xfcf90002U)
#define BOARD_APP_XPI_NOR_CFG_OPT_OPT0 (0x00000007U)
#define BOARD_APP_XPI_NOR_CFG_OPT_OPT1 (0x0000000EU)

#define BOARD_FLASH_BASE_ADDRESS (0x80000000UL)
#define BOARD_FLASH_SIZE         (8 << 20)

/* SDXC section */
#define BOARD_APP_SDCARD_SDXC_BASE                 (HPM_SDXC0)
#define BOARD_APP_SDCARD_SDXC_IRQ                  IRQn_SDXC0
#define BOARD_APP_SDCARD_SUPPORT_3V3               (1)
#define BOARD_APP_SDCARD_SUPPORT_1V8               (0)
#define BOARD_APP_SDCARD_SUPPORT_4BIT              (1)
#define BOARD_APP_SDCARD_SUPPORT_CARD_DETECTION    (0)
#define BOARD_APP_SDCARD_SUPPORT_POWER_SWITCH      (0)
#define BOARD_APP_SDCARD_SUPPORT_VOLTAGE_SWITCH    (0)
#define BOARD_APP_SDCARD_CARD_DETECTION_USING_GPIO (0)
#if defined(BOARD_APP_SDCARD_CARD_DETECTION_USING_GPIO) && (BOARD_APP_SDCARD_CARD_DETECTION_USING_GPIO == 1)
#define BOARD_APP_SDCARD_CARD_DETECTION_PIN        IOC_PAD_PE31
#endif

#define BOARD_CPU_FREQ (648000000UL)

#ifndef BOARD_SHOW_CLOCK
#define BOARD_SHOW_CLOCK 0
#endif
#ifndef BOARD_SHOW_BANNER
#define BOARD_SHOW_BANNER 0
#endif

#ifndef BOARD_RUNNING_CORE
#define BOARD_RUNNING_CORE 0
#endif

#if defined(__cplusplus)
extern "C" {
#endif /* __cplusplus */

typedef void (*board_timer_cb)(void);

void board_init(void);
void board_init_console(void);

uint32_t board_init_femc_clock(void);

void board_init_sdram_pins(void);
void board_init_gpio_pins(void);

void board_init_clock(void);

/* Initialize the UART clock */
uint32_t board_init_uart_clock(UART_Type *ptr);

uint32_t board_sd_configure_clock(SDXC_Type *ptr, uint32_t freq, bool need_inverse);
void board_sd_switch_pins_to_1v8(SDXC_Type *ptr);

void init_sdxc_cd_pin(SDXC_Type* ptr, bool as_gpio);
void init_sdxc_cmd_pin(SDXC_Type* ptr, bool open_drain, bool is_1v8);
void init_sdxc_clk_data_pins(SDXC_Type* ptr, uint32_t width, bool is_1v8);

/*
 * @brief Initialize PMP and PMA for but not limited to the following purposes:
 *      -- non-cacheable memory initialization
 */
void board_init_pmp(void);

void board_delay_ms(uint32_t ms);
void board_delay_us(uint32_t us);

/*
 * Keep mchtmr clock on low power mode
 */
void board_ungate_mchtmr_at_lp_mode(void);

#if defined(__cplusplus)
}
#endif /* __cplusplus */
#endif /* _HPM_BOARD_H */
