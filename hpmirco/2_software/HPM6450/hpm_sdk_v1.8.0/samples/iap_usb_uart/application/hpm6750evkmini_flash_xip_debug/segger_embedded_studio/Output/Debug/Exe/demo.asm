
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80020000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80020000:	800211b7          	lui	gp,0x80021
        addi    gp, gp, %lo(__global_pointer$)
80020004:	8a418193          	add	gp,gp,-1884 # 800208a4 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80020008:	01081237          	lui	tp,0x1081
        addi    tp, tp, %lo(__thread_pointer$)
8002000c:	80020213          	add	tp,tp,-2048 # 1080800 <__thread_pointer$>
        .option pop

        csrw    mstatus, zero
80020010:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
80020014:	34201073          	csrw	mcause,zero
    /* Initialize FCSR */
    fscsr zero
#endif

    /* Enable LMM1 clock */
    la t0, 0xF4000800
80020018:	f40012b7          	lui	t0,0xf4001
8002001c:	80028293          	add	t0,t0,-2048 # f4000800 <__AHB_SRAM_segment_end__+0x3cf8800>
    lw t1, 0(t0)
80020020:	0002a303          	lw	t1,0(t0)
    ori t1, t1, 0x80
80020024:	08036313          	or	t1,t1,128
    sw t1, 0(t0)
80020028:	0062a023          	sw	t1,0(t0)
    la t0, _stack_safe
    mv sp, t0
    call _init_ext_ram
#endif

        lui     t0,     %hi(__stack_end__)
8002002c:	000c02b7          	lui	t0,0xc0
        addi    sp, t0, %lo(__stack_end__)
80020030:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
80020034:	43f010ef          	jal	80021c72 <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80020038:	405010ef          	jal	80021c3c <l1c_dc_enable>
        call    l1c_dc_invalidate_all
8002003c:	3af030ef          	jal	80023bea <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
80020040:	10b030ef          	jal	8002394a <_init>

80020044 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80020044:	80025437          	lui	s0,0x80025
80020048:	79440413          	add	s0,s0,1940 # 80025794 <.L155+0x4>

8002004c <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
8002004c:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
8002004e:	0411                	add	s0,s0,4
        jalr    a0                              // Call initialization function
80020050:	9502                	jalr	a0
        j       L(RunInit)
80020052:	bfed                	j	8002004c <.L_start_RunInit>

80020054 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
80020054:	033030ef          	jal	80023886 <_clean_up>

80020058 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80020058:	000002b7          	lui	t0,0x0
8002005c:	00028293          	mv	t0,t0
    csrw mtvec, t0
80020060:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
80020064:	7d016073          	csrs	0x7d0,2

80020068 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80020068:	0cb030ef          	jal	80023932 <reset_handler>
        tail    exit
8002006c:	a009                	j	8002006e <exit>

8002006e <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
8002006e:	a001                	j	8002006e <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
80020070:	4501                	li	a0,0
        li      a1, 0
80020072:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
80020074:	0bf030ef          	jal	80023932 <reset_handler>
        tail    exit
80020078:	bfdd                	j	8002006e <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

8002007a <__SEGGER_RTL_SIGNAL_SIG_DFL>:
8002007a:	8082                	ret

Disassembly of section .text.pllctl_pll_poweron:

80020bd6 <pllctl_pll_poweron>:
 * @param[in] pll Target PLL index
 *
 * @return status_success if everything is okay
 */
static inline hpm_stat_t pllctl_pll_poweron(PLLCTL_Type *ptr, uint8_t pll)
{
80020bd6:	1101                	add	sp,sp,-32
80020bd8:	c62a                	sw	a0,12(sp)
80020bda:	87ae                	mv	a5,a1
80020bdc:	00f105a3          	sb	a5,11(sp)
    uint32_t cfg;
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
80020be0:	00b14703          	lbu	a4,11(sp)
80020be4:	4791                	li	a5,4
80020be6:	00e7f463          	bgeu	a5,a4,80020bee <.L8>
        return status_invalid_argument;
80020bea:	4789                	li	a5,2
80020bec:	a849                	j	80020c7e <.L9>

80020bee <.L8>:
    }

    cfg = ptr->PLL[pll].CFG1;
80020bee:	00b14783          	lbu	a5,11(sp)
80020bf2:	4732                	lw	a4,12(sp)
80020bf4:	0785                	add	a5,a5,1
80020bf6:	079e                	sll	a5,a5,0x7
80020bf8:	97ba                	add	a5,a5,a4
80020bfa:	43dc                	lw	a5,4(a5)
80020bfc:	ce3e                	sw	a5,28(sp)
    if (!(cfg & PLLCTL_PLL_CFG1_PLLPD_SW_MASK)) {
80020bfe:	4772                	lw	a4,28(sp)
80020c00:	020007b7          	lui	a5,0x2000
80020c04:	8ff9                	and	a5,a5,a4
80020c06:	e399                	bnez	a5,80020c0c <.L10>
        return status_success;
80020c08:	4781                	li	a5,0
80020c0a:	a895                	j	80020c7e <.L9>

80020c0c <.L10>:
    }

    if (cfg & PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK) {
80020c0c:	47f2                	lw	a5,28(sp)
80020c0e:	0207d463          	bgez	a5,80020c36 <.L11>
        ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
80020c12:	00b14783          	lbu	a5,11(sp)
80020c16:	4732                	lw	a4,12(sp)
80020c18:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
80020c1a:	079e                	sll	a5,a5,0x7
80020c1c:	97ba                	add	a5,a5,a4
80020c1e:	43d4                	lw	a3,4(a5)
80020c20:	00b14783          	lbu	a5,11(sp)
80020c24:	80000737          	lui	a4,0x80000
80020c28:	177d                	add	a4,a4,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
80020c2a:	8f75                	and	a4,a4,a3
80020c2c:	46b2                	lw	a3,12(sp)
80020c2e:	0785                	add	a5,a5,1
80020c30:	079e                	sll	a5,a5,0x7
80020c32:	97b6                	add	a5,a5,a3
80020c34:	c3d8                	sw	a4,4(a5)

80020c36 <.L11>:
    }

    ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
80020c36:	00b14783          	lbu	a5,11(sp)
80020c3a:	4732                	lw	a4,12(sp)
80020c3c:	0785                	add	a5,a5,1
80020c3e:	079e                	sll	a5,a5,0x7
80020c40:	97ba                	add	a5,a5,a4
80020c42:	43d4                	lw	a3,4(a5)
80020c44:	00b14783          	lbu	a5,11(sp)
80020c48:	fe000737          	lui	a4,0xfe000
80020c4c:	177d                	add	a4,a4,-1 # fdffffff <__APB_SRAM_segment_end__+0x9f0dfff>
80020c4e:	8f75                	and	a4,a4,a3
80020c50:	46b2                	lw	a3,12(sp)
80020c52:	0785                	add	a5,a5,1
80020c54:	079e                	sll	a5,a5,0x7
80020c56:	97b6                	add	a5,a5,a3
80020c58:	c3d8                	sw	a4,4(a5)

    /*
     * put back to hardware mode
     */
    ptr->PLL[pll].CFG1 |= PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
80020c5a:	00b14783          	lbu	a5,11(sp)
80020c5e:	4732                	lw	a4,12(sp)
80020c60:	0785                	add	a5,a5,1
80020c62:	079e                	sll	a5,a5,0x7
80020c64:	97ba                	add	a5,a5,a4
80020c66:	43d4                	lw	a3,4(a5)
80020c68:	00b14783          	lbu	a5,11(sp)
80020c6c:	80000737          	lui	a4,0x80000
80020c70:	8f55                	or	a4,a4,a3
80020c72:	46b2                	lw	a3,12(sp)
80020c74:	0785                	add	a5,a5,1
80020c76:	079e                	sll	a5,a5,0x7
80020c78:	97b6                	add	a5,a5,a3
80020c7a:	c3d8                	sw	a4,4(a5)
    return status_success;
80020c7c:	4781                	li	a5,0

80020c7e <.L9>:
}
80020c7e:	853e                	mv	a0,a5
80020c80:	6105                	add	sp,sp,32
80020c82:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

80020ca2 <read_pmp_cfg>:
 */
#include "hpm_pmp_drv.h"
#include "hpm_csr_drv.h"

uint32_t read_pmp_cfg(uint32_t idx)
{
80020ca2:	7179                	add	sp,sp,-48
80020ca4:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
80020ca6:	d602                	sw	zero,44(sp)
    switch (idx) {
80020ca8:	4732                	lw	a4,12(sp)
80020caa:	478d                	li	a5,3
80020cac:	04f70763          	beq	a4,a5,80020cfa <.L2>
80020cb0:	4732                	lw	a4,12(sp)
80020cb2:	478d                	li	a5,3
80020cb4:	04e7e963          	bltu	a5,a4,80020d06 <.L9>
80020cb8:	4732                	lw	a4,12(sp)
80020cba:	4789                	li	a5,2
80020cbc:	02f70963          	beq	a4,a5,80020cee <.L4>
80020cc0:	4732                	lw	a4,12(sp)
80020cc2:	4789                	li	a5,2
80020cc4:	04e7e163          	bltu	a5,a4,80020d06 <.L9>
80020cc8:	47b2                	lw	a5,12(sp)
80020cca:	c791                	beqz	a5,80020cd6 <.L5>
80020ccc:	4732                	lw	a4,12(sp)
80020cce:	4785                	li	a5,1
80020cd0:	00f70963          	beq	a4,a5,80020ce2 <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
80020cd4:	a80d                	j	80020d06 <.L9>

80020cd6 <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
80020cd6:	3a0027f3          	csrr	a5,pmpcfg0
80020cda:	ce3e                	sw	a5,28(sp)
80020cdc:	47f2                	lw	a5,28(sp)

80020cde <.LBE2>:
80020cde:	d63e                	sw	a5,44(sp)
        break;
80020ce0:	a025                	j	80020d08 <.L7>

80020ce2 <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
80020ce2:	3a1027f3          	csrr	a5,pmpcfg1
80020ce6:	d03e                	sw	a5,32(sp)
80020ce8:	5782                	lw	a5,32(sp)

80020cea <.LBE3>:
80020cea:	d63e                	sw	a5,44(sp)
        break;
80020cec:	a831                	j	80020d08 <.L7>

80020cee <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
80020cee:	3a2027f3          	csrr	a5,pmpcfg2
80020cf2:	d23e                	sw	a5,36(sp)
80020cf4:	5792                	lw	a5,36(sp)

80020cf6 <.LBE4>:
80020cf6:	d63e                	sw	a5,44(sp)
        break;
80020cf8:	a801                	j	80020d08 <.L7>

80020cfa <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
80020cfa:	3a3027f3          	csrr	a5,pmpcfg3
80020cfe:	d43e                	sw	a5,40(sp)
80020d00:	57a2                	lw	a5,40(sp)

80020d02 <.LBE5>:
80020d02:	d63e                	sw	a5,44(sp)
        break;
80020d04:	a011                	j	80020d08 <.L7>

80020d06 <.L9>:
        break;
80020d06:	0001                	nop

80020d08 <.L7>:
    }
    return pmp_cfg;
80020d08:	57b2                	lw	a5,44(sp)
}
80020d0a:	853e                	mv	a0,a5
80020d0c:	6145                	add	sp,sp,48
80020d0e:	8082                	ret

Disassembly of section .text.write_pmp_addr:

80020d1a <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
80020d1a:	1141                	add	sp,sp,-16
80020d1c:	c62a                	sw	a0,12(sp)
80020d1e:	c42e                	sw	a1,8(sp)
    switch (idx) {
80020d20:	4722                	lw	a4,8(sp)
80020d22:	47bd                	li	a5,15
80020d24:	08e7ea63          	bltu	a5,a4,80020db8 <.L38>
80020d28:	47a2                	lw	a5,8(sp)
80020d2a:	00279713          	sll	a4,a5,0x2
80020d2e:	89418793          	add	a5,gp,-1900 # 80020138 <.L21>
80020d32:	97ba                	add	a5,a5,a4
80020d34:	439c                	lw	a5,0(a5)
80020d36:	8782                	jr	a5

80020d38 <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
80020d38:	47b2                	lw	a5,12(sp)
80020d3a:	3b079073          	csrw	pmpaddr0,a5
        break;
80020d3e:	a8b5                	j	80020dba <.L37>

80020d40 <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
80020d40:	47b2                	lw	a5,12(sp)
80020d42:	3b179073          	csrw	pmpaddr1,a5
        break;
80020d46:	a895                	j	80020dba <.L37>

80020d48 <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
80020d48:	47b2                	lw	a5,12(sp)
80020d4a:	3b279073          	csrw	pmpaddr2,a5
        break;
80020d4e:	a0b5                	j	80020dba <.L37>

80020d50 <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
80020d50:	47b2                	lw	a5,12(sp)
80020d52:	3b379073          	csrw	pmpaddr3,a5
        break;
80020d56:	a095                	j	80020dba <.L37>

80020d58 <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
80020d58:	47b2                	lw	a5,12(sp)
80020d5a:	3b479073          	csrw	pmpaddr4,a5
        break;
80020d5e:	a8b1                	j	80020dba <.L37>

80020d60 <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
80020d60:	47b2                	lw	a5,12(sp)
80020d62:	3b579073          	csrw	pmpaddr5,a5
        break;
80020d66:	a891                	j	80020dba <.L37>

80020d68 <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
80020d68:	47b2                	lw	a5,12(sp)
80020d6a:	3b679073          	csrw	pmpaddr6,a5
        break;
80020d6e:	a0b1                	j	80020dba <.L37>

80020d70 <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
80020d70:	47b2                	lw	a5,12(sp)
80020d72:	3b779073          	csrw	pmpaddr7,a5
        break;
80020d76:	a091                	j	80020dba <.L37>

80020d78 <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
80020d78:	47b2                	lw	a5,12(sp)
80020d7a:	3b879073          	csrw	pmpaddr8,a5
        break;
80020d7e:	a835                	j	80020dba <.L37>

80020d80 <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
80020d80:	47b2                	lw	a5,12(sp)
80020d82:	3b979073          	csrw	pmpaddr9,a5
        break;
80020d86:	a815                	j	80020dba <.L37>

80020d88 <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
80020d88:	47b2                	lw	a5,12(sp)
80020d8a:	3ba79073          	csrw	pmpaddr10,a5
        break;
80020d8e:	a035                	j	80020dba <.L37>

80020d90 <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
80020d90:	47b2                	lw	a5,12(sp)
80020d92:	3bb79073          	csrw	pmpaddr11,a5
        break;
80020d96:	a015                	j	80020dba <.L37>

80020d98 <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
80020d98:	47b2                	lw	a5,12(sp)
80020d9a:	3bc79073          	csrw	pmpaddr12,a5
        break;
80020d9e:	a831                	j	80020dba <.L37>

80020da0 <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
80020da0:	47b2                	lw	a5,12(sp)
80020da2:	3bd79073          	csrw	pmpaddr13,a5
        break;
80020da6:	a811                	j	80020dba <.L37>

80020da8 <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
80020da8:	47b2                	lw	a5,12(sp)
80020daa:	3be79073          	csrw	pmpaddr14,a5
        break;
80020dae:	a031                	j	80020dba <.L37>

80020db0 <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
80020db0:	47b2                	lw	a5,12(sp)
80020db2:	3bf79073          	csrw	pmpaddr15,a5
        break;
80020db6:	a011                	j	80020dba <.L37>

80020db8 <.L38>:
    default:
        /* Do nothing */
        break;
80020db8:	0001                	nop

80020dba <.L37>:
    }
}
80020dba:	0001                	nop
80020dbc:	0141                	add	sp,sp,16
80020dbe:	8082                	ret

Disassembly of section .text.read_pma_cfg:

80020dc2 <read_pma_cfg>:
    return ret_val;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
80020dc2:	7179                	add	sp,sp,-48
80020dc4:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
80020dc6:	d602                	sw	zero,44(sp)
    switch (idx) {
80020dc8:	4732                	lw	a4,12(sp)
80020dca:	478d                	li	a5,3
80020dcc:	04f70763          	beq	a4,a5,80020e1a <.L62>
80020dd0:	4732                	lw	a4,12(sp)
80020dd2:	478d                	li	a5,3
80020dd4:	04e7e963          	bltu	a5,a4,80020e26 <.L69>
80020dd8:	4732                	lw	a4,12(sp)
80020dda:	4789                	li	a5,2
80020ddc:	02f70963          	beq	a4,a5,80020e0e <.L64>
80020de0:	4732                	lw	a4,12(sp)
80020de2:	4789                	li	a5,2
80020de4:	04e7e163          	bltu	a5,a4,80020e26 <.L69>
80020de8:	47b2                	lw	a5,12(sp)
80020dea:	c791                	beqz	a5,80020df6 <.L65>
80020dec:	4732                	lw	a4,12(sp)
80020dee:	4785                	li	a5,1
80020df0:	00f70963          	beq	a4,a5,80020e02 <.L66>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
80020df4:	a80d                	j	80020e26 <.L69>

80020df6 <.L65>:
        pma_cfg = read_csr(CSR_PMACFG0);
80020df6:	bc0027f3          	csrr	a5,0xbc0
80020dfa:	ce3e                	sw	a5,28(sp)
80020dfc:	47f2                	lw	a5,28(sp)

80020dfe <.LBE22>:
80020dfe:	d63e                	sw	a5,44(sp)
        break;
80020e00:	a025                	j	80020e28 <.L67>

80020e02 <.L66>:
        pma_cfg = read_csr(CSR_PMACFG1);
80020e02:	bc1027f3          	csrr	a5,0xbc1
80020e06:	d03e                	sw	a5,32(sp)
80020e08:	5782                	lw	a5,32(sp)

80020e0a <.LBE23>:
80020e0a:	d63e                	sw	a5,44(sp)
        break;
80020e0c:	a831                	j	80020e28 <.L67>

80020e0e <.L64>:
        pma_cfg = read_csr(CSR_PMACFG2);
80020e0e:	bc2027f3          	csrr	a5,0xbc2
80020e12:	d23e                	sw	a5,36(sp)
80020e14:	5792                	lw	a5,36(sp)

80020e16 <.LBE24>:
80020e16:	d63e                	sw	a5,44(sp)
        break;
80020e18:	a801                	j	80020e28 <.L67>

80020e1a <.L62>:
        pma_cfg = read_csr(CSR_PMACFG3);
80020e1a:	bc3027f3          	csrr	a5,0xbc3
80020e1e:	d43e                	sw	a5,40(sp)
80020e20:	57a2                	lw	a5,40(sp)

80020e22 <.LBE25>:
80020e22:	d63e                	sw	a5,44(sp)
        break;
80020e24:	a011                	j	80020e28 <.L67>

80020e26 <.L69>:
        break;
80020e26:	0001                	nop

80020e28 <.L67>:
    }
    return pma_cfg;
80020e28:	57b2                	lw	a5,44(sp)
}
80020e2a:	853e                	mv	a0,a5
80020e2c:	6145                	add	sp,sp,48
80020e2e:	8082                	ret

Disassembly of section .text.write_pma_addr:

80020e6a <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
80020e6a:	1141                	add	sp,sp,-16
80020e6c:	c62a                	sw	a0,12(sp)
80020e6e:	c42e                	sw	a1,8(sp)
    switch (idx) {
80020e70:	4722                	lw	a4,8(sp)
80020e72:	47bd                	li	a5,15
80020e74:	08e7ea63          	bltu	a5,a4,80020f08 <.L98>
80020e78:	47a2                	lw	a5,8(sp)
80020e7a:	00279713          	sll	a4,a5,0x2
80020e7e:	8d418793          	add	a5,gp,-1836 # 80020178 <.L81>
80020e82:	97ba                	add	a5,a5,a4
80020e84:	439c                	lw	a5,0(a5)
80020e86:	8782                	jr	a5

80020e88 <.L96>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
80020e88:	47b2                	lw	a5,12(sp)
80020e8a:	bd079073          	csrw	0xbd0,a5
        break;
80020e8e:	a8b5                	j	80020f0a <.L97>

80020e90 <.L95>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
80020e90:	47b2                	lw	a5,12(sp)
80020e92:	bd179073          	csrw	0xbd1,a5
        break;
80020e96:	a895                	j	80020f0a <.L97>

80020e98 <.L94>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
80020e98:	47b2                	lw	a5,12(sp)
80020e9a:	bd279073          	csrw	0xbd2,a5
        break;
80020e9e:	a0b5                	j	80020f0a <.L97>

80020ea0 <.L93>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
80020ea0:	47b2                	lw	a5,12(sp)
80020ea2:	bd379073          	csrw	0xbd3,a5
        break;
80020ea6:	a095                	j	80020f0a <.L97>

80020ea8 <.L92>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
80020ea8:	47b2                	lw	a5,12(sp)
80020eaa:	bd479073          	csrw	0xbd4,a5
        break;
80020eae:	a8b1                	j	80020f0a <.L97>

80020eb0 <.L91>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
80020eb0:	47b2                	lw	a5,12(sp)
80020eb2:	bd579073          	csrw	0xbd5,a5
        break;
80020eb6:	a891                	j	80020f0a <.L97>

80020eb8 <.L90>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
80020eb8:	47b2                	lw	a5,12(sp)
80020eba:	bd679073          	csrw	0xbd6,a5
        break;
80020ebe:	a0b1                	j	80020f0a <.L97>

80020ec0 <.L89>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
80020ec0:	47b2                	lw	a5,12(sp)
80020ec2:	bd779073          	csrw	0xbd7,a5
        break;
80020ec6:	a091                	j	80020f0a <.L97>

80020ec8 <.L88>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
80020ec8:	47b2                	lw	a5,12(sp)
80020eca:	bd879073          	csrw	0xbd8,a5
        break;
80020ece:	a835                	j	80020f0a <.L97>

80020ed0 <.L87>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
80020ed0:	47b2                	lw	a5,12(sp)
80020ed2:	bd979073          	csrw	0xbd9,a5
        break;
80020ed6:	a815                	j	80020f0a <.L97>

80020ed8 <.L86>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
80020ed8:	47b2                	lw	a5,12(sp)
80020eda:	bda79073          	csrw	0xbda,a5
        break;
80020ede:	a035                	j	80020f0a <.L97>

80020ee0 <.L85>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
80020ee0:	47b2                	lw	a5,12(sp)
80020ee2:	bdb79073          	csrw	0xbdb,a5
        break;
80020ee6:	a015                	j	80020f0a <.L97>

80020ee8 <.L84>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
80020ee8:	47b2                	lw	a5,12(sp)
80020eea:	bdc79073          	csrw	0xbdc,a5
        break;
80020eee:	a831                	j	80020f0a <.L97>

80020ef0 <.L83>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
80020ef0:	47b2                	lw	a5,12(sp)
80020ef2:	bdd79073          	csrw	0xbdd,a5
        break;
80020ef6:	a811                	j	80020f0a <.L97>

80020ef8 <.L82>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
80020ef8:	47b2                	lw	a5,12(sp)
80020efa:	bde79073          	csrw	0xbde,a5
        break;
80020efe:	a031                	j	80020f0a <.L97>

80020f00 <.L80>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
80020f00:	47b2                	lw	a5,12(sp)
80020f02:	bdf79073          	csrw	0xbdf,a5
        break;
80020f06:	a011                	j	80020f0a <.L97>

80020f08 <.L98>:
    default:
        /* Do nothing */
        break;
80020f08:	0001                	nop

80020f0a <.L97>:
    }
}
80020f0a:	0001                	nop
80020f0c:	0141                	add	sp,sp,16
80020f0e:	8082                	ret

Disassembly of section .text.pmp_config:

80020f1e <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
80020f1e:	7139                	add	sp,sp,-64
80020f20:	de06                	sw	ra,60(sp)
80020f22:	c62a                	sw	a0,12(sp)
80020f24:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
80020f26:	4789                	li	a5,2
80020f28:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > 15U));
80020f2a:	47b2                	lw	a5,12(sp)
80020f2c:	cfcd                	beqz	a5,80020fe6 <.L125>
80020f2e:	47a2                	lw	a5,8(sp)
80020f30:	cbdd                	beqz	a5,80020fe6 <.L125>
80020f32:	4722                	lw	a4,8(sp)
80020f34:	47bd                	li	a5,15
80020f36:	0ae7e863          	bltu	a5,a4,80020fe6 <.L125>

80020f3a <.LBB43>:

        for (uint32_t i = 0; i < num_of_entries; i++) {
80020f3a:	d402                	sw	zero,40(sp)
80020f3c:	a871                	j	80020fd8 <.L126>

80020f3e <.L127>:
            uint32_t idx = i / 4;
80020f3e:	57a2                	lw	a5,40(sp)
80020f40:	8389                	srl	a5,a5,0x2
80020f42:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
80020f44:	57a2                	lw	a5,40(sp)
80020f46:	078e                	sll	a5,a5,0x3
80020f48:	8be1                	and	a5,a5,24
80020f4a:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
80020f4c:	5512                	lw	a0,36(sp)
80020f4e:	3b91                	jal	80020ca2 <read_pmp_cfg>
80020f50:	ce2a                	sw	a0,28(sp)
            pmp_cfg &= ~(0xFFUL << offset);
80020f52:	5782                	lw	a5,32(sp)
80020f54:	0ff00713          	li	a4,255
80020f58:	00f717b3          	sll	a5,a4,a5
80020f5c:	fff7c793          	not	a5,a5
80020f60:	4772                	lw	a4,28(sp)
80020f62:	8ff9                	and	a5,a5,a4
80020f64:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t) entry->pmp_cfg.val) << offset;
80020f66:	47b2                	lw	a5,12(sp)
80020f68:	0007c783          	lbu	a5,0(a5)
80020f6c:	873e                	mv	a4,a5
80020f6e:	5782                	lw	a5,32(sp)
80020f70:	00f717b3          	sll	a5,a4,a5
80020f74:	4772                	lw	a4,28(sp)
80020f76:	8fd9                	or	a5,a5,a4
80020f78:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
80020f7a:	47b2                	lw	a5,12(sp)
80020f7c:	43dc                	lw	a5,4(a5)
80020f7e:	55a2                	lw	a1,40(sp)
80020f80:	853e                	mv	a0,a5
80020f82:	3b61                	jal	80020d1a <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
80020f84:	5592                	lw	a1,36(sp)
80020f86:	4572                	lw	a0,28(sp)
80020f88:	438020ef          	jal	800233c0 <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
80020f8c:	5512                	lw	a0,36(sp)
80020f8e:	3d15                	jal	80020dc2 <read_pma_cfg>
80020f90:	cc2a                	sw	a0,24(sp)
            pma_cfg &= ~(0xFFUL << offset);
80020f92:	5782                	lw	a5,32(sp)
80020f94:	0ff00713          	li	a4,255
80020f98:	00f717b3          	sll	a5,a4,a5
80020f9c:	fff7c793          	not	a5,a5
80020fa0:	4762                	lw	a4,24(sp)
80020fa2:	8ff9                	and	a5,a5,a4
80020fa4:	cc3e                	sw	a5,24(sp)
            pma_cfg |= ((uint32_t) entry->pma_cfg.val) << offset;
80020fa6:	47b2                	lw	a5,12(sp)
80020fa8:	0087c783          	lbu	a5,8(a5)
80020fac:	873e                	mv	a4,a5
80020fae:	5782                	lw	a5,32(sp)
80020fb0:	00f717b3          	sll	a5,a4,a5
80020fb4:	4762                	lw	a4,24(sp)
80020fb6:	8fd9                	or	a5,a5,a4
80020fb8:	cc3e                	sw	a5,24(sp)
            write_pma_cfg(pma_cfg, idx);
80020fba:	5592                	lw	a1,36(sp)
80020fbc:	4562                	lw	a0,24(sp)
80020fbe:	45e020ef          	jal	8002341c <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
80020fc2:	47b2                	lw	a5,12(sp)
80020fc4:	47dc                	lw	a5,12(a5)
80020fc6:	55a2                	lw	a1,40(sp)
80020fc8:	853e                	mv	a0,a5
80020fca:	3545                	jal	80020e6a <write_pma_addr>
#endif
            ++entry;
80020fcc:	47b2                	lw	a5,12(sp)
80020fce:	07c1                	add	a5,a5,16
80020fd0:	c63e                	sw	a5,12(sp)

80020fd2 <.LBE44>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
80020fd2:	57a2                	lw	a5,40(sp)
80020fd4:	0785                	add	a5,a5,1
80020fd6:	d43e                	sw	a5,40(sp)

80020fd8 <.L126>:
80020fd8:	5722                	lw	a4,40(sp)
80020fda:	47a2                	lw	a5,8(sp)
80020fdc:	f6f761e3          	bltu	a4,a5,80020f3e <.L127>

80020fe0 <.LBE43>:
        }
        fencei();
80020fe0:	0000100f          	fence.i

        status = status_success;
80020fe4:	d602                	sw	zero,44(sp)

80020fe6 <.L125>:

    } while (false);

    return status;
80020fe6:	57b2                	lw	a5,44(sp)
}
80020fe8:	853e                	mv	a0,a5
80020fea:	50f2                	lw	ra,60(sp)
80020fec:	6121                	add	sp,sp,64
80020fee:	8082                	ret

Disassembly of section .text.uart_default_config:

80020ff2 <uart_default_config>:
#ifndef UART_SOC_OVERSAMPLE_MAX
#define UART_SOC_OVERSAMPLE_MAX HPM_UART_OSC_MAX
#endif

void uart_default_config(UART_Type *ptr, uart_config_t *config)
{
80020ff2:	1141                	add	sp,sp,-16
80020ff4:	c62a                	sw	a0,12(sp)
80020ff6:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->baudrate = 115200;
80020ff8:	47a2                	lw	a5,8(sp)
80020ffa:	6771                	lui	a4,0x1c
80020ffc:	20070713          	add	a4,a4,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80021000:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80021002:	47a2                	lw	a5,8(sp)
80021004:	470d                	li	a4,3
80021006:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
8002100a:	47a2                	lw	a5,8(sp)
8002100c:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80021010:	47a2                	lw	a5,8(sp)
80021012:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
80021016:	47a2                	lw	a5,8(sp)
80021018:	4705                	li	a4,1
8002101a:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
8002101e:	47a2                	lw	a5,8(sp)
80021020:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
80021024:	47a2                	lw	a5,8(sp)
80021026:	000785a3          	sb	zero,11(a5)
    config->dma_enable = false;
8002102a:	47a2                	lw	a5,8(sp)
8002102c:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
80021030:	47a2                	lw	a5,8(sp)
80021032:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
80021036:	47a2                	lw	a5,8(sp)
80021038:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
8002103c:	47a2                	lw	a5,8(sp)
8002103e:	000788a3          	sb	zero,17(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
#endif
#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    config->rx_enable = true;
#endif
}
80021042:	0001                	nop
80021044:	0141                	add	sp,sp,16
80021046:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

8002107a <uart_calculate_baudrate>:

static bool uart_calculate_baudrate(uint32_t freq, uint32_t baudrate, uint16_t *div_out, uint8_t *osc_out)
{
8002107a:	7179                	add	sp,sp,-48
8002107c:	d606                	sw	ra,44(sp)
8002107e:	d422                	sw	s0,40(sp)
80021080:	c62a                	sw	a0,12(sp)
80021082:	c42e                	sw	a1,8(sp)
80021084:	c232                	sw	a2,4(sp)
80021086:	c036                	sw	a3,0(sp)
    uint16_t div, osc, delta;
    float tmp;
    if ((div_out == NULL) || (!freq) || (!baudrate)
80021088:	4792                	lw	a5,4(sp)
8002108a:	cb85                	beqz	a5,800210ba <.L4>
8002108c:	47b2                	lw	a5,12(sp)
8002108e:	c795                	beqz	a5,800210ba <.L4>
80021090:	47a2                	lw	a5,8(sp)
80021092:	c785                	beqz	a5,800210ba <.L4>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
80021094:	4722                	lw	a4,8(sp)
80021096:	0c700793          	li	a5,199
8002109a:	02e7f063          	bgeu	a5,a4,800210ba <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
8002109e:	47a2                	lw	a5,8(sp)
800210a0:	078e                	sll	a5,a5,0x3
800210a2:	4732                	lw	a4,12(sp)
800210a4:	00f76b63          	bltu	a4,a5,800210ba <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
800210a8:	4732                	lw	a4,12(sp)
800210aa:	67c1                	lui	a5,0x10
800210ac:	17fd                	add	a5,a5,-1 # ffff <__AHB_SRAM_segment_size__+0x7fff>
800210ae:	02f75733          	divu	a4,a4,a5
800210b2:	47a2                	lw	a5,8(sp)
800210b4:	0796                	sll	a5,a5,0x5
800210b6:	00e7f463          	bgeu	a5,a4,800210be <.L5>

800210ba <.L4>:
        return 0;
800210ba:	4781                	li	a5,0
800210bc:	aa8d                	j	8002122e <.L6>

800210be <.L5>:
    }

    tmp = (float) freq / baudrate;
800210be:	4532                	lw	a0,12(sp)
800210c0:	162010ef          	jal	80022222 <__floatunsisf>
800210c4:	842a                	mv	s0,a0
800210c6:	4522                	lw	a0,8(sp)
800210c8:	15a010ef          	jal	80022222 <__floatunsisf>
800210cc:	87aa                	mv	a5,a0
800210ce:	85be                	mv	a1,a5
800210d0:	8522                	mv	a0,s0
800210d2:	208030ef          	jal	800242da <__divsf3>
800210d6:	87aa                	mv	a5,a0
800210d8:	cc3e                	sw	a5,24(sp)

    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
800210da:	47a1                	li	a5,8
800210dc:	00f11f23          	sh	a5,30(sp)
800210e0:	a281                	j	80021220 <.L7>

800210e2 <.L18>:
        /* osc range: HPM_UART_OSC_MIN - UART_SOC_OVERSAMPLE_MAX, even number */
        delta = 0;
800210e2:	00011e23          	sh	zero,28(sp)
        div = (uint16_t)(tmp / osc);
800210e6:	01e15783          	lhu	a5,30(sp)
800210ea:	853e                	mv	a0,a5
800210ec:	0d0010ef          	jal	800221bc <__floatsisf>
800210f0:	87aa                	mv	a5,a0
800210f2:	85be                	mv	a1,a5
800210f4:	4562                	lw	a0,24(sp)
800210f6:	1e4030ef          	jal	800242da <__divsf3>
800210fa:	87aa                	mv	a5,a0
800210fc:	853e                	mv	a0,a5
800210fe:	05a010ef          	jal	80022158 <__fixunssfsi>
80021102:	87aa                	mv	a5,a0
80021104:	00f11b23          	sh	a5,22(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN) {
80021108:	01615783          	lhu	a5,22(sp)
8002110c:	10078263          	beqz	a5,80021210 <.L22>
            /* invalid div */
            continue;
        }
        if (div * osc > tmp) {
80021110:	01615703          	lhu	a4,22(sp)
80021114:	01e15783          	lhu	a5,30(sp)
80021118:	02f707b3          	mul	a5,a4,a5
8002111c:	853e                	mv	a0,a5
8002111e:	09e010ef          	jal	800221bc <__floatsisf>
80021122:	87aa                	mv	a5,a0
80021124:	85be                	mv	a1,a5
80021126:	4562                	lw	a0,24(sp)
80021128:	751000ef          	jal	80022078 <__ltsf2>
8002112c:	87aa                	mv	a5,a0
8002112e:	0207d863          	bgez	a5,8002115e <.L21>
            delta = (uint16_t)(div * osc - tmp);
80021132:	01615703          	lhu	a4,22(sp)
80021136:	01e15783          	lhu	a5,30(sp)
8002113a:	02f707b3          	mul	a5,a4,a5
8002113e:	853e                	mv	a0,a5
80021140:	07c010ef          	jal	800221bc <__floatsisf>
80021144:	87aa                	mv	a5,a0
80021146:	45e2                	lw	a1,24(sp)
80021148:	853e                	mv	a0,a5
8002114a:	579000ef          	jal	80021ec2 <__subsf3>
8002114e:	87aa                	mv	a5,a0
80021150:	853e                	mv	a0,a5
80021152:	006010ef          	jal	80022158 <__fixunssfsi>
80021156:	87aa                	mv	a5,a0
80021158:	00f11e23          	sh	a5,28(sp)
8002115c:	a0b9                	j	800211aa <.L12>

8002115e <.L21>:
        } else if (div * osc < tmp) {
8002115e:	01615703          	lhu	a4,22(sp)
80021162:	01e15783          	lhu	a5,30(sp)
80021166:	02f707b3          	mul	a5,a4,a5
8002116a:	853e                	mv	a0,a5
8002116c:	050010ef          	jal	800221bc <__floatsisf>
80021170:	87aa                	mv	a5,a0
80021172:	85be                	mv	a1,a5
80021174:	4562                	lw	a0,24(sp)
80021176:	773000ef          	jal	800220e8 <__gtsf2>
8002117a:	87aa                	mv	a5,a0
8002117c:	02f05763          	blez	a5,800211aa <.L12>
            delta = (uint16_t)(tmp - div * osc);
80021180:	01615703          	lhu	a4,22(sp)
80021184:	01e15783          	lhu	a5,30(sp)
80021188:	02f707b3          	mul	a5,a4,a5
8002118c:	853e                	mv	a0,a5
8002118e:	02e010ef          	jal	800221bc <__floatsisf>
80021192:	87aa                	mv	a5,a0
80021194:	85be                	mv	a1,a5
80021196:	4562                	lw	a0,24(sp)
80021198:	52b000ef          	jal	80021ec2 <__subsf3>
8002119c:	87aa                	mv	a5,a0
8002119e:	853e                	mv	a0,a5
800211a0:	7b9000ef          	jal	80022158 <__fixunssfsi>
800211a4:	87aa                	mv	a5,a0
800211a6:	00f11e23          	sh	a5,28(sp)

800211aa <.L12>:
        }
        if (delta && ((delta * 100 / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
800211aa:	01c15783          	lhu	a5,28(sp)
800211ae:	cb9d                	beqz	a5,800211e4 <.L14>
800211b0:	01c15703          	lhu	a4,28(sp)
800211b4:	06400793          	li	a5,100
800211b8:	02f707b3          	mul	a5,a4,a5
800211bc:	853e                	mv	a0,a5
800211be:	7ff000ef          	jal	800221bc <__floatsisf>
800211c2:	87aa                	mv	a5,a0
800211c4:	45e2                	lw	a1,24(sp)
800211c6:	853e                	mv	a0,a5
800211c8:	112030ef          	jal	800242da <__divsf3>
800211cc:	87aa                	mv	a5,a0
800211ce:	873e                	mv	a4,a5
800211d0:	800207b7          	lui	a5,0x80020
800211d4:	07c7a583          	lw	a1,124(a5) # 8002007c <.LC0>
800211d8:	853a                	mv	a0,a4
800211da:	70f000ef          	jal	800220e8 <__gtsf2>
800211de:	87aa                	mv	a5,a0
800211e0:	02f04a63          	bgtz	a5,80021214 <.L23>

800211e4 <.L14>:
            continue;
        } else {
            *div_out = div;
800211e4:	4792                	lw	a5,4(sp)
800211e6:	01615703          	lhu	a4,22(sp)
800211ea:	00e79023          	sh	a4,0(a5)
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
800211ee:	01e15703          	lhu	a4,30(sp)
800211f2:	02000793          	li	a5,32
800211f6:	00f70763          	beq	a4,a5,80021204 <.L16>
800211fa:	01e15783          	lhu	a5,30(sp)
800211fe:	0ff7f793          	zext.b	a5,a5
80021202:	a011                	j	80021206 <.L17>

80021204 <.L16>:
80021204:	4781                	li	a5,0

80021206 <.L17>:
80021206:	4702                	lw	a4,0(sp)
80021208:	00f70023          	sb	a5,0(a4)
            return true;
8002120c:	4785                	li	a5,1
8002120e:	a005                	j	8002122e <.L6>

80021210 <.L22>:
            continue;
80021210:	0001                	nop
80021212:	a011                	j	80021216 <.L9>

80021214 <.L23>:
            continue;
80021214:	0001                	nop

80021216 <.L9>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80021216:	01e15783          	lhu	a5,30(sp)
8002121a:	0789                	add	a5,a5,2
8002121c:	00f11f23          	sh	a5,30(sp)

80021220 <.L7>:
80021220:	01e15703          	lhu	a4,30(sp)
80021224:	02000793          	li	a5,32
80021228:	eae7fde3          	bgeu	a5,a4,800210e2 <.L18>
        }
    }
    return false;
8002122c:	4781                	li	a5,0

8002122e <.L6>:
}
8002122e:	853e                	mv	a0,a5
80021230:	50b2                	lw	ra,44(sp)
80021232:	5422                	lw	s0,40(sp)
80021234:	6145                	add	sp,sp,48
80021236:	8082                	ret

Disassembly of section .text.uart_send_byte:

80021256 <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
80021256:	1101                	add	sp,sp,-32
80021258:	c62a                	sw	a0,12(sp)
8002125a:	87ae                	mv	a5,a1
8002125c:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
80021260:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
80021262:	a811                	j	80021276 <.L49>

80021264 <.L52>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
80021264:	4772                	lw	a4,28(sp)
80021266:	6785                	lui	a5,0x1
80021268:	38878793          	add	a5,a5,904 # 1388 <__ILM_segment_used_end__+0x104a>
8002126c:	00e7eb63          	bltu	a5,a4,80021282 <.L55>
            break;
        }
        retry++;
80021270:	47f2                	lw	a5,28(sp)
80021272:	0785                	add	a5,a5,1
80021274:	ce3e                	sw	a5,28(sp)

80021276 <.L49>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
80021276:	47b2                	lw	a5,12(sp)
80021278:	5bdc                	lw	a5,52(a5)
8002127a:	0207f793          	and	a5,a5,32
8002127e:	d3fd                	beqz	a5,80021264 <.L52>
80021280:	a011                	j	80021284 <.L51>

80021282 <.L55>:
            break;
80021282:	0001                	nop

80021284 <.L51>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
80021284:	4772                	lw	a4,28(sp)
80021286:	6785                	lui	a5,0x1
80021288:	38878793          	add	a5,a5,904 # 1388 <__ILM_segment_used_end__+0x104a>
8002128c:	00e7f463          	bgeu	a5,a4,80021294 <.L53>
        return status_timeout;
80021290:	478d                	li	a5,3
80021292:	a031                	j	8002129e <.L54>

80021294 <.L53>:
    }

    ptr->THR = UART_THR_THR_SET(c);
80021294:	00b14703          	lbu	a4,11(sp)
80021298:	47b2                	lw	a5,12(sp)
8002129a:	d398                	sw	a4,32(a5)
    return status_success;
8002129c:	4781                	li	a5,0

8002129e <.L54>:
}
8002129e:	853e                	mv	a0,a5
800212a0:	6105                	add	sp,sp,32
800212a2:	8082                	ret

Disassembly of section .text.pllctl_xtal_set_rampup_time:

800212b2 <pllctl_xtal_set_rampup_time>:
 * @brief set XTAL rampup time in cycles of IRC24M
 *
 * @param[in] ptr PLLCTL base address
 */
static inline void pllctl_xtal_set_rampup_time(PLLCTL_Type *ptr, uint32_t cycles)
{
800212b2:	1141                	add	sp,sp,-16
800212b4:	c62a                	sw	a0,12(sp)
800212b6:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTL_XTAL_RAMP_TIME_MASK) | PLLCTL_XTAL_RAMP_TIME_SET(cycles);
800212b8:	47b2                	lw	a5,12(sp)
800212ba:	4398                	lw	a4,0(a5)
800212bc:	fff007b7          	lui	a5,0xfff00
800212c0:	8f7d                	and	a4,a4,a5
800212c2:	46a2                	lw	a3,8(sp)
800212c4:	001007b7          	lui	a5,0x100
800212c8:	17fd                	add	a5,a5,-1 # fffff <__DLM_segment_end__+0x3ffff>
800212ca:	8ff5                	and	a5,a5,a3
800212cc:	8f5d                	or	a4,a4,a5
800212ce:	47b2                	lw	a5,12(sp)
800212d0:	c398                	sw	a4,0(a5)
}
800212d2:	0001                	nop
800212d4:	0141                	add	sp,sp,16
800212d6:	8082                	ret

Disassembly of section .text.pcfg_dcdc_switch_to_dcm_mode:

800212e2 <pcfg_dcdc_switch_to_dcm_mode>:
 * @brief dcdc switch to dcm mode
 *
 * @param[in] ptr base address
 */
static inline void pcfg_dcdc_switch_to_dcm_mode(PCFG_Type *ptr)
{
800212e2:	7139                	add	sp,sp,-64
800212e4:	c62a                	sw	a0,12(sp)
    const uint8_t pcfc_dcdc_min_duty_cycle[] = {
800212e6:	15818793          	add	a5,gp,344 # 800209fc <.LC0>
800212ea:	0007a883          	lw	a7,0(a5)
800212ee:	0047a803          	lw	a6,4(a5)
800212f2:	4788                	lw	a0,8(a5)
800212f4:	47cc                	lw	a1,12(a5)
800212f6:	4b90                	lw	a2,16(a5)
800212f8:	4bd4                	lw	a3,20(a5)
800212fa:	4f98                	lw	a4,24(a5)
800212fc:	4fdc                	lw	a5,28(a5)
800212fe:	ce46                	sw	a7,28(sp)
80021300:	d042                	sw	a6,32(sp)
80021302:	d22a                	sw	a0,36(sp)
80021304:	d42e                	sw	a1,40(sp)
80021306:	d632                	sw	a2,44(sp)
80021308:	d836                	sw	a3,48(sp)
8002130a:	da3a                	sw	a4,52(sp)
8002130c:	dc3e                	sw	a5,56(sp)
        0x76, 0x78, 0x78, 0x78, 0x78, 0x7A, 0x7A, 0x7A,
        0x7A, 0x7C, 0x7C, 0x7C, 0x7E, 0x7E, 0x7E, 0x7E
    };
    uint16_t voltage;

    ptr->DCDC_MODE |= 0x77000u;
8002130e:	47b2                	lw	a5,12(sp)
80021310:	4b98                	lw	a4,16(a5)
80021312:	000777b7          	lui	a5,0x77
80021316:	8f5d                	or	a4,a4,a5
80021318:	47b2                	lw	a5,12(sp)
8002131a:	cb98                	sw	a4,16(a5)
    ptr->DCDC_ADVMODE = (ptr->DCDC_ADVMODE & ~0x73F0067u) | 0x4120067u;
8002131c:	47b2                	lw	a5,12(sp)
8002131e:	5398                	lw	a4,32(a5)
80021320:	f8c107b7          	lui	a5,0xf8c10
80021324:	f9878793          	add	a5,a5,-104 # f8c0ff98 <__APB_SRAM_segment_end__+0x4b1df98>
80021328:	8f7d                	and	a4,a4,a5
8002132a:	041207b7          	lui	a5,0x4120
8002132e:	06778793          	add	a5,a5,103 # 4120067 <__SHARE_RAM_segment_end__+0x2fa0067>
80021332:	8f5d                	or	a4,a4,a5
80021334:	47b2                	lw	a5,12(sp)
80021336:	d398                	sw	a4,32(a5)
    ptr->DCDC_PROT &= ~PCFG_DCDC_PROT_SHORT_CURRENT_MASK;
80021338:	47b2                	lw	a5,12(sp)
8002133a:	4f9c                	lw	a5,24(a5)
8002133c:	fef7f713          	and	a4,a5,-17
80021340:	47b2                	lw	a5,12(sp)
80021342:	cf98                	sw	a4,24(a5)
    ptr->DCDC_PROT |= PCFG_DCDC_PROT_DISABLE_SHORT_MASK;
80021344:	47b2                	lw	a5,12(sp)
80021346:	4f9c                	lw	a5,24(a5)
80021348:	0807e713          	or	a4,a5,128
8002134c:	47b2                	lw	a5,12(sp)
8002134e:	cf98                	sw	a4,24(a5)
    ptr->DCDC_MISC = 0x100000u;
80021350:	47b2                	lw	a5,12(sp)
80021352:	00100737          	lui	a4,0x100
80021356:	d798                	sw	a4,40(a5)
    voltage = PCFG_DCDC_MODE_VOLT_GET(ptr->DCDC_MODE);
80021358:	47b2                	lw	a5,12(sp)
8002135a:	4b9c                	lw	a5,16(a5)
8002135c:	01079713          	sll	a4,a5,0x10
80021360:	8341                	srl	a4,a4,0x10
80021362:	6785                	lui	a5,0x1
80021364:	17fd                	add	a5,a5,-1 # fff <__ILM_segment_used_end__+0xcc1>
80021366:	8ff9                	and	a5,a5,a4
80021368:	02f11f23          	sh	a5,62(sp)
    voltage = (voltage - 600) / 25;
8002136c:	03e15783          	lhu	a5,62(sp)
80021370:	da878713          	add	a4,a5,-600
80021374:	47e5                	li	a5,25
80021376:	02f747b3          	div	a5,a4,a5
8002137a:	02f11f23          	sh	a5,62(sp)
    ptr->DCDC_ADVPARAM = (ptr->DCDC_ADVPARAM & ~PCFG_DCDC_ADVPARAM_MIN_DUT_MASK) | PCFG_DCDC_ADVPARAM_MIN_DUT_SET(pcfc_dcdc_min_duty_cycle[voltage]);
8002137e:	47b2                	lw	a5,12(sp)
80021380:	53d8                	lw	a4,36(a5)
80021382:	77e1                	lui	a5,0xffff8
80021384:	0ff78793          	add	a5,a5,255 # ffff80ff <__APB_SRAM_segment_end__+0xbf060ff>
80021388:	8f7d                	and	a4,a4,a5
8002138a:	03e15783          	lhu	a5,62(sp)
8002138e:	04078793          	add	a5,a5,64
80021392:	978a                	add	a5,a5,sp
80021394:	fdc7c783          	lbu	a5,-36(a5)
80021398:	00879693          	sll	a3,a5,0x8
8002139c:	67a1                	lui	a5,0x8
8002139e:	f0078793          	add	a5,a5,-256 # 7f00 <__XPI0_segment_used_size__+0x23a0>
800213a2:	8ff5                	and	a5,a5,a3
800213a4:	8f5d                	or	a4,a4,a5
800213a6:	47b2                	lw	a5,12(sp)
800213a8:	d3d8                	sw	a4,36(a5)
}
800213aa:	0001                	nop
800213ac:	6121                	add	sp,sp,64
800213ae:	8082                	ret

Disassembly of section .text.board_init_pmp:

800213ba <board_init_pmp>:
{
    clock_cpu_delay_us(us);
}

void board_init_pmp(void)
{
800213ba:	712d                	add	sp,sp,-288
800213bc:	10112e23          	sw	ra,284(sp)
    uint32_t start_addr;
    uint32_t end_addr;
    uint32_t length;
    pmp_entry_t pmp_entry[16];
    uint8_t index = 0;
800213c0:	100107a3          	sb	zero,271(sp)

    /* Init noncachable memory */
    extern uint32_t __noncacheable_start__[];
    extern uint32_t __noncacheable_end__[];
    start_addr = (uint32_t) __noncacheable_start__;
800213c4:	011007b7          	lui	a5,0x1100
800213c8:	00078793          	mv	a5,a5
800213cc:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t) __noncacheable_end__;
800213d0:	011407b7          	lui	a5,0x1140
800213d4:	00078793          	mv	a5,a5
800213d8:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
800213dc:	10412703          	lw	a4,260(sp)
800213e0:	10812783          	lw	a5,264(sp)
800213e4:	40f707b3          	sub	a5,a4,a5
800213e8:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
800213ec:	10012783          	lw	a5,256(sp)
800213f0:	cfc5                	beqz	a5,800214a8 <.L20>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
800213f2:	10012783          	lw	a5,256(sp)
800213f6:	fff78713          	add	a4,a5,-1 # 113ffff <__AXI_SRAM_segment_end__+0x3ffff>
800213fa:	10012783          	lw	a5,256(sp)
800213fe:	8ff9                	and	a5,a5,a4
80021400:	cb89                	beqz	a5,80021412 <.L21>
80021402:	0b600613          	li	a2,182
80021406:	26c18593          	add	a1,gp,620 # 80020b10 <.LC15>
8002140a:	2cc18513          	add	a0,gp,716 # 80020b70 <.LC16>
8002140e:	1ff020ef          	jal	80023e0c <__SEGGER_RTL_X_assert>

80021412 <.L21>:
        assert((start_addr & (length - 1U)) == 0U);
80021412:	10012783          	lw	a5,256(sp)
80021416:	fff78713          	add	a4,a5,-1
8002141a:	10812783          	lw	a5,264(sp)
8002141e:	8ff9                	and	a5,a5,a4
80021420:	cb89                	beqz	a5,80021432 <.L22>
80021422:	0b700613          	li	a2,183
80021426:	26c18593          	add	a1,gp,620 # 80020b10 <.LC15>
8002142a:	2ec18513          	add	a0,gp,748 # 80020b90 <.LC17>
8002142e:	1df020ef          	jal	80023e0c <__SEGGER_RTL_X_assert>

80021432 <.L22>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
80021432:	10812783          	lw	a5,264(sp)
80021436:	0027d693          	srl	a3,a5,0x2
8002143a:	10012783          	lw	a5,256(sp)
8002143e:	17fd                	add	a5,a5,-1
80021440:	0037d713          	srl	a4,a5,0x3
80021444:	10f14783          	lbu	a5,271(sp)
80021448:	8f55                	or	a4,a4,a3
8002144a:	0792                	sll	a5,a5,0x4
8002144c:	11078793          	add	a5,a5,272
80021450:	978a                	add	a5,a5,sp
80021452:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
80021456:	10f14783          	lbu	a5,271(sp)
8002145a:	0792                	sll	a5,a5,0x4
8002145c:	11078793          	add	a5,a5,272
80021460:	978a                	add	a5,a5,sp
80021462:	477d                	li	a4,31
80021464:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
80021468:	10812783          	lw	a5,264(sp)
8002146c:	0027d693          	srl	a3,a5,0x2
80021470:	10012783          	lw	a5,256(sp)
80021474:	17fd                	add	a5,a5,-1
80021476:	0037d713          	srl	a4,a5,0x3
8002147a:	10f14783          	lbu	a5,271(sp)
8002147e:	8f55                	or	a4,a4,a3
80021480:	0792                	sll	a5,a5,0x4
80021482:	11078793          	add	a5,a5,272
80021486:	978a                	add	a5,a5,sp
80021488:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
8002148c:	10f14783          	lbu	a5,271(sp)
80021490:	0792                	sll	a5,a5,0x4
80021492:	11078793          	add	a5,a5,272
80021496:	978a                	add	a5,a5,sp
80021498:	473d                	li	a4,15
8002149a:	eee78c23          	sb	a4,-264(a5)
        index++;
8002149e:	10f14783          	lbu	a5,271(sp)
800214a2:	0785                	add	a5,a5,1
800214a4:	10f107a3          	sb	a5,271(sp)

800214a8 <.L20>:
    }

    /* Init share memory */
    extern uint32_t __share_mem_start__[];
    extern uint32_t __share_mem_end__[];
    start_addr = (uint32_t)__share_mem_start__;
800214a8:	0117c7b7          	lui	a5,0x117c
800214ac:	00078793          	mv	a5,a5
800214b0:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t)__share_mem_end__;
800214b4:	011807b7          	lui	a5,0x1180
800214b8:	00078793          	mv	a5,a5
800214bc:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
800214c0:	10412703          	lw	a4,260(sp)
800214c4:	10812783          	lw	a5,264(sp)
800214c8:	40f707b3          	sub	a5,a4,a5
800214cc:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
800214d0:	10012783          	lw	a5,256(sp)
800214d4:	cfc5                	beqz	a5,8002158c <.L23>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
800214d6:	10012783          	lw	a5,256(sp)
800214da:	fff78713          	add	a4,a5,-1 # 117ffff <__SHARE_RAM_segment_start__+0x3fff>
800214de:	10012783          	lw	a5,256(sp)
800214e2:	8ff9                	and	a5,a5,a4
800214e4:	cb89                	beqz	a5,800214f6 <.L24>
800214e6:	0c700613          	li	a2,199
800214ea:	26c18593          	add	a1,gp,620 # 80020b10 <.LC15>
800214ee:	2cc18513          	add	a0,gp,716 # 80020b70 <.LC16>
800214f2:	11b020ef          	jal	80023e0c <__SEGGER_RTL_X_assert>

800214f6 <.L24>:
        assert((start_addr & (length - 1U)) == 0U);
800214f6:	10012783          	lw	a5,256(sp)
800214fa:	fff78713          	add	a4,a5,-1
800214fe:	10812783          	lw	a5,264(sp)
80021502:	8ff9                	and	a5,a5,a4
80021504:	cb89                	beqz	a5,80021516 <.L25>
80021506:	0c800613          	li	a2,200
8002150a:	26c18593          	add	a1,gp,620 # 80020b10 <.LC15>
8002150e:	2ec18513          	add	a0,gp,748 # 80020b90 <.LC17>
80021512:	0fb020ef          	jal	80023e0c <__SEGGER_RTL_X_assert>

80021516 <.L25>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
80021516:	10812783          	lw	a5,264(sp)
8002151a:	0027d693          	srl	a3,a5,0x2
8002151e:	10012783          	lw	a5,256(sp)
80021522:	17fd                	add	a5,a5,-1
80021524:	0037d713          	srl	a4,a5,0x3
80021528:	10f14783          	lbu	a5,271(sp)
8002152c:	8f55                	or	a4,a4,a3
8002152e:	0792                	sll	a5,a5,0x4
80021530:	11078793          	add	a5,a5,272
80021534:	978a                	add	a5,a5,sp
80021536:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
8002153a:	10f14783          	lbu	a5,271(sp)
8002153e:	0792                	sll	a5,a5,0x4
80021540:	11078793          	add	a5,a5,272
80021544:	978a                	add	a5,a5,sp
80021546:	477d                	li	a4,31
80021548:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
8002154c:	10812783          	lw	a5,264(sp)
80021550:	0027d693          	srl	a3,a5,0x2
80021554:	10012783          	lw	a5,256(sp)
80021558:	17fd                	add	a5,a5,-1
8002155a:	0037d713          	srl	a4,a5,0x3
8002155e:	10f14783          	lbu	a5,271(sp)
80021562:	8f55                	or	a4,a4,a3
80021564:	0792                	sll	a5,a5,0x4
80021566:	11078793          	add	a5,a5,272
8002156a:	978a                	add	a5,a5,sp
8002156c:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
80021570:	10f14783          	lbu	a5,271(sp)
80021574:	0792                	sll	a5,a5,0x4
80021576:	11078793          	add	a5,a5,272
8002157a:	978a                	add	a5,a5,sp
8002157c:	473d                	li	a4,15
8002157e:	eee78c23          	sb	a4,-264(a5)
        index++;
80021582:	10f14783          	lbu	a5,271(sp)
80021586:	0785                	add	a5,a5,1
80021588:	10f107a3          	sb	a5,271(sp)

8002158c <.L23>:
    }

    pmp_config(&pmp_entry[0], index);
8002158c:	10f14703          	lbu	a4,271(sp)
80021590:	878a                	mv	a5,sp
80021592:	85ba                	mv	a1,a4
80021594:	853e                	mv	a0,a5
80021596:	3261                	jal	80020f1e <pmp_config>
}
80021598:	0001                	nop
8002159a:	11c12083          	lw	ra,284(sp)
8002159e:	6115                	add	sp,sp,288
800215a0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

800215a2 <__SEGGER_RTL_SIGNAL_SIG_IGN>:
800215a2:	8082                	ret

Disassembly of section .text.board_init_clock:

80021614 <board_init_clock>:

void board_init_clock(void)
{
80021614:	1101                	add	sp,sp,-32
80021616:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
80021618:	4501                	li	a0,0
8002161a:	2e21                	jal	80021932 <clock_get_frequency>
8002161c:	c62a                	sw	a0,12(sp)
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
8002161e:	4732                	lw	a4,12(sp)
80021620:	016e37b7          	lui	a5,0x16e3
80021624:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80021628:	00f71e63          	bne	a4,a5,80021644 <.L27>
        /* Configure the External OSC ramp-up time: ~9ms */
        pllctl_xtal_set_rampup_time(HPM_PLLCTL, 32UL * 1000UL * 9U);
8002162c:	000467b7          	lui	a5,0x46
80021630:	50078593          	add	a1,a5,1280 # 46500 <__DLM_segment_size__+0x6500>
80021634:	f4100537          	lui	a0,0xf4100
80021638:	39ad                	jal	800212b2 <pllctl_xtal_set_rampup_time>

        /* Select clock setting preset1 */
        sysctl_clock_set_preset(HPM_SYSCTL, sysctl_preset_1);
8002163a:	4589                	li	a1,2
8002163c:	f4000537          	lui	a0,0xf4000
80021640:	032020ef          	jal	80023672 <sysctl_clock_set_preset>

80021644 <.L27>:
    }

    /* Add clocks to group 0 */
    clock_add_to_group(clock_cpu0, 0);
80021644:	4581                	li	a1,0
80021646:	4501                	li	a0,0
80021648:	29d5                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
8002164a:	4581                	li	a1,0
8002164c:	010807b7          	lui	a5,0x1080
80021650:	00178513          	add	a0,a5,1 # 1080001 <__RAL_global_locale+0x1>
80021654:	21e5                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_axi0, 0);
80021656:	4581                	li	a1,0
80021658:	010107b7          	lui	a5,0x1010
8002165c:	00478513          	add	a0,a5,4 # 1010004 <_extram_size+0x10004>
80021660:	29f1                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_axi1, 0);
80021662:	4581                	li	a1,0
80021664:	010207b7          	lui	a5,0x1020
80021668:	00578513          	add	a0,a5,5 # 1020005 <_extram_size+0x20005>
8002166c:	29c1                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_axi2, 0);
8002166e:	4581                	li	a1,0
80021670:	010307b7          	lui	a5,0x1030
80021674:	00678513          	add	a0,a5,6 # 1030006 <_extram_size+0x30006>
80021678:	21d1                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_ahb, 0);
8002167a:	4581                	li	a1,0
8002167c:	010007b7          	lui	a5,0x1000
80021680:	00778513          	add	a0,a5,7 # 1000007 <_extram_size+0x7>
80021684:	2965                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_xdma, 0);
80021686:	4581                	li	a1,0
80021688:	011207b7          	lui	a5,0x1120
8002168c:	60178513          	add	a0,a5,1537 # 1120601 <__AXI_SRAM_segment_end__+0x20601>
80021690:	2175                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
80021692:	4581                	li	a1,0
80021694:	011107b7          	lui	a5,0x1110
80021698:	50478513          	add	a0,a5,1284 # 1110504 <__AXI_SRAM_segment_end__+0x10504>
8002169c:	2145                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
8002169e:	4581                	li	a1,0
800216a0:	010c07b7          	lui	a5,0x10c0
800216a4:	00978513          	add	a0,a5,9 # 10c0009 <__thread_pointer$+0x3f809>
800216a8:	2951                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_xpi1, 0);
800216aa:	4581                	li	a1,0
800216ac:	010d07b7          	lui	a5,0x10d0
800216b0:	00a78513          	add	a0,a5,10 # 10d000a <__thread_pointer$+0x4f80a>
800216b4:	2161                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_ram0, 0);
800216b6:	4581                	li	a1,0
800216b8:	010a07b7          	lui	a5,0x10a0
800216bc:	60378513          	add	a0,a5,1539 # 10a0603 <__thread_pointer$+0x1fe03>
800216c0:	29b5                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_ram1, 0);
800216c2:	4581                	li	a1,0
800216c4:	010b07b7          	lui	a5,0x10b0
800216c8:	60478513          	add	a0,a5,1540 # 10b0604 <__thread_pointer$+0x2fe04>
800216cc:	2985                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
800216ce:	4581                	li	a1,0
800216d0:	010617b7          	lui	a5,0x1061
800216d4:	90078513          	add	a0,a5,-1792 # 1060900 <_extram_size+0x60900>
800216d8:	2195                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_lmm1, 0);
800216da:	4581                	li	a1,0
800216dc:	010717b7          	lui	a5,0x1071
800216e0:	a0078513          	add	a0,a5,-1536 # 1070a00 <_extram_size+0x70a00>
800216e4:	29a1                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
800216e6:	4581                	li	a1,0
800216e8:	011307b7          	lui	a5,0x1130
800216ec:	50178513          	add	a0,a5,1281 # 1130501 <__AXI_SRAM_segment_end__+0x30501>
800216f0:	21b1                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_mot0, 0);
800216f2:	4581                	li	a1,0
800216f4:	014b07b7          	lui	a5,0x14b0
800216f8:	50678513          	add	a0,a5,1286 # 14b0506 <__SHARE_RAM_segment_end__+0x330506>
800216fc:	2181                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_mot1, 0);
800216fe:	4581                	li	a1,0
80021700:	014c07b7          	lui	a5,0x14c0
80021704:	50778513          	add	a0,a5,1287 # 14c0507 <__SHARE_RAM_segment_end__+0x340507>
80021708:	2915                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_mot2, 0);
8002170a:	4581                	li	a1,0
8002170c:	014d07b7          	lui	a5,0x14d0
80021710:	50878513          	add	a0,a5,1288 # 14d0508 <__SHARE_RAM_segment_end__+0x350508>
80021714:	2125                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_mot3, 0);
80021716:	4581                	li	a1,0
80021718:	014e07b7          	lui	a5,0x14e0
8002171c:	50978513          	add	a0,a5,1289 # 14e0509 <__SHARE_RAM_segment_end__+0x360509>
80021720:	2931                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_synt, 0);
80021722:	4581                	li	a1,0
80021724:	014a07b7          	lui	a5,0x14a0
80021728:	50c78513          	add	a0,a5,1292 # 14a050c <__SHARE_RAM_segment_end__+0x32050c>
8002172c:	2901                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
8002172e:	4581                	li	a1,0
80021730:	013e07b7          	lui	a5,0x13e0
80021734:	02f78513          	add	a0,a5,47 # 13e002f <__SHARE_RAM_segment_end__+0x26002f>
80021738:	2111                	jal	80021b3c <clock_add_to_group>
    /* Connect Group0 to CPU0 */
    clock_connect_group_to_cpu(0, 0);
8002173a:	4581                	li	a1,0
8002173c:	4501                	li	a0,0
8002173e:	454020ef          	jal	80023b92 <clock_connect_group_to_cpu>

    /* Add clocks to Group1 */
    clock_add_to_group(clock_cpu1, 1);
80021742:	4585                	li	a1,1
80021744:	000807b7          	lui	a5,0x80
80021748:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
8002174c:	2ec5                	jal	80021b3c <clock_add_to_group>
    clock_add_to_group(clock_mchtmr1, 1);
8002174e:	4585                	li	a1,1
80021750:	010907b7          	lui	a5,0x1090
80021754:	00378513          	add	a0,a5,3 # 1090003 <__thread_pointer$+0xf803>
80021758:	26d5                	jal	80021b3c <clock_add_to_group>
    /* Connect Group1 to CPU1 */
    clock_connect_group_to_cpu(1, 1);
8002175a:	4585                	li	a1,1
8002175c:	4505                	li	a0,1
8002175e:	434020ef          	jal	80023b92 <clock_connect_group_to_cpu>

    /* Bump up DCDC voltage to 1200mv */
    pcfg_dcdc_set_voltage(HPM_PCFG, 1200);
80021762:	4b000593          	li	a1,1200
80021766:	f40c4537          	lui	a0,0xf40c4
8002176a:	01b010ef          	jal	80022f84 <pcfg_dcdc_set_voltage>
    pcfg_dcdc_switch_to_dcm_mode(HPM_PCFG);
8002176e:	f40c4537          	lui	a0,0xf40c4
80021772:	3e85                	jal	800212e2 <pcfg_dcdc_switch_to_dcm_mode>

    if (status_success != pllctl_init_int_pll_with_freq(HPM_PLLCTL, 0, BOARD_CPU_FREQ)) {
80021774:	269fb7b7          	lui	a5,0x269fb
80021778:	20078613          	add	a2,a5,512 # 269fb200 <__SHARE_RAM_segment_end__+0x2587b200>
8002177c:	4581                	li	a1,0
8002177e:	f4100537          	lui	a0,0xf4100
80021782:	097010ef          	jal	80023018 <pllctl_init_int_pll_with_freq>
80021786:	87aa                	mv	a5,a0
80021788:	cb91                	beqz	a5,8002179c <.L28>
        printf("Failed to set pll0_clk0 to %ldHz\n", BOARD_CPU_FREQ);
8002178a:	269fb7b7          	lui	a5,0x269fb
8002178e:	20078593          	add	a1,a5,512 # 269fb200 <__SHARE_RAM_segment_end__+0x2587b200>
80021792:	31018513          	add	a0,gp,784 # 80020bb4 <.LC18>
80021796:	676010ef          	jal	80022e0c <printf>

8002179a <.L29>:
        while (1) {
8002179a:	a001                	j	8002179a <.L29>

8002179c <.L28>:
        }
    }

    clock_set_source_divider(clock_cpu0, clk_src_pll0_clk0, 1);
8002179c:	4605                	li	a2,1
8002179e:	4585                	li	a1,1
800217a0:	4501                	li	a0,0
800217a2:	24c9                	jal	80021a64 <clock_set_source_divider>
    clock_set_source_divider(clock_cpu1, clk_src_pll0_clk0, 1);
800217a4:	4605                	li	a2,1
800217a6:	4585                	li	a1,1
800217a8:	000807b7          	lui	a5,0x80
800217ac:	00278513          	add	a0,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
800217b0:	2c55                	jal	80021a64 <clock_set_source_divider>
    clock_update_core_clock();
800217b2:	2999                	jal	80021c08 <clock_update_core_clock>

    clock_set_source_divider(clock_ahb, clk_src_pll1_clk1, 2); /*200m hz*/
800217b4:	4609                	li	a2,2
800217b6:	458d                	li	a1,3
800217b8:	010007b7          	lui	a5,0x1000
800217bc:	00778513          	add	a0,a5,7 # 1000007 <_extram_size+0x7>
800217c0:	2455                	jal	80021a64 <clock_set_source_divider>
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
800217c2:	4605                	li	a2,1
800217c4:	4581                	li	a1,0
800217c6:	010807b7          	lui	a5,0x1080
800217ca:	00178513          	add	a0,a5,1 # 1080001 <__RAL_global_locale+0x1>
800217ce:	2c59                	jal	80021a64 <clock_set_source_divider>
    clock_set_source_divider(clock_mchtmr1, clk_src_osc24m, 1);
800217d0:	4605                	li	a2,1
800217d2:	4581                	li	a1,0
800217d4:	010907b7          	lui	a5,0x1090
800217d8:	00378513          	add	a0,a5,3 # 1090003 <__thread_pointer$+0xf803>
800217dc:	2461                	jal	80021a64 <clock_set_source_divider>
}
800217de:	0001                	nop
800217e0:	40f2                	lw	ra,28(sp)
800217e2:	6105                	add	sp,sp,32
800217e4:	8082                	ret

Disassembly of section .text.gpio_toggle_pin:

800217e6 <gpio_toggle_pin>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_toggle_pin(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
800217e6:	1141                	add	sp,sp,-16
800217e8:	c62a                	sw	a0,12(sp)
800217ea:	c42e                	sw	a1,8(sp)
800217ec:	87b2                	mv	a5,a2
800217ee:	00f103a3          	sb	a5,7(sp)
    ptr->DO[port].TOGGLE = 1 << pin;
800217f2:	00714783          	lbu	a5,7(sp)
800217f6:	4705                	li	a4,1
800217f8:	00f717b3          	sll	a5,a4,a5
800217fc:	86be                	mv	a3,a5
800217fe:	4732                	lw	a4,12(sp)
80021800:	47a2                	lw	a5,8(sp)
80021802:	07c1                	add	a5,a5,16
80021804:	0792                	sll	a5,a5,0x4
80021806:	97ba                	add	a5,a5,a4
80021808:	c7d4                	sw	a3,12(a5)
}
8002180a:	0001                	nop
8002180c:	0141                	add	sp,sp,16
8002180e:	8082                	ret

Disassembly of section .text.main:

80021810 <main>:

    gpio_set_pin_output(LED_PIN);
}

int main(void)
{
80021810:	1141                	add	sp,sp,-16
80021812:	c606                	sw	ra,12(sp)
    board_init_clock();
80021814:	3501                	jal	80021614 <board_init_clock>
    board_init_console();
80021816:	7c5010ef          	jal	800237da <board_init_console>
    board_init_pmp();
8002181a:	3645                	jal	800213ba <board_init_pmp>

    led_init();
8002181c:	04c020ef          	jal	80023868 <led_init>

80021820 <.L5>:

    while (1)
    {
        board_delay_ms(1000);
80021820:	3e800513          	li	a0,1000
80021824:	004020ef          	jal	80023828 <board_delay_ms>
        printf("hello world\n");
80021828:	66c18513          	add	a0,gp,1644 # 80020f10 <.LC0>
8002182c:	5e0010ef          	jal	80022e0c <printf>
        gpio_toggle_pin(LED_PIN);
80021830:	4611                	li	a2,4
80021832:	4585                	li	a1,1
80021834:	f0000537          	lui	a0,0xf0000
80021838:	377d                	jal	800217e6 <gpio_toggle_pin>
        board_delay_ms(1000);
8002183a:	b7dd                	j	80021820 <.L5>

Disassembly of section .text.syscall_handler:

8002183c <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
8002183c:	1101                	add	sp,sp,-32
8002183e:	ce2a                	sw	a0,28(sp)
80021840:	cc2e                	sw	a1,24(sp)
80021842:	ca32                	sw	a2,20(sp)
80021844:	c836                	sw	a3,16(sp)
80021846:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
80021848:	0001                	nop
8002184a:	6105                	add	sp,sp,32
8002184c:	8082                	ret

Disassembly of section .text.hpm_csr_get_core_cycle:

8002184e <hpm_csr_get_core_cycle>:
 *          - in user mode if the device supports M/U mode
 *
 * @return CSR cycle value in 64-bit
 */
static inline uint64_t hpm_csr_get_core_cycle(void)
{
8002184e:	7179                	add	sp,sp,-48

80021850 <.LBB2>:
    uint64_t result;
    uint32_t resultl_first = read_csr(CSR_CYCLE);
80021850:	c0002f73          	rdcycle	t5
80021854:	d27a                	sw	t5,36(sp)
80021856:	5f12                	lw	t5,36(sp)

80021858 <.LBE2>:
80021858:	d07a                	sw	t5,32(sp)

8002185a <.LBB3>:
    uint32_t resulth = read_csr(CSR_CYCLEH);
8002185a:	c8002f73          	rdcycleh	t5
8002185e:	ce7a                	sw	t5,28(sp)
80021860:	4f72                	lw	t5,28(sp)

80021862 <.LBE3>:
80021862:	cc7a                	sw	t5,24(sp)

80021864 <.LBB4>:
    uint32_t resultl_second = read_csr(CSR_CYCLE);
80021864:	c0002f73          	rdcycle	t5
80021868:	ca7a                	sw	t5,20(sp)
8002186a:	4f52                	lw	t5,20(sp)

8002186c <.LBE4>:
8002186c:	c87a                	sw	t5,16(sp)
    if (resultl_first < resultl_second) {
8002186e:	5f82                	lw	t6,32(sp)
80021870:	4f42                	lw	t5,16(sp)
80021872:	03eff263          	bgeu	t6,t5,80021896 <.L2>
        result = ((uint64_t)resulth << 32) | resultl_first; /* if CYCLE didn't roll over, return the value directly */
80021876:	47e2                	lw	a5,24(sp)
80021878:	8e3e                	mv	t3,a5
8002187a:	4e81                	li	t4,0
8002187c:	000e1693          	sll	a3,t3,0x0
80021880:	4601                	li	a2,0
80021882:	5782                	lw	a5,32(sp)
80021884:	883e                	mv	a6,a5
80021886:	4881                	li	a7,0
80021888:	010667b3          	or	a5,a2,a6
8002188c:	d43e                	sw	a5,40(sp)
8002188e:	0116e7b3          	or	a5,a3,a7
80021892:	d63e                	sw	a5,44(sp)
80021894:	a025                	j	800218bc <.L3>

80021896 <.L2>:
    } else {
        resulth = read_csr(CSR_CYCLEH);
80021896:	c80026f3          	rdcycleh	a3
8002189a:	c636                	sw	a3,12(sp)
8002189c:	46b2                	lw	a3,12(sp)

8002189e <.LBE5>:
8002189e:	cc36                	sw	a3,24(sp)
        result = ((uint64_t)resulth << 32) | resultl_second; /* if CYCLE rolled over, need to get the CYCLEH again */
800218a0:	46e2                	lw	a3,24(sp)
800218a2:	8336                	mv	t1,a3
800218a4:	4381                	li	t2,0
800218a6:	00031793          	sll	a5,t1,0x0
800218aa:	4701                	li	a4,0
800218ac:	46c2                	lw	a3,16(sp)
800218ae:	8536                	mv	a0,a3
800218b0:	4581                	li	a1,0
800218b2:	00a766b3          	or	a3,a4,a0
800218b6:	d436                	sw	a3,40(sp)
800218b8:	8fcd                	or	a5,a5,a1
800218ba:	d63e                	sw	a5,44(sp)

800218bc <.L3>:
    }
    return result;
800218bc:	5722                	lw	a4,40(sp)
800218be:	57b2                	lw	a5,44(sp)
 }
800218c0:	853a                	mv	a0,a4
800218c2:	85be                	mv	a1,a5
800218c4:	6145                	add	sp,sp,48
800218c6:	8082                	ret

Disassembly of section .text.pllctl_get_div:

800218c8 <pllctl_get_div>:
{
800218c8:	1141                	add	sp,sp,-16
800218ca:	c62a                	sw	a0,12(sp)
800218cc:	87ae                	mv	a5,a1
800218ce:	8732                	mv	a4,a2
800218d0:	00f105a3          	sb	a5,11(sp)
800218d4:	87ba                	mv	a5,a4
800218d6:	00f10523          	sb	a5,10(sp)
    if ((pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1))
800218da:	00b14703          	lbu	a4,11(sp)
800218de:	4791                	li	a5,4
800218e0:	00e7ec63          	bltu	a5,a4,800218f8 <.L6>
            || !(PLLCTL_SOC_PLL_HAS_DIV0(pll))) {
800218e4:	00b14703          	lbu	a4,11(sp)
800218e8:	4785                	li	a5,1
800218ea:	00f70963          	beq	a4,a5,800218fc <.L7>
800218ee:	00b14703          	lbu	a4,11(sp)
800218f2:	4789                	li	a5,2
800218f4:	00f70463          	beq	a4,a5,800218fc <.L7>

800218f8 <.L6>:
        return status_invalid_argument;
800218f8:	4789                	li	a5,2
800218fa:	a80d                	j	8002192c <.L8>

800218fc <.L7>:
    if (div_index) {
800218fc:	00a14783          	lbu	a5,10(sp)
80021900:	cf81                	beqz	a5,80021918 <.L9>
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV1) + 1;
80021902:	00b14783          	lbu	a5,11(sp)
80021906:	4732                	lw	a4,12(sp)
80021908:	079e                	sll	a5,a5,0x7
8002190a:	97ba                	add	a5,a5,a4
8002190c:	0c47a783          	lw	a5,196(a5)
80021910:	0ff7f793          	zext.b	a5,a5
80021914:	0785                	add	a5,a5,1
80021916:	a819                	j	8002192c <.L8>

80021918 <.L9>:
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV0) + 1;
80021918:	00b14783          	lbu	a5,11(sp)
8002191c:	4732                	lw	a4,12(sp)
8002191e:	079e                	sll	a5,a5,0x7
80021920:	97ba                	add	a5,a5,a4
80021922:	0c07a783          	lw	a5,192(a5)
80021926:	0ff7f793          	zext.b	a5,a5
8002192a:	0785                	add	a5,a5,1

8002192c <.L8>:
}
8002192c:	853e                	mv	a0,a5
8002192e:	0141                	add	sp,sp,16
80021930:	8082                	ret

Disassembly of section .text.clock_get_frequency:

80021932 <clock_get_frequency>:

/***********************************************************************************************************************
 * Codes
 **********************************************************************************************************************/
uint32_t clock_get_frequency(clock_name_t clock_name)
{
80021932:	7179                	add	sp,sp,-48
80021934:	d606                	sw	ra,44(sp)
80021936:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80021938:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
8002193a:	47b2                	lw	a5,12(sp)
8002193c:	83a1                	srl	a5,a5,0x8
8002193e:	0ff7f793          	zext.b	a5,a5
80021942:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80021944:	47b2                	lw	a5,12(sp)
80021946:	0ff7f793          	zext.b	a5,a5
8002194a:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
8002194c:	4762                	lw	a4,24(sp)
8002194e:	47b1                	li	a5,12
80021950:	08e7ec63          	bltu	a5,a4,800219e8 <.L18>
80021954:	47e2                	lw	a5,24(sp)
80021956:	00279713          	sll	a4,a5,0x2
8002195a:	98018793          	add	a5,gp,-1664 # 80020224 <.L20>
8002195e:	97ba                	add	a5,a5,a4
80021960:	439c                	lw	a5,0(a5)
80021962:	8782                	jr	a5

80021964 <.L32>:
    case CLK_SRC_GROUP_COMMON:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
80021964:	47d2                	lw	a5,20(sp)
80021966:	0ff7f793          	zext.b	a5,a5
8002196a:	853e                	mv	a0,a5
8002196c:	2069                	jal	800219f6 <.LFE130>
8002196e:	ce2a                	sw	a0,28(sp)
        break;
80021970:	a8b5                	j	800219ec <.L33>

80021972 <.L31>:
    case CLK_SRC_GROUP_ADC:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_ADC, node_or_instance);
80021972:	45d2                	lw	a1,20(sp)
80021974:	4505                	li	a0,1
80021976:	0f8020ef          	jal	80023a6e <get_frequency_for_i2s_or_adc>
8002197a:	ce2a                	sw	a0,28(sp)
        break;
8002197c:	a885                	j	800219ec <.L33>

8002197e <.L30>:
    case CLK_SRC_GROUP_I2S:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_I2S, node_or_instance);
8002197e:	45d2                	lw	a1,20(sp)
80021980:	4509                	li	a0,2
80021982:	0ec020ef          	jal	80023a6e <get_frequency_for_i2s_or_adc>
80021986:	ce2a                	sw	a0,28(sp)
        break;
80021988:	a095                	j	800219ec <.L33>

8002198a <.L29>:
    case CLK_SRC_GROUP_WDG:
        clk_freq = get_frequency_for_wdg(node_or_instance);
8002198a:	4552                	lw	a0,20(sp)
8002198c:	1b2020ef          	jal	80023b3e <get_frequency_for_wdg>
80021990:	ce2a                	sw	a0,28(sp)
        break;
80021992:	a8a9                	j	800219ec <.L33>

80021994 <.L19>:
    case CLK_SRC_GROUP_PWDG:
        clk_freq = get_frequency_for_pwdg();
80021994:	1da020ef          	jal	80023b6e <get_frequency_for_pwdg>
80021998:	ce2a                	sw	a0,28(sp)
        break;
8002199a:	a889                	j	800219ec <.L33>

8002199c <.L28>:
    case CLK_SRC_GROUP_PMIC:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
8002199c:	016e37b7          	lui	a5,0x16e3
800219a0:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
800219a4:	ce3e                	sw	a5,28(sp)
        break;
800219a6:	a099                	j	800219ec <.L33>

800219a8 <.L27>:
    case CLK_SRC_GROUP_AHB:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
800219a8:	451d                	li	a0,7
800219aa:	20b1                	jal	800219f6 <.LFE130>
800219ac:	ce2a                	sw	a0,28(sp)
        break;
800219ae:	a83d                	j	800219ec <.L33>

800219b0 <.L26>:
    case CLK_SRC_GROUP_AXI0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi0);
800219b0:	4511                	li	a0,4
800219b2:	2091                	jal	800219f6 <.LFE130>
800219b4:	ce2a                	sw	a0,28(sp)
        break;
800219b6:	a81d                	j	800219ec <.L33>

800219b8 <.L25>:
    case CLK_SRC_GROUP_AXI1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi1);
800219b8:	4515                	li	a0,5
800219ba:	2835                	jal	800219f6 <.LFE130>
800219bc:	ce2a                	sw	a0,28(sp)
        break;
800219be:	a03d                	j	800219ec <.L33>

800219c0 <.L24>:
    case CLK_SRC_GROUP_AXI2:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi2);
800219c0:	4519                	li	a0,6
800219c2:	2815                	jal	800219f6 <.LFE130>
800219c4:	ce2a                	sw	a0,28(sp)
        break;
800219c6:	a01d                	j	800219ec <.L33>

800219c8 <.L23>:
    case CLK_SRC_GROUP_CPU0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
800219c8:	4501                	li	a0,0
800219ca:	2035                	jal	800219f6 <.LFE130>
800219cc:	ce2a                	sw	a0,28(sp)
        break;
800219ce:	a839                	j	800219ec <.L33>

800219d0 <.L22>:
    case CLK_SRC_GROUP_CPU1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu1);
800219d0:	4509                	li	a0,2
800219d2:	2015                	jal	800219f6 <.LFE130>
800219d4:	ce2a                	sw	a0,28(sp)
        break;
800219d6:	a819                	j	800219ec <.L33>

800219d8 <.L21>:
    case CLK_SRC_GROUP_SRC:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
800219d8:	47d2                	lw	a5,20(sp)
800219da:	0ff7f793          	zext.b	a5,a5
800219de:	853e                	mv	a0,a5
800219e0:	79f010ef          	jal	8002397e <get_frequency_for_source>
800219e4:	ce2a                	sw	a0,28(sp)
        break;
800219e6:	a019                	j	800219ec <.L33>

800219e8 <.L18>:
    default:
        clk_freq = 0UL;
800219e8:	ce02                	sw	zero,28(sp)
        break;
800219ea:	0001                	nop

800219ec <.L33>:
    }
    return clk_freq;
800219ec:	47f2                	lw	a5,28(sp)
}
800219ee:	853e                	mv	a0,a5
800219f0:	50b2                	lw	ra,44(sp)
800219f2:	6145                	add	sp,sp,48
800219f4:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

800219f6 <get_frequency_for_ip_in_common_group>:

    return clk_freq;
}

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
800219f6:	7139                	add	sp,sp,-64
800219f8:	de06                	sw	ra,60(sp)
800219fa:	87aa                	mv	a5,a0
800219fc:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80021a00:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
80021a02:	00f14783          	lbu	a5,15(sp)
80021a06:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
80021a08:	5722                	lw	a4,40(sp)
80021a0a:	04a00793          	li	a5,74
80021a0e:	04e7e663          	bltu	a5,a4,80021a5a <.L49>

80021a12 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
80021a12:	57a2                	lw	a5,40(sp)
80021a14:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
80021a16:	f4000737          	lui	a4,0xf4000
80021a1a:	5792                	lw	a5,36(sp)
80021a1c:	60078793          	add	a5,a5,1536
80021a20:	078a                	sll	a5,a5,0x2
80021a22:	97ba                	add	a5,a5,a4
80021a24:	439c                	lw	a5,0(a5)
80021a26:	0ff7f793          	zext.b	a5,a5
80021a2a:	0785                	add	a5,a5,1
80021a2c:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
80021a2e:	f4000737          	lui	a4,0xf4000
80021a32:	5792                	lw	a5,36(sp)
80021a34:	60078793          	add	a5,a5,1536
80021a38:	078a                	sll	a5,a5,0x2
80021a3a:	97ba                	add	a5,a5,a4
80021a3c:	439c                	lw	a5,0(a5)
80021a3e:	83a1                	srl	a5,a5,0x8
80021a40:	8bbd                	and	a5,a5,15
80021a42:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
80021a46:	01f14783          	lbu	a5,31(sp)
80021a4a:	853e                	mv	a0,a5
80021a4c:	733010ef          	jal	8002397e <get_frequency_for_source>
80021a50:	872a                	mv	a4,a0
80021a52:	5782                	lw	a5,32(sp)
80021a54:	02f757b3          	divu	a5,a4,a5
80021a58:	d63e                	sw	a5,44(sp)

80021a5a <.L49>:
    }
    return clk_freq;
80021a5a:	57b2                	lw	a5,44(sp)
}
80021a5c:	853e                	mv	a0,a5
80021a5e:	50f2                	lw	ra,60(sp)
80021a60:	6121                	add	sp,sp,64
80021a62:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

80021a64 <clock_set_source_divider>:
    }
    return status_success;
}

hpm_stat_t clock_set_source_divider(clock_name_t clock_name, clk_src_t src, uint32_t div)
{
80021a64:	7179                	add	sp,sp,-48
80021a66:	d606                	sw	ra,44(sp)
80021a68:	c62a                	sw	a0,12(sp)
80021a6a:	87ae                	mv	a5,a1
80021a6c:	c232                	sw	a2,4(sp)
80021a6e:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
80021a72:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80021a74:	47b2                	lw	a5,12(sp)
80021a76:	83a1                	srl	a5,a5,0x8
80021a78:	0ff7f793          	zext.b	a5,a5
80021a7c:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80021a7e:	47b2                	lw	a5,12(sp)
80021a80:	0ff7f793          	zext.b	a5,a5
80021a84:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80021a86:	4762                	lw	a4,24(sp)
80021a88:	47b1                	li	a5,12
80021a8a:	08e7ef63          	bltu	a5,a4,80021b28 <.L140>
80021a8e:	47e2                	lw	a5,24(sp)
80021a90:	00279713          	sll	a4,a5,0x2
80021a94:	9d418793          	add	a5,gp,-1580 # 80020278 <.L142>
80021a98:	97ba                	add	a5,a5,a4
80021a9a:	439c                	lw	a5,0(a5)
80021a9c:	8782                	jr	a5

80021a9e <.L150>:
    case CLK_SRC_GROUP_COMMON:
        if ((div < 1U) || (div > 256U)) {
80021a9e:	4792                	lw	a5,4(sp)
80021aa0:	c791                	beqz	a5,80021aac <.L151>
80021aa2:	4712                	lw	a4,4(sp)
80021aa4:	10000793          	li	a5,256
80021aa8:	00e7f763          	bgeu	a5,a4,80021ab6 <.L152>

80021aac <.L151>:
            status = status_clk_div_invalid;
80021aac:	6795                	lui	a5,0x5
80021aae:	5f078793          	add	a5,a5,1520 # 55f0 <__HEAPSIZE__+0x15f0>
80021ab2:	ce3e                	sw	a5,28(sp)
        } else {
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
        }
        break;
80021ab4:	a8bd                	j	80021b32 <.L154>

80021ab6 <.L152>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
80021ab6:	00b14783          	lbu	a5,11(sp)
80021aba:	8bbd                	and	a5,a5,15
80021abc:	00f109a3          	sb	a5,19(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
80021ac0:	47d2                	lw	a5,20(sp)
80021ac2:	0ff7f793          	zext.b	a5,a5
80021ac6:	01314703          	lbu	a4,19(sp)
80021aca:	4692                	lw	a3,4(sp)
80021acc:	863a                	mv	a2,a4
80021ace:	85be                	mv	a1,a5
80021ad0:	f4000537          	lui	a0,0xf4000
80021ad4:	2415                	jal	80021cf8 <sysctl_config_clock>

80021ad6 <.LBE14>:
        break;
80021ad6:	a8b1                	j	80021b32 <.L154>

80021ad8 <.L141>:
    case CLK_SRC_GROUP_ADC:
    case CLK_SRC_GROUP_I2S:
    case CLK_SRC_GROUP_WDG:
    case CLK_SRC_GROUP_PWDG:
    case CLK_SRC_GROUP_SRC:
        status = status_clk_operation_unsupported;
80021ad8:	6795                	lui	a5,0x5
80021ada:	5f378793          	add	a5,a5,1523 # 55f3 <__HEAPSIZE__+0x15f3>
80021ade:	ce3e                	sw	a5,28(sp)
        break;
80021ae0:	a889                	j	80021b32 <.L154>

80021ae2 <.L149>:
    case CLK_SRC_GROUP_PMIC:
        status = status_clk_fixed;
80021ae2:	6795                	lui	a5,0x5
80021ae4:	5fa78793          	add	a5,a5,1530 # 55fa <__HEAPSIZE__+0x15fa>
80021ae8:	ce3e                	sw	a5,28(sp)
        break;
80021aea:	a0a1                	j	80021b32 <.L154>

80021aec <.L148>:
    case CLK_SRC_GROUP_AHB:
        status = status_clk_shared_ahb;
80021aec:	6795                	lui	a5,0x5
80021aee:	5f478793          	add	a5,a5,1524 # 55f4 <__HEAPSIZE__+0x15f4>
80021af2:	ce3e                	sw	a5,28(sp)
        break;
80021af4:	a83d                	j	80021b32 <.L154>

80021af6 <.L147>:
    case CLK_SRC_GROUP_AXI0:
        status = status_clk_shared_axi0;
80021af6:	6795                	lui	a5,0x5
80021af8:	5f578793          	add	a5,a5,1525 # 55f5 <__HEAPSIZE__+0x15f5>
80021afc:	ce3e                	sw	a5,28(sp)
        break;
80021afe:	a815                	j	80021b32 <.L154>

80021b00 <.L146>:
    case CLK_SRC_GROUP_AXI1:
        status = status_clk_shared_axi1;
80021b00:	6795                	lui	a5,0x5
80021b02:	5f678793          	add	a5,a5,1526 # 55f6 <__HEAPSIZE__+0x15f6>
80021b06:	ce3e                	sw	a5,28(sp)
        break;
80021b08:	a02d                	j	80021b32 <.L154>

80021b0a <.L145>:
    case CLK_SRC_GROUP_AXI2:
        status = status_clk_shared_axi2;
80021b0a:	6795                	lui	a5,0x5
80021b0c:	5f778793          	add	a5,a5,1527 # 55f7 <__HEAPSIZE__+0x15f7>
80021b10:	ce3e                	sw	a5,28(sp)
        break;
80021b12:	a005                	j	80021b32 <.L154>

80021b14 <.L144>:
    case CLK_SRC_GROUP_CPU0:
        status = status_clk_shared_cpu0;
80021b14:	6795                	lui	a5,0x5
80021b16:	5f878793          	add	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
80021b1a:	ce3e                	sw	a5,28(sp)
        break;
80021b1c:	a819                	j	80021b32 <.L154>

80021b1e <.L143>:
    case CLK_SRC_GROUP_CPU1:
        status = status_clk_shared_cpu1;
80021b1e:	6795                	lui	a5,0x5
80021b20:	5f978793          	add	a5,a5,1529 # 55f9 <__HEAPSIZE__+0x15f9>
80021b24:	ce3e                	sw	a5,28(sp)
        break;
80021b26:	a031                	j	80021b32 <.L154>

80021b28 <.L140>:
    default:
        status = status_clk_src_invalid;
80021b28:	6795                	lui	a5,0x5
80021b2a:	5f178793          	add	a5,a5,1521 # 55f1 <__HEAPSIZE__+0x15f1>
80021b2e:	ce3e                	sw	a5,28(sp)
        break;
80021b30:	0001                	nop

80021b32 <.L154>:
    }

    return status;
80021b32:	47f2                	lw	a5,28(sp)
}
80021b34:	853e                	mv	a0,a5
80021b36:	50b2                	lw	ra,44(sp)
80021b38:	6145                	add	sp,sp,48
80021b3a:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80021b3c <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80021b3c:	7179                	add	sp,sp,-48
80021b3e:	d606                	sw	ra,44(sp)
80021b40:	c62a                	sw	a0,12(sp)
80021b42:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80021b44:	47b2                	lw	a5,12(sp)
80021b46:	83c1                	srl	a5,a5,0x10
80021b48:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80021b4a:	4772                	lw	a4,28(sp)
80021b4c:	15d00793          	li	a5,349
80021b50:	00e7ef63          	bltu	a5,a4,80021b6e <.L165>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80021b54:	47a2                	lw	a5,8(sp)
80021b56:	0ff7f793          	zext.b	a5,a5
80021b5a:	4772                	lw	a4,28(sp)
80021b5c:	0742                	sll	a4,a4,0x10
80021b5e:	8341                	srl	a4,a4,0x10
80021b60:	4685                	li	a3,1
80021b62:	863a                	mv	a2,a4
80021b64:	85be                	mv	a1,a5
80021b66:	f4000537          	lui	a0,0xf4000
80021b6a:	098020ef          	jal	80023c02 <sysctl_enable_group_resource>

80021b6e <.L165>:
    }
}
80021b6e:	0001                	nop
80021b70:	50b2                	lw	ra,44(sp)
80021b72:	6145                	add	sp,sp,48
80021b74:	8082                	ret

Disassembly of section .text.clock_cpu_delay_ms:

80021b76 <clock_cpu_delay_ms>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_cpu_delay_ms(uint32_t ms)
{
80021b76:	715d                	add	sp,sp,-80
80021b78:	c686                	sw	ra,76(sp)
80021b7a:	c4a2                	sw	s0,72(sp)
80021b7c:	c2a6                	sw	s1,68(sp)
80021b7e:	c0ca                	sw	s2,64(sp)
80021b80:	de4e                	sw	s3,60(sp)
80021b82:	dc52                	sw	s4,56(sp)
80021b84:	da56                	sw	s5,52(sp)
80021b86:	d85a                	sw	s6,48(sp)
80021b88:	d65e                	sw	s7,44(sp)
80021b8a:	c62a                	sw	a0,12(sp)
    uint64_t expected_ticks = hpm_csr_get_core_cycle() + (uint64_t)clock_get_core_clock_ticks_per_ms() * (uint64_t)ms;
80021b8c:	31c9                	jal	8002184e <hpm_csr_get_core_cycle>
80021b8e:	8b2a                	mv	s6,a0
80021b90:	8bae                	mv	s7,a1
80021b92:	02c020ef          	jal	80023bbe <clock_get_core_clock_ticks_per_ms>
80021b96:	87aa                	mv	a5,a0
80021b98:	8a3e                	mv	s4,a5
80021b9a:	4a81                	li	s5,0
80021b9c:	47b2                	lw	a5,12(sp)
80021b9e:	893e                	mv	s2,a5
80021ba0:	4981                	li	s3,0
80021ba2:	032a8733          	mul	a4,s5,s2
80021ba6:	034987b3          	mul	a5,s3,s4
80021baa:	97ba                	add	a5,a5,a4
80021bac:	032a0733          	mul	a4,s4,s2
80021bb0:	032a34b3          	mulhu	s1,s4,s2
80021bb4:	843a                	mv	s0,a4
80021bb6:	97a6                	add	a5,a5,s1
80021bb8:	84be                	mv	s1,a5
80021bba:	008b0733          	add	a4,s6,s0
80021bbe:	86ba                	mv	a3,a4
80021bc0:	0166b6b3          	sltu	a3,a3,s6
80021bc4:	009b87b3          	add	a5,s7,s1
80021bc8:	96be                	add	a3,a3,a5
80021bca:	87b6                	mv	a5,a3
80021bcc:	cc3a                	sw	a4,24(sp)
80021bce:	ce3e                	sw	a5,28(sp)
    while (hpm_csr_get_core_cycle() < expected_ticks) {
80021bd0:	0001                	nop

80021bd2 <.L188>:
80021bd2:	39b5                	jal	8002184e <hpm_csr_get_core_cycle>
80021bd4:	872a                	mv	a4,a0
80021bd6:	87ae                	mv	a5,a1
80021bd8:	46f2                	lw	a3,28(sp)
80021bda:	863e                	mv	a2,a5
80021bdc:	fed66be3          	bltu	a2,a3,80021bd2 <.L188>
80021be0:	46f2                	lw	a3,28(sp)
80021be2:	863e                	mv	a2,a5
80021be4:	00c69663          	bne	a3,a2,80021bf0 <.L190>
80021be8:	46e2                	lw	a3,24(sp)
80021bea:	87ba                	mv	a5,a4
80021bec:	fed7e3e3          	bltu	a5,a3,80021bd2 <.L188>

80021bf0 <.L190>:
    }
}
80021bf0:	0001                	nop
80021bf2:	40b6                	lw	ra,76(sp)
80021bf4:	4426                	lw	s0,72(sp)
80021bf6:	4496                	lw	s1,68(sp)
80021bf8:	4906                	lw	s2,64(sp)
80021bfa:	59f2                	lw	s3,60(sp)
80021bfc:	5a62                	lw	s4,56(sp)
80021bfe:	5ad2                	lw	s5,52(sp)
80021c00:	5b42                	lw	s6,48(sp)
80021c02:	5bb2                	lw	s7,44(sp)
80021c04:	6161                	add	sp,sp,80
80021c06:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

80021c08 <clock_update_core_clock>:

void clock_update_core_clock(void)
{
80021c08:	1101                	add	sp,sp,-32
80021c0a:	ce06                	sw	ra,28(sp)

80021c0c <.LBB16>:
    uint32_t hart_id = read_csr(CSR_MHARTID);
80021c0c:	f14027f3          	csrr	a5,mhartid
80021c10:	c63e                	sw	a5,12(sp)
80021c12:	47b2                	lw	a5,12(sp)

80021c14 <.LBE16>:
80021c14:	c43e                	sw	a5,8(sp)
    clock_name_t cpu_clk_name = (hart_id == 1U) ? clock_cpu1 : clock_cpu0;
80021c16:	4722                	lw	a4,8(sp)
80021c18:	4785                	li	a5,1
80021c1a:	00f71663          	bne	a4,a5,80021c26 <.L192>
80021c1e:	000807b7          	lui	a5,0x80
80021c22:	0789                	add	a5,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
80021c24:	a011                	j	80021c28 <.L193>

80021c26 <.L192>:
80021c26:	4781                	li	a5,0

80021c28 <.L193>:
80021c28:	c23e                	sw	a5,4(sp)
    hpm_core_clock = clock_get_frequency(cpu_clk_name);
80021c2a:	4512                	lw	a0,4(sp)
80021c2c:	3319                	jal	80021932 <clock_get_frequency>
80021c2e:	872a                	mv	a4,a0
80021c30:	82e22623          	sw	a4,-2004(tp) # fffff82c <__APB_SRAM_segment_end__+0xbf0d82c>
80021c34:	0001                	nop
80021c36:	40f2                	lw	ra,28(sp)
80021c38:	6105                	add	sp,sp,32
80021c3a:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80021c3c <l1c_dc_enable>:

    write_csr(CSR_MSTATUS, csr);
}

void l1c_dc_enable(void)
{
80021c3c:	1141                	add	sp,sp,-16

80021c3e <.LBB56>:
extern "C" {
#endif
/* get cache control register value */
__attribute__((always_inline)) static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80021c3e:	7ca027f3          	csrr	a5,0x7ca
80021c42:	c63e                	sw	a5,12(sp)
80021c44:	47b2                	lw	a5,12(sp)

80021c46 <.LBE60>:
80021c46:	0001                	nop

80021c48 <.LBE58>:
}

__attribute__((always_inline)) static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80021c48:	8b89                	and	a5,a5,2
80021c4a:	00f037b3          	snez	a5,a5
80021c4e:	0ff7f793          	zext.b	a5,a5

80021c52 <.LBE56>:
    if (!l1c_dc_is_enabled()) {
80021c52:	0017c793          	xor	a5,a5,1
80021c56:	0ff7f793          	zext.b	a5,a5
80021c5a:	cb89                	beqz	a5,80021c6c <.L13>
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
80021c5c:	001807b7          	lui	a5,0x180
80021c60:	7ca7b073          	csrc	0x7ca,a5
        set_csr(CSR_MCACHE_CTL,
80021c64:	67c1                	lui	a5,0x10
80021c66:	0789                	add	a5,a5,2 # 10002 <__AHB_SRAM_segment_size__+0x8002>
80021c68:	7ca7a073          	csrs	0x7ca,a5

80021c6c <.L13>:
                HPM_MCACHE_CTL_DC_WAROUND(L1C_DC_WAROUND_VALUE) |
#endif
                                HPM_MCACHE_CTL_DPREF_EN_MASK
                              | HPM_MCACHE_CTL_DC_EN_MASK);
    }
}
80021c6c:	0001                	nop
80021c6e:	0141                	add	sp,sp,16
80021c70:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

80021c72 <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
80021c72:	1141                	add	sp,sp,-16

80021c74 <.LBB66>:
    return read_csr(CSR_MCACHE_CTL);
80021c74:	7ca027f3          	csrr	a5,0x7ca
80021c78:	c63e                	sw	a5,12(sp)
80021c7a:	47b2                	lw	a5,12(sp)

80021c7c <.LBE70>:
80021c7c:	0001                	nop

80021c7e <.LBE68>:
}

__attribute__((always_inline)) static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
80021c7e:	8b85                	and	a5,a5,1
80021c80:	00f037b3          	snez	a5,a5
80021c84:	0ff7f793          	zext.b	a5,a5

80021c88 <.LBE66>:
    if (!l1c_ic_is_enabled()) {
80021c88:	0017c793          	xor	a5,a5,1
80021c8c:	0ff7f793          	zext.b	a5,a5
80021c90:	c789                	beqz	a5,80021c9a <.L23>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
80021c92:	30100793          	li	a5,769
80021c96:	7ca7a073          	csrs	0x7ca,a5

80021c9a <.L23>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80021c9a:	0001                	nop
80021c9c:	0141                	add	sp,sp,16
80021c9e:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

80021ca0 <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
80021ca0:	1141                	add	sp,sp,-16
80021ca2:	c62a                	sw	a0,12(sp)
80021ca4:	87ae                	mv	a5,a1
80021ca6:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
80021caa:	00a15783          	lhu	a5,10(sp)
80021cae:	4732                	lw	a4,12(sp)
80021cb0:	078a                	sll	a5,a5,0x2
80021cb2:	97ba                	add	a5,a5,a4
80021cb4:	4398                	lw	a4,0(a5)
80021cb6:	400007b7          	lui	a5,0x40000
80021cba:	8ff9                	and	a5,a5,a4
80021cbc:	00f037b3          	snez	a5,a5
80021cc0:	0ff7f793          	zext.b	a5,a5
}
80021cc4:	853e                	mv	a0,a5
80021cc6:	0141                	add	sp,sp,16
80021cc8:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

80021cca <sysctl_clock_target_is_busy>:
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr,
                                               clock_node_t clock)
{
80021cca:	1141                	add	sp,sp,-16
80021ccc:	c62a                	sw	a0,12(sp)
80021cce:	87ae                	mv	a5,a1
80021cd0:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
80021cd4:	00b14783          	lbu	a5,11(sp)
80021cd8:	4732                	lw	a4,12(sp)
80021cda:	60078793          	add	a5,a5,1536 # 40000600 <__SHARE_RAM_segment_end__+0x3ee80600>
80021cde:	078a                	sll	a5,a5,0x2
80021ce0:	97ba                	add	a5,a5,a4
80021ce2:	4398                	lw	a4,0(a5)
80021ce4:	400007b7          	lui	a5,0x40000
80021ce8:	8ff9                	and	a5,a5,a4
80021cea:	00f037b3          	snez	a5,a5
80021cee:	0ff7f793          	zext.b	a5,a5
}
80021cf2:	853e                	mv	a0,a5
80021cf4:	0141                	add	sp,sp,16
80021cf6:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

80021cf8 <sysctl_config_clock>:
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node,
                                clock_source_t source, uint32_t divide_by)
{
80021cf8:	1101                	add	sp,sp,-32
80021cfa:	ce06                	sw	ra,28(sp)
80021cfc:	c62a                	sw	a0,12(sp)
80021cfe:	87ae                	mv	a5,a1
80021d00:	8732                	mv	a4,a2
80021d02:	c236                	sw	a3,4(sp)
80021d04:	00f105a3          	sb	a5,11(sp)
80021d08:	87ba                	mv	a5,a4
80021d0a:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_i2s_start) {
80021d0e:	00b14703          	lbu	a4,11(sp)
80021d12:	04200793          	li	a5,66
80021d16:	00e7f463          	bgeu	a5,a4,80021d1e <.L114>
        return status_invalid_argument;
80021d1a:	4789                	li	a5,2
80021d1c:	a89d                	j	80021d92 <.L115>

80021d1e <.L114>:
    }

    if (source >= clock_source_general_source_end) {
80021d1e:	00a14703          	lbu	a4,10(sp)
80021d22:	479d                	li	a5,7
80021d24:	00e7f463          	bgeu	a5,a4,80021d2c <.L116>
        return status_invalid_argument;
80021d28:	4789                	li	a5,2
80021d2a:	a0a5                	j	80021d92 <.L115>

80021d2c <.L116>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80021d2c:	00b14783          	lbu	a5,11(sp)
80021d30:	4732                	lw	a4,12(sp)
80021d32:	60078793          	add	a5,a5,1536 # 40000600 <__SHARE_RAM_segment_end__+0x3ee80600>
80021d36:	078a                	sll	a5,a5,0x2
80021d38:	97ba                	add	a5,a5,a4
80021d3a:	4398                	lw	a4,0(a5)
80021d3c:	77fd                	lui	a5,0xfffff
80021d3e:	00f776b3          	and	a3,a4,a5
            ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK))
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80021d42:	00a14783          	lbu	a5,10(sp)
80021d46:	00879713          	sll	a4,a5,0x8
80021d4a:	6785                	lui	a5,0x1
80021d4c:	f0078793          	add	a5,a5,-256 # f00 <__ILM_segment_used_end__+0xbc2>
80021d50:	8f7d                	and	a4,a4,a5
80021d52:	4792                	lw	a5,4(sp)
80021d54:	17fd                	add	a5,a5,-1
80021d56:	0ff7f793          	zext.b	a5,a5
80021d5a:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80021d5c:	00b14783          	lbu	a5,11(sp)
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80021d60:	8f55                	or	a4,a4,a3
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80021d62:	46b2                	lw	a3,12(sp)
80021d64:	60078793          	add	a5,a5,1536
80021d68:	078a                	sll	a5,a5,0x2
80021d6a:	97b6                	add	a5,a5,a3
80021d6c:	c398                	sw	a4,0(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
80021d6e:	0001                	nop

80021d70 <.L117>:
80021d70:	00b14783          	lbu	a5,11(sp)
80021d74:	85be                	mv	a1,a5
80021d76:	4532                	lw	a0,12(sp)
80021d78:	3f89                	jal	80021cca <sysctl_clock_target_is_busy>
80021d7a:	87aa                	mv	a5,a0
80021d7c:	fbf5                	bnez	a5,80021d70 <.L117>
    }

    if ((node == clock_node_cpu0) || (node == clock_node_cpu1)) {
80021d7e:	00b14783          	lbu	a5,11(sp)
80021d82:	c791                	beqz	a5,80021d8e <.L118>
80021d84:	00b14703          	lbu	a4,11(sp)
80021d88:	4789                	li	a5,2
80021d8a:	00f71363          	bne	a4,a5,80021d90 <.L119>

80021d8e <.L118>:
        clock_update_core_clock();
80021d8e:	3dad                	jal	80021c08 <clock_update_core_clock>

80021d90 <.L119>:
    }
    return status_success;
80021d90:	4781                	li	a5,0

80021d92 <.L115>:
}
80021d92:	853e                	mv	a0,a5
80021d94:	40f2                	lw	ra,28(sp)
80021d96:	6105                	add	sp,sp,32
80021d98:	8082                	ret

Disassembly of section .text.system_init:

80021d9a <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80021d9a:	7179                	add	sp,sp,-48
80021d9c:	d606                	sw	ra,44(sp)
80021d9e:	47a1                	li	a5,8
80021da0:	c83e                	sw	a5,16(sp)

80021da2 <.LBB16>:
 * @param[in] mask interrupt mask to be disabled
 * @retval current mstatus value before irq mask is disabled
 */
ATTR_ALWAYS_INLINE static inline uint32_t disable_global_irq(uint32_t mask)
{
    return read_clear_csr(CSR_MSTATUS, mask);
80021da2:	c602                	sw	zero,12(sp)
80021da4:	47c2                	lw	a5,16(sp)
80021da6:	3007b7f3          	csrrc	a5,mstatus,a5
80021daa:	c63e                	sw	a5,12(sp)
80021dac:	47b2                	lw	a5,12(sp)

80021dae <.LBE18>:
80021dae:	0001                	nop

80021db0 <.LBB19>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80021db0:	6785                	lui	a5,0x1
80021db2:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x4c2>
80021db6:	3047b073          	csrc	mie,a5
}
80021dba:	0001                	nop

80021dbc <.LBE19>:
    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();
    enable_plic_feature();
80021dbc:	76f010ef          	jal	80023d2a <enable_plic_feature>

80021dc0 <.LBB21>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80021dc0:	6785                	lui	a5,0x1
80021dc2:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x4c2>
80021dc6:	3047a073          	csrs	mie,a5
}
80021dca:	0001                	nop
80021dcc:	47a1                	li	a5,8
80021dce:	ca3e                	sw	a5,20(sp)

80021dd0 <.LBB23>:
    set_csr(CSR_MSTATUS, mask);
80021dd0:	47d2                	lw	a5,20(sp)
80021dd2:	3007a073          	csrs	mstatus,a5
}
80021dd6:	0001                	nop

80021dd8 <.LBB25>:
#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif

#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
80021dd8:	306027f3          	csrr	a5,mcounteren
80021ddc:	ce3e                	sw	a5,28(sp)
80021dde:	47f2                	lw	a5,28(sp)

80021de0 <.LBE25>:
80021de0:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80021de2:	47e2                	lw	a5,24(sp)
80021de4:	0017e793          	or	a5,a5,1
80021de8:	30679073          	csrw	mcounteren,a5
#endif

#if defined(CONFIG_ENABLE_BPOR_RETENTION) && CONFIG_ENABLE_BPOR_RETENTION
    bpor_enable_reg_value_retention(HPM_BPOR);
#endif
}
80021dec:	0001                	nop
80021dee:	50b2                	lw	ra,44(sp)
80021df0:	6145                	add	sp,sp,48
80021df2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80021df4 <__SEGGER_RTL_xltoa>:
80021df4:	882a                	mv	a6,a0
80021df6:	88ae                	mv	a7,a1
80021df8:	852e                	mv	a0,a1
80021dfa:	ca89                	beqz	a3,80021e0c <.L2>
80021dfc:	02d00793          	li	a5,45
80021e00:	00158893          	add	a7,a1,1
80021e04:	00f58023          	sb	a5,0(a1)
80021e08:	41000833          	neg	a6,a6

80021e0c <.L2>:
80021e0c:	8746                	mv	a4,a7
80021e0e:	4325                	li	t1,9

80021e10 <.L5>:
80021e10:	02c876b3          	remu	a3,a6,a2
80021e14:	85c2                	mv	a1,a6
80021e16:	0ff6f793          	zext.b	a5,a3
80021e1a:	02c85833          	divu	a6,a6,a2
80021e1e:	02d37d63          	bgeu	t1,a3,80021e58 <.L3>
80021e22:	05778793          	add	a5,a5,87

80021e26 <.L11>:
80021e26:	0ff7f793          	zext.b	a5,a5
80021e2a:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3cf8000>
80021e2e:	00170693          	add	a3,a4,1
80021e32:	02c5f163          	bgeu	a1,a2,80021e54 <.L8>
80021e36:	000700a3          	sb	zero,1(a4)

80021e3a <.L6>:
80021e3a:	0008c683          	lbu	a3,0(a7)
80021e3e:	00074783          	lbu	a5,0(a4)
80021e42:	0885                	add	a7,a7,1
80021e44:	177d                	add	a4,a4,-1
80021e46:	00d700a3          	sb	a3,1(a4)
80021e4a:	fef88fa3          	sb	a5,-1(a7)
80021e4e:	fee8e6e3          	bltu	a7,a4,80021e3a <.L6>
80021e52:	8082                	ret

80021e54 <.L8>:
80021e54:	8736                	mv	a4,a3
80021e56:	bf6d                	j	80021e10 <.L5>

80021e58 <.L3>:
80021e58:	03078793          	add	a5,a5,48
80021e5c:	b7e9                	j	80021e26 <.L11>

Disassembly of section .text.libc.itoa:

80021e5e <itoa>:
80021e5e:	46a9                	li	a3,10
80021e60:	87aa                	mv	a5,a0
80021e62:	882e                	mv	a6,a1
80021e64:	8732                	mv	a4,a2
80021e66:	00d61563          	bne	a2,a3,80021e70 <.L301>
80021e6a:	4685                	li	a3,1
80021e6c:	00054663          	bltz	a0,80021e78 <.L302>

80021e70 <.L301>:
80021e70:	4681                	li	a3,0
80021e72:	863a                	mv	a2,a4
80021e74:	85c2                	mv	a1,a6
80021e76:	853e                	mv	a0,a5

80021e78 <.L302>:
80021e78:	bfb5                	j	80021df4 <__SEGGER_RTL_xltoa>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

80021e7a <__SEGGER_RTL_SIGNAL_SIG_ERR>:
80021e7a:	8082                	ret

Disassembly of section .text.libc.fwrite:

80021e7c <fwrite>:
80021e7c:	1101                	add	sp,sp,-32
80021e7e:	c64e                	sw	s3,12(sp)
80021e80:	89aa                	mv	s3,a0
80021e82:	8536                	mv	a0,a3
80021e84:	cc22                	sw	s0,24(sp)
80021e86:	ca26                	sw	s1,20(sp)
80021e88:	c84a                	sw	s2,16(sp)
80021e8a:	ce06                	sw	ra,28(sp)
80021e8c:	84ae                	mv	s1,a1
80021e8e:	8432                	mv	s0,a2
80021e90:	8936                	mv	s2,a3
80021e92:	0da010ef          	jal	80022f6c <__SEGGER_RTL_X_file_stat>
80021e96:	02054463          	bltz	a0,80021ebe <.L43>
80021e9a:	02848633          	mul	a2,s1,s0
80021e9e:	4501                	li	a0,0
80021ea0:	00966863          	bltu	a2,s1,80021eb0 <.L41>
80021ea4:	85ce                	mv	a1,s3
80021ea6:	854a                	mv	a0,s2
80021ea8:	052010ef          	jal	80022efa <__SEGGER_RTL_X_file_write>
80021eac:	02955533          	divu	a0,a0,s1

80021eb0 <.L41>:
80021eb0:	40f2                	lw	ra,28(sp)
80021eb2:	4462                	lw	s0,24(sp)
80021eb4:	44d2                	lw	s1,20(sp)
80021eb6:	4942                	lw	s2,16(sp)
80021eb8:	49b2                	lw	s3,12(sp)
80021eba:	6105                	add	sp,sp,32
80021ebc:	8082                	ret

80021ebe <.L43>:
80021ebe:	4501                	li	a0,0
80021ec0:	bfc5                	j	80021eb0 <.L41>

Disassembly of section .text.libc.__subsf3:

80021ec2 <__subsf3>:
80021ec2:	80000637          	lui	a2,0x80000
80021ec6:	8db1                	xor	a1,a1,a2
80021ec8:	a009                	j	80021eca <__addsf3>

Disassembly of section .text.libc.__addsf3:

80021eca <__addsf3>:
80021eca:	80000637          	lui	a2,0x80000
80021ece:	00b546b3          	xor	a3,a0,a1
80021ed2:	0806ca63          	bltz	a3,80021f66 <.L__addsf3_subtract>
80021ed6:	00b57563          	bgeu	a0,a1,80021ee0 <.L__addsf3_add_already_ordered>
80021eda:	86aa                	mv	a3,a0
80021edc:	852e                	mv	a0,a1
80021ede:	85b6                	mv	a1,a3

80021ee0 <.L__addsf3_add_already_ordered>:
80021ee0:	00151713          	sll	a4,a0,0x1
80021ee4:	8361                	srl	a4,a4,0x18
80021ee6:	00159693          	sll	a3,a1,0x1
80021eea:	82e1                	srl	a3,a3,0x18
80021eec:	0ff00293          	li	t0,255
80021ef0:	06570563          	beq	a4,t0,80021f5a <.L__addsf3_add_inf_or_nan>
80021ef4:	c325                	beqz	a4,80021f54 <.L__addsf3_zero>
80021ef6:	ceb1                	beqz	a3,80021f52 <.L__addsf3_add_done>
80021ef8:	40d706b3          	sub	a3,a4,a3
80021efc:	42e1                	li	t0,24
80021efe:	04d2ca63          	blt	t0,a3,80021f52 <.L__addsf3_add_done>
80021f02:	05a2                	sll	a1,a1,0x8
80021f04:	8dd1                	or	a1,a1,a2
80021f06:	01755713          	srl	a4,a0,0x17
80021f0a:	0522                	sll	a0,a0,0x8
80021f0c:	8d51                	or	a0,a0,a2
80021f0e:	47e5                	li	a5,25
80021f10:	8f95                	sub	a5,a5,a3
80021f12:	00f59633          	sll	a2,a1,a5
80021f16:	821d                	srl	a2,a2,0x7
80021f18:	00d5d5b3          	srl	a1,a1,a3
80021f1c:	00b507b3          	add	a5,a0,a1
80021f20:	00a7f463          	bgeu	a5,a0,80021f28 <.L__addsf3_add_no_normalization>
80021f24:	8385                	srl	a5,a5,0x1
80021f26:	0709                	add	a4,a4,2

80021f28 <.L__addsf3_add_no_normalization>:
80021f28:	177d                	add	a4,a4,-1
80021f2a:	0ff77593          	zext.b	a1,a4
80021f2e:	f0158593          	add	a1,a1,-255
80021f32:	cd91                	beqz	a1,80021f4e <.L__addsf3_inf>
80021f34:	075e                	sll	a4,a4,0x17
80021f36:	0087d513          	srl	a0,a5,0x8
80021f3a:	07e2                	sll	a5,a5,0x18
80021f3c:	8fd1                	or	a5,a5,a2
80021f3e:	0007d663          	bgez	a5,80021f4a <.L__addsf3_no_tie>
80021f42:	0786                	sll	a5,a5,0x1
80021f44:	0505                	add	a0,a0,1 # f4000001 <__AHB_SRAM_segment_end__+0x3cf8001>
80021f46:	e391                	bnez	a5,80021f4a <.L__addsf3_no_tie>
80021f48:	9979                	and	a0,a0,-2

80021f4a <.L__addsf3_no_tie>:
80021f4a:	953a                	add	a0,a0,a4
80021f4c:	8082                	ret

80021f4e <.L__addsf3_inf>:
80021f4e:	01771513          	sll	a0,a4,0x17

80021f52 <.L__addsf3_add_done>:
80021f52:	8082                	ret

80021f54 <.L__addsf3_zero>:
80021f54:	817d                	srl	a0,a0,0x1f
80021f56:	057e                	sll	a0,a0,0x1f
80021f58:	8082                	ret

80021f5a <.L__addsf3_add_inf_or_nan>:
80021f5a:	00951613          	sll	a2,a0,0x9
80021f5e:	da75                	beqz	a2,80021f52 <.L__addsf3_add_done>

80021f60 <.L__addsf3_return_nan>:
80021f60:	7fc00537          	lui	a0,0x7fc00
80021f64:	8082                	ret

80021f66 <.L__addsf3_subtract>:
80021f66:	8db1                	xor	a1,a1,a2
80021f68:	40b506b3          	sub	a3,a0,a1
80021f6c:	00b57563          	bgeu	a0,a1,80021f76 <.L__addsf3_sub_already_ordered>
80021f70:	8eb1                	xor	a3,a3,a2
80021f72:	8d15                	sub	a0,a0,a3
80021f74:	95b6                	add	a1,a1,a3

80021f76 <.L__addsf3_sub_already_ordered>:
80021f76:	00159693          	sll	a3,a1,0x1
80021f7a:	82e1                	srl	a3,a3,0x18
80021f7c:	00151713          	sll	a4,a0,0x1
80021f80:	8361                	srl	a4,a4,0x18
80021f82:	05a2                	sll	a1,a1,0x8
80021f84:	8dd1                	or	a1,a1,a2
80021f86:	0ff00293          	li	t0,255
80021f8a:	0c570c63          	beq	a4,t0,80022062 <.L__addsf3_sub_inf_or_nan>
80021f8e:	c2f5                	beqz	a3,80022072 <.L__addsf3_sub_zero>
80021f90:	40d706b3          	sub	a3,a4,a3
80021f94:	c695                	beqz	a3,80021fc0 <.L__addsf3_exponents_equal>
80021f96:	4285                	li	t0,1
80021f98:	08569063          	bne	a3,t0,80022018 <.L__addsf3_exponents_differ_by_more_than_1>
80021f9c:	01755693          	srl	a3,a0,0x17
80021fa0:	0526                	sll	a0,a0,0x9
80021fa2:	00b532b3          	sltu	t0,a0,a1
80021fa6:	8d0d                	sub	a0,a0,a1
80021fa8:	02029263          	bnez	t0,80021fcc <.L__addsf3_normalization_steps>
80021fac:	06de                	sll	a3,a3,0x17
80021fae:	01751593          	sll	a1,a0,0x17
80021fb2:	8125                	srl	a0,a0,0x9
80021fb4:	0005d463          	bgez	a1,80021fbc <.L__addsf3_sub_no_tie_single>
80021fb8:	0505                	add	a0,a0,1 # 7fc00001 <__SHARE_RAM_segment_end__+0x7ea80001>
80021fba:	9979                	and	a0,a0,-2

80021fbc <.L__addsf3_sub_no_tie_single>:
80021fbc:	9536                	add	a0,a0,a3

80021fbe <.L__addsf3_sub_done>:
80021fbe:	8082                	ret

80021fc0 <.L__addsf3_exponents_equal>:
80021fc0:	01755693          	srl	a3,a0,0x17
80021fc4:	0526                	sll	a0,a0,0x9
80021fc6:	0586                	sll	a1,a1,0x1
80021fc8:	8d0d                	sub	a0,a0,a1
80021fca:	d975                	beqz	a0,80021fbe <.L__addsf3_sub_done>

80021fcc <.L__addsf3_normalization_steps>:
80021fcc:	4581                	li	a1,0
80021fce:	01055793          	srl	a5,a0,0x10
80021fd2:	e399                	bnez	a5,80021fd8 <.L1^B1>
80021fd4:	0542                	sll	a0,a0,0x10
80021fd6:	05c1                	add	a1,a1,16

80021fd8 <.L1^B1>:
80021fd8:	01855793          	srl	a5,a0,0x18
80021fdc:	e399                	bnez	a5,80021fe2 <.L2^B1>
80021fde:	0522                	sll	a0,a0,0x8
80021fe0:	05a1                	add	a1,a1,8

80021fe2 <.L2^B1>:
80021fe2:	01c55793          	srl	a5,a0,0x1c
80021fe6:	e399                	bnez	a5,80021fec <.L3^B1>
80021fe8:	0512                	sll	a0,a0,0x4
80021fea:	0591                	add	a1,a1,4

80021fec <.L3^B1>:
80021fec:	01e55793          	srl	a5,a0,0x1e
80021ff0:	e399                	bnez	a5,80021ff6 <.L4^B1>
80021ff2:	050a                	sll	a0,a0,0x2
80021ff4:	0589                	add	a1,a1,2

80021ff6 <.L4^B1>:
80021ff6:	00054463          	bltz	a0,80021ffe <.L5^B1>
80021ffa:	0506                	sll	a0,a0,0x1
80021ffc:	0585                	add	a1,a1,1

80021ffe <.L5^B1>:
80021ffe:	0585                	add	a1,a1,1
80022000:	0506                	sll	a0,a0,0x1
80022002:	00e5f763          	bgeu	a1,a4,80022010 <.L__addsf3_underflow>
80022006:	8e8d                	sub	a3,a3,a1
80022008:	06de                	sll	a3,a3,0x17
8002200a:	8125                	srl	a0,a0,0x9
8002200c:	9536                	add	a0,a0,a3
8002200e:	8082                	ret

80022010 <.L__addsf3_underflow>:
80022010:	0086d513          	srl	a0,a3,0x8
80022014:	057e                	sll	a0,a0,0x1f
80022016:	8082                	ret

80022018 <.L__addsf3_exponents_differ_by_more_than_1>:
80022018:	42e5                	li	t0,25
8002201a:	fad2e2e3          	bltu	t0,a3,80021fbe <.L__addsf3_sub_done>
8002201e:	0685                	add	a3,a3,1
80022020:	40d00733          	neg	a4,a3
80022024:	00e59733          	sll	a4,a1,a4
80022028:	00d5d5b3          	srl	a1,a1,a3
8002202c:	00e03733          	snez	a4,a4
80022030:	95ae                	add	a1,a1,a1
80022032:	95ba                	add	a1,a1,a4
80022034:	01755693          	srl	a3,a0,0x17
80022038:	0522                	sll	a0,a0,0x8
8002203a:	8d51                	or	a0,a0,a2
8002203c:	40b50733          	sub	a4,a0,a1
80022040:	00074463          	bltz	a4,80022048 <.L__addsf3_sub_already_normalized>
80022044:	070a                	sll	a4,a4,0x2
80022046:	8305                	srl	a4,a4,0x1

80022048 <.L__addsf3_sub_already_normalized>:
80022048:	16fd                	add	a3,a3,-1
8002204a:	06de                	sll	a3,a3,0x17
8002204c:	00875513          	srl	a0,a4,0x8
80022050:	0762                	sll	a4,a4,0x18
80022052:	00075663          	bgez	a4,8002205e <.L__addsf3_sub_no_tie>
80022056:	0706                	sll	a4,a4,0x1
80022058:	0505                	add	a0,a0,1
8002205a:	e311                	bnez	a4,8002205e <.L__addsf3_sub_no_tie>
8002205c:	9979                	and	a0,a0,-2

8002205e <.L__addsf3_sub_no_tie>:
8002205e:	9536                	add	a0,a0,a3
80022060:	8082                	ret

80022062 <.L__addsf3_sub_inf_or_nan>:
80022062:	0ff00293          	li	t0,255
80022066:	ee568de3          	beq	a3,t0,80021f60 <.L__addsf3_return_nan>
8002206a:	00951593          	sll	a1,a0,0x9
8002206e:	d9a1                	beqz	a1,80021fbe <.L__addsf3_sub_done>
80022070:	bdc5                	j	80021f60 <.L__addsf3_return_nan>

80022072 <.L__addsf3_sub_zero>:
80022072:	f731                	bnez	a4,80021fbe <.L__addsf3_sub_done>
80022074:	4501                	li	a0,0
80022076:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

80022078 <__ltsf2>:
80022078:	ff000637          	lui	a2,0xff000
8002207c:	00151693          	sll	a3,a0,0x1
80022080:	02d66763          	bltu	a2,a3,800220ae <.L__ltsf2_zero>
80022084:	00159693          	sll	a3,a1,0x1
80022088:	02d66363          	bltu	a2,a3,800220ae <.L__ltsf2_zero>
8002208c:	00b56633          	or	a2,a0,a1
80022090:	00161693          	sll	a3,a2,0x1
80022094:	ce89                	beqz	a3,800220ae <.L__ltsf2_zero>
80022096:	00064763          	bltz	a2,800220a4 <.L__ltsf2_negative>
8002209a:	00b53533          	sltu	a0,a0,a1
8002209e:	40a00533          	neg	a0,a0
800220a2:	8082                	ret

800220a4 <.L__ltsf2_negative>:
800220a4:	00a5b533          	sltu	a0,a1,a0
800220a8:	40a00533          	neg	a0,a0
800220ac:	8082                	ret

800220ae <.L__ltsf2_zero>:
800220ae:	4501                	li	a0,0
800220b0:	8082                	ret

Disassembly of section .text.libc.__lesf2:

800220b2 <__lesf2>:
800220b2:	ff000637          	lui	a2,0xff000
800220b6:	00151693          	sll	a3,a0,0x1
800220ba:	02d66363          	bltu	a2,a3,800220e0 <.L__lesf2_nan>
800220be:	00159693          	sll	a3,a1,0x1
800220c2:	00d66f63          	bltu	a2,a3,800220e0 <.L__lesf2_nan>
800220c6:	00b56633          	or	a2,a0,a1
800220ca:	00161693          	sll	a3,a2,0x1
800220ce:	ca99                	beqz	a3,800220e4 <.L__lesf2_zero>
800220d0:	00064563          	bltz	a2,800220da <.L__lesf2_negative>
800220d4:	00a5b533          	sltu	a0,a1,a0
800220d8:	8082                	ret

800220da <.L__lesf2_negative>:
800220da:	00b53533          	sltu	a0,a0,a1
800220de:	8082                	ret

800220e0 <.L__lesf2_nan>:
800220e0:	4505                	li	a0,1
800220e2:	8082                	ret

800220e4 <.L__lesf2_zero>:
800220e4:	4501                	li	a0,0
800220e6:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

800220e8 <__gtsf2>:
800220e8:	ff000637          	lui	a2,0xff000
800220ec:	00151693          	sll	a3,a0,0x1
800220f0:	02d66363          	bltu	a2,a3,80022116 <.L__gtsf2_zero>
800220f4:	00159693          	sll	a3,a1,0x1
800220f8:	00d66f63          	bltu	a2,a3,80022116 <.L__gtsf2_zero>
800220fc:	00b56633          	or	a2,a0,a1
80022100:	00161693          	sll	a3,a2,0x1
80022104:	ca89                	beqz	a3,80022116 <.L__gtsf2_zero>
80022106:	00064563          	bltz	a2,80022110 <.L__gtsf2_negative>
8002210a:	00a5b533          	sltu	a0,a1,a0
8002210e:	8082                	ret

80022110 <.L__gtsf2_negative>:
80022110:	00b53533          	sltu	a0,a0,a1
80022114:	8082                	ret

80022116 <.L__gtsf2_zero>:
80022116:	4501                	li	a0,0
80022118:	8082                	ret

Disassembly of section .text.libc.__gesf2:

8002211a <__gesf2>:
8002211a:	ff000637          	lui	a2,0xff000
8002211e:	00151693          	sll	a3,a0,0x1
80022122:	02d66763          	bltu	a2,a3,80022150 <.L__gesf2_nan>
80022126:	00159693          	sll	a3,a1,0x1
8002212a:	02d66363          	bltu	a2,a3,80022150 <.L__gesf2_nan>
8002212e:	00b56633          	or	a2,a0,a1
80022132:	00161693          	sll	a3,a2,0x1
80022136:	ce99                	beqz	a3,80022154 <.L__gesf2_zero>
80022138:	00064763          	bltz	a2,80022146 <.L__gesf2_negative>
8002213c:	00b53533          	sltu	a0,a0,a1
80022140:	40a00533          	neg	a0,a0
80022144:	8082                	ret

80022146 <.L__gesf2_negative>:
80022146:	00a5b533          	sltu	a0,a1,a0
8002214a:	40a00533          	neg	a0,a0
8002214e:	8082                	ret

80022150 <.L__gesf2_nan>:
80022150:	557d                	li	a0,-1
80022152:	8082                	ret

80022154 <.L__gesf2_zero>:
80022154:	4501                	li	a0,0
80022156:	8082                	ret

Disassembly of section .text.libc.__fixunssfsi:

80022158 <__fixunssfsi>:
80022158:	02a05763          	blez	a0,80022186 <.L__fixunssfsi_zero_result>
8002215c:	00151593          	sll	a1,a0,0x1
80022160:	81e1                	srl	a1,a1,0x18
80022162:	f8158593          	add	a1,a1,-127
80022166:	0205c063          	bltz	a1,80022186 <.L__fixunssfsi_zero_result>
8002216a:	40b005b3          	neg	a1,a1
8002216e:	05fd                	add	a1,a1,31
80022170:	0005c963          	bltz	a1,80022182 <.L__fixunssfsi_max_result>
80022174:	0522                	sll	a0,a0,0x8
80022176:	800006b7          	lui	a3,0x80000
8002217a:	8d55                	or	a0,a0,a3
8002217c:	00b55533          	srl	a0,a0,a1
80022180:	8082                	ret

80022182 <.L__fixunssfsi_max_result>:
80022182:	557d                	li	a0,-1
80022184:	8082                	ret

80022186 <.L__fixunssfsi_zero_result>:
80022186:	4501                	li	a0,0
80022188:	8082                	ret

Disassembly of section .text.libc.__fixunsdfsi:

8002218a <__fixunsdfsi>:
8002218a:	0205c563          	bltz	a1,800221b4 <.L__fixunsdfsi_zero_result>
8002218e:	0145d613          	srl	a2,a1,0x14
80022192:	c0160613          	add	a2,a2,-1023 # fefffc01 <__APB_SRAM_segment_end__+0xaf0dc01>
80022196:	00064f63          	bltz	a2,800221b4 <.L__fixunsdfsi_zero_result>
8002219a:	477d                	li	a4,31
8002219c:	8f11                	sub	a4,a4,a2
8002219e:	00074d63          	bltz	a4,800221b8 <.L__fixunsdfsi_overflow_result>
800221a2:	8155                	srl	a0,a0,0x15
800221a4:	05ae                	sll	a1,a1,0xb
800221a6:	8d4d                	or	a0,a0,a1
800221a8:	800006b7          	lui	a3,0x80000
800221ac:	8d55                	or	a0,a0,a3
800221ae:	00e55533          	srl	a0,a0,a4
800221b2:	8082                	ret

800221b4 <.L__fixunsdfsi_zero_result>:
800221b4:	4501                	li	a0,0
800221b6:	8082                	ret

800221b8 <.L__fixunsdfsi_overflow_result>:
800221b8:	557d                	li	a0,-1
800221ba:	8082                	ret

Disassembly of section .text.libc.__floatsisf:

800221bc <__floatsisf>:
800221bc:	01f55613          	srl	a2,a0,0x1f
800221c0:	0622                	sll	a2,a2,0x8
800221c2:	09d60613          	add	a2,a2,157
800221c6:	cd29                	beqz	a0,80022220 <.L__floatsisf_done>
800221c8:	41f55693          	sra	a3,a0,0x1f
800221cc:	00d545b3          	xor	a1,a0,a3
800221d0:	8d95                	sub	a1,a1,a3
800221d2:	0105d693          	srl	a3,a1,0x10
800221d6:	e299                	bnez	a3,800221dc <.L1^B2>
800221d8:	05c2                	sll	a1,a1,0x10
800221da:	1641                	add	a2,a2,-16

800221dc <.L1^B2>:
800221dc:	0185d693          	srl	a3,a1,0x18
800221e0:	e299                	bnez	a3,800221e6 <.L2^B2>
800221e2:	05a2                	sll	a1,a1,0x8
800221e4:	1661                	add	a2,a2,-8

800221e6 <.L2^B2>:
800221e6:	01c5d693          	srl	a3,a1,0x1c
800221ea:	e299                	bnez	a3,800221f0 <.L3^B2>
800221ec:	0592                	sll	a1,a1,0x4
800221ee:	1671                	add	a2,a2,-4

800221f0 <.L3^B2>:
800221f0:	01e5d693          	srl	a3,a1,0x1e
800221f4:	e299                	bnez	a3,800221fa <.L4^B2>
800221f6:	058a                	sll	a1,a1,0x2
800221f8:	1679                	add	a2,a2,-2

800221fa <.L4^B2>:
800221fa:	0005c463          	bltz	a1,80022202 <.L5^B2>
800221fe:	0586                	sll	a1,a1,0x1
80022200:	167d                	add	a2,a2,-1

80022202 <.L5^B2>:
80022202:	065e                	sll	a2,a2,0x17
80022204:	0085d513          	srl	a0,a1,0x8
80022208:	05de                	sll	a1,a1,0x17
8002220a:	0005a333          	sltz	t1,a1
8002220e:	95ae                	add	a1,a1,a1
80022210:	959a                	add	a1,a1,t1
80022212:	0005d663          	bgez	a1,8002221e <.L__floatsisf_round_down>
80022216:	95ae                	add	a1,a1,a1
80022218:	00b035b3          	snez	a1,a1
8002221c:	952e                	add	a0,a0,a1

8002221e <.L__floatsisf_round_down>:
8002221e:	9532                	add	a0,a0,a2

80022220 <.L__floatsisf_done>:
80022220:	8082                	ret

Disassembly of section .text.libc.__floatunsisf:

80022222 <__floatunsisf>:
80022222:	c931                	beqz	a0,80022276 <.L__floatunsisf_done>
80022224:	09d00613          	li	a2,157
80022228:	01055693          	srl	a3,a0,0x10
8002222c:	e299                	bnez	a3,80022232 <.L1^B8>
8002222e:	0542                	sll	a0,a0,0x10
80022230:	1641                	add	a2,a2,-16

80022232 <.L1^B8>:
80022232:	01855693          	srl	a3,a0,0x18
80022236:	e299                	bnez	a3,8002223c <.L2^B8>
80022238:	0522                	sll	a0,a0,0x8
8002223a:	1661                	add	a2,a2,-8

8002223c <.L2^B8>:
8002223c:	01c55693          	srl	a3,a0,0x1c
80022240:	e299                	bnez	a3,80022246 <.L3^B6>
80022242:	0512                	sll	a0,a0,0x4
80022244:	1671                	add	a2,a2,-4

80022246 <.L3^B6>:
80022246:	01e55693          	srl	a3,a0,0x1e
8002224a:	e299                	bnez	a3,80022250 <.L4^B8>
8002224c:	050a                	sll	a0,a0,0x2
8002224e:	1679                	add	a2,a2,-2

80022250 <.L4^B8>:
80022250:	00054463          	bltz	a0,80022258 <.L5^B6>
80022254:	0506                	sll	a0,a0,0x1
80022256:	167d                	add	a2,a2,-1

80022258 <.L5^B6>:
80022258:	065e                	sll	a2,a2,0x17
8002225a:	01751593          	sll	a1,a0,0x17
8002225e:	8121                	srl	a0,a0,0x8
80022260:	0005a333          	sltz	t1,a1
80022264:	95ae                	add	a1,a1,a1
80022266:	959a                	add	a1,a1,t1
80022268:	0005d663          	bgez	a1,80022274 <.L__floatunsisf_round_down>
8002226c:	95ae                	add	a1,a1,a1
8002226e:	00b035b3          	snez	a1,a1
80022272:	952e                	add	a0,a0,a1

80022274 <.L__floatunsisf_round_down>:
80022274:	9532                	add	a0,a0,a2

80022276 <.L__floatunsisf_done>:
80022276:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

80022278 <__floatundisf>:
80022278:	c5bd                	beqz	a1,800222e6 <.L__floatundisf_high_word_zero>
8002227a:	4701                	li	a4,0
8002227c:	0105d693          	srl	a3,a1,0x10
80022280:	e299                	bnez	a3,80022286 <.L8^B3>
80022282:	0741                	add	a4,a4,16
80022284:	05c2                	sll	a1,a1,0x10

80022286 <.L8^B3>:
80022286:	0185d693          	srl	a3,a1,0x18
8002228a:	e299                	bnez	a3,80022290 <.L4^B10>
8002228c:	0721                	add	a4,a4,8
8002228e:	05a2                	sll	a1,a1,0x8

80022290 <.L4^B10>:
80022290:	01c5d693          	srl	a3,a1,0x1c
80022294:	e299                	bnez	a3,8002229a <.L2^B10>
80022296:	0711                	add	a4,a4,4
80022298:	0592                	sll	a1,a1,0x4

8002229a <.L2^B10>:
8002229a:	01e5d693          	srl	a3,a1,0x1e
8002229e:	e299                	bnez	a3,800222a4 <.L1^B10>
800222a0:	0709                	add	a4,a4,2
800222a2:	058a                	sll	a1,a1,0x2

800222a4 <.L1^B10>:
800222a4:	0005c463          	bltz	a1,800222ac <.L0^B3>
800222a8:	0705                	add	a4,a4,1
800222aa:	0586                	sll	a1,a1,0x1

800222ac <.L0^B3>:
800222ac:	fff74613          	not	a2,a4
800222b0:	00c556b3          	srl	a3,a0,a2
800222b4:	8285                	srl	a3,a3,0x1
800222b6:	8dd5                	or	a1,a1,a3
800222b8:	00e51533          	sll	a0,a0,a4
800222bc:	0be60613          	add	a2,a2,190
800222c0:	00a03533          	snez	a0,a0
800222c4:	8dc9                	or	a1,a1,a0

800222c6 <.L__floatundisf_round_and_pack>:
800222c6:	065e                	sll	a2,a2,0x17
800222c8:	0085d513          	srl	a0,a1,0x8
800222cc:	05de                	sll	a1,a1,0x17
800222ce:	0005a333          	sltz	t1,a1
800222d2:	95ae                	add	a1,a1,a1
800222d4:	959a                	add	a1,a1,t1
800222d6:	0005d663          	bgez	a1,800222e2 <.L__floatundisf_round_down>
800222da:	95ae                	add	a1,a1,a1
800222dc:	00b035b3          	snez	a1,a1
800222e0:	952e                	add	a0,a0,a1

800222e2 <.L__floatundisf_round_down>:
800222e2:	9532                	add	a0,a0,a2

800222e4 <.L__floatundisf_done>:
800222e4:	8082                	ret

800222e6 <.L__floatundisf_high_word_zero>:
800222e6:	dd7d                	beqz	a0,800222e4 <.L__floatundisf_done>
800222e8:	09d00613          	li	a2,157
800222ec:	01055693          	srl	a3,a0,0x10
800222f0:	e299                	bnez	a3,800222f6 <.L1^B11>
800222f2:	0542                	sll	a0,a0,0x10
800222f4:	1641                	add	a2,a2,-16

800222f6 <.L1^B11>:
800222f6:	01855693          	srl	a3,a0,0x18
800222fa:	e299                	bnez	a3,80022300 <.L2^B11>
800222fc:	0522                	sll	a0,a0,0x8
800222fe:	1661                	add	a2,a2,-8

80022300 <.L2^B11>:
80022300:	01c55693          	srl	a3,a0,0x1c
80022304:	e299                	bnez	a3,8002230a <.L3^B8>
80022306:	0512                	sll	a0,a0,0x4
80022308:	1671                	add	a2,a2,-4

8002230a <.L3^B8>:
8002230a:	01e55693          	srl	a3,a0,0x1e
8002230e:	e299                	bnez	a3,80022314 <.L4^B11>
80022310:	050a                	sll	a0,a0,0x2
80022312:	1679                	add	a2,a2,-2

80022314 <.L4^B11>:
80022314:	00054463          	bltz	a0,8002231c <.L5^B8>
80022318:	0506                	sll	a0,a0,0x1
8002231a:	167d                	add	a2,a2,-1

8002231c <.L5^B8>:
8002231c:	85aa                	mv	a1,a0
8002231e:	4501                	li	a0,0
80022320:	b75d                	j	800222c6 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

80022322 <__truncdfsf2>:
80022322:	00159693          	sll	a3,a1,0x1
80022326:	82d5                	srl	a3,a3,0x15
80022328:	7ff00613          	li	a2,2047
8002232c:	04c68663          	beq	a3,a2,80022378 <.L__truncdfsf2_inf_nan>
80022330:	c8068693          	add	a3,a3,-896 # 7ffffc80 <__SHARE_RAM_segment_end__+0x7ee7fc80>
80022334:	02d05e63          	blez	a3,80022370 <.L__truncdfsf2_underflow>
80022338:	0ff00613          	li	a2,255
8002233c:	04c6f263          	bgeu	a3,a2,80022380 <.L__truncdfsf2_inf>
80022340:	06de                	sll	a3,a3,0x17
80022342:	01f5d613          	srl	a2,a1,0x1f
80022346:	067e                	sll	a2,a2,0x1f
80022348:	8ed1                	or	a3,a3,a2
8002234a:	05b2                	sll	a1,a1,0xc
8002234c:	01455613          	srl	a2,a0,0x14
80022350:	8dd1                	or	a1,a1,a2
80022352:	81a5                	srl	a1,a1,0x9
80022354:	00251613          	sll	a2,a0,0x2
80022358:	00062733          	sltz	a4,a2
8002235c:	9632                	add	a2,a2,a2
8002235e:	000627b3          	sltz	a5,a2
80022362:	9632                	add	a2,a2,a2
80022364:	963a                	add	a2,a2,a4
80022366:	c211                	beqz	a2,8002236a <.L__truncdfsf2_no_round_tie>
80022368:	95be                	add	a1,a1,a5

8002236a <.L__truncdfsf2_no_round_tie>:
8002236a:	00d58533          	add	a0,a1,a3
8002236e:	8082                	ret

80022370 <.L__truncdfsf2_underflow>:
80022370:	01f5d513          	srl	a0,a1,0x1f
80022374:	057e                	sll	a0,a0,0x1f
80022376:	8082                	ret

80022378 <.L__truncdfsf2_inf_nan>:
80022378:	00c59693          	sll	a3,a1,0xc
8002237c:	8ec9                	or	a3,a3,a0
8002237e:	ea81                	bnez	a3,8002238e <.L__truncdfsf2_nan>

80022380 <.L__truncdfsf2_inf>:
80022380:	81fd                	srl	a1,a1,0x1f
80022382:	05fe                	sll	a1,a1,0x1f
80022384:	7f800537          	lui	a0,0x7f800
80022388:	8d4d                	or	a0,a0,a1
8002238a:	4581                	li	a1,0
8002238c:	8082                	ret

8002238e <.L__truncdfsf2_nan>:
8002238e:	800006b7          	lui	a3,0x80000
80022392:	00d5f633          	and	a2,a1,a3
80022396:	058e                	sll	a1,a1,0x3
80022398:	8175                	srl	a0,a0,0x1d
8002239a:	8d4d                	or	a0,a0,a1
8002239c:	0506                	sll	a0,a0,0x1
8002239e:	8105                	srl	a0,a0,0x1
800223a0:	8d51                	or	a0,a0,a2
800223a2:	82a5                	srl	a3,a3,0x9
800223a4:	8d55                	or	a0,a0,a3
800223a6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

800223a8 <__SEGGER_RTL_ldouble_to_double>:
800223a8:	4158                	lw	a4,4(a0)
800223aa:	451c                	lw	a5,8(a0)
800223ac:	4554                	lw	a3,12(a0)
800223ae:	1141                	add	sp,sp,-16
800223b0:	c23a                	sw	a4,4(sp)
800223b2:	c43e                	sw	a5,8(sp)
800223b4:	7771                	lui	a4,0xffffc
800223b6:	00169793          	sll	a5,a3,0x1
800223ba:	83c5                	srl	a5,a5,0x11
800223bc:	40070713          	add	a4,a4,1024 # ffffc400 <__APB_SRAM_segment_end__+0xbf0a400>
800223c0:	c636                	sw	a3,12(sp)
800223c2:	97ba                	add	a5,a5,a4
800223c4:	00f04a63          	bgtz	a5,800223d8 <.L27>
800223c8:	800007b7          	lui	a5,0x80000
800223cc:	4701                	li	a4,0
800223ce:	8ff5                	and	a5,a5,a3

800223d0 <.L28>:
800223d0:	853a                	mv	a0,a4
800223d2:	85be                	mv	a1,a5
800223d4:	0141                	add	sp,sp,16
800223d6:	8082                	ret

800223d8 <.L27>:
800223d8:	6711                	lui	a4,0x4
800223da:	3ff70713          	add	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
800223de:	00e78c63          	beq	a5,a4,800223f6 <.L29>
800223e2:	7ff00713          	li	a4,2047
800223e6:	00f75a63          	bge	a4,a5,800223fa <.L30>
800223ea:	4781                	li	a5,0
800223ec:	4801                	li	a6,0
800223ee:	c43e                	sw	a5,8(sp)
800223f0:	c642                	sw	a6,12(sp)
800223f2:	c03e                	sw	a5,0(sp)
800223f4:	c242                	sw	a6,4(sp)

800223f6 <.L29>:
800223f6:	7ff00793          	li	a5,2047

800223fa <.L30>:
800223fa:	45a2                	lw	a1,8(sp)
800223fc:	4732                	lw	a4,12(sp)
800223fe:	80000637          	lui	a2,0x80000
80022402:	01c5d513          	srl	a0,a1,0x1c
80022406:	8e79                	and	a2,a2,a4
80022408:	0712                	sll	a4,a4,0x4
8002240a:	4692                	lw	a3,4(sp)
8002240c:	8f49                	or	a4,a4,a0
8002240e:	0732                	sll	a4,a4,0xc
80022410:	8331                	srl	a4,a4,0xc
80022412:	8e59                	or	a2,a2,a4
80022414:	82f1                	srl	a3,a3,0x1c
80022416:	0592                	sll	a1,a1,0x4
80022418:	07d2                	sll	a5,a5,0x14
8002241a:	00b6e733          	or	a4,a3,a1
8002241e:	8fd1                	or	a5,a5,a2
80022420:	bf45                	j	800223d0 <.L28>

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

80022422 <__SEGGER_RTL_float32_isnan>:
80022422:	ff0007b7          	lui	a5,0xff000
80022426:	0785                	add	a5,a5,1 # ff000001 <__APB_SRAM_segment_end__+0xaf0e001>
80022428:	0506                	sll	a0,a0,0x1
8002242a:	00f53533          	sltu	a0,a0,a5
8002242e:	00154513          	xor	a0,a0,1
80022432:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

80022434 <__SEGGER_RTL_float32_isinf>:
80022434:	010007b7          	lui	a5,0x1000
80022438:	0506                	sll	a0,a0,0x1
8002243a:	953e                	add	a0,a0,a5
8002243c:	00153513          	seqz	a0,a0
80022440:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

80022442 <__SEGGER_RTL_float32_isnormal>:
80022442:	ff0007b7          	lui	a5,0xff000
80022446:	0506                	sll	a0,a0,0x1
80022448:	953e                	add	a0,a0,a5
8002244a:	fe0007b7          	lui	a5,0xfe000
8002244e:	00f53533          	sltu	a0,a0,a5
80022452:	8082                	ret

Disassembly of section .text.libc.floorf:

80022454 <floorf>:
80022454:	00151693          	sll	a3,a0,0x1
80022458:	82e1                	srl	a3,a3,0x18
8002245a:	01755793          	srl	a5,a0,0x17
8002245e:	16fd                	add	a3,a3,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
80022460:	0fd00613          	li	a2,253
80022464:	872a                	mv	a4,a0
80022466:	0ff7f793          	zext.b	a5,a5
8002246a:	00d67963          	bgeu	a2,a3,8002247c <.L1240>
8002246e:	e789                	bnez	a5,80022478 <.L1241>
80022470:	800007b7          	lui	a5,0x80000
80022474:	00f57733          	and	a4,a0,a5

80022478 <.L1241>:
80022478:	853a                	mv	a0,a4
8002247a:	8082                	ret

8002247c <.L1240>:
8002247c:	f8178793          	add	a5,a5,-127 # 7fffff81 <__SHARE_RAM_segment_end__+0x7ee7ff81>
80022480:	0007d963          	bgez	a5,80022492 <.L1243>
80022484:	00000513          	li	a0,0
80022488:	02075863          	bgez	a4,800224b8 <.L1242>
8002248c:	1541a503          	lw	a0,340(gp) # 800209f8 <.Lmerged_single+0x18>
80022490:	8082                	ret

80022492 <.L1243>:
80022492:	46d9                	li	a3,22
80022494:	02f6c263          	blt	a3,a5,800224b8 <.L1242>
80022498:	008006b7          	lui	a3,0x800
8002249c:	fff68613          	add	a2,a3,-1 # 7fffff <__XPI0_segment_size__+0x1ffff>
800224a0:	00f65633          	srl	a2,a2,a5
800224a4:	fff64513          	not	a0,a2
800224a8:	8d79                	and	a0,a0,a4
800224aa:	8f71                	and	a4,a4,a2
800224ac:	c711                	beqz	a4,800224b8 <.L1242>
800224ae:	00055563          	bgez	a0,800224b8 <.L1242>
800224b2:	00f6d6b3          	srl	a3,a3,a5
800224b6:	9536                	add	a0,a0,a3

800224b8 <.L1242>:
800224b8:	8082                	ret

Disassembly of section .text.libc.__ashldi3:

800224ba <__ashldi3>:
800224ba:	02067793          	and	a5,a2,32
800224be:	ef89                	bnez	a5,800224d8 <.L__ashldi3LongShift>
800224c0:	00155793          	srl	a5,a0,0x1
800224c4:	fff64713          	not	a4,a2
800224c8:	00e7d7b3          	srl	a5,a5,a4
800224cc:	00c595b3          	sll	a1,a1,a2
800224d0:	8ddd                	or	a1,a1,a5
800224d2:	00c51533          	sll	a0,a0,a2
800224d6:	8082                	ret

800224d8 <.L__ashldi3LongShift>:
800224d8:	00c515b3          	sll	a1,a0,a2
800224dc:	4501                	li	a0,0
800224de:	8082                	ret

Disassembly of section .text.libc.__udivdi3:

800224e0 <__udivdi3>:
800224e0:	1101                	add	sp,sp,-32
800224e2:	cc22                	sw	s0,24(sp)
800224e4:	ca26                	sw	s1,20(sp)
800224e6:	c84a                	sw	s2,16(sp)
800224e8:	c64e                	sw	s3,12(sp)
800224ea:	ce06                	sw	ra,28(sp)
800224ec:	c452                	sw	s4,8(sp)
800224ee:	c256                	sw	s5,4(sp)
800224f0:	c05a                	sw	s6,0(sp)
800224f2:	842a                	mv	s0,a0
800224f4:	892e                	mv	s2,a1
800224f6:	89b2                	mv	s3,a2
800224f8:	84b6                	mv	s1,a3
800224fa:	2e069063          	bnez	a3,800227da <.L47>
800224fe:	ed99                	bnez	a1,8002251c <.L48>
80022500:	02c55433          	divu	s0,a0,a2

80022504 <.L49>:
80022504:	40f2                	lw	ra,28(sp)
80022506:	8522                	mv	a0,s0
80022508:	4462                	lw	s0,24(sp)
8002250a:	44d2                	lw	s1,20(sp)
8002250c:	49b2                	lw	s3,12(sp)
8002250e:	4a22                	lw	s4,8(sp)
80022510:	4a92                	lw	s5,4(sp)
80022512:	4b02                	lw	s6,0(sp)
80022514:	85ca                	mv	a1,s2
80022516:	4942                	lw	s2,16(sp)
80022518:	6105                	add	sp,sp,32
8002251a:	8082                	ret

8002251c <.L48>:
8002251c:	010007b7          	lui	a5,0x1000
80022520:	12f67863          	bgeu	a2,a5,80022650 <.L50>
80022524:	4791                	li	a5,4
80022526:	08c7e763          	bltu	a5,a2,800225b4 <.L52>
8002252a:	470d                	li	a4,3
8002252c:	02e60263          	beq	a2,a4,80022550 <.L54>
80022530:	06f60a63          	beq	a2,a5,800225a4 <.L55>
80022534:	4785                	li	a5,1
80022536:	fcf607e3          	beq	a2,a5,80022504 <.L49>
8002253a:	4789                	li	a5,2
8002253c:	3af61c63          	bne	a2,a5,800228f4 <.L88>
80022540:	01f59793          	sll	a5,a1,0x1f
80022544:	00155413          	srl	s0,a0,0x1
80022548:	8c5d                	or	s0,s0,a5
8002254a:	0015d913          	srl	s2,a1,0x1
8002254e:	bf5d                	j	80022504 <.L49>

80022550 <.L54>:
80022550:	555557b7          	lui	a5,0x55555
80022554:	55578793          	add	a5,a5,1365 # 55555555 <__SHARE_RAM_segment_end__+0x543d5555>
80022558:	02b7b6b3          	mulhu	a3,a5,a1
8002255c:	02a7b633          	mulhu	a2,a5,a0
80022560:	02a78733          	mul	a4,a5,a0
80022564:	02b787b3          	mul	a5,a5,a1
80022568:	97b2                	add	a5,a5,a2
8002256a:	00c7b633          	sltu	a2,a5,a2
8002256e:	9636                	add	a2,a2,a3
80022570:	00f706b3          	add	a3,a4,a5
80022574:	00e6b733          	sltu	a4,a3,a4
80022578:	9732                	add	a4,a4,a2
8002257a:	97ba                	add	a5,a5,a4
8002257c:	00e7b5b3          	sltu	a1,a5,a4
80022580:	9736                	add	a4,a4,a3
80022582:	00d736b3          	sltu	a3,a4,a3
80022586:	0705                	add	a4,a4,1
80022588:	97b6                	add	a5,a5,a3
8002258a:	00173713          	seqz	a4,a4
8002258e:	00d7b6b3          	sltu	a3,a5,a3
80022592:	962e                	add	a2,a2,a1
80022594:	97ba                	add	a5,a5,a4
80022596:	00c68933          	add	s2,a3,a2
8002259a:	00e7b733          	sltu	a4,a5,a4
8002259e:	843e                	mv	s0,a5
800225a0:	993a                	add	s2,s2,a4
800225a2:	b78d                	j	80022504 <.L49>

800225a4 <.L55>:
800225a4:	01e59793          	sll	a5,a1,0x1e
800225a8:	00255413          	srl	s0,a0,0x2
800225ac:	8c5d                	or	s0,s0,a5
800225ae:	0025d913          	srl	s2,a1,0x2
800225b2:	bf89                	j	80022504 <.L49>

800225b4 <.L52>:
800225b4:	67c1                	lui	a5,0x10
800225b6:	02c5d6b3          	divu	a3,a1,a2
800225ba:	01055713          	srl	a4,a0,0x10
800225be:	02f67a63          	bgeu	a2,a5,800225f2 <.L62>
800225c2:	01051413          	sll	s0,a0,0x10
800225c6:	8041                	srl	s0,s0,0x10
800225c8:	02c687b3          	mul	a5,a3,a2
800225cc:	40f587b3          	sub	a5,a1,a5
800225d0:	07c2                	sll	a5,a5,0x10
800225d2:	97ba                	add	a5,a5,a4
800225d4:	02c7d933          	divu	s2,a5,a2
800225d8:	02c90733          	mul	a4,s2,a2
800225dc:	0942                	sll	s2,s2,0x10
800225de:	8f99                	sub	a5,a5,a4
800225e0:	07c2                	sll	a5,a5,0x10
800225e2:	943e                	add	s0,s0,a5
800225e4:	02c45433          	divu	s0,s0,a2
800225e8:	944a                	add	s0,s0,s2
800225ea:	01243933          	sltu	s2,s0,s2
800225ee:	9936                	add	s2,s2,a3
800225f0:	bf11                	j	80022504 <.L49>

800225f2 <.L62>:
800225f2:	02c687b3          	mul	a5,a3,a2
800225f6:	01855613          	srl	a2,a0,0x18
800225fa:	0ff77713          	zext.b	a4,a4
800225fe:	0ff47413          	zext.b	s0,s0
80022602:	8936                	mv	s2,a3
80022604:	40f587b3          	sub	a5,a1,a5
80022608:	07a2                	sll	a5,a5,0x8
8002260a:	963e                	add	a2,a2,a5
8002260c:	033657b3          	divu	a5,a2,s3
80022610:	033785b3          	mul	a1,a5,s3
80022614:	07a2                	sll	a5,a5,0x8
80022616:	8e0d                	sub	a2,a2,a1
80022618:	0622                	sll	a2,a2,0x8
8002261a:	9732                	add	a4,a4,a2
8002261c:	033755b3          	divu	a1,a4,s3
80022620:	97ae                	add	a5,a5,a1
80022622:	07a2                	sll	a5,a5,0x8
80022624:	03358633          	mul	a2,a1,s3
80022628:	8f11                	sub	a4,a4,a2
8002262a:	00855613          	srl	a2,a0,0x8
8002262e:	0ff67613          	zext.b	a2,a2
80022632:	0722                	sll	a4,a4,0x8
80022634:	9732                	add	a4,a4,a2
80022636:	03375633          	divu	a2,a4,s3
8002263a:	97b2                	add	a5,a5,a2
8002263c:	07a2                	sll	a5,a5,0x8
8002263e:	03360533          	mul	a0,a2,s3
80022642:	8f09                	sub	a4,a4,a0
80022644:	0722                	sll	a4,a4,0x8
80022646:	943a                	add	s0,s0,a4
80022648:	03345433          	divu	s0,s0,s3
8002264c:	943e                	add	s0,s0,a5
8002264e:	bd5d                	j	80022504 <.L49>

80022650 <.L50>:
80022650:	b0818a93          	add	s5,gp,-1272 # 800203ac <__SEGGER_RTL_Moeller_inverse_lut>
80022654:	0cc5f063          	bgeu	a1,a2,80022714 <.L64>
80022658:	10000737          	lui	a4,0x10000
8002265c:	87b2                	mv	a5,a2
8002265e:	00e67563          	bgeu	a2,a4,80022668 <.L65>
80022662:	00461793          	sll	a5,a2,0x4
80022666:	4491                	li	s1,4

80022668 <.L65>:
80022668:	40000737          	lui	a4,0x40000
8002266c:	00e7f463          	bgeu	a5,a4,80022674 <.L66>
80022670:	0489                	add	s1,s1,2
80022672:	078a                	sll	a5,a5,0x2

80022674 <.L66>:
80022674:	0007c363          	bltz	a5,8002267a <.L67>
80022678:	0485                	add	s1,s1,1

8002267a <.L67>:
8002267a:	8626                	mv	a2,s1
8002267c:	8522                	mv	a0,s0
8002267e:	85ca                	mv	a1,s2
80022680:	3d2d                	jal	800224ba <__ashldi3>
80022682:	009994b3          	sll	s1,s3,s1
80022686:	0164d793          	srl	a5,s1,0x16
8002268a:	e0078793          	add	a5,a5,-512 # fe00 <__AHB_SRAM_segment_size__+0x7e00>
8002268e:	0786                	sll	a5,a5,0x1
80022690:	97d6                	add	a5,a5,s5
80022692:	0007d783          	lhu	a5,0(a5)
80022696:	00b4d813          	srl	a6,s1,0xb
8002269a:	0014f713          	and	a4,s1,1
8002269e:	02f78633          	mul	a2,a5,a5
800226a2:	0792                	sll	a5,a5,0x4
800226a4:	0014d693          	srl	a3,s1,0x1
800226a8:	0805                	add	a6,a6,1
800226aa:	03063633          	mulhu	a2,a2,a6
800226ae:	8f91                	sub	a5,a5,a2
800226b0:	96ba                	add	a3,a3,a4
800226b2:	17fd                	add	a5,a5,-1
800226b4:	c319                	beqz	a4,800226ba <.L68>
800226b6:	0017d713          	srl	a4,a5,0x1

800226ba <.L68>:
800226ba:	02f686b3          	mul	a3,a3,a5
800226be:	8f15                	sub	a4,a4,a3
800226c0:	02e7b733          	mulhu	a4,a5,a4
800226c4:	07be                	sll	a5,a5,0xf
800226c6:	8305                	srl	a4,a4,0x1
800226c8:	97ba                	add	a5,a5,a4
800226ca:	8726                	mv	a4,s1
800226cc:	029786b3          	mul	a3,a5,s1
800226d0:	9736                	add	a4,a4,a3
800226d2:	00d736b3          	sltu	a3,a4,a3
800226d6:	8726                	mv	a4,s1
800226d8:	9736                	add	a4,a4,a3
800226da:	0297b6b3          	mulhu	a3,a5,s1
800226de:	9736                	add	a4,a4,a3
800226e0:	8f99                	sub	a5,a5,a4
800226e2:	02b7b733          	mulhu	a4,a5,a1
800226e6:	02b787b3          	mul	a5,a5,a1
800226ea:	00a786b3          	add	a3,a5,a0
800226ee:	00f6b7b3          	sltu	a5,a3,a5
800226f2:	95be                	add	a1,a1,a5
800226f4:	00b707b3          	add	a5,a4,a1
800226f8:	00178413          	add	s0,a5,1
800226fc:	02848733          	mul	a4,s1,s0
80022700:	8d19                	sub	a0,a0,a4
80022702:	00a6f463          	bgeu	a3,a0,8002270a <.L69>
80022706:	9526                	add	a0,a0,s1
80022708:	843e                	mv	s0,a5

8002270a <.L69>:
8002270a:	00956363          	bltu	a0,s1,80022710 <.L109>
8002270e:	0405                	add	s0,s0,1

80022710 <.L109>:
80022710:	4901                	li	s2,0
80022712:	bbcd                	j	80022504 <.L49>

80022714 <.L64>:
80022714:	02c5da33          	divu	s4,a1,a2
80022718:	10000737          	lui	a4,0x10000
8002271c:	87b2                	mv	a5,a2
8002271e:	02ca05b3          	mul	a1,s4,a2
80022722:	40b905b3          	sub	a1,s2,a1
80022726:	00e67563          	bgeu	a2,a4,80022730 <.L71>
8002272a:	00461793          	sll	a5,a2,0x4
8002272e:	4491                	li	s1,4

80022730 <.L71>:
80022730:	40000737          	lui	a4,0x40000
80022734:	00e7f463          	bgeu	a5,a4,8002273c <.L72>
80022738:	0489                	add	s1,s1,2
8002273a:	078a                	sll	a5,a5,0x2

8002273c <.L72>:
8002273c:	0007c363          	bltz	a5,80022742 <.L73>
80022740:	0485                	add	s1,s1,1

80022742 <.L73>:
80022742:	8626                	mv	a2,s1
80022744:	8522                	mv	a0,s0
80022746:	3b95                	jal	800224ba <__ashldi3>
80022748:	009994b3          	sll	s1,s3,s1
8002274c:	0164d793          	srl	a5,s1,0x16
80022750:	e0078793          	add	a5,a5,-512
80022754:	0786                	sll	a5,a5,0x1
80022756:	9abe                	add	s5,s5,a5
80022758:	000ad783          	lhu	a5,0(s5)
8002275c:	00b4d813          	srl	a6,s1,0xb
80022760:	0014f713          	and	a4,s1,1
80022764:	02f78633          	mul	a2,a5,a5
80022768:	0792                	sll	a5,a5,0x4
8002276a:	0014d693          	srl	a3,s1,0x1
8002276e:	0805                	add	a6,a6,1
80022770:	03063633          	mulhu	a2,a2,a6
80022774:	8f91                	sub	a5,a5,a2
80022776:	96ba                	add	a3,a3,a4
80022778:	17fd                	add	a5,a5,-1
8002277a:	c319                	beqz	a4,80022780 <.L74>
8002277c:	0017d713          	srl	a4,a5,0x1

80022780 <.L74>:
80022780:	02f686b3          	mul	a3,a3,a5
80022784:	8f15                	sub	a4,a4,a3
80022786:	02e7b733          	mulhu	a4,a5,a4
8002278a:	07be                	sll	a5,a5,0xf
8002278c:	8305                	srl	a4,a4,0x1
8002278e:	97ba                	add	a5,a5,a4
80022790:	8726                	mv	a4,s1
80022792:	029786b3          	mul	a3,a5,s1
80022796:	9736                	add	a4,a4,a3
80022798:	00d736b3          	sltu	a3,a4,a3
8002279c:	8726                	mv	a4,s1
8002279e:	9736                	add	a4,a4,a3
800227a0:	0297b6b3          	mulhu	a3,a5,s1
800227a4:	9736                	add	a4,a4,a3
800227a6:	8f99                	sub	a5,a5,a4
800227a8:	02b7b733          	mulhu	a4,a5,a1
800227ac:	02b787b3          	mul	a5,a5,a1
800227b0:	00a786b3          	add	a3,a5,a0
800227b4:	00f6b7b3          	sltu	a5,a3,a5
800227b8:	95be                	add	a1,a1,a5
800227ba:	00b707b3          	add	a5,a4,a1
800227be:	00178413          	add	s0,a5,1
800227c2:	02848733          	mul	a4,s1,s0
800227c6:	8d19                	sub	a0,a0,a4
800227c8:	00a6f463          	bgeu	a3,a0,800227d0 <.L75>
800227cc:	9526                	add	a0,a0,s1
800227ce:	843e                	mv	s0,a5

800227d0 <.L75>:
800227d0:	00956363          	bltu	a0,s1,800227d6 <.L76>
800227d4:	0405                	add	s0,s0,1

800227d6 <.L76>:
800227d6:	8952                	mv	s2,s4
800227d8:	b335                	j	80022504 <.L49>

800227da <.L47>:
800227da:	67c1                	lui	a5,0x10
800227dc:	8ab6                	mv	s5,a3
800227de:	4a01                	li	s4,0
800227e0:	00f6f563          	bgeu	a3,a5,800227ea <.L77>
800227e4:	01069493          	sll	s1,a3,0x10
800227e8:	4a41                	li	s4,16

800227ea <.L77>:
800227ea:	010007b7          	lui	a5,0x1000
800227ee:	00f4f463          	bgeu	s1,a5,800227f6 <.L78>
800227f2:	0a21                	add	s4,s4,8
800227f4:	04a2                	sll	s1,s1,0x8

800227f6 <.L78>:
800227f6:	100007b7          	lui	a5,0x10000
800227fa:	00f4f463          	bgeu	s1,a5,80022802 <.L79>
800227fe:	0a11                	add	s4,s4,4
80022800:	0492                	sll	s1,s1,0x4

80022802 <.L79>:
80022802:	400007b7          	lui	a5,0x40000
80022806:	00f4f463          	bgeu	s1,a5,8002280e <.L80>
8002280a:	0a09                	add	s4,s4,2
8002280c:	048a                	sll	s1,s1,0x2

8002280e <.L80>:
8002280e:	0004c363          	bltz	s1,80022814 <.L81>
80022812:	0a05                	add	s4,s4,1

80022814 <.L81>:
80022814:	01f91793          	sll	a5,s2,0x1f
80022818:	8652                	mv	a2,s4
8002281a:	00145493          	srl	s1,s0,0x1
8002281e:	854e                	mv	a0,s3
80022820:	85d6                	mv	a1,s5
80022822:	8cdd                	or	s1,s1,a5
80022824:	3959                	jal	800224ba <__ashldi3>
80022826:	0165d613          	srl	a2,a1,0x16
8002282a:	e0060613          	add	a2,a2,-512 # 7ffffe00 <__SHARE_RAM_segment_end__+0x7ee7fe00>
8002282e:	0606                	sll	a2,a2,0x1
80022830:	b0818793          	add	a5,gp,-1272 # 800203ac <__SEGGER_RTL_Moeller_inverse_lut>
80022834:	97b2                	add	a5,a5,a2
80022836:	0007d783          	lhu	a5,0(a5) # 40000000 <__SHARE_RAM_segment_end__+0x3ee80000>
8002283a:	00b5d513          	srl	a0,a1,0xb
8002283e:	0015f713          	and	a4,a1,1
80022842:	02f78633          	mul	a2,a5,a5
80022846:	0792                	sll	a5,a5,0x4
80022848:	0015d693          	srl	a3,a1,0x1
8002284c:	0505                	add	a0,a0,1 # 7f800001 <__SHARE_RAM_segment_end__+0x7e680001>
8002284e:	02a63633          	mulhu	a2,a2,a0
80022852:	8f91                	sub	a5,a5,a2
80022854:	00195b13          	srl	s6,s2,0x1
80022858:	96ba                	add	a3,a3,a4
8002285a:	17fd                	add	a5,a5,-1
8002285c:	c319                	beqz	a4,80022862 <.L82>
8002285e:	0017d713          	srl	a4,a5,0x1

80022862 <.L82>:
80022862:	02f686b3          	mul	a3,a3,a5
80022866:	8f15                	sub	a4,a4,a3
80022868:	02e7b733          	mulhu	a4,a5,a4
8002286c:	07be                	sll	a5,a5,0xf
8002286e:	8305                	srl	a4,a4,0x1
80022870:	97ba                	add	a5,a5,a4
80022872:	872e                	mv	a4,a1
80022874:	02b786b3          	mul	a3,a5,a1
80022878:	9736                	add	a4,a4,a3
8002287a:	00d736b3          	sltu	a3,a4,a3
8002287e:	872e                	mv	a4,a1
80022880:	9736                	add	a4,a4,a3
80022882:	02b7b6b3          	mulhu	a3,a5,a1
80022886:	9736                	add	a4,a4,a3
80022888:	8f99                	sub	a5,a5,a4
8002288a:	0367b733          	mulhu	a4,a5,s6
8002288e:	036787b3          	mul	a5,a5,s6
80022892:	009786b3          	add	a3,a5,s1
80022896:	00f6b7b3          	sltu	a5,a3,a5
8002289a:	97da                	add	a5,a5,s6
8002289c:	973e                	add	a4,a4,a5
8002289e:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
800228a2:	02f58633          	mul	a2,a1,a5
800228a6:	8c91                	sub	s1,s1,a2
800228a8:	0096f463          	bgeu	a3,s1,800228b0 <.L83>
800228ac:	94ae                	add	s1,s1,a1
800228ae:	87ba                	mv	a5,a4

800228b0 <.L83>:
800228b0:	00b4e363          	bltu	s1,a1,800228b6 <.L84>
800228b4:	0785                	add	a5,a5,1

800228b6 <.L84>:
800228b6:	477d                	li	a4,31
800228b8:	41470733          	sub	a4,a4,s4
800228bc:	00e7d633          	srl	a2,a5,a4
800228c0:	c211                	beqz	a2,800228c4 <.L85>
800228c2:	167d                	add	a2,a2,-1

800228c4 <.L85>:
800228c4:	02ca87b3          	mul	a5,s5,a2
800228c8:	03360733          	mul	a4,a2,s3
800228cc:	033636b3          	mulhu	a3,a2,s3
800228d0:	40e40733          	sub	a4,s0,a4
800228d4:	00e43433          	sltu	s0,s0,a4
800228d8:	97b6                	add	a5,a5,a3
800228da:	40f907b3          	sub	a5,s2,a5
800228de:	40878433          	sub	s0,a5,s0
800228e2:	01546763          	bltu	s0,s5,800228f0 <.L86>
800228e6:	008a9463          	bne	s5,s0,800228ee <.L95>
800228ea:	01376363          	bltu	a4,s3,800228f0 <.L86>

800228ee <.L95>:
800228ee:	0605                	add	a2,a2,1

800228f0 <.L86>:
800228f0:	8432                	mv	s0,a2
800228f2:	bd39                	j	80022710 <.L109>

800228f4 <.L88>:
800228f4:	4401                	li	s0,0
800228f6:	bd29                	j	80022710 <.L109>

Disassembly of section .text.libc.__umoddi3:

800228f8 <__umoddi3>:
800228f8:	1101                	add	sp,sp,-32
800228fa:	cc22                	sw	s0,24(sp)
800228fc:	ca26                	sw	s1,20(sp)
800228fe:	c84a                	sw	s2,16(sp)
80022900:	c64e                	sw	s3,12(sp)
80022902:	c452                	sw	s4,8(sp)
80022904:	ce06                	sw	ra,28(sp)
80022906:	c256                	sw	s5,4(sp)
80022908:	c05a                	sw	s6,0(sp)
8002290a:	892a                	mv	s2,a0
8002290c:	84ae                	mv	s1,a1
8002290e:	8432                	mv	s0,a2
80022910:	89b6                	mv	s3,a3
80022912:	8a36                	mv	s4,a3
80022914:	2e069c63          	bnez	a3,80022c0c <.L111>
80022918:	e589                	bnez	a1,80022922 <.L112>
8002291a:	02c557b3          	divu	a5,a0,a2

8002291e <.L174>:
8002291e:	4701                	li	a4,0
80022920:	a815                	j	80022954 <.L113>

80022922 <.L112>:
80022922:	010007b7          	lui	a5,0x1000
80022926:	16f67163          	bgeu	a2,a5,80022a88 <.L114>
8002292a:	4791                	li	a5,4
8002292c:	0cc7e063          	bltu	a5,a2,800229ec <.L116>
80022930:	470d                	li	a4,3
80022932:	04e60d63          	beq	a2,a4,8002298c <.L118>
80022936:	0af60363          	beq	a2,a5,800229dc <.L119>
8002293a:	4785                	li	a5,1
8002293c:	3ef60363          	beq	a2,a5,80022d22 <.L152>
80022940:	4789                	li	a5,2
80022942:	3ef61363          	bne	a2,a5,80022d28 <.L153>
80022946:	01f59713          	sll	a4,a1,0x1f
8002294a:	00155793          	srl	a5,a0,0x1
8002294e:	8fd9                	or	a5,a5,a4
80022950:	0015d713          	srl	a4,a1,0x1

80022954 <.L113>:
80022954:	02870733          	mul	a4,a4,s0
80022958:	40f2                	lw	ra,28(sp)
8002295a:	4a22                	lw	s4,8(sp)
8002295c:	4a92                	lw	s5,4(sp)
8002295e:	4b02                	lw	s6,0(sp)
80022960:	02f989b3          	mul	s3,s3,a5
80022964:	02f40533          	mul	a0,s0,a5
80022968:	99ba                	add	s3,s3,a4
8002296a:	02f43433          	mulhu	s0,s0,a5
8002296e:	40a90533          	sub	a0,s2,a0
80022972:	00a935b3          	sltu	a1,s2,a0
80022976:	4942                	lw	s2,16(sp)
80022978:	99a2                	add	s3,s3,s0
8002297a:	4462                	lw	s0,24(sp)
8002297c:	413484b3          	sub	s1,s1,s3
80022980:	40b485b3          	sub	a1,s1,a1
80022984:	49b2                	lw	s3,12(sp)
80022986:	44d2                	lw	s1,20(sp)
80022988:	6105                	add	sp,sp,32
8002298a:	8082                	ret

8002298c <.L118>:
8002298c:	555557b7          	lui	a5,0x55555
80022990:	55578793          	add	a5,a5,1365 # 55555555 <__SHARE_RAM_segment_end__+0x543d5555>
80022994:	02b7b6b3          	mulhu	a3,a5,a1
80022998:	02a7b633          	mulhu	a2,a5,a0
8002299c:	02a78733          	mul	a4,a5,a0
800229a0:	02b787b3          	mul	a5,a5,a1
800229a4:	97b2                	add	a5,a5,a2
800229a6:	00c7b633          	sltu	a2,a5,a2
800229aa:	9636                	add	a2,a2,a3
800229ac:	00f706b3          	add	a3,a4,a5
800229b0:	00e6b733          	sltu	a4,a3,a4
800229b4:	9732                	add	a4,a4,a2
800229b6:	97ba                	add	a5,a5,a4
800229b8:	00e7b5b3          	sltu	a1,a5,a4
800229bc:	9736                	add	a4,a4,a3
800229be:	00d736b3          	sltu	a3,a4,a3
800229c2:	0705                	add	a4,a4,1
800229c4:	97b6                	add	a5,a5,a3
800229c6:	00173713          	seqz	a4,a4
800229ca:	00d7b6b3          	sltu	a3,a5,a3
800229ce:	962e                	add	a2,a2,a1
800229d0:	97ba                	add	a5,a5,a4
800229d2:	96b2                	add	a3,a3,a2
800229d4:	00e7b733          	sltu	a4,a5,a4
800229d8:	9736                	add	a4,a4,a3
800229da:	bfad                	j	80022954 <.L113>

800229dc <.L119>:
800229dc:	01e59713          	sll	a4,a1,0x1e
800229e0:	00255793          	srl	a5,a0,0x2
800229e4:	8fd9                	or	a5,a5,a4
800229e6:	0025d713          	srl	a4,a1,0x2
800229ea:	b7ad                	j	80022954 <.L113>

800229ec <.L116>:
800229ec:	67c1                	lui	a5,0x10
800229ee:	02c5d733          	divu	a4,a1,a2
800229f2:	01055693          	srl	a3,a0,0x10
800229f6:	02f67b63          	bgeu	a2,a5,80022a2c <.L126>
800229fa:	02c707b3          	mul	a5,a4,a2
800229fe:	40f587b3          	sub	a5,a1,a5
80022a02:	07c2                	sll	a5,a5,0x10
80022a04:	97b6                	add	a5,a5,a3
80022a06:	02c7d633          	divu	a2,a5,a2
80022a0a:	028606b3          	mul	a3,a2,s0
80022a0e:	0642                	sll	a2,a2,0x10
80022a10:	8f95                	sub	a5,a5,a3
80022a12:	01079693          	sll	a3,a5,0x10
80022a16:	01051793          	sll	a5,a0,0x10
80022a1a:	83c1                	srl	a5,a5,0x10
80022a1c:	97b6                	add	a5,a5,a3
80022a1e:	0287d7b3          	divu	a5,a5,s0
80022a22:	97b2                	add	a5,a5,a2
80022a24:	00c7b633          	sltu	a2,a5,a2
80022a28:	9732                	add	a4,a4,a2
80022a2a:	b72d                	j	80022954 <.L113>

80022a2c <.L126>:
80022a2c:	02c707b3          	mul	a5,a4,a2
80022a30:	01855613          	srl	a2,a0,0x18
80022a34:	0ff6f693          	zext.b	a3,a3
80022a38:	40f587b3          	sub	a5,a1,a5
80022a3c:	07a2                	sll	a5,a5,0x8
80022a3e:	963e                	add	a2,a2,a5
80022a40:	028657b3          	divu	a5,a2,s0
80022a44:	028785b3          	mul	a1,a5,s0
80022a48:	07a2                	sll	a5,a5,0x8
80022a4a:	8e0d                	sub	a2,a2,a1
80022a4c:	0622                	sll	a2,a2,0x8
80022a4e:	96b2                	add	a3,a3,a2
80022a50:	0286d5b3          	divu	a1,a3,s0
80022a54:	97ae                	add	a5,a5,a1
80022a56:	07a2                	sll	a5,a5,0x8
80022a58:	02858633          	mul	a2,a1,s0
80022a5c:	8e91                	sub	a3,a3,a2
80022a5e:	00855613          	srl	a2,a0,0x8
80022a62:	0ff67613          	zext.b	a2,a2
80022a66:	06a2                	sll	a3,a3,0x8
80022a68:	96b2                	add	a3,a3,a2
80022a6a:	0286d633          	divu	a2,a3,s0
80022a6e:	97b2                	add	a5,a5,a2
80022a70:	07a2                	sll	a5,a5,0x8
80022a72:	02860533          	mul	a0,a2,s0
80022a76:	0ff97613          	zext.b	a2,s2
80022a7a:	8e89                	sub	a3,a3,a0
80022a7c:	06a2                	sll	a3,a3,0x8
80022a7e:	96b2                	add	a3,a3,a2
80022a80:	0286d6b3          	divu	a3,a3,s0
80022a84:	97b6                	add	a5,a5,a3
80022a86:	b5f9                	j	80022954 <.L113>

80022a88 <.L114>:
80022a88:	b0818b13          	add	s6,gp,-1272 # 800203ac <__SEGGER_RTL_Moeller_inverse_lut>
80022a8c:	0ac5fe63          	bgeu	a1,a2,80022b48 <.L128>
80022a90:	10000737          	lui	a4,0x10000
80022a94:	87b2                	mv	a5,a2
80022a96:	00e67563          	bgeu	a2,a4,80022aa0 <.L129>
80022a9a:	00461793          	sll	a5,a2,0x4
80022a9e:	4a11                	li	s4,4

80022aa0 <.L129>:
80022aa0:	40000737          	lui	a4,0x40000
80022aa4:	00e7f463          	bgeu	a5,a4,80022aac <.L130>
80022aa8:	0a09                	add	s4,s4,2
80022aaa:	078a                	sll	a5,a5,0x2

80022aac <.L130>:
80022aac:	0007c363          	bltz	a5,80022ab2 <.L131>
80022ab0:	0a05                	add	s4,s4,1

80022ab2 <.L131>:
80022ab2:	8652                	mv	a2,s4
80022ab4:	854a                	mv	a0,s2
80022ab6:	85a6                	mv	a1,s1
80022ab8:	3409                	jal	800224ba <__ashldi3>
80022aba:	01441a33          	sll	s4,s0,s4
80022abe:	016a5793          	srl	a5,s4,0x16
80022ac2:	e0078793          	add	a5,a5,-512 # fe00 <__AHB_SRAM_segment_size__+0x7e00>
80022ac6:	0786                	sll	a5,a5,0x1
80022ac8:	97da                	add	a5,a5,s6
80022aca:	0007d783          	lhu	a5,0(a5)
80022ace:	00ba5813          	srl	a6,s4,0xb
80022ad2:	001a7713          	and	a4,s4,1
80022ad6:	02f78633          	mul	a2,a5,a5
80022ada:	0792                	sll	a5,a5,0x4
80022adc:	001a5693          	srl	a3,s4,0x1
80022ae0:	0805                	add	a6,a6,1
80022ae2:	03063633          	mulhu	a2,a2,a6
80022ae6:	8f91                	sub	a5,a5,a2
80022ae8:	96ba                	add	a3,a3,a4
80022aea:	17fd                	add	a5,a5,-1
80022aec:	c319                	beqz	a4,80022af2 <.L132>
80022aee:	0017d713          	srl	a4,a5,0x1

80022af2 <.L132>:
80022af2:	02f686b3          	mul	a3,a3,a5
80022af6:	8f15                	sub	a4,a4,a3
80022af8:	02e7b733          	mulhu	a4,a5,a4
80022afc:	07be                	sll	a5,a5,0xf
80022afe:	8305                	srl	a4,a4,0x1
80022b00:	97ba                	add	a5,a5,a4
80022b02:	8752                	mv	a4,s4
80022b04:	034786b3          	mul	a3,a5,s4
80022b08:	9736                	add	a4,a4,a3
80022b0a:	00d736b3          	sltu	a3,a4,a3
80022b0e:	8752                	mv	a4,s4
80022b10:	9736                	add	a4,a4,a3
80022b12:	0347b6b3          	mulhu	a3,a5,s4
80022b16:	9736                	add	a4,a4,a3
80022b18:	8f99                	sub	a5,a5,a4
80022b1a:	02b7b733          	mulhu	a4,a5,a1
80022b1e:	02b787b3          	mul	a5,a5,a1
80022b22:	00a786b3          	add	a3,a5,a0
80022b26:	00f6b7b3          	sltu	a5,a3,a5
80022b2a:	95be                	add	a1,a1,a5
80022b2c:	972e                	add	a4,a4,a1
80022b2e:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
80022b32:	02fa0633          	mul	a2,s4,a5
80022b36:	8d11                	sub	a0,a0,a2
80022b38:	00a6f463          	bgeu	a3,a0,80022b40 <.L133>
80022b3c:	9552                	add	a0,a0,s4
80022b3e:	87ba                	mv	a5,a4

80022b40 <.L133>:
80022b40:	dd456fe3          	bltu	a0,s4,8002291e <.L174>

80022b44 <.L160>:
80022b44:	0785                	add	a5,a5,1
80022b46:	bbe1                	j	8002291e <.L174>

80022b48 <.L128>:
80022b48:	02c5dab3          	divu	s5,a1,a2
80022b4c:	10000737          	lui	a4,0x10000
80022b50:	87b2                	mv	a5,a2
80022b52:	02ca85b3          	mul	a1,s5,a2
80022b56:	40b485b3          	sub	a1,s1,a1
80022b5a:	00e67563          	bgeu	a2,a4,80022b64 <.L135>
80022b5e:	00461793          	sll	a5,a2,0x4
80022b62:	4a11                	li	s4,4

80022b64 <.L135>:
80022b64:	40000737          	lui	a4,0x40000
80022b68:	00e7f463          	bgeu	a5,a4,80022b70 <.L136>
80022b6c:	0a09                	add	s4,s4,2
80022b6e:	078a                	sll	a5,a5,0x2

80022b70 <.L136>:
80022b70:	0007c363          	bltz	a5,80022b76 <.L137>
80022b74:	0a05                	add	s4,s4,1

80022b76 <.L137>:
80022b76:	8652                	mv	a2,s4
80022b78:	854a                	mv	a0,s2
80022b7a:	3281                	jal	800224ba <__ashldi3>
80022b7c:	01441a33          	sll	s4,s0,s4
80022b80:	016a5793          	srl	a5,s4,0x16
80022b84:	e0078793          	add	a5,a5,-512
80022b88:	0786                	sll	a5,a5,0x1
80022b8a:	9b3e                	add	s6,s6,a5
80022b8c:	000b5783          	lhu	a5,0(s6)
80022b90:	00ba5813          	srl	a6,s4,0xb
80022b94:	001a7713          	and	a4,s4,1
80022b98:	02f78633          	mul	a2,a5,a5
80022b9c:	0792                	sll	a5,a5,0x4
80022b9e:	001a5693          	srl	a3,s4,0x1
80022ba2:	0805                	add	a6,a6,1
80022ba4:	03063633          	mulhu	a2,a2,a6
80022ba8:	8f91                	sub	a5,a5,a2
80022baa:	96ba                	add	a3,a3,a4
80022bac:	17fd                	add	a5,a5,-1
80022bae:	c319                	beqz	a4,80022bb4 <.L138>
80022bb0:	0017d713          	srl	a4,a5,0x1

80022bb4 <.L138>:
80022bb4:	02f686b3          	mul	a3,a3,a5
80022bb8:	8f15                	sub	a4,a4,a3
80022bba:	02e7b733          	mulhu	a4,a5,a4
80022bbe:	07be                	sll	a5,a5,0xf
80022bc0:	8305                	srl	a4,a4,0x1
80022bc2:	97ba                	add	a5,a5,a4
80022bc4:	8752                	mv	a4,s4
80022bc6:	034786b3          	mul	a3,a5,s4
80022bca:	9736                	add	a4,a4,a3
80022bcc:	00d736b3          	sltu	a3,a4,a3
80022bd0:	8752                	mv	a4,s4
80022bd2:	9736                	add	a4,a4,a3
80022bd4:	0347b6b3          	mulhu	a3,a5,s4
80022bd8:	9736                	add	a4,a4,a3
80022bda:	8f99                	sub	a5,a5,a4
80022bdc:	02b7b733          	mulhu	a4,a5,a1
80022be0:	02b787b3          	mul	a5,a5,a1
80022be4:	00a786b3          	add	a3,a5,a0
80022be8:	00f6b7b3          	sltu	a5,a3,a5
80022bec:	95be                	add	a1,a1,a5
80022bee:	972e                	add	a4,a4,a1
80022bf0:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
80022bf4:	02fa0633          	mul	a2,s4,a5
80022bf8:	8d11                	sub	a0,a0,a2
80022bfa:	00a6f463          	bgeu	a3,a0,80022c02 <.L139>
80022bfe:	9552                	add	a0,a0,s4
80022c00:	87ba                	mv	a5,a4

80022c02 <.L139>:
80022c02:	01456363          	bltu	a0,s4,80022c08 <.L140>
80022c06:	0785                	add	a5,a5,1

80022c08 <.L140>:
80022c08:	8756                	mv	a4,s5
80022c0a:	b3a9                	j	80022954 <.L113>

80022c0c <.L111>:
80022c0c:	67c1                	lui	a5,0x10
80022c0e:	4a81                	li	s5,0
80022c10:	00f6f563          	bgeu	a3,a5,80022c1a <.L141>
80022c14:	01069a13          	sll	s4,a3,0x10
80022c18:	4ac1                	li	s5,16

80022c1a <.L141>:
80022c1a:	010007b7          	lui	a5,0x1000
80022c1e:	00fa7463          	bgeu	s4,a5,80022c26 <.L142>
80022c22:	0aa1                	add	s5,s5,8
80022c24:	0a22                	sll	s4,s4,0x8

80022c26 <.L142>:
80022c26:	100007b7          	lui	a5,0x10000
80022c2a:	00fa7463          	bgeu	s4,a5,80022c32 <.L143>
80022c2e:	0a91                	add	s5,s5,4
80022c30:	0a12                	sll	s4,s4,0x4

80022c32 <.L143>:
80022c32:	400007b7          	lui	a5,0x40000
80022c36:	00fa7463          	bgeu	s4,a5,80022c3e <.L144>
80022c3a:	0a89                	add	s5,s5,2
80022c3c:	0a0a                	sll	s4,s4,0x2

80022c3e <.L144>:
80022c3e:	000a4363          	bltz	s4,80022c44 <.L145>
80022c42:	0a85                	add	s5,s5,1

80022c44 <.L145>:
80022c44:	01f49793          	sll	a5,s1,0x1f
80022c48:	8656                	mv	a2,s5
80022c4a:	00195a13          	srl	s4,s2,0x1
80022c4e:	8522                	mv	a0,s0
80022c50:	85ce                	mv	a1,s3
80022c52:	0147ea33          	or	s4,a5,s4
80022c56:	3095                	jal	800224ba <__ashldi3>
80022c58:	0165d613          	srl	a2,a1,0x16
80022c5c:	e0060613          	add	a2,a2,-512
80022c60:	0606                	sll	a2,a2,0x1
80022c62:	b0818793          	add	a5,gp,-1272 # 800203ac <__SEGGER_RTL_Moeller_inverse_lut>
80022c66:	97b2                	add	a5,a5,a2
80022c68:	0007d783          	lhu	a5,0(a5) # 40000000 <__SHARE_RAM_segment_end__+0x3ee80000>
80022c6c:	00b5d513          	srl	a0,a1,0xb
80022c70:	0015f713          	and	a4,a1,1
80022c74:	02f78633          	mul	a2,a5,a5
80022c78:	0792                	sll	a5,a5,0x4
80022c7a:	0015d693          	srl	a3,a1,0x1
80022c7e:	0505                	add	a0,a0,1
80022c80:	02a63633          	mulhu	a2,a2,a0
80022c84:	8f91                	sub	a5,a5,a2
80022c86:	0014db13          	srl	s6,s1,0x1
80022c8a:	96ba                	add	a3,a3,a4
80022c8c:	17fd                	add	a5,a5,-1
80022c8e:	c319                	beqz	a4,80022c94 <.L146>
80022c90:	0017d713          	srl	a4,a5,0x1

80022c94 <.L146>:
80022c94:	02f686b3          	mul	a3,a3,a5
80022c98:	8f15                	sub	a4,a4,a3
80022c9a:	02e7b733          	mulhu	a4,a5,a4
80022c9e:	07be                	sll	a5,a5,0xf
80022ca0:	8305                	srl	a4,a4,0x1
80022ca2:	97ba                	add	a5,a5,a4
80022ca4:	872e                	mv	a4,a1
80022ca6:	02b786b3          	mul	a3,a5,a1
80022caa:	9736                	add	a4,a4,a3
80022cac:	00d736b3          	sltu	a3,a4,a3
80022cb0:	872e                	mv	a4,a1
80022cb2:	9736                	add	a4,a4,a3
80022cb4:	02b7b6b3          	mulhu	a3,a5,a1
80022cb8:	9736                	add	a4,a4,a3
80022cba:	8f99                	sub	a5,a5,a4
80022cbc:	0367b733          	mulhu	a4,a5,s6
80022cc0:	036787b3          	mul	a5,a5,s6
80022cc4:	014786b3          	add	a3,a5,s4
80022cc8:	00f6b7b3          	sltu	a5,a3,a5
80022ccc:	97da                	add	a5,a5,s6
80022cce:	973e                	add	a4,a4,a5
80022cd0:	00170793          	add	a5,a4,1
80022cd4:	02f58633          	mul	a2,a1,a5
80022cd8:	40ca0a33          	sub	s4,s4,a2
80022cdc:	0146f463          	bgeu	a3,s4,80022ce4 <.L147>
80022ce0:	9a2e                	add	s4,s4,a1
80022ce2:	87ba                	mv	a5,a4

80022ce4 <.L147>:
80022ce4:	00ba6363          	bltu	s4,a1,80022cea <.L148>
80022ce8:	0785                	add	a5,a5,1

80022cea <.L148>:
80022cea:	477d                	li	a4,31
80022cec:	41570733          	sub	a4,a4,s5
80022cf0:	00e7d7b3          	srl	a5,a5,a4
80022cf4:	c391                	beqz	a5,80022cf8 <.L149>
80022cf6:	17fd                	add	a5,a5,-1

80022cf8 <.L149>:
80022cf8:	0287b633          	mulhu	a2,a5,s0
80022cfc:	02f98733          	mul	a4,s3,a5
80022d00:	028786b3          	mul	a3,a5,s0
80022d04:	9732                	add	a4,a4,a2
80022d06:	40e48733          	sub	a4,s1,a4
80022d0a:	40d906b3          	sub	a3,s2,a3
80022d0e:	00d93633          	sltu	a2,s2,a3
80022d12:	8f11                	sub	a4,a4,a2
80022d14:	c13765e3          	bltu	a4,s3,8002291e <.L174>
80022d18:	e2e996e3          	bne	s3,a4,80022b44 <.L160>
80022d1c:	c086e1e3          	bltu	a3,s0,8002291e <.L174>
80022d20:	b515                	j	80022b44 <.L160>

80022d22 <.L152>:
80022d22:	87aa                	mv	a5,a0
80022d24:	872e                	mv	a4,a1
80022d26:	b13d                	j	80022954 <.L113>

80022d28 <.L153>:
80022d28:	4781                	li	a5,0
80022d2a:	bed5                	j	8002291e <.L174>

Disassembly of section .text.libc.abs:

80022d2c <abs>:
80022d2c:	41f55793          	sra	a5,a0,0x1f
80022d30:	8d3d                	xor	a0,a0,a5
80022d32:	8d1d                	sub	a0,a0,a5
80022d34:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

80022d36 <__SEGGER_RTL_pow10f>:
80022d36:	1101                	add	sp,sp,-32
80022d38:	cc22                	sw	s0,24(sp)
80022d3a:	c64e                	sw	s3,12(sp)
80022d3c:	ce06                	sw	ra,28(sp)
80022d3e:	ca26                	sw	s1,20(sp)
80022d40:	c84a                	sw	s2,16(sp)
80022d42:	842a                	mv	s0,a0
80022d44:	4981                	li	s3,0
80022d46:	00055563          	bgez	a0,80022d50 <.L17>
80022d4a:	40a00433          	neg	s0,a0
80022d4e:	4985                	li	s3,1

80022d50 <.L17>:
80022d50:	1401a503          	lw	a0,320(gp) # 800209e4 <.Lmerged_single+0x4>
80022d54:	f0818493          	add	s1,gp,-248 # 800207ac <__SEGGER_RTL_aPower2f>

80022d58 <.L18>:
80022d58:	ec19                	bnez	s0,80022d76 <.L20>
80022d5a:	00098763          	beqz	s3,80022d68 <.L16>
80022d5e:	85aa                	mv	a1,a0
80022d60:	1401a503          	lw	a0,320(gp) # 800209e4 <.Lmerged_single+0x4>
80022d64:	576010ef          	jal	800242da <__divsf3>

80022d68 <.L16>:
80022d68:	40f2                	lw	ra,28(sp)
80022d6a:	4462                	lw	s0,24(sp)
80022d6c:	44d2                	lw	s1,20(sp)
80022d6e:	4942                	lw	s2,16(sp)
80022d70:	49b2                	lw	s3,12(sp)
80022d72:	6105                	add	sp,sp,32
80022d74:	8082                	ret

80022d76 <.L20>:
80022d76:	00147793          	and	a5,s0,1
80022d7a:	c781                	beqz	a5,80022d82 <.L19>
80022d7c:	408c                	lw	a1,0(s1)
80022d7e:	39c010ef          	jal	8002411a <__mulsf3>

80022d82 <.L19>:
80022d82:	8405                	sra	s0,s0,0x1
80022d84:	0491                	add	s1,s1,4
80022d86:	bfc9                	j	80022d58 <.L18>

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80022d88 <__SEGGER_RTL_prin_flush>:
80022d88:	4950                	lw	a2,20(a0)
80022d8a:	ce19                	beqz	a2,80022da8 <.L20>
80022d8c:	511c                	lw	a5,32(a0)
80022d8e:	1141                	add	sp,sp,-16
80022d90:	c422                	sw	s0,8(sp)
80022d92:	c606                	sw	ra,12(sp)
80022d94:	842a                	mv	s0,a0
80022d96:	c399                	beqz	a5,80022d9c <.L12>
80022d98:	490c                	lw	a1,16(a0)
80022d9a:	9782                	jalr	a5

80022d9c <.L12>:
80022d9c:	40b2                	lw	ra,12(sp)
80022d9e:	00042a23          	sw	zero,20(s0)
80022da2:	4422                	lw	s0,8(sp)
80022da4:	0141                	add	sp,sp,16
80022da6:	8082                	ret

80022da8 <.L20>:
80022da8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80022daa <__SEGGER_RTL_pre_padding>:
80022daa:	0105f793          	and	a5,a1,16
80022dae:	eb91                	bnez	a5,80022dc2 <.L40>
80022db0:	2005f793          	and	a5,a1,512
80022db4:	02000593          	li	a1,32
80022db8:	c399                	beqz	a5,80022dbe <.L42>
80022dba:	03000593          	li	a1,48

80022dbe <.L42>:
80022dbe:	4590106f          	j	80024a16 <__SEGGER_RTL_print_padding>

80022dc2 <.L40>:
80022dc2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin_l:

80022dc4 <__SEGGER_RTL_init_prin_l>:
80022dc4:	1141                	add	sp,sp,-16
80022dc6:	c226                	sw	s1,4(sp)
80022dc8:	02400613          	li	a2,36
80022dcc:	84ae                	mv	s1,a1
80022dce:	4581                	li	a1,0
80022dd0:	c422                	sw	s0,8(sp)
80022dd2:	c606                	sw	ra,12(sp)
80022dd4:	842a                	mv	s0,a0
80022dd6:	231010ef          	jal	80024806 <memset>
80022dda:	40b2                	lw	ra,12(sp)
80022ddc:	cc44                	sw	s1,28(s0)
80022dde:	4422                	lw	s0,8(sp)
80022de0:	4492                	lw	s1,4(sp)
80022de2:	0141                	add	sp,sp,16
80022de4:	8082                	ret

Disassembly of section .text.libc.vfprintf:

80022de6 <vfprintf>:
80022de6:	1101                	add	sp,sp,-32
80022de8:	cc22                	sw	s0,24(sp)
80022dea:	ca26                	sw	s1,20(sp)
80022dec:	ce06                	sw	ra,28(sp)
80022dee:	84ae                	mv	s1,a1
80022df0:	842a                	mv	s0,a0
80022df2:	c632                	sw	a2,12(sp)
80022df4:	193020ef          	jal	80025786 <__SEGGER_RTL_current_locale>
80022df8:	85aa                	mv	a1,a0
80022dfa:	8522                	mv	a0,s0
80022dfc:	4462                	lw	s0,24(sp)
80022dfe:	46b2                	lw	a3,12(sp)
80022e00:	40f2                	lw	ra,28(sp)
80022e02:	8626                	mv	a2,s1
80022e04:	44d2                	lw	s1,20(sp)
80022e06:	6105                	add	sp,sp,32
80022e08:	4390106f          	j	80024a40 <vfprintf_l>

Disassembly of section .text.libc.printf:

80022e0c <printf>:
80022e0c:	7139                	add	sp,sp,-64
80022e0e:	da3e                	sw	a5,52(sp)
80022e10:	d22e                	sw	a1,36(sp)
80022e12:	85aa                	mv	a1,a0
80022e14:	84022503          	lw	a0,-1984(tp) # fffff840 <__APB_SRAM_segment_end__+0xbf0d840>
80022e18:	d432                	sw	a2,40(sp)
80022e1a:	1050                	add	a2,sp,36
80022e1c:	ce06                	sw	ra,28(sp)
80022e1e:	d636                	sw	a3,44(sp)
80022e20:	d83a                	sw	a4,48(sp)
80022e22:	dc42                	sw	a6,56(sp)
80022e24:	de46                	sw	a7,60(sp)
80022e26:	c632                	sw	a2,12(sp)
80022e28:	3f7d                	jal	80022de6 <vfprintf>
80022e2a:	40f2                	lw	ra,28(sp)
80022e2c:	6121                	add	sp,sp,64
80022e2e:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

80022e30 <__SEGGER_init_heap>:
80022e30:	00080537          	lui	a0,0x80
80022e34:	00050513          	mv	a0,a0
80022e38:	000845b7          	lui	a1,0x84
80022e3c:	00058593          	mv	a1,a1
80022e40:	8d89                	sub	a1,a1,a0
80022e42:	a009                	j	80022e44 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

80022e44 <__SEGGER_RTL_init_heap>:
80022e44:	479d                	li	a5,7
80022e46:	00b7f763          	bgeu	a5,a1,80022e54 <.L68>
80022e4a:	82a22e23          	sw	a0,-1988(tp) # fffff83c <__APB_SRAM_segment_end__+0xbf0d83c>
80022e4e:	00052023          	sw	zero,0(a0) # 80000 <__AXI_SRAM_segment_size__>
80022e52:	c14c                	sw	a1,4(a0)

80022e54 <.L68>:
80022e54:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

80022e56 <__SEGGER_RTL_ascii_toupper>:
80022e56:	f9f50713          	add	a4,a0,-97
80022e5a:	47e5                	li	a5,25
80022e5c:	00e7e363          	bltu	a5,a4,80022e62 <.L5>
80022e60:	1501                	add	a0,a0,-32

80022e62 <.L5>:
80022e62:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

80022e64 <__SEGGER_RTL_ascii_towupper>:
80022e64:	f9f50713          	add	a4,a0,-97
80022e68:	47e5                	li	a5,25
80022e6a:	00e7e363          	bltu	a5,a4,80022e70 <.L12>
80022e6e:	1501                	add	a0,a0,-32

80022e70 <.L12>:
80022e70:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

80022e72 <__SEGGER_RTL_ascii_mbtowc>:
80022e72:	87aa                	mv	a5,a0
80022e74:	4501                	li	a0,0
80022e76:	c195                	beqz	a1,80022e9a <.L55>
80022e78:	c20d                	beqz	a2,80022e9a <.L55>
80022e7a:	0005c703          	lbu	a4,0(a1) # 84000 <__heap_end__>
80022e7e:	07f00613          	li	a2,127
80022e82:	5579                	li	a0,-2
80022e84:	00e66b63          	bltu	a2,a4,80022e9a <.L55>
80022e88:	c391                	beqz	a5,80022e8c <.L57>
80022e8a:	c398                	sw	a4,0(a5)

80022e8c <.L57>:
80022e8c:	0006a023          	sw	zero,0(a3)
80022e90:	0006a223          	sw	zero,4(a3)
80022e94:	00e03533          	snez	a0,a4
80022e98:	8082                	ret

80022e9a <.L55>:
80022e9a:	8082                	ret

Disassembly of section .text.console_init:

80022e9c <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
80022e9c:	7139                	add	sp,sp,-64
80022e9e:	de06                	sw	ra,60(sp)
80022ea0:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
80022ea2:	4785                	li	a5,1
80022ea4:	d63e                	sw	a5,44(sp)

    if (cfg->type == CONSOLE_TYPE_UART) {
80022ea6:	47b2                	lw	a5,12(sp)
80022ea8:	439c                	lw	a5,0(a5)
80022eaa:	e3b9                	bnez	a5,80022ef0 <.L2>

80022eac <.LBB2>:
        uart_config_t config = {0};
80022eac:	cc02                	sw	zero,24(sp)
80022eae:	ce02                	sw	zero,28(sp)
80022eb0:	d002                	sw	zero,32(sp)
80022eb2:	d202                	sw	zero,36(sp)
80022eb4:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
80022eb6:	47b2                	lw	a5,12(sp)
80022eb8:	43dc                	lw	a5,4(a5)
80022eba:	873e                	mv	a4,a5
80022ebc:	083c                	add	a5,sp,24
80022ebe:	85be                	mv	a1,a5
80022ec0:	853a                	mv	a0,a4
80022ec2:	930fe0ef          	jal	80020ff2 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
80022ec6:	47b2                	lw	a5,12(sp)
80022ec8:	479c                	lw	a5,8(a5)
80022eca:	cc3e                	sw	a5,24(sp)
        config.baudrate = cfg->baudrate;
80022ecc:	47b2                	lw	a5,12(sp)
80022ece:	47dc                	lw	a5,12(a5)
80022ed0:	ce3e                	sw	a5,28(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
80022ed2:	47b2                	lw	a5,12(sp)
80022ed4:	43dc                	lw	a5,4(a5)
80022ed6:	873e                	mv	a4,a5
80022ed8:	083c                	add	a5,sp,24
80022eda:	85be                	mv	a1,a5
80022edc:	853a                	mv	a0,a4
80022ede:	2bd9                	jal	800234b4 <uart_init>
80022ee0:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
80022ee2:	57b2                	lw	a5,44(sp)
80022ee4:	e791                	bnez	a5,80022ef0 <.L2>
            g_console_uart = (UART_Type *)cfg->base;
80022ee6:	47b2                	lw	a5,12(sp)
80022ee8:	43dc                	lw	a5,4(a5)
80022eea:	873e                	mv	a4,a5
80022eec:	82e22823          	sw	a4,-2000(tp) # fffff830 <__APB_SRAM_segment_end__+0xbf0d830>

80022ef0 <.L2>:
        }
    }

    return stat;
80022ef0:	57b2                	lw	a5,44(sp)
}
80022ef2:	853e                	mv	a0,a5
80022ef4:	50f2                	lw	ra,60(sp)
80022ef6:	6121                	add	sp,sp,64
80022ef8:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

80022efa <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
80022efa:	7179                	add	sp,sp,-48
80022efc:	d606                	sw	ra,44(sp)
80022efe:	c62a                	sw	a0,12(sp)
80022f00:	c42e                	sw	a1,8(sp)
80022f02:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
80022f04:	ce02                	sw	zero,28(sp)
80022f06:	a099                	j	80022f4c <.L13>

80022f08 <.L17>:
        if (data[count] == '\n') {
80022f08:	4722                	lw	a4,8(sp)
80022f0a:	47f2                	lw	a5,28(sp)
80022f0c:	97ba                	add	a5,a5,a4
80022f0e:	0007c703          	lbu	a4,0(a5)
80022f12:	47a9                	li	a5,10
80022f14:	00f71b63          	bne	a4,a5,80022f2a <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
80022f18:	0001                	nop

80022f1a <.L15>:
80022f1a:	83022783          	lw	a5,-2000(tp) # fffff830 <__APB_SRAM_segment_end__+0xbf0d830>
80022f1e:	45b5                	li	a1,13
80022f20:	853e                	mv	a0,a5
80022f22:	b34fe0ef          	jal	80021256 <uart_send_byte>
80022f26:	87aa                	mv	a5,a0
80022f28:	fbed                	bnez	a5,80022f1a <.L15>

80022f2a <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
80022f2a:	0001                	nop

80022f2c <.L16>:
80022f2c:	83022683          	lw	a3,-2000(tp) # fffff830 <__APB_SRAM_segment_end__+0xbf0d830>
80022f30:	4722                	lw	a4,8(sp)
80022f32:	47f2                	lw	a5,28(sp)
80022f34:	97ba                	add	a5,a5,a4
80022f36:	0007c783          	lbu	a5,0(a5)
80022f3a:	85be                	mv	a1,a5
80022f3c:	8536                	mv	a0,a3
80022f3e:	b18fe0ef          	jal	80021256 <uart_send_byte>
80022f42:	87aa                	mv	a5,a0
80022f44:	f7e5                	bnez	a5,80022f2c <.L16>
    for (count = 0; count < size; count++) {
80022f46:	47f2                	lw	a5,28(sp)
80022f48:	0785                	add	a5,a5,1
80022f4a:	ce3e                	sw	a5,28(sp)

80022f4c <.L13>:
80022f4c:	4772                	lw	a4,28(sp)
80022f4e:	4792                	lw	a5,4(sp)
80022f50:	faf76ce3          	bltu	a4,a5,80022f08 <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
80022f54:	0001                	nop

80022f56 <.L18>:
80022f56:	83022783          	lw	a5,-2000(tp) # fffff830 <__APB_SRAM_segment_end__+0xbf0d830>
80022f5a:	853e                	mv	a0,a5
80022f5c:	2dd9                	jal	80023632 <uart_flush>
80022f5e:	87aa                	mv	a5,a0
80022f60:	fbfd                	bnez	a5,80022f56 <.L18>
    }
    return count;
80022f62:	47f2                	lw	a5,28(sp)

}
80022f64:	853e                	mv	a0,a5
80022f66:	50b2                	lw	ra,44(sp)
80022f68:	6145                	add	sp,sp,48
80022f6a:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

80022f6c <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
80022f6c:	1141                	add	sp,sp,-16
80022f6e:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
80022f70:	4781                	li	a5,0
}
80022f72:	853e                	mv	a0,a5
80022f74:	0141                	add	sp,sp,16
80022f76:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

80022f78 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
80022f78:	1141                	add	sp,sp,-16
80022f7a:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
80022f7c:	4785                	li	a5,1
}
80022f7e:	853e                	mv	a0,a5
80022f80:	0141                	add	sp,sp,16
80022f82:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

80022f84 <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
80022f84:	1101                	add	sp,sp,-32
80022f86:	c62a                	sw	a0,12(sp)
80022f88:	87ae                	mv	a5,a1
80022f8a:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80022f8e:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
80022f90:	00a15703          	lhu	a4,10(sp)
80022f94:	25700793          	li	a5,599
80022f98:	00e7f863          	bgeu	a5,a4,80022fa8 <.L26>
80022f9c:	00a15703          	lhu	a4,10(sp)
80022fa0:	55f00793          	li	a5,1375
80022fa4:	00e7f463          	bgeu	a5,a4,80022fac <.L27>

80022fa8 <.L26>:
        return status_invalid_argument;
80022fa8:	4789                	li	a5,2
80022faa:	a831                	j	80022fc6 <.L28>

80022fac <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80022fac:	47b2                	lw	a5,12(sp)
80022fae:	4b98                	lw	a4,16(a5)
80022fb0:	77fd                	lui	a5,0xfffff
80022fb2:	8f7d                	and	a4,a4,a5
80022fb4:	00a15683          	lhu	a3,10(sp)
80022fb8:	6785                	lui	a5,0x1
80022fba:	17fd                	add	a5,a5,-1 # fff <__ILM_segment_used_end__+0xcc1>
80022fbc:	8ff5                	and	a5,a5,a3
80022fbe:	8f5d                	or	a4,a4,a5
80022fc0:	47b2                	lw	a5,12(sp)
80022fc2:	cb98                	sw	a4,16(a5)
    return stat;
80022fc4:	47f2                	lw	a5,28(sp)

80022fc6 <.L28>:
}
80022fc6:	853e                	mv	a0,a5
80022fc8:	6105                	add	sp,sp,32
80022fca:	8082                	ret

Disassembly of section .text.pllctl_pll_powerdown:

80022fcc <pllctl_pll_powerdown>:
{
80022fcc:	1141                	add	sp,sp,-16
80022fce:	c62a                	sw	a0,12(sp)
80022fd0:	87ae                	mv	a5,a1
80022fd2:	00f105a3          	sb	a5,11(sp)
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
80022fd6:	00b14703          	lbu	a4,11(sp)
80022fda:	4791                	li	a5,4
80022fdc:	00e7f463          	bgeu	a5,a4,80022fe4 <.L5>
        return status_invalid_argument;
80022fe0:	4789                	li	a5,2
80022fe2:	a805                	j	80023012 <.L6>

80022fe4 <.L5>:
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
80022fe4:	00b14783          	lbu	a5,11(sp)
80022fe8:	4732                	lw	a4,12(sp)
80022fea:	0785                	add	a5,a5,1
80022fec:	079e                	sll	a5,a5,0x7
80022fee:	97ba                	add	a5,a5,a4
80022ff0:	43d8                	lw	a4,4(a5)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
80022ff2:	7a0007b7          	lui	a5,0x7a000
80022ff6:	17fd                	add	a5,a5,-1 # 79ffffff <__SHARE_RAM_segment_end__+0x78e7ffff>
80022ff8:	00f776b3          	and	a3,a4,a5
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
80022ffc:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
80023000:	02000737          	lui	a4,0x2000
80023004:	8f55                	or	a4,a4,a3
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
80023006:	46b2                	lw	a3,12(sp)
80023008:	0785                	add	a5,a5,1
8002300a:	079e                	sll	a5,a5,0x7
8002300c:	97b6                	add	a5,a5,a3
8002300e:	c3d8                	sw	a4,4(a5)
    return status_success;
80023010:	4781                	li	a5,0

80023012 <.L6>:
}
80023012:	853e                	mv	a0,a5
80023014:	0141                	add	sp,sp,16
80023016:	8082                	ret

Disassembly of section .text.pllctl_init_int_pll_with_freq:

80023018 <pllctl_init_int_pll_with_freq>:
    return status_success;
}

hpm_stat_t pllctl_init_int_pll_with_freq(PLLCTL_Type *ptr, uint8_t pll,
                                    uint32_t freq_in_hz)
{
80023018:	7179                	add	sp,sp,-48
8002301a:	d606                	sw	ra,44(sp)
8002301c:	c62a                	sw	a0,12(sp)
8002301e:	87ae                	mv	a5,a1
80023020:	c232                	sw	a2,4(sp)
80023022:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
80023026:	47b2                	lw	a5,12(sp)
80023028:	c791                	beqz	a5,80023034 <.L27>
8002302a:	00b14703          	lbu	a4,11(sp)
8002302e:	4791                	li	a5,4
80023030:	00e7f463          	bgeu	a5,a4,80023038 <.L28>

80023034 <.L27>:
        return status_invalid_argument;
80023034:	4789                	li	a5,2
80023036:	ac09                	j	80023248 <.L29>

80023038 <.L28>:
    }
    uint32_t freq, fbdiv, refdiv, postdiv;
    if ((freq_in_hz < PLLCTL_PLL_VCO_FREQ_MIN)
80023038:	4712                	lw	a4,4(sp)
8002303a:	165a17b7          	lui	a5,0x165a1
8002303e:	bbf78793          	add	a5,a5,-1089 # 165a0bbf <__SHARE_RAM_segment_end__+0x15420bbf>
80023042:	00e7f963          	bgeu	a5,a4,80023054 <.L30>
            || (freq_in_hz > PLLCTL_PLL_VCO_FREQ_MAX)) {
80023046:	4712                	lw	a4,4(sp)
80023048:	832157b7          	lui	a5,0x83215
8002304c:	60078793          	add	a5,a5,1536 # 83215600 <__XPI0_segment_end__+0x2a15600>
80023050:	00e7f463          	bgeu	a5,a4,80023058 <.L31>

80023054 <.L30>:
        return status_invalid_argument;
80023054:	4789                	li	a5,2
80023056:	aacd                	j	80023248 <.L29>

80023058 <.L31>:
    }

    freq = freq_in_hz;
80023058:	4792                	lw	a5,4(sp)
8002305a:	ca3e                	sw	a5,20(sp)
    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
8002305c:	00b14783          	lbu	a5,11(sp)
80023060:	4732                	lw	a4,12(sp)
80023062:	0785                	add	a5,a5,1
80023064:	079e                	sll	a5,a5,0x7
80023066:	97ba                	add	a5,a5,a4
80023068:	439c                	lw	a5,0(a5)
8002306a:	83e1                	srl	a5,a5,0x18
8002306c:	03f7f793          	and	a5,a5,63
80023070:	cc3e                	sw	a5,24(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
80023072:	00b14783          	lbu	a5,11(sp)
80023076:	4732                	lw	a4,12(sp)
80023078:	0785                	add	a5,a5,1
8002307a:	079e                	sll	a5,a5,0x7
8002307c:	97ba                	add	a5,a5,a4
8002307e:	439c                	lw	a5,0(a5)
80023080:	83d1                	srl	a5,a5,0x14
80023082:	8b9d                	and	a5,a5,7
80023084:	c83e                	sw	a5,16(sp)
    fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
80023086:	4762                	lw	a4,24(sp)
80023088:	47c2                	lw	a5,16(sp)
8002308a:	02f707b3          	mul	a5,a4,a5
8002308e:	016e3737          	lui	a4,0x16e3
80023092:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80023096:	02f757b3          	divu	a5,a4,a5
8002309a:	4752                	lw	a4,20(sp)
8002309c:	02f757b3          	divu	a5,a4,a5
800230a0:	ce3e                	sw	a5,28(sp)
    if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
800230a2:	4772                	lw	a4,28(sp)
800230a4:	6785                	lui	a5,0x1
800230a6:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x622>
800230aa:	04e7f163          	bgeu	a5,a4,800230ec <.L32>
        /* current refdiv can't be used for the given frequency */
        refdiv--;
800230ae:	47e2                	lw	a5,24(sp)
800230b0:	17fd                	add	a5,a5,-1
800230b2:	cc3e                	sw	a5,24(sp)

800230b4 <.L36>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
800230b4:	4762                	lw	a4,24(sp)
800230b6:	47c2                	lw	a5,16(sp)
800230b8:	02f707b3          	mul	a5,a4,a5
800230bc:	016e3737          	lui	a4,0x16e3
800230c0:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
800230c4:	02f757b3          	divu	a5,a4,a5
800230c8:	4752                	lw	a4,20(sp)
800230ca:	02f757b3          	divu	a5,a4,a5
800230ce:	ce3e                	sw	a5,28(sp)
            if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
800230d0:	4772                	lw	a4,28(sp)
800230d2:	6785                	lui	a5,0x1
800230d4:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x622>
800230d8:	04e7fc63          	bgeu	a5,a4,80023130 <.L45>
                refdiv--;
800230dc:	47e2                	lw	a5,24(sp)
800230de:	17fd                	add	a5,a5,-1
800230e0:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv > PLLCTL_PLL_MIN_REFDIV);
800230e2:	4762                	lw	a4,24(sp)
800230e4:	4785                	li	a5,1
800230e6:	fce7e7e3          	bltu	a5,a4,800230b4 <.L36>
800230ea:	a0b1                	j	80023136 <.L37>

800230ec <.L32>:
    } else if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
800230ec:	4772                	lw	a4,28(sp)
800230ee:	47bd                	li	a5,15
800230f0:	04e7e363          	bltu	a5,a4,80023136 <.L37>
        /* current refdiv can't be used for the given frequency */
        refdiv++;
800230f4:	47e2                	lw	a5,24(sp)
800230f6:	0785                	add	a5,a5,1
800230f8:	cc3e                	sw	a5,24(sp)

800230fa <.L40>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
800230fa:	4762                	lw	a4,24(sp)
800230fc:	47c2                	lw	a5,16(sp)
800230fe:	02f707b3          	mul	a5,a4,a5
80023102:	016e3737          	lui	a4,0x16e3
80023106:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8002310a:	02f757b3          	divu	a5,a4,a5
8002310e:	4752                	lw	a4,20(sp)
80023110:	02f757b3          	divu	a5,a4,a5
80023114:	ce3e                	sw	a5,28(sp)
            if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
80023116:	4772                	lw	a4,28(sp)
80023118:	47bd                	li	a5,15
8002311a:	00e7ed63          	bltu	a5,a4,80023134 <.L46>
                refdiv++;
8002311e:	47e2                	lw	a5,24(sp)
80023120:	0785                	add	a5,a5,1
80023122:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv < PLLCTL_PLL_MAX_REFDIV);
80023124:	4762                	lw	a4,24(sp)
80023126:	03e00793          	li	a5,62
8002312a:	fce7f8e3          	bgeu	a5,a4,800230fa <.L40>
8002312e:	a021                	j	80023136 <.L37>

80023130 <.L45>:
                break;
80023130:	0001                	nop
80023132:	a011                	j	80023136 <.L37>

80023134 <.L46>:
                break;
80023134:	0001                	nop

80023136 <.L37>:
    }

    if ((refdiv > PLLCTL_PLL_MAX_REFDIV)
80023136:	4762                	lw	a4,24(sp)
80023138:	03f00793          	li	a5,63
8002313c:	02e7eb63          	bltu	a5,a4,80023172 <.L41>
            || (refdiv < PLLCTL_PLL_MIN_REFDIV)
80023140:	47e2                	lw	a5,24(sp)
80023142:	cb85                	beqz	a5,80023172 <.L41>
            || (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV)
80023144:	4772                	lw	a4,28(sp)
80023146:	6785                	lui	a5,0x1
80023148:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x622>
8002314c:	02e7e363          	bltu	a5,a4,80023172 <.L41>
            || (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV)
80023150:	4772                	lw	a4,28(sp)
80023152:	47bd                	li	a5,15
80023154:	00e7ff63          	bgeu	a5,a4,80023172 <.L41>
            || (((PLLCTL_SOC_PLL_REFCLK_FREQ / refdiv) < PLLCTL_INT_PLL_MIN_REF))) {
80023158:	016e37b7          	lui	a5,0x16e3
8002315c:	60078713          	add	a4,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80023160:	47e2                	lw	a5,24(sp)
80023162:	02f75733          	divu	a4,a4,a5
80023166:	000f47b7          	lui	a5,0xf4
8002316a:	23f78793          	add	a5,a5,575 # f423f <__DLM_segment_end__+0x3423f>
8002316e:	00e7e663          	bltu	a5,a4,8002317a <.L42>

80023172 <.L41>:
        return status_pllctl_out_of_range;
80023172:	6799                	lui	a5,0x6
80023174:	9da78793          	add	a5,a5,-1574 # 59da <__HEAPSIZE__+0x19da>
80023178:	a8c1                	j	80023248 <.L29>

8002317a <.L42>:
    }

    if (!(ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK)) {
8002317a:	00b14783          	lbu	a5,11(sp)
8002317e:	4732                	lw	a4,12(sp)
80023180:	0785                	add	a5,a5,1
80023182:	079e                	sll	a5,a5,0x7
80023184:	97ba                	add	a5,a5,a4
80023186:	439c                	lw	a5,0(a5)
80023188:	8ba1                	and	a5,a5,8
8002318a:	e795                	bnez	a5,800231b6 <.L43>
        /* it was at frac mode, then it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
8002318c:	00b14783          	lbu	a5,11(sp)
80023190:	85be                	mv	a1,a5
80023192:	4532                	lw	a0,12(sp)
80023194:	3d25                	jal	80022fcc <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 |= PLLCTL_PLL_CFG0_DSMPD_MASK;
80023196:	00b14783          	lbu	a5,11(sp)
8002319a:	4732                	lw	a4,12(sp)
8002319c:	0785                	add	a5,a5,1
8002319e:	079e                	sll	a5,a5,0x7
800231a0:	97ba                	add	a5,a5,a4
800231a2:	4398                	lw	a4,0(a5)
800231a4:	00b14783          	lbu	a5,11(sp)
800231a8:	00876713          	or	a4,a4,8
800231ac:	46b2                	lw	a3,12(sp)
800231ae:	0785                	add	a5,a5,1
800231b0:	079e                	sll	a5,a5,0x7
800231b2:	97b6                	add	a5,a5,a3
800231b4:	c398                	sw	a4,0(a5)

800231b6 <.L43>:
    }

    if (PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0) != refdiv) {
800231b6:	00b14783          	lbu	a5,11(sp)
800231ba:	4732                	lw	a4,12(sp)
800231bc:	0785                	add	a5,a5,1
800231be:	079e                	sll	a5,a5,0x7
800231c0:	97ba                	add	a5,a5,a4
800231c2:	439c                	lw	a5,0(a5)
800231c4:	83e1                	srl	a5,a5,0x18
800231c6:	03f7f793          	and	a5,a5,63
800231ca:	4762                	lw	a4,24(sp)
800231cc:	04f70163          	beq	a4,a5,8002320e <.L44>
        /* if refdiv is different, it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
800231d0:	00b14783          	lbu	a5,11(sp)
800231d4:	85be                	mv	a1,a5
800231d6:	4532                	lw	a0,12(sp)
800231d8:	3bd5                	jal	80022fcc <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
800231da:	00b14783          	lbu	a5,11(sp)
800231de:	4732                	lw	a4,12(sp)
800231e0:	0785                	add	a5,a5,1
800231e2:	079e                	sll	a5,a5,0x7
800231e4:	97ba                	add	a5,a5,a4
800231e6:	4398                	lw	a4,0(a5)
800231e8:	c10007b7          	lui	a5,0xc1000
800231ec:	17fd                	add	a5,a5,-1 # c0ffffff <__XPI0_segment_end__+0x407fffff>
800231ee:	00f776b3          	and	a3,a4,a5
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
800231f2:	47e2                	lw	a5,24(sp)
800231f4:	01879713          	sll	a4,a5,0x18
800231f8:	3f0007b7          	lui	a5,0x3f000
800231fc:	8f7d                	and	a4,a4,a5
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
800231fe:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
80023202:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
80023204:	46b2                	lw	a3,12(sp)
80023206:	0785                	add	a5,a5,1 # 3f000001 <__SHARE_RAM_segment_end__+0x3de80001>
80023208:	079e                	sll	a5,a5,0x7
8002320a:	97b6                	add	a5,a5,a3
8002320c:	c398                	sw	a4,0(a5)

8002320e <.L44>:
    }

    ptr->PLL[pll].CFG2 = (ptr->PLL[pll].CFG2 & ~(PLLCTL_PLL_CFG2_FBDIV_INT_MASK)) | PLLCTL_PLL_CFG2_FBDIV_INT_SET(fbdiv);
8002320e:	00b14783          	lbu	a5,11(sp)
80023212:	4732                	lw	a4,12(sp)
80023214:	0785                	add	a5,a5,1
80023216:	079e                	sll	a5,a5,0x7
80023218:	97ba                	add	a5,a5,a4
8002321a:	4798                	lw	a4,8(a5)
8002321c:	77fd                	lui	a5,0xfffff
8002321e:	00f776b3          	and	a3,a4,a5
80023222:	4772                	lw	a4,28(sp)
80023224:	6785                	lui	a5,0x1
80023226:	17fd                	add	a5,a5,-1 # fff <__ILM_segment_used_end__+0xcc1>
80023228:	8f7d                	and	a4,a4,a5
8002322a:	00b14783          	lbu	a5,11(sp)
8002322e:	8f55                	or	a4,a4,a3
80023230:	46b2                	lw	a3,12(sp)
80023232:	0785                	add	a5,a5,1
80023234:	079e                	sll	a5,a5,0x7
80023236:	97b6                	add	a5,a5,a3
80023238:	c798                	sw	a4,8(a5)

    pllctl_pll_poweron(ptr, pll);
8002323a:	00b14783          	lbu	a5,11(sp)
8002323e:	85be                	mv	a1,a5
80023240:	4532                	lw	a0,12(sp)
80023242:	995fd0ef          	jal	80020bd6 <pllctl_pll_poweron>
    return status_success;
80023246:	4781                	li	a5,0

80023248 <.L29>:
}
80023248:	853e                	mv	a0,a5
8002324a:	50b2                	lw	ra,44(sp)
8002324c:	6145                	add	sp,sp,48
8002324e:	8082                	ret

Disassembly of section .text.pllctl_get_pll_freq_in_hz:

80023250 <pllctl_get_pll_freq_in_hz>:
    pllctl_pll_poweron(ptr, pll);
    return status_success;
}

uint32_t pllctl_get_pll_freq_in_hz(PLLCTL_Type *ptr, uint8_t pll)
{
80023250:	715d                	add	sp,sp,-80
80023252:	c686                	sw	ra,76(sp)
80023254:	c4a2                	sw	s0,72(sp)
80023256:	c2a6                	sw	s1,68(sp)
80023258:	c0ca                	sw	s2,64(sp)
8002325a:	de4e                	sw	s3,60(sp)
8002325c:	c62a                	sw	a0,12(sp)
8002325e:	87ae                	mv	a5,a1
80023260:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
80023264:	47b2                	lw	a5,12(sp)
80023266:	c791                	beqz	a5,80023272 <.L67>
80023268:	00b14703          	lbu	a4,11(sp)
8002326c:	4791                	li	a5,4
8002326e:	00e7f463          	bgeu	a5,a4,80023276 <.L68>

80023272 <.L67>:
        return status_invalid_argument;
80023272:	4789                	li	a5,2
80023274:	aa35                	j	800233b0 <.L69>

80023276 <.L68>:
    }
    uint32_t fbdiv, frac, refdiv, postdiv, refclk, freq;
    if (ptr->PLL[pll].CFG1 & PLLCTL_PLL_CFG1_PLLPD_SW_MASK) {
80023276:	00b14783          	lbu	a5,11(sp)
8002327a:	4732                	lw	a4,12(sp)
8002327c:	0785                	add	a5,a5,1
8002327e:	079e                	sll	a5,a5,0x7
80023280:	97ba                	add	a5,a5,a4
80023282:	43d8                	lw	a4,4(a5)
80023284:	020007b7          	lui	a5,0x2000
80023288:	8ff9                	and	a5,a5,a4
8002328a:	c399                	beqz	a5,80023290 <.L70>
        /* pll is powered down */
        return 0;
8002328c:	4781                	li	a5,0
8002328e:	a20d                	j	800233b0 <.L69>

80023290 <.L70>:
    }

    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
80023290:	00b14783          	lbu	a5,11(sp)
80023294:	4732                	lw	a4,12(sp)
80023296:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
80023298:	079e                	sll	a5,a5,0x7
8002329a:	97ba                	add	a5,a5,a4
8002329c:	439c                	lw	a5,0(a5)
8002329e:	83e1                	srl	a5,a5,0x18
800232a0:	03f7f793          	and	a5,a5,63
800232a4:	d43e                	sw	a5,40(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
800232a6:	00b14783          	lbu	a5,11(sp)
800232aa:	4732                	lw	a4,12(sp)
800232ac:	0785                	add	a5,a5,1
800232ae:	079e                	sll	a5,a5,0x7
800232b0:	97ba                	add	a5,a5,a4
800232b2:	439c                	lw	a5,0(a5)
800232b4:	83d1                	srl	a5,a5,0x14
800232b6:	8b9d                	and	a5,a5,7
800232b8:	d23e                	sw	a5,36(sp)
    refclk = PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv);
800232ba:	5722                	lw	a4,40(sp)
800232bc:	5792                	lw	a5,36(sp)
800232be:	02f707b3          	mul	a5,a4,a5
800232c2:	016e3737          	lui	a4,0x16e3
800232c6:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
800232ca:	02f757b3          	divu	a5,a4,a5
800232ce:	d03e                	sw	a5,32(sp)

    if (ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK) {
800232d0:	00b14783          	lbu	a5,11(sp)
800232d4:	4732                	lw	a4,12(sp)
800232d6:	0785                	add	a5,a5,1
800232d8:	079e                	sll	a5,a5,0x7
800232da:	97ba                	add	a5,a5,a4
800232dc:	439c                	lw	a5,0(a5)
800232de:	8ba1                	and	a5,a5,8
800232e0:	c395                	beqz	a5,80023304 <.L71>
        /* pll int mode */
        fbdiv = PLLCTL_PLL_CFG2_FBDIV_INT_GET(ptr->PLL[pll].CFG2);
800232e2:	00b14783          	lbu	a5,11(sp)
800232e6:	4732                	lw	a4,12(sp)
800232e8:	0785                	add	a5,a5,1
800232ea:	079e                	sll	a5,a5,0x7
800232ec:	97ba                	add	a5,a5,a4
800232ee:	4798                	lw	a4,8(a5)
800232f0:	6785                	lui	a5,0x1
800232f2:	17fd                	add	a5,a5,-1 # fff <__ILM_segment_used_end__+0xcc1>
800232f4:	8ff9                	and	a5,a5,a4
800232f6:	ce3e                	sw	a5,28(sp)
        freq = refclk * fbdiv;
800232f8:	5702                	lw	a4,32(sp)
800232fa:	47f2                	lw	a5,28(sp)
800232fc:	02f707b3          	mul	a5,a4,a5
80023300:	d63e                	sw	a5,44(sp)
80023302:	a075                	j	800233ae <.L72>

80023304 <.L71>:
    } else {
        /* pll frac mode */
        fbdiv = PLLCTL_PLL_FREQ_FBDIV_FRAC_GET(ptr->PLL[pll].FREQ);
80023304:	00b14783          	lbu	a5,11(sp)
80023308:	4732                	lw	a4,12(sp)
8002330a:	0785                	add	a5,a5,1
8002330c:	079e                	sll	a5,a5,0x7
8002330e:	97ba                	add	a5,a5,a4
80023310:	47dc                	lw	a5,12(a5)
80023312:	0ff7f793          	zext.b	a5,a5
80023316:	ce3e                	sw	a5,28(sp)
        frac = PLLCTL_PLL_FREQ_FRAC_GET(ptr->PLL[pll].FREQ);
80023318:	00b14783          	lbu	a5,11(sp)
8002331c:	4732                	lw	a4,12(sp)
8002331e:	0785                	add	a5,a5,1
80023320:	079e                	sll	a5,a5,0x7
80023322:	97ba                	add	a5,a5,a4
80023324:	47dc                	lw	a5,12(a5)
80023326:	0087d713          	srl	a4,a5,0x8
8002332a:	010007b7          	lui	a5,0x1000
8002332e:	17fd                	add	a5,a5,-1 # ffffff <_flash_size+0x7fffff>
80023330:	8ff9                	and	a5,a5,a4
80023332:	cc3e                	sw	a5,24(sp)
        freq = (uint32_t)((refclk * (fbdiv + ((double) frac / (1 << 24)))) + 0.5);
80023334:	5502                	lw	a0,32(sp)
80023336:	2f0010ef          	jal	80024626 <__floatunsidf>
8002333a:	842a                	mv	s0,a0
8002333c:	84ae                	mv	s1,a1
8002333e:	4572                	lw	a0,28(sp)
80023340:	2e6010ef          	jal	80024626 <__floatunsidf>
80023344:	892a                	mv	s2,a0
80023346:	89ae                	mv	s3,a1
80023348:	4562                	lw	a0,24(sp)
8002334a:	2dc010ef          	jal	80024626 <__floatunsidf>
8002334e:	872a                	mv	a4,a0
80023350:	87ae                	mv	a5,a1
80023352:	800206b7          	lui	a3,0x80020
80023356:	0886a603          	lw	a2,136(a3) # 80020088 <.LC1>
8002335a:	08c6a683          	lw	a3,140(a3)
8002335e:	853a                	mv	a0,a4
80023360:	85be                	mv	a1,a5
80023362:	078010ef          	jal	800243da <__divdf3>
80023366:	872a                	mv	a4,a0
80023368:	87ae                	mv	a5,a1
8002336a:	863a                	mv	a2,a4
8002336c:	86be                	mv	a3,a5
8002336e:	854a                	mv	a0,s2
80023370:	85ce                	mv	a1,s3
80023372:	2d1000ef          	jal	80023e42 <__adddf3>
80023376:	872a                	mv	a4,a0
80023378:	87ae                	mv	a5,a1
8002337a:	863a                	mv	a2,a4
8002337c:	86be                	mv	a3,a5
8002337e:	8522                	mv	a0,s0
80023380:	85a6                	mv	a1,s1
80023382:	649000ef          	jal	800241ca <__muldf3>
80023386:	872a                	mv	a4,a0
80023388:	87ae                	mv	a5,a1
8002338a:	853a                	mv	a0,a4
8002338c:	85be                	mv	a1,a5
8002338e:	800207b7          	lui	a5,0x80020
80023392:	0907a603          	lw	a2,144(a5) # 80020090 <.LC2>
80023396:	0947a683          	lw	a3,148(a5)
8002339a:	2a9000ef          	jal	80023e42 <__adddf3>
8002339e:	872a                	mv	a4,a0
800233a0:	87ae                	mv	a5,a1
800233a2:	853a                	mv	a0,a4
800233a4:	85be                	mv	a1,a5
800233a6:	de5fe0ef          	jal	8002218a <__fixunsdfsi>
800233aa:	87aa                	mv	a5,a0
800233ac:	d63e                	sw	a5,44(sp)

800233ae <.L72>:
    }
    return freq;
800233ae:	57b2                	lw	a5,44(sp)

800233b0 <.L69>:
}
800233b0:	853e                	mv	a0,a5
800233b2:	40b6                	lw	ra,76(sp)
800233b4:	4426                	lw	s0,72(sp)
800233b6:	4496                	lw	s1,68(sp)
800233b8:	4906                	lw	s2,64(sp)
800233ba:	59f2                	lw	s3,60(sp)
800233bc:	6161                	add	sp,sp,80
800233be:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

800233c0 <write_pmp_cfg>:
{
800233c0:	1141                	add	sp,sp,-16
800233c2:	c62a                	sw	a0,12(sp)
800233c4:	c42e                	sw	a1,8(sp)
    switch (idx) {
800233c6:	4722                	lw	a4,8(sp)
800233c8:	478d                	li	a5,3
800233ca:	04f70163          	beq	a4,a5,8002340c <.L11>
800233ce:	4722                	lw	a4,8(sp)
800233d0:	478d                	li	a5,3
800233d2:	04e7e163          	bltu	a5,a4,80023414 <.L17>
800233d6:	4722                	lw	a4,8(sp)
800233d8:	4789                	li	a5,2
800233da:	02f70563          	beq	a4,a5,80023404 <.L13>
800233de:	4722                	lw	a4,8(sp)
800233e0:	4789                	li	a5,2
800233e2:	02e7e963          	bltu	a5,a4,80023414 <.L17>
800233e6:	47a2                	lw	a5,8(sp)
800233e8:	c791                	beqz	a5,800233f4 <.L14>
800233ea:	4722                	lw	a4,8(sp)
800233ec:	4785                	li	a5,1
800233ee:	00f70763          	beq	a4,a5,800233fc <.L15>
        break;
800233f2:	a00d                	j	80023414 <.L17>

800233f4 <.L14>:
        write_csr(CSR_PMPCFG0, value);
800233f4:	47b2                	lw	a5,12(sp)
800233f6:	3a079073          	csrw	pmpcfg0,a5
        break;
800233fa:	a831                	j	80023416 <.L16>

800233fc <.L15>:
        write_csr(CSR_PMPCFG1, value);
800233fc:	47b2                	lw	a5,12(sp)
800233fe:	3a179073          	csrw	pmpcfg1,a5
        break;
80023402:	a811                	j	80023416 <.L16>

80023404 <.L13>:
        write_csr(CSR_PMPCFG2, value);
80023404:	47b2                	lw	a5,12(sp)
80023406:	3a279073          	csrw	pmpcfg2,a5
        break;
8002340a:	a031                	j	80023416 <.L16>

8002340c <.L11>:
        write_csr(CSR_PMPCFG3, value);
8002340c:	47b2                	lw	a5,12(sp)
8002340e:	3a379073          	csrw	pmpcfg3,a5
        break;
80023412:	a011                	j	80023416 <.L16>

80023414 <.L17>:
        break;
80023414:	0001                	nop

80023416 <.L16>:
}
80023416:	0001                	nop
80023418:	0141                	add	sp,sp,16
8002341a:	8082                	ret

Disassembly of section .text.write_pma_cfg:

8002341c <write_pma_cfg>:
{
8002341c:	1141                	add	sp,sp,-16
8002341e:	c62a                	sw	a0,12(sp)
80023420:	c42e                	sw	a1,8(sp)
    switch (idx) {
80023422:	4722                	lw	a4,8(sp)
80023424:	478d                	li	a5,3
80023426:	04f70163          	beq	a4,a5,80023468 <.L71>
8002342a:	4722                	lw	a4,8(sp)
8002342c:	478d                	li	a5,3
8002342e:	04e7e163          	bltu	a5,a4,80023470 <.L77>
80023432:	4722                	lw	a4,8(sp)
80023434:	4789                	li	a5,2
80023436:	02f70563          	beq	a4,a5,80023460 <.L73>
8002343a:	4722                	lw	a4,8(sp)
8002343c:	4789                	li	a5,2
8002343e:	02e7e963          	bltu	a5,a4,80023470 <.L77>
80023442:	47a2                	lw	a5,8(sp)
80023444:	c791                	beqz	a5,80023450 <.L74>
80023446:	4722                	lw	a4,8(sp)
80023448:	4785                	li	a5,1
8002344a:	00f70763          	beq	a4,a5,80023458 <.L75>
        break;
8002344e:	a00d                	j	80023470 <.L77>

80023450 <.L74>:
        write_csr(CSR_PMACFG0, value);
80023450:	47b2                	lw	a5,12(sp)
80023452:	bc079073          	csrw	0xbc0,a5
        break;
80023456:	a831                	j	80023472 <.L76>

80023458 <.L75>:
        write_csr(CSR_PMACFG1, value);
80023458:	47b2                	lw	a5,12(sp)
8002345a:	bc179073          	csrw	0xbc1,a5
        break;
8002345e:	a811                	j	80023472 <.L76>

80023460 <.L73>:
        write_csr(CSR_PMACFG2, value);
80023460:	47b2                	lw	a5,12(sp)
80023462:	bc279073          	csrw	0xbc2,a5
        break;
80023466:	a031                	j	80023472 <.L76>

80023468 <.L71>:
        write_csr(CSR_PMACFG3, value);
80023468:	47b2                	lw	a5,12(sp)
8002346a:	bc379073          	csrw	0xbc3,a5
        break;
8002346e:	a011                	j	80023472 <.L76>

80023470 <.L77>:
        break;
80023470:	0001                	nop

80023472 <.L76>:
}
80023472:	0001                	nop
80023474:	0141                	add	sp,sp,16
80023476:	8082                	ret

Disassembly of section .text.uart_modem_config:

80023478 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
80023478:	1141                	add	sp,sp,-16
8002347a:	c62a                	sw	a0,12(sp)
8002347c:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
8002347e:	47a2                	lw	a5,8(sp)
80023480:	0007c783          	lbu	a5,0(a5)
80023484:	0796                	sll	a5,a5,0x5
80023486:	0207f713          	and	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
8002348a:	47a2                	lw	a5,8(sp)
8002348c:	0017c783          	lbu	a5,1(a5)
80023490:	0792                	sll	a5,a5,0x4
80023492:	8bc1                	and	a5,a5,16
80023494:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
80023496:	47a2                	lw	a5,8(sp)
80023498:	0027c783          	lbu	a5,2(a5)
8002349c:	0017c793          	xor	a5,a5,1
800234a0:	0ff7f793          	zext.b	a5,a5
800234a4:	0786                	sll	a5,a5,0x1
800234a6:	8b89                	and	a5,a5,2
800234a8:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
800234aa:	47b2                	lw	a5,12(sp)
800234ac:	db98                	sw	a4,48(a5)
}
800234ae:	0001                	nop
800234b0:	0141                	add	sp,sp,16
800234b2:	8082                	ret

Disassembly of section .text.uart_init:

800234b4 <uart_init>:
{
800234b4:	7179                	add	sp,sp,-48
800234b6:	d606                	sw	ra,44(sp)
800234b8:	c62a                	sw	a0,12(sp)
800234ba:	c42e                	sw	a1,8(sp)
    ptr->IER = 0;
800234bc:	47b2                	lw	a5,12(sp)
800234be:	0207a223          	sw	zero,36(a5)
    ptr->LCR |= UART_LCR_DLAB_MASK;
800234c2:	47b2                	lw	a5,12(sp)
800234c4:	57dc                	lw	a5,44(a5)
800234c6:	0807e713          	or	a4,a5,128
800234ca:	47b2                	lw	a5,12(sp)
800234cc:	d7d8                	sw	a4,44(a5)
    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
800234ce:	47a2                	lw	a5,8(sp)
800234d0:	4398                	lw	a4,0(a5)
800234d2:	47a2                	lw	a5,8(sp)
800234d4:	43dc                	lw	a5,4(a5)
800234d6:	01b10693          	add	a3,sp,27
800234da:	0830                	add	a2,sp,24
800234dc:	85be                	mv	a1,a5
800234de:	853a                	mv	a0,a4
800234e0:	b9bfd0ef          	jal	8002107a <uart_calculate_baudrate>
800234e4:	87aa                	mv	a5,a0
800234e6:	0017c793          	xor	a5,a5,1
800234ea:	0ff7f793          	zext.b	a5,a5
800234ee:	c781                	beqz	a5,800234f6 <.L25>
        return status_uart_no_suitable_baudrate_parameter_found;
800234f0:	3e900793          	li	a5,1001
800234f4:	aa1d                	j	8002362a <.L41>

800234f6 <.L25>:
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
800234f6:	47b2                	lw	a5,12(sp)
800234f8:	4bdc                	lw	a5,20(a5)
800234fa:	fe07f713          	and	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
800234fe:	01b14783          	lbu	a5,27(sp)
80023502:	8bfd                	and	a5,a5,31
80023504:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80023506:	47b2                	lw	a5,12(sp)
80023508:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
8002350a:	01815783          	lhu	a5,24(sp)
8002350e:	0ff7f713          	zext.b	a4,a5
80023512:	47b2                	lw	a5,12(sp)
80023514:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
80023516:	01815783          	lhu	a5,24(sp)
8002351a:	83a1                	srl	a5,a5,0x8
8002351c:	07c2                	sll	a5,a5,0x10
8002351e:	83c1                	srl	a5,a5,0x10
80023520:	0ff7f713          	zext.b	a4,a5
80023524:	47b2                	lw	a5,12(sp)
80023526:	d3d8                	sw	a4,36(a5)
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
80023528:	47b2                	lw	a5,12(sp)
8002352a:	57dc                	lw	a5,44(a5)
8002352c:	f7f7f793          	and	a5,a5,-129
80023530:	ce3e                	sw	a5,28(sp)
    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
80023532:	47f2                	lw	a5,28(sp)
80023534:	fc77f793          	and	a5,a5,-57
80023538:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
8002353a:	47a2                	lw	a5,8(sp)
8002353c:	00a7c783          	lbu	a5,10(a5)
80023540:	4711                	li	a4,4
80023542:	02f76d63          	bltu	a4,a5,8002357c <.L27>
80023546:	00279713          	sll	a4,a5,0x2
8002354a:	91418793          	add	a5,gp,-1772 # 800201b8 <.L29>
8002354e:	97ba                	add	a5,a5,a4
80023550:	439c                	lw	a5,0(a5)
80023552:	8782                	jr	a5

80023554 <.L32>:
        tmp |= UART_LCR_PEN_MASK;
80023554:	47f2                	lw	a5,28(sp)
80023556:	0087e793          	or	a5,a5,8
8002355a:	ce3e                	sw	a5,28(sp)
        break;
8002355c:	a01d                	j	80023582 <.L34>

8002355e <.L31>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
8002355e:	47f2                	lw	a5,28(sp)
80023560:	0187e793          	or	a5,a5,24
80023564:	ce3e                	sw	a5,28(sp)
        break;
80023566:	a831                	j	80023582 <.L34>

80023568 <.L30>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
80023568:	47f2                	lw	a5,28(sp)
8002356a:	0287e793          	or	a5,a5,40
8002356e:	ce3e                	sw	a5,28(sp)
        break;
80023570:	a809                	j	80023582 <.L34>

80023572 <.L28>:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
80023572:	47f2                	lw	a5,28(sp)
80023574:	0387e793          	or	a5,a5,56
80023578:	ce3e                	sw	a5,28(sp)
        break;
8002357a:	a021                	j	80023582 <.L34>

8002357c <.L27>:
        return status_invalid_argument;
8002357c:	4789                	li	a5,2
8002357e:	a075                	j	8002362a <.L41>

80023580 <.L42>:
        break;
80023580:	0001                	nop

80023582 <.L34>:
    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
80023582:	47f2                	lw	a5,28(sp)
80023584:	9be1                	and	a5,a5,-8
80023586:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
80023588:	47a2                	lw	a5,8(sp)
8002358a:	0087c783          	lbu	a5,8(a5)
8002358e:	4709                	li	a4,2
80023590:	00e78e63          	beq	a5,a4,800235ac <.L35>
80023594:	4709                	li	a4,2
80023596:	02f74663          	blt	a4,a5,800235c2 <.L36>
8002359a:	c795                	beqz	a5,800235c6 <.L43>
8002359c:	4705                	li	a4,1
8002359e:	02e79263          	bne	a5,a4,800235c2 <.L36>
        tmp |= UART_LCR_STB_MASK;
800235a2:	47f2                	lw	a5,28(sp)
800235a4:	0047e793          	or	a5,a5,4
800235a8:	ce3e                	sw	a5,28(sp)
        break;
800235aa:	a839                	j	800235c8 <.L39>

800235ac <.L35>:
        if (config->word_length < word_length_6_bits) {
800235ac:	47a2                	lw	a5,8(sp)
800235ae:	0097c783          	lbu	a5,9(a5)
800235b2:	e399                	bnez	a5,800235b8 <.L40>
            return status_invalid_argument;
800235b4:	4789                	li	a5,2
800235b6:	a895                	j	8002362a <.L41>

800235b8 <.L40>:
        tmp |= UART_LCR_STB_MASK;
800235b8:	47f2                	lw	a5,28(sp)
800235ba:	0047e793          	or	a5,a5,4
800235be:	ce3e                	sw	a5,28(sp)
        break;
800235c0:	a021                	j	800235c8 <.L39>

800235c2 <.L36>:
        return status_invalid_argument;
800235c2:	4789                	li	a5,2
800235c4:	a09d                	j	8002362a <.L41>

800235c6 <.L43>:
        break;
800235c6:	0001                	nop

800235c8 <.L39>:
    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
800235c8:	47a2                	lw	a5,8(sp)
800235ca:	0097c783          	lbu	a5,9(a5)
800235ce:	0037f713          	and	a4,a5,3
800235d2:	47f2                	lw	a5,28(sp)
800235d4:	8f5d                	or	a4,a4,a5
800235d6:	47b2                	lw	a5,12(sp)
800235d8:	d7d8                	sw	a4,44(a5)
    ptr->FCR = UART_FCR_TFIFORST_MASK | UART_FCR_RFIFORST_MASK;
800235da:	47b2                	lw	a5,12(sp)
800235dc:	4719                	li	a4,6
800235de:	d798                	sw	a4,40(a5)
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
800235e0:	47a2                	lw	a5,8(sp)
800235e2:	00e7c783          	lbu	a5,14(a5)
800235e6:	873e                	mv	a4,a5
        | UART_FCR_TFIFOT_SET(config->tx_fifo_level)
800235e8:	47a2                	lw	a5,8(sp)
800235ea:	00b7c783          	lbu	a5,11(a5)
800235ee:	0792                	sll	a5,a5,0x4
800235f0:	0307f793          	and	a5,a5,48
800235f4:	8f5d                	or	a4,a4,a5
        | UART_FCR_RFIFOT_SET(config->rx_fifo_level)
800235f6:	47a2                	lw	a5,8(sp)
800235f8:	00c7c783          	lbu	a5,12(a5)
800235fc:	079a                	sll	a5,a5,0x6
800235fe:	0ff7f793          	zext.b	a5,a5
80023602:	8f5d                	or	a4,a4,a5
        | UART_FCR_DMAE_SET(config->dma_enable);
80023604:	47a2                	lw	a5,8(sp)
80023606:	00d7c783          	lbu	a5,13(a5)
8002360a:	078e                	sll	a5,a5,0x3
8002360c:	8ba1                	and	a5,a5,8
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
8002360e:	8fd9                	or	a5,a5,a4
80023610:	ce3e                	sw	a5,28(sp)
    ptr->FCR = tmp;
80023612:	47b2                	lw	a5,12(sp)
80023614:	4772                	lw	a4,28(sp)
80023616:	d798                	sw	a4,40(a5)
    ptr->GPR = tmp;
80023618:	47b2                	lw	a5,12(sp)
8002361a:	4772                	lw	a4,28(sp)
8002361c:	dfd8                	sw	a4,60(a5)
    uart_modem_config(ptr, &config->modem_config);
8002361e:	47a2                	lw	a5,8(sp)
80023620:	07bd                	add	a5,a5,15
80023622:	85be                	mv	a1,a5
80023624:	4532                	lw	a0,12(sp)
80023626:	3d89                	jal	80023478 <uart_modem_config>
    return status_success;
80023628:	4781                	li	a5,0

8002362a <.L41>:
}
8002362a:	853e                	mv	a0,a5
8002362c:	50b2                	lw	ra,44(sp)
8002362e:	6145                	add	sp,sp,48
80023630:	8082                	ret

Disassembly of section .text.uart_flush:

80023632 <uart_flush>:

hpm_stat_t uart_flush(UART_Type *ptr)
{
80023632:	1101                	add	sp,sp,-32
80023634:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
80023636:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80023638:	a811                	j	8002364c <.L57>

8002363a <.L60>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8002363a:	4772                	lw	a4,28(sp)
8002363c:	6785                	lui	a5,0x1
8002363e:	38878793          	add	a5,a5,904 # 1388 <__ILM_segment_used_end__+0x104a>
80023642:	00e7eb63          	bltu	a5,a4,80023658 <.L63>
            break;
        }
        retry++;
80023646:	47f2                	lw	a5,28(sp)
80023648:	0785                	add	a5,a5,1
8002364a:	ce3e                	sw	a5,28(sp)

8002364c <.L57>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
8002364c:	47b2                	lw	a5,12(sp)
8002364e:	5bdc                	lw	a5,52(a5)
80023650:	0407f793          	and	a5,a5,64
80023654:	d3fd                	beqz	a5,8002363a <.L60>
80023656:	a011                	j	8002365a <.L59>

80023658 <.L63>:
            break;
80023658:	0001                	nop

8002365a <.L59>:
    }
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8002365a:	4772                	lw	a4,28(sp)
8002365c:	6785                	lui	a5,0x1
8002365e:	38878793          	add	a5,a5,904 # 1388 <__ILM_segment_used_end__+0x104a>
80023662:	00e7f463          	bgeu	a5,a4,8002366a <.L61>
        return status_timeout;
80023666:	478d                	li	a5,3
80023668:	a011                	j	8002366c <.L62>

8002366a <.L61>:
    }

    return status_success;
8002366a:	4781                	li	a5,0

8002366c <.L62>:
}
8002366c:	853e                	mv	a0,a5
8002366e:	6105                	add	sp,sp,32
80023670:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

80023672 <sysctl_clock_set_preset>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr,
                                           sysctl_preset_t preset)
{
80023672:	1141                	add	sp,sp,-16
80023674:	c62a                	sw	a0,12(sp)
80023676:	87ae                	mv	a5,a1
80023678:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_PRESET_MASK)
8002367c:	4732                	lw	a4,12(sp)
8002367e:	6789                	lui	a5,0x2
80023680:	97ba                	add	a5,a5,a4
80023682:	439c                	lw	a5,0(a5)
80023684:	ff07f713          	and	a4,a5,-16
                | SYSCTL_GLOBAL00_PRESET_SET(preset);
80023688:	00b14783          	lbu	a5,11(sp)
8002368c:	8bbd                	and	a5,a5,15
8002368e:	8f5d                	or	a4,a4,a5
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_PRESET_MASK)
80023690:	46b2                	lw	a3,12(sp)
80023692:	6789                	lui	a5,0x2
80023694:	97b6                	add	a5,a5,a3
80023696:	c398                	sw	a4,0(a5)
}
80023698:	0001                	nop
8002369a:	0141                	add	sp,sp,16
8002369c:	8082                	ret

Disassembly of section .text.init_uart_pins:

8002369e <init_uart_pins>:
{
8002369e:	1141                	add	sp,sp,-16
800236a0:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
800236a2:	4732                	lw	a4,12(sp)
800236a4:	f00407b7          	lui	a5,0xf0040
800236a8:	02f71f63          	bne	a4,a5,800236e6 <.L5>
        HPM_IOC->PAD[IOC_PAD_PY07].FUNC_CTL = IOC_PY07_FUNC_CTL_UART0_RXD;
800236ac:	f4040737          	lui	a4,0xf4040
800236b0:	6785                	lui	a5,0x1
800236b2:	97ba                	add	a5,a5,a4
800236b4:	4709                	li	a4,2
800236b6:	e2e7ac23          	sw	a4,-456(a5) # e38 <__ILM_segment_used_end__+0xafa>
        HPM_IOC->PAD[IOC_PAD_PY06].FUNC_CTL = IOC_PY06_FUNC_CTL_UART0_TXD;
800236ba:	f4040737          	lui	a4,0xf4040
800236be:	6785                	lui	a5,0x1
800236c0:	97ba                	add	a5,a5,a4
800236c2:	4709                	li	a4,2
800236c4:	e2e7a823          	sw	a4,-464(a5) # e30 <__ILM_segment_used_end__+0xaf2>
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_SOC_PY_07;
800236c8:	f40d8737          	lui	a4,0xf40d8
800236cc:	6785                	lui	a5,0x1
800236ce:	97ba                	add	a5,a5,a4
800236d0:	470d                	li	a4,3
800236d2:	e2e7ac23          	sw	a4,-456(a5) # e38 <__ILM_segment_used_end__+0xafa>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_SOC_PY_06;
800236d6:	f40d8737          	lui	a4,0xf40d8
800236da:	6785                	lui	a5,0x1
800236dc:	97ba                	add	a5,a5,a4
800236de:	470d                	li	a4,3
800236e0:	e2e7a823          	sw	a4,-464(a5) # e30 <__ILM_segment_used_end__+0xaf2>
}
800236e4:	a8c5                	j	800237d4 <.L11>

800236e6 <.L5>:
    } else if (ptr == HPM_UART6) {
800236e6:	4732                	lw	a4,12(sp)
800236e8:	f00587b7          	lui	a5,0xf0058
800236ec:	00f71d63          	bne	a4,a5,80023706 <.L7>
        HPM_IOC->PAD[IOC_PAD_PE27].FUNC_CTL = IOC_PE27_FUNC_CTL_UART6_RXD;
800236f0:	f40407b7          	lui	a5,0xf4040
800236f4:	4709                	li	a4,2
800236f6:	4ce7ac23          	sw	a4,1240(a5) # f40404d8 <__AHB_SRAM_segment_end__+0x3d384d8>
        HPM_IOC->PAD[IOC_PAD_PE28].FUNC_CTL = IOC_PE28_FUNC_CTL_UART6_TXD;
800236fa:	f40407b7          	lui	a5,0xf4040
800236fe:	4709                	li	a4,2
80023700:	4ee7a023          	sw	a4,1248(a5) # f40404e0 <__AHB_SRAM_segment_end__+0x3d384e0>
}
80023704:	a8c1                	j	800237d4 <.L11>

80023706 <.L7>:
    } else if (ptr == HPM_UART7) {
80023706:	4732                	lw	a4,12(sp)
80023708:	f005c7b7          	lui	a5,0xf005c
8002370c:	00f71d63          	bne	a4,a5,80023726 <.L8>
        HPM_IOC->PAD[IOC_PAD_PC02].FUNC_CTL = IOC_PC02_FUNC_CTL_UART7_RXD;
80023710:	f40407b7          	lui	a5,0xf4040
80023714:	4709                	li	a4,2
80023716:	20e7a823          	sw	a4,528(a5) # f4040210 <__AHB_SRAM_segment_end__+0x3d38210>
        HPM_IOC->PAD[IOC_PAD_PC03].FUNC_CTL = IOC_PC03_FUNC_CTL_UART7_TXD;
8002371a:	f40407b7          	lui	a5,0xf4040
8002371e:	4709                	li	a4,2
80023720:	20e7ac23          	sw	a4,536(a5) # f4040218 <__AHB_SRAM_segment_end__+0x3d38218>
}
80023724:	a845                	j	800237d4 <.L11>

80023726 <.L8>:
    } else if (ptr == HPM_UART13) {
80023726:	4732                	lw	a4,12(sp)
80023728:	f00747b7          	lui	a5,0xf0074
8002372c:	02f71f63          	bne	a4,a5,8002376a <.L9>
        HPM_IOC->PAD[IOC_PAD_PZ08].FUNC_CTL = IOC_PZ08_FUNC_CTL_UART13_RXD;
80023730:	f4040737          	lui	a4,0xf4040
80023734:	6785                	lui	a5,0x1
80023736:	97ba                	add	a5,a5,a4
80023738:	4709                	li	a4,2
8002373a:	f4e7a023          	sw	a4,-192(a5) # f40 <__ILM_segment_used_end__+0xc02>
        HPM_IOC->PAD[IOC_PAD_PZ09].FUNC_CTL = IOC_PZ09_FUNC_CTL_UART13_TXD;
8002373e:	f4040737          	lui	a4,0xf4040
80023742:	6785                	lui	a5,0x1
80023744:	97ba                	add	a5,a5,a4
80023746:	4709                	li	a4,2
80023748:	f4e7a423          	sw	a4,-184(a5) # f48 <__ILM_segment_used_end__+0xc0a>
        HPM_BIOC->PAD[IOC_PAD_PZ08].FUNC_CTL = BIOC_PZ08_FUNC_CTL_SOC_PZ_08;
8002374c:	f5010737          	lui	a4,0xf5010
80023750:	6785                	lui	a5,0x1
80023752:	97ba                	add	a5,a5,a4
80023754:	470d                	li	a4,3
80023756:	f4e7a023          	sw	a4,-192(a5) # f40 <__ILM_segment_used_end__+0xc02>
        HPM_BIOC->PAD[IOC_PAD_PZ09].FUNC_CTL = BIOC_PZ09_FUNC_CTL_SOC_PZ_09;
8002375a:	f5010737          	lui	a4,0xf5010
8002375e:	6785                	lui	a5,0x1
80023760:	97ba                	add	a5,a5,a4
80023762:	470d                	li	a4,3
80023764:	f4e7a423          	sw	a4,-184(a5) # f48 <__ILM_segment_used_end__+0xc0a>
}
80023768:	a0b5                	j	800237d4 <.L11>

8002376a <.L9>:
    } else if (ptr == HPM_UART14) {
8002376a:	4732                	lw	a4,12(sp)
8002376c:	f00787b7          	lui	a5,0xf0078
80023770:	02f71f63          	bne	a4,a5,800237ae <.L10>
        HPM_IOC->PAD[IOC_PAD_PZ10].FUNC_CTL = IOC_PZ10_FUNC_CTL_UART14_RXD;
80023774:	f4040737          	lui	a4,0xf4040
80023778:	6785                	lui	a5,0x1
8002377a:	97ba                	add	a5,a5,a4
8002377c:	4709                	li	a4,2
8002377e:	f4e7a823          	sw	a4,-176(a5) # f50 <__ILM_segment_used_end__+0xc12>
        HPM_IOC->PAD[IOC_PAD_PZ11].FUNC_CTL = IOC_PZ11_FUNC_CTL_UART14_TXD;
80023782:	f4040737          	lui	a4,0xf4040
80023786:	6785                	lui	a5,0x1
80023788:	97ba                	add	a5,a5,a4
8002378a:	4709                	li	a4,2
8002378c:	f4e7ac23          	sw	a4,-168(a5) # f58 <__ILM_segment_used_end__+0xc1a>
        HPM_BIOC->PAD[IOC_PAD_PZ10].FUNC_CTL = BIOC_PZ10_FUNC_CTL_SOC_PZ_10;
80023790:	f5010737          	lui	a4,0xf5010
80023794:	6785                	lui	a5,0x1
80023796:	97ba                	add	a5,a5,a4
80023798:	470d                	li	a4,3
8002379a:	f4e7a823          	sw	a4,-176(a5) # f50 <__ILM_segment_used_end__+0xc12>
        HPM_BIOC->PAD[IOC_PAD_PZ11].FUNC_CTL = BIOC_PZ11_FUNC_CTL_SOC_PZ_11;
8002379e:	f5010737          	lui	a4,0xf5010
800237a2:	6785                	lui	a5,0x1
800237a4:	97ba                	add	a5,a5,a4
800237a6:	470d                	li	a4,3
800237a8:	f4e7ac23          	sw	a4,-168(a5) # f58 <__ILM_segment_used_end__+0xc1a>
}
800237ac:	a025                	j	800237d4 <.L11>

800237ae <.L10>:
    } else if (ptr == HPM_PUART) {
800237ae:	4732                	lw	a4,12(sp)
800237b0:	f40e47b7          	lui	a5,0xf40e4
800237b4:	02f71063          	bne	a4,a5,800237d4 <.L11>
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_PUART_RXD;
800237b8:	f40d8737          	lui	a4,0xf40d8
800237bc:	6785                	lui	a5,0x1
800237be:	97ba                	add	a5,a5,a4
800237c0:	4705                	li	a4,1
800237c2:	e2e7ac23          	sw	a4,-456(a5) # e38 <__ILM_segment_used_end__+0xafa>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_PUART_TXD;
800237c6:	f40d8737          	lui	a4,0xf40d8
800237ca:	6785                	lui	a5,0x1
800237cc:	97ba                	add	a5,a5,a4
800237ce:	4705                	li	a4,1
800237d0:	e2e7a823          	sw	a4,-464(a5) # e30 <__ILM_segment_used_end__+0xaf2>

800237d4 <.L11>:
}
800237d4:	0001                	nop
800237d6:	0141                	add	sp,sp,16
800237d8:	8082                	ret

Disassembly of section .text.board_init_console:

800237da <board_init_console>:
{
800237da:	1101                	add	sp,sp,-32
800237dc:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
800237de:	f0040537          	lui	a0,0xf0040
800237e2:	3d75                	jal	8002369e <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
800237e4:	4581                	li	a1,0
800237e6:	012207b7          	lui	a5,0x1220
800237ea:	01378513          	add	a0,a5,19 # 1220013 <__SHARE_RAM_segment_end__+0xa0013>
800237ee:	b4efe0ef          	jal	80021b3c <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
800237f2:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t) BOARD_CONSOLE_UART_BASE;
800237f4:	f00407b7          	lui	a5,0xf0040
800237f8:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
800237fa:	012207b7          	lui	a5,0x1220
800237fe:	01378513          	add	a0,a5,19 # 1220013 <__SHARE_RAM_segment_end__+0xa0013>
80023802:	930fe0ef          	jal	80021932 <clock_get_frequency>
80023806:	87aa                	mv	a5,a0
80023808:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
8002380a:	67f1                	lui	a5,0x1c
8002380c:	20078793          	add	a5,a5,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80023810:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
80023812:	878a                	mv	a5,sp
80023814:	853e                	mv	a0,a5
80023816:	e86ff0ef          	jal	80022e9c <console_init>
8002381a:	87aa                	mv	a5,a0
8002381c:	c391                	beqz	a5,80023820 <.L15>

8002381e <.L14>:
        while (1) {
8002381e:	a001                	j	8002381e <.L14>

80023820 <.L15>:
}
80023820:	0001                	nop
80023822:	40f2                	lw	ra,28(sp)
80023824:	6105                	add	sp,sp,32
80023826:	8082                	ret

Disassembly of section .text.board_delay_ms:

80023828 <board_delay_ms>:
{
80023828:	1101                	add	sp,sp,-32
8002382a:	ce06                	sw	ra,28(sp)
8002382c:	c62a                	sw	a0,12(sp)
    clock_cpu_delay_ms(ms);
8002382e:	4532                	lw	a0,12(sp)
80023830:	b46fe0ef          	jal	80021b76 <clock_cpu_delay_ms>
}
80023834:	0001                	nop
80023836:	40f2                	lw	ra,28(sp)
80023838:	6105                	add	sp,sp,32
8002383a:	8082                	ret

Disassembly of section .text.gpio_set_pin_output:

8002383c <gpio_set_pin_output>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_set_pin_output(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
8002383c:	1141                	add	sp,sp,-16
8002383e:	c62a                	sw	a0,12(sp)
80023840:	c42e                	sw	a1,8(sp)
80023842:	87b2                	mv	a5,a2
80023844:	00f103a3          	sb	a5,7(sp)
    ptr->OE[port].SET = 1 << pin;
80023848:	00714783          	lbu	a5,7(sp)
8002384c:	4705                	li	a4,1
8002384e:	00f717b3          	sll	a5,a4,a5
80023852:	86be                	mv	a3,a5
80023854:	4732                	lw	a4,12(sp)
80023856:	47a2                	lw	a5,8(sp)
80023858:	02078793          	add	a5,a5,32
8002385c:	0792                	sll	a5,a5,0x4
8002385e:	97ba                	add	a5,a5,a4
80023860:	c3d4                	sw	a3,4(a5)
}
80023862:	0001                	nop
80023864:	0141                	add	sp,sp,16
80023866:	8082                	ret

Disassembly of section .text.led_init:

80023868 <led_init>:
{
80023868:	1141                	add	sp,sp,-16
8002386a:	c606                	sw	ra,12(sp)
    HPM_IOC->PAD[IOC_PAD_PB04].FUNC_CTL = IOC_PB04_FUNC_CTL_GPIO_B_04;
8002386c:	f40407b7          	lui	a5,0xf4040
80023870:	1207a023          	sw	zero,288(a5) # f4040120 <__AHB_SRAM_segment_end__+0x3d38120>
    gpio_set_pin_output(LED_PIN);
80023874:	4611                	li	a2,4
80023876:	4585                	li	a1,1
80023878:	f0000537          	lui	a0,0xf0000
8002387c:	37c1                	jal	8002383c <gpio_set_pin_output>
}
8002387e:	0001                	nop
80023880:	40b2                	lw	ra,12(sp)
80023882:	0141                	add	sp,sp,16
80023884:	8082                	ret

Disassembly of section .text._clean_up:

80023886 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
80023886:	7139                	add	sp,sp,-64

80023888 <.LBB18>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80023888:	6785                	lui	a5,0x1
8002388a:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x4c2>
8002388e:	3047b073          	csrc	mie,a5
}
80023892:	0001                	nop
80023894:	da02                	sw	zero,52(sp)
80023896:	d802                	sw	zero,48(sp)
80023898:	e40007b7          	lui	a5,0xe4000
8002389c:	d63e                	sw	a5,44(sp)
8002389e:	57d2                	lw	a5,52(sp)
800238a0:	d43e                	sw	a5,40(sp)
800238a2:	57c2                	lw	a5,48(sp)
800238a4:	d23e                	sw	a5,36(sp)

800238a6 <.LBB20>:
                                                           uint32_t target,
                                                           uint32_t threshold)
{
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_THRESHOLD_OFFSET +
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
800238a6:	57a2                	lw	a5,40(sp)
800238a8:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
800238ac:	57b2                	lw	a5,44(sp)
800238ae:	973e                	add	a4,a4,a5
800238b0:	002007b7          	lui	a5,0x200
800238b4:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
800238b6:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
800238b8:	5782                	lw	a5,32(sp)
800238ba:	5712                	lw	a4,36(sp)
800238bc:	c398                	sw	a4,0(a5)
}
800238be:	0001                	nop

800238c0 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
800238c0:	0001                	nop

800238c2 <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
800238c2:	de02                	sw	zero,60(sp)
800238c4:	a82d                	j	800238fe <.L2>

800238c6 <.L3>:
800238c6:	ce02                	sw	zero,28(sp)
800238c8:	57f2                	lw	a5,60(sp)
800238ca:	cc3e                	sw	a5,24(sp)
800238cc:	e40007b7          	lui	a5,0xe4000
800238d0:	ca3e                	sw	a5,20(sp)
800238d2:	47f2                	lw	a5,28(sp)
800238d4:	c83e                	sw	a5,16(sp)
800238d6:	47e2                	lw	a5,24(sp)
800238d8:	c63e                	sw	a5,12(sp)

800238da <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
800238da:	47c2                	lw	a5,16(sp)
800238dc:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
800238e0:	47d2                	lw	a5,20(sp)
800238e2:	973e                	add	a4,a4,a5
800238e4:	002007b7          	lui	a5,0x200
800238e8:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_end__+0x140004>
800238ea:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
800238ec:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
800238ee:	47a2                	lw	a5,8(sp)
800238f0:	4732                	lw	a4,12(sp)
800238f2:	c398                	sw	a4,0(a5)
}
800238f4:	0001                	nop

800238f6 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
800238f6:	0001                	nop

800238f8 <.LBE25>:
800238f8:	57f2                	lw	a5,60(sp)
800238fa:	0785                	add	a5,a5,1
800238fc:	de3e                	sw	a5,60(sp)

800238fe <.L2>:
800238fe:	5772                	lw	a4,60(sp)
80023900:	07f00793          	li	a5,127
80023904:	fce7f1e3          	bgeu	a5,a4,800238c6 <.L3>

80023908 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
80023908:	dc02                	sw	zero,56(sp)
8002390a:	a821                	j	80023922 <.L4>

8002390c <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
8002390c:	57e2                	lw	a5,56(sp)
8002390e:	00279713          	sll	a4,a5,0x2
80023912:	e40027b7          	lui	a5,0xe4002
80023916:	97ba                	add	a5,a5,a4
80023918:	0007a023          	sw	zero,0(a5) # e4002000 <__XPI0_segment_end__+0x63802000>
    for (uint32_t i = 0; i < 4; i++) {
8002391c:	57e2                	lw	a5,56(sp)
8002391e:	0785                	add	a5,a5,1
80023920:	dc3e                	sw	a5,56(sp)

80023922 <.L4>:
80023922:	5762                	lw	a4,56(sp)
80023924:	478d                	li	a5,3
80023926:	fee7f3e3          	bgeu	a5,a4,8002390c <.L5>

8002392a <.LBE29>:
    }
}
8002392a:	0001                	nop
8002392c:	0001                	nop
8002392e:	6121                	add	sp,sp,64
80023930:	8082                	ret

Disassembly of section .text.reset_handler:

80023932 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
80023932:	1141                	add	sp,sp,-16
80023934:	c606                	sw	ra,12(sp)
    fencei();
80023936:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
8002393a:	c60fe0ef          	jal	80021d9a <system_init>

    /* Entry function */
    MAIN_ENTRY();
8002393e:	ed3fd0ef          	jal	80021810 <main>
}
80023942:	0001                	nop
80023944:	40b2                	lw	ra,12(sp)
80023946:	0141                	add	sp,sp,16
80023948:	8082                	ret

Disassembly of section .text._init:

8002394a <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
8002394a:	0001                	nop
8002394c:	8082                	ret

Disassembly of section .text.mchtmr_isr:

8002394e <mchtmr_isr>:
}
8002394e:	0001                	nop
80023950:	8082                	ret

Disassembly of section .text.swi_isr:

80023952 <swi_isr>:
}
80023952:	0001                	nop
80023954:	8082                	ret

Disassembly of section .text.exception_handler:

80023956 <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
80023956:	1141                	add	sp,sp,-16
80023958:	c62a                	sw	a0,12(sp)
8002395a:	c42e                	sw	a1,8(sp)
    switch (cause) {
8002395c:	4732                	lw	a4,12(sp)
8002395e:	47bd                	li	a5,15
80023960:	00e7ea63          	bltu	a5,a4,80023974 <.L23>
80023964:	47b2                	lw	a5,12(sp)
80023966:	00279713          	sll	a4,a5,0x2
8002396a:	92818793          	add	a5,gp,-1752 # 800201cc <.L7>
8002396e:	97ba                	add	a5,a5,a4
80023970:	439c                	lw	a5,0(a5)
80023972:	8782                	jr	a5

80023974 <.L23>:
        case MCAUSE_LOAD_PAGE_FAULT:
            break;
        case MCAUSE_STORE_AMO_PAGE_FAULT:
            break;
        default:
            break;
80023974:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
80023976:	47a2                	lw	a5,8(sp)
}
80023978:	853e                	mv	a0,a5
8002397a:	0141                	add	sp,sp,16
8002397c:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

8002397e <get_frequency_for_source>:
{
8002397e:	7179                	add	sp,sp,-48
80023980:	d606                	sw	ra,44(sp)
80023982:	87aa                	mv	a5,a0
80023984:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80023988:	ce02                	sw	zero,28(sp)
    uint32_t div = 1;
8002398a:	4785                	li	a5,1
8002398c:	cc3e                	sw	a5,24(sp)
    switch (source) {
8002398e:	00f14783          	lbu	a5,15(sp)
80023992:	471d                	li	a4,7
80023994:	0cf76663          	bltu	a4,a5,80023a60 <.L36>
80023998:	00279713          	sll	a4,a5,0x2
8002399c:	9b418793          	add	a5,gp,-1612 # 80020258 <.L38>
800239a0:	97ba                	add	a5,a5,a4
800239a2:	439c                	lw	a5,0(a5)
800239a4:	8782                	jr	a5

800239a6 <.L45>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
800239a6:	016e37b7          	lui	a5,0x16e3
800239aa:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
800239ae:	ce3e                	sw	a5,28(sp)
        break;
800239b0:	a855                	j	80023a64 <.L46>

800239b2 <.L44>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 0U);
800239b2:	4581                	li	a1,0
800239b4:	f4100537          	lui	a0,0xf4100
800239b8:	3861                	jal	80023250 <pllctl_get_pll_freq_in_hz>
800239ba:	ce2a                	sw	a0,28(sp)
        break;
800239bc:	a065                	j	80023a64 <.L46>

800239be <.L43>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 0);
800239be:	4601                	li	a2,0
800239c0:	4585                	li	a1,1
800239c2:	f4100537          	lui	a0,0xf4100
800239c6:	f03fd0ef          	jal	800218c8 <pllctl_get_div>
800239ca:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
800239cc:	4585                	li	a1,1
800239ce:	f4100537          	lui	a0,0xf4100
800239d2:	38bd                	jal	80023250 <pllctl_get_pll_freq_in_hz>
800239d4:	872a                	mv	a4,a0
800239d6:	47e2                	lw	a5,24(sp)
800239d8:	02f757b3          	divu	a5,a4,a5
800239dc:	ce3e                	sw	a5,28(sp)
        break;
800239de:	a059                	j	80023a64 <.L46>

800239e0 <.L42>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 1);
800239e0:	4605                	li	a2,1
800239e2:	4585                	li	a1,1
800239e4:	f4100537          	lui	a0,0xf4100
800239e8:	ee1fd0ef          	jal	800218c8 <pllctl_get_div>
800239ec:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
800239ee:	4585                	li	a1,1
800239f0:	f4100537          	lui	a0,0xf4100
800239f4:	38b1                	jal	80023250 <pllctl_get_pll_freq_in_hz>
800239f6:	872a                	mv	a4,a0
800239f8:	47e2                	lw	a5,24(sp)
800239fa:	02f757b3          	divu	a5,a4,a5
800239fe:	ce3e                	sw	a5,28(sp)
        break;
80023a00:	a095                	j	80023a64 <.L46>

80023a02 <.L41>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 0);
80023a02:	4601                	li	a2,0
80023a04:	4589                	li	a1,2
80023a06:	f4100537          	lui	a0,0xf4100
80023a0a:	ebffd0ef          	jal	800218c8 <pllctl_get_div>
80023a0e:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
80023a10:	4589                	li	a1,2
80023a12:	f4100537          	lui	a0,0xf4100
80023a16:	382d                	jal	80023250 <pllctl_get_pll_freq_in_hz>
80023a18:	872a                	mv	a4,a0
80023a1a:	47e2                	lw	a5,24(sp)
80023a1c:	02f757b3          	divu	a5,a4,a5
80023a20:	ce3e                	sw	a5,28(sp)
        break;
80023a22:	a089                	j	80023a64 <.L46>

80023a24 <.L40>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 1);
80023a24:	4605                	li	a2,1
80023a26:	4589                	li	a1,2
80023a28:	f4100537          	lui	a0,0xf4100
80023a2c:	e9dfd0ef          	jal	800218c8 <pllctl_get_div>
80023a30:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
80023a32:	4589                	li	a1,2
80023a34:	f4100537          	lui	a0,0xf4100
80023a38:	3821                	jal	80023250 <pllctl_get_pll_freq_in_hz>
80023a3a:	872a                	mv	a4,a0
80023a3c:	47e2                	lw	a5,24(sp)
80023a3e:	02f757b3          	divu	a5,a4,a5
80023a42:	ce3e                	sw	a5,28(sp)
        break;
80023a44:	a005                	j	80023a64 <.L46>

80023a46 <.L39>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 3U);
80023a46:	458d                	li	a1,3
80023a48:	f4100537          	lui	a0,0xf4100
80023a4c:	3011                	jal	80023250 <pllctl_get_pll_freq_in_hz>
80023a4e:	ce2a                	sw	a0,28(sp)
        break;
80023a50:	a811                	j	80023a64 <.L46>

80023a52 <.L37>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 4U);
80023a52:	4591                	li	a1,4
80023a54:	f4100537          	lui	a0,0xf4100
80023a58:	ff8ff0ef          	jal	80023250 <pllctl_get_pll_freq_in_hz>
80023a5c:	ce2a                	sw	a0,28(sp)
        break;
80023a5e:	a019                	j	80023a64 <.L46>

80023a60 <.L36>:
        clk_freq = 0UL;
80023a60:	ce02                	sw	zero,28(sp)
        break;
80023a62:	0001                	nop

80023a64 <.L46>:
    return clk_freq;
80023a64:	47f2                	lw	a5,28(sp)
}
80023a66:	853e                	mv	a0,a5
80023a68:	50b2                	lw	ra,44(sp)
80023a6a:	6145                	add	sp,sp,48
80023a6c:	8082                	ret

Disassembly of section .text.get_frequency_for_i2s_or_adc:

80023a6e <get_frequency_for_i2s_or_adc>:
{
80023a6e:	7139                	add	sp,sp,-64
80023a70:	de06                	sw	ra,60(sp)
80023a72:	c62a                	sw	a0,12(sp)
80023a74:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
80023a76:	d602                	sw	zero,44(sp)
    bool is_mux_valid = false;
80023a78:	020105a3          	sb	zero,43(sp)
    clock_node_t node = clock_node_end;
80023a7c:	04b00793          	li	a5,75
80023a80:	02f10523          	sb	a5,42(sp)
    if (clk_src_type == CLK_SRC_GROUP_ADC) {
80023a84:	4732                	lw	a4,12(sp)
80023a86:	4785                	li	a5,1
80023a88:	04f71363          	bne	a4,a5,80023ace <.L52>

80023a8c <.LBB7>:
        uint32_t adc_index = instance;
80023a8c:	47a2                	lw	a5,8(sp)
80023a8e:	ce3e                	sw	a5,28(sp)
        if (adc_index < ADC_INSTANCE_NUM) {
80023a90:	4772                	lw	a4,28(sp)
80023a92:	478d                	li	a5,3
80023a94:	06e7ed63          	bltu	a5,a4,80023b0e <.L53>

80023a98 <.LBB8>:
            uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
80023a98:	f4000737          	lui	a4,0xf4000
80023a9c:	47f2                	lw	a5,28(sp)
80023a9e:	70078793          	add	a5,a5,1792
80023aa2:	078a                	sll	a5,a5,0x2
80023aa4:	97ba                	add	a5,a5,a4
80023aa6:	439c                	lw	a5,0(a5)
80023aa8:	83a1                	srl	a5,a5,0x8
80023aaa:	8b9d                	and	a5,a5,7
80023aac:	cc3e                	sw	a5,24(sp)
            if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
80023aae:	4762                	lw	a4,24(sp)
80023ab0:	478d                	li	a5,3
80023ab2:	04e7ee63          	bltu	a5,a4,80023b0e <.L53>
                node = s_adc_clk_mux_node[mux_in_reg];
80023ab6:	96818713          	add	a4,gp,-1688 # 8002020c <s_adc_clk_mux_node>
80023aba:	47e2                	lw	a5,24(sp)
80023abc:	97ba                	add	a5,a5,a4
80023abe:	0007c783          	lbu	a5,0(a5)
80023ac2:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
80023ac6:	4785                	li	a5,1
80023ac8:	02f105a3          	sb	a5,43(sp)
80023acc:	a089                	j	80023b0e <.L53>

80023ace <.L52>:
        uint32_t i2s_index = instance;
80023ace:	47a2                	lw	a5,8(sp)
80023ad0:	d23e                	sw	a5,36(sp)
        if (i2s_index < I2S_INSTANCE_NUM) {
80023ad2:	5712                	lw	a4,36(sp)
80023ad4:	478d                	li	a5,3
80023ad6:	02e7ec63          	bltu	a5,a4,80023b0e <.L53>

80023ada <.LBB10>:
            uint32_t mux_in_reg = SYSCTL_I2SCLK_MUX_GET(HPM_SYSCTL->I2SCLK[i2s_index]);
80023ada:	f4000737          	lui	a4,0xf4000
80023ade:	5792                	lw	a5,36(sp)
80023ae0:	70478793          	add	a5,a5,1796
80023ae4:	078a                	sll	a5,a5,0x2
80023ae6:	97ba                	add	a5,a5,a4
80023ae8:	439c                	lw	a5,0(a5)
80023aea:	83a1                	srl	a5,a5,0x8
80023aec:	8b9d                	and	a5,a5,7
80023aee:	d03e                	sw	a5,32(sp)
            if (mux_in_reg < ARRAY_SIZE(s_i2s_clk_mux_node)) {
80023af0:	5702                	lw	a4,32(sp)
80023af2:	478d                	li	a5,3
80023af4:	00e7ed63          	bltu	a5,a4,80023b0e <.L53>
                node = s_i2s_clk_mux_node[mux_in_reg];
80023af8:	96c18713          	add	a4,gp,-1684 # 80020210 <s_i2s_clk_mux_node>
80023afc:	5782                	lw	a5,32(sp)
80023afe:	97ba                	add	a5,a5,a4
80023b00:	0007c783          	lbu	a5,0(a5)
80023b04:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
80023b08:	4785                	li	a5,1
80023b0a:	02f105a3          	sb	a5,43(sp)

80023b0e <.L53>:
    if (is_mux_valid) {
80023b0e:	02b14783          	lbu	a5,43(sp)
80023b12:	c38d                	beqz	a5,80023b34 <.L54>
        if (node == clock_node_ahb0) {
80023b14:	02a14703          	lbu	a4,42(sp)
80023b18:	479d                	li	a5,7
80023b1a:	00f71763          	bne	a4,a5,80023b28 <.L55>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
80023b1e:	451d                	li	a0,7
80023b20:	ed7fd0ef          	jal	800219f6 <get_frequency_for_ip_in_common_group>
80023b24:	d62a                	sw	a0,44(sp)
80023b26:	a039                	j	80023b34 <.L54>

80023b28 <.L55>:
            clk_freq = get_frequency_for_ip_in_common_group(node);
80023b28:	02a14783          	lbu	a5,42(sp)
80023b2c:	853e                	mv	a0,a5
80023b2e:	ec9fd0ef          	jal	800219f6 <get_frequency_for_ip_in_common_group>
80023b32:	d62a                	sw	a0,44(sp)

80023b34 <.L54>:
    return clk_freq;
80023b34:	57b2                	lw	a5,44(sp)
}
80023b36:	853e                	mv	a0,a5
80023b38:	50f2                	lw	ra,60(sp)
80023b3a:	6121                	add	sp,sp,64
80023b3c:	8082                	ret

Disassembly of section .text.get_frequency_for_wdg:

80023b3e <get_frequency_for_wdg>:
{
80023b3e:	7179                	add	sp,sp,-48
80023b40:	d606                	sw	ra,44(sp)
80023b42:	c62a                	sw	a0,12(sp)
    if (WDG_CTRL_CLKSEL_GET(s_wdgs[instance]->CTRL) == 0) {
80023b44:	97018713          	add	a4,gp,-1680 # 80020214 <s_wdgs>
80023b48:	47b2                	lw	a5,12(sp)
80023b4a:	078a                	sll	a5,a5,0x2
80023b4c:	97ba                	add	a5,a5,a4
80023b4e:	439c                	lw	a5,0(a5)
80023b50:	4b9c                	lw	a5,16(a5)
80023b52:	8b89                	and	a5,a5,2
80023b54:	e791                	bnez	a5,80023b60 <.L58>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
80023b56:	451d                	li	a0,7
80023b58:	e9ffd0ef          	jal	800219f6 <get_frequency_for_ip_in_common_group>
80023b5c:	ce2a                	sw	a0,28(sp)
80023b5e:	a019                	j	80023b64 <.L59>

80023b60 <.L58>:
        freq_in_hz = FREQ_32KHz;
80023b60:	67a1                	lui	a5,0x8
80023b62:	ce3e                	sw	a5,28(sp)

80023b64 <.L59>:
    return freq_in_hz;
80023b64:	47f2                	lw	a5,28(sp)
}
80023b66:	853e                	mv	a0,a5
80023b68:	50b2                	lw	ra,44(sp)
80023b6a:	6145                	add	sp,sp,48
80023b6c:	8082                	ret

Disassembly of section .text.get_frequency_for_pwdg:

80023b6e <get_frequency_for_pwdg>:
{
80023b6e:	1141                	add	sp,sp,-16
    if (WDG_CTRL_CLKSEL_GET(HPM_PWDG->CTRL) == 0) {
80023b70:	f40e87b7          	lui	a5,0xf40e8
80023b74:	4b9c                	lw	a5,16(a5)
80023b76:	8b89                	and	a5,a5,2
80023b78:	e799                	bnez	a5,80023b86 <.L62>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
80023b7a:	016e37b7          	lui	a5,0x16e3
80023b7e:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80023b82:	c63e                	sw	a5,12(sp)
80023b84:	a019                	j	80023b8a <.L63>

80023b86 <.L62>:
        freq_in_hz = FREQ_32KHz;
80023b86:	67a1                	lui	a5,0x8
80023b88:	c63e                	sw	a5,12(sp)

80023b8a <.L63>:
    return freq_in_hz;
80023b8a:	47b2                	lw	a5,12(sp)
}
80023b8c:	853e                	mv	a0,a5
80023b8e:	0141                	add	sp,sp,16
80023b90:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

80023b92 <clock_connect_group_to_cpu>:
{
80023b92:	1141                	add	sp,sp,-16
80023b94:	c62a                	sw	a0,12(sp)
80023b96:	c42e                	sw	a1,8(sp)
    if (cpu < 2U) {
80023b98:	4722                	lw	a4,8(sp)
80023b9a:	4785                	li	a5,1
80023b9c:	00e7ee63          	bltu	a5,a4,80023bb8 <.L173>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
80023ba0:	f40006b7          	lui	a3,0xf4000
80023ba4:	47b2                	lw	a5,12(sp)
80023ba6:	4705                	li	a4,1
80023ba8:	00f71733          	sll	a4,a4,a5
80023bac:	47a2                	lw	a5,8(sp)
80023bae:	09078793          	add	a5,a5,144 # 8090 <__AHB_SRAM_segment_size__+0x90>
80023bb2:	0792                	sll	a5,a5,0x4
80023bb4:	97b6                	add	a5,a5,a3
80023bb6:	c3d8                	sw	a4,4(a5)

80023bb8 <.L173>:
}
80023bb8:	0001                	nop
80023bba:	0141                	add	sp,sp,16
80023bbc:	8082                	ret

Disassembly of section .text.clock_get_core_clock_ticks_per_ms:

80023bbe <clock_get_core_clock_ticks_per_ms>:
{
80023bbe:	1141                	add	sp,sp,-16
80023bc0:	c606                	sw	ra,12(sp)
    if (hpm_core_clock == 0U) {
80023bc2:	82c22783          	lw	a5,-2004(tp) # fffff82c <__APB_SRAM_segment_end__+0xbf0d82c>
80023bc6:	e399                	bnez	a5,80023bcc <.L181>
        clock_update_core_clock();
80023bc8:	840fe0ef          	jal	80021c08 <clock_update_core_clock>

80023bcc <.L181>:
    return (hpm_core_clock + FREQ_1MHz - 1U) / 1000;
80023bcc:	82c22703          	lw	a4,-2004(tp) # fffff82c <__APB_SRAM_segment_end__+0xbf0d82c>
80023bd0:	000f47b7          	lui	a5,0xf4
80023bd4:	23f78793          	add	a5,a5,575 # f423f <__DLM_segment_end__+0x3423f>
80023bd8:	973e                	add	a4,a4,a5
80023bda:	3e800793          	li	a5,1000
80023bde:	02f757b3          	divu	a5,a4,a5
}
80023be2:	853e                	mv	a0,a5
80023be4:	40b2                	lw	ra,12(sp)
80023be6:	0141                	add	sp,sp,16
80023be8:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

80023bea <l1c_dc_invalidate_all>:
{
    __asm("fence.i");
}

void l1c_dc_invalidate_all(void)
{
80023bea:	1141                	add	sp,sp,-16
80023bec:	47dd                	li	a5,23
80023bee:	00f107a3          	sb	a5,15(sp)

80023bf2 <.LBB76>:
}

/* send command */
__attribute__((always_inline)) static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
80023bf2:	00f14783          	lbu	a5,15(sp)
80023bf6:	7cc79073          	csrw	0x7cc,a5
}
80023bfa:	0001                	nop

80023bfc <.LBE76>:
    l1c_cctl_cmd(HPM_L1C_CCTL_CMD_L1D_INVAL_ALL);
}
80023bfc:	0001                	nop
80023bfe:	0141                	add	sp,sp,16
80023c00:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

80023c02 <sysctl_enable_group_resource>:
{
80023c02:	7179                	add	sp,sp,-48
80023c04:	d606                	sw	ra,44(sp)
80023c06:	c62a                	sw	a0,12(sp)
80023c08:	87ae                	mv	a5,a1
80023c0a:	8736                	mv	a4,a3
80023c0c:	00f105a3          	sb	a5,11(sp)
80023c10:	87b2                	mv	a5,a2
80023c12:	00f11423          	sh	a5,8(sp)
80023c16:	87ba                	mv	a5,a4
80023c18:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
80023c1c:	00815703          	lhu	a4,8(sp)
80023c20:	0ff00793          	li	a5,255
80023c24:	00e7e463          	bltu	a5,a4,80023c2c <.L60>
        return status_invalid_argument;
80023c28:	4789                	li	a5,2
80023c2a:	a8e5                	j	80023d22 <.L61>

80023c2c <.L60>:
    index = (resource - sysctl_resource_linkable_start) / 32;
80023c2c:	00815783          	lhu	a5,8(sp)
80023c30:	f0078793          	add	a5,a5,-256
80023c34:	41f7d713          	sra	a4,a5,0x1f
80023c38:	8b7d                	and	a4,a4,31
80023c3a:	97ba                	add	a5,a5,a4
80023c3c:	8795                	sra	a5,a5,0x5
80023c3e:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
80023c40:	00815783          	lhu	a5,8(sp)
80023c44:	f0078713          	add	a4,a5,-256
80023c48:	41f75793          	sra	a5,a4,0x1f
80023c4c:	83ed                	srl	a5,a5,0x1b
80023c4e:	973e                	add	a4,a4,a5
80023c50:	8b7d                	and	a4,a4,31
80023c52:	40f707b3          	sub	a5,a4,a5
80023c56:	cc3e                	sw	a5,24(sp)
    switch (group) {
80023c58:	00b14783          	lbu	a5,11(sp)
80023c5c:	c789                	beqz	a5,80023c66 <.L62>
80023c5e:	4705                	li	a4,1
80023c60:	04e78f63          	beq	a5,a4,80023cbe <.L63>
80023c64:	a84d                	j	80023d16 <.L74>

80023c66 <.L62>:
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
80023c66:	4732                	lw	a4,12(sp)
80023c68:	47f2                	lw	a5,28(sp)
80023c6a:	08078793          	add	a5,a5,128
80023c6e:	0792                	sll	a5,a5,0x4
80023c70:	97ba                	add	a5,a5,a4
80023c72:	4398                	lw	a4,0(a5)
80023c74:	47e2                	lw	a5,24(sp)
80023c76:	4685                	li	a3,1
80023c78:	00f697b3          	sll	a5,a3,a5
80023c7c:	fff7c793          	not	a5,a5
80023c80:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
80023c82:	00a14783          	lbu	a5,10(sp)
80023c86:	c791                	beqz	a5,80023c92 <.L65>
80023c88:	47e2                	lw	a5,24(sp)
80023c8a:	4685                	li	a3,1
80023c8c:	00f697b3          	sll	a5,a3,a5
80023c90:	a011                	j	80023c94 <.L66>

80023c92 <.L65>:
80023c92:	4781                	li	a5,0

80023c94 <.L66>:
80023c94:	8f5d                	or	a4,a4,a5
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
80023c96:	46b2                	lw	a3,12(sp)
80023c98:	47f2                	lw	a5,28(sp)
80023c9a:	08078793          	add	a5,a5,128
80023c9e:	0792                	sll	a5,a5,0x4
80023ca0:	97b6                	add	a5,a5,a3
80023ca2:	c398                	sw	a4,0(a5)
        if (enable) {
80023ca4:	00a14783          	lbu	a5,10(sp)
80023ca8:	cbad                	beqz	a5,80023d1a <.L75>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
80023caa:	0001                	nop

80023cac <.L68>:
80023cac:	00815783          	lhu	a5,8(sp)
80023cb0:	85be                	mv	a1,a5
80023cb2:	4532                	lw	a0,12(sp)
80023cb4:	fedfd0ef          	jal	80021ca0 <sysctl_resource_target_is_busy>
80023cb8:	87aa                	mv	a5,a0
80023cba:	fbed                	bnez	a5,80023cac <.L68>
        break;
80023cbc:	a8b9                	j	80023d1a <.L75>

80023cbe <.L63>:
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
80023cbe:	4732                	lw	a4,12(sp)
80023cc0:	47f2                	lw	a5,28(sp)
80023cc2:	08478793          	add	a5,a5,132
80023cc6:	0792                	sll	a5,a5,0x4
80023cc8:	97ba                	add	a5,a5,a4
80023cca:	4398                	lw	a4,0(a5)
80023ccc:	47e2                	lw	a5,24(sp)
80023cce:	4685                	li	a3,1
80023cd0:	00f697b3          	sll	a5,a3,a5
80023cd4:	fff7c793          	not	a5,a5
80023cd8:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
80023cda:	00a14783          	lbu	a5,10(sp)
80023cde:	c791                	beqz	a5,80023cea <.L70>
80023ce0:	47e2                	lw	a5,24(sp)
80023ce2:	4685                	li	a3,1
80023ce4:	00f697b3          	sll	a5,a3,a5
80023ce8:	a011                	j	80023cec <.L71>

80023cea <.L70>:
80023cea:	4781                	li	a5,0

80023cec <.L71>:
80023cec:	8f5d                	or	a4,a4,a5
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
80023cee:	46b2                	lw	a3,12(sp)
80023cf0:	47f2                	lw	a5,28(sp)
80023cf2:	08478793          	add	a5,a5,132
80023cf6:	0792                	sll	a5,a5,0x4
80023cf8:	97b6                	add	a5,a5,a3
80023cfa:	c398                	sw	a4,0(a5)
        if (enable) {
80023cfc:	00a14783          	lbu	a5,10(sp)
80023d00:	cf99                	beqz	a5,80023d1e <.L76>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
80023d02:	0001                	nop

80023d04 <.L73>:
80023d04:	00815783          	lhu	a5,8(sp)
80023d08:	85be                	mv	a1,a5
80023d0a:	4532                	lw	a0,12(sp)
80023d0c:	f95fd0ef          	jal	80021ca0 <sysctl_resource_target_is_busy>
80023d10:	87aa                	mv	a5,a0
80023d12:	fbed                	bnez	a5,80023d04 <.L73>
        break;
80023d14:	a029                	j	80023d1e <.L76>

80023d16 <.L74>:
        return status_invalid_argument;
80023d16:	4789                	li	a5,2
80023d18:	a029                	j	80023d22 <.L61>

80023d1a <.L75>:
        break;
80023d1a:	0001                	nop
80023d1c:	a011                	j	80023d20 <.L69>

80023d1e <.L76>:
        break;
80023d1e:	0001                	nop

80023d20 <.L69>:
    return status_success;
80023d20:	4781                	li	a5,0

80023d22 <.L61>:
}
80023d22:	853e                	mv	a0,a5
80023d24:	50b2                	lw	ra,44(sp)
80023d26:	6145                	add	sp,sp,48
80023d28:	8082                	ret

Disassembly of section .text.enable_plic_feature:

80023d2a <enable_plic_feature>:
{
80023d2a:	1141                	add	sp,sp,-16
    uint32_t plic_feature = 0;
80023d2c:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
80023d2e:	47b2                	lw	a5,12(sp)
80023d30:	0027e793          	or	a5,a5,2
80023d34:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
80023d36:	47b2                	lw	a5,12(sp)
80023d38:	0017e793          	or	a5,a5,1
80023d3c:	c63e                	sw	a5,12(sp)
80023d3e:	e40007b7          	lui	a5,0xe4000
80023d42:	c43e                	sw	a5,8(sp)
80023d44:	47b2                	lw	a5,12(sp)
80023d46:	c23e                	sw	a5,4(sp)

80023d48 <.LBB14>:
 * @param[in] feature Specific feature to be set
 *
 */
ATTR_ALWAYS_INLINE static inline void __plic_set_feature(uint32_t base, uint32_t feature)
{
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
80023d48:	47a2                	lw	a5,8(sp)
80023d4a:	4712                	lw	a4,4(sp)
80023d4c:	c398                	sw	a4,0(a5)
}
80023d4e:	0001                	nop

80023d50 <.LBE14>:
}
80023d50:	0001                	nop
80023d52:	0141                	add	sp,sp,16
80023d54:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

80023d56 <__SEGGER_RTL_puts_no_nl>:
80023d56:	1101                	add	sp,sp,-32
80023d58:	cc22                	sw	s0,24(sp)
80023d5a:	84022403          	lw	s0,-1984(tp) # fffff840 <__APB_SRAM_segment_end__+0xbf0d840>
80023d5e:	ce06                	sw	ra,28(sp)
80023d60:	c62a                	sw	a0,12(sp)
80023d62:	30d000ef          	jal	8002486e <strlen>
80023d66:	862a                	mv	a2,a0
80023d68:	8522                	mv	a0,s0
80023d6a:	4462                	lw	s0,24(sp)
80023d6c:	45b2                	lw	a1,12(sp)
80023d6e:	40f2                	lw	ra,28(sp)
80023d70:	6105                	add	sp,sp,32
80023d72:	988ff06f          	j	80022efa <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.signal:

80023d76 <signal>:
80023d76:	4795                	li	a5,5
80023d78:	02a7e263          	bltu	a5,a0,80023d9c <.L18>
80023d7c:	81420693          	add	a3,tp,-2028 # fffff814 <__APB_SRAM_segment_end__+0xbf0d814>
80023d80:	00251793          	sll	a5,a0,0x2
80023d84:	96be                	add	a3,a3,a5
80023d86:	4288                	lw	a0,0(a3)
80023d88:	81420713          	add	a4,tp,-2028 # fffff814 <__APB_SRAM_segment_end__+0xbf0d814>
80023d8c:	e509                	bnez	a0,80023d96 <.L17>
80023d8e:	80020537          	lui	a0,0x80020
80023d92:	07a50513          	add	a0,a0,122 # 8002007a <__SEGGER_RTL_SIGNAL_SIG_DFL>

80023d96 <.L17>:
80023d96:	973e                	add	a4,a4,a5
80023d98:	c30c                	sw	a1,0(a4)
80023d9a:	8082                	ret

80023d9c <.L18>:
80023d9c:	80022537          	lui	a0,0x80022
80023da0:	e7a50513          	add	a0,a0,-390 # 80021e7a <__SEGGER_RTL_SIGNAL_SIG_ERR>
80023da4:	8082                	ret

Disassembly of section .text.libc.raise:

80023da6 <raise>:
80023da6:	1141                	add	sp,sp,-16
80023da8:	c04a                	sw	s2,0(sp)
80023daa:	80021937          	lui	s2,0x80021
80023dae:	5a290593          	add	a1,s2,1442 # 800215a2 <__SEGGER_RTL_SIGNAL_SIG_IGN>
80023db2:	c226                	sw	s1,4(sp)
80023db4:	c606                	sw	ra,12(sp)
80023db6:	c422                	sw	s0,8(sp)
80023db8:	84aa                	mv	s1,a0
80023dba:	3f75                	jal	80023d76 <signal>
80023dbc:	800227b7          	lui	a5,0x80022
80023dc0:	e7a78793          	add	a5,a5,-390 # 80021e7a <__SEGGER_RTL_SIGNAL_SIG_ERR>
80023dc4:	02f50d63          	beq	a0,a5,80023dfe <.L24>
80023dc8:	5a290913          	add	s2,s2,1442
80023dcc:	842a                	mv	s0,a0
80023dce:	03250163          	beq	a0,s2,80023df0 <.L22>
80023dd2:	800205b7          	lui	a1,0x80020
80023dd6:	07a58793          	add	a5,a1,122 # 8002007a <__SEGGER_RTL_SIGNAL_SIG_DFL>
80023dda:	00f51563          	bne	a0,a5,80023de4 <.L23>
80023dde:	4505                	li	a0,1
80023de0:	a8efc0ef          	jal	8002006e <exit>

80023de4 <.L23>:
80023de4:	07a58593          	add	a1,a1,122
80023de8:	8526                	mv	a0,s1
80023dea:	3771                	jal	80023d76 <signal>
80023dec:	8526                	mv	a0,s1
80023dee:	9402                	jalr	s0

80023df0 <.L22>:
80023df0:	4501                	li	a0,0

80023df2 <.L20>:
80023df2:	40b2                	lw	ra,12(sp)
80023df4:	4422                	lw	s0,8(sp)
80023df6:	4492                	lw	s1,4(sp)
80023df8:	4902                	lw	s2,0(sp)
80023dfa:	0141                	add	sp,sp,16
80023dfc:	8082                	ret

80023dfe <.L24>:
80023dfe:	557d                	li	a0,-1
80023e00:	bfcd                	j	80023df2 <.L20>

Disassembly of section .text.libc.abort:

80023e02 <abort>:
80023e02:	1141                	add	sp,sp,-16
80023e04:	c606                	sw	ra,12(sp)

80023e06 <.L27>:
80023e06:	4501                	li	a0,0
80023e08:	3f79                	jal	80023da6 <raise>
80023e0a:	bff5                	j	80023e06 <.L27>

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

80023e0c <__SEGGER_RTL_X_assert>:
80023e0c:	1101                	add	sp,sp,-32
80023e0e:	cc22                	sw	s0,24(sp)
80023e10:	ca26                	sw	s1,20(sp)
80023e12:	842a                	mv	s0,a0
80023e14:	84ae                	mv	s1,a1
80023e16:	8532                	mv	a0,a2
80023e18:	858a                	mv	a1,sp
80023e1a:	4629                	li	a2,10
80023e1c:	ce06                	sw	ra,28(sp)
80023e1e:	840fe0ef          	jal	80021e5e <itoa>
80023e22:	8526                	mv	a0,s1
80023e24:	3f0d                	jal	80023d56 <__SEGGER_RTL_puts_no_nl>
80023e26:	3e018513          	add	a0,gp,992 # 80020c84 <.LC0>
80023e2a:	3735                	jal	80023d56 <__SEGGER_RTL_puts_no_nl>
80023e2c:	850a                	mv	a0,sp
80023e2e:	3725                	jal	80023d56 <__SEGGER_RTL_puts_no_nl>
80023e30:	3e418513          	add	a0,gp,996 # 80020c88 <.LC1>
80023e34:	370d                	jal	80023d56 <__SEGGER_RTL_puts_no_nl>
80023e36:	8522                	mv	a0,s0
80023e38:	3f39                	jal	80023d56 <__SEGGER_RTL_puts_no_nl>
80023e3a:	3fc18513          	add	a0,gp,1020 # 80020ca0 <.LC2>
80023e3e:	3f21                	jal	80023d56 <__SEGGER_RTL_puts_no_nl>
80023e40:	37c9                	jal	80023e02 <abort>

Disassembly of section .text.libc.__adddf3:

80023e42 <__adddf3>:
80023e42:	800007b7          	lui	a5,0x80000
80023e46:	00d5c8b3          	xor	a7,a1,a3
80023e4a:	1008c263          	bltz	a7,80023f4e <.L__adddf3_subtract>
80023e4e:	00b6e863          	bltu	a3,a1,80023e5e <.L__adddf3_add_already_ordered>
80023e52:	8d31                	xor	a0,a0,a2
80023e54:	8e29                	xor	a2,a2,a0
80023e56:	8d31                	xor	a0,a0,a2
80023e58:	8db5                	xor	a1,a1,a3
80023e5a:	8ead                	xor	a3,a3,a1
80023e5c:	8db5                	xor	a1,a1,a3

80023e5e <.L__adddf3_add_already_ordered>:
80023e5e:	00159813          	sll	a6,a1,0x1
80023e62:	01585813          	srl	a6,a6,0x15
80023e66:	00169893          	sll	a7,a3,0x1
80023e6a:	0158d893          	srl	a7,a7,0x15
80023e6e:	0c088063          	beqz	a7,80023f2e <.L__adddf3_add_zero>
80023e72:	00180713          	add	a4,a6,1
80023e76:	0756                	sll	a4,a4,0x15
80023e78:	c759                	beqz	a4,80023f06 <.L__adddf3_done>
80023e7a:	41180733          	sub	a4,a6,a7
80023e7e:	03500293          	li	t0,53
80023e82:	08e2e263          	bltu	t0,a4,80023f06 <.L__adddf3_done>
80023e86:	0145d813          	srl	a6,a1,0x14
80023e8a:	06ae                	sll	a3,a3,0xb
80023e8c:	8edd                	or	a3,a3,a5
80023e8e:	82ad                	srl	a3,a3,0xb
80023e90:	05ae                	sll	a1,a1,0xb
80023e92:	8ddd                	or	a1,a1,a5
80023e94:	85ad                	sra	a1,a1,0xb
80023e96:	02000293          	li	t0,32
80023e9a:	06577763          	bgeu	a4,t0,80023f08 <.L__adddf3_add_shifted_word>
80023e9e:	4881                	li	a7,0
80023ea0:	cf01                	beqz	a4,80023eb8 <.L__adddf3_add_no_shift>
80023ea2:	40e002b3          	neg	t0,a4
80023ea6:	005618b3          	sll	a7,a2,t0
80023eaa:	00e65633          	srl	a2,a2,a4
80023eae:	005692b3          	sll	t0,a3,t0
80023eb2:	9616                	add	a2,a2,t0
80023eb4:	00e6d6b3          	srl	a3,a3,a4

80023eb8 <.L__adddf3_add_no_shift>:
80023eb8:	9532                	add	a0,a0,a2
80023eba:	00c532b3          	sltu	t0,a0,a2
80023ebe:	95b6                	add	a1,a1,a3
80023ec0:	00d5b333          	sltu	t1,a1,a3
80023ec4:	9596                	add	a1,a1,t0
80023ec6:	00031463          	bnez	t1,80023ece <.L__adddf3_normalization_required>
80023eca:	0255f163          	bgeu	a1,t0,80023eec <.L__adddf3_already_normalized>

80023ece <.L__adddf3_normalization_required>:
80023ece:	00280613          	add	a2,a6,2
80023ed2:	0656                	sll	a2,a2,0x15
80023ed4:	c235                	beqz	a2,80023f38 <.L__adddf3_inf>
80023ed6:	01f51613          	sll	a2,a0,0x1f
80023eda:	011032b3          	snez	t0,a7
80023ede:	005608b3          	add	a7,a2,t0
80023ee2:	8105                	srl	a0,a0,0x1
80023ee4:	01f59693          	sll	a3,a1,0x1f
80023ee8:	8d55                	or	a0,a0,a3
80023eea:	8185                	srl	a1,a1,0x1

80023eec <.L__adddf3_already_normalized>:
80023eec:	0805                	add	a6,a6,1
80023eee:	0852                	sll	a6,a6,0x14

80023ef0 <.L__adddf3_perform_rounding>:
80023ef0:	0008da63          	bgez	a7,80023f04 <.L__adddf3_add_no_tie>
80023ef4:	0505                	add	a0,a0,1
80023ef6:	00153293          	seqz	t0,a0
80023efa:	9596                	add	a1,a1,t0
80023efc:	0886                	sll	a7,a7,0x1
80023efe:	00089363          	bnez	a7,80023f04 <.L__adddf3_add_no_tie>
80023f02:	9979                	and	a0,a0,-2

80023f04 <.L__adddf3_add_no_tie>:
80023f04:	95c2                	add	a1,a1,a6

80023f06 <.L__adddf3_done>:
80023f06:	8082                	ret

80023f08 <.L__adddf3_add_shifted_word>:
80023f08:	88b2                	mv	a7,a2
80023f0a:	1701                	add	a4,a4,-32 # f3ffffe0 <__AHB_SRAM_segment_end__+0x3cf7fe0>
80023f0c:	cb11                	beqz	a4,80023f20 <.L__adddf3_already_aligned>
80023f0e:	40e008b3          	neg	a7,a4
80023f12:	011698b3          	sll	a7,a3,a7
80023f16:	00e6d6b3          	srl	a3,a3,a4
80023f1a:	00c03733          	snez	a4,a2
80023f1e:	98ba                	add	a7,a7,a4

80023f20 <.L__adddf3_already_aligned>:
80023f20:	9536                	add	a0,a0,a3
80023f22:	00d532b3          	sltu	t0,a0,a3
80023f26:	9596                	add	a1,a1,t0
80023f28:	fc55f2e3          	bgeu	a1,t0,80023eec <.L__adddf3_already_normalized>
80023f2c:	b74d                	j	80023ece <.L__adddf3_normalization_required>

80023f2e <.L__adddf3_add_zero>:
80023f2e:	fc081ce3          	bnez	a6,80023f06 <.L__adddf3_done>
80023f32:	8dfd                	and	a1,a1,a5
80023f34:	4501                	li	a0,0
80023f36:	bfc1                	j	80023f06 <.L__adddf3_done>

80023f38 <.L__adddf3_inf>:
80023f38:	0805                	add	a6,a6,1
80023f3a:	01481593          	sll	a1,a6,0x14
80023f3e:	4501                	li	a0,0
80023f40:	b7d9                	j	80023f06 <.L__adddf3_done>

80023f42 <.L__adddf3_sub_inf_nan>:
80023f42:	fce892e3          	bne	a7,a4,80023f06 <.L__adddf3_done>
80023f46:	7ff805b7          	lui	a1,0x7ff80
80023f4a:	4501                	li	a0,0
80023f4c:	bf6d                	j	80023f06 <.L__adddf3_done>

80023f4e <.L__adddf3_subtract>:
80023f4e:	8ebd                	xor	a3,a3,a5
80023f50:	00b6ed63          	bltu	a3,a1,80023f6a <.L__adddf3_sub_already_ordered>
80023f54:	00b69463          	bne	a3,a1,80023f5c <.L__adddf3_sub_must_exchange>
80023f58:	00a66963          	bltu	a2,a0,80023f6a <.L__adddf3_sub_already_ordered>

80023f5c <.L__adddf3_sub_must_exchange>:
80023f5c:	8ebd                	xor	a3,a3,a5
80023f5e:	8d31                	xor	a0,a0,a2
80023f60:	8e29                	xor	a2,a2,a0
80023f62:	8d31                	xor	a0,a0,a2
80023f64:	8db5                	xor	a1,a1,a3
80023f66:	8ead                	xor	a3,a3,a1
80023f68:	8db5                	xor	a1,a1,a3

80023f6a <.L__adddf3_sub_already_ordered>:
80023f6a:	00b58833          	add	a6,a1,a1
80023f6e:	00d688b3          	add	a7,a3,a3
80023f72:	ffe00737          	lui	a4,0xffe00
80023f76:	fce876e3          	bgeu	a6,a4,80023f42 <.L__adddf3_sub_inf_nan>
80023f7a:	01585813          	srl	a6,a6,0x15
80023f7e:	0158d893          	srl	a7,a7,0x15
80023f82:	0a088f63          	beqz	a7,80024040 <.L__adddf3_subtracting_zero>
80023f86:	41180733          	sub	a4,a6,a7
80023f8a:	03600293          	li	t0,54
80023f8e:	f6e2ece3          	bltu	t0,a4,80023f06 <.L__adddf3_done>
80023f92:	83c2                	mv	t2,a6
80023f94:	0145d813          	srl	a6,a1,0x14
80023f98:	06ae                	sll	a3,a3,0xb
80023f9a:	8edd                	or	a3,a3,a5
80023f9c:	82ad                	srl	a3,a3,0xb
80023f9e:	05ae                	sll	a1,a1,0xb
80023fa0:	8ddd                	or	a1,a1,a5
80023fa2:	81ad                	srl	a1,a1,0xb
80023fa4:	4285                	li	t0,1
80023fa6:	0ae2ef63          	bltu	t0,a4,80024064 <.L__adddf3_sub_align_far>
80023faa:	00571a63          	bne	a4,t0,80023fbe <.L__adddf3_sub_already_aligned>
80023fae:	01f61713          	sll	a4,a2,0x1f
80023fb2:	8205                	srl	a2,a2,0x1
80023fb4:	01f69893          	sll	a7,a3,0x1f
80023fb8:	01166633          	or	a2,a2,a7
80023fbc:	8285                	srl	a3,a3,0x1

80023fbe <.L__adddf3_sub_already_aligned>:
80023fbe:	82aa                	mv	t0,a0
80023fc0:	8d11                	sub	a0,a0,a2
80023fc2:	00a2b2b3          	sltu	t0,t0,a0
80023fc6:	8d95                	sub	a1,a1,a3
80023fc8:	405585b3          	sub	a1,a1,t0
80023fcc:	c711                	beqz	a4,80023fd8 <.L__adddf3_sub_single_done>
80023fce:	00153293          	seqz	t0,a0
80023fd2:	157d                	add	a0,a0,-1
80023fd4:	405585b3          	sub	a1,a1,t0

80023fd8 <.L__adddf3_sub_single_done>:
80023fd8:	c9ad                	beqz	a1,8002404a <.L__adddf3_high_word_cancelled>
80023fda:	00b59293          	sll	t0,a1,0xb
80023fde:	1202ca63          	bltz	t0,80024112 <.L__adddf3_sub_normalized>

80023fe2 <.L__adddf3_first_normalization_step>:
80023fe2:	000522b3          	sltz	t0,a0
80023fe6:	952a                	add	a0,a0,a0
80023fe8:	95ae                	add	a1,a1,a1
80023fea:	9596                	add	a1,a1,t0
80023fec:	837d                	srl	a4,a4,0x1f
80023fee:	953a                	add	a0,a0,a4
80023ff0:	4705                	li	a4,1

80023ff2 <.L__adddf3_try_shift_4>:
80023ff2:	0115d293          	srl	t0,a1,0x11
80023ff6:	00029963          	bnez	t0,80024008 <.L__adddf3_cant_shift_4>
80023ffa:	0711                	add	a4,a4,4 # ffe00004 <__APB_SRAM_segment_end__+0xbd0e004>
80023ffc:	0592                	sll	a1,a1,0x4
80023ffe:	01c55293          	srl	t0,a0,0x1c
80024002:	0512                	sll	a0,a0,0x4
80024004:	9596                	add	a1,a1,t0
80024006:	b7f5                	j	80023ff2 <.L__adddf3_try_shift_4>

80024008 <.L__adddf3_cant_shift_4>:
80024008:	00b59293          	sll	t0,a1,0xb
8002400c:	0002cc63          	bltz	t0,80024024 <.L__adddf3_normalized>

80024010 <.L__adddf3_normalize>:
80024010:	0705                	add	a4,a4,1
80024012:	000522b3          	sltz	t0,a0
80024016:	952a                	add	a0,a0,a0
80024018:	95ae                	add	a1,a1,a1
8002401a:	9596                	add	a1,a1,t0

8002401c <.L__adddf3_pre_normalize>:
8002401c:	00b59293          	sll	t0,a1,0xb
80024020:	fe02d8e3          	bgez	t0,80024010 <.L__adddf3_normalize>

80024024 <.L__adddf3_normalized>:
80024024:	861e                	mv	a2,t2
80024026:	00c77863          	bgeu	a4,a2,80024036 <.L__adddf3_signed_zero>
8002402a:	40e80833          	sub	a6,a6,a4
8002402e:	187d                	add	a6,a6,-1
80024030:	0852                	sll	a6,a6,0x14
80024032:	95c2                	add	a1,a1,a6
80024034:	bdc9                	j	80023f06 <.L__adddf3_done>

80024036 <.L__adddf3_signed_zero>:
80024036:	00b85593          	srl	a1,a6,0xb
8002403a:	05fe                	sll	a1,a1,0x1f
8002403c:	4501                	li	a0,0
8002403e:	b5e1                	j	80023f06 <.L__adddf3_done>

80024040 <.L__adddf3_subtracting_zero>:
80024040:	ec0813e3          	bnez	a6,80023f06 <.L__adddf3_done>
80024044:	4501                	li	a0,0
80024046:	4581                	li	a1,0
80024048:	bd7d                	j	80023f06 <.L__adddf3_done>

8002404a <.L__adddf3_high_word_cancelled>:
8002404a:	00e56633          	or	a2,a0,a4
8002404e:	ea060ce3          	beqz	a2,80023f06 <.L__adddf3_done>
80024052:	001008b7          	lui	a7,0x100
80024056:	f91576e3          	bgeu	a0,a7,80023fe2 <.L__adddf3_first_normalization_step>
8002405a:	85aa                	mv	a1,a0
8002405c:	853a                	mv	a0,a4
8002405e:	02000713          	li	a4,32
80024062:	bf6d                	j	8002401c <.L__adddf3_pre_normalize>

80024064 <.L__adddf3_sub_align_far>:
80024064:	02000293          	li	t0,32
80024068:	04574863          	blt	a4,t0,800240b8 <.L__adddf3_aligned_on_top>
8002406c:	04570263          	beq	a4,t0,800240b0 <.L__adddf3_word_aligned_on_top>
80024070:	1701                	add	a4,a4,-32
80024072:	40e002b3          	neg	t0,a4
80024076:	00e65333          	srl	t1,a2,a4
8002407a:	005618b3          	sll	a7,a2,t0
8002407e:	00569633          	sll	a2,a3,t0
80024082:	961a                	add	a2,a2,t1
80024084:	00e6d6b3          	srl	a3,a3,a4
80024088:	011038b3          	snez	a7,a7
8002408c:	00c8e8b3          	or	a7,a7,a2
80024090:	4601                	li	a2,0
80024092:	82aa                	mv	t0,a0
80024094:	8d15                	sub	a0,a0,a3
80024096:	00a2b2b3          	sltu	t0,t0,a0
8002409a:	405585b3          	sub	a1,a1,t0
8002409e:	41100733          	neg	a4,a7
800240a2:	c729                	beqz	a4,800240ec <.L__adddf3_sub_normalize>
800240a4:	00153293          	seqz	t0,a0
800240a8:	157d                	add	a0,a0,-1
800240aa:	405585b3          	sub	a1,a1,t0
800240ae:	a83d                	j	800240ec <.L__adddf3_sub_normalize>

800240b0 <.L__adddf3_word_aligned_on_top>:
800240b0:	88b2                	mv	a7,a2
800240b2:	8636                	mv	a2,a3
800240b4:	4681                	li	a3,0
800240b6:	a821                	j	800240ce <.L__adddf3_aligned_subtract>

800240b8 <.L__adddf3_aligned_on_top>:
800240b8:	40e002b3          	neg	t0,a4
800240bc:	00e65333          	srl	t1,a2,a4
800240c0:	005618b3          	sll	a7,a2,t0
800240c4:	00569633          	sll	a2,a3,t0
800240c8:	961a                	add	a2,a2,t1
800240ca:	00e6d6b3          	srl	a3,a3,a4

800240ce <.L__adddf3_aligned_subtract>:
800240ce:	82aa                	mv	t0,a0
800240d0:	8d11                	sub	a0,a0,a2
800240d2:	00a2b2b3          	sltu	t0,t0,a0
800240d6:	8d95                	sub	a1,a1,a3
800240d8:	405585b3          	sub	a1,a1,t0
800240dc:	41100733          	neg	a4,a7
800240e0:	c711                	beqz	a4,800240ec <.L__adddf3_sub_normalize>
800240e2:	00153293          	seqz	t0,a0
800240e6:	157d                	add	a0,a0,-1
800240e8:	405585b3          	sub	a1,a1,t0

800240ec <.L__adddf3_sub_normalize>:
800240ec:	00c59893          	sll	a7,a1,0xc
800240f0:	00b59293          	sll	t0,a1,0xb
800240f4:	0002cf63          	bltz	t0,80024112 <.L__adddf3_sub_normalized>
800240f8:	187d                	add	a6,a6,-1
800240fa:	000522b3          	sltz	t0,a0
800240fe:	952a                	add	a0,a0,a0
80024100:	95ae                	add	a1,a1,a1
80024102:	9596                	add	a1,a1,t0
80024104:	000722b3          	sltz	t0,a4
80024108:	973a                	add	a4,a4,a4
8002410a:	9516                	add	a0,a0,t0
8002410c:	005532b3          	sltu	t0,a0,t0
80024110:	9596                	add	a1,a1,t0

80024112 <.L__adddf3_sub_normalized>:
80024112:	187d                	add	a6,a6,-1
80024114:	0852                	sll	a6,a6,0x14
80024116:	88ba                	mv	a7,a4
80024118:	bbe1                	j	80023ef0 <.L__adddf3_perform_rounding>

Disassembly of section .text.libc.__mulsf3:

8002411a <__mulsf3>:
8002411a:	80000737          	lui	a4,0x80000
8002411e:	0ff00293          	li	t0,255
80024122:	00b547b3          	xor	a5,a0,a1
80024126:	8ff9                	and	a5,a5,a4
80024128:	00151613          	sll	a2,a0,0x1
8002412c:	8261                	srl	a2,a2,0x18
8002412e:	00159693          	sll	a3,a1,0x1
80024132:	82e1                	srl	a3,a3,0x18
80024134:	ce29                	beqz	a2,8002418e <.L__mulsf3_lhs_zero_or_subnormal>
80024136:	c6bd                	beqz	a3,800241a4 <.L__mulsf3_rhs_zero_or_subnormal>
80024138:	04560f63          	beq	a2,t0,80024196 <.L__mulsf3_lhs_inf_or_nan>
8002413c:	06568963          	beq	a3,t0,800241ae <.L__mulsf3_rhs_inf_or_nan>
80024140:	9636                	add	a2,a2,a3
80024142:	0522                	sll	a0,a0,0x8
80024144:	8d59                	or	a0,a0,a4
80024146:	05a2                	sll	a1,a1,0x8
80024148:	8dd9                	or	a1,a1,a4
8002414a:	02b506b3          	mul	a3,a0,a1
8002414e:	02b53533          	mulhu	a0,a0,a1
80024152:	00d036b3          	snez	a3,a3
80024156:	8d55                	or	a0,a0,a3
80024158:	00054463          	bltz	a0,80024160 <.L__mulsf3_normalized>
8002415c:	0506                	sll	a0,a0,0x1
8002415e:	167d                	add	a2,a2,-1

80024160 <.L__mulsf3_normalized>:
80024160:	f8160613          	add	a2,a2,-127
80024164:	04064863          	bltz	a2,800241b4 <.L__mulsf3_zero_or_underflow>
80024168:	12fd                	add	t0,t0,-1 # ffffffff <__APB_SRAM_segment_end__+0xbf0dfff>
8002416a:	00565f63          	bge	a2,t0,80024188 <.L__mulsf3_inf>
8002416e:	01851693          	sll	a3,a0,0x18
80024172:	8121                	srl	a0,a0,0x8
80024174:	065e                	sll	a2,a2,0x17
80024176:	9532                	add	a0,a0,a2
80024178:	0006d663          	bgez	a3,80024184 <.L__mulsf3_apply_sign>
8002417c:	0505                	add	a0,a0,1
8002417e:	0686                	sll	a3,a3,0x1
80024180:	e291                	bnez	a3,80024184 <.L__mulsf3_apply_sign>
80024182:	9979                	and	a0,a0,-2

80024184 <.L__mulsf3_apply_sign>:
80024184:	8d5d                	or	a0,a0,a5
80024186:	8082                	ret

80024188 <.L__mulsf3_inf>:
80024188:	7f800537          	lui	a0,0x7f800
8002418c:	bfe5                	j	80024184 <.L__mulsf3_apply_sign>

8002418e <.L__mulsf3_lhs_zero_or_subnormal>:
8002418e:	00568d63          	beq	a3,t0,800241a8 <.L__mulsf3_nan>

80024192 <.L__mulsf3_signed_zero>:
80024192:	853e                	mv	a0,a5
80024194:	8082                	ret

80024196 <.L__mulsf3_lhs_inf_or_nan>:
80024196:	0526                	sll	a0,a0,0x9
80024198:	e901                	bnez	a0,800241a8 <.L__mulsf3_nan>
8002419a:	fe5697e3          	bne	a3,t0,80024188 <.L__mulsf3_inf>
8002419e:	05a6                	sll	a1,a1,0x9
800241a0:	e581                	bnez	a1,800241a8 <.L__mulsf3_nan>
800241a2:	b7dd                	j	80024188 <.L__mulsf3_inf>

800241a4 <.L__mulsf3_rhs_zero_or_subnormal>:
800241a4:	fe5617e3          	bne	a2,t0,80024192 <.L__mulsf3_signed_zero>

800241a8 <.L__mulsf3_nan>:
800241a8:	7fc00537          	lui	a0,0x7fc00
800241ac:	8082                	ret

800241ae <.L__mulsf3_rhs_inf_or_nan>:
800241ae:	05a6                	sll	a1,a1,0x9
800241b0:	fde5                	bnez	a1,800241a8 <.L__mulsf3_nan>
800241b2:	bfd9                	j	80024188 <.L__mulsf3_inf>

800241b4 <.L__mulsf3_zero_or_underflow>:
800241b4:	0605                	add	a2,a2,1
800241b6:	fe71                	bnez	a2,80024192 <.L__mulsf3_signed_zero>
800241b8:	8521                	sra	a0,a0,0x8
800241ba:	00150293          	add	t0,a0,1 # 7fc00001 <__SHARE_RAM_segment_end__+0x7ea80001>
800241be:	0509                	add	a0,a0,2
800241c0:	fc0299e3          	bnez	t0,80024192 <.L__mulsf3_signed_zero>
800241c4:	00800537          	lui	a0,0x800
800241c8:	bf75                	j	80024184 <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__muldf3:

800241ca <__muldf3>:
800241ca:	800008b7          	lui	a7,0x80000
800241ce:	00d5c833          	xor	a6,a1,a3
800241d2:	01187eb3          	and	t4,a6,a7
800241d6:	00b58733          	add	a4,a1,a1
800241da:	00d687b3          	add	a5,a3,a3
800241de:	ffe00837          	lui	a6,0xffe00
800241e2:	0d077363          	bgeu	a4,a6,800242a8 <.L__muldf3_lhs_nan_or_inf>
800241e6:	0d07ff63          	bgeu	a5,a6,800242c4 <.L__muldf3_rhs_nan_or_inf>
800241ea:	8355                	srl	a4,a4,0x15
800241ec:	c76d                	beqz	a4,800242d6 <.L__muldf3_signed_zero>
800241ee:	83d5                	srl	a5,a5,0x15
800241f0:	c3fd                	beqz	a5,800242d6 <.L__muldf3_signed_zero>
800241f2:	06ae                	sll	a3,a3,0xb
800241f4:	0116e6b3          	or	a3,a3,a7
800241f8:	82ad                	srl	a3,a3,0xb
800241fa:	05ae                	sll	a1,a1,0xb
800241fc:	0115e5b3          	or	a1,a1,a7
80024200:	01555813          	srl	a6,a0,0x15
80024204:	052e                	sll	a0,a0,0xb
80024206:	010582b3          	add	t0,a1,a6
8002420a:	00f70333          	add	t1,a4,a5
8002420e:	02c50733          	mul	a4,a0,a2
80024212:	02c537b3          	mulhu	a5,a0,a2
80024216:	02d50833          	mul	a6,a0,a3
8002421a:	02d538b3          	mulhu	a7,a0,a3
8002421e:	983e                	add	a6,a6,a5
80024220:	00f837b3          	sltu	a5,a6,a5
80024224:	98be                	add	a7,a7,a5
80024226:	02c28533          	mul	a0,t0,a2
8002422a:	02c2b5b3          	mulhu	a1,t0,a2
8002422e:	982a                	add	a6,a6,a0
80024230:	00a83533          	sltu	a0,a6,a0
80024234:	98ae                	add	a7,a7,a1
80024236:	00b8b5b3          	sltu	a1,a7,a1
8002423a:	98aa                	add	a7,a7,a0
8002423c:	00a8b533          	sltu	a0,a7,a0
80024240:	00b50633          	add	a2,a0,a1
80024244:	02d28533          	mul	a0,t0,a3
80024248:	02d2b5b3          	mulhu	a1,t0,a3
8002424c:	9546                	add	a0,a0,a7
8002424e:	011538b3          	sltu	a7,a0,a7
80024252:	95c6                	add	a1,a1,a7
80024254:	95b2                	add	a1,a1,a2
80024256:	00e03733          	snez	a4,a4
8002425a:	00e86833          	or	a6,a6,a4
8002425e:	871a                	mv	a4,t1
80024260:	00b59293          	sll	t0,a1,0xb
80024264:	0002cc63          	bltz	t0,8002427c <.L__muldf3_normalized>
80024268:	000822b3          	sltz	t0,a6
8002426c:	9842                	add	a6,a6,a6
8002426e:	00052333          	sltz	t1,a0
80024272:	952a                	add	a0,a0,a0
80024274:	9516                	add	a0,a0,t0
80024276:	95ae                	add	a1,a1,a1
80024278:	959a                	add	a1,a1,t1
8002427a:	177d                	add	a4,a4,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>

8002427c <.L__muldf3_normalized>:
8002427c:	3ff00793          	li	a5,1023
80024280:	8f1d                	sub	a4,a4,a5
80024282:	04074a63          	bltz	a4,800242d6 <.L__muldf3_signed_zero>
80024286:	0786                	sll	a5,a5,0x1
80024288:	04f75363          	bge	a4,a5,800242ce <.L__muldf3_inf>
8002428c:	0752                	sll	a4,a4,0x14
8002428e:	95ba                	add	a1,a1,a4
80024290:	00085a63          	bgez	a6,800242a4 <.L__muldf3_apply_sign>
80024294:	0505                	add	a0,a0,1 # 800001 <_flash_size+0x1>
80024296:	00153613          	seqz	a2,a0
8002429a:	95b2                	add	a1,a1,a2
8002429c:	0806                	sll	a6,a6,0x1
8002429e:	00081363          	bnez	a6,800242a4 <.L__muldf3_apply_sign>
800242a2:	9979                	and	a0,a0,-2

800242a4 <.L__muldf3_apply_sign>:
800242a4:	95f6                	add	a1,a1,t4
800242a6:	8082                	ret

800242a8 <.L__muldf3_lhs_nan_or_inf>:
800242a8:	01071a63          	bne	a4,a6,800242bc <.L__muldf3_nan>
800242ac:	e901                	bnez	a0,800242bc <.L__muldf3_nan>
800242ae:	00f86763          	bltu	a6,a5,800242bc <.L__muldf3_nan>
800242b2:	0107e363          	bltu	a5,a6,800242b8 <.L__muldf3_rhs_could_be_zero>
800242b6:	e219                	bnez	a2,800242bc <.L__muldf3_nan>

800242b8 <.L__muldf3_rhs_could_be_zero>:
800242b8:	83d5                	srl	a5,a5,0x15
800242ba:	eb91                	bnez	a5,800242ce <.L__muldf3_inf>

800242bc <.L__muldf3_nan>:
800242bc:	7ff805b7          	lui	a1,0x7ff80

800242c0 <.L__muldf3_load_zero_lo>:
800242c0:	4501                	li	a0,0
800242c2:	8082                	ret

800242c4 <.L__muldf3_rhs_nan_or_inf>:
800242c4:	ff079ce3          	bne	a5,a6,800242bc <.L__muldf3_nan>
800242c8:	fa75                	bnez	a2,800242bc <.L__muldf3_nan>
800242ca:	8355                	srl	a4,a4,0x15
800242cc:	db65                	beqz	a4,800242bc <.L__muldf3_nan>

800242ce <.L__muldf3_inf>:
800242ce:	7ff005b7          	lui	a1,0x7ff00
800242d2:	4501                	li	a0,0
800242d4:	bfc1                	j	800242a4 <.L__muldf3_apply_sign>

800242d6 <.L__muldf3_signed_zero>:
800242d6:	85f6                	mv	a1,t4
800242d8:	b7e5                	j	800242c0 <.L__muldf3_load_zero_lo>

Disassembly of section .text.libc.__divsf3:

800242da <__divsf3>:
800242da:	0ff00293          	li	t0,255
800242de:	00151713          	sll	a4,a0,0x1
800242e2:	8361                	srl	a4,a4,0x18
800242e4:	00159793          	sll	a5,a1,0x1
800242e8:	83e1                	srl	a5,a5,0x18
800242ea:	00b54333          	xor	t1,a0,a1
800242ee:	01f35313          	srl	t1,t1,0x1f
800242f2:	037e                	sll	t1,t1,0x1f
800242f4:	cf4d                	beqz	a4,800243ae <.L__divsf3_lhs_zero_or_subnormal>
800242f6:	cbe9                	beqz	a5,800243c8 <.L__divsf3_rhs_zero_or_subnormal>
800242f8:	0c570363          	beq	a4,t0,800243be <.L__divsf3_lhs_inf_or_nan>
800242fc:	0c578b63          	beq	a5,t0,800243d2 <.L__divsf3_rhs_inf_or_nan>
80024300:	8f1d                	sub	a4,a4,a5
80024302:	a0818293          	add	t0,gp,-1528 # 800202ac <__SEGGER_RTL_fdiv_reciprocal_table>
80024306:	00f5d693          	srl	a3,a1,0xf
8002430a:	0fc6f693          	and	a3,a3,252
8002430e:	9696                	add	a3,a3,t0
80024310:	429c                	lw	a5,0(a3)
80024312:	4187d613          	sra	a2,a5,0x18
80024316:	00f59693          	sll	a3,a1,0xf
8002431a:	82e1                	srl	a3,a3,0x18
8002431c:	0016f293          	and	t0,a3,1
80024320:	8285                	srl	a3,a3,0x1
80024322:	fc068693          	add	a3,a3,-64 # f3ffffc0 <__AHB_SRAM_segment_end__+0x3cf7fc0>
80024326:	9696                	add	a3,a3,t0
80024328:	02d60633          	mul	a2,a2,a3
8002432c:	07a2                	sll	a5,a5,0x8
8002432e:	83a1                	srl	a5,a5,0x8
80024330:	963e                	add	a2,a2,a5
80024332:	05a2                	sll	a1,a1,0x8
80024334:	81a1                	srl	a1,a1,0x8
80024336:	008007b7          	lui	a5,0x800
8002433a:	8ddd                	or	a1,a1,a5
8002433c:	02c586b3          	mul	a3,a1,a2
80024340:	0522                	sll	a0,a0,0x8
80024342:	8121                	srl	a0,a0,0x8
80024344:	8d5d                	or	a0,a0,a5
80024346:	02c697b3          	mulh	a5,a3,a2
8002434a:	00b532b3          	sltu	t0,a0,a1
8002434e:	00551533          	sll	a0,a0,t0
80024352:	40570733          	sub	a4,a4,t0
80024356:	01465693          	srl	a3,a2,0x14
8002435a:	8a85                	and	a3,a3,1
8002435c:	0016c693          	xor	a3,a3,1
80024360:	062e                	sll	a2,a2,0xb
80024362:	8e1d                	sub	a2,a2,a5
80024364:	8e15                	sub	a2,a2,a3
80024366:	050a                	sll	a0,a0,0x2
80024368:	02a617b3          	mulh	a5,a2,a0
8002436c:	07e70613          	add	a2,a4,126
80024370:	055a                	sll	a0,a0,0x16
80024372:	8d0d                	sub	a0,a0,a1
80024374:	02b786b3          	mul	a3,a5,a1
80024378:	0fe00293          	li	t0,254
8002437c:	00567f63          	bgeu	a2,t0,8002439a <.L__divsf3_underflow_or_overflow>
80024380:	40a68533          	sub	a0,a3,a0
80024384:	000522b3          	sltz	t0,a0
80024388:	9796                	add	a5,a5,t0
8002438a:	0017f513          	and	a0,a5,1
8002438e:	8385                	srl	a5,a5,0x1
80024390:	953e                	add	a0,a0,a5
80024392:	065e                	sll	a2,a2,0x17
80024394:	9532                	add	a0,a0,a2
80024396:	951a                	add	a0,a0,t1
80024398:	8082                	ret

8002439a <.L__divsf3_underflow_or_overflow>:
8002439a:	851a                	mv	a0,t1
8002439c:	00564563          	blt	a2,t0,800243a6 <.L__divsf3_done>
800243a0:	7f800337          	lui	t1,0x7f800

800243a4 <.L__divsf3_apply_sign>:
800243a4:	951a                	add	a0,a0,t1

800243a6 <.L__divsf3_done>:
800243a6:	8082                	ret

800243a8 <.L__divsf3_inf>:
800243a8:	7f800537          	lui	a0,0x7f800
800243ac:	bfe5                	j	800243a4 <.L__divsf3_apply_sign>

800243ae <.L__divsf3_lhs_zero_or_subnormal>:
800243ae:	c789                	beqz	a5,800243b8 <.L__divsf3_nan>
800243b0:	02579363          	bne	a5,t0,800243d6 <.L__divsf3_signed_zero>
800243b4:	05a6                	sll	a1,a1,0x9
800243b6:	c185                	beqz	a1,800243d6 <.L__divsf3_signed_zero>

800243b8 <.L__divsf3_nan>:
800243b8:	7fc00537          	lui	a0,0x7fc00
800243bc:	8082                	ret

800243be <.L__divsf3_lhs_inf_or_nan>:
800243be:	0526                	sll	a0,a0,0x9
800243c0:	fd65                	bnez	a0,800243b8 <.L__divsf3_nan>
800243c2:	fe5793e3          	bne	a5,t0,800243a8 <.L__divsf3_inf>
800243c6:	bfcd                	j	800243b8 <.L__divsf3_nan>

800243c8 <.L__divsf3_rhs_zero_or_subnormal>:
800243c8:	fe5710e3          	bne	a4,t0,800243a8 <.L__divsf3_inf>
800243cc:	0526                	sll	a0,a0,0x9
800243ce:	f56d                	bnez	a0,800243b8 <.L__divsf3_nan>
800243d0:	bfe1                	j	800243a8 <.L__divsf3_inf>

800243d2 <.L__divsf3_rhs_inf_or_nan>:
800243d2:	05a6                	sll	a1,a1,0x9
800243d4:	f1f5                	bnez	a1,800243b8 <.L__divsf3_nan>

800243d6 <.L__divsf3_signed_zero>:
800243d6:	851a                	mv	a0,t1
800243d8:	8082                	ret

Disassembly of section .text.libc.__divdf3:

800243da <__divdf3>:
800243da:	00169813          	sll	a6,a3,0x1
800243de:	01585813          	srl	a6,a6,0x15
800243e2:	00159893          	sll	a7,a1,0x1
800243e6:	0158d893          	srl	a7,a7,0x15
800243ea:	00d5c3b3          	xor	t2,a1,a3
800243ee:	01f3d393          	srl	t2,t2,0x1f
800243f2:	03fe                	sll	t2,t2,0x1f
800243f4:	7ff00293          	li	t0,2047
800243f8:	16588e63          	beq	a7,t0,80024574 <.L__divdf3_inf_nan_over>
800243fc:	18080a63          	beqz	a6,80024590 <.L__divdf3_div_zero>
80024400:	18580263          	beq	a6,t0,80024584 <.L__divdf3_div_inf_nan>
80024404:	18088263          	beqz	a7,80024588 <.L__divdf3_signed_zero>
80024408:	410888b3          	sub	a7,a7,a6
8002440c:	3ff88893          	add	a7,a7,1023 # 800003ff <__SHARE_RAM_segment_end__+0x7ee803ff>
80024410:	05b2                	sll	a1,a1,0xc
80024412:	81b1                	srl	a1,a1,0xc
80024414:	06b2                	sll	a3,a3,0xc
80024416:	82b1                	srl	a3,a3,0xc
80024418:	00100737          	lui	a4,0x100
8002441c:	8dd9                	or	a1,a1,a4
8002441e:	8ed9                	or	a3,a3,a4
80024420:	00c53733          	sltu	a4,a0,a2
80024424:	9736                	add	a4,a4,a3
80024426:	8d99                	sub	a1,a1,a4
80024428:	8d11                	sub	a0,a0,a2
8002442a:	0005dd63          	bgez	a1,80024444 <.L__divdf3_can_subtract>
8002442e:	00052733          	sltz	a4,a0
80024432:	95ae                	add	a1,a1,a1
80024434:	95ba                	add	a1,a1,a4
80024436:	95b6                	add	a1,a1,a3
80024438:	952a                	add	a0,a0,a0
8002443a:	9532                	add	a0,a0,a2
8002443c:	00c53733          	sltu	a4,a0,a2
80024440:	95ba                	add	a1,a1,a4
80024442:	18fd                	add	a7,a7,-1

80024444 <.L__divdf3_can_subtract>:
80024444:	1258dd63          	bge	a7,t0,8002457e <.L__divdf3_signed_inf>
80024448:	15105063          	blez	a7,80024588 <.L__divdf3_signed_zero>
8002444c:	05aa                	sll	a1,a1,0xa
8002444e:	01655713          	srl	a4,a0,0x16
80024452:	8dd9                	or	a1,a1,a4
80024454:	052a                	sll	a0,a0,0xa
80024456:	02d5d833          	divu	a6,a1,a3
8002445a:	02d80e33          	mul	t3,a6,a3
8002445e:	41c585b3          	sub	a1,a1,t3
80024462:	02c80733          	mul	a4,a6,a2
80024466:	02c837b3          	mulhu	a5,a6,a2
8002446a:	00e53e33          	sltu	t3,a0,a4
8002446e:	97f2                	add	a5,a5,t3
80024470:	8d19                	sub	a0,a0,a4
80024472:	8d9d                	sub	a1,a1,a5
80024474:	0005d863          	bgez	a1,80024484 <.L__divdf3_qdash_correct_1>
80024478:	187d                	add	a6,a6,-1 # ffdfffff <__APB_SRAM_segment_end__+0xbd0dfff>
8002447a:	9532                	add	a0,a0,a2
8002447c:	95b6                	add	a1,a1,a3
8002447e:	00c532b3          	sltu	t0,a0,a2
80024482:	9596                	add	a1,a1,t0

80024484 <.L__divdf3_qdash_correct_1>:
80024484:	05aa                	sll	a1,a1,0xa
80024486:	01655293          	srl	t0,a0,0x16
8002448a:	9596                	add	a1,a1,t0
8002448c:	052a                	sll	a0,a0,0xa
8002448e:	02d5d2b3          	divu	t0,a1,a3
80024492:	02d28733          	mul	a4,t0,a3
80024496:	8d99                	sub	a1,a1,a4
80024498:	02c28733          	mul	a4,t0,a2
8002449c:	02c2b7b3          	mulhu	a5,t0,a2
800244a0:	00e53e33          	sltu	t3,a0,a4
800244a4:	97f2                	add	a5,a5,t3
800244a6:	8d19                	sub	a0,a0,a4
800244a8:	8d9d                	sub	a1,a1,a5
800244aa:	0005d863          	bgez	a1,800244ba <.L__divdf3_qdash_correct_2>
800244ae:	12fd                	add	t0,t0,-1
800244b0:	9532                	add	a0,a0,a2
800244b2:	95b6                	add	a1,a1,a3
800244b4:	00c53e33          	sltu	t3,a0,a2
800244b8:	95f2                	add	a1,a1,t3

800244ba <.L__divdf3_qdash_correct_2>:
800244ba:	082a                	sll	a6,a6,0xa
800244bc:	9816                	add	a6,a6,t0
800244be:	05ae                	sll	a1,a1,0xb
800244c0:	01555e13          	srl	t3,a0,0x15
800244c4:	95f2                	add	a1,a1,t3
800244c6:	052e                	sll	a0,a0,0xb
800244c8:	02d5d2b3          	divu	t0,a1,a3
800244cc:	02d28733          	mul	a4,t0,a3
800244d0:	8d99                	sub	a1,a1,a4
800244d2:	02c28733          	mul	a4,t0,a2
800244d6:	02c2b7b3          	mulhu	a5,t0,a2
800244da:	00e53e33          	sltu	t3,a0,a4
800244de:	97f2                	add	a5,a5,t3
800244e0:	8d19                	sub	a0,a0,a4
800244e2:	8d9d                	sub	a1,a1,a5
800244e4:	0005d863          	bgez	a1,800244f4 <.L__divdf3_qdash_correct_3>
800244e8:	12fd                	add	t0,t0,-1
800244ea:	9532                	add	a0,a0,a2
800244ec:	95b6                	add	a1,a1,a3
800244ee:	00c53e33          	sltu	t3,a0,a2
800244f2:	95f2                	add	a1,a1,t3

800244f4 <.L__divdf3_qdash_correct_3>:
800244f4:	05ae                	sll	a1,a1,0xb
800244f6:	01555e13          	srl	t3,a0,0x15
800244fa:	95f2                	add	a1,a1,t3
800244fc:	052e                	sll	a0,a0,0xb
800244fe:	02d5d333          	divu	t1,a1,a3
80024502:	02d30733          	mul	a4,t1,a3
80024506:	8d99                	sub	a1,a1,a4
80024508:	02c30733          	mul	a4,t1,a2
8002450c:	02c337b3          	mulhu	a5,t1,a2
80024510:	00e53e33          	sltu	t3,a0,a4
80024514:	97f2                	add	a5,a5,t3
80024516:	8d19                	sub	a0,a0,a4
80024518:	8d9d                	sub	a1,a1,a5
8002451a:	0005d863          	bgez	a1,8002452a <.L__divdf3_qdash_correct_4>
8002451e:	137d                	add	t1,t1,-1 # 7f7fffff <__SHARE_RAM_segment_end__+0x7e67ffff>
80024520:	9532                	add	a0,a0,a2
80024522:	95b6                	add	a1,a1,a3
80024524:	00c53e33          	sltu	t3,a0,a2
80024528:	95f2                	add	a1,a1,t3

8002452a <.L__divdf3_qdash_correct_4>:
8002452a:	02d6                	sll	t0,t0,0x15
8002452c:	032a                	sll	t1,t1,0xa
8002452e:	929a                	add	t0,t0,t1
80024530:	05ae                	sll	a1,a1,0xb
80024532:	01555e13          	srl	t3,a0,0x15
80024536:	95f2                	add	a1,a1,t3
80024538:	052e                	sll	a0,a0,0xb
8002453a:	02d5d333          	divu	t1,a1,a3
8002453e:	02d30733          	mul	a4,t1,a3
80024542:	8d99                	sub	a1,a1,a4
80024544:	02c30733          	mul	a4,t1,a2
80024548:	02c337b3          	mulhu	a5,t1,a2
8002454c:	00e53e33          	sltu	t3,a0,a4
80024550:	97f2                	add	a5,a5,t3
80024552:	8d9d                	sub	a1,a1,a5
80024554:	85fd                	sra	a1,a1,0x1f
80024556:	932e                	add	t1,t1,a1
80024558:	08d2                	sll	a7,a7,0x14
8002455a:	011805b3          	add	a1,a6,a7
8002455e:	00135513          	srl	a0,t1,0x1
80024562:	9516                	add	a0,a0,t0
80024564:	00137313          	and	t1,t1,1
80024568:	951a                	add	a0,a0,t1
8002456a:	00653733          	sltu	a4,a0,t1
8002456e:	95ba                	add	a1,a1,a4
80024570:	959e                	add	a1,a1,t2
80024572:	8082                	ret

80024574 <.L__divdf3_inf_nan_over>:
80024574:	05b2                	sll	a1,a1,0xc
80024576:	00580f63          	beq	a6,t0,80024594 <.L__divdf3_return_nan>
8002457a:	8dc9                	or	a1,a1,a0
8002457c:	ed81                	bnez	a1,80024594 <.L__divdf3_return_nan>

8002457e <.L__divdf3_signed_inf>:
8002457e:	7ff005b7          	lui	a1,0x7ff00
80024582:	a021                	j	8002458a <.L__divdf3_apply_sign>

80024584 <.L__divdf3_div_inf_nan>:
80024584:	06b2                	sll	a3,a3,0xc
80024586:	e699                	bnez	a3,80024594 <.L__divdf3_return_nan>

80024588 <.L__divdf3_signed_zero>:
80024588:	4581                	li	a1,0

8002458a <.L__divdf3_apply_sign>:
8002458a:	959e                	add	a1,a1,t2

8002458c <.L__divdf3_clr_low_ret>:
8002458c:	4501                	li	a0,0
8002458e:	8082                	ret

80024590 <.L__divdf3_div_zero>:
80024590:	fe0897e3          	bnez	a7,8002457e <.L__divdf3_signed_inf>

80024594 <.L__divdf3_return_nan>:
80024594:	7ff805b7          	lui	a1,0x7ff80
80024598:	bfd5                	j	8002458c <.L__divdf3_clr_low_ret>

Disassembly of section .text.libc.__eqsf2:

8002459a <__eqsf2>:
8002459a:	ff000637          	lui	a2,0xff000
8002459e:	00151693          	sll	a3,a0,0x1
800245a2:	02d66063          	bltu	a2,a3,800245c2 <.L__eqsf2_one>
800245a6:	00159693          	sll	a3,a1,0x1
800245aa:	00d66c63          	bltu	a2,a3,800245c2 <.L__eqsf2_one>
800245ae:	00b56633          	or	a2,a0,a1
800245b2:	0606                	sll	a2,a2,0x1
800245b4:	c609                	beqz	a2,800245be <.L__eqsf2_zero>
800245b6:	8d0d                	sub	a0,a0,a1
800245b8:	00a03533          	snez	a0,a0
800245bc:	8082                	ret

800245be <.L__eqsf2_zero>:
800245be:	4501                	li	a0,0
800245c0:	8082                	ret

800245c2 <.L__eqsf2_one>:
800245c2:	4505                	li	a0,1
800245c4:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

800245c6 <__fixunssfdi>:
800245c6:	04054a63          	bltz	a0,8002461a <.L__fixunssfdi_zero_result>
800245ca:	00151613          	sll	a2,a0,0x1
800245ce:	8261                	srl	a2,a2,0x18
800245d0:	f8160613          	add	a2,a2,-127 # feffff81 <__APB_SRAM_segment_end__+0xaf0df81>
800245d4:	04064363          	bltz	a2,8002461a <.L__fixunssfdi_zero_result>
800245d8:	800006b7          	lui	a3,0x80000
800245dc:	02000293          	li	t0,32
800245e0:	00565b63          	bge	a2,t0,800245f6 <.L__fixunssfdi_long_shift>
800245e4:	40c00633          	neg	a2,a2
800245e8:	067d                	add	a2,a2,31
800245ea:	0522                	sll	a0,a0,0x8
800245ec:	8d55                	or	a0,a0,a3
800245ee:	00c55533          	srl	a0,a0,a2
800245f2:	4581                	li	a1,0
800245f4:	8082                	ret

800245f6 <.L__fixunssfdi_long_shift>:
800245f6:	40c00633          	neg	a2,a2
800245fa:	03f60613          	add	a2,a2,63
800245fe:	02064163          	bltz	a2,80024620 <.L__fixunssfdi_overflow_result>
80024602:	00851593          	sll	a1,a0,0x8
80024606:	8dd5                	or	a1,a1,a3
80024608:	4501                	li	a0,0
8002460a:	c619                	beqz	a2,80024618 <.L__fixunssfdi_shift_32>
8002460c:	40c006b3          	neg	a3,a2
80024610:	00d59533          	sll	a0,a1,a3
80024614:	00c5d5b3          	srl	a1,a1,a2

80024618 <.L__fixunssfdi_shift_32>:
80024618:	8082                	ret

8002461a <.L__fixunssfdi_zero_result>:
8002461a:	4501                	li	a0,0
8002461c:	4581                	li	a1,0
8002461e:	8082                	ret

80024620 <.L__fixunssfdi_overflow_result>:
80024620:	557d                	li	a0,-1
80024622:	55fd                	li	a1,-1
80024624:	8082                	ret

Disassembly of section .text.libc.__floatunsidf:

80024626 <__floatunsidf>:
80024626:	c131                	beqz	a0,8002466a <.L__floatunsidf_zero>
80024628:	41d00613          	li	a2,1053
8002462c:	01055693          	srl	a3,a0,0x10
80024630:	e299                	bnez	a3,80024636 <.L1^B9>
80024632:	0542                	sll	a0,a0,0x10
80024634:	1641                	add	a2,a2,-16

80024636 <.L1^B9>:
80024636:	01855693          	srl	a3,a0,0x18
8002463a:	e299                	bnez	a3,80024640 <.L2^B9>
8002463c:	0522                	sll	a0,a0,0x8
8002463e:	1661                	add	a2,a2,-8

80024640 <.L2^B9>:
80024640:	01c55693          	srl	a3,a0,0x1c
80024644:	e299                	bnez	a3,8002464a <.L3^B7>
80024646:	0512                	sll	a0,a0,0x4
80024648:	1671                	add	a2,a2,-4

8002464a <.L3^B7>:
8002464a:	01e55693          	srl	a3,a0,0x1e
8002464e:	e299                	bnez	a3,80024654 <.L4^B9>
80024650:	050a                	sll	a0,a0,0x2
80024652:	1679                	add	a2,a2,-2

80024654 <.L4^B9>:
80024654:	00054463          	bltz	a0,8002465c <.L5^B7>
80024658:	0506                	sll	a0,a0,0x1
8002465a:	167d                	add	a2,a2,-1

8002465c <.L5^B7>:
8002465c:	0652                	sll	a2,a2,0x14
8002465e:	00b55693          	srl	a3,a0,0xb
80024662:	0556                	sll	a0,a0,0x15
80024664:	00c685b3          	add	a1,a3,a2
80024668:	8082                	ret

8002466a <.L__floatunsidf_zero>:
8002466a:	85aa                	mv	a1,a0
8002466c:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

8002466e <__trunctfsf2>:
8002466e:	4110                	lw	a2,0(a0)
80024670:	4154                	lw	a3,4(a0)
80024672:	4518                	lw	a4,8(a0)
80024674:	455c                	lw	a5,12(a0)
80024676:	1101                	add	sp,sp,-32
80024678:	850a                	mv	a0,sp
8002467a:	ce06                	sw	ra,28(sp)
8002467c:	c032                	sw	a2,0(sp)
8002467e:	c236                	sw	a3,4(sp)
80024680:	c43a                	sw	a4,8(sp)
80024682:	c63e                	sw	a5,12(sp)
80024684:	d25fd0ef          	jal	800223a8 <__SEGGER_RTL_ldouble_to_double>
80024688:	c9bfd0ef          	jal	80022322 <__truncdfsf2>
8002468c:	40f2                	lw	ra,28(sp)
8002468e:	6105                	add	sp,sp,32
80024690:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

80024692 <__SEGGER_RTL_float32_signbit>:
80024692:	817d                	srl	a0,a0,0x1f
80024694:	8082                	ret

Disassembly of section .text.libc.ldexpf:

80024696 <ldexpf>:
80024696:	01755713          	srl	a4,a0,0x17
8002469a:	0ff77713          	zext.b	a4,a4
8002469e:	fff70613          	add	a2,a4,-1 # fffff <__DLM_segment_end__+0x3ffff>
800246a2:	0fd00693          	li	a3,253
800246a6:	87aa                	mv	a5,a0
800246a8:	02c6e863          	bltu	a3,a2,800246d8 <.L780>
800246ac:	95ba                	add	a1,a1,a4
800246ae:	fff58713          	add	a4,a1,-1 # 7ff7ffff <__SHARE_RAM_segment_end__+0x7edfffff>
800246b2:	00e6eb63          	bltu	a3,a4,800246c8 <.L781>
800246b6:	80800737          	lui	a4,0x80800
800246ba:	177d                	add	a4,a4,-1 # 807fffff <__XPI0_segment_used_end__+0x7da49f>
800246bc:	00e577b3          	and	a5,a0,a4
800246c0:	05de                	sll	a1,a1,0x17
800246c2:	00f5e533          	or	a0,a1,a5
800246c6:	8082                	ret

800246c8 <.L781>:
800246c8:	80000537          	lui	a0,0x80000
800246cc:	8d7d                	and	a0,a0,a5
800246ce:	00b05563          	blez	a1,800246d8 <.L780>
800246d2:	7f8007b7          	lui	a5,0x7f800
800246d6:	8d5d                	or	a0,a0,a5

800246d8 <.L780>:
800246d8:	8082                	ret

Disassembly of section .text.libc.frexpf:

800246da <frexpf>:
800246da:	01755793          	srl	a5,a0,0x17
800246de:	0ff7f793          	zext.b	a5,a5
800246e2:	4701                	li	a4,0
800246e4:	cf99                	beqz	a5,80024702 <.L959>
800246e6:	0ff00613          	li	a2,255
800246ea:	00c78c63          	beq	a5,a2,80024702 <.L959>
800246ee:	f8278713          	add	a4,a5,-126 # 7f7fff82 <__SHARE_RAM_segment_end__+0x7e67ff82>
800246f2:	808007b7          	lui	a5,0x80800
800246f6:	17fd                	add	a5,a5,-1 # 807fffff <__XPI0_segment_used_end__+0x7da49f>
800246f8:	00f576b3          	and	a3,a0,a5
800246fc:	3f000537          	lui	a0,0x3f000
80024700:	8d55                	or	a0,a0,a3

80024702 <.L959>:
80024702:	c198                	sw	a4,0(a1)
80024704:	8082                	ret

Disassembly of section .text.libc.fmodf:

80024706 <fmodf>:
80024706:	01755793          	srl	a5,a0,0x17
8002470a:	80000837          	lui	a6,0x80000
8002470e:	17fd                	add	a5,a5,-1
80024710:	0fd00713          	li	a4,253
80024714:	86aa                	mv	a3,a0
80024716:	862e                	mv	a2,a1
80024718:	00a87833          	and	a6,a6,a0
8002471c:	02f76463          	bltu	a4,a5,80024744 <.L991>
80024720:	0175d793          	srl	a5,a1,0x17
80024724:	17fd                	add	a5,a5,-1
80024726:	02f77e63          	bgeu	a4,a5,80024762 <.L992>
8002472a:	00151713          	sll	a4,a0,0x1

8002472e <.L993>:
8002472e:	00159793          	sll	a5,a1,0x1
80024732:	ff000637          	lui	a2,0xff000
80024736:	0cf66663          	bltu	a2,a5,80024802 <.L1009>
8002473a:	ef01                	bnez	a4,80024752 <.L995>
8002473c:	eb91                	bnez	a5,80024750 <.L994>

8002473e <.L1011>:
8002473e:	1501a503          	lw	a0,336(gp) # 800209f4 <.Lmerged_single+0x14>
80024742:	8082                	ret

80024744 <.L991>:
80024744:	00151713          	sll	a4,a0,0x1
80024748:	ff0007b7          	lui	a5,0xff000
8002474c:	fee7f1e3          	bgeu	a5,a4,8002472e <.L993>

80024750 <.L994>:
80024750:	8082                	ret

80024752 <.L995>:
80024752:	fec706e3          	beq	a4,a2,8002473e <.L1011>
80024756:	fec78de3          	beq	a5,a2,80024750 <.L994>
8002475a:	d3f5                	beqz	a5,8002473e <.L1011>
8002475c:	0586                	sll	a1,a1,0x1
8002475e:	0015d613          	srl	a2,a1,0x1

80024762 <.L992>:
80024762:	00169793          	sll	a5,a3,0x1
80024766:	8385                	srl	a5,a5,0x1
80024768:	00f66663          	bltu	a2,a5,80024774 <.L996>
8002476c:	fec792e3          	bne	a5,a2,80024750 <.L994>

80024770 <.L1018>:
80024770:	8542                	mv	a0,a6
80024772:	8082                	ret

80024774 <.L996>:
80024774:	0177d713          	srl	a4,a5,0x17
80024778:	cb0d                	beqz	a4,800247aa <.L1012>
8002477a:	008007b7          	lui	a5,0x800
8002477e:	fff78593          	add	a1,a5,-1 # 7fffff <__XPI0_segment_size__+0x1ffff>
80024782:	8eed                	and	a3,a3,a1
80024784:	8fd5                	or	a5,a5,a3

80024786 <.L998>:
80024786:	01765593          	srl	a1,a2,0x17
8002478a:	c985                	beqz	a1,800247ba <.L1013>
8002478c:	008006b7          	lui	a3,0x800
80024790:	fff68513          	add	a0,a3,-1 # 7fffff <__XPI0_segment_size__+0x1ffff>
80024794:	8e69                	and	a2,a2,a0
80024796:	8e55                	or	a2,a2,a3

80024798 <.L1002>:
80024798:	40c786b3          	sub	a3,a5,a2
8002479c:	02e5c763          	blt	a1,a4,800247ca <.L1003>
800247a0:	0206cc63          	bltz	a3,800247d8 <.L1015>
800247a4:	8542                	mv	a0,a6
800247a6:	ea95                	bnez	a3,800247da <.L1004>
800247a8:	8082                	ret

800247aa <.L1012>:
800247aa:	4701                	li	a4,0
800247ac:	008006b7          	lui	a3,0x800

800247b0 <.L997>:
800247b0:	0786                	sll	a5,a5,0x1
800247b2:	177d                	add	a4,a4,-1
800247b4:	fed7eee3          	bltu	a5,a3,800247b0 <.L997>
800247b8:	b7f9                	j	80024786 <.L998>

800247ba <.L1013>:
800247ba:	4581                	li	a1,0
800247bc:	008006b7          	lui	a3,0x800

800247c0 <.L999>:
800247c0:	0606                	sll	a2,a2,0x1
800247c2:	15fd                	add	a1,a1,-1
800247c4:	fed66ee3          	bltu	a2,a3,800247c0 <.L999>
800247c8:	bfc1                	j	80024798 <.L1002>

800247ca <.L1003>:
800247ca:	0006c463          	bltz	a3,800247d2 <.L1001>
800247ce:	d2cd                	beqz	a3,80024770 <.L1018>
800247d0:	87b6                	mv	a5,a3

800247d2 <.L1001>:
800247d2:	0786                	sll	a5,a5,0x1
800247d4:	177d                	add	a4,a4,-1
800247d6:	b7c9                	j	80024798 <.L1002>

800247d8 <.L1015>:
800247d8:	86be                	mv	a3,a5

800247da <.L1004>:
800247da:	008007b7          	lui	a5,0x800

800247de <.L1006>:
800247de:	fff70513          	add	a0,a4,-1
800247e2:	00f6ed63          	bltu	a3,a5,800247fc <.L1007>
800247e6:	00e04763          	bgtz	a4,800247f4 <.L1008>
800247ea:	4785                	li	a5,1
800247ec:	8f99                	sub	a5,a5,a4
800247ee:	00f6d6b3          	srl	a3,a3,a5
800247f2:	4501                	li	a0,0

800247f4 <.L1008>:
800247f4:	9836                	add	a6,a6,a3
800247f6:	055e                	sll	a0,a0,0x17
800247f8:	9542                	add	a0,a0,a6
800247fa:	8082                	ret

800247fc <.L1007>:
800247fc:	0686                	sll	a3,a3,0x1
800247fe:	872a                	mv	a4,a0
80024800:	bff9                	j	800247de <.L1006>

80024802 <.L1009>:
80024802:	852e                	mv	a0,a1
80024804:	8082                	ret

Disassembly of section .text.libc.memset:

80024806 <memset>:
80024806:	872a                	mv	a4,a0
80024808:	c22d                	beqz	a2,8002486a <.Lmemset_memset_end>

8002480a <.Lmemset_unaligned_byte_set_loop>:
8002480a:	01e51693          	sll	a3,a0,0x1e
8002480e:	c699                	beqz	a3,8002481c <.Lmemset_fast_set>
80024810:	00b50023          	sb	a1,0(a0) # 3f000000 <__SHARE_RAM_segment_end__+0x3de80000>
80024814:	0505                	add	a0,a0,1
80024816:	167d                	add	a2,a2,-1 # feffffff <__APB_SRAM_segment_end__+0xaf0dfff>
80024818:	fa6d                	bnez	a2,8002480a <.Lmemset_unaligned_byte_set_loop>
8002481a:	a881                	j	8002486a <.Lmemset_memset_end>

8002481c <.Lmemset_fast_set>:
8002481c:	0ff5f593          	zext.b	a1,a1
80024820:	00859693          	sll	a3,a1,0x8
80024824:	8dd5                	or	a1,a1,a3
80024826:	01059693          	sll	a3,a1,0x10
8002482a:	8dd5                	or	a1,a1,a3
8002482c:	02000693          	li	a3,32
80024830:	00d66f63          	bltu	a2,a3,8002484e <.Lmemset_word_set>

80024834 <.Lmemset_fast_set_loop>:
80024834:	c10c                	sw	a1,0(a0)
80024836:	c14c                	sw	a1,4(a0)
80024838:	c50c                	sw	a1,8(a0)
8002483a:	c54c                	sw	a1,12(a0)
8002483c:	c90c                	sw	a1,16(a0)
8002483e:	c94c                	sw	a1,20(a0)
80024840:	cd0c                	sw	a1,24(a0)
80024842:	cd4c                	sw	a1,28(a0)
80024844:	9536                	add	a0,a0,a3
80024846:	8e15                	sub	a2,a2,a3
80024848:	fed676e3          	bgeu	a2,a3,80024834 <.Lmemset_fast_set_loop>
8002484c:	ce19                	beqz	a2,8002486a <.Lmemset_memset_end>

8002484e <.Lmemset_word_set>:
8002484e:	4691                	li	a3,4
80024850:	00d66863          	bltu	a2,a3,80024860 <.Lmemset_byte_set_loop>

80024854 <.Lmemset_word_set_loop>:
80024854:	c10c                	sw	a1,0(a0)
80024856:	9536                	add	a0,a0,a3
80024858:	8e15                	sub	a2,a2,a3
8002485a:	fed67de3          	bgeu	a2,a3,80024854 <.Lmemset_word_set_loop>
8002485e:	c611                	beqz	a2,8002486a <.Lmemset_memset_end>

80024860 <.Lmemset_byte_set_loop>:
80024860:	00b50023          	sb	a1,0(a0)
80024864:	0505                	add	a0,a0,1
80024866:	167d                	add	a2,a2,-1
80024868:	fe65                	bnez	a2,80024860 <.Lmemset_byte_set_loop>

8002486a <.Lmemset_memset_end>:
8002486a:	853a                	mv	a0,a4
8002486c:	8082                	ret

Disassembly of section .text.libc.strlen:

8002486e <strlen>:
8002486e:	85aa                	mv	a1,a0
80024870:	00357693          	and	a3,a0,3
80024874:	c29d                	beqz	a3,8002489a <.Lstrlen_aligned>
80024876:	00054603          	lbu	a2,0(a0)
8002487a:	ce21                	beqz	a2,800248d2 <.Lstrlen_done>
8002487c:	0505                	add	a0,a0,1
8002487e:	00357693          	and	a3,a0,3
80024882:	ce81                	beqz	a3,8002489a <.Lstrlen_aligned>
80024884:	00054603          	lbu	a2,0(a0)
80024888:	c629                	beqz	a2,800248d2 <.Lstrlen_done>
8002488a:	0505                	add	a0,a0,1
8002488c:	00357693          	and	a3,a0,3
80024890:	c689                	beqz	a3,8002489a <.Lstrlen_aligned>
80024892:	00054603          	lbu	a2,0(a0)
80024896:	ce15                	beqz	a2,800248d2 <.Lstrlen_done>
80024898:	0505                	add	a0,a0,1

8002489a <.Lstrlen_aligned>:
8002489a:	01010637          	lui	a2,0x1010
8002489e:	10160613          	add	a2,a2,257 # 1010101 <_extram_size+0x10101>
800248a2:	00761693          	sll	a3,a2,0x7

800248a6 <.Lstrlen_wordstrlen>:
800248a6:	4118                	lw	a4,0(a0)
800248a8:	0511                	add	a0,a0,4
800248aa:	40c707b3          	sub	a5,a4,a2
800248ae:	fff74713          	not	a4,a4
800248b2:	8ff9                	and	a5,a5,a4
800248b4:	8ff5                	and	a5,a5,a3
800248b6:	dbe5                	beqz	a5,800248a6 <.Lstrlen_wordstrlen>
800248b8:	1571                	add	a0,a0,-4
800248ba:	01879713          	sll	a4,a5,0x18
800248be:	eb11                	bnez	a4,800248d2 <.Lstrlen_done>
800248c0:	0505                	add	a0,a0,1
800248c2:	01079713          	sll	a4,a5,0x10
800248c6:	e711                	bnez	a4,800248d2 <.Lstrlen_done>
800248c8:	0505                	add	a0,a0,1
800248ca:	00879713          	sll	a4,a5,0x8
800248ce:	e311                	bnez	a4,800248d2 <.Lstrlen_done>
800248d0:	0505                	add	a0,a0,1

800248d2 <.Lstrlen_done>:
800248d2:	8d0d                	sub	a0,a0,a1
800248d4:	8082                	ret

Disassembly of section .text.libc.strnlen:

800248d6 <strnlen>:
800248d6:	862a                	mv	a2,a0
800248d8:	852e                	mv	a0,a1
800248da:	c9c9                	beqz	a1,8002496c <.L528>
800248dc:	00064783          	lbu	a5,0(a2)
800248e0:	c7c9                	beqz	a5,8002496a <.L534>
800248e2:	00367793          	and	a5,a2,3
800248e6:	00379693          	sll	a3,a5,0x3
800248ea:	00f58533          	add	a0,a1,a5
800248ee:	ffc67713          	and	a4,a2,-4
800248f2:	57fd                	li	a5,-1
800248f4:	00d797b3          	sll	a5,a5,a3
800248f8:	4314                	lw	a3,0(a4)
800248fa:	fff7c793          	not	a5,a5
800248fe:	feff05b7          	lui	a1,0xfeff0
80024902:	80808837          	lui	a6,0x80808
80024906:	8fd5                	or	a5,a5,a3
80024908:	488d                	li	a7,3
8002490a:	eff58593          	add	a1,a1,-257 # fefefeff <__APB_SRAM_segment_end__+0xaefdeff>
8002490e:	08080813          	add	a6,a6,128 # 80808080 <__XPI0_segment_end__+0x8080>

80024912 <.L530>:
80024912:	00a8ff63          	bgeu	a7,a0,80024930 <.L529>
80024916:	00b786b3          	add	a3,a5,a1
8002491a:	fff7c313          	not	t1,a5
8002491e:	0066f6b3          	and	a3,a3,t1
80024922:	0106f6b3          	and	a3,a3,a6
80024926:	e689                	bnez	a3,80024930 <.L529>
80024928:	0711                	add	a4,a4,4
8002492a:	1571                	add	a0,a0,-4
8002492c:	431c                	lw	a5,0(a4)
8002492e:	b7d5                	j	80024912 <.L530>

80024930 <.L529>:
80024930:	0ff7f593          	zext.b	a1,a5
80024934:	c59d                	beqz	a1,80024962 <.L531>
80024936:	0087d593          	srl	a1,a5,0x8
8002493a:	0ff5f593          	zext.b	a1,a1
8002493e:	4685                	li	a3,1
80024940:	cd89                	beqz	a1,8002495a <.L532>
80024942:	0107d593          	srl	a1,a5,0x10
80024946:	0ff5f593          	zext.b	a1,a1
8002494a:	4689                	li	a3,2
8002494c:	c599                	beqz	a1,8002495a <.L532>
8002494e:	010005b7          	lui	a1,0x1000
80024952:	468d                	li	a3,3
80024954:	00b7e363          	bltu	a5,a1,8002495a <.L532>
80024958:	4691                	li	a3,4

8002495a <.L532>:
8002495a:	85aa                	mv	a1,a0
8002495c:	00a6f363          	bgeu	a3,a0,80024962 <.L531>
80024960:	85b6                	mv	a1,a3

80024962 <.L531>:
80024962:	8f11                	sub	a4,a4,a2
80024964:	00b70533          	add	a0,a4,a1
80024968:	8082                	ret

8002496a <.L534>:
8002496a:	4501                	li	a0,0

8002496c <.L528>:
8002496c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

8002496e <__SEGGER_RTL_stream_write>:
8002496e:	5154                	lw	a3,36(a0)
80024970:	87ae                	mv	a5,a1
80024972:	853e                	mv	a0,a5
80024974:	4585                	li	a1,1
80024976:	d06fd06f          	j	80021e7c <fwrite>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

8002497a <__SEGGER_RTL_putc>:
8002497a:	4918                	lw	a4,16(a0)
8002497c:	1101                	add	sp,sp,-32
8002497e:	0ff5f593          	zext.b	a1,a1
80024982:	cc22                	sw	s0,24(sp)
80024984:	ce06                	sw	ra,28(sp)
80024986:	00b107a3          	sb	a1,15(sp)
8002498a:	411c                	lw	a5,0(a0)
8002498c:	842a                	mv	s0,a0
8002498e:	cb05                	beqz	a4,800249be <.L24>
80024990:	4154                	lw	a3,4(a0)
80024992:	00d7ff63          	bgeu	a5,a3,800249b0 <.L26>
80024996:	495c                	lw	a5,20(a0)
80024998:	00178693          	add	a3,a5,1 # 800001 <_flash_size+0x1>
8002499c:	973e                	add	a4,a4,a5
8002499e:	c954                	sw	a3,20(a0)
800249a0:	00b70023          	sb	a1,0(a4)
800249a4:	4958                	lw	a4,20(a0)
800249a6:	4d1c                	lw	a5,24(a0)
800249a8:	00f71463          	bne	a4,a5,800249b0 <.L26>
800249ac:	bdcfe0ef          	jal	80022d88 <__SEGGER_RTL_prin_flush>

800249b0 <.L26>:
800249b0:	401c                	lw	a5,0(s0)
800249b2:	40f2                	lw	ra,28(sp)
800249b4:	0785                	add	a5,a5,1
800249b6:	c01c                	sw	a5,0(s0)
800249b8:	4462                	lw	s0,24(sp)
800249ba:	6105                	add	sp,sp,32
800249bc:	8082                	ret

800249be <.L24>:
800249be:	4558                	lw	a4,12(a0)
800249c0:	c305                	beqz	a4,800249e0 <.L28>
800249c2:	4154                	lw	a3,4(a0)
800249c4:	00178613          	add	a2,a5,1
800249c8:	00d61463          	bne	a2,a3,800249d0 <.L29>
800249cc:	000107a3          	sb	zero,15(sp)

800249d0 <.L29>:
800249d0:	fed7f0e3          	bgeu	a5,a3,800249b0 <.L26>
800249d4:	00f14683          	lbu	a3,15(sp)
800249d8:	973e                	add	a4,a4,a5
800249da:	00d70023          	sb	a3,0(a4)
800249de:	bfc9                	j	800249b0 <.L26>

800249e0 <.L28>:
800249e0:	4518                	lw	a4,8(a0)
800249e2:	c305                	beqz	a4,80024a02 <.L30>
800249e4:	4154                	lw	a3,4(a0)
800249e6:	00178613          	add	a2,a5,1
800249ea:	00d61463          	bne	a2,a3,800249f2 <.L31>
800249ee:	000107a3          	sb	zero,15(sp)

800249f2 <.L31>:
800249f2:	fad7ffe3          	bgeu	a5,a3,800249b0 <.L26>
800249f6:	078a                	sll	a5,a5,0x2
800249f8:	973e                	add	a4,a4,a5
800249fa:	00f14783          	lbu	a5,15(sp)
800249fe:	c31c                	sw	a5,0(a4)
80024a00:	bf45                	j	800249b0 <.L26>

80024a02 <.L30>:
80024a02:	5118                	lw	a4,32(a0)
80024a04:	d755                	beqz	a4,800249b0 <.L26>
80024a06:	4154                	lw	a3,4(a0)
80024a08:	fad7f4e3          	bgeu	a5,a3,800249b0 <.L26>
80024a0c:	4605                	li	a2,1
80024a0e:	00f10593          	add	a1,sp,15
80024a12:	9702                	jalr	a4
80024a14:	bf71                	j	800249b0 <.L26>

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

80024a16 <__SEGGER_RTL_print_padding>:
80024a16:	1141                	add	sp,sp,-16
80024a18:	c422                	sw	s0,8(sp)
80024a1a:	c226                	sw	s1,4(sp)
80024a1c:	c04a                	sw	s2,0(sp)
80024a1e:	c606                	sw	ra,12(sp)
80024a20:	84aa                	mv	s1,a0
80024a22:	892e                	mv	s2,a1
80024a24:	8432                	mv	s0,a2

80024a26 <.L37>:
80024a26:	147d                	add	s0,s0,-1
80024a28:	00045863          	bgez	s0,80024a38 <.L38>
80024a2c:	40b2                	lw	ra,12(sp)
80024a2e:	4422                	lw	s0,8(sp)
80024a30:	4492                	lw	s1,4(sp)
80024a32:	4902                	lw	s2,0(sp)
80024a34:	0141                	add	sp,sp,16
80024a36:	8082                	ret

80024a38 <.L38>:
80024a38:	85ca                	mv	a1,s2
80024a3a:	8526                	mv	a0,s1
80024a3c:	3f3d                	jal	8002497a <__SEGGER_RTL_putc>
80024a3e:	b7e5                	j	80024a26 <.L37>

Disassembly of section .text.libc.vfprintf_l:

80024a40 <vfprintf_l>:
80024a40:	711d                	add	sp,sp,-96
80024a42:	ce86                	sw	ra,92(sp)
80024a44:	cca2                	sw	s0,88(sp)
80024a46:	caa6                	sw	s1,84(sp)
80024a48:	1080                	add	s0,sp,96
80024a4a:	c8ca                	sw	s2,80(sp)
80024a4c:	c6ce                	sw	s3,76(sp)
80024a4e:	8932                	mv	s2,a2
80024a50:	fad42623          	sw	a3,-84(s0)
80024a54:	89aa                	mv	s3,a0
80024a56:	fab42423          	sw	a1,-88(s0)
80024a5a:	d1efe0ef          	jal	80022f78 <__SEGGER_RTL_X_file_bufsize>
80024a5e:	fa842583          	lw	a1,-88(s0)
80024a62:	00f50793          	add	a5,a0,15
80024a66:	9bc1                	and	a5,a5,-16
80024a68:	40f10133          	sub	sp,sp,a5
80024a6c:	84aa                	mv	s1,a0
80024a6e:	fb840513          	add	a0,s0,-72
80024a72:	b52fe0ef          	jal	80022dc4 <__SEGGER_RTL_init_prin_l>
80024a76:	800007b7          	lui	a5,0x80000
80024a7a:	fac42603          	lw	a2,-84(s0)
80024a7e:	17fd                	add	a5,a5,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
80024a80:	faf42e23          	sw	a5,-68(s0)
80024a84:	800257b7          	lui	a5,0x80025
80024a88:	96e78793          	add	a5,a5,-1682 # 8002496e <__SEGGER_RTL_stream_write>
80024a8c:	85ca                	mv	a1,s2
80024a8e:	fb840513          	add	a0,s0,-72
80024a92:	fc242423          	sw	sp,-56(s0)
80024a96:	fc942823          	sw	s1,-48(s0)
80024a9a:	fd342e23          	sw	s3,-36(s0)
80024a9e:	fcf42c23          	sw	a5,-40(s0)
80024aa2:	2811                	jal	80024ab6 <__SEGGER_RTL_vfprintf>
80024aa4:	fa040113          	add	sp,s0,-96
80024aa8:	40f6                	lw	ra,92(sp)
80024aaa:	4466                	lw	s0,88(sp)
80024aac:	44d6                	lw	s1,84(sp)
80024aae:	4946                	lw	s2,80(sp)
80024ab0:	49b6                	lw	s3,76(sp)
80024ab2:	6125                	add	sp,sp,96
80024ab4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

80024ab6 <__SEGGER_RTL_vfprintf>:
80024ab6:	7175                	add	sp,sp,-144
80024ab8:	f7018793          	add	a5,gp,-144 # 80020814 <.L9>
80024abc:	c83e                	sw	a5,16(sp)
80024abe:	dece                	sw	s3,124(sp)
80024ac0:	dad6                	sw	s5,116(sp)
80024ac2:	ceee                	sw	s11,92(sp)
80024ac4:	c706                	sw	ra,140(sp)
80024ac6:	c522                	sw	s0,136(sp)
80024ac8:	c326                	sw	s1,132(sp)
80024aca:	c14a                	sw	s2,128(sp)
80024acc:	dcd2                	sw	s4,120(sp)
80024ace:	d8da                	sw	s6,112(sp)
80024ad0:	d6de                	sw	s7,108(sp)
80024ad2:	d4e2                	sw	s8,104(sp)
80024ad4:	d2e6                	sw	s9,100(sp)
80024ad6:	d0ea                	sw	s10,96(sp)
80024ad8:	fb418793          	add	a5,gp,-76 # 80020858 <.L45>
80024adc:	00020db7          	lui	s11,0x20
80024ae0:	89aa                	mv	s3,a0
80024ae2:	8ab2                	mv	s5,a2
80024ae4:	00052023          	sw	zero,0(a0)
80024ae8:	ca3e                	sw	a5,20(sp)
80024aea:	021d8d93          	add	s11,s11,33 # 20021 <BOOT_USER_OFFSET+0x21>

80024aee <.L2>:
80024aee:	00158a13          	add	s4,a1,1 # 1000001 <_extram_size+0x1>
80024af2:	0005c583          	lbu	a1,0(a1)
80024af6:	e19d                	bnez	a1,80024b1c <.L229>
80024af8:	00c9a783          	lw	a5,12(s3)
80024afc:	cb91                	beqz	a5,80024b10 <.L230>
80024afe:	0009a703          	lw	a4,0(s3)
80024b02:	0049a683          	lw	a3,4(s3)
80024b06:	00d77563          	bgeu	a4,a3,80024b10 <.L230>
80024b0a:	97ba                	add	a5,a5,a4
80024b0c:	00078023          	sb	zero,0(a5)

80024b10 <.L230>:
80024b10:	854e                	mv	a0,s3
80024b12:	a76fe0ef          	jal	80022d88 <__SEGGER_RTL_prin_flush>
80024b16:	0009a503          	lw	a0,0(s3)
80024b1a:	a2f9                	j	80024ce8 <.L338>

80024b1c <.L229>:
80024b1c:	02500793          	li	a5,37
80024b20:	00f58563          	beq	a1,a5,80024b2a <.L231>

80024b24 <.L362>:
80024b24:	854e                	mv	a0,s3
80024b26:	3d91                	jal	8002497a <__SEGGER_RTL_putc>
80024b28:	aab9                	j	80024c86 <.L4>

80024b2a <.L231>:
80024b2a:	4b81                	li	s7,0
80024b2c:	03000613          	li	a2,48
80024b30:	05e00593          	li	a1,94
80024b34:	6505                	lui	a0,0x1
80024b36:	487d                	li	a6,31
80024b38:	48c1                	li	a7,16
80024b3a:	6321                	lui	t1,0x8
80024b3c:	a03d                	j	80024b6a <.L3>

80024b3e <.L5>:
80024b3e:	04b78f63          	beq	a5,a1,80024b9c <.L15>

80024b42 <.L232>:
80024b42:	8a36                	mv	s4,a3
80024b44:	4b01                	li	s6,0
80024b46:	46a5                	li	a3,9
80024b48:	45a9                	li	a1,10

80024b4a <.L18>:
80024b4a:	fd078713          	add	a4,a5,-48
80024b4e:	0ff77613          	zext.b	a2,a4
80024b52:	08c6e363          	bltu	a3,a2,80024bd8 <.L20>
80024b56:	02bb0b33          	mul	s6,s6,a1
80024b5a:	0a05                	add	s4,s4,1
80024b5c:	fffa4783          	lbu	a5,-1(s4)
80024b60:	9b3a                	add	s6,s6,a4
80024b62:	b7e5                	j	80024b4a <.L18>

80024b64 <.L14>:
80024b64:	040beb93          	or	s7,s7,64

80024b68 <.L16>:
80024b68:	8a36                	mv	s4,a3

80024b6a <.L3>:
80024b6a:	000a4783          	lbu	a5,0(s4)
80024b6e:	001a0693          	add	a3,s4,1
80024b72:	fcf666e3          	bltu	a2,a5,80024b3e <.L5>
80024b76:	fcf876e3          	bgeu	a6,a5,80024b42 <.L232>
80024b7a:	fe078713          	add	a4,a5,-32
80024b7e:	0ff77713          	zext.b	a4,a4
80024b82:	02e8e963          	bltu	a7,a4,80024bb4 <.L7>
80024b86:	4442                	lw	s0,16(sp)
80024b88:	070a                	sll	a4,a4,0x2
80024b8a:	9722                	add	a4,a4,s0
80024b8c:	4318                	lw	a4,0(a4)
80024b8e:	8702                	jr	a4

80024b90 <.L13>:
80024b90:	080beb93          	or	s7,s7,128
80024b94:	bfd1                	j	80024b68 <.L16>

80024b96 <.L12>:
80024b96:	006bebb3          	or	s7,s7,t1
80024b9a:	b7f9                	j	80024b68 <.L16>

80024b9c <.L15>:
80024b9c:	00abebb3          	or	s7,s7,a0
80024ba0:	b7e1                	j	80024b68 <.L16>

80024ba2 <.L11>:
80024ba2:	020beb93          	or	s7,s7,32
80024ba6:	b7c9                	j	80024b68 <.L16>

80024ba8 <.L10>:
80024ba8:	010beb93          	or	s7,s7,16
80024bac:	bf75                	j	80024b68 <.L16>

80024bae <.L8>:
80024bae:	200beb93          	or	s7,s7,512
80024bb2:	bf5d                	j	80024b68 <.L16>

80024bb4 <.L7>:
80024bb4:	02a00713          	li	a4,42
80024bb8:	f8e795e3          	bne	a5,a4,80024b42 <.L232>
80024bbc:	000aab03          	lw	s6,0(s5)
80024bc0:	004a8713          	add	a4,s5,4
80024bc4:	000b5663          	bgez	s6,80024bd0 <.L19>
80024bc8:	41600b33          	neg	s6,s6
80024bcc:	010beb93          	or	s7,s7,16

80024bd0 <.L19>:
80024bd0:	0006c783          	lbu	a5,0(a3) # 800000 <_flash_size>
80024bd4:	0a09                	add	s4,s4,2
80024bd6:	8aba                	mv	s5,a4

80024bd8 <.L20>:
80024bd8:	000b5363          	bgez	s6,80024bde <.L22>
80024bdc:	4b01                	li	s6,0

80024bde <.L22>:
80024bde:	02e00713          	li	a4,46
80024be2:	4481                	li	s1,0
80024be4:	04e79263          	bne	a5,a4,80024c28 <.L23>
80024be8:	000a4783          	lbu	a5,0(s4)
80024bec:	02a00713          	li	a4,42
80024bf0:	02e78263          	beq	a5,a4,80024c14 <.L24>
80024bf4:	0a05                	add	s4,s4,1
80024bf6:	46a5                	li	a3,9
80024bf8:	45a9                	li	a1,10

80024bfa <.L25>:
80024bfa:	fd078713          	add	a4,a5,-48
80024bfe:	0ff77613          	zext.b	a2,a4
80024c02:	00c6ef63          	bltu	a3,a2,80024c20 <.L26>
80024c06:	02b484b3          	mul	s1,s1,a1
80024c0a:	0a05                	add	s4,s4,1
80024c0c:	fffa4783          	lbu	a5,-1(s4)
80024c10:	94ba                	add	s1,s1,a4
80024c12:	b7e5                	j	80024bfa <.L25>

80024c14 <.L24>:
80024c14:	000aa483          	lw	s1,0(s5)
80024c18:	001a4783          	lbu	a5,1(s4)
80024c1c:	0a91                	add	s5,s5,4
80024c1e:	0a09                	add	s4,s4,2

80024c20 <.L26>:
80024c20:	0004c463          	bltz	s1,80024c28 <.L23>
80024c24:	100beb93          	or	s7,s7,256

80024c28 <.L23>:
80024c28:	06c00713          	li	a4,108
80024c2c:	06e78263          	beq	a5,a4,80024c90 <.L28>
80024c30:	02f76c63          	bltu	a4,a5,80024c68 <.L29>
80024c34:	06800713          	li	a4,104
80024c38:	06e78a63          	beq	a5,a4,80024cac <.L30>
80024c3c:	06a00713          	li	a4,106
80024c40:	04e78563          	beq	a5,a4,80024c8a <.L31>

80024c44 <.L32>:
80024c44:	05700713          	li	a4,87
80024c48:	2af760e3          	bltu	a4,a5,800256e8 <.L38>
80024c4c:	04500713          	li	a4,69
80024c50:	2ce78563          	beq	a5,a4,80024f1a <.L39>
80024c54:	06f76763          	bltu	a4,a5,80024cc2 <.L40>
80024c58:	c7c1                	beqz	a5,80024ce0 <.L41>
80024c5a:	02500713          	li	a4,37
80024c5e:	02500593          	li	a1,37
80024c62:	ece781e3          	beq	a5,a4,80024b24 <.L362>
80024c66:	a005                	j	80024c86 <.L4>

80024c68 <.L29>:
80024c68:	07400713          	li	a4,116
80024c6c:	00e78663          	beq	a5,a4,80024c78 <.L346>
80024c70:	07a00713          	li	a4,122
80024c74:	26e796e3          	bne	a5,a4,800256e0 <.L34>

80024c78 <.L346>:
80024c78:	000a4783          	lbu	a5,0(s4)
80024c7c:	0a05                	add	s4,s4,1

80024c7e <.L35>:
80024c7e:	07800713          	li	a4,120
80024c82:	fcf771e3          	bgeu	a4,a5,80024c44 <.L32>

80024c86 <.L4>:
80024c86:	85d2                	mv	a1,s4
80024c88:	b59d                	j	80024aee <.L2>

80024c8a <.L31>:
80024c8a:	002beb93          	or	s7,s7,2
80024c8e:	b7ed                	j	80024c78 <.L346>

80024c90 <.L28>:
80024c90:	000a4783          	lbu	a5,0(s4)
80024c94:	00e79863          	bne	a5,a4,80024ca4 <.L36>
80024c98:	002beb93          	or	s7,s7,2

80024c9c <.L347>:
80024c9c:	001a4783          	lbu	a5,1(s4)
80024ca0:	0a09                	add	s4,s4,2
80024ca2:	bff1                	j	80024c7e <.L35>

80024ca4 <.L36>:
80024ca4:	0a05                	add	s4,s4,1
80024ca6:	001beb93          	or	s7,s7,1
80024caa:	bfd1                	j	80024c7e <.L35>

80024cac <.L30>:
80024cac:	000a4783          	lbu	a5,0(s4)
80024cb0:	00e79563          	bne	a5,a4,80024cba <.L37>
80024cb4:	008beb93          	or	s7,s7,8
80024cb8:	b7d5                	j	80024c9c <.L347>

80024cba <.L37>:
80024cba:	0a05                	add	s4,s4,1
80024cbc:	004beb93          	or	s7,s7,4
80024cc0:	bf7d                	j	80024c7e <.L35>

80024cc2 <.L40>:
80024cc2:	04600713          	li	a4,70
80024cc6:	2ce78263          	beq	a5,a4,80024f8a <.L57>
80024cca:	04700713          	li	a4,71
80024cce:	fae79ce3          	bne	a5,a4,80024c86 <.L4>
80024cd2:	6789                	lui	a5,0x2
80024cd4:	00fbebb3          	or	s7,s7,a5

80024cd8 <.L52>:
80024cd8:	6905                	lui	s2,0x1
80024cda:	c0090913          	add	s2,s2,-1024 # c00 <__ILM_segment_used_end__+0x8c2>
80024cde:	ac65                	j	80024f96 <.L353>

80024ce0 <.L41>:
80024ce0:	854e                	mv	a0,s3
80024ce2:	8a6fe0ef          	jal	80022d88 <__SEGGER_RTL_prin_flush>
80024ce6:	557d                	li	a0,-1

80024ce8 <.L338>:
80024ce8:	40ba                	lw	ra,140(sp)
80024cea:	442a                	lw	s0,136(sp)
80024cec:	449a                	lw	s1,132(sp)
80024cee:	490a                	lw	s2,128(sp)
80024cf0:	59f6                	lw	s3,124(sp)
80024cf2:	5a66                	lw	s4,120(sp)
80024cf4:	5ad6                	lw	s5,116(sp)
80024cf6:	5b46                	lw	s6,112(sp)
80024cf8:	5bb6                	lw	s7,108(sp)
80024cfa:	5c26                	lw	s8,104(sp)
80024cfc:	5c96                	lw	s9,100(sp)
80024cfe:	5d06                	lw	s10,96(sp)
80024d00:	4df6                	lw	s11,92(sp)
80024d02:	6149                	add	sp,sp,144
80024d04:	8082                	ret

80024d06 <.L55>:
80024d06:	000aa483          	lw	s1,0(s5)
80024d0a:	1b7d                	add	s6,s6,-1
80024d0c:	865a                	mv	a2,s6
80024d0e:	85de                	mv	a1,s7
80024d10:	854e                	mv	a0,s3
80024d12:	898fe0ef          	jal	80022daa <__SEGGER_RTL_pre_padding>
80024d16:	004a8413          	add	s0,s5,4
80024d1a:	0ff4f593          	zext.b	a1,s1
80024d1e:	854e                	mv	a0,s3
80024d20:	39a9                	jal	8002497a <__SEGGER_RTL_putc>
80024d22:	8aa2                	mv	s5,s0

80024d24 <.L371>:
80024d24:	010bfb93          	and	s7,s7,16
80024d28:	f40b8fe3          	beqz	s7,80024c86 <.L4>
80024d2c:	865a                	mv	a2,s6
80024d2e:	02000593          	li	a1,32
80024d32:	854e                	mv	a0,s3
80024d34:	31cd                	jal	80024a16 <__SEGGER_RTL_print_padding>
80024d36:	bf81                	j	80024c86 <.L4>

80024d38 <.L50>:
80024d38:	008bf693          	and	a3,s7,8
80024d3c:	000aa783          	lw	a5,0(s5)
80024d40:	0009a703          	lw	a4,0(s3)
80024d44:	0a91                	add	s5,s5,4
80024d46:	c681                	beqz	a3,80024d4e <.L62>
80024d48:	00e78023          	sb	a4,0(a5) # 2000 <__APB_SRAM_segment_size__>
80024d4c:	bf2d                	j	80024c86 <.L4>

80024d4e <.L62>:
80024d4e:	002bfb93          	and	s7,s7,2
80024d52:	c398                	sw	a4,0(a5)
80024d54:	f20b89e3          	beqz	s7,80024c86 <.L4>
80024d58:	0007a223          	sw	zero,4(a5)
80024d5c:	b72d                	j	80024c86 <.L4>

80024d5e <.L47>:
80024d5e:	000aa403          	lw	s0,0(s5)
80024d62:	895e                	mv	s2,s7
80024d64:	0a91                	add	s5,s5,4

80024d66 <.L65>:
80024d66:	e019                	bnez	s0,80024d6c <.L66>
80024d68:	f4018413          	add	s0,gp,-192 # 800207e4 <.LC0>

80024d6c <.L66>:
80024d6c:	dff97b93          	and	s7,s2,-513
80024d70:	10097913          	and	s2,s2,256
80024d74:	02090563          	beqz	s2,80024d9e <.L67>
80024d78:	85a6                	mv	a1,s1
80024d7a:	8522                	mv	a0,s0
80024d7c:	3ea9                	jal	800248d6 <strnlen>

80024d7e <.L348>:
80024d7e:	40ab0b33          	sub	s6,s6,a0
80024d82:	84aa                	mv	s1,a0
80024d84:	865a                	mv	a2,s6
80024d86:	85de                	mv	a1,s7
80024d88:	854e                	mv	a0,s3
80024d8a:	820fe0ef          	jal	80022daa <__SEGGER_RTL_pre_padding>

80024d8e <.L69>:
80024d8e:	d8d9                	beqz	s1,80024d24 <.L371>
80024d90:	00044583          	lbu	a1,0(s0)
80024d94:	854e                	mv	a0,s3
80024d96:	0405                	add	s0,s0,1
80024d98:	36cd                	jal	8002497a <__SEGGER_RTL_putc>
80024d9a:	14fd                	add	s1,s1,-1
80024d9c:	bfcd                	j	80024d8e <.L69>

80024d9e <.L67>:
80024d9e:	8522                	mv	a0,s0
80024da0:	34f9                	jal	8002486e <strlen>
80024da2:	bff1                	j	80024d7e <.L348>

80024da4 <.L48>:
80024da4:	080bf713          	and	a4,s7,128
80024da8:	000aa403          	lw	s0,0(s5)
80024dac:	004a8693          	add	a3,s5,4
80024db0:	4581                	li	a1,0
80024db2:	02300c93          	li	s9,35
80024db6:	e311                	bnez	a4,80024dba <.L71>
80024db8:	4c81                	li	s9,0

80024dba <.L71>:
80024dba:	100beb93          	or	s7,s7,256
80024dbe:	8ab6                	mv	s5,a3
80024dc0:	44a1                	li	s1,8

80024dc2 <.L72>:
80024dc2:	100bf713          	and	a4,s7,256
80024dc6:	e311                	bnez	a4,80024dca <.L203>
80024dc8:	4485                	li	s1,1

80024dca <.L203>:
80024dca:	05800713          	li	a4,88
80024dce:	04e78ae3          	beq	a5,a4,80025622 <.L204>
80024dd2:	f9c78693          	add	a3,a5,-100
80024dd6:	4705                	li	a4,1
80024dd8:	00d71733          	sll	a4,a4,a3
80024ddc:	01b776b3          	and	a3,a4,s11
80024de0:	7c069c63          	bnez	a3,800255b8 <.L205>
80024de4:	00c75693          	srl	a3,a4,0xc
80024de8:	1016f693          	and	a3,a3,257
80024dec:	02069be3          	bnez	a3,80025622 <.L204>
80024df0:	06f00713          	li	a4,111
80024df4:	4c01                	li	s8,0
80024df6:	04e791e3          	bne	a5,a4,80025638 <.L206>

80024dfa <.L207>:
80024dfa:	00b467b3          	or	a5,s0,a1
80024dfe:	02078de3          	beqz	a5,80025638 <.L206>
80024e02:	183c                	add	a5,sp,56
80024e04:	01878733          	add	a4,a5,s8
80024e08:	00747793          	and	a5,s0,7
80024e0c:	03078793          	add	a5,a5,48
80024e10:	00f70023          	sb	a5,0(a4)
80024e14:	800d                	srl	s0,s0,0x3
80024e16:	01d59793          	sll	a5,a1,0x1d
80024e1a:	0c05                	add	s8,s8,1
80024e1c:	8c5d                	or	s0,s0,a5
80024e1e:	818d                	srl	a1,a1,0x3
80024e20:	bfe9                	j	80024dfa <.L207>

80024e22 <.L56>:
80024e22:	6709                	lui	a4,0x2
80024e24:	00ebebb3          	or	s7,s7,a4

80024e28 <.L44>:
80024e28:	080bf713          	and	a4,s7,128
80024e2c:	4c81                	li	s9,0
80024e2e:	cb19                	beqz	a4,80024e44 <.L75>
80024e30:	6c8d                	lui	s9,0x3
80024e32:	07800713          	li	a4,120
80024e36:	058c8c93          	add	s9,s9,88 # 3058 <__APB_SRAM_segment_size__+0x1058>
80024e3a:	00e79563          	bne	a5,a4,80024e44 <.L75>
80024e3e:	6c8d                	lui	s9,0x3
80024e40:	078c8c93          	add	s9,s9,120 # 3078 <__APB_SRAM_segment_size__+0x1078>

80024e44 <.L75>:
80024e44:	100bf713          	and	a4,s7,256

80024e48 <.L365>:
80024e48:	c319                	beqz	a4,80024e4e <.L74>
80024e4a:	dffbfb93          	and	s7,s7,-513

80024e4e <.L74>:
80024e4e:	011b9613          	sll	a2,s7,0x11
80024e52:	002bf713          	and	a4,s7,2
80024e56:	004bf693          	and	a3,s7,4
80024e5a:	08065563          	bgez	a2,80024ee4 <.L76>
80024e5e:	cf31                	beqz	a4,80024eba <.L77>
80024e60:	007a8713          	add	a4,s5,7
80024e64:	9b61                	and	a4,a4,-8
80024e66:	4300                	lw	s0,0(a4)
80024e68:	434c                	lw	a1,4(a4)
80024e6a:	00870a93          	add	s5,a4,8 # 2008 <__APB_SRAM_segment_size__+0x8>

80024e6e <.L78>:
80024e6e:	cea1                	beqz	a3,80024ec6 <.L79>
80024e70:	0442                	sll	s0,s0,0x10
80024e72:	8441                	sra	s0,s0,0x10

80024e74 <.L351>:
80024e74:	41f45593          	sra	a1,s0,0x1f

80024e78 <.L80>:
80024e78:	0405dd63          	bgez	a1,80024ed2 <.L82>
80024e7c:	00803733          	snez	a4,s0
80024e80:	40b005b3          	neg	a1,a1
80024e84:	8d99                	sub	a1,a1,a4
80024e86:	40800433          	neg	s0,s0
80024e8a:	02d00c93          	li	s9,45

80024e8e <.L84>:
80024e8e:	100bf713          	and	a4,s7,256
80024e92:	db05                	beqz	a4,80024dc2 <.L72>
80024e94:	dffbfb93          	and	s7,s7,-513
80024e98:	b72d                	j	80024dc2 <.L72>

80024e9a <.L49>:
80024e9a:	080bf713          	and	a4,s7,128
80024e9e:	03000c93          	li	s9,48
80024ea2:	f34d                	bnez	a4,80024e44 <.L75>
80024ea4:	4c81                	li	s9,0
80024ea6:	bf79                	j	80024e44 <.L75>

80024ea8 <.L46>:
80024ea8:	100bf713          	and	a4,s7,256
80024eac:	4c81                	li	s9,0
80024eae:	bf69                	j	80024e48 <.L365>

80024eb0 <.L51>:
80024eb0:	6711                	lui	a4,0x4
80024eb2:	00ebebb3          	or	s7,s7,a4
80024eb6:	4c81                	li	s9,0
80024eb8:	bf59                	j	80024e4e <.L74>

80024eba <.L77>:
80024eba:	000aa403          	lw	s0,0(s5)
80024ebe:	0a91                	add	s5,s5,4
80024ec0:	41f45593          	sra	a1,s0,0x1f
80024ec4:	b76d                	j	80024e6e <.L78>

80024ec6 <.L79>:
80024ec6:	008bf713          	and	a4,s7,8
80024eca:	d75d                	beqz	a4,80024e78 <.L80>
80024ecc:	0462                	sll	s0,s0,0x18
80024ece:	8461                	sra	s0,s0,0x18
80024ed0:	b755                	j	80024e74 <.L351>

80024ed2 <.L82>:
80024ed2:	020bf713          	and	a4,s7,32
80024ed6:	ef1d                	bnez	a4,80024f14 <.L239>
80024ed8:	040bf713          	and	a4,s7,64
80024edc:	db4d                	beqz	a4,80024e8e <.L84>
80024ede:	02000c93          	li	s9,32
80024ee2:	b775                	j	80024e8e <.L84>

80024ee4 <.L76>:
80024ee4:	cf09                	beqz	a4,80024efe <.L85>
80024ee6:	007a8713          	add	a4,s5,7
80024eea:	9b61                	and	a4,a4,-8
80024eec:	4300                	lw	s0,0(a4)
80024eee:	434c                	lw	a1,4(a4)
80024ef0:	00870a93          	add	s5,a4,8 # 4008 <__HEAPSIZE__+0x8>

80024ef4 <.L86>:
80024ef4:	ca91                	beqz	a3,80024f08 <.L87>
80024ef6:	0442                	sll	s0,s0,0x10
80024ef8:	8041                	srl	s0,s0,0x10

80024efa <.L352>:
80024efa:	4581                	li	a1,0
80024efc:	bf49                	j	80024e8e <.L84>

80024efe <.L85>:
80024efe:	000aa403          	lw	s0,0(s5)
80024f02:	4581                	li	a1,0
80024f04:	0a91                	add	s5,s5,4
80024f06:	b7fd                	j	80024ef4 <.L86>

80024f08 <.L87>:
80024f08:	008bf713          	and	a4,s7,8
80024f0c:	d349                	beqz	a4,80024e8e <.L84>
80024f0e:	0ff47413          	zext.b	s0,s0
80024f12:	b7e5                	j	80024efa <.L352>

80024f14 <.L239>:
80024f14:	02b00c93          	li	s9,43
80024f18:	bf9d                	j	80024e8e <.L84>

80024f1a <.L39>:
80024f1a:	6789                	lui	a5,0x2
80024f1c:	00fbebb3          	or	s7,s7,a5

80024f20 <.L54>:
80024f20:	400be913          	or	s2,s7,1024

80024f24 <.L91>:
80024f24:	00297793          	and	a5,s2,2
80024f28:	cbb5                	beqz	a5,80024f9c <.L92>
80024f2a:	000aa783          	lw	a5,0(s5)
80024f2e:	1008                	add	a0,sp,32
80024f30:	004a8413          	add	s0,s5,4
80024f34:	4398                	lw	a4,0(a5)
80024f36:	8aa2                	mv	s5,s0
80024f38:	d03a                	sw	a4,32(sp)
80024f3a:	43d8                	lw	a4,4(a5)
80024f3c:	d23a                	sw	a4,36(sp)
80024f3e:	4798                	lw	a4,8(a5)
80024f40:	d43a                	sw	a4,40(sp)
80024f42:	47dc                	lw	a5,12(a5)
80024f44:	d63e                	sw	a5,44(sp)
80024f46:	f28ff0ef          	jal	8002466e <__trunctfsf2>
80024f4a:	8baa                	mv	s7,a0

80024f4c <.L93>:
80024f4c:	10097793          	and	a5,s2,256
80024f50:	c3ad                	beqz	a5,80024fb2 <.L240>
80024f52:	e889                	bnez	s1,80024f64 <.L94>
80024f54:	6785                	lui	a5,0x1
80024f56:	c0078793          	add	a5,a5,-1024 # c00 <__ILM_segment_used_end__+0x8c2>
80024f5a:	00f974b3          	and	s1,s2,a5
80024f5e:	8c9d                	sub	s1,s1,a5
80024f60:	0014b493          	seqz	s1,s1

80024f64 <.L94>:
80024f64:	855e                	mv	a0,s7
80024f66:	ccefd0ef          	jal	80022434 <__SEGGER_RTL_float32_isinf>
80024f6a:	c531                	beqz	a0,80024fb6 <.L95>

80024f6c <.L117>:
80024f6c:	6409                	lui	s0,0x2
80024f6e:	00000593          	li	a1,0
80024f72:	855e                	mv	a0,s7
80024f74:	00897433          	and	s0,s2,s0
80024f78:	900fd0ef          	jal	80022078 <__ltsf2>
80024f7c:	3e055963          	bgez	a0,8002536e <.L341>
80024f80:	3e040463          	beqz	s0,80025368 <.L244>
80024f84:	f4818413          	add	s0,gp,-184 # 800207ec <.LC1>
80024f88:	a089                	j	80024fca <.L122>

80024f8a <.L57>:
80024f8a:	6789                	lui	a5,0x2
80024f8c:	00fbebb3          	or	s7,s7,a5

80024f90 <.L53>:
80024f90:	6905                	lui	s2,0x1
80024f92:	80090913          	add	s2,s2,-2048 # 800 <__ILM_segment_used_end__+0x4c2>

80024f96 <.L353>:
80024f96:	012be933          	or	s2,s7,s2
80024f9a:	b769                	j	80024f24 <.L91>

80024f9c <.L92>:
80024f9c:	007a8793          	add	a5,s5,7
80024fa0:	9be1                	and	a5,a5,-8
80024fa2:	4388                	lw	a0,0(a5)
80024fa4:	43cc                	lw	a1,4(a5)
80024fa6:	00878a93          	add	s5,a5,8 # 2008 <__APB_SRAM_segment_size__+0x8>
80024faa:	b78fd0ef          	jal	80022322 <__truncdfsf2>
80024fae:	8baa                	mv	s7,a0
80024fb0:	bf71                	j	80024f4c <.L93>

80024fb2 <.L240>:
80024fb2:	4499                	li	s1,6
80024fb4:	bf45                	j	80024f64 <.L94>

80024fb6 <.L95>:
80024fb6:	855e                	mv	a0,s7
80024fb8:	c6afd0ef          	jal	80022422 <__SEGGER_RTL_float32_isnan>
80024fbc:	cd09                	beqz	a0,80024fd6 <.L101>
80024fbe:	01291793          	sll	a5,s2,0x12
80024fc2:	0007d763          	bgez	a5,80024fd0 <.L243>
80024fc6:	f6818413          	add	s0,gp,-152 # 8002080c <.LC5>

80024fca <.L122>:
80024fca:	eff97913          	and	s2,s2,-257
80024fce:	bb61                	j	80024d66 <.L65>

80024fd0 <.L243>:
80024fd0:	f6c18413          	add	s0,gp,-148 # 80020810 <.LC6>
80024fd4:	bfdd                	j	80024fca <.L122>

80024fd6 <.L101>:
80024fd6:	855e                	mv	a0,s7
80024fd8:	c6afd0ef          	jal	80022442 <__SEGGER_RTL_float32_isnormal>
80024fdc:	e119                	bnez	a0,80024fe2 <.L103>
80024fde:	00000b93          	li	s7,0

80024fe2 <.L103>:
80024fe2:	855e                	mv	a0,s7
80024fe4:	845e                	mv	s0,s7
80024fe6:	eacff0ef          	jal	80024692 <__SEGGER_RTL_float32_signbit>
80024fea:	c519                	beqz	a0,80024ff8 <.L104>
80024fec:	80000437          	lui	s0,0x80000
80024ff0:	06096913          	or	s2,s2,96
80024ff4:	01744433          	xor	s0,s0,s7

80024ff8 <.L104>:
80024ff8:	184c                	add	a1,sp,52
80024ffa:	8522                	mv	a0,s0
80024ffc:	edeff0ef          	jal	800246da <frexpf>
80025000:	5752                	lw	a4,52(sp)
80025002:	478d                	li	a5,3
80025004:	00000593          	li	a1,0
80025008:	02e787b3          	mul	a5,a5,a4
8002500c:	4729                	li	a4,10
8002500e:	8522                	mv	a0,s0
80025010:	8ba2                	mv	s7,s0
80025012:	02e7c7b3          	div	a5,a5,a4
80025016:	da3e                	sw	a5,52(sp)
80025018:	d82ff0ef          	jal	8002459a <__eqsf2>
8002501c:	24051063          	bnez	a0,8002525c <.L105>

80025020 <.L111>:
80025020:	6785                	lui	a5,0x1
80025022:	c0078793          	add	a5,a5,-1024 # c00 <__ILM_segment_used_end__+0x8c2>
80025026:	00f97c33          	and	s8,s2,a5
8002502a:	40000713          	li	a4,1024
8002502e:	5552                	lw	a0,52(sp)
80025030:	24ec1d63          	bne	s8,a4,8002528a <.L340>

80025034 <.L106>:
80025034:	02600793          	li	a5,38
80025038:	30f51f63          	bne	a0,a5,80025356 <.L113>
8002503c:	14c1a583          	lw	a1,332(gp) # 800209f0 <.Lmerged_single+0x10>
80025040:	855e                	mv	a0,s7
80025042:	a98ff0ef          	jal	800242da <__divsf3>

80025046 <.L354>:
80025046:	00000593          	li	a1,0
8002504a:	8baa                	mv	s7,a0
8002504c:	842a                	mv	s0,a0
8002504e:	d4cff0ef          	jal	8002459a <__eqsf2>
80025052:	cd39                	beqz	a0,800250b0 <.L116>
80025054:	855e                	mv	a0,s7
80025056:	bdefd0ef          	jal	80022434 <__SEGGER_RTL_float32_isinf>
8002505a:	f00519e3          	bnez	a0,80024f6c <.L117>
8002505e:	57d2                	lw	a5,52(sp)
80025060:	4701                	li	a4,0

80025062 <.L118>:
80025062:	c63e                	sw	a5,12(sp)
80025064:	00178d13          	add	s10,a5,1
80025068:	1441a583          	lw	a1,324(gp) # 800209e8 <.Lmerged_single+0x8>
8002506c:	855e                	mv	a0,s7
8002506e:	cc3a                	sw	a4,24(sp)
80025070:	8aafd0ef          	jal	8002211a <__gesf2>
80025074:	47b2                	lw	a5,12(sp)
80025076:	4762                	lw	a4,24(sp)
80025078:	30055763          	bgez	a0,80025386 <.L124>
8002507c:	c319                	beqz	a4,80025082 <.L125>
8002507e:	845e                	mv	s0,s7
80025080:	da3e                	sw	a5,52(sp)

80025082 <.L125>:
80025082:	1401a703          	lw	a4,320(gp) # 800209e4 <.Lmerged_single+0x4>
80025086:	5d52                	lw	s10,52(sp)
80025088:	1441ac83          	lw	s9,324(gp) # 800209e8 <.Lmerged_single+0x8>
8002508c:	87a2                	mv	a5,s0
8002508e:	4681                	li	a3,0
80025090:	c63a                	sw	a4,12(sp)

80025092 <.L126>:
80025092:	45b2                	lw	a1,12(sp)
80025094:	853e                	mv	a0,a5
80025096:	ce36                	sw	a3,28(sp)
80025098:	cc3e                	sw	a5,24(sp)
8002509a:	fdffc0ef          	jal	80022078 <__ltsf2>
8002509e:	47e2                	lw	a5,24(sp)
800250a0:	46f2                	lw	a3,28(sp)
800250a2:	fffd0b93          	add	s7,s10,-1
800250a6:	2e054963          	bltz	a0,80025398 <.L127>
800250aa:	c299                	beqz	a3,800250b0 <.L116>
800250ac:	843e                	mv	s0,a5
800250ae:	da6a                	sw	s10,52(sp)

800250b0 <.L116>:
800250b0:	c499                	beqz	s1,800250be <.L129>
800250b2:	6785                	lui	a5,0x1
800250b4:	c0078793          	add	a5,a5,-1024 # c00 <__ILM_segment_used_end__+0x8c2>
800250b8:	00fc1363          	bne	s8,a5,800250be <.L129>
800250bc:	14fd                	add	s1,s1,-1

800250be <.L129>:
800250be:	40900533          	neg	a0,s1
800250c2:	c75fd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
800250c6:	55fd                	li	a1,-1
800250c8:	dceff0ef          	jal	80024696 <ldexpf>
800250cc:	85a2                	mv	a1,s0
800250ce:	dfdfc0ef          	jal	80021eca <__addsf3>
800250d2:	1441a583          	lw	a1,324(gp) # 800209e8 <.Lmerged_single+0x8>
800250d6:	8baa                	mv	s7,a0
800250d8:	842a                	mv	s0,a0
800250da:	840fd0ef          	jal	8002211a <__gesf2>
800250de:	00054b63          	bltz	a0,800250f4 <.L130>
800250e2:	57d2                	lw	a5,52(sp)
800250e4:	1441a583          	lw	a1,324(gp) # 800209e8 <.Lmerged_single+0x8>
800250e8:	855e                	mv	a0,s7
800250ea:	0785                	add	a5,a5,1
800250ec:	da3e                	sw	a5,52(sp)
800250ee:	9ecff0ef          	jal	800242da <__divsf3>
800250f2:	842a                	mv	s0,a0

800250f4 <.L130>:
800250f4:	c622                	sw	s0,12(sp)
800250f6:	2a049963          	bnez	s1,800253a8 <.L132>

800250fa <.L135>:
800250fa:	4481                	li	s1,0

800250fc <.L133>:
800250fc:	00548793          	add	a5,s1,5
80025100:	7c7d                	lui	s8,0xfffff
80025102:	40fb0b33          	sub	s6,s6,a5
80025106:	08097793          	and	a5,s2,128
8002510a:	7ffc0c13          	add	s8,s8,2047 # fffff7ff <__APB_SRAM_segment_end__+0xbf0d7ff>
8002510e:	8fc5                	or	a5,a5,s1
80025110:	01897c33          	and	s8,s2,s8
80025114:	c391                	beqz	a5,80025118 <.L139>
80025116:	1b7d                	add	s6,s6,-1

80025118 <.L139>:
80025118:	01391793          	sll	a5,s2,0x13
8002511c:	4d05                	li	s10,1
8002511e:	0207dc63          	bgez	a5,80025156 <.L140>
80025122:	5bd2                	lw	s7,52(sp)
80025124:	470d                	li	a4,3
80025126:	02ebe733          	rem	a4,s7,a4
8002512a:	c31d                	beqz	a4,80025150 <.L141>
8002512c:	0709                	add	a4,a4,2
8002512e:	56b5                	li	a3,-19
80025130:	40e6d733          	sra	a4,a3,a4
80025134:	8b05                	and	a4,a4,1
80025136:	2c070663          	beqz	a4,80025402 <.L142>
8002513a:	1441a583          	lw	a1,324(gp) # 800209e8 <.Lmerged_single+0x8>
8002513e:	4532                	lw	a0,12(sp)
80025140:	1b7d                	add	s6,s6,-1
80025142:	4d09                	li	s10,2
80025144:	fd7fe0ef          	jal	8002411a <__mulsf3>
80025148:	fffb8793          	add	a5,s7,-1
8002514c:	842a                	mv	s0,a0
8002514e:	da3e                	sw	a5,52(sp)

80025150 <.L141>:
80025150:	0004d363          	bgez	s1,80025156 <.L140>
80025154:	4481                	li	s1,0

80025156 <.L140>:
80025156:	06097913          	and	s2,s2,96
8002515a:	00090363          	beqz	s2,80025160 <.L144>
8002515e:	1b7d                	add	s6,s6,-1

80025160 <.L144>:
80025160:	5552                	lw	a0,52(sp)
80025162:	bcbfd0ef          	jal	80022d2c <abs>
80025166:	06300793          	li	a5,99
8002516a:	00a7d363          	bge	a5,a0,80025170 <.L145>
8002516e:	1b7d                	add	s6,s6,-1

80025170 <.L145>:
80025170:	8522                	mv	a0,s0
80025172:	c54ff0ef          	jal	800245c6 <__fixunssfdi>
80025176:	8bae                	mv	s7,a1
80025178:	8caa                	mv	s9,a0
8002517a:	8fefd0ef          	jal	80022278 <__floatundisf>
8002517e:	85aa                	mv	a1,a0
80025180:	8522                	mv	a0,s0
80025182:	d41fc0ef          	jal	80021ec2 <__subsf3>
80025186:	842a                	mv	s0,a0

80025188 <.L146>:
80025188:	895a                	mv	s2,s6
8002518a:	000b5363          	bgez	s6,80025190 <.L165>
8002518e:	4901                	li	s2,0

80025190 <.L165>:
80025190:	210c7793          	and	a5,s8,528
80025194:	e399                	bnez	a5,8002519a <.L167>

80025196 <.L166>:
80025196:	2e091d63          	bnez	s2,80025490 <.L168>

8002519a <.L167>:
8002519a:	020c7713          	and	a4,s8,32
8002519e:	040c7793          	and	a5,s8,64
800251a2:	2e070e63          	beqz	a4,8002549e <.L169>
800251a6:	02b00593          	li	a1,43
800251aa:	c399                	beqz	a5,800251b0 <.L358>
800251ac:	02d00593          	li	a1,45

800251b0 <.L358>:
800251b0:	854e                	mv	a0,s3
800251b2:	fc8ff0ef          	jal	8002497a <__SEGGER_RTL_putc>

800251b6 <.L171>:
800251b6:	010c7793          	and	a5,s8,16
800251ba:	e399                	bnez	a5,800251c0 <.L173>

800251bc <.L172>:
800251bc:	2e091663          	bnez	s2,800254a8 <.L174>

800251c0 <.L173>:
800251c0:	80020b37          	lui	s6,0x80020
800251c4:	098b0b13          	add	s6,s6,152 # 80020098 <__SEGGER_RTL_ipow10>

800251c8 <.L178>:
800251c8:	1d7d                	add	s10,s10,-1
800251ca:	003d1793          	sll	a5,s10,0x3
800251ce:	97da                	add	a5,a5,s6
800251d0:	4398                	lw	a4,0(a5)
800251d2:	43dc                	lw	a5,4(a5)
800251d4:	03000593          	li	a1,48

800251d8 <.L175>:
800251d8:	00fbe663          	bltu	s7,a5,800251e4 <.L258>
800251dc:	2d779d63          	bne	a5,s7,800254b6 <.L176>
800251e0:	2cecfb63          	bgeu	s9,a4,800254b6 <.L176>

800251e4 <.L258>:
800251e4:	854e                	mv	a0,s3
800251e6:	f94ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
800251ea:	fc0d1fe3          	bnez	s10,800251c8 <.L178>
800251ee:	6b85                	lui	s7,0x1
800251f0:	800b8b93          	add	s7,s7,-2048 # 800 <__ILM_segment_used_end__+0x4c2>
800251f4:	017c7bb3          	and	s7,s8,s7
800251f8:	2e0b9363          	bnez	s7,800254de <.L179>

800251fc <.L183>:
800251fc:	080c7793          	and	a5,s8,128
80025200:	8fc5                	or	a5,a5,s1
80025202:	c3a1                	beqz	a5,80025242 <.L181>
80025204:	02e00593          	li	a1,46
80025208:	854e                	mv	a0,s3
8002520a:	f70ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
8002520e:	47c1                	li	a5,16
80025210:	8ca6                	mv	s9,s1
80025212:	2c97da63          	bge	a5,s1,800254e6 <.L186>
80025216:	4cc1                	li	s9,16

80025218 <.L187>:
80025218:	419484b3          	sub	s1,s1,s9
8002521c:	8566                	mv	a0,s9
8002521e:	000b8563          	beqz	s7,80025228 <.L359>
80025222:	5552                	lw	a0,52(sp)
80025224:	40ac8533          	sub	a0,s9,a0

80025228 <.L359>:
80025228:	b0ffd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
8002522c:	85a2                	mv	a1,s0
8002522e:	eedfe0ef          	jal	8002411a <__mulsf3>
80025232:	b94ff0ef          	jal	800245c6 <__fixunssfdi>
80025236:	8baa                	mv	s7,a0
80025238:	842e                	mv	s0,a1

8002523a <.L193>:
8002523a:	2a0c9a63          	bnez	s9,800254ee <.L194>

8002523e <.L195>:
8002523e:	2e049563          	bnez	s1,80025528 <.L196>

80025242 <.L181>:
80025242:	400c7793          	and	a5,s8,1024
80025246:	2e079863          	bnez	a5,80025536 <.L184>

8002524a <.L201>:
8002524a:	a2090ee3          	beqz	s2,80024c86 <.L4>
8002524e:	197d                	add	s2,s2,-1
80025250:	02000593          	li	a1,32
80025254:	ae81                	j	800255a4 <.L360>

80025256 <.L108>:
80025256:	57d2                	lw	a5,52(sp)
80025258:	0785                	add	a5,a5,1
8002525a:	da3e                	sw	a5,52(sp)

8002525c <.L105>:
8002525c:	5552                	lw	a0,52(sp)
8002525e:	0505                	add	a0,a0,1 # 1001 <__ILM_segment_used_end__+0xcc3>
80025260:	ad7fd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
80025264:	85aa                	mv	a1,a0
80025266:	855e                	mv	a0,s7
80025268:	e81fc0ef          	jal	800220e8 <__gtsf2>
8002526c:	fea045e3          	bgtz	a0,80025256 <.L108>

80025270 <.L109>:
80025270:	5552                	lw	a0,52(sp)
80025272:	ac5fd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
80025276:	85aa                	mv	a1,a0
80025278:	855e                	mv	a0,s7
8002527a:	dfffc0ef          	jal	80022078 <__ltsf2>
8002527e:	da0551e3          	bgez	a0,80025020 <.L111>
80025282:	57d2                	lw	a5,52(sp)
80025284:	17fd                	add	a5,a5,-1
80025286:	da3e                	sw	a5,52(sp)
80025288:	b7e5                	j	80025270 <.L109>

8002528a <.L340>:
8002528a:	00fc1763          	bne	s8,a5,80025298 <.L112>
8002528e:	da9553e3          	bge	a0,s1,80025034 <.L106>
80025292:	57f1                	li	a5,-4
80025294:	0cf54163          	blt	a0,a5,80025356 <.L113>

80025298 <.L112>:
80025298:	08097793          	and	a5,s2,128
8002529c:	c63e                	sw	a5,12(sp)
8002529e:	40097793          	and	a5,s2,1024
800252a2:	c789                	beqz	a5,800252ac <.L147>
800252a4:	47b9                	li	a5,14
800252a6:	16a7da63          	bge	a5,a0,8002541a <.L148>

800252aa <.L153>:
800252aa:	4481                	li	s1,0

800252ac <.L147>:
800252ac:	57d2                	lw	a5,52(sp)
800252ae:	40900533          	neg	a0,s1
800252b2:	bff97c13          	and	s8,s2,-1025
800252b6:	ff178713          	add	a4,a5,-15
800252ba:	00e55463          	bge	a0,a4,800252c2 <.L154>
800252be:	ff078513          	add	a0,a5,-16

800252c2 <.L154>:
800252c2:	a75fd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
800252c6:	55fd                	li	a1,-1
800252c8:	bceff0ef          	jal	80024696 <ldexpf>
800252cc:	85aa                	mv	a1,a0
800252ce:	855e                	mv	a0,s7
800252d0:	bfbfc0ef          	jal	80021eca <__addsf3>
800252d4:	8d2a                	mv	s10,a0
800252d6:	842a                	mv	s0,a0
800252d8:	5552                	lw	a0,52(sp)
800252da:	0505                	add	a0,a0,1
800252dc:	a5bfd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
800252e0:	85ea                	mv	a1,s10
800252e2:	dd1fc0ef          	jal	800220b2 <__lesf2>
800252e6:	00a04563          	bgtz	a0,800252f0 <.L156>
800252ea:	57d2                	lw	a5,52(sp)
800252ec:	0785                	add	a5,a5,1
800252ee:	da3e                	sw	a5,52(sp)

800252f0 <.L156>:
800252f0:	57d2                	lw	a5,52(sp)
800252f2:	1807c963          	bltz	a5,80025484 <.L158>
800252f6:	4541                	li	a0,16
800252f8:	16f55863          	bge	a0,a5,80025468 <.L159>
800252fc:	ff078713          	add	a4,a5,-16
80025300:	8d1d                	sub	a0,a0,a5
80025302:	da3a                	sw	a4,52(sp)
80025304:	a33fd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
80025308:	85ea                	mv	a1,s10
8002530a:	e11fe0ef          	jal	8002411a <__mulsf3>
8002530e:	ab8ff0ef          	jal	800245c6 <__fixunssfdi>
80025312:	8caa                	mv	s9,a0
80025314:	8bae                	mv	s7,a1
80025316:	00000413          	li	s0,0

8002531a <.L160>:
8002531a:	800207b7          	lui	a5,0x80020
8002531e:	09878793          	add	a5,a5,152 # 80020098 <__SEGGER_RTL_ipow10>
80025322:	4d05                	li	s10,1

80025324 <.L161>:
80025324:	47d8                	lw	a4,12(a5)
80025326:	07a1                	add	a5,a5,8
80025328:	00ebe763          	bltu	s7,a4,80025336 <.L257>
8002532c:	17771063          	bne	a4,s7,8002548c <.L162>
80025330:	4398                	lw	a4,0(a5)
80025332:	14ecfd63          	bgeu	s9,a4,8002548c <.L162>

80025336 <.L257>:
80025336:	5752                	lw	a4,52(sp)
80025338:	009d07b3          	add	a5,s10,s1
8002533c:	97ba                	add	a5,a5,a4
8002533e:	40fb0b33          	sub	s6,s6,a5
80025342:	47b2                	lw	a5,12(sp)
80025344:	8fc5                	or	a5,a5,s1
80025346:	c391                	beqz	a5,8002534a <.L164>
80025348:	1b7d                	add	s6,s6,-1

8002534a <.L164>:
8002534a:	06097793          	and	a5,s2,96
8002534e:	e2078de3          	beqz	a5,80025188 <.L146>
80025352:	1b7d                	add	s6,s6,-1
80025354:	bd15                	j	80025188 <.L146>

80025356 <.L113>:
80025356:	40a00533          	neg	a0,a0
8002535a:	9ddfd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
8002535e:	85aa                	mv	a1,a0
80025360:	855e                	mv	a0,s7
80025362:	db9fe0ef          	jal	8002411a <__mulsf3>
80025366:	b1c5                	j	80025046 <.L354>

80025368 <.L244>:
80025368:	f5018413          	add	s0,gp,-176 # 800207f4 <.LC2>
8002536c:	b9b9                	j	80024fca <.L122>

8002536e <.L341>:
8002536e:	c809                	beqz	s0,80025380 <.L245>
80025370:	f5818413          	add	s0,gp,-168 # 800207fc <.LC3>

80025374 <.L123>:
80025374:	02097793          	and	a5,s2,32
80025378:	c40799e3          	bnez	a5,80024fca <.L122>
8002537c:	0405                	add	s0,s0,1 # 80000001 <__SHARE_RAM_segment_end__+0x7ee80001>
8002537e:	b1b1                	j	80024fca <.L122>

80025380 <.L245>:
80025380:	f6018413          	add	s0,gp,-160 # 80020804 <.LC4>
80025384:	bfc5                	j	80025374 <.L123>

80025386 <.L124>:
80025386:	1441a583          	lw	a1,324(gp) # 800209e8 <.Lmerged_single+0x8>
8002538a:	855e                	mv	a0,s7
8002538c:	f4ffe0ef          	jal	800242da <__divsf3>
80025390:	8baa                	mv	s7,a0
80025392:	87ea                	mv	a5,s10
80025394:	4705                	li	a4,1
80025396:	b1f1                	j	80025062 <.L118>

80025398 <.L127>:
80025398:	853e                	mv	a0,a5
8002539a:	85e6                	mv	a1,s9
8002539c:	d7ffe0ef          	jal	8002411a <__mulsf3>
800253a0:	87aa                	mv	a5,a0
800253a2:	8d5e                	mv	s10,s7
800253a4:	4685                	li	a3,1
800253a6:	b1f5                	j	80025092 <.L126>

800253a8 <.L132>:
800253a8:	6785                	lui	a5,0x1
800253aa:	88078793          	add	a5,a5,-1920 # 880 <__ILM_segment_used_end__+0x542>
800253ae:	00f977b3          	and	a5,s2,a5
800253b2:	80078793          	add	a5,a5,-2048
800253b6:	d40793e3          	bnez	a5,800250fc <.L133>
800253ba:	47c1                	li	a5,16
800253bc:	0097d363          	bge	a5,s1,800253c2 <.L134>
800253c0:	44c1                	li	s1,16

800253c2 <.L134>:
800253c2:	8526                	mv	a0,s1
800253c4:	973fd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
800253c8:	85a2                	mv	a1,s0
800253ca:	d51fe0ef          	jal	8002411a <__mulsf3>
800253ce:	9f8ff0ef          	jal	800245c6 <__fixunssfdi>
800253d2:	00a5e7b3          	or	a5,a1,a0
800253d6:	8c2a                	mv	s8,a0
800253d8:	8d2e                	mv	s10,a1
800253da:	d20780e3          	beqz	a5,800250fa <.L135>

800253de <.L357>:
800253de:	4629                	li	a2,10
800253e0:	4681                	li	a3,0
800253e2:	d16fd0ef          	jal	800228f8 <__umoddi3>
800253e6:	8d4d                	or	a0,a0,a1
800253e8:	d0051ae3          	bnez	a0,800250fc <.L133>
800253ec:	8562                	mv	a0,s8
800253ee:	85ea                	mv	a1,s10
800253f0:	4629                	li	a2,10
800253f2:	4681                	li	a3,0
800253f4:	8ecfd0ef          	jal	800224e0 <__udivdi3>
800253f8:	14fd                	add	s1,s1,-1
800253fa:	8c2a                	mv	s8,a0
800253fc:	8d2e                	mv	s10,a1
800253fe:	f0e5                	bnez	s1,800253de <.L357>
80025400:	b9ed                	j	800250fa <.L135>

80025402 <.L142>:
80025402:	1481a583          	lw	a1,328(gp) # 800209ec <.Lmerged_single+0xc>
80025406:	4532                	lw	a0,12(sp)
80025408:	1b79                	add	s6,s6,-2
8002540a:	4d0d                	li	s10,3
8002540c:	d0ffe0ef          	jal	8002411a <__mulsf3>
80025410:	ffeb8793          	add	a5,s7,-2
80025414:	842a                	mv	s0,a0
80025416:	da3e                	sw	a5,52(sp)
80025418:	bb25                	j	80025150 <.L141>

8002541a <.L148>:
8002541a:	0505                	add	a0,a0,1
8002541c:	8c89                	sub	s1,s1,a0
8002541e:	47c1                	li	a5,16
80025420:	0097d363          	bge	a5,s1,80025426 <.L149>
80025424:	44c1                	li	s1,16

80025426 <.L149>:
80025426:	08097793          	and	a5,s2,128
8002542a:	e80791e3          	bnez	a5,800252ac <.L147>
8002542e:	13c1ac03          	lw	s8,316(gp) # 800209e0 <.Lmerged_single>
80025432:	1441a403          	lw	s0,324(gp) # 800209e8 <.Lmerged_single+0x8>

80025436 <.L150>:
80025436:	e6048ae3          	beqz	s1,800252aa <.L153>
8002543a:	8526                	mv	a0,s1
8002543c:	8fbfd0ef          	jal	80022d36 <__SEGGER_RTL_pow10f>
80025440:	85aa                	mv	a1,a0
80025442:	855e                	mv	a0,s7
80025444:	cd7fe0ef          	jal	8002411a <__mulsf3>
80025448:	85e2                	mv	a1,s8
8002544a:	a81fc0ef          	jal	80021eca <__addsf3>
8002544e:	806fd0ef          	jal	80022454 <floorf>
80025452:	85a2                	mv	a1,s0
80025454:	ab2ff0ef          	jal	80024706 <fmodf>
80025458:	00000593          	li	a1,0
8002545c:	93eff0ef          	jal	8002459a <__eqsf2>
80025460:	e40516e3          	bnez	a0,800252ac <.L147>
80025464:	14fd                	add	s1,s1,-1
80025466:	bfc1                	j	80025436 <.L150>

80025468 <.L159>:
80025468:	856a                	mv	a0,s10
8002546a:	da02                	sw	zero,52(sp)
8002546c:	95aff0ef          	jal	800245c6 <__fixunssfdi>
80025470:	8bae                	mv	s7,a1
80025472:	8caa                	mv	s9,a0
80025474:	e05fc0ef          	jal	80022278 <__floatundisf>
80025478:	85aa                	mv	a1,a0
8002547a:	856a                	mv	a0,s10
8002547c:	a47fc0ef          	jal	80021ec2 <__subsf3>
80025480:	842a                	mv	s0,a0
80025482:	bd61                	j	8002531a <.L160>

80025484 <.L158>:
80025484:	da02                	sw	zero,52(sp)
80025486:	4c81                	li	s9,0
80025488:	4b81                	li	s7,0
8002548a:	bd41                	j	8002531a <.L160>

8002548c <.L162>:
8002548c:	0d05                	add	s10,s10,1
8002548e:	bd59                	j	80025324 <.L161>

80025490 <.L168>:
80025490:	02000593          	li	a1,32
80025494:	854e                	mv	a0,s3
80025496:	197d                	add	s2,s2,-1
80025498:	ce2ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
8002549c:	b9ed                	j	80025196 <.L166>

8002549e <.L169>:
8002549e:	d0078ce3          	beqz	a5,800251b6 <.L171>
800254a2:	02000593          	li	a1,32
800254a6:	b329                	j	800251b0 <.L358>

800254a8 <.L174>:
800254a8:	03000593          	li	a1,48
800254ac:	854e                	mv	a0,s3
800254ae:	197d                	add	s2,s2,-1
800254b0:	ccaff0ef          	jal	8002497a <__SEGGER_RTL_putc>
800254b4:	b321                	j	800251bc <.L172>

800254b6 <.L176>:
800254b6:	40ec86b3          	sub	a3,s9,a4
800254ba:	00dcb633          	sltu	a2,s9,a3
800254be:	0585                	add	a1,a1,1
800254c0:	40fb8bb3          	sub	s7,s7,a5
800254c4:	0ff5f593          	zext.b	a1,a1
800254c8:	8cb6                	mv	s9,a3
800254ca:	40cb8bb3          	sub	s7,s7,a2
800254ce:	b329                	j	800251d8 <.L175>

800254d0 <.L182>:
800254d0:	17fd                	add	a5,a5,-1
800254d2:	03000593          	li	a1,48
800254d6:	854e                	mv	a0,s3
800254d8:	da3e                	sw	a5,52(sp)
800254da:	ca0ff0ef          	jal	8002497a <__SEGGER_RTL_putc>

800254de <.L179>:
800254de:	57d2                	lw	a5,52(sp)
800254e0:	fef048e3          	bgtz	a5,800254d0 <.L182>
800254e4:	bb21                	j	800251fc <.L183>

800254e6 <.L186>:
800254e6:	d204d9e3          	bgez	s1,80025218 <.L187>
800254ea:	4c81                	li	s9,0
800254ec:	b335                	j	80025218 <.L187>

800254ee <.L194>:
800254ee:	1cfd                	add	s9,s9,-1
800254f0:	003c9793          	sll	a5,s9,0x3
800254f4:	97da                	add	a5,a5,s6
800254f6:	4398                	lw	a4,0(a5)
800254f8:	43dc                	lw	a5,4(a5)
800254fa:	03000593          	li	a1,48

800254fe <.L190>:
800254fe:	00f46663          	bltu	s0,a5,8002550a <.L259>
80025502:	00879863          	bne	a5,s0,80025512 <.L191>
80025506:	00ebf663          	bgeu	s7,a4,80025512 <.L191>

8002550a <.L259>:
8002550a:	854e                	mv	a0,s3
8002550c:	c6eff0ef          	jal	8002497a <__SEGGER_RTL_putc>
80025510:	b32d                	j	8002523a <.L193>

80025512 <.L191>:
80025512:	40eb86b3          	sub	a3,s7,a4
80025516:	00dbb633          	sltu	a2,s7,a3
8002551a:	0585                	add	a1,a1,1
8002551c:	8c1d                	sub	s0,s0,a5
8002551e:	0ff5f593          	zext.b	a1,a1
80025522:	8bb6                	mv	s7,a3
80025524:	8c11                	sub	s0,s0,a2
80025526:	bfe1                	j	800254fe <.L190>

80025528 <.L196>:
80025528:	03000593          	li	a1,48
8002552c:	854e                	mv	a0,s3
8002552e:	14fd                	add	s1,s1,-1
80025530:	c4aff0ef          	jal	8002497a <__SEGGER_RTL_putc>
80025534:	b329                	j	8002523e <.L195>

80025536 <.L184>:
80025536:	012c1793          	sll	a5,s8,0x12
8002553a:	06500593          	li	a1,101
8002553e:	0007d463          	bgez	a5,80025546 <.L197>
80025542:	04500593          	li	a1,69

80025546 <.L197>:
80025546:	854e                	mv	a0,s3
80025548:	c32ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
8002554c:	57d2                	lw	a5,52(sp)
8002554e:	0407df63          	bgez	a5,800255ac <.L198>
80025552:	02d00593          	li	a1,45
80025556:	854e                	mv	a0,s3
80025558:	c22ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
8002555c:	57d2                	lw	a5,52(sp)
8002555e:	40f007b3          	neg	a5,a5
80025562:	da3e                	sw	a5,52(sp)

80025564 <.L199>:
80025564:	55d2                	lw	a1,52(sp)
80025566:	06300793          	li	a5,99
8002556a:	00b7df63          	bge	a5,a1,80025588 <.L200>
8002556e:	06400413          	li	s0,100
80025572:	0285c5b3          	div	a1,a1,s0
80025576:	854e                	mv	a0,s3
80025578:	03058593          	add	a1,a1,48
8002557c:	bfeff0ef          	jal	8002497a <__SEGGER_RTL_putc>
80025580:	57d2                	lw	a5,52(sp)
80025582:	0287e7b3          	rem	a5,a5,s0
80025586:	da3e                	sw	a5,52(sp)

80025588 <.L200>:
80025588:	55d2                	lw	a1,52(sp)
8002558a:	4429                	li	s0,10
8002558c:	854e                	mv	a0,s3
8002558e:	0285c5b3          	div	a1,a1,s0
80025592:	03058593          	add	a1,a1,48
80025596:	be4ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
8002559a:	55d2                	lw	a1,52(sp)
8002559c:	0285e5b3          	rem	a1,a1,s0
800255a0:	03058593          	add	a1,a1,48

800255a4 <.L360>:
800255a4:	854e                	mv	a0,s3
800255a6:	bd4ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
800255aa:	b145                	j	8002524a <.L201>

800255ac <.L198>:
800255ac:	02b00593          	li	a1,43
800255b0:	854e                	mv	a0,s3
800255b2:	bc8ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
800255b6:	b77d                	j	80025564 <.L199>

800255b8 <.L205>:
800255b8:	6d21                	lui	s10,0x8
800255ba:	892e                	mv	s2,a1
800255bc:	4c01                	li	s8,0
800255be:	01abfd33          	and	s10,s7,s10
800255c2:	470d                	li	a4,3
800255c4:	02c00813          	li	a6,44

800255c8 <.L208>:
800255c8:	012467b3          	or	a5,s0,s2
800255cc:	c7b5                	beqz	a5,80025638 <.L206>
800255ce:	000d0d63          	beqz	s10,800255e8 <.L214>
800255d2:	003c7793          	and	a5,s8,3
800255d6:	00e79963          	bne	a5,a4,800255e8 <.L214>
800255da:	030c0793          	add	a5,s8,48
800255de:	1018                	add	a4,sp,32
800255e0:	97ba                	add	a5,a5,a4
800255e2:	ff078423          	sb	a6,-24(a5)
800255e6:	0c05                	add	s8,s8,1

800255e8 <.L214>:
800255e8:	1018                	add	a4,sp,32
800255ea:	030c0793          	add	a5,s8,48
800255ee:	97ba                	add	a5,a5,a4
800255f0:	4629                	li	a2,10
800255f2:	4681                	li	a3,0
800255f4:	8522                	mv	a0,s0
800255f6:	85ca                	mv	a1,s2
800255f8:	c63e                	sw	a5,12(sp)
800255fa:	afefd0ef          	jal	800228f8 <__umoddi3>
800255fe:	47b2                	lw	a5,12(sp)
80025600:	03050513          	add	a0,a0,48
80025604:	85ca                	mv	a1,s2
80025606:	fea78423          	sb	a0,-24(a5)
8002560a:	4629                	li	a2,10
8002560c:	8522                	mv	a0,s0
8002560e:	4681                	li	a3,0
80025610:	ed1fc0ef          	jal	800224e0 <__udivdi3>
80025614:	0c05                	add	s8,s8,1
80025616:	842a                	mv	s0,a0
80025618:	892e                	mv	s2,a1
8002561a:	02c00813          	li	a6,44
8002561e:	470d                	li	a4,3
80025620:	b765                	j	800255c8 <.L208>

80025622 <.L204>:
80025622:	6709                	lui	a4,0x2
80025624:	4c01                	li	s8,0
80025626:	00ebf733          	and	a4,s7,a4
8002562a:	f2018693          	add	a3,gp,-224 # 800207c4 <__SEGGER_RTL_hex_lc>
8002562e:	f3018613          	add	a2,gp,-208 # 800207d4 <__SEGGER_RTL_hex_uc>

80025632 <.L209>:
80025632:	00b467b3          	or	a5,s0,a1
80025636:	e38d                	bnez	a5,80025658 <.L212>

80025638 <.L206>:
80025638:	418484b3          	sub	s1,s1,s8
8002563c:	0004d363          	bgez	s1,80025642 <.L216>
80025640:	4481                	li	s1,0

80025642 <.L216>:
80025642:	409b0b33          	sub	s6,s6,s1
80025646:	0ff00793          	li	a5,255
8002564a:	418b0b33          	sub	s6,s6,s8
8002564e:	0397f863          	bgeu	a5,s9,8002567e <.L217>
80025652:	1b7d                	add	s6,s6,-1

80025654 <.L218>:
80025654:	1b7d                	add	s6,s6,-1
80025656:	a035                	j	80025682 <.L219>

80025658 <.L212>:
80025658:	00f47793          	and	a5,s0,15
8002565c:	cf19                	beqz	a4,8002567a <.L210>
8002565e:	97b2                	add	a5,a5,a2

80025660 <.L361>:
80025660:	0007c783          	lbu	a5,0(a5)
80025664:	1828                	add	a0,sp,56
80025666:	9562                	add	a0,a0,s8
80025668:	00f50023          	sb	a5,0(a0)
8002566c:	8011                	srl	s0,s0,0x4
8002566e:	01c59793          	sll	a5,a1,0x1c
80025672:	0c05                	add	s8,s8,1
80025674:	8c5d                	or	s0,s0,a5
80025676:	8191                	srl	a1,a1,0x4
80025678:	bf6d                	j	80025632 <.L209>

8002567a <.L210>:
8002567a:	97b6                	add	a5,a5,a3
8002567c:	b7d5                	j	80025660 <.L361>

8002567e <.L217>:
8002567e:	fc0c9be3          	bnez	s9,80025654 <.L218>

80025682 <.L219>:
80025682:	200bf793          	and	a5,s7,512
80025686:	e799                	bnez	a5,80025694 <.L220>
80025688:	865a                	mv	a2,s6
8002568a:	85de                	mv	a1,s7
8002568c:	854e                	mv	a0,s3
8002568e:	f1cfd0ef          	jal	80022daa <__SEGGER_RTL_pre_padding>
80025692:	4b01                	li	s6,0

80025694 <.L220>:
80025694:	0ff00793          	li	a5,255
80025698:	0197fc63          	bgeu	a5,s9,800256b0 <.L221>
8002569c:	03000593          	li	a1,48
800256a0:	854e                	mv	a0,s3
800256a2:	ad8ff0ef          	jal	8002497a <__SEGGER_RTL_putc>

800256a6 <.L222>:
800256a6:	85e6                	mv	a1,s9
800256a8:	854e                	mv	a0,s3
800256aa:	ad0ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
800256ae:	a019                	j	800256b4 <.L223>

800256b0 <.L221>:
800256b0:	fe0c9be3          	bnez	s9,800256a6 <.L222>

800256b4 <.L223>:
800256b4:	865a                	mv	a2,s6
800256b6:	85de                	mv	a1,s7
800256b8:	854e                	mv	a0,s3
800256ba:	ef0fd0ef          	jal	80022daa <__SEGGER_RTL_pre_padding>
800256be:	8626                	mv	a2,s1
800256c0:	03000593          	li	a1,48
800256c4:	854e                	mv	a0,s3
800256c6:	b50ff0ef          	jal	80024a16 <__SEGGER_RTL_print_padding>

800256ca <.L224>:
800256ca:	1c7d                	add	s8,s8,-1
800256cc:	e40c4c63          	bltz	s8,80024d24 <.L371>
800256d0:	183c                	add	a5,sp,56
800256d2:	97e2                	add	a5,a5,s8
800256d4:	0007c583          	lbu	a1,0(a5)
800256d8:	854e                	mv	a0,s3
800256da:	aa0ff0ef          	jal	8002497a <__SEGGER_RTL_putc>
800256de:	b7f5                	j	800256ca <.L224>

800256e0 <.L34>:
800256e0:	07800713          	li	a4,120
800256e4:	daf76163          	bltu	a4,a5,80024c86 <.L4>

800256e8 <.L38>:
800256e8:	fa878713          	add	a4,a5,-88
800256ec:	0ff77713          	zext.b	a4,a4
800256f0:	02000693          	li	a3,32
800256f4:	d8e6e963          	bltu	a3,a4,80024c86 <.L4>
800256f8:	46d2                	lw	a3,20(sp)
800256fa:	070a                	sll	a4,a4,0x2
800256fc:	9736                	add	a4,a4,a3
800256fe:	4318                	lw	a4,0(a4)
80025700:	8702                	jr	a4

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

80025702 <__SEGGER_RTL_ascii_isctype>:
80025702:	07f00793          	li	a5,127
80025706:	02a7e063          	bltu	a5,a0,80025726 <.L3>
8002570a:	0bc18793          	add	a5,gp,188 # 80020960 <__SEGGER_RTL_ascii_ctype_map>
8002570e:	953e                	add	a0,a0,a5
80025710:	800217b7          	lui	a5,0x80021
80025714:	2a478793          	add	a5,a5,676 # 800212a4 <__SEGGER_RTL_ascii_ctype_mask>
80025718:	95be                	add	a1,a1,a5
8002571a:	00054503          	lbu	a0,0(a0)
8002571e:	0005c783          	lbu	a5,0(a1)
80025722:	8d7d                	and	a0,a0,a5
80025724:	8082                	ret

80025726 <.L3>:
80025726:	4501                	li	a0,0
80025728:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

8002572a <__SEGGER_RTL_ascii_tolower>:
8002572a:	fbf50713          	add	a4,a0,-65
8002572e:	47e5                	li	a5,25
80025730:	00e7e463          	bltu	a5,a4,80025738 <.L7>
80025734:	02050513          	add	a0,a0,32

80025738 <.L7>:
80025738:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

8002573a <__SEGGER_RTL_ascii_iswctype>:
8002573a:	07f00793          	li	a5,127
8002573e:	02a7e063          	bltu	a5,a0,8002575e <.L10>
80025742:	0bc18793          	add	a5,gp,188 # 80020960 <__SEGGER_RTL_ascii_ctype_map>
80025746:	953e                	add	a0,a0,a5
80025748:	800217b7          	lui	a5,0x80021
8002574c:	2a478793          	add	a5,a5,676 # 800212a4 <__SEGGER_RTL_ascii_ctype_mask>
80025750:	95be                	add	a1,a1,a5
80025752:	00054503          	lbu	a0,0(a0)
80025756:	0005c783          	lbu	a5,0(a1)
8002575a:	8d7d                	and	a0,a0,a5
8002575c:	8082                	ret

8002575e <.L10>:
8002575e:	4501                	li	a0,0
80025760:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

80025762 <__SEGGER_RTL_ascii_towlower>:
80025762:	fbf50713          	add	a4,a0,-65
80025766:	47e5                	li	a5,25
80025768:	00e7e463          	bltu	a5,a4,80025770 <.L14>
8002576c:	02050513          	add	a0,a0,32

80025770 <.L14>:
80025770:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

80025772 <__SEGGER_RTL_ascii_wctomb>:
80025772:	07f00793          	li	a5,127
80025776:	00b7e663          	bltu	a5,a1,80025782 <.L66>
8002577a:	00b50023          	sb	a1,0(a0)
8002577e:	4505                	li	a0,1
80025780:	8082                	ret

80025782 <.L66>:
80025782:	5579                	li	a0,-2
80025784:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

80025786 <__SEGGER_RTL_current_locale>:
80025786:	83822503          	lw	a0,-1992(tp) # fffff838 <__APB_SRAM_segment_end__+0xbf0d838>
8002578a:	e119                	bnez	a0,80025790 <.L155>
8002578c:	80020513          	add	a0,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>

80025790 <.L155>:
80025790:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

80025b30 <__SEGGER_init_zero>:
80025b30:	4008                	lw	a0,0(s0)
80025b32:	404c                	lw	a1,4(s0)
80025b34:	0421                	add	s0,s0,8
80025b36:	c591                	beqz	a1,80025b42 <.L__SEGGER_init_zero_Done>

80025b38 <.L__SEGGER_init_zero_Loop>:
80025b38:	00050023          	sb	zero,0(a0)
80025b3c:	0505                	add	a0,a0,1
80025b3e:	15fd                	add	a1,a1,-1
80025b40:	fde5                	bnez	a1,80025b38 <.L__SEGGER_init_zero_Loop>

80025b42 <.L__SEGGER_init_zero_Done>:
80025b42:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

80025b44 <__SEGGER_init_copy>:
80025b44:	4008                	lw	a0,0(s0)
80025b46:	404c                	lw	a1,4(s0)
80025b48:	4410                	lw	a2,8(s0)
80025b4a:	0431                	add	s0,s0,12
80025b4c:	ca09                	beqz	a2,80025b5e <.L__SEGGER_init_copy_Done>

80025b4e <.L__SEGGER_init_copy_Loop>:
80025b4e:	00058683          	lb	a3,0(a1)
80025b52:	00d50023          	sb	a3,0(a0)
80025b56:	0505                	add	a0,a0,1
80025b58:	0585                	add	a1,a1,1
80025b5a:	167d                	add	a2,a2,-1
80025b5c:	fa6d                	bnez	a2,80025b4e <.L__SEGGER_init_copy_Loop>

80025b5e <.L__SEGGER_init_copy_Done>:
80025b5e:	8082                	ret
