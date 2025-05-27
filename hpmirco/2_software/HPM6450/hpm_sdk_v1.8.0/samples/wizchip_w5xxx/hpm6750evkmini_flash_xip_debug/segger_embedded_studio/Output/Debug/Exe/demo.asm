
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80003000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80003000:	010811b7          	lui	gp,0x1081
        addi    gp, gp, %lo(__global_pointer$)
80003004:	80018193          	add	gp,gp,-2048 # 1080800 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	01081237          	lui	tp,0x1081
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	98c20213          	add	tp,tp,-1652 # 108098c <__thread_pointer$>
        .option pop

        csrw    mstatus, zero
80003010:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
80003014:	34201073          	csrw	mcause,zero
    /* Initialize FCSR */
    fscsr zero
#endif

    /* Enable LMM1 clock */
    la t0, 0xF4000800
80003018:	f40012b7          	lui	t0,0xf4001
8000301c:	80028293          	add	t0,t0,-2048 # f4000800 <__AHB_SRAM_segment_end__+0x3cf8800>
    lw t1, 0(t0)
80003020:	0002a303          	lw	t1,0(t0)
    ori t1, t1, 0x80
80003024:	08036313          	or	t1,t1,128
    sw t1, 0(t0)
80003028:	0062a023          	sw	t1,0(t0)
    la t0, _stack_safe
    mv sp, t0
    call _init_ext_ram
#endif

        lui     t0,     %hi(__stack_end__)
8000302c:	000c02b7          	lui	t0,0xc0
        addi    sp, t0, %lo(__stack_end__)
80003030:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
80003034:	10b040ef          	jal	8000793e <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003038:	0d1040ef          	jal	80007908 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
8000303c:	703090ef          	jal	8000cf3e <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
80003040:	38b090ef          	jal	8000cbca <_init>

80003044 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003044:	8000f437          	lui	s0,0x8000f
80003048:	b5440413          	add	s0,s0,-1196 # 8000eb54 <.L155+0x4>

8000304c <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
8000304c:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
8000304e:	0411                	add	s0,s0,4
        jalr    a0                              // Call initialization function
80003050:	9502                	jalr	a0
        j       L(RunInit)
80003052:	bfed                	j	8000304c <.L_start_RunInit>

80003054 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
80003054:	2b5090ef          	jal	8000cb08 <_clean_up>

80003058 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80003058:	000002b7          	lui	t0,0x0
8000305c:	00028293          	mv	t0,t0
    csrw mtvec, t0
80003060:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
80003064:	7d016073          	csrs	0x7d0,2

80003068 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003068:	34d090ef          	jal	8000cbb4 <reset_handler>
        tail    exit
8000306c:	a009                	j	8000306e <exit>

8000306e <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
8000306e:	a001                	j	8000306e <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
80003070:	4501                	li	a0,0
        li      a1, 0
80003072:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
80003074:	341090ef          	jal	8000cbb4 <reset_handler>
        tail    exit
80003078:	bfdd                	j	8000306e <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>:
8000307a:	8082                	ret

Disassembly of section .text.gptmr_channel_get_default_config:

80003d1e <gptmr_channel_get_default_config>:
 */

#include "hpm_gptmr_drv.h"

void gptmr_channel_get_default_config(GPTMR_Type *ptr, gptmr_channel_config_t *config)
{
80003d1e:	1101                	add	sp,sp,-32
80003d20:	c62a                	sw	a0,12(sp)
80003d22:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->mode = gptmr_work_mode_no_capture;
80003d24:	47a2                	lw	a5,8(sp)
80003d26:	00078023          	sb	zero,0(a5)
    config->dma_request_event = gptmr_dma_request_disabled;
80003d2a:	47a2                	lw	a5,8(sp)
80003d2c:	577d                	li	a4,-1
80003d2e:	00e780a3          	sb	a4,1(a5)
    config->synci_edge = gptmr_synci_edge_none;
80003d32:	47a2                	lw	a5,8(sp)
80003d34:	00079123          	sh	zero,2(a5)

80003d38 <.LBB2>:
    for (uint8_t i = 0; i < GPTMR_CH_CMP_COUNT; i++) {
80003d38:	00010fa3          	sb	zero,31(sp)
80003d3c:	a829                	j	80003d56 <.L2>

80003d3e <.L3>:
        config->cmp[i] = 0xFFFFFFFEUL;
80003d3e:	01f14783          	lbu	a5,31(sp)
80003d42:	4722                	lw	a4,8(sp)
80003d44:	078a                	sll	a5,a5,0x2
80003d46:	97ba                	add	a5,a5,a4
80003d48:	5779                	li	a4,-2
80003d4a:	c3d8                	sw	a4,4(a5)
    for (uint8_t i = 0; i < GPTMR_CH_CMP_COUNT; i++) {
80003d4c:	01f14783          	lbu	a5,31(sp)
80003d50:	0785                	add	a5,a5,1
80003d52:	00f10fa3          	sb	a5,31(sp)

80003d56 <.L2>:
80003d56:	01f14703          	lbu	a4,31(sp)
80003d5a:	4785                	li	a5,1
80003d5c:	fee7f1e3          	bgeu	a5,a4,80003d3e <.L3>

80003d60 <.LBE2>:
    }
    config->reload = 0xFFFFFFFEUL;
80003d60:	47a2                	lw	a5,8(sp)
80003d62:	5779                	li	a4,-2
80003d64:	c7d8                	sw	a4,12(a5)
    config->cmp_initial_polarity_high = true;
80003d66:	47a2                	lw	a5,8(sp)
80003d68:	4705                	li	a4,1
80003d6a:	00e78823          	sb	a4,16(a5)
    config->enable_cmp_output = true;
80003d6e:	47a2                	lw	a5,8(sp)
80003d70:	4705                	li	a4,1
80003d72:	00e788a3          	sb	a4,17(a5)
    config->enable_sync_follow_previous_channel = false;
80003d76:	47a2                	lw	a5,8(sp)
80003d78:	00078923          	sb	zero,18(a5)
    config->enable_software_sync = false;
80003d7c:	47a2                	lw	a5,8(sp)
80003d7e:	000789a3          	sb	zero,19(a5)
    config->debug_mode = true;
80003d82:	47a2                	lw	a5,8(sp)
80003d84:	4705                	li	a4,1
80003d86:	00e78a23          	sb	a4,20(a5)

#if defined(HPM_IP_FEATURE_GPTMR_MONITOR) && (HPM_IP_FEATURE_GPTMR_MONITOR  == 1)
    config->enable_monitor = false;
    gptmr_channel_get_default_monitor_config(ptr, &config->monitor_config);
#endif
}
80003d8a:	0001                	nop
80003d8c:	6105                	add	sp,sp,32
80003d8e:	8082                	ret

Disassembly of section .text.gptmr_channel_config:

80003dae <gptmr_channel_config>:

hpm_stat_t gptmr_channel_config(GPTMR_Type *ptr,
                         uint8_t ch_index,
                         gptmr_channel_config_t *config,
                         bool enable)
{
80003dae:	1101                	add	sp,sp,-32
80003db0:	c62a                	sw	a0,12(sp)
80003db2:	87ae                	mv	a5,a1
80003db4:	c232                	sw	a2,4(sp)
80003db6:	8736                	mv	a4,a3
80003db8:	00f105a3          	sb	a5,11(sp)
80003dbc:	87ba                	mv	a5,a4
80003dbe:	00f10523          	sb	a5,10(sp)
    uint32_t v = 0;
80003dc2:	ce02                	sw	zero,28(sp)
    uint32_t tmp_value;

    if (config->enable_sync_follow_previous_channel && !ch_index) {
80003dc4:	4792                	lw	a5,4(sp)
80003dc6:	0127c783          	lbu	a5,18(a5)
80003dca:	c791                	beqz	a5,80003dd6 <.L5>
80003dcc:	00b14783          	lbu	a5,11(sp)
80003dd0:	e399                	bnez	a5,80003dd6 <.L5>
        return status_invalid_argument;
80003dd2:	4789                	li	a5,2
80003dd4:	aa19                	j	80003eea <.L6>

80003dd6 <.L5>:
    }

    if (config->dma_request_event != gptmr_dma_request_disabled) {
80003dd6:	4792                	lw	a5,4(sp)
80003dd8:	0017c703          	lbu	a4,1(a5)
80003ddc:	0ff00793          	li	a5,255
80003de0:	00f70d63          	beq	a4,a5,80003dfa <.L7>
        v |= GPTMR_CHANNEL_CR_DMAEN_MASK
            | GPTMR_CHANNEL_CR_DMASEL_SET(config->dma_request_event);
80003de4:	4792                	lw	a5,4(sp)
80003de6:	0017c783          	lbu	a5,1(a5)
80003dea:	079a                	sll	a5,a5,0x6
80003dec:	0ff7f713          	zext.b	a4,a5
        v |= GPTMR_CHANNEL_CR_DMAEN_MASK
80003df0:	47f2                	lw	a5,28(sp)
80003df2:	8fd9                	or	a5,a5,a4
80003df4:	0207e793          	or	a5,a5,32
80003df8:	ce3e                	sw	a5,28(sp)

80003dfa <.L7>:
    }
    v |= GPTMR_CHANNEL_CR_CAPMODE_SET(config->mode)
80003dfa:	4792                	lw	a5,4(sp)
80003dfc:	0007c783          	lbu	a5,0(a5)
80003e00:	0077f713          	and	a4,a5,7
        | GPTMR_CHANNEL_CR_DBGPAUSE_SET(config->debug_mode)
80003e04:	4792                	lw	a5,4(sp)
80003e06:	0147c783          	lbu	a5,20(a5)
80003e0a:	078e                	sll	a5,a5,0x3
80003e0c:	8ba1                	and	a5,a5,8
80003e0e:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_SWSYNCIEN_SET(config->enable_software_sync)
80003e10:	4792                	lw	a5,4(sp)
80003e12:	0137c783          	lbu	a5,19(a5)
80003e16:	0792                	sll	a5,a5,0x4
80003e18:	8bc1                	and	a5,a5,16
80003e1a:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_CMPINIT_SET(config->cmp_initial_polarity_high)
80003e1c:	4792                	lw	a5,4(sp)
80003e1e:	0107c783          	lbu	a5,16(a5)
80003e22:	07a6                	sll	a5,a5,0x9
80003e24:	2007f793          	and	a5,a5,512
80003e28:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_SYNCFLW_SET(config->enable_sync_follow_previous_channel)
80003e2a:	4792                	lw	a5,4(sp)
80003e2c:	0127c783          	lbu	a5,18(a5)
80003e30:	00d79693          	sll	a3,a5,0xd
80003e34:	6789                	lui	a5,0x2
80003e36:	8ff5                	and	a5,a5,a3
80003e38:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_CMPEN_SET(config->enable_cmp_output)
80003e3a:	4792                	lw	a5,4(sp)
80003e3c:	0117c783          	lbu	a5,17(a5) # 2011 <__APB_SRAM_segment_size__+0x11>
80003e40:	07a2                	sll	a5,a5,0x8
80003e42:	1007f793          	and	a5,a5,256
80003e46:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_CEN_SET(enable)
80003e48:	00a14783          	lbu	a5,10(sp)
80003e4c:	07aa                	sll	a5,a5,0xa
80003e4e:	4007f793          	and	a5,a5,1024
80003e52:	8fd9                	or	a5,a5,a4
        | config->synci_edge;
80003e54:	4712                	lw	a4,4(sp)
80003e56:	00275703          	lhu	a4,2(a4)
80003e5a:	8fd9                	or	a5,a5,a4
    v |= GPTMR_CHANNEL_CR_CAPMODE_SET(config->mode)
80003e5c:	4772                	lw	a4,28(sp)
80003e5e:	8fd9                	or	a5,a5,a4
80003e60:	ce3e                	sw	a5,28(sp)

80003e62 <.LBB3>:
    v |= GPTMR_CHANNEL_CR_CNT_MODE_SET(config->counter_mode);
#endif
#if defined(HPM_IP_FEATURE_GPTMR_OP_MODE) && (HPM_IP_FEATURE_GPTMR_OP_MODE  == 1)
    v |= GPTMR_CHANNEL_CR_OPMODE_SET(config->enable_opmode);
#endif
    for (uint8_t i = GPTMR_CH_CMP_COUNT; i > 0; i--) {
80003e62:	4789                	li	a5,2
80003e64:	00f10ba3          	sb	a5,23(sp)
80003e68:	a099                	j	80003eae <.L8>

80003e6a <.L10>:
        tmp_value = config->cmp[i - 1];
80003e6a:	01714783          	lbu	a5,23(sp)
80003e6e:	17fd                	add	a5,a5,-1
80003e70:	4712                	lw	a4,4(sp)
80003e72:	078a                	sll	a5,a5,0x2
80003e74:	97ba                	add	a5,a5,a4
80003e76:	43dc                	lw	a5,4(a5)
80003e78:	cc3e                	sw	a5,24(sp)
        if ((tmp_value > 0)  && (tmp_value != 0xFFFFFFFFu)) {
80003e7a:	47e2                	lw	a5,24(sp)
80003e7c:	cb81                	beqz	a5,80003e8c <.L9>
80003e7e:	4762                	lw	a4,24(sp)
80003e80:	57fd                	li	a5,-1
80003e82:	00f70563          	beq	a4,a5,80003e8c <.L9>
            tmp_value--;
80003e86:	47e2                	lw	a5,24(sp)
80003e88:	17fd                	add	a5,a5,-1
80003e8a:	cc3e                	sw	a5,24(sp)

80003e8c <.L9>:
        }
        ptr->CHANNEL[ch_index].CMP[i - 1] = GPTMR_CHANNEL_CMP_CMP_SET(tmp_value);
80003e8c:	00b14683          	lbu	a3,11(sp)
80003e90:	01714783          	lbu	a5,23(sp)
80003e94:	17fd                	add	a5,a5,-1
80003e96:	4732                	lw	a4,12(sp)
80003e98:	0692                	sll	a3,a3,0x4
80003e9a:	97b6                	add	a5,a5,a3
80003e9c:	078a                	sll	a5,a5,0x2
80003e9e:	97ba                	add	a5,a5,a4
80003ea0:	4762                	lw	a4,24(sp)
80003ea2:	c3d8                	sw	a4,4(a5)
    for (uint8_t i = GPTMR_CH_CMP_COUNT; i > 0; i--) {
80003ea4:	01714783          	lbu	a5,23(sp)
80003ea8:	17fd                	add	a5,a5,-1
80003eaa:	00f10ba3          	sb	a5,23(sp)

80003eae <.L8>:
80003eae:	01714783          	lbu	a5,23(sp)
80003eb2:	ffc5                	bnez	a5,80003e6a <.L10>

80003eb4 <.LBE3>:
    }
    tmp_value = config->reload;
80003eb4:	4792                	lw	a5,4(sp)
80003eb6:	47dc                	lw	a5,12(a5)
80003eb8:	cc3e                	sw	a5,24(sp)
    if ((tmp_value > 0) && (tmp_value != 0xFFFFFFFFu)) {
80003eba:	47e2                	lw	a5,24(sp)
80003ebc:	cb81                	beqz	a5,80003ecc <.L11>
80003ebe:	4762                	lw	a4,24(sp)
80003ec0:	57fd                	li	a5,-1
80003ec2:	00f70563          	beq	a4,a5,80003ecc <.L11>
        tmp_value--;
80003ec6:	47e2                	lw	a5,24(sp)
80003ec8:	17fd                	add	a5,a5,-1
80003eca:	cc3e                	sw	a5,24(sp)

80003ecc <.L11>:
    }
    ptr->CHANNEL[ch_index].RLD = GPTMR_CHANNEL_RLD_RLD_SET(tmp_value);
80003ecc:	00b14783          	lbu	a5,11(sp)
80003ed0:	4732                	lw	a4,12(sp)
80003ed2:	079a                	sll	a5,a5,0x6
80003ed4:	97ba                	add	a5,a5,a4
80003ed6:	4762                	lw	a4,24(sp)
80003ed8:	c7d8                	sw	a4,12(a5)
    ptr->CHANNEL[ch_index].CR = v;
80003eda:	00b14783          	lbu	a5,11(sp)
80003ede:	4732                	lw	a4,12(sp)
80003ee0:	079a                	sll	a5,a5,0x6
80003ee2:	97ba                	add	a5,a5,a4
80003ee4:	4772                	lw	a4,28(sp)
80003ee6:	c398                	sw	a4,0(a5)
#if defined(HPM_IP_FEATURE_GPTMR_MONITOR) && (HPM_IP_FEATURE_GPTMR_MONITOR  == 1)
    gptmr_channel_monitor_config(ptr, ch_index, &config->monitor_config, config->enable_monitor);
#endif

    return status_success;
80003ee8:	4781                	li	a5,0

80003eea <.L6>:
}
80003eea:	853e                	mv	a0,a5
80003eec:	6105                	add	sp,sp,32
80003eee:	8082                	ret

Disassembly of section .text.pllctl_pll_poweron:

80003efa <pllctl_pll_poweron>:
 * @param[in] pll Target PLL index
 *
 * @return status_success if everything is okay
 */
static inline hpm_stat_t pllctl_pll_poweron(PLLCTL_Type *ptr, uint8_t pll)
{
80003efa:	1101                	add	sp,sp,-32
80003efc:	c62a                	sw	a0,12(sp)
80003efe:	87ae                	mv	a5,a1
80003f00:	00f105a3          	sb	a5,11(sp)
    uint32_t cfg;
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
80003f04:	00b14703          	lbu	a4,11(sp)
80003f08:	4791                	li	a5,4
80003f0a:	00e7f463          	bgeu	a5,a4,80003f12 <.L8>
        return status_invalid_argument;
80003f0e:	4789                	li	a5,2
80003f10:	a849                	j	80003fa2 <.L9>

80003f12 <.L8>:
    }

    cfg = ptr->PLL[pll].CFG1;
80003f12:	00b14783          	lbu	a5,11(sp)
80003f16:	4732                	lw	a4,12(sp)
80003f18:	0785                	add	a5,a5,1
80003f1a:	079e                	sll	a5,a5,0x7
80003f1c:	97ba                	add	a5,a5,a4
80003f1e:	43dc                	lw	a5,4(a5)
80003f20:	ce3e                	sw	a5,28(sp)
    if (!(cfg & PLLCTL_PLL_CFG1_PLLPD_SW_MASK)) {
80003f22:	4772                	lw	a4,28(sp)
80003f24:	020007b7          	lui	a5,0x2000
80003f28:	8ff9                	and	a5,a5,a4
80003f2a:	e399                	bnez	a5,80003f30 <.L10>
        return status_success;
80003f2c:	4781                	li	a5,0
80003f2e:	a895                	j	80003fa2 <.L9>

80003f30 <.L10>:
    }

    if (cfg & PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK) {
80003f30:	47f2                	lw	a5,28(sp)
80003f32:	0207d463          	bgez	a5,80003f5a <.L11>
        ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
80003f36:	00b14783          	lbu	a5,11(sp)
80003f3a:	4732                	lw	a4,12(sp)
80003f3c:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
80003f3e:	079e                	sll	a5,a5,0x7
80003f40:	97ba                	add	a5,a5,a4
80003f42:	43d4                	lw	a3,4(a5)
80003f44:	00b14783          	lbu	a5,11(sp)
80003f48:	80000737          	lui	a4,0x80000
80003f4c:	177d                	add	a4,a4,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
80003f4e:	8f75                	and	a4,a4,a3
80003f50:	46b2                	lw	a3,12(sp)
80003f52:	0785                	add	a5,a5,1
80003f54:	079e                	sll	a5,a5,0x7
80003f56:	97b6                	add	a5,a5,a3
80003f58:	c3d8                	sw	a4,4(a5)

80003f5a <.L11>:
    }

    ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
80003f5a:	00b14783          	lbu	a5,11(sp)
80003f5e:	4732                	lw	a4,12(sp)
80003f60:	0785                	add	a5,a5,1
80003f62:	079e                	sll	a5,a5,0x7
80003f64:	97ba                	add	a5,a5,a4
80003f66:	43d4                	lw	a3,4(a5)
80003f68:	00b14783          	lbu	a5,11(sp)
80003f6c:	fe000737          	lui	a4,0xfe000
80003f70:	177d                	add	a4,a4,-1 # fdffffff <__APB_SRAM_segment_end__+0x9f0dfff>
80003f72:	8f75                	and	a4,a4,a3
80003f74:	46b2                	lw	a3,12(sp)
80003f76:	0785                	add	a5,a5,1
80003f78:	079e                	sll	a5,a5,0x7
80003f7a:	97b6                	add	a5,a5,a3
80003f7c:	c3d8                	sw	a4,4(a5)

    /*
     * put back to hardware mode
     */
    ptr->PLL[pll].CFG1 |= PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
80003f7e:	00b14783          	lbu	a5,11(sp)
80003f82:	4732                	lw	a4,12(sp)
80003f84:	0785                	add	a5,a5,1
80003f86:	079e                	sll	a5,a5,0x7
80003f88:	97ba                	add	a5,a5,a4
80003f8a:	43d4                	lw	a3,4(a5)
80003f8c:	00b14783          	lbu	a5,11(sp)
80003f90:	80000737          	lui	a4,0x80000
80003f94:	8f55                	or	a4,a4,a3
80003f96:	46b2                	lw	a3,12(sp)
80003f98:	0785                	add	a5,a5,1
80003f9a:	079e                	sll	a5,a5,0x7
80003f9c:	97b6                	add	a5,a5,a3
80003f9e:	c3d8                	sw	a4,4(a5)
    return status_success;
80003fa0:	4781                	li	a5,0

80003fa2 <.L9>:
}
80003fa2:	853e                	mv	a0,a5
80003fa4:	6105                	add	sp,sp,32
80003fa6:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

80003faa <read_pmp_cfg>:
 */
#include "hpm_pmp_drv.h"
#include "hpm_csr_drv.h"

uint32_t read_pmp_cfg(uint32_t idx)
{
80003faa:	7179                	add	sp,sp,-48
80003fac:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
80003fae:	d602                	sw	zero,44(sp)
    switch (idx) {
80003fb0:	4732                	lw	a4,12(sp)
80003fb2:	478d                	li	a5,3
80003fb4:	04f70763          	beq	a4,a5,80004002 <.L2>
80003fb8:	4732                	lw	a4,12(sp)
80003fba:	478d                	li	a5,3
80003fbc:	04e7e963          	bltu	a5,a4,8000400e <.L9>
80003fc0:	4732                	lw	a4,12(sp)
80003fc2:	4789                	li	a5,2
80003fc4:	02f70963          	beq	a4,a5,80003ff6 <.L4>
80003fc8:	4732                	lw	a4,12(sp)
80003fca:	4789                	li	a5,2
80003fcc:	04e7e163          	bltu	a5,a4,8000400e <.L9>
80003fd0:	47b2                	lw	a5,12(sp)
80003fd2:	c791                	beqz	a5,80003fde <.L5>
80003fd4:	4732                	lw	a4,12(sp)
80003fd6:	4785                	li	a5,1
80003fd8:	00f70963          	beq	a4,a5,80003fea <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
80003fdc:	a80d                	j	8000400e <.L9>

80003fde <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
80003fde:	3a0027f3          	csrr	a5,pmpcfg0
80003fe2:	ce3e                	sw	a5,28(sp)
80003fe4:	47f2                	lw	a5,28(sp)

80003fe6 <.LBE2>:
80003fe6:	d63e                	sw	a5,44(sp)
        break;
80003fe8:	a025                	j	80004010 <.L7>

80003fea <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
80003fea:	3a1027f3          	csrr	a5,pmpcfg1
80003fee:	d03e                	sw	a5,32(sp)
80003ff0:	5782                	lw	a5,32(sp)

80003ff2 <.LBE3>:
80003ff2:	d63e                	sw	a5,44(sp)
        break;
80003ff4:	a831                	j	80004010 <.L7>

80003ff6 <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
80003ff6:	3a2027f3          	csrr	a5,pmpcfg2
80003ffa:	d23e                	sw	a5,36(sp)
80003ffc:	5792                	lw	a5,36(sp)

80003ffe <.LBE4>:
80003ffe:	d63e                	sw	a5,44(sp)
        break;
80004000:	a801                	j	80004010 <.L7>

80004002 <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
80004002:	3a3027f3          	csrr	a5,pmpcfg3
80004006:	d43e                	sw	a5,40(sp)
80004008:	57a2                	lw	a5,40(sp)

8000400a <.LBE5>:
8000400a:	d63e                	sw	a5,44(sp)
        break;
8000400c:	a011                	j	80004010 <.L7>

8000400e <.L9>:
        break;
8000400e:	0001                	nop

80004010 <.L7>:
    }
    return pmp_cfg;
80004010:	57b2                	lw	a5,44(sp)
}
80004012:	853e                	mv	a0,a5
80004014:	6145                	add	sp,sp,48
80004016:	8082                	ret

Disassembly of section .text.write_pmp_addr:

80004052 <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
80004052:	1141                	add	sp,sp,-16
80004054:	c62a                	sw	a0,12(sp)
80004056:	c42e                	sw	a1,8(sp)
    switch (idx) {
80004058:	4722                	lw	a4,8(sp)
8000405a:	47bd                	li	a5,15
8000405c:	08e7ec63          	bltu	a5,a4,800040f4 <.L38>
80004060:	47a2                	lw	a5,8(sp)
80004062:	00279713          	sll	a4,a5,0x2
80004066:	800037b7          	lui	a5,0x80003
8000406a:	13878793          	add	a5,a5,312 # 80003138 <.L21>
8000406e:	97ba                	add	a5,a5,a4
80004070:	439c                	lw	a5,0(a5)
80004072:	8782                	jr	a5

80004074 <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
80004074:	47b2                	lw	a5,12(sp)
80004076:	3b079073          	csrw	pmpaddr0,a5
        break;
8000407a:	a8b5                	j	800040f6 <.L37>

8000407c <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
8000407c:	47b2                	lw	a5,12(sp)
8000407e:	3b179073          	csrw	pmpaddr1,a5
        break;
80004082:	a895                	j	800040f6 <.L37>

80004084 <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
80004084:	47b2                	lw	a5,12(sp)
80004086:	3b279073          	csrw	pmpaddr2,a5
        break;
8000408a:	a0b5                	j	800040f6 <.L37>

8000408c <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
8000408c:	47b2                	lw	a5,12(sp)
8000408e:	3b379073          	csrw	pmpaddr3,a5
        break;
80004092:	a095                	j	800040f6 <.L37>

80004094 <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
80004094:	47b2                	lw	a5,12(sp)
80004096:	3b479073          	csrw	pmpaddr4,a5
        break;
8000409a:	a8b1                	j	800040f6 <.L37>

8000409c <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
8000409c:	47b2                	lw	a5,12(sp)
8000409e:	3b579073          	csrw	pmpaddr5,a5
        break;
800040a2:	a891                	j	800040f6 <.L37>

800040a4 <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
800040a4:	47b2                	lw	a5,12(sp)
800040a6:	3b679073          	csrw	pmpaddr6,a5
        break;
800040aa:	a0b1                	j	800040f6 <.L37>

800040ac <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
800040ac:	47b2                	lw	a5,12(sp)
800040ae:	3b779073          	csrw	pmpaddr7,a5
        break;
800040b2:	a091                	j	800040f6 <.L37>

800040b4 <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
800040b4:	47b2                	lw	a5,12(sp)
800040b6:	3b879073          	csrw	pmpaddr8,a5
        break;
800040ba:	a835                	j	800040f6 <.L37>

800040bc <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
800040bc:	47b2                	lw	a5,12(sp)
800040be:	3b979073          	csrw	pmpaddr9,a5
        break;
800040c2:	a815                	j	800040f6 <.L37>

800040c4 <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
800040c4:	47b2                	lw	a5,12(sp)
800040c6:	3ba79073          	csrw	pmpaddr10,a5
        break;
800040ca:	a035                	j	800040f6 <.L37>

800040cc <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
800040cc:	47b2                	lw	a5,12(sp)
800040ce:	3bb79073          	csrw	pmpaddr11,a5
        break;
800040d2:	a015                	j	800040f6 <.L37>

800040d4 <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
800040d4:	47b2                	lw	a5,12(sp)
800040d6:	3bc79073          	csrw	pmpaddr12,a5
        break;
800040da:	a831                	j	800040f6 <.L37>

800040dc <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
800040dc:	47b2                	lw	a5,12(sp)
800040de:	3bd79073          	csrw	pmpaddr13,a5
        break;
800040e2:	a811                	j	800040f6 <.L37>

800040e4 <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
800040e4:	47b2                	lw	a5,12(sp)
800040e6:	3be79073          	csrw	pmpaddr14,a5
        break;
800040ea:	a031                	j	800040f6 <.L37>

800040ec <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
800040ec:	47b2                	lw	a5,12(sp)
800040ee:	3bf79073          	csrw	pmpaddr15,a5
        break;
800040f2:	a011                	j	800040f6 <.L37>

800040f4 <.L38>:
    default:
        /* Do nothing */
        break;
800040f4:	0001                	nop

800040f6 <.L37>:
    }
}
800040f6:	0001                	nop
800040f8:	0141                	add	sp,sp,16
800040fa:	8082                	ret

Disassembly of section .text.read_pma_cfg:

8000420e <read_pma_cfg>:
    return ret_val;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
8000420e:	7179                	add	sp,sp,-48
80004210:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
80004212:	d602                	sw	zero,44(sp)
    switch (idx) {
80004214:	4732                	lw	a4,12(sp)
80004216:	478d                	li	a5,3
80004218:	04f70763          	beq	a4,a5,80004266 <.L62>
8000421c:	4732                	lw	a4,12(sp)
8000421e:	478d                	li	a5,3
80004220:	04e7e963          	bltu	a5,a4,80004272 <.L69>
80004224:	4732                	lw	a4,12(sp)
80004226:	4789                	li	a5,2
80004228:	02f70963          	beq	a4,a5,8000425a <.L64>
8000422c:	4732                	lw	a4,12(sp)
8000422e:	4789                	li	a5,2
80004230:	04e7e163          	bltu	a5,a4,80004272 <.L69>
80004234:	47b2                	lw	a5,12(sp)
80004236:	c791                	beqz	a5,80004242 <.L65>
80004238:	4732                	lw	a4,12(sp)
8000423a:	4785                	li	a5,1
8000423c:	00f70963          	beq	a4,a5,8000424e <.L66>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
80004240:	a80d                	j	80004272 <.L69>

80004242 <.L65>:
        pma_cfg = read_csr(CSR_PMACFG0);
80004242:	bc0027f3          	csrr	a5,0xbc0
80004246:	ce3e                	sw	a5,28(sp)
80004248:	47f2                	lw	a5,28(sp)

8000424a <.LBE22>:
8000424a:	d63e                	sw	a5,44(sp)
        break;
8000424c:	a025                	j	80004274 <.L67>

8000424e <.L66>:
        pma_cfg = read_csr(CSR_PMACFG1);
8000424e:	bc1027f3          	csrr	a5,0xbc1
80004252:	d03e                	sw	a5,32(sp)
80004254:	5782                	lw	a5,32(sp)

80004256 <.LBE23>:
80004256:	d63e                	sw	a5,44(sp)
        break;
80004258:	a831                	j	80004274 <.L67>

8000425a <.L64>:
        pma_cfg = read_csr(CSR_PMACFG2);
8000425a:	bc2027f3          	csrr	a5,0xbc2
8000425e:	d23e                	sw	a5,36(sp)
80004260:	5792                	lw	a5,36(sp)

80004262 <.LBE24>:
80004262:	d63e                	sw	a5,44(sp)
        break;
80004264:	a801                	j	80004274 <.L67>

80004266 <.L62>:
        pma_cfg = read_csr(CSR_PMACFG3);
80004266:	bc3027f3          	csrr	a5,0xbc3
8000426a:	d43e                	sw	a5,40(sp)
8000426c:	57a2                	lw	a5,40(sp)

8000426e <.LBE25>:
8000426e:	d63e                	sw	a5,44(sp)
        break;
80004270:	a011                	j	80004274 <.L67>

80004272 <.L69>:
        break;
80004272:	0001                	nop

80004274 <.L67>:
    }
    return pma_cfg;
80004274:	57b2                	lw	a5,44(sp)
}
80004276:	853e                	mv	a0,a5
80004278:	6145                	add	sp,sp,48
8000427a:	8082                	ret

Disassembly of section .text.write_pma_addr:

8000427e <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
8000427e:	1141                	add	sp,sp,-16
80004280:	c62a                	sw	a0,12(sp)
80004282:	c42e                	sw	a1,8(sp)
    switch (idx) {
80004284:	4722                	lw	a4,8(sp)
80004286:	47bd                	li	a5,15
80004288:	08e7ec63          	bltu	a5,a4,80004320 <.L98>
8000428c:	47a2                	lw	a5,8(sp)
8000428e:	00279713          	sll	a4,a5,0x2
80004292:	800037b7          	lui	a5,0x80003
80004296:	17878793          	add	a5,a5,376 # 80003178 <.L81>
8000429a:	97ba                	add	a5,a5,a4
8000429c:	439c                	lw	a5,0(a5)
8000429e:	8782                	jr	a5

800042a0 <.L96>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
800042a0:	47b2                	lw	a5,12(sp)
800042a2:	bd079073          	csrw	0xbd0,a5
        break;
800042a6:	a8b5                	j	80004322 <.L97>

800042a8 <.L95>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
800042a8:	47b2                	lw	a5,12(sp)
800042aa:	bd179073          	csrw	0xbd1,a5
        break;
800042ae:	a895                	j	80004322 <.L97>

800042b0 <.L94>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
800042b0:	47b2                	lw	a5,12(sp)
800042b2:	bd279073          	csrw	0xbd2,a5
        break;
800042b6:	a0b5                	j	80004322 <.L97>

800042b8 <.L93>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
800042b8:	47b2                	lw	a5,12(sp)
800042ba:	bd379073          	csrw	0xbd3,a5
        break;
800042be:	a095                	j	80004322 <.L97>

800042c0 <.L92>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
800042c0:	47b2                	lw	a5,12(sp)
800042c2:	bd479073          	csrw	0xbd4,a5
        break;
800042c6:	a8b1                	j	80004322 <.L97>

800042c8 <.L91>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
800042c8:	47b2                	lw	a5,12(sp)
800042ca:	bd579073          	csrw	0xbd5,a5
        break;
800042ce:	a891                	j	80004322 <.L97>

800042d0 <.L90>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
800042d0:	47b2                	lw	a5,12(sp)
800042d2:	bd679073          	csrw	0xbd6,a5
        break;
800042d6:	a0b1                	j	80004322 <.L97>

800042d8 <.L89>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
800042d8:	47b2                	lw	a5,12(sp)
800042da:	bd779073          	csrw	0xbd7,a5
        break;
800042de:	a091                	j	80004322 <.L97>

800042e0 <.L88>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
800042e0:	47b2                	lw	a5,12(sp)
800042e2:	bd879073          	csrw	0xbd8,a5
        break;
800042e6:	a835                	j	80004322 <.L97>

800042e8 <.L87>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
800042e8:	47b2                	lw	a5,12(sp)
800042ea:	bd979073          	csrw	0xbd9,a5
        break;
800042ee:	a815                	j	80004322 <.L97>

800042f0 <.L86>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
800042f0:	47b2                	lw	a5,12(sp)
800042f2:	bda79073          	csrw	0xbda,a5
        break;
800042f6:	a035                	j	80004322 <.L97>

800042f8 <.L85>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
800042f8:	47b2                	lw	a5,12(sp)
800042fa:	bdb79073          	csrw	0xbdb,a5
        break;
800042fe:	a015                	j	80004322 <.L97>

80004300 <.L84>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
80004300:	47b2                	lw	a5,12(sp)
80004302:	bdc79073          	csrw	0xbdc,a5
        break;
80004306:	a831                	j	80004322 <.L97>

80004308 <.L83>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
80004308:	47b2                	lw	a5,12(sp)
8000430a:	bdd79073          	csrw	0xbdd,a5
        break;
8000430e:	a811                	j	80004322 <.L97>

80004310 <.L82>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
80004310:	47b2                	lw	a5,12(sp)
80004312:	bde79073          	csrw	0xbde,a5
        break;
80004316:	a031                	j	80004322 <.L97>

80004318 <.L80>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
80004318:	47b2                	lw	a5,12(sp)
8000431a:	bdf79073          	csrw	0xbdf,a5
        break;
8000431e:	a011                	j	80004322 <.L97>

80004320 <.L98>:
    default:
        /* Do nothing */
        break;
80004320:	0001                	nop

80004322 <.L97>:
    }
}
80004322:	0001                	nop
80004324:	0141                	add	sp,sp,16
80004326:	8082                	ret

Disassembly of section .text.pmp_config:

8000435a <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
8000435a:	7139                	add	sp,sp,-64
8000435c:	de06                	sw	ra,60(sp)
8000435e:	c62a                	sw	a0,12(sp)
80004360:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
80004362:	4789                	li	a5,2
80004364:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > 15U));
80004366:	47b2                	lw	a5,12(sp)
80004368:	cfcd                	beqz	a5,80004422 <.L125>
8000436a:	47a2                	lw	a5,8(sp)
8000436c:	cbdd                	beqz	a5,80004422 <.L125>
8000436e:	4722                	lw	a4,8(sp)
80004370:	47bd                	li	a5,15
80004372:	0ae7e863          	bltu	a5,a4,80004422 <.L125>

80004376 <.LBB43>:

        for (uint32_t i = 0; i < num_of_entries; i++) {
80004376:	d402                	sw	zero,40(sp)
80004378:	a871                	j	80004414 <.L126>

8000437a <.L127>:
            uint32_t idx = i / 4;
8000437a:	57a2                	lw	a5,40(sp)
8000437c:	8389                	srl	a5,a5,0x2
8000437e:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
80004380:	57a2                	lw	a5,40(sp)
80004382:	078e                	sll	a5,a5,0x3
80004384:	8be1                	and	a5,a5,24
80004386:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
80004388:	5512                	lw	a0,36(sp)
8000438a:	3105                	jal	80003faa <read_pmp_cfg>
8000438c:	ce2a                	sw	a0,28(sp)
            pmp_cfg &= ~(0xFFUL << offset);
8000438e:	5782                	lw	a5,32(sp)
80004390:	0ff00713          	li	a4,255
80004394:	00f717b3          	sll	a5,a4,a5
80004398:	fff7c793          	not	a5,a5
8000439c:	4772                	lw	a4,28(sp)
8000439e:	8ff9                	and	a5,a5,a4
800043a0:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t) entry->pmp_cfg.val) << offset;
800043a2:	47b2                	lw	a5,12(sp)
800043a4:	0007c783          	lbu	a5,0(a5)
800043a8:	873e                	mv	a4,a5
800043aa:	5782                	lw	a5,32(sp)
800043ac:	00f717b3          	sll	a5,a4,a5
800043b0:	4772                	lw	a4,28(sp)
800043b2:	8fd9                	or	a5,a5,a4
800043b4:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
800043b6:	47b2                	lw	a5,12(sp)
800043b8:	43dc                	lw	a5,4(a5)
800043ba:	55a2                	lw	a1,40(sp)
800043bc:	853e                	mv	a0,a5
800043be:	3951                	jal	80004052 <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
800043c0:	5592                	lw	a1,36(sp)
800043c2:	4572                	lw	a0,28(sp)
800043c4:	164050ef          	jal	80009528 <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
800043c8:	5512                	lw	a0,36(sp)
800043ca:	3591                	jal	8000420e <read_pma_cfg>
800043cc:	cc2a                	sw	a0,24(sp)
            pma_cfg &= ~(0xFFUL << offset);
800043ce:	5782                	lw	a5,32(sp)
800043d0:	0ff00713          	li	a4,255
800043d4:	00f717b3          	sll	a5,a4,a5
800043d8:	fff7c793          	not	a5,a5
800043dc:	4762                	lw	a4,24(sp)
800043de:	8ff9                	and	a5,a5,a4
800043e0:	cc3e                	sw	a5,24(sp)
            pma_cfg |= ((uint32_t) entry->pma_cfg.val) << offset;
800043e2:	47b2                	lw	a5,12(sp)
800043e4:	0087c783          	lbu	a5,8(a5)
800043e8:	873e                	mv	a4,a5
800043ea:	5782                	lw	a5,32(sp)
800043ec:	00f717b3          	sll	a5,a4,a5
800043f0:	4762                	lw	a4,24(sp)
800043f2:	8fd9                	or	a5,a5,a4
800043f4:	cc3e                	sw	a5,24(sp)
            write_pma_cfg(pma_cfg, idx);
800043f6:	5592                	lw	a1,36(sp)
800043f8:	4562                	lw	a0,24(sp)
800043fa:	18a050ef          	jal	80009584 <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
800043fe:	47b2                	lw	a5,12(sp)
80004400:	47dc                	lw	a5,12(a5)
80004402:	55a2                	lw	a1,40(sp)
80004404:	853e                	mv	a0,a5
80004406:	3da5                	jal	8000427e <write_pma_addr>
#endif
            ++entry;
80004408:	47b2                	lw	a5,12(sp)
8000440a:	07c1                	add	a5,a5,16
8000440c:	c63e                	sw	a5,12(sp)

8000440e <.LBE44>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
8000440e:	57a2                	lw	a5,40(sp)
80004410:	0785                	add	a5,a5,1
80004412:	d43e                	sw	a5,40(sp)

80004414 <.L126>:
80004414:	5722                	lw	a4,40(sp)
80004416:	47a2                	lw	a5,8(sp)
80004418:	f6f761e3          	bltu	a4,a5,8000437a <.L127>

8000441c <.LBE43>:
        }
        fencei();
8000441c:	0000100f          	fence.i

        status = status_success;
80004420:	d602                	sw	zero,44(sp)

80004422 <.L125>:

    } while (false);

    return status;
80004422:	57b2                	lw	a5,44(sp)
}
80004424:	853e                	mv	a0,a5
80004426:	50f2                	lw	ra,60(sp)
80004428:	6121                	add	sp,sp,64
8000442a:	8082                	ret

Disassembly of section .text.spi_master_get_default_timing_config:

8000444a <spi_master_get_default_timing_config>:
    }
    return status_success;
}

void spi_master_get_default_timing_config(spi_timing_config_t *config)
{
8000444a:	1141                	add	sp,sp,-16
8000444c:	c62a                	sw	a0,12(sp)
    config->master_config.cs2sclk = spi_cs2sclk_half_sclk_4;
8000444e:	47b2                	lw	a5,12(sp)
80004450:	470d                	li	a4,3
80004452:	00e78423          	sb	a4,8(a5)
    config->master_config.csht = spi_csht_half_sclk_12;
80004456:	47b2                	lw	a5,12(sp)
80004458:	472d                	li	a4,11
8000445a:	00e784a3          	sb	a4,9(a5)
}
8000445e:	0001                	nop
80004460:	0141                	add	sp,sp,16
80004462:	8082                	ret

Disassembly of section .text.spi_master_get_default_control_config:

80004472 <spi_master_get_default_control_config>:
    config->common_config.cpol = spi_sclk_high_idle;
    config->common_config.cpha = spi_sclk_sampling_even_clk_edges;
}

void spi_master_get_default_control_config(spi_control_config_t *config)
{
80004472:	1141                	add	sp,sp,-16
80004474:	c62a                	sw	a0,12(sp)
    config->master_config.cmd_enable = false;
80004476:	47b2                	lw	a5,12(sp)
80004478:	00078023          	sb	zero,0(a5)
    config->master_config.addr_enable = false;
8000447c:	47b2                	lw	a5,12(sp)
8000447e:	000780a3          	sb	zero,1(a5)
    config->master_config.token_enable = false;
80004482:	47b2                	lw	a5,12(sp)
80004484:	000781a3          	sb	zero,3(a5)
    config->master_config.token_value = spi_token_value_0x00;
80004488:	47b2                	lw	a5,12(sp)
8000448a:	00078223          	sb	zero,4(a5)
    config->master_config.addr_phase_fmt = spi_address_phase_format_single_io_mode;
8000448e:	47b2                	lw	a5,12(sp)
80004490:	00078123          	sb	zero,2(a5)
    config->common_config.tx_dma_enable = false;
80004494:	47b2                	lw	a5,12(sp)
80004496:	00078323          	sb	zero,6(a5)
    config->common_config.rx_dma_enable = false;
8000449a:	47b2                	lw	a5,12(sp)
8000449c:	000783a3          	sb	zero,7(a5)
    config->common_config.trans_mode = spi_trans_write_only;
800044a0:	47b2                	lw	a5,12(sp)
800044a2:	4705                	li	a4,1
800044a4:	00e78423          	sb	a4,8(a5)
    config->common_config.data_phase_fmt = spi_single_io_mode;
800044a8:	47b2                	lw	a5,12(sp)
800044aa:	000784a3          	sb	zero,9(a5)
    config->common_config.dummy_cnt = spi_dummy_count_2;
800044ae:	47b2                	lw	a5,12(sp)
800044b0:	4705                	li	a4,1
800044b2:	00e78523          	sb	a4,10(a5)
#if defined(HPM_IP_FEATURE_SPI_CS_SELECT) && (HPM_IP_FEATURE_SPI_CS_SELECT == 1)
    config->common_config.cs_index = spi_cs_0;
#endif
}
800044b6:	0001                	nop
800044b8:	0141                	add	sp,sp,16
800044ba:	8082                	ret

Disassembly of section .text.spi_master_timing_init:

800044c6 <spi_master_timing_init>:
    config->common_config.cs_index = spi_cs_0;
#endif
}

hpm_stat_t spi_master_timing_init(SPI_Type *ptr, spi_timing_config_t *config)
{
800044c6:	1101                	add	sp,sp,-32
800044c8:	c62a                	sw	a0,12(sp)
800044ca:	c42e                	sw	a1,8(sp)
    uint8_t sclk_div;
    uint32_t div_remainder;
    uint32_t div_integer;
    if (config->master_config.sclk_freq_in_hz == 0) {
800044cc:	47a2                	lw	a5,8(sp)
800044ce:	43dc                	lw	a5,4(a5)
800044d0:	e399                	bnez	a5,800044d6 <.L101>
        return status_invalid_argument;
800044d2:	4789                	li	a5,2
800044d4:	a059                	j	8000455a <.L102>

800044d6 <.L101>:
    }

    if (config->master_config.clk_src_freq_in_hz > config->master_config.sclk_freq_in_hz) {
800044d6:	47a2                	lw	a5,8(sp)
800044d8:	4398                	lw	a4,0(a5)
800044da:	47a2                	lw	a5,8(sp)
800044dc:	43dc                	lw	a5,4(a5)
800044de:	04e7f463          	bgeu	a5,a4,80004526 <.L103>
        div_remainder = (config->master_config.clk_src_freq_in_hz % config->master_config.sclk_freq_in_hz);
800044e2:	47a2                	lw	a5,8(sp)
800044e4:	4398                	lw	a4,0(a5)
800044e6:	47a2                	lw	a5,8(sp)
800044e8:	43dc                	lw	a5,4(a5)
800044ea:	02f777b3          	remu	a5,a4,a5
800044ee:	cc3e                	sw	a5,24(sp)
        div_integer  = (config->master_config.clk_src_freq_in_hz / config->master_config.sclk_freq_in_hz);
800044f0:	47a2                	lw	a5,8(sp)
800044f2:	4398                	lw	a4,0(a5)
800044f4:	47a2                	lw	a5,8(sp)
800044f6:	43dc                	lw	a5,4(a5)
800044f8:	02f757b3          	divu	a5,a4,a5
800044fc:	ca3e                	sw	a5,20(sp)
        if ((div_remainder != 0) || ((div_integer % 2) != 0) ||
800044fe:	47e2                	lw	a5,24(sp)
80004500:	eb89                	bnez	a5,80004512 <.L104>
80004502:	47d2                	lw	a5,20(sp)
80004504:	8b85                	and	a5,a5,1
80004506:	e791                	bnez	a5,80004512 <.L104>
80004508:	4752                	lw	a4,20(sp)
8000450a:	1fe00793          	li	a5,510
8000450e:	00e7f463          	bgeu	a5,a4,80004516 <.L105>

80004512 <.L104>:
            (div_integer > 510)) {  /* div_integer must be less than or equal to ((SCLK_DIV + 1) * 2), SCLK_DIV max value is 0xFE */
            return status_invalid_argument;
80004512:	4789                	li	a5,2
80004514:	a099                	j	8000455a <.L102>

80004516 <.L105>:
        }
        sclk_div = (div_integer / 2) - 1;
80004516:	47d2                	lw	a5,20(sp)
80004518:	8385                	srl	a5,a5,0x1
8000451a:	0ff7f793          	zext.b	a5,a5
8000451e:	17fd                	add	a5,a5,-1
80004520:	00f10fa3          	sb	a5,31(sp)
80004524:	a021                	j	8000452c <.L106>

80004526 <.L103>:
    } else {
        sclk_div = 0xff;
80004526:	57fd                	li	a5,-1
80004528:	00f10fa3          	sb	a5,31(sp)

8000452c <.L106>:
    }

     ptr->TIMING = SPI_TIMING_CS2SCLK_SET(config->master_config.cs2sclk) |
8000452c:	47a2                	lw	a5,8(sp)
8000452e:	0087c783          	lbu	a5,8(a5)
80004532:	00c79713          	sll	a4,a5,0xc
80004536:	678d                	lui	a5,0x3
80004538:	8f7d                	and	a4,a4,a5
                   SPI_TIMING_CSHT_SET(config->master_config.csht) |
8000453a:	47a2                	lw	a5,8(sp)
8000453c:	0097c783          	lbu	a5,9(a5) # 3009 <__APB_SRAM_segment_size__+0x1009>
80004540:	00879693          	sll	a3,a5,0x8
80004544:	6785                	lui	a5,0x1
80004546:	f0078793          	add	a5,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
8000454a:	8ff5                	and	a5,a5,a3
     ptr->TIMING = SPI_TIMING_CS2SCLK_SET(config->master_config.cs2sclk) |
8000454c:	8f5d                	or	a4,a4,a5
                   SPI_TIMING_SCLK_DIV_SET(sclk_div);
8000454e:	01f14783          	lbu	a5,31(sp)
                   SPI_TIMING_CSHT_SET(config->master_config.csht) |
80004552:	8f5d                	or	a4,a4,a5
     ptr->TIMING = SPI_TIMING_CS2SCLK_SET(config->master_config.cs2sclk) |
80004554:	47b2                	lw	a5,12(sp)
80004556:	c3b8                	sw	a4,64(a5)

    return status_success;
80004558:	4781                	li	a5,0

8000455a <.L102>:
}
8000455a:	853e                	mv	a0,a5
8000455c:	6105                	add	sp,sp,32
8000455e:	8082                	ret

Disassembly of section .text.spi_control_init:

8000456a <spi_control_init>:
                    SPI_TRANSFMT_CPOL_SET(config->common_config.cpol) |
                    SPI_TRANSFMT_CPHA_SET(config->common_config.cpha);
}

hpm_stat_t spi_control_init(SPI_Type *ptr, spi_control_config_t *config, uint32_t wcount, uint32_t rcount)
{
8000456a:	1101                	add	sp,sp,-32
8000456c:	c62a                	sw	a0,12(sp)
8000456e:	c42e                	sw	a1,8(sp)
80004570:	c232                	sw	a2,4(sp)
80004572:	c036                	sw	a3,0(sp)
    uint8_t mode;
#if defined(SPI_SOC_TRANSFER_COUNT_MAX) && (SPI_SOC_TRANSFER_COUNT_MAX == 512)
    if ((wcount > SPI_SOC_TRANSFER_COUNT_MAX) || (rcount > SPI_SOC_TRANSFER_COUNT_MAX)) {
80004574:	4712                	lw	a4,4(sp)
80004576:	20000793          	li	a5,512
8000457a:	00e7e763          	bltu	a5,a4,80004588 <.L109>
8000457e:	4702                	lw	a4,0(sp)
80004580:	20000793          	li	a5,512
80004584:	00e7f463          	bgeu	a5,a4,8000458c <.L110>

80004588 <.L109>:
        return status_invalid_argument;
80004588:	4789                	li	a5,2
8000458a:	a8d5                	j	8000467e <.L111>

8000458c <.L110>:
    }
#endif

    /* read spi control mode */
    mode = (ptr->TRANSFMT & SPI_TRANSFMT_SLVMODE_MASK) >> SPI_TRANSFMT_SLVMODE_SHIFT;
8000458c:	47b2                	lw	a5,12(sp)
8000458e:	4b9c                	lw	a5,16(a5)
80004590:	8389                	srl	a5,a5,0x2
80004592:	0ff7f793          	zext.b	a5,a5
80004596:	8b85                	and	a5,a5,1
80004598:	00f10fa3          	sb	a5,31(sp)

    /* slave data only mode only works on write read together transfer mode */
    if ((config->slave_config.slave_data_only == true) &&
8000459c:	47a2                	lw	a5,8(sp)
8000459e:	0057c783          	lbu	a5,5(a5)
800045a2:	cf81                	beqz	a5,800045ba <.L112>
        (config->common_config.trans_mode != spi_trans_write_read_together) &&
800045a4:	47a2                	lw	a5,8(sp)
800045a6:	0087c783          	lbu	a5,8(a5)
    if ((config->slave_config.slave_data_only == true) &&
800045aa:	cb81                	beqz	a5,800045ba <.L112>
        (config->common_config.trans_mode != spi_trans_write_read_together) &&
800045ac:	01f14703          	lbu	a4,31(sp)
800045b0:	4785                	li	a5,1
800045b2:	00f71463          	bne	a4,a5,800045ba <.L112>
        (mode == spi_slave_mode)) {
        return status_invalid_argument;
800045b6:	4789                	li	a5,2
800045b8:	a0d9                	j	8000467e <.L111>

800045ba <.L112>:
    }

    ptr->TRANSCTRL = SPI_TRANSCTRL_SLVDATAONLY_SET(config->slave_config.slave_data_only) |
800045ba:	47a2                	lw	a5,8(sp)
800045bc:	0057c783          	lbu	a5,5(a5)
800045c0:	01f79713          	sll	a4,a5,0x1f
                     SPI_TRANSCTRL_CMDEN_SET(config->master_config.cmd_enable) |
800045c4:	47a2                	lw	a5,8(sp)
800045c6:	0007c783          	lbu	a5,0(a5)
800045ca:	01e79693          	sll	a3,a5,0x1e
800045ce:	400007b7          	lui	a5,0x40000
800045d2:	8ff5                	and	a5,a5,a3
    ptr->TRANSCTRL = SPI_TRANSCTRL_SLVDATAONLY_SET(config->slave_config.slave_data_only) |
800045d4:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_ADDREN_SET(config->master_config.addr_enable) |
800045d6:	47a2                	lw	a5,8(sp)
800045d8:	0017c783          	lbu	a5,1(a5) # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
800045dc:	01d79693          	sll	a3,a5,0x1d
800045e0:	200007b7          	lui	a5,0x20000
800045e4:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_CMDEN_SET(config->master_config.cmd_enable) |
800045e6:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_ADDRFMT_SET(config->master_config.addr_phase_fmt) |
800045e8:	47a2                	lw	a5,8(sp)
800045ea:	0027c783          	lbu	a5,2(a5) # 20000002 <__SHARE_RAM_segment_end__+0x1ee80002>
800045ee:	01c79693          	sll	a3,a5,0x1c
800045f2:	100007b7          	lui	a5,0x10000
800045f6:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_ADDREN_SET(config->master_config.addr_enable) |
800045f8:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_TRANSMODE_SET(config->common_config.trans_mode) |
800045fa:	47a2                	lw	a5,8(sp)
800045fc:	0087c783          	lbu	a5,8(a5) # 10000008 <__SHARE_RAM_segment_end__+0xee80008>
80004600:	01879693          	sll	a3,a5,0x18
80004604:	0f0007b7          	lui	a5,0xf000
80004608:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_ADDRFMT_SET(config->master_config.addr_phase_fmt) |
8000460a:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_DUALQUAD_SET(config->common_config.data_phase_fmt) |
8000460c:	47a2                	lw	a5,8(sp)
8000460e:	0097c783          	lbu	a5,9(a5) # f000009 <__SHARE_RAM_segment_end__+0xde80009>
80004612:	01679693          	sll	a3,a5,0x16
80004616:	00c007b7          	lui	a5,0xc00
8000461a:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_TRANSMODE_SET(config->common_config.trans_mode) |
8000461c:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_TOKENEN_SET(config->master_config.token_enable) |
8000461e:	47a2                	lw	a5,8(sp)
80004620:	0037c783          	lbu	a5,3(a5) # c00003 <_flash_size+0x400003>
80004624:	01579693          	sll	a3,a5,0x15
80004628:	002007b7          	lui	a5,0x200
8000462c:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_DUALQUAD_SET(config->common_config.data_phase_fmt) |
8000462e:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_WRTRANCNT_SET(wcount - 1) |
80004630:	4792                	lw	a5,4(sp)
80004632:	17fd                	add	a5,a5,-1 # 1fffff <__DLM_segment_end__+0x13ffff>
80004634:	00c79693          	sll	a3,a5,0xc
80004638:	001ff7b7          	lui	a5,0x1ff
8000463c:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_TOKENEN_SET(config->master_config.token_enable) |
8000463e:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_TOKENVALUE_SET(config->master_config.token_value) |
80004640:	47a2                	lw	a5,8(sp)
80004642:	0047c783          	lbu	a5,4(a5) # 1ff004 <__DLM_segment_end__+0x13f004>
80004646:	00b79693          	sll	a3,a5,0xb
8000464a:	6785                	lui	a5,0x1
8000464c:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x402>
80004650:	8ff5                	and	a5,a5,a3
                     SPI_TRANSCTRL_WRTRANCNT_SET(wcount - 1) |
80004652:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_DUMMYCNT_SET(config->common_config.dummy_cnt) |
80004654:	47a2                	lw	a5,8(sp)
80004656:	00a7c783          	lbu	a5,10(a5)
8000465a:	07a6                	sll	a5,a5,0x9
8000465c:	6007f793          	and	a5,a5,1536
                     SPI_TRANSCTRL_TOKENVALUE_SET(config->master_config.token_value) |
80004660:	8f5d                	or	a4,a4,a5
                     SPI_TRANSCTRL_RDTRANCNT_SET(rcount - 1);
80004662:	4782                	lw	a5,0(sp)
80004664:	17fd                	add	a5,a5,-1
80004666:	1ff7f793          	and	a5,a5,511
                     SPI_TRANSCTRL_DUMMYCNT_SET(config->common_config.dummy_cnt) |
8000466a:	8f5d                	or	a4,a4,a5
    ptr->TRANSCTRL = SPI_TRANSCTRL_SLVDATAONLY_SET(config->slave_config.slave_data_only) |
8000466c:	47b2                	lw	a5,12(sp)
8000466e:	d398                	sw	a4,32(a5)
    ptr->WR_TRANS_CNT = wcount - 1;
    ptr->RD_TRANS_CNT = rcount - 1;
#endif

    /* reset txfifo, rxfifo and control */
    ptr->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
80004670:	47b2                	lw	a5,12(sp)
80004672:	5b9c                	lw	a5,48(a5)
80004674:	0077e713          	or	a4,a5,7
80004678:	47b2                	lw	a5,12(sp)
8000467a:	db98                	sw	a4,48(a5)

    return status_success;
8000467c:	4781                	li	a5,0

8000467e <.L111>:
}
8000467e:	853e                	mv	a0,a5
80004680:	6105                	add	sp,sp,32
80004682:	8082                	ret

Disassembly of section .text.uart_default_config:

80004a90 <uart_default_config>:
#ifndef UART_SOC_OVERSAMPLE_MAX
#define UART_SOC_OVERSAMPLE_MAX HPM_UART_OSC_MAX
#endif

void uart_default_config(UART_Type *ptr, uart_config_t *config)
{
80004a90:	1141                	add	sp,sp,-16
80004a92:	c62a                	sw	a0,12(sp)
80004a94:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->baudrate = 115200;
80004a96:	47a2                	lw	a5,8(sp)
80004a98:	6771                	lui	a4,0x1c
80004a9a:	20070713          	add	a4,a4,512 # 1c200 <__XPI0_segment_used_size__+0x101ac>
80004a9e:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80004aa0:	47a2                	lw	a5,8(sp)
80004aa2:	470d                	li	a4,3
80004aa4:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
80004aa8:	47a2                	lw	a5,8(sp)
80004aaa:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80004aae:	47a2                	lw	a5,8(sp)
80004ab0:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
80004ab4:	47a2                	lw	a5,8(sp)
80004ab6:	4705                	li	a4,1
80004ab8:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
80004abc:	47a2                	lw	a5,8(sp)
80004abe:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
80004ac2:	47a2                	lw	a5,8(sp)
80004ac4:	000785a3          	sb	zero,11(a5)
    config->dma_enable = false;
80004ac8:	47a2                	lw	a5,8(sp)
80004aca:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
80004ace:	47a2                	lw	a5,8(sp)
80004ad0:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
80004ad4:	47a2                	lw	a5,8(sp)
80004ad6:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
80004ada:	47a2                	lw	a5,8(sp)
80004adc:	000788a3          	sb	zero,17(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
#endif
#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    config->rx_enable = true;
#endif
}
80004ae0:	0001                	nop
80004ae2:	0141                	add	sp,sp,16
80004ae4:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

80004ae6 <uart_calculate_baudrate>:

static bool uart_calculate_baudrate(uint32_t freq, uint32_t baudrate, uint16_t *div_out, uint8_t *osc_out)
{
80004ae6:	7179                	add	sp,sp,-48
80004ae8:	d606                	sw	ra,44(sp)
80004aea:	d422                	sw	s0,40(sp)
80004aec:	c62a                	sw	a0,12(sp)
80004aee:	c42e                	sw	a1,8(sp)
80004af0:	c232                	sw	a2,4(sp)
80004af2:	c036                	sw	a3,0(sp)
    uint16_t div, osc, delta;
    float tmp;
    if ((div_out == NULL) || (!freq) || (!baudrate)
80004af4:	4792                	lw	a5,4(sp)
80004af6:	cb85                	beqz	a5,80004b26 <.L4>
80004af8:	47b2                	lw	a5,12(sp)
80004afa:	c795                	beqz	a5,80004b26 <.L4>
80004afc:	47a2                	lw	a5,8(sp)
80004afe:	c785                	beqz	a5,80004b26 <.L4>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
80004b00:	4722                	lw	a4,8(sp)
80004b02:	0c700793          	li	a5,199
80004b06:	02e7f063          	bgeu	a5,a4,80004b26 <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
80004b0a:	47a2                	lw	a5,8(sp)
80004b0c:	078e                	sll	a5,a5,0x3
80004b0e:	4732                	lw	a4,12(sp)
80004b10:	00f76b63          	bltu	a4,a5,80004b26 <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
80004b14:	4732                	lw	a4,12(sp)
80004b16:	67c1                	lui	a5,0x10
80004b18:	17fd                	add	a5,a5,-1 # ffff <__XPI0_segment_used_size__+0x3fab>
80004b1a:	02f75733          	divu	a4,a4,a5
80004b1e:	47a2                	lw	a5,8(sp)
80004b20:	0796                	sll	a5,a5,0x5
80004b22:	00e7f463          	bgeu	a5,a4,80004b2a <.L5>

80004b26 <.L4>:
        return 0;
80004b26:	4781                	li	a5,0
80004b28:	aa8d                	j	80004c9a <.L6>

80004b2a <.L5>:
    }

    tmp = (float) freq / baudrate;
80004b2a:	4532                	lw	a0,12(sp)
80004b2c:	478030ef          	jal	80007fa4 <__floatunsisf>
80004b30:	842a                	mv	s0,a0
80004b32:	4522                	lw	a0,8(sp)
80004b34:	470030ef          	jal	80007fa4 <__floatunsisf>
80004b38:	87aa                	mv	a5,a0
80004b3a:	85be                	mv	a1,a5
80004b3c:	8522                	mv	a0,s0
80004b3e:	2fd080ef          	jal	8000d63a <__divsf3>
80004b42:	87aa                	mv	a5,a0
80004b44:	cc3e                	sw	a5,24(sp)

    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80004b46:	47a1                	li	a5,8
80004b48:	00f11f23          	sh	a5,30(sp)
80004b4c:	a281                	j	80004c8c <.L7>

80004b4e <.L18>:
        /* osc range: HPM_UART_OSC_MIN - UART_SOC_OVERSAMPLE_MAX, even number */
        delta = 0;
80004b4e:	00011e23          	sh	zero,28(sp)
        div = (uint16_t)(tmp / osc);
80004b52:	01e15783          	lhu	a5,30(sp)
80004b56:	853e                	mv	a0,a5
80004b58:	3e6030ef          	jal	80007f3e <__floatsisf>
80004b5c:	87aa                	mv	a5,a0
80004b5e:	85be                	mv	a1,a5
80004b60:	4562                	lw	a0,24(sp)
80004b62:	2d9080ef          	jal	8000d63a <__divsf3>
80004b66:	87aa                	mv	a5,a0
80004b68:	853e                	mv	a0,a5
80004b6a:	370030ef          	jal	80007eda <__fixunssfsi>
80004b6e:	87aa                	mv	a5,a0
80004b70:	00f11b23          	sh	a5,22(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN) {
80004b74:	01615783          	lhu	a5,22(sp)
80004b78:	10078263          	beqz	a5,80004c7c <.L22>
            /* invalid div */
            continue;
        }
        if (div * osc > tmp) {
80004b7c:	01615703          	lhu	a4,22(sp)
80004b80:	01e15783          	lhu	a5,30(sp)
80004b84:	02f707b3          	mul	a5,a4,a5
80004b88:	853e                	mv	a0,a5
80004b8a:	3b4030ef          	jal	80007f3e <__floatsisf>
80004b8e:	87aa                	mv	a5,a0
80004b90:	85be                	mv	a1,a5
80004b92:	4562                	lw	a0,24(sp)
80004b94:	266030ef          	jal	80007dfa <__ltsf2>
80004b98:	87aa                	mv	a5,a0
80004b9a:	0207d863          	bgez	a5,80004bca <.L21>
            delta = (uint16_t)(div * osc - tmp);
80004b9e:	01615703          	lhu	a4,22(sp)
80004ba2:	01e15783          	lhu	a5,30(sp)
80004ba6:	02f707b3          	mul	a5,a4,a5
80004baa:	853e                	mv	a0,a5
80004bac:	392030ef          	jal	80007f3e <__floatsisf>
80004bb0:	87aa                	mv	a5,a0
80004bb2:	45e2                	lw	a1,24(sp)
80004bb4:	853e                	mv	a0,a5
80004bb6:	08e030ef          	jal	80007c44 <__subsf3>
80004bba:	87aa                	mv	a5,a0
80004bbc:	853e                	mv	a0,a5
80004bbe:	31c030ef          	jal	80007eda <__fixunssfsi>
80004bc2:	87aa                	mv	a5,a0
80004bc4:	00f11e23          	sh	a5,28(sp)
80004bc8:	a0b9                	j	80004c16 <.L12>

80004bca <.L21>:
        } else if (div * osc < tmp) {
80004bca:	01615703          	lhu	a4,22(sp)
80004bce:	01e15783          	lhu	a5,30(sp)
80004bd2:	02f707b3          	mul	a5,a4,a5
80004bd6:	853e                	mv	a0,a5
80004bd8:	366030ef          	jal	80007f3e <__floatsisf>
80004bdc:	87aa                	mv	a5,a0
80004bde:	85be                	mv	a1,a5
80004be0:	4562                	lw	a0,24(sp)
80004be2:	288030ef          	jal	80007e6a <__gtsf2>
80004be6:	87aa                	mv	a5,a0
80004be8:	02f05763          	blez	a5,80004c16 <.L12>
            delta = (uint16_t)(tmp - div * osc);
80004bec:	01615703          	lhu	a4,22(sp)
80004bf0:	01e15783          	lhu	a5,30(sp)
80004bf4:	02f707b3          	mul	a5,a4,a5
80004bf8:	853e                	mv	a0,a5
80004bfa:	344030ef          	jal	80007f3e <__floatsisf>
80004bfe:	87aa                	mv	a5,a0
80004c00:	85be                	mv	a1,a5
80004c02:	4562                	lw	a0,24(sp)
80004c04:	040030ef          	jal	80007c44 <__subsf3>
80004c08:	87aa                	mv	a5,a0
80004c0a:	853e                	mv	a0,a5
80004c0c:	2ce030ef          	jal	80007eda <__fixunssfsi>
80004c10:	87aa                	mv	a5,a0
80004c12:	00f11e23          	sh	a5,28(sp)

80004c16 <.L12>:
        }
        if (delta && ((delta * 100 / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
80004c16:	01c15783          	lhu	a5,28(sp)
80004c1a:	cb9d                	beqz	a5,80004c50 <.L14>
80004c1c:	01c15703          	lhu	a4,28(sp)
80004c20:	06400793          	li	a5,100
80004c24:	02f707b3          	mul	a5,a4,a5
80004c28:	853e                	mv	a0,a5
80004c2a:	314030ef          	jal	80007f3e <__floatsisf>
80004c2e:	87aa                	mv	a5,a0
80004c30:	45e2                	lw	a1,24(sp)
80004c32:	853e                	mv	a0,a5
80004c34:	207080ef          	jal	8000d63a <__divsf3>
80004c38:	87aa                	mv	a5,a0
80004c3a:	873e                	mv	a4,a5
80004c3c:	800037b7          	lui	a5,0x80003
80004c40:	07c7a583          	lw	a1,124(a5) # 8000307c <.LC0>
80004c44:	853a                	mv	a0,a4
80004c46:	224030ef          	jal	80007e6a <__gtsf2>
80004c4a:	87aa                	mv	a5,a0
80004c4c:	02f04a63          	bgtz	a5,80004c80 <.L23>

80004c50 <.L14>:
            continue;
        } else {
            *div_out = div;
80004c50:	4792                	lw	a5,4(sp)
80004c52:	01615703          	lhu	a4,22(sp)
80004c56:	00e79023          	sh	a4,0(a5)
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
80004c5a:	01e15703          	lhu	a4,30(sp)
80004c5e:	02000793          	li	a5,32
80004c62:	00f70763          	beq	a4,a5,80004c70 <.L16>
80004c66:	01e15783          	lhu	a5,30(sp)
80004c6a:	0ff7f793          	zext.b	a5,a5
80004c6e:	a011                	j	80004c72 <.L17>

80004c70 <.L16>:
80004c70:	4781                	li	a5,0

80004c72 <.L17>:
80004c72:	4702                	lw	a4,0(sp)
80004c74:	00f70023          	sb	a5,0(a4)
            return true;
80004c78:	4785                	li	a5,1
80004c7a:	a005                	j	80004c9a <.L6>

80004c7c <.L22>:
            continue;
80004c7c:	0001                	nop
80004c7e:	a011                	j	80004c82 <.L9>

80004c80 <.L23>:
            continue;
80004c80:	0001                	nop

80004c82 <.L9>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80004c82:	01e15783          	lhu	a5,30(sp)
80004c86:	0789                	add	a5,a5,2
80004c88:	00f11f23          	sh	a5,30(sp)

80004c8c <.L7>:
80004c8c:	01e15703          	lhu	a4,30(sp)
80004c90:	02000793          	li	a5,32
80004c94:	eae7fde3          	bgeu	a5,a4,80004b4e <.L18>
        }
    }
    return false;
80004c98:	4781                	li	a5,0

80004c9a <.L6>:
}
80004c9a:	853e                	mv	a0,a5
80004c9c:	50b2                	lw	ra,44(sp)
80004c9e:	5422                	lw	s0,40(sp)
80004ca0:	6145                	add	sp,sp,48
80004ca2:	8082                	ret

Disassembly of section .text.uart_send_byte:

80004ca4 <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
80004ca4:	1101                	add	sp,sp,-32
80004ca6:	c62a                	sw	a0,12(sp)
80004ca8:	87ae                	mv	a5,a1
80004caa:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
80004cae:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
80004cb0:	a811                	j	80004cc4 <.L49>

80004cb2 <.L52>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
80004cb2:	4772                	lw	a4,28(sp)
80004cb4:	6785                	lui	a5,0x1
80004cb6:	38878793          	add	a5,a5,904 # 1388 <__fw_size__+0x388>
80004cba:	00e7eb63          	bltu	a5,a4,80004cd0 <.L55>
            break;
        }
        retry++;
80004cbe:	47f2                	lw	a5,28(sp)
80004cc0:	0785                	add	a5,a5,1
80004cc2:	ce3e                	sw	a5,28(sp)

80004cc4 <.L49>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
80004cc4:	47b2                	lw	a5,12(sp)
80004cc6:	5bdc                	lw	a5,52(a5)
80004cc8:	0207f793          	and	a5,a5,32
80004ccc:	d3fd                	beqz	a5,80004cb2 <.L52>
80004cce:	a011                	j	80004cd2 <.L51>

80004cd0 <.L55>:
            break;
80004cd0:	0001                	nop

80004cd2 <.L51>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
80004cd2:	4772                	lw	a4,28(sp)
80004cd4:	6785                	lui	a5,0x1
80004cd6:	38878793          	add	a5,a5,904 # 1388 <__fw_size__+0x388>
80004cda:	00e7f463          	bgeu	a5,a4,80004ce2 <.L53>
        return status_timeout;
80004cde:	478d                	li	a5,3
80004ce0:	a031                	j	80004cec <.L54>

80004ce2 <.L53>:
    }

    ptr->THR = UART_THR_THR_SET(c);
80004ce2:	00b14703          	lbu	a4,11(sp)
80004ce6:	47b2                	lw	a5,12(sp)
80004ce8:	d398                	sw	a4,32(a5)
    return status_success;
80004cea:	4781                	li	a5,0

80004cec <.L54>:
}
80004cec:	853e                	mv	a0,a5
80004cee:	6105                	add	sp,sp,32
80004cf0:	8082                	ret

Disassembly of section .text.loopback_tcpc:

80004cf2 <loopback_tcpc>:
   return 1;
}


int32_t loopback_tcpc(uint8_t sn, uint8_t* buf, uint8_t* destip, uint16_t destport)
{
80004cf2:	7179                	add	sp,sp,-48
80004cf4:	d606                	sw	ra,44(sp)
80004cf6:	87aa                	mv	a5,a0
80004cf8:	c42e                	sw	a1,8(sp)
80004cfa:	c232                	sw	a2,4(sp)
80004cfc:	8736                	mv	a4,a3
80004cfe:	00f107a3          	sb	a5,15(sp)
80004d02:	87ba                	mv	a5,a4
80004d04:	00f11623          	sh	a5,12(sp)
   static uint8_t connect_flag = 0;
   int32_t ret; // return value for SOCK_ERRORs
   uint16_t size = 0, sentsize=0;
80004d08:	00011f23          	sh	zero,30(sp)
80004d0c:	00011e23          	sh	zero,28(sp)
   // Port number for TCP client (will be increased)
   static uint16_t any_port = 	50000;

   // Socket Status Transitions
   // Check the W5500 Socket n status register (Sn_SR, The 'Sn_SR' controlled by Sn_CR command or Packet send/recv status)
   switch(getSn_SR(sn))
80004d10:	00f14783          	lbu	a5,15(sp)
80004d14:	078a                	sll	a5,a5,0x2
80004d16:	0785                	add	a5,a5,1
80004d18:	078e                	sll	a5,a5,0x3
80004d1a:	30078793          	add	a5,a5,768
80004d1e:	853e                	mv	a0,a5
80004d20:	22d9                	jal	80004ee6 <.LFE1>
80004d22:	87aa                	mv	a5,a0
80004d24:	4771                	li	a4,28
80004d26:	0ae78f63          	beq	a5,a4,80004de4 <.L25>
80004d2a:	4771                	li	a4,28
80004d2c:	1af74163          	blt	a4,a5,80004ece <.L38>
80004d30:	475d                	li	a4,23
80004d32:	00e78b63          	beq	a5,a4,80004d48 <.L27>
80004d36:	475d                	li	a4,23
80004d38:	18f74b63          	blt	a4,a5,80004ece <.L38>
80004d3c:	12078d63          	beqz	a5,80004e76 <.L28>
80004d40:	474d                	li	a4,19
80004d42:	0ce78863          	beq	a5,a4,80004e12 <.L29>
    	 //printf("%d:TCP client loopback start\r\n",sn);
         //printf("%d:Socket opened\r\n",sn);
#endif
         break;
      default:
         break;
80004d46:	a261                	j	80004ece <.L38>

80004d48 <.L27>:
        if (connect_flag == 0) {
80004d48:	1631c783          	lbu	a5,355(gp) # 1080963 <connect_flag.1>
80004d4c:	ebb5                	bnez	a5,80004dc0 <.L30>
            if(getSn_IR(sn) & Sn_IR_CON)	// Socket n interrupt register mask; TCP CON interrupt = connection with peer is successful
80004d4e:	00f14783          	lbu	a5,15(sp)
80004d52:	078a                	sll	a5,a5,0x2
80004d54:	0785                	add	a5,a5,1
80004d56:	078e                	sll	a5,a5,0x3
80004d58:	20078793          	add	a5,a5,512
80004d5c:	853e                	mv	a0,a5
80004d5e:	2261                	jal	80004ee6 <.LFE1>
80004d60:	87aa                	mv	a5,a0
80004d62:	8b85                	and	a5,a5,1
80004d64:	cfb1                	beqz	a5,80004dc0 <.L30>
                connect_flag = 1;
80004d66:	4705                	li	a4,1
80004d68:	16e181a3          	sb	a4,355(gp) # 1080963 <connect_flag.1>
                printf("%d:Connected to - %d.%d.%d.%d : %d\r\n",sn, destip[0], destip[1], destip[2], destip[3], destport);
80004d6c:	00f14583          	lbu	a1,15(sp)
80004d70:	4792                	lw	a5,4(sp)
80004d72:	0007c783          	lbu	a5,0(a5)
80004d76:	863e                	mv	a2,a5
80004d78:	4792                	lw	a5,4(sp)
80004d7a:	0785                	add	a5,a5,1
80004d7c:	0007c783          	lbu	a5,0(a5)
80004d80:	86be                	mv	a3,a5
80004d82:	4792                	lw	a5,4(sp)
80004d84:	0789                	add	a5,a5,2
80004d86:	0007c783          	lbu	a5,0(a5)
80004d8a:	873e                	mv	a4,a5
80004d8c:	4792                	lw	a5,4(sp)
80004d8e:	078d                	add	a5,a5,3
80004d90:	0007c783          	lbu	a5,0(a5)
80004d94:	853e                	mv	a0,a5
80004d96:	00c15783          	lhu	a5,12(sp)
80004d9a:	883e                	mv	a6,a5
80004d9c:	87aa                	mv	a5,a0
80004d9e:	80004537          	lui	a0,0x80004
80004da2:	16050513          	add	a0,a0,352 # 80004160 <.LC3>
80004da6:	76b030ef          	jal	80008d10 <printf>
                setSn_IR(sn, Sn_IR_CON);  // this interrupt should be write the bit cleared to '1'
80004daa:	00f14783          	lbu	a5,15(sp)
80004dae:	078a                	sll	a5,a5,0x2
80004db0:	0785                	add	a5,a5,1
80004db2:	078e                	sll	a5,a5,0x3
80004db4:	20078793          	add	a5,a5,512
80004db8:	4585                	li	a1,1
80004dba:	853e                	mv	a0,a5
80004dbc:	2e7040ef          	jal	800098a2 <WIZCHIP_WRITE>

80004dc0 <.L30>:
         ret = send(sn, buf, 128);
80004dc0:	00f14783          	lbu	a5,15(sp)
80004dc4:	08000613          	li	a2,128
80004dc8:	45a2                	lw	a1,8(sp)
80004dca:	853e                	mv	a0,a5
80004dcc:	238d                	jal	8000532e <send>
80004dce:	cc2a                	sw	a0,24(sp)
         if(ret < 0) {
80004dd0:	47e2                	lw	a5,24(sp)
80004dd2:	1007d063          	bgez	a5,80004ed2 <.L39>
            close(sn);
80004dd6:	00f14783          	lbu	a5,15(sp)
80004dda:	853e                	mv	a0,a5
80004ddc:	07a050ef          	jal	80009e56 <close>
            return ret;
80004de0:	47e2                	lw	a5,24(sp)
80004de2:	a8f5                	j	80004ede <.L32>

80004de4 <.L25>:
         if((ret=disconnect(sn)) != SOCK_OK) return ret;
80004de4:	00f14783          	lbu	a5,15(sp)
80004de8:	853e                	mv	a0,a5
80004dea:	342050ef          	jal	8000a12c <disconnect>
80004dee:	87aa                	mv	a5,a0
80004df0:	cc3e                	sw	a5,24(sp)
80004df2:	4762                	lw	a4,24(sp)
80004df4:	4785                	li	a5,1
80004df6:	00f70463          	beq	a4,a5,80004dfe <.L34>
80004dfa:	47e2                	lw	a5,24(sp)
80004dfc:	a0cd                	j	80004ede <.L32>

80004dfe <.L34>:
         printf("%d:Socket Closed\r\n", sn);
80004dfe:	00f14783          	lbu	a5,15(sp)
80004e02:	85be                	mv	a1,a5
80004e04:	800047b7          	lui	a5,0x80004
80004e08:	12078513          	add	a0,a5,288 # 80004120 <.LC1>
80004e0c:	705030ef          	jal	80008d10 <printf>
         break;
80004e10:	a0f1                	j	80004edc <.L33>

80004e12 <.L29>:
         connect_flag = 0;
80004e12:	160181a3          	sb	zero,355(gp) # 1080963 <connect_flag.1>
    	 printf("%d:Try to connect to the %d.%d.%d.%d : %d\r\n", sn, destip[0], destip[1], destip[2], destip[3], destport);
80004e16:	00f14583          	lbu	a1,15(sp)
80004e1a:	4792                	lw	a5,4(sp)
80004e1c:	0007c783          	lbu	a5,0(a5)
80004e20:	863e                	mv	a2,a5
80004e22:	4792                	lw	a5,4(sp)
80004e24:	0785                	add	a5,a5,1
80004e26:	0007c783          	lbu	a5,0(a5)
80004e2a:	86be                	mv	a3,a5
80004e2c:	4792                	lw	a5,4(sp)
80004e2e:	0789                	add	a5,a5,2
80004e30:	0007c783          	lbu	a5,0(a5)
80004e34:	873e                	mv	a4,a5
80004e36:	4792                	lw	a5,4(sp)
80004e38:	078d                	add	a5,a5,3
80004e3a:	0007c783          	lbu	a5,0(a5)
80004e3e:	853e                	mv	a0,a5
80004e40:	00c15783          	lhu	a5,12(sp)
80004e44:	883e                	mv	a6,a5
80004e46:	87aa                	mv	a5,a0
80004e48:	80004537          	lui	a0,0x80004
80004e4c:	18850513          	add	a0,a0,392 # 80004188 <.LC4>
80004e50:	6c1030ef          	jal	80008d10 <printf>
    	 if( (ret = connect(sn, destip, destport)) != SOCK_OK) return ret;	//	Try to TCP connect to the TCP server (destination)
80004e54:	00c15703          	lhu	a4,12(sp)
80004e58:	00f14783          	lbu	a5,15(sp)
80004e5c:	863a                	mv	a2,a4
80004e5e:	4592                	lw	a1,4(sp)
80004e60:	853e                	mv	a0,a5
80004e62:	0f0050ef          	jal	80009f52 <connect>
80004e66:	87aa                	mv	a5,a0
80004e68:	cc3e                	sw	a5,24(sp)
80004e6a:	4762                	lw	a4,24(sp)
80004e6c:	4785                	li	a5,1
80004e6e:	06f70463          	beq	a4,a5,80004ed6 <.L40>
80004e72:	47e2                	lw	a5,24(sp)
80004e74:	a0ad                	j	80004ede <.L32>

80004e76 <.L28>:
          connect_flag = 0;
80004e76:	160181a3          	sb	zero,355(gp) # 1080963 <connect_flag.1>
    	  close(sn);
80004e7a:	00f14783          	lbu	a5,15(sp)
80004e7e:	853e                	mv	a0,a5
80004e80:	7d7040ef          	jal	80009e56 <close>
    	  if((ret=socket(sn, Sn_MR_TCP, any_port++, 0x00)) != sn){
80004e84:	1881d783          	lhu	a5,392(gp) # 1080988 <any_port.0>
80004e88:	00178713          	add	a4,a5,1
80004e8c:	01071693          	sll	a3,a4,0x10
80004e90:	82c1                	srl	a3,a3,0x10
80004e92:	18d19423          	sh	a3,392(gp) # 1080988 <any_port.0>
80004e96:	00f14703          	lbu	a4,15(sp)
80004e9a:	4681                	li	a3,0
80004e9c:	863e                	mv	a2,a5
80004e9e:	4585                	li	a1,1
80004ea0:	853a                	mv	a0,a4
80004ea2:	54d040ef          	jal	80009bee <socket>
80004ea6:	87aa                	mv	a5,a0
80004ea8:	cc3e                	sw	a5,24(sp)
80004eaa:	00f14783          	lbu	a5,15(sp)
80004eae:	4762                	lw	a4,24(sp)
80004eb0:	02f70563          	beq	a4,a5,80004eda <.L41>
         if(any_port == 0xffff) any_port = 50000;
80004eb4:	1881d703          	lhu	a4,392(gp) # 1080988 <any_port.0>
80004eb8:	67c1                	lui	a5,0x10
80004eba:	17fd                	add	a5,a5,-1 # ffff <__XPI0_segment_used_size__+0x3fab>
80004ebc:	00f71763          	bne	a4,a5,80004eca <.L37>
80004ec0:	7771                	lui	a4,0xffffc
80004ec2:	35070713          	add	a4,a4,848 # ffffc350 <__APB_SRAM_segment_end__+0xbf0a350>
80004ec6:	18e19423          	sh	a4,392(gp) # 1080988 <any_port.0>

80004eca <.L37>:
         return ret; // TCP socket open with 'any_port' port number
80004eca:	47e2                	lw	a5,24(sp)
80004ecc:	a809                	j	80004ede <.L32>

80004ece <.L38>:
         break;
80004ece:	0001                	nop
80004ed0:	a031                	j	80004edc <.L33>

80004ed2 <.L39>:
         break;
80004ed2:	0001                	nop
80004ed4:	a021                	j	80004edc <.L33>

80004ed6 <.L40>:
         break;
80004ed6:	0001                	nop
80004ed8:	a011                	j	80004edc <.L33>

80004eda <.L41>:
         break;
80004eda:	0001                	nop

80004edc <.L33>:
   }
   return 1;
80004edc:	4785                	li	a5,1

80004ede <.L32>:
}
80004ede:	853e                	mv	a0,a5
80004ee0:	50b2                	lw	ra,44(sp)
80004ee2:	6145                	add	sp,sp,48
80004ee4:	8082                	ret

Disassembly of section .text.WIZCHIP_READ:

80004ee6 <WIZCHIP_READ>:

#if   (_WIZCHIP_ == 5500)
////////////////////////////////////////////////////
extern uint8_t wizchip_read_byte(uint8_t *addr_sel, uint8_t addr_sel_len);
uint8_t  WIZCHIP_READ(uint32_t AddrSel)
{
80004ee6:	7179                	add	sp,sp,-48
80004ee8:	d606                	sw	ra,44(sp)
80004eea:	c62a                	sw	a0,12(sp)
   uint8_t ret;
   uint8_t spi_data[3];

   WIZCHIP_CRITICAL_ENTER();
80004eec:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004ef0:	47dc                	lw	a5,12(a5)
80004ef2:	9782                	jalr	a5
   WIZCHIP.CS._select();
80004ef4:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004ef8:	4bdc                	lw	a5,20(a5)
80004efa:	9782                	jalr	a5

   AddrSel |= (_W5500_SPI_READ_ | _W5500_SPI_VDM_OP_);

   if(!WIZCHIP.IF.SPI._read_burst || !WIZCHIP.IF.SPI._write_burst) 	// byte operation
80004efc:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004f00:	53dc                	lw	a5,36(a5)
80004f02:	c789                	beqz	a5,80004f0c <.L2>
80004f04:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004f08:	579c                	lw	a5,40(a5)
80004f0a:	ef85                	bnez	a5,80004f42 <.L3>

80004f0c <.L2>:
   {
	   WIZCHIP.IF.SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
80004f0c:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004f10:	539c                	lw	a5,32(a5)
80004f12:	4732                	lw	a4,12(sp)
80004f14:	8341                	srl	a4,a4,0x10
80004f16:	0ff77713          	zext.b	a4,a4
80004f1a:	853a                	mv	a0,a4
80004f1c:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
80004f1e:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004f22:	539c                	lw	a5,32(a5)
80004f24:	4732                	lw	a4,12(sp)
80004f26:	8321                	srl	a4,a4,0x8
80004f28:	0ff77713          	zext.b	a4,a4
80004f2c:	853a                	mv	a0,a4
80004f2e:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x000000FF) >>  0);
80004f30:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004f34:	539c                	lw	a5,32(a5)
80004f36:	4732                	lw	a4,12(sp)
80004f38:	0ff77713          	zext.b	a4,a4
80004f3c:	853a                	mv	a0,a4
80004f3e:	9782                	jalr	a5
80004f40:	a815                	j	80004f74 <.L4>

80004f42 <.L3>:
   }
   else																// burst operation
   {
		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
80004f42:	47b2                	lw	a5,12(sp)
80004f44:	83c1                	srl	a5,a5,0x10
80004f46:	0ff7f793          	zext.b	a5,a5
80004f4a:	00f10e23          	sb	a5,28(sp)
		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
80004f4e:	47b2                	lw	a5,12(sp)
80004f50:	83a1                	srl	a5,a5,0x8
80004f52:	0ff7f793          	zext.b	a5,a5
80004f56:	00f10ea3          	sb	a5,29(sp)
		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
80004f5a:	47b2                	lw	a5,12(sp)
80004f5c:	0ff7f793          	zext.b	a5,a5
80004f60:	00f10f23          	sb	a5,30(sp)
#if 0
		WIZCHIP.IF.SPI._write_burst(spi_data, 3);
   }
   ret = WIZCHIP.IF.SPI._read_byte();
#else
        ret = wizchip_read_byte(spi_data, 3);
80004f64:	087c                	add	a5,sp,28
80004f66:	458d                	li	a1,3
80004f68:	853e                	mv	a0,a5
80004f6a:	2b4070ef          	jal	8000c21e <wizchip_read_byte>
80004f6e:	87aa                	mv	a5,a0
80004f70:	00f10fa3          	sb	a5,31(sp)

80004f74 <.L4>:
    }
#endif
   
   WIZCHIP.CS._deselect();
80004f74:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004f78:	4f9c                	lw	a5,24(a5)
80004f7a:	9782                	jalr	a5
   WIZCHIP_CRITICAL_EXIT();
80004f7c:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004f80:	4b9c                	lw	a5,16(a5)
80004f82:	9782                	jalr	a5
   return ret;
80004f84:	01f14783          	lbu	a5,31(sp)
}
80004f88:	853e                	mv	a0,a5
80004f8a:	50b2                	lw	ra,44(sp)
80004f8c:	6145                	add	sp,sp,48
80004f8e:	8082                	ret

Disassembly of section .text.WIZCHIP_WRITE_BUF:

80004f90 <WIZCHIP_WRITE_BUF>:
   WIZCHIP.CS._deselect();
   WIZCHIP_CRITICAL_EXIT();
}

void     WIZCHIP_WRITE_BUF(uint32_t AddrSel, uint8_t* pBuf, uint16_t len)
{
80004f90:	7179                	add	sp,sp,-48
80004f92:	d606                	sw	ra,44(sp)
80004f94:	c62a                	sw	a0,12(sp)
80004f96:	c42e                	sw	a1,8(sp)
80004f98:	87b2                	mv	a5,a2
80004f9a:	00f11323          	sh	a5,6(sp)
   uint8_t spi_data[3];
   uint16_t i;

   WIZCHIP_CRITICAL_ENTER();
80004f9e:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004fa2:	47dc                	lw	a5,12(a5)
80004fa4:	9782                	jalr	a5
   WIZCHIP.CS._select();
80004fa6:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004faa:	4bdc                	lw	a5,20(a5)
80004fac:	9782                	jalr	a5

   AddrSel |= (_W5500_SPI_WRITE_ | _W5500_SPI_VDM_OP_);
80004fae:	47b2                	lw	a5,12(sp)
80004fb0:	0047e793          	or	a5,a5,4
80004fb4:	c63e                	sw	a5,12(sp)

   if(!WIZCHIP.IF.SPI._write_burst) 	// byte operation
80004fb6:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004fba:	579c                	lw	a5,40(a5)
80004fbc:	e7ad                	bnez	a5,80005026 <.L16>
   {
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
80004fbe:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004fc2:	539c                	lw	a5,32(a5)
80004fc4:	4732                	lw	a4,12(sp)
80004fc6:	8341                	srl	a4,a4,0x10
80004fc8:	0ff77713          	zext.b	a4,a4
80004fcc:	853a                	mv	a0,a4
80004fce:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
80004fd0:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004fd4:	539c                	lw	a5,32(a5)
80004fd6:	4732                	lw	a4,12(sp)
80004fd8:	8321                	srl	a4,a4,0x8
80004fda:	0ff77713          	zext.b	a4,a4
80004fde:	853a                	mv	a0,a4
80004fe0:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x000000FF) >>  0);
80004fe2:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004fe6:	539c                	lw	a5,32(a5)
80004fe8:	4732                	lw	a4,12(sp)
80004fea:	0ff77713          	zext.b	a4,a4
80004fee:	853a                	mv	a0,a4
80004ff0:	9782                	jalr	a5
		for(i = 0; i < len; i++)
80004ff2:	00011f23          	sh	zero,30(sp)
80004ff6:	a00d                	j	80005018 <.L17>

80004ff8 <.L18>:
			WIZCHIP.IF.SPI._write_byte(pBuf[i]);
80004ff8:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80004ffc:	539c                	lw	a5,32(a5)
80004ffe:	01e15703          	lhu	a4,30(sp)
80005002:	46a2                	lw	a3,8(sp)
80005004:	9736                	add	a4,a4,a3
80005006:	00074703          	lbu	a4,0(a4)
8000500a:	853a                	mv	a0,a4
8000500c:	9782                	jalr	a5
		for(i = 0; i < len; i++)
8000500e:	01e15783          	lhu	a5,30(sp)
80005012:	0785                	add	a5,a5,1
80005014:	00f11f23          	sh	a5,30(sp)

80005018 <.L17>:
80005018:	01e15703          	lhu	a4,30(sp)
8000501c:	00615783          	lhu	a5,6(sp)
80005020:	fcf76ce3          	bltu	a4,a5,80004ff8 <.L18>
80005024:	a089                	j	80005066 <.L19>

80005026 <.L16>:
   }
   else									// burst operation
   {
		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
80005026:	47b2                	lw	a5,12(sp)
80005028:	83c1                	srl	a5,a5,0x10
8000502a:	0ff7f793          	zext.b	a5,a5
8000502e:	00f10c23          	sb	a5,24(sp)
		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
80005032:	47b2                	lw	a5,12(sp)
80005034:	83a1                	srl	a5,a5,0x8
80005036:	0ff7f793          	zext.b	a5,a5
8000503a:	00f10ca3          	sb	a5,25(sp)
		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
8000503e:	47b2                	lw	a5,12(sp)
80005040:	0ff7f793          	zext.b	a5,a5
80005044:	00f10d23          	sb	a5,26(sp)
		WIZCHIP.IF.SPI._write_burst(spi_data, 3);
80005048:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000504c:	579c                	lw	a5,40(a5)
8000504e:	0838                	add	a4,sp,24
80005050:	458d                	li	a1,3
80005052:	853a                	mv	a0,a4
80005054:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_burst(pBuf, len);
80005056:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000505a:	579c                	lw	a5,40(a5)
8000505c:	00615703          	lhu	a4,6(sp)
80005060:	85ba                	mv	a1,a4
80005062:	4522                	lw	a0,8(sp)
80005064:	9782                	jalr	a5

80005066 <.L19>:
   }

   WIZCHIP.CS._deselect();
80005066:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000506a:	4f9c                	lw	a5,24(a5)
8000506c:	9782                	jalr	a5
   WIZCHIP_CRITICAL_EXIT();
8000506e:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80005072:	4b9c                	lw	a5,16(a5)
80005074:	9782                	jalr	a5
}
80005076:	0001                	nop
80005078:	50b2                	lw	ra,44(sp)
8000507a:	6145                	add	sp,sp,48
8000507c:	8082                	ret

Disassembly of section .text.wiz_send_data:

8000507e <wiz_send_data>:
   }while (val != val1);
   return val;
}

void wiz_send_data(uint8_t sn, uint8_t *wizdata, uint16_t len)
{
8000507e:	7179                	add	sp,sp,-48
80005080:	d606                	sw	ra,44(sp)
80005082:	d422                	sw	s0,40(sp)
80005084:	87aa                	mv	a5,a0
80005086:	c42e                	sw	a1,8(sp)
80005088:	8732                	mv	a4,a2
8000508a:	00f107a3          	sb	a5,15(sp)
8000508e:	87ba                	mv	a5,a4
80005090:	00f11623          	sh	a5,12(sp)
   uint16_t ptr = 0;
80005094:	00011f23          	sh	zero,30(sp)
   uint32_t addrsel = 0;
80005098:	cc02                	sw	zero,24(sp)

   if(len == 0)  return;
8000509a:	00c15783          	lhu	a5,12(sp)
8000509e:	c7e9                	beqz	a5,80005168 <.L31>
   ptr = getSn_TX_WR(sn);
800050a0:	00f14783          	lbu	a5,15(sp)
800050a4:	078a                	sll	a5,a5,0x2
800050a6:	0785                	add	a5,a5,1
800050a8:	00379713          	sll	a4,a5,0x3
800050ac:	6789                	lui	a5,0x2
800050ae:	40078793          	add	a5,a5,1024 # 2400 <__APB_SRAM_segment_size__+0x400>
800050b2:	97ba                	add	a5,a5,a4
800050b4:	853e                	mv	a0,a5
800050b6:	3d05                	jal	80004ee6 <WIZCHIP_READ>
800050b8:	87aa                	mv	a5,a0
800050ba:	07a2                	sll	a5,a5,0x8
800050bc:	01079413          	sll	s0,a5,0x10
800050c0:	8041                	srl	s0,s0,0x10
800050c2:	00f14783          	lbu	a5,15(sp)
800050c6:	078a                	sll	a5,a5,0x2
800050c8:	0785                	add	a5,a5,1
800050ca:	00379713          	sll	a4,a5,0x3
800050ce:	6789                	lui	a5,0x2
800050d0:	50078793          	add	a5,a5,1280 # 2500 <__APB_SRAM_segment_size__+0x500>
800050d4:	97ba                	add	a5,a5,a4
800050d6:	853e                	mv	a0,a5
800050d8:	3539                	jal	80004ee6 <WIZCHIP_READ>
800050da:	87aa                	mv	a5,a0
800050dc:	97a2                	add	a5,a5,s0
800050de:	00f11f23          	sh	a5,30(sp)
   //M20140501 : implict type casting -> explict type casting
   //addrsel = (ptr << 8) + (WIZCHIP_TXBUF_BLOCK(sn) << 3);
   addrsel = ((uint32_t)ptr << 8) + (WIZCHIP_TXBUF_BLOCK(sn) << 3);
800050e2:	01e15783          	lhu	a5,30(sp)
800050e6:	00879713          	sll	a4,a5,0x8
800050ea:	00f14783          	lbu	a5,15(sp)
800050ee:	078a                	sll	a5,a5,0x2
800050f0:	0789                	add	a5,a5,2
800050f2:	078e                	sll	a5,a5,0x3
800050f4:	97ba                	add	a5,a5,a4
800050f6:	cc3e                	sw	a5,24(sp)
   //
   WIZCHIP_WRITE_BUF(addrsel,wizdata, len);
800050f8:	00c15783          	lhu	a5,12(sp)
800050fc:	863e                	mv	a2,a5
800050fe:	45a2                	lw	a1,8(sp)
80005100:	4562                	lw	a0,24(sp)
80005102:	3579                	jal	80004f90 <WIZCHIP_WRITE_BUF>
   
   ptr += len;
80005104:	01e15783          	lhu	a5,30(sp)
80005108:	873e                	mv	a4,a5
8000510a:	00c15783          	lhu	a5,12(sp)
8000510e:	97ba                	add	a5,a5,a4
80005110:	00f11f23          	sh	a5,30(sp)
   setSn_TX_WR(sn,ptr);
80005114:	00f14783          	lbu	a5,15(sp)
80005118:	078a                	sll	a5,a5,0x2
8000511a:	0785                	add	a5,a5,1
8000511c:	00379713          	sll	a4,a5,0x3
80005120:	6789                	lui	a5,0x2
80005122:	40078793          	add	a5,a5,1024 # 2400 <__APB_SRAM_segment_size__+0x400>
80005126:	97ba                	add	a5,a5,a4
80005128:	873e                	mv	a4,a5
8000512a:	01e15783          	lhu	a5,30(sp)
8000512e:	83a1                	srl	a5,a5,0x8
80005130:	07c2                	sll	a5,a5,0x10
80005132:	83c1                	srl	a5,a5,0x10
80005134:	0ff7f793          	zext.b	a5,a5
80005138:	85be                	mv	a1,a5
8000513a:	853a                	mv	a0,a4
8000513c:	766040ef          	jal	800098a2 <WIZCHIP_WRITE>
80005140:	00f14783          	lbu	a5,15(sp)
80005144:	078a                	sll	a5,a5,0x2
80005146:	0785                	add	a5,a5,1
80005148:	00379713          	sll	a4,a5,0x3
8000514c:	6789                	lui	a5,0x2
8000514e:	50078793          	add	a5,a5,1280 # 2500 <__APB_SRAM_segment_size__+0x500>
80005152:	97ba                	add	a5,a5,a4
80005154:	873e                	mv	a4,a5
80005156:	01e15783          	lhu	a5,30(sp)
8000515a:	0ff7f793          	zext.b	a5,a5
8000515e:	85be                	mv	a1,a5
80005160:	853a                	mv	a0,a4
80005162:	740040ef          	jal	800098a2 <WIZCHIP_WRITE>
80005166:	a011                	j	8000516a <.L28>

80005168 <.L31>:
   if(len == 0)  return;
80005168:	0001                	nop

8000516a <.L28>:
}
8000516a:	50b2                	lw	ra,44(sp)
8000516c:	5422                	lw	s0,40(sp)
8000516e:	6145                	add	sp,sp,48
80005170:	8082                	ret

Disassembly of section .text.wiz_recv_data:

80005172 <wiz_recv_data>:

void wiz_recv_data(uint8_t sn, uint8_t *wizdata, uint16_t len)
{
80005172:	7179                	add	sp,sp,-48
80005174:	d606                	sw	ra,44(sp)
80005176:	d422                	sw	s0,40(sp)
80005178:	87aa                	mv	a5,a0
8000517a:	c42e                	sw	a1,8(sp)
8000517c:	8732                	mv	a4,a2
8000517e:	00f107a3          	sb	a5,15(sp)
80005182:	87ba                	mv	a5,a4
80005184:	00f11623          	sh	a5,12(sp)
   uint16_t ptr = 0;
80005188:	00011f23          	sh	zero,30(sp)
   uint32_t addrsel = 0;
8000518c:	cc02                	sw	zero,24(sp)
   
   if(len == 0) return;
8000518e:	00c15783          	lhu	a5,12(sp)
80005192:	c7f1                	beqz	a5,8000525e <.L35>
   ptr = getSn_RX_RD(sn);
80005194:	00f14783          	lbu	a5,15(sp)
80005198:	078a                	sll	a5,a5,0x2
8000519a:	0785                	add	a5,a5,1
8000519c:	00379713          	sll	a4,a5,0x3
800051a0:	678d                	lui	a5,0x3
800051a2:	80078793          	add	a5,a5,-2048 # 2800 <__APB_SRAM_segment_size__+0x800>
800051a6:	97ba                	add	a5,a5,a4
800051a8:	853e                	mv	a0,a5
800051aa:	3b35                	jal	80004ee6 <WIZCHIP_READ>
800051ac:	87aa                	mv	a5,a0
800051ae:	07a2                	sll	a5,a5,0x8
800051b0:	01079413          	sll	s0,a5,0x10
800051b4:	8041                	srl	s0,s0,0x10
800051b6:	00f14783          	lbu	a5,15(sp)
800051ba:	078a                	sll	a5,a5,0x2
800051bc:	0785                	add	a5,a5,1
800051be:	00379713          	sll	a4,a5,0x3
800051c2:	678d                	lui	a5,0x3
800051c4:	90078793          	add	a5,a5,-1792 # 2900 <__APB_SRAM_segment_size__+0x900>
800051c8:	97ba                	add	a5,a5,a4
800051ca:	853e                	mv	a0,a5
800051cc:	3b29                	jal	80004ee6 <WIZCHIP_READ>
800051ce:	87aa                	mv	a5,a0
800051d0:	97a2                	add	a5,a5,s0
800051d2:	00f11f23          	sh	a5,30(sp)
   //M20140501 : implict type casting -> explict type casting
   //addrsel = ((ptr << 8) + (WIZCHIP_RXBUF_BLOCK(sn) << 3);
   addrsel = ((uint32_t)ptr << 8) + (WIZCHIP_RXBUF_BLOCK(sn) << 3);
800051d6:	01e15783          	lhu	a5,30(sp)
800051da:	00879713          	sll	a4,a5,0x8
800051de:	00f14783          	lbu	a5,15(sp)
800051e2:	078a                	sll	a5,a5,0x2
800051e4:	078d                	add	a5,a5,3
800051e6:	078e                	sll	a5,a5,0x3
800051e8:	97ba                	add	a5,a5,a4
800051ea:	cc3e                	sw	a5,24(sp)
   //
   WIZCHIP_READ_BUF(addrsel, wizdata, len);
800051ec:	00c15783          	lhu	a5,12(sp)
800051f0:	863e                	mv	a2,a5
800051f2:	45a2                	lw	a1,8(sp)
800051f4:	4562                	lw	a0,24(sp)
800051f6:	76c040ef          	jal	80009962 <WIZCHIP_READ_BUF>
   ptr += len;
800051fa:	01e15783          	lhu	a5,30(sp)
800051fe:	873e                	mv	a4,a5
80005200:	00c15783          	lhu	a5,12(sp)
80005204:	97ba                	add	a5,a5,a4
80005206:	00f11f23          	sh	a5,30(sp)
   
   setSn_RX_RD(sn,ptr);
8000520a:	00f14783          	lbu	a5,15(sp)
8000520e:	078a                	sll	a5,a5,0x2
80005210:	0785                	add	a5,a5,1
80005212:	00379713          	sll	a4,a5,0x3
80005216:	678d                	lui	a5,0x3
80005218:	80078793          	add	a5,a5,-2048 # 2800 <__APB_SRAM_segment_size__+0x800>
8000521c:	97ba                	add	a5,a5,a4
8000521e:	873e                	mv	a4,a5
80005220:	01e15783          	lhu	a5,30(sp)
80005224:	83a1                	srl	a5,a5,0x8
80005226:	07c2                	sll	a5,a5,0x10
80005228:	83c1                	srl	a5,a5,0x10
8000522a:	0ff7f793          	zext.b	a5,a5
8000522e:	85be                	mv	a1,a5
80005230:	853a                	mv	a0,a4
80005232:	670040ef          	jal	800098a2 <WIZCHIP_WRITE>
80005236:	00f14783          	lbu	a5,15(sp)
8000523a:	078a                	sll	a5,a5,0x2
8000523c:	0785                	add	a5,a5,1
8000523e:	00379713          	sll	a4,a5,0x3
80005242:	678d                	lui	a5,0x3
80005244:	90078793          	add	a5,a5,-1792 # 2900 <__APB_SRAM_segment_size__+0x900>
80005248:	97ba                	add	a5,a5,a4
8000524a:	873e                	mv	a4,a5
8000524c:	01e15783          	lhu	a5,30(sp)
80005250:	0ff7f793          	zext.b	a5,a5
80005254:	85be                	mv	a1,a5
80005256:	853a                	mv	a0,a4
80005258:	64a040ef          	jal	800098a2 <WIZCHIP_WRITE>
8000525c:	a011                	j	80005260 <.L32>

8000525e <.L35>:
   if(len == 0) return;
8000525e:	0001                	nop

80005260 <.L32>:
}
80005260:	50b2                	lw	ra,44(sp)
80005262:	5422                	lw	s0,40(sp)
80005264:	6145                	add	sp,sp,48
80005266:	8082                	ret

Disassembly of section .text.wiz_recv_ignore:

80005268 <wiz_recv_ignore>:


void wiz_recv_ignore(uint8_t sn, uint16_t len)
{
80005268:	7179                	add	sp,sp,-48
8000526a:	d606                	sw	ra,44(sp)
8000526c:	d422                	sw	s0,40(sp)
8000526e:	87aa                	mv	a5,a0
80005270:	872e                	mv	a4,a1
80005272:	00f107a3          	sb	a5,15(sp)
80005276:	87ba                	mv	a5,a4
80005278:	00f11623          	sh	a5,12(sp)
   uint16_t ptr = 0;
8000527c:	00011f23          	sh	zero,30(sp)

   ptr = getSn_RX_RD(sn);
80005280:	00f14783          	lbu	a5,15(sp)
80005284:	078a                	sll	a5,a5,0x2
80005286:	0785                	add	a5,a5,1
80005288:	00379713          	sll	a4,a5,0x3
8000528c:	678d                	lui	a5,0x3
8000528e:	80078793          	add	a5,a5,-2048 # 2800 <__APB_SRAM_segment_size__+0x800>
80005292:	97ba                	add	a5,a5,a4
80005294:	853e                	mv	a0,a5
80005296:	3981                	jal	80004ee6 <WIZCHIP_READ>
80005298:	87aa                	mv	a5,a0
8000529a:	07a2                	sll	a5,a5,0x8
8000529c:	01079413          	sll	s0,a5,0x10
800052a0:	8041                	srl	s0,s0,0x10
800052a2:	00f14783          	lbu	a5,15(sp)
800052a6:	078a                	sll	a5,a5,0x2
800052a8:	0785                	add	a5,a5,1
800052aa:	00379713          	sll	a4,a5,0x3
800052ae:	678d                	lui	a5,0x3
800052b0:	90078793          	add	a5,a5,-1792 # 2900 <__APB_SRAM_segment_size__+0x900>
800052b4:	97ba                	add	a5,a5,a4
800052b6:	853e                	mv	a0,a5
800052b8:	313d                	jal	80004ee6 <WIZCHIP_READ>
800052ba:	87aa                	mv	a5,a0
800052bc:	97a2                	add	a5,a5,s0
800052be:	00f11f23          	sh	a5,30(sp)
   ptr += len;
800052c2:	01e15783          	lhu	a5,30(sp)
800052c6:	873e                	mv	a4,a5
800052c8:	00c15783          	lhu	a5,12(sp)
800052cc:	97ba                	add	a5,a5,a4
800052ce:	00f11f23          	sh	a5,30(sp)
   setSn_RX_RD(sn,ptr);
800052d2:	00f14783          	lbu	a5,15(sp)
800052d6:	078a                	sll	a5,a5,0x2
800052d8:	0785                	add	a5,a5,1
800052da:	00379713          	sll	a4,a5,0x3
800052de:	678d                	lui	a5,0x3
800052e0:	80078793          	add	a5,a5,-2048 # 2800 <__APB_SRAM_segment_size__+0x800>
800052e4:	97ba                	add	a5,a5,a4
800052e6:	873e                	mv	a4,a5
800052e8:	01e15783          	lhu	a5,30(sp)
800052ec:	83a1                	srl	a5,a5,0x8
800052ee:	07c2                	sll	a5,a5,0x10
800052f0:	83c1                	srl	a5,a5,0x10
800052f2:	0ff7f793          	zext.b	a5,a5
800052f6:	85be                	mv	a1,a5
800052f8:	853a                	mv	a0,a4
800052fa:	5a8040ef          	jal	800098a2 <WIZCHIP_WRITE>
800052fe:	00f14783          	lbu	a5,15(sp)
80005302:	078a                	sll	a5,a5,0x2
80005304:	0785                	add	a5,a5,1
80005306:	00379713          	sll	a4,a5,0x3
8000530a:	678d                	lui	a5,0x3
8000530c:	90078793          	add	a5,a5,-1792 # 2900 <__APB_SRAM_segment_size__+0x900>
80005310:	97ba                	add	a5,a5,a4
80005312:	873e                	mv	a4,a5
80005314:	01e15783          	lhu	a5,30(sp)
80005318:	0ff7f793          	zext.b	a5,a5
8000531c:	85be                	mv	a1,a5
8000531e:	853a                	mv	a0,a4
80005320:	582040ef          	jal	800098a2 <WIZCHIP_WRITE>
}
80005324:	0001                	nop
80005326:	50b2                	lw	ra,44(sp)
80005328:	5422                	lw	s0,40(sp)
8000532a:	6145                	add	sp,sp,48
8000532c:	8082                	ret

Disassembly of section .text.send:

8000532e <send>:
	}
	return SOCK_OK;
}

int32_t send(uint8_t sn, uint8_t * buf, uint16_t len)
{
8000532e:	7179                	add	sp,sp,-48
80005330:	d606                	sw	ra,44(sp)
80005332:	87aa                	mv	a5,a0
80005334:	c42e                	sw	a1,8(sp)
80005336:	8732                	mv	a4,a2
80005338:	00f107a3          	sb	a5,15(sp)
8000533c:	87ba                	mv	a5,a4
8000533e:	00f11623          	sh	a5,12(sp)
   uint8_t tmp=0;
80005342:	00010fa3          	sb	zero,31(sp)
   uint16_t freesize=0;
80005346:	00011e23          	sh	zero,28(sp)
   
   CHECK_SOCKNUM();
8000534a:	00f14703          	lbu	a4,15(sp)
8000534e:	47a1                	li	a5,8
80005350:	00e7f463          	bgeu	a5,a4,80005358 <.L60>
80005354:	57fd                	li	a5,-1
80005356:	a431                	j	80005562 <.L61>

80005358 <.L60>:
   CHECK_SOCKMODE(Sn_MR_TCP);
80005358:	00f14783          	lbu	a5,15(sp)
8000535c:	078a                	sll	a5,a5,0x2
8000535e:	0785                	add	a5,a5,1
80005360:	078e                	sll	a5,a5,0x3
80005362:	853e                	mv	a0,a5
80005364:	3649                	jal	80004ee6 <WIZCHIP_READ>
80005366:	87aa                	mv	a5,a0
80005368:	00f7f713          	and	a4,a5,15
8000536c:	4785                	li	a5,1
8000536e:	00f70463          	beq	a4,a5,80005376 <.L62>
80005372:	57ed                	li	a5,-5
80005374:	a2fd                	j	80005562 <.L61>

80005376 <.L62>:
   CHECK_SOCKDATA();
80005376:	00c15783          	lhu	a5,12(sp)
8000537a:	e399                	bnez	a5,80005380 <.L63>
8000537c:	57c9                	li	a5,-14
8000537e:	a2d5                	j	80005562 <.L61>

80005380 <.L63>:
   tmp = getSn_SR(sn);
80005380:	00f14783          	lbu	a5,15(sp)
80005384:	078a                	sll	a5,a5,0x2
80005386:	0785                	add	a5,a5,1
80005388:	078e                	sll	a5,a5,0x3
8000538a:	30078793          	add	a5,a5,768
8000538e:	853e                	mv	a0,a5
80005390:	3e99                	jal	80004ee6 <WIZCHIP_READ>
80005392:	87aa                	mv	a5,a0
80005394:	00f10fa3          	sb	a5,31(sp)
   if(tmp != SOCK_ESTABLISHED && tmp != SOCK_CLOSE_WAIT) return SOCKERR_SOCKSTATUS;
80005398:	01f14703          	lbu	a4,31(sp)
8000539c:	47dd                	li	a5,23
8000539e:	00f70963          	beq	a4,a5,800053b0 <.L64>
800053a2:	01f14703          	lbu	a4,31(sp)
800053a6:	47f1                	li	a5,28
800053a8:	00f70463          	beq	a4,a5,800053b0 <.L64>
800053ac:	57e5                	li	a5,-7
800053ae:	aa55                	j	80005562 <.L61>

800053b0 <.L64>:
   if( sock_is_sending & (1<<sn) )
800053b0:	11e1d783          	lhu	a5,286(gp) # 108091e <sock_is_sending>
800053b4:	873e                	mv	a4,a5
800053b6:	00f14783          	lbu	a5,15(sp)
800053ba:	40f757b3          	sra	a5,a4,a5
800053be:	8b85                	and	a5,a5,1
800053c0:	c3d9                	beqz	a5,80005446 <.L65>
   {
      tmp = getSn_IR(sn);
800053c2:	00f14783          	lbu	a5,15(sp)
800053c6:	078a                	sll	a5,a5,0x2
800053c8:	0785                	add	a5,a5,1
800053ca:	078e                	sll	a5,a5,0x3
800053cc:	20078793          	add	a5,a5,512
800053d0:	853e                	mv	a0,a5
800053d2:	3e11                	jal	80004ee6 <WIZCHIP_READ>
800053d4:	87aa                	mv	a5,a0
800053d6:	8bfd                	and	a5,a5,31
800053d8:	00f10fa3          	sb	a5,31(sp)
      if(tmp & Sn_IR_SENDOK)
800053dc:	01f14783          	lbu	a5,31(sp)
800053e0:	8bc1                	and	a5,a5,16
800053e2:	c7a9                	beqz	a5,8000542c <.L66>
      {
         setSn_IR(sn, Sn_IR_SENDOK);
800053e4:	00f14783          	lbu	a5,15(sp)
800053e8:	078a                	sll	a5,a5,0x2
800053ea:	0785                	add	a5,a5,1
800053ec:	078e                	sll	a5,a5,0x3
800053ee:	20078793          	add	a5,a5,512
800053f2:	45c1                	li	a1,16
800053f4:	853e                	mv	a0,a5
800053f6:	4ac040ef          	jal	800098a2 <WIZCHIP_WRITE>
               setSn_CR(sn,Sn_CR_SEND);
               while(getSn_CR(sn));
               return SOCK_BUSY;
            }
         #endif
         sock_is_sending &= ~(1<<sn);         
800053fa:	00f14783          	lbu	a5,15(sp)
800053fe:	4705                	li	a4,1
80005400:	00f717b3          	sll	a5,a4,a5
80005404:	07c2                	sll	a5,a5,0x10
80005406:	87c1                	sra	a5,a5,0x10
80005408:	fff7c793          	not	a5,a5
8000540c:	01079713          	sll	a4,a5,0x10
80005410:	8741                	sra	a4,a4,0x10
80005412:	11e1d783          	lhu	a5,286(gp) # 108091e <sock_is_sending>
80005416:	07c2                	sll	a5,a5,0x10
80005418:	87c1                	sra	a5,a5,0x10
8000541a:	8ff9                	and	a5,a5,a4
8000541c:	07c2                	sll	a5,a5,0x10
8000541e:	87c1                	sra	a5,a5,0x10
80005420:	01079713          	sll	a4,a5,0x10
80005424:	8341                	srl	a4,a4,0x10
80005426:	10e19f23          	sh	a4,286(gp) # 108091e <sock_is_sending>
8000542a:	a831                	j	80005446 <.L65>

8000542c <.L66>:
      }
      else if(tmp & Sn_IR_TIMEOUT)
8000542c:	01f14783          	lbu	a5,31(sp)
80005430:	8ba1                	and	a5,a5,8
80005432:	cb81                	beqz	a5,80005442 <.L67>
      {
         close(sn);
80005434:	00f14783          	lbu	a5,15(sp)
80005438:	853e                	mv	a0,a5
8000543a:	21d040ef          	jal	80009e56 <close>
         return SOCKERR_TIMEOUT;
8000543e:	57cd                	li	a5,-13
80005440:	a20d                	j	80005562 <.L61>

80005442 <.L67>:
      }
      else return SOCK_BUSY;
80005442:	4781                	li	a5,0
80005444:	aa39                	j	80005562 <.L61>

80005446 <.L65>:
   }
   freesize = getSn_TxMAX(sn);
80005446:	00f14783          	lbu	a5,15(sp)
8000544a:	078a                	sll	a5,a5,0x2
8000544c:	0785                	add	a5,a5,1
8000544e:	00379713          	sll	a4,a5,0x3
80005452:	6789                	lui	a5,0x2
80005454:	f0078793          	add	a5,a5,-256 # 1f00 <__fw_size__+0xf00>
80005458:	97ba                	add	a5,a5,a4
8000545a:	853e                	mv	a0,a5
8000545c:	3469                	jal	80004ee6 <WIZCHIP_READ>
8000545e:	87aa                	mv	a5,a0
80005460:	07aa                	sll	a5,a5,0xa
80005462:	00f11e23          	sh	a5,28(sp)
   if (len > freesize) len = freesize; // check size not to exceed MAX size.
80005466:	00c15703          	lhu	a4,12(sp)
8000546a:	01c15783          	lhu	a5,28(sp)
8000546e:	00e7f663          	bgeu	a5,a4,8000547a <.L73>
80005472:	01c15783          	lhu	a5,28(sp)
80005476:	00f11623          	sh	a5,12(sp)

8000547a <.L73>:
   while(1)
   {
      freesize = getSn_TX_FSR(sn);
8000547a:	00f14783          	lbu	a5,15(sp)
8000547e:	853e                	mv	a0,a5
80005480:	5d6040ef          	jal	80009a56 <getSn_TX_FSR>
80005484:	87aa                	mv	a5,a0
80005486:	00f11e23          	sh	a5,28(sp)
      tmp = getSn_SR(sn);
8000548a:	00f14783          	lbu	a5,15(sp)
8000548e:	078a                	sll	a5,a5,0x2
80005490:	0785                	add	a5,a5,1
80005492:	078e                	sll	a5,a5,0x3
80005494:	30078793          	add	a5,a5,768
80005498:	853e                	mv	a0,a5
8000549a:	34b1                	jal	80004ee6 <WIZCHIP_READ>
8000549c:	87aa                	mv	a5,a0
8000549e:	00f10fa3          	sb	a5,31(sp)
      if ((tmp != SOCK_ESTABLISHED) && (tmp != SOCK_CLOSE_WAIT))
800054a2:	01f14703          	lbu	a4,31(sp)
800054a6:	47dd                	li	a5,23
800054a8:	00f70e63          	beq	a4,a5,800054c4 <.L69>
800054ac:	01f14703          	lbu	a4,31(sp)
800054b0:	47f1                	li	a5,28
800054b2:	00f70963          	beq	a4,a5,800054c4 <.L69>
      {
         close(sn);
800054b6:	00f14783          	lbu	a5,15(sp)
800054ba:	853e                	mv	a0,a5
800054bc:	19b040ef          	jal	80009e56 <close>
         return SOCKERR_SOCKSTATUS;
800054c0:	57e5                	li	a5,-7
800054c2:	a045                	j	80005562 <.L61>

800054c4 <.L69>:
      }
      if( (sock_io_mode & (1<<sn)) && (len > freesize) ) return SOCK_BUSY;
800054c4:	1601d783          	lhu	a5,352(gp) # 1080960 <sock_io_mode>
800054c8:	873e                	mv	a4,a5
800054ca:	00f14783          	lbu	a5,15(sp)
800054ce:	40f757b3          	sra	a5,a4,a5
800054d2:	8b85                	and	a5,a5,1
800054d4:	cb89                	beqz	a5,800054e6 <.L70>
800054d6:	00c15703          	lhu	a4,12(sp)
800054da:	01c15783          	lhu	a5,28(sp)
800054de:	00e7f463          	bgeu	a5,a4,800054e6 <.L70>
800054e2:	4781                	li	a5,0
800054e4:	a8bd                	j	80005562 <.L61>

800054e6 <.L70>:
      if(len <= freesize) break;
800054e6:	00c15703          	lhu	a4,12(sp)
800054ea:	01c15783          	lhu	a5,28(sp)
800054ee:	00e7f363          	bgeu	a5,a4,800054f4 <.L76>
      freesize = getSn_TX_FSR(sn);
800054f2:	b761                	j	8000547a <.L73>

800054f4 <.L76>:
      if(len <= freesize) break;
800054f4:	0001                	nop
   }
   wiz_send_data(sn, buf, len);
800054f6:	00c15703          	lhu	a4,12(sp)
800054fa:	00f14783          	lbu	a5,15(sp)
800054fe:	863a                	mv	a2,a4
80005500:	45a2                	lw	a1,8(sp)
80005502:	853e                	mv	a0,a5
80005504:	3ead                	jal	8000507e <wiz_send_data>

   #if _WIZCHIP_ == 5300
      setSn_TX_WRSR(sn,len);
   #endif
   
   setSn_CR(sn,Sn_CR_SEND);
80005506:	00f14783          	lbu	a5,15(sp)
8000550a:	078a                	sll	a5,a5,0x2
8000550c:	0785                	add	a5,a5,1
8000550e:	078e                	sll	a5,a5,0x3
80005510:	10078793          	add	a5,a5,256
80005514:	02000593          	li	a1,32
80005518:	853e                	mv	a0,a5
8000551a:	388040ef          	jal	800098a2 <WIZCHIP_WRITE>
   /* wait to process the command... */
   while(getSn_CR(sn));
8000551e:	0001                	nop

80005520 <.L74>:
80005520:	00f14783          	lbu	a5,15(sp)
80005524:	078a                	sll	a5,a5,0x2
80005526:	0785                	add	a5,a5,1
80005528:	078e                	sll	a5,a5,0x3
8000552a:	10078793          	add	a5,a5,256
8000552e:	853e                	mv	a0,a5
80005530:	3a5d                	jal	80004ee6 <WIZCHIP_READ>
80005532:	87aa                	mv	a5,a0
80005534:	f7f5                	bnez	a5,80005520 <.L74>
   sock_is_sending |= (1 << sn);
80005536:	00f14783          	lbu	a5,15(sp)
8000553a:	4705                	li	a4,1
8000553c:	00f717b3          	sll	a5,a4,a5
80005540:	01079713          	sll	a4,a5,0x10
80005544:	8741                	sra	a4,a4,0x10
80005546:	11e1d783          	lhu	a5,286(gp) # 108091e <sock_is_sending>
8000554a:	07c2                	sll	a5,a5,0x10
8000554c:	87c1                	sra	a5,a5,0x10
8000554e:	8fd9                	or	a5,a5,a4
80005550:	07c2                	sll	a5,a5,0x10
80005552:	87c1                	sra	a5,a5,0x10
80005554:	01079713          	sll	a4,a5,0x10
80005558:	8341                	srl	a4,a4,0x10
8000555a:	10e19f23          	sh	a4,286(gp) # 108091e <sock_is_sending>
   //M20150409 : Explicit Type Casting
   //return len;
   return (int32_t)len;
8000555e:	00c15783          	lhu	a5,12(sp)

80005562 <.L61>:
}
80005562:	853e                	mv	a0,a5
80005564:	50b2                	lw	ra,44(sp)
80005566:	6145                	add	sp,sp,48
80005568:	8082                	ret

Disassembly of section .text.wizchip_bus_writedata:

8000556a <wizchip_bus_writedata>:
 * @note This function help not to access wrong address. If you do not describe this function or register any functions,
 * null function is called.
 */
//M20150601 : Rename the function for integrating with W5300
//void 	wizchip_bus_writebyte(uint32_t AddrSel, uint8_t wb)  { *((volatile uint8_t*)((ptrdiff_t)AddrSel)) = wb; }
void 	wizchip_bus_writedata(uint32_t AddrSel, iodata_t wb)  { *((volatile iodata_t*)((ptrdiff_t)AddrSel)) = wb; }
8000556a:	1141                	add	sp,sp,-16
8000556c:	c62a                	sw	a0,12(sp)
8000556e:	87ae                	mv	a5,a1
80005570:	00f105a3          	sb	a5,11(sp)
80005574:	47b2                	lw	a5,12(sp)
80005576:	00b14703          	lbu	a4,11(sp)
8000557a:	00e78023          	sb	a4,0(a5)
8000557e:	0001                	nop
80005580:	0141                	add	sp,sp,16
80005582:	8082                	ret

Disassembly of section .text.wizchip_spi_readbyte:

80005584 <wizchip_spi_readbyte>:
 * @brief Default function to read in SPI interface.
 * @note This function help not to access wrong address. If you do not describe this function or register any functions,
 * null function is called.
 */
//uint8_t wizchip_spi_readbyte(void)        {return 0;};
uint8_t wizchip_spi_readbyte(void)        {return 0;}
80005584:	4781                	li	a5,0
80005586:	853e                	mv	a0,a5
80005588:	8082                	ret

Disassembly of section .text.wizchip_spi_writebyte:

8000558a <wizchip_spi_writebyte>:
 * @brief Default function to write in SPI interface.
 * @note This function help not to access wrong address. If you do not describe this function or register any functions,
 * null function is called.
 */
//void 	wizchip_spi_writebyte(uint8_t wb) {};
void 	wizchip_spi_writebyte(uint8_t wb) {}
8000558a:	1141                	add	sp,sp,-16
8000558c:	87aa                	mv	a5,a0
8000558e:	00f107a3          	sb	a5,15(sp)
80005592:	0001                	nop
80005594:	0141                	add	sp,sp,16
80005596:	8082                	ret

Disassembly of section .text.ctlwizchip:

80005598 <ctlwizchip>:
      WIZCHIP.IF.SPI._write_burst  = spi_wb;
   }
}

int8_t ctlwizchip(ctlwizchip_type cwtype, void* arg)
{
80005598:	7179                	add	sp,sp,-48
8000559a:	d606                	sw	ra,44(sp)
8000559c:	d422                	sw	s0,40(sp)
8000559e:	87aa                	mv	a5,a0
800055a0:	c42e                	sw	a1,8(sp)
800055a2:	00f107a3          	sb	a5,15(sp)
#if	_WIZCHIP_ == W5100S || _WIZCHIP_ == W5200 || _WIZCHIP_ == W5500
   uint8_t tmp = 0;
800055a6:	00010fa3          	sb	zero,31(sp)
#endif
   uint8_t* ptmp[2] = {0,0};
800055aa:	ca02                	sw	zero,20(sp)
800055ac:	cc02                	sw	zero,24(sp)
   switch(cwtype)
800055ae:	00f14783          	lbu	a5,15(sp)
800055b2:	473d                	li	a4,15
800055b4:	1af76363          	bltu	a4,a5,8000575a <.L37>
800055b8:	00279713          	sll	a4,a5,0x2
800055bc:	800037b7          	lui	a5,0x80003
800055c0:	1cc78793          	add	a5,a5,460 # 800031cc <.L39>
800055c4:	97ba                	add	a5,a5,a4
800055c6:	439c                	lw	a5,0(a5)
800055c8:	8782                	jr	a5

800055ca <.L54>:
   {
      case CW_RESET_WIZCHIP:
         wizchip_sw_reset();
800055ca:	5fc050ef          	jal	8000abc6 <wizchip_sw_reset>
         break;
800055ce:	aa49                	j	80005760 <.L55>

800055d0 <.L53>:
      case CW_INIT_WIZCHIP:
         if(arg != 0) 
800055d0:	47a2                	lw	a5,8(sp)
800055d2:	c791                	beqz	a5,800055de <.L56>
         {
            ptmp[0] = (uint8_t*)arg;
800055d4:	47a2                	lw	a5,8(sp)
800055d6:	ca3e                	sw	a5,20(sp)
            ptmp[1] = ptmp[0] + _WIZCHIP_SOCK_NUM_;
800055d8:	47d2                	lw	a5,20(sp)
800055da:	07a1                	add	a5,a5,8
800055dc:	cc3e                	sw	a5,24(sp)

800055de <.L56>:
         }
         return wizchip_init(ptmp[0], ptmp[1]);
800055de:	47d2                	lw	a5,20(sp)
800055e0:	4762                	lw	a4,24(sp)
800055e2:	85ba                	mv	a1,a4
800055e4:	853e                	mv	a0,a5
800055e6:	2ad5                	jal	800057da <wizchip_init>
800055e8:	87aa                	mv	a5,a0
800055ea:	aaa5                	j	80005762 <.L60>

800055ec <.L51>:
      case CW_CLR_INTERRUPT:
         wizchip_clrinterrupt(*((intr_kind*)arg));
800055ec:	47a2                	lw	a5,8(sp)
800055ee:	0007d783          	lhu	a5,0(a5)
800055f2:	853e                	mv	a0,a5
800055f4:	666050ef          	jal	8000ac5a <wizchip_clrinterrupt>
         break;
800055f8:	a2a5                	j	80005760 <.L55>

800055fa <.L52>:
      case CW_GET_INTERRUPT:
        *((intr_kind*)arg) = wizchip_getinterrupt();
800055fa:	6e0050ef          	jal	8000acda <wizchip_getinterrupt>
800055fe:	87aa                	mv	a5,a0
80005600:	873e                	mv	a4,a5
80005602:	47a2                	lw	a5,8(sp)
80005604:	00e79023          	sh	a4,0(a5)
         break;
80005608:	aaa1                	j	80005760 <.L55>

8000560a <.L50>:
      case CW_SET_INTRMASK:
         wizchip_setinterruptmask(*((intr_kind*)arg));
8000560a:	47a2                	lw	a5,8(sp)
8000560c:	0007d783          	lhu	a5,0(a5)
80005610:	853e                	mv	a0,a5
80005612:	728050ef          	jal	8000ad3a <wizchip_setinterruptmask>
         break;         
80005616:	a2a9                	j	80005760 <.L55>

80005618 <.L49>:
      case CW_GET_INTRMASK:
         *((intr_kind*)arg) = wizchip_getinterruptmask();
80005618:	2e21                	jal	80005930 <wizchip_getinterruptmask>
8000561a:	87aa                	mv	a5,a0
8000561c:	873e                	mv	a4,a5
8000561e:	47a2                	lw	a5,8(sp)
80005620:	00e79023          	sh	a4,0(a5)
         break;
80005624:	aa35                	j	80005760 <.L55>

80005626 <.L48>:
   //M20150601 : This can be supported by W5200, W5500
   //#if _WIZCHIP_ > W5100
   #if (_WIZCHIP_ == W5200 || _WIZCHIP_ == W5500)
      case CW_SET_INTRTIME:
         setINTLEVEL(*(uint16_t*)arg);
80005626:	47a2                	lw	a5,8(sp)
80005628:	0007d783          	lhu	a5,0(a5)
8000562c:	83a1                	srl	a5,a5,0x8
8000562e:	07c2                	sll	a5,a5,0x10
80005630:	83c1                	srl	a5,a5,0x10
80005632:	0ff7f793          	zext.b	a5,a5
80005636:	85be                	mv	a1,a5
80005638:	6785                	lui	a5,0x1
8000563a:	30078513          	add	a0,a5,768 # 1300 <__fw_size__+0x300>
8000563e:	264040ef          	jal	800098a2 <WIZCHIP_WRITE>
80005642:	47a2                	lw	a5,8(sp)
80005644:	0007d783          	lhu	a5,0(a5)
80005648:	0ff7f793          	zext.b	a5,a5
8000564c:	85be                	mv	a1,a5
8000564e:	6785                	lui	a5,0x1
80005650:	40078513          	add	a0,a5,1024 # 1400 <__fw_size__+0x400>
80005654:	24e040ef          	jal	800098a2 <WIZCHIP_WRITE>
         break;
80005658:	a221                	j	80005760 <.L55>

8000565a <.L47>:
      case CW_GET_INTRTIME:
         *(uint16_t*)arg = getINTLEVEL();
8000565a:	6785                	lui	a5,0x1
8000565c:	30078513          	add	a0,a5,768 # 1300 <__fw_size__+0x300>
80005660:	3059                	jal	80004ee6 <WIZCHIP_READ>
80005662:	87aa                	mv	a5,a0
80005664:	07a2                	sll	a5,a5,0x8
80005666:	01079413          	sll	s0,a5,0x10
8000566a:	8041                	srl	s0,s0,0x10
8000566c:	6785                	lui	a5,0x1
8000566e:	40078513          	add	a0,a5,1024 # 1400 <__fw_size__+0x400>
80005672:	3895                	jal	80004ee6 <WIZCHIP_READ>
80005674:	87aa                	mv	a5,a0
80005676:	97a2                	add	a5,a5,s0
80005678:	01079713          	sll	a4,a5,0x10
8000567c:	8341                	srl	a4,a4,0x10
8000567e:	47a2                	lw	a5,8(sp)
80005680:	00e79023          	sh	a4,0(a5)
         break;
80005684:	a8f1                	j	80005760 <.L55>

80005686 <.L46>:
   #endif
      case CW_GET_ID:
         ((uint8_t*)arg)[0] = WIZCHIP.id[0];
80005686:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000568a:	0027c703          	lbu	a4,2(a5)
8000568e:	47a2                	lw	a5,8(sp)
80005690:	00e78023          	sb	a4,0(a5)
         ((uint8_t*)arg)[1] = WIZCHIP.id[1];
80005694:	47a2                	lw	a5,8(sp)
80005696:	0785                	add	a5,a5,1
80005698:	80018713          	add	a4,gp,-2048 # 1080000 <WIZCHIP>
8000569c:	00374703          	lbu	a4,3(a4)
800056a0:	00e78023          	sb	a4,0(a5)
         ((uint8_t*)arg)[2] = WIZCHIP.id[2];
800056a4:	47a2                	lw	a5,8(sp)
800056a6:	0789                	add	a5,a5,2
800056a8:	80018713          	add	a4,gp,-2048 # 1080000 <WIZCHIP>
800056ac:	00474703          	lbu	a4,4(a4)
800056b0:	00e78023          	sb	a4,0(a5)
         ((uint8_t*)arg)[3] = WIZCHIP.id[3];
800056b4:	47a2                	lw	a5,8(sp)
800056b6:	078d                	add	a5,a5,3
800056b8:	80018713          	add	a4,gp,-2048 # 1080000 <WIZCHIP>
800056bc:	00574703          	lbu	a4,5(a4)
800056c0:	00e78023          	sb	a4,0(a5)
         ((uint8_t*)arg)[4] = WIZCHIP.id[4];
800056c4:	47a2                	lw	a5,8(sp)
800056c6:	0791                	add	a5,a5,4
800056c8:	80018713          	add	a4,gp,-2048 # 1080000 <WIZCHIP>
800056cc:	00674703          	lbu	a4,6(a4)
800056d0:	00e78023          	sb	a4,0(a5)
         ((uint8_t*)arg)[5] = WIZCHIP.id[5];
800056d4:	47a2                	lw	a5,8(sp)
800056d6:	0795                	add	a5,a5,5
800056d8:	80018713          	add	a4,gp,-2048 # 1080000 <WIZCHIP>
800056dc:	00774703          	lbu	a4,7(a4)
800056e0:	00e78023          	sb	a4,0(a5)
         ((uint8_t*)arg)[6] = 0;
800056e4:	47a2                	lw	a5,8(sp)
800056e6:	0799                	add	a5,a5,6
800056e8:	00078023          	sb	zero,0(a5)
         break;
800056ec:	a895                	j	80005760 <.L55>

800056ee <.L45>:
   #if _WIZCHIP_ == W5100S || _WIZCHIP_ == W5500
      case CW_RESET_PHY:
         wizphy_reset();
800056ee:	6cc050ef          	jal	8000adba <wizphy_reset>
         break;
800056f2:	a0bd                	j	80005760 <.L55>

800056f4 <.L44>:
      case CW_SET_PHYCONF:
         wizphy_setphyconf((wiz_PhyConf*)arg);
800056f4:	4522                	lw	a0,8(sp)
800056f6:	24c9                	jal	800059b8 <wizphy_setphyconf>
         break;
800056f8:	a0a5                	j	80005760 <.L55>

800056fa <.L43>:
      case CW_GET_PHYCONF:
         wizphy_getphyconf((wiz_PhyConf*)arg);
800056fa:	4522                	lw	a0,8(sp)
800056fc:	26bd                	jal	80005a6a <wizphy_getphyconf>
         break;
800056fe:	a08d                	j	80005760 <.L55>

80005700 <.L41>:
      case CW_GET_PHYSTATUS:
         break;
      case CW_SET_PHYPOWMODE:
         return wizphy_setphypmode(*(uint8_t*)arg);
80005700:	47a2                	lw	a5,8(sp)
80005702:	0007c783          	lbu	a5,0(a5)
80005706:	853e                	mv	a0,a5
80005708:	716050ef          	jal	8000ae1e <wizphy_setphypmode>
8000570c:	87aa                	mv	a5,a0
8000570e:	a891                	j	80005762 <.L60>

80005710 <.L40>:
   #endif
   #if _WIZCHIP_ == W5100S || _WIZCHIP_ == W5200 || _WIZCHIP_ == W5500
      case CW_GET_PHYPOWMODE:
         tmp = wizphy_getphypmode();
80005710:	672050ef          	jal	8000ad82 <wizphy_getphypmode>
80005714:	87aa                	mv	a5,a0
80005716:	00f10fa3          	sb	a5,31(sp)
         if((int8_t)tmp == -1) return -1;
8000571a:	01f14703          	lbu	a4,31(sp)
8000571e:	0ff00793          	li	a5,255
80005722:	00f71463          	bne	a4,a5,8000572a <.L58>
80005726:	57fd                	li	a5,-1
80005728:	a82d                	j	80005762 <.L60>

8000572a <.L58>:
         *(uint8_t*)arg = tmp;
8000572a:	47a2                	lw	a5,8(sp)
8000572c:	01f14703          	lbu	a4,31(sp)
80005730:	00e78023          	sb	a4,0(a5)
         break;
80005734:	a035                	j	80005760 <.L55>

80005736 <.L38>:
      case CW_GET_PHYLINK:
         tmp = wizphy_getphylink();
80005736:	2ca1                	jal	8000598e <wizphy_getphylink>
80005738:	87aa                	mv	a5,a0
8000573a:	00f10fa3          	sb	a5,31(sp)
         if((int8_t)tmp == -1) return -1;
8000573e:	01f14703          	lbu	a4,31(sp)
80005742:	0ff00793          	li	a5,255
80005746:	00f71463          	bne	a4,a5,8000574e <.L59>
8000574a:	57fd                	li	a5,-1
8000574c:	a819                	j	80005762 <.L60>

8000574e <.L59>:
         *(uint8_t*)arg = tmp;
8000574e:	47a2                	lw	a5,8(sp)
80005750:	01f14703          	lbu	a4,31(sp)
80005754:	00e78023          	sb	a4,0(a5)
         break;
80005758:	a021                	j	80005760 <.L55>

8000575a <.L37>:
   #endif      
      default:
         return -1;
8000575a:	57fd                	li	a5,-1
8000575c:	a019                	j	80005762 <.L60>

8000575e <.L61>:
         break;
8000575e:	0001                	nop

80005760 <.L55>:
   }
   return 0;
80005760:	4781                	li	a5,0

80005762 <.L60>:
}
80005762:	853e                	mv	a0,a5
80005764:	50b2                	lw	ra,44(sp)
80005766:	5422                	lw	s0,40(sp)
80005768:	6145                	add	sp,sp,48
8000576a:	8082                	ret

Disassembly of section .text.ctlnetwork:

8000576c <ctlnetwork>:


int8_t ctlnetwork(ctlnetwork_type cntype, void* arg)
{
8000576c:	1101                	add	sp,sp,-32
8000576e:	ce06                	sw	ra,28(sp)
80005770:	87aa                	mv	a5,a0
80005772:	c42e                	sw	a1,8(sp)
80005774:	00f107a3          	sb	a5,15(sp)
   
   switch(cntype)
80005778:	00f14783          	lbu	a5,15(sp)
8000577c:	4715                	li	a4,5
8000577e:	04f76763          	bltu	a4,a5,800057cc <.L63>
80005782:	00279713          	sll	a4,a5,0x2
80005786:	800037b7          	lui	a5,0x80003
8000578a:	20c78793          	add	a5,a5,524 # 8000320c <.L65>
8000578e:	97ba                	add	a5,a5,a4
80005790:	439c                	lw	a5,0(a5)
80005792:	8782                	jr	a5

80005794 <.L70>:
   {
      case CN_SET_NETINFO:
         wizchip_setnetinfo((wiz_NetInfo*)arg);
80005794:	4522                	lw	a0,8(sp)
80005796:	2e5d                	jal	80005b4c <wizchip_setnetinfo>
         break;
80005798:	a825                	j	800057d0 <.L71>

8000579a <.L69>:
      case CN_GET_NETINFO:
         wizchip_getnetinfo((wiz_NetInfo*)arg);
8000579a:	4522                	lw	a0,8(sp)
8000579c:	293d                	jal	80005bda <wizchip_getnetinfo>
         break;
8000579e:	a80d                	j	800057d0 <.L71>

800057a0 <.L68>:
      case CN_SET_NETMODE:
         return wizchip_setnetmode(*(netmode_type*)arg);
800057a0:	47a2                	lw	a5,8(sp)
800057a2:	0007c783          	lbu	a5,0(a5)
800057a6:	853e                	mv	a0,a5
800057a8:	21c1                	jal	80005c68 <wizchip_setnetmode>
800057aa:	87aa                	mv	a5,a0
800057ac:	a01d                	j	800057d2 <.L72>

800057ae <.L67>:
      case CN_GET_NETMODE:
         *(netmode_type*)arg = wizchip_getnetmode();
800057ae:	71e050ef          	jal	8000aecc <wizchip_getnetmode>
800057b2:	87aa                	mv	a5,a0
800057b4:	873e                	mv	a4,a5
800057b6:	47a2                	lw	a5,8(sp)
800057b8:	00e78023          	sb	a4,0(a5)
         break;
800057bc:	a811                	j	800057d0 <.L71>

800057be <.L66>:
      case CN_SET_TIMEOUT:
         wizchip_settimeout((wiz_NetTimeout*)arg);
800057be:	4522                	lw	a0,8(sp)
800057c0:	29dd                	jal	80005cb6 <wizchip_settimeout>
         break;
800057c2:	a039                	j	800057d0 <.L71>

800057c4 <.L64>:
      case CN_GET_TIMEOUT:
         wizchip_gettimeout((wiz_NetTimeout*)arg);
800057c4:	4522                	lw	a0,8(sp)
800057c6:	71a050ef          	jal	8000aee0 <wizchip_gettimeout>
         break;
800057ca:	a019                	j	800057d0 <.L71>

800057cc <.L63>:
      default:
         return -1;
800057cc:	57fd                	li	a5,-1
800057ce:	a011                	j	800057d2 <.L72>

800057d0 <.L71>:
   }
   return 0;
800057d0:	4781                	li	a5,0

800057d2 <.L72>:
}
800057d2:	853e                	mv	a0,a5
800057d4:	40f2                	lw	ra,28(sp)
800057d6:	6105                	add	sp,sp,32
800057d8:	8082                	ret

Disassembly of section .text.wizchip_init:

800057da <wizchip_init>:
   setSUBR(sn);
   setSIPR(sip);
}

int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize)
{
800057da:	7179                	add	sp,sp,-48
800057dc:	d606                	sw	ra,44(sp)
800057de:	c62a                	sw	a0,12(sp)
800057e0:	c42e                	sw	a1,8(sp)
   int8_t i;
#if _WIZCHIP_ < W5200
   int8_t j;
#endif
   int8_t tmp = 0;
800057e2:	00010f23          	sb	zero,30(sp)
   wizchip_sw_reset();
800057e6:	3e0050ef          	jal	8000abc6 <wizchip_sw_reset>
   if(txsize)
800057ea:	47b2                	lw	a5,12(sp)
800057ec:	cfd1                	beqz	a5,80005888 <.L75>
   {
      tmp = 0;
800057ee:	00010f23          	sb	zero,30(sp)
			tmp += txsize[i];
			if(tmp > 128) return -1;
		}
		if(tmp % 8) return -1;
#else
		for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
800057f2:	00010fa3          	sb	zero,31(sp)
800057f6:	a835                	j	80005832 <.L76>

800057f8 <.L79>:
		{
			tmp += txsize[i];
800057f8:	01f10783          	lb	a5,31(sp)
800057fc:	4732                	lw	a4,12(sp)
800057fe:	97ba                	add	a5,a5,a4
80005800:	0007c703          	lbu	a4,0(a5)
80005804:	01e14783          	lbu	a5,30(sp)
80005808:	97ba                	add	a5,a5,a4
8000580a:	0ff7f793          	zext.b	a5,a5
8000580e:	00f10f23          	sb	a5,30(sp)

#if _WIZCHIP_ < W5200	//2016.10.28 peter add condition for w5100 and w5100s
			if(tmp > 8) return -1;
#else
			if(tmp > 16) return -1;
80005812:	01e10703          	lb	a4,30(sp)
80005816:	47c1                	li	a5,16
80005818:	00e7d463          	bge	a5,a4,80005820 <.L77>
8000581c:	57fd                	li	a5,-1
8000581e:	a229                	j	80005928 <.L78>

80005820 <.L77>:
		for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
80005820:	01f10783          	lb	a5,31(sp)
80005824:	0ff7f793          	zext.b	a5,a5
80005828:	0785                	add	a5,a5,1
8000582a:	0ff7f793          	zext.b	a5,a5
8000582e:	00f10fa3          	sb	a5,31(sp)

80005832 <.L76>:
80005832:	01f10703          	lb	a4,31(sp)
80005836:	479d                	li	a5,7
80005838:	fce7d0e3          	bge	a5,a4,800057f8 <.L79>
#endif
		}
#endif
		for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
8000583c:	00010fa3          	sb	zero,31(sp)
80005840:	a83d                	j	8000587e <.L80>

80005842 <.L81>:
#if _WIZCHIP_ < W5200	//2016.10.28 peter add condition for w5100
			j = 0;
			while((txsize[i] >> j != 1)&&(txsize[i] !=0)){j++;}
			setSn_TXBUF_SIZE(i, j);
#else
			setSn_TXBUF_SIZE(i, txsize[i]);
80005842:	01f10783          	lb	a5,31(sp)
80005846:	078a                	sll	a5,a5,0x2
80005848:	0785                	add	a5,a5,1
8000584a:	00379713          	sll	a4,a5,0x3
8000584e:	6789                	lui	a5,0x2
80005850:	f0078793          	add	a5,a5,-256 # 1f00 <__fw_size__+0xf00>
80005854:	97ba                	add	a5,a5,a4
80005856:	86be                	mv	a3,a5
80005858:	01f10783          	lb	a5,31(sp)
8000585c:	4732                	lw	a4,12(sp)
8000585e:	97ba                	add	a5,a5,a4
80005860:	0007c783          	lbu	a5,0(a5)
80005864:	85be                	mv	a1,a5
80005866:	8536                	mv	a0,a3
80005868:	03a040ef          	jal	800098a2 <WIZCHIP_WRITE>
		for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
8000586c:	01f10783          	lb	a5,31(sp)
80005870:	0ff7f793          	zext.b	a5,a5
80005874:	0785                	add	a5,a5,1
80005876:	0ff7f793          	zext.b	a5,a5
8000587a:	00f10fa3          	sb	a5,31(sp)

8000587e <.L80>:
8000587e:	01f10703          	lb	a4,31(sp)
80005882:	479d                	li	a5,7
80005884:	fae7dfe3          	bge	a5,a4,80005842 <.L81>

80005888 <.L75>:
#endif
		}	
   }

   if(rxsize)
80005888:	47a2                	lw	a5,8(sp)
8000588a:	cfd1                	beqz	a5,80005926 <.L82>
   {
      tmp = 0;
8000588c:	00010f23          	sb	zero,30(sp)
			tmp += rxsize[i];
			if(tmp > 128) return -1;
		}
		if(tmp % 8) return -1;
#else
		for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
80005890:	00010fa3          	sb	zero,31(sp)
80005894:	a835                	j	800058d0 <.L83>

80005896 <.L85>:
		{
			tmp += rxsize[i];
80005896:	01f10783          	lb	a5,31(sp)
8000589a:	4722                	lw	a4,8(sp)
8000589c:	97ba                	add	a5,a5,a4
8000589e:	0007c703          	lbu	a4,0(a5)
800058a2:	01e14783          	lbu	a5,30(sp)
800058a6:	97ba                	add	a5,a5,a4
800058a8:	0ff7f793          	zext.b	a5,a5
800058ac:	00f10f23          	sb	a5,30(sp)
#if _WIZCHIP_ < W5200	//2016.10.28 peter add condition for w5100 and w5100s
			if(tmp > 8) return -1;
#else
			if(tmp > 16) return -1;
800058b0:	01e10703          	lb	a4,30(sp)
800058b4:	47c1                	li	a5,16
800058b6:	00e7d463          	bge	a5,a4,800058be <.L84>
800058ba:	57fd                	li	a5,-1
800058bc:	a0b5                	j	80005928 <.L78>

800058be <.L84>:
		for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
800058be:	01f10783          	lb	a5,31(sp)
800058c2:	0ff7f793          	zext.b	a5,a5
800058c6:	0785                	add	a5,a5,1
800058c8:	0ff7f793          	zext.b	a5,a5
800058cc:	00f10fa3          	sb	a5,31(sp)

800058d0 <.L83>:
800058d0:	01f10703          	lb	a4,31(sp)
800058d4:	479d                	li	a5,7
800058d6:	fce7d0e3          	bge	a5,a4,80005896 <.L85>
#endif
		}
#endif
		for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
800058da:	00010fa3          	sb	zero,31(sp)
800058de:	a83d                	j	8000591c <.L86>

800058e0 <.L87>:
#if _WIZCHIP_ < W5200	// add condition for w5100
			j = 0;
			while((rxsize[i] >> j != 1)&&(txsize[i] !=0)){j++;}
			setSn_RXBUF_SIZE(i, j);
#else
			setSn_RXBUF_SIZE(i, rxsize[i]);
800058e0:	01f10783          	lb	a5,31(sp)
800058e4:	078a                	sll	a5,a5,0x2
800058e6:	0785                	add	a5,a5,1
800058e8:	00379713          	sll	a4,a5,0x3
800058ec:	6789                	lui	a5,0x2
800058ee:	e0078793          	add	a5,a5,-512 # 1e00 <__fw_size__+0xe00>
800058f2:	97ba                	add	a5,a5,a4
800058f4:	86be                	mv	a3,a5
800058f6:	01f10783          	lb	a5,31(sp)
800058fa:	4722                	lw	a4,8(sp)
800058fc:	97ba                	add	a5,a5,a4
800058fe:	0007c783          	lbu	a5,0(a5)
80005902:	85be                	mv	a1,a5
80005904:	8536                	mv	a0,a3
80005906:	79d030ef          	jal	800098a2 <WIZCHIP_WRITE>
		for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
8000590a:	01f10783          	lb	a5,31(sp)
8000590e:	0ff7f793          	zext.b	a5,a5
80005912:	0785                	add	a5,a5,1
80005914:	0ff7f793          	zext.b	a5,a5
80005918:	00f10fa3          	sb	a5,31(sp)

8000591c <.L86>:
8000591c:	01f10703          	lb	a4,31(sp)
80005920:	479d                	li	a5,7
80005922:	fae7dfe3          	bge	a5,a4,800058e0 <.L87>

80005926 <.L82>:
#endif
		}
   }
   return 0;
80005926:	4781                	li	a5,0

80005928 <.L78>:
}
80005928:	853e                	mv	a0,a5
8000592a:	50b2                	lw	ra,44(sp)
8000592c:	6145                	add	sp,sp,48
8000592e:	8082                	ret

Disassembly of section .text.wizchip_getinterruptmask:

80005930 <wizchip_getinterruptmask>:
   setSIMR(simr);
#endif   
}

intr_kind wizchip_getinterruptmask(void)
{
80005930:	1101                	add	sp,sp,-32
80005932:	ce06                	sw	ra,28(sp)
   uint8_t imr  = 0;
80005934:	000107a3          	sb	zero,15(sp)
   uint8_t simr = 0;
80005938:	00010723          	sb	zero,14(sp)
   uint16_t ret = 0;
8000593c:	00011623          	sh	zero,12(sp)
#elif _WIZCHIP_ == W5300
   ret = getIMR();
   imr = (uint8_t)(ret >> 8);
   simr = (uint8_t)ret;
#else
   imr  = getIMR();
80005940:	6785                	lui	a5,0x1
80005942:	60078513          	add	a0,a5,1536 # 1600 <__fw_size__+0x600>
80005946:	da0ff0ef          	jal	80004ee6 <WIZCHIP_READ>
8000594a:	87aa                	mv	a5,a0
8000594c:	00f107a3          	sb	a5,15(sp)
   simr = getSIMR();
80005950:	6789                	lui	a5,0x2
80005952:	80078513          	add	a0,a5,-2048 # 1800 <__fw_size__+0x800>
80005956:	d90ff0ef          	jal	80004ee6 <WIZCHIP_READ>
8000595a:	87aa                	mv	a5,a0
8000595c:	00f10723          	sb	a5,14(sp)
   imr &= ~(1<<4); // IK_WOL
#endif
#if _WIZCHIP_ == W5200
   imr &= ~(1 << 6);  // IK_DEST_UNREACH
#endif
  ret = simr;
80005960:	00e14783          	lbu	a5,14(sp)
80005964:	00f11623          	sh	a5,12(sp)
  ret = (ret << 8) + imr;
80005968:	00c15783          	lhu	a5,12(sp)
8000596c:	07a2                	sll	a5,a5,0x8
8000596e:	01079713          	sll	a4,a5,0x10
80005972:	8341                	srl	a4,a4,0x10
80005974:	00f14783          	lbu	a5,15(sp)
80005978:	07c2                	sll	a5,a5,0x10
8000597a:	83c1                	srl	a5,a5,0x10
8000597c:	97ba                	add	a5,a5,a4
8000597e:	00f11623          	sh	a5,12(sp)
  return (intr_kind)ret;
80005982:	00c15783          	lhu	a5,12(sp)
}
80005986:	853e                	mv	a0,a5
80005988:	40f2                	lw	ra,28(sp)
8000598a:	6105                	add	sp,sp,32
8000598c:	8082                	ret

Disassembly of section .text.wizphy_getphylink:

8000598e <wizphy_getphylink>:

int8_t wizphy_getphylink(void)
{
8000598e:	1101                	add	sp,sp,-32
80005990:	ce06                	sw	ra,28(sp)
   int8_t tmp = PHY_LINK_OFF;
80005992:	000107a3          	sb	zero,15(sp)
	   tmp = PHY_LINK_ON;
#elif   _WIZCHIP_ == W5200
   if(getPHYSTATUS() & PHYSTATUS_LINK)
      tmp = PHY_LINK_ON;
#elif _WIZCHIP_ == W5500
   if(getPHYCFGR() & PHYCFGR_LNK_ON)
80005996:	678d                	lui	a5,0x3
80005998:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000599c:	d4aff0ef          	jal	80004ee6 <WIZCHIP_READ>
800059a0:	87aa                	mv	a5,a0
800059a2:	8b85                	and	a5,a5,1
800059a4:	c781                	beqz	a5,800059ac <.L98>
      tmp = PHY_LINK_ON;
800059a6:	4785                	li	a5,1
800059a8:	00f107a3          	sb	a5,15(sp)

800059ac <.L98>:

#else
   tmp = -1;
#endif
   return tmp;
800059ac:	00f10783          	lb	a5,15(sp)
}
800059b0:	853e                	mv	a0,a5
800059b2:	40f2                	lw	ra,28(sp)
800059b4:	6105                	add	sp,sp,32
800059b6:	8082                	ret

Disassembly of section .text.wizphy_setphyconf:

800059b8 <wizphy_setphyconf>:
   tmp |= ~PHYCFGR_RST;
   setPHYCFGR(tmp);
}

void wizphy_setphyconf(wiz_PhyConf* phyconf)
{
800059b8:	7179                	add	sp,sp,-48
800059ba:	d606                	sw	ra,44(sp)
800059bc:	c62a                	sw	a0,12(sp)
   uint8_t tmp = 0;
800059be:	00010fa3          	sb	zero,31(sp)
   if(phyconf->by == PHY_CONFBY_SW)
800059c2:	47b2                	lw	a5,12(sp)
800059c4:	0007c703          	lbu	a4,0(a5)
800059c8:	4785                	li	a5,1
800059ca:	00f71963          	bne	a4,a5,800059dc <.L106>
      tmp |= PHYCFGR_OPMD;
800059ce:	01f14783          	lbu	a5,31(sp)
800059d2:	0407e793          	or	a5,a5,64
800059d6:	00f10fa3          	sb	a5,31(sp)
800059da:	a039                	j	800059e8 <.L107>

800059dc <.L106>:
   else
      tmp &= ~PHYCFGR_OPMD;
800059dc:	01f14783          	lbu	a5,31(sp)
800059e0:	fbf7f793          	and	a5,a5,-65
800059e4:	00f10fa3          	sb	a5,31(sp)

800059e8 <.L107>:
   if(phyconf->mode == PHY_MODE_AUTONEGO)
800059e8:	47b2                	lw	a5,12(sp)
800059ea:	0017c703          	lbu	a4,1(a5)
800059ee:	4785                	li	a5,1
800059f0:	00f71963          	bne	a4,a5,80005a02 <.L108>
      tmp |= PHYCFGR_OPMDC_ALLA;
800059f4:	01f14783          	lbu	a5,31(sp)
800059f8:	0387e793          	or	a5,a5,56
800059fc:	00f10fa3          	sb	a5,31(sp)
80005a00:	a0b9                	j	80005a4e <.L109>

80005a02 <.L108>:
   else
   {
      if(phyconf->duplex == PHY_DUPLEX_FULL)
80005a02:	47b2                	lw	a5,12(sp)
80005a04:	0037c703          	lbu	a4,3(a5)
80005a08:	4785                	li	a5,1
80005a0a:	02f71663          	bne	a4,a5,80005a36 <.L110>
      {
         if(phyconf->speed == PHY_SPEED_100)
80005a0e:	47b2                	lw	a5,12(sp)
80005a10:	0027c703          	lbu	a4,2(a5)
80005a14:	4785                	li	a5,1
80005a16:	00f71963          	bne	a4,a5,80005a28 <.L111>
            tmp |= PHYCFGR_OPMDC_100F;
80005a1a:	01f14783          	lbu	a5,31(sp)
80005a1e:	0187e793          	or	a5,a5,24
80005a22:	00f10fa3          	sb	a5,31(sp)
80005a26:	a025                	j	80005a4e <.L109>

80005a28 <.L111>:
         else
            tmp |= PHYCFGR_OPMDC_10F;
80005a28:	01f14783          	lbu	a5,31(sp)
80005a2c:	0087e793          	or	a5,a5,8
80005a30:	00f10fa3          	sb	a5,31(sp)
80005a34:	a829                	j	80005a4e <.L109>

80005a36 <.L110>:
      }   
      else
      {
         if(phyconf->speed == PHY_SPEED_100)
80005a36:	47b2                	lw	a5,12(sp)
80005a38:	0027c703          	lbu	a4,2(a5)
80005a3c:	4785                	li	a5,1
80005a3e:	00f71863          	bne	a4,a5,80005a4e <.L109>
            tmp |= PHYCFGR_OPMDC_100H;
80005a42:	01f14783          	lbu	a5,31(sp)
80005a46:	0107e793          	or	a5,a5,16
80005a4a:	00f10fa3          	sb	a5,31(sp)

80005a4e <.L109>:
         else
            tmp |= PHYCFGR_OPMDC_10H;
      }
   }
   setPHYCFGR(tmp);
80005a4e:	01f14783          	lbu	a5,31(sp)
80005a52:	85be                	mv	a1,a5
80005a54:	678d                	lui	a5,0x3
80005a56:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
80005a5a:	649030ef          	jal	800098a2 <WIZCHIP_WRITE>
   wizphy_reset();
80005a5e:	35c050ef          	jal	8000adba <wizphy_reset>
}
80005a62:	0001                	nop
80005a64:	50b2                	lw	ra,44(sp)
80005a66:	6145                	add	sp,sp,48
80005a68:	8082                	ret

Disassembly of section .text.wizphy_getphyconf:

80005a6a <wizphy_getphyconf>:

void wizphy_getphyconf(wiz_PhyConf* phyconf)
{
80005a6a:	7179                	add	sp,sp,-48
80005a6c:	d606                	sw	ra,44(sp)
80005a6e:	c62a                	sw	a0,12(sp)
   uint8_t tmp = 0;
80005a70:	00010fa3          	sb	zero,31(sp)
   tmp = getPHYCFGR();
80005a74:	678d                	lui	a5,0x3
80005a76:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
80005a7a:	c6cff0ef          	jal	80004ee6 <WIZCHIP_READ>
80005a7e:	87aa                	mv	a5,a0
80005a80:	00f10fa3          	sb	a5,31(sp)
   phyconf->by   = (tmp & PHYCFGR_OPMD) ? PHY_CONFBY_SW : PHY_CONFBY_HW;
80005a84:	01f14783          	lbu	a5,31(sp)
80005a88:	8799                	sra	a5,a5,0x6
80005a8a:	0ff7f793          	zext.b	a5,a5
80005a8e:	8b85                	and	a5,a5,1
80005a90:	0ff7f713          	zext.b	a4,a5
80005a94:	47b2                	lw	a5,12(sp)
80005a96:	00e78023          	sb	a4,0(a5)
   switch(tmp & PHYCFGR_OPMDC_ALLA)
80005a9a:	01f14783          	lbu	a5,31(sp)
80005a9e:	0387f793          	and	a5,a5,56
80005aa2:	02000713          	li	a4,32
80005aa6:	00e78663          	beq	a5,a4,80005ab2 <.L114>
80005aaa:	03800713          	li	a4,56
80005aae:	00e79763          	bne	a5,a4,80005abc <.L115>

80005ab2 <.L114>:
   {
      case PHYCFGR_OPMDC_ALLA:
      case PHYCFGR_OPMDC_100FA: 
         phyconf->mode = PHY_MODE_AUTONEGO;
80005ab2:	47b2                	lw	a5,12(sp)
80005ab4:	4705                	li	a4,1
80005ab6:	00e780a3          	sb	a4,1(a5)
         break;
80005aba:	a029                	j	80005ac4 <.L116>

80005abc <.L115>:
      default:
         phyconf->mode = PHY_MODE_MANUAL;
80005abc:	47b2                	lw	a5,12(sp)
80005abe:	000780a3          	sb	zero,1(a5)
         break;
80005ac2:	0001                	nop

80005ac4 <.L116>:
   }
   switch(tmp & PHYCFGR_OPMDC_ALLA)
80005ac4:	01f14783          	lbu	a5,31(sp)
80005ac8:	0387f793          	and	a5,a5,56
80005acc:	17c1                	add	a5,a5,-16
80005ace:	0117b713          	sltiu	a4,a5,17
80005ad2:	00173713          	seqz	a4,a4
80005ad6:	0ff77713          	zext.b	a4,a4
80005ada:	e30d                	bnez	a4,80005afc <.L117>
80005adc:	6741                	lui	a4,0x10
80005ade:	10170713          	add	a4,a4,257 # 10101 <__XPI0_segment_used_size__+0x40ad>
80005ae2:	00f757b3          	srl	a5,a4,a5
80005ae6:	8b85                	and	a5,a5,1
80005ae8:	00f037b3          	snez	a5,a5
80005aec:	0ff7f793          	zext.b	a5,a5
80005af0:	c791                	beqz	a5,80005afc <.L117>
   {
      case PHYCFGR_OPMDC_100FA:
      case PHYCFGR_OPMDC_100F:
      case PHYCFGR_OPMDC_100H:
         phyconf->speed = PHY_SPEED_100;
80005af2:	47b2                	lw	a5,12(sp)
80005af4:	4705                	li	a4,1
80005af6:	00e78123          	sb	a4,2(a5)
         break;
80005afa:	a029                	j	80005b04 <.L118>

80005afc <.L117>:
      default:
         phyconf->speed = PHY_SPEED_10;
80005afc:	47b2                	lw	a5,12(sp)
80005afe:	00078123          	sb	zero,2(a5)
         break;
80005b02:	0001                	nop

80005b04 <.L118>:
   }
   switch(tmp & PHYCFGR_OPMDC_ALLA)
80005b04:	01f14783          	lbu	a5,31(sp)
80005b08:	0387f793          	and	a5,a5,56
80005b0c:	17e1                	add	a5,a5,-8
80005b0e:	0197b713          	sltiu	a4,a5,25
80005b12:	00173713          	seqz	a4,a4
80005b16:	0ff77713          	zext.b	a4,a4
80005b1a:	e30d                	bnez	a4,80005b3c <.L119>
80005b1c:	01010737          	lui	a4,0x1010
80005b20:	0705                	add	a4,a4,1 # 1010001 <_extram_size+0x10001>
80005b22:	00f757b3          	srl	a5,a4,a5
80005b26:	8b85                	and	a5,a5,1
80005b28:	00f037b3          	snez	a5,a5
80005b2c:	0ff7f793          	zext.b	a5,a5
80005b30:	c791                	beqz	a5,80005b3c <.L119>
   {
      case PHYCFGR_OPMDC_100FA:
      case PHYCFGR_OPMDC_100F:
      case PHYCFGR_OPMDC_10F:
         phyconf->duplex = PHY_DUPLEX_FULL;
80005b32:	47b2                	lw	a5,12(sp)
80005b34:	4705                	li	a4,1
80005b36:	00e781a3          	sb	a4,3(a5)
         break;
80005b3a:	a029                	j	80005b44 <.L120>

80005b3c <.L119>:
      default:
         phyconf->duplex = PHY_DUPLEX_HALF;
80005b3c:	47b2                	lw	a5,12(sp)
80005b3e:	000781a3          	sb	zero,3(a5)
         break;
80005b42:	0001                	nop

80005b44 <.L120>:
   }
}
80005b44:	0001                	nop
80005b46:	50b2                	lw	ra,44(sp)
80005b48:	6145                	add	sp,sp,48
80005b4a:	8082                	ret

Disassembly of section .text.wizchip_setnetinfo:

80005b4c <wizchip_setnetinfo>:
}
#endif


void wizchip_setnetinfo(wiz_NetInfo* pnetinfo)
{
80005b4c:	1101                	add	sp,sp,-32
80005b4e:	ce06                	sw	ra,28(sp)
80005b50:	c62a                	sw	a0,12(sp)
   setSHAR(pnetinfo->mac);
80005b52:	47b2                	lw	a5,12(sp)
80005b54:	4619                	li	a2,6
80005b56:	85be                	mv	a1,a5
80005b58:	6785                	lui	a5,0x1
80005b5a:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
80005b5e:	c32ff0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setGAR(pnetinfo->gw);
80005b62:	47b2                	lw	a5,12(sp)
80005b64:	07b9                	add	a5,a5,14
80005b66:	4611                	li	a2,4
80005b68:	85be                	mv	a1,a5
80005b6a:	10000513          	li	a0,256
80005b6e:	c22ff0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setSUBR(pnetinfo->sn);
80005b72:	47b2                	lw	a5,12(sp)
80005b74:	07a9                	add	a5,a5,10
80005b76:	4611                	li	a2,4
80005b78:	85be                	mv	a1,a5
80005b7a:	50000513          	li	a0,1280
80005b7e:	c12ff0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setSIPR(pnetinfo->ip);
80005b82:	47b2                	lw	a5,12(sp)
80005b84:	0799                	add	a5,a5,6
80005b86:	4611                	li	a2,4
80005b88:	85be                	mv	a1,a5
80005b8a:	6785                	lui	a5,0x1
80005b8c:	f0078513          	add	a0,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
80005b90:	c00ff0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   _DNS_[0] = pnetinfo->dns[0];
80005b94:	47b2                	lw	a5,12(sp)
80005b96:	0127c703          	lbu	a4,18(a5)
80005b9a:	12e18a23          	sb	a4,308(gp) # 1080934 <_DNS_>
   _DNS_[1] = pnetinfo->dns[1];
80005b9e:	47b2                	lw	a5,12(sp)
80005ba0:	0137c703          	lbu	a4,19(a5)
80005ba4:	13418793          	add	a5,gp,308 # 1080934 <_DNS_>
80005ba8:	00e780a3          	sb	a4,1(a5)
   _DNS_[2] = pnetinfo->dns[2];
80005bac:	47b2                	lw	a5,12(sp)
80005bae:	0147c703          	lbu	a4,20(a5)
80005bb2:	13418793          	add	a5,gp,308 # 1080934 <_DNS_>
80005bb6:	00e78123          	sb	a4,2(a5)
   _DNS_[3] = pnetinfo->dns[3];
80005bba:	47b2                	lw	a5,12(sp)
80005bbc:	0157c703          	lbu	a4,21(a5)
80005bc0:	13418793          	add	a5,gp,308 # 1080934 <_DNS_>
80005bc4:	00e781a3          	sb	a4,3(a5)
   _DHCP_   = pnetinfo->dhcp;
80005bc8:	47b2                	lw	a5,12(sp)
80005bca:	0167c703          	lbu	a4,22(a5)
80005bce:	16e18223          	sb	a4,356(gp) # 1080964 <_DHCP_>
}
80005bd2:	0001                	nop
80005bd4:	40f2                	lw	ra,28(sp)
80005bd6:	6105                	add	sp,sp,32
80005bd8:	8082                	ret

Disassembly of section .text.wizchip_getnetinfo:

80005bda <wizchip_getnetinfo>:

void wizchip_getnetinfo(wiz_NetInfo* pnetinfo)
{
80005bda:	1101                	add	sp,sp,-32
80005bdc:	ce06                	sw	ra,28(sp)
80005bde:	c62a                	sw	a0,12(sp)
   getSHAR(pnetinfo->mac);
80005be0:	47b2                	lw	a5,12(sp)
80005be2:	4619                	li	a2,6
80005be4:	85be                	mv	a1,a5
80005be6:	6785                	lui	a5,0x1
80005be8:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
80005bec:	577030ef          	jal	80009962 <WIZCHIP_READ_BUF>
   getGAR(pnetinfo->gw);
80005bf0:	47b2                	lw	a5,12(sp)
80005bf2:	07b9                	add	a5,a5,14
80005bf4:	4611                	li	a2,4
80005bf6:	85be                	mv	a1,a5
80005bf8:	10000513          	li	a0,256
80005bfc:	567030ef          	jal	80009962 <WIZCHIP_READ_BUF>
   getSUBR(pnetinfo->sn);
80005c00:	47b2                	lw	a5,12(sp)
80005c02:	07a9                	add	a5,a5,10
80005c04:	4611                	li	a2,4
80005c06:	85be                	mv	a1,a5
80005c08:	50000513          	li	a0,1280
80005c0c:	557030ef          	jal	80009962 <WIZCHIP_READ_BUF>
   getSIPR(pnetinfo->ip);
80005c10:	47b2                	lw	a5,12(sp)
80005c12:	0799                	add	a5,a5,6
80005c14:	4611                	li	a2,4
80005c16:	85be                	mv	a1,a5
80005c18:	6785                	lui	a5,0x1
80005c1a:	f0078513          	add	a0,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
80005c1e:	545030ef          	jal	80009962 <WIZCHIP_READ_BUF>
   pnetinfo->dns[0]= _DNS_[0];
80005c22:	1341c703          	lbu	a4,308(gp) # 1080934 <_DNS_>
80005c26:	47b2                	lw	a5,12(sp)
80005c28:	00e78923          	sb	a4,18(a5)
   pnetinfo->dns[1]= _DNS_[1];
80005c2c:	13418793          	add	a5,gp,308 # 1080934 <_DNS_>
80005c30:	0017c703          	lbu	a4,1(a5)
80005c34:	47b2                	lw	a5,12(sp)
80005c36:	00e789a3          	sb	a4,19(a5)
   pnetinfo->dns[2]= _DNS_[2];
80005c3a:	13418793          	add	a5,gp,308 # 1080934 <_DNS_>
80005c3e:	0027c703          	lbu	a4,2(a5)
80005c42:	47b2                	lw	a5,12(sp)
80005c44:	00e78a23          	sb	a4,20(a5)
   pnetinfo->dns[3]= _DNS_[3];
80005c48:	13418793          	add	a5,gp,308 # 1080934 <_DNS_>
80005c4c:	0037c703          	lbu	a4,3(a5)
80005c50:	47b2                	lw	a5,12(sp)
80005c52:	00e78aa3          	sb	a4,21(a5)
   pnetinfo->dhcp  = _DHCP_;
80005c56:	1641c703          	lbu	a4,356(gp) # 1080964 <_DHCP_>
80005c5a:	47b2                	lw	a5,12(sp)
80005c5c:	00e78b23          	sb	a4,22(a5)
}
80005c60:	0001                	nop
80005c62:	40f2                	lw	ra,28(sp)
80005c64:	6105                	add	sp,sp,32
80005c66:	8082                	ret

Disassembly of section .text.wizchip_setnetmode:

80005c68 <wizchip_setnetmode>:

int8_t wizchip_setnetmode(netmode_type netmode)
{
80005c68:	7179                	add	sp,sp,-48
80005c6a:	d606                	sw	ra,44(sp)
80005c6c:	87aa                	mv	a5,a0
80005c6e:	00f107a3          	sb	a5,15(sp)
   uint8_t tmp = 0;
80005c72:	00010fa3          	sb	zero,31(sp)
#if _WIZCHIP_ != W5500
   if(netmode & ~(NM_WAKEONLAN | NM_PPPOE | NM_PINGBLOCK)) return -1;
#else
   if(netmode & ~(NM_WAKEONLAN | NM_PPPOE | NM_PINGBLOCK | NM_FORCEARP)) return -1;
80005c76:	00f14783          	lbu	a5,15(sp)
80005c7a:	fc57f793          	and	a5,a5,-59
80005c7e:	c399                	beqz	a5,80005c84 <.L132>
80005c80:	57fd                	li	a5,-1
80005c82:	a035                	j	80005cae <.L133>

80005c84 <.L132>:
#endif      
   tmp = getMR();
80005c84:	4501                	li	a0,0
80005c86:	a60ff0ef          	jal	80004ee6 <WIZCHIP_READ>
80005c8a:	87aa                	mv	a5,a0
80005c8c:	00f10fa3          	sb	a5,31(sp)
   tmp |= (uint8_t)netmode;
80005c90:	01f14783          	lbu	a5,31(sp)
80005c94:	873e                	mv	a4,a5
80005c96:	00f14783          	lbu	a5,15(sp)
80005c9a:	8fd9                	or	a5,a5,a4
80005c9c:	00f10fa3          	sb	a5,31(sp)
   setMR(tmp);
80005ca0:	01f14783          	lbu	a5,31(sp)
80005ca4:	85be                	mv	a1,a5
80005ca6:	4501                	li	a0,0
80005ca8:	3fb030ef          	jal	800098a2 <WIZCHIP_WRITE>
   return 0;
80005cac:	4781                	li	a5,0

80005cae <.L133>:
}
80005cae:	853e                	mv	a0,a5
80005cb0:	50b2                	lw	ra,44(sp)
80005cb2:	6145                	add	sp,sp,48
80005cb4:	8082                	ret

Disassembly of section .text.wizchip_settimeout:

80005cb6 <wizchip_settimeout>:
{
   return (netmode_type) getMR();
}

void wizchip_settimeout(wiz_NetTimeout* nettime)
{
80005cb6:	1101                	add	sp,sp,-32
80005cb8:	ce06                	sw	ra,28(sp)
80005cba:	c62a                	sw	a0,12(sp)
   setRCR(nettime->retry_cnt);
80005cbc:	47b2                	lw	a5,12(sp)
80005cbe:	0007c783          	lbu	a5,0(a5)
80005cc2:	85be                	mv	a1,a5
80005cc4:	6789                	lui	a5,0x2
80005cc6:	b0078513          	add	a0,a5,-1280 # 1b00 <__fw_size__+0xb00>
80005cca:	3d9030ef          	jal	800098a2 <WIZCHIP_WRITE>
   setRTR(nettime->time_100us);
80005cce:	47b2                	lw	a5,12(sp)
80005cd0:	0027d783          	lhu	a5,2(a5)
80005cd4:	83a1                	srl	a5,a5,0x8
80005cd6:	07c2                	sll	a5,a5,0x10
80005cd8:	83c1                	srl	a5,a5,0x10
80005cda:	0ff7f793          	zext.b	a5,a5
80005cde:	85be                	mv	a1,a5
80005ce0:	6789                	lui	a5,0x2
80005ce2:	90078513          	add	a0,a5,-1792 # 1900 <__fw_size__+0x900>
80005ce6:	3bd030ef          	jal	800098a2 <WIZCHIP_WRITE>
80005cea:	47b2                	lw	a5,12(sp)
80005cec:	0027d783          	lhu	a5,2(a5)
80005cf0:	0ff7f793          	zext.b	a5,a5
80005cf4:	85be                	mv	a1,a5
80005cf6:	6789                	lui	a5,0x2
80005cf8:	a0078513          	add	a0,a5,-1536 # 1a00 <__fw_size__+0xa00>
80005cfc:	3a7030ef          	jal	800098a2 <WIZCHIP_WRITE>
}
80005d00:	0001                	nop
80005d02:	40f2                	lw	ra,28(sp)
80005d04:	6105                	add	sp,sp,32
80005d06:	8082                	ret

Disassembly of section .text.makeDHCPMSG:

80005d08 <makeDHCPMSG>:
   if(ip_conflict) dhcp_ip_conflict = ip_conflict;
}

/* make the common DHCP message */
void makeDHCPMSG(void)
{
80005d08:	1101                	add	sp,sp,-32
80005d0a:	ce06                	sw	ra,28(sp)
   uint8_t  bk_mac[6];
   uint8_t* ptmp;
   uint8_t  i;
   getSHAR(bk_mac);
80005d0c:	878a                	mv	a5,sp
80005d0e:	4619                	li	a2,6
80005d10:	85be                	mv	a1,a5
80005d12:	6785                	lui	a5,0x1
80005d14:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
80005d18:	44b030ef          	jal	80009962 <WIZCHIP_READ_BUF>
	pDHCPMSG->op      = DHCP_BOOTREQUEST;
80005d1c:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005d20:	4705                	li	a4,1
80005d22:	00e78023          	sb	a4,0(a5)
	pDHCPMSG->htype   = DHCP_HTYPE10MB;
80005d26:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005d2a:	4705                	li	a4,1
80005d2c:	00e780a3          	sb	a4,1(a5)
	pDHCPMSG->hlen    = DHCP_HLENETHERNET;
80005d30:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005d34:	4719                	li	a4,6
80005d36:	00e78123          	sb	a4,2(a5)
	pDHCPMSG->hops    = DHCP_HOPS;
80005d3a:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005d3e:	000781a3          	sb	zero,3(a5)
	ptmp              = (uint8_t*)(&pDHCPMSG->xid);
80005d42:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005d46:	0791                	add	a5,a5,4
80005d48:	c43e                	sw	a5,8(sp)
	*(ptmp+0)         = (uint8_t)((DHCP_XID & 0xFF000000) >> 24);
80005d4a:	14c1a783          	lw	a5,332(gp) # 108094c <DHCP_XID>
80005d4e:	83e1                	srl	a5,a5,0x18
80005d50:	0ff7f713          	zext.b	a4,a5
80005d54:	47a2                	lw	a5,8(sp)
80005d56:	00e78023          	sb	a4,0(a5)
	*(ptmp+1)         = (uint8_t)((DHCP_XID & 0x00FF0000) >> 16);
80005d5a:	14c1a783          	lw	a5,332(gp) # 108094c <DHCP_XID>
80005d5e:	0107d713          	srl	a4,a5,0x10
80005d62:	47a2                	lw	a5,8(sp)
80005d64:	0785                	add	a5,a5,1
80005d66:	0ff77713          	zext.b	a4,a4
80005d6a:	00e78023          	sb	a4,0(a5)
   *(ptmp+2)         = (uint8_t)((DHCP_XID & 0x0000FF00) >>  8);
80005d6e:	14c1a783          	lw	a5,332(gp) # 108094c <DHCP_XID>
80005d72:	0087d713          	srl	a4,a5,0x8
80005d76:	47a2                	lw	a5,8(sp)
80005d78:	0789                	add	a5,a5,2
80005d7a:	0ff77713          	zext.b	a4,a4
80005d7e:	00e78023          	sb	a4,0(a5)
	*(ptmp+3)         = (uint8_t)((DHCP_XID & 0x000000FF) >>  0);   
80005d82:	14c1a703          	lw	a4,332(gp) # 108094c <DHCP_XID>
80005d86:	47a2                	lw	a5,8(sp)
80005d88:	078d                	add	a5,a5,3
80005d8a:	0ff77713          	zext.b	a4,a4
80005d8e:	00e78023          	sb	a4,0(a5)
	pDHCPMSG->secs    = DHCP_SECS;
80005d92:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005d96:	00079423          	sh	zero,8(a5)
	ptmp              = (uint8_t*)(&pDHCPMSG->flags);	
80005d9a:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005d9e:	07a9                	add	a5,a5,10
80005da0:	c43e                	sw	a5,8(sp)
	*(ptmp+0)         = (uint8_t)((DHCP_FLAGSBROADCAST & 0xFF00) >> 8);
80005da2:	47a2                	lw	a5,8(sp)
80005da4:	f8000713          	li	a4,-128
80005da8:	00e78023          	sb	a4,0(a5)
	*(ptmp+1)         = (uint8_t)((DHCP_FLAGSBROADCAST & 0x00FF) >> 0);
80005dac:	47a2                	lw	a5,8(sp)
80005dae:	0785                	add	a5,a5,1
80005db0:	00078023          	sb	zero,0(a5)

	pDHCPMSG->ciaddr[0] = 0;
80005db4:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005db8:	00078623          	sb	zero,12(a5)
	pDHCPMSG->ciaddr[1] = 0;
80005dbc:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005dc0:	000786a3          	sb	zero,13(a5)
	pDHCPMSG->ciaddr[2] = 0;
80005dc4:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005dc8:	00078723          	sb	zero,14(a5)
	pDHCPMSG->ciaddr[3] = 0;
80005dcc:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005dd0:	000787a3          	sb	zero,15(a5)

	pDHCPMSG->yiaddr[0] = 0;
80005dd4:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005dd8:	00078823          	sb	zero,16(a5)
	pDHCPMSG->yiaddr[1] = 0;
80005ddc:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005de0:	000788a3          	sb	zero,17(a5)
	pDHCPMSG->yiaddr[2] = 0;
80005de4:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005de8:	00078923          	sb	zero,18(a5)
	pDHCPMSG->yiaddr[3] = 0;
80005dec:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005df0:	000789a3          	sb	zero,19(a5)

	pDHCPMSG->siaddr[0] = 0;
80005df4:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005df8:	00078a23          	sb	zero,20(a5)
	pDHCPMSG->siaddr[1] = 0;
80005dfc:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e00:	00078aa3          	sb	zero,21(a5)
	pDHCPMSG->siaddr[2] = 0;
80005e04:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e08:	00078b23          	sb	zero,22(a5)
	pDHCPMSG->siaddr[3] = 0;
80005e0c:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e10:	00078ba3          	sb	zero,23(a5)

	pDHCPMSG->giaddr[0] = 0;
80005e14:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e18:	00078c23          	sb	zero,24(a5)
	pDHCPMSG->giaddr[1] = 0;
80005e1c:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e20:	00078ca3          	sb	zero,25(a5)
	pDHCPMSG->giaddr[2] = 0;
80005e24:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e28:	00078d23          	sb	zero,26(a5)
	pDHCPMSG->giaddr[3] = 0;
80005e2c:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e30:	00078da3          	sb	zero,27(a5)

	pDHCPMSG->chaddr[0] = DHCP_CHADDR[0];
80005e34:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e38:	11818713          	add	a4,gp,280 # 1080918 <DHCP_CHADDR>
80005e3c:	00074703          	lbu	a4,0(a4)
80005e40:	00e78e23          	sb	a4,28(a5)
	pDHCPMSG->chaddr[1] = DHCP_CHADDR[1];
80005e44:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e48:	11818713          	add	a4,gp,280 # 1080918 <DHCP_CHADDR>
80005e4c:	00174703          	lbu	a4,1(a4)
80005e50:	00e78ea3          	sb	a4,29(a5)
	pDHCPMSG->chaddr[2] = DHCP_CHADDR[2];
80005e54:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e58:	11818713          	add	a4,gp,280 # 1080918 <DHCP_CHADDR>
80005e5c:	00274703          	lbu	a4,2(a4)
80005e60:	00e78f23          	sb	a4,30(a5)
	pDHCPMSG->chaddr[3] = DHCP_CHADDR[3];
80005e64:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e68:	11818713          	add	a4,gp,280 # 1080918 <DHCP_CHADDR>
80005e6c:	00374703          	lbu	a4,3(a4)
80005e70:	00e78fa3          	sb	a4,31(a5)
	pDHCPMSG->chaddr[4] = DHCP_CHADDR[4];
80005e74:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e78:	11818713          	add	a4,gp,280 # 1080918 <DHCP_CHADDR>
80005e7c:	00474703          	lbu	a4,4(a4)
80005e80:	02e78023          	sb	a4,32(a5)
	pDHCPMSG->chaddr[5] = DHCP_CHADDR[5];
80005e84:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005e88:	11818713          	add	a4,gp,280 # 1080918 <DHCP_CHADDR>
80005e8c:	00574703          	lbu	a4,5(a4)
80005e90:	02e780a3          	sb	a4,33(a5)

	for (i = 6; i < 16; i++)  pDHCPMSG->chaddr[i] = 0;
80005e94:	4799                	li	a5,6
80005e96:	00f107a3          	sb	a5,15(sp)
80005e9a:	a829                	j	80005eb4 <.L10>

80005e9c <.L11>:
80005e9c:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80005ea0:	00f14783          	lbu	a5,15(sp)
80005ea4:	97ba                	add	a5,a5,a4
80005ea6:	00078e23          	sb	zero,28(a5)
80005eaa:	00f14783          	lbu	a5,15(sp)
80005eae:	0785                	add	a5,a5,1
80005eb0:	00f107a3          	sb	a5,15(sp)

80005eb4 <.L10>:
80005eb4:	00f14703          	lbu	a4,15(sp)
80005eb8:	47bd                	li	a5,15
80005eba:	fee7f1e3          	bgeu	a5,a4,80005e9c <.L11>
	for (i = 0; i < 64; i++)  pDHCPMSG->sname[i]  = 0;
80005ebe:	000107a3          	sb	zero,15(sp)
80005ec2:	a829                	j	80005edc <.L12>

80005ec4 <.L13>:
80005ec4:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80005ec8:	00f14783          	lbu	a5,15(sp)
80005ecc:	97ba                	add	a5,a5,a4
80005ece:	02078623          	sb	zero,44(a5)
80005ed2:	00f14783          	lbu	a5,15(sp)
80005ed6:	0785                	add	a5,a5,1
80005ed8:	00f107a3          	sb	a5,15(sp)

80005edc <.L12>:
80005edc:	00f14703          	lbu	a4,15(sp)
80005ee0:	03f00793          	li	a5,63
80005ee4:	fee7f0e3          	bgeu	a5,a4,80005ec4 <.L13>
	for (i = 0; i < 128; i++) pDHCPMSG->file[i]   = 0;
80005ee8:	000107a3          	sb	zero,15(sp)
80005eec:	a829                	j	80005f06 <.L14>

80005eee <.L15>:
80005eee:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80005ef2:	00f14783          	lbu	a5,15(sp)
80005ef6:	97ba                	add	a5,a5,a4
80005ef8:	06078623          	sb	zero,108(a5)
80005efc:	00f14783          	lbu	a5,15(sp)
80005f00:	0785                	add	a5,a5,1
80005f02:	00f107a3          	sb	a5,15(sp)

80005f06 <.L14>:
80005f06:	00f10783          	lb	a5,15(sp)
80005f0a:	fe07d2e3          	bgez	a5,80005eee <.L15>

	// MAGIC_COOKIE
	pDHCPMSG->OPT[0] = (uint8_t)((MAGIC_COOKIE & 0xFF000000) >> 24);
80005f0e:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f12:	06300713          	li	a4,99
80005f16:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[1] = (uint8_t)((MAGIC_COOKIE & 0x00FF0000) >> 16);
80005f1a:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f1e:	f8200713          	li	a4,-126
80005f22:	0ee786a3          	sb	a4,237(a5)
	pDHCPMSG->OPT[2] = (uint8_t)((MAGIC_COOKIE & 0x0000FF00) >>  8);
80005f26:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f2a:	05300713          	li	a4,83
80005f2e:	0ee78723          	sb	a4,238(a5)
	pDHCPMSG->OPT[3] = (uint8_t) (MAGIC_COOKIE & 0x000000FF) >>  0;
80005f32:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f36:	06300713          	li	a4,99
80005f3a:	0ee787a3          	sb	a4,239(a5)
}
80005f3e:	0001                	nop
80005f40:	40f2                	lw	ra,28(sp)
80005f42:	6105                	add	sp,sp,32
80005f44:	8082                	ret

Disassembly of section .text.send_DHCP_REQUEST:

80005f46 <send_DHCP_REQUEST>:
	sendto(DHCP_SOCKET, (uint8_t *)pDHCPMSG, RIP_MSG_SIZE, ip, DHCP_SERVER_PORT);
}

/* SEND DHCP REQUEST */
void send_DHCP_REQUEST(void)
{
80005f46:	1101                	add	sp,sp,-32
80005f48:	ce06                	sw	ra,28(sp)
80005f4a:	cc22                	sw	s0,24(sp)
80005f4c:	ca26                	sw	s1,20(sp)
	int i;
	uint8_t ip[4];
	uint16_t k = 0;
80005f4e:	00011523          	sh	zero,10(sp)

   makeDHCPMSG();
80005f52:	3b5d                	jal	80005d08 <makeDHCPMSG>

   if(dhcp_state == STATE_DHCP_LEASED || dhcp_state == STATE_DHCP_REREQUEST)
80005f54:	0ff18703          	lb	a4,255(gp) # 10808ff <dhcp_state>
80005f58:	478d                	li	a5,3
80005f5a:	00f70763          	beq	a4,a5,80005f68 <.L22>
80005f5e:	0ff18703          	lb	a4,255(gp) # 10808ff <dhcp_state>
80005f62:	4791                	li	a5,4
80005f64:	08f71263          	bne	a4,a5,80005fe8 <.L23>

80005f68 <.L22>:
   {
   	*((uint8_t*)(&pDHCPMSG->flags))   = ((DHCP_FLAGSUNICAST & 0xFF00)>> 8);
80005f68:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f6c:	07a9                	add	a5,a5,10
80005f6e:	00078023          	sb	zero,0(a5)
   	*((uint8_t*)(&pDHCPMSG->flags)+1) = (DHCP_FLAGSUNICAST & 0x00FF);
80005f72:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f76:	07a9                	add	a5,a5,10
80005f78:	0785                	add	a5,a5,1
80005f7a:	00078023          	sb	zero,0(a5)
   	pDHCPMSG->ciaddr[0] = DHCP_allocated_ip[0];
80005f7e:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f82:	1401c703          	lbu	a4,320(gp) # 1080940 <DHCP_allocated_ip>
80005f86:	00e78623          	sb	a4,12(a5)
   	pDHCPMSG->ciaddr[1] = DHCP_allocated_ip[1];
80005f8a:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f8e:	14018713          	add	a4,gp,320 # 1080940 <DHCP_allocated_ip>
80005f92:	00174703          	lbu	a4,1(a4)
80005f96:	00e786a3          	sb	a4,13(a5)
   	pDHCPMSG->ciaddr[2] = DHCP_allocated_ip[2];
80005f9a:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005f9e:	14018713          	add	a4,gp,320 # 1080940 <DHCP_allocated_ip>
80005fa2:	00274703          	lbu	a4,2(a4)
80005fa6:	00e78723          	sb	a4,14(a5)
   	pDHCPMSG->ciaddr[3] = DHCP_allocated_ip[3];
80005faa:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
80005fae:	14018713          	add	a4,gp,320 # 1080940 <DHCP_allocated_ip>
80005fb2:	00374703          	lbu	a4,3(a4)
80005fb6:	00e787a3          	sb	a4,15(a5)
   	ip[0] = DHCP_SIP[0];
80005fba:	1501c783          	lbu	a5,336(gp) # 1080950 <DHCP_SIP>
80005fbe:	00f10223          	sb	a5,4(sp)
   	ip[1] = DHCP_SIP[1];
80005fc2:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
80005fc6:	0017c783          	lbu	a5,1(a5)
80005fca:	00f102a3          	sb	a5,5(sp)
   	ip[2] = DHCP_SIP[2];
80005fce:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
80005fd2:	0027c783          	lbu	a5,2(a5)
80005fd6:	00f10323          	sb	a5,6(sp)
   	ip[3] = DHCP_SIP[3];   	   	   	
80005fda:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
80005fde:	0037c783          	lbu	a5,3(a5)
80005fe2:	00f103a3          	sb	a5,7(sp)
80005fe6:	a829                	j	80006000 <.L24>

80005fe8 <.L23>:
   }
   else
   {
   	ip[0] = 255;
80005fe8:	57fd                	li	a5,-1
80005fea:	00f10223          	sb	a5,4(sp)
   	ip[1] = 255;
80005fee:	57fd                	li	a5,-1
80005ff0:	00f102a3          	sb	a5,5(sp)
   	ip[2] = 255;
80005ff4:	57fd                	li	a5,-1
80005ff6:	00f10323          	sb	a5,6(sp)
   	ip[3] = 255;   	   	   	
80005ffa:	57fd                	li	a5,-1
80005ffc:	00f103a3          	sb	a5,7(sp)

80006000 <.L24>:
   }
   
   k = 4;      // because MAGIC_COOKIE already made by makeDHCPMSG()
80006000:	4791                	li	a5,4
80006002:	00f11523          	sh	a5,10(sp)
	
	// Option Request Param.
	pDHCPMSG->OPT[k++] = dhcpMessageType;
80006006:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000600a:	00a15783          	lhu	a5,10(sp)
8000600e:	00178693          	add	a3,a5,1
80006012:	00d11523          	sh	a3,10(sp)
80006016:	97ba                	add	a5,a5,a4
80006018:	03500713          	li	a4,53
8000601c:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x01;
80006020:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006024:	00a15783          	lhu	a5,10(sp)
80006028:	00178693          	add	a3,a5,1
8000602c:	00d11523          	sh	a3,10(sp)
80006030:	97ba                	add	a5,a5,a4
80006032:	4705                	li	a4,1
80006034:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_REQUEST;
80006038:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000603c:	00a15783          	lhu	a5,10(sp)
80006040:	00178693          	add	a3,a5,1
80006044:	00d11523          	sh	a3,10(sp)
80006048:	97ba                	add	a5,a5,a4
8000604a:	470d                	li	a4,3
8000604c:	0ee78623          	sb	a4,236(a5)

	pDHCPMSG->OPT[k++] = dhcpClientIdentifier;
80006050:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006054:	00a15783          	lhu	a5,10(sp)
80006058:	00178693          	add	a3,a5,1
8000605c:	00d11523          	sh	a3,10(sp)
80006060:	97ba                	add	a5,a5,a4
80006062:	03d00713          	li	a4,61
80006066:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x07;
8000606a:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000606e:	00a15783          	lhu	a5,10(sp)
80006072:	00178693          	add	a3,a5,1
80006076:	00d11523          	sh	a3,10(sp)
8000607a:	97ba                	add	a5,a5,a4
8000607c:	471d                	li	a4,7
8000607e:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x01;
80006082:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006086:	00a15783          	lhu	a5,10(sp)
8000608a:	00178693          	add	a3,a5,1
8000608e:	00d11523          	sh	a3,10(sp)
80006092:	97ba                	add	a5,a5,a4
80006094:	4705                	li	a4,1
80006096:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[0];
8000609a:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000609e:	00a15783          	lhu	a5,10(sp)
800060a2:	00178713          	add	a4,a5,1
800060a6:	00e11523          	sh	a4,10(sp)
800060aa:	863e                	mv	a2,a5
800060ac:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
800060b0:	0007c703          	lbu	a4,0(a5)
800060b4:	00c687b3          	add	a5,a3,a2
800060b8:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[1];
800060bc:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
800060c0:	00a15783          	lhu	a5,10(sp)
800060c4:	00178713          	add	a4,a5,1
800060c8:	00e11523          	sh	a4,10(sp)
800060cc:	863e                	mv	a2,a5
800060ce:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
800060d2:	0017c703          	lbu	a4,1(a5)
800060d6:	00c687b3          	add	a5,a3,a2
800060da:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[2];
800060de:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
800060e2:	00a15783          	lhu	a5,10(sp)
800060e6:	00178713          	add	a4,a5,1
800060ea:	00e11523          	sh	a4,10(sp)
800060ee:	863e                	mv	a2,a5
800060f0:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
800060f4:	0027c703          	lbu	a4,2(a5)
800060f8:	00c687b3          	add	a5,a3,a2
800060fc:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[3];
80006100:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
80006104:	00a15783          	lhu	a5,10(sp)
80006108:	00178713          	add	a4,a5,1
8000610c:	00e11523          	sh	a4,10(sp)
80006110:	863e                	mv	a2,a5
80006112:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
80006116:	0037c703          	lbu	a4,3(a5)
8000611a:	00c687b3          	add	a5,a3,a2
8000611e:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[4];
80006122:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
80006126:	00a15783          	lhu	a5,10(sp)
8000612a:	00178713          	add	a4,a5,1
8000612e:	00e11523          	sh	a4,10(sp)
80006132:	863e                	mv	a2,a5
80006134:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
80006138:	0047c703          	lbu	a4,4(a5)
8000613c:	00c687b3          	add	a5,a3,a2
80006140:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[5];
80006144:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
80006148:	00a15783          	lhu	a5,10(sp)
8000614c:	00178713          	add	a4,a5,1
80006150:	00e11523          	sh	a4,10(sp)
80006154:	863e                	mv	a2,a5
80006156:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000615a:	0057c703          	lbu	a4,5(a5)
8000615e:	00c687b3          	add	a5,a3,a2
80006162:	0ee78623          	sb	a4,236(a5)

   if(ip[3] == 255)  // if(dchp_state == STATE_DHCP_LEASED || dchp_state == DHCP_REREQUEST_STATE)
80006166:	00714703          	lbu	a4,7(sp)
8000616a:	0ff00793          	li	a5,255
8000616e:	16f71863          	bne	a4,a5,800062de <.L25>
   {
		pDHCPMSG->OPT[k++] = dhcpRequestedIPaddr;
80006172:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006176:	00a15783          	lhu	a5,10(sp)
8000617a:	00178693          	add	a3,a5,1
8000617e:	00d11523          	sh	a3,10(sp)
80006182:	97ba                	add	a5,a5,a4
80006184:	03200713          	li	a4,50
80006188:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = 0x04;
8000618c:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006190:	00a15783          	lhu	a5,10(sp)
80006194:	00178693          	add	a3,a5,1
80006198:	00d11523          	sh	a3,10(sp)
8000619c:	97ba                	add	a5,a5,a4
8000619e:	4711                	li	a4,4
800061a0:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = DHCP_allocated_ip[0];
800061a4:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
800061a8:	00a15783          	lhu	a5,10(sp)
800061ac:	00178713          	add	a4,a5,1
800061b0:	00e11523          	sh	a4,10(sp)
800061b4:	863e                	mv	a2,a5
800061b6:	1401c703          	lbu	a4,320(gp) # 1080940 <DHCP_allocated_ip>
800061ba:	00c687b3          	add	a5,a3,a2
800061be:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = DHCP_allocated_ip[1];
800061c2:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
800061c6:	00a15783          	lhu	a5,10(sp)
800061ca:	00178713          	add	a4,a5,1
800061ce:	00e11523          	sh	a4,10(sp)
800061d2:	863e                	mv	a2,a5
800061d4:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
800061d8:	0017c703          	lbu	a4,1(a5)
800061dc:	00c687b3          	add	a5,a3,a2
800061e0:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = DHCP_allocated_ip[2];
800061e4:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
800061e8:	00a15783          	lhu	a5,10(sp)
800061ec:	00178713          	add	a4,a5,1
800061f0:	00e11523          	sh	a4,10(sp)
800061f4:	863e                	mv	a2,a5
800061f6:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
800061fa:	0027c703          	lbu	a4,2(a5)
800061fe:	00c687b3          	add	a5,a3,a2
80006202:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = DHCP_allocated_ip[3];
80006206:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000620a:	00a15783          	lhu	a5,10(sp)
8000620e:	00178713          	add	a4,a5,1
80006212:	00e11523          	sh	a4,10(sp)
80006216:	863e                	mv	a2,a5
80006218:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
8000621c:	0037c703          	lbu	a4,3(a5)
80006220:	00c687b3          	add	a5,a3,a2
80006224:	0ee78623          	sb	a4,236(a5)
	
		pDHCPMSG->OPT[k++] = dhcpServerIdentifier;
80006228:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000622c:	00a15783          	lhu	a5,10(sp)
80006230:	00178693          	add	a3,a5,1
80006234:	00d11523          	sh	a3,10(sp)
80006238:	97ba                	add	a5,a5,a4
8000623a:	03600713          	li	a4,54
8000623e:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = 0x04;
80006242:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006246:	00a15783          	lhu	a5,10(sp)
8000624a:	00178693          	add	a3,a5,1
8000624e:	00d11523          	sh	a3,10(sp)
80006252:	97ba                	add	a5,a5,a4
80006254:	4711                	li	a4,4
80006256:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = DHCP_SIP[0];
8000625a:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000625e:	00a15783          	lhu	a5,10(sp)
80006262:	00178713          	add	a4,a5,1
80006266:	00e11523          	sh	a4,10(sp)
8000626a:	863e                	mv	a2,a5
8000626c:	1501c703          	lbu	a4,336(gp) # 1080950 <DHCP_SIP>
80006270:	00c687b3          	add	a5,a3,a2
80006274:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = DHCP_SIP[1];
80006278:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000627c:	00a15783          	lhu	a5,10(sp)
80006280:	00178713          	add	a4,a5,1
80006284:	00e11523          	sh	a4,10(sp)
80006288:	863e                	mv	a2,a5
8000628a:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000628e:	0017c703          	lbu	a4,1(a5)
80006292:	00c687b3          	add	a5,a3,a2
80006296:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = DHCP_SIP[2];
8000629a:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000629e:	00a15783          	lhu	a5,10(sp)
800062a2:	00178713          	add	a4,a5,1
800062a6:	00e11523          	sh	a4,10(sp)
800062aa:	863e                	mv	a2,a5
800062ac:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
800062b0:	0027c703          	lbu	a4,2(a5)
800062b4:	00c687b3          	add	a5,a3,a2
800062b8:	0ee78623          	sb	a4,236(a5)
		pDHCPMSG->OPT[k++] = DHCP_SIP[3];
800062bc:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
800062c0:	00a15783          	lhu	a5,10(sp)
800062c4:	00178713          	add	a4,a5,1
800062c8:	00e11523          	sh	a4,10(sp)
800062cc:	863e                	mv	a2,a5
800062ce:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
800062d2:	0037c703          	lbu	a4,3(a5)
800062d6:	00c687b3          	add	a5,a3,a2
800062da:	0ee78623          	sb	a4,236(a5)

800062de <.L25>:
	}

	// host name
	pDHCPMSG->OPT[k++] = hostName;
800062de:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
800062e2:	00a15783          	lhu	a5,10(sp)
800062e6:	00178693          	add	a3,a5,1
800062ea:	00d11523          	sh	a3,10(sp)
800062ee:	97ba                	add	a5,a5,a4
800062f0:	4731                	li	a4,12
800062f2:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0; // length of hostname
800062f6:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
800062fa:	00a15783          	lhu	a5,10(sp)
800062fe:	00178693          	add	a3,a5,1
80006302:	00d11523          	sh	a3,10(sp)
80006306:	97ba                	add	a5,a5,a4
80006308:	0e078623          	sb	zero,236(a5)
	for(i = 0 ; HOST_NAME[i] != 0; i++)
8000630c:	c602                	sw	zero,12(sp)
8000630e:	a03d                	j	8000633c <.L26>

80006310 <.L27>:
   	pDHCPMSG->OPT[k++] = HOST_NAME[i];
80006310:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
80006314:	00a15783          	lhu	a5,10(sp)
80006318:	00178713          	add	a4,a5,1
8000631c:	00e11523          	sh	a4,10(sp)
80006320:	863e                	mv	a2,a5
80006322:	16818713          	add	a4,gp,360 # 1080968 <HOST_NAME>
80006326:	47b2                	lw	a5,12(sp)
80006328:	97ba                	add	a5,a5,a4
8000632a:	0007c703          	lbu	a4,0(a5)
8000632e:	00c687b3          	add	a5,a3,a2
80006332:	0ee78623          	sb	a4,236(a5)
	for(i = 0 ; HOST_NAME[i] != 0; i++)
80006336:	47b2                	lw	a5,12(sp)
80006338:	0785                	add	a5,a5,1
8000633a:	c63e                	sw	a5,12(sp)

8000633c <.L26>:
8000633c:	16818713          	add	a4,gp,360 # 1080968 <HOST_NAME>
80006340:	47b2                	lw	a5,12(sp)
80006342:	97ba                	add	a5,a5,a4
80006344:	0007c783          	lbu	a5,0(a5)
80006348:	f7e1                	bnez	a5,80006310 <.L27>
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[3] >> 4); 
8000634a:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000634e:	0037c783          	lbu	a5,3(a5)
80006352:	8391                	srl	a5,a5,0x4
80006354:	0ff7f693          	zext.b	a3,a5
80006358:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
8000635c:	00a15783          	lhu	a5,10(sp)
80006360:	00178713          	add	a4,a5,1
80006364:	00e11523          	sh	a4,10(sp)
80006368:	84be                	mv	s1,a5
8000636a:	8536                	mv	a0,a3
8000636c:	417050ef          	jal	8000bf82 <NibbleToHex>
80006370:	87aa                	mv	a5,a0
80006372:	873e                	mv	a4,a5
80006374:	009407b3          	add	a5,s0,s1
80006378:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[3]);
8000637c:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
80006380:	0037c683          	lbu	a3,3(a5)
80006384:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
80006388:	00a15783          	lhu	a5,10(sp)
8000638c:	00178713          	add	a4,a5,1
80006390:	00e11523          	sh	a4,10(sp)
80006394:	84be                	mv	s1,a5
80006396:	8536                	mv	a0,a3
80006398:	3eb050ef          	jal	8000bf82 <NibbleToHex>
8000639c:	87aa                	mv	a5,a0
8000639e:	873e                	mv	a4,a5
800063a0:	009407b3          	add	a5,s0,s1
800063a4:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[4] >> 4); 
800063a8:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
800063ac:	0047c783          	lbu	a5,4(a5)
800063b0:	8391                	srl	a5,a5,0x4
800063b2:	0ff7f693          	zext.b	a3,a5
800063b6:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
800063ba:	00a15783          	lhu	a5,10(sp)
800063be:	00178713          	add	a4,a5,1
800063c2:	00e11523          	sh	a4,10(sp)
800063c6:	84be                	mv	s1,a5
800063c8:	8536                	mv	a0,a3
800063ca:	3b9050ef          	jal	8000bf82 <NibbleToHex>
800063ce:	87aa                	mv	a5,a0
800063d0:	873e                	mv	a4,a5
800063d2:	009407b3          	add	a5,s0,s1
800063d6:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[4]);
800063da:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
800063de:	0047c683          	lbu	a3,4(a5)
800063e2:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
800063e6:	00a15783          	lhu	a5,10(sp)
800063ea:	00178713          	add	a4,a5,1
800063ee:	00e11523          	sh	a4,10(sp)
800063f2:	84be                	mv	s1,a5
800063f4:	8536                	mv	a0,a3
800063f6:	38d050ef          	jal	8000bf82 <NibbleToHex>
800063fa:	87aa                	mv	a5,a0
800063fc:	873e                	mv	a4,a5
800063fe:	009407b3          	add	a5,s0,s1
80006402:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[5] >> 4); 
80006406:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000640a:	0057c783          	lbu	a5,5(a5)
8000640e:	8391                	srl	a5,a5,0x4
80006410:	0ff7f693          	zext.b	a3,a5
80006414:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
80006418:	00a15783          	lhu	a5,10(sp)
8000641c:	00178713          	add	a4,a5,1
80006420:	00e11523          	sh	a4,10(sp)
80006424:	84be                	mv	s1,a5
80006426:	8536                	mv	a0,a3
80006428:	35b050ef          	jal	8000bf82 <NibbleToHex>
8000642c:	87aa                	mv	a5,a0
8000642e:	873e                	mv	a4,a5
80006430:	009407b3          	add	a5,s0,s1
80006434:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[5]);
80006438:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000643c:	0057c683          	lbu	a3,5(a5)
80006440:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
80006444:	00a15783          	lhu	a5,10(sp)
80006448:	00178713          	add	a4,a5,1
8000644c:	00e11523          	sh	a4,10(sp)
80006450:	84be                	mv	s1,a5
80006452:	8536                	mv	a0,a3
80006454:	32f050ef          	jal	8000bf82 <NibbleToHex>
80006458:	87aa                	mv	a5,a0
8000645a:	873e                	mv	a4,a5
8000645c:	009407b3          	add	a5,s0,s1
80006460:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k - (i+6+1)] = i+6; // length of hostname
80006464:	47b2                	lw	a5,12(sp)
80006466:	0ff7f713          	zext.b	a4,a5
8000646a:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000646e:	00a15603          	lhu	a2,10(sp)
80006472:	47b2                	lw	a5,12(sp)
80006474:	079d                	add	a5,a5,7
80006476:	40f607b3          	sub	a5,a2,a5
8000647a:	0719                	add	a4,a4,6
8000647c:	0ff77713          	zext.b	a4,a4
80006480:	97b6                	add	a5,a5,a3
80006482:	0ee78623          	sb	a4,236(a5)
	
	pDHCPMSG->OPT[k++] = dhcpParamRequest;
80006486:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000648a:	00a15783          	lhu	a5,10(sp)
8000648e:	00178693          	add	a3,a5,1
80006492:	00d11523          	sh	a3,10(sp)
80006496:	97ba                	add	a5,a5,a4
80006498:	03700713          	li	a4,55
8000649c:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x08;
800064a0:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
800064a4:	00a15783          	lhu	a5,10(sp)
800064a8:	00178693          	add	a3,a5,1
800064ac:	00d11523          	sh	a3,10(sp)
800064b0:	97ba                	add	a5,a5,a4
800064b2:	4721                	li	a4,8
800064b4:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = subnetMask;
800064b8:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
800064bc:	00a15783          	lhu	a5,10(sp)
800064c0:	00178693          	add	a3,a5,1
800064c4:	00d11523          	sh	a3,10(sp)
800064c8:	97ba                	add	a5,a5,a4
800064ca:	4705                	li	a4,1
800064cc:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = routersOnSubnet;
800064d0:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
800064d4:	00a15783          	lhu	a5,10(sp)
800064d8:	00178693          	add	a3,a5,1
800064dc:	00d11523          	sh	a3,10(sp)
800064e0:	97ba                	add	a5,a5,a4
800064e2:	470d                	li	a4,3
800064e4:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dns;
800064e8:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
800064ec:	00a15783          	lhu	a5,10(sp)
800064f0:	00178693          	add	a3,a5,1
800064f4:	00d11523          	sh	a3,10(sp)
800064f8:	97ba                	add	a5,a5,a4
800064fa:	4719                	li	a4,6
800064fc:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = domainName;
80006500:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006504:	00a15783          	lhu	a5,10(sp)
80006508:	00178693          	add	a3,a5,1
8000650c:	00d11523          	sh	a3,10(sp)
80006510:	97ba                	add	a5,a5,a4
80006512:	473d                	li	a4,15
80006514:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpT1value;
80006518:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000651c:	00a15783          	lhu	a5,10(sp)
80006520:	00178693          	add	a3,a5,1
80006524:	00d11523          	sh	a3,10(sp)
80006528:	97ba                	add	a5,a5,a4
8000652a:	03a00713          	li	a4,58
8000652e:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpT2value;
80006532:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006536:	00a15783          	lhu	a5,10(sp)
8000653a:	00178693          	add	a3,a5,1
8000653e:	00d11523          	sh	a3,10(sp)
80006542:	97ba                	add	a5,a5,a4
80006544:	03b00713          	li	a4,59
80006548:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = performRouterDiscovery;
8000654c:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006550:	00a15783          	lhu	a5,10(sp)
80006554:	00178693          	add	a3,a5,1
80006558:	00d11523          	sh	a3,10(sp)
8000655c:	97ba                	add	a5,a5,a4
8000655e:	477d                	li	a4,31
80006560:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = staticRoute;
80006564:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006568:	00a15783          	lhu	a5,10(sp)
8000656c:	00178693          	add	a3,a5,1
80006570:	00d11523          	sh	a3,10(sp)
80006574:	97ba                	add	a5,a5,a4
80006576:	02100713          	li	a4,33
8000657a:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = endOption;
8000657e:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
80006582:	00a15783          	lhu	a5,10(sp)
80006586:	00178693          	add	a3,a5,1
8000658a:	00d11523          	sh	a3,10(sp)
8000658e:	97ba                	add	a5,a5,a4
80006590:	577d                	li	a4,-1
80006592:	0ee78623          	sb	a4,236(a5)

	for (i = k; i < OPT_SIZE; i++) pDHCPMSG->OPT[i] = 0;
80006596:	00a15783          	lhu	a5,10(sp)
8000659a:	c63e                	sw	a5,12(sp)
8000659c:	a811                	j	800065b0 <.L28>

8000659e <.L29>:
8000659e:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
800065a2:	47b2                	lw	a5,12(sp)
800065a4:	97ba                	add	a5,a5,a4
800065a6:	0e078623          	sb	zero,236(a5)
800065aa:	47b2                	lw	a5,12(sp)
800065ac:	0785                	add	a5,a5,1
800065ae:	c63e                	sw	a5,12(sp)

800065b0 <.L28>:
800065b0:	4732                	lw	a4,12(sp)
800065b2:	13700793          	li	a5,311
800065b6:	fee7d4e3          	bge	a5,a4,8000659e <.L29>

#ifdef _DHCP_DEBUG_
	printf("> Send DHCP_REQUEST\r\n");
800065ba:	800047b7          	lui	a5,0x80004
800065be:	69c78513          	add	a0,a5,1692 # 8000469c <.LC1>
800065c2:	74e020ef          	jal	80008d10 <printf>
#endif
	
	sendto(DHCP_SOCKET, (uint8_t *)pDHCPMSG, RIP_MSG_SIZE, ip, DHCP_SERVER_PORT);
800065c6:	1651c503          	lbu	a0,357(gp) # 1080965 <DHCP_SOCKET>
800065ca:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
800065ce:	0054                	add	a3,sp,4
800065d0:	04300713          	li	a4,67
800065d4:	22400613          	li	a2,548
800065d8:	85be                	mv	a1,a5
800065da:	449030ef          	jal	8000a222 <sendto>

}
800065de:	0001                	nop
800065e0:	40f2                	lw	ra,28(sp)
800065e2:	4462                	lw	s0,24(sp)
800065e4:	44d2                	lw	s1,20(sp)
800065e6:	6105                	add	sp,sp,32
800065e8:	8082                	ret

Disassembly of section .text.DHCP_run:

800065ea <DHCP_run>:
	} // if
	return	type;
}

uint8_t DHCP_run(void)
{
800065ea:	1101                	add	sp,sp,-32
800065ec:	ce06                	sw	ra,28(sp)
	uint8_t  type;
	uint8_t  ret;

	if(dhcp_state == STATE_DHCP_STOP) return DHCP_STOPPED;
800065ee:	0ff18703          	lb	a4,255(gp) # 10808ff <dhcp_state>
800065f2:	4799                	li	a5,6
800065f4:	00f71463          	bne	a4,a5,800065fc <.L59>
800065f8:	4795                	li	a5,5
800065fa:	ac51                	j	8000688e <.L60>

800065fc <.L59>:

	if(getSn_SR(DHCP_SOCKET) != SOCK_UDP)
800065fc:	1651c783          	lbu	a5,357(gp) # 1080965 <DHCP_SOCKET>
80006600:	078a                	sll	a5,a5,0x2
80006602:	0785                	add	a5,a5,1
80006604:	078e                	sll	a5,a5,0x3
80006606:	30078793          	add	a5,a5,768
8000660a:	853e                	mv	a0,a5
8000660c:	8dbfe0ef          	jal	80004ee6 <WIZCHIP_READ>
80006610:	87aa                	mv	a5,a0
80006612:	873e                	mv	a4,a5
80006614:	02200793          	li	a5,34
80006618:	00f70b63          	beq	a4,a5,8000662e <.L61>
	   socket(DHCP_SOCKET, Sn_MR_UDP, DHCP_CLIENT_PORT, 0x00);
8000661c:	1651c783          	lbu	a5,357(gp) # 1080965 <DHCP_SOCKET>
80006620:	4681                	li	a3,0
80006622:	04400613          	li	a2,68
80006626:	4589                	li	a1,2
80006628:	853e                	mv	a0,a5
8000662a:	5c4030ef          	jal	80009bee <socket>

8000662e <.L61>:

	ret = DHCP_RUNNING;
8000662e:	4785                	li	a5,1
80006630:	00f107a3          	sb	a5,15(sp)
	type = parseDHCPMSG();
80006634:	20e050ef          	jal	8000b842 <parseDHCPMSG>
80006638:	87aa                	mv	a5,a0
8000663a:	00f10723          	sb	a5,14(sp)

	switch ( dhcp_state ) {
8000663e:	0ff18783          	lb	a5,255(gp) # 10808ff <dhcp_state>
80006642:	4711                	li	a4,4
80006644:	24f76063          	bltu	a4,a5,80006884 <.L83>
80006648:	00279713          	sll	a4,a5,0x2
8000664c:	800037b7          	lui	a5,0x80003
80006650:	30078793          	add	a5,a5,768 # 80003300 <.L64>
80006654:	97ba                	add	a5,a5,a4
80006656:	439c                	lw	a5,0(a5)
80006658:	8782                	jr	a5

8000665a <.L68>:
	   case STATE_DHCP_INIT     :
         DHCP_allocated_ip[0] = 0;
8000665a:	14018023          	sb	zero,320(gp) # 1080940 <DHCP_allocated_ip>
         DHCP_allocated_ip[1] = 0;
8000665e:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
80006662:	000780a3          	sb	zero,1(a5)
         DHCP_allocated_ip[2] = 0;
80006666:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
8000666a:	00078123          	sb	zero,2(a5)
         DHCP_allocated_ip[3] = 0;
8000666e:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
80006672:	000781a3          	sb	zero,3(a5)
   		send_DHCP_DISCOVER();
80006676:	1a1040ef          	jal	8000b016 <send_DHCP_DISCOVER>
   		dhcp_state = STATE_DHCP_DISCOVER;
8000667a:	4705                	li	a4,1
8000667c:	0ee18fa3          	sb	a4,255(gp) # 10808ff <dhcp_state>
   		break;
80006680:	a429                	j	8000688a <.L69>

80006682 <.L67>:
		case STATE_DHCP_DISCOVER :
			if (type == DHCP_OFFER){
80006682:	00e14703          	lbu	a4,14(sp)
80006686:	4789                	li	a5,2
80006688:	04f71b63          	bne	a4,a5,800066de <.L70>
#ifdef _DHCP_DEBUG_
				printf("> Receive DHCP_OFFER\r\n");
8000668c:	800047b7          	lui	a5,0x80004
80006690:	76c78513          	add	a0,a5,1900 # 8000476c <.LC6>
80006694:	67c020ef          	jal	80008d10 <printf>
#endif
            DHCP_allocated_ip[0] = pDHCPMSG->yiaddr[0];
80006698:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000669c:	0107c703          	lbu	a4,16(a5)
800066a0:	14e18023          	sb	a4,320(gp) # 1080940 <DHCP_allocated_ip>
            DHCP_allocated_ip[1] = pDHCPMSG->yiaddr[1];
800066a4:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
800066a8:	0117c703          	lbu	a4,17(a5)
800066ac:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
800066b0:	00e780a3          	sb	a4,1(a5)
            DHCP_allocated_ip[2] = pDHCPMSG->yiaddr[2];
800066b4:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
800066b8:	0127c703          	lbu	a4,18(a5)
800066bc:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
800066c0:	00e78123          	sb	a4,2(a5)
            DHCP_allocated_ip[3] = pDHCPMSG->yiaddr[3];
800066c4:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
800066c8:	0137c703          	lbu	a4,19(a5)
800066cc:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
800066d0:	00e781a3          	sb	a4,3(a5)

				send_DHCP_REQUEST();
800066d4:	388d                	jal	80005f46 <send_DHCP_REQUEST>
				dhcp_state = STATE_DHCP_REQUEST;
800066d6:	4709                	li	a4,2
800066d8:	0ee18fa3          	sb	a4,255(gp) # 10808ff <dhcp_state>
			} else ret = check_DHCP_timeout();
         break;
800066dc:	a27d                	j	8000688a <.L69>

800066de <.L70>:
			} else ret = check_DHCP_timeout();
800066de:	2a65                	jal	80006896 <.LFE9>
800066e0:	87aa                	mv	a5,a0
800066e2:	00f107a3          	sb	a5,15(sp)
         break;
800066e6:	a255                	j	8000688a <.L69>

800066e8 <.L66>:

		case STATE_DHCP_REQUEST :
			if (type == DHCP_ACK) {
800066e8:	00e14703          	lbu	a4,14(sp)
800066ec:	4795                	li	a5,5
800066ee:	02f71a63          	bne	a4,a5,80006722 <.L72>

#ifdef _DHCP_DEBUG_
				printf("> Receive DHCP_ACK\r\n");
800066f2:	800047b7          	lui	a5,0x80004
800066f6:	78478513          	add	a0,a5,1924 # 80004784 <.LC7>
800066fa:	616020ef          	jal	80008d10 <printf>
#endif
				if (check_DHCP_leasedIP()) {
800066fe:	2ca1                	jal	80006956 <check_DHCP_leasedIP>
80006700:	87aa                	mv	a5,a0
80006702:	cb89                	beqz	a5,80006714 <.L73>
					// Network info assignment from DHCP
					dhcp_ip_assign();
80006704:	1841a783          	lw	a5,388(gp) # 1080984 <dhcp_ip_assign>
80006708:	9782                	jalr	a5
					reset_DHCP_timeout();
8000670a:	2cd9                	jal	800069e0 <reset_DHCP_timeout>

					dhcp_state = STATE_DHCP_LEASED;
8000670c:	470d                	li	a4,3
8000670e:	0ee18fa3          	sb	a4,255(gp) # 10808ff <dhcp_state>

				reset_DHCP_timeout();

				dhcp_state = STATE_DHCP_DISCOVER;
			} else ret = check_DHCP_timeout();
		break;
80006712:	aaa5                	j	8000688a <.L69>

80006714 <.L73>:
					reset_DHCP_timeout();
80006714:	24f1                	jal	800069e0 <reset_DHCP_timeout>
					dhcp_ip_conflict();
80006716:	1801a783          	lw	a5,384(gp) # 1080980 <dhcp_ip_conflict>
8000671a:	9782                	jalr	a5
				    dhcp_state = STATE_DHCP_INIT;
8000671c:	0e018fa3          	sb	zero,255(gp) # 10808ff <dhcp_state>
		break;
80006720:	a2ad                	j	8000688a <.L69>

80006722 <.L72>:
			} else if (type == DHCP_NAK) {
80006722:	00e14703          	lbu	a4,14(sp)
80006726:	4799                	li	a5,6
80006728:	00f71d63          	bne	a4,a5,80006742 <.L75>
				printf("> Receive DHCP_NACK\r\n");
8000672c:	800047b7          	lui	a5,0x80004
80006730:	79c78513          	add	a0,a5,1948 # 8000479c <.LC8>
80006734:	5dc020ef          	jal	80008d10 <printf>
				reset_DHCP_timeout();
80006738:	2465                	jal	800069e0 <reset_DHCP_timeout>
				dhcp_state = STATE_DHCP_DISCOVER;
8000673a:	4705                	li	a4,1
8000673c:	0ee18fa3          	sb	a4,255(gp) # 10808ff <dhcp_state>
		break;
80006740:	a2a9                	j	8000688a <.L69>

80006742 <.L75>:
			} else ret = check_DHCP_timeout();
80006742:	2a91                	jal	80006896 <.LFE9>
80006744:	87aa                	mv	a5,a0
80006746:	00f107a3          	sb	a5,15(sp)
		break;
8000674a:	a281                	j	8000688a <.L69>

8000674c <.L65>:

		case STATE_DHCP_LEASED :
		   ret = DHCP_IP_LEASED;
8000674c:	4791                	li	a5,4
8000674e:	00f107a3          	sb	a5,15(sp)
			if ((dhcp_lease_time != INFINITE_LEASETIME) && ((dhcp_lease_time/2) < dhcp_tick_1s)) {
80006752:	1781a703          	lw	a4,376(gp) # 1080978 <dhcp_lease_time>
80006756:	57fd                	li	a5,-1
80006758:	12f70863          	beq	a4,a5,80006888 <.L84>
8000675c:	1781a783          	lw	a5,376(gp) # 1080978 <dhcp_lease_time>
80006760:	0017d713          	srl	a4,a5,0x1
80006764:	12c1a783          	lw	a5,300(gp) # 108092c <dhcp_tick_1s>
80006768:	12f77063          	bgeu	a4,a5,80006888 <.L84>
				
#ifdef _DHCP_DEBUG_
 				printf("> Maintains the IP address \r\n");
8000676c:	800047b7          	lui	a5,0x80004
80006770:	7b478513          	add	a0,a5,1972 # 800047b4 <.LC9>
80006774:	59c020ef          	jal	80008d10 <printf>
#endif

				type = 0;
80006778:	00010723          	sb	zero,14(sp)
				OLD_allocated_ip[0] = DHCP_allocated_ip[0];
8000677c:	1401c703          	lbu	a4,320(gp) # 1080940 <DHCP_allocated_ip>
80006780:	12e18c23          	sb	a4,312(gp) # 1080938 <OLD_allocated_ip>
				OLD_allocated_ip[1] = DHCP_allocated_ip[1];
80006784:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
80006788:	0017c703          	lbu	a4,1(a5)
8000678c:	13818793          	add	a5,gp,312 # 1080938 <OLD_allocated_ip>
80006790:	00e780a3          	sb	a4,1(a5)
				OLD_allocated_ip[2] = DHCP_allocated_ip[2];
80006794:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
80006798:	0027c703          	lbu	a4,2(a5)
8000679c:	13818793          	add	a5,gp,312 # 1080938 <OLD_allocated_ip>
800067a0:	00e78123          	sb	a4,2(a5)
				OLD_allocated_ip[3] = DHCP_allocated_ip[3];
800067a4:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
800067a8:	0037c703          	lbu	a4,3(a5)
800067ac:	13818793          	add	a5,gp,312 # 1080938 <OLD_allocated_ip>
800067b0:	00e781a3          	sb	a4,3(a5)
				
				DHCP_XID++;
800067b4:	14c1a783          	lw	a5,332(gp) # 108094c <DHCP_XID>
800067b8:	00178713          	add	a4,a5,1
800067bc:	14e1a623          	sw	a4,332(gp) # 108094c <DHCP_XID>

				send_DHCP_REQUEST();
800067c0:	f86ff0ef          	jal	80005f46 <send_DHCP_REQUEST>

				reset_DHCP_timeout();
800067c4:	2c31                	jal	800069e0 <reset_DHCP_timeout>

				dhcp_state = STATE_DHCP_REREQUEST;
800067c6:	4711                	li	a4,4
800067c8:	0ee18fa3          	sb	a4,255(gp) # 10808ff <dhcp_state>
			}
		break;
800067cc:	a875                	j	80006888 <.L84>

800067ce <.L63>:

		case STATE_DHCP_REREQUEST :
		   ret = DHCP_IP_LEASED;
800067ce:	4791                	li	a5,4
800067d0:	00f107a3          	sb	a5,15(sp)
			if (type == DHCP_ACK) {
800067d4:	00e14703          	lbu	a4,14(sp)
800067d8:	4795                	li	a5,5
800067da:	08f71063          	bne	a4,a5,8000685a <.L77>
				dhcp_retry_count = 0;
800067de:	16018123          	sb	zero,354(gp) # 1080962 <dhcp_retry_count>
				if (OLD_allocated_ip[0] != DHCP_allocated_ip[0] || 
800067e2:	1381c703          	lbu	a4,312(gp) # 1080938 <OLD_allocated_ip>
800067e6:	1401c783          	lbu	a5,320(gp) # 1080940 <DHCP_allocated_ip>
800067ea:	04f71063          	bne	a4,a5,8000682a <.L78>
				    OLD_allocated_ip[1] != DHCP_allocated_ip[1] ||
800067ee:	13818793          	add	a5,gp,312 # 1080938 <OLD_allocated_ip>
800067f2:	0017c703          	lbu	a4,1(a5)
800067f6:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
800067fa:	0017c783          	lbu	a5,1(a5)
				if (OLD_allocated_ip[0] != DHCP_allocated_ip[0] || 
800067fe:	02f71663          	bne	a4,a5,8000682a <.L78>
				    OLD_allocated_ip[2] != DHCP_allocated_ip[2] ||
80006802:	13818793          	add	a5,gp,312 # 1080938 <OLD_allocated_ip>
80006806:	0027c703          	lbu	a4,2(a5)
8000680a:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
8000680e:	0027c783          	lbu	a5,2(a5)
				    OLD_allocated_ip[1] != DHCP_allocated_ip[1] ||
80006812:	00f71c63          	bne	a4,a5,8000682a <.L78>
				    OLD_allocated_ip[3] != DHCP_allocated_ip[3]) 
80006816:	13818793          	add	a5,gp,312 # 1080938 <OLD_allocated_ip>
8000681a:	0037c703          	lbu	a4,3(a5)
8000681e:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
80006822:	0037c783          	lbu	a5,3(a5)
				    OLD_allocated_ip[2] != DHCP_allocated_ip[2] ||
80006826:	00f70f63          	beq	a4,a5,80006844 <.L79>

8000682a <.L78>:
				{
					ret = DHCP_IP_CHANGED;
8000682a:	478d                	li	a5,3
8000682c:	00f107a3          	sb	a5,15(sp)
					dhcp_ip_update();
80006830:	17c1a783          	lw	a5,380(gp) # 108097c <dhcp_ip_update>
80006834:	9782                	jalr	a5
               #ifdef _DHCP_DEBUG_
                  printf(">IP changed.\r\n");
80006836:	800047b7          	lui	a5,0x80004
8000683a:	7d478513          	add	a0,a5,2004 # 800047d4 <.LC10>
8000683e:	4d2020ef          	jal	80008d10 <printf>
80006842:	a039                	j	80006850 <.L80>

80006844 <.L79>:
               #endif
					
				}
         #ifdef _DHCP_DEBUG_
            else printf(">IP is continued.\r\n");
80006844:	800047b7          	lui	a5,0x80004
80006848:	7e478513          	add	a0,a5,2020 # 800047e4 <.LC11>
8000684c:	4c4020ef          	jal	80008d10 <printf>

80006850 <.L80>:
         #endif            				
				reset_DHCP_timeout();
80006850:	2a41                	jal	800069e0 <reset_DHCP_timeout>
				dhcp_state = STATE_DHCP_LEASED;
80006852:	470d                	li	a4,3
80006854:	0ee18fa3          	sb	a4,255(gp) # 10808ff <dhcp_state>

				reset_DHCP_timeout();

				dhcp_state = STATE_DHCP_DISCOVER;
			} else ret = check_DHCP_timeout();
	   	break;
80006858:	a80d                	j	8000688a <.L69>

8000685a <.L77>:
			} else if (type == DHCP_NAK) {
8000685a:	00e14703          	lbu	a4,14(sp)
8000685e:	4799                	li	a5,6
80006860:	00f71d63          	bne	a4,a5,8000687a <.L82>
				printf("> Receive DHCP_NACK, Failed to maintain ip\r\n");
80006864:	800047b7          	lui	a5,0x80004
80006868:	7f878513          	add	a0,a5,2040 # 800047f8 <.LC12>
8000686c:	4a4020ef          	jal	80008d10 <printf>
				reset_DHCP_timeout();
80006870:	2a85                	jal	800069e0 <reset_DHCP_timeout>
				dhcp_state = STATE_DHCP_DISCOVER;
80006872:	4705                	li	a4,1
80006874:	0ee18fa3          	sb	a4,255(gp) # 10808ff <dhcp_state>
	   	break;
80006878:	a809                	j	8000688a <.L69>

8000687a <.L82>:
			} else ret = check_DHCP_timeout();
8000687a:	2831                	jal	80006896 <.LFE9>
8000687c:	87aa                	mv	a5,a0
8000687e:	00f107a3          	sb	a5,15(sp)
	   	break;
80006882:	a021                	j	8000688a <.L69>

80006884 <.L83>:
		default :
   		break;
80006884:	0001                	nop
80006886:	a011                	j	8000688a <.L69>

80006888 <.L84>:
		break;
80006888:	0001                	nop

8000688a <.L69>:
	}

	return ret;
8000688a:	00f14783          	lbu	a5,15(sp)

8000688e <.L60>:
}
8000688e:	853e                	mv	a0,a5
80006890:	40f2                	lw	ra,28(sp)
80006892:	6105                	add	sp,sp,32
80006894:	8082                	ret

Disassembly of section .text.check_DHCP_timeout:

80006896 <check_DHCP_timeout>:
   close(DHCP_SOCKET);
   dhcp_state = STATE_DHCP_STOP;
}

uint8_t check_DHCP_timeout(void)
{
80006896:	1101                	add	sp,sp,-32
80006898:	ce06                	sw	ra,28(sp)
	uint8_t ret = DHCP_RUNNING;
8000689a:	4785                	li	a5,1
8000689c:	00f107a3          	sb	a5,15(sp)
	
	if (dhcp_retry_count < MAX_DHCP_RETRY) {
800068a0:	16218703          	lb	a4,354(gp) # 1080962 <dhcp_retry_count>
800068a4:	4785                	li	a5,1
800068a6:	06e7c663          	blt	a5,a4,80006912 <.L87>
		if (dhcp_tick_next < dhcp_tick_1s) {
800068aa:	1741a703          	lw	a4,372(gp) # 1080974 <dhcp_tick_next>
800068ae:	12c1a783          	lw	a5,300(gp) # 108092c <dhcp_tick_1s>
800068b2:	08f77c63          	bgeu	a4,a5,8000694a <.L88>

			switch ( dhcp_state ) {
800068b6:	0ff18783          	lb	a5,255(gp) # 10808ff <dhcp_state>
800068ba:	4711                	li	a4,4
800068bc:	02e78263          	beq	a5,a4,800068e0 <.L89>
800068c0:	4711                	li	a4,4
800068c2:	02f74263          	blt	a4,a5,800068e6 <.L99>
800068c6:	4705                	li	a4,1
800068c8:	00e78663          	beq	a5,a4,800068d4 <.L91>
800068cc:	4709                	li	a4,2
800068ce:	00e78663          	beq	a5,a4,800068da <.L92>
					
					send_DHCP_REQUEST();
				break;
		
				default :
				break;
800068d2:	a811                	j	800068e6 <.L99>

800068d4 <.L91>:
					send_DHCP_DISCOVER();
800068d4:	742040ef          	jal	8000b016 <send_DHCP_DISCOVER>
				break;
800068d8:	a801                	j	800068e8 <.L93>

800068da <.L92>:
					send_DHCP_REQUEST();
800068da:	e6cff0ef          	jal	80005f46 <send_DHCP_REQUEST>
				break;
800068de:	a029                	j	800068e8 <.L93>

800068e0 <.L89>:
					send_DHCP_REQUEST();
800068e0:	e66ff0ef          	jal	80005f46 <send_DHCP_REQUEST>
				break;
800068e4:	a011                	j	800068e8 <.L93>

800068e6 <.L99>:
				break;
800068e6:	0001                	nop

800068e8 <.L93>:
			}

			dhcp_tick_1s = 0;
800068e8:	1201a623          	sw	zero,300(gp) # 108092c <dhcp_tick_1s>
			dhcp_tick_next = dhcp_tick_1s + DHCP_WAIT_TIME;
800068ec:	12c1a783          	lw	a5,300(gp) # 108092c <dhcp_tick_1s>
800068f0:	00a78713          	add	a4,a5,10
800068f4:	16e1aa23          	sw	a4,372(gp) # 1080974 <dhcp_tick_next>
			dhcp_retry_count++;
800068f8:	16218783          	lb	a5,354(gp) # 1080962 <dhcp_retry_count>
800068fc:	0ff7f793          	zext.b	a5,a5
80006900:	0785                	add	a5,a5,1
80006902:	0ff7f793          	zext.b	a5,a5
80006906:	01879713          	sll	a4,a5,0x18
8000690a:	8761                	sra	a4,a4,0x18
8000690c:	16e18123          	sb	a4,354(gp) # 1080962 <dhcp_retry_count>
80006910:	a82d                	j	8000694a <.L88>

80006912 <.L87>:
		}
	} else { // timeout occurred

		switch(dhcp_state) {
80006912:	0ff18783          	lb	a5,255(gp) # 10808ff <dhcp_state>
80006916:	4711                	li	a4,4
80006918:	02e78163          	beq	a5,a4,8000693a <.L94>
8000691c:	4711                	li	a4,4
8000691e:	02f74463          	blt	a4,a5,80006946 <.L100>
80006922:	4705                	li	a4,1
80006924:	00e78663          	beq	a5,a4,80006930 <.L96>
80006928:	4709                	li	a4,2
8000692a:	00e78863          	beq	a5,a4,8000693a <.L94>
			case STATE_DHCP_REREQUEST:
				send_DHCP_DISCOVER();
				dhcp_state = STATE_DHCP_DISCOVER;
				break;
			default :
				break;
8000692e:	a821                	j	80006946 <.L100>

80006930 <.L96>:
				dhcp_state = STATE_DHCP_INIT;
80006930:	0e018fa3          	sb	zero,255(gp) # 10808ff <dhcp_state>
				ret = DHCP_FAILED;
80006934:	000107a3          	sb	zero,15(sp)
				break;
80006938:	a801                	j	80006948 <.L97>

8000693a <.L94>:
				send_DHCP_DISCOVER();
8000693a:	6dc040ef          	jal	8000b016 <send_DHCP_DISCOVER>
				dhcp_state = STATE_DHCP_DISCOVER;
8000693e:	4705                	li	a4,1
80006940:	0ee18fa3          	sb	a4,255(gp) # 10808ff <dhcp_state>
				break;
80006944:	a011                	j	80006948 <.L97>

80006946 <.L100>:
				break;
80006946:	0001                	nop

80006948 <.L97>:
		}
		reset_DHCP_timeout();
80006948:	2861                	jal	800069e0 <reset_DHCP_timeout>

8000694a <.L88>:
	}
	return ret;
8000694a:	00f14783          	lbu	a5,15(sp)
}
8000694e:	853e                	mv	a0,a5
80006950:	40f2                	lw	ra,28(sp)
80006952:	6105                	add	sp,sp,32
80006954:	8082                	ret

Disassembly of section .text.check_DHCP_leasedIP:

80006956 <check_DHCP_leasedIP>:

int8_t check_DHCP_leasedIP(void)
{
80006956:	1101                	add	sp,sp,-32
80006958:	ce06                	sw	ra,28(sp)
	uint8_t tmp;
	int32_t ret;

	//WIZchip RCR value changed for ARP Timeout count control
	tmp = getRCR();
8000695a:	6789                	lui	a5,0x2
8000695c:	b0078513          	add	a0,a5,-1280 # 1b00 <__fw_size__+0xb00>
80006960:	d86fe0ef          	jal	80004ee6 <WIZCHIP_READ>
80006964:	87aa                	mv	a5,a0
80006966:	00f107a3          	sb	a5,15(sp)
	setRCR(0x03);
8000696a:	458d                	li	a1,3
8000696c:	6789                	lui	a5,0x2
8000696e:	b0078513          	add	a0,a5,-1280 # 1b00 <__fw_size__+0xb00>
80006972:	731020ef          	jal	800098a2 <WIZCHIP_WRITE>

	// IP conflict detection : ARP request - ARP reply
	// Broadcasting ARP Request for check the IP conflict using UDP sendto() function
	ret = sendto(DHCP_SOCKET, (uint8_t *)"CHECK_IP_CONFLICT", 17, DHCP_allocated_ip, 5000);
80006976:	1651c503          	lbu	a0,357(gp) # 1080965 <DHCP_SOCKET>
8000697a:	6785                	lui	a5,0x1
8000697c:	38878713          	add	a4,a5,904 # 1388 <__fw_size__+0x388>
80006980:	14018693          	add	a3,gp,320 # 1080940 <DHCP_allocated_ip>
80006984:	4645                	li	a2,17
80006986:	800057b7          	lui	a5,0x80005
8000698a:	82878593          	add	a1,a5,-2008 # 80004828 <.LC13>
8000698e:	095030ef          	jal	8000a222 <sendto>
80006992:	c42a                	sw	a0,8(sp)

	// RCR value restore
	setRCR(tmp);
80006994:	00f14783          	lbu	a5,15(sp)
80006998:	85be                	mv	a1,a5
8000699a:	6789                	lui	a5,0x2
8000699c:	b0078513          	add	a0,a5,-1280 # 1b00 <__fw_size__+0xb00>
800069a0:	703020ef          	jal	800098a2 <WIZCHIP_WRITE>

	if(ret == SOCKERR_TIMEOUT) {
800069a4:	4722                	lw	a4,8(sp)
800069a6:	57cd                	li	a5,-13
800069a8:	00f71a63          	bne	a4,a5,800069bc <.L102>
		// UDP send Timeout occurred : allocated IP address is unique, DHCP Success

#ifdef _DHCP_DEBUG_
		printf("\r\n> Check leased IP - OK\r\n");
800069ac:	800057b7          	lui	a5,0x80005
800069b0:	83c78513          	add	a0,a5,-1988 # 8000483c <.LC14>
800069b4:	35c020ef          	jal	80008d10 <printf>
#endif

		return 1;
800069b8:	4785                	li	a5,1
800069ba:	a839                	j	800069d8 <.L103>

800069bc <.L102>:
	} else {
		// Received ARP reply or etc : IP address conflict occur, DHCP Failed
		send_DHCP_DECLINE();
800069bc:	313040ef          	jal	8000b4ce <send_DHCP_DECLINE>

		ret = dhcp_tick_1s;
800069c0:	12c1a783          	lw	a5,300(gp) # 108092c <dhcp_tick_1s>
800069c4:	c43e                	sw	a5,8(sp)
		while((dhcp_tick_1s - ret) < 2) ;   // wait for 1s over; wait to complete to send DECLINE message;
800069c6:	0001                	nop

800069c8 <.L104>:
800069c8:	12c1a703          	lw	a4,300(gp) # 108092c <dhcp_tick_1s>
800069cc:	47a2                	lw	a5,8(sp)
800069ce:	8f1d                	sub	a4,a4,a5
800069d0:	4785                	li	a5,1
800069d2:	fee7fbe3          	bgeu	a5,a4,800069c8 <.L104>

		return 0;
800069d6:	4781                	li	a5,0

800069d8 <.L103>:
	}
}	
800069d8:	853e                	mv	a0,a5
800069da:	40f2                	lw	ra,28(sp)
800069dc:	6105                	add	sp,sp,32
800069de:	8082                	ret

Disassembly of section .text.reset_DHCP_timeout:

800069e0 <reset_DHCP_timeout>:


/* Reset the DHCP timeout count and retry count. */
void reset_DHCP_timeout(void)
{
	dhcp_tick_1s = 0;
800069e0:	1201a623          	sw	zero,300(gp) # 108092c <dhcp_tick_1s>
	dhcp_tick_next = DHCP_WAIT_TIME;
800069e4:	4729                	li	a4,10
800069e6:	16e1aa23          	sw	a4,372(gp) # 1080974 <dhcp_tick_next>
	dhcp_retry_count = 0;
800069ea:	16018123          	sb	zero,354(gp) # 1080962 <dhcp_retry_count>
}
800069ee:	0001                	nop
800069f0:	8082                	ret

Disassembly of section .text.spi_is_active:

800069f2 <spi_is_active>:
 *
 * @param ptr SPI base address.
 * @retval bool true for active, false for inactive
 */
static inline bool spi_is_active(SPI_Type *ptr)
{
800069f2:	1141                	add	sp,sp,-16
800069f4:	c62a                	sw	a0,12(sp)
    return ((ptr->STATUS & SPI_STATUS_SPIACTIVE_MASK) == SPI_STATUS_SPIACTIVE_MASK) ? true : false;
800069f6:	47b2                	lw	a5,12(sp)
800069f8:	5bdc                	lw	a5,52(a5)
800069fa:	8b85                	and	a5,a5,1
800069fc:	17fd                	add	a5,a5,-1
800069fe:	0017b793          	seqz	a5,a5
80006a02:	0ff7f793          	zext.b	a5,a5
}
80006a06:	853e                	mv	a0,a5
80006a08:	0141                	add	sp,sp,16
80006a0a:	8082                	ret

Disassembly of section .text.spi_get_rx_fifo_valid_data_size:

80006a0c <spi_get_rx_fifo_valid_data_size>:
 * @param [in] ptr SPI base address
 *
 * @return rx fifo valid data size
 */
static inline uint8_t spi_get_rx_fifo_valid_data_size(SPI_Type *ptr)
{
80006a0c:	1141                	add	sp,sp,-16
80006a0e:	c62a                	sw	a0,12(sp)
    return ((SPI_STATUS_RXNUM_7_6_GET(ptr->STATUS) << 6) | SPI_STATUS_RXNUM_5_0_GET(ptr->STATUS));
80006a10:	47b2                	lw	a5,12(sp)
80006a12:	5bdc                	lw	a5,52(a5)
80006a14:	83e1                	srl	a5,a5,0x18
80006a16:	0ff7f793          	zext.b	a5,a5
80006a1a:	079a                	sll	a5,a5,0x6
80006a1c:	0ff7f713          	zext.b	a4,a5
80006a20:	47b2                	lw	a5,12(sp)
80006a22:	5bdc                	lw	a5,52(a5)
80006a24:	83a1                	srl	a5,a5,0x8
80006a26:	0ff7f793          	zext.b	a5,a5
80006a2a:	03f7f793          	and	a5,a5,63
80006a2e:	0ff7f793          	zext.b	a5,a5
80006a32:	8fd9                	or	a5,a5,a4
80006a34:	0ff7f793          	zext.b	a5,a5
}
80006a38:	853e                	mv	a0,a5
80006a3a:	0141                	add	sp,sp,16
80006a3c:	8082                	ret

Disassembly of section .text.gpio_write_pin:

80006a3e <gpio_write_pin>:
 * @param port Port index
 * @param pin Pin index
 * @param high Pin level set to high when it is set to true
 */
static inline void gpio_write_pin(GPIO_Type *ptr, uint32_t port, uint8_t pin, uint8_t high)
{
80006a3e:	1141                	add	sp,sp,-16
80006a40:	c62a                	sw	a0,12(sp)
80006a42:	c42e                	sw	a1,8(sp)
80006a44:	87b2                	mv	a5,a2
80006a46:	8736                	mv	a4,a3
80006a48:	00f103a3          	sb	a5,7(sp)
80006a4c:	87ba                	mv	a5,a4
80006a4e:	00f10323          	sb	a5,6(sp)
    if (high) {
80006a52:	00614783          	lbu	a5,6(sp)
80006a56:	cf91                	beqz	a5,80006a72 <.L13>
        ptr->DO[port].SET = 1 << pin;
80006a58:	00714783          	lbu	a5,7(sp)
80006a5c:	4705                	li	a4,1
80006a5e:	00f717b3          	sll	a5,a4,a5
80006a62:	86be                	mv	a3,a5
80006a64:	4732                	lw	a4,12(sp)
80006a66:	47a2                	lw	a5,8(sp)
80006a68:	07c1                	add	a5,a5,16
80006a6a:	0792                	sll	a5,a5,0x4
80006a6c:	97ba                	add	a5,a5,a4
80006a6e:	c3d4                	sw	a3,4(a5)
    } else {
        ptr->DO[port].CLEAR = 1 << pin;
    }
}
80006a70:	a829                	j	80006a8a <.L15>

80006a72 <.L13>:
        ptr->DO[port].CLEAR = 1 << pin;
80006a72:	00714783          	lbu	a5,7(sp)
80006a76:	4705                	li	a4,1
80006a78:	00f717b3          	sll	a5,a4,a5
80006a7c:	86be                	mv	a3,a5
80006a7e:	4732                	lw	a4,12(sp)
80006a80:	47a2                	lw	a5,8(sp)
80006a82:	07c1                	add	a5,a5,16
80006a84:	0792                	sll	a5,a5,0x4
80006a86:	97ba                	add	a5,a5,a4
80006a88:	c794                	sw	a3,8(a5)

80006a8a <.L15>:
}
80006a8a:	0001                	nop
80006a8c:	0141                	add	sp,sp,16
80006a8e:	8082                	ret

Disassembly of section .text.hpm_spi_transfer_via_dma:

80006a90 <hpm_spi_transfer_via_dma>:
    }
    return stat;
}

static hpm_stat_t hpm_spi_transfer_via_dma(SPI_Type *spi_ptr, DMA_Type *dma_ptr, uint8_t *buf, uint32_t len, bool is_read)
{
80006a90:	7139                	add	sp,sp,-64
80006a92:	de06                	sw	ra,60(sp)
80006a94:	ce2a                	sw	a0,28(sp)
80006a96:	cc2e                	sw	a1,24(sp)
80006a98:	ca32                	sw	a2,20(sp)
80006a9a:	c836                	sw	a3,16(sp)
80006a9c:	87ba                	mv	a5,a4
80006a9e:	00f107a3          	sb	a5,15(sp)
    hpm_stat_t stat;
    uint32_t timeout_count = 0;
80006aa2:	d402                	sw	zero,40(sp)
        PORT_SPI_BASE->RD_TRANS_CNT = len - 1;
    } else {
        PORT_SPI_BASE->WR_TRANS_CNT = len - 1;
    }
#endif
    if (is_read) {
80006aa4:	00f14783          	lbu	a5,15(sp)
80006aa8:	cbd9                	beqz	a5,80006b3e <.L29>
        /* set mode is readonly. and set the transfer len is 1*/
        PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_RDTRANCNT_MASK) | SPI_TRANSCTRL_RDTRANCNT_SET(len - 1));
80006aaa:	f00347b7          	lui	a5,0xf0034
80006aae:	539c                	lw	a5,32(a5)
80006ab0:	e007f693          	and	a3,a5,-512
80006ab4:	47c2                	lw	a5,16(sp)
80006ab6:	17fd                	add	a5,a5,-1 # f0033fff <__XPI0_segment_end__+0x6f833fff>
80006ab8:	1ff7f713          	and	a4,a5,511
80006abc:	f00347b7          	lui	a5,0xf0034
80006ac0:	8f55                	or	a4,a4,a3
80006ac2:	d398                	sw	a4,32(a5)
        PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_TRANSMODE_MASK) | SPI_TRANSCTRL_TRANSMODE_SET(spi_trans_read_only));
80006ac4:	f00347b7          	lui	a5,0xf0034
80006ac8:	5398                	lw	a4,32(a5)
80006aca:	f10007b7          	lui	a5,0xf1000
80006ace:	17fd                	add	a5,a5,-1 # f0ffffff <__AHB_SRAM_segment_end__+0xcf7fff>
80006ad0:	00f776b3          	and	a3,a4,a5
80006ad4:	f00347b7          	lui	a5,0xf0034
80006ad8:	02000737          	lui	a4,0x2000
80006adc:	8f55                	or	a4,a4,a3
80006ade:	d398                	sw	a4,32(a5)
        /* reset the fifo*/
        PORT_SPI_BASE->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
80006ae0:	f00347b7          	lui	a5,0xf0034
80006ae4:	5b98                	lw	a4,48(a5)
80006ae6:	f00347b7          	lui	a5,0xf0034
80006aea:	00776713          	or	a4,a4,7
80006aee:	db98                	sw	a4,48(a5)
        stat = spi_nor_rx_trigger_dma(dma_ptr, PORT_SPI_RX_DMA_CH, spi_ptr,
80006af0:	47d2                	lw	a5,20(sp)
80006af2:	85be                	mv	a1,a5
80006af4:	4501                	li	a0,0
80006af6:	4c8050ef          	jal	8000bfbe <core_local_mem_to_sys_address>
80006afa:	86aa                	mv	a3,a0
80006afc:	4801                	li	a6,0
80006afe:	47c2                	lw	a5,16(sp)
80006b00:	4701                	li	a4,0
80006b02:	4672                	lw	a2,28(sp)
80006b04:	4581                	li	a1,0
80006b06:	4562                	lw	a0,24(sp)
80006b08:	66e050ef          	jal	8000c176 <spi_nor_rx_trigger_dma>
80006b0c:	d62a                	sw	a0,44(sp)
                                core_local_mem_to_sys_address(BOARD_RUNNING_CORE, (uint32_t)buf),
                                DMA_TRANSFER_WIDTH_BYTE, len, DMA_NUM_TRANSFER_PER_BURST_1T);
        actual_cs_sel();
80006b0e:	28e1                	jal	80006be6 <.LFE243>
        PORT_SPI_BASE->CMD = 0xff;
80006b10:	f00347b7          	lui	a5,0xf0034
80006b14:	0ff00713          	li	a4,255
80006b18:	d3d8                	sw	a4,36(a5)

        while (spi_is_active(spi_ptr)) {
80006b1a:	a829                	j	80006b34 <.L30>

80006b1c <.L32>:
            timeout_count++;
80006b1c:	57a2                	lw	a5,40(sp)
80006b1e:	0785                	add	a5,a5,1 # f0034001 <__XPI0_segment_end__+0x6f834001>
80006b20:	d43e                	sw	a5,40(sp)
            if (timeout_count >= 0xFFFFFF) {
80006b22:	5722                	lw	a4,40(sp)
80006b24:	010007b7          	lui	a5,0x1000
80006b28:	17f9                	add	a5,a5,-2 # fffffe <_flash_size+0x7ffffe>
80006b2a:	00e7f563          	bgeu	a5,a4,80006b34 <.L30>
                stat = status_timeout;
80006b2e:	478d                	li	a5,3
80006b30:	d63e                	sw	a5,44(sp)
                break;
80006b32:	a06d                	j	80006bdc <.L33>

80006b34 <.L30>:
        while (spi_is_active(spi_ptr)) {
80006b34:	4572                	lw	a0,28(sp)
80006b36:	3d75                	jal	800069f2 <spi_is_active>
80006b38:	87aa                	mv	a5,a0
80006b3a:	f3ed                	bnez	a5,80006b1c <.L32>
80006b3c:	a045                	j	80006bdc <.L33>

80006b3e <.L29>:
            }
        }
    } else {
        /* set mode is readonly. and set the transfer len is 1*/
        PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_WRTRANCNT_MASK) | SPI_TRANSCTRL_WRTRANCNT_SET(len - 1));
80006b3e:	f00347b7          	lui	a5,0xf0034
80006b42:	5398                	lw	a4,32(a5)
80006b44:	ffe017b7          	lui	a5,0xffe01
80006b48:	17fd                	add	a5,a5,-1 # ffe00fff <__APB_SRAM_segment_end__+0xbd0efff>
80006b4a:	00f776b3          	and	a3,a4,a5
80006b4e:	47c2                	lw	a5,16(sp)
80006b50:	17fd                	add	a5,a5,-1
80006b52:	00c79713          	sll	a4,a5,0xc
80006b56:	001ff7b7          	lui	a5,0x1ff
80006b5a:	8f7d                	and	a4,a4,a5
80006b5c:	f00347b7          	lui	a5,0xf0034
80006b60:	8f55                	or	a4,a4,a3
80006b62:	d398                	sw	a4,32(a5)
        PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_TRANSMODE_MASK) | SPI_TRANSCTRL_TRANSMODE_SET(spi_trans_write_only));
80006b64:	f00347b7          	lui	a5,0xf0034
80006b68:	5398                	lw	a4,32(a5)
80006b6a:	f10007b7          	lui	a5,0xf1000
80006b6e:	17fd                	add	a5,a5,-1 # f0ffffff <__AHB_SRAM_segment_end__+0xcf7fff>
80006b70:	00f776b3          	and	a3,a4,a5
80006b74:	f00347b7          	lui	a5,0xf0034
80006b78:	01000737          	lui	a4,0x1000
80006b7c:	8f55                	or	a4,a4,a3
80006b7e:	d398                	sw	a4,32(a5)
        /* reset the fifo*/
        PORT_SPI_BASE->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
80006b80:	f00347b7          	lui	a5,0xf0034
80006b84:	5b98                	lw	a4,48(a5)
80006b86:	f00347b7          	lui	a5,0xf0034
80006b8a:	00776713          	or	a4,a4,7
80006b8e:	db98                	sw	a4,48(a5)
        stat = spi_nor_tx_trigger_dma(dma_ptr, PORT_SPI_TX_DMA_CH, spi_ptr,
80006b90:	47d2                	lw	a5,20(sp)
80006b92:	85be                	mv	a1,a5
80006b94:	4501                	li	a0,0
80006b96:	428050ef          	jal	8000bfbe <core_local_mem_to_sys_address>
80006b9a:	86aa                	mv	a3,a0
80006b9c:	4801                	li	a6,0
80006b9e:	47c2                	lw	a5,16(sp)
80006ba0:	4701                	li	a4,0
80006ba2:	4672                	lw	a2,28(sp)
80006ba4:	4585                	li	a1,1
80006ba6:	4562                	lw	a0,24(sp)
80006ba8:	532050ef          	jal	8000c0da <spi_nor_tx_trigger_dma>
80006bac:	d62a                	sw	a0,44(sp)
                                        core_local_mem_to_sys_address(BOARD_RUNNING_CORE, (uint32_t)buf),
                                        DMA_TRANSFER_WIDTH_BYTE, len, DMA_NUM_TRANSFER_PER_BURST_1T);
        actual_cs_sel();
80006bae:	2825                	jal	80006be6 <.LFE243>
        PORT_SPI_BASE->CMD = 0xff;
80006bb0:	f00347b7          	lui	a5,0xf0034
80006bb4:	0ff00713          	li	a4,255
80006bb8:	d3d8                	sw	a4,36(a5)
        while (spi_is_active(spi_ptr)) {
80006bba:	a829                	j	80006bd4 <.L34>

80006bbc <.L35>:
            timeout_count++;
80006bbc:	57a2                	lw	a5,40(sp)
80006bbe:	0785                	add	a5,a5,1 # f0034001 <__XPI0_segment_end__+0x6f834001>
80006bc0:	d43e                	sw	a5,40(sp)
            if (timeout_count >= 0xFFFFFF) {
80006bc2:	5722                	lw	a4,40(sp)
80006bc4:	010007b7          	lui	a5,0x1000
80006bc8:	17f9                	add	a5,a5,-2 # fffffe <_flash_size+0x7ffffe>
80006bca:	00e7f563          	bgeu	a5,a4,80006bd4 <.L34>
                stat = status_timeout;
80006bce:	478d                	li	a5,3
80006bd0:	d63e                	sw	a5,44(sp)
                break;
80006bd2:	a029                	j	80006bdc <.L33>

80006bd4 <.L34>:
        while (spi_is_active(spi_ptr)) {
80006bd4:	4572                	lw	a0,28(sp)
80006bd6:	3d31                	jal	800069f2 <spi_is_active>
80006bd8:	87aa                	mv	a5,a0
80006bda:	f3ed                	bnez	a5,80006bbc <.L35>

80006bdc <.L33>:
            }
        }
    }
    return stat;
80006bdc:	57b2                	lw	a5,44(sp)
}
80006bde:	853e                	mv	a0,a5
80006be0:	50f2                	lw	ra,60(sp)
80006be2:	6121                	add	sp,sp,64
80006be4:	8082                	ret

Disassembly of section .text.actual_cs_sel:

80006be6 <actual_cs_sel>:
    /*in order to cs interval, actual_cs_sel API is actually use during transmisson*/

}

static void actual_cs_sel(void)
{
80006be6:	1141                	add	sp,sp,-16
80006be8:	c606                	sw	ra,12(sp)
#if !defined(USE_HARDWARE_CS) || (USE_HARDWARE_CS == 0)
    gpio_write_pin(PORT_CS_PIN, 0);
80006bea:	4681                	li	a3,0
80006bec:	4649                	li	a2,18
80006bee:	4581                	li	a1,0
80006bf0:	f0000537          	lui	a0,0xf0000
80006bf4:	35a9                	jal	80006a3e <gpio_write_pin>
#endif
}
80006bf6:	0001                	nop
80006bf8:	40b2                	lw	ra,12(sp)
80006bfa:	0141                	add	sp,sp,16
80006bfc:	8082                	ret

Disassembly of section .text.cs_desel:

80006bfe <cs_desel>:

static void cs_desel(void)
{
80006bfe:	1141                	add	sp,sp,-16
80006c00:	c606                	sw	ra,12(sp)
#if !defined(USE_HARDWARE_CS) || (USE_HARDWARE_CS == 0)
    gpio_write_pin(PORT_CS_PIN, 1);
80006c02:	4685                	li	a3,1
80006c04:	4649                	li	a2,18
80006c06:	4581                	li	a1,0
80006c08:	f0000537          	lui	a0,0xf0000
80006c0c:	3d0d                	jal	80006a3e <gpio_write_pin>
#endif
}
80006c0e:	0001                	nop
80006c10:	40b2                	lw	ra,12(sp)
80006c12:	0141                	add	sp,sp,16
80006c14:	8082                	ret

Disassembly of section .text.spi_rbyte:

80006c16 <spi_rbyte>:

static uint8_t spi_rbyte(void)
{
80006c16:	1141                	add	sp,sp,-16
80006c18:	c606                	sw	ra,12(sp)
    /* set mode is readonly. and set the transfer len is 1*/
    PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_TRANSMODE_MASK) | SPI_TRANSCTRL_TRANSMODE_SET(spi_trans_read_only));
80006c1a:	f00347b7          	lui	a5,0xf0034
80006c1e:	5398                	lw	a4,32(a5)
80006c20:	f10007b7          	lui	a5,0xf1000
80006c24:	17fd                	add	a5,a5,-1 # f0ffffff <__AHB_SRAM_segment_end__+0xcf7fff>
80006c26:	00f776b3          	and	a3,a4,a5
80006c2a:	f00347b7          	lui	a5,0xf0034
80006c2e:	02000737          	lui	a4,0x2000
80006c32:	8f55                	or	a4,a4,a3
80006c34:	d398                	sw	a4,32(a5)
    PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_RDTRANCNT_MASK) | SPI_TRANSCTRL_RDTRANCNT_SET(0));
80006c36:	f00347b7          	lui	a5,0xf0034
80006c3a:	5398                	lw	a4,32(a5)
80006c3c:	f00347b7          	lui	a5,0xf0034
80006c40:	e0077713          	and	a4,a4,-512
80006c44:	d398                	sw	a4,32(a5)
#if defined(SPI_SOC_HAS_NEW_TRANS_COUNT) && (SPI_SOC_HAS_NEW_TRANS_COUNT == 1)
    PORT_SPI_BASE->RD_TRANS_CNT = 0;
#endif
    /* reset the fifo*/
    PORT_SPI_BASE->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
80006c46:	f00347b7          	lui	a5,0xf0034
80006c4a:	5b98                	lw	a4,48(a5)
80006c4c:	f00347b7          	lui	a5,0xf0034
80006c50:	00776713          	or	a4,a4,7
80006c54:	db98                	sw	a4,48(a5)
    /* start tranfer */
    actual_cs_sel();
80006c56:	3f41                	jal	80006be6 <actual_cs_sel>
    PORT_SPI_BASE->CMD = 0xff;
80006c58:	f00347b7          	lui	a5,0xf0034
80006c5c:	0ff00713          	li	a4,255
80006c60:	d3d8                	sw	a4,36(a5)
    /* read fifo one byte*/
    while (spi_is_active(PORT_SPI_BASE));
80006c62:	0001                	nop

80006c64 <.L43>:
80006c64:	f0034537          	lui	a0,0xf0034
80006c68:	3369                	jal	800069f2 <spi_is_active>
80006c6a:	87aa                	mv	a5,a0
80006c6c:	ffe5                	bnez	a5,80006c64 <.L43>
    return PORT_SPI_BASE->DATA;
80006c6e:	f00347b7          	lui	a5,0xf0034
80006c72:	57dc                	lw	a5,44(a5)
80006c74:	0ff7f793          	zext.b	a5,a5
}
80006c78:	853e                	mv	a0,a5
80006c7a:	40b2                	lw	ra,12(sp)
80006c7c:	0141                	add	sp,sp,16
80006c7e:	8082                	ret

Disassembly of section .text.spi_wbyte:

80006c80 <spi_wbyte>:

static void spi_wbyte(uint8_t wb)
{
80006c80:	1101                	add	sp,sp,-32
80006c82:	ce06                	sw	ra,28(sp)
80006c84:	87aa                	mv	a5,a0
80006c86:	00f107a3          	sb	a5,15(sp)
    /* set mode is readonly. and set the transfer len is 1*/
    PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_TRANSMODE_MASK) | SPI_TRANSCTRL_TRANSMODE_SET(spi_trans_write_only));
80006c8a:	f00347b7          	lui	a5,0xf0034
80006c8e:	5398                	lw	a4,32(a5)
80006c90:	f10007b7          	lui	a5,0xf1000
80006c94:	17fd                	add	a5,a5,-1 # f0ffffff <__AHB_SRAM_segment_end__+0xcf7fff>
80006c96:	00f776b3          	and	a3,a4,a5
80006c9a:	f00347b7          	lui	a5,0xf0034
80006c9e:	01000737          	lui	a4,0x1000
80006ca2:	8f55                	or	a4,a4,a3
80006ca4:	d398                	sw	a4,32(a5)
    PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_WRTRANCNT_MASK) | SPI_TRANSCTRL_WRTRANCNT_SET(0));
80006ca6:	f00347b7          	lui	a5,0xf0034
80006caa:	5394                	lw	a3,32(a5)
80006cac:	f00347b7          	lui	a5,0xf0034
80006cb0:	ffe01737          	lui	a4,0xffe01
80006cb4:	177d                	add	a4,a4,-1 # ffe00fff <__APB_SRAM_segment_end__+0xbd0efff>
80006cb6:	8f75                	and	a4,a4,a3
80006cb8:	d398                	sw	a4,32(a5)
#if defined(SPI_SOC_HAS_NEW_TRANS_COUNT) && (SPI_SOC_HAS_NEW_TRANS_COUNT == 1)
    PORT_SPI_BASE->WR_TRANS_CNT = 0;
#endif
    /* reset the fifo*/
    PORT_SPI_BASE->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
80006cba:	f00347b7          	lui	a5,0xf0034
80006cbe:	5b98                	lw	a4,48(a5)
80006cc0:	f00347b7          	lui	a5,0xf0034
80006cc4:	00776713          	or	a4,a4,7
80006cc8:	db98                	sw	a4,48(a5)
    /* write one byte for fifo*/
    
    /* start tranfer */
    actual_cs_sel();
80006cca:	3f31                	jal	80006be6 <actual_cs_sel>
    PORT_SPI_BASE->CMD = 0xff;
80006ccc:	f00347b7          	lui	a5,0xf0034
80006cd0:	0ff00713          	li	a4,255
80006cd4:	d3d8                	sw	a4,36(a5)
    PORT_SPI_BASE->DATA = wb;
80006cd6:	f00347b7          	lui	a5,0xf0034
80006cda:	00f14703          	lbu	a4,15(sp)
80006cde:	d7d8                	sw	a4,44(a5)
    while (spi_is_active(PORT_SPI_BASE));
80006ce0:	0001                	nop

80006ce2 <.L46>:
80006ce2:	f0034537          	lui	a0,0xf0034
80006ce6:	3331                	jal	800069f2 <spi_is_active>
80006ce8:	87aa                	mv	a5,a0
80006cea:	ffe5                	bnez	a5,80006ce2 <.L46>
}
80006cec:	0001                	nop
80006cee:	0001                	nop
80006cf0:	40f2                	lw	ra,28(sp)
80006cf2:	6105                	add	sp,sp,32
80006cf4:	8082                	ret

Disassembly of section .text.spi_rbusrt:

80006cf6 <spi_rbusrt>:

static void spi_rbusrt(uint8_t* pBuf, uint16_t len)
{
80006cf6:	715d                	add	sp,sp,-80
80006cf8:	c686                	sw	ra,76(sp)
80006cfa:	c62a                	sw	a0,12(sp)
80006cfc:	87ae                	mv	a5,a1
80006cfe:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80006d02:	d802                	sw	zero,48(sp)
    uint32_t i = 0;
80006d04:	de02                	sw	zero,60(sp)
    uint32_t aligned_start;
    uint32_t aligned_end;
    uint32_t aligned_size;
    uint16_t remaining_len = len;
80006d06:	00a15783          	lhu	a5,10(sp)
80006d0a:	02f11d23          	sh	a5,58(sp)
    uint16_t read_size = 0;
80006d0e:	02011723          	sh	zero,46(sp)
    uint32_t temp;
    uint8_t *dst_8 = (uint8_t *) pBuf;
80006d12:	47b2                	lw	a5,12(sp)
80006d14:	da3e                	sw	a5,52(sp)
    if (len <= SPI_SOC_FIFO_DEPTH) {
80006d16:	00a15703          	lhu	a4,10(sp)
80006d1a:	4791                	li	a5,4
80006d1c:	12e7e663          	bltu	a5,a4,80006e48 <.L53>
        /* set mode is readonly. and set the transfer len is 1*/
        PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_RDTRANCNT_MASK) | SPI_TRANSCTRL_RDTRANCNT_SET(len - 1));
80006d20:	f00347b7          	lui	a5,0xf0034
80006d24:	539c                	lw	a5,32(a5)
80006d26:	e007f693          	and	a3,a5,-512
80006d2a:	00a15783          	lhu	a5,10(sp)
80006d2e:	17fd                	add	a5,a5,-1 # f0033fff <__XPI0_segment_end__+0x6f833fff>
80006d30:	1ff7f713          	and	a4,a5,511
80006d34:	f00347b7          	lui	a5,0xf0034
80006d38:	8f55                	or	a4,a4,a3
80006d3a:	d398                	sw	a4,32(a5)
        PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_TRANSMODE_MASK) | SPI_TRANSCTRL_TRANSMODE_SET(spi_trans_read_only));
80006d3c:	f00347b7          	lui	a5,0xf0034
80006d40:	5398                	lw	a4,32(a5)
80006d42:	f10007b7          	lui	a5,0xf1000
80006d46:	17fd                	add	a5,a5,-1 # f0ffffff <__AHB_SRAM_segment_end__+0xcf7fff>
80006d48:	00f776b3          	and	a3,a4,a5
80006d4c:	f00347b7          	lui	a5,0xf0034
80006d50:	02000737          	lui	a4,0x2000
80006d54:	8f55                	or	a4,a4,a3
80006d56:	d398                	sw	a4,32(a5)
#if defined(SPI_SOC_HAS_NEW_TRANS_COUNT) && (SPI_SOC_HAS_NEW_TRANS_COUNT == 1)
        PORT_SPI_BASE->RD_TRANS_CNT = len - 1;
#endif
        /* reset the fifo*/
        PORT_SPI_BASE->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
80006d58:	f00347b7          	lui	a5,0xf0034
80006d5c:	5b98                	lw	a4,48(a5)
80006d5e:	f00347b7          	lui	a5,0xf0034
80006d62:	00776713          	or	a4,a4,7
80006d66:	db98                	sw	a4,48(a5)
        /* start tranfer */
        actual_cs_sel();
80006d68:	3dbd                	jal	80006be6 <actual_cs_sel>
        PORT_SPI_BASE->CMD = 0xff;
80006d6a:	f00347b7          	lui	a5,0xf0034
80006d6e:	0ff00713          	li	a4,255
80006d72:	d3d8                	sw	a4,36(a5)
        while (spi_is_active(PORT_SPI_BASE));
80006d74:	0001                	nop

80006d76 <.L49>:
80006d76:	f0034537          	lui	a0,0xf0034
80006d7a:	39a5                	jal	800069f2 <spi_is_active>
80006d7c:	87aa                	mv	a5,a0
80006d7e:	ffe5                	bnez	a5,80006d76 <.L49>
        for (i = 0; i < len;) {
80006d80:	de02                	sw	zero,60(sp)
80006d82:	a02d                	j	80006dac <.L50>

80006d84 <.L51>:
            if(spi_get_rx_fifo_valid_data_size(PORT_SPI_BASE) != 0) {
80006d84:	f0034537          	lui	a0,0xf0034
80006d88:	3151                	jal	80006a0c <spi_get_rx_fifo_valid_data_size>
80006d8a:	87aa                	mv	a5,a0
80006d8c:	c385                	beqz	a5,80006dac <.L50>
                temp = PORT_SPI_BASE->DATA;
80006d8e:	f00347b7          	lui	a5,0xf0034
80006d92:	57dc                	lw	a5,44(a5)
80006d94:	ce3e                	sw	a5,28(sp)
                pBuf[i] = temp;
80006d96:	4732                	lw	a4,12(sp)
80006d98:	57f2                	lw	a5,60(sp)
80006d9a:	97ba                	add	a5,a5,a4
80006d9c:	4772                	lw	a4,28(sp)
80006d9e:	0ff77713          	zext.b	a4,a4
80006da2:	00e78023          	sb	a4,0(a5) # f0034000 <__XPI0_segment_end__+0x6f834000>
                i++;
80006da6:	57f2                	lw	a5,60(sp)
80006da8:	0785                	add	a5,a5,1
80006daa:	de3e                	sw	a5,60(sp)

80006dac <.L50>:
        for (i = 0; i < len;) {
80006dac:	00a15783          	lhu	a5,10(sp)
80006db0:	5772                	lw	a4,60(sp)
80006db2:	fcf769e3          	bltu	a4,a5,80006d84 <.L51>
            }
            remaining_len -= read_size;
            dst_8 += read_size;
        }
    }
}
80006db6:	a869                	j	80006e50 <.L60>

80006db8 <.L59>:
            read_size = MIN(remaining_len, SPI_SOC_TRANSFER_COUNT_MAX);
80006db8:	03a15783          	lhu	a5,58(sp)
80006dbc:	01079693          	sll	a3,a5,0x10
80006dc0:	82c1                	srl	a3,a3,0x10
80006dc2:	20000713          	li	a4,512
80006dc6:	00d77463          	bgeu	a4,a3,80006dce <.L54>
80006dca:	20000793          	li	a5,512

80006dce <.L54>:
80006dce:	02f11723          	sh	a5,46(sp)
            hpm_spi_transfer_via_dma(PORT_SPI_BASE, PORT_SPI_DMA, dst_8,
80006dd2:	02e15783          	lhu	a5,46(sp)
80006dd6:	4705                	li	a4,1
80006dd8:	86be                	mv	a3,a5
80006dda:	5652                	lw	a2,52(sp)
80006ddc:	f00c45b7          	lui	a1,0xf00c4
80006de0:	f0034537          	lui	a0,0xf0034
80006de4:	3175                	jal	80006a90 <hpm_spi_transfer_via_dma>
            HPM_BREAK_IF(stat != status_success);
80006de6:	57c2                	lw	a5,48(sp)
80006de8:	e7a5                	bnez	a5,80006e50 <.L60>

80006dea <.LBB15>:
extern "C" {
#endif
/* get cache control register value */
__attribute__((always_inline)) static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80006dea:	7ca027f3          	csrr	a5,0x7ca
80006dee:	cc3e                	sw	a5,24(sp)
80006df0:	47e2                	lw	a5,24(sp)

80006df2 <.LBE19>:
80006df2:	0001                	nop

80006df4 <.LBE17>:
}

__attribute__((always_inline)) static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80006df4:	8b89                	and	a5,a5,2
80006df6:	00f037b3          	snez	a5,a5
80006dfa:	0ff7f793          	zext.b	a5,a5

80006dfe <.LBE15>:
            if (l1c_dc_is_enabled()) {
80006dfe:	c79d                	beqz	a5,80006e2c <.L58>
                aligned_start = HPM_L1C_CACHELINE_ALIGN_DOWN((uint32_t)dst_8);
80006e00:	57d2                	lw	a5,52(sp)
80006e02:	fc07f793          	and	a5,a5,-64
80006e06:	d43e                	sw	a5,40(sp)
                aligned_end = HPM_L1C_CACHELINE_ALIGN_UP(dst_8 + read_size);
80006e08:	02e15783          	lhu	a5,46(sp)
80006e0c:	5752                	lw	a4,52(sp)
80006e0e:	97ba                	add	a5,a5,a4
80006e10:	03f78793          	add	a5,a5,63
80006e14:	fc07f793          	and	a5,a5,-64
80006e18:	d23e                	sw	a5,36(sp)
                aligned_size = aligned_end - aligned_start;
80006e1a:	5712                	lw	a4,36(sp)
80006e1c:	57a2                	lw	a5,40(sp)
80006e1e:	40f707b3          	sub	a5,a4,a5
80006e22:	d03e                	sw	a5,32(sp)
                l1c_dc_invalidate(aligned_start, aligned_size);
80006e24:	5582                	lw	a1,32(sp)
80006e26:	5522                	lw	a0,40(sp)
80006e28:	345000ef          	jal	8000796c <l1c_dc_invalidate>

80006e2c <.L58>:
            remaining_len -= read_size;
80006e2c:	03a15783          	lhu	a5,58(sp)
80006e30:	873e                	mv	a4,a5
80006e32:	02e15783          	lhu	a5,46(sp)
80006e36:	40f707b3          	sub	a5,a4,a5
80006e3a:	02f11d23          	sh	a5,58(sp)
            dst_8 += read_size;
80006e3e:	02e15783          	lhu	a5,46(sp)
80006e42:	5752                	lw	a4,52(sp)
80006e44:	97ba                	add	a5,a5,a4
80006e46:	da3e                	sw	a5,52(sp)

80006e48 <.L53>:
        while(remaining_len > 0) {
80006e48:	03a15783          	lhu	a5,58(sp)
80006e4c:	f7b5                	bnez	a5,80006db8 <.L59>
}
80006e4e:	a009                	j	80006e50 <.L60>

80006e50 <.L60>:
80006e50:	0001                	nop
80006e52:	40b6                	lw	ra,76(sp)
80006e54:	6161                	add	sp,sp,80
80006e56:	8082                	ret

Disassembly of section .text.spi_wburst:

80006e58 <spi_wburst>:

static void spi_wburst(uint8_t* pBuf, uint16_t len)
{
80006e58:	715d                	add	sp,sp,-80
80006e5a:	c686                	sw	ra,76(sp)
80006e5c:	c62a                	sw	a0,12(sp)
80006e5e:	87ae                	mv	a5,a1
80006e60:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80006e64:	d802                	sw	zero,48(sp)
    uint32_t i = 0;
80006e66:	de02                	sw	zero,60(sp)
    uint32_t aligned_start;
    uint32_t aligned_end;
    uint32_t aligned_size;
    uint16_t remaining_len = len;
80006e68:	00a15783          	lhu	a5,10(sp)
80006e6c:	02f11d23          	sh	a5,58(sp)
    uint16_t read_size = 0;
80006e70:	02011723          	sh	zero,46(sp)
    uint8_t *dst_8 = (uint8_t *) pBuf;
80006e74:	47b2                	lw	a5,12(sp)
80006e76:	da3e                	sw	a5,52(sp)
    if (len <= SPI_SOC_FIFO_DEPTH) {
80006e78:	00a15703          	lhu	a4,10(sp)
80006e7c:	4791                	li	a5,4
80006e7e:	12e7e363          	bltu	a5,a4,80006fa4 <.L68>
        /* set mode is readonly. and set the transfer len is 1*/
        PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_TRANSMODE_MASK) | SPI_TRANSCTRL_TRANSMODE_SET(spi_trans_write_only));
80006e82:	f00347b7          	lui	a5,0xf0034
80006e86:	5398                	lw	a4,32(a5)
80006e88:	f10007b7          	lui	a5,0xf1000
80006e8c:	17fd                	add	a5,a5,-1 # f0ffffff <__AHB_SRAM_segment_end__+0xcf7fff>
80006e8e:	00f776b3          	and	a3,a4,a5
80006e92:	f00347b7          	lui	a5,0xf0034
80006e96:	01000737          	lui	a4,0x1000
80006e9a:	8f55                	or	a4,a4,a3
80006e9c:	d398                	sw	a4,32(a5)
#if defined(SPI_SOC_HAS_NEW_TRANS_COUNT) && (SPI_SOC_HAS_NEW_TRANS_COUNT == 1)
        PORT_SPI_BASE->WR_TRANS_CNT = len - 1;
#endif
        PORT_SPI_BASE->TRANSCTRL =  ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_WRTRANCNT_MASK) | SPI_TRANSCTRL_WRTRANCNT_SET(len - 1));
80006e9e:	f00347b7          	lui	a5,0xf0034
80006ea2:	5398                	lw	a4,32(a5)
80006ea4:	ffe017b7          	lui	a5,0xffe01
80006ea8:	17fd                	add	a5,a5,-1 # ffe00fff <__APB_SRAM_segment_end__+0xbd0efff>
80006eaa:	00f776b3          	and	a3,a4,a5
80006eae:	00a15783          	lhu	a5,10(sp)
80006eb2:	17fd                	add	a5,a5,-1
80006eb4:	00c79713          	sll	a4,a5,0xc
80006eb8:	001ff7b7          	lui	a5,0x1ff
80006ebc:	8f7d                	and	a4,a4,a5
80006ebe:	f00347b7          	lui	a5,0xf0034
80006ec2:	8f55                	or	a4,a4,a3
80006ec4:	d398                	sw	a4,32(a5)
        /* reset the fifo*/
        PORT_SPI_BASE->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
80006ec6:	f00347b7          	lui	a5,0xf0034
80006eca:	5b98                	lw	a4,48(a5)
80006ecc:	f00347b7          	lui	a5,0xf0034
80006ed0:	00776713          	or	a4,a4,7
80006ed4:	db98                	sw	a4,48(a5)
        actual_cs_sel();
80006ed6:	3b01                	jal	80006be6 <actual_cs_sel>
        PORT_SPI_BASE->CMD = 0xff;
80006ed8:	f00347b7          	lui	a5,0xf0034
80006edc:	0ff00713          	li	a4,255
80006ee0:	d3d8                	sw	a4,36(a5)
        for (i = 0; i < len; i++) {
80006ee2:	de02                	sw	zero,60(sp)
80006ee4:	a821                	j	80006efc <.L64>

80006ee6 <.L65>:
            PORT_SPI_BASE->DATA = pBuf[i];
80006ee6:	4732                	lw	a4,12(sp)
80006ee8:	57f2                	lw	a5,60(sp)
80006eea:	97ba                	add	a5,a5,a4
80006eec:	0007c703          	lbu	a4,0(a5) # f0034000 <__XPI0_segment_end__+0x6f834000>
80006ef0:	f00347b7          	lui	a5,0xf0034
80006ef4:	d7d8                	sw	a4,44(a5)
        for (i = 0; i < len; i++) {
80006ef6:	57f2                	lw	a5,60(sp)
80006ef8:	0785                	add	a5,a5,1 # f0034001 <__XPI0_segment_end__+0x6f834001>
80006efa:	de3e                	sw	a5,60(sp)

80006efc <.L64>:
80006efc:	00a15783          	lhu	a5,10(sp)
80006f00:	5772                	lw	a4,60(sp)
80006f02:	fef762e3          	bltu	a4,a5,80006ee6 <.L65>
        }
        /* start tranfer */
        while (spi_is_active(PORT_SPI_BASE));
80006f06:	0001                	nop

80006f08 <.L66>:
80006f08:	f0034537          	lui	a0,0xf0034
80006f0c:	34dd                	jal	800069f2 <spi_is_active>
80006f0e:	87aa                	mv	a5,a0
80006f10:	ffe5                	bnez	a5,80006f08 <.L66>
            HPM_BREAK_IF(stat != status_success);
            remaining_len -= read_size;
            dst_8 += read_size;
        }
    }
}
80006f12:	a869                	j	80006fac <.L75>

80006f14 <.L74>:
            read_size = MIN(remaining_len, SPI_SOC_TRANSFER_COUNT_MAX);
80006f14:	03a15783          	lhu	a5,58(sp)
80006f18:	01079693          	sll	a3,a5,0x10
80006f1c:	82c1                	srl	a3,a3,0x10
80006f1e:	20000713          	li	a4,512
80006f22:	00d77463          	bgeu	a4,a3,80006f2a <.L69>
80006f26:	20000793          	li	a5,512

80006f2a <.L69>:
80006f2a:	02f11723          	sh	a5,46(sp)

80006f2e <.LBB20>:
    return read_csr(CSR_MCACHE_CTL);
80006f2e:	7ca027f3          	csrr	a5,0x7ca
80006f32:	ce3e                	sw	a5,28(sp)
80006f34:	47f2                	lw	a5,28(sp)

80006f36 <.LBE24>:
80006f36:	0001                	nop

80006f38 <.LBE22>:
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80006f38:	8b89                	and	a5,a5,2
80006f3a:	00f037b3          	snez	a5,a5
80006f3e:	0ff7f793          	zext.b	a5,a5

80006f42 <.LBE20>:
            if (l1c_dc_is_enabled()) {
80006f42:	c79d                	beqz	a5,80006f70 <.L72>
                aligned_start = HPM_L1C_CACHELINE_ALIGN_DOWN((uint32_t)dst_8);
80006f44:	57d2                	lw	a5,52(sp)
80006f46:	fc07f793          	and	a5,a5,-64
80006f4a:	d43e                	sw	a5,40(sp)
                aligned_end = HPM_L1C_CACHELINE_ALIGN_UP((uint32_t)dst_8 + read_size);
80006f4c:	02e15703          	lhu	a4,46(sp)
80006f50:	57d2                	lw	a5,52(sp)
80006f52:	97ba                	add	a5,a5,a4
80006f54:	03f78793          	add	a5,a5,63
80006f58:	fc07f793          	and	a5,a5,-64
80006f5c:	d23e                	sw	a5,36(sp)
                aligned_size = aligned_end - aligned_start;
80006f5e:	5712                	lw	a4,36(sp)
80006f60:	57a2                	lw	a5,40(sp)
80006f62:	40f707b3          	sub	a5,a4,a5
80006f66:	d03e                	sw	a5,32(sp)
                l1c_dc_writeback(aligned_start, aligned_size);
80006f68:	5582                	lw	a1,32(sp)
80006f6a:	5522                	lw	a0,40(sp)
80006f6c:	25b000ef          	jal	800079c6 <l1c_dc_writeback>

80006f70 <.L72>:
            hpm_spi_transfer_via_dma(PORT_SPI_BASE, PORT_SPI_DMA, dst_8,
80006f70:	02e15783          	lhu	a5,46(sp)
80006f74:	4701                	li	a4,0
80006f76:	86be                	mv	a3,a5
80006f78:	5652                	lw	a2,52(sp)
80006f7a:	f00c45b7          	lui	a1,0xf00c4
80006f7e:	f0034537          	lui	a0,0xf0034
80006f82:	3639                	jal	80006a90 <hpm_spi_transfer_via_dma>
            HPM_BREAK_IF(stat != status_success);
80006f84:	57c2                	lw	a5,48(sp)
80006f86:	e39d                	bnez	a5,80006fac <.L75>
            remaining_len -= read_size;
80006f88:	03a15783          	lhu	a5,58(sp)
80006f8c:	873e                	mv	a4,a5
80006f8e:	02e15783          	lhu	a5,46(sp)
80006f92:	40f707b3          	sub	a5,a4,a5
80006f96:	02f11d23          	sh	a5,58(sp)
            dst_8 += read_size;
80006f9a:	02e15783          	lhu	a5,46(sp)
80006f9e:	5752                	lw	a4,52(sp)
80006fa0:	97ba                	add	a5,a5,a4
80006fa2:	da3e                	sw	a5,52(sp)

80006fa4 <.L68>:
        while(remaining_len > 0) {
80006fa4:	03a15783          	lhu	a5,58(sp)
80006fa8:	f7b5                	bnez	a5,80006f14 <.L74>
}
80006faa:	a009                	j	80006fac <.L75>

80006fac <.L75>:
80006fac:	0001                	nop
80006fae:	40b6                	lw	ra,76(sp)
80006fb0:	6161                	add	sp,sp,80
80006fb2:	8082                	ret

Disassembly of section .text.network_init:

80006fb4 <network_init>:
#define DHCP_TIM_CH       1
#define DHCP_TIM_IRQ      IRQn_GPTMR5
#define DHCP_TIM_CLK_NAME clock_gptmr5

static void network_init(void)
{
80006fb4:	1141                	add	sp,sp,-16
80006fb6:	c606                	sw	ra,12(sp)
    ctlnetwork(CN_SET_NETINFO, (void*)&g_winznet_info);
80006fb8:	0e818593          	add	a1,gp,232 # 10808e8 <g_winznet_info>
80006fbc:	4501                	li	a0,0
80006fbe:	faefe0ef          	jal	8000576c <ctlnetwork>
}
80006fc2:	0001                	nop
80006fc4:	40b2                	lw	ra,12(sp)
80006fc6:	0141                	add	sp,sp,16
80006fc8:	8082                	ret

Disassembly of section .text.my_ip_assign:

80006fca <my_ip_assign>:

static void my_ip_assign(void)
{
80006fca:	1141                	add	sp,sp,-16
80006fcc:	c606                	sw	ra,12(sp)
   getIPfromDHCP(g_winznet_info.ip);
80006fce:	0ee18513          	add	a0,gp,238 # 10808ee <g_winznet_info+0x6>
80006fd2:	699040ef          	jal	8000be6a <getIPfromDHCP>
   getGWfromDHCP(g_winznet_info.gw);
80006fd6:	0f618513          	add	a0,gp,246 # 10808f6 <g_winznet_info+0xe>
80006fda:	6d5040ef          	jal	8000beae <getGWfromDHCP>
   getSNfromDHCP(g_winznet_info.sn);
80006fde:	0f218513          	add	a0,gp,242 # 10808f2 <g_winznet_info+0xa>
80006fe2:	711040ef          	jal	8000bef2 <getSNfromDHCP>
   getDNSfromDHCP(g_winznet_info.dns);
80006fe6:	0fa18513          	add	a0,gp,250 # 10808fa <g_winznet_info+0x12>
80006fea:	74d040ef          	jal	8000bf36 <getDNSfromDHCP>
   g_winznet_info.dhcp = NETINFO_DHCP;
80006fee:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
80006ff2:	4709                	li	a4,2
80006ff4:	00e78b23          	sb	a4,22(a5)
   /* Network initialization */
   network_init();      // apply from dhcp
80006ff8:	3f75                	jal	80006fb4 <network_init>
   printf("DHCP LEASED TIME : %d Sec.\r\n", getDHCPLeasetime());
80006ffa:	781040ef          	jal	8000bf7a <getDHCPLeasetime>
80006ffe:	87aa                	mv	a5,a0
80007000:	85be                	mv	a1,a5
80007002:	800057b7          	lui	a5,0x80005
80007006:	87878513          	add	a0,a5,-1928 # 80004878 <.LC0>
8000700a:	507010ef          	jal	80008d10 <printf>
}
8000700e:	0001                	nop
80007010:	40b2                	lw	ra,12(sp)
80007012:	0141                	add	sp,sp,16
80007014:	8082                	ret

Disassembly of section .text.my_ip_conflict:

80007016 <my_ip_conflict>:

static void my_ip_conflict(void)
{
80007016:	1141                	add	sp,sp,-16
80007018:	c606                	sw	ra,12(sp)
	printf("CONFLICT IP from DHCP\r\n");
8000701a:	800057b7          	lui	a5,0x80005
8000701e:	89878513          	add	a0,a5,-1896 # 80004898 <.LC1>
80007022:	4ef010ef          	jal	80008d10 <printf>

80007026 <.L10>:
	/* halt or reset or any... */
	while(1); // this example is halt.
80007026:	a001                	j	80007026 <.L10>

Disassembly of section .text.pllctl_xtal_set_rampup_time:

80007028 <pllctl_xtal_set_rampup_time>:
 * @brief set XTAL rampup time in cycles of IRC24M
 *
 * @param[in] ptr PLLCTL base address
 */
static inline void pllctl_xtal_set_rampup_time(PLLCTL_Type *ptr, uint32_t cycles)
{
80007028:	1141                	add	sp,sp,-16
8000702a:	c62a                	sw	a0,12(sp)
8000702c:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTL_XTAL_RAMP_TIME_MASK) | PLLCTL_XTAL_RAMP_TIME_SET(cycles);
8000702e:	47b2                	lw	a5,12(sp)
80007030:	4398                	lw	a4,0(a5)
80007032:	fff007b7          	lui	a5,0xfff00
80007036:	8f7d                	and	a4,a4,a5
80007038:	46a2                	lw	a3,8(sp)
8000703a:	001007b7          	lui	a5,0x100
8000703e:	17fd                	add	a5,a5,-1 # fffff <__DLM_segment_end__+0x3ffff>
80007040:	8ff5                	and	a5,a5,a3
80007042:	8f5d                	or	a4,a4,a5
80007044:	47b2                	lw	a5,12(sp)
80007046:	c398                	sw	a4,0(a5)
}
80007048:	0001                	nop
8000704a:	0141                	add	sp,sp,16
8000704c:	8082                	ret

Disassembly of section .text.pcfg_dcdc_switch_to_dcm_mode:

8000704e <pcfg_dcdc_switch_to_dcm_mode>:
 * @brief dcdc switch to dcm mode
 *
 * @param[in] ptr base address
 */
static inline void pcfg_dcdc_switch_to_dcm_mode(PCFG_Type *ptr)
{
8000704e:	7139                	add	sp,sp,-64
80007050:	c62a                	sw	a0,12(sp)
    const uint8_t pcfc_dcdc_min_duty_cycle[] = {
80007052:	800047b7          	lui	a5,0x80004
80007056:	b4478793          	add	a5,a5,-1212 # 80003b44 <.LC0>
8000705a:	0007a883          	lw	a7,0(a5)
8000705e:	0047a803          	lw	a6,4(a5)
80007062:	4788                	lw	a0,8(a5)
80007064:	47cc                	lw	a1,12(a5)
80007066:	4b90                	lw	a2,16(a5)
80007068:	4bd4                	lw	a3,20(a5)
8000706a:	4f98                	lw	a4,24(a5)
8000706c:	4fdc                	lw	a5,28(a5)
8000706e:	ce46                	sw	a7,28(sp)
80007070:	d042                	sw	a6,32(sp)
80007072:	d22a                	sw	a0,36(sp)
80007074:	d42e                	sw	a1,40(sp)
80007076:	d632                	sw	a2,44(sp)
80007078:	d836                	sw	a3,48(sp)
8000707a:	da3a                	sw	a4,52(sp)
8000707c:	dc3e                	sw	a5,56(sp)
        0x76, 0x78, 0x78, 0x78, 0x78, 0x7A, 0x7A, 0x7A,
        0x7A, 0x7C, 0x7C, 0x7C, 0x7E, 0x7E, 0x7E, 0x7E
    };
    uint16_t voltage;

    ptr->DCDC_MODE |= 0x77000u;
8000707e:	47b2                	lw	a5,12(sp)
80007080:	4b98                	lw	a4,16(a5)
80007082:	000777b7          	lui	a5,0x77
80007086:	8f5d                	or	a4,a4,a5
80007088:	47b2                	lw	a5,12(sp)
8000708a:	cb98                	sw	a4,16(a5)
    ptr->DCDC_ADVMODE = (ptr->DCDC_ADVMODE & ~0x73F0067u) | 0x4120067u;
8000708c:	47b2                	lw	a5,12(sp)
8000708e:	5398                	lw	a4,32(a5)
80007090:	f8c107b7          	lui	a5,0xf8c10
80007094:	f9878793          	add	a5,a5,-104 # f8c0ff98 <__APB_SRAM_segment_end__+0x4b1df98>
80007098:	8f7d                	and	a4,a4,a5
8000709a:	041207b7          	lui	a5,0x4120
8000709e:	06778793          	add	a5,a5,103 # 4120067 <__SHARE_RAM_segment_end__+0x2fa0067>
800070a2:	8f5d                	or	a4,a4,a5
800070a4:	47b2                	lw	a5,12(sp)
800070a6:	d398                	sw	a4,32(a5)
    ptr->DCDC_PROT &= ~PCFG_DCDC_PROT_SHORT_CURRENT_MASK;
800070a8:	47b2                	lw	a5,12(sp)
800070aa:	4f9c                	lw	a5,24(a5)
800070ac:	fef7f713          	and	a4,a5,-17
800070b0:	47b2                	lw	a5,12(sp)
800070b2:	cf98                	sw	a4,24(a5)
    ptr->DCDC_PROT |= PCFG_DCDC_PROT_DISABLE_SHORT_MASK;
800070b4:	47b2                	lw	a5,12(sp)
800070b6:	4f9c                	lw	a5,24(a5)
800070b8:	0807e713          	or	a4,a5,128
800070bc:	47b2                	lw	a5,12(sp)
800070be:	cf98                	sw	a4,24(a5)
    ptr->DCDC_MISC = 0x100000u;
800070c0:	47b2                	lw	a5,12(sp)
800070c2:	00100737          	lui	a4,0x100
800070c6:	d798                	sw	a4,40(a5)
    voltage = PCFG_DCDC_MODE_VOLT_GET(ptr->DCDC_MODE);
800070c8:	47b2                	lw	a5,12(sp)
800070ca:	4b9c                	lw	a5,16(a5)
800070cc:	01079713          	sll	a4,a5,0x10
800070d0:	8341                	srl	a4,a4,0x10
800070d2:	6785                	lui	a5,0x1
800070d4:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
800070d6:	8ff9                	and	a5,a5,a4
800070d8:	02f11f23          	sh	a5,62(sp)
    voltage = (voltage - 600) / 25;
800070dc:	03e15783          	lhu	a5,62(sp)
800070e0:	da878713          	add	a4,a5,-600
800070e4:	47e5                	li	a5,25
800070e6:	02f747b3          	div	a5,a4,a5
800070ea:	02f11f23          	sh	a5,62(sp)
    ptr->DCDC_ADVPARAM = (ptr->DCDC_ADVPARAM & ~PCFG_DCDC_ADVPARAM_MIN_DUT_MASK) | PCFG_DCDC_ADVPARAM_MIN_DUT_SET(pcfc_dcdc_min_duty_cycle[voltage]);
800070ee:	47b2                	lw	a5,12(sp)
800070f0:	53d8                	lw	a4,36(a5)
800070f2:	77e1                	lui	a5,0xffff8
800070f4:	0ff78793          	add	a5,a5,255 # ffff80ff <__APB_SRAM_segment_end__+0xbf060ff>
800070f8:	8f7d                	and	a4,a4,a5
800070fa:	03e15783          	lhu	a5,62(sp)
800070fe:	04078793          	add	a5,a5,64
80007102:	978a                	add	a5,a5,sp
80007104:	fdc7c783          	lbu	a5,-36(a5)
80007108:	00879693          	sll	a3,a5,0x8
8000710c:	67a1                	lui	a5,0x8
8000710e:	f0078793          	add	a5,a5,-256 # 7f00 <__HEAPSIZE__+0x3f00>
80007112:	8ff5                	and	a5,a5,a3
80007114:	8f5d                	or	a4,a4,a5
80007116:	47b2                	lw	a5,12(sp)
80007118:	d3d8                	sw	a4,36(a5)
}
8000711a:	0001                	nop
8000711c:	6121                	add	sp,sp,64
8000711e:	8082                	ret

Disassembly of section .text.board_init_pmp:

80007120 <board_init_pmp>:
{
    clock_cpu_delay_us(us);
}

void board_init_pmp(void)
{
80007120:	712d                	add	sp,sp,-288
80007122:	10112e23          	sw	ra,284(sp)
    uint32_t start_addr;
    uint32_t end_addr;
    uint32_t length;
    pmp_entry_t pmp_entry[16];
    uint8_t index = 0;
80007126:	100107a3          	sb	zero,271(sp)

    /* Init noncachable memory */
    extern uint32_t __noncacheable_start__[];
    extern uint32_t __noncacheable_end__[];
    start_addr = (uint32_t) __noncacheable_start__;
8000712a:	011007b7          	lui	a5,0x1100
8000712e:	00078793          	mv	a5,a5
80007132:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t) __noncacheable_end__;
80007136:	011407b7          	lui	a5,0x1140
8000713a:	00078793          	mv	a5,a5
8000713e:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
80007142:	10412703          	lw	a4,260(sp)
80007146:	10812783          	lw	a5,264(sp)
8000714a:	40f707b3          	sub	a5,a4,a5
8000714e:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
80007152:	10012783          	lw	a5,256(sp)
80007156:	c7e1                	beqz	a5,8000721e <.L20>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
80007158:	10012783          	lw	a5,256(sp)
8000715c:	fff78713          	add	a4,a5,-1 # 113ffff <__AXI_SRAM_segment_end__+0x3ffff>
80007160:	10012783          	lw	a5,256(sp)
80007164:	8ff9                	and	a5,a5,a4
80007166:	cf89                	beqz	a5,80007180 <.L21>
80007168:	0c200613          	li	a2,194
8000716c:	800047b7          	lui	a5,0x80004
80007170:	c5878593          	add	a1,a5,-936 # 80003c58 <.LC15>
80007174:	800047b7          	lui	a5,0x80004
80007178:	cb878513          	add	a0,a5,-840 # 80003cb8 <.LC16>
8000717c:	7e5050ef          	jal	8000d160 <__SEGGER_RTL_X_assert>

80007180 <.L21>:
        assert((start_addr & (length - 1U)) == 0U);
80007180:	10012783          	lw	a5,256(sp)
80007184:	fff78713          	add	a4,a5,-1
80007188:	10812783          	lw	a5,264(sp)
8000718c:	8ff9                	and	a5,a5,a4
8000718e:	cf89                	beqz	a5,800071a8 <.L22>
80007190:	0c300613          	li	a2,195
80007194:	800047b7          	lui	a5,0x80004
80007198:	c5878593          	add	a1,a5,-936 # 80003c58 <.LC15>
8000719c:	800047b7          	lui	a5,0x80004
800071a0:	cd878513          	add	a0,a5,-808 # 80003cd8 <.LC17>
800071a4:	7bd050ef          	jal	8000d160 <__SEGGER_RTL_X_assert>

800071a8 <.L22>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
800071a8:	10812783          	lw	a5,264(sp)
800071ac:	0027d693          	srl	a3,a5,0x2
800071b0:	10012783          	lw	a5,256(sp)
800071b4:	17fd                	add	a5,a5,-1
800071b6:	0037d713          	srl	a4,a5,0x3
800071ba:	10f14783          	lbu	a5,271(sp)
800071be:	8f55                	or	a4,a4,a3
800071c0:	0792                	sll	a5,a5,0x4
800071c2:	11078793          	add	a5,a5,272
800071c6:	978a                	add	a5,a5,sp
800071c8:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
800071cc:	10f14783          	lbu	a5,271(sp)
800071d0:	0792                	sll	a5,a5,0x4
800071d2:	11078793          	add	a5,a5,272
800071d6:	978a                	add	a5,a5,sp
800071d8:	477d                	li	a4,31
800071da:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
800071de:	10812783          	lw	a5,264(sp)
800071e2:	0027d693          	srl	a3,a5,0x2
800071e6:	10012783          	lw	a5,256(sp)
800071ea:	17fd                	add	a5,a5,-1
800071ec:	0037d713          	srl	a4,a5,0x3
800071f0:	10f14783          	lbu	a5,271(sp)
800071f4:	8f55                	or	a4,a4,a3
800071f6:	0792                	sll	a5,a5,0x4
800071f8:	11078793          	add	a5,a5,272
800071fc:	978a                	add	a5,a5,sp
800071fe:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
80007202:	10f14783          	lbu	a5,271(sp)
80007206:	0792                	sll	a5,a5,0x4
80007208:	11078793          	add	a5,a5,272
8000720c:	978a                	add	a5,a5,sp
8000720e:	473d                	li	a4,15
80007210:	eee78c23          	sb	a4,-264(a5)
        index++;
80007214:	10f14783          	lbu	a5,271(sp)
80007218:	0785                	add	a5,a5,1
8000721a:	10f107a3          	sb	a5,271(sp)

8000721e <.L20>:
    }

    /* Init share memory */
    extern uint32_t __share_mem_start__[];
    extern uint32_t __share_mem_end__[];
    start_addr = (uint32_t)__share_mem_start__;
8000721e:	0117c7b7          	lui	a5,0x117c
80007222:	00078793          	mv	a5,a5
80007226:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t)__share_mem_end__;
8000722a:	011807b7          	lui	a5,0x1180
8000722e:	00078793          	mv	a5,a5
80007232:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
80007236:	10412703          	lw	a4,260(sp)
8000723a:	10812783          	lw	a5,264(sp)
8000723e:	40f707b3          	sub	a5,a4,a5
80007242:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
80007246:	10012783          	lw	a5,256(sp)
8000724a:	c7e1                	beqz	a5,80007312 <.L23>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
8000724c:	10012783          	lw	a5,256(sp)
80007250:	fff78713          	add	a4,a5,-1 # 117ffff <__SHARE_RAM_segment_start__+0x3fff>
80007254:	10012783          	lw	a5,256(sp)
80007258:	8ff9                	and	a5,a5,a4
8000725a:	cf89                	beqz	a5,80007274 <.L24>
8000725c:	0d300613          	li	a2,211
80007260:	800047b7          	lui	a5,0x80004
80007264:	c5878593          	add	a1,a5,-936 # 80003c58 <.LC15>
80007268:	800047b7          	lui	a5,0x80004
8000726c:	cb878513          	add	a0,a5,-840 # 80003cb8 <.LC16>
80007270:	6f1050ef          	jal	8000d160 <__SEGGER_RTL_X_assert>

80007274 <.L24>:
        assert((start_addr & (length - 1U)) == 0U);
80007274:	10012783          	lw	a5,256(sp)
80007278:	fff78713          	add	a4,a5,-1
8000727c:	10812783          	lw	a5,264(sp)
80007280:	8ff9                	and	a5,a5,a4
80007282:	cf89                	beqz	a5,8000729c <.L25>
80007284:	0d400613          	li	a2,212
80007288:	800047b7          	lui	a5,0x80004
8000728c:	c5878593          	add	a1,a5,-936 # 80003c58 <.LC15>
80007290:	800047b7          	lui	a5,0x80004
80007294:	cd878513          	add	a0,a5,-808 # 80003cd8 <.LC17>
80007298:	6c9050ef          	jal	8000d160 <__SEGGER_RTL_X_assert>

8000729c <.L25>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
8000729c:	10812783          	lw	a5,264(sp)
800072a0:	0027d693          	srl	a3,a5,0x2
800072a4:	10012783          	lw	a5,256(sp)
800072a8:	17fd                	add	a5,a5,-1
800072aa:	0037d713          	srl	a4,a5,0x3
800072ae:	10f14783          	lbu	a5,271(sp)
800072b2:	8f55                	or	a4,a4,a3
800072b4:	0792                	sll	a5,a5,0x4
800072b6:	11078793          	add	a5,a5,272
800072ba:	978a                	add	a5,a5,sp
800072bc:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
800072c0:	10f14783          	lbu	a5,271(sp)
800072c4:	0792                	sll	a5,a5,0x4
800072c6:	11078793          	add	a5,a5,272
800072ca:	978a                	add	a5,a5,sp
800072cc:	477d                	li	a4,31
800072ce:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
800072d2:	10812783          	lw	a5,264(sp)
800072d6:	0027d693          	srl	a3,a5,0x2
800072da:	10012783          	lw	a5,256(sp)
800072de:	17fd                	add	a5,a5,-1
800072e0:	0037d713          	srl	a4,a5,0x3
800072e4:	10f14783          	lbu	a5,271(sp)
800072e8:	8f55                	or	a4,a4,a3
800072ea:	0792                	sll	a5,a5,0x4
800072ec:	11078793          	add	a5,a5,272
800072f0:	978a                	add	a5,a5,sp
800072f2:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
800072f6:	10f14783          	lbu	a5,271(sp)
800072fa:	0792                	sll	a5,a5,0x4
800072fc:	11078793          	add	a5,a5,272
80007300:	978a                	add	a5,a5,sp
80007302:	473d                	li	a4,15
80007304:	eee78c23          	sb	a4,-264(a5)
        index++;
80007308:	10f14783          	lbu	a5,271(sp)
8000730c:	0785                	add	a5,a5,1
8000730e:	10f107a3          	sb	a5,271(sp)

80007312 <.L23>:
    }

    pmp_config(&pmp_entry[0], index);
80007312:	10f14703          	lbu	a4,271(sp)
80007316:	878a                	mv	a5,sp
80007318:	85ba                	mv	a1,a4
8000731a:	853e                	mv	a0,a5
8000731c:	83efd0ef          	jal	8000435a <pmp_config>
}
80007320:	0001                	nop
80007322:	11c12083          	lw	ra,284(sp)
80007326:	6115                	add	sp,sp,288
80007328:	8082                	ret

Disassembly of section .text.board_init_clock:

8000732a <board_init_clock>:

void board_init_clock(void)
{
8000732a:	1101                	add	sp,sp,-32
8000732c:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
8000732e:	4501                	li	a0,0
80007330:	24d9                	jal	800075f6 <clock_get_frequency>
80007332:	c62a                	sw	a0,12(sp)
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
80007334:	4732                	lw	a4,12(sp)
80007336:	016e37b7          	lui	a5,0x16e3
8000733a:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000733e:	00f71e63          	bne	a4,a5,8000735a <.L27>
        /* Configure the External OSC ramp-up time: ~9ms */
        pllctl_xtal_set_rampup_time(HPM_PLLCTL, 32UL * 1000UL * 9U);
80007342:	000467b7          	lui	a5,0x46
80007346:	50078593          	add	a1,a5,1280 # 46500 <__DLM_segment_size__+0x6500>
8000734a:	f4100537          	lui	a0,0xf4100
8000734e:	39e9                	jal	80007028 <pllctl_xtal_set_rampup_time>

        /* Select clock setting preset1 */
        sysctl_clock_set_preset(HPM_SYSCTL, sysctl_preset_1);
80007350:	4589                	li	a1,2
80007352:	f4000537          	lui	a0,0xf4000
80007356:	5e8050ef          	jal	8000c93e <sysctl_clock_set_preset>

8000735a <.L27>:
    }

    /* Add clocks to group 0 */
    clock_add_to_group(clock_cpu0, 0);
8000735a:	4581                	li	a1,0
8000735c:	4501                	li	a0,0
8000735e:	216d                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
80007360:	4581                	li	a1,0
80007362:	010807b7          	lui	a5,0x1080
80007366:	00178513          	add	a0,a5,1 # 1080001 <WIZCHIP+0x1>
8000736a:	2979                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_axi0, 0);
8000736c:	4581                	li	a1,0
8000736e:	010107b7          	lui	a5,0x1010
80007372:	00478513          	add	a0,a5,4 # 1010004 <_extram_size+0x10004>
80007376:	2949                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_axi1, 0);
80007378:	4581                	li	a1,0
8000737a:	010207b7          	lui	a5,0x1020
8000737e:	00578513          	add	a0,a5,5 # 1020005 <_extram_size+0x20005>
80007382:	2159                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_axi2, 0);
80007384:	4581                	li	a1,0
80007386:	010307b7          	lui	a5,0x1030
8000738a:	00678513          	add	a0,a5,6 # 1030006 <_extram_size+0x30006>
8000738e:	29ad                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_ahb, 0);
80007390:	4581                	li	a1,0
80007392:	010007b7          	lui	a5,0x1000
80007396:	00778513          	add	a0,a5,7 # 1000007 <_extram_size+0x7>
8000739a:	21bd                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_xdma, 0);
8000739c:	4581                	li	a1,0
8000739e:	011207b7          	lui	a5,0x1120
800073a2:	60178513          	add	a0,a5,1537 # 1120601 <__AXI_SRAM_segment_end__+0x20601>
800073a6:	218d                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
800073a8:	4581                	li	a1,0
800073aa:	011107b7          	lui	a5,0x1110
800073ae:	50478513          	add	a0,a5,1284 # 1110504 <__AXI_SRAM_segment_end__+0x10504>
800073b2:	2999                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
800073b4:	4581                	li	a1,0
800073b6:	010c07b7          	lui	a5,0x10c0
800073ba:	00978513          	add	a0,a5,9 # 10c0009 <__AXI_SRAM_segment_used_end__+0x3f679>
800073be:	21a9                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_xpi1, 0);
800073c0:	4581                	li	a1,0
800073c2:	010d07b7          	lui	a5,0x10d0
800073c6:	00a78513          	add	a0,a5,10 # 10d000a <__AXI_SRAM_segment_used_end__+0x4f67a>
800073ca:	293d                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_ram0, 0);
800073cc:	4581                	li	a1,0
800073ce:	010a07b7          	lui	a5,0x10a0
800073d2:	60378513          	add	a0,a5,1539 # 10a0603 <__AXI_SRAM_segment_used_end__+0x1fc73>
800073d6:	290d                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_ram1, 0);
800073d8:	4581                	li	a1,0
800073da:	010b07b7          	lui	a5,0x10b0
800073de:	60478513          	add	a0,a5,1540 # 10b0604 <__AXI_SRAM_segment_used_end__+0x2fc74>
800073e2:	211d                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
800073e4:	4581                	li	a1,0
800073e6:	010617b7          	lui	a5,0x1061
800073ea:	90078513          	add	a0,a5,-1792 # 1060900 <_extram_size+0x60900>
800073ee:	2929                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_lmm1, 0);
800073f0:	4581                	li	a1,0
800073f2:	010717b7          	lui	a5,0x1071
800073f6:	a0078513          	add	a0,a5,-1536 # 1070a00 <_extram_size+0x70a00>
800073fa:	2139                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
800073fc:	4581                	li	a1,0
800073fe:	011307b7          	lui	a5,0x1130
80007402:	50178513          	add	a0,a5,1281 # 1130501 <__AXI_SRAM_segment_end__+0x30501>
80007406:	2109                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_mot0, 0);
80007408:	4581                	li	a1,0
8000740a:	014b07b7          	lui	a5,0x14b0
8000740e:	50678513          	add	a0,a5,1286 # 14b0506 <__SHARE_RAM_segment_end__+0x330506>
80007412:	2edd                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_mot1, 0);
80007414:	4581                	li	a1,0
80007416:	014c07b7          	lui	a5,0x14c0
8000741a:	50778513          	add	a0,a5,1287 # 14c0507 <__SHARE_RAM_segment_end__+0x340507>
8000741e:	26ed                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_mot2, 0);
80007420:	4581                	li	a1,0
80007422:	014d07b7          	lui	a5,0x14d0
80007426:	50878513          	add	a0,a5,1288 # 14d0508 <__SHARE_RAM_segment_end__+0x350508>
8000742a:	2ef9                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_mot3, 0);
8000742c:	4581                	li	a1,0
8000742e:	014e07b7          	lui	a5,0x14e0
80007432:	50978513          	add	a0,a5,1289 # 14e0509 <__SHARE_RAM_segment_end__+0x360509>
80007436:	2ec9                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_synt, 0);
80007438:	4581                	li	a1,0
8000743a:	014a07b7          	lui	a5,0x14a0
8000743e:	50c78513          	add	a0,a5,1292 # 14a050c <__SHARE_RAM_segment_end__+0x32050c>
80007442:	26d9                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
80007444:	4581                	li	a1,0
80007446:	013e07b7          	lui	a5,0x13e0
8000744a:	02f78513          	add	a0,a5,47 # 13e002f <__SHARE_RAM_segment_end__+0x26002f>
8000744e:	2e6d                	jal	80007808 <clock_add_to_group>
    /* Connect Group0 to CPU0 */
    clock_connect_group_to_cpu(0, 0);
80007450:	4581                	li	a1,0
80007452:	4501                	li	a0,0
80007454:	1df050ef          	jal	8000ce32 <clock_connect_group_to_cpu>

    /* Add clocks to Group1 */
    clock_add_to_group(clock_cpu1, 1);
80007458:	4585                	li	a1,1
8000745a:	000807b7          	lui	a5,0x80
8000745e:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
80007462:	265d                	jal	80007808 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr1, 1);
80007464:	4585                	li	a1,1
80007466:	010907b7          	lui	a5,0x1090
8000746a:	00378513          	add	a0,a5,3 # 1090003 <__AXI_SRAM_segment_used_end__+0xf673>
8000746e:	2e69                	jal	80007808 <clock_add_to_group>
    /* Connect Group1 to CPU1 */
    clock_connect_group_to_cpu(1, 1);
80007470:	4585                	li	a1,1
80007472:	4505                	li	a0,1
80007474:	1bf050ef          	jal	8000ce32 <clock_connect_group_to_cpu>

    /* Bump up DCDC voltage to 1200mv */
    pcfg_dcdc_set_voltage(HPM_PCFG, 1200);
80007478:	4b000593          	li	a1,1200
8000747c:	f40c4537          	lui	a0,0xf40c4
80007480:	46d010ef          	jal	800090ec <pcfg_dcdc_set_voltage>
    pcfg_dcdc_switch_to_dcm_mode(HPM_PCFG);
80007484:	f40c4537          	lui	a0,0xf40c4
80007488:	36d9                	jal	8000704e <pcfg_dcdc_switch_to_dcm_mode>

    if (status_success != pllctl_init_int_pll_with_freq(HPM_PLLCTL, 0, BOARD_CPU_FREQ)) {
8000748a:	269fb7b7          	lui	a5,0x269fb
8000748e:	20078613          	add	a2,a5,512 # 269fb200 <__SHARE_RAM_segment_end__+0x2587b200>
80007492:	4581                	li	a1,0
80007494:	f4100537          	lui	a0,0xf4100
80007498:	4e9010ef          	jal	80009180 <pllctl_init_int_pll_with_freq>
8000749c:	87aa                	mv	a5,a0
8000749e:	cf81                	beqz	a5,800074b6 <.L28>
        printf("Failed to set pll0_clk0 to %ldHz\n", BOARD_CPU_FREQ);
800074a0:	269fb7b7          	lui	a5,0x269fb
800074a4:	20078593          	add	a1,a5,512 # 269fb200 <__SHARE_RAM_segment_end__+0x2587b200>
800074a8:	800047b7          	lui	a5,0x80004
800074ac:	cfc78513          	add	a0,a5,-772 # 80003cfc <.LC18>
800074b0:	061010ef          	jal	80008d10 <printf>

800074b4 <.L29>:
        while (1) {
800074b4:	a001                	j	800074b4 <.L29>

800074b6 <.L28>:
        }
    }

    clock_set_source_divider(clock_cpu0, clk_src_pll0_clk0, 1);
800074b6:	4605                	li	a2,1
800074b8:	4585                	li	a1,1
800074ba:	4501                	li	a0,0
800074bc:	2c85                	jal	8000772c <clock_set_source_divider>
    clock_set_source_divider(clock_cpu1, clk_src_pll0_clk0, 1);
800074be:	4605                	li	a2,1
800074c0:	4585                	li	a1,1
800074c2:	000807b7          	lui	a5,0x80
800074c6:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
800074ca:	248d                	jal	8000772c <clock_set_source_divider>
    clock_update_core_clock();
800074cc:	2121                	jal	800078d4 <clock_update_core_clock>

    clock_set_source_divider(clock_ahb, clk_src_pll1_clk1, 2); /*200m hz*/
800074ce:	4609                	li	a2,2
800074d0:	458d                	li	a1,3
800074d2:	010007b7          	lui	a5,0x1000
800074d6:	00778513          	add	a0,a5,7 # 1000007 <_extram_size+0x7>
800074da:	2c89                	jal	8000772c <clock_set_source_divider>
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
800074dc:	4605                	li	a2,1
800074de:	4581                	li	a1,0
800074e0:	010807b7          	lui	a5,0x1080
800074e4:	00178513          	add	a0,a5,1 # 1080001 <WIZCHIP+0x1>
800074e8:	2491                	jal	8000772c <clock_set_source_divider>
    clock_set_source_divider(clock_mchtmr1, clk_src_osc24m, 1);
800074ea:	4605                	li	a2,1
800074ec:	4581                	li	a1,0
800074ee:	010907b7          	lui	a5,0x1090
800074f2:	00378513          	add	a0,a5,3 # 1090003 <__AXI_SRAM_segment_used_end__+0xf673>
800074f6:	2c1d                	jal	8000772c <clock_set_source_divider>
}
800074f8:	0001                	nop
800074fa:	40f2                	lw	ra,28(sp)
800074fc:	6105                	add	sp,sp,32
800074fe:	8082                	ret

Disassembly of section .text.syscall_handler:

80007500 <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
80007500:	1101                	add	sp,sp,-32
80007502:	ce2a                	sw	a0,28(sp)
80007504:	cc2e                	sw	a1,24(sp)
80007506:	ca32                	sw	a2,20(sp)
80007508:	c836                	sw	a3,16(sp)
8000750a:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
8000750c:	0001                	nop
8000750e:	6105                	add	sp,sp,32
80007510:	8082                	ret

Disassembly of section .text.hpm_csr_get_core_cycle:

80007512 <hpm_csr_get_core_cycle>:
 *          - in user mode if the device supports M/U mode
 *
 * @return CSR cycle value in 64-bit
 */
static inline uint64_t hpm_csr_get_core_cycle(void)
{
80007512:	7179                	add	sp,sp,-48

80007514 <.LBB2>:
    uint64_t result;
    uint32_t resultl_first = read_csr(CSR_CYCLE);
80007514:	c0002f73          	rdcycle	t5
80007518:	d27a                	sw	t5,36(sp)
8000751a:	5f12                	lw	t5,36(sp)

8000751c <.LBE2>:
8000751c:	d07a                	sw	t5,32(sp)

8000751e <.LBB3>:
    uint32_t resulth = read_csr(CSR_CYCLEH);
8000751e:	c8002f73          	rdcycleh	t5
80007522:	ce7a                	sw	t5,28(sp)
80007524:	4f72                	lw	t5,28(sp)

80007526 <.LBE3>:
80007526:	cc7a                	sw	t5,24(sp)

80007528 <.LBB4>:
    uint32_t resultl_second = read_csr(CSR_CYCLE);
80007528:	c0002f73          	rdcycle	t5
8000752c:	ca7a                	sw	t5,20(sp)
8000752e:	4f52                	lw	t5,20(sp)

80007530 <.LBE4>:
80007530:	c87a                	sw	t5,16(sp)
    if (resultl_first < resultl_second) {
80007532:	5f82                	lw	t6,32(sp)
80007534:	4f42                	lw	t5,16(sp)
80007536:	03eff263          	bgeu	t6,t5,8000755a <.L2>
        result = ((uint64_t)resulth << 32) | resultl_first; /* if CYCLE didn't roll over, return the value directly */
8000753a:	47e2                	lw	a5,24(sp)
8000753c:	8e3e                	mv	t3,a5
8000753e:	4e81                	li	t4,0
80007540:	000e1693          	sll	a3,t3,0x0
80007544:	4601                	li	a2,0
80007546:	5782                	lw	a5,32(sp)
80007548:	883e                	mv	a6,a5
8000754a:	4881                	li	a7,0
8000754c:	010667b3          	or	a5,a2,a6
80007550:	d43e                	sw	a5,40(sp)
80007552:	0116e7b3          	or	a5,a3,a7
80007556:	d63e                	sw	a5,44(sp)
80007558:	a025                	j	80007580 <.L3>

8000755a <.L2>:
    } else {
        resulth = read_csr(CSR_CYCLEH);
8000755a:	c80026f3          	rdcycleh	a3
8000755e:	c636                	sw	a3,12(sp)
80007560:	46b2                	lw	a3,12(sp)

80007562 <.LBE5>:
80007562:	cc36                	sw	a3,24(sp)
        result = ((uint64_t)resulth << 32) | resultl_second; /* if CYCLE rolled over, need to get the CYCLEH again */
80007564:	46e2                	lw	a3,24(sp)
80007566:	8336                	mv	t1,a3
80007568:	4381                	li	t2,0
8000756a:	00031793          	sll	a5,t1,0x0
8000756e:	4701                	li	a4,0
80007570:	46c2                	lw	a3,16(sp)
80007572:	8536                	mv	a0,a3
80007574:	4581                	li	a1,0
80007576:	00a766b3          	or	a3,a4,a0
8000757a:	d436                	sw	a3,40(sp)
8000757c:	8fcd                	or	a5,a5,a1
8000757e:	d63e                	sw	a5,44(sp)

80007580 <.L3>:
    }
    return result;
80007580:	5722                	lw	a4,40(sp)
80007582:	57b2                	lw	a5,44(sp)
 }
80007584:	853a                	mv	a0,a4
80007586:	85be                	mv	a1,a5
80007588:	6145                	add	sp,sp,48
8000758a:	8082                	ret

Disassembly of section .text.pllctl_get_div:

8000758c <pllctl_get_div>:
{
8000758c:	1141                	add	sp,sp,-16
8000758e:	c62a                	sw	a0,12(sp)
80007590:	87ae                	mv	a5,a1
80007592:	8732                	mv	a4,a2
80007594:	00f105a3          	sb	a5,11(sp)
80007598:	87ba                	mv	a5,a4
8000759a:	00f10523          	sb	a5,10(sp)
    if ((pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1))
8000759e:	00b14703          	lbu	a4,11(sp)
800075a2:	4791                	li	a5,4
800075a4:	00e7ec63          	bltu	a5,a4,800075bc <.L6>
            || !(PLLCTL_SOC_PLL_HAS_DIV0(pll))) {
800075a8:	00b14703          	lbu	a4,11(sp)
800075ac:	4785                	li	a5,1
800075ae:	00f70963          	beq	a4,a5,800075c0 <.L7>
800075b2:	00b14703          	lbu	a4,11(sp)
800075b6:	4789                	li	a5,2
800075b8:	00f70463          	beq	a4,a5,800075c0 <.L7>

800075bc <.L6>:
        return status_invalid_argument;
800075bc:	4789                	li	a5,2
800075be:	a80d                	j	800075f0 <.L8>

800075c0 <.L7>:
    if (div_index) {
800075c0:	00a14783          	lbu	a5,10(sp)
800075c4:	cf81                	beqz	a5,800075dc <.L9>
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV1) + 1;
800075c6:	00b14783          	lbu	a5,11(sp)
800075ca:	4732                	lw	a4,12(sp)
800075cc:	079e                	sll	a5,a5,0x7
800075ce:	97ba                	add	a5,a5,a4
800075d0:	0c47a783          	lw	a5,196(a5)
800075d4:	0ff7f793          	zext.b	a5,a5
800075d8:	0785                	add	a5,a5,1
800075da:	a819                	j	800075f0 <.L8>

800075dc <.L9>:
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV0) + 1;
800075dc:	00b14783          	lbu	a5,11(sp)
800075e0:	4732                	lw	a4,12(sp)
800075e2:	079e                	sll	a5,a5,0x7
800075e4:	97ba                	add	a5,a5,a4
800075e6:	0c07a783          	lw	a5,192(a5)
800075ea:	0ff7f793          	zext.b	a5,a5
800075ee:	0785                	add	a5,a5,1

800075f0 <.L8>:
}
800075f0:	853e                	mv	a0,a5
800075f2:	0141                	add	sp,sp,16
800075f4:	8082                	ret

Disassembly of section .text.clock_get_frequency:

800075f6 <clock_get_frequency>:

/***********************************************************************************************************************
 * Codes
 **********************************************************************************************************************/
uint32_t clock_get_frequency(clock_name_t clock_name)
{
800075f6:	7179                	add	sp,sp,-48
800075f8:	d606                	sw	ra,44(sp)
800075fa:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
800075fc:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
800075fe:	47b2                	lw	a5,12(sp)
80007600:	83a1                	srl	a5,a5,0x8
80007602:	0ff7f793          	zext.b	a5,a5
80007606:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80007608:	47b2                	lw	a5,12(sp)
8000760a:	0ff7f793          	zext.b	a5,a5
8000760e:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80007610:	4762                	lw	a4,24(sp)
80007612:	47b1                	li	a5,12
80007614:	08e7ee63          	bltu	a5,a4,800076b0 <.L18>
80007618:	47e2                	lw	a5,24(sp)
8000761a:	00279713          	sll	a4,a5,0x2
8000761e:	800037b7          	lui	a5,0x80003
80007622:	36c78793          	add	a5,a5,876 # 8000336c <.L20>
80007626:	97ba                	add	a5,a5,a4
80007628:	439c                	lw	a5,0(a5)
8000762a:	8782                	jr	a5

8000762c <.L32>:
    case CLK_SRC_GROUP_COMMON:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
8000762c:	47d2                	lw	a5,20(sp)
8000762e:	0ff7f793          	zext.b	a5,a5
80007632:	853e                	mv	a0,a5
80007634:	2069                	jal	800076be <.LFE130>
80007636:	ce2a                	sw	a0,28(sp)
        break;
80007638:	a8b5                	j	800076b4 <.L33>

8000763a <.L31>:
    case CLK_SRC_GROUP_ADC:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_ADC, node_or_instance);
8000763a:	45d2                	lw	a1,20(sp)
8000763c:	4505                	li	a0,1
8000763e:	6c4050ef          	jal	8000cd02 <get_frequency_for_i2s_or_adc>
80007642:	ce2a                	sw	a0,28(sp)
        break;
80007644:	a885                	j	800076b4 <.L33>

80007646 <.L30>:
    case CLK_SRC_GROUP_I2S:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_I2S, node_or_instance);
80007646:	45d2                	lw	a1,20(sp)
80007648:	4509                	li	a0,2
8000764a:	6b8050ef          	jal	8000cd02 <get_frequency_for_i2s_or_adc>
8000764e:	ce2a                	sw	a0,28(sp)
        break;
80007650:	a095                	j	800076b4 <.L33>

80007652 <.L29>:
    case CLK_SRC_GROUP_WDG:
        clk_freq = get_frequency_for_wdg(node_or_instance);
80007652:	4552                	lw	a0,20(sp)
80007654:	786050ef          	jal	8000cdda <get_frequency_for_wdg>
80007658:	ce2a                	sw	a0,28(sp)
        break;
8000765a:	a8a9                	j	800076b4 <.L33>

8000765c <.L19>:
    case CLK_SRC_GROUP_PWDG:
        clk_freq = get_frequency_for_pwdg();
8000765c:	7b2050ef          	jal	8000ce0e <get_frequency_for_pwdg>
80007660:	ce2a                	sw	a0,28(sp)
        break;
80007662:	a889                	j	800076b4 <.L33>

80007664 <.L28>:
    case CLK_SRC_GROUP_PMIC:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80007664:	016e37b7          	lui	a5,0x16e3
80007668:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000766c:	ce3e                	sw	a5,28(sp)
        break;
8000766e:	a099                	j	800076b4 <.L33>

80007670 <.L27>:
    case CLK_SRC_GROUP_AHB:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
80007670:	451d                	li	a0,7
80007672:	20b1                	jal	800076be <.LFE130>
80007674:	ce2a                	sw	a0,28(sp)
        break;
80007676:	a83d                	j	800076b4 <.L33>

80007678 <.L26>:
    case CLK_SRC_GROUP_AXI0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi0);
80007678:	4511                	li	a0,4
8000767a:	2091                	jal	800076be <.LFE130>
8000767c:	ce2a                	sw	a0,28(sp)
        break;
8000767e:	a81d                	j	800076b4 <.L33>

80007680 <.L25>:
    case CLK_SRC_GROUP_AXI1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi1);
80007680:	4515                	li	a0,5
80007682:	2835                	jal	800076be <.LFE130>
80007684:	ce2a                	sw	a0,28(sp)
        break;
80007686:	a03d                	j	800076b4 <.L33>

80007688 <.L24>:
    case CLK_SRC_GROUP_AXI2:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi2);
80007688:	4519                	li	a0,6
8000768a:	2815                	jal	800076be <.LFE130>
8000768c:	ce2a                	sw	a0,28(sp)
        break;
8000768e:	a01d                	j	800076b4 <.L33>

80007690 <.L23>:
    case CLK_SRC_GROUP_CPU0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
80007690:	4501                	li	a0,0
80007692:	2035                	jal	800076be <.LFE130>
80007694:	ce2a                	sw	a0,28(sp)
        break;
80007696:	a839                	j	800076b4 <.L33>

80007698 <.L22>:
    case CLK_SRC_GROUP_CPU1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu1);
80007698:	4509                	li	a0,2
8000769a:	2015                	jal	800076be <.LFE130>
8000769c:	ce2a                	sw	a0,28(sp)
        break;
8000769e:	a819                	j	800076b4 <.L33>

800076a0 <.L21>:
    case CLK_SRC_GROUP_SRC:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
800076a0:	47d2                	lw	a5,20(sp)
800076a2:	0ff7f793          	zext.b	a5,a5
800076a6:	853e                	mv	a0,a5
800076a8:	55a050ef          	jal	8000cc02 <get_frequency_for_source>
800076ac:	ce2a                	sw	a0,28(sp)
        break;
800076ae:	a019                	j	800076b4 <.L33>

800076b0 <.L18>:
    default:
        clk_freq = 0UL;
800076b0:	ce02                	sw	zero,28(sp)
        break;
800076b2:	0001                	nop

800076b4 <.L33>:
    }
    return clk_freq;
800076b4:	47f2                	lw	a5,28(sp)
}
800076b6:	853e                	mv	a0,a5
800076b8:	50b2                	lw	ra,44(sp)
800076ba:	6145                	add	sp,sp,48
800076bc:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

800076be <get_frequency_for_ip_in_common_group>:

    return clk_freq;
}

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
800076be:	7139                	add	sp,sp,-64
800076c0:	de06                	sw	ra,60(sp)
800076c2:	87aa                	mv	a5,a0
800076c4:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
800076c8:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
800076ca:	00f14783          	lbu	a5,15(sp)
800076ce:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
800076d0:	5722                	lw	a4,40(sp)
800076d2:	04a00793          	li	a5,74
800076d6:	04e7e663          	bltu	a5,a4,80007722 <.L49>

800076da <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
800076da:	57a2                	lw	a5,40(sp)
800076dc:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
800076de:	f4000737          	lui	a4,0xf4000
800076e2:	5792                	lw	a5,36(sp)
800076e4:	60078793          	add	a5,a5,1536
800076e8:	078a                	sll	a5,a5,0x2
800076ea:	97ba                	add	a5,a5,a4
800076ec:	439c                	lw	a5,0(a5)
800076ee:	0ff7f793          	zext.b	a5,a5
800076f2:	0785                	add	a5,a5,1
800076f4:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
800076f6:	f4000737          	lui	a4,0xf4000
800076fa:	5792                	lw	a5,36(sp)
800076fc:	60078793          	add	a5,a5,1536
80007700:	078a                	sll	a5,a5,0x2
80007702:	97ba                	add	a5,a5,a4
80007704:	439c                	lw	a5,0(a5)
80007706:	83a1                	srl	a5,a5,0x8
80007708:	8bbd                	and	a5,a5,15
8000770a:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
8000770e:	01f14783          	lbu	a5,31(sp)
80007712:	853e                	mv	a0,a5
80007714:	4ee050ef          	jal	8000cc02 <get_frequency_for_source>
80007718:	872a                	mv	a4,a0
8000771a:	5782                	lw	a5,32(sp)
8000771c:	02f757b3          	divu	a5,a4,a5
80007720:	d63e                	sw	a5,44(sp)

80007722 <.L49>:
    }
    return clk_freq;
80007722:	57b2                	lw	a5,44(sp)
}
80007724:	853e                	mv	a0,a5
80007726:	50f2                	lw	ra,60(sp)
80007728:	6121                	add	sp,sp,64
8000772a:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

8000772c <clock_set_source_divider>:
    }
    return status_success;
}

hpm_stat_t clock_set_source_divider(clock_name_t clock_name, clk_src_t src, uint32_t div)
{
8000772c:	7179                	add	sp,sp,-48
8000772e:	d606                	sw	ra,44(sp)
80007730:	c62a                	sw	a0,12(sp)
80007732:	87ae                	mv	a5,a1
80007734:	c232                	sw	a2,4(sp)
80007736:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
8000773a:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
8000773c:	47b2                	lw	a5,12(sp)
8000773e:	83a1                	srl	a5,a5,0x8
80007740:	0ff7f793          	zext.b	a5,a5
80007744:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80007746:	47b2                	lw	a5,12(sp)
80007748:	0ff7f793          	zext.b	a5,a5
8000774c:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
8000774e:	4762                	lw	a4,24(sp)
80007750:	47b1                	li	a5,12
80007752:	0ae7e163          	bltu	a5,a4,800077f4 <.L140>
80007756:	47e2                	lw	a5,24(sp)
80007758:	00279713          	sll	a4,a5,0x2
8000775c:	800037b7          	lui	a5,0x80003
80007760:	3c078793          	add	a5,a5,960 # 800033c0 <.L142>
80007764:	97ba                	add	a5,a5,a4
80007766:	439c                	lw	a5,0(a5)
80007768:	8782                	jr	a5

8000776a <.L150>:
    case CLK_SRC_GROUP_COMMON:
        if ((div < 1U) || (div > 256U)) {
8000776a:	4792                	lw	a5,4(sp)
8000776c:	c791                	beqz	a5,80007778 <.L151>
8000776e:	4712                	lw	a4,4(sp)
80007770:	10000793          	li	a5,256
80007774:	00e7f763          	bgeu	a5,a4,80007782 <.L152>

80007778 <.L151>:
            status = status_clk_div_invalid;
80007778:	6795                	lui	a5,0x5
8000777a:	5f078793          	add	a5,a5,1520 # 55f0 <__HEAPSIZE__+0x15f0>
8000777e:	ce3e                	sw	a5,28(sp)
        } else {
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
        }
        break;
80007780:	a8bd                	j	800077fe <.L154>

80007782 <.L152>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
80007782:	00b14783          	lbu	a5,11(sp)
80007786:	8bbd                	and	a5,a5,15
80007788:	00f109a3          	sb	a5,19(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
8000778c:	47d2                	lw	a5,20(sp)
8000778e:	0ff7f793          	zext.b	a5,a5
80007792:	01314703          	lbu	a4,19(sp)
80007796:	4692                	lw	a3,4(sp)
80007798:	863a                	mv	a2,a4
8000779a:	85be                	mv	a1,a5
8000779c:	f4000537          	lui	a0,0xf4000
800077a0:	2ce1                	jal	80007a78 <sysctl_config_clock>

800077a2 <.LBE14>:
        break;
800077a2:	a8b1                	j	800077fe <.L154>

800077a4 <.L141>:
    case CLK_SRC_GROUP_ADC:
    case CLK_SRC_GROUP_I2S:
    case CLK_SRC_GROUP_WDG:
    case CLK_SRC_GROUP_PWDG:
    case CLK_SRC_GROUP_SRC:
        status = status_clk_operation_unsupported;
800077a4:	6795                	lui	a5,0x5
800077a6:	5f378793          	add	a5,a5,1523 # 55f3 <__HEAPSIZE__+0x15f3>
800077aa:	ce3e                	sw	a5,28(sp)
        break;
800077ac:	a889                	j	800077fe <.L154>

800077ae <.L149>:
    case CLK_SRC_GROUP_PMIC:
        status = status_clk_fixed;
800077ae:	6795                	lui	a5,0x5
800077b0:	5fa78793          	add	a5,a5,1530 # 55fa <__HEAPSIZE__+0x15fa>
800077b4:	ce3e                	sw	a5,28(sp)
        break;
800077b6:	a0a1                	j	800077fe <.L154>

800077b8 <.L148>:
    case CLK_SRC_GROUP_AHB:
        status = status_clk_shared_ahb;
800077b8:	6795                	lui	a5,0x5
800077ba:	5f478793          	add	a5,a5,1524 # 55f4 <__HEAPSIZE__+0x15f4>
800077be:	ce3e                	sw	a5,28(sp)
        break;
800077c0:	a83d                	j	800077fe <.L154>

800077c2 <.L147>:
    case CLK_SRC_GROUP_AXI0:
        status = status_clk_shared_axi0;
800077c2:	6795                	lui	a5,0x5
800077c4:	5f578793          	add	a5,a5,1525 # 55f5 <__HEAPSIZE__+0x15f5>
800077c8:	ce3e                	sw	a5,28(sp)
        break;
800077ca:	a815                	j	800077fe <.L154>

800077cc <.L146>:
    case CLK_SRC_GROUP_AXI1:
        status = status_clk_shared_axi1;
800077cc:	6795                	lui	a5,0x5
800077ce:	5f678793          	add	a5,a5,1526 # 55f6 <__HEAPSIZE__+0x15f6>
800077d2:	ce3e                	sw	a5,28(sp)
        break;
800077d4:	a02d                	j	800077fe <.L154>

800077d6 <.L145>:
    case CLK_SRC_GROUP_AXI2:
        status = status_clk_shared_axi2;
800077d6:	6795                	lui	a5,0x5
800077d8:	5f778793          	add	a5,a5,1527 # 55f7 <__HEAPSIZE__+0x15f7>
800077dc:	ce3e                	sw	a5,28(sp)
        break;
800077de:	a005                	j	800077fe <.L154>

800077e0 <.L144>:
    case CLK_SRC_GROUP_CPU0:
        status = status_clk_shared_cpu0;
800077e0:	6795                	lui	a5,0x5
800077e2:	5f878793          	add	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
800077e6:	ce3e                	sw	a5,28(sp)
        break;
800077e8:	a819                	j	800077fe <.L154>

800077ea <.L143>:
    case CLK_SRC_GROUP_CPU1:
        status = status_clk_shared_cpu1;
800077ea:	6795                	lui	a5,0x5
800077ec:	5f978793          	add	a5,a5,1529 # 55f9 <__HEAPSIZE__+0x15f9>
800077f0:	ce3e                	sw	a5,28(sp)
        break;
800077f2:	a031                	j	800077fe <.L154>

800077f4 <.L140>:
    default:
        status = status_clk_src_invalid;
800077f4:	6795                	lui	a5,0x5
800077f6:	5f178793          	add	a5,a5,1521 # 55f1 <__HEAPSIZE__+0x15f1>
800077fa:	ce3e                	sw	a5,28(sp)
        break;
800077fc:	0001                	nop

800077fe <.L154>:
    }

    return status;
800077fe:	47f2                	lw	a5,28(sp)
}
80007800:	853e                	mv	a0,a5
80007802:	50b2                	lw	ra,44(sp)
80007804:	6145                	add	sp,sp,48
80007806:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80007808 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80007808:	7179                	add	sp,sp,-48
8000780a:	d606                	sw	ra,44(sp)
8000780c:	c62a                	sw	a0,12(sp)
8000780e:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80007810:	47b2                	lw	a5,12(sp)
80007812:	83c1                	srl	a5,a5,0x10
80007814:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80007816:	4772                	lw	a4,28(sp)
80007818:	15d00793          	li	a5,349
8000781c:	00e7ef63          	bltu	a5,a4,8000783a <.L165>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80007820:	47a2                	lw	a5,8(sp)
80007822:	0ff7f793          	zext.b	a5,a5
80007826:	4772                	lw	a4,28(sp)
80007828:	0742                	sll	a4,a4,0x10
8000782a:	8341                	srl	a4,a4,0x10
8000782c:	4685                	li	a3,1
8000782e:	863a                	mv	a2,a4
80007830:	85be                	mv	a1,a5
80007832:	f4000537          	lui	a0,0xf4000
80007836:	720050ef          	jal	8000cf56 <sysctl_enable_group_resource>

8000783a <.L165>:
    }
}
8000783a:	0001                	nop
8000783c:	50b2                	lw	ra,44(sp)
8000783e:	6145                	add	sp,sp,48
80007840:	8082                	ret

Disassembly of section .text.clock_cpu_delay_ms:

80007842 <clock_cpu_delay_ms>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_cpu_delay_ms(uint32_t ms)
{
80007842:	715d                	add	sp,sp,-80
80007844:	c686                	sw	ra,76(sp)
80007846:	c4a2                	sw	s0,72(sp)
80007848:	c2a6                	sw	s1,68(sp)
8000784a:	c0ca                	sw	s2,64(sp)
8000784c:	de4e                	sw	s3,60(sp)
8000784e:	dc52                	sw	s4,56(sp)
80007850:	da56                	sw	s5,52(sp)
80007852:	d85a                	sw	s6,48(sp)
80007854:	d65e                	sw	s7,44(sp)
80007856:	c62a                	sw	a0,12(sp)
    uint64_t expected_ticks = hpm_csr_get_core_cycle() + (uint64_t)clock_get_core_clock_ticks_per_ms() * (uint64_t)ms;
80007858:	396d                	jal	80007512 <hpm_csr_get_core_cycle>
8000785a:	8b2a                	mv	s6,a0
8000785c:	8bae                	mv	s7,a1
8000785e:	600050ef          	jal	8000ce5e <clock_get_core_clock_ticks_per_ms>
80007862:	87aa                	mv	a5,a0
80007864:	8a3e                	mv	s4,a5
80007866:	4a81                	li	s5,0
80007868:	47b2                	lw	a5,12(sp)
8000786a:	893e                	mv	s2,a5
8000786c:	4981                	li	s3,0
8000786e:	032a8733          	mul	a4,s5,s2
80007872:	034987b3          	mul	a5,s3,s4
80007876:	97ba                	add	a5,a5,a4
80007878:	032a0733          	mul	a4,s4,s2
8000787c:	032a34b3          	mulhu	s1,s4,s2
80007880:	843a                	mv	s0,a4
80007882:	97a6                	add	a5,a5,s1
80007884:	84be                	mv	s1,a5
80007886:	008b0733          	add	a4,s6,s0
8000788a:	86ba                	mv	a3,a4
8000788c:	0166b6b3          	sltu	a3,a3,s6
80007890:	009b87b3          	add	a5,s7,s1
80007894:	96be                	add	a3,a3,a5
80007896:	87b6                	mv	a5,a3
80007898:	cc3a                	sw	a4,24(sp)
8000789a:	ce3e                	sw	a5,28(sp)
    while (hpm_csr_get_core_cycle() < expected_ticks) {
8000789c:	0001                	nop

8000789e <.L188>:
8000789e:	3995                	jal	80007512 <hpm_csr_get_core_cycle>
800078a0:	872a                	mv	a4,a0
800078a2:	87ae                	mv	a5,a1
800078a4:	46f2                	lw	a3,28(sp)
800078a6:	863e                	mv	a2,a5
800078a8:	fed66be3          	bltu	a2,a3,8000789e <.L188>
800078ac:	46f2                	lw	a3,28(sp)
800078ae:	863e                	mv	a2,a5
800078b0:	00c69663          	bne	a3,a2,800078bc <.L190>
800078b4:	46e2                	lw	a3,24(sp)
800078b6:	87ba                	mv	a5,a4
800078b8:	fed7e3e3          	bltu	a5,a3,8000789e <.L188>

800078bc <.L190>:
    }
}
800078bc:	0001                	nop
800078be:	40b6                	lw	ra,76(sp)
800078c0:	4426                	lw	s0,72(sp)
800078c2:	4496                	lw	s1,68(sp)
800078c4:	4906                	lw	s2,64(sp)
800078c6:	59f2                	lw	s3,60(sp)
800078c8:	5a62                	lw	s4,56(sp)
800078ca:	5ad2                	lw	s5,52(sp)
800078cc:	5b42                	lw	s6,48(sp)
800078ce:	5bb2                	lw	s7,44(sp)
800078d0:	6161                	add	sp,sp,80
800078d2:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

800078d4 <clock_update_core_clock>:

void clock_update_core_clock(void)
{
800078d4:	1101                	add	sp,sp,-32
800078d6:	ce06                	sw	ra,28(sp)

800078d8 <.LBB16>:
    uint32_t hart_id = read_csr(CSR_MHARTID);
800078d8:	f14027f3          	csrr	a5,mhartid
800078dc:	c63e                	sw	a5,12(sp)
800078de:	47b2                	lw	a5,12(sp)

800078e0 <.LBE16>:
800078e0:	c43e                	sw	a5,8(sp)
    clock_name_t cpu_clk_name = (hart_id == 1U) ? clock_cpu1 : clock_cpu0;
800078e2:	4722                	lw	a4,8(sp)
800078e4:	4785                	li	a5,1
800078e6:	00f71663          	bne	a4,a5,800078f2 <.L192>
800078ea:	000807b7          	lui	a5,0x80
800078ee:	0789                	add	a5,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
800078f0:	a011                	j	800078f4 <.L193>

800078f2 <.L192>:
800078f2:	4781                	li	a5,0

800078f4 <.L193>:
800078f4:	c23e                	sw	a5,4(sp)
    hpm_core_clock = clock_get_frequency(cpu_clk_name);
800078f6:	4512                	lw	a0,4(sp)
800078f8:	39fd                	jal	800075f6 <clock_get_frequency>
800078fa:	872a                	mv	a4,a0
800078fc:	12e1a223          	sw	a4,292(gp) # 1080924 <hpm_core_clock>
80007900:	0001                	nop
80007902:	40f2                	lw	ra,28(sp)
80007904:	6105                	add	sp,sp,32
80007906:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80007908 <l1c_dc_enable>:

    write_csr(CSR_MSTATUS, csr);
}

void l1c_dc_enable(void)
{
80007908:	1141                	add	sp,sp,-16

8000790a <.LBB56>:
extern "C" {
#endif
/* get cache control register value */
__attribute__((always_inline)) static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
8000790a:	7ca027f3          	csrr	a5,0x7ca
8000790e:	c63e                	sw	a5,12(sp)
80007910:	47b2                	lw	a5,12(sp)

80007912 <.LBE60>:
80007912:	0001                	nop

80007914 <.LBE58>:
}

__attribute__((always_inline)) static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80007914:	8b89                	and	a5,a5,2
80007916:	00f037b3          	snez	a5,a5
8000791a:	0ff7f793          	zext.b	a5,a5

8000791e <.LBE56>:
    if (!l1c_dc_is_enabled()) {
8000791e:	0017c793          	xor	a5,a5,1
80007922:	0ff7f793          	zext.b	a5,a5
80007926:	cb89                	beqz	a5,80007938 <.L13>
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
80007928:	001807b7          	lui	a5,0x180
8000792c:	7ca7b073          	csrc	0x7ca,a5
        set_csr(CSR_MCACHE_CTL,
80007930:	67c1                	lui	a5,0x10
80007932:	0789                	add	a5,a5,2 # 10002 <__XPI0_segment_used_size__+0x3fae>
80007934:	7ca7a073          	csrs	0x7ca,a5

80007938 <.L13>:
                HPM_MCACHE_CTL_DC_WAROUND(L1C_DC_WAROUND_VALUE) |
#endif
                                HPM_MCACHE_CTL_DPREF_EN_MASK
                              | HPM_MCACHE_CTL_DC_EN_MASK);
    }
}
80007938:	0001                	nop
8000793a:	0141                	add	sp,sp,16
8000793c:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

8000793e <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
8000793e:	1141                	add	sp,sp,-16

80007940 <.LBB66>:
    return read_csr(CSR_MCACHE_CTL);
80007940:	7ca027f3          	csrr	a5,0x7ca
80007944:	c63e                	sw	a5,12(sp)
80007946:	47b2                	lw	a5,12(sp)

80007948 <.LBE70>:
80007948:	0001                	nop

8000794a <.LBE68>:
}

__attribute__((always_inline)) static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
8000794a:	8b85                	and	a5,a5,1
8000794c:	00f037b3          	snez	a5,a5
80007950:	0ff7f793          	zext.b	a5,a5

80007954 <.LBE66>:
    if (!l1c_ic_is_enabled()) {
80007954:	0017c793          	xor	a5,a5,1
80007958:	0ff7f793          	zext.b	a5,a5
8000795c:	c789                	beqz	a5,80007966 <.L23>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
8000795e:	30100793          	li	a5,769
80007962:	7ca7a073          	csrs	0x7ca,a5

80007966 <.L23>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80007966:	0001                	nop
80007968:	0141                	add	sp,sp,16
8000796a:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate:

8000796c <l1c_dc_invalidate>:
    ASSERT_ADDR_SIZE(address, size);
    l1c_op(HPM_L1C_CCTL_CMD_L1D_VA_LOCK, address, size);
}

void l1c_dc_invalidate(uint32_t address, uint32_t size)
{
8000796c:	1101                	add	sp,sp,-32
8000796e:	ce06                	sw	ra,28(sp)
80007970:	c62a                	sw	a0,12(sp)
80007972:	c42e                	sw	a1,8(sp)
    ASSERT_ADDR_SIZE(address, size);
80007974:	47b2                	lw	a5,12(sp)
80007976:	03f7f793          	and	a5,a5,63
8000797a:	cf89                	beqz	a5,80007994 <.L37>
8000797c:	06d00613          	li	a2,109
80007980:	800057b7          	lui	a5,0x80005
80007984:	97c78593          	add	a1,a5,-1668 # 8000497c <.LC0>
80007988:	800057b7          	lui	a5,0x80005
8000798c:	9d478513          	add	a0,a5,-1580 # 800049d4 <.LC1>
80007990:	7d0050ef          	jal	8000d160 <__SEGGER_RTL_X_assert>

80007994 <.L37>:
80007994:	47a2                	lw	a5,8(sp)
80007996:	03f7f793          	and	a5,a5,63
8000799a:	cf89                	beqz	a5,800079b4 <.L38>
8000799c:	06d00613          	li	a2,109
800079a0:	800057b7          	lui	a5,0x80005
800079a4:	97c78593          	add	a1,a5,-1668 # 8000497c <.LC0>
800079a8:	800057b7          	lui	a5,0x80005
800079ac:	9fc78513          	add	a0,a5,-1540 # 800049fc <.LC2>
800079b0:	7b0050ef          	jal	8000d160 <__SEGGER_RTL_X_assert>

800079b4 <.L38>:
    l1c_op(HPM_L1C_CCTL_CMD_L1D_VA_INVAL, address, size);
800079b4:	4622                	lw	a2,8(sp)
800079b6:	45b2                	lw	a1,12(sp)
800079b8:	4501                	li	a0,0
800079ba:	4d0050ef          	jal	8000ce8a <l1c_op>
}
800079be:	0001                	nop
800079c0:	40f2                	lw	ra,28(sp)
800079c2:	6105                	add	sp,sp,32
800079c4:	8082                	ret

Disassembly of section .text.l1c_dc_writeback:

800079c6 <l1c_dc_writeback>:

void l1c_dc_writeback(uint32_t address, uint32_t size)
{
800079c6:	1101                	add	sp,sp,-32
800079c8:	ce06                	sw	ra,28(sp)
800079ca:	c62a                	sw	a0,12(sp)
800079cc:	c42e                	sw	a1,8(sp)
    ASSERT_ADDR_SIZE(address, size);
800079ce:	47b2                	lw	a5,12(sp)
800079d0:	03f7f793          	and	a5,a5,63
800079d4:	cf89                	beqz	a5,800079ee <.L40>
800079d6:	07300613          	li	a2,115
800079da:	800057b7          	lui	a5,0x80005
800079de:	97c78593          	add	a1,a5,-1668 # 8000497c <.LC0>
800079e2:	800057b7          	lui	a5,0x80005
800079e6:	9d478513          	add	a0,a5,-1580 # 800049d4 <.LC1>
800079ea:	776050ef          	jal	8000d160 <__SEGGER_RTL_X_assert>

800079ee <.L40>:
800079ee:	47a2                	lw	a5,8(sp)
800079f0:	03f7f793          	and	a5,a5,63
800079f4:	cf89                	beqz	a5,80007a0e <.L41>
800079f6:	07300613          	li	a2,115
800079fa:	800057b7          	lui	a5,0x80005
800079fe:	97c78593          	add	a1,a5,-1668 # 8000497c <.LC0>
80007a02:	800057b7          	lui	a5,0x80005
80007a06:	9fc78513          	add	a0,a5,-1540 # 800049fc <.LC2>
80007a0a:	756050ef          	jal	8000d160 <__SEGGER_RTL_X_assert>

80007a0e <.L41>:
    l1c_op(HPM_L1C_CCTL_CMD_L1D_VA_WB, address, size);
80007a0e:	4622                	lw	a2,8(sp)
80007a10:	45b2                	lw	a1,12(sp)
80007a12:	4505                	li	a0,1
80007a14:	476050ef          	jal	8000ce8a <l1c_op>
}
80007a18:	0001                	nop
80007a1a:	40f2                	lw	ra,28(sp)
80007a1c:	6105                	add	sp,sp,32
80007a1e:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

80007a20 <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
80007a20:	1141                	add	sp,sp,-16
80007a22:	c62a                	sw	a0,12(sp)
80007a24:	87ae                	mv	a5,a1
80007a26:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
80007a2a:	00a15783          	lhu	a5,10(sp)
80007a2e:	4732                	lw	a4,12(sp)
80007a30:	078a                	sll	a5,a5,0x2
80007a32:	97ba                	add	a5,a5,a4
80007a34:	4398                	lw	a4,0(a5)
80007a36:	400007b7          	lui	a5,0x40000
80007a3a:	8ff9                	and	a5,a5,a4
80007a3c:	00f037b3          	snez	a5,a5
80007a40:	0ff7f793          	zext.b	a5,a5
}
80007a44:	853e                	mv	a0,a5
80007a46:	0141                	add	sp,sp,16
80007a48:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

80007a4a <sysctl_clock_target_is_busy>:
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr,
                                               clock_node_t clock)
{
80007a4a:	1141                	add	sp,sp,-16
80007a4c:	c62a                	sw	a0,12(sp)
80007a4e:	87ae                	mv	a5,a1
80007a50:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
80007a54:	00b14783          	lbu	a5,11(sp)
80007a58:	4732                	lw	a4,12(sp)
80007a5a:	60078793          	add	a5,a5,1536 # 40000600 <__SHARE_RAM_segment_end__+0x3ee80600>
80007a5e:	078a                	sll	a5,a5,0x2
80007a60:	97ba                	add	a5,a5,a4
80007a62:	4398                	lw	a4,0(a5)
80007a64:	400007b7          	lui	a5,0x40000
80007a68:	8ff9                	and	a5,a5,a4
80007a6a:	00f037b3          	snez	a5,a5
80007a6e:	0ff7f793          	zext.b	a5,a5
}
80007a72:	853e                	mv	a0,a5
80007a74:	0141                	add	sp,sp,16
80007a76:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

80007a78 <sysctl_config_clock>:
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node,
                                clock_source_t source, uint32_t divide_by)
{
80007a78:	1101                	add	sp,sp,-32
80007a7a:	ce06                	sw	ra,28(sp)
80007a7c:	c62a                	sw	a0,12(sp)
80007a7e:	87ae                	mv	a5,a1
80007a80:	8732                	mv	a4,a2
80007a82:	c236                	sw	a3,4(sp)
80007a84:	00f105a3          	sb	a5,11(sp)
80007a88:	87ba                	mv	a5,a4
80007a8a:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_i2s_start) {
80007a8e:	00b14703          	lbu	a4,11(sp)
80007a92:	04200793          	li	a5,66
80007a96:	00e7f463          	bgeu	a5,a4,80007a9e <.L114>
        return status_invalid_argument;
80007a9a:	4789                	li	a5,2
80007a9c:	a89d                	j	80007b12 <.L115>

80007a9e <.L114>:
    }

    if (source >= clock_source_general_source_end) {
80007a9e:	00a14703          	lbu	a4,10(sp)
80007aa2:	479d                	li	a5,7
80007aa4:	00e7f463          	bgeu	a5,a4,80007aac <.L116>
        return status_invalid_argument;
80007aa8:	4789                	li	a5,2
80007aaa:	a0a5                	j	80007b12 <.L115>

80007aac <.L116>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80007aac:	00b14783          	lbu	a5,11(sp)
80007ab0:	4732                	lw	a4,12(sp)
80007ab2:	60078793          	add	a5,a5,1536 # 40000600 <__SHARE_RAM_segment_end__+0x3ee80600>
80007ab6:	078a                	sll	a5,a5,0x2
80007ab8:	97ba                	add	a5,a5,a4
80007aba:	4398                	lw	a4,0(a5)
80007abc:	77fd                	lui	a5,0xfffff
80007abe:	00f776b3          	and	a3,a4,a5
            ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK))
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80007ac2:	00a14783          	lbu	a5,10(sp)
80007ac6:	00879713          	sll	a4,a5,0x8
80007aca:	6785                	lui	a5,0x1
80007acc:	f0078793          	add	a5,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
80007ad0:	8f7d                	and	a4,a4,a5
80007ad2:	4792                	lw	a5,4(sp)
80007ad4:	17fd                	add	a5,a5,-1
80007ad6:	0ff7f793          	zext.b	a5,a5
80007ada:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80007adc:	00b14783          	lbu	a5,11(sp)
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80007ae0:	8f55                	or	a4,a4,a3
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80007ae2:	46b2                	lw	a3,12(sp)
80007ae4:	60078793          	add	a5,a5,1536
80007ae8:	078a                	sll	a5,a5,0x2
80007aea:	97b6                	add	a5,a5,a3
80007aec:	c398                	sw	a4,0(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
80007aee:	0001                	nop

80007af0 <.L117>:
80007af0:	00b14783          	lbu	a5,11(sp)
80007af4:	85be                	mv	a1,a5
80007af6:	4532                	lw	a0,12(sp)
80007af8:	3f89                	jal	80007a4a <sysctl_clock_target_is_busy>
80007afa:	87aa                	mv	a5,a0
80007afc:	fbf5                	bnez	a5,80007af0 <.L117>
    }

    if ((node == clock_node_cpu0) || (node == clock_node_cpu1)) {
80007afe:	00b14783          	lbu	a5,11(sp)
80007b02:	c791                	beqz	a5,80007b0e <.L118>
80007b04:	00b14703          	lbu	a4,11(sp)
80007b08:	4789                	li	a5,2
80007b0a:	00f71363          	bne	a4,a5,80007b10 <.L119>

80007b0e <.L118>:
        clock_update_core_clock();
80007b0e:	33d9                	jal	800078d4 <clock_update_core_clock>

80007b10 <.L119>:
    }
    return status_success;
80007b10:	4781                	li	a5,0

80007b12 <.L115>:
}
80007b12:	853e                	mv	a0,a5
80007b14:	40f2                	lw	ra,28(sp)
80007b16:	6105                	add	sp,sp,32
80007b18:	8082                	ret

Disassembly of section .text.system_init:

80007b1a <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80007b1a:	7179                	add	sp,sp,-48
80007b1c:	d606                	sw	ra,44(sp)
80007b1e:	47a1                	li	a5,8
80007b20:	c83e                	sw	a5,16(sp)

80007b22 <.LBB16>:
 * @param[in] mask interrupt mask to be disabled
 * @retval current mstatus value before irq mask is disabled
 */
ATTR_ALWAYS_INLINE static inline uint32_t disable_global_irq(uint32_t mask)
{
    return read_clear_csr(CSR_MSTATUS, mask);
80007b22:	c602                	sw	zero,12(sp)
80007b24:	47c2                	lw	a5,16(sp)
80007b26:	3007b7f3          	csrrc	a5,mstatus,a5
80007b2a:	c63e                	sw	a5,12(sp)
80007b2c:	47b2                	lw	a5,12(sp)

80007b2e <.LBE18>:
80007b2e:	0001                	nop

80007b30 <.LBB19>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80007b30:	6785                	lui	a5,0x1
80007b32:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x402>
80007b36:	3047b073          	csrc	mie,a5
}
80007b3a:	0001                	nop

80007b3c <.LBE19>:
    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();
    enable_plic_feature();
80007b3c:	542050ef          	jal	8000d07e <enable_plic_feature>

80007b40 <.LBB21>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80007b40:	6785                	lui	a5,0x1
80007b42:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x402>
80007b46:	3047a073          	csrs	mie,a5
}
80007b4a:	0001                	nop
80007b4c:	47a1                	li	a5,8
80007b4e:	ca3e                	sw	a5,20(sp)

80007b50 <.LBB23>:
    set_csr(CSR_MSTATUS, mask);
80007b50:	47d2                	lw	a5,20(sp)
80007b52:	3007a073          	csrs	mstatus,a5
}
80007b56:	0001                	nop

80007b58 <.LBB25>:
#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif

#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
80007b58:	306027f3          	csrr	a5,mcounteren
80007b5c:	ce3e                	sw	a5,28(sp)
80007b5e:	47f2                	lw	a5,28(sp)

80007b60 <.LBE25>:
80007b60:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80007b62:	47e2                	lw	a5,24(sp)
80007b64:	0017e793          	or	a5,a5,1
80007b68:	30679073          	csrw	mcounteren,a5
#endif

#if defined(CONFIG_ENABLE_BPOR_RETENTION) && CONFIG_ENABLE_BPOR_RETENTION
    bpor_enable_reg_value_retention(HPM_BPOR);
#endif
}
80007b6c:	0001                	nop
80007b6e:	50b2                	lw	ra,44(sp)
80007b70:	6145                	add	sp,sp,48
80007b72:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80007b74 <__SEGGER_RTL_xltoa>:
80007b74:	882a                	mv	a6,a0
80007b76:	88ae                	mv	a7,a1
80007b78:	852e                	mv	a0,a1
80007b7a:	ca89                	beqz	a3,80007b8c <.L2>
80007b7c:	02d00793          	li	a5,45
80007b80:	00158893          	add	a7,a1,1 # f00c4001 <__XPI0_segment_end__+0x6f8c4001>
80007b84:	00f58023          	sb	a5,0(a1)
80007b88:	41000833          	neg	a6,a6

80007b8c <.L2>:
80007b8c:	8746                	mv	a4,a7
80007b8e:	4325                	li	t1,9

80007b90 <.L5>:
80007b90:	02c876b3          	remu	a3,a6,a2
80007b94:	85c2                	mv	a1,a6
80007b96:	0ff6f793          	zext.b	a5,a3
80007b9a:	02c85833          	divu	a6,a6,a2
80007b9e:	02d37d63          	bgeu	t1,a3,80007bd8 <.L3>
80007ba2:	05778793          	add	a5,a5,87

80007ba6 <.L11>:
80007ba6:	0ff7f793          	zext.b	a5,a5
80007baa:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3cf8000>
80007bae:	00170693          	add	a3,a4,1
80007bb2:	02c5f163          	bgeu	a1,a2,80007bd4 <.L8>
80007bb6:	000700a3          	sb	zero,1(a4)

80007bba <.L6>:
80007bba:	0008c683          	lbu	a3,0(a7)
80007bbe:	00074783          	lbu	a5,0(a4)
80007bc2:	0885                	add	a7,a7,1
80007bc4:	177d                	add	a4,a4,-1
80007bc6:	00d700a3          	sb	a3,1(a4)
80007bca:	fef88fa3          	sb	a5,-1(a7)
80007bce:	fee8e6e3          	bltu	a7,a4,80007bba <.L6>
80007bd2:	8082                	ret

80007bd4 <.L8>:
80007bd4:	8736                	mv	a4,a3
80007bd6:	bf6d                	j	80007b90 <.L5>

80007bd8 <.L3>:
80007bd8:	03078793          	add	a5,a5,48
80007bdc:	b7e9                	j	80007ba6 <.L11>

Disassembly of section .text.libc.itoa:

80007bde <itoa>:
80007bde:	46a9                	li	a3,10
80007be0:	87aa                	mv	a5,a0
80007be2:	882e                	mv	a6,a1
80007be4:	8732                	mv	a4,a2
80007be6:	00d61563          	bne	a2,a3,80007bf0 <.L301>
80007bea:	4685                	li	a3,1
80007bec:	00054663          	bltz	a0,80007bf8 <.L302>

80007bf0 <.L301>:
80007bf0:	4681                	li	a3,0
80007bf2:	863a                	mv	a2,a4
80007bf4:	85c2                	mv	a1,a6
80007bf6:	853e                	mv	a0,a5

80007bf8 <.L302>:
80007bf8:	bfb5                	j	80007b74 <__SEGGER_RTL_xltoa>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

80007bfa <__SEGGER_RTL_SIGNAL_SIG_IGN>:
80007bfa:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

80007bfc <__SEGGER_RTL_SIGNAL_SIG_ERR>:
80007bfc:	8082                	ret

Disassembly of section .text.libc.fwrite:

80007bfe <fwrite>:
80007bfe:	1101                	add	sp,sp,-32
80007c00:	c64e                	sw	s3,12(sp)
80007c02:	89aa                	mv	s3,a0
80007c04:	8536                	mv	a0,a3
80007c06:	cc22                	sw	s0,24(sp)
80007c08:	ca26                	sw	s1,20(sp)
80007c0a:	c84a                	sw	s2,16(sp)
80007c0c:	ce06                	sw	ra,28(sp)
80007c0e:	84ae                	mv	s1,a1
80007c10:	8432                	mv	s0,a2
80007c12:	8936                	mv	s2,a3
80007c14:	260010ef          	jal	80008e74 <__SEGGER_RTL_X_file_stat>
80007c18:	02054463          	bltz	a0,80007c40 <.L43>
80007c1c:	02848633          	mul	a2,s1,s0
80007c20:	4501                	li	a0,0
80007c22:	00966863          	bltu	a2,s1,80007c32 <.L41>
80007c26:	85ce                	mv	a1,s3
80007c28:	854a                	mv	a0,s2
80007c2a:	1d6010ef          	jal	80008e00 <__SEGGER_RTL_X_file_write>
80007c2e:	02955533          	divu	a0,a0,s1

80007c32 <.L41>:
80007c32:	40f2                	lw	ra,28(sp)
80007c34:	4462                	lw	s0,24(sp)
80007c36:	44d2                	lw	s1,20(sp)
80007c38:	4942                	lw	s2,16(sp)
80007c3a:	49b2                	lw	s3,12(sp)
80007c3c:	6105                	add	sp,sp,32
80007c3e:	8082                	ret

80007c40 <.L43>:
80007c40:	4501                	li	a0,0
80007c42:	bfc5                	j	80007c32 <.L41>

Disassembly of section .text.libc.__subsf3:

80007c44 <__subsf3>:
80007c44:	80000637          	lui	a2,0x80000
80007c48:	8db1                	xor	a1,a1,a2
80007c4a:	a009                	j	80007c4c <__addsf3>

Disassembly of section .text.libc.__addsf3:

80007c4c <__addsf3>:
80007c4c:	80000637          	lui	a2,0x80000
80007c50:	00b546b3          	xor	a3,a0,a1
80007c54:	0806ca63          	bltz	a3,80007ce8 <.L__addsf3_subtract>
80007c58:	00b57563          	bgeu	a0,a1,80007c62 <.L__addsf3_add_already_ordered>
80007c5c:	86aa                	mv	a3,a0
80007c5e:	852e                	mv	a0,a1
80007c60:	85b6                	mv	a1,a3

80007c62 <.L__addsf3_add_already_ordered>:
80007c62:	00151713          	sll	a4,a0,0x1
80007c66:	8361                	srl	a4,a4,0x18
80007c68:	00159693          	sll	a3,a1,0x1
80007c6c:	82e1                	srl	a3,a3,0x18
80007c6e:	0ff00293          	li	t0,255
80007c72:	06570563          	beq	a4,t0,80007cdc <.L__addsf3_add_inf_or_nan>
80007c76:	c325                	beqz	a4,80007cd6 <.L__addsf3_zero>
80007c78:	ceb1                	beqz	a3,80007cd4 <.L__addsf3_add_done>
80007c7a:	40d706b3          	sub	a3,a4,a3
80007c7e:	42e1                	li	t0,24
80007c80:	04d2ca63          	blt	t0,a3,80007cd4 <.L__addsf3_add_done>
80007c84:	05a2                	sll	a1,a1,0x8
80007c86:	8dd1                	or	a1,a1,a2
80007c88:	01755713          	srl	a4,a0,0x17
80007c8c:	0522                	sll	a0,a0,0x8
80007c8e:	8d51                	or	a0,a0,a2
80007c90:	47e5                	li	a5,25
80007c92:	8f95                	sub	a5,a5,a3
80007c94:	00f59633          	sll	a2,a1,a5
80007c98:	821d                	srl	a2,a2,0x7
80007c9a:	00d5d5b3          	srl	a1,a1,a3
80007c9e:	00b507b3          	add	a5,a0,a1
80007ca2:	00a7f463          	bgeu	a5,a0,80007caa <.L__addsf3_add_no_normalization>
80007ca6:	8385                	srl	a5,a5,0x1
80007ca8:	0709                	add	a4,a4,2

80007caa <.L__addsf3_add_no_normalization>:
80007caa:	177d                	add	a4,a4,-1
80007cac:	0ff77593          	zext.b	a1,a4
80007cb0:	f0158593          	add	a1,a1,-255
80007cb4:	cd91                	beqz	a1,80007cd0 <.L__addsf3_inf>
80007cb6:	075e                	sll	a4,a4,0x17
80007cb8:	0087d513          	srl	a0,a5,0x8
80007cbc:	07e2                	sll	a5,a5,0x18
80007cbe:	8fd1                	or	a5,a5,a2
80007cc0:	0007d663          	bgez	a5,80007ccc <.L__addsf3_no_tie>
80007cc4:	0786                	sll	a5,a5,0x1
80007cc6:	0505                	add	a0,a0,1 # f4000001 <__AHB_SRAM_segment_end__+0x3cf8001>
80007cc8:	e391                	bnez	a5,80007ccc <.L__addsf3_no_tie>
80007cca:	9979                	and	a0,a0,-2

80007ccc <.L__addsf3_no_tie>:
80007ccc:	953a                	add	a0,a0,a4
80007cce:	8082                	ret

80007cd0 <.L__addsf3_inf>:
80007cd0:	01771513          	sll	a0,a4,0x17

80007cd4 <.L__addsf3_add_done>:
80007cd4:	8082                	ret

80007cd6 <.L__addsf3_zero>:
80007cd6:	817d                	srl	a0,a0,0x1f
80007cd8:	057e                	sll	a0,a0,0x1f
80007cda:	8082                	ret

80007cdc <.L__addsf3_add_inf_or_nan>:
80007cdc:	00951613          	sll	a2,a0,0x9
80007ce0:	da75                	beqz	a2,80007cd4 <.L__addsf3_add_done>

80007ce2 <.L__addsf3_return_nan>:
80007ce2:	7fc00537          	lui	a0,0x7fc00
80007ce6:	8082                	ret

80007ce8 <.L__addsf3_subtract>:
80007ce8:	8db1                	xor	a1,a1,a2
80007cea:	40b506b3          	sub	a3,a0,a1
80007cee:	00b57563          	bgeu	a0,a1,80007cf8 <.L__addsf3_sub_already_ordered>
80007cf2:	8eb1                	xor	a3,a3,a2
80007cf4:	8d15                	sub	a0,a0,a3
80007cf6:	95b6                	add	a1,a1,a3

80007cf8 <.L__addsf3_sub_already_ordered>:
80007cf8:	00159693          	sll	a3,a1,0x1
80007cfc:	82e1                	srl	a3,a3,0x18
80007cfe:	00151713          	sll	a4,a0,0x1
80007d02:	8361                	srl	a4,a4,0x18
80007d04:	05a2                	sll	a1,a1,0x8
80007d06:	8dd1                	or	a1,a1,a2
80007d08:	0ff00293          	li	t0,255
80007d0c:	0c570c63          	beq	a4,t0,80007de4 <.L__addsf3_sub_inf_or_nan>
80007d10:	c2f5                	beqz	a3,80007df4 <.L__addsf3_sub_zero>
80007d12:	40d706b3          	sub	a3,a4,a3
80007d16:	c695                	beqz	a3,80007d42 <.L__addsf3_exponents_equal>
80007d18:	4285                	li	t0,1
80007d1a:	08569063          	bne	a3,t0,80007d9a <.L__addsf3_exponents_differ_by_more_than_1>
80007d1e:	01755693          	srl	a3,a0,0x17
80007d22:	0526                	sll	a0,a0,0x9
80007d24:	00b532b3          	sltu	t0,a0,a1
80007d28:	8d0d                	sub	a0,a0,a1
80007d2a:	02029263          	bnez	t0,80007d4e <.L__addsf3_normalization_steps>
80007d2e:	06de                	sll	a3,a3,0x17
80007d30:	01751593          	sll	a1,a0,0x17
80007d34:	8125                	srl	a0,a0,0x9
80007d36:	0005d463          	bgez	a1,80007d3e <.L__addsf3_sub_no_tie_single>
80007d3a:	0505                	add	a0,a0,1 # 7fc00001 <__SHARE_RAM_segment_end__+0x7ea80001>
80007d3c:	9979                	and	a0,a0,-2

80007d3e <.L__addsf3_sub_no_tie_single>:
80007d3e:	9536                	add	a0,a0,a3

80007d40 <.L__addsf3_sub_done>:
80007d40:	8082                	ret

80007d42 <.L__addsf3_exponents_equal>:
80007d42:	01755693          	srl	a3,a0,0x17
80007d46:	0526                	sll	a0,a0,0x9
80007d48:	0586                	sll	a1,a1,0x1
80007d4a:	8d0d                	sub	a0,a0,a1
80007d4c:	d975                	beqz	a0,80007d40 <.L__addsf3_sub_done>

80007d4e <.L__addsf3_normalization_steps>:
80007d4e:	4581                	li	a1,0
80007d50:	01055793          	srl	a5,a0,0x10
80007d54:	e399                	bnez	a5,80007d5a <.L1^B1>
80007d56:	0542                	sll	a0,a0,0x10
80007d58:	05c1                	add	a1,a1,16

80007d5a <.L1^B1>:
80007d5a:	01855793          	srl	a5,a0,0x18
80007d5e:	e399                	bnez	a5,80007d64 <.L2^B1>
80007d60:	0522                	sll	a0,a0,0x8
80007d62:	05a1                	add	a1,a1,8

80007d64 <.L2^B1>:
80007d64:	01c55793          	srl	a5,a0,0x1c
80007d68:	e399                	bnez	a5,80007d6e <.L3^B1>
80007d6a:	0512                	sll	a0,a0,0x4
80007d6c:	0591                	add	a1,a1,4

80007d6e <.L3^B1>:
80007d6e:	01e55793          	srl	a5,a0,0x1e
80007d72:	e399                	bnez	a5,80007d78 <.L4^B1>
80007d74:	050a                	sll	a0,a0,0x2
80007d76:	0589                	add	a1,a1,2

80007d78 <.L4^B1>:
80007d78:	00054463          	bltz	a0,80007d80 <.L5^B1>
80007d7c:	0506                	sll	a0,a0,0x1
80007d7e:	0585                	add	a1,a1,1

80007d80 <.L5^B1>:
80007d80:	0585                	add	a1,a1,1
80007d82:	0506                	sll	a0,a0,0x1
80007d84:	00e5f763          	bgeu	a1,a4,80007d92 <.L__addsf3_underflow>
80007d88:	8e8d                	sub	a3,a3,a1
80007d8a:	06de                	sll	a3,a3,0x17
80007d8c:	8125                	srl	a0,a0,0x9
80007d8e:	9536                	add	a0,a0,a3
80007d90:	8082                	ret

80007d92 <.L__addsf3_underflow>:
80007d92:	0086d513          	srl	a0,a3,0x8
80007d96:	057e                	sll	a0,a0,0x1f
80007d98:	8082                	ret

80007d9a <.L__addsf3_exponents_differ_by_more_than_1>:
80007d9a:	42e5                	li	t0,25
80007d9c:	fad2e2e3          	bltu	t0,a3,80007d40 <.L__addsf3_sub_done>
80007da0:	0685                	add	a3,a3,1
80007da2:	40d00733          	neg	a4,a3
80007da6:	00e59733          	sll	a4,a1,a4
80007daa:	00d5d5b3          	srl	a1,a1,a3
80007dae:	00e03733          	snez	a4,a4
80007db2:	95ae                	add	a1,a1,a1
80007db4:	95ba                	add	a1,a1,a4
80007db6:	01755693          	srl	a3,a0,0x17
80007dba:	0522                	sll	a0,a0,0x8
80007dbc:	8d51                	or	a0,a0,a2
80007dbe:	40b50733          	sub	a4,a0,a1
80007dc2:	00074463          	bltz	a4,80007dca <.L__addsf3_sub_already_normalized>
80007dc6:	070a                	sll	a4,a4,0x2
80007dc8:	8305                	srl	a4,a4,0x1

80007dca <.L__addsf3_sub_already_normalized>:
80007dca:	16fd                	add	a3,a3,-1
80007dcc:	06de                	sll	a3,a3,0x17
80007dce:	00875513          	srl	a0,a4,0x8
80007dd2:	0762                	sll	a4,a4,0x18
80007dd4:	00075663          	bgez	a4,80007de0 <.L__addsf3_sub_no_tie>
80007dd8:	0706                	sll	a4,a4,0x1
80007dda:	0505                	add	a0,a0,1
80007ddc:	e311                	bnez	a4,80007de0 <.L__addsf3_sub_no_tie>
80007dde:	9979                	and	a0,a0,-2

80007de0 <.L__addsf3_sub_no_tie>:
80007de0:	9536                	add	a0,a0,a3
80007de2:	8082                	ret

80007de4 <.L__addsf3_sub_inf_or_nan>:
80007de4:	0ff00293          	li	t0,255
80007de8:	ee568de3          	beq	a3,t0,80007ce2 <.L__addsf3_return_nan>
80007dec:	00951593          	sll	a1,a0,0x9
80007df0:	d9a1                	beqz	a1,80007d40 <.L__addsf3_sub_done>
80007df2:	bdc5                	j	80007ce2 <.L__addsf3_return_nan>

80007df4 <.L__addsf3_sub_zero>:
80007df4:	f731                	bnez	a4,80007d40 <.L__addsf3_sub_done>
80007df6:	4501                	li	a0,0
80007df8:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

80007dfa <__ltsf2>:
80007dfa:	ff000637          	lui	a2,0xff000
80007dfe:	00151693          	sll	a3,a0,0x1
80007e02:	02d66763          	bltu	a2,a3,80007e30 <.L__ltsf2_zero>
80007e06:	00159693          	sll	a3,a1,0x1
80007e0a:	02d66363          	bltu	a2,a3,80007e30 <.L__ltsf2_zero>
80007e0e:	00b56633          	or	a2,a0,a1
80007e12:	00161693          	sll	a3,a2,0x1
80007e16:	ce89                	beqz	a3,80007e30 <.L__ltsf2_zero>
80007e18:	00064763          	bltz	a2,80007e26 <.L__ltsf2_negative>
80007e1c:	00b53533          	sltu	a0,a0,a1
80007e20:	40a00533          	neg	a0,a0
80007e24:	8082                	ret

80007e26 <.L__ltsf2_negative>:
80007e26:	00a5b533          	sltu	a0,a1,a0
80007e2a:	40a00533          	neg	a0,a0
80007e2e:	8082                	ret

80007e30 <.L__ltsf2_zero>:
80007e30:	4501                	li	a0,0
80007e32:	8082                	ret

Disassembly of section .text.libc.__lesf2:

80007e34 <__lesf2>:
80007e34:	ff000637          	lui	a2,0xff000
80007e38:	00151693          	sll	a3,a0,0x1
80007e3c:	02d66363          	bltu	a2,a3,80007e62 <.L__lesf2_nan>
80007e40:	00159693          	sll	a3,a1,0x1
80007e44:	00d66f63          	bltu	a2,a3,80007e62 <.L__lesf2_nan>
80007e48:	00b56633          	or	a2,a0,a1
80007e4c:	00161693          	sll	a3,a2,0x1
80007e50:	ca99                	beqz	a3,80007e66 <.L__lesf2_zero>
80007e52:	00064563          	bltz	a2,80007e5c <.L__lesf2_negative>
80007e56:	00a5b533          	sltu	a0,a1,a0
80007e5a:	8082                	ret

80007e5c <.L__lesf2_negative>:
80007e5c:	00b53533          	sltu	a0,a0,a1
80007e60:	8082                	ret

80007e62 <.L__lesf2_nan>:
80007e62:	4505                	li	a0,1
80007e64:	8082                	ret

80007e66 <.L__lesf2_zero>:
80007e66:	4501                	li	a0,0
80007e68:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

80007e6a <__gtsf2>:
80007e6a:	ff000637          	lui	a2,0xff000
80007e6e:	00151693          	sll	a3,a0,0x1
80007e72:	02d66363          	bltu	a2,a3,80007e98 <.L__gtsf2_zero>
80007e76:	00159693          	sll	a3,a1,0x1
80007e7a:	00d66f63          	bltu	a2,a3,80007e98 <.L__gtsf2_zero>
80007e7e:	00b56633          	or	a2,a0,a1
80007e82:	00161693          	sll	a3,a2,0x1
80007e86:	ca89                	beqz	a3,80007e98 <.L__gtsf2_zero>
80007e88:	00064563          	bltz	a2,80007e92 <.L__gtsf2_negative>
80007e8c:	00a5b533          	sltu	a0,a1,a0
80007e90:	8082                	ret

80007e92 <.L__gtsf2_negative>:
80007e92:	00b53533          	sltu	a0,a0,a1
80007e96:	8082                	ret

80007e98 <.L__gtsf2_zero>:
80007e98:	4501                	li	a0,0
80007e9a:	8082                	ret

Disassembly of section .text.libc.__gesf2:

80007e9c <__gesf2>:
80007e9c:	ff000637          	lui	a2,0xff000
80007ea0:	00151693          	sll	a3,a0,0x1
80007ea4:	02d66763          	bltu	a2,a3,80007ed2 <.L__gesf2_nan>
80007ea8:	00159693          	sll	a3,a1,0x1
80007eac:	02d66363          	bltu	a2,a3,80007ed2 <.L__gesf2_nan>
80007eb0:	00b56633          	or	a2,a0,a1
80007eb4:	00161693          	sll	a3,a2,0x1
80007eb8:	ce99                	beqz	a3,80007ed6 <.L__gesf2_zero>
80007eba:	00064763          	bltz	a2,80007ec8 <.L__gesf2_negative>
80007ebe:	00b53533          	sltu	a0,a0,a1
80007ec2:	40a00533          	neg	a0,a0
80007ec6:	8082                	ret

80007ec8 <.L__gesf2_negative>:
80007ec8:	00a5b533          	sltu	a0,a1,a0
80007ecc:	40a00533          	neg	a0,a0
80007ed0:	8082                	ret

80007ed2 <.L__gesf2_nan>:
80007ed2:	557d                	li	a0,-1
80007ed4:	8082                	ret

80007ed6 <.L__gesf2_zero>:
80007ed6:	4501                	li	a0,0
80007ed8:	8082                	ret

Disassembly of section .text.libc.__fixunssfsi:

80007eda <__fixunssfsi>:
80007eda:	02a05763          	blez	a0,80007f08 <.L__fixunssfsi_zero_result>
80007ede:	00151593          	sll	a1,a0,0x1
80007ee2:	81e1                	srl	a1,a1,0x18
80007ee4:	f8158593          	add	a1,a1,-127
80007ee8:	0205c063          	bltz	a1,80007f08 <.L__fixunssfsi_zero_result>
80007eec:	40b005b3          	neg	a1,a1
80007ef0:	05fd                	add	a1,a1,31
80007ef2:	0005c963          	bltz	a1,80007f04 <.L__fixunssfsi_max_result>
80007ef6:	0522                	sll	a0,a0,0x8
80007ef8:	800006b7          	lui	a3,0x80000
80007efc:	8d55                	or	a0,a0,a3
80007efe:	00b55533          	srl	a0,a0,a1
80007f02:	8082                	ret

80007f04 <.L__fixunssfsi_max_result>:
80007f04:	557d                	li	a0,-1
80007f06:	8082                	ret

80007f08 <.L__fixunssfsi_zero_result>:
80007f08:	4501                	li	a0,0
80007f0a:	8082                	ret

Disassembly of section .text.libc.__fixunsdfsi:

80007f0c <__fixunsdfsi>:
80007f0c:	0205c563          	bltz	a1,80007f36 <.L__fixunsdfsi_zero_result>
80007f10:	0145d613          	srl	a2,a1,0x14
80007f14:	c0160613          	add	a2,a2,-1023 # fefffc01 <__APB_SRAM_segment_end__+0xaf0dc01>
80007f18:	00064f63          	bltz	a2,80007f36 <.L__fixunsdfsi_zero_result>
80007f1c:	477d                	li	a4,31
80007f1e:	8f11                	sub	a4,a4,a2
80007f20:	00074d63          	bltz	a4,80007f3a <.L__fixunsdfsi_overflow_result>
80007f24:	8155                	srl	a0,a0,0x15
80007f26:	05ae                	sll	a1,a1,0xb
80007f28:	8d4d                	or	a0,a0,a1
80007f2a:	800006b7          	lui	a3,0x80000
80007f2e:	8d55                	or	a0,a0,a3
80007f30:	00e55533          	srl	a0,a0,a4
80007f34:	8082                	ret

80007f36 <.L__fixunsdfsi_zero_result>:
80007f36:	4501                	li	a0,0
80007f38:	8082                	ret

80007f3a <.L__fixunsdfsi_overflow_result>:
80007f3a:	557d                	li	a0,-1
80007f3c:	8082                	ret

Disassembly of section .text.libc.__floatsisf:

80007f3e <__floatsisf>:
80007f3e:	01f55613          	srl	a2,a0,0x1f
80007f42:	0622                	sll	a2,a2,0x8
80007f44:	09d60613          	add	a2,a2,157
80007f48:	cd29                	beqz	a0,80007fa2 <.L__floatsisf_done>
80007f4a:	41f55693          	sra	a3,a0,0x1f
80007f4e:	00d545b3          	xor	a1,a0,a3
80007f52:	8d95                	sub	a1,a1,a3
80007f54:	0105d693          	srl	a3,a1,0x10
80007f58:	e299                	bnez	a3,80007f5e <.L1^B2>
80007f5a:	05c2                	sll	a1,a1,0x10
80007f5c:	1641                	add	a2,a2,-16

80007f5e <.L1^B2>:
80007f5e:	0185d693          	srl	a3,a1,0x18
80007f62:	e299                	bnez	a3,80007f68 <.L2^B2>
80007f64:	05a2                	sll	a1,a1,0x8
80007f66:	1661                	add	a2,a2,-8

80007f68 <.L2^B2>:
80007f68:	01c5d693          	srl	a3,a1,0x1c
80007f6c:	e299                	bnez	a3,80007f72 <.L3^B2>
80007f6e:	0592                	sll	a1,a1,0x4
80007f70:	1671                	add	a2,a2,-4

80007f72 <.L3^B2>:
80007f72:	01e5d693          	srl	a3,a1,0x1e
80007f76:	e299                	bnez	a3,80007f7c <.L4^B2>
80007f78:	058a                	sll	a1,a1,0x2
80007f7a:	1679                	add	a2,a2,-2

80007f7c <.L4^B2>:
80007f7c:	0005c463          	bltz	a1,80007f84 <.L5^B2>
80007f80:	0586                	sll	a1,a1,0x1
80007f82:	167d                	add	a2,a2,-1

80007f84 <.L5^B2>:
80007f84:	065e                	sll	a2,a2,0x17
80007f86:	0085d513          	srl	a0,a1,0x8
80007f8a:	05de                	sll	a1,a1,0x17
80007f8c:	0005a333          	sltz	t1,a1
80007f90:	95ae                	add	a1,a1,a1
80007f92:	959a                	add	a1,a1,t1
80007f94:	0005d663          	bgez	a1,80007fa0 <.L__floatsisf_round_down>
80007f98:	95ae                	add	a1,a1,a1
80007f9a:	00b035b3          	snez	a1,a1
80007f9e:	952e                	add	a0,a0,a1

80007fa0 <.L__floatsisf_round_down>:
80007fa0:	9532                	add	a0,a0,a2

80007fa2 <.L__floatsisf_done>:
80007fa2:	8082                	ret

Disassembly of section .text.libc.__floatunsisf:

80007fa4 <__floatunsisf>:
80007fa4:	c931                	beqz	a0,80007ff8 <.L__floatunsisf_done>
80007fa6:	09d00613          	li	a2,157
80007faa:	01055693          	srl	a3,a0,0x10
80007fae:	e299                	bnez	a3,80007fb4 <.L1^B8>
80007fb0:	0542                	sll	a0,a0,0x10
80007fb2:	1641                	add	a2,a2,-16

80007fb4 <.L1^B8>:
80007fb4:	01855693          	srl	a3,a0,0x18
80007fb8:	e299                	bnez	a3,80007fbe <.L2^B8>
80007fba:	0522                	sll	a0,a0,0x8
80007fbc:	1661                	add	a2,a2,-8

80007fbe <.L2^B8>:
80007fbe:	01c55693          	srl	a3,a0,0x1c
80007fc2:	e299                	bnez	a3,80007fc8 <.L3^B6>
80007fc4:	0512                	sll	a0,a0,0x4
80007fc6:	1671                	add	a2,a2,-4

80007fc8 <.L3^B6>:
80007fc8:	01e55693          	srl	a3,a0,0x1e
80007fcc:	e299                	bnez	a3,80007fd2 <.L4^B8>
80007fce:	050a                	sll	a0,a0,0x2
80007fd0:	1679                	add	a2,a2,-2

80007fd2 <.L4^B8>:
80007fd2:	00054463          	bltz	a0,80007fda <.L5^B6>
80007fd6:	0506                	sll	a0,a0,0x1
80007fd8:	167d                	add	a2,a2,-1

80007fda <.L5^B6>:
80007fda:	065e                	sll	a2,a2,0x17
80007fdc:	01751593          	sll	a1,a0,0x17
80007fe0:	8121                	srl	a0,a0,0x8
80007fe2:	0005a333          	sltz	t1,a1
80007fe6:	95ae                	add	a1,a1,a1
80007fe8:	959a                	add	a1,a1,t1
80007fea:	0005d663          	bgez	a1,80007ff6 <.L__floatunsisf_round_down>
80007fee:	95ae                	add	a1,a1,a1
80007ff0:	00b035b3          	snez	a1,a1
80007ff4:	952e                	add	a0,a0,a1

80007ff6 <.L__floatunsisf_round_down>:
80007ff6:	9532                	add	a0,a0,a2

80007ff8 <.L__floatunsisf_done>:
80007ff8:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

80007ffa <__floatundisf>:
80007ffa:	c5bd                	beqz	a1,80008068 <.L__floatundisf_high_word_zero>
80007ffc:	4701                	li	a4,0
80007ffe:	0105d693          	srl	a3,a1,0x10
80008002:	e299                	bnez	a3,80008008 <.L8^B3>
80008004:	0741                	add	a4,a4,16
80008006:	05c2                	sll	a1,a1,0x10

80008008 <.L8^B3>:
80008008:	0185d693          	srl	a3,a1,0x18
8000800c:	e299                	bnez	a3,80008012 <.L4^B10>
8000800e:	0721                	add	a4,a4,8
80008010:	05a2                	sll	a1,a1,0x8

80008012 <.L4^B10>:
80008012:	01c5d693          	srl	a3,a1,0x1c
80008016:	e299                	bnez	a3,8000801c <.L2^B10>
80008018:	0711                	add	a4,a4,4
8000801a:	0592                	sll	a1,a1,0x4

8000801c <.L2^B10>:
8000801c:	01e5d693          	srl	a3,a1,0x1e
80008020:	e299                	bnez	a3,80008026 <.L1^B10>
80008022:	0709                	add	a4,a4,2
80008024:	058a                	sll	a1,a1,0x2

80008026 <.L1^B10>:
80008026:	0005c463          	bltz	a1,8000802e <.L0^B3>
8000802a:	0705                	add	a4,a4,1
8000802c:	0586                	sll	a1,a1,0x1

8000802e <.L0^B3>:
8000802e:	fff74613          	not	a2,a4
80008032:	00c556b3          	srl	a3,a0,a2
80008036:	8285                	srl	a3,a3,0x1
80008038:	8dd5                	or	a1,a1,a3
8000803a:	00e51533          	sll	a0,a0,a4
8000803e:	0be60613          	add	a2,a2,190
80008042:	00a03533          	snez	a0,a0
80008046:	8dc9                	or	a1,a1,a0

80008048 <.L__floatundisf_round_and_pack>:
80008048:	065e                	sll	a2,a2,0x17
8000804a:	0085d513          	srl	a0,a1,0x8
8000804e:	05de                	sll	a1,a1,0x17
80008050:	0005a333          	sltz	t1,a1
80008054:	95ae                	add	a1,a1,a1
80008056:	959a                	add	a1,a1,t1
80008058:	0005d663          	bgez	a1,80008064 <.L__floatundisf_round_down>
8000805c:	95ae                	add	a1,a1,a1
8000805e:	00b035b3          	snez	a1,a1
80008062:	952e                	add	a0,a0,a1

80008064 <.L__floatundisf_round_down>:
80008064:	9532                	add	a0,a0,a2

80008066 <.L__floatundisf_done>:
80008066:	8082                	ret

80008068 <.L__floatundisf_high_word_zero>:
80008068:	dd7d                	beqz	a0,80008066 <.L__floatundisf_done>
8000806a:	09d00613          	li	a2,157
8000806e:	01055693          	srl	a3,a0,0x10
80008072:	e299                	bnez	a3,80008078 <.L1^B11>
80008074:	0542                	sll	a0,a0,0x10
80008076:	1641                	add	a2,a2,-16

80008078 <.L1^B11>:
80008078:	01855693          	srl	a3,a0,0x18
8000807c:	e299                	bnez	a3,80008082 <.L2^B11>
8000807e:	0522                	sll	a0,a0,0x8
80008080:	1661                	add	a2,a2,-8

80008082 <.L2^B11>:
80008082:	01c55693          	srl	a3,a0,0x1c
80008086:	e299                	bnez	a3,8000808c <.L3^B8>
80008088:	0512                	sll	a0,a0,0x4
8000808a:	1671                	add	a2,a2,-4

8000808c <.L3^B8>:
8000808c:	01e55693          	srl	a3,a0,0x1e
80008090:	e299                	bnez	a3,80008096 <.L4^B11>
80008092:	050a                	sll	a0,a0,0x2
80008094:	1679                	add	a2,a2,-2

80008096 <.L4^B11>:
80008096:	00054463          	bltz	a0,8000809e <.L5^B8>
8000809a:	0506                	sll	a0,a0,0x1
8000809c:	167d                	add	a2,a2,-1

8000809e <.L5^B8>:
8000809e:	85aa                	mv	a1,a0
800080a0:	4501                	li	a0,0
800080a2:	b75d                	j	80008048 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

800080a4 <__truncdfsf2>:
800080a4:	00159693          	sll	a3,a1,0x1
800080a8:	82d5                	srl	a3,a3,0x15
800080aa:	7ff00613          	li	a2,2047
800080ae:	04c68663          	beq	a3,a2,800080fa <.L__truncdfsf2_inf_nan>
800080b2:	c8068693          	add	a3,a3,-896 # 7ffffc80 <__SHARE_RAM_segment_end__+0x7ee7fc80>
800080b6:	02d05e63          	blez	a3,800080f2 <.L__truncdfsf2_underflow>
800080ba:	0ff00613          	li	a2,255
800080be:	04c6f263          	bgeu	a3,a2,80008102 <.L__truncdfsf2_inf>
800080c2:	06de                	sll	a3,a3,0x17
800080c4:	01f5d613          	srl	a2,a1,0x1f
800080c8:	067e                	sll	a2,a2,0x1f
800080ca:	8ed1                	or	a3,a3,a2
800080cc:	05b2                	sll	a1,a1,0xc
800080ce:	01455613          	srl	a2,a0,0x14
800080d2:	8dd1                	or	a1,a1,a2
800080d4:	81a5                	srl	a1,a1,0x9
800080d6:	00251613          	sll	a2,a0,0x2
800080da:	00062733          	sltz	a4,a2
800080de:	9632                	add	a2,a2,a2
800080e0:	000627b3          	sltz	a5,a2
800080e4:	9632                	add	a2,a2,a2
800080e6:	963a                	add	a2,a2,a4
800080e8:	c211                	beqz	a2,800080ec <.L__truncdfsf2_no_round_tie>
800080ea:	95be                	add	a1,a1,a5

800080ec <.L__truncdfsf2_no_round_tie>:
800080ec:	00d58533          	add	a0,a1,a3
800080f0:	8082                	ret

800080f2 <.L__truncdfsf2_underflow>:
800080f2:	01f5d513          	srl	a0,a1,0x1f
800080f6:	057e                	sll	a0,a0,0x1f
800080f8:	8082                	ret

800080fa <.L__truncdfsf2_inf_nan>:
800080fa:	00c59693          	sll	a3,a1,0xc
800080fe:	8ec9                	or	a3,a3,a0
80008100:	ea81                	bnez	a3,80008110 <.L__truncdfsf2_nan>

80008102 <.L__truncdfsf2_inf>:
80008102:	81fd                	srl	a1,a1,0x1f
80008104:	05fe                	sll	a1,a1,0x1f
80008106:	7f800537          	lui	a0,0x7f800
8000810a:	8d4d                	or	a0,a0,a1
8000810c:	4581                	li	a1,0
8000810e:	8082                	ret

80008110 <.L__truncdfsf2_nan>:
80008110:	800006b7          	lui	a3,0x80000
80008114:	00d5f633          	and	a2,a1,a3
80008118:	058e                	sll	a1,a1,0x3
8000811a:	8175                	srl	a0,a0,0x1d
8000811c:	8d4d                	or	a0,a0,a1
8000811e:	0506                	sll	a0,a0,0x1
80008120:	8105                	srl	a0,a0,0x1
80008122:	8d51                	or	a0,a0,a2
80008124:	82a5                	srl	a3,a3,0x9
80008126:	8d55                	or	a0,a0,a3
80008128:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

8000812a <__SEGGER_RTL_ldouble_to_double>:
8000812a:	4158                	lw	a4,4(a0)
8000812c:	451c                	lw	a5,8(a0)
8000812e:	4554                	lw	a3,12(a0)
80008130:	1141                	add	sp,sp,-16
80008132:	c23a                	sw	a4,4(sp)
80008134:	c43e                	sw	a5,8(sp)
80008136:	7771                	lui	a4,0xffffc
80008138:	00169793          	sll	a5,a3,0x1
8000813c:	83c5                	srl	a5,a5,0x11
8000813e:	40070713          	add	a4,a4,1024 # ffffc400 <__APB_SRAM_segment_end__+0xbf0a400>
80008142:	c636                	sw	a3,12(sp)
80008144:	97ba                	add	a5,a5,a4
80008146:	00f04a63          	bgtz	a5,8000815a <.L27>
8000814a:	800007b7          	lui	a5,0x80000
8000814e:	4701                	li	a4,0
80008150:	8ff5                	and	a5,a5,a3

80008152 <.L28>:
80008152:	853a                	mv	a0,a4
80008154:	85be                	mv	a1,a5
80008156:	0141                	add	sp,sp,16
80008158:	8082                	ret

8000815a <.L27>:
8000815a:	6711                	lui	a4,0x4
8000815c:	3ff70713          	add	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
80008160:	00e78c63          	beq	a5,a4,80008178 <.L29>
80008164:	7ff00713          	li	a4,2047
80008168:	00f75a63          	bge	a4,a5,8000817c <.L30>
8000816c:	4781                	li	a5,0
8000816e:	4801                	li	a6,0
80008170:	c43e                	sw	a5,8(sp)
80008172:	c642                	sw	a6,12(sp)
80008174:	c03e                	sw	a5,0(sp)
80008176:	c242                	sw	a6,4(sp)

80008178 <.L29>:
80008178:	7ff00793          	li	a5,2047

8000817c <.L30>:
8000817c:	45a2                	lw	a1,8(sp)
8000817e:	4732                	lw	a4,12(sp)
80008180:	80000637          	lui	a2,0x80000
80008184:	01c5d513          	srl	a0,a1,0x1c
80008188:	8e79                	and	a2,a2,a4
8000818a:	0712                	sll	a4,a4,0x4
8000818c:	4692                	lw	a3,4(sp)
8000818e:	8f49                	or	a4,a4,a0
80008190:	0732                	sll	a4,a4,0xc
80008192:	8331                	srl	a4,a4,0xc
80008194:	8e59                	or	a2,a2,a4
80008196:	82f1                	srl	a3,a3,0x1c
80008198:	0592                	sll	a1,a1,0x4
8000819a:	07d2                	sll	a5,a5,0x14
8000819c:	00b6e733          	or	a4,a3,a1
800081a0:	8fd1                	or	a5,a5,a2
800081a2:	bf45                	j	80008152 <.L28>

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

800081a4 <__SEGGER_RTL_float32_isnan>:
800081a4:	ff0007b7          	lui	a5,0xff000
800081a8:	0785                	add	a5,a5,1 # ff000001 <__APB_SRAM_segment_end__+0xaf0e001>
800081aa:	0506                	sll	a0,a0,0x1
800081ac:	00f53533          	sltu	a0,a0,a5
800081b0:	00154513          	xor	a0,a0,1
800081b4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

800081b6 <__SEGGER_RTL_float32_isinf>:
800081b6:	010007b7          	lui	a5,0x1000
800081ba:	0506                	sll	a0,a0,0x1
800081bc:	953e                	add	a0,a0,a5
800081be:	00153513          	seqz	a0,a0
800081c2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

800081c4 <__SEGGER_RTL_float32_isnormal>:
800081c4:	ff0007b7          	lui	a5,0xff000
800081c8:	0506                	sll	a0,a0,0x1
800081ca:	953e                	add	a0,a0,a5
800081cc:	fe0007b7          	lui	a5,0xfe000
800081d0:	00f53533          	sltu	a0,a0,a5
800081d4:	8082                	ret

Disassembly of section .text.libc.floorf:

800081d6 <floorf>:
800081d6:	00151693          	sll	a3,a0,0x1
800081da:	82e1                	srl	a3,a3,0x18
800081dc:	01755793          	srl	a5,a0,0x17
800081e0:	16fd                	add	a3,a3,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
800081e2:	0fd00613          	li	a2,253
800081e6:	872a                	mv	a4,a0
800081e8:	0ff7f793          	zext.b	a5,a5
800081ec:	00d67963          	bgeu	a2,a3,800081fe <.L1240>
800081f0:	e789                	bnez	a5,800081fa <.L1241>
800081f2:	800007b7          	lui	a5,0x80000
800081f6:	00f57733          	and	a4,a0,a5

800081fa <.L1241>:
800081fa:	853a                	mv	a0,a4
800081fc:	8082                	ret

800081fe <.L1240>:
800081fe:	f8178793          	add	a5,a5,-127 # 7fffff81 <__SHARE_RAM_segment_end__+0x7ee7ff81>
80008202:	0007db63          	bgez	a5,80008218 <.L1243>
80008206:	00000513          	li	a0,0
8000820a:	02075a63          	bgez	a4,8000823e <.L1242>
8000820e:	800047b7          	lui	a5,0x80004
80008212:	b407a503          	lw	a0,-1216(a5) # 80003b40 <.Lmerged_single+0x18>
80008216:	8082                	ret

80008218 <.L1243>:
80008218:	46d9                	li	a3,22
8000821a:	02f6c263          	blt	a3,a5,8000823e <.L1242>
8000821e:	008006b7          	lui	a3,0x800
80008222:	fff68613          	add	a2,a3,-1 # 7fffff <__XPI0_segment_size__+0x2fff>
80008226:	00f65633          	srl	a2,a2,a5
8000822a:	fff64513          	not	a0,a2
8000822e:	8d79                	and	a0,a0,a4
80008230:	8f71                	and	a4,a4,a2
80008232:	c711                	beqz	a4,8000823e <.L1242>
80008234:	00055563          	bgez	a0,8000823e <.L1242>
80008238:	00f6d6b3          	srl	a3,a3,a5
8000823c:	9536                	add	a0,a0,a3

8000823e <.L1242>:
8000823e:	8082                	ret

Disassembly of section .text.libc.__ashldi3:

80008240 <__ashldi3>:
80008240:	02067793          	and	a5,a2,32
80008244:	ef89                	bnez	a5,8000825e <.L__ashldi3LongShift>
80008246:	00155793          	srl	a5,a0,0x1
8000824a:	fff64713          	not	a4,a2
8000824e:	00e7d7b3          	srl	a5,a5,a4
80008252:	00c595b3          	sll	a1,a1,a2
80008256:	8ddd                	or	a1,a1,a5
80008258:	00c51533          	sll	a0,a0,a2
8000825c:	8082                	ret

8000825e <.L__ashldi3LongShift>:
8000825e:	00c515b3          	sll	a1,a0,a2
80008262:	4501                	li	a0,0
80008264:	8082                	ret

Disassembly of section .text.libc.__udivdi3:

80008266 <__udivdi3>:
80008266:	1101                	add	sp,sp,-32
80008268:	cc22                	sw	s0,24(sp)
8000826a:	ca26                	sw	s1,20(sp)
8000826c:	c84a                	sw	s2,16(sp)
8000826e:	c64e                	sw	s3,12(sp)
80008270:	ce06                	sw	ra,28(sp)
80008272:	c452                	sw	s4,8(sp)
80008274:	c256                	sw	s5,4(sp)
80008276:	c05a                	sw	s6,0(sp)
80008278:	842a                	mv	s0,a0
8000827a:	892e                	mv	s2,a1
8000827c:	89b2                	mv	s3,a2
8000827e:	84b6                	mv	s1,a3
80008280:	2e069263          	bnez	a3,80008564 <.L47>
80008284:	ed99                	bnez	a1,800082a2 <.L48>
80008286:	02c55433          	divu	s0,a0,a2

8000828a <.L49>:
8000828a:	40f2                	lw	ra,28(sp)
8000828c:	8522                	mv	a0,s0
8000828e:	4462                	lw	s0,24(sp)
80008290:	44d2                	lw	s1,20(sp)
80008292:	49b2                	lw	s3,12(sp)
80008294:	4a22                	lw	s4,8(sp)
80008296:	4a92                	lw	s5,4(sp)
80008298:	4b02                	lw	s6,0(sp)
8000829a:	85ca                	mv	a1,s2
8000829c:	4942                	lw	s2,16(sp)
8000829e:	6105                	add	sp,sp,32
800082a0:	8082                	ret

800082a2 <.L48>:
800082a2:	010007b7          	lui	a5,0x1000
800082a6:	12f67863          	bgeu	a2,a5,800083d6 <.L50>
800082aa:	4791                	li	a5,4
800082ac:	08c7e763          	bltu	a5,a2,8000833a <.L52>
800082b0:	470d                	li	a4,3
800082b2:	02e60263          	beq	a2,a4,800082d6 <.L54>
800082b6:	06f60a63          	beq	a2,a5,8000832a <.L55>
800082ba:	4785                	li	a5,1
800082bc:	fcf607e3          	beq	a2,a5,8000828a <.L49>
800082c0:	4789                	li	a5,2
800082c2:	3cf61063          	bne	a2,a5,80008682 <.L88>
800082c6:	01f59793          	sll	a5,a1,0x1f
800082ca:	00155413          	srl	s0,a0,0x1
800082ce:	8c5d                	or	s0,s0,a5
800082d0:	0015d913          	srl	s2,a1,0x1
800082d4:	bf5d                	j	8000828a <.L49>

800082d6 <.L54>:
800082d6:	555557b7          	lui	a5,0x55555
800082da:	55578793          	add	a5,a5,1365 # 55555555 <__SHARE_RAM_segment_end__+0x543d5555>
800082de:	02b7b6b3          	mulhu	a3,a5,a1
800082e2:	02a7b633          	mulhu	a2,a5,a0
800082e6:	02a78733          	mul	a4,a5,a0
800082ea:	02b787b3          	mul	a5,a5,a1
800082ee:	97b2                	add	a5,a5,a2
800082f0:	00c7b633          	sltu	a2,a5,a2
800082f4:	9636                	add	a2,a2,a3
800082f6:	00f706b3          	add	a3,a4,a5
800082fa:	00e6b733          	sltu	a4,a3,a4
800082fe:	9732                	add	a4,a4,a2
80008300:	97ba                	add	a5,a5,a4
80008302:	00e7b5b3          	sltu	a1,a5,a4
80008306:	9736                	add	a4,a4,a3
80008308:	00d736b3          	sltu	a3,a4,a3
8000830c:	0705                	add	a4,a4,1
8000830e:	97b6                	add	a5,a5,a3
80008310:	00173713          	seqz	a4,a4
80008314:	00d7b6b3          	sltu	a3,a5,a3
80008318:	962e                	add	a2,a2,a1
8000831a:	97ba                	add	a5,a5,a4
8000831c:	00c68933          	add	s2,a3,a2
80008320:	00e7b733          	sltu	a4,a5,a4
80008324:	843e                	mv	s0,a5
80008326:	993a                	add	s2,s2,a4
80008328:	b78d                	j	8000828a <.L49>

8000832a <.L55>:
8000832a:	01e59793          	sll	a5,a1,0x1e
8000832e:	00255413          	srl	s0,a0,0x2
80008332:	8c5d                	or	s0,s0,a5
80008334:	0025d913          	srl	s2,a1,0x2
80008338:	bf89                	j	8000828a <.L49>

8000833a <.L52>:
8000833a:	67c1                	lui	a5,0x10
8000833c:	02c5d6b3          	divu	a3,a1,a2
80008340:	01055713          	srl	a4,a0,0x10
80008344:	02f67a63          	bgeu	a2,a5,80008378 <.L62>
80008348:	01051413          	sll	s0,a0,0x10
8000834c:	8041                	srl	s0,s0,0x10
8000834e:	02c687b3          	mul	a5,a3,a2
80008352:	40f587b3          	sub	a5,a1,a5
80008356:	07c2                	sll	a5,a5,0x10
80008358:	97ba                	add	a5,a5,a4
8000835a:	02c7d933          	divu	s2,a5,a2
8000835e:	02c90733          	mul	a4,s2,a2
80008362:	0942                	sll	s2,s2,0x10
80008364:	8f99                	sub	a5,a5,a4
80008366:	07c2                	sll	a5,a5,0x10
80008368:	943e                	add	s0,s0,a5
8000836a:	02c45433          	divu	s0,s0,a2
8000836e:	944a                	add	s0,s0,s2
80008370:	01243933          	sltu	s2,s0,s2
80008374:	9936                	add	s2,s2,a3
80008376:	bf11                	j	8000828a <.L49>

80008378 <.L62>:
80008378:	02c687b3          	mul	a5,a3,a2
8000837c:	01855613          	srl	a2,a0,0x18
80008380:	0ff77713          	zext.b	a4,a4
80008384:	0ff47413          	zext.b	s0,s0
80008388:	8936                	mv	s2,a3
8000838a:	40f587b3          	sub	a5,a1,a5
8000838e:	07a2                	sll	a5,a5,0x8
80008390:	963e                	add	a2,a2,a5
80008392:	033657b3          	divu	a5,a2,s3
80008396:	033785b3          	mul	a1,a5,s3
8000839a:	07a2                	sll	a5,a5,0x8
8000839c:	8e0d                	sub	a2,a2,a1
8000839e:	0622                	sll	a2,a2,0x8
800083a0:	9732                	add	a4,a4,a2
800083a2:	033755b3          	divu	a1,a4,s3
800083a6:	97ae                	add	a5,a5,a1
800083a8:	07a2                	sll	a5,a5,0x8
800083aa:	03358633          	mul	a2,a1,s3
800083ae:	8f11                	sub	a4,a4,a2
800083b0:	00855613          	srl	a2,a0,0x8
800083b4:	0ff67613          	zext.b	a2,a2
800083b8:	0722                	sll	a4,a4,0x8
800083ba:	9732                	add	a4,a4,a2
800083bc:	03375633          	divu	a2,a4,s3
800083c0:	97b2                	add	a5,a5,a2
800083c2:	07a2                	sll	a5,a5,0x8
800083c4:	03360533          	mul	a0,a2,s3
800083c8:	8f09                	sub	a4,a4,a0
800083ca:	0722                	sll	a4,a4,0x8
800083cc:	943a                	add	s0,s0,a4
800083ce:	03345433          	divu	s0,s0,s3
800083d2:	943e                	add	s0,s0,a5
800083d4:	bd5d                	j	8000828a <.L49>

800083d6 <.L50>:
800083d6:	80003ab7          	lui	s5,0x80003
800083da:	4f4a8a93          	add	s5,s5,1268 # 800034f4 <__SEGGER_RTL_Moeller_inverse_lut>
800083de:	0cc5f063          	bgeu	a1,a2,8000849e <.L64>
800083e2:	10000737          	lui	a4,0x10000
800083e6:	87b2                	mv	a5,a2
800083e8:	00e67563          	bgeu	a2,a4,800083f2 <.L65>
800083ec:	00461793          	sll	a5,a2,0x4
800083f0:	4491                	li	s1,4

800083f2 <.L65>:
800083f2:	40000737          	lui	a4,0x40000
800083f6:	00e7f463          	bgeu	a5,a4,800083fe <.L66>
800083fa:	0489                	add	s1,s1,2
800083fc:	078a                	sll	a5,a5,0x2

800083fe <.L66>:
800083fe:	0007c363          	bltz	a5,80008404 <.L67>
80008402:	0485                	add	s1,s1,1

80008404 <.L67>:
80008404:	8626                	mv	a2,s1
80008406:	8522                	mv	a0,s0
80008408:	85ca                	mv	a1,s2
8000840a:	3d1d                	jal	80008240 <__ashldi3>
8000840c:	009994b3          	sll	s1,s3,s1
80008410:	0164d793          	srl	a5,s1,0x16
80008414:	e0078793          	add	a5,a5,-512 # fe00 <__XPI0_segment_used_size__+0x3dac>
80008418:	0786                	sll	a5,a5,0x1
8000841a:	97d6                	add	a5,a5,s5
8000841c:	0007d783          	lhu	a5,0(a5)
80008420:	00b4d813          	srl	a6,s1,0xb
80008424:	0014f713          	and	a4,s1,1
80008428:	02f78633          	mul	a2,a5,a5
8000842c:	0792                	sll	a5,a5,0x4
8000842e:	0014d693          	srl	a3,s1,0x1
80008432:	0805                	add	a6,a6,1
80008434:	03063633          	mulhu	a2,a2,a6
80008438:	8f91                	sub	a5,a5,a2
8000843a:	96ba                	add	a3,a3,a4
8000843c:	17fd                	add	a5,a5,-1
8000843e:	c319                	beqz	a4,80008444 <.L68>
80008440:	0017d713          	srl	a4,a5,0x1

80008444 <.L68>:
80008444:	02f686b3          	mul	a3,a3,a5
80008448:	8f15                	sub	a4,a4,a3
8000844a:	02e7b733          	mulhu	a4,a5,a4
8000844e:	07be                	sll	a5,a5,0xf
80008450:	8305                	srl	a4,a4,0x1
80008452:	97ba                	add	a5,a5,a4
80008454:	8726                	mv	a4,s1
80008456:	029786b3          	mul	a3,a5,s1
8000845a:	9736                	add	a4,a4,a3
8000845c:	00d736b3          	sltu	a3,a4,a3
80008460:	8726                	mv	a4,s1
80008462:	9736                	add	a4,a4,a3
80008464:	0297b6b3          	mulhu	a3,a5,s1
80008468:	9736                	add	a4,a4,a3
8000846a:	8f99                	sub	a5,a5,a4
8000846c:	02b7b733          	mulhu	a4,a5,a1
80008470:	02b787b3          	mul	a5,a5,a1
80008474:	00a786b3          	add	a3,a5,a0
80008478:	00f6b7b3          	sltu	a5,a3,a5
8000847c:	95be                	add	a1,a1,a5
8000847e:	00b707b3          	add	a5,a4,a1
80008482:	00178413          	add	s0,a5,1
80008486:	02848733          	mul	a4,s1,s0
8000848a:	8d19                	sub	a0,a0,a4
8000848c:	00a6f463          	bgeu	a3,a0,80008494 <.L69>
80008490:	9526                	add	a0,a0,s1
80008492:	843e                	mv	s0,a5

80008494 <.L69>:
80008494:	00956363          	bltu	a0,s1,8000849a <.L109>
80008498:	0405                	add	s0,s0,1

8000849a <.L109>:
8000849a:	4901                	li	s2,0
8000849c:	b3fd                	j	8000828a <.L49>

8000849e <.L64>:
8000849e:	02c5da33          	divu	s4,a1,a2
800084a2:	10000737          	lui	a4,0x10000
800084a6:	87b2                	mv	a5,a2
800084a8:	02ca05b3          	mul	a1,s4,a2
800084ac:	40b905b3          	sub	a1,s2,a1
800084b0:	00e67563          	bgeu	a2,a4,800084ba <.L71>
800084b4:	00461793          	sll	a5,a2,0x4
800084b8:	4491                	li	s1,4

800084ba <.L71>:
800084ba:	40000737          	lui	a4,0x40000
800084be:	00e7f463          	bgeu	a5,a4,800084c6 <.L72>
800084c2:	0489                	add	s1,s1,2
800084c4:	078a                	sll	a5,a5,0x2

800084c6 <.L72>:
800084c6:	0007c363          	bltz	a5,800084cc <.L73>
800084ca:	0485                	add	s1,s1,1

800084cc <.L73>:
800084cc:	8626                	mv	a2,s1
800084ce:	8522                	mv	a0,s0
800084d0:	3b85                	jal	80008240 <__ashldi3>
800084d2:	009994b3          	sll	s1,s3,s1
800084d6:	0164d793          	srl	a5,s1,0x16
800084da:	e0078793          	add	a5,a5,-512
800084de:	0786                	sll	a5,a5,0x1
800084e0:	9abe                	add	s5,s5,a5
800084e2:	000ad783          	lhu	a5,0(s5)
800084e6:	00b4d813          	srl	a6,s1,0xb
800084ea:	0014f713          	and	a4,s1,1
800084ee:	02f78633          	mul	a2,a5,a5
800084f2:	0792                	sll	a5,a5,0x4
800084f4:	0014d693          	srl	a3,s1,0x1
800084f8:	0805                	add	a6,a6,1
800084fa:	03063633          	mulhu	a2,a2,a6
800084fe:	8f91                	sub	a5,a5,a2
80008500:	96ba                	add	a3,a3,a4
80008502:	17fd                	add	a5,a5,-1
80008504:	c319                	beqz	a4,8000850a <.L74>
80008506:	0017d713          	srl	a4,a5,0x1

8000850a <.L74>:
8000850a:	02f686b3          	mul	a3,a3,a5
8000850e:	8f15                	sub	a4,a4,a3
80008510:	02e7b733          	mulhu	a4,a5,a4
80008514:	07be                	sll	a5,a5,0xf
80008516:	8305                	srl	a4,a4,0x1
80008518:	97ba                	add	a5,a5,a4
8000851a:	8726                	mv	a4,s1
8000851c:	029786b3          	mul	a3,a5,s1
80008520:	9736                	add	a4,a4,a3
80008522:	00d736b3          	sltu	a3,a4,a3
80008526:	8726                	mv	a4,s1
80008528:	9736                	add	a4,a4,a3
8000852a:	0297b6b3          	mulhu	a3,a5,s1
8000852e:	9736                	add	a4,a4,a3
80008530:	8f99                	sub	a5,a5,a4
80008532:	02b7b733          	mulhu	a4,a5,a1
80008536:	02b787b3          	mul	a5,a5,a1
8000853a:	00a786b3          	add	a3,a5,a0
8000853e:	00f6b7b3          	sltu	a5,a3,a5
80008542:	95be                	add	a1,a1,a5
80008544:	00b707b3          	add	a5,a4,a1
80008548:	00178413          	add	s0,a5,1
8000854c:	02848733          	mul	a4,s1,s0
80008550:	8d19                	sub	a0,a0,a4
80008552:	00a6f463          	bgeu	a3,a0,8000855a <.L75>
80008556:	9526                	add	a0,a0,s1
80008558:	843e                	mv	s0,a5

8000855a <.L75>:
8000855a:	00956363          	bltu	a0,s1,80008560 <.L76>
8000855e:	0405                	add	s0,s0,1

80008560 <.L76>:
80008560:	8952                	mv	s2,s4
80008562:	b325                	j	8000828a <.L49>

80008564 <.L47>:
80008564:	67c1                	lui	a5,0x10
80008566:	8ab6                	mv	s5,a3
80008568:	4a01                	li	s4,0
8000856a:	00f6f563          	bgeu	a3,a5,80008574 <.L77>
8000856e:	01069493          	sll	s1,a3,0x10
80008572:	4a41                	li	s4,16

80008574 <.L77>:
80008574:	010007b7          	lui	a5,0x1000
80008578:	00f4f463          	bgeu	s1,a5,80008580 <.L78>
8000857c:	0a21                	add	s4,s4,8
8000857e:	04a2                	sll	s1,s1,0x8

80008580 <.L78>:
80008580:	100007b7          	lui	a5,0x10000
80008584:	00f4f463          	bgeu	s1,a5,8000858c <.L79>
80008588:	0a11                	add	s4,s4,4
8000858a:	0492                	sll	s1,s1,0x4

8000858c <.L79>:
8000858c:	400007b7          	lui	a5,0x40000
80008590:	00f4f463          	bgeu	s1,a5,80008598 <.L80>
80008594:	0a09                	add	s4,s4,2
80008596:	048a                	sll	s1,s1,0x2

80008598 <.L80>:
80008598:	0004c363          	bltz	s1,8000859e <.L81>
8000859c:	0a05                	add	s4,s4,1

8000859e <.L81>:
8000859e:	01f91793          	sll	a5,s2,0x1f
800085a2:	8652                	mv	a2,s4
800085a4:	00145493          	srl	s1,s0,0x1
800085a8:	854e                	mv	a0,s3
800085aa:	85d6                	mv	a1,s5
800085ac:	8cdd                	or	s1,s1,a5
800085ae:	3949                	jal	80008240 <__ashldi3>
800085b0:	0165d613          	srl	a2,a1,0x16
800085b4:	800037b7          	lui	a5,0x80003
800085b8:	e0060613          	add	a2,a2,-512 # 7ffffe00 <__SHARE_RAM_segment_end__+0x7ee7fe00>
800085bc:	0606                	sll	a2,a2,0x1
800085be:	4f478793          	add	a5,a5,1268 # 800034f4 <__SEGGER_RTL_Moeller_inverse_lut>
800085c2:	97b2                	add	a5,a5,a2
800085c4:	0007d783          	lhu	a5,0(a5)
800085c8:	00b5d513          	srl	a0,a1,0xb
800085cc:	0015f713          	and	a4,a1,1
800085d0:	02f78633          	mul	a2,a5,a5
800085d4:	0792                	sll	a5,a5,0x4
800085d6:	0015d693          	srl	a3,a1,0x1
800085da:	0505                	add	a0,a0,1 # 7f800001 <__SHARE_RAM_segment_end__+0x7e680001>
800085dc:	02a63633          	mulhu	a2,a2,a0
800085e0:	8f91                	sub	a5,a5,a2
800085e2:	00195b13          	srl	s6,s2,0x1
800085e6:	96ba                	add	a3,a3,a4
800085e8:	17fd                	add	a5,a5,-1
800085ea:	c319                	beqz	a4,800085f0 <.L82>
800085ec:	0017d713          	srl	a4,a5,0x1

800085f0 <.L82>:
800085f0:	02f686b3          	mul	a3,a3,a5
800085f4:	8f15                	sub	a4,a4,a3
800085f6:	02e7b733          	mulhu	a4,a5,a4
800085fa:	07be                	sll	a5,a5,0xf
800085fc:	8305                	srl	a4,a4,0x1
800085fe:	97ba                	add	a5,a5,a4
80008600:	872e                	mv	a4,a1
80008602:	02b786b3          	mul	a3,a5,a1
80008606:	9736                	add	a4,a4,a3
80008608:	00d736b3          	sltu	a3,a4,a3
8000860c:	872e                	mv	a4,a1
8000860e:	9736                	add	a4,a4,a3
80008610:	02b7b6b3          	mulhu	a3,a5,a1
80008614:	9736                	add	a4,a4,a3
80008616:	8f99                	sub	a5,a5,a4
80008618:	0367b733          	mulhu	a4,a5,s6
8000861c:	036787b3          	mul	a5,a5,s6
80008620:	009786b3          	add	a3,a5,s1
80008624:	00f6b7b3          	sltu	a5,a3,a5
80008628:	97da                	add	a5,a5,s6
8000862a:	973e                	add	a4,a4,a5
8000862c:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
80008630:	02f58633          	mul	a2,a1,a5
80008634:	8c91                	sub	s1,s1,a2
80008636:	0096f463          	bgeu	a3,s1,8000863e <.L83>
8000863a:	94ae                	add	s1,s1,a1
8000863c:	87ba                	mv	a5,a4

8000863e <.L83>:
8000863e:	00b4e363          	bltu	s1,a1,80008644 <.L84>
80008642:	0785                	add	a5,a5,1

80008644 <.L84>:
80008644:	477d                	li	a4,31
80008646:	41470733          	sub	a4,a4,s4
8000864a:	00e7d633          	srl	a2,a5,a4
8000864e:	c211                	beqz	a2,80008652 <.L85>
80008650:	167d                	add	a2,a2,-1

80008652 <.L85>:
80008652:	02ca87b3          	mul	a5,s5,a2
80008656:	03360733          	mul	a4,a2,s3
8000865a:	033636b3          	mulhu	a3,a2,s3
8000865e:	40e40733          	sub	a4,s0,a4
80008662:	00e43433          	sltu	s0,s0,a4
80008666:	97b6                	add	a5,a5,a3
80008668:	40f907b3          	sub	a5,s2,a5
8000866c:	40878433          	sub	s0,a5,s0
80008670:	01546763          	bltu	s0,s5,8000867e <.L86>
80008674:	008a9463          	bne	s5,s0,8000867c <.L95>
80008678:	01376363          	bltu	a4,s3,8000867e <.L86>

8000867c <.L95>:
8000867c:	0605                	add	a2,a2,1

8000867e <.L86>:
8000867e:	8432                	mv	s0,a2
80008680:	bd29                	j	8000849a <.L109>

80008682 <.L88>:
80008682:	4401                	li	s0,0
80008684:	bd19                	j	8000849a <.L109>

Disassembly of section .text.libc.__umoddi3:

80008686 <__umoddi3>:
80008686:	1101                	add	sp,sp,-32
80008688:	cc22                	sw	s0,24(sp)
8000868a:	ca26                	sw	s1,20(sp)
8000868c:	c84a                	sw	s2,16(sp)
8000868e:	c64e                	sw	s3,12(sp)
80008690:	c452                	sw	s4,8(sp)
80008692:	ce06                	sw	ra,28(sp)
80008694:	c256                	sw	s5,4(sp)
80008696:	c05a                	sw	s6,0(sp)
80008698:	892a                	mv	s2,a0
8000869a:	84ae                	mv	s1,a1
8000869c:	8432                	mv	s0,a2
8000869e:	89b6                	mv	s3,a3
800086a0:	8a36                	mv	s4,a3
800086a2:	2e069e63          	bnez	a3,8000899e <.L111>
800086a6:	e589                	bnez	a1,800086b0 <.L112>
800086a8:	02c557b3          	divu	a5,a0,a2

800086ac <.L174>:
800086ac:	4701                	li	a4,0
800086ae:	a815                	j	800086e2 <.L113>

800086b0 <.L112>:
800086b0:	010007b7          	lui	a5,0x1000
800086b4:	16f67163          	bgeu	a2,a5,80008816 <.L114>
800086b8:	4791                	li	a5,4
800086ba:	0cc7e063          	bltu	a5,a2,8000877a <.L116>
800086be:	470d                	li	a4,3
800086c0:	04e60d63          	beq	a2,a4,8000871a <.L118>
800086c4:	0af60363          	beq	a2,a5,8000876a <.L119>
800086c8:	4785                	li	a5,1
800086ca:	3ef60763          	beq	a2,a5,80008ab8 <.L152>
800086ce:	4789                	li	a5,2
800086d0:	3ef61763          	bne	a2,a5,80008abe <.L153>
800086d4:	01f59713          	sll	a4,a1,0x1f
800086d8:	00155793          	srl	a5,a0,0x1
800086dc:	8fd9                	or	a5,a5,a4
800086de:	0015d713          	srl	a4,a1,0x1

800086e2 <.L113>:
800086e2:	02870733          	mul	a4,a4,s0
800086e6:	40f2                	lw	ra,28(sp)
800086e8:	4a22                	lw	s4,8(sp)
800086ea:	4a92                	lw	s5,4(sp)
800086ec:	4b02                	lw	s6,0(sp)
800086ee:	02f989b3          	mul	s3,s3,a5
800086f2:	02f40533          	mul	a0,s0,a5
800086f6:	99ba                	add	s3,s3,a4
800086f8:	02f43433          	mulhu	s0,s0,a5
800086fc:	40a90533          	sub	a0,s2,a0
80008700:	00a935b3          	sltu	a1,s2,a0
80008704:	4942                	lw	s2,16(sp)
80008706:	99a2                	add	s3,s3,s0
80008708:	4462                	lw	s0,24(sp)
8000870a:	413484b3          	sub	s1,s1,s3
8000870e:	40b485b3          	sub	a1,s1,a1
80008712:	49b2                	lw	s3,12(sp)
80008714:	44d2                	lw	s1,20(sp)
80008716:	6105                	add	sp,sp,32
80008718:	8082                	ret

8000871a <.L118>:
8000871a:	555557b7          	lui	a5,0x55555
8000871e:	55578793          	add	a5,a5,1365 # 55555555 <__SHARE_RAM_segment_end__+0x543d5555>
80008722:	02b7b6b3          	mulhu	a3,a5,a1
80008726:	02a7b633          	mulhu	a2,a5,a0
8000872a:	02a78733          	mul	a4,a5,a0
8000872e:	02b787b3          	mul	a5,a5,a1
80008732:	97b2                	add	a5,a5,a2
80008734:	00c7b633          	sltu	a2,a5,a2
80008738:	9636                	add	a2,a2,a3
8000873a:	00f706b3          	add	a3,a4,a5
8000873e:	00e6b733          	sltu	a4,a3,a4
80008742:	9732                	add	a4,a4,a2
80008744:	97ba                	add	a5,a5,a4
80008746:	00e7b5b3          	sltu	a1,a5,a4
8000874a:	9736                	add	a4,a4,a3
8000874c:	00d736b3          	sltu	a3,a4,a3
80008750:	0705                	add	a4,a4,1
80008752:	97b6                	add	a5,a5,a3
80008754:	00173713          	seqz	a4,a4
80008758:	00d7b6b3          	sltu	a3,a5,a3
8000875c:	962e                	add	a2,a2,a1
8000875e:	97ba                	add	a5,a5,a4
80008760:	96b2                	add	a3,a3,a2
80008762:	00e7b733          	sltu	a4,a5,a4
80008766:	9736                	add	a4,a4,a3
80008768:	bfad                	j	800086e2 <.L113>

8000876a <.L119>:
8000876a:	01e59713          	sll	a4,a1,0x1e
8000876e:	00255793          	srl	a5,a0,0x2
80008772:	8fd9                	or	a5,a5,a4
80008774:	0025d713          	srl	a4,a1,0x2
80008778:	b7ad                	j	800086e2 <.L113>

8000877a <.L116>:
8000877a:	67c1                	lui	a5,0x10
8000877c:	02c5d733          	divu	a4,a1,a2
80008780:	01055693          	srl	a3,a0,0x10
80008784:	02f67b63          	bgeu	a2,a5,800087ba <.L126>
80008788:	02c707b3          	mul	a5,a4,a2
8000878c:	40f587b3          	sub	a5,a1,a5
80008790:	07c2                	sll	a5,a5,0x10
80008792:	97b6                	add	a5,a5,a3
80008794:	02c7d633          	divu	a2,a5,a2
80008798:	028606b3          	mul	a3,a2,s0
8000879c:	0642                	sll	a2,a2,0x10
8000879e:	8f95                	sub	a5,a5,a3
800087a0:	01079693          	sll	a3,a5,0x10
800087a4:	01051793          	sll	a5,a0,0x10
800087a8:	83c1                	srl	a5,a5,0x10
800087aa:	97b6                	add	a5,a5,a3
800087ac:	0287d7b3          	divu	a5,a5,s0
800087b0:	97b2                	add	a5,a5,a2
800087b2:	00c7b633          	sltu	a2,a5,a2
800087b6:	9732                	add	a4,a4,a2
800087b8:	b72d                	j	800086e2 <.L113>

800087ba <.L126>:
800087ba:	02c707b3          	mul	a5,a4,a2
800087be:	01855613          	srl	a2,a0,0x18
800087c2:	0ff6f693          	zext.b	a3,a3
800087c6:	40f587b3          	sub	a5,a1,a5
800087ca:	07a2                	sll	a5,a5,0x8
800087cc:	963e                	add	a2,a2,a5
800087ce:	028657b3          	divu	a5,a2,s0
800087d2:	028785b3          	mul	a1,a5,s0
800087d6:	07a2                	sll	a5,a5,0x8
800087d8:	8e0d                	sub	a2,a2,a1
800087da:	0622                	sll	a2,a2,0x8
800087dc:	96b2                	add	a3,a3,a2
800087de:	0286d5b3          	divu	a1,a3,s0
800087e2:	97ae                	add	a5,a5,a1
800087e4:	07a2                	sll	a5,a5,0x8
800087e6:	02858633          	mul	a2,a1,s0
800087ea:	8e91                	sub	a3,a3,a2
800087ec:	00855613          	srl	a2,a0,0x8
800087f0:	0ff67613          	zext.b	a2,a2
800087f4:	06a2                	sll	a3,a3,0x8
800087f6:	96b2                	add	a3,a3,a2
800087f8:	0286d633          	divu	a2,a3,s0
800087fc:	97b2                	add	a5,a5,a2
800087fe:	07a2                	sll	a5,a5,0x8
80008800:	02860533          	mul	a0,a2,s0
80008804:	0ff97613          	zext.b	a2,s2
80008808:	8e89                	sub	a3,a3,a0
8000880a:	06a2                	sll	a3,a3,0x8
8000880c:	96b2                	add	a3,a3,a2
8000880e:	0286d6b3          	divu	a3,a3,s0
80008812:	97b6                	add	a5,a5,a3
80008814:	b5f9                	j	800086e2 <.L113>

80008816 <.L114>:
80008816:	80003b37          	lui	s6,0x80003
8000881a:	4f4b0b13          	add	s6,s6,1268 # 800034f4 <__SEGGER_RTL_Moeller_inverse_lut>
8000881e:	0ac5fe63          	bgeu	a1,a2,800088da <.L128>
80008822:	10000737          	lui	a4,0x10000
80008826:	87b2                	mv	a5,a2
80008828:	00e67563          	bgeu	a2,a4,80008832 <.L129>
8000882c:	00461793          	sll	a5,a2,0x4
80008830:	4a11                	li	s4,4

80008832 <.L129>:
80008832:	40000737          	lui	a4,0x40000
80008836:	00e7f463          	bgeu	a5,a4,8000883e <.L130>
8000883a:	0a09                	add	s4,s4,2
8000883c:	078a                	sll	a5,a5,0x2

8000883e <.L130>:
8000883e:	0007c363          	bltz	a5,80008844 <.L131>
80008842:	0a05                	add	s4,s4,1

80008844 <.L131>:
80008844:	8652                	mv	a2,s4
80008846:	854a                	mv	a0,s2
80008848:	85a6                	mv	a1,s1
8000884a:	3add                	jal	80008240 <__ashldi3>
8000884c:	01441a33          	sll	s4,s0,s4
80008850:	016a5793          	srl	a5,s4,0x16
80008854:	e0078793          	add	a5,a5,-512 # fe00 <__XPI0_segment_used_size__+0x3dac>
80008858:	0786                	sll	a5,a5,0x1
8000885a:	97da                	add	a5,a5,s6
8000885c:	0007d783          	lhu	a5,0(a5)
80008860:	00ba5813          	srl	a6,s4,0xb
80008864:	001a7713          	and	a4,s4,1
80008868:	02f78633          	mul	a2,a5,a5
8000886c:	0792                	sll	a5,a5,0x4
8000886e:	001a5693          	srl	a3,s4,0x1
80008872:	0805                	add	a6,a6,1
80008874:	03063633          	mulhu	a2,a2,a6
80008878:	8f91                	sub	a5,a5,a2
8000887a:	96ba                	add	a3,a3,a4
8000887c:	17fd                	add	a5,a5,-1
8000887e:	c319                	beqz	a4,80008884 <.L132>
80008880:	0017d713          	srl	a4,a5,0x1

80008884 <.L132>:
80008884:	02f686b3          	mul	a3,a3,a5
80008888:	8f15                	sub	a4,a4,a3
8000888a:	02e7b733          	mulhu	a4,a5,a4
8000888e:	07be                	sll	a5,a5,0xf
80008890:	8305                	srl	a4,a4,0x1
80008892:	97ba                	add	a5,a5,a4
80008894:	8752                	mv	a4,s4
80008896:	034786b3          	mul	a3,a5,s4
8000889a:	9736                	add	a4,a4,a3
8000889c:	00d736b3          	sltu	a3,a4,a3
800088a0:	8752                	mv	a4,s4
800088a2:	9736                	add	a4,a4,a3
800088a4:	0347b6b3          	mulhu	a3,a5,s4
800088a8:	9736                	add	a4,a4,a3
800088aa:	8f99                	sub	a5,a5,a4
800088ac:	02b7b733          	mulhu	a4,a5,a1
800088b0:	02b787b3          	mul	a5,a5,a1
800088b4:	00a786b3          	add	a3,a5,a0
800088b8:	00f6b7b3          	sltu	a5,a3,a5
800088bc:	95be                	add	a1,a1,a5
800088be:	972e                	add	a4,a4,a1
800088c0:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
800088c4:	02fa0633          	mul	a2,s4,a5
800088c8:	8d11                	sub	a0,a0,a2
800088ca:	00a6f463          	bgeu	a3,a0,800088d2 <.L133>
800088ce:	9552                	add	a0,a0,s4
800088d0:	87ba                	mv	a5,a4

800088d2 <.L133>:
800088d2:	dd456de3          	bltu	a0,s4,800086ac <.L174>

800088d6 <.L160>:
800088d6:	0785                	add	a5,a5,1
800088d8:	bbd1                	j	800086ac <.L174>

800088da <.L128>:
800088da:	02c5dab3          	divu	s5,a1,a2
800088de:	10000737          	lui	a4,0x10000
800088e2:	87b2                	mv	a5,a2
800088e4:	02ca85b3          	mul	a1,s5,a2
800088e8:	40b485b3          	sub	a1,s1,a1
800088ec:	00e67563          	bgeu	a2,a4,800088f6 <.L135>
800088f0:	00461793          	sll	a5,a2,0x4
800088f4:	4a11                	li	s4,4

800088f6 <.L135>:
800088f6:	40000737          	lui	a4,0x40000
800088fa:	00e7f463          	bgeu	a5,a4,80008902 <.L136>
800088fe:	0a09                	add	s4,s4,2
80008900:	078a                	sll	a5,a5,0x2

80008902 <.L136>:
80008902:	0007c363          	bltz	a5,80008908 <.L137>
80008906:	0a05                	add	s4,s4,1

80008908 <.L137>:
80008908:	8652                	mv	a2,s4
8000890a:	854a                	mv	a0,s2
8000890c:	3a15                	jal	80008240 <__ashldi3>
8000890e:	01441a33          	sll	s4,s0,s4
80008912:	016a5793          	srl	a5,s4,0x16
80008916:	e0078793          	add	a5,a5,-512
8000891a:	0786                	sll	a5,a5,0x1
8000891c:	9b3e                	add	s6,s6,a5
8000891e:	000b5783          	lhu	a5,0(s6)
80008922:	00ba5813          	srl	a6,s4,0xb
80008926:	001a7713          	and	a4,s4,1
8000892a:	02f78633          	mul	a2,a5,a5
8000892e:	0792                	sll	a5,a5,0x4
80008930:	001a5693          	srl	a3,s4,0x1
80008934:	0805                	add	a6,a6,1
80008936:	03063633          	mulhu	a2,a2,a6
8000893a:	8f91                	sub	a5,a5,a2
8000893c:	96ba                	add	a3,a3,a4
8000893e:	17fd                	add	a5,a5,-1
80008940:	c319                	beqz	a4,80008946 <.L138>
80008942:	0017d713          	srl	a4,a5,0x1

80008946 <.L138>:
80008946:	02f686b3          	mul	a3,a3,a5
8000894a:	8f15                	sub	a4,a4,a3
8000894c:	02e7b733          	mulhu	a4,a5,a4
80008950:	07be                	sll	a5,a5,0xf
80008952:	8305                	srl	a4,a4,0x1
80008954:	97ba                	add	a5,a5,a4
80008956:	8752                	mv	a4,s4
80008958:	034786b3          	mul	a3,a5,s4
8000895c:	9736                	add	a4,a4,a3
8000895e:	00d736b3          	sltu	a3,a4,a3
80008962:	8752                	mv	a4,s4
80008964:	9736                	add	a4,a4,a3
80008966:	0347b6b3          	mulhu	a3,a5,s4
8000896a:	9736                	add	a4,a4,a3
8000896c:	8f99                	sub	a5,a5,a4
8000896e:	02b7b733          	mulhu	a4,a5,a1
80008972:	02b787b3          	mul	a5,a5,a1
80008976:	00a786b3          	add	a3,a5,a0
8000897a:	00f6b7b3          	sltu	a5,a3,a5
8000897e:	95be                	add	a1,a1,a5
80008980:	972e                	add	a4,a4,a1
80008982:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
80008986:	02fa0633          	mul	a2,s4,a5
8000898a:	8d11                	sub	a0,a0,a2
8000898c:	00a6f463          	bgeu	a3,a0,80008994 <.L139>
80008990:	9552                	add	a0,a0,s4
80008992:	87ba                	mv	a5,a4

80008994 <.L139>:
80008994:	01456363          	bltu	a0,s4,8000899a <.L140>
80008998:	0785                	add	a5,a5,1

8000899a <.L140>:
8000899a:	8756                	mv	a4,s5
8000899c:	b399                	j	800086e2 <.L113>

8000899e <.L111>:
8000899e:	67c1                	lui	a5,0x10
800089a0:	4a81                	li	s5,0
800089a2:	00f6f563          	bgeu	a3,a5,800089ac <.L141>
800089a6:	01069a13          	sll	s4,a3,0x10
800089aa:	4ac1                	li	s5,16

800089ac <.L141>:
800089ac:	010007b7          	lui	a5,0x1000
800089b0:	00fa7463          	bgeu	s4,a5,800089b8 <.L142>
800089b4:	0aa1                	add	s5,s5,8
800089b6:	0a22                	sll	s4,s4,0x8

800089b8 <.L142>:
800089b8:	100007b7          	lui	a5,0x10000
800089bc:	00fa7463          	bgeu	s4,a5,800089c4 <.L143>
800089c0:	0a91                	add	s5,s5,4
800089c2:	0a12                	sll	s4,s4,0x4

800089c4 <.L143>:
800089c4:	400007b7          	lui	a5,0x40000
800089c8:	00fa7463          	bgeu	s4,a5,800089d0 <.L144>
800089cc:	0a89                	add	s5,s5,2
800089ce:	0a0a                	sll	s4,s4,0x2

800089d0 <.L144>:
800089d0:	000a4363          	bltz	s4,800089d6 <.L145>
800089d4:	0a85                	add	s5,s5,1

800089d6 <.L145>:
800089d6:	01f49793          	sll	a5,s1,0x1f
800089da:	8656                	mv	a2,s5
800089dc:	00195a13          	srl	s4,s2,0x1
800089e0:	8522                	mv	a0,s0
800089e2:	85ce                	mv	a1,s3
800089e4:	0147ea33          	or	s4,a5,s4
800089e8:	38a1                	jal	80008240 <__ashldi3>
800089ea:	0165d613          	srl	a2,a1,0x16
800089ee:	800037b7          	lui	a5,0x80003
800089f2:	e0060613          	add	a2,a2,-512
800089f6:	0606                	sll	a2,a2,0x1
800089f8:	4f478793          	add	a5,a5,1268 # 800034f4 <__SEGGER_RTL_Moeller_inverse_lut>
800089fc:	97b2                	add	a5,a5,a2
800089fe:	0007d783          	lhu	a5,0(a5)
80008a02:	00b5d513          	srl	a0,a1,0xb
80008a06:	0015f713          	and	a4,a1,1
80008a0a:	02f78633          	mul	a2,a5,a5
80008a0e:	0792                	sll	a5,a5,0x4
80008a10:	0015d693          	srl	a3,a1,0x1
80008a14:	0505                	add	a0,a0,1
80008a16:	02a63633          	mulhu	a2,a2,a0
80008a1a:	8f91                	sub	a5,a5,a2
80008a1c:	0014db13          	srl	s6,s1,0x1
80008a20:	96ba                	add	a3,a3,a4
80008a22:	17fd                	add	a5,a5,-1
80008a24:	c319                	beqz	a4,80008a2a <.L146>
80008a26:	0017d713          	srl	a4,a5,0x1

80008a2a <.L146>:
80008a2a:	02f686b3          	mul	a3,a3,a5
80008a2e:	8f15                	sub	a4,a4,a3
80008a30:	02e7b733          	mulhu	a4,a5,a4
80008a34:	07be                	sll	a5,a5,0xf
80008a36:	8305                	srl	a4,a4,0x1
80008a38:	97ba                	add	a5,a5,a4
80008a3a:	872e                	mv	a4,a1
80008a3c:	02b786b3          	mul	a3,a5,a1
80008a40:	9736                	add	a4,a4,a3
80008a42:	00d736b3          	sltu	a3,a4,a3
80008a46:	872e                	mv	a4,a1
80008a48:	9736                	add	a4,a4,a3
80008a4a:	02b7b6b3          	mulhu	a3,a5,a1
80008a4e:	9736                	add	a4,a4,a3
80008a50:	8f99                	sub	a5,a5,a4
80008a52:	0367b733          	mulhu	a4,a5,s6
80008a56:	036787b3          	mul	a5,a5,s6
80008a5a:	014786b3          	add	a3,a5,s4
80008a5e:	00f6b7b3          	sltu	a5,a3,a5
80008a62:	97da                	add	a5,a5,s6
80008a64:	973e                	add	a4,a4,a5
80008a66:	00170793          	add	a5,a4,1
80008a6a:	02f58633          	mul	a2,a1,a5
80008a6e:	40ca0a33          	sub	s4,s4,a2
80008a72:	0146f463          	bgeu	a3,s4,80008a7a <.L147>
80008a76:	9a2e                	add	s4,s4,a1
80008a78:	87ba                	mv	a5,a4

80008a7a <.L147>:
80008a7a:	00ba6363          	bltu	s4,a1,80008a80 <.L148>
80008a7e:	0785                	add	a5,a5,1

80008a80 <.L148>:
80008a80:	477d                	li	a4,31
80008a82:	41570733          	sub	a4,a4,s5
80008a86:	00e7d7b3          	srl	a5,a5,a4
80008a8a:	c391                	beqz	a5,80008a8e <.L149>
80008a8c:	17fd                	add	a5,a5,-1

80008a8e <.L149>:
80008a8e:	0287b633          	mulhu	a2,a5,s0
80008a92:	02f98733          	mul	a4,s3,a5
80008a96:	028786b3          	mul	a3,a5,s0
80008a9a:	9732                	add	a4,a4,a2
80008a9c:	40e48733          	sub	a4,s1,a4
80008aa0:	40d906b3          	sub	a3,s2,a3
80008aa4:	00d93633          	sltu	a2,s2,a3
80008aa8:	8f11                	sub	a4,a4,a2
80008aaa:	c13761e3          	bltu	a4,s3,800086ac <.L174>
80008aae:	e2e994e3          	bne	s3,a4,800088d6 <.L160>
80008ab2:	be86ede3          	bltu	a3,s0,800086ac <.L174>
80008ab6:	b505                	j	800088d6 <.L160>

80008ab8 <.L152>:
80008ab8:	87aa                	mv	a5,a0
80008aba:	872e                	mv	a4,a1
80008abc:	b11d                	j	800086e2 <.L113>

80008abe <.L153>:
80008abe:	4781                	li	a5,0
80008ac0:	b6f5                	j	800086ac <.L174>

Disassembly of section .text.libc.abs:

80008ac2 <abs>:
80008ac2:	41f55793          	sra	a5,a0,0x1f
80008ac6:	8d3d                	xor	a0,a0,a5
80008ac8:	8d1d                	sub	a0,a0,a5
80008aca:	8082                	ret

Disassembly of section .text.libc.memcpy:

80008acc <memcpy>:
80008acc:	c251                	beqz	a2,80008b50 <.Lmemcpy_done>
80008ace:	87aa                	mv	a5,a0
80008ad0:	00b546b3          	xor	a3,a0,a1
80008ad4:	06fa                	sll	a3,a3,0x1e
80008ad6:	e2bd                	bnez	a3,80008b3c <.Lmemcpy_byte_copy>
80008ad8:	01e51693          	sll	a3,a0,0x1e
80008adc:	ce81                	beqz	a3,80008af4 <.Lmemcpy_aligned>

80008ade <.Lmemcpy_word_align>:
80008ade:	00058683          	lb	a3,0(a1)
80008ae2:	00d50023          	sb	a3,0(a0)
80008ae6:	0585                	add	a1,a1,1
80008ae8:	0505                	add	a0,a0,1
80008aea:	167d                	add	a2,a2,-1
80008aec:	c22d                	beqz	a2,80008b4e <.Lmemcpy_memcpy_end>
80008aee:	01e51693          	sll	a3,a0,0x1e
80008af2:	f6f5                	bnez	a3,80008ade <.Lmemcpy_word_align>

80008af4 <.Lmemcpy_aligned>:
80008af4:	02000693          	li	a3,32
80008af8:	02d66763          	bltu	a2,a3,80008b26 <.Lmemcpy_word_copy>

80008afc <.Lmemcpy_aligned_block_copy_loop>:
80008afc:	4198                	lw	a4,0(a1)
80008afe:	c118                	sw	a4,0(a0)
80008b00:	41d8                	lw	a4,4(a1)
80008b02:	c158                	sw	a4,4(a0)
80008b04:	4598                	lw	a4,8(a1)
80008b06:	c518                	sw	a4,8(a0)
80008b08:	45d8                	lw	a4,12(a1)
80008b0a:	c558                	sw	a4,12(a0)
80008b0c:	4998                	lw	a4,16(a1)
80008b0e:	c918                	sw	a4,16(a0)
80008b10:	49d8                	lw	a4,20(a1)
80008b12:	c958                	sw	a4,20(a0)
80008b14:	4d98                	lw	a4,24(a1)
80008b16:	cd18                	sw	a4,24(a0)
80008b18:	4dd8                	lw	a4,28(a1)
80008b1a:	cd58                	sw	a4,28(a0)
80008b1c:	9536                	add	a0,a0,a3
80008b1e:	95b6                	add	a1,a1,a3
80008b20:	8e15                	sub	a2,a2,a3
80008b22:	fcd67de3          	bgeu	a2,a3,80008afc <.Lmemcpy_aligned_block_copy_loop>

80008b26 <.Lmemcpy_word_copy>:
80008b26:	c605                	beqz	a2,80008b4e <.Lmemcpy_memcpy_end>
80008b28:	4691                	li	a3,4
80008b2a:	00d66963          	bltu	a2,a3,80008b3c <.Lmemcpy_byte_copy>

80008b2e <.Lmemcpy_word_copy_loop>:
80008b2e:	4198                	lw	a4,0(a1)
80008b30:	c118                	sw	a4,0(a0)
80008b32:	9536                	add	a0,a0,a3
80008b34:	95b6                	add	a1,a1,a3
80008b36:	8e15                	sub	a2,a2,a3
80008b38:	fed67be3          	bgeu	a2,a3,80008b2e <.Lmemcpy_word_copy_loop>

80008b3c <.Lmemcpy_byte_copy>:
80008b3c:	ca09                	beqz	a2,80008b4e <.Lmemcpy_memcpy_end>

80008b3e <.Lmemcpy_byte_copy_loop>:
80008b3e:	00058703          	lb	a4,0(a1)
80008b42:	00e50023          	sb	a4,0(a0)
80008b46:	0585                	add	a1,a1,1
80008b48:	0505                	add	a0,a0,1
80008b4a:	167d                	add	a2,a2,-1
80008b4c:	fa6d                	bnez	a2,80008b3e <.Lmemcpy_byte_copy_loop>

80008b4e <.Lmemcpy_memcpy_end>:
80008b4e:	853e                	mv	a0,a5

80008b50 <.Lmemcpy_done>:
80008b50:	8082                	ret

Disassembly of section .text.libc.strchr:

80008b52 <strchr>:
80008b52:	0ff5f593          	zext.b	a1,a1

80008b56 <.Lstrchr_search>:
80008b56:	00357613          	and	a2,a0,3
80008b5a:	ca19                	beqz	a2,80008b70 <.Lstrchr_aligned>
80008b5c:	00054603          	lbu	a2,0(a0)
80008b60:	0505                	add	a0,a0,1
80008b62:	00b60563          	beq	a2,a1,80008b6c <.Lstrchr_found>
80008b66:	fa65                	bnez	a2,80008b56 <.Lstrchr_search>
80008b68:	4501                	li	a0,0
80008b6a:	8082                	ret

80008b6c <.Lstrchr_found>:
80008b6c:	157d                	add	a0,a0,-1
80008b6e:	8082                	ret

80008b70 <.Lstrchr_aligned>:
80008b70:	01010637          	lui	a2,0x1010
80008b74:	10160613          	add	a2,a2,257 # 1010101 <_extram_size+0x10101>
80008b78:	02c585b3          	mul	a1,a1,a2
80008b7c:	00761693          	sll	a3,a2,0x7

80008b80 <.Lstrchr_wordsearch>:
80008b80:	4118                	lw	a4,0(a0)
80008b82:	0511                	add	a0,a0,4
80008b84:	fff74293          	not	t0,a4
80008b88:	40c707b3          	sub	a5,a4,a2
80008b8c:	0057f7b3          	and	a5,a5,t0
80008b90:	8f2d                	xor	a4,a4,a1
80008b92:	40c702b3          	sub	t0,a4,a2
80008b96:	fff74713          	not	a4,a4
80008b9a:	00e2f2b3          	and	t0,t0,a4
80008b9e:	00f2e2b3          	or	t0,t0,a5
80008ba2:	00d2f2b3          	and	t0,t0,a3
80008ba6:	fc028de3          	beqz	t0,80008b80 <.Lstrchr_wordsearch>
80008baa:	1571                	add	a0,a0,-4
80008bac:	0ff5f593          	zext.b	a1,a1

80008bb0 <.Lstrchr_tailsearch>:
80008bb0:	00054603          	lbu	a2,0(a0)
80008bb4:	0505                	add	a0,a0,1
80008bb6:	00b60563          	beq	a2,a1,80008bc0 <.Lstrchr_tailfound>
80008bba:	fa7d                	bnez	a2,80008bb0 <.Lstrchr_tailsearch>
80008bbc:	4501                	li	a0,0
80008bbe:	8082                	ret

80008bc0 <.Lstrchr_tailfound>:
80008bc0:	157d                	add	a0,a0,-1
80008bc2:	8082                	ret

Disassembly of section .text.libc.strtok:

80008bc4 <strtok>:
80008bc4:	1141                	add	sp,sp,-16
80008bc6:	c422                	sw	s0,8(sp)
80008bc8:	c04a                	sw	s2,0(sp)
80008bca:	c606                	sw	ra,12(sp)
80008bcc:	c226                	sw	s1,4(sp)
80008bce:	842a                	mv	s0,a0
80008bd0:	892e                	mv	s2,a1
80008bd2:	e519                	bnez	a0,80008be0 <.L646>
80008bd4:	000007b7          	lui	a5,0x0
80008bd8:	004787b3          	add	a5,a5,tp
80008bdc:	0007a403          	lw	s0,0(a5) # 0 <__AHB_SRAM_segment_used_size__>

80008be0 <.L646>:
80008be0:	00044583          	lbu	a1,0(s0)
80008be4:	e599                	bnez	a1,80008bf2 <.L647>

80008be6 <.L651>:
80008be6:	00044783          	lbu	a5,0(s0)
80008bea:	84a2                	mv	s1,s0
80008bec:	ef81                	bnez	a5,80008c04 <.L649>
80008bee:	4401                	li	s0,0
80008bf0:	a035                	j	80008c1c <.L644>

80008bf2 <.L647>:
80008bf2:	854a                	mv	a0,s2
80008bf4:	3fb9                	jal	80008b52 <strchr>
80008bf6:	d965                	beqz	a0,80008be6 <.L651>
80008bf8:	0405                	add	s0,s0,1
80008bfa:	b7dd                	j	80008be0 <.L646>

80008bfc <.L652>:
80008bfc:	854a                	mv	a0,s2
80008bfe:	3f91                	jal	80008b52 <strchr>
80008c00:	e509                	bnez	a0,80008c0a <.L656>
80008c02:	0485                	add	s1,s1,1

80008c04 <.L649>:
80008c04:	0004c583          	lbu	a1,0(s1)
80008c08:	f9f5                	bnez	a1,80008bfc <.L652>

80008c0a <.L656>:
80008c0a:	0004c783          	lbu	a5,0(s1)
80008c0e:	ef91                	bnez	a5,80008c2a <.L653>

80008c10 <.L654>:
80008c10:	000007b7          	lui	a5,0x0
80008c14:	004787b3          	add	a5,a5,tp
80008c18:	0097a023          	sw	s1,0(a5) # 0 <__AHB_SRAM_segment_used_size__>

80008c1c <.L644>:
80008c1c:	40b2                	lw	ra,12(sp)
80008c1e:	8522                	mv	a0,s0
80008c20:	4422                	lw	s0,8(sp)
80008c22:	4492                	lw	s1,4(sp)
80008c24:	4902                	lw	s2,0(sp)
80008c26:	0141                	add	sp,sp,16
80008c28:	8082                	ret

80008c2a <.L653>:
80008c2a:	00048023          	sb	zero,0(s1)
80008c2e:	0485                	add	s1,s1,1
80008c30:	b7c5                	j	80008c10 <.L654>

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

80008c32 <__SEGGER_RTL_pow10f>:
80008c32:	1101                	add	sp,sp,-32
80008c34:	cc22                	sw	s0,24(sp)
80008c36:	c64e                	sw	s3,12(sp)
80008c38:	ce06                	sw	ra,28(sp)
80008c3a:	ca26                	sw	s1,20(sp)
80008c3c:	c84a                	sw	s2,16(sp)
80008c3e:	842a                	mv	s0,a0
80008c40:	4981                	li	s3,0
80008c42:	00055563          	bgez	a0,80008c4c <.L17>
80008c46:	40a00433          	neg	s0,a0
80008c4a:	4985                	li	s3,1

80008c4c <.L17>:
80008c4c:	80004937          	lui	s2,0x80004
80008c50:	b2c92503          	lw	a0,-1236(s2) # 80003b2c <.Lmerged_single+0x4>
80008c54:	800044b7          	lui	s1,0x80004
80008c58:	8f448493          	add	s1,s1,-1804 # 800038f4 <__SEGGER_RTL_aPower2f>

80008c5c <.L18>:
80008c5c:	ec19                	bnez	s0,80008c7a <.L20>
80008c5e:	00098763          	beqz	s3,80008c6c <.L16>
80008c62:	85aa                	mv	a1,a0
80008c64:	b2c92503          	lw	a0,-1236(s2)
80008c68:	1d3040ef          	jal	8000d63a <__divsf3>

80008c6c <.L16>:
80008c6c:	40f2                	lw	ra,28(sp)
80008c6e:	4462                	lw	s0,24(sp)
80008c70:	44d2                	lw	s1,20(sp)
80008c72:	4942                	lw	s2,16(sp)
80008c74:	49b2                	lw	s3,12(sp)
80008c76:	6105                	add	sp,sp,32
80008c78:	8082                	ret

80008c7a <.L20>:
80008c7a:	00147793          	and	a5,s0,1
80008c7e:	c781                	beqz	a5,80008c86 <.L19>
80008c80:	408c                	lw	a1,0(s1)
80008c82:	7f8040ef          	jal	8000d47a <__mulsf3>

80008c86 <.L19>:
80008c86:	8405                	sra	s0,s0,0x1
80008c88:	0491                	add	s1,s1,4
80008c8a:	bfc9                	j	80008c5c <.L18>

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80008c8c <__SEGGER_RTL_prin_flush>:
80008c8c:	4950                	lw	a2,20(a0)
80008c8e:	ce19                	beqz	a2,80008cac <.L20>
80008c90:	511c                	lw	a5,32(a0)
80008c92:	1141                	add	sp,sp,-16
80008c94:	c422                	sw	s0,8(sp)
80008c96:	c606                	sw	ra,12(sp)
80008c98:	842a                	mv	s0,a0
80008c9a:	c399                	beqz	a5,80008ca0 <.L12>
80008c9c:	490c                	lw	a1,16(a0)
80008c9e:	9782                	jalr	a5

80008ca0 <.L12>:
80008ca0:	40b2                	lw	ra,12(sp)
80008ca2:	00042a23          	sw	zero,20(s0)
80008ca6:	4422                	lw	s0,8(sp)
80008ca8:	0141                	add	sp,sp,16
80008caa:	8082                	ret

80008cac <.L20>:
80008cac:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80008cae <__SEGGER_RTL_pre_padding>:
80008cae:	0105f793          	and	a5,a1,16
80008cb2:	eb91                	bnez	a5,80008cc6 <.L40>
80008cb4:	2005f793          	and	a5,a1,512
80008cb8:	02000593          	li	a1,32
80008cbc:	c399                	beqz	a5,80008cc2 <.L42>
80008cbe:	03000593          	li	a1,48

80008cc2 <.L42>:
80008cc2:	0bc0506f          	j	8000dd7e <__SEGGER_RTL_print_padding>

80008cc6 <.L40>:
80008cc6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin_l:

80008cc8 <__SEGGER_RTL_init_prin_l>:
80008cc8:	1141                	add	sp,sp,-16
80008cca:	c226                	sw	s1,4(sp)
80008ccc:	02400613          	li	a2,36
80008cd0:	84ae                	mv	s1,a1
80008cd2:	4581                	li	a1,0
80008cd4:	c422                	sw	s0,8(sp)
80008cd6:	c606                	sw	ra,12(sp)
80008cd8:	842a                	mv	s0,a0
80008cda:	695040ef          	jal	8000db6e <memset>
80008cde:	40b2                	lw	ra,12(sp)
80008ce0:	cc44                	sw	s1,28(s0)
80008ce2:	4422                	lw	s0,8(sp)
80008ce4:	4492                	lw	s1,4(sp)
80008ce6:	0141                	add	sp,sp,16
80008ce8:	8082                	ret

Disassembly of section .text.libc.vfprintf:

80008cea <vfprintf>:
80008cea:	1101                	add	sp,sp,-32
80008cec:	cc22                	sw	s0,24(sp)
80008cee:	ca26                	sw	s1,20(sp)
80008cf0:	ce06                	sw	ra,28(sp)
80008cf2:	84ae                	mv	s1,a1
80008cf4:	842a                	mv	s0,a0
80008cf6:	c632                	sw	a2,12(sp)
80008cf8:	64f050ef          	jal	8000eb46 <__SEGGER_RTL_current_locale>
80008cfc:	85aa                	mv	a1,a0
80008cfe:	8522                	mv	a0,s0
80008d00:	4462                	lw	s0,24(sp)
80008d02:	46b2                	lw	a3,12(sp)
80008d04:	40f2                	lw	ra,28(sp)
80008d06:	8626                	mv	a2,s1
80008d08:	44d2                	lw	s1,20(sp)
80008d0a:	6105                	add	sp,sp,32
80008d0c:	09c0506f          	j	8000dda8 <vfprintf_l>

Disassembly of section .text.libc.printf:

80008d10 <printf>:
80008d10:	7139                	add	sp,sp,-64
80008d12:	da3e                	sw	a5,52(sp)
80008d14:	d22e                	sw	a1,36(sp)
80008d16:	85aa                	mv	a1,a0
80008d18:	1701a503          	lw	a0,368(gp) # 1080970 <stdout>
80008d1c:	d432                	sw	a2,40(sp)
80008d1e:	1050                	add	a2,sp,36
80008d20:	ce06                	sw	ra,28(sp)
80008d22:	d636                	sw	a3,44(sp)
80008d24:	d83a                	sw	a4,48(sp)
80008d26:	dc42                	sw	a6,56(sp)
80008d28:	de46                	sw	a7,60(sp)
80008d2a:	c632                	sw	a2,12(sp)
80008d2c:	3f7d                	jal	80008cea <vfprintf>
80008d2e:	40f2                	lw	ra,28(sp)
80008d30:	6121                	add	sp,sp,64
80008d32:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

80008d34 <__SEGGER_init_heap>:
80008d34:	00080537          	lui	a0,0x80
80008d38:	00050513          	mv	a0,a0
80008d3c:	000845b7          	lui	a1,0x84
80008d40:	00058593          	mv	a1,a1
80008d44:	8d89                	sub	a1,a1,a0
80008d46:	a009                	j	80008d48 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

80008d48 <__SEGGER_RTL_init_heap>:
80008d48:	479d                	li	a5,7
80008d4a:	00b7f763          	bgeu	a5,a1,80008d58 <.L68>
80008d4e:	14a1ae23          	sw	a0,348(gp) # 108095c <__SEGGER_RTL_heap_globals>
80008d52:	00052023          	sw	zero,0(a0) # 80000 <__AXI_SRAM_segment_size__>
80008d56:	c14c                	sw	a1,4(a0)

80008d58 <.L68>:
80008d58:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

80008d5a <__SEGGER_RTL_ascii_toupper>:
80008d5a:	f9f50713          	add	a4,a0,-97
80008d5e:	47e5                	li	a5,25
80008d60:	00e7e363          	bltu	a5,a4,80008d66 <.L5>
80008d64:	1501                	add	a0,a0,-32

80008d66 <.L5>:
80008d66:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

80008d68 <__SEGGER_RTL_ascii_towupper>:
80008d68:	f9f50713          	add	a4,a0,-97
80008d6c:	47e5                	li	a5,25
80008d6e:	00e7e363          	bltu	a5,a4,80008d74 <.L12>
80008d72:	1501                	add	a0,a0,-32

80008d74 <.L12>:
80008d74:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

80008d76 <__SEGGER_RTL_ascii_mbtowc>:
80008d76:	87aa                	mv	a5,a0
80008d78:	4501                	li	a0,0
80008d7a:	c195                	beqz	a1,80008d9e <.L55>
80008d7c:	c20d                	beqz	a2,80008d9e <.L55>
80008d7e:	0005c703          	lbu	a4,0(a1) # 84000 <__heap_end__>
80008d82:	07f00613          	li	a2,127
80008d86:	5579                	li	a0,-2
80008d88:	00e66b63          	bltu	a2,a4,80008d9e <.L55>
80008d8c:	c391                	beqz	a5,80008d90 <.L57>
80008d8e:	c398                	sw	a4,0(a5)

80008d90 <.L57>:
80008d90:	0006a023          	sw	zero,0(a3)
80008d94:	0006a223          	sw	zero,4(a3)
80008d98:	00e03533          	snez	a0,a4
80008d9c:	8082                	ret

80008d9e <.L55>:
80008d9e:	8082                	ret

Disassembly of section .text.console_init:

80008da0 <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
80008da0:	7139                	add	sp,sp,-64
80008da2:	de06                	sw	ra,60(sp)
80008da4:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
80008da6:	4785                	li	a5,1
80008da8:	d63e                	sw	a5,44(sp)

    if (cfg->type == CONSOLE_TYPE_UART) {
80008daa:	47b2                	lw	a5,12(sp)
80008dac:	439c                	lw	a5,0(a5)
80008dae:	e7a1                	bnez	a5,80008df6 <.L2>

80008db0 <.LBB2>:
        uart_config_t config = {0};
80008db0:	cc02                	sw	zero,24(sp)
80008db2:	ce02                	sw	zero,28(sp)
80008db4:	d002                	sw	zero,32(sp)
80008db6:	d202                	sw	zero,36(sp)
80008db8:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
80008dba:	47b2                	lw	a5,12(sp)
80008dbc:	43dc                	lw	a5,4(a5)
80008dbe:	873e                	mv	a4,a5
80008dc0:	083c                	add	a5,sp,24
80008dc2:	85be                	mv	a1,a5
80008dc4:	853a                	mv	a0,a4
80008dc6:	ccbfb0ef          	jal	80004a90 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
80008dca:	47b2                	lw	a5,12(sp)
80008dcc:	479c                	lw	a5,8(a5)
80008dce:	cc3e                	sw	a5,24(sp)
        config.baudrate = cfg->baudrate;
80008dd0:	47b2                	lw	a5,12(sp)
80008dd2:	47dc                	lw	a5,12(a5)
80008dd4:	ce3e                	sw	a5,28(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
80008dd6:	47b2                	lw	a5,12(sp)
80008dd8:	43dc                	lw	a5,4(a5)
80008dda:	873e                	mv	a4,a5
80008ddc:	083c                	add	a5,sp,24
80008dde:	85be                	mv	a1,a5
80008de0:	853a                	mv	a0,a4
80008de2:	0ff000ef          	jal	800096e0 <uart_init>
80008de6:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
80008de8:	57b2                	lw	a5,44(sp)
80008dea:	e791                	bnez	a5,80008df6 <.L2>
            g_console_uart = (UART_Type *)cfg->base;
80008dec:	47b2                	lw	a5,12(sp)
80008dee:	43dc                	lw	a5,4(a5)
80008df0:	873e                	mv	a4,a5
80008df2:	12e1a423          	sw	a4,296(gp) # 1080928 <g_console_uart>

80008df6 <.L2>:
        }
    }

    return stat;
80008df6:	57b2                	lw	a5,44(sp)
}
80008df8:	853e                	mv	a0,a5
80008dfa:	50f2                	lw	ra,60(sp)
80008dfc:	6121                	add	sp,sp,64
80008dfe:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

80008e00 <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
80008e00:	7179                	add	sp,sp,-48
80008e02:	d606                	sw	ra,44(sp)
80008e04:	c62a                	sw	a0,12(sp)
80008e06:	c42e                	sw	a1,8(sp)
80008e08:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
80008e0a:	ce02                	sw	zero,28(sp)
80008e0c:	a099                	j	80008e52 <.L13>

80008e0e <.L17>:
        if (data[count] == '\n') {
80008e0e:	4722                	lw	a4,8(sp)
80008e10:	47f2                	lw	a5,28(sp)
80008e12:	97ba                	add	a5,a5,a4
80008e14:	0007c703          	lbu	a4,0(a5)
80008e18:	47a9                	li	a5,10
80008e1a:	00f71b63          	bne	a4,a5,80008e30 <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
80008e1e:	0001                	nop

80008e20 <.L15>:
80008e20:	1281a783          	lw	a5,296(gp) # 1080928 <g_console_uart>
80008e24:	45b5                	li	a1,13
80008e26:	853e                	mv	a0,a5
80008e28:	e7dfb0ef          	jal	80004ca4 <uart_send_byte>
80008e2c:	87aa                	mv	a5,a0
80008e2e:	fbed                	bnez	a5,80008e20 <.L15>

80008e30 <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
80008e30:	0001                	nop

80008e32 <.L16>:
80008e32:	1281a683          	lw	a3,296(gp) # 1080928 <g_console_uart>
80008e36:	4722                	lw	a4,8(sp)
80008e38:	47f2                	lw	a5,28(sp)
80008e3a:	97ba                	add	a5,a5,a4
80008e3c:	0007c783          	lbu	a5,0(a5)
80008e40:	85be                	mv	a1,a5
80008e42:	8536                	mv	a0,a3
80008e44:	e61fb0ef          	jal	80004ca4 <uart_send_byte>
80008e48:	87aa                	mv	a5,a0
80008e4a:	f7e5                	bnez	a5,80008e32 <.L16>
    for (count = 0; count < size; count++) {
80008e4c:	47f2                	lw	a5,28(sp)
80008e4e:	0785                	add	a5,a5,1
80008e50:	ce3e                	sw	a5,28(sp)

80008e52 <.L13>:
80008e52:	4772                	lw	a4,28(sp)
80008e54:	4792                	lw	a5,4(sp)
80008e56:	faf76ce3          	bltu	a4,a5,80008e0e <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
80008e5a:	0001                	nop

80008e5c <.L18>:
80008e5c:	1281a783          	lw	a5,296(gp) # 1080928 <g_console_uart>
80008e60:	853e                	mv	a0,a5
80008e62:	201000ef          	jal	80009862 <uart_flush>
80008e66:	87aa                	mv	a5,a0
80008e68:	fbf5                	bnez	a5,80008e5c <.L18>
    }
    return count;
80008e6a:	47f2                	lw	a5,28(sp)

}
80008e6c:	853e                	mv	a0,a5
80008e6e:	50b2                	lw	ra,44(sp)
80008e70:	6145                	add	sp,sp,48
80008e72:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

80008e74 <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
80008e74:	1141                	add	sp,sp,-16
80008e76:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
80008e78:	4781                	li	a5,0
}
80008e7a:	853e                	mv	a0,a5
80008e7c:	0141                	add	sp,sp,16
80008e7e:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

80008e80 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
80008e80:	1141                	add	sp,sp,-16
80008e82:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
80008e84:	4785                	li	a5,1
}
80008e86:	853e                	mv	a0,a5
80008e88:	0141                	add	sp,sp,16
80008e8a:	8082                	ret

Disassembly of section .text.dma_setup_channel:

80008e8c <dma_setup_channel>:
 */

#include "hpm_dma_drv.h"

hpm_stat_t dma_setup_channel(DMA_Type *ptr, uint8_t ch_num, dma_channel_config_t *ch, bool start_transfer)
{
80008e8c:	1101                	add	sp,sp,-32
80008e8e:	c62a                	sw	a0,12(sp)
80008e90:	87ae                	mv	a5,a1
80008e92:	c232                	sw	a2,4(sp)
80008e94:	8736                	mv	a4,a3
80008e96:	00f105a3          	sb	a5,11(sp)
80008e9a:	87ba                	mv	a5,a4
80008e9c:	00f10523          	sb	a5,10(sp)
    uint32_t tmp;

    if ((ch->dst_width > DMA_SOC_TRANSFER_WIDTH_MAX(ptr))
80008ea0:	4792                	lw	a5,4(sp)
80008ea2:	0057c783          	lbu	a5,5(a5)
80008ea6:	86be                	mv	a3,a5
80008ea8:	4732                	lw	a4,12(sp)
80008eaa:	f30487b7          	lui	a5,0xf3048
80008eae:	00f71463          	bne	a4,a5,80008eb6 <.L11>
80008eb2:	478d                	li	a5,3
80008eb4:	a011                	j	80008eb8 <.L12>

80008eb6 <.L11>:
80008eb6:	4789                	li	a5,2

80008eb8 <.L12>:
80008eb8:	04d7e163          	bltu	a5,a3,80008efa <.L13>
       || (ch->src_width > DMA_SOC_TRANSFER_WIDTH_MAX(ptr))
80008ebc:	4792                	lw	a5,4(sp)
80008ebe:	0047c783          	lbu	a5,4(a5) # f3048004 <__AHB_SRAM_segment_end__+0x2d40004>
80008ec2:	86be                	mv	a3,a5
80008ec4:	4732                	lw	a4,12(sp)
80008ec6:	f30487b7          	lui	a5,0xf3048
80008eca:	00f71463          	bne	a4,a5,80008ed2 <.L14>
80008ece:	478d                	li	a5,3
80008ed0:	a011                	j	80008ed4 <.L15>

80008ed2 <.L14>:
80008ed2:	4789                	li	a5,2

80008ed4 <.L15>:
80008ed4:	02d7e363          	bltu	a5,a3,80008efa <.L13>
       || (ch_num >= DMA_SOC_CHANNEL_NUM)
80008ed8:	00b14703          	lbu	a4,11(sp)
80008edc:	479d                	li	a5,7
80008ede:	00e7ee63          	bltu	a5,a4,80008efa <.L13>
       || ((ch->dst_mode == DMA_HANDSHAKE_MODE_HANDSHAKE) && (ch->src_mode == DMA_HANDSHAKE_MODE_HANDSHAKE))) {
80008ee2:	4792                	lw	a5,4(sp)
80008ee4:	0037c703          	lbu	a4,3(a5) # f3048003 <__AHB_SRAM_segment_end__+0x2d40003>
80008ee8:	4785                	li	a5,1
80008eea:	00f71a63          	bne	a4,a5,80008efe <.L16>
80008eee:	4792                	lw	a5,4(sp)
80008ef0:	0027c703          	lbu	a4,2(a5)
80008ef4:	4785                	li	a5,1
80008ef6:	00f71463          	bne	a4,a5,80008efe <.L16>

80008efa <.L13>:
        return status_invalid_argument;
80008efa:	4789                	li	a5,2
80008efc:	a27d                	j	800090aa <.L17>

80008efe <.L16>:
    }
    if ((ch->size_in_byte & ((1 << ch->dst_width) - 1))
80008efe:	4792                	lw	a5,4(sp)
80008f00:	4f9c                	lw	a5,24(a5)
80008f02:	4712                	lw	a4,4(sp)
80008f04:	00574703          	lbu	a4,5(a4)
80008f08:	86ba                	mv	a3,a4
80008f0a:	4705                	li	a4,1
80008f0c:	00d71733          	sll	a4,a4,a3
80008f10:	177d                	add	a4,a4,-1
80008f12:	8ff9                	and	a5,a5,a4
80008f14:	efa1                	bnez	a5,80008f6c <.L18>
     || (ch->src_addr & ((1 << ch->src_width) - 1))
80008f16:	4792                	lw	a5,4(sp)
80008f18:	47dc                	lw	a5,12(a5)
80008f1a:	4712                	lw	a4,4(sp)
80008f1c:	00474703          	lbu	a4,4(a4)
80008f20:	86ba                	mv	a3,a4
80008f22:	4705                	li	a4,1
80008f24:	00d71733          	sll	a4,a4,a3
80008f28:	177d                	add	a4,a4,-1
80008f2a:	8ff9                	and	a5,a5,a4
80008f2c:	e3a1                	bnez	a5,80008f6c <.L18>
     || (ch->dst_addr & ((1 << ch->dst_width) - 1))
80008f2e:	4792                	lw	a5,4(sp)
80008f30:	4b9c                	lw	a5,16(a5)
80008f32:	4712                	lw	a4,4(sp)
80008f34:	00574703          	lbu	a4,5(a4)
80008f38:	86ba                	mv	a3,a4
80008f3a:	4705                	li	a4,1
80008f3c:	00d71733          	sll	a4,a4,a3
80008f40:	177d                	add	a4,a4,-1
80008f42:	8ff9                	and	a5,a5,a4
80008f44:	e785                	bnez	a5,80008f6c <.L18>
     || ((1 << ch->src_width) & ((1 << ch->dst_width) - 1))
80008f46:	4792                	lw	a5,4(sp)
80008f48:	0057c783          	lbu	a5,5(a5)
80008f4c:	873e                	mv	a4,a5
80008f4e:	4785                	li	a5,1
80008f50:	00e797b3          	sll	a5,a5,a4
80008f54:	17fd                	add	a5,a5,-1
80008f56:	4712                	lw	a4,4(sp)
80008f58:	00474703          	lbu	a4,4(a4)
80008f5c:	40e7d7b3          	sra	a5,a5,a4
80008f60:	8b85                	and	a5,a5,1
80008f62:	e789                	bnez	a5,80008f6c <.L18>
     || ((ch->linked_ptr & 0x7))) {
80008f64:	4792                	lw	a5,4(sp)
80008f66:	4bdc                	lw	a5,20(a5)
80008f68:	8b9d                	and	a5,a5,7
80008f6a:	c789                	beqz	a5,80008f74 <.L19>

80008f6c <.L18>:
        return status_dma_alignment_error;
80008f6c:	6789                	lui	a5,0x2
80008f6e:	f4478793          	add	a5,a5,-188 # 1f44 <__fw_size__+0xf44>
80008f72:	aa25                	j	800090aa <.L17>

80008f74 <.L19>:
    }
    ptr->CHCTRL[ch_num].SRCADDR = DMA_CHCTRL_SRCADDR_SRCADDRL_SET(ch->src_addr);
80008f74:	00b14783          	lbu	a5,11(sp)
80008f78:	4712                	lw	a4,4(sp)
80008f7a:	4758                	lw	a4,12(a4)
80008f7c:	46b2                	lw	a3,12(sp)
80008f7e:	0789                	add	a5,a5,2
80008f80:	0796                	sll	a5,a5,0x5
80008f82:	97b6                	add	a5,a5,a3
80008f84:	c798                	sw	a4,8(a5)
    ptr->CHCTRL[ch_num].DSTADDR = DMA_CHCTRL_DSTADDR_DSTADDRL_SET(ch->dst_addr);
80008f86:	00b14783          	lbu	a5,11(sp)
80008f8a:	4712                	lw	a4,4(sp)
80008f8c:	4b18                	lw	a4,16(a4)
80008f8e:	46b2                	lw	a3,12(sp)
80008f90:	0796                	sll	a5,a5,0x5
80008f92:	97b6                	add	a5,a5,a3
80008f94:	cbb8                	sw	a4,80(a5)
    ptr->CHCTRL[ch_num].TRANSIZE = DMA_CHCTRL_TRANSIZE_TRANSIZE_SET(ch->size_in_byte >> ch->src_width);
80008f96:	4792                	lw	a5,4(sp)
80008f98:	4f98                	lw	a4,24(a5)
80008f9a:	4792                	lw	a5,4(sp)
80008f9c:	0047c783          	lbu	a5,4(a5)
80008fa0:	86be                	mv	a3,a5
80008fa2:	00b14783          	lbu	a5,11(sp)
80008fa6:	00d75733          	srl	a4,a4,a3
80008faa:	46b2                	lw	a3,12(sp)
80008fac:	0789                	add	a5,a5,2
80008fae:	0796                	sll	a5,a5,0x5
80008fb0:	97b6                	add	a5,a5,a3
80008fb2:	c3d8                	sw	a4,4(a5)
    ptr->CHCTRL[ch_num].LLPOINTER = DMA_CHCTRL_LLPOINTER_LLPOINTERL_SET(ch->linked_ptr >> DMA_CHCTRL_LLPOINTER_LLPOINTERL_SHIFT);
80008fb4:	4792                	lw	a5,4(sp)
80008fb6:	4bd8                	lw	a4,20(a5)
80008fb8:	00b14783          	lbu	a5,11(sp)
80008fbc:	9b61                	and	a4,a4,-8
80008fbe:	46b2                	lw	a3,12(sp)
80008fc0:	0796                	sll	a5,a5,0x5
80008fc2:	97b6                	add	a5,a5,a3
80008fc4:	cfb8                	sw	a4,88(a5)
    ptr->CHCTRL[ch_num].SRCADDRH = DMA_CHCTRL_SRCADDRH_SRCADDRH_SET(ch->src_addr_high);
    ptr->CHCTRL[ch_num].DSTADDRH = DMA_CHCTRL_DSTADDRH_DSTADDRH_SET(ch->dst_addr_high);
    ptr->CHCTRL[ch_num].LLPOINTERH = DMA_CHCTRL_LLPOINTERH_LLPOINTERH_SET(ch->linked_ptr_high);
#endif

    ptr->INTSTATUS = (DMA_INTSTATUS_TC_SET(1) | DMA_INTSTATUS_ABORT_SET(1) | DMA_INTSTATUS_ERROR_SET(1)) << ch_num;
80008fc6:	00b14783          	lbu	a5,11(sp)
80008fca:	6741                	lui	a4,0x10
80008fcc:	10170713          	add	a4,a4,257 # 10101 <__XPI0_segment_used_size__+0x40ad>
80008fd0:	00f71733          	sll	a4,a4,a5
80008fd4:	47b2                	lw	a5,12(sp)
80008fd6:	db98                	sw	a4,48(a5)
    tmp = DMA_CHCTRL_CTRL_SRCBUSINFIDX_SET(0)
        | DMA_CHCTRL_CTRL_DSTBUSINFIDX_SET(0)
        | DMA_CHCTRL_CTRL_PRIORITY_SET(ch->priority)
80008fd8:	4792                	lw	a5,4(sp)
80008fda:	0007c783          	lbu	a5,0(a5)
80008fde:	01d79713          	sll	a4,a5,0x1d
80008fe2:	200007b7          	lui	a5,0x20000
80008fe6:	8f7d                	and	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCBURSTSIZE_SET(ch->src_burst_size)
80008fe8:	4792                	lw	a5,4(sp)
80008fea:	0017c783          	lbu	a5,1(a5) # 20000001 <__SHARE_RAM_segment_end__+0x1ee80001>
80008fee:	01879693          	sll	a3,a5,0x18
80008ff2:	0f0007b7          	lui	a5,0xf000
80008ff6:	8ff5                	and	a5,a5,a3
80008ff8:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCWIDTH_SET(ch->src_width)
80008ffa:	4792                	lw	a5,4(sp)
80008ffc:	0047c783          	lbu	a5,4(a5) # f000004 <__SHARE_RAM_segment_end__+0xde80004>
80009000:	01579693          	sll	a3,a5,0x15
80009004:	00e007b7          	lui	a5,0xe00
80009008:	8ff5                	and	a5,a5,a3
8000900a:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_DSTWIDTH_SET(ch->dst_width)
8000900c:	4792                	lw	a5,4(sp)
8000900e:	0057c783          	lbu	a5,5(a5) # e00005 <_flash_size+0x600005>
80009012:	01279693          	sll	a3,a5,0x12
80009016:	001c07b7          	lui	a5,0x1c0
8000901a:	8ff5                	and	a5,a5,a3
8000901c:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCMODE_SET(ch->src_mode)
8000901e:	4792                	lw	a5,4(sp)
80009020:	0027c783          	lbu	a5,2(a5) # 1c0002 <__DLM_segment_end__+0x100002>
80009024:	01179693          	sll	a3,a5,0x11
80009028:	000207b7          	lui	a5,0x20
8000902c:	8ff5                	and	a5,a5,a3
8000902e:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_DSTMODE_SET(ch->dst_mode)
80009030:	4792                	lw	a5,4(sp)
80009032:	0037c783          	lbu	a5,3(a5) # 20003 <__XPI0_segment_used_size__+0x13faf>
80009036:	01079693          	sll	a3,a5,0x10
8000903a:	67c1                	lui	a5,0x10
8000903c:	8ff5                	and	a5,a5,a3
8000903e:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCADDRCTRL_SET(ch->src_addr_ctrl)
80009040:	4792                	lw	a5,4(sp)
80009042:	0067c783          	lbu	a5,6(a5) # 10006 <__XPI0_segment_used_size__+0x3fb2>
80009046:	00e79693          	sll	a3,a5,0xe
8000904a:	67c1                	lui	a5,0x10
8000904c:	17fd                	add	a5,a5,-1 # ffff <__XPI0_segment_used_size__+0x3fab>
8000904e:	8ff5                	and	a5,a5,a3
80009050:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_DSTADDRCTRL_SET(ch->dst_addr_ctrl)
80009052:	4792                	lw	a5,4(sp)
80009054:	0077c783          	lbu	a5,7(a5)
80009058:	00c79693          	sll	a3,a5,0xc
8000905c:	678d                	lui	a5,0x3
8000905e:	8ff5                	and	a5,a5,a3
80009060:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCREQSEL_SET(ch_num)
80009062:	00b14783          	lbu	a5,11(sp)
80009066:	00879693          	sll	a3,a5,0x8
8000906a:	6785                	lui	a5,0x1
8000906c:	f0078793          	add	a5,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
80009070:	8ff5                	and	a5,a5,a3
80009072:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_DSTREQSEL_SET(ch_num)
80009074:	00b14783          	lbu	a5,11(sp)
80009078:	0792                	sll	a5,a5,0x4
8000907a:	0ff7f793          	zext.b	a5,a5
8000907e:	8fd9                	or	a5,a5,a4
        | ch->interrupt_mask;
80009080:	4712                	lw	a4,4(sp)
80009082:	00875703          	lhu	a4,8(a4)
    tmp = DMA_CHCTRL_CTRL_SRCBUSINFIDX_SET(0)
80009086:	8fd9                	or	a5,a5,a4
80009088:	ce3e                	sw	a5,28(sp)

    if (start_transfer) {
8000908a:	00a14783          	lbu	a5,10(sp)
8000908e:	c789                	beqz	a5,80009098 <.L20>
        tmp |= DMA_CHCTRL_CTRL_ENABLE_MASK;
80009090:	47f2                	lw	a5,28(sp)
80009092:	0017e793          	or	a5,a5,1
80009096:	ce3e                	sw	a5,28(sp)

80009098 <.L20>:
    }
    ptr->CHCTRL[ch_num].CTRL = tmp;
80009098:	00b14783          	lbu	a5,11(sp)
8000909c:	4732                	lw	a4,12(sp)
8000909e:	0789                	add	a5,a5,2
800090a0:	0796                	sll	a5,a5,0x5
800090a2:	97ba                	add	a5,a5,a4
800090a4:	4772                	lw	a4,28(sp)
800090a6:	c398                	sw	a4,0(a5)

    return status_success;
800090a8:	4781                	li	a5,0

800090aa <.L17>:
}
800090aa:	853e                	mv	a0,a5
800090ac:	6105                	add	sp,sp,32
800090ae:	8082                	ret

Disassembly of section .text.dma_default_channel_config:

800090b0 <dma_default_channel_config>:


void dma_default_channel_config(DMA_Type *ptr, dma_channel_config_t *ch)
{
800090b0:	1141                	add	sp,sp,-16
800090b2:	c62a                	sw	a0,12(sp)
800090b4:	c42e                	sw	a1,8(sp)
    (void) ptr;
    ch->priority = DMA_CHANNEL_PRIORITY_LOW;
800090b6:	47a2                	lw	a5,8(sp)
800090b8:	00078023          	sb	zero,0(a5)
    ch->src_mode = DMA_HANDSHAKE_MODE_NORMAL;
800090bc:	47a2                	lw	a5,8(sp)
800090be:	00078123          	sb	zero,2(a5)
    ch->dst_mode = DMA_HANDSHAKE_MODE_NORMAL;
800090c2:	47a2                	lw	a5,8(sp)
800090c4:	000781a3          	sb	zero,3(a5)
    ch->src_burst_size = DMA_NUM_TRANSFER_PER_BURST_1T;
800090c8:	47a2                	lw	a5,8(sp)
800090ca:	000780a3          	sb	zero,1(a5)
    ch->src_addr_ctrl = DMA_ADDRESS_CONTROL_INCREMENT;
800090ce:	47a2                	lw	a5,8(sp)
800090d0:	00078323          	sb	zero,6(a5)
    ch->dst_addr_ctrl = DMA_ADDRESS_CONTROL_INCREMENT;
800090d4:	47a2                	lw	a5,8(sp)
800090d6:	000783a3          	sb	zero,7(a5)
    ch->interrupt_mask = DMA_INTERRUPT_MASK_NONE;
800090da:	47a2                	lw	a5,8(sp)
800090dc:	00079423          	sh	zero,8(a5)
    ch->linked_ptr = 0;
800090e0:	47a2                	lw	a5,8(sp)
800090e2:	0007aa23          	sw	zero,20(a5)
#if DMA_SUPPORT_64BIT_ADDR
    ch->linked_ptr_high = 0;
#endif
}
800090e6:	0001                	nop
800090e8:	0141                	add	sp,sp,16
800090ea:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

800090ec <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
800090ec:	1101                	add	sp,sp,-32
800090ee:	c62a                	sw	a0,12(sp)
800090f0:	87ae                	mv	a5,a1
800090f2:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
800090f6:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
800090f8:	00a15703          	lhu	a4,10(sp)
800090fc:	25700793          	li	a5,599
80009100:	00e7f863          	bgeu	a5,a4,80009110 <.L26>
80009104:	00a15703          	lhu	a4,10(sp)
80009108:	55f00793          	li	a5,1375
8000910c:	00e7f463          	bgeu	a5,a4,80009114 <.L27>

80009110 <.L26>:
        return status_invalid_argument;
80009110:	4789                	li	a5,2
80009112:	a831                	j	8000912e <.L28>

80009114 <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80009114:	47b2                	lw	a5,12(sp)
80009116:	4b98                	lw	a4,16(a5)
80009118:	77fd                	lui	a5,0xfffff
8000911a:	8f7d                	and	a4,a4,a5
8000911c:	00a15683          	lhu	a3,10(sp)
80009120:	6785                	lui	a5,0x1
80009122:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
80009124:	8ff5                	and	a5,a5,a3
80009126:	8f5d                	or	a4,a4,a5
80009128:	47b2                	lw	a5,12(sp)
8000912a:	cb98                	sw	a4,16(a5)
    return stat;
8000912c:	47f2                	lw	a5,28(sp)

8000912e <.L28>:
}
8000912e:	853e                	mv	a0,a5
80009130:	6105                	add	sp,sp,32
80009132:	8082                	ret

Disassembly of section .text.pllctl_pll_powerdown:

80009134 <pllctl_pll_powerdown>:
{
80009134:	1141                	add	sp,sp,-16
80009136:	c62a                	sw	a0,12(sp)
80009138:	87ae                	mv	a5,a1
8000913a:	00f105a3          	sb	a5,11(sp)
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
8000913e:	00b14703          	lbu	a4,11(sp)
80009142:	4791                	li	a5,4
80009144:	00e7f463          	bgeu	a5,a4,8000914c <.L5>
        return status_invalid_argument;
80009148:	4789                	li	a5,2
8000914a:	a805                	j	8000917a <.L6>

8000914c <.L5>:
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
8000914c:	00b14783          	lbu	a5,11(sp)
80009150:	4732                	lw	a4,12(sp)
80009152:	0785                	add	a5,a5,1
80009154:	079e                	sll	a5,a5,0x7
80009156:	97ba                	add	a5,a5,a4
80009158:	43d8                	lw	a4,4(a5)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
8000915a:	7a0007b7          	lui	a5,0x7a000
8000915e:	17fd                	add	a5,a5,-1 # 79ffffff <__SHARE_RAM_segment_end__+0x78e7ffff>
80009160:	00f776b3          	and	a3,a4,a5
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
80009164:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
80009168:	02000737          	lui	a4,0x2000
8000916c:	8f55                	or	a4,a4,a3
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
8000916e:	46b2                	lw	a3,12(sp)
80009170:	0785                	add	a5,a5,1
80009172:	079e                	sll	a5,a5,0x7
80009174:	97b6                	add	a5,a5,a3
80009176:	c3d8                	sw	a4,4(a5)
    return status_success;
80009178:	4781                	li	a5,0

8000917a <.L6>:
}
8000917a:	853e                	mv	a0,a5
8000917c:	0141                	add	sp,sp,16
8000917e:	8082                	ret

Disassembly of section .text.pllctl_init_int_pll_with_freq:

80009180 <pllctl_init_int_pll_with_freq>:
    return status_success;
}

hpm_stat_t pllctl_init_int_pll_with_freq(PLLCTL_Type *ptr, uint8_t pll,
                                    uint32_t freq_in_hz)
{
80009180:	7179                	add	sp,sp,-48
80009182:	d606                	sw	ra,44(sp)
80009184:	c62a                	sw	a0,12(sp)
80009186:	87ae                	mv	a5,a1
80009188:	c232                	sw	a2,4(sp)
8000918a:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
8000918e:	47b2                	lw	a5,12(sp)
80009190:	c791                	beqz	a5,8000919c <.L27>
80009192:	00b14703          	lbu	a4,11(sp)
80009196:	4791                	li	a5,4
80009198:	00e7f463          	bgeu	a5,a4,800091a0 <.L28>

8000919c <.L27>:
        return status_invalid_argument;
8000919c:	4789                	li	a5,2
8000919e:	ac09                	j	800093b0 <.L29>

800091a0 <.L28>:
    }
    uint32_t freq, fbdiv, refdiv, postdiv;
    if ((freq_in_hz < PLLCTL_PLL_VCO_FREQ_MIN)
800091a0:	4712                	lw	a4,4(sp)
800091a2:	165a17b7          	lui	a5,0x165a1
800091a6:	bbf78793          	add	a5,a5,-1089 # 165a0bbf <__SHARE_RAM_segment_end__+0x15420bbf>
800091aa:	00e7f963          	bgeu	a5,a4,800091bc <.L30>
            || (freq_in_hz > PLLCTL_PLL_VCO_FREQ_MAX)) {
800091ae:	4712                	lw	a4,4(sp)
800091b0:	832157b7          	lui	a5,0x83215
800091b4:	60078793          	add	a5,a5,1536 # 83215600 <__XPI0_segment_end__+0x2a15600>
800091b8:	00e7f463          	bgeu	a5,a4,800091c0 <.L31>

800091bc <.L30>:
        return status_invalid_argument;
800091bc:	4789                	li	a5,2
800091be:	aacd                	j	800093b0 <.L29>

800091c0 <.L31>:
    }

    freq = freq_in_hz;
800091c0:	4792                	lw	a5,4(sp)
800091c2:	ca3e                	sw	a5,20(sp)
    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
800091c4:	00b14783          	lbu	a5,11(sp)
800091c8:	4732                	lw	a4,12(sp)
800091ca:	0785                	add	a5,a5,1
800091cc:	079e                	sll	a5,a5,0x7
800091ce:	97ba                	add	a5,a5,a4
800091d0:	439c                	lw	a5,0(a5)
800091d2:	83e1                	srl	a5,a5,0x18
800091d4:	03f7f793          	and	a5,a5,63
800091d8:	cc3e                	sw	a5,24(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
800091da:	00b14783          	lbu	a5,11(sp)
800091de:	4732                	lw	a4,12(sp)
800091e0:	0785                	add	a5,a5,1
800091e2:	079e                	sll	a5,a5,0x7
800091e4:	97ba                	add	a5,a5,a4
800091e6:	439c                	lw	a5,0(a5)
800091e8:	83d1                	srl	a5,a5,0x14
800091ea:	8b9d                	and	a5,a5,7
800091ec:	c83e                	sw	a5,16(sp)
    fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
800091ee:	4762                	lw	a4,24(sp)
800091f0:	47c2                	lw	a5,16(sp)
800091f2:	02f707b3          	mul	a5,a4,a5
800091f6:	016e3737          	lui	a4,0x16e3
800091fa:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
800091fe:	02f757b3          	divu	a5,a4,a5
80009202:	4752                	lw	a4,20(sp)
80009204:	02f757b3          	divu	a5,a4,a5
80009208:	ce3e                	sw	a5,28(sp)
    if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
8000920a:	4772                	lw	a4,28(sp)
8000920c:	6785                	lui	a5,0x1
8000920e:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x562>
80009212:	04e7f163          	bgeu	a5,a4,80009254 <.L32>
        /* current refdiv can't be used for the given frequency */
        refdiv--;
80009216:	47e2                	lw	a5,24(sp)
80009218:	17fd                	add	a5,a5,-1
8000921a:	cc3e                	sw	a5,24(sp)

8000921c <.L36>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000921c:	4762                	lw	a4,24(sp)
8000921e:	47c2                	lw	a5,16(sp)
80009220:	02f707b3          	mul	a5,a4,a5
80009224:	016e3737          	lui	a4,0x16e3
80009228:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000922c:	02f757b3          	divu	a5,a4,a5
80009230:	4752                	lw	a4,20(sp)
80009232:	02f757b3          	divu	a5,a4,a5
80009236:	ce3e                	sw	a5,28(sp)
            if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
80009238:	4772                	lw	a4,28(sp)
8000923a:	6785                	lui	a5,0x1
8000923c:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x562>
80009240:	04e7fc63          	bgeu	a5,a4,80009298 <.L45>
                refdiv--;
80009244:	47e2                	lw	a5,24(sp)
80009246:	17fd                	add	a5,a5,-1
80009248:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv > PLLCTL_PLL_MIN_REFDIV);
8000924a:	4762                	lw	a4,24(sp)
8000924c:	4785                	li	a5,1
8000924e:	fce7e7e3          	bltu	a5,a4,8000921c <.L36>
80009252:	a0b1                	j	8000929e <.L37>

80009254 <.L32>:
    } else if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
80009254:	4772                	lw	a4,28(sp)
80009256:	47bd                	li	a5,15
80009258:	04e7e363          	bltu	a5,a4,8000929e <.L37>
        /* current refdiv can't be used for the given frequency */
        refdiv++;
8000925c:	47e2                	lw	a5,24(sp)
8000925e:	0785                	add	a5,a5,1
80009260:	cc3e                	sw	a5,24(sp)

80009262 <.L40>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
80009262:	4762                	lw	a4,24(sp)
80009264:	47c2                	lw	a5,16(sp)
80009266:	02f707b3          	mul	a5,a4,a5
8000926a:	016e3737          	lui	a4,0x16e3
8000926e:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80009272:	02f757b3          	divu	a5,a4,a5
80009276:	4752                	lw	a4,20(sp)
80009278:	02f757b3          	divu	a5,a4,a5
8000927c:	ce3e                	sw	a5,28(sp)
            if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
8000927e:	4772                	lw	a4,28(sp)
80009280:	47bd                	li	a5,15
80009282:	00e7ed63          	bltu	a5,a4,8000929c <.L46>
                refdiv++;
80009286:	47e2                	lw	a5,24(sp)
80009288:	0785                	add	a5,a5,1
8000928a:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv < PLLCTL_PLL_MAX_REFDIV);
8000928c:	4762                	lw	a4,24(sp)
8000928e:	03e00793          	li	a5,62
80009292:	fce7f8e3          	bgeu	a5,a4,80009262 <.L40>
80009296:	a021                	j	8000929e <.L37>

80009298 <.L45>:
                break;
80009298:	0001                	nop
8000929a:	a011                	j	8000929e <.L37>

8000929c <.L46>:
                break;
8000929c:	0001                	nop

8000929e <.L37>:
    }

    if ((refdiv > PLLCTL_PLL_MAX_REFDIV)
8000929e:	4762                	lw	a4,24(sp)
800092a0:	03f00793          	li	a5,63
800092a4:	02e7eb63          	bltu	a5,a4,800092da <.L41>
            || (refdiv < PLLCTL_PLL_MIN_REFDIV)
800092a8:	47e2                	lw	a5,24(sp)
800092aa:	cb85                	beqz	a5,800092da <.L41>
            || (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV)
800092ac:	4772                	lw	a4,28(sp)
800092ae:	6785                	lui	a5,0x1
800092b0:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x562>
800092b4:	02e7e363          	bltu	a5,a4,800092da <.L41>
            || (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV)
800092b8:	4772                	lw	a4,28(sp)
800092ba:	47bd                	li	a5,15
800092bc:	00e7ff63          	bgeu	a5,a4,800092da <.L41>
            || (((PLLCTL_SOC_PLL_REFCLK_FREQ / refdiv) < PLLCTL_INT_PLL_MIN_REF))) {
800092c0:	016e37b7          	lui	a5,0x16e3
800092c4:	60078713          	add	a4,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
800092c8:	47e2                	lw	a5,24(sp)
800092ca:	02f75733          	divu	a4,a4,a5
800092ce:	000f47b7          	lui	a5,0xf4
800092d2:	23f78793          	add	a5,a5,575 # f423f <__DLM_segment_end__+0x3423f>
800092d6:	00e7e663          	bltu	a5,a4,800092e2 <.L42>

800092da <.L41>:
        return status_pllctl_out_of_range;
800092da:	6799                	lui	a5,0x6
800092dc:	9da78793          	add	a5,a5,-1574 # 59da <__HEAPSIZE__+0x19da>
800092e0:	a8c1                	j	800093b0 <.L29>

800092e2 <.L42>:
    }

    if (!(ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK)) {
800092e2:	00b14783          	lbu	a5,11(sp)
800092e6:	4732                	lw	a4,12(sp)
800092e8:	0785                	add	a5,a5,1
800092ea:	079e                	sll	a5,a5,0x7
800092ec:	97ba                	add	a5,a5,a4
800092ee:	439c                	lw	a5,0(a5)
800092f0:	8ba1                	and	a5,a5,8
800092f2:	e795                	bnez	a5,8000931e <.L43>
        /* it was at frac mode, then it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
800092f4:	00b14783          	lbu	a5,11(sp)
800092f8:	85be                	mv	a1,a5
800092fa:	4532                	lw	a0,12(sp)
800092fc:	3d25                	jal	80009134 <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 |= PLLCTL_PLL_CFG0_DSMPD_MASK;
800092fe:	00b14783          	lbu	a5,11(sp)
80009302:	4732                	lw	a4,12(sp)
80009304:	0785                	add	a5,a5,1
80009306:	079e                	sll	a5,a5,0x7
80009308:	97ba                	add	a5,a5,a4
8000930a:	4398                	lw	a4,0(a5)
8000930c:	00b14783          	lbu	a5,11(sp)
80009310:	00876713          	or	a4,a4,8
80009314:	46b2                	lw	a3,12(sp)
80009316:	0785                	add	a5,a5,1
80009318:	079e                	sll	a5,a5,0x7
8000931a:	97b6                	add	a5,a5,a3
8000931c:	c398                	sw	a4,0(a5)

8000931e <.L43>:
    }

    if (PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0) != refdiv) {
8000931e:	00b14783          	lbu	a5,11(sp)
80009322:	4732                	lw	a4,12(sp)
80009324:	0785                	add	a5,a5,1
80009326:	079e                	sll	a5,a5,0x7
80009328:	97ba                	add	a5,a5,a4
8000932a:	439c                	lw	a5,0(a5)
8000932c:	83e1                	srl	a5,a5,0x18
8000932e:	03f7f793          	and	a5,a5,63
80009332:	4762                	lw	a4,24(sp)
80009334:	04f70163          	beq	a4,a5,80009376 <.L44>
        /* if refdiv is different, it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
80009338:	00b14783          	lbu	a5,11(sp)
8000933c:	85be                	mv	a1,a5
8000933e:	4532                	lw	a0,12(sp)
80009340:	3bd5                	jal	80009134 <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
80009342:	00b14783          	lbu	a5,11(sp)
80009346:	4732                	lw	a4,12(sp)
80009348:	0785                	add	a5,a5,1
8000934a:	079e                	sll	a5,a5,0x7
8000934c:	97ba                	add	a5,a5,a4
8000934e:	4398                	lw	a4,0(a5)
80009350:	c10007b7          	lui	a5,0xc1000
80009354:	17fd                	add	a5,a5,-1 # c0ffffff <__XPI0_segment_end__+0x407fffff>
80009356:	00f776b3          	and	a3,a4,a5
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
8000935a:	47e2                	lw	a5,24(sp)
8000935c:	01879713          	sll	a4,a5,0x18
80009360:	3f0007b7          	lui	a5,0x3f000
80009364:	8f7d                	and	a4,a4,a5
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
80009366:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
8000936a:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
8000936c:	46b2                	lw	a3,12(sp)
8000936e:	0785                	add	a5,a5,1 # 3f000001 <__SHARE_RAM_segment_end__+0x3de80001>
80009370:	079e                	sll	a5,a5,0x7
80009372:	97b6                	add	a5,a5,a3
80009374:	c398                	sw	a4,0(a5)

80009376 <.L44>:
    }

    ptr->PLL[pll].CFG2 = (ptr->PLL[pll].CFG2 & ~(PLLCTL_PLL_CFG2_FBDIV_INT_MASK)) | PLLCTL_PLL_CFG2_FBDIV_INT_SET(fbdiv);
80009376:	00b14783          	lbu	a5,11(sp)
8000937a:	4732                	lw	a4,12(sp)
8000937c:	0785                	add	a5,a5,1
8000937e:	079e                	sll	a5,a5,0x7
80009380:	97ba                	add	a5,a5,a4
80009382:	4798                	lw	a4,8(a5)
80009384:	77fd                	lui	a5,0xfffff
80009386:	00f776b3          	and	a3,a4,a5
8000938a:	4772                	lw	a4,28(sp)
8000938c:	6785                	lui	a5,0x1
8000938e:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
80009390:	8f7d                	and	a4,a4,a5
80009392:	00b14783          	lbu	a5,11(sp)
80009396:	8f55                	or	a4,a4,a3
80009398:	46b2                	lw	a3,12(sp)
8000939a:	0785                	add	a5,a5,1
8000939c:	079e                	sll	a5,a5,0x7
8000939e:	97b6                	add	a5,a5,a3
800093a0:	c798                	sw	a4,8(a5)

    pllctl_pll_poweron(ptr, pll);
800093a2:	00b14783          	lbu	a5,11(sp)
800093a6:	85be                	mv	a1,a5
800093a8:	4532                	lw	a0,12(sp)
800093aa:	b51fa0ef          	jal	80003efa <pllctl_pll_poweron>
    return status_success;
800093ae:	4781                	li	a5,0

800093b0 <.L29>:
}
800093b0:	853e                	mv	a0,a5
800093b2:	50b2                	lw	ra,44(sp)
800093b4:	6145                	add	sp,sp,48
800093b6:	8082                	ret

Disassembly of section .text.pllctl_get_pll_freq_in_hz:

800093b8 <pllctl_get_pll_freq_in_hz>:
    pllctl_pll_poweron(ptr, pll);
    return status_success;
}

uint32_t pllctl_get_pll_freq_in_hz(PLLCTL_Type *ptr, uint8_t pll)
{
800093b8:	715d                	add	sp,sp,-80
800093ba:	c686                	sw	ra,76(sp)
800093bc:	c4a2                	sw	s0,72(sp)
800093be:	c2a6                	sw	s1,68(sp)
800093c0:	c0ca                	sw	s2,64(sp)
800093c2:	de4e                	sw	s3,60(sp)
800093c4:	c62a                	sw	a0,12(sp)
800093c6:	87ae                	mv	a5,a1
800093c8:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
800093cc:	47b2                	lw	a5,12(sp)
800093ce:	c791                	beqz	a5,800093da <.L67>
800093d0:	00b14703          	lbu	a4,11(sp)
800093d4:	4791                	li	a5,4
800093d6:	00e7f463          	bgeu	a5,a4,800093de <.L68>

800093da <.L67>:
        return status_invalid_argument;
800093da:	4789                	li	a5,2
800093dc:	aa35                	j	80009518 <.L69>

800093de <.L68>:
    }
    uint32_t fbdiv, frac, refdiv, postdiv, refclk, freq;
    if (ptr->PLL[pll].CFG1 & PLLCTL_PLL_CFG1_PLLPD_SW_MASK) {
800093de:	00b14783          	lbu	a5,11(sp)
800093e2:	4732                	lw	a4,12(sp)
800093e4:	0785                	add	a5,a5,1
800093e6:	079e                	sll	a5,a5,0x7
800093e8:	97ba                	add	a5,a5,a4
800093ea:	43d8                	lw	a4,4(a5)
800093ec:	020007b7          	lui	a5,0x2000
800093f0:	8ff9                	and	a5,a5,a4
800093f2:	c399                	beqz	a5,800093f8 <.L70>
        /* pll is powered down */
        return 0;
800093f4:	4781                	li	a5,0
800093f6:	a20d                	j	80009518 <.L69>

800093f8 <.L70>:
    }

    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
800093f8:	00b14783          	lbu	a5,11(sp)
800093fc:	4732                	lw	a4,12(sp)
800093fe:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
80009400:	079e                	sll	a5,a5,0x7
80009402:	97ba                	add	a5,a5,a4
80009404:	439c                	lw	a5,0(a5)
80009406:	83e1                	srl	a5,a5,0x18
80009408:	03f7f793          	and	a5,a5,63
8000940c:	d43e                	sw	a5,40(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
8000940e:	00b14783          	lbu	a5,11(sp)
80009412:	4732                	lw	a4,12(sp)
80009414:	0785                	add	a5,a5,1
80009416:	079e                	sll	a5,a5,0x7
80009418:	97ba                	add	a5,a5,a4
8000941a:	439c                	lw	a5,0(a5)
8000941c:	83d1                	srl	a5,a5,0x14
8000941e:	8b9d                	and	a5,a5,7
80009420:	d23e                	sw	a5,36(sp)
    refclk = PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv);
80009422:	5722                	lw	a4,40(sp)
80009424:	5792                	lw	a5,36(sp)
80009426:	02f707b3          	mul	a5,a4,a5
8000942a:	016e3737          	lui	a4,0x16e3
8000942e:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80009432:	02f757b3          	divu	a5,a4,a5
80009436:	d03e                	sw	a5,32(sp)

    if (ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK) {
80009438:	00b14783          	lbu	a5,11(sp)
8000943c:	4732                	lw	a4,12(sp)
8000943e:	0785                	add	a5,a5,1
80009440:	079e                	sll	a5,a5,0x7
80009442:	97ba                	add	a5,a5,a4
80009444:	439c                	lw	a5,0(a5)
80009446:	8ba1                	and	a5,a5,8
80009448:	c395                	beqz	a5,8000946c <.L71>
        /* pll int mode */
        fbdiv = PLLCTL_PLL_CFG2_FBDIV_INT_GET(ptr->PLL[pll].CFG2);
8000944a:	00b14783          	lbu	a5,11(sp)
8000944e:	4732                	lw	a4,12(sp)
80009450:	0785                	add	a5,a5,1
80009452:	079e                	sll	a5,a5,0x7
80009454:	97ba                	add	a5,a5,a4
80009456:	4798                	lw	a4,8(a5)
80009458:	6785                	lui	a5,0x1
8000945a:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
8000945c:	8ff9                	and	a5,a5,a4
8000945e:	ce3e                	sw	a5,28(sp)
        freq = refclk * fbdiv;
80009460:	5702                	lw	a4,32(sp)
80009462:	47f2                	lw	a5,28(sp)
80009464:	02f707b3          	mul	a5,a4,a5
80009468:	d63e                	sw	a5,44(sp)
8000946a:	a075                	j	80009516 <.L72>

8000946c <.L71>:
    } else {
        /* pll frac mode */
        fbdiv = PLLCTL_PLL_FREQ_FBDIV_FRAC_GET(ptr->PLL[pll].FREQ);
8000946c:	00b14783          	lbu	a5,11(sp)
80009470:	4732                	lw	a4,12(sp)
80009472:	0785                	add	a5,a5,1
80009474:	079e                	sll	a5,a5,0x7
80009476:	97ba                	add	a5,a5,a4
80009478:	47dc                	lw	a5,12(a5)
8000947a:	0ff7f793          	zext.b	a5,a5
8000947e:	ce3e                	sw	a5,28(sp)
        frac = PLLCTL_PLL_FREQ_FRAC_GET(ptr->PLL[pll].FREQ);
80009480:	00b14783          	lbu	a5,11(sp)
80009484:	4732                	lw	a4,12(sp)
80009486:	0785                	add	a5,a5,1
80009488:	079e                	sll	a5,a5,0x7
8000948a:	97ba                	add	a5,a5,a4
8000948c:	47dc                	lw	a5,12(a5)
8000948e:	0087d713          	srl	a4,a5,0x8
80009492:	010007b7          	lui	a5,0x1000
80009496:	17fd                	add	a5,a5,-1 # ffffff <_flash_size+0x7fffff>
80009498:	8ff9                	and	a5,a5,a4
8000949a:	cc3e                	sw	a5,24(sp)
        freq = (uint32_t)((refclk * (fbdiv + ((double) frac / (1 << 24)))) + 0.5);
8000949c:	5502                	lw	a0,32(sp)
8000949e:	4ec040ef          	jal	8000d98a <__floatunsidf>
800094a2:	842a                	mv	s0,a0
800094a4:	84ae                	mv	s1,a1
800094a6:	4572                	lw	a0,28(sp)
800094a8:	4e2040ef          	jal	8000d98a <__floatunsidf>
800094ac:	892a                	mv	s2,a0
800094ae:	89ae                	mv	s3,a1
800094b0:	4562                	lw	a0,24(sp)
800094b2:	4d8040ef          	jal	8000d98a <__floatunsidf>
800094b6:	872a                	mv	a4,a0
800094b8:	87ae                	mv	a5,a1
800094ba:	800036b7          	lui	a3,0x80003
800094be:	0886a603          	lw	a2,136(a3) # 80003088 <.LC1>
800094c2:	08c6a683          	lw	a3,140(a3)
800094c6:	853a                	mv	a0,a4
800094c8:	85be                	mv	a1,a5
800094ca:	274040ef          	jal	8000d73e <__divdf3>
800094ce:	872a                	mv	a4,a0
800094d0:	87ae                	mv	a5,a1
800094d2:	863a                	mv	a2,a4
800094d4:	86be                	mv	a3,a5
800094d6:	854a                	mv	a0,s2
800094d8:	85ce                	mv	a1,s3
800094da:	4c9030ef          	jal	8000d1a2 <__adddf3>
800094de:	872a                	mv	a4,a0
800094e0:	87ae                	mv	a5,a1
800094e2:	863a                	mv	a2,a4
800094e4:	86be                	mv	a3,a5
800094e6:	8522                	mv	a0,s0
800094e8:	85a6                	mv	a1,s1
800094ea:	040040ef          	jal	8000d52a <__muldf3>
800094ee:	872a                	mv	a4,a0
800094f0:	87ae                	mv	a5,a1
800094f2:	853a                	mv	a0,a4
800094f4:	85be                	mv	a1,a5
800094f6:	800037b7          	lui	a5,0x80003
800094fa:	0907a603          	lw	a2,144(a5) # 80003090 <.LC2>
800094fe:	0947a683          	lw	a3,148(a5)
80009502:	4a1030ef          	jal	8000d1a2 <__adddf3>
80009506:	872a                	mv	a4,a0
80009508:	87ae                	mv	a5,a1
8000950a:	853a                	mv	a0,a4
8000950c:	85be                	mv	a1,a5
8000950e:	9fffe0ef          	jal	80007f0c <__fixunsdfsi>
80009512:	87aa                	mv	a5,a0
80009514:	d63e                	sw	a5,44(sp)

80009516 <.L72>:
    }
    return freq;
80009516:	57b2                	lw	a5,44(sp)

80009518 <.L69>:
}
80009518:	853e                	mv	a0,a5
8000951a:	40b6                	lw	ra,76(sp)
8000951c:	4426                	lw	s0,72(sp)
8000951e:	4496                	lw	s1,68(sp)
80009520:	4906                	lw	s2,64(sp)
80009522:	59f2                	lw	s3,60(sp)
80009524:	6161                	add	sp,sp,80
80009526:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

80009528 <write_pmp_cfg>:
{
80009528:	1141                	add	sp,sp,-16
8000952a:	c62a                	sw	a0,12(sp)
8000952c:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000952e:	4722                	lw	a4,8(sp)
80009530:	478d                	li	a5,3
80009532:	04f70163          	beq	a4,a5,80009574 <.L11>
80009536:	4722                	lw	a4,8(sp)
80009538:	478d                	li	a5,3
8000953a:	04e7e163          	bltu	a5,a4,8000957c <.L17>
8000953e:	4722                	lw	a4,8(sp)
80009540:	4789                	li	a5,2
80009542:	02f70563          	beq	a4,a5,8000956c <.L13>
80009546:	4722                	lw	a4,8(sp)
80009548:	4789                	li	a5,2
8000954a:	02e7e963          	bltu	a5,a4,8000957c <.L17>
8000954e:	47a2                	lw	a5,8(sp)
80009550:	c791                	beqz	a5,8000955c <.L14>
80009552:	4722                	lw	a4,8(sp)
80009554:	4785                	li	a5,1
80009556:	00f70763          	beq	a4,a5,80009564 <.L15>
        break;
8000955a:	a00d                	j	8000957c <.L17>

8000955c <.L14>:
        write_csr(CSR_PMPCFG0, value);
8000955c:	47b2                	lw	a5,12(sp)
8000955e:	3a079073          	csrw	pmpcfg0,a5
        break;
80009562:	a831                	j	8000957e <.L16>

80009564 <.L15>:
        write_csr(CSR_PMPCFG1, value);
80009564:	47b2                	lw	a5,12(sp)
80009566:	3a179073          	csrw	pmpcfg1,a5
        break;
8000956a:	a811                	j	8000957e <.L16>

8000956c <.L13>:
        write_csr(CSR_PMPCFG2, value);
8000956c:	47b2                	lw	a5,12(sp)
8000956e:	3a279073          	csrw	pmpcfg2,a5
        break;
80009572:	a031                	j	8000957e <.L16>

80009574 <.L11>:
        write_csr(CSR_PMPCFG3, value);
80009574:	47b2                	lw	a5,12(sp)
80009576:	3a379073          	csrw	pmpcfg3,a5
        break;
8000957a:	a011                	j	8000957e <.L16>

8000957c <.L17>:
        break;
8000957c:	0001                	nop

8000957e <.L16>:
}
8000957e:	0001                	nop
80009580:	0141                	add	sp,sp,16
80009582:	8082                	ret

Disassembly of section .text.write_pma_cfg:

80009584 <write_pma_cfg>:
{
80009584:	1141                	add	sp,sp,-16
80009586:	c62a                	sw	a0,12(sp)
80009588:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000958a:	4722                	lw	a4,8(sp)
8000958c:	478d                	li	a5,3
8000958e:	04f70163          	beq	a4,a5,800095d0 <.L71>
80009592:	4722                	lw	a4,8(sp)
80009594:	478d                	li	a5,3
80009596:	04e7e163          	bltu	a5,a4,800095d8 <.L77>
8000959a:	4722                	lw	a4,8(sp)
8000959c:	4789                	li	a5,2
8000959e:	02f70563          	beq	a4,a5,800095c8 <.L73>
800095a2:	4722                	lw	a4,8(sp)
800095a4:	4789                	li	a5,2
800095a6:	02e7e963          	bltu	a5,a4,800095d8 <.L77>
800095aa:	47a2                	lw	a5,8(sp)
800095ac:	c791                	beqz	a5,800095b8 <.L74>
800095ae:	4722                	lw	a4,8(sp)
800095b0:	4785                	li	a5,1
800095b2:	00f70763          	beq	a4,a5,800095c0 <.L75>
        break;
800095b6:	a00d                	j	800095d8 <.L77>

800095b8 <.L74>:
        write_csr(CSR_PMACFG0, value);
800095b8:	47b2                	lw	a5,12(sp)
800095ba:	bc079073          	csrw	0xbc0,a5
        break;
800095be:	a831                	j	800095da <.L76>

800095c0 <.L75>:
        write_csr(CSR_PMACFG1, value);
800095c0:	47b2                	lw	a5,12(sp)
800095c2:	bc179073          	csrw	0xbc1,a5
        break;
800095c6:	a811                	j	800095da <.L76>

800095c8 <.L73>:
        write_csr(CSR_PMACFG2, value);
800095c8:	47b2                	lw	a5,12(sp)
800095ca:	bc279073          	csrw	0xbc2,a5
        break;
800095ce:	a031                	j	800095da <.L76>

800095d0 <.L71>:
        write_csr(CSR_PMACFG3, value);
800095d0:	47b2                	lw	a5,12(sp)
800095d2:	bc379073          	csrw	0xbc3,a5
        break;
800095d6:	a011                	j	800095da <.L76>

800095d8 <.L77>:
        break;
800095d8:	0001                	nop

800095da <.L76>:
}
800095da:	0001                	nop
800095dc:	0141                	add	sp,sp,16
800095de:	8082                	ret

Disassembly of section .text.spi_master_get_default_format_config:

800095e0 <spi_master_get_default_format_config>:
{
800095e0:	1141                	add	sp,sp,-16
800095e2:	c62a                	sw	a0,12(sp)
    config->master_config.addr_len_in_bytes = 1;
800095e4:	47b2                	lw	a5,12(sp)
800095e6:	4705                	li	a4,1
800095e8:	00e78023          	sb	a4,0(a5)
    config->common_config.data_len_in_bits = 32;
800095ec:	47b2                	lw	a5,12(sp)
800095ee:	02000713          	li	a4,32
800095f2:	00e780a3          	sb	a4,1(a5)
    config->common_config.data_merge = false;
800095f6:	47b2                	lw	a5,12(sp)
800095f8:	00078123          	sb	zero,2(a5)
    config->common_config.mosi_bidir = false;
800095fc:	47b2                	lw	a5,12(sp)
800095fe:	000781a3          	sb	zero,3(a5)
    config->common_config.lsb = false;
80009602:	47b2                	lw	a5,12(sp)
80009604:	00078223          	sb	zero,4(a5)
    config->common_config.mode = spi_master_mode;
80009608:	47b2                	lw	a5,12(sp)
8000960a:	000782a3          	sb	zero,5(a5)
    config->common_config.cpol = spi_sclk_high_idle;
8000960e:	47b2                	lw	a5,12(sp)
80009610:	4705                	li	a4,1
80009612:	00e78323          	sb	a4,6(a5)
    config->common_config.cpha = spi_sclk_sampling_even_clk_edges;
80009616:	47b2                	lw	a5,12(sp)
80009618:	4705                	li	a4,1
8000961a:	00e783a3          	sb	a4,7(a5)
}
8000961e:	0001                	nop
80009620:	0141                	add	sp,sp,16
80009622:	8082                	ret

Disassembly of section .text.spi_format_init:

80009624 <spi_format_init>:
{
80009624:	1141                	add	sp,sp,-16
80009626:	c62a                	sw	a0,12(sp)
80009628:	c42e                	sw	a1,8(sp)
    ptr->TRANSFMT = SPI_TRANSFMT_ADDRLEN_SET(config->master_config.addr_len_in_bytes - 1) |
8000962a:	47a2                	lw	a5,8(sp)
8000962c:	0007c783          	lbu	a5,0(a5)
80009630:	17fd                	add	a5,a5,-1
80009632:	01079713          	sll	a4,a5,0x10
80009636:	000307b7          	lui	a5,0x30
8000963a:	8f7d                	and	a4,a4,a5
                    SPI_TRANSFMT_DATALEN_SET(config->common_config.data_len_in_bits - 1) |
8000963c:	47a2                	lw	a5,8(sp)
8000963e:	0017c783          	lbu	a5,1(a5) # 30001 <__XPI0_segment_used_size__+0x23fad>
80009642:	17fd                	add	a5,a5,-1
80009644:	00879693          	sll	a3,a5,0x8
80009648:	6789                	lui	a5,0x2
8000964a:	f0078793          	add	a5,a5,-256 # 1f00 <__fw_size__+0xf00>
8000964e:	8ff5                	and	a5,a5,a3
    ptr->TRANSFMT = SPI_TRANSFMT_ADDRLEN_SET(config->master_config.addr_len_in_bytes - 1) |
80009650:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_DATAMERGE_SET(config->common_config.data_merge) |
80009652:	47a2                	lw	a5,8(sp)
80009654:	0027c783          	lbu	a5,2(a5)
80009658:	079e                	sll	a5,a5,0x7
8000965a:	0ff7f793          	zext.b	a5,a5
                    SPI_TRANSFMT_DATALEN_SET(config->common_config.data_len_in_bits - 1) |
8000965e:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_MOSIBIDIR_SET(config->common_config.mosi_bidir) |
80009660:	47a2                	lw	a5,8(sp)
80009662:	0037c783          	lbu	a5,3(a5)
80009666:	0792                	sll	a5,a5,0x4
80009668:	8bc1                	and	a5,a5,16
                    SPI_TRANSFMT_DATAMERGE_SET(config->common_config.data_merge) |
8000966a:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_LSB_SET(config->common_config.lsb) |
8000966c:	47a2                	lw	a5,8(sp)
8000966e:	0047c783          	lbu	a5,4(a5)
80009672:	078e                	sll	a5,a5,0x3
80009674:	8ba1                	and	a5,a5,8
                    SPI_TRANSFMT_MOSIBIDIR_SET(config->common_config.mosi_bidir) |
80009676:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_SLVMODE_SET(config->common_config.mode) |
80009678:	47a2                	lw	a5,8(sp)
8000967a:	0057c783          	lbu	a5,5(a5)
8000967e:	078a                	sll	a5,a5,0x2
80009680:	8b91                	and	a5,a5,4
                    SPI_TRANSFMT_LSB_SET(config->common_config.lsb) |
80009682:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_CPOL_SET(config->common_config.cpol) |
80009684:	47a2                	lw	a5,8(sp)
80009686:	0067c783          	lbu	a5,6(a5)
8000968a:	0786                	sll	a5,a5,0x1
8000968c:	8b89                	and	a5,a5,2
                    SPI_TRANSFMT_SLVMODE_SET(config->common_config.mode) |
8000968e:	8f5d                	or	a4,a4,a5
                    SPI_TRANSFMT_CPHA_SET(config->common_config.cpha);
80009690:	47a2                	lw	a5,8(sp)
80009692:	0077c783          	lbu	a5,7(a5)
80009696:	8b85                	and	a5,a5,1
                    SPI_TRANSFMT_CPOL_SET(config->common_config.cpol) |
80009698:	8f5d                	or	a4,a4,a5
    ptr->TRANSFMT = SPI_TRANSFMT_ADDRLEN_SET(config->master_config.addr_len_in_bytes - 1) |
8000969a:	47b2                	lw	a5,12(sp)
8000969c:	cb98                	sw	a4,16(a5)
}
8000969e:	0001                	nop
800096a0:	0141                	add	sp,sp,16
800096a2:	8082                	ret

Disassembly of section .text.uart_modem_config:

800096a4 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
800096a4:	1141                	add	sp,sp,-16
800096a6:	c62a                	sw	a0,12(sp)
800096a8:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
800096aa:	47a2                	lw	a5,8(sp)
800096ac:	0007c783          	lbu	a5,0(a5)
800096b0:	0796                	sll	a5,a5,0x5
800096b2:	0207f713          	and	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
800096b6:	47a2                	lw	a5,8(sp)
800096b8:	0017c783          	lbu	a5,1(a5)
800096bc:	0792                	sll	a5,a5,0x4
800096be:	8bc1                	and	a5,a5,16
800096c0:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
800096c2:	47a2                	lw	a5,8(sp)
800096c4:	0027c783          	lbu	a5,2(a5)
800096c8:	0017c793          	xor	a5,a5,1
800096cc:	0ff7f793          	zext.b	a5,a5
800096d0:	0786                	sll	a5,a5,0x1
800096d2:	8b89                	and	a5,a5,2
800096d4:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
800096d6:	47b2                	lw	a5,12(sp)
800096d8:	db98                	sw	a4,48(a5)
}
800096da:	0001                	nop
800096dc:	0141                	add	sp,sp,16
800096de:	8082                	ret

Disassembly of section .text.uart_init:

800096e0 <uart_init>:
{
800096e0:	7179                	add	sp,sp,-48
800096e2:	d606                	sw	ra,44(sp)
800096e4:	c62a                	sw	a0,12(sp)
800096e6:	c42e                	sw	a1,8(sp)
    ptr->IER = 0;
800096e8:	47b2                	lw	a5,12(sp)
800096ea:	0207a223          	sw	zero,36(a5)
    ptr->LCR |= UART_LCR_DLAB_MASK;
800096ee:	47b2                	lw	a5,12(sp)
800096f0:	57dc                	lw	a5,44(a5)
800096f2:	0807e713          	or	a4,a5,128
800096f6:	47b2                	lw	a5,12(sp)
800096f8:	d7d8                	sw	a4,44(a5)
    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
800096fa:	47a2                	lw	a5,8(sp)
800096fc:	4398                	lw	a4,0(a5)
800096fe:	47a2                	lw	a5,8(sp)
80009700:	43dc                	lw	a5,4(a5)
80009702:	01b10693          	add	a3,sp,27
80009706:	0830                	add	a2,sp,24
80009708:	85be                	mv	a1,a5
8000970a:	853a                	mv	a0,a4
8000970c:	bdafb0ef          	jal	80004ae6 <uart_calculate_baudrate>
80009710:	87aa                	mv	a5,a0
80009712:	0017c793          	xor	a5,a5,1
80009716:	0ff7f793          	zext.b	a5,a5
8000971a:	c781                	beqz	a5,80009722 <.L25>
        return status_uart_no_suitable_baudrate_parameter_found;
8000971c:	3e900793          	li	a5,1001
80009720:	aa2d                	j	8000985a <.L41>

80009722 <.L25>:
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80009722:	47b2                	lw	a5,12(sp)
80009724:	4bdc                	lw	a5,20(a5)
80009726:	fe07f713          	and	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
8000972a:	01b14783          	lbu	a5,27(sp)
8000972e:	8bfd                	and	a5,a5,31
80009730:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80009732:	47b2                	lw	a5,12(sp)
80009734:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
80009736:	01815783          	lhu	a5,24(sp)
8000973a:	0ff7f713          	zext.b	a4,a5
8000973e:	47b2                	lw	a5,12(sp)
80009740:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
80009742:	01815783          	lhu	a5,24(sp)
80009746:	83a1                	srl	a5,a5,0x8
80009748:	07c2                	sll	a5,a5,0x10
8000974a:	83c1                	srl	a5,a5,0x10
8000974c:	0ff7f713          	zext.b	a4,a5
80009750:	47b2                	lw	a5,12(sp)
80009752:	d3d8                	sw	a4,36(a5)
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
80009754:	47b2                	lw	a5,12(sp)
80009756:	57dc                	lw	a5,44(a5)
80009758:	f7f7f793          	and	a5,a5,-129
8000975c:	ce3e                	sw	a5,28(sp)
    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
8000975e:	47f2                	lw	a5,28(sp)
80009760:	fc77f793          	and	a5,a5,-57
80009764:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
80009766:	47a2                	lw	a5,8(sp)
80009768:	00a7c783          	lbu	a5,10(a5)
8000976c:	4711                	li	a4,4
8000976e:	02f76f63          	bltu	a4,a5,800097ac <.L27>
80009772:	00279713          	sll	a4,a5,0x2
80009776:	800037b7          	lui	a5,0x80003
8000977a:	1b878793          	add	a5,a5,440 # 800031b8 <.L29>
8000977e:	97ba                	add	a5,a5,a4
80009780:	439c                	lw	a5,0(a5)
80009782:	8782                	jr	a5

80009784 <.L32>:
        tmp |= UART_LCR_PEN_MASK;
80009784:	47f2                	lw	a5,28(sp)
80009786:	0087e793          	or	a5,a5,8
8000978a:	ce3e                	sw	a5,28(sp)
        break;
8000978c:	a01d                	j	800097b2 <.L34>

8000978e <.L31>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
8000978e:	47f2                	lw	a5,28(sp)
80009790:	0187e793          	or	a5,a5,24
80009794:	ce3e                	sw	a5,28(sp)
        break;
80009796:	a831                	j	800097b2 <.L34>

80009798 <.L30>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
80009798:	47f2                	lw	a5,28(sp)
8000979a:	0287e793          	or	a5,a5,40
8000979e:	ce3e                	sw	a5,28(sp)
        break;
800097a0:	a809                	j	800097b2 <.L34>

800097a2 <.L28>:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
800097a2:	47f2                	lw	a5,28(sp)
800097a4:	0387e793          	or	a5,a5,56
800097a8:	ce3e                	sw	a5,28(sp)
        break;
800097aa:	a021                	j	800097b2 <.L34>

800097ac <.L27>:
        return status_invalid_argument;
800097ac:	4789                	li	a5,2
800097ae:	a075                	j	8000985a <.L41>

800097b0 <.L42>:
        break;
800097b0:	0001                	nop

800097b2 <.L34>:
    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
800097b2:	47f2                	lw	a5,28(sp)
800097b4:	9be1                	and	a5,a5,-8
800097b6:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
800097b8:	47a2                	lw	a5,8(sp)
800097ba:	0087c783          	lbu	a5,8(a5)
800097be:	4709                	li	a4,2
800097c0:	00e78e63          	beq	a5,a4,800097dc <.L35>
800097c4:	4709                	li	a4,2
800097c6:	02f74663          	blt	a4,a5,800097f2 <.L36>
800097ca:	c795                	beqz	a5,800097f6 <.L43>
800097cc:	4705                	li	a4,1
800097ce:	02e79263          	bne	a5,a4,800097f2 <.L36>
        tmp |= UART_LCR_STB_MASK;
800097d2:	47f2                	lw	a5,28(sp)
800097d4:	0047e793          	or	a5,a5,4
800097d8:	ce3e                	sw	a5,28(sp)
        break;
800097da:	a839                	j	800097f8 <.L39>

800097dc <.L35>:
        if (config->word_length < word_length_6_bits) {
800097dc:	47a2                	lw	a5,8(sp)
800097de:	0097c783          	lbu	a5,9(a5)
800097e2:	e399                	bnez	a5,800097e8 <.L40>
            return status_invalid_argument;
800097e4:	4789                	li	a5,2
800097e6:	a895                	j	8000985a <.L41>

800097e8 <.L40>:
        tmp |= UART_LCR_STB_MASK;
800097e8:	47f2                	lw	a5,28(sp)
800097ea:	0047e793          	or	a5,a5,4
800097ee:	ce3e                	sw	a5,28(sp)
        break;
800097f0:	a021                	j	800097f8 <.L39>

800097f2 <.L36>:
        return status_invalid_argument;
800097f2:	4789                	li	a5,2
800097f4:	a09d                	j	8000985a <.L41>

800097f6 <.L43>:
        break;
800097f6:	0001                	nop

800097f8 <.L39>:
    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
800097f8:	47a2                	lw	a5,8(sp)
800097fa:	0097c783          	lbu	a5,9(a5)
800097fe:	0037f713          	and	a4,a5,3
80009802:	47f2                	lw	a5,28(sp)
80009804:	8f5d                	or	a4,a4,a5
80009806:	47b2                	lw	a5,12(sp)
80009808:	d7d8                	sw	a4,44(a5)
    ptr->FCR = UART_FCR_TFIFORST_MASK | UART_FCR_RFIFORST_MASK;
8000980a:	47b2                	lw	a5,12(sp)
8000980c:	4719                	li	a4,6
8000980e:	d798                	sw	a4,40(a5)
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
80009810:	47a2                	lw	a5,8(sp)
80009812:	00e7c783          	lbu	a5,14(a5)
80009816:	873e                	mv	a4,a5
        | UART_FCR_TFIFOT_SET(config->tx_fifo_level)
80009818:	47a2                	lw	a5,8(sp)
8000981a:	00b7c783          	lbu	a5,11(a5)
8000981e:	0792                	sll	a5,a5,0x4
80009820:	0307f793          	and	a5,a5,48
80009824:	8f5d                	or	a4,a4,a5
        | UART_FCR_RFIFOT_SET(config->rx_fifo_level)
80009826:	47a2                	lw	a5,8(sp)
80009828:	00c7c783          	lbu	a5,12(a5)
8000982c:	079a                	sll	a5,a5,0x6
8000982e:	0ff7f793          	zext.b	a5,a5
80009832:	8f5d                	or	a4,a4,a5
        | UART_FCR_DMAE_SET(config->dma_enable);
80009834:	47a2                	lw	a5,8(sp)
80009836:	00d7c783          	lbu	a5,13(a5)
8000983a:	078e                	sll	a5,a5,0x3
8000983c:	8ba1                	and	a5,a5,8
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
8000983e:	8fd9                	or	a5,a5,a4
80009840:	ce3e                	sw	a5,28(sp)
    ptr->FCR = tmp;
80009842:	47b2                	lw	a5,12(sp)
80009844:	4772                	lw	a4,28(sp)
80009846:	d798                	sw	a4,40(a5)
    ptr->GPR = tmp;
80009848:	47b2                	lw	a5,12(sp)
8000984a:	4772                	lw	a4,28(sp)
8000984c:	dfd8                	sw	a4,60(a5)
    uart_modem_config(ptr, &config->modem_config);
8000984e:	47a2                	lw	a5,8(sp)
80009850:	07bd                	add	a5,a5,15
80009852:	85be                	mv	a1,a5
80009854:	4532                	lw	a0,12(sp)
80009856:	35b9                	jal	800096a4 <uart_modem_config>
    return status_success;
80009858:	4781                	li	a5,0

8000985a <.L41>:
}
8000985a:	853e                	mv	a0,a5
8000985c:	50b2                	lw	ra,44(sp)
8000985e:	6145                	add	sp,sp,48
80009860:	8082                	ret

Disassembly of section .text.uart_flush:

80009862 <uart_flush>:

hpm_stat_t uart_flush(UART_Type *ptr)
{
80009862:	1101                	add	sp,sp,-32
80009864:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
80009866:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80009868:	a811                	j	8000987c <.L57>

8000986a <.L60>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000986a:	4772                	lw	a4,28(sp)
8000986c:	6785                	lui	a5,0x1
8000986e:	38878793          	add	a5,a5,904 # 1388 <__fw_size__+0x388>
80009872:	00e7eb63          	bltu	a5,a4,80009888 <.L63>
            break;
        }
        retry++;
80009876:	47f2                	lw	a5,28(sp)
80009878:	0785                	add	a5,a5,1
8000987a:	ce3e                	sw	a5,28(sp)

8000987c <.L57>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
8000987c:	47b2                	lw	a5,12(sp)
8000987e:	5bdc                	lw	a5,52(a5)
80009880:	0407f793          	and	a5,a5,64
80009884:	d3fd                	beqz	a5,8000986a <.L60>
80009886:	a011                	j	8000988a <.L59>

80009888 <.L63>:
            break;
80009888:	0001                	nop

8000988a <.L59>:
    }
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000988a:	4772                	lw	a4,28(sp)
8000988c:	6785                	lui	a5,0x1
8000988e:	38878793          	add	a5,a5,904 # 1388 <__fw_size__+0x388>
80009892:	00e7f463          	bgeu	a5,a4,8000989a <.L61>
        return status_timeout;
80009896:	478d                	li	a5,3
80009898:	a011                	j	8000989c <.L62>

8000989a <.L61>:
    }

    return status_success;
8000989a:	4781                	li	a5,0

8000989c <.L62>:
}
8000989c:	853e                	mv	a0,a5
8000989e:	6105                	add	sp,sp,32
800098a0:	8082                	ret

Disassembly of section .text.WIZCHIP_WRITE:

800098a2 <WIZCHIP_WRITE>:
{
800098a2:	7179                	add	sp,sp,-48
800098a4:	d606                	sw	ra,44(sp)
800098a6:	c62a                	sw	a0,12(sp)
800098a8:	87ae                	mv	a5,a1
800098aa:	00f105a3          	sb	a5,11(sp)
   WIZCHIP_CRITICAL_ENTER();
800098ae:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800098b2:	47dc                	lw	a5,12(a5)
800098b4:	9782                	jalr	a5
   WIZCHIP.CS._select();
800098b6:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800098ba:	4bdc                	lw	a5,20(a5)
800098bc:	9782                	jalr	a5
   AddrSel |= (_W5500_SPI_WRITE_ | _W5500_SPI_VDM_OP_);
800098be:	47b2                	lw	a5,12(sp)
800098c0:	0047e793          	or	a5,a5,4
800098c4:	c63e                	sw	a5,12(sp)
   if(!WIZCHIP.IF.SPI._write_burst) 	// byte operation
800098c6:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800098ca:	579c                	lw	a5,40(a5)
800098cc:	e3b9                	bnez	a5,80009912 <.L7>
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
800098ce:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800098d2:	539c                	lw	a5,32(a5)
800098d4:	4732                	lw	a4,12(sp)
800098d6:	8341                	srl	a4,a4,0x10
800098d8:	0ff77713          	zext.b	a4,a4
800098dc:	853a                	mv	a0,a4
800098de:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
800098e0:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800098e4:	539c                	lw	a5,32(a5)
800098e6:	4732                	lw	a4,12(sp)
800098e8:	8321                	srl	a4,a4,0x8
800098ea:	0ff77713          	zext.b	a4,a4
800098ee:	853a                	mv	a0,a4
800098f0:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x000000FF) >>  0);
800098f2:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800098f6:	539c                	lw	a5,32(a5)
800098f8:	4732                	lw	a4,12(sp)
800098fa:	0ff77713          	zext.b	a4,a4
800098fe:	853a                	mv	a0,a4
80009900:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte(wb);
80009902:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009906:	539c                	lw	a5,32(a5)
80009908:	00b14703          	lbu	a4,11(sp)
8000990c:	853a                	mv	a0,a4
8000990e:	9782                	jalr	a5
80009910:	a82d                	j	8000994a <.L8>

80009912 <.L7>:
		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
80009912:	47b2                	lw	a5,12(sp)
80009914:	83c1                	srl	a5,a5,0x10
80009916:	0ff7f793          	zext.b	a5,a5
8000991a:	00f10e23          	sb	a5,28(sp)
		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
8000991e:	47b2                	lw	a5,12(sp)
80009920:	83a1                	srl	a5,a5,0x8
80009922:	0ff7f793          	zext.b	a5,a5
80009926:	00f10ea3          	sb	a5,29(sp)
		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
8000992a:	47b2                	lw	a5,12(sp)
8000992c:	0ff7f793          	zext.b	a5,a5
80009930:	00f10f23          	sb	a5,30(sp)
		spi_data[3] = wb;
80009934:	00b14783          	lbu	a5,11(sp)
80009938:	00f10fa3          	sb	a5,31(sp)
		WIZCHIP.IF.SPI._write_burst(spi_data, 4);
8000993c:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009940:	579c                	lw	a5,40(a5)
80009942:	0878                	add	a4,sp,28
80009944:	4591                	li	a1,4
80009946:	853a                	mv	a0,a4
80009948:	9782                	jalr	a5

8000994a <.L8>:
   WIZCHIP.CS._deselect();
8000994a:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000994e:	4f9c                	lw	a5,24(a5)
80009950:	9782                	jalr	a5
   WIZCHIP_CRITICAL_EXIT();
80009952:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009956:	4b9c                	lw	a5,16(a5)
80009958:	9782                	jalr	a5
}
8000995a:	0001                	nop
8000995c:	50b2                	lw	ra,44(sp)
8000995e:	6145                	add	sp,sp,48
80009960:	8082                	ret

Disassembly of section .text.WIZCHIP_READ_BUF:

80009962 <WIZCHIP_READ_BUF>:
{
80009962:	7179                	add	sp,sp,-48
80009964:	d606                	sw	ra,44(sp)
80009966:	d422                	sw	s0,40(sp)
80009968:	c62a                	sw	a0,12(sp)
8000996a:	c42e                	sw	a1,8(sp)
8000996c:	87b2                	mv	a5,a2
8000996e:	00f11323          	sh	a5,6(sp)
   WIZCHIP_CRITICAL_ENTER();
80009972:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009976:	47dc                	lw	a5,12(a5)
80009978:	9782                	jalr	a5
   WIZCHIP.CS._select();
8000997a:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000997e:	4bdc                	lw	a5,20(a5)
80009980:	9782                	jalr	a5
   if(!WIZCHIP.IF.SPI._read_burst || !WIZCHIP.IF.SPI._write_burst) 	// byte operation
80009982:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009986:	53dc                	lw	a5,36(a5)
80009988:	c789                	beqz	a5,80009992 <.L10>
8000998a:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000998e:	579c                	lw	a5,40(a5)
80009990:	e7b5                	bnez	a5,800099fc <.L11>

80009992 <.L10>:
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
80009992:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009996:	539c                	lw	a5,32(a5)
80009998:	4732                	lw	a4,12(sp)
8000999a:	8341                	srl	a4,a4,0x10
8000999c:	0ff77713          	zext.b	a4,a4
800099a0:	853a                	mv	a0,a4
800099a2:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
800099a4:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800099a8:	539c                	lw	a5,32(a5)
800099aa:	4732                	lw	a4,12(sp)
800099ac:	8321                	srl	a4,a4,0x8
800099ae:	0ff77713          	zext.b	a4,a4
800099b2:	853a                	mv	a0,a4
800099b4:	9782                	jalr	a5
		WIZCHIP.IF.SPI._write_byte((AddrSel & 0x000000FF) >>  0);
800099b6:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800099ba:	539c                	lw	a5,32(a5)
800099bc:	4732                	lw	a4,12(sp)
800099be:	0ff77713          	zext.b	a4,a4
800099c2:	853a                	mv	a0,a4
800099c4:	9782                	jalr	a5
		for(i = 0; i < len; i++)
800099c6:	00011f23          	sh	zero,30(sp)
800099ca:	a015                	j	800099ee <.L12>

800099cc <.L13>:
		   pBuf[i] = WIZCHIP.IF.SPI._read_byte();
800099cc:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
800099d0:	4fdc                	lw	a5,28(a5)
800099d2:	01e15703          	lhu	a4,30(sp)
800099d6:	46a2                	lw	a3,8(sp)
800099d8:	00e68433          	add	s0,a3,a4
800099dc:	9782                	jalr	a5
800099de:	87aa                	mv	a5,a0
800099e0:	00f40023          	sb	a5,0(s0)
		for(i = 0; i < len; i++)
800099e4:	01e15783          	lhu	a5,30(sp)
800099e8:	0785                	add	a5,a5,1
800099ea:	00f11f23          	sh	a5,30(sp)

800099ee <.L12>:
800099ee:	01e15703          	lhu	a4,30(sp)
800099f2:	00615783          	lhu	a5,6(sp)
800099f6:	fcf76be3          	bltu	a4,a5,800099cc <.L13>
   if(!WIZCHIP.IF.SPI._read_burst || !WIZCHIP.IF.SPI._write_burst) 	// byte operation
800099fa:	a089                	j	80009a3c <.L14>

800099fc <.L11>:
		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
800099fc:	47b2                	lw	a5,12(sp)
800099fe:	83c1                	srl	a5,a5,0x10
80009a00:	0ff7f793          	zext.b	a5,a5
80009a04:	00f10c23          	sb	a5,24(sp)
		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
80009a08:	47b2                	lw	a5,12(sp)
80009a0a:	83a1                	srl	a5,a5,0x8
80009a0c:	0ff7f793          	zext.b	a5,a5
80009a10:	00f10ca3          	sb	a5,25(sp)
		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
80009a14:	47b2                	lw	a5,12(sp)
80009a16:	0ff7f793          	zext.b	a5,a5
80009a1a:	00f10d23          	sb	a5,26(sp)
		WIZCHIP.IF.SPI._write_burst(spi_data, 3);
80009a1e:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009a22:	579c                	lw	a5,40(a5)
80009a24:	0838                	add	a4,sp,24
80009a26:	458d                	li	a1,3
80009a28:	853a                	mv	a0,a4
80009a2a:	9782                	jalr	a5
		WIZCHIP.IF.SPI._read_burst(pBuf, len);
80009a2c:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009a30:	53dc                	lw	a5,36(a5)
80009a32:	00615703          	lhu	a4,6(sp)
80009a36:	85ba                	mv	a1,a4
80009a38:	4522                	lw	a0,8(sp)
80009a3a:	9782                	jalr	a5

80009a3c <.L14>:
   WIZCHIP.CS._deselect();
80009a3c:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009a40:	4f9c                	lw	a5,24(a5)
80009a42:	9782                	jalr	a5
   WIZCHIP_CRITICAL_EXIT();
80009a44:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
80009a48:	4b9c                	lw	a5,16(a5)
80009a4a:	9782                	jalr	a5
}
80009a4c:	0001                	nop
80009a4e:	50b2                	lw	ra,44(sp)
80009a50:	5422                	lw	s0,40(sp)
80009a52:	6145                	add	sp,sp,48
80009a54:	8082                	ret

Disassembly of section .text.getSn_TX_FSR:

80009a56 <getSn_TX_FSR>:
{
80009a56:	7179                	add	sp,sp,-48
80009a58:	d606                	sw	ra,44(sp)
80009a5a:	d422                	sw	s0,40(sp)
80009a5c:	87aa                	mv	a5,a0
80009a5e:	00f107a3          	sb	a5,15(sp)
   uint16_t val=0,val1=0;
80009a62:	00011f23          	sh	zero,30(sp)
80009a66:	00011e23          	sh	zero,28(sp)

80009a6a <.L22>:
      val1 = WIZCHIP_READ(Sn_TX_FSR(sn));
80009a6a:	00f14783          	lbu	a5,15(sp)
80009a6e:	078a                	sll	a5,a5,0x2
80009a70:	0785                	add	a5,a5,1
80009a72:	00379713          	sll	a4,a5,0x3
80009a76:	6789                	lui	a5,0x2
80009a78:	97ba                	add	a5,a5,a4
80009a7a:	853e                	mv	a0,a5
80009a7c:	c6afb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009a80:	87aa                	mv	a5,a0
80009a82:	00f11e23          	sh	a5,28(sp)
      val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_FSR(sn),1));
80009a86:	01c15783          	lhu	a5,28(sp)
80009a8a:	07a2                	sll	a5,a5,0x8
80009a8c:	01079413          	sll	s0,a5,0x10
80009a90:	8041                	srl	s0,s0,0x10
80009a92:	00f14783          	lbu	a5,15(sp)
80009a96:	078a                	sll	a5,a5,0x2
80009a98:	0785                	add	a5,a5,1 # 2001 <__APB_SRAM_segment_size__+0x1>
80009a9a:	00379713          	sll	a4,a5,0x3
80009a9e:	6789                	lui	a5,0x2
80009aa0:	10078793          	add	a5,a5,256 # 2100 <__APB_SRAM_segment_size__+0x100>
80009aa4:	97ba                	add	a5,a5,a4
80009aa6:	853e                	mv	a0,a5
80009aa8:	c3efb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009aac:	87aa                	mv	a5,a0
80009aae:	97a2                	add	a5,a5,s0
80009ab0:	00f11e23          	sh	a5,28(sp)
      if (val1 != 0)
80009ab4:	01c15783          	lhu	a5,28(sp)
80009ab8:	c7b1                	beqz	a5,80009b04 <.L21>
        val = WIZCHIP_READ(Sn_TX_FSR(sn));
80009aba:	00f14783          	lbu	a5,15(sp)
80009abe:	078a                	sll	a5,a5,0x2
80009ac0:	0785                	add	a5,a5,1
80009ac2:	00379713          	sll	a4,a5,0x3
80009ac6:	6789                	lui	a5,0x2
80009ac8:	97ba                	add	a5,a5,a4
80009aca:	853e                	mv	a0,a5
80009acc:	c1afb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009ad0:	87aa                	mv	a5,a0
80009ad2:	00f11f23          	sh	a5,30(sp)
        val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_FSR(sn),1));
80009ad6:	01e15783          	lhu	a5,30(sp)
80009ada:	07a2                	sll	a5,a5,0x8
80009adc:	01079413          	sll	s0,a5,0x10
80009ae0:	8041                	srl	s0,s0,0x10
80009ae2:	00f14783          	lbu	a5,15(sp)
80009ae6:	078a                	sll	a5,a5,0x2
80009ae8:	0785                	add	a5,a5,1 # 2001 <__APB_SRAM_segment_size__+0x1>
80009aea:	00379713          	sll	a4,a5,0x3
80009aee:	6789                	lui	a5,0x2
80009af0:	10078793          	add	a5,a5,256 # 2100 <__APB_SRAM_segment_size__+0x100>
80009af4:	97ba                	add	a5,a5,a4
80009af6:	853e                	mv	a0,a5
80009af8:	beefb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009afc:	87aa                	mv	a5,a0
80009afe:	97a2                	add	a5,a5,s0
80009b00:	00f11f23          	sh	a5,30(sp)

80009b04 <.L21>:
   }while (val != val1);
80009b04:	01e15703          	lhu	a4,30(sp)
80009b08:	01c15783          	lhu	a5,28(sp)
80009b0c:	f4f71fe3          	bne	a4,a5,80009a6a <.L22>
   return val;
80009b10:	01e15783          	lhu	a5,30(sp)
}
80009b14:	853e                	mv	a0,a5
80009b16:	50b2                	lw	ra,44(sp)
80009b18:	5422                	lw	s0,40(sp)
80009b1a:	6145                	add	sp,sp,48
80009b1c:	8082                	ret

Disassembly of section .text.getSn_RX_RSR:

80009b1e <getSn_RX_RSR>:
{
80009b1e:	7179                	add	sp,sp,-48
80009b20:	d606                	sw	ra,44(sp)
80009b22:	d422                	sw	s0,40(sp)
80009b24:	87aa                	mv	a5,a0
80009b26:	00f107a3          	sb	a5,15(sp)
   uint16_t val=0,val1=0;
80009b2a:	00011f23          	sh	zero,30(sp)
80009b2e:	00011e23          	sh	zero,28(sp)

80009b32 <.L26>:
      val1 = WIZCHIP_READ(Sn_RX_RSR(sn));
80009b32:	00f14783          	lbu	a5,15(sp)
80009b36:	078a                	sll	a5,a5,0x2
80009b38:	0785                	add	a5,a5,1
80009b3a:	00379713          	sll	a4,a5,0x3
80009b3e:	6789                	lui	a5,0x2
80009b40:	60078793          	add	a5,a5,1536 # 2600 <__APB_SRAM_segment_size__+0x600>
80009b44:	97ba                	add	a5,a5,a4
80009b46:	853e                	mv	a0,a5
80009b48:	b9efb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009b4c:	87aa                	mv	a5,a0
80009b4e:	00f11e23          	sh	a5,28(sp)
      val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
80009b52:	01c15783          	lhu	a5,28(sp)
80009b56:	07a2                	sll	a5,a5,0x8
80009b58:	01079413          	sll	s0,a5,0x10
80009b5c:	8041                	srl	s0,s0,0x10
80009b5e:	00f14783          	lbu	a5,15(sp)
80009b62:	078a                	sll	a5,a5,0x2
80009b64:	0785                	add	a5,a5,1
80009b66:	00379713          	sll	a4,a5,0x3
80009b6a:	6789                	lui	a5,0x2
80009b6c:	70078793          	add	a5,a5,1792 # 2700 <__APB_SRAM_segment_size__+0x700>
80009b70:	97ba                	add	a5,a5,a4
80009b72:	853e                	mv	a0,a5
80009b74:	b72fb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009b78:	87aa                	mv	a5,a0
80009b7a:	97a2                	add	a5,a5,s0
80009b7c:	00f11e23          	sh	a5,28(sp)
      if (val1 != 0)
80009b80:	01c15783          	lhu	a5,28(sp)
80009b84:	cba1                	beqz	a5,80009bd4 <.L25>
        val = WIZCHIP_READ(Sn_RX_RSR(sn));
80009b86:	00f14783          	lbu	a5,15(sp)
80009b8a:	078a                	sll	a5,a5,0x2
80009b8c:	0785                	add	a5,a5,1
80009b8e:	00379713          	sll	a4,a5,0x3
80009b92:	6789                	lui	a5,0x2
80009b94:	60078793          	add	a5,a5,1536 # 2600 <__APB_SRAM_segment_size__+0x600>
80009b98:	97ba                	add	a5,a5,a4
80009b9a:	853e                	mv	a0,a5
80009b9c:	b4afb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009ba0:	87aa                	mv	a5,a0
80009ba2:	00f11f23          	sh	a5,30(sp)
        val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
80009ba6:	01e15783          	lhu	a5,30(sp)
80009baa:	07a2                	sll	a5,a5,0x8
80009bac:	01079413          	sll	s0,a5,0x10
80009bb0:	8041                	srl	s0,s0,0x10
80009bb2:	00f14783          	lbu	a5,15(sp)
80009bb6:	078a                	sll	a5,a5,0x2
80009bb8:	0785                	add	a5,a5,1
80009bba:	00379713          	sll	a4,a5,0x3
80009bbe:	6789                	lui	a5,0x2
80009bc0:	70078793          	add	a5,a5,1792 # 2700 <__APB_SRAM_segment_size__+0x700>
80009bc4:	97ba                	add	a5,a5,a4
80009bc6:	853e                	mv	a0,a5
80009bc8:	b1efb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009bcc:	87aa                	mv	a5,a0
80009bce:	97a2                	add	a5,a5,s0
80009bd0:	00f11f23          	sh	a5,30(sp)

80009bd4 <.L25>:
   }while (val != val1);
80009bd4:	01e15703          	lhu	a4,30(sp)
80009bd8:	01c15783          	lhu	a5,28(sp)
80009bdc:	f4f71be3          	bne	a4,a5,80009b32 <.L26>
   return val;
80009be0:	01e15783          	lhu	a5,30(sp)
}
80009be4:	853e                	mv	a0,a5
80009be6:	50b2                	lw	ra,44(sp)
80009be8:	5422                	lw	s0,40(sp)
80009bea:	6145                	add	sp,sp,48
80009bec:	8082                	ret

Disassembly of section .text.socket:

80009bee <socket>:
{
80009bee:	7179                	add	sp,sp,-48
80009bf0:	d606                	sw	ra,44(sp)
80009bf2:	87aa                	mv	a5,a0
80009bf4:	8736                	mv	a4,a3
80009bf6:	00f107a3          	sb	a5,15(sp)
80009bfa:	87ae                	mv	a5,a1
80009bfc:	00f10723          	sb	a5,14(sp)
80009c00:	87b2                	mv	a5,a2
80009c02:	00f11623          	sh	a5,12(sp)
80009c06:	87ba                	mv	a5,a4
80009c08:	00f105a3          	sb	a5,11(sp)
	CHECK_SOCKNUM();
80009c0c:	00f14703          	lbu	a4,15(sp)
80009c10:	47a1                	li	a5,8
80009c12:	00e7f463          	bgeu	a5,a4,80009c1a <.L2>
80009c16:	57fd                	li	a5,-1
80009c18:	ac1d                	j	80009e4e <.L3>

80009c1a <.L2>:
	switch(protocol)
80009c1a:	00e14783          	lbu	a5,14(sp)
80009c1e:	4705                	li	a4,1
80009c20:	00e78a63          	beq	a5,a4,80009c34 <.L4>
80009c24:	02f05363          	blez	a5,80009c4a <.L5>
80009c28:	ffe78713          	add	a4,a5,-2
80009c2c:	4789                	li	a5,2
80009c2e:	00e7ee63          	bltu	a5,a4,80009c4a <.L5>
         break;
80009c32:	a839                	j	80009c50 <.L9>

80009c34 <.L4>:
            getSIPR((uint8_t*)&taddr);
80009c34:	087c                	add	a5,sp,28
80009c36:	4611                	li	a2,4
80009c38:	85be                	mv	a1,a5
80009c3a:	6785                	lui	a5,0x1
80009c3c:	f0078513          	add	a0,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
80009c40:	330d                	jal	80009962 <WIZCHIP_READ_BUF>
            if(taddr == 0) return SOCKERR_SOCKINIT;
80009c42:	47f2                	lw	a5,28(sp)
80009c44:	e789                	bnez	a5,80009c4e <.L21>
80009c46:	57f5                	li	a5,-3
80009c48:	a419                	j	80009e4e <.L3>

80009c4a <.L5>:
         return SOCKERR_SOCKMODE;
80009c4a:	57ed                	li	a5,-5
80009c4c:	a409                	j	80009e4e <.L3>

80009c4e <.L21>:
	    break;
80009c4e:	0001                	nop

80009c50 <.L9>:
	if((flag & 0x04) != 0) return SOCKERR_SOCKFLAG;
80009c50:	00b14783          	lbu	a5,11(sp)
80009c54:	8b91                	and	a5,a5,4
80009c56:	c399                	beqz	a5,80009c5c <.L10>
80009c58:	57e9                	li	a5,-6
80009c5a:	aad5                	j	80009e4e <.L3>

80009c5c <.L10>:
	if(flag != 0)
80009c5c:	00b14783          	lbu	a5,11(sp)
80009c60:	cba9                	beqz	a5,80009cb2 <.L11>
   	switch(protocol)
80009c62:	00e14783          	lbu	a5,14(sp)
80009c66:	4705                	li	a4,1
80009c68:	00e78663          	beq	a5,a4,80009c74 <.L12>
80009c6c:	4709                	li	a4,2
80009c6e:	00e78a63          	beq	a5,a4,80009c82 <.L13>
   	      break;
80009c72:	a081                	j	80009cb2 <.L11>

80009c74 <.L12>:
   		     if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
80009c74:	00b14783          	lbu	a5,11(sp)
80009c78:	0217f793          	and	a5,a5,33
80009c7c:	eb85                	bnez	a5,80009cac <.L22>
80009c7e:	57e9                	li	a5,-6
80009c80:	a2f9                	j	80009e4e <.L3>

80009c82 <.L13>:
   	      if(flag & SF_IGMP_VER2)
80009c82:	00b14783          	lbu	a5,11(sp)
80009c86:	0207f793          	and	a5,a5,32
80009c8a:	c799                	beqz	a5,80009c98 <.L16>
   	         if((flag & SF_MULTI_ENABLE)==0) return SOCKERR_SOCKFLAG;
80009c8c:	00b10783          	lb	a5,11(sp)
80009c90:	0007c463          	bltz	a5,80009c98 <.L16>
80009c94:	57e9                	li	a5,-6
80009c96:	aa65                	j	80009e4e <.L3>

80009c98 <.L16>:
      	      if(flag & SF_UNI_BLOCK)
80009c98:	00b14783          	lbu	a5,11(sp)
80009c9c:	8bc1                	and	a5,a5,16
80009c9e:	cb89                	beqz	a5,80009cb0 <.L23>
      	         if((flag & SF_MULTI_ENABLE) == 0) return SOCKERR_SOCKFLAG;
80009ca0:	00b10783          	lb	a5,11(sp)
80009ca4:	0007c663          	bltz	a5,80009cb0 <.L23>
80009ca8:	57e9                	li	a5,-6
80009caa:	a255                	j	80009e4e <.L3>

80009cac <.L22>:
   	      break;
80009cac:	0001                	nop
80009cae:	a011                	j	80009cb2 <.L11>

80009cb0 <.L23>:
   	      break;
80009cb0:	0001                	nop

80009cb2 <.L11>:
	close(sn);
80009cb2:	00f14783          	lbu	a5,15(sp)
80009cb6:	853e                	mv	a0,a5
80009cb8:	2a79                	jal	80009e56 <.LFE0>
	   setSn_MR(sn, (protocol | (flag & 0xF0)));
80009cba:	00f14783          	lbu	a5,15(sp)
80009cbe:	078a                	sll	a5,a5,0x2
80009cc0:	0785                	add	a5,a5,1
80009cc2:	00379693          	sll	a3,a5,0x3
80009cc6:	00b10783          	lb	a5,11(sp)
80009cca:	9bc1                	and	a5,a5,-16
80009ccc:	01879713          	sll	a4,a5,0x18
80009cd0:	8761                	sra	a4,a4,0x18
80009cd2:	00e10783          	lb	a5,14(sp)
80009cd6:	8fd9                	or	a5,a5,a4
80009cd8:	07e2                	sll	a5,a5,0x18
80009cda:	87e1                	sra	a5,a5,0x18
80009cdc:	0ff7f793          	zext.b	a5,a5
80009ce0:	85be                	mv	a1,a5
80009ce2:	8536                	mv	a0,a3
80009ce4:	3e7d                	jal	800098a2 <WIZCHIP_WRITE>
	if(!port)
80009ce6:	00c15783          	lhu	a5,12(sp)
80009cea:	e78d                	bnez	a5,80009d14 <.L18>
	   port = sock_any_port++;
80009cec:	1661d783          	lhu	a5,358(gp) # 1080966 <sock_any_port>
80009cf0:	00178713          	add	a4,a5,1
80009cf4:	01071693          	sll	a3,a4,0x10
80009cf8:	82c1                	srl	a3,a3,0x10
80009cfa:	16d19323          	sh	a3,358(gp) # 1080966 <sock_any_port>
80009cfe:	00f11623          	sh	a5,12(sp)
	   if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
80009d02:	1661d703          	lhu	a4,358(gp) # 1080966 <sock_any_port>
80009d06:	67c1                	lui	a5,0x10
80009d08:	17c1                	add	a5,a5,-16 # fff0 <__XPI0_segment_used_size__+0x3f9c>
80009d0a:	00f71563          	bne	a4,a5,80009d14 <.L18>
80009d0e:	7771                	lui	a4,0xffffc
80009d10:	16e19323          	sh	a4,358(gp) # 1080966 <sock_any_port>

80009d14 <.L18>:
   setSn_PORT(sn,port);	
80009d14:	00f14783          	lbu	a5,15(sp)
80009d18:	078a                	sll	a5,a5,0x2
80009d1a:	0785                	add	a5,a5,1
80009d1c:	078e                	sll	a5,a5,0x3
80009d1e:	40078793          	add	a5,a5,1024
80009d22:	873e                	mv	a4,a5
80009d24:	00c15783          	lhu	a5,12(sp)
80009d28:	83a1                	srl	a5,a5,0x8
80009d2a:	07c2                	sll	a5,a5,0x10
80009d2c:	83c1                	srl	a5,a5,0x10
80009d2e:	0ff7f793          	zext.b	a5,a5
80009d32:	85be                	mv	a1,a5
80009d34:	853a                	mv	a0,a4
80009d36:	36b5                	jal	800098a2 <WIZCHIP_WRITE>
80009d38:	00f14783          	lbu	a5,15(sp)
80009d3c:	078a                	sll	a5,a5,0x2
80009d3e:	0785                	add	a5,a5,1
80009d40:	078e                	sll	a5,a5,0x3
80009d42:	50078793          	add	a5,a5,1280
80009d46:	873e                	mv	a4,a5
80009d48:	00c15783          	lhu	a5,12(sp)
80009d4c:	0ff7f793          	zext.b	a5,a5
80009d50:	85be                	mv	a1,a5
80009d52:	853a                	mv	a0,a4
80009d54:	36b9                	jal	800098a2 <WIZCHIP_WRITE>
   setSn_CR(sn,Sn_CR_OPEN);
80009d56:	00f14783          	lbu	a5,15(sp)
80009d5a:	078a                	sll	a5,a5,0x2
80009d5c:	0785                	add	a5,a5,1
80009d5e:	078e                	sll	a5,a5,0x3
80009d60:	10078793          	add	a5,a5,256
80009d64:	4585                	li	a1,1
80009d66:	853e                	mv	a0,a5
80009d68:	3e2d                	jal	800098a2 <WIZCHIP_WRITE>
   while(getSn_CR(sn));
80009d6a:	0001                	nop

80009d6c <.L19>:
80009d6c:	00f14783          	lbu	a5,15(sp)
80009d70:	078a                	sll	a5,a5,0x2
80009d72:	0785                	add	a5,a5,1
80009d74:	078e                	sll	a5,a5,0x3
80009d76:	10078793          	add	a5,a5,256
80009d7a:	853e                	mv	a0,a5
80009d7c:	96afb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009d80:	87aa                	mv	a5,a0
80009d82:	f7ed                	bnez	a5,80009d6c <.L19>
   sock_io_mode &= ~(1 <<sn);
80009d84:	00f14783          	lbu	a5,15(sp)
80009d88:	4705                	li	a4,1
80009d8a:	00f717b3          	sll	a5,a4,a5
80009d8e:	07c2                	sll	a5,a5,0x10
80009d90:	87c1                	sra	a5,a5,0x10
80009d92:	fff7c793          	not	a5,a5
80009d96:	01079713          	sll	a4,a5,0x10
80009d9a:	8741                	sra	a4,a4,0x10
80009d9c:	1601d783          	lhu	a5,352(gp) # 1080960 <sock_io_mode>
80009da0:	07c2                	sll	a5,a5,0x10
80009da2:	87c1                	sra	a5,a5,0x10
80009da4:	8ff9                	and	a5,a5,a4
80009da6:	07c2                	sll	a5,a5,0x10
80009da8:	87c1                	sra	a5,a5,0x10
80009daa:	01079713          	sll	a4,a5,0x10
80009dae:	8341                	srl	a4,a4,0x10
80009db0:	16e19023          	sh	a4,352(gp) # 1080960 <sock_io_mode>
	sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);   
80009db4:	00b14783          	lbu	a5,11(sp)
80009db8:	0017f713          	and	a4,a5,1
80009dbc:	00f14783          	lbu	a5,15(sp)
80009dc0:	00f717b3          	sll	a5,a4,a5
80009dc4:	01079713          	sll	a4,a5,0x10
80009dc8:	8741                	sra	a4,a4,0x10
80009dca:	1601d783          	lhu	a5,352(gp) # 1080960 <sock_io_mode>
80009dce:	07c2                	sll	a5,a5,0x10
80009dd0:	87c1                	sra	a5,a5,0x10
80009dd2:	8fd9                	or	a5,a5,a4
80009dd4:	07c2                	sll	a5,a5,0x10
80009dd6:	87c1                	sra	a5,a5,0x10
80009dd8:	01079713          	sll	a4,a5,0x10
80009ddc:	8341                	srl	a4,a4,0x10
80009dde:	16e19023          	sh	a4,352(gp) # 1080960 <sock_io_mode>
   sock_is_sending &= ~(1<<sn);
80009de2:	00f14783          	lbu	a5,15(sp)
80009de6:	4705                	li	a4,1
80009de8:	00f717b3          	sll	a5,a4,a5
80009dec:	07c2                	sll	a5,a5,0x10
80009dee:	87c1                	sra	a5,a5,0x10
80009df0:	fff7c793          	not	a5,a5
80009df4:	01079713          	sll	a4,a5,0x10
80009df8:	8741                	sra	a4,a4,0x10
80009dfa:	11e1d783          	lhu	a5,286(gp) # 108091e <sock_is_sending>
80009dfe:	07c2                	sll	a5,a5,0x10
80009e00:	87c1                	sra	a5,a5,0x10
80009e02:	8ff9                	and	a5,a5,a4
80009e04:	07c2                	sll	a5,a5,0x10
80009e06:	87c1                	sra	a5,a5,0x10
80009e08:	01079713          	sll	a4,a5,0x10
80009e0c:	8341                	srl	a4,a4,0x10
80009e0e:	10e19f23          	sh	a4,286(gp) # 108091e <sock_is_sending>
   sock_remained_size[sn] = 0;
80009e12:	00f14783          	lbu	a5,15(sp)
80009e16:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
80009e1a:	0786                	sll	a5,a5,0x1
80009e1c:	97ba                	add	a5,a5,a4
80009e1e:	00079023          	sh	zero,0(a5)
   sock_pack_info[sn] = PACK_COMPLETED;
80009e22:	00f14783          	lbu	a5,15(sp)
80009e26:	11018713          	add	a4,gp,272 # 1080910 <sock_pack_info>
80009e2a:	97ba                	add	a5,a5,a4
80009e2c:	00078023          	sb	zero,0(a5)
   while(getSn_SR(sn) == SOCK_CLOSED);
80009e30:	0001                	nop

80009e32 <.L20>:
80009e32:	00f14783          	lbu	a5,15(sp)
80009e36:	078a                	sll	a5,a5,0x2
80009e38:	0785                	add	a5,a5,1
80009e3a:	078e                	sll	a5,a5,0x3
80009e3c:	30078793          	add	a5,a5,768
80009e40:	853e                	mv	a0,a5
80009e42:	8a4fb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009e46:	87aa                	mv	a5,a0
80009e48:	d7ed                	beqz	a5,80009e32 <.L20>
   return (int8_t)sn;
80009e4a:	00f10783          	lb	a5,15(sp)

80009e4e <.L3>:
}	   
80009e4e:	853e                	mv	a0,a5
80009e50:	50b2                	lw	ra,44(sp)
80009e52:	6145                	add	sp,sp,48
80009e54:	8082                	ret

Disassembly of section .text.close:

80009e56 <close>:
{
80009e56:	1101                	add	sp,sp,-32
80009e58:	ce06                	sw	ra,28(sp)
80009e5a:	87aa                	mv	a5,a0
80009e5c:	00f107a3          	sb	a5,15(sp)
	CHECK_SOCKNUM();
80009e60:	00f14703          	lbu	a4,15(sp)
80009e64:	47a1                	li	a5,8
80009e66:	00e7f463          	bgeu	a5,a4,80009e6e <.L25>
80009e6a:	57fd                	li	a5,-1
80009e6c:	a8f9                	j	80009f4a <.L26>

80009e6e <.L25>:
	setSn_CR(sn,Sn_CR_CLOSE);
80009e6e:	00f14783          	lbu	a5,15(sp)
80009e72:	078a                	sll	a5,a5,0x2
80009e74:	0785                	add	a5,a5,1
80009e76:	078e                	sll	a5,a5,0x3
80009e78:	10078793          	add	a5,a5,256
80009e7c:	45c1                	li	a1,16
80009e7e:	853e                	mv	a0,a5
80009e80:	340d                	jal	800098a2 <WIZCHIP_WRITE>
	while( getSn_CR(sn) );
80009e82:	0001                	nop

80009e84 <.L27>:
80009e84:	00f14783          	lbu	a5,15(sp)
80009e88:	078a                	sll	a5,a5,0x2
80009e8a:	0785                	add	a5,a5,1
80009e8c:	078e                	sll	a5,a5,0x3
80009e8e:	10078793          	add	a5,a5,256
80009e92:	853e                	mv	a0,a5
80009e94:	852fb0ef          	jal	80004ee6 <WIZCHIP_READ>
80009e98:	87aa                	mv	a5,a0
80009e9a:	f7ed                	bnez	a5,80009e84 <.L27>
	setSn_IR(sn, 0xFF);
80009e9c:	00f14783          	lbu	a5,15(sp)
80009ea0:	078a                	sll	a5,a5,0x2
80009ea2:	0785                	add	a5,a5,1
80009ea4:	078e                	sll	a5,a5,0x3
80009ea6:	20078793          	add	a5,a5,512
80009eaa:	45fd                	li	a1,31
80009eac:	853e                	mv	a0,a5
80009eae:	3ad5                	jal	800098a2 <WIZCHIP_WRITE>
	sock_io_mode &= ~(1<<sn);
80009eb0:	00f14783          	lbu	a5,15(sp)
80009eb4:	4705                	li	a4,1
80009eb6:	00f717b3          	sll	a5,a4,a5
80009eba:	07c2                	sll	a5,a5,0x10
80009ebc:	87c1                	sra	a5,a5,0x10
80009ebe:	fff7c793          	not	a5,a5
80009ec2:	01079713          	sll	a4,a5,0x10
80009ec6:	8741                	sra	a4,a4,0x10
80009ec8:	1601d783          	lhu	a5,352(gp) # 1080960 <sock_io_mode>
80009ecc:	07c2                	sll	a5,a5,0x10
80009ece:	87c1                	sra	a5,a5,0x10
80009ed0:	8ff9                	and	a5,a5,a4
80009ed2:	07c2                	sll	a5,a5,0x10
80009ed4:	87c1                	sra	a5,a5,0x10
80009ed6:	01079713          	sll	a4,a5,0x10
80009eda:	8341                	srl	a4,a4,0x10
80009edc:	16e19023          	sh	a4,352(gp) # 1080960 <sock_io_mode>
	sock_is_sending &= ~(1<<sn);
80009ee0:	00f14783          	lbu	a5,15(sp)
80009ee4:	4705                	li	a4,1
80009ee6:	00f717b3          	sll	a5,a4,a5
80009eea:	07c2                	sll	a5,a5,0x10
80009eec:	87c1                	sra	a5,a5,0x10
80009eee:	fff7c793          	not	a5,a5
80009ef2:	01079713          	sll	a4,a5,0x10
80009ef6:	8741                	sra	a4,a4,0x10
80009ef8:	11e1d783          	lhu	a5,286(gp) # 108091e <sock_is_sending>
80009efc:	07c2                	sll	a5,a5,0x10
80009efe:	87c1                	sra	a5,a5,0x10
80009f00:	8ff9                	and	a5,a5,a4
80009f02:	07c2                	sll	a5,a5,0x10
80009f04:	87c1                	sra	a5,a5,0x10
80009f06:	01079713          	sll	a4,a5,0x10
80009f0a:	8341                	srl	a4,a4,0x10
80009f0c:	10e19f23          	sh	a4,286(gp) # 108091e <sock_is_sending>
	sock_remained_size[sn] = 0;
80009f10:	00f14783          	lbu	a5,15(sp)
80009f14:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
80009f18:	0786                	sll	a5,a5,0x1
80009f1a:	97ba                	add	a5,a5,a4
80009f1c:	00079023          	sh	zero,0(a5)
	sock_pack_info[sn] = 0;
80009f20:	00f14783          	lbu	a5,15(sp)
80009f24:	11018713          	add	a4,gp,272 # 1080910 <sock_pack_info>
80009f28:	97ba                	add	a5,a5,a4
80009f2a:	00078023          	sb	zero,0(a5)
	while(getSn_SR(sn) != SOCK_CLOSED);
80009f2e:	0001                	nop

80009f30 <.L28>:
80009f30:	00f14783          	lbu	a5,15(sp)
80009f34:	078a                	sll	a5,a5,0x2
80009f36:	0785                	add	a5,a5,1
80009f38:	078e                	sll	a5,a5,0x3
80009f3a:	30078793          	add	a5,a5,768
80009f3e:	853e                	mv	a0,a5
80009f40:	fa7fa0ef          	jal	80004ee6 <WIZCHIP_READ>
80009f44:	87aa                	mv	a5,a0
80009f46:	f7ed                	bnez	a5,80009f30 <.L28>
	return SOCK_OK;
80009f48:	4785                	li	a5,1

80009f4a <.L26>:
}
80009f4a:	853e                	mv	a0,a5
80009f4c:	40f2                	lw	ra,28(sp)
80009f4e:	6105                	add	sp,sp,32
80009f50:	8082                	ret

Disassembly of section .text.connect:

80009f52 <connect>:
{
80009f52:	7179                	add	sp,sp,-48
80009f54:	d606                	sw	ra,44(sp)
80009f56:	87aa                	mv	a5,a0
80009f58:	c42e                	sw	a1,8(sp)
80009f5a:	8732                	mv	a4,a2
80009f5c:	00f107a3          	sb	a5,15(sp)
80009f60:	87ba                	mv	a5,a4
80009f62:	00f11623          	sh	a5,12(sp)
   CHECK_SOCKNUM();
80009f66:	00f14703          	lbu	a4,15(sp)
80009f6a:	47a1                	li	a5,8
80009f6c:	00e7f463          	bgeu	a5,a4,80009f74 <.L39>
80009f70:	57fd                	li	a5,-1
80009f72:	aa4d                	j	8000a124 <.L40>

80009f74 <.L39>:
   CHECK_SOCKMODE(Sn_MR_TCP);
80009f74:	00f14783          	lbu	a5,15(sp)
80009f78:	078a                	sll	a5,a5,0x2
80009f7a:	0785                	add	a5,a5,1
80009f7c:	078e                	sll	a5,a5,0x3
80009f7e:	853e                	mv	a0,a5
80009f80:	f67fa0ef          	jal	80004ee6 <WIZCHIP_READ>
80009f84:	87aa                	mv	a5,a0
80009f86:	00f7f713          	and	a4,a5,15
80009f8a:	4785                	li	a5,1
80009f8c:	00f70463          	beq	a4,a5,80009f94 <.L41>
80009f90:	57ed                	li	a5,-5
80009f92:	aa49                	j	8000a124 <.L40>

80009f94 <.L41>:
   CHECK_SOCKINIT();
80009f94:	00f14783          	lbu	a5,15(sp)
80009f98:	078a                	sll	a5,a5,0x2
80009f9a:	0785                	add	a5,a5,1
80009f9c:	078e                	sll	a5,a5,0x3
80009f9e:	30078793          	add	a5,a5,768
80009fa2:	853e                	mv	a0,a5
80009fa4:	f43fa0ef          	jal	80004ee6 <WIZCHIP_READ>
80009fa8:	87aa                	mv	a5,a0
80009faa:	873e                	mv	a4,a5
80009fac:	47cd                	li	a5,19
80009fae:	00f70463          	beq	a4,a5,80009fb6 <.L42>
80009fb2:	57f5                	li	a5,-3
80009fb4:	aa85                	j	8000a124 <.L40>

80009fb6 <.L42>:
      taddr = ((uint32_t)addr[0] & 0x000000FF);
80009fb6:	47a2                	lw	a5,8(sp)
80009fb8:	0007c783          	lbu	a5,0(a5)
80009fbc:	ce3e                	sw	a5,28(sp)
      taddr = (taddr << 8) + ((uint32_t)addr[1] & 0x000000FF);
80009fbe:	47f2                	lw	a5,28(sp)
80009fc0:	07a2                	sll	a5,a5,0x8
80009fc2:	4722                	lw	a4,8(sp)
80009fc4:	0705                	add	a4,a4,1 # ffffc001 <__APB_SRAM_segment_end__+0xbf0a001>
80009fc6:	00074703          	lbu	a4,0(a4)
80009fca:	97ba                	add	a5,a5,a4
80009fcc:	ce3e                	sw	a5,28(sp)
      taddr = (taddr << 8) + ((uint32_t)addr[2] & 0x000000FF);
80009fce:	47f2                	lw	a5,28(sp)
80009fd0:	07a2                	sll	a5,a5,0x8
80009fd2:	4722                	lw	a4,8(sp)
80009fd4:	0709                	add	a4,a4,2
80009fd6:	00074703          	lbu	a4,0(a4)
80009fda:	97ba                	add	a5,a5,a4
80009fdc:	ce3e                	sw	a5,28(sp)
      taddr = (taddr << 8) + ((uint32_t)addr[3] & 0x000000FF);
80009fde:	47f2                	lw	a5,28(sp)
80009fe0:	07a2                	sll	a5,a5,0x8
80009fe2:	4722                	lw	a4,8(sp)
80009fe4:	070d                	add	a4,a4,3
80009fe6:	00074703          	lbu	a4,0(a4)
80009fea:	97ba                	add	a5,a5,a4
80009fec:	ce3e                	sw	a5,28(sp)
      if( taddr == 0xFFFFFFFF || taddr == 0) return SOCKERR_IPINVALID;
80009fee:	4772                	lw	a4,28(sp)
80009ff0:	57fd                	li	a5,-1
80009ff2:	00f70463          	beq	a4,a5,80009ffa <.L43>
80009ff6:	47f2                	lw	a5,28(sp)
80009ff8:	e399                	bnez	a5,80009ffe <.L44>

80009ffa <.L43>:
80009ffa:	57d1                	li	a5,-12
80009ffc:	a225                	j	8000a124 <.L40>

80009ffe <.L44>:
	if(port == 0) return SOCKERR_PORTZERO;
80009ffe:	00c15783          	lhu	a5,12(sp)
8000a002:	e399                	bnez	a5,8000a008 <.L45>
8000a004:	57d5                	li	a5,-11
8000a006:	aa39                	j	8000a124 <.L40>

8000a008 <.L45>:
	setSn_DIPR(sn,addr);
8000a008:	00f14783          	lbu	a5,15(sp)
8000a00c:	078a                	sll	a5,a5,0x2
8000a00e:	0785                	add	a5,a5,1
8000a010:	00379713          	sll	a4,a5,0x3
8000a014:	6785                	lui	a5,0x1
8000a016:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000a01a:	97ba                	add	a5,a5,a4
8000a01c:	4611                	li	a2,4
8000a01e:	45a2                	lw	a1,8(sp)
8000a020:	853e                	mv	a0,a5
8000a022:	f6ffa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
	setSn_DPORT(sn,port);
8000a026:	00f14783          	lbu	a5,15(sp)
8000a02a:	078a                	sll	a5,a5,0x2
8000a02c:	0785                	add	a5,a5,1
8000a02e:	00379713          	sll	a4,a5,0x3
8000a032:	6785                	lui	a5,0x1
8000a034:	97ba                	add	a5,a5,a4
8000a036:	873e                	mv	a4,a5
8000a038:	00c15783          	lhu	a5,12(sp)
8000a03c:	83a1                	srl	a5,a5,0x8
8000a03e:	07c2                	sll	a5,a5,0x10
8000a040:	83c1                	srl	a5,a5,0x10
8000a042:	0ff7f793          	zext.b	a5,a5
8000a046:	85be                	mv	a1,a5
8000a048:	853a                	mv	a0,a4
8000a04a:	38a1                	jal	800098a2 <WIZCHIP_WRITE>
8000a04c:	00f14783          	lbu	a5,15(sp)
8000a050:	078a                	sll	a5,a5,0x2
8000a052:	0785                	add	a5,a5,1 # 1001 <__fw_size__+0x1>
8000a054:	00379713          	sll	a4,a5,0x3
8000a058:	6785                	lui	a5,0x1
8000a05a:	10078793          	add	a5,a5,256 # 1100 <__fw_size__+0x100>
8000a05e:	97ba                	add	a5,a5,a4
8000a060:	873e                	mv	a4,a5
8000a062:	00c15783          	lhu	a5,12(sp)
8000a066:	0ff7f793          	zext.b	a5,a5
8000a06a:	85be                	mv	a1,a5
8000a06c:	853a                	mv	a0,a4
8000a06e:	3815                	jal	800098a2 <WIZCHIP_WRITE>
	setSn_CR(sn,Sn_CR_CONNECT);
8000a070:	00f14783          	lbu	a5,15(sp)
8000a074:	078a                	sll	a5,a5,0x2
8000a076:	0785                	add	a5,a5,1
8000a078:	078e                	sll	a5,a5,0x3
8000a07a:	10078793          	add	a5,a5,256
8000a07e:	4591                	li	a1,4
8000a080:	853e                	mv	a0,a5
8000a082:	3005                	jal	800098a2 <WIZCHIP_WRITE>
   while(getSn_CR(sn));
8000a084:	0001                	nop

8000a086 <.L46>:
8000a086:	00f14783          	lbu	a5,15(sp)
8000a08a:	078a                	sll	a5,a5,0x2
8000a08c:	0785                	add	a5,a5,1
8000a08e:	078e                	sll	a5,a5,0x3
8000a090:	10078793          	add	a5,a5,256
8000a094:	853e                	mv	a0,a5
8000a096:	e51fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a09a:	87aa                	mv	a5,a0
8000a09c:	f7ed                	bnez	a5,8000a086 <.L46>
   if(sock_io_mode & (1<<sn)) return SOCK_BUSY;
8000a09e:	1601d783          	lhu	a5,352(gp) # 1080960 <sock_io_mode>
8000a0a2:	873e                	mv	a4,a5
8000a0a4:	00f14783          	lbu	a5,15(sp)
8000a0a8:	40f757b3          	sra	a5,a4,a5
8000a0ac:	8b85                	and	a5,a5,1
8000a0ae:	cbb9                	beqz	a5,8000a104 <.L48>
8000a0b0:	4781                	li	a5,0
8000a0b2:	a88d                	j	8000a124 <.L40>

8000a0b4 <.L50>:
		if (getSn_IR(sn) & Sn_IR_TIMEOUT)
8000a0b4:	00f14783          	lbu	a5,15(sp)
8000a0b8:	078a                	sll	a5,a5,0x2
8000a0ba:	0785                	add	a5,a5,1
8000a0bc:	078e                	sll	a5,a5,0x3
8000a0be:	20078793          	add	a5,a5,512
8000a0c2:	853e                	mv	a0,a5
8000a0c4:	e23fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a0c8:	87aa                	mv	a5,a0
8000a0ca:	8ba1                	and	a5,a5,8
8000a0cc:	cf91                	beqz	a5,8000a0e8 <.L49>
			setSn_IR(sn, Sn_IR_TIMEOUT);
8000a0ce:	00f14783          	lbu	a5,15(sp)
8000a0d2:	078a                	sll	a5,a5,0x2
8000a0d4:	0785                	add	a5,a5,1
8000a0d6:	078e                	sll	a5,a5,0x3
8000a0d8:	20078793          	add	a5,a5,512
8000a0dc:	45a1                	li	a1,8
8000a0de:	853e                	mv	a0,a5
8000a0e0:	fc2ff0ef          	jal	800098a2 <WIZCHIP_WRITE>
            return SOCKERR_TIMEOUT;
8000a0e4:	57cd                	li	a5,-13
8000a0e6:	a83d                	j	8000a124 <.L40>

8000a0e8 <.L49>:
		if (getSn_SR(sn) == SOCK_CLOSED)
8000a0e8:	00f14783          	lbu	a5,15(sp)
8000a0ec:	078a                	sll	a5,a5,0x2
8000a0ee:	0785                	add	a5,a5,1
8000a0f0:	078e                	sll	a5,a5,0x3
8000a0f2:	30078793          	add	a5,a5,768
8000a0f6:	853e                	mv	a0,a5
8000a0f8:	deffa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a0fc:	87aa                	mv	a5,a0
8000a0fe:	e399                	bnez	a5,8000a104 <.L48>
			return SOCKERR_SOCKCLOSED;
8000a100:	57f1                	li	a5,-4
8000a102:	a00d                	j	8000a124 <.L40>

8000a104 <.L48>:
   while(getSn_SR(sn) != SOCK_ESTABLISHED)
8000a104:	00f14783          	lbu	a5,15(sp)
8000a108:	078a                	sll	a5,a5,0x2
8000a10a:	0785                	add	a5,a5,1
8000a10c:	078e                	sll	a5,a5,0x3
8000a10e:	30078793          	add	a5,a5,768
8000a112:	853e                	mv	a0,a5
8000a114:	dd3fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a118:	87aa                	mv	a5,a0
8000a11a:	873e                	mv	a4,a5
8000a11c:	47dd                	li	a5,23
8000a11e:	f8f71be3          	bne	a4,a5,8000a0b4 <.L50>
   return SOCK_OK;
8000a122:	4785                	li	a5,1

8000a124 <.L40>:
}
8000a124:	853e                	mv	a0,a5
8000a126:	50b2                	lw	ra,44(sp)
8000a128:	6145                	add	sp,sp,48
8000a12a:	8082                	ret

Disassembly of section .text.disconnect:

8000a12c <disconnect>:
{
8000a12c:	1101                	add	sp,sp,-32
8000a12e:	ce06                	sw	ra,28(sp)
8000a130:	87aa                	mv	a5,a0
8000a132:	00f107a3          	sb	a5,15(sp)
   CHECK_SOCKNUM();
8000a136:	00f14703          	lbu	a4,15(sp)
8000a13a:	47a1                	li	a5,8
8000a13c:	00e7f463          	bgeu	a5,a4,8000a144 <.L52>
8000a140:	57fd                	li	a5,-1
8000a142:	a8e1                	j	8000a21a <.L53>

8000a144 <.L52>:
   CHECK_SOCKMODE(Sn_MR_TCP);
8000a144:	00f14783          	lbu	a5,15(sp)
8000a148:	078a                	sll	a5,a5,0x2
8000a14a:	0785                	add	a5,a5,1
8000a14c:	078e                	sll	a5,a5,0x3
8000a14e:	853e                	mv	a0,a5
8000a150:	d97fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a154:	87aa                	mv	a5,a0
8000a156:	00f7f713          	and	a4,a5,15
8000a15a:	4785                	li	a5,1
8000a15c:	00f70463          	beq	a4,a5,8000a164 <.L54>
8000a160:	57ed                	li	a5,-5
8000a162:	a865                	j	8000a21a <.L53>

8000a164 <.L54>:
	setSn_CR(sn,Sn_CR_DISCON);
8000a164:	00f14783          	lbu	a5,15(sp)
8000a168:	078a                	sll	a5,a5,0x2
8000a16a:	0785                	add	a5,a5,1
8000a16c:	078e                	sll	a5,a5,0x3
8000a16e:	10078793          	add	a5,a5,256
8000a172:	45a1                	li	a1,8
8000a174:	853e                	mv	a0,a5
8000a176:	f2cff0ef          	jal	800098a2 <WIZCHIP_WRITE>
	while(getSn_CR(sn));
8000a17a:	0001                	nop

8000a17c <.L55>:
8000a17c:	00f14783          	lbu	a5,15(sp)
8000a180:	078a                	sll	a5,a5,0x2
8000a182:	0785                	add	a5,a5,1
8000a184:	078e                	sll	a5,a5,0x3
8000a186:	10078793          	add	a5,a5,256
8000a18a:	853e                	mv	a0,a5
8000a18c:	d5bfa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a190:	87aa                	mv	a5,a0
8000a192:	f7ed                	bnez	a5,8000a17c <.L55>
	sock_is_sending &= ~(1<<sn);
8000a194:	00f14783          	lbu	a5,15(sp)
8000a198:	4705                	li	a4,1
8000a19a:	00f717b3          	sll	a5,a4,a5
8000a19e:	07c2                	sll	a5,a5,0x10
8000a1a0:	87c1                	sra	a5,a5,0x10
8000a1a2:	fff7c793          	not	a5,a5
8000a1a6:	01079713          	sll	a4,a5,0x10
8000a1aa:	8741                	sra	a4,a4,0x10
8000a1ac:	11e1d783          	lhu	a5,286(gp) # 108091e <sock_is_sending>
8000a1b0:	07c2                	sll	a5,a5,0x10
8000a1b2:	87c1                	sra	a5,a5,0x10
8000a1b4:	8ff9                	and	a5,a5,a4
8000a1b6:	07c2                	sll	a5,a5,0x10
8000a1b8:	87c1                	sra	a5,a5,0x10
8000a1ba:	01079713          	sll	a4,a5,0x10
8000a1be:	8341                	srl	a4,a4,0x10
8000a1c0:	10e19f23          	sh	a4,286(gp) # 108091e <sock_is_sending>
   if(sock_io_mode & (1<<sn)) return SOCK_BUSY;
8000a1c4:	1601d783          	lhu	a5,352(gp) # 1080960 <sock_io_mode>
8000a1c8:	873e                	mv	a4,a5
8000a1ca:	00f14783          	lbu	a5,15(sp)
8000a1ce:	40f757b3          	sra	a5,a4,a5
8000a1d2:	8b85                	and	a5,a5,1
8000a1d4:	c795                	beqz	a5,8000a200 <.L57>
8000a1d6:	4781                	li	a5,0
8000a1d8:	a089                	j	8000a21a <.L53>

8000a1da <.L58>:
	   if(getSn_IR(sn) & Sn_IR_TIMEOUT)
8000a1da:	00f14783          	lbu	a5,15(sp)
8000a1de:	078a                	sll	a5,a5,0x2
8000a1e0:	0785                	add	a5,a5,1
8000a1e2:	078e                	sll	a5,a5,0x3
8000a1e4:	20078793          	add	a5,a5,512
8000a1e8:	853e                	mv	a0,a5
8000a1ea:	cfdfa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a1ee:	87aa                	mv	a5,a0
8000a1f0:	8ba1                	and	a5,a5,8
8000a1f2:	c799                	beqz	a5,8000a200 <.L57>
	      close(sn);
8000a1f4:	00f14783          	lbu	a5,15(sp)
8000a1f8:	853e                	mv	a0,a5
8000a1fa:	39b1                	jal	80009e56 <close>
	      return SOCKERR_TIMEOUT;
8000a1fc:	57cd                	li	a5,-13
8000a1fe:	a831                	j	8000a21a <.L53>

8000a200 <.L57>:
	while(getSn_SR(sn) != SOCK_CLOSED)
8000a200:	00f14783          	lbu	a5,15(sp)
8000a204:	078a                	sll	a5,a5,0x2
8000a206:	0785                	add	a5,a5,1
8000a208:	078e                	sll	a5,a5,0x3
8000a20a:	30078793          	add	a5,a5,768
8000a20e:	853e                	mv	a0,a5
8000a210:	cd7fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a214:	87aa                	mv	a5,a0
8000a216:	f3f1                	bnez	a5,8000a1da <.L58>
	return SOCK_OK;
8000a218:	4785                	li	a5,1

8000a21a <.L53>:
}
8000a21a:	853e                	mv	a0,a5
8000a21c:	40f2                	lw	ra,28(sp)
8000a21e:	6105                	add	sp,sp,32
8000a220:	8082                	ret

Disassembly of section .text.sendto:

8000a222 <sendto>:
   //return len;
   return (int32_t)len;
}

int32_t sendto(uint8_t sn, uint8_t * buf, uint16_t len, uint8_t * addr, uint16_t port)
{
8000a222:	7179                	add	sp,sp,-48
8000a224:	d606                	sw	ra,44(sp)
8000a226:	87aa                	mv	a5,a0
8000a228:	c42e                	sw	a1,8(sp)
8000a22a:	c236                	sw	a3,4(sp)
8000a22c:	00f107a3          	sb	a5,15(sp)
8000a230:	87b2                	mv	a5,a2
8000a232:	00f11623          	sh	a5,12(sp)
8000a236:	87ba                	mv	a5,a4
8000a238:	00f11123          	sh	a5,2(sp)
   uint8_t tmp = 0;
8000a23c:	00010fa3          	sb	zero,31(sp)
   uint16_t freesize = 0;
8000a240:	00011e23          	sh	zero,28(sp)
   uint32_t taddr;

   CHECK_SOCKNUM();
8000a244:	00f14703          	lbu	a4,15(sp)
8000a248:	47a1                	li	a5,8
8000a24a:	00e7f463          	bgeu	a5,a4,8000a252 <.L95>
8000a24e:	57fd                	li	a5,-1
8000a250:	ac69                	j	8000a4ea <.L96>

8000a252 <.L95>:
   switch(getSn_MR(sn) & 0x0F)
8000a252:	00f14783          	lbu	a5,15(sp)
8000a256:	078a                	sll	a5,a5,0x2
8000a258:	0785                	add	a5,a5,1
8000a25a:	078e                	sll	a5,a5,0x3
8000a25c:	853e                	mv	a0,a5
8000a25e:	c89fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a262:	87aa                	mv	a5,a0
8000a264:	8bbd                	and	a5,a5,15
8000a266:	ffe78713          	add	a4,a5,-2
8000a26a:	4789                	li	a5,2
8000a26c:	00e7f463          	bgeu	a5,a4,8000a274 <.L116>
//   #if ( _WIZCHIP_ < 5200 )
      case Sn_MR_IPRAW:
         break;
//   #endif
      default:
         return SOCKERR_SOCKMODE;
8000a270:	57ed                	li	a5,-5
8000a272:	aca5                	j	8000a4ea <.L96>

8000a274 <.L116>:
         break;
8000a274:	0001                	nop
   }
   CHECK_SOCKDATA();
8000a276:	00c15783          	lhu	a5,12(sp)
8000a27a:	e399                	bnez	a5,8000a280 <.L99>
8000a27c:	57c9                	li	a5,-14
8000a27e:	a4b5                	j	8000a4ea <.L96>

8000a280 <.L99>:
   //M20140501 : For avoiding fatal error on memory align mismatched
   //if(*((uint32_t*)addr) == 0) return SOCKERR_IPINVALID;
   //{
      //uint32_t taddr;
      taddr = ((uint32_t)addr[0]) & 0x000000FF;
8000a280:	4792                	lw	a5,4(sp)
8000a282:	0007c783          	lbu	a5,0(a5)
8000a286:	cc3e                	sw	a5,24(sp)
      taddr = (taddr << 8) + ((uint32_t)addr[1] & 0x000000FF);
8000a288:	47e2                	lw	a5,24(sp)
8000a28a:	07a2                	sll	a5,a5,0x8
8000a28c:	4712                	lw	a4,4(sp)
8000a28e:	0705                	add	a4,a4,1
8000a290:	00074703          	lbu	a4,0(a4)
8000a294:	97ba                	add	a5,a5,a4
8000a296:	cc3e                	sw	a5,24(sp)
      taddr = (taddr << 8) + ((uint32_t)addr[2] & 0x000000FF);
8000a298:	47e2                	lw	a5,24(sp)
8000a29a:	07a2                	sll	a5,a5,0x8
8000a29c:	4712                	lw	a4,4(sp)
8000a29e:	0709                	add	a4,a4,2
8000a2a0:	00074703          	lbu	a4,0(a4)
8000a2a4:	97ba                	add	a5,a5,a4
8000a2a6:	cc3e                	sw	a5,24(sp)
      taddr = (taddr << 8) + ((uint32_t)addr[3] & 0x000000FF);
8000a2a8:	47e2                	lw	a5,24(sp)
8000a2aa:	07a2                	sll	a5,a5,0x8
8000a2ac:	4712                	lw	a4,4(sp)
8000a2ae:	070d                	add	a4,a4,3
8000a2b0:	00074703          	lbu	a4,0(a4)
8000a2b4:	97ba                	add	a5,a5,a4
8000a2b6:	cc3e                	sw	a5,24(sp)
   //}
   //
   //if(*((uint32_t*)addr) == 0) return SOCKERR_IPINVALID;
   if((taddr == 0) && ((getSn_MR(sn)&Sn_MR_MACRAW) != Sn_MR_MACRAW)) return SOCKERR_IPINVALID;
8000a2b8:	47e2                	lw	a5,24(sp)
8000a2ba:	e38d                	bnez	a5,8000a2dc <.L100>
8000a2bc:	00f14783          	lbu	a5,15(sp)
8000a2c0:	078a                	sll	a5,a5,0x2
8000a2c2:	0785                	add	a5,a5,1
8000a2c4:	078e                	sll	a5,a5,0x3
8000a2c6:	853e                	mv	a0,a5
8000a2c8:	c1ffa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a2cc:	87aa                	mv	a5,a0
8000a2ce:	0047f713          	and	a4,a5,4
8000a2d2:	4791                	li	a5,4
8000a2d4:	00f70463          	beq	a4,a5,8000a2dc <.L100>
8000a2d8:	57d1                	li	a5,-12
8000a2da:	ac01                	j	8000a4ea <.L96>

8000a2dc <.L100>:
   if((port  == 0) && ((getSn_MR(sn)&Sn_MR_MACRAW) != Sn_MR_MACRAW)) return SOCKERR_PORTZERO;
8000a2dc:	00215783          	lhu	a5,2(sp)
8000a2e0:	e38d                	bnez	a5,8000a302 <.L101>
8000a2e2:	00f14783          	lbu	a5,15(sp)
8000a2e6:	078a                	sll	a5,a5,0x2
8000a2e8:	0785                	add	a5,a5,1
8000a2ea:	078e                	sll	a5,a5,0x3
8000a2ec:	853e                	mv	a0,a5
8000a2ee:	bf9fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a2f2:	87aa                	mv	a5,a0
8000a2f4:	0047f713          	and	a4,a5,4
8000a2f8:	4791                	li	a5,4
8000a2fa:	00f70463          	beq	a4,a5,8000a302 <.L101>
8000a2fe:	57d5                	li	a5,-11
8000a300:	a2ed                	j	8000a4ea <.L96>

8000a302 <.L101>:
   tmp = getSn_SR(sn);
8000a302:	00f14783          	lbu	a5,15(sp)
8000a306:	078a                	sll	a5,a5,0x2
8000a308:	0785                	add	a5,a5,1
8000a30a:	078e                	sll	a5,a5,0x3
8000a30c:	30078793          	add	a5,a5,768
8000a310:	853e                	mv	a0,a5
8000a312:	bd5fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a316:	87aa                	mv	a5,a0
8000a318:	00f10fa3          	sb	a5,31(sp)
//#if ( _WIZCHIP_ < 5200 )
   if((tmp != SOCK_MACRAW) && (tmp != SOCK_UDP) && (tmp != SOCK_IPRAW)) return SOCKERR_SOCKSTATUS;
8000a31c:	01f14703          	lbu	a4,31(sp)
8000a320:	04200793          	li	a5,66
8000a324:	02f70063          	beq	a4,a5,8000a344 <.L102>
8000a328:	01f14703          	lbu	a4,31(sp)
8000a32c:	02200793          	li	a5,34
8000a330:	00f70a63          	beq	a4,a5,8000a344 <.L102>
8000a334:	01f14703          	lbu	a4,31(sp)
8000a338:	03200793          	li	a5,50
8000a33c:	00f70463          	beq	a4,a5,8000a344 <.L102>
8000a340:	57e5                	li	a5,-7
8000a342:	a265                	j	8000a4ea <.L96>

8000a344 <.L102>:
//#else
//   if(tmp != SOCK_MACRAW && tmp != SOCK_UDP) return SOCKERR_SOCKSTATUS;
//#endif
      
   setSn_DIPR(sn,addr);
8000a344:	00f14783          	lbu	a5,15(sp)
8000a348:	078a                	sll	a5,a5,0x2
8000a34a:	0785                	add	a5,a5,1
8000a34c:	00379713          	sll	a4,a5,0x3
8000a350:	6785                	lui	a5,0x1
8000a352:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000a356:	97ba                	add	a5,a5,a4
8000a358:	4611                	li	a2,4
8000a35a:	4592                	lw	a1,4(sp)
8000a35c:	853e                	mv	a0,a5
8000a35e:	c33fa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setSn_DPORT(sn,port);      
8000a362:	00f14783          	lbu	a5,15(sp)
8000a366:	078a                	sll	a5,a5,0x2
8000a368:	0785                	add	a5,a5,1
8000a36a:	00379713          	sll	a4,a5,0x3
8000a36e:	6785                	lui	a5,0x1
8000a370:	97ba                	add	a5,a5,a4
8000a372:	873e                	mv	a4,a5
8000a374:	00215783          	lhu	a5,2(sp)
8000a378:	83a1                	srl	a5,a5,0x8
8000a37a:	07c2                	sll	a5,a5,0x10
8000a37c:	83c1                	srl	a5,a5,0x10
8000a37e:	0ff7f793          	zext.b	a5,a5
8000a382:	85be                	mv	a1,a5
8000a384:	853a                	mv	a0,a4
8000a386:	d1cff0ef          	jal	800098a2 <WIZCHIP_WRITE>
8000a38a:	00f14783          	lbu	a5,15(sp)
8000a38e:	078a                	sll	a5,a5,0x2
8000a390:	0785                	add	a5,a5,1 # 1001 <__fw_size__+0x1>
8000a392:	00379713          	sll	a4,a5,0x3
8000a396:	6785                	lui	a5,0x1
8000a398:	10078793          	add	a5,a5,256 # 1100 <__fw_size__+0x100>
8000a39c:	97ba                	add	a5,a5,a4
8000a39e:	873e                	mv	a4,a5
8000a3a0:	00215783          	lhu	a5,2(sp)
8000a3a4:	0ff7f793          	zext.b	a5,a5
8000a3a8:	85be                	mv	a1,a5
8000a3aa:	853a                	mv	a0,a4
8000a3ac:	cf6ff0ef          	jal	800098a2 <WIZCHIP_WRITE>
   freesize = getSn_TxMAX(sn);
8000a3b0:	00f14783          	lbu	a5,15(sp)
8000a3b4:	078a                	sll	a5,a5,0x2
8000a3b6:	0785                	add	a5,a5,1
8000a3b8:	00379713          	sll	a4,a5,0x3
8000a3bc:	6789                	lui	a5,0x2
8000a3be:	f0078793          	add	a5,a5,-256 # 1f00 <__fw_size__+0xf00>
8000a3c2:	97ba                	add	a5,a5,a4
8000a3c4:	853e                	mv	a0,a5
8000a3c6:	b21fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a3ca:	87aa                	mv	a5,a0
8000a3cc:	07aa                	sll	a5,a5,0xa
8000a3ce:	00f11e23          	sh	a5,28(sp)
   if (len > freesize) len = freesize; // check size not to exceed MAX size.
8000a3d2:	00c15703          	lhu	a4,12(sp)
8000a3d6:	01c15783          	lhu	a5,28(sp)
8000a3da:	00e7f663          	bgeu	a5,a4,8000a3e6 <.L108>
8000a3de:	01c15783          	lhu	a5,28(sp)
8000a3e2:	00f11623          	sh	a5,12(sp)

8000a3e6 <.L108>:
   while(1)
   {
      freesize = getSn_TX_FSR(sn);
8000a3e6:	00f14783          	lbu	a5,15(sp)
8000a3ea:	853e                	mv	a0,a5
8000a3ec:	e6aff0ef          	jal	80009a56 <getSn_TX_FSR>
8000a3f0:	87aa                	mv	a5,a0
8000a3f2:	00f11e23          	sh	a5,28(sp)
      if(getSn_SR(sn) == SOCK_CLOSED) return SOCKERR_SOCKCLOSED;
8000a3f6:	00f14783          	lbu	a5,15(sp)
8000a3fa:	078a                	sll	a5,a5,0x2
8000a3fc:	0785                	add	a5,a5,1
8000a3fe:	078e                	sll	a5,a5,0x3
8000a400:	30078793          	add	a5,a5,768
8000a404:	853e                	mv	a0,a5
8000a406:	ae1fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a40a:	87aa                	mv	a5,a0
8000a40c:	e399                	bnez	a5,8000a412 <.L104>
8000a40e:	57f1                	li	a5,-4
8000a410:	a8e9                	j	8000a4ea <.L96>

8000a412 <.L104>:
      if( (sock_io_mode & (1<<sn)) && (len > freesize) ) return SOCK_BUSY;
8000a412:	1601d783          	lhu	a5,352(gp) # 1080960 <sock_io_mode>
8000a416:	873e                	mv	a4,a5
8000a418:	00f14783          	lbu	a5,15(sp)
8000a41c:	40f757b3          	sra	a5,a4,a5
8000a420:	8b85                	and	a5,a5,1
8000a422:	cb89                	beqz	a5,8000a434 <.L105>
8000a424:	00c15703          	lhu	a4,12(sp)
8000a428:	01c15783          	lhu	a5,28(sp)
8000a42c:	00e7f463          	bgeu	a5,a4,8000a434 <.L105>
8000a430:	4781                	li	a5,0
8000a432:	a865                	j	8000a4ea <.L96>

8000a434 <.L105>:
      if(len <= freesize) break;
8000a434:	00c15703          	lhu	a4,12(sp)
8000a438:	01c15783          	lhu	a5,28(sp)
8000a43c:	00e7f363          	bgeu	a5,a4,8000a442 <.L117>
      freesize = getSn_TX_FSR(sn);
8000a440:	b75d                	j	8000a3e6 <.L108>

8000a442 <.L117>:
      if(len <= freesize) break;
8000a442:	0001                	nop
   };
	wiz_send_data(sn, buf, len);
8000a444:	00c15703          	lhu	a4,12(sp)
8000a448:	00f14783          	lbu	a5,15(sp)
8000a44c:	863a                	mv	a2,a4
8000a44e:	45a2                	lw	a1,8(sp)
8000a450:	853e                	mv	a0,a5
8000a452:	c2dfa0ef          	jal	8000507e <wiz_send_data>
//A20150601 : For W5300
#if _WIZCHIP_ == 5300
   setSn_TX_WRSR(sn, len);
#endif
//   
	setSn_CR(sn,Sn_CR_SEND);
8000a456:	00f14783          	lbu	a5,15(sp)
8000a45a:	078a                	sll	a5,a5,0x2
8000a45c:	0785                	add	a5,a5,1
8000a45e:	078e                	sll	a5,a5,0x3
8000a460:	10078793          	add	a5,a5,256
8000a464:	02000593          	li	a1,32
8000a468:	853e                	mv	a0,a5
8000a46a:	c38ff0ef          	jal	800098a2 <WIZCHIP_WRITE>
	/* wait to process the command... */
	while(getSn_CR(sn));
8000a46e:	0001                	nop

8000a470 <.L109>:
8000a470:	00f14783          	lbu	a5,15(sp)
8000a474:	078a                	sll	a5,a5,0x2
8000a476:	0785                	add	a5,a5,1
8000a478:	078e                	sll	a5,a5,0x3
8000a47a:	10078793          	add	a5,a5,256
8000a47e:	853e                	mv	a0,a5
8000a480:	a67fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a484:	87aa                	mv	a5,a0
8000a486:	f7ed                	bnez	a5,8000a470 <.L109>

8000a488 <.L113>:
   while(1)
   {
      tmp = getSn_IR(sn);
8000a488:	00f14783          	lbu	a5,15(sp)
8000a48c:	078a                	sll	a5,a5,0x2
8000a48e:	0785                	add	a5,a5,1
8000a490:	078e                	sll	a5,a5,0x3
8000a492:	20078793          	add	a5,a5,512
8000a496:	853e                	mv	a0,a5
8000a498:	a4ffa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a49c:	87aa                	mv	a5,a0
8000a49e:	8bfd                	and	a5,a5,31
8000a4a0:	00f10fa3          	sb	a5,31(sp)
      if(tmp & Sn_IR_SENDOK)
8000a4a4:	01f14783          	lbu	a5,31(sp)
8000a4a8:	8bc1                	and	a5,a5,16
8000a4aa:	c385                	beqz	a5,8000a4ca <.L110>
      {
         setSn_IR(sn, Sn_IR_SENDOK);
8000a4ac:	00f14783          	lbu	a5,15(sp)
8000a4b0:	078a                	sll	a5,a5,0x2
8000a4b2:	0785                	add	a5,a5,1
8000a4b4:	078e                	sll	a5,a5,0x3
8000a4b6:	20078793          	add	a5,a5,512
8000a4ba:	45c1                	li	a1,16
8000a4bc:	853e                	mv	a0,a5
8000a4be:	be4ff0ef          	jal	800098a2 <WIZCHIP_WRITE>
         break;
8000a4c2:	0001                	nop
   #if _WIZCHIP_ < 5500   //M20150401 : for WIZCHIP Errata #4, #5 (ARP errata)
      if(taddr) setSUBR((uint8_t*)&taddr);
   #endif
   //M20150409 : Explicit Type Casting
   //return len;
   return (int32_t)len;
8000a4c4:	00c15783          	lhu	a5,12(sp)
8000a4c8:	a00d                	j	8000a4ea <.L96>

8000a4ca <.L110>:
      else if(tmp & Sn_IR_TIMEOUT)
8000a4ca:	01f14783          	lbu	a5,31(sp)
8000a4ce:	8ba1                	and	a5,a5,8
8000a4d0:	dfc5                	beqz	a5,8000a488 <.L113>
         setSn_IR(sn, Sn_IR_TIMEOUT);
8000a4d2:	00f14783          	lbu	a5,15(sp)
8000a4d6:	078a                	sll	a5,a5,0x2
8000a4d8:	0785                	add	a5,a5,1
8000a4da:	078e                	sll	a5,a5,0x3
8000a4dc:	20078793          	add	a5,a5,512
8000a4e0:	45a1                	li	a1,8
8000a4e2:	853e                	mv	a0,a5
8000a4e4:	bbeff0ef          	jal	800098a2 <WIZCHIP_WRITE>
         return SOCKERR_TIMEOUT;
8000a4e8:	57cd                	li	a5,-13

8000a4ea <.L96>:
}
8000a4ea:	853e                	mv	a0,a5
8000a4ec:	50b2                	lw	ra,44(sp)
8000a4ee:	6145                	add	sp,sp,48
8000a4f0:	8082                	ret

Disassembly of section .text.recvfrom:

8000a4f2 <recvfrom>:



int32_t recvfrom(uint8_t sn, uint8_t * buf, uint16_t len, uint8_t * addr, uint16_t *port)
{
8000a4f2:	7179                	add	sp,sp,-48
8000a4f4:	d606                	sw	ra,44(sp)
8000a4f6:	87aa                	mv	a5,a0
8000a4f8:	c42e                	sw	a1,8(sp)
8000a4fa:	c236                	sw	a3,4(sp)
8000a4fc:	c03a                	sw	a4,0(sp)
8000a4fe:	00f107a3          	sb	a5,15(sp)
8000a502:	87b2                	mv	a5,a2
8000a504:	00f11623          	sh	a5,12(sp)
#else   
   uint8_t  mr;
#endif
//   
   uint8_t  head[8];
	uint16_t pack_len=0;
8000a508:	00011f23          	sh	zero,30(sp)

   CHECK_SOCKNUM();
8000a50c:	00f14703          	lbu	a4,15(sp)
8000a510:	47a1                	li	a5,8
8000a512:	00e7f463          	bgeu	a5,a4,8000a51a <.L119>
8000a516:	57fd                	li	a5,-1
8000a518:	ab0d                	j	8000aa4a <.L150>

8000a51a <.L119>:
//A20150601
#if _WIZCHIP_ == 5300
   mr1 = getMR();
#endif   

   switch((mr=getSn_MR(sn)) & 0x0F)
8000a51a:	00f14783          	lbu	a5,15(sp)
8000a51e:	078a                	sll	a5,a5,0x2
8000a520:	0785                	add	a5,a5,1
8000a522:	078e                	sll	a5,a5,0x3
8000a524:	853e                	mv	a0,a5
8000a526:	9c1fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a52a:	87aa                	mv	a5,a0
8000a52c:	00f10ea3          	sb	a5,29(sp)
8000a530:	01d14783          	lbu	a5,29(sp)
8000a534:	8bbd                	and	a5,a5,15
8000a536:	ffe78713          	add	a4,a5,-2
8000a53a:	4789                	li	a5,2
8000a53c:	00e7f463          	bgeu	a5,a4,8000a544 <.L152>
   #if ( _WIZCHIP_ < 5200 )         
      case Sn_MR_PPPoE:
         break;
   #endif
      default:
         return SOCKERR_SOCKMODE;
8000a540:	57ed                	li	a5,-5
8000a542:	a321                	j	8000aa4a <.L150>

8000a544 <.L152>:
         break;
8000a544:	0001                	nop
   }
   CHECK_SOCKDATA();
8000a546:	00c15783          	lhu	a5,12(sp)
8000a54a:	e399                	bnez	a5,8000a550 <.L123>
8000a54c:	57c9                	li	a5,-14
8000a54e:	a9f5                	j	8000aa4a <.L150>

8000a550 <.L123>:
   if(sock_remained_size[sn] == 0)
8000a550:	00f14783          	lbu	a5,15(sp)
8000a554:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a558:	0786                	sll	a5,a5,0x1
8000a55a:	97ba                	add	a5,a5,a4
8000a55c:	0007d783          	lhu	a5,0(a5)
8000a560:	ebb1                	bnez	a5,8000a5b4 <.L124>

8000a562 <.L128>:
   {
      while(1)
      {
         pack_len = getSn_RX_RSR(sn);
8000a562:	00f14783          	lbu	a5,15(sp)
8000a566:	853e                	mv	a0,a5
8000a568:	db6ff0ef          	jal	80009b1e <getSn_RX_RSR>
8000a56c:	87aa                	mv	a5,a0
8000a56e:	00f11f23          	sh	a5,30(sp)
         if(getSn_SR(sn) == SOCK_CLOSED) return SOCKERR_SOCKCLOSED;
8000a572:	00f14783          	lbu	a5,15(sp)
8000a576:	078a                	sll	a5,a5,0x2
8000a578:	0785                	add	a5,a5,1
8000a57a:	078e                	sll	a5,a5,0x3
8000a57c:	30078793          	add	a5,a5,768
8000a580:	853e                	mv	a0,a5
8000a582:	965fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a586:	87aa                	mv	a5,a0
8000a588:	e399                	bnez	a5,8000a58e <.L125>
8000a58a:	57f1                	li	a5,-4
8000a58c:	a97d                	j	8000aa4a <.L150>

8000a58e <.L125>:
         if( (sock_io_mode & (1<<sn)) && (pack_len == 0) ) return SOCK_BUSY;
8000a58e:	1601d783          	lhu	a5,352(gp) # 1080960 <sock_io_mode>
8000a592:	873e                	mv	a4,a5
8000a594:	00f14783          	lbu	a5,15(sp)
8000a598:	40f757b3          	sra	a5,a4,a5
8000a59c:	8b85                	and	a5,a5,1
8000a59e:	c791                	beqz	a5,8000a5aa <.L126>
8000a5a0:	01e15783          	lhu	a5,30(sp)
8000a5a4:	e399                	bnez	a5,8000a5aa <.L126>
8000a5a6:	4781                	li	a5,0
8000a5a8:	a14d                	j	8000aa4a <.L150>

8000a5aa <.L126>:
         if(pack_len != 0) break;
8000a5aa:	01e15783          	lhu	a5,30(sp)
8000a5ae:	e391                	bnez	a5,8000a5b2 <.L153>
         pack_len = getSn_RX_RSR(sn);
8000a5b0:	bf4d                	j	8000a562 <.L128>

8000a5b2 <.L153>:
         if(pack_len != 0) break;
8000a5b2:	0001                	nop

8000a5b4 <.L124>:
      };
   }
//D20150601 : Move it to bottom
// sock_pack_info[sn] = PACK_COMPLETED;
	switch (mr & 0x07)
8000a5b4:	01d14783          	lbu	a5,29(sp)
8000a5b8:	8b9d                	and	a5,a5,7
8000a5ba:	4711                	li	a4,4
8000a5bc:	16e78a63          	beq	a5,a4,8000a730 <.L129>
8000a5c0:	4711                	li	a4,4
8000a5c2:	3af74e63          	blt	a4,a5,8000a97e <.L130>
8000a5c6:	4709                	li	a4,2
8000a5c8:	00e78663          	beq	a5,a4,8000a5d4 <.L131>
8000a5cc:	470d                	li	a4,3
8000a5ce:	28e78463          	beq	a5,a4,8000a856 <.L132>
8000a5d2:	a675                	j	8000a97e <.L130>

8000a5d4 <.L131>:
	{
	   case Sn_MR_UDP :
	      if(sock_remained_size[sn] == 0)
8000a5d4:	00f14783          	lbu	a5,15(sp)
8000a5d8:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a5dc:	0786                	sll	a5,a5,0x1
8000a5de:	97ba                	add	a5,a5,a4
8000a5e0:	0007d783          	lhu	a5,0(a5)
8000a5e4:	0e079d63          	bnez	a5,8000a6de <.L133>
	      {
   			wiz_recv_data(sn, head, 8);
8000a5e8:	0858                	add	a4,sp,20
8000a5ea:	00f14783          	lbu	a5,15(sp)
8000a5ee:	4621                	li	a2,8
8000a5f0:	85ba                	mv	a1,a4
8000a5f2:	853e                	mv	a0,a5
8000a5f4:	b7ffa0ef          	jal	80005172 <wiz_recv_data>
   			setSn_CR(sn,Sn_CR_RECV);
8000a5f8:	00f14783          	lbu	a5,15(sp)
8000a5fc:	078a                	sll	a5,a5,0x2
8000a5fe:	0785                	add	a5,a5,1
8000a600:	078e                	sll	a5,a5,0x3
8000a602:	10078793          	add	a5,a5,256
8000a606:	04000593          	li	a1,64
8000a60a:	853e                	mv	a0,a5
8000a60c:	a96ff0ef          	jal	800098a2 <WIZCHIP_WRITE>
   			while(getSn_CR(sn));
8000a610:	0001                	nop

8000a612 <.L134>:
8000a612:	00f14783          	lbu	a5,15(sp)
8000a616:	078a                	sll	a5,a5,0x2
8000a618:	0785                	add	a5,a5,1
8000a61a:	078e                	sll	a5,a5,0x3
8000a61c:	10078793          	add	a5,a5,256
8000a620:	853e                	mv	a0,a5
8000a622:	8c5fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a626:	87aa                	mv	a5,a0
8000a628:	f7ed                	bnez	a5,8000a612 <.L134>
      			sock_remained_size[sn] = (sock_remained_size[sn] << 8) + head[6];
   		   }
            else
            {
         #endif
               addr[0] = head[0];
8000a62a:	01414703          	lbu	a4,20(sp)
8000a62e:	4792                	lw	a5,4(sp)
8000a630:	00e78023          	sb	a4,0(a5)
      			addr[1] = head[1];
8000a634:	4792                	lw	a5,4(sp)
8000a636:	0785                	add	a5,a5,1
8000a638:	01514703          	lbu	a4,21(sp)
8000a63c:	00e78023          	sb	a4,0(a5)
      			addr[2] = head[2];
8000a640:	4792                	lw	a5,4(sp)
8000a642:	0789                	add	a5,a5,2
8000a644:	01614703          	lbu	a4,22(sp)
8000a648:	00e78023          	sb	a4,0(a5)
      			addr[3] = head[3];
8000a64c:	4792                	lw	a5,4(sp)
8000a64e:	078d                	add	a5,a5,3
8000a650:	01714703          	lbu	a4,23(sp)
8000a654:	00e78023          	sb	a4,0(a5)
      			*port = head[4];
8000a658:	01814783          	lbu	a5,24(sp)
8000a65c:	873e                	mv	a4,a5
8000a65e:	4782                	lw	a5,0(sp)
8000a660:	00e79023          	sh	a4,0(a5)
      			*port = (*port << 8) + head[5];
8000a664:	4782                	lw	a5,0(sp)
8000a666:	0007d783          	lhu	a5,0(a5)
8000a66a:	07a2                	sll	a5,a5,0x8
8000a66c:	07c2                	sll	a5,a5,0x10
8000a66e:	83c1                	srl	a5,a5,0x10
8000a670:	01914703          	lbu	a4,25(sp)
8000a674:	97ba                	add	a5,a5,a4
8000a676:	01079713          	sll	a4,a5,0x10
8000a67a:	8341                	srl	a4,a4,0x10
8000a67c:	4782                	lw	a5,0(sp)
8000a67e:	00e79023          	sh	a4,0(a5)
      			sock_remained_size[sn] = head[6];
8000a682:	01a14703          	lbu	a4,26(sp)
8000a686:	00f14783          	lbu	a5,15(sp)
8000a68a:	86ba                	mv	a3,a4
8000a68c:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a690:	0786                	sll	a5,a5,0x1
8000a692:	97ba                	add	a5,a5,a4
8000a694:	00d79023          	sh	a3,0(a5)
      			sock_remained_size[sn] = (sock_remained_size[sn] << 8) + head[7];
8000a698:	00f14783          	lbu	a5,15(sp)
8000a69c:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a6a0:	0786                	sll	a5,a5,0x1
8000a6a2:	97ba                	add	a5,a5,a4
8000a6a4:	0007d783          	lhu	a5,0(a5)
8000a6a8:	07a2                	sll	a5,a5,0x8
8000a6aa:	01079713          	sll	a4,a5,0x10
8000a6ae:	8341                	srl	a4,a4,0x10
8000a6b0:	01b14783          	lbu	a5,27(sp)
8000a6b4:	86be                	mv	a3,a5
8000a6b6:	00f14783          	lbu	a5,15(sp)
8000a6ba:	9736                	add	a4,a4,a3
8000a6bc:	0742                	sll	a4,a4,0x10
8000a6be:	8341                	srl	a4,a4,0x10
8000a6c0:	10018693          	add	a3,gp,256 # 1080900 <sock_remained_size>
8000a6c4:	0786                	sll	a5,a5,0x1
8000a6c6:	97b6                	add	a5,a5,a3
8000a6c8:	00e79023          	sh	a4,0(a5)
         #if _WIZCHIP_ == 5300
            }
         #endif
   			sock_pack_info[sn] = PACK_FIRST;
8000a6cc:	00f14783          	lbu	a5,15(sp)
8000a6d0:	11018713          	add	a4,gp,272 # 1080910 <sock_pack_info>
8000a6d4:	97ba                	add	a5,a5,a4
8000a6d6:	f8000713          	li	a4,-128
8000a6da:	00e78023          	sb	a4,0(a5)

8000a6de <.L133>:
   	   }
			if(len < sock_remained_size[sn]) pack_len = len;
8000a6de:	00f14783          	lbu	a5,15(sp)
8000a6e2:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a6e6:	0786                	sll	a5,a5,0x1
8000a6e8:	97ba                	add	a5,a5,a4
8000a6ea:	0007d783          	lhu	a5,0(a5)
8000a6ee:	00c15703          	lhu	a4,12(sp)
8000a6f2:	00f77763          	bgeu	a4,a5,8000a700 <.L135>
8000a6f6:	00c15783          	lhu	a5,12(sp)
8000a6fa:	00f11f23          	sh	a5,30(sp)
8000a6fe:	a819                	j	8000a714 <.L136>

8000a700 <.L135>:
			else pack_len = sock_remained_size[sn];
8000a700:	00f14783          	lbu	a5,15(sp)
8000a704:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a708:	0786                	sll	a5,a5,0x1
8000a70a:	97ba                	add	a5,a5,a4
8000a70c:	0007d783          	lhu	a5,0(a5)
8000a710:	00f11f23          	sh	a5,30(sp)

8000a714 <.L136>:
			//A20150601 : For W5300
			len = pack_len;
8000a714:	01e15783          	lhu	a5,30(sp)
8000a718:	00f11623          	sh	a5,12(sp)
			   }
			#endif
			//
			// Need to packet length check (default 1472)
			//
   		wiz_recv_data(sn, buf, pack_len); // data copy.
8000a71c:	01e15703          	lhu	a4,30(sp)
8000a720:	00f14783          	lbu	a5,15(sp)
8000a724:	863a                	mv	a2,a4
8000a726:	45a2                	lw	a1,8(sp)
8000a728:	853e                	mv	a0,a5
8000a72a:	a49fa0ef          	jal	80005172 <wiz_recv_data>
			break;
8000a72e:	ac9d                	j	8000a9a4 <.L137>

8000a730 <.L129>:
	   case Sn_MR_MACRAW :
	      if(sock_remained_size[sn] == 0)
8000a730:	00f14783          	lbu	a5,15(sp)
8000a734:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a738:	0786                	sll	a5,a5,0x1
8000a73a:	97ba                	add	a5,a5,a4
8000a73c:	0007d783          	lhu	a5,0(a5)
8000a740:	e7f1                	bnez	a5,8000a80c <.L138>
	      {
   			wiz_recv_data(sn, head, 2);
8000a742:	0858                	add	a4,sp,20
8000a744:	00f14783          	lbu	a5,15(sp)
8000a748:	4609                	li	a2,2
8000a74a:	85ba                	mv	a1,a4
8000a74c:	853e                	mv	a0,a5
8000a74e:	a25fa0ef          	jal	80005172 <wiz_recv_data>
   			setSn_CR(sn,Sn_CR_RECV);
8000a752:	00f14783          	lbu	a5,15(sp)
8000a756:	078a                	sll	a5,a5,0x2
8000a758:	0785                	add	a5,a5,1
8000a75a:	078e                	sll	a5,a5,0x3
8000a75c:	10078793          	add	a5,a5,256
8000a760:	04000593          	li	a1,64
8000a764:	853e                	mv	a0,a5
8000a766:	93cff0ef          	jal	800098a2 <WIZCHIP_WRITE>
   			while(getSn_CR(sn));
8000a76a:	0001                	nop

8000a76c <.L139>:
8000a76c:	00f14783          	lbu	a5,15(sp)
8000a770:	078a                	sll	a5,a5,0x2
8000a772:	0785                	add	a5,a5,1
8000a774:	078e                	sll	a5,a5,0x3
8000a776:	10078793          	add	a5,a5,256
8000a77a:	853e                	mv	a0,a5
8000a77c:	f6afa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a780:	87aa                	mv	a5,a0
8000a782:	f7ed                	bnez	a5,8000a76c <.L139>
   			// read peer's IP address, port number & packet length
    			sock_remained_size[sn] = head[0];
8000a784:	01414703          	lbu	a4,20(sp)
8000a788:	00f14783          	lbu	a5,15(sp)
8000a78c:	86ba                	mv	a3,a4
8000a78e:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a792:	0786                	sll	a5,a5,0x1
8000a794:	97ba                	add	a5,a5,a4
8000a796:	00d79023          	sh	a3,0(a5)
   			sock_remained_size[sn] = (sock_remained_size[sn] <<8) + head[1] -2;
8000a79a:	00f14783          	lbu	a5,15(sp)
8000a79e:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a7a2:	0786                	sll	a5,a5,0x1
8000a7a4:	97ba                	add	a5,a5,a4
8000a7a6:	0007d783          	lhu	a5,0(a5)
8000a7aa:	07a2                	sll	a5,a5,0x8
8000a7ac:	07c2                	sll	a5,a5,0x10
8000a7ae:	83c1                	srl	a5,a5,0x10
8000a7b0:	01514703          	lbu	a4,21(sp)
8000a7b4:	97ba                	add	a5,a5,a4
8000a7b6:	01079713          	sll	a4,a5,0x10
8000a7ba:	8341                	srl	a4,a4,0x10
8000a7bc:	00f14783          	lbu	a5,15(sp)
8000a7c0:	1779                	add	a4,a4,-2
8000a7c2:	0742                	sll	a4,a4,0x10
8000a7c4:	8341                	srl	a4,a4,0x10
8000a7c6:	10018693          	add	a3,gp,256 # 1080900 <sock_remained_size>
8000a7ca:	0786                	sll	a5,a5,0x1
8000a7cc:	97b6                	add	a5,a5,a3
8000a7ce:	00e79023          	sh	a4,0(a5)
   			if(sock_remained_size[sn] & 0x01)
   				sock_remained_size[sn] = sock_remained_size[sn] + 1 - 4;
   			else
   				sock_remained_size[sn] -= 4;
			#endif
   			if(sock_remained_size[sn] > 1514) 
8000a7d2:	00f14783          	lbu	a5,15(sp)
8000a7d6:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a7da:	0786                	sll	a5,a5,0x1
8000a7dc:	97ba                	add	a5,a5,a4
8000a7de:	0007d703          	lhu	a4,0(a5)
8000a7e2:	5ea00793          	li	a5,1514
8000a7e6:	00e7fa63          	bgeu	a5,a4,8000a7fa <.L140>
   			{
   			   close(sn);
8000a7ea:	00f14783          	lbu	a5,15(sp)
8000a7ee:	853e                	mv	a0,a5
8000a7f0:	e66ff0ef          	jal	80009e56 <close>
   			   return SOCKFATAL_PACKLEN;
8000a7f4:	c1700793          	li	a5,-1001
8000a7f8:	ac89                	j	8000aa4a <.L150>

8000a7fa <.L140>:
   			}
   			sock_pack_info[sn] = PACK_FIRST;
8000a7fa:	00f14783          	lbu	a5,15(sp)
8000a7fe:	11018713          	add	a4,gp,272 # 1080910 <sock_pack_info>
8000a802:	97ba                	add	a5,a5,a4
8000a804:	f8000713          	li	a4,-128
8000a808:	00e78023          	sb	a4,0(a5)

8000a80c <.L138>:
   	   }
			if(len < sock_remained_size[sn]) pack_len = len;
8000a80c:	00f14783          	lbu	a5,15(sp)
8000a810:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a814:	0786                	sll	a5,a5,0x1
8000a816:	97ba                	add	a5,a5,a4
8000a818:	0007d783          	lhu	a5,0(a5)
8000a81c:	00c15703          	lhu	a4,12(sp)
8000a820:	00f77763          	bgeu	a4,a5,8000a82e <.L141>
8000a824:	00c15783          	lhu	a5,12(sp)
8000a828:	00f11f23          	sh	a5,30(sp)
8000a82c:	a819                	j	8000a842 <.L142>

8000a82e <.L141>:
			else pack_len = sock_remained_size[sn];
8000a82e:	00f14783          	lbu	a5,15(sp)
8000a832:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a836:	0786                	sll	a5,a5,0x1
8000a838:	97ba                	add	a5,a5,a4
8000a83a:	0007d783          	lhu	a5,0(a5)
8000a83e:	00f11f23          	sh	a5,30(sp)

8000a842 <.L142>:
			wiz_recv_data(sn,buf,pack_len);
8000a842:	01e15703          	lhu	a4,30(sp)
8000a846:	00f14783          	lbu	a5,15(sp)
8000a84a:	863a                	mv	a2,a4
8000a84c:	45a2                	lw	a1,8(sp)
8000a84e:	853e                	mv	a0,a5
8000a850:	923fa0ef          	jal	80005172 <wiz_recv_data>
		   break;
8000a854:	aa81                	j	8000a9a4 <.L137>

8000a856 <.L132>:
   //#if ( _WIZCHIP_ < 5200 )
		case Sn_MR_IPRAW:
		   if(sock_remained_size[sn] == 0)
8000a856:	00f14783          	lbu	a5,15(sp)
8000a85a:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a85e:	0786                	sll	a5,a5,0x1
8000a860:	97ba                	add	a5,a5,a4
8000a862:	0007d783          	lhu	a5,0(a5)
8000a866:	e7f9                	bnez	a5,8000a934 <.L143>
		   {
   			wiz_recv_data(sn, head, 6);
8000a868:	0858                	add	a4,sp,20
8000a86a:	00f14783          	lbu	a5,15(sp)
8000a86e:	4619                	li	a2,6
8000a870:	85ba                	mv	a1,a4
8000a872:	853e                	mv	a0,a5
8000a874:	8fffa0ef          	jal	80005172 <wiz_recv_data>
   			setSn_CR(sn,Sn_CR_RECV);
8000a878:	00f14783          	lbu	a5,15(sp)
8000a87c:	078a                	sll	a5,a5,0x2
8000a87e:	0785                	add	a5,a5,1
8000a880:	078e                	sll	a5,a5,0x3
8000a882:	10078793          	add	a5,a5,256
8000a886:	04000593          	li	a1,64
8000a88a:	853e                	mv	a0,a5
8000a88c:	816ff0ef          	jal	800098a2 <WIZCHIP_WRITE>
   			while(getSn_CR(sn));
8000a890:	0001                	nop

8000a892 <.L144>:
8000a892:	00f14783          	lbu	a5,15(sp)
8000a896:	078a                	sll	a5,a5,0x2
8000a898:	0785                	add	a5,a5,1
8000a89a:	078e                	sll	a5,a5,0x3
8000a89c:	10078793          	add	a5,a5,256
8000a8a0:	853e                	mv	a0,a5
8000a8a2:	e44fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a8a6:	87aa                	mv	a5,a0
8000a8a8:	f7ed                	bnez	a5,8000a892 <.L144>
   			addr[0] = head[0];
8000a8aa:	01414703          	lbu	a4,20(sp)
8000a8ae:	4792                	lw	a5,4(sp)
8000a8b0:	00e78023          	sb	a4,0(a5)
   			addr[1] = head[1];
8000a8b4:	4792                	lw	a5,4(sp)
8000a8b6:	0785                	add	a5,a5,1
8000a8b8:	01514703          	lbu	a4,21(sp)
8000a8bc:	00e78023          	sb	a4,0(a5)
   			addr[2] = head[2];
8000a8c0:	4792                	lw	a5,4(sp)
8000a8c2:	0789                	add	a5,a5,2
8000a8c4:	01614703          	lbu	a4,22(sp)
8000a8c8:	00e78023          	sb	a4,0(a5)
   			addr[3] = head[3];
8000a8cc:	4792                	lw	a5,4(sp)
8000a8ce:	078d                	add	a5,a5,3
8000a8d0:	01714703          	lbu	a4,23(sp)
8000a8d4:	00e78023          	sb	a4,0(a5)
   			sock_remained_size[sn] = head[4];
8000a8d8:	01814703          	lbu	a4,24(sp)
8000a8dc:	00f14783          	lbu	a5,15(sp)
8000a8e0:	86ba                	mv	a3,a4
8000a8e2:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a8e6:	0786                	sll	a5,a5,0x1
8000a8e8:	97ba                	add	a5,a5,a4
8000a8ea:	00d79023          	sh	a3,0(a5)
   			//M20150401 : For Typing Error
   			//sock_remaiend_size[sn] = (sock_remained_size[sn] << 8) + head[5];
   			sock_remained_size[sn] = (sock_remained_size[sn] << 8) + head[5];
8000a8ee:	00f14783          	lbu	a5,15(sp)
8000a8f2:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a8f6:	0786                	sll	a5,a5,0x1
8000a8f8:	97ba                	add	a5,a5,a4
8000a8fa:	0007d783          	lhu	a5,0(a5)
8000a8fe:	07a2                	sll	a5,a5,0x8
8000a900:	01079713          	sll	a4,a5,0x10
8000a904:	8341                	srl	a4,a4,0x10
8000a906:	01914783          	lbu	a5,25(sp)
8000a90a:	86be                	mv	a3,a5
8000a90c:	00f14783          	lbu	a5,15(sp)
8000a910:	9736                	add	a4,a4,a3
8000a912:	0742                	sll	a4,a4,0x10
8000a914:	8341                	srl	a4,a4,0x10
8000a916:	10018693          	add	a3,gp,256 # 1080900 <sock_remained_size>
8000a91a:	0786                	sll	a5,a5,0x1
8000a91c:	97b6                	add	a5,a5,a3
8000a91e:	00e79023          	sh	a4,0(a5)
   			sock_pack_info[sn] = PACK_FIRST;
8000a922:	00f14783          	lbu	a5,15(sp)
8000a926:	11018713          	add	a4,gp,272 # 1080910 <sock_pack_info>
8000a92a:	97ba                	add	a5,a5,a4
8000a92c:	f8000713          	li	a4,-128
8000a930:	00e78023          	sb	a4,0(a5)

8000a934 <.L143>:
         }
			//
			// Need to packet length check
			//
			if(len < sock_remained_size[sn]) pack_len = len;
8000a934:	00f14783          	lbu	a5,15(sp)
8000a938:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a93c:	0786                	sll	a5,a5,0x1
8000a93e:	97ba                	add	a5,a5,a4
8000a940:	0007d783          	lhu	a5,0(a5)
8000a944:	00c15703          	lhu	a4,12(sp)
8000a948:	00f77763          	bgeu	a4,a5,8000a956 <.L145>
8000a94c:	00c15783          	lhu	a5,12(sp)
8000a950:	00f11f23          	sh	a5,30(sp)
8000a954:	a819                	j	8000a96a <.L146>

8000a956 <.L145>:
			else pack_len = sock_remained_size[sn];
8000a956:	00f14783          	lbu	a5,15(sp)
8000a95a:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a95e:	0786                	sll	a5,a5,0x1
8000a960:	97ba                	add	a5,a5,a4
8000a962:	0007d783          	lhu	a5,0(a5)
8000a966:	00f11f23          	sh	a5,30(sp)

8000a96a <.L146>:
   		wiz_recv_data(sn, buf, pack_len); // data copy.
8000a96a:	01e15703          	lhu	a4,30(sp)
8000a96e:	00f14783          	lbu	a5,15(sp)
8000a972:	863a                	mv	a2,a4
8000a974:	45a2                	lw	a1,8(sp)
8000a976:	853e                	mv	a0,a5
8000a978:	ffafa0ef          	jal	80005172 <wiz_recv_data>
			break;
8000a97c:	a025                	j	8000a9a4 <.L137>

8000a97e <.L130>:
   //#endif
      default:
         wiz_recv_ignore(sn, pack_len); // data copy.
8000a97e:	01e15703          	lhu	a4,30(sp)
8000a982:	00f14783          	lbu	a5,15(sp)
8000a986:	85ba                	mv	a1,a4
8000a988:	853e                	mv	a0,a5
8000a98a:	8dffa0ef          	jal	80005268 <wiz_recv_ignore>
         sock_remained_size[sn] = pack_len;
8000a98e:	00f14783          	lbu	a5,15(sp)
8000a992:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a996:	0786                	sll	a5,a5,0x1
8000a998:	97ba                	add	a5,a5,a4
8000a99a:	01e15703          	lhu	a4,30(sp)
8000a99e:	00e79023          	sh	a4,0(a5)
         break;
8000a9a2:	0001                	nop

8000a9a4 <.L137>:
   }
	setSn_CR(sn,Sn_CR_RECV);
8000a9a4:	00f14783          	lbu	a5,15(sp)
8000a9a8:	078a                	sll	a5,a5,0x2
8000a9aa:	0785                	add	a5,a5,1
8000a9ac:	078e                	sll	a5,a5,0x3
8000a9ae:	10078793          	add	a5,a5,256
8000a9b2:	04000593          	li	a1,64
8000a9b6:	853e                	mv	a0,a5
8000a9b8:	eebfe0ef          	jal	800098a2 <WIZCHIP_WRITE>
	/* wait to process the command... */
	while(getSn_CR(sn)) ;
8000a9bc:	0001                	nop

8000a9be <.L147>:
8000a9be:	00f14783          	lbu	a5,15(sp)
8000a9c2:	078a                	sll	a5,a5,0x2
8000a9c4:	0785                	add	a5,a5,1
8000a9c6:	078e                	sll	a5,a5,0x3
8000a9c8:	10078793          	add	a5,a5,256
8000a9cc:	853e                	mv	a0,a5
8000a9ce:	d18fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000a9d2:	87aa                	mv	a5,a0
8000a9d4:	f7ed                	bnez	a5,8000a9be <.L147>
	sock_remained_size[sn] -= pack_len;
8000a9d6:	00f14783          	lbu	a5,15(sp)
8000a9da:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000a9de:	0786                	sll	a5,a5,0x1
8000a9e0:	97ba                	add	a5,a5,a4
8000a9e2:	0007d703          	lhu	a4,0(a5)
8000a9e6:	00f14783          	lbu	a5,15(sp)
8000a9ea:	01e15683          	lhu	a3,30(sp)
8000a9ee:	8f15                	sub	a4,a4,a3
8000a9f0:	0742                	sll	a4,a4,0x10
8000a9f2:	8341                	srl	a4,a4,0x10
8000a9f4:	10018693          	add	a3,gp,256 # 1080900 <sock_remained_size>
8000a9f8:	0786                	sll	a5,a5,0x1
8000a9fa:	97b6                	add	a5,a5,a3
8000a9fc:	00e79023          	sh	a4,0(a5)
	//M20150601 : 
	//if(sock_remained_size[sn] != 0) sock_pack_info[sn] |= 0x01;
	if(sock_remained_size[sn] != 0)
8000aa00:	00f14783          	lbu	a5,15(sp)
8000aa04:	10018713          	add	a4,gp,256 # 1080900 <sock_remained_size>
8000aa08:	0786                	sll	a5,a5,0x1
8000aa0a:	97ba                	add	a5,a5,a4
8000aa0c:	0007d783          	lhu	a5,0(a5)
8000aa10:	c785                	beqz	a5,8000aa38 <.L148>
	{
	   sock_pack_info[sn] |= PACK_REMAINED;
8000aa12:	00f14783          	lbu	a5,15(sp)
8000aa16:	11018713          	add	a4,gp,272 # 1080910 <sock_pack_info>
8000aa1a:	97ba                	add	a5,a5,a4
8000aa1c:	0007c703          	lbu	a4,0(a5)
8000aa20:	00f14783          	lbu	a5,15(sp)
8000aa24:	00176713          	or	a4,a4,1
8000aa28:	0ff77713          	zext.b	a4,a4
8000aa2c:	11018693          	add	a3,gp,272 # 1080910 <sock_pack_info>
8000aa30:	97b6                	add	a5,a5,a3
8000aa32:	00e78023          	sb	a4,0(a5)
8000aa36:	a801                	j	8000aa46 <.L149>

8000aa38 <.L148>:
   #if _WIZCHIP_ == 5300	   
	   if(pack_len & 0x01) sock_pack_info[sn] |= PACK_FIFOBYTE;
   #endif	      
	}
	else sock_pack_info[sn] = PACK_COMPLETED;
8000aa38:	00f14783          	lbu	a5,15(sp)
8000aa3c:	11018713          	add	a4,gp,272 # 1080910 <sock_pack_info>
8000aa40:	97ba                	add	a5,a5,a4
8000aa42:	00078023          	sb	zero,0(a5)

8000aa46 <.L149>:
   pack_len = len;
#endif
   //
   //M20150409 : Explicit Type Casting
   //return pack_len;
   return (int32_t)pack_len;
8000aa46:	01e15783          	lhu	a5,30(sp)

8000aa4a <.L150>:
}
8000aa4a:	853e                	mv	a0,a5
8000aa4c:	50b2                	lw	ra,44(sp)
8000aa4e:	6145                	add	sp,sp,48
8000aa50:	8082                	ret

Disassembly of section .text.wizchip_cris_enter:

8000aa52 <wizchip_cris_enter>:
void 	  wizchip_cris_enter(void)           {}
8000aa52:	0001                	nop
8000aa54:	8082                	ret

Disassembly of section .text.wizchip_cris_exit:

8000aa56 <wizchip_cris_exit>:
void 	  wizchip_cris_exit(void)          {}
8000aa56:	0001                	nop
8000aa58:	8082                	ret

Disassembly of section .text.wizchip_cs_select:

8000aa5a <wizchip_cs_select>:
void 	wizchip_cs_select(void)            {}
8000aa5a:	0001                	nop
8000aa5c:	8082                	ret

Disassembly of section .text.wizchip_cs_deselect:

8000aa5e <wizchip_cs_deselect>:
void 	wizchip_cs_deselect(void)          {}
8000aa5e:	0001                	nop
8000aa60:	8082                	ret

Disassembly of section .text.wizchip_bus_readdata:

8000aa62 <wizchip_bus_readdata>:
iodata_t wizchip_bus_readdata(uint32_t AddrSel) { return * ((volatile iodata_t *)((ptrdiff_t) AddrSel)); }
8000aa62:	1141                	add	sp,sp,-16
8000aa64:	c62a                	sw	a0,12(sp)
8000aa66:	47b2                	lw	a5,12(sp)
8000aa68:	0007c783          	lbu	a5,0(a5)
8000aa6c:	0ff7f793          	zext.b	a5,a5
8000aa70:	853e                	mv	a0,a5
8000aa72:	0141                	add	sp,sp,16
8000aa74:	8082                	ret

Disassembly of section .text.wizchip_spi_readburst:

8000aa76 <wizchip_spi_readburst>:
void 	wizchip_spi_readburst(uint8_t* pBuf, uint16_t len) 	{}
8000aa76:	1141                	add	sp,sp,-16
8000aa78:	c62a                	sw	a0,12(sp)
8000aa7a:	87ae                	mv	a5,a1
8000aa7c:	00f11523          	sh	a5,10(sp)
8000aa80:	0001                	nop
8000aa82:	0141                	add	sp,sp,16
8000aa84:	8082                	ret

Disassembly of section .text.wizchip_spi_writeburst:

8000aa86 <wizchip_spi_writeburst>:
void 	wizchip_spi_writeburst(uint8_t* pBuf, uint16_t len) {}
8000aa86:	1141                	add	sp,sp,-16
8000aa88:	c62a                	sw	a0,12(sp)
8000aa8a:	87ae                	mv	a5,a1
8000aa8c:	00f11523          	sh	a5,10(sp)
8000aa90:	0001                	nop
8000aa92:	0141                	add	sp,sp,16
8000aa94:	8082                	ret

Disassembly of section .text.reg_wizchip_cris_cbfunc:

8000aa96 <reg_wizchip_cris_cbfunc>:
{
8000aa96:	1141                	add	sp,sp,-16
8000aa98:	c62a                	sw	a0,12(sp)
8000aa9a:	c42e                	sw	a1,8(sp)
   if(!cris_en || !cris_ex)
8000aa9c:	47b2                	lw	a5,12(sp)
8000aa9e:	c399                	beqz	a5,8000aaa4 <.L14>
8000aaa0:	47a2                	lw	a5,8(sp)
8000aaa2:	e385                	bnez	a5,8000aac2 <.L15>

8000aaa4 <.L14>:
      WIZCHIP.CRIS._enter = wizchip_cris_enter;
8000aaa4:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000aaa8:	8000b737          	lui	a4,0x8000b
8000aaac:	a5270713          	add	a4,a4,-1454 # 8000aa52 <wizchip_cris_enter>
8000aab0:	c7d8                	sw	a4,12(a5)
      WIZCHIP.CRIS._exit  = wizchip_cris_exit;
8000aab2:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000aab6:	8000b737          	lui	a4,0x8000b
8000aaba:	a5670713          	add	a4,a4,-1450 # 8000aa56 <wizchip_cris_exit>
8000aabe:	cb98                	sw	a4,16(a5)
8000aac0:	a811                	j	8000aad4 <.L16>

8000aac2 <.L15>:
      WIZCHIP.CRIS._enter = cris_en;
8000aac2:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000aac6:	4732                	lw	a4,12(sp)
8000aac8:	c7d8                	sw	a4,12(a5)
      WIZCHIP.CRIS._exit  = cris_ex;
8000aaca:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000aace:	4722                	lw	a4,8(sp)
8000aad0:	cb98                	sw	a4,16(a5)
}
8000aad2:	0001                	nop

8000aad4 <.L16>:
8000aad4:	0001                	nop
8000aad6:	0141                	add	sp,sp,16
8000aad8:	8082                	ret

Disassembly of section .text.reg_wizchip_cs_cbfunc:

8000aada <reg_wizchip_cs_cbfunc>:
{
8000aada:	1141                	add	sp,sp,-16
8000aadc:	c62a                	sw	a0,12(sp)
8000aade:	c42e                	sw	a1,8(sp)
   if(!cs_sel || !cs_desel)
8000aae0:	47b2                	lw	a5,12(sp)
8000aae2:	c399                	beqz	a5,8000aae8 <.L18>
8000aae4:	47a2                	lw	a5,8(sp)
8000aae6:	e385                	bnez	a5,8000ab06 <.L19>

8000aae8 <.L18>:
      WIZCHIP.CS._select   = wizchip_cs_select;
8000aae8:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000aaec:	8000b737          	lui	a4,0x8000b
8000aaf0:	a5a70713          	add	a4,a4,-1446 # 8000aa5a <wizchip_cs_select>
8000aaf4:	cbd8                	sw	a4,20(a5)
      WIZCHIP.CS._deselect = wizchip_cs_deselect;
8000aaf6:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000aafa:	8000b737          	lui	a4,0x8000b
8000aafe:	a5e70713          	add	a4,a4,-1442 # 8000aa5e <wizchip_cs_deselect>
8000ab02:	cf98                	sw	a4,24(a5)
8000ab04:	a811                	j	8000ab18 <.L20>

8000ab06 <.L19>:
      WIZCHIP.CS._select   = cs_sel;
8000ab06:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab0a:	4732                	lw	a4,12(sp)
8000ab0c:	cbd8                	sw	a4,20(a5)
      WIZCHIP.CS._deselect = cs_desel;
8000ab0e:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab12:	4722                	lw	a4,8(sp)
8000ab14:	cf98                	sw	a4,24(a5)
}
8000ab16:	0001                	nop

8000ab18 <.L20>:
8000ab18:	0001                	nop
8000ab1a:	0141                	add	sp,sp,16
8000ab1c:	8082                	ret

Disassembly of section .text.reg_wizchip_spi_cbfunc:

8000ab1e <reg_wizchip_spi_cbfunc>:
{
8000ab1e:	1141                	add	sp,sp,-16
8000ab20:	c62a                	sw	a0,12(sp)
8000ab22:	c42e                	sw	a1,8(sp)
   while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_SPI_));
8000ab24:	0001                	nop

8000ab26 <.L27>:
8000ab26:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab2a:	0007d783          	lhu	a5,0(a5)
8000ab2e:	2007f793          	and	a5,a5,512
8000ab32:	dbf5                	beqz	a5,8000ab26 <.L27>
   if(!spi_rb || !spi_wb)
8000ab34:	47b2                	lw	a5,12(sp)
8000ab36:	c399                	beqz	a5,8000ab3c <.L28>
8000ab38:	47a2                	lw	a5,8(sp)
8000ab3a:	e385                	bnez	a5,8000ab5a <.L29>

8000ab3c <.L28>:
      WIZCHIP.IF.SPI._read_byte   = wizchip_spi_readbyte;
8000ab3c:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab40:	80005737          	lui	a4,0x80005
8000ab44:	58470713          	add	a4,a4,1412 # 80005584 <wizchip_spi_readbyte>
8000ab48:	cfd8                	sw	a4,28(a5)
      WIZCHIP.IF.SPI._write_byte  = wizchip_spi_writebyte;
8000ab4a:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab4e:	80005737          	lui	a4,0x80005
8000ab52:	58a70713          	add	a4,a4,1418 # 8000558a <wizchip_spi_writebyte>
8000ab56:	d398                	sw	a4,32(a5)
8000ab58:	a811                	j	8000ab6c <.L30>

8000ab5a <.L29>:
      WIZCHIP.IF.SPI._read_byte   = spi_rb;
8000ab5a:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab5e:	4732                	lw	a4,12(sp)
8000ab60:	cfd8                	sw	a4,28(a5)
      WIZCHIP.IF.SPI._write_byte  = spi_wb;
8000ab62:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab66:	4722                	lw	a4,8(sp)
8000ab68:	d398                	sw	a4,32(a5)
}
8000ab6a:	0001                	nop

8000ab6c <.L30>:
8000ab6c:	0001                	nop
8000ab6e:	0141                	add	sp,sp,16
8000ab70:	8082                	ret

Disassembly of section .text.reg_wizchip_spiburst_cbfunc:

8000ab72 <reg_wizchip_spiburst_cbfunc>:
{
8000ab72:	1141                	add	sp,sp,-16
8000ab74:	c62a                	sw	a0,12(sp)
8000ab76:	c42e                	sw	a1,8(sp)
   while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_SPI_));
8000ab78:	0001                	nop

8000ab7a <.L32>:
8000ab7a:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab7e:	0007d783          	lhu	a5,0(a5)
8000ab82:	2007f793          	and	a5,a5,512
8000ab86:	dbf5                	beqz	a5,8000ab7a <.L32>
   if(!spi_rb || !spi_wb)
8000ab88:	47b2                	lw	a5,12(sp)
8000ab8a:	c399                	beqz	a5,8000ab90 <.L33>
8000ab8c:	47a2                	lw	a5,8(sp)
8000ab8e:	e385                	bnez	a5,8000abae <.L34>

8000ab90 <.L33>:
      WIZCHIP.IF.SPI._read_burst   = wizchip_spi_readburst;
8000ab90:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000ab94:	8000b737          	lui	a4,0x8000b
8000ab98:	a7670713          	add	a4,a4,-1418 # 8000aa76 <wizchip_spi_readburst>
8000ab9c:	d3d8                	sw	a4,36(a5)
      WIZCHIP.IF.SPI._write_burst  = wizchip_spi_writeburst;
8000ab9e:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000aba2:	8000b737          	lui	a4,0x8000b
8000aba6:	a8670713          	add	a4,a4,-1402 # 8000aa86 <wizchip_spi_writeburst>
8000abaa:	d798                	sw	a4,40(a5)
8000abac:	a811                	j	8000abc0 <.L35>

8000abae <.L34>:
      WIZCHIP.IF.SPI._read_burst   = spi_rb;
8000abae:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000abb2:	4732                	lw	a4,12(sp)
8000abb4:	d3d8                	sw	a4,36(a5)
      WIZCHIP.IF.SPI._write_burst  = spi_wb;
8000abb6:	80018793          	add	a5,gp,-2048 # 1080000 <WIZCHIP>
8000abba:	4722                	lw	a4,8(sp)
8000abbc:	d798                	sw	a4,40(a5)
}
8000abbe:	0001                	nop

8000abc0 <.L35>:
8000abc0:	0001                	nop
8000abc2:	0141                	add	sp,sp,16
8000abc4:	8082                	ret

Disassembly of section .text.wizchip_sw_reset:

8000abc6 <wizchip_sw_reset>:
{
8000abc6:	7179                	add	sp,sp,-48
8000abc8:	d606                	sw	ra,44(sp)
   getSHAR(mac);
8000abca:	007c                	add	a5,sp,12
8000abcc:	4619                	li	a2,6
8000abce:	85be                	mv	a1,a5
8000abd0:	6785                	lui	a5,0x1
8000abd2:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
8000abd6:	d8dfe0ef          	jal	80009962 <WIZCHIP_READ_BUF>
   getGAR(gw);
8000abda:	087c                	add	a5,sp,28
8000abdc:	4611                	li	a2,4
8000abde:	85be                	mv	a1,a5
8000abe0:	10000513          	li	a0,256
8000abe4:	d7ffe0ef          	jal	80009962 <WIZCHIP_READ_BUF>
   getSUBR(sn);
8000abe8:	083c                	add	a5,sp,24
8000abea:	4611                	li	a2,4
8000abec:	85be                	mv	a1,a5
8000abee:	50000513          	li	a0,1280
8000abf2:	d71fe0ef          	jal	80009962 <WIZCHIP_READ_BUF>
   getSIPR(sip);
8000abf6:	085c                	add	a5,sp,20
8000abf8:	4611                	li	a2,4
8000abfa:	85be                	mv	a1,a5
8000abfc:	6785                	lui	a5,0x1
8000abfe:	f0078513          	add	a0,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
8000ac02:	d61fe0ef          	jal	80009962 <WIZCHIP_READ_BUF>
   setMR(MR_RST);
8000ac06:	08000593          	li	a1,128
8000ac0a:	4501                	li	a0,0
8000ac0c:	c97fe0ef          	jal	800098a2 <WIZCHIP_WRITE>
   getMR(); // for delay
8000ac10:	4501                	li	a0,0
8000ac12:	ad4fa0ef          	jal	80004ee6 <WIZCHIP_READ>
   setSHAR(mac);
8000ac16:	007c                	add	a5,sp,12
8000ac18:	4619                	li	a2,6
8000ac1a:	85be                	mv	a1,a5
8000ac1c:	6785                	lui	a5,0x1
8000ac1e:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
8000ac22:	b6efa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setGAR(gw);
8000ac26:	087c                	add	a5,sp,28
8000ac28:	4611                	li	a2,4
8000ac2a:	85be                	mv	a1,a5
8000ac2c:	10000513          	li	a0,256
8000ac30:	b60fa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setSUBR(sn);
8000ac34:	083c                	add	a5,sp,24
8000ac36:	4611                	li	a2,4
8000ac38:	85be                	mv	a1,a5
8000ac3a:	50000513          	li	a0,1280
8000ac3e:	b52fa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setSIPR(sip);
8000ac42:	085c                	add	a5,sp,20
8000ac44:	4611                	li	a2,4
8000ac46:	85be                	mv	a1,a5
8000ac48:	6785                	lui	a5,0x1
8000ac4a:	f0078513          	add	a0,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
8000ac4e:	b42fa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
}
8000ac52:	0001                	nop
8000ac54:	50b2                	lw	ra,44(sp)
8000ac56:	6145                	add	sp,sp,48
8000ac58:	8082                	ret

Disassembly of section .text.wizchip_clrinterrupt:

8000ac5a <wizchip_clrinterrupt>:
{
8000ac5a:	7179                	add	sp,sp,-48
8000ac5c:	d606                	sw	ra,44(sp)
8000ac5e:	87aa                	mv	a5,a0
8000ac60:	00f11723          	sh	a5,14(sp)
   uint8_t ir  = (uint8_t)intr;
8000ac64:	00e15783          	lhu	a5,14(sp)
8000ac68:	00f10fa3          	sb	a5,31(sp)
   uint8_t sir = (uint8_t)((uint16_t)intr >> 8);
8000ac6c:	00e15783          	lhu	a5,14(sp)
8000ac70:	83a1                	srl	a5,a5,0x8
8000ac72:	07c2                	sll	a5,a5,0x10
8000ac74:	83c1                	srl	a5,a5,0x10
8000ac76:	00f10f23          	sb	a5,30(sp)
   setIR(ir);
8000ac7a:	01f14783          	lbu	a5,31(sp)
8000ac7e:	9bc1                	and	a5,a5,-16
8000ac80:	0ff7f793          	zext.b	a5,a5
8000ac84:	85be                	mv	a1,a5
8000ac86:	6785                	lui	a5,0x1
8000ac88:	50078513          	add	a0,a5,1280 # 1500 <__fw_size__+0x500>
8000ac8c:	c17fe0ef          	jal	800098a2 <WIZCHIP_WRITE>
   for(ir=0; ir<8; ir++){
8000ac90:	00010fa3          	sb	zero,31(sp)
8000ac94:	a80d                	j	8000acc6 <.L89>

8000ac96 <.L91>:
       if(sir & (0x01 <<ir) ) setSn_IR(ir, 0xff);
8000ac96:	01e14703          	lbu	a4,30(sp)
8000ac9a:	01f14783          	lbu	a5,31(sp)
8000ac9e:	40f757b3          	sra	a5,a4,a5
8000aca2:	8b85                	and	a5,a5,1
8000aca4:	cf81                	beqz	a5,8000acbc <.L90>
8000aca6:	01f14783          	lbu	a5,31(sp)
8000acaa:	078a                	sll	a5,a5,0x2
8000acac:	0785                	add	a5,a5,1
8000acae:	078e                	sll	a5,a5,0x3
8000acb0:	20078793          	add	a5,a5,512
8000acb4:	45fd                	li	a1,31
8000acb6:	853e                	mv	a0,a5
8000acb8:	bebfe0ef          	jal	800098a2 <WIZCHIP_WRITE>

8000acbc <.L90>:
   for(ir=0; ir<8; ir++){
8000acbc:	01f14783          	lbu	a5,31(sp)
8000acc0:	0785                	add	a5,a5,1
8000acc2:	00f10fa3          	sb	a5,31(sp)

8000acc6 <.L89>:
8000acc6:	01f14703          	lbu	a4,31(sp)
8000acca:	479d                	li	a5,7
8000accc:	fce7f5e3          	bgeu	a5,a4,8000ac96 <.L91>
}
8000acd0:	0001                	nop
8000acd2:	0001                	nop
8000acd4:	50b2                	lw	ra,44(sp)
8000acd6:	6145                	add	sp,sp,48
8000acd8:	8082                	ret

Disassembly of section .text.wizchip_getinterrupt:

8000acda <wizchip_getinterrupt>:
{
8000acda:	1101                	add	sp,sp,-32
8000acdc:	ce06                	sw	ra,28(sp)
   uint8_t ir  = 0;
8000acde:	000107a3          	sb	zero,15(sp)
   uint8_t sir = 0;
8000ace2:	00010723          	sb	zero,14(sp)
   uint16_t ret = 0;
8000ace6:	00011623          	sh	zero,12(sp)
   ir  = getIR();
8000acea:	6785                	lui	a5,0x1
8000acec:	50078513          	add	a0,a5,1280 # 1500 <__fw_size__+0x500>
8000acf0:	9f6fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000acf4:	87aa                	mv	a5,a0
8000acf6:	9bc1                	and	a5,a5,-16
8000acf8:	00f107a3          	sb	a5,15(sp)
   sir = getSIR();
8000acfc:	6785                	lui	a5,0x1
8000acfe:	70078513          	add	a0,a5,1792 # 1700 <__fw_size__+0x700>
8000ad02:	9e4fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000ad06:	87aa                	mv	a5,a0
8000ad08:	00f10723          	sb	a5,14(sp)
  ret = sir;
8000ad0c:	00e14783          	lbu	a5,14(sp)
8000ad10:	00f11623          	sh	a5,12(sp)
  ret = (ret << 8) + ir;
8000ad14:	00c15783          	lhu	a5,12(sp)
8000ad18:	07a2                	sll	a5,a5,0x8
8000ad1a:	01079713          	sll	a4,a5,0x10
8000ad1e:	8341                	srl	a4,a4,0x10
8000ad20:	00f14783          	lbu	a5,15(sp)
8000ad24:	07c2                	sll	a5,a5,0x10
8000ad26:	83c1                	srl	a5,a5,0x10
8000ad28:	97ba                	add	a5,a5,a4
8000ad2a:	00f11623          	sh	a5,12(sp)
  return (intr_kind)ret;
8000ad2e:	00c15783          	lhu	a5,12(sp)
}
8000ad32:	853e                	mv	a0,a5
8000ad34:	40f2                	lw	ra,28(sp)
8000ad36:	6105                	add	sp,sp,32
8000ad38:	8082                	ret

Disassembly of section .text.wizchip_setinterruptmask:

8000ad3a <wizchip_setinterruptmask>:
{
8000ad3a:	7179                	add	sp,sp,-48
8000ad3c:	d606                	sw	ra,44(sp)
8000ad3e:	87aa                	mv	a5,a0
8000ad40:	00f11723          	sh	a5,14(sp)
   uint8_t imr  = (uint8_t)intr;
8000ad44:	00e15783          	lhu	a5,14(sp)
8000ad48:	00f10fa3          	sb	a5,31(sp)
   uint8_t simr = (uint8_t)((uint16_t)intr >> 8);
8000ad4c:	00e15783          	lhu	a5,14(sp)
8000ad50:	83a1                	srl	a5,a5,0x8
8000ad52:	07c2                	sll	a5,a5,0x10
8000ad54:	83c1                	srl	a5,a5,0x10
8000ad56:	00f10f23          	sb	a5,30(sp)
   setIMR(imr);
8000ad5a:	01f14783          	lbu	a5,31(sp)
8000ad5e:	85be                	mv	a1,a5
8000ad60:	6785                	lui	a5,0x1
8000ad62:	60078513          	add	a0,a5,1536 # 1600 <__fw_size__+0x600>
8000ad66:	b3dfe0ef          	jal	800098a2 <WIZCHIP_WRITE>
   setSIMR(simr);
8000ad6a:	01e14783          	lbu	a5,30(sp)
8000ad6e:	85be                	mv	a1,a5
8000ad70:	6789                	lui	a5,0x2
8000ad72:	80078513          	add	a0,a5,-2048 # 1800 <__fw_size__+0x800>
8000ad76:	b2dfe0ef          	jal	800098a2 <WIZCHIP_WRITE>
}
8000ad7a:	0001                	nop
8000ad7c:	50b2                	lw	ra,44(sp)
8000ad7e:	6145                	add	sp,sp,48
8000ad80:	8082                	ret

Disassembly of section .text.wizphy_getphypmode:

8000ad82 <wizphy_getphypmode>:
{
8000ad82:	1101                	add	sp,sp,-32
8000ad84:	ce06                	sw	ra,28(sp)
   int8_t tmp = 0;
8000ad86:	000107a3          	sb	zero,15(sp)
      if((getPHYCFGR() & PHYCFGR_OPMDC_ALLA) == PHYCFGR_OPMDC_PDOWN)
8000ad8a:	678d                	lui	a5,0x3
8000ad8c:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000ad90:	956fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000ad94:	87aa                	mv	a5,a0
8000ad96:	0387f713          	and	a4,a5,56
8000ad9a:	03000793          	li	a5,48
8000ad9e:	00f71663          	bne	a4,a5,8000adaa <.L101>
         tmp = PHY_POWER_DOWN;
8000ada2:	4785                	li	a5,1
8000ada4:	00f107a3          	sb	a5,15(sp)
8000ada8:	a019                	j	8000adae <.L102>

8000adaa <.L101>:
         tmp = PHY_POWER_NORM;
8000adaa:	000107a3          	sb	zero,15(sp)

8000adae <.L102>:
   return tmp;
8000adae:	00f10783          	lb	a5,15(sp)
}
8000adb2:	853e                	mv	a0,a5
8000adb4:	40f2                	lw	ra,28(sp)
8000adb6:	6105                	add	sp,sp,32
8000adb8:	8082                	ret

Disassembly of section .text.wizphy_reset:

8000adba <wizphy_reset>:
{
8000adba:	1101                	add	sp,sp,-32
8000adbc:	ce06                	sw	ra,28(sp)
   uint8_t tmp = getPHYCFGR();
8000adbe:	678d                	lui	a5,0x3
8000adc0:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000adc4:	922fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000adc8:	87aa                	mv	a5,a0
8000adca:	00f107a3          	sb	a5,15(sp)
   tmp &= PHYCFGR_RST;
8000adce:	00f14783          	lbu	a5,15(sp)
8000add2:	07f7f793          	and	a5,a5,127
8000add6:	00f107a3          	sb	a5,15(sp)
   setPHYCFGR(tmp);
8000adda:	00f14783          	lbu	a5,15(sp)
8000adde:	85be                	mv	a1,a5
8000ade0:	678d                	lui	a5,0x3
8000ade2:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000ade6:	abdfe0ef          	jal	800098a2 <WIZCHIP_WRITE>
   tmp = getPHYCFGR();
8000adea:	678d                	lui	a5,0x3
8000adec:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000adf0:	8f6fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000adf4:	87aa                	mv	a5,a0
8000adf6:	00f107a3          	sb	a5,15(sp)
   tmp |= ~PHYCFGR_RST;
8000adfa:	00f14783          	lbu	a5,15(sp)
8000adfe:	f807e793          	or	a5,a5,-128
8000ae02:	00f107a3          	sb	a5,15(sp)
   setPHYCFGR(tmp);
8000ae06:	00f14783          	lbu	a5,15(sp)
8000ae0a:	85be                	mv	a1,a5
8000ae0c:	678d                	lui	a5,0x3
8000ae0e:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000ae12:	a91fe0ef          	jal	800098a2 <WIZCHIP_WRITE>
}
8000ae16:	0001                	nop
8000ae18:	40f2                	lw	ra,28(sp)
8000ae1a:	6105                	add	sp,sp,32
8000ae1c:	8082                	ret

Disassembly of section .text.wizphy_setphypmode:

8000ae1e <wizphy_setphypmode>:
{
8000ae1e:	7179                	add	sp,sp,-48
8000ae20:	d606                	sw	ra,44(sp)
8000ae22:	87aa                	mv	a5,a0
8000ae24:	00f107a3          	sb	a5,15(sp)
   uint8_t tmp = 0;
8000ae28:	00010fa3          	sb	zero,31(sp)
   tmp = getPHYCFGR();
8000ae2c:	678d                	lui	a5,0x3
8000ae2e:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000ae32:	8b4fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000ae36:	87aa                	mv	a5,a0
8000ae38:	00f10fa3          	sb	a5,31(sp)
   if((tmp & PHYCFGR_OPMD)== 0) return -1;
8000ae3c:	01f14783          	lbu	a5,31(sp)
8000ae40:	0407f793          	and	a5,a5,64
8000ae44:	e399                	bnez	a5,8000ae4a <.L123>
8000ae46:	57fd                	li	a5,-1
8000ae48:	a8b5                	j	8000aec4 <.L124>

8000ae4a <.L123>:
   tmp &= ~PHYCFGR_OPMDC_ALLA;         
8000ae4a:	01f14783          	lbu	a5,31(sp)
8000ae4e:	fc77f793          	and	a5,a5,-57
8000ae52:	00f10fa3          	sb	a5,31(sp)
   if( pmode == PHY_POWER_DOWN)
8000ae56:	00f14703          	lbu	a4,15(sp)
8000ae5a:	4785                	li	a5,1
8000ae5c:	00f71963          	bne	a4,a5,8000ae6e <.L125>
      tmp |= PHYCFGR_OPMDC_PDOWN;
8000ae60:	01f14783          	lbu	a5,31(sp)
8000ae64:	0307e793          	or	a5,a5,48
8000ae68:	00f10fa3          	sb	a5,31(sp)
8000ae6c:	a039                	j	8000ae7a <.L126>

8000ae6e <.L125>:
      tmp |= PHYCFGR_OPMDC_ALLA;
8000ae6e:	01f14783          	lbu	a5,31(sp)
8000ae72:	0387e793          	or	a5,a5,56
8000ae76:	00f10fa3          	sb	a5,31(sp)

8000ae7a <.L126>:
   setPHYCFGR(tmp);
8000ae7a:	01f14783          	lbu	a5,31(sp)
8000ae7e:	85be                	mv	a1,a5
8000ae80:	678d                	lui	a5,0x3
8000ae82:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000ae86:	a1dfe0ef          	jal	800098a2 <WIZCHIP_WRITE>
   wizphy_reset();
8000ae8a:	3f05                	jal	8000adba <wizphy_reset>
   tmp = getPHYCFGR();
8000ae8c:	678d                	lui	a5,0x3
8000ae8e:	e0078513          	add	a0,a5,-512 # 2e00 <__APB_SRAM_segment_size__+0xe00>
8000ae92:	854fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000ae96:	87aa                	mv	a5,a0
8000ae98:	00f10fa3          	sb	a5,31(sp)
   if( pmode == PHY_POWER_DOWN)
8000ae9c:	00f14703          	lbu	a4,15(sp)
8000aea0:	4785                	li	a5,1
8000aea2:	00f71963          	bne	a4,a5,8000aeb4 <.L127>
      if(tmp & PHYCFGR_OPMDC_PDOWN) return 0;
8000aea6:	01f14783          	lbu	a5,31(sp)
8000aeaa:	0307f793          	and	a5,a5,48
8000aeae:	cb91                	beqz	a5,8000aec2 <.L128>
8000aeb0:	4781                	li	a5,0
8000aeb2:	a809                	j	8000aec4 <.L124>

8000aeb4 <.L127>:
      if(tmp & PHYCFGR_OPMDC_ALLA) return 0;
8000aeb4:	01f14783          	lbu	a5,31(sp)
8000aeb8:	0387f793          	and	a5,a5,56
8000aebc:	c399                	beqz	a5,8000aec2 <.L128>
8000aebe:	4781                	li	a5,0
8000aec0:	a011                	j	8000aec4 <.L124>

8000aec2 <.L128>:
   return -1;
8000aec2:	57fd                	li	a5,-1

8000aec4 <.L124>:
}
8000aec4:	853e                	mv	a0,a5
8000aec6:	50b2                	lw	ra,44(sp)
8000aec8:	6145                	add	sp,sp,48
8000aeca:	8082                	ret

Disassembly of section .text.wizchip_getnetmode:

8000aecc <wizchip_getnetmode>:
{
8000aecc:	1141                	add	sp,sp,-16
8000aece:	c606                	sw	ra,12(sp)
   return (netmode_type) getMR();
8000aed0:	4501                	li	a0,0
8000aed2:	814fa0ef          	jal	80004ee6 <WIZCHIP_READ>
8000aed6:	87aa                	mv	a5,a0
}
8000aed8:	853e                	mv	a0,a5
8000aeda:	40b2                	lw	ra,12(sp)
8000aedc:	0141                	add	sp,sp,16
8000aede:	8082                	ret

Disassembly of section .text.wizchip_gettimeout:

8000aee0 <wizchip_gettimeout>:

void wizchip_gettimeout(wiz_NetTimeout* nettime)
{
8000aee0:	1101                	add	sp,sp,-32
8000aee2:	ce06                	sw	ra,28(sp)
8000aee4:	cc22                	sw	s0,24(sp)
8000aee6:	c62a                	sw	a0,12(sp)
   nettime->retry_cnt = getRCR();
8000aee8:	6789                	lui	a5,0x2
8000aeea:	b0078513          	add	a0,a5,-1280 # 1b00 <__fw_size__+0xb00>
8000aeee:	ff9f90ef          	jal	80004ee6 <WIZCHIP_READ>
8000aef2:	87aa                	mv	a5,a0
8000aef4:	873e                	mv	a4,a5
8000aef6:	47b2                	lw	a5,12(sp)
8000aef8:	00e78023          	sb	a4,0(a5)
   nettime->time_100us = getRTR();
8000aefc:	6789                	lui	a5,0x2
8000aefe:	90078513          	add	a0,a5,-1792 # 1900 <__fw_size__+0x900>
8000af02:	fe5f90ef          	jal	80004ee6 <WIZCHIP_READ>
8000af06:	87aa                	mv	a5,a0
8000af08:	07a2                	sll	a5,a5,0x8
8000af0a:	01079413          	sll	s0,a5,0x10
8000af0e:	8041                	srl	s0,s0,0x10
8000af10:	6789                	lui	a5,0x2
8000af12:	a0078513          	add	a0,a5,-1536 # 1a00 <__fw_size__+0xa00>
8000af16:	fd1f90ef          	jal	80004ee6 <WIZCHIP_READ>
8000af1a:	87aa                	mv	a5,a0
8000af1c:	97a2                	add	a5,a5,s0
8000af1e:	01079713          	sll	a4,a5,0x10
8000af22:	8341                	srl	a4,a4,0x10
8000af24:	47b2                	lw	a5,12(sp)
8000af26:	00e79123          	sh	a4,2(a5)
}
8000af2a:	0001                	nop
8000af2c:	40f2                	lw	ra,28(sp)
8000af2e:	4462                	lw	s0,24(sp)
8000af30:	6105                	add	sp,sp,32
8000af32:	8082                	ret

Disassembly of section .text.default_ip_assign:

8000af34 <default_ip_assign>:
{
8000af34:	1141                	add	sp,sp,-16
8000af36:	c606                	sw	ra,12(sp)
   setSIPR(DHCP_allocated_ip);
8000af38:	4611                	li	a2,4
8000af3a:	14018593          	add	a1,gp,320 # 1080940 <DHCP_allocated_ip>
8000af3e:	6785                	lui	a5,0x1
8000af40:	f0078513          	add	a0,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
8000af44:	84cfa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setSUBR(DHCP_allocated_sn);
8000af48:	4611                	li	a2,4
8000af4a:	13c18593          	add	a1,gp,316 # 108093c <DHCP_allocated_sn>
8000af4e:	50000513          	li	a0,1280
8000af52:	83efa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
   setGAR (DHCP_allocated_gw);
8000af56:	4611                	li	a2,4
8000af58:	14418593          	add	a1,gp,324 # 1080944 <DHCP_allocated_gw>
8000af5c:	10000513          	li	a0,256
8000af60:	830fa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
}
8000af64:	0001                	nop
8000af66:	40b2                	lw	ra,12(sp)
8000af68:	0141                	add	sp,sp,16
8000af6a:	8082                	ret

Disassembly of section .text.default_ip_update:

8000af6c <default_ip_update>:
{
8000af6c:	1141                	add	sp,sp,-16
8000af6e:	c606                	sw	ra,12(sp)
   setMR(MR_RST);
8000af70:	08000593          	li	a1,128
8000af74:	4501                	li	a0,0
8000af76:	92dfe0ef          	jal	800098a2 <WIZCHIP_WRITE>
   getMR(); // for delay
8000af7a:	4501                	li	a0,0
8000af7c:	f6bf90ef          	jal	80004ee6 <WIZCHIP_READ>
   default_ip_assign();
8000af80:	3f55                	jal	8000af34 <default_ip_assign>
   setSHAR(DHCP_CHADDR);
8000af82:	4619                	li	a2,6
8000af84:	11818593          	add	a1,gp,280 # 1080918 <DHCP_CHADDR>
8000af88:	6785                	lui	a5,0x1
8000af8a:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
8000af8e:	802fa0ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
}
8000af92:	0001                	nop
8000af94:	40b2                	lw	ra,12(sp)
8000af96:	0141                	add	sp,sp,16
8000af98:	8082                	ret

Disassembly of section .text.default_ip_conflict:

8000af9a <default_ip_conflict>:
{
8000af9a:	1141                	add	sp,sp,-16
8000af9c:	c606                	sw	ra,12(sp)
	setMR(MR_RST);
8000af9e:	08000593          	li	a1,128
8000afa2:	4501                	li	a0,0
8000afa4:	8fffe0ef          	jal	800098a2 <WIZCHIP_WRITE>
	getMR(); // for delay
8000afa8:	4501                	li	a0,0
8000afaa:	f3df90ef          	jal	80004ee6 <WIZCHIP_READ>
	setSHAR(DHCP_CHADDR);
8000afae:	4619                	li	a2,6
8000afb0:	11818593          	add	a1,gp,280 # 1080918 <DHCP_CHADDR>
8000afb4:	6785                	lui	a5,0x1
8000afb6:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
8000afba:	fd7f90ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
}
8000afbe:	0001                	nop
8000afc0:	40b2                	lw	ra,12(sp)
8000afc2:	0141                	add	sp,sp,16
8000afc4:	8082                	ret

Disassembly of section .text.reg_dhcp_cbfunc:

8000afc6 <reg_dhcp_cbfunc>:
{
8000afc6:	1141                	add	sp,sp,-16
8000afc8:	c62a                	sw	a0,12(sp)
8000afca:	c42e                	sw	a1,8(sp)
8000afcc:	c232                	sw	a2,4(sp)
   dhcp_ip_assign   = default_ip_assign;
8000afce:	8000b737          	lui	a4,0x8000b
8000afd2:	f3470713          	add	a4,a4,-204 # 8000af34 <default_ip_assign>
8000afd6:	18e1a223          	sw	a4,388(gp) # 1080984 <dhcp_ip_assign>
   dhcp_ip_update   = default_ip_update;
8000afda:	8000b737          	lui	a4,0x8000b
8000afde:	f6c70713          	add	a4,a4,-148 # 8000af6c <default_ip_update>
8000afe2:	16e1ae23          	sw	a4,380(gp) # 108097c <dhcp_ip_update>
   dhcp_ip_conflict = default_ip_conflict;
8000afe6:	8000b737          	lui	a4,0x8000b
8000afea:	f9a70713          	add	a4,a4,-102 # 8000af9a <default_ip_conflict>
8000afee:	18e1a023          	sw	a4,384(gp) # 1080980 <dhcp_ip_conflict>
   if(ip_assign)   dhcp_ip_assign = ip_assign;
8000aff2:	47b2                	lw	a5,12(sp)
8000aff4:	c781                	beqz	a5,8000affc <.L5>
8000aff6:	4732                	lw	a4,12(sp)
8000aff8:	18e1a223          	sw	a4,388(gp) # 1080984 <dhcp_ip_assign>

8000affc <.L5>:
   if(ip_update)   dhcp_ip_update = ip_update;
8000affc:	47a2                	lw	a5,8(sp)
8000affe:	c781                	beqz	a5,8000b006 <.L6>
8000b000:	4722                	lw	a4,8(sp)
8000b002:	16e1ae23          	sw	a4,380(gp) # 108097c <dhcp_ip_update>

8000b006 <.L6>:
   if(ip_conflict) dhcp_ip_conflict = ip_conflict;
8000b006:	4792                	lw	a5,4(sp)
8000b008:	c781                	beqz	a5,8000b010 <.L8>
8000b00a:	4712                	lw	a4,4(sp)
8000b00c:	18e1a023          	sw	a4,384(gp) # 1080980 <dhcp_ip_conflict>

8000b010 <.L8>:
}
8000b010:	0001                	nop
8000b012:	0141                	add	sp,sp,16
8000b014:	8082                	ret

Disassembly of section .text.send_DHCP_DISCOVER:

8000b016 <send_DHCP_DISCOVER>:
{
8000b016:	1101                	add	sp,sp,-32
8000b018:	ce06                	sw	ra,28(sp)
8000b01a:	cc22                	sw	s0,24(sp)
8000b01c:	ca26                	sw	s1,20(sp)
	uint16_t k = 0;
8000b01e:	00011623          	sh	zero,12(sp)
   makeDHCPMSG();
8000b022:	ce7fa0ef          	jal	80005d08 <makeDHCPMSG>
   DHCP_SIP[0]=0;
8000b026:	14018823          	sb	zero,336(gp) # 1080950 <DHCP_SIP>
   DHCP_SIP[1]=0;
8000b02a:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b02e:	000780a3          	sb	zero,1(a5)
   DHCP_SIP[2]=0;
8000b032:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b036:	00078123          	sb	zero,2(a5)
   DHCP_SIP[3]=0;
8000b03a:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b03e:	000781a3          	sb	zero,3(a5)
   DHCP_REAL_SIP[0]=0;
8000b042:	14018a23          	sb	zero,340(gp) # 1080954 <DHCP_REAL_SIP>
   DHCP_REAL_SIP[1]=0;
8000b046:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000b04a:	000780a3          	sb	zero,1(a5)
   DHCP_REAL_SIP[2]=0;
8000b04e:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000b052:	00078123          	sb	zero,2(a5)
   DHCP_REAL_SIP[3]=0;
8000b056:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000b05a:	000781a3          	sb	zero,3(a5)
   k = 4;     // because MAGIC_COOKIE already made by makeDHCPMSG()
8000b05e:	4791                	li	a5,4
8000b060:	00f11623          	sh	a5,12(sp)
	pDHCPMSG->OPT[k++] = dhcpMessageType;
8000b064:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b068:	00c15783          	lhu	a5,12(sp)
8000b06c:	00178693          	add	a3,a5,1
8000b070:	00d11623          	sh	a3,12(sp)
8000b074:	97ba                	add	a5,a5,a4
8000b076:	03500713          	li	a4,53
8000b07a:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x01;
8000b07e:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b082:	00c15783          	lhu	a5,12(sp)
8000b086:	00178693          	add	a3,a5,1
8000b08a:	00d11623          	sh	a3,12(sp)
8000b08e:	97ba                	add	a5,a5,a4
8000b090:	4705                	li	a4,1
8000b092:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_DISCOVER;
8000b096:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b09a:	00c15783          	lhu	a5,12(sp)
8000b09e:	00178693          	add	a3,a5,1
8000b0a2:	00d11623          	sh	a3,12(sp)
8000b0a6:	97ba                	add	a5,a5,a4
8000b0a8:	4705                	li	a4,1
8000b0aa:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpClientIdentifier;
8000b0ae:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b0b2:	00c15783          	lhu	a5,12(sp)
8000b0b6:	00178693          	add	a3,a5,1
8000b0ba:	00d11623          	sh	a3,12(sp)
8000b0be:	97ba                	add	a5,a5,a4
8000b0c0:	03d00713          	li	a4,61
8000b0c4:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x07;
8000b0c8:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b0cc:	00c15783          	lhu	a5,12(sp)
8000b0d0:	00178693          	add	a3,a5,1
8000b0d4:	00d11623          	sh	a3,12(sp)
8000b0d8:	97ba                	add	a5,a5,a4
8000b0da:	471d                	li	a4,7
8000b0dc:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x01;
8000b0e0:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b0e4:	00c15783          	lhu	a5,12(sp)
8000b0e8:	00178693          	add	a3,a5,1
8000b0ec:	00d11623          	sh	a3,12(sp)
8000b0f0:	97ba                	add	a5,a5,a4
8000b0f2:	4705                	li	a4,1
8000b0f4:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[0];
8000b0f8:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b0fc:	00c15783          	lhu	a5,12(sp)
8000b100:	00178713          	add	a4,a5,1
8000b104:	00e11623          	sh	a4,12(sp)
8000b108:	863e                	mv	a2,a5
8000b10a:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b10e:	0007c703          	lbu	a4,0(a5)
8000b112:	00c687b3          	add	a5,a3,a2
8000b116:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[1];
8000b11a:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b11e:	00c15783          	lhu	a5,12(sp)
8000b122:	00178713          	add	a4,a5,1
8000b126:	00e11623          	sh	a4,12(sp)
8000b12a:	863e                	mv	a2,a5
8000b12c:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b130:	0017c703          	lbu	a4,1(a5)
8000b134:	00c687b3          	add	a5,a3,a2
8000b138:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[2];
8000b13c:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b140:	00c15783          	lhu	a5,12(sp)
8000b144:	00178713          	add	a4,a5,1
8000b148:	00e11623          	sh	a4,12(sp)
8000b14c:	863e                	mv	a2,a5
8000b14e:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b152:	0027c703          	lbu	a4,2(a5)
8000b156:	00c687b3          	add	a5,a3,a2
8000b15a:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[3];
8000b15e:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b162:	00c15783          	lhu	a5,12(sp)
8000b166:	00178713          	add	a4,a5,1
8000b16a:	00e11623          	sh	a4,12(sp)
8000b16e:	863e                	mv	a2,a5
8000b170:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b174:	0037c703          	lbu	a4,3(a5)
8000b178:	00c687b3          	add	a5,a3,a2
8000b17c:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[4];
8000b180:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b184:	00c15783          	lhu	a5,12(sp)
8000b188:	00178713          	add	a4,a5,1
8000b18c:	00e11623          	sh	a4,12(sp)
8000b190:	863e                	mv	a2,a5
8000b192:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b196:	0047c703          	lbu	a4,4(a5)
8000b19a:	00c687b3          	add	a5,a3,a2
8000b19e:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[5];
8000b1a2:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b1a6:	00c15783          	lhu	a5,12(sp)
8000b1aa:	00178713          	add	a4,a5,1
8000b1ae:	00e11623          	sh	a4,12(sp)
8000b1b2:	863e                	mv	a2,a5
8000b1b4:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b1b8:	0057c703          	lbu	a4,5(a5)
8000b1bc:	00c687b3          	add	a5,a3,a2
8000b1c0:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = hostName;
8000b1c4:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b1c8:	00c15783          	lhu	a5,12(sp)
8000b1cc:	00178693          	add	a3,a5,1
8000b1d0:	00d11623          	sh	a3,12(sp)
8000b1d4:	97ba                	add	a5,a5,a4
8000b1d6:	4731                	li	a4,12
8000b1d8:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0;          // fill zero length of hostname 
8000b1dc:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b1e0:	00c15783          	lhu	a5,12(sp)
8000b1e4:	00178693          	add	a3,a5,1
8000b1e8:	00d11623          	sh	a3,12(sp)
8000b1ec:	97ba                	add	a5,a5,a4
8000b1ee:	0e078623          	sb	zero,236(a5)
	for(i = 0 ; HOST_NAME[i] != 0; i++)
8000b1f2:	00011723          	sh	zero,14(sp)
8000b1f6:	a815                	j	8000b22a <.L17>

8000b1f8 <.L18>:
   	pDHCPMSG->OPT[k++] = HOST_NAME[i];
8000b1f8:	00e15703          	lhu	a4,14(sp)
8000b1fc:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b200:	00c15783          	lhu	a5,12(sp)
8000b204:	00178613          	add	a2,a5,1
8000b208:	00c11623          	sh	a2,12(sp)
8000b20c:	863e                	mv	a2,a5
8000b20e:	16818793          	add	a5,gp,360 # 1080968 <HOST_NAME>
8000b212:	97ba                	add	a5,a5,a4
8000b214:	0007c703          	lbu	a4,0(a5)
8000b218:	00c687b3          	add	a5,a3,a2
8000b21c:	0ee78623          	sb	a4,236(a5)
	for(i = 0 ; HOST_NAME[i] != 0; i++)
8000b220:	00e15783          	lhu	a5,14(sp)
8000b224:	0785                	add	a5,a5,1
8000b226:	00f11723          	sh	a5,14(sp)

8000b22a <.L17>:
8000b22a:	00e15783          	lhu	a5,14(sp)
8000b22e:	16818713          	add	a4,gp,360 # 1080968 <HOST_NAME>
8000b232:	97ba                	add	a5,a5,a4
8000b234:	0007c783          	lbu	a5,0(a5)
8000b238:	f3e1                	bnez	a5,8000b1f8 <.L18>
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[3] >> 4); 
8000b23a:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b23e:	0037c783          	lbu	a5,3(a5)
8000b242:	8391                	srl	a5,a5,0x4
8000b244:	0ff7f693          	zext.b	a3,a5
8000b248:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
8000b24c:	00c15783          	lhu	a5,12(sp)
8000b250:	00178713          	add	a4,a5,1
8000b254:	00e11623          	sh	a4,12(sp)
8000b258:	84be                	mv	s1,a5
8000b25a:	8536                	mv	a0,a3
8000b25c:	527000ef          	jal	8000bf82 <NibbleToHex>
8000b260:	87aa                	mv	a5,a0
8000b262:	873e                	mv	a4,a5
8000b264:	009407b3          	add	a5,s0,s1
8000b268:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[3]);
8000b26c:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b270:	0037c683          	lbu	a3,3(a5)
8000b274:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
8000b278:	00c15783          	lhu	a5,12(sp)
8000b27c:	00178713          	add	a4,a5,1
8000b280:	00e11623          	sh	a4,12(sp)
8000b284:	84be                	mv	s1,a5
8000b286:	8536                	mv	a0,a3
8000b288:	4fb000ef          	jal	8000bf82 <NibbleToHex>
8000b28c:	87aa                	mv	a5,a0
8000b28e:	873e                	mv	a4,a5
8000b290:	009407b3          	add	a5,s0,s1
8000b294:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[4] >> 4); 
8000b298:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b29c:	0047c783          	lbu	a5,4(a5)
8000b2a0:	8391                	srl	a5,a5,0x4
8000b2a2:	0ff7f693          	zext.b	a3,a5
8000b2a6:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
8000b2aa:	00c15783          	lhu	a5,12(sp)
8000b2ae:	00178713          	add	a4,a5,1
8000b2b2:	00e11623          	sh	a4,12(sp)
8000b2b6:	84be                	mv	s1,a5
8000b2b8:	8536                	mv	a0,a3
8000b2ba:	4c9000ef          	jal	8000bf82 <NibbleToHex>
8000b2be:	87aa                	mv	a5,a0
8000b2c0:	873e                	mv	a4,a5
8000b2c2:	009407b3          	add	a5,s0,s1
8000b2c6:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[4]);
8000b2ca:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b2ce:	0047c683          	lbu	a3,4(a5)
8000b2d2:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
8000b2d6:	00c15783          	lhu	a5,12(sp)
8000b2da:	00178713          	add	a4,a5,1
8000b2de:	00e11623          	sh	a4,12(sp)
8000b2e2:	84be                	mv	s1,a5
8000b2e4:	8536                	mv	a0,a3
8000b2e6:	49d000ef          	jal	8000bf82 <NibbleToHex>
8000b2ea:	87aa                	mv	a5,a0
8000b2ec:	873e                	mv	a4,a5
8000b2ee:	009407b3          	add	a5,s0,s1
8000b2f2:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[5] >> 4); 
8000b2f6:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b2fa:	0057c783          	lbu	a5,5(a5)
8000b2fe:	8391                	srl	a5,a5,0x4
8000b300:	0ff7f693          	zext.b	a3,a5
8000b304:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
8000b308:	00c15783          	lhu	a5,12(sp)
8000b30c:	00178713          	add	a4,a5,1
8000b310:	00e11623          	sh	a4,12(sp)
8000b314:	84be                	mv	s1,a5
8000b316:	8536                	mv	a0,a3
8000b318:	46b000ef          	jal	8000bf82 <NibbleToHex>
8000b31c:	87aa                	mv	a5,a0
8000b31e:	873e                	mv	a4,a5
8000b320:	009407b3          	add	a5,s0,s1
8000b324:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = NibbleToHex(DHCP_CHADDR[5]);
8000b328:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b32c:	0057c683          	lbu	a3,5(a5)
8000b330:	1201a403          	lw	s0,288(gp) # 1080920 <pDHCPMSG>
8000b334:	00c15783          	lhu	a5,12(sp)
8000b338:	00178713          	add	a4,a5,1
8000b33c:	00e11623          	sh	a4,12(sp)
8000b340:	84be                	mv	s1,a5
8000b342:	8536                	mv	a0,a3
8000b344:	43f000ef          	jal	8000bf82 <NibbleToHex>
8000b348:	87aa                	mv	a5,a0
8000b34a:	873e                	mv	a4,a5
8000b34c:	009407b3          	add	a5,s0,s1
8000b350:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k - (i+6+1)] = i+6; // length of hostname
8000b354:	00e15783          	lhu	a5,14(sp)
8000b358:	0ff7f713          	zext.b	a4,a5
8000b35c:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b360:	00c15603          	lhu	a2,12(sp)
8000b364:	00e15783          	lhu	a5,14(sp)
8000b368:	079d                	add	a5,a5,7
8000b36a:	40f607b3          	sub	a5,a2,a5
8000b36e:	0719                	add	a4,a4,6
8000b370:	0ff77713          	zext.b	a4,a4
8000b374:	97b6                	add	a5,a5,a3
8000b376:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpParamRequest;
8000b37a:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b37e:	00c15783          	lhu	a5,12(sp)
8000b382:	00178693          	add	a3,a5,1
8000b386:	00d11623          	sh	a3,12(sp)
8000b38a:	97ba                	add	a5,a5,a4
8000b38c:	03700713          	li	a4,55
8000b390:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x06;	// length of request
8000b394:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b398:	00c15783          	lhu	a5,12(sp)
8000b39c:	00178693          	add	a3,a5,1
8000b3a0:	00d11623          	sh	a3,12(sp)
8000b3a4:	97ba                	add	a5,a5,a4
8000b3a6:	4719                	li	a4,6
8000b3a8:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = subnetMask;
8000b3ac:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b3b0:	00c15783          	lhu	a5,12(sp)
8000b3b4:	00178693          	add	a3,a5,1
8000b3b8:	00d11623          	sh	a3,12(sp)
8000b3bc:	97ba                	add	a5,a5,a4
8000b3be:	4705                	li	a4,1
8000b3c0:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = routersOnSubnet;
8000b3c4:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b3c8:	00c15783          	lhu	a5,12(sp)
8000b3cc:	00178693          	add	a3,a5,1
8000b3d0:	00d11623          	sh	a3,12(sp)
8000b3d4:	97ba                	add	a5,a5,a4
8000b3d6:	470d                	li	a4,3
8000b3d8:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dns;
8000b3dc:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b3e0:	00c15783          	lhu	a5,12(sp)
8000b3e4:	00178693          	add	a3,a5,1
8000b3e8:	00d11623          	sh	a3,12(sp)
8000b3ec:	97ba                	add	a5,a5,a4
8000b3ee:	4719                	li	a4,6
8000b3f0:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = domainName;
8000b3f4:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b3f8:	00c15783          	lhu	a5,12(sp)
8000b3fc:	00178693          	add	a3,a5,1
8000b400:	00d11623          	sh	a3,12(sp)
8000b404:	97ba                	add	a5,a5,a4
8000b406:	473d                	li	a4,15
8000b408:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpT1value;
8000b40c:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b410:	00c15783          	lhu	a5,12(sp)
8000b414:	00178693          	add	a3,a5,1
8000b418:	00d11623          	sh	a3,12(sp)
8000b41c:	97ba                	add	a5,a5,a4
8000b41e:	03a00713          	li	a4,58
8000b422:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpT2value;
8000b426:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b42a:	00c15783          	lhu	a5,12(sp)
8000b42e:	00178693          	add	a3,a5,1
8000b432:	00d11623          	sh	a3,12(sp)
8000b436:	97ba                	add	a5,a5,a4
8000b438:	03b00713          	li	a4,59
8000b43c:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = endOption;
8000b440:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b444:	00c15783          	lhu	a5,12(sp)
8000b448:	00178693          	add	a3,a5,1
8000b44c:	00d11623          	sh	a3,12(sp)
8000b450:	97ba                	add	a5,a5,a4
8000b452:	577d                	li	a4,-1
8000b454:	0ee78623          	sb	a4,236(a5)
	for (i = k; i < OPT_SIZE; i++) pDHCPMSG->OPT[i] = 0;
8000b458:	00c15783          	lhu	a5,12(sp)
8000b45c:	00f11723          	sh	a5,14(sp)
8000b460:	a829                	j	8000b47a <.L19>

8000b462 <.L20>:
8000b462:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b466:	00e15783          	lhu	a5,14(sp)
8000b46a:	97ba                	add	a5,a5,a4
8000b46c:	0e078623          	sb	zero,236(a5)
8000b470:	00e15783          	lhu	a5,14(sp)
8000b474:	0785                	add	a5,a5,1
8000b476:	00f11723          	sh	a5,14(sp)

8000b47a <.L19>:
8000b47a:	00e15703          	lhu	a4,14(sp)
8000b47e:	13700793          	li	a5,311
8000b482:	fee7f0e3          	bgeu	a5,a4,8000b462 <.L20>
	ip[0] = 255;
8000b486:	57fd                	li	a5,-1
8000b488:	00f10423          	sb	a5,8(sp)
	ip[1] = 255;
8000b48c:	57fd                	li	a5,-1
8000b48e:	00f104a3          	sb	a5,9(sp)
	ip[2] = 255;
8000b492:	57fd                	li	a5,-1
8000b494:	00f10523          	sb	a5,10(sp)
	ip[3] = 255;
8000b498:	57fd                	li	a5,-1
8000b49a:	00f105a3          	sb	a5,11(sp)
	printf("> Send DHCP_DISCOVER\r\n");
8000b49e:	800047b7          	lui	a5,0x80004
8000b4a2:	68478513          	add	a0,a5,1668 # 80004684 <.LC0>
8000b4a6:	86bfd0ef          	jal	80008d10 <printf>
	sendto(DHCP_SOCKET, (uint8_t *)pDHCPMSG, RIP_MSG_SIZE, ip, DHCP_SERVER_PORT);
8000b4aa:	1651c503          	lbu	a0,357(gp) # 1080965 <DHCP_SOCKET>
8000b4ae:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b4b2:	0034                	add	a3,sp,8
8000b4b4:	04300713          	li	a4,67
8000b4b8:	22400613          	li	a2,548
8000b4bc:	85be                	mv	a1,a5
8000b4be:	d65fe0ef          	jal	8000a222 <sendto>
}
8000b4c2:	0001                	nop
8000b4c4:	40f2                	lw	ra,28(sp)
8000b4c6:	4462                	lw	s0,24(sp)
8000b4c8:	44d2                	lw	s1,20(sp)
8000b4ca:	6105                	add	sp,sp,32
8000b4cc:	8082                	ret

Disassembly of section .text.send_DHCP_DECLINE:

8000b4ce <send_DHCP_DECLINE>:
{
8000b4ce:	1101                	add	sp,sp,-32
8000b4d0:	ce06                	sw	ra,28(sp)
	uint16_t k = 0;
8000b4d2:	00011523          	sh	zero,10(sp)
	makeDHCPMSG();
8000b4d6:	833fa0ef          	jal	80005d08 <makeDHCPMSG>
   k = 4;      // because MAGIC_COOKIE already made by makeDHCPMSG()
8000b4da:	4791                	li	a5,4
8000b4dc:	00f11523          	sh	a5,10(sp)
	*((uint8_t*)(&pDHCPMSG->flags))   = ((DHCP_FLAGSUNICAST & 0xFF00)>> 8);
8000b4e0:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b4e4:	07a9                	add	a5,a5,10
8000b4e6:	00078023          	sb	zero,0(a5)
	*((uint8_t*)(&pDHCPMSG->flags)+1) = (DHCP_FLAGSUNICAST & 0x00FF);
8000b4ea:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b4ee:	07a9                	add	a5,a5,10
8000b4f0:	0785                	add	a5,a5,1
8000b4f2:	00078023          	sb	zero,0(a5)
	pDHCPMSG->OPT[k++] = dhcpMessageType;
8000b4f6:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b4fa:	00a15783          	lhu	a5,10(sp)
8000b4fe:	00178693          	add	a3,a5,1
8000b502:	00d11523          	sh	a3,10(sp)
8000b506:	97ba                	add	a5,a5,a4
8000b508:	03500713          	li	a4,53
8000b50c:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x01;
8000b510:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b514:	00a15783          	lhu	a5,10(sp)
8000b518:	00178693          	add	a3,a5,1
8000b51c:	00d11523          	sh	a3,10(sp)
8000b520:	97ba                	add	a5,a5,a4
8000b522:	4705                	li	a4,1
8000b524:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_DECLINE;
8000b528:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b52c:	00a15783          	lhu	a5,10(sp)
8000b530:	00178693          	add	a3,a5,1
8000b534:	00d11523          	sh	a3,10(sp)
8000b538:	97ba                	add	a5,a5,a4
8000b53a:	4711                	li	a4,4
8000b53c:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpClientIdentifier;
8000b540:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b544:	00a15783          	lhu	a5,10(sp)
8000b548:	00178693          	add	a3,a5,1
8000b54c:	00d11523          	sh	a3,10(sp)
8000b550:	97ba                	add	a5,a5,a4
8000b552:	03d00713          	li	a4,61
8000b556:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x07;
8000b55a:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b55e:	00a15783          	lhu	a5,10(sp)
8000b562:	00178693          	add	a3,a5,1
8000b566:	00d11523          	sh	a3,10(sp)
8000b56a:	97ba                	add	a5,a5,a4
8000b56c:	471d                	li	a4,7
8000b56e:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x01;
8000b572:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b576:	00a15783          	lhu	a5,10(sp)
8000b57a:	00178693          	add	a3,a5,1
8000b57e:	00d11523          	sh	a3,10(sp)
8000b582:	97ba                	add	a5,a5,a4
8000b584:	4705                	li	a4,1
8000b586:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[0];
8000b58a:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b58e:	00a15783          	lhu	a5,10(sp)
8000b592:	00178713          	add	a4,a5,1
8000b596:	00e11523          	sh	a4,10(sp)
8000b59a:	863e                	mv	a2,a5
8000b59c:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b5a0:	0007c703          	lbu	a4,0(a5)
8000b5a4:	00c687b3          	add	a5,a3,a2
8000b5a8:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[1];
8000b5ac:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b5b0:	00a15783          	lhu	a5,10(sp)
8000b5b4:	00178713          	add	a4,a5,1
8000b5b8:	00e11523          	sh	a4,10(sp)
8000b5bc:	863e                	mv	a2,a5
8000b5be:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b5c2:	0017c703          	lbu	a4,1(a5)
8000b5c6:	00c687b3          	add	a5,a3,a2
8000b5ca:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[2];
8000b5ce:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b5d2:	00a15783          	lhu	a5,10(sp)
8000b5d6:	00178713          	add	a4,a5,1
8000b5da:	00e11523          	sh	a4,10(sp)
8000b5de:	863e                	mv	a2,a5
8000b5e0:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b5e4:	0027c703          	lbu	a4,2(a5)
8000b5e8:	00c687b3          	add	a5,a3,a2
8000b5ec:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[3];
8000b5f0:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b5f4:	00a15783          	lhu	a5,10(sp)
8000b5f8:	00178713          	add	a4,a5,1
8000b5fc:	00e11523          	sh	a4,10(sp)
8000b600:	863e                	mv	a2,a5
8000b602:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b606:	0037c703          	lbu	a4,3(a5)
8000b60a:	00c687b3          	add	a5,a3,a2
8000b60e:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[4];
8000b612:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b616:	00a15783          	lhu	a5,10(sp)
8000b61a:	00178713          	add	a4,a5,1
8000b61e:	00e11523          	sh	a4,10(sp)
8000b622:	863e                	mv	a2,a5
8000b624:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b628:	0047c703          	lbu	a4,4(a5)
8000b62c:	00c687b3          	add	a5,a3,a2
8000b630:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_CHADDR[5];
8000b634:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b638:	00a15783          	lhu	a5,10(sp)
8000b63c:	00178713          	add	a4,a5,1
8000b640:	00e11523          	sh	a4,10(sp)
8000b644:	863e                	mv	a2,a5
8000b646:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b64a:	0057c703          	lbu	a4,5(a5)
8000b64e:	00c687b3          	add	a5,a3,a2
8000b652:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpRequestedIPaddr;
8000b656:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b65a:	00a15783          	lhu	a5,10(sp)
8000b65e:	00178693          	add	a3,a5,1
8000b662:	00d11523          	sh	a3,10(sp)
8000b666:	97ba                	add	a5,a5,a4
8000b668:	03200713          	li	a4,50
8000b66c:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x04;
8000b670:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b674:	00a15783          	lhu	a5,10(sp)
8000b678:	00178693          	add	a3,a5,1
8000b67c:	00d11523          	sh	a3,10(sp)
8000b680:	97ba                	add	a5,a5,a4
8000b682:	4711                	li	a4,4
8000b684:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_allocated_ip[0];
8000b688:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b68c:	00a15783          	lhu	a5,10(sp)
8000b690:	00178713          	add	a4,a5,1
8000b694:	00e11523          	sh	a4,10(sp)
8000b698:	863e                	mv	a2,a5
8000b69a:	1401c703          	lbu	a4,320(gp) # 1080940 <DHCP_allocated_ip>
8000b69e:	00c687b3          	add	a5,a3,a2
8000b6a2:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_allocated_ip[1];
8000b6a6:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b6aa:	00a15783          	lhu	a5,10(sp)
8000b6ae:	00178713          	add	a4,a5,1
8000b6b2:	00e11523          	sh	a4,10(sp)
8000b6b6:	863e                	mv	a2,a5
8000b6b8:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
8000b6bc:	0017c703          	lbu	a4,1(a5)
8000b6c0:	00c687b3          	add	a5,a3,a2
8000b6c4:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_allocated_ip[2];
8000b6c8:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b6cc:	00a15783          	lhu	a5,10(sp)
8000b6d0:	00178713          	add	a4,a5,1
8000b6d4:	00e11523          	sh	a4,10(sp)
8000b6d8:	863e                	mv	a2,a5
8000b6da:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
8000b6de:	0027c703          	lbu	a4,2(a5)
8000b6e2:	00c687b3          	add	a5,a3,a2
8000b6e6:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_allocated_ip[3];
8000b6ea:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b6ee:	00a15783          	lhu	a5,10(sp)
8000b6f2:	00178713          	add	a4,a5,1
8000b6f6:	00e11523          	sh	a4,10(sp)
8000b6fa:	863e                	mv	a2,a5
8000b6fc:	14018793          	add	a5,gp,320 # 1080940 <DHCP_allocated_ip>
8000b700:	0037c703          	lbu	a4,3(a5)
8000b704:	00c687b3          	add	a5,a3,a2
8000b708:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = dhcpServerIdentifier;
8000b70c:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b710:	00a15783          	lhu	a5,10(sp)
8000b714:	00178693          	add	a3,a5,1
8000b718:	00d11523          	sh	a3,10(sp)
8000b71c:	97ba                	add	a5,a5,a4
8000b71e:	03600713          	li	a4,54
8000b722:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = 0x04;
8000b726:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b72a:	00a15783          	lhu	a5,10(sp)
8000b72e:	00178693          	add	a3,a5,1
8000b732:	00d11523          	sh	a3,10(sp)
8000b736:	97ba                	add	a5,a5,a4
8000b738:	4711                	li	a4,4
8000b73a:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_SIP[0];
8000b73e:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b742:	00a15783          	lhu	a5,10(sp)
8000b746:	00178713          	add	a4,a5,1
8000b74a:	00e11523          	sh	a4,10(sp)
8000b74e:	863e                	mv	a2,a5
8000b750:	1501c703          	lbu	a4,336(gp) # 1080950 <DHCP_SIP>
8000b754:	00c687b3          	add	a5,a3,a2
8000b758:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_SIP[1];
8000b75c:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b760:	00a15783          	lhu	a5,10(sp)
8000b764:	00178713          	add	a4,a5,1
8000b768:	00e11523          	sh	a4,10(sp)
8000b76c:	863e                	mv	a2,a5
8000b76e:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b772:	0017c703          	lbu	a4,1(a5)
8000b776:	00c687b3          	add	a5,a3,a2
8000b77a:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_SIP[2];
8000b77e:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b782:	00a15783          	lhu	a5,10(sp)
8000b786:	00178713          	add	a4,a5,1
8000b78a:	00e11523          	sh	a4,10(sp)
8000b78e:	863e                	mv	a2,a5
8000b790:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b794:	0027c703          	lbu	a4,2(a5)
8000b798:	00c687b3          	add	a5,a3,a2
8000b79c:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = DHCP_SIP[3];
8000b7a0:	1201a683          	lw	a3,288(gp) # 1080920 <pDHCPMSG>
8000b7a4:	00a15783          	lhu	a5,10(sp)
8000b7a8:	00178713          	add	a4,a5,1
8000b7ac:	00e11523          	sh	a4,10(sp)
8000b7b0:	863e                	mv	a2,a5
8000b7b2:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b7b6:	0037c703          	lbu	a4,3(a5)
8000b7ba:	00c687b3          	add	a5,a3,a2
8000b7be:	0ee78623          	sb	a4,236(a5)
	pDHCPMSG->OPT[k++] = endOption;
8000b7c2:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b7c6:	00a15783          	lhu	a5,10(sp)
8000b7ca:	00178693          	add	a3,a5,1
8000b7ce:	00d11523          	sh	a3,10(sp)
8000b7d2:	97ba                	add	a5,a5,a4
8000b7d4:	577d                	li	a4,-1
8000b7d6:	0ee78623          	sb	a4,236(a5)
	for (i = k; i < OPT_SIZE; i++) pDHCPMSG->OPT[i] = 0;
8000b7da:	00a15783          	lhu	a5,10(sp)
8000b7de:	c63e                	sw	a5,12(sp)
8000b7e0:	a811                	j	8000b7f4 <.L31>

8000b7e2 <.L32>:
8000b7e2:	1201a703          	lw	a4,288(gp) # 1080920 <pDHCPMSG>
8000b7e6:	47b2                	lw	a5,12(sp)
8000b7e8:	97ba                	add	a5,a5,a4
8000b7ea:	0e078623          	sb	zero,236(a5)
8000b7ee:	47b2                	lw	a5,12(sp)
8000b7f0:	0785                	add	a5,a5,1
8000b7f2:	c63e                	sw	a5,12(sp)

8000b7f4 <.L31>:
8000b7f4:	4732                	lw	a4,12(sp)
8000b7f6:	13700793          	li	a5,311
8000b7fa:	fee7d4e3          	bge	a5,a4,8000b7e2 <.L32>
	ip[0] = 0xFF;
8000b7fe:	57fd                	li	a5,-1
8000b800:	00f10223          	sb	a5,4(sp)
	ip[1] = 0xFF;
8000b804:	57fd                	li	a5,-1
8000b806:	00f102a3          	sb	a5,5(sp)
	ip[2] = 0xFF;
8000b80a:	57fd                	li	a5,-1
8000b80c:	00f10323          	sb	a5,6(sp)
	ip[3] = 0xFF;
8000b810:	57fd                	li	a5,-1
8000b812:	00f103a3          	sb	a5,7(sp)
	printf("\r\n> Send DHCP_DECLINE\r\n");
8000b816:	800047b7          	lui	a5,0x80004
8000b81a:	6b478513          	add	a0,a5,1716 # 800046b4 <.LC2>
8000b81e:	cf2fd0ef          	jal	80008d10 <printf>
	sendto(DHCP_SOCKET, (uint8_t *)pDHCPMSG, RIP_MSG_SIZE, ip, DHCP_SERVER_PORT);
8000b822:	1651c503          	lbu	a0,357(gp) # 1080965 <DHCP_SOCKET>
8000b826:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b82a:	0054                	add	a3,sp,4
8000b82c:	04300713          	li	a4,67
8000b830:	22400613          	li	a2,548
8000b834:	85be                	mv	a1,a5
8000b836:	9edfe0ef          	jal	8000a222 <sendto>
}
8000b83a:	0001                	nop
8000b83c:	40f2                	lw	ra,28(sp)
8000b83e:	6105                	add	sp,sp,32
8000b840:	8082                	ret

Disassembly of section .text.parseDHCPMSG:

8000b842 <parseDHCPMSG>:
{
8000b842:	7179                	add	sp,sp,-48
8000b844:	d606                	sw	ra,44(sp)
	uint8_t type = 0;
8000b846:	00010da3          	sb	zero,27(sp)
   if((len = getSn_RX_RSR(DHCP_SOCKET)) > 0)
8000b84a:	1651c783          	lbu	a5,357(gp) # 1080965 <DHCP_SOCKET>
8000b84e:	853e                	mv	a0,a5
8000b850:	acefe0ef          	jal	80009b1e <getSn_RX_RSR>
8000b854:	87aa                	mv	a5,a0
8000b856:	00f11c23          	sh	a5,24(sp)
8000b85a:	01815783          	lhu	a5,24(sp)
8000b85e:	c3a5                	beqz	a5,8000b8be <.L34>
   	len = recvfrom(DHCP_SOCKET, (uint8_t *)pDHCPMSG, len, svr_addr, &svr_port);
8000b860:	1651c503          	lbu	a0,357(gp) # 1080965 <DHCP_SOCKET>
8000b864:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b868:	00a10713          	add	a4,sp,10
8000b86c:	0074                	add	a3,sp,12
8000b86e:	01815603          	lhu	a2,24(sp)
8000b872:	85be                	mv	a1,a5
8000b874:	c7ffe0ef          	jal	8000a4f2 <recvfrom>
8000b878:	87aa                	mv	a5,a0
8000b87a:	00f11c23          	sh	a5,24(sp)
      printf("DHCP message : %d.%d.%d.%d(%d) %d received. \r\n",svr_addr[0],svr_addr[1],svr_addr[2], svr_addr[3],svr_port, len);
8000b87e:	00c14783          	lbu	a5,12(sp)
8000b882:	85be                	mv	a1,a5
8000b884:	00d14783          	lbu	a5,13(sp)
8000b888:	863e                	mv	a2,a5
8000b88a:	00e14783          	lbu	a5,14(sp)
8000b88e:	86be                	mv	a3,a5
8000b890:	00f14783          	lbu	a5,15(sp)
8000b894:	873e                	mv	a4,a5
8000b896:	00a15783          	lhu	a5,10(sp)
8000b89a:	853e                	mv	a0,a5
8000b89c:	01815783          	lhu	a5,24(sp)
8000b8a0:	883e                	mv	a6,a5
8000b8a2:	87aa                	mv	a5,a0
8000b8a4:	80004537          	lui	a0,0x80004
8000b8a8:	6cc50513          	add	a0,a0,1740 # 800046cc <.LC3>
8000b8ac:	c64fd0ef          	jal	80008d10 <printf>
	if (svr_port == DHCP_SERVER_PORT) {
8000b8b0:	00a15703          	lhu	a4,10(sp)
8000b8b4:	04300793          	li	a5,67
8000b8b8:	42f71763          	bne	a4,a5,8000bce6 <.L37>
8000b8bc:	a019                	j	8000b8c2 <.L57>

8000b8be <.L34>:
   else return 0;
8000b8be:	4781                	li	a5,0
8000b8c0:	a12d                	j	8000bcea <.L56>

8000b8c2 <.L57>:
		if ( (pDHCPMSG->chaddr[0] != DHCP_CHADDR[0]) || (pDHCPMSG->chaddr[1] != DHCP_CHADDR[1]) ||
8000b8c2:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b8c6:	01c7c703          	lbu	a4,28(a5)
8000b8ca:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b8ce:	0007c783          	lbu	a5,0(a5)
8000b8d2:	06f71463          	bne	a4,a5,8000b93a <.L38>
8000b8d6:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b8da:	01d7c703          	lbu	a4,29(a5)
8000b8de:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b8e2:	0017c783          	lbu	a5,1(a5)
8000b8e6:	04f71a63          	bne	a4,a5,8000b93a <.L38>
		     (pDHCPMSG->chaddr[2] != DHCP_CHADDR[2]) || (pDHCPMSG->chaddr[3] != DHCP_CHADDR[3]) ||
8000b8ea:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b8ee:	01e7c703          	lbu	a4,30(a5)
8000b8f2:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b8f6:	0027c783          	lbu	a5,2(a5)
		if ( (pDHCPMSG->chaddr[0] != DHCP_CHADDR[0]) || (pDHCPMSG->chaddr[1] != DHCP_CHADDR[1]) ||
8000b8fa:	04f71063          	bne	a4,a5,8000b93a <.L38>
		     (pDHCPMSG->chaddr[2] != DHCP_CHADDR[2]) || (pDHCPMSG->chaddr[3] != DHCP_CHADDR[3]) ||
8000b8fe:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b902:	01f7c703          	lbu	a4,31(a5)
8000b906:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b90a:	0037c783          	lbu	a5,3(a5)
8000b90e:	02f71663          	bne	a4,a5,8000b93a <.L38>
		     (pDHCPMSG->chaddr[4] != DHCP_CHADDR[4]) || (pDHCPMSG->chaddr[5] != DHCP_CHADDR[5])   )
8000b912:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b916:	0207c703          	lbu	a4,32(a5)
8000b91a:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b91e:	0047c783          	lbu	a5,4(a5)
		     (pDHCPMSG->chaddr[2] != DHCP_CHADDR[2]) || (pDHCPMSG->chaddr[3] != DHCP_CHADDR[3]) ||
8000b922:	00f71c63          	bne	a4,a5,8000b93a <.L38>
		     (pDHCPMSG->chaddr[4] != DHCP_CHADDR[4]) || (pDHCPMSG->chaddr[5] != DHCP_CHADDR[5])   )
8000b926:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b92a:	0217c703          	lbu	a4,33(a5)
8000b92e:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000b932:	0057c783          	lbu	a5,5(a5)
8000b936:	00f70a63          	beq	a4,a5,8000b94a <.L39>

8000b93a <.L38>:
            printf("No My DHCP Message. This message is ignored.\r\n");
8000b93a:	800047b7          	lui	a5,0x80004
8000b93e:	6fc78513          	add	a0,a5,1788 # 800046fc <.LC4>
8000b942:	bcefd0ef          	jal	80008d10 <printf>
         return 0;
8000b946:	4781                	li	a5,0
8000b948:	a64d                	j	8000bcea <.L56>

8000b94a <.L39>:
        if((DHCP_SIP[0]!=0) || (DHCP_SIP[1]!=0) || (DHCP_SIP[2]!=0) || (DHCP_SIP[3]!=0)){
8000b94a:	1501c783          	lbu	a5,336(gp) # 1080950 <DHCP_SIP>
8000b94e:	e385                	bnez	a5,8000b96e <.L40>
8000b950:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b954:	0017c783          	lbu	a5,1(a5)
8000b958:	eb99                	bnez	a5,8000b96e <.L40>
8000b95a:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b95e:	0027c783          	lbu	a5,2(a5)
8000b962:	e791                	bnez	a5,8000b96e <.L40>
8000b964:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b968:	0037c783          	lbu	a5,3(a5)
8000b96c:	c7c9                	beqz	a5,8000b9f6 <.L41>

8000b96e <.L40>:
            if( ((svr_addr[0]!=DHCP_SIP[0])|| (svr_addr[1]!=DHCP_SIP[1])|| (svr_addr[2]!=DHCP_SIP[2])|| (svr_addr[3]!=DHCP_SIP[3])) &&
8000b96e:	00c14703          	lbu	a4,12(sp)
8000b972:	1501c783          	lbu	a5,336(gp) # 1080950 <DHCP_SIP>
8000b976:	02f71a63          	bne	a4,a5,8000b9aa <.L42>
8000b97a:	00d14703          	lbu	a4,13(sp)
8000b97e:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b982:	0017c783          	lbu	a5,1(a5)
8000b986:	02f71263          	bne	a4,a5,8000b9aa <.L42>
8000b98a:	00e14703          	lbu	a4,14(sp)
8000b98e:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b992:	0027c783          	lbu	a5,2(a5)
8000b996:	00f71a63          	bne	a4,a5,8000b9aa <.L42>
8000b99a:	00f14703          	lbu	a4,15(sp)
8000b99e:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000b9a2:	0037c783          	lbu	a5,3(a5)
8000b9a6:	04f70863          	beq	a4,a5,8000b9f6 <.L41>

8000b9aa <.L42>:
                ((svr_addr[0]!=DHCP_REAL_SIP[0])|| (svr_addr[1]!=DHCP_REAL_SIP[1])|| (svr_addr[2]!=DHCP_REAL_SIP[2])|| (svr_addr[3]!=DHCP_REAL_SIP[3]))  )
8000b9aa:	00c14703          	lbu	a4,12(sp)
8000b9ae:	1541c783          	lbu	a5,340(gp) # 1080954 <DHCP_REAL_SIP>
            if( ((svr_addr[0]!=DHCP_SIP[0])|| (svr_addr[1]!=DHCP_SIP[1])|| (svr_addr[2]!=DHCP_SIP[2])|| (svr_addr[3]!=DHCP_SIP[3])) &&
8000b9b2:	02f71a63          	bne	a4,a5,8000b9e6 <.L43>
                ((svr_addr[0]!=DHCP_REAL_SIP[0])|| (svr_addr[1]!=DHCP_REAL_SIP[1])|| (svr_addr[2]!=DHCP_REAL_SIP[2])|| (svr_addr[3]!=DHCP_REAL_SIP[3]))  )
8000b9b6:	00d14703          	lbu	a4,13(sp)
8000b9ba:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000b9be:	0017c783          	lbu	a5,1(a5)
8000b9c2:	02f71263          	bne	a4,a5,8000b9e6 <.L43>
8000b9c6:	00e14703          	lbu	a4,14(sp)
8000b9ca:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000b9ce:	0027c783          	lbu	a5,2(a5)
8000b9d2:	00f71a63          	bne	a4,a5,8000b9e6 <.L43>
8000b9d6:	00f14703          	lbu	a4,15(sp)
8000b9da:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000b9de:	0037c783          	lbu	a5,3(a5)
8000b9e2:	00f70a63          	beq	a4,a5,8000b9f6 <.L41>

8000b9e6 <.L43>:
                printf("Another DHCP sever send a response message. This is ignored.\r\n");
8000b9e6:	800047b7          	lui	a5,0x80004
8000b9ea:	72c78513          	add	a0,a5,1836 # 8000472c <.LC5>
8000b9ee:	b22fd0ef          	jal	80008d10 <printf>
                return 0;
8000b9f2:	4781                	li	a5,0
8000b9f4:	acdd                	j	8000bcea <.L56>

8000b9f6 <.L41>:
		p = (uint8_t *)(&pDHCPMSG->op);
8000b9f6:	1201a783          	lw	a5,288(gp) # 1080920 <pDHCPMSG>
8000b9fa:	ce3e                	sw	a5,28(sp)
		p = p + 240;      // 240 = sizeof(RIP_MSG) + MAGIC_COOKIE size in RIP_MSG.opt - sizeof(RIP_MSG.opt)
8000b9fc:	47f2                	lw	a5,28(sp)
8000b9fe:	0f078793          	add	a5,a5,240
8000ba02:	ce3e                	sw	a5,28(sp)
		e = p + (len - 240);
8000ba04:	01815783          	lhu	a5,24(sp)
8000ba08:	f1078793          	add	a5,a5,-240
8000ba0c:	4772                	lw	a4,28(sp)
8000ba0e:	97ba                	add	a5,a5,a4
8000ba10:	ca3e                	sw	a5,20(sp)
		while ( p < e ) {
8000ba12:	a4f1                	j	8000bcde <.L44>

8000ba14 <.L55>:
			switch ( *p ) {
8000ba14:	47f2                	lw	a5,28(sp)
8000ba16:	0007c783          	lbu	a5,0(a5)
8000ba1a:	03600713          	li	a4,54
8000ba1e:	02f74163          	blt	a4,a5,8000ba40 <.L45>
8000ba22:	2807cd63          	bltz	a5,8000bcbc <.L46>
8000ba26:	03600713          	li	a4,54
8000ba2a:	28f76963          	bltu	a4,a5,8000bcbc <.L46>
8000ba2e:	00279713          	sll	a4,a5,0x2
8000ba32:	800037b7          	lui	a5,0x80003
8000ba36:	22478793          	add	a5,a5,548 # 80003224 <.L48>
8000ba3a:	97ba                	add	a5,a5,a4
8000ba3c:	439c                	lw	a5,0(a5)
8000ba3e:	8782                	jr	a5

8000ba40 <.L45>:
8000ba40:	0ff00713          	li	a4,255
8000ba44:	26e79c63          	bne	a5,a4,8000bcbc <.L46>
   			   p = e;   // for break while(p < e)
8000ba48:	47d2                	lw	a5,20(sp)
8000ba4a:	ce3e                	sw	a5,28(sp)
   				break;
8000ba4c:	ac49                	j	8000bcde <.L44>

8000ba4e <.L54>:
   				p++;
8000ba4e:	47f2                	lw	a5,28(sp)
8000ba50:	0785                	add	a5,a5,1
8000ba52:	ce3e                	sw	a5,28(sp)
   				break;
8000ba54:	a469                	j	8000bcde <.L44>

8000ba56 <.L49>:
   				p++;
8000ba56:	47f2                	lw	a5,28(sp)
8000ba58:	0785                	add	a5,a5,1
8000ba5a:	ce3e                	sw	a5,28(sp)
   				p++;
8000ba5c:	47f2                	lw	a5,28(sp)
8000ba5e:	0785                	add	a5,a5,1
8000ba60:	ce3e                	sw	a5,28(sp)
   				type = *p++;
8000ba62:	47f2                	lw	a5,28(sp)
8000ba64:	00178713          	add	a4,a5,1
8000ba68:	ce3a                	sw	a4,28(sp)
8000ba6a:	0007c783          	lbu	a5,0(a5)
8000ba6e:	00f10da3          	sb	a5,27(sp)
   				break;
8000ba72:	a4b5                	j	8000bcde <.L44>

8000ba74 <.L53>:
   				p++;
8000ba74:	47f2                	lw	a5,28(sp)
8000ba76:	0785                	add	a5,a5,1
8000ba78:	ce3e                	sw	a5,28(sp)
   				p++;
8000ba7a:	47f2                	lw	a5,28(sp)
8000ba7c:	0785                	add	a5,a5,1
8000ba7e:	ce3e                	sw	a5,28(sp)
   				DHCP_allocated_sn[0] = *p++;
8000ba80:	47f2                	lw	a5,28(sp)
8000ba82:	00178713          	add	a4,a5,1
8000ba86:	ce3a                	sw	a4,28(sp)
8000ba88:	0007c703          	lbu	a4,0(a5)
8000ba8c:	12e18e23          	sb	a4,316(gp) # 108093c <DHCP_allocated_sn>
   				DHCP_allocated_sn[1] = *p++;
8000ba90:	47f2                	lw	a5,28(sp)
8000ba92:	00178713          	add	a4,a5,1
8000ba96:	ce3a                	sw	a4,28(sp)
8000ba98:	0007c703          	lbu	a4,0(a5)
8000ba9c:	13c18793          	add	a5,gp,316 # 108093c <DHCP_allocated_sn>
8000baa0:	00e780a3          	sb	a4,1(a5)
   				DHCP_allocated_sn[2] = *p++;
8000baa4:	47f2                	lw	a5,28(sp)
8000baa6:	00178713          	add	a4,a5,1
8000baaa:	ce3a                	sw	a4,28(sp)
8000baac:	0007c703          	lbu	a4,0(a5)
8000bab0:	13c18793          	add	a5,gp,316 # 108093c <DHCP_allocated_sn>
8000bab4:	00e78123          	sb	a4,2(a5)
   				DHCP_allocated_sn[3] = *p++;
8000bab8:	47f2                	lw	a5,28(sp)
8000baba:	00178713          	add	a4,a5,1
8000babe:	ce3a                	sw	a4,28(sp)
8000bac0:	0007c703          	lbu	a4,0(a5)
8000bac4:	13c18793          	add	a5,gp,316 # 108093c <DHCP_allocated_sn>
8000bac8:	00e781a3          	sb	a4,3(a5)
   				break;
8000bacc:	ac09                	j	8000bcde <.L44>

8000bace <.L52>:
   				p++;
8000bace:	47f2                	lw	a5,28(sp)
8000bad0:	0785                	add	a5,a5,1
8000bad2:	ce3e                	sw	a5,28(sp)
   				opt_len = *p++;       
8000bad4:	47f2                	lw	a5,28(sp)
8000bad6:	00178713          	add	a4,a5,1
8000bada:	ce3a                	sw	a4,28(sp)
8000badc:	0007c783          	lbu	a5,0(a5)
8000bae0:	00f109a3          	sb	a5,19(sp)
   				DHCP_allocated_gw[0] = *p++;
8000bae4:	47f2                	lw	a5,28(sp)
8000bae6:	00178713          	add	a4,a5,1
8000baea:	ce3a                	sw	a4,28(sp)
8000baec:	0007c703          	lbu	a4,0(a5)
8000baf0:	14e18223          	sb	a4,324(gp) # 1080944 <DHCP_allocated_gw>
   				DHCP_allocated_gw[1] = *p++;
8000baf4:	47f2                	lw	a5,28(sp)
8000baf6:	00178713          	add	a4,a5,1
8000bafa:	ce3a                	sw	a4,28(sp)
8000bafc:	0007c703          	lbu	a4,0(a5)
8000bb00:	14418793          	add	a5,gp,324 # 1080944 <DHCP_allocated_gw>
8000bb04:	00e780a3          	sb	a4,1(a5)
   				DHCP_allocated_gw[2] = *p++;
8000bb08:	47f2                	lw	a5,28(sp)
8000bb0a:	00178713          	add	a4,a5,1
8000bb0e:	ce3a                	sw	a4,28(sp)
8000bb10:	0007c703          	lbu	a4,0(a5)
8000bb14:	14418793          	add	a5,gp,324 # 1080944 <DHCP_allocated_gw>
8000bb18:	00e78123          	sb	a4,2(a5)
   				DHCP_allocated_gw[3] = *p++;
8000bb1c:	47f2                	lw	a5,28(sp)
8000bb1e:	00178713          	add	a4,a5,1
8000bb22:	ce3a                	sw	a4,28(sp)
8000bb24:	0007c703          	lbu	a4,0(a5)
8000bb28:	14418793          	add	a5,gp,324 # 1080944 <DHCP_allocated_gw>
8000bb2c:	00e781a3          	sb	a4,3(a5)
   				p = p + (opt_len - 4);
8000bb30:	01314783          	lbu	a5,19(sp)
8000bb34:	17f1                	add	a5,a5,-4
8000bb36:	4772                	lw	a4,28(sp)
8000bb38:	97ba                	add	a5,a5,a4
8000bb3a:	ce3e                	sw	a5,28(sp)
   				break;
8000bb3c:	a24d                	j	8000bcde <.L44>

8000bb3e <.L51>:
   				p++;                  
8000bb3e:	47f2                	lw	a5,28(sp)
8000bb40:	0785                	add	a5,a5,1
8000bb42:	ce3e                	sw	a5,28(sp)
   				opt_len = *p++;       
8000bb44:	47f2                	lw	a5,28(sp)
8000bb46:	00178713          	add	a4,a5,1
8000bb4a:	ce3a                	sw	a4,28(sp)
8000bb4c:	0007c783          	lbu	a5,0(a5)
8000bb50:	00f109a3          	sb	a5,19(sp)
   				DHCP_allocated_dns[0] = *p++;
8000bb54:	47f2                	lw	a5,28(sp)
8000bb56:	00178713          	add	a4,a5,1
8000bb5a:	ce3a                	sw	a4,28(sp)
8000bb5c:	0007c703          	lbu	a4,0(a5)
8000bb60:	14e18423          	sb	a4,328(gp) # 1080948 <DHCP_allocated_dns>
   				DHCP_allocated_dns[1] = *p++;
8000bb64:	47f2                	lw	a5,28(sp)
8000bb66:	00178713          	add	a4,a5,1
8000bb6a:	ce3a                	sw	a4,28(sp)
8000bb6c:	0007c703          	lbu	a4,0(a5)
8000bb70:	14818793          	add	a5,gp,328 # 1080948 <DHCP_allocated_dns>
8000bb74:	00e780a3          	sb	a4,1(a5)
   				DHCP_allocated_dns[2] = *p++;
8000bb78:	47f2                	lw	a5,28(sp)
8000bb7a:	00178713          	add	a4,a5,1
8000bb7e:	ce3a                	sw	a4,28(sp)
8000bb80:	0007c703          	lbu	a4,0(a5)
8000bb84:	14818793          	add	a5,gp,328 # 1080948 <DHCP_allocated_dns>
8000bb88:	00e78123          	sb	a4,2(a5)
   				DHCP_allocated_dns[3] = *p++;
8000bb8c:	47f2                	lw	a5,28(sp)
8000bb8e:	00178713          	add	a4,a5,1
8000bb92:	ce3a                	sw	a4,28(sp)
8000bb94:	0007c703          	lbu	a4,0(a5)
8000bb98:	14818793          	add	a5,gp,328 # 1080948 <DHCP_allocated_dns>
8000bb9c:	00e781a3          	sb	a4,3(a5)
   				p = p + (opt_len - 4);
8000bba0:	01314783          	lbu	a5,19(sp)
8000bba4:	17f1                	add	a5,a5,-4
8000bba6:	4772                	lw	a4,28(sp)
8000bba8:	97ba                	add	a5,a5,a4
8000bbaa:	ce3e                	sw	a5,28(sp)
   				break;
8000bbac:	aa0d                	j	8000bcde <.L44>

8000bbae <.L50>:
   				p++;
8000bbae:	47f2                	lw	a5,28(sp)
8000bbb0:	0785                	add	a5,a5,1
8000bbb2:	ce3e                	sw	a5,28(sp)
   				opt_len = *p++;
8000bbb4:	47f2                	lw	a5,28(sp)
8000bbb6:	00178713          	add	a4,a5,1
8000bbba:	ce3a                	sw	a4,28(sp)
8000bbbc:	0007c783          	lbu	a5,0(a5)
8000bbc0:	00f109a3          	sb	a5,19(sp)
   				dhcp_lease_time  = *p++;
8000bbc4:	47f2                	lw	a5,28(sp)
8000bbc6:	00178713          	add	a4,a5,1
8000bbca:	ce3a                	sw	a4,28(sp)
8000bbcc:	0007c783          	lbu	a5,0(a5)
8000bbd0:	873e                	mv	a4,a5
8000bbd2:	16e1ac23          	sw	a4,376(gp) # 1080978 <dhcp_lease_time>
   				dhcp_lease_time  = (dhcp_lease_time << 8) + *p++;
8000bbd6:	1781a783          	lw	a5,376(gp) # 1080978 <dhcp_lease_time>
8000bbda:	00879713          	sll	a4,a5,0x8
8000bbde:	47f2                	lw	a5,28(sp)
8000bbe0:	00178693          	add	a3,a5,1
8000bbe4:	ce36                	sw	a3,28(sp)
8000bbe6:	0007c783          	lbu	a5,0(a5)
8000bbea:	973e                	add	a4,a4,a5
8000bbec:	16e1ac23          	sw	a4,376(gp) # 1080978 <dhcp_lease_time>
   				dhcp_lease_time  = (dhcp_lease_time << 8) + *p++;
8000bbf0:	1781a783          	lw	a5,376(gp) # 1080978 <dhcp_lease_time>
8000bbf4:	00879713          	sll	a4,a5,0x8
8000bbf8:	47f2                	lw	a5,28(sp)
8000bbfa:	00178693          	add	a3,a5,1
8000bbfe:	ce36                	sw	a3,28(sp)
8000bc00:	0007c783          	lbu	a5,0(a5)
8000bc04:	973e                	add	a4,a4,a5
8000bc06:	16e1ac23          	sw	a4,376(gp) # 1080978 <dhcp_lease_time>
   				dhcp_lease_time  = (dhcp_lease_time << 8) + *p++;
8000bc0a:	1781a783          	lw	a5,376(gp) # 1080978 <dhcp_lease_time>
8000bc0e:	00879713          	sll	a4,a5,0x8
8000bc12:	47f2                	lw	a5,28(sp)
8000bc14:	00178693          	add	a3,a5,1
8000bc18:	ce36                	sw	a3,28(sp)
8000bc1a:	0007c783          	lbu	a5,0(a5)
8000bc1e:	973e                	add	a4,a4,a5
8000bc20:	16e1ac23          	sw	a4,376(gp) # 1080978 <dhcp_lease_time>
               dhcp_lease_time = 10;
8000bc24:	4729                	li	a4,10
8000bc26:	16e1ac23          	sw	a4,376(gp) # 1080978 <dhcp_lease_time>
   				break;
8000bc2a:	a855                	j	8000bcde <.L44>

8000bc2c <.L47>:
   				p++;
8000bc2c:	47f2                	lw	a5,28(sp)
8000bc2e:	0785                	add	a5,a5,1
8000bc30:	ce3e                	sw	a5,28(sp)
   				opt_len = *p++;
8000bc32:	47f2                	lw	a5,28(sp)
8000bc34:	00178713          	add	a4,a5,1
8000bc38:	ce3a                	sw	a4,28(sp)
8000bc3a:	0007c783          	lbu	a5,0(a5)
8000bc3e:	00f109a3          	sb	a5,19(sp)
   				DHCP_SIP[0] = *p++;
8000bc42:	47f2                	lw	a5,28(sp)
8000bc44:	00178713          	add	a4,a5,1
8000bc48:	ce3a                	sw	a4,28(sp)
8000bc4a:	0007c703          	lbu	a4,0(a5)
8000bc4e:	14e18823          	sb	a4,336(gp) # 1080950 <DHCP_SIP>
   				DHCP_SIP[1] = *p++;
8000bc52:	47f2                	lw	a5,28(sp)
8000bc54:	00178713          	add	a4,a5,1
8000bc58:	ce3a                	sw	a4,28(sp)
8000bc5a:	0007c703          	lbu	a4,0(a5)
8000bc5e:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000bc62:	00e780a3          	sb	a4,1(a5)
   				DHCP_SIP[2] = *p++;
8000bc66:	47f2                	lw	a5,28(sp)
8000bc68:	00178713          	add	a4,a5,1
8000bc6c:	ce3a                	sw	a4,28(sp)
8000bc6e:	0007c703          	lbu	a4,0(a5)
8000bc72:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000bc76:	00e78123          	sb	a4,2(a5)
   				DHCP_SIP[3] = *p++;
8000bc7a:	47f2                	lw	a5,28(sp)
8000bc7c:	00178713          	add	a4,a5,1
8000bc80:	ce3a                	sw	a4,28(sp)
8000bc82:	0007c703          	lbu	a4,0(a5)
8000bc86:	15018793          	add	a5,gp,336 # 1080950 <DHCP_SIP>
8000bc8a:	00e781a3          	sb	a4,3(a5)
                DHCP_REAL_SIP[0]=svr_addr[0];
8000bc8e:	00c14703          	lbu	a4,12(sp)
8000bc92:	14e18a23          	sb	a4,340(gp) # 1080954 <DHCP_REAL_SIP>
                DHCP_REAL_SIP[1]=svr_addr[1];
8000bc96:	00d14703          	lbu	a4,13(sp)
8000bc9a:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000bc9e:	00e780a3          	sb	a4,1(a5)
                DHCP_REAL_SIP[2]=svr_addr[2];
8000bca2:	00e14703          	lbu	a4,14(sp)
8000bca6:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000bcaa:	00e78123          	sb	a4,2(a5)
                DHCP_REAL_SIP[3]=svr_addr[3];
8000bcae:	00f14703          	lbu	a4,15(sp)
8000bcb2:	15418793          	add	a5,gp,340 # 1080954 <DHCP_REAL_SIP>
8000bcb6:	00e781a3          	sb	a4,3(a5)
   				break;
8000bcba:	a015                	j	8000bcde <.L44>

8000bcbc <.L46>:
   				p++;
8000bcbc:	47f2                	lw	a5,28(sp)
8000bcbe:	0785                	add	a5,a5,1
8000bcc0:	ce3e                	sw	a5,28(sp)
   				opt_len = *p++;
8000bcc2:	47f2                	lw	a5,28(sp)
8000bcc4:	00178713          	add	a4,a5,1
8000bcc8:	ce3a                	sw	a4,28(sp)
8000bcca:	0007c783          	lbu	a5,0(a5)
8000bcce:	00f109a3          	sb	a5,19(sp)
   				p += opt_len;
8000bcd2:	01314783          	lbu	a5,19(sp)
8000bcd6:	4772                	lw	a4,28(sp)
8000bcd8:	97ba                	add	a5,a5,a4
8000bcda:	ce3e                	sw	a5,28(sp)
   				break;
8000bcdc:	0001                	nop

8000bcde <.L44>:
		while ( p < e ) {
8000bcde:	4772                	lw	a4,28(sp)
8000bce0:	47d2                	lw	a5,20(sp)
8000bce2:	d2f769e3          	bltu	a4,a5,8000ba14 <.L55>

8000bce6 <.L37>:
	return	type;
8000bce6:	01b10783          	lb	a5,27(sp)

8000bcea <.L56>:
}
8000bcea:	853e                	mv	a0,a5
8000bcec:	50b2                	lw	ra,44(sp)
8000bcee:	6145                	add	sp,sp,48
8000bcf0:	8082                	ret

Disassembly of section .text.DHCP_init:

8000bcf2 <DHCP_init>:
{
8000bcf2:	7179                	add	sp,sp,-48
8000bcf4:	d606                	sw	ra,44(sp)
8000bcf6:	87aa                	mv	a5,a0
8000bcf8:	c42e                	sw	a1,8(sp)
8000bcfa:	00f107a3          	sb	a5,15(sp)
   uint8_t zeroip[4] = {0,0,0,0};
8000bcfe:	ce02                	sw	zero,28(sp)
   getSHAR(DHCP_CHADDR);
8000bd00:	4619                	li	a2,6
8000bd02:	11818593          	add	a1,gp,280 # 1080918 <DHCP_CHADDR>
8000bd06:	6785                	lui	a5,0x1
8000bd08:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
8000bd0c:	c57fd0ef          	jal	80009962 <WIZCHIP_READ_BUF>
   if((DHCP_CHADDR[0] | DHCP_CHADDR[1]  | DHCP_CHADDR[2] | DHCP_CHADDR[3] | DHCP_CHADDR[4] | DHCP_CHADDR[5]) == 0x00)
8000bd10:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd14:	0007c703          	lbu	a4,0(a5)
8000bd18:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd1c:	0017c783          	lbu	a5,1(a5)
8000bd20:	8fd9                	or	a5,a5,a4
8000bd22:	0ff7f713          	zext.b	a4,a5
8000bd26:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd2a:	0027c783          	lbu	a5,2(a5)
8000bd2e:	8fd9                	or	a5,a5,a4
8000bd30:	0ff7f713          	zext.b	a4,a5
8000bd34:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd38:	0037c783          	lbu	a5,3(a5)
8000bd3c:	8fd9                	or	a5,a5,a4
8000bd3e:	0ff7f713          	zext.b	a4,a5
8000bd42:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd46:	0047c783          	lbu	a5,4(a5)
8000bd4a:	8fd9                	or	a5,a5,a4
8000bd4c:	0ff7f713          	zext.b	a4,a5
8000bd50:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd54:	0057c783          	lbu	a5,5(a5)
8000bd58:	8fd9                	or	a5,a5,a4
8000bd5a:	0ff7f793          	zext.b	a5,a5
8000bd5e:	e7a1                	bnez	a5,8000bda6 <.L106>
      DHCP_CHADDR[0] = 0x00;
8000bd60:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd64:	00078023          	sb	zero,0(a5)
      DHCP_CHADDR[1] = 0x08;
8000bd68:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd6c:	4721                	li	a4,8
8000bd6e:	00e780a3          	sb	a4,1(a5)
      DHCP_CHADDR[2] = 0xdc;      
8000bd72:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd76:	fdc00713          	li	a4,-36
8000bd7a:	00e78123          	sb	a4,2(a5)
      DHCP_CHADDR[3] = 0x00;
8000bd7e:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd82:	000781a3          	sb	zero,3(a5)
      DHCP_CHADDR[4] = 0x00;
8000bd86:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd8a:	00078223          	sb	zero,4(a5)
      DHCP_CHADDR[5] = 0x00; 
8000bd8e:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bd92:	000782a3          	sb	zero,5(a5)
      setSHAR(DHCP_CHADDR);     
8000bd96:	4619                	li	a2,6
8000bd98:	11818593          	add	a1,gp,280 # 1080918 <DHCP_CHADDR>
8000bd9c:	6785                	lui	a5,0x1
8000bd9e:	90078513          	add	a0,a5,-1792 # 900 <__ILM_segment_used_end__+0x502>
8000bda2:	9eef90ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>

8000bda6 <.L106>:
	DHCP_SOCKET = s; // SOCK_DHCP
8000bda6:	00f14703          	lbu	a4,15(sp)
8000bdaa:	16e182a3          	sb	a4,357(gp) # 1080965 <DHCP_SOCKET>
	pDHCPMSG = (RIP_MSG*)buf;
8000bdae:	4722                	lw	a4,8(sp)
8000bdb0:	12e1a023          	sw	a4,288(gp) # 1080920 <pDHCPMSG>
	DHCP_XID = 0x12345678;
8000bdb4:	12345737          	lui	a4,0x12345
8000bdb8:	67870713          	add	a4,a4,1656 # 12345678 <__SHARE_RAM_segment_end__+0x111c5678>
8000bdbc:	14e1a623          	sw	a4,332(gp) # 108094c <DHCP_XID>
		DHCP_XID += DHCP_CHADDR[3];
8000bdc0:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bdc4:	0037c783          	lbu	a5,3(a5)
8000bdc8:	873e                	mv	a4,a5
8000bdca:	14c1a783          	lw	a5,332(gp) # 108094c <DHCP_XID>
8000bdce:	973e                	add	a4,a4,a5
8000bdd0:	14e1a623          	sw	a4,332(gp) # 108094c <DHCP_XID>
		DHCP_XID += DHCP_CHADDR[4];
8000bdd4:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bdd8:	0047c783          	lbu	a5,4(a5)
8000bddc:	873e                	mv	a4,a5
8000bdde:	14c1a783          	lw	a5,332(gp) # 108094c <DHCP_XID>
8000bde2:	973e                	add	a4,a4,a5
8000bde4:	14e1a623          	sw	a4,332(gp) # 108094c <DHCP_XID>
		DHCP_XID += DHCP_CHADDR[5];
8000bde8:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000bdec:	0057c783          	lbu	a5,5(a5)
8000bdf0:	873e                	mv	a4,a5
8000bdf2:	14c1a783          	lw	a5,332(gp) # 108094c <DHCP_XID>
8000bdf6:	973e                	add	a4,a4,a5
8000bdf8:	14e1a623          	sw	a4,332(gp) # 108094c <DHCP_XID>
		DHCP_XID += (DHCP_CHADDR[3] ^ DHCP_CHADDR[4] ^ DHCP_CHADDR[5]);
8000bdfc:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000be00:	0037c703          	lbu	a4,3(a5)
8000be04:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000be08:	0047c783          	lbu	a5,4(a5)
8000be0c:	8fb9                	xor	a5,a5,a4
8000be0e:	0ff7f713          	zext.b	a4,a5
8000be12:	11818793          	add	a5,gp,280 # 1080918 <DHCP_CHADDR>
8000be16:	0057c783          	lbu	a5,5(a5)
8000be1a:	8fb9                	xor	a5,a5,a4
8000be1c:	0ff7f793          	zext.b	a5,a5
8000be20:	873e                	mv	a4,a5
8000be22:	14c1a783          	lw	a5,332(gp) # 108094c <DHCP_XID>
8000be26:	973e                	add	a4,a4,a5
8000be28:	14e1a623          	sw	a4,332(gp) # 108094c <DHCP_XID>
	setSIPR(zeroip);
8000be2c:	087c                	add	a5,sp,28
8000be2e:	4611                	li	a2,4
8000be30:	85be                	mv	a1,a5
8000be32:	6785                	lui	a5,0x1
8000be34:	f0078513          	add	a0,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
8000be38:	958f90ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
	setGAR(zeroip);
8000be3c:	087c                	add	a5,sp,28
8000be3e:	4611                	li	a2,4
8000be40:	85be                	mv	a1,a5
8000be42:	10000513          	li	a0,256
8000be46:	94af90ef          	jal	80004f90 <WIZCHIP_WRITE_BUF>
	reset_DHCP_timeout();
8000be4a:	b97fa0ef          	jal	800069e0 <reset_DHCP_timeout>
	dhcp_state = STATE_DHCP_INIT;
8000be4e:	0e018fa3          	sb	zero,255(gp) # 10808ff <dhcp_state>
}
8000be52:	0001                	nop
8000be54:	50b2                	lw	ra,44(sp)
8000be56:	6145                	add	sp,sp,48
8000be58:	8082                	ret

Disassembly of section .text.DHCP_time_handler:

8000be5a <DHCP_time_handler>:

void DHCP_time_handler(void)
{
	dhcp_tick_1s++;
8000be5a:	12c1a783          	lw	a5,300(gp) # 108092c <dhcp_tick_1s>
8000be5e:	00178713          	add	a4,a5,1
8000be62:	12e1a623          	sw	a4,300(gp) # 108092c <dhcp_tick_1s>
}
8000be66:	0001                	nop
8000be68:	8082                	ret

Disassembly of section .text.getIPfromDHCP:

8000be6a <getIPfromDHCP>:

void getIPfromDHCP(uint8_t* ip)
{
8000be6a:	1141                	add	sp,sp,-16
8000be6c:	c62a                	sw	a0,12(sp)
	ip[0] = DHCP_allocated_ip[0];
8000be6e:	1401c703          	lbu	a4,320(gp) # 1080940 <DHCP_allocated_ip>
8000be72:	47b2                	lw	a5,12(sp)
8000be74:	00e78023          	sb	a4,0(a5)
	ip[1] = DHCP_allocated_ip[1];
8000be78:	47b2                	lw	a5,12(sp)
8000be7a:	0785                	add	a5,a5,1
8000be7c:	14018713          	add	a4,gp,320 # 1080940 <DHCP_allocated_ip>
8000be80:	00174703          	lbu	a4,1(a4)
8000be84:	00e78023          	sb	a4,0(a5)
	ip[2] = DHCP_allocated_ip[2];	
8000be88:	47b2                	lw	a5,12(sp)
8000be8a:	0789                	add	a5,a5,2
8000be8c:	14018713          	add	a4,gp,320 # 1080940 <DHCP_allocated_ip>
8000be90:	00274703          	lbu	a4,2(a4)
8000be94:	00e78023          	sb	a4,0(a5)
	ip[3] = DHCP_allocated_ip[3];
8000be98:	47b2                	lw	a5,12(sp)
8000be9a:	078d                	add	a5,a5,3
8000be9c:	14018713          	add	a4,gp,320 # 1080940 <DHCP_allocated_ip>
8000bea0:	00374703          	lbu	a4,3(a4)
8000bea4:	00e78023          	sb	a4,0(a5)
}
8000bea8:	0001                	nop
8000beaa:	0141                	add	sp,sp,16
8000beac:	8082                	ret

Disassembly of section .text.getGWfromDHCP:

8000beae <getGWfromDHCP>:

void getGWfromDHCP(uint8_t* ip)
{
8000beae:	1141                	add	sp,sp,-16
8000beb0:	c62a                	sw	a0,12(sp)
	ip[0] =DHCP_allocated_gw[0];
8000beb2:	1441c703          	lbu	a4,324(gp) # 1080944 <DHCP_allocated_gw>
8000beb6:	47b2                	lw	a5,12(sp)
8000beb8:	00e78023          	sb	a4,0(a5)
	ip[1] =DHCP_allocated_gw[1];
8000bebc:	47b2                	lw	a5,12(sp)
8000bebe:	0785                	add	a5,a5,1
8000bec0:	14418713          	add	a4,gp,324 # 1080944 <DHCP_allocated_gw>
8000bec4:	00174703          	lbu	a4,1(a4)
8000bec8:	00e78023          	sb	a4,0(a5)
	ip[2] =DHCP_allocated_gw[2];
8000becc:	47b2                	lw	a5,12(sp)
8000bece:	0789                	add	a5,a5,2
8000bed0:	14418713          	add	a4,gp,324 # 1080944 <DHCP_allocated_gw>
8000bed4:	00274703          	lbu	a4,2(a4)
8000bed8:	00e78023          	sb	a4,0(a5)
	ip[3] =DHCP_allocated_gw[3];			
8000bedc:	47b2                	lw	a5,12(sp)
8000bede:	078d                	add	a5,a5,3
8000bee0:	14418713          	add	a4,gp,324 # 1080944 <DHCP_allocated_gw>
8000bee4:	00374703          	lbu	a4,3(a4)
8000bee8:	00e78023          	sb	a4,0(a5)
}
8000beec:	0001                	nop
8000beee:	0141                	add	sp,sp,16
8000bef0:	8082                	ret

Disassembly of section .text.getSNfromDHCP:

8000bef2 <getSNfromDHCP>:

void getSNfromDHCP(uint8_t* ip)
{
8000bef2:	1141                	add	sp,sp,-16
8000bef4:	c62a                	sw	a0,12(sp)
   ip[0] = DHCP_allocated_sn[0];
8000bef6:	13c1c703          	lbu	a4,316(gp) # 108093c <DHCP_allocated_sn>
8000befa:	47b2                	lw	a5,12(sp)
8000befc:	00e78023          	sb	a4,0(a5)
   ip[1] = DHCP_allocated_sn[1];
8000bf00:	47b2                	lw	a5,12(sp)
8000bf02:	0785                	add	a5,a5,1
8000bf04:	13c18713          	add	a4,gp,316 # 108093c <DHCP_allocated_sn>
8000bf08:	00174703          	lbu	a4,1(a4)
8000bf0c:	00e78023          	sb	a4,0(a5)
   ip[2] = DHCP_allocated_sn[2];
8000bf10:	47b2                	lw	a5,12(sp)
8000bf12:	0789                	add	a5,a5,2
8000bf14:	13c18713          	add	a4,gp,316 # 108093c <DHCP_allocated_sn>
8000bf18:	00274703          	lbu	a4,2(a4)
8000bf1c:	00e78023          	sb	a4,0(a5)
   ip[3] = DHCP_allocated_sn[3];         
8000bf20:	47b2                	lw	a5,12(sp)
8000bf22:	078d                	add	a5,a5,3
8000bf24:	13c18713          	add	a4,gp,316 # 108093c <DHCP_allocated_sn>
8000bf28:	00374703          	lbu	a4,3(a4)
8000bf2c:	00e78023          	sb	a4,0(a5)
}
8000bf30:	0001                	nop
8000bf32:	0141                	add	sp,sp,16
8000bf34:	8082                	ret

Disassembly of section .text.getDNSfromDHCP:

8000bf36 <getDNSfromDHCP>:

void getDNSfromDHCP(uint8_t* ip)
{
8000bf36:	1141                	add	sp,sp,-16
8000bf38:	c62a                	sw	a0,12(sp)
   ip[0] = DHCP_allocated_dns[0];
8000bf3a:	1481c703          	lbu	a4,328(gp) # 1080948 <DHCP_allocated_dns>
8000bf3e:	47b2                	lw	a5,12(sp)
8000bf40:	00e78023          	sb	a4,0(a5)
   ip[1] = DHCP_allocated_dns[1];
8000bf44:	47b2                	lw	a5,12(sp)
8000bf46:	0785                	add	a5,a5,1
8000bf48:	14818713          	add	a4,gp,328 # 1080948 <DHCP_allocated_dns>
8000bf4c:	00174703          	lbu	a4,1(a4)
8000bf50:	00e78023          	sb	a4,0(a5)
   ip[2] = DHCP_allocated_dns[2];
8000bf54:	47b2                	lw	a5,12(sp)
8000bf56:	0789                	add	a5,a5,2
8000bf58:	14818713          	add	a4,gp,328 # 1080948 <DHCP_allocated_dns>
8000bf5c:	00274703          	lbu	a4,2(a4)
8000bf60:	00e78023          	sb	a4,0(a5)
   ip[3] = DHCP_allocated_dns[3];         
8000bf64:	47b2                	lw	a5,12(sp)
8000bf66:	078d                	add	a5,a5,3
8000bf68:	14818713          	add	a4,gp,328 # 1080948 <DHCP_allocated_dns>
8000bf6c:	00374703          	lbu	a4,3(a4)
8000bf70:	00e78023          	sb	a4,0(a5)
}
8000bf74:	0001                	nop
8000bf76:	0141                	add	sp,sp,16
8000bf78:	8082                	ret

Disassembly of section .text.getDHCPLeasetime:

8000bf7a <getDHCPLeasetime>:

uint32_t getDHCPLeasetime(void)
{
	return dhcp_lease_time;
8000bf7a:	1781a783          	lw	a5,376(gp) # 1080978 <dhcp_lease_time>
}
8000bf7e:	853e                	mv	a0,a5
8000bf80:	8082                	ret

Disassembly of section .text.NibbleToHex:

8000bf82 <NibbleToHex>:

char NibbleToHex(uint8_t nibble)
{
8000bf82:	1141                	add	sp,sp,-16
8000bf84:	87aa                	mv	a5,a0
8000bf86:	00f107a3          	sb	a5,15(sp)
  nibble &= 0x0F;
8000bf8a:	00f14783          	lbu	a5,15(sp)
8000bf8e:	8bbd                	and	a5,a5,15
8000bf90:	00f107a3          	sb	a5,15(sp)
  if (nibble <= 9)
8000bf94:	00f14703          	lbu	a4,15(sp)
8000bf98:	47a5                	li	a5,9
8000bf9a:	00e7e963          	bltu	a5,a4,8000bfac <.L116>
    return nibble + '0';
8000bf9e:	00f14783          	lbu	a5,15(sp)
8000bfa2:	03078793          	add	a5,a5,48
8000bfa6:	0ff7f793          	zext.b	a5,a5
8000bfaa:	a039                	j	8000bfb8 <.L117>

8000bfac <.L116>:
  else 
    return nibble + ('A'-0x0A);
8000bfac:	00f14783          	lbu	a5,15(sp)
8000bfb0:	03778793          	add	a5,a5,55
8000bfb4:	0ff7f793          	zext.b	a5,a5

8000bfb8 <.L117>:
}
8000bfb8:	853e                	mv	a0,a5
8000bfba:	0141                	add	sp,sp,16
8000bfbc:	8082                	ret

Disassembly of section .text.core_local_mem_to_sys_address:

8000bfbe <core_local_mem_to_sys_address>:
#define HPM_CORE0 (0U)
#define HPM_CORE1 (1U)

/* map core local memory(DLM/ILM) to system address */
static inline uint32_t core_local_mem_to_sys_address(uint8_t core_id, uint32_t addr)
{
8000bfbe:	1101                	add	sp,sp,-32
8000bfc0:	87aa                	mv	a5,a0
8000bfc2:	c42e                	sw	a1,8(sp)
8000bfc4:	00f107a3          	sb	a5,15(sp)
    uint32_t sys_addr;
    if (ADDRESS_IN_ILM(addr)) {
8000bfc8:	4722                	lw	a4,8(sp)
8000bfca:	000407b7          	lui	a5,0x40
8000bfce:	00f77863          	bgeu	a4,a5,8000bfde <.L2>
        sys_addr = ILM_TO_SYSTEM(addr);
8000bfd2:	4722                	lw	a4,8(sp)
8000bfd4:	010007b7          	lui	a5,0x1000
8000bfd8:	97ba                	add	a5,a5,a4
8000bfda:	ce3e                	sw	a5,28(sp)
8000bfdc:	a01d                	j	8000c002 <.L3>

8000bfde <.L2>:
    } else if (ADDRESS_IN_DLM(addr)) {
8000bfde:	4722                	lw	a4,8(sp)
8000bfe0:	000807b7          	lui	a5,0x80
8000bfe4:	00f76d63          	bltu	a4,a5,8000bffe <.L4>
8000bfe8:	4722                	lw	a4,8(sp)
8000bfea:	000c07b7          	lui	a5,0xc0
8000bfee:	00f77863          	bgeu	a4,a5,8000bffe <.L4>
        sys_addr = DLM_TO_SYSTEM(addr);
8000bff2:	4722                	lw	a4,8(sp)
8000bff4:	00fc07b7          	lui	a5,0xfc0
8000bff8:	97ba                	add	a5,a5,a4
8000bffa:	ce3e                	sw	a5,28(sp)
8000bffc:	a019                	j	8000c002 <.L3>

8000bffe <.L4>:
    } else {
        return addr;
8000bffe:	47a2                	lw	a5,8(sp)
8000c000:	a821                	j	8000c018 <.L5>

8000c002 <.L3>:
    }
    if (core_id == HPM_CORE1) {
8000c002:	00f14703          	lbu	a4,15(sp)
8000c006:	4785                	li	a5,1
8000c008:	00f71763          	bne	a4,a5,8000c016 <.L6>
        sys_addr += CORE1_ILM_SYSTEM_BASE - CORE0_ILM_SYSTEM_BASE;
8000c00c:	4772                	lw	a4,28(sp)
8000c00e:	001807b7          	lui	a5,0x180
8000c012:	97ba                	add	a5,a5,a4
8000c014:	ce3e                	sw	a5,28(sp)

8000c016 <.L6>:
    }

    return sys_addr;
8000c016:	47f2                	lw	a5,28(sp)

8000c018 <.L5>:
}
8000c018:	853e                	mv	a0,a5
8000c01a:	6105                	add	sp,sp,32
8000c01c:	8082                	ret

Disassembly of section .text.dmamux_config:

8000c01e <dmamux_config>:
 * @param[in] ch_index channel to be configured
 * @param[in] src DMAMUX source
 * @param[in] enable Set true to enable the channel
 */
static inline void dmamux_config(DMAMUX_Type *ptr, uint8_t ch_index, uint8_t src,  bool enable)
{
8000c01e:	1141                	add	sp,sp,-16
8000c020:	c62a                	sw	a0,12(sp)
8000c022:	87ae                	mv	a5,a1
8000c024:	8736                	mv	a4,a3
8000c026:	00f105a3          	sb	a5,11(sp)
8000c02a:	87b2                	mv	a5,a2
8000c02c:	00f10523          	sb	a5,10(sp)
8000c030:	87ba                	mv	a5,a4
8000c032:	00f104a3          	sb	a5,9(sp)
    ptr->MUXCFG[ch_index] = DMAMUX_MUXCFG_SOURCE_SET(src)
8000c036:	00a14783          	lbu	a5,10(sp)
8000c03a:	07f7f693          	and	a3,a5,127
                       | DMAMUX_MUXCFG_ENABLE_SET(enable);
8000c03e:	00914783          	lbu	a5,9(sp)
8000c042:	01f79713          	sll	a4,a5,0x1f
    ptr->MUXCFG[ch_index] = DMAMUX_MUXCFG_SOURCE_SET(src)
8000c046:	00b14783          	lbu	a5,11(sp)
                       | DMAMUX_MUXCFG_ENABLE_SET(enable);
8000c04a:	8f55                	or	a4,a4,a3
    ptr->MUXCFG[ch_index] = DMAMUX_MUXCFG_SOURCE_SET(src)
8000c04c:	46b2                	lw	a3,12(sp)
8000c04e:	078a                	sll	a5,a5,0x2
8000c050:	97b6                	add	a5,a5,a3
8000c052:	c398                	sw	a4,0(a5)
}
8000c054:	0001                	nop
8000c056:	0141                	add	sp,sp,16
8000c058:	8082                	ret

Disassembly of section .text.gpio_set_pin_output:

8000c05a <gpio_set_pin_output>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_set_pin_output(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
8000c05a:	1141                	add	sp,sp,-16
8000c05c:	c62a                	sw	a0,12(sp)
8000c05e:	c42e                	sw	a1,8(sp)
8000c060:	87b2                	mv	a5,a2
8000c062:	00f103a3          	sb	a5,7(sp)
    ptr->OE[port].SET = 1 << pin;
8000c066:	00714783          	lbu	a5,7(sp)
8000c06a:	4705                	li	a4,1
8000c06c:	00f717b3          	sll	a5,a4,a5
8000c070:	86be                	mv	a3,a5
8000c072:	4732                	lw	a4,12(sp)
8000c074:	47a2                	lw	a5,8(sp)
8000c076:	02078793          	add	a5,a5,32 # 180020 <__DLM_segment_end__+0xc0020>
8000c07a:	0792                	sll	a5,a5,0x4
8000c07c:	97ba                	add	a5,a5,a4
8000c07e:	c3d4                	sw	a3,4(a5)
}
8000c080:	0001                	nop
8000c082:	0141                	add	sp,sp,16
8000c084:	8082                	ret

Disassembly of section .text.gpiom_set_pin_controller:

8000c086 <gpiom_set_pin_controller>:
 */
static inline void gpiom_set_pin_controller(GPIOM_Type *ptr,
                              uint8_t gpio_index,
                              uint8_t pin_index,
                              gpiom_gpio_t gpio)
{
8000c086:	1141                	add	sp,sp,-16
8000c088:	c62a                	sw	a0,12(sp)
8000c08a:	87ae                	mv	a5,a1
8000c08c:	8736                	mv	a4,a3
8000c08e:	00f105a3          	sb	a5,11(sp)
8000c092:	87b2                	mv	a5,a2
8000c094:	00f10523          	sb	a5,10(sp)
8000c098:	87ba                	mv	a5,a4
8000c09a:	00f104a3          	sb	a5,9(sp)
    ptr->ASSIGN[gpio_index].PIN[pin_index] =
        (ptr->ASSIGN[gpio_index].PIN[pin_index] & ~(GPIOM_ASSIGN_PIN_SELECT_MASK))
8000c09e:	00b14683          	lbu	a3,11(sp)
8000c0a2:	00a14783          	lbu	a5,10(sp)
8000c0a6:	4732                	lw	a4,12(sp)
8000c0a8:	0696                	sll	a3,a3,0x5
8000c0aa:	97b6                	add	a5,a5,a3
8000c0ac:	078a                	sll	a5,a5,0x2
8000c0ae:	97ba                	add	a5,a5,a4
8000c0b0:	439c                	lw	a5,0(a5)
8000c0b2:	ffc7f693          	and	a3,a5,-4
      | GPIOM_ASSIGN_PIN_SELECT_SET(gpio);
8000c0b6:	00914783          	lbu	a5,9(sp)
8000c0ba:	0037f713          	and	a4,a5,3
    ptr->ASSIGN[gpio_index].PIN[pin_index] =
8000c0be:	00b14603          	lbu	a2,11(sp)
8000c0c2:	00a14783          	lbu	a5,10(sp)
      | GPIOM_ASSIGN_PIN_SELECT_SET(gpio);
8000c0c6:	8f55                	or	a4,a4,a3
    ptr->ASSIGN[gpio_index].PIN[pin_index] =
8000c0c8:	46b2                	lw	a3,12(sp)
8000c0ca:	0616                	sll	a2,a2,0x5
8000c0cc:	97b2                	add	a5,a5,a2
8000c0ce:	078a                	sll	a5,a5,0x2
8000c0d0:	97b6                	add	a5,a5,a3
8000c0d2:	c398                	sw	a4,0(a5)
}
8000c0d4:	0001                	nop
8000c0d6:	0141                	add	sp,sp,16
8000c0d8:	8082                	ret

Disassembly of section .text.spi_nor_tx_trigger_dma:

8000c0da <spi_nor_tx_trigger_dma>:
{
8000c0da:	715d                	add	sp,sp,-80
8000c0dc:	c686                	sw	ra,76(sp)
8000c0de:	ce2a                	sw	a0,28(sp)
8000c0e0:	ca32                	sw	a2,20(sp)
8000c0e2:	c836                	sw	a3,16(sp)
8000c0e4:	86ba                	mv	a3,a4
8000c0e6:	c63e                	sw	a5,12(sp)
8000c0e8:	8742                	mv	a4,a6
8000c0ea:	87ae                	mv	a5,a1
8000c0ec:	00f10da3          	sb	a5,27(sp)
8000c0f0:	87b6                	mv	a5,a3
8000c0f2:	00f10d23          	sb	a5,26(sp)
8000c0f6:	87ba                	mv	a5,a4
8000c0f8:	00f10ca3          	sb	a5,25(sp)
    if (ch_num >= DMA_SOC_CHANNEL_NUM) {
8000c0fc:	01b14703          	lbu	a4,27(sp)
8000c100:	479d                	li	a5,7
8000c102:	00e7f463          	bgeu	a5,a4,8000c10a <.L19>
        return status_invalid_argument;
8000c106:	4789                	li	a5,2
8000c108:	a09d                	j	8000c16e <.L22>

8000c10a <.L19>:
    dma_default_channel_config(dma_ptr, &config);
8000c10a:	101c                	add	a5,sp,32
8000c10c:	85be                	mv	a1,a5
8000c10e:	4572                	lw	a0,28(sp)
8000c110:	fa1fc0ef          	jal	800090b0 <dma_default_channel_config>
    config.dst_addr_ctrl = DMA_ADDRESS_CONTROL_FIXED;
8000c114:	4789                	li	a5,2
8000c116:	02f103a3          	sb	a5,39(sp)
    config.dst_mode      = DMA_HANDSHAKE_MODE_HANDSHAKE;
8000c11a:	4785                	li	a5,1
8000c11c:	02f101a3          	sb	a5,35(sp)
    config.src_addr_ctrl = DMA_ADDRESS_CONTROL_INCREMENT;
8000c120:	02010323          	sb	zero,38(sp)
    config.src_mode      = DMA_HANDSHAKE_MODE_NORMAL;
8000c124:	02010123          	sb	zero,34(sp)
    config.src_width     = data_width;
8000c128:	01a14783          	lbu	a5,26(sp)
8000c12c:	02f10223          	sb	a5,36(sp)
    config.dst_width     = data_width;
8000c130:	01a14783          	lbu	a5,26(sp)
8000c134:	02f102a3          	sb	a5,37(sp)
    config.src_addr      = src;
8000c138:	47c2                	lw	a5,16(sp)
8000c13a:	d63e                	sw	a5,44(sp)
    config.dst_addr      = (uint32_t)&spi_ptr->DATA;
8000c13c:	47d2                	lw	a5,20(sp)
8000c13e:	02c78793          	add	a5,a5,44
8000c142:	d83e                	sw	a5,48(sp)
    config.size_in_byte  = size;
8000c144:	47b2                	lw	a5,12(sp)
8000c146:	dc3e                	sw	a5,56(sp)
    config.src_burst_size = burst_size;
8000c148:	01914783          	lbu	a5,25(sp)
8000c14c:	02f100a3          	sb	a5,33(sp)
    stat = dma_setup_channel(dma_ptr, ch_num, &config, true);
8000c150:	1018                	add	a4,sp,32
8000c152:	01b14783          	lbu	a5,27(sp)
8000c156:	4685                	li	a3,1
8000c158:	863a                	mv	a2,a4
8000c15a:	85be                	mv	a1,a5
8000c15c:	4572                	lw	a0,28(sp)
8000c15e:	d2ffc0ef          	jal	80008e8c <dma_setup_channel>
8000c162:	de2a                	sw	a0,60(sp)
    if (stat != status_success) {
8000c164:	57f2                	lw	a5,60(sp)
8000c166:	c399                	beqz	a5,8000c16c <.L21>
        return stat;
8000c168:	57f2                	lw	a5,60(sp)
8000c16a:	a011                	j	8000c16e <.L22>

8000c16c <.L21>:
    return stat;
8000c16c:	57f2                	lw	a5,60(sp)

8000c16e <.L22>:
}
8000c16e:	853e                	mv	a0,a5
8000c170:	40b6                	lw	ra,76(sp)
8000c172:	6161                	add	sp,sp,80
8000c174:	8082                	ret

Disassembly of section .text.spi_nor_rx_trigger_dma:

8000c176 <spi_nor_rx_trigger_dma>:
{
8000c176:	715d                	add	sp,sp,-80
8000c178:	c686                	sw	ra,76(sp)
8000c17a:	ce2a                	sw	a0,28(sp)
8000c17c:	ca32                	sw	a2,20(sp)
8000c17e:	c836                	sw	a3,16(sp)
8000c180:	86ba                	mv	a3,a4
8000c182:	c63e                	sw	a5,12(sp)
8000c184:	8742                	mv	a4,a6
8000c186:	87ae                	mv	a5,a1
8000c188:	00f10da3          	sb	a5,27(sp)
8000c18c:	87b6                	mv	a5,a3
8000c18e:	00f10d23          	sb	a5,26(sp)
8000c192:	87ba                	mv	a5,a4
8000c194:	00f10ca3          	sb	a5,25(sp)
    if (ch_num >= DMA_SOC_CHANNEL_NUM) {
8000c198:	01b14703          	lbu	a4,27(sp)
8000c19c:	479d                	li	a5,7
8000c19e:	00e7f463          	bgeu	a5,a4,8000c1a6 <.L24>
        return status_invalid_argument;
8000c1a2:	4789                	li	a5,2
8000c1a4:	a09d                	j	8000c20a <.L27>

8000c1a6 <.L24>:
    dma_default_channel_config(dma_ptr, &config);
8000c1a6:	101c                	add	a5,sp,32
8000c1a8:	85be                	mv	a1,a5
8000c1aa:	4572                	lw	a0,28(sp)
8000c1ac:	f05fc0ef          	jal	800090b0 <dma_default_channel_config>
    config.dst_addr_ctrl = DMA_ADDRESS_CONTROL_INCREMENT;
8000c1b0:	020103a3          	sb	zero,39(sp)
    config.dst_mode      = DMA_HANDSHAKE_MODE_HANDSHAKE;
8000c1b4:	4785                	li	a5,1
8000c1b6:	02f101a3          	sb	a5,35(sp)
    config.src_addr_ctrl = DMA_ADDRESS_CONTROL_FIXED;
8000c1ba:	4789                	li	a5,2
8000c1bc:	02f10323          	sb	a5,38(sp)
    config.src_mode      = DMA_HANDSHAKE_MODE_NORMAL;
8000c1c0:	02010123          	sb	zero,34(sp)
    config.src_width     = data_width;
8000c1c4:	01a14783          	lbu	a5,26(sp)
8000c1c8:	02f10223          	sb	a5,36(sp)
    config.dst_width     = data_width;
8000c1cc:	01a14783          	lbu	a5,26(sp)
8000c1d0:	02f102a3          	sb	a5,37(sp)
    config.src_addr      = (uint32_t)&spi_ptr->DATA;
8000c1d4:	47d2                	lw	a5,20(sp)
8000c1d6:	02c78793          	add	a5,a5,44
8000c1da:	d63e                	sw	a5,44(sp)
    config.dst_addr      = dst;
8000c1dc:	47c2                	lw	a5,16(sp)
8000c1de:	d83e                	sw	a5,48(sp)
    config.size_in_byte  = size;
8000c1e0:	47b2                	lw	a5,12(sp)
8000c1e2:	dc3e                	sw	a5,56(sp)
    config.src_burst_size = burst_size;
8000c1e4:	01914783          	lbu	a5,25(sp)
8000c1e8:	02f100a3          	sb	a5,33(sp)
    stat = dma_setup_channel(dma_ptr, ch_num, &config, true);
8000c1ec:	1018                	add	a4,sp,32
8000c1ee:	01b14783          	lbu	a5,27(sp)
8000c1f2:	4685                	li	a3,1
8000c1f4:	863a                	mv	a2,a4
8000c1f6:	85be                	mv	a1,a5
8000c1f8:	4572                	lw	a0,28(sp)
8000c1fa:	c93fc0ef          	jal	80008e8c <dma_setup_channel>
8000c1fe:	de2a                	sw	a0,60(sp)
    if (stat != status_success) {
8000c200:	57f2                	lw	a5,60(sp)
8000c202:	c399                	beqz	a5,8000c208 <.L26>
        return stat;
8000c204:	57f2                	lw	a5,60(sp)
8000c206:	a011                	j	8000c20a <.L27>

8000c208 <.L26>:
    return stat;
8000c208:	57f2                	lw	a5,60(sp)

8000c20a <.L27>:
}
8000c20a:	853e                	mv	a0,a5
8000c20c:	40b6                	lw	ra,76(sp)
8000c20e:	6161                	add	sp,sp,80
8000c210:	8082                	ret

Disassembly of section .text.cris_en:

8000c212 <cris_en>:
}
8000c212:	0001                	nop
8000c214:	8082                	ret

Disassembly of section .text.cris_ex:

8000c216 <cris_ex>:
}
8000c216:	0001                	nop
8000c218:	8082                	ret

Disassembly of section .text.cs_sel:

8000c21a <cs_sel>:
}
8000c21a:	0001                	nop
8000c21c:	8082                	ret

Disassembly of section .text.wizchip_read_byte:

8000c21e <wizchip_read_byte>:

uint8_t wizchip_read_byte(uint8_t *addr_sel, uint8_t addr_sel_len)
{
8000c21e:	7179                	add	sp,sp,-48
8000c220:	d606                	sw	ra,44(sp)
8000c222:	c62a                	sw	a0,12(sp)
8000c224:	87ae                	mv	a5,a1
8000c226:	00f105a3          	sb	a5,11(sp)
    uint8_t i = 0;
8000c22a:	00010fa3          	sb	zero,31(sp)
    /* set mode is readonly. and set the transfer len is 1*/
    PORT_SPI_BASE->TRANSCTRL =  ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_RDTRANCNT_MASK) | SPI_TRANSCTRL_RDTRANCNT_SET(0));
8000c22e:	f00347b7          	lui	a5,0xf0034
8000c232:	5398                	lw	a4,32(a5)
8000c234:	f00347b7          	lui	a5,0xf0034
8000c238:	e0077713          	and	a4,a4,-512
8000c23c:	d398                	sw	a4,32(a5)
    PORT_SPI_BASE->TRANSCTRL =  ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_WRTRANCNT_MASK) | SPI_TRANSCTRL_WRTRANCNT_SET(addr_sel_len - 1));
8000c23e:	f00347b7          	lui	a5,0xf0034
8000c242:	5398                	lw	a4,32(a5)
8000c244:	ffe017b7          	lui	a5,0xffe01
8000c248:	17fd                	add	a5,a5,-1 # ffe00fff <__APB_SRAM_segment_end__+0xbd0efff>
8000c24a:	00f776b3          	and	a3,a4,a5
8000c24e:	00b14783          	lbu	a5,11(sp)
8000c252:	17fd                	add	a5,a5,-1
8000c254:	00c79713          	sll	a4,a5,0xc
8000c258:	001ff7b7          	lui	a5,0x1ff
8000c25c:	8f7d                	and	a4,a4,a5
8000c25e:	f00347b7          	lui	a5,0xf0034
8000c262:	8f55                	or	a4,a4,a3
8000c264:	d398                	sw	a4,32(a5)
    PORT_SPI_BASE->TRANSCTRL = ((PORT_SPI_BASE->TRANSCTRL & ~SPI_TRANSCTRL_TRANSMODE_MASK) | SPI_TRANSCTRL_TRANSMODE_SET(spi_trans_write_read));
8000c266:	f00347b7          	lui	a5,0xf0034
8000c26a:	5398                	lw	a4,32(a5)
8000c26c:	f10007b7          	lui	a5,0xf1000
8000c270:	17fd                	add	a5,a5,-1 # f0ffffff <__AHB_SRAM_segment_end__+0xcf7fff>
8000c272:	00f776b3          	and	a3,a4,a5
8000c276:	f00347b7          	lui	a5,0xf0034
8000c27a:	03000737          	lui	a4,0x3000
8000c27e:	8f55                	or	a4,a4,a3
8000c280:	d398                	sw	a4,32(a5)
#if defined(SPI_SOC_HAS_NEW_TRANS_COUNT) && (SPI_SOC_HAS_NEW_TRANS_COUNT == 1)
    PORT_SPI_BASE->WR_TRANS_CNT = addr_sel_len - 1;
    PORT_SPI_BASE->RD_TRANS_CNT = 0;
#endif
    /* reset the fifo*/
    PORT_SPI_BASE->CTRL |= SPI_CTRL_TXFIFORST_MASK | SPI_CTRL_RXFIFORST_MASK | SPI_CTRL_SPIRST_MASK;
8000c282:	f00347b7          	lui	a5,0xf0034
8000c286:	5b98                	lw	a4,48(a5)
8000c288:	f00347b7          	lui	a5,0xf0034
8000c28c:	00776713          	or	a4,a4,7
8000c290:	db98                	sw	a4,48(a5)
    /* write one byte for fifo*/
    
    /* start tranfer */
    actual_cs_sel();
8000c292:	955fa0ef          	jal	80006be6 <actual_cs_sel>
    PORT_SPI_BASE->CMD = 0xff;
8000c296:	f00347b7          	lui	a5,0xf0034
8000c29a:	0ff00713          	li	a4,255
8000c29e:	d3d8                	sw	a4,36(a5)
    for (i = 0; i < addr_sel_len; i++) {
8000c2a0:	00010fa3          	sb	zero,31(sp)
8000c2a4:	a839                	j	8000c2c2 <.L78>

8000c2a6 <.L79>:
        PORT_SPI_BASE->DATA = addr_sel[i];
8000c2a6:	01f14783          	lbu	a5,31(sp)
8000c2aa:	4732                	lw	a4,12(sp)
8000c2ac:	97ba                	add	a5,a5,a4
8000c2ae:	0007c703          	lbu	a4,0(a5) # f0034000 <__XPI0_segment_end__+0x6f834000>
8000c2b2:	f00347b7          	lui	a5,0xf0034
8000c2b6:	d7d8                	sw	a4,44(a5)
    for (i = 0; i < addr_sel_len; i++) {
8000c2b8:	01f14783          	lbu	a5,31(sp)
8000c2bc:	0785                	add	a5,a5,1 # f0034001 <__XPI0_segment_end__+0x6f834001>
8000c2be:	00f10fa3          	sb	a5,31(sp)

8000c2c2 <.L78>:
8000c2c2:	01f14703          	lbu	a4,31(sp)
8000c2c6:	00b14783          	lbu	a5,11(sp)
8000c2ca:	fcf76ee3          	bltu	a4,a5,8000c2a6 <.L79>
    }
    while (spi_is_active(PORT_SPI_BASE));
8000c2ce:	0001                	nop

8000c2d0 <.L80>:
8000c2d0:	f0034537          	lui	a0,0xf0034
8000c2d4:	f1efa0ef          	jal	800069f2 <spi_is_active>
8000c2d8:	87aa                	mv	a5,a0
8000c2da:	fbfd                	bnez	a5,8000c2d0 <.L80>
    cs_desel();
8000c2dc:	923fa0ef          	jal	80006bfe <cs_desel>
    return PORT_SPI_BASE->DATA;
8000c2e0:	f00347b7          	lui	a5,0xf0034
8000c2e4:	57dc                	lw	a5,44(a5)
8000c2e6:	0ff7f793          	zext.b	a5,a5
}
8000c2ea:	853e                	mv	a0,a5
8000c2ec:	50b2                	lw	ra,44(sp)
8000c2ee:	6145                	add	sp,sp,48
8000c2f0:	8082                	ret

Disassembly of section .text.wizchip_register_port:

8000c2f2 <wizchip_register_port>:

void wizchip_register_port(void)
{
8000c2f2:	1141                	add	sp,sp,-16
8000c2f4:	c606                	sw	ra,12(sp)
    reg_wizchip_cris_cbfunc(cris_en, cris_ex);            /* critical section */
8000c2f6:	8000c7b7          	lui	a5,0x8000c
8000c2fa:	21678593          	add	a1,a5,534 # 8000c216 <cris_ex>
8000c2fe:	8000c7b7          	lui	a5,0x8000c
8000c302:	21278513          	add	a0,a5,530 # 8000c212 <cris_en>
8000c306:	f90fe0ef          	jal	8000aa96 <reg_wizchip_cris_cbfunc>
    reg_wizchip_cs_cbfunc(cs_sel, cs_desel);              /* cs register */
8000c30a:	800077b7          	lui	a5,0x80007
8000c30e:	bfe78593          	add	a1,a5,-1026 # 80006bfe <cs_desel>
8000c312:	8000c7b7          	lui	a5,0x8000c
8000c316:	21a78513          	add	a0,a5,538 # 8000c21a <cs_sel>
8000c31a:	fc0fe0ef          	jal	8000aada <reg_wizchip_cs_cbfunc>
    reg_wizchip_spi_cbfunc(spi_rbyte, spi_wbyte);         /* byte taransfer register*/
8000c31e:	800077b7          	lui	a5,0x80007
8000c322:	c8078593          	add	a1,a5,-896 # 80006c80 <spi_wbyte>
8000c326:	800077b7          	lui	a5,0x80007
8000c32a:	c1678513          	add	a0,a5,-1002 # 80006c16 <spi_rbyte>
8000c32e:	ff0fe0ef          	jal	8000ab1e <reg_wizchip_spi_cbfunc>
    reg_wizchip_spiburst_cbfunc(spi_rbusrt, spi_wburst);  /* block transfer register*/
8000c332:	800077b7          	lui	a5,0x80007
8000c336:	e5878593          	add	a1,a5,-424 # 80006e58 <spi_wburst>
8000c33a:	800077b7          	lui	a5,0x80007
8000c33e:	cf678513          	add	a0,a5,-778 # 80006cf6 <spi_rbusrt>
8000c342:	831fe0ef          	jal	8000ab72 <reg_wizchip_spiburst_cbfunc>
}
8000c346:	0001                	nop
8000c348:	40b2                	lw	ra,12(sp)
8000c34a:	0141                	add	sp,sp,16
8000c34c:	8082                	ret

Disassembly of section .text.wizchip_spi_init:

8000c34e <wizchip_spi_init>:

void wizchip_spi_init(void)
{
8000c34e:	7179                	add	sp,sp,-48
8000c350:	d606                	sw	ra,44(sp)
    spi_timing_config_t timing_config = {0};
8000c352:	ca02                	sw	zero,20(sp)
8000c354:	cc02                	sw	zero,24(sp)
8000c356:	ce02                	sw	zero,28(sp)
    spi_format_config_t format_config = {0};
8000c358:	c602                	sw	zero,12(sp)
8000c35a:	c802                	sw	zero,16(sp)
    spi_control_config_t control_config = {0};
8000c35c:	c002                	sw	zero,0(sp)
8000c35e:	c202                	sw	zero,4(sp)
8000c360:	00011423          	sh	zero,8(sp)
8000c364:	00010523          	sb	zero,10(sp)
    uint32_t spi_clcok;

    HPM_IOC->PAD[IOC_PAD_PA23].FUNC_CTL = IOC_PA23_FUNC_CTL_SPI1_MISO;
8000c368:	f40407b7          	lui	a5,0xf4040
8000c36c:	4715                	li	a4,5
8000c36e:	0ae7ac23          	sw	a4,184(a5) # f40400b8 <__AHB_SRAM_segment_end__+0x3d380b8>
    HPM_IOC->PAD[IOC_PAD_PA16].FUNC_CTL = IOC_PA16_FUNC_CTL_SPI1_MOSI;
8000c372:	f40407b7          	lui	a5,0xf4040
8000c376:	4715                	li	a4,5
8000c378:	08e7a023          	sw	a4,128(a5) # f4040080 <__AHB_SRAM_segment_end__+0x3d38080>
    HPM_IOC->PAD[IOC_PAD_PA21].FUNC_CTL = IOC_PA21_FUNC_CTL_SPI1_SCLK | IOC_PAD_FUNC_CTL_LOOP_BACK_MASK;
8000c37c:	f40407b7          	lui	a5,0xf4040
8000c380:	6741                	lui	a4,0x10
8000c382:	0715                	add	a4,a4,5 # 10005 <__XPI0_segment_used_size__+0x3fb1>
8000c384:	0ae7a423          	sw	a4,168(a5) # f40400a8 <__AHB_SRAM_segment_end__+0x3d380a8>

#if !defined(USE_HARDWARE_CS) || (USE_HARDWARE_CS == 0)
    HPM_IOC->PAD[IOC_PAD_PA18].FUNC_CTL = IOC_PA18_FUNC_CTL_GPIO_A_18;
8000c388:	f40407b7          	lui	a5,0xf4040
8000c38c:	0807a823          	sw	zero,144(a5) # f4040090 <__AHB_SRAM_segment_end__+0x3d38090>
    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOA, 18, gpiom_soc_gpio0);
8000c390:	4681                	li	a3,0
8000c392:	4649                	li	a2,18
8000c394:	4581                	li	a1,0
8000c396:	f0008537          	lui	a0,0xf0008
8000c39a:	31f5                	jal	8000c086 <gpiom_set_pin_controller>
    gpio_set_pin_output(PORT_CS_PIN);
8000c39c:	4649                	li	a2,18
8000c39e:	4581                	li	a1,0
8000c3a0:	f0000537          	lui	a0,0xf0000
8000c3a4:	395d                	jal	8000c05a <gpio_set_pin_output>
    gpio_write_pin(PORT_CS_PIN, 1);
8000c3a6:	4685                	li	a3,1
8000c3a8:	4649                	li	a2,18
8000c3aa:	4581                	li	a1,0
8000c3ac:	f0000537          	lui	a0,0xf0000
8000c3b0:	e8efa0ef          	jal	80006a3e <gpio_write_pin>
#else
     HPM_IOC->PAD[IOC_PAD_PA18].FUNC_CTL = IOC_PA18_FUNC_CTL_SPI1_CSN;
#endif

    /* set SPI sclk frequency for master */
    clock_add_to_group(PORT_SPI_CLK_NAME, 0);
8000c3b4:	4581                	li	a1,0
8000c3b6:	013707b7          	lui	a5,0x1370
8000c3ba:	02878513          	add	a0,a5,40 # 1370028 <__SHARE_RAM_segment_end__+0x1f0028>
8000c3be:	c4afb0ef          	jal	80007808 <clock_add_to_group>
    spi_master_get_default_timing_config(&timing_config);
8000c3c2:	085c                	add	a5,sp,20
8000c3c4:	853e                	mv	a0,a5
8000c3c6:	884f80ef          	jal	8000444a <spi_master_get_default_timing_config>
    timing_config.master_config.cs2sclk = spi_cs2sclk_half_sclk_1;
8000c3ca:	00010e23          	sb	zero,28(sp)
    timing_config.master_config.csht = spi_csht_half_sclk_1;
8000c3ce:	00010ea3          	sb	zero,29(sp)
    timing_config.master_config.clk_src_freq_in_hz = clock_get_frequency(PORT_SPI_CLK_NAME);
8000c3d2:	013707b7          	lui	a5,0x1370
8000c3d6:	02878513          	add	a0,a5,40 # 1370028 <__SHARE_RAM_segment_end__+0x1f0028>
8000c3da:	a1cfb0ef          	jal	800075f6 <clock_get_frequency>
8000c3de:	87aa                	mv	a5,a0
8000c3e0:	ca3e                	sw	a5,20(sp)
    timing_config.master_config.sclk_freq_in_hz = PORT_SPI_SCLK_FREQ;
8000c3e2:	013137b7          	lui	a5,0x1313
8000c3e6:	d0078793          	add	a5,a5,-768 # 1312d00 <__SHARE_RAM_segment_end__+0x192d00>
8000c3ea:	cc3e                	sw	a5,24(sp)
    if (status_success != spi_master_timing_init(PORT_SPI_BASE, &timing_config)) {
8000c3ec:	085c                	add	a5,sp,20
8000c3ee:	85be                	mv	a1,a5
8000c3f0:	f0034537          	lui	a0,0xf0034
8000c3f4:	8d2f80ef          	jal	800044c6 <spi_master_timing_init>
8000c3f8:	87aa                	mv	a5,a0
8000c3fa:	c799                	beqz	a5,8000c408 <.L84>
        printf("SPI master timing init failed\n");
8000c3fc:	800057b7          	lui	a5,0x80005
8000c400:	85878513          	add	a0,a5,-1960 # 80004858 <.LC0>
8000c404:	90dfc0ef          	jal	80008d10 <printf>

8000c408 <.L84>:
    }
    /* set SPI format config for master */
    spi_master_get_default_format_config(&format_config);
8000c408:	007c                	add	a5,sp,12
8000c40a:	853e                	mv	a0,a5
8000c40c:	9d4fd0ef          	jal	800095e0 <spi_master_get_default_format_config>
    format_config.master_config.addr_len_in_bytes = 1U;
8000c410:	4785                	li	a5,1
8000c412:	00f10623          	sb	a5,12(sp)
    format_config.common_config.data_len_in_bits = 8;
8000c416:	47a1                	li	a5,8
8000c418:	00f106a3          	sb	a5,13(sp)
    format_config.common_config.data_merge = false;
8000c41c:	00010723          	sb	zero,14(sp)
    format_config.common_config.mosi_bidir = false;
8000c420:	000107a3          	sb	zero,15(sp)
    format_config.common_config.lsb = false;
8000c424:	00010823          	sb	zero,16(sp)
    format_config.common_config.mode = spi_master_mode;
8000c428:	000108a3          	sb	zero,17(sp)
    format_config.common_config.cpol = spi_sclk_high_idle;
8000c42c:	4785                	li	a5,1
8000c42e:	00f10923          	sb	a5,18(sp)
    format_config.common_config.cpha = spi_sclk_sampling_even_clk_edges;
8000c432:	4785                	li	a5,1
8000c434:	00f109a3          	sb	a5,19(sp)
    spi_format_init(PORT_SPI_BASE, &format_config);
8000c438:	007c                	add	a5,sp,12
8000c43a:	85be                	mv	a1,a5
8000c43c:	f0034537          	lui	a0,0xf0034
8000c440:	9e4fd0ef          	jal	80009624 <spi_format_init>

    spi_master_get_default_control_config(&control_config);
8000c444:	878a                	mv	a5,sp
8000c446:	853e                	mv	a0,a5
8000c448:	82af80ef          	jal	80004472 <spi_master_get_default_control_config>
    control_config.common_config.tx_dma_enable = true;
8000c44c:	4785                	li	a5,1
8000c44e:	00f10323          	sb	a5,6(sp)
    control_config.common_config.rx_dma_enable = true;
8000c452:	4785                	li	a5,1
8000c454:	00f103a3          	sb	a5,7(sp)
    control_config.common_config.trans_mode = spi_trans_write_read;
8000c458:	478d                	li	a5,3
8000c45a:	00f10423          	sb	a5,8(sp)
    control_config.common_config.data_phase_fmt = spi_single_io_mode;
8000c45e:	000104a3          	sb	zero,9(sp)
    control_config.common_config.dummy_cnt = spi_dummy_count_1;
8000c462:	00010523          	sb	zero,10(sp)
    spi_control_init(PORT_SPI_BASE, &control_config, 3, 1);
8000c466:	878a                	mv	a5,sp
8000c468:	4685                	li	a3,1
8000c46a:	460d                	li	a2,3
8000c46c:	85be                	mv	a1,a5
8000c46e:	f0034537          	lui	a0,0xf0034
8000c472:	8f8f80ef          	jal	8000456a <spi_control_init>
    PORT_SPI_BASE->CTRL |= SPI_CTRL_TXDMAEN_MASK | SPI_CTRL_RXDMAEN_MASK;
8000c476:	f00347b7          	lui	a5,0xf0034
8000c47a:	5b98                	lw	a4,48(a5)
8000c47c:	f00347b7          	lui	a5,0xf0034
8000c480:	01876713          	or	a4,a4,24
8000c484:	db98                	sw	a4,48(a5)
    dmamux_config(PORT_SPI_DMAMUX, PORT_SPI_TX_DMAMUX_CH, PORT_SPI_TX_DMA_REQ, true);
8000c486:	4685                	li	a3,1
8000c488:	460d                	li	a2,3
8000c48a:	4585                	li	a1,1
8000c48c:	f00c0537          	lui	a0,0xf00c0
8000c490:	3679                	jal	8000c01e <dmamux_config>
    dmamux_config(PORT_SPI_DMAMUX, PORT_SPI_RX_DMAMUX_CH, PORT_SPI_RX_DMA_REQ, true);
8000c492:	4685                	li	a3,1
8000c494:	4609                	li	a2,2
8000c496:	4581                	li	a1,0
8000c498:	f00c0537          	lui	a0,0xf00c0
8000c49c:	3649                	jal	8000c01e <dmamux_config>
}
8000c49e:	0001                	nop
8000c4a0:	50b2                	lw	ra,44(sp)
8000c4a2:	6145                	add	sp,sp,48
8000c4a4:	8082                	ret

Disassembly of section .text.wizchip_spi_change_freq:

8000c4a6 <wizchip_spi_change_freq>:

void wizchip_spi_change_freq(int freq)
{
8000c4a6:	7179                	add	sp,sp,-48
8000c4a8:	d606                	sw	ra,44(sp)
8000c4aa:	c62a                	sw	a0,12(sp)
    spi_timing_config_t timing_config = {0};
8000c4ac:	ca02                	sw	zero,20(sp)
8000c4ae:	cc02                	sw	zero,24(sp)
8000c4b0:	ce02                	sw	zero,28(sp)
    if (freq <= 0) {
8000c4b2:	47b2                	lw	a5,12(sp)
8000c4b4:	00f04763          	bgtz	a5,8000c4c2 <.L86>
        freq = PORT_SPI_SCLK_FREQ;
8000c4b8:	013137b7          	lui	a5,0x1313
8000c4bc:	d0078793          	add	a5,a5,-768 # 1312d00 <__SHARE_RAM_segment_end__+0x192d00>
8000c4c0:	c63e                	sw	a5,12(sp)

8000c4c2 <.L86>:
    }
    spi_master_get_default_timing_config(&timing_config);
8000c4c2:	085c                	add	a5,sp,20
8000c4c4:	853e                	mv	a0,a5
8000c4c6:	f85f70ef          	jal	8000444a <spi_master_get_default_timing_config>
    timing_config.master_config.cs2sclk = spi_cs2sclk_half_sclk_1;
8000c4ca:	00010e23          	sb	zero,28(sp)
    timing_config.master_config.csht = spi_csht_half_sclk_1;
8000c4ce:	00010ea3          	sb	zero,29(sp)
    timing_config.master_config.clk_src_freq_in_hz = clock_get_frequency(PORT_SPI_CLK_NAME);;
8000c4d2:	013707b7          	lui	a5,0x1370
8000c4d6:	02878513          	add	a0,a5,40 # 1370028 <__SHARE_RAM_segment_end__+0x1f0028>
8000c4da:	91cfb0ef          	jal	800075f6 <clock_get_frequency>
8000c4de:	87aa                	mv	a5,a0
8000c4e0:	ca3e                	sw	a5,20(sp)
    timing_config.master_config.sclk_freq_in_hz = freq;
8000c4e2:	47b2                	lw	a5,12(sp)
8000c4e4:	cc3e                	sw	a5,24(sp)
    if (status_success != spi_master_timing_init(PORT_SPI_BASE, &timing_config)) {
8000c4e6:	085c                	add	a5,sp,20
8000c4e8:	85be                	mv	a1,a5
8000c4ea:	f0034537          	lui	a0,0xf0034
8000c4ee:	fd9f70ef          	jal	800044c6 <spi_master_timing_init>
8000c4f2:	87aa                	mv	a5,a0
8000c4f4:	c799                	beqz	a5,8000c502 <.L88>
        printf("SPI master timing init failed\n");
8000c4f6:	800057b7          	lui	a5,0x80005
8000c4fa:	85878513          	add	a0,a5,-1960 # 80004858 <.LC0>
8000c4fe:	813fc0ef          	jal	80008d10 <printf>

8000c502 <.L88>:
    }
}
8000c502:	0001                	nop
8000c504:	50b2                	lw	ra,44(sp)
8000c506:	6145                	add	sp,sp,48
8000c508:	8082                	ret

Disassembly of section .text.gptmr_enable_irq:

8000c50a <gptmr_enable_irq>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] irq_mask irq mask
 */
static inline void gptmr_enable_irq(GPTMR_Type *ptr, uint32_t irq_mask)
{
8000c50a:	1141                	add	sp,sp,-16
8000c50c:	c62a                	sw	a0,12(sp)
8000c50e:	c42e                	sw	a1,8(sp)
    ptr->IRQEN |= irq_mask;
8000c510:	47b2                	lw	a5,12(sp)
8000c512:	2047a703          	lw	a4,516(a5)
8000c516:	47a2                	lw	a5,8(sp)
8000c518:	8f5d                	or	a4,a4,a5
8000c51a:	47b2                	lw	a5,12(sp)
8000c51c:	20e7a223          	sw	a4,516(a5)
}
8000c520:	0001                	nop
8000c522:	0141                	add	sp,sp,16
8000c524:	8082                	ret

Disassembly of section .text.gptmr_check_status:

8000c526 <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
8000c526:	1141                	add	sp,sp,-16
8000c528:	c62a                	sw	a0,12(sp)
8000c52a:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
8000c52c:	47b2                	lw	a5,12(sp)
8000c52e:	2007a703          	lw	a4,512(a5)
8000c532:	47a2                	lw	a5,8(sp)
8000c534:	8ff9                	and	a5,a5,a4
8000c536:	4722                	lw	a4,8(sp)
8000c538:	40f707b3          	sub	a5,a4,a5
8000c53c:	0017b793          	seqz	a5,a5
8000c540:	0ff7f793          	zext.b	a5,a5
}
8000c544:	853e                	mv	a0,a5
8000c546:	0141                	add	sp,sp,16
8000c548:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

8000c54a <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
8000c54a:	1141                	add	sp,sp,-16
8000c54c:	c62a                	sw	a0,12(sp)
8000c54e:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
8000c550:	47b2                	lw	a5,12(sp)
8000c552:	4722                	lw	a4,8(sp)
8000c554:	20e7a023          	sw	a4,512(a5)
}
8000c558:	0001                	nop
8000c55a:	0141                	add	sp,sp,16
8000c55c:	8082                	ret

Disassembly of section .text.gptmr_start_counter:

8000c55e <gptmr_start_counter>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] ch_index channel index
 */
static inline void gptmr_start_counter(GPTMR_Type *ptr, uint8_t ch_index)
{
8000c55e:	1141                	add	sp,sp,-16
8000c560:	c62a                	sw	a0,12(sp)
8000c562:	87ae                	mv	a5,a1
8000c564:	00f105a3          	sb	a5,11(sp)
    /* if support opmode, should clear CEN and set CEN */
     if (gptmr_channel_is_opmode(ptr, ch_index) == true) {
        ptr->CHANNEL[ch_index].CR &= ~GPTMR_CHANNEL_CR_CEN_MASK;
     }
#endif
    ptr->CHANNEL[ch_index].CR |= GPTMR_CHANNEL_CR_CEN_MASK;
8000c568:	00b14783          	lbu	a5,11(sp)
8000c56c:	4732                	lw	a4,12(sp)
8000c56e:	079a                	sll	a5,a5,0x6
8000c570:	97ba                	add	a5,a5,a4
8000c572:	4398                	lw	a4,0(a5)
8000c574:	00b14783          	lbu	a5,11(sp)
8000c578:	40076713          	or	a4,a4,1024
8000c57c:	46b2                	lw	a3,12(sp)
8000c57e:	079a                	sll	a5,a5,0x6
8000c580:	97b6                	add	a5,a5,a3
8000c582:	c398                	sw	a4,0(a5)
}
8000c584:	0001                	nop
8000c586:	0141                	add	sp,sp,16
8000c588:	8082                	ret

Disassembly of section .text.load_net_parameters:

8000c58a <load_net_parameters>:
    g_winznet_info.gw[0] = 192;
8000c58a:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c58e:	fc000713          	li	a4,-64
8000c592:	00e78723          	sb	a4,14(a5)
    g_winznet_info.gw[1] = 168;
8000c596:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c59a:	fa800713          	li	a4,-88
8000c59e:	00e787a3          	sb	a4,15(a5)
    g_winznet_info.gw[2] = 0;
8000c5a2:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5a6:	00078823          	sb	zero,16(a5)
    g_winznet_info.gw[3] = 1;
8000c5aa:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5ae:	4705                	li	a4,1
8000c5b0:	00e788a3          	sb	a4,17(a5)
    g_winznet_info.sn[0] = 255;
8000c5b4:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5b8:	577d                	li	a4,-1
8000c5ba:	00e78523          	sb	a4,10(a5)
    g_winznet_info.sn[1] = 255;
8000c5be:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5c2:	577d                	li	a4,-1
8000c5c4:	00e785a3          	sb	a4,11(a5)
    g_winznet_info.sn[2] = 255;
8000c5c8:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5cc:	577d                	li	a4,-1
8000c5ce:	00e78623          	sb	a4,12(a5)
    g_winznet_info.sn[3] = 0;
8000c5d2:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5d6:	000786a3          	sb	zero,13(a5)
    g_winznet_info.mac[0] = 0x0c;
8000c5da:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5de:	4731                	li	a4,12
8000c5e0:	00e78023          	sb	a4,0(a5)
    g_winznet_info.mac[1] = 0x29;
8000c5e4:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5e8:	02900713          	li	a4,41
8000c5ec:	00e780a3          	sb	a4,1(a5)
    g_winznet_info.mac[2] = 0xab;
8000c5f0:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c5f4:	fab00713          	li	a4,-85
8000c5f8:	00e78123          	sb	a4,2(a5)
    g_winznet_info.mac[3] = 0x7c;
8000c5fc:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c600:	07c00713          	li	a4,124
8000c604:	00e781a3          	sb	a4,3(a5)
    g_winznet_info.mac[4] = 0x00;
8000c608:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c60c:	00078223          	sb	zero,4(a5)
    g_winznet_info.mac[5] = 0x01;
8000c610:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c614:	4705                	li	a4,1
8000c616:	00e782a3          	sb	a4,5(a5)
    g_winznet_info.ip[0] = 192;
8000c61a:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c61e:	fc000713          	li	a4,-64
8000c622:	00e78323          	sb	a4,6(a5)
    g_winznet_info.ip[1] = 168;
8000c626:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c62a:	fa800713          	li	a4,-88
8000c62e:	00e783a3          	sb	a4,7(a5)
    g_winznet_info.ip[2] = 0;
8000c632:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c636:	00078423          	sb	zero,8(a5)
    g_winznet_info.ip[3] = 246;
8000c63a:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c63e:	5759                	li	a4,-10
8000c640:	00e784a3          	sb	a4,9(a5)
    g_winznet_info.dhcp = NETINFO_STATIC;
8000c644:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c648:	4705                	li	a4,1
8000c64a:	00e78b23          	sb	a4,22(a5)
}
8000c64e:	0001                	nop
8000c650:	8082                	ret

Disassembly of section .text.TimInit:

8000c652 <TimInit>:
}

static void TimInit(void)
{
8000c652:	711d                	add	sp,sp,-96
8000c654:	ce86                	sw	ra,92(sp)
    uint32_t               gptmr_freq;
    gptmr_channel_config_t config;

    gptmr_channel_get_default_config(DHCP_TIM_BASE, &config);
8000c656:	005c                	add	a5,sp,4
8000c658:	85be                	mv	a1,a5
8000c65a:	f3014537          	lui	a0,0xf3014
8000c65e:	ec0f70ef          	jal	80003d1e <gptmr_channel_get_default_config>

    clock_add_to_group(DHCP_TIM_CLK_NAME, 0);
8000c662:	4581                	li	a1,0
8000c664:	011f07b7          	lui	a5,0x11f0
8000c668:	01078513          	add	a0,a5,16 # 11f0010 <__SHARE_RAM_segment_end__+0x70010>
8000c66c:	99cfb0ef          	jal	80007808 <clock_add_to_group>

    config.reload = clock_get_frequency(DHCP_TIM_CLK_NAME);  // 1 s
8000c670:	011f07b7          	lui	a5,0x11f0
8000c674:	01078513          	add	a0,a5,16 # 11f0010 <__SHARE_RAM_segment_end__+0x70010>
8000c678:	f7ffa0ef          	jal	800075f6 <clock_get_frequency>
8000c67c:	87aa                	mv	a5,a0
8000c67e:	c83e                	sw	a5,16(sp)
    gptmr_channel_config(DHCP_TIM_BASE, DHCP_TIM_CH, &config, false);
8000c680:	005c                	add	a5,sp,4
8000c682:	4681                	li	a3,0
8000c684:	863e                	mv	a2,a5
8000c686:	4585                	li	a1,1
8000c688:	f3014537          	lui	a0,0xf3014
8000c68c:	f22f70ef          	jal	80003dae <gptmr_channel_config>
    gptmr_enable_irq(DHCP_TIM_BASE, GPTMR_CH_RLD_IRQ_MASK(DHCP_TIM_CH));
8000c690:	45c1                	li	a1,16
8000c692:	f3014537          	lui	a0,0xf3014
8000c696:	3d95                	jal	8000c50a <gptmr_enable_irq>
8000c698:	04100793          	li	a5,65
8000c69c:	d83e                	sw	a5,48(sp)
8000c69e:	4785                	li	a5,1
8000c6a0:	d63e                	sw	a5,44(sp)
8000c6a2:	e40007b7          	lui	a5,0xe4000
8000c6a6:	d43e                	sw	a5,40(sp)
8000c6a8:	57c2                	lw	a5,48(sp)
8000c6aa:	d23e                	sw	a5,36(sp)
8000c6ac:	57b2                	lw	a5,44(sp)
8000c6ae:	d03e                	sw	a5,32(sp)

8000c6b0 <.LBB14>:
ATTR_ALWAYS_INLINE static inline void __plic_set_irq_priority(uint32_t base,
                                               uint32_t irq,
                                               uint32_t priority)
{
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_PRIORITY_OFFSET + ((irq-1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
8000c6b0:	5792                	lw	a5,36(sp)
8000c6b2:	17fd                	add	a5,a5,-1 # e3ffffff <__XPI0_segment_end__+0x637fffff>
8000c6b4:	00279713          	sll	a4,a5,0x2
8000c6b8:	57a2                	lw	a5,40(sp)
8000c6ba:	97ba                	add	a5,a5,a4
8000c6bc:	0791                	add	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
8000c6be:	ce3e                	sw	a5,28(sp)
    *priority_ptr = priority;
8000c6c0:	47f2                	lw	a5,28(sp)
8000c6c2:	5702                	lw	a4,32(sp)
8000c6c4:	c398                	sw	a4,0(a5)
}
8000c6c6:	0001                	nop

8000c6c8 <.LBE16>:
 * @param[in] priority Priority of interrupt
 */
ATTR_ALWAYS_INLINE static inline void intc_set_irq_priority(uint32_t irq, uint32_t priority)
{
    __plic_set_irq_priority(HPM_PLIC_BASE, irq, priority);
}
8000c6c8:	0001                	nop
8000c6ca:	c682                	sw	zero,76(sp)
8000c6cc:	04100793          	li	a5,65
8000c6d0:	c4be                	sw	a5,72(sp)
8000c6d2:	e40007b7          	lui	a5,0xe4000
8000c6d6:	c2be                	sw	a5,68(sp)
8000c6d8:	47b6                	lw	a5,76(sp)
8000c6da:	c0be                	sw	a5,64(sp)
8000c6dc:	47a6                	lw	a5,72(sp)
8000c6de:	de3e                	sw	a5,60(sp)

8000c6e0 <.LBB18>:
                                                        uint32_t target,
                                                        uint32_t irq)
{
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_ENABLE_OFFSET +
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
8000c6e0:	4786                	lw	a5,64(sp)
8000c6e2:	00779713          	sll	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
8000c6e6:	4796                	lw	a5,68(sp)
8000c6e8:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
8000c6ea:	57f2                	lw	a5,60(sp)
8000c6ec:	8395                	srl	a5,a5,0x5
8000c6ee:	078a                	sll	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
8000c6f0:	973e                	add	a4,a4,a5
8000c6f2:	6789                	lui	a5,0x2
8000c6f4:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
8000c6f6:	dc3e                	sw	a5,56(sp)
    uint32_t current = *current_ptr;
8000c6f8:	57e2                	lw	a5,56(sp)
8000c6fa:	439c                	lw	a5,0(a5)
8000c6fc:	da3e                	sw	a5,52(sp)
    current = current | (1 << (irq & 0x1F));
8000c6fe:	57f2                	lw	a5,60(sp)
8000c700:	8bfd                	and	a5,a5,31
8000c702:	4705                	li	a4,1
8000c704:	00f717b3          	sll	a5,a4,a5
8000c708:	873e                	mv	a4,a5
8000c70a:	57d2                	lw	a5,52(sp)
8000c70c:	8fd9                	or	a5,a5,a4
8000c70e:	da3e                	sw	a5,52(sp)
    *current_ptr = current;
8000c710:	57e2                	lw	a5,56(sp)
8000c712:	5752                	lw	a4,52(sp)
8000c714:	c398                	sw	a4,0(a5)
}
8000c716:	0001                	nop

8000c718 <.LBE20>:
}
8000c718:	0001                	nop

8000c71a <.LBE18>:
    intc_m_enable_irq_with_priority(DHCP_TIM_IRQ, 1);

    gptmr_start_counter(HPM_GPTMR5, DHCP_TIM_CH);
8000c71a:	4585                	li	a1,1
8000c71c:	f3014537          	lui	a0,0xf3014
8000c720:	3d3d                	jal	8000c55e <gptmr_start_counter>
}
8000c722:	0001                	nop
8000c724:	40f6                	lw	ra,92(sp)
8000c726:	6125                	add	sp,sp,96
8000c728:	8082                	ret

Disassembly of section .text.main:

8000c72a <main>:
SDK_DECLARE_EXT_ISR_M(DHCP_TIM_IRQ, _Timisr)

#endif

int main(void)
{
8000c72a:	1101                	add	sp,sp,-32
8000c72c:	ce06                	sw	ra,28(sp)
    uint8_t tmp;
    uint8_t destip[4] = {192, 168, 0, 113};
8000c72e:	7100b7b7          	lui	a5,0x7100b
8000c732:	8c078793          	add	a5,a5,-1856 # 7100a8c0 <__SHARE_RAM_segment_end__+0x6fe8a8c0>
8000c736:	c43e                	sw	a5,8(sp)

    board_init_clock();
8000c738:	bf3fa0ef          	jal	8000732a <board_init_clock>
    board_init_console();
8000c73c:	243d                	jal	8000c96a <board_init_console>
    board_init_pmp();
8000c73e:	9e3fa0ef          	jal	80007120 <board_init_pmp>

    wizchip_spi_init();
8000c742:	3131                	jal	8000c34e <wizchip_spi_init>
    wizchip_register_port();
8000c744:	367d                	jal	8000c2f2 <wizchip_register_port>
    load_net_parameters();
8000c746:	3591                	jal	8000c58a <load_net_parameters>
    if (ctlwizchip(CW_INIT_WIZCHIP, ar) == -1) {
8000c748:	84018593          	add	a1,gp,-1984 # 1080040 <ar>
8000c74c:	4505                	li	a0,1
8000c74e:	e4bf80ef          	jal	80005598 <ctlwizchip>
8000c752:	87aa                	mv	a5,a0
8000c754:	873e                	mv	a4,a5
8000c756:	57fd                	li	a5,-1
8000c758:	00f71963          	bne	a4,a5,8000c76a <.L17>
        printf("WIZCHIP Initialized fail.\r\n");
8000c75c:	800057b7          	lui	a5,0x80005
8000c760:	8b078513          	add	a0,a5,-1872 # 800048b0 <.LC2>
8000c764:	dacfc0ef          	jal	80008d10 <printf>

8000c768 <.L18>:
        while(1);
8000c768:	a001                	j	8000c768 <.L18>

8000c76a <.L17>:
    }
    do{
        if(ctlwizchip(CW_GET_PHYLINK, (void*)&tmp) == -1){
8000c76a:	00e10793          	add	a5,sp,14
8000c76e:	85be                	mv	a1,a5
8000c770:	453d                	li	a0,15
8000c772:	e27f80ef          	jal	80005598 <ctlwizchip>
8000c776:	87aa                	mv	a5,a0
8000c778:	873e                	mv	a4,a5
8000c77a:	57fd                	li	a5,-1
8000c77c:	00f71a63          	bne	a4,a5,8000c790 <.L19>
            board_delay_ms(10);
8000c780:	4529                	li	a0,10
8000c782:	2e8d                	jal	8000caf4 <board_delay_ms>
            printf("Unknown PHY Link stauts.\r\n");
8000c784:	800057b7          	lui	a5,0x80005
8000c788:	8cc78513          	add	a0,a5,-1844 # 800048cc <.LC3>
8000c78c:	d84fc0ef          	jal	80008d10 <printf>

8000c790 <.L19>:
        }
    }while(tmp == PHY_LINK_OFF);
8000c790:	00e14783          	lbu	a5,14(sp)
8000c794:	dbf9                	beqz	a5,8000c76a <.L17>
    printf("the wiznet chip is:%s \r\n", strtok(_WIZCHIP_STR_, "."));
8000c796:	800057b7          	lui	a5,0x80005
8000c79a:	8e878593          	add	a1,a5,-1816 # 800048e8 <.LC4>
8000c79e:	800057b7          	lui	a5,0x80005
8000c7a2:	8ec78513          	add	a0,a5,-1812 # 800048ec <.LC5>
8000c7a6:	c1efc0ef          	jal	80008bc4 <strtok>
8000c7aa:	87aa                	mv	a5,a0
8000c7ac:	85be                	mv	a1,a5
8000c7ae:	800057b7          	lui	a5,0x80005
8000c7b2:	8f478513          	add	a0,a5,-1804 # 800048f4 <.LC6>
8000c7b6:	d5afc0ef          	jal	80008d10 <printf>
    // setSHAR(g_winznet_info.mac);
#if defined(CONFIG_WIZNET_DCHP) && (CONFIG_WIZNET_DCHP == 1)
    TimInit();
8000c7ba:	3d61                	jal	8000c652 <TimInit>
    /* When dhcp is turned on, the w5100s will have problems receiving and parsing the mac address of the dhcp client
     because the frequency is too high, so the frequency needs to be reduced.*/
    wizchip_spi_change_freq(DHCP_ENABLE_SPI_FREQENCY);
8000c7bc:	009897b7          	lui	a5,0x989
8000c7c0:	68078513          	add	a0,a5,1664 # 989680 <_flash_size+0x189680>
8000c7c4:	31cd                	jal	8000c4a6 <wizchip_spi_change_freq>
    DHCP_init(0, dhcp_buff);
8000c7c6:	85018593          	add	a1,gp,-1968 # 1080050 <dhcp_buff>
8000c7ca:	4501                	li	a0,0
8000c7cc:	d26ff0ef          	jal	8000bcf2 <DHCP_init>
    reg_dhcp_cbfunc(my_ip_assign, my_ip_assign, my_ip_conflict);
8000c7d0:	800077b7          	lui	a5,0x80007
8000c7d4:	01678613          	add	a2,a5,22 # 80007016 <my_ip_conflict>
8000c7d8:	800077b7          	lui	a5,0x80007
8000c7dc:	fca78593          	add	a1,a5,-54 # 80006fca <my_ip_assign>
8000c7e0:	800077b7          	lui	a5,0x80007
8000c7e4:	fca78513          	add	a0,a5,-54 # 80006fca <my_ip_assign>
8000c7e8:	fdefe0ef          	jal	8000afc6 <reg_dhcp_cbfunc>
    uint8_t dhcp_ret = DHCP_run();
8000c7ec:	dfff90ef          	jal	800065ea <DHCP_run>
8000c7f0:	87aa                	mv	a5,a0
8000c7f2:	00f107a3          	sb	a5,15(sp)
    while(dhcp_ret != DHCP_IP_LEASED) {
8000c7f6:	a015                	j	8000c81a <.L20>

8000c7f8 <.L21>:
        printf("dhcp run %d\n",dhcp_ret);
8000c7f8:	00f14783          	lbu	a5,15(sp)
8000c7fc:	85be                	mv	a1,a5
8000c7fe:	800057b7          	lui	a5,0x80005
8000c802:	91078513          	add	a0,a5,-1776 # 80004910 <.LC7>
8000c806:	d0afc0ef          	jal	80008d10 <printf>
        board_delay_ms(1000);
8000c80a:	3e800513          	li	a0,1000
8000c80e:	24dd                	jal	8000caf4 <board_delay_ms>
        dhcp_ret = DHCP_run();
8000c810:	ddbf90ef          	jal	800065ea <DHCP_run>
8000c814:	87aa                	mv	a5,a0
8000c816:	00f107a3          	sb	a5,15(sp)

8000c81a <.L20>:
    while(dhcp_ret != DHCP_IP_LEASED) {
8000c81a:	00f14703          	lbu	a4,15(sp)
8000c81e:	4791                	li	a5,4
8000c820:	fcf71ce3          	bne	a4,a5,8000c7f8 <.L21>
    }
    printf("dhcp ip: \r\n");
8000c824:	800057b7          	lui	a5,0x80005
8000c828:	92078513          	add	a0,a5,-1760 # 80004920 <.LC8>
8000c82c:	ce4fc0ef          	jal	80008d10 <printf>
    printf("SIP: %d.%d.%d.%d\r\n", g_winznet_info.ip[0],g_winznet_info.ip[1],g_winznet_info.ip[2],g_winznet_info.ip[3]);
8000c830:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c834:	0067c783          	lbu	a5,6(a5)
8000c838:	85be                	mv	a1,a5
8000c83a:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c83e:	0077c783          	lbu	a5,7(a5)
8000c842:	863e                	mv	a2,a5
8000c844:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c848:	0087c783          	lbu	a5,8(a5)
8000c84c:	86be                	mv	a3,a5
8000c84e:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c852:	0097c783          	lbu	a5,9(a5)
8000c856:	873e                	mv	a4,a5
8000c858:	800057b7          	lui	a5,0x80005
8000c85c:	92c78513          	add	a0,a5,-1748 # 8000492c <.LC9>
8000c860:	cb0fc0ef          	jal	80008d10 <printf>
    printf("GAR: %d.%d.%d.%d\r\n", g_winznet_info.gw[0],g_winznet_info.gw[1],g_winznet_info.gw[2],g_winznet_info.gw[3]);
8000c864:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c868:	00e7c783          	lbu	a5,14(a5)
8000c86c:	85be                	mv	a1,a5
8000c86e:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c872:	00f7c783          	lbu	a5,15(a5)
8000c876:	863e                	mv	a2,a5
8000c878:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c87c:	0107c783          	lbu	a5,16(a5)
8000c880:	86be                	mv	a3,a5
8000c882:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c886:	0117c783          	lbu	a5,17(a5)
8000c88a:	873e                	mv	a4,a5
8000c88c:	800057b7          	lui	a5,0x80005
8000c890:	94078513          	add	a0,a5,-1728 # 80004940 <.LC10>
8000c894:	c7cfc0ef          	jal	80008d10 <printf>
    printf("SUB: %d.%d.%d.%d\r\n", g_winznet_info.sn[0],g_winznet_info.sn[1],g_winznet_info.sn[2],g_winznet_info.sn[3]);
8000c898:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c89c:	00a7c783          	lbu	a5,10(a5)
8000c8a0:	85be                	mv	a1,a5
8000c8a2:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c8a6:	00b7c783          	lbu	a5,11(a5)
8000c8aa:	863e                	mv	a2,a5
8000c8ac:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c8b0:	00c7c783          	lbu	a5,12(a5)
8000c8b4:	86be                	mv	a3,a5
8000c8b6:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c8ba:	00d7c783          	lbu	a5,13(a5)
8000c8be:	873e                	mv	a4,a5
8000c8c0:	800057b7          	lui	a5,0x80005
8000c8c4:	95478513          	add	a0,a5,-1708 # 80004954 <.LC11>
8000c8c8:	c48fc0ef          	jal	80008d10 <printf>
    printf("DNS: %d.%d.%d.%d\r\n", g_winznet_info.dns[0],g_winznet_info.dns[1],g_winznet_info.dns[2],g_winznet_info.dns[3]);
8000c8cc:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c8d0:	0127c783          	lbu	a5,18(a5)
8000c8d4:	85be                	mv	a1,a5
8000c8d6:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c8da:	0137c783          	lbu	a5,19(a5)
8000c8de:	863e                	mv	a2,a5
8000c8e0:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c8e4:	0147c783          	lbu	a5,20(a5)
8000c8e8:	86be                	mv	a3,a5
8000c8ea:	0e818793          	add	a5,gp,232 # 10808e8 <g_winznet_info>
8000c8ee:	0157c783          	lbu	a5,21(a5)
8000c8f2:	873e                	mv	a4,a5
8000c8f4:	800057b7          	lui	a5,0x80005
8000c8f8:	96878513          	add	a0,a5,-1688 # 80004968 <.LC12>
8000c8fc:	c14fc0ef          	jal	80008d10 <printf>
    memcpy(destip, g_winznet_info.dns, 4);
8000c900:	0038                	add	a4,sp,8
8000c902:	4611                	li	a2,4
8000c904:	0fa18593          	add	a1,gp,250 # 10808fa <g_winznet_info+0x12>
8000c908:	853a                	mv	a0,a4
8000c90a:	9c2fc0ef          	jal	80008acc <memcpy>
    wizchip_spi_change_freq(-1); /* resore the default freq */
8000c90e:	557d                	li	a0,-1
8000c910:	3e59                	jal	8000c4a6 <wizchip_spi_change_freq>
    printf("SIP: %d.%d.%d.%d\r\n", g_winznet_info.ip[0],g_winznet_info.ip[1],g_winznet_info.ip[2],g_winznet_info.ip[3]);
    printf("GAR: %d.%d.%d.%d\r\n", g_winznet_info.gw[0],g_winznet_info.gw[1],g_winznet_info.gw[2],g_winznet_info.gw[3]);
    printf("SUB: %d.%d.%d.%d\r\n", g_winznet_info.sn[0],g_winznet_info.sn[1],g_winznet_info.sn[2],g_winznet_info.sn[3]);
    printf("DNS: %d.%d.%d.%d\r\n", g_winznet_info.dns[0],g_winznet_info.dns[1],g_winznet_info.dns[2],g_winznet_info.dns[3]);
#endif
    memset(tcpc_buff, 0x66, sizeof(tcpc_buff));
8000c912:	08000613          	li	a2,128
8000c916:	06600593          	li	a1,102
8000c91a:	05018513          	add	a0,gp,80 # 1080850 <tcpc_buff>
8000c91e:	250010ef          	jal	8000db6e <memset>

8000c922 <.L22>:
    while (1) {
#if defined(CONFIG_TCP_CLIENT_IPERF) || (CONFIG_TCP_CLIENT_IPERF == 1)
        loopback_tcpc(1, tcpc_buff, destip, 5001);
8000c922:	0038                	add	a4,sp,8
8000c924:	6785                	lui	a5,0x1
8000c926:	38978693          	add	a3,a5,905 # 1389 <__fw_size__+0x389>
8000c92a:	863a                	mv	a2,a4
8000c92c:	05018593          	add	a1,gp,80 # 1080850 <tcpc_buff>
8000c930:	4505                	li	a0,1
8000c932:	bc0f80ef          	jal	80004cf2 <loopback_tcpc>
        board_delay_ms(500);
8000c936:	1f400513          	li	a0,500
8000c93a:	2a6d                	jal	8000caf4 <board_delay_ms>
        loopback_tcpc(1, tcpc_buff, destip, 5001);
8000c93c:	b7dd                	j	8000c922 <.L22>

Disassembly of section .text.sysctl_clock_set_preset:

8000c93e <sysctl_clock_set_preset>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr,
                                           sysctl_preset_t preset)
{
8000c93e:	1141                	add	sp,sp,-16
8000c940:	c62a                	sw	a0,12(sp)
8000c942:	87ae                	mv	a5,a1
8000c944:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_PRESET_MASK)
8000c948:	4732                	lw	a4,12(sp)
8000c94a:	6789                	lui	a5,0x2
8000c94c:	97ba                	add	a5,a5,a4
8000c94e:	439c                	lw	a5,0(a5)
8000c950:	ff07f713          	and	a4,a5,-16
                | SYSCTL_GLOBAL00_PRESET_SET(preset);
8000c954:	00b14783          	lbu	a5,11(sp)
8000c958:	8bbd                	and	a5,a5,15
8000c95a:	8f5d                	or	a4,a4,a5
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_PRESET_MASK)
8000c95c:	46b2                	lw	a3,12(sp)
8000c95e:	6789                	lui	a5,0x2
8000c960:	97b6                	add	a5,a5,a3
8000c962:	c398                	sw	a4,0(a5)
}
8000c964:	0001                	nop
8000c966:	0141                	add	sp,sp,16
8000c968:	8082                	ret

Disassembly of section .text.board_init_console:

8000c96a <board_init_console>:
{
8000c96a:	1101                	add	sp,sp,-32
8000c96c:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
8000c96e:	f0040537          	lui	a0,0xf0040
8000c972:	2099                	jal	8000c9b8 <.LFE405>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
8000c974:	4581                	li	a1,0
8000c976:	012207b7          	lui	a5,0x1220
8000c97a:	01378513          	add	a0,a5,19 # 1220013 <__SHARE_RAM_segment_end__+0xa0013>
8000c97e:	e8bfa0ef          	jal	80007808 <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
8000c982:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t) BOARD_CONSOLE_UART_BASE;
8000c984:	f00407b7          	lui	a5,0xf0040
8000c988:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
8000c98a:	012207b7          	lui	a5,0x1220
8000c98e:	01378513          	add	a0,a5,19 # 1220013 <__SHARE_RAM_segment_end__+0xa0013>
8000c992:	c65fa0ef          	jal	800075f6 <clock_get_frequency>
8000c996:	87aa                	mv	a5,a0
8000c998:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
8000c99a:	67f1                	lui	a5,0x1c
8000c99c:	20078793          	add	a5,a5,512 # 1c200 <__XPI0_segment_used_size__+0x101ac>
8000c9a0:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
8000c9a2:	878a                	mv	a5,sp
8000c9a4:	853e                	mv	a0,a5
8000c9a6:	bfafc0ef          	jal	80008da0 <console_init>
8000c9aa:	87aa                	mv	a5,a0
8000c9ac:	c391                	beqz	a5,8000c9b0 <.L7>

8000c9ae <.L6>:
        while (1) {
8000c9ae:	a001                	j	8000c9ae <.L6>

8000c9b0 <.L7>:
}
8000c9b0:	0001                	nop
8000c9b2:	40f2                	lw	ra,28(sp)
8000c9b4:	6105                	add	sp,sp,32
8000c9b6:	8082                	ret

Disassembly of section .text.init_uart_pins:

8000c9b8 <init_uart_pins>:
{
8000c9b8:	1141                	add	sp,sp,-16
8000c9ba:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
8000c9bc:	4732                	lw	a4,12(sp)
8000c9be:	f00407b7          	lui	a5,0xf0040
8000c9c2:	02f71f63          	bne	a4,a5,8000ca00 <.L9>
        HPM_IOC->PAD[IOC_PAD_PY07].FUNC_CTL = IOC_PY07_FUNC_CTL_UART0_RXD;
8000c9c6:	f4040737          	lui	a4,0xf4040
8000c9ca:	6785                	lui	a5,0x1
8000c9cc:	97ba                	add	a5,a5,a4
8000c9ce:	4709                	li	a4,2
8000c9d0:	e2e7ac23          	sw	a4,-456(a5) # e38 <__NOR_CFG_OPTION_segment_size__+0x238>
        HPM_IOC->PAD[IOC_PAD_PY06].FUNC_CTL = IOC_PY06_FUNC_CTL_UART0_TXD;
8000c9d4:	f4040737          	lui	a4,0xf4040
8000c9d8:	6785                	lui	a5,0x1
8000c9da:	97ba                	add	a5,a5,a4
8000c9dc:	4709                	li	a4,2
8000c9de:	e2e7a823          	sw	a4,-464(a5) # e30 <__NOR_CFG_OPTION_segment_size__+0x230>
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_SOC_PY_07;
8000c9e2:	f40d8737          	lui	a4,0xf40d8
8000c9e6:	6785                	lui	a5,0x1
8000c9e8:	97ba                	add	a5,a5,a4
8000c9ea:	470d                	li	a4,3
8000c9ec:	e2e7ac23          	sw	a4,-456(a5) # e38 <__NOR_CFG_OPTION_segment_size__+0x238>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_SOC_PY_06;
8000c9f0:	f40d8737          	lui	a4,0xf40d8
8000c9f4:	6785                	lui	a5,0x1
8000c9f6:	97ba                	add	a5,a5,a4
8000c9f8:	470d                	li	a4,3
8000c9fa:	e2e7a823          	sw	a4,-464(a5) # e30 <__NOR_CFG_OPTION_segment_size__+0x230>
}
8000c9fe:	a8c5                	j	8000caee <.L15>

8000ca00 <.L9>:
    } else if (ptr == HPM_UART6) {
8000ca00:	4732                	lw	a4,12(sp)
8000ca02:	f00587b7          	lui	a5,0xf0058
8000ca06:	00f71d63          	bne	a4,a5,8000ca20 <.L11>
        HPM_IOC->PAD[IOC_PAD_PE27].FUNC_CTL = IOC_PE27_FUNC_CTL_UART6_RXD;
8000ca0a:	f40407b7          	lui	a5,0xf4040
8000ca0e:	4709                	li	a4,2
8000ca10:	4ce7ac23          	sw	a4,1240(a5) # f40404d8 <__AHB_SRAM_segment_end__+0x3d384d8>
        HPM_IOC->PAD[IOC_PAD_PE28].FUNC_CTL = IOC_PE28_FUNC_CTL_UART6_TXD;
8000ca14:	f40407b7          	lui	a5,0xf4040
8000ca18:	4709                	li	a4,2
8000ca1a:	4ee7a023          	sw	a4,1248(a5) # f40404e0 <__AHB_SRAM_segment_end__+0x3d384e0>
}
8000ca1e:	a8c1                	j	8000caee <.L15>

8000ca20 <.L11>:
    } else if (ptr == HPM_UART7) {
8000ca20:	4732                	lw	a4,12(sp)
8000ca22:	f005c7b7          	lui	a5,0xf005c
8000ca26:	00f71d63          	bne	a4,a5,8000ca40 <.L12>
        HPM_IOC->PAD[IOC_PAD_PC02].FUNC_CTL = IOC_PC02_FUNC_CTL_UART7_RXD;
8000ca2a:	f40407b7          	lui	a5,0xf4040
8000ca2e:	4709                	li	a4,2
8000ca30:	20e7a823          	sw	a4,528(a5) # f4040210 <__AHB_SRAM_segment_end__+0x3d38210>
        HPM_IOC->PAD[IOC_PAD_PC03].FUNC_CTL = IOC_PC03_FUNC_CTL_UART7_TXD;
8000ca34:	f40407b7          	lui	a5,0xf4040
8000ca38:	4709                	li	a4,2
8000ca3a:	20e7ac23          	sw	a4,536(a5) # f4040218 <__AHB_SRAM_segment_end__+0x3d38218>
}
8000ca3e:	a845                	j	8000caee <.L15>

8000ca40 <.L12>:
    } else if (ptr == HPM_UART13) {
8000ca40:	4732                	lw	a4,12(sp)
8000ca42:	f00747b7          	lui	a5,0xf0074
8000ca46:	02f71f63          	bne	a4,a5,8000ca84 <.L13>
        HPM_IOC->PAD[IOC_PAD_PZ08].FUNC_CTL = IOC_PZ08_FUNC_CTL_UART13_RXD;
8000ca4a:	f4040737          	lui	a4,0xf4040
8000ca4e:	6785                	lui	a5,0x1
8000ca50:	97ba                	add	a5,a5,a4
8000ca52:	4709                	li	a4,2
8000ca54:	f4e7a023          	sw	a4,-192(a5) # f40 <__NOR_CFG_OPTION_segment_size__+0x340>
        HPM_IOC->PAD[IOC_PAD_PZ09].FUNC_CTL = IOC_PZ09_FUNC_CTL_UART13_TXD;
8000ca58:	f4040737          	lui	a4,0xf4040
8000ca5c:	6785                	lui	a5,0x1
8000ca5e:	97ba                	add	a5,a5,a4
8000ca60:	4709                	li	a4,2
8000ca62:	f4e7a423          	sw	a4,-184(a5) # f48 <__NOR_CFG_OPTION_segment_size__+0x348>
        HPM_BIOC->PAD[IOC_PAD_PZ08].FUNC_CTL = BIOC_PZ08_FUNC_CTL_SOC_PZ_08;
8000ca66:	f5010737          	lui	a4,0xf5010
8000ca6a:	6785                	lui	a5,0x1
8000ca6c:	97ba                	add	a5,a5,a4
8000ca6e:	470d                	li	a4,3
8000ca70:	f4e7a023          	sw	a4,-192(a5) # f40 <__NOR_CFG_OPTION_segment_size__+0x340>
        HPM_BIOC->PAD[IOC_PAD_PZ09].FUNC_CTL = BIOC_PZ09_FUNC_CTL_SOC_PZ_09;
8000ca74:	f5010737          	lui	a4,0xf5010
8000ca78:	6785                	lui	a5,0x1
8000ca7a:	97ba                	add	a5,a5,a4
8000ca7c:	470d                	li	a4,3
8000ca7e:	f4e7a423          	sw	a4,-184(a5) # f48 <__NOR_CFG_OPTION_segment_size__+0x348>
}
8000ca82:	a0b5                	j	8000caee <.L15>

8000ca84 <.L13>:
    } else if (ptr == HPM_UART14) {
8000ca84:	4732                	lw	a4,12(sp)
8000ca86:	f00787b7          	lui	a5,0xf0078
8000ca8a:	02f71f63          	bne	a4,a5,8000cac8 <.L14>
        HPM_IOC->PAD[IOC_PAD_PZ10].FUNC_CTL = IOC_PZ10_FUNC_CTL_UART14_RXD;
8000ca8e:	f4040737          	lui	a4,0xf4040
8000ca92:	6785                	lui	a5,0x1
8000ca94:	97ba                	add	a5,a5,a4
8000ca96:	4709                	li	a4,2
8000ca98:	f4e7a823          	sw	a4,-176(a5) # f50 <__NOR_CFG_OPTION_segment_size__+0x350>
        HPM_IOC->PAD[IOC_PAD_PZ11].FUNC_CTL = IOC_PZ11_FUNC_CTL_UART14_TXD;
8000ca9c:	f4040737          	lui	a4,0xf4040
8000caa0:	6785                	lui	a5,0x1
8000caa2:	97ba                	add	a5,a5,a4
8000caa4:	4709                	li	a4,2
8000caa6:	f4e7ac23          	sw	a4,-168(a5) # f58 <__NOR_CFG_OPTION_segment_size__+0x358>
        HPM_BIOC->PAD[IOC_PAD_PZ10].FUNC_CTL = BIOC_PZ10_FUNC_CTL_SOC_PZ_10;
8000caaa:	f5010737          	lui	a4,0xf5010
8000caae:	6785                	lui	a5,0x1
8000cab0:	97ba                	add	a5,a5,a4
8000cab2:	470d                	li	a4,3
8000cab4:	f4e7a823          	sw	a4,-176(a5) # f50 <__NOR_CFG_OPTION_segment_size__+0x350>
        HPM_BIOC->PAD[IOC_PAD_PZ11].FUNC_CTL = BIOC_PZ11_FUNC_CTL_SOC_PZ_11;
8000cab8:	f5010737          	lui	a4,0xf5010
8000cabc:	6785                	lui	a5,0x1
8000cabe:	97ba                	add	a5,a5,a4
8000cac0:	470d                	li	a4,3
8000cac2:	f4e7ac23          	sw	a4,-168(a5) # f58 <__NOR_CFG_OPTION_segment_size__+0x358>
}
8000cac6:	a025                	j	8000caee <.L15>

8000cac8 <.L14>:
    } else if (ptr == HPM_PUART) {
8000cac8:	4732                	lw	a4,12(sp)
8000caca:	f40e47b7          	lui	a5,0xf40e4
8000cace:	02f71063          	bne	a4,a5,8000caee <.L15>
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_PUART_RXD;
8000cad2:	f40d8737          	lui	a4,0xf40d8
8000cad6:	6785                	lui	a5,0x1
8000cad8:	97ba                	add	a5,a5,a4
8000cada:	4705                	li	a4,1
8000cadc:	e2e7ac23          	sw	a4,-456(a5) # e38 <__NOR_CFG_OPTION_segment_size__+0x238>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_PUART_TXD;
8000cae0:	f40d8737          	lui	a4,0xf40d8
8000cae4:	6785                	lui	a5,0x1
8000cae6:	97ba                	add	a5,a5,a4
8000cae8:	4705                	li	a4,1
8000caea:	e2e7a823          	sw	a4,-464(a5) # e30 <__NOR_CFG_OPTION_segment_size__+0x230>

8000caee <.L15>:
}
8000caee:	0001                	nop
8000caf0:	0141                	add	sp,sp,16
8000caf2:	8082                	ret

Disassembly of section .text.board_delay_ms:

8000caf4 <board_delay_ms>:
{
8000caf4:	1101                	add	sp,sp,-32
8000caf6:	ce06                	sw	ra,28(sp)
8000caf8:	c62a                	sw	a0,12(sp)
    clock_cpu_delay_ms(ms);
8000cafa:	4532                	lw	a0,12(sp)
8000cafc:	d47fa0ef          	jal	80007842 <clock_cpu_delay_ms>
}
8000cb00:	0001                	nop
8000cb02:	40f2                	lw	ra,28(sp)
8000cb04:	6105                	add	sp,sp,32
8000cb06:	8082                	ret

Disassembly of section .text._clean_up:

8000cb08 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
8000cb08:	7139                	add	sp,sp,-64

8000cb0a <.LBB18>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000cb0a:	6785                	lui	a5,0x1
8000cb0c:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x402>
8000cb10:	3047b073          	csrc	mie,a5
}
8000cb14:	0001                	nop
8000cb16:	da02                	sw	zero,52(sp)
8000cb18:	d802                	sw	zero,48(sp)
8000cb1a:	e40007b7          	lui	a5,0xe4000
8000cb1e:	d63e                	sw	a5,44(sp)
8000cb20:	57d2                	lw	a5,52(sp)
8000cb22:	d43e                	sw	a5,40(sp)
8000cb24:	57c2                	lw	a5,48(sp)
8000cb26:	d23e                	sw	a5,36(sp)

8000cb28 <.LBB20>:
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
8000cb28:	57a2                	lw	a5,40(sp)
8000cb2a:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
8000cb2e:	57b2                	lw	a5,44(sp)
8000cb30:	973e                	add	a4,a4,a5
8000cb32:	002007b7          	lui	a5,0x200
8000cb36:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
8000cb38:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
8000cb3a:	5782                	lw	a5,32(sp)
8000cb3c:	5712                	lw	a4,36(sp)
8000cb3e:	c398                	sw	a4,0(a5)
}
8000cb40:	0001                	nop

8000cb42 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
8000cb42:	0001                	nop

8000cb44 <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
8000cb44:	de02                	sw	zero,60(sp)
8000cb46:	a82d                	j	8000cb80 <.L2>

8000cb48 <.L3>:
8000cb48:	ce02                	sw	zero,28(sp)
8000cb4a:	57f2                	lw	a5,60(sp)
8000cb4c:	cc3e                	sw	a5,24(sp)
8000cb4e:	e40007b7          	lui	a5,0xe4000
8000cb52:	ca3e                	sw	a5,20(sp)
8000cb54:	47f2                	lw	a5,28(sp)
8000cb56:	c83e                	sw	a5,16(sp)
8000cb58:	47e2                	lw	a5,24(sp)
8000cb5a:	c63e                	sw	a5,12(sp)

8000cb5c <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
8000cb5c:	47c2                	lw	a5,16(sp)
8000cb5e:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
8000cb62:	47d2                	lw	a5,20(sp)
8000cb64:	973e                	add	a4,a4,a5
8000cb66:	002007b7          	lui	a5,0x200
8000cb6a:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_end__+0x140004>
8000cb6c:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
8000cb6e:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
8000cb70:	47a2                	lw	a5,8(sp)
8000cb72:	4732                	lw	a4,12(sp)
8000cb74:	c398                	sw	a4,0(a5)
}
8000cb76:	0001                	nop

8000cb78 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
8000cb78:	0001                	nop

8000cb7a <.LBE25>:
8000cb7a:	57f2                	lw	a5,60(sp)
8000cb7c:	0785                	add	a5,a5,1
8000cb7e:	de3e                	sw	a5,60(sp)

8000cb80 <.L2>:
8000cb80:	5772                	lw	a4,60(sp)
8000cb82:	07f00793          	li	a5,127
8000cb86:	fce7f1e3          	bgeu	a5,a4,8000cb48 <.L3>

8000cb8a <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
8000cb8a:	dc02                	sw	zero,56(sp)
8000cb8c:	a821                	j	8000cba4 <.L4>

8000cb8e <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
8000cb8e:	57e2                	lw	a5,56(sp)
8000cb90:	00279713          	sll	a4,a5,0x2
8000cb94:	e40027b7          	lui	a5,0xe4002
8000cb98:	97ba                	add	a5,a5,a4
8000cb9a:	0007a023          	sw	zero,0(a5) # e4002000 <__XPI0_segment_end__+0x63802000>
    for (uint32_t i = 0; i < 4; i++) {
8000cb9e:	57e2                	lw	a5,56(sp)
8000cba0:	0785                	add	a5,a5,1
8000cba2:	dc3e                	sw	a5,56(sp)

8000cba4 <.L4>:
8000cba4:	5762                	lw	a4,56(sp)
8000cba6:	478d                	li	a5,3
8000cba8:	fee7f3e3          	bgeu	a5,a4,8000cb8e <.L5>

8000cbac <.LBE29>:
    }
}
8000cbac:	0001                	nop
8000cbae:	0001                	nop
8000cbb0:	6121                	add	sp,sp,64
8000cbb2:	8082                	ret

Disassembly of section .text.reset_handler:

8000cbb4 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
8000cbb4:	1141                	add	sp,sp,-16
8000cbb6:	c606                	sw	ra,12(sp)
    fencei();
8000cbb8:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
8000cbbc:	f5ffa0ef          	jal	80007b1a <system_init>

    /* Entry function */
    MAIN_ENTRY();
8000cbc0:	36ad                	jal	8000c72a <main>
}
8000cbc2:	0001                	nop
8000cbc4:	40b2                	lw	ra,12(sp)
8000cbc6:	0141                	add	sp,sp,16
8000cbc8:	8082                	ret

Disassembly of section .text._init:

8000cbca <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
8000cbca:	0001                	nop
8000cbcc:	8082                	ret

Disassembly of section .text.mchtmr_isr:

8000cbce <mchtmr_isr>:
}
8000cbce:	0001                	nop
8000cbd0:	8082                	ret

Disassembly of section .text.swi_isr:

8000cbd2 <swi_isr>:
}
8000cbd2:	0001                	nop
8000cbd4:	8082                	ret

Disassembly of section .text.exception_handler:

8000cbd6 <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
8000cbd6:	1141                	add	sp,sp,-16
8000cbd8:	c62a                	sw	a0,12(sp)
8000cbda:	c42e                	sw	a1,8(sp)
    switch (cause) {
8000cbdc:	4732                	lw	a4,12(sp)
8000cbde:	47bd                	li	a5,15
8000cbe0:	00e7ec63          	bltu	a5,a4,8000cbf8 <.L23>
8000cbe4:	47b2                	lw	a5,12(sp)
8000cbe6:	00279713          	sll	a4,a5,0x2
8000cbea:	800037b7          	lui	a5,0x80003
8000cbee:	31478793          	add	a5,a5,788 # 80003314 <.L7>
8000cbf2:	97ba                	add	a5,a5,a4
8000cbf4:	439c                	lw	a5,0(a5)
8000cbf6:	8782                	jr	a5

8000cbf8 <.L23>:
        case MCAUSE_LOAD_PAGE_FAULT:
            break;
        case MCAUSE_STORE_AMO_PAGE_FAULT:
            break;
        default:
            break;
8000cbf8:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
8000cbfa:	47a2                	lw	a5,8(sp)
}
8000cbfc:	853e                	mv	a0,a5
8000cbfe:	0141                	add	sp,sp,16
8000cc00:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

8000cc02 <get_frequency_for_source>:
{
8000cc02:	7179                	add	sp,sp,-48
8000cc04:	d606                	sw	ra,44(sp)
8000cc06:	87aa                	mv	a5,a0
8000cc08:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
8000cc0c:	ce02                	sw	zero,28(sp)
    uint32_t div = 1;
8000cc0e:	4785                	li	a5,1
8000cc10:	cc3e                	sw	a5,24(sp)
    switch (source) {
8000cc12:	00f14783          	lbu	a5,15(sp)
8000cc16:	471d                	li	a4,7
8000cc18:	0cf76e63          	bltu	a4,a5,8000ccf4 <.L36>
8000cc1c:	00279713          	sll	a4,a5,0x2
8000cc20:	800037b7          	lui	a5,0x80003
8000cc24:	3a078793          	add	a5,a5,928 # 800033a0 <.L38>
8000cc28:	97ba                	add	a5,a5,a4
8000cc2a:	439c                	lw	a5,0(a5)
8000cc2c:	8782                	jr	a5

8000cc2e <.L45>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
8000cc2e:	016e37b7          	lui	a5,0x16e3
8000cc32:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000cc36:	ce3e                	sw	a5,28(sp)
        break;
8000cc38:	a0c1                	j	8000ccf8 <.L46>

8000cc3a <.L44>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 0U);
8000cc3a:	4581                	li	a1,0
8000cc3c:	f4100537          	lui	a0,0xf4100
8000cc40:	f78fc0ef          	jal	800093b8 <pllctl_get_pll_freq_in_hz>
8000cc44:	ce2a                	sw	a0,28(sp)
        break;
8000cc46:	a84d                	j	8000ccf8 <.L46>

8000cc48 <.L43>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 0);
8000cc48:	4601                	li	a2,0
8000cc4a:	4585                	li	a1,1
8000cc4c:	f4100537          	lui	a0,0xf4100
8000cc50:	93dfa0ef          	jal	8000758c <pllctl_get_div>
8000cc54:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
8000cc56:	4585                	li	a1,1
8000cc58:	f4100537          	lui	a0,0xf4100
8000cc5c:	f5cfc0ef          	jal	800093b8 <pllctl_get_pll_freq_in_hz>
8000cc60:	872a                	mv	a4,a0
8000cc62:	47e2                	lw	a5,24(sp)
8000cc64:	02f757b3          	divu	a5,a4,a5
8000cc68:	ce3e                	sw	a5,28(sp)
        break;
8000cc6a:	a079                	j	8000ccf8 <.L46>

8000cc6c <.L42>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 1);
8000cc6c:	4605                	li	a2,1
8000cc6e:	4585                	li	a1,1
8000cc70:	f4100537          	lui	a0,0xf4100
8000cc74:	919fa0ef          	jal	8000758c <pllctl_get_div>
8000cc78:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
8000cc7a:	4585                	li	a1,1
8000cc7c:	f4100537          	lui	a0,0xf4100
8000cc80:	f38fc0ef          	jal	800093b8 <pllctl_get_pll_freq_in_hz>
8000cc84:	872a                	mv	a4,a0
8000cc86:	47e2                	lw	a5,24(sp)
8000cc88:	02f757b3          	divu	a5,a4,a5
8000cc8c:	ce3e                	sw	a5,28(sp)
        break;
8000cc8e:	a0ad                	j	8000ccf8 <.L46>

8000cc90 <.L41>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 0);
8000cc90:	4601                	li	a2,0
8000cc92:	4589                	li	a1,2
8000cc94:	f4100537          	lui	a0,0xf4100
8000cc98:	8f5fa0ef          	jal	8000758c <pllctl_get_div>
8000cc9c:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
8000cc9e:	4589                	li	a1,2
8000cca0:	f4100537          	lui	a0,0xf4100
8000cca4:	f14fc0ef          	jal	800093b8 <pllctl_get_pll_freq_in_hz>
8000cca8:	872a                	mv	a4,a0
8000ccaa:	47e2                	lw	a5,24(sp)
8000ccac:	02f757b3          	divu	a5,a4,a5
8000ccb0:	ce3e                	sw	a5,28(sp)
        break;
8000ccb2:	a099                	j	8000ccf8 <.L46>

8000ccb4 <.L40>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 1);
8000ccb4:	4605                	li	a2,1
8000ccb6:	4589                	li	a1,2
8000ccb8:	f4100537          	lui	a0,0xf4100
8000ccbc:	8d1fa0ef          	jal	8000758c <pllctl_get_div>
8000ccc0:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
8000ccc2:	4589                	li	a1,2
8000ccc4:	f4100537          	lui	a0,0xf4100
8000ccc8:	ef0fc0ef          	jal	800093b8 <pllctl_get_pll_freq_in_hz>
8000cccc:	872a                	mv	a4,a0
8000ccce:	47e2                	lw	a5,24(sp)
8000ccd0:	02f757b3          	divu	a5,a4,a5
8000ccd4:	ce3e                	sw	a5,28(sp)
        break;
8000ccd6:	a00d                	j	8000ccf8 <.L46>

8000ccd8 <.L39>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 3U);
8000ccd8:	458d                	li	a1,3
8000ccda:	f4100537          	lui	a0,0xf4100
8000ccde:	edafc0ef          	jal	800093b8 <pllctl_get_pll_freq_in_hz>
8000cce2:	ce2a                	sw	a0,28(sp)
        break;
8000cce4:	a811                	j	8000ccf8 <.L46>

8000cce6 <.L37>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 4U);
8000cce6:	4591                	li	a1,4
8000cce8:	f4100537          	lui	a0,0xf4100
8000ccec:	eccfc0ef          	jal	800093b8 <pllctl_get_pll_freq_in_hz>
8000ccf0:	ce2a                	sw	a0,28(sp)
        break;
8000ccf2:	a019                	j	8000ccf8 <.L46>

8000ccf4 <.L36>:
        clk_freq = 0UL;
8000ccf4:	ce02                	sw	zero,28(sp)
        break;
8000ccf6:	0001                	nop

8000ccf8 <.L46>:
    return clk_freq;
8000ccf8:	47f2                	lw	a5,28(sp)
}
8000ccfa:	853e                	mv	a0,a5
8000ccfc:	50b2                	lw	ra,44(sp)
8000ccfe:	6145                	add	sp,sp,48
8000cd00:	8082                	ret

Disassembly of section .text.get_frequency_for_i2s_or_adc:

8000cd02 <get_frequency_for_i2s_or_adc>:
{
8000cd02:	7139                	add	sp,sp,-64
8000cd04:	de06                	sw	ra,60(sp)
8000cd06:	c62a                	sw	a0,12(sp)
8000cd08:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
8000cd0a:	d602                	sw	zero,44(sp)
    bool is_mux_valid = false;
8000cd0c:	020105a3          	sb	zero,43(sp)
    clock_node_t node = clock_node_end;
8000cd10:	04b00793          	li	a5,75
8000cd14:	02f10523          	sb	a5,42(sp)
    if (clk_src_type == CLK_SRC_GROUP_ADC) {
8000cd18:	4732                	lw	a4,12(sp)
8000cd1a:	4785                	li	a5,1
8000cd1c:	04f71563          	bne	a4,a5,8000cd66 <.L52>

8000cd20 <.LBB7>:
        uint32_t adc_index = instance;
8000cd20:	47a2                	lw	a5,8(sp)
8000cd22:	ce3e                	sw	a5,28(sp)
        if (adc_index < ADC_INSTANCE_NUM) {
8000cd24:	4772                	lw	a4,28(sp)
8000cd26:	478d                	li	a5,3
8000cd28:	08e7e163          	bltu	a5,a4,8000cdaa <.L53>

8000cd2c <.LBB8>:
            uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
8000cd2c:	f4000737          	lui	a4,0xf4000
8000cd30:	47f2                	lw	a5,28(sp)
8000cd32:	70078793          	add	a5,a5,1792
8000cd36:	078a                	sll	a5,a5,0x2
8000cd38:	97ba                	add	a5,a5,a4
8000cd3a:	439c                	lw	a5,0(a5)
8000cd3c:	83a1                	srl	a5,a5,0x8
8000cd3e:	8b9d                	and	a5,a5,7
8000cd40:	cc3e                	sw	a5,24(sp)
            if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
8000cd42:	4762                	lw	a4,24(sp)
8000cd44:	478d                	li	a5,3
8000cd46:	06e7e263          	bltu	a5,a4,8000cdaa <.L53>
                node = s_adc_clk_mux_node[mux_in_reg];
8000cd4a:	800037b7          	lui	a5,0x80003
8000cd4e:	35478713          	add	a4,a5,852 # 80003354 <s_adc_clk_mux_node>
8000cd52:	47e2                	lw	a5,24(sp)
8000cd54:	97ba                	add	a5,a5,a4
8000cd56:	0007c783          	lbu	a5,0(a5)
8000cd5a:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
8000cd5e:	4785                	li	a5,1
8000cd60:	02f105a3          	sb	a5,43(sp)
8000cd64:	a099                	j	8000cdaa <.L53>

8000cd66 <.L52>:
        uint32_t i2s_index = instance;
8000cd66:	47a2                	lw	a5,8(sp)
8000cd68:	d23e                	sw	a5,36(sp)
        if (i2s_index < I2S_INSTANCE_NUM) {
8000cd6a:	5712                	lw	a4,36(sp)
8000cd6c:	478d                	li	a5,3
8000cd6e:	02e7ee63          	bltu	a5,a4,8000cdaa <.L53>

8000cd72 <.LBB10>:
            uint32_t mux_in_reg = SYSCTL_I2SCLK_MUX_GET(HPM_SYSCTL->I2SCLK[i2s_index]);
8000cd72:	f4000737          	lui	a4,0xf4000
8000cd76:	5792                	lw	a5,36(sp)
8000cd78:	70478793          	add	a5,a5,1796
8000cd7c:	078a                	sll	a5,a5,0x2
8000cd7e:	97ba                	add	a5,a5,a4
8000cd80:	439c                	lw	a5,0(a5)
8000cd82:	83a1                	srl	a5,a5,0x8
8000cd84:	8b9d                	and	a5,a5,7
8000cd86:	d03e                	sw	a5,32(sp)
            if (mux_in_reg < ARRAY_SIZE(s_i2s_clk_mux_node)) {
8000cd88:	5702                	lw	a4,32(sp)
8000cd8a:	478d                	li	a5,3
8000cd8c:	00e7ef63          	bltu	a5,a4,8000cdaa <.L53>
                node = s_i2s_clk_mux_node[mux_in_reg];
8000cd90:	800037b7          	lui	a5,0x80003
8000cd94:	35878713          	add	a4,a5,856 # 80003358 <s_i2s_clk_mux_node>
8000cd98:	5782                	lw	a5,32(sp)
8000cd9a:	97ba                	add	a5,a5,a4
8000cd9c:	0007c783          	lbu	a5,0(a5)
8000cda0:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
8000cda4:	4785                	li	a5,1
8000cda6:	02f105a3          	sb	a5,43(sp)

8000cdaa <.L53>:
    if (is_mux_valid) {
8000cdaa:	02b14783          	lbu	a5,43(sp)
8000cdae:	c38d                	beqz	a5,8000cdd0 <.L54>
        if (node == clock_node_ahb0) {
8000cdb0:	02a14703          	lbu	a4,42(sp)
8000cdb4:	479d                	li	a5,7
8000cdb6:	00f71763          	bne	a4,a5,8000cdc4 <.L55>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000cdba:	451d                	li	a0,7
8000cdbc:	903fa0ef          	jal	800076be <get_frequency_for_ip_in_common_group>
8000cdc0:	d62a                	sw	a0,44(sp)
8000cdc2:	a039                	j	8000cdd0 <.L54>

8000cdc4 <.L55>:
            clk_freq = get_frequency_for_ip_in_common_group(node);
8000cdc4:	02a14783          	lbu	a5,42(sp)
8000cdc8:	853e                	mv	a0,a5
8000cdca:	8f5fa0ef          	jal	800076be <get_frequency_for_ip_in_common_group>
8000cdce:	d62a                	sw	a0,44(sp)

8000cdd0 <.L54>:
    return clk_freq;
8000cdd0:	57b2                	lw	a5,44(sp)
}
8000cdd2:	853e                	mv	a0,a5
8000cdd4:	50f2                	lw	ra,60(sp)
8000cdd6:	6121                	add	sp,sp,64
8000cdd8:	8082                	ret

Disassembly of section .text.get_frequency_for_wdg:

8000cdda <get_frequency_for_wdg>:
{
8000cdda:	7179                	add	sp,sp,-48
8000cddc:	d606                	sw	ra,44(sp)
8000cdde:	c62a                	sw	a0,12(sp)
    if (WDG_CTRL_CLKSEL_GET(s_wdgs[instance]->CTRL) == 0) {
8000cde0:	800037b7          	lui	a5,0x80003
8000cde4:	35c78713          	add	a4,a5,860 # 8000335c <s_wdgs>
8000cde8:	47b2                	lw	a5,12(sp)
8000cdea:	078a                	sll	a5,a5,0x2
8000cdec:	97ba                	add	a5,a5,a4
8000cdee:	439c                	lw	a5,0(a5)
8000cdf0:	4b9c                	lw	a5,16(a5)
8000cdf2:	8b89                	and	a5,a5,2
8000cdf4:	e791                	bnez	a5,8000ce00 <.L58>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000cdf6:	451d                	li	a0,7
8000cdf8:	8c7fa0ef          	jal	800076be <get_frequency_for_ip_in_common_group>
8000cdfc:	ce2a                	sw	a0,28(sp)
8000cdfe:	a019                	j	8000ce04 <.L59>

8000ce00 <.L58>:
        freq_in_hz = FREQ_32KHz;
8000ce00:	67a1                	lui	a5,0x8
8000ce02:	ce3e                	sw	a5,28(sp)

8000ce04 <.L59>:
    return freq_in_hz;
8000ce04:	47f2                	lw	a5,28(sp)
}
8000ce06:	853e                	mv	a0,a5
8000ce08:	50b2                	lw	ra,44(sp)
8000ce0a:	6145                	add	sp,sp,48
8000ce0c:	8082                	ret

Disassembly of section .text.get_frequency_for_pwdg:

8000ce0e <get_frequency_for_pwdg>:
{
8000ce0e:	1141                	add	sp,sp,-16
    if (WDG_CTRL_CLKSEL_GET(HPM_PWDG->CTRL) == 0) {
8000ce10:	f40e87b7          	lui	a5,0xf40e8
8000ce14:	4b9c                	lw	a5,16(a5)
8000ce16:	8b89                	and	a5,a5,2
8000ce18:	e799                	bnez	a5,8000ce26 <.L62>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
8000ce1a:	016e37b7          	lui	a5,0x16e3
8000ce1e:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000ce22:	c63e                	sw	a5,12(sp)
8000ce24:	a019                	j	8000ce2a <.L63>

8000ce26 <.L62>:
        freq_in_hz = FREQ_32KHz;
8000ce26:	67a1                	lui	a5,0x8
8000ce28:	c63e                	sw	a5,12(sp)

8000ce2a <.L63>:
    return freq_in_hz;
8000ce2a:	47b2                	lw	a5,12(sp)
}
8000ce2c:	853e                	mv	a0,a5
8000ce2e:	0141                	add	sp,sp,16
8000ce30:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

8000ce32 <clock_connect_group_to_cpu>:
{
8000ce32:	1141                	add	sp,sp,-16
8000ce34:	c62a                	sw	a0,12(sp)
8000ce36:	c42e                	sw	a1,8(sp)
    if (cpu < 2U) {
8000ce38:	4722                	lw	a4,8(sp)
8000ce3a:	4785                	li	a5,1
8000ce3c:	00e7ee63          	bltu	a5,a4,8000ce58 <.L173>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
8000ce40:	f40006b7          	lui	a3,0xf4000
8000ce44:	47b2                	lw	a5,12(sp)
8000ce46:	4705                	li	a4,1
8000ce48:	00f71733          	sll	a4,a4,a5
8000ce4c:	47a2                	lw	a5,8(sp)
8000ce4e:	09078793          	add	a5,a5,144 # 8090 <__AHB_SRAM_segment_size__+0x90>
8000ce52:	0792                	sll	a5,a5,0x4
8000ce54:	97b6                	add	a5,a5,a3
8000ce56:	c3d8                	sw	a4,4(a5)

8000ce58 <.L173>:
}
8000ce58:	0001                	nop
8000ce5a:	0141                	add	sp,sp,16
8000ce5c:	8082                	ret

Disassembly of section .text.clock_get_core_clock_ticks_per_ms:

8000ce5e <clock_get_core_clock_ticks_per_ms>:
{
8000ce5e:	1141                	add	sp,sp,-16
8000ce60:	c606                	sw	ra,12(sp)
    if (hpm_core_clock == 0U) {
8000ce62:	1241a783          	lw	a5,292(gp) # 1080924 <hpm_core_clock>
8000ce66:	e399                	bnez	a5,8000ce6c <.L181>
        clock_update_core_clock();
8000ce68:	a6dfa0ef          	jal	800078d4 <clock_update_core_clock>

8000ce6c <.L181>:
    return (hpm_core_clock + FREQ_1MHz - 1U) / 1000;
8000ce6c:	1241a703          	lw	a4,292(gp) # 1080924 <hpm_core_clock>
8000ce70:	000f47b7          	lui	a5,0xf4
8000ce74:	23f78793          	add	a5,a5,575 # f423f <__DLM_segment_end__+0x3423f>
8000ce78:	973e                	add	a4,a4,a5
8000ce7a:	3e800793          	li	a5,1000
8000ce7e:	02f757b3          	divu	a5,a4,a5
}
8000ce82:	853e                	mv	a0,a5
8000ce84:	40b2                	lw	ra,12(sp)
8000ce86:	0141                	add	sp,sp,16
8000ce88:	8082                	ret

Disassembly of section .text.l1c_op:

8000ce8a <l1c_op>:
{
8000ce8a:	7139                	add	sp,sp,-64
8000ce8c:	de22                	sw	s0,60(sp)
8000ce8e:	dc26                	sw	s1,56(sp)
8000ce90:	da4a                	sw	s2,52(sp)
8000ce92:	87aa                	mv	a5,a0
8000ce94:	c42e                	sw	a1,8(sp)
8000ce96:	c232                	sw	a2,4(sp)
8000ce98:	00f107a3          	sb	a5,15(sp)

8000ce9c <.LBB45>:
    csr = read_clear_csr(CSR_MSTATUS, CSR_MSTATUS_MIE_MASK);
8000ce9c:	cc02                	sw	zero,24(sp)
8000ce9e:	47a1                	li	a5,8
8000cea0:	3007b7f3          	csrrc	a5,mstatus,a5
8000cea4:	cc3e                	sw	a5,24(sp)
8000cea6:	47e2                	lw	a5,24(sp)

8000cea8 <.LBE45>:
8000cea8:	893e                	mv	s2,a5

8000ceaa <.LBB46>:
    if ((read_csr(CSR_MMSC_CFG) & CCTL_VERSION)) {
8000ceaa:	fc2027f3          	csrr	a5,0xfc2
8000ceae:	d63e                	sw	a5,44(sp)
8000ceb0:	5732                	lw	a4,44(sp)

8000ceb2 <.LBE46>:
8000ceb2:	000c07b7          	lui	a5,0xc0
8000ceb6:	8ff9                	and	a5,a5,a4
8000ceb8:	c3a9                	beqz	a5,8000cefa <.L2>
8000ceba:	47a2                	lw	a5,8(sp)
8000cebc:	d43e                	sw	a5,40(sp)

8000cebe <.LBB47>:
    (uint32_t)(((x) << HPM_MCCTLBEGINADDR_WAY_SHIFT) & HPM_MCCTLBEGINADDR_WAY_MASK)

/* send IX command */
__attribute__((always_inline)) static inline void l1c_cctl_address(uint32_t address)
{
    write_csr(CSR_MCCTLBEGINADDR, address);
8000cebe:	57a2                	lw	a5,40(sp)
8000cec0:	7cb79073          	csrw	0x7cb,a5
}
8000cec4:	0001                	nop

8000cec6 <.LBE47>:
        next_address = address;
8000cec6:	4422                	lw	s0,8(sp)
        while ((next_address < (address + size)) && (next_address >= address)) {
8000cec8:	a005                	j	8000cee8 <.L3>

8000ceca <.L6>:
8000ceca:	00f14783          	lbu	a5,15(sp)
8000cece:	02f101a3          	sb	a5,35(sp)

8000ced2 <.LBB49>:

/* send command */
__attribute__((always_inline)) static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
8000ced2:	02314783          	lbu	a5,35(sp)
8000ced6:	7cc79073          	csrw	0x7cc,a5
}
8000ceda:	0001                	nop

8000cedc <.LBB51>:

__attribute__((always_inline)) static inline uint32_t l1c_cctl_get_address(void)
{
    return read_csr(CSR_MCCTLBEGINADDR);
8000cedc:	7cb027f3          	csrr	a5,0x7cb
8000cee0:	d23e                	sw	a5,36(sp)
8000cee2:	5792                	lw	a5,36(sp)

8000cee4 <.LBE53>:
8000cee4:	0001                	nop

8000cee6 <.LBE51>:
            next_address = l1c_cctl_get_address();
8000cee6:	843e                	mv	s0,a5

8000cee8 <.L3>:
        while ((next_address < (address + size)) && (next_address >= address)) {
8000cee8:	4722                	lw	a4,8(sp)
8000ceea:	4792                	lw	a5,4(sp)
8000ceec:	97ba                	add	a5,a5,a4
8000ceee:	04f47063          	bgeu	s0,a5,8000cf2e <.L5>
8000cef2:	47a2                	lw	a5,8(sp)
8000cef4:	fcf47be3          	bgeu	s0,a5,8000ceca <.L6>
8000cef8:	a81d                	j	8000cf2e <.L5>

8000cefa <.L2>:
        for (i = 0, tmp = 0; tmp < size; i++) {
8000cefa:	4481                	li	s1,0
8000cefc:	4401                	li	s0,0
8000cefe:	a02d                	j	8000cf28 <.L7>

8000cf00 <.L8>:
            l1c_cctl_address_cmd(opcode, address + i * HPM_L1C_CACHELINE_SIZE);
8000cf00:	00649713          	sll	a4,s1,0x6
8000cf04:	47a2                	lw	a5,8(sp)
8000cf06:	97ba                	add	a5,a5,a4
8000cf08:	00f14703          	lbu	a4,15(sp)
8000cf0c:	02e10123          	sb	a4,34(sp)
8000cf10:	ce3e                	sw	a5,28(sp)

8000cf12 <.LBB54>:

/* send IX command */
__attribute__((always_inline)) static inline
    void l1c_cctl_address_cmd(uint8_t cmd, uint32_t address)
{
    write_csr(CSR_MCCTLBEGINADDR, address);
8000cf12:	47f2                	lw	a5,28(sp)
8000cf14:	7cb79073          	csrw	0x7cb,a5
    write_csr(CSR_MCCTLCOMMAND, cmd);
8000cf18:	02214783          	lbu	a5,34(sp)
8000cf1c:	7cc79073          	csrw	0x7cc,a5
}
8000cf20:	0001                	nop

8000cf22 <.LBE54>:
            tmp += HPM_L1C_CACHELINE_SIZE;
8000cf22:	04040413          	add	s0,s0,64
        for (i = 0, tmp = 0; tmp < size; i++) {
8000cf26:	0485                	add	s1,s1,1

8000cf28 <.L7>:
8000cf28:	4792                	lw	a5,4(sp)
8000cf2a:	fcf46be3          	bltu	s0,a5,8000cf00 <.L8>

8000cf2e <.L5>:
    write_csr(CSR_MSTATUS, csr);
8000cf2e:	30091073          	csrw	mstatus,s2
}
8000cf32:	0001                	nop
8000cf34:	5472                	lw	s0,60(sp)
8000cf36:	54e2                	lw	s1,56(sp)
8000cf38:	5952                	lw	s2,52(sp)
8000cf3a:	6121                	add	sp,sp,64
8000cf3c:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

8000cf3e <l1c_dc_invalidate_all>:
{
8000cf3e:	1141                	add	sp,sp,-16
8000cf40:	47dd                	li	a5,23
8000cf42:	00f107a3          	sb	a5,15(sp)

8000cf46 <.LBB76>:
    write_csr(CSR_MCCTLCOMMAND, cmd);
8000cf46:	00f14783          	lbu	a5,15(sp)
8000cf4a:	7cc79073          	csrw	0x7cc,a5
}
8000cf4e:	0001                	nop

8000cf50 <.LBE76>:
}
8000cf50:	0001                	nop
8000cf52:	0141                	add	sp,sp,16
8000cf54:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

8000cf56 <sysctl_enable_group_resource>:
{
8000cf56:	7179                	add	sp,sp,-48
8000cf58:	d606                	sw	ra,44(sp)
8000cf5a:	c62a                	sw	a0,12(sp)
8000cf5c:	87ae                	mv	a5,a1
8000cf5e:	8736                	mv	a4,a3
8000cf60:	00f105a3          	sb	a5,11(sp)
8000cf64:	87b2                	mv	a5,a2
8000cf66:	00f11423          	sh	a5,8(sp)
8000cf6a:	87ba                	mv	a5,a4
8000cf6c:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
8000cf70:	00815703          	lhu	a4,8(sp)
8000cf74:	0ff00793          	li	a5,255
8000cf78:	00e7e463          	bltu	a5,a4,8000cf80 <.L60>
        return status_invalid_argument;
8000cf7c:	4789                	li	a5,2
8000cf7e:	a8e5                	j	8000d076 <.L61>

8000cf80 <.L60>:
    index = (resource - sysctl_resource_linkable_start) / 32;
8000cf80:	00815783          	lhu	a5,8(sp)
8000cf84:	f0078793          	add	a5,a5,-256 # bff00 <__heap_end__+0x3bf00>
8000cf88:	41f7d713          	sra	a4,a5,0x1f
8000cf8c:	8b7d                	and	a4,a4,31
8000cf8e:	97ba                	add	a5,a5,a4
8000cf90:	8795                	sra	a5,a5,0x5
8000cf92:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
8000cf94:	00815783          	lhu	a5,8(sp)
8000cf98:	f0078713          	add	a4,a5,-256
8000cf9c:	41f75793          	sra	a5,a4,0x1f
8000cfa0:	83ed                	srl	a5,a5,0x1b
8000cfa2:	973e                	add	a4,a4,a5
8000cfa4:	8b7d                	and	a4,a4,31
8000cfa6:	40f707b3          	sub	a5,a4,a5
8000cfaa:	cc3e                	sw	a5,24(sp)
    switch (group) {
8000cfac:	00b14783          	lbu	a5,11(sp)
8000cfb0:	c789                	beqz	a5,8000cfba <.L62>
8000cfb2:	4705                	li	a4,1
8000cfb4:	04e78f63          	beq	a5,a4,8000d012 <.L63>
8000cfb8:	a84d                	j	8000d06a <.L74>

8000cfba <.L62>:
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
8000cfba:	4732                	lw	a4,12(sp)
8000cfbc:	47f2                	lw	a5,28(sp)
8000cfbe:	08078793          	add	a5,a5,128
8000cfc2:	0792                	sll	a5,a5,0x4
8000cfc4:	97ba                	add	a5,a5,a4
8000cfc6:	4398                	lw	a4,0(a5)
8000cfc8:	47e2                	lw	a5,24(sp)
8000cfca:	4685                	li	a3,1
8000cfcc:	00f697b3          	sll	a5,a3,a5
8000cfd0:	fff7c793          	not	a5,a5
8000cfd4:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
8000cfd6:	00a14783          	lbu	a5,10(sp)
8000cfda:	c791                	beqz	a5,8000cfe6 <.L65>
8000cfdc:	47e2                	lw	a5,24(sp)
8000cfde:	4685                	li	a3,1
8000cfe0:	00f697b3          	sll	a5,a3,a5
8000cfe4:	a011                	j	8000cfe8 <.L66>

8000cfe6 <.L65>:
8000cfe6:	4781                	li	a5,0

8000cfe8 <.L66>:
8000cfe8:	8f5d                	or	a4,a4,a5
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
8000cfea:	46b2                	lw	a3,12(sp)
8000cfec:	47f2                	lw	a5,28(sp)
8000cfee:	08078793          	add	a5,a5,128
8000cff2:	0792                	sll	a5,a5,0x4
8000cff4:	97b6                	add	a5,a5,a3
8000cff6:	c398                	sw	a4,0(a5)
        if (enable) {
8000cff8:	00a14783          	lbu	a5,10(sp)
8000cffc:	cbad                	beqz	a5,8000d06e <.L75>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
8000cffe:	0001                	nop

8000d000 <.L68>:
8000d000:	00815783          	lhu	a5,8(sp)
8000d004:	85be                	mv	a1,a5
8000d006:	4532                	lw	a0,12(sp)
8000d008:	a19fa0ef          	jal	80007a20 <sysctl_resource_target_is_busy>
8000d00c:	87aa                	mv	a5,a0
8000d00e:	fbed                	bnez	a5,8000d000 <.L68>
        break;
8000d010:	a8b9                	j	8000d06e <.L75>

8000d012 <.L63>:
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
8000d012:	4732                	lw	a4,12(sp)
8000d014:	47f2                	lw	a5,28(sp)
8000d016:	08478793          	add	a5,a5,132
8000d01a:	0792                	sll	a5,a5,0x4
8000d01c:	97ba                	add	a5,a5,a4
8000d01e:	4398                	lw	a4,0(a5)
8000d020:	47e2                	lw	a5,24(sp)
8000d022:	4685                	li	a3,1
8000d024:	00f697b3          	sll	a5,a3,a5
8000d028:	fff7c793          	not	a5,a5
8000d02c:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
8000d02e:	00a14783          	lbu	a5,10(sp)
8000d032:	c791                	beqz	a5,8000d03e <.L70>
8000d034:	47e2                	lw	a5,24(sp)
8000d036:	4685                	li	a3,1
8000d038:	00f697b3          	sll	a5,a3,a5
8000d03c:	a011                	j	8000d040 <.L71>

8000d03e <.L70>:
8000d03e:	4781                	li	a5,0

8000d040 <.L71>:
8000d040:	8f5d                	or	a4,a4,a5
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
8000d042:	46b2                	lw	a3,12(sp)
8000d044:	47f2                	lw	a5,28(sp)
8000d046:	08478793          	add	a5,a5,132
8000d04a:	0792                	sll	a5,a5,0x4
8000d04c:	97b6                	add	a5,a5,a3
8000d04e:	c398                	sw	a4,0(a5)
        if (enable) {
8000d050:	00a14783          	lbu	a5,10(sp)
8000d054:	cf99                	beqz	a5,8000d072 <.L76>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
8000d056:	0001                	nop

8000d058 <.L73>:
8000d058:	00815783          	lhu	a5,8(sp)
8000d05c:	85be                	mv	a1,a5
8000d05e:	4532                	lw	a0,12(sp)
8000d060:	9c1fa0ef          	jal	80007a20 <sysctl_resource_target_is_busy>
8000d064:	87aa                	mv	a5,a0
8000d066:	fbed                	bnez	a5,8000d058 <.L73>
        break;
8000d068:	a029                	j	8000d072 <.L76>

8000d06a <.L74>:
        return status_invalid_argument;
8000d06a:	4789                	li	a5,2
8000d06c:	a029                	j	8000d076 <.L61>

8000d06e <.L75>:
        break;
8000d06e:	0001                	nop
8000d070:	a011                	j	8000d074 <.L69>

8000d072 <.L76>:
        break;
8000d072:	0001                	nop

8000d074 <.L69>:
    return status_success;
8000d074:	4781                	li	a5,0

8000d076 <.L61>:
}
8000d076:	853e                	mv	a0,a5
8000d078:	50b2                	lw	ra,44(sp)
8000d07a:	6145                	add	sp,sp,48
8000d07c:	8082                	ret

Disassembly of section .text.enable_plic_feature:

8000d07e <enable_plic_feature>:
{
8000d07e:	1141                	add	sp,sp,-16
    uint32_t plic_feature = 0;
8000d080:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
8000d082:	47b2                	lw	a5,12(sp)
8000d084:	0027e793          	or	a5,a5,2
8000d088:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
8000d08a:	47b2                	lw	a5,12(sp)
8000d08c:	0017e793          	or	a5,a5,1
8000d090:	c63e                	sw	a5,12(sp)
8000d092:	e40007b7          	lui	a5,0xe4000
8000d096:	c43e                	sw	a5,8(sp)
8000d098:	47b2                	lw	a5,12(sp)
8000d09a:	c23e                	sw	a5,4(sp)

8000d09c <.LBB14>:
 * @param[in] feature Specific feature to be set
 *
 */
ATTR_ALWAYS_INLINE static inline void __plic_set_feature(uint32_t base, uint32_t feature)
{
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
8000d09c:	47a2                	lw	a5,8(sp)
8000d09e:	4712                	lw	a4,4(sp)
8000d0a0:	c398                	sw	a4,0(a5)
}
8000d0a2:	0001                	nop

8000d0a4 <.LBE14>:
}
8000d0a4:	0001                	nop
8000d0a6:	0141                	add	sp,sp,16
8000d0a8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

8000d0aa <__SEGGER_RTL_puts_no_nl>:
8000d0aa:	1101                	add	sp,sp,-32
8000d0ac:	cc22                	sw	s0,24(sp)
8000d0ae:	1701a403          	lw	s0,368(gp) # 1080970 <stdout>
8000d0b2:	ce06                	sw	ra,28(sp)
8000d0b4:	c62a                	sw	a0,12(sp)
8000d0b6:	321000ef          	jal	8000dbd6 <strlen>
8000d0ba:	862a                	mv	a2,a0
8000d0bc:	8522                	mv	a0,s0
8000d0be:	4462                	lw	s0,24(sp)
8000d0c0:	45b2                	lw	a1,12(sp)
8000d0c2:	40f2                	lw	ra,28(sp)
8000d0c4:	6105                	add	sp,sp,32
8000d0c6:	d3bfb06f          	j	80008e00 <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.signal:

8000d0ca <signal>:
8000d0ca:	4795                	li	a5,5
8000d0cc:	02a7e263          	bltu	a5,a0,8000d0f0 <.L18>
8000d0d0:	0d018693          	add	a3,gp,208 # 10808d0 <__SEGGER_RTL_aSigTab>
8000d0d4:	00251793          	sll	a5,a0,0x2
8000d0d8:	96be                	add	a3,a3,a5
8000d0da:	4288                	lw	a0,0(a3)
8000d0dc:	0d018713          	add	a4,gp,208 # 10808d0 <__SEGGER_RTL_aSigTab>
8000d0e0:	e509                	bnez	a0,8000d0ea <.L17>
8000d0e2:	80003537          	lui	a0,0x80003
8000d0e6:	07a50513          	add	a0,a0,122 # 8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>

8000d0ea <.L17>:
8000d0ea:	973e                	add	a4,a4,a5
8000d0ec:	c30c                	sw	a1,0(a4)
8000d0ee:	8082                	ret

8000d0f0 <.L18>:
8000d0f0:	80008537          	lui	a0,0x80008
8000d0f4:	bfc50513          	add	a0,a0,-1028 # 80007bfc <__SEGGER_RTL_SIGNAL_SIG_ERR>
8000d0f8:	8082                	ret

Disassembly of section .text.libc.raise:

8000d0fa <raise>:
8000d0fa:	1141                	add	sp,sp,-16
8000d0fc:	c04a                	sw	s2,0(sp)
8000d0fe:	80008937          	lui	s2,0x80008
8000d102:	bfa90593          	add	a1,s2,-1030 # 80007bfa <__SEGGER_RTL_SIGNAL_SIG_IGN>
8000d106:	c226                	sw	s1,4(sp)
8000d108:	c606                	sw	ra,12(sp)
8000d10a:	c422                	sw	s0,8(sp)
8000d10c:	84aa                	mv	s1,a0
8000d10e:	3f75                	jal	8000d0ca <signal>
8000d110:	800087b7          	lui	a5,0x80008
8000d114:	bfc78793          	add	a5,a5,-1028 # 80007bfc <__SEGGER_RTL_SIGNAL_SIG_ERR>
8000d118:	02f50d63          	beq	a0,a5,8000d152 <.L24>
8000d11c:	bfa90913          	add	s2,s2,-1030
8000d120:	842a                	mv	s0,a0
8000d122:	03250163          	beq	a0,s2,8000d144 <.L22>
8000d126:	800035b7          	lui	a1,0x80003
8000d12a:	07a58793          	add	a5,a1,122 # 8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>
8000d12e:	00f51563          	bne	a0,a5,8000d138 <.L23>
8000d132:	4505                	li	a0,1
8000d134:	f3bf50ef          	jal	8000306e <exit>

8000d138 <.L23>:
8000d138:	07a58593          	add	a1,a1,122
8000d13c:	8526                	mv	a0,s1
8000d13e:	3771                	jal	8000d0ca <signal>
8000d140:	8526                	mv	a0,s1
8000d142:	9402                	jalr	s0

8000d144 <.L22>:
8000d144:	4501                	li	a0,0

8000d146 <.L20>:
8000d146:	40b2                	lw	ra,12(sp)
8000d148:	4422                	lw	s0,8(sp)
8000d14a:	4492                	lw	s1,4(sp)
8000d14c:	4902                	lw	s2,0(sp)
8000d14e:	0141                	add	sp,sp,16
8000d150:	8082                	ret

8000d152 <.L24>:
8000d152:	557d                	li	a0,-1
8000d154:	bfcd                	j	8000d146 <.L20>

Disassembly of section .text.libc.abort:

8000d156 <abort>:
8000d156:	1141                	add	sp,sp,-16
8000d158:	c606                	sw	ra,12(sp)

8000d15a <.L27>:
8000d15a:	4501                	li	a0,0
8000d15c:	3f79                	jal	8000d0fa <raise>
8000d15e:	bff5                	j	8000d15a <.L27>

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

8000d160 <__SEGGER_RTL_X_assert>:
8000d160:	1101                	add	sp,sp,-32
8000d162:	cc22                	sw	s0,24(sp)
8000d164:	ca26                	sw	s1,20(sp)
8000d166:	842a                	mv	s0,a0
8000d168:	84ae                	mv	s1,a1
8000d16a:	8532                	mv	a0,a2
8000d16c:	858a                	mv	a1,sp
8000d16e:	4629                	li	a2,10
8000d170:	ce06                	sw	ra,28(sp)
8000d172:	a6dfa0ef          	jal	80007bde <itoa>
8000d176:	8526                	mv	a0,s1
8000d178:	3f0d                	jal	8000d0aa <__SEGGER_RTL_puts_no_nl>
8000d17a:	80004537          	lui	a0,0x80004
8000d17e:	d9050513          	add	a0,a0,-624 # 80003d90 <.LC0>
8000d182:	3725                	jal	8000d0aa <__SEGGER_RTL_puts_no_nl>
8000d184:	850a                	mv	a0,sp
8000d186:	3715                	jal	8000d0aa <__SEGGER_RTL_puts_no_nl>
8000d188:	80004537          	lui	a0,0x80004
8000d18c:	d9450513          	add	a0,a0,-620 # 80003d94 <.LC1>
8000d190:	3f29                	jal	8000d0aa <__SEGGER_RTL_puts_no_nl>
8000d192:	8522                	mv	a0,s0
8000d194:	3f19                	jal	8000d0aa <__SEGGER_RTL_puts_no_nl>
8000d196:	80004537          	lui	a0,0x80004
8000d19a:	dac50513          	add	a0,a0,-596 # 80003dac <.LC2>
8000d19e:	3731                	jal	8000d0aa <__SEGGER_RTL_puts_no_nl>
8000d1a0:	3f5d                	jal	8000d156 <abort>

Disassembly of section .text.libc.__adddf3:

8000d1a2 <__adddf3>:
8000d1a2:	800007b7          	lui	a5,0x80000
8000d1a6:	00d5c8b3          	xor	a7,a1,a3
8000d1aa:	1008c263          	bltz	a7,8000d2ae <.L__adddf3_subtract>
8000d1ae:	00b6e863          	bltu	a3,a1,8000d1be <.L__adddf3_add_already_ordered>
8000d1b2:	8d31                	xor	a0,a0,a2
8000d1b4:	8e29                	xor	a2,a2,a0
8000d1b6:	8d31                	xor	a0,a0,a2
8000d1b8:	8db5                	xor	a1,a1,a3
8000d1ba:	8ead                	xor	a3,a3,a1
8000d1bc:	8db5                	xor	a1,a1,a3

8000d1be <.L__adddf3_add_already_ordered>:
8000d1be:	00159813          	sll	a6,a1,0x1
8000d1c2:	01585813          	srl	a6,a6,0x15
8000d1c6:	00169893          	sll	a7,a3,0x1
8000d1ca:	0158d893          	srl	a7,a7,0x15
8000d1ce:	0c088063          	beqz	a7,8000d28e <.L__adddf3_add_zero>
8000d1d2:	00180713          	add	a4,a6,1
8000d1d6:	0756                	sll	a4,a4,0x15
8000d1d8:	c759                	beqz	a4,8000d266 <.L__adddf3_done>
8000d1da:	41180733          	sub	a4,a6,a7
8000d1de:	03500293          	li	t0,53
8000d1e2:	08e2e263          	bltu	t0,a4,8000d266 <.L__adddf3_done>
8000d1e6:	0145d813          	srl	a6,a1,0x14
8000d1ea:	06ae                	sll	a3,a3,0xb
8000d1ec:	8edd                	or	a3,a3,a5
8000d1ee:	82ad                	srl	a3,a3,0xb
8000d1f0:	05ae                	sll	a1,a1,0xb
8000d1f2:	8ddd                	or	a1,a1,a5
8000d1f4:	85ad                	sra	a1,a1,0xb
8000d1f6:	02000293          	li	t0,32
8000d1fa:	06577763          	bgeu	a4,t0,8000d268 <.L__adddf3_add_shifted_word>
8000d1fe:	4881                	li	a7,0
8000d200:	cf01                	beqz	a4,8000d218 <.L__adddf3_add_no_shift>
8000d202:	40e002b3          	neg	t0,a4
8000d206:	005618b3          	sll	a7,a2,t0
8000d20a:	00e65633          	srl	a2,a2,a4
8000d20e:	005692b3          	sll	t0,a3,t0
8000d212:	9616                	add	a2,a2,t0
8000d214:	00e6d6b3          	srl	a3,a3,a4

8000d218 <.L__adddf3_add_no_shift>:
8000d218:	9532                	add	a0,a0,a2
8000d21a:	00c532b3          	sltu	t0,a0,a2
8000d21e:	95b6                	add	a1,a1,a3
8000d220:	00d5b333          	sltu	t1,a1,a3
8000d224:	9596                	add	a1,a1,t0
8000d226:	00031463          	bnez	t1,8000d22e <.L__adddf3_normalization_required>
8000d22a:	0255f163          	bgeu	a1,t0,8000d24c <.L__adddf3_already_normalized>

8000d22e <.L__adddf3_normalization_required>:
8000d22e:	00280613          	add	a2,a6,2
8000d232:	0656                	sll	a2,a2,0x15
8000d234:	c235                	beqz	a2,8000d298 <.L__adddf3_inf>
8000d236:	01f51613          	sll	a2,a0,0x1f
8000d23a:	011032b3          	snez	t0,a7
8000d23e:	005608b3          	add	a7,a2,t0
8000d242:	8105                	srl	a0,a0,0x1
8000d244:	01f59693          	sll	a3,a1,0x1f
8000d248:	8d55                	or	a0,a0,a3
8000d24a:	8185                	srl	a1,a1,0x1

8000d24c <.L__adddf3_already_normalized>:
8000d24c:	0805                	add	a6,a6,1
8000d24e:	0852                	sll	a6,a6,0x14

8000d250 <.L__adddf3_perform_rounding>:
8000d250:	0008da63          	bgez	a7,8000d264 <.L__adddf3_add_no_tie>
8000d254:	0505                	add	a0,a0,1
8000d256:	00153293          	seqz	t0,a0
8000d25a:	9596                	add	a1,a1,t0
8000d25c:	0886                	sll	a7,a7,0x1
8000d25e:	00089363          	bnez	a7,8000d264 <.L__adddf3_add_no_tie>
8000d262:	9979                	and	a0,a0,-2

8000d264 <.L__adddf3_add_no_tie>:
8000d264:	95c2                	add	a1,a1,a6

8000d266 <.L__adddf3_done>:
8000d266:	8082                	ret

8000d268 <.L__adddf3_add_shifted_word>:
8000d268:	88b2                	mv	a7,a2
8000d26a:	1701                	add	a4,a4,-32 # f3ffffe0 <__AHB_SRAM_segment_end__+0x3cf7fe0>
8000d26c:	cb11                	beqz	a4,8000d280 <.L__adddf3_already_aligned>
8000d26e:	40e008b3          	neg	a7,a4
8000d272:	011698b3          	sll	a7,a3,a7
8000d276:	00e6d6b3          	srl	a3,a3,a4
8000d27a:	00c03733          	snez	a4,a2
8000d27e:	98ba                	add	a7,a7,a4

8000d280 <.L__adddf3_already_aligned>:
8000d280:	9536                	add	a0,a0,a3
8000d282:	00d532b3          	sltu	t0,a0,a3
8000d286:	9596                	add	a1,a1,t0
8000d288:	fc55f2e3          	bgeu	a1,t0,8000d24c <.L__adddf3_already_normalized>
8000d28c:	b74d                	j	8000d22e <.L__adddf3_normalization_required>

8000d28e <.L__adddf3_add_zero>:
8000d28e:	fc081ce3          	bnez	a6,8000d266 <.L__adddf3_done>
8000d292:	8dfd                	and	a1,a1,a5
8000d294:	4501                	li	a0,0
8000d296:	bfc1                	j	8000d266 <.L__adddf3_done>

8000d298 <.L__adddf3_inf>:
8000d298:	0805                	add	a6,a6,1
8000d29a:	01481593          	sll	a1,a6,0x14
8000d29e:	4501                	li	a0,0
8000d2a0:	b7d9                	j	8000d266 <.L__adddf3_done>

8000d2a2 <.L__adddf3_sub_inf_nan>:
8000d2a2:	fce892e3          	bne	a7,a4,8000d266 <.L__adddf3_done>
8000d2a6:	7ff805b7          	lui	a1,0x7ff80
8000d2aa:	4501                	li	a0,0
8000d2ac:	bf6d                	j	8000d266 <.L__adddf3_done>

8000d2ae <.L__adddf3_subtract>:
8000d2ae:	8ebd                	xor	a3,a3,a5
8000d2b0:	00b6ed63          	bltu	a3,a1,8000d2ca <.L__adddf3_sub_already_ordered>
8000d2b4:	00b69463          	bne	a3,a1,8000d2bc <.L__adddf3_sub_must_exchange>
8000d2b8:	00a66963          	bltu	a2,a0,8000d2ca <.L__adddf3_sub_already_ordered>

8000d2bc <.L__adddf3_sub_must_exchange>:
8000d2bc:	8ebd                	xor	a3,a3,a5
8000d2be:	8d31                	xor	a0,a0,a2
8000d2c0:	8e29                	xor	a2,a2,a0
8000d2c2:	8d31                	xor	a0,a0,a2
8000d2c4:	8db5                	xor	a1,a1,a3
8000d2c6:	8ead                	xor	a3,a3,a1
8000d2c8:	8db5                	xor	a1,a1,a3

8000d2ca <.L__adddf3_sub_already_ordered>:
8000d2ca:	00b58833          	add	a6,a1,a1
8000d2ce:	00d688b3          	add	a7,a3,a3
8000d2d2:	ffe00737          	lui	a4,0xffe00
8000d2d6:	fce876e3          	bgeu	a6,a4,8000d2a2 <.L__adddf3_sub_inf_nan>
8000d2da:	01585813          	srl	a6,a6,0x15
8000d2de:	0158d893          	srl	a7,a7,0x15
8000d2e2:	0a088f63          	beqz	a7,8000d3a0 <.L__adddf3_subtracting_zero>
8000d2e6:	41180733          	sub	a4,a6,a7
8000d2ea:	03600293          	li	t0,54
8000d2ee:	f6e2ece3          	bltu	t0,a4,8000d266 <.L__adddf3_done>
8000d2f2:	83c2                	mv	t2,a6
8000d2f4:	0145d813          	srl	a6,a1,0x14
8000d2f8:	06ae                	sll	a3,a3,0xb
8000d2fa:	8edd                	or	a3,a3,a5
8000d2fc:	82ad                	srl	a3,a3,0xb
8000d2fe:	05ae                	sll	a1,a1,0xb
8000d300:	8ddd                	or	a1,a1,a5
8000d302:	81ad                	srl	a1,a1,0xb
8000d304:	4285                	li	t0,1
8000d306:	0ae2ef63          	bltu	t0,a4,8000d3c4 <.L__adddf3_sub_align_far>
8000d30a:	00571a63          	bne	a4,t0,8000d31e <.L__adddf3_sub_already_aligned>
8000d30e:	01f61713          	sll	a4,a2,0x1f
8000d312:	8205                	srl	a2,a2,0x1
8000d314:	01f69893          	sll	a7,a3,0x1f
8000d318:	01166633          	or	a2,a2,a7
8000d31c:	8285                	srl	a3,a3,0x1

8000d31e <.L__adddf3_sub_already_aligned>:
8000d31e:	82aa                	mv	t0,a0
8000d320:	8d11                	sub	a0,a0,a2
8000d322:	00a2b2b3          	sltu	t0,t0,a0
8000d326:	8d95                	sub	a1,a1,a3
8000d328:	405585b3          	sub	a1,a1,t0
8000d32c:	c711                	beqz	a4,8000d338 <.L__adddf3_sub_single_done>
8000d32e:	00153293          	seqz	t0,a0
8000d332:	157d                	add	a0,a0,-1
8000d334:	405585b3          	sub	a1,a1,t0

8000d338 <.L__adddf3_sub_single_done>:
8000d338:	c9ad                	beqz	a1,8000d3aa <.L__adddf3_high_word_cancelled>
8000d33a:	00b59293          	sll	t0,a1,0xb
8000d33e:	1202ca63          	bltz	t0,8000d472 <.L__adddf3_sub_normalized>

8000d342 <.L__adddf3_first_normalization_step>:
8000d342:	000522b3          	sltz	t0,a0
8000d346:	952a                	add	a0,a0,a0
8000d348:	95ae                	add	a1,a1,a1
8000d34a:	9596                	add	a1,a1,t0
8000d34c:	837d                	srl	a4,a4,0x1f
8000d34e:	953a                	add	a0,a0,a4
8000d350:	4705                	li	a4,1

8000d352 <.L__adddf3_try_shift_4>:
8000d352:	0115d293          	srl	t0,a1,0x11
8000d356:	00029963          	bnez	t0,8000d368 <.L__adddf3_cant_shift_4>
8000d35a:	0711                	add	a4,a4,4 # ffe00004 <__APB_SRAM_segment_end__+0xbd0e004>
8000d35c:	0592                	sll	a1,a1,0x4
8000d35e:	01c55293          	srl	t0,a0,0x1c
8000d362:	0512                	sll	a0,a0,0x4
8000d364:	9596                	add	a1,a1,t0
8000d366:	b7f5                	j	8000d352 <.L__adddf3_try_shift_4>

8000d368 <.L__adddf3_cant_shift_4>:
8000d368:	00b59293          	sll	t0,a1,0xb
8000d36c:	0002cc63          	bltz	t0,8000d384 <.L__adddf3_normalized>

8000d370 <.L__adddf3_normalize>:
8000d370:	0705                	add	a4,a4,1
8000d372:	000522b3          	sltz	t0,a0
8000d376:	952a                	add	a0,a0,a0
8000d378:	95ae                	add	a1,a1,a1
8000d37a:	9596                	add	a1,a1,t0

8000d37c <.L__adddf3_pre_normalize>:
8000d37c:	00b59293          	sll	t0,a1,0xb
8000d380:	fe02d8e3          	bgez	t0,8000d370 <.L__adddf3_normalize>

8000d384 <.L__adddf3_normalized>:
8000d384:	861e                	mv	a2,t2
8000d386:	00c77863          	bgeu	a4,a2,8000d396 <.L__adddf3_signed_zero>
8000d38a:	40e80833          	sub	a6,a6,a4
8000d38e:	187d                	add	a6,a6,-1
8000d390:	0852                	sll	a6,a6,0x14
8000d392:	95c2                	add	a1,a1,a6
8000d394:	bdc9                	j	8000d266 <.L__adddf3_done>

8000d396 <.L__adddf3_signed_zero>:
8000d396:	00b85593          	srl	a1,a6,0xb
8000d39a:	05fe                	sll	a1,a1,0x1f
8000d39c:	4501                	li	a0,0
8000d39e:	b5e1                	j	8000d266 <.L__adddf3_done>

8000d3a0 <.L__adddf3_subtracting_zero>:
8000d3a0:	ec0813e3          	bnez	a6,8000d266 <.L__adddf3_done>
8000d3a4:	4501                	li	a0,0
8000d3a6:	4581                	li	a1,0
8000d3a8:	bd7d                	j	8000d266 <.L__adddf3_done>

8000d3aa <.L__adddf3_high_word_cancelled>:
8000d3aa:	00e56633          	or	a2,a0,a4
8000d3ae:	ea060ce3          	beqz	a2,8000d266 <.L__adddf3_done>
8000d3b2:	001008b7          	lui	a7,0x100
8000d3b6:	f91576e3          	bgeu	a0,a7,8000d342 <.L__adddf3_first_normalization_step>
8000d3ba:	85aa                	mv	a1,a0
8000d3bc:	853a                	mv	a0,a4
8000d3be:	02000713          	li	a4,32
8000d3c2:	bf6d                	j	8000d37c <.L__adddf3_pre_normalize>

8000d3c4 <.L__adddf3_sub_align_far>:
8000d3c4:	02000293          	li	t0,32
8000d3c8:	04574863          	blt	a4,t0,8000d418 <.L__adddf3_aligned_on_top>
8000d3cc:	04570263          	beq	a4,t0,8000d410 <.L__adddf3_word_aligned_on_top>
8000d3d0:	1701                	add	a4,a4,-32
8000d3d2:	40e002b3          	neg	t0,a4
8000d3d6:	00e65333          	srl	t1,a2,a4
8000d3da:	005618b3          	sll	a7,a2,t0
8000d3de:	00569633          	sll	a2,a3,t0
8000d3e2:	961a                	add	a2,a2,t1
8000d3e4:	00e6d6b3          	srl	a3,a3,a4
8000d3e8:	011038b3          	snez	a7,a7
8000d3ec:	00c8e8b3          	or	a7,a7,a2
8000d3f0:	4601                	li	a2,0
8000d3f2:	82aa                	mv	t0,a0
8000d3f4:	8d15                	sub	a0,a0,a3
8000d3f6:	00a2b2b3          	sltu	t0,t0,a0
8000d3fa:	405585b3          	sub	a1,a1,t0
8000d3fe:	41100733          	neg	a4,a7
8000d402:	c729                	beqz	a4,8000d44c <.L__adddf3_sub_normalize>
8000d404:	00153293          	seqz	t0,a0
8000d408:	157d                	add	a0,a0,-1
8000d40a:	405585b3          	sub	a1,a1,t0
8000d40e:	a83d                	j	8000d44c <.L__adddf3_sub_normalize>

8000d410 <.L__adddf3_word_aligned_on_top>:
8000d410:	88b2                	mv	a7,a2
8000d412:	8636                	mv	a2,a3
8000d414:	4681                	li	a3,0
8000d416:	a821                	j	8000d42e <.L__adddf3_aligned_subtract>

8000d418 <.L__adddf3_aligned_on_top>:
8000d418:	40e002b3          	neg	t0,a4
8000d41c:	00e65333          	srl	t1,a2,a4
8000d420:	005618b3          	sll	a7,a2,t0
8000d424:	00569633          	sll	a2,a3,t0
8000d428:	961a                	add	a2,a2,t1
8000d42a:	00e6d6b3          	srl	a3,a3,a4

8000d42e <.L__adddf3_aligned_subtract>:
8000d42e:	82aa                	mv	t0,a0
8000d430:	8d11                	sub	a0,a0,a2
8000d432:	00a2b2b3          	sltu	t0,t0,a0
8000d436:	8d95                	sub	a1,a1,a3
8000d438:	405585b3          	sub	a1,a1,t0
8000d43c:	41100733          	neg	a4,a7
8000d440:	c711                	beqz	a4,8000d44c <.L__adddf3_sub_normalize>
8000d442:	00153293          	seqz	t0,a0
8000d446:	157d                	add	a0,a0,-1
8000d448:	405585b3          	sub	a1,a1,t0

8000d44c <.L__adddf3_sub_normalize>:
8000d44c:	00c59893          	sll	a7,a1,0xc
8000d450:	00b59293          	sll	t0,a1,0xb
8000d454:	0002cf63          	bltz	t0,8000d472 <.L__adddf3_sub_normalized>
8000d458:	187d                	add	a6,a6,-1
8000d45a:	000522b3          	sltz	t0,a0
8000d45e:	952a                	add	a0,a0,a0
8000d460:	95ae                	add	a1,a1,a1
8000d462:	9596                	add	a1,a1,t0
8000d464:	000722b3          	sltz	t0,a4
8000d468:	973a                	add	a4,a4,a4
8000d46a:	9516                	add	a0,a0,t0
8000d46c:	005532b3          	sltu	t0,a0,t0
8000d470:	9596                	add	a1,a1,t0

8000d472 <.L__adddf3_sub_normalized>:
8000d472:	187d                	add	a6,a6,-1
8000d474:	0852                	sll	a6,a6,0x14
8000d476:	88ba                	mv	a7,a4
8000d478:	bbe1                	j	8000d250 <.L__adddf3_perform_rounding>

Disassembly of section .text.libc.__mulsf3:

8000d47a <__mulsf3>:
8000d47a:	80000737          	lui	a4,0x80000
8000d47e:	0ff00293          	li	t0,255
8000d482:	00b547b3          	xor	a5,a0,a1
8000d486:	8ff9                	and	a5,a5,a4
8000d488:	00151613          	sll	a2,a0,0x1
8000d48c:	8261                	srl	a2,a2,0x18
8000d48e:	00159693          	sll	a3,a1,0x1
8000d492:	82e1                	srl	a3,a3,0x18
8000d494:	ce29                	beqz	a2,8000d4ee <.L__mulsf3_lhs_zero_or_subnormal>
8000d496:	c6bd                	beqz	a3,8000d504 <.L__mulsf3_rhs_zero_or_subnormal>
8000d498:	04560f63          	beq	a2,t0,8000d4f6 <.L__mulsf3_lhs_inf_or_nan>
8000d49c:	06568963          	beq	a3,t0,8000d50e <.L__mulsf3_rhs_inf_or_nan>
8000d4a0:	9636                	add	a2,a2,a3
8000d4a2:	0522                	sll	a0,a0,0x8
8000d4a4:	8d59                	or	a0,a0,a4
8000d4a6:	05a2                	sll	a1,a1,0x8
8000d4a8:	8dd9                	or	a1,a1,a4
8000d4aa:	02b506b3          	mul	a3,a0,a1
8000d4ae:	02b53533          	mulhu	a0,a0,a1
8000d4b2:	00d036b3          	snez	a3,a3
8000d4b6:	8d55                	or	a0,a0,a3
8000d4b8:	00054463          	bltz	a0,8000d4c0 <.L__mulsf3_normalized>
8000d4bc:	0506                	sll	a0,a0,0x1
8000d4be:	167d                	add	a2,a2,-1

8000d4c0 <.L__mulsf3_normalized>:
8000d4c0:	f8160613          	add	a2,a2,-127
8000d4c4:	04064863          	bltz	a2,8000d514 <.L__mulsf3_zero_or_underflow>
8000d4c8:	12fd                	add	t0,t0,-1 # ffffffff <__APB_SRAM_segment_end__+0xbf0dfff>
8000d4ca:	00565f63          	bge	a2,t0,8000d4e8 <.L__mulsf3_inf>
8000d4ce:	01851693          	sll	a3,a0,0x18
8000d4d2:	8121                	srl	a0,a0,0x8
8000d4d4:	065e                	sll	a2,a2,0x17
8000d4d6:	9532                	add	a0,a0,a2
8000d4d8:	0006d663          	bgez	a3,8000d4e4 <.L__mulsf3_apply_sign>
8000d4dc:	0505                	add	a0,a0,1
8000d4de:	0686                	sll	a3,a3,0x1
8000d4e0:	e291                	bnez	a3,8000d4e4 <.L__mulsf3_apply_sign>
8000d4e2:	9979                	and	a0,a0,-2

8000d4e4 <.L__mulsf3_apply_sign>:
8000d4e4:	8d5d                	or	a0,a0,a5
8000d4e6:	8082                	ret

8000d4e8 <.L__mulsf3_inf>:
8000d4e8:	7f800537          	lui	a0,0x7f800
8000d4ec:	bfe5                	j	8000d4e4 <.L__mulsf3_apply_sign>

8000d4ee <.L__mulsf3_lhs_zero_or_subnormal>:
8000d4ee:	00568d63          	beq	a3,t0,8000d508 <.L__mulsf3_nan>

8000d4f2 <.L__mulsf3_signed_zero>:
8000d4f2:	853e                	mv	a0,a5
8000d4f4:	8082                	ret

8000d4f6 <.L__mulsf3_lhs_inf_or_nan>:
8000d4f6:	0526                	sll	a0,a0,0x9
8000d4f8:	e901                	bnez	a0,8000d508 <.L__mulsf3_nan>
8000d4fa:	fe5697e3          	bne	a3,t0,8000d4e8 <.L__mulsf3_inf>
8000d4fe:	05a6                	sll	a1,a1,0x9
8000d500:	e581                	bnez	a1,8000d508 <.L__mulsf3_nan>
8000d502:	b7dd                	j	8000d4e8 <.L__mulsf3_inf>

8000d504 <.L__mulsf3_rhs_zero_or_subnormal>:
8000d504:	fe5617e3          	bne	a2,t0,8000d4f2 <.L__mulsf3_signed_zero>

8000d508 <.L__mulsf3_nan>:
8000d508:	7fc00537          	lui	a0,0x7fc00
8000d50c:	8082                	ret

8000d50e <.L__mulsf3_rhs_inf_or_nan>:
8000d50e:	05a6                	sll	a1,a1,0x9
8000d510:	fde5                	bnez	a1,8000d508 <.L__mulsf3_nan>
8000d512:	bfd9                	j	8000d4e8 <.L__mulsf3_inf>

8000d514 <.L__mulsf3_zero_or_underflow>:
8000d514:	0605                	add	a2,a2,1
8000d516:	fe71                	bnez	a2,8000d4f2 <.L__mulsf3_signed_zero>
8000d518:	8521                	sra	a0,a0,0x8
8000d51a:	00150293          	add	t0,a0,1 # 7fc00001 <__SHARE_RAM_segment_end__+0x7ea80001>
8000d51e:	0509                	add	a0,a0,2
8000d520:	fc0299e3          	bnez	t0,8000d4f2 <.L__mulsf3_signed_zero>
8000d524:	00800537          	lui	a0,0x800
8000d528:	bf75                	j	8000d4e4 <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__muldf3:

8000d52a <__muldf3>:
8000d52a:	800008b7          	lui	a7,0x80000
8000d52e:	00d5c833          	xor	a6,a1,a3
8000d532:	01187eb3          	and	t4,a6,a7
8000d536:	00b58733          	add	a4,a1,a1
8000d53a:	00d687b3          	add	a5,a3,a3
8000d53e:	ffe00837          	lui	a6,0xffe00
8000d542:	0d077363          	bgeu	a4,a6,8000d608 <.L__muldf3_lhs_nan_or_inf>
8000d546:	0d07ff63          	bgeu	a5,a6,8000d624 <.L__muldf3_rhs_nan_or_inf>
8000d54a:	8355                	srl	a4,a4,0x15
8000d54c:	c76d                	beqz	a4,8000d636 <.L__muldf3_signed_zero>
8000d54e:	83d5                	srl	a5,a5,0x15
8000d550:	c3fd                	beqz	a5,8000d636 <.L__muldf3_signed_zero>
8000d552:	06ae                	sll	a3,a3,0xb
8000d554:	0116e6b3          	or	a3,a3,a7
8000d558:	82ad                	srl	a3,a3,0xb
8000d55a:	05ae                	sll	a1,a1,0xb
8000d55c:	0115e5b3          	or	a1,a1,a7
8000d560:	01555813          	srl	a6,a0,0x15
8000d564:	052e                	sll	a0,a0,0xb
8000d566:	010582b3          	add	t0,a1,a6
8000d56a:	00f70333          	add	t1,a4,a5
8000d56e:	02c50733          	mul	a4,a0,a2
8000d572:	02c537b3          	mulhu	a5,a0,a2
8000d576:	02d50833          	mul	a6,a0,a3
8000d57a:	02d538b3          	mulhu	a7,a0,a3
8000d57e:	983e                	add	a6,a6,a5
8000d580:	00f837b3          	sltu	a5,a6,a5
8000d584:	98be                	add	a7,a7,a5
8000d586:	02c28533          	mul	a0,t0,a2
8000d58a:	02c2b5b3          	mulhu	a1,t0,a2
8000d58e:	982a                	add	a6,a6,a0
8000d590:	00a83533          	sltu	a0,a6,a0
8000d594:	98ae                	add	a7,a7,a1
8000d596:	00b8b5b3          	sltu	a1,a7,a1
8000d59a:	98aa                	add	a7,a7,a0
8000d59c:	00a8b533          	sltu	a0,a7,a0
8000d5a0:	00b50633          	add	a2,a0,a1
8000d5a4:	02d28533          	mul	a0,t0,a3
8000d5a8:	02d2b5b3          	mulhu	a1,t0,a3
8000d5ac:	9546                	add	a0,a0,a7
8000d5ae:	011538b3          	sltu	a7,a0,a7
8000d5b2:	95c6                	add	a1,a1,a7
8000d5b4:	95b2                	add	a1,a1,a2
8000d5b6:	00e03733          	snez	a4,a4
8000d5ba:	00e86833          	or	a6,a6,a4
8000d5be:	871a                	mv	a4,t1
8000d5c0:	00b59293          	sll	t0,a1,0xb
8000d5c4:	0002cc63          	bltz	t0,8000d5dc <.L__muldf3_normalized>
8000d5c8:	000822b3          	sltz	t0,a6
8000d5cc:	9842                	add	a6,a6,a6
8000d5ce:	00052333          	sltz	t1,a0
8000d5d2:	952a                	add	a0,a0,a0
8000d5d4:	9516                	add	a0,a0,t0
8000d5d6:	95ae                	add	a1,a1,a1
8000d5d8:	959a                	add	a1,a1,t1
8000d5da:	177d                	add	a4,a4,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>

8000d5dc <.L__muldf3_normalized>:
8000d5dc:	3ff00793          	li	a5,1023
8000d5e0:	8f1d                	sub	a4,a4,a5
8000d5e2:	04074a63          	bltz	a4,8000d636 <.L__muldf3_signed_zero>
8000d5e6:	0786                	sll	a5,a5,0x1
8000d5e8:	04f75363          	bge	a4,a5,8000d62e <.L__muldf3_inf>
8000d5ec:	0752                	sll	a4,a4,0x14
8000d5ee:	95ba                	add	a1,a1,a4
8000d5f0:	00085a63          	bgez	a6,8000d604 <.L__muldf3_apply_sign>
8000d5f4:	0505                	add	a0,a0,1 # 800001 <_flash_size+0x1>
8000d5f6:	00153613          	seqz	a2,a0
8000d5fa:	95b2                	add	a1,a1,a2
8000d5fc:	0806                	sll	a6,a6,0x1
8000d5fe:	00081363          	bnez	a6,8000d604 <.L__muldf3_apply_sign>
8000d602:	9979                	and	a0,a0,-2

8000d604 <.L__muldf3_apply_sign>:
8000d604:	95f6                	add	a1,a1,t4
8000d606:	8082                	ret

8000d608 <.L__muldf3_lhs_nan_or_inf>:
8000d608:	01071a63          	bne	a4,a6,8000d61c <.L__muldf3_nan>
8000d60c:	e901                	bnez	a0,8000d61c <.L__muldf3_nan>
8000d60e:	00f86763          	bltu	a6,a5,8000d61c <.L__muldf3_nan>
8000d612:	0107e363          	bltu	a5,a6,8000d618 <.L__muldf3_rhs_could_be_zero>
8000d616:	e219                	bnez	a2,8000d61c <.L__muldf3_nan>

8000d618 <.L__muldf3_rhs_could_be_zero>:
8000d618:	83d5                	srl	a5,a5,0x15
8000d61a:	eb91                	bnez	a5,8000d62e <.L__muldf3_inf>

8000d61c <.L__muldf3_nan>:
8000d61c:	7ff805b7          	lui	a1,0x7ff80

8000d620 <.L__muldf3_load_zero_lo>:
8000d620:	4501                	li	a0,0
8000d622:	8082                	ret

8000d624 <.L__muldf3_rhs_nan_or_inf>:
8000d624:	ff079ce3          	bne	a5,a6,8000d61c <.L__muldf3_nan>
8000d628:	fa75                	bnez	a2,8000d61c <.L__muldf3_nan>
8000d62a:	8355                	srl	a4,a4,0x15
8000d62c:	db65                	beqz	a4,8000d61c <.L__muldf3_nan>

8000d62e <.L__muldf3_inf>:
8000d62e:	7ff005b7          	lui	a1,0x7ff00
8000d632:	4501                	li	a0,0
8000d634:	bfc1                	j	8000d604 <.L__muldf3_apply_sign>

8000d636 <.L__muldf3_signed_zero>:
8000d636:	85f6                	mv	a1,t4
8000d638:	b7e5                	j	8000d620 <.L__muldf3_load_zero_lo>

Disassembly of section .text.libc.__divsf3:

8000d63a <__divsf3>:
8000d63a:	0ff00293          	li	t0,255
8000d63e:	00151713          	sll	a4,a0,0x1
8000d642:	8361                	srl	a4,a4,0x18
8000d644:	00159793          	sll	a5,a1,0x1
8000d648:	83e1                	srl	a5,a5,0x18
8000d64a:	00b54333          	xor	t1,a0,a1
8000d64e:	01f35313          	srl	t1,t1,0x1f
8000d652:	037e                	sll	t1,t1,0x1f
8000d654:	cf5d                	beqz	a4,8000d712 <.L__divsf3_lhs_zero_or_subnormal>
8000d656:	cbf9                	beqz	a5,8000d72c <.L__divsf3_rhs_zero_or_subnormal>
8000d658:	0c570563          	beq	a4,t0,8000d722 <.L__divsf3_lhs_inf_or_nan>
8000d65c:	0c578d63          	beq	a5,t0,8000d736 <.L__divsf3_rhs_inf_or_nan>
8000d660:	8f1d                	sub	a4,a4,a5
8000d662:	800032b7          	lui	t0,0x80003
8000d666:	3f428293          	add	t0,t0,1012 # 800033f4 <__SEGGER_RTL_fdiv_reciprocal_table>
8000d66a:	00f5d693          	srl	a3,a1,0xf
8000d66e:	0fc6f693          	and	a3,a3,252
8000d672:	9696                	add	a3,a3,t0
8000d674:	429c                	lw	a5,0(a3)
8000d676:	4187d613          	sra	a2,a5,0x18
8000d67a:	00f59693          	sll	a3,a1,0xf
8000d67e:	82e1                	srl	a3,a3,0x18
8000d680:	0016f293          	and	t0,a3,1
8000d684:	8285                	srl	a3,a3,0x1
8000d686:	fc068693          	add	a3,a3,-64 # f3ffffc0 <__AHB_SRAM_segment_end__+0x3cf7fc0>
8000d68a:	9696                	add	a3,a3,t0
8000d68c:	02d60633          	mul	a2,a2,a3
8000d690:	07a2                	sll	a5,a5,0x8
8000d692:	83a1                	srl	a5,a5,0x8
8000d694:	963e                	add	a2,a2,a5
8000d696:	05a2                	sll	a1,a1,0x8
8000d698:	81a1                	srl	a1,a1,0x8
8000d69a:	008007b7          	lui	a5,0x800
8000d69e:	8ddd                	or	a1,a1,a5
8000d6a0:	02c586b3          	mul	a3,a1,a2
8000d6a4:	0522                	sll	a0,a0,0x8
8000d6a6:	8121                	srl	a0,a0,0x8
8000d6a8:	8d5d                	or	a0,a0,a5
8000d6aa:	02c697b3          	mulh	a5,a3,a2
8000d6ae:	00b532b3          	sltu	t0,a0,a1
8000d6b2:	00551533          	sll	a0,a0,t0
8000d6b6:	40570733          	sub	a4,a4,t0
8000d6ba:	01465693          	srl	a3,a2,0x14
8000d6be:	8a85                	and	a3,a3,1
8000d6c0:	0016c693          	xor	a3,a3,1
8000d6c4:	062e                	sll	a2,a2,0xb
8000d6c6:	8e1d                	sub	a2,a2,a5
8000d6c8:	8e15                	sub	a2,a2,a3
8000d6ca:	050a                	sll	a0,a0,0x2
8000d6cc:	02a617b3          	mulh	a5,a2,a0
8000d6d0:	07e70613          	add	a2,a4,126
8000d6d4:	055a                	sll	a0,a0,0x16
8000d6d6:	8d0d                	sub	a0,a0,a1
8000d6d8:	02b786b3          	mul	a3,a5,a1
8000d6dc:	0fe00293          	li	t0,254
8000d6e0:	00567f63          	bgeu	a2,t0,8000d6fe <.L__divsf3_underflow_or_overflow>
8000d6e4:	40a68533          	sub	a0,a3,a0
8000d6e8:	000522b3          	sltz	t0,a0
8000d6ec:	9796                	add	a5,a5,t0
8000d6ee:	0017f513          	and	a0,a5,1
8000d6f2:	8385                	srl	a5,a5,0x1
8000d6f4:	953e                	add	a0,a0,a5
8000d6f6:	065e                	sll	a2,a2,0x17
8000d6f8:	9532                	add	a0,a0,a2
8000d6fa:	951a                	add	a0,a0,t1
8000d6fc:	8082                	ret

8000d6fe <.L__divsf3_underflow_or_overflow>:
8000d6fe:	851a                	mv	a0,t1
8000d700:	00564563          	blt	a2,t0,8000d70a <.L__divsf3_done>
8000d704:	7f800337          	lui	t1,0x7f800

8000d708 <.L__divsf3_apply_sign>:
8000d708:	951a                	add	a0,a0,t1

8000d70a <.L__divsf3_done>:
8000d70a:	8082                	ret

8000d70c <.L__divsf3_inf>:
8000d70c:	7f800537          	lui	a0,0x7f800
8000d710:	bfe5                	j	8000d708 <.L__divsf3_apply_sign>

8000d712 <.L__divsf3_lhs_zero_or_subnormal>:
8000d712:	c789                	beqz	a5,8000d71c <.L__divsf3_nan>
8000d714:	02579363          	bne	a5,t0,8000d73a <.L__divsf3_signed_zero>
8000d718:	05a6                	sll	a1,a1,0x9
8000d71a:	c185                	beqz	a1,8000d73a <.L__divsf3_signed_zero>

8000d71c <.L__divsf3_nan>:
8000d71c:	7fc00537          	lui	a0,0x7fc00
8000d720:	8082                	ret

8000d722 <.L__divsf3_lhs_inf_or_nan>:
8000d722:	0526                	sll	a0,a0,0x9
8000d724:	fd65                	bnez	a0,8000d71c <.L__divsf3_nan>
8000d726:	fe5793e3          	bne	a5,t0,8000d70c <.L__divsf3_inf>
8000d72a:	bfcd                	j	8000d71c <.L__divsf3_nan>

8000d72c <.L__divsf3_rhs_zero_or_subnormal>:
8000d72c:	fe5710e3          	bne	a4,t0,8000d70c <.L__divsf3_inf>
8000d730:	0526                	sll	a0,a0,0x9
8000d732:	f56d                	bnez	a0,8000d71c <.L__divsf3_nan>
8000d734:	bfe1                	j	8000d70c <.L__divsf3_inf>

8000d736 <.L__divsf3_rhs_inf_or_nan>:
8000d736:	05a6                	sll	a1,a1,0x9
8000d738:	f1f5                	bnez	a1,8000d71c <.L__divsf3_nan>

8000d73a <.L__divsf3_signed_zero>:
8000d73a:	851a                	mv	a0,t1
8000d73c:	8082                	ret

Disassembly of section .text.libc.__divdf3:

8000d73e <__divdf3>:
8000d73e:	00169813          	sll	a6,a3,0x1
8000d742:	01585813          	srl	a6,a6,0x15
8000d746:	00159893          	sll	a7,a1,0x1
8000d74a:	0158d893          	srl	a7,a7,0x15
8000d74e:	00d5c3b3          	xor	t2,a1,a3
8000d752:	01f3d393          	srl	t2,t2,0x1f
8000d756:	03fe                	sll	t2,t2,0x1f
8000d758:	7ff00293          	li	t0,2047
8000d75c:	16588e63          	beq	a7,t0,8000d8d8 <.L__divdf3_inf_nan_over>
8000d760:	18080a63          	beqz	a6,8000d8f4 <.L__divdf3_div_zero>
8000d764:	18580263          	beq	a6,t0,8000d8e8 <.L__divdf3_div_inf_nan>
8000d768:	18088263          	beqz	a7,8000d8ec <.L__divdf3_signed_zero>
8000d76c:	410888b3          	sub	a7,a7,a6
8000d770:	3ff88893          	add	a7,a7,1023 # 800003ff <__SHARE_RAM_segment_end__+0x7ee803ff>
8000d774:	05b2                	sll	a1,a1,0xc
8000d776:	81b1                	srl	a1,a1,0xc
8000d778:	06b2                	sll	a3,a3,0xc
8000d77a:	82b1                	srl	a3,a3,0xc
8000d77c:	00100737          	lui	a4,0x100
8000d780:	8dd9                	or	a1,a1,a4
8000d782:	8ed9                	or	a3,a3,a4
8000d784:	00c53733          	sltu	a4,a0,a2
8000d788:	9736                	add	a4,a4,a3
8000d78a:	8d99                	sub	a1,a1,a4
8000d78c:	8d11                	sub	a0,a0,a2
8000d78e:	0005dd63          	bgez	a1,8000d7a8 <.L__divdf3_can_subtract>
8000d792:	00052733          	sltz	a4,a0
8000d796:	95ae                	add	a1,a1,a1
8000d798:	95ba                	add	a1,a1,a4
8000d79a:	95b6                	add	a1,a1,a3
8000d79c:	952a                	add	a0,a0,a0
8000d79e:	9532                	add	a0,a0,a2
8000d7a0:	00c53733          	sltu	a4,a0,a2
8000d7a4:	95ba                	add	a1,a1,a4
8000d7a6:	18fd                	add	a7,a7,-1

8000d7a8 <.L__divdf3_can_subtract>:
8000d7a8:	1258dd63          	bge	a7,t0,8000d8e2 <.L__divdf3_signed_inf>
8000d7ac:	15105063          	blez	a7,8000d8ec <.L__divdf3_signed_zero>
8000d7b0:	05aa                	sll	a1,a1,0xa
8000d7b2:	01655713          	srl	a4,a0,0x16
8000d7b6:	8dd9                	or	a1,a1,a4
8000d7b8:	052a                	sll	a0,a0,0xa
8000d7ba:	02d5d833          	divu	a6,a1,a3
8000d7be:	02d80e33          	mul	t3,a6,a3
8000d7c2:	41c585b3          	sub	a1,a1,t3
8000d7c6:	02c80733          	mul	a4,a6,a2
8000d7ca:	02c837b3          	mulhu	a5,a6,a2
8000d7ce:	00e53e33          	sltu	t3,a0,a4
8000d7d2:	97f2                	add	a5,a5,t3
8000d7d4:	8d19                	sub	a0,a0,a4
8000d7d6:	8d9d                	sub	a1,a1,a5
8000d7d8:	0005d863          	bgez	a1,8000d7e8 <.L__divdf3_qdash_correct_1>
8000d7dc:	187d                	add	a6,a6,-1 # ffdfffff <__APB_SRAM_segment_end__+0xbd0dfff>
8000d7de:	9532                	add	a0,a0,a2
8000d7e0:	95b6                	add	a1,a1,a3
8000d7e2:	00c532b3          	sltu	t0,a0,a2
8000d7e6:	9596                	add	a1,a1,t0

8000d7e8 <.L__divdf3_qdash_correct_1>:
8000d7e8:	05aa                	sll	a1,a1,0xa
8000d7ea:	01655293          	srl	t0,a0,0x16
8000d7ee:	9596                	add	a1,a1,t0
8000d7f0:	052a                	sll	a0,a0,0xa
8000d7f2:	02d5d2b3          	divu	t0,a1,a3
8000d7f6:	02d28733          	mul	a4,t0,a3
8000d7fa:	8d99                	sub	a1,a1,a4
8000d7fc:	02c28733          	mul	a4,t0,a2
8000d800:	02c2b7b3          	mulhu	a5,t0,a2
8000d804:	00e53e33          	sltu	t3,a0,a4
8000d808:	97f2                	add	a5,a5,t3
8000d80a:	8d19                	sub	a0,a0,a4
8000d80c:	8d9d                	sub	a1,a1,a5
8000d80e:	0005d863          	bgez	a1,8000d81e <.L__divdf3_qdash_correct_2>
8000d812:	12fd                	add	t0,t0,-1
8000d814:	9532                	add	a0,a0,a2
8000d816:	95b6                	add	a1,a1,a3
8000d818:	00c53e33          	sltu	t3,a0,a2
8000d81c:	95f2                	add	a1,a1,t3

8000d81e <.L__divdf3_qdash_correct_2>:
8000d81e:	082a                	sll	a6,a6,0xa
8000d820:	9816                	add	a6,a6,t0
8000d822:	05ae                	sll	a1,a1,0xb
8000d824:	01555e13          	srl	t3,a0,0x15
8000d828:	95f2                	add	a1,a1,t3
8000d82a:	052e                	sll	a0,a0,0xb
8000d82c:	02d5d2b3          	divu	t0,a1,a3
8000d830:	02d28733          	mul	a4,t0,a3
8000d834:	8d99                	sub	a1,a1,a4
8000d836:	02c28733          	mul	a4,t0,a2
8000d83a:	02c2b7b3          	mulhu	a5,t0,a2
8000d83e:	00e53e33          	sltu	t3,a0,a4
8000d842:	97f2                	add	a5,a5,t3
8000d844:	8d19                	sub	a0,a0,a4
8000d846:	8d9d                	sub	a1,a1,a5
8000d848:	0005d863          	bgez	a1,8000d858 <.L__divdf3_qdash_correct_3>
8000d84c:	12fd                	add	t0,t0,-1
8000d84e:	9532                	add	a0,a0,a2
8000d850:	95b6                	add	a1,a1,a3
8000d852:	00c53e33          	sltu	t3,a0,a2
8000d856:	95f2                	add	a1,a1,t3

8000d858 <.L__divdf3_qdash_correct_3>:
8000d858:	05ae                	sll	a1,a1,0xb
8000d85a:	01555e13          	srl	t3,a0,0x15
8000d85e:	95f2                	add	a1,a1,t3
8000d860:	052e                	sll	a0,a0,0xb
8000d862:	02d5d333          	divu	t1,a1,a3
8000d866:	02d30733          	mul	a4,t1,a3
8000d86a:	8d99                	sub	a1,a1,a4
8000d86c:	02c30733          	mul	a4,t1,a2
8000d870:	02c337b3          	mulhu	a5,t1,a2
8000d874:	00e53e33          	sltu	t3,a0,a4
8000d878:	97f2                	add	a5,a5,t3
8000d87a:	8d19                	sub	a0,a0,a4
8000d87c:	8d9d                	sub	a1,a1,a5
8000d87e:	0005d863          	bgez	a1,8000d88e <.L__divdf3_qdash_correct_4>
8000d882:	137d                	add	t1,t1,-1 # 7f7fffff <__SHARE_RAM_segment_end__+0x7e67ffff>
8000d884:	9532                	add	a0,a0,a2
8000d886:	95b6                	add	a1,a1,a3
8000d888:	00c53e33          	sltu	t3,a0,a2
8000d88c:	95f2                	add	a1,a1,t3

8000d88e <.L__divdf3_qdash_correct_4>:
8000d88e:	02d6                	sll	t0,t0,0x15
8000d890:	032a                	sll	t1,t1,0xa
8000d892:	929a                	add	t0,t0,t1
8000d894:	05ae                	sll	a1,a1,0xb
8000d896:	01555e13          	srl	t3,a0,0x15
8000d89a:	95f2                	add	a1,a1,t3
8000d89c:	052e                	sll	a0,a0,0xb
8000d89e:	02d5d333          	divu	t1,a1,a3
8000d8a2:	02d30733          	mul	a4,t1,a3
8000d8a6:	8d99                	sub	a1,a1,a4
8000d8a8:	02c30733          	mul	a4,t1,a2
8000d8ac:	02c337b3          	mulhu	a5,t1,a2
8000d8b0:	00e53e33          	sltu	t3,a0,a4
8000d8b4:	97f2                	add	a5,a5,t3
8000d8b6:	8d9d                	sub	a1,a1,a5
8000d8b8:	85fd                	sra	a1,a1,0x1f
8000d8ba:	932e                	add	t1,t1,a1
8000d8bc:	08d2                	sll	a7,a7,0x14
8000d8be:	011805b3          	add	a1,a6,a7
8000d8c2:	00135513          	srl	a0,t1,0x1
8000d8c6:	9516                	add	a0,a0,t0
8000d8c8:	00137313          	and	t1,t1,1
8000d8cc:	951a                	add	a0,a0,t1
8000d8ce:	00653733          	sltu	a4,a0,t1
8000d8d2:	95ba                	add	a1,a1,a4
8000d8d4:	959e                	add	a1,a1,t2
8000d8d6:	8082                	ret

8000d8d8 <.L__divdf3_inf_nan_over>:
8000d8d8:	05b2                	sll	a1,a1,0xc
8000d8da:	00580f63          	beq	a6,t0,8000d8f8 <.L__divdf3_return_nan>
8000d8de:	8dc9                	or	a1,a1,a0
8000d8e0:	ed81                	bnez	a1,8000d8f8 <.L__divdf3_return_nan>

8000d8e2 <.L__divdf3_signed_inf>:
8000d8e2:	7ff005b7          	lui	a1,0x7ff00
8000d8e6:	a021                	j	8000d8ee <.L__divdf3_apply_sign>

8000d8e8 <.L__divdf3_div_inf_nan>:
8000d8e8:	06b2                	sll	a3,a3,0xc
8000d8ea:	e699                	bnez	a3,8000d8f8 <.L__divdf3_return_nan>

8000d8ec <.L__divdf3_signed_zero>:
8000d8ec:	4581                	li	a1,0

8000d8ee <.L__divdf3_apply_sign>:
8000d8ee:	959e                	add	a1,a1,t2

8000d8f0 <.L__divdf3_clr_low_ret>:
8000d8f0:	4501                	li	a0,0
8000d8f2:	8082                	ret

8000d8f4 <.L__divdf3_div_zero>:
8000d8f4:	fe0897e3          	bnez	a7,8000d8e2 <.L__divdf3_signed_inf>

8000d8f8 <.L__divdf3_return_nan>:
8000d8f8:	7ff805b7          	lui	a1,0x7ff80
8000d8fc:	bfd5                	j	8000d8f0 <.L__divdf3_clr_low_ret>

Disassembly of section .text.libc.__eqsf2:

8000d8fe <__eqsf2>:
8000d8fe:	ff000637          	lui	a2,0xff000
8000d902:	00151693          	sll	a3,a0,0x1
8000d906:	02d66063          	bltu	a2,a3,8000d926 <.L__eqsf2_one>
8000d90a:	00159693          	sll	a3,a1,0x1
8000d90e:	00d66c63          	bltu	a2,a3,8000d926 <.L__eqsf2_one>
8000d912:	00b56633          	or	a2,a0,a1
8000d916:	0606                	sll	a2,a2,0x1
8000d918:	c609                	beqz	a2,8000d922 <.L__eqsf2_zero>
8000d91a:	8d0d                	sub	a0,a0,a1
8000d91c:	00a03533          	snez	a0,a0
8000d920:	8082                	ret

8000d922 <.L__eqsf2_zero>:
8000d922:	4501                	li	a0,0
8000d924:	8082                	ret

8000d926 <.L__eqsf2_one>:
8000d926:	4505                	li	a0,1
8000d928:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

8000d92a <__fixunssfdi>:
8000d92a:	04054a63          	bltz	a0,8000d97e <.L__fixunssfdi_zero_result>
8000d92e:	00151613          	sll	a2,a0,0x1
8000d932:	8261                	srl	a2,a2,0x18
8000d934:	f8160613          	add	a2,a2,-127 # feffff81 <__APB_SRAM_segment_end__+0xaf0df81>
8000d938:	04064363          	bltz	a2,8000d97e <.L__fixunssfdi_zero_result>
8000d93c:	800006b7          	lui	a3,0x80000
8000d940:	02000293          	li	t0,32
8000d944:	00565b63          	bge	a2,t0,8000d95a <.L__fixunssfdi_long_shift>
8000d948:	40c00633          	neg	a2,a2
8000d94c:	067d                	add	a2,a2,31
8000d94e:	0522                	sll	a0,a0,0x8
8000d950:	8d55                	or	a0,a0,a3
8000d952:	00c55533          	srl	a0,a0,a2
8000d956:	4581                	li	a1,0
8000d958:	8082                	ret

8000d95a <.L__fixunssfdi_long_shift>:
8000d95a:	40c00633          	neg	a2,a2
8000d95e:	03f60613          	add	a2,a2,63
8000d962:	02064163          	bltz	a2,8000d984 <.L__fixunssfdi_overflow_result>
8000d966:	00851593          	sll	a1,a0,0x8
8000d96a:	8dd5                	or	a1,a1,a3
8000d96c:	4501                	li	a0,0
8000d96e:	c619                	beqz	a2,8000d97c <.L__fixunssfdi_shift_32>
8000d970:	40c006b3          	neg	a3,a2
8000d974:	00d59533          	sll	a0,a1,a3
8000d978:	00c5d5b3          	srl	a1,a1,a2

8000d97c <.L__fixunssfdi_shift_32>:
8000d97c:	8082                	ret

8000d97e <.L__fixunssfdi_zero_result>:
8000d97e:	4501                	li	a0,0
8000d980:	4581                	li	a1,0
8000d982:	8082                	ret

8000d984 <.L__fixunssfdi_overflow_result>:
8000d984:	557d                	li	a0,-1
8000d986:	55fd                	li	a1,-1
8000d988:	8082                	ret

Disassembly of section .text.libc.__floatunsidf:

8000d98a <__floatunsidf>:
8000d98a:	c131                	beqz	a0,8000d9ce <.L__floatunsidf_zero>
8000d98c:	41d00613          	li	a2,1053
8000d990:	01055693          	srl	a3,a0,0x10
8000d994:	e299                	bnez	a3,8000d99a <.L1^B9>
8000d996:	0542                	sll	a0,a0,0x10
8000d998:	1641                	add	a2,a2,-16

8000d99a <.L1^B9>:
8000d99a:	01855693          	srl	a3,a0,0x18
8000d99e:	e299                	bnez	a3,8000d9a4 <.L2^B9>
8000d9a0:	0522                	sll	a0,a0,0x8
8000d9a2:	1661                	add	a2,a2,-8

8000d9a4 <.L2^B9>:
8000d9a4:	01c55693          	srl	a3,a0,0x1c
8000d9a8:	e299                	bnez	a3,8000d9ae <.L3^B7>
8000d9aa:	0512                	sll	a0,a0,0x4
8000d9ac:	1671                	add	a2,a2,-4

8000d9ae <.L3^B7>:
8000d9ae:	01e55693          	srl	a3,a0,0x1e
8000d9b2:	e299                	bnez	a3,8000d9b8 <.L4^B9>
8000d9b4:	050a                	sll	a0,a0,0x2
8000d9b6:	1679                	add	a2,a2,-2

8000d9b8 <.L4^B9>:
8000d9b8:	00054463          	bltz	a0,8000d9c0 <.L5^B7>
8000d9bc:	0506                	sll	a0,a0,0x1
8000d9be:	167d                	add	a2,a2,-1

8000d9c0 <.L5^B7>:
8000d9c0:	0652                	sll	a2,a2,0x14
8000d9c2:	00b55693          	srl	a3,a0,0xb
8000d9c6:	0556                	sll	a0,a0,0x15
8000d9c8:	00c685b3          	add	a1,a3,a2
8000d9cc:	8082                	ret

8000d9ce <.L__floatunsidf_zero>:
8000d9ce:	85aa                	mv	a1,a0
8000d9d0:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

8000d9d2 <__trunctfsf2>:
8000d9d2:	4110                	lw	a2,0(a0)
8000d9d4:	4154                	lw	a3,4(a0)
8000d9d6:	4518                	lw	a4,8(a0)
8000d9d8:	455c                	lw	a5,12(a0)
8000d9da:	1101                	add	sp,sp,-32
8000d9dc:	850a                	mv	a0,sp
8000d9de:	ce06                	sw	ra,28(sp)
8000d9e0:	c032                	sw	a2,0(sp)
8000d9e2:	c236                	sw	a3,4(sp)
8000d9e4:	c43a                	sw	a4,8(sp)
8000d9e6:	c63e                	sw	a5,12(sp)
8000d9e8:	f42fa0ef          	jal	8000812a <__SEGGER_RTL_ldouble_to_double>
8000d9ec:	eb8fa0ef          	jal	800080a4 <__truncdfsf2>
8000d9f0:	40f2                	lw	ra,28(sp)
8000d9f2:	6105                	add	sp,sp,32
8000d9f4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

8000d9f6 <__SEGGER_RTL_float32_signbit>:
8000d9f6:	817d                	srl	a0,a0,0x1f
8000d9f8:	8082                	ret

Disassembly of section .text.libc.ldexpf:

8000d9fa <ldexpf>:
8000d9fa:	01755713          	srl	a4,a0,0x17
8000d9fe:	0ff77713          	zext.b	a4,a4
8000da02:	fff70613          	add	a2,a4,-1 # fffff <__DLM_segment_end__+0x3ffff>
8000da06:	0fd00693          	li	a3,253
8000da0a:	87aa                	mv	a5,a0
8000da0c:	02c6e863          	bltu	a3,a2,8000da3c <.L780>
8000da10:	95ba                	add	a1,a1,a4
8000da12:	fff58713          	add	a4,a1,-1 # 7ff7ffff <__SHARE_RAM_segment_end__+0x7edfffff>
8000da16:	00e6eb63          	bltu	a3,a4,8000da2c <.L781>
8000da1a:	80800737          	lui	a4,0x80800
8000da1e:	177d                	add	a4,a4,-1 # 807fffff <__XPI0_segment_used_end__+0x7f0fab>
8000da20:	00e577b3          	and	a5,a0,a4
8000da24:	05de                	sll	a1,a1,0x17
8000da26:	00f5e533          	or	a0,a1,a5
8000da2a:	8082                	ret

8000da2c <.L781>:
8000da2c:	80000537          	lui	a0,0x80000
8000da30:	8d7d                	and	a0,a0,a5
8000da32:	00b05563          	blez	a1,8000da3c <.L780>
8000da36:	7f8007b7          	lui	a5,0x7f800
8000da3a:	8d5d                	or	a0,a0,a5

8000da3c <.L780>:
8000da3c:	8082                	ret

Disassembly of section .text.libc.frexpf:

8000da3e <frexpf>:
8000da3e:	01755793          	srl	a5,a0,0x17
8000da42:	0ff7f793          	zext.b	a5,a5
8000da46:	4701                	li	a4,0
8000da48:	cf99                	beqz	a5,8000da66 <.L959>
8000da4a:	0ff00613          	li	a2,255
8000da4e:	00c78c63          	beq	a5,a2,8000da66 <.L959>
8000da52:	f8278713          	add	a4,a5,-126 # 7f7fff82 <__SHARE_RAM_segment_end__+0x7e67ff82>
8000da56:	808007b7          	lui	a5,0x80800
8000da5a:	17fd                	add	a5,a5,-1 # 807fffff <__XPI0_segment_used_end__+0x7f0fab>
8000da5c:	00f576b3          	and	a3,a0,a5
8000da60:	3f000537          	lui	a0,0x3f000
8000da64:	8d55                	or	a0,a0,a3

8000da66 <.L959>:
8000da66:	c198                	sw	a4,0(a1)
8000da68:	8082                	ret

Disassembly of section .text.libc.fmodf:

8000da6a <fmodf>:
8000da6a:	01755793          	srl	a5,a0,0x17
8000da6e:	80000837          	lui	a6,0x80000
8000da72:	17fd                	add	a5,a5,-1
8000da74:	0fd00713          	li	a4,253
8000da78:	86aa                	mv	a3,a0
8000da7a:	862e                	mv	a2,a1
8000da7c:	00a87833          	and	a6,a6,a0
8000da80:	02f76663          	bltu	a4,a5,8000daac <.L991>
8000da84:	0175d793          	srl	a5,a1,0x17
8000da88:	17fd                	add	a5,a5,-1
8000da8a:	04f77063          	bgeu	a4,a5,8000daca <.L992>
8000da8e:	00151713          	sll	a4,a0,0x1

8000da92 <.L993>:
8000da92:	00159793          	sll	a5,a1,0x1
8000da96:	ff000637          	lui	a2,0xff000
8000da9a:	0cf66863          	bltu	a2,a5,8000db6a <.L1009>
8000da9e:	ef11                	bnez	a4,8000daba <.L995>
8000daa0:	ef81                	bnez	a5,8000dab8 <.L994>

8000daa2 <.L1011>:
8000daa2:	800047b7          	lui	a5,0x80004
8000daa6:	b3c7a503          	lw	a0,-1220(a5) # 80003b3c <.Lmerged_single+0x14>
8000daaa:	8082                	ret

8000daac <.L991>:
8000daac:	00151713          	sll	a4,a0,0x1
8000dab0:	ff0007b7          	lui	a5,0xff000
8000dab4:	fce7ffe3          	bgeu	a5,a4,8000da92 <.L993>

8000dab8 <.L994>:
8000dab8:	8082                	ret

8000daba <.L995>:
8000daba:	fec704e3          	beq	a4,a2,8000daa2 <.L1011>
8000dabe:	fec78de3          	beq	a5,a2,8000dab8 <.L994>
8000dac2:	d3e5                	beqz	a5,8000daa2 <.L1011>
8000dac4:	0586                	sll	a1,a1,0x1
8000dac6:	0015d613          	srl	a2,a1,0x1

8000daca <.L992>:
8000daca:	00169793          	sll	a5,a3,0x1
8000dace:	8385                	srl	a5,a5,0x1
8000dad0:	00f66663          	bltu	a2,a5,8000dadc <.L996>
8000dad4:	fec792e3          	bne	a5,a2,8000dab8 <.L994>

8000dad8 <.L1018>:
8000dad8:	8542                	mv	a0,a6
8000dada:	8082                	ret

8000dadc <.L996>:
8000dadc:	0177d713          	srl	a4,a5,0x17
8000dae0:	cb0d                	beqz	a4,8000db12 <.L1012>
8000dae2:	008007b7          	lui	a5,0x800
8000dae6:	fff78593          	add	a1,a5,-1 # 7fffff <__XPI0_segment_size__+0x2fff>
8000daea:	8eed                	and	a3,a3,a1
8000daec:	8fd5                	or	a5,a5,a3

8000daee <.L998>:
8000daee:	01765593          	srl	a1,a2,0x17
8000daf2:	c985                	beqz	a1,8000db22 <.L1013>
8000daf4:	008006b7          	lui	a3,0x800
8000daf8:	fff68513          	add	a0,a3,-1 # 7fffff <__XPI0_segment_size__+0x2fff>
8000dafc:	8e69                	and	a2,a2,a0
8000dafe:	8e55                	or	a2,a2,a3

8000db00 <.L1002>:
8000db00:	40c786b3          	sub	a3,a5,a2
8000db04:	02e5c763          	blt	a1,a4,8000db32 <.L1003>
8000db08:	0206cc63          	bltz	a3,8000db40 <.L1015>
8000db0c:	8542                	mv	a0,a6
8000db0e:	ea95                	bnez	a3,8000db42 <.L1004>
8000db10:	8082                	ret

8000db12 <.L1012>:
8000db12:	4701                	li	a4,0
8000db14:	008006b7          	lui	a3,0x800

8000db18 <.L997>:
8000db18:	0786                	sll	a5,a5,0x1
8000db1a:	177d                	add	a4,a4,-1
8000db1c:	fed7eee3          	bltu	a5,a3,8000db18 <.L997>
8000db20:	b7f9                	j	8000daee <.L998>

8000db22 <.L1013>:
8000db22:	4581                	li	a1,0
8000db24:	008006b7          	lui	a3,0x800

8000db28 <.L999>:
8000db28:	0606                	sll	a2,a2,0x1
8000db2a:	15fd                	add	a1,a1,-1
8000db2c:	fed66ee3          	bltu	a2,a3,8000db28 <.L999>
8000db30:	bfc1                	j	8000db00 <.L1002>

8000db32 <.L1003>:
8000db32:	0006c463          	bltz	a3,8000db3a <.L1001>
8000db36:	d2cd                	beqz	a3,8000dad8 <.L1018>
8000db38:	87b6                	mv	a5,a3

8000db3a <.L1001>:
8000db3a:	0786                	sll	a5,a5,0x1
8000db3c:	177d                	add	a4,a4,-1
8000db3e:	b7c9                	j	8000db00 <.L1002>

8000db40 <.L1015>:
8000db40:	86be                	mv	a3,a5

8000db42 <.L1004>:
8000db42:	008007b7          	lui	a5,0x800

8000db46 <.L1006>:
8000db46:	fff70513          	add	a0,a4,-1
8000db4a:	00f6ed63          	bltu	a3,a5,8000db64 <.L1007>
8000db4e:	00e04763          	bgtz	a4,8000db5c <.L1008>
8000db52:	4785                	li	a5,1
8000db54:	8f99                	sub	a5,a5,a4
8000db56:	00f6d6b3          	srl	a3,a3,a5
8000db5a:	4501                	li	a0,0

8000db5c <.L1008>:
8000db5c:	9836                	add	a6,a6,a3
8000db5e:	055e                	sll	a0,a0,0x17
8000db60:	9542                	add	a0,a0,a6
8000db62:	8082                	ret

8000db64 <.L1007>:
8000db64:	0686                	sll	a3,a3,0x1
8000db66:	872a                	mv	a4,a0
8000db68:	bff9                	j	8000db46 <.L1006>

8000db6a <.L1009>:
8000db6a:	852e                	mv	a0,a1
8000db6c:	8082                	ret

Disassembly of section .text.libc.memset:

8000db6e <memset>:
8000db6e:	872a                	mv	a4,a0
8000db70:	c22d                	beqz	a2,8000dbd2 <.Lmemset_memset_end>

8000db72 <.Lmemset_unaligned_byte_set_loop>:
8000db72:	01e51693          	sll	a3,a0,0x1e
8000db76:	c699                	beqz	a3,8000db84 <.Lmemset_fast_set>
8000db78:	00b50023          	sb	a1,0(a0) # 3f000000 <__SHARE_RAM_segment_end__+0x3de80000>
8000db7c:	0505                	add	a0,a0,1
8000db7e:	167d                	add	a2,a2,-1 # feffffff <__APB_SRAM_segment_end__+0xaf0dfff>
8000db80:	fa6d                	bnez	a2,8000db72 <.Lmemset_unaligned_byte_set_loop>
8000db82:	a881                	j	8000dbd2 <.Lmemset_memset_end>

8000db84 <.Lmemset_fast_set>:
8000db84:	0ff5f593          	zext.b	a1,a1
8000db88:	00859693          	sll	a3,a1,0x8
8000db8c:	8dd5                	or	a1,a1,a3
8000db8e:	01059693          	sll	a3,a1,0x10
8000db92:	8dd5                	or	a1,a1,a3
8000db94:	02000693          	li	a3,32
8000db98:	00d66f63          	bltu	a2,a3,8000dbb6 <.Lmemset_word_set>

8000db9c <.Lmemset_fast_set_loop>:
8000db9c:	c10c                	sw	a1,0(a0)
8000db9e:	c14c                	sw	a1,4(a0)
8000dba0:	c50c                	sw	a1,8(a0)
8000dba2:	c54c                	sw	a1,12(a0)
8000dba4:	c90c                	sw	a1,16(a0)
8000dba6:	c94c                	sw	a1,20(a0)
8000dba8:	cd0c                	sw	a1,24(a0)
8000dbaa:	cd4c                	sw	a1,28(a0)
8000dbac:	9536                	add	a0,a0,a3
8000dbae:	8e15                	sub	a2,a2,a3
8000dbb0:	fed676e3          	bgeu	a2,a3,8000db9c <.Lmemset_fast_set_loop>
8000dbb4:	ce19                	beqz	a2,8000dbd2 <.Lmemset_memset_end>

8000dbb6 <.Lmemset_word_set>:
8000dbb6:	4691                	li	a3,4
8000dbb8:	00d66863          	bltu	a2,a3,8000dbc8 <.Lmemset_byte_set_loop>

8000dbbc <.Lmemset_word_set_loop>:
8000dbbc:	c10c                	sw	a1,0(a0)
8000dbbe:	9536                	add	a0,a0,a3
8000dbc0:	8e15                	sub	a2,a2,a3
8000dbc2:	fed67de3          	bgeu	a2,a3,8000dbbc <.Lmemset_word_set_loop>
8000dbc6:	c611                	beqz	a2,8000dbd2 <.Lmemset_memset_end>

8000dbc8 <.Lmemset_byte_set_loop>:
8000dbc8:	00b50023          	sb	a1,0(a0)
8000dbcc:	0505                	add	a0,a0,1
8000dbce:	167d                	add	a2,a2,-1
8000dbd0:	fe65                	bnez	a2,8000dbc8 <.Lmemset_byte_set_loop>

8000dbd2 <.Lmemset_memset_end>:
8000dbd2:	853a                	mv	a0,a4
8000dbd4:	8082                	ret

Disassembly of section .text.libc.strlen:

8000dbd6 <strlen>:
8000dbd6:	85aa                	mv	a1,a0
8000dbd8:	00357693          	and	a3,a0,3
8000dbdc:	c29d                	beqz	a3,8000dc02 <.Lstrlen_aligned>
8000dbde:	00054603          	lbu	a2,0(a0)
8000dbe2:	ce21                	beqz	a2,8000dc3a <.Lstrlen_done>
8000dbe4:	0505                	add	a0,a0,1
8000dbe6:	00357693          	and	a3,a0,3
8000dbea:	ce81                	beqz	a3,8000dc02 <.Lstrlen_aligned>
8000dbec:	00054603          	lbu	a2,0(a0)
8000dbf0:	c629                	beqz	a2,8000dc3a <.Lstrlen_done>
8000dbf2:	0505                	add	a0,a0,1
8000dbf4:	00357693          	and	a3,a0,3
8000dbf8:	c689                	beqz	a3,8000dc02 <.Lstrlen_aligned>
8000dbfa:	00054603          	lbu	a2,0(a0)
8000dbfe:	ce15                	beqz	a2,8000dc3a <.Lstrlen_done>
8000dc00:	0505                	add	a0,a0,1

8000dc02 <.Lstrlen_aligned>:
8000dc02:	01010637          	lui	a2,0x1010
8000dc06:	10160613          	add	a2,a2,257 # 1010101 <_extram_size+0x10101>
8000dc0a:	00761693          	sll	a3,a2,0x7

8000dc0e <.Lstrlen_wordstrlen>:
8000dc0e:	4118                	lw	a4,0(a0)
8000dc10:	0511                	add	a0,a0,4
8000dc12:	40c707b3          	sub	a5,a4,a2
8000dc16:	fff74713          	not	a4,a4
8000dc1a:	8ff9                	and	a5,a5,a4
8000dc1c:	8ff5                	and	a5,a5,a3
8000dc1e:	dbe5                	beqz	a5,8000dc0e <.Lstrlen_wordstrlen>
8000dc20:	1571                	add	a0,a0,-4
8000dc22:	01879713          	sll	a4,a5,0x18
8000dc26:	eb11                	bnez	a4,8000dc3a <.Lstrlen_done>
8000dc28:	0505                	add	a0,a0,1
8000dc2a:	01079713          	sll	a4,a5,0x10
8000dc2e:	e711                	bnez	a4,8000dc3a <.Lstrlen_done>
8000dc30:	0505                	add	a0,a0,1
8000dc32:	00879713          	sll	a4,a5,0x8
8000dc36:	e311                	bnez	a4,8000dc3a <.Lstrlen_done>
8000dc38:	0505                	add	a0,a0,1

8000dc3a <.Lstrlen_done>:
8000dc3a:	8d0d                	sub	a0,a0,a1
8000dc3c:	8082                	ret

Disassembly of section .text.libc.strnlen:

8000dc3e <strnlen>:
8000dc3e:	862a                	mv	a2,a0
8000dc40:	852e                	mv	a0,a1
8000dc42:	c9c9                	beqz	a1,8000dcd4 <.L528>
8000dc44:	00064783          	lbu	a5,0(a2)
8000dc48:	c7c9                	beqz	a5,8000dcd2 <.L534>
8000dc4a:	00367793          	and	a5,a2,3
8000dc4e:	00379693          	sll	a3,a5,0x3
8000dc52:	00f58533          	add	a0,a1,a5
8000dc56:	ffc67713          	and	a4,a2,-4
8000dc5a:	57fd                	li	a5,-1
8000dc5c:	00d797b3          	sll	a5,a5,a3
8000dc60:	4314                	lw	a3,0(a4)
8000dc62:	fff7c793          	not	a5,a5
8000dc66:	feff05b7          	lui	a1,0xfeff0
8000dc6a:	80808837          	lui	a6,0x80808
8000dc6e:	8fd5                	or	a5,a5,a3
8000dc70:	488d                	li	a7,3
8000dc72:	eff58593          	add	a1,a1,-257 # fefefeff <__APB_SRAM_segment_end__+0xaefdeff>
8000dc76:	08080813          	add	a6,a6,128 # 80808080 <__XPI0_segment_end__+0x8080>

8000dc7a <.L530>:
8000dc7a:	00a8ff63          	bgeu	a7,a0,8000dc98 <.L529>
8000dc7e:	00b786b3          	add	a3,a5,a1
8000dc82:	fff7c313          	not	t1,a5
8000dc86:	0066f6b3          	and	a3,a3,t1
8000dc8a:	0106f6b3          	and	a3,a3,a6
8000dc8e:	e689                	bnez	a3,8000dc98 <.L529>
8000dc90:	0711                	add	a4,a4,4
8000dc92:	1571                	add	a0,a0,-4
8000dc94:	431c                	lw	a5,0(a4)
8000dc96:	b7d5                	j	8000dc7a <.L530>

8000dc98 <.L529>:
8000dc98:	0ff7f593          	zext.b	a1,a5
8000dc9c:	c59d                	beqz	a1,8000dcca <.L531>
8000dc9e:	0087d593          	srl	a1,a5,0x8
8000dca2:	0ff5f593          	zext.b	a1,a1
8000dca6:	4685                	li	a3,1
8000dca8:	cd89                	beqz	a1,8000dcc2 <.L532>
8000dcaa:	0107d593          	srl	a1,a5,0x10
8000dcae:	0ff5f593          	zext.b	a1,a1
8000dcb2:	4689                	li	a3,2
8000dcb4:	c599                	beqz	a1,8000dcc2 <.L532>
8000dcb6:	010005b7          	lui	a1,0x1000
8000dcba:	468d                	li	a3,3
8000dcbc:	00b7e363          	bltu	a5,a1,8000dcc2 <.L532>
8000dcc0:	4691                	li	a3,4

8000dcc2 <.L532>:
8000dcc2:	85aa                	mv	a1,a0
8000dcc4:	00a6f363          	bgeu	a3,a0,8000dcca <.L531>
8000dcc8:	85b6                	mv	a1,a3

8000dcca <.L531>:
8000dcca:	8f11                	sub	a4,a4,a2
8000dccc:	00b70533          	add	a0,a4,a1
8000dcd0:	8082                	ret

8000dcd2 <.L534>:
8000dcd2:	4501                	li	a0,0

8000dcd4 <.L528>:
8000dcd4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

8000dcd6 <__SEGGER_RTL_stream_write>:
8000dcd6:	5154                	lw	a3,36(a0)
8000dcd8:	87ae                	mv	a5,a1
8000dcda:	853e                	mv	a0,a5
8000dcdc:	4585                	li	a1,1
8000dcde:	f21f906f          	j	80007bfe <fwrite>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

8000dce2 <__SEGGER_RTL_putc>:
8000dce2:	4918                	lw	a4,16(a0)
8000dce4:	1101                	add	sp,sp,-32
8000dce6:	0ff5f593          	zext.b	a1,a1
8000dcea:	cc22                	sw	s0,24(sp)
8000dcec:	ce06                	sw	ra,28(sp)
8000dcee:	00b107a3          	sb	a1,15(sp)
8000dcf2:	411c                	lw	a5,0(a0)
8000dcf4:	842a                	mv	s0,a0
8000dcf6:	cb05                	beqz	a4,8000dd26 <.L24>
8000dcf8:	4154                	lw	a3,4(a0)
8000dcfa:	00d7ff63          	bgeu	a5,a3,8000dd18 <.L26>
8000dcfe:	495c                	lw	a5,20(a0)
8000dd00:	00178693          	add	a3,a5,1 # 800001 <_flash_size+0x1>
8000dd04:	973e                	add	a4,a4,a5
8000dd06:	c954                	sw	a3,20(a0)
8000dd08:	00b70023          	sb	a1,0(a4)
8000dd0c:	4958                	lw	a4,20(a0)
8000dd0e:	4d1c                	lw	a5,24(a0)
8000dd10:	00f71463          	bne	a4,a5,8000dd18 <.L26>
8000dd14:	f79fa0ef          	jal	80008c8c <__SEGGER_RTL_prin_flush>

8000dd18 <.L26>:
8000dd18:	401c                	lw	a5,0(s0)
8000dd1a:	40f2                	lw	ra,28(sp)
8000dd1c:	0785                	add	a5,a5,1
8000dd1e:	c01c                	sw	a5,0(s0)
8000dd20:	4462                	lw	s0,24(sp)
8000dd22:	6105                	add	sp,sp,32
8000dd24:	8082                	ret

8000dd26 <.L24>:
8000dd26:	4558                	lw	a4,12(a0)
8000dd28:	c305                	beqz	a4,8000dd48 <.L28>
8000dd2a:	4154                	lw	a3,4(a0)
8000dd2c:	00178613          	add	a2,a5,1
8000dd30:	00d61463          	bne	a2,a3,8000dd38 <.L29>
8000dd34:	000107a3          	sb	zero,15(sp)

8000dd38 <.L29>:
8000dd38:	fed7f0e3          	bgeu	a5,a3,8000dd18 <.L26>
8000dd3c:	00f14683          	lbu	a3,15(sp)
8000dd40:	973e                	add	a4,a4,a5
8000dd42:	00d70023          	sb	a3,0(a4)
8000dd46:	bfc9                	j	8000dd18 <.L26>

8000dd48 <.L28>:
8000dd48:	4518                	lw	a4,8(a0)
8000dd4a:	c305                	beqz	a4,8000dd6a <.L30>
8000dd4c:	4154                	lw	a3,4(a0)
8000dd4e:	00178613          	add	a2,a5,1
8000dd52:	00d61463          	bne	a2,a3,8000dd5a <.L31>
8000dd56:	000107a3          	sb	zero,15(sp)

8000dd5a <.L31>:
8000dd5a:	fad7ffe3          	bgeu	a5,a3,8000dd18 <.L26>
8000dd5e:	078a                	sll	a5,a5,0x2
8000dd60:	973e                	add	a4,a4,a5
8000dd62:	00f14783          	lbu	a5,15(sp)
8000dd66:	c31c                	sw	a5,0(a4)
8000dd68:	bf45                	j	8000dd18 <.L26>

8000dd6a <.L30>:
8000dd6a:	5118                	lw	a4,32(a0)
8000dd6c:	d755                	beqz	a4,8000dd18 <.L26>
8000dd6e:	4154                	lw	a3,4(a0)
8000dd70:	fad7f4e3          	bgeu	a5,a3,8000dd18 <.L26>
8000dd74:	4605                	li	a2,1
8000dd76:	00f10593          	add	a1,sp,15
8000dd7a:	9702                	jalr	a4
8000dd7c:	bf71                	j	8000dd18 <.L26>

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

8000dd7e <__SEGGER_RTL_print_padding>:
8000dd7e:	1141                	add	sp,sp,-16
8000dd80:	c422                	sw	s0,8(sp)
8000dd82:	c226                	sw	s1,4(sp)
8000dd84:	c04a                	sw	s2,0(sp)
8000dd86:	c606                	sw	ra,12(sp)
8000dd88:	84aa                	mv	s1,a0
8000dd8a:	892e                	mv	s2,a1
8000dd8c:	8432                	mv	s0,a2

8000dd8e <.L37>:
8000dd8e:	147d                	add	s0,s0,-1
8000dd90:	00045863          	bgez	s0,8000dda0 <.L38>
8000dd94:	40b2                	lw	ra,12(sp)
8000dd96:	4422                	lw	s0,8(sp)
8000dd98:	4492                	lw	s1,4(sp)
8000dd9a:	4902                	lw	s2,0(sp)
8000dd9c:	0141                	add	sp,sp,16
8000dd9e:	8082                	ret

8000dda0 <.L38>:
8000dda0:	85ca                	mv	a1,s2
8000dda2:	8526                	mv	a0,s1
8000dda4:	3f3d                	jal	8000dce2 <__SEGGER_RTL_putc>
8000dda6:	b7e5                	j	8000dd8e <.L37>

Disassembly of section .text.libc.vfprintf_l:

8000dda8 <vfprintf_l>:
8000dda8:	711d                	add	sp,sp,-96
8000ddaa:	ce86                	sw	ra,92(sp)
8000ddac:	cca2                	sw	s0,88(sp)
8000ddae:	caa6                	sw	s1,84(sp)
8000ddb0:	1080                	add	s0,sp,96
8000ddb2:	c8ca                	sw	s2,80(sp)
8000ddb4:	c6ce                	sw	s3,76(sp)
8000ddb6:	8932                	mv	s2,a2
8000ddb8:	fad42623          	sw	a3,-84(s0)
8000ddbc:	89aa                	mv	s3,a0
8000ddbe:	fab42423          	sw	a1,-88(s0)
8000ddc2:	8befb0ef          	jal	80008e80 <__SEGGER_RTL_X_file_bufsize>
8000ddc6:	fa842583          	lw	a1,-88(s0)
8000ddca:	00f50793          	add	a5,a0,15
8000ddce:	9bc1                	and	a5,a5,-16
8000ddd0:	40f10133          	sub	sp,sp,a5
8000ddd4:	84aa                	mv	s1,a0
8000ddd6:	fb840513          	add	a0,s0,-72
8000ddda:	eeffa0ef          	jal	80008cc8 <__SEGGER_RTL_init_prin_l>
8000ddde:	800007b7          	lui	a5,0x80000
8000dde2:	fac42603          	lw	a2,-84(s0)
8000dde6:	17fd                	add	a5,a5,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
8000dde8:	faf42e23          	sw	a5,-68(s0)
8000ddec:	8000e7b7          	lui	a5,0x8000e
8000ddf0:	cd678793          	add	a5,a5,-810 # 8000dcd6 <__SEGGER_RTL_stream_write>
8000ddf4:	85ca                	mv	a1,s2
8000ddf6:	fb840513          	add	a0,s0,-72
8000ddfa:	fc242423          	sw	sp,-56(s0)
8000ddfe:	fc942823          	sw	s1,-48(s0)
8000de02:	fd342e23          	sw	s3,-36(s0)
8000de06:	fcf42c23          	sw	a5,-40(s0)
8000de0a:	2811                	jal	8000de1e <__SEGGER_RTL_vfprintf>
8000de0c:	fa040113          	add	sp,s0,-96
8000de10:	40f6                	lw	ra,92(sp)
8000de12:	4466                	lw	s0,88(sp)
8000de14:	44d6                	lw	s1,84(sp)
8000de16:	4946                	lw	s2,80(sp)
8000de18:	49b6                	lw	s3,76(sp)
8000de1a:	6125                	add	sp,sp,96
8000de1c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

8000de1e <__SEGGER_RTL_vfprintf>:
8000de1e:	800047b7          	lui	a5,0x80004
8000de22:	7175                	add	sp,sp,-144
8000de24:	95c78793          	add	a5,a5,-1700 # 8000395c <.L9>
8000de28:	c83e                	sw	a5,16(sp)
8000de2a:	800047b7          	lui	a5,0x80004
8000de2e:	dece                	sw	s3,124(sp)
8000de30:	dad6                	sw	s5,116(sp)
8000de32:	ceee                	sw	s11,92(sp)
8000de34:	c706                	sw	ra,140(sp)
8000de36:	c522                	sw	s0,136(sp)
8000de38:	c326                	sw	s1,132(sp)
8000de3a:	c14a                	sw	s2,128(sp)
8000de3c:	dcd2                	sw	s4,120(sp)
8000de3e:	d8da                	sw	s6,112(sp)
8000de40:	d6de                	sw	s7,108(sp)
8000de42:	d4e2                	sw	s8,104(sp)
8000de44:	d2e6                	sw	s9,100(sp)
8000de46:	d0ea                	sw	s10,96(sp)
8000de48:	9a078793          	add	a5,a5,-1632 # 800039a0 <.L45>
8000de4c:	00020db7          	lui	s11,0x20
8000de50:	89aa                	mv	s3,a0
8000de52:	8ab2                	mv	s5,a2
8000de54:	00052023          	sw	zero,0(a0)
8000de58:	ca3e                	sw	a5,20(sp)
8000de5a:	021d8d93          	add	s11,s11,33 # 20021 <__XPI0_segment_used_size__+0x13fcd>

8000de5e <.L2>:
8000de5e:	00158a13          	add	s4,a1,1 # 1000001 <_extram_size+0x1>
8000de62:	0005c583          	lbu	a1,0(a1)
8000de66:	e19d                	bnez	a1,8000de8c <.L229>
8000de68:	00c9a783          	lw	a5,12(s3)
8000de6c:	cb91                	beqz	a5,8000de80 <.L230>
8000de6e:	0009a703          	lw	a4,0(s3)
8000de72:	0049a683          	lw	a3,4(s3)
8000de76:	00d77563          	bgeu	a4,a3,8000de80 <.L230>
8000de7a:	97ba                	add	a5,a5,a4
8000de7c:	00078023          	sb	zero,0(a5)

8000de80 <.L230>:
8000de80:	854e                	mv	a0,s3
8000de82:	e0bfa0ef          	jal	80008c8c <__SEGGER_RTL_prin_flush>
8000de86:	0009a503          	lw	a0,0(s3)
8000de8a:	a2f9                	j	8000e058 <.L338>

8000de8c <.L229>:
8000de8c:	02500793          	li	a5,37
8000de90:	00f58563          	beq	a1,a5,8000de9a <.L231>

8000de94 <.L362>:
8000de94:	854e                	mv	a0,s3
8000de96:	35b1                	jal	8000dce2 <__SEGGER_RTL_putc>
8000de98:	aab9                	j	8000dff6 <.L4>

8000de9a <.L231>:
8000de9a:	4b81                	li	s7,0
8000de9c:	03000613          	li	a2,48
8000dea0:	05e00593          	li	a1,94
8000dea4:	6505                	lui	a0,0x1
8000dea6:	487d                	li	a6,31
8000dea8:	48c1                	li	a7,16
8000deaa:	6321                	lui	t1,0x8
8000deac:	a03d                	j	8000deda <.L3>

8000deae <.L5>:
8000deae:	04b78f63          	beq	a5,a1,8000df0c <.L15>

8000deb2 <.L232>:
8000deb2:	8a36                	mv	s4,a3
8000deb4:	4b01                	li	s6,0
8000deb6:	46a5                	li	a3,9
8000deb8:	45a9                	li	a1,10

8000deba <.L18>:
8000deba:	fd078713          	add	a4,a5,-48
8000debe:	0ff77613          	zext.b	a2,a4
8000dec2:	08c6e363          	bltu	a3,a2,8000df48 <.L20>
8000dec6:	02bb0b33          	mul	s6,s6,a1
8000deca:	0a05                	add	s4,s4,1
8000decc:	fffa4783          	lbu	a5,-1(s4)
8000ded0:	9b3a                	add	s6,s6,a4
8000ded2:	b7e5                	j	8000deba <.L18>

8000ded4 <.L14>:
8000ded4:	040beb93          	or	s7,s7,64

8000ded8 <.L16>:
8000ded8:	8a36                	mv	s4,a3

8000deda <.L3>:
8000deda:	000a4783          	lbu	a5,0(s4)
8000dede:	001a0693          	add	a3,s4,1
8000dee2:	fcf666e3          	bltu	a2,a5,8000deae <.L5>
8000dee6:	fcf876e3          	bgeu	a6,a5,8000deb2 <.L232>
8000deea:	fe078713          	add	a4,a5,-32
8000deee:	0ff77713          	zext.b	a4,a4
8000def2:	02e8e963          	bltu	a7,a4,8000df24 <.L7>
8000def6:	4442                	lw	s0,16(sp)
8000def8:	070a                	sll	a4,a4,0x2
8000defa:	9722                	add	a4,a4,s0
8000defc:	4318                	lw	a4,0(a4)
8000defe:	8702                	jr	a4

8000df00 <.L13>:
8000df00:	080beb93          	or	s7,s7,128
8000df04:	bfd1                	j	8000ded8 <.L16>

8000df06 <.L12>:
8000df06:	006bebb3          	or	s7,s7,t1
8000df0a:	b7f9                	j	8000ded8 <.L16>

8000df0c <.L15>:
8000df0c:	00abebb3          	or	s7,s7,a0
8000df10:	b7e1                	j	8000ded8 <.L16>

8000df12 <.L11>:
8000df12:	020beb93          	or	s7,s7,32
8000df16:	b7c9                	j	8000ded8 <.L16>

8000df18 <.L10>:
8000df18:	010beb93          	or	s7,s7,16
8000df1c:	bf75                	j	8000ded8 <.L16>

8000df1e <.L8>:
8000df1e:	200beb93          	or	s7,s7,512
8000df22:	bf5d                	j	8000ded8 <.L16>

8000df24 <.L7>:
8000df24:	02a00713          	li	a4,42
8000df28:	f8e795e3          	bne	a5,a4,8000deb2 <.L232>
8000df2c:	000aab03          	lw	s6,0(s5)
8000df30:	004a8713          	add	a4,s5,4
8000df34:	000b5663          	bgez	s6,8000df40 <.L19>
8000df38:	41600b33          	neg	s6,s6
8000df3c:	010beb93          	or	s7,s7,16

8000df40 <.L19>:
8000df40:	0006c783          	lbu	a5,0(a3) # 800000 <_flash_size>
8000df44:	0a09                	add	s4,s4,2
8000df46:	8aba                	mv	s5,a4

8000df48 <.L20>:
8000df48:	000b5363          	bgez	s6,8000df4e <.L22>
8000df4c:	4b01                	li	s6,0

8000df4e <.L22>:
8000df4e:	02e00713          	li	a4,46
8000df52:	4481                	li	s1,0
8000df54:	04e79263          	bne	a5,a4,8000df98 <.L23>
8000df58:	000a4783          	lbu	a5,0(s4)
8000df5c:	02a00713          	li	a4,42
8000df60:	02e78263          	beq	a5,a4,8000df84 <.L24>
8000df64:	0a05                	add	s4,s4,1
8000df66:	46a5                	li	a3,9
8000df68:	45a9                	li	a1,10

8000df6a <.L25>:
8000df6a:	fd078713          	add	a4,a5,-48
8000df6e:	0ff77613          	zext.b	a2,a4
8000df72:	00c6ef63          	bltu	a3,a2,8000df90 <.L26>
8000df76:	02b484b3          	mul	s1,s1,a1
8000df7a:	0a05                	add	s4,s4,1
8000df7c:	fffa4783          	lbu	a5,-1(s4)
8000df80:	94ba                	add	s1,s1,a4
8000df82:	b7e5                	j	8000df6a <.L25>

8000df84 <.L24>:
8000df84:	000aa483          	lw	s1,0(s5)
8000df88:	001a4783          	lbu	a5,1(s4)
8000df8c:	0a91                	add	s5,s5,4
8000df8e:	0a09                	add	s4,s4,2

8000df90 <.L26>:
8000df90:	0004c463          	bltz	s1,8000df98 <.L23>
8000df94:	100beb93          	or	s7,s7,256

8000df98 <.L23>:
8000df98:	06c00713          	li	a4,108
8000df9c:	06e78263          	beq	a5,a4,8000e000 <.L28>
8000dfa0:	02f76c63          	bltu	a4,a5,8000dfd8 <.L29>
8000dfa4:	06800713          	li	a4,104
8000dfa8:	06e78a63          	beq	a5,a4,8000e01c <.L30>
8000dfac:	06a00713          	li	a4,106
8000dfb0:	04e78563          	beq	a5,a4,8000dffa <.L31>

8000dfb4 <.L32>:
8000dfb4:	05700713          	li	a4,87
8000dfb8:	2ef764e3          	bltu	a4,a5,8000eaa0 <.L38>
8000dfbc:	04500713          	li	a4,69
8000dfc0:	2ce78763          	beq	a5,a4,8000e28e <.L39>
8000dfc4:	06f76763          	bltu	a4,a5,8000e032 <.L40>
8000dfc8:	c7c1                	beqz	a5,8000e050 <.L41>
8000dfca:	02500713          	li	a4,37
8000dfce:	02500593          	li	a1,37
8000dfd2:	ece781e3          	beq	a5,a4,8000de94 <.L362>
8000dfd6:	a005                	j	8000dff6 <.L4>

8000dfd8 <.L29>:
8000dfd8:	07400713          	li	a4,116
8000dfdc:	00e78663          	beq	a5,a4,8000dfe8 <.L346>
8000dfe0:	07a00713          	li	a4,122
8000dfe4:	2ae79ae3          	bne	a5,a4,8000ea98 <.L34>

8000dfe8 <.L346>:
8000dfe8:	000a4783          	lbu	a5,0(s4)
8000dfec:	0a05                	add	s4,s4,1

8000dfee <.L35>:
8000dfee:	07800713          	li	a4,120
8000dff2:	fcf771e3          	bgeu	a4,a5,8000dfb4 <.L32>

8000dff6 <.L4>:
8000dff6:	85d2                	mv	a1,s4
8000dff8:	b59d                	j	8000de5e <.L2>

8000dffa <.L31>:
8000dffa:	002beb93          	or	s7,s7,2
8000dffe:	b7ed                	j	8000dfe8 <.L346>

8000e000 <.L28>:
8000e000:	000a4783          	lbu	a5,0(s4)
8000e004:	00e79863          	bne	a5,a4,8000e014 <.L36>
8000e008:	002beb93          	or	s7,s7,2

8000e00c <.L347>:
8000e00c:	001a4783          	lbu	a5,1(s4)
8000e010:	0a09                	add	s4,s4,2
8000e012:	bff1                	j	8000dfee <.L35>

8000e014 <.L36>:
8000e014:	0a05                	add	s4,s4,1
8000e016:	001beb93          	or	s7,s7,1
8000e01a:	bfd1                	j	8000dfee <.L35>

8000e01c <.L30>:
8000e01c:	000a4783          	lbu	a5,0(s4)
8000e020:	00e79563          	bne	a5,a4,8000e02a <.L37>
8000e024:	008beb93          	or	s7,s7,8
8000e028:	b7d5                	j	8000e00c <.L347>

8000e02a <.L37>:
8000e02a:	0a05                	add	s4,s4,1
8000e02c:	004beb93          	or	s7,s7,4
8000e030:	bf7d                	j	8000dfee <.L35>

8000e032 <.L40>:
8000e032:	04600713          	li	a4,70
8000e036:	2ce78663          	beq	a5,a4,8000e302 <.L57>
8000e03a:	04700713          	li	a4,71
8000e03e:	fae79ce3          	bne	a5,a4,8000dff6 <.L4>
8000e042:	6789                	lui	a5,0x2
8000e044:	00fbebb3          	or	s7,s7,a5

8000e048 <.L52>:
8000e048:	6905                	lui	s2,0x1
8000e04a:	c0090913          	add	s2,s2,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000e04e:	a4c1                	j	8000e30e <.L353>

8000e050 <.L41>:
8000e050:	854e                	mv	a0,s3
8000e052:	c3bfa0ef          	jal	80008c8c <__SEGGER_RTL_prin_flush>
8000e056:	557d                	li	a0,-1

8000e058 <.L338>:
8000e058:	40ba                	lw	ra,140(sp)
8000e05a:	442a                	lw	s0,136(sp)
8000e05c:	449a                	lw	s1,132(sp)
8000e05e:	490a                	lw	s2,128(sp)
8000e060:	59f6                	lw	s3,124(sp)
8000e062:	5a66                	lw	s4,120(sp)
8000e064:	5ad6                	lw	s5,116(sp)
8000e066:	5b46                	lw	s6,112(sp)
8000e068:	5bb6                	lw	s7,108(sp)
8000e06a:	5c26                	lw	s8,104(sp)
8000e06c:	5c96                	lw	s9,100(sp)
8000e06e:	5d06                	lw	s10,96(sp)
8000e070:	4df6                	lw	s11,92(sp)
8000e072:	6149                	add	sp,sp,144
8000e074:	8082                	ret

8000e076 <.L55>:
8000e076:	000aa483          	lw	s1,0(s5)
8000e07a:	1b7d                	add	s6,s6,-1
8000e07c:	865a                	mv	a2,s6
8000e07e:	85de                	mv	a1,s7
8000e080:	854e                	mv	a0,s3
8000e082:	c2dfa0ef          	jal	80008cae <__SEGGER_RTL_pre_padding>
8000e086:	004a8413          	add	s0,s5,4
8000e08a:	0ff4f593          	zext.b	a1,s1
8000e08e:	854e                	mv	a0,s3
8000e090:	3989                	jal	8000dce2 <__SEGGER_RTL_putc>
8000e092:	8aa2                	mv	s5,s0

8000e094 <.L371>:
8000e094:	010bfb93          	and	s7,s7,16
8000e098:	f40b8fe3          	beqz	s7,8000dff6 <.L4>
8000e09c:	865a                	mv	a2,s6
8000e09e:	02000593          	li	a1,32
8000e0a2:	854e                	mv	a0,s3
8000e0a4:	39e9                	jal	8000dd7e <__SEGGER_RTL_print_padding>
8000e0a6:	bf81                	j	8000dff6 <.L4>

8000e0a8 <.L50>:
8000e0a8:	008bf693          	and	a3,s7,8
8000e0ac:	000aa783          	lw	a5,0(s5)
8000e0b0:	0009a703          	lw	a4,0(s3)
8000e0b4:	0a91                	add	s5,s5,4
8000e0b6:	c681                	beqz	a3,8000e0be <.L62>
8000e0b8:	00e78023          	sb	a4,0(a5) # 2000 <__APB_SRAM_segment_size__>
8000e0bc:	bf2d                	j	8000dff6 <.L4>

8000e0be <.L62>:
8000e0be:	002bfb93          	and	s7,s7,2
8000e0c2:	c398                	sw	a4,0(a5)
8000e0c4:	f20b89e3          	beqz	s7,8000dff6 <.L4>
8000e0c8:	0007a223          	sw	zero,4(a5)
8000e0cc:	b72d                	j	8000dff6 <.L4>

8000e0ce <.L47>:
8000e0ce:	000aa403          	lw	s0,0(s5)
8000e0d2:	895e                	mv	s2,s7
8000e0d4:	0a91                	add	s5,s5,4

8000e0d6 <.L65>:
8000e0d6:	e409                	bnez	s0,8000e0e0 <.L66>
8000e0d8:	80004437          	lui	s0,0x80004
8000e0dc:	92c40413          	add	s0,s0,-1748 # 8000392c <.LC0>

8000e0e0 <.L66>:
8000e0e0:	dff97b93          	and	s7,s2,-513
8000e0e4:	10097913          	and	s2,s2,256
8000e0e8:	02090563          	beqz	s2,8000e112 <.L67>
8000e0ec:	85a6                	mv	a1,s1
8000e0ee:	8522                	mv	a0,s0
8000e0f0:	36b9                	jal	8000dc3e <strnlen>

8000e0f2 <.L348>:
8000e0f2:	40ab0b33          	sub	s6,s6,a0
8000e0f6:	84aa                	mv	s1,a0
8000e0f8:	865a                	mv	a2,s6
8000e0fa:	85de                	mv	a1,s7
8000e0fc:	854e                	mv	a0,s3
8000e0fe:	bb1fa0ef          	jal	80008cae <__SEGGER_RTL_pre_padding>

8000e102 <.L69>:
8000e102:	d8c9                	beqz	s1,8000e094 <.L371>
8000e104:	00044583          	lbu	a1,0(s0)
8000e108:	854e                	mv	a0,s3
8000e10a:	0405                	add	s0,s0,1
8000e10c:	3ed9                	jal	8000dce2 <__SEGGER_RTL_putc>
8000e10e:	14fd                	add	s1,s1,-1
8000e110:	bfcd                	j	8000e102 <.L69>

8000e112 <.L67>:
8000e112:	8522                	mv	a0,s0
8000e114:	34c9                	jal	8000dbd6 <strlen>
8000e116:	bff1                	j	8000e0f2 <.L348>

8000e118 <.L48>:
8000e118:	080bf713          	and	a4,s7,128
8000e11c:	000aa403          	lw	s0,0(s5)
8000e120:	004a8693          	add	a3,s5,4
8000e124:	4581                	li	a1,0
8000e126:	02300c93          	li	s9,35
8000e12a:	e311                	bnez	a4,8000e12e <.L71>
8000e12c:	4c81                	li	s9,0

8000e12e <.L71>:
8000e12e:	100beb93          	or	s7,s7,256
8000e132:	8ab6                	mv	s5,a3
8000e134:	44a1                	li	s1,8

8000e136 <.L72>:
8000e136:	100bf713          	and	a4,s7,256
8000e13a:	e311                	bnez	a4,8000e13e <.L203>
8000e13c:	4485                	li	s1,1

8000e13e <.L203>:
8000e13e:	05800713          	li	a4,88
8000e142:	08e788e3          	beq	a5,a4,8000e9d2 <.L204>
8000e146:	f9c78693          	add	a3,a5,-100
8000e14a:	4705                	li	a4,1
8000e14c:	00d71733          	sll	a4,a4,a3
8000e150:	01b776b3          	and	a3,a4,s11
8000e154:	00069ae3          	bnez	a3,8000e968 <.L205>
8000e158:	00c75693          	srl	a3,a4,0xc
8000e15c:	1016f693          	and	a3,a3,257
8000e160:	060699e3          	bnez	a3,8000e9d2 <.L204>
8000e164:	06f00713          	li	a4,111
8000e168:	4c01                	li	s8,0
8000e16a:	08e793e3          	bne	a5,a4,8000e9f0 <.L206>

8000e16e <.L207>:
8000e16e:	00b467b3          	or	a5,s0,a1
8000e172:	06078fe3          	beqz	a5,8000e9f0 <.L206>
8000e176:	183c                	add	a5,sp,56
8000e178:	01878733          	add	a4,a5,s8
8000e17c:	00747793          	and	a5,s0,7
8000e180:	03078793          	add	a5,a5,48
8000e184:	00f70023          	sb	a5,0(a4)
8000e188:	800d                	srl	s0,s0,0x3
8000e18a:	01d59793          	sll	a5,a1,0x1d
8000e18e:	0c05                	add	s8,s8,1
8000e190:	8c5d                	or	s0,s0,a5
8000e192:	818d                	srl	a1,a1,0x3
8000e194:	bfe9                	j	8000e16e <.L207>

8000e196 <.L56>:
8000e196:	6709                	lui	a4,0x2
8000e198:	00ebebb3          	or	s7,s7,a4

8000e19c <.L44>:
8000e19c:	080bf713          	and	a4,s7,128
8000e1a0:	4c81                	li	s9,0
8000e1a2:	cb19                	beqz	a4,8000e1b8 <.L75>
8000e1a4:	6c8d                	lui	s9,0x3
8000e1a6:	07800713          	li	a4,120
8000e1aa:	058c8c93          	add	s9,s9,88 # 3058 <__APB_SRAM_segment_size__+0x1058>
8000e1ae:	00e79563          	bne	a5,a4,8000e1b8 <.L75>
8000e1b2:	6c8d                	lui	s9,0x3
8000e1b4:	078c8c93          	add	s9,s9,120 # 3078 <__APB_SRAM_segment_size__+0x1078>

8000e1b8 <.L75>:
8000e1b8:	100bf713          	and	a4,s7,256

8000e1bc <.L365>:
8000e1bc:	c319                	beqz	a4,8000e1c2 <.L74>
8000e1be:	dffbfb93          	and	s7,s7,-513

8000e1c2 <.L74>:
8000e1c2:	011b9613          	sll	a2,s7,0x11
8000e1c6:	002bf713          	and	a4,s7,2
8000e1ca:	004bf693          	and	a3,s7,4
8000e1ce:	08065563          	bgez	a2,8000e258 <.L76>
8000e1d2:	cf31                	beqz	a4,8000e22e <.L77>
8000e1d4:	007a8713          	add	a4,s5,7
8000e1d8:	9b61                	and	a4,a4,-8
8000e1da:	4300                	lw	s0,0(a4)
8000e1dc:	434c                	lw	a1,4(a4)
8000e1de:	00870a93          	add	s5,a4,8 # 2008 <__APB_SRAM_segment_size__+0x8>

8000e1e2 <.L78>:
8000e1e2:	cea1                	beqz	a3,8000e23a <.L79>
8000e1e4:	0442                	sll	s0,s0,0x10
8000e1e6:	8441                	sra	s0,s0,0x10

8000e1e8 <.L351>:
8000e1e8:	41f45593          	sra	a1,s0,0x1f

8000e1ec <.L80>:
8000e1ec:	0405dd63          	bgez	a1,8000e246 <.L82>
8000e1f0:	00803733          	snez	a4,s0
8000e1f4:	40b005b3          	neg	a1,a1
8000e1f8:	8d99                	sub	a1,a1,a4
8000e1fa:	40800433          	neg	s0,s0
8000e1fe:	02d00c93          	li	s9,45

8000e202 <.L84>:
8000e202:	100bf713          	and	a4,s7,256
8000e206:	db05                	beqz	a4,8000e136 <.L72>
8000e208:	dffbfb93          	and	s7,s7,-513
8000e20c:	b72d                	j	8000e136 <.L72>

8000e20e <.L49>:
8000e20e:	080bf713          	and	a4,s7,128
8000e212:	03000c93          	li	s9,48
8000e216:	f34d                	bnez	a4,8000e1b8 <.L75>
8000e218:	4c81                	li	s9,0
8000e21a:	bf79                	j	8000e1b8 <.L75>

8000e21c <.L46>:
8000e21c:	100bf713          	and	a4,s7,256
8000e220:	4c81                	li	s9,0
8000e222:	bf69                	j	8000e1bc <.L365>

8000e224 <.L51>:
8000e224:	6711                	lui	a4,0x4
8000e226:	00ebebb3          	or	s7,s7,a4
8000e22a:	4c81                	li	s9,0
8000e22c:	bf59                	j	8000e1c2 <.L74>

8000e22e <.L77>:
8000e22e:	000aa403          	lw	s0,0(s5)
8000e232:	0a91                	add	s5,s5,4
8000e234:	41f45593          	sra	a1,s0,0x1f
8000e238:	b76d                	j	8000e1e2 <.L78>

8000e23a <.L79>:
8000e23a:	008bf713          	and	a4,s7,8
8000e23e:	d75d                	beqz	a4,8000e1ec <.L80>
8000e240:	0462                	sll	s0,s0,0x18
8000e242:	8461                	sra	s0,s0,0x18
8000e244:	b755                	j	8000e1e8 <.L351>

8000e246 <.L82>:
8000e246:	020bf713          	and	a4,s7,32
8000e24a:	ef1d                	bnez	a4,8000e288 <.L239>
8000e24c:	040bf713          	and	a4,s7,64
8000e250:	db4d                	beqz	a4,8000e202 <.L84>
8000e252:	02000c93          	li	s9,32
8000e256:	b775                	j	8000e202 <.L84>

8000e258 <.L76>:
8000e258:	cf09                	beqz	a4,8000e272 <.L85>
8000e25a:	007a8713          	add	a4,s5,7
8000e25e:	9b61                	and	a4,a4,-8
8000e260:	4300                	lw	s0,0(a4)
8000e262:	434c                	lw	a1,4(a4)
8000e264:	00870a93          	add	s5,a4,8 # 4008 <__HEAPSIZE__+0x8>

8000e268 <.L86>:
8000e268:	ca91                	beqz	a3,8000e27c <.L87>
8000e26a:	0442                	sll	s0,s0,0x10
8000e26c:	8041                	srl	s0,s0,0x10

8000e26e <.L352>:
8000e26e:	4581                	li	a1,0
8000e270:	bf49                	j	8000e202 <.L84>

8000e272 <.L85>:
8000e272:	000aa403          	lw	s0,0(s5)
8000e276:	4581                	li	a1,0
8000e278:	0a91                	add	s5,s5,4
8000e27a:	b7fd                	j	8000e268 <.L86>

8000e27c <.L87>:
8000e27c:	008bf713          	and	a4,s7,8
8000e280:	d349                	beqz	a4,8000e202 <.L84>
8000e282:	0ff47413          	zext.b	s0,s0
8000e286:	b7e5                	j	8000e26e <.L352>

8000e288 <.L239>:
8000e288:	02b00c93          	li	s9,43
8000e28c:	bf9d                	j	8000e202 <.L84>

8000e28e <.L39>:
8000e28e:	6789                	lui	a5,0x2
8000e290:	00fbebb3          	or	s7,s7,a5

8000e294 <.L54>:
8000e294:	400be913          	or	s2,s7,1024

8000e298 <.L91>:
8000e298:	00297793          	and	a5,s2,2
8000e29c:	cfa5                	beqz	a5,8000e314 <.L92>
8000e29e:	000aa783          	lw	a5,0(s5)
8000e2a2:	1008                	add	a0,sp,32
8000e2a4:	004a8413          	add	s0,s5,4
8000e2a8:	4398                	lw	a4,0(a5)
8000e2aa:	8aa2                	mv	s5,s0
8000e2ac:	d03a                	sw	a4,32(sp)
8000e2ae:	43d8                	lw	a4,4(a5)
8000e2b0:	d23a                	sw	a4,36(sp)
8000e2b2:	4798                	lw	a4,8(a5)
8000e2b4:	d43a                	sw	a4,40(sp)
8000e2b6:	47dc                	lw	a5,12(a5)
8000e2b8:	d63e                	sw	a5,44(sp)
8000e2ba:	f18ff0ef          	jal	8000d9d2 <__trunctfsf2>
8000e2be:	8baa                	mv	s7,a0

8000e2c0 <.L93>:
8000e2c0:	10097793          	and	a5,s2,256
8000e2c4:	c3bd                	beqz	a5,8000e32a <.L240>
8000e2c6:	e889                	bnez	s1,8000e2d8 <.L94>
8000e2c8:	6785                	lui	a5,0x1
8000e2ca:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000e2ce:	00f974b3          	and	s1,s2,a5
8000e2d2:	8c9d                	sub	s1,s1,a5
8000e2d4:	0014b493          	seqz	s1,s1

8000e2d8 <.L94>:
8000e2d8:	855e                	mv	a0,s7
8000e2da:	eddf90ef          	jal	800081b6 <__SEGGER_RTL_float32_isinf>
8000e2de:	c921                	beqz	a0,8000e32e <.L95>

8000e2e0 <.L117>:
8000e2e0:	6409                	lui	s0,0x2
8000e2e2:	00000593          	li	a1,0
8000e2e6:	855e                	mv	a0,s7
8000e2e8:	00897433          	and	s0,s2,s0
8000e2ec:	b0ff90ef          	jal	80007dfa <__ltsf2>
8000e2f0:	40055b63          	bgez	a0,8000e706 <.L341>
8000e2f4:	40040463          	beqz	s0,8000e6fc <.L244>
8000e2f8:	80004437          	lui	s0,0x80004
8000e2fc:	93440413          	add	s0,s0,-1740 # 80003934 <.LC1>
8000e300:	a099                	j	8000e346 <.L122>

8000e302 <.L57>:
8000e302:	6789                	lui	a5,0x2
8000e304:	00fbebb3          	or	s7,s7,a5

8000e308 <.L53>:
8000e308:	6905                	lui	s2,0x1
8000e30a:	80090913          	add	s2,s2,-2048 # 800 <__ILM_segment_used_end__+0x402>

8000e30e <.L353>:
8000e30e:	012be933          	or	s2,s7,s2
8000e312:	b759                	j	8000e298 <.L91>

8000e314 <.L92>:
8000e314:	007a8793          	add	a5,s5,7
8000e318:	9be1                	and	a5,a5,-8
8000e31a:	4388                	lw	a0,0(a5)
8000e31c:	43cc                	lw	a1,4(a5)
8000e31e:	00878a93          	add	s5,a5,8 # 2008 <__APB_SRAM_segment_size__+0x8>
8000e322:	d83f90ef          	jal	800080a4 <__truncdfsf2>
8000e326:	8baa                	mv	s7,a0
8000e328:	bf61                	j	8000e2c0 <.L93>

8000e32a <.L240>:
8000e32a:	4499                	li	s1,6
8000e32c:	b775                	j	8000e2d8 <.L94>

8000e32e <.L95>:
8000e32e:	855e                	mv	a0,s7
8000e330:	e75f90ef          	jal	800081a4 <__SEGGER_RTL_float32_isnan>
8000e334:	c10d                	beqz	a0,8000e356 <.L101>
8000e336:	01291793          	sll	a5,s2,0x12
8000e33a:	0007d963          	bgez	a5,8000e34c <.L243>
8000e33e:	80004437          	lui	s0,0x80004
8000e342:	95440413          	add	s0,s0,-1708 # 80003954 <.LC5>

8000e346 <.L122>:
8000e346:	eff97913          	and	s2,s2,-257
8000e34a:	b371                	j	8000e0d6 <.L65>

8000e34c <.L243>:
8000e34c:	80004437          	lui	s0,0x80004
8000e350:	95840413          	add	s0,s0,-1704 # 80003958 <.LC6>
8000e354:	bfcd                	j	8000e346 <.L122>

8000e356 <.L101>:
8000e356:	855e                	mv	a0,s7
8000e358:	e6df90ef          	jal	800081c4 <__SEGGER_RTL_float32_isnormal>
8000e35c:	e119                	bnez	a0,8000e362 <.L103>
8000e35e:	00000b93          	li	s7,0

8000e362 <.L103>:
8000e362:	855e                	mv	a0,s7
8000e364:	845e                	mv	s0,s7
8000e366:	e90ff0ef          	jal	8000d9f6 <__SEGGER_RTL_float32_signbit>
8000e36a:	c519                	beqz	a0,8000e378 <.L104>
8000e36c:	80000437          	lui	s0,0x80000
8000e370:	06096913          	or	s2,s2,96
8000e374:	01744433          	xor	s0,s0,s7

8000e378 <.L104>:
8000e378:	184c                	add	a1,sp,52
8000e37a:	8522                	mv	a0,s0
8000e37c:	ec2ff0ef          	jal	8000da3e <frexpf>
8000e380:	5752                	lw	a4,52(sp)
8000e382:	478d                	li	a5,3
8000e384:	00000593          	li	a1,0
8000e388:	02e787b3          	mul	a5,a5,a4
8000e38c:	4729                	li	a4,10
8000e38e:	8522                	mv	a0,s0
8000e390:	8ba2                	mv	s7,s0
8000e392:	02e7c7b3          	div	a5,a5,a4
8000e396:	da3e                	sw	a5,52(sp)
8000e398:	d66ff0ef          	jal	8000d8fe <__eqsf2>
8000e39c:	24051a63          	bnez	a0,8000e5f0 <.L105>

8000e3a0 <.L111>:
8000e3a0:	6785                	lui	a5,0x1
8000e3a2:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000e3a6:	00f97c33          	and	s8,s2,a5
8000e3aa:	40000713          	li	a4,1024
8000e3ae:	5552                	lw	a0,52(sp)
8000e3b0:	26ec1763          	bne	s8,a4,8000e61e <.L340>

8000e3b4 <.L106>:
8000e3b4:	02600793          	li	a5,38
8000e3b8:	32f51963          	bne	a0,a5,8000e6ea <.L113>
8000e3bc:	800047b7          	lui	a5,0x80004
8000e3c0:	b387a583          	lw	a1,-1224(a5) # 80003b38 <.Lmerged_single+0x10>
8000e3c4:	855e                	mv	a0,s7
8000e3c6:	a74ff0ef          	jal	8000d63a <__divsf3>

8000e3ca <.L354>:
8000e3ca:	00000593          	li	a1,0
8000e3ce:	8baa                	mv	s7,a0
8000e3d0:	842a                	mv	s0,a0
8000e3d2:	d2cff0ef          	jal	8000d8fe <__eqsf2>
8000e3d6:	c52d                	beqz	a0,8000e440 <.L116>
8000e3d8:	855e                	mv	a0,s7
8000e3da:	dddf90ef          	jal	800081b6 <__SEGGER_RTL_float32_isinf>
8000e3de:	f00511e3          	bnez	a0,8000e2e0 <.L117>
8000e3e2:	57d2                	lw	a5,52(sp)
8000e3e4:	4701                	li	a4,0

8000e3e6 <.L118>:
8000e3e6:	80004cb7          	lui	s9,0x80004
8000e3ea:	c63e                	sw	a5,12(sp)
8000e3ec:	00178d13          	add	s10,a5,1
8000e3f0:	800047b7          	lui	a5,0x80004
8000e3f4:	b307a583          	lw	a1,-1232(a5) # 80003b30 <.Lmerged_single+0x8>
8000e3f8:	855e                	mv	a0,s7
8000e3fa:	cc3a                	sw	a4,24(sp)
8000e3fc:	aa1f90ef          	jal	80007e9c <__gesf2>
8000e400:	47b2                	lw	a5,12(sp)
8000e402:	4762                	lw	a4,24(sp)
8000e404:	32055163          	bgez	a0,8000e726 <.L124>
8000e408:	c319                	beqz	a4,8000e40e <.L125>
8000e40a:	845e                	mv	s0,s7
8000e40c:	da3e                	sw	a5,52(sp)

8000e40e <.L125>:
8000e40e:	80004637          	lui	a2,0x80004
8000e412:	b2c62703          	lw	a4,-1236(a2) # 80003b2c <.Lmerged_single+0x4>
8000e416:	5d52                	lw	s10,52(sp)
8000e418:	b30cac83          	lw	s9,-1232(s9) # 80003b30 <.Lmerged_single+0x8>
8000e41c:	87a2                	mv	a5,s0
8000e41e:	4681                	li	a3,0
8000e420:	c63a                	sw	a4,12(sp)

8000e422 <.L126>:
8000e422:	45b2                	lw	a1,12(sp)
8000e424:	853e                	mv	a0,a5
8000e426:	ce36                	sw	a3,28(sp)
8000e428:	cc3e                	sw	a5,24(sp)
8000e42a:	9d1f90ef          	jal	80007dfa <__ltsf2>
8000e42e:	47e2                	lw	a5,24(sp)
8000e430:	46f2                	lw	a3,28(sp)
8000e432:	fffd0b93          	add	s7,s10,-1
8000e436:	30054363          	bltz	a0,8000e73c <.L127>
8000e43a:	c299                	beqz	a3,8000e440 <.L116>
8000e43c:	843e                	mv	s0,a5
8000e43e:	da6a                	sw	s10,52(sp)

8000e440 <.L116>:
8000e440:	c499                	beqz	s1,8000e44e <.L129>
8000e442:	6785                	lui	a5,0x1
8000e444:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000e448:	00fc1363          	bne	s8,a5,8000e44e <.L129>
8000e44c:	14fd                	add	s1,s1,-1

8000e44e <.L129>:
8000e44e:	40900533          	neg	a0,s1
8000e452:	fe0fa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e456:	55fd                	li	a1,-1
8000e458:	da2ff0ef          	jal	8000d9fa <ldexpf>
8000e45c:	85a2                	mv	a1,s0
8000e45e:	feef90ef          	jal	80007c4c <__addsf3>
8000e462:	80004cb7          	lui	s9,0x80004
8000e466:	b30ca583          	lw	a1,-1232(s9) # 80003b30 <.Lmerged_single+0x8>
8000e46a:	8baa                	mv	s7,a0
8000e46c:	842a                	mv	s0,a0
8000e46e:	a2ff90ef          	jal	80007e9c <__gesf2>
8000e472:	00054b63          	bltz	a0,8000e488 <.L130>
8000e476:	57d2                	lw	a5,52(sp)
8000e478:	b30ca583          	lw	a1,-1232(s9)
8000e47c:	855e                	mv	a0,s7
8000e47e:	0785                	add	a5,a5,1
8000e480:	da3e                	sw	a5,52(sp)
8000e482:	9b8ff0ef          	jal	8000d63a <__divsf3>
8000e486:	842a                	mv	s0,a0

8000e488 <.L130>:
8000e488:	c622                	sw	s0,12(sp)
8000e48a:	2c049163          	bnez	s1,8000e74c <.L132>

8000e48e <.L135>:
8000e48e:	4481                	li	s1,0

8000e490 <.L133>:
8000e490:	00548793          	add	a5,s1,5
8000e494:	7c7d                	lui	s8,0xfffff
8000e496:	40fb0b33          	sub	s6,s6,a5
8000e49a:	08097793          	and	a5,s2,128
8000e49e:	7ffc0c13          	add	s8,s8,2047 # fffff7ff <__APB_SRAM_segment_end__+0xbf0d7ff>
8000e4a2:	8fc5                	or	a5,a5,s1
8000e4a4:	01897c33          	and	s8,s2,s8
8000e4a8:	c391                	beqz	a5,8000e4ac <.L139>
8000e4aa:	1b7d                	add	s6,s6,-1

8000e4ac <.L139>:
8000e4ac:	01391793          	sll	a5,s2,0x13
8000e4b0:	4d05                	li	s10,1
8000e4b2:	0207dc63          	bgez	a5,8000e4ea <.L140>
8000e4b6:	5bd2                	lw	s7,52(sp)
8000e4b8:	470d                	li	a4,3
8000e4ba:	02ebe733          	rem	a4,s7,a4
8000e4be:	c31d                	beqz	a4,8000e4e4 <.L141>
8000e4c0:	0709                	add	a4,a4,2
8000e4c2:	56b5                	li	a3,-19
8000e4c4:	40e6d733          	sra	a4,a3,a4
8000e4c8:	8b05                	and	a4,a4,1
8000e4ca:	2c070e63          	beqz	a4,8000e7a6 <.L142>
8000e4ce:	b30ca583          	lw	a1,-1232(s9)
8000e4d2:	4532                	lw	a0,12(sp)
8000e4d4:	1b7d                	add	s6,s6,-1
8000e4d6:	4d09                	li	s10,2
8000e4d8:	fa3fe0ef          	jal	8000d47a <__mulsf3>
8000e4dc:	fffb8793          	add	a5,s7,-1
8000e4e0:	842a                	mv	s0,a0
8000e4e2:	da3e                	sw	a5,52(sp)

8000e4e4 <.L141>:
8000e4e4:	0004d363          	bgez	s1,8000e4ea <.L140>
8000e4e8:	4481                	li	s1,0

8000e4ea <.L140>:
8000e4ea:	06097913          	and	s2,s2,96
8000e4ee:	00090363          	beqz	s2,8000e4f4 <.L144>
8000e4f2:	1b7d                	add	s6,s6,-1

8000e4f4 <.L144>:
8000e4f4:	5552                	lw	a0,52(sp)
8000e4f6:	dccfa0ef          	jal	80008ac2 <abs>
8000e4fa:	06300793          	li	a5,99
8000e4fe:	00a7d363          	bge	a5,a0,8000e504 <.L145>
8000e502:	1b7d                	add	s6,s6,-1

8000e504 <.L145>:
8000e504:	8522                	mv	a0,s0
8000e506:	c24ff0ef          	jal	8000d92a <__fixunssfdi>
8000e50a:	8bae                	mv	s7,a1
8000e50c:	8caa                	mv	s9,a0
8000e50e:	aedf90ef          	jal	80007ffa <__floatundisf>
8000e512:	85aa                	mv	a1,a0
8000e514:	8522                	mv	a0,s0
8000e516:	f2ef90ef          	jal	80007c44 <__subsf3>
8000e51a:	842a                	mv	s0,a0

8000e51c <.L146>:
8000e51c:	895a                	mv	s2,s6
8000e51e:	000b5363          	bgez	s6,8000e524 <.L165>
8000e522:	4901                	li	s2,0

8000e524 <.L165>:
8000e524:	210c7793          	and	a5,s8,528
8000e528:	e399                	bnez	a5,8000e52e <.L167>

8000e52a <.L166>:
8000e52a:	30091b63          	bnez	s2,8000e840 <.L168>

8000e52e <.L167>:
8000e52e:	020c7713          	and	a4,s8,32
8000e532:	040c7793          	and	a5,s8,64
8000e536:	30070c63          	beqz	a4,8000e84e <.L169>
8000e53a:	02b00593          	li	a1,43
8000e53e:	c399                	beqz	a5,8000e544 <.L358>
8000e540:	02d00593          	li	a1,45

8000e544 <.L358>:
8000e544:	854e                	mv	a0,s3
8000e546:	f9cff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>

8000e54a <.L171>:
8000e54a:	010c7793          	and	a5,s8,16
8000e54e:	e399                	bnez	a5,8000e554 <.L173>

8000e550 <.L172>:
8000e550:	30091463          	bnez	s2,8000e858 <.L174>

8000e554 <.L173>:
8000e554:	80003b37          	lui	s6,0x80003
8000e558:	098b0b13          	add	s6,s6,152 # 80003098 <__SEGGER_RTL_ipow10>

8000e55c <.L178>:
8000e55c:	1d7d                	add	s10,s10,-1
8000e55e:	003d1793          	sll	a5,s10,0x3
8000e562:	97da                	add	a5,a5,s6
8000e564:	4398                	lw	a4,0(a5)
8000e566:	43dc                	lw	a5,4(a5)
8000e568:	03000593          	li	a1,48

8000e56c <.L175>:
8000e56c:	00fbe663          	bltu	s7,a5,8000e578 <.L258>
8000e570:	2f779b63          	bne	a5,s7,8000e866 <.L176>
8000e574:	2eecf963          	bgeu	s9,a4,8000e866 <.L176>

8000e578 <.L258>:
8000e578:	854e                	mv	a0,s3
8000e57a:	f68ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e57e:	fc0d1fe3          	bnez	s10,8000e55c <.L178>
8000e582:	6b85                	lui	s7,0x1
8000e584:	800b8b93          	add	s7,s7,-2048 # 800 <__ILM_segment_used_end__+0x402>
8000e588:	017c7bb3          	and	s7,s8,s7
8000e58c:	300b9163          	bnez	s7,8000e88e <.L179>

8000e590 <.L183>:
8000e590:	080c7793          	and	a5,s8,128
8000e594:	8fc5                	or	a5,a5,s1
8000e596:	c3a1                	beqz	a5,8000e5d6 <.L181>
8000e598:	02e00593          	li	a1,46
8000e59c:	854e                	mv	a0,s3
8000e59e:	f44ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e5a2:	47c1                	li	a5,16
8000e5a4:	8ca6                	mv	s9,s1
8000e5a6:	2e97d863          	bge	a5,s1,8000e896 <.L186>
8000e5aa:	4cc1                	li	s9,16

8000e5ac <.L187>:
8000e5ac:	419484b3          	sub	s1,s1,s9
8000e5b0:	8566                	mv	a0,s9
8000e5b2:	000b8563          	beqz	s7,8000e5bc <.L359>
8000e5b6:	5552                	lw	a0,52(sp)
8000e5b8:	40ac8533          	sub	a0,s9,a0

8000e5bc <.L359>:
8000e5bc:	e76fa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e5c0:	85a2                	mv	a1,s0
8000e5c2:	eb9fe0ef          	jal	8000d47a <__mulsf3>
8000e5c6:	b64ff0ef          	jal	8000d92a <__fixunssfdi>
8000e5ca:	8baa                	mv	s7,a0
8000e5cc:	842e                	mv	s0,a1

8000e5ce <.L193>:
8000e5ce:	2c0c9863          	bnez	s9,8000e89e <.L194>

8000e5d2 <.L195>:
8000e5d2:	30049363          	bnez	s1,8000e8d8 <.L196>

8000e5d6 <.L181>:
8000e5d6:	400c7793          	and	a5,s8,1024
8000e5da:	30079663          	bnez	a5,8000e8e6 <.L184>

8000e5de <.L201>:
8000e5de:	a0090ce3          	beqz	s2,8000dff6 <.L4>
8000e5e2:	197d                	add	s2,s2,-1
8000e5e4:	02000593          	li	a1,32
8000e5e8:	a6b5                	j	8000e954 <.L360>

8000e5ea <.L108>:
8000e5ea:	57d2                	lw	a5,52(sp)
8000e5ec:	0785                	add	a5,a5,1
8000e5ee:	da3e                	sw	a5,52(sp)

8000e5f0 <.L105>:
8000e5f0:	5552                	lw	a0,52(sp)
8000e5f2:	0505                	add	a0,a0,1 # 1001 <__fw_size__+0x1>
8000e5f4:	e3efa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e5f8:	85aa                	mv	a1,a0
8000e5fa:	855e                	mv	a0,s7
8000e5fc:	86ff90ef          	jal	80007e6a <__gtsf2>
8000e600:	fea045e3          	bgtz	a0,8000e5ea <.L108>

8000e604 <.L109>:
8000e604:	5552                	lw	a0,52(sp)
8000e606:	e2cfa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e60a:	85aa                	mv	a1,a0
8000e60c:	855e                	mv	a0,s7
8000e60e:	fecf90ef          	jal	80007dfa <__ltsf2>
8000e612:	d80557e3          	bgez	a0,8000e3a0 <.L111>
8000e616:	57d2                	lw	a5,52(sp)
8000e618:	17fd                	add	a5,a5,-1
8000e61a:	da3e                	sw	a5,52(sp)
8000e61c:	b7e5                	j	8000e604 <.L109>

8000e61e <.L340>:
8000e61e:	00fc1763          	bne	s8,a5,8000e62c <.L112>
8000e622:	d89559e3          	bge	a0,s1,8000e3b4 <.L106>
8000e626:	57f1                	li	a5,-4
8000e628:	0cf54163          	blt	a0,a5,8000e6ea <.L113>

8000e62c <.L112>:
8000e62c:	08097793          	and	a5,s2,128
8000e630:	c63e                	sw	a5,12(sp)
8000e632:	40097793          	and	a5,s2,1024
8000e636:	c789                	beqz	a5,8000e640 <.L147>
8000e638:	47b9                	li	a5,14
8000e63a:	18a7d463          	bge	a5,a0,8000e7c2 <.L148>

8000e63e <.L153>:
8000e63e:	4481                	li	s1,0

8000e640 <.L147>:
8000e640:	57d2                	lw	a5,52(sp)
8000e642:	40900533          	neg	a0,s1
8000e646:	bff97c13          	and	s8,s2,-1025
8000e64a:	ff178713          	add	a4,a5,-15
8000e64e:	00e55463          	bge	a0,a4,8000e656 <.L154>
8000e652:	ff078513          	add	a0,a5,-16

8000e656 <.L154>:
8000e656:	ddcfa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e65a:	55fd                	li	a1,-1
8000e65c:	b9eff0ef          	jal	8000d9fa <ldexpf>
8000e660:	85aa                	mv	a1,a0
8000e662:	855e                	mv	a0,s7
8000e664:	de8f90ef          	jal	80007c4c <__addsf3>
8000e668:	8d2a                	mv	s10,a0
8000e66a:	842a                	mv	s0,a0
8000e66c:	5552                	lw	a0,52(sp)
8000e66e:	0505                	add	a0,a0,1
8000e670:	dc2fa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e674:	85ea                	mv	a1,s10
8000e676:	fbef90ef          	jal	80007e34 <__lesf2>
8000e67a:	00a04563          	bgtz	a0,8000e684 <.L156>
8000e67e:	57d2                	lw	a5,52(sp)
8000e680:	0785                	add	a5,a5,1
8000e682:	da3e                	sw	a5,52(sp)

8000e684 <.L156>:
8000e684:	57d2                	lw	a5,52(sp)
8000e686:	1a07c763          	bltz	a5,8000e834 <.L158>
8000e68a:	4541                	li	a0,16
8000e68c:	18f55663          	bge	a0,a5,8000e818 <.L159>
8000e690:	ff078713          	add	a4,a5,-16
8000e694:	8d1d                	sub	a0,a0,a5
8000e696:	da3a                	sw	a4,52(sp)
8000e698:	d9afa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e69c:	85ea                	mv	a1,s10
8000e69e:	dddfe0ef          	jal	8000d47a <__mulsf3>
8000e6a2:	a88ff0ef          	jal	8000d92a <__fixunssfdi>
8000e6a6:	8caa                	mv	s9,a0
8000e6a8:	8bae                	mv	s7,a1
8000e6aa:	00000413          	li	s0,0

8000e6ae <.L160>:
8000e6ae:	800037b7          	lui	a5,0x80003
8000e6b2:	09878793          	add	a5,a5,152 # 80003098 <__SEGGER_RTL_ipow10>
8000e6b6:	4d05                	li	s10,1

8000e6b8 <.L161>:
8000e6b8:	47d8                	lw	a4,12(a5)
8000e6ba:	07a1                	add	a5,a5,8
8000e6bc:	00ebe763          	bltu	s7,a4,8000e6ca <.L257>
8000e6c0:	17771e63          	bne	a4,s7,8000e83c <.L162>
8000e6c4:	4398                	lw	a4,0(a5)
8000e6c6:	16ecfb63          	bgeu	s9,a4,8000e83c <.L162>

8000e6ca <.L257>:
8000e6ca:	5752                	lw	a4,52(sp)
8000e6cc:	009d07b3          	add	a5,s10,s1
8000e6d0:	97ba                	add	a5,a5,a4
8000e6d2:	40fb0b33          	sub	s6,s6,a5
8000e6d6:	47b2                	lw	a5,12(sp)
8000e6d8:	8fc5                	or	a5,a5,s1
8000e6da:	c391                	beqz	a5,8000e6de <.L164>
8000e6dc:	1b7d                	add	s6,s6,-1

8000e6de <.L164>:
8000e6de:	06097793          	and	a5,s2,96
8000e6e2:	e2078de3          	beqz	a5,8000e51c <.L146>
8000e6e6:	1b7d                	add	s6,s6,-1
8000e6e8:	bd15                	j	8000e51c <.L146>

8000e6ea <.L113>:
8000e6ea:	40a00533          	neg	a0,a0
8000e6ee:	d44fa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e6f2:	85aa                	mv	a1,a0
8000e6f4:	855e                	mv	a0,s7
8000e6f6:	d85fe0ef          	jal	8000d47a <__mulsf3>
8000e6fa:	b9c1                	j	8000e3ca <.L354>

8000e6fc <.L244>:
8000e6fc:	80004437          	lui	s0,0x80004
8000e700:	93c40413          	add	s0,s0,-1732 # 8000393c <.LC2>
8000e704:	b189                	j	8000e346 <.L122>

8000e706 <.L341>:
8000e706:	c819                	beqz	s0,8000e71c <.L245>
8000e708:	80004437          	lui	s0,0x80004
8000e70c:	94440413          	add	s0,s0,-1724 # 80003944 <.LC3>

8000e710 <.L123>:
8000e710:	02097793          	and	a5,s2,32
8000e714:	c20799e3          	bnez	a5,8000e346 <.L122>
8000e718:	0405                	add	s0,s0,1
8000e71a:	b135                	j	8000e346 <.L122>

8000e71c <.L245>:
8000e71c:	80004437          	lui	s0,0x80004
8000e720:	94c40413          	add	s0,s0,-1716 # 8000394c <.LC4>
8000e724:	b7f5                	j	8000e710 <.L123>

8000e726 <.L124>:
8000e726:	800047b7          	lui	a5,0x80004
8000e72a:	b307a583          	lw	a1,-1232(a5) # 80003b30 <.Lmerged_single+0x8>
8000e72e:	855e                	mv	a0,s7
8000e730:	f0bfe0ef          	jal	8000d63a <__divsf3>
8000e734:	8baa                	mv	s7,a0
8000e736:	87ea                	mv	a5,s10
8000e738:	4705                	li	a4,1
8000e73a:	b175                	j	8000e3e6 <.L118>

8000e73c <.L127>:
8000e73c:	853e                	mv	a0,a5
8000e73e:	85e6                	mv	a1,s9
8000e740:	d3bfe0ef          	jal	8000d47a <__mulsf3>
8000e744:	87aa                	mv	a5,a0
8000e746:	8d5e                	mv	s10,s7
8000e748:	4685                	li	a3,1
8000e74a:	b9e1                	j	8000e422 <.L126>

8000e74c <.L132>:
8000e74c:	6785                	lui	a5,0x1
8000e74e:	88078793          	add	a5,a5,-1920 # 880 <__ILM_segment_used_end__+0x482>
8000e752:	00f977b3          	and	a5,s2,a5
8000e756:	80078793          	add	a5,a5,-2048
8000e75a:	d2079be3          	bnez	a5,8000e490 <.L133>
8000e75e:	47c1                	li	a5,16
8000e760:	0097d363          	bge	a5,s1,8000e766 <.L134>
8000e764:	44c1                	li	s1,16

8000e766 <.L134>:
8000e766:	8526                	mv	a0,s1
8000e768:	ccafa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e76c:	85a2                	mv	a1,s0
8000e76e:	d0dfe0ef          	jal	8000d47a <__mulsf3>
8000e772:	9b8ff0ef          	jal	8000d92a <__fixunssfdi>
8000e776:	00a5e7b3          	or	a5,a1,a0
8000e77a:	8c2a                	mv	s8,a0
8000e77c:	8d2e                	mv	s10,a1
8000e77e:	d00788e3          	beqz	a5,8000e48e <.L135>

8000e782 <.L357>:
8000e782:	4629                	li	a2,10
8000e784:	4681                	li	a3,0
8000e786:	f01f90ef          	jal	80008686 <__umoddi3>
8000e78a:	8d4d                	or	a0,a0,a1
8000e78c:	d00512e3          	bnez	a0,8000e490 <.L133>
8000e790:	8562                	mv	a0,s8
8000e792:	85ea                	mv	a1,s10
8000e794:	4629                	li	a2,10
8000e796:	4681                	li	a3,0
8000e798:	acff90ef          	jal	80008266 <__udivdi3>
8000e79c:	14fd                	add	s1,s1,-1
8000e79e:	8c2a                	mv	s8,a0
8000e7a0:	8d2e                	mv	s10,a1
8000e7a2:	f0e5                	bnez	s1,8000e782 <.L357>
8000e7a4:	b1ed                	j	8000e48e <.L135>

8000e7a6 <.L142>:
8000e7a6:	80004737          	lui	a4,0x80004
8000e7aa:	b3472583          	lw	a1,-1228(a4) # 80003b34 <.Lmerged_single+0xc>
8000e7ae:	4532                	lw	a0,12(sp)
8000e7b0:	1b79                	add	s6,s6,-2
8000e7b2:	4d0d                	li	s10,3
8000e7b4:	cc7fe0ef          	jal	8000d47a <__mulsf3>
8000e7b8:	ffeb8793          	add	a5,s7,-2
8000e7bc:	842a                	mv	s0,a0
8000e7be:	da3e                	sw	a5,52(sp)
8000e7c0:	b315                	j	8000e4e4 <.L141>

8000e7c2 <.L148>:
8000e7c2:	0505                	add	a0,a0,1
8000e7c4:	8c89                	sub	s1,s1,a0
8000e7c6:	47c1                	li	a5,16
8000e7c8:	0097d363          	bge	a5,s1,8000e7ce <.L149>
8000e7cc:	44c1                	li	s1,16

8000e7ce <.L149>:
8000e7ce:	08097793          	and	a5,s2,128
8000e7d2:	e60797e3          	bnez	a5,8000e640 <.L147>
8000e7d6:	800047b7          	lui	a5,0x80004
8000e7da:	b287ac03          	lw	s8,-1240(a5) # 80003b28 <.Lmerged_single>
8000e7de:	800047b7          	lui	a5,0x80004
8000e7e2:	b307a403          	lw	s0,-1232(a5) # 80003b30 <.Lmerged_single+0x8>

8000e7e6 <.L150>:
8000e7e6:	e4048ce3          	beqz	s1,8000e63e <.L153>
8000e7ea:	8526                	mv	a0,s1
8000e7ec:	c46fa0ef          	jal	80008c32 <__SEGGER_RTL_pow10f>
8000e7f0:	85aa                	mv	a1,a0
8000e7f2:	855e                	mv	a0,s7
8000e7f4:	c87fe0ef          	jal	8000d47a <__mulsf3>
8000e7f8:	85e2                	mv	a1,s8
8000e7fa:	c52f90ef          	jal	80007c4c <__addsf3>
8000e7fe:	9d9f90ef          	jal	800081d6 <floorf>
8000e802:	85a2                	mv	a1,s0
8000e804:	a66ff0ef          	jal	8000da6a <fmodf>
8000e808:	00000593          	li	a1,0
8000e80c:	8f2ff0ef          	jal	8000d8fe <__eqsf2>
8000e810:	e20518e3          	bnez	a0,8000e640 <.L147>
8000e814:	14fd                	add	s1,s1,-1
8000e816:	bfc1                	j	8000e7e6 <.L150>

8000e818 <.L159>:
8000e818:	856a                	mv	a0,s10
8000e81a:	da02                	sw	zero,52(sp)
8000e81c:	90eff0ef          	jal	8000d92a <__fixunssfdi>
8000e820:	8bae                	mv	s7,a1
8000e822:	8caa                	mv	s9,a0
8000e824:	fd6f90ef          	jal	80007ffa <__floatundisf>
8000e828:	85aa                	mv	a1,a0
8000e82a:	856a                	mv	a0,s10
8000e82c:	c18f90ef          	jal	80007c44 <__subsf3>
8000e830:	842a                	mv	s0,a0
8000e832:	bdb5                	j	8000e6ae <.L160>

8000e834 <.L158>:
8000e834:	da02                	sw	zero,52(sp)
8000e836:	4c81                	li	s9,0
8000e838:	4b81                	li	s7,0
8000e83a:	bd95                	j	8000e6ae <.L160>

8000e83c <.L162>:
8000e83c:	0d05                	add	s10,s10,1
8000e83e:	bdad                	j	8000e6b8 <.L161>

8000e840 <.L168>:
8000e840:	02000593          	li	a1,32
8000e844:	854e                	mv	a0,s3
8000e846:	197d                	add	s2,s2,-1
8000e848:	c9aff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e84c:	b9f9                	j	8000e52a <.L166>

8000e84e <.L169>:
8000e84e:	ce078ee3          	beqz	a5,8000e54a <.L171>
8000e852:	02000593          	li	a1,32
8000e856:	b1fd                	j	8000e544 <.L358>

8000e858 <.L174>:
8000e858:	03000593          	li	a1,48
8000e85c:	854e                	mv	a0,s3
8000e85e:	197d                	add	s2,s2,-1
8000e860:	c82ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e864:	b1f5                	j	8000e550 <.L172>

8000e866 <.L176>:
8000e866:	40ec86b3          	sub	a3,s9,a4
8000e86a:	00dcb633          	sltu	a2,s9,a3
8000e86e:	0585                	add	a1,a1,1
8000e870:	40fb8bb3          	sub	s7,s7,a5
8000e874:	0ff5f593          	zext.b	a1,a1
8000e878:	8cb6                	mv	s9,a3
8000e87a:	40cb8bb3          	sub	s7,s7,a2
8000e87e:	b1fd                	j	8000e56c <.L175>

8000e880 <.L182>:
8000e880:	17fd                	add	a5,a5,-1
8000e882:	03000593          	li	a1,48
8000e886:	854e                	mv	a0,s3
8000e888:	da3e                	sw	a5,52(sp)
8000e88a:	c58ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>

8000e88e <.L179>:
8000e88e:	57d2                	lw	a5,52(sp)
8000e890:	fef048e3          	bgtz	a5,8000e880 <.L182>
8000e894:	b9f5                	j	8000e590 <.L183>

8000e896 <.L186>:
8000e896:	d004dbe3          	bgez	s1,8000e5ac <.L187>
8000e89a:	4c81                	li	s9,0
8000e89c:	bb01                	j	8000e5ac <.L187>

8000e89e <.L194>:
8000e89e:	1cfd                	add	s9,s9,-1
8000e8a0:	003c9793          	sll	a5,s9,0x3
8000e8a4:	97da                	add	a5,a5,s6
8000e8a6:	4398                	lw	a4,0(a5)
8000e8a8:	43dc                	lw	a5,4(a5)
8000e8aa:	03000593          	li	a1,48

8000e8ae <.L190>:
8000e8ae:	00f46663          	bltu	s0,a5,8000e8ba <.L259>
8000e8b2:	00879863          	bne	a5,s0,8000e8c2 <.L191>
8000e8b6:	00ebf663          	bgeu	s7,a4,8000e8c2 <.L191>

8000e8ba <.L259>:
8000e8ba:	854e                	mv	a0,s3
8000e8bc:	c26ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e8c0:	b339                	j	8000e5ce <.L193>

8000e8c2 <.L191>:
8000e8c2:	40eb86b3          	sub	a3,s7,a4
8000e8c6:	00dbb633          	sltu	a2,s7,a3
8000e8ca:	0585                	add	a1,a1,1
8000e8cc:	8c1d                	sub	s0,s0,a5
8000e8ce:	0ff5f593          	zext.b	a1,a1
8000e8d2:	8bb6                	mv	s7,a3
8000e8d4:	8c11                	sub	s0,s0,a2
8000e8d6:	bfe1                	j	8000e8ae <.L190>

8000e8d8 <.L196>:
8000e8d8:	03000593          	li	a1,48
8000e8dc:	854e                	mv	a0,s3
8000e8de:	14fd                	add	s1,s1,-1
8000e8e0:	c02ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e8e4:	b1fd                	j	8000e5d2 <.L195>

8000e8e6 <.L184>:
8000e8e6:	012c1793          	sll	a5,s8,0x12
8000e8ea:	06500593          	li	a1,101
8000e8ee:	0007d463          	bgez	a5,8000e8f6 <.L197>
8000e8f2:	04500593          	li	a1,69

8000e8f6 <.L197>:
8000e8f6:	854e                	mv	a0,s3
8000e8f8:	beaff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e8fc:	57d2                	lw	a5,52(sp)
8000e8fe:	0407df63          	bgez	a5,8000e95c <.L198>
8000e902:	02d00593          	li	a1,45
8000e906:	854e                	mv	a0,s3
8000e908:	bdaff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e90c:	57d2                	lw	a5,52(sp)
8000e90e:	40f007b3          	neg	a5,a5
8000e912:	da3e                	sw	a5,52(sp)

8000e914 <.L199>:
8000e914:	55d2                	lw	a1,52(sp)
8000e916:	06300793          	li	a5,99
8000e91a:	00b7df63          	bge	a5,a1,8000e938 <.L200>
8000e91e:	06400413          	li	s0,100
8000e922:	0285c5b3          	div	a1,a1,s0
8000e926:	854e                	mv	a0,s3
8000e928:	03058593          	add	a1,a1,48
8000e92c:	bb6ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e930:	57d2                	lw	a5,52(sp)
8000e932:	0287e7b3          	rem	a5,a5,s0
8000e936:	da3e                	sw	a5,52(sp)

8000e938 <.L200>:
8000e938:	55d2                	lw	a1,52(sp)
8000e93a:	4429                	li	s0,10
8000e93c:	854e                	mv	a0,s3
8000e93e:	0285c5b3          	div	a1,a1,s0
8000e942:	03058593          	add	a1,a1,48
8000e946:	b9cff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e94a:	55d2                	lw	a1,52(sp)
8000e94c:	0285e5b3          	rem	a1,a1,s0
8000e950:	03058593          	add	a1,a1,48

8000e954 <.L360>:
8000e954:	854e                	mv	a0,s3
8000e956:	b8cff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e95a:	b151                	j	8000e5de <.L201>

8000e95c <.L198>:
8000e95c:	02b00593          	li	a1,43
8000e960:	854e                	mv	a0,s3
8000e962:	b80ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000e966:	b77d                	j	8000e914 <.L199>

8000e968 <.L205>:
8000e968:	6d21                	lui	s10,0x8
8000e96a:	892e                	mv	s2,a1
8000e96c:	4c01                	li	s8,0
8000e96e:	01abfd33          	and	s10,s7,s10
8000e972:	470d                	li	a4,3
8000e974:	02c00813          	li	a6,44

8000e978 <.L208>:
8000e978:	012467b3          	or	a5,s0,s2
8000e97c:	cbb5                	beqz	a5,8000e9f0 <.L206>
8000e97e:	000d0d63          	beqz	s10,8000e998 <.L214>
8000e982:	003c7793          	and	a5,s8,3
8000e986:	00e79963          	bne	a5,a4,8000e998 <.L214>
8000e98a:	030c0793          	add	a5,s8,48
8000e98e:	1018                	add	a4,sp,32
8000e990:	97ba                	add	a5,a5,a4
8000e992:	ff078423          	sb	a6,-24(a5)
8000e996:	0c05                	add	s8,s8,1

8000e998 <.L214>:
8000e998:	1018                	add	a4,sp,32
8000e99a:	030c0793          	add	a5,s8,48
8000e99e:	97ba                	add	a5,a5,a4
8000e9a0:	4629                	li	a2,10
8000e9a2:	4681                	li	a3,0
8000e9a4:	8522                	mv	a0,s0
8000e9a6:	85ca                	mv	a1,s2
8000e9a8:	c63e                	sw	a5,12(sp)
8000e9aa:	cddf90ef          	jal	80008686 <__umoddi3>
8000e9ae:	47b2                	lw	a5,12(sp)
8000e9b0:	03050513          	add	a0,a0,48
8000e9b4:	85ca                	mv	a1,s2
8000e9b6:	fea78423          	sb	a0,-24(a5)
8000e9ba:	4629                	li	a2,10
8000e9bc:	8522                	mv	a0,s0
8000e9be:	4681                	li	a3,0
8000e9c0:	8a7f90ef          	jal	80008266 <__udivdi3>
8000e9c4:	0c05                	add	s8,s8,1
8000e9c6:	842a                	mv	s0,a0
8000e9c8:	892e                	mv	s2,a1
8000e9ca:	02c00813          	li	a6,44
8000e9ce:	470d                	li	a4,3
8000e9d0:	b765                	j	8000e978 <.L208>

8000e9d2 <.L204>:
8000e9d2:	6709                	lui	a4,0x2
8000e9d4:	800046b7          	lui	a3,0x80004
8000e9d8:	80004637          	lui	a2,0x80004
8000e9dc:	4c01                	li	s8,0
8000e9de:	00ebf733          	and	a4,s7,a4
8000e9e2:	90c68693          	add	a3,a3,-1780 # 8000390c <__SEGGER_RTL_hex_lc>
8000e9e6:	91c60613          	add	a2,a2,-1764 # 8000391c <__SEGGER_RTL_hex_uc>

8000e9ea <.L209>:
8000e9ea:	00b467b3          	or	a5,s0,a1
8000e9ee:	e38d                	bnez	a5,8000ea10 <.L212>

8000e9f0 <.L206>:
8000e9f0:	418484b3          	sub	s1,s1,s8
8000e9f4:	0004d363          	bgez	s1,8000e9fa <.L216>
8000e9f8:	4481                	li	s1,0

8000e9fa <.L216>:
8000e9fa:	409b0b33          	sub	s6,s6,s1
8000e9fe:	0ff00793          	li	a5,255
8000ea02:	418b0b33          	sub	s6,s6,s8
8000ea06:	0397f863          	bgeu	a5,s9,8000ea36 <.L217>
8000ea0a:	1b7d                	add	s6,s6,-1

8000ea0c <.L218>:
8000ea0c:	1b7d                	add	s6,s6,-1
8000ea0e:	a035                	j	8000ea3a <.L219>

8000ea10 <.L212>:
8000ea10:	00f47793          	and	a5,s0,15
8000ea14:	cf19                	beqz	a4,8000ea32 <.L210>
8000ea16:	97b2                	add	a5,a5,a2

8000ea18 <.L361>:
8000ea18:	0007c783          	lbu	a5,0(a5)
8000ea1c:	1828                	add	a0,sp,56
8000ea1e:	9562                	add	a0,a0,s8
8000ea20:	00f50023          	sb	a5,0(a0)
8000ea24:	8011                	srl	s0,s0,0x4
8000ea26:	01c59793          	sll	a5,a1,0x1c
8000ea2a:	0c05                	add	s8,s8,1
8000ea2c:	8c5d                	or	s0,s0,a5
8000ea2e:	8191                	srl	a1,a1,0x4
8000ea30:	bf6d                	j	8000e9ea <.L209>

8000ea32 <.L210>:
8000ea32:	97b6                	add	a5,a5,a3
8000ea34:	b7d5                	j	8000ea18 <.L361>

8000ea36 <.L217>:
8000ea36:	fc0c9be3          	bnez	s9,8000ea0c <.L218>

8000ea3a <.L219>:
8000ea3a:	200bf793          	and	a5,s7,512
8000ea3e:	e799                	bnez	a5,8000ea4c <.L220>
8000ea40:	865a                	mv	a2,s6
8000ea42:	85de                	mv	a1,s7
8000ea44:	854e                	mv	a0,s3
8000ea46:	a68fa0ef          	jal	80008cae <__SEGGER_RTL_pre_padding>
8000ea4a:	4b01                	li	s6,0

8000ea4c <.L220>:
8000ea4c:	0ff00793          	li	a5,255
8000ea50:	0197fc63          	bgeu	a5,s9,8000ea68 <.L221>
8000ea54:	03000593          	li	a1,48
8000ea58:	854e                	mv	a0,s3
8000ea5a:	a88ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>

8000ea5e <.L222>:
8000ea5e:	85e6                	mv	a1,s9
8000ea60:	854e                	mv	a0,s3
8000ea62:	a80ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000ea66:	a019                	j	8000ea6c <.L223>

8000ea68 <.L221>:
8000ea68:	fe0c9be3          	bnez	s9,8000ea5e <.L222>

8000ea6c <.L223>:
8000ea6c:	865a                	mv	a2,s6
8000ea6e:	85de                	mv	a1,s7
8000ea70:	854e                	mv	a0,s3
8000ea72:	a3cfa0ef          	jal	80008cae <__SEGGER_RTL_pre_padding>
8000ea76:	8626                	mv	a2,s1
8000ea78:	03000593          	li	a1,48
8000ea7c:	854e                	mv	a0,s3
8000ea7e:	b00ff0ef          	jal	8000dd7e <__SEGGER_RTL_print_padding>

8000ea82 <.L224>:
8000ea82:	1c7d                	add	s8,s8,-1
8000ea84:	e00c4863          	bltz	s8,8000e094 <.L371>
8000ea88:	183c                	add	a5,sp,56
8000ea8a:	97e2                	add	a5,a5,s8
8000ea8c:	0007c583          	lbu	a1,0(a5)
8000ea90:	854e                	mv	a0,s3
8000ea92:	a50ff0ef          	jal	8000dce2 <__SEGGER_RTL_putc>
8000ea96:	b7f5                	j	8000ea82 <.L224>

8000ea98 <.L34>:
8000ea98:	07800713          	li	a4,120
8000ea9c:	d4f76d63          	bltu	a4,a5,8000dff6 <.L4>

8000eaa0 <.L38>:
8000eaa0:	fa878713          	add	a4,a5,-88
8000eaa4:	0ff77713          	zext.b	a4,a4
8000eaa8:	02000693          	li	a3,32
8000eaac:	d4e6e563          	bltu	a3,a4,8000dff6 <.L4>
8000eab0:	46d2                	lw	a3,20(sp)
8000eab2:	070a                	sll	a4,a4,0x2
8000eab4:	9736                	add	a4,a4,a3
8000eab6:	4318                	lw	a4,0(a4)
8000eab8:	8702                	jr	a4

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

8000eaba <__SEGGER_RTL_ascii_isctype>:
8000eaba:	07f00793          	li	a5,127
8000eabe:	02a7e263          	bltu	a5,a0,8000eae2 <.L3>
8000eac2:	800047b7          	lui	a5,0x80004
8000eac6:	aa878793          	add	a5,a5,-1368 # 80003aa8 <__SEGGER_RTL_ascii_ctype_map>
8000eaca:	953e                	add	a0,a0,a5
8000eacc:	800047b7          	lui	a5,0x80004
8000ead0:	46478793          	add	a5,a5,1124 # 80004464 <__SEGGER_RTL_ascii_ctype_mask>
8000ead4:	95be                	add	a1,a1,a5
8000ead6:	00054503          	lbu	a0,0(a0)
8000eada:	0005c783          	lbu	a5,0(a1)
8000eade:	8d7d                	and	a0,a0,a5
8000eae0:	8082                	ret

8000eae2 <.L3>:
8000eae2:	4501                	li	a0,0
8000eae4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

8000eae6 <__SEGGER_RTL_ascii_tolower>:
8000eae6:	fbf50713          	add	a4,a0,-65
8000eaea:	47e5                	li	a5,25
8000eaec:	00e7e463          	bltu	a5,a4,8000eaf4 <.L7>
8000eaf0:	02050513          	add	a0,a0,32

8000eaf4 <.L7>:
8000eaf4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

8000eaf6 <__SEGGER_RTL_ascii_iswctype>:
8000eaf6:	07f00793          	li	a5,127
8000eafa:	02a7e263          	bltu	a5,a0,8000eb1e <.L10>
8000eafe:	800047b7          	lui	a5,0x80004
8000eb02:	aa878793          	add	a5,a5,-1368 # 80003aa8 <__SEGGER_RTL_ascii_ctype_map>
8000eb06:	953e                	add	a0,a0,a5
8000eb08:	800047b7          	lui	a5,0x80004
8000eb0c:	46478793          	add	a5,a5,1124 # 80004464 <__SEGGER_RTL_ascii_ctype_mask>
8000eb10:	95be                	add	a1,a1,a5
8000eb12:	00054503          	lbu	a0,0(a0)
8000eb16:	0005c783          	lbu	a5,0(a1)
8000eb1a:	8d7d                	and	a0,a0,a5
8000eb1c:	8082                	ret

8000eb1e <.L10>:
8000eb1e:	4501                	li	a0,0
8000eb20:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

8000eb22 <__SEGGER_RTL_ascii_towlower>:
8000eb22:	fbf50713          	add	a4,a0,-65
8000eb26:	47e5                	li	a5,25
8000eb28:	00e7e463          	bltu	a5,a4,8000eb30 <.L14>
8000eb2c:	02050513          	add	a0,a0,32

8000eb30 <.L14>:
8000eb30:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

8000eb32 <__SEGGER_RTL_ascii_wctomb>:
8000eb32:	07f00793          	li	a5,127
8000eb36:	00b7e663          	bltu	a5,a1,8000eb42 <.L66>
8000eb3a:	00b50023          	sb	a1,0(a0)
8000eb3e:	4505                	li	a0,1
8000eb40:	8082                	ret

8000eb42 <.L66>:
8000eb42:	5579                	li	a0,-2
8000eb44:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

8000eb46 <__SEGGER_RTL_current_locale>:
8000eb46:	1581a503          	lw	a0,344(gp) # 1080958 <__SEGGER_RTL_locale_ptr>
8000eb4a:	e119                	bnez	a0,8000eb50 <.L155>
8000eb4c:	82c18513          	add	a0,gp,-2004 # 108002c <__RAL_global_locale>

8000eb50 <.L155>:
8000eb50:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

8000f024 <__SEGGER_init_zero>:
8000f024:	4008                	lw	a0,0(s0)
8000f026:	404c                	lw	a1,4(s0)
8000f028:	0421                	add	s0,s0,8
8000f02a:	c591                	beqz	a1,8000f036 <.L__SEGGER_init_zero_Done>

8000f02c <.L__SEGGER_init_zero_Loop>:
8000f02c:	00050023          	sb	zero,0(a0)
8000f030:	0505                	add	a0,a0,1
8000f032:	15fd                	add	a1,a1,-1
8000f034:	fde5                	bnez	a1,8000f02c <.L__SEGGER_init_zero_Loop>

8000f036 <.L__SEGGER_init_zero_Done>:
8000f036:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

8000f038 <__SEGGER_init_copy>:
8000f038:	4008                	lw	a0,0(s0)
8000f03a:	404c                	lw	a1,4(s0)
8000f03c:	4410                	lw	a2,8(s0)
8000f03e:	0431                	add	s0,s0,12
8000f040:	ca09                	beqz	a2,8000f052 <.L__SEGGER_init_copy_Done>

8000f042 <.L__SEGGER_init_copy_Loop>:
8000f042:	00058683          	lb	a3,0(a1)
8000f046:	00d50023          	sb	a3,0(a0)
8000f04a:	0505                	add	a0,a0,1
8000f04c:	0585                	add	a1,a1,1
8000f04e:	167d                	add	a2,a2,-1
8000f050:	fa6d                	bnez	a2,8000f042 <.L__SEGGER_init_copy_Loop>

8000f052 <.L__SEGGER_init_copy_Done>:
8000f052:	8082                	ret
