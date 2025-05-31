/*
 * Copyright (c) 2021-2024 HPMicro
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

#include "board.h"
#include "hpm_uart_drv.h"
#include "hpm_gpio_drv.h"
#include "hpm_femc_drv.h"
#include "hpm_pmp_drv.h"
#include "hpm_clock_drv.h"
#include "hpm_sysctl_drv.h"
#include "hpm_sdxc_drv.h"
#include "hpm_sdxc_soc_drv.h"
#include "hpm_pllctl_drv.h"
#include "hpm_pcfg_drv.h"

/**
 * @brief FLASH configuration option definitions:
 * option[0]:
 *    [31:16] 0xfcf9 - FLASH configuration option tag
 *    [15:4]  0 - Reserved
 *    [3:0]   option words (exclude option[0])
 * option[1]:
 *    [31:28] Flash probe type
 *      0 - SFDP SDR / 1 - SFDP DDR
 *      2 - 1-4-4 Read (0xEB, 24-bit address) / 3 - 1-2-2 Read(0xBB, 24-bit address)
 *      4 - HyperFLASH 1.8V / 5 - HyperFLASH 3V
 *      6 - OctaBus DDR (SPI -> OPI DDR)
 *      8 - Xccela DDR (SPI -> OPI DDR)
 *      10 - EcoXiP DDR (SPI -> OPI DDR)
 *    [27:24] Command Pads after Power-on Reset
 *      0 - SPI / 1 - DPI / 2 - QPI / 3 - OPI
 *    [23:20] Command Pads after Configuring FLASH
 *      0 - SPI / 1 - DPI / 2 - QPI / 3 - OPI
 *    [19:16] Quad Enable Sequence (for the device support SFDP 1.0 only)
 *      0 - Not needed
 *      1 - QE bit is at bit 6 in Status Register 1
 *      2 - QE bit is at bit1 in Status Register 2
 *      3 - QE bit is at bit7 in Status Register 2
 *      4 - QE bit is at bit1 in Status Register 2 and should be programmed by 0x31
 *    [15:8] Dummy cycles
 *      0 - Auto-probed / detected / default value
 *      Others - User specified value, for DDR read, the dummy cycles should be 2 * cycles on FLASH datasheet
 *    [7:4] Misc.
 *      0 - Not used
 *      1 - SPI mode
 *      2 - Internal loopback
 *      3 - External DQS
 *    [3:0] Frequency option
 *      1 - 30MHz / 2 - 50MHz / 3 - 66MHz / 4 - 80MHz / 5 - 100MHz / 6 - 120MHz / 7 - 133MHz / 8 - 166MHz
 *
 * option[2] (Effective only if the bit[3:0] in option[0] > 1)
 *    [31:20]  Reserved
 *    [19:16] IO voltage
 *      0 - 3V / 1 - 1.8V
 *    [15:12] Pin group
 *      0 - 1st group / 1 - 2nd group
 *    [11:8] Connection selection
 *      0 - CA_CS0 / 1 - CB_CS0 / 2 - CA_CS0 + CB_CS0 (Two FLASH connected to CA and CB respectively)
 *    [7:0] Drive Strength
 *      0 - Default value
 * option[3] (Effective only if the bit[3:0] in option[0] > 2, required only for the QSPI NOR FLASH that not supports
 *              JESD216)
 *    [31:16] reserved
 *    [15:12] Sector Erase Command Option, not required here
 *    [11:8]  Sector Size Option, not required here
 *    [7:0] Flash Size Option
 *      0 - 4MB / 1 - 8MB / 2 - 16MB
 */
#if defined(FLASH_XIP) && FLASH_XIP
__attribute__((section(".nor_cfg_option"), used)) const uint32_t option[4] = {0xfcf90002, 0x00000007, 0x100, 0x0};
#endif

#if defined(FLASH_UF2) && FLASH_UF2
ATTR_PLACE_AT(".uf2_signature")
__attribute__((used)) const uint32_t uf2_signature = BOARD_UF2_SIGNATURE;
#endif

#include "board.h"

void init_uart_pins(UART_Type* ptr)
{
    if (ptr == HPM_UART0)
    {
        HPM_IOC->PAD[IOC_PAD_PY07].FUNC_CTL  = IOC_PY07_FUNC_CTL_UART0_RXD;
        HPM_IOC->PAD[IOC_PAD_PY06].FUNC_CTL  = IOC_PY06_FUNC_CTL_UART0_TXD;
        /* PY port IO needs to configure PIOC as well */
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_SOC_PY_07;
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_SOC_PY_06;
    }
    else if (ptr == HPM_UART6)
    {
        HPM_IOC->PAD[IOC_PAD_PE27].FUNC_CTL = IOC_PE27_FUNC_CTL_UART6_RXD;
        HPM_IOC->PAD[IOC_PAD_PE28].FUNC_CTL = IOC_PE28_FUNC_CTL_UART6_TXD;
    }
    else if (ptr == HPM_UART7)
    {
        HPM_IOC->PAD[IOC_PAD_PC02].FUNC_CTL = IOC_PC02_FUNC_CTL_UART7_RXD;
        HPM_IOC->PAD[IOC_PAD_PC03].FUNC_CTL = IOC_PC03_FUNC_CTL_UART7_TXD;
    }
    else if (ptr == HPM_UART13)
    {
        HPM_IOC->PAD[IOC_PAD_PZ08].FUNC_CTL  = IOC_PZ08_FUNC_CTL_UART13_RXD;
        HPM_IOC->PAD[IOC_PAD_PZ09].FUNC_CTL  = IOC_PZ09_FUNC_CTL_UART13_TXD;
        /* PZ port IO needs to configure BIOC as well */
        HPM_BIOC->PAD[IOC_PAD_PZ08].FUNC_CTL = BIOC_PZ08_FUNC_CTL_SOC_PZ_08;
        HPM_BIOC->PAD[IOC_PAD_PZ09].FUNC_CTL = BIOC_PZ09_FUNC_CTL_SOC_PZ_09;
    }
    else if (ptr == HPM_UART14)
    {
        HPM_IOC->PAD[IOC_PAD_PZ10].FUNC_CTL  = IOC_PZ10_FUNC_CTL_UART14_RXD;
        HPM_IOC->PAD[IOC_PAD_PZ11].FUNC_CTL  = IOC_PZ11_FUNC_CTL_UART14_TXD;
        /* PZ port IO needs to configure BIOC as well */
        HPM_BIOC->PAD[IOC_PAD_PZ10].FUNC_CTL = BIOC_PZ10_FUNC_CTL_SOC_PZ_10;
        HPM_BIOC->PAD[IOC_PAD_PZ11].FUNC_CTL = BIOC_PZ11_FUNC_CTL_SOC_PZ_11;
    }
    else if (ptr == HPM_PUART)
    {
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_PUART_RXD;
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_PUART_TXD;
    }
}

void init_femc_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PC01].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC00].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB31].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB30].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB29].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB28].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB27].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB26].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB25].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB24].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB23].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB22].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB21].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB20].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB19].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PB18].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);

    HPM_IOC->PAD[IOC_PAD_PD13].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD12].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD10].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD09].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD08].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD07].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD06].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD05].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD04].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD03].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD02].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD01].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PD00].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC29].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC28].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC27].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);

    HPM_IOC->PAD[IOC_PAD_PC21].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12); /* SRAM #WE */
    HPM_IOC->PAD[IOC_PAD_PC17].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC15].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC12].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC11].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC10].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC09].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC08].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC07].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC06].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC05].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC04].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);

    HPM_IOC->PAD[IOC_PAD_PC14].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12); /* SRAM #ADV */
    HPM_IOC->PAD[IOC_PAD_PC13].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC16].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12) | IOC_PAD_FUNC_CTL_LOOP_BACK_MASK;
    HPM_IOC->PAD[IOC_PAD_PC26].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC25].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC19].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC18].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC23].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC24].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC30].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12); /* SRAM #LB */
    HPM_IOC->PAD[IOC_PAD_PC31].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12); /* SRAM #UB */
    HPM_IOC->PAD[IOC_PAD_PC02].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
    HPM_IOC->PAD[IOC_PAD_PC03].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);

    HPM_IOC->PAD[IOC_PAD_PC20].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12); /* SRAM #CE */
    HPM_IOC->PAD[IOC_PAD_PC22].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12); /* SRAM #OE */
}

void board_init_console(void)
{
#if !defined(CONFIG_NDEBUG_CONSOLE) || !CONFIG_NDEBUG_CONSOLE
#if BOARD_CONSOLE_TYPE == CONSOLE_TYPE_UART
    console_config_t cfg;

    /* uart needs to configure pin function before enabling clock, otherwise the level change of
    uart rx pin when configuring pin function will cause a wrong data to be received.
    And a uart rx dma request will be generated by default uart fifo dma trigger level. */
    init_uart_pins((UART_Type*)BOARD_CONSOLE_UART_BASE);

    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);

    cfg.type           = BOARD_CONSOLE_TYPE;
    cfg.base           = (uint32_t)BOARD_CONSOLE_UART_BASE;
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
    cfg.baudrate       = BOARD_CONSOLE_UART_BAUDRATE;

    if (status_success != console_init(&cfg))
    {
        /* failed to  initialize debug console */
        while (1)
        {
        }
    }
#else
    while (1)
    {
    }
#endif
#endif
}

void board_print_clock_freq(void)
{
    printf("==============================\n");
    printf(" %s clock summary\n", BOARD_NAME);
    printf("==============================\n");
    printf("cpu0:\t\t %luHz\n", clock_get_frequency(clock_cpu0));
    printf("cpu1:\t\t %luHz\n", clock_get_frequency(clock_cpu1));
    printf("axi0:\t\t %luHz\n", clock_get_frequency(clock_axi0));
    printf("axi1:\t\t %luHz\n", clock_get_frequency(clock_axi1));
    printf("axi2:\t\t %luHz\n", clock_get_frequency(clock_axi2));
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb));
    printf("mchtmr0:\t %luHz\n", clock_get_frequency(clock_mchtmr0));
    printf("mchtmr1:\t %luHz\n", clock_get_frequency(clock_mchtmr1));
    printf("xpi0:\t\t %luHz\n", clock_get_frequency(clock_xpi0));
    printf("xpi1:\t\t %luHz\n", clock_get_frequency(clock_xpi1));
    printf("femc:\t\t %luHz\n", clock_get_frequency(clock_femc));
    printf("==============================\n");
}

void board_init_uart(UART_Type* ptr)
{
    /* configure uart's pin before opening uart's clock */
    init_uart_pins(ptr);
    board_init_uart_clock(ptr);
}

void board_init(void)
{
    board_init_clock();
    board_init_console();
    board_init_pmp();
#if BOARD_SHOW_CLOCK
    board_print_clock_freq();
#endif
}

void board_init_sdram_pins(void)
{
    init_femc_pins();
}

uint32_t board_init_femc_clock(void)
{
    clock_add_to_group(clock_femc, 0);

    clock_set_source_divider(clock_femc, clk_src_pll2_clk0, 2U); /* 166Mhz */

    return clock_get_frequency(clock_femc);
}

void board_delay_ms(uint32_t ms)
{
    clock_cpu_delay_ms(ms);
}

void board_delay_us(uint32_t us)
{
    clock_cpu_delay_us(us);
}

uint32_t board_init_uart_clock(UART_Type* ptr)
{
    uint32_t freq = 0U;
    if (ptr == HPM_UART0)
    {
        clock_add_to_group(clock_uart0, 0);
        freq = clock_get_frequency(clock_uart0);
    }
    else if (ptr == HPM_UART6)
    {
        clock_add_to_group(clock_uart6, 0);
        freq = clock_get_frequency(clock_uart6);
    }
    else if (ptr == HPM_UART7)
    {
        clock_add_to_group(clock_uart7, 0);
        freq = clock_get_frequency(clock_uart7);
    }
    else if (ptr == HPM_UART13)
    {
        clock_add_to_group(clock_uart13, 0);
        freq = clock_get_frequency(clock_uart13);
    }
    else if (ptr == HPM_UART14)
    {
        clock_add_to_group(clock_uart14, 0);
        freq = clock_get_frequency(clock_uart14);
    }
    else
    {
        /* Not supported */
    }
    return freq;
}

void board_init_pmp(void)
{
    uint32_t    start_addr;
    uint32_t    end_addr;
    uint32_t    length;
    pmp_entry_t pmp_entry[16];
    uint8_t     index = 0;

    /* Init noncachable memory */
    extern uint32_t __noncacheable_start__[];
    extern uint32_t __noncacheable_end__[];
    start_addr = (uint32_t)__noncacheable_start__;
    end_addr   = (uint32_t)__noncacheable_end__;
    length     = end_addr - start_addr;
    if (length > 0)
    {
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
        assert((start_addr & (length - 1U)) == 0U);
        pmp_entry[index].pmp_addr    = PMP_NAPOT_ADDR(start_addr, length);
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
        pmp_entry[index].pma_addr    = PMA_NAPOT_ADDR(start_addr, length);
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
        index++;
    }

    /* Init share memory */
    extern uint32_t __share_mem_start__[];
    extern uint32_t __share_mem_end__[];
    start_addr = (uint32_t)__share_mem_start__;
    end_addr   = (uint32_t)__share_mem_end__;
    length     = end_addr - start_addr;
    if (length > 0)
    {
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
        assert((start_addr & (length - 1U)) == 0U);
        pmp_entry[index].pmp_addr    = PMP_NAPOT_ADDR(start_addr, length);
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
        pmp_entry[index].pma_addr    = PMA_NAPOT_ADDR(start_addr, length);
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
        index++;
    }

    pmp_config(&pmp_entry[0], index);
}

void board_init_clock(void)
{
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ)
    {
        /* Configure the External OSC ramp-up time: ~9ms */
        pllctl_xtal_set_rampup_time(HPM_PLLCTL, 32UL * 1000UL * 9U);

        /* Select clock setting preset1 */
        sysctl_clock_set_preset(HPM_SYSCTL, sysctl_preset_1);
    }

    /* Add clocks to group 0 */
    clock_add_to_group(clock_cpu0, 0);
    clock_add_to_group(clock_mchtmr0, 0);
    clock_add_to_group(clock_axi0, 0);
    clock_add_to_group(clock_axi1, 0);
    clock_add_to_group(clock_axi2, 0);
    clock_add_to_group(clock_ahb, 0);
    clock_add_to_group(clock_xdma, 0);
    clock_add_to_group(clock_hdma, 0);
    clock_add_to_group(clock_xpi0, 0);
    clock_add_to_group(clock_xpi1, 0);
    clock_add_to_group(clock_ram0, 0);
    clock_add_to_group(clock_ram1, 0);
    clock_add_to_group(clock_lmm0, 0);
    clock_add_to_group(clock_lmm1, 0);
    clock_add_to_group(clock_gpio, 0);
    clock_add_to_group(clock_mot0, 0);
    clock_add_to_group(clock_mot1, 0);
    clock_add_to_group(clock_mot2, 0);
    clock_add_to_group(clock_mot3, 0);
    clock_add_to_group(clock_synt, 0);
    clock_add_to_group(clock_ptpc, 0);
    /* Connect Group0 to CPU0 */
    clock_connect_group_to_cpu(0, 0);

    /* Add clocks to Group1 */
    clock_add_to_group(clock_cpu1, 1);
    clock_add_to_group(clock_mchtmr1, 1);
    /* Connect Group1 to CPU1 */
    clock_connect_group_to_cpu(1, 1);

    /* Bump up DCDC voltage to 1200mv */
    pcfg_dcdc_set_voltage(HPM_PCFG, 1200);
    pcfg_dcdc_switch_to_dcm_mode(HPM_PCFG);

    if (status_success != pllctl_init_int_pll_with_freq(HPM_PLLCTL, 0, BOARD_CPU_FREQ))
    {
        printf("Failed to set pll0_clk0 to %ldHz\n", BOARD_CPU_FREQ);
        while (1)
        {
        }
    }

    clock_set_source_divider(clock_cpu0, clk_src_pll0_clk0, 1);
    clock_set_source_divider(clock_cpu1, clk_src_pll0_clk0, 1);
    clock_update_core_clock();

    clock_set_source_divider(clock_ahb, clk_src_pll1_clk1, 2); /*200m hz*/
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
    clock_set_source_divider(clock_mchtmr1, clk_src_osc24m, 1);
}

#ifdef INIT_EXT_RAM_FOR_DATA
/*
 * this function will be called during startup to initialize external memory for data use
 */
void _init_ext_ram(void)
{
    uint32_t            femc_clk_in_hz;
    femc_config_t       config       = {0};
    femc_sdram_config_t sdram_config = {0};

    board_init_sdram_pins();
    femc_clk_in_hz = board_init_femc_clock();
    femc_default_config(HPM_FEMC, &config);
    femc_init(HPM_FEMC, &config);

    femc_get_typical_sdram_config(HPM_FEMC, &sdram_config);

    sdram_config.bank_num                        = FEMC_SDRAM_BANK_NUM_4;
    sdram_config.prescaler                       = 0x3;
    sdram_config.burst_len_in_byte               = 8;
    sdram_config.auto_refresh_count_in_one_burst = 1;
    sdram_config.col_addr_bits                   = BOARD_SDRAM_COLUMN_ADDR_BITS;
    sdram_config.cas_latency                     = FEMC_SDRAM_CAS_LATENCY_3;

    sdram_config.refresh_to_refresh_in_ns   = 60; /* Trc */
    sdram_config.refresh_recover_in_ns      = 60; /* Trc */
    sdram_config.act_to_precharge_in_ns     = 42; /* Tras */
    sdram_config.act_to_rw_in_ns            = 18; /* Trcd */
    sdram_config.precharge_to_act_in_ns     = 18; /* Trp */
    sdram_config.act_to_act_in_ns           = 12; /* Trrd */
    sdram_config.write_recover_in_ns        = 12; /* Twr/Tdpl */
    sdram_config.self_refresh_recover_in_ns = 72; /* Txsr */

    sdram_config.cs                 = BOARD_SDRAM_CS;
    sdram_config.base_address       = BOARD_SDRAM_ADDRESS;
    sdram_config.size_in_byte       = BOARD_SDRAM_SIZE;
    sdram_config.port_size          = BOARD_SDRAM_PORT_SIZE;
    sdram_config.refresh_count      = BOARD_SDRAM_REFRESH_COUNT;
    sdram_config.refresh_in_ms      = BOARD_SDRAM_REFRESH_IN_MS;
    sdram_config.delay_cell_disable = true;
    sdram_config.delay_cell_value   = 0;

    femc_config_sdram(HPM_FEMC, femc_clk_in_hz, &sdram_config);
}
#endif

uint32_t board_sd_configure_clock(SDXC_Type* ptr, uint32_t freq, bool need_inverse)
{
    uint32_t actual_freq = 0;
    do {
        clock_name_t sdxc_clk = (ptr == HPM_SDXC0) ? clock_sdxc0 : clock_sdxc1;
        clock_add_to_group(sdxc_clk, 0);
        sdxc_enable_inverse_clock(ptr, false);
        sdxc_enable_sd_clock(ptr, false);
        /* Configure the clock below 400KHz for the identification state */
        if (freq <= 400000UL)
        {
            clock_set_source_divider(sdxc_clk, clk_src_osc24m, 63);
        }
        /* configure the clock to 24MHz for the SDR12/Default speed */
        else if (freq <= 26000000UL)
        {
            clock_set_source_divider(sdxc_clk, clk_src_osc24m, 1);
        }
        /* Configure the clock to 50MHz for the SDR25/High speed/50MHz DDR/50MHz SDR */
        else if (freq <= 52000000UL)
        {
            clock_set_source_divider(sdxc_clk, clk_src_pll1_clk1, 8);
        }
        /* Configure the clock to 100MHz for the SDR50 */
        else if (freq <= 100000000UL)
        {
            clock_set_source_divider(sdxc_clk, clk_src_pll1_clk1, 4);
        }
        /* Configure the clock to 166MHz for SDR104/HS200/HS400  */
        else if (freq <= 208000000UL)
        {
            clock_set_source_divider(sdxc_clk, clk_src_pll2_clk0, 2);
        }
        /* For other unsupported clock ranges, configure the clock to 24MHz */
        else
        {
            clock_set_source_divider(sdxc_clk, clk_src_osc24m, 1);
        }
        if (need_inverse)
        {
            sdxc_enable_inverse_clock(ptr, true);
        }

        hpm_stat_t status = clock_wait_source_stable(sdxc_clk);
        if (status != status_success)
        {
            break;
        }

        sdxc_enable_sd_clock(ptr, true);
        actual_freq = clock_get_frequency(sdxc_clk);
    } while (false);

    return actual_freq;
}
