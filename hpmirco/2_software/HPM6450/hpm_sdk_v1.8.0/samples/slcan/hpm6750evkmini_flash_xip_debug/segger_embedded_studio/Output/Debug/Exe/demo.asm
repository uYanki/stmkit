
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80003000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80003000:	011051b7          	lui	gp,0x1105
        addi    gp, gp, %lo(__global_pointer$)
80003004:	87818193          	add	gp,gp,-1928 # 1104878 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	80004237          	lui	tp,0x80004
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	20020213          	add	tp,tp,512 # 80004200 <__thread_pointer$>
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
80003034:	194050ef          	jal	800081c8 <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003038:	15a050ef          	jal	80008192 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
8000303c:	23a090ef          	jal	8000c276 <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
80003040:	7a3080ef          	jal	8000bfe2 <_init>

80003044 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003044:	8000e437          	lui	s0,0x8000e
80003048:	e7840413          	add	s0,s0,-392 # 8000de78 <.L155+0x2>

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
80003054:	6c7080ef          	jal	8000bf1a <_clean_up>

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
80003068:	75f080ef          	jal	8000bfc6 <reset_handler>
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
80003074:	753080ef          	jal	8000bfc6 <reset_handler>
        tail    exit
80003078:	bfdd                	j	8000306e <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>:
8000307a:	8082                	ret

Disassembly of section .text.usb_get_port_ccs:

80003dca <usb_get_port_ccs>:
 *
 * @param[in] ptr A USB peripheral base address
 * @retval The USB controller reset status
 */
static inline bool usb_get_port_ccs(USB_Type *ptr)
{
80003dca:	1141                	add	sp,sp,-16
80003dcc:	c62a                	sw	a0,12(sp)
    return USB_PORTSC1_CCS_GET(ptr->PORTSC1);
80003dce:	47b2                	lw	a5,12(sp)
80003dd0:	1847a783          	lw	a5,388(a5)
80003dd4:	8b85                	and	a5,a5,1
80003dd6:	00f037b3          	snez	a5,a5
80003dda:	0ff7f793          	zext.b	a5,a5
}
80003dde:	853e                	mv	a0,a5
80003de0:	0141                	add	sp,sp,16
80003de2:	8082                	ret

Disassembly of section .text.usb_dcd_get_device_addr:

80003df6 <usb_dcd_get_device_addr>:
 *
 * @param[in] ptr A USB peripheral base address
 * @retval The endpoint address
 */
static inline uint8_t usb_dcd_get_device_addr(USB_Type *ptr)
{
80003df6:	1141                	add	sp,sp,-16
80003df8:	c62a                	sw	a0,12(sp)
    return USB_DEVICEADDR_USBADR_GET(ptr->DEVICEADDR);
80003dfa:	47b2                	lw	a5,12(sp)
80003dfc:	1547a783          	lw	a5,340(a5)
80003e00:	83e5                	srl	a5,a5,0x19
80003e02:	0ff7f793          	zext.b	a5,a5
80003e06:	07f7f793          	and	a5,a5,127
80003e0a:	0ff7f793          	zext.b	a5,a5
}
80003e0e:	853e                	mv	a0,a5
80003e10:	0141                	add	sp,sp,16
80003e12:	8082                	ret

Disassembly of section .text.usb_qtd_init:

80003e1e <usb_qtd_init>:
#include "hpm_misc.h"
#include "hpm_common.h"

/* Initialize qtd */
static void usb_qtd_init(dcd_qtd_t *p_qtd, void *data_ptr, uint16_t total_bytes)
{
80003e1e:	7179                	add	sp,sp,-48
80003e20:	d606                	sw	ra,44(sp)
80003e22:	c62a                	sw	a0,12(sp)
80003e24:	c42e                	sw	a1,8(sp)
80003e26:	87b2                	mv	a5,a2
80003e28:	00f11323          	sh	a5,6(sp)
    memset(p_qtd, 0, sizeof(dcd_qtd_t));
80003e2c:	02000613          	li	a2,32
80003e30:	4581                	li	a1,0
80003e32:	4532                	lw	a0,12(sp)
80003e34:	05e090ef          	jal	8000ce92 <memset>

    p_qtd->next        = USB_SOC_DCD_QTD_NEXT_INVALID;
80003e38:	47b2                	lw	a5,12(sp)
80003e3a:	4705                	li	a4,1
80003e3c:	c398                	sw	a4,0(a5)
    p_qtd->active      = 1;
80003e3e:	47b2                	lw	a5,12(sp)
80003e40:	43d8                	lw	a4,4(a5)
80003e42:	08076713          	or	a4,a4,128
80003e46:	c3d8                	sw	a4,4(a5)
    p_qtd->total_bytes = p_qtd->expected_bytes = total_bytes;
80003e48:	00615783          	lhu	a5,6(sp)
80003e4c:	4732                	lw	a4,12(sp)
80003e4e:	00f71e23          	sh	a5,28(a4)
80003e52:	873e                	mv	a4,a5
80003e54:	67a1                	lui	a5,0x8
80003e56:	17fd                	add	a5,a5,-1 # 7fff <__NONCACHEABLE_RAM_segment_used_size__+0x2b07>
80003e58:	8ff9                	and	a5,a5,a4
80003e5a:	01079693          	sll	a3,a5,0x10
80003e5e:	82c1                	srl	a3,a3,0x10
80003e60:	47b2                	lw	a5,12(sp)
80003e62:	6721                	lui	a4,0x8
80003e64:	177d                	add	a4,a4,-1 # 7fff <__NONCACHEABLE_RAM_segment_used_size__+0x2b07>
80003e66:	8f75                	and	a4,a4,a3
80003e68:	0742                	sll	a4,a4,0x10
80003e6a:	43d0                	lw	a2,4(a5)
80003e6c:	800106b7          	lui	a3,0x80010
80003e70:	16fd                	add	a3,a3,-1 # 8000ffff <__XPI0_segment_used_end__+0x3c7>
80003e72:	8ef1                	and	a3,a3,a2
80003e74:	8f55                	or	a4,a4,a3
80003e76:	c3d8                	sw	a4,4(a5)

    if (data_ptr != NULL) {
80003e78:	47a2                	lw	a5,8(sp)
80003e7a:	cbb9                	beqz	a5,80003ed0 <.L35>
        p_qtd->buffer[0]   = (uint32_t)data_ptr;
80003e7c:	4722                	lw	a4,8(sp)
80003e7e:	47b2                	lw	a5,12(sp)
80003e80:	c798                	sw	a4,8(a5)

80003e82 <.LBB2>:
        for (uint8_t i = 1; i < USB_SOC_DCD_QHD_BUFFER_COUNT; i++) {
80003e82:	4785                	li	a5,1
80003e84:	00f10fa3          	sb	a5,31(sp)
80003e88:	a83d                	j	80003ec6 <.L33>

80003e8a <.L34>:
            p_qtd->buffer[i] |= ((p_qtd->buffer[i-1]) & 0xFFFFF000UL) + 4096U;
80003e8a:	01f14783          	lbu	a5,31(sp)
80003e8e:	17fd                	add	a5,a5,-1
80003e90:	4732                	lw	a4,12(sp)
80003e92:	078a                	sll	a5,a5,0x2
80003e94:	97ba                	add	a5,a5,a4
80003e96:	4798                	lw	a4,8(a5)
80003e98:	77fd                	lui	a5,0xfffff
80003e9a:	8f7d                	and	a4,a4,a5
80003e9c:	6785                	lui	a5,0x1
80003e9e:	00f706b3          	add	a3,a4,a5
80003ea2:	01f14783          	lbu	a5,31(sp)
80003ea6:	4732                	lw	a4,12(sp)
80003ea8:	078a                	sll	a5,a5,0x2
80003eaa:	97ba                	add	a5,a5,a4
80003eac:	4798                	lw	a4,8(a5)
80003eae:	01f14783          	lbu	a5,31(sp)
80003eb2:	8f55                	or	a4,a4,a3
80003eb4:	46b2                	lw	a3,12(sp)
80003eb6:	078a                	sll	a5,a5,0x2
80003eb8:	97b6                	add	a5,a5,a3
80003eba:	c798                	sw	a4,8(a5)
        for (uint8_t i = 1; i < USB_SOC_DCD_QHD_BUFFER_COUNT; i++) {
80003ebc:	01f14783          	lbu	a5,31(sp)
80003ec0:	0785                	add	a5,a5,1 # 1001 <__fw_size__+0x1>
80003ec2:	00f10fa3          	sb	a5,31(sp)

80003ec6 <.L33>:
80003ec6:	01f14703          	lbu	a4,31(sp)
80003eca:	4791                	li	a5,4
80003ecc:	fae7ffe3          	bgeu	a5,a4,80003e8a <.L34>

80003ed0 <.L35>:
        }
    }
}
80003ed0:	0001                	nop
80003ed2:	50b2                	lw	ra,44(sp)
80003ed4:	6145                	add	sp,sp,48
80003ed6:	8082                	ret

Disassembly of section .text.usb_device_qtd_get:

80003eda <usb_device_qtd_get>:
{
    return &handle->dcd_data->qhd[ep_idx];
}

dcd_qtd_t *usb_device_qtd_get(usb_device_handle_t *handle, uint8_t ep_idx)
{
80003eda:	1141                	add	sp,sp,-16
80003edc:	c62a                	sw	a0,12(sp)
80003ede:	87ae                	mv	a5,a1
80003ee0:	00f105a3          	sb	a5,11(sp)
    return &handle->dcd_data->qtd[ep_idx * USB_SOC_DCD_QTD_COUNT_EACH_ENDPOINT];
80003ee4:	47b2                	lw	a5,12(sp)
80003ee6:	43d8                	lw	a4,4(a5)
80003ee8:	00b14783          	lbu	a5,11(sp)
80003eec:	078e                	sll	a5,a5,0x3
80003eee:	02078793          	add	a5,a5,32
80003ef2:	0796                	sll	a5,a5,0x5
80003ef4:	97ba                	add	a5,a5,a4
}
80003ef6:	853e                	mv	a0,a5
80003ef8:	0141                	add	sp,sp,16
80003efa:	8082                	ret

Disassembly of section .text.usb_device_bus_reset:

80003f1a <usb_device_bus_reset>:

void usb_device_bus_reset(usb_device_handle_t *handle, uint16_t ep0_max_packet_size)
{
80003f1a:	7179                	add	sp,sp,-48
80003f1c:	d606                	sw	ra,44(sp)
80003f1e:	c62a                	sw	a0,12(sp)
80003f20:	87ae                	mv	a5,a1
80003f22:	00f11523          	sh	a5,10(sp)
    dcd_data_t *dcd_data = handle->dcd_data;
80003f26:	47b2                	lw	a5,12(sp)
80003f28:	43dc                	lw	a5,4(a5)
80003f2a:	ce3e                	sw	a5,28(sp)

    usb_dcd_bus_reset(handle->regs, ep0_max_packet_size);
80003f2c:	47b2                	lw	a5,12(sp)
80003f2e:	439c                	lw	a5,0(a5)
80003f30:	00a15703          	lhu	a4,10(sp)
80003f34:	85ba                	mv	a1,a4
80003f36:	853e                	mv	a0,a5
80003f38:	029060ef          	jal	8000a760 <usb_dcd_bus_reset>

     /* Queue Head & Queue TD */
    memset(dcd_data, 0, sizeof(dcd_data_t));
80003f3c:	6785                	lui	a5,0x1
80003f3e:	40078613          	add	a2,a5,1024 # 1400 <.L20+0xe>
80003f42:	4581                	li	a1,0
80003f44:	4572                	lw	a0,28(sp)
80003f46:	74d080ef          	jal	8000ce92 <memset>

    /* Set up Control Endpoints (0 OUT, 1 IN) */
    dcd_data->qhd[0].zero_length_termination = dcd_data->qhd[1].zero_length_termination = 1;
80003f4a:	4705                	li	a4,1
80003f4c:	47f2                	lw	a5,28(sp)
80003f4e:	00177693          	and	a3,a4,1
80003f52:	06f6                	sll	a3,a3,0x1d
80003f54:	43ac                	lw	a1,64(a5)
80003f56:	e0000637          	lui	a2,0xe0000
80003f5a:	167d                	add	a2,a2,-1 # dfffffff <__XPI0_segment_end__+0x5f7fffff>
80003f5c:	8e6d                	and	a2,a2,a1
80003f5e:	8ed1                	or	a3,a3,a2
80003f60:	c3b4                	sw	a3,64(a5)
80003f62:	47f2                	lw	a5,28(sp)
80003f64:	8b05                	and	a4,a4,1
80003f66:	0776                	sll	a4,a4,0x1d
80003f68:	4390                	lw	a2,0(a5)
80003f6a:	e00006b7          	lui	a3,0xe0000
80003f6e:	16fd                	add	a3,a3,-1 # dfffffff <__XPI0_segment_end__+0x5f7fffff>
80003f70:	8ef1                	and	a3,a3,a2
80003f72:	8f55                	or	a4,a4,a3
80003f74:	c398                	sw	a4,0(a5)
    dcd_data->qhd[0].max_packet_size         = dcd_data->qhd[1].max_packet_size         = ep0_max_packet_size;
80003f76:	00a15783          	lhu	a5,10(sp)
80003f7a:	7ff7f793          	and	a5,a5,2047
80003f7e:	01079713          	sll	a4,a5,0x10
80003f82:	8341                	srl	a4,a4,0x10
80003f84:	47f2                	lw	a5,28(sp)
80003f86:	7ff77693          	and	a3,a4,2047
80003f8a:	06c2                	sll	a3,a3,0x10
80003f8c:	43ac                	lw	a1,64(a5)
80003f8e:	f8010637          	lui	a2,0xf8010
80003f92:	167d                	add	a2,a2,-1 # f800ffff <__APB_SRAM_segment_end__+0x3f1dfff>
80003f94:	8e6d                	and	a2,a2,a1
80003f96:	8ed1                	or	a3,a3,a2
80003f98:	c3b4                	sw	a3,64(a5)
80003f9a:	47f2                	lw	a5,28(sp)
80003f9c:	7ff77713          	and	a4,a4,2047
80003fa0:	0742                	sll	a4,a4,0x10
80003fa2:	4390                	lw	a2,0(a5)
80003fa4:	f80106b7          	lui	a3,0xf8010
80003fa8:	16fd                	add	a3,a3,-1 # f800ffff <__APB_SRAM_segment_end__+0x3f1dfff>
80003faa:	8ef1                	and	a3,a3,a2
80003fac:	8f55                	or	a4,a4,a3
80003fae:	c398                	sw	a4,0(a5)
    dcd_data->qhd[0].qtd_overlay.next        = dcd_data->qhd[1].qtd_overlay.next        = USB_SOC_DCD_QTD_NEXT_INVALID;
80003fb0:	4785                	li	a5,1
80003fb2:	4772                	lw	a4,28(sp)
80003fb4:	c73c                	sw	a5,72(a4)
80003fb6:	4772                	lw	a4,28(sp)
80003fb8:	c71c                	sw	a5,8(a4)

    /* OUT only */
    dcd_data->qhd[0].int_on_setup = 1;
80003fba:	47f2                	lw	a5,28(sp)
80003fbc:	4394                	lw	a3,0(a5)
80003fbe:	6721                	lui	a4,0x8
80003fc0:	8f55                	or	a4,a4,a3
80003fc2:	c398                	sw	a4,0(a5)
}
80003fc4:	0001                	nop
80003fc6:	50b2                	lw	ra,44(sp)
80003fc8:	6145                	add	sp,sp,48
80003fca:	8082                	ret

Disassembly of section .text.usb_device_status_flags:

80003fd6 <usb_device_status_flags>:

    memset(handle->dcd_data, 0, sizeof(dcd_data_t));
}

uint32_t usb_device_status_flags(usb_device_handle_t *handle)
{
80003fd6:	1101                	add	sp,sp,-32
80003fd8:	ce06                	sw	ra,28(sp)
80003fda:	c62a                	sw	a0,12(sp)
    return usb_get_status_flags(handle->regs);
80003fdc:	47b2                	lw	a5,12(sp)
80003fde:	439c                	lw	a5,0(a5)
80003fe0:	853e                	mv	a0,a5
80003fe2:	68c050ef          	jal	8000966e <usb_get_status_flags>
80003fe6:	87aa                	mv	a5,a0
}
80003fe8:	853e                	mv	a0,a5
80003fea:	40f2                	lw	ra,28(sp)
80003fec:	6105                	add	sp,sp,32
80003fee:	8082                	ret

Disassembly of section .text.usb_device_interrupts:

80003ff2 <usb_device_interrupts>:
{
    usb_clear_status_flags(handle->regs, mask);
}

uint32_t usb_device_interrupts(usb_device_handle_t *handle)
{
80003ff2:	1101                	add	sp,sp,-32
80003ff4:	ce06                	sw	ra,28(sp)
80003ff6:	c62a                	sw	a0,12(sp)
    return usb_get_interrupts(handle->regs);
80003ff8:	47b2                	lw	a5,12(sp)
80003ffa:	439c                	lw	a5,0(a5)
80003ffc:	853e                	mv	a0,a5
80003ffe:	644050ef          	jal	80009642 <usb_get_interrupts>
80004002:	87aa                	mv	a5,a0
}
80004004:	853e                	mv	a0,a5
80004006:	40f2                	lw	ra,28(sp)
80004008:	6105                	add	sp,sp,32
8000400a:	8082                	ret

Disassembly of section .text.usb_device_get_suspend_status:

80004046 <usb_device_get_suspend_status>:
{
    return usb_get_port_speed(handle->regs);
}

uint8_t usb_device_get_suspend_status(usb_device_handle_t *handle)
{
80004046:	1101                	add	sp,sp,-32
80004048:	ce06                	sw	ra,28(sp)
8000404a:	c62a                	sw	a0,12(sp)
    return usb_get_suspend_status(handle->regs);
8000404c:	47b2                	lw	a5,12(sp)
8000404e:	439c                	lw	a5,0(a5)
80004050:	853e                	mv	a0,a5
80004052:	640050ef          	jal	80009692 <usb_get_suspend_status>
80004056:	87aa                	mv	a5,a0
}
80004058:	853e                	mv	a0,a5
8000405a:	40f2                	lw	ra,28(sp)
8000405c:	6105                	add	sp,sp,32
8000405e:	8082                	ret

Disassembly of section .text.usb_device_get_address:

800040be <usb_device_get_address>:

    usb_dcd_set_address(handle->regs, dev_addr);
}

uint8_t usb_device_get_address(usb_device_handle_t *handle)
{
800040be:	1101                	add	sp,sp,-32
800040c0:	ce06                	sw	ra,28(sp)
800040c2:	c62a                	sw	a0,12(sp)
    return usb_dcd_get_device_addr(handle->regs);
800040c4:	47b2                	lw	a5,12(sp)
800040c6:	439c                	lw	a5,0(a5)
800040c8:	853e                	mv	a0,a5
800040ca:	3335                	jal	80003df6 <usb_dcd_get_device_addr>
800040cc:	87aa                	mv	a5,a0
}
800040ce:	853e                	mv	a0,a5
800040d0:	40f2                	lw	ra,28(sp)
800040d2:	6105                	add	sp,sp,32
800040d4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

800040d6 <__SEGGER_RTL_SIGNAL_SIG_IGN>:
800040d6:	8082                	ret

Disassembly of section .text.usb_device_get_port_ccs:

80004422 <usb_device_get_port_ccs>:
{
    usb_dcd_disconnect(handle->regs);
}

bool usb_device_get_port_ccs(usb_device_handle_t *handle)
{
80004422:	1101                	add	sp,sp,-32
80004424:	ce06                	sw	ra,28(sp)
80004426:	c62a                	sw	a0,12(sp)
    return usb_get_port_ccs(handle->regs);
80004428:	47b2                	lw	a5,12(sp)
8000442a:	439c                	lw	a5,0(a5)
8000442c:	853e                	mv	a0,a5
8000442e:	3a71                	jal	80003dca <usb_get_port_ccs>
80004430:	87aa                	mv	a5,a0
}
80004432:	853e                	mv	a0,a5
80004434:	40f2                	lw	ra,28(sp)
80004436:	6105                	add	sp,sp,32
80004438:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

8000443a <__SEGGER_RTL_SIGNAL_SIG_ERR>:
8000443a:	8082                	ret

Disassembly of section .text.usb_device_get_edpt_complete_status:

8000443e <usb_device_get_edpt_complete_status>:
{
    return usb_get_port_reset_status(handle->regs);
}

uint32_t usb_device_get_edpt_complete_status(usb_device_handle_t *handle)
{
8000443e:	1101                	add	sp,sp,-32
80004440:	ce06                	sw	ra,28(sp)
80004442:	c62a                	sw	a0,12(sp)
    return usb_dcd_get_edpt_complete_status(handle->regs);
80004444:	47b2                	lw	a5,12(sp)
80004446:	439c                	lw	a5,0(a5)
80004448:	853e                	mv	a0,a5
8000444a:	2a0050ef          	jal	800096ea <usb_dcd_get_edpt_complete_status>
8000444e:	87aa                	mv	a5,a0
}
80004450:	853e                	mv	a0,a5
80004452:	40f2                	lw	ra,28(sp)
80004454:	6105                	add	sp,sp,32
80004456:	8082                	ret

Disassembly of section .text.usb_device_get_setup_status:

8000448a <usb_device_get_setup_status>:
{
    usb_dcd_clear_edpt_complete_status(handle->regs, mask);
}

uint32_t usb_device_get_setup_status(usb_device_handle_t *handle)
{
8000448a:	1101                	add	sp,sp,-32
8000448c:	ce06                	sw	ra,28(sp)
8000448e:	c62a                	sw	a0,12(sp)
    return usb_dcd_get_edpt_setup_status(handle->regs);
80004490:	47b2                	lw	a5,12(sp)
80004492:	439c                	lw	a5,0(a5)
80004494:	853e                	mv	a0,a5
80004496:	218050ef          	jal	800096ae <usb_dcd_get_edpt_setup_status>
8000449a:	87aa                	mv	a5,a0
}
8000449c:	853e                	mv	a0,a5
8000449e:	40f2                	lw	ra,28(sp)
800044a0:	6105                	add	sp,sp,32
800044a2:	8082                	ret

Disassembly of section .text.usb_device_edpt_open:

800044c2 <usb_device_edpt_open>:
/*---------------------------------------------------------------------
 * Endpoint API
 *---------------------------------------------------------------------
 */
bool usb_device_edpt_open(usb_device_handle_t *handle, usb_endpoint_config_t *config)
{
800044c2:	7179                	add	sp,sp,-48
800044c4:	d606                	sw	ra,44(sp)
800044c6:	c62a                	sw	a0,12(sp)
800044c8:	c42e                	sw	a1,8(sp)
    uint8_t const epnum  = config->ep_addr & 0x0f;
800044ca:	47a2                	lw	a5,8(sp)
800044cc:	0017c783          	lbu	a5,1(a5)
800044d0:	8bbd                	and	a5,a5,15
800044d2:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir = (config->ep_addr & 0x80) >> 7;
800044d6:	47a2                	lw	a5,8(sp)
800044d8:	0017c783          	lbu	a5,1(a5)
800044dc:	839d                	srl	a5,a5,0x7
800044de:	00f10f23          	sb	a5,30(sp)
    uint8_t const ep_idx = 2 * epnum + dir;
800044e2:	01f14783          	lbu	a5,31(sp)
800044e6:	0786                	sll	a5,a5,0x1
800044e8:	0ff7f793          	zext.b	a5,a5
800044ec:	01e14703          	lbu	a4,30(sp)
800044f0:	97ba                	add	a5,a5,a4
800044f2:	00f10ea3          	sb	a5,29(sp)

    dcd_qhd_t *p_qhd;

    /* Must not exceed max endpoint number */
    if (epnum >= USB_SOC_DCD_MAX_ENDPOINT_COUNT) {
800044f6:	01f14703          	lbu	a4,31(sp)
800044fa:	479d                	li	a5,7
800044fc:	00e7f463          	bgeu	a5,a4,80004504 <.L73>
        return false;
80004500:	4781                	li	a5,0
80004502:	a04d                	j	800045a4 <.L74>

80004504 <.L73>:
    }

    /* Prepare Queue Head */
    p_qhd = &handle->dcd_data->qhd[ep_idx];
80004504:	47b2                	lw	a5,12(sp)
80004506:	43d8                	lw	a4,4(a5)
80004508:	01d14783          	lbu	a5,29(sp)
8000450c:	079a                	sll	a5,a5,0x6
8000450e:	97ba                	add	a5,a5,a4
80004510:	cc3e                	sw	a5,24(sp)
    memset(p_qhd, 0, sizeof(dcd_qhd_t));
80004512:	04000613          	li	a2,64
80004516:	4581                	li	a1,0
80004518:	4562                	lw	a0,24(sp)
8000451a:	179080ef          	jal	8000ce92 <memset>

    p_qhd->zero_length_termination = 1;
8000451e:	47e2                	lw	a5,24(sp)
80004520:	4394                	lw	a3,0(a5)
80004522:	20000737          	lui	a4,0x20000
80004526:	8f55                	or	a4,a4,a3
80004528:	c398                	sw	a4,0(a5)
    p_qhd->max_packet_size         = config->max_packet_size & 0x7FFu;
8000452a:	47a2                	lw	a5,8(sp)
8000452c:	0027d783          	lhu	a5,2(a5)
80004530:	7ff7f793          	and	a5,a5,2047
80004534:	01079713          	sll	a4,a5,0x10
80004538:	8341                	srl	a4,a4,0x10
8000453a:	47e2                	lw	a5,24(sp)
8000453c:	7ff77713          	and	a4,a4,2047
80004540:	0742                	sll	a4,a4,0x10
80004542:	4390                	lw	a2,0(a5)
80004544:	f80106b7          	lui	a3,0xf8010
80004548:	16fd                	add	a3,a3,-1 # f800ffff <__APB_SRAM_segment_end__+0x3f1dfff>
8000454a:	8ef1                	and	a3,a3,a2
8000454c:	8f55                	or	a4,a4,a3
8000454e:	c398                	sw	a4,0(a5)
    p_qhd->qtd_overlay.next        = USB_SOC_DCD_QTD_NEXT_INVALID;
80004550:	47e2                	lw	a5,24(sp)
80004552:	4705                	li	a4,1
80004554:	c798                	sw	a4,8(a5)
    if (config->xfer == usb_xfer_isochronous) {
80004556:	47a2                	lw	a5,8(sp)
80004558:	0007c703          	lbu	a4,0(a5)
8000455c:	4785                	li	a5,1
8000455e:	02f71c63          	bne	a4,a5,80004596 <.L75>
        p_qhd->iso_mult = ((config->max_packet_size >> 11u) & 0x3u) + 1u;
80004562:	47a2                	lw	a5,8(sp)
80004564:	0027d783          	lhu	a5,2(a5)
80004568:	83ad                	srl	a5,a5,0xb
8000456a:	07c2                	sll	a5,a5,0x10
8000456c:	83c1                	srl	a5,a5,0x10
8000456e:	0ff7f793          	zext.b	a5,a5
80004572:	8b8d                	and	a5,a5,3
80004574:	0ff7f793          	zext.b	a5,a5
80004578:	0785                	add	a5,a5,1
8000457a:	0ff7f793          	zext.b	a5,a5
8000457e:	8b8d                	and	a5,a5,3
80004580:	0ff7f713          	zext.b	a4,a5
80004584:	47e2                	lw	a5,24(sp)
80004586:	077a                	sll	a4,a4,0x1e
80004588:	4390                	lw	a2,0(a5)
8000458a:	400006b7          	lui	a3,0x40000
8000458e:	16fd                	add	a3,a3,-1 # 3fffffff <__SHARE_RAM_segment_end__+0x3ee7ffff>
80004590:	8ef1                	and	a3,a3,a2
80004592:	8f55                	or	a4,a4,a3
80004594:	c398                	sw	a4,0(a5)

80004596 <.L75>:
    }

    usb_dcd_edpt_open(handle->regs, config);
80004596:	47b2                	lw	a5,12(sp)
80004598:	439c                	lw	a5,0(a5)
8000459a:	45a2                	lw	a1,8(sp)
8000459c:	853e                	mv	a0,a5
8000459e:	3d6010ef          	jal	80005974 <usb_dcd_edpt_open>

    return true;
800045a2:	4785                	li	a5,1

800045a4 <.L74>:
}
800045a4:	853e                	mv	a0,a5
800045a6:	50b2                	lw	ra,44(sp)
800045a8:	6145                	add	sp,sp,48
800045aa:	8082                	ret

Disassembly of section .text.usb_device_edpt_xfer:

800045ba <usb_device_edpt_xfer>:

bool usb_device_edpt_xfer(usb_device_handle_t *handle, uint8_t ep_addr, uint8_t *buffer, uint32_t total_bytes)
{
800045ba:	7139                	add	sp,sp,-64
800045bc:	de06                	sw	ra,60(sp)
800045be:	c62a                	sw	a0,12(sp)
800045c0:	87ae                	mv	a5,a1
800045c2:	c232                	sw	a2,4(sp)
800045c4:	c036                	sw	a3,0(sp)
800045c6:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
800045ca:	00b14783          	lbu	a5,11(sp)
800045ce:	8bbd                	and	a5,a5,15
800045d0:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
800045d4:	00b14783          	lbu	a5,11(sp)
800045d8:	839d                	srl	a5,a5,0x7
800045da:	00f10f23          	sb	a5,30(sp)
    uint8_t const ep_idx = 2 * epnum + dir;
800045de:	01f14783          	lbu	a5,31(sp)
800045e2:	0786                	sll	a5,a5,0x1
800045e4:	0ff7f793          	zext.b	a5,a5
800045e8:	01e14703          	lbu	a4,30(sp)
800045ec:	97ba                	add	a5,a5,a4
800045ee:	00f10ea3          	sb	a5,29(sp)
    uint8_t qtd_num;
    uint8_t i;
    uint32_t xfer_len;
    dcd_qhd_t *p_qhd;
    dcd_qtd_t *p_qtd;
    dcd_qtd_t *first_p_qtd = NULL;
800045f2:	d202                	sw	zero,36(sp)
    dcd_qtd_t *prev_p_qtd = NULL;
800045f4:	d002                	sw	zero,32(sp)

    if (epnum == 0) {
800045f6:	01f14783          	lbu	a5,31(sp)
800045fa:	eb91                	bnez	a5,8000460e <.L77>
        /* follows UM Setup packet handling using setup lockout mechanism
         * wait until ENDPTSETUPSTAT before priming data/status in response TODO add time out
         */
        while (usb_dcd_get_edpt_setup_status(handle->regs) & HPM_BITSMASK(1, 0)) {
800045fc:	0001                	nop

800045fe <.L78>:
800045fe:	47b2                	lw	a5,12(sp)
80004600:	439c                	lw	a5,0(a5)
80004602:	853e                	mv	a0,a5
80004604:	0aa050ef          	jal	800096ae <usb_dcd_get_edpt_setup_status>
80004608:	87aa                	mv	a5,a0
8000460a:	8b85                	and	a5,a5,1
8000460c:	fbed                	bnez	a5,800045fe <.L78>

8000460e <.L77>:
        }
    }

    qtd_num = (total_bytes + 0x3fff) / 0x4000;
8000460e:	4702                	lw	a4,0(sp)
80004610:	6791                	lui	a5,0x4
80004612:	17fd                	add	a5,a5,-1 # 3fff <__ILM_segment_used_end__+0x13a9>
80004614:	97ba                	add	a5,a5,a4
80004616:	83b9                	srl	a5,a5,0xe
80004618:	00f10e23          	sb	a5,28(sp)
    if (qtd_num > USB_SOC_DCD_QTD_COUNT_EACH_ENDPOINT) {
8000461c:	01c14703          	lbu	a4,28(sp)
80004620:	47a1                	li	a5,8
80004622:	00e7f463          	bgeu	a5,a4,8000462a <.L79>
        return false;
80004626:	4781                	li	a5,0
80004628:	a0e1                	j	800046f0 <.L80>

8000462a <.L79>:
    }

    if (buffer != NULL) {
8000462a:	4792                	lw	a5,4(sp)
8000462c:	cb81                	beqz	a5,8000463c <.L81>
        buffer = (uint8_t *)core_local_mem_to_sys_address(0, (uint32_t)buffer);
8000462e:	4792                	lw	a5,4(sp)
80004630:	85be                	mv	a1,a5
80004632:	4501                	li	a0,0
80004634:	7af040ef          	jal	800095e2 <core_local_mem_to_sys_address>
80004638:	87aa                	mv	a5,a0
8000463a:	c23e                	sw	a5,4(sp)

8000463c <.L81>:
    }
    p_qhd = &handle->dcd_data->qhd[ep_idx];
8000463c:	47b2                	lw	a5,12(sp)
8000463e:	43d8                	lw	a4,4(a5)
80004640:	01d14783          	lbu	a5,29(sp)
80004644:	079a                	sll	a5,a5,0x6
80004646:	97ba                	add	a5,a5,a4
80004648:	cc3e                	sw	a5,24(sp)
    i = 0;
8000464a:	020107a3          	sb	zero,47(sp)

8000464e <.L87>:
    do {
        p_qtd = &handle->dcd_data->qtd[ep_idx * USB_SOC_DCD_QTD_COUNT_EACH_ENDPOINT + i];
8000464e:	47b2                	lw	a5,12(sp)
80004650:	43d8                	lw	a4,4(a5)
80004652:	01d14783          	lbu	a5,29(sp)
80004656:	00379693          	sll	a3,a5,0x3
8000465a:	02f14783          	lbu	a5,47(sp)
8000465e:	97b6                	add	a5,a5,a3
80004660:	02078793          	add	a5,a5,32
80004664:	0796                	sll	a5,a5,0x5
80004666:	97ba                	add	a5,a5,a4
80004668:	ca3e                	sw	a5,20(sp)
        i++;
8000466a:	02f14783          	lbu	a5,47(sp)
8000466e:	0785                	add	a5,a5,1
80004670:	02f107a3          	sb	a5,47(sp)

        if (total_bytes > 0x4000) {
80004674:	4702                	lw	a4,0(sp)
80004676:	6791                	lui	a5,0x4
80004678:	00e7f963          	bgeu	a5,a4,8000468a <.L82>
            xfer_len = 0x4000;
8000467c:	6791                	lui	a5,0x4
8000467e:	d43e                	sw	a5,40(sp)
            total_bytes -= 0x4000;
80004680:	4702                	lw	a4,0(sp)
80004682:	77f1                	lui	a5,0xffffc
80004684:	97ba                	add	a5,a5,a4
80004686:	c03e                	sw	a5,0(sp)
80004688:	a021                	j	80004690 <.L83>

8000468a <.L82>:
        } else {
            xfer_len = total_bytes;
8000468a:	4782                	lw	a5,0(sp)
8000468c:	d43e                	sw	a5,40(sp)
            total_bytes = 0;
8000468e:	c002                	sw	zero,0(sp)

80004690 <.L83>:
        }

        usb_qtd_init(p_qtd, (void *)buffer, xfer_len);
80004690:	57a2                	lw	a5,40(sp)
80004692:	07c2                	sll	a5,a5,0x10
80004694:	83c1                	srl	a5,a5,0x10
80004696:	863e                	mv	a2,a5
80004698:	4592                	lw	a1,4(sp)
8000469a:	4552                	lw	a0,20(sp)
8000469c:	f82ff0ef          	jal	80003e1e <usb_qtd_init>
        if (total_bytes == 0) {
800046a0:	4782                	lw	a5,0(sp)
800046a2:	e791                	bnez	a5,800046ae <.L84>
            p_qtd->int_on_complete = true;
800046a4:	47d2                	lw	a5,20(sp)
800046a6:	43d4                	lw	a3,4(a5)
800046a8:	6721                	lui	a4,0x8
800046aa:	8f55                	or	a4,a4,a3
800046ac:	c3d8                	sw	a4,4(a5)

800046ae <.L84>:
        }
        buffer += xfer_len;
800046ae:	4712                	lw	a4,4(sp)
800046b0:	57a2                	lw	a5,40(sp)
800046b2:	97ba                	add	a5,a5,a4
800046b4:	c23e                	sw	a5,4(sp)

        if (prev_p_qtd) {
800046b6:	5782                	lw	a5,32(sp)
800046b8:	c789                	beqz	a5,800046c2 <.L85>
            prev_p_qtd->next = (uint32_t)p_qtd;
800046ba:	4752                	lw	a4,20(sp)
800046bc:	5782                	lw	a5,32(sp)
800046be:	c398                	sw	a4,0(a5)
800046c0:	a019                	j	800046c6 <.L86>

800046c2 <.L85>:
        } else {
            first_p_qtd = p_qtd;
800046c2:	47d2                	lw	a5,20(sp)
800046c4:	d23e                	sw	a5,36(sp)

800046c6 <.L86>:
        }
        prev_p_qtd = p_qtd;
800046c6:	47d2                	lw	a5,20(sp)
800046c8:	d03e                	sw	a5,32(sp)
    } while (total_bytes > 0);
800046ca:	4782                	lw	a5,0(sp)
800046cc:	f3c9                	bnez	a5,8000464e <.L87>

    p_qhd->qtd_overlay.next = core_local_mem_to_sys_address(0, (uint32_t) first_p_qtd); /* link qtd to qhd */
800046ce:	5792                	lw	a5,36(sp)
800046d0:	85be                	mv	a1,a5
800046d2:	4501                	li	a0,0
800046d4:	70f040ef          	jal	800095e2 <core_local_mem_to_sys_address>
800046d8:	872a                	mv	a4,a0
800046da:	47e2                	lw	a5,24(sp)
800046dc:	c798                	sw	a4,8(a5)

    usb_dcd_edpt_xfer(handle->regs, ep_idx);
800046de:	47b2                	lw	a5,12(sp)
800046e0:	439c                	lw	a5,0(a5)
800046e2:	01d14703          	lbu	a4,29(sp)
800046e6:	85ba                	mv	a1,a4
800046e8:	853e                	mv	a0,a5
800046ea:	1d4060ef          	jal	8000a8be <usb_dcd_edpt_xfer>

    return true;
800046ee:	4785                	li	a5,1

800046f0 <.L80>:
}
800046f0:	853e                	mv	a0,a5
800046f2:	50f2                	lw	ra,60(sp)
800046f4:	6121                	add	sp,sp,64
800046f6:	8082                	ret

Disassembly of section .text.usb_device_edpt_check_stall:

80004702 <usb_device_edpt_check_stall>:
{
    usb_dcd_edpt_clear_stall(handle->regs, ep_addr);
}

bool usb_device_edpt_check_stall(usb_device_handle_t *handle, uint8_t ep_addr)
{
80004702:	1101                	add	sp,sp,-32
80004704:	ce06                	sw	ra,28(sp)
80004706:	c62a                	sw	a0,12(sp)
80004708:	87ae                	mv	a5,a1
8000470a:	00f105a3          	sb	a5,11(sp)
    return usb_dcd_edpt_check_stall(handle->regs, ep_addr);
8000470e:	47b2                	lw	a5,12(sp)
80004710:	439c                	lw	a5,0(a5)
80004712:	00b14703          	lbu	a4,11(sp)
80004716:	85ba                	mv	a1,a4
80004718:	853e                	mv	a0,a5
8000471a:	3b4010ef          	jal	80005ace <usb_dcd_edpt_check_stall>
8000471e:	87aa                	mv	a5,a0
}
80004720:	853e                	mv	a0,a5
80004722:	40f2                	lw	ra,28(sp)
80004724:	6105                	add	sp,sp,32
80004726:	8082                	ret

Disassembly of section .text.can_force_bus_off:

80004732 <can_force_bus_off>:
/**
 * @brief Force CAN controller to Bus-off mode
 * @param [in] base CAN base address
 */
static inline void can_force_bus_off(CAN_Type *base)
{
80004732:	1141                	add	sp,sp,-16
80004734:	c62a                	sw	a0,12(sp)
    base->CMD_STA_CMD_CTRL = CAN_CMD_STA_CMD_CTRL_BUSOFF_MASK;
80004736:	47b2                	lw	a5,12(sp)
80004738:	4705                	li	a4,1
8000473a:	0ae7a023          	sw	a4,160(a5) # ffffc0a0 <__APB_SRAM_segment_end__+0xbf0a0a0>
}
8000473e:	0001                	nop
80004740:	0141                	add	sp,sp,16
80004742:	8082                	ret

Disassembly of section .text.can_set_node_mode:

80004b40 <can_set_node_mode>:
 *  @arg can_mode_loopback_internal internal loopback mode
 *  @arg can_mode_loopback_external external loopback mode
 *  @arg can_mode_listen_only CAN listen-only mode
 */
static inline void can_set_node_mode(CAN_Type *base, can_node_mode_t mode)
{
80004b40:	1101                	add	sp,sp,-32
80004b42:	c62a                	sw	a0,12(sp)
80004b44:	87ae                	mv	a5,a1
80004b46:	00f105a3          	sb	a5,11(sp)
    uint32_t cfg_stat = base->CMD_STA_CMD_CTRL & ~(CAN_CMD_STA_CMD_CTRL_LBME_MASK | CAN_CMD_STA_CMD_CTRL_LBMI_MASK | CAN_CMD_STA_CMD_CTRL_LOM_MASK);
80004b4a:	47b2                	lw	a5,12(sp)
80004b4c:	0a07a703          	lw	a4,160(a5)
80004b50:	77f1                	lui	a5,0xffffc
80004b52:	f9f78793          	add	a5,a5,-97 # ffffbf9f <__APB_SRAM_segment_end__+0xbf09f9f>
80004b56:	8ff9                	and	a5,a5,a4
80004b58:	ce3e                	sw	a5,28(sp)
    if (mode == can_mode_loopback_internal) {
80004b5a:	00b14703          	lbu	a4,11(sp)
80004b5e:	4785                	li	a5,1
80004b60:	00f71763          	bne	a4,a5,80004b6e <.L7>
        cfg_stat |= CAN_CMD_STA_CMD_CTRL_LBMI_MASK;
80004b64:	47f2                	lw	a5,28(sp)
80004b66:	0207e793          	or	a5,a5,32
80004b6a:	ce3e                	sw	a5,28(sp)
80004b6c:	a025                	j	80004b94 <.L8>

80004b6e <.L7>:
    } else if (mode == can_mode_loopback_external) {
80004b6e:	00b14703          	lbu	a4,11(sp)
80004b72:	4789                	li	a5,2
80004b74:	00f71763          	bne	a4,a5,80004b82 <.L9>
        cfg_stat |= CAN_CMD_STA_CMD_CTRL_LBME_MASK;
80004b78:	47f2                	lw	a5,28(sp)
80004b7a:	0407e793          	or	a5,a5,64
80004b7e:	ce3e                	sw	a5,28(sp)
80004b80:	a811                	j	80004b94 <.L8>

80004b82 <.L9>:
    } else if (mode == can_mode_listen_only) {
80004b82:	00b14703          	lbu	a4,11(sp)
80004b86:	478d                	li	a5,3
80004b88:	00f71663          	bne	a4,a5,80004b94 <.L8>
        cfg_stat |= CAN_CMD_STA_CMD_CTRL_LOM_MASK;
80004b8c:	4772                	lw	a4,28(sp)
80004b8e:	6791                	lui	a5,0x4
80004b90:	8fd9                	or	a5,a5,a4
80004b92:	ce3e                	sw	a5,28(sp)

80004b94 <.L8>:
    } else {
        /* CAN normal work mode, no change needed here */
    }
    base->CMD_STA_CMD_CTRL = cfg_stat;
80004b94:	47b2                	lw	a5,12(sp)
80004b96:	4772                	lw	a4,28(sp)
80004b98:	0ae7a023          	sw	a4,160(a5) # 40a0 <__HEAPSIZE__+0xa0>
}
80004b9c:	0001                	nop
80004b9e:	6105                	add	sp,sp,32
80004ba0:	8082                	ret

Disassembly of section .text.can_select_tx_buffer_priority_mode:

80004ba2 <can_select_tx_buffer_priority_mode>:
 * @param [in] enable_priority_decision CAN tx buffer priority mode selection flag
 *  @arg true priority decision mode
 *  @arg false FIFO mode
 */
static inline void can_select_tx_buffer_priority_mode(CAN_Type *base, bool enable_priority_decision)
{
80004ba2:	1141                	add	sp,sp,-16
80004ba4:	c62a                	sw	a0,12(sp)
80004ba6:	87ae                	mv	a5,a1
80004ba8:	00f105a3          	sb	a5,11(sp)
    if (enable_priority_decision) {
80004bac:	00b14783          	lbu	a5,11(sp)
80004bb0:	cb99                	beqz	a5,80004bc6 <.L19>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TSMODE_MASK;
80004bb2:	47b2                	lw	a5,12(sp)
80004bb4:	0a07a703          	lw	a4,160(a5)
80004bb8:	002007b7          	lui	a5,0x200
80004bbc:	8f5d                	or	a4,a4,a5
80004bbe:	47b2                	lw	a5,12(sp)
80004bc0:	0ae7a023          	sw	a4,160(a5) # 2000a0 <__DLM_segment_end__+0x1400a0>
    } else {
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TSMODE_MASK;
    }
}
80004bc4:	a819                	j	80004bda <.L21>

80004bc6 <.L19>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TSMODE_MASK;
80004bc6:	47b2                	lw	a5,12(sp)
80004bc8:	0a07a703          	lw	a4,160(a5)
80004bcc:	ffe007b7          	lui	a5,0xffe00
80004bd0:	17fd                	add	a5,a5,-1 # ffdfffff <__APB_SRAM_segment_end__+0xbd0dfff>
80004bd2:	8f7d                	and	a4,a4,a5
80004bd4:	47b2                	lw	a5,12(sp)
80004bd6:	0ae7a023          	sw	a4,160(a5)

80004bda <.L21>:
}
80004bda:	0001                	nop
80004bdc:	0141                	add	sp,sp,16
80004bde:	8082                	ret

Disassembly of section .text.can_enable_self_ack:

80004be0 <can_enable_self_ack>:
 * @param [in] base CAN base address
 * @param [in] enable Self-ack enable flag, true or false
 *
 */
static inline void can_enable_self_ack(CAN_Type *base, bool enable)
{
80004be0:	1141                	add	sp,sp,-16
80004be2:	c62a                	sw	a0,12(sp)
80004be4:	87ae                	mv	a5,a1
80004be6:	00f105a3          	sb	a5,11(sp)
    if (enable) {
80004bea:	00b14783          	lbu	a5,11(sp)
80004bee:	cb99                	beqz	a5,80004c04 <.L23>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_SACK_MASK;
80004bf0:	47b2                	lw	a5,12(sp)
80004bf2:	0a07a703          	lw	a4,160(a5)
80004bf6:	800007b7          	lui	a5,0x80000
80004bfa:	8f5d                	or	a4,a4,a5
80004bfc:	47b2                	lw	a5,12(sp)
80004bfe:	0ae7a023          	sw	a4,160(a5) # 800000a0 <__SHARE_RAM_segment_end__+0x7ee800a0>
    } else {
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_SACK_MASK;
    }
}
80004c02:	a819                	j	80004c18 <.L25>

80004c04 <.L23>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_SACK_MASK;
80004c04:	47b2                	lw	a5,12(sp)
80004c06:	0a07a703          	lw	a4,160(a5)
80004c0a:	800007b7          	lui	a5,0x80000
80004c0e:	17fd                	add	a5,a5,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
80004c10:	8f7d                	and	a4,a4,a5
80004c12:	47b2                	lw	a5,12(sp)
80004c14:	0ae7a023          	sw	a4,160(a5)

80004c18 <.L25>:
}
80004c18:	0001                	nop
80004c1a:	0141                	add	sp,sp,16
80004c1c:	8082                	ret

Disassembly of section .text.can_enable_can_fd_iso_mode:

80004c1e <can_enable_can_fd_iso_mode>:
 * @brief Enable CAN FD ISO mode
 * @param [in] base CAN base address
 * @param enable CAN-FD ISO mode enable flag
 */
static inline void can_enable_can_fd_iso_mode(CAN_Type *base, bool enable)
{
80004c1e:	1141                	add	sp,sp,-16
80004c20:	c62a                	sw	a0,12(sp)
80004c22:	87ae                	mv	a5,a1
80004c24:	00f105a3          	sb	a5,11(sp)
    if (enable) {
80004c28:	00b14783          	lbu	a5,11(sp)
80004c2c:	cb99                	beqz	a5,80004c42 <.L27>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_FD_ISO_MASK;
80004c2e:	47b2                	lw	a5,12(sp)
80004c30:	0a07a703          	lw	a4,160(a5)
80004c34:	008007b7          	lui	a5,0x800
80004c38:	8f5d                	or	a4,a4,a5
80004c3a:	47b2                	lw	a5,12(sp)
80004c3c:	0ae7a023          	sw	a4,160(a5) # 8000a0 <_flash_size+0xa0>
    } else {
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_FD_ISO_MASK;
    }
}
80004c40:	a819                	j	80004c56 <.L29>

80004c42 <.L27>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_FD_ISO_MASK;
80004c42:	47b2                	lw	a5,12(sp)
80004c44:	0a07a703          	lw	a4,160(a5)
80004c48:	ff8007b7          	lui	a5,0xff800
80004c4c:	17fd                	add	a5,a5,-1 # ff7fffff <__APB_SRAM_segment_end__+0xb70dfff>
80004c4e:	8f7d                	and	a4,a4,a5
80004c50:	47b2                	lw	a5,12(sp)
80004c52:	0ae7a023          	sw	a4,160(a5)

80004c56 <.L29>:
}
80004c56:	0001                	nop
80004c58:	0141                	add	sp,sp,16
80004c5a:	8082                	ret

Disassembly of section .text.can_enable_tx_rx_irq:

80004c5c <can_enable_tx_rx_irq>:
 * @brief Enable CAN TX/RX interrupt
 * @param [in] base CAN base address
 * @param [in] mask CAN interrupt mask
 */
static inline void can_enable_tx_rx_irq(CAN_Type *base, uint8_t mask)
{
80004c5c:	1141                	add	sp,sp,-16
80004c5e:	c62a                	sw	a0,12(sp)
80004c60:	87ae                	mv	a5,a1
80004c62:	00f105a3          	sb	a5,11(sp)
    base->RTIE |= mask;
80004c66:	47b2                	lw	a5,12(sp)
80004c68:	0a47c783          	lbu	a5,164(a5)
80004c6c:	0ff7f793          	zext.b	a5,a5
80004c70:	00b14703          	lbu	a4,11(sp)
80004c74:	8fd9                	or	a5,a5,a4
80004c76:	0ff7f713          	zext.b	a4,a5
80004c7a:	47b2                	lw	a5,12(sp)
80004c7c:	0ae78223          	sb	a4,164(a5)
}
80004c80:	0001                	nop
80004c82:	0141                	add	sp,sp,16
80004c84:	8082                	ret

Disassembly of section .text.can_enable_error_irq:

80004c86 <can_enable_error_irq>:
 * @brief Enable CAN error interrupt
 * @param [in] base CAN base address
 * @param [in] mask CAN error interrupt mask
 */
static inline void can_enable_error_irq(CAN_Type *base, uint8_t mask)
{
80004c86:	1141                	add	sp,sp,-16
80004c88:	c62a                	sw	a0,12(sp)
80004c8a:	87ae                	mv	a5,a1
80004c8c:	00f105a3          	sb	a5,11(sp)
    base->ERRINT |= mask;
80004c90:	47b2                	lw	a5,12(sp)
80004c92:	0a67c783          	lbu	a5,166(a5)
80004c96:	0ff7f793          	zext.b	a5,a5
80004c9a:	00b14703          	lbu	a4,11(sp)
80004c9e:	8fd9                	or	a5,a5,a4
80004ca0:	0ff7f713          	zext.b	a4,a5
80004ca4:	47b2                	lw	a5,12(sp)
80004ca6:	0ae78323          	sb	a4,166(a5)
}
80004caa:	0001                	nop
80004cac:	0141                	add	sp,sp,16
80004cae:	8082                	ret

Disassembly of section .text.can_disable_filter:

80004cb0 <can_disable_filter>:
 *
 * @param [in] base CAN base address
 * @param index  CAN filter index
 */
static inline void can_disable_filter(CAN_Type *base, uint32_t index)
{
80004cb0:	1141                	add	sp,sp,-16
80004cb2:	c62a                	sw	a0,12(sp)
80004cb4:	c42e                	sw	a1,8(sp)
    base->ACF_EN &= (uint16_t) ~(1U << index);
80004cb6:	47b2                	lw	a5,12(sp)
80004cb8:	0b67d783          	lhu	a5,182(a5)
80004cbc:	01079713          	sll	a4,a5,0x10
80004cc0:	8341                	srl	a4,a4,0x10
80004cc2:	47a2                	lw	a5,8(sp)
80004cc4:	4685                	li	a3,1
80004cc6:	00f697b3          	sll	a5,a3,a5
80004cca:	07c2                	sll	a5,a5,0x10
80004ccc:	83c1                	srl	a5,a5,0x10
80004cce:	fff7c793          	not	a5,a5
80004cd2:	07c2                	sll	a5,a5,0x10
80004cd4:	83c1                	srl	a5,a5,0x10
80004cd6:	8ff9                	and	a5,a5,a4
80004cd8:	01079713          	sll	a4,a5,0x10
80004cdc:	8341                	srl	a4,a4,0x10
80004cde:	47b2                	lw	a5,12(sp)
80004ce0:	0ae79b23          	sh	a4,182(a5)
}
80004ce4:	0001                	nop
80004ce6:	0141                	add	sp,sp,16
80004ce8:	8082                	ret

Disassembly of section .text.can_set_slow_speed_timing:

80004cea <can_set_slow_speed_timing>:
 * @brief Configure the Slow Speed Bit timing using low-level interface
 * @param [in] base CAN base address
 * @param [in] param CAN bit timing parameter
 */
static inline void can_set_slow_speed_timing(CAN_Type *base, const can_bit_timing_param_t *param)
{
80004cea:	1141                	add	sp,sp,-16
80004cec:	c62a                	sw	a0,12(sp)
80004cee:	c42e                	sw	a1,8(sp)
    base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(param->prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(param->num_seg1 - 2U) |
80004cf0:	47a2                	lw	a5,8(sp)
80004cf2:	0007d783          	lhu	a5,0(a5)
80004cf6:	17fd                	add	a5,a5,-1
80004cf8:	01879713          	sll	a4,a5,0x18
80004cfc:	47a2                	lw	a5,8(sp)
80004cfe:	0027d783          	lhu	a5,2(a5)
80004d02:	17f9                	add	a5,a5,-2
80004d04:	0ff7f793          	zext.b	a5,a5
80004d08:	8f5d                	or	a4,a4,a5
                                CAN_S_PRESC_S_SEG_2_SET(param->num_seg2 - 1U) | CAN_S_PRESC_S_SJW_SET(param->num_sjw - 1U);
80004d0a:	47a2                	lw	a5,8(sp)
80004d0c:	0047d783          	lhu	a5,4(a5)
80004d10:	17fd                	add	a5,a5,-1
80004d12:	00879693          	sll	a3,a5,0x8
80004d16:	67a1                	lui	a5,0x8
80004d18:	f0078793          	add	a5,a5,-256 # 7f00 <__NONCACHEABLE_RAM_segment_used_size__+0x2a08>
80004d1c:	8ff5                	and	a5,a5,a3
    base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(param->prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(param->num_seg1 - 2U) |
80004d1e:	8f5d                	or	a4,a4,a5
                                CAN_S_PRESC_S_SEG_2_SET(param->num_seg2 - 1U) | CAN_S_PRESC_S_SJW_SET(param->num_sjw - 1U);
80004d20:	47a2                	lw	a5,8(sp)
80004d22:	0067d783          	lhu	a5,6(a5)
80004d26:	17fd                	add	a5,a5,-1
80004d28:	01079693          	sll	a3,a5,0x10
80004d2c:	007f07b7          	lui	a5,0x7f0
80004d30:	8ff5                	and	a5,a5,a3
80004d32:	8f5d                	or	a4,a4,a5
    base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(param->prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(param->num_seg1 - 2U) |
80004d34:	47b2                	lw	a5,12(sp)
80004d36:	0ae7a423          	sw	a4,168(a5) # 7f00a8 <__DLM_segment_end__+0x7300a8>
}
80004d3a:	0001                	nop
80004d3c:	0141                	add	sp,sp,16
80004d3e:	8082                	ret

Disassembly of section .text.is_can_bit_timing_param_valid:

80004d40 <is_can_bit_timing_param_valid>:

    return status;
}

static bool is_can_bit_timing_param_valid(can_bit_timing_option_t option, const can_bit_timing_param_t *param)
{
80004d40:	1101                	add	sp,sp,-32
80004d42:	87aa                	mv	a5,a0
80004d44:	c42e                	sw	a1,8(sp)
80004d46:	00f107a3          	sb	a5,15(sp)
    bool result = false;
80004d4a:	00010fa3          	sb	zero,31(sp)
    const can_bit_timing_table_t *tbl = &s_can_bit_timing_tbl[(uint8_t) option];
80004d4e:	00f14703          	lbu	a4,15(sp)
80004d52:	87ba                	mv	a5,a4
80004d54:	078e                	sll	a5,a5,0x3
80004d56:	97ba                	add	a5,a5,a4
80004d58:	54420713          	add	a4,tp,1348 # 544 <slcan_parse_ascii+0x12>
80004d5c:	97ba                	add	a5,a5,a4
80004d5e:	cc3e                	sw	a5,24(sp)
    do {
        if ((param->num_seg1 < tbl->seg1_min) || (param->num_seg1 > tbl->seg1_max)) {
80004d60:	47a2                	lw	a5,8(sp)
80004d62:	0027d783          	lhu	a5,2(a5)
80004d66:	4762                	lw	a4,24(sp)
80004d68:	00274703          	lbu	a4,2(a4) # 8002 <__AHB_SRAM_segment_size__+0x2>
80004d6c:	06e7e663          	bltu	a5,a4,80004dd8 <.L66>
80004d70:	47a2                	lw	a5,8(sp)
80004d72:	0027d783          	lhu	a5,2(a5)
80004d76:	4762                	lw	a4,24(sp)
80004d78:	00374703          	lbu	a4,3(a4)
80004d7c:	04f76e63          	bltu	a4,a5,80004dd8 <.L66>
            break;
        }
        if ((param->num_seg2 < tbl->seg2_min) || (param->num_seg2 > tbl->seg2_max)) {
80004d80:	47a2                	lw	a5,8(sp)
80004d82:	0047d783          	lhu	a5,4(a5)
80004d86:	4762                	lw	a4,24(sp)
80004d88:	00474703          	lbu	a4,4(a4)
80004d8c:	04e7e663          	bltu	a5,a4,80004dd8 <.L66>
80004d90:	47a2                	lw	a5,8(sp)
80004d92:	0047d783          	lhu	a5,4(a5)
80004d96:	4762                	lw	a4,24(sp)
80004d98:	00574703          	lbu	a4,5(a4)
80004d9c:	02f76e63          	bltu	a4,a5,80004dd8 <.L66>
            break;
        }
        if ((param->num_sjw < tbl->sjw_min) || (param->num_sjw > tbl->sjw_max)) {
80004da0:	47a2                	lw	a5,8(sp)
80004da2:	0067d783          	lhu	a5,6(a5)
80004da6:	4762                	lw	a4,24(sp)
80004da8:	00674703          	lbu	a4,6(a4)
80004dac:	02e7e663          	bltu	a5,a4,80004dd8 <.L66>
80004db0:	47a2                	lw	a5,8(sp)
80004db2:	0067d783          	lhu	a5,6(a5)
80004db6:	4762                	lw	a4,24(sp)
80004db8:	00774703          	lbu	a4,7(a4)
80004dbc:	00f76e63          	bltu	a4,a5,80004dd8 <.L66>
            break;
        }
        if (param->prescaler > NUM_PRESCALE_MAX) {
80004dc0:	47a2                	lw	a5,8(sp)
80004dc2:	0007d703          	lhu	a4,0(a5)
80004dc6:	10000793          	li	a5,256
80004dca:	00e7e663          	bltu	a5,a4,80004dd6 <.L69>
            break;
        }
        result = true;
80004dce:	4785                	li	a5,1
80004dd0:	00f10fa3          	sb	a5,31(sp)
80004dd4:	a011                	j	80004dd8 <.L66>

80004dd6 <.L69>:
            break;
80004dd6:	0001                	nop

80004dd8 <.L66>:
    } while (false);

    return result;
80004dd8:	01f14783          	lbu	a5,31(sp)
}
80004ddc:	853e                	mv	a0,a5
80004dde:	6105                	add	sp,sp,32
80004de0:	8082                	ret

Disassembly of section .text.can_set_bit_timing:

80004de2 <can_set_bit_timing>:

hpm_stat_t can_set_bit_timing(CAN_Type *base, can_bit_timing_option_t option,
                              uint32_t src_clk_freq, uint32_t baudrate,
                              uint16_t samplepoint_min, uint16_t samplepoint_max)
{
80004de2:	7139                	add	sp,sp,-64
80004de4:	de06                	sw	ra,60(sp)
80004de6:	ce2a                	sw	a0,28(sp)
80004de8:	ca32                	sw	a2,20(sp)
80004dea:	c836                	sw	a3,16(sp)
80004dec:	86ba                	mv	a3,a4
80004dee:	873e                	mv	a4,a5
80004df0:	87ae                	mv	a5,a1
80004df2:	00f10da3          	sb	a5,27(sp)
80004df6:	87b6                	mv	a5,a3
80004df8:	00f11c23          	sh	a5,24(sp)
80004dfc:	87ba                	mv	a5,a4
80004dfe:	00f11723          	sh	a5,14(sp)
    hpm_stat_t status = status_invalid_argument;
80004e02:	4789                	li	a5,2
80004e04:	d63e                	sw	a5,44(sp)

80004e06 <.LBB7>:

    do {
        if (base == NULL) {
80004e06:	47f2                	lw	a5,28(sp)
80004e08:	cbc5                	beqz	a5,80004eb8 <.L77>
            break;
        }

        can_bit_timing_param_t timing_param;
        status = can_calculate_bit_timing(src_clk_freq, option, baudrate, samplepoint_min, samplepoint_max, &timing_param);
80004e0a:	105c                	add	a5,sp,36
80004e0c:	00e15703          	lhu	a4,14(sp)
80004e10:	01815683          	lhu	a3,24(sp)
80004e14:	01b14583          	lbu	a1,27(sp)
80004e18:	4642                	lw	a2,16(sp)
80004e1a:	4552                	lw	a0,20(sp)
80004e1c:	467040ef          	jal	80009a82 <can_calculate_bit_timing>
80004e20:	d62a                	sw	a0,44(sp)

        if (status == status_success) {
80004e22:	57b2                	lw	a5,44(sp)
80004e24:	ebd9                	bnez	a5,80004eba <.L72>
            if (option < can_bit_timing_canfd_data) {
80004e26:	01b14703          	lbu	a4,27(sp)
80004e2a:	4785                	li	a5,1
80004e2c:	04e7e463          	bltu	a5,a4,80004e74 <.L74>
                base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(timing_param.prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(timing_param.num_seg1 - 2U) |
80004e30:	02415783          	lhu	a5,36(sp)
80004e34:	17fd                	add	a5,a5,-1
80004e36:	01879713          	sll	a4,a5,0x18
80004e3a:	02615783          	lhu	a5,38(sp)
80004e3e:	17f9                	add	a5,a5,-2
80004e40:	0ff7f793          	zext.b	a5,a5
80004e44:	8f5d                	or	a4,a4,a5
                                CAN_S_PRESC_S_SEG_2_SET(timing_param.num_seg2 - 1U) | CAN_S_PRESC_S_SJW_SET(timing_param.num_sjw - 1U);
80004e46:	02815783          	lhu	a5,40(sp)
80004e4a:	17fd                	add	a5,a5,-1
80004e4c:	00879693          	sll	a3,a5,0x8
80004e50:	67a1                	lui	a5,0x8
80004e52:	f0078793          	add	a5,a5,-256 # 7f00 <__NONCACHEABLE_RAM_segment_used_size__+0x2a08>
80004e56:	8ff5                	and	a5,a5,a3
                base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(timing_param.prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(timing_param.num_seg1 - 2U) |
80004e58:	8f5d                	or	a4,a4,a5
                                CAN_S_PRESC_S_SEG_2_SET(timing_param.num_seg2 - 1U) | CAN_S_PRESC_S_SJW_SET(timing_param.num_sjw - 1U);
80004e5a:	02a15783          	lhu	a5,42(sp)
80004e5e:	17fd                	add	a5,a5,-1
80004e60:	01079693          	sll	a3,a5,0x10
80004e64:	007f07b7          	lui	a5,0x7f0
80004e68:	8ff5                	and	a5,a5,a3
80004e6a:	8f5d                	or	a4,a4,a5
                base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(timing_param.prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(timing_param.num_seg1 - 2U) |
80004e6c:	47f2                	lw	a5,28(sp)
80004e6e:	0ae7a423          	sw	a4,168(a5) # 7f00a8 <__DLM_segment_end__+0x7300a8>
80004e72:	a089                	j	80004eb4 <.L75>

80004e74 <.L74>:
            } else {
                base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(timing_param.prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(timing_param.num_seg1 - 2U) |
80004e74:	02415783          	lhu	a5,36(sp)
80004e78:	17fd                	add	a5,a5,-1
80004e7a:	01879713          	sll	a4,a5,0x18
80004e7e:	02615783          	lhu	a5,38(sp)
80004e82:	17f9                	add	a5,a5,-2
80004e84:	8bbd                	and	a5,a5,15
80004e86:	8f5d                	or	a4,a4,a5
                                CAN_F_PRESC_F_SEG_2_SET(timing_param.num_seg2 - 1U) | CAN_F_PRESC_F_SJW_SET(timing_param.num_sjw - 1U);
80004e88:	02815783          	lhu	a5,40(sp)
80004e8c:	17fd                	add	a5,a5,-1
80004e8e:	00879693          	sll	a3,a5,0x8
80004e92:	6785                	lui	a5,0x1
80004e94:	f0078793          	add	a5,a5,-256 # f00 <.L27+0xc6>
80004e98:	8ff5                	and	a5,a5,a3
                base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(timing_param.prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(timing_param.num_seg1 - 2U) |
80004e9a:	8f5d                	or	a4,a4,a5
                                CAN_F_PRESC_F_SEG_2_SET(timing_param.num_seg2 - 1U) | CAN_F_PRESC_F_SJW_SET(timing_param.num_sjw - 1U);
80004e9c:	02a15783          	lhu	a5,42(sp)
80004ea0:	17fd                	add	a5,a5,-1
80004ea2:	01079693          	sll	a3,a5,0x10
80004ea6:	000f07b7          	lui	a5,0xf0
80004eaa:	8ff5                	and	a5,a5,a3
80004eac:	8f5d                	or	a4,a4,a5
                base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(timing_param.prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(timing_param.num_seg1 - 2U) |
80004eae:	47f2                	lw	a5,28(sp)
80004eb0:	0ae7a623          	sw	a4,172(a5) # f00ac <__DLM_segment_end__+0x300ac>

80004eb4 <.L75>:

            }
            status = status_success;
80004eb4:	d602                	sw	zero,44(sp)
80004eb6:	a011                	j	80004eba <.L72>

80004eb8 <.L77>:
            break;
80004eb8:	0001                	nop

80004eba <.L72>:
        }

    } while (false);

    return status;
80004eba:	57b2                	lw	a5,44(sp)
}
80004ebc:	853e                	mv	a0,a5
80004ebe:	50f2                	lw	ra,60(sp)
80004ec0:	6121                	add	sp,sp,64
80004ec2:	8082                	ret

Disassembly of section .text.can_set_filter:

80004ec4 <can_set_filter>:

hpm_stat_t can_set_filter(CAN_Type *base, const can_filter_config_t *config)
{
80004ec4:	1101                	add	sp,sp,-32
80004ec6:	c62a                	sw	a0,12(sp)
80004ec8:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
80004eca:	4789                	li	a5,2
80004ecc:	ce3e                	sw	a5,28(sp)

80004ece <.LBB8>:

    do {
        if ((base == NULL) || (config == NULL)) {
80004ece:	47b2                	lw	a5,12(sp)
80004ed0:	10078b63          	beqz	a5,80004fe6 <.L79>
80004ed4:	47a2                	lw	a5,8(sp)
80004ed6:	10078863          	beqz	a5,80004fe6 <.L79>
            break;
        }
        if (config->index > CAN_FILTER_INDEX_MAX) {
80004eda:	47a2                	lw	a5,8(sp)
80004edc:	0007d703          	lhu	a4,0(a5)
80004ee0:	47bd                	li	a5,15
80004ee2:	00e7f763          	bgeu	a5,a4,80004ef0 <.L80>
            status = status_can_filter_index_invalid;
80004ee6:	6795                	lui	a5,0x5
80004ee8:	a3f78793          	add	a5,a5,-1473 # 4a3f <__HEAPSIZE__+0xa3f>
80004eec:	ce3e                	sw	a5,28(sp)
            break;
80004eee:	a8e5                	j	80004fe6 <.L79>

80004ef0 <.L80>:
        }

        /* Configure acceptance code */
        base->ACFCTRL = CAN_ACFCTRL_ACFADR_SET(config->index);
80004ef0:	47a2                	lw	a5,8(sp)
80004ef2:	0007d783          	lhu	a5,0(a5)
80004ef6:	0ff7f793          	zext.b	a5,a5
80004efa:	8bbd                	and	a5,a5,15
80004efc:	0ff7f713          	zext.b	a4,a5
80004f00:	47b2                	lw	a5,12(sp)
80004f02:	0ae78a23          	sb	a4,180(a5)
        base->ACF = CAN_ACF_CODE_MASK_SET(config->code);
80004f06:	47a2                	lw	a5,8(sp)
80004f08:	43d8                	lw	a4,4(a5)
80004f0a:	200007b7          	lui	a5,0x20000
80004f0e:	17fd                	add	a5,a5,-1 # 1fffffff <__SHARE_RAM_segment_end__+0x1ee7ffff>
80004f10:	8f7d                	and	a4,a4,a5
80004f12:	47b2                	lw	a5,12(sp)
80004f14:	0ae7ac23          	sw	a4,184(a5)

        /* Configure acceptance mask */
        uint32_t acf_value = CAN_ACF_CODE_MASK_SET(config->mask);
80004f18:	47a2                	lw	a5,8(sp)
80004f1a:	4798                	lw	a4,8(a5)
80004f1c:	200007b7          	lui	a5,0x20000
80004f20:	17fd                	add	a5,a5,-1 # 1fffffff <__SHARE_RAM_segment_end__+0x1ee7ffff>
80004f22:	8ff9                	and	a5,a5,a4
80004f24:	cc3e                	sw	a5,24(sp)
        if (config->id_mode == can_filter_id_mode_standard_frames) {
80004f26:	47a2                	lw	a5,8(sp)
80004f28:	0027c703          	lbu	a4,2(a5)
80004f2c:	4785                	li	a5,1
80004f2e:	00f71863          	bne	a4,a5,80004f3e <.L81>
            acf_value |= CAN_ACF_AIDEE_MASK;
80004f32:	4762                	lw	a4,24(sp)
80004f34:	400007b7          	lui	a5,0x40000
80004f38:	8fd9                	or	a5,a5,a4
80004f3a:	cc3e                	sw	a5,24(sp)
80004f3c:	a821                	j	80004f54 <.L82>

80004f3e <.L81>:
        } else if (config->id_mode == can_filter_id_mode_extended_frames) {
80004f3e:	47a2                	lw	a5,8(sp)
80004f40:	0027c703          	lbu	a4,2(a5) # 40000002 <__SHARE_RAM_segment_end__+0x3ee80002>
80004f44:	4789                	li	a5,2
80004f46:	00f71763          	bne	a4,a5,80004f54 <.L82>
            acf_value |= CAN_ACF_AIDEE_MASK | CAN_ACF_AIDE_MASK;
80004f4a:	4762                	lw	a4,24(sp)
80004f4c:	600007b7          	lui	a5,0x60000
80004f50:	8fd9                	or	a5,a5,a4
80004f52:	cc3e                	sw	a5,24(sp)

80004f54 <.L82>:
        } else {
            /* Treat it as the default mode */
            acf_value |= 0;
        }

        base->ACFCTRL = CAN_ACFCTRL_SELMASK_MASK | CAN_ACFCTRL_ACFADR_SET(config->index);
80004f54:	47a2                	lw	a5,8(sp)
80004f56:	0007d783          	lhu	a5,0(a5) # 60000000 <__SHARE_RAM_segment_end__+0x5ee80000>
80004f5a:	0ff7f793          	zext.b	a5,a5
80004f5e:	8bbd                	and	a5,a5,15
80004f60:	0ff7f793          	zext.b	a5,a5
80004f64:	0207e793          	or	a5,a5,32
80004f68:	0ff7f713          	zext.b	a4,a5
80004f6c:	47b2                	lw	a5,12(sp)
80004f6e:	0ae78a23          	sb	a4,180(a5)
        base->ACF = acf_value;
80004f72:	47b2                	lw	a5,12(sp)
80004f74:	4762                	lw	a4,24(sp)
80004f76:	0ae7ac23          	sw	a4,184(a5)

        if (config->enable) {
80004f7a:	47a2                	lw	a5,8(sp)
80004f7c:	0037c783          	lbu	a5,3(a5)
80004f80:	cb85                	beqz	a5,80004fb0 <.L84>
            base->ACF_EN |= (1U << config->index);
80004f82:	47b2                	lw	a5,12(sp)
80004f84:	0b67d783          	lhu	a5,182(a5)
80004f88:	01079713          	sll	a4,a5,0x10
80004f8c:	8341                	srl	a4,a4,0x10
80004f8e:	47a2                	lw	a5,8(sp)
80004f90:	0007d783          	lhu	a5,0(a5)
80004f94:	86be                	mv	a3,a5
80004f96:	4785                	li	a5,1
80004f98:	00d797b3          	sll	a5,a5,a3
80004f9c:	07c2                	sll	a5,a5,0x10
80004f9e:	83c1                	srl	a5,a5,0x10
80004fa0:	8fd9                	or	a5,a5,a4
80004fa2:	01079713          	sll	a4,a5,0x10
80004fa6:	8341                	srl	a4,a4,0x10
80004fa8:	47b2                	lw	a5,12(sp)
80004faa:	0ae79b23          	sh	a4,182(a5)
80004fae:	a81d                	j	80004fe4 <.L85>

80004fb0 <.L84>:
        } else {
            base->ACF_EN &= (uint16_t) ~(1U << config->index);
80004fb0:	47b2                	lw	a5,12(sp)
80004fb2:	0b67d783          	lhu	a5,182(a5)
80004fb6:	01079713          	sll	a4,a5,0x10
80004fba:	8341                	srl	a4,a4,0x10
80004fbc:	47a2                	lw	a5,8(sp)
80004fbe:	0007d783          	lhu	a5,0(a5)
80004fc2:	86be                	mv	a3,a5
80004fc4:	4785                	li	a5,1
80004fc6:	00d797b3          	sll	a5,a5,a3
80004fca:	07c2                	sll	a5,a5,0x10
80004fcc:	83c1                	srl	a5,a5,0x10
80004fce:	fff7c793          	not	a5,a5
80004fd2:	07c2                	sll	a5,a5,0x10
80004fd4:	83c1                	srl	a5,a5,0x10
80004fd6:	8ff9                	and	a5,a5,a4
80004fd8:	01079713          	sll	a4,a5,0x10
80004fdc:	8341                	srl	a4,a4,0x10
80004fde:	47b2                	lw	a5,12(sp)
80004fe0:	0ae79b23          	sh	a4,182(a5)

80004fe4 <.L85>:
        }
        status = status_success;
80004fe4:	ce02                	sw	zero,28(sp)

80004fe6 <.L79>:
    } while (false);

    return status;
80004fe6:	47f2                	lw	a5,28(sp)
}
80004fe8:	853e                	mv	a0,a5
80004fea:	6105                	add	sp,sp,32
80004fec:	8082                	ret

Disassembly of section .text.can_get_data_words_from_dlc:

80004fee <can_get_data_words_from_dlc>:

static uint8_t can_get_data_words_from_dlc(uint32_t dlc)
{
80004fee:	1101                	add	sp,sp,-32
80004ff0:	c62a                	sw	a0,12(sp)
    uint32_t copy_words = 0;
80004ff2:	ce02                	sw	zero,28(sp)

    dlc &= 0xFU;
80004ff4:	47b2                	lw	a5,12(sp)
80004ff6:	8bbd                	and	a5,a5,15
80004ff8:	c63e                	sw	a5,12(sp)
    if (dlc <= 8U) {
80004ffa:	4732                	lw	a4,12(sp)
80004ffc:	47a1                	li	a5,8
80004ffe:	00e7e763          	bltu	a5,a4,8000500c <.L88>
        copy_words = (dlc + 3U) / sizeof(uint32_t);
80005002:	47b2                	lw	a5,12(sp)
80005004:	078d                	add	a5,a5,3
80005006:	8389                	srl	a5,a5,0x2
80005008:	ce3e                	sw	a5,28(sp)
8000500a:	a0a9                	j	80005054 <.L89>

8000500c <.L88>:
    } else {
        switch (dlc) {
8000500c:	47b2                	lw	a5,12(sp)
8000500e:	17dd                	add	a5,a5,-9
80005010:	4719                	li	a4,6
80005012:	04f76063          	bltu	a4,a5,80005052 <.L100>
80005016:	00279713          	sll	a4,a5,0x2
8000501a:	800037b7          	lui	a5,0x80003
8000501e:	13878793          	add	a5,a5,312 # 80003138 <.L92>
80005022:	97ba                	add	a5,a5,a4
80005024:	439c                	lw	a5,0(a5)
80005026:	8782                	jr	a5

80005028 <.L98>:
        case can_payload_size_12:
            copy_words = 3U;
80005028:	478d                	li	a5,3
8000502a:	ce3e                	sw	a5,28(sp)
            break;
8000502c:	a025                	j	80005054 <.L89>

8000502e <.L97>:
        case can_payload_size_16:
            copy_words = 4U;
8000502e:	4791                	li	a5,4
80005030:	ce3e                	sw	a5,28(sp)
            break;
80005032:	a00d                	j	80005054 <.L89>

80005034 <.L96>:
        case can_payload_size_20:
            copy_words = 5U;
80005034:	4795                	li	a5,5
80005036:	ce3e                	sw	a5,28(sp)
            break;
80005038:	a831                	j	80005054 <.L89>

8000503a <.L95>:
        case can_payload_size_24:
            copy_words = 6U;
8000503a:	4799                	li	a5,6
8000503c:	ce3e                	sw	a5,28(sp)
            break;
8000503e:	a819                	j	80005054 <.L89>

80005040 <.L94>:
        case can_payload_size_32:
            copy_words = 8U;
80005040:	47a1                	li	a5,8
80005042:	ce3e                	sw	a5,28(sp)
            break;
80005044:	a801                	j	80005054 <.L89>

80005046 <.L93>:
        case can_payload_size_48:
            copy_words = 12U;
80005046:	47b1                	li	a5,12
80005048:	ce3e                	sw	a5,28(sp)
            break;
8000504a:	a029                	j	80005054 <.L89>

8000504c <.L91>:
        case can_payload_size_64:
            copy_words = 16U;
8000504c:	47c1                	li	a5,16
8000504e:	ce3e                	sw	a5,28(sp)
            break;
80005050:	a011                	j	80005054 <.L89>

80005052 <.L100>:
        default:
            /* Code should never touch here */
            break;
80005052:	0001                	nop

80005054 <.L89>:
        }
    }

    return copy_words;
80005054:	47f2                	lw	a5,28(sp)
80005056:	0ff7f793          	zext.b	a5,a5
}
8000505a:	853e                	mv	a0,a5
8000505c:	6105                	add	sp,sp,32
8000505e:	8082                	ret

Disassembly of section .text.can_init:

80005060 <can_init>:

    return status;
}

hpm_stat_t can_init(CAN_Type *base, can_config_t *config, uint32_t src_clk_freq)
{
80005060:	715d                	add	sp,sp,-80
80005062:	c686                	sw	ra,76(sp)
80005064:	c62a                	sw	a0,12(sp)
80005066:	c42e                	sw	a1,8(sp)
80005068:	c232                	sw	a2,4(sp)
    hpm_stat_t status = status_invalid_argument;
8000506a:	4789                	li	a5,2
8000506c:	de3e                	sw	a5,60(sp)

8000506e <.LBB16>:

    do {

        HPM_BREAK_IF((base == NULL) || (config == NULL) || (src_clk_freq == 0U) || (config->filter_list_num > 16U));
8000506e:	47b2                	lw	a5,12(sp)
80005070:	2a078663          	beqz	a5,8000531c <.L164>
80005074:	47a2                	lw	a5,8(sp)
80005076:	2a078363          	beqz	a5,8000531c <.L164>
8000507a:	4792                	lw	a5,4(sp)
8000507c:	2a078063          	beqz	a5,8000531c <.L164>
80005080:	47a2                	lw	a5,8(sp)
80005082:	0177c703          	lbu	a4,23(a5)
80005086:	47c1                	li	a5,16
80005088:	28e7ea63          	bltu	a5,a4,8000531c <.L164>

        can_reset(base, true);
8000508c:	4585                	li	a1,1
8000508e:	4532                	lw	a0,12(sp)
80005090:	7ce040ef          	jal	8000985e <can_reset>

        base->TTCFG &= ~CAN_TTCFG_TTEN_MASK;
80005094:	47b2                	lw	a5,12(sp)
80005096:	0bf7c783          	lbu	a5,191(a5)
8000509a:	0ff7f793          	zext.b	a5,a5
8000509e:	9bf9                	and	a5,a5,-2
800050a0:	0ff7f713          	zext.b	a4,a5
800050a4:	47b2                	lw	a5,12(sp)
800050a6:	0ae78fa3          	sb	a4,191(a5)
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TTTBM_MASK;
800050aa:	47b2                	lw	a5,12(sp)
800050ac:	0a07a703          	lw	a4,160(a5)
800050b0:	fff007b7          	lui	a5,0xfff00
800050b4:	17fd                	add	a5,a5,-1 # ffefffff <__APB_SRAM_segment_end__+0xbe0dfff>
800050b6:	8f7d                	and	a4,a4,a5
800050b8:	47b2                	lw	a5,12(sp)
800050ba:	0ae7a023          	sw	a4,160(a5)

        if (!config->use_lowlevel_timing_setting) {
800050be:	47a2                	lw	a5,8(sp)
800050c0:	0117c783          	lbu	a5,17(a5)
800050c4:	0017c793          	xor	a5,a5,1
800050c8:	0ff7f793          	zext.b	a5,a5
800050cc:	c3ad                	beqz	a5,8000512e <.L165>
            if (config->enable_canfd) {
800050ce:	47a2                	lw	a5,8(sp)
800050d0:	0127c783          	lbu	a5,18(a5)
800050d4:	cf9d                	beqz	a5,80005112 <.L166>
                status = can_set_bit_timing(base,
800050d6:	47a2                	lw	a5,8(sp)
800050d8:	4394                	lw	a3,0(a5)
800050da:	47a2                	lw	a5,8(sp)
800050dc:	0087d703          	lhu	a4,8(a5)
800050e0:	47a2                	lw	a5,8(sp)
800050e2:	00a7d783          	lhu	a5,10(a5)
800050e6:	4612                	lw	a2,4(sp)
800050e8:	4585                	li	a1,1
800050ea:	4532                	lw	a0,12(sp)
800050ec:	39dd                	jal	80004de2 <can_set_bit_timing>
800050ee:	de2a                	sw	a0,60(sp)
                                            can_bit_timing_canfd_nominal,
                                            src_clk_freq,
                                            config->baudrate,
                                            config->can20_samplepoint_min,
                                            config->can20_samplepoint_max);
                HPM_BREAK_IF(status != status_success);
800050f0:	57f2                	lw	a5,60(sp)
800050f2:	22079563          	bnez	a5,8000531c <.L164>
                status = can_set_bit_timing(base,
800050f6:	47a2                	lw	a5,8(sp)
800050f8:	43d4                	lw	a3,4(a5)
800050fa:	47a2                	lw	a5,8(sp)
800050fc:	00c7d703          	lhu	a4,12(a5)
80005100:	47a2                	lw	a5,8(sp)
80005102:	00e7d783          	lhu	a5,14(a5)
80005106:	4612                	lw	a2,4(sp)
80005108:	4589                	li	a1,2
8000510a:	4532                	lw	a0,12(sp)
8000510c:	39d9                	jal	80004de2 <can_set_bit_timing>
8000510e:	de2a                	sw	a0,60(sp)
80005110:	a86d                	j	800051ca <.L168>

80005112 <.L166>:
                                            src_clk_freq,
                                            config->baudrate_fd,
                                            config->canfd_samplepoint_min,
                                            config->canfd_samplepoint_max);
            } else {
                status = can_set_bit_timing(base,
80005112:	47a2                	lw	a5,8(sp)
80005114:	4394                	lw	a3,0(a5)
80005116:	47a2                	lw	a5,8(sp)
80005118:	0087d703          	lhu	a4,8(a5)
8000511c:	47a2                	lw	a5,8(sp)
8000511e:	00a7d783          	lhu	a5,10(a5)
80005122:	4612                	lw	a2,4(sp)
80005124:	4581                	li	a1,0
80005126:	4532                	lw	a0,12(sp)
80005128:	396d                	jal	80004de2 <can_set_bit_timing>
8000512a:	de2a                	sw	a0,60(sp)
8000512c:	a879                	j	800051ca <.L168>

8000512e <.L165>:
                                            config->baudrate,
                                            config->can20_samplepoint_min,
                                            config->can20_samplepoint_max);
            }
        } else {
            if (config->enable_canfd) {
8000512e:	47a2                	lw	a5,8(sp)
80005130:	0127c783          	lbu	a5,18(a5)
80005134:	c3bd                	beqz	a5,8000519a <.L169>

80005136 <.LBB17>:
                bool param_valid = is_can_bit_timing_param_valid(can_bit_timing_canfd_nominal, &config->can_timing);
80005136:	47a2                	lw	a5,8(sp)
80005138:	85be                	mv	a1,a5
8000513a:	4505                	li	a0,1
8000513c:	3111                	jal	80004d40 <is_can_bit_timing_param_valid>
8000513e:	87aa                	mv	a5,a0
80005140:	02f10723          	sb	a5,46(sp)
                if (!param_valid) {
80005144:	02e14783          	lbu	a5,46(sp)
80005148:	0017c793          	xor	a5,a5,1
8000514c:	0ff7f793          	zext.b	a5,a5
80005150:	c791                	beqz	a5,8000515c <.L170>
                    status = status_can_invalid_bit_timing;
80005152:	6795                	lui	a5,0x5
80005154:	a4178793          	add	a5,a5,-1471 # 4a41 <__HEAPSIZE__+0xa41>
80005158:	de3e                	sw	a5,60(sp)
                    break;
8000515a:	a2c9                	j	8000531c <.L164>

8000515c <.L170>:
                }
                param_valid = is_can_bit_timing_param_valid(can_bit_timing_canfd_data, &config->canfd_timing);
8000515c:	47a2                	lw	a5,8(sp)
8000515e:	07a1                	add	a5,a5,8
80005160:	85be                	mv	a1,a5
80005162:	4509                	li	a0,2
80005164:	3ef1                	jal	80004d40 <is_can_bit_timing_param_valid>
80005166:	87aa                	mv	a5,a0
80005168:	02f10723          	sb	a5,46(sp)
                if (!param_valid) {
8000516c:	02e14783          	lbu	a5,46(sp)
80005170:	0017c793          	xor	a5,a5,1
80005174:	0ff7f793          	zext.b	a5,a5
80005178:	c791                	beqz	a5,80005184 <.L171>
                    status = status_can_invalid_bit_timing;
8000517a:	6795                	lui	a5,0x5
8000517c:	a4178793          	add	a5,a5,-1471 # 4a41 <__HEAPSIZE__+0xa41>
80005180:	de3e                	sw	a5,60(sp)
                    break;
80005182:	aa69                	j	8000531c <.L164>

80005184 <.L171>:
                }
                can_set_slow_speed_timing(base, &config->can_timing);
80005184:	47a2                	lw	a5,8(sp)
80005186:	85be                	mv	a1,a5
80005188:	4532                	lw	a0,12(sp)
8000518a:	3685                	jal	80004cea <can_set_slow_speed_timing>
                can_set_fast_speed_timing(base, &config->canfd_timing);
8000518c:	47a2                	lw	a5,8(sp)
8000518e:	07a1                	add	a5,a5,8
80005190:	85be                	mv	a1,a5
80005192:	4532                	lw	a0,12(sp)
80005194:	013040ef          	jal	800099a6 <can_set_fast_speed_timing>

80005198 <.LBE17>:
80005198:	a805                	j	800051c8 <.L172>

8000519a <.L169>:
            } else {
                bool param_valid = is_can_bit_timing_param_valid(can_bit_timing_can2_0, &config->can_timing);
8000519a:	47a2                	lw	a5,8(sp)
8000519c:	85be                	mv	a1,a5
8000519e:	4501                	li	a0,0
800051a0:	3645                	jal	80004d40 <is_can_bit_timing_param_valid>
800051a2:	87aa                	mv	a5,a0
800051a4:	02f107a3          	sb	a5,47(sp)
                if (!param_valid) {
800051a8:	02f14783          	lbu	a5,47(sp)
800051ac:	0017c793          	xor	a5,a5,1
800051b0:	0ff7f793          	zext.b	a5,a5
800051b4:	c791                	beqz	a5,800051c0 <.L173>
                    status = status_can_invalid_bit_timing;
800051b6:	6795                	lui	a5,0x5
800051b8:	a4178793          	add	a5,a5,-1471 # 4a41 <__HEAPSIZE__+0xa41>
800051bc:	de3e                	sw	a5,60(sp)
                    break;
800051be:	aab9                	j	8000531c <.L164>

800051c0 <.L173>:
                }
                can_set_slow_speed_timing(base, &config->can_timing);
800051c0:	47a2                	lw	a5,8(sp)
800051c2:	85be                	mv	a1,a5
800051c4:	4532                	lw	a0,12(sp)
800051c6:	3615                	jal	80004cea <can_set_slow_speed_timing>

800051c8 <.L172>:
            }
            status = status_success;
800051c8:	de02                	sw	zero,60(sp)

800051ca <.L168>:
        }

        /* Enable Transmitter Delay Compensation as needed */
        uint32_t ssp_offset = CAN_F_PRESC_F_SEG_1_GET(base->F_PRESC) + 2U;
800051ca:	47b2                	lw	a5,12(sp)
800051cc:	0ac7a783          	lw	a5,172(a5)
800051d0:	8bbd                	and	a5,a5,15
800051d2:	0789                	add	a5,a5,2
800051d4:	d43e                	sw	a5,40(sp)
        can_set_transmitter_delay_compensation(base, ssp_offset, config->enable_tdc);
800051d6:	57a2                	lw	a5,40(sp)
800051d8:	0ff7f713          	zext.b	a4,a5
800051dc:	47a2                	lw	a5,8(sp)
800051de:	0167c783          	lbu	a5,22(a5)
800051e2:	863e                	mv	a2,a5
800051e4:	85ba                	mv	a1,a4
800051e6:	4532                	lw	a0,12(sp)
800051e8:	796040ef          	jal	8000997e <can_set_transmitter_delay_compensation>

        HPM_BREAK_IF(status != status_success);
800051ec:	57f2                	lw	a5,60(sp)
800051ee:	12079763          	bnez	a5,8000531c <.L164>


        /* Configure the CAN filters */
        if (config->filter_list_num > CAN_FILTER_NUM_MAX) {
800051f2:	47a2                	lw	a5,8(sp)
800051f4:	0177c703          	lbu	a4,23(a5)
800051f8:	47c1                	li	a5,16
800051fa:	00e7f763          	bgeu	a5,a4,80005208 <.L175>
            status = status_can_filter_num_invalid;
800051fe:	6795                	lui	a5,0x5
80005200:	a4078793          	add	a5,a5,-1472 # 4a40 <__HEAPSIZE__+0xa40>
80005204:	de3e                	sw	a5,60(sp)
            break;
80005206:	aa19                	j	8000531c <.L164>

80005208 <.L175>:
        } else if (config->filter_list_num == 0) {
80005208:	47a2                	lw	a5,8(sp)
8000520a:	0177c783          	lbu	a5,23(a5)
8000520e:	ef95                	bnez	a5,8000524a <.L176>

80005210 <.LBB19>:
            can_filter_config_t default_filter = CAN_DEFAULT_FILTER_SETTING;
80005210:	00011e23          	sh	zero,28(sp)
80005214:	00010f23          	sb	zero,30(sp)
80005218:	4785                	li	a5,1
8000521a:	00f10fa3          	sb	a5,31(sp)
8000521e:	d002                	sw	zero,32(sp)
80005220:	200007b7          	lui	a5,0x20000
80005224:	17fd                	add	a5,a5,-1 # 1fffffff <__SHARE_RAM_segment_end__+0x1ee7ffff>
80005226:	d23e                	sw	a5,36(sp)

80005228 <.LBB20>:
            for (uint32_t i = 0; i < CAN_FILTER_NUM_MAX; i++) {
80005228:	dc02                	sw	zero,56(sp)
8000522a:	a039                	j	80005238 <.L177>

8000522c <.L178>:
                can_disable_filter(base, i);
8000522c:	55e2                	lw	a1,56(sp)
8000522e:	4532                	lw	a0,12(sp)
80005230:	3441                	jal	80004cb0 <can_disable_filter>
            for (uint32_t i = 0; i < CAN_FILTER_NUM_MAX; i++) {
80005232:	57e2                	lw	a5,56(sp)
80005234:	0785                	add	a5,a5,1
80005236:	dc3e                	sw	a5,56(sp)

80005238 <.L177>:
80005238:	5762                	lw	a4,56(sp)
8000523a:	47bd                	li	a5,15
8000523c:	fee7f8e3          	bgeu	a5,a4,8000522c <.L178>

80005240 <.LBE20>:
            }
            (void) can_set_filter(base, &default_filter);
80005240:	087c                	add	a5,sp,28
80005242:	85be                	mv	a1,a5
80005244:	4532                	lw	a0,12(sp)
80005246:	39bd                	jal	80004ec4 <can_set_filter>

80005248 <.LBE19>:
80005248:	a889                	j	8000529a <.L179>

8000524a <.L176>:
        } else {
            for (uint32_t i = 0; i < CAN_FILTER_NUM_MAX; i++) {
8000524a:	da02                	sw	zero,52(sp)
8000524c:	a039                	j	8000525a <.L180>

8000524e <.L181>:
                can_disable_filter(base, i);
8000524e:	55d2                	lw	a1,52(sp)
80005250:	4532                	lw	a0,12(sp)
80005252:	3cb9                	jal	80004cb0 <can_disable_filter>
            for (uint32_t i = 0; i < CAN_FILTER_NUM_MAX; i++) {
80005254:	57d2                	lw	a5,52(sp)
80005256:	0785                	add	a5,a5,1
80005258:	da3e                	sw	a5,52(sp)

8000525a <.L180>:
8000525a:	5752                	lw	a4,52(sp)
8000525c:	47bd                	li	a5,15
8000525e:	fee7f8e3          	bgeu	a5,a4,8000524e <.L181>

80005262 <.LBB22>:
            }
            for (uint32_t i = 0; i < config->filter_list_num; i++) {
80005262:	d802                	sw	zero,48(sp)
80005264:	a025                	j	8000528c <.L182>

80005266 <.L185>:
                status = can_set_filter(base, &config->filter_list[i]);
80005266:	47a2                	lw	a5,8(sp)
80005268:	4f94                	lw	a3,24(a5)
8000526a:	5742                	lw	a4,48(sp)
8000526c:	87ba                	mv	a5,a4
8000526e:	0786                	sll	a5,a5,0x1
80005270:	97ba                	add	a5,a5,a4
80005272:	078a                	sll	a5,a5,0x2
80005274:	97b6                	add	a5,a5,a3
80005276:	85be                	mv	a1,a5
80005278:	4532                	lw	a0,12(sp)
8000527a:	31a9                	jal	80004ec4 <can_set_filter>
8000527c:	de2a                	sw	a0,60(sp)
                if (status != status_success) {
8000527e:	57f2                	lw	a5,60(sp)
80005280:	c399                	beqz	a5,80005286 <.L183>
                    return status;
80005282:	57f2                	lw	a5,60(sp)
80005284:	a869                	j	8000531e <.L184>

80005286 <.L183>:
            for (uint32_t i = 0; i < config->filter_list_num; i++) {
80005286:	57c2                	lw	a5,48(sp)
80005288:	0785                	add	a5,a5,1
8000528a:	d83e                	sw	a5,48(sp)

8000528c <.L182>:
8000528c:	47a2                	lw	a5,8(sp)
8000528e:	0177c783          	lbu	a5,23(a5)
80005292:	873e                	mv	a4,a5
80005294:	57c2                	lw	a5,48(sp)
80005296:	fce7e8e3          	bltu	a5,a4,80005266 <.L185>

8000529a <.L179>:
                }
            }
        }

        /* Set CAN FD standard */
        can_enable_can_fd_iso_mode(base, config->enable_can_fd_iso_mode);
8000529a:	47a2                	lw	a5,8(sp)
8000529c:	01f7c783          	lbu	a5,31(a5)
800052a0:	85be                	mv	a1,a5
800052a2:	4532                	lw	a0,12(sp)
800052a4:	3aad                	jal	80004c1e <can_enable_can_fd_iso_mode>

        can_reset(base, false);
800052a6:	4581                	li	a1,0
800052a8:	4532                	lw	a0,12(sp)
800052aa:	5b4040ef          	jal	8000985e <can_reset>

        /* The following mode must be set when the CAN controller is not in reset mode */

        /* Disable re-transmission on PTB on demand */
        can_disable_ptb_retransmission(base, config->disable_ptb_retransmission);
800052ae:	47a2                	lw	a5,8(sp)
800052b0:	0147c783          	lbu	a5,20(a5)
800052b4:	85be                	mv	a1,a5
800052b6:	4532                	lw	a0,12(sp)
800052b8:	5de040ef          	jal	80009896 <can_disable_ptb_retransmission>
        /* Disable re-transmission on STB on demand */
        can_disable_stb_retransmission(base, config->disable_stb_retransmission);
800052bc:	47a2                	lw	a5,8(sp)
800052be:	0157c783          	lbu	a5,21(a5)
800052c2:	85be                	mv	a1,a5
800052c4:	4532                	lw	a0,12(sp)
800052c6:	608040ef          	jal	800098ce <can_disable_stb_retransmission>

        /* Set Self-ack mode*/
        can_enable_self_ack(base, config->enable_self_ack);
800052ca:	47a2                	lw	a5,8(sp)
800052cc:	0137c783          	lbu	a5,19(a5)
800052d0:	85be                	mv	a1,a5
800052d2:	4532                	lw	a0,12(sp)
800052d4:	3231                	jal	80004be0 <can_enable_self_ack>

        /* Set CAN work mode */
        can_set_node_mode(base, config->mode);
800052d6:	47a2                	lw	a5,8(sp)
800052d8:	0107c783          	lbu	a5,16(a5)
800052dc:	85be                	mv	a1,a5
800052de:	4532                	lw	a0,12(sp)
800052e0:	3085                	jal	80004b40 <can_set_node_mode>

        /* Configure TX Buffer priority mode */
        can_select_tx_buffer_priority_mode(base, config->enable_tx_buffer_priority_mode);
800052e2:	47a2                	lw	a5,8(sp)
800052e4:	01e7c783          	lbu	a5,30(a5)
800052e8:	85be                	mv	a1,a5
800052ea:	4532                	lw	a0,12(sp)
800052ec:	385d                	jal	80004ba2 <can_select_tx_buffer_priority_mode>

        /* Configure interrupt */
        can_disable_tx_rx_irq(base, 0xFFU);
800052ee:	0ff00593          	li	a1,255
800052f2:	4532                	lw	a0,12(sp)
800052f4:	612040ef          	jal	80009906 <can_disable_tx_rx_irq>
        can_disable_error_irq(base, 0xFFU);
800052f8:	0ff00593          	li	a1,255
800052fc:	4532                	lw	a0,12(sp)
800052fe:	644040ef          	jal	80009942 <can_disable_error_irq>
        can_enable_tx_rx_irq(base, config->irq_txrx_enable_mask);
80005302:	47a2                	lw	a5,8(sp)
80005304:	01c7c783          	lbu	a5,28(a5)
80005308:	85be                	mv	a1,a5
8000530a:	4532                	lw	a0,12(sp)
8000530c:	3a81                	jal	80004c5c <can_enable_tx_rx_irq>
        can_enable_error_irq(base, config->irq_error_enable_mask);
8000530e:	47a2                	lw	a5,8(sp)
80005310:	01d7c783          	lbu	a5,29(a5)
80005314:	85be                	mv	a1,a5
80005316:	4532                	lw	a0,12(sp)
80005318:	32bd                	jal	80004c86 <can_enable_error_irq>

        status = status_success;
8000531a:	de02                	sw	zero,60(sp)

8000531c <.L164>:
    } while (false);

    return status;
8000531c:	57f2                	lw	a5,60(sp)

8000531e <.L184>:
}
8000531e:	853e                	mv	a0,a5
80005320:	40b6                	lw	ra,76(sp)
80005322:	6161                	add	sp,sp,80
80005324:	8082                	ret

Disassembly of section .text.can_deinit:

80005326 <can_deinit>:

void can_deinit(CAN_Type *base)
{
80005326:	1101                	add	sp,sp,-32
80005328:	ce06                	sw	ra,28(sp)
8000532a:	c62a                	sw	a0,12(sp)
    do {
        HPM_BREAK_IF(base == NULL);
8000532c:	47b2                	lw	a5,12(sp)
8000532e:	cb89                	beqz	a5,80005340 <.L188>
        can_force_bus_off(base);
80005330:	4532                	lw	a0,12(sp)
80005332:	c00ff0ef          	jal	80004732 <can_force_bus_off>
        can_reset(base, true);
80005336:	4585                	li	a1,1
80005338:	4532                	lw	a0,12(sp)
8000533a:	524040ef          	jal	8000985e <can_reset>
    } while (false);
8000533e:	0001                	nop

80005340 <.L188>:
80005340:	0001                	nop
80005342:	40f2                	lw	ra,28(sp)
80005344:	6105                	add	sp,sp,32
80005346:	8082                	ret

Disassembly of section .text.pllctl_pll_poweron:

80005348 <pllctl_pll_poweron>:
 * @param[in] pll Target PLL index
 *
 * @return status_success if everything is okay
 */
static inline hpm_stat_t pllctl_pll_poweron(PLLCTL_Type *ptr, uint8_t pll)
{
80005348:	1101                	add	sp,sp,-32
8000534a:	c62a                	sw	a0,12(sp)
8000534c:	87ae                	mv	a5,a1
8000534e:	00f105a3          	sb	a5,11(sp)
    uint32_t cfg;
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
80005352:	00b14703          	lbu	a4,11(sp)
80005356:	4791                	li	a5,4
80005358:	00e7f463          	bgeu	a5,a4,80005360 <.L8>
        return status_invalid_argument;
8000535c:	4789                	li	a5,2
8000535e:	a849                	j	800053f0 <.L9>

80005360 <.L8>:
    }

    cfg = ptr->PLL[pll].CFG1;
80005360:	00b14783          	lbu	a5,11(sp)
80005364:	4732                	lw	a4,12(sp)
80005366:	0785                	add	a5,a5,1
80005368:	079e                	sll	a5,a5,0x7
8000536a:	97ba                	add	a5,a5,a4
8000536c:	43dc                	lw	a5,4(a5)
8000536e:	ce3e                	sw	a5,28(sp)
    if (!(cfg & PLLCTL_PLL_CFG1_PLLPD_SW_MASK)) {
80005370:	4772                	lw	a4,28(sp)
80005372:	020007b7          	lui	a5,0x2000
80005376:	8ff9                	and	a5,a5,a4
80005378:	e399                	bnez	a5,8000537e <.L10>
        return status_success;
8000537a:	4781                	li	a5,0
8000537c:	a895                	j	800053f0 <.L9>

8000537e <.L10>:
    }

    if (cfg & PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK) {
8000537e:	47f2                	lw	a5,28(sp)
80005380:	0207d463          	bgez	a5,800053a8 <.L11>
        ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
80005384:	00b14783          	lbu	a5,11(sp)
80005388:	4732                	lw	a4,12(sp)
8000538a:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
8000538c:	079e                	sll	a5,a5,0x7
8000538e:	97ba                	add	a5,a5,a4
80005390:	43d4                	lw	a3,4(a5)
80005392:	00b14783          	lbu	a5,11(sp)
80005396:	80000737          	lui	a4,0x80000
8000539a:	177d                	add	a4,a4,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
8000539c:	8f75                	and	a4,a4,a3
8000539e:	46b2                	lw	a3,12(sp)
800053a0:	0785                	add	a5,a5,1
800053a2:	079e                	sll	a5,a5,0x7
800053a4:	97b6                	add	a5,a5,a3
800053a6:	c3d8                	sw	a4,4(a5)

800053a8 <.L11>:
    }

    ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
800053a8:	00b14783          	lbu	a5,11(sp)
800053ac:	4732                	lw	a4,12(sp)
800053ae:	0785                	add	a5,a5,1
800053b0:	079e                	sll	a5,a5,0x7
800053b2:	97ba                	add	a5,a5,a4
800053b4:	43d4                	lw	a3,4(a5)
800053b6:	00b14783          	lbu	a5,11(sp)
800053ba:	fe000737          	lui	a4,0xfe000
800053be:	177d                	add	a4,a4,-1 # fdffffff <__APB_SRAM_segment_end__+0x9f0dfff>
800053c0:	8f75                	and	a4,a4,a3
800053c2:	46b2                	lw	a3,12(sp)
800053c4:	0785                	add	a5,a5,1
800053c6:	079e                	sll	a5,a5,0x7
800053c8:	97b6                	add	a5,a5,a3
800053ca:	c3d8                	sw	a4,4(a5)

    /*
     * put back to hardware mode
     */
    ptr->PLL[pll].CFG1 |= PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
800053cc:	00b14783          	lbu	a5,11(sp)
800053d0:	4732                	lw	a4,12(sp)
800053d2:	0785                	add	a5,a5,1
800053d4:	079e                	sll	a5,a5,0x7
800053d6:	97ba                	add	a5,a5,a4
800053d8:	43d4                	lw	a3,4(a5)
800053da:	00b14783          	lbu	a5,11(sp)
800053de:	80000737          	lui	a4,0x80000
800053e2:	8f55                	or	a4,a4,a3
800053e4:	46b2                	lw	a3,12(sp)
800053e6:	0785                	add	a5,a5,1
800053e8:	079e                	sll	a5,a5,0x7
800053ea:	97b6                	add	a5,a5,a3
800053ec:	c3d8                	sw	a4,4(a5)
    return status_success;
800053ee:	4781                	li	a5,0

800053f0 <.L9>:
}
800053f0:	853e                	mv	a0,a5
800053f2:	6105                	add	sp,sp,32
800053f4:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

800053f6 <read_pmp_cfg>:
 */
#include "hpm_pmp_drv.h"
#include "hpm_csr_drv.h"

uint32_t read_pmp_cfg(uint32_t idx)
{
800053f6:	7179                	add	sp,sp,-48
800053f8:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
800053fa:	d602                	sw	zero,44(sp)
    switch (idx) {
800053fc:	4732                	lw	a4,12(sp)
800053fe:	478d                	li	a5,3
80005400:	04f70763          	beq	a4,a5,8000544e <.L2>
80005404:	4732                	lw	a4,12(sp)
80005406:	478d                	li	a5,3
80005408:	04e7e963          	bltu	a5,a4,8000545a <.L9>
8000540c:	4732                	lw	a4,12(sp)
8000540e:	4789                	li	a5,2
80005410:	02f70963          	beq	a4,a5,80005442 <.L4>
80005414:	4732                	lw	a4,12(sp)
80005416:	4789                	li	a5,2
80005418:	04e7e163          	bltu	a5,a4,8000545a <.L9>
8000541c:	47b2                	lw	a5,12(sp)
8000541e:	c791                	beqz	a5,8000542a <.L5>
80005420:	4732                	lw	a4,12(sp)
80005422:	4785                	li	a5,1
80005424:	00f70963          	beq	a4,a5,80005436 <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
80005428:	a80d                	j	8000545a <.L9>

8000542a <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
8000542a:	3a0027f3          	csrr	a5,pmpcfg0
8000542e:	ce3e                	sw	a5,28(sp)
80005430:	47f2                	lw	a5,28(sp)

80005432 <.LBE2>:
80005432:	d63e                	sw	a5,44(sp)
        break;
80005434:	a025                	j	8000545c <.L7>

80005436 <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
80005436:	3a1027f3          	csrr	a5,pmpcfg1
8000543a:	d03e                	sw	a5,32(sp)
8000543c:	5782                	lw	a5,32(sp)

8000543e <.LBE3>:
8000543e:	d63e                	sw	a5,44(sp)
        break;
80005440:	a831                	j	8000545c <.L7>

80005442 <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
80005442:	3a2027f3          	csrr	a5,pmpcfg2
80005446:	d23e                	sw	a5,36(sp)
80005448:	5792                	lw	a5,36(sp)

8000544a <.LBE4>:
8000544a:	d63e                	sw	a5,44(sp)
        break;
8000544c:	a801                	j	8000545c <.L7>

8000544e <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
8000544e:	3a3027f3          	csrr	a5,pmpcfg3
80005452:	d43e                	sw	a5,40(sp)
80005454:	57a2                	lw	a5,40(sp)

80005456 <.LBE5>:
80005456:	d63e                	sw	a5,44(sp)
        break;
80005458:	a011                	j	8000545c <.L7>

8000545a <.L9>:
        break;
8000545a:	0001                	nop

8000545c <.L7>:
    }
    return pmp_cfg;
8000545c:	57b2                	lw	a5,44(sp)
}
8000545e:	853e                	mv	a0,a5
80005460:	6145                	add	sp,sp,48
80005462:	8082                	ret

Disassembly of section .text.write_pmp_addr:

80005464 <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
80005464:	1141                	add	sp,sp,-16
80005466:	c62a                	sw	a0,12(sp)
80005468:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000546a:	4722                	lw	a4,8(sp)
8000546c:	47bd                	li	a5,15
8000546e:	08e7ec63          	bltu	a5,a4,80005506 <.L38>
80005472:	47a2                	lw	a5,8(sp)
80005474:	00279713          	sll	a4,a5,0x2
80005478:	800037b7          	lui	a5,0x80003
8000547c:	1e078793          	add	a5,a5,480 # 800031e0 <.L21>
80005480:	97ba                	add	a5,a5,a4
80005482:	439c                	lw	a5,0(a5)
80005484:	8782                	jr	a5

80005486 <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
80005486:	47b2                	lw	a5,12(sp)
80005488:	3b079073          	csrw	pmpaddr0,a5
        break;
8000548c:	a8b5                	j	80005508 <.L37>

8000548e <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
8000548e:	47b2                	lw	a5,12(sp)
80005490:	3b179073          	csrw	pmpaddr1,a5
        break;
80005494:	a895                	j	80005508 <.L37>

80005496 <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
80005496:	47b2                	lw	a5,12(sp)
80005498:	3b279073          	csrw	pmpaddr2,a5
        break;
8000549c:	a0b5                	j	80005508 <.L37>

8000549e <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
8000549e:	47b2                	lw	a5,12(sp)
800054a0:	3b379073          	csrw	pmpaddr3,a5
        break;
800054a4:	a095                	j	80005508 <.L37>

800054a6 <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
800054a6:	47b2                	lw	a5,12(sp)
800054a8:	3b479073          	csrw	pmpaddr4,a5
        break;
800054ac:	a8b1                	j	80005508 <.L37>

800054ae <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
800054ae:	47b2                	lw	a5,12(sp)
800054b0:	3b579073          	csrw	pmpaddr5,a5
        break;
800054b4:	a891                	j	80005508 <.L37>

800054b6 <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
800054b6:	47b2                	lw	a5,12(sp)
800054b8:	3b679073          	csrw	pmpaddr6,a5
        break;
800054bc:	a0b1                	j	80005508 <.L37>

800054be <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
800054be:	47b2                	lw	a5,12(sp)
800054c0:	3b779073          	csrw	pmpaddr7,a5
        break;
800054c4:	a091                	j	80005508 <.L37>

800054c6 <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
800054c6:	47b2                	lw	a5,12(sp)
800054c8:	3b879073          	csrw	pmpaddr8,a5
        break;
800054cc:	a835                	j	80005508 <.L37>

800054ce <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
800054ce:	47b2                	lw	a5,12(sp)
800054d0:	3b979073          	csrw	pmpaddr9,a5
        break;
800054d4:	a815                	j	80005508 <.L37>

800054d6 <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
800054d6:	47b2                	lw	a5,12(sp)
800054d8:	3ba79073          	csrw	pmpaddr10,a5
        break;
800054dc:	a035                	j	80005508 <.L37>

800054de <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
800054de:	47b2                	lw	a5,12(sp)
800054e0:	3bb79073          	csrw	pmpaddr11,a5
        break;
800054e4:	a015                	j	80005508 <.L37>

800054e6 <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
800054e6:	47b2                	lw	a5,12(sp)
800054e8:	3bc79073          	csrw	pmpaddr12,a5
        break;
800054ec:	a831                	j	80005508 <.L37>

800054ee <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
800054ee:	47b2                	lw	a5,12(sp)
800054f0:	3bd79073          	csrw	pmpaddr13,a5
        break;
800054f4:	a811                	j	80005508 <.L37>

800054f6 <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
800054f6:	47b2                	lw	a5,12(sp)
800054f8:	3be79073          	csrw	pmpaddr14,a5
        break;
800054fc:	a031                	j	80005508 <.L37>

800054fe <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
800054fe:	47b2                	lw	a5,12(sp)
80005500:	3bf79073          	csrw	pmpaddr15,a5
        break;
80005504:	a011                	j	80005508 <.L37>

80005506 <.L38>:
    default:
        /* Do nothing */
        break;
80005506:	0001                	nop

80005508 <.L37>:
    }
}
80005508:	0001                	nop
8000550a:	0141                	add	sp,sp,16
8000550c:	8082                	ret

Disassembly of section .text.read_pma_cfg:

8000550e <read_pma_cfg>:
    return ret_val;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
8000550e:	7179                	add	sp,sp,-48
80005510:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
80005512:	d602                	sw	zero,44(sp)
    switch (idx) {
80005514:	4732                	lw	a4,12(sp)
80005516:	478d                	li	a5,3
80005518:	04f70763          	beq	a4,a5,80005566 <.L62>
8000551c:	4732                	lw	a4,12(sp)
8000551e:	478d                	li	a5,3
80005520:	04e7e963          	bltu	a5,a4,80005572 <.L69>
80005524:	4732                	lw	a4,12(sp)
80005526:	4789                	li	a5,2
80005528:	02f70963          	beq	a4,a5,8000555a <.L64>
8000552c:	4732                	lw	a4,12(sp)
8000552e:	4789                	li	a5,2
80005530:	04e7e163          	bltu	a5,a4,80005572 <.L69>
80005534:	47b2                	lw	a5,12(sp)
80005536:	c791                	beqz	a5,80005542 <.L65>
80005538:	4732                	lw	a4,12(sp)
8000553a:	4785                	li	a5,1
8000553c:	00f70963          	beq	a4,a5,8000554e <.L66>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
80005540:	a80d                	j	80005572 <.L69>

80005542 <.L65>:
        pma_cfg = read_csr(CSR_PMACFG0);
80005542:	bc0027f3          	csrr	a5,0xbc0
80005546:	ce3e                	sw	a5,28(sp)
80005548:	47f2                	lw	a5,28(sp)

8000554a <.LBE22>:
8000554a:	d63e                	sw	a5,44(sp)
        break;
8000554c:	a025                	j	80005574 <.L67>

8000554e <.L66>:
        pma_cfg = read_csr(CSR_PMACFG1);
8000554e:	bc1027f3          	csrr	a5,0xbc1
80005552:	d03e                	sw	a5,32(sp)
80005554:	5782                	lw	a5,32(sp)

80005556 <.LBE23>:
80005556:	d63e                	sw	a5,44(sp)
        break;
80005558:	a831                	j	80005574 <.L67>

8000555a <.L64>:
        pma_cfg = read_csr(CSR_PMACFG2);
8000555a:	bc2027f3          	csrr	a5,0xbc2
8000555e:	d23e                	sw	a5,36(sp)
80005560:	5792                	lw	a5,36(sp)

80005562 <.LBE24>:
80005562:	d63e                	sw	a5,44(sp)
        break;
80005564:	a801                	j	80005574 <.L67>

80005566 <.L62>:
        pma_cfg = read_csr(CSR_PMACFG3);
80005566:	bc3027f3          	csrr	a5,0xbc3
8000556a:	d43e                	sw	a5,40(sp)
8000556c:	57a2                	lw	a5,40(sp)

8000556e <.LBE25>:
8000556e:	d63e                	sw	a5,44(sp)
        break;
80005570:	a011                	j	80005574 <.L67>

80005572 <.L69>:
        break;
80005572:	0001                	nop

80005574 <.L67>:
    }
    return pma_cfg;
80005574:	57b2                	lw	a5,44(sp)
}
80005576:	853e                	mv	a0,a5
80005578:	6145                	add	sp,sp,48
8000557a:	8082                	ret

Disassembly of section .text.write_pma_addr:

8000557c <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
8000557c:	1141                	add	sp,sp,-16
8000557e:	c62a                	sw	a0,12(sp)
80005580:	c42e                	sw	a1,8(sp)
    switch (idx) {
80005582:	4722                	lw	a4,8(sp)
80005584:	47bd                	li	a5,15
80005586:	08e7ec63          	bltu	a5,a4,8000561e <.L98>
8000558a:	47a2                	lw	a5,8(sp)
8000558c:	00279713          	sll	a4,a5,0x2
80005590:	800037b7          	lui	a5,0x80003
80005594:	22078793          	add	a5,a5,544 # 80003220 <.L81>
80005598:	97ba                	add	a5,a5,a4
8000559a:	439c                	lw	a5,0(a5)
8000559c:	8782                	jr	a5

8000559e <.L96>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
8000559e:	47b2                	lw	a5,12(sp)
800055a0:	bd079073          	csrw	0xbd0,a5
        break;
800055a4:	a8b5                	j	80005620 <.L97>

800055a6 <.L95>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
800055a6:	47b2                	lw	a5,12(sp)
800055a8:	bd179073          	csrw	0xbd1,a5
        break;
800055ac:	a895                	j	80005620 <.L97>

800055ae <.L94>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
800055ae:	47b2                	lw	a5,12(sp)
800055b0:	bd279073          	csrw	0xbd2,a5
        break;
800055b4:	a0b5                	j	80005620 <.L97>

800055b6 <.L93>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
800055b6:	47b2                	lw	a5,12(sp)
800055b8:	bd379073          	csrw	0xbd3,a5
        break;
800055bc:	a095                	j	80005620 <.L97>

800055be <.L92>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
800055be:	47b2                	lw	a5,12(sp)
800055c0:	bd479073          	csrw	0xbd4,a5
        break;
800055c4:	a8b1                	j	80005620 <.L97>

800055c6 <.L91>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
800055c6:	47b2                	lw	a5,12(sp)
800055c8:	bd579073          	csrw	0xbd5,a5
        break;
800055cc:	a891                	j	80005620 <.L97>

800055ce <.L90>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
800055ce:	47b2                	lw	a5,12(sp)
800055d0:	bd679073          	csrw	0xbd6,a5
        break;
800055d4:	a0b1                	j	80005620 <.L97>

800055d6 <.L89>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
800055d6:	47b2                	lw	a5,12(sp)
800055d8:	bd779073          	csrw	0xbd7,a5
        break;
800055dc:	a091                	j	80005620 <.L97>

800055de <.L88>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
800055de:	47b2                	lw	a5,12(sp)
800055e0:	bd879073          	csrw	0xbd8,a5
        break;
800055e4:	a835                	j	80005620 <.L97>

800055e6 <.L87>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
800055e6:	47b2                	lw	a5,12(sp)
800055e8:	bd979073          	csrw	0xbd9,a5
        break;
800055ec:	a815                	j	80005620 <.L97>

800055ee <.L86>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
800055ee:	47b2                	lw	a5,12(sp)
800055f0:	bda79073          	csrw	0xbda,a5
        break;
800055f4:	a035                	j	80005620 <.L97>

800055f6 <.L85>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
800055f6:	47b2                	lw	a5,12(sp)
800055f8:	bdb79073          	csrw	0xbdb,a5
        break;
800055fc:	a015                	j	80005620 <.L97>

800055fe <.L84>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
800055fe:	47b2                	lw	a5,12(sp)
80005600:	bdc79073          	csrw	0xbdc,a5
        break;
80005604:	a831                	j	80005620 <.L97>

80005606 <.L83>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
80005606:	47b2                	lw	a5,12(sp)
80005608:	bdd79073          	csrw	0xbdd,a5
        break;
8000560c:	a811                	j	80005620 <.L97>

8000560e <.L82>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
8000560e:	47b2                	lw	a5,12(sp)
80005610:	bde79073          	csrw	0xbde,a5
        break;
80005614:	a031                	j	80005620 <.L97>

80005616 <.L80>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
80005616:	47b2                	lw	a5,12(sp)
80005618:	bdf79073          	csrw	0xbdf,a5
        break;
8000561c:	a011                	j	80005620 <.L97>

8000561e <.L98>:
    default:
        /* Do nothing */
        break;
8000561e:	0001                	nop

80005620 <.L97>:
    }
}
80005620:	0001                	nop
80005622:	0141                	add	sp,sp,16
80005624:	8082                	ret

Disassembly of section .text.pmp_config:

80005626 <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
80005626:	7139                	add	sp,sp,-64
80005628:	de06                	sw	ra,60(sp)
8000562a:	c62a                	sw	a0,12(sp)
8000562c:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
8000562e:	4789                	li	a5,2
80005630:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > 15U));
80005632:	47b2                	lw	a5,12(sp)
80005634:	cfcd                	beqz	a5,800056ee <.L125>
80005636:	47a2                	lw	a5,8(sp)
80005638:	cbdd                	beqz	a5,800056ee <.L125>
8000563a:	4722                	lw	a4,8(sp)
8000563c:	47bd                	li	a5,15
8000563e:	0ae7e863          	bltu	a5,a4,800056ee <.L125>

80005642 <.LBB43>:

        for (uint32_t i = 0; i < num_of_entries; i++) {
80005642:	d402                	sw	zero,40(sp)
80005644:	a871                	j	800056e0 <.L126>

80005646 <.L127>:
            uint32_t idx = i / 4;
80005646:	57a2                	lw	a5,40(sp)
80005648:	8389                	srl	a5,a5,0x2
8000564a:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
8000564c:	57a2                	lw	a5,40(sp)
8000564e:	078e                	sll	a5,a5,0x3
80005650:	8be1                	and	a5,a5,24
80005652:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
80005654:	5512                	lw	a0,36(sp)
80005656:	3345                	jal	800053f6 <read_pmp_cfg>
80005658:	ce2a                	sw	a0,28(sp)
            pmp_cfg &= ~(0xFFUL << offset);
8000565a:	5782                	lw	a5,32(sp)
8000565c:	0ff00713          	li	a4,255
80005660:	00f717b3          	sll	a5,a4,a5
80005664:	fff7c793          	not	a5,a5
80005668:	4772                	lw	a4,28(sp)
8000566a:	8ff9                	and	a5,a5,a4
8000566c:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t) entry->pmp_cfg.val) << offset;
8000566e:	47b2                	lw	a5,12(sp)
80005670:	0007c783          	lbu	a5,0(a5)
80005674:	873e                	mv	a4,a5
80005676:	5782                	lw	a5,32(sp)
80005678:	00f717b3          	sll	a5,a4,a5
8000567c:	4772                	lw	a4,28(sp)
8000567e:	8fd9                	or	a5,a5,a4
80005680:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
80005682:	47b2                	lw	a5,12(sp)
80005684:	43dc                	lw	a5,4(a5)
80005686:	55a2                	lw	a1,40(sp)
80005688:	853e                	mv	a0,a5
8000568a:	3be9                	jal	80005464 <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
8000568c:	5592                	lw	a1,36(sp)
8000568e:	4572                	lw	a0,28(sp)
80005690:	4af040ef          	jal	8000a33e <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
80005694:	5512                	lw	a0,36(sp)
80005696:	3da5                	jal	8000550e <read_pma_cfg>
80005698:	cc2a                	sw	a0,24(sp)
            pma_cfg &= ~(0xFFUL << offset);
8000569a:	5782                	lw	a5,32(sp)
8000569c:	0ff00713          	li	a4,255
800056a0:	00f717b3          	sll	a5,a4,a5
800056a4:	fff7c793          	not	a5,a5
800056a8:	4762                	lw	a4,24(sp)
800056aa:	8ff9                	and	a5,a5,a4
800056ac:	cc3e                	sw	a5,24(sp)
            pma_cfg |= ((uint32_t) entry->pma_cfg.val) << offset;
800056ae:	47b2                	lw	a5,12(sp)
800056b0:	0087c783          	lbu	a5,8(a5)
800056b4:	873e                	mv	a4,a5
800056b6:	5782                	lw	a5,32(sp)
800056b8:	00f717b3          	sll	a5,a4,a5
800056bc:	4762                	lw	a4,24(sp)
800056be:	8fd9                	or	a5,a5,a4
800056c0:	cc3e                	sw	a5,24(sp)
            write_pma_cfg(pma_cfg, idx);
800056c2:	5592                	lw	a1,36(sp)
800056c4:	4562                	lw	a0,24(sp)
800056c6:	4d5040ef          	jal	8000a39a <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
800056ca:	47b2                	lw	a5,12(sp)
800056cc:	47dc                	lw	a5,12(a5)
800056ce:	55a2                	lw	a1,40(sp)
800056d0:	853e                	mv	a0,a5
800056d2:	356d                	jal	8000557c <write_pma_addr>
#endif
            ++entry;
800056d4:	47b2                	lw	a5,12(sp)
800056d6:	07c1                	add	a5,a5,16
800056d8:	c63e                	sw	a5,12(sp)

800056da <.LBE44>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
800056da:	57a2                	lw	a5,40(sp)
800056dc:	0785                	add	a5,a5,1
800056de:	d43e                	sw	a5,40(sp)

800056e0 <.L126>:
800056e0:	5722                	lw	a4,40(sp)
800056e2:	47a2                	lw	a5,8(sp)
800056e4:	f6f761e3          	bltu	a4,a5,80005646 <.L127>

800056e8 <.LBE43>:
        }
        fencei();
800056e8:	0000100f          	fence.i

        status = status_success;
800056ec:	d602                	sw	zero,44(sp)

800056ee <.L125>:

    } while (false);

    return status;
800056ee:	57b2                	lw	a5,44(sp)
}
800056f0:	853e                	mv	a0,a5
800056f2:	50f2                	lw	ra,60(sp)
800056f4:	6121                	add	sp,sp,64
800056f6:	8082                	ret

Disassembly of section .text.uart_default_config:

800056f8 <uart_default_config>:
#ifndef UART_SOC_OVERSAMPLE_MAX
#define UART_SOC_OVERSAMPLE_MAX HPM_UART_OSC_MAX
#endif

void uart_default_config(UART_Type *ptr, uart_config_t *config)
{
800056f8:	1141                	add	sp,sp,-16
800056fa:	c62a                	sw	a0,12(sp)
800056fc:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->baudrate = 115200;
800056fe:	47a2                	lw	a5,8(sp)
80005700:	6771                	lui	a4,0x1c
80005702:	20070713          	add	a4,a4,512 # 1c200 <__XPI0_segment_used_size__+0xf5c8>
80005706:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80005708:	47a2                	lw	a5,8(sp)
8000570a:	470d                	li	a4,3
8000570c:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
80005710:	47a2                	lw	a5,8(sp)
80005712:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80005716:	47a2                	lw	a5,8(sp)
80005718:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
8000571c:	47a2                	lw	a5,8(sp)
8000571e:	4705                	li	a4,1
80005720:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
80005724:	47a2                	lw	a5,8(sp)
80005726:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
8000572a:	47a2                	lw	a5,8(sp)
8000572c:	000785a3          	sb	zero,11(a5)
    config->dma_enable = false;
80005730:	47a2                	lw	a5,8(sp)
80005732:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
80005736:	47a2                	lw	a5,8(sp)
80005738:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
8000573c:	47a2                	lw	a5,8(sp)
8000573e:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
80005742:	47a2                	lw	a5,8(sp)
80005744:	000788a3          	sb	zero,17(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
#endif
#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    config->rx_enable = true;
#endif
}
80005748:	0001                	nop
8000574a:	0141                	add	sp,sp,16
8000574c:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

8000574e <uart_calculate_baudrate>:

static bool uart_calculate_baudrate(uint32_t freq, uint32_t baudrate, uint16_t *div_out, uint8_t *osc_out)
{
8000574e:	7179                	add	sp,sp,-48
80005750:	d606                	sw	ra,44(sp)
80005752:	d422                	sw	s0,40(sp)
80005754:	c62a                	sw	a0,12(sp)
80005756:	c42e                	sw	a1,8(sp)
80005758:	c232                	sw	a2,4(sp)
8000575a:	c036                	sw	a3,0(sp)
    uint16_t div, osc, delta;
    float tmp;
    if ((div_out == NULL) || (!freq) || (!baudrate)
8000575c:	4792                	lw	a5,4(sp)
8000575e:	cb85                	beqz	a5,8000578e <.L4>
80005760:	47b2                	lw	a5,12(sp)
80005762:	c795                	beqz	a5,8000578e <.L4>
80005764:	47a2                	lw	a5,8(sp)
80005766:	c785                	beqz	a5,8000578e <.L4>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
80005768:	4722                	lw	a4,8(sp)
8000576a:	0c700793          	li	a5,199
8000576e:	02e7f063          	bgeu	a5,a4,8000578e <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
80005772:	47a2                	lw	a5,8(sp)
80005774:	078e                	sll	a5,a5,0x3
80005776:	4732                	lw	a4,12(sp)
80005778:	00f76b63          	bltu	a4,a5,8000578e <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
8000577c:	4732                	lw	a4,12(sp)
8000577e:	67c1                	lui	a5,0x10
80005780:	17fd                	add	a5,a5,-1 # ffff <__XPI0_segment_used_size__+0x33c7>
80005782:	02f75733          	divu	a4,a4,a5
80005786:	47a2                	lw	a5,8(sp)
80005788:	0796                	sll	a5,a5,0x5
8000578a:	00e7f463          	bgeu	a5,a4,80005792 <.L5>

8000578e <.L4>:
        return 0;
8000578e:	4781                	li	a5,0
80005790:	aa8d                	j	80005902 <.L6>

80005792 <.L5>:
    }

    tmp = (float) freq / baudrate;
80005792:	4532                	lw	a0,12(sp)
80005794:	7e3020ef          	jal	80008776 <__floatunsisf>
80005798:	842a                	mv	s0,a0
8000579a:	4522                	lw	a0,8(sp)
8000579c:	7db020ef          	jal	80008776 <__floatunsisf>
800057a0:	87aa                	mv	a5,a0
800057a2:	85be                	mv	a1,a5
800057a4:	8522                	mv	a0,s0
800057a6:	1bc070ef          	jal	8000c962 <__divsf3>
800057aa:	87aa                	mv	a5,a0
800057ac:	cc3e                	sw	a5,24(sp)

    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
800057ae:	47a1                	li	a5,8
800057b0:	00f11f23          	sh	a5,30(sp)
800057b4:	a281                	j	800058f4 <.L7>

800057b6 <.L18>:
        /* osc range: HPM_UART_OSC_MIN - UART_SOC_OVERSAMPLE_MAX, even number */
        delta = 0;
800057b6:	00011e23          	sh	zero,28(sp)
        div = (uint16_t)(tmp / osc);
800057ba:	01e15783          	lhu	a5,30(sp)
800057be:	853e                	mv	a0,a5
800057c0:	751020ef          	jal	80008710 <__floatsisf>
800057c4:	87aa                	mv	a5,a0
800057c6:	85be                	mv	a1,a5
800057c8:	4562                	lw	a0,24(sp)
800057ca:	198070ef          	jal	8000c962 <__divsf3>
800057ce:	87aa                	mv	a5,a0
800057d0:	853e                	mv	a0,a5
800057d2:	6db020ef          	jal	800086ac <__fixunssfsi>
800057d6:	87aa                	mv	a5,a0
800057d8:	00f11b23          	sh	a5,22(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN) {
800057dc:	01615783          	lhu	a5,22(sp)
800057e0:	10078263          	beqz	a5,800058e4 <.L22>
            /* invalid div */
            continue;
        }
        if (div * osc > tmp) {
800057e4:	01615703          	lhu	a4,22(sp)
800057e8:	01e15783          	lhu	a5,30(sp)
800057ec:	02f707b3          	mul	a5,a4,a5
800057f0:	853e                	mv	a0,a5
800057f2:	71f020ef          	jal	80008710 <__floatsisf>
800057f6:	87aa                	mv	a5,a0
800057f8:	85be                	mv	a1,a5
800057fa:	4562                	lw	a0,24(sp)
800057fc:	5d1020ef          	jal	800085cc <__ltsf2>
80005800:	87aa                	mv	a5,a0
80005802:	0207d863          	bgez	a5,80005832 <.L21>
            delta = (uint16_t)(div * osc - tmp);
80005806:	01615703          	lhu	a4,22(sp)
8000580a:	01e15783          	lhu	a5,30(sp)
8000580e:	02f707b3          	mul	a5,a4,a5
80005812:	853e                	mv	a0,a5
80005814:	6fd020ef          	jal	80008710 <__floatsisf>
80005818:	87aa                	mv	a5,a0
8000581a:	45e2                	lw	a1,24(sp)
8000581c:	853e                	mv	a0,a5
8000581e:	3f9020ef          	jal	80008416 <__subsf3>
80005822:	87aa                	mv	a5,a0
80005824:	853e                	mv	a0,a5
80005826:	687020ef          	jal	800086ac <__fixunssfsi>
8000582a:	87aa                	mv	a5,a0
8000582c:	00f11e23          	sh	a5,28(sp)
80005830:	a0b9                	j	8000587e <.L12>

80005832 <.L21>:
        } else if (div * osc < tmp) {
80005832:	01615703          	lhu	a4,22(sp)
80005836:	01e15783          	lhu	a5,30(sp)
8000583a:	02f707b3          	mul	a5,a4,a5
8000583e:	853e                	mv	a0,a5
80005840:	6d1020ef          	jal	80008710 <__floatsisf>
80005844:	87aa                	mv	a5,a0
80005846:	85be                	mv	a1,a5
80005848:	4562                	lw	a0,24(sp)
8000584a:	5f3020ef          	jal	8000863c <__gtsf2>
8000584e:	87aa                	mv	a5,a0
80005850:	02f05763          	blez	a5,8000587e <.L12>
            delta = (uint16_t)(tmp - div * osc);
80005854:	01615703          	lhu	a4,22(sp)
80005858:	01e15783          	lhu	a5,30(sp)
8000585c:	02f707b3          	mul	a5,a4,a5
80005860:	853e                	mv	a0,a5
80005862:	6af020ef          	jal	80008710 <__floatsisf>
80005866:	87aa                	mv	a5,a0
80005868:	85be                	mv	a1,a5
8000586a:	4562                	lw	a0,24(sp)
8000586c:	3ab020ef          	jal	80008416 <__subsf3>
80005870:	87aa                	mv	a5,a0
80005872:	853e                	mv	a0,a5
80005874:	639020ef          	jal	800086ac <__fixunssfsi>
80005878:	87aa                	mv	a5,a0
8000587a:	00f11e23          	sh	a5,28(sp)

8000587e <.L12>:
        }
        if (delta && ((delta * 100 / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
8000587e:	01c15783          	lhu	a5,28(sp)
80005882:	cb9d                	beqz	a5,800058b8 <.L14>
80005884:	01c15703          	lhu	a4,28(sp)
80005888:	06400793          	li	a5,100
8000588c:	02f707b3          	mul	a5,a4,a5
80005890:	853e                	mv	a0,a5
80005892:	67f020ef          	jal	80008710 <__floatsisf>
80005896:	87aa                	mv	a5,a0
80005898:	45e2                	lw	a1,24(sp)
8000589a:	853e                	mv	a0,a5
8000589c:	0c6070ef          	jal	8000c962 <__divsf3>
800058a0:	87aa                	mv	a5,a0
800058a2:	873e                	mv	a4,a5
800058a4:	800037b7          	lui	a5,0x80003
800058a8:	07c7a583          	lw	a1,124(a5) # 8000307c <.LC0>
800058ac:	853a                	mv	a0,a4
800058ae:	58f020ef          	jal	8000863c <__gtsf2>
800058b2:	87aa                	mv	a5,a0
800058b4:	02f04a63          	bgtz	a5,800058e8 <.L23>

800058b8 <.L14>:
            continue;
        } else {
            *div_out = div;
800058b8:	4792                	lw	a5,4(sp)
800058ba:	01615703          	lhu	a4,22(sp)
800058be:	00e79023          	sh	a4,0(a5)
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
800058c2:	01e15703          	lhu	a4,30(sp)
800058c6:	02000793          	li	a5,32
800058ca:	00f70763          	beq	a4,a5,800058d8 <.L16>
800058ce:	01e15783          	lhu	a5,30(sp)
800058d2:	0ff7f793          	zext.b	a5,a5
800058d6:	a011                	j	800058da <.L17>

800058d8 <.L16>:
800058d8:	4781                	li	a5,0

800058da <.L17>:
800058da:	4702                	lw	a4,0(sp)
800058dc:	00f70023          	sb	a5,0(a4)
            return true;
800058e0:	4785                	li	a5,1
800058e2:	a005                	j	80005902 <.L6>

800058e4 <.L22>:
            continue;
800058e4:	0001                	nop
800058e6:	a011                	j	800058ea <.L9>

800058e8 <.L23>:
            continue;
800058e8:	0001                	nop

800058ea <.L9>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
800058ea:	01e15783          	lhu	a5,30(sp)
800058ee:	0789                	add	a5,a5,2
800058f0:	00f11f23          	sh	a5,30(sp)

800058f4 <.L7>:
800058f4:	01e15703          	lhu	a4,30(sp)
800058f8:	02000793          	li	a5,32
800058fc:	eae7fde3          	bgeu	a5,a4,800057b6 <.L18>
        }
    }
    return false;
80005900:	4781                	li	a5,0

80005902 <.L6>:
}
80005902:	853e                	mv	a0,a5
80005904:	50b2                	lw	ra,44(sp)
80005906:	5422                	lw	s0,40(sp)
80005908:	6145                	add	sp,sp,48
8000590a:	8082                	ret

Disassembly of section .text.uart_send_byte:

8000590c <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
8000590c:	1101                	add	sp,sp,-32
8000590e:	c62a                	sw	a0,12(sp)
80005910:	87ae                	mv	a5,a1
80005912:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
80005916:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
80005918:	a811                	j	8000592c <.L49>

8000591a <.L52>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000591a:	4772                	lw	a4,28(sp)
8000591c:	6785                	lui	a5,0x1
8000591e:	38878793          	add	a5,a5,904 # 1388 <.L22+0xc>
80005922:	00e7eb63          	bltu	a5,a4,80005938 <.L55>
            break;
        }
        retry++;
80005926:	47f2                	lw	a5,28(sp)
80005928:	0785                	add	a5,a5,1
8000592a:	ce3e                	sw	a5,28(sp)

8000592c <.L49>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
8000592c:	47b2                	lw	a5,12(sp)
8000592e:	5bdc                	lw	a5,52(a5)
80005930:	0207f793          	and	a5,a5,32
80005934:	d3fd                	beqz	a5,8000591a <.L52>
80005936:	a011                	j	8000593a <.L51>

80005938 <.L55>:
            break;
80005938:	0001                	nop

8000593a <.L51>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000593a:	4772                	lw	a4,28(sp)
8000593c:	6785                	lui	a5,0x1
8000593e:	38878793          	add	a5,a5,904 # 1388 <.L22+0xc>
80005942:	00e7f463          	bgeu	a5,a4,8000594a <.L53>
        return status_timeout;
80005946:	478d                	li	a5,3
80005948:	a031                	j	80005954 <.L54>

8000594a <.L53>:
    }

    ptr->THR = UART_THR_THR_SET(c);
8000594a:	00b14703          	lbu	a4,11(sp)
8000594e:	47b2                	lw	a5,12(sp)
80005950:	d398                	sw	a4,32(a5)
    return status_success;
80005952:	4781                	li	a5,0

80005954 <.L54>:
}
80005954:	853e                	mv	a0,a5
80005956:	6105                	add	sp,sp,32
80005958:	8082                	ret

Disassembly of section .text.usb_dcd_connect:

8000595a <usb_dcd_connect>:
    ptr->USBINTR = 0;
}

/* Connect by enabling internal pull-up resistor on D+/D- */
void usb_dcd_connect(USB_Type *ptr)
{
8000595a:	1141                	add	sp,sp,-16
8000595c:	c62a                	sw	a0,12(sp)
    ptr->USBCMD |= USB_USBCMD_RS_MASK;
8000595e:	47b2                	lw	a5,12(sp)
80005960:	1407a783          	lw	a5,320(a5)
80005964:	0017e713          	or	a4,a5,1
80005968:	47b2                	lw	a5,12(sp)
8000596a:	14e7a023          	sw	a4,320(a5)
}
8000596e:	0001                	nop
80005970:	0141                	add	sp,sp,16
80005972:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_open:

80005974 <usb_dcd_edpt_open>:
/*---------------------------------------------------------------------
 * Endpoint API
 *---------------------------------------------------------------------
 */
void usb_dcd_edpt_open(USB_Type *ptr, usb_endpoint_config_t *config)
{
80005974:	1101                	add	sp,sp,-32
80005976:	c62a                	sw	a0,12(sp)
80005978:	c42e                	sw	a1,8(sp)
    uint8_t const epnum  = config->ep_addr & 0x0f;
8000597a:	47a2                	lw	a5,8(sp)
8000597c:	0017c783          	lbu	a5,1(a5)
80005980:	8bbd                	and	a5,a5,15
80005982:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir = (config->ep_addr & 0x80) >> 7;
80005986:	47a2                	lw	a5,8(sp)
80005988:	0017c783          	lbu	a5,1(a5)
8000598c:	839d                	srl	a5,a5,0x7
8000598e:	00f10f23          	sb	a5,30(sp)

    /* Enable EP Control */
    uint32_t temp = ptr->ENDPTCTRL[epnum];
80005992:	01f14783          	lbu	a5,31(sp)
80005996:	4732                	lw	a4,12(sp)
80005998:	07078793          	add	a5,a5,112
8000599c:	078a                	sll	a5,a5,0x2
8000599e:	97ba                	add	a5,a5,a4
800059a0:	439c                	lw	a5,0(a5)
800059a2:	cc3e                	sw	a5,24(sp)
    temp &= ~((0x03 << 2) << (dir ? 16 : 0));
800059a4:	01e14783          	lbu	a5,30(sp)
800059a8:	c789                	beqz	a5,800059b2 <.L35>
800059aa:	fff407b7          	lui	a5,0xfff40
800059ae:	17fd                	add	a5,a5,-1 # fff3ffff <__APB_SRAM_segment_end__+0xbe4dfff>
800059b0:	a011                	j	800059b4 <.L36>

800059b2 <.L35>:
800059b2:	57cd                	li	a5,-13

800059b4 <.L36>:
800059b4:	4762                	lw	a4,24(sp)
800059b6:	8ff9                	and	a5,a5,a4
800059b8:	cc3e                	sw	a5,24(sp)
    temp |= ((config->xfer << 2) | ENDPTCTRL_ENABLE | ENDPTCTRL_TOGGLE_RESET) << (dir ? 16 : 0);
800059ba:	47a2                	lw	a5,8(sp)
800059bc:	0007c783          	lbu	a5,0(a5)
800059c0:	078a                	sll	a5,a5,0x2
800059c2:	0c07e713          	or	a4,a5,192
800059c6:	01e14783          	lbu	a5,30(sp)
800059ca:	c399                	beqz	a5,800059d0 <.L37>
800059cc:	47c1                	li	a5,16
800059ce:	a011                	j	800059d2 <.L38>

800059d0 <.L37>:
800059d0:	4781                	li	a5,0

800059d2 <.L38>:
800059d2:	00f717b3          	sll	a5,a4,a5
800059d6:	873e                	mv	a4,a5
800059d8:	47e2                	lw	a5,24(sp)
800059da:	8fd9                	or	a5,a5,a4
800059dc:	cc3e                	sw	a5,24(sp)
    ptr->ENDPTCTRL[epnum] = temp;
800059de:	01f14783          	lbu	a5,31(sp)
800059e2:	4732                	lw	a4,12(sp)
800059e4:	07078793          	add	a5,a5,112
800059e8:	078a                	sll	a5,a5,0x2
800059ea:	97ba                	add	a5,a5,a4
800059ec:	4762                	lw	a4,24(sp)
800059ee:	c398                	sw	a4,0(a5)
}
800059f0:	0001                	nop
800059f2:	6105                	add	sp,sp,32
800059f4:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_stall:

800059f6 <usb_dcd_edpt_stall>:
    /* Start transfer */
    ptr->ENDPTPRIME = 1 << offset;
}

void usb_dcd_edpt_stall(USB_Type *ptr, uint8_t ep_addr)
{
800059f6:	1101                	add	sp,sp,-32
800059f8:	c62a                	sw	a0,12(sp)
800059fa:	87ae                	mv	a5,a1
800059fc:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
80005a00:	00b14783          	lbu	a5,11(sp)
80005a04:	8bbd                	and	a5,a5,15
80005a06:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
80005a0a:	00b14783          	lbu	a5,11(sp)
80005a0e:	839d                	srl	a5,a5,0x7
80005a10:	00f10f23          	sb	a5,30(sp)

    ptr->ENDPTCTRL[epnum] |= ENDPTCTRL_STALL << (dir ? 16 : 0);
80005a14:	01f14783          	lbu	a5,31(sp)
80005a18:	4732                	lw	a4,12(sp)
80005a1a:	07078793          	add	a5,a5,112
80005a1e:	078a                	sll	a5,a5,0x2
80005a20:	97ba                	add	a5,a5,a4
80005a22:	4398                	lw	a4,0(a5)
80005a24:	01e14783          	lbu	a5,30(sp)
80005a28:	c399                	beqz	a5,80005a2e <.L45>
80005a2a:	67c1                	lui	a5,0x10
80005a2c:	a011                	j	80005a30 <.L46>

80005a2e <.L45>:
80005a2e:	4785                	li	a5,1

80005a30 <.L46>:
80005a30:	01f14603          	lbu	a2,31(sp)
80005a34:	8f5d                	or	a4,a4,a5
80005a36:	46b2                	lw	a3,12(sp)
80005a38:	07060793          	add	a5,a2,112
80005a3c:	078a                	sll	a5,a5,0x2
80005a3e:	97b6                	add	a5,a5,a3
80005a40:	c398                	sw	a4,0(a5)
}
80005a42:	0001                	nop
80005a44:	6105                	add	sp,sp,32
80005a46:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_clear_stall:

80005a48 <usb_dcd_edpt_clear_stall>:

void usb_dcd_edpt_clear_stall(USB_Type *ptr, uint8_t ep_addr)
{
80005a48:	1101                	add	sp,sp,-32
80005a4a:	c62a                	sw	a0,12(sp)
80005a4c:	87ae                	mv	a5,a1
80005a4e:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
80005a52:	00b14783          	lbu	a5,11(sp)
80005a56:	8bbd                	and	a5,a5,15
80005a58:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
80005a5c:	00b14783          	lbu	a5,11(sp)
80005a60:	839d                	srl	a5,a5,0x7
80005a62:	00f10f23          	sb	a5,30(sp)

    /* data toggle also need to be reset */
    ptr->ENDPTCTRL[epnum] |= ENDPTCTRL_TOGGLE_RESET << (dir ? 16 : 0);
80005a66:	01f14783          	lbu	a5,31(sp)
80005a6a:	4732                	lw	a4,12(sp)
80005a6c:	07078793          	add	a5,a5,112 # 10070 <__XPI0_segment_used_size__+0x3438>
80005a70:	078a                	sll	a5,a5,0x2
80005a72:	97ba                	add	a5,a5,a4
80005a74:	4398                	lw	a4,0(a5)
80005a76:	01e14783          	lbu	a5,30(sp)
80005a7a:	c781                	beqz	a5,80005a82 <.L48>
80005a7c:	004007b7          	lui	a5,0x400
80005a80:	a019                	j	80005a86 <.L49>

80005a82 <.L48>:
80005a82:	04000793          	li	a5,64

80005a86 <.L49>:
80005a86:	01f14603          	lbu	a2,31(sp)
80005a8a:	8f5d                	or	a4,a4,a5
80005a8c:	46b2                	lw	a3,12(sp)
80005a8e:	07060793          	add	a5,a2,112
80005a92:	078a                	sll	a5,a5,0x2
80005a94:	97b6                	add	a5,a5,a3
80005a96:	c398                	sw	a4,0(a5)
    ptr->ENDPTCTRL[epnum] &= ~(ENDPTCTRL_STALL << (dir  ? 16 : 0));
80005a98:	01f14783          	lbu	a5,31(sp)
80005a9c:	4732                	lw	a4,12(sp)
80005a9e:	07078793          	add	a5,a5,112 # 400070 <__DLM_segment_end__+0x340070>
80005aa2:	078a                	sll	a5,a5,0x2
80005aa4:	97ba                	add	a5,a5,a4
80005aa6:	4398                	lw	a4,0(a5)
80005aa8:	01e14783          	lbu	a5,30(sp)
80005aac:	c781                	beqz	a5,80005ab4 <.L50>
80005aae:	77c1                	lui	a5,0xffff0
80005ab0:	17fd                	add	a5,a5,-1 # fffeffff <__APB_SRAM_segment_end__+0xbefdfff>
80005ab2:	a011                	j	80005ab6 <.L51>

80005ab4 <.L50>:
80005ab4:	57f9                	li	a5,-2

80005ab6 <.L51>:
80005ab6:	01f14603          	lbu	a2,31(sp)
80005aba:	8f7d                	and	a4,a4,a5
80005abc:	46b2                	lw	a3,12(sp)
80005abe:	07060793          	add	a5,a2,112
80005ac2:	078a                	sll	a5,a5,0x2
80005ac4:	97b6                	add	a5,a5,a3
80005ac6:	c398                	sw	a4,0(a5)
}
80005ac8:	0001                	nop
80005aca:	6105                	add	sp,sp,32
80005acc:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_check_stall:

80005ace <usb_dcd_edpt_check_stall>:

bool usb_dcd_edpt_check_stall(USB_Type *ptr, uint8_t ep_addr)
{
80005ace:	1101                	add	sp,sp,-32
80005ad0:	c62a                	sw	a0,12(sp)
80005ad2:	87ae                	mv	a5,a1
80005ad4:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
80005ad8:	00b14783          	lbu	a5,11(sp)
80005adc:	8bbd                	and	a5,a5,15
80005ade:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
80005ae2:	00b14783          	lbu	a5,11(sp)
80005ae6:	839d                	srl	a5,a5,0x7
80005ae8:	00f10f23          	sb	a5,30(sp)

    return (ptr->ENDPTCTRL[epnum] & (ENDPTCTRL_STALL << (dir ? 16 : 0))) ? true : false;
80005aec:	01f14783          	lbu	a5,31(sp)
80005af0:	4732                	lw	a4,12(sp)
80005af2:	07078793          	add	a5,a5,112
80005af6:	078a                	sll	a5,a5,0x2
80005af8:	97ba                	add	a5,a5,a4
80005afa:	4398                	lw	a4,0(a5)
80005afc:	01e14783          	lbu	a5,30(sp)
80005b00:	c399                	beqz	a5,80005b06 <.L53>
80005b02:	67c1                	lui	a5,0x10
80005b04:	a011                	j	80005b08 <.L54>

80005b06 <.L53>:
80005b06:	4785                	li	a5,1

80005b08 <.L54>:
80005b08:	8ff9                	and	a5,a5,a4
80005b0a:	00f037b3          	snez	a5,a5
80005b0e:	0ff7f793          	zext.b	a5,a5
}
80005b12:	853e                	mv	a0,a5
80005b14:	6105                	add	sp,sp,32
80005b16:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_close:

80005b18 <usb_dcd_edpt_close>:

void usb_dcd_edpt_close(USB_Type *ptr, uint8_t ep_addr)
{
80005b18:	1101                	add	sp,sp,-32
80005b1a:	c62a                	sw	a0,12(sp)
80005b1c:	87ae                	mv	a5,a1
80005b1e:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
80005b22:	00b14783          	lbu	a5,11(sp)
80005b26:	8bbd                	and	a5,a5,15
80005b28:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
80005b2c:	00b14783          	lbu	a5,11(sp)
80005b30:	839d                	srl	a5,a5,0x7
80005b32:	00f10f23          	sb	a5,30(sp)

    uint32_t primebit = HPM_BITSMASK(1, epnum) << (dir ? 16 : 0);
80005b36:	01f14783          	lbu	a5,31(sp)
80005b3a:	4705                	li	a4,1
80005b3c:	00f71733          	sll	a4,a4,a5
80005b40:	01e14783          	lbu	a5,30(sp)
80005b44:	c399                	beqz	a5,80005b4a <.L57>
80005b46:	47c1                	li	a5,16
80005b48:	a011                	j	80005b4c <.L58>

80005b4a <.L57>:
80005b4a:	4781                	li	a5,0

80005b4c <.L58>:
80005b4c:	00f717b3          	sll	a5,a4,a5
80005b50:	cc3e                	sw	a5,24(sp)

80005b52 <.L60>:

    /* Flush the endpoint to stop a transfer. */
    do {
        /* Set the corresponding bit(s) in the ENDPTFLUSH register */
        ptr->ENDPTFLUSH |= primebit;
80005b52:	47b2                	lw	a5,12(sp)
80005b54:	1b47a703          	lw	a4,436(a5) # 101b4 <__XPI0_segment_used_size__+0x357c>
80005b58:	47e2                	lw	a5,24(sp)
80005b5a:	8f5d                	or	a4,a4,a5
80005b5c:	47b2                	lw	a5,12(sp)
80005b5e:	1ae7aa23          	sw	a4,436(a5)

        /* Wait until all bits in the ENDPTFLUSH register are cleared. */
        while (0U != (ptr->ENDPTFLUSH & primebit)) {
80005b62:	0001                	nop

80005b64 <.L59>:
80005b64:	47b2                	lw	a5,12(sp)
80005b66:	1b47a703          	lw	a4,436(a5)
80005b6a:	47e2                	lw	a5,24(sp)
80005b6c:	8ff9                	and	a5,a5,a4
80005b6e:	fbfd                	bnez	a5,80005b64 <.L59>
        /*
         * Read the ENDPTSTAT register to ensure that for all endpoints
         * commanded to be flushed, that the corresponding bits
         * are now cleared.
         */
    } while (0U != (ptr->ENDPTSTAT & primebit));
80005b70:	47b2                	lw	a5,12(sp)
80005b72:	1b87a703          	lw	a4,440(a5)
80005b76:	47e2                	lw	a5,24(sp)
80005b78:	8ff9                	and	a5,a5,a4
80005b7a:	ffe1                	bnez	a5,80005b52 <.L60>

    /* Disable the endpoint */
    ptr->ENDPTCTRL[epnum] &= ~((ENDPTCTRL_TYPE | ENDPTCTRL_ENABLE | ENDPTCTRL_STALL) << (dir ? 16 : 0));
80005b7c:	01f14783          	lbu	a5,31(sp)
80005b80:	4732                	lw	a4,12(sp)
80005b82:	07078793          	add	a5,a5,112
80005b86:	078a                	sll	a5,a5,0x2
80005b88:	97ba                	add	a5,a5,a4
80005b8a:	4398                	lw	a4,0(a5)
80005b8c:	01e14783          	lbu	a5,30(sp)
80005b90:	c789                	beqz	a5,80005b9a <.L61>
80005b92:	ff7307b7          	lui	a5,0xff730
80005b96:	17fd                	add	a5,a5,-1 # ff72ffff <__APB_SRAM_segment_end__+0xb63dfff>
80005b98:	a019                	j	80005b9e <.L62>

80005b9a <.L61>:
80005b9a:	f7200793          	li	a5,-142

80005b9e <.L62>:
80005b9e:	01f14603          	lbu	a2,31(sp)
80005ba2:	8f7d                	and	a4,a4,a5
80005ba4:	46b2                	lw	a3,12(sp)
80005ba6:	07060793          	add	a5,a2,112
80005baa:	078a                	sll	a5,a5,0x2
80005bac:	97b6                	add	a5,a5,a3
80005bae:	c398                	sw	a4,0(a5)
    ptr->ENDPTCTRL[epnum] |= (usb_xfer_bulk << 2) << (dir ? 16 : 0);
80005bb0:	01f14783          	lbu	a5,31(sp)
80005bb4:	4732                	lw	a4,12(sp)
80005bb6:	07078793          	add	a5,a5,112
80005bba:	078a                	sll	a5,a5,0x2
80005bbc:	97ba                	add	a5,a5,a4
80005bbe:	4398                	lw	a4,0(a5)
80005bc0:	01e14783          	lbu	a5,30(sp)
80005bc4:	c781                	beqz	a5,80005bcc <.L63>
80005bc6:	000807b7          	lui	a5,0x80
80005bca:	a011                	j	80005bce <.L64>

80005bcc <.L63>:
80005bcc:	47a1                	li	a5,8

80005bce <.L64>:
80005bce:	01f14603          	lbu	a2,31(sp)
80005bd2:	8f5d                	or	a4,a4,a5
80005bd4:	46b2                	lw	a3,12(sp)
80005bd6:	07060793          	add	a5,a2,112
80005bda:	078a                	sll	a5,a5,0x2
80005bdc:	97b6                	add	a5,a5,a3
80005bde:	c398                	sw	a4,0(a5)
}
80005be0:	0001                	nop
80005be2:	6105                	add	sp,sp,32
80005be4:	8082                	ret

Disassembly of section .text.chry_ringbuffer_check_empty:

80005be6 <chry_ringbuffer_check_empty>:
* 
* @retval true              empty
* @retval false             not empty
*****************************************************************************/
bool chry_ringbuffer_check_empty(chry_ringbuffer_t *rb)
{
80005be6:	1141                	add	sp,sp,-16
80005be8:	c62a                	sw	a0,12(sp)
    return rb->in == rb->out;
80005bea:	47b2                	lw	a5,12(sp)
80005bec:	4398                	lw	a4,0(a5)
80005bee:	47b2                	lw	a5,12(sp)
80005bf0:	43dc                	lw	a5,4(a5)
80005bf2:	40f707b3          	sub	a5,a4,a5
80005bf6:	0017b793          	seqz	a5,a5
80005bfa:	0ff7f793          	zext.b	a5,a5
}
80005bfe:	853e                	mv	a0,a5
80005c00:	0141                	add	sp,sp,16
80005c02:	8082                	ret

Disassembly of section .text.chry_ringbuffer_peek_byte:

80005c04 <chry_ringbuffer_peek_byte>:
* 
* @retval true              Success
* @retval false             ringbuffer is empty
*****************************************************************************/
bool chry_ringbuffer_peek_byte(chry_ringbuffer_t *rb, uint8_t *byte)
{
80005c04:	1101                	add	sp,sp,-32
80005c06:	ce06                	sw	ra,28(sp)
80005c08:	c62a                	sw	a0,12(sp)
80005c0a:	c42e                	sw	a1,8(sp)
    if (chry_ringbuffer_check_empty(rb)) {
80005c0c:	4532                	lw	a0,12(sp)
80005c0e:	3fe1                	jal	80005be6 <chry_ringbuffer_check_empty>
80005c10:	87aa                	mv	a5,a0
80005c12:	c399                	beqz	a5,80005c18 <.L26>
        return false;
80005c14:	4781                	li	a5,0
80005c16:	a839                	j	80005c34 <.L27>

80005c18 <.L26>:
    }

    *byte = ((uint8_t *)(rb->pool))[rb->out & rb->mask];
80005c18:	47b2                	lw	a5,12(sp)
80005c1a:	47d8                	lw	a4,12(a5)
80005c1c:	47b2                	lw	a5,12(sp)
80005c1e:	43d4                	lw	a3,4(a5)
80005c20:	47b2                	lw	a5,12(sp)
80005c22:	479c                	lw	a5,8(a5)
80005c24:	8ff5                	and	a5,a5,a3
80005c26:	97ba                	add	a5,a5,a4
80005c28:	0007c703          	lbu	a4,0(a5) # 80000 <__AXI_SRAM_segment_size__>
80005c2c:	47a2                	lw	a5,8(sp)
80005c2e:	00e78023          	sb	a4,0(a5)
    return true;
80005c32:	4785                	li	a5,1

80005c34 <.L27>:
}
80005c34:	853e                	mv	a0,a5
80005c36:	40f2                	lw	ra,28(sp)
80005c38:	6105                	add	sp,sp,32
80005c3a:	8082                	ret

Disassembly of section .text.chry_ringbuffer_write:

80005c3c <chry_ringbuffer_write>:
* @param[in]    size        size in byte
* 
* @retval uint32_t          actual write size in byte
*****************************************************************************/
uint32_t chry_ringbuffer_write(chry_ringbuffer_t *rb, void *data, uint32_t size)
{
80005c3c:	7179                	add	sp,sp,-48
80005c3e:	d606                	sw	ra,44(sp)
80005c40:	c62a                	sw	a0,12(sp)
80005c42:	c42e                	sw	a1,8(sp)
80005c44:	c232                	sw	a2,4(sp)
    uint32_t unused;
    uint32_t offset;
    uint32_t remain;

    unused = (rb->mask + 1) - (rb->in - rb->out);
80005c46:	47b2                	lw	a5,12(sp)
80005c48:	4798                	lw	a4,8(a5)
80005c4a:	47b2                	lw	a5,12(sp)
80005c4c:	43d4                	lw	a3,4(a5)
80005c4e:	47b2                	lw	a5,12(sp)
80005c50:	439c                	lw	a5,0(a5)
80005c52:	40f687b3          	sub	a5,a3,a5
80005c56:	97ba                	add	a5,a5,a4
80005c58:	0785                	add	a5,a5,1
80005c5a:	ce3e                	sw	a5,28(sp)

    if (size > unused) {
80005c5c:	4712                	lw	a4,4(sp)
80005c5e:	47f2                	lw	a5,28(sp)
80005c60:	00e7f463          	bgeu	a5,a4,80005c68 <.L34>
        size = unused;
80005c64:	47f2                	lw	a5,28(sp)
80005c66:	c23e                	sw	a5,4(sp)

80005c68 <.L34>:
    }

    offset = rb->in & rb->mask;
80005c68:	47b2                	lw	a5,12(sp)
80005c6a:	4398                	lw	a4,0(a5)
80005c6c:	47b2                	lw	a5,12(sp)
80005c6e:	479c                	lw	a5,8(a5)
80005c70:	8ff9                	and	a5,a5,a4
80005c72:	cc3e                	sw	a5,24(sp)

    remain = rb->mask + 1 - offset;
80005c74:	47b2                	lw	a5,12(sp)
80005c76:	4798                	lw	a4,8(a5)
80005c78:	47e2                	lw	a5,24(sp)
80005c7a:	40f707b3          	sub	a5,a4,a5
80005c7e:	0785                	add	a5,a5,1
80005c80:	ca3e                	sw	a5,20(sp)
    remain = remain > size ? size : remain;
80005c82:	4712                	lw	a4,4(sp)
80005c84:	47d2                	lw	a5,20(sp)
80005c86:	00f77363          	bgeu	a4,a5,80005c8c <.L35>
80005c8a:	87ba                	mv	a5,a4

80005c8c <.L35>:
80005c8c:	ca3e                	sw	a5,20(sp)

    memcpy(((uint8_t *)(rb->pool)) + offset, data, remain);
80005c8e:	47b2                	lw	a5,12(sp)
80005c90:	47d8                	lw	a4,12(a5)
80005c92:	47e2                	lw	a5,24(sp)
80005c94:	97ba                	add	a5,a5,a4
80005c96:	4652                	lw	a2,20(sp)
80005c98:	45a2                	lw	a1,8(sp)
80005c9a:	853e                	mv	a0,a5
80005c9c:	5fe030ef          	jal	8000929a <memcpy>
    memcpy(rb->pool, (uint8_t *)data + remain, size - remain);
80005ca0:	47b2                	lw	a5,12(sp)
80005ca2:	47d4                	lw	a3,12(a5)
80005ca4:	4722                	lw	a4,8(sp)
80005ca6:	47d2                	lw	a5,20(sp)
80005ca8:	00f705b3          	add	a1,a4,a5
80005cac:	4712                	lw	a4,4(sp)
80005cae:	47d2                	lw	a5,20(sp)
80005cb0:	40f707b3          	sub	a5,a4,a5
80005cb4:	863e                	mv	a2,a5
80005cb6:	8536                	mv	a0,a3
80005cb8:	5e2030ef          	jal	8000929a <memcpy>

    rb->in += size;
80005cbc:	47b2                	lw	a5,12(sp)
80005cbe:	4398                	lw	a4,0(a5)
80005cc0:	4792                	lw	a5,4(sp)
80005cc2:	973e                	add	a4,a4,a5
80005cc4:	47b2                	lw	a5,12(sp)
80005cc6:	c398                	sw	a4,0(a5)

    return size;
80005cc8:	4792                	lw	a5,4(sp)
}
80005cca:	853e                	mv	a0,a5
80005ccc:	50b2                	lw	ra,44(sp)
80005cce:	6145                	add	sp,sp,48
80005cd0:	8082                	ret

Disassembly of section .text.cdc_acm_class_interface_request_handler:

80005cd2 <cdc_acm_class_interface_request_handler>:

const char *stop_name[] = { "1", "1.5", "2" };
const char *parity_name[] = { "N", "O", "E", "M", "S" };

static int cdc_acm_class_interface_request_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
80005cd2:	7179                	add	sp,sp,-48
80005cd4:	d606                	sw	ra,44(sp)
80005cd6:	87aa                	mv	a5,a0
80005cd8:	c42e                	sw	a1,8(sp)
80005cda:	c232                	sw	a2,4(sp)
80005cdc:	c036                	sw	a3,0(sp)
80005cde:	00f107a3          	sb	a5,15(sp)
                "bRequest 0x%02x\r\n",
                setup->bRequest);

    struct cdc_line_coding line_coding;
    bool dtr, rts;
    uint8_t intf_num = LO_BYTE(setup->wIndex);
80005ce2:	47a2                	lw	a5,8(sp)
80005ce4:	0047c703          	lbu	a4,4(a5)
80005ce8:	0057c783          	lbu	a5,5(a5)
80005cec:	07a2                	sll	a5,a5,0x8
80005cee:	8fd9                	or	a5,a5,a4
80005cf0:	07c2                	sll	a5,a5,0x10
80005cf2:	83c1                	srl	a5,a5,0x10
80005cf4:	00f10fa3          	sb	a5,31(sp)

    switch (setup->bRequest) {
80005cf8:	47a2                	lw	a5,8(sp)
80005cfa:	0017c783          	lbu	a5,1(a5)
80005cfe:	02300713          	li	a4,35
80005d02:	0ee78f63          	beq	a5,a4,80005e00 <.L2>
80005d06:	02300713          	li	a4,35
80005d0a:	10f74363          	blt	a4,a5,80005e10 <.L3>
80005d0e:	02200713          	li	a4,34
80005d12:	04e78e63          	beq	a5,a4,80005d6e <.L4>
80005d16:	02200713          	li	a4,34
80005d1a:	0ef74b63          	blt	a4,a5,80005e10 <.L3>
80005d1e:	02000713          	li	a4,32
80005d22:	00e78763          	beq	a5,a4,80005d30 <.L5>
80005d26:	02100713          	li	a4,33
80005d2a:	0ae78363          	beq	a5,a4,80005dd0 <.L6>
80005d2e:	a0cd                	j	80005e10 <.L3>

80005d30 <.L5>:
            /*                                        2 - Even                             */
            /*                                        3 - Mark                             */
            /*                                        4 - Space                            */
            /* 6      | bDataBits  |   1   | Number Data bits (5, 6, 7, 8 or 16).          */
            /*******************************************************************************/
            memcpy(&line_coding, *data, setup->wLength);
80005d30:	4792                	lw	a5,4(sp)
80005d32:	4394                	lw	a3,0(a5)
80005d34:	47a2                	lw	a5,8(sp)
80005d36:	0067c703          	lbu	a4,6(a5)
80005d3a:	0077c783          	lbu	a5,7(a5)
80005d3e:	07a2                	sll	a5,a5,0x8
80005d40:	8fd9                	or	a5,a5,a4
80005d42:	07c2                	sll	a5,a5,0x10
80005d44:	83c1                	srl	a5,a5,0x10
80005d46:	873e                	mv	a4,a5
80005d48:	085c                	add	a5,sp,20
80005d4a:	863a                	mv	a2,a4
80005d4c:	85b6                	mv	a1,a3
80005d4e:	853e                	mv	a0,a5
80005d50:	54a030ef          	jal	8000929a <memcpy>
                        line_coding.dwDTERate,
                        line_coding.bDataBits,
                        parity_name[line_coding.bParityType],
                        stop_name[line_coding.bCharFormat]);

            usbd_cdc_acm_set_line_coding(busid, intf_num, &line_coding);
80005d54:	0854                	add	a3,sp,20
80005d56:	01f14703          	lbu	a4,31(sp)
80005d5a:	00f14783          	lbu	a5,15(sp)
80005d5e:	8636                	mv	a2,a3
80005d60:	85ba                	mv	a1,a4
80005d62:	853e                	mv	a0,a5
80005d64:	7fffc097          	auipc	ra,0x7fffc
80005d68:	c54080e7          	jalr	-940(ra) # 19b8 <usbd_cdc_acm_set_line_coding>
            break;
80005d6c:	a0e1                	j	80005e34 <.L7>

80005d6e <.L4>:

        case CDC_REQUEST_SET_CONTROL_LINE_STATE:
            dtr = (setup->wValue & 0x0001);
80005d6e:	47a2                	lw	a5,8(sp)
80005d70:	0027c703          	lbu	a4,2(a5)
80005d74:	0037c783          	lbu	a5,3(a5)
80005d78:	07a2                	sll	a5,a5,0x8
80005d7a:	8fd9                	or	a5,a5,a4
80005d7c:	07c2                	sll	a5,a5,0x10
80005d7e:	83c1                	srl	a5,a5,0x10
80005d80:	8b85                	and	a5,a5,1
80005d82:	00f037b3          	snez	a5,a5
80005d86:	00f10f23          	sb	a5,30(sp)
            rts = (setup->wValue & 0x0002);
80005d8a:	47a2                	lw	a5,8(sp)
80005d8c:	0027c703          	lbu	a4,2(a5)
80005d90:	0037c783          	lbu	a5,3(a5)
80005d94:	07a2                	sll	a5,a5,0x8
80005d96:	8fd9                	or	a5,a5,a4
80005d98:	07c2                	sll	a5,a5,0x10
80005d9a:	83c1                	srl	a5,a5,0x10
80005d9c:	8b89                	and	a5,a5,2
80005d9e:	00f037b3          	snez	a5,a5
80005da2:	00f10ea3          	sb	a5,29(sp)
            USB_LOG_DBG("Set intf:%d DTR 0x%x,RTS 0x%x\r\n",
                        intf_num,
                        dtr,
                        rts);
            usbd_cdc_acm_set_dtr(busid, intf_num, dtr);
80005da6:	01e14683          	lbu	a3,30(sp)
80005daa:	01f14703          	lbu	a4,31(sp)
80005dae:	00f14783          	lbu	a5,15(sp)
80005db2:	8636                	mv	a2,a3
80005db4:	85ba                	mv	a1,a4
80005db6:	853e                	mv	a0,a5
80005db8:	2059                	jal	80005e3e <.LFE64>
            usbd_cdc_acm_set_rts(busid, intf_num, rts);
80005dba:	01d14683          	lbu	a3,29(sp)
80005dbe:	01f14703          	lbu	a4,31(sp)
80005dc2:	00f14783          	lbu	a5,15(sp)
80005dc6:	8636                	mv	a2,a3
80005dc8:	85ba                	mv	a1,a4
80005dca:	853e                	mv	a0,a5
80005dcc:	2841                	jal	80005e5c <usbd_cdc_acm_set_rts>
            break;
80005dce:	a09d                	j	80005e34 <.L7>

80005dd0 <.L6>:

        case CDC_REQUEST_GET_LINE_CODING:
            usbd_cdc_acm_get_line_coding(busid, intf_num, &line_coding);
80005dd0:	0854                	add	a3,sp,20
80005dd2:	01f14703          	lbu	a4,31(sp)
80005dd6:	00f14783          	lbu	a5,15(sp)
80005dda:	8636                	mv	a2,a3
80005ddc:	85ba                	mv	a1,a4
80005dde:	853e                	mv	a0,a5
80005de0:	7fffb097          	auipc	ra,0x7fffb
80005de4:	71a080e7          	jalr	1818(ra) # 14fa <usbd_cdc_acm_get_line_coding>
            memcpy(*data, &line_coding, 7);
80005de8:	4792                	lw	a5,4(sp)
80005dea:	439c                	lw	a5,0(a5)
80005dec:	0858                	add	a4,sp,20
80005dee:	461d                	li	a2,7
80005df0:	85ba                	mv	a1,a4
80005df2:	853e                	mv	a0,a5
80005df4:	4a6030ef          	jal	8000929a <memcpy>
            *len = 7;
80005df8:	4782                	lw	a5,0(sp)
80005dfa:	471d                	li	a4,7
80005dfc:	c398                	sw	a4,0(a5)
                        intf_num,
                        line_coding.dwDTERate,
                        line_coding.bCharFormat,
                        line_coding.bParityType,
                        line_coding.bDataBits);
            break;
80005dfe:	a81d                	j	80005e34 <.L7>

80005e00 <.L2>:
        case CDC_REQUEST_SEND_BREAK:
            usbd_cdc_acm_send_break(busid, intf_num);
80005e00:	01f14703          	lbu	a4,31(sp)
80005e04:	00f14783          	lbu	a5,15(sp)
80005e08:	85ba                	mv	a1,a4
80005e0a:	853e                	mv	a0,a5
80005e0c:	20bd                	jal	80005e7a <usbd_cdc_acm_send_break>
            break;
80005e0e:	a01d                	j	80005e34 <.L7>

80005e10 <.L3>:
        default:
            USB_LOG_WRN("Unhandled CDC Class bRequest 0x%02x\r\n", setup->bRequest);
80005e10:	e8020513          	add	a0,tp,-384 # fffffe80 <__APB_SRAM_segment_end__+0xbf0de80>
80005e14:	63a030ef          	jal	8000944e <printf>
80005e18:	47a2                	lw	a5,8(sp)
80005e1a:	0017c783          	lbu	a5,1(a5)
80005e1e:	85be                	mv	a1,a5
80005e20:	e9020513          	add	a0,tp,-368 # fffffe90 <__APB_SRAM_segment_end__+0xbf0de90>
80005e24:	62a030ef          	jal	8000944e <printf>
80005e28:	eb820513          	add	a0,tp,-328 # fffffeb8 <__APB_SRAM_segment_end__+0xbf0deb8>
80005e2c:	622030ef          	jal	8000944e <printf>
            return -1;
80005e30:	57fd                	li	a5,-1
80005e32:	a011                	j	80005e36 <.L9>

80005e34 <.L7>:
    }

    return 0;
80005e34:	4781                	li	a5,0

80005e36 <.L9>:
}
80005e36:	853e                	mv	a0,a5
80005e38:	50b2                	lw	ra,44(sp)
80005e3a:	6145                	add	sp,sp,48
80005e3c:	8082                	ret

Disassembly of section .text.usbd_cdc_acm_set_dtr:

80005e3e <usbd_cdc_acm_set_dtr>:
    line_coding->bParityType = 0;
    line_coding->bCharFormat = 0;
}

__WEAK void usbd_cdc_acm_set_dtr(uint8_t busid, uint8_t intf, bool dtr)
{
80005e3e:	1141                	add	sp,sp,-16
80005e40:	87aa                	mv	a5,a0
80005e42:	86ae                	mv	a3,a1
80005e44:	8732                	mv	a4,a2
80005e46:	00f107a3          	sb	a5,15(sp)
80005e4a:	87b6                	mv	a5,a3
80005e4c:	00f10723          	sb	a5,14(sp)
80005e50:	87ba                	mv	a5,a4
80005e52:	00f106a3          	sb	a5,13(sp)
    (void)busid;
    (void)intf;
    (void)dtr;
}
80005e56:	0001                	nop
80005e58:	0141                	add	sp,sp,16
80005e5a:	8082                	ret

Disassembly of section .text.usbd_cdc_acm_set_rts:

80005e5c <usbd_cdc_acm_set_rts>:

__WEAK void usbd_cdc_acm_set_rts(uint8_t busid, uint8_t intf, bool rts)
{
80005e5c:	1141                	add	sp,sp,-16
80005e5e:	87aa                	mv	a5,a0
80005e60:	86ae                	mv	a3,a1
80005e62:	8732                	mv	a4,a2
80005e64:	00f107a3          	sb	a5,15(sp)
80005e68:	87b6                	mv	a5,a3
80005e6a:	00f10723          	sb	a5,14(sp)
80005e6e:	87ba                	mv	a5,a4
80005e70:	00f106a3          	sb	a5,13(sp)
    (void)busid;
    (void)intf;
    (void)rts;
}
80005e74:	0001                	nop
80005e76:	0141                	add	sp,sp,16
80005e78:	8082                	ret

Disassembly of section .text.usbd_cdc_acm_send_break:

80005e7a <usbd_cdc_acm_send_break>:

__WEAK void usbd_cdc_acm_send_break(uint8_t busid, uint8_t intf)
{
80005e7a:	1141                	add	sp,sp,-16
80005e7c:	87aa                	mv	a5,a0
80005e7e:	872e                	mv	a4,a1
80005e80:	00f107a3          	sb	a5,15(sp)
80005e84:	87ba                	mv	a5,a4
80005e86:	00f10723          	sb	a5,14(sp)
    (void)busid;
    (void)intf;
}
80005e8a:	0001                	nop
80005e8c:	0141                	add	sp,sp,16
80005e8e:	8082                	ret

Disassembly of section .text.dword2array:

80005e90 <dword2array>:
#include <stddef.h>

#define ALIGN_UP_DWORD(x) ((uint32_t)(uintptr_t)(x) & (sizeof(uint32_t) - 1))

static inline void dword2array(char *addr, uint32_t w)
{
80005e90:	1141                	add	sp,sp,-16
80005e92:	c62a                	sw	a0,12(sp)
80005e94:	c42e                	sw	a1,8(sp)
    addr[0] = w;
80005e96:	47a2                	lw	a5,8(sp)
80005e98:	0ff7f713          	zext.b	a4,a5
80005e9c:	47b2                	lw	a5,12(sp)
80005e9e:	00e78023          	sb	a4,0(a5)
    addr[1] = w >> 8;
80005ea2:	47a2                	lw	a5,8(sp)
80005ea4:	0087d713          	srl	a4,a5,0x8
80005ea8:	47b2                	lw	a5,12(sp)
80005eaa:	0785                	add	a5,a5,1
80005eac:	0ff77713          	zext.b	a4,a4
80005eb0:	00e78023          	sb	a4,0(a5)
    addr[2] = w >> 16;
80005eb4:	47a2                	lw	a5,8(sp)
80005eb6:	0107d713          	srl	a4,a5,0x10
80005eba:	47b2                	lw	a5,12(sp)
80005ebc:	0789                	add	a5,a5,2
80005ebe:	0ff77713          	zext.b	a4,a4
80005ec2:	00e78023          	sb	a4,0(a5)
    addr[3] = w >> 24;
80005ec6:	47a2                	lw	a5,8(sp)
80005ec8:	0187d713          	srl	a4,a5,0x18
80005ecc:	47b2                	lw	a5,12(sp)
80005ece:	078d                	add	a5,a5,3
80005ed0:	0ff77713          	zext.b	a4,a4
80005ed4:	00e78023          	sb	a4,0(a5)
}
80005ed8:	0001                	nop
80005eda:	0141                	add	sp,sp,16
80005edc:	8082                	ret

Disassembly of section .text.usbd_print_setup:

80005ede <usbd_print_setup>:
struct usbd_bus g_usbdev_bus[CONFIG_USBDEV_MAX_BUS];

static void usbd_class_event_notify_handler(uint8_t busid, uint8_t event, void *arg);

static void usbd_print_setup(struct usb_setup_packet *setup)
{
80005ede:	1101                	add	sp,sp,-32
80005ee0:	ce06                	sw	ra,28(sp)
80005ee2:	c62a                	sw	a0,12(sp)
    USB_LOG_INFO("Setup: "
80005ee4:	56020513          	add	a0,tp,1376 # 560 <slcan_parse_ascii+0x2e>
80005ee8:	566030ef          	jal	8000944e <printf>
80005eec:	47b2                	lw	a5,12(sp)
80005eee:	0007c783          	lbu	a5,0(a5)
80005ef2:	85be                	mv	a1,a5
80005ef4:	47b2                	lw	a5,12(sp)
80005ef6:	0017c783          	lbu	a5,1(a5)
80005efa:	863e                	mv	a2,a5
80005efc:	47b2                	lw	a5,12(sp)
80005efe:	0027c703          	lbu	a4,2(a5)
80005f02:	0037c783          	lbu	a5,3(a5)
80005f06:	07a2                	sll	a5,a5,0x8
80005f08:	8fd9                	or	a5,a5,a4
80005f0a:	07c2                	sll	a5,a5,0x10
80005f0c:	83c1                	srl	a5,a5,0x10
80005f0e:	86be                	mv	a3,a5
80005f10:	47b2                	lw	a5,12(sp)
80005f12:	0047c703          	lbu	a4,4(a5)
80005f16:	0057c783          	lbu	a5,5(a5)
80005f1a:	07a2                	sll	a5,a5,0x8
80005f1c:	8fd9                	or	a5,a5,a4
80005f1e:	07c2                	sll	a5,a5,0x10
80005f20:	83c1                	srl	a5,a5,0x10
80005f22:	853e                	mv	a0,a5
80005f24:	47b2                	lw	a5,12(sp)
80005f26:	0067c703          	lbu	a4,6(a5)
80005f2a:	0077c783          	lbu	a5,7(a5)
80005f2e:	07a2                	sll	a5,a5,0x8
80005f30:	8fd9                	or	a5,a5,a4
80005f32:	07c2                	sll	a5,a5,0x10
80005f34:	83c1                	srl	a5,a5,0x10
80005f36:	872a                	mv	a4,a0
80005f38:	57020513          	add	a0,tp,1392 # 570 <slcan_parse_ascii+0x3e>
80005f3c:	512030ef          	jal	8000944e <printf>
80005f40:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
80005f44:	50a030ef          	jal	8000944e <printf>
                 setup->bmRequestType,
                 setup->bRequest,
                 setup->wValue,
                 setup->wIndex,
                 setup->wLength);
}
80005f48:	0001                	nop
80005f4a:	40f2                	lw	ra,28(sp)
80005f4c:	6105                	add	sp,sp,32
80005f4e:	8082                	ret

Disassembly of section .text.is_device_configured:

80005f50 <is_device_configured>:

static bool is_device_configured(uint8_t busid)
{
80005f50:	1141                	add	sp,sp,-16
80005f52:	87aa                	mv	a5,a0
80005f54:	00f107a3          	sb	a5,15(sp)
    return (g_usbd_core[busid].configuration != 0);
80005f58:	00f14683          	lbu	a3,15(sp)
80005f5c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80005f60:	6785                	lui	a5,0x1
80005f62:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80005f66:	02f687b3          	mul	a5,a3,a5
80005f6a:	97ba                	add	a5,a5,a4
80005f6c:	6705                	lui	a4,0x1
80005f6e:	97ba                	add	a5,a5,a4
80005f70:	81c7c783          	lbu	a5,-2020(a5)
80005f74:	00f037b3          	snez	a5,a5
80005f78:	0ff7f793          	zext.b	a5,a5
}
80005f7c:	853e                	mv	a0,a5
80005f7e:	0141                	add	sp,sp,16
80005f80:	8082                	ret

Disassembly of section .text.usbd_set_endpoint:

80005f82 <usbd_set_endpoint>:
 * @param [in]  ep Endpoint descriptor byte array
 *
 * @return true if successfully configured and enabled
 */
static bool usbd_set_endpoint(uint8_t busid, const struct usb_endpoint_descriptor *ep)
{
80005f82:	1101                	add	sp,sp,-32
80005f84:	ce06                	sw	ra,28(sp)
80005f86:	87aa                	mv	a5,a0
80005f88:	c42e                	sw	a1,8(sp)
80005f8a:	00f107a3          	sb	a5,15(sp)
    USB_LOG_DBG("Open ep:0x%02x type:%u mps:%u\r\n",
                ep->bEndpointAddress,
                USB_GET_ENDPOINT_TYPE(ep->bmAttributes),
                USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize));

    if (ep->bEndpointAddress & 0x80) {
80005f8e:	47a2                	lw	a5,8(sp)
80005f90:	0027c783          	lbu	a5,2(a5)
80005f94:	07e2                	sll	a5,a5,0x18
80005f96:	87e1                	sra	a5,a5,0x18
80005f98:	0a07d063          	bgez	a5,80006038 <.L28>
        g_usbd_core[busid].tx_msg[ep->bEndpointAddress & 0x7f].ep_mps = USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize);
80005f9c:	47a2                	lw	a5,8(sp)
80005f9e:	0047c703          	lbu	a4,4(a5)
80005fa2:	0057c783          	lbu	a5,5(a5)
80005fa6:	07a2                	sll	a5,a5,0x8
80005fa8:	8fd9                	or	a5,a5,a4
80005faa:	07c2                	sll	a5,a5,0x10
80005fac:	83c1                	srl	a5,a5,0x10
80005fae:	00f14583          	lbu	a1,15(sp)
80005fb2:	4722                	lw	a4,8(sp)
80005fb4:	00274703          	lbu	a4,2(a4) # 1002 <__fw_size__+0x2>
80005fb8:	07f77713          	and	a4,a4,127
80005fbc:	7ff7f793          	and	a5,a5,2047
80005fc0:	01079693          	sll	a3,a5,0x10
80005fc4:	82c1                	srl	a3,a3,0x10
80005fc6:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
80005fca:	87ba                	mv	a5,a4
80005fcc:	0786                	sll	a5,a5,0x1
80005fce:	97ba                	add	a5,a5,a4
80005fd0:	078a                	sll	a5,a5,0x2
80005fd2:	6705                	lui	a4,0x1
80005fd4:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
80005fd8:	02e58733          	mul	a4,a1,a4
80005fdc:	97ba                	add	a5,a5,a4
80005fde:	97b2                	add	a5,a5,a2
80005fe0:	6705                	lui	a4,0x1
80005fe2:	97ba                	add	a5,a5,a4
80005fe4:	86d79d23          	sh	a3,-1926(a5)
        g_usbd_core[busid].tx_msg[ep->bEndpointAddress & 0x7f].ep_mult = USB_GET_MULT(ep->wMaxPacketSize);
80005fe8:	47a2                	lw	a5,8(sp)
80005fea:	0047c703          	lbu	a4,4(a5)
80005fee:	0057c783          	lbu	a5,5(a5)
80005ff2:	07a2                	sll	a5,a5,0x8
80005ff4:	8fd9                	or	a5,a5,a4
80005ff6:	07c2                	sll	a5,a5,0x10
80005ff8:	83c1                	srl	a5,a5,0x10
80005ffa:	87ad                	sra	a5,a5,0xb
80005ffc:	0ff7f793          	zext.b	a5,a5
80006000:	00f14583          	lbu	a1,15(sp)
80006004:	4722                	lw	a4,8(sp)
80006006:	00274703          	lbu	a4,2(a4) # 1002 <__fw_size__+0x2>
8000600a:	07f77713          	and	a4,a4,127
8000600e:	8b8d                	and	a5,a5,3
80006010:	0ff7f693          	zext.b	a3,a5
80006014:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
80006018:	87ba                	mv	a5,a4
8000601a:	0786                	sll	a5,a5,0x1
8000601c:	97ba                	add	a5,a5,a4
8000601e:	078a                	sll	a5,a5,0x2
80006020:	6705                	lui	a4,0x1
80006022:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
80006026:	02e58733          	mul	a4,a1,a4
8000602a:	97ba                	add	a5,a5,a4
8000602c:	97b2                	add	a5,a5,a2
8000602e:	6705                	lui	a4,0x1
80006030:	97ba                	add	a5,a5,a4
80006032:	86d78ca3          	sb	a3,-1927(a5)
80006036:	a871                	j	800060d2 <.L29>

80006038 <.L28>:
    } else {
        g_usbd_core[busid].rx_msg[ep->bEndpointAddress & 0x7f].ep_mps = USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize);
80006038:	47a2                	lw	a5,8(sp)
8000603a:	0047c703          	lbu	a4,4(a5)
8000603e:	0057c783          	lbu	a5,5(a5)
80006042:	07a2                	sll	a5,a5,0x8
80006044:	8fd9                	or	a5,a5,a4
80006046:	07c2                	sll	a5,a5,0x10
80006048:	83c1                	srl	a5,a5,0x10
8000604a:	00f14583          	lbu	a1,15(sp)
8000604e:	4722                	lw	a4,8(sp)
80006050:	00274703          	lbu	a4,2(a4) # 1002 <__fw_size__+0x2>
80006054:	07f77713          	and	a4,a4,127
80006058:	7ff7f793          	and	a5,a5,2047
8000605c:	01079693          	sll	a3,a5,0x10
80006060:	82c1                	srl	a3,a3,0x10
80006062:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
80006066:	87ba                	mv	a5,a4
80006068:	0786                	sll	a5,a5,0x1
8000606a:	97ba                	add	a5,a5,a4
8000606c:	078a                	sll	a5,a5,0x2
8000606e:	6705                	lui	a4,0x1
80006070:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
80006074:	02e58733          	mul	a4,a1,a4
80006078:	97ba                	add	a5,a5,a4
8000607a:	97b2                	add	a5,a5,a2
8000607c:	6705                	lui	a4,0x1
8000607e:	97ba                	add	a5,a5,a4
80006080:	8cd79d23          	sh	a3,-1830(a5)
        g_usbd_core[busid].rx_msg[ep->bEndpointAddress & 0x7f].ep_mult = USB_GET_MULT(ep->wMaxPacketSize);
80006084:	47a2                	lw	a5,8(sp)
80006086:	0047c703          	lbu	a4,4(a5)
8000608a:	0057c783          	lbu	a5,5(a5)
8000608e:	07a2                	sll	a5,a5,0x8
80006090:	8fd9                	or	a5,a5,a4
80006092:	07c2                	sll	a5,a5,0x10
80006094:	83c1                	srl	a5,a5,0x10
80006096:	87ad                	sra	a5,a5,0xb
80006098:	0ff7f793          	zext.b	a5,a5
8000609c:	00f14583          	lbu	a1,15(sp)
800060a0:	4722                	lw	a4,8(sp)
800060a2:	00274703          	lbu	a4,2(a4) # 1002 <__fw_size__+0x2>
800060a6:	07f77713          	and	a4,a4,127
800060aa:	8b8d                	and	a5,a5,3
800060ac:	0ff7f693          	zext.b	a3,a5
800060b0:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
800060b4:	87ba                	mv	a5,a4
800060b6:	0786                	sll	a5,a5,0x1
800060b8:	97ba                	add	a5,a5,a4
800060ba:	078a                	sll	a5,a5,0x2
800060bc:	6705                	lui	a4,0x1
800060be:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
800060c2:	02e58733          	mul	a4,a1,a4
800060c6:	97ba                	add	a5,a5,a4
800060c8:	97b2                	add	a5,a5,a2
800060ca:	6705                	lui	a4,0x1
800060cc:	97ba                	add	a5,a5,a4
800060ce:	8cd78ca3          	sb	a3,-1831(a5)

800060d2 <.L29>:
    }

    return usbd_ep_open(busid, ep) == 0 ? true : false;
800060d2:	00f14783          	lbu	a5,15(sp)
800060d6:	45a2                	lw	a1,8(sp)
800060d8:	853e                	mv	a0,a5
800060da:	690050ef          	jal	8000b76a <usbd_ep_open>
800060de:	87aa                	mv	a5,a0
800060e0:	0017b793          	seqz	a5,a5
800060e4:	0ff7f793          	zext.b	a5,a5
}
800060e8:	853e                	mv	a0,a5
800060ea:	40f2                	lw	ra,28(sp)
800060ec:	6105                	add	sp,sp,32
800060ee:	8082                	ret

Disassembly of section .text.usbd_get_descriptor:

800060f0 <usbd_get_descriptor>:
 *
 * @return true if the descriptor was found, false otherwise
 */
#ifdef CONFIG_USBDEV_ADVANCE_DESC
static bool usbd_get_descriptor(uint8_t busid, uint16_t type_index, uint8_t **data, uint32_t *len)
{
800060f0:	7139                	add	sp,sp,-64
800060f2:	de06                	sw	ra,60(sp)
800060f4:	dc22                	sw	s0,56(sp)
800060f6:	87aa                	mv	a5,a0
800060f8:	872e                	mv	a4,a1
800060fa:	c432                	sw	a2,8(sp)
800060fc:	c236                	sw	a3,4(sp)
800060fe:	00f107a3          	sb	a5,15(sp)
80006102:	87ba                	mv	a5,a4
80006104:	00f11623          	sh	a5,12(sp)
    uint8_t type = 0U;
80006108:	020100a3          	sb	zero,33(sp)
    uint8_t index = 0U;
8000610c:	02010023          	sb	zero,32(sp)
    bool found = true;
80006110:	4785                	li	a5,1
80006112:	02f107a3          	sb	a5,47(sp)
    uint32_t desc_len = 0;
80006116:	d402                	sw	zero,40(sp)
    const char *string = NULL;
80006118:	ce02                	sw	zero,28(sp)
    const uint8_t *desc = NULL;
8000611a:	d202                	sw	zero,36(sp)

    type = HI_BYTE(type_index);
8000611c:	00c15783          	lhu	a5,12(sp)
80006120:	83a1                	srl	a5,a5,0x8
80006122:	07c2                	sll	a5,a5,0x10
80006124:	83c1                	srl	a5,a5,0x10
80006126:	02f100a3          	sb	a5,33(sp)
    index = LO_BYTE(type_index);
8000612a:	00c15783          	lhu	a5,12(sp)
8000612e:	02f10023          	sb	a5,32(sp)

    switch (type) {
80006132:	02114783          	lbu	a5,33(sp)
80006136:	473d                	li	a4,15
80006138:	40f76563          	bltu	a4,a5,80006542 <.L34>
8000613c:	00279713          	sll	a4,a5,0x2
80006140:	800037b7          	lui	a5,0x80003
80006144:	27478793          	add	a5,a5,628 # 80003274 <.L36>
80006148:	97ba                	add	a5,a5,a4
8000614a:	439c                	lw	a5,0(a5)
8000614c:	8782                	jr	a5

8000614e <.L41>:
        case USB_DESCRIPTOR_TYPE_DEVICE:
            g_usbd_core[busid].speed = usbd_get_port_speed(busid); /* before we get device descriptor, we have known steady port speed */
8000614e:	00f14403          	lbu	s0,15(sp)
80006152:	00f14783          	lbu	a5,15(sp)
80006156:	853e                	mv	a0,a5
80006158:	5b4050ef          	jal	8000b70c <usbd_get_port_speed>
8000615c:	87aa                	mv	a5,a0
8000615e:	86be                	mv	a3,a5
80006160:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006164:	6785                	lui	a5,0x1
80006166:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000616a:	02f407b3          	mul	a5,s0,a5
8000616e:	97ba                	add	a5,a5,a4
80006170:	6705                	lui	a4,0x1
80006172:	97ba                	add	a5,a5,a4
80006174:	82d78123          	sb	a3,-2014(a5)
            desc = g_usbd_core[busid].descriptors->device_descriptor_callback(g_usbd_core[busid].speed);
80006178:	00f14683          	lbu	a3,15(sp)
8000617c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006180:	6785                	lui	a5,0x1
80006182:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006186:	02f687b3          	mul	a5,a3,a5
8000618a:	97ba                	add	a5,a5,a4
8000618c:	4f9c                	lw	a5,24(a5)
8000618e:	4398                	lw	a4,0(a5)
80006190:	00f14603          	lbu	a2,15(sp)
80006194:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006198:	6785                	lui	a5,0x1
8000619a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000619e:	02f607b3          	mul	a5,a2,a5
800061a2:	97b6                	add	a5,a5,a3
800061a4:	6685                	lui	a3,0x1
800061a6:	97b6                	add	a5,a5,a3
800061a8:	8227c783          	lbu	a5,-2014(a5)
800061ac:	853e                	mv	a0,a5
800061ae:	9702                	jalr	a4
800061b0:	d22a                	sw	a0,36(sp)
            if (desc == NULL) {
800061b2:	5792                	lw	a5,36(sp)
800061b4:	e781                	bnez	a5,800061bc <.L42>
                found = false;
800061b6:	020107a3          	sb	zero,47(sp)
                break;
800061ba:	a679                	j	80006548 <.L43>

800061bc <.L42>:
            }
            desc_len = desc[0];
800061bc:	5792                	lw	a5,36(sp)
800061be:	0007c783          	lbu	a5,0(a5)
800061c2:	d43e                	sw	a5,40(sp)
            break;
800061c4:	a651                	j	80006548 <.L43>

800061c6 <.L40>:
        case USB_DESCRIPTOR_TYPE_CONFIGURATION:
            desc = g_usbd_core[busid].descriptors->config_descriptor_callback(g_usbd_core[busid].speed);
800061c6:	00f14683          	lbu	a3,15(sp)
800061ca:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800061ce:	6785                	lui	a5,0x1
800061d0:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800061d4:	02f687b3          	mul	a5,a3,a5
800061d8:	97ba                	add	a5,a5,a4
800061da:	4f9c                	lw	a5,24(a5)
800061dc:	43d8                	lw	a4,4(a5)
800061de:	00f14603          	lbu	a2,15(sp)
800061e2:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
800061e6:	6785                	lui	a5,0x1
800061e8:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800061ec:	02f607b3          	mul	a5,a2,a5
800061f0:	97b6                	add	a5,a5,a3
800061f2:	6685                	lui	a3,0x1
800061f4:	97b6                	add	a5,a5,a3
800061f6:	8227c783          	lbu	a5,-2014(a5)
800061fa:	853e                	mv	a0,a5
800061fc:	9702                	jalr	a4
800061fe:	d22a                	sw	a0,36(sp)
            if (desc == NULL) {
80006200:	5792                	lw	a5,36(sp)
80006202:	e781                	bnez	a5,8000620a <.L44>
                found = false;
80006204:	020107a3          	sb	zero,47(sp)
                break;
80006208:	a681                	j	80006548 <.L43>

8000620a <.L44>:
            }
            desc_len = ((desc[CONF_DESC_wTotalLength]) | (desc[CONF_DESC_wTotalLength + 1] << 8));
8000620a:	5792                	lw	a5,36(sp)
8000620c:	0789                	add	a5,a5,2
8000620e:	0007c783          	lbu	a5,0(a5)
80006212:	873e                	mv	a4,a5
80006214:	5792                	lw	a5,36(sp)
80006216:	078d                	add	a5,a5,3
80006218:	0007c783          	lbu	a5,0(a5)
8000621c:	07a2                	sll	a5,a5,0x8
8000621e:	8fd9                	or	a5,a5,a4
80006220:	d43e                	sw	a5,40(sp)

            g_usbd_core[busid].self_powered = (desc[7] & USB_CONFIG_POWERED_MASK) ? true : false;
80006222:	5792                	lw	a5,36(sp)
80006224:	079d                	add	a5,a5,7
80006226:	0007c783          	lbu	a5,0(a5)
8000622a:	8799                	sra	a5,a5,0x6
8000622c:	8b85                	and	a5,a5,1
8000622e:	00f14603          	lbu	a2,15(sp)
80006232:	00f037b3          	snez	a5,a5
80006236:	0ff7f713          	zext.b	a4,a5
8000623a:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000623e:	6785                	lui	a5,0x1
80006240:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006244:	02f607b3          	mul	a5,a2,a5
80006248:	97b6                	add	a5,a5,a3
8000624a:	6685                	lui	a3,0x1
8000624c:	97b6                	add	a5,a5,a3
8000624e:	80e78f23          	sb	a4,-2018(a5)
            g_usbd_core[busid].remote_wakeup_support = (desc[7] & USB_CONFIG_REMOTE_WAKEUP) ? true : false;
80006252:	5792                	lw	a5,36(sp)
80006254:	079d                	add	a5,a5,7
80006256:	0007c783          	lbu	a5,0(a5)
8000625a:	8795                	sra	a5,a5,0x5
8000625c:	8b85                	and	a5,a5,1
8000625e:	00f14603          	lbu	a2,15(sp)
80006262:	00f037b3          	snez	a5,a5
80006266:	0ff7f713          	zext.b	a4,a5
8000626a:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000626e:	6785                	lui	a5,0x1
80006270:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006274:	02f607b3          	mul	a5,a2,a5
80006278:	97b6                	add	a5,a5,a3
8000627a:	6685                	lui	a3,0x1
8000627c:	97b6                	add	a5,a5,a3
8000627e:	80e78fa3          	sb	a4,-2017(a5)
            break;
80006282:	a4d9                	j	80006548 <.L43>

80006284 <.L39>:
        case USB_DESCRIPTOR_TYPE_STRING:
            if (index == USB_OSDESC_STRING_DESC_INDEX) {
80006284:	02014703          	lbu	a4,32(sp)
80006288:	0ee00793          	li	a5,238
8000628c:	06f71163          	bne	a4,a5,800062ee <.L45>
                if (!g_usbd_core[busid].descriptors->msosv1_descriptor) {
80006290:	00f14683          	lbu	a3,15(sp)
80006294:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006298:	6785                	lui	a5,0x1
8000629a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000629e:	02f687b3          	mul	a5,a3,a5
800062a2:	97ba                	add	a5,a5,a4
800062a4:	4f9c                	lw	a5,24(a5)
800062a6:	4bdc                	lw	a5,20(a5)
800062a8:	e781                	bnez	a5,800062b0 <.L46>
                    found = false;
800062aa:	020107a3          	sb	zero,47(sp)
                    break;
800062ae:	ac69                	j	80006548 <.L43>

800062b0 <.L46>:
                }

                desc = (uint8_t *)g_usbd_core[busid].descriptors->msosv1_descriptor->string;
800062b0:	00f14683          	lbu	a3,15(sp)
800062b4:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800062b8:	6785                	lui	a5,0x1
800062ba:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800062be:	02f687b3          	mul	a5,a3,a5
800062c2:	97ba                	add	a5,a5,a4
800062c4:	4f9c                	lw	a5,24(a5)
800062c6:	4bdc                	lw	a5,20(a5)
800062c8:	439c                	lw	a5,0(a5)
800062ca:	d23e                	sw	a5,36(sp)
                desc_len = g_usbd_core[busid].descriptors->msosv1_descriptor->string[0];
800062cc:	00f14683          	lbu	a3,15(sp)
800062d0:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800062d4:	6785                	lui	a5,0x1
800062d6:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800062da:	02f687b3          	mul	a5,a3,a5
800062de:	97ba                	add	a5,a5,a4
800062e0:	4f9c                	lw	a5,24(a5)
800062e2:	4bdc                	lw	a5,20(a5)
800062e4:	439c                	lw	a5,0(a5)
800062e6:	0007c783          	lbu	a5,0(a5)
800062ea:	d43e                	sw	a5,40(sp)
                }

                *len = total_size;
                return true;
            }
            break;
800062ec:	acb1                	j	80006548 <.L43>

800062ee <.L45>:
                string = g_usbd_core[busid].descriptors->string_descriptor_callback(g_usbd_core[busid].speed, index);
800062ee:	00f14683          	lbu	a3,15(sp)
800062f2:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800062f6:	6785                	lui	a5,0x1
800062f8:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800062fc:	02f687b3          	mul	a5,a3,a5
80006300:	97ba                	add	a5,a5,a4
80006302:	4f9c                	lw	a5,24(a5)
80006304:	4b98                	lw	a4,16(a5)
80006306:	00f14603          	lbu	a2,15(sp)
8000630a:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000630e:	6785                	lui	a5,0x1
80006310:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006314:	02f607b3          	mul	a5,a2,a5
80006318:	97b6                	add	a5,a5,a3
8000631a:	6685                	lui	a3,0x1
8000631c:	97b6                	add	a5,a5,a3
8000631e:	8227c783          	lbu	a5,-2014(a5)
80006322:	02014683          	lbu	a3,32(sp)
80006326:	85b6                	mv	a1,a3
80006328:	853e                	mv	a0,a5
8000632a:	9702                	jalr	a4
8000632c:	ce2a                	sw	a0,28(sp)
                if (string == NULL) {
8000632e:	47f2                	lw	a5,28(sp)
80006330:	e781                	bnez	a5,80006338 <.L48>
                    found = false;
80006332:	020107a3          	sb	zero,47(sp)
                    break;
80006336:	ac09                	j	80006548 <.L43>

80006338 <.L48>:
                if (index == USB_STRING_LANGID_INDEX) {
80006338:	02014783          	lbu	a5,32(sp)
8000633c:	e3b9                	bnez	a5,80006382 <.L49>
                    (*data)[0] = 4;
8000633e:	47a2                	lw	a5,8(sp)
80006340:	439c                	lw	a5,0(a5)
80006342:	4711                	li	a4,4
80006344:	00e78023          	sb	a4,0(a5)
                    (*data)[1] = USB_DESCRIPTOR_TYPE_STRING;
80006348:	47a2                	lw	a5,8(sp)
8000634a:	439c                	lw	a5,0(a5)
8000634c:	0785                	add	a5,a5,1
8000634e:	470d                	li	a4,3
80006350:	00e78023          	sb	a4,0(a5)
                    (*data)[2] = string[0];
80006354:	47a2                	lw	a5,8(sp)
80006356:	439c                	lw	a5,0(a5)
80006358:	0789                	add	a5,a5,2
8000635a:	4772                	lw	a4,28(sp)
8000635c:	00074703          	lbu	a4,0(a4) # 1000 <__fw_size__>
80006360:	00e78023          	sb	a4,0(a5)
                    (*data)[3] = string[1];
80006364:	47f2                	lw	a5,28(sp)
80006366:	00178713          	add	a4,a5,1
8000636a:	47a2                	lw	a5,8(sp)
8000636c:	439c                	lw	a5,0(a5)
8000636e:	078d                	add	a5,a5,3
80006370:	00074703          	lbu	a4,0(a4)
80006374:	00e78023          	sb	a4,0(a5)
                    *len = 4;
80006378:	4792                	lw	a5,4(sp)
8000637a:	4711                	li	a4,4
8000637c:	c398                	sw	a4,0(a5)
                    return true;
8000637e:	4785                	li	a5,1
80006380:	a431                	j	8000658c <.L50>

80006382 <.L49>:
                uint16_t str_size = strlen(string);
80006382:	4572                	lw	a0,28(sp)
80006384:	377060ef          	jal	8000cefa <strlen>
80006388:	87aa                	mv	a5,a0
8000638a:	00f11d23          	sh	a5,26(sp)
                uint16_t total_size = 2 * str_size + 2;
8000638e:	01a15783          	lhu	a5,26(sp)
80006392:	0785                	add	a5,a5,1
80006394:	07c2                	sll	a5,a5,0x10
80006396:	83c1                	srl	a5,a5,0x10
80006398:	0786                	sll	a5,a5,0x1
8000639a:	00f11c23          	sh	a5,24(sp)
                if (total_size > CONFIG_USBDEV_REQUEST_BUFFER_LEN) {
8000639e:	01815703          	lhu	a4,24(sp)
800063a2:	6785                	lui	a5,0x1
800063a4:	80078793          	add	a5,a5,-2048 # 800 <.L133+0x14>
800063a8:	02e7f063          	bgeu	a5,a4,800063c8 <.L51>
                    USB_LOG_ERR("string size overflow\r\n");
800063ac:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
800063b0:	09e030ef          	jal	8000944e <printf>
800063b4:	5e820513          	add	a0,tp,1512 # 5e8 <.L128+0x34>
800063b8:	096030ef          	jal	8000944e <printf>
800063bc:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
800063c0:	08e030ef          	jal	8000944e <printf>
                    return false;
800063c4:	4781                	li	a5,0
800063c6:	a2d9                	j	8000658c <.L50>

800063c8 <.L51>:
                (*data)[0] = total_size;
800063c8:	47a2                	lw	a5,8(sp)
800063ca:	439c                	lw	a5,0(a5)
800063cc:	01815703          	lhu	a4,24(sp)
800063d0:	0ff77713          	zext.b	a4,a4
800063d4:	00e78023          	sb	a4,0(a5)
                (*data)[1] = USB_DESCRIPTOR_TYPE_STRING;
800063d8:	47a2                	lw	a5,8(sp)
800063da:	439c                	lw	a5,0(a5)
800063dc:	0785                	add	a5,a5,1
800063de:	470d                	li	a4,3
800063e0:	00e78023          	sb	a4,0(a5)

800063e4 <.LBB3>:
                for (uint16_t i = 0; i < str_size; i++) {
800063e4:	02011123          	sh	zero,34(sp)
800063e8:	a835                	j	80006424 <.L52>

800063ea <.L53>:
                    (*data)[2 * i + 2] = string[i];
800063ea:	02215783          	lhu	a5,34(sp)
800063ee:	4772                	lw	a4,28(sp)
800063f0:	973e                	add	a4,a4,a5
800063f2:	47a2                	lw	a5,8(sp)
800063f4:	4394                	lw	a3,0(a5)
800063f6:	02215783          	lhu	a5,34(sp)
800063fa:	0786                	sll	a5,a5,0x1
800063fc:	0789                	add	a5,a5,2
800063fe:	97b6                	add	a5,a5,a3
80006400:	00074703          	lbu	a4,0(a4)
80006404:	00e78023          	sb	a4,0(a5)
                    (*data)[2 * i + 3] = 0x00;
80006408:	47a2                	lw	a5,8(sp)
8000640a:	4398                	lw	a4,0(a5)
8000640c:	02215783          	lhu	a5,34(sp)
80006410:	0786                	sll	a5,a5,0x1
80006412:	078d                	add	a5,a5,3
80006414:	97ba                	add	a5,a5,a4
80006416:	00078023          	sb	zero,0(a5)
                for (uint16_t i = 0; i < str_size; i++) {
8000641a:	02215783          	lhu	a5,34(sp)
8000641e:	0785                	add	a5,a5,1
80006420:	02f11123          	sh	a5,34(sp)

80006424 <.L52>:
80006424:	02215703          	lhu	a4,34(sp)
80006428:	01a15783          	lhu	a5,26(sp)
8000642c:	faf76fe3          	bltu	a4,a5,800063ea <.L53>

80006430 <.LBE3>:
                *len = total_size;
80006430:	01815703          	lhu	a4,24(sp)
80006434:	4792                	lw	a5,4(sp)
80006436:	c398                	sw	a4,0(a5)
                return true;
80006438:	4785                	li	a5,1
8000643a:	aa89                	j	8000658c <.L50>

8000643c <.L38>:
        case USB_DESCRIPTOR_TYPE_DEVICE_QUALIFIER:
#ifndef CONFIG_USB_HS
            return false;
#else
            desc = g_usbd_core[busid].descriptors->device_quality_descriptor_callback(g_usbd_core[busid].speed);
8000643c:	00f14683          	lbu	a3,15(sp)
80006440:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006444:	6785                	lui	a5,0x1
80006446:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000644a:	02f687b3          	mul	a5,a3,a5
8000644e:	97ba                	add	a5,a5,a4
80006450:	4f9c                	lw	a5,24(a5)
80006452:	4798                	lw	a4,8(a5)
80006454:	00f14603          	lbu	a2,15(sp)
80006458:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000645c:	6785                	lui	a5,0x1
8000645e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006462:	02f607b3          	mul	a5,a2,a5
80006466:	97b6                	add	a5,a5,a3
80006468:	6685                	lui	a3,0x1
8000646a:	97b6                	add	a5,a5,a3
8000646c:	8227c783          	lbu	a5,-2014(a5)
80006470:	853e                	mv	a0,a5
80006472:	9702                	jalr	a4
80006474:	d22a                	sw	a0,36(sp)
            if (desc == NULL) {
80006476:	5792                	lw	a5,36(sp)
80006478:	e781                	bnez	a5,80006480 <.L54>
                found = false;
8000647a:	020107a3          	sb	zero,47(sp)
                break;
8000647e:	a0e9                	j	80006548 <.L43>

80006480 <.L54>:
            }
            desc_len = desc[0];
80006480:	5792                	lw	a5,36(sp)
80006482:	0007c783          	lbu	a5,0(a5)
80006486:	d43e                	sw	a5,40(sp)
            break;
80006488:	a0c1                	j	80006548 <.L43>

8000648a <.L37>:
#endif
        case USB_DESCRIPTOR_TYPE_OTHER_SPEED:
            desc = g_usbd_core[busid].descriptors->other_speed_descriptor_callback(g_usbd_core[busid].speed);
8000648a:	00f14683          	lbu	a3,15(sp)
8000648e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006492:	6785                	lui	a5,0x1
80006494:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006498:	02f687b3          	mul	a5,a3,a5
8000649c:	97ba                	add	a5,a5,a4
8000649e:	4f9c                	lw	a5,24(a5)
800064a0:	47d8                	lw	a4,12(a5)
800064a2:	00f14603          	lbu	a2,15(sp)
800064a6:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
800064aa:	6785                	lui	a5,0x1
800064ac:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800064b0:	02f607b3          	mul	a5,a2,a5
800064b4:	97b6                	add	a5,a5,a3
800064b6:	6685                	lui	a3,0x1
800064b8:	97b6                	add	a5,a5,a3
800064ba:	8227c783          	lbu	a5,-2014(a5)
800064be:	853e                	mv	a0,a5
800064c0:	9702                	jalr	a4
800064c2:	d22a                	sw	a0,36(sp)
            if (desc == NULL) {
800064c4:	5792                	lw	a5,36(sp)
800064c6:	e781                	bnez	a5,800064ce <.L55>
                found = false;
800064c8:	020107a3          	sb	zero,47(sp)
                break;
800064cc:	a8b5                	j	80006548 <.L43>

800064ce <.L55>:
            }
            desc_len = ((desc[CONF_DESC_wTotalLength]) | (desc[CONF_DESC_wTotalLength + 1] << 8));
800064ce:	5792                	lw	a5,36(sp)
800064d0:	0789                	add	a5,a5,2
800064d2:	0007c783          	lbu	a5,0(a5)
800064d6:	873e                	mv	a4,a5
800064d8:	5792                	lw	a5,36(sp)
800064da:	078d                	add	a5,a5,3
800064dc:	0007c783          	lbu	a5,0(a5)
800064e0:	07a2                	sll	a5,a5,0x8
800064e2:	8fd9                	or	a5,a5,a4
800064e4:	d43e                	sw	a5,40(sp)
            break;
800064e6:	a08d                	j	80006548 <.L43>

800064e8 <.L35>:

        case USB_DESCRIPTOR_TYPE_BINARY_OBJECT_STORE:
            if (!g_usbd_core[busid].descriptors->bos_descriptor) {
800064e8:	00f14683          	lbu	a3,15(sp)
800064ec:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800064f0:	6785                	lui	a5,0x1
800064f2:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800064f6:	02f687b3          	mul	a5,a3,a5
800064fa:	97ba                	add	a5,a5,a4
800064fc:	4f9c                	lw	a5,24(a5)
800064fe:	539c                	lw	a5,32(a5)
80006500:	e781                	bnez	a5,80006508 <.L56>
                found = false;
80006502:	020107a3          	sb	zero,47(sp)
                break;
80006506:	a089                	j	80006548 <.L43>

80006508 <.L56>:
            }

            desc = (uint8_t *)g_usbd_core[busid].descriptors->bos_descriptor->string;
80006508:	00f14683          	lbu	a3,15(sp)
8000650c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006510:	6785                	lui	a5,0x1
80006512:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006516:	02f687b3          	mul	a5,a3,a5
8000651a:	97ba                	add	a5,a5,a4
8000651c:	4f9c                	lw	a5,24(a5)
8000651e:	539c                	lw	a5,32(a5)
80006520:	439c                	lw	a5,0(a5)
80006522:	d23e                	sw	a5,36(sp)
            desc_len = g_usbd_core[busid].descriptors->bos_descriptor->string_len;
80006524:	00f14683          	lbu	a3,15(sp)
80006528:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000652c:	6785                	lui	a5,0x1
8000652e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006532:	02f687b3          	mul	a5,a3,a5
80006536:	97ba                	add	a5,a5,a4
80006538:	4f9c                	lw	a5,24(a5)
8000653a:	539c                	lw	a5,32(a5)
8000653c:	43dc                	lw	a5,4(a5)
8000653e:	d43e                	sw	a5,40(sp)
            break;
80006540:	a021                	j	80006548 <.L43>

80006542 <.L34>:

        default:
            found = false;
80006542:	020107a3          	sb	zero,47(sp)
            break;
80006546:	0001                	nop

80006548 <.L43>:
    }

    if (found == false) {
80006548:	02f14783          	lbu	a5,47(sp)
8000654c:	0017c793          	xor	a5,a5,1
80006550:	0ff7f793          	zext.b	a5,a5
80006554:	c785                	beqz	a5,8000657c <.L57>
        /* nothing found */
        USB_LOG_ERR("descriptor <type:%x,index:%x> not found!\r\n", type, index);
80006556:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
8000655a:	6f5020ef          	jal	8000944e <printf>
8000655e:	02114783          	lbu	a5,33(sp)
80006562:	02014703          	lbu	a4,32(sp)
80006566:	863a                	mv	a2,a4
80006568:	85be                	mv	a1,a5
8000656a:	60020513          	add	a0,tp,1536 # 600 <.L143+0x6>
8000656e:	6e1020ef          	jal	8000944e <printf>
80006572:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
80006576:	6d9020ef          	jal	8000944e <printf>
8000657a:	a039                	j	80006588 <.L58>

8000657c <.L57>:
    } else {
        *data = (uint8_t *)desc;
8000657c:	47a2                	lw	a5,8(sp)
8000657e:	5712                	lw	a4,36(sp)
80006580:	c398                	sw	a4,0(a5)
        //memcpy(*data, desc, desc_len);
        *len = desc_len;
80006582:	4792                	lw	a5,4(sp)
80006584:	5722                	lw	a4,40(sp)
80006586:	c398                	sw	a4,0(a5)

80006588 <.L58>:
    }
    return found;
80006588:	02f14783          	lbu	a5,47(sp)

8000658c <.L50>:
}
8000658c:	853e                	mv	a0,a5
8000658e:	50f2                	lw	ra,60(sp)
80006590:	5462                	lw	s0,56(sp)
80006592:	6121                	add	sp,sp,64
80006594:	8082                	ret

Disassembly of section .text.usbd_set_configuration:

80006596 <usbd_set_configuration>:
 * @param [in] alt_setting  Alternate setting number
 *
 * @return true if successfully configured false if error or unconfigured
 */
static bool usbd_set_configuration(uint8_t busid, uint8_t config_index, uint8_t alt_setting)
{
80006596:	7179                	add	sp,sp,-48
80006598:	d606                	sw	ra,44(sp)
8000659a:	87aa                	mv	a5,a0
8000659c:	86ae                	mv	a3,a1
8000659e:	8732                	mv	a4,a2
800065a0:	00f107a3          	sb	a5,15(sp)
800065a4:	87b6                	mv	a5,a3
800065a6:	00f10723          	sb	a5,14(sp)
800065aa:	87ba                	mv	a5,a4
800065ac:	00f106a3          	sb	a5,13(sp)
    uint8_t cur_alt_setting = 0xFF;
800065b0:	57fd                	li	a5,-1
800065b2:	00f10fa3          	sb	a5,31(sp)
    uint8_t cur_config = 0xFF;
800065b6:	57fd                	li	a5,-1
800065b8:	00f10f23          	sb	a5,30(sp)
    bool found = false;
800065bc:	00010ea3          	sb	zero,29(sp)
    const uint8_t *p;
    uint32_t desc_len = 0;
800065c0:	ca02                	sw	zero,20(sp)
    uint32_t current_desc_len = 0;
800065c2:	c802                	sw	zero,16(sp)

#ifdef CONFIG_USBDEV_ADVANCE_DESC
    p = g_usbd_core[busid].descriptors->config_descriptor_callback(g_usbd_core[busid].speed);
800065c4:	00f14683          	lbu	a3,15(sp)
800065c8:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800065cc:	6785                	lui	a5,0x1
800065ce:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800065d2:	02f687b3          	mul	a5,a3,a5
800065d6:	97ba                	add	a5,a5,a4
800065d8:	4f9c                	lw	a5,24(a5)
800065da:	43d8                	lw	a4,4(a5)
800065dc:	00f14603          	lbu	a2,15(sp)
800065e0:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
800065e4:	6785                	lui	a5,0x1
800065e6:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800065ea:	02f607b3          	mul	a5,a2,a5
800065ee:	97b6                	add	a5,a5,a3
800065f0:	6685                	lui	a3,0x1
800065f2:	97b6                	add	a5,a5,a3
800065f4:	8227c783          	lbu	a5,-2014(a5)
800065f8:	853e                	mv	a0,a5
800065fa:	9702                	jalr	a4
800065fc:	cc2a                	sw	a0,24(sp)
#else
    p = (uint8_t *)g_usbd_core[busid].descriptors;
#endif
    /* configure endpoints for this configuration/altsetting */
    while (p[DESC_bLength] != 0U) {
800065fe:	a0d1                	j	800066c2 <.L60>

80006600 <.L68>:
        switch (p[DESC_bDescriptorType]) {
80006600:	47e2                	lw	a5,24(sp)
80006602:	0785                	add	a5,a5,1
80006604:	0007c783          	lbu	a5,0(a5)
80006608:	4715                	li	a4,5
8000660a:	06e78063          	beq	a5,a4,8000666a <.L61>
8000660e:	4715                	li	a4,5
80006610:	08f74263          	blt	a4,a5,80006694 <.L70>
80006614:	4709                	li	a4,2
80006616:	00e78663          	beq	a5,a4,80006622 <.L63>
8000661a:	4711                	li	a4,4
8000661c:	04e78063          	beq	a5,a4,8000665c <.L64>

                found = usbd_set_endpoint(busid, (struct usb_endpoint_descriptor *)p);
                break;

            default:
                break;
80006620:	a895                	j	80006694 <.L70>

80006622 <.L63>:
                cur_config = p[CONF_DESC_bConfigurationValue];
80006622:	47e2                	lw	a5,24(sp)
80006624:	0795                	add	a5,a5,5
80006626:	0007c783          	lbu	a5,0(a5)
8000662a:	00f10f23          	sb	a5,30(sp)
                if (cur_config == config_index) {
8000662e:	01e14703          	lbu	a4,30(sp)
80006632:	00e14783          	lbu	a5,14(sp)
80006636:	06f71163          	bne	a4,a5,80006698 <.L71>
                    found = true;
8000663a:	4785                	li	a5,1
8000663c:	00f10ea3          	sb	a5,29(sp)
                    current_desc_len = 0;
80006640:	c802                	sw	zero,16(sp)
                    desc_len = (p[CONF_DESC_wTotalLength]) |
80006642:	47e2                	lw	a5,24(sp)
80006644:	0789                	add	a5,a5,2
80006646:	0007c783          	lbu	a5,0(a5)
8000664a:	873e                	mv	a4,a5
                               (p[CONF_DESC_wTotalLength + 1] << 8);
8000664c:	47e2                	lw	a5,24(sp)
8000664e:	078d                	add	a5,a5,3
80006650:	0007c783          	lbu	a5,0(a5)
80006654:	07a2                	sll	a5,a5,0x8
                    desc_len = (p[CONF_DESC_wTotalLength]) |
80006656:	8fd9                	or	a5,a5,a4
80006658:	ca3e                	sw	a5,20(sp)
                break;
8000665a:	a83d                	j	80006698 <.L71>

8000665c <.L64>:
                    p[INTF_DESC_bAlternateSetting];
8000665c:	47e2                	lw	a5,24(sp)
8000665e:	078d                	add	a5,a5,3
                cur_alt_setting =
80006660:	0007c783          	lbu	a5,0(a5)
80006664:	00f10fa3          	sb	a5,31(sp)
                break;
80006668:	a80d                	j	8000669a <.L66>

8000666a <.L61>:
                if ((cur_config != config_index) ||
8000666a:	01e14703          	lbu	a4,30(sp)
8000666e:	00e14783          	lbu	a5,14(sp)
80006672:	02f71463          	bne	a4,a5,8000669a <.L66>
80006676:	01f14703          	lbu	a4,31(sp)
8000667a:	00d14783          	lbu	a5,13(sp)
8000667e:	00f71e63          	bne	a4,a5,8000669a <.L66>
                found = usbd_set_endpoint(busid, (struct usb_endpoint_descriptor *)p);
80006682:	00f14783          	lbu	a5,15(sp)
80006686:	45e2                	lw	a1,24(sp)
80006688:	853e                	mv	a0,a5
8000668a:	38e5                	jal	80005f82 <usbd_set_endpoint>
8000668c:	87aa                	mv	a5,a0
8000668e:	00f10ea3          	sb	a5,29(sp)
                break;
80006692:	a021                	j	8000669a <.L66>

80006694 <.L70>:
                break;
80006694:	0001                	nop
80006696:	a011                	j	8000669a <.L66>

80006698 <.L71>:
                break;
80006698:	0001                	nop

8000669a <.L66>:
        }

        /* skip to next descriptor */
        p += p[DESC_bLength];
8000669a:	47e2                	lw	a5,24(sp)
8000669c:	0007c783          	lbu	a5,0(a5)
800066a0:	873e                	mv	a4,a5
800066a2:	47e2                	lw	a5,24(sp)
800066a4:	97ba                	add	a5,a5,a4
800066a6:	cc3e                	sw	a5,24(sp)
        current_desc_len += p[DESC_bLength];
800066a8:	47e2                	lw	a5,24(sp)
800066aa:	0007c783          	lbu	a5,0(a5)
800066ae:	873e                	mv	a4,a5
800066b0:	47c2                	lw	a5,16(sp)
800066b2:	97ba                	add	a5,a5,a4
800066b4:	c83e                	sw	a5,16(sp)
        if (current_desc_len >= desc_len && desc_len) {
800066b6:	4742                	lw	a4,16(sp)
800066b8:	47d2                	lw	a5,20(sp)
800066ba:	00f76463          	bltu	a4,a5,800066c2 <.L60>
800066be:	47d2                	lw	a5,20(sp)
800066c0:	e791                	bnez	a5,800066cc <.L72>

800066c2 <.L60>:
    while (p[DESC_bLength] != 0U) {
800066c2:	47e2                	lw	a5,24(sp)
800066c4:	0007c783          	lbu	a5,0(a5)
800066c8:	ff85                	bnez	a5,80006600 <.L68>
800066ca:	a011                	j	800066ce <.L67>

800066cc <.L72>:
            break;
800066cc:	0001                	nop

800066ce <.L67>:
        }
    }

    return found;
800066ce:	01d14783          	lbu	a5,29(sp)
}
800066d2:	853e                	mv	a0,a5
800066d4:	50b2                	lw	ra,44(sp)
800066d6:	6145                	add	sp,sp,48
800066d8:	8082                	ret

Disassembly of section .text.usbd_set_interface:

800066da <usbd_set_interface>:
 * @param [in] alt_setting  Alternate setting number
 *
 * @return true if successfully configured false if error or unconfigured
 */
static bool usbd_set_interface(uint8_t busid, uint8_t iface, uint8_t alt_setting)
{
800066da:	7139                	add	sp,sp,-64
800066dc:	de06                	sw	ra,60(sp)
800066de:	87aa                	mv	a5,a0
800066e0:	86ae                	mv	a3,a1
800066e2:	8732                	mv	a4,a2
800066e4:	00f107a3          	sb	a5,15(sp)
800066e8:	87b6                	mv	a5,a3
800066ea:	00f10723          	sb	a5,14(sp)
800066ee:	87ba                	mv	a5,a4
800066f0:	00f106a3          	sb	a5,13(sp)
    const uint8_t *if_desc = NULL;
800066f4:	d602                	sw	zero,44(sp)
    struct usb_endpoint_descriptor *ep_desc;
    uint8_t cur_alt_setting = 0xFF;
800066f6:	57fd                	li	a5,-1
800066f8:	02f105a3          	sb	a5,43(sp)
    uint8_t cur_iface = 0xFF;
800066fc:	57fd                	li	a5,-1
800066fe:	02f10523          	sb	a5,42(sp)
    bool ret = false;
80006702:	020104a3          	sb	zero,41(sp)
    const uint8_t *p;
    uint32_t desc_len = 0;
80006706:	d002                	sw	zero,32(sp)
    uint32_t current_desc_len = 0;
80006708:	ce02                	sw	zero,28(sp)

#ifdef CONFIG_USBDEV_ADVANCE_DESC
    p = g_usbd_core[busid].descriptors->config_descriptor_callback(g_usbd_core[busid].speed);
8000670a:	00f14683          	lbu	a3,15(sp)
8000670e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006712:	6785                	lui	a5,0x1
80006714:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006718:	02f687b3          	mul	a5,a3,a5
8000671c:	97ba                	add	a5,a5,a4
8000671e:	4f9c                	lw	a5,24(a5)
80006720:	43d8                	lw	a4,4(a5)
80006722:	00f14603          	lbu	a2,15(sp)
80006726:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000672a:	6785                	lui	a5,0x1
8000672c:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006730:	02f607b3          	mul	a5,a2,a5
80006734:	97b6                	add	a5,a5,a3
80006736:	6685                	lui	a3,0x1
80006738:	97b6                	add	a5,a5,a3
8000673a:	8227c783          	lbu	a5,-2014(a5)
8000673e:	853e                	mv	a0,a5
80006740:	9702                	jalr	a4
80006742:	d22a                	sw	a0,36(sp)
#else
    p = (uint8_t *)g_usbd_core[busid].descriptors;
#endif
    USB_LOG_DBG("iface %u alt_setting %u\r\n", iface, alt_setting);

    while (p[DESC_bLength] != 0U) {
80006744:	a8cd                	j	80006836 <.L74>

80006746 <.L84>:
        switch (p[DESC_bDescriptorType]) {
80006746:	5792                	lw	a5,36(sp)
80006748:	0785                	add	a5,a5,1
8000674a:	0007c783          	lbu	a5,0(a5)
8000674e:	4715                	li	a4,5
80006750:	06e78563          	beq	a5,a4,800067ba <.L75>
80006754:	4715                	li	a4,5
80006756:	0af74763          	blt	a4,a5,80006804 <.L86>
8000675a:	4709                	li	a4,2
8000675c:	00e78663          	beq	a5,a4,80006768 <.L77>
80006760:	4711                	li	a4,4
80006762:	02e78163          	beq	a5,a4,80006784 <.L78>
                }

                break;

            default:
                break;
80006766:	a879                	j	80006804 <.L86>

80006768 <.L77>:
                current_desc_len = 0;
80006768:	ce02                	sw	zero,28(sp)
                desc_len = (p[CONF_DESC_wTotalLength]) |
8000676a:	5792                	lw	a5,36(sp)
8000676c:	0789                	add	a5,a5,2
8000676e:	0007c783          	lbu	a5,0(a5)
80006772:	873e                	mv	a4,a5
                           (p[CONF_DESC_wTotalLength + 1] << 8);
80006774:	5792                	lw	a5,36(sp)
80006776:	078d                	add	a5,a5,3
80006778:	0007c783          	lbu	a5,0(a5)
8000677c:	07a2                	sll	a5,a5,0x8
                desc_len = (p[CONF_DESC_wTotalLength]) |
8000677e:	8fd9                	or	a5,a5,a4
80006780:	d03e                	sw	a5,32(sp)
                break;
80006782:	a071                	j	8000680e <.L79>

80006784 <.L78>:
                cur_alt_setting = p[INTF_DESC_bAlternateSetting];
80006784:	5792                	lw	a5,36(sp)
80006786:	078d                	add	a5,a5,3
80006788:	0007c783          	lbu	a5,0(a5)
8000678c:	02f105a3          	sb	a5,43(sp)
                cur_iface = p[INTF_DESC_bInterfaceNumber];
80006790:	5792                	lw	a5,36(sp)
80006792:	0789                	add	a5,a5,2
80006794:	0007c783          	lbu	a5,0(a5)
80006798:	02f10523          	sb	a5,42(sp)
                if (cur_iface == iface &&
8000679c:	02a14703          	lbu	a4,42(sp)
800067a0:	00e14783          	lbu	a5,14(sp)
800067a4:	06f71263          	bne	a4,a5,80006808 <.L87>
800067a8:	02b14703          	lbu	a4,43(sp)
800067ac:	00d14783          	lbu	a5,13(sp)
800067b0:	04f71c63          	bne	a4,a5,80006808 <.L87>
                    if_desc = (void *)p;
800067b4:	5792                	lw	a5,36(sp)
800067b6:	d63e                	sw	a5,44(sp)
                break;
800067b8:	a881                	j	80006808 <.L87>

800067ba <.L75>:
                if (cur_iface == iface) {
800067ba:	02a14703          	lbu	a4,42(sp)
800067be:	00e14783          	lbu	a5,14(sp)
800067c2:	04f71563          	bne	a4,a5,8000680c <.L88>
                    ep_desc = (struct usb_endpoint_descriptor *)p;
800067c6:	5792                	lw	a5,36(sp)
800067c8:	cc3e                	sw	a5,24(sp)
                    if (alt_setting == 0) {
800067ca:	00d14783          	lbu	a5,13(sp)
800067ce:	eb99                	bnez	a5,800067e4 <.L82>
                        ret = usbd_reset_endpoint(busid, ep_desc);
800067d0:	00f14783          	lbu	a5,15(sp)
800067d4:	45e2                	lw	a1,24(sp)
800067d6:	853e                	mv	a0,a5
800067d8:	3ca040ef          	jal	8000aba2 <usbd_reset_endpoint>
800067dc:	87aa                	mv	a5,a0
800067de:	02f104a3          	sb	a5,41(sp)
                        goto find_end;
800067e2:	a085                	j	80006842 <.L83>

800067e4 <.L82>:
                    } else if (cur_alt_setting == alt_setting) {
800067e4:	02b14703          	lbu	a4,43(sp)
800067e8:	00d14783          	lbu	a5,13(sp)
800067ec:	02f71063          	bne	a4,a5,8000680c <.L88>
                        ret = usbd_set_endpoint(busid, ep_desc);
800067f0:	00f14783          	lbu	a5,15(sp)
800067f4:	45e2                	lw	a1,24(sp)
800067f6:	853e                	mv	a0,a5
800067f8:	f8aff0ef          	jal	80005f82 <usbd_set_endpoint>
800067fc:	87aa                	mv	a5,a0
800067fe:	02f104a3          	sb	a5,41(sp)
                        goto find_end;
80006802:	a081                	j	80006842 <.L83>

80006804 <.L86>:
                break;
80006804:	0001                	nop
80006806:	a021                	j	8000680e <.L79>

80006808 <.L87>:
                break;
80006808:	0001                	nop
8000680a:	a011                	j	8000680e <.L79>

8000680c <.L88>:
                break;
8000680c:	0001                	nop

8000680e <.L79>:
        }

        /* skip to next descriptor */
        p += p[DESC_bLength];
8000680e:	5792                	lw	a5,36(sp)
80006810:	0007c783          	lbu	a5,0(a5)
80006814:	873e                	mv	a4,a5
80006816:	5792                	lw	a5,36(sp)
80006818:	97ba                	add	a5,a5,a4
8000681a:	d23e                	sw	a5,36(sp)
        current_desc_len += p[DESC_bLength];
8000681c:	5792                	lw	a5,36(sp)
8000681e:	0007c783          	lbu	a5,0(a5)
80006822:	873e                	mv	a4,a5
80006824:	47f2                	lw	a5,28(sp)
80006826:	97ba                	add	a5,a5,a4
80006828:	ce3e                	sw	a5,28(sp)
        if (current_desc_len >= desc_len && desc_len) {
8000682a:	4772                	lw	a4,28(sp)
8000682c:	5782                	lw	a5,32(sp)
8000682e:	00f76463          	bltu	a4,a5,80006836 <.L74>
80006832:	5782                	lw	a5,32(sp)
80006834:	e791                	bnez	a5,80006840 <.L89>

80006836 <.L74>:
    while (p[DESC_bLength] != 0U) {
80006836:	5792                	lw	a5,36(sp)
80006838:	0007c783          	lbu	a5,0(a5)
8000683c:	f789                	bnez	a5,80006746 <.L84>
            break;
        }
    }

find_end:
8000683e:	a011                	j	80006842 <.L83>

80006840 <.L89>:
            break;
80006840:	0001                	nop

80006842 <.L83>:
    usbd_class_event_notify_handler(busid, USBD_EVENT_SET_INTERFACE, (void *)if_desc);
80006842:	00f14783          	lbu	a5,15(sp)
80006846:	5632                	lw	a2,44(sp)
80006848:	45a1                	li	a1,8
8000684a:	853e                	mv	a0,a5
8000684c:	24d000ef          	jal	80007298 <usbd_class_event_notify_handler>

    return ret;
80006850:	02914783          	lbu	a5,41(sp)
}
80006854:	853e                	mv	a0,a5
80006856:	50f2                	lw	ra,60(sp)
80006858:	6121                	add	sp,sp,64
8000685a:	8082                	ret

Disassembly of section .text.usbd_std_device_req_handler:

8000685c <usbd_std_device_req_handler>:
 * @param [in,out] len      Pointer to data length
 *
 * @return true if the request was handled successfully
 */
static bool usbd_std_device_req_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
8000685c:	7179                	add	sp,sp,-48
8000685e:	d606                	sw	ra,44(sp)
80006860:	87aa                	mv	a5,a0
80006862:	c42e                	sw	a1,8(sp)
80006864:	c232                	sw	a2,4(sp)
80006866:	c036                	sw	a3,0(sp)
80006868:	00f107a3          	sb	a5,15(sp)
    uint16_t value = setup->wValue;
8000686c:	47a2                	lw	a5,8(sp)
8000686e:	0027c703          	lbu	a4,2(a5)
80006872:	0037c783          	lbu	a5,3(a5)
80006876:	07a2                	sll	a5,a5,0x8
80006878:	8fd9                	or	a5,a5,a4
8000687a:	00f11e23          	sh	a5,28(sp)
    bool ret = true;
8000687e:	4785                	li	a5,1
80006880:	00f10fa3          	sb	a5,31(sp)

    switch (setup->bRequest) {
80006884:	47a2                	lw	a5,8(sp)
80006886:	0017c783          	lbu	a5,1(a5)
8000688a:	472d                	li	a4,11
8000688c:	2cf76863          	bltu	a4,a5,80006b5c <.L91>
80006890:	00279713          	sll	a4,a5,0x2
80006894:	800037b7          	lui	a5,0x80003
80006898:	2b478793          	add	a5,a5,692 # 800032b4 <.L93>
8000689c:	97ba                	add	a5,a5,a4
8000689e:	439c                	lw	a5,0(a5)
800068a0:	8782                	jr	a5

800068a2 <.L100>:
        case USB_REQUEST_GET_STATUS:
            /* bit 0: self-powered */
            /* bit 1: remote wakeup */
            (*data)[0] = 0x00;
800068a2:	4792                	lw	a5,4(sp)
800068a4:	439c                	lw	a5,0(a5)
800068a6:	00078023          	sb	zero,0(a5)
            if (g_usbd_core[busid].self_powered) {
800068aa:	00f14683          	lbu	a3,15(sp)
800068ae:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800068b2:	6785                	lui	a5,0x1
800068b4:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800068b8:	02f687b3          	mul	a5,a3,a5
800068bc:	97ba                	add	a5,a5,a4
800068be:	6705                	lui	a4,0x1
800068c0:	97ba                	add	a5,a5,a4
800068c2:	81e7c783          	lbu	a5,-2018(a5)
800068c6:	cf89                	beqz	a5,800068e0 <.L101>
                (*data)[0] |= USB_GETSTATUS_SELF_POWERED;
800068c8:	4792                	lw	a5,4(sp)
800068ca:	439c                	lw	a5,0(a5)
800068cc:	0007c703          	lbu	a4,0(a5)
800068d0:	4792                	lw	a5,4(sp)
800068d2:	439c                	lw	a5,0(a5)
800068d4:	00176713          	or	a4,a4,1
800068d8:	0ff77713          	zext.b	a4,a4
800068dc:	00e78023          	sb	a4,0(a5)

800068e0 <.L101>:
            }
            if (g_usbd_core[busid].remote_wakeup_enabled) {
800068e0:	00f14683          	lbu	a3,15(sp)
800068e4:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800068e8:	6785                	lui	a5,0x1
800068ea:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800068ee:	02f687b3          	mul	a5,a3,a5
800068f2:	97ba                	add	a5,a5,a4
800068f4:	6705                	lui	a4,0x1
800068f6:	97ba                	add	a5,a5,a4
800068f8:	8207c783          	lbu	a5,-2016(a5)
800068fc:	cf89                	beqz	a5,80006916 <.L102>
                (*data)[0] |= USB_GETSTATUS_REMOTE_WAKEUP;
800068fe:	4792                	lw	a5,4(sp)
80006900:	439c                	lw	a5,0(a5)
80006902:	0007c703          	lbu	a4,0(a5)
80006906:	4792                	lw	a5,4(sp)
80006908:	439c                	lw	a5,0(a5)
8000690a:	00276713          	or	a4,a4,2
8000690e:	0ff77713          	zext.b	a4,a4
80006912:	00e78023          	sb	a4,0(a5)

80006916 <.L102>:
            }
            (*data)[1] = 0x00;
80006916:	4792                	lw	a5,4(sp)
80006918:	439c                	lw	a5,0(a5)
8000691a:	0785                	add	a5,a5,1
8000691c:	00078023          	sb	zero,0(a5)
            *len = 2;
80006920:	4782                	lw	a5,0(sp)
80006922:	4709                	li	a4,2
80006924:	c398                	sw	a4,0(a5)
            break;
80006926:	ac35                	j	80006b62 <.L103>

80006928 <.L99>:

        case USB_REQUEST_CLEAR_FEATURE:
        case USB_REQUEST_SET_FEATURE:
            if (value == USB_FEATURE_REMOTE_WAKEUP) {
80006928:	01c15703          	lhu	a4,28(sp)
8000692c:	4785                	li	a5,1
8000692e:	08f71d63          	bne	a4,a5,800069c8 <.L104>
                if (setup->bRequest == USB_REQUEST_SET_FEATURE) {
80006932:	47a2                	lw	a5,8(sp)
80006934:	0017c703          	lbu	a4,1(a5)
80006938:	478d                	li	a5,3
8000693a:	04f71563          	bne	a4,a5,80006984 <.L105>
                    g_usbd_core[busid].remote_wakeup_enabled = true;
8000693e:	00f14683          	lbu	a3,15(sp)
80006942:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006946:	6785                	lui	a5,0x1
80006948:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000694c:	02f687b3          	mul	a5,a3,a5
80006950:	97ba                	add	a5,a5,a4
80006952:	6705                	lui	a4,0x1
80006954:	97ba                	add	a5,a5,a4
80006956:	4705                	li	a4,1
80006958:	82e78023          	sb	a4,-2016(a5)
                    g_usbd_core[busid].event_handler(busid, USBD_EVENT_SET_REMOTE_WAKEUP);
8000695c:	00f14683          	lbu	a3,15(sp)
80006960:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006964:	6785                	lui	a5,0x1
80006966:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000696a:	02f687b3          	mul	a5,a3,a5
8000696e:	97ba                	add	a5,a5,a4
80006970:	6705                	lui	a4,0x1
80006972:	97ba                	add	a5,a5,a4
80006974:	9387a783          	lw	a5,-1736(a5)
80006978:	00f14703          	lbu	a4,15(sp)
8000697c:	45a5                	li	a1,9
8000697e:	853a                	mv	a0,a4
80006980:	9782                	jalr	a5
80006982:	a0bd                	j	800069f0 <.L106>

80006984 <.L105>:
                } else {
                    g_usbd_core[busid].remote_wakeup_enabled = false;
80006984:	00f14683          	lbu	a3,15(sp)
80006988:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000698c:	6785                	lui	a5,0x1
8000698e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006992:	02f687b3          	mul	a5,a3,a5
80006996:	97ba                	add	a5,a5,a4
80006998:	6705                	lui	a4,0x1
8000699a:	97ba                	add	a5,a5,a4
8000699c:	82078023          	sb	zero,-2016(a5)
                    g_usbd_core[busid].event_handler(busid, USBD_EVENT_CLR_REMOTE_WAKEUP);
800069a0:	00f14683          	lbu	a3,15(sp)
800069a4:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800069a8:	6785                	lui	a5,0x1
800069aa:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800069ae:	02f687b3          	mul	a5,a3,a5
800069b2:	97ba                	add	a5,a5,a4
800069b4:	6705                	lui	a4,0x1
800069b6:	97ba                	add	a5,a5,a4
800069b8:	9387a783          	lw	a5,-1736(a5)
800069bc:	00f14703          	lbu	a4,15(sp)
800069c0:	45a9                	li	a1,10
800069c2:	853a                	mv	a0,a4
800069c4:	9782                	jalr	a5
800069c6:	a02d                	j	800069f0 <.L106>

800069c8 <.L104>:
                }
            } else if (value == USB_FEATURE_TEST_MODE) {
800069c8:	01c15703          	lhu	a4,28(sp)
800069cc:	4789                	li	a5,2
800069ce:	02f71163          	bne	a4,a5,800069f0 <.L106>
#ifdef CONFIG_USBDEV_TEST_MODE
                g_usbd_core[busid].test_req = true;
800069d2:	00f14683          	lbu	a3,15(sp)
800069d6:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800069da:	6785                	lui	a5,0x1
800069dc:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800069e0:	02f687b3          	mul	a5,a3,a5
800069e4:	97ba                	add	a5,a5,a4
800069e6:	6705                	lui	a4,0x1
800069e8:	97ba                	add	a5,a5,a4
800069ea:	4705                	li	a4,1
800069ec:	82e781a3          	sb	a4,-2013(a5)

800069f0 <.L106>:
#endif
            }
            *len = 0;
800069f0:	4782                	lw	a5,0(sp)
800069f2:	0007a023          	sw	zero,0(a5)
            break;
800069f6:	a2b5                	j	80006b62 <.L103>

800069f8 <.L98>:

        case USB_REQUEST_SET_ADDRESS:
            g_usbd_core[busid].device_address = value;
800069f8:	00f14603          	lbu	a2,15(sp)
800069fc:	01c15783          	lhu	a5,28(sp)
80006a00:	0ff7f713          	zext.b	a4,a5
80006a04:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006a08:	6785                	lui	a5,0x1
80006a0a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006a0e:	02f607b3          	mul	a5,a2,a5
80006a12:	97b6                	add	a5,a5,a3
80006a14:	6685                	lui	a3,0x1
80006a16:	97b6                	add	a5,a5,a3
80006a18:	80e78ea3          	sb	a4,-2019(a5)
            usbd_set_address(busid, value);
80006a1c:	01c15783          	lhu	a5,28(sp)
80006a20:	0ff7f713          	zext.b	a4,a5
80006a24:	00f14783          	lbu	a5,15(sp)
80006a28:	85ba                	mv	a1,a4
80006a2a:	853e                	mv	a0,a5
80006a2c:	34e010ef          	jal	80007d7a <usbd_set_address>
            *len = 0;
80006a30:	4782                	lw	a5,0(sp)
80006a32:	0007a023          	sw	zero,0(a5)
            break;
80006a36:	a235                	j	80006b62 <.L103>

80006a38 <.L97>:

        case USB_REQUEST_GET_DESCRIPTOR:
            ret = usbd_get_descriptor(busid, value, data, len);
80006a38:	01c15703          	lhu	a4,28(sp)
80006a3c:	00f14783          	lbu	a5,15(sp)
80006a40:	4682                	lw	a3,0(sp)
80006a42:	4612                	lw	a2,4(sp)
80006a44:	85ba                	mv	a1,a4
80006a46:	853e                	mv	a0,a5
80006a48:	ea8ff0ef          	jal	800060f0 <usbd_get_descriptor>
80006a4c:	87aa                	mv	a5,a0
80006a4e:	00f10fa3          	sb	a5,31(sp)
            break;
80006a52:	aa01                	j	80006b62 <.L103>

80006a54 <.L96>:

        case USB_REQUEST_SET_DESCRIPTOR:
            ret = false;
80006a54:	00010fa3          	sb	zero,31(sp)
            break;
80006a58:	a229                	j	80006b62 <.L103>

80006a5a <.L95>:

        case USB_REQUEST_GET_CONFIGURATION:
            (*data)[0] = g_usbd_core[busid].configuration;
80006a5a:	00f14603          	lbu	a2,15(sp)
80006a5e:	4792                	lw	a5,4(sp)
80006a60:	4398                	lw	a4,0(a5)
80006a62:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006a66:	6785                	lui	a5,0x1
80006a68:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006a6c:	02f607b3          	mul	a5,a2,a5
80006a70:	97b6                	add	a5,a5,a3
80006a72:	6685                	lui	a3,0x1
80006a74:	97b6                	add	a5,a5,a3
80006a76:	81c7c783          	lbu	a5,-2020(a5)
80006a7a:	00f70023          	sb	a5,0(a4) # 1000 <__fw_size__>
            *len = 1;
80006a7e:	4782                	lw	a5,0(sp)
80006a80:	4705                	li	a4,1
80006a82:	c398                	sw	a4,0(a5)
            break;
80006a84:	a8f9                	j	80006b62 <.L103>

80006a86 <.L94>:

        case USB_REQUEST_SET_CONFIGURATION:
            value &= 0xFF;
80006a86:	01c15783          	lhu	a5,28(sp)
80006a8a:	0ff7f793          	zext.b	a5,a5
80006a8e:	00f11e23          	sh	a5,28(sp)

            if (value == 0) {
80006a92:	01c15783          	lhu	a5,28(sp)
80006a96:	e385                	bnez	a5,80006ab6 <.L107>
                g_usbd_core[busid].configuration = 0;
80006a98:	00f14683          	lbu	a3,15(sp)
80006a9c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006aa0:	6785                	lui	a5,0x1
80006aa2:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006aa6:	02f687b3          	mul	a5,a3,a5
80006aaa:	97ba                	add	a5,a5,a4
80006aac:	6705                	lui	a4,0x1
80006aae:	97ba                	add	a5,a5,a4
80006ab0:	80078e23          	sb	zero,-2020(a5)
80006ab4:	a869                	j	80006b4e <.L108>

80006ab6 <.L107>:
            } else if (!usbd_set_configuration(busid, value, 0)) {
80006ab6:	01c15783          	lhu	a5,28(sp)
80006aba:	0ff7f713          	zext.b	a4,a5
80006abe:	00f14783          	lbu	a5,15(sp)
80006ac2:	4601                	li	a2,0
80006ac4:	85ba                	mv	a1,a4
80006ac6:	853e                	mv	a0,a5
80006ac8:	34f9                	jal	80006596 <usbd_set_configuration>
80006aca:	87aa                	mv	a5,a0
80006acc:	0017c793          	xor	a5,a5,1
80006ad0:	0ff7f793          	zext.b	a5,a5
80006ad4:	c781                	beqz	a5,80006adc <.L109>
                ret = false;
80006ad6:	00010fa3          	sb	zero,31(sp)
80006ada:	a895                	j	80006b4e <.L108>

80006adc <.L109>:
            } else {
                g_usbd_core[busid].configuration = value;
80006adc:	00f14603          	lbu	a2,15(sp)
80006ae0:	01c15783          	lhu	a5,28(sp)
80006ae4:	0ff7f713          	zext.b	a4,a5
80006ae8:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006aec:	6785                	lui	a5,0x1
80006aee:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006af2:	02f607b3          	mul	a5,a2,a5
80006af6:	97b6                	add	a5,a5,a3
80006af8:	6685                	lui	a3,0x1
80006afa:	97b6                	add	a5,a5,a3
80006afc:	80e78e23          	sb	a4,-2020(a5)
                g_usbd_core[busid].is_suspend = false;
80006b00:	00f14683          	lbu	a3,15(sp)
80006b04:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006b08:	6785                	lui	a5,0x1
80006b0a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006b0e:	02f687b3          	mul	a5,a3,a5
80006b12:	97ba                	add	a5,a5,a4
80006b14:	6705                	lui	a4,0x1
80006b16:	97ba                	add	a5,a5,a4
80006b18:	820780a3          	sb	zero,-2015(a5)
                usbd_class_event_notify_handler(busid, USBD_EVENT_CONFIGURED, NULL);
80006b1c:	00f14783          	lbu	a5,15(sp)
80006b20:	4601                	li	a2,0
80006b22:	459d                	li	a1,7
80006b24:	853e                	mv	a0,a5
80006b26:	2f8d                	jal	80007298 <usbd_class_event_notify_handler>
                g_usbd_core[busid].event_handler(busid, USBD_EVENT_CONFIGURED);
80006b28:	00f14683          	lbu	a3,15(sp)
80006b2c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006b30:	6785                	lui	a5,0x1
80006b32:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006b36:	02f687b3          	mul	a5,a3,a5
80006b3a:	97ba                	add	a5,a5,a4
80006b3c:	6705                	lui	a4,0x1
80006b3e:	97ba                	add	a5,a5,a4
80006b40:	9387a783          	lw	a5,-1736(a5)
80006b44:	00f14703          	lbu	a4,15(sp)
80006b48:	459d                	li	a1,7
80006b4a:	853a                	mv	a0,a4
80006b4c:	9782                	jalr	a5

80006b4e <.L108>:
            }
            *len = 0;
80006b4e:	4782                	lw	a5,0(sp)
80006b50:	0007a023          	sw	zero,0(a5)
            break;
80006b54:	a039                	j	80006b62 <.L103>

80006b56 <.L92>:

        case USB_REQUEST_GET_INTERFACE:
        case USB_REQUEST_SET_INTERFACE:
            ret = false;
80006b56:	00010fa3          	sb	zero,31(sp)
            break;
80006b5a:	a021                	j	80006b62 <.L103>

80006b5c <.L91>:

        default:
            ret = false;
80006b5c:	00010fa3          	sb	zero,31(sp)
            break;
80006b60:	0001                	nop

80006b62 <.L103>:
    }

    return ret;
80006b62:	01f14783          	lbu	a5,31(sp)
}
80006b66:	853e                	mv	a0,a5
80006b68:	50b2                	lw	ra,44(sp)
80006b6a:	6145                	add	sp,sp,48
80006b6c:	8082                	ret

Disassembly of section .text.usbd_class_request_handler:

80006b6e <usbd_class_request_handler>:
 * @param [in,out] len      Pointer to data length
 *
 * @return true if the request was handled successfully
 */
static int usbd_class_request_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
80006b6e:	7179                	add	sp,sp,-48
80006b70:	d606                	sw	ra,44(sp)
80006b72:	87aa                	mv	a5,a0
80006b74:	c42e                	sw	a1,8(sp)
80006b76:	c232                	sw	a2,4(sp)
80006b78:	c036                	sw	a3,0(sp)
80006b7a:	00f107a3          	sb	a5,15(sp)
    if ((setup->bmRequestType & USB_REQUEST_RECIPIENT_MASK) == USB_REQUEST_RECIPIENT_INTERFACE) {
80006b7e:	47a2                	lw	a5,8(sp)
80006b80:	0007c783          	lbu	a5,0(a5)
80006b84:	0037f713          	and	a4,a5,3
80006b88:	4785                	li	a5,1
80006b8a:	08f71f63          	bne	a4,a5,80006c28 <.L168>

80006b8e <.LBB6>:
        for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
80006b8e:	00010fa3          	sb	zero,31(sp)
80006b92:	a885                	j	80006c02 <.L169>

80006b94 <.L172>:
            struct usbd_interface *intf = g_usbd_core[busid].intf[i];
80006b94:	00f14603          	lbu	a2,15(sp)
80006b98:	01f14783          	lbu	a5,31(sp)
80006b9c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006ba0:	24f00693          	li	a3,591
80006ba4:	02d606b3          	mul	a3,a2,a3
80006ba8:	97b6                	add	a5,a5,a3
80006baa:	20878793          	add	a5,a5,520
80006bae:	078a                	sll	a5,a5,0x2
80006bb0:	97ba                	add	a5,a5,a4
80006bb2:	43dc                	lw	a5,4(a5)
80006bb4:	ca3e                	sw	a5,20(sp)

            if (intf && intf->class_interface_handler && (intf->intf_num == (setup->wIndex & 0xFF))) {
80006bb6:	47d2                	lw	a5,20(sp)
80006bb8:	c3a1                	beqz	a5,80006bf8 <.L170>
80006bba:	47d2                	lw	a5,20(sp)
80006bbc:	439c                	lw	a5,0(a5)
80006bbe:	cf8d                	beqz	a5,80006bf8 <.L170>
80006bc0:	47d2                	lw	a5,20(sp)
80006bc2:	0187c783          	lbu	a5,24(a5)
80006bc6:	86be                	mv	a3,a5
80006bc8:	47a2                	lw	a5,8(sp)
80006bca:	0047c703          	lbu	a4,4(a5)
80006bce:	0057c783          	lbu	a5,5(a5)
80006bd2:	07a2                	sll	a5,a5,0x8
80006bd4:	8fd9                	or	a5,a5,a4
80006bd6:	07c2                	sll	a5,a5,0x10
80006bd8:	83c1                	srl	a5,a5,0x10
80006bda:	0ff7f793          	zext.b	a5,a5
80006bde:	00f69d63          	bne	a3,a5,80006bf8 <.L170>
                return intf->class_interface_handler(busid, setup, data, len);
80006be2:	47d2                	lw	a5,20(sp)
80006be4:	439c                	lw	a5,0(a5)
80006be6:	00f14703          	lbu	a4,15(sp)
80006bea:	4682                	lw	a3,0(sp)
80006bec:	4612                	lw	a2,4(sp)
80006bee:	45a2                	lw	a1,8(sp)
80006bf0:	853a                	mv	a0,a4
80006bf2:	9782                	jalr	a5
80006bf4:	87aa                	mv	a5,a0
80006bf6:	a86d                	j	80006cb0 <.L171>

80006bf8 <.L170>:
        for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
80006bf8:	01f14783          	lbu	a5,31(sp)
80006bfc:	0785                	add	a5,a5,1
80006bfe:	00f10fa3          	sb	a5,31(sp)

80006c02 <.L169>:
80006c02:	00f14683          	lbu	a3,15(sp)
80006c06:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006c0a:	6785                	lui	a5,0x1
80006c0c:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006c10:	02f687b3          	mul	a5,a3,a5
80006c14:	97ba                	add	a5,a5,a4
80006c16:	6705                	lui	a4,0x1
80006c18:	97ba                	add	a5,a5,a4
80006c1a:	8747c783          	lbu	a5,-1932(a5)
80006c1e:	01f14703          	lbu	a4,31(sp)
80006c22:	f6f769e3          	bltu	a4,a5,80006b94 <.L172>
80006c26:	a061                	j	80006cae <.L173>

80006c28 <.L168>:
            }
        }
    } else if ((setup->bmRequestType & USB_REQUEST_RECIPIENT_MASK) == USB_REQUEST_RECIPIENT_ENDPOINT) {
80006c28:	47a2                	lw	a5,8(sp)
80006c2a:	0007c783          	lbu	a5,0(a5)
80006c2e:	0037f713          	and	a4,a5,3
80006c32:	4789                	li	a5,2
80006c34:	06f71d63          	bne	a4,a5,80006cae <.L173>

80006c38 <.LBB8>:
        for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
80006c38:	00010f23          	sb	zero,30(sp)
80006c3c:	a0b9                	j	80006c8a <.L174>

80006c3e <.L176>:
            struct usbd_interface *intf = g_usbd_core[busid].intf[i];
80006c3e:	00f14603          	lbu	a2,15(sp)
80006c42:	01e14783          	lbu	a5,30(sp)
80006c46:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006c4a:	24f00693          	li	a3,591
80006c4e:	02d606b3          	mul	a3,a2,a3
80006c52:	97b6                	add	a5,a5,a3
80006c54:	20878793          	add	a5,a5,520
80006c58:	078a                	sll	a5,a5,0x2
80006c5a:	97ba                	add	a5,a5,a4
80006c5c:	43dc                	lw	a5,4(a5)
80006c5e:	cc3e                	sw	a5,24(sp)

            if (intf && intf->class_endpoint_handler) {
80006c60:	47e2                	lw	a5,24(sp)
80006c62:	cf99                	beqz	a5,80006c80 <.L175>
80006c64:	47e2                	lw	a5,24(sp)
80006c66:	43dc                	lw	a5,4(a5)
80006c68:	cf81                	beqz	a5,80006c80 <.L175>
                return intf->class_endpoint_handler(busid, setup, data, len);
80006c6a:	47e2                	lw	a5,24(sp)
80006c6c:	43dc                	lw	a5,4(a5)
80006c6e:	00f14703          	lbu	a4,15(sp)
80006c72:	4682                	lw	a3,0(sp)
80006c74:	4612                	lw	a2,4(sp)
80006c76:	45a2                	lw	a1,8(sp)
80006c78:	853a                	mv	a0,a4
80006c7a:	9782                	jalr	a5
80006c7c:	87aa                	mv	a5,a0
80006c7e:	a80d                	j	80006cb0 <.L171>

80006c80 <.L175>:
        for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
80006c80:	01e14783          	lbu	a5,30(sp)
80006c84:	0785                	add	a5,a5,1
80006c86:	00f10f23          	sb	a5,30(sp)

80006c8a <.L174>:
80006c8a:	00f14683          	lbu	a3,15(sp)
80006c8e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006c92:	6785                	lui	a5,0x1
80006c94:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006c98:	02f687b3          	mul	a5,a3,a5
80006c9c:	97ba                	add	a5,a5,a4
80006c9e:	6705                	lui	a4,0x1
80006ca0:	97ba                	add	a5,a5,a4
80006ca2:	8747c783          	lbu	a5,-1932(a5)
80006ca6:	01e14703          	lbu	a4,30(sp)
80006caa:	f8f76ae3          	bltu	a4,a5,80006c3e <.L176>

80006cae <.L173>:
            }
        }
    }
    return -1;
80006cae:	57fd                	li	a5,-1

80006cb0 <.L171>:
}
80006cb0:	853e                	mv	a0,a5
80006cb2:	50b2                	lw	ra,44(sp)
80006cb4:	6145                	add	sp,sp,48
80006cb6:	8082                	ret

Disassembly of section .text.usbd_vendor_request_handler:

80006cb8 <usbd_vendor_request_handler>:
 * @param [in,out] len      Pointer to data length
 *
 * @return true if the request was handled successfully
 */
static int usbd_vendor_request_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
80006cb8:	7179                	add	sp,sp,-48
80006cba:	d606                	sw	ra,44(sp)
80006cbc:	87aa                	mv	a5,a0
80006cbe:	c42e                	sw	a1,8(sp)
80006cc0:	c232                	sw	a2,4(sp)
80006cc2:	c036                	sw	a3,0(sp)
80006cc4:	00f107a3          	sb	a5,15(sp)
    uint32_t desclen;
#ifdef CONFIG_USBDEV_ADVANCE_DESC
    if (g_usbd_core[busid].descriptors->msosv1_descriptor) {
80006cc8:	00f14683          	lbu	a3,15(sp)
80006ccc:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006cd0:	6785                	lui	a5,0x1
80006cd2:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006cd6:	02f687b3          	mul	a5,a3,a5
80006cda:	97ba                	add	a5,a5,a4
80006cdc:	4f9c                	lw	a5,24(a5)
80006cde:	4bdc                	lw	a5,20(a5)
80006ce0:	24078763          	beqz	a5,80006f2e <.L178>
        if (setup->bRequest == g_usbd_core[busid].descriptors->msosv1_descriptor->vendor_code) {
80006ce4:	47a2                	lw	a5,8(sp)
80006ce6:	0017c703          	lbu	a4,1(a5)
80006cea:	00f14603          	lbu	a2,15(sp)
80006cee:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006cf2:	6785                	lui	a5,0x1
80006cf4:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006cf8:	02f607b3          	mul	a5,a2,a5
80006cfc:	97b6                	add	a5,a5,a3
80006cfe:	4f9c                	lw	a5,24(a5)
80006d00:	4bdc                	lw	a5,20(a5)
80006d02:	0047c783          	lbu	a5,4(a5)
80006d06:	30f71063          	bne	a4,a5,80007006 <.L179>
            switch (setup->wIndex) {
80006d0a:	47a2                	lw	a5,8(sp)
80006d0c:	0047c703          	lbu	a4,4(a5)
80006d10:	0057c783          	lbu	a5,5(a5)
80006d14:	07a2                	sll	a5,a5,0x8
80006d16:	8fd9                	or	a5,a5,a4
80006d18:	07c2                	sll	a5,a5,0x10
80006d1a:	83c1                	srl	a5,a5,0x10
80006d1c:	4711                	li	a4,4
80006d1e:	00e78663          	beq	a5,a4,80006d2a <.L180>
80006d22:	4715                	li	a4,5
80006d24:	0ae78f63          	beq	a5,a4,80006de2 <.L181>
80006d28:	a2ed                	j	80006f12 <.L190>

80006d2a <.L180>:
                case 0x04:
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[0] +
80006d2a:	00f14683          	lbu	a3,15(sp)
80006d2e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006d32:	6785                	lui	a5,0x1
80006d34:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006d38:	02f687b3          	mul	a5,a3,a5
80006d3c:	97ba                	add	a5,a5,a4
80006d3e:	4f9c                	lw	a5,24(a5)
80006d40:	4bdc                	lw	a5,20(a5)
80006d42:	479c                	lw	a5,8(a5)
80006d44:	0007c783          	lbu	a5,0(a5)
80006d48:	863e                	mv	a2,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[1] << 8) +
80006d4a:	00f14683          	lbu	a3,15(sp)
80006d4e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006d52:	6785                	lui	a5,0x1
80006d54:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006d58:	02f687b3          	mul	a5,a3,a5
80006d5c:	97ba                	add	a5,a5,a4
80006d5e:	4f9c                	lw	a5,24(a5)
80006d60:	4bdc                	lw	a5,20(a5)
80006d62:	479c                	lw	a5,8(a5)
80006d64:	0785                	add	a5,a5,1
80006d66:	0007c783          	lbu	a5,0(a5)
80006d6a:	07a2                	sll	a5,a5,0x8
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[0] +
80006d6c:	00f60733          	add	a4,a2,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[2] << 16) +
80006d70:	00f14603          	lbu	a2,15(sp)
80006d74:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006d78:	6785                	lui	a5,0x1
80006d7a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006d7e:	02f607b3          	mul	a5,a2,a5
80006d82:	97b6                	add	a5,a5,a3
80006d84:	4f9c                	lw	a5,24(a5)
80006d86:	4bdc                	lw	a5,20(a5)
80006d88:	479c                	lw	a5,8(a5)
80006d8a:	0789                	add	a5,a5,2
80006d8c:	0007c783          	lbu	a5,0(a5)
80006d90:	07c2                	sll	a5,a5,0x10
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[1] << 8) +
80006d92:	973e                	add	a4,a4,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[3] << 24);
80006d94:	00f14603          	lbu	a2,15(sp)
80006d98:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006d9c:	6785                	lui	a5,0x1
80006d9e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006da2:	02f607b3          	mul	a5,a2,a5
80006da6:	97b6                	add	a5,a5,a3
80006da8:	4f9c                	lw	a5,24(a5)
80006daa:	4bdc                	lw	a5,20(a5)
80006dac:	479c                	lw	a5,8(a5)
80006dae:	078d                	add	a5,a5,3
80006db0:	0007c783          	lbu	a5,0(a5)
80006db4:	07e2                	sll	a5,a5,0x18
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[2] << 16) +
80006db6:	97ba                	add	a5,a5,a4
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[0] +
80006db8:	cc3e                	sw	a5,24(sp)

                    *data = (uint8_t *)g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id;
80006dba:	00f14683          	lbu	a3,15(sp)
80006dbe:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006dc2:	6785                	lui	a5,0x1
80006dc4:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006dc8:	02f687b3          	mul	a5,a3,a5
80006dcc:	97ba                	add	a5,a5,a4
80006dce:	4f9c                	lw	a5,24(a5)
80006dd0:	4bdc                	lw	a5,20(a5)
80006dd2:	4798                	lw	a4,8(a5)
80006dd4:	4792                	lw	a5,4(sp)
80006dd6:	c398                	sw	a4,0(a5)
                    //memcpy(*data, g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id, desclen);
                    *len = desclen;
80006dd8:	4782                	lw	a5,0(sp)
80006dda:	4762                	lw	a4,24(sp)
80006ddc:	c398                	sw	a4,0(a5)
                    return 0;
80006dde:	4781                	li	a5,0
80006de0:	ae49                	j	80007172 <.L183>

80006de2 <.L181>:
                case 0x05:
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][0] +
80006de2:	00f14683          	lbu	a3,15(sp)
80006de6:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006dea:	6785                	lui	a5,0x1
80006dec:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006df0:	02f687b3          	mul	a5,a3,a5
80006df4:	97ba                	add	a5,a5,a4
80006df6:	4f9c                	lw	a5,24(a5)
80006df8:	4bdc                	lw	a5,20(a5)
80006dfa:	47d8                	lw	a4,12(a5)
80006dfc:	47a2                	lw	a5,8(sp)
80006dfe:	0027c683          	lbu	a3,2(a5)
80006e02:	0037c783          	lbu	a5,3(a5)
80006e06:	07a2                	sll	a5,a5,0x8
80006e08:	8fd5                	or	a5,a5,a3
80006e0a:	07c2                	sll	a5,a5,0x10
80006e0c:	83c1                	srl	a5,a5,0x10
80006e0e:	078a                	sll	a5,a5,0x2
80006e10:	97ba                	add	a5,a5,a4
80006e12:	439c                	lw	a5,0(a5)
80006e14:	0007c783          	lbu	a5,0(a5)
80006e18:	863e                	mv	a2,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][1] << 8) +
80006e1a:	00f14683          	lbu	a3,15(sp)
80006e1e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006e22:	6785                	lui	a5,0x1
80006e24:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006e28:	02f687b3          	mul	a5,a3,a5
80006e2c:	97ba                	add	a5,a5,a4
80006e2e:	4f9c                	lw	a5,24(a5)
80006e30:	4bdc                	lw	a5,20(a5)
80006e32:	47d8                	lw	a4,12(a5)
80006e34:	47a2                	lw	a5,8(sp)
80006e36:	0027c683          	lbu	a3,2(a5)
80006e3a:	0037c783          	lbu	a5,3(a5)
80006e3e:	07a2                	sll	a5,a5,0x8
80006e40:	8fd5                	or	a5,a5,a3
80006e42:	07c2                	sll	a5,a5,0x10
80006e44:	83c1                	srl	a5,a5,0x10
80006e46:	078a                	sll	a5,a5,0x2
80006e48:	97ba                	add	a5,a5,a4
80006e4a:	439c                	lw	a5,0(a5)
80006e4c:	0785                	add	a5,a5,1
80006e4e:	0007c783          	lbu	a5,0(a5)
80006e52:	07a2                	sll	a5,a5,0x8
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][0] +
80006e54:	00f60733          	add	a4,a2,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][2] << 16) +
80006e58:	00f14603          	lbu	a2,15(sp)
80006e5c:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006e60:	6785                	lui	a5,0x1
80006e62:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006e66:	02f607b3          	mul	a5,a2,a5
80006e6a:	97b6                	add	a5,a5,a3
80006e6c:	4f9c                	lw	a5,24(a5)
80006e6e:	4bdc                	lw	a5,20(a5)
80006e70:	47d4                	lw	a3,12(a5)
80006e72:	47a2                	lw	a5,8(sp)
80006e74:	0027c603          	lbu	a2,2(a5)
80006e78:	0037c783          	lbu	a5,3(a5)
80006e7c:	07a2                	sll	a5,a5,0x8
80006e7e:	8fd1                	or	a5,a5,a2
80006e80:	07c2                	sll	a5,a5,0x10
80006e82:	83c1                	srl	a5,a5,0x10
80006e84:	078a                	sll	a5,a5,0x2
80006e86:	97b6                	add	a5,a5,a3
80006e88:	439c                	lw	a5,0(a5)
80006e8a:	0789                	add	a5,a5,2
80006e8c:	0007c783          	lbu	a5,0(a5)
80006e90:	07c2                	sll	a5,a5,0x10
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][1] << 8) +
80006e92:	973e                	add	a4,a4,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][3] << 24);
80006e94:	00f14603          	lbu	a2,15(sp)
80006e98:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006e9c:	6785                	lui	a5,0x1
80006e9e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006ea2:	02f607b3          	mul	a5,a2,a5
80006ea6:	97b6                	add	a5,a5,a3
80006ea8:	4f9c                	lw	a5,24(a5)
80006eaa:	4bdc                	lw	a5,20(a5)
80006eac:	47d4                	lw	a3,12(a5)
80006eae:	47a2                	lw	a5,8(sp)
80006eb0:	0027c603          	lbu	a2,2(a5)
80006eb4:	0037c783          	lbu	a5,3(a5)
80006eb8:	07a2                	sll	a5,a5,0x8
80006eba:	8fd1                	or	a5,a5,a2
80006ebc:	07c2                	sll	a5,a5,0x10
80006ebe:	83c1                	srl	a5,a5,0x10
80006ec0:	078a                	sll	a5,a5,0x2
80006ec2:	97b6                	add	a5,a5,a3
80006ec4:	439c                	lw	a5,0(a5)
80006ec6:	078d                	add	a5,a5,3
80006ec8:	0007c783          	lbu	a5,0(a5)
80006ecc:	07e2                	sll	a5,a5,0x18
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][2] << 16) +
80006ece:	97ba                	add	a5,a5,a4
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][0] +
80006ed0:	cc3e                	sw	a5,24(sp)

                    *data = (uint8_t *)g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue];
80006ed2:	00f14683          	lbu	a3,15(sp)
80006ed6:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006eda:	6785                	lui	a5,0x1
80006edc:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006ee0:	02f687b3          	mul	a5,a3,a5
80006ee4:	97ba                	add	a5,a5,a4
80006ee6:	4f9c                	lw	a5,24(a5)
80006ee8:	4bdc                	lw	a5,20(a5)
80006eea:	47d8                	lw	a4,12(a5)
80006eec:	47a2                	lw	a5,8(sp)
80006eee:	0027c683          	lbu	a3,2(a5)
80006ef2:	0037c783          	lbu	a5,3(a5)
80006ef6:	07a2                	sll	a5,a5,0x8
80006ef8:	8fd5                	or	a5,a5,a3
80006efa:	07c2                	sll	a5,a5,0x10
80006efc:	83c1                	srl	a5,a5,0x10
80006efe:	078a                	sll	a5,a5,0x2
80006f00:	97ba                	add	a5,a5,a4
80006f02:	4398                	lw	a4,0(a5)
80006f04:	4792                	lw	a5,4(sp)
80006f06:	c398                	sw	a4,0(a5)
                    //memcpy(*data, g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue], desclen);
                    *len = desclen;
80006f08:	4782                	lw	a5,0(sp)
80006f0a:	4762                	lw	a4,24(sp)
80006f0c:	c398                	sw	a4,0(a5)
                    return 0;
80006f0e:	4781                	li	a5,0
80006f10:	a48d                	j	80007172 <.L183>

80006f12 <.L190>:
                default:
                    USB_LOG_ERR("unknown vendor code\r\n");
80006f12:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
80006f16:	538020ef          	jal	8000944e <printf>
80006f1a:	65820513          	add	a0,tp,1624 # 658 <.L146>
80006f1e:	530020ef          	jal	8000944e <printf>
80006f22:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
80006f26:	528020ef          	jal	8000944e <printf>
                    return -1;
80006f2a:	57fd                	li	a5,-1
80006f2c:	a499                	j	80007172 <.L183>

80006f2e <.L178>:
            }
        }
    } else if (g_usbd_core[busid].descriptors->msosv2_descriptor) {
80006f2e:	00f14683          	lbu	a3,15(sp)
80006f32:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006f36:	6785                	lui	a5,0x1
80006f38:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006f3c:	02f687b3          	mul	a5,a3,a5
80006f40:	97ba                	add	a5,a5,a4
80006f42:	4f9c                	lw	a5,24(a5)
80006f44:	4f9c                	lw	a5,24(a5)
80006f46:	c3e1                	beqz	a5,80007006 <.L179>
        if (setup->bRequest == g_usbd_core[busid].descriptors->msosv2_descriptor->vendor_code) {
80006f48:	47a2                	lw	a5,8(sp)
80006f4a:	0017c703          	lbu	a4,1(a5)
80006f4e:	00f14603          	lbu	a2,15(sp)
80006f52:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80006f56:	6785                	lui	a5,0x1
80006f58:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006f5c:	02f607b3          	mul	a5,a2,a5
80006f60:	97b6                	add	a5,a5,a3
80006f62:	4f9c                	lw	a5,24(a5)
80006f64:	4f9c                	lw	a5,24(a5)
80006f66:	0067c783          	lbu	a5,6(a5)
80006f6a:	08f71e63          	bne	a4,a5,80007006 <.L179>
            switch (setup->wIndex) {
80006f6e:	47a2                	lw	a5,8(sp)
80006f70:	0047c703          	lbu	a4,4(a5)
80006f74:	0057c783          	lbu	a5,5(a5)
80006f78:	07a2                	sll	a5,a5,0x8
80006f7a:	8fd9                	or	a5,a5,a4
80006f7c:	07c2                	sll	a5,a5,0x10
80006f7e:	83c1                	srl	a5,a5,0x10
80006f80:	873e                	mv	a4,a5
80006f82:	479d                	li	a5,7
80006f84:	06f71363          	bne	a4,a5,80006fea <.L184>
                case WINUSB_REQUEST_GET_DESCRIPTOR_SET:
                    desclen = g_usbd_core[busid].descriptors->msosv2_descriptor->compat_id_len;
80006f88:	00f14683          	lbu	a3,15(sp)
80006f8c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006f90:	6785                	lui	a5,0x1
80006f92:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006f96:	02f687b3          	mul	a5,a3,a5
80006f9a:	97ba                	add	a5,a5,a4
80006f9c:	4f9c                	lw	a5,24(a5)
80006f9e:	4f9c                	lw	a5,24(a5)
80006fa0:	0047d783          	lhu	a5,4(a5)
80006fa4:	cc3e                	sw	a5,24(sp)
                    *data = (uint8_t *)g_usbd_core[busid].descriptors->msosv2_descriptor->compat_id;
80006fa6:	00f14683          	lbu	a3,15(sp)
80006faa:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006fae:	6785                	lui	a5,0x1
80006fb0:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006fb4:	02f687b3          	mul	a5,a3,a5
80006fb8:	97ba                	add	a5,a5,a4
80006fba:	4f9c                	lw	a5,24(a5)
80006fbc:	4f9c                	lw	a5,24(a5)
80006fbe:	4398                	lw	a4,0(a5)
80006fc0:	4792                	lw	a5,4(sp)
80006fc2:	c398                	sw	a4,0(a5)
                    //memcpy(*data, g_usbd_core[busid].descriptors->msosv2_descriptor->compat_id, desclen);
                    *len = g_usbd_core[busid].descriptors->msosv2_descriptor->compat_id_len;
80006fc4:	00f14683          	lbu	a3,15(sp)
80006fc8:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80006fcc:	6785                	lui	a5,0x1
80006fce:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80006fd2:	02f687b3          	mul	a5,a3,a5
80006fd6:	97ba                	add	a5,a5,a4
80006fd8:	4f9c                	lw	a5,24(a5)
80006fda:	4f9c                	lw	a5,24(a5)
80006fdc:	0047d783          	lhu	a5,4(a5)
80006fe0:	873e                	mv	a4,a5
80006fe2:	4782                	lw	a5,0(sp)
80006fe4:	c398                	sw	a4,0(a5)
                    return 0;
80006fe6:	4781                	li	a5,0
80006fe8:	a269                	j	80007172 <.L183>

80006fea <.L184>:
                default:
                    USB_LOG_ERR("unknown vendor code\r\n");
80006fea:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
80006fee:	460020ef          	jal	8000944e <printf>
80006ff2:	65820513          	add	a0,tp,1624 # 658 <.L146>
80006ff6:	458020ef          	jal	8000944e <printf>
80006ffa:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
80006ffe:	450020ef          	jal	8000944e <printf>
                    return -1;
80007002:	57fd                	li	a5,-1
80007004:	a2bd                	j	80007172 <.L183>

80007006 <.L179>:
            }
        }
    }

    if (g_usbd_core[busid].descriptors->webusb_url_descriptor) {
80007006:	00f14683          	lbu	a3,15(sp)
8000700a:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000700e:	6785                	lui	a5,0x1
80007010:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007014:	02f687b3          	mul	a5,a3,a5
80007018:	97ba                	add	a5,a5,a4
8000701a:	4f9c                	lw	a5,24(a5)
8000701c:	4fdc                	lw	a5,28(a5)
8000701e:	cfe1                	beqz	a5,800070f6 <.L185>
        if (setup->bRequest == g_usbd_core[busid].descriptors->webusb_url_descriptor->vendor_code) {
80007020:	47a2                	lw	a5,8(sp)
80007022:	0017c703          	lbu	a4,1(a5)
80007026:	00f14603          	lbu	a2,15(sp)
8000702a:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000702e:	6785                	lui	a5,0x1
80007030:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007034:	02f607b3          	mul	a5,a2,a5
80007038:	97b6                	add	a5,a5,a3
8000703a:	4f9c                	lw	a5,24(a5)
8000703c:	4fdc                	lw	a5,28(a5)
8000703e:	0007c783          	lbu	a5,0(a5)
80007042:	0af71a63          	bne	a4,a5,800070f6 <.L185>
            switch (setup->wIndex) {
80007046:	47a2                	lw	a5,8(sp)
80007048:	0047c703          	lbu	a4,4(a5)
8000704c:	0057c783          	lbu	a5,5(a5)
80007050:	07a2                	sll	a5,a5,0x8
80007052:	8fd9                	or	a5,a5,a4
80007054:	07c2                	sll	a5,a5,0x10
80007056:	83c1                	srl	a5,a5,0x10
80007058:	873e                	mv	a4,a5
8000705a:	4789                	li	a5,2
8000705c:	06f71f63          	bne	a4,a5,800070da <.L186>
                case WEBUSB_REQUEST_GET_URL:
                    desclen = g_usbd_core[busid].descriptors->webusb_url_descriptor->string_len;
80007060:	00f14683          	lbu	a3,15(sp)
80007064:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007068:	6785                	lui	a5,0x1
8000706a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000706e:	02f687b3          	mul	a5,a3,a5
80007072:	97ba                	add	a5,a5,a4
80007074:	4f9c                	lw	a5,24(a5)
80007076:	4fdc                	lw	a5,28(a5)
80007078:	0057c703          	lbu	a4,5(a5)
8000707c:	0067c683          	lbu	a3,6(a5)
80007080:	06a2                	sll	a3,a3,0x8
80007082:	8f55                	or	a4,a4,a3
80007084:	0077c683          	lbu	a3,7(a5)
80007088:	06c2                	sll	a3,a3,0x10
8000708a:	8f55                	or	a4,a4,a3
8000708c:	0087c783          	lbu	a5,8(a5)
80007090:	07e2                	sll	a5,a5,0x18
80007092:	8fd9                	or	a5,a5,a4
80007094:	cc3e                	sw	a5,24(sp)
                    *data = (uint8_t *)g_usbd_core[busid].descriptors->webusb_url_descriptor->string;
80007096:	00f14683          	lbu	a3,15(sp)
8000709a:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000709e:	6785                	lui	a5,0x1
800070a0:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800070a4:	02f687b3          	mul	a5,a3,a5
800070a8:	97ba                	add	a5,a5,a4
800070aa:	4f9c                	lw	a5,24(a5)
800070ac:	4fdc                	lw	a5,28(a5)
800070ae:	0017c703          	lbu	a4,1(a5)
800070b2:	0027c683          	lbu	a3,2(a5)
800070b6:	06a2                	sll	a3,a3,0x8
800070b8:	8f55                	or	a4,a4,a3
800070ba:	0037c683          	lbu	a3,3(a5)
800070be:	06c2                	sll	a3,a3,0x10
800070c0:	8f55                	or	a4,a4,a3
800070c2:	0047c783          	lbu	a5,4(a5)
800070c6:	07e2                	sll	a5,a5,0x18
800070c8:	8fd9                	or	a5,a5,a4
800070ca:	873e                	mv	a4,a5
800070cc:	4792                	lw	a5,4(sp)
800070ce:	c398                	sw	a4,0(a5)
                    //memcpy(*data, g_usbd_core[busid].descriptors->webusb_url_descriptor->string, desclen);
                    *len = desclen;
800070d0:	4782                	lw	a5,0(sp)
800070d2:	4762                	lw	a4,24(sp)
800070d4:	c398                	sw	a4,0(a5)
                    return 0;
800070d6:	4781                	li	a5,0
800070d8:	a869                	j	80007172 <.L183>

800070da <.L186>:
                default:
                    USB_LOG_ERR("unknown vendor code\r\n");
800070da:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
800070de:	370020ef          	jal	8000944e <printf>
800070e2:	65820513          	add	a0,tp,1624 # 658 <.L146>
800070e6:	368020ef          	jal	8000944e <printf>
800070ea:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
800070ee:	360020ef          	jal	8000944e <printf>
                    return -1;
800070f2:	57fd                	li	a5,-1
800070f4:	a8bd                	j	80007172 <.L183>

800070f6 <.L185>:
                    return -1;
            }
        }
    }
#endif
    for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
800070f6:	00010fa3          	sb	zero,31(sp)
800070fa:	a889                	j	8000714c <.L187>

800070fc <.L189>:
        struct usbd_interface *intf = g_usbd_core[busid].intf[i];
800070fc:	00f14603          	lbu	a2,15(sp)
80007100:	01f14783          	lbu	a5,31(sp)
80007104:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007108:	24f00693          	li	a3,591
8000710c:	02d606b3          	mul	a3,a2,a3
80007110:	97b6                	add	a5,a5,a3
80007112:	20878793          	add	a5,a5,520
80007116:	078a                	sll	a5,a5,0x2
80007118:	97ba                	add	a5,a5,a4
8000711a:	43dc                	lw	a5,4(a5)
8000711c:	ca3e                	sw	a5,20(sp)

        if (intf && intf->vendor_handler && (intf->vendor_handler(busid, setup, data, len) == 0)) {
8000711e:	47d2                	lw	a5,20(sp)
80007120:	c38d                	beqz	a5,80007142 <.L188>
80007122:	47d2                	lw	a5,20(sp)
80007124:	479c                	lw	a5,8(a5)
80007126:	cf91                	beqz	a5,80007142 <.L188>
80007128:	47d2                	lw	a5,20(sp)
8000712a:	479c                	lw	a5,8(a5)
8000712c:	00f14703          	lbu	a4,15(sp)
80007130:	4682                	lw	a3,0(sp)
80007132:	4612                	lw	a2,4(sp)
80007134:	45a2                	lw	a1,8(sp)
80007136:	853a                	mv	a0,a4
80007138:	9782                	jalr	a5
8000713a:	87aa                	mv	a5,a0
8000713c:	e399                	bnez	a5,80007142 <.L188>
            return 0;
8000713e:	4781                	li	a5,0
80007140:	a80d                	j	80007172 <.L183>

80007142 <.L188>:
    for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
80007142:	01f14783          	lbu	a5,31(sp)
80007146:	0785                	add	a5,a5,1
80007148:	00f10fa3          	sb	a5,31(sp)

8000714c <.L187>:
8000714c:	00f14683          	lbu	a3,15(sp)
80007150:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007154:	6785                	lui	a5,0x1
80007156:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000715a:	02f687b3          	mul	a5,a3,a5
8000715e:	97ba                	add	a5,a5,a4
80007160:	6705                	lui	a4,0x1
80007162:	97ba                	add	a5,a5,a4
80007164:	8747c783          	lbu	a5,-1932(a5)
80007168:	01f14703          	lbu	a4,31(sp)
8000716c:	f8f768e3          	bltu	a4,a5,800070fc <.L189>

80007170 <.LBE10>:
        }
    }

    return -1;
80007170:	57fd                	li	a5,-1

80007172 <.L183>:
}
80007172:	853e                	mv	a0,a5
80007174:	50b2                	lw	ra,44(sp)
80007176:	6145                	add	sp,sp,48
80007178:	8082                	ret

Disassembly of section .text.usbd_setup_request_handler:

8000717a <usbd_setup_request_handler>:
 * @param [in,out] len   Pointer to data length
 *
 * @return true if the request was handles successfully
 */
static bool usbd_setup_request_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
8000717a:	1101                	add	sp,sp,-32
8000717c:	ce06                	sw	ra,28(sp)
8000717e:	87aa                	mv	a5,a0
80007180:	c42e                	sw	a1,8(sp)
80007182:	c232                	sw	a2,4(sp)
80007184:	c036                	sw	a3,0(sp)
80007186:	00f107a3          	sb	a5,15(sp)
    switch (setup->bmRequestType & USB_REQUEST_TYPE_MASK) {
8000718a:	47a2                	lw	a5,8(sp)
8000718c:	0007c783          	lbu	a5,0(a5)
80007190:	0607f793          	and	a5,a5,96
80007194:	04000713          	li	a4,64
80007198:	0ae78963          	beq	a5,a4,8000724a <.L192>
8000719c:	04000713          	li	a4,64
800071a0:	0ef76063          	bltu	a4,a5,80007280 <.L193>
800071a4:	c791                	beqz	a5,800071b0 <.L194>
800071a6:	02000713          	li	a4,32
800071aa:	06e78563          	beq	a5,a4,80007214 <.L195>
800071ae:	a8c9                	j	80007280 <.L193>

800071b0 <.L194>:
        case USB_REQUEST_STANDARD:
            if (usbd_standard_request_handler(busid, setup, data, len) < 0) {
800071b0:	00f14783          	lbu	a5,15(sp)
800071b4:	4682                	lw	a3,0(sp)
800071b6:	4612                	lw	a2,4(sp)
800071b8:	45a2                	lw	a1,8(sp)
800071ba:	853e                	mv	a0,a5
800071bc:	66b030ef          	jal	8000b026 <usbd_standard_request_handler>
800071c0:	87aa                	mv	a5,a0
800071c2:	0c07d163          	bgez	a5,80007284 <.L202>
                /* Ignore error log for getting Device Qualifier Descriptor request */
                if ((setup->bRequest == 0x06) && (setup->wValue == 0x0600)) {
800071c6:	47a2                	lw	a5,8(sp)
800071c8:	0017c703          	lbu	a4,1(a5)
800071cc:	4799                	li	a5,6
800071ce:	02f71263          	bne	a4,a5,800071f2 <.L197>
800071d2:	47a2                	lw	a5,8(sp)
800071d4:	0027c703          	lbu	a4,2(a5)
800071d8:	0037c783          	lbu	a5,3(a5)
800071dc:	07a2                	sll	a5,a5,0x8
800071de:	8fd9                	or	a5,a5,a4
800071e0:	01079713          	sll	a4,a5,0x10
800071e4:	8341                	srl	a4,a4,0x10
800071e6:	60000793          	li	a5,1536
800071ea:	00f71463          	bne	a4,a5,800071f2 <.L197>
                    //USB_LOG_DBG("Ignore DQD in fs\r\n");
                    return false;
800071ee:	4781                	li	a5,0
800071f0:	a045                	j	80007290 <.L198>

800071f2 <.L197>:
                }
                USB_LOG_ERR("standard request error\r\n");
800071f2:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
800071f6:	258020ef          	jal	8000944e <printf>
800071fa:	67020513          	add	a0,tp,1648 # 670 <.L124+0x10>
800071fe:	250020ef          	jal	8000944e <printf>
80007202:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
80007206:	248020ef          	jal	8000944e <printf>
                usbd_print_setup(setup);
8000720a:	4522                	lw	a0,8(sp)
8000720c:	cd3fe0ef          	jal	80005ede <usbd_print_setup>
                return false;
80007210:	4781                	li	a5,0
80007212:	a8bd                	j	80007290 <.L198>

80007214 <.L195>:
            }
            break;
        case USB_REQUEST_CLASS:
            if (usbd_class_request_handler(busid, setup, data, len) < 0) {
80007214:	00f14783          	lbu	a5,15(sp)
80007218:	4682                	lw	a3,0(sp)
8000721a:	4612                	lw	a2,4(sp)
8000721c:	45a2                	lw	a1,8(sp)
8000721e:	853e                	mv	a0,a5
80007220:	32b9                	jal	80006b6e <usbd_class_request_handler>
80007222:	87aa                	mv	a5,a0
80007224:	0607d263          	bgez	a5,80007288 <.L203>
                USB_LOG_ERR("class request error\r\n");
80007228:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
8000722c:	222020ef          	jal	8000944e <printf>
80007230:	68c20513          	add	a0,tp,1676 # 68c <.L124+0x2c>
80007234:	21a020ef          	jal	8000944e <printf>
80007238:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
8000723c:	212020ef          	jal	8000944e <printf>
                usbd_print_setup(setup);
80007240:	4522                	lw	a0,8(sp)
80007242:	c9dfe0ef          	jal	80005ede <usbd_print_setup>
                return false;
80007246:	4781                	li	a5,0
80007248:	a0a1                	j	80007290 <.L198>

8000724a <.L192>:
            }
            break;
        case USB_REQUEST_VENDOR:
            if (usbd_vendor_request_handler(busid, setup, data, len) < 0) {
8000724a:	00f14783          	lbu	a5,15(sp)
8000724e:	4682                	lw	a3,0(sp)
80007250:	4612                	lw	a2,4(sp)
80007252:	45a2                	lw	a1,8(sp)
80007254:	853e                	mv	a0,a5
80007256:	348d                	jal	80006cb8 <usbd_vendor_request_handler>
80007258:	87aa                	mv	a5,a0
8000725a:	0207d963          	bgez	a5,8000728c <.L204>
                USB_LOG_ERR("vendor request error\r\n");
8000725e:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
80007262:	1ec020ef          	jal	8000944e <printf>
80007266:	6a420513          	add	a0,tp,1700 # 6a4 <.L148+0xa>
8000726a:	1e4020ef          	jal	8000944e <printf>
8000726e:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
80007272:	1dc020ef          	jal	8000944e <printf>
                usbd_print_setup(setup);
80007276:	4522                	lw	a0,8(sp)
80007278:	c67fe0ef          	jal	80005ede <usbd_print_setup>
                return false;
8000727c:	4781                	li	a5,0
8000727e:	a809                	j	80007290 <.L198>

80007280 <.L193>:
            }
            break;

        default:
            return false;
80007280:	4781                	li	a5,0
80007282:	a039                	j	80007290 <.L198>

80007284 <.L202>:
            break;
80007284:	0001                	nop
80007286:	a021                	j	8000728e <.L199>

80007288 <.L203>:
            break;
80007288:	0001                	nop
8000728a:	a011                	j	8000728e <.L199>

8000728c <.L204>:
            break;
8000728c:	0001                	nop

8000728e <.L199>:
    }

    return true;
8000728e:	4785                	li	a5,1

80007290 <.L198>:
}
80007290:	853e                	mv	a0,a5
80007292:	40f2                	lw	ra,28(sp)
80007294:	6105                	add	sp,sp,32
80007296:	8082                	ret

Disassembly of section .text.usbd_class_event_notify_handler:

80007298 <usbd_class_event_notify_handler>:

static void usbd_class_event_notify_handler(uint8_t busid, uint8_t event, void *arg)
{
80007298:	7179                	add	sp,sp,-48
8000729a:	d606                	sw	ra,44(sp)
8000729c:	87aa                	mv	a5,a0
8000729e:	872e                	mv	a4,a1
800072a0:	c432                	sw	a2,8(sp)
800072a2:	00f107a3          	sb	a5,15(sp)
800072a6:	87ba                	mv	a5,a4
800072a8:	00f10723          	sb	a5,14(sp)

800072ac <.LBB12>:
    for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
800072ac:	00010fa3          	sb	zero,31(sp)
800072b0:	a051                	j	80007334 <.L206>

800072b2 <.L209>:
        struct usbd_interface *intf = g_usbd_core[busid].intf[i];
800072b2:	00f14603          	lbu	a2,15(sp)
800072b6:	01f14783          	lbu	a5,31(sp)
800072ba:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800072be:	24f00693          	li	a3,591
800072c2:	02d606b3          	mul	a3,a2,a3
800072c6:	97b6                	add	a5,a5,a3
800072c8:	20878793          	add	a5,a5,520
800072cc:	078a                	sll	a5,a5,0x2
800072ce:	97ba                	add	a5,a5,a4
800072d0:	43dc                	lw	a5,4(a5)
800072d2:	cc3e                	sw	a5,24(sp)

        if (arg) {
800072d4:	47a2                	lw	a5,8(sp)
800072d6:	cb9d                	beqz	a5,8000730c <.L207>

800072d8 <.LBB14>:
            struct usb_interface_descriptor *desc = (struct usb_interface_descriptor *)arg;
800072d8:	47a2                	lw	a5,8(sp)
800072da:	ca3e                	sw	a5,20(sp)
            if (intf && intf->notify_handler && (desc->bInterfaceNumber == (intf->intf_num))) {
800072dc:	47e2                	lw	a5,24(sp)
800072de:	c7b1                	beqz	a5,8000732a <.L208>
800072e0:	47e2                	lw	a5,24(sp)
800072e2:	47dc                	lw	a5,12(a5)
800072e4:	c3b9                	beqz	a5,8000732a <.L208>
800072e6:	47d2                	lw	a5,20(sp)
800072e8:	0027c703          	lbu	a4,2(a5)
800072ec:	47e2                	lw	a5,24(sp)
800072ee:	0187c783          	lbu	a5,24(a5)
800072f2:	02f71c63          	bne	a4,a5,8000732a <.L208>
                intf->notify_handler(busid, event, arg);
800072f6:	47e2                	lw	a5,24(sp)
800072f8:	47dc                	lw	a5,12(a5)
800072fa:	00e14683          	lbu	a3,14(sp)
800072fe:	00f14703          	lbu	a4,15(sp)
80007302:	4622                	lw	a2,8(sp)
80007304:	85b6                	mv	a1,a3
80007306:	853a                	mv	a0,a4
80007308:	9782                	jalr	a5
8000730a:	a005                	j	8000732a <.L208>

8000730c <.L207>:
            }
        } else {
            if (intf && intf->notify_handler) {
8000730c:	47e2                	lw	a5,24(sp)
8000730e:	cf91                	beqz	a5,8000732a <.L208>
80007310:	47e2                	lw	a5,24(sp)
80007312:	47dc                	lw	a5,12(a5)
80007314:	cb99                	beqz	a5,8000732a <.L208>
                intf->notify_handler(busid, event, arg);
80007316:	47e2                	lw	a5,24(sp)
80007318:	47dc                	lw	a5,12(a5)
8000731a:	00e14683          	lbu	a3,14(sp)
8000731e:	00f14703          	lbu	a4,15(sp)
80007322:	4622                	lw	a2,8(sp)
80007324:	85b6                	mv	a1,a3
80007326:	853a                	mv	a0,a4
80007328:	9782                	jalr	a5

8000732a <.L208>:
    for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
8000732a:	01f14783          	lbu	a5,31(sp)
8000732e:	0785                	add	a5,a5,1
80007330:	00f10fa3          	sb	a5,31(sp)

80007334 <.L206>:
80007334:	00f14683          	lbu	a3,15(sp)
80007338:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000733c:	6785                	lui	a5,0x1
8000733e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007342:	02f687b3          	mul	a5,a3,a5
80007346:	97ba                	add	a5,a5,a4
80007348:	6705                	lui	a4,0x1
8000734a:	97ba                	add	a5,a5,a4
8000734c:	8747c783          	lbu	a5,-1932(a5)
80007350:	01f14703          	lbu	a4,31(sp)
80007354:	f4f76fe3          	bltu	a4,a5,800072b2 <.L209>

80007358 <.LBE12>:
            }
        }
    }
}
80007358:	0001                	nop
8000735a:	0001                	nop
8000735c:	50b2                	lw	ra,44(sp)
8000735e:	6145                	add	sp,sp,48
80007360:	8082                	ret

Disassembly of section .text.usbd_event_reset_handler:

80007362 <usbd_event_reset_handler>:
        g_usbd_core[busid].event_handler(busid, USBD_EVENT_SUSPEND);
    }
}

void usbd_event_reset_handler(uint8_t busid)
{
80007362:	7179                	add	sp,sp,-48
80007364:	d606                	sw	ra,44(sp)
80007366:	87aa                	mv	a5,a0
80007368:	00f107a3          	sb	a5,15(sp)
    usbd_set_address(busid, 0);
8000736c:	00f14783          	lbu	a5,15(sp)
80007370:	4581                	li	a1,0
80007372:	853e                	mv	a0,a5
80007374:	207000ef          	jal	80007d7a <usbd_set_address>
    g_usbd_core[busid].device_address = 0;
80007378:	00f14683          	lbu	a3,15(sp)
8000737c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007380:	6785                	lui	a5,0x1
80007382:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007386:	02f687b3          	mul	a5,a3,a5
8000738a:	97ba                	add	a5,a5,a4
8000738c:	6705                	lui	a4,0x1
8000738e:	97ba                	add	a5,a5,a4
80007390:	80078ea3          	sb	zero,-2019(a5)
    g_usbd_core[busid].configuration = 0;
80007394:	00f14683          	lbu	a3,15(sp)
80007398:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000739c:	6785                	lui	a5,0x1
8000739e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800073a2:	02f687b3          	mul	a5,a3,a5
800073a6:	97ba                	add	a5,a5,a4
800073a8:	6705                	lui	a4,0x1
800073aa:	97ba                	add	a5,a5,a4
800073ac:	80078e23          	sb	zero,-2020(a5)
#ifdef CONFIG_USBDEV_ADVANCE_DESC
    g_usbd_core[busid].speed = USB_SPEED_UNKNOWN;
800073b0:	00f14683          	lbu	a3,15(sp)
800073b4:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800073b8:	6785                	lui	a5,0x1
800073ba:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800073be:	02f687b3          	mul	a5,a3,a5
800073c2:	97ba                	add	a5,a5,a4
800073c4:	6705                	lui	a4,0x1
800073c6:	97ba                	add	a5,a5,a4
800073c8:	82078123          	sb	zero,-2014(a5)
#endif
    struct usb_endpoint_descriptor ep0;

    ep0.bLength = 7;
800073cc:	479d                	li	a5,7
800073ce:	00f10c23          	sb	a5,24(sp)
    ep0.bDescriptorType = USB_DESCRIPTOR_TYPE_ENDPOINT;
800073d2:	4795                	li	a5,5
800073d4:	00f10ca3          	sb	a5,25(sp)
    ep0.wMaxPacketSize = USB_CTRL_EP_MPS;
800073d8:	04000793          	li	a5,64
800073dc:	00f11e23          	sh	a5,28(sp)
    ep0.bmAttributes = USB_ENDPOINT_TYPE_CONTROL;
800073e0:	00010da3          	sb	zero,27(sp)
    ep0.bEndpointAddress = USB_CONTROL_IN_EP0;
800073e4:	f8000793          	li	a5,-128
800073e8:	00f10d23          	sb	a5,26(sp)
    ep0.bInterval = 0;
800073ec:	00010f23          	sb	zero,30(sp)
    usbd_ep_open(busid, &ep0);
800073f0:	0838                	add	a4,sp,24
800073f2:	00f14783          	lbu	a5,15(sp)
800073f6:	85ba                	mv	a1,a4
800073f8:	853e                	mv	a0,a5
800073fa:	370040ef          	jal	8000b76a <usbd_ep_open>

    ep0.bEndpointAddress = USB_CONTROL_OUT_EP0;
800073fe:	00010d23          	sb	zero,26(sp)
    usbd_ep_open(busid, &ep0);
80007402:	0838                	add	a4,sp,24
80007404:	00f14783          	lbu	a5,15(sp)
80007408:	85ba                	mv	a1,a4
8000740a:	853e                	mv	a0,a5
8000740c:	35e040ef          	jal	8000b76a <usbd_ep_open>

    usbd_class_event_notify_handler(busid, USBD_EVENT_RESET, NULL);
80007410:	00f14783          	lbu	a5,15(sp)
80007414:	4601                	li	a2,0
80007416:	4585                	li	a1,1
80007418:	853e                	mv	a0,a5
8000741a:	3dbd                	jal	80007298 <usbd_class_event_notify_handler>
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_RESET);
8000741c:	00f14683          	lbu	a3,15(sp)
80007420:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007424:	6785                	lui	a5,0x1
80007426:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000742a:	02f687b3          	mul	a5,a3,a5
8000742e:	97ba                	add	a5,a5,a4
80007430:	6705                	lui	a4,0x1
80007432:	97ba                	add	a5,a5,a4
80007434:	9387a783          	lw	a5,-1736(a5)
80007438:	00f14703          	lbu	a4,15(sp)
8000743c:	4585                	li	a1,1
8000743e:	853a                	mv	a0,a4
80007440:	9782                	jalr	a5
}
80007442:	0001                	nop
80007444:	50b2                	lw	ra,44(sp)
80007446:	6145                	add	sp,sp,48
80007448:	8082                	ret

Disassembly of section .text.usbd_event_ep0_setup_complete_handler:

8000744a <usbd_event_ep0_setup_complete_handler>:

void usbd_event_ep0_setup_complete_handler(uint8_t busid, uint8_t *psetup)
{
8000744a:	7179                	add	sp,sp,-48
8000744c:	d606                	sw	ra,44(sp)
8000744e:	87aa                	mv	a5,a0
80007450:	c42e                	sw	a1,8(sp)
80007452:	00f107a3          	sb	a5,15(sp)
    struct usb_setup_packet *setup = &g_usbd_core[busid].setup;
80007456:	00f14703          	lbu	a4,15(sp)
8000745a:	6785                	lui	a5,0x1
8000745c:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007460:	02f70733          	mul	a4,a4,a5
80007464:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
80007468:	97ba                	add	a5,a5,a4
8000746a:	ce3e                	sw	a5,28(sp)
    uint8_t *buf;

    memcpy(setup, psetup, 8);
8000746c:	4621                	li	a2,8
8000746e:	45a2                	lw	a1,8(sp)
80007470:	4572                	lw	a0,28(sp)
80007472:	629010ef          	jal	8000929a <memcpy>
#ifdef CONFIG_USBDEV_SETUP_LOG_PRINT
    usbd_print_setup(setup);
#endif
    if (setup->wLength > CONFIG_USBDEV_REQUEST_BUFFER_LEN) {
80007476:	47f2                	lw	a5,28(sp)
80007478:	0067c703          	lbu	a4,6(a5)
8000747c:	0077c783          	lbu	a5,7(a5)
80007480:	07a2                	sll	a5,a5,0x8
80007482:	8fd9                	or	a5,a5,a4
80007484:	01079713          	sll	a4,a5,0x10
80007488:	8341                	srl	a4,a4,0x10
8000748a:	6785                	lui	a5,0x1
8000748c:	80078793          	add	a5,a5,-2048 # 800 <.L133+0x14>
80007490:	02e7fd63          	bgeu	a5,a4,800074ca <.L218>
        if ((setup->bmRequestType & USB_REQUEST_DIR_MASK) == USB_REQUEST_DIR_OUT) {
80007494:	47f2                	lw	a5,28(sp)
80007496:	0007c783          	lbu	a5,0(a5)
8000749a:	07e2                	sll	a5,a5,0x18
8000749c:	87e1                	sra	a5,a5,0x18
8000749e:	0207c663          	bltz	a5,800074ca <.L218>
            USB_LOG_ERR("Request buffer too small\r\n");
800074a2:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
800074a6:	7a9010ef          	jal	8000944e <printf>
800074aa:	6bc20513          	add	a0,tp,1724 # 6bc <.L148+0x22>
800074ae:	7a1010ef          	jal	8000944e <printf>
800074b2:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
800074b6:	799010ef          	jal	8000944e <printf>
            usbd_ep_set_stall(busid, USB_CONTROL_IN_EP0);
800074ba:	00f14783          	lbu	a5,15(sp)
800074be:	08000593          	li	a1,128
800074c2:	853e                	mv	a0,a5
800074c4:	0fd000ef          	jal	80007dc0 <usbd_ep_set_stall>
            return;
800074c8:	acd1                	j	8000779c <.L217>

800074ca <.L218>:
        }
    }

    g_usbd_core[busid].ep0_data_buf = g_usbd_core[busid].req_data;
800074ca:	00f14703          	lbu	a4,15(sp)
800074ce:	00f14603          	lbu	a2,15(sp)
800074d2:	6785                	lui	a5,0x1
800074d4:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800074d8:	02f707b3          	mul	a5,a4,a5
800074dc:	01078713          	add	a4,a5,16
800074e0:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
800074e4:	97ba                	add	a5,a5,a4
800074e6:	00c78713          	add	a4,a5,12
800074ea:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
800074ee:	6785                	lui	a5,0x1
800074f0:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800074f4:	02f607b3          	mul	a5,a2,a5
800074f8:	97b6                	add	a5,a5,a3
800074fa:	c798                	sw	a4,8(a5)
    g_usbd_core[busid].ep0_data_buf_residue = setup->wLength;
800074fc:	47f2                	lw	a5,28(sp)
800074fe:	0067c703          	lbu	a4,6(a5)
80007502:	0077c783          	lbu	a5,7(a5)
80007506:	07a2                	sll	a5,a5,0x8
80007508:	8fd9                	or	a5,a5,a4
8000750a:	07c2                	sll	a5,a5,0x10
8000750c:	83c1                	srl	a5,a5,0x10
8000750e:	00f14683          	lbu	a3,15(sp)
80007512:	863e                	mv	a2,a5
80007514:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007518:	6785                	lui	a5,0x1
8000751a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000751e:	02f687b3          	mul	a5,a3,a5
80007522:	97ba                	add	a5,a5,a4
80007524:	c7d0                	sw	a2,12(a5)
    g_usbd_core[busid].ep0_data_buf_len = setup->wLength;
80007526:	47f2                	lw	a5,28(sp)
80007528:	0067c703          	lbu	a4,6(a5)
8000752c:	0077c783          	lbu	a5,7(a5)
80007530:	07a2                	sll	a5,a5,0x8
80007532:	8fd9                	or	a5,a5,a4
80007534:	07c2                	sll	a5,a5,0x10
80007536:	83c1                	srl	a5,a5,0x10
80007538:	00f14683          	lbu	a3,15(sp)
8000753c:	863e                	mv	a2,a5
8000753e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007542:	6785                	lui	a5,0x1
80007544:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007548:	02f687b3          	mul	a5,a3,a5
8000754c:	97ba                	add	a5,a5,a4
8000754e:	cb90                	sw	a2,16(a5)
    g_usbd_core[busid].zlp_flag = false;
80007550:	00f14683          	lbu	a3,15(sp)
80007554:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007558:	6785                	lui	a5,0x1
8000755a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000755e:	02f687b3          	mul	a5,a3,a5
80007562:	97ba                	add	a5,a5,a4
80007564:	00078a23          	sb	zero,20(a5)
    buf = g_usbd_core[busid].ep0_data_buf;
80007568:	00f14683          	lbu	a3,15(sp)
8000756c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007570:	6785                	lui	a5,0x1
80007572:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007576:	02f687b3          	mul	a5,a3,a5
8000757a:	97ba                	add	a5,a5,a4
8000757c:	479c                	lw	a5,8(a5)
8000757e:	cc3e                	sw	a5,24(sp)

    /* handle class request when all the data is received */
    if (setup->wLength && ((setup->bmRequestType & USB_REQUEST_DIR_MASK) == USB_REQUEST_DIR_OUT)) {
80007580:	47f2                	lw	a5,28(sp)
80007582:	0067c703          	lbu	a4,6(a5)
80007586:	0077c783          	lbu	a5,7(a5)
8000758a:	07a2                	sll	a5,a5,0x8
8000758c:	8fd9                	or	a5,a5,a4
8000758e:	07c2                	sll	a5,a5,0x10
80007590:	83c1                	srl	a5,a5,0x10
80007592:	c7a9                	beqz	a5,800075dc <.L220>
80007594:	47f2                	lw	a5,28(sp)
80007596:	0007c783          	lbu	a5,0(a5)
8000759a:	07e2                	sll	a5,a5,0x18
8000759c:	87e1                	sra	a5,a5,0x18
8000759e:	0207cf63          	bltz	a5,800075dc <.L220>
        USB_LOG_DBG("Start reading %d bytes from ep0\r\n", setup->wLength);
        usbd_ep_start_read(busid, USB_CONTROL_OUT_EP0, g_usbd_core[busid].ep0_data_buf, setup->wLength);
800075a2:	00f14683          	lbu	a3,15(sp)
800075a6:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800075aa:	6785                	lui	a5,0x1
800075ac:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800075b0:	02f687b3          	mul	a5,a3,a5
800075b4:	97ba                	add	a5,a5,a4
800075b6:	4790                	lw	a2,8(a5)
800075b8:	47f2                	lw	a5,28(sp)
800075ba:	0067c703          	lbu	a4,6(a5)
800075be:	0077c783          	lbu	a5,7(a5)
800075c2:	07a2                	sll	a5,a5,0x8
800075c4:	8fd9                	or	a5,a5,a4
800075c6:	07c2                	sll	a5,a5,0x10
800075c8:	83c1                	srl	a5,a5,0x10
800075ca:	873e                	mv	a4,a5
800075cc:	00f14783          	lbu	a5,15(sp)
800075d0:	86ba                	mv	a3,a4
800075d2:	4581                	li	a1,0
800075d4:	853e                	mv	a0,a5
800075d6:	510040ef          	jal	8000bae6 <usbd_ep_start_read>
        return;
800075da:	a2c9                	j	8000779c <.L217>

800075dc <.L220>:
    }

    /* Ask installed handler to process request */
    if (!usbd_setup_request_handler(busid, setup, &buf, &g_usbd_core[busid].ep0_data_buf_len)) {
800075dc:	00f14703          	lbu	a4,15(sp)
800075e0:	6785                	lui	a5,0x1
800075e2:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800075e6:	02f707b3          	mul	a5,a4,a5
800075ea:	01078713          	add	a4,a5,16
800075ee:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
800075f2:	00f706b3          	add	a3,a4,a5
800075f6:	0838                	add	a4,sp,24
800075f8:	00f14783          	lbu	a5,15(sp)
800075fc:	863a                	mv	a2,a4
800075fe:	45f2                	lw	a1,28(sp)
80007600:	853e                	mv	a0,a5
80007602:	3ea5                	jal	8000717a <usbd_setup_request_handler>
80007604:	87aa                	mv	a5,a0
80007606:	0017c793          	xor	a5,a5,1
8000760a:	0ff7f793          	zext.b	a5,a5
8000760e:	cb81                	beqz	a5,8000761e <.L221>
        usbd_ep_set_stall(busid, USB_CONTROL_IN_EP0);
80007610:	00f14783          	lbu	a5,15(sp)
80007614:	08000593          	li	a1,128
80007618:	853e                	mv	a0,a5
8000761a:	275d                	jal	80007dc0 <usbd_ep_set_stall>
        return;
8000761c:	a241                	j	8000779c <.L217>

8000761e <.L221>:
    }

    /* Send smallest of requested and offered length */
    g_usbd_core[busid].ep0_data_buf_residue = MIN(g_usbd_core[busid].ep0_data_buf_len, setup->wLength);
8000761e:	47f2                	lw	a5,28(sp)
80007620:	0067c703          	lbu	a4,6(a5)
80007624:	0077c783          	lbu	a5,7(a5)
80007628:	07a2                	sll	a5,a5,0x8
8000762a:	8fd9                	or	a5,a5,a4
8000762c:	07c2                	sll	a5,a5,0x10
8000762e:	83c1                	srl	a5,a5,0x10
80007630:	85be                	mv	a1,a5
80007632:	00f14683          	lbu	a3,15(sp)
80007636:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000763a:	6785                	lui	a5,0x1
8000763c:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007640:	02f687b3          	mul	a5,a3,a5
80007644:	97ba                	add	a5,a5,a4
80007646:	4b9c                	lw	a5,16(a5)
80007648:	00f14603          	lbu	a2,15(sp)
8000764c:	872e                	mv	a4,a1
8000764e:	00e7f363          	bgeu	a5,a4,80007654 <.L222>
80007652:	873e                	mv	a4,a5

80007654 <.L222>:
80007654:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80007658:	6785                	lui	a5,0x1
8000765a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000765e:	02f607b3          	mul	a5,a2,a5
80007662:	97b6                	add	a5,a5,a3
80007664:	c7d8                	sw	a4,12(a5)
    if (g_usbd_core[busid].ep0_data_buf_residue > CONFIG_USBDEV_REQUEST_BUFFER_LEN) {
80007666:	00f14683          	lbu	a3,15(sp)
8000766a:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000766e:	6785                	lui	a5,0x1
80007670:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007674:	02f687b3          	mul	a5,a3,a5
80007678:	97ba                	add	a5,a5,a4
8000767a:	47d8                	lw	a4,12(a5)
8000767c:	6785                	lui	a5,0x1
8000767e:	80078793          	add	a5,a5,-2048 # 800 <.L133+0x14>
80007682:	02e7f563          	bgeu	a5,a4,800076ac <.L223>
        USB_LOG_ERR("Request buffer too small\r\n");
80007686:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
8000768a:	5c5010ef          	jal	8000944e <printf>
8000768e:	6bc20513          	add	a0,tp,1724 # 6bc <.L148+0x22>
80007692:	5bd010ef          	jal	8000944e <printf>
80007696:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
8000769a:	5b5010ef          	jal	8000944e <printf>
        usbd_ep_set_stall(busid, USB_CONTROL_IN_EP0);
8000769e:	00f14783          	lbu	a5,15(sp)
800076a2:	08000593          	li	a1,128
800076a6:	853e                	mv	a0,a5
800076a8:	2f21                	jal	80007dc0 <usbd_ep_set_stall>
        return;
800076aa:	a8cd                	j	8000779c <.L217>

800076ac <.L223>:
    }

    /* use *data = xxx; g_usbd_core[busid].ep0_data_buf records real data address, we should copy data into ep0 buffer.
     * Why we should copy once? because some chips are not access to flash with dma if real data address is in flash address(such as ch32).
     */
    if (buf != g_usbd_core[busid].ep0_data_buf) {
800076ac:	00f14683          	lbu	a3,15(sp)
800076b0:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800076b4:	6785                	lui	a5,0x1
800076b6:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800076ba:	02f687b3          	mul	a5,a3,a5
800076be:	97ba                	add	a5,a5,a4
800076c0:	4798                	lw	a4,8(a5)
800076c2:	47e2                	lw	a5,24(sp)
800076c4:	02f70c63          	beq	a4,a5,800076fc <.L224>
#ifdef CONFIG_USBDEV_EP0_INDATA_NO_COPY
        g_usbd_core[busid].ep0_data_buf = buf;
#else
        usb_memcpy(g_usbd_core[busid].ep0_data_buf, buf, g_usbd_core[busid].ep0_data_buf_residue);
800076c8:	00f14683          	lbu	a3,15(sp)
800076cc:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800076d0:	6785                	lui	a5,0x1
800076d2:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800076d6:	02f687b3          	mul	a5,a3,a5
800076da:	97ba                	add	a5,a5,a4
800076dc:	4788                	lw	a0,8(a5)
800076de:	45e2                	lw	a1,24(sp)
800076e0:	00f14683          	lbu	a3,15(sp)
800076e4:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800076e8:	6785                	lui	a5,0x1
800076ea:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800076ee:	02f687b3          	mul	a5,a3,a5
800076f2:	97ba                	add	a5,a5,a4
800076f4:	47dc                	lw	a5,12(a5)
800076f6:	863e                	mv	a2,a5
800076f8:	2b2030ef          	jal	8000a9aa <usb_memcpy>

800076fc <.L224>:
    } else {
        /* use memcpy(*data, xxx, len); has copied into ep0 buffer, we do nothing */
    }

    /* Send data or status to host */
    usbd_ep_start_write(busid, USB_CONTROL_IN_EP0, g_usbd_core[busid].ep0_data_buf, g_usbd_core[busid].ep0_data_buf_residue);
800076fc:	00f14683          	lbu	a3,15(sp)
80007700:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007704:	6785                	lui	a5,0x1
80007706:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000770a:	02f687b3          	mul	a5,a3,a5
8000770e:	97ba                	add	a5,a5,a4
80007710:	4790                	lw	a2,8(a5)
80007712:	00f14683          	lbu	a3,15(sp)
80007716:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000771a:	6785                	lui	a5,0x1
8000771c:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007720:	02f687b3          	mul	a5,a3,a5
80007724:	97ba                	add	a5,a5,a4
80007726:	47d8                	lw	a4,12(a5)
80007728:	00f14783          	lbu	a5,15(sp)
8000772c:	86ba                	mv	a3,a4
8000772e:	08000593          	li	a1,128
80007732:	853e                	mv	a0,a5
80007734:	2aa040ef          	jal	8000b9de <usbd_ep_start_write>
    /*
    * Set ZLP flag when host asks for a bigger length and the data size is
    * multiplier of USB_CTRL_EP_MPS, to indicate the transfer done after zlp
    * sent.
    */
    if ((setup->wLength > g_usbd_core[busid].ep0_data_buf_len) && (!(g_usbd_core[busid].ep0_data_buf_len % USB_CTRL_EP_MPS))) {
80007738:	47f2                	lw	a5,28(sp)
8000773a:	0067c703          	lbu	a4,6(a5)
8000773e:	0077c783          	lbu	a5,7(a5)
80007742:	07a2                	sll	a5,a5,0x8
80007744:	8fd9                	or	a5,a5,a4
80007746:	07c2                	sll	a5,a5,0x10
80007748:	83c1                	srl	a5,a5,0x10
8000774a:	863e                	mv	a2,a5
8000774c:	00f14683          	lbu	a3,15(sp)
80007750:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007754:	6785                	lui	a5,0x1
80007756:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000775a:	02f687b3          	mul	a5,a3,a5
8000775e:	97ba                	add	a5,a5,a4
80007760:	4b9c                	lw	a5,16(a5)
80007762:	02c7fd63          	bgeu	a5,a2,8000779c <.L217>
80007766:	00f14683          	lbu	a3,15(sp)
8000776a:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000776e:	6785                	lui	a5,0x1
80007770:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007774:	02f687b3          	mul	a5,a3,a5
80007778:	97ba                	add	a5,a5,a4
8000777a:	4b9c                	lw	a5,16(a5)
8000777c:	03f7f793          	and	a5,a5,63
80007780:	ef91                	bnez	a5,8000779c <.L217>
        g_usbd_core[busid].zlp_flag = true;
80007782:	00f14683          	lbu	a3,15(sp)
80007786:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000778a:	6785                	lui	a5,0x1
8000778c:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007790:	02f687b3          	mul	a5,a3,a5
80007794:	97ba                	add	a5,a5,a4
80007796:	4705                	li	a4,1
80007798:	00e78a23          	sb	a4,20(a5)

8000779c <.L217>:
        USB_LOG_DBG("EP0 Set zlp\r\n");
    }
}
8000779c:	50b2                	lw	ra,44(sp)
8000779e:	6145                	add	sp,sp,48
800077a0:	8082                	ret

Disassembly of section .text.usbd_event_ep0_in_complete_handler:

800077a2 <usbd_event_ep0_in_complete_handler>:

void usbd_event_ep0_in_complete_handler(uint8_t busid, uint8_t ep, uint32_t nbytes)
{
800077a2:	7179                	add	sp,sp,-48
800077a4:	d606                	sw	ra,44(sp)
800077a6:	87aa                	mv	a5,a0
800077a8:	872e                	mv	a4,a1
800077aa:	c432                	sw	a2,8(sp)
800077ac:	00f107a3          	sb	a5,15(sp)
800077b0:	87ba                	mv	a5,a4
800077b2:	00f10723          	sb	a5,14(sp)
    struct usb_setup_packet *setup = &g_usbd_core[busid].setup;
800077b6:	00f14703          	lbu	a4,15(sp)
800077ba:	6785                	lui	a5,0x1
800077bc:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800077c0:	02f70733          	mul	a4,a4,a5
800077c4:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
800077c8:	97ba                	add	a5,a5,a4
800077ca:	ce3e                	sw	a5,28(sp)

    (void)ep;

    g_usbd_core[busid].ep0_data_buf += nbytes;
800077cc:	00f14683          	lbu	a3,15(sp)
800077d0:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800077d4:	6785                	lui	a5,0x1
800077d6:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800077da:	02f687b3          	mul	a5,a3,a5
800077de:	97ba                	add	a5,a5,a4
800077e0:	4798                	lw	a4,8(a5)
800077e2:	00f14603          	lbu	a2,15(sp)
800077e6:	47a2                	lw	a5,8(sp)
800077e8:	973e                	add	a4,a4,a5
800077ea:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
800077ee:	6785                	lui	a5,0x1
800077f0:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800077f4:	02f607b3          	mul	a5,a2,a5
800077f8:	97b6                	add	a5,a5,a3
800077fa:	c798                	sw	a4,8(a5)
    g_usbd_core[busid].ep0_data_buf_residue -= nbytes;
800077fc:	00f14683          	lbu	a3,15(sp)
80007800:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007804:	6785                	lui	a5,0x1
80007806:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000780a:	02f687b3          	mul	a5,a3,a5
8000780e:	97ba                	add	a5,a5,a4
80007810:	47d8                	lw	a4,12(a5)
80007812:	00f14603          	lbu	a2,15(sp)
80007816:	47a2                	lw	a5,8(sp)
80007818:	8f1d                	sub	a4,a4,a5
8000781a:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000781e:	6785                	lui	a5,0x1
80007820:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007824:	02f607b3          	mul	a5,a2,a5
80007828:	97b6                	add	a5,a5,a3
8000782a:	c7d8                	sw	a4,12(a5)

    USB_LOG_DBG("EP0 send %d bytes, %d remained\r\n", nbytes, g_usbd_core[busid].ep0_data_buf_residue);

    if (g_usbd_core[busid].ep0_data_buf_residue != 0) {
8000782c:	00f14683          	lbu	a3,15(sp)
80007830:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007834:	6785                	lui	a5,0x1
80007836:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000783a:	02f687b3          	mul	a5,a3,a5
8000783e:	97ba                	add	a5,a5,a4
80007840:	47dc                	lw	a5,12(a5)
80007842:	c3a1                	beqz	a5,80007882 <.L228>
        /* Start sending the remain data */
        usbd_ep_start_write(busid, USB_CONTROL_IN_EP0, g_usbd_core[busid].ep0_data_buf, g_usbd_core[busid].ep0_data_buf_residue);
80007844:	00f14683          	lbu	a3,15(sp)
80007848:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000784c:	6785                	lui	a5,0x1
8000784e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007852:	02f687b3          	mul	a5,a3,a5
80007856:	97ba                	add	a5,a5,a4
80007858:	4790                	lw	a2,8(a5)
8000785a:	00f14683          	lbu	a3,15(sp)
8000785e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007862:	6785                	lui	a5,0x1
80007864:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007868:	02f687b3          	mul	a5,a3,a5
8000786c:	97ba                	add	a5,a5,a4
8000786e:	47d8                	lw	a4,12(a5)
80007870:	00f14783          	lbu	a5,15(sp)
80007874:	86ba                	mv	a3,a4
80007876:	08000593          	li	a1,128
8000787a:	853e                	mv	a0,a5
8000787c:	162040ef          	jal	8000b9de <usbd_ep_start_write>
                g_usbd_core[busid].test_req = false;
            }
#endif
        }
    }
}
80007880:	a8f1                	j	8000795c <.L232>

80007882 <.L228>:
        if (g_usbd_core[busid].zlp_flag == true) {
80007882:	00f14683          	lbu	a3,15(sp)
80007886:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000788a:	6785                	lui	a5,0x1
8000788c:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007890:	02f687b3          	mul	a5,a3,a5
80007894:	97ba                	add	a5,a5,a4
80007896:	0147c783          	lbu	a5,20(a5)
8000789a:	c79d                	beqz	a5,800078c8 <.L230>
            g_usbd_core[busid].zlp_flag = false;
8000789c:	00f14683          	lbu	a3,15(sp)
800078a0:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
800078a4:	6785                	lui	a5,0x1
800078a6:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
800078aa:	02f687b3          	mul	a5,a3,a5
800078ae:	97ba                	add	a5,a5,a4
800078b0:	00078a23          	sb	zero,20(a5)
            usbd_ep_start_write(busid, USB_CONTROL_IN_EP0, NULL, 0);
800078b4:	00f14783          	lbu	a5,15(sp)
800078b8:	4681                	li	a3,0
800078ba:	4601                	li	a2,0
800078bc:	08000593          	li	a1,128
800078c0:	853e                	mv	a0,a5
800078c2:	11c040ef          	jal	8000b9de <usbd_ep_start_write>
}
800078c6:	a859                	j	8000795c <.L232>

800078c8 <.L230>:
            if (setup->wLength && ((setup->bmRequestType & USB_REQUEST_DIR_MASK) == USB_REQUEST_DIR_IN)) {
800078c8:	47f2                	lw	a5,28(sp)
800078ca:	0067c703          	lbu	a4,6(a5)
800078ce:	0077c783          	lbu	a5,7(a5)
800078d2:	07a2                	sll	a5,a5,0x8
800078d4:	8fd9                	or	a5,a5,a4
800078d6:	07c2                	sll	a5,a5,0x10
800078d8:	83c1                	srl	a5,a5,0x10
800078da:	c385                	beqz	a5,800078fa <.L231>
800078dc:	47f2                	lw	a5,28(sp)
800078de:	0007c783          	lbu	a5,0(a5)
800078e2:	07e2                	sll	a5,a5,0x18
800078e4:	87e1                	sra	a5,a5,0x18
800078e6:	0007da63          	bgez	a5,800078fa <.L231>
                usbd_ep_start_read(busid, USB_CONTROL_OUT_EP0, NULL, 0);
800078ea:	00f14783          	lbu	a5,15(sp)
800078ee:	4681                	li	a3,0
800078f0:	4601                	li	a2,0
800078f2:	4581                	li	a1,0
800078f4:	853e                	mv	a0,a5
800078f6:	1f0040ef          	jal	8000bae6 <usbd_ep_start_read>

800078fa <.L231>:
            if (g_usbd_core[busid].test_req) {
800078fa:	00f14683          	lbu	a3,15(sp)
800078fe:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007902:	6785                	lui	a5,0x1
80007904:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007908:	02f687b3          	mul	a5,a3,a5
8000790c:	97ba                	add	a5,a5,a4
8000790e:	6705                	lui	a4,0x1
80007910:	97ba                	add	a5,a5,a4
80007912:	8237c783          	lbu	a5,-2013(a5)
80007916:	c3b9                	beqz	a5,8000795c <.L232>
                usbd_execute_test_mode(busid, HI_BYTE(setup->wIndex));
80007918:	47f2                	lw	a5,28(sp)
8000791a:	0047c703          	lbu	a4,4(a5)
8000791e:	0057c783          	lbu	a5,5(a5)
80007922:	07a2                	sll	a5,a5,0x8
80007924:	8fd9                	or	a5,a5,a4
80007926:	07c2                	sll	a5,a5,0x10
80007928:	83c1                	srl	a5,a5,0x10
8000792a:	83a1                	srl	a5,a5,0x8
8000792c:	07c2                	sll	a5,a5,0x10
8000792e:	83c1                	srl	a5,a5,0x10
80007930:	0ff7f713          	zext.b	a4,a5
80007934:	00f14783          	lbu	a5,15(sp)
80007938:	85ba                	mv	a1,a4
8000793a:	853e                	mv	a0,a5
8000793c:	593030ef          	jal	8000b6ce <usbd_execute_test_mode>
                g_usbd_core[busid].test_req = false;
80007940:	00f14683          	lbu	a3,15(sp)
80007944:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007948:	6785                	lui	a5,0x1
8000794a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000794e:	02f687b3          	mul	a5,a3,a5
80007952:	97ba                	add	a5,a5,a4
80007954:	6705                	lui	a4,0x1
80007956:	97ba                	add	a5,a5,a4
80007958:	820781a3          	sb	zero,-2013(a5)

8000795c <.L232>:
}
8000795c:	0001                	nop
8000795e:	50b2                	lw	ra,44(sp)
80007960:	6145                	add	sp,sp,48
80007962:	8082                	ret

Disassembly of section .text.usbd_event_ep_in_complete_handler:

80007964 <usbd_event_ep_in_complete_handler>:
        USB_LOG_DBG("EP0 recv out status\r\n");
    }
}

void usbd_event_ep_in_complete_handler(uint8_t busid, uint8_t ep, uint32_t nbytes)
{
80007964:	1101                	add	sp,sp,-32
80007966:	ce06                	sw	ra,28(sp)
80007968:	87aa                	mv	a5,a0
8000796a:	872e                	mv	a4,a1
8000796c:	c432                	sw	a2,8(sp)
8000796e:	00f107a3          	sb	a5,15(sp)
80007972:	87ba                	mv	a5,a4
80007974:	00f10723          	sb	a5,14(sp)
    if (g_usbd_core[busid].tx_msg[ep & 0x7f].cb) {
80007978:	00f14603          	lbu	a2,15(sp)
8000797c:	00e14783          	lbu	a5,14(sp)
80007980:	07f7f713          	and	a4,a5,127
80007984:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80007988:	87ba                	mv	a5,a4
8000798a:	0786                	sll	a5,a5,0x1
8000798c:	97ba                	add	a5,a5,a4
8000798e:	078a                	sll	a5,a5,0x2
80007990:	6705                	lui	a4,0x1
80007992:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
80007996:	02e60733          	mul	a4,a2,a4
8000799a:	97ba                	add	a5,a5,a4
8000799c:	97b6                	add	a5,a5,a3
8000799e:	6705                	lui	a4,0x1
800079a0:	97ba                	add	a5,a5,a4
800079a2:	8807a783          	lw	a5,-1920(a5)
800079a6:	c3a1                	beqz	a5,800079e6 <.L239>
        g_usbd_core[busid].tx_msg[ep & 0x7f].cb(busid, ep, nbytes);
800079a8:	00f14603          	lbu	a2,15(sp)
800079ac:	00e14783          	lbu	a5,14(sp)
800079b0:	07f7f713          	and	a4,a5,127
800079b4:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
800079b8:	87ba                	mv	a5,a4
800079ba:	0786                	sll	a5,a5,0x1
800079bc:	97ba                	add	a5,a5,a4
800079be:	078a                	sll	a5,a5,0x2
800079c0:	6705                	lui	a4,0x1
800079c2:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
800079c6:	02e60733          	mul	a4,a2,a4
800079ca:	97ba                	add	a5,a5,a4
800079cc:	97b6                	add	a5,a5,a3
800079ce:	6705                	lui	a4,0x1
800079d0:	97ba                	add	a5,a5,a4
800079d2:	8807a783          	lw	a5,-1920(a5)
800079d6:	00e14683          	lbu	a3,14(sp)
800079da:	00f14703          	lbu	a4,15(sp)
800079de:	4622                	lw	a2,8(sp)
800079e0:	85b6                	mv	a1,a3
800079e2:	853a                	mv	a0,a4
800079e4:	9782                	jalr	a5

800079e6 <.L239>:
    }
}
800079e6:	0001                	nop
800079e8:	40f2                	lw	ra,28(sp)
800079ea:	6105                	add	sp,sp,32
800079ec:	8082                	ret

Disassembly of section .text.usbd_event_ep_out_complete_handler:

800079ee <usbd_event_ep_out_complete_handler>:

void usbd_event_ep_out_complete_handler(uint8_t busid, uint8_t ep, uint32_t nbytes)
{
800079ee:	1101                	add	sp,sp,-32
800079f0:	ce06                	sw	ra,28(sp)
800079f2:	87aa                	mv	a5,a0
800079f4:	872e                	mv	a4,a1
800079f6:	c432                	sw	a2,8(sp)
800079f8:	00f107a3          	sb	a5,15(sp)
800079fc:	87ba                	mv	a5,a4
800079fe:	00f10723          	sb	a5,14(sp)
    if (g_usbd_core[busid].rx_msg[ep & 0x7f].cb) {
80007a02:	00f14603          	lbu	a2,15(sp)
80007a06:	00e14783          	lbu	a5,14(sp)
80007a0a:	07f7f713          	and	a4,a5,127
80007a0e:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80007a12:	87ba                	mv	a5,a4
80007a14:	0786                	sll	a5,a5,0x1
80007a16:	97ba                	add	a5,a5,a4
80007a18:	078a                	sll	a5,a5,0x2
80007a1a:	6705                	lui	a4,0x1
80007a1c:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
80007a20:	02e60733          	mul	a4,a2,a4
80007a24:	97ba                	add	a5,a5,a4
80007a26:	97b6                	add	a5,a5,a3
80007a28:	6705                	lui	a4,0x1
80007a2a:	97ba                	add	a5,a5,a4
80007a2c:	8e07a783          	lw	a5,-1824(a5)
80007a30:	c3a1                	beqz	a5,80007a70 <.L242>
        g_usbd_core[busid].rx_msg[ep & 0x7f].cb(busid, ep, nbytes);
80007a32:	00f14603          	lbu	a2,15(sp)
80007a36:	00e14783          	lbu	a5,14(sp)
80007a3a:	07f7f713          	and	a4,a5,127
80007a3e:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
80007a42:	87ba                	mv	a5,a4
80007a44:	0786                	sll	a5,a5,0x1
80007a46:	97ba                	add	a5,a5,a4
80007a48:	078a                	sll	a5,a5,0x2
80007a4a:	6705                	lui	a4,0x1
80007a4c:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
80007a50:	02e60733          	mul	a4,a2,a4
80007a54:	97ba                	add	a5,a5,a4
80007a56:	97b6                	add	a5,a5,a3
80007a58:	6705                	lui	a4,0x1
80007a5a:	97ba                	add	a5,a5,a4
80007a5c:	8e07a783          	lw	a5,-1824(a5)
80007a60:	00e14683          	lbu	a3,14(sp)
80007a64:	00f14703          	lbu	a4,15(sp)
80007a68:	4622                	lw	a2,8(sp)
80007a6a:	85b6                	mv	a1,a3
80007a6c:	853a                	mv	a0,a4
80007a6e:	9782                	jalr	a5

80007a70 <.L242>:
    }
}
80007a70:	0001                	nop
80007a72:	40f2                	lw	ra,28(sp)
80007a74:	6105                	add	sp,sp,32
80007a76:	8082                	ret

Disassembly of section .text.usbd_desc_register:

80007a78 <usbd_desc_register>:

#ifdef CONFIG_USBDEV_ADVANCE_DESC
void usbd_desc_register(uint8_t busid, const struct usb_descriptor *desc)
{
80007a78:	1101                	add	sp,sp,-32
80007a7a:	ce06                	sw	ra,28(sp)
80007a7c:	87aa                	mv	a5,a0
80007a7e:	c42e                	sw	a1,8(sp)
80007a80:	00f107a3          	sb	a5,15(sp)
    memset(&g_usbd_core[busid], 0, sizeof(struct usbd_core_priv));
80007a84:	00f14703          	lbu	a4,15(sp)
80007a88:	6785                	lui	a5,0x1
80007a8a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007a8e:	02f70733          	mul	a4,a4,a5
80007a92:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
80007a96:	973e                	add	a4,a4,a5
80007a98:	6785                	lui	a5,0x1
80007a9a:	93c78613          	add	a2,a5,-1732 # 93c <.L165+0x12>
80007a9e:	4581                	li	a1,0
80007aa0:	853a                	mv	a0,a4
80007aa2:	3f0050ef          	jal	8000ce92 <memset>

    g_usbd_core[busid].descriptors = desc;
80007aa6:	00f14683          	lbu	a3,15(sp)
80007aaa:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007aae:	6785                	lui	a5,0x1
80007ab0:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007ab4:	02f687b3          	mul	a5,a3,a5
80007ab8:	97ba                	add	a5,a5,a4
80007aba:	4722                	lw	a4,8(sp)
80007abc:	cf98                	sw	a4,24(a5)
    g_usbd_core[busid].intf_offset = 0;
80007abe:	00f14683          	lbu	a3,15(sp)
80007ac2:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007ac6:	6785                	lui	a5,0x1
80007ac8:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007acc:	02f687b3          	mul	a5,a3,a5
80007ad0:	97ba                	add	a5,a5,a4
80007ad2:	6705                	lui	a4,0x1
80007ad4:	97ba                	add	a5,a5,a4
80007ad6:	86078a23          	sb	zero,-1932(a5)

    g_usbd_core[busid].tx_msg[0].ep = 0x80;
80007ada:	00f14683          	lbu	a3,15(sp)
80007ade:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007ae2:	6785                	lui	a5,0x1
80007ae4:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007ae8:	02f687b3          	mul	a5,a3,a5
80007aec:	97ba                	add	a5,a5,a4
80007aee:	6705                	lui	a4,0x1
80007af0:	97ba                	add	a5,a5,a4
80007af2:	f8000713          	li	a4,-128
80007af6:	86e78c23          	sb	a4,-1928(a5)
    g_usbd_core[busid].tx_msg[0].cb = usbd_event_ep0_in_complete_handler;
80007afa:	00f14683          	lbu	a3,15(sp)
80007afe:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007b02:	6785                	lui	a5,0x1
80007b04:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007b08:	02f687b3          	mul	a5,a3,a5
80007b0c:	97ba                	add	a5,a5,a4
80007b0e:	6705                	lui	a4,0x1
80007b10:	97ba                	add	a5,a5,a4
80007b12:	80007737          	lui	a4,0x80007
80007b16:	7a270713          	add	a4,a4,1954 # 800077a2 <usbd_event_ep0_in_complete_handler>
80007b1a:	88e7a023          	sw	a4,-1920(a5)
    g_usbd_core[busid].rx_msg[0].ep = 0x00;
80007b1e:	00f14683          	lbu	a3,15(sp)
80007b22:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007b26:	6785                	lui	a5,0x1
80007b28:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007b2c:	02f687b3          	mul	a5,a3,a5
80007b30:	97ba                	add	a5,a5,a4
80007b32:	6705                	lui	a4,0x1
80007b34:	97ba                	add	a5,a5,a4
80007b36:	8c078c23          	sb	zero,-1832(a5)
    g_usbd_core[busid].rx_msg[0].cb = usbd_event_ep0_out_complete_handler;
80007b3a:	00f14683          	lbu	a3,15(sp)
80007b3e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
80007b42:	6785                	lui	a5,0x1
80007b44:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
80007b48:	02f687b3          	mul	a5,a3,a5
80007b4c:	97ba                	add	a5,a5,a4
80007b4e:	6705                	lui	a4,0x1
80007b50:	97ba                	add	a5,a5,a4
80007b52:	8000b737          	lui	a4,0x8000b
80007b56:	20a70713          	add	a4,a4,522 # 8000b20a <usbd_event_ep0_out_complete_handler>
80007b5a:	8ee7a023          	sw	a4,-1824(a5)
}
80007b5e:	0001                	nop
80007b60:	40f2                	lw	ra,28(sp)
80007b62:	6105                	add	sp,sp,32
80007b64:	8082                	ret

Disassembly of section .text.ep_idx2bit:

80007b66 <ep_idx2bit>:
static uint32_t _dcd_irqnum[CONFIG_USBDEV_MAX_BUS];
static uint8_t _dcd_busid[CONFIG_USBDEV_MAX_BUS];

/* Index to bit position in register */
static inline uint8_t ep_idx2bit(uint8_t ep_idx)
{
80007b66:	1141                	add	sp,sp,-16
80007b68:	87aa                	mv	a5,a0
80007b6a:	00f107a3          	sb	a5,15(sp)
    return ep_idx / 2 + ((ep_idx % 2) ? 16 : 0);
80007b6e:	00f14783          	lbu	a5,15(sp)
80007b72:	8385                	srl	a5,a5,0x1
80007b74:	0ff7f713          	zext.b	a4,a5
80007b78:	00f14783          	lbu	a5,15(sp)
80007b7c:	0792                	sll	a5,a5,0x4
80007b7e:	0ff7f793          	zext.b	a5,a5
80007b82:	8bc1                	and	a5,a5,16
80007b84:	0ff7f793          	zext.b	a5,a5
80007b88:	97ba                	add	a5,a5,a4
80007b8a:	0ff7f793          	zext.b	a5,a5
}
80007b8e:	853e                	mv	a0,a5
80007b90:	0141                	add	sp,sp,16
80007b92:	8082                	ret

Disassembly of section .text.usb_dc_init:

80007b94 <usb_dc_init>:
{
    usb_set_port_test_mode(g_hpm_udc[busid].handle->regs, test_mode);
}

int usb_dc_init(uint8_t busid)
{
80007b94:	7139                	add	sp,sp,-64
80007b96:	de06                	sw	ra,60(sp)
80007b98:	87aa                	mv	a5,a0
80007b9a:	00f107a3          	sb	a5,15(sp)
    memset(&g_hpm_udc[busid], 0, sizeof(struct hpm_udc));
80007b9e:	00f14703          	lbu	a4,15(sp)
80007ba2:	14800793          	li	a5,328
80007ba6:	02f70733          	mul	a4,a4,a5
80007baa:	010807b7          	lui	a5,0x1080
80007bae:	02478793          	add	a5,a5,36 # 1080024 <g_hpm_udc>
80007bb2:	97ba                	add	a5,a5,a4
80007bb4:	14800613          	li	a2,328
80007bb8:	4581                	li	a1,0
80007bba:	853e                	mv	a0,a5
80007bbc:	2d6050ef          	jal	8000ce92 <memset>
    g_hpm_udc[busid].handle = &usb_device_handle[busid];
80007bc0:	00f14783          	lbu	a5,15(sp)
80007bc4:	00f14603          	lbu	a2,15(sp)
80007bc8:	00379713          	sll	a4,a5,0x3
80007bcc:	011037b7          	lui	a5,0x1103
80007bd0:	c0078793          	add	a5,a5,-1024 # 1102c00 <usb_device_handle>
80007bd4:	973e                	add	a4,a4,a5
80007bd6:	010807b7          	lui	a5,0x1080
80007bda:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
80007bde:	14800793          	li	a5,328
80007be2:	02f607b3          	mul	a5,a2,a5
80007be6:	97b6                	add	a5,a5,a3
80007be8:	c398                	sw	a4,0(a5)
    g_hpm_udc[busid].handle->regs = (USB_Type *)g_usbdev_bus[busid].reg_base;
80007bea:	00f14783          	lbu	a5,15(sp)
80007bee:	01080737          	lui	a4,0x1080
80007bf2:	31c70713          	add	a4,a4,796 # 108031c <g_usbdev_bus>
80007bf6:	078e                	sll	a5,a5,0x3
80007bf8:	97ba                	add	a5,a5,a4
80007bfa:	43d0                	lw	a2,4(a5)
80007bfc:	00f14683          	lbu	a3,15(sp)
80007c00:	010807b7          	lui	a5,0x1080
80007c04:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
80007c08:	14800793          	li	a5,328
80007c0c:	02f687b3          	mul	a5,a3,a5
80007c10:	97ba                	add	a5,a5,a4
80007c12:	439c                	lw	a5,0(a5)
80007c14:	8732                	mv	a4,a2
80007c16:	c398                	sw	a4,0(a5)

    if (g_usbdev_bus[busid].reg_base == HPM_USB0_BASE) {
80007c18:	00f14783          	lbu	a5,15(sp)
80007c1c:	01080737          	lui	a4,0x1080
80007c20:	31c70713          	add	a4,a4,796 # 108031c <g_usbdev_bus>
80007c24:	078e                	sll	a5,a5,0x3
80007c26:	97ba                	add	a5,a5,a4
80007c28:	43d8                	lw	a4,4(a5)
80007c2a:	f20207b7          	lui	a5,0xf2020
80007c2e:	02f71463          	bne	a4,a5,80007c56 <.L13>
        _dcd_irqnum[busid] = IRQn_USB0;
80007c32:	00f14783          	lbu	a5,15(sp)
80007c36:	01080737          	lui	a4,0x1080
80007c3a:	32c70713          	add	a4,a4,812 # 108032c <_dcd_irqnum>
80007c3e:	078a                	sll	a5,a5,0x2
80007c40:	97ba                	add	a5,a5,a4
80007c42:	06a00713          	li	a4,106
80007c46:	c398                	sw	a4,0(a5)
        _dcd_busid[0] = busid;
80007c48:	010807b7          	lui	a5,0x1080
80007c4c:	00f14703          	lbu	a4,15(sp)
80007c50:	34e78423          	sb	a4,840(a5) # 1080348 <_dcd_busid>
80007c54:	a089                	j	80007c96 <.L14>

80007c56 <.L13>:
    } else {
#ifdef HPM_USB1_BASE
        if (g_usbdev_bus[busid].reg_base == HPM_USB1_BASE) {
80007c56:	00f14783          	lbu	a5,15(sp)
80007c5a:	01080737          	lui	a4,0x1080
80007c5e:	31c70713          	add	a4,a4,796 # 108031c <g_usbdev_bus>
80007c62:	078e                	sll	a5,a5,0x3
80007c64:	97ba                	add	a5,a5,a4
80007c66:	43d8                	lw	a4,4(a5)
80007c68:	f20247b7          	lui	a5,0xf2024
80007c6c:	02f71563          	bne	a4,a5,80007c96 <.L14>
            _dcd_irqnum[busid] = IRQn_USB1;
80007c70:	00f14783          	lbu	a5,15(sp)
80007c74:	01080737          	lui	a4,0x1080
80007c78:	32c70713          	add	a4,a4,812 # 108032c <_dcd_irqnum>
80007c7c:	078a                	sll	a5,a5,0x2
80007c7e:	97ba                	add	a5,a5,a4
80007c80:	06b00713          	li	a4,107
80007c84:	c398                	sw	a4,0(a5)
            _dcd_busid[1] = busid;
80007c86:	010807b7          	lui	a5,0x1080
80007c8a:	34878793          	add	a5,a5,840 # 1080348 <_dcd_busid>
80007c8e:	00f14703          	lbu	a4,15(sp)
80007c92:	00e780a3          	sb	a4,1(a5)

80007c96 <.L14>:
        }
#endif
    }

    if (busid == 0) {
80007c96:	00f14783          	lbu	a5,15(sp)
80007c9a:	e39d                	bnez	a5,80007cc0 <.L15>
        g_hpm_udc[busid].handle->dcd_data = &_dcd_data0;
80007c9c:	00f14683          	lbu	a3,15(sp)
80007ca0:	010807b7          	lui	a5,0x1080
80007ca4:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
80007ca8:	14800793          	li	a5,328
80007cac:	02f687b3          	mul	a5,a3,a5
80007cb0:	97ba                	add	a5,a5,a4
80007cb2:	439c                	lw	a5,0(a5)
80007cb4:	01100737          	lui	a4,0x1100
80007cb8:	00070713          	mv	a4,a4
80007cbc:	c3d8                	sw	a4,4(a5)
80007cbe:	a03d                	j	80007cec <.L16>

80007cc0 <.L15>:
    } else if (busid == 1) {
80007cc0:	00f14703          	lbu	a4,15(sp)
80007cc4:	4785                	li	a5,1
80007cc6:	02f71363          	bne	a4,a5,80007cec <.L16>
#ifdef HPM_USB1_BASE
        g_hpm_udc[busid].handle->dcd_data = &_dcd_data1;
80007cca:	00f14683          	lbu	a3,15(sp)
80007cce:	010807b7          	lui	a5,0x1080
80007cd2:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
80007cd6:	14800793          	li	a5,328
80007cda:	02f687b3          	mul	a5,a3,a5
80007cde:	97ba                	add	a5,a5,a4
80007ce0:	439c                	lw	a5,0(a5)
80007ce2:	01102737          	lui	a4,0x1102
80007ce6:	80070713          	add	a4,a4,-2048 # 1101800 <_dcd_data1>
80007cea:	c3d8                	sw	a4,4(a5)

80007cec <.L16>:
    } else {
        ;
    }

    uint32_t int_mask;
    int_mask = (USB_USBINTR_UE_MASK | USB_USBINTR_UEE_MASK | USB_USBINTR_SLE_MASK |
80007cec:	14700793          	li	a5,327
80007cf0:	d63e                	sw	a5,44(sp)
                USB_USBINTR_PCE_MASK | USB_USBINTR_URE_MASK);

    usb_device_init(g_hpm_udc[busid].handle, int_mask);
80007cf2:	00f14683          	lbu	a3,15(sp)
80007cf6:	010807b7          	lui	a5,0x1080
80007cfa:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
80007cfe:	14800793          	li	a5,328
80007d02:	02f687b3          	mul	a5,a3,a5
80007d06:	97ba                	add	a5,a5,a4
80007d08:	439c                	lw	a5,0(a5)
80007d0a:	55b2                	lw	a1,44(sp)
80007d0c:	853e                	mv	a0,a5
80007d0e:	21d010ef          	jal	8000972a <usb_device_init>

    intc_m_enable_irq(_dcd_irqnum[busid]);
80007d12:	00f14783          	lbu	a5,15(sp)
80007d16:	01080737          	lui	a4,0x1080
80007d1a:	32c70713          	add	a4,a4,812 # 108032c <_dcd_irqnum>
80007d1e:	078a                	sll	a5,a5,0x2
80007d20:	97ba                	add	a5,a5,a4
80007d22:	439c                	lw	a5,0(a5)
80007d24:	d402                	sw	zero,40(sp)
80007d26:	d23e                	sw	a5,36(sp)
80007d28:	e40007b7          	lui	a5,0xe4000
80007d2c:	d03e                	sw	a5,32(sp)
80007d2e:	57a2                	lw	a5,40(sp)
80007d30:	ce3e                	sw	a5,28(sp)
80007d32:	5792                	lw	a5,36(sp)
80007d34:	cc3e                	sw	a5,24(sp)

80007d36 <.LBB14>:
                                                        uint32_t target,
                                                        uint32_t irq)
{
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_ENABLE_OFFSET +
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80007d36:	47f2                	lw	a5,28(sp)
80007d38:	00779713          	sll	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
80007d3c:	5782                	lw	a5,32(sp)
80007d3e:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
80007d40:	47e2                	lw	a5,24(sp)
80007d42:	8395                	srl	a5,a5,0x5
80007d44:	078a                	sll	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80007d46:	973e                	add	a4,a4,a5
80007d48:	6789                	lui	a5,0x2
80007d4a:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
80007d4c:	ca3e                	sw	a5,20(sp)
    uint32_t current = *current_ptr;
80007d4e:	47d2                	lw	a5,20(sp)
80007d50:	439c                	lw	a5,0(a5)
80007d52:	c83e                	sw	a5,16(sp)
    current = current | (1 << (irq & 0x1F));
80007d54:	47e2                	lw	a5,24(sp)
80007d56:	8bfd                	and	a5,a5,31
80007d58:	4705                	li	a4,1
80007d5a:	00f717b3          	sll	a5,a4,a5
80007d5e:	873e                	mv	a4,a5
80007d60:	47c2                	lw	a5,16(sp)
80007d62:	8fd9                	or	a5,a5,a4
80007d64:	c83e                	sw	a5,16(sp)
    *current_ptr = current;
80007d66:	47d2                	lw	a5,20(sp)
80007d68:	4742                	lw	a4,16(sp)
80007d6a:	c398                	sw	a4,0(a5)
}
80007d6c:	0001                	nop

80007d6e <.LBE16>:
 * @param[in] irq Interrupt number
 */
ATTR_ALWAYS_INLINE static inline void intc_enable_irq(uint32_t target, uint32_t irq)
{
    __plic_enable_irq(HPM_PLIC_BASE, target, irq);
}
80007d6e:	0001                	nop

80007d70 <.LBE14>:
    return 0;
80007d70:	4781                	li	a5,0
}
80007d72:	853e                	mv	a0,a5
80007d74:	50f2                	lw	ra,60(sp)
80007d76:	6121                	add	sp,sp,64
80007d78:	8082                	ret

Disassembly of section .text.usbd_set_address:

80007d7a <usbd_set_address>:

    return 0;
}

int usbd_set_address(uint8_t busid, const uint8_t addr)
{
80007d7a:	7179                	add	sp,sp,-48
80007d7c:	d606                	sw	ra,44(sp)
80007d7e:	87aa                	mv	a5,a0
80007d80:	872e                	mv	a4,a1
80007d82:	00f107a3          	sb	a5,15(sp)
80007d86:	87ba                	mv	a5,a4
80007d88:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
80007d8c:	00f14683          	lbu	a3,15(sp)
80007d90:	010807b7          	lui	a5,0x1080
80007d94:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
80007d98:	14800793          	li	a5,328
80007d9c:	02f687b3          	mul	a5,a3,a5
80007da0:	97ba                	add	a5,a5,a4
80007da2:	439c                	lw	a5,0(a5)
80007da4:	ce3e                	sw	a5,28(sp)
    usb_dcd_set_address(handle->regs, addr);
80007da6:	47f2                	lw	a5,28(sp)
80007da8:	439c                	lw	a5,0(a5)
80007daa:	00e14703          	lbu	a4,14(sp)
80007dae:	85ba                	mv	a1,a4
80007db0:	853e                	mv	a0,a5
80007db2:	0f9030ef          	jal	8000b6aa <usb_dcd_set_address>
    return 0;
80007db6:	4781                	li	a5,0
}
80007db8:	853e                	mv	a0,a5
80007dba:	50b2                	lw	ra,44(sp)
80007dbc:	6145                	add	sp,sp,48
80007dbe:	8082                	ret

Disassembly of section .text.usbd_ep_set_stall:

80007dc0 <usbd_ep_set_stall>:

    return 0;
}

int usbd_ep_set_stall(uint8_t busid, const uint8_t ep)
{
80007dc0:	7179                	add	sp,sp,-48
80007dc2:	d606                	sw	ra,44(sp)
80007dc4:	87aa                	mv	a5,a0
80007dc6:	872e                	mv	a4,a1
80007dc8:	00f107a3          	sb	a5,15(sp)
80007dcc:	87ba                	mv	a5,a4
80007dce:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
80007dd2:	00f14683          	lbu	a3,15(sp)
80007dd6:	010807b7          	lui	a5,0x1080
80007dda:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
80007dde:	14800793          	li	a5,328
80007de2:	02f687b3          	mul	a5,a3,a5
80007de6:	97ba                	add	a5,a5,a4
80007de8:	439c                	lw	a5,0(a5)
80007dea:	ce3e                	sw	a5,28(sp)

    usb_device_edpt_stall(handle, ep);
80007dec:	00e14783          	lbu	a5,14(sp)
80007df0:	85be                	mv	a1,a5
80007df2:	4572                	lw	a0,28(sp)
80007df4:	1ff010ef          	jal	800097f2 <usb_device_edpt_stall>
    return 0;
80007df8:	4781                	li	a5,0
}
80007dfa:	853e                	mv	a0,a5
80007dfc:	50b2                	lw	ra,44(sp)
80007dfe:	6145                	add	sp,sp,48
80007e00:	8082                	ret

Disassembly of section .text.usbd_ep_clear_stall:

80007e02 <usbd_ep_clear_stall>:

int usbd_ep_clear_stall(uint8_t busid, const uint8_t ep)
{
80007e02:	7179                	add	sp,sp,-48
80007e04:	d606                	sw	ra,44(sp)
80007e06:	87aa                	mv	a5,a0
80007e08:	872e                	mv	a4,a1
80007e0a:	00f107a3          	sb	a5,15(sp)
80007e0e:	87ba                	mv	a5,a4
80007e10:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
80007e14:	00f14683          	lbu	a3,15(sp)
80007e18:	010807b7          	lui	a5,0x1080
80007e1c:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
80007e20:	14800793          	li	a5,328
80007e24:	02f687b3          	mul	a5,a3,a5
80007e28:	97ba                	add	a5,a5,a4
80007e2a:	439c                	lw	a5,0(a5)
80007e2c:	ce3e                	sw	a5,28(sp)

    usb_device_edpt_clear_stall(handle, ep);
80007e2e:	00e14783          	lbu	a5,14(sp)
80007e32:	85be                	mv	a1,a5
80007e34:	4572                	lw	a0,28(sp)
80007e36:	1e1010ef          	jal	80009816 <usb_device_edpt_clear_stall>
    return 0;
80007e3a:	4781                	li	a5,0
}
80007e3c:	853e                	mv	a0,a5
80007e3e:	50b2                	lw	ra,44(sp)
80007e40:	6145                	add	sp,sp,48
80007e42:	8082                	ret

Disassembly of section .text.usbd_ep_is_stalled:

80007e44 <usbd_ep_is_stalled>:

int usbd_ep_is_stalled(uint8_t busid, const uint8_t ep, uint8_t *stalled)
{
80007e44:	7179                	add	sp,sp,-48
80007e46:	d606                	sw	ra,44(sp)
80007e48:	87aa                	mv	a5,a0
80007e4a:	872e                	mv	a4,a1
80007e4c:	c432                	sw	a2,8(sp)
80007e4e:	00f107a3          	sb	a5,15(sp)
80007e52:	87ba                	mv	a5,a4
80007e54:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
80007e58:	00f14683          	lbu	a3,15(sp)
80007e5c:	010807b7          	lui	a5,0x1080
80007e60:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
80007e64:	14800793          	li	a5,328
80007e68:	02f687b3          	mul	a5,a3,a5
80007e6c:	97ba                	add	a5,a5,a4
80007e6e:	439c                	lw	a5,0(a5)
80007e70:	ce3e                	sw	a5,28(sp)

    *stalled = usb_device_edpt_check_stall(handle, ep);
80007e72:	00e14783          	lbu	a5,14(sp)
80007e76:	85be                	mv	a1,a5
80007e78:	4572                	lw	a0,28(sp)
80007e7a:	889fc0ef          	jal	80004702 <usb_device_edpt_check_stall>
80007e7e:	87aa                	mv	a5,a0
80007e80:	873e                	mv	a4,a5
80007e82:	47a2                	lw	a5,8(sp)
80007e84:	00e78023          	sb	a4,0(a5)
    return 0;
80007e88:	4781                	li	a5,0
}
80007e8a:	853e                	mv	a0,a5
80007e8c:	50b2                	lw	ra,44(sp)
80007e8e:	6145                	add	sp,sp,48
80007e90:	8082                	ret

Disassembly of section .text.syscall_handler:

80007e92 <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
80007e92:	1101                	add	sp,sp,-32
80007e94:	ce2a                	sw	a0,28(sp)
80007e96:	cc2e                	sw	a1,24(sp)
80007e98:	ca32                	sw	a2,20(sp)
80007e9a:	c836                	sw	a3,16(sp)
80007e9c:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
80007e9e:	0001                	nop
80007ea0:	6105                	add	sp,sp,32
80007ea2:	8082                	ret

Disassembly of section .text.pllctl_get_div:

80007ea4 <pllctl_get_div>:
 * @param[in] div_index Target DIV to query
 *
 * @return Divider value of target DIV
 */
static inline hpm_stat_t pllctl_get_div(PLLCTL_Type *ptr, uint8_t pll, uint8_t div_index)
{
80007ea4:	1141                	add	sp,sp,-16
80007ea6:	c62a                	sw	a0,12(sp)
80007ea8:	87ae                	mv	a5,a1
80007eaa:	8732                	mv	a4,a2
80007eac:	00f105a3          	sb	a5,11(sp)
80007eb0:	87ba                	mv	a5,a4
80007eb2:	00f10523          	sb	a5,10(sp)
    if ((pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1))
80007eb6:	00b14703          	lbu	a4,11(sp)
80007eba:	4791                	li	a5,4
80007ebc:	00e7ec63          	bltu	a5,a4,80007ed4 <.L6>
            || !(PLLCTL_SOC_PLL_HAS_DIV0(pll))) {
80007ec0:	00b14703          	lbu	a4,11(sp)
80007ec4:	4785                	li	a5,1
80007ec6:	00f70963          	beq	a4,a5,80007ed8 <.L7>
80007eca:	00b14703          	lbu	a4,11(sp)
80007ece:	4789                	li	a5,2
80007ed0:	00f70463          	beq	a4,a5,80007ed8 <.L7>

80007ed4 <.L6>:
        return status_invalid_argument;
80007ed4:	4789                	li	a5,2
80007ed6:	a80d                	j	80007f08 <.L8>

80007ed8 <.L7>:
    }
    if (div_index) {
80007ed8:	00a14783          	lbu	a5,10(sp)
80007edc:	cf81                	beqz	a5,80007ef4 <.L9>
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV1) + 1;
80007ede:	00b14783          	lbu	a5,11(sp)
80007ee2:	4732                	lw	a4,12(sp)
80007ee4:	079e                	sll	a5,a5,0x7
80007ee6:	97ba                	add	a5,a5,a4
80007ee8:	0c47a783          	lw	a5,196(a5)
80007eec:	0ff7f793          	zext.b	a5,a5
80007ef0:	0785                	add	a5,a5,1
80007ef2:	a819                	j	80007f08 <.L8>

80007ef4 <.L9>:
    } else {
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV0) + 1;
80007ef4:	00b14783          	lbu	a5,11(sp)
80007ef8:	4732                	lw	a4,12(sp)
80007efa:	079e                	sll	a5,a5,0x7
80007efc:	97ba                	add	a5,a5,a4
80007efe:	0c07a783          	lw	a5,192(a5)
80007f02:	0ff7f793          	zext.b	a5,a5
80007f06:	0785                	add	a5,a5,1

80007f08 <.L8>:
    }
}
80007f08:	853e                	mv	a0,a5
80007f0a:	0141                	add	sp,sp,16
80007f0c:	8082                	ret

Disassembly of section .text.clock_get_frequency:

80007f0e <clock_get_frequency>:

/***********************************************************************************************************************
 * Codes
 **********************************************************************************************************************/
uint32_t clock_get_frequency(clock_name_t clock_name)
{
80007f0e:	7179                	add	sp,sp,-48
80007f10:	d606                	sw	ra,44(sp)
80007f12:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80007f14:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80007f16:	47b2                	lw	a5,12(sp)
80007f18:	83a1                	srl	a5,a5,0x8
80007f1a:	0ff7f793          	zext.b	a5,a5
80007f1e:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80007f20:	47b2                	lw	a5,12(sp)
80007f22:	0ff7f793          	zext.b	a5,a5
80007f26:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80007f28:	4762                	lw	a4,24(sp)
80007f2a:	47b1                	li	a5,12
80007f2c:	08e7ee63          	bltu	a5,a4,80007fc8 <.L18>
80007f30:	47e2                	lw	a5,24(sp)
80007f32:	00279713          	sll	a4,a5,0x2
80007f36:	800037b7          	lui	a5,0x80003
80007f3a:	42878793          	add	a5,a5,1064 # 80003428 <.L20>
80007f3e:	97ba                	add	a5,a5,a4
80007f40:	439c                	lw	a5,0(a5)
80007f42:	8782                	jr	a5

80007f44 <.L32>:
    case CLK_SRC_GROUP_COMMON:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
80007f44:	47d2                	lw	a5,20(sp)
80007f46:	0ff7f793          	zext.b	a5,a5
80007f4a:	853e                	mv	a0,a5
80007f4c:	2069                	jal	80007fd6 <.LFE130>
80007f4e:	ce2a                	sw	a0,28(sp)
        break;
80007f50:	a8b5                	j	80007fcc <.L33>

80007f52 <.L31>:
    case CLK_SRC_GROUP_ADC:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_ADC, node_or_instance);
80007f52:	45d2                	lw	a1,20(sp)
80007f54:	4505                	li	a0,1
80007f56:	1c4040ef          	jal	8000c11a <get_frequency_for_i2s_or_adc>
80007f5a:	ce2a                	sw	a0,28(sp)
        break;
80007f5c:	a885                	j	80007fcc <.L33>

80007f5e <.L30>:
    case CLK_SRC_GROUP_I2S:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_I2S, node_or_instance);
80007f5e:	45d2                	lw	a1,20(sp)
80007f60:	4509                	li	a0,2
80007f62:	1b8040ef          	jal	8000c11a <get_frequency_for_i2s_or_adc>
80007f66:	ce2a                	sw	a0,28(sp)
        break;
80007f68:	a095                	j	80007fcc <.L33>

80007f6a <.L29>:
    case CLK_SRC_GROUP_WDG:
        clk_freq = get_frequency_for_wdg(node_or_instance);
80007f6a:	4552                	lw	a0,20(sp)
80007f6c:	286040ef          	jal	8000c1f2 <get_frequency_for_wdg>
80007f70:	ce2a                	sw	a0,28(sp)
        break;
80007f72:	a8a9                	j	80007fcc <.L33>

80007f74 <.L19>:
    case CLK_SRC_GROUP_PWDG:
        clk_freq = get_frequency_for_pwdg();
80007f74:	2b2040ef          	jal	8000c226 <get_frequency_for_pwdg>
80007f78:	ce2a                	sw	a0,28(sp)
        break;
80007f7a:	a889                	j	80007fcc <.L33>

80007f7c <.L28>:
    case CLK_SRC_GROUP_PMIC:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80007f7c:	016e37b7          	lui	a5,0x16e3
80007f80:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80007f84:	ce3e                	sw	a5,28(sp)
        break;
80007f86:	a099                	j	80007fcc <.L33>

80007f88 <.L27>:
    case CLK_SRC_GROUP_AHB:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
80007f88:	451d                	li	a0,7
80007f8a:	20b1                	jal	80007fd6 <.LFE130>
80007f8c:	ce2a                	sw	a0,28(sp)
        break;
80007f8e:	a83d                	j	80007fcc <.L33>

80007f90 <.L26>:
    case CLK_SRC_GROUP_AXI0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi0);
80007f90:	4511                	li	a0,4
80007f92:	2091                	jal	80007fd6 <.LFE130>
80007f94:	ce2a                	sw	a0,28(sp)
        break;
80007f96:	a81d                	j	80007fcc <.L33>

80007f98 <.L25>:
    case CLK_SRC_GROUP_AXI1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi1);
80007f98:	4515                	li	a0,5
80007f9a:	2835                	jal	80007fd6 <.LFE130>
80007f9c:	ce2a                	sw	a0,28(sp)
        break;
80007f9e:	a03d                	j	80007fcc <.L33>

80007fa0 <.L24>:
    case CLK_SRC_GROUP_AXI2:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi2);
80007fa0:	4519                	li	a0,6
80007fa2:	2815                	jal	80007fd6 <.LFE130>
80007fa4:	ce2a                	sw	a0,28(sp)
        break;
80007fa6:	a01d                	j	80007fcc <.L33>

80007fa8 <.L23>:
    case CLK_SRC_GROUP_CPU0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
80007fa8:	4501                	li	a0,0
80007faa:	2035                	jal	80007fd6 <.LFE130>
80007fac:	ce2a                	sw	a0,28(sp)
        break;
80007fae:	a839                	j	80007fcc <.L33>

80007fb0 <.L22>:
    case CLK_SRC_GROUP_CPU1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu1);
80007fb0:	4509                	li	a0,2
80007fb2:	2015                	jal	80007fd6 <.LFE130>
80007fb4:	ce2a                	sw	a0,28(sp)
        break;
80007fb6:	a819                	j	80007fcc <.L33>

80007fb8 <.L21>:
    case CLK_SRC_GROUP_SRC:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
80007fb8:	47d2                	lw	a5,20(sp)
80007fba:	0ff7f793          	zext.b	a5,a5
80007fbe:	853e                	mv	a0,a5
80007fc0:	05a040ef          	jal	8000c01a <get_frequency_for_source>
80007fc4:	ce2a                	sw	a0,28(sp)
        break;
80007fc6:	a019                	j	80007fcc <.L33>

80007fc8 <.L18>:
    default:
        clk_freq = 0UL;
80007fc8:	ce02                	sw	zero,28(sp)
        break;
80007fca:	0001                	nop

80007fcc <.L33>:
    }
    return clk_freq;
80007fcc:	47f2                	lw	a5,28(sp)
}
80007fce:	853e                	mv	a0,a5
80007fd0:	50b2                	lw	ra,44(sp)
80007fd2:	6145                	add	sp,sp,48
80007fd4:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

80007fd6 <get_frequency_for_ip_in_common_group>:

    return clk_freq;
}

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
80007fd6:	7139                	add	sp,sp,-64
80007fd8:	de06                	sw	ra,60(sp)
80007fda:	87aa                	mv	a5,a0
80007fdc:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80007fe0:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
80007fe2:	00f14783          	lbu	a5,15(sp)
80007fe6:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
80007fe8:	5722                	lw	a4,40(sp)
80007fea:	04a00793          	li	a5,74
80007fee:	04e7e663          	bltu	a5,a4,8000803a <.L49>

80007ff2 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
80007ff2:	57a2                	lw	a5,40(sp)
80007ff4:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
80007ff6:	f4000737          	lui	a4,0xf4000
80007ffa:	5792                	lw	a5,36(sp)
80007ffc:	60078793          	add	a5,a5,1536
80008000:	078a                	sll	a5,a5,0x2
80008002:	97ba                	add	a5,a5,a4
80008004:	439c                	lw	a5,0(a5)
80008006:	0ff7f793          	zext.b	a5,a5
8000800a:	0785                	add	a5,a5,1
8000800c:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
8000800e:	f4000737          	lui	a4,0xf4000
80008012:	5792                	lw	a5,36(sp)
80008014:	60078793          	add	a5,a5,1536
80008018:	078a                	sll	a5,a5,0x2
8000801a:	97ba                	add	a5,a5,a4
8000801c:	439c                	lw	a5,0(a5)
8000801e:	83a1                	srl	a5,a5,0x8
80008020:	8bbd                	and	a5,a5,15
80008022:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
80008026:	01f14783          	lbu	a5,31(sp)
8000802a:	853e                	mv	a0,a5
8000802c:	7ef030ef          	jal	8000c01a <get_frequency_for_source>
80008030:	872a                	mv	a4,a0
80008032:	5782                	lw	a5,32(sp)
80008034:	02f757b3          	divu	a5,a4,a5
80008038:	d63e                	sw	a5,44(sp)

8000803a <.L49>:
    }
    return clk_freq;
8000803a:	57b2                	lw	a5,44(sp)
}
8000803c:	853e                	mv	a0,a5
8000803e:	50f2                	lw	ra,60(sp)
80008040:	6121                	add	sp,sp,64
80008042:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

80008044 <clock_set_source_divider>:
    }
    return status_success;
}

hpm_stat_t clock_set_source_divider(clock_name_t clock_name, clk_src_t src, uint32_t div)
{
80008044:	7179                	add	sp,sp,-48
80008046:	d606                	sw	ra,44(sp)
80008048:	c62a                	sw	a0,12(sp)
8000804a:	87ae                	mv	a5,a1
8000804c:	c232                	sw	a2,4(sp)
8000804e:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
80008052:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80008054:	47b2                	lw	a5,12(sp)
80008056:	83a1                	srl	a5,a5,0x8
80008058:	0ff7f793          	zext.b	a5,a5
8000805c:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
8000805e:	47b2                	lw	a5,12(sp)
80008060:	0ff7f793          	zext.b	a5,a5
80008064:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80008066:	4762                	lw	a4,24(sp)
80008068:	47b1                	li	a5,12
8000806a:	0ae7e163          	bltu	a5,a4,8000810c <.L140>
8000806e:	47e2                	lw	a5,24(sp)
80008070:	00279713          	sll	a4,a5,0x2
80008074:	800037b7          	lui	a5,0x80003
80008078:	47c78793          	add	a5,a5,1148 # 8000347c <.L142>
8000807c:	97ba                	add	a5,a5,a4
8000807e:	439c                	lw	a5,0(a5)
80008080:	8782                	jr	a5

80008082 <.L150>:
    case CLK_SRC_GROUP_COMMON:
        if ((div < 1U) || (div > 256U)) {
80008082:	4792                	lw	a5,4(sp)
80008084:	c791                	beqz	a5,80008090 <.L151>
80008086:	4712                	lw	a4,4(sp)
80008088:	10000793          	li	a5,256
8000808c:	00e7f763          	bgeu	a5,a4,8000809a <.L152>

80008090 <.L151>:
            status = status_clk_div_invalid;
80008090:	6795                	lui	a5,0x5
80008092:	5f078793          	add	a5,a5,1520 # 55f0 <__NONCACHEABLE_RAM_segment_used_size__+0xf8>
80008096:	ce3e                	sw	a5,28(sp)
        } else {
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
        }
        break;
80008098:	a8bd                	j	80008116 <.L154>

8000809a <.L152>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
8000809a:	00b14783          	lbu	a5,11(sp)
8000809e:	8bbd                	and	a5,a5,15
800080a0:	00f109a3          	sb	a5,19(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
800080a4:	47d2                	lw	a5,20(sp)
800080a6:	0ff7f793          	zext.b	a5,a5
800080aa:	01314703          	lbu	a4,19(sp)
800080ae:	4692                	lw	a3,4(sp)
800080b0:	863a                	mv	a2,a4
800080b2:	85be                	mv	a1,a5
800080b4:	f4000537          	lui	a0,0xf4000
800080b8:	2a59                	jal	8000824e <sysctl_config_clock>

800080ba <.LBE14>:
        break;
800080ba:	a8b1                	j	80008116 <.L154>

800080bc <.L141>:
    case CLK_SRC_GROUP_ADC:
    case CLK_SRC_GROUP_I2S:
    case CLK_SRC_GROUP_WDG:
    case CLK_SRC_GROUP_PWDG:
    case CLK_SRC_GROUP_SRC:
        status = status_clk_operation_unsupported;
800080bc:	6795                	lui	a5,0x5
800080be:	5f378793          	add	a5,a5,1523 # 55f3 <__NONCACHEABLE_RAM_segment_used_size__+0xfb>
800080c2:	ce3e                	sw	a5,28(sp)
        break;
800080c4:	a889                	j	80008116 <.L154>

800080c6 <.L149>:
    case CLK_SRC_GROUP_PMIC:
        status = status_clk_fixed;
800080c6:	6795                	lui	a5,0x5
800080c8:	5fa78793          	add	a5,a5,1530 # 55fa <__NONCACHEABLE_RAM_segment_used_size__+0x102>
800080cc:	ce3e                	sw	a5,28(sp)
        break;
800080ce:	a0a1                	j	80008116 <.L154>

800080d0 <.L148>:
    case CLK_SRC_GROUP_AHB:
        status = status_clk_shared_ahb;
800080d0:	6795                	lui	a5,0x5
800080d2:	5f478793          	add	a5,a5,1524 # 55f4 <__NONCACHEABLE_RAM_segment_used_size__+0xfc>
800080d6:	ce3e                	sw	a5,28(sp)
        break;
800080d8:	a83d                	j	80008116 <.L154>

800080da <.L147>:
    case CLK_SRC_GROUP_AXI0:
        status = status_clk_shared_axi0;
800080da:	6795                	lui	a5,0x5
800080dc:	5f578793          	add	a5,a5,1525 # 55f5 <__NONCACHEABLE_RAM_segment_used_size__+0xfd>
800080e0:	ce3e                	sw	a5,28(sp)
        break;
800080e2:	a815                	j	80008116 <.L154>

800080e4 <.L146>:
    case CLK_SRC_GROUP_AXI1:
        status = status_clk_shared_axi1;
800080e4:	6795                	lui	a5,0x5
800080e6:	5f678793          	add	a5,a5,1526 # 55f6 <__NONCACHEABLE_RAM_segment_used_size__+0xfe>
800080ea:	ce3e                	sw	a5,28(sp)
        break;
800080ec:	a02d                	j	80008116 <.L154>

800080ee <.L145>:
    case CLK_SRC_GROUP_AXI2:
        status = status_clk_shared_axi2;
800080ee:	6795                	lui	a5,0x5
800080f0:	5f778793          	add	a5,a5,1527 # 55f7 <__NONCACHEABLE_RAM_segment_used_size__+0xff>
800080f4:	ce3e                	sw	a5,28(sp)
        break;
800080f6:	a005                	j	80008116 <.L154>

800080f8 <.L144>:
    case CLK_SRC_GROUP_CPU0:
        status = status_clk_shared_cpu0;
800080f8:	6795                	lui	a5,0x5
800080fa:	5f878793          	add	a5,a5,1528 # 55f8 <__NONCACHEABLE_RAM_segment_used_size__+0x100>
800080fe:	ce3e                	sw	a5,28(sp)
        break;
80008100:	a819                	j	80008116 <.L154>

80008102 <.L143>:
    case CLK_SRC_GROUP_CPU1:
        status = status_clk_shared_cpu1;
80008102:	6795                	lui	a5,0x5
80008104:	5f978793          	add	a5,a5,1529 # 55f9 <__NONCACHEABLE_RAM_segment_used_size__+0x101>
80008108:	ce3e                	sw	a5,28(sp)
        break;
8000810a:	a031                	j	80008116 <.L154>

8000810c <.L140>:
    default:
        status = status_clk_src_invalid;
8000810c:	6795                	lui	a5,0x5
8000810e:	5f178793          	add	a5,a5,1521 # 55f1 <__NONCACHEABLE_RAM_segment_used_size__+0xf9>
80008112:	ce3e                	sw	a5,28(sp)
        break;
80008114:	0001                	nop

80008116 <.L154>:
    }

    return status;
80008116:	47f2                	lw	a5,28(sp)
}
80008118:	853e                	mv	a0,a5
8000811a:	50b2                	lw	ra,44(sp)
8000811c:	6145                	add	sp,sp,48
8000811e:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80008120 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80008120:	7179                	add	sp,sp,-48
80008122:	d606                	sw	ra,44(sp)
80008124:	c62a                	sw	a0,12(sp)
80008126:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80008128:	47b2                	lw	a5,12(sp)
8000812a:	83c1                	srl	a5,a5,0x10
8000812c:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
8000812e:	4772                	lw	a4,28(sp)
80008130:	15d00793          	li	a5,349
80008134:	00e7ef63          	bltu	a5,a4,80008152 <.L165>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80008138:	47a2                	lw	a5,8(sp)
8000813a:	0ff7f793          	zext.b	a5,a5
8000813e:	4772                	lw	a4,28(sp)
80008140:	0742                	sll	a4,a4,0x10
80008142:	8341                	srl	a4,a4,0x10
80008144:	4685                	li	a3,1
80008146:	863a                	mv	a2,a4
80008148:	85be                	mv	a1,a5
8000814a:	f4000537          	lui	a0,0xf4000
8000814e:	140040ef          	jal	8000c28e <sysctl_enable_group_resource>

80008152 <.L165>:
    }
}
80008152:	0001                	nop
80008154:	50b2                	lw	ra,44(sp)
80008156:	6145                	add	sp,sp,48
80008158:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

8000815a <clock_update_core_clock>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_update_core_clock(void)
{
8000815a:	1101                	add	sp,sp,-32
8000815c:	ce06                	sw	ra,28(sp)

8000815e <.LBB16>:
    uint32_t hart_id = read_csr(CSR_MHARTID);
8000815e:	f14027f3          	csrr	a5,mhartid
80008162:	c63e                	sw	a5,12(sp)
80008164:	47b2                	lw	a5,12(sp)

80008166 <.LBE16>:
80008166:	c43e                	sw	a5,8(sp)
    clock_name_t cpu_clk_name = (hart_id == 1U) ? clock_cpu1 : clock_cpu0;
80008168:	4722                	lw	a4,8(sp)
8000816a:	4785                	li	a5,1
8000816c:	00f71663          	bne	a4,a5,80008178 <.L192>
80008170:	000807b7          	lui	a5,0x80
80008174:	0789                	add	a5,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
80008176:	a011                	j	8000817a <.L193>

80008178 <.L192>:
80008178:	4781                	li	a5,0

8000817a <.L193>:
8000817a:	c23e                	sw	a5,4(sp)
    hpm_core_clock = clock_get_frequency(cpu_clk_name);
8000817c:	4512                	lw	a0,4(sp)
8000817e:	3b41                	jal	80007f0e <clock_get_frequency>
80008180:	872a                	mv	a4,a0
80008182:	010807b7          	lui	a5,0x1080
80008186:	32e7aa23          	sw	a4,820(a5) # 1080334 <hpm_core_clock>
8000818a:	0001                	nop
8000818c:	40f2                	lw	ra,28(sp)
8000818e:	6105                	add	sp,sp,32
80008190:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80008192 <l1c_dc_enable>:

    write_csr(CSR_MSTATUS, csr);
}

void l1c_dc_enable(void)
{
80008192:	1141                	add	sp,sp,-16

80008194 <.LBB56>:
extern "C" {
#endif
/* get cache control register value */
__attribute__((always_inline)) static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80008194:	7ca027f3          	csrr	a5,0x7ca
80008198:	c63e                	sw	a5,12(sp)
8000819a:	47b2                	lw	a5,12(sp)

8000819c <.LBE60>:
8000819c:	0001                	nop

8000819e <.LBE58>:
}

__attribute__((always_inline)) static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
8000819e:	8b89                	and	a5,a5,2
800081a0:	00f037b3          	snez	a5,a5
800081a4:	0ff7f793          	zext.b	a5,a5

800081a8 <.LBE56>:
    if (!l1c_dc_is_enabled()) {
800081a8:	0017c793          	xor	a5,a5,1
800081ac:	0ff7f793          	zext.b	a5,a5
800081b0:	cb89                	beqz	a5,800081c2 <.L13>
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
800081b2:	001807b7          	lui	a5,0x180
800081b6:	7ca7b073          	csrc	0x7ca,a5
        set_csr(CSR_MCACHE_CTL,
800081ba:	67c1                	lui	a5,0x10
800081bc:	0789                	add	a5,a5,2 # 10002 <__XPI0_segment_used_size__+0x33ca>
800081be:	7ca7a073          	csrs	0x7ca,a5

800081c2 <.L13>:
                HPM_MCACHE_CTL_DC_WAROUND(L1C_DC_WAROUND_VALUE) |
#endif
                                HPM_MCACHE_CTL_DPREF_EN_MASK
                              | HPM_MCACHE_CTL_DC_EN_MASK);
    }
}
800081c2:	0001                	nop
800081c4:	0141                	add	sp,sp,16
800081c6:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

800081c8 <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
800081c8:	1141                	add	sp,sp,-16

800081ca <.LBB66>:
    return read_csr(CSR_MCACHE_CTL);
800081ca:	7ca027f3          	csrr	a5,0x7ca
800081ce:	c63e                	sw	a5,12(sp)
800081d0:	47b2                	lw	a5,12(sp)

800081d2 <.LBE70>:
800081d2:	0001                	nop

800081d4 <.LBE68>:
}

__attribute__((always_inline)) static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
800081d4:	8b85                	and	a5,a5,1
800081d6:	00f037b3          	snez	a5,a5
800081da:	0ff7f793          	zext.b	a5,a5

800081de <.LBE66>:
    if (!l1c_ic_is_enabled()) {
800081de:	0017c793          	xor	a5,a5,1
800081e2:	0ff7f793          	zext.b	a5,a5
800081e6:	c789                	beqz	a5,800081f0 <.L23>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
800081e8:	30100793          	li	a5,769
800081ec:	7ca7a073          	csrs	0x7ca,a5

800081f0 <.L23>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
800081f0:	0001                	nop
800081f2:	0141                	add	sp,sp,16
800081f4:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

800081f6 <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
800081f6:	1141                	add	sp,sp,-16
800081f8:	c62a                	sw	a0,12(sp)
800081fa:	87ae                	mv	a5,a1
800081fc:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
80008200:	00a15783          	lhu	a5,10(sp)
80008204:	4732                	lw	a4,12(sp)
80008206:	078a                	sll	a5,a5,0x2
80008208:	97ba                	add	a5,a5,a4
8000820a:	4398                	lw	a4,0(a5)
8000820c:	400007b7          	lui	a5,0x40000
80008210:	8ff9                	and	a5,a5,a4
80008212:	00f037b3          	snez	a5,a5
80008216:	0ff7f793          	zext.b	a5,a5
}
8000821a:	853e                	mv	a0,a5
8000821c:	0141                	add	sp,sp,16
8000821e:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

80008220 <sysctl_clock_target_is_busy>:
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr,
                                               clock_node_t clock)
{
80008220:	1141                	add	sp,sp,-16
80008222:	c62a                	sw	a0,12(sp)
80008224:	87ae                	mv	a5,a1
80008226:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
8000822a:	00b14783          	lbu	a5,11(sp)
8000822e:	4732                	lw	a4,12(sp)
80008230:	60078793          	add	a5,a5,1536 # 40000600 <__SHARE_RAM_segment_end__+0x3ee80600>
80008234:	078a                	sll	a5,a5,0x2
80008236:	97ba                	add	a5,a5,a4
80008238:	4398                	lw	a4,0(a5)
8000823a:	400007b7          	lui	a5,0x40000
8000823e:	8ff9                	and	a5,a5,a4
80008240:	00f037b3          	snez	a5,a5
80008244:	0ff7f793          	zext.b	a5,a5
}
80008248:	853e                	mv	a0,a5
8000824a:	0141                	add	sp,sp,16
8000824c:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

8000824e <sysctl_config_clock>:
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node,
                                clock_source_t source, uint32_t divide_by)
{
8000824e:	1101                	add	sp,sp,-32
80008250:	ce06                	sw	ra,28(sp)
80008252:	c62a                	sw	a0,12(sp)
80008254:	87ae                	mv	a5,a1
80008256:	8732                	mv	a4,a2
80008258:	c236                	sw	a3,4(sp)
8000825a:	00f105a3          	sb	a5,11(sp)
8000825e:	87ba                	mv	a5,a4
80008260:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_i2s_start) {
80008264:	00b14703          	lbu	a4,11(sp)
80008268:	04200793          	li	a5,66
8000826c:	00e7f463          	bgeu	a5,a4,80008274 <.L114>
        return status_invalid_argument;
80008270:	4789                	li	a5,2
80008272:	a89d                	j	800082e8 <.L115>

80008274 <.L114>:
    }

    if (source >= clock_source_general_source_end) {
80008274:	00a14703          	lbu	a4,10(sp)
80008278:	479d                	li	a5,7
8000827a:	00e7f463          	bgeu	a5,a4,80008282 <.L116>
        return status_invalid_argument;
8000827e:	4789                	li	a5,2
80008280:	a0a5                	j	800082e8 <.L115>

80008282 <.L116>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80008282:	00b14783          	lbu	a5,11(sp)
80008286:	4732                	lw	a4,12(sp)
80008288:	60078793          	add	a5,a5,1536 # 40000600 <__SHARE_RAM_segment_end__+0x3ee80600>
8000828c:	078a                	sll	a5,a5,0x2
8000828e:	97ba                	add	a5,a5,a4
80008290:	4398                	lw	a4,0(a5)
80008292:	77fd                	lui	a5,0xfffff
80008294:	00f776b3          	and	a3,a4,a5
            ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK))
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80008298:	00a14783          	lbu	a5,10(sp)
8000829c:	00879713          	sll	a4,a5,0x8
800082a0:	6785                	lui	a5,0x1
800082a2:	f0078793          	add	a5,a5,-256 # f00 <.L27+0xc6>
800082a6:	8f7d                	and	a4,a4,a5
800082a8:	4792                	lw	a5,4(sp)
800082aa:	17fd                	add	a5,a5,-1
800082ac:	0ff7f793          	zext.b	a5,a5
800082b0:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
800082b2:	00b14783          	lbu	a5,11(sp)
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
800082b6:	8f55                	or	a4,a4,a3
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
800082b8:	46b2                	lw	a3,12(sp)
800082ba:	60078793          	add	a5,a5,1536
800082be:	078a                	sll	a5,a5,0x2
800082c0:	97b6                	add	a5,a5,a3
800082c2:	c398                	sw	a4,0(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
800082c4:	0001                	nop

800082c6 <.L117>:
800082c6:	00b14783          	lbu	a5,11(sp)
800082ca:	85be                	mv	a1,a5
800082cc:	4532                	lw	a0,12(sp)
800082ce:	3f89                	jal	80008220 <sysctl_clock_target_is_busy>
800082d0:	87aa                	mv	a5,a0
800082d2:	fbf5                	bnez	a5,800082c6 <.L117>
    }

    if ((node == clock_node_cpu0) || (node == clock_node_cpu1)) {
800082d4:	00b14783          	lbu	a5,11(sp)
800082d8:	c791                	beqz	a5,800082e4 <.L118>
800082da:	00b14703          	lbu	a4,11(sp)
800082de:	4789                	li	a5,2
800082e0:	00f71363          	bne	a4,a5,800082e6 <.L119>

800082e4 <.L118>:
        clock_update_core_clock();
800082e4:	3d9d                	jal	8000815a <clock_update_core_clock>

800082e6 <.L119>:
    }
    return status_success;
800082e6:	4781                	li	a5,0

800082e8 <.L115>:
}
800082e8:	853e                	mv	a0,a5
800082ea:	40f2                	lw	ra,28(sp)
800082ec:	6105                	add	sp,sp,32
800082ee:	8082                	ret

Disassembly of section .text.system_init:

800082f0 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
800082f0:	7179                	add	sp,sp,-48
800082f2:	d606                	sw	ra,44(sp)
800082f4:	47a1                	li	a5,8
800082f6:	c83e                	sw	a5,16(sp)

800082f8 <.LBB16>:
 * @param[in] mask interrupt mask to be disabled
 * @retval current mstatus value before irq mask is disabled
 */
ATTR_ALWAYS_INLINE static inline uint32_t disable_global_irq(uint32_t mask)
{
    return read_clear_csr(CSR_MSTATUS, mask);
800082f8:	c602                	sw	zero,12(sp)
800082fa:	47c2                	lw	a5,16(sp)
800082fc:	3007b7f3          	csrrc	a5,mstatus,a5
80008300:	c63e                	sw	a5,12(sp)
80008302:	47b2                	lw	a5,12(sp)

80008304 <.LBE18>:
80008304:	0001                	nop

80008306 <.LBB19>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80008306:	6785                	lui	a5,0x1
80008308:	80078793          	add	a5,a5,-2048 # 800 <.L133+0x14>
8000830c:	3047b073          	csrc	mie,a5
}
80008310:	0001                	nop

80008312 <.LBE19>:
    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();
    enable_plic_feature();
80008312:	0a4040ef          	jal	8000c3b6 <enable_plic_feature>

80008316 <.LBB21>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80008316:	6785                	lui	a5,0x1
80008318:	80078793          	add	a5,a5,-2048 # 800 <.L133+0x14>
8000831c:	3047a073          	csrs	mie,a5
}
80008320:	0001                	nop
80008322:	47a1                	li	a5,8
80008324:	ca3e                	sw	a5,20(sp)

80008326 <.LBB23>:
    set_csr(CSR_MSTATUS, mask);
80008326:	47d2                	lw	a5,20(sp)
80008328:	3007a073          	csrs	mstatus,a5
}
8000832c:	0001                	nop

8000832e <.LBB25>:
#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif

#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
8000832e:	306027f3          	csrr	a5,mcounteren
80008332:	ce3e                	sw	a5,28(sp)
80008334:	47f2                	lw	a5,28(sp)

80008336 <.LBE25>:
80008336:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80008338:	47e2                	lw	a5,24(sp)
8000833a:	0017e793          	or	a5,a5,1
8000833e:	30679073          	csrw	mcounteren,a5
#endif

#if defined(CONFIG_ENABLE_BPOR_RETENTION) && CONFIG_ENABLE_BPOR_RETENTION
    bpor_enable_reg_value_retention(HPM_BPOR);
#endif
}
80008342:	0001                	nop
80008344:	50b2                	lw	ra,44(sp)
80008346:	6145                	add	sp,sp,48
80008348:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

8000834a <__SEGGER_RTL_xltoa>:
8000834a:	882a                	mv	a6,a0
8000834c:	88ae                	mv	a7,a1
8000834e:	852e                	mv	a0,a1
80008350:	ca89                	beqz	a3,80008362 <.L2>
80008352:	02d00793          	li	a5,45
80008356:	00158893          	add	a7,a1,1
8000835a:	00f58023          	sb	a5,0(a1)
8000835e:	41000833          	neg	a6,a6

80008362 <.L2>:
80008362:	8746                	mv	a4,a7
80008364:	4325                	li	t1,9

80008366 <.L5>:
80008366:	02c876b3          	remu	a3,a6,a2
8000836a:	85c2                	mv	a1,a6
8000836c:	0ff6f793          	zext.b	a5,a3
80008370:	02c85833          	divu	a6,a6,a2
80008374:	02d37d63          	bgeu	t1,a3,800083ae <.L3>
80008378:	05778793          	add	a5,a5,87

8000837c <.L11>:
8000837c:	0ff7f793          	zext.b	a5,a5
80008380:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3cf8000>
80008384:	00170693          	add	a3,a4,1
80008388:	02c5f163          	bgeu	a1,a2,800083aa <.L8>
8000838c:	000700a3          	sb	zero,1(a4)

80008390 <.L6>:
80008390:	0008c683          	lbu	a3,0(a7)
80008394:	00074783          	lbu	a5,0(a4)
80008398:	0885                	add	a7,a7,1
8000839a:	177d                	add	a4,a4,-1
8000839c:	00d700a3          	sb	a3,1(a4)
800083a0:	fef88fa3          	sb	a5,-1(a7)
800083a4:	fee8e6e3          	bltu	a7,a4,80008390 <.L6>
800083a8:	8082                	ret

800083aa <.L8>:
800083aa:	8736                	mv	a4,a3
800083ac:	bf6d                	j	80008366 <.L5>

800083ae <.L3>:
800083ae:	03078793          	add	a5,a5,48
800083b2:	b7e9                	j	8000837c <.L11>

Disassembly of section .text.libc.itoa:

800083b4 <itoa>:
800083b4:	46a9                	li	a3,10
800083b6:	87aa                	mv	a5,a0
800083b8:	882e                	mv	a6,a1
800083ba:	8732                	mv	a4,a2
800083bc:	00d61563          	bne	a2,a3,800083c6 <.L301>
800083c0:	4685                	li	a3,1
800083c2:	00054663          	bltz	a0,800083ce <.L302>

800083c6 <.L301>:
800083c6:	4681                	li	a3,0
800083c8:	863a                	mv	a2,a4
800083ca:	85c2                	mv	a1,a6
800083cc:	853e                	mv	a0,a5

800083ce <.L302>:
800083ce:	bfb5                	j	8000834a <__SEGGER_RTL_xltoa>

Disassembly of section .text.libc.fwrite:

800083d0 <fwrite>:
800083d0:	1101                	add	sp,sp,-32
800083d2:	c64e                	sw	s3,12(sp)
800083d4:	89aa                	mv	s3,a0
800083d6:	8536                	mv	a0,a3
800083d8:	cc22                	sw	s0,24(sp)
800083da:	ca26                	sw	s1,20(sp)
800083dc:	c84a                	sw	s2,16(sp)
800083de:	ce06                	sw	ra,28(sp)
800083e0:	84ae                	mv	s1,a1
800083e2:	8432                	mv	s0,a2
800083e4:	8936                	mv	s2,a3
800083e6:	1e4010ef          	jal	800095ca <__SEGGER_RTL_X_file_stat>
800083ea:	02054463          	bltz	a0,80008412 <.L43>
800083ee:	02848633          	mul	a2,s1,s0
800083f2:	4501                	li	a0,0
800083f4:	00966863          	bltu	a2,s1,80008404 <.L41>
800083f8:	85ce                	mv	a1,s3
800083fa:	854a                	mv	a0,s2
800083fc:	14e010ef          	jal	8000954a <__SEGGER_RTL_X_file_write>
80008400:	02955533          	divu	a0,a0,s1

80008404 <.L41>:
80008404:	40f2                	lw	ra,28(sp)
80008406:	4462                	lw	s0,24(sp)
80008408:	44d2                	lw	s1,20(sp)
8000840a:	4942                	lw	s2,16(sp)
8000840c:	49b2                	lw	s3,12(sp)
8000840e:	6105                	add	sp,sp,32
80008410:	8082                	ret

80008412 <.L43>:
80008412:	4501                	li	a0,0
80008414:	bfc5                	j	80008404 <.L41>

Disassembly of section .text.libc.__subsf3:

80008416 <__subsf3>:
80008416:	80000637          	lui	a2,0x80000
8000841a:	8db1                	xor	a1,a1,a2
8000841c:	a009                	j	8000841e <__addsf3>

Disassembly of section .text.libc.__addsf3:

8000841e <__addsf3>:
8000841e:	80000637          	lui	a2,0x80000
80008422:	00b546b3          	xor	a3,a0,a1
80008426:	0806ca63          	bltz	a3,800084ba <.L__addsf3_subtract>
8000842a:	00b57563          	bgeu	a0,a1,80008434 <.L__addsf3_add_already_ordered>
8000842e:	86aa                	mv	a3,a0
80008430:	852e                	mv	a0,a1
80008432:	85b6                	mv	a1,a3

80008434 <.L__addsf3_add_already_ordered>:
80008434:	00151713          	sll	a4,a0,0x1
80008438:	8361                	srl	a4,a4,0x18
8000843a:	00159693          	sll	a3,a1,0x1
8000843e:	82e1                	srl	a3,a3,0x18
80008440:	0ff00293          	li	t0,255
80008444:	06570563          	beq	a4,t0,800084ae <.L__addsf3_add_inf_or_nan>
80008448:	c325                	beqz	a4,800084a8 <.L__addsf3_zero>
8000844a:	ceb1                	beqz	a3,800084a6 <.L__addsf3_add_done>
8000844c:	40d706b3          	sub	a3,a4,a3
80008450:	42e1                	li	t0,24
80008452:	04d2ca63          	blt	t0,a3,800084a6 <.L__addsf3_add_done>
80008456:	05a2                	sll	a1,a1,0x8
80008458:	8dd1                	or	a1,a1,a2
8000845a:	01755713          	srl	a4,a0,0x17
8000845e:	0522                	sll	a0,a0,0x8
80008460:	8d51                	or	a0,a0,a2
80008462:	47e5                	li	a5,25
80008464:	8f95                	sub	a5,a5,a3
80008466:	00f59633          	sll	a2,a1,a5
8000846a:	821d                	srl	a2,a2,0x7
8000846c:	00d5d5b3          	srl	a1,a1,a3
80008470:	00b507b3          	add	a5,a0,a1
80008474:	00a7f463          	bgeu	a5,a0,8000847c <.L__addsf3_add_no_normalization>
80008478:	8385                	srl	a5,a5,0x1
8000847a:	0709                	add	a4,a4,2

8000847c <.L__addsf3_add_no_normalization>:
8000847c:	177d                	add	a4,a4,-1
8000847e:	0ff77593          	zext.b	a1,a4
80008482:	f0158593          	add	a1,a1,-255
80008486:	cd91                	beqz	a1,800084a2 <.L__addsf3_inf>
80008488:	075e                	sll	a4,a4,0x17
8000848a:	0087d513          	srl	a0,a5,0x8
8000848e:	07e2                	sll	a5,a5,0x18
80008490:	8fd1                	or	a5,a5,a2
80008492:	0007d663          	bgez	a5,8000849e <.L__addsf3_no_tie>
80008496:	0786                	sll	a5,a5,0x1
80008498:	0505                	add	a0,a0,1 # f4000001 <__AHB_SRAM_segment_end__+0x3cf8001>
8000849a:	e391                	bnez	a5,8000849e <.L__addsf3_no_tie>
8000849c:	9979                	and	a0,a0,-2

8000849e <.L__addsf3_no_tie>:
8000849e:	953a                	add	a0,a0,a4
800084a0:	8082                	ret

800084a2 <.L__addsf3_inf>:
800084a2:	01771513          	sll	a0,a4,0x17

800084a6 <.L__addsf3_add_done>:
800084a6:	8082                	ret

800084a8 <.L__addsf3_zero>:
800084a8:	817d                	srl	a0,a0,0x1f
800084aa:	057e                	sll	a0,a0,0x1f
800084ac:	8082                	ret

800084ae <.L__addsf3_add_inf_or_nan>:
800084ae:	00951613          	sll	a2,a0,0x9
800084b2:	da75                	beqz	a2,800084a6 <.L__addsf3_add_done>

800084b4 <.L__addsf3_return_nan>:
800084b4:	7fc00537          	lui	a0,0x7fc00
800084b8:	8082                	ret

800084ba <.L__addsf3_subtract>:
800084ba:	8db1                	xor	a1,a1,a2
800084bc:	40b506b3          	sub	a3,a0,a1
800084c0:	00b57563          	bgeu	a0,a1,800084ca <.L__addsf3_sub_already_ordered>
800084c4:	8eb1                	xor	a3,a3,a2
800084c6:	8d15                	sub	a0,a0,a3
800084c8:	95b6                	add	a1,a1,a3

800084ca <.L__addsf3_sub_already_ordered>:
800084ca:	00159693          	sll	a3,a1,0x1
800084ce:	82e1                	srl	a3,a3,0x18
800084d0:	00151713          	sll	a4,a0,0x1
800084d4:	8361                	srl	a4,a4,0x18
800084d6:	05a2                	sll	a1,a1,0x8
800084d8:	8dd1                	or	a1,a1,a2
800084da:	0ff00293          	li	t0,255
800084de:	0c570c63          	beq	a4,t0,800085b6 <.L__addsf3_sub_inf_or_nan>
800084e2:	c2f5                	beqz	a3,800085c6 <.L__addsf3_sub_zero>
800084e4:	40d706b3          	sub	a3,a4,a3
800084e8:	c695                	beqz	a3,80008514 <.L__addsf3_exponents_equal>
800084ea:	4285                	li	t0,1
800084ec:	08569063          	bne	a3,t0,8000856c <.L__addsf3_exponents_differ_by_more_than_1>
800084f0:	01755693          	srl	a3,a0,0x17
800084f4:	0526                	sll	a0,a0,0x9
800084f6:	00b532b3          	sltu	t0,a0,a1
800084fa:	8d0d                	sub	a0,a0,a1
800084fc:	02029263          	bnez	t0,80008520 <.L__addsf3_normalization_steps>
80008500:	06de                	sll	a3,a3,0x17
80008502:	01751593          	sll	a1,a0,0x17
80008506:	8125                	srl	a0,a0,0x9
80008508:	0005d463          	bgez	a1,80008510 <.L__addsf3_sub_no_tie_single>
8000850c:	0505                	add	a0,a0,1 # 7fc00001 <__SHARE_RAM_segment_end__+0x7ea80001>
8000850e:	9979                	and	a0,a0,-2

80008510 <.L__addsf3_sub_no_tie_single>:
80008510:	9536                	add	a0,a0,a3

80008512 <.L__addsf3_sub_done>:
80008512:	8082                	ret

80008514 <.L__addsf3_exponents_equal>:
80008514:	01755693          	srl	a3,a0,0x17
80008518:	0526                	sll	a0,a0,0x9
8000851a:	0586                	sll	a1,a1,0x1
8000851c:	8d0d                	sub	a0,a0,a1
8000851e:	d975                	beqz	a0,80008512 <.L__addsf3_sub_done>

80008520 <.L__addsf3_normalization_steps>:
80008520:	4581                	li	a1,0
80008522:	01055793          	srl	a5,a0,0x10
80008526:	e399                	bnez	a5,8000852c <.L1^B1>
80008528:	0542                	sll	a0,a0,0x10
8000852a:	05c1                	add	a1,a1,16

8000852c <.L1^B1>:
8000852c:	01855793          	srl	a5,a0,0x18
80008530:	e399                	bnez	a5,80008536 <.L2^B1>
80008532:	0522                	sll	a0,a0,0x8
80008534:	05a1                	add	a1,a1,8

80008536 <.L2^B1>:
80008536:	01c55793          	srl	a5,a0,0x1c
8000853a:	e399                	bnez	a5,80008540 <.L3^B1>
8000853c:	0512                	sll	a0,a0,0x4
8000853e:	0591                	add	a1,a1,4

80008540 <.L3^B1>:
80008540:	01e55793          	srl	a5,a0,0x1e
80008544:	e399                	bnez	a5,8000854a <.L4^B1>
80008546:	050a                	sll	a0,a0,0x2
80008548:	0589                	add	a1,a1,2

8000854a <.L4^B1>:
8000854a:	00054463          	bltz	a0,80008552 <.L5^B1>
8000854e:	0506                	sll	a0,a0,0x1
80008550:	0585                	add	a1,a1,1

80008552 <.L5^B1>:
80008552:	0585                	add	a1,a1,1
80008554:	0506                	sll	a0,a0,0x1
80008556:	00e5f763          	bgeu	a1,a4,80008564 <.L__addsf3_underflow>
8000855a:	8e8d                	sub	a3,a3,a1
8000855c:	06de                	sll	a3,a3,0x17
8000855e:	8125                	srl	a0,a0,0x9
80008560:	9536                	add	a0,a0,a3
80008562:	8082                	ret

80008564 <.L__addsf3_underflow>:
80008564:	0086d513          	srl	a0,a3,0x8
80008568:	057e                	sll	a0,a0,0x1f
8000856a:	8082                	ret

8000856c <.L__addsf3_exponents_differ_by_more_than_1>:
8000856c:	42e5                	li	t0,25
8000856e:	fad2e2e3          	bltu	t0,a3,80008512 <.L__addsf3_sub_done>
80008572:	0685                	add	a3,a3,1 # 1001 <__fw_size__+0x1>
80008574:	40d00733          	neg	a4,a3
80008578:	00e59733          	sll	a4,a1,a4
8000857c:	00d5d5b3          	srl	a1,a1,a3
80008580:	00e03733          	snez	a4,a4
80008584:	95ae                	add	a1,a1,a1
80008586:	95ba                	add	a1,a1,a4
80008588:	01755693          	srl	a3,a0,0x17
8000858c:	0522                	sll	a0,a0,0x8
8000858e:	8d51                	or	a0,a0,a2
80008590:	40b50733          	sub	a4,a0,a1
80008594:	00074463          	bltz	a4,8000859c <.L__addsf3_sub_already_normalized>
80008598:	070a                	sll	a4,a4,0x2
8000859a:	8305                	srl	a4,a4,0x1

8000859c <.L__addsf3_sub_already_normalized>:
8000859c:	16fd                	add	a3,a3,-1
8000859e:	06de                	sll	a3,a3,0x17
800085a0:	00875513          	srl	a0,a4,0x8
800085a4:	0762                	sll	a4,a4,0x18
800085a6:	00075663          	bgez	a4,800085b2 <.L__addsf3_sub_no_tie>
800085aa:	0706                	sll	a4,a4,0x1
800085ac:	0505                	add	a0,a0,1
800085ae:	e311                	bnez	a4,800085b2 <.L__addsf3_sub_no_tie>
800085b0:	9979                	and	a0,a0,-2

800085b2 <.L__addsf3_sub_no_tie>:
800085b2:	9536                	add	a0,a0,a3
800085b4:	8082                	ret

800085b6 <.L__addsf3_sub_inf_or_nan>:
800085b6:	0ff00293          	li	t0,255
800085ba:	ee568de3          	beq	a3,t0,800084b4 <.L__addsf3_return_nan>
800085be:	00951593          	sll	a1,a0,0x9
800085c2:	d9a1                	beqz	a1,80008512 <.L__addsf3_sub_done>
800085c4:	bdc5                	j	800084b4 <.L__addsf3_return_nan>

800085c6 <.L__addsf3_sub_zero>:
800085c6:	f731                	bnez	a4,80008512 <.L__addsf3_sub_done>
800085c8:	4501                	li	a0,0
800085ca:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

800085cc <__ltsf2>:
800085cc:	ff000637          	lui	a2,0xff000
800085d0:	00151693          	sll	a3,a0,0x1
800085d4:	02d66763          	bltu	a2,a3,80008602 <.L__ltsf2_zero>
800085d8:	00159693          	sll	a3,a1,0x1
800085dc:	02d66363          	bltu	a2,a3,80008602 <.L__ltsf2_zero>
800085e0:	00b56633          	or	a2,a0,a1
800085e4:	00161693          	sll	a3,a2,0x1
800085e8:	ce89                	beqz	a3,80008602 <.L__ltsf2_zero>
800085ea:	00064763          	bltz	a2,800085f8 <.L__ltsf2_negative>
800085ee:	00b53533          	sltu	a0,a0,a1
800085f2:	40a00533          	neg	a0,a0
800085f6:	8082                	ret

800085f8 <.L__ltsf2_negative>:
800085f8:	00a5b533          	sltu	a0,a1,a0
800085fc:	40a00533          	neg	a0,a0
80008600:	8082                	ret

80008602 <.L__ltsf2_zero>:
80008602:	4501                	li	a0,0
80008604:	8082                	ret

Disassembly of section .text.libc.__lesf2:

80008606 <__lesf2>:
80008606:	ff000637          	lui	a2,0xff000
8000860a:	00151693          	sll	a3,a0,0x1
8000860e:	02d66363          	bltu	a2,a3,80008634 <.L__lesf2_nan>
80008612:	00159693          	sll	a3,a1,0x1
80008616:	00d66f63          	bltu	a2,a3,80008634 <.L__lesf2_nan>
8000861a:	00b56633          	or	a2,a0,a1
8000861e:	00161693          	sll	a3,a2,0x1
80008622:	ca99                	beqz	a3,80008638 <.L__lesf2_zero>
80008624:	00064563          	bltz	a2,8000862e <.L__lesf2_negative>
80008628:	00a5b533          	sltu	a0,a1,a0
8000862c:	8082                	ret

8000862e <.L__lesf2_negative>:
8000862e:	00b53533          	sltu	a0,a0,a1
80008632:	8082                	ret

80008634 <.L__lesf2_nan>:
80008634:	4505                	li	a0,1
80008636:	8082                	ret

80008638 <.L__lesf2_zero>:
80008638:	4501                	li	a0,0
8000863a:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

8000863c <__gtsf2>:
8000863c:	ff000637          	lui	a2,0xff000
80008640:	00151693          	sll	a3,a0,0x1
80008644:	02d66363          	bltu	a2,a3,8000866a <.L__gtsf2_zero>
80008648:	00159693          	sll	a3,a1,0x1
8000864c:	00d66f63          	bltu	a2,a3,8000866a <.L__gtsf2_zero>
80008650:	00b56633          	or	a2,a0,a1
80008654:	00161693          	sll	a3,a2,0x1
80008658:	ca89                	beqz	a3,8000866a <.L__gtsf2_zero>
8000865a:	00064563          	bltz	a2,80008664 <.L__gtsf2_negative>
8000865e:	00a5b533          	sltu	a0,a1,a0
80008662:	8082                	ret

80008664 <.L__gtsf2_negative>:
80008664:	00b53533          	sltu	a0,a0,a1
80008668:	8082                	ret

8000866a <.L__gtsf2_zero>:
8000866a:	4501                	li	a0,0
8000866c:	8082                	ret

Disassembly of section .text.libc.__gesf2:

8000866e <__gesf2>:
8000866e:	ff000637          	lui	a2,0xff000
80008672:	00151693          	sll	a3,a0,0x1
80008676:	02d66763          	bltu	a2,a3,800086a4 <.L__gesf2_nan>
8000867a:	00159693          	sll	a3,a1,0x1
8000867e:	02d66363          	bltu	a2,a3,800086a4 <.L__gesf2_nan>
80008682:	00b56633          	or	a2,a0,a1
80008686:	00161693          	sll	a3,a2,0x1
8000868a:	ce99                	beqz	a3,800086a8 <.L__gesf2_zero>
8000868c:	00064763          	bltz	a2,8000869a <.L__gesf2_negative>
80008690:	00b53533          	sltu	a0,a0,a1
80008694:	40a00533          	neg	a0,a0
80008698:	8082                	ret

8000869a <.L__gesf2_negative>:
8000869a:	00a5b533          	sltu	a0,a1,a0
8000869e:	40a00533          	neg	a0,a0
800086a2:	8082                	ret

800086a4 <.L__gesf2_nan>:
800086a4:	557d                	li	a0,-1
800086a6:	8082                	ret

800086a8 <.L__gesf2_zero>:
800086a8:	4501                	li	a0,0
800086aa:	8082                	ret

Disassembly of section .text.libc.__fixunssfsi:

800086ac <__fixunssfsi>:
800086ac:	02a05763          	blez	a0,800086da <.L__fixunssfsi_zero_result>
800086b0:	00151593          	sll	a1,a0,0x1
800086b4:	81e1                	srl	a1,a1,0x18
800086b6:	f8158593          	add	a1,a1,-127
800086ba:	0205c063          	bltz	a1,800086da <.L__fixunssfsi_zero_result>
800086be:	40b005b3          	neg	a1,a1
800086c2:	05fd                	add	a1,a1,31
800086c4:	0005c963          	bltz	a1,800086d6 <.L__fixunssfsi_max_result>
800086c8:	0522                	sll	a0,a0,0x8
800086ca:	800006b7          	lui	a3,0x80000
800086ce:	8d55                	or	a0,a0,a3
800086d0:	00b55533          	srl	a0,a0,a1
800086d4:	8082                	ret

800086d6 <.L__fixunssfsi_max_result>:
800086d6:	557d                	li	a0,-1
800086d8:	8082                	ret

800086da <.L__fixunssfsi_zero_result>:
800086da:	4501                	li	a0,0
800086dc:	8082                	ret

Disassembly of section .text.libc.__fixunsdfsi:

800086de <__fixunsdfsi>:
800086de:	0205c563          	bltz	a1,80008708 <.L__fixunsdfsi_zero_result>
800086e2:	0145d613          	srl	a2,a1,0x14
800086e6:	c0160613          	add	a2,a2,-1023 # fefffc01 <__APB_SRAM_segment_end__+0xaf0dc01>
800086ea:	00064f63          	bltz	a2,80008708 <.L__fixunsdfsi_zero_result>
800086ee:	477d                	li	a4,31
800086f0:	8f11                	sub	a4,a4,a2
800086f2:	00074d63          	bltz	a4,8000870c <.L__fixunsdfsi_overflow_result>
800086f6:	8155                	srl	a0,a0,0x15
800086f8:	05ae                	sll	a1,a1,0xb
800086fa:	8d4d                	or	a0,a0,a1
800086fc:	800006b7          	lui	a3,0x80000
80008700:	8d55                	or	a0,a0,a3
80008702:	00e55533          	srl	a0,a0,a4
80008706:	8082                	ret

80008708 <.L__fixunsdfsi_zero_result>:
80008708:	4501                	li	a0,0
8000870a:	8082                	ret

8000870c <.L__fixunsdfsi_overflow_result>:
8000870c:	557d                	li	a0,-1
8000870e:	8082                	ret

Disassembly of section .text.libc.__floatsisf:

80008710 <__floatsisf>:
80008710:	01f55613          	srl	a2,a0,0x1f
80008714:	0622                	sll	a2,a2,0x8
80008716:	09d60613          	add	a2,a2,157
8000871a:	cd29                	beqz	a0,80008774 <.L__floatsisf_done>
8000871c:	41f55693          	sra	a3,a0,0x1f
80008720:	00d545b3          	xor	a1,a0,a3
80008724:	8d95                	sub	a1,a1,a3
80008726:	0105d693          	srl	a3,a1,0x10
8000872a:	e299                	bnez	a3,80008730 <.L1^B2>
8000872c:	05c2                	sll	a1,a1,0x10
8000872e:	1641                	add	a2,a2,-16

80008730 <.L1^B2>:
80008730:	0185d693          	srl	a3,a1,0x18
80008734:	e299                	bnez	a3,8000873a <.L2^B2>
80008736:	05a2                	sll	a1,a1,0x8
80008738:	1661                	add	a2,a2,-8

8000873a <.L2^B2>:
8000873a:	01c5d693          	srl	a3,a1,0x1c
8000873e:	e299                	bnez	a3,80008744 <.L3^B2>
80008740:	0592                	sll	a1,a1,0x4
80008742:	1671                	add	a2,a2,-4

80008744 <.L3^B2>:
80008744:	01e5d693          	srl	a3,a1,0x1e
80008748:	e299                	bnez	a3,8000874e <.L4^B2>
8000874a:	058a                	sll	a1,a1,0x2
8000874c:	1679                	add	a2,a2,-2

8000874e <.L4^B2>:
8000874e:	0005c463          	bltz	a1,80008756 <.L5^B2>
80008752:	0586                	sll	a1,a1,0x1
80008754:	167d                	add	a2,a2,-1

80008756 <.L5^B2>:
80008756:	065e                	sll	a2,a2,0x17
80008758:	0085d513          	srl	a0,a1,0x8
8000875c:	05de                	sll	a1,a1,0x17
8000875e:	0005a333          	sltz	t1,a1
80008762:	95ae                	add	a1,a1,a1
80008764:	959a                	add	a1,a1,t1
80008766:	0005d663          	bgez	a1,80008772 <.L__floatsisf_round_down>
8000876a:	95ae                	add	a1,a1,a1
8000876c:	00b035b3          	snez	a1,a1
80008770:	952e                	add	a0,a0,a1

80008772 <.L__floatsisf_round_down>:
80008772:	9532                	add	a0,a0,a2

80008774 <.L__floatsisf_done>:
80008774:	8082                	ret

Disassembly of section .text.libc.__floatunsisf:

80008776 <__floatunsisf>:
80008776:	c931                	beqz	a0,800087ca <.L__floatunsisf_done>
80008778:	09d00613          	li	a2,157
8000877c:	01055693          	srl	a3,a0,0x10
80008780:	e299                	bnez	a3,80008786 <.L1^B8>
80008782:	0542                	sll	a0,a0,0x10
80008784:	1641                	add	a2,a2,-16

80008786 <.L1^B8>:
80008786:	01855693          	srl	a3,a0,0x18
8000878a:	e299                	bnez	a3,80008790 <.L2^B8>
8000878c:	0522                	sll	a0,a0,0x8
8000878e:	1661                	add	a2,a2,-8

80008790 <.L2^B8>:
80008790:	01c55693          	srl	a3,a0,0x1c
80008794:	e299                	bnez	a3,8000879a <.L3^B6>
80008796:	0512                	sll	a0,a0,0x4
80008798:	1671                	add	a2,a2,-4

8000879a <.L3^B6>:
8000879a:	01e55693          	srl	a3,a0,0x1e
8000879e:	e299                	bnez	a3,800087a4 <.L4^B8>
800087a0:	050a                	sll	a0,a0,0x2
800087a2:	1679                	add	a2,a2,-2

800087a4 <.L4^B8>:
800087a4:	00054463          	bltz	a0,800087ac <.L5^B6>
800087a8:	0506                	sll	a0,a0,0x1
800087aa:	167d                	add	a2,a2,-1

800087ac <.L5^B6>:
800087ac:	065e                	sll	a2,a2,0x17
800087ae:	01751593          	sll	a1,a0,0x17
800087b2:	8121                	srl	a0,a0,0x8
800087b4:	0005a333          	sltz	t1,a1
800087b8:	95ae                	add	a1,a1,a1
800087ba:	959a                	add	a1,a1,t1
800087bc:	0005d663          	bgez	a1,800087c8 <.L__floatunsisf_round_down>
800087c0:	95ae                	add	a1,a1,a1
800087c2:	00b035b3          	snez	a1,a1
800087c6:	952e                	add	a0,a0,a1

800087c8 <.L__floatunsisf_round_down>:
800087c8:	9532                	add	a0,a0,a2

800087ca <.L__floatunsisf_done>:
800087ca:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

800087cc <__floatundisf>:
800087cc:	c5bd                	beqz	a1,8000883a <.L__floatundisf_high_word_zero>
800087ce:	4701                	li	a4,0
800087d0:	0105d693          	srl	a3,a1,0x10
800087d4:	e299                	bnez	a3,800087da <.L8^B3>
800087d6:	0741                	add	a4,a4,16
800087d8:	05c2                	sll	a1,a1,0x10

800087da <.L8^B3>:
800087da:	0185d693          	srl	a3,a1,0x18
800087de:	e299                	bnez	a3,800087e4 <.L4^B10>
800087e0:	0721                	add	a4,a4,8
800087e2:	05a2                	sll	a1,a1,0x8

800087e4 <.L4^B10>:
800087e4:	01c5d693          	srl	a3,a1,0x1c
800087e8:	e299                	bnez	a3,800087ee <.L2^B10>
800087ea:	0711                	add	a4,a4,4
800087ec:	0592                	sll	a1,a1,0x4

800087ee <.L2^B10>:
800087ee:	01e5d693          	srl	a3,a1,0x1e
800087f2:	e299                	bnez	a3,800087f8 <.L1^B10>
800087f4:	0709                	add	a4,a4,2
800087f6:	058a                	sll	a1,a1,0x2

800087f8 <.L1^B10>:
800087f8:	0005c463          	bltz	a1,80008800 <.L0^B3>
800087fc:	0705                	add	a4,a4,1
800087fe:	0586                	sll	a1,a1,0x1

80008800 <.L0^B3>:
80008800:	fff74613          	not	a2,a4
80008804:	00c556b3          	srl	a3,a0,a2
80008808:	8285                	srl	a3,a3,0x1
8000880a:	8dd5                	or	a1,a1,a3
8000880c:	00e51533          	sll	a0,a0,a4
80008810:	0be60613          	add	a2,a2,190
80008814:	00a03533          	snez	a0,a0
80008818:	8dc9                	or	a1,a1,a0

8000881a <.L__floatundisf_round_and_pack>:
8000881a:	065e                	sll	a2,a2,0x17
8000881c:	0085d513          	srl	a0,a1,0x8
80008820:	05de                	sll	a1,a1,0x17
80008822:	0005a333          	sltz	t1,a1
80008826:	95ae                	add	a1,a1,a1
80008828:	959a                	add	a1,a1,t1
8000882a:	0005d663          	bgez	a1,80008836 <.L__floatundisf_round_down>
8000882e:	95ae                	add	a1,a1,a1
80008830:	00b035b3          	snez	a1,a1
80008834:	952e                	add	a0,a0,a1

80008836 <.L__floatundisf_round_down>:
80008836:	9532                	add	a0,a0,a2

80008838 <.L__floatundisf_done>:
80008838:	8082                	ret

8000883a <.L__floatundisf_high_word_zero>:
8000883a:	dd7d                	beqz	a0,80008838 <.L__floatundisf_done>
8000883c:	09d00613          	li	a2,157
80008840:	01055693          	srl	a3,a0,0x10
80008844:	e299                	bnez	a3,8000884a <.L1^B11>
80008846:	0542                	sll	a0,a0,0x10
80008848:	1641                	add	a2,a2,-16

8000884a <.L1^B11>:
8000884a:	01855693          	srl	a3,a0,0x18
8000884e:	e299                	bnez	a3,80008854 <.L2^B11>
80008850:	0522                	sll	a0,a0,0x8
80008852:	1661                	add	a2,a2,-8

80008854 <.L2^B11>:
80008854:	01c55693          	srl	a3,a0,0x1c
80008858:	e299                	bnez	a3,8000885e <.L3^B8>
8000885a:	0512                	sll	a0,a0,0x4
8000885c:	1671                	add	a2,a2,-4

8000885e <.L3^B8>:
8000885e:	01e55693          	srl	a3,a0,0x1e
80008862:	e299                	bnez	a3,80008868 <.L4^B11>
80008864:	050a                	sll	a0,a0,0x2
80008866:	1679                	add	a2,a2,-2

80008868 <.L4^B11>:
80008868:	00054463          	bltz	a0,80008870 <.L5^B8>
8000886c:	0506                	sll	a0,a0,0x1
8000886e:	167d                	add	a2,a2,-1

80008870 <.L5^B8>:
80008870:	85aa                	mv	a1,a0
80008872:	4501                	li	a0,0
80008874:	b75d                	j	8000881a <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

80008876 <__truncdfsf2>:
80008876:	00159693          	sll	a3,a1,0x1
8000887a:	82d5                	srl	a3,a3,0x15
8000887c:	7ff00613          	li	a2,2047
80008880:	04c68663          	beq	a3,a2,800088cc <.L__truncdfsf2_inf_nan>
80008884:	c8068693          	add	a3,a3,-896 # 7ffffc80 <__SHARE_RAM_segment_end__+0x7ee7fc80>
80008888:	02d05e63          	blez	a3,800088c4 <.L__truncdfsf2_underflow>
8000888c:	0ff00613          	li	a2,255
80008890:	04c6f263          	bgeu	a3,a2,800088d4 <.L__truncdfsf2_inf>
80008894:	06de                	sll	a3,a3,0x17
80008896:	01f5d613          	srl	a2,a1,0x1f
8000889a:	067e                	sll	a2,a2,0x1f
8000889c:	8ed1                	or	a3,a3,a2
8000889e:	05b2                	sll	a1,a1,0xc
800088a0:	01455613          	srl	a2,a0,0x14
800088a4:	8dd1                	or	a1,a1,a2
800088a6:	81a5                	srl	a1,a1,0x9
800088a8:	00251613          	sll	a2,a0,0x2
800088ac:	00062733          	sltz	a4,a2
800088b0:	9632                	add	a2,a2,a2
800088b2:	000627b3          	sltz	a5,a2
800088b6:	9632                	add	a2,a2,a2
800088b8:	963a                	add	a2,a2,a4
800088ba:	c211                	beqz	a2,800088be <.L__truncdfsf2_no_round_tie>
800088bc:	95be                	add	a1,a1,a5

800088be <.L__truncdfsf2_no_round_tie>:
800088be:	00d58533          	add	a0,a1,a3
800088c2:	8082                	ret

800088c4 <.L__truncdfsf2_underflow>:
800088c4:	01f5d513          	srl	a0,a1,0x1f
800088c8:	057e                	sll	a0,a0,0x1f
800088ca:	8082                	ret

800088cc <.L__truncdfsf2_inf_nan>:
800088cc:	00c59693          	sll	a3,a1,0xc
800088d0:	8ec9                	or	a3,a3,a0
800088d2:	ea81                	bnez	a3,800088e2 <.L__truncdfsf2_nan>

800088d4 <.L__truncdfsf2_inf>:
800088d4:	81fd                	srl	a1,a1,0x1f
800088d6:	05fe                	sll	a1,a1,0x1f
800088d8:	7f800537          	lui	a0,0x7f800
800088dc:	8d4d                	or	a0,a0,a1
800088de:	4581                	li	a1,0
800088e0:	8082                	ret

800088e2 <.L__truncdfsf2_nan>:
800088e2:	800006b7          	lui	a3,0x80000
800088e6:	00d5f633          	and	a2,a1,a3
800088ea:	058e                	sll	a1,a1,0x3
800088ec:	8175                	srl	a0,a0,0x1d
800088ee:	8d4d                	or	a0,a0,a1
800088f0:	0506                	sll	a0,a0,0x1
800088f2:	8105                	srl	a0,a0,0x1
800088f4:	8d51                	or	a0,a0,a2
800088f6:	82a5                	srl	a3,a3,0x9
800088f8:	8d55                	or	a0,a0,a3
800088fa:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

800088fc <__SEGGER_RTL_ldouble_to_double>:
800088fc:	4158                	lw	a4,4(a0)
800088fe:	451c                	lw	a5,8(a0)
80008900:	4554                	lw	a3,12(a0)
80008902:	1141                	add	sp,sp,-16
80008904:	c23a                	sw	a4,4(sp)
80008906:	c43e                	sw	a5,8(sp)
80008908:	7771                	lui	a4,0xffffc
8000890a:	00169793          	sll	a5,a3,0x1
8000890e:	83c5                	srl	a5,a5,0x11
80008910:	40070713          	add	a4,a4,1024 # ffffc400 <__APB_SRAM_segment_end__+0xbf0a400>
80008914:	c636                	sw	a3,12(sp)
80008916:	97ba                	add	a5,a5,a4
80008918:	00f04a63          	bgtz	a5,8000892c <.L27>
8000891c:	800007b7          	lui	a5,0x80000
80008920:	4701                	li	a4,0
80008922:	8ff5                	and	a5,a5,a3

80008924 <.L28>:
80008924:	853a                	mv	a0,a4
80008926:	85be                	mv	a1,a5
80008928:	0141                	add	sp,sp,16
8000892a:	8082                	ret

8000892c <.L27>:
8000892c:	6711                	lui	a4,0x4
8000892e:	3ff70713          	add	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
80008932:	00e78c63          	beq	a5,a4,8000894a <.L29>
80008936:	7ff00713          	li	a4,2047
8000893a:	00f75a63          	bge	a4,a5,8000894e <.L30>
8000893e:	4781                	li	a5,0
80008940:	4801                	li	a6,0
80008942:	c43e                	sw	a5,8(sp)
80008944:	c642                	sw	a6,12(sp)
80008946:	c03e                	sw	a5,0(sp)
80008948:	c242                	sw	a6,4(sp)

8000894a <.L29>:
8000894a:	7ff00793          	li	a5,2047

8000894e <.L30>:
8000894e:	45a2                	lw	a1,8(sp)
80008950:	4732                	lw	a4,12(sp)
80008952:	80000637          	lui	a2,0x80000
80008956:	01c5d513          	srl	a0,a1,0x1c
8000895a:	8e79                	and	a2,a2,a4
8000895c:	0712                	sll	a4,a4,0x4
8000895e:	4692                	lw	a3,4(sp)
80008960:	8f49                	or	a4,a4,a0
80008962:	0732                	sll	a4,a4,0xc
80008964:	8331                	srl	a4,a4,0xc
80008966:	8e59                	or	a2,a2,a4
80008968:	82f1                	srl	a3,a3,0x1c
8000896a:	0592                	sll	a1,a1,0x4
8000896c:	07d2                	sll	a5,a5,0x14
8000896e:	00b6e733          	or	a4,a3,a1
80008972:	8fd1                	or	a5,a5,a2
80008974:	bf45                	j	80008924 <.L28>

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

80008976 <__SEGGER_RTL_float32_isnan>:
80008976:	ff0007b7          	lui	a5,0xff000
8000897a:	0785                	add	a5,a5,1 # ff000001 <__APB_SRAM_segment_end__+0xaf0e001>
8000897c:	0506                	sll	a0,a0,0x1
8000897e:	00f53533          	sltu	a0,a0,a5
80008982:	00154513          	xor	a0,a0,1
80008986:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

80008988 <__SEGGER_RTL_float32_isinf>:
80008988:	010007b7          	lui	a5,0x1000
8000898c:	0506                	sll	a0,a0,0x1
8000898e:	953e                	add	a0,a0,a5
80008990:	00153513          	seqz	a0,a0
80008994:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

80008996 <__SEGGER_RTL_float32_isnormal>:
80008996:	ff0007b7          	lui	a5,0xff000
8000899a:	0506                	sll	a0,a0,0x1
8000899c:	953e                	add	a0,a0,a5
8000899e:	fe0007b7          	lui	a5,0xfe000
800089a2:	00f53533          	sltu	a0,a0,a5
800089a6:	8082                	ret

Disassembly of section .text.libc.floorf:

800089a8 <floorf>:
800089a8:	00151693          	sll	a3,a0,0x1
800089ac:	82e1                	srl	a3,a3,0x18
800089ae:	01755793          	srl	a5,a0,0x17
800089b2:	16fd                	add	a3,a3,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
800089b4:	0fd00613          	li	a2,253
800089b8:	872a                	mv	a4,a0
800089ba:	0ff7f793          	zext.b	a5,a5
800089be:	00d67963          	bgeu	a2,a3,800089d0 <.L1240>
800089c2:	e789                	bnez	a5,800089cc <.L1241>
800089c4:	800007b7          	lui	a5,0x80000
800089c8:	00f57733          	and	a4,a0,a5

800089cc <.L1241>:
800089cc:	853a                	mv	a0,a4
800089ce:	8082                	ret

800089d0 <.L1240>:
800089d0:	f8178793          	add	a5,a5,-127 # 7fffff81 <__SHARE_RAM_segment_end__+0x7ee7ff81>
800089d4:	0007d963          	bgez	a5,800089e6 <.L1243>
800089d8:	00000513          	li	a0,0
800089dc:	02075863          	bgez	a4,80008a0c <.L1242>
800089e0:	9fc22503          	lw	a0,-1540(tp) # fffff9fc <__APB_SRAM_segment_end__+0xbf0d9fc>
800089e4:	8082                	ret

800089e6 <.L1243>:
800089e6:	46d9                	li	a3,22
800089e8:	02f6c263          	blt	a3,a5,80008a0c <.L1242>
800089ec:	008006b7          	lui	a3,0x800
800089f0:	fff68613          	add	a2,a3,-1 # 7fffff <__XPI0_segment_size__+0x2fff>
800089f4:	00f65633          	srl	a2,a2,a5
800089f8:	fff64513          	not	a0,a2
800089fc:	8d79                	and	a0,a0,a4
800089fe:	8f71                	and	a4,a4,a2
80008a00:	c711                	beqz	a4,80008a0c <.L1242>
80008a02:	00055563          	bgez	a0,80008a0c <.L1242>
80008a06:	00f6d6b3          	srl	a3,a3,a5
80008a0a:	9536                	add	a0,a0,a3

80008a0c <.L1242>:
80008a0c:	8082                	ret

Disassembly of section .text.libc.__ashldi3:

80008a0e <__ashldi3>:
80008a0e:	02067793          	and	a5,a2,32
80008a12:	ef89                	bnez	a5,80008a2c <.L__ashldi3LongShift>
80008a14:	00155793          	srl	a5,a0,0x1
80008a18:	fff64713          	not	a4,a2
80008a1c:	00e7d7b3          	srl	a5,a5,a4
80008a20:	00c595b3          	sll	a1,a1,a2
80008a24:	8ddd                	or	a1,a1,a5
80008a26:	00c51533          	sll	a0,a0,a2
80008a2a:	8082                	ret

80008a2c <.L__ashldi3LongShift>:
80008a2c:	00c515b3          	sll	a1,a0,a2
80008a30:	4501                	li	a0,0
80008a32:	8082                	ret

Disassembly of section .text.libc.__udivdi3:

80008a34 <__udivdi3>:
80008a34:	1101                	add	sp,sp,-32
80008a36:	cc22                	sw	s0,24(sp)
80008a38:	ca26                	sw	s1,20(sp)
80008a3a:	c84a                	sw	s2,16(sp)
80008a3c:	c64e                	sw	s3,12(sp)
80008a3e:	ce06                	sw	ra,28(sp)
80008a40:	c452                	sw	s4,8(sp)
80008a42:	c256                	sw	s5,4(sp)
80008a44:	c05a                	sw	s6,0(sp)
80008a46:	842a                	mv	s0,a0
80008a48:	892e                	mv	s2,a1
80008a4a:	89b2                	mv	s3,a2
80008a4c:	84b6                	mv	s1,a3
80008a4e:	2e069263          	bnez	a3,80008d32 <.L47>
80008a52:	ed99                	bnez	a1,80008a70 <.L48>
80008a54:	02c55433          	divu	s0,a0,a2

80008a58 <.L49>:
80008a58:	40f2                	lw	ra,28(sp)
80008a5a:	8522                	mv	a0,s0
80008a5c:	4462                	lw	s0,24(sp)
80008a5e:	44d2                	lw	s1,20(sp)
80008a60:	49b2                	lw	s3,12(sp)
80008a62:	4a22                	lw	s4,8(sp)
80008a64:	4a92                	lw	s5,4(sp)
80008a66:	4b02                	lw	s6,0(sp)
80008a68:	85ca                	mv	a1,s2
80008a6a:	4942                	lw	s2,16(sp)
80008a6c:	6105                	add	sp,sp,32
80008a6e:	8082                	ret

80008a70 <.L48>:
80008a70:	010007b7          	lui	a5,0x1000
80008a74:	12f67863          	bgeu	a2,a5,80008ba4 <.L50>
80008a78:	4791                	li	a5,4
80008a7a:	08c7e763          	bltu	a5,a2,80008b08 <.L52>
80008a7e:	470d                	li	a4,3
80008a80:	02e60263          	beq	a2,a4,80008aa4 <.L54>
80008a84:	06f60a63          	beq	a2,a5,80008af8 <.L55>
80008a88:	4785                	li	a5,1
80008a8a:	fcf607e3          	beq	a2,a5,80008a58 <.L49>
80008a8e:	4789                	li	a5,2
80008a90:	3cf61063          	bne	a2,a5,80008e50 <.L88>
80008a94:	01f59793          	sll	a5,a1,0x1f
80008a98:	00155413          	srl	s0,a0,0x1
80008a9c:	8c5d                	or	s0,s0,a5
80008a9e:	0015d913          	srl	s2,a1,0x1
80008aa2:	bf5d                	j	80008a58 <.L49>

80008aa4 <.L54>:
80008aa4:	555557b7          	lui	a5,0x55555
80008aa8:	55578793          	add	a5,a5,1365 # 55555555 <__SHARE_RAM_segment_end__+0x543d5555>
80008aac:	02b7b6b3          	mulhu	a3,a5,a1
80008ab0:	02a7b633          	mulhu	a2,a5,a0
80008ab4:	02a78733          	mul	a4,a5,a0
80008ab8:	02b787b3          	mul	a5,a5,a1
80008abc:	97b2                	add	a5,a5,a2
80008abe:	00c7b633          	sltu	a2,a5,a2
80008ac2:	9636                	add	a2,a2,a3
80008ac4:	00f706b3          	add	a3,a4,a5
80008ac8:	00e6b733          	sltu	a4,a3,a4
80008acc:	9732                	add	a4,a4,a2
80008ace:	97ba                	add	a5,a5,a4
80008ad0:	00e7b5b3          	sltu	a1,a5,a4
80008ad4:	9736                	add	a4,a4,a3
80008ad6:	00d736b3          	sltu	a3,a4,a3
80008ada:	0705                	add	a4,a4,1
80008adc:	97b6                	add	a5,a5,a3
80008ade:	00173713          	seqz	a4,a4
80008ae2:	00d7b6b3          	sltu	a3,a5,a3
80008ae6:	962e                	add	a2,a2,a1
80008ae8:	97ba                	add	a5,a5,a4
80008aea:	00c68933          	add	s2,a3,a2
80008aee:	00e7b733          	sltu	a4,a5,a4
80008af2:	843e                	mv	s0,a5
80008af4:	993a                	add	s2,s2,a4
80008af6:	b78d                	j	80008a58 <.L49>

80008af8 <.L55>:
80008af8:	01e59793          	sll	a5,a1,0x1e
80008afc:	00255413          	srl	s0,a0,0x2
80008b00:	8c5d                	or	s0,s0,a5
80008b02:	0025d913          	srl	s2,a1,0x2
80008b06:	bf89                	j	80008a58 <.L49>

80008b08 <.L52>:
80008b08:	67c1                	lui	a5,0x10
80008b0a:	02c5d6b3          	divu	a3,a1,a2
80008b0e:	01055713          	srl	a4,a0,0x10
80008b12:	02f67a63          	bgeu	a2,a5,80008b46 <.L62>
80008b16:	01051413          	sll	s0,a0,0x10
80008b1a:	8041                	srl	s0,s0,0x10
80008b1c:	02c687b3          	mul	a5,a3,a2
80008b20:	40f587b3          	sub	a5,a1,a5
80008b24:	07c2                	sll	a5,a5,0x10
80008b26:	97ba                	add	a5,a5,a4
80008b28:	02c7d933          	divu	s2,a5,a2
80008b2c:	02c90733          	mul	a4,s2,a2
80008b30:	0942                	sll	s2,s2,0x10
80008b32:	8f99                	sub	a5,a5,a4
80008b34:	07c2                	sll	a5,a5,0x10
80008b36:	943e                	add	s0,s0,a5
80008b38:	02c45433          	divu	s0,s0,a2
80008b3c:	944a                	add	s0,s0,s2
80008b3e:	01243933          	sltu	s2,s0,s2
80008b42:	9936                	add	s2,s2,a3
80008b44:	bf11                	j	80008a58 <.L49>

80008b46 <.L62>:
80008b46:	02c687b3          	mul	a5,a3,a2
80008b4a:	01855613          	srl	a2,a0,0x18
80008b4e:	0ff77713          	zext.b	a4,a4
80008b52:	0ff47413          	zext.b	s0,s0
80008b56:	8936                	mv	s2,a3
80008b58:	40f587b3          	sub	a5,a1,a5
80008b5c:	07a2                	sll	a5,a5,0x8
80008b5e:	963e                	add	a2,a2,a5
80008b60:	033657b3          	divu	a5,a2,s3
80008b64:	033785b3          	mul	a1,a5,s3
80008b68:	07a2                	sll	a5,a5,0x8
80008b6a:	8e0d                	sub	a2,a2,a1
80008b6c:	0622                	sll	a2,a2,0x8
80008b6e:	9732                	add	a4,a4,a2
80008b70:	033755b3          	divu	a1,a4,s3
80008b74:	97ae                	add	a5,a5,a1
80008b76:	07a2                	sll	a5,a5,0x8
80008b78:	03358633          	mul	a2,a1,s3
80008b7c:	8f11                	sub	a4,a4,a2
80008b7e:	00855613          	srl	a2,a0,0x8
80008b82:	0ff67613          	zext.b	a2,a2
80008b86:	0722                	sll	a4,a4,0x8
80008b88:	9732                	add	a4,a4,a2
80008b8a:	03375633          	divu	a2,a4,s3
80008b8e:	97b2                	add	a5,a5,a2
80008b90:	07a2                	sll	a5,a5,0x8
80008b92:	03360533          	mul	a0,a2,s3
80008b96:	8f09                	sub	a4,a4,a0
80008b98:	0722                	sll	a4,a4,0x8
80008b9a:	943a                	add	s0,s0,a4
80008b9c:	03345433          	divu	s0,s0,s3
80008ba0:	943e                	add	s0,s0,a5
80008ba2:	bd5d                	j	80008a58 <.L49>

80008ba4 <.L50>:
80008ba4:	80003ab7          	lui	s5,0x80003
80008ba8:	5b0a8a93          	add	s5,s5,1456 # 800035b0 <__SEGGER_RTL_Moeller_inverse_lut>
80008bac:	0cc5f063          	bgeu	a1,a2,80008c6c <.L64>
80008bb0:	10000737          	lui	a4,0x10000
80008bb4:	87b2                	mv	a5,a2
80008bb6:	00e67563          	bgeu	a2,a4,80008bc0 <.L65>
80008bba:	00461793          	sll	a5,a2,0x4
80008bbe:	4491                	li	s1,4

80008bc0 <.L65>:
80008bc0:	40000737          	lui	a4,0x40000
80008bc4:	00e7f463          	bgeu	a5,a4,80008bcc <.L66>
80008bc8:	0489                	add	s1,s1,2
80008bca:	078a                	sll	a5,a5,0x2

80008bcc <.L66>:
80008bcc:	0007c363          	bltz	a5,80008bd2 <.L67>
80008bd0:	0485                	add	s1,s1,1

80008bd2 <.L67>:
80008bd2:	8626                	mv	a2,s1
80008bd4:	8522                	mv	a0,s0
80008bd6:	85ca                	mv	a1,s2
80008bd8:	3d1d                	jal	80008a0e <__ashldi3>
80008bda:	009994b3          	sll	s1,s3,s1
80008bde:	0164d793          	srl	a5,s1,0x16
80008be2:	e0078793          	add	a5,a5,-512 # fe00 <__XPI0_segment_used_size__+0x31c8>
80008be6:	0786                	sll	a5,a5,0x1
80008be8:	97d6                	add	a5,a5,s5
80008bea:	0007d783          	lhu	a5,0(a5)
80008bee:	00b4d813          	srl	a6,s1,0xb
80008bf2:	0014f713          	and	a4,s1,1
80008bf6:	02f78633          	mul	a2,a5,a5
80008bfa:	0792                	sll	a5,a5,0x4
80008bfc:	0014d693          	srl	a3,s1,0x1
80008c00:	0805                	add	a6,a6,1
80008c02:	03063633          	mulhu	a2,a2,a6
80008c06:	8f91                	sub	a5,a5,a2
80008c08:	96ba                	add	a3,a3,a4
80008c0a:	17fd                	add	a5,a5,-1
80008c0c:	c319                	beqz	a4,80008c12 <.L68>
80008c0e:	0017d713          	srl	a4,a5,0x1

80008c12 <.L68>:
80008c12:	02f686b3          	mul	a3,a3,a5
80008c16:	8f15                	sub	a4,a4,a3
80008c18:	02e7b733          	mulhu	a4,a5,a4
80008c1c:	07be                	sll	a5,a5,0xf
80008c1e:	8305                	srl	a4,a4,0x1
80008c20:	97ba                	add	a5,a5,a4
80008c22:	8726                	mv	a4,s1
80008c24:	029786b3          	mul	a3,a5,s1
80008c28:	9736                	add	a4,a4,a3
80008c2a:	00d736b3          	sltu	a3,a4,a3
80008c2e:	8726                	mv	a4,s1
80008c30:	9736                	add	a4,a4,a3
80008c32:	0297b6b3          	mulhu	a3,a5,s1
80008c36:	9736                	add	a4,a4,a3
80008c38:	8f99                	sub	a5,a5,a4
80008c3a:	02b7b733          	mulhu	a4,a5,a1
80008c3e:	02b787b3          	mul	a5,a5,a1
80008c42:	00a786b3          	add	a3,a5,a0
80008c46:	00f6b7b3          	sltu	a5,a3,a5
80008c4a:	95be                	add	a1,a1,a5
80008c4c:	00b707b3          	add	a5,a4,a1
80008c50:	00178413          	add	s0,a5,1
80008c54:	02848733          	mul	a4,s1,s0
80008c58:	8d19                	sub	a0,a0,a4
80008c5a:	00a6f463          	bgeu	a3,a0,80008c62 <.L69>
80008c5e:	9526                	add	a0,a0,s1
80008c60:	843e                	mv	s0,a5

80008c62 <.L69>:
80008c62:	00956363          	bltu	a0,s1,80008c68 <.L109>
80008c66:	0405                	add	s0,s0,1

80008c68 <.L109>:
80008c68:	4901                	li	s2,0
80008c6a:	b3fd                	j	80008a58 <.L49>

80008c6c <.L64>:
80008c6c:	02c5da33          	divu	s4,a1,a2
80008c70:	10000737          	lui	a4,0x10000
80008c74:	87b2                	mv	a5,a2
80008c76:	02ca05b3          	mul	a1,s4,a2
80008c7a:	40b905b3          	sub	a1,s2,a1
80008c7e:	00e67563          	bgeu	a2,a4,80008c88 <.L71>
80008c82:	00461793          	sll	a5,a2,0x4
80008c86:	4491                	li	s1,4

80008c88 <.L71>:
80008c88:	40000737          	lui	a4,0x40000
80008c8c:	00e7f463          	bgeu	a5,a4,80008c94 <.L72>
80008c90:	0489                	add	s1,s1,2
80008c92:	078a                	sll	a5,a5,0x2

80008c94 <.L72>:
80008c94:	0007c363          	bltz	a5,80008c9a <.L73>
80008c98:	0485                	add	s1,s1,1

80008c9a <.L73>:
80008c9a:	8626                	mv	a2,s1
80008c9c:	8522                	mv	a0,s0
80008c9e:	3b85                	jal	80008a0e <__ashldi3>
80008ca0:	009994b3          	sll	s1,s3,s1
80008ca4:	0164d793          	srl	a5,s1,0x16
80008ca8:	e0078793          	add	a5,a5,-512
80008cac:	0786                	sll	a5,a5,0x1
80008cae:	9abe                	add	s5,s5,a5
80008cb0:	000ad783          	lhu	a5,0(s5)
80008cb4:	00b4d813          	srl	a6,s1,0xb
80008cb8:	0014f713          	and	a4,s1,1
80008cbc:	02f78633          	mul	a2,a5,a5
80008cc0:	0792                	sll	a5,a5,0x4
80008cc2:	0014d693          	srl	a3,s1,0x1
80008cc6:	0805                	add	a6,a6,1
80008cc8:	03063633          	mulhu	a2,a2,a6
80008ccc:	8f91                	sub	a5,a5,a2
80008cce:	96ba                	add	a3,a3,a4
80008cd0:	17fd                	add	a5,a5,-1
80008cd2:	c319                	beqz	a4,80008cd8 <.L74>
80008cd4:	0017d713          	srl	a4,a5,0x1

80008cd8 <.L74>:
80008cd8:	02f686b3          	mul	a3,a3,a5
80008cdc:	8f15                	sub	a4,a4,a3
80008cde:	02e7b733          	mulhu	a4,a5,a4
80008ce2:	07be                	sll	a5,a5,0xf
80008ce4:	8305                	srl	a4,a4,0x1
80008ce6:	97ba                	add	a5,a5,a4
80008ce8:	8726                	mv	a4,s1
80008cea:	029786b3          	mul	a3,a5,s1
80008cee:	9736                	add	a4,a4,a3
80008cf0:	00d736b3          	sltu	a3,a4,a3
80008cf4:	8726                	mv	a4,s1
80008cf6:	9736                	add	a4,a4,a3
80008cf8:	0297b6b3          	mulhu	a3,a5,s1
80008cfc:	9736                	add	a4,a4,a3
80008cfe:	8f99                	sub	a5,a5,a4
80008d00:	02b7b733          	mulhu	a4,a5,a1
80008d04:	02b787b3          	mul	a5,a5,a1
80008d08:	00a786b3          	add	a3,a5,a0
80008d0c:	00f6b7b3          	sltu	a5,a3,a5
80008d10:	95be                	add	a1,a1,a5
80008d12:	00b707b3          	add	a5,a4,a1
80008d16:	00178413          	add	s0,a5,1
80008d1a:	02848733          	mul	a4,s1,s0
80008d1e:	8d19                	sub	a0,a0,a4
80008d20:	00a6f463          	bgeu	a3,a0,80008d28 <.L75>
80008d24:	9526                	add	a0,a0,s1
80008d26:	843e                	mv	s0,a5

80008d28 <.L75>:
80008d28:	00956363          	bltu	a0,s1,80008d2e <.L76>
80008d2c:	0405                	add	s0,s0,1

80008d2e <.L76>:
80008d2e:	8952                	mv	s2,s4
80008d30:	b325                	j	80008a58 <.L49>

80008d32 <.L47>:
80008d32:	67c1                	lui	a5,0x10
80008d34:	8ab6                	mv	s5,a3
80008d36:	4a01                	li	s4,0
80008d38:	00f6f563          	bgeu	a3,a5,80008d42 <.L77>
80008d3c:	01069493          	sll	s1,a3,0x10
80008d40:	4a41                	li	s4,16

80008d42 <.L77>:
80008d42:	010007b7          	lui	a5,0x1000
80008d46:	00f4f463          	bgeu	s1,a5,80008d4e <.L78>
80008d4a:	0a21                	add	s4,s4,8
80008d4c:	04a2                	sll	s1,s1,0x8

80008d4e <.L78>:
80008d4e:	100007b7          	lui	a5,0x10000
80008d52:	00f4f463          	bgeu	s1,a5,80008d5a <.L79>
80008d56:	0a11                	add	s4,s4,4
80008d58:	0492                	sll	s1,s1,0x4

80008d5a <.L79>:
80008d5a:	400007b7          	lui	a5,0x40000
80008d5e:	00f4f463          	bgeu	s1,a5,80008d66 <.L80>
80008d62:	0a09                	add	s4,s4,2
80008d64:	048a                	sll	s1,s1,0x2

80008d66 <.L80>:
80008d66:	0004c363          	bltz	s1,80008d6c <.L81>
80008d6a:	0a05                	add	s4,s4,1

80008d6c <.L81>:
80008d6c:	01f91793          	sll	a5,s2,0x1f
80008d70:	8652                	mv	a2,s4
80008d72:	00145493          	srl	s1,s0,0x1
80008d76:	854e                	mv	a0,s3
80008d78:	85d6                	mv	a1,s5
80008d7a:	8cdd                	or	s1,s1,a5
80008d7c:	3949                	jal	80008a0e <__ashldi3>
80008d7e:	0165d613          	srl	a2,a1,0x16
80008d82:	800037b7          	lui	a5,0x80003
80008d86:	e0060613          	add	a2,a2,-512 # 7ffffe00 <__SHARE_RAM_segment_end__+0x7ee7fe00>
80008d8a:	0606                	sll	a2,a2,0x1
80008d8c:	5b078793          	add	a5,a5,1456 # 800035b0 <__SEGGER_RTL_Moeller_inverse_lut>
80008d90:	97b2                	add	a5,a5,a2
80008d92:	0007d783          	lhu	a5,0(a5)
80008d96:	00b5d513          	srl	a0,a1,0xb
80008d9a:	0015f713          	and	a4,a1,1
80008d9e:	02f78633          	mul	a2,a5,a5
80008da2:	0792                	sll	a5,a5,0x4
80008da4:	0015d693          	srl	a3,a1,0x1
80008da8:	0505                	add	a0,a0,1 # 7f800001 <__SHARE_RAM_segment_end__+0x7e680001>
80008daa:	02a63633          	mulhu	a2,a2,a0
80008dae:	8f91                	sub	a5,a5,a2
80008db0:	00195b13          	srl	s6,s2,0x1
80008db4:	96ba                	add	a3,a3,a4
80008db6:	17fd                	add	a5,a5,-1
80008db8:	c319                	beqz	a4,80008dbe <.L82>
80008dba:	0017d713          	srl	a4,a5,0x1

80008dbe <.L82>:
80008dbe:	02f686b3          	mul	a3,a3,a5
80008dc2:	8f15                	sub	a4,a4,a3
80008dc4:	02e7b733          	mulhu	a4,a5,a4
80008dc8:	07be                	sll	a5,a5,0xf
80008dca:	8305                	srl	a4,a4,0x1
80008dcc:	97ba                	add	a5,a5,a4
80008dce:	872e                	mv	a4,a1
80008dd0:	02b786b3          	mul	a3,a5,a1
80008dd4:	9736                	add	a4,a4,a3
80008dd6:	00d736b3          	sltu	a3,a4,a3
80008dda:	872e                	mv	a4,a1
80008ddc:	9736                	add	a4,a4,a3
80008dde:	02b7b6b3          	mulhu	a3,a5,a1
80008de2:	9736                	add	a4,a4,a3
80008de4:	8f99                	sub	a5,a5,a4
80008de6:	0367b733          	mulhu	a4,a5,s6
80008dea:	036787b3          	mul	a5,a5,s6
80008dee:	009786b3          	add	a3,a5,s1
80008df2:	00f6b7b3          	sltu	a5,a3,a5
80008df6:	97da                	add	a5,a5,s6
80008df8:	973e                	add	a4,a4,a5
80008dfa:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
80008dfe:	02f58633          	mul	a2,a1,a5
80008e02:	8c91                	sub	s1,s1,a2
80008e04:	0096f463          	bgeu	a3,s1,80008e0c <.L83>
80008e08:	94ae                	add	s1,s1,a1
80008e0a:	87ba                	mv	a5,a4

80008e0c <.L83>:
80008e0c:	00b4e363          	bltu	s1,a1,80008e12 <.L84>
80008e10:	0785                	add	a5,a5,1

80008e12 <.L84>:
80008e12:	477d                	li	a4,31
80008e14:	41470733          	sub	a4,a4,s4
80008e18:	00e7d633          	srl	a2,a5,a4
80008e1c:	c211                	beqz	a2,80008e20 <.L85>
80008e1e:	167d                	add	a2,a2,-1

80008e20 <.L85>:
80008e20:	02ca87b3          	mul	a5,s5,a2
80008e24:	03360733          	mul	a4,a2,s3
80008e28:	033636b3          	mulhu	a3,a2,s3
80008e2c:	40e40733          	sub	a4,s0,a4
80008e30:	00e43433          	sltu	s0,s0,a4
80008e34:	97b6                	add	a5,a5,a3
80008e36:	40f907b3          	sub	a5,s2,a5
80008e3a:	40878433          	sub	s0,a5,s0
80008e3e:	01546763          	bltu	s0,s5,80008e4c <.L86>
80008e42:	008a9463          	bne	s5,s0,80008e4a <.L95>
80008e46:	01376363          	bltu	a4,s3,80008e4c <.L86>

80008e4a <.L95>:
80008e4a:	0605                	add	a2,a2,1

80008e4c <.L86>:
80008e4c:	8432                	mv	s0,a2
80008e4e:	bd29                	j	80008c68 <.L109>

80008e50 <.L88>:
80008e50:	4401                	li	s0,0
80008e52:	bd19                	j	80008c68 <.L109>

Disassembly of section .text.libc.__umoddi3:

80008e54 <__umoddi3>:
80008e54:	1101                	add	sp,sp,-32
80008e56:	cc22                	sw	s0,24(sp)
80008e58:	ca26                	sw	s1,20(sp)
80008e5a:	c84a                	sw	s2,16(sp)
80008e5c:	c64e                	sw	s3,12(sp)
80008e5e:	c452                	sw	s4,8(sp)
80008e60:	ce06                	sw	ra,28(sp)
80008e62:	c256                	sw	s5,4(sp)
80008e64:	c05a                	sw	s6,0(sp)
80008e66:	892a                	mv	s2,a0
80008e68:	84ae                	mv	s1,a1
80008e6a:	8432                	mv	s0,a2
80008e6c:	89b6                	mv	s3,a3
80008e6e:	8a36                	mv	s4,a3
80008e70:	2e069e63          	bnez	a3,8000916c <.L111>
80008e74:	e589                	bnez	a1,80008e7e <.L112>
80008e76:	02c557b3          	divu	a5,a0,a2

80008e7a <.L174>:
80008e7a:	4701                	li	a4,0
80008e7c:	a815                	j	80008eb0 <.L113>

80008e7e <.L112>:
80008e7e:	010007b7          	lui	a5,0x1000
80008e82:	16f67163          	bgeu	a2,a5,80008fe4 <.L114>
80008e86:	4791                	li	a5,4
80008e88:	0cc7e063          	bltu	a5,a2,80008f48 <.L116>
80008e8c:	470d                	li	a4,3
80008e8e:	04e60d63          	beq	a2,a4,80008ee8 <.L118>
80008e92:	0af60363          	beq	a2,a5,80008f38 <.L119>
80008e96:	4785                	li	a5,1
80008e98:	3ef60763          	beq	a2,a5,80009286 <.L152>
80008e9c:	4789                	li	a5,2
80008e9e:	3ef61763          	bne	a2,a5,8000928c <.L153>
80008ea2:	01f59713          	sll	a4,a1,0x1f
80008ea6:	00155793          	srl	a5,a0,0x1
80008eaa:	8fd9                	or	a5,a5,a4
80008eac:	0015d713          	srl	a4,a1,0x1

80008eb0 <.L113>:
80008eb0:	02870733          	mul	a4,a4,s0
80008eb4:	40f2                	lw	ra,28(sp)
80008eb6:	4a22                	lw	s4,8(sp)
80008eb8:	4a92                	lw	s5,4(sp)
80008eba:	4b02                	lw	s6,0(sp)
80008ebc:	02f989b3          	mul	s3,s3,a5
80008ec0:	02f40533          	mul	a0,s0,a5
80008ec4:	99ba                	add	s3,s3,a4
80008ec6:	02f43433          	mulhu	s0,s0,a5
80008eca:	40a90533          	sub	a0,s2,a0
80008ece:	00a935b3          	sltu	a1,s2,a0
80008ed2:	4942                	lw	s2,16(sp)
80008ed4:	99a2                	add	s3,s3,s0
80008ed6:	4462                	lw	s0,24(sp)
80008ed8:	413484b3          	sub	s1,s1,s3
80008edc:	40b485b3          	sub	a1,s1,a1
80008ee0:	49b2                	lw	s3,12(sp)
80008ee2:	44d2                	lw	s1,20(sp)
80008ee4:	6105                	add	sp,sp,32
80008ee6:	8082                	ret

80008ee8 <.L118>:
80008ee8:	555557b7          	lui	a5,0x55555
80008eec:	55578793          	add	a5,a5,1365 # 55555555 <__SHARE_RAM_segment_end__+0x543d5555>
80008ef0:	02b7b6b3          	mulhu	a3,a5,a1
80008ef4:	02a7b633          	mulhu	a2,a5,a0
80008ef8:	02a78733          	mul	a4,a5,a0
80008efc:	02b787b3          	mul	a5,a5,a1
80008f00:	97b2                	add	a5,a5,a2
80008f02:	00c7b633          	sltu	a2,a5,a2
80008f06:	9636                	add	a2,a2,a3
80008f08:	00f706b3          	add	a3,a4,a5
80008f0c:	00e6b733          	sltu	a4,a3,a4
80008f10:	9732                	add	a4,a4,a2
80008f12:	97ba                	add	a5,a5,a4
80008f14:	00e7b5b3          	sltu	a1,a5,a4
80008f18:	9736                	add	a4,a4,a3
80008f1a:	00d736b3          	sltu	a3,a4,a3
80008f1e:	0705                	add	a4,a4,1
80008f20:	97b6                	add	a5,a5,a3
80008f22:	00173713          	seqz	a4,a4
80008f26:	00d7b6b3          	sltu	a3,a5,a3
80008f2a:	962e                	add	a2,a2,a1
80008f2c:	97ba                	add	a5,a5,a4
80008f2e:	96b2                	add	a3,a3,a2
80008f30:	00e7b733          	sltu	a4,a5,a4
80008f34:	9736                	add	a4,a4,a3
80008f36:	bfad                	j	80008eb0 <.L113>

80008f38 <.L119>:
80008f38:	01e59713          	sll	a4,a1,0x1e
80008f3c:	00255793          	srl	a5,a0,0x2
80008f40:	8fd9                	or	a5,a5,a4
80008f42:	0025d713          	srl	a4,a1,0x2
80008f46:	b7ad                	j	80008eb0 <.L113>

80008f48 <.L116>:
80008f48:	67c1                	lui	a5,0x10
80008f4a:	02c5d733          	divu	a4,a1,a2
80008f4e:	01055693          	srl	a3,a0,0x10
80008f52:	02f67b63          	bgeu	a2,a5,80008f88 <.L126>
80008f56:	02c707b3          	mul	a5,a4,a2
80008f5a:	40f587b3          	sub	a5,a1,a5
80008f5e:	07c2                	sll	a5,a5,0x10
80008f60:	97b6                	add	a5,a5,a3
80008f62:	02c7d633          	divu	a2,a5,a2
80008f66:	028606b3          	mul	a3,a2,s0
80008f6a:	0642                	sll	a2,a2,0x10
80008f6c:	8f95                	sub	a5,a5,a3
80008f6e:	01079693          	sll	a3,a5,0x10
80008f72:	01051793          	sll	a5,a0,0x10
80008f76:	83c1                	srl	a5,a5,0x10
80008f78:	97b6                	add	a5,a5,a3
80008f7a:	0287d7b3          	divu	a5,a5,s0
80008f7e:	97b2                	add	a5,a5,a2
80008f80:	00c7b633          	sltu	a2,a5,a2
80008f84:	9732                	add	a4,a4,a2
80008f86:	b72d                	j	80008eb0 <.L113>

80008f88 <.L126>:
80008f88:	02c707b3          	mul	a5,a4,a2
80008f8c:	01855613          	srl	a2,a0,0x18
80008f90:	0ff6f693          	zext.b	a3,a3
80008f94:	40f587b3          	sub	a5,a1,a5
80008f98:	07a2                	sll	a5,a5,0x8
80008f9a:	963e                	add	a2,a2,a5
80008f9c:	028657b3          	divu	a5,a2,s0
80008fa0:	028785b3          	mul	a1,a5,s0
80008fa4:	07a2                	sll	a5,a5,0x8
80008fa6:	8e0d                	sub	a2,a2,a1
80008fa8:	0622                	sll	a2,a2,0x8
80008faa:	96b2                	add	a3,a3,a2
80008fac:	0286d5b3          	divu	a1,a3,s0
80008fb0:	97ae                	add	a5,a5,a1
80008fb2:	07a2                	sll	a5,a5,0x8
80008fb4:	02858633          	mul	a2,a1,s0
80008fb8:	8e91                	sub	a3,a3,a2
80008fba:	00855613          	srl	a2,a0,0x8
80008fbe:	0ff67613          	zext.b	a2,a2
80008fc2:	06a2                	sll	a3,a3,0x8
80008fc4:	96b2                	add	a3,a3,a2
80008fc6:	0286d633          	divu	a2,a3,s0
80008fca:	97b2                	add	a5,a5,a2
80008fcc:	07a2                	sll	a5,a5,0x8
80008fce:	02860533          	mul	a0,a2,s0
80008fd2:	0ff97613          	zext.b	a2,s2
80008fd6:	8e89                	sub	a3,a3,a0
80008fd8:	06a2                	sll	a3,a3,0x8
80008fda:	96b2                	add	a3,a3,a2
80008fdc:	0286d6b3          	divu	a3,a3,s0
80008fe0:	97b6                	add	a5,a5,a3
80008fe2:	b5f9                	j	80008eb0 <.L113>

80008fe4 <.L114>:
80008fe4:	80003b37          	lui	s6,0x80003
80008fe8:	5b0b0b13          	add	s6,s6,1456 # 800035b0 <__SEGGER_RTL_Moeller_inverse_lut>
80008fec:	0ac5fe63          	bgeu	a1,a2,800090a8 <.L128>
80008ff0:	10000737          	lui	a4,0x10000
80008ff4:	87b2                	mv	a5,a2
80008ff6:	00e67563          	bgeu	a2,a4,80009000 <.L129>
80008ffa:	00461793          	sll	a5,a2,0x4
80008ffe:	4a11                	li	s4,4

80009000 <.L129>:
80009000:	40000737          	lui	a4,0x40000
80009004:	00e7f463          	bgeu	a5,a4,8000900c <.L130>
80009008:	0a09                	add	s4,s4,2
8000900a:	078a                	sll	a5,a5,0x2

8000900c <.L130>:
8000900c:	0007c363          	bltz	a5,80009012 <.L131>
80009010:	0a05                	add	s4,s4,1

80009012 <.L131>:
80009012:	8652                	mv	a2,s4
80009014:	854a                	mv	a0,s2
80009016:	85a6                	mv	a1,s1
80009018:	3add                	jal	80008a0e <__ashldi3>
8000901a:	01441a33          	sll	s4,s0,s4
8000901e:	016a5793          	srl	a5,s4,0x16
80009022:	e0078793          	add	a5,a5,-512 # fe00 <__XPI0_segment_used_size__+0x31c8>
80009026:	0786                	sll	a5,a5,0x1
80009028:	97da                	add	a5,a5,s6
8000902a:	0007d783          	lhu	a5,0(a5)
8000902e:	00ba5813          	srl	a6,s4,0xb
80009032:	001a7713          	and	a4,s4,1
80009036:	02f78633          	mul	a2,a5,a5
8000903a:	0792                	sll	a5,a5,0x4
8000903c:	001a5693          	srl	a3,s4,0x1
80009040:	0805                	add	a6,a6,1
80009042:	03063633          	mulhu	a2,a2,a6
80009046:	8f91                	sub	a5,a5,a2
80009048:	96ba                	add	a3,a3,a4
8000904a:	17fd                	add	a5,a5,-1
8000904c:	c319                	beqz	a4,80009052 <.L132>
8000904e:	0017d713          	srl	a4,a5,0x1

80009052 <.L132>:
80009052:	02f686b3          	mul	a3,a3,a5
80009056:	8f15                	sub	a4,a4,a3
80009058:	02e7b733          	mulhu	a4,a5,a4
8000905c:	07be                	sll	a5,a5,0xf
8000905e:	8305                	srl	a4,a4,0x1
80009060:	97ba                	add	a5,a5,a4
80009062:	8752                	mv	a4,s4
80009064:	034786b3          	mul	a3,a5,s4
80009068:	9736                	add	a4,a4,a3
8000906a:	00d736b3          	sltu	a3,a4,a3
8000906e:	8752                	mv	a4,s4
80009070:	9736                	add	a4,a4,a3
80009072:	0347b6b3          	mulhu	a3,a5,s4
80009076:	9736                	add	a4,a4,a3
80009078:	8f99                	sub	a5,a5,a4
8000907a:	02b7b733          	mulhu	a4,a5,a1
8000907e:	02b787b3          	mul	a5,a5,a1
80009082:	00a786b3          	add	a3,a5,a0
80009086:	00f6b7b3          	sltu	a5,a3,a5
8000908a:	95be                	add	a1,a1,a5
8000908c:	972e                	add	a4,a4,a1
8000908e:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
80009092:	02fa0633          	mul	a2,s4,a5
80009096:	8d11                	sub	a0,a0,a2
80009098:	00a6f463          	bgeu	a3,a0,800090a0 <.L133>
8000909c:	9552                	add	a0,a0,s4
8000909e:	87ba                	mv	a5,a4

800090a0 <.L133>:
800090a0:	dd456de3          	bltu	a0,s4,80008e7a <.L174>

800090a4 <.L160>:
800090a4:	0785                	add	a5,a5,1
800090a6:	bbd1                	j	80008e7a <.L174>

800090a8 <.L128>:
800090a8:	02c5dab3          	divu	s5,a1,a2
800090ac:	10000737          	lui	a4,0x10000
800090b0:	87b2                	mv	a5,a2
800090b2:	02ca85b3          	mul	a1,s5,a2
800090b6:	40b485b3          	sub	a1,s1,a1
800090ba:	00e67563          	bgeu	a2,a4,800090c4 <.L135>
800090be:	00461793          	sll	a5,a2,0x4
800090c2:	4a11                	li	s4,4

800090c4 <.L135>:
800090c4:	40000737          	lui	a4,0x40000
800090c8:	00e7f463          	bgeu	a5,a4,800090d0 <.L136>
800090cc:	0a09                	add	s4,s4,2
800090ce:	078a                	sll	a5,a5,0x2

800090d0 <.L136>:
800090d0:	0007c363          	bltz	a5,800090d6 <.L137>
800090d4:	0a05                	add	s4,s4,1

800090d6 <.L137>:
800090d6:	8652                	mv	a2,s4
800090d8:	854a                	mv	a0,s2
800090da:	3a15                	jal	80008a0e <__ashldi3>
800090dc:	01441a33          	sll	s4,s0,s4
800090e0:	016a5793          	srl	a5,s4,0x16
800090e4:	e0078793          	add	a5,a5,-512
800090e8:	0786                	sll	a5,a5,0x1
800090ea:	9b3e                	add	s6,s6,a5
800090ec:	000b5783          	lhu	a5,0(s6)
800090f0:	00ba5813          	srl	a6,s4,0xb
800090f4:	001a7713          	and	a4,s4,1
800090f8:	02f78633          	mul	a2,a5,a5
800090fc:	0792                	sll	a5,a5,0x4
800090fe:	001a5693          	srl	a3,s4,0x1
80009102:	0805                	add	a6,a6,1
80009104:	03063633          	mulhu	a2,a2,a6
80009108:	8f91                	sub	a5,a5,a2
8000910a:	96ba                	add	a3,a3,a4
8000910c:	17fd                	add	a5,a5,-1
8000910e:	c319                	beqz	a4,80009114 <.L138>
80009110:	0017d713          	srl	a4,a5,0x1

80009114 <.L138>:
80009114:	02f686b3          	mul	a3,a3,a5
80009118:	8f15                	sub	a4,a4,a3
8000911a:	02e7b733          	mulhu	a4,a5,a4
8000911e:	07be                	sll	a5,a5,0xf
80009120:	8305                	srl	a4,a4,0x1
80009122:	97ba                	add	a5,a5,a4
80009124:	8752                	mv	a4,s4
80009126:	034786b3          	mul	a3,a5,s4
8000912a:	9736                	add	a4,a4,a3
8000912c:	00d736b3          	sltu	a3,a4,a3
80009130:	8752                	mv	a4,s4
80009132:	9736                	add	a4,a4,a3
80009134:	0347b6b3          	mulhu	a3,a5,s4
80009138:	9736                	add	a4,a4,a3
8000913a:	8f99                	sub	a5,a5,a4
8000913c:	02b7b733          	mulhu	a4,a5,a1
80009140:	02b787b3          	mul	a5,a5,a1
80009144:	00a786b3          	add	a3,a5,a0
80009148:	00f6b7b3          	sltu	a5,a3,a5
8000914c:	95be                	add	a1,a1,a5
8000914e:	972e                	add	a4,a4,a1
80009150:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
80009154:	02fa0633          	mul	a2,s4,a5
80009158:	8d11                	sub	a0,a0,a2
8000915a:	00a6f463          	bgeu	a3,a0,80009162 <.L139>
8000915e:	9552                	add	a0,a0,s4
80009160:	87ba                	mv	a5,a4

80009162 <.L139>:
80009162:	01456363          	bltu	a0,s4,80009168 <.L140>
80009166:	0785                	add	a5,a5,1

80009168 <.L140>:
80009168:	8756                	mv	a4,s5
8000916a:	b399                	j	80008eb0 <.L113>

8000916c <.L111>:
8000916c:	67c1                	lui	a5,0x10
8000916e:	4a81                	li	s5,0
80009170:	00f6f563          	bgeu	a3,a5,8000917a <.L141>
80009174:	01069a13          	sll	s4,a3,0x10
80009178:	4ac1                	li	s5,16

8000917a <.L141>:
8000917a:	010007b7          	lui	a5,0x1000
8000917e:	00fa7463          	bgeu	s4,a5,80009186 <.L142>
80009182:	0aa1                	add	s5,s5,8
80009184:	0a22                	sll	s4,s4,0x8

80009186 <.L142>:
80009186:	100007b7          	lui	a5,0x10000
8000918a:	00fa7463          	bgeu	s4,a5,80009192 <.L143>
8000918e:	0a91                	add	s5,s5,4
80009190:	0a12                	sll	s4,s4,0x4

80009192 <.L143>:
80009192:	400007b7          	lui	a5,0x40000
80009196:	00fa7463          	bgeu	s4,a5,8000919e <.L144>
8000919a:	0a89                	add	s5,s5,2
8000919c:	0a0a                	sll	s4,s4,0x2

8000919e <.L144>:
8000919e:	000a4363          	bltz	s4,800091a4 <.L145>
800091a2:	0a85                	add	s5,s5,1

800091a4 <.L145>:
800091a4:	01f49793          	sll	a5,s1,0x1f
800091a8:	8656                	mv	a2,s5
800091aa:	00195a13          	srl	s4,s2,0x1
800091ae:	8522                	mv	a0,s0
800091b0:	85ce                	mv	a1,s3
800091b2:	0147ea33          	or	s4,a5,s4
800091b6:	38a1                	jal	80008a0e <__ashldi3>
800091b8:	0165d613          	srl	a2,a1,0x16
800091bc:	800037b7          	lui	a5,0x80003
800091c0:	e0060613          	add	a2,a2,-512
800091c4:	0606                	sll	a2,a2,0x1
800091c6:	5b078793          	add	a5,a5,1456 # 800035b0 <__SEGGER_RTL_Moeller_inverse_lut>
800091ca:	97b2                	add	a5,a5,a2
800091cc:	0007d783          	lhu	a5,0(a5)
800091d0:	00b5d513          	srl	a0,a1,0xb
800091d4:	0015f713          	and	a4,a1,1
800091d8:	02f78633          	mul	a2,a5,a5
800091dc:	0792                	sll	a5,a5,0x4
800091de:	0015d693          	srl	a3,a1,0x1
800091e2:	0505                	add	a0,a0,1
800091e4:	02a63633          	mulhu	a2,a2,a0
800091e8:	8f91                	sub	a5,a5,a2
800091ea:	0014db13          	srl	s6,s1,0x1
800091ee:	96ba                	add	a3,a3,a4
800091f0:	17fd                	add	a5,a5,-1
800091f2:	c319                	beqz	a4,800091f8 <.L146>
800091f4:	0017d713          	srl	a4,a5,0x1

800091f8 <.L146>:
800091f8:	02f686b3          	mul	a3,a3,a5
800091fc:	8f15                	sub	a4,a4,a3
800091fe:	02e7b733          	mulhu	a4,a5,a4
80009202:	07be                	sll	a5,a5,0xf
80009204:	8305                	srl	a4,a4,0x1
80009206:	97ba                	add	a5,a5,a4
80009208:	872e                	mv	a4,a1
8000920a:	02b786b3          	mul	a3,a5,a1
8000920e:	9736                	add	a4,a4,a3
80009210:	00d736b3          	sltu	a3,a4,a3
80009214:	872e                	mv	a4,a1
80009216:	9736                	add	a4,a4,a3
80009218:	02b7b6b3          	mulhu	a3,a5,a1
8000921c:	9736                	add	a4,a4,a3
8000921e:	8f99                	sub	a5,a5,a4
80009220:	0367b733          	mulhu	a4,a5,s6
80009224:	036787b3          	mul	a5,a5,s6
80009228:	014786b3          	add	a3,a5,s4
8000922c:	00f6b7b3          	sltu	a5,a3,a5
80009230:	97da                	add	a5,a5,s6
80009232:	973e                	add	a4,a4,a5
80009234:	00170793          	add	a5,a4,1
80009238:	02f58633          	mul	a2,a1,a5
8000923c:	40ca0a33          	sub	s4,s4,a2
80009240:	0146f463          	bgeu	a3,s4,80009248 <.L147>
80009244:	9a2e                	add	s4,s4,a1
80009246:	87ba                	mv	a5,a4

80009248 <.L147>:
80009248:	00ba6363          	bltu	s4,a1,8000924e <.L148>
8000924c:	0785                	add	a5,a5,1

8000924e <.L148>:
8000924e:	477d                	li	a4,31
80009250:	41570733          	sub	a4,a4,s5
80009254:	00e7d7b3          	srl	a5,a5,a4
80009258:	c391                	beqz	a5,8000925c <.L149>
8000925a:	17fd                	add	a5,a5,-1

8000925c <.L149>:
8000925c:	0287b633          	mulhu	a2,a5,s0
80009260:	02f98733          	mul	a4,s3,a5
80009264:	028786b3          	mul	a3,a5,s0
80009268:	9732                	add	a4,a4,a2
8000926a:	40e48733          	sub	a4,s1,a4
8000926e:	40d906b3          	sub	a3,s2,a3
80009272:	00d93633          	sltu	a2,s2,a3
80009276:	8f11                	sub	a4,a4,a2
80009278:	c13761e3          	bltu	a4,s3,80008e7a <.L174>
8000927c:	e2e994e3          	bne	s3,a4,800090a4 <.L160>
80009280:	be86ede3          	bltu	a3,s0,80008e7a <.L174>
80009284:	b505                	j	800090a4 <.L160>

80009286 <.L152>:
80009286:	87aa                	mv	a5,a0
80009288:	872e                	mv	a4,a1
8000928a:	b11d                	j	80008eb0 <.L113>

8000928c <.L153>:
8000928c:	4781                	li	a5,0
8000928e:	b6f5                	j	80008e7a <.L174>

Disassembly of section .text.libc.abs:

80009290 <abs>:
80009290:	41f55793          	sra	a5,a0,0x1f
80009294:	8d3d                	xor	a0,a0,a5
80009296:	8d1d                	sub	a0,a0,a5
80009298:	8082                	ret

Disassembly of section .text.libc.memcpy:

8000929a <memcpy>:
8000929a:	c251                	beqz	a2,8000931e <.Lmemcpy_done>
8000929c:	87aa                	mv	a5,a0
8000929e:	00b546b3          	xor	a3,a0,a1
800092a2:	06fa                	sll	a3,a3,0x1e
800092a4:	e2bd                	bnez	a3,8000930a <.Lmemcpy_byte_copy>
800092a6:	01e51693          	sll	a3,a0,0x1e
800092aa:	ce81                	beqz	a3,800092c2 <.Lmemcpy_aligned>

800092ac <.Lmemcpy_word_align>:
800092ac:	00058683          	lb	a3,0(a1)
800092b0:	00d50023          	sb	a3,0(a0)
800092b4:	0585                	add	a1,a1,1
800092b6:	0505                	add	a0,a0,1
800092b8:	167d                	add	a2,a2,-1
800092ba:	c22d                	beqz	a2,8000931c <.Lmemcpy_memcpy_end>
800092bc:	01e51693          	sll	a3,a0,0x1e
800092c0:	f6f5                	bnez	a3,800092ac <.Lmemcpy_word_align>

800092c2 <.Lmemcpy_aligned>:
800092c2:	02000693          	li	a3,32
800092c6:	02d66763          	bltu	a2,a3,800092f4 <.Lmemcpy_word_copy>

800092ca <.Lmemcpy_aligned_block_copy_loop>:
800092ca:	4198                	lw	a4,0(a1)
800092cc:	c118                	sw	a4,0(a0)
800092ce:	41d8                	lw	a4,4(a1)
800092d0:	c158                	sw	a4,4(a0)
800092d2:	4598                	lw	a4,8(a1)
800092d4:	c518                	sw	a4,8(a0)
800092d6:	45d8                	lw	a4,12(a1)
800092d8:	c558                	sw	a4,12(a0)
800092da:	4998                	lw	a4,16(a1)
800092dc:	c918                	sw	a4,16(a0)
800092de:	49d8                	lw	a4,20(a1)
800092e0:	c958                	sw	a4,20(a0)
800092e2:	4d98                	lw	a4,24(a1)
800092e4:	cd18                	sw	a4,24(a0)
800092e6:	4dd8                	lw	a4,28(a1)
800092e8:	cd58                	sw	a4,28(a0)
800092ea:	9536                	add	a0,a0,a3
800092ec:	95b6                	add	a1,a1,a3
800092ee:	8e15                	sub	a2,a2,a3
800092f0:	fcd67de3          	bgeu	a2,a3,800092ca <.Lmemcpy_aligned_block_copy_loop>

800092f4 <.Lmemcpy_word_copy>:
800092f4:	c605                	beqz	a2,8000931c <.Lmemcpy_memcpy_end>
800092f6:	4691                	li	a3,4
800092f8:	00d66963          	bltu	a2,a3,8000930a <.Lmemcpy_byte_copy>

800092fc <.Lmemcpy_word_copy_loop>:
800092fc:	4198                	lw	a4,0(a1)
800092fe:	c118                	sw	a4,0(a0)
80009300:	9536                	add	a0,a0,a3
80009302:	95b6                	add	a1,a1,a3
80009304:	8e15                	sub	a2,a2,a3
80009306:	fed67be3          	bgeu	a2,a3,800092fc <.Lmemcpy_word_copy_loop>

8000930a <.Lmemcpy_byte_copy>:
8000930a:	ca09                	beqz	a2,8000931c <.Lmemcpy_memcpy_end>

8000930c <.Lmemcpy_byte_copy_loop>:
8000930c:	00058703          	lb	a4,0(a1)
80009310:	00e50023          	sb	a4,0(a0)
80009314:	0585                	add	a1,a1,1
80009316:	0505                	add	a0,a0,1
80009318:	167d                	add	a2,a2,-1
8000931a:	fa6d                	bnez	a2,8000930c <.Lmemcpy_byte_copy_loop>

8000931c <.Lmemcpy_memcpy_end>:
8000931c:	853e                	mv	a0,a5

8000931e <.Lmemcpy_done>:
8000931e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

80009320 <__SEGGER_RTL_pow10f>:
80009320:	1101                	add	sp,sp,-32
80009322:	cc22                	sw	s0,24(sp)
80009324:	c64e                	sw	s3,12(sp)
80009326:	ce06                	sw	ra,28(sp)
80009328:	ca26                	sw	s1,20(sp)
8000932a:	c84a                	sw	s2,16(sp)
8000932c:	842a                	mv	s0,a0
8000932e:	4981                	li	s3,0
80009330:	00055563          	bgez	a0,8000933a <.L17>
80009334:	40a00433          	neg	s0,a0
80009338:	4985                	li	s3,1

8000933a <.L17>:
8000933a:	9e822503          	lw	a0,-1560(tp) # fffff9e8 <__APB_SRAM_segment_end__+0xbf0d9e8>
8000933e:	800044b7          	lui	s1,0x80004
80009342:	9b048493          	add	s1,s1,-1616 # 800039b0 <__SEGGER_RTL_aPower2f>

80009346 <.L18>:
80009346:	ec19                	bnez	s0,80009364 <.L20>
80009348:	00098763          	beqz	s3,80009356 <.L16>
8000934c:	85aa                	mv	a1,a0
8000934e:	9e822503          	lw	a0,-1560(tp) # fffff9e8 <__APB_SRAM_segment_end__+0xbf0d9e8>
80009352:	610030ef          	jal	8000c962 <__divsf3>

80009356 <.L16>:
80009356:	40f2                	lw	ra,28(sp)
80009358:	4462                	lw	s0,24(sp)
8000935a:	44d2                	lw	s1,20(sp)
8000935c:	4942                	lw	s2,16(sp)
8000935e:	49b2                	lw	s3,12(sp)
80009360:	6105                	add	sp,sp,32
80009362:	8082                	ret

80009364 <.L20>:
80009364:	00147793          	and	a5,s0,1
80009368:	c781                	beqz	a5,80009370 <.L19>
8000936a:	408c                	lw	a1,0(s1)
8000936c:	436030ef          	jal	8000c7a2 <__mulsf3>

80009370 <.L19>:
80009370:	8405                	sra	s0,s0,0x1
80009372:	0491                	add	s1,s1,4
80009374:	bfc9                	j	80009346 <.L18>

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80009376 <__SEGGER_RTL_prin_flush>:
80009376:	4950                	lw	a2,20(a0)
80009378:	ce19                	beqz	a2,80009396 <.L20>
8000937a:	511c                	lw	a5,32(a0)
8000937c:	1141                	add	sp,sp,-16
8000937e:	c422                	sw	s0,8(sp)
80009380:	c606                	sw	ra,12(sp)
80009382:	842a                	mv	s0,a0
80009384:	c399                	beqz	a5,8000938a <.L12>
80009386:	490c                	lw	a1,16(a0)
80009388:	9782                	jalr	a5

8000938a <.L12>:
8000938a:	40b2                	lw	ra,12(sp)
8000938c:	00042a23          	sw	zero,20(s0)
80009390:	4422                	lw	s0,8(sp)
80009392:	0141                	add	sp,sp,16
80009394:	8082                	ret

80009396 <.L20>:
80009396:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80009398 <__SEGGER_RTL_pre_padding>:
80009398:	0105f793          	and	a5,a1,16
8000939c:	eb91                	bnez	a5,800093b0 <.L40>
8000939e:	2005f793          	and	a5,a1,512
800093a2:	02000593          	li	a1,32
800093a6:	c399                	beqz	a5,800093ac <.L42>
800093a8:	03000593          	li	a1,48

800093ac <.L42>:
800093ac:	4f70306f          	j	8000d0a2 <__SEGGER_RTL_print_padding>

800093b0 <.L40>:
800093b0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin_l:

800093b2 <__SEGGER_RTL_init_prin_l>:
800093b2:	1141                	add	sp,sp,-16
800093b4:	c226                	sw	s1,4(sp)
800093b6:	02400613          	li	a2,36
800093ba:	84ae                	mv	s1,a1
800093bc:	4581                	li	a1,0
800093be:	c422                	sw	s0,8(sp)
800093c0:	c606                	sw	ra,12(sp)
800093c2:	842a                	mv	s0,a0
800093c4:	2cf030ef          	jal	8000ce92 <memset>
800093c8:	40b2                	lw	ra,12(sp)
800093ca:	cc44                	sw	s1,28(s0)
800093cc:	4422                	lw	s0,8(sp)
800093ce:	4492                	lw	s1,4(sp)
800093d0:	0141                	add	sp,sp,16
800093d2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin:

800093d4 <__SEGGER_RTL_init_prin>:
800093d4:	1141                	add	sp,sp,-16
800093d6:	c422                	sw	s0,8(sp)
800093d8:	c606                	sw	ra,12(sp)
800093da:	842a                	mv	s0,a0
800093dc:	289040ef          	jal	8000de64 <__SEGGER_RTL_current_locale>
800093e0:	85aa                	mv	a1,a0
800093e2:	8522                	mv	a0,s0
800093e4:	4422                	lw	s0,8(sp)
800093e6:	40b2                	lw	ra,12(sp)
800093e8:	0141                	add	sp,sp,16
800093ea:	b7e1                	j	800093b2 <__SEGGER_RTL_init_prin_l>

Disassembly of section .text.libc.snprintf:

800093ec <snprintf>:
800093ec:	711d                	add	sp,sp,-96
800093ee:	d84a                	sw	s2,48(sp)
800093f0:	cabe                	sw	a5,84(sp)
800093f2:	892a                	mv	s2,a0
800093f4:	00fc                	add	a5,sp,76
800093f6:	0068                	add	a0,sp,12
800093f8:	de06                	sw	ra,60(sp)
800093fa:	dc22                	sw	s0,56(sp)
800093fc:	da26                	sw	s1,52(sp)
800093fe:	8432                	mv	s0,a2
80009400:	84ae                	mv	s1,a1
80009402:	c6b6                	sw	a3,76(sp)
80009404:	c8ba                	sw	a4,80(sp)
80009406:	ccc2                	sw	a6,88(sp)
80009408:	cec6                	sw	a7,92(sp)
8000940a:	c43e                	sw	a5,8(sp)
8000940c:	37e1                	jal	800093d4 <__SEGGER_RTL_init_prin>
8000940e:	4622                	lw	a2,8(sp)
80009410:	85a2                	mv	a1,s0
80009412:	0068                	add	a0,sp,12
80009414:	cc4a                	sw	s2,24(sp)
80009416:	c826                	sw	s1,16(sp)
80009418:	565030ef          	jal	8000d17c <__SEGGER_RTL_vfprintf>
8000941c:	50f2                	lw	ra,60(sp)
8000941e:	5462                	lw	s0,56(sp)
80009420:	54d2                	lw	s1,52(sp)
80009422:	5942                	lw	s2,48(sp)
80009424:	6125                	add	sp,sp,96
80009426:	8082                	ret

Disassembly of section .text.libc.vfprintf:

80009428 <vfprintf>:
80009428:	1101                	add	sp,sp,-32
8000942a:	cc22                	sw	s0,24(sp)
8000942c:	ca26                	sw	s1,20(sp)
8000942e:	ce06                	sw	ra,28(sp)
80009430:	84ae                	mv	s1,a1
80009432:	842a                	mv	s0,a0
80009434:	c632                	sw	a2,12(sp)
80009436:	22f040ef          	jal	8000de64 <__SEGGER_RTL_current_locale>
8000943a:	85aa                	mv	a1,a0
8000943c:	8522                	mv	a0,s0
8000943e:	4462                	lw	s0,24(sp)
80009440:	46b2                	lw	a3,12(sp)
80009442:	40f2                	lw	ra,28(sp)
80009444:	8626                	mv	a2,s1
80009446:	44d2                	lw	s1,20(sp)
80009448:	6105                	add	sp,sp,32
8000944a:	4bd0306f          	j	8000d106 <vfprintf_l>

Disassembly of section .text.libc.printf:

8000944e <printf>:
8000944e:	7139                	add	sp,sp,-64
80009450:	da3e                	sw	a5,52(sp)
80009452:	010807b7          	lui	a5,0x1080
80009456:	d22e                	sw	a1,36(sp)
80009458:	85aa                	mv	a1,a0
8000945a:	3507a503          	lw	a0,848(a5) # 1080350 <stdout>
8000945e:	d432                	sw	a2,40(sp)
80009460:	1050                	add	a2,sp,36
80009462:	ce06                	sw	ra,28(sp)
80009464:	d636                	sw	a3,44(sp)
80009466:	d83a                	sw	a4,48(sp)
80009468:	dc42                	sw	a6,56(sp)
8000946a:	de46                	sw	a7,60(sp)
8000946c:	c632                	sw	a2,12(sp)
8000946e:	3f6d                	jal	80009428 <vfprintf>
80009470:	40f2                	lw	ra,28(sp)
80009472:	6121                	add	sp,sp,64
80009474:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

80009476 <__SEGGER_init_heap>:
80009476:	00080537          	lui	a0,0x80
8000947a:	00050513          	mv	a0,a0
8000947e:	000845b7          	lui	a1,0x84
80009482:	00058593          	mv	a1,a1
80009486:	8d89                	sub	a1,a1,a0
80009488:	a009                	j	8000948a <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

8000948a <__SEGGER_RTL_init_heap>:
8000948a:	479d                	li	a5,7
8000948c:	00b7f963          	bgeu	a5,a1,8000949e <.L68>
80009490:	010807b7          	lui	a5,0x1080
80009494:	34a7a223          	sw	a0,836(a5) # 1080344 <__SEGGER_RTL_heap_globals>
80009498:	00052023          	sw	zero,0(a0) # 80000 <__AXI_SRAM_segment_size__>
8000949c:	c14c                	sw	a1,4(a0)

8000949e <.L68>:
8000949e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

800094a0 <__SEGGER_RTL_ascii_toupper>:
800094a0:	f9f50713          	add	a4,a0,-97
800094a4:	47e5                	li	a5,25
800094a6:	00e7e363          	bltu	a5,a4,800094ac <.L5>
800094aa:	1501                	add	a0,a0,-32

800094ac <.L5>:
800094ac:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

800094ae <__SEGGER_RTL_ascii_towupper>:
800094ae:	f9f50713          	add	a4,a0,-97
800094b2:	47e5                	li	a5,25
800094b4:	00e7e363          	bltu	a5,a4,800094ba <.L12>
800094b8:	1501                	add	a0,a0,-32

800094ba <.L12>:
800094ba:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

800094bc <__SEGGER_RTL_ascii_mbtowc>:
800094bc:	87aa                	mv	a5,a0
800094be:	4501                	li	a0,0
800094c0:	c195                	beqz	a1,800094e4 <.L55>
800094c2:	c20d                	beqz	a2,800094e4 <.L55>
800094c4:	0005c703          	lbu	a4,0(a1) # 84000 <__heap_end__>
800094c8:	07f00613          	li	a2,127
800094cc:	5579                	li	a0,-2
800094ce:	00e66b63          	bltu	a2,a4,800094e4 <.L55>
800094d2:	c391                	beqz	a5,800094d6 <.L57>
800094d4:	c398                	sw	a4,0(a5)

800094d6 <.L57>:
800094d6:	0006a023          	sw	zero,0(a3)
800094da:	0006a223          	sw	zero,4(a3)
800094de:	00e03533          	snez	a0,a4
800094e2:	8082                	ret

800094e4 <.L55>:
800094e4:	8082                	ret

Disassembly of section .text.console_init:

800094e6 <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
800094e6:	7139                	add	sp,sp,-64
800094e8:	de06                	sw	ra,60(sp)
800094ea:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
800094ec:	4785                	li	a5,1
800094ee:	d63e                	sw	a5,44(sp)

    if (cfg->type == CONSOLE_TYPE_UART) {
800094f0:	47b2                	lw	a5,12(sp)
800094f2:	439c                	lw	a5,0(a5)
800094f4:	e7b1                	bnez	a5,80009540 <.L2>

800094f6 <.LBB2>:
        uart_config_t config = {0};
800094f6:	cc02                	sw	zero,24(sp)
800094f8:	ce02                	sw	zero,28(sp)
800094fa:	d002                	sw	zero,32(sp)
800094fc:	d202                	sw	zero,36(sp)
800094fe:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
80009500:	47b2                	lw	a5,12(sp)
80009502:	43dc                	lw	a5,4(a5)
80009504:	873e                	mv	a4,a5
80009506:	083c                	add	a5,sp,24
80009508:	85be                	mv	a1,a5
8000950a:	853a                	mv	a0,a4
8000950c:	9ecfc0ef          	jal	800056f8 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
80009510:	47b2                	lw	a5,12(sp)
80009512:	479c                	lw	a5,8(a5)
80009514:	cc3e                	sw	a5,24(sp)
        config.baudrate = cfg->baudrate;
80009516:	47b2                	lw	a5,12(sp)
80009518:	47dc                	lw	a5,12(a5)
8000951a:	ce3e                	sw	a5,28(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
8000951c:	47b2                	lw	a5,12(sp)
8000951e:	43dc                	lw	a5,4(a5)
80009520:	873e                	mv	a4,a5
80009522:	083c                	add	a5,sp,24
80009524:	85be                	mv	a1,a5
80009526:	853a                	mv	a0,a4
80009528:	70b000ef          	jal	8000a432 <uart_init>
8000952c:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
8000952e:	57b2                	lw	a5,44(sp)
80009530:	eb81                	bnez	a5,80009540 <.L2>
            g_console_uart = (UART_Type *)cfg->base;
80009532:	47b2                	lw	a5,12(sp)
80009534:	43dc                	lw	a5,4(a5)
80009536:	873e                	mv	a4,a5
80009538:	010807b7          	lui	a5,0x1080
8000953c:	32e7ac23          	sw	a4,824(a5) # 1080338 <g_console_uart>

80009540 <.L2>:
        }
    }

    return stat;
80009540:	57b2                	lw	a5,44(sp)
}
80009542:	853e                	mv	a0,a5
80009544:	50f2                	lw	ra,60(sp)
80009546:	6121                	add	sp,sp,64
80009548:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

8000954a <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
8000954a:	7179                	add	sp,sp,-48
8000954c:	d606                	sw	ra,44(sp)
8000954e:	c62a                	sw	a0,12(sp)
80009550:	c42e                	sw	a1,8(sp)
80009552:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
80009554:	ce02                	sw	zero,28(sp)
80009556:	a0b9                	j	800095a4 <.L13>

80009558 <.L17>:
        if (data[count] == '\n') {
80009558:	4722                	lw	a4,8(sp)
8000955a:	47f2                	lw	a5,28(sp)
8000955c:	97ba                	add	a5,a5,a4
8000955e:	0007c703          	lbu	a4,0(a5)
80009562:	47a9                	li	a5,10
80009564:	00f71d63          	bne	a4,a5,8000957e <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
80009568:	0001                	nop

8000956a <.L15>:
8000956a:	010807b7          	lui	a5,0x1080
8000956e:	3387a783          	lw	a5,824(a5) # 1080338 <g_console_uart>
80009572:	45b5                	li	a1,13
80009574:	853e                	mv	a0,a5
80009576:	b96fc0ef          	jal	8000590c <uart_send_byte>
8000957a:	87aa                	mv	a5,a0
8000957c:	f7fd                	bnez	a5,8000956a <.L15>

8000957e <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
8000957e:	0001                	nop

80009580 <.L16>:
80009580:	010807b7          	lui	a5,0x1080
80009584:	3387a683          	lw	a3,824(a5) # 1080338 <g_console_uart>
80009588:	4722                	lw	a4,8(sp)
8000958a:	47f2                	lw	a5,28(sp)
8000958c:	97ba                	add	a5,a5,a4
8000958e:	0007c783          	lbu	a5,0(a5)
80009592:	85be                	mv	a1,a5
80009594:	8536                	mv	a0,a3
80009596:	b76fc0ef          	jal	8000590c <uart_send_byte>
8000959a:	87aa                	mv	a5,a0
8000959c:	f3f5                	bnez	a5,80009580 <.L16>
    for (count = 0; count < size; count++) {
8000959e:	47f2                	lw	a5,28(sp)
800095a0:	0785                	add	a5,a5,1
800095a2:	ce3e                	sw	a5,28(sp)

800095a4 <.L13>:
800095a4:	4772                	lw	a4,28(sp)
800095a6:	4792                	lw	a5,4(sp)
800095a8:	faf768e3          	bltu	a4,a5,80009558 <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
800095ac:	0001                	nop

800095ae <.L18>:
800095ae:	010807b7          	lui	a5,0x1080
800095b2:	3387a783          	lw	a5,824(a5) # 1080338 <g_console_uart>
800095b6:	853e                	mv	a0,a5
800095b8:	7fd000ef          	jal	8000a5b4 <uart_flush>
800095bc:	87aa                	mv	a5,a0
800095be:	fbe5                	bnez	a5,800095ae <.L18>
    }
    return count;
800095c0:	47f2                	lw	a5,28(sp)

}
800095c2:	853e                	mv	a0,a5
800095c4:	50b2                	lw	ra,44(sp)
800095c6:	6145                	add	sp,sp,48
800095c8:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

800095ca <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
800095ca:	1141                	add	sp,sp,-16
800095cc:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
800095ce:	4781                	li	a5,0
}
800095d0:	853e                	mv	a0,a5
800095d2:	0141                	add	sp,sp,16
800095d4:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

800095d6 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
800095d6:	1141                	add	sp,sp,-16
800095d8:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
800095da:	4785                	li	a5,1
}
800095dc:	853e                	mv	a0,a5
800095de:	0141                	add	sp,sp,16
800095e0:	8082                	ret

Disassembly of section .text.core_local_mem_to_sys_address:

800095e2 <core_local_mem_to_sys_address>:
#define HPM_CORE0 (0U)
#define HPM_CORE1 (1U)

/* map core local memory(DLM/ILM) to system address */
static inline uint32_t core_local_mem_to_sys_address(uint8_t core_id, uint32_t addr)
{
800095e2:	1101                	add	sp,sp,-32
800095e4:	87aa                	mv	a5,a0
800095e6:	c42e                	sw	a1,8(sp)
800095e8:	00f107a3          	sb	a5,15(sp)
    uint32_t sys_addr;
    if (ADDRESS_IN_ILM(addr)) {
800095ec:	4722                	lw	a4,8(sp)
800095ee:	000407b7          	lui	a5,0x40
800095f2:	00f77863          	bgeu	a4,a5,80009602 <.L2>
        sys_addr = ILM_TO_SYSTEM(addr);
800095f6:	4722                	lw	a4,8(sp)
800095f8:	010007b7          	lui	a5,0x1000
800095fc:	97ba                	add	a5,a5,a4
800095fe:	ce3e                	sw	a5,28(sp)
80009600:	a01d                	j	80009626 <.L3>

80009602 <.L2>:
    } else if (ADDRESS_IN_DLM(addr)) {
80009602:	4722                	lw	a4,8(sp)
80009604:	000807b7          	lui	a5,0x80
80009608:	00f76d63          	bltu	a4,a5,80009622 <.L4>
8000960c:	4722                	lw	a4,8(sp)
8000960e:	000c07b7          	lui	a5,0xc0
80009612:	00f77863          	bgeu	a4,a5,80009622 <.L4>
        sys_addr = DLM_TO_SYSTEM(addr);
80009616:	4722                	lw	a4,8(sp)
80009618:	00fc07b7          	lui	a5,0xfc0
8000961c:	97ba                	add	a5,a5,a4
8000961e:	ce3e                	sw	a5,28(sp)
80009620:	a019                	j	80009626 <.L3>

80009622 <.L4>:
    } else {
        return addr;
80009622:	47a2                	lw	a5,8(sp)
80009624:	a821                	j	8000963c <.L5>

80009626 <.L3>:
    }
    if (core_id == HPM_CORE1) {
80009626:	00f14703          	lbu	a4,15(sp)
8000962a:	4785                	li	a5,1
8000962c:	00f71763          	bne	a4,a5,8000963a <.L6>
        sys_addr += CORE1_ILM_SYSTEM_BASE - CORE0_ILM_SYSTEM_BASE;
80009630:	4772                	lw	a4,28(sp)
80009632:	001807b7          	lui	a5,0x180
80009636:	97ba                	add	a5,a5,a4
80009638:	ce3e                	sw	a5,28(sp)

8000963a <.L6>:
    }

    return sys_addr;
8000963a:	47f2                	lw	a5,28(sp)

8000963c <.L5>:
}
8000963c:	853e                	mv	a0,a5
8000963e:	6105                	add	sp,sp,32
80009640:	8082                	ret

Disassembly of section .text.usb_get_interrupts:

80009642 <usb_get_interrupts>:
{
80009642:	1141                	add	sp,sp,-16
80009644:	c62a                	sw	a0,12(sp)
    return ptr->USBINTR;
80009646:	47b2                	lw	a5,12(sp)
80009648:	1487a783          	lw	a5,328(a5) # 180148 <__DLM_segment_end__+0xc0148>
}
8000964c:	853e                	mv	a0,a5
8000964e:	0141                	add	sp,sp,16
80009650:	8082                	ret

Disassembly of section .text.usb_enable_interrupts:

80009652 <usb_enable_interrupts>:
{
80009652:	1141                	add	sp,sp,-16
80009654:	c62a                	sw	a0,12(sp)
80009656:	c42e                	sw	a1,8(sp)
    ptr->USBINTR |= mask;
80009658:	47b2                	lw	a5,12(sp)
8000965a:	1487a703          	lw	a4,328(a5)
8000965e:	47a2                	lw	a5,8(sp)
80009660:	8f5d                	or	a4,a4,a5
80009662:	47b2                	lw	a5,12(sp)
80009664:	14e7a423          	sw	a4,328(a5)
}
80009668:	0001                	nop
8000966a:	0141                	add	sp,sp,16
8000966c:	8082                	ret

Disassembly of section .text.usb_get_status_flags:

8000966e <usb_get_status_flags>:
{
8000966e:	1141                	add	sp,sp,-16
80009670:	c62a                	sw	a0,12(sp)
    return ptr->USBSTS;
80009672:	47b2                	lw	a5,12(sp)
80009674:	1447a783          	lw	a5,324(a5)
}
80009678:	853e                	mv	a0,a5
8000967a:	0141                	add	sp,sp,16
8000967c:	8082                	ret

Disassembly of section .text.usb_clear_status_flags:

8000967e <usb_clear_status_flags>:
{
8000967e:	1141                	add	sp,sp,-16
80009680:	c62a                	sw	a0,12(sp)
80009682:	c42e                	sw	a1,8(sp)
    ptr->USBSTS = mask;
80009684:	47b2                	lw	a5,12(sp)
80009686:	4722                	lw	a4,8(sp)
80009688:	14e7a223          	sw	a4,324(a5)
}
8000968c:	0001                	nop
8000968e:	0141                	add	sp,sp,16
80009690:	8082                	ret

Disassembly of section .text.usb_get_suspend_status:

80009692 <usb_get_suspend_status>:
{
80009692:	1141                	add	sp,sp,-16
80009694:	c62a                	sw	a0,12(sp)
    return USB_PORTSC1_SUSP_GET(ptr->PORTSC1);
80009696:	47b2                	lw	a5,12(sp)
80009698:	1847a783          	lw	a5,388(a5)
8000969c:	839d                	srl	a5,a5,0x7
8000969e:	0ff7f793          	zext.b	a5,a5
800096a2:	8b85                	and	a5,a5,1
800096a4:	0ff7f793          	zext.b	a5,a5
}
800096a8:	853e                	mv	a0,a5
800096aa:	0141                	add	sp,sp,16
800096ac:	8082                	ret

Disassembly of section .text.usb_dcd_get_edpt_setup_status:

800096ae <usb_dcd_get_edpt_setup_status>:
{
800096ae:	1141                	add	sp,sp,-16
800096b0:	c62a                	sw	a0,12(sp)
    return ptr->ENDPTSETUPSTAT;
800096b2:	47b2                	lw	a5,12(sp)
800096b4:	1ac7a783          	lw	a5,428(a5)
}
800096b8:	853e                	mv	a0,a5
800096ba:	0141                	add	sp,sp,16
800096bc:	8082                	ret

Disassembly of section .text.usb_dcd_clear_edpt_setup_status:

800096be <usb_dcd_clear_edpt_setup_status>:
{
800096be:	1141                	add	sp,sp,-16
800096c0:	c62a                	sw	a0,12(sp)
800096c2:	c42e                	sw	a1,8(sp)
    ptr->ENDPTSETUPSTAT = mask;
800096c4:	47b2                	lw	a5,12(sp)
800096c6:	4722                	lw	a4,8(sp)
800096c8:	1ae7a623          	sw	a4,428(a5)
}
800096cc:	0001                	nop
800096ce:	0141                	add	sp,sp,16
800096d0:	8082                	ret

Disassembly of section .text.usb_dcd_set_edpt_list_addr:

800096d2 <usb_dcd_set_edpt_list_addr>:
{
800096d2:	1141                	add	sp,sp,-16
800096d4:	c62a                	sw	a0,12(sp)
800096d6:	c42e                	sw	a1,8(sp)
    ptr->ENDPTLISTADDR = addr & USB_ENDPTLISTADDR_EPBASE_MASK;
800096d8:	47a2                	lw	a5,8(sp)
800096da:	8007f713          	and	a4,a5,-2048
800096de:	47b2                	lw	a5,12(sp)
800096e0:	14e7ac23          	sw	a4,344(a5)
}
800096e4:	0001                	nop
800096e6:	0141                	add	sp,sp,16
800096e8:	8082                	ret

Disassembly of section .text.usb_dcd_get_edpt_complete_status:

800096ea <usb_dcd_get_edpt_complete_status>:
 *
 * @param[in] ptr A USB peripheral base address
 * @retval The complete status od endpoint
 */
static inline uint32_t usb_dcd_get_edpt_complete_status(USB_Type *ptr)
{
800096ea:	1141                	add	sp,sp,-16
800096ec:	c62a                	sw	a0,12(sp)
    return ptr->ENDPTCOMPLETE;
800096ee:	47b2                	lw	a5,12(sp)
800096f0:	1bc7a783          	lw	a5,444(a5)
}
800096f4:	853e                	mv	a0,a5
800096f6:	0141                	add	sp,sp,16
800096f8:	8082                	ret

Disassembly of section .text.usb_dcd_clear_edpt_complete_status:

800096fa <usb_dcd_clear_edpt_complete_status>:
 *
 * @param[in] ptr A USB peripheral base address
 * @param[in] mask A mask of the specified endpoints
 */
static inline void usb_dcd_clear_edpt_complete_status(USB_Type *ptr, uint32_t mask)
{
800096fa:	1141                	add	sp,sp,-16
800096fc:	c62a                	sw	a0,12(sp)
800096fe:	c42e                	sw	a1,8(sp)
    ptr->ENDPTCOMPLETE = mask;
80009700:	47b2                	lw	a5,12(sp)
80009702:	4722                	lw	a4,8(sp)
80009704:	1ae7ae23          	sw	a4,444(a5)
}
80009708:	0001                	nop
8000970a:	0141                	add	sp,sp,16
8000970c:	8082                	ret

Disassembly of section .text.usb_device_qhd_get:

8000970e <usb_device_qhd_get>:
{
8000970e:	1141                	add	sp,sp,-16
80009710:	c62a                	sw	a0,12(sp)
80009712:	87ae                	mv	a5,a1
80009714:	00f105a3          	sb	a5,11(sp)
    return &handle->dcd_data->qhd[ep_idx];
80009718:	47b2                	lw	a5,12(sp)
8000971a:	43d8                	lw	a4,4(a5)
8000971c:	00b14783          	lbu	a5,11(sp)
80009720:	079a                	sll	a5,a5,0x6
80009722:	97ba                	add	a5,a5,a4
}
80009724:	853e                	mv	a0,a5
80009726:	0141                	add	sp,sp,16
80009728:	8082                	ret

Disassembly of section .text.usb_device_init:

8000972a <usb_device_init>:
{
8000972a:	1101                	add	sp,sp,-32
8000972c:	ce06                	sw	ra,28(sp)
8000972e:	cc22                	sw	s0,24(sp)
80009730:	c62a                	sw	a0,12(sp)
80009732:	c42e                	sw	a1,8(sp)
    if (handle->dcd_data == NULL) {
80009734:	47b2                	lw	a5,12(sp)
80009736:	43dc                	lw	a5,4(a5)
80009738:	e399                	bnez	a5,8000973e <.L42>
        return false;
8000973a:	4781                	li	a5,0
8000973c:	a8b9                	j	8000979a <.L43>

8000973e <.L42>:
    memset(handle->dcd_data, 0, sizeof(dcd_data_t));
8000973e:	47b2                	lw	a5,12(sp)
80009740:	43d8                	lw	a4,4(a5)
80009742:	6785                	lui	a5,0x1
80009744:	40078613          	add	a2,a5,1024 # 1400 <.L20+0xe>
80009748:	4581                	li	a1,0
8000974a:	853a                	mv	a0,a4
8000974c:	746030ef          	jal	8000ce92 <memset>
    usb_dcd_init(handle->regs);
80009750:	47b2                	lw	a5,12(sp)
80009752:	439c                	lw	a5,0(a5)
80009754:	853e                	mv	a0,a5
80009756:	096010ef          	jal	8000a7ec <usb_dcd_init>
    usb_dcd_set_edpt_list_addr(handle->regs, core_local_mem_to_sys_address(0,  (uint32_t)handle->dcd_data->qhd));
8000975a:	47b2                	lw	a5,12(sp)
8000975c:	4380                	lw	s0,0(a5)
8000975e:	47b2                	lw	a5,12(sp)
80009760:	43dc                	lw	a5,4(a5)
80009762:	85be                	mv	a1,a5
80009764:	4501                	li	a0,0
80009766:	3db5                	jal	800095e2 <core_local_mem_to_sys_address>
80009768:	87aa                	mv	a5,a0
8000976a:	85be                	mv	a1,a5
8000976c:	8522                	mv	a0,s0
8000976e:	3795                	jal	800096d2 <usb_dcd_set_edpt_list_addr>
    usb_clear_status_flags(handle->regs, usb_get_status_flags(handle->regs));
80009770:	47b2                	lw	a5,12(sp)
80009772:	4380                	lw	s0,0(a5)
80009774:	47b2                	lw	a5,12(sp)
80009776:	439c                	lw	a5,0(a5)
80009778:	853e                	mv	a0,a5
8000977a:	3dd5                	jal	8000966e <usb_get_status_flags>
8000977c:	87aa                	mv	a5,a0
8000977e:	85be                	mv	a1,a5
80009780:	8522                	mv	a0,s0
80009782:	3df5                	jal	8000967e <usb_clear_status_flags>
    usb_enable_interrupts(handle->regs, int_mask);
80009784:	47b2                	lw	a5,12(sp)
80009786:	439c                	lw	a5,0(a5)
80009788:	45a2                	lw	a1,8(sp)
8000978a:	853e                	mv	a0,a5
8000978c:	35d9                	jal	80009652 <usb_enable_interrupts>
    usb_dcd_connect(handle->regs);
8000978e:	47b2                	lw	a5,12(sp)
80009790:	439c                	lw	a5,0(a5)
80009792:	853e                	mv	a0,a5
80009794:	9c6fc0ef          	jal	8000595a <usb_dcd_connect>
    return true;
80009798:	4785                	li	a5,1

8000979a <.L43>:
}
8000979a:	853e                	mv	a0,a5
8000979c:	40f2                	lw	ra,28(sp)
8000979e:	4462                	lw	s0,24(sp)
800097a0:	6105                	add	sp,sp,32
800097a2:	8082                	ret

Disassembly of section .text.usb_device_clear_status_flags:

800097a4 <usb_device_clear_status_flags>:
{
800097a4:	1101                	add	sp,sp,-32
800097a6:	ce06                	sw	ra,28(sp)
800097a8:	c62a                	sw	a0,12(sp)
800097aa:	c42e                	sw	a1,8(sp)
    usb_clear_status_flags(handle->regs, mask);
800097ac:	47b2                	lw	a5,12(sp)
800097ae:	439c                	lw	a5,0(a5)
800097b0:	45a2                	lw	a1,8(sp)
800097b2:	853e                	mv	a0,a5
800097b4:	35e9                	jal	8000967e <usb_clear_status_flags>
}
800097b6:	0001                	nop
800097b8:	40f2                	lw	ra,28(sp)
800097ba:	6105                	add	sp,sp,32
800097bc:	8082                	ret

Disassembly of section .text.usb_device_clear_edpt_complete_status:

800097be <usb_device_clear_edpt_complete_status>:
{
800097be:	1101                	add	sp,sp,-32
800097c0:	ce06                	sw	ra,28(sp)
800097c2:	c62a                	sw	a0,12(sp)
800097c4:	c42e                	sw	a1,8(sp)
    usb_dcd_clear_edpt_complete_status(handle->regs, mask);
800097c6:	47b2                	lw	a5,12(sp)
800097c8:	439c                	lw	a5,0(a5)
800097ca:	45a2                	lw	a1,8(sp)
800097cc:	853e                	mv	a0,a5
800097ce:	3735                	jal	800096fa <usb_dcd_clear_edpt_complete_status>
}
800097d0:	0001                	nop
800097d2:	40f2                	lw	ra,28(sp)
800097d4:	6105                	add	sp,sp,32
800097d6:	8082                	ret

Disassembly of section .text.usb_device_clear_setup_status:

800097d8 <usb_device_clear_setup_status>:
{
800097d8:	1101                	add	sp,sp,-32
800097da:	ce06                	sw	ra,28(sp)
800097dc:	c62a                	sw	a0,12(sp)
800097de:	c42e                	sw	a1,8(sp)
    usb_dcd_clear_edpt_setup_status(handle->regs, mask);
800097e0:	47b2                	lw	a5,12(sp)
800097e2:	439c                	lw	a5,0(a5)
800097e4:	45a2                	lw	a1,8(sp)
800097e6:	853e                	mv	a0,a5
800097e8:	3dd9                	jal	800096be <usb_dcd_clear_edpt_setup_status>
}
800097ea:	0001                	nop
800097ec:	40f2                	lw	ra,28(sp)
800097ee:	6105                	add	sp,sp,32
800097f0:	8082                	ret

Disassembly of section .text.usb_device_edpt_stall:

800097f2 <usb_device_edpt_stall>:
{
800097f2:	1101                	add	sp,sp,-32
800097f4:	ce06                	sw	ra,28(sp)
800097f6:	c62a                	sw	a0,12(sp)
800097f8:	87ae                	mv	a5,a1
800097fa:	00f105a3          	sb	a5,11(sp)
    usb_dcd_edpt_stall(handle->regs, ep_addr);
800097fe:	47b2                	lw	a5,12(sp)
80009800:	439c                	lw	a5,0(a5)
80009802:	00b14703          	lbu	a4,11(sp)
80009806:	85ba                	mv	a1,a4
80009808:	853e                	mv	a0,a5
8000980a:	9ecfc0ef          	jal	800059f6 <usb_dcd_edpt_stall>
}
8000980e:	0001                	nop
80009810:	40f2                	lw	ra,28(sp)
80009812:	6105                	add	sp,sp,32
80009814:	8082                	ret

Disassembly of section .text.usb_device_edpt_clear_stall:

80009816 <usb_device_edpt_clear_stall>:
{
80009816:	1101                	add	sp,sp,-32
80009818:	ce06                	sw	ra,28(sp)
8000981a:	c62a                	sw	a0,12(sp)
8000981c:	87ae                	mv	a5,a1
8000981e:	00f105a3          	sb	a5,11(sp)
    usb_dcd_edpt_clear_stall(handle->regs, ep_addr);
80009822:	47b2                	lw	a5,12(sp)
80009824:	439c                	lw	a5,0(a5)
80009826:	00b14703          	lbu	a4,11(sp)
8000982a:	85ba                	mv	a1,a4
8000982c:	853e                	mv	a0,a5
8000982e:	a1afc0ef          	jal	80005a48 <usb_dcd_edpt_clear_stall>
}
80009832:	0001                	nop
80009834:	40f2                	lw	ra,28(sp)
80009836:	6105                	add	sp,sp,32
80009838:	8082                	ret

Disassembly of section .text.usb_device_edpt_close:

8000983a <usb_device_edpt_close>:

void usb_device_edpt_close(usb_device_handle_t *handle, uint8_t ep_addr)
{
8000983a:	1101                	add	sp,sp,-32
8000983c:	ce06                	sw	ra,28(sp)
8000983e:	c62a                	sw	a0,12(sp)
80009840:	87ae                	mv	a5,a1
80009842:	00f105a3          	sb	a5,11(sp)
    usb_dcd_edpt_close(handle->regs, ep_addr);
80009846:	47b2                	lw	a5,12(sp)
80009848:	439c                	lw	a5,0(a5)
8000984a:	00b14703          	lbu	a4,11(sp)
8000984e:	85ba                	mv	a1,a4
80009850:	853e                	mv	a0,a5
80009852:	ac6fc0ef          	jal	80005b18 <usb_dcd_edpt_close>
}
80009856:	0001                	nop
80009858:	40f2                	lw	ra,28(sp)
8000985a:	6105                	add	sp,sp,32
8000985c:	8082                	ret

Disassembly of section .text.can_reset:

8000985e <can_reset>:
{
8000985e:	1141                	add	sp,sp,-16
80009860:	c62a                	sw	a0,12(sp)
80009862:	87ae                	mv	a5,a1
80009864:	00f105a3          	sb	a5,11(sp)
    if (enable) {
80009868:	00b14783          	lbu	a5,11(sp)
8000986c:	cb91                	beqz	a5,80009880 <.L2>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_RESET_MASK;
8000986e:	47b2                	lw	a5,12(sp)
80009870:	0a07a783          	lw	a5,160(a5)
80009874:	0807e713          	or	a4,a5,128
80009878:	47b2                	lw	a5,12(sp)
8000987a:	0ae7a023          	sw	a4,160(a5)
}
8000987e:	a809                	j	80009890 <.L4>

80009880 <.L2>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_RESET_MASK;
80009880:	47b2                	lw	a5,12(sp)
80009882:	0a07a783          	lw	a5,160(a5)
80009886:	f7f7f713          	and	a4,a5,-129
8000988a:	47b2                	lw	a5,12(sp)
8000988c:	0ae7a023          	sw	a4,160(a5)

80009890 <.L4>:
}
80009890:	0001                	nop
80009892:	0141                	add	sp,sp,16
80009894:	8082                	ret

Disassembly of section .text.can_disable_ptb_retransmission:

80009896 <can_disable_ptb_retransmission>:
{
80009896:	1141                	add	sp,sp,-16
80009898:	c62a                	sw	a0,12(sp)
8000989a:	87ae                	mv	a5,a1
8000989c:	00f105a3          	sb	a5,11(sp)
    if (enable) {
800098a0:	00b14783          	lbu	a5,11(sp)
800098a4:	cb91                	beqz	a5,800098b8 <.L11>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TPSS_MASK;
800098a6:	47b2                	lw	a5,12(sp)
800098a8:	0a07a783          	lw	a5,160(a5)
800098ac:	0107e713          	or	a4,a5,16
800098b0:	47b2                	lw	a5,12(sp)
800098b2:	0ae7a023          	sw	a4,160(a5)
}
800098b6:	a809                	j	800098c8 <.L13>

800098b8 <.L11>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TPSS_MASK;
800098b8:	47b2                	lw	a5,12(sp)
800098ba:	0a07a783          	lw	a5,160(a5)
800098be:	fef7f713          	and	a4,a5,-17
800098c2:	47b2                	lw	a5,12(sp)
800098c4:	0ae7a023          	sw	a4,160(a5)

800098c8 <.L13>:
}
800098c8:	0001                	nop
800098ca:	0141                	add	sp,sp,16
800098cc:	8082                	ret

Disassembly of section .text.can_disable_stb_retransmission:

800098ce <can_disable_stb_retransmission>:
{
800098ce:	1141                	add	sp,sp,-16
800098d0:	c62a                	sw	a0,12(sp)
800098d2:	87ae                	mv	a5,a1
800098d4:	00f105a3          	sb	a5,11(sp)
    if (enable) {
800098d8:	00b14783          	lbu	a5,11(sp)
800098dc:	cb91                	beqz	a5,800098f0 <.L15>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TSSS_MASK;
800098de:	47b2                	lw	a5,12(sp)
800098e0:	0a07a783          	lw	a5,160(a5)
800098e4:	0087e713          	or	a4,a5,8
800098e8:	47b2                	lw	a5,12(sp)
800098ea:	0ae7a023          	sw	a4,160(a5)
}
800098ee:	a809                	j	80009900 <.L17>

800098f0 <.L15>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TSSS_MASK;
800098f0:	47b2                	lw	a5,12(sp)
800098f2:	0a07a783          	lw	a5,160(a5)
800098f6:	ff77f713          	and	a4,a5,-9
800098fa:	47b2                	lw	a5,12(sp)
800098fc:	0ae7a023          	sw	a4,160(a5)

80009900 <.L17>:
}
80009900:	0001                	nop
80009902:	0141                	add	sp,sp,16
80009904:	8082                	ret

Disassembly of section .text.can_disable_tx_rx_irq:

80009906 <can_disable_tx_rx_irq>:
{
80009906:	1141                	add	sp,sp,-16
80009908:	c62a                	sw	a0,12(sp)
8000990a:	87ae                	mv	a5,a1
8000990c:	00f105a3          	sb	a5,11(sp)
    base->RTIE &= ~mask;
80009910:	47b2                	lw	a5,12(sp)
80009912:	0a47c783          	lbu	a5,164(a5)
80009916:	0ff7f793          	zext.b	a5,a5
8000991a:	01879713          	sll	a4,a5,0x18
8000991e:	8761                	sra	a4,a4,0x18
80009920:	00b10783          	lb	a5,11(sp)
80009924:	fff7c793          	not	a5,a5
80009928:	07e2                	sll	a5,a5,0x18
8000992a:	87e1                	sra	a5,a5,0x18
8000992c:	8ff9                	and	a5,a5,a4
8000992e:	07e2                	sll	a5,a5,0x18
80009930:	87e1                	sra	a5,a5,0x18
80009932:	0ff7f713          	zext.b	a4,a5
80009936:	47b2                	lw	a5,12(sp)
80009938:	0ae78223          	sb	a4,164(a5)
}
8000993c:	0001                	nop
8000993e:	0141                	add	sp,sp,16
80009940:	8082                	ret

Disassembly of section .text.can_disable_error_irq:

80009942 <can_disable_error_irq>:
{
80009942:	1141                	add	sp,sp,-16
80009944:	c62a                	sw	a0,12(sp)
80009946:	87ae                	mv	a5,a1
80009948:	00f105a3          	sb	a5,11(sp)
    base->ERRINT &= ~mask;
8000994c:	47b2                	lw	a5,12(sp)
8000994e:	0a67c783          	lbu	a5,166(a5)
80009952:	0ff7f793          	zext.b	a5,a5
80009956:	01879713          	sll	a4,a5,0x18
8000995a:	8761                	sra	a4,a4,0x18
8000995c:	00b10783          	lb	a5,11(sp)
80009960:	fff7c793          	not	a5,a5
80009964:	07e2                	sll	a5,a5,0x18
80009966:	87e1                	sra	a5,a5,0x18
80009968:	8ff9                	and	a5,a5,a4
8000996a:	07e2                	sll	a5,a5,0x18
8000996c:	87e1                	sra	a5,a5,0x18
8000996e:	0ff7f713          	zext.b	a4,a5
80009972:	47b2                	lw	a5,12(sp)
80009974:	0ae78323          	sb	a4,166(a5)
}
80009978:	0001                	nop
8000997a:	0141                	add	sp,sp,16
8000997c:	8082                	ret

Disassembly of section .text.can_set_transmitter_delay_compensation:

8000997e <can_set_transmitter_delay_compensation>:
{
8000997e:	1141                	add	sp,sp,-16
80009980:	c62a                	sw	a0,12(sp)
80009982:	87ae                	mv	a5,a1
80009984:	8732                	mv	a4,a2
80009986:	00f105a3          	sb	a5,11(sp)
8000998a:	87ba                	mv	a5,a4
8000998c:	00f10523          	sb	a5,10(sp)
    base->TDC = CAN_TDC_TDCEN_SET((uint8_t) enable);
80009990:	00a14783          	lbu	a5,10(sp)
80009994:	079e                	sll	a5,a5,0x7
80009996:	0ff7f713          	zext.b	a4,a5
8000999a:	47b2                	lw	a5,12(sp)
8000999c:	0ae788a3          	sb	a4,177(a5)
}
800099a0:	0001                	nop
800099a2:	0141                	add	sp,sp,16
800099a4:	8082                	ret

Disassembly of section .text.can_set_fast_speed_timing:

800099a6 <can_set_fast_speed_timing>:
 * @brief Configure the Fast Speed Bit timing using low-level interface
 * @param [in] base CAN base address
 * @param [in] param CAN bit timing parameter
 */
static inline void can_set_fast_speed_timing(CAN_Type *base, const can_bit_timing_param_t *param)
{
800099a6:	1141                	add	sp,sp,-16
800099a8:	c62a                	sw	a0,12(sp)
800099aa:	c42e                	sw	a1,8(sp)
    base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(param->prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(param->num_seg1 - 2U) |
800099ac:	47a2                	lw	a5,8(sp)
800099ae:	0007d783          	lhu	a5,0(a5)
800099b2:	17fd                	add	a5,a5,-1
800099b4:	01879713          	sll	a4,a5,0x18
800099b8:	47a2                	lw	a5,8(sp)
800099ba:	0027d783          	lhu	a5,2(a5)
800099be:	17f9                	add	a5,a5,-2
800099c0:	8bbd                	and	a5,a5,15
800099c2:	8f5d                	or	a4,a4,a5
                                CAN_F_PRESC_F_SEG_2_SET(param->num_seg2 - 1U) | CAN_F_PRESC_F_SJW_SET(param->num_sjw - 1U);
800099c4:	47a2                	lw	a5,8(sp)
800099c6:	0047d783          	lhu	a5,4(a5)
800099ca:	17fd                	add	a5,a5,-1
800099cc:	00879693          	sll	a3,a5,0x8
800099d0:	6785                	lui	a5,0x1
800099d2:	f0078793          	add	a5,a5,-256 # f00 <.L27+0xc6>
800099d6:	8ff5                	and	a5,a5,a3
    base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(param->prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(param->num_seg1 - 2U) |
800099d8:	8f5d                	or	a4,a4,a5
                                CAN_F_PRESC_F_SEG_2_SET(param->num_seg2 - 1U) | CAN_F_PRESC_F_SJW_SET(param->num_sjw - 1U);
800099da:	47a2                	lw	a5,8(sp)
800099dc:	0067d783          	lhu	a5,6(a5)
800099e0:	17fd                	add	a5,a5,-1
800099e2:	01079693          	sll	a3,a5,0x10
800099e6:	000f07b7          	lui	a5,0xf0
800099ea:	8ff5                	and	a5,a5,a3
800099ec:	8f5d                	or	a4,a4,a5
    base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(param->prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(param->num_seg1 - 2U) |
800099ee:	47b2                	lw	a5,12(sp)
800099f0:	0ae7a623          	sw	a4,172(a5) # f00ac <__DLM_segment_end__+0x300ac>
}
800099f4:	0001                	nop
800099f6:	0141                	add	sp,sp,16
800099f8:	8082                	ret

Disassembly of section .text.find_optimal_prescaler:

800099fa <find_optimal_prescaler>:
{
800099fa:	1101                	add	sp,sp,-32
800099fc:	c62a                	sw	a0,12(sp)
800099fe:	c42e                	sw	a1,8(sp)
80009a00:	c232                	sw	a2,4(sp)
80009a02:	c036                	sw	a3,0(sp)
    bool has_found = false;
80009a04:	00010fa3          	sb	zero,31(sp)
    uint32_t prescaler = start_prescaler;
80009a08:	47a2                	lw	a5,8(sp)
80009a0a:	cc3e                	sw	a5,24(sp)
    while (!has_found) {
80009a0c:	a899                	j	80009a62 <.L39>

80009a0e <.L45>:
        if ((num_tq_mul_prescaler / prescaler > max_tq) || (num_tq_mul_prescaler % prescaler != 0)) {
80009a0e:	4732                	lw	a4,12(sp)
80009a10:	47e2                	lw	a5,24(sp)
80009a12:	02f757b3          	divu	a5,a4,a5
80009a16:	4712                	lw	a4,4(sp)
80009a18:	00f76763          	bltu	a4,a5,80009a26 <.L40>
80009a1c:	4732                	lw	a4,12(sp)
80009a1e:	47e2                	lw	a5,24(sp)
80009a20:	02f777b3          	remu	a5,a4,a5
80009a24:	c789                	beqz	a5,80009a2e <.L41>

80009a26 <.L40>:
            ++prescaler;
80009a26:	47e2                	lw	a5,24(sp)
80009a28:	0785                	add	a5,a5,1
80009a2a:	cc3e                	sw	a5,24(sp)
            continue;
80009a2c:	a81d                	j	80009a62 <.L39>

80009a2e <.L41>:
            uint32_t tq = num_tq_mul_prescaler / prescaler;
80009a2e:	4732                	lw	a4,12(sp)
80009a30:	47e2                	lw	a5,24(sp)
80009a32:	02f757b3          	divu	a5,a4,a5
80009a36:	ca3e                	sw	a5,20(sp)
            if (tq * prescaler == num_tq_mul_prescaler) {
80009a38:	4752                	lw	a4,20(sp)
80009a3a:	47e2                	lw	a5,24(sp)
80009a3c:	02f707b3          	mul	a5,a4,a5
80009a40:	4732                	lw	a4,12(sp)
80009a42:	00f71663          	bne	a4,a5,80009a4e <.L42>
                has_found = true;
80009a46:	4785                	li	a5,1
80009a48:	00f10fa3          	sb	a5,31(sp)
                break;
80009a4c:	a015                	j	80009a70 <.L43>

80009a4e <.L42>:
            } else if (tq < min_tq) {
80009a4e:	4752                	lw	a4,20(sp)
80009a50:	4782                	lw	a5,0(sp)
80009a52:	00f77563          	bgeu	a4,a5,80009a5c <.L44>
                has_found = false;
80009a56:	00010fa3          	sb	zero,31(sp)
                break;
80009a5a:	a819                	j	80009a70 <.L43>

80009a5c <.L44>:
                ++prescaler;
80009a5c:	47e2                	lw	a5,24(sp)
80009a5e:	0785                	add	a5,a5,1
80009a60:	cc3e                	sw	a5,24(sp)

80009a62 <.L39>:
    while (!has_found) {
80009a62:	01f14783          	lbu	a5,31(sp)
80009a66:	0017c793          	xor	a5,a5,1
80009a6a:	0ff7f793          	zext.b	a5,a5
80009a6e:	f3c5                	bnez	a5,80009a0e <.L45>

80009a70 <.L43>:
    return has_found ? prescaler : 0U;
80009a70:	01f14783          	lbu	a5,31(sp)
80009a74:	c399                	beqz	a5,80009a7a <.L46>
80009a76:	47e2                	lw	a5,24(sp)
80009a78:	a011                	j	80009a7c <.L48>

80009a7a <.L46>:
80009a7a:	4781                	li	a5,0

80009a7c <.L48>:
}
80009a7c:	853e                	mv	a0,a5
80009a7e:	6105                	add	sp,sp,32
80009a80:	8082                	ret

Disassembly of section .text.can_calculate_bit_timing:

80009a82 <can_calculate_bit_timing>:
{
80009a82:	711d                	add	sp,sp,-96
80009a84:	ce86                	sw	ra,92(sp)
80009a86:	ce2a                	sw	a0,28(sp)
80009a88:	ca32                	sw	a2,20(sp)
80009a8a:	c63e                	sw	a5,12(sp)
80009a8c:	87ae                	mv	a5,a1
80009a8e:	00f10da3          	sb	a5,27(sp)
80009a92:	87b6                	mv	a5,a3
80009a94:	00f11c23          	sh	a5,24(sp)
80009a98:	87ba                	mv	a5,a4
80009a9a:	00f11923          	sh	a5,18(sp)
    hpm_stat_t status = status_invalid_argument;
80009a9e:	4789                	li	a5,2
80009aa0:	c6be                	sw	a5,76(sp)

80009aa2 <.LBB3>:
        if ((option > can_bit_timing_canfd_data) || (baudrate == 0U) ||
80009aa2:	01b14703          	lbu	a4,27(sp)
80009aa6:	4789                	li	a5,2
80009aa8:	18e7e963          	bltu	a5,a4,80009c3a <.L50>
80009aac:	47d2                	lw	a5,20(sp)
80009aae:	18078663          	beqz	a5,80009c3a <.L50>
            (src_clk_freq / baudrate < MIN_TQ_MUL_PRESCALE) || (timing_param == NULL)) {
80009ab2:	4772                	lw	a4,28(sp)
80009ab4:	47d2                	lw	a5,20(sp)
80009ab6:	02f75733          	divu	a4,a4,a5
        if ((option > can_bit_timing_canfd_data) || (baudrate == 0U) ||
80009aba:	47a5                	li	a5,9
80009abc:	16e7ff63          	bgeu	a5,a4,80009c3a <.L50>
            (src_clk_freq / baudrate < MIN_TQ_MUL_PRESCALE) || (timing_param == NULL)) {
80009ac0:	47b2                	lw	a5,12(sp)
80009ac2:	16078c63          	beqz	a5,80009c3a <.L50>
        const can_bit_timing_table_t *tbl = &s_can_bit_timing_tbl[(uint8_t) option];
80009ac6:	01b14703          	lbu	a4,27(sp)
80009aca:	87ba                	mv	a5,a4
80009acc:	078e                	sll	a5,a5,0x3
80009ace:	97ba                	add	a5,a5,a4
80009ad0:	54420713          	add	a4,tp,1348 # 544 <slcan_parse_ascii+0x12>
80009ad4:	97ba                	add	a5,a5,a4
80009ad6:	da3e                	sw	a5,52(sp)
        if (src_clk_freq / baudrate < tbl->tq_min) {
80009ad8:	4772                	lw	a4,28(sp)
80009ada:	47d2                	lw	a5,20(sp)
80009adc:	02f757b3          	divu	a5,a4,a5
80009ae0:	5752                	lw	a4,52(sp)
80009ae2:	00074703          	lbu	a4,0(a4)
80009ae6:	14e7e963          	bltu	a5,a4,80009c38 <.L63>
        uint32_t num_tq_mul_prescaler = src_clk_freq / baudrate;
80009aea:	4772                	lw	a4,28(sp)
80009aec:	47d2                	lw	a5,20(sp)
80009aee:	02f757b3          	divu	a5,a4,a5
80009af2:	d83e                	sw	a5,48(sp)
        uint32_t start_prescaler = 1U;
80009af4:	4785                	li	a5,1
80009af6:	c4be                	sw	a5,72(sp)
        bool has_found = false;
80009af8:	02010fa3          	sb	zero,63(sp)
        while (!has_found) {
80009afc:	a8d9                	j	80009bd2 <.L52>

80009afe <.L60>:
                                                       tbl->tq_max,
80009afe:	57d2                	lw	a5,52(sp)
80009b00:	0017c783          	lbu	a5,1(a5)
            current_prescaler = find_optimal_prescaler(num_tq_mul_prescaler, start_prescaler,
80009b04:	873e                	mv	a4,a5
                                                       tbl->tq_min);
80009b06:	57d2                	lw	a5,52(sp)
80009b08:	0007c783          	lbu	a5,0(a5)
            current_prescaler = find_optimal_prescaler(num_tq_mul_prescaler, start_prescaler,
80009b0c:	86be                	mv	a3,a5
80009b0e:	863a                	mv	a2,a4
80009b10:	45a6                	lw	a1,72(sp)
80009b12:	5542                	lw	a0,48(sp)
80009b14:	35dd                	jal	800099fa <find_optimal_prescaler>
80009b16:	dc2a                	sw	a0,56(sp)
            if ((current_prescaler < start_prescaler) || (current_prescaler > NUM_PRESCALE_MAX)) {
80009b18:	5762                	lw	a4,56(sp)
80009b1a:	47a6                	lw	a5,72(sp)
80009b1c:	0cf76463          	bltu	a4,a5,80009be4 <.L53>
80009b20:	5762                	lw	a4,56(sp)
80009b22:	10000793          	li	a5,256
80009b26:	0ae7ef63          	bltu	a5,a4,80009be4 <.L53>
            uint32_t num_tq = num_tq_mul_prescaler / current_prescaler;
80009b2a:	5742                	lw	a4,48(sp)
80009b2c:	57e2                	lw	a5,56(sp)
80009b2e:	02f757b3          	divu	a5,a4,a5
80009b32:	d63e                	sw	a5,44(sp)
            num_seg2 = (num_tq - tbl->min_diff_seg1_minus_seg2) / 2U;
80009b34:	57d2                	lw	a5,52(sp)
80009b36:	0087c783          	lbu	a5,8(a5)
80009b3a:	873e                	mv	a4,a5
80009b3c:	57b2                	lw	a5,44(sp)
80009b3e:	8f99                	sub	a5,a5,a4
80009b40:	8385                	srl	a5,a5,0x1
80009b42:	c0be                	sw	a5,64(sp)
            num_seg1 = num_tq - num_seg2;
80009b44:	5732                	lw	a4,44(sp)
80009b46:	4786                	lw	a5,64(sp)
80009b48:	40f707b3          	sub	a5,a4,a5
80009b4c:	c2be                	sw	a5,68(sp)
            while (num_seg2 > tbl->seg2_max) {
80009b4e:	a039                	j	80009b5c <.L54>

80009b50 <.L55>:
                num_seg2--;
80009b50:	4786                	lw	a5,64(sp)
80009b52:	17fd                	add	a5,a5,-1
80009b54:	c0be                	sw	a5,64(sp)
                num_seg1++;
80009b56:	4796                	lw	a5,68(sp)
80009b58:	0785                	add	a5,a5,1
80009b5a:	c2be                	sw	a5,68(sp)

80009b5c <.L54>:
            while (num_seg2 > tbl->seg2_max) {
80009b5c:	57d2                	lw	a5,52(sp)
80009b5e:	0057c783          	lbu	a5,5(a5)
80009b62:	873e                	mv	a4,a5
80009b64:	4786                	lw	a5,64(sp)
80009b66:	fef765e3          	bltu	a4,a5,80009b50 <.L55>
            while ((num_seg1 * 1000U) / num_tq < samplepoint_min) {
80009b6a:	a039                	j	80009b78 <.L56>

80009b6c <.L57>:
                ++num_seg1;
80009b6c:	4796                	lw	a5,68(sp)
80009b6e:	0785                	add	a5,a5,1
80009b70:	c2be                	sw	a5,68(sp)
                --num_seg2;
80009b72:	4786                	lw	a5,64(sp)
80009b74:	17fd                	add	a5,a5,-1
80009b76:	c0be                	sw	a5,64(sp)

80009b78 <.L56>:
            while ((num_seg1 * 1000U) / num_tq < samplepoint_min) {
80009b78:	4716                	lw	a4,68(sp)
80009b7a:	3e800793          	li	a5,1000
80009b7e:	02f70733          	mul	a4,a4,a5
80009b82:	57b2                	lw	a5,44(sp)
80009b84:	02f75733          	divu	a4,a4,a5
80009b88:	01815783          	lhu	a5,24(sp)
80009b8c:	fef760e3          	bltu	a4,a5,80009b6c <.L57>
            if ((num_seg1 * 1000U) / num_tq > samplepoint_max) {
80009b90:	4716                	lw	a4,68(sp)
80009b92:	3e800793          	li	a5,1000
80009b96:	02f70733          	mul	a4,a4,a5
80009b9a:	57b2                	lw	a5,44(sp)
80009b9c:	02f75733          	divu	a4,a4,a5
80009ba0:	01215783          	lhu	a5,18(sp)
80009ba4:	02e7ef63          	bltu	a5,a4,80009be2 <.L64>
            if ((num_seg2 >= tbl->seg2_min) && (num_seg1 <= tbl->seg1_max)) {
80009ba8:	57d2                	lw	a5,52(sp)
80009baa:	0047c783          	lbu	a5,4(a5)
80009bae:	873e                	mv	a4,a5
80009bb0:	4786                	lw	a5,64(sp)
80009bb2:	00e7ed63          	bltu	a5,a4,80009bcc <.L59>
80009bb6:	57d2                	lw	a5,52(sp)
80009bb8:	0037c783          	lbu	a5,3(a5)
80009bbc:	873e                	mv	a4,a5
80009bbe:	4796                	lw	a5,68(sp)
80009bc0:	00f76663          	bltu	a4,a5,80009bcc <.L59>
                has_found = true;
80009bc4:	4785                	li	a5,1
80009bc6:	02f10fa3          	sb	a5,63(sp)
80009bca:	a021                	j	80009bd2 <.L52>

80009bcc <.L59>:
                start_prescaler = current_prescaler + 1U;
80009bcc:	57e2                	lw	a5,56(sp)
80009bce:	0785                	add	a5,a5,1
80009bd0:	c4be                	sw	a5,72(sp)

80009bd2 <.L52>:
        while (!has_found) {
80009bd2:	03f14783          	lbu	a5,63(sp)
80009bd6:	0017c793          	xor	a5,a5,1
80009bda:	0ff7f793          	zext.b	a5,a5
80009bde:	f385                	bnez	a5,80009afe <.L60>
80009be0:	a011                	j	80009be4 <.L53>

80009be2 <.L64>:
                break;
80009be2:	0001                	nop

80009be4 <.L53>:
        if (has_found) {
80009be4:	03f14783          	lbu	a5,63(sp)
80009be8:	cba9                	beqz	a5,80009c3a <.L50>

80009bea <.LBB6>:
            uint32_t num_sjw = MIN(tbl->sjw_max, num_seg2);
80009bea:	57d2                	lw	a5,52(sp)
80009bec:	0077c783          	lbu	a5,7(a5)
80009bf0:	873e                	mv	a4,a5
80009bf2:	4786                	lw	a5,64(sp)
80009bf4:	00f77363          	bgeu	a4,a5,80009bfa <.L61>
80009bf8:	87ba                	mv	a5,a4

80009bfa <.L61>:
80009bfa:	d43e                	sw	a5,40(sp)
            timing_param->num_seg1 = num_seg1;
80009bfc:	4796                	lw	a5,68(sp)
80009bfe:	01079713          	sll	a4,a5,0x10
80009c02:	8341                	srl	a4,a4,0x10
80009c04:	47b2                	lw	a5,12(sp)
80009c06:	00e79123          	sh	a4,2(a5)
            timing_param->num_seg2 = num_seg2;
80009c0a:	4786                	lw	a5,64(sp)
80009c0c:	01079713          	sll	a4,a5,0x10
80009c10:	8341                	srl	a4,a4,0x10
80009c12:	47b2                	lw	a5,12(sp)
80009c14:	00e79223          	sh	a4,4(a5)
            timing_param->num_sjw = num_sjw;
80009c18:	57a2                	lw	a5,40(sp)
80009c1a:	01079713          	sll	a4,a5,0x10
80009c1e:	8341                	srl	a4,a4,0x10
80009c20:	47b2                	lw	a5,12(sp)
80009c22:	00e79323          	sh	a4,6(a5)
            timing_param->prescaler = current_prescaler;
80009c26:	57e2                	lw	a5,56(sp)
80009c28:	01079713          	sll	a4,a5,0x10
80009c2c:	8341                	srl	a4,a4,0x10
80009c2e:	47b2                	lw	a5,12(sp)
80009c30:	00e79023          	sh	a4,0(a5)
            status = status_success;
80009c34:	c682                	sw	zero,76(sp)
80009c36:	a011                	j	80009c3a <.L50>

80009c38 <.L63>:
            break;
80009c38:	0001                	nop

80009c3a <.L50>:
    return status;
80009c3a:	47b6                	lw	a5,76(sp)
}
80009c3c:	853e                	mv	a0,a5
80009c3e:	40f6                	lw	ra,92(sp)
80009c40:	6125                	add	sp,sp,96
80009c42:	8082                	ret

Disassembly of section .text.can_fill_tx_buffer:

80009c44 <can_fill_tx_buffer>:
{
80009c44:	7179                	add	sp,sp,-48
80009c46:	d606                	sw	ra,44(sp)
80009c48:	c62a                	sw	a0,12(sp)
80009c4a:	c42e                	sw	a1,8(sp)
    base->TBUF[0] = message->buffer[0];
80009c4c:	47a2                	lw	a5,8(sp)
80009c4e:	4398                	lw	a4,0(a5)
80009c50:	47b2                	lw	a5,12(sp)
80009c52:	cbb8                	sw	a4,80(a5)
    base->TBUF[1] = message->buffer[1];
80009c54:	47a2                	lw	a5,8(sp)
80009c56:	43d8                	lw	a4,4(a5)
80009c58:	47b2                	lw	a5,12(sp)
80009c5a:	cbf8                	sw	a4,84(a5)
    uint32_t copy_words = can_get_data_words_from_dlc(message->dlc);
80009c5c:	47a2                	lw	a5,8(sp)
80009c5e:	43dc                	lw	a5,4(a5)
80009c60:	8bbd                	and	a5,a5,15
80009c62:	0ff7f793          	zext.b	a5,a5
80009c66:	853e                	mv	a0,a5
80009c68:	b86fb0ef          	jal	80004fee <can_get_data_words_from_dlc>
80009c6c:	87aa                	mv	a5,a0
80009c6e:	cc3e                	sw	a5,24(sp)

80009c70 <.LBB9>:
    for (uint32_t i = 0U; i < copy_words; i++) {
80009c70:	ce02                	sw	zero,28(sp)
80009c72:	a015                	j	80009c96 <.L102>

80009c74 <.L103>:
        base->TBUF[2U + i] = message->buffer[2U + i];
80009c74:	47f2                	lw	a5,28(sp)
80009c76:	00278713          	add	a4,a5,2
80009c7a:	47f2                	lw	a5,28(sp)
80009c7c:	0789                	add	a5,a5,2
80009c7e:	46a2                	lw	a3,8(sp)
80009c80:	070a                	sll	a4,a4,0x2
80009c82:	9736                	add	a4,a4,a3
80009c84:	4318                	lw	a4,0(a4)
80009c86:	46b2                	lw	a3,12(sp)
80009c88:	07d1                	add	a5,a5,20
80009c8a:	078a                	sll	a5,a5,0x2
80009c8c:	97b6                	add	a5,a5,a3
80009c8e:	c398                	sw	a4,0(a5)
    for (uint32_t i = 0U; i < copy_words; i++) {
80009c90:	47f2                	lw	a5,28(sp)
80009c92:	0785                	add	a5,a5,1
80009c94:	ce3e                	sw	a5,28(sp)

80009c96 <.L102>:
80009c96:	4772                	lw	a4,28(sp)
80009c98:	47e2                	lw	a5,24(sp)
80009c9a:	fcf76de3          	bltu	a4,a5,80009c74 <.L103>

80009c9e <.LBE9>:
}
80009c9e:	0001                	nop
80009ca0:	0001                	nop
80009ca2:	50b2                	lw	ra,44(sp)
80009ca4:	6145                	add	sp,sp,48
80009ca6:	8082                	ret

Disassembly of section .text.can_send_message_blocking:

80009ca8 <can_send_message_blocking>:
{
80009ca8:	7179                	add	sp,sp,-48
80009caa:	d606                	sw	ra,44(sp)
80009cac:	c62a                	sw	a0,12(sp)
80009cae:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
80009cb0:	4789                	li	a5,2
80009cb2:	ce3e                	sw	a5,28(sp)

80009cb4 <.LBB10>:
        if ((base == NULL) || (message == NULL)) {
80009cb4:	47b2                	lw	a5,12(sp)
80009cb6:	cbd9                	beqz	a5,80009d4c <.L105>
80009cb8:	47a2                	lw	a5,8(sp)
80009cba:	cbc9                	beqz	a5,80009d4c <.L105>
        status = status_success;
80009cbc:	ce02                	sw	zero,28(sp)
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TBSEL_MASK;
80009cbe:	47b2                	lw	a5,12(sp)
80009cc0:	0a07a703          	lw	a4,160(a5)
80009cc4:	67a1                	lui	a5,0x8
80009cc6:	8f5d                	or	a4,a4,a5
80009cc8:	47b2                	lw	a5,12(sp)
80009cca:	0ae7a023          	sw	a4,160(a5) # 80a0 <__AHB_SRAM_segment_size__+0xa0>
        can_fill_tx_buffer(base, message);
80009cce:	45a2                	lw	a1,8(sp)
80009cd0:	4532                	lw	a0,12(sp)
80009cd2:	3f8d                	jal	80009c44 <can_fill_tx_buffer>
        int32_t timeout_cnt = CAN_TIMEOUT_CNT;
80009cd4:	010007b7          	lui	a5,0x1000
80009cd8:	17fd                	add	a5,a5,-1 # ffffff <_flash_size+0x7fffff>
80009cda:	cc3e                	sw	a5,24(sp)
        while (CAN_CMD_STA_CMD_CTRL_TSSTAT_GET(base->CMD_STA_CMD_CTRL) == CAN_STB_IS_FULL) {
80009cdc:	a811                	j	80009cf0 <.L106>

80009cde <.L108>:
            timeout_cnt--;
80009cde:	47e2                	lw	a5,24(sp)
80009ce0:	17fd                	add	a5,a5,-1
80009ce2:	cc3e                	sw	a5,24(sp)
            if (timeout_cnt <= 0) {
80009ce4:	47e2                	lw	a5,24(sp)
80009ce6:	00f04563          	bgtz	a5,80009cf0 <.L106>
                status = status_timeout;
80009cea:	478d                	li	a5,3
80009cec:	ce3e                	sw	a5,28(sp)
                break;
80009cee:	a819                	j	80009d04 <.L107>

80009cf0 <.L106>:
        while (CAN_CMD_STA_CMD_CTRL_TSSTAT_GET(base->CMD_STA_CMD_CTRL) == CAN_STB_IS_FULL) {
80009cf0:	47b2                	lw	a5,12(sp)
80009cf2:	0a07a703          	lw	a4,160(a5)
80009cf6:	000307b7          	lui	a5,0x30
80009cfa:	8f7d                	and	a4,a4,a5
80009cfc:	000307b7          	lui	a5,0x30
80009d00:	fcf70fe3          	beq	a4,a5,80009cde <.L108>

80009d04 <.L107>:
        if (status != status_success) {
80009d04:	47f2                	lw	a5,28(sp)
80009d06:	e3b1                	bnez	a5,80009d4a <.L113>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TSNEXT_MASK | CAN_CMD_STA_CMD_CTRL_TSONE_MASK;
80009d08:	47b2                	lw	a5,12(sp)
80009d0a:	0a07a703          	lw	a4,160(a5) # 300a0 <__XPI0_segment_used_size__+0x23468>
80009d0e:	004007b7          	lui	a5,0x400
80009d12:	40078793          	add	a5,a5,1024 # 400400 <__DLM_segment_end__+0x340400>
80009d16:	8f5d                	or	a4,a4,a5
80009d18:	47b2                	lw	a5,12(sp)
80009d1a:	0ae7a023          	sw	a4,160(a5)
        timeout_cnt = CAN_TIMEOUT_CNT;
80009d1e:	010007b7          	lui	a5,0x1000
80009d22:	17fd                	add	a5,a5,-1 # ffffff <_flash_size+0x7fffff>
80009d24:	cc3e                	sw	a5,24(sp)
        while (CAN_CMD_STA_CMD_CTRL_TSSTAT_GET(base->CMD_STA_CMD_CTRL) != CAN_STB_IS_EMPTY) {
80009d26:	a811                	j	80009d3a <.L110>

80009d28 <.L111>:
            timeout_cnt--;
80009d28:	47e2                	lw	a5,24(sp)
80009d2a:	17fd                	add	a5,a5,-1
80009d2c:	cc3e                	sw	a5,24(sp)
            if (timeout_cnt <= 0) {
80009d2e:	47e2                	lw	a5,24(sp)
80009d30:	00f04563          	bgtz	a5,80009d3a <.L110>
                status = status_timeout;
80009d34:	478d                	li	a5,3
80009d36:	ce3e                	sw	a5,28(sp)
                break;
80009d38:	a811                	j	80009d4c <.L105>

80009d3a <.L110>:
        while (CAN_CMD_STA_CMD_CTRL_TSSTAT_GET(base->CMD_STA_CMD_CTRL) != CAN_STB_IS_EMPTY) {
80009d3a:	47b2                	lw	a5,12(sp)
80009d3c:	0a07a703          	lw	a4,160(a5)
80009d40:	000307b7          	lui	a5,0x30
80009d44:	8ff9                	and	a5,a5,a4
80009d46:	f3ed                	bnez	a5,80009d28 <.L111>
80009d48:	a011                	j	80009d4c <.L105>

80009d4a <.L113>:
            break;
80009d4a:	0001                	nop

80009d4c <.L105>:
    return status;
80009d4c:	47f2                	lw	a5,28(sp)
}
80009d4e:	853e                	mv	a0,a5
80009d50:	50b2                	lw	ra,44(sp)
80009d52:	6145                	add	sp,sp,48
80009d54:	8082                	ret

Disassembly of section .text.can_read_received_message:

80009d56 <can_read_received_message>:
{
80009d56:	7179                	add	sp,sp,-48
80009d58:	d606                	sw	ra,44(sp)
80009d5a:	c62a                	sw	a0,12(sp)
80009d5c:	c42e                	sw	a1,8(sp)
    assert((base != NULL) && (message != NULL));
80009d5e:	47b2                	lw	a5,12(sp)
80009d60:	c399                	beqz	a5,80009d66 <.L144>
80009d62:	47a2                	lw	a5,8(sp)
80009d64:	ef89                	bnez	a5,80009d7e <.L145>

80009d66 <.L144>:
80009d66:	23a00613          	li	a2,570
80009d6a:	800037b7          	lui	a5,0x80003
80009d6e:	15478593          	add	a1,a5,340 # 80003154 <.LC0>
80009d72:	800037b7          	lui	a5,0x80003
80009d76:	1a478513          	add	a0,a5,420 # 800031a4 <.LC1>
80009d7a:	71a020ef          	jal	8000c494 <__SEGGER_RTL_X_assert>

80009d7e <.L145>:
        message->buffer[0] = base->RBUF[0];
80009d7e:	47b2                	lw	a5,12(sp)
80009d80:	4398                	lw	a4,0(a5)
80009d82:	47a2                	lw	a5,8(sp)
80009d84:	c398                	sw	a4,0(a5)
        message->buffer[1] = base->RBUF[1];
80009d86:	47b2                	lw	a5,12(sp)
80009d88:	43d8                	lw	a4,4(a5)
80009d8a:	47a2                	lw	a5,8(sp)
80009d8c:	c3d8                	sw	a4,4(a5)
        if (message->error_type != 0U) {
80009d8e:	47a2                	lw	a5,8(sp)
80009d90:	43d8                	lw	a4,4(a5)
80009d92:	67b9                	lui	a5,0xe
80009d94:	8ff9                	and	a5,a5,a4
80009d96:	c3b5                	beqz	a5,80009dfa <.L146>
            switch (message->error_type) {
80009d98:	47a2                	lw	a5,8(sp)
80009d9a:	43dc                	lw	a5,4(a5)
80009d9c:	83b5                	srl	a5,a5,0xd
80009d9e:	8b9d                	and	a5,a5,7
80009da0:	0ff7f793          	zext.b	a5,a5
80009da4:	4715                	li	a4,5
80009da6:	04f76463          	bltu	a4,a5,80009dee <.L147>
80009daa:	00279713          	sll	a4,a5,0x2
80009dae:	800037b7          	lui	a5,0x80003
80009db2:	1c878793          	add	a5,a5,456 # 800031c8 <.L149>
80009db6:	97ba                	add	a5,a5,a4
80009db8:	439c                	lw	a5,0(a5)
80009dba:	8782                	jr	a5

80009dbc <.L153>:
                status = status_can_bit_error;
80009dbc:	6795                	lui	a5,0x5
80009dbe:	a3878793          	add	a5,a5,-1480 # 4a38 <__HEAPSIZE__+0xa38>
80009dc2:	ce3e                	sw	a5,28(sp)
                break;
80009dc4:	a815                	j	80009df8 <.L154>

80009dc6 <.L152>:
                status = status_can_form_error;
80009dc6:	6795                	lui	a5,0x5
80009dc8:	a3978793          	add	a5,a5,-1479 # 4a39 <__HEAPSIZE__+0xa39>
80009dcc:	ce3e                	sw	a5,28(sp)
                break;
80009dce:	a02d                	j	80009df8 <.L154>

80009dd0 <.L151>:
                status = status_can_stuff_error;
80009dd0:	6795                	lui	a5,0x5
80009dd2:	a3a78793          	add	a5,a5,-1478 # 4a3a <__HEAPSIZE__+0xa3a>
80009dd6:	ce3e                	sw	a5,28(sp)
                break;
80009dd8:	a005                	j	80009df8 <.L154>

80009dda <.L150>:
                status = status_can_ack_error;
80009dda:	6795                	lui	a5,0x5
80009ddc:	a3b78793          	add	a5,a5,-1477 # 4a3b <__HEAPSIZE__+0xa3b>
80009de0:	ce3e                	sw	a5,28(sp)
                break;
80009de2:	a819                	j	80009df8 <.L154>

80009de4 <.L148>:
                status = status_can_crc_error;
80009de4:	6795                	lui	a5,0x5
80009de6:	a3c78793          	add	a5,a5,-1476 # 4a3c <__HEAPSIZE__+0xa3c>
80009dea:	ce3e                	sw	a5,28(sp)
                break;
80009dec:	a031                	j	80009df8 <.L154>

80009dee <.L147>:
                status = status_can_other_error;
80009dee:	6795                	lui	a5,0x5
80009df0:	a3d78793          	add	a5,a5,-1475 # 4a3d <__HEAPSIZE__+0xa3d>
80009df4:	ce3e                	sw	a5,28(sp)
                break;
80009df6:	0001                	nop

80009df8 <.L154>:
            break;
80009df8:	a085                	j	80009e58 <.L155>

80009dfa <.L146>:
        if (message->remote_frame == 0U) {
80009dfa:	47a2                	lw	a5,8(sp)
80009dfc:	43dc                	lw	a5,4(a5)
80009dfe:	0407f793          	and	a5,a5,64
80009e02:	e3a9                	bnez	a5,80009e44 <.L156>

80009e04 <.LBB14>:
            uint32_t copy_words = can_get_data_words_from_dlc(message->dlc);
80009e04:	47a2                	lw	a5,8(sp)
80009e06:	43dc                	lw	a5,4(a5)
80009e08:	8bbd                	and	a5,a5,15
80009e0a:	0ff7f793          	zext.b	a5,a5
80009e0e:	853e                	mv	a0,a5
80009e10:	9defb0ef          	jal	80004fee <can_get_data_words_from_dlc>
80009e14:	87aa                	mv	a5,a0
80009e16:	ca3e                	sw	a5,20(sp)

80009e18 <.LBB15>:
            for (uint32_t i = 0; i < copy_words; i++) {
80009e18:	cc02                	sw	zero,24(sp)
80009e1a:	a00d                	j	80009e3c <.L157>

80009e1c <.L158>:
                message->buffer[2U + i] = base->RBUF[2U + i];
80009e1c:	47e2                	lw	a5,24(sp)
80009e1e:	00278713          	add	a4,a5,2
80009e22:	47e2                	lw	a5,24(sp)
80009e24:	0789                	add	a5,a5,2
80009e26:	46b2                	lw	a3,12(sp)
80009e28:	070a                	sll	a4,a4,0x2
80009e2a:	9736                	add	a4,a4,a3
80009e2c:	4318                	lw	a4,0(a4)
80009e2e:	46a2                	lw	a3,8(sp)
80009e30:	078a                	sll	a5,a5,0x2
80009e32:	97b6                	add	a5,a5,a3
80009e34:	c398                	sw	a4,0(a5)
            for (uint32_t i = 0; i < copy_words; i++) {
80009e36:	47e2                	lw	a5,24(sp)
80009e38:	0785                	add	a5,a5,1
80009e3a:	cc3e                	sw	a5,24(sp)

80009e3c <.L157>:
80009e3c:	4762                	lw	a4,24(sp)
80009e3e:	47d2                	lw	a5,20(sp)
80009e40:	fcf76ee3          	bltu	a4,a5,80009e1c <.L158>

80009e44 <.L156>:
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_RREL_MASK;
80009e44:	47b2                	lw	a5,12(sp)
80009e46:	0a07a703          	lw	a4,160(a5)
80009e4a:	100007b7          	lui	a5,0x10000
80009e4e:	8f5d                	or	a4,a4,a5
80009e50:	47b2                	lw	a5,12(sp)
80009e52:	0ae7a023          	sw	a4,160(a5) # 100000a0 <__SHARE_RAM_segment_end__+0xee800a0>
        status = status_success;
80009e56:	ce02                	sw	zero,28(sp)

80009e58 <.L155>:
    return status;
80009e58:	47f2                	lw	a5,28(sp)
}
80009e5a:	853e                	mv	a0,a5
80009e5c:	50b2                	lw	ra,44(sp)
80009e5e:	6145                	add	sp,sp,48
80009e60:	8082                	ret

Disassembly of section .text.can_get_default_config:

80009e62 <can_get_default_config>:
{
80009e62:	1101                	add	sp,sp,-32
80009e64:	c62a                	sw	a0,12(sp)
    hpm_stat_t status = status_invalid_argument;
80009e66:	4789                	li	a5,2
80009e68:	ce3e                	sw	a5,28(sp)
    if (config != NULL) {
80009e6a:	47b2                	lw	a5,12(sp)
80009e6c:	c7d9                	beqz	a5,80009efa <.L161>
        config->baudrate = 1000000UL; /* 1Mbit/s */
80009e6e:	47b2                	lw	a5,12(sp)
80009e70:	000f4737          	lui	a4,0xf4
80009e74:	24070713          	add	a4,a4,576 # f4240 <__DLM_segment_end__+0x34240>
80009e78:	c398                	sw	a4,0(a5)
        config->baudrate_fd = 0U;
80009e7a:	47b2                	lw	a5,12(sp)
80009e7c:	0007a223          	sw	zero,4(a5)
        config->use_lowlevel_timing_setting = false;
80009e80:	47b2                	lw	a5,12(sp)
80009e82:	000788a3          	sb	zero,17(a5)
        config->can20_samplepoint_min = CAN_SAMPLEPOINT_MIN;
80009e86:	47b2                	lw	a5,12(sp)
80009e88:	2ee00713          	li	a4,750
80009e8c:	00e79423          	sh	a4,8(a5)
        config->can20_samplepoint_max = CAN_SAMPLEPOINT_MAX;
80009e90:	47b2                	lw	a5,12(sp)
80009e92:	36b00713          	li	a4,875
80009e96:	00e79523          	sh	a4,10(a5)
        config->canfd_samplepoint_min = CAN_SAMPLEPOINT_MIN;
80009e9a:	47b2                	lw	a5,12(sp)
80009e9c:	2ee00713          	li	a4,750
80009ea0:	00e79623          	sh	a4,12(a5)
        config->canfd_samplepoint_max = CAN_SAMPLEPOINT_MAX;
80009ea4:	47b2                	lw	a5,12(sp)
80009ea6:	36b00713          	li	a4,875
80009eaa:	00e79723          	sh	a4,14(a5)
        config->enable_canfd = false;
80009eae:	47b2                	lw	a5,12(sp)
80009eb0:	00078923          	sb	zero,18(a5)
        config->enable_can_fd_iso_mode = true;
80009eb4:	47b2                	lw	a5,12(sp)
80009eb6:	4705                	li	a4,1
80009eb8:	00e78fa3          	sb	a4,31(a5)
        config->mode = can_mode_normal;
80009ebc:	47b2                	lw	a5,12(sp)
80009ebe:	00078823          	sb	zero,16(a5)
        config->enable_self_ack = false;
80009ec2:	47b2                	lw	a5,12(sp)
80009ec4:	000789a3          	sb	zero,19(a5)
        config->disable_stb_retransmission = false;
80009ec8:	47b2                	lw	a5,12(sp)
80009eca:	00078aa3          	sb	zero,21(a5)
        config->disable_ptb_retransmission = false;
80009ece:	47b2                	lw	a5,12(sp)
80009ed0:	00078a23          	sb	zero,20(a5)
        config->enable_tx_buffer_priority_mode = false;
80009ed4:	47b2                	lw	a5,12(sp)
80009ed6:	00078f23          	sb	zero,30(a5)
        config->enable_tdc = false;
80009eda:	47b2                	lw	a5,12(sp)
80009edc:	00078b23          	sb	zero,22(a5)
        config->filter_list_num = 0;
80009ee0:	47b2                	lw	a5,12(sp)
80009ee2:	00078ba3          	sb	zero,23(a5)
        config->filter_list = NULL;
80009ee6:	47b2                	lw	a5,12(sp)
80009ee8:	0007ac23          	sw	zero,24(a5)
        config->irq_txrx_enable_mask = 0;
80009eec:	47b2                	lw	a5,12(sp)
80009eee:	00078e23          	sb	zero,28(a5)
        config->irq_error_enable_mask = 0;
80009ef2:	47b2                	lw	a5,12(sp)
80009ef4:	00078ea3          	sb	zero,29(a5)
        status = status_success;
80009ef8:	ce02                	sw	zero,28(sp)

80009efa <.L161>:
    return status;
80009efa:	47f2                	lw	a5,28(sp)
}
80009efc:	853e                	mv	a0,a5
80009efe:	6105                	add	sp,sp,32
80009f00:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

80009f02 <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
80009f02:	1101                	add	sp,sp,-32
80009f04:	c62a                	sw	a0,12(sp)
80009f06:	87ae                	mv	a5,a1
80009f08:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80009f0c:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
80009f0e:	00a15703          	lhu	a4,10(sp)
80009f12:	25700793          	li	a5,599
80009f16:	00e7f863          	bgeu	a5,a4,80009f26 <.L26>
80009f1a:	00a15703          	lhu	a4,10(sp)
80009f1e:	55f00793          	li	a5,1375
80009f22:	00e7f463          	bgeu	a5,a4,80009f2a <.L27>

80009f26 <.L26>:
        return status_invalid_argument;
80009f26:	4789                	li	a5,2
80009f28:	a831                	j	80009f44 <.L28>

80009f2a <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80009f2a:	47b2                	lw	a5,12(sp)
80009f2c:	4b98                	lw	a4,16(a5)
80009f2e:	77fd                	lui	a5,0xfffff
80009f30:	8f7d                	and	a4,a4,a5
80009f32:	00a15683          	lhu	a3,10(sp)
80009f36:	6785                	lui	a5,0x1
80009f38:	17fd                	add	a5,a5,-1 # fff <.L27+0x1c5>
80009f3a:	8ff5                	and	a5,a5,a3
80009f3c:	8f5d                	or	a4,a4,a5
80009f3e:	47b2                	lw	a5,12(sp)
80009f40:	cb98                	sw	a4,16(a5)
    return stat;
80009f42:	47f2                	lw	a5,28(sp)

80009f44 <.L28>:
}
80009f44:	853e                	mv	a0,a5
80009f46:	6105                	add	sp,sp,32
80009f48:	8082                	ret

Disassembly of section .text.pllctl_pll_powerdown:

80009f4a <pllctl_pll_powerdown>:
{
80009f4a:	1141                	add	sp,sp,-16
80009f4c:	c62a                	sw	a0,12(sp)
80009f4e:	87ae                	mv	a5,a1
80009f50:	00f105a3          	sb	a5,11(sp)
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
80009f54:	00b14703          	lbu	a4,11(sp)
80009f58:	4791                	li	a5,4
80009f5a:	00e7f463          	bgeu	a5,a4,80009f62 <.L5>
        return status_invalid_argument;
80009f5e:	4789                	li	a5,2
80009f60:	a805                	j	80009f90 <.L6>

80009f62 <.L5>:
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
80009f62:	00b14783          	lbu	a5,11(sp)
80009f66:	4732                	lw	a4,12(sp)
80009f68:	0785                	add	a5,a5,1
80009f6a:	079e                	sll	a5,a5,0x7
80009f6c:	97ba                	add	a5,a5,a4
80009f6e:	43d8                	lw	a4,4(a5)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
80009f70:	7a0007b7          	lui	a5,0x7a000
80009f74:	17fd                	add	a5,a5,-1 # 79ffffff <__SHARE_RAM_segment_end__+0x78e7ffff>
80009f76:	00f776b3          	and	a3,a4,a5
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
80009f7a:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
80009f7e:	02000737          	lui	a4,0x2000
80009f82:	8f55                	or	a4,a4,a3
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
80009f84:	46b2                	lw	a3,12(sp)
80009f86:	0785                	add	a5,a5,1
80009f88:	079e                	sll	a5,a5,0x7
80009f8a:	97b6                	add	a5,a5,a3
80009f8c:	c3d8                	sw	a4,4(a5)
    return status_success;
80009f8e:	4781                	li	a5,0

80009f90 <.L6>:
}
80009f90:	853e                	mv	a0,a5
80009f92:	0141                	add	sp,sp,16
80009f94:	8082                	ret

Disassembly of section .text.pllctl_init_int_pll_with_freq:

80009f96 <pllctl_init_int_pll_with_freq>:
    return status_success;
}

hpm_stat_t pllctl_init_int_pll_with_freq(PLLCTL_Type *ptr, uint8_t pll,
                                    uint32_t freq_in_hz)
{
80009f96:	7179                	add	sp,sp,-48
80009f98:	d606                	sw	ra,44(sp)
80009f9a:	c62a                	sw	a0,12(sp)
80009f9c:	87ae                	mv	a5,a1
80009f9e:	c232                	sw	a2,4(sp)
80009fa0:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
80009fa4:	47b2                	lw	a5,12(sp)
80009fa6:	c791                	beqz	a5,80009fb2 <.L27>
80009fa8:	00b14703          	lbu	a4,11(sp)
80009fac:	4791                	li	a5,4
80009fae:	00e7f463          	bgeu	a5,a4,80009fb6 <.L28>

80009fb2 <.L27>:
        return status_invalid_argument;
80009fb2:	4789                	li	a5,2
80009fb4:	ac09                	j	8000a1c6 <.L29>

80009fb6 <.L28>:
    }
    uint32_t freq, fbdiv, refdiv, postdiv;
    if ((freq_in_hz < PLLCTL_PLL_VCO_FREQ_MIN)
80009fb6:	4712                	lw	a4,4(sp)
80009fb8:	165a17b7          	lui	a5,0x165a1
80009fbc:	bbf78793          	add	a5,a5,-1089 # 165a0bbf <__SHARE_RAM_segment_end__+0x15420bbf>
80009fc0:	00e7f963          	bgeu	a5,a4,80009fd2 <.L30>
            || (freq_in_hz > PLLCTL_PLL_VCO_FREQ_MAX)) {
80009fc4:	4712                	lw	a4,4(sp)
80009fc6:	832157b7          	lui	a5,0x83215
80009fca:	60078793          	add	a5,a5,1536 # 83215600 <__XPI0_segment_end__+0x2a15600>
80009fce:	00e7f463          	bgeu	a5,a4,80009fd6 <.L31>

80009fd2 <.L30>:
        return status_invalid_argument;
80009fd2:	4789                	li	a5,2
80009fd4:	aacd                	j	8000a1c6 <.L29>

80009fd6 <.L31>:
    }

    freq = freq_in_hz;
80009fd6:	4792                	lw	a5,4(sp)
80009fd8:	ca3e                	sw	a5,20(sp)
    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
80009fda:	00b14783          	lbu	a5,11(sp)
80009fde:	4732                	lw	a4,12(sp)
80009fe0:	0785                	add	a5,a5,1
80009fe2:	079e                	sll	a5,a5,0x7
80009fe4:	97ba                	add	a5,a5,a4
80009fe6:	439c                	lw	a5,0(a5)
80009fe8:	83e1                	srl	a5,a5,0x18
80009fea:	03f7f793          	and	a5,a5,63
80009fee:	cc3e                	sw	a5,24(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
80009ff0:	00b14783          	lbu	a5,11(sp)
80009ff4:	4732                	lw	a4,12(sp)
80009ff6:	0785                	add	a5,a5,1
80009ff8:	079e                	sll	a5,a5,0x7
80009ffa:	97ba                	add	a5,a5,a4
80009ffc:	439c                	lw	a5,0(a5)
80009ffe:	83d1                	srl	a5,a5,0x14
8000a000:	8b9d                	and	a5,a5,7
8000a002:	c83e                	sw	a5,16(sp)
    fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000a004:	4762                	lw	a4,24(sp)
8000a006:	47c2                	lw	a5,16(sp)
8000a008:	02f707b3          	mul	a5,a4,a5
8000a00c:	016e3737          	lui	a4,0x16e3
8000a010:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000a014:	02f757b3          	divu	a5,a4,a5
8000a018:	4752                	lw	a4,20(sp)
8000a01a:	02f757b3          	divu	a5,a4,a5
8000a01e:	ce3e                	sw	a5,28(sp)
    if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
8000a020:	4772                	lw	a4,28(sp)
8000a022:	6785                	lui	a5,0x1
8000a024:	96078793          	add	a5,a5,-1696 # 960 <.L164+0xe>
8000a028:	04e7f163          	bgeu	a5,a4,8000a06a <.L32>
        /* current refdiv can't be used for the given frequency */
        refdiv--;
8000a02c:	47e2                	lw	a5,24(sp)
8000a02e:	17fd                	add	a5,a5,-1
8000a030:	cc3e                	sw	a5,24(sp)

8000a032 <.L36>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000a032:	4762                	lw	a4,24(sp)
8000a034:	47c2                	lw	a5,16(sp)
8000a036:	02f707b3          	mul	a5,a4,a5
8000a03a:	016e3737          	lui	a4,0x16e3
8000a03e:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000a042:	02f757b3          	divu	a5,a4,a5
8000a046:	4752                	lw	a4,20(sp)
8000a048:	02f757b3          	divu	a5,a4,a5
8000a04c:	ce3e                	sw	a5,28(sp)
            if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
8000a04e:	4772                	lw	a4,28(sp)
8000a050:	6785                	lui	a5,0x1
8000a052:	96078793          	add	a5,a5,-1696 # 960 <.L164+0xe>
8000a056:	04e7fc63          	bgeu	a5,a4,8000a0ae <.L45>
                refdiv--;
8000a05a:	47e2                	lw	a5,24(sp)
8000a05c:	17fd                	add	a5,a5,-1
8000a05e:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv > PLLCTL_PLL_MIN_REFDIV);
8000a060:	4762                	lw	a4,24(sp)
8000a062:	4785                	li	a5,1
8000a064:	fce7e7e3          	bltu	a5,a4,8000a032 <.L36>
8000a068:	a0b1                	j	8000a0b4 <.L37>

8000a06a <.L32>:
    } else if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
8000a06a:	4772                	lw	a4,28(sp)
8000a06c:	47bd                	li	a5,15
8000a06e:	04e7e363          	bltu	a5,a4,8000a0b4 <.L37>
        /* current refdiv can't be used for the given frequency */
        refdiv++;
8000a072:	47e2                	lw	a5,24(sp)
8000a074:	0785                	add	a5,a5,1
8000a076:	cc3e                	sw	a5,24(sp)

8000a078 <.L40>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000a078:	4762                	lw	a4,24(sp)
8000a07a:	47c2                	lw	a5,16(sp)
8000a07c:	02f707b3          	mul	a5,a4,a5
8000a080:	016e3737          	lui	a4,0x16e3
8000a084:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000a088:	02f757b3          	divu	a5,a4,a5
8000a08c:	4752                	lw	a4,20(sp)
8000a08e:	02f757b3          	divu	a5,a4,a5
8000a092:	ce3e                	sw	a5,28(sp)
            if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
8000a094:	4772                	lw	a4,28(sp)
8000a096:	47bd                	li	a5,15
8000a098:	00e7ed63          	bltu	a5,a4,8000a0b2 <.L46>
                refdiv++;
8000a09c:	47e2                	lw	a5,24(sp)
8000a09e:	0785                	add	a5,a5,1
8000a0a0:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv < PLLCTL_PLL_MAX_REFDIV);
8000a0a2:	4762                	lw	a4,24(sp)
8000a0a4:	03e00793          	li	a5,62
8000a0a8:	fce7f8e3          	bgeu	a5,a4,8000a078 <.L40>
8000a0ac:	a021                	j	8000a0b4 <.L37>

8000a0ae <.L45>:
                break;
8000a0ae:	0001                	nop
8000a0b0:	a011                	j	8000a0b4 <.L37>

8000a0b2 <.L46>:
                break;
8000a0b2:	0001                	nop

8000a0b4 <.L37>:
    }

    if ((refdiv > PLLCTL_PLL_MAX_REFDIV)
8000a0b4:	4762                	lw	a4,24(sp)
8000a0b6:	03f00793          	li	a5,63
8000a0ba:	02e7eb63          	bltu	a5,a4,8000a0f0 <.L41>
            || (refdiv < PLLCTL_PLL_MIN_REFDIV)
8000a0be:	47e2                	lw	a5,24(sp)
8000a0c0:	cb85                	beqz	a5,8000a0f0 <.L41>
            || (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV)
8000a0c2:	4772                	lw	a4,28(sp)
8000a0c4:	6785                	lui	a5,0x1
8000a0c6:	96078793          	add	a5,a5,-1696 # 960 <.L164+0xe>
8000a0ca:	02e7e363          	bltu	a5,a4,8000a0f0 <.L41>
            || (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV)
8000a0ce:	4772                	lw	a4,28(sp)
8000a0d0:	47bd                	li	a5,15
8000a0d2:	00e7ff63          	bgeu	a5,a4,8000a0f0 <.L41>
            || (((PLLCTL_SOC_PLL_REFCLK_FREQ / refdiv) < PLLCTL_INT_PLL_MIN_REF))) {
8000a0d6:	016e37b7          	lui	a5,0x16e3
8000a0da:	60078713          	add	a4,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000a0de:	47e2                	lw	a5,24(sp)
8000a0e0:	02f75733          	divu	a4,a4,a5
8000a0e4:	000f47b7          	lui	a5,0xf4
8000a0e8:	23f78793          	add	a5,a5,575 # f423f <__DLM_segment_end__+0x3423f>
8000a0ec:	00e7e663          	bltu	a5,a4,8000a0f8 <.L42>

8000a0f0 <.L41>:
        return status_pllctl_out_of_range;
8000a0f0:	6799                	lui	a5,0x6
8000a0f2:	9da78793          	add	a5,a5,-1574 # 59da <__NONCACHEABLE_RAM_segment_used_size__+0x4e2>
8000a0f6:	a8c1                	j	8000a1c6 <.L29>

8000a0f8 <.L42>:
    }

    if (!(ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK)) {
8000a0f8:	00b14783          	lbu	a5,11(sp)
8000a0fc:	4732                	lw	a4,12(sp)
8000a0fe:	0785                	add	a5,a5,1
8000a100:	079e                	sll	a5,a5,0x7
8000a102:	97ba                	add	a5,a5,a4
8000a104:	439c                	lw	a5,0(a5)
8000a106:	8ba1                	and	a5,a5,8
8000a108:	e795                	bnez	a5,8000a134 <.L43>
        /* it was at frac mode, then it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
8000a10a:	00b14783          	lbu	a5,11(sp)
8000a10e:	85be                	mv	a1,a5
8000a110:	4532                	lw	a0,12(sp)
8000a112:	3d25                	jal	80009f4a <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 |= PLLCTL_PLL_CFG0_DSMPD_MASK;
8000a114:	00b14783          	lbu	a5,11(sp)
8000a118:	4732                	lw	a4,12(sp)
8000a11a:	0785                	add	a5,a5,1
8000a11c:	079e                	sll	a5,a5,0x7
8000a11e:	97ba                	add	a5,a5,a4
8000a120:	4398                	lw	a4,0(a5)
8000a122:	00b14783          	lbu	a5,11(sp)
8000a126:	00876713          	or	a4,a4,8
8000a12a:	46b2                	lw	a3,12(sp)
8000a12c:	0785                	add	a5,a5,1
8000a12e:	079e                	sll	a5,a5,0x7
8000a130:	97b6                	add	a5,a5,a3
8000a132:	c398                	sw	a4,0(a5)

8000a134 <.L43>:
    }

    if (PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0) != refdiv) {
8000a134:	00b14783          	lbu	a5,11(sp)
8000a138:	4732                	lw	a4,12(sp)
8000a13a:	0785                	add	a5,a5,1
8000a13c:	079e                	sll	a5,a5,0x7
8000a13e:	97ba                	add	a5,a5,a4
8000a140:	439c                	lw	a5,0(a5)
8000a142:	83e1                	srl	a5,a5,0x18
8000a144:	03f7f793          	and	a5,a5,63
8000a148:	4762                	lw	a4,24(sp)
8000a14a:	04f70163          	beq	a4,a5,8000a18c <.L44>
        /* if refdiv is different, it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
8000a14e:	00b14783          	lbu	a5,11(sp)
8000a152:	85be                	mv	a1,a5
8000a154:	4532                	lw	a0,12(sp)
8000a156:	3bd5                	jal	80009f4a <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
8000a158:	00b14783          	lbu	a5,11(sp)
8000a15c:	4732                	lw	a4,12(sp)
8000a15e:	0785                	add	a5,a5,1
8000a160:	079e                	sll	a5,a5,0x7
8000a162:	97ba                	add	a5,a5,a4
8000a164:	4398                	lw	a4,0(a5)
8000a166:	c10007b7          	lui	a5,0xc1000
8000a16a:	17fd                	add	a5,a5,-1 # c0ffffff <__XPI0_segment_end__+0x407fffff>
8000a16c:	00f776b3          	and	a3,a4,a5
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
8000a170:	47e2                	lw	a5,24(sp)
8000a172:	01879713          	sll	a4,a5,0x18
8000a176:	3f0007b7          	lui	a5,0x3f000
8000a17a:	8f7d                	and	a4,a4,a5
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
8000a17c:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
8000a180:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
8000a182:	46b2                	lw	a3,12(sp)
8000a184:	0785                	add	a5,a5,1 # 3f000001 <__SHARE_RAM_segment_end__+0x3de80001>
8000a186:	079e                	sll	a5,a5,0x7
8000a188:	97b6                	add	a5,a5,a3
8000a18a:	c398                	sw	a4,0(a5)

8000a18c <.L44>:
    }

    ptr->PLL[pll].CFG2 = (ptr->PLL[pll].CFG2 & ~(PLLCTL_PLL_CFG2_FBDIV_INT_MASK)) | PLLCTL_PLL_CFG2_FBDIV_INT_SET(fbdiv);
8000a18c:	00b14783          	lbu	a5,11(sp)
8000a190:	4732                	lw	a4,12(sp)
8000a192:	0785                	add	a5,a5,1
8000a194:	079e                	sll	a5,a5,0x7
8000a196:	97ba                	add	a5,a5,a4
8000a198:	4798                	lw	a4,8(a5)
8000a19a:	77fd                	lui	a5,0xfffff
8000a19c:	00f776b3          	and	a3,a4,a5
8000a1a0:	4772                	lw	a4,28(sp)
8000a1a2:	6785                	lui	a5,0x1
8000a1a4:	17fd                	add	a5,a5,-1 # fff <.L27+0x1c5>
8000a1a6:	8f7d                	and	a4,a4,a5
8000a1a8:	00b14783          	lbu	a5,11(sp)
8000a1ac:	8f55                	or	a4,a4,a3
8000a1ae:	46b2                	lw	a3,12(sp)
8000a1b0:	0785                	add	a5,a5,1
8000a1b2:	079e                	sll	a5,a5,0x7
8000a1b4:	97b6                	add	a5,a5,a3
8000a1b6:	c798                	sw	a4,8(a5)

    pllctl_pll_poweron(ptr, pll);
8000a1b8:	00b14783          	lbu	a5,11(sp)
8000a1bc:	85be                	mv	a1,a5
8000a1be:	4532                	lw	a0,12(sp)
8000a1c0:	988fb0ef          	jal	80005348 <pllctl_pll_poweron>
    return status_success;
8000a1c4:	4781                	li	a5,0

8000a1c6 <.L29>:
}
8000a1c6:	853e                	mv	a0,a5
8000a1c8:	50b2                	lw	ra,44(sp)
8000a1ca:	6145                	add	sp,sp,48
8000a1cc:	8082                	ret

Disassembly of section .text.pllctl_get_pll_freq_in_hz:

8000a1ce <pllctl_get_pll_freq_in_hz>:
    pllctl_pll_poweron(ptr, pll);
    return status_success;
}

uint32_t pllctl_get_pll_freq_in_hz(PLLCTL_Type *ptr, uint8_t pll)
{
8000a1ce:	715d                	add	sp,sp,-80
8000a1d0:	c686                	sw	ra,76(sp)
8000a1d2:	c4a2                	sw	s0,72(sp)
8000a1d4:	c2a6                	sw	s1,68(sp)
8000a1d6:	c0ca                	sw	s2,64(sp)
8000a1d8:	de4e                	sw	s3,60(sp)
8000a1da:	c62a                	sw	a0,12(sp)
8000a1dc:	87ae                	mv	a5,a1
8000a1de:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
8000a1e2:	47b2                	lw	a5,12(sp)
8000a1e4:	c791                	beqz	a5,8000a1f0 <.L67>
8000a1e6:	00b14703          	lbu	a4,11(sp)
8000a1ea:	4791                	li	a5,4
8000a1ec:	00e7f463          	bgeu	a5,a4,8000a1f4 <.L68>

8000a1f0 <.L67>:
        return status_invalid_argument;
8000a1f0:	4789                	li	a5,2
8000a1f2:	aa35                	j	8000a32e <.L69>

8000a1f4 <.L68>:
    }
    uint32_t fbdiv, frac, refdiv, postdiv, refclk, freq;
    if (ptr->PLL[pll].CFG1 & PLLCTL_PLL_CFG1_PLLPD_SW_MASK) {
8000a1f4:	00b14783          	lbu	a5,11(sp)
8000a1f8:	4732                	lw	a4,12(sp)
8000a1fa:	0785                	add	a5,a5,1
8000a1fc:	079e                	sll	a5,a5,0x7
8000a1fe:	97ba                	add	a5,a5,a4
8000a200:	43d8                	lw	a4,4(a5)
8000a202:	020007b7          	lui	a5,0x2000
8000a206:	8ff9                	and	a5,a5,a4
8000a208:	c399                	beqz	a5,8000a20e <.L70>
        /* pll is powered down */
        return 0;
8000a20a:	4781                	li	a5,0
8000a20c:	a20d                	j	8000a32e <.L69>

8000a20e <.L70>:
    }

    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
8000a20e:	00b14783          	lbu	a5,11(sp)
8000a212:	4732                	lw	a4,12(sp)
8000a214:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
8000a216:	079e                	sll	a5,a5,0x7
8000a218:	97ba                	add	a5,a5,a4
8000a21a:	439c                	lw	a5,0(a5)
8000a21c:	83e1                	srl	a5,a5,0x18
8000a21e:	03f7f793          	and	a5,a5,63
8000a222:	d43e                	sw	a5,40(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
8000a224:	00b14783          	lbu	a5,11(sp)
8000a228:	4732                	lw	a4,12(sp)
8000a22a:	0785                	add	a5,a5,1
8000a22c:	079e                	sll	a5,a5,0x7
8000a22e:	97ba                	add	a5,a5,a4
8000a230:	439c                	lw	a5,0(a5)
8000a232:	83d1                	srl	a5,a5,0x14
8000a234:	8b9d                	and	a5,a5,7
8000a236:	d23e                	sw	a5,36(sp)
    refclk = PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv);
8000a238:	5722                	lw	a4,40(sp)
8000a23a:	5792                	lw	a5,36(sp)
8000a23c:	02f707b3          	mul	a5,a4,a5
8000a240:	016e3737          	lui	a4,0x16e3
8000a244:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000a248:	02f757b3          	divu	a5,a4,a5
8000a24c:	d03e                	sw	a5,32(sp)

    if (ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK) {
8000a24e:	00b14783          	lbu	a5,11(sp)
8000a252:	4732                	lw	a4,12(sp)
8000a254:	0785                	add	a5,a5,1
8000a256:	079e                	sll	a5,a5,0x7
8000a258:	97ba                	add	a5,a5,a4
8000a25a:	439c                	lw	a5,0(a5)
8000a25c:	8ba1                	and	a5,a5,8
8000a25e:	c395                	beqz	a5,8000a282 <.L71>
        /* pll int mode */
        fbdiv = PLLCTL_PLL_CFG2_FBDIV_INT_GET(ptr->PLL[pll].CFG2);
8000a260:	00b14783          	lbu	a5,11(sp)
8000a264:	4732                	lw	a4,12(sp)
8000a266:	0785                	add	a5,a5,1
8000a268:	079e                	sll	a5,a5,0x7
8000a26a:	97ba                	add	a5,a5,a4
8000a26c:	4798                	lw	a4,8(a5)
8000a26e:	6785                	lui	a5,0x1
8000a270:	17fd                	add	a5,a5,-1 # fff <.L27+0x1c5>
8000a272:	8ff9                	and	a5,a5,a4
8000a274:	ce3e                	sw	a5,28(sp)
        freq = refclk * fbdiv;
8000a276:	5702                	lw	a4,32(sp)
8000a278:	47f2                	lw	a5,28(sp)
8000a27a:	02f707b3          	mul	a5,a4,a5
8000a27e:	d63e                	sw	a5,44(sp)
8000a280:	a075                	j	8000a32c <.L72>

8000a282 <.L71>:
    } else {
        /* pll frac mode */
        fbdiv = PLLCTL_PLL_FREQ_FBDIV_FRAC_GET(ptr->PLL[pll].FREQ);
8000a282:	00b14783          	lbu	a5,11(sp)
8000a286:	4732                	lw	a4,12(sp)
8000a288:	0785                	add	a5,a5,1
8000a28a:	079e                	sll	a5,a5,0x7
8000a28c:	97ba                	add	a5,a5,a4
8000a28e:	47dc                	lw	a5,12(a5)
8000a290:	0ff7f793          	zext.b	a5,a5
8000a294:	ce3e                	sw	a5,28(sp)
        frac = PLLCTL_PLL_FREQ_FRAC_GET(ptr->PLL[pll].FREQ);
8000a296:	00b14783          	lbu	a5,11(sp)
8000a29a:	4732                	lw	a4,12(sp)
8000a29c:	0785                	add	a5,a5,1
8000a29e:	079e                	sll	a5,a5,0x7
8000a2a0:	97ba                	add	a5,a5,a4
8000a2a2:	47dc                	lw	a5,12(a5)
8000a2a4:	0087d713          	srl	a4,a5,0x8
8000a2a8:	010007b7          	lui	a5,0x1000
8000a2ac:	17fd                	add	a5,a5,-1 # ffffff <_flash_size+0x7fffff>
8000a2ae:	8ff9                	and	a5,a5,a4
8000a2b0:	cc3e                	sw	a5,24(sp)
        freq = (uint32_t)((refclk * (fbdiv + ((double) frac / (1 << 24)))) + 0.5);
8000a2b2:	5502                	lw	a0,32(sp)
8000a2b4:	1ff020ef          	jal	8000ccb2 <__floatunsidf>
8000a2b8:	842a                	mv	s0,a0
8000a2ba:	84ae                	mv	s1,a1
8000a2bc:	4572                	lw	a0,28(sp)
8000a2be:	1f5020ef          	jal	8000ccb2 <__floatunsidf>
8000a2c2:	892a                	mv	s2,a0
8000a2c4:	89ae                	mv	s3,a1
8000a2c6:	4562                	lw	a0,24(sp)
8000a2c8:	1eb020ef          	jal	8000ccb2 <__floatunsidf>
8000a2cc:	872a                	mv	a4,a0
8000a2ce:	87ae                	mv	a5,a1
8000a2d0:	800036b7          	lui	a3,0x80003
8000a2d4:	0886a603          	lw	a2,136(a3) # 80003088 <.LC1>
8000a2d8:	08c6a683          	lw	a3,140(a3)
8000a2dc:	853a                	mv	a0,a4
8000a2de:	85be                	mv	a1,a5
8000a2e0:	786020ef          	jal	8000ca66 <__divdf3>
8000a2e4:	872a                	mv	a4,a0
8000a2e6:	87ae                	mv	a5,a1
8000a2e8:	863a                	mv	a2,a4
8000a2ea:	86be                	mv	a3,a5
8000a2ec:	854a                	mv	a0,s2
8000a2ee:	85ce                	mv	a1,s3
8000a2f0:	1da020ef          	jal	8000c4ca <__adddf3>
8000a2f4:	872a                	mv	a4,a0
8000a2f6:	87ae                	mv	a5,a1
8000a2f8:	863a                	mv	a2,a4
8000a2fa:	86be                	mv	a3,a5
8000a2fc:	8522                	mv	a0,s0
8000a2fe:	85a6                	mv	a1,s1
8000a300:	552020ef          	jal	8000c852 <__muldf3>
8000a304:	872a                	mv	a4,a0
8000a306:	87ae                	mv	a5,a1
8000a308:	853a                	mv	a0,a4
8000a30a:	85be                	mv	a1,a5
8000a30c:	800037b7          	lui	a5,0x80003
8000a310:	0907a603          	lw	a2,144(a5) # 80003090 <.LC2>
8000a314:	0947a683          	lw	a3,148(a5)
8000a318:	1b2020ef          	jal	8000c4ca <__adddf3>
8000a31c:	872a                	mv	a4,a0
8000a31e:	87ae                	mv	a5,a1
8000a320:	853a                	mv	a0,a4
8000a322:	85be                	mv	a1,a5
8000a324:	bbafe0ef          	jal	800086de <__fixunsdfsi>
8000a328:	87aa                	mv	a5,a0
8000a32a:	d63e                	sw	a5,44(sp)

8000a32c <.L72>:
    }
    return freq;
8000a32c:	57b2                	lw	a5,44(sp)

8000a32e <.L69>:
}
8000a32e:	853e                	mv	a0,a5
8000a330:	40b6                	lw	ra,76(sp)
8000a332:	4426                	lw	s0,72(sp)
8000a334:	4496                	lw	s1,68(sp)
8000a336:	4906                	lw	s2,64(sp)
8000a338:	59f2                	lw	s3,60(sp)
8000a33a:	6161                	add	sp,sp,80
8000a33c:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

8000a33e <write_pmp_cfg>:
{
8000a33e:	1141                	add	sp,sp,-16
8000a340:	c62a                	sw	a0,12(sp)
8000a342:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000a344:	4722                	lw	a4,8(sp)
8000a346:	478d                	li	a5,3
8000a348:	04f70163          	beq	a4,a5,8000a38a <.L11>
8000a34c:	4722                	lw	a4,8(sp)
8000a34e:	478d                	li	a5,3
8000a350:	04e7e163          	bltu	a5,a4,8000a392 <.L17>
8000a354:	4722                	lw	a4,8(sp)
8000a356:	4789                	li	a5,2
8000a358:	02f70563          	beq	a4,a5,8000a382 <.L13>
8000a35c:	4722                	lw	a4,8(sp)
8000a35e:	4789                	li	a5,2
8000a360:	02e7e963          	bltu	a5,a4,8000a392 <.L17>
8000a364:	47a2                	lw	a5,8(sp)
8000a366:	c791                	beqz	a5,8000a372 <.L14>
8000a368:	4722                	lw	a4,8(sp)
8000a36a:	4785                	li	a5,1
8000a36c:	00f70763          	beq	a4,a5,8000a37a <.L15>
        break;
8000a370:	a00d                	j	8000a392 <.L17>

8000a372 <.L14>:
        write_csr(CSR_PMPCFG0, value);
8000a372:	47b2                	lw	a5,12(sp)
8000a374:	3a079073          	csrw	pmpcfg0,a5
        break;
8000a378:	a831                	j	8000a394 <.L16>

8000a37a <.L15>:
        write_csr(CSR_PMPCFG1, value);
8000a37a:	47b2                	lw	a5,12(sp)
8000a37c:	3a179073          	csrw	pmpcfg1,a5
        break;
8000a380:	a811                	j	8000a394 <.L16>

8000a382 <.L13>:
        write_csr(CSR_PMPCFG2, value);
8000a382:	47b2                	lw	a5,12(sp)
8000a384:	3a279073          	csrw	pmpcfg2,a5
        break;
8000a388:	a031                	j	8000a394 <.L16>

8000a38a <.L11>:
        write_csr(CSR_PMPCFG3, value);
8000a38a:	47b2                	lw	a5,12(sp)
8000a38c:	3a379073          	csrw	pmpcfg3,a5
        break;
8000a390:	a011                	j	8000a394 <.L16>

8000a392 <.L17>:
        break;
8000a392:	0001                	nop

8000a394 <.L16>:
}
8000a394:	0001                	nop
8000a396:	0141                	add	sp,sp,16
8000a398:	8082                	ret

Disassembly of section .text.write_pma_cfg:

8000a39a <write_pma_cfg>:
{
8000a39a:	1141                	add	sp,sp,-16
8000a39c:	c62a                	sw	a0,12(sp)
8000a39e:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000a3a0:	4722                	lw	a4,8(sp)
8000a3a2:	478d                	li	a5,3
8000a3a4:	04f70163          	beq	a4,a5,8000a3e6 <.L71>
8000a3a8:	4722                	lw	a4,8(sp)
8000a3aa:	478d                	li	a5,3
8000a3ac:	04e7e163          	bltu	a5,a4,8000a3ee <.L77>
8000a3b0:	4722                	lw	a4,8(sp)
8000a3b2:	4789                	li	a5,2
8000a3b4:	02f70563          	beq	a4,a5,8000a3de <.L73>
8000a3b8:	4722                	lw	a4,8(sp)
8000a3ba:	4789                	li	a5,2
8000a3bc:	02e7e963          	bltu	a5,a4,8000a3ee <.L77>
8000a3c0:	47a2                	lw	a5,8(sp)
8000a3c2:	c791                	beqz	a5,8000a3ce <.L74>
8000a3c4:	4722                	lw	a4,8(sp)
8000a3c6:	4785                	li	a5,1
8000a3c8:	00f70763          	beq	a4,a5,8000a3d6 <.L75>
        break;
8000a3cc:	a00d                	j	8000a3ee <.L77>

8000a3ce <.L74>:
        write_csr(CSR_PMACFG0, value);
8000a3ce:	47b2                	lw	a5,12(sp)
8000a3d0:	bc079073          	csrw	0xbc0,a5
        break;
8000a3d4:	a831                	j	8000a3f0 <.L76>

8000a3d6 <.L75>:
        write_csr(CSR_PMACFG1, value);
8000a3d6:	47b2                	lw	a5,12(sp)
8000a3d8:	bc179073          	csrw	0xbc1,a5
        break;
8000a3dc:	a811                	j	8000a3f0 <.L76>

8000a3de <.L73>:
        write_csr(CSR_PMACFG2, value);
8000a3de:	47b2                	lw	a5,12(sp)
8000a3e0:	bc279073          	csrw	0xbc2,a5
        break;
8000a3e4:	a031                	j	8000a3f0 <.L76>

8000a3e6 <.L71>:
        write_csr(CSR_PMACFG3, value);
8000a3e6:	47b2                	lw	a5,12(sp)
8000a3e8:	bc379073          	csrw	0xbc3,a5
        break;
8000a3ec:	a011                	j	8000a3f0 <.L76>

8000a3ee <.L77>:
        break;
8000a3ee:	0001                	nop

8000a3f0 <.L76>:
}
8000a3f0:	0001                	nop
8000a3f2:	0141                	add	sp,sp,16
8000a3f4:	8082                	ret

Disassembly of section .text.uart_modem_config:

8000a3f6 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
8000a3f6:	1141                	add	sp,sp,-16
8000a3f8:	c62a                	sw	a0,12(sp)
8000a3fa:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
8000a3fc:	47a2                	lw	a5,8(sp)
8000a3fe:	0007c783          	lbu	a5,0(a5)
8000a402:	0796                	sll	a5,a5,0x5
8000a404:	0207f713          	and	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
8000a408:	47a2                	lw	a5,8(sp)
8000a40a:	0017c783          	lbu	a5,1(a5)
8000a40e:	0792                	sll	a5,a5,0x4
8000a410:	8bc1                	and	a5,a5,16
8000a412:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
8000a414:	47a2                	lw	a5,8(sp)
8000a416:	0027c783          	lbu	a5,2(a5)
8000a41a:	0017c793          	xor	a5,a5,1
8000a41e:	0ff7f793          	zext.b	a5,a5
8000a422:	0786                	sll	a5,a5,0x1
8000a424:	8b89                	and	a5,a5,2
8000a426:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
8000a428:	47b2                	lw	a5,12(sp)
8000a42a:	db98                	sw	a4,48(a5)
}
8000a42c:	0001                	nop
8000a42e:	0141                	add	sp,sp,16
8000a430:	8082                	ret

Disassembly of section .text.uart_init:

8000a432 <uart_init>:
{
8000a432:	7179                	add	sp,sp,-48
8000a434:	d606                	sw	ra,44(sp)
8000a436:	c62a                	sw	a0,12(sp)
8000a438:	c42e                	sw	a1,8(sp)
    ptr->IER = 0;
8000a43a:	47b2                	lw	a5,12(sp)
8000a43c:	0207a223          	sw	zero,36(a5)
    ptr->LCR |= UART_LCR_DLAB_MASK;
8000a440:	47b2                	lw	a5,12(sp)
8000a442:	57dc                	lw	a5,44(a5)
8000a444:	0807e713          	or	a4,a5,128
8000a448:	47b2                	lw	a5,12(sp)
8000a44a:	d7d8                	sw	a4,44(a5)
    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
8000a44c:	47a2                	lw	a5,8(sp)
8000a44e:	4398                	lw	a4,0(a5)
8000a450:	47a2                	lw	a5,8(sp)
8000a452:	43dc                	lw	a5,4(a5)
8000a454:	01b10693          	add	a3,sp,27
8000a458:	0830                	add	a2,sp,24
8000a45a:	85be                	mv	a1,a5
8000a45c:	853a                	mv	a0,a4
8000a45e:	af0fb0ef          	jal	8000574e <uart_calculate_baudrate>
8000a462:	87aa                	mv	a5,a0
8000a464:	0017c793          	xor	a5,a5,1
8000a468:	0ff7f793          	zext.b	a5,a5
8000a46c:	c781                	beqz	a5,8000a474 <.L25>
        return status_uart_no_suitable_baudrate_parameter_found;
8000a46e:	3e900793          	li	a5,1001
8000a472:	aa2d                	j	8000a5ac <.L41>

8000a474 <.L25>:
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
8000a474:	47b2                	lw	a5,12(sp)
8000a476:	4bdc                	lw	a5,20(a5)
8000a478:	fe07f713          	and	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
8000a47c:	01b14783          	lbu	a5,27(sp)
8000a480:	8bfd                	and	a5,a5,31
8000a482:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
8000a484:	47b2                	lw	a5,12(sp)
8000a486:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
8000a488:	01815783          	lhu	a5,24(sp)
8000a48c:	0ff7f713          	zext.b	a4,a5
8000a490:	47b2                	lw	a5,12(sp)
8000a492:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
8000a494:	01815783          	lhu	a5,24(sp)
8000a498:	83a1                	srl	a5,a5,0x8
8000a49a:	07c2                	sll	a5,a5,0x10
8000a49c:	83c1                	srl	a5,a5,0x10
8000a49e:	0ff7f713          	zext.b	a4,a5
8000a4a2:	47b2                	lw	a5,12(sp)
8000a4a4:	d3d8                	sw	a4,36(a5)
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
8000a4a6:	47b2                	lw	a5,12(sp)
8000a4a8:	57dc                	lw	a5,44(a5)
8000a4aa:	f7f7f793          	and	a5,a5,-129
8000a4ae:	ce3e                	sw	a5,28(sp)
    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
8000a4b0:	47f2                	lw	a5,28(sp)
8000a4b2:	fc77f793          	and	a5,a5,-57
8000a4b6:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
8000a4b8:	47a2                	lw	a5,8(sp)
8000a4ba:	00a7c783          	lbu	a5,10(a5)
8000a4be:	4711                	li	a4,4
8000a4c0:	02f76f63          	bltu	a4,a5,8000a4fe <.L27>
8000a4c4:	00279713          	sll	a4,a5,0x2
8000a4c8:	800037b7          	lui	a5,0x80003
8000a4cc:	26078793          	add	a5,a5,608 # 80003260 <.L29>
8000a4d0:	97ba                	add	a5,a5,a4
8000a4d2:	439c                	lw	a5,0(a5)
8000a4d4:	8782                	jr	a5

8000a4d6 <.L32>:
        tmp |= UART_LCR_PEN_MASK;
8000a4d6:	47f2                	lw	a5,28(sp)
8000a4d8:	0087e793          	or	a5,a5,8
8000a4dc:	ce3e                	sw	a5,28(sp)
        break;
8000a4de:	a01d                	j	8000a504 <.L34>

8000a4e0 <.L31>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
8000a4e0:	47f2                	lw	a5,28(sp)
8000a4e2:	0187e793          	or	a5,a5,24
8000a4e6:	ce3e                	sw	a5,28(sp)
        break;
8000a4e8:	a831                	j	8000a504 <.L34>

8000a4ea <.L30>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
8000a4ea:	47f2                	lw	a5,28(sp)
8000a4ec:	0287e793          	or	a5,a5,40
8000a4f0:	ce3e                	sw	a5,28(sp)
        break;
8000a4f2:	a809                	j	8000a504 <.L34>

8000a4f4 <.L28>:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
8000a4f4:	47f2                	lw	a5,28(sp)
8000a4f6:	0387e793          	or	a5,a5,56
8000a4fa:	ce3e                	sw	a5,28(sp)
        break;
8000a4fc:	a021                	j	8000a504 <.L34>

8000a4fe <.L27>:
        return status_invalid_argument;
8000a4fe:	4789                	li	a5,2
8000a500:	a075                	j	8000a5ac <.L41>

8000a502 <.L42>:
        break;
8000a502:	0001                	nop

8000a504 <.L34>:
    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
8000a504:	47f2                	lw	a5,28(sp)
8000a506:	9be1                	and	a5,a5,-8
8000a508:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
8000a50a:	47a2                	lw	a5,8(sp)
8000a50c:	0087c783          	lbu	a5,8(a5)
8000a510:	4709                	li	a4,2
8000a512:	00e78e63          	beq	a5,a4,8000a52e <.L35>
8000a516:	4709                	li	a4,2
8000a518:	02f74663          	blt	a4,a5,8000a544 <.L36>
8000a51c:	c795                	beqz	a5,8000a548 <.L43>
8000a51e:	4705                	li	a4,1
8000a520:	02e79263          	bne	a5,a4,8000a544 <.L36>
        tmp |= UART_LCR_STB_MASK;
8000a524:	47f2                	lw	a5,28(sp)
8000a526:	0047e793          	or	a5,a5,4
8000a52a:	ce3e                	sw	a5,28(sp)
        break;
8000a52c:	a839                	j	8000a54a <.L39>

8000a52e <.L35>:
        if (config->word_length < word_length_6_bits) {
8000a52e:	47a2                	lw	a5,8(sp)
8000a530:	0097c783          	lbu	a5,9(a5)
8000a534:	e399                	bnez	a5,8000a53a <.L40>
            return status_invalid_argument;
8000a536:	4789                	li	a5,2
8000a538:	a895                	j	8000a5ac <.L41>

8000a53a <.L40>:
        tmp |= UART_LCR_STB_MASK;
8000a53a:	47f2                	lw	a5,28(sp)
8000a53c:	0047e793          	or	a5,a5,4
8000a540:	ce3e                	sw	a5,28(sp)
        break;
8000a542:	a021                	j	8000a54a <.L39>

8000a544 <.L36>:
        return status_invalid_argument;
8000a544:	4789                	li	a5,2
8000a546:	a09d                	j	8000a5ac <.L41>

8000a548 <.L43>:
        break;
8000a548:	0001                	nop

8000a54a <.L39>:
    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
8000a54a:	47a2                	lw	a5,8(sp)
8000a54c:	0097c783          	lbu	a5,9(a5)
8000a550:	0037f713          	and	a4,a5,3
8000a554:	47f2                	lw	a5,28(sp)
8000a556:	8f5d                	or	a4,a4,a5
8000a558:	47b2                	lw	a5,12(sp)
8000a55a:	d7d8                	sw	a4,44(a5)
    ptr->FCR = UART_FCR_TFIFORST_MASK | UART_FCR_RFIFORST_MASK;
8000a55c:	47b2                	lw	a5,12(sp)
8000a55e:	4719                	li	a4,6
8000a560:	d798                	sw	a4,40(a5)
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
8000a562:	47a2                	lw	a5,8(sp)
8000a564:	00e7c783          	lbu	a5,14(a5)
8000a568:	873e                	mv	a4,a5
        | UART_FCR_TFIFOT_SET(config->tx_fifo_level)
8000a56a:	47a2                	lw	a5,8(sp)
8000a56c:	00b7c783          	lbu	a5,11(a5)
8000a570:	0792                	sll	a5,a5,0x4
8000a572:	0307f793          	and	a5,a5,48
8000a576:	8f5d                	or	a4,a4,a5
        | UART_FCR_RFIFOT_SET(config->rx_fifo_level)
8000a578:	47a2                	lw	a5,8(sp)
8000a57a:	00c7c783          	lbu	a5,12(a5)
8000a57e:	079a                	sll	a5,a5,0x6
8000a580:	0ff7f793          	zext.b	a5,a5
8000a584:	8f5d                	or	a4,a4,a5
        | UART_FCR_DMAE_SET(config->dma_enable);
8000a586:	47a2                	lw	a5,8(sp)
8000a588:	00d7c783          	lbu	a5,13(a5)
8000a58c:	078e                	sll	a5,a5,0x3
8000a58e:	8ba1                	and	a5,a5,8
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
8000a590:	8fd9                	or	a5,a5,a4
8000a592:	ce3e                	sw	a5,28(sp)
    ptr->FCR = tmp;
8000a594:	47b2                	lw	a5,12(sp)
8000a596:	4772                	lw	a4,28(sp)
8000a598:	d798                	sw	a4,40(a5)
    ptr->GPR = tmp;
8000a59a:	47b2                	lw	a5,12(sp)
8000a59c:	4772                	lw	a4,28(sp)
8000a59e:	dfd8                	sw	a4,60(a5)
    uart_modem_config(ptr, &config->modem_config);
8000a5a0:	47a2                	lw	a5,8(sp)
8000a5a2:	07bd                	add	a5,a5,15
8000a5a4:	85be                	mv	a1,a5
8000a5a6:	4532                	lw	a0,12(sp)
8000a5a8:	35b9                	jal	8000a3f6 <uart_modem_config>
    return status_success;
8000a5aa:	4781                	li	a5,0

8000a5ac <.L41>:
}
8000a5ac:	853e                	mv	a0,a5
8000a5ae:	50b2                	lw	ra,44(sp)
8000a5b0:	6145                	add	sp,sp,48
8000a5b2:	8082                	ret

Disassembly of section .text.uart_flush:

8000a5b4 <uart_flush>:

hpm_stat_t uart_flush(UART_Type *ptr)
{
8000a5b4:	1101                	add	sp,sp,-32
8000a5b6:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
8000a5b8:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
8000a5ba:	a811                	j	8000a5ce <.L57>

8000a5bc <.L60>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000a5bc:	4772                	lw	a4,28(sp)
8000a5be:	6785                	lui	a5,0x1
8000a5c0:	38878793          	add	a5,a5,904 # 1388 <.L22+0xc>
8000a5c4:	00e7eb63          	bltu	a5,a4,8000a5da <.L63>
            break;
        }
        retry++;
8000a5c8:	47f2                	lw	a5,28(sp)
8000a5ca:	0785                	add	a5,a5,1
8000a5cc:	ce3e                	sw	a5,28(sp)

8000a5ce <.L57>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
8000a5ce:	47b2                	lw	a5,12(sp)
8000a5d0:	5bdc                	lw	a5,52(a5)
8000a5d2:	0407f793          	and	a5,a5,64
8000a5d6:	d3fd                	beqz	a5,8000a5bc <.L60>
8000a5d8:	a011                	j	8000a5dc <.L59>

8000a5da <.L63>:
            break;
8000a5da:	0001                	nop

8000a5dc <.L59>:
    }
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000a5dc:	4772                	lw	a4,28(sp)
8000a5de:	6785                	lui	a5,0x1
8000a5e0:	38878793          	add	a5,a5,904 # 1388 <.L22+0xc>
8000a5e4:	00e7f463          	bgeu	a5,a4,8000a5ec <.L61>
        return status_timeout;
8000a5e8:	478d                	li	a5,3
8000a5ea:	a011                	j	8000a5ee <.L62>

8000a5ec <.L61>:
    }

    return status_success;
8000a5ec:	4781                	li	a5,0

8000a5ee <.L62>:
}
8000a5ee:	853e                	mv	a0,a5
8000a5f0:	6105                	add	sp,sp,32
8000a5f2:	8082                	ret

Disassembly of section .text.usb_phy_enable_dp_dm_pulldown:

8000a5f4 <usb_phy_enable_dp_dm_pulldown>:
{
8000a5f4:	1141                	add	sp,sp,-16
8000a5f6:	c62a                	sw	a0,12(sp)
    ptr->PHY_CTRL0 &= ~0x001000E0u;
8000a5f8:	47b2                	lw	a5,12(sp)
8000a5fa:	2107a703          	lw	a4,528(a5)
8000a5fe:	fff007b7          	lui	a5,0xfff00
8000a602:	f1f78793          	add	a5,a5,-225 # ffefff1f <__APB_SRAM_segment_end__+0xbe0df1f>
8000a606:	8f7d                	and	a4,a4,a5
8000a608:	47b2                	lw	a5,12(sp)
8000a60a:	20e7a823          	sw	a4,528(a5)
}
8000a60e:	0001                	nop
8000a610:	0141                	add	sp,sp,16
8000a612:	8082                	ret

Disassembly of section .text.usb_phy_deinit:

8000a614 <usb_phy_deinit>:
{
8000a614:	1101                	add	sp,sp,-32
8000a616:	c62a                	sw	a0,12(sp)
    ptr->PHY_CTRL1 &= ~USB_PHY_CTRL1_UTMI_OTG_SUSPENDM_MASK;       /* clear otg_suspendm */
8000a618:	47b2                	lw	a5,12(sp)
8000a61a:	2147a783          	lw	a5,532(a5)
8000a61e:	ffd7f713          	and	a4,a5,-3
8000a622:	47b2                	lw	a5,12(sp)
8000a624:	20e7aa23          	sw	a4,532(a5)
    ptr->PHY_CTRL1 &= ~USB_PHY_CTRL1_UTMI_CFG_RST_N_MASK;          /* clear cfg_rst_n */
8000a628:	47b2                	lw	a5,12(sp)
8000a62a:	2147a703          	lw	a4,532(a5)
8000a62e:	fff007b7          	lui	a5,0xfff00
8000a632:	17fd                	add	a5,a5,-1 # ffefffff <__APB_SRAM_segment_end__+0xbe0dfff>
8000a634:	8f7d                	and	a4,a4,a5
8000a636:	47b2                	lw	a5,12(sp)
8000a638:	20e7aa23          	sw	a4,532(a5)
    ptr->OTG_CTRL0 |= USB_OTG_CTRL0_OTG_UTMI_RESET_SW_MASK;        /* set otg_utmi_reset_sw for naneng usbphy */
8000a63c:	47b2                	lw	a5,12(sp)
8000a63e:	2007a703          	lw	a4,512(a5)
8000a642:	6785                	lui	a5,0x1
8000a644:	80078793          	add	a5,a5,-2048 # 800 <.L133+0x14>
8000a648:	8f5d                	or	a4,a4,a5
8000a64a:	47b2                	lw	a5,12(sp)
8000a64c:	20e7a023          	sw	a4,512(a5)

8000a650 <.LBB2>:
    for (volatile uint32_t i = 0; i < USB_PHY_INIT_DELAY_COUNT; i++) {
8000a650:	cc02                	sw	zero,24(sp)
8000a652:	a039                	j	8000a660 <.L13>

8000a654 <.L14>:
        (void)ptr->PHY_CTRL1;                                      /* used for delay, at least 1us */
8000a654:	47b2                	lw	a5,12(sp)
8000a656:	2147a783          	lw	a5,532(a5)
    for (volatile uint32_t i = 0; i < USB_PHY_INIT_DELAY_COUNT; i++) {
8000a65a:	47e2                	lw	a5,24(sp)
8000a65c:	0785                	add	a5,a5,1
8000a65e:	cc3e                	sw	a5,24(sp)

8000a660 <.L13>:
8000a660:	4762                	lw	a4,24(sp)
8000a662:	06300793          	li	a5,99
8000a666:	fee7f7e3          	bgeu	a5,a4,8000a654 <.L14>

8000a66a <.LBE2>:
    ptr->OTG_CTRL0 &= ~USB_OTG_CTRL0_OTG_UTMI_SUSPENDM_SW_MASK;     /* clear otg_utmi_suspend_m for naneng usbphy */
8000a66a:	47b2                	lw	a5,12(sp)
8000a66c:	2007a703          	lw	a4,512(a5)
8000a670:	77fd                	lui	a5,0xfffff
8000a672:	17fd                	add	a5,a5,-1 # ffffefff <__APB_SRAM_segment_end__+0xbf0cfff>
8000a674:	8f7d                	and	a4,a4,a5
8000a676:	47b2                	lw	a5,12(sp)
8000a678:	20e7a023          	sw	a4,512(a5)

8000a67c <.L15>:
        status = USB_OTG_CTRL0_OTG_UTMI_RESET_SW_GET(ptr->OTG_CTRL0); /* wait for reset status */
8000a67c:	47b2                	lw	a5,12(sp)
8000a67e:	2007a783          	lw	a5,512(a5)
8000a682:	83ad                	srl	a5,a5,0xb
8000a684:	8b85                	and	a5,a5,1
8000a686:	ce3e                	sw	a5,28(sp)
    } while (status == 0);
8000a688:	47f2                	lw	a5,28(sp)
8000a68a:	dbed                	beqz	a5,8000a67c <.L15>
}
8000a68c:	0001                	nop
8000a68e:	0001                	nop
8000a690:	6105                	add	sp,sp,32
8000a692:	8082                	ret

Disassembly of section .text.usb_phy_init:

8000a694 <usb_phy_init>:
{
8000a694:	7179                	add	sp,sp,-48
8000a696:	d606                	sw	ra,44(sp)
8000a698:	c62a                	sw	a0,12(sp)
8000a69a:	87ae                	mv	a5,a1
8000a69c:	00f105a3          	sb	a5,11(sp)
    usb_phy_deinit(ptr);
8000a6a0:	4532                	lw	a0,12(sp)
8000a6a2:	3f8d                	jal	8000a614 <usb_phy_deinit>
    usb_phy_enable_dp_dm_pulldown(ptr);
8000a6a4:	4532                	lw	a0,12(sp)
8000a6a6:	37b9                	jal	8000a5f4 <usb_phy_enable_dp_dm_pulldown>
    ptr->OTG_CTRL0 |= USB_OTG_CTRL0_OTG_UTMI_SUSPENDM_SW_MASK;        /* set otg_utmi_suspend_m for naneng usbphy */
8000a6a8:	47b2                	lw	a5,12(sp)
8000a6aa:	2007a703          	lw	a4,512(a5)
8000a6ae:	6785                	lui	a5,0x1
8000a6b0:	8f5d                	or	a4,a4,a5
8000a6b2:	47b2                	lw	a5,12(sp)
8000a6b4:	20e7a023          	sw	a4,512(a5) # 1200 <.L200+0x2c>

8000a6b8 <.LBB3>:
    for (volatile uint32_t i = 0; i < USB_PHY_INIT_DELAY_COUNT; i++) {
8000a6b8:	cc02                	sw	zero,24(sp)
8000a6ba:	a039                	j	8000a6c8 <.L17>

8000a6bc <.L18>:
        (void)ptr->PHY_CTRL1;                                         /* used for delay, at least 1us */
8000a6bc:	47b2                	lw	a5,12(sp)
8000a6be:	2147a783          	lw	a5,532(a5)
    for (volatile uint32_t i = 0; i < USB_PHY_INIT_DELAY_COUNT; i++) {
8000a6c2:	47e2                	lw	a5,24(sp)
8000a6c4:	0785                	add	a5,a5,1
8000a6c6:	cc3e                	sw	a5,24(sp)

8000a6c8 <.L17>:
8000a6c8:	4762                	lw	a4,24(sp)
8000a6ca:	06300793          	li	a5,99
8000a6ce:	fee7f7e3          	bgeu	a5,a4,8000a6bc <.L18>

8000a6d2 <.LBE3>:
    ptr->OTG_CTRL0 &= ~USB_OTG_CTRL0_OTG_UTMI_RESET_SW_MASK;          /* clear otg_utmi_reset_sw for naneng usbphy */
8000a6d2:	47b2                	lw	a5,12(sp)
8000a6d4:	2007a703          	lw	a4,512(a5)
8000a6d8:	77fd                	lui	a5,0xfffff
8000a6da:	7ff78793          	add	a5,a5,2047 # fffff7ff <__APB_SRAM_segment_end__+0xbf0d7ff>
8000a6de:	8f7d                	and	a4,a4,a5
8000a6e0:	47b2                	lw	a5,12(sp)
8000a6e2:	20e7a023          	sw	a4,512(a5)
    ptr->OTG_CTRL0 &= ~USB_OTG_CTRL0_OTG_WKDPDMCHG_EN_MASK;           /* Disable dp/dm wakeup */
8000a6e6:	47b2                	lw	a5,12(sp)
8000a6e8:	2007a703          	lw	a4,512(a5)
8000a6ec:	fe0007b7          	lui	a5,0xfe000
8000a6f0:	17fd                	add	a5,a5,-1 # fdffffff <__APB_SRAM_segment_end__+0x9f0dfff>
8000a6f2:	8f7d                	and	a4,a4,a5
8000a6f4:	47b2                	lw	a5,12(sp)
8000a6f6:	20e7a023          	sw	a4,512(a5)
    ptr->PHY_STATUS |= USB_PHY_STATUS_UTMI_CLK_VALID_MASK;            /* write 1 to clear valid status */
8000a6fa:	47b2                	lw	a5,12(sp)
8000a6fc:	2247a703          	lw	a4,548(a5)
8000a700:	800007b7          	lui	a5,0x80000
8000a704:	8f5d                	or	a4,a4,a5
8000a706:	47b2                	lw	a5,12(sp)
8000a708:	22e7a223          	sw	a4,548(a5) # 80000224 <__SHARE_RAM_segment_end__+0x7ee80224>

8000a70c <.L19>:
        status = USB_PHY_STATUS_UTMI_CLK_VALID_GET(ptr->PHY_STATUS);  /* get utmi clock status */
8000a70c:	47b2                	lw	a5,12(sp)
8000a70e:	2247a783          	lw	a5,548(a5)
8000a712:	83fd                	srl	a5,a5,0x1f
8000a714:	8b85                	and	a5,a5,1
8000a716:	ce3e                	sw	a5,28(sp)
    } while (status == 0);
8000a718:	47f2                	lw	a5,28(sp)
8000a71a:	dbed                	beqz	a5,8000a70c <.L19>
    ptr->PHY_CTRL0 |= USB_PHY_CTRL0_OP_MODE_SUSPENDM_ENJ_MASK;        /* set suspendm_enj */
8000a71c:	47b2                	lw	a5,12(sp)
8000a71e:	2107a703          	lw	a4,528(a5)
8000a722:	6785                	lui	a5,0x1
8000a724:	80078793          	add	a5,a5,-2048 # 800 <.L133+0x14>
8000a728:	8f5d                	or	a4,a4,a5
8000a72a:	47b2                	lw	a5,12(sp)
8000a72c:	20e7a823          	sw	a4,528(a5)
    ptr->PHY_CTRL1 |= USB_PHY_CTRL1_UTMI_CFG_RST_N_MASK;              /* set cfg_rst_n */
8000a730:	47b2                	lw	a5,12(sp)
8000a732:	2147a703          	lw	a4,532(a5)
8000a736:	001007b7          	lui	a5,0x100
8000a73a:	8f5d                	or	a4,a4,a5
8000a73c:	47b2                	lw	a5,12(sp)
8000a73e:	20e7aa23          	sw	a4,532(a5) # 100214 <__DLM_segment_end__+0x40214>
    if (host) {
8000a742:	00b14783          	lbu	a5,11(sp)
8000a746:	cb89                	beqz	a5,8000a758 <.L21>
        ptr->PHY_CTRL1 |= USB_PHY_CTRL1_UTMI_OTG_SUSPENDM_MASK;       /* set otg_suspendm, enable high speed device disconect detect */
8000a748:	47b2                	lw	a5,12(sp)
8000a74a:	2147a783          	lw	a5,532(a5)
8000a74e:	0027e713          	or	a4,a5,2
8000a752:	47b2                	lw	a5,12(sp)
8000a754:	20e7aa23          	sw	a4,532(a5)

8000a758 <.L21>:
}
8000a758:	0001                	nop
8000a75a:	50b2                	lw	ra,44(sp)
8000a75c:	6145                	add	sp,sp,48
8000a75e:	8082                	ret

Disassembly of section .text.usb_dcd_bus_reset:

8000a760 <usb_dcd_bus_reset>:
{
8000a760:	1101                	add	sp,sp,-32
8000a762:	c62a                	sw	a0,12(sp)
8000a764:	87ae                	mv	a5,a1
8000a766:	00f11523          	sh	a5,10(sp)

8000a76a <.LBB4>:
    for (uint32_t i = 1; i < USB_SOC_DCD_MAX_ENDPOINT_COUNT; i++) {
8000a76a:	4785                	li	a5,1
8000a76c:	ce3e                	sw	a5,28(sp)
8000a76e:	a831                	j	8000a78a <.L23>

8000a770 <.L24>:
        ptr->ENDPTCTRL[i] = USB_ENDPTCTRL_TXT_SET(usb_xfer_bulk) | USB_ENDPTCTRL_RXT_SET(usb_xfer_bulk);
8000a770:	4732                	lw	a4,12(sp)
8000a772:	47f2                	lw	a5,28(sp)
8000a774:	07078793          	add	a5,a5,112
8000a778:	078a                	sll	a5,a5,0x2
8000a77a:	97ba                	add	a5,a5,a4
8000a77c:	00080737          	lui	a4,0x80
8000a780:	0721                	add	a4,a4,8 # 80008 <__AXI_SRAM_segment_size__+0x8>
8000a782:	c398                	sw	a4,0(a5)
    for (uint32_t i = 1; i < USB_SOC_DCD_MAX_ENDPOINT_COUNT; i++) {
8000a784:	47f2                	lw	a5,28(sp)
8000a786:	0785                	add	a5,a5,1
8000a788:	ce3e                	sw	a5,28(sp)

8000a78a <.L23>:
8000a78a:	4772                	lw	a4,28(sp)
8000a78c:	479d                	li	a5,7
8000a78e:	fee7f1e3          	bgeu	a5,a4,8000a770 <.L24>

8000a792 <.LBE4>:
    ptr->ENDPTNAK       = ptr->ENDPTNAK;
8000a792:	47b2                	lw	a5,12(sp)
8000a794:	1787a703          	lw	a4,376(a5)
8000a798:	47b2                	lw	a5,12(sp)
8000a79a:	16e7ac23          	sw	a4,376(a5)
    ptr->ENDPTNAKEN     = 0;
8000a79e:	47b2                	lw	a5,12(sp)
8000a7a0:	1607ae23          	sw	zero,380(a5)
    ptr->USBSTS         = ptr->USBSTS;
8000a7a4:	47b2                	lw	a5,12(sp)
8000a7a6:	1447a703          	lw	a4,324(a5)
8000a7aa:	47b2                	lw	a5,12(sp)
8000a7ac:	14e7a223          	sw	a4,324(a5)
    ptr->ENDPTSETUPSTAT = ptr->ENDPTSETUPSTAT;
8000a7b0:	47b2                	lw	a5,12(sp)
8000a7b2:	1ac7a703          	lw	a4,428(a5)
8000a7b6:	47b2                	lw	a5,12(sp)
8000a7b8:	1ae7a623          	sw	a4,428(a5)
    ptr->ENDPTCOMPLETE  = ptr->ENDPTCOMPLETE;
8000a7bc:	47b2                	lw	a5,12(sp)
8000a7be:	1bc7a703          	lw	a4,444(a5)
8000a7c2:	47b2                	lw	a5,12(sp)
8000a7c4:	1ae7ae23          	sw	a4,444(a5)
    while (ptr->ENDPTPRIME) {
8000a7c8:	0001                	nop

8000a7ca <.L25>:
8000a7ca:	47b2                	lw	a5,12(sp)
8000a7cc:	1b07a783          	lw	a5,432(a5)
8000a7d0:	ffed                	bnez	a5,8000a7ca <.L25>
    ptr->ENDPTFLUSH = 0xFFFFFFFF;
8000a7d2:	47b2                	lw	a5,12(sp)
8000a7d4:	577d                	li	a4,-1
8000a7d6:	1ae7aa23          	sw	a4,436(a5)
    while (ptr->ENDPTFLUSH) {
8000a7da:	0001                	nop

8000a7dc <.L26>:
8000a7dc:	47b2                	lw	a5,12(sp)
8000a7de:	1b47a783          	lw	a5,436(a5)
8000a7e2:	ffed                	bnez	a5,8000a7dc <.L26>
}
8000a7e4:	0001                	nop
8000a7e6:	0001                	nop
8000a7e8:	6105                	add	sp,sp,32
8000a7ea:	8082                	ret

Disassembly of section .text.usb_dcd_init:

8000a7ec <usb_dcd_init>:
{
8000a7ec:	1101                	add	sp,sp,-32
8000a7ee:	ce06                	sw	ra,28(sp)
8000a7f0:	c62a                	sw	a0,12(sp)
    usb_phy_init(ptr, false);
8000a7f2:	4581                	li	a1,0
8000a7f4:	4532                	lw	a0,12(sp)
8000a7f6:	3d79                	jal	8000a694 <usb_phy_init>
    ptr->USBCMD &= ~USB_USBCMD_RS_MASK;
8000a7f8:	47b2                	lw	a5,12(sp)
8000a7fa:	1407a783          	lw	a5,320(a5)
8000a7fe:	ffe7f713          	and	a4,a5,-2
8000a802:	47b2                	lw	a5,12(sp)
8000a804:	14e7a023          	sw	a4,320(a5)
    ptr->USBCMD |= USB_USBCMD_RST_MASK;
8000a808:	47b2                	lw	a5,12(sp)
8000a80a:	1407a783          	lw	a5,320(a5)
8000a80e:	0027e713          	or	a4,a5,2
8000a812:	47b2                	lw	a5,12(sp)
8000a814:	14e7a023          	sw	a4,320(a5)
    while (USB_USBCMD_RST_GET(ptr->USBCMD)) {
8000a818:	0001                	nop

8000a81a <.L28>:
8000a81a:	47b2                	lw	a5,12(sp)
8000a81c:	1407a783          	lw	a5,320(a5)
8000a820:	8b89                	and	a5,a5,2
8000a822:	ffe5                	bnez	a5,8000a81a <.L28>
    ptr->USBMODE &= ~USB_USBMODE_CM_MASK;
8000a824:	47b2                	lw	a5,12(sp)
8000a826:	1a87a783          	lw	a5,424(a5)
8000a82a:	ffc7f713          	and	a4,a5,-4
8000a82e:	47b2                	lw	a5,12(sp)
8000a830:	1ae7a423          	sw	a4,424(a5)
    ptr->USBMODE |= USB_USBMODE_CM_SET(2);
8000a834:	47b2                	lw	a5,12(sp)
8000a836:	1a87a783          	lw	a5,424(a5)
8000a83a:	0027e713          	or	a4,a5,2
8000a83e:	47b2                	lw	a5,12(sp)
8000a840:	1ae7a423          	sw	a4,424(a5)
    ptr->USBMODE &= ~USB_USBMODE_SLOM_MASK;
8000a844:	47b2                	lw	a5,12(sp)
8000a846:	1a87a783          	lw	a5,424(a5)
8000a84a:	ff77f713          	and	a4,a5,-9
8000a84e:	47b2                	lw	a5,12(sp)
8000a850:	1ae7a423          	sw	a4,424(a5)
    ptr->USBMODE &= ~USB_USBMODE_ES_MASK;
8000a854:	47b2                	lw	a5,12(sp)
8000a856:	1a87a783          	lw	a5,424(a5)
8000a85a:	ffb7f713          	and	a4,a5,-5
8000a85e:	47b2                	lw	a5,12(sp)
8000a860:	1ae7a423          	sw	a4,424(a5)
    ptr->PORTSC1 &= ~USB_PORTSC1_STS_MASK;
8000a864:	47b2                	lw	a5,12(sp)
8000a866:	1847a703          	lw	a4,388(a5)
8000a86a:	e00007b7          	lui	a5,0xe0000
8000a86e:	17fd                	add	a5,a5,-1 # dfffffff <__XPI0_segment_end__+0x5f7fffff>
8000a870:	8f7d                	and	a4,a4,a5
8000a872:	47b2                	lw	a5,12(sp)
8000a874:	18e7a223          	sw	a4,388(a5)
    ptr->PORTSC1 &= ~USB_PORTSC1_PTW_MASK;
8000a878:	47b2                	lw	a5,12(sp)
8000a87a:	1847a703          	lw	a4,388(a5)
8000a87e:	f00007b7          	lui	a5,0xf0000
8000a882:	17fd                	add	a5,a5,-1 # efffffff <__XPI0_segment_end__+0x6f7fffff>
8000a884:	8f7d                	and	a4,a4,a5
8000a886:	47b2                	lw	a5,12(sp)
8000a888:	18e7a223          	sw	a4,388(a5)
    ptr->USBCMD &= ~USB_USBCMD_ITC_MASK;
8000a88c:	47b2                	lw	a5,12(sp)
8000a88e:	1407a703          	lw	a4,320(a5)
8000a892:	ff0107b7          	lui	a5,0xff010
8000a896:	17fd                	add	a5,a5,-1 # ff00ffff <__APB_SRAM_segment_end__+0xaf1dfff>
8000a898:	8f7d                	and	a4,a4,a5
8000a89a:	47b2                	lw	a5,12(sp)
8000a89c:	14e7a023          	sw	a4,320(a5)
    ptr->OTGSC |= USB_OTGSC_VD_MASK;
8000a8a0:	47b2                	lw	a5,12(sp)
8000a8a2:	1a47a783          	lw	a5,420(a5)
8000a8a6:	0017e713          	or	a4,a5,1
8000a8aa:	47b2                	lw	a5,12(sp)
8000a8ac:	1ae7a223          	sw	a4,420(a5)
    ptr->USBINTR = 0;
8000a8b0:	47b2                	lw	a5,12(sp)
8000a8b2:	1407a423          	sw	zero,328(a5)
}
8000a8b6:	0001                	nop
8000a8b8:	40f2                	lw	ra,28(sp)
8000a8ba:	6105                	add	sp,sp,32
8000a8bc:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_xfer:

8000a8be <usb_dcd_edpt_xfer>:
{
8000a8be:	1101                	add	sp,sp,-32
8000a8c0:	c62a                	sw	a0,12(sp)
8000a8c2:	87ae                	mv	a5,a1
8000a8c4:	00f105a3          	sb	a5,11(sp)
    uint32_t offset = ep_idx / 2 + ((ep_idx % 2) ? 16 : 0);
8000a8c8:	00b14783          	lbu	a5,11(sp)
8000a8cc:	8385                	srl	a5,a5,0x1
8000a8ce:	0ff7f793          	zext.b	a5,a5
8000a8d2:	873e                	mv	a4,a5
8000a8d4:	00b14783          	lbu	a5,11(sp)
8000a8d8:	0792                	sll	a5,a5,0x4
8000a8da:	8bc1                	and	a5,a5,16
8000a8dc:	97ba                	add	a5,a5,a4
8000a8de:	ce3e                	sw	a5,28(sp)
    ptr->ENDPTPRIME = 1 << offset;
8000a8e0:	47f2                	lw	a5,28(sp)
8000a8e2:	4705                	li	a4,1
8000a8e4:	00f717b3          	sll	a5,a4,a5
8000a8e8:	873e                	mv	a4,a5
8000a8ea:	47b2                	lw	a5,12(sp)
8000a8ec:	1ae7a823          	sw	a4,432(a5)
}
8000a8f0:	0001                	nop
8000a8f2:	6105                	add	sp,sp,32
8000a8f4:	8082                	ret

Disassembly of section .text.chry_ringbuffer_init:

8000a8f6 <chry_ringbuffer_init>:
{
8000a8f6:	1141                	add	sp,sp,-16
8000a8f8:	c62a                	sw	a0,12(sp)
8000a8fa:	c42e                	sw	a1,8(sp)
8000a8fc:	c232                	sw	a2,4(sp)
    if (NULL == rb) {
8000a8fe:	47b2                	lw	a5,12(sp)
8000a900:	e399                	bnez	a5,8000a906 <.L2>
        return -1;
8000a902:	57fd                	li	a5,-1
8000a904:	a081                	j	8000a944 <.L3>

8000a906 <.L2>:
    if (NULL == pool) {
8000a906:	47a2                	lw	a5,8(sp)
8000a908:	e399                	bnez	a5,8000a90e <.L4>
        return -1;
8000a90a:	57fd                	li	a5,-1
8000a90c:	a825                	j	8000a944 <.L3>

8000a90e <.L4>:
    if ((size < 2) || (size & (size - 1))) {
8000a90e:	4712                	lw	a4,4(sp)
8000a910:	4785                	li	a5,1
8000a912:	00e7f863          	bgeu	a5,a4,8000a922 <.L5>
8000a916:	4792                	lw	a5,4(sp)
8000a918:	fff78713          	add	a4,a5,-1
8000a91c:	4792                	lw	a5,4(sp)
8000a91e:	8ff9                	and	a5,a5,a4
8000a920:	c399                	beqz	a5,8000a926 <.L6>

8000a922 <.L5>:
        return -1;
8000a922:	57fd                	li	a5,-1
8000a924:	a005                	j	8000a944 <.L3>

8000a926 <.L6>:
    rb->in = 0;
8000a926:	47b2                	lw	a5,12(sp)
8000a928:	0007a023          	sw	zero,0(a5)
    rb->out = 0;
8000a92c:	47b2                	lw	a5,12(sp)
8000a92e:	0007a223          	sw	zero,4(a5)
    rb->mask = size - 1;
8000a932:	4792                	lw	a5,4(sp)
8000a934:	fff78713          	add	a4,a5,-1
8000a938:	47b2                	lw	a5,12(sp)
8000a93a:	c798                	sw	a4,8(a5)
    rb->pool = pool;
8000a93c:	47b2                	lw	a5,12(sp)
8000a93e:	4722                	lw	a4,8(sp)
8000a940:	c7d8                	sw	a4,12(a5)
    return 0;
8000a942:	4781                	li	a5,0

8000a944 <.L3>:
}
8000a944:	853e                	mv	a0,a5
8000a946:	0141                	add	sp,sp,16
8000a948:	8082                	ret

Disassembly of section .text.chry_ringbuffer_read_byte:

8000a94a <chry_ringbuffer_read_byte>:
{
8000a94a:	7179                	add	sp,sp,-48
8000a94c:	d606                	sw	ra,44(sp)
8000a94e:	c62a                	sw	a0,12(sp)
8000a950:	c42e                	sw	a1,8(sp)
    ret = chry_ringbuffer_peek_byte(rb, byte);
8000a952:	45a2                	lw	a1,8(sp)
8000a954:	4532                	lw	a0,12(sp)
8000a956:	aaefb0ef          	jal	80005c04 <chry_ringbuffer_peek_byte>
8000a95a:	87aa                	mv	a5,a0
8000a95c:	00f10fa3          	sb	a5,31(sp)
    rb->out += ret;
8000a960:	47b2                	lw	a5,12(sp)
8000a962:	43d8                	lw	a4,4(a5)
8000a964:	01f14783          	lbu	a5,31(sp)
8000a968:	973e                	add	a4,a4,a5
8000a96a:	47b2                	lw	a5,12(sp)
8000a96c:	c3d8                	sw	a4,4(a5)
    return ret;
8000a96e:	01f14783          	lbu	a5,31(sp)
}
8000a972:	853e                	mv	a0,a5
8000a974:	50b2                	lw	ra,44(sp)
8000a976:	6145                	add	sp,sp,48
8000a978:	8082                	ret

Disassembly of section .text.usbd_cdc_acm_init_intf:

8000a97a <usbd_cdc_acm_init_intf>:
{
8000a97a:	1141                	add	sp,sp,-16
8000a97c:	87aa                	mv	a5,a0
8000a97e:	c42e                	sw	a1,8(sp)
8000a980:	00f107a3          	sb	a5,15(sp)
    intf->class_interface_handler = cdc_acm_class_interface_request_handler;
8000a984:	47a2                	lw	a5,8(sp)
8000a986:	80006737          	lui	a4,0x80006
8000a98a:	cd270713          	add	a4,a4,-814 # 80005cd2 <cdc_acm_class_interface_request_handler>
8000a98e:	c398                	sw	a4,0(a5)
    intf->class_endpoint_handler = NULL;
8000a990:	47a2                	lw	a5,8(sp)
8000a992:	0007a223          	sw	zero,4(a5)
    intf->vendor_handler = NULL;
8000a996:	47a2                	lw	a5,8(sp)
8000a998:	0007a423          	sw	zero,8(a5)
    intf->notify_handler = NULL;
8000a99c:	47a2                	lw	a5,8(sp)
8000a99e:	0007a623          	sw	zero,12(a5)
    return intf;
8000a9a2:	47a2                	lw	a5,8(sp)
}
8000a9a4:	853e                	mv	a0,a5
8000a9a6:	0141                	add	sp,sp,16
8000a9a8:	8082                	ret

Disassembly of section .text.usb_memcpy:

8000a9aa <usb_memcpy>:

static inline void *usb_memcpy(void *s1, const void *s2, size_t n)
{
8000a9aa:	7179                	add	sp,sp,-48
8000a9ac:	d606                	sw	ra,44(sp)
8000a9ae:	c62a                	sw	a0,12(sp)
8000a9b0:	c42e                	sw	a1,8(sp)
8000a9b2:	c232                	sw	a2,4(sp)
    char *b1 = (char *)s1;
8000a9b4:	47b2                	lw	a5,12(sp)
8000a9b6:	ce3e                	sw	a5,28(sp)
    const char *b2 = (const char *)s2;
8000a9b8:	47a2                	lw	a5,8(sp)
8000a9ba:	cc3e                	sw	a5,24(sp)
    uint32_t *w1;
    const uint32_t *w2;

    if (ALIGN_UP_DWORD(b1) == ALIGN_UP_DWORD(b2)) {
8000a9bc:	4772                	lw	a4,28(sp)
8000a9be:	47e2                	lw	a5,24(sp)
8000a9c0:	8fb9                	xor	a5,a5,a4
8000a9c2:	8b8d                	and	a5,a5,3
8000a9c4:	10079363          	bnez	a5,8000aaca <.L14>
        while (ALIGN_UP_DWORD(b1) != 0 && n > 0) {
8000a9c8:	a005                	j	8000a9e8 <.L4>

8000a9ca <.L6>:
            *b1++ = *b2++;
8000a9ca:	4762                	lw	a4,24(sp)
8000a9cc:	00170793          	add	a5,a4,1
8000a9d0:	cc3e                	sw	a5,24(sp)
8000a9d2:	47f2                	lw	a5,28(sp)
8000a9d4:	00178693          	add	a3,a5,1
8000a9d8:	ce36                	sw	a3,28(sp)
8000a9da:	00074703          	lbu	a4,0(a4)
8000a9de:	00e78023          	sb	a4,0(a5)
            --n;
8000a9e2:	4792                	lw	a5,4(sp)
8000a9e4:	17fd                	add	a5,a5,-1
8000a9e6:	c23e                	sw	a5,4(sp)

8000a9e8 <.L4>:
        while (ALIGN_UP_DWORD(b1) != 0 && n > 0) {
8000a9e8:	47f2                	lw	a5,28(sp)
8000a9ea:	8b8d                	and	a5,a5,3
8000a9ec:	c399                	beqz	a5,8000a9f2 <.L5>
8000a9ee:	4792                	lw	a5,4(sp)
8000a9f0:	ffe9                	bnez	a5,8000a9ca <.L6>

8000a9f2 <.L5>:
        }

        w1 = (uint32_t *)b1;
8000a9f2:	47f2                	lw	a5,28(sp)
8000a9f4:	ca3e                	sw	a5,20(sp)
        w2 = (const uint32_t *)b2;
8000a9f6:	47e2                	lw	a5,24(sp)
8000a9f8:	c83e                	sw	a5,16(sp)

        while (n >= 4 * sizeof(uint32_t)) {
8000a9fa:	a8a1                	j	8000aa52 <.L7>

8000a9fc <.L8>:
            *w1++ = *w2++;
8000a9fc:	4742                	lw	a4,16(sp)
8000a9fe:	00470793          	add	a5,a4,4
8000aa02:	c83e                	sw	a5,16(sp)
8000aa04:	47d2                	lw	a5,20(sp)
8000aa06:	00478693          	add	a3,a5,4
8000aa0a:	ca36                	sw	a3,20(sp)
8000aa0c:	4318                	lw	a4,0(a4)
8000aa0e:	c398                	sw	a4,0(a5)
            *w1++ = *w2++;
8000aa10:	4742                	lw	a4,16(sp)
8000aa12:	00470793          	add	a5,a4,4
8000aa16:	c83e                	sw	a5,16(sp)
8000aa18:	47d2                	lw	a5,20(sp)
8000aa1a:	00478693          	add	a3,a5,4
8000aa1e:	ca36                	sw	a3,20(sp)
8000aa20:	4318                	lw	a4,0(a4)
8000aa22:	c398                	sw	a4,0(a5)
            *w1++ = *w2++;
8000aa24:	4742                	lw	a4,16(sp)
8000aa26:	00470793          	add	a5,a4,4
8000aa2a:	c83e                	sw	a5,16(sp)
8000aa2c:	47d2                	lw	a5,20(sp)
8000aa2e:	00478693          	add	a3,a5,4
8000aa32:	ca36                	sw	a3,20(sp)
8000aa34:	4318                	lw	a4,0(a4)
8000aa36:	c398                	sw	a4,0(a5)
            *w1++ = *w2++;
8000aa38:	4742                	lw	a4,16(sp)
8000aa3a:	00470793          	add	a5,a4,4
8000aa3e:	c83e                	sw	a5,16(sp)
8000aa40:	47d2                	lw	a5,20(sp)
8000aa42:	00478693          	add	a3,a5,4
8000aa46:	ca36                	sw	a3,20(sp)
8000aa48:	4318                	lw	a4,0(a4)
8000aa4a:	c398                	sw	a4,0(a5)
            n -= 4 * sizeof(uint32_t);
8000aa4c:	4792                	lw	a5,4(sp)
8000aa4e:	17c1                	add	a5,a5,-16
8000aa50:	c23e                	sw	a5,4(sp)

8000aa52 <.L7>:
        while (n >= 4 * sizeof(uint32_t)) {
8000aa52:	4712                	lw	a4,4(sp)
8000aa54:	47bd                	li	a5,15
8000aa56:	fae7e3e3          	bltu	a5,a4,8000a9fc <.L8>
        }

        while (n >= sizeof(uint32_t)) {
8000aa5a:	a831                	j	8000aa76 <.L9>

8000aa5c <.L10>:
            *w1++ = *w2++;
8000aa5c:	4742                	lw	a4,16(sp)
8000aa5e:	00470793          	add	a5,a4,4
8000aa62:	c83e                	sw	a5,16(sp)
8000aa64:	47d2                	lw	a5,20(sp)
8000aa66:	00478693          	add	a3,a5,4
8000aa6a:	ca36                	sw	a3,20(sp)
8000aa6c:	4318                	lw	a4,0(a4)
8000aa6e:	c398                	sw	a4,0(a5)
            n -= sizeof(uint32_t);
8000aa70:	4792                	lw	a5,4(sp)
8000aa72:	17f1                	add	a5,a5,-4
8000aa74:	c23e                	sw	a5,4(sp)

8000aa76 <.L9>:
        while (n >= sizeof(uint32_t)) {
8000aa76:	4712                	lw	a4,4(sp)
8000aa78:	478d                	li	a5,3
8000aa7a:	fee7e1e3          	bltu	a5,a4,8000aa5c <.L10>
        }

        b1 = (char *)w1;
8000aa7e:	47d2                	lw	a5,20(sp)
8000aa80:	ce3e                	sw	a5,28(sp)
        b2 = (const char *)w2;
8000aa82:	47c2                	lw	a5,16(sp)
8000aa84:	cc3e                	sw	a5,24(sp)

        while (n--) {
8000aa86:	a829                	j	8000aaa0 <.L11>

8000aa88 <.L12>:
            *b1++ = *b2++;
8000aa88:	4762                	lw	a4,24(sp)
8000aa8a:	00170793          	add	a5,a4,1
8000aa8e:	cc3e                	sw	a5,24(sp)
8000aa90:	47f2                	lw	a5,28(sp)
8000aa92:	00178693          	add	a3,a5,1
8000aa96:	ce36                	sw	a3,28(sp)
8000aa98:	00074703          	lbu	a4,0(a4)
8000aa9c:	00e78023          	sb	a4,0(a5)

8000aaa0 <.L11>:
        while (n--) {
8000aaa0:	4792                	lw	a5,4(sp)
8000aaa2:	fff78713          	add	a4,a5,-1
8000aaa6:	c23a                	sw	a4,4(sp)
8000aaa8:	f3e5                	bnez	a5,8000aa88 <.L12>
8000aaaa:	a0fd                	j	8000ab98 <.L13>

8000aaac <.L16>:
        }
    } else {
        while (n > 0 && ALIGN_UP_DWORD(b2) != 0) {
            *b1++ = *b2++;
8000aaac:	4762                	lw	a4,24(sp)
8000aaae:	00170793          	add	a5,a4,1
8000aab2:	cc3e                	sw	a5,24(sp)
8000aab4:	47f2                	lw	a5,28(sp)
8000aab6:	00178693          	add	a3,a5,1
8000aaba:	ce36                	sw	a3,28(sp)
8000aabc:	00074703          	lbu	a4,0(a4)
8000aac0:	00e78023          	sb	a4,0(a5)
            --n;
8000aac4:	4792                	lw	a5,4(sp)
8000aac6:	17fd                	add	a5,a5,-1
8000aac8:	c23e                	sw	a5,4(sp)

8000aaca <.L14>:
        while (n > 0 && ALIGN_UP_DWORD(b2) != 0) {
8000aaca:	4792                	lw	a5,4(sp)
8000aacc:	c781                	beqz	a5,8000aad4 <.L15>
8000aace:	47e2                	lw	a5,24(sp)
8000aad0:	8b8d                	and	a5,a5,3
8000aad2:	ffe9                	bnez	a5,8000aaac <.L16>

8000aad4 <.L15>:
        }

        w2 = (const uint32_t *)b2;
8000aad4:	47e2                	lw	a5,24(sp)
8000aad6:	c83e                	sw	a5,16(sp)

        while (n >= 4 * sizeof(uint32_t)) {
8000aad8:	a0a5                	j	8000ab40 <.L17>

8000aada <.L18>:
         dword2array(b1, *w2++);
8000aada:	47c2                	lw	a5,16(sp)
8000aadc:	00478713          	add	a4,a5,4
8000aae0:	c83a                	sw	a4,16(sp)
8000aae2:	439c                	lw	a5,0(a5)
8000aae4:	85be                	mv	a1,a5
8000aae6:	4572                	lw	a0,28(sp)
8000aae8:	ba8fb0ef          	jal	80005e90 <dword2array>
            b1 += sizeof(uint32_t);
8000aaec:	47f2                	lw	a5,28(sp)
8000aaee:	0791                	add	a5,a5,4
8000aaf0:	ce3e                	sw	a5,28(sp)
         dword2array(b1, *w2++);
8000aaf2:	47c2                	lw	a5,16(sp)
8000aaf4:	00478713          	add	a4,a5,4
8000aaf8:	c83a                	sw	a4,16(sp)
8000aafa:	439c                	lw	a5,0(a5)
8000aafc:	85be                	mv	a1,a5
8000aafe:	4572                	lw	a0,28(sp)
8000ab00:	b90fb0ef          	jal	80005e90 <dword2array>
            b1 += sizeof(uint32_t);
8000ab04:	47f2                	lw	a5,28(sp)
8000ab06:	0791                	add	a5,a5,4
8000ab08:	ce3e                	sw	a5,28(sp)
         dword2array(b1, *w2++);
8000ab0a:	47c2                	lw	a5,16(sp)
8000ab0c:	00478713          	add	a4,a5,4
8000ab10:	c83a                	sw	a4,16(sp)
8000ab12:	439c                	lw	a5,0(a5)
8000ab14:	85be                	mv	a1,a5
8000ab16:	4572                	lw	a0,28(sp)
8000ab18:	b78fb0ef          	jal	80005e90 <dword2array>
            b1 += sizeof(uint32_t);
8000ab1c:	47f2                	lw	a5,28(sp)
8000ab1e:	0791                	add	a5,a5,4
8000ab20:	ce3e                	sw	a5,28(sp)
         dword2array(b1, *w2++);
8000ab22:	47c2                	lw	a5,16(sp)
8000ab24:	00478713          	add	a4,a5,4
8000ab28:	c83a                	sw	a4,16(sp)
8000ab2a:	439c                	lw	a5,0(a5)
8000ab2c:	85be                	mv	a1,a5
8000ab2e:	4572                	lw	a0,28(sp)
8000ab30:	b60fb0ef          	jal	80005e90 <dword2array>
            b1 += sizeof(uint32_t);
8000ab34:	47f2                	lw	a5,28(sp)
8000ab36:	0791                	add	a5,a5,4
8000ab38:	ce3e                	sw	a5,28(sp)
            n -= 4 * sizeof(uint32_t);
8000ab3a:	4792                	lw	a5,4(sp)
8000ab3c:	17c1                	add	a5,a5,-16
8000ab3e:	c23e                	sw	a5,4(sp)

8000ab40 <.L17>:
        while (n >= 4 * sizeof(uint32_t)) {
8000ab40:	4712                	lw	a4,4(sp)
8000ab42:	47bd                	li	a5,15
8000ab44:	f8e7ebe3          	bltu	a5,a4,8000aada <.L18>
        }

        while (n >= sizeof(uint32_t)) {
8000ab48:	a005                	j	8000ab68 <.L19>

8000ab4a <.L20>:
         dword2array(b1, *w2++);
8000ab4a:	47c2                	lw	a5,16(sp)
8000ab4c:	00478713          	add	a4,a5,4
8000ab50:	c83a                	sw	a4,16(sp)
8000ab52:	439c                	lw	a5,0(a5)
8000ab54:	85be                	mv	a1,a5
8000ab56:	4572                	lw	a0,28(sp)
8000ab58:	b38fb0ef          	jal	80005e90 <dword2array>
            b1 += sizeof(uint32_t);
8000ab5c:	47f2                	lw	a5,28(sp)
8000ab5e:	0791                	add	a5,a5,4
8000ab60:	ce3e                	sw	a5,28(sp)
            n -= sizeof(uint32_t);
8000ab62:	4792                	lw	a5,4(sp)
8000ab64:	17f1                	add	a5,a5,-4
8000ab66:	c23e                	sw	a5,4(sp)

8000ab68 <.L19>:
        while (n >= sizeof(uint32_t)) {
8000ab68:	4712                	lw	a4,4(sp)
8000ab6a:	478d                	li	a5,3
8000ab6c:	fce7efe3          	bltu	a5,a4,8000ab4a <.L20>
        }

        b2 = (const char *)w2;
8000ab70:	47c2                	lw	a5,16(sp)
8000ab72:	cc3e                	sw	a5,24(sp)

        while (n--) {
8000ab74:	a829                	j	8000ab8e <.L21>

8000ab76 <.L22>:
            *b1++ = *b2++;
8000ab76:	4762                	lw	a4,24(sp)
8000ab78:	00170793          	add	a5,a4,1
8000ab7c:	cc3e                	sw	a5,24(sp)
8000ab7e:	47f2                	lw	a5,28(sp)
8000ab80:	00178693          	add	a3,a5,1
8000ab84:	ce36                	sw	a3,28(sp)
8000ab86:	00074703          	lbu	a4,0(a4)
8000ab8a:	00e78023          	sb	a4,0(a5)

8000ab8e <.L21>:
        while (n--) {
8000ab8e:	4792                	lw	a5,4(sp)
8000ab90:	fff78713          	add	a4,a5,-1
8000ab94:	c23a                	sw	a4,4(sp)
8000ab96:	f3e5                	bnez	a5,8000ab76 <.L22>

8000ab98 <.L13>:
        }
    }
    return s1;
8000ab98:	47b2                	lw	a5,12(sp)
}
8000ab9a:	853e                	mv	a0,a5
8000ab9c:	50b2                	lw	ra,44(sp)
8000ab9e:	6145                	add	sp,sp,48
8000aba0:	8082                	ret

Disassembly of section .text.usbd_reset_endpoint:

8000aba2 <usbd_reset_endpoint>:
{
8000aba2:	1101                	add	sp,sp,-32
8000aba4:	ce06                	sw	ra,28(sp)
8000aba6:	87aa                	mv	a5,a0
8000aba8:	c42e                	sw	a1,8(sp)
8000abaa:	00f107a3          	sb	a5,15(sp)
    return usbd_ep_close(busid, ep->bEndpointAddress) == 0 ? true : false;
8000abae:	47a2                	lw	a5,8(sp)
8000abb0:	0027c703          	lbu	a4,2(a5)
8000abb4:	00f14783          	lbu	a5,15(sp)
8000abb8:	85ba                	mv	a1,a4
8000abba:	853e                	mv	a0,a5
8000abbc:	57b000ef          	jal	8000b936 <usbd_ep_close>
8000abc0:	87aa                	mv	a5,a0
8000abc2:	0017b793          	seqz	a5,a5
8000abc6:	0ff7f793          	zext.b	a5,a5
}
8000abca:	853e                	mv	a0,a5
8000abcc:	40f2                	lw	ra,28(sp)
8000abce:	6105                	add	sp,sp,32
8000abd0:	8082                	ret

Disassembly of section .text.usbd_std_interface_req_handler:

8000abd2 <usbd_std_interface_req_handler>:
{
8000abd2:	7139                	add	sp,sp,-64
8000abd4:	de06                	sw	ra,60(sp)
8000abd6:	87aa                	mv	a5,a0
8000abd8:	c42e                	sw	a1,8(sp)
8000abda:	c232                	sw	a2,4(sp)
8000abdc:	c036                	sw	a3,0(sp)
8000abde:	00f107a3          	sb	a5,15(sp)
    uint8_t type = HI_BYTE(setup->wValue);
8000abe2:	47a2                	lw	a5,8(sp)
8000abe4:	0027c703          	lbu	a4,2(a5)
8000abe8:	0037c783          	lbu	a5,3(a5)
8000abec:	07a2                	sll	a5,a5,0x8
8000abee:	8fd9                	or	a5,a5,a4
8000abf0:	07c2                	sll	a5,a5,0x10
8000abf2:	83c1                	srl	a5,a5,0x10
8000abf4:	83a1                	srl	a5,a5,0x8
8000abf6:	07c2                	sll	a5,a5,0x10
8000abf8:	83c1                	srl	a5,a5,0x10
8000abfa:	00f10ea3          	sb	a5,29(sp)
    uint8_t intf_num = LO_BYTE(setup->wIndex);
8000abfe:	47a2                	lw	a5,8(sp)
8000ac00:	0047c703          	lbu	a4,4(a5)
8000ac04:	0057c783          	lbu	a5,5(a5)
8000ac08:	07a2                	sll	a5,a5,0x8
8000ac0a:	8fd9                	or	a5,a5,a4
8000ac0c:	07c2                	sll	a5,a5,0x10
8000ac0e:	83c1                	srl	a5,a5,0x10
8000ac10:	00f10e23          	sb	a5,28(sp)
    bool ret = true;
8000ac14:	4785                	li	a5,1
8000ac16:	02f107a3          	sb	a5,47(sp)
    uint32_t desc_len = 0;
8000ac1a:	d202                	sw	zero,36(sp)
    uint32_t current_desc_len = 0;
8000ac1c:	d002                	sw	zero,32(sp)
    uint8_t cur_iface = 0xFF;
8000ac1e:	57fd                	li	a5,-1
8000ac20:	00f10fa3          	sb	a5,31(sp)
    p = g_usbd_core[busid].descriptors->config_descriptor_callback(g_usbd_core[busid].speed);
8000ac24:	00f14683          	lbu	a3,15(sp)
8000ac28:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000ac2c:	6785                	lui	a5,0x1
8000ac2e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000ac32:	02f687b3          	mul	a5,a3,a5
8000ac36:	97ba                	add	a5,a5,a4
8000ac38:	4f9c                	lw	a5,24(a5)
8000ac3a:	43d8                	lw	a4,4(a5)
8000ac3c:	00f14603          	lbu	a2,15(sp)
8000ac40:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000ac44:	6785                	lui	a5,0x1
8000ac46:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000ac4a:	02f607b3          	mul	a5,a2,a5
8000ac4e:	97b6                	add	a5,a5,a3
8000ac50:	6685                	lui	a3,0x1
8000ac52:	97b6                	add	a5,a5,a3
8000ac54:	8227c783          	lbu	a5,-2014(a5)
8000ac58:	853e                	mv	a0,a5
8000ac5a:	9702                	jalr	a4
8000ac5c:	d42a                	sw	a0,40(sp)
    if (!is_device_configured(busid)) {
8000ac5e:	00f14783          	lbu	a5,15(sp)
8000ac62:	853e                	mv	a0,a5
8000ac64:	aecfb0ef          	jal	80005f50 <is_device_configured>
8000ac68:	87aa                	mv	a5,a0
8000ac6a:	0017c793          	xor	a5,a5,1
8000ac6e:	0ff7f793          	zext.b	a5,a5
8000ac72:	c399                	beqz	a5,8000ac78 <.L112>
        return false;
8000ac74:	4781                	li	a5,0
8000ac76:	a481                	j	8000aeb6 <.L113>

8000ac78 <.L112>:
    switch (setup->bRequest) {
8000ac78:	47a2                	lw	a5,8(sp)
8000ac7a:	0017c783          	lbu	a5,1(a5)
8000ac7e:	472d                	li	a4,11
8000ac80:	22f76663          	bltu	a4,a5,8000aeac <.L114>
8000ac84:	00279713          	sll	a4,a5,0x2
8000ac88:	800037b7          	lui	a5,0x80003
8000ac8c:	2e478793          	add	a5,a5,740 # 800032e4 <.L116>
8000ac90:	97ba                	add	a5,a5,a4
8000ac92:	439c                	lw	a5,0(a5)
8000ac94:	8782                	jr	a5

8000ac96 <.L120>:
            (*data)[0] = 0x00;
8000ac96:	4792                	lw	a5,4(sp)
8000ac98:	439c                	lw	a5,0(a5)
8000ac9a:	00078023          	sb	zero,0(a5)
            (*data)[1] = 0x00;
8000ac9e:	4792                	lw	a5,4(sp)
8000aca0:	439c                	lw	a5,0(a5)
8000aca2:	0785                	add	a5,a5,1
8000aca4:	00078023          	sb	zero,0(a5)
            *len = 2;
8000aca8:	4782                	lw	a5,0(sp)
8000acaa:	4709                	li	a4,2
8000acac:	c398                	sw	a4,0(a5)
            break;
8000acae:	a411                	j	8000aeb2 <.L121>

8000acb0 <.L118>:
            if (type == 0x21) { /* HID_DESCRIPTOR_TYPE_HID */
8000acb0:	01d14703          	lbu	a4,29(sp)
8000acb4:	02100793          	li	a5,33
8000acb8:	0af71863          	bne	a4,a5,8000ad68 <.L122>
                while (p[DESC_bLength] != 0U) {
8000acbc:	a04d                	j	8000ad5e <.L123>

8000acbe <.L131>:
                    switch (p[DESC_bDescriptorType]) {
8000acbe:	57a2                	lw	a5,40(sp)
8000acc0:	0785                	add	a5,a5,1
8000acc2:	0007c783          	lbu	a5,0(a5)
8000acc6:	02100713          	li	a4,33
8000acca:	04e78263          	beq	a5,a4,8000ad0e <.L124>
8000acce:	02100713          	li	a4,33
8000acd2:	04f74f63          	blt	a4,a5,8000ad30 <.L136>
8000acd6:	4709                	li	a4,2
8000acd8:	00e78663          	beq	a5,a4,8000ace4 <.L126>
8000acdc:	4711                	li	a4,4
8000acde:	02e78163          	beq	a5,a4,8000ad00 <.L127>
                            break;
8000ace2:	a0b9                	j	8000ad30 <.L136>

8000ace4 <.L126>:
                            current_desc_len = 0;
8000ace4:	d002                	sw	zero,32(sp)
                            desc_len = (p[CONF_DESC_wTotalLength]) |
8000ace6:	57a2                	lw	a5,40(sp)
8000ace8:	0789                	add	a5,a5,2
8000acea:	0007c783          	lbu	a5,0(a5)
8000acee:	873e                	mv	a4,a5
                                       (p[CONF_DESC_wTotalLength + 1] << 8);
8000acf0:	57a2                	lw	a5,40(sp)
8000acf2:	078d                	add	a5,a5,3
8000acf4:	0007c783          	lbu	a5,0(a5)
8000acf8:	07a2                	sll	a5,a5,0x8
                            desc_len = (p[CONF_DESC_wTotalLength]) |
8000acfa:	8fd9                	or	a5,a5,a4
8000acfc:	d23e                	sw	a5,36(sp)
                            break;
8000acfe:	a825                	j	8000ad36 <.L128>

8000ad00 <.L127>:
                            cur_iface = p[INTF_DESC_bInterfaceNumber];
8000ad00:	57a2                	lw	a5,40(sp)
8000ad02:	0789                	add	a5,a5,2
8000ad04:	0007c783          	lbu	a5,0(a5)
8000ad08:	00f10fa3          	sb	a5,31(sp)
                            break;
8000ad0c:	a02d                	j	8000ad36 <.L128>

8000ad0e <.L124>:
                            if (cur_iface == intf_num) {
8000ad0e:	01f14703          	lbu	a4,31(sp)
8000ad12:	01c14783          	lbu	a5,28(sp)
8000ad16:	00f71f63          	bne	a4,a5,8000ad34 <.L137>
                                *data = (uint8_t *)p;
8000ad1a:	4792                	lw	a5,4(sp)
8000ad1c:	5722                	lw	a4,40(sp)
8000ad1e:	c398                	sw	a4,0(a5)
                                *len = p[DESC_bLength];
8000ad20:	57a2                	lw	a5,40(sp)
8000ad22:	0007c783          	lbu	a5,0(a5)
8000ad26:	873e                	mv	a4,a5
8000ad28:	4782                	lw	a5,0(sp)
8000ad2a:	c398                	sw	a4,0(a5)
                                return true;
8000ad2c:	4785                	li	a5,1
8000ad2e:	a261                	j	8000aeb6 <.L113>

8000ad30 <.L136>:
                            break;
8000ad30:	0001                	nop
8000ad32:	a011                	j	8000ad36 <.L128>

8000ad34 <.L137>:
                            break;
8000ad34:	0001                	nop

8000ad36 <.L128>:
                    p += p[DESC_bLength];
8000ad36:	57a2                	lw	a5,40(sp)
8000ad38:	0007c783          	lbu	a5,0(a5)
8000ad3c:	873e                	mv	a4,a5
8000ad3e:	57a2                	lw	a5,40(sp)
8000ad40:	97ba                	add	a5,a5,a4
8000ad42:	d43e                	sw	a5,40(sp)
                    current_desc_len += p[DESC_bLength];
8000ad44:	57a2                	lw	a5,40(sp)
8000ad46:	0007c783          	lbu	a5,0(a5)
8000ad4a:	873e                	mv	a4,a5
8000ad4c:	5782                	lw	a5,32(sp)
8000ad4e:	97ba                	add	a5,a5,a4
8000ad50:	d03e                	sw	a5,32(sp)
                    if (current_desc_len >= desc_len && desc_len) {
8000ad52:	5702                	lw	a4,32(sp)
8000ad54:	5792                	lw	a5,36(sp)
8000ad56:	00f76463          	bltu	a4,a5,8000ad5e <.L123>
8000ad5a:	5792                	lw	a5,36(sp)
8000ad5c:	ebd9                	bnez	a5,8000adf2 <.L138>

8000ad5e <.L123>:
                while (p[DESC_bLength] != 0U) {
8000ad5e:	57a2                	lw	a5,40(sp)
8000ad60:	0007c783          	lbu	a5,0(a5)
8000ad64:	ffa9                	bnez	a5,8000acbe <.L131>
8000ad66:	a079                	j	8000adf4 <.L132>

8000ad68 <.L122>:
            } else if (type == 0x22) { /* HID_DESCRIPTOR_TYPE_HID_REPORT */
8000ad68:	01d14703          	lbu	a4,29(sp)
8000ad6c:	02200793          	li	a5,34
8000ad70:	08f71263          	bne	a4,a5,8000adf4 <.L132>

8000ad74 <.LBB4>:
                for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
8000ad74:	00010f23          	sb	zero,30(sp)
8000ad78:	a891                	j	8000adcc <.L133>

8000ad7a <.L135>:
                    struct usbd_interface *intf = g_usbd_core[busid].intf[i];
8000ad7a:	00f14603          	lbu	a2,15(sp)
8000ad7e:	01e14783          	lbu	a5,30(sp)
8000ad82:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000ad86:	24f00693          	li	a3,591
8000ad8a:	02d606b3          	mul	a3,a2,a3
8000ad8e:	97b6                	add	a5,a5,a3
8000ad90:	20878793          	add	a5,a5,520
8000ad94:	078a                	sll	a5,a5,0x2
8000ad96:	97ba                	add	a5,a5,a4
8000ad98:	43dc                	lw	a5,4(a5)
8000ad9a:	cc3e                	sw	a5,24(sp)
                    if (intf && (intf->intf_num == intf_num)) {
8000ad9c:	47e2                	lw	a5,24(sp)
8000ad9e:	c395                	beqz	a5,8000adc2 <.L134>
8000ada0:	47e2                	lw	a5,24(sp)
8000ada2:	0187c783          	lbu	a5,24(a5)
8000ada6:	01c14703          	lbu	a4,28(sp)
8000adaa:	00f71c63          	bne	a4,a5,8000adc2 <.L134>
                        *data = (uint8_t *)intf->hid_report_descriptor;
8000adae:	47e2                	lw	a5,24(sp)
8000adb0:	4b98                	lw	a4,16(a5)
8000adb2:	4792                	lw	a5,4(sp)
8000adb4:	c398                	sw	a4,0(a5)
                        *len = intf->hid_report_descriptor_len;
8000adb6:	47e2                	lw	a5,24(sp)
8000adb8:	4bd8                	lw	a4,20(a5)
8000adba:	4782                	lw	a5,0(sp)
8000adbc:	c398                	sw	a4,0(a5)
                        return true;
8000adbe:	4785                	li	a5,1
8000adc0:	a8dd                	j	8000aeb6 <.L113>

8000adc2 <.L134>:
                for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
8000adc2:	01e14783          	lbu	a5,30(sp)
8000adc6:	0785                	add	a5,a5,1
8000adc8:	00f10f23          	sb	a5,30(sp)

8000adcc <.L133>:
8000adcc:	00f14683          	lbu	a3,15(sp)
8000add0:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000add4:	6785                	lui	a5,0x1
8000add6:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000adda:	02f687b3          	mul	a5,a3,a5
8000adde:	97ba                	add	a5,a5,a4
8000ade0:	6705                	lui	a4,0x1
8000ade2:	97ba                	add	a5,a5,a4
8000ade4:	8747c783          	lbu	a5,-1932(a5)
8000ade8:	01e14703          	lbu	a4,30(sp)
8000adec:	f8f767e3          	bltu	a4,a5,8000ad7a <.L135>
8000adf0:	a011                	j	8000adf4 <.L132>

8000adf2 <.L138>:
                        break;
8000adf2:	0001                	nop

8000adf4 <.L132>:
            ret = false;
8000adf4:	020107a3          	sb	zero,47(sp)
            break;
8000adf8:	a86d                	j	8000aeb2 <.L121>

8000adfa <.L119>:
            ret = false;
8000adfa:	020107a3          	sb	zero,47(sp)
            break;
8000adfe:	a855                	j	8000aeb2 <.L121>

8000ae00 <.L117>:
            (*data)[0] = g_usbd_core[busid].intf_altsetting[intf_num];
8000ae00:	00f14583          	lbu	a1,15(sp)
8000ae04:	01c14683          	lbu	a3,28(sp)
8000ae08:	4792                	lw	a5,4(sp)
8000ae0a:	4398                	lw	a4,0(a5)
8000ae0c:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
8000ae10:	6785                	lui	a5,0x1
8000ae12:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000ae16:	02f587b3          	mul	a5,a1,a5
8000ae1a:	97b2                	add	a5,a5,a2
8000ae1c:	97b6                	add	a5,a5,a3
8000ae1e:	6685                	lui	a3,0x1
8000ae20:	97b6                	add	a5,a5,a3
8000ae22:	8647c783          	lbu	a5,-1948(a5)
8000ae26:	00f70023          	sb	a5,0(a4) # 1000 <__fw_size__>
            *len = 1;
8000ae2a:	4782                	lw	a5,0(sp)
8000ae2c:	4705                	li	a4,1
8000ae2e:	c398                	sw	a4,0(a5)
            break;
8000ae30:	a049                	j	8000aeb2 <.L121>

8000ae32 <.L115>:
            g_usbd_core[busid].intf_altsetting[intf_num] = LO_BYTE(setup->wValue);
8000ae32:	47a2                	lw	a5,8(sp)
8000ae34:	0027c703          	lbu	a4,2(a5)
8000ae38:	0037c783          	lbu	a5,3(a5)
8000ae3c:	07a2                	sll	a5,a5,0x8
8000ae3e:	8fd9                	or	a5,a5,a4
8000ae40:	07c2                	sll	a5,a5,0x10
8000ae42:	83c1                	srl	a5,a5,0x10
8000ae44:	00f14583          	lbu	a1,15(sp)
8000ae48:	01c14683          	lbu	a3,28(sp)
8000ae4c:	0ff7f713          	zext.b	a4,a5
8000ae50:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
8000ae54:	6785                	lui	a5,0x1
8000ae56:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000ae5a:	02f587b3          	mul	a5,a1,a5
8000ae5e:	97b2                	add	a5,a5,a2
8000ae60:	97b6                	add	a5,a5,a3
8000ae62:	6685                	lui	a3,0x1
8000ae64:	97b6                	add	a5,a5,a3
8000ae66:	86e78223          	sb	a4,-1948(a5)
            usbd_set_interface(busid, setup->wIndex, setup->wValue);
8000ae6a:	47a2                	lw	a5,8(sp)
8000ae6c:	0047c703          	lbu	a4,4(a5)
8000ae70:	0057c783          	lbu	a5,5(a5)
8000ae74:	07a2                	sll	a5,a5,0x8
8000ae76:	8fd9                	or	a5,a5,a4
8000ae78:	07c2                	sll	a5,a5,0x10
8000ae7a:	83c1                	srl	a5,a5,0x10
8000ae7c:	0ff7f693          	zext.b	a3,a5
8000ae80:	47a2                	lw	a5,8(sp)
8000ae82:	0027c703          	lbu	a4,2(a5)
8000ae86:	0037c783          	lbu	a5,3(a5)
8000ae8a:	07a2                	sll	a5,a5,0x8
8000ae8c:	8fd9                	or	a5,a5,a4
8000ae8e:	07c2                	sll	a5,a5,0x10
8000ae90:	83c1                	srl	a5,a5,0x10
8000ae92:	0ff7f713          	zext.b	a4,a5
8000ae96:	00f14783          	lbu	a5,15(sp)
8000ae9a:	863a                	mv	a2,a4
8000ae9c:	85b6                	mv	a1,a3
8000ae9e:	853e                	mv	a0,a5
8000aea0:	83bfb0ef          	jal	800066da <usbd_set_interface>
            *len = 0;
8000aea4:	4782                	lw	a5,0(sp)
8000aea6:	0007a023          	sw	zero,0(a5)
            break;
8000aeaa:	a021                	j	8000aeb2 <.L121>

8000aeac <.L114>:
            ret = false;
8000aeac:	020107a3          	sb	zero,47(sp)
            break;
8000aeb0:	0001                	nop

8000aeb2 <.L121>:
    return ret;
8000aeb2:	02f14783          	lbu	a5,47(sp)

8000aeb6 <.L113>:
}
8000aeb6:	853e                	mv	a0,a5
8000aeb8:	50f2                	lw	ra,60(sp)
8000aeba:	6121                	add	sp,sp,64
8000aebc:	8082                	ret

Disassembly of section .text.usbd_std_endpoint_req_handler:

8000aebe <usbd_std_endpoint_req_handler>:
{
8000aebe:	7179                	add	sp,sp,-48
8000aec0:	d606                	sw	ra,44(sp)
8000aec2:	87aa                	mv	a5,a0
8000aec4:	c42e                	sw	a1,8(sp)
8000aec6:	c232                	sw	a2,4(sp)
8000aec8:	c036                	sw	a3,0(sp)
8000aeca:	00f107a3          	sb	a5,15(sp)
    uint8_t ep = (uint8_t)setup->wIndex;
8000aece:	47a2                	lw	a5,8(sp)
8000aed0:	0047c703          	lbu	a4,4(a5)
8000aed4:	0057c783          	lbu	a5,5(a5)
8000aed8:	07a2                	sll	a5,a5,0x8
8000aeda:	8fd9                	or	a5,a5,a4
8000aedc:	07c2                	sll	a5,a5,0x10
8000aede:	83c1                	srl	a5,a5,0x10
8000aee0:	00f10f23          	sb	a5,30(sp)
    bool ret = true;
8000aee4:	4785                	li	a5,1
8000aee6:	00f10fa3          	sb	a5,31(sp)
    if (!is_device_configured(busid)) {
8000aeea:	00f14783          	lbu	a5,15(sp)
8000aeee:	853e                	mv	a0,a5
8000aef0:	860fb0ef          	jal	80005f50 <is_device_configured>
8000aef4:	87aa                	mv	a5,a0
8000aef6:	0017c793          	xor	a5,a5,1
8000aefa:	0ff7f793          	zext.b	a5,a5
8000aefe:	c399                	beqz	a5,8000af04 <.L140>
        return false;
8000af00:	4781                	li	a5,0
8000af02:	aa31                	j	8000b01e <.L153>

8000af04 <.L140>:
    switch (setup->bRequest) {
8000af04:	47a2                	lw	a5,8(sp)
8000af06:	0017c783          	lbu	a5,1(a5)
8000af0a:	4731                	li	a4,12
8000af0c:	10e78163          	beq	a5,a4,8000b00e <.L142>
8000af10:	4731                	li	a4,12
8000af12:	10f74163          	blt	a4,a5,8000b014 <.L143>
8000af16:	470d                	li	a4,3
8000af18:	0ae78363          	beq	a5,a4,8000afbe <.L144>
8000af1c:	470d                	li	a4,3
8000af1e:	0ef74b63          	blt	a4,a5,8000b014 <.L143>
8000af22:	c789                	beqz	a5,8000af2c <.L145>
8000af24:	4705                	li	a4,1
8000af26:	04e78463          	beq	a5,a4,8000af6e <.L146>
8000af2a:	a0ed                	j	8000b014 <.L143>

8000af2c <.L145>:
            usbd_ep_is_stalled(busid, ep, &stalled);
8000af2c:	01d10693          	add	a3,sp,29
8000af30:	01e14703          	lbu	a4,30(sp)
8000af34:	00f14783          	lbu	a5,15(sp)
8000af38:	8636                	mv	a2,a3
8000af3a:	85ba                	mv	a1,a4
8000af3c:	853e                	mv	a0,a5
8000af3e:	f07fc0ef          	jal	80007e44 <usbd_ep_is_stalled>
            if (stalled) {
8000af42:	01d14783          	lbu	a5,29(sp)
8000af46:	c799                	beqz	a5,8000af54 <.L147>
                (*data)[0] = 0x01;
8000af48:	4792                	lw	a5,4(sp)
8000af4a:	439c                	lw	a5,0(a5)
8000af4c:	4705                	li	a4,1
8000af4e:	00e78023          	sb	a4,0(a5)
8000af52:	a029                	j	8000af5c <.L148>

8000af54 <.L147>:
                (*data)[0] = 0x00;
8000af54:	4792                	lw	a5,4(sp)
8000af56:	439c                	lw	a5,0(a5)
8000af58:	00078023          	sb	zero,0(a5)

8000af5c <.L148>:
            (*data)[1] = 0x00;
8000af5c:	4792                	lw	a5,4(sp)
8000af5e:	439c                	lw	a5,0(a5)
8000af60:	0785                	add	a5,a5,1
8000af62:	00078023          	sb	zero,0(a5)
            *len = 2;
8000af66:	4782                	lw	a5,0(sp)
8000af68:	4709                	li	a4,2
8000af6a:	c398                	sw	a4,0(a5)
            break;
8000af6c:	a07d                	j	8000b01a <.L149>

8000af6e <.L146>:
            if (setup->wValue == USB_FEATURE_ENDPOINT_HALT) {
8000af6e:	47a2                	lw	a5,8(sp)
8000af70:	0027c703          	lbu	a4,2(a5)
8000af74:	0037c783          	lbu	a5,3(a5)
8000af78:	07a2                	sll	a5,a5,0x8
8000af7a:	8fd9                	or	a5,a5,a4
8000af7c:	07c2                	sll	a5,a5,0x10
8000af7e:	83c1                	srl	a5,a5,0x10
8000af80:	eb8d                	bnez	a5,8000afb2 <.L150>
                USB_LOG_ERR("ep:%02x clear halt\r\n", ep);
8000af82:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
8000af86:	cc8fe0ef          	jal	8000944e <printf>
8000af8a:	01e14783          	lbu	a5,30(sp)
8000af8e:	85be                	mv	a1,a5
8000af90:	62c20513          	add	a0,tp,1580 # 62c <.L134+0xa>
8000af94:	cbafe0ef          	jal	8000944e <printf>
8000af98:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
8000af9c:	cb2fe0ef          	jal	8000944e <printf>
                usbd_ep_clear_stall(busid, ep);
8000afa0:	01e14703          	lbu	a4,30(sp)
8000afa4:	00f14783          	lbu	a5,15(sp)
8000afa8:	85ba                	mv	a1,a4
8000afaa:	853e                	mv	a0,a5
8000afac:	e57fc0ef          	jal	80007e02 <usbd_ep_clear_stall>
                break;
8000afb0:	a0ad                	j	8000b01a <.L149>

8000afb2 <.L150>:
                ret = false;
8000afb2:	00010fa3          	sb	zero,31(sp)
            *len = 0;
8000afb6:	4782                	lw	a5,0(sp)
8000afb8:	0007a023          	sw	zero,0(a5)
            break;
8000afbc:	a8b9                	j	8000b01a <.L149>

8000afbe <.L144>:
            if (setup->wValue == USB_FEATURE_ENDPOINT_HALT) {
8000afbe:	47a2                	lw	a5,8(sp)
8000afc0:	0027c703          	lbu	a4,2(a5)
8000afc4:	0037c783          	lbu	a5,3(a5)
8000afc8:	07a2                	sll	a5,a5,0x8
8000afca:	8fd9                	or	a5,a5,a4
8000afcc:	07c2                	sll	a5,a5,0x10
8000afce:	83c1                	srl	a5,a5,0x10
8000afd0:	eb8d                	bnez	a5,8000b002 <.L151>
                USB_LOG_ERR("ep:%02x set halt\r\n", ep);
8000afd2:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
8000afd6:	c78fe0ef          	jal	8000944e <printf>
8000afda:	01e14783          	lbu	a5,30(sp)
8000afde:	85be                	mv	a1,a5
8000afe0:	64420513          	add	a0,tp,1604 # 644 <.L134+0x22>
8000afe4:	c6afe0ef          	jal	8000944e <printf>
8000afe8:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
8000afec:	c62fe0ef          	jal	8000944e <printf>
                usbd_ep_set_stall(busid, ep);
8000aff0:	01e14703          	lbu	a4,30(sp)
8000aff4:	00f14783          	lbu	a5,15(sp)
8000aff8:	85ba                	mv	a1,a4
8000affa:	853e                	mv	a0,a5
8000affc:	dc5fc0ef          	jal	80007dc0 <usbd_ep_set_stall>
8000b000:	a019                	j	8000b006 <.L152>

8000b002 <.L151>:
                ret = false;
8000b002:	00010fa3          	sb	zero,31(sp)

8000b006 <.L152>:
            *len = 0;
8000b006:	4782                	lw	a5,0(sp)
8000b008:	0007a023          	sw	zero,0(a5)
            break;
8000b00c:	a039                	j	8000b01a <.L149>

8000b00e <.L142>:
            ret = false;
8000b00e:	00010fa3          	sb	zero,31(sp)
            break;
8000b012:	a021                	j	8000b01a <.L149>

8000b014 <.L143>:
            ret = false;
8000b014:	00010fa3          	sb	zero,31(sp)
            break;
8000b018:	0001                	nop

8000b01a <.L149>:
    return ret;
8000b01a:	01f14783          	lbu	a5,31(sp)

8000b01e <.L153>:
}
8000b01e:	853e                	mv	a0,a5
8000b020:	50b2                	lw	ra,44(sp)
8000b022:	6145                	add	sp,sp,48
8000b024:	8082                	ret

Disassembly of section .text.usbd_standard_request_handler:

8000b026 <usbd_standard_request_handler>:
{
8000b026:	7179                	add	sp,sp,-48
8000b028:	d606                	sw	ra,44(sp)
8000b02a:	87aa                	mv	a5,a0
8000b02c:	c42e                	sw	a1,8(sp)
8000b02e:	c232                	sw	a2,4(sp)
8000b030:	c036                	sw	a3,0(sp)
8000b032:	00f107a3          	sb	a5,15(sp)
    int rc = 0;
8000b036:	ce02                	sw	zero,28(sp)
    switch (setup->bmRequestType & USB_REQUEST_RECIPIENT_MASK) {
8000b038:	47a2                	lw	a5,8(sp)
8000b03a:	0007c783          	lbu	a5,0(a5)
8000b03e:	8b8d                	and	a5,a5,3
8000b040:	4709                	li	a4,2
8000b042:	04e78b63          	beq	a5,a4,8000b098 <.L155>
8000b046:	4709                	li	a4,2
8000b048:	06f76863          	bltu	a4,a5,8000b0b8 <.L156>
8000b04c:	c789                	beqz	a5,8000b056 <.L157>
8000b04e:	4705                	li	a4,1
8000b050:	02e78463          	beq	a5,a4,8000b078 <.L158>
8000b054:	a095                	j	8000b0b8 <.L156>

8000b056 <.L157>:
            if (usbd_std_device_req_handler(busid, setup, data, len) == false) {
8000b056:	00f14783          	lbu	a5,15(sp)
8000b05a:	4682                	lw	a3,0(sp)
8000b05c:	4612                	lw	a2,4(sp)
8000b05e:	45a2                	lw	a1,8(sp)
8000b060:	853e                	mv	a0,a5
8000b062:	ffafb0ef          	jal	8000685c <usbd_std_device_req_handler>
8000b066:	87aa                	mv	a5,a0
8000b068:	0017c793          	xor	a5,a5,1
8000b06c:	0ff7f793          	zext.b	a5,a5
8000b070:	c7b9                	beqz	a5,8000b0be <.L164>
                rc = -1;
8000b072:	57fd                	li	a5,-1
8000b074:	ce3e                	sw	a5,28(sp)
            break;
8000b076:	a0a1                	j	8000b0be <.L164>

8000b078 <.L158>:
            if (usbd_std_interface_req_handler(busid, setup, data, len) == false) {
8000b078:	00f14783          	lbu	a5,15(sp)
8000b07c:	4682                	lw	a3,0(sp)
8000b07e:	4612                	lw	a2,4(sp)
8000b080:	45a2                	lw	a1,8(sp)
8000b082:	853e                	mv	a0,a5
8000b084:	36b9                	jal	8000abd2 <usbd_std_interface_req_handler>
8000b086:	87aa                	mv	a5,a0
8000b088:	0017c793          	xor	a5,a5,1
8000b08c:	0ff7f793          	zext.b	a5,a5
8000b090:	cb8d                	beqz	a5,8000b0c2 <.L165>
                rc = -1;
8000b092:	57fd                	li	a5,-1
8000b094:	ce3e                	sw	a5,28(sp)
            break;
8000b096:	a035                	j	8000b0c2 <.L165>

8000b098 <.L155>:
            if (usbd_std_endpoint_req_handler(busid, setup, data, len) == false) {
8000b098:	00f14783          	lbu	a5,15(sp)
8000b09c:	4682                	lw	a3,0(sp)
8000b09e:	4612                	lw	a2,4(sp)
8000b0a0:	45a2                	lw	a1,8(sp)
8000b0a2:	853e                	mv	a0,a5
8000b0a4:	3d29                	jal	8000aebe <usbd_std_endpoint_req_handler>
8000b0a6:	87aa                	mv	a5,a0
8000b0a8:	0017c793          	xor	a5,a5,1
8000b0ac:	0ff7f793          	zext.b	a5,a5
8000b0b0:	cb99                	beqz	a5,8000b0c6 <.L166>
                rc = -1;
8000b0b2:	57fd                	li	a5,-1
8000b0b4:	ce3e                	sw	a5,28(sp)
            break;
8000b0b6:	a801                	j	8000b0c6 <.L166>

8000b0b8 <.L156>:
            rc = -1;
8000b0b8:	57fd                	li	a5,-1
8000b0ba:	ce3e                	sw	a5,28(sp)
            break;
8000b0bc:	a031                	j	8000b0c8 <.L160>

8000b0be <.L164>:
            break;
8000b0be:	0001                	nop
8000b0c0:	a021                	j	8000b0c8 <.L160>

8000b0c2 <.L165>:
            break;
8000b0c2:	0001                	nop
8000b0c4:	a011                	j	8000b0c8 <.L160>

8000b0c6 <.L166>:
            break;
8000b0c6:	0001                	nop

8000b0c8 <.L160>:
    return rc;
8000b0c8:	47f2                	lw	a5,28(sp)
}
8000b0ca:	853e                	mv	a0,a5
8000b0cc:	50b2                	lw	ra,44(sp)
8000b0ce:	6145                	add	sp,sp,48
8000b0d0:	8082                	ret

Disassembly of section .text.usbd_event_connect_handler:

8000b0d2 <usbd_event_connect_handler>:
{
8000b0d2:	1101                	add	sp,sp,-32
8000b0d4:	ce06                	sw	ra,28(sp)
8000b0d6:	87aa                	mv	a5,a0
8000b0d8:	00f107a3          	sb	a5,15(sp)
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_CONNECTED);
8000b0dc:	00f14683          	lbu	a3,15(sp)
8000b0e0:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b0e4:	6785                	lui	a5,0x1
8000b0e6:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b0ea:	02f687b3          	mul	a5,a3,a5
8000b0ee:	97ba                	add	a5,a5,a4
8000b0f0:	6705                	lui	a4,0x1
8000b0f2:	97ba                	add	a5,a5,a4
8000b0f4:	9387a783          	lw	a5,-1736(a5)
8000b0f8:	00f14703          	lbu	a4,15(sp)
8000b0fc:	458d                	li	a1,3
8000b0fe:	853a                	mv	a0,a4
8000b100:	9782                	jalr	a5
}
8000b102:	0001                	nop
8000b104:	40f2                	lw	ra,28(sp)
8000b106:	6105                	add	sp,sp,32
8000b108:	8082                	ret

Disassembly of section .text.usbd_event_disconnect_handler:

8000b10a <usbd_event_disconnect_handler>:
{
8000b10a:	1101                	add	sp,sp,-32
8000b10c:	ce06                	sw	ra,28(sp)
8000b10e:	87aa                	mv	a5,a0
8000b110:	00f107a3          	sb	a5,15(sp)
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_DISCONNECTED);
8000b114:	00f14683          	lbu	a3,15(sp)
8000b118:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b11c:	6785                	lui	a5,0x1
8000b11e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b122:	02f687b3          	mul	a5,a3,a5
8000b126:	97ba                	add	a5,a5,a4
8000b128:	6705                	lui	a4,0x1
8000b12a:	97ba                	add	a5,a5,a4
8000b12c:	9387a783          	lw	a5,-1736(a5)
8000b130:	00f14703          	lbu	a4,15(sp)
8000b134:	4591                	li	a1,4
8000b136:	853a                	mv	a0,a4
8000b138:	9782                	jalr	a5
}
8000b13a:	0001                	nop
8000b13c:	40f2                	lw	ra,28(sp)
8000b13e:	6105                	add	sp,sp,32
8000b140:	8082                	ret

Disassembly of section .text.usbd_event_resume_handler:

8000b142 <usbd_event_resume_handler>:
{
8000b142:	1101                	add	sp,sp,-32
8000b144:	ce06                	sw	ra,28(sp)
8000b146:	87aa                	mv	a5,a0
8000b148:	00f107a3          	sb	a5,15(sp)
    g_usbd_core[busid].is_suspend = false;
8000b14c:	00f14683          	lbu	a3,15(sp)
8000b150:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b154:	6785                	lui	a5,0x1
8000b156:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b15a:	02f687b3          	mul	a5,a3,a5
8000b15e:	97ba                	add	a5,a5,a4
8000b160:	6705                	lui	a4,0x1
8000b162:	97ba                	add	a5,a5,a4
8000b164:	820780a3          	sb	zero,-2015(a5)
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_RESUME);
8000b168:	00f14683          	lbu	a3,15(sp)
8000b16c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b170:	6785                	lui	a5,0x1
8000b172:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b176:	02f687b3          	mul	a5,a3,a5
8000b17a:	97ba                	add	a5,a5,a4
8000b17c:	6705                	lui	a4,0x1
8000b17e:	97ba                	add	a5,a5,a4
8000b180:	9387a783          	lw	a5,-1736(a5)
8000b184:	00f14703          	lbu	a4,15(sp)
8000b188:	4599                	li	a1,6
8000b18a:	853a                	mv	a0,a4
8000b18c:	9782                	jalr	a5
}
8000b18e:	0001                	nop
8000b190:	40f2                	lw	ra,28(sp)
8000b192:	6105                	add	sp,sp,32
8000b194:	8082                	ret

Disassembly of section .text.usbd_event_suspend_handler:

8000b196 <usbd_event_suspend_handler>:
{
8000b196:	1101                	add	sp,sp,-32
8000b198:	ce06                	sw	ra,28(sp)
8000b19a:	87aa                	mv	a5,a0
8000b19c:	00f107a3          	sb	a5,15(sp)
    if (g_usbd_core[busid].device_address > 0) {
8000b1a0:	00f14683          	lbu	a3,15(sp)
8000b1a4:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b1a8:	6785                	lui	a5,0x1
8000b1aa:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b1ae:	02f687b3          	mul	a5,a3,a5
8000b1b2:	97ba                	add	a5,a5,a4
8000b1b4:	6705                	lui	a4,0x1
8000b1b6:	97ba                	add	a5,a5,a4
8000b1b8:	81d7c783          	lbu	a5,-2019(a5)
8000b1bc:	c3b9                	beqz	a5,8000b202 <.L215>
        g_usbd_core[busid].is_suspend = true;
8000b1be:	00f14683          	lbu	a3,15(sp)
8000b1c2:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b1c6:	6785                	lui	a5,0x1
8000b1c8:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b1cc:	02f687b3          	mul	a5,a3,a5
8000b1d0:	97ba                	add	a5,a5,a4
8000b1d2:	6705                	lui	a4,0x1
8000b1d4:	97ba                	add	a5,a5,a4
8000b1d6:	4705                	li	a4,1
8000b1d8:	82e780a3          	sb	a4,-2015(a5)
        g_usbd_core[busid].event_handler(busid, USBD_EVENT_SUSPEND);
8000b1dc:	00f14683          	lbu	a3,15(sp)
8000b1e0:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b1e4:	6785                	lui	a5,0x1
8000b1e6:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b1ea:	02f687b3          	mul	a5,a3,a5
8000b1ee:	97ba                	add	a5,a5,a4
8000b1f0:	6705                	lui	a4,0x1
8000b1f2:	97ba                	add	a5,a5,a4
8000b1f4:	9387a783          	lw	a5,-1736(a5)
8000b1f8:	00f14703          	lbu	a4,15(sp)
8000b1fc:	4595                	li	a1,5
8000b1fe:	853a                	mv	a0,a4
8000b200:	9782                	jalr	a5

8000b202 <.L215>:
}
8000b202:	0001                	nop
8000b204:	40f2                	lw	ra,28(sp)
8000b206:	6105                	add	sp,sp,32
8000b208:	8082                	ret

Disassembly of section .text.usbd_event_ep0_out_complete_handler:

8000b20a <usbd_event_ep0_out_complete_handler>:
{
8000b20a:	7179                	add	sp,sp,-48
8000b20c:	d606                	sw	ra,44(sp)
8000b20e:	87aa                	mv	a5,a0
8000b210:	872e                	mv	a4,a1
8000b212:	c432                	sw	a2,8(sp)
8000b214:	00f107a3          	sb	a5,15(sp)
8000b218:	87ba                	mv	a5,a4
8000b21a:	00f10723          	sb	a5,14(sp)
    struct usb_setup_packet *setup = &g_usbd_core[busid].setup;
8000b21e:	00f14703          	lbu	a4,15(sp)
8000b222:	6785                	lui	a5,0x1
8000b224:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b228:	02f70733          	mul	a4,a4,a5
8000b22c:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
8000b230:	97ba                	add	a5,a5,a4
8000b232:	ce3e                	sw	a5,28(sp)
    if (nbytes > 0) {
8000b234:	47a2                	lw	a5,8(sp)
8000b236:	14078963          	beqz	a5,8000b388 <.L233>
        g_usbd_core[busid].ep0_data_buf += nbytes;
8000b23a:	00f14683          	lbu	a3,15(sp)
8000b23e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b242:	6785                	lui	a5,0x1
8000b244:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b248:	02f687b3          	mul	a5,a3,a5
8000b24c:	97ba                	add	a5,a5,a4
8000b24e:	4798                	lw	a4,8(a5)
8000b250:	00f14603          	lbu	a2,15(sp)
8000b254:	47a2                	lw	a5,8(sp)
8000b256:	973e                	add	a4,a4,a5
8000b258:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000b25c:	6785                	lui	a5,0x1
8000b25e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b262:	02f607b3          	mul	a5,a2,a5
8000b266:	97b6                	add	a5,a5,a3
8000b268:	c798                	sw	a4,8(a5)
        g_usbd_core[busid].ep0_data_buf_residue -= nbytes;
8000b26a:	00f14683          	lbu	a3,15(sp)
8000b26e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b272:	6785                	lui	a5,0x1
8000b274:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b278:	02f687b3          	mul	a5,a3,a5
8000b27c:	97ba                	add	a5,a5,a4
8000b27e:	47d8                	lw	a4,12(a5)
8000b280:	00f14603          	lbu	a2,15(sp)
8000b284:	47a2                	lw	a5,8(sp)
8000b286:	8f1d                	sub	a4,a4,a5
8000b288:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000b28c:	6785                	lui	a5,0x1
8000b28e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b292:	02f607b3          	mul	a5,a2,a5
8000b296:	97b6                	add	a5,a5,a3
8000b298:	c7d8                	sw	a4,12(a5)
        if (g_usbd_core[busid].ep0_data_buf_residue == 0) {
8000b29a:	00f14683          	lbu	a3,15(sp)
8000b29e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b2a2:	6785                	lui	a5,0x1
8000b2a4:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b2a8:	02f687b3          	mul	a5,a3,a5
8000b2ac:	97ba                	add	a5,a5,a4
8000b2ae:	47dc                	lw	a5,12(a5)
8000b2b0:	e3c5                	bnez	a5,8000b350 <.L235>
            g_usbd_core[busid].ep0_data_buf = g_usbd_core[busid].req_data;
8000b2b2:	00f14703          	lbu	a4,15(sp)
8000b2b6:	00f14603          	lbu	a2,15(sp)
8000b2ba:	6785                	lui	a5,0x1
8000b2bc:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b2c0:	02f707b3          	mul	a5,a4,a5
8000b2c4:	01078713          	add	a4,a5,16
8000b2c8:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
8000b2cc:	97ba                	add	a5,a5,a4
8000b2ce:	00c78713          	add	a4,a5,12
8000b2d2:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000b2d6:	6785                	lui	a5,0x1
8000b2d8:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b2dc:	02f607b3          	mul	a5,a2,a5
8000b2e0:	97b6                	add	a5,a5,a3
8000b2e2:	c798                	sw	a4,8(a5)
            if (!usbd_setup_request_handler(busid, setup, &g_usbd_core[busid].ep0_data_buf, &g_usbd_core[busid].ep0_data_buf_len)) {
8000b2e4:	00f14703          	lbu	a4,15(sp)
8000b2e8:	6785                	lui	a5,0x1
8000b2ea:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b2ee:	02f70733          	mul	a4,a4,a5
8000b2f2:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
8000b2f6:	97ba                	add	a5,a5,a4
8000b2f8:	00878613          	add	a2,a5,8
8000b2fc:	00f14703          	lbu	a4,15(sp)
8000b300:	6785                	lui	a5,0x1
8000b302:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b306:	02f707b3          	mul	a5,a4,a5
8000b30a:	01078713          	add	a4,a5,16
8000b30e:	80018793          	add	a5,gp,-2048 # 1104078 <g_usbd_core>
8000b312:	973e                	add	a4,a4,a5
8000b314:	00f14783          	lbu	a5,15(sp)
8000b318:	86ba                	mv	a3,a4
8000b31a:	45f2                	lw	a1,28(sp)
8000b31c:	853e                	mv	a0,a5
8000b31e:	e5dfb0ef          	jal	8000717a <usbd_setup_request_handler>
8000b322:	87aa                	mv	a5,a0
8000b324:	0017c793          	xor	a5,a5,1
8000b328:	0ff7f793          	zext.b	a5,a5
8000b32c:	cb89                	beqz	a5,8000b33e <.L236>
                usbd_ep_set_stall(busid, USB_CONTROL_IN_EP0);
8000b32e:	00f14783          	lbu	a5,15(sp)
8000b332:	08000593          	li	a1,128
8000b336:	853e                	mv	a0,a5
8000b338:	a89fc0ef          	jal	80007dc0 <usbd_ep_set_stall>
                return;
8000b33c:	a0b1                	j	8000b388 <.L233>

8000b33e <.L236>:
            usbd_ep_start_write(busid, USB_CONTROL_IN_EP0, NULL, 0);
8000b33e:	00f14783          	lbu	a5,15(sp)
8000b342:	4681                	li	a3,0
8000b344:	4601                	li	a2,0
8000b346:	08000593          	li	a1,128
8000b34a:	853e                	mv	a0,a5
8000b34c:	2d49                	jal	8000b9de <usbd_ep_start_write>
8000b34e:	a82d                	j	8000b388 <.L233>

8000b350 <.L235>:
            usbd_ep_start_read(busid, USB_CONTROL_OUT_EP0, g_usbd_core[busid].ep0_data_buf, g_usbd_core[busid].ep0_data_buf_residue);
8000b350:	00f14683          	lbu	a3,15(sp)
8000b354:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b358:	6785                	lui	a5,0x1
8000b35a:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b35e:	02f687b3          	mul	a5,a3,a5
8000b362:	97ba                	add	a5,a5,a4
8000b364:	4790                	lw	a2,8(a5)
8000b366:	00f14683          	lbu	a3,15(sp)
8000b36a:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b36e:	6785                	lui	a5,0x1
8000b370:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b374:	02f687b3          	mul	a5,a3,a5
8000b378:	97ba                	add	a5,a5,a4
8000b37a:	47d8                	lw	a4,12(a5)
8000b37c:	00f14783          	lbu	a5,15(sp)
8000b380:	86ba                	mv	a3,a4
8000b382:	4581                	li	a1,0
8000b384:	853e                	mv	a0,a5
8000b386:	2785                	jal	8000bae6 <usbd_ep_start_read>

8000b388 <.L233>:
}
8000b388:	50b2                	lw	ra,44(sp)
8000b38a:	6145                	add	sp,sp,48
8000b38c:	8082                	ret

Disassembly of section .text.usbd_add_interface:

8000b38e <usbd_add_interface>:
    g_usbd_core[busid].webusb_url_desc = desc;
}
#endif

void usbd_add_interface(uint8_t busid, struct usbd_interface *intf)
{
8000b38e:	1141                	add	sp,sp,-16
8000b390:	87aa                	mv	a5,a0
8000b392:	c42e                	sw	a1,8(sp)
8000b394:	00f107a3          	sb	a5,15(sp)
    intf->intf_num = g_usbd_core[busid].intf_offset;
8000b398:	00f14683          	lbu	a3,15(sp)
8000b39c:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b3a0:	6785                	lui	a5,0x1
8000b3a2:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b3a6:	02f687b3          	mul	a5,a3,a5
8000b3aa:	97ba                	add	a5,a5,a4
8000b3ac:	6705                	lui	a4,0x1
8000b3ae:	97ba                	add	a5,a5,a4
8000b3b0:	8747c703          	lbu	a4,-1932(a5)
8000b3b4:	47a2                	lw	a5,8(sp)
8000b3b6:	00e78c23          	sb	a4,24(a5)
    g_usbd_core[busid].intf[g_usbd_core[busid].intf_offset] = intf;
8000b3ba:	00f14683          	lbu	a3,15(sp)
8000b3be:	00f14603          	lbu	a2,15(sp)
8000b3c2:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b3c6:	6785                	lui	a5,0x1
8000b3c8:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b3cc:	02f607b3          	mul	a5,a2,a5
8000b3d0:	97ba                	add	a5,a5,a4
8000b3d2:	6705                	lui	a4,0x1
8000b3d4:	97ba                	add	a5,a5,a4
8000b3d6:	8747c783          	lbu	a5,-1932(a5)
8000b3da:	863e                	mv	a2,a5
8000b3dc:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b3e0:	24f00793          	li	a5,591
8000b3e4:	02f687b3          	mul	a5,a3,a5
8000b3e8:	97b2                	add	a5,a5,a2
8000b3ea:	20878793          	add	a5,a5,520
8000b3ee:	078a                	sll	a5,a5,0x2
8000b3f0:	97ba                	add	a5,a5,a4
8000b3f2:	4722                	lw	a4,8(sp)
8000b3f4:	c3d8                	sw	a4,4(a5)
    g_usbd_core[busid].intf_offset++;
8000b3f6:	00f14703          	lbu	a4,15(sp)
8000b3fa:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000b3fe:	6785                	lui	a5,0x1
8000b400:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b404:	02f707b3          	mul	a5,a4,a5
8000b408:	97b6                	add	a5,a5,a3
8000b40a:	6685                	lui	a3,0x1
8000b40c:	97b6                	add	a5,a5,a3
8000b40e:	8747c783          	lbu	a5,-1932(a5)
8000b412:	0785                	add	a5,a5,1
8000b414:	0ff7f693          	zext.b	a3,a5
8000b418:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
8000b41c:	6785                	lui	a5,0x1
8000b41e:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b422:	02f707b3          	mul	a5,a4,a5
8000b426:	97b2                	add	a5,a5,a2
8000b428:	6705                	lui	a4,0x1
8000b42a:	97ba                	add	a5,a5,a4
8000b42c:	86d78a23          	sb	a3,-1932(a5)
}
8000b430:	0001                	nop
8000b432:	0141                	add	sp,sp,16
8000b434:	8082                	ret

Disassembly of section .text.usbd_add_endpoint:

8000b436 <usbd_add_endpoint>:

void usbd_add_endpoint(uint8_t busid, struct usbd_endpoint *ep)
{
8000b436:	1141                	add	sp,sp,-16
8000b438:	87aa                	mv	a5,a0
8000b43a:	c42e                	sw	a1,8(sp)
8000b43c:	00f107a3          	sb	a5,15(sp)
    if (ep->ep_addr & 0x80) {
8000b440:	47a2                	lw	a5,8(sp)
8000b442:	0007c783          	lbu	a5,0(a5)
8000b446:	07e2                	sll	a5,a5,0x18
8000b448:	87e1                	sra	a5,a5,0x18
8000b44a:	0607d863          	bgez	a5,8000b4ba <.L246>
        g_usbd_core[busid].tx_msg[ep->ep_addr & 0x7f].ep = ep->ep_addr;
8000b44e:	00f14583          	lbu	a1,15(sp)
8000b452:	47a2                	lw	a5,8(sp)
8000b454:	0007c783          	lbu	a5,0(a5)
8000b458:	07f7f713          	and	a4,a5,127
8000b45c:	47a2                	lw	a5,8(sp)
8000b45e:	0007c683          	lbu	a3,0(a5)
8000b462:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
8000b466:	87ba                	mv	a5,a4
8000b468:	0786                	sll	a5,a5,0x1
8000b46a:	97ba                	add	a5,a5,a4
8000b46c:	078a                	sll	a5,a5,0x2
8000b46e:	6705                	lui	a4,0x1
8000b470:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
8000b474:	02e58733          	mul	a4,a1,a4
8000b478:	97ba                	add	a5,a5,a4
8000b47a:	97b2                	add	a5,a5,a2
8000b47c:	6705                	lui	a4,0x1
8000b47e:	97ba                	add	a5,a5,a4
8000b480:	86d78c23          	sb	a3,-1928(a5)
        g_usbd_core[busid].tx_msg[ep->ep_addr & 0x7f].cb = ep->ep_cb;
8000b484:	00f14583          	lbu	a1,15(sp)
8000b488:	47a2                	lw	a5,8(sp)
8000b48a:	0007c783          	lbu	a5,0(a5)
8000b48e:	07f7f713          	and	a4,a5,127
8000b492:	47a2                	lw	a5,8(sp)
8000b494:	43d4                	lw	a3,4(a5)
8000b496:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
8000b49a:	87ba                	mv	a5,a4
8000b49c:	0786                	sll	a5,a5,0x1
8000b49e:	97ba                	add	a5,a5,a4
8000b4a0:	078a                	sll	a5,a5,0x2
8000b4a2:	6705                	lui	a4,0x1
8000b4a4:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
8000b4a8:	02e58733          	mul	a4,a1,a4
8000b4ac:	97ba                	add	a5,a5,a4
8000b4ae:	97b2                	add	a5,a5,a2
8000b4b0:	6705                	lui	a4,0x1
8000b4b2:	97ba                	add	a5,a5,a4
8000b4b4:	88d7a023          	sw	a3,-1920(a5)
    } else {
        g_usbd_core[busid].rx_msg[ep->ep_addr & 0x7f].ep = ep->ep_addr;
        g_usbd_core[busid].rx_msg[ep->ep_addr & 0x7f].cb = ep->ep_cb;
    }
}
8000b4b8:	a0b5                	j	8000b524 <.L248>

8000b4ba <.L246>:
        g_usbd_core[busid].rx_msg[ep->ep_addr & 0x7f].ep = ep->ep_addr;
8000b4ba:	00f14583          	lbu	a1,15(sp)
8000b4be:	47a2                	lw	a5,8(sp)
8000b4c0:	0007c783          	lbu	a5,0(a5)
8000b4c4:	07f7f713          	and	a4,a5,127
8000b4c8:	47a2                	lw	a5,8(sp)
8000b4ca:	0007c683          	lbu	a3,0(a5)
8000b4ce:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
8000b4d2:	87ba                	mv	a5,a4
8000b4d4:	0786                	sll	a5,a5,0x1
8000b4d6:	97ba                	add	a5,a5,a4
8000b4d8:	078a                	sll	a5,a5,0x2
8000b4da:	6705                	lui	a4,0x1
8000b4dc:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
8000b4e0:	02e58733          	mul	a4,a1,a4
8000b4e4:	97ba                	add	a5,a5,a4
8000b4e6:	97b2                	add	a5,a5,a2
8000b4e8:	6705                	lui	a4,0x1
8000b4ea:	97ba                	add	a5,a5,a4
8000b4ec:	8cd78c23          	sb	a3,-1832(a5)
        g_usbd_core[busid].rx_msg[ep->ep_addr & 0x7f].cb = ep->ep_cb;
8000b4f0:	00f14583          	lbu	a1,15(sp)
8000b4f4:	47a2                	lw	a5,8(sp)
8000b4f6:	0007c783          	lbu	a5,0(a5)
8000b4fa:	07f7f713          	and	a4,a5,127
8000b4fe:	47a2                	lw	a5,8(sp)
8000b500:	43d4                	lw	a3,4(a5)
8000b502:	80018613          	add	a2,gp,-2048 # 1104078 <g_usbd_core>
8000b506:	87ba                	mv	a5,a4
8000b508:	0786                	sll	a5,a5,0x1
8000b50a:	97ba                	add	a5,a5,a4
8000b50c:	078a                	sll	a5,a5,0x2
8000b50e:	6705                	lui	a4,0x1
8000b510:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
8000b514:	02e58733          	mul	a4,a1,a4
8000b518:	97ba                	add	a5,a5,a4
8000b51a:	97b2                	add	a5,a5,a2
8000b51c:	6705                	lui	a4,0x1
8000b51e:	97ba                	add	a5,a5,a4
8000b520:	8ed7a023          	sw	a3,-1824(a5)

8000b524 <.L248>:
}
8000b524:	0001                	nop
8000b526:	0141                	add	sp,sp,16
8000b528:	8082                	ret

Disassembly of section .text.usbd_get_ep_mps:

8000b52a <usbd_get_ep_mps>:

uint16_t usbd_get_ep_mps(uint8_t busid, uint8_t ep)
{
8000b52a:	1141                	add	sp,sp,-16
8000b52c:	87aa                	mv	a5,a0
8000b52e:	872e                	mv	a4,a1
8000b530:	00f107a3          	sb	a5,15(sp)
8000b534:	87ba                	mv	a5,a4
8000b536:	00f10723          	sb	a5,14(sp)
    if (ep & 0x80) {
8000b53a:	00e10783          	lb	a5,14(sp)
8000b53e:	0207da63          	bgez	a5,8000b572 <.L250>
        return g_usbd_core[busid].tx_msg[ep & 0x7f].ep_mps;
8000b542:	00f14603          	lbu	a2,15(sp)
8000b546:	00e14783          	lbu	a5,14(sp)
8000b54a:	07f7f713          	and	a4,a5,127
8000b54e:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000b552:	87ba                	mv	a5,a4
8000b554:	0786                	sll	a5,a5,0x1
8000b556:	97ba                	add	a5,a5,a4
8000b558:	078a                	sll	a5,a5,0x2
8000b55a:	6705                	lui	a4,0x1
8000b55c:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
8000b560:	02e60733          	mul	a4,a2,a4
8000b564:	97ba                	add	a5,a5,a4
8000b566:	97b6                	add	a5,a5,a3
8000b568:	6705                	lui	a4,0x1
8000b56a:	97ba                	add	a5,a5,a4
8000b56c:	87a7d783          	lhu	a5,-1926(a5)
8000b570:	a805                	j	8000b5a0 <.L251>

8000b572 <.L250>:
    } else {
        return g_usbd_core[busid].rx_msg[ep & 0x7f].ep_mps;
8000b572:	00f14603          	lbu	a2,15(sp)
8000b576:	00e14783          	lbu	a5,14(sp)
8000b57a:	07f7f713          	and	a4,a5,127
8000b57e:	80018693          	add	a3,gp,-2048 # 1104078 <g_usbd_core>
8000b582:	87ba                	mv	a5,a4
8000b584:	0786                	sll	a5,a5,0x1
8000b586:	97ba                	add	a5,a5,a4
8000b588:	078a                	sll	a5,a5,0x2
8000b58a:	6705                	lui	a4,0x1
8000b58c:	93c70713          	add	a4,a4,-1732 # 93c <.L165+0x12>
8000b590:	02e60733          	mul	a4,a2,a4
8000b594:	97ba                	add	a5,a5,a4
8000b596:	97b6                	add	a5,a5,a3
8000b598:	6705                	lui	a4,0x1
8000b59a:	97ba                	add	a5,a5,a4
8000b59c:	8da7d783          	lhu	a5,-1830(a5)

8000b5a0 <.L251>:
    }
}
8000b5a0:	853e                	mv	a0,a5
8000b5a2:	0141                	add	sp,sp,16
8000b5a4:	8082                	ret

Disassembly of section .text.usbd_initialize:

8000b5a6 <usbd_initialize>:
        return -1;
    }
}

int usbd_initialize(uint8_t busid, uintptr_t reg_base, void (*event_handler)(uint8_t busid, uint8_t event))
{
8000b5a6:	7179                	add	sp,sp,-48
8000b5a8:	d606                	sw	ra,44(sp)
8000b5aa:	87aa                	mv	a5,a0
8000b5ac:	c42e                	sw	a1,8(sp)
8000b5ae:	c232                	sw	a2,4(sp)
8000b5b0:	00f107a3          	sb	a5,15(sp)
    int ret;
    struct usbd_bus *bus;

    if (busid >= CONFIG_USBDEV_MAX_BUS) {
8000b5b4:	00f14703          	lbu	a4,15(sp)
8000b5b8:	4785                	li	a5,1
8000b5ba:	00e7ff63          	bgeu	a5,a4,8000b5d8 <.L266>
        USB_LOG_ERR("bus overflow\r\n");
8000b5be:	5d820513          	add	a0,tp,1496 # 5d8 <.L128+0x24>
8000b5c2:	e8dfd0ef          	jal	8000944e <printf>
8000b5c6:	74c20513          	add	a0,tp,1868 # 74c <.L152+0x10>
8000b5ca:	e85fd0ef          	jal	8000944e <printf>
8000b5ce:	5d020513          	add	a0,tp,1488 # 5d0 <.L128+0x1c>
8000b5d2:	e7dfd0ef          	jal	8000944e <printf>

8000b5d6 <.L267>:
        while (1) {
8000b5d6:	a001                	j	8000b5d6 <.L267>

8000b5d8 <.L266>:
        }
    }

    bus = &g_usbdev_bus[busid];
8000b5d8:	00f14783          	lbu	a5,15(sp)
8000b5dc:	00379713          	sll	a4,a5,0x3
8000b5e0:	010807b7          	lui	a5,0x1080
8000b5e4:	31c78793          	add	a5,a5,796 # 108031c <g_usbdev_bus>
8000b5e8:	97ba                	add	a5,a5,a4
8000b5ea:	ce3e                	sw	a5,28(sp)
    bus->reg_base = reg_base;
8000b5ec:	47f2                	lw	a5,28(sp)
8000b5ee:	4722                	lw	a4,8(sp)
8000b5f0:	c3d8                	sw	a4,4(a5)

    g_usbd_core[busid].event_handler = event_handler;
8000b5f2:	00f14683          	lbu	a3,15(sp)
8000b5f6:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b5fa:	6785                	lui	a5,0x1
8000b5fc:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b600:	02f687b3          	mul	a5,a3,a5
8000b604:	97ba                	add	a5,a5,a4
8000b606:	6705                	lui	a4,0x1
8000b608:	97ba                	add	a5,a5,a4
8000b60a:	4712                	lw	a4,4(sp)
8000b60c:	92e7ac23          	sw	a4,-1736(a5)
    ret = usb_dc_init(busid);
8000b610:	00f14783          	lbu	a5,15(sp)
8000b614:	853e                	mv	a0,a5
8000b616:	d7efc0ef          	jal	80007b94 <usb_dc_init>
8000b61a:	cc2a                	sw	a0,24(sp)
    usbd_class_event_notify_handler(busid, USBD_EVENT_INIT, NULL);
8000b61c:	00f14783          	lbu	a5,15(sp)
8000b620:	4601                	li	a2,0
8000b622:	45ad                	li	a1,11
8000b624:	853e                	mv	a0,a5
8000b626:	c73fb0ef          	jal	80007298 <usbd_class_event_notify_handler>
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_INIT);
8000b62a:	00f14683          	lbu	a3,15(sp)
8000b62e:	80018713          	add	a4,gp,-2048 # 1104078 <g_usbd_core>
8000b632:	6785                	lui	a5,0x1
8000b634:	93c78793          	add	a5,a5,-1732 # 93c <.L165+0x12>
8000b638:	02f687b3          	mul	a5,a3,a5
8000b63c:	97ba                	add	a5,a5,a4
8000b63e:	6705                	lui	a4,0x1
8000b640:	97ba                	add	a5,a5,a4
8000b642:	9387a783          	lw	a5,-1736(a5)
8000b646:	00f14703          	lbu	a4,15(sp)
8000b64a:	45ad                	li	a1,11
8000b64c:	853a                	mv	a0,a4
8000b64e:	9782                	jalr	a5
    return ret;
8000b650:	47e2                	lw	a5,24(sp)
}
8000b652:	853e                	mv	a0,a5
8000b654:	50b2                	lw	ra,44(sp)
8000b656:	6145                	add	sp,sp,48
8000b658:	8082                	ret

Disassembly of section .text.usb_get_port_speed:

8000b65a <usb_get_port_speed>:
{
8000b65a:	1141                	add	sp,sp,-16
8000b65c:	c62a                	sw	a0,12(sp)
    return USB_PORTSC1_PSPD_GET(ptr->PORTSC1);
8000b65e:	47b2                	lw	a5,12(sp)
8000b660:	1847a783          	lw	a5,388(a5)
8000b664:	83e9                	srl	a5,a5,0x1a
8000b666:	0ff7f793          	zext.b	a5,a5
8000b66a:	8b8d                	and	a5,a5,3
8000b66c:	0ff7f793          	zext.b	a5,a5
}
8000b670:	853e                	mv	a0,a5
8000b672:	0141                	add	sp,sp,16
8000b674:	8082                	ret

Disassembly of section .text.usb_set_port_test_mode:

8000b676 <usb_set_port_test_mode>:
{
8000b676:	1141                	add	sp,sp,-16
8000b678:	c62a                	sw	a0,12(sp)
8000b67a:	87ae                	mv	a5,a1
8000b67c:	00f105a3          	sb	a5,11(sp)
    ptr->PORTSC1 = (ptr->PORTSC1 & ~USB_PORTSC1_PTC_MASK) | USB_PORTSC1_PTC_SET(test_mode);
8000b680:	47b2                	lw	a5,12(sp)
8000b682:	1847a703          	lw	a4,388(a5)
8000b686:	fff107b7          	lui	a5,0xfff10
8000b68a:	17fd                	add	a5,a5,-1 # fff0ffff <__APB_SRAM_segment_end__+0xbe1dfff>
8000b68c:	8f7d                	and	a4,a4,a5
8000b68e:	00b14783          	lbu	a5,11(sp)
8000b692:	01079693          	sll	a3,a5,0x10
8000b696:	000f07b7          	lui	a5,0xf0
8000b69a:	8ff5                	and	a5,a5,a3
8000b69c:	8f5d                	or	a4,a4,a5
8000b69e:	47b2                	lw	a5,12(sp)
8000b6a0:	18e7a223          	sw	a4,388(a5) # f0184 <__DLM_segment_end__+0x30184>
}
8000b6a4:	0001                	nop
8000b6a6:	0141                	add	sp,sp,16
8000b6a8:	8082                	ret

Disassembly of section .text.usb_dcd_set_address:

8000b6aa <usb_dcd_set_address>:
{
8000b6aa:	1141                	add	sp,sp,-16
8000b6ac:	c62a                	sw	a0,12(sp)
8000b6ae:	87ae                	mv	a5,a1
8000b6b0:	00f105a3          	sb	a5,11(sp)
    ptr->DEVICEADDR = USB_DEVICEADDR_USBADR_SET(dev_addr) | USB_DEVICEADDR_USBADRA_MASK;
8000b6b4:	00b14783          	lbu	a5,11(sp)
8000b6b8:	01979713          	sll	a4,a5,0x19
8000b6bc:	010007b7          	lui	a5,0x1000
8000b6c0:	8f5d                	or	a4,a4,a5
8000b6c2:	47b2                	lw	a5,12(sp)
8000b6c4:	14e7aa23          	sw	a4,340(a5) # 1000154 <_extram_size+0x154>
}
8000b6c8:	0001                	nop
8000b6ca:	0141                	add	sp,sp,16
8000b6cc:	8082                	ret

Disassembly of section .text.usbd_execute_test_mode:

8000b6ce <usbd_execute_test_mode>:
{
8000b6ce:	1101                	add	sp,sp,-32
8000b6d0:	ce06                	sw	ra,28(sp)
8000b6d2:	87aa                	mv	a5,a0
8000b6d4:	872e                	mv	a4,a1
8000b6d6:	00f107a3          	sb	a5,15(sp)
8000b6da:	87ba                	mv	a5,a4
8000b6dc:	00f10723          	sb	a5,14(sp)
    usb_set_port_test_mode(g_hpm_udc[busid].handle->regs, test_mode);
8000b6e0:	00f14683          	lbu	a3,15(sp)
8000b6e4:	010807b7          	lui	a5,0x1080
8000b6e8:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000b6ec:	14800793          	li	a5,328
8000b6f0:	02f687b3          	mul	a5,a3,a5
8000b6f4:	97ba                	add	a5,a5,a4
8000b6f6:	439c                	lw	a5,0(a5)
8000b6f8:	439c                	lw	a5,0(a5)
8000b6fa:	00e14703          	lbu	a4,14(sp)
8000b6fe:	85ba                	mv	a1,a4
8000b700:	853e                	mv	a0,a5
8000b702:	3f95                	jal	8000b676 <usb_set_port_test_mode>
}
8000b704:	0001                	nop
8000b706:	40f2                	lw	ra,28(sp)
8000b708:	6105                	add	sp,sp,32
8000b70a:	8082                	ret

Disassembly of section .text.usbd_get_port_speed:

8000b70c <usbd_get_port_speed>:
{
8000b70c:	7179                	add	sp,sp,-48
8000b70e:	d606                	sw	ra,44(sp)
8000b710:	87aa                	mv	a5,a0
8000b712:	00f107a3          	sb	a5,15(sp)
    speed = usb_get_port_speed(g_hpm_udc[busid].handle->regs);
8000b716:	00f14683          	lbu	a3,15(sp)
8000b71a:	010807b7          	lui	a5,0x1080
8000b71e:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000b722:	14800793          	li	a5,328
8000b726:	02f687b3          	mul	a5,a3,a5
8000b72a:	97ba                	add	a5,a5,a4
8000b72c:	439c                	lw	a5,0(a5)
8000b72e:	439c                	lw	a5,0(a5)
8000b730:	853e                	mv	a0,a5
8000b732:	3725                	jal	8000b65a <usb_get_port_speed>
8000b734:	87aa                	mv	a5,a0
8000b736:	00f10fa3          	sb	a5,31(sp)
    if (speed == 0x00) {
8000b73a:	01f14783          	lbu	a5,31(sp)
8000b73e:	e399                	bnez	a5,8000b744 <.L26>
        return USB_SPEED_FULL;
8000b740:	4789                	li	a5,2
8000b742:	a005                	j	8000b762 <.L27>

8000b744 <.L26>:
    if (speed == 0x01) {
8000b744:	01f14703          	lbu	a4,31(sp)
8000b748:	4785                	li	a5,1
8000b74a:	00f71463          	bne	a4,a5,8000b752 <.L28>
        return USB_SPEED_LOW;
8000b74e:	4785                	li	a5,1
8000b750:	a809                	j	8000b762 <.L27>

8000b752 <.L28>:
    if (speed == 0x02) {
8000b752:	01f14703          	lbu	a4,31(sp)
8000b756:	4789                	li	a5,2
8000b758:	00f71463          	bne	a4,a5,8000b760 <.L29>
        return USB_SPEED_HIGH;
8000b75c:	478d                	li	a5,3
8000b75e:	a011                	j	8000b762 <.L27>

8000b760 <.L29>:
    return 0;
8000b760:	4781                	li	a5,0

8000b762 <.L27>:
}
8000b762:	853e                	mv	a0,a5
8000b764:	50b2                	lw	ra,44(sp)
8000b766:	6145                	add	sp,sp,48
8000b768:	8082                	ret

Disassembly of section .text.usbd_ep_open:

8000b76a <usbd_ep_open>:
{
8000b76a:	7179                	add	sp,sp,-48
8000b76c:	d606                	sw	ra,44(sp)
8000b76e:	87aa                	mv	a5,a0
8000b770:	c42e                	sw	a1,8(sp)
8000b772:	00f107a3          	sb	a5,15(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000b776:	00f14683          	lbu	a3,15(sp)
8000b77a:	010807b7          	lui	a5,0x1080
8000b77e:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000b782:	14800793          	li	a5,328
8000b786:	02f687b3          	mul	a5,a3,a5
8000b78a:	97ba                	add	a5,a5,a4
8000b78c:	439c                	lw	a5,0(a5)
8000b78e:	ce3e                	sw	a5,28(sp)
    uint8_t ep_idx = USB_EP_GET_IDX(ep->bEndpointAddress);
8000b790:	47a2                	lw	a5,8(sp)
8000b792:	0027c783          	lbu	a5,2(a5)
8000b796:	07f7f793          	and	a5,a5,127
8000b79a:	00f10da3          	sb	a5,27(sp)
    tmp_ep_cfg.xfer = USB_GET_ENDPOINT_TYPE(ep->bmAttributes);
8000b79e:	47a2                	lw	a5,8(sp)
8000b7a0:	0037c783          	lbu	a5,3(a5)
8000b7a4:	8b8d                	and	a5,a5,3
8000b7a6:	0ff7f793          	zext.b	a5,a5
8000b7aa:	00f10a23          	sb	a5,20(sp)
    tmp_ep_cfg.ep_addr = ep->bEndpointAddress;
8000b7ae:	47a2                	lw	a5,8(sp)
8000b7b0:	0027c783          	lbu	a5,2(a5)
8000b7b4:	00f10aa3          	sb	a5,21(sp)
    tmp_ep_cfg.max_packet_size = ep->wMaxPacketSize;
8000b7b8:	47a2                	lw	a5,8(sp)
8000b7ba:	0047c703          	lbu	a4,4(a5)
8000b7be:	0057c783          	lbu	a5,5(a5)
8000b7c2:	07a2                	sll	a5,a5,0x8
8000b7c4:	8fd9                	or	a5,a5,a4
8000b7c6:	07c2                	sll	a5,a5,0x10
8000b7c8:	83c1                	srl	a5,a5,0x10
8000b7ca:	00f11b23          	sh	a5,22(sp)
    usb_device_edpt_open(handle, &tmp_ep_cfg);
8000b7ce:	085c                	add	a5,sp,20
8000b7d0:	85be                	mv	a1,a5
8000b7d2:	4572                	lw	a0,28(sp)
8000b7d4:	ceff80ef          	jal	800044c2 <usb_device_edpt_open>
    if (USB_EP_DIR_IS_OUT(ep->bEndpointAddress)) {
8000b7d8:	47a2                	lw	a5,8(sp)
8000b7da:	0027c783          	lbu	a5,2(a5)
8000b7de:	07e2                	sll	a5,a5,0x18
8000b7e0:	87e1                	sra	a5,a5,0x18
8000b7e2:	0a07c463          	bltz	a5,8000b88a <.L31>
        g_hpm_udc[busid].out_ep[ep_idx].ep_mps = USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize);
8000b7e6:	47a2                	lw	a5,8(sp)
8000b7e8:	0047c703          	lbu	a4,4(a5)
8000b7ec:	0057c783          	lbu	a5,5(a5)
8000b7f0:	07a2                	sll	a5,a5,0x8
8000b7f2:	8fd9                	or	a5,a5,a4
8000b7f4:	07c2                	sll	a5,a5,0x10
8000b7f6:	83c1                	srl	a5,a5,0x10
8000b7f8:	00f14583          	lbu	a1,15(sp)
8000b7fc:	01b14703          	lbu	a4,27(sp)
8000b800:	7ff7f793          	and	a5,a5,2047
8000b804:	01079693          	sll	a3,a5,0x10
8000b808:	82c1                	srl	a3,a3,0x10
8000b80a:	010807b7          	lui	a5,0x1080
8000b80e:	02478613          	add	a2,a5,36 # 1080024 <g_hpm_udc>
8000b812:	87ba                	mv	a5,a4
8000b814:	078a                	sll	a5,a5,0x2
8000b816:	97ba                	add	a5,a5,a4
8000b818:	078a                	sll	a5,a5,0x2
8000b81a:	14800713          	li	a4,328
8000b81e:	02e58733          	mul	a4,a1,a4
8000b822:	97ba                	add	a5,a5,a4
8000b824:	97b2                	add	a5,a5,a2
8000b826:	0ad79423          	sh	a3,168(a5)
        g_hpm_udc[busid].out_ep[ep_idx].ep_type = USB_GET_ENDPOINT_TYPE(ep->bmAttributes);
8000b82a:	47a2                	lw	a5,8(sp)
8000b82c:	0037c783          	lbu	a5,3(a5)
8000b830:	00f14583          	lbu	a1,15(sp)
8000b834:	01b14703          	lbu	a4,27(sp)
8000b838:	8b8d                	and	a5,a5,3
8000b83a:	0ff7f693          	zext.b	a3,a5
8000b83e:	010807b7          	lui	a5,0x1080
8000b842:	02478613          	add	a2,a5,36 # 1080024 <g_hpm_udc>
8000b846:	87ba                	mv	a5,a4
8000b848:	078a                	sll	a5,a5,0x2
8000b84a:	97ba                	add	a5,a5,a4
8000b84c:	078a                	sll	a5,a5,0x2
8000b84e:	14800713          	li	a4,328
8000b852:	02e58733          	mul	a4,a1,a4
8000b856:	97ba                	add	a5,a5,a4
8000b858:	97b2                	add	a5,a5,a2
8000b85a:	0ad78523          	sb	a3,170(a5)
        g_hpm_udc[busid].out_ep[ep_idx].ep_enable = true;
8000b85e:	00f14603          	lbu	a2,15(sp)
8000b862:	01b14703          	lbu	a4,27(sp)
8000b866:	010807b7          	lui	a5,0x1080
8000b86a:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000b86e:	87ba                	mv	a5,a4
8000b870:	078a                	sll	a5,a5,0x2
8000b872:	97ba                	add	a5,a5,a4
8000b874:	078a                	sll	a5,a5,0x2
8000b876:	14800713          	li	a4,328
8000b87a:	02e60733          	mul	a4,a2,a4
8000b87e:	97ba                	add	a5,a5,a4
8000b880:	97b6                	add	a5,a5,a3
8000b882:	4705                	li	a4,1
8000b884:	0ae78623          	sb	a4,172(a5)
8000b888:	a055                	j	8000b92c <.L32>

8000b88a <.L31>:
        g_hpm_udc[busid].in_ep[ep_idx].ep_mps = USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize);
8000b88a:	47a2                	lw	a5,8(sp)
8000b88c:	0047c703          	lbu	a4,4(a5)
8000b890:	0057c783          	lbu	a5,5(a5)
8000b894:	07a2                	sll	a5,a5,0x8
8000b896:	8fd9                	or	a5,a5,a4
8000b898:	07c2                	sll	a5,a5,0x10
8000b89a:	83c1                	srl	a5,a5,0x10
8000b89c:	00f14583          	lbu	a1,15(sp)
8000b8a0:	01b14703          	lbu	a4,27(sp)
8000b8a4:	7ff7f793          	and	a5,a5,2047
8000b8a8:	01079693          	sll	a3,a5,0x10
8000b8ac:	82c1                	srl	a3,a3,0x10
8000b8ae:	010807b7          	lui	a5,0x1080
8000b8b2:	02478613          	add	a2,a5,36 # 1080024 <g_hpm_udc>
8000b8b6:	87ba                	mv	a5,a4
8000b8b8:	078a                	sll	a5,a5,0x2
8000b8ba:	97ba                	add	a5,a5,a4
8000b8bc:	078a                	sll	a5,a5,0x2
8000b8be:	14800713          	li	a4,328
8000b8c2:	02e58733          	mul	a4,a1,a4
8000b8c6:	97ba                	add	a5,a5,a4
8000b8c8:	97b2                	add	a5,a5,a2
8000b8ca:	00d79423          	sh	a3,8(a5)
        g_hpm_udc[busid].in_ep[ep_idx].ep_type = USB_GET_ENDPOINT_TYPE(ep->bmAttributes);
8000b8ce:	47a2                	lw	a5,8(sp)
8000b8d0:	0037c783          	lbu	a5,3(a5)
8000b8d4:	00f14583          	lbu	a1,15(sp)
8000b8d8:	01b14703          	lbu	a4,27(sp)
8000b8dc:	8b8d                	and	a5,a5,3
8000b8de:	0ff7f693          	zext.b	a3,a5
8000b8e2:	010807b7          	lui	a5,0x1080
8000b8e6:	02478613          	add	a2,a5,36 # 1080024 <g_hpm_udc>
8000b8ea:	87ba                	mv	a5,a4
8000b8ec:	078a                	sll	a5,a5,0x2
8000b8ee:	97ba                	add	a5,a5,a4
8000b8f0:	078a                	sll	a5,a5,0x2
8000b8f2:	14800713          	li	a4,328
8000b8f6:	02e58733          	mul	a4,a1,a4
8000b8fa:	97ba                	add	a5,a5,a4
8000b8fc:	97b2                	add	a5,a5,a2
8000b8fe:	00d78523          	sb	a3,10(a5)
        g_hpm_udc[busid].in_ep[ep_idx].ep_enable = true;
8000b902:	00f14603          	lbu	a2,15(sp)
8000b906:	01b14703          	lbu	a4,27(sp)
8000b90a:	010807b7          	lui	a5,0x1080
8000b90e:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000b912:	87ba                	mv	a5,a4
8000b914:	078a                	sll	a5,a5,0x2
8000b916:	97ba                	add	a5,a5,a4
8000b918:	078a                	sll	a5,a5,0x2
8000b91a:	14800713          	li	a4,328
8000b91e:	02e60733          	mul	a4,a2,a4
8000b922:	97ba                	add	a5,a5,a4
8000b924:	97b6                	add	a5,a5,a3
8000b926:	4705                	li	a4,1
8000b928:	00e78623          	sb	a4,12(a5)

8000b92c <.L32>:
    return 0;
8000b92c:	4781                	li	a5,0
}
8000b92e:	853e                	mv	a0,a5
8000b930:	50b2                	lw	ra,44(sp)
8000b932:	6145                	add	sp,sp,48
8000b934:	8082                	ret

Disassembly of section .text.usbd_ep_close:

8000b936 <usbd_ep_close>:
{
8000b936:	7179                	add	sp,sp,-48
8000b938:	d606                	sw	ra,44(sp)
8000b93a:	87aa                	mv	a5,a0
8000b93c:	872e                	mv	a4,a1
8000b93e:	00f107a3          	sb	a5,15(sp)
8000b942:	87ba                	mv	a5,a4
8000b944:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000b948:	00f14683          	lbu	a3,15(sp)
8000b94c:	010807b7          	lui	a5,0x1080
8000b950:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000b954:	14800793          	li	a5,328
8000b958:	02f687b3          	mul	a5,a3,a5
8000b95c:	97ba                	add	a5,a5,a4
8000b95e:	439c                	lw	a5,0(a5)
8000b960:	ce3e                	sw	a5,28(sp)
    uint8_t ep_idx = USB_EP_GET_IDX(ep);
8000b962:	00e14783          	lbu	a5,14(sp)
8000b966:	07f7f793          	and	a5,a5,127
8000b96a:	00f10da3          	sb	a5,27(sp)
    if (USB_EP_DIR_IS_OUT(ep)) {
8000b96e:	00e10783          	lb	a5,14(sp)
8000b972:	0207c763          	bltz	a5,8000b9a0 <.L35>
        g_hpm_udc[busid].out_ep[ep_idx].ep_enable = false;
8000b976:	00f14603          	lbu	a2,15(sp)
8000b97a:	01b14703          	lbu	a4,27(sp)
8000b97e:	010807b7          	lui	a5,0x1080
8000b982:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000b986:	87ba                	mv	a5,a4
8000b988:	078a                	sll	a5,a5,0x2
8000b98a:	97ba                	add	a5,a5,a4
8000b98c:	078a                	sll	a5,a5,0x2
8000b98e:	14800713          	li	a4,328
8000b992:	02e60733          	mul	a4,a2,a4
8000b996:	97ba                	add	a5,a5,a4
8000b998:	97b6                	add	a5,a5,a3
8000b99a:	0a078623          	sb	zero,172(a5)
8000b99e:	a02d                	j	8000b9c8 <.L36>

8000b9a0 <.L35>:
        g_hpm_udc[busid].in_ep[ep_idx].ep_enable = false;
8000b9a0:	00f14603          	lbu	a2,15(sp)
8000b9a4:	01b14703          	lbu	a4,27(sp)
8000b9a8:	010807b7          	lui	a5,0x1080
8000b9ac:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000b9b0:	87ba                	mv	a5,a4
8000b9b2:	078a                	sll	a5,a5,0x2
8000b9b4:	97ba                	add	a5,a5,a4
8000b9b6:	078a                	sll	a5,a5,0x2
8000b9b8:	14800713          	li	a4,328
8000b9bc:	02e60733          	mul	a4,a2,a4
8000b9c0:	97ba                	add	a5,a5,a4
8000b9c2:	97b6                	add	a5,a5,a3
8000b9c4:	00078623          	sb	zero,12(a5)

8000b9c8 <.L36>:
    usb_device_edpt_close(handle, ep);
8000b9c8:	00e14783          	lbu	a5,14(sp)
8000b9cc:	85be                	mv	a1,a5
8000b9ce:	4572                	lw	a0,28(sp)
8000b9d0:	e6bfd0ef          	jal	8000983a <usb_device_edpt_close>
    return 0;
8000b9d4:	4781                	li	a5,0
}
8000b9d6:	853e                	mv	a0,a5
8000b9d8:	50b2                	lw	ra,44(sp)
8000b9da:	6145                	add	sp,sp,48
8000b9dc:	8082                	ret

Disassembly of section .text.usbd_ep_start_write:

8000b9de <usbd_ep_start_write>:

int usbd_ep_start_write(uint8_t busid, const uint8_t ep, const uint8_t *data, uint32_t data_len)
{
8000b9de:	7179                	add	sp,sp,-48
8000b9e0:	d606                	sw	ra,44(sp)
8000b9e2:	87aa                	mv	a5,a0
8000b9e4:	872e                	mv	a4,a1
8000b9e6:	c432                	sw	a2,8(sp)
8000b9e8:	c236                	sw	a3,4(sp)
8000b9ea:	00f107a3          	sb	a5,15(sp)
8000b9ee:	87ba                	mv	a5,a4
8000b9f0:	00f10723          	sb	a5,14(sp)
    uint8_t ep_idx = USB_EP_GET_IDX(ep);
8000b9f4:	00e14783          	lbu	a5,14(sp)
8000b9f8:	07f7f793          	and	a5,a5,127
8000b9fc:	00f10fa3          	sb	a5,31(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000ba00:	00f14683          	lbu	a3,15(sp)
8000ba04:	010807b7          	lui	a5,0x1080
8000ba08:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000ba0c:	14800793          	li	a5,328
8000ba10:	02f687b3          	mul	a5,a3,a5
8000ba14:	97ba                	add	a5,a5,a4
8000ba16:	439c                	lw	a5,0(a5)
8000ba18:	cc3e                	sw	a5,24(sp)

    if (!data && data_len) {
8000ba1a:	47a2                	lw	a5,8(sp)
8000ba1c:	e789                	bnez	a5,8000ba26 <.L45>
8000ba1e:	4792                	lw	a5,4(sp)
8000ba20:	c399                	beqz	a5,8000ba26 <.L45>
        return -1;
8000ba22:	57fd                	li	a5,-1
8000ba24:	a86d                	j	8000bade <.L46>

8000ba26 <.L45>:
    }
    if (!g_hpm_udc[busid].in_ep[ep_idx].ep_enable) {
8000ba26:	00f14603          	lbu	a2,15(sp)
8000ba2a:	01f14703          	lbu	a4,31(sp)
8000ba2e:	010807b7          	lui	a5,0x1080
8000ba32:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000ba36:	87ba                	mv	a5,a4
8000ba38:	078a                	sll	a5,a5,0x2
8000ba3a:	97ba                	add	a5,a5,a4
8000ba3c:	078a                	sll	a5,a5,0x2
8000ba3e:	14800713          	li	a4,328
8000ba42:	02e60733          	mul	a4,a2,a4
8000ba46:	97ba                	add	a5,a5,a4
8000ba48:	97b6                	add	a5,a5,a3
8000ba4a:	00c7c783          	lbu	a5,12(a5)
8000ba4e:	e399                	bnez	a5,8000ba54 <.L47>
        return -2;
8000ba50:	57f9                	li	a5,-2
8000ba52:	a071                	j	8000bade <.L46>

8000ba54 <.L47>:
    }

    g_hpm_udc[busid].in_ep[ep_idx].xfer_buf = (uint8_t *)data;
8000ba54:	00f14603          	lbu	a2,15(sp)
8000ba58:	01f14703          	lbu	a4,31(sp)
8000ba5c:	010807b7          	lui	a5,0x1080
8000ba60:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000ba64:	87ba                	mv	a5,a4
8000ba66:	078a                	sll	a5,a5,0x2
8000ba68:	97ba                	add	a5,a5,a4
8000ba6a:	078a                	sll	a5,a5,0x2
8000ba6c:	14800713          	li	a4,328
8000ba70:	02e60733          	mul	a4,a2,a4
8000ba74:	97ba                	add	a5,a5,a4
8000ba76:	97b6                	add	a5,a5,a3
8000ba78:	4722                	lw	a4,8(sp)
8000ba7a:	cb98                	sw	a4,16(a5)
    g_hpm_udc[busid].in_ep[ep_idx].xfer_len = data_len;
8000ba7c:	00f14603          	lbu	a2,15(sp)
8000ba80:	01f14703          	lbu	a4,31(sp)
8000ba84:	010807b7          	lui	a5,0x1080
8000ba88:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000ba8c:	87ba                	mv	a5,a4
8000ba8e:	078a                	sll	a5,a5,0x2
8000ba90:	97ba                	add	a5,a5,a4
8000ba92:	078a                	sll	a5,a5,0x2
8000ba94:	14800713          	li	a4,328
8000ba98:	02e60733          	mul	a4,a2,a4
8000ba9c:	97ba                	add	a5,a5,a4
8000ba9e:	97b6                	add	a5,a5,a3
8000baa0:	4712                	lw	a4,4(sp)
8000baa2:	cbd8                	sw	a4,20(a5)
    g_hpm_udc[busid].in_ep[ep_idx].actual_xfer_len = 0;
8000baa4:	00f14603          	lbu	a2,15(sp)
8000baa8:	01f14703          	lbu	a4,31(sp)
8000baac:	010807b7          	lui	a5,0x1080
8000bab0:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000bab4:	87ba                	mv	a5,a4
8000bab6:	078a                	sll	a5,a5,0x2
8000bab8:	97ba                	add	a5,a5,a4
8000baba:	078a                	sll	a5,a5,0x2
8000babc:	14800713          	li	a4,328
8000bac0:	02e60733          	mul	a4,a2,a4
8000bac4:	97ba                	add	a5,a5,a4
8000bac6:	97b6                	add	a5,a5,a3
8000bac8:	0007ac23          	sw	zero,24(a5)

    usb_device_edpt_xfer(handle, ep, (uint8_t *)data, data_len);
8000bacc:	00e14783          	lbu	a5,14(sp)
8000bad0:	4692                	lw	a3,4(sp)
8000bad2:	4622                	lw	a2,8(sp)
8000bad4:	85be                	mv	a1,a5
8000bad6:	4562                	lw	a0,24(sp)
8000bad8:	ae3f80ef          	jal	800045ba <usb_device_edpt_xfer>

    return 0;
8000badc:	4781                	li	a5,0

8000bade <.L46>:
}
8000bade:	853e                	mv	a0,a5
8000bae0:	50b2                	lw	ra,44(sp)
8000bae2:	6145                	add	sp,sp,48
8000bae4:	8082                	ret

Disassembly of section .text.usbd_ep_start_read:

8000bae6 <usbd_ep_start_read>:

int usbd_ep_start_read(uint8_t busid, const uint8_t ep, uint8_t *data, uint32_t data_len)
{
8000bae6:	7179                	add	sp,sp,-48
8000bae8:	d606                	sw	ra,44(sp)
8000baea:	87aa                	mv	a5,a0
8000baec:	872e                	mv	a4,a1
8000baee:	c432                	sw	a2,8(sp)
8000baf0:	c236                	sw	a3,4(sp)
8000baf2:	00f107a3          	sb	a5,15(sp)
8000baf6:	87ba                	mv	a5,a4
8000baf8:	00f10723          	sb	a5,14(sp)
    uint8_t ep_idx = USB_EP_GET_IDX(ep);
8000bafc:	00e14783          	lbu	a5,14(sp)
8000bb00:	07f7f793          	and	a5,a5,127
8000bb04:	00f10fa3          	sb	a5,31(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000bb08:	00f14683          	lbu	a3,15(sp)
8000bb0c:	010807b7          	lui	a5,0x1080
8000bb10:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000bb14:	14800793          	li	a5,328
8000bb18:	02f687b3          	mul	a5,a3,a5
8000bb1c:	97ba                	add	a5,a5,a4
8000bb1e:	439c                	lw	a5,0(a5)
8000bb20:	cc3e                	sw	a5,24(sp)

    if (!data && data_len) {
8000bb22:	47a2                	lw	a5,8(sp)
8000bb24:	e789                	bnez	a5,8000bb2e <.L49>
8000bb26:	4792                	lw	a5,4(sp)
8000bb28:	c399                	beqz	a5,8000bb2e <.L49>
        return -1;
8000bb2a:	57fd                	li	a5,-1
8000bb2c:	a87d                	j	8000bbea <.L50>

8000bb2e <.L49>:
    }
    if (!g_hpm_udc[busid].out_ep[ep_idx].ep_enable) {
8000bb2e:	00f14603          	lbu	a2,15(sp)
8000bb32:	01f14703          	lbu	a4,31(sp)
8000bb36:	010807b7          	lui	a5,0x1080
8000bb3a:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000bb3e:	87ba                	mv	a5,a4
8000bb40:	078a                	sll	a5,a5,0x2
8000bb42:	97ba                	add	a5,a5,a4
8000bb44:	078a                	sll	a5,a5,0x2
8000bb46:	14800713          	li	a4,328
8000bb4a:	02e60733          	mul	a4,a2,a4
8000bb4e:	97ba                	add	a5,a5,a4
8000bb50:	97b6                	add	a5,a5,a3
8000bb52:	0ac7c783          	lbu	a5,172(a5)
8000bb56:	e399                	bnez	a5,8000bb5c <.L51>
        return -2;
8000bb58:	57f9                	li	a5,-2
8000bb5a:	a841                	j	8000bbea <.L50>

8000bb5c <.L51>:
    }

    g_hpm_udc[busid].out_ep[ep_idx].xfer_buf = (uint8_t *)data;
8000bb5c:	00f14603          	lbu	a2,15(sp)
8000bb60:	01f14703          	lbu	a4,31(sp)
8000bb64:	010807b7          	lui	a5,0x1080
8000bb68:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000bb6c:	87ba                	mv	a5,a4
8000bb6e:	078a                	sll	a5,a5,0x2
8000bb70:	97ba                	add	a5,a5,a4
8000bb72:	078a                	sll	a5,a5,0x2
8000bb74:	14800713          	li	a4,328
8000bb78:	02e60733          	mul	a4,a2,a4
8000bb7c:	97ba                	add	a5,a5,a4
8000bb7e:	97b6                	add	a5,a5,a3
8000bb80:	4722                	lw	a4,8(sp)
8000bb82:	0ae7a823          	sw	a4,176(a5)
    g_hpm_udc[busid].out_ep[ep_idx].xfer_len = data_len;
8000bb86:	00f14603          	lbu	a2,15(sp)
8000bb8a:	01f14703          	lbu	a4,31(sp)
8000bb8e:	010807b7          	lui	a5,0x1080
8000bb92:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000bb96:	87ba                	mv	a5,a4
8000bb98:	078a                	sll	a5,a5,0x2
8000bb9a:	97ba                	add	a5,a5,a4
8000bb9c:	078a                	sll	a5,a5,0x2
8000bb9e:	14800713          	li	a4,328
8000bba2:	02e60733          	mul	a4,a2,a4
8000bba6:	97ba                	add	a5,a5,a4
8000bba8:	97b6                	add	a5,a5,a3
8000bbaa:	4712                	lw	a4,4(sp)
8000bbac:	0ae7aa23          	sw	a4,180(a5)
    g_hpm_udc[busid].out_ep[ep_idx].actual_xfer_len = 0;
8000bbb0:	00f14603          	lbu	a2,15(sp)
8000bbb4:	01f14703          	lbu	a4,31(sp)
8000bbb8:	010807b7          	lui	a5,0x1080
8000bbbc:	02478693          	add	a3,a5,36 # 1080024 <g_hpm_udc>
8000bbc0:	87ba                	mv	a5,a4
8000bbc2:	078a                	sll	a5,a5,0x2
8000bbc4:	97ba                	add	a5,a5,a4
8000bbc6:	078a                	sll	a5,a5,0x2
8000bbc8:	14800713          	li	a4,328
8000bbcc:	02e60733          	mul	a4,a2,a4
8000bbd0:	97ba                	add	a5,a5,a4
8000bbd2:	97b6                	add	a5,a5,a3
8000bbd4:	0a07ac23          	sw	zero,184(a5)

    usb_device_edpt_xfer(handle, ep, data, data_len);
8000bbd8:	00e14783          	lbu	a5,14(sp)
8000bbdc:	4692                	lw	a3,4(sp)
8000bbde:	4622                	lw	a2,8(sp)
8000bbe0:	85be                	mv	a1,a5
8000bbe2:	4562                	lw	a0,24(sp)
8000bbe4:	9d7f80ef          	jal	800045ba <usb_device_edpt_xfer>

    return 0;
8000bbe8:	4781                	li	a5,0

8000bbea <.L50>:
}
8000bbea:	853e                	mv	a0,a5
8000bbec:	50b2                	lw	ra,44(sp)
8000bbee:	6145                	add	sp,sp,48
8000bbf0:	8082                	ret

Disassembly of section .text.USBD_IRQHandler:

8000bbf2 <USBD_IRQHandler>:

void USBD_IRQHandler(uint8_t busid)
{
8000bbf2:	715d                	add	sp,sp,-80
8000bbf4:	c686                	sw	ra,76(sp)
8000bbf6:	87aa                	mv	a5,a0
8000bbf8:	00f107a3          	sb	a5,15(sp)
    uint32_t int_status;
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000bbfc:	00f14683          	lbu	a3,15(sp)
8000bc00:	010807b7          	lui	a5,0x1080
8000bc04:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000bc08:	14800793          	li	a5,328
8000bc0c:	02f687b3          	mul	a5,a3,a5
8000bc10:	97ba                	add	a5,a5,a4
8000bc12:	439c                	lw	a5,0(a5)
8000bc14:	d83e                	sw	a5,48(sp)
    uint32_t transfer_len;
    bool ep_cb_req;

    /* Acknowledge handled interrupt */
    int_status = usb_device_status_flags(handle);
8000bc16:	5542                	lw	a0,48(sp)
8000bc18:	bbef80ef          	jal	80003fd6 <usb_device_status_flags>
8000bc1c:	d62a                	sw	a0,44(sp)
    int_status &= usb_device_interrupts(handle);
8000bc1e:	5542                	lw	a0,48(sp)
8000bc20:	bd2f80ef          	jal	80003ff2 <usb_device_interrupts>
8000bc24:	872a                	mv	a4,a0
8000bc26:	57b2                	lw	a5,44(sp)
8000bc28:	8ff9                	and	a5,a5,a4
8000bc2a:	d63e                	sw	a5,44(sp)
    usb_device_clear_status_flags(handle, int_status);
8000bc2c:	55b2                	lw	a1,44(sp)
8000bc2e:	5542                	lw	a0,48(sp)
8000bc30:	b75fd0ef          	jal	800097a4 <usb_device_clear_status_flags>

    if (int_status & intr_error) {
8000bc34:	57b2                	lw	a5,44(sp)
8000bc36:	8b89                	and	a5,a5,2
8000bc38:	cf89                	beqz	a5,8000bc52 <.L53>
        USB_LOG_ERR("usbd intr error!\r\n");
8000bc3a:	75c20513          	add	a0,tp,1884 # 75c <.L179+0xc>
8000bc3e:	811fd0ef          	jal	8000944e <printf>
8000bc42:	76c20513          	add	a0,tp,1900 # 76c <.L154+0x8>
8000bc46:	809fd0ef          	jal	8000944e <printf>
8000bc4a:	78020513          	add	a0,tp,1920 # 780 <.L154+0x1c>
8000bc4e:	801fd0ef          	jal	8000944e <printf>

8000bc52 <.L53>:
    }

    if (int_status & intr_reset) {
8000bc52:	57b2                	lw	a5,44(sp)
8000bc54:	0407f793          	and	a5,a5,64
8000bc58:	cfb5                	beqz	a5,8000bcd4 <.L54>
        g_hpm_udc[busid].is_suspend = false;
8000bc5a:	00f14683          	lbu	a3,15(sp)
8000bc5e:	010807b7          	lui	a5,0x1080
8000bc62:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000bc66:	14800793          	li	a5,328
8000bc6a:	02f687b3          	mul	a5,a3,a5
8000bc6e:	97ba                	add	a5,a5,a4
8000bc70:	00078223          	sb	zero,4(a5)
        memset(g_hpm_udc[busid].in_ep, 0, sizeof(struct hpm_ep_state) * USB_NUM_BIDIR_ENDPOINTS);
8000bc74:	00f14703          	lbu	a4,15(sp)
8000bc78:	14800793          	li	a5,328
8000bc7c:	02f70733          	mul	a4,a4,a5
8000bc80:	010807b7          	lui	a5,0x1080
8000bc84:	02478793          	add	a5,a5,36 # 1080024 <g_hpm_udc>
8000bc88:	97ba                	add	a5,a5,a4
8000bc8a:	07a1                	add	a5,a5,8
8000bc8c:	0a000613          	li	a2,160
8000bc90:	4581                	li	a1,0
8000bc92:	853e                	mv	a0,a5
8000bc94:	1fe010ef          	jal	8000ce92 <memset>
        memset(g_hpm_udc[busid].out_ep, 0, sizeof(struct hpm_ep_state) * USB_NUM_BIDIR_ENDPOINTS);
8000bc98:	00f14703          	lbu	a4,15(sp)
8000bc9c:	14800793          	li	a5,328
8000bca0:	02f707b3          	mul	a5,a4,a5
8000bca4:	0a078713          	add	a4,a5,160
8000bca8:	010807b7          	lui	a5,0x1080
8000bcac:	02478793          	add	a5,a5,36 # 1080024 <g_hpm_udc>
8000bcb0:	97ba                	add	a5,a5,a4
8000bcb2:	07a1                	add	a5,a5,8
8000bcb4:	0a000613          	li	a2,160
8000bcb8:	4581                	li	a1,0
8000bcba:	853e                	mv	a0,a5
8000bcbc:	1d6010ef          	jal	8000ce92 <memset>
        usbd_event_reset_handler(busid);
8000bcc0:	00f14783          	lbu	a5,15(sp)
8000bcc4:	853e                	mv	a0,a5
8000bcc6:	e9cfb0ef          	jal	80007362 <usbd_event_reset_handler>
        usb_device_bus_reset(handle, 64);
8000bcca:	04000593          	li	a1,64
8000bcce:	5542                	lw	a0,48(sp)
8000bcd0:	a4af80ef          	jal	80003f1a <usb_device_bus_reset>

8000bcd4 <.L54>:
    }

    if (int_status & intr_suspend) {
8000bcd4:	57b2                	lw	a5,44(sp)
8000bcd6:	1007f793          	and	a5,a5,256
8000bcda:	cf95                	beqz	a5,8000bd16 <.L55>
        if (usb_device_get_suspend_status(handle)) {
8000bcdc:	5542                	lw	a0,48(sp)
8000bcde:	b68f80ef          	jal	80004046 <usb_device_get_suspend_status>
8000bce2:	87aa                	mv	a5,a0
8000bce4:	cb8d                	beqz	a5,8000bd16 <.L55>
            /* Note: Host may delay more than 3 ms before and/or after bus reset before doing enumeration. */
            if (usb_device_get_address(handle)) {
8000bce6:	5542                	lw	a0,48(sp)
8000bce8:	bd6f80ef          	jal	800040be <usb_device_get_address>
8000bcec:	87aa                	mv	a5,a0
8000bcee:	c785                	beqz	a5,8000bd16 <.L55>
                g_hpm_udc[busid].is_suspend = true;
8000bcf0:	00f14683          	lbu	a3,15(sp)
8000bcf4:	010807b7          	lui	a5,0x1080
8000bcf8:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000bcfc:	14800793          	li	a5,328
8000bd00:	02f687b3          	mul	a5,a3,a5
8000bd04:	97ba                	add	a5,a5,a4
8000bd06:	4705                	li	a4,1
8000bd08:	00e78223          	sb	a4,4(a5)
                usbd_event_suspend_handler(busid);
8000bd0c:	00f14783          	lbu	a5,15(sp)
8000bd10:	853e                	mv	a0,a5
8000bd12:	c84ff0ef          	jal	8000b196 <usbd_event_suspend_handler>

8000bd16 <.L55>:
            }
        } else {
        }
    }

    if (int_status & intr_port_change) {
8000bd16:	57b2                	lw	a5,44(sp)
8000bd18:	8b91                	and	a5,a5,4
8000bd1a:	c7ad                	beqz	a5,8000bd84 <.L56>
        if (!usb_device_get_port_ccs(handle)) {
8000bd1c:	5542                	lw	a0,48(sp)
8000bd1e:	f04f80ef          	jal	80004422 <usb_device_get_port_ccs>
8000bd22:	87aa                	mv	a5,a0
8000bd24:	0017c793          	xor	a5,a5,1
8000bd28:	0ff7f793          	zext.b	a5,a5
8000bd2c:	c799                	beqz	a5,8000bd3a <.L57>
            usbd_event_disconnect_handler(busid);
8000bd2e:	00f14783          	lbu	a5,15(sp)
8000bd32:	853e                	mv	a0,a5
8000bd34:	bd6ff0ef          	jal	8000b10a <usbd_event_disconnect_handler>
8000bd38:	a0b1                	j	8000bd84 <.L56>

8000bd3a <.L57>:
        } else {
            if (g_hpm_udc[busid].is_suspend) {
8000bd3a:	00f14683          	lbu	a3,15(sp)
8000bd3e:	010807b7          	lui	a5,0x1080
8000bd42:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000bd46:	14800793          	li	a5,328
8000bd4a:	02f687b3          	mul	a5,a3,a5
8000bd4e:	97ba                	add	a5,a5,a4
8000bd50:	0047c783          	lbu	a5,4(a5)
8000bd54:	c39d                	beqz	a5,8000bd7a <.L58>
                g_hpm_udc[busid].is_suspend = false;
8000bd56:	00f14683          	lbu	a3,15(sp)
8000bd5a:	010807b7          	lui	a5,0x1080
8000bd5e:	02478713          	add	a4,a5,36 # 1080024 <g_hpm_udc>
8000bd62:	14800793          	li	a5,328
8000bd66:	02f687b3          	mul	a5,a3,a5
8000bd6a:	97ba                	add	a5,a5,a4
8000bd6c:	00078223          	sb	zero,4(a5)
                usbd_event_resume_handler(busid);
8000bd70:	00f14783          	lbu	a5,15(sp)
8000bd74:	853e                	mv	a0,a5
8000bd76:	bccff0ef          	jal	8000b142 <usbd_event_resume_handler>

8000bd7a <.L58>:
            }
            usbd_event_connect_handler(busid);
8000bd7a:	00f14783          	lbu	a5,15(sp)
8000bd7e:	853e                	mv	a0,a5
8000bd80:	b52ff0ef          	jal	8000b0d2 <usbd_event_connect_handler>

8000bd84 <.L56>:
        }
    }

    if (int_status & intr_usb) {
8000bd84:	57b2                	lw	a5,44(sp)
8000bd86:	8b85                	and	a5,a5,1
8000bd88:	18078563          	beqz	a5,8000bf12 <.L71>

8000bd8c <.LBB22>:
        uint32_t const edpt_complete = usb_device_get_edpt_complete_status(handle);
8000bd8c:	5542                	lw	a0,48(sp)
8000bd8e:	eb0f80ef          	jal	8000443e <usb_device_get_edpt_complete_status>
8000bd92:	d42a                	sw	a0,40(sp)
        usb_device_clear_edpt_complete_status(handle, edpt_complete);
8000bd94:	55a2                	lw	a1,40(sp)
8000bd96:	5542                	lw	a0,48(sp)
8000bd98:	a27fd0ef          	jal	800097be <usb_device_clear_edpt_complete_status>
        uint32_t edpt_setup_status = usb_device_get_setup_status(handle);
8000bd9c:	5542                	lw	a0,48(sp)
8000bd9e:	eecf80ef          	jal	8000448a <usb_device_get_setup_status>
8000bda2:	d22a                	sw	a0,36(sp)

        if (edpt_setup_status) {
8000bda4:	5792                	lw	a5,36(sp)
8000bda6:	c39d                	beqz	a5,8000bdcc <.L60>

8000bda8 <.LBB23>:
            /*------------- Set up Received -------------*/
            usb_device_clear_setup_status(handle, edpt_setup_status);
8000bda8:	5592                	lw	a1,36(sp)
8000bdaa:	5542                	lw	a0,48(sp)
8000bdac:	a2dfd0ef          	jal	800097d8 <usb_device_clear_setup_status>
            dcd_qhd_t *qhd0 = usb_device_qhd_get(handle, 0);
8000bdb0:	4581                	li	a1,0
8000bdb2:	5542                	lw	a0,48(sp)
8000bdb4:	95bfd0ef          	jal	8000970e <usb_device_qhd_get>
8000bdb8:	d02a                	sw	a0,32(sp)
            usbd_event_ep0_setup_complete_handler(busid, (uint8_t *)&qhd0->setup_request);
8000bdba:	5782                	lw	a5,32(sp)
8000bdbc:	02878713          	add	a4,a5,40
8000bdc0:	00f14783          	lbu	a5,15(sp)
8000bdc4:	85ba                	mv	a1,a4
8000bdc6:	853e                	mv	a0,a5
8000bdc8:	e82fb0ef          	jal	8000744a <usbd_event_ep0_setup_complete_handler>

8000bdcc <.L60>:
        }

        if (edpt_complete) {
8000bdcc:	57a2                	lw	a5,40(sp)
8000bdce:	14078263          	beqz	a5,8000bf12 <.L71>

8000bdd2 <.LBB24>:
            for (uint8_t ep_idx = 0; ep_idx < USB_SOS_DCD_MAX_QHD_COUNT; ep_idx++) {
8000bdd2:	02010d23          	sb	zero,58(sp)
8000bdd6:	aa0d                	j	8000bf08 <.L61>

8000bdd8 <.L70>:
                if (edpt_complete & (1 << ep_idx2bit(ep_idx))) {
8000bdd8:	03a14783          	lbu	a5,58(sp)
8000bddc:	853e                	mv	a0,a5
8000bdde:	d89fb0ef          	jal	80007b66 <ep_idx2bit>
8000bde2:	87aa                	mv	a5,a0
8000bde4:	873e                	mv	a4,a5
8000bde6:	4785                	li	a5,1
8000bde8:	00e797b3          	sll	a5,a5,a4
8000bdec:	873e                	mv	a4,a5
8000bdee:	57a2                	lw	a5,40(sp)
8000bdf0:	8ff9                	and	a5,a5,a4
8000bdf2:	10078663          	beqz	a5,8000befe <.L62>

8000bdf6 <.LBB25>:
                    transfer_len = 0;
8000bdf6:	de02                	sw	zero,60(sp)
                    ep_cb_req = true;
8000bdf8:	4785                	li	a5,1
8000bdfa:	02f10da3          	sb	a5,59(sp)

                    /* Failed QTD also get ENDPTCOMPLETE set */
                    dcd_qtd_t *p_qtd = usb_device_qtd_get(handle, ep_idx);
8000bdfe:	03a14783          	lbu	a5,58(sp)
8000be02:	85be                	mv	a1,a5
8000be04:	5542                	lw	a0,48(sp)
8000be06:	8d4f80ef          	jal	80003eda <usb_device_qtd_get>
8000be0a:	da2a                	sw	a0,52(sp)

8000be0c <.L68>:
                    while (1) {
                        if (p_qtd->halted || p_qtd->xact_err || p_qtd->buffer_err) {
8000be0c:	57d2                	lw	a5,52(sp)
8000be0e:	43dc                	lw	a5,4(a5)
8000be10:	8399                	srl	a5,a5,0x6
8000be12:	8b85                	and	a5,a5,1
8000be14:	0ff7f793          	zext.b	a5,a5
8000be18:	ef99                	bnez	a5,8000be36 <.L63>
8000be1a:	57d2                	lw	a5,52(sp)
8000be1c:	43dc                	lw	a5,4(a5)
8000be1e:	838d                	srl	a5,a5,0x3
8000be20:	8b85                	and	a5,a5,1
8000be22:	0ff7f793          	zext.b	a5,a5
8000be26:	eb81                	bnez	a5,8000be36 <.L63>
8000be28:	57d2                	lw	a5,52(sp)
8000be2a:	43dc                	lw	a5,4(a5)
8000be2c:	8395                	srl	a5,a5,0x5
8000be2e:	8b85                	and	a5,a5,1
8000be30:	0ff7f793          	zext.b	a5,a5
8000be34:	c385                	beqz	a5,8000be54 <.L64>

8000be36 <.L63>:
                            USB_LOG_ERR("usbd transfer error!\r\n");
8000be36:	75c20513          	add	a0,tp,1884 # 75c <.L179+0xc>
8000be3a:	e14fd0ef          	jal	8000944e <printf>
8000be3e:	78820513          	add	a0,tp,1928 # 788 <.L154+0x24>
8000be42:	e0cfd0ef          	jal	8000944e <printf>
8000be46:	78020513          	add	a0,tp,1920 # 780 <.L154+0x1c>
8000be4a:	e04fd0ef          	jal	8000944e <printf>
                            ep_cb_req = false;
8000be4e:	02010da3          	sb	zero,59(sp)
                            break;
8000be52:	a891                	j	8000bea6 <.L65>

8000be54 <.L64>:
                        } else if (p_qtd->active) {
8000be54:	57d2                	lw	a5,52(sp)
8000be56:	43dc                	lw	a5,4(a5)
8000be58:	839d                	srl	a5,a5,0x7
8000be5a:	8b85                	and	a5,a5,1
8000be5c:	0ff7f793          	zext.b	a5,a5
8000be60:	c781                	beqz	a5,8000be68 <.L66>
                            ep_cb_req = false;
8000be62:	02010da3          	sb	zero,59(sp)
                            break;
8000be66:	a081                	j	8000bea6 <.L65>

8000be68 <.L66>:
                        } else {
                            transfer_len += p_qtd->expected_bytes - p_qtd->total_bytes;
8000be68:	57d2                	lw	a5,52(sp)
8000be6a:	01c7d783          	lhu	a5,28(a5)
8000be6e:	07c2                	sll	a5,a5,0x10
8000be70:	83c1                	srl	a5,a5,0x10
8000be72:	873e                	mv	a4,a5
8000be74:	57d2                	lw	a5,52(sp)
8000be76:	43dc                	lw	a5,4(a5)
8000be78:	83c1                	srl	a5,a5,0x10
8000be7a:	86be                	mv	a3,a5
8000be7c:	67a1                	lui	a5,0x8
8000be7e:	17fd                	add	a5,a5,-1 # 7fff <__NONCACHEABLE_RAM_segment_used_size__+0x2b07>
8000be80:	8ff5                	and	a5,a5,a3
8000be82:	07c2                	sll	a5,a5,0x10
8000be84:	83c1                	srl	a5,a5,0x10
8000be86:	40f707b3          	sub	a5,a4,a5
8000be8a:	873e                	mv	a4,a5
8000be8c:	57f2                	lw	a5,60(sp)
8000be8e:	97ba                	add	a5,a5,a4
8000be90:	de3e                	sw	a5,60(sp)
                        }

                        if (p_qtd->next == USB_SOC_DCD_QTD_NEXT_INVALID) {
8000be92:	57d2                	lw	a5,52(sp)
8000be94:	4398                	lw	a4,0(a5)
8000be96:	4785                	li	a5,1
8000be98:	00f70663          	beq	a4,a5,8000bea4 <.L72>
                            break;
                        } else {
                            p_qtd = (dcd_qtd_t *)p_qtd->next;
8000be9c:	57d2                	lw	a5,52(sp)
8000be9e:	439c                	lw	a5,0(a5)
8000bea0:	da3e                	sw	a5,52(sp)
                        if (p_qtd->halted || p_qtd->xact_err || p_qtd->buffer_err) {
8000bea2:	b7ad                	j	8000be0c <.L68>

8000bea4 <.L72>:
                            break;
8000bea4:	0001                	nop

8000bea6 <.L65>:
                        }
                    }

                    if (ep_cb_req) {
8000bea6:	03b14783          	lbu	a5,59(sp)
8000beaa:	cbb1                	beqz	a5,8000befe <.L62>

8000beac <.LBB26>:
                        uint8_t const ep_addr = (ep_idx / 2) | ((ep_idx & 0x01) ? 0x80 : 0);
8000beac:	03a14783          	lbu	a5,58(sp)
8000beb0:	8385                	srl	a5,a5,0x1
8000beb2:	0ff7f793          	zext.b	a5,a5
8000beb6:	01879713          	sll	a4,a5,0x18
8000beba:	8761                	sra	a4,a4,0x18
8000bebc:	03a10783          	lb	a5,58(sp)
8000bec0:	079e                	sll	a5,a5,0x7
8000bec2:	07e2                	sll	a5,a5,0x18
8000bec4:	87e1                	sra	a5,a5,0x18
8000bec6:	8fd9                	or	a5,a5,a4
8000bec8:	07e2                	sll	a5,a5,0x18
8000beca:	87e1                	sra	a5,a5,0x18
8000becc:	00f10fa3          	sb	a5,31(sp)
                        if (ep_addr & 0x80) {
8000bed0:	01f10783          	lb	a5,31(sp)
8000bed4:	0007dc63          	bgez	a5,8000beec <.L69>
                            usbd_event_ep_in_complete_handler(busid, ep_addr, transfer_len);
8000bed8:	01f14703          	lbu	a4,31(sp)
8000bedc:	00f14783          	lbu	a5,15(sp)
8000bee0:	5672                	lw	a2,60(sp)
8000bee2:	85ba                	mv	a1,a4
8000bee4:	853e                	mv	a0,a5
8000bee6:	a7ffb0ef          	jal	80007964 <usbd_event_ep_in_complete_handler>
8000beea:	a811                	j	8000befe <.L62>

8000beec <.L69>:
                        } else {
                            usbd_event_ep_out_complete_handler(busid, ep_addr, transfer_len);
8000beec:	01f14703          	lbu	a4,31(sp)
8000bef0:	00f14783          	lbu	a5,15(sp)
8000bef4:	5672                	lw	a2,60(sp)
8000bef6:	85ba                	mv	a1,a4
8000bef8:	853e                	mv	a0,a5
8000befa:	af5fb0ef          	jal	800079ee <usbd_event_ep_out_complete_handler>

8000befe <.L62>:
            for (uint8_t ep_idx = 0; ep_idx < USB_SOS_DCD_MAX_QHD_COUNT; ep_idx++) {
8000befe:	03a14783          	lbu	a5,58(sp)
8000bf02:	0785                	add	a5,a5,1
8000bf04:	02f10d23          	sb	a5,58(sp)

8000bf08 <.L61>:
8000bf08:	03a14703          	lbu	a4,58(sp)
8000bf0c:	47bd                	li	a5,15
8000bf0e:	ece7f5e3          	bgeu	a5,a4,8000bdd8 <.L70>

8000bf12 <.L71>:
                    }
                }
            }
        }
    }
}
8000bf12:	0001                	nop
8000bf14:	40b6                	lw	ra,76(sp)
8000bf16:	6161                	add	sp,sp,80
8000bf18:	8082                	ret

Disassembly of section .text._clean_up:

8000bf1a <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
8000bf1a:	7139                	add	sp,sp,-64

8000bf1c <.LBB18>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000bf1c:	6785                	lui	a5,0x1
8000bf1e:	80078793          	add	a5,a5,-2048 # 800 <.L133+0x14>
8000bf22:	3047b073          	csrc	mie,a5
}
8000bf26:	0001                	nop
8000bf28:	da02                	sw	zero,52(sp)
8000bf2a:	d802                	sw	zero,48(sp)
8000bf2c:	e40007b7          	lui	a5,0xe4000
8000bf30:	d63e                	sw	a5,44(sp)
8000bf32:	57d2                	lw	a5,52(sp)
8000bf34:	d43e                	sw	a5,40(sp)
8000bf36:	57c2                	lw	a5,48(sp)
8000bf38:	d23e                	sw	a5,36(sp)

8000bf3a <.LBB20>:
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
8000bf3a:	57a2                	lw	a5,40(sp)
8000bf3c:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
8000bf40:	57b2                	lw	a5,44(sp)
8000bf42:	973e                	add	a4,a4,a5
8000bf44:	002007b7          	lui	a5,0x200
8000bf48:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
8000bf4a:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
8000bf4c:	5782                	lw	a5,32(sp)
8000bf4e:	5712                	lw	a4,36(sp)
8000bf50:	c398                	sw	a4,0(a5)
}
8000bf52:	0001                	nop

8000bf54 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
8000bf54:	0001                	nop

8000bf56 <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
8000bf56:	de02                	sw	zero,60(sp)
8000bf58:	a82d                	j	8000bf92 <.L2>

8000bf5a <.L3>:
8000bf5a:	ce02                	sw	zero,28(sp)
8000bf5c:	57f2                	lw	a5,60(sp)
8000bf5e:	cc3e                	sw	a5,24(sp)
8000bf60:	e40007b7          	lui	a5,0xe4000
8000bf64:	ca3e                	sw	a5,20(sp)
8000bf66:	47f2                	lw	a5,28(sp)
8000bf68:	c83e                	sw	a5,16(sp)
8000bf6a:	47e2                	lw	a5,24(sp)
8000bf6c:	c63e                	sw	a5,12(sp)

8000bf6e <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
8000bf6e:	47c2                	lw	a5,16(sp)
8000bf70:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
8000bf74:	47d2                	lw	a5,20(sp)
8000bf76:	973e                	add	a4,a4,a5
8000bf78:	002007b7          	lui	a5,0x200
8000bf7c:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_end__+0x140004>
8000bf7e:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
8000bf80:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
8000bf82:	47a2                	lw	a5,8(sp)
8000bf84:	4732                	lw	a4,12(sp)
8000bf86:	c398                	sw	a4,0(a5)
}
8000bf88:	0001                	nop

8000bf8a <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
8000bf8a:	0001                	nop

8000bf8c <.LBE25>:
8000bf8c:	57f2                	lw	a5,60(sp)
8000bf8e:	0785                	add	a5,a5,1
8000bf90:	de3e                	sw	a5,60(sp)

8000bf92 <.L2>:
8000bf92:	5772                	lw	a4,60(sp)
8000bf94:	07f00793          	li	a5,127
8000bf98:	fce7f1e3          	bgeu	a5,a4,8000bf5a <.L3>

8000bf9c <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
8000bf9c:	dc02                	sw	zero,56(sp)
8000bf9e:	a821                	j	8000bfb6 <.L4>

8000bfa0 <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
8000bfa0:	57e2                	lw	a5,56(sp)
8000bfa2:	00279713          	sll	a4,a5,0x2
8000bfa6:	e40027b7          	lui	a5,0xe4002
8000bfaa:	97ba                	add	a5,a5,a4
8000bfac:	0007a023          	sw	zero,0(a5) # e4002000 <__XPI0_segment_end__+0x63802000>
    for (uint32_t i = 0; i < 4; i++) {
8000bfb0:	57e2                	lw	a5,56(sp)
8000bfb2:	0785                	add	a5,a5,1
8000bfb4:	dc3e                	sw	a5,56(sp)

8000bfb6 <.L4>:
8000bfb6:	5762                	lw	a4,56(sp)
8000bfb8:	478d                	li	a5,3
8000bfba:	fee7f3e3          	bgeu	a5,a4,8000bfa0 <.L5>

8000bfbe <.LBE29>:
    }
}
8000bfbe:	0001                	nop
8000bfc0:	0001                	nop
8000bfc2:	6121                	add	sp,sp,64
8000bfc4:	8082                	ret

Disassembly of section .text.reset_handler:

8000bfc6 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
8000bfc6:	1141                	add	sp,sp,-16
8000bfc8:	c606                	sw	ra,12(sp)
    fencei();
8000bfca:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
8000bfce:	b22fc0ef          	jal	800082f0 <system_init>

    /* Entry function */
    MAIN_ENTRY();
8000bfd2:	7fff7097          	auipc	ra,0x7fff7
8000bfd6:	9f8080e7          	jalr	-1544(ra) # 29ca <main>
}
8000bfda:	0001                	nop
8000bfdc:	40b2                	lw	ra,12(sp)
8000bfde:	0141                	add	sp,sp,16
8000bfe0:	8082                	ret

Disassembly of section .text._init:

8000bfe2 <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
8000bfe2:	0001                	nop
8000bfe4:	8082                	ret

Disassembly of section .text.mchtmr_isr:

8000bfe6 <mchtmr_isr>:
}
8000bfe6:	0001                	nop
8000bfe8:	8082                	ret

Disassembly of section .text.swi_isr:

8000bfea <swi_isr>:
}
8000bfea:	0001                	nop
8000bfec:	8082                	ret

Disassembly of section .text.exception_handler:

8000bfee <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
8000bfee:	1141                	add	sp,sp,-16
8000bff0:	c62a                	sw	a0,12(sp)
8000bff2:	c42e                	sw	a1,8(sp)
    switch (cause) {
8000bff4:	4732                	lw	a4,12(sp)
8000bff6:	47bd                	li	a5,15
8000bff8:	00e7ec63          	bltu	a5,a4,8000c010 <.L23>
8000bffc:	47b2                	lw	a5,12(sp)
8000bffe:	00279713          	sll	a4,a5,0x2
8000c002:	800037b7          	lui	a5,0x80003
8000c006:	3d078793          	add	a5,a5,976 # 800033d0 <.L7>
8000c00a:	97ba                	add	a5,a5,a4
8000c00c:	439c                	lw	a5,0(a5)
8000c00e:	8782                	jr	a5

8000c010 <.L23>:
        case MCAUSE_LOAD_PAGE_FAULT:
            break;
        case MCAUSE_STORE_AMO_PAGE_FAULT:
            break;
        default:
            break;
8000c010:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
8000c012:	47a2                	lw	a5,8(sp)
}
8000c014:	853e                	mv	a0,a5
8000c016:	0141                	add	sp,sp,16
8000c018:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

8000c01a <get_frequency_for_source>:
{
8000c01a:	7179                	add	sp,sp,-48
8000c01c:	d606                	sw	ra,44(sp)
8000c01e:	87aa                	mv	a5,a0
8000c020:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
8000c024:	ce02                	sw	zero,28(sp)
    uint32_t div = 1;
8000c026:	4785                	li	a5,1
8000c028:	cc3e                	sw	a5,24(sp)
    switch (source) {
8000c02a:	00f14783          	lbu	a5,15(sp)
8000c02e:	471d                	li	a4,7
8000c030:	0cf76e63          	bltu	a4,a5,8000c10c <.L36>
8000c034:	00279713          	sll	a4,a5,0x2
8000c038:	800037b7          	lui	a5,0x80003
8000c03c:	45c78793          	add	a5,a5,1116 # 8000345c <.L38>
8000c040:	97ba                	add	a5,a5,a4
8000c042:	439c                	lw	a5,0(a5)
8000c044:	8782                	jr	a5

8000c046 <.L45>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
8000c046:	016e37b7          	lui	a5,0x16e3
8000c04a:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000c04e:	ce3e                	sw	a5,28(sp)
        break;
8000c050:	a0c1                	j	8000c110 <.L46>

8000c052 <.L44>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 0U);
8000c052:	4581                	li	a1,0
8000c054:	f4100537          	lui	a0,0xf4100
8000c058:	976fe0ef          	jal	8000a1ce <pllctl_get_pll_freq_in_hz>
8000c05c:	ce2a                	sw	a0,28(sp)
        break;
8000c05e:	a84d                	j	8000c110 <.L46>

8000c060 <.L43>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 0);
8000c060:	4601                	li	a2,0
8000c062:	4585                	li	a1,1
8000c064:	f4100537          	lui	a0,0xf4100
8000c068:	e3dfb0ef          	jal	80007ea4 <pllctl_get_div>
8000c06c:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
8000c06e:	4585                	li	a1,1
8000c070:	f4100537          	lui	a0,0xf4100
8000c074:	95afe0ef          	jal	8000a1ce <pllctl_get_pll_freq_in_hz>
8000c078:	872a                	mv	a4,a0
8000c07a:	47e2                	lw	a5,24(sp)
8000c07c:	02f757b3          	divu	a5,a4,a5
8000c080:	ce3e                	sw	a5,28(sp)
        break;
8000c082:	a079                	j	8000c110 <.L46>

8000c084 <.L42>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 1);
8000c084:	4605                	li	a2,1
8000c086:	4585                	li	a1,1
8000c088:	f4100537          	lui	a0,0xf4100
8000c08c:	e19fb0ef          	jal	80007ea4 <pllctl_get_div>
8000c090:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
8000c092:	4585                	li	a1,1
8000c094:	f4100537          	lui	a0,0xf4100
8000c098:	936fe0ef          	jal	8000a1ce <pllctl_get_pll_freq_in_hz>
8000c09c:	872a                	mv	a4,a0
8000c09e:	47e2                	lw	a5,24(sp)
8000c0a0:	02f757b3          	divu	a5,a4,a5
8000c0a4:	ce3e                	sw	a5,28(sp)
        break;
8000c0a6:	a0ad                	j	8000c110 <.L46>

8000c0a8 <.L41>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 0);
8000c0a8:	4601                	li	a2,0
8000c0aa:	4589                	li	a1,2
8000c0ac:	f4100537          	lui	a0,0xf4100
8000c0b0:	df5fb0ef          	jal	80007ea4 <pllctl_get_div>
8000c0b4:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
8000c0b6:	4589                	li	a1,2
8000c0b8:	f4100537          	lui	a0,0xf4100
8000c0bc:	912fe0ef          	jal	8000a1ce <pllctl_get_pll_freq_in_hz>
8000c0c0:	872a                	mv	a4,a0
8000c0c2:	47e2                	lw	a5,24(sp)
8000c0c4:	02f757b3          	divu	a5,a4,a5
8000c0c8:	ce3e                	sw	a5,28(sp)
        break;
8000c0ca:	a099                	j	8000c110 <.L46>

8000c0cc <.L40>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 1);
8000c0cc:	4605                	li	a2,1
8000c0ce:	4589                	li	a1,2
8000c0d0:	f4100537          	lui	a0,0xf4100
8000c0d4:	dd1fb0ef          	jal	80007ea4 <pllctl_get_div>
8000c0d8:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
8000c0da:	4589                	li	a1,2
8000c0dc:	f4100537          	lui	a0,0xf4100
8000c0e0:	8eefe0ef          	jal	8000a1ce <pllctl_get_pll_freq_in_hz>
8000c0e4:	872a                	mv	a4,a0
8000c0e6:	47e2                	lw	a5,24(sp)
8000c0e8:	02f757b3          	divu	a5,a4,a5
8000c0ec:	ce3e                	sw	a5,28(sp)
        break;
8000c0ee:	a00d                	j	8000c110 <.L46>

8000c0f0 <.L39>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 3U);
8000c0f0:	458d                	li	a1,3
8000c0f2:	f4100537          	lui	a0,0xf4100
8000c0f6:	8d8fe0ef          	jal	8000a1ce <pllctl_get_pll_freq_in_hz>
8000c0fa:	ce2a                	sw	a0,28(sp)
        break;
8000c0fc:	a811                	j	8000c110 <.L46>

8000c0fe <.L37>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 4U);
8000c0fe:	4591                	li	a1,4
8000c100:	f4100537          	lui	a0,0xf4100
8000c104:	8cafe0ef          	jal	8000a1ce <pllctl_get_pll_freq_in_hz>
8000c108:	ce2a                	sw	a0,28(sp)
        break;
8000c10a:	a019                	j	8000c110 <.L46>

8000c10c <.L36>:
        clk_freq = 0UL;
8000c10c:	ce02                	sw	zero,28(sp)
        break;
8000c10e:	0001                	nop

8000c110 <.L46>:
    return clk_freq;
8000c110:	47f2                	lw	a5,28(sp)
}
8000c112:	853e                	mv	a0,a5
8000c114:	50b2                	lw	ra,44(sp)
8000c116:	6145                	add	sp,sp,48
8000c118:	8082                	ret

Disassembly of section .text.get_frequency_for_i2s_or_adc:

8000c11a <get_frequency_for_i2s_or_adc>:
{
8000c11a:	7139                	add	sp,sp,-64
8000c11c:	de06                	sw	ra,60(sp)
8000c11e:	c62a                	sw	a0,12(sp)
8000c120:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
8000c122:	d602                	sw	zero,44(sp)
    bool is_mux_valid = false;
8000c124:	020105a3          	sb	zero,43(sp)
    clock_node_t node = clock_node_end;
8000c128:	04b00793          	li	a5,75
8000c12c:	02f10523          	sb	a5,42(sp)
    if (clk_src_type == CLK_SRC_GROUP_ADC) {
8000c130:	4732                	lw	a4,12(sp)
8000c132:	4785                	li	a5,1
8000c134:	04f71563          	bne	a4,a5,8000c17e <.L52>

8000c138 <.LBB7>:
        uint32_t adc_index = instance;
8000c138:	47a2                	lw	a5,8(sp)
8000c13a:	ce3e                	sw	a5,28(sp)
        if (adc_index < ADC_INSTANCE_NUM) {
8000c13c:	4772                	lw	a4,28(sp)
8000c13e:	478d                	li	a5,3
8000c140:	08e7e163          	bltu	a5,a4,8000c1c2 <.L53>

8000c144 <.LBB8>:
            uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
8000c144:	f4000737          	lui	a4,0xf4000
8000c148:	47f2                	lw	a5,28(sp)
8000c14a:	70078793          	add	a5,a5,1792
8000c14e:	078a                	sll	a5,a5,0x2
8000c150:	97ba                	add	a5,a5,a4
8000c152:	439c                	lw	a5,0(a5)
8000c154:	83a1                	srl	a5,a5,0x8
8000c156:	8b9d                	and	a5,a5,7
8000c158:	cc3e                	sw	a5,24(sp)
            if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
8000c15a:	4762                	lw	a4,24(sp)
8000c15c:	478d                	li	a5,3
8000c15e:	06e7e263          	bltu	a5,a4,8000c1c2 <.L53>
                node = s_adc_clk_mux_node[mux_in_reg];
8000c162:	800037b7          	lui	a5,0x80003
8000c166:	41078713          	add	a4,a5,1040 # 80003410 <s_adc_clk_mux_node>
8000c16a:	47e2                	lw	a5,24(sp)
8000c16c:	97ba                	add	a5,a5,a4
8000c16e:	0007c783          	lbu	a5,0(a5)
8000c172:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
8000c176:	4785                	li	a5,1
8000c178:	02f105a3          	sb	a5,43(sp)
8000c17c:	a099                	j	8000c1c2 <.L53>

8000c17e <.L52>:
        uint32_t i2s_index = instance;
8000c17e:	47a2                	lw	a5,8(sp)
8000c180:	d23e                	sw	a5,36(sp)
        if (i2s_index < I2S_INSTANCE_NUM) {
8000c182:	5712                	lw	a4,36(sp)
8000c184:	478d                	li	a5,3
8000c186:	02e7ee63          	bltu	a5,a4,8000c1c2 <.L53>

8000c18a <.LBB10>:
            uint32_t mux_in_reg = SYSCTL_I2SCLK_MUX_GET(HPM_SYSCTL->I2SCLK[i2s_index]);
8000c18a:	f4000737          	lui	a4,0xf4000
8000c18e:	5792                	lw	a5,36(sp)
8000c190:	70478793          	add	a5,a5,1796
8000c194:	078a                	sll	a5,a5,0x2
8000c196:	97ba                	add	a5,a5,a4
8000c198:	439c                	lw	a5,0(a5)
8000c19a:	83a1                	srl	a5,a5,0x8
8000c19c:	8b9d                	and	a5,a5,7
8000c19e:	d03e                	sw	a5,32(sp)
            if (mux_in_reg < ARRAY_SIZE(s_i2s_clk_mux_node)) {
8000c1a0:	5702                	lw	a4,32(sp)
8000c1a2:	478d                	li	a5,3
8000c1a4:	00e7ef63          	bltu	a5,a4,8000c1c2 <.L53>
                node = s_i2s_clk_mux_node[mux_in_reg];
8000c1a8:	800037b7          	lui	a5,0x80003
8000c1ac:	41478713          	add	a4,a5,1044 # 80003414 <s_i2s_clk_mux_node>
8000c1b0:	5782                	lw	a5,32(sp)
8000c1b2:	97ba                	add	a5,a5,a4
8000c1b4:	0007c783          	lbu	a5,0(a5)
8000c1b8:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
8000c1bc:	4785                	li	a5,1
8000c1be:	02f105a3          	sb	a5,43(sp)

8000c1c2 <.L53>:
    if (is_mux_valid) {
8000c1c2:	02b14783          	lbu	a5,43(sp)
8000c1c6:	c38d                	beqz	a5,8000c1e8 <.L54>
        if (node == clock_node_ahb0) {
8000c1c8:	02a14703          	lbu	a4,42(sp)
8000c1cc:	479d                	li	a5,7
8000c1ce:	00f71763          	bne	a4,a5,8000c1dc <.L55>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000c1d2:	451d                	li	a0,7
8000c1d4:	e03fb0ef          	jal	80007fd6 <get_frequency_for_ip_in_common_group>
8000c1d8:	d62a                	sw	a0,44(sp)
8000c1da:	a039                	j	8000c1e8 <.L54>

8000c1dc <.L55>:
            clk_freq = get_frequency_for_ip_in_common_group(node);
8000c1dc:	02a14783          	lbu	a5,42(sp)
8000c1e0:	853e                	mv	a0,a5
8000c1e2:	df5fb0ef          	jal	80007fd6 <get_frequency_for_ip_in_common_group>
8000c1e6:	d62a                	sw	a0,44(sp)

8000c1e8 <.L54>:
    return clk_freq;
8000c1e8:	57b2                	lw	a5,44(sp)
}
8000c1ea:	853e                	mv	a0,a5
8000c1ec:	50f2                	lw	ra,60(sp)
8000c1ee:	6121                	add	sp,sp,64
8000c1f0:	8082                	ret

Disassembly of section .text.get_frequency_for_wdg:

8000c1f2 <get_frequency_for_wdg>:
{
8000c1f2:	7179                	add	sp,sp,-48
8000c1f4:	d606                	sw	ra,44(sp)
8000c1f6:	c62a                	sw	a0,12(sp)
    if (WDG_CTRL_CLKSEL_GET(s_wdgs[instance]->CTRL) == 0) {
8000c1f8:	800037b7          	lui	a5,0x80003
8000c1fc:	41878713          	add	a4,a5,1048 # 80003418 <s_wdgs>
8000c200:	47b2                	lw	a5,12(sp)
8000c202:	078a                	sll	a5,a5,0x2
8000c204:	97ba                	add	a5,a5,a4
8000c206:	439c                	lw	a5,0(a5)
8000c208:	4b9c                	lw	a5,16(a5)
8000c20a:	8b89                	and	a5,a5,2
8000c20c:	e791                	bnez	a5,8000c218 <.L58>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000c20e:	451d                	li	a0,7
8000c210:	dc7fb0ef          	jal	80007fd6 <get_frequency_for_ip_in_common_group>
8000c214:	ce2a                	sw	a0,28(sp)
8000c216:	a019                	j	8000c21c <.L59>

8000c218 <.L58>:
        freq_in_hz = FREQ_32KHz;
8000c218:	67a1                	lui	a5,0x8
8000c21a:	ce3e                	sw	a5,28(sp)

8000c21c <.L59>:
    return freq_in_hz;
8000c21c:	47f2                	lw	a5,28(sp)
}
8000c21e:	853e                	mv	a0,a5
8000c220:	50b2                	lw	ra,44(sp)
8000c222:	6145                	add	sp,sp,48
8000c224:	8082                	ret

Disassembly of section .text.get_frequency_for_pwdg:

8000c226 <get_frequency_for_pwdg>:
{
8000c226:	1141                	add	sp,sp,-16
    if (WDG_CTRL_CLKSEL_GET(HPM_PWDG->CTRL) == 0) {
8000c228:	f40e87b7          	lui	a5,0xf40e8
8000c22c:	4b9c                	lw	a5,16(a5)
8000c22e:	8b89                	and	a5,a5,2
8000c230:	e799                	bnez	a5,8000c23e <.L62>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
8000c232:	016e37b7          	lui	a5,0x16e3
8000c236:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000c23a:	c63e                	sw	a5,12(sp)
8000c23c:	a019                	j	8000c242 <.L63>

8000c23e <.L62>:
        freq_in_hz = FREQ_32KHz;
8000c23e:	67a1                	lui	a5,0x8
8000c240:	c63e                	sw	a5,12(sp)

8000c242 <.L63>:
    return freq_in_hz;
8000c242:	47b2                	lw	a5,12(sp)
}
8000c244:	853e                	mv	a0,a5
8000c246:	0141                	add	sp,sp,16
8000c248:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

8000c24a <clock_connect_group_to_cpu>:
{
8000c24a:	1141                	add	sp,sp,-16
8000c24c:	c62a                	sw	a0,12(sp)
8000c24e:	c42e                	sw	a1,8(sp)
    if (cpu < 2U) {
8000c250:	4722                	lw	a4,8(sp)
8000c252:	4785                	li	a5,1
8000c254:	00e7ee63          	bltu	a5,a4,8000c270 <.L173>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
8000c258:	f40006b7          	lui	a3,0xf4000
8000c25c:	47b2                	lw	a5,12(sp)
8000c25e:	4705                	li	a4,1
8000c260:	00f71733          	sll	a4,a4,a5
8000c264:	47a2                	lw	a5,8(sp)
8000c266:	09078793          	add	a5,a5,144 # 8090 <__AHB_SRAM_segment_size__+0x90>
8000c26a:	0792                	sll	a5,a5,0x4
8000c26c:	97b6                	add	a5,a5,a3
8000c26e:	c3d8                	sw	a4,4(a5)

8000c270 <.L173>:
}
8000c270:	0001                	nop
8000c272:	0141                	add	sp,sp,16
8000c274:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

8000c276 <l1c_dc_invalidate_all>:
{
    __asm("fence.i");
}

void l1c_dc_invalidate_all(void)
{
8000c276:	1141                	add	sp,sp,-16
8000c278:	47dd                	li	a5,23
8000c27a:	00f107a3          	sb	a5,15(sp)

8000c27e <.LBB76>:
}

/* send command */
__attribute__((always_inline)) static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
8000c27e:	00f14783          	lbu	a5,15(sp)
8000c282:	7cc79073          	csrw	0x7cc,a5
}
8000c286:	0001                	nop

8000c288 <.LBE76>:
    l1c_cctl_cmd(HPM_L1C_CCTL_CMD_L1D_INVAL_ALL);
}
8000c288:	0001                	nop
8000c28a:	0141                	add	sp,sp,16
8000c28c:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

8000c28e <sysctl_enable_group_resource>:
{
8000c28e:	7179                	add	sp,sp,-48
8000c290:	d606                	sw	ra,44(sp)
8000c292:	c62a                	sw	a0,12(sp)
8000c294:	87ae                	mv	a5,a1
8000c296:	8736                	mv	a4,a3
8000c298:	00f105a3          	sb	a5,11(sp)
8000c29c:	87b2                	mv	a5,a2
8000c29e:	00f11423          	sh	a5,8(sp)
8000c2a2:	87ba                	mv	a5,a4
8000c2a4:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
8000c2a8:	00815703          	lhu	a4,8(sp)
8000c2ac:	0ff00793          	li	a5,255
8000c2b0:	00e7e463          	bltu	a5,a4,8000c2b8 <.L60>
        return status_invalid_argument;
8000c2b4:	4789                	li	a5,2
8000c2b6:	a8e5                	j	8000c3ae <.L61>

8000c2b8 <.L60>:
    index = (resource - sysctl_resource_linkable_start) / 32;
8000c2b8:	00815783          	lhu	a5,8(sp)
8000c2bc:	f0078793          	add	a5,a5,-256
8000c2c0:	41f7d713          	sra	a4,a5,0x1f
8000c2c4:	8b7d                	and	a4,a4,31
8000c2c6:	97ba                	add	a5,a5,a4
8000c2c8:	8795                	sra	a5,a5,0x5
8000c2ca:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
8000c2cc:	00815783          	lhu	a5,8(sp)
8000c2d0:	f0078713          	add	a4,a5,-256
8000c2d4:	41f75793          	sra	a5,a4,0x1f
8000c2d8:	83ed                	srl	a5,a5,0x1b
8000c2da:	973e                	add	a4,a4,a5
8000c2dc:	8b7d                	and	a4,a4,31
8000c2de:	40f707b3          	sub	a5,a4,a5
8000c2e2:	cc3e                	sw	a5,24(sp)
    switch (group) {
8000c2e4:	00b14783          	lbu	a5,11(sp)
8000c2e8:	c789                	beqz	a5,8000c2f2 <.L62>
8000c2ea:	4705                	li	a4,1
8000c2ec:	04e78f63          	beq	a5,a4,8000c34a <.L63>
8000c2f0:	a84d                	j	8000c3a2 <.L74>

8000c2f2 <.L62>:
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
8000c2f2:	4732                	lw	a4,12(sp)
8000c2f4:	47f2                	lw	a5,28(sp)
8000c2f6:	08078793          	add	a5,a5,128
8000c2fa:	0792                	sll	a5,a5,0x4
8000c2fc:	97ba                	add	a5,a5,a4
8000c2fe:	4398                	lw	a4,0(a5)
8000c300:	47e2                	lw	a5,24(sp)
8000c302:	4685                	li	a3,1
8000c304:	00f697b3          	sll	a5,a3,a5
8000c308:	fff7c793          	not	a5,a5
8000c30c:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
8000c30e:	00a14783          	lbu	a5,10(sp)
8000c312:	c791                	beqz	a5,8000c31e <.L65>
8000c314:	47e2                	lw	a5,24(sp)
8000c316:	4685                	li	a3,1
8000c318:	00f697b3          	sll	a5,a3,a5
8000c31c:	a011                	j	8000c320 <.L66>

8000c31e <.L65>:
8000c31e:	4781                	li	a5,0

8000c320 <.L66>:
8000c320:	8f5d                	or	a4,a4,a5
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
8000c322:	46b2                	lw	a3,12(sp)
8000c324:	47f2                	lw	a5,28(sp)
8000c326:	08078793          	add	a5,a5,128
8000c32a:	0792                	sll	a5,a5,0x4
8000c32c:	97b6                	add	a5,a5,a3
8000c32e:	c398                	sw	a4,0(a5)
        if (enable) {
8000c330:	00a14783          	lbu	a5,10(sp)
8000c334:	cbad                	beqz	a5,8000c3a6 <.L75>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
8000c336:	0001                	nop

8000c338 <.L68>:
8000c338:	00815783          	lhu	a5,8(sp)
8000c33c:	85be                	mv	a1,a5
8000c33e:	4532                	lw	a0,12(sp)
8000c340:	eb7fb0ef          	jal	800081f6 <sysctl_resource_target_is_busy>
8000c344:	87aa                	mv	a5,a0
8000c346:	fbed                	bnez	a5,8000c338 <.L68>
        break;
8000c348:	a8b9                	j	8000c3a6 <.L75>

8000c34a <.L63>:
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
8000c34a:	4732                	lw	a4,12(sp)
8000c34c:	47f2                	lw	a5,28(sp)
8000c34e:	08478793          	add	a5,a5,132
8000c352:	0792                	sll	a5,a5,0x4
8000c354:	97ba                	add	a5,a5,a4
8000c356:	4398                	lw	a4,0(a5)
8000c358:	47e2                	lw	a5,24(sp)
8000c35a:	4685                	li	a3,1
8000c35c:	00f697b3          	sll	a5,a3,a5
8000c360:	fff7c793          	not	a5,a5
8000c364:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
8000c366:	00a14783          	lbu	a5,10(sp)
8000c36a:	c791                	beqz	a5,8000c376 <.L70>
8000c36c:	47e2                	lw	a5,24(sp)
8000c36e:	4685                	li	a3,1
8000c370:	00f697b3          	sll	a5,a3,a5
8000c374:	a011                	j	8000c378 <.L71>

8000c376 <.L70>:
8000c376:	4781                	li	a5,0

8000c378 <.L71>:
8000c378:	8f5d                	or	a4,a4,a5
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
8000c37a:	46b2                	lw	a3,12(sp)
8000c37c:	47f2                	lw	a5,28(sp)
8000c37e:	08478793          	add	a5,a5,132
8000c382:	0792                	sll	a5,a5,0x4
8000c384:	97b6                	add	a5,a5,a3
8000c386:	c398                	sw	a4,0(a5)
        if (enable) {
8000c388:	00a14783          	lbu	a5,10(sp)
8000c38c:	cf99                	beqz	a5,8000c3aa <.L76>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
8000c38e:	0001                	nop

8000c390 <.L73>:
8000c390:	00815783          	lhu	a5,8(sp)
8000c394:	85be                	mv	a1,a5
8000c396:	4532                	lw	a0,12(sp)
8000c398:	e5ffb0ef          	jal	800081f6 <sysctl_resource_target_is_busy>
8000c39c:	87aa                	mv	a5,a0
8000c39e:	fbed                	bnez	a5,8000c390 <.L73>
        break;
8000c3a0:	a029                	j	8000c3aa <.L76>

8000c3a2 <.L74>:
        return status_invalid_argument;
8000c3a2:	4789                	li	a5,2
8000c3a4:	a029                	j	8000c3ae <.L61>

8000c3a6 <.L75>:
        break;
8000c3a6:	0001                	nop
8000c3a8:	a011                	j	8000c3ac <.L69>

8000c3aa <.L76>:
        break;
8000c3aa:	0001                	nop

8000c3ac <.L69>:
    return status_success;
8000c3ac:	4781                	li	a5,0

8000c3ae <.L61>:
}
8000c3ae:	853e                	mv	a0,a5
8000c3b0:	50b2                	lw	ra,44(sp)
8000c3b2:	6145                	add	sp,sp,48
8000c3b4:	8082                	ret

Disassembly of section .text.enable_plic_feature:

8000c3b6 <enable_plic_feature>:
{
8000c3b6:	1141                	add	sp,sp,-16
    uint32_t plic_feature = 0;
8000c3b8:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
8000c3ba:	47b2                	lw	a5,12(sp)
8000c3bc:	0027e793          	or	a5,a5,2
8000c3c0:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
8000c3c2:	47b2                	lw	a5,12(sp)
8000c3c4:	0017e793          	or	a5,a5,1
8000c3c8:	c63e                	sw	a5,12(sp)
8000c3ca:	e40007b7          	lui	a5,0xe4000
8000c3ce:	c43e                	sw	a5,8(sp)
8000c3d0:	47b2                	lw	a5,12(sp)
8000c3d2:	c23e                	sw	a5,4(sp)

8000c3d4 <.LBB14>:
 * @param[in] feature Specific feature to be set
 *
 */
ATTR_ALWAYS_INLINE static inline void __plic_set_feature(uint32_t base, uint32_t feature)
{
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
8000c3d4:	47a2                	lw	a5,8(sp)
8000c3d6:	4712                	lw	a4,4(sp)
8000c3d8:	c398                	sw	a4,0(a5)
}
8000c3da:	0001                	nop

8000c3dc <.LBE14>:
}
8000c3dc:	0001                	nop
8000c3de:	0141                	add	sp,sp,16
8000c3e0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

8000c3e2 <__SEGGER_RTL_puts_no_nl>:
8000c3e2:	1101                	add	sp,sp,-32
8000c3e4:	010807b7          	lui	a5,0x1080
8000c3e8:	cc22                	sw	s0,24(sp)
8000c3ea:	3507a403          	lw	s0,848(a5) # 1080350 <stdout>
8000c3ee:	ce06                	sw	ra,28(sp)
8000c3f0:	c62a                	sw	a0,12(sp)
8000c3f2:	309000ef          	jal	8000cefa <strlen>
8000c3f6:	862a                	mv	a2,a0
8000c3f8:	8522                	mv	a0,s0
8000c3fa:	4462                	lw	s0,24(sp)
8000c3fc:	45b2                	lw	a1,12(sp)
8000c3fe:	40f2                	lw	ra,28(sp)
8000c400:	6105                	add	sp,sp,32
8000c402:	948fd06f          	j	8000954a <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.signal:

8000c406 <signal>:
8000c406:	4795                	li	a5,5
8000c408:	02a7e463          	bltu	a5,a0,8000c430 <.L18>
8000c40c:	01080737          	lui	a4,0x1080
8000c410:	30470693          	add	a3,a4,772 # 1080304 <__SEGGER_RTL_aSigTab>
8000c414:	00251793          	sll	a5,a0,0x2
8000c418:	96be                	add	a3,a3,a5
8000c41a:	4288                	lw	a0,0(a3)
8000c41c:	30470713          	add	a4,a4,772
8000c420:	e509                	bnez	a0,8000c42a <.L17>
8000c422:	80003537          	lui	a0,0x80003
8000c426:	07a50513          	add	a0,a0,122 # 8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>

8000c42a <.L17>:
8000c42a:	973e                	add	a4,a4,a5
8000c42c:	c30c                	sw	a1,0(a4)
8000c42e:	8082                	ret

8000c430 <.L18>:
8000c430:	23a20513          	add	a0,tp,570 # 23a <default_isr_106+0x1c>
8000c434:	8082                	ret

Disassembly of section .text.libc.raise:

8000c436 <raise>:
8000c436:	1141                	add	sp,sp,-16
8000c438:	c04a                	sw	s2,0(sp)
8000c43a:	ed620593          	add	a1,tp,-298 # fffffed6 <__APB_SRAM_segment_end__+0xbf0ded6>
8000c43e:	c226                	sw	s1,4(sp)
8000c440:	c606                	sw	ra,12(sp)
8000c442:	c422                	sw	s0,8(sp)
8000c444:	84aa                	mv	s1,a0
8000c446:	37c1                	jal	8000c406 <signal>
8000c448:	23a20793          	add	a5,tp,570 # 23a <default_isr_106+0x1c>
8000c44c:	02f50d63          	beq	a0,a5,8000c486 <.L24>
8000c450:	ed620913          	add	s2,tp,-298 # fffffed6 <__APB_SRAM_segment_end__+0xbf0ded6>
8000c454:	842a                	mv	s0,a0
8000c456:	03250163          	beq	a0,s2,8000c478 <.L22>
8000c45a:	800035b7          	lui	a1,0x80003
8000c45e:	07a58793          	add	a5,a1,122 # 8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>
8000c462:	00f51563          	bne	a0,a5,8000c46c <.L23>
8000c466:	4505                	li	a0,1
8000c468:	c07f60ef          	jal	8000306e <exit>

8000c46c <.L23>:
8000c46c:	07a58593          	add	a1,a1,122
8000c470:	8526                	mv	a0,s1
8000c472:	3f51                	jal	8000c406 <signal>
8000c474:	8526                	mv	a0,s1
8000c476:	9402                	jalr	s0

8000c478 <.L22>:
8000c478:	4501                	li	a0,0

8000c47a <.L20>:
8000c47a:	40b2                	lw	ra,12(sp)
8000c47c:	4422                	lw	s0,8(sp)
8000c47e:	4492                	lw	s1,4(sp)
8000c480:	4902                	lw	s2,0(sp)
8000c482:	0141                	add	sp,sp,16
8000c484:	8082                	ret

8000c486 <.L24>:
8000c486:	557d                	li	a0,-1
8000c488:	bfcd                	j	8000c47a <.L20>

Disassembly of section .text.libc.abort:

8000c48a <abort>:
8000c48a:	1141                	add	sp,sp,-16
8000c48c:	c606                	sw	ra,12(sp)

8000c48e <.L27>:
8000c48e:	4501                	li	a0,0
8000c490:	375d                	jal	8000c436 <raise>
8000c492:	bff5                	j	8000c48e <.L27>

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

8000c494 <__SEGGER_RTL_X_assert>:
8000c494:	1101                	add	sp,sp,-32
8000c496:	cc22                	sw	s0,24(sp)
8000c498:	ca26                	sw	s1,20(sp)
8000c49a:	842a                	mv	s0,a0
8000c49c:	84ae                	mv	s1,a1
8000c49e:	8532                	mv	a0,a2
8000c4a0:	858a                	mv	a1,sp
8000c4a2:	4629                	li	a2,10
8000c4a4:	ce06                	sw	ra,28(sp)
8000c4a6:	f0ffb0ef          	jal	800083b4 <itoa>
8000c4aa:	8526                	mv	a0,s1
8000c4ac:	3f1d                	jal	8000c3e2 <__SEGGER_RTL_puts_no_nl>
8000c4ae:	cfc20513          	add	a0,tp,-772 # fffffcfc <__APB_SRAM_segment_end__+0xbf0dcfc>
8000c4b2:	3f05                	jal	8000c3e2 <__SEGGER_RTL_puts_no_nl>
8000c4b4:	850a                	mv	a0,sp
8000c4b6:	3735                	jal	8000c3e2 <__SEGGER_RTL_puts_no_nl>
8000c4b8:	d0020513          	add	a0,tp,-768 # fffffd00 <__APB_SRAM_segment_end__+0xbf0dd00>
8000c4bc:	371d                	jal	8000c3e2 <__SEGGER_RTL_puts_no_nl>
8000c4be:	8522                	mv	a0,s0
8000c4c0:	370d                	jal	8000c3e2 <__SEGGER_RTL_puts_no_nl>
8000c4c2:	d1820513          	add	a0,tp,-744 # fffffd18 <__APB_SRAM_segment_end__+0xbf0dd18>
8000c4c6:	3f31                	jal	8000c3e2 <__SEGGER_RTL_puts_no_nl>
8000c4c8:	37c9                	jal	8000c48a <abort>

Disassembly of section .text.libc.__adddf3:

8000c4ca <__adddf3>:
8000c4ca:	800007b7          	lui	a5,0x80000
8000c4ce:	00d5c8b3          	xor	a7,a1,a3
8000c4d2:	1008c263          	bltz	a7,8000c5d6 <.L__adddf3_subtract>
8000c4d6:	00b6e863          	bltu	a3,a1,8000c4e6 <.L__adddf3_add_already_ordered>
8000c4da:	8d31                	xor	a0,a0,a2
8000c4dc:	8e29                	xor	a2,a2,a0
8000c4de:	8d31                	xor	a0,a0,a2
8000c4e0:	8db5                	xor	a1,a1,a3
8000c4e2:	8ead                	xor	a3,a3,a1
8000c4e4:	8db5                	xor	a1,a1,a3

8000c4e6 <.L__adddf3_add_already_ordered>:
8000c4e6:	00159813          	sll	a6,a1,0x1
8000c4ea:	01585813          	srl	a6,a6,0x15
8000c4ee:	00169893          	sll	a7,a3,0x1
8000c4f2:	0158d893          	srl	a7,a7,0x15
8000c4f6:	0c088063          	beqz	a7,8000c5b6 <.L__adddf3_add_zero>
8000c4fa:	00180713          	add	a4,a6,1
8000c4fe:	0756                	sll	a4,a4,0x15
8000c500:	c759                	beqz	a4,8000c58e <.L__adddf3_done>
8000c502:	41180733          	sub	a4,a6,a7
8000c506:	03500293          	li	t0,53
8000c50a:	08e2e263          	bltu	t0,a4,8000c58e <.L__adddf3_done>
8000c50e:	0145d813          	srl	a6,a1,0x14
8000c512:	06ae                	sll	a3,a3,0xb
8000c514:	8edd                	or	a3,a3,a5
8000c516:	82ad                	srl	a3,a3,0xb
8000c518:	05ae                	sll	a1,a1,0xb
8000c51a:	8ddd                	or	a1,a1,a5
8000c51c:	85ad                	sra	a1,a1,0xb
8000c51e:	02000293          	li	t0,32
8000c522:	06577763          	bgeu	a4,t0,8000c590 <.L__adddf3_add_shifted_word>
8000c526:	4881                	li	a7,0
8000c528:	cf01                	beqz	a4,8000c540 <.L__adddf3_add_no_shift>
8000c52a:	40e002b3          	neg	t0,a4
8000c52e:	005618b3          	sll	a7,a2,t0
8000c532:	00e65633          	srl	a2,a2,a4
8000c536:	005692b3          	sll	t0,a3,t0
8000c53a:	9616                	add	a2,a2,t0
8000c53c:	00e6d6b3          	srl	a3,a3,a4

8000c540 <.L__adddf3_add_no_shift>:
8000c540:	9532                	add	a0,a0,a2
8000c542:	00c532b3          	sltu	t0,a0,a2
8000c546:	95b6                	add	a1,a1,a3
8000c548:	00d5b333          	sltu	t1,a1,a3
8000c54c:	9596                	add	a1,a1,t0
8000c54e:	00031463          	bnez	t1,8000c556 <.L__adddf3_normalization_required>
8000c552:	0255f163          	bgeu	a1,t0,8000c574 <.L__adddf3_already_normalized>

8000c556 <.L__adddf3_normalization_required>:
8000c556:	00280613          	add	a2,a6,2
8000c55a:	0656                	sll	a2,a2,0x15
8000c55c:	c235                	beqz	a2,8000c5c0 <.L__adddf3_inf>
8000c55e:	01f51613          	sll	a2,a0,0x1f
8000c562:	011032b3          	snez	t0,a7
8000c566:	005608b3          	add	a7,a2,t0
8000c56a:	8105                	srl	a0,a0,0x1
8000c56c:	01f59693          	sll	a3,a1,0x1f
8000c570:	8d55                	or	a0,a0,a3
8000c572:	8185                	srl	a1,a1,0x1

8000c574 <.L__adddf3_already_normalized>:
8000c574:	0805                	add	a6,a6,1
8000c576:	0852                	sll	a6,a6,0x14

8000c578 <.L__adddf3_perform_rounding>:
8000c578:	0008da63          	bgez	a7,8000c58c <.L__adddf3_add_no_tie>
8000c57c:	0505                	add	a0,a0,1
8000c57e:	00153293          	seqz	t0,a0
8000c582:	9596                	add	a1,a1,t0
8000c584:	0886                	sll	a7,a7,0x1
8000c586:	00089363          	bnez	a7,8000c58c <.L__adddf3_add_no_tie>
8000c58a:	9979                	and	a0,a0,-2

8000c58c <.L__adddf3_add_no_tie>:
8000c58c:	95c2                	add	a1,a1,a6

8000c58e <.L__adddf3_done>:
8000c58e:	8082                	ret

8000c590 <.L__adddf3_add_shifted_word>:
8000c590:	88b2                	mv	a7,a2
8000c592:	1701                	add	a4,a4,-32
8000c594:	cb11                	beqz	a4,8000c5a8 <.L__adddf3_already_aligned>
8000c596:	40e008b3          	neg	a7,a4
8000c59a:	011698b3          	sll	a7,a3,a7
8000c59e:	00e6d6b3          	srl	a3,a3,a4
8000c5a2:	00c03733          	snez	a4,a2
8000c5a6:	98ba                	add	a7,a7,a4

8000c5a8 <.L__adddf3_already_aligned>:
8000c5a8:	9536                	add	a0,a0,a3
8000c5aa:	00d532b3          	sltu	t0,a0,a3
8000c5ae:	9596                	add	a1,a1,t0
8000c5b0:	fc55f2e3          	bgeu	a1,t0,8000c574 <.L__adddf3_already_normalized>
8000c5b4:	b74d                	j	8000c556 <.L__adddf3_normalization_required>

8000c5b6 <.L__adddf3_add_zero>:
8000c5b6:	fc081ce3          	bnez	a6,8000c58e <.L__adddf3_done>
8000c5ba:	8dfd                	and	a1,a1,a5
8000c5bc:	4501                	li	a0,0
8000c5be:	bfc1                	j	8000c58e <.L__adddf3_done>

8000c5c0 <.L__adddf3_inf>:
8000c5c0:	0805                	add	a6,a6,1
8000c5c2:	01481593          	sll	a1,a6,0x14
8000c5c6:	4501                	li	a0,0
8000c5c8:	b7d9                	j	8000c58e <.L__adddf3_done>

8000c5ca <.L__adddf3_sub_inf_nan>:
8000c5ca:	fce892e3          	bne	a7,a4,8000c58e <.L__adddf3_done>
8000c5ce:	7ff805b7          	lui	a1,0x7ff80
8000c5d2:	4501                	li	a0,0
8000c5d4:	bf6d                	j	8000c58e <.L__adddf3_done>

8000c5d6 <.L__adddf3_subtract>:
8000c5d6:	8ebd                	xor	a3,a3,a5
8000c5d8:	00b6ed63          	bltu	a3,a1,8000c5f2 <.L__adddf3_sub_already_ordered>
8000c5dc:	00b69463          	bne	a3,a1,8000c5e4 <.L__adddf3_sub_must_exchange>
8000c5e0:	00a66963          	bltu	a2,a0,8000c5f2 <.L__adddf3_sub_already_ordered>

8000c5e4 <.L__adddf3_sub_must_exchange>:
8000c5e4:	8ebd                	xor	a3,a3,a5
8000c5e6:	8d31                	xor	a0,a0,a2
8000c5e8:	8e29                	xor	a2,a2,a0
8000c5ea:	8d31                	xor	a0,a0,a2
8000c5ec:	8db5                	xor	a1,a1,a3
8000c5ee:	8ead                	xor	a3,a3,a1
8000c5f0:	8db5                	xor	a1,a1,a3

8000c5f2 <.L__adddf3_sub_already_ordered>:
8000c5f2:	00b58833          	add	a6,a1,a1
8000c5f6:	00d688b3          	add	a7,a3,a3
8000c5fa:	ffe00737          	lui	a4,0xffe00
8000c5fe:	fce876e3          	bgeu	a6,a4,8000c5ca <.L__adddf3_sub_inf_nan>
8000c602:	01585813          	srl	a6,a6,0x15
8000c606:	0158d893          	srl	a7,a7,0x15
8000c60a:	0a088f63          	beqz	a7,8000c6c8 <.L__adddf3_subtracting_zero>
8000c60e:	41180733          	sub	a4,a6,a7
8000c612:	03600293          	li	t0,54
8000c616:	f6e2ece3          	bltu	t0,a4,8000c58e <.L__adddf3_done>
8000c61a:	83c2                	mv	t2,a6
8000c61c:	0145d813          	srl	a6,a1,0x14
8000c620:	06ae                	sll	a3,a3,0xb
8000c622:	8edd                	or	a3,a3,a5
8000c624:	82ad                	srl	a3,a3,0xb
8000c626:	05ae                	sll	a1,a1,0xb
8000c628:	8ddd                	or	a1,a1,a5
8000c62a:	81ad                	srl	a1,a1,0xb
8000c62c:	4285                	li	t0,1
8000c62e:	0ae2ef63          	bltu	t0,a4,8000c6ec <.L__adddf3_sub_align_far>
8000c632:	00571a63          	bne	a4,t0,8000c646 <.L__adddf3_sub_already_aligned>
8000c636:	01f61713          	sll	a4,a2,0x1f
8000c63a:	8205                	srl	a2,a2,0x1
8000c63c:	01f69893          	sll	a7,a3,0x1f
8000c640:	01166633          	or	a2,a2,a7
8000c644:	8285                	srl	a3,a3,0x1

8000c646 <.L__adddf3_sub_already_aligned>:
8000c646:	82aa                	mv	t0,a0
8000c648:	8d11                	sub	a0,a0,a2
8000c64a:	00a2b2b3          	sltu	t0,t0,a0
8000c64e:	8d95                	sub	a1,a1,a3
8000c650:	405585b3          	sub	a1,a1,t0
8000c654:	c711                	beqz	a4,8000c660 <.L__adddf3_sub_single_done>
8000c656:	00153293          	seqz	t0,a0
8000c65a:	157d                	add	a0,a0,-1
8000c65c:	405585b3          	sub	a1,a1,t0

8000c660 <.L__adddf3_sub_single_done>:
8000c660:	c9ad                	beqz	a1,8000c6d2 <.L__adddf3_high_word_cancelled>
8000c662:	00b59293          	sll	t0,a1,0xb
8000c666:	1202ca63          	bltz	t0,8000c79a <.L__adddf3_sub_normalized>

8000c66a <.L__adddf3_first_normalization_step>:
8000c66a:	000522b3          	sltz	t0,a0
8000c66e:	952a                	add	a0,a0,a0
8000c670:	95ae                	add	a1,a1,a1
8000c672:	9596                	add	a1,a1,t0
8000c674:	837d                	srl	a4,a4,0x1f
8000c676:	953a                	add	a0,a0,a4
8000c678:	4705                	li	a4,1

8000c67a <.L__adddf3_try_shift_4>:
8000c67a:	0115d293          	srl	t0,a1,0x11
8000c67e:	00029963          	bnez	t0,8000c690 <.L__adddf3_cant_shift_4>
8000c682:	0711                	add	a4,a4,4 # ffe00004 <__APB_SRAM_segment_end__+0xbd0e004>
8000c684:	0592                	sll	a1,a1,0x4
8000c686:	01c55293          	srl	t0,a0,0x1c
8000c68a:	0512                	sll	a0,a0,0x4
8000c68c:	9596                	add	a1,a1,t0
8000c68e:	b7f5                	j	8000c67a <.L__adddf3_try_shift_4>

8000c690 <.L__adddf3_cant_shift_4>:
8000c690:	00b59293          	sll	t0,a1,0xb
8000c694:	0002cc63          	bltz	t0,8000c6ac <.L__adddf3_normalized>

8000c698 <.L__adddf3_normalize>:
8000c698:	0705                	add	a4,a4,1
8000c69a:	000522b3          	sltz	t0,a0
8000c69e:	952a                	add	a0,a0,a0
8000c6a0:	95ae                	add	a1,a1,a1
8000c6a2:	9596                	add	a1,a1,t0

8000c6a4 <.L__adddf3_pre_normalize>:
8000c6a4:	00b59293          	sll	t0,a1,0xb
8000c6a8:	fe02d8e3          	bgez	t0,8000c698 <.L__adddf3_normalize>

8000c6ac <.L__adddf3_normalized>:
8000c6ac:	861e                	mv	a2,t2
8000c6ae:	00c77863          	bgeu	a4,a2,8000c6be <.L__adddf3_signed_zero>
8000c6b2:	40e80833          	sub	a6,a6,a4
8000c6b6:	187d                	add	a6,a6,-1
8000c6b8:	0852                	sll	a6,a6,0x14
8000c6ba:	95c2                	add	a1,a1,a6
8000c6bc:	bdc9                	j	8000c58e <.L__adddf3_done>

8000c6be <.L__adddf3_signed_zero>:
8000c6be:	00b85593          	srl	a1,a6,0xb
8000c6c2:	05fe                	sll	a1,a1,0x1f
8000c6c4:	4501                	li	a0,0
8000c6c6:	b5e1                	j	8000c58e <.L__adddf3_done>

8000c6c8 <.L__adddf3_subtracting_zero>:
8000c6c8:	ec0813e3          	bnez	a6,8000c58e <.L__adddf3_done>
8000c6cc:	4501                	li	a0,0
8000c6ce:	4581                	li	a1,0
8000c6d0:	bd7d                	j	8000c58e <.L__adddf3_done>

8000c6d2 <.L__adddf3_high_word_cancelled>:
8000c6d2:	00e56633          	or	a2,a0,a4
8000c6d6:	ea060ce3          	beqz	a2,8000c58e <.L__adddf3_done>
8000c6da:	001008b7          	lui	a7,0x100
8000c6de:	f91576e3          	bgeu	a0,a7,8000c66a <.L__adddf3_first_normalization_step>
8000c6e2:	85aa                	mv	a1,a0
8000c6e4:	853a                	mv	a0,a4
8000c6e6:	02000713          	li	a4,32
8000c6ea:	bf6d                	j	8000c6a4 <.L__adddf3_pre_normalize>

8000c6ec <.L__adddf3_sub_align_far>:
8000c6ec:	02000293          	li	t0,32
8000c6f0:	04574863          	blt	a4,t0,8000c740 <.L__adddf3_aligned_on_top>
8000c6f4:	04570263          	beq	a4,t0,8000c738 <.L__adddf3_word_aligned_on_top>
8000c6f8:	1701                	add	a4,a4,-32
8000c6fa:	40e002b3          	neg	t0,a4
8000c6fe:	00e65333          	srl	t1,a2,a4
8000c702:	005618b3          	sll	a7,a2,t0
8000c706:	00569633          	sll	a2,a3,t0
8000c70a:	961a                	add	a2,a2,t1
8000c70c:	00e6d6b3          	srl	a3,a3,a4
8000c710:	011038b3          	snez	a7,a7
8000c714:	00c8e8b3          	or	a7,a7,a2
8000c718:	4601                	li	a2,0
8000c71a:	82aa                	mv	t0,a0
8000c71c:	8d15                	sub	a0,a0,a3
8000c71e:	00a2b2b3          	sltu	t0,t0,a0
8000c722:	405585b3          	sub	a1,a1,t0
8000c726:	41100733          	neg	a4,a7
8000c72a:	c729                	beqz	a4,8000c774 <.L__adddf3_sub_normalize>
8000c72c:	00153293          	seqz	t0,a0
8000c730:	157d                	add	a0,a0,-1
8000c732:	405585b3          	sub	a1,a1,t0
8000c736:	a83d                	j	8000c774 <.L__adddf3_sub_normalize>

8000c738 <.L__adddf3_word_aligned_on_top>:
8000c738:	88b2                	mv	a7,a2
8000c73a:	8636                	mv	a2,a3
8000c73c:	4681                	li	a3,0
8000c73e:	a821                	j	8000c756 <.L__adddf3_aligned_subtract>

8000c740 <.L__adddf3_aligned_on_top>:
8000c740:	40e002b3          	neg	t0,a4
8000c744:	00e65333          	srl	t1,a2,a4
8000c748:	005618b3          	sll	a7,a2,t0
8000c74c:	00569633          	sll	a2,a3,t0
8000c750:	961a                	add	a2,a2,t1
8000c752:	00e6d6b3          	srl	a3,a3,a4

8000c756 <.L__adddf3_aligned_subtract>:
8000c756:	82aa                	mv	t0,a0
8000c758:	8d11                	sub	a0,a0,a2
8000c75a:	00a2b2b3          	sltu	t0,t0,a0
8000c75e:	8d95                	sub	a1,a1,a3
8000c760:	405585b3          	sub	a1,a1,t0
8000c764:	41100733          	neg	a4,a7
8000c768:	c711                	beqz	a4,8000c774 <.L__adddf3_sub_normalize>
8000c76a:	00153293          	seqz	t0,a0
8000c76e:	157d                	add	a0,a0,-1
8000c770:	405585b3          	sub	a1,a1,t0

8000c774 <.L__adddf3_sub_normalize>:
8000c774:	00c59893          	sll	a7,a1,0xc
8000c778:	00b59293          	sll	t0,a1,0xb
8000c77c:	0002cf63          	bltz	t0,8000c79a <.L__adddf3_sub_normalized>
8000c780:	187d                	add	a6,a6,-1
8000c782:	000522b3          	sltz	t0,a0
8000c786:	952a                	add	a0,a0,a0
8000c788:	95ae                	add	a1,a1,a1
8000c78a:	9596                	add	a1,a1,t0
8000c78c:	000722b3          	sltz	t0,a4
8000c790:	973a                	add	a4,a4,a4
8000c792:	9516                	add	a0,a0,t0
8000c794:	005532b3          	sltu	t0,a0,t0
8000c798:	9596                	add	a1,a1,t0

8000c79a <.L__adddf3_sub_normalized>:
8000c79a:	187d                	add	a6,a6,-1
8000c79c:	0852                	sll	a6,a6,0x14
8000c79e:	88ba                	mv	a7,a4
8000c7a0:	bbe1                	j	8000c578 <.L__adddf3_perform_rounding>

Disassembly of section .text.libc.__mulsf3:

8000c7a2 <__mulsf3>:
8000c7a2:	80000737          	lui	a4,0x80000
8000c7a6:	0ff00293          	li	t0,255
8000c7aa:	00b547b3          	xor	a5,a0,a1
8000c7ae:	8ff9                	and	a5,a5,a4
8000c7b0:	00151613          	sll	a2,a0,0x1
8000c7b4:	8261                	srl	a2,a2,0x18
8000c7b6:	00159693          	sll	a3,a1,0x1
8000c7ba:	82e1                	srl	a3,a3,0x18
8000c7bc:	ce29                	beqz	a2,8000c816 <.L__mulsf3_lhs_zero_or_subnormal>
8000c7be:	c6bd                	beqz	a3,8000c82c <.L__mulsf3_rhs_zero_or_subnormal>
8000c7c0:	04560f63          	beq	a2,t0,8000c81e <.L__mulsf3_lhs_inf_or_nan>
8000c7c4:	06568963          	beq	a3,t0,8000c836 <.L__mulsf3_rhs_inf_or_nan>
8000c7c8:	9636                	add	a2,a2,a3
8000c7ca:	0522                	sll	a0,a0,0x8
8000c7cc:	8d59                	or	a0,a0,a4
8000c7ce:	05a2                	sll	a1,a1,0x8
8000c7d0:	8dd9                	or	a1,a1,a4
8000c7d2:	02b506b3          	mul	a3,a0,a1
8000c7d6:	02b53533          	mulhu	a0,a0,a1
8000c7da:	00d036b3          	snez	a3,a3
8000c7de:	8d55                	or	a0,a0,a3
8000c7e0:	00054463          	bltz	a0,8000c7e8 <.L__mulsf3_normalized>
8000c7e4:	0506                	sll	a0,a0,0x1
8000c7e6:	167d                	add	a2,a2,-1

8000c7e8 <.L__mulsf3_normalized>:
8000c7e8:	f8160613          	add	a2,a2,-127
8000c7ec:	04064863          	bltz	a2,8000c83c <.L__mulsf3_zero_or_underflow>
8000c7f0:	12fd                	add	t0,t0,-1 # ffffffff <__APB_SRAM_segment_end__+0xbf0dfff>
8000c7f2:	00565f63          	bge	a2,t0,8000c810 <.L__mulsf3_inf>
8000c7f6:	01851693          	sll	a3,a0,0x18
8000c7fa:	8121                	srl	a0,a0,0x8
8000c7fc:	065e                	sll	a2,a2,0x17
8000c7fe:	9532                	add	a0,a0,a2
8000c800:	0006d663          	bgez	a3,8000c80c <.L__mulsf3_apply_sign>
8000c804:	0505                	add	a0,a0,1
8000c806:	0686                	sll	a3,a3,0x1
8000c808:	e291                	bnez	a3,8000c80c <.L__mulsf3_apply_sign>
8000c80a:	9979                	and	a0,a0,-2

8000c80c <.L__mulsf3_apply_sign>:
8000c80c:	8d5d                	or	a0,a0,a5
8000c80e:	8082                	ret

8000c810 <.L__mulsf3_inf>:
8000c810:	7f800537          	lui	a0,0x7f800
8000c814:	bfe5                	j	8000c80c <.L__mulsf3_apply_sign>

8000c816 <.L__mulsf3_lhs_zero_or_subnormal>:
8000c816:	00568d63          	beq	a3,t0,8000c830 <.L__mulsf3_nan>

8000c81a <.L__mulsf3_signed_zero>:
8000c81a:	853e                	mv	a0,a5
8000c81c:	8082                	ret

8000c81e <.L__mulsf3_lhs_inf_or_nan>:
8000c81e:	0526                	sll	a0,a0,0x9
8000c820:	e901                	bnez	a0,8000c830 <.L__mulsf3_nan>
8000c822:	fe5697e3          	bne	a3,t0,8000c810 <.L__mulsf3_inf>
8000c826:	05a6                	sll	a1,a1,0x9
8000c828:	e581                	bnez	a1,8000c830 <.L__mulsf3_nan>
8000c82a:	b7dd                	j	8000c810 <.L__mulsf3_inf>

8000c82c <.L__mulsf3_rhs_zero_or_subnormal>:
8000c82c:	fe5617e3          	bne	a2,t0,8000c81a <.L__mulsf3_signed_zero>

8000c830 <.L__mulsf3_nan>:
8000c830:	7fc00537          	lui	a0,0x7fc00
8000c834:	8082                	ret

8000c836 <.L__mulsf3_rhs_inf_or_nan>:
8000c836:	05a6                	sll	a1,a1,0x9
8000c838:	fde5                	bnez	a1,8000c830 <.L__mulsf3_nan>
8000c83a:	bfd9                	j	8000c810 <.L__mulsf3_inf>

8000c83c <.L__mulsf3_zero_or_underflow>:
8000c83c:	0605                	add	a2,a2,1
8000c83e:	fe71                	bnez	a2,8000c81a <.L__mulsf3_signed_zero>
8000c840:	8521                	sra	a0,a0,0x8
8000c842:	00150293          	add	t0,a0,1 # 7fc00001 <__SHARE_RAM_segment_end__+0x7ea80001>
8000c846:	0509                	add	a0,a0,2
8000c848:	fc0299e3          	bnez	t0,8000c81a <.L__mulsf3_signed_zero>
8000c84c:	00800537          	lui	a0,0x800
8000c850:	bf75                	j	8000c80c <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__muldf3:

8000c852 <__muldf3>:
8000c852:	800008b7          	lui	a7,0x80000
8000c856:	00d5c833          	xor	a6,a1,a3
8000c85a:	01187eb3          	and	t4,a6,a7
8000c85e:	00b58733          	add	a4,a1,a1
8000c862:	00d687b3          	add	a5,a3,a3
8000c866:	ffe00837          	lui	a6,0xffe00
8000c86a:	0d077363          	bgeu	a4,a6,8000c930 <.L__muldf3_lhs_nan_or_inf>
8000c86e:	0d07ff63          	bgeu	a5,a6,8000c94c <.L__muldf3_rhs_nan_or_inf>
8000c872:	8355                	srl	a4,a4,0x15
8000c874:	c76d                	beqz	a4,8000c95e <.L__muldf3_signed_zero>
8000c876:	83d5                	srl	a5,a5,0x15
8000c878:	c3fd                	beqz	a5,8000c95e <.L__muldf3_signed_zero>
8000c87a:	06ae                	sll	a3,a3,0xb
8000c87c:	0116e6b3          	or	a3,a3,a7
8000c880:	82ad                	srl	a3,a3,0xb
8000c882:	05ae                	sll	a1,a1,0xb
8000c884:	0115e5b3          	or	a1,a1,a7
8000c888:	01555813          	srl	a6,a0,0x15
8000c88c:	052e                	sll	a0,a0,0xb
8000c88e:	010582b3          	add	t0,a1,a6
8000c892:	00f70333          	add	t1,a4,a5
8000c896:	02c50733          	mul	a4,a0,a2
8000c89a:	02c537b3          	mulhu	a5,a0,a2
8000c89e:	02d50833          	mul	a6,a0,a3
8000c8a2:	02d538b3          	mulhu	a7,a0,a3
8000c8a6:	983e                	add	a6,a6,a5
8000c8a8:	00f837b3          	sltu	a5,a6,a5
8000c8ac:	98be                	add	a7,a7,a5
8000c8ae:	02c28533          	mul	a0,t0,a2
8000c8b2:	02c2b5b3          	mulhu	a1,t0,a2
8000c8b6:	982a                	add	a6,a6,a0
8000c8b8:	00a83533          	sltu	a0,a6,a0
8000c8bc:	98ae                	add	a7,a7,a1
8000c8be:	00b8b5b3          	sltu	a1,a7,a1
8000c8c2:	98aa                	add	a7,a7,a0
8000c8c4:	00a8b533          	sltu	a0,a7,a0
8000c8c8:	00b50633          	add	a2,a0,a1
8000c8cc:	02d28533          	mul	a0,t0,a3
8000c8d0:	02d2b5b3          	mulhu	a1,t0,a3
8000c8d4:	9546                	add	a0,a0,a7
8000c8d6:	011538b3          	sltu	a7,a0,a7
8000c8da:	95c6                	add	a1,a1,a7
8000c8dc:	95b2                	add	a1,a1,a2
8000c8de:	00e03733          	snez	a4,a4
8000c8e2:	00e86833          	or	a6,a6,a4
8000c8e6:	871a                	mv	a4,t1
8000c8e8:	00b59293          	sll	t0,a1,0xb
8000c8ec:	0002cc63          	bltz	t0,8000c904 <.L__muldf3_normalized>
8000c8f0:	000822b3          	sltz	t0,a6
8000c8f4:	9842                	add	a6,a6,a6
8000c8f6:	00052333          	sltz	t1,a0
8000c8fa:	952a                	add	a0,a0,a0
8000c8fc:	9516                	add	a0,a0,t0
8000c8fe:	95ae                	add	a1,a1,a1
8000c900:	959a                	add	a1,a1,t1
8000c902:	177d                	add	a4,a4,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>

8000c904 <.L__muldf3_normalized>:
8000c904:	3ff00793          	li	a5,1023
8000c908:	8f1d                	sub	a4,a4,a5
8000c90a:	04074a63          	bltz	a4,8000c95e <.L__muldf3_signed_zero>
8000c90e:	0786                	sll	a5,a5,0x1
8000c910:	04f75363          	bge	a4,a5,8000c956 <.L__muldf3_inf>
8000c914:	0752                	sll	a4,a4,0x14
8000c916:	95ba                	add	a1,a1,a4
8000c918:	00085a63          	bgez	a6,8000c92c <.L__muldf3_apply_sign>
8000c91c:	0505                	add	a0,a0,1 # 800001 <_flash_size+0x1>
8000c91e:	00153613          	seqz	a2,a0
8000c922:	95b2                	add	a1,a1,a2
8000c924:	0806                	sll	a6,a6,0x1
8000c926:	00081363          	bnez	a6,8000c92c <.L__muldf3_apply_sign>
8000c92a:	9979                	and	a0,a0,-2

8000c92c <.L__muldf3_apply_sign>:
8000c92c:	95f6                	add	a1,a1,t4
8000c92e:	8082                	ret

8000c930 <.L__muldf3_lhs_nan_or_inf>:
8000c930:	01071a63          	bne	a4,a6,8000c944 <.L__muldf3_nan>
8000c934:	e901                	bnez	a0,8000c944 <.L__muldf3_nan>
8000c936:	00f86763          	bltu	a6,a5,8000c944 <.L__muldf3_nan>
8000c93a:	0107e363          	bltu	a5,a6,8000c940 <.L__muldf3_rhs_could_be_zero>
8000c93e:	e219                	bnez	a2,8000c944 <.L__muldf3_nan>

8000c940 <.L__muldf3_rhs_could_be_zero>:
8000c940:	83d5                	srl	a5,a5,0x15
8000c942:	eb91                	bnez	a5,8000c956 <.L__muldf3_inf>

8000c944 <.L__muldf3_nan>:
8000c944:	7ff805b7          	lui	a1,0x7ff80

8000c948 <.L__muldf3_load_zero_lo>:
8000c948:	4501                	li	a0,0
8000c94a:	8082                	ret

8000c94c <.L__muldf3_rhs_nan_or_inf>:
8000c94c:	ff079ce3          	bne	a5,a6,8000c944 <.L__muldf3_nan>
8000c950:	fa75                	bnez	a2,8000c944 <.L__muldf3_nan>
8000c952:	8355                	srl	a4,a4,0x15
8000c954:	db65                	beqz	a4,8000c944 <.L__muldf3_nan>

8000c956 <.L__muldf3_inf>:
8000c956:	7ff005b7          	lui	a1,0x7ff00
8000c95a:	4501                	li	a0,0
8000c95c:	bfc1                	j	8000c92c <.L__muldf3_apply_sign>

8000c95e <.L__muldf3_signed_zero>:
8000c95e:	85f6                	mv	a1,t4
8000c960:	b7e5                	j	8000c948 <.L__muldf3_load_zero_lo>

Disassembly of section .text.libc.__divsf3:

8000c962 <__divsf3>:
8000c962:	0ff00293          	li	t0,255
8000c966:	00151713          	sll	a4,a0,0x1
8000c96a:	8361                	srl	a4,a4,0x18
8000c96c:	00159793          	sll	a5,a1,0x1
8000c970:	83e1                	srl	a5,a5,0x18
8000c972:	00b54333          	xor	t1,a0,a1
8000c976:	01f35313          	srl	t1,t1,0x1f
8000c97a:	037e                	sll	t1,t1,0x1f
8000c97c:	cf5d                	beqz	a4,8000ca3a <.L__divsf3_lhs_zero_or_subnormal>
8000c97e:	cbf9                	beqz	a5,8000ca54 <.L__divsf3_rhs_zero_or_subnormal>
8000c980:	0c570563          	beq	a4,t0,8000ca4a <.L__divsf3_lhs_inf_or_nan>
8000c984:	0c578d63          	beq	a5,t0,8000ca5e <.L__divsf3_rhs_inf_or_nan>
8000c988:	8f1d                	sub	a4,a4,a5
8000c98a:	800032b7          	lui	t0,0x80003
8000c98e:	4b028293          	add	t0,t0,1200 # 800034b0 <__SEGGER_RTL_fdiv_reciprocal_table>
8000c992:	00f5d693          	srl	a3,a1,0xf
8000c996:	0fc6f693          	and	a3,a3,252
8000c99a:	9696                	add	a3,a3,t0
8000c99c:	429c                	lw	a5,0(a3)
8000c99e:	4187d613          	sra	a2,a5,0x18
8000c9a2:	00f59693          	sll	a3,a1,0xf
8000c9a6:	82e1                	srl	a3,a3,0x18
8000c9a8:	0016f293          	and	t0,a3,1
8000c9ac:	8285                	srl	a3,a3,0x1
8000c9ae:	fc068693          	add	a3,a3,-64 # f3ffffc0 <__AHB_SRAM_segment_end__+0x3cf7fc0>
8000c9b2:	9696                	add	a3,a3,t0
8000c9b4:	02d60633          	mul	a2,a2,a3
8000c9b8:	07a2                	sll	a5,a5,0x8
8000c9ba:	83a1                	srl	a5,a5,0x8
8000c9bc:	963e                	add	a2,a2,a5
8000c9be:	05a2                	sll	a1,a1,0x8
8000c9c0:	81a1                	srl	a1,a1,0x8
8000c9c2:	008007b7          	lui	a5,0x800
8000c9c6:	8ddd                	or	a1,a1,a5
8000c9c8:	02c586b3          	mul	a3,a1,a2
8000c9cc:	0522                	sll	a0,a0,0x8
8000c9ce:	8121                	srl	a0,a0,0x8
8000c9d0:	8d5d                	or	a0,a0,a5
8000c9d2:	02c697b3          	mulh	a5,a3,a2
8000c9d6:	00b532b3          	sltu	t0,a0,a1
8000c9da:	00551533          	sll	a0,a0,t0
8000c9de:	40570733          	sub	a4,a4,t0
8000c9e2:	01465693          	srl	a3,a2,0x14
8000c9e6:	8a85                	and	a3,a3,1
8000c9e8:	0016c693          	xor	a3,a3,1
8000c9ec:	062e                	sll	a2,a2,0xb
8000c9ee:	8e1d                	sub	a2,a2,a5
8000c9f0:	8e15                	sub	a2,a2,a3
8000c9f2:	050a                	sll	a0,a0,0x2
8000c9f4:	02a617b3          	mulh	a5,a2,a0
8000c9f8:	07e70613          	add	a2,a4,126
8000c9fc:	055a                	sll	a0,a0,0x16
8000c9fe:	8d0d                	sub	a0,a0,a1
8000ca00:	02b786b3          	mul	a3,a5,a1
8000ca04:	0fe00293          	li	t0,254
8000ca08:	00567f63          	bgeu	a2,t0,8000ca26 <.L__divsf3_underflow_or_overflow>
8000ca0c:	40a68533          	sub	a0,a3,a0
8000ca10:	000522b3          	sltz	t0,a0
8000ca14:	9796                	add	a5,a5,t0
8000ca16:	0017f513          	and	a0,a5,1
8000ca1a:	8385                	srl	a5,a5,0x1
8000ca1c:	953e                	add	a0,a0,a5
8000ca1e:	065e                	sll	a2,a2,0x17
8000ca20:	9532                	add	a0,a0,a2
8000ca22:	951a                	add	a0,a0,t1
8000ca24:	8082                	ret

8000ca26 <.L__divsf3_underflow_or_overflow>:
8000ca26:	851a                	mv	a0,t1
8000ca28:	00564563          	blt	a2,t0,8000ca32 <.L__divsf3_done>
8000ca2c:	7f800337          	lui	t1,0x7f800

8000ca30 <.L__divsf3_apply_sign>:
8000ca30:	951a                	add	a0,a0,t1

8000ca32 <.L__divsf3_done>:
8000ca32:	8082                	ret

8000ca34 <.L__divsf3_inf>:
8000ca34:	7f800537          	lui	a0,0x7f800
8000ca38:	bfe5                	j	8000ca30 <.L__divsf3_apply_sign>

8000ca3a <.L__divsf3_lhs_zero_or_subnormal>:
8000ca3a:	c789                	beqz	a5,8000ca44 <.L__divsf3_nan>
8000ca3c:	02579363          	bne	a5,t0,8000ca62 <.L__divsf3_signed_zero>
8000ca40:	05a6                	sll	a1,a1,0x9
8000ca42:	c185                	beqz	a1,8000ca62 <.L__divsf3_signed_zero>

8000ca44 <.L__divsf3_nan>:
8000ca44:	7fc00537          	lui	a0,0x7fc00
8000ca48:	8082                	ret

8000ca4a <.L__divsf3_lhs_inf_or_nan>:
8000ca4a:	0526                	sll	a0,a0,0x9
8000ca4c:	fd65                	bnez	a0,8000ca44 <.L__divsf3_nan>
8000ca4e:	fe5793e3          	bne	a5,t0,8000ca34 <.L__divsf3_inf>
8000ca52:	bfcd                	j	8000ca44 <.L__divsf3_nan>

8000ca54 <.L__divsf3_rhs_zero_or_subnormal>:
8000ca54:	fe5710e3          	bne	a4,t0,8000ca34 <.L__divsf3_inf>
8000ca58:	0526                	sll	a0,a0,0x9
8000ca5a:	f56d                	bnez	a0,8000ca44 <.L__divsf3_nan>
8000ca5c:	bfe1                	j	8000ca34 <.L__divsf3_inf>

8000ca5e <.L__divsf3_rhs_inf_or_nan>:
8000ca5e:	05a6                	sll	a1,a1,0x9
8000ca60:	f1f5                	bnez	a1,8000ca44 <.L__divsf3_nan>

8000ca62 <.L__divsf3_signed_zero>:
8000ca62:	851a                	mv	a0,t1
8000ca64:	8082                	ret

Disassembly of section .text.libc.__divdf3:

8000ca66 <__divdf3>:
8000ca66:	00169813          	sll	a6,a3,0x1
8000ca6a:	01585813          	srl	a6,a6,0x15
8000ca6e:	00159893          	sll	a7,a1,0x1
8000ca72:	0158d893          	srl	a7,a7,0x15
8000ca76:	00d5c3b3          	xor	t2,a1,a3
8000ca7a:	01f3d393          	srl	t2,t2,0x1f
8000ca7e:	03fe                	sll	t2,t2,0x1f
8000ca80:	7ff00293          	li	t0,2047
8000ca84:	16588e63          	beq	a7,t0,8000cc00 <.L__divdf3_inf_nan_over>
8000ca88:	18080a63          	beqz	a6,8000cc1c <.L__divdf3_div_zero>
8000ca8c:	18580263          	beq	a6,t0,8000cc10 <.L__divdf3_div_inf_nan>
8000ca90:	18088263          	beqz	a7,8000cc14 <.L__divdf3_signed_zero>
8000ca94:	410888b3          	sub	a7,a7,a6
8000ca98:	3ff88893          	add	a7,a7,1023 # 800003ff <__SHARE_RAM_segment_end__+0x7ee803ff>
8000ca9c:	05b2                	sll	a1,a1,0xc
8000ca9e:	81b1                	srl	a1,a1,0xc
8000caa0:	06b2                	sll	a3,a3,0xc
8000caa2:	82b1                	srl	a3,a3,0xc
8000caa4:	00100737          	lui	a4,0x100
8000caa8:	8dd9                	or	a1,a1,a4
8000caaa:	8ed9                	or	a3,a3,a4
8000caac:	00c53733          	sltu	a4,a0,a2
8000cab0:	9736                	add	a4,a4,a3
8000cab2:	8d99                	sub	a1,a1,a4
8000cab4:	8d11                	sub	a0,a0,a2
8000cab6:	0005dd63          	bgez	a1,8000cad0 <.L__divdf3_can_subtract>
8000caba:	00052733          	sltz	a4,a0
8000cabe:	95ae                	add	a1,a1,a1
8000cac0:	95ba                	add	a1,a1,a4
8000cac2:	95b6                	add	a1,a1,a3
8000cac4:	952a                	add	a0,a0,a0
8000cac6:	9532                	add	a0,a0,a2
8000cac8:	00c53733          	sltu	a4,a0,a2
8000cacc:	95ba                	add	a1,a1,a4
8000cace:	18fd                	add	a7,a7,-1

8000cad0 <.L__divdf3_can_subtract>:
8000cad0:	1258dd63          	bge	a7,t0,8000cc0a <.L__divdf3_signed_inf>
8000cad4:	15105063          	blez	a7,8000cc14 <.L__divdf3_signed_zero>
8000cad8:	05aa                	sll	a1,a1,0xa
8000cada:	01655713          	srl	a4,a0,0x16
8000cade:	8dd9                	or	a1,a1,a4
8000cae0:	052a                	sll	a0,a0,0xa
8000cae2:	02d5d833          	divu	a6,a1,a3
8000cae6:	02d80e33          	mul	t3,a6,a3
8000caea:	41c585b3          	sub	a1,a1,t3
8000caee:	02c80733          	mul	a4,a6,a2
8000caf2:	02c837b3          	mulhu	a5,a6,a2
8000caf6:	00e53e33          	sltu	t3,a0,a4
8000cafa:	97f2                	add	a5,a5,t3
8000cafc:	8d19                	sub	a0,a0,a4
8000cafe:	8d9d                	sub	a1,a1,a5
8000cb00:	0005d863          	bgez	a1,8000cb10 <.L__divdf3_qdash_correct_1>
8000cb04:	187d                	add	a6,a6,-1 # ffdfffff <__APB_SRAM_segment_end__+0xbd0dfff>
8000cb06:	9532                	add	a0,a0,a2
8000cb08:	95b6                	add	a1,a1,a3
8000cb0a:	00c532b3          	sltu	t0,a0,a2
8000cb0e:	9596                	add	a1,a1,t0

8000cb10 <.L__divdf3_qdash_correct_1>:
8000cb10:	05aa                	sll	a1,a1,0xa
8000cb12:	01655293          	srl	t0,a0,0x16
8000cb16:	9596                	add	a1,a1,t0
8000cb18:	052a                	sll	a0,a0,0xa
8000cb1a:	02d5d2b3          	divu	t0,a1,a3
8000cb1e:	02d28733          	mul	a4,t0,a3
8000cb22:	8d99                	sub	a1,a1,a4
8000cb24:	02c28733          	mul	a4,t0,a2
8000cb28:	02c2b7b3          	mulhu	a5,t0,a2
8000cb2c:	00e53e33          	sltu	t3,a0,a4
8000cb30:	97f2                	add	a5,a5,t3
8000cb32:	8d19                	sub	a0,a0,a4
8000cb34:	8d9d                	sub	a1,a1,a5
8000cb36:	0005d863          	bgez	a1,8000cb46 <.L__divdf3_qdash_correct_2>
8000cb3a:	12fd                	add	t0,t0,-1
8000cb3c:	9532                	add	a0,a0,a2
8000cb3e:	95b6                	add	a1,a1,a3
8000cb40:	00c53e33          	sltu	t3,a0,a2
8000cb44:	95f2                	add	a1,a1,t3

8000cb46 <.L__divdf3_qdash_correct_2>:
8000cb46:	082a                	sll	a6,a6,0xa
8000cb48:	9816                	add	a6,a6,t0
8000cb4a:	05ae                	sll	a1,a1,0xb
8000cb4c:	01555e13          	srl	t3,a0,0x15
8000cb50:	95f2                	add	a1,a1,t3
8000cb52:	052e                	sll	a0,a0,0xb
8000cb54:	02d5d2b3          	divu	t0,a1,a3
8000cb58:	02d28733          	mul	a4,t0,a3
8000cb5c:	8d99                	sub	a1,a1,a4
8000cb5e:	02c28733          	mul	a4,t0,a2
8000cb62:	02c2b7b3          	mulhu	a5,t0,a2
8000cb66:	00e53e33          	sltu	t3,a0,a4
8000cb6a:	97f2                	add	a5,a5,t3
8000cb6c:	8d19                	sub	a0,a0,a4
8000cb6e:	8d9d                	sub	a1,a1,a5
8000cb70:	0005d863          	bgez	a1,8000cb80 <.L__divdf3_qdash_correct_3>
8000cb74:	12fd                	add	t0,t0,-1
8000cb76:	9532                	add	a0,a0,a2
8000cb78:	95b6                	add	a1,a1,a3
8000cb7a:	00c53e33          	sltu	t3,a0,a2
8000cb7e:	95f2                	add	a1,a1,t3

8000cb80 <.L__divdf3_qdash_correct_3>:
8000cb80:	05ae                	sll	a1,a1,0xb
8000cb82:	01555e13          	srl	t3,a0,0x15
8000cb86:	95f2                	add	a1,a1,t3
8000cb88:	052e                	sll	a0,a0,0xb
8000cb8a:	02d5d333          	divu	t1,a1,a3
8000cb8e:	02d30733          	mul	a4,t1,a3
8000cb92:	8d99                	sub	a1,a1,a4
8000cb94:	02c30733          	mul	a4,t1,a2
8000cb98:	02c337b3          	mulhu	a5,t1,a2
8000cb9c:	00e53e33          	sltu	t3,a0,a4
8000cba0:	97f2                	add	a5,a5,t3
8000cba2:	8d19                	sub	a0,a0,a4
8000cba4:	8d9d                	sub	a1,a1,a5
8000cba6:	0005d863          	bgez	a1,8000cbb6 <.L__divdf3_qdash_correct_4>
8000cbaa:	137d                	add	t1,t1,-1 # 7f7fffff <__SHARE_RAM_segment_end__+0x7e67ffff>
8000cbac:	9532                	add	a0,a0,a2
8000cbae:	95b6                	add	a1,a1,a3
8000cbb0:	00c53e33          	sltu	t3,a0,a2
8000cbb4:	95f2                	add	a1,a1,t3

8000cbb6 <.L__divdf3_qdash_correct_4>:
8000cbb6:	02d6                	sll	t0,t0,0x15
8000cbb8:	032a                	sll	t1,t1,0xa
8000cbba:	929a                	add	t0,t0,t1
8000cbbc:	05ae                	sll	a1,a1,0xb
8000cbbe:	01555e13          	srl	t3,a0,0x15
8000cbc2:	95f2                	add	a1,a1,t3
8000cbc4:	052e                	sll	a0,a0,0xb
8000cbc6:	02d5d333          	divu	t1,a1,a3
8000cbca:	02d30733          	mul	a4,t1,a3
8000cbce:	8d99                	sub	a1,a1,a4
8000cbd0:	02c30733          	mul	a4,t1,a2
8000cbd4:	02c337b3          	mulhu	a5,t1,a2
8000cbd8:	00e53e33          	sltu	t3,a0,a4
8000cbdc:	97f2                	add	a5,a5,t3
8000cbde:	8d9d                	sub	a1,a1,a5
8000cbe0:	85fd                	sra	a1,a1,0x1f
8000cbe2:	932e                	add	t1,t1,a1
8000cbe4:	08d2                	sll	a7,a7,0x14
8000cbe6:	011805b3          	add	a1,a6,a7
8000cbea:	00135513          	srl	a0,t1,0x1
8000cbee:	9516                	add	a0,a0,t0
8000cbf0:	00137313          	and	t1,t1,1
8000cbf4:	951a                	add	a0,a0,t1
8000cbf6:	00653733          	sltu	a4,a0,t1
8000cbfa:	95ba                	add	a1,a1,a4
8000cbfc:	959e                	add	a1,a1,t2
8000cbfe:	8082                	ret

8000cc00 <.L__divdf3_inf_nan_over>:
8000cc00:	05b2                	sll	a1,a1,0xc
8000cc02:	00580f63          	beq	a6,t0,8000cc20 <.L__divdf3_return_nan>
8000cc06:	8dc9                	or	a1,a1,a0
8000cc08:	ed81                	bnez	a1,8000cc20 <.L__divdf3_return_nan>

8000cc0a <.L__divdf3_signed_inf>:
8000cc0a:	7ff005b7          	lui	a1,0x7ff00
8000cc0e:	a021                	j	8000cc16 <.L__divdf3_apply_sign>

8000cc10 <.L__divdf3_div_inf_nan>:
8000cc10:	06b2                	sll	a3,a3,0xc
8000cc12:	e699                	bnez	a3,8000cc20 <.L__divdf3_return_nan>

8000cc14 <.L__divdf3_signed_zero>:
8000cc14:	4581                	li	a1,0

8000cc16 <.L__divdf3_apply_sign>:
8000cc16:	959e                	add	a1,a1,t2

8000cc18 <.L__divdf3_clr_low_ret>:
8000cc18:	4501                	li	a0,0
8000cc1a:	8082                	ret

8000cc1c <.L__divdf3_div_zero>:
8000cc1c:	fe0897e3          	bnez	a7,8000cc0a <.L__divdf3_signed_inf>

8000cc20 <.L__divdf3_return_nan>:
8000cc20:	7ff805b7          	lui	a1,0x7ff80
8000cc24:	bfd5                	j	8000cc18 <.L__divdf3_clr_low_ret>

Disassembly of section .text.libc.__eqsf2:

8000cc26 <__eqsf2>:
8000cc26:	ff000637          	lui	a2,0xff000
8000cc2a:	00151693          	sll	a3,a0,0x1
8000cc2e:	02d66063          	bltu	a2,a3,8000cc4e <.L__eqsf2_one>
8000cc32:	00159693          	sll	a3,a1,0x1
8000cc36:	00d66c63          	bltu	a2,a3,8000cc4e <.L__eqsf2_one>
8000cc3a:	00b56633          	or	a2,a0,a1
8000cc3e:	0606                	sll	a2,a2,0x1
8000cc40:	c609                	beqz	a2,8000cc4a <.L__eqsf2_zero>
8000cc42:	8d0d                	sub	a0,a0,a1
8000cc44:	00a03533          	snez	a0,a0
8000cc48:	8082                	ret

8000cc4a <.L__eqsf2_zero>:
8000cc4a:	4501                	li	a0,0
8000cc4c:	8082                	ret

8000cc4e <.L__eqsf2_one>:
8000cc4e:	4505                	li	a0,1
8000cc50:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

8000cc52 <__fixunssfdi>:
8000cc52:	04054a63          	bltz	a0,8000cca6 <.L__fixunssfdi_zero_result>
8000cc56:	00151613          	sll	a2,a0,0x1
8000cc5a:	8261                	srl	a2,a2,0x18
8000cc5c:	f8160613          	add	a2,a2,-127 # feffff81 <__APB_SRAM_segment_end__+0xaf0df81>
8000cc60:	04064363          	bltz	a2,8000cca6 <.L__fixunssfdi_zero_result>
8000cc64:	800006b7          	lui	a3,0x80000
8000cc68:	02000293          	li	t0,32
8000cc6c:	00565b63          	bge	a2,t0,8000cc82 <.L__fixunssfdi_long_shift>
8000cc70:	40c00633          	neg	a2,a2
8000cc74:	067d                	add	a2,a2,31
8000cc76:	0522                	sll	a0,a0,0x8
8000cc78:	8d55                	or	a0,a0,a3
8000cc7a:	00c55533          	srl	a0,a0,a2
8000cc7e:	4581                	li	a1,0
8000cc80:	8082                	ret

8000cc82 <.L__fixunssfdi_long_shift>:
8000cc82:	40c00633          	neg	a2,a2
8000cc86:	03f60613          	add	a2,a2,63
8000cc8a:	02064163          	bltz	a2,8000ccac <.L__fixunssfdi_overflow_result>
8000cc8e:	00851593          	sll	a1,a0,0x8
8000cc92:	8dd5                	or	a1,a1,a3
8000cc94:	4501                	li	a0,0
8000cc96:	c619                	beqz	a2,8000cca4 <.L__fixunssfdi_shift_32>
8000cc98:	40c006b3          	neg	a3,a2
8000cc9c:	00d59533          	sll	a0,a1,a3
8000cca0:	00c5d5b3          	srl	a1,a1,a2

8000cca4 <.L__fixunssfdi_shift_32>:
8000cca4:	8082                	ret

8000cca6 <.L__fixunssfdi_zero_result>:
8000cca6:	4501                	li	a0,0
8000cca8:	4581                	li	a1,0
8000ccaa:	8082                	ret

8000ccac <.L__fixunssfdi_overflow_result>:
8000ccac:	557d                	li	a0,-1
8000ccae:	55fd                	li	a1,-1
8000ccb0:	8082                	ret

Disassembly of section .text.libc.__floatunsidf:

8000ccb2 <__floatunsidf>:
8000ccb2:	c131                	beqz	a0,8000ccf6 <.L__floatunsidf_zero>
8000ccb4:	41d00613          	li	a2,1053
8000ccb8:	01055693          	srl	a3,a0,0x10
8000ccbc:	e299                	bnez	a3,8000ccc2 <.L1^B9>
8000ccbe:	0542                	sll	a0,a0,0x10
8000ccc0:	1641                	add	a2,a2,-16

8000ccc2 <.L1^B9>:
8000ccc2:	01855693          	srl	a3,a0,0x18
8000ccc6:	e299                	bnez	a3,8000cccc <.L2^B9>
8000ccc8:	0522                	sll	a0,a0,0x8
8000ccca:	1661                	add	a2,a2,-8

8000cccc <.L2^B9>:
8000cccc:	01c55693          	srl	a3,a0,0x1c
8000ccd0:	e299                	bnez	a3,8000ccd6 <.L3^B7>
8000ccd2:	0512                	sll	a0,a0,0x4
8000ccd4:	1671                	add	a2,a2,-4

8000ccd6 <.L3^B7>:
8000ccd6:	01e55693          	srl	a3,a0,0x1e
8000ccda:	e299                	bnez	a3,8000cce0 <.L4^B9>
8000ccdc:	050a                	sll	a0,a0,0x2
8000ccde:	1679                	add	a2,a2,-2

8000cce0 <.L4^B9>:
8000cce0:	00054463          	bltz	a0,8000cce8 <.L5^B7>
8000cce4:	0506                	sll	a0,a0,0x1
8000cce6:	167d                	add	a2,a2,-1

8000cce8 <.L5^B7>:
8000cce8:	0652                	sll	a2,a2,0x14
8000ccea:	00b55693          	srl	a3,a0,0xb
8000ccee:	0556                	sll	a0,a0,0x15
8000ccf0:	00c685b3          	add	a1,a3,a2
8000ccf4:	8082                	ret

8000ccf6 <.L__floatunsidf_zero>:
8000ccf6:	85aa                	mv	a1,a0
8000ccf8:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

8000ccfa <__trunctfsf2>:
8000ccfa:	4110                	lw	a2,0(a0)
8000ccfc:	4154                	lw	a3,4(a0)
8000ccfe:	4518                	lw	a4,8(a0)
8000cd00:	455c                	lw	a5,12(a0)
8000cd02:	1101                	add	sp,sp,-32
8000cd04:	850a                	mv	a0,sp
8000cd06:	ce06                	sw	ra,28(sp)
8000cd08:	c032                	sw	a2,0(sp)
8000cd0a:	c236                	sw	a3,4(sp)
8000cd0c:	c43a                	sw	a4,8(sp)
8000cd0e:	c63e                	sw	a5,12(sp)
8000cd10:	bedfb0ef          	jal	800088fc <__SEGGER_RTL_ldouble_to_double>
8000cd14:	b63fb0ef          	jal	80008876 <__truncdfsf2>
8000cd18:	40f2                	lw	ra,28(sp)
8000cd1a:	6105                	add	sp,sp,32
8000cd1c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

8000cd1e <__SEGGER_RTL_float32_signbit>:
8000cd1e:	817d                	srl	a0,a0,0x1f
8000cd20:	8082                	ret

Disassembly of section .text.libc.ldexpf:

8000cd22 <ldexpf>:
8000cd22:	01755713          	srl	a4,a0,0x17
8000cd26:	0ff77713          	zext.b	a4,a4
8000cd2a:	fff70613          	add	a2,a4,-1 # fffff <__DLM_segment_end__+0x3ffff>
8000cd2e:	0fd00693          	li	a3,253
8000cd32:	87aa                	mv	a5,a0
8000cd34:	02c6e863          	bltu	a3,a2,8000cd64 <.L780>
8000cd38:	95ba                	add	a1,a1,a4
8000cd3a:	fff58713          	add	a4,a1,-1 # 7ff7ffff <__SHARE_RAM_segment_end__+0x7edfffff>
8000cd3e:	00e6eb63          	bltu	a3,a4,8000cd54 <.L781>
8000cd42:	80800737          	lui	a4,0x80800
8000cd46:	177d                	add	a4,a4,-1 # 807fffff <__XPI0_segment_used_end__+0x7f03c7>
8000cd48:	00e577b3          	and	a5,a0,a4
8000cd4c:	05de                	sll	a1,a1,0x17
8000cd4e:	00f5e533          	or	a0,a1,a5
8000cd52:	8082                	ret

8000cd54 <.L781>:
8000cd54:	80000537          	lui	a0,0x80000
8000cd58:	8d7d                	and	a0,a0,a5
8000cd5a:	00b05563          	blez	a1,8000cd64 <.L780>
8000cd5e:	7f8007b7          	lui	a5,0x7f800
8000cd62:	8d5d                	or	a0,a0,a5

8000cd64 <.L780>:
8000cd64:	8082                	ret

Disassembly of section .text.libc.frexpf:

8000cd66 <frexpf>:
8000cd66:	01755793          	srl	a5,a0,0x17
8000cd6a:	0ff7f793          	zext.b	a5,a5
8000cd6e:	4701                	li	a4,0
8000cd70:	cf99                	beqz	a5,8000cd8e <.L959>
8000cd72:	0ff00613          	li	a2,255
8000cd76:	00c78c63          	beq	a5,a2,8000cd8e <.L959>
8000cd7a:	f8278713          	add	a4,a5,-126 # 7f7fff82 <__SHARE_RAM_segment_end__+0x7e67ff82>
8000cd7e:	808007b7          	lui	a5,0x80800
8000cd82:	17fd                	add	a5,a5,-1 # 807fffff <__XPI0_segment_used_end__+0x7f03c7>
8000cd84:	00f576b3          	and	a3,a0,a5
8000cd88:	3f000537          	lui	a0,0x3f000
8000cd8c:	8d55                	or	a0,a0,a3

8000cd8e <.L959>:
8000cd8e:	c198                	sw	a4,0(a1)
8000cd90:	8082                	ret

Disassembly of section .text.libc.fmodf:

8000cd92 <fmodf>:
8000cd92:	01755793          	srl	a5,a0,0x17
8000cd96:	80000837          	lui	a6,0x80000
8000cd9a:	17fd                	add	a5,a5,-1
8000cd9c:	0fd00713          	li	a4,253
8000cda0:	86aa                	mv	a3,a0
8000cda2:	862e                	mv	a2,a1
8000cda4:	00a87833          	and	a6,a6,a0
8000cda8:	02f76463          	bltu	a4,a5,8000cdd0 <.L991>
8000cdac:	0175d793          	srl	a5,a1,0x17
8000cdb0:	17fd                	add	a5,a5,-1
8000cdb2:	02f77e63          	bgeu	a4,a5,8000cdee <.L992>
8000cdb6:	00151713          	sll	a4,a0,0x1

8000cdba <.L993>:
8000cdba:	00159793          	sll	a5,a1,0x1
8000cdbe:	ff000637          	lui	a2,0xff000
8000cdc2:	0cf66663          	bltu	a2,a5,8000ce8e <.L1009>
8000cdc6:	ef01                	bnez	a4,8000cdde <.L995>
8000cdc8:	eb91                	bnez	a5,8000cddc <.L994>

8000cdca <.L1011>:
8000cdca:	9f822503          	lw	a0,-1544(tp) # fffff9f8 <__APB_SRAM_segment_end__+0xbf0d9f8>
8000cdce:	8082                	ret

8000cdd0 <.L991>:
8000cdd0:	00151713          	sll	a4,a0,0x1
8000cdd4:	ff0007b7          	lui	a5,0xff000
8000cdd8:	fee7f1e3          	bgeu	a5,a4,8000cdba <.L993>

8000cddc <.L994>:
8000cddc:	8082                	ret

8000cdde <.L995>:
8000cdde:	fec706e3          	beq	a4,a2,8000cdca <.L1011>
8000cde2:	fec78de3          	beq	a5,a2,8000cddc <.L994>
8000cde6:	d3f5                	beqz	a5,8000cdca <.L1011>
8000cde8:	0586                	sll	a1,a1,0x1
8000cdea:	0015d613          	srl	a2,a1,0x1

8000cdee <.L992>:
8000cdee:	00169793          	sll	a5,a3,0x1
8000cdf2:	8385                	srl	a5,a5,0x1
8000cdf4:	00f66663          	bltu	a2,a5,8000ce00 <.L996>
8000cdf8:	fec792e3          	bne	a5,a2,8000cddc <.L994>

8000cdfc <.L1018>:
8000cdfc:	8542                	mv	a0,a6
8000cdfe:	8082                	ret

8000ce00 <.L996>:
8000ce00:	0177d713          	srl	a4,a5,0x17
8000ce04:	cb0d                	beqz	a4,8000ce36 <.L1012>
8000ce06:	008007b7          	lui	a5,0x800
8000ce0a:	fff78593          	add	a1,a5,-1 # 7fffff <__XPI0_segment_size__+0x2fff>
8000ce0e:	8eed                	and	a3,a3,a1
8000ce10:	8fd5                	or	a5,a5,a3

8000ce12 <.L998>:
8000ce12:	01765593          	srl	a1,a2,0x17
8000ce16:	c985                	beqz	a1,8000ce46 <.L1013>
8000ce18:	008006b7          	lui	a3,0x800
8000ce1c:	fff68513          	add	a0,a3,-1 # 7fffff <__XPI0_segment_size__+0x2fff>
8000ce20:	8e69                	and	a2,a2,a0
8000ce22:	8e55                	or	a2,a2,a3

8000ce24 <.L1002>:
8000ce24:	40c786b3          	sub	a3,a5,a2
8000ce28:	02e5c763          	blt	a1,a4,8000ce56 <.L1003>
8000ce2c:	0206cc63          	bltz	a3,8000ce64 <.L1015>
8000ce30:	8542                	mv	a0,a6
8000ce32:	ea95                	bnez	a3,8000ce66 <.L1004>
8000ce34:	8082                	ret

8000ce36 <.L1012>:
8000ce36:	4701                	li	a4,0
8000ce38:	008006b7          	lui	a3,0x800

8000ce3c <.L997>:
8000ce3c:	0786                	sll	a5,a5,0x1
8000ce3e:	177d                	add	a4,a4,-1
8000ce40:	fed7eee3          	bltu	a5,a3,8000ce3c <.L997>
8000ce44:	b7f9                	j	8000ce12 <.L998>

8000ce46 <.L1013>:
8000ce46:	4581                	li	a1,0
8000ce48:	008006b7          	lui	a3,0x800

8000ce4c <.L999>:
8000ce4c:	0606                	sll	a2,a2,0x1
8000ce4e:	15fd                	add	a1,a1,-1
8000ce50:	fed66ee3          	bltu	a2,a3,8000ce4c <.L999>
8000ce54:	bfc1                	j	8000ce24 <.L1002>

8000ce56 <.L1003>:
8000ce56:	0006c463          	bltz	a3,8000ce5e <.L1001>
8000ce5a:	d2cd                	beqz	a3,8000cdfc <.L1018>
8000ce5c:	87b6                	mv	a5,a3

8000ce5e <.L1001>:
8000ce5e:	0786                	sll	a5,a5,0x1
8000ce60:	177d                	add	a4,a4,-1
8000ce62:	b7c9                	j	8000ce24 <.L1002>

8000ce64 <.L1015>:
8000ce64:	86be                	mv	a3,a5

8000ce66 <.L1004>:
8000ce66:	008007b7          	lui	a5,0x800

8000ce6a <.L1006>:
8000ce6a:	fff70513          	add	a0,a4,-1
8000ce6e:	00f6ed63          	bltu	a3,a5,8000ce88 <.L1007>
8000ce72:	00e04763          	bgtz	a4,8000ce80 <.L1008>
8000ce76:	4785                	li	a5,1
8000ce78:	8f99                	sub	a5,a5,a4
8000ce7a:	00f6d6b3          	srl	a3,a3,a5
8000ce7e:	4501                	li	a0,0

8000ce80 <.L1008>:
8000ce80:	9836                	add	a6,a6,a3
8000ce82:	055e                	sll	a0,a0,0x17
8000ce84:	9542                	add	a0,a0,a6
8000ce86:	8082                	ret

8000ce88 <.L1007>:
8000ce88:	0686                	sll	a3,a3,0x1
8000ce8a:	872a                	mv	a4,a0
8000ce8c:	bff9                	j	8000ce6a <.L1006>

8000ce8e <.L1009>:
8000ce8e:	852e                	mv	a0,a1
8000ce90:	8082                	ret

Disassembly of section .text.libc.memset:

8000ce92 <memset>:
8000ce92:	872a                	mv	a4,a0
8000ce94:	c22d                	beqz	a2,8000cef6 <.Lmemset_memset_end>

8000ce96 <.Lmemset_unaligned_byte_set_loop>:
8000ce96:	01e51693          	sll	a3,a0,0x1e
8000ce9a:	c699                	beqz	a3,8000cea8 <.Lmemset_fast_set>
8000ce9c:	00b50023          	sb	a1,0(a0) # 3f000000 <__SHARE_RAM_segment_end__+0x3de80000>
8000cea0:	0505                	add	a0,a0,1
8000cea2:	167d                	add	a2,a2,-1 # feffffff <__APB_SRAM_segment_end__+0xaf0dfff>
8000cea4:	fa6d                	bnez	a2,8000ce96 <.Lmemset_unaligned_byte_set_loop>
8000cea6:	a881                	j	8000cef6 <.Lmemset_memset_end>

8000cea8 <.Lmemset_fast_set>:
8000cea8:	0ff5f593          	zext.b	a1,a1
8000ceac:	00859693          	sll	a3,a1,0x8
8000ceb0:	8dd5                	or	a1,a1,a3
8000ceb2:	01059693          	sll	a3,a1,0x10
8000ceb6:	8dd5                	or	a1,a1,a3
8000ceb8:	02000693          	li	a3,32
8000cebc:	00d66f63          	bltu	a2,a3,8000ceda <.Lmemset_word_set>

8000cec0 <.Lmemset_fast_set_loop>:
8000cec0:	c10c                	sw	a1,0(a0)
8000cec2:	c14c                	sw	a1,4(a0)
8000cec4:	c50c                	sw	a1,8(a0)
8000cec6:	c54c                	sw	a1,12(a0)
8000cec8:	c90c                	sw	a1,16(a0)
8000ceca:	c94c                	sw	a1,20(a0)
8000cecc:	cd0c                	sw	a1,24(a0)
8000cece:	cd4c                	sw	a1,28(a0)
8000ced0:	9536                	add	a0,a0,a3
8000ced2:	8e15                	sub	a2,a2,a3
8000ced4:	fed676e3          	bgeu	a2,a3,8000cec0 <.Lmemset_fast_set_loop>
8000ced8:	ce19                	beqz	a2,8000cef6 <.Lmemset_memset_end>

8000ceda <.Lmemset_word_set>:
8000ceda:	4691                	li	a3,4
8000cedc:	00d66863          	bltu	a2,a3,8000ceec <.Lmemset_byte_set_loop>

8000cee0 <.Lmemset_word_set_loop>:
8000cee0:	c10c                	sw	a1,0(a0)
8000cee2:	9536                	add	a0,a0,a3
8000cee4:	8e15                	sub	a2,a2,a3
8000cee6:	fed67de3          	bgeu	a2,a3,8000cee0 <.Lmemset_word_set_loop>
8000ceea:	c611                	beqz	a2,8000cef6 <.Lmemset_memset_end>

8000ceec <.Lmemset_byte_set_loop>:
8000ceec:	00b50023          	sb	a1,0(a0)
8000cef0:	0505                	add	a0,a0,1
8000cef2:	167d                	add	a2,a2,-1
8000cef4:	fe65                	bnez	a2,8000ceec <.Lmemset_byte_set_loop>

8000cef6 <.Lmemset_memset_end>:
8000cef6:	853a                	mv	a0,a4
8000cef8:	8082                	ret

Disassembly of section .text.libc.strlen:

8000cefa <strlen>:
8000cefa:	85aa                	mv	a1,a0
8000cefc:	00357693          	and	a3,a0,3
8000cf00:	c29d                	beqz	a3,8000cf26 <.Lstrlen_aligned>
8000cf02:	00054603          	lbu	a2,0(a0)
8000cf06:	ce21                	beqz	a2,8000cf5e <.Lstrlen_done>
8000cf08:	0505                	add	a0,a0,1
8000cf0a:	00357693          	and	a3,a0,3
8000cf0e:	ce81                	beqz	a3,8000cf26 <.Lstrlen_aligned>
8000cf10:	00054603          	lbu	a2,0(a0)
8000cf14:	c629                	beqz	a2,8000cf5e <.Lstrlen_done>
8000cf16:	0505                	add	a0,a0,1
8000cf18:	00357693          	and	a3,a0,3
8000cf1c:	c689                	beqz	a3,8000cf26 <.Lstrlen_aligned>
8000cf1e:	00054603          	lbu	a2,0(a0)
8000cf22:	ce15                	beqz	a2,8000cf5e <.Lstrlen_done>
8000cf24:	0505                	add	a0,a0,1

8000cf26 <.Lstrlen_aligned>:
8000cf26:	01010637          	lui	a2,0x1010
8000cf2a:	10160613          	add	a2,a2,257 # 1010101 <_extram_size+0x10101>
8000cf2e:	00761693          	sll	a3,a2,0x7

8000cf32 <.Lstrlen_wordstrlen>:
8000cf32:	4118                	lw	a4,0(a0)
8000cf34:	0511                	add	a0,a0,4
8000cf36:	40c707b3          	sub	a5,a4,a2
8000cf3a:	fff74713          	not	a4,a4
8000cf3e:	8ff9                	and	a5,a5,a4
8000cf40:	8ff5                	and	a5,a5,a3
8000cf42:	dbe5                	beqz	a5,8000cf32 <.Lstrlen_wordstrlen>
8000cf44:	1571                	add	a0,a0,-4
8000cf46:	01879713          	sll	a4,a5,0x18
8000cf4a:	eb11                	bnez	a4,8000cf5e <.Lstrlen_done>
8000cf4c:	0505                	add	a0,a0,1
8000cf4e:	01079713          	sll	a4,a5,0x10
8000cf52:	e711                	bnez	a4,8000cf5e <.Lstrlen_done>
8000cf54:	0505                	add	a0,a0,1
8000cf56:	00879713          	sll	a4,a5,0x8
8000cf5a:	e311                	bnez	a4,8000cf5e <.Lstrlen_done>
8000cf5c:	0505                	add	a0,a0,1

8000cf5e <.Lstrlen_done>:
8000cf5e:	8d0d                	sub	a0,a0,a1
8000cf60:	8082                	ret

Disassembly of section .text.libc.strnlen:

8000cf62 <strnlen>:
8000cf62:	862a                	mv	a2,a0
8000cf64:	852e                	mv	a0,a1
8000cf66:	c9c9                	beqz	a1,8000cff8 <.L528>
8000cf68:	00064783          	lbu	a5,0(a2)
8000cf6c:	c7c9                	beqz	a5,8000cff6 <.L534>
8000cf6e:	00367793          	and	a5,a2,3
8000cf72:	00379693          	sll	a3,a5,0x3
8000cf76:	00f58533          	add	a0,a1,a5
8000cf7a:	ffc67713          	and	a4,a2,-4
8000cf7e:	57fd                	li	a5,-1
8000cf80:	00d797b3          	sll	a5,a5,a3
8000cf84:	4314                	lw	a3,0(a4)
8000cf86:	fff7c793          	not	a5,a5
8000cf8a:	feff05b7          	lui	a1,0xfeff0
8000cf8e:	80808837          	lui	a6,0x80808
8000cf92:	8fd5                	or	a5,a5,a3
8000cf94:	488d                	li	a7,3
8000cf96:	eff58593          	add	a1,a1,-257 # fefefeff <__APB_SRAM_segment_end__+0xaefdeff>
8000cf9a:	08080813          	add	a6,a6,128 # 80808080 <__XPI0_segment_end__+0x8080>

8000cf9e <.L530>:
8000cf9e:	00a8ff63          	bgeu	a7,a0,8000cfbc <.L529>
8000cfa2:	00b786b3          	add	a3,a5,a1
8000cfa6:	fff7c313          	not	t1,a5
8000cfaa:	0066f6b3          	and	a3,a3,t1
8000cfae:	0106f6b3          	and	a3,a3,a6
8000cfb2:	e689                	bnez	a3,8000cfbc <.L529>
8000cfb4:	0711                	add	a4,a4,4
8000cfb6:	1571                	add	a0,a0,-4
8000cfb8:	431c                	lw	a5,0(a4)
8000cfba:	b7d5                	j	8000cf9e <.L530>

8000cfbc <.L529>:
8000cfbc:	0ff7f593          	zext.b	a1,a5
8000cfc0:	c59d                	beqz	a1,8000cfee <.L531>
8000cfc2:	0087d593          	srl	a1,a5,0x8
8000cfc6:	0ff5f593          	zext.b	a1,a1
8000cfca:	4685                	li	a3,1
8000cfcc:	cd89                	beqz	a1,8000cfe6 <.L532>
8000cfce:	0107d593          	srl	a1,a5,0x10
8000cfd2:	0ff5f593          	zext.b	a1,a1
8000cfd6:	4689                	li	a3,2
8000cfd8:	c599                	beqz	a1,8000cfe6 <.L532>
8000cfda:	010005b7          	lui	a1,0x1000
8000cfde:	468d                	li	a3,3
8000cfe0:	00b7e363          	bltu	a5,a1,8000cfe6 <.L532>
8000cfe4:	4691                	li	a3,4

8000cfe6 <.L532>:
8000cfe6:	85aa                	mv	a1,a0
8000cfe8:	00a6f363          	bgeu	a3,a0,8000cfee <.L531>
8000cfec:	85b6                	mv	a1,a3

8000cfee <.L531>:
8000cfee:	8f11                	sub	a4,a4,a2
8000cff0:	00b70533          	add	a0,a4,a1
8000cff4:	8082                	ret

8000cff6 <.L534>:
8000cff6:	4501                	li	a0,0

8000cff8 <.L528>:
8000cff8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

8000cffa <__SEGGER_RTL_stream_write>:
8000cffa:	5154                	lw	a3,36(a0)
8000cffc:	87ae                	mv	a5,a1
8000cffe:	853e                	mv	a0,a5
8000d000:	4585                	li	a1,1
8000d002:	bcefb06f          	j	800083d0 <fwrite>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

8000d006 <__SEGGER_RTL_putc>:
8000d006:	4918                	lw	a4,16(a0)
8000d008:	1101                	add	sp,sp,-32
8000d00a:	0ff5f593          	zext.b	a1,a1
8000d00e:	cc22                	sw	s0,24(sp)
8000d010:	ce06                	sw	ra,28(sp)
8000d012:	00b107a3          	sb	a1,15(sp)
8000d016:	411c                	lw	a5,0(a0)
8000d018:	842a                	mv	s0,a0
8000d01a:	cb05                	beqz	a4,8000d04a <.L24>
8000d01c:	4154                	lw	a3,4(a0)
8000d01e:	00d7ff63          	bgeu	a5,a3,8000d03c <.L26>
8000d022:	495c                	lw	a5,20(a0)
8000d024:	00178693          	add	a3,a5,1 # 800001 <_flash_size+0x1>
8000d028:	973e                	add	a4,a4,a5
8000d02a:	c954                	sw	a3,20(a0)
8000d02c:	00b70023          	sb	a1,0(a4)
8000d030:	4958                	lw	a4,20(a0)
8000d032:	4d1c                	lw	a5,24(a0)
8000d034:	00f71463          	bne	a4,a5,8000d03c <.L26>
8000d038:	b3efc0ef          	jal	80009376 <__SEGGER_RTL_prin_flush>

8000d03c <.L26>:
8000d03c:	401c                	lw	a5,0(s0)
8000d03e:	40f2                	lw	ra,28(sp)
8000d040:	0785                	add	a5,a5,1
8000d042:	c01c                	sw	a5,0(s0)
8000d044:	4462                	lw	s0,24(sp)
8000d046:	6105                	add	sp,sp,32
8000d048:	8082                	ret

8000d04a <.L24>:
8000d04a:	4558                	lw	a4,12(a0)
8000d04c:	c305                	beqz	a4,8000d06c <.L28>
8000d04e:	4154                	lw	a3,4(a0)
8000d050:	00178613          	add	a2,a5,1
8000d054:	00d61463          	bne	a2,a3,8000d05c <.L29>
8000d058:	000107a3          	sb	zero,15(sp)

8000d05c <.L29>:
8000d05c:	fed7f0e3          	bgeu	a5,a3,8000d03c <.L26>
8000d060:	00f14683          	lbu	a3,15(sp)
8000d064:	973e                	add	a4,a4,a5
8000d066:	00d70023          	sb	a3,0(a4)
8000d06a:	bfc9                	j	8000d03c <.L26>

8000d06c <.L28>:
8000d06c:	4518                	lw	a4,8(a0)
8000d06e:	c305                	beqz	a4,8000d08e <.L30>
8000d070:	4154                	lw	a3,4(a0)
8000d072:	00178613          	add	a2,a5,1
8000d076:	00d61463          	bne	a2,a3,8000d07e <.L31>
8000d07a:	000107a3          	sb	zero,15(sp)

8000d07e <.L31>:
8000d07e:	fad7ffe3          	bgeu	a5,a3,8000d03c <.L26>
8000d082:	078a                	sll	a5,a5,0x2
8000d084:	973e                	add	a4,a4,a5
8000d086:	00f14783          	lbu	a5,15(sp)
8000d08a:	c31c                	sw	a5,0(a4)
8000d08c:	bf45                	j	8000d03c <.L26>

8000d08e <.L30>:
8000d08e:	5118                	lw	a4,32(a0)
8000d090:	d755                	beqz	a4,8000d03c <.L26>
8000d092:	4154                	lw	a3,4(a0)
8000d094:	fad7f4e3          	bgeu	a5,a3,8000d03c <.L26>
8000d098:	4605                	li	a2,1
8000d09a:	00f10593          	add	a1,sp,15
8000d09e:	9702                	jalr	a4
8000d0a0:	bf71                	j	8000d03c <.L26>

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

8000d0a2 <__SEGGER_RTL_print_padding>:
8000d0a2:	1141                	add	sp,sp,-16
8000d0a4:	c422                	sw	s0,8(sp)
8000d0a6:	c226                	sw	s1,4(sp)
8000d0a8:	c04a                	sw	s2,0(sp)
8000d0aa:	c606                	sw	ra,12(sp)
8000d0ac:	84aa                	mv	s1,a0
8000d0ae:	892e                	mv	s2,a1
8000d0b0:	8432                	mv	s0,a2

8000d0b2 <.L37>:
8000d0b2:	147d                	add	s0,s0,-1
8000d0b4:	00045863          	bgez	s0,8000d0c4 <.L38>
8000d0b8:	40b2                	lw	ra,12(sp)
8000d0ba:	4422                	lw	s0,8(sp)
8000d0bc:	4492                	lw	s1,4(sp)
8000d0be:	4902                	lw	s2,0(sp)
8000d0c0:	0141                	add	sp,sp,16
8000d0c2:	8082                	ret

8000d0c4 <.L38>:
8000d0c4:	85ca                	mv	a1,s2
8000d0c6:	8526                	mv	a0,s1
8000d0c8:	3f3d                	jal	8000d006 <__SEGGER_RTL_putc>
8000d0ca:	b7e5                	j	8000d0b2 <.L37>

Disassembly of section .text.libc.sprintf:

8000d0cc <sprintf>:
8000d0cc:	7159                	add	sp,sp,-112
8000d0ce:	c4a2                	sw	s0,72(sp)
8000d0d0:	d2be                	sw	a5,100(sp)
8000d0d2:	842a                	mv	s0,a0
8000d0d4:	08bc                	add	a5,sp,88
8000d0d6:	0868                	add	a0,sp,28
8000d0d8:	c686                	sw	ra,76(sp)
8000d0da:	c62e                	sw	a1,12(sp)
8000d0dc:	ccb2                	sw	a2,88(sp)
8000d0de:	ceb6                	sw	a3,92(sp)
8000d0e0:	d0ba                	sw	a4,96(sp)
8000d0e2:	d4c2                	sw	a6,104(sp)
8000d0e4:	d6c6                	sw	a7,108(sp)
8000d0e6:	cc3e                	sw	a5,24(sp)
8000d0e8:	aecfc0ef          	jal	800093d4 <__SEGGER_RTL_init_prin>
8000d0ec:	4662                	lw	a2,24(sp)
8000d0ee:	45b2                	lw	a1,12(sp)
8000d0f0:	800007b7          	lui	a5,0x80000
8000d0f4:	17fd                	add	a5,a5,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
8000d0f6:	0868                	add	a0,sp,28
8000d0f8:	d422                	sw	s0,40(sp)
8000d0fa:	d03e                	sw	a5,32(sp)
8000d0fc:	2041                	jal	8000d17c <__SEGGER_RTL_vfprintf>
8000d0fe:	40b6                	lw	ra,76(sp)
8000d100:	4426                	lw	s0,72(sp)
8000d102:	6165                	add	sp,sp,112
8000d104:	8082                	ret

Disassembly of section .text.libc.vfprintf_l:

8000d106 <vfprintf_l>:
8000d106:	711d                	add	sp,sp,-96
8000d108:	ce86                	sw	ra,92(sp)
8000d10a:	cca2                	sw	s0,88(sp)
8000d10c:	caa6                	sw	s1,84(sp)
8000d10e:	1080                	add	s0,sp,96
8000d110:	c8ca                	sw	s2,80(sp)
8000d112:	c6ce                	sw	s3,76(sp)
8000d114:	8932                	mv	s2,a2
8000d116:	fad42623          	sw	a3,-84(s0)
8000d11a:	89aa                	mv	s3,a0
8000d11c:	fab42423          	sw	a1,-88(s0)
8000d120:	cb6fc0ef          	jal	800095d6 <__SEGGER_RTL_X_file_bufsize>
8000d124:	fa842583          	lw	a1,-88(s0)
8000d128:	00f50793          	add	a5,a0,15
8000d12c:	9bc1                	and	a5,a5,-16
8000d12e:	40f10133          	sub	sp,sp,a5
8000d132:	84aa                	mv	s1,a0
8000d134:	fb840513          	add	a0,s0,-72
8000d138:	a7afc0ef          	jal	800093b2 <__SEGGER_RTL_init_prin_l>
8000d13c:	800007b7          	lui	a5,0x80000
8000d140:	fac42603          	lw	a2,-84(s0)
8000d144:	17fd                	add	a5,a5,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
8000d146:	faf42e23          	sw	a5,-68(s0)
8000d14a:	8000d7b7          	lui	a5,0x8000d
8000d14e:	ffa78793          	add	a5,a5,-6 # 8000cffa <__SEGGER_RTL_stream_write>
8000d152:	85ca                	mv	a1,s2
8000d154:	fb840513          	add	a0,s0,-72
8000d158:	fc242423          	sw	sp,-56(s0)
8000d15c:	fc942823          	sw	s1,-48(s0)
8000d160:	fd342e23          	sw	s3,-36(s0)
8000d164:	fcf42c23          	sw	a5,-40(s0)
8000d168:	2811                	jal	8000d17c <__SEGGER_RTL_vfprintf>
8000d16a:	fa040113          	add	sp,s0,-96
8000d16e:	40f6                	lw	ra,92(sp)
8000d170:	4466                	lw	s0,88(sp)
8000d172:	44d6                	lw	s1,84(sp)
8000d174:	4946                	lw	s2,80(sp)
8000d176:	49b6                	lw	s3,76(sp)
8000d178:	6125                	add	sp,sp,96
8000d17a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

8000d17c <__SEGGER_RTL_vfprintf>:
8000d17c:	7175                	add	sp,sp,-144
8000d17e:	81820793          	add	a5,tp,-2024 # fffff818 <__APB_SRAM_segment_end__+0xbf0d818>
8000d182:	c83e                	sw	a5,16(sp)
8000d184:	dece                	sw	s3,124(sp)
8000d186:	dad6                	sw	s5,116(sp)
8000d188:	ceee                	sw	s11,92(sp)
8000d18a:	c706                	sw	ra,140(sp)
8000d18c:	c522                	sw	s0,136(sp)
8000d18e:	c326                	sw	s1,132(sp)
8000d190:	c14a                	sw	s2,128(sp)
8000d192:	dcd2                	sw	s4,120(sp)
8000d194:	d8da                	sw	s6,112(sp)
8000d196:	d6de                	sw	s7,108(sp)
8000d198:	d4e2                	sw	s8,104(sp)
8000d19a:	d2e6                	sw	s9,100(sp)
8000d19c:	d0ea                	sw	s10,96(sp)
8000d19e:	85c20793          	add	a5,tp,-1956 # fffff85c <__APB_SRAM_segment_end__+0xbf0d85c>
8000d1a2:	00020db7          	lui	s11,0x20
8000d1a6:	89aa                	mv	s3,a0
8000d1a8:	8ab2                	mv	s5,a2
8000d1aa:	00052023          	sw	zero,0(a0)
8000d1ae:	ca3e                	sw	a5,20(sp)
8000d1b0:	021d8d93          	add	s11,s11,33 # 20021 <__XPI0_segment_used_size__+0x133e9>

8000d1b4 <.L2>:
8000d1b4:	00158a13          	add	s4,a1,1 # 1000001 <_extram_size+0x1>
8000d1b8:	0005c583          	lbu	a1,0(a1)
8000d1bc:	e19d                	bnez	a1,8000d1e2 <.L229>
8000d1be:	00c9a783          	lw	a5,12(s3)
8000d1c2:	cb91                	beqz	a5,8000d1d6 <.L230>
8000d1c4:	0009a703          	lw	a4,0(s3)
8000d1c8:	0049a683          	lw	a3,4(s3)
8000d1cc:	00d77563          	bgeu	a4,a3,8000d1d6 <.L230>
8000d1d0:	97ba                	add	a5,a5,a4
8000d1d2:	00078023          	sb	zero,0(a5)

8000d1d6 <.L230>:
8000d1d6:	854e                	mv	a0,s3
8000d1d8:	99efc0ef          	jal	80009376 <__SEGGER_RTL_prin_flush>
8000d1dc:	0009a503          	lw	a0,0(s3)
8000d1e0:	a2f9                	j	8000d3ae <.L338>

8000d1e2 <.L229>:
8000d1e2:	02500793          	li	a5,37
8000d1e6:	00f58563          	beq	a1,a5,8000d1f0 <.L231>

8000d1ea <.L362>:
8000d1ea:	854e                	mv	a0,s3
8000d1ec:	3d29                	jal	8000d006 <__SEGGER_RTL_putc>
8000d1ee:	aab9                	j	8000d34c <.L4>

8000d1f0 <.L231>:
8000d1f0:	4b81                	li	s7,0
8000d1f2:	03000613          	li	a2,48
8000d1f6:	05e00593          	li	a1,94
8000d1fa:	6505                	lui	a0,0x1
8000d1fc:	487d                	li	a6,31
8000d1fe:	48c1                	li	a7,16
8000d200:	6321                	lui	t1,0x8
8000d202:	a03d                	j	8000d230 <.L3>

8000d204 <.L5>:
8000d204:	04b78f63          	beq	a5,a1,8000d262 <.L15>

8000d208 <.L232>:
8000d208:	8a36                	mv	s4,a3
8000d20a:	4b01                	li	s6,0
8000d20c:	46a5                	li	a3,9
8000d20e:	45a9                	li	a1,10

8000d210 <.L18>:
8000d210:	fd078713          	add	a4,a5,-48
8000d214:	0ff77613          	zext.b	a2,a4
8000d218:	08c6e363          	bltu	a3,a2,8000d29e <.L20>
8000d21c:	02bb0b33          	mul	s6,s6,a1
8000d220:	0a05                	add	s4,s4,1
8000d222:	fffa4783          	lbu	a5,-1(s4)
8000d226:	9b3a                	add	s6,s6,a4
8000d228:	b7e5                	j	8000d210 <.L18>

8000d22a <.L14>:
8000d22a:	040beb93          	or	s7,s7,64

8000d22e <.L16>:
8000d22e:	8a36                	mv	s4,a3

8000d230 <.L3>:
8000d230:	000a4783          	lbu	a5,0(s4)
8000d234:	001a0693          	add	a3,s4,1
8000d238:	fcf666e3          	bltu	a2,a5,8000d204 <.L5>
8000d23c:	fcf876e3          	bgeu	a6,a5,8000d208 <.L232>
8000d240:	fe078713          	add	a4,a5,-32
8000d244:	0ff77713          	zext.b	a4,a4
8000d248:	02e8e963          	bltu	a7,a4,8000d27a <.L7>
8000d24c:	4442                	lw	s0,16(sp)
8000d24e:	070a                	sll	a4,a4,0x2
8000d250:	9722                	add	a4,a4,s0
8000d252:	4318                	lw	a4,0(a4)
8000d254:	8702                	jr	a4

8000d256 <.L13>:
8000d256:	080beb93          	or	s7,s7,128
8000d25a:	bfd1                	j	8000d22e <.L16>

8000d25c <.L12>:
8000d25c:	006bebb3          	or	s7,s7,t1
8000d260:	b7f9                	j	8000d22e <.L16>

8000d262 <.L15>:
8000d262:	00abebb3          	or	s7,s7,a0
8000d266:	b7e1                	j	8000d22e <.L16>

8000d268 <.L11>:
8000d268:	020beb93          	or	s7,s7,32
8000d26c:	b7c9                	j	8000d22e <.L16>

8000d26e <.L10>:
8000d26e:	010beb93          	or	s7,s7,16
8000d272:	bf75                	j	8000d22e <.L16>

8000d274 <.L8>:
8000d274:	200beb93          	or	s7,s7,512
8000d278:	bf5d                	j	8000d22e <.L16>

8000d27a <.L7>:
8000d27a:	02a00713          	li	a4,42
8000d27e:	f8e795e3          	bne	a5,a4,8000d208 <.L232>
8000d282:	000aab03          	lw	s6,0(s5)
8000d286:	004a8713          	add	a4,s5,4
8000d28a:	000b5663          	bgez	s6,8000d296 <.L19>
8000d28e:	41600b33          	neg	s6,s6
8000d292:	010beb93          	or	s7,s7,16

8000d296 <.L19>:
8000d296:	0006c783          	lbu	a5,0(a3) # 800000 <_flash_size>
8000d29a:	0a09                	add	s4,s4,2
8000d29c:	8aba                	mv	s5,a4

8000d29e <.L20>:
8000d29e:	000b5363          	bgez	s6,8000d2a4 <.L22>
8000d2a2:	4b01                	li	s6,0

8000d2a4 <.L22>:
8000d2a4:	02e00713          	li	a4,46
8000d2a8:	4481                	li	s1,0
8000d2aa:	04e79263          	bne	a5,a4,8000d2ee <.L23>
8000d2ae:	000a4783          	lbu	a5,0(s4)
8000d2b2:	02a00713          	li	a4,42
8000d2b6:	02e78263          	beq	a5,a4,8000d2da <.L24>
8000d2ba:	0a05                	add	s4,s4,1
8000d2bc:	46a5                	li	a3,9
8000d2be:	45a9                	li	a1,10

8000d2c0 <.L25>:
8000d2c0:	fd078713          	add	a4,a5,-48
8000d2c4:	0ff77613          	zext.b	a2,a4
8000d2c8:	00c6ef63          	bltu	a3,a2,8000d2e6 <.L26>
8000d2cc:	02b484b3          	mul	s1,s1,a1
8000d2d0:	0a05                	add	s4,s4,1
8000d2d2:	fffa4783          	lbu	a5,-1(s4)
8000d2d6:	94ba                	add	s1,s1,a4
8000d2d8:	b7e5                	j	8000d2c0 <.L25>

8000d2da <.L24>:
8000d2da:	000aa483          	lw	s1,0(s5)
8000d2de:	001a4783          	lbu	a5,1(s4)
8000d2e2:	0a91                	add	s5,s5,4
8000d2e4:	0a09                	add	s4,s4,2

8000d2e6 <.L26>:
8000d2e6:	0004c463          	bltz	s1,8000d2ee <.L23>
8000d2ea:	100beb93          	or	s7,s7,256

8000d2ee <.L23>:
8000d2ee:	06c00713          	li	a4,108
8000d2f2:	06e78263          	beq	a5,a4,8000d356 <.L28>
8000d2f6:	02f76c63          	bltu	a4,a5,8000d32e <.L29>
8000d2fa:	06800713          	li	a4,104
8000d2fe:	06e78a63          	beq	a5,a4,8000d372 <.L30>
8000d302:	06a00713          	li	a4,106
8000d306:	04e78563          	beq	a5,a4,8000d350 <.L31>

8000d30a <.L32>:
8000d30a:	05700713          	li	a4,87
8000d30e:	2cf760e3          	bltu	a4,a5,8000ddce <.L38>
8000d312:	04500713          	li	a4,69
8000d316:	2ce78763          	beq	a5,a4,8000d5e4 <.L39>
8000d31a:	06f76763          	bltu	a4,a5,8000d388 <.L40>
8000d31e:	c7c1                	beqz	a5,8000d3a6 <.L41>
8000d320:	02500713          	li	a4,37
8000d324:	02500593          	li	a1,37
8000d328:	ece781e3          	beq	a5,a4,8000d1ea <.L362>
8000d32c:	a005                	j	8000d34c <.L4>

8000d32e <.L29>:
8000d32e:	07400713          	li	a4,116
8000d332:	00e78663          	beq	a5,a4,8000d33e <.L346>
8000d336:	07a00713          	li	a4,122
8000d33a:	28e796e3          	bne	a5,a4,8000ddc6 <.L34>

8000d33e <.L346>:
8000d33e:	000a4783          	lbu	a5,0(s4)
8000d342:	0a05                	add	s4,s4,1

8000d344 <.L35>:
8000d344:	07800713          	li	a4,120
8000d348:	fcf771e3          	bgeu	a4,a5,8000d30a <.L32>

8000d34c <.L4>:
8000d34c:	85d2                	mv	a1,s4
8000d34e:	b59d                	j	8000d1b4 <.L2>

8000d350 <.L31>:
8000d350:	002beb93          	or	s7,s7,2
8000d354:	b7ed                	j	8000d33e <.L346>

8000d356 <.L28>:
8000d356:	000a4783          	lbu	a5,0(s4)
8000d35a:	00e79863          	bne	a5,a4,8000d36a <.L36>
8000d35e:	002beb93          	or	s7,s7,2

8000d362 <.L347>:
8000d362:	001a4783          	lbu	a5,1(s4)
8000d366:	0a09                	add	s4,s4,2
8000d368:	bff1                	j	8000d344 <.L35>

8000d36a <.L36>:
8000d36a:	0a05                	add	s4,s4,1
8000d36c:	001beb93          	or	s7,s7,1
8000d370:	bfd1                	j	8000d344 <.L35>

8000d372 <.L30>:
8000d372:	000a4783          	lbu	a5,0(s4)
8000d376:	00e79563          	bne	a5,a4,8000d380 <.L37>
8000d37a:	008beb93          	or	s7,s7,8
8000d37e:	b7d5                	j	8000d362 <.L347>

8000d380 <.L37>:
8000d380:	0a05                	add	s4,s4,1
8000d382:	004beb93          	or	s7,s7,4
8000d386:	bf7d                	j	8000d344 <.L35>

8000d388 <.L40>:
8000d388:	04600713          	li	a4,70
8000d38c:	2ce78663          	beq	a5,a4,8000d658 <.L57>
8000d390:	04700713          	li	a4,71
8000d394:	fae79ce3          	bne	a5,a4,8000d34c <.L4>
8000d398:	6789                	lui	a5,0x2
8000d39a:	00fbebb3          	or	s7,s7,a5

8000d39e <.L52>:
8000d39e:	6905                	lui	s2,0x1
8000d3a0:	c0090913          	add	s2,s2,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000d3a4:	a4c1                	j	8000d664 <.L353>

8000d3a6 <.L41>:
8000d3a6:	854e                	mv	a0,s3
8000d3a8:	fcffb0ef          	jal	80009376 <__SEGGER_RTL_prin_flush>
8000d3ac:	557d                	li	a0,-1

8000d3ae <.L338>:
8000d3ae:	40ba                	lw	ra,140(sp)
8000d3b0:	442a                	lw	s0,136(sp)
8000d3b2:	449a                	lw	s1,132(sp)
8000d3b4:	490a                	lw	s2,128(sp)
8000d3b6:	59f6                	lw	s3,124(sp)
8000d3b8:	5a66                	lw	s4,120(sp)
8000d3ba:	5ad6                	lw	s5,116(sp)
8000d3bc:	5b46                	lw	s6,112(sp)
8000d3be:	5bb6                	lw	s7,108(sp)
8000d3c0:	5c26                	lw	s8,104(sp)
8000d3c2:	5c96                	lw	s9,100(sp)
8000d3c4:	5d06                	lw	s10,96(sp)
8000d3c6:	4df6                	lw	s11,92(sp)
8000d3c8:	6149                	add	sp,sp,144
8000d3ca:	8082                	ret

8000d3cc <.L55>:
8000d3cc:	000aa483          	lw	s1,0(s5)
8000d3d0:	1b7d                	add	s6,s6,-1
8000d3d2:	865a                	mv	a2,s6
8000d3d4:	85de                	mv	a1,s7
8000d3d6:	854e                	mv	a0,s3
8000d3d8:	fc1fb0ef          	jal	80009398 <__SEGGER_RTL_pre_padding>
8000d3dc:	004a8413          	add	s0,s5,4
8000d3e0:	0ff4f593          	zext.b	a1,s1
8000d3e4:	854e                	mv	a0,s3
8000d3e6:	3105                	jal	8000d006 <__SEGGER_RTL_putc>
8000d3e8:	8aa2                	mv	s5,s0

8000d3ea <.L371>:
8000d3ea:	010bfb93          	and	s7,s7,16
8000d3ee:	f40b8fe3          	beqz	s7,8000d34c <.L4>
8000d3f2:	865a                	mv	a2,s6
8000d3f4:	02000593          	li	a1,32
8000d3f8:	854e                	mv	a0,s3
8000d3fa:	3165                	jal	8000d0a2 <__SEGGER_RTL_print_padding>
8000d3fc:	bf81                	j	8000d34c <.L4>

8000d3fe <.L50>:
8000d3fe:	008bf693          	and	a3,s7,8
8000d402:	000aa783          	lw	a5,0(s5)
8000d406:	0009a703          	lw	a4,0(s3)
8000d40a:	0a91                	add	s5,s5,4
8000d40c:	c681                	beqz	a3,8000d414 <.L62>
8000d40e:	00e78023          	sb	a4,0(a5) # 2000 <__APB_SRAM_segment_size__>
8000d412:	bf2d                	j	8000d34c <.L4>

8000d414 <.L62>:
8000d414:	002bfb93          	and	s7,s7,2
8000d418:	c398                	sw	a4,0(a5)
8000d41a:	f20b89e3          	beqz	s7,8000d34c <.L4>
8000d41e:	0007a223          	sw	zero,4(a5)
8000d422:	b72d                	j	8000d34c <.L4>

8000d424 <.L47>:
8000d424:	000aa403          	lw	s0,0(s5)
8000d428:	895e                	mv	s2,s7
8000d42a:	0a91                	add	s5,s5,4

8000d42c <.L65>:
8000d42c:	e409                	bnez	s0,8000d436 <.L66>
8000d42e:	80004437          	lui	s0,0x80004
8000d432:	9e840413          	add	s0,s0,-1560 # 800039e8 <.LC0>

8000d436 <.L66>:
8000d436:	dff97b93          	and	s7,s2,-513
8000d43a:	10097913          	and	s2,s2,256
8000d43e:	02090563          	beqz	s2,8000d468 <.L67>
8000d442:	85a6                	mv	a1,s1
8000d444:	8522                	mv	a0,s0
8000d446:	3e31                	jal	8000cf62 <strnlen>

8000d448 <.L348>:
8000d448:	40ab0b33          	sub	s6,s6,a0
8000d44c:	84aa                	mv	s1,a0
8000d44e:	865a                	mv	a2,s6
8000d450:	85de                	mv	a1,s7
8000d452:	854e                	mv	a0,s3
8000d454:	f45fb0ef          	jal	80009398 <__SEGGER_RTL_pre_padding>

8000d458 <.L69>:
8000d458:	d8c9                	beqz	s1,8000d3ea <.L371>
8000d45a:	00044583          	lbu	a1,0(s0)
8000d45e:	854e                	mv	a0,s3
8000d460:	0405                	add	s0,s0,1
8000d462:	3655                	jal	8000d006 <__SEGGER_RTL_putc>
8000d464:	14fd                	add	s1,s1,-1
8000d466:	bfcd                	j	8000d458 <.L69>

8000d468 <.L67>:
8000d468:	8522                	mv	a0,s0
8000d46a:	3c41                	jal	8000cefa <strlen>
8000d46c:	bff1                	j	8000d448 <.L348>

8000d46e <.L48>:
8000d46e:	080bf713          	and	a4,s7,128
8000d472:	000aa403          	lw	s0,0(s5)
8000d476:	004a8693          	add	a3,s5,4
8000d47a:	4581                	li	a1,0
8000d47c:	02300c93          	li	s9,35
8000d480:	e311                	bnez	a4,8000d484 <.L71>
8000d482:	4c81                	li	s9,0

8000d484 <.L71>:
8000d484:	100beb93          	or	s7,s7,256
8000d488:	8ab6                	mv	s5,a3
8000d48a:	44a1                	li	s1,8

8000d48c <.L72>:
8000d48c:	100bf713          	and	a4,s7,256
8000d490:	e311                	bnez	a4,8000d494 <.L203>
8000d492:	4485                	li	s1,1

8000d494 <.L203>:
8000d494:	05800713          	li	a4,88
8000d498:	06e784e3          	beq	a5,a4,8000dd00 <.L204>
8000d49c:	f9c78693          	add	a3,a5,-100
8000d4a0:	4705                	li	a4,1
8000d4a2:	00d71733          	sll	a4,a4,a3
8000d4a6:	01b776b3          	and	a3,a4,s11
8000d4aa:	7e069663          	bnez	a3,8000dc96 <.L205>
8000d4ae:	00c75693          	srl	a3,a4,0xc
8000d4b2:	1016f693          	and	a3,a3,257
8000d4b6:	040695e3          	bnez	a3,8000dd00 <.L204>
8000d4ba:	06f00713          	li	a4,111
8000d4be:	4c01                	li	s8,0
8000d4c0:	04e79fe3          	bne	a5,a4,8000dd1e <.L206>

8000d4c4 <.L207>:
8000d4c4:	00b467b3          	or	a5,s0,a1
8000d4c8:	04078be3          	beqz	a5,8000dd1e <.L206>
8000d4cc:	183c                	add	a5,sp,56
8000d4ce:	01878733          	add	a4,a5,s8
8000d4d2:	00747793          	and	a5,s0,7
8000d4d6:	03078793          	add	a5,a5,48
8000d4da:	00f70023          	sb	a5,0(a4)
8000d4de:	800d                	srl	s0,s0,0x3
8000d4e0:	01d59793          	sll	a5,a1,0x1d
8000d4e4:	0c05                	add	s8,s8,1
8000d4e6:	8c5d                	or	s0,s0,a5
8000d4e8:	818d                	srl	a1,a1,0x3
8000d4ea:	bfe9                	j	8000d4c4 <.L207>

8000d4ec <.L56>:
8000d4ec:	6709                	lui	a4,0x2
8000d4ee:	00ebebb3          	or	s7,s7,a4

8000d4f2 <.L44>:
8000d4f2:	080bf713          	and	a4,s7,128
8000d4f6:	4c81                	li	s9,0
8000d4f8:	cb19                	beqz	a4,8000d50e <.L75>
8000d4fa:	6c8d                	lui	s9,0x3
8000d4fc:	07800713          	li	a4,120
8000d500:	058c8c93          	add	s9,s9,88 # 3058 <__ILM_segment_used_end__+0x402>
8000d504:	00e79563          	bne	a5,a4,8000d50e <.L75>
8000d508:	6c8d                	lui	s9,0x3
8000d50a:	078c8c93          	add	s9,s9,120 # 3078 <__ILM_segment_used_end__+0x422>

8000d50e <.L75>:
8000d50e:	100bf713          	and	a4,s7,256

8000d512 <.L365>:
8000d512:	c319                	beqz	a4,8000d518 <.L74>
8000d514:	dffbfb93          	and	s7,s7,-513

8000d518 <.L74>:
8000d518:	011b9613          	sll	a2,s7,0x11
8000d51c:	002bf713          	and	a4,s7,2
8000d520:	004bf693          	and	a3,s7,4
8000d524:	08065563          	bgez	a2,8000d5ae <.L76>
8000d528:	cf31                	beqz	a4,8000d584 <.L77>
8000d52a:	007a8713          	add	a4,s5,7
8000d52e:	9b61                	and	a4,a4,-8
8000d530:	4300                	lw	s0,0(a4)
8000d532:	434c                	lw	a1,4(a4)
8000d534:	00870a93          	add	s5,a4,8 # 2008 <__APB_SRAM_segment_size__+0x8>

8000d538 <.L78>:
8000d538:	cea1                	beqz	a3,8000d590 <.L79>
8000d53a:	0442                	sll	s0,s0,0x10
8000d53c:	8441                	sra	s0,s0,0x10

8000d53e <.L351>:
8000d53e:	41f45593          	sra	a1,s0,0x1f

8000d542 <.L80>:
8000d542:	0405dd63          	bgez	a1,8000d59c <.L82>
8000d546:	00803733          	snez	a4,s0
8000d54a:	40b005b3          	neg	a1,a1
8000d54e:	8d99                	sub	a1,a1,a4
8000d550:	40800433          	neg	s0,s0
8000d554:	02d00c93          	li	s9,45

8000d558 <.L84>:
8000d558:	100bf713          	and	a4,s7,256
8000d55c:	db05                	beqz	a4,8000d48c <.L72>
8000d55e:	dffbfb93          	and	s7,s7,-513
8000d562:	b72d                	j	8000d48c <.L72>

8000d564 <.L49>:
8000d564:	080bf713          	and	a4,s7,128
8000d568:	03000c93          	li	s9,48
8000d56c:	f34d                	bnez	a4,8000d50e <.L75>
8000d56e:	4c81                	li	s9,0
8000d570:	bf79                	j	8000d50e <.L75>

8000d572 <.L46>:
8000d572:	100bf713          	and	a4,s7,256
8000d576:	4c81                	li	s9,0
8000d578:	bf69                	j	8000d512 <.L365>

8000d57a <.L51>:
8000d57a:	6711                	lui	a4,0x4
8000d57c:	00ebebb3          	or	s7,s7,a4
8000d580:	4c81                	li	s9,0
8000d582:	bf59                	j	8000d518 <.L74>

8000d584 <.L77>:
8000d584:	000aa403          	lw	s0,0(s5)
8000d588:	0a91                	add	s5,s5,4
8000d58a:	41f45593          	sra	a1,s0,0x1f
8000d58e:	b76d                	j	8000d538 <.L78>

8000d590 <.L79>:
8000d590:	008bf713          	and	a4,s7,8
8000d594:	d75d                	beqz	a4,8000d542 <.L80>
8000d596:	0462                	sll	s0,s0,0x18
8000d598:	8461                	sra	s0,s0,0x18
8000d59a:	b755                	j	8000d53e <.L351>

8000d59c <.L82>:
8000d59c:	020bf713          	and	a4,s7,32
8000d5a0:	ef1d                	bnez	a4,8000d5de <.L239>
8000d5a2:	040bf713          	and	a4,s7,64
8000d5a6:	db4d                	beqz	a4,8000d558 <.L84>
8000d5a8:	02000c93          	li	s9,32
8000d5ac:	b775                	j	8000d558 <.L84>

8000d5ae <.L76>:
8000d5ae:	cf09                	beqz	a4,8000d5c8 <.L85>
8000d5b0:	007a8713          	add	a4,s5,7
8000d5b4:	9b61                	and	a4,a4,-8
8000d5b6:	4300                	lw	s0,0(a4)
8000d5b8:	434c                	lw	a1,4(a4)
8000d5ba:	00870a93          	add	s5,a4,8 # 4008 <__HEAPSIZE__+0x8>

8000d5be <.L86>:
8000d5be:	ca91                	beqz	a3,8000d5d2 <.L87>
8000d5c0:	0442                	sll	s0,s0,0x10
8000d5c2:	8041                	srl	s0,s0,0x10

8000d5c4 <.L352>:
8000d5c4:	4581                	li	a1,0
8000d5c6:	bf49                	j	8000d558 <.L84>

8000d5c8 <.L85>:
8000d5c8:	000aa403          	lw	s0,0(s5)
8000d5cc:	4581                	li	a1,0
8000d5ce:	0a91                	add	s5,s5,4
8000d5d0:	b7fd                	j	8000d5be <.L86>

8000d5d2 <.L87>:
8000d5d2:	008bf713          	and	a4,s7,8
8000d5d6:	d349                	beqz	a4,8000d558 <.L84>
8000d5d8:	0ff47413          	zext.b	s0,s0
8000d5dc:	b7e5                	j	8000d5c4 <.L352>

8000d5de <.L239>:
8000d5de:	02b00c93          	li	s9,43
8000d5e2:	bf9d                	j	8000d558 <.L84>

8000d5e4 <.L39>:
8000d5e4:	6789                	lui	a5,0x2
8000d5e6:	00fbebb3          	or	s7,s7,a5

8000d5ea <.L54>:
8000d5ea:	400be913          	or	s2,s7,1024

8000d5ee <.L91>:
8000d5ee:	00297793          	and	a5,s2,2
8000d5f2:	cfa5                	beqz	a5,8000d66a <.L92>
8000d5f4:	000aa783          	lw	a5,0(s5)
8000d5f8:	1008                	add	a0,sp,32
8000d5fa:	004a8413          	add	s0,s5,4
8000d5fe:	4398                	lw	a4,0(a5)
8000d600:	8aa2                	mv	s5,s0
8000d602:	d03a                	sw	a4,32(sp)
8000d604:	43d8                	lw	a4,4(a5)
8000d606:	d23a                	sw	a4,36(sp)
8000d608:	4798                	lw	a4,8(a5)
8000d60a:	d43a                	sw	a4,40(sp)
8000d60c:	47dc                	lw	a5,12(a5)
8000d60e:	d63e                	sw	a5,44(sp)
8000d610:	eeaff0ef          	jal	8000ccfa <__trunctfsf2>
8000d614:	8baa                	mv	s7,a0

8000d616 <.L93>:
8000d616:	10097793          	and	a5,s2,256
8000d61a:	c3bd                	beqz	a5,8000d680 <.L240>
8000d61c:	e889                	bnez	s1,8000d62e <.L94>
8000d61e:	6785                	lui	a5,0x1
8000d620:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000d624:	00f974b3          	and	s1,s2,a5
8000d628:	8c9d                	sub	s1,s1,a5
8000d62a:	0014b493          	seqz	s1,s1

8000d62e <.L94>:
8000d62e:	855e                	mv	a0,s7
8000d630:	b58fb0ef          	jal	80008988 <__SEGGER_RTL_float32_isinf>
8000d634:	c921                	beqz	a0,8000d684 <.L95>

8000d636 <.L117>:
8000d636:	6409                	lui	s0,0x2
8000d638:	00000593          	li	a1,0
8000d63c:	855e                	mv	a0,s7
8000d63e:	00897433          	and	s0,s2,s0
8000d642:	f8bfa0ef          	jal	800085cc <__ltsf2>
8000d646:	3e055f63          	bgez	a0,8000da44 <.L341>
8000d64a:	3e040863          	beqz	s0,8000da3a <.L244>
8000d64e:	80004437          	lui	s0,0x80004
8000d652:	9f040413          	add	s0,s0,-1552 # 800039f0 <.LC1>
8000d656:	a099                	j	8000d69c <.L122>

8000d658 <.L57>:
8000d658:	6789                	lui	a5,0x2
8000d65a:	00fbebb3          	or	s7,s7,a5

8000d65e <.L53>:
8000d65e:	6905                	lui	s2,0x1
8000d660:	80090913          	add	s2,s2,-2048 # 800 <.L133+0x14>

8000d664 <.L353>:
8000d664:	012be933          	or	s2,s7,s2
8000d668:	b759                	j	8000d5ee <.L91>

8000d66a <.L92>:
8000d66a:	007a8793          	add	a5,s5,7
8000d66e:	9be1                	and	a5,a5,-8
8000d670:	4388                	lw	a0,0(a5)
8000d672:	43cc                	lw	a1,4(a5)
8000d674:	00878a93          	add	s5,a5,8 # 2008 <__APB_SRAM_segment_size__+0x8>
8000d678:	9fefb0ef          	jal	80008876 <__truncdfsf2>
8000d67c:	8baa                	mv	s7,a0
8000d67e:	bf61                	j	8000d616 <.L93>

8000d680 <.L240>:
8000d680:	4499                	li	s1,6
8000d682:	b775                	j	8000d62e <.L94>

8000d684 <.L95>:
8000d684:	855e                	mv	a0,s7
8000d686:	af0fb0ef          	jal	80008976 <__SEGGER_RTL_float32_isnan>
8000d68a:	cd19                	beqz	a0,8000d6a8 <.L101>
8000d68c:	01291793          	sll	a5,s2,0x12
8000d690:	0007d963          	bgez	a5,8000d6a2 <.L243>
8000d694:	80004437          	lui	s0,0x80004
8000d698:	a1040413          	add	s0,s0,-1520 # 80003a10 <.LC5>

8000d69c <.L122>:
8000d69c:	eff97913          	and	s2,s2,-257
8000d6a0:	b371                	j	8000d42c <.L65>

8000d6a2 <.L243>:
8000d6a2:	81420413          	add	s0,tp,-2028 # fffff814 <__APB_SRAM_segment_end__+0xbf0d814>
8000d6a6:	bfdd                	j	8000d69c <.L122>

8000d6a8 <.L101>:
8000d6a8:	855e                	mv	a0,s7
8000d6aa:	aecfb0ef          	jal	80008996 <__SEGGER_RTL_float32_isnormal>
8000d6ae:	e119                	bnez	a0,8000d6b4 <.L103>
8000d6b0:	00000b93          	li	s7,0

8000d6b4 <.L103>:
8000d6b4:	855e                	mv	a0,s7
8000d6b6:	845e                	mv	s0,s7
8000d6b8:	e66ff0ef          	jal	8000cd1e <__SEGGER_RTL_float32_signbit>
8000d6bc:	c519                	beqz	a0,8000d6ca <.L104>
8000d6be:	80000437          	lui	s0,0x80000
8000d6c2:	06096913          	or	s2,s2,96
8000d6c6:	01744433          	xor	s0,s0,s7

8000d6ca <.L104>:
8000d6ca:	184c                	add	a1,sp,52
8000d6cc:	8522                	mv	a0,s0
8000d6ce:	e98ff0ef          	jal	8000cd66 <frexpf>
8000d6d2:	5752                	lw	a4,52(sp)
8000d6d4:	478d                	li	a5,3
8000d6d6:	00000593          	li	a1,0
8000d6da:	02e787b3          	mul	a5,a5,a4
8000d6de:	4729                	li	a4,10
8000d6e0:	8522                	mv	a0,s0
8000d6e2:	8ba2                	mv	s7,s0
8000d6e4:	02e7c7b3          	div	a5,a5,a4
8000d6e8:	da3e                	sw	a5,52(sp)
8000d6ea:	d3cff0ef          	jal	8000cc26 <__eqsf2>
8000d6ee:	24051063          	bnez	a0,8000d92e <.L105>

8000d6f2 <.L111>:
8000d6f2:	6785                	lui	a5,0x1
8000d6f4:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000d6f8:	00f97c33          	and	s8,s2,a5
8000d6fc:	40000713          	li	a4,1024
8000d700:	5552                	lw	a0,52(sp)
8000d702:	24ec1d63          	bne	s8,a4,8000d95c <.L340>

8000d706 <.L106>:
8000d706:	02600793          	li	a5,38
8000d70a:	30f51f63          	bne	a0,a5,8000da28 <.L113>
8000d70e:	9f422583          	lw	a1,-1548(tp) # fffff9f4 <__APB_SRAM_segment_end__+0xbf0d9f4>
8000d712:	855e                	mv	a0,s7
8000d714:	a4eff0ef          	jal	8000c962 <__divsf3>

8000d718 <.L354>:
8000d718:	00000593          	li	a1,0
8000d71c:	8baa                	mv	s7,a0
8000d71e:	842a                	mv	s0,a0
8000d720:	d06ff0ef          	jal	8000cc26 <__eqsf2>
8000d724:	cd39                	beqz	a0,8000d782 <.L116>
8000d726:	855e                	mv	a0,s7
8000d728:	a60fb0ef          	jal	80008988 <__SEGGER_RTL_float32_isinf>
8000d72c:	f00515e3          	bnez	a0,8000d636 <.L117>
8000d730:	57d2                	lw	a5,52(sp)
8000d732:	4701                	li	a4,0

8000d734 <.L118>:
8000d734:	c63e                	sw	a5,12(sp)
8000d736:	00178d13          	add	s10,a5,1
8000d73a:	9ec22583          	lw	a1,-1556(tp) # fffff9ec <__APB_SRAM_segment_end__+0xbf0d9ec>
8000d73e:	855e                	mv	a0,s7
8000d740:	cc3a                	sw	a4,24(sp)
8000d742:	f2dfa0ef          	jal	8000866e <__gesf2>
8000d746:	47b2                	lw	a5,12(sp)
8000d748:	4762                	lw	a4,24(sp)
8000d74a:	30055d63          	bgez	a0,8000da64 <.L124>
8000d74e:	c319                	beqz	a4,8000d754 <.L125>
8000d750:	845e                	mv	s0,s7
8000d752:	da3e                	sw	a5,52(sp)

8000d754 <.L125>:
8000d754:	9e822703          	lw	a4,-1560(tp) # fffff9e8 <__APB_SRAM_segment_end__+0xbf0d9e8>
8000d758:	5d52                	lw	s10,52(sp)
8000d75a:	9ec22c83          	lw	s9,-1556(tp) # fffff9ec <__APB_SRAM_segment_end__+0xbf0d9ec>
8000d75e:	87a2                	mv	a5,s0
8000d760:	4681                	li	a3,0
8000d762:	c63a                	sw	a4,12(sp)

8000d764 <.L126>:
8000d764:	45b2                	lw	a1,12(sp)
8000d766:	853e                	mv	a0,a5
8000d768:	ce36                	sw	a3,28(sp)
8000d76a:	cc3e                	sw	a5,24(sp)
8000d76c:	e61fa0ef          	jal	800085cc <__ltsf2>
8000d770:	47e2                	lw	a5,24(sp)
8000d772:	46f2                	lw	a3,28(sp)
8000d774:	fffd0b93          	add	s7,s10,-1
8000d778:	2e054f63          	bltz	a0,8000da76 <.L127>
8000d77c:	c299                	beqz	a3,8000d782 <.L116>
8000d77e:	843e                	mv	s0,a5
8000d780:	da6a                	sw	s10,52(sp)

8000d782 <.L116>:
8000d782:	c499                	beqz	s1,8000d790 <.L129>
8000d784:	6785                	lui	a5,0x1
8000d786:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000d78a:	00fc1363          	bne	s8,a5,8000d790 <.L129>
8000d78e:	14fd                	add	s1,s1,-1

8000d790 <.L129>:
8000d790:	40900533          	neg	a0,s1
8000d794:	b8dfb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000d798:	55fd                	li	a1,-1
8000d79a:	d88ff0ef          	jal	8000cd22 <ldexpf>
8000d79e:	85a2                	mv	a1,s0
8000d7a0:	c7ffa0ef          	jal	8000841e <__addsf3>
8000d7a4:	9ec22583          	lw	a1,-1556(tp) # fffff9ec <__APB_SRAM_segment_end__+0xbf0d9ec>
8000d7a8:	8baa                	mv	s7,a0
8000d7aa:	842a                	mv	s0,a0
8000d7ac:	ec3fa0ef          	jal	8000866e <__gesf2>
8000d7b0:	00054b63          	bltz	a0,8000d7c6 <.L130>
8000d7b4:	57d2                	lw	a5,52(sp)
8000d7b6:	9ec22583          	lw	a1,-1556(tp) # fffff9ec <__APB_SRAM_segment_end__+0xbf0d9ec>
8000d7ba:	855e                	mv	a0,s7
8000d7bc:	0785                	add	a5,a5,1
8000d7be:	da3e                	sw	a5,52(sp)
8000d7c0:	9a2ff0ef          	jal	8000c962 <__divsf3>
8000d7c4:	842a                	mv	s0,a0

8000d7c6 <.L130>:
8000d7c6:	c622                	sw	s0,12(sp)
8000d7c8:	2a049f63          	bnez	s1,8000da86 <.L132>

8000d7cc <.L135>:
8000d7cc:	4481                	li	s1,0

8000d7ce <.L133>:
8000d7ce:	00548793          	add	a5,s1,5
8000d7d2:	7c7d                	lui	s8,0xfffff
8000d7d4:	40fb0b33          	sub	s6,s6,a5
8000d7d8:	08097793          	and	a5,s2,128
8000d7dc:	7ffc0c13          	add	s8,s8,2047 # fffff7ff <__APB_SRAM_segment_end__+0xbf0d7ff>
8000d7e0:	8fc5                	or	a5,a5,s1
8000d7e2:	01897c33          	and	s8,s2,s8
8000d7e6:	c391                	beqz	a5,8000d7ea <.L139>
8000d7e8:	1b7d                	add	s6,s6,-1

8000d7ea <.L139>:
8000d7ea:	01391793          	sll	a5,s2,0x13
8000d7ee:	4d05                	li	s10,1
8000d7f0:	0207dc63          	bgez	a5,8000d828 <.L140>
8000d7f4:	5bd2                	lw	s7,52(sp)
8000d7f6:	470d                	li	a4,3
8000d7f8:	02ebe733          	rem	a4,s7,a4
8000d7fc:	c31d                	beqz	a4,8000d822 <.L141>
8000d7fe:	0709                	add	a4,a4,2
8000d800:	56b5                	li	a3,-19
8000d802:	40e6d733          	sra	a4,a3,a4
8000d806:	8b05                	and	a4,a4,1
8000d808:	2c070c63          	beqz	a4,8000dae0 <.L142>
8000d80c:	9ec22583          	lw	a1,-1556(tp) # fffff9ec <__APB_SRAM_segment_end__+0xbf0d9ec>
8000d810:	4532                	lw	a0,12(sp)
8000d812:	1b7d                	add	s6,s6,-1
8000d814:	4d09                	li	s10,2
8000d816:	f8dfe0ef          	jal	8000c7a2 <__mulsf3>
8000d81a:	fffb8793          	add	a5,s7,-1
8000d81e:	842a                	mv	s0,a0
8000d820:	da3e                	sw	a5,52(sp)

8000d822 <.L141>:
8000d822:	0004d363          	bgez	s1,8000d828 <.L140>
8000d826:	4481                	li	s1,0

8000d828 <.L140>:
8000d828:	06097913          	and	s2,s2,96
8000d82c:	00090363          	beqz	s2,8000d832 <.L144>
8000d830:	1b7d                	add	s6,s6,-1

8000d832 <.L144>:
8000d832:	5552                	lw	a0,52(sp)
8000d834:	a5dfb0ef          	jal	80009290 <abs>
8000d838:	06300793          	li	a5,99
8000d83c:	00a7d363          	bge	a5,a0,8000d842 <.L145>
8000d840:	1b7d                	add	s6,s6,-1

8000d842 <.L145>:
8000d842:	8522                	mv	a0,s0
8000d844:	c0eff0ef          	jal	8000cc52 <__fixunssfdi>
8000d848:	8bae                	mv	s7,a1
8000d84a:	8caa                	mv	s9,a0
8000d84c:	f81fa0ef          	jal	800087cc <__floatundisf>
8000d850:	85aa                	mv	a1,a0
8000d852:	8522                	mv	a0,s0
8000d854:	bc3fa0ef          	jal	80008416 <__subsf3>
8000d858:	842a                	mv	s0,a0

8000d85a <.L146>:
8000d85a:	895a                	mv	s2,s6
8000d85c:	000b5363          	bgez	s6,8000d862 <.L165>
8000d860:	4901                	li	s2,0

8000d862 <.L165>:
8000d862:	210c7793          	and	a5,s8,528
8000d866:	e399                	bnez	a5,8000d86c <.L167>

8000d868 <.L166>:
8000d868:	30091363          	bnez	s2,8000db6e <.L168>

8000d86c <.L167>:
8000d86c:	020c7713          	and	a4,s8,32
8000d870:	040c7793          	and	a5,s8,64
8000d874:	30070463          	beqz	a4,8000db7c <.L169>
8000d878:	02b00593          	li	a1,43
8000d87c:	c399                	beqz	a5,8000d882 <.L358>
8000d87e:	02d00593          	li	a1,45

8000d882 <.L358>:
8000d882:	854e                	mv	a0,s3
8000d884:	f82ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>

8000d888 <.L171>:
8000d888:	010c7793          	and	a5,s8,16
8000d88c:	e399                	bnez	a5,8000d892 <.L173>

8000d88e <.L172>:
8000d88e:	2e091c63          	bnez	s2,8000db86 <.L174>

8000d892 <.L173>:
8000d892:	80003b37          	lui	s6,0x80003
8000d896:	098b0b13          	add	s6,s6,152 # 80003098 <__SEGGER_RTL_ipow10>

8000d89a <.L178>:
8000d89a:	1d7d                	add	s10,s10,-1
8000d89c:	003d1793          	sll	a5,s10,0x3
8000d8a0:	97da                	add	a5,a5,s6
8000d8a2:	4398                	lw	a4,0(a5)
8000d8a4:	43dc                	lw	a5,4(a5)
8000d8a6:	03000593          	li	a1,48

8000d8aa <.L175>:
8000d8aa:	00fbe663          	bltu	s7,a5,8000d8b6 <.L258>
8000d8ae:	2f779363          	bne	a5,s7,8000db94 <.L176>
8000d8b2:	2eecf163          	bgeu	s9,a4,8000db94 <.L176>

8000d8b6 <.L258>:
8000d8b6:	854e                	mv	a0,s3
8000d8b8:	f4eff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000d8bc:	fc0d1fe3          	bnez	s10,8000d89a <.L178>
8000d8c0:	6b85                	lui	s7,0x1
8000d8c2:	800b8b93          	add	s7,s7,-2048 # 800 <.L133+0x14>
8000d8c6:	017c7bb3          	and	s7,s8,s7
8000d8ca:	2e0b9963          	bnez	s7,8000dbbc <.L179>

8000d8ce <.L183>:
8000d8ce:	080c7793          	and	a5,s8,128
8000d8d2:	8fc5                	or	a5,a5,s1
8000d8d4:	c3a1                	beqz	a5,8000d914 <.L181>
8000d8d6:	02e00593          	li	a1,46
8000d8da:	854e                	mv	a0,s3
8000d8dc:	f2aff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000d8e0:	47c1                	li	a5,16
8000d8e2:	8ca6                	mv	s9,s1
8000d8e4:	2e97d063          	bge	a5,s1,8000dbc4 <.L186>
8000d8e8:	4cc1                	li	s9,16

8000d8ea <.L187>:
8000d8ea:	419484b3          	sub	s1,s1,s9
8000d8ee:	8566                	mv	a0,s9
8000d8f0:	000b8563          	beqz	s7,8000d8fa <.L359>
8000d8f4:	5552                	lw	a0,52(sp)
8000d8f6:	40ac8533          	sub	a0,s9,a0

8000d8fa <.L359>:
8000d8fa:	a27fb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000d8fe:	85a2                	mv	a1,s0
8000d900:	ea3fe0ef          	jal	8000c7a2 <__mulsf3>
8000d904:	b4eff0ef          	jal	8000cc52 <__fixunssfdi>
8000d908:	8baa                	mv	s7,a0
8000d90a:	842e                	mv	s0,a1

8000d90c <.L193>:
8000d90c:	2c0c9063          	bnez	s9,8000dbcc <.L194>

8000d910 <.L195>:
8000d910:	2e049b63          	bnez	s1,8000dc06 <.L196>

8000d914 <.L181>:
8000d914:	400c7793          	and	a5,s8,1024
8000d918:	2e079e63          	bnez	a5,8000dc14 <.L184>

8000d91c <.L201>:
8000d91c:	a20908e3          	beqz	s2,8000d34c <.L4>
8000d920:	197d                	add	s2,s2,-1
8000d922:	02000593          	li	a1,32
8000d926:	aeb1                	j	8000dc82 <.L360>

8000d928 <.L108>:
8000d928:	57d2                	lw	a5,52(sp)
8000d92a:	0785                	add	a5,a5,1
8000d92c:	da3e                	sw	a5,52(sp)

8000d92e <.L105>:
8000d92e:	5552                	lw	a0,52(sp)
8000d930:	0505                	add	a0,a0,1 # 1001 <__fw_size__+0x1>
8000d932:	9effb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000d936:	85aa                	mv	a1,a0
8000d938:	855e                	mv	a0,s7
8000d93a:	d03fa0ef          	jal	8000863c <__gtsf2>
8000d93e:	fea045e3          	bgtz	a0,8000d928 <.L108>

8000d942 <.L109>:
8000d942:	5552                	lw	a0,52(sp)
8000d944:	9ddfb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000d948:	85aa                	mv	a1,a0
8000d94a:	855e                	mv	a0,s7
8000d94c:	c81fa0ef          	jal	800085cc <__ltsf2>
8000d950:	da0551e3          	bgez	a0,8000d6f2 <.L111>
8000d954:	57d2                	lw	a5,52(sp)
8000d956:	17fd                	add	a5,a5,-1
8000d958:	da3e                	sw	a5,52(sp)
8000d95a:	b7e5                	j	8000d942 <.L109>

8000d95c <.L340>:
8000d95c:	00fc1763          	bne	s8,a5,8000d96a <.L112>
8000d960:	da9553e3          	bge	a0,s1,8000d706 <.L106>
8000d964:	57f1                	li	a5,-4
8000d966:	0cf54163          	blt	a0,a5,8000da28 <.L113>

8000d96a <.L112>:
8000d96a:	08097793          	and	a5,s2,128
8000d96e:	c63e                	sw	a5,12(sp)
8000d970:	40097793          	and	a5,s2,1024
8000d974:	c789                	beqz	a5,8000d97e <.L147>
8000d976:	47b9                	li	a5,14
8000d978:	18a7d063          	bge	a5,a0,8000daf8 <.L148>

8000d97c <.L153>:
8000d97c:	4481                	li	s1,0

8000d97e <.L147>:
8000d97e:	57d2                	lw	a5,52(sp)
8000d980:	40900533          	neg	a0,s1
8000d984:	bff97c13          	and	s8,s2,-1025
8000d988:	ff178713          	add	a4,a5,-15
8000d98c:	00e55463          	bge	a0,a4,8000d994 <.L154>
8000d990:	ff078513          	add	a0,a5,-16

8000d994 <.L154>:
8000d994:	98dfb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000d998:	55fd                	li	a1,-1
8000d99a:	b88ff0ef          	jal	8000cd22 <ldexpf>
8000d99e:	85aa                	mv	a1,a0
8000d9a0:	855e                	mv	a0,s7
8000d9a2:	a7dfa0ef          	jal	8000841e <__addsf3>
8000d9a6:	8d2a                	mv	s10,a0
8000d9a8:	842a                	mv	s0,a0
8000d9aa:	5552                	lw	a0,52(sp)
8000d9ac:	0505                	add	a0,a0,1
8000d9ae:	973fb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000d9b2:	85ea                	mv	a1,s10
8000d9b4:	c53fa0ef          	jal	80008606 <__lesf2>
8000d9b8:	00a04563          	bgtz	a0,8000d9c2 <.L156>
8000d9bc:	57d2                	lw	a5,52(sp)
8000d9be:	0785                	add	a5,a5,1
8000d9c0:	da3e                	sw	a5,52(sp)

8000d9c2 <.L156>:
8000d9c2:	57d2                	lw	a5,52(sp)
8000d9c4:	1807cf63          	bltz	a5,8000db62 <.L158>
8000d9c8:	4541                	li	a0,16
8000d9ca:	16f55e63          	bge	a0,a5,8000db46 <.L159>
8000d9ce:	ff078713          	add	a4,a5,-16
8000d9d2:	8d1d                	sub	a0,a0,a5
8000d9d4:	da3a                	sw	a4,52(sp)
8000d9d6:	94bfb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000d9da:	85ea                	mv	a1,s10
8000d9dc:	dc7fe0ef          	jal	8000c7a2 <__mulsf3>
8000d9e0:	a72ff0ef          	jal	8000cc52 <__fixunssfdi>
8000d9e4:	8caa                	mv	s9,a0
8000d9e6:	8bae                	mv	s7,a1
8000d9e8:	00000413          	li	s0,0

8000d9ec <.L160>:
8000d9ec:	800037b7          	lui	a5,0x80003
8000d9f0:	09878793          	add	a5,a5,152 # 80003098 <__SEGGER_RTL_ipow10>
8000d9f4:	4d05                	li	s10,1

8000d9f6 <.L161>:
8000d9f6:	47d8                	lw	a4,12(a5)
8000d9f8:	07a1                	add	a5,a5,8
8000d9fa:	00ebe763          	bltu	s7,a4,8000da08 <.L257>
8000d9fe:	17771663          	bne	a4,s7,8000db6a <.L162>
8000da02:	4398                	lw	a4,0(a5)
8000da04:	16ecf363          	bgeu	s9,a4,8000db6a <.L162>

8000da08 <.L257>:
8000da08:	5752                	lw	a4,52(sp)
8000da0a:	009d07b3          	add	a5,s10,s1
8000da0e:	97ba                	add	a5,a5,a4
8000da10:	40fb0b33          	sub	s6,s6,a5
8000da14:	47b2                	lw	a5,12(sp)
8000da16:	8fc5                	or	a5,a5,s1
8000da18:	c391                	beqz	a5,8000da1c <.L164>
8000da1a:	1b7d                	add	s6,s6,-1

8000da1c <.L164>:
8000da1c:	06097793          	and	a5,s2,96
8000da20:	e2078de3          	beqz	a5,8000d85a <.L146>
8000da24:	1b7d                	add	s6,s6,-1
8000da26:	bd15                	j	8000d85a <.L146>

8000da28 <.L113>:
8000da28:	40a00533          	neg	a0,a0
8000da2c:	8f5fb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000da30:	85aa                	mv	a1,a0
8000da32:	855e                	mv	a0,s7
8000da34:	d6ffe0ef          	jal	8000c7a2 <__mulsf3>
8000da38:	b1c5                	j	8000d718 <.L354>

8000da3a <.L244>:
8000da3a:	80004437          	lui	s0,0x80004
8000da3e:	9f840413          	add	s0,s0,-1544 # 800039f8 <.LC2>
8000da42:	b9a9                	j	8000d69c <.L122>

8000da44 <.L341>:
8000da44:	c819                	beqz	s0,8000da5a <.L245>
8000da46:	80004437          	lui	s0,0x80004
8000da4a:	a0040413          	add	s0,s0,-1536 # 80003a00 <.LC3>

8000da4e <.L123>:
8000da4e:	02097793          	and	a5,s2,32
8000da52:	c40795e3          	bnez	a5,8000d69c <.L122>
8000da56:	0405                	add	s0,s0,1
8000da58:	b191                	j	8000d69c <.L122>

8000da5a <.L245>:
8000da5a:	80004437          	lui	s0,0x80004
8000da5e:	a0840413          	add	s0,s0,-1528 # 80003a08 <.LC4>
8000da62:	b7f5                	j	8000da4e <.L123>

8000da64 <.L124>:
8000da64:	9ec22583          	lw	a1,-1556(tp) # fffff9ec <__APB_SRAM_segment_end__+0xbf0d9ec>
8000da68:	855e                	mv	a0,s7
8000da6a:	ef9fe0ef          	jal	8000c962 <__divsf3>
8000da6e:	8baa                	mv	s7,a0
8000da70:	87ea                	mv	a5,s10
8000da72:	4705                	li	a4,1
8000da74:	b1c1                	j	8000d734 <.L118>

8000da76 <.L127>:
8000da76:	853e                	mv	a0,a5
8000da78:	85e6                	mv	a1,s9
8000da7a:	d29fe0ef          	jal	8000c7a2 <__mulsf3>
8000da7e:	87aa                	mv	a5,a0
8000da80:	8d5e                	mv	s10,s7
8000da82:	4685                	li	a3,1
8000da84:	b1c5                	j	8000d764 <.L126>

8000da86 <.L132>:
8000da86:	6785                	lui	a5,0x1
8000da88:	88078793          	add	a5,a5,-1920 # 880 <.L157+0x5a>
8000da8c:	00f977b3          	and	a5,s2,a5
8000da90:	80078793          	add	a5,a5,-2048
8000da94:	d2079de3          	bnez	a5,8000d7ce <.L133>
8000da98:	47c1                	li	a5,16
8000da9a:	0097d363          	bge	a5,s1,8000daa0 <.L134>
8000da9e:	44c1                	li	s1,16

8000daa0 <.L134>:
8000daa0:	8526                	mv	a0,s1
8000daa2:	87ffb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000daa6:	85a2                	mv	a1,s0
8000daa8:	cfbfe0ef          	jal	8000c7a2 <__mulsf3>
8000daac:	9a6ff0ef          	jal	8000cc52 <__fixunssfdi>
8000dab0:	00a5e7b3          	or	a5,a1,a0
8000dab4:	8c2a                	mv	s8,a0
8000dab6:	8d2e                	mv	s10,a1
8000dab8:	d0078ae3          	beqz	a5,8000d7cc <.L135>

8000dabc <.L357>:
8000dabc:	4629                	li	a2,10
8000dabe:	4681                	li	a3,0
8000dac0:	b94fb0ef          	jal	80008e54 <__umoddi3>
8000dac4:	8d4d                	or	a0,a0,a1
8000dac6:	d00514e3          	bnez	a0,8000d7ce <.L133>
8000daca:	8562                	mv	a0,s8
8000dacc:	85ea                	mv	a1,s10
8000dace:	4629                	li	a2,10
8000dad0:	4681                	li	a3,0
8000dad2:	f63fa0ef          	jal	80008a34 <__udivdi3>
8000dad6:	14fd                	add	s1,s1,-1
8000dad8:	8c2a                	mv	s8,a0
8000dada:	8d2e                	mv	s10,a1
8000dadc:	f0e5                	bnez	s1,8000dabc <.L357>
8000dade:	b1fd                	j	8000d7cc <.L135>

8000dae0 <.L142>:
8000dae0:	9f022583          	lw	a1,-1552(tp) # fffff9f0 <__APB_SRAM_segment_end__+0xbf0d9f0>
8000dae4:	4532                	lw	a0,12(sp)
8000dae6:	1b79                	add	s6,s6,-2
8000dae8:	4d0d                	li	s10,3
8000daea:	cb9fe0ef          	jal	8000c7a2 <__mulsf3>
8000daee:	ffeb8793          	add	a5,s7,-2
8000daf2:	842a                	mv	s0,a0
8000daf4:	da3e                	sw	a5,52(sp)
8000daf6:	b335                	j	8000d822 <.L141>

8000daf8 <.L148>:
8000daf8:	0505                	add	a0,a0,1
8000dafa:	8c89                	sub	s1,s1,a0
8000dafc:	47c1                	li	a5,16
8000dafe:	0097d363          	bge	a5,s1,8000db04 <.L149>
8000db02:	44c1                	li	s1,16

8000db04 <.L149>:
8000db04:	08097793          	and	a5,s2,128
8000db08:	e6079be3          	bnez	a5,8000d97e <.L147>
8000db0c:	9e422c03          	lw	s8,-1564(tp) # fffff9e4 <__APB_SRAM_segment_end__+0xbf0d9e4>
8000db10:	9ec22403          	lw	s0,-1556(tp) # fffff9ec <__APB_SRAM_segment_end__+0xbf0d9ec>

8000db14 <.L150>:
8000db14:	e60484e3          	beqz	s1,8000d97c <.L153>
8000db18:	8526                	mv	a0,s1
8000db1a:	807fb0ef          	jal	80009320 <__SEGGER_RTL_pow10f>
8000db1e:	85aa                	mv	a1,a0
8000db20:	855e                	mv	a0,s7
8000db22:	c81fe0ef          	jal	8000c7a2 <__mulsf3>
8000db26:	85e2                	mv	a1,s8
8000db28:	8f7fa0ef          	jal	8000841e <__addsf3>
8000db2c:	e7dfa0ef          	jal	800089a8 <floorf>
8000db30:	85a2                	mv	a1,s0
8000db32:	a60ff0ef          	jal	8000cd92 <fmodf>
8000db36:	00000593          	li	a1,0
8000db3a:	8ecff0ef          	jal	8000cc26 <__eqsf2>
8000db3e:	e40510e3          	bnez	a0,8000d97e <.L147>
8000db42:	14fd                	add	s1,s1,-1
8000db44:	bfc1                	j	8000db14 <.L150>

8000db46 <.L159>:
8000db46:	856a                	mv	a0,s10
8000db48:	da02                	sw	zero,52(sp)
8000db4a:	908ff0ef          	jal	8000cc52 <__fixunssfdi>
8000db4e:	8bae                	mv	s7,a1
8000db50:	8caa                	mv	s9,a0
8000db52:	c7bfa0ef          	jal	800087cc <__floatundisf>
8000db56:	85aa                	mv	a1,a0
8000db58:	856a                	mv	a0,s10
8000db5a:	8bdfa0ef          	jal	80008416 <__subsf3>
8000db5e:	842a                	mv	s0,a0
8000db60:	b571                	j	8000d9ec <.L160>

8000db62 <.L158>:
8000db62:	da02                	sw	zero,52(sp)
8000db64:	4c81                	li	s9,0
8000db66:	4b81                	li	s7,0
8000db68:	b551                	j	8000d9ec <.L160>

8000db6a <.L162>:
8000db6a:	0d05                	add	s10,s10,1
8000db6c:	b569                	j	8000d9f6 <.L161>

8000db6e <.L168>:
8000db6e:	02000593          	li	a1,32
8000db72:	854e                	mv	a0,s3
8000db74:	197d                	add	s2,s2,-1
8000db76:	c90ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000db7a:	b1fd                	j	8000d868 <.L166>

8000db7c <.L169>:
8000db7c:	d00786e3          	beqz	a5,8000d888 <.L171>
8000db80:	02000593          	li	a1,32
8000db84:	b9fd                	j	8000d882 <.L358>

8000db86 <.L174>:
8000db86:	03000593          	li	a1,48
8000db8a:	854e                	mv	a0,s3
8000db8c:	197d                	add	s2,s2,-1
8000db8e:	c78ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000db92:	b9f5                	j	8000d88e <.L172>

8000db94 <.L176>:
8000db94:	40ec86b3          	sub	a3,s9,a4
8000db98:	00dcb633          	sltu	a2,s9,a3
8000db9c:	0585                	add	a1,a1,1
8000db9e:	40fb8bb3          	sub	s7,s7,a5
8000dba2:	0ff5f593          	zext.b	a1,a1
8000dba6:	8cb6                	mv	s9,a3
8000dba8:	40cb8bb3          	sub	s7,s7,a2
8000dbac:	b9fd                	j	8000d8aa <.L175>

8000dbae <.L182>:
8000dbae:	17fd                	add	a5,a5,-1
8000dbb0:	03000593          	li	a1,48
8000dbb4:	854e                	mv	a0,s3
8000dbb6:	da3e                	sw	a5,52(sp)
8000dbb8:	c4eff0ef          	jal	8000d006 <__SEGGER_RTL_putc>

8000dbbc <.L179>:
8000dbbc:	57d2                	lw	a5,52(sp)
8000dbbe:	fef048e3          	bgtz	a5,8000dbae <.L182>
8000dbc2:	b331                	j	8000d8ce <.L183>

8000dbc4 <.L186>:
8000dbc4:	d204d3e3          	bgez	s1,8000d8ea <.L187>
8000dbc8:	4c81                	li	s9,0
8000dbca:	b305                	j	8000d8ea <.L187>

8000dbcc <.L194>:
8000dbcc:	1cfd                	add	s9,s9,-1
8000dbce:	003c9793          	sll	a5,s9,0x3
8000dbd2:	97da                	add	a5,a5,s6
8000dbd4:	4398                	lw	a4,0(a5)
8000dbd6:	43dc                	lw	a5,4(a5)
8000dbd8:	03000593          	li	a1,48

8000dbdc <.L190>:
8000dbdc:	00f46663          	bltu	s0,a5,8000dbe8 <.L259>
8000dbe0:	00879863          	bne	a5,s0,8000dbf0 <.L191>
8000dbe4:	00ebf663          	bgeu	s7,a4,8000dbf0 <.L191>

8000dbe8 <.L259>:
8000dbe8:	854e                	mv	a0,s3
8000dbea:	c1cff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dbee:	bb39                	j	8000d90c <.L193>

8000dbf0 <.L191>:
8000dbf0:	40eb86b3          	sub	a3,s7,a4
8000dbf4:	00dbb633          	sltu	a2,s7,a3
8000dbf8:	0585                	add	a1,a1,1
8000dbfa:	8c1d                	sub	s0,s0,a5
8000dbfc:	0ff5f593          	zext.b	a1,a1
8000dc00:	8bb6                	mv	s7,a3
8000dc02:	8c11                	sub	s0,s0,a2
8000dc04:	bfe1                	j	8000dbdc <.L190>

8000dc06 <.L196>:
8000dc06:	03000593          	li	a1,48
8000dc0a:	854e                	mv	a0,s3
8000dc0c:	14fd                	add	s1,s1,-1
8000dc0e:	bf8ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dc12:	b9fd                	j	8000d910 <.L195>

8000dc14 <.L184>:
8000dc14:	012c1793          	sll	a5,s8,0x12
8000dc18:	06500593          	li	a1,101
8000dc1c:	0007d463          	bgez	a5,8000dc24 <.L197>
8000dc20:	04500593          	li	a1,69

8000dc24 <.L197>:
8000dc24:	854e                	mv	a0,s3
8000dc26:	be0ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dc2a:	57d2                	lw	a5,52(sp)
8000dc2c:	0407df63          	bgez	a5,8000dc8a <.L198>
8000dc30:	02d00593          	li	a1,45
8000dc34:	854e                	mv	a0,s3
8000dc36:	bd0ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dc3a:	57d2                	lw	a5,52(sp)
8000dc3c:	40f007b3          	neg	a5,a5
8000dc40:	da3e                	sw	a5,52(sp)

8000dc42 <.L199>:
8000dc42:	55d2                	lw	a1,52(sp)
8000dc44:	06300793          	li	a5,99
8000dc48:	00b7df63          	bge	a5,a1,8000dc66 <.L200>
8000dc4c:	06400413          	li	s0,100
8000dc50:	0285c5b3          	div	a1,a1,s0
8000dc54:	854e                	mv	a0,s3
8000dc56:	03058593          	add	a1,a1,48
8000dc5a:	bacff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dc5e:	57d2                	lw	a5,52(sp)
8000dc60:	0287e7b3          	rem	a5,a5,s0
8000dc64:	da3e                	sw	a5,52(sp)

8000dc66 <.L200>:
8000dc66:	55d2                	lw	a1,52(sp)
8000dc68:	4429                	li	s0,10
8000dc6a:	854e                	mv	a0,s3
8000dc6c:	0285c5b3          	div	a1,a1,s0
8000dc70:	03058593          	add	a1,a1,48
8000dc74:	b92ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dc78:	55d2                	lw	a1,52(sp)
8000dc7a:	0285e5b3          	rem	a1,a1,s0
8000dc7e:	03058593          	add	a1,a1,48

8000dc82 <.L360>:
8000dc82:	854e                	mv	a0,s3
8000dc84:	b82ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dc88:	b951                	j	8000d91c <.L201>

8000dc8a <.L198>:
8000dc8a:	02b00593          	li	a1,43
8000dc8e:	854e                	mv	a0,s3
8000dc90:	b76ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dc94:	b77d                	j	8000dc42 <.L199>

8000dc96 <.L205>:
8000dc96:	6d21                	lui	s10,0x8
8000dc98:	892e                	mv	s2,a1
8000dc9a:	4c01                	li	s8,0
8000dc9c:	01abfd33          	and	s10,s7,s10
8000dca0:	470d                	li	a4,3
8000dca2:	02c00813          	li	a6,44

8000dca6 <.L208>:
8000dca6:	012467b3          	or	a5,s0,s2
8000dcaa:	cbb5                	beqz	a5,8000dd1e <.L206>
8000dcac:	000d0d63          	beqz	s10,8000dcc6 <.L214>
8000dcb0:	003c7793          	and	a5,s8,3
8000dcb4:	00e79963          	bne	a5,a4,8000dcc6 <.L214>
8000dcb8:	030c0793          	add	a5,s8,48
8000dcbc:	1018                	add	a4,sp,32
8000dcbe:	97ba                	add	a5,a5,a4
8000dcc0:	ff078423          	sb	a6,-24(a5)
8000dcc4:	0c05                	add	s8,s8,1

8000dcc6 <.L214>:
8000dcc6:	1018                	add	a4,sp,32
8000dcc8:	030c0793          	add	a5,s8,48
8000dccc:	97ba                	add	a5,a5,a4
8000dcce:	4629                	li	a2,10
8000dcd0:	4681                	li	a3,0
8000dcd2:	8522                	mv	a0,s0
8000dcd4:	85ca                	mv	a1,s2
8000dcd6:	c63e                	sw	a5,12(sp)
8000dcd8:	97cfb0ef          	jal	80008e54 <__umoddi3>
8000dcdc:	47b2                	lw	a5,12(sp)
8000dcde:	03050513          	add	a0,a0,48
8000dce2:	85ca                	mv	a1,s2
8000dce4:	fea78423          	sb	a0,-24(a5)
8000dce8:	4629                	li	a2,10
8000dcea:	8522                	mv	a0,s0
8000dcec:	4681                	li	a3,0
8000dcee:	d47fa0ef          	jal	80008a34 <__udivdi3>
8000dcf2:	0c05                	add	s8,s8,1
8000dcf4:	842a                	mv	s0,a0
8000dcf6:	892e                	mv	s2,a1
8000dcf8:	02c00813          	li	a6,44
8000dcfc:	470d                	li	a4,3
8000dcfe:	b765                	j	8000dca6 <.L208>

8000dd00 <.L204>:
8000dd00:	6709                	lui	a4,0x2
8000dd02:	800046b7          	lui	a3,0x80004
8000dd06:	80004637          	lui	a2,0x80004
8000dd0a:	4c01                	li	s8,0
8000dd0c:	00ebf733          	and	a4,s7,a4
8000dd10:	9c868693          	add	a3,a3,-1592 # 800039c8 <__SEGGER_RTL_hex_lc>
8000dd14:	9d860613          	add	a2,a2,-1576 # 800039d8 <__SEGGER_RTL_hex_uc>

8000dd18 <.L209>:
8000dd18:	00b467b3          	or	a5,s0,a1
8000dd1c:	e38d                	bnez	a5,8000dd3e <.L212>

8000dd1e <.L206>:
8000dd1e:	418484b3          	sub	s1,s1,s8
8000dd22:	0004d363          	bgez	s1,8000dd28 <.L216>
8000dd26:	4481                	li	s1,0

8000dd28 <.L216>:
8000dd28:	409b0b33          	sub	s6,s6,s1
8000dd2c:	0ff00793          	li	a5,255
8000dd30:	418b0b33          	sub	s6,s6,s8
8000dd34:	0397f863          	bgeu	a5,s9,8000dd64 <.L217>
8000dd38:	1b7d                	add	s6,s6,-1

8000dd3a <.L218>:
8000dd3a:	1b7d                	add	s6,s6,-1
8000dd3c:	a035                	j	8000dd68 <.L219>

8000dd3e <.L212>:
8000dd3e:	00f47793          	and	a5,s0,15
8000dd42:	cf19                	beqz	a4,8000dd60 <.L210>
8000dd44:	97b2                	add	a5,a5,a2

8000dd46 <.L361>:
8000dd46:	0007c783          	lbu	a5,0(a5)
8000dd4a:	1828                	add	a0,sp,56
8000dd4c:	9562                	add	a0,a0,s8
8000dd4e:	00f50023          	sb	a5,0(a0)
8000dd52:	8011                	srl	s0,s0,0x4
8000dd54:	01c59793          	sll	a5,a1,0x1c
8000dd58:	0c05                	add	s8,s8,1
8000dd5a:	8c5d                	or	s0,s0,a5
8000dd5c:	8191                	srl	a1,a1,0x4
8000dd5e:	bf6d                	j	8000dd18 <.L209>

8000dd60 <.L210>:
8000dd60:	97b6                	add	a5,a5,a3
8000dd62:	b7d5                	j	8000dd46 <.L361>

8000dd64 <.L217>:
8000dd64:	fc0c9be3          	bnez	s9,8000dd3a <.L218>

8000dd68 <.L219>:
8000dd68:	200bf793          	and	a5,s7,512
8000dd6c:	e799                	bnez	a5,8000dd7a <.L220>
8000dd6e:	865a                	mv	a2,s6
8000dd70:	85de                	mv	a1,s7
8000dd72:	854e                	mv	a0,s3
8000dd74:	e24fb0ef          	jal	80009398 <__SEGGER_RTL_pre_padding>
8000dd78:	4b01                	li	s6,0

8000dd7a <.L220>:
8000dd7a:	0ff00793          	li	a5,255
8000dd7e:	0197fc63          	bgeu	a5,s9,8000dd96 <.L221>
8000dd82:	03000593          	li	a1,48
8000dd86:	854e                	mv	a0,s3
8000dd88:	a7eff0ef          	jal	8000d006 <__SEGGER_RTL_putc>

8000dd8c <.L222>:
8000dd8c:	85e6                	mv	a1,s9
8000dd8e:	854e                	mv	a0,s3
8000dd90:	a76ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000dd94:	a019                	j	8000dd9a <.L223>

8000dd96 <.L221>:
8000dd96:	fe0c9be3          	bnez	s9,8000dd8c <.L222>

8000dd9a <.L223>:
8000dd9a:	865a                	mv	a2,s6
8000dd9c:	85de                	mv	a1,s7
8000dd9e:	854e                	mv	a0,s3
8000dda0:	df8fb0ef          	jal	80009398 <__SEGGER_RTL_pre_padding>
8000dda4:	8626                	mv	a2,s1
8000dda6:	03000593          	li	a1,48
8000ddaa:	854e                	mv	a0,s3
8000ddac:	af6ff0ef          	jal	8000d0a2 <__SEGGER_RTL_print_padding>

8000ddb0 <.L224>:
8000ddb0:	1c7d                	add	s8,s8,-1
8000ddb2:	e20c4c63          	bltz	s8,8000d3ea <.L371>
8000ddb6:	183c                	add	a5,sp,56
8000ddb8:	97e2                	add	a5,a5,s8
8000ddba:	0007c583          	lbu	a1,0(a5)
8000ddbe:	854e                	mv	a0,s3
8000ddc0:	a46ff0ef          	jal	8000d006 <__SEGGER_RTL_putc>
8000ddc4:	b7f5                	j	8000ddb0 <.L224>

8000ddc6 <.L34>:
8000ddc6:	07800713          	li	a4,120
8000ddca:	d8f76163          	bltu	a4,a5,8000d34c <.L4>

8000ddce <.L38>:
8000ddce:	fa878713          	add	a4,a5,-88
8000ddd2:	0ff77713          	zext.b	a4,a4
8000ddd6:	02000693          	li	a3,32
8000ddda:	d6e6e963          	bltu	a3,a4,8000d34c <.L4>
8000ddde:	46d2                	lw	a3,20(sp)
8000dde0:	070a                	sll	a4,a4,0x2
8000dde2:	9736                	add	a4,a4,a3
8000dde4:	4318                	lw	a4,0(a4)
8000dde6:	8702                	jr	a4

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

8000dde8 <__SEGGER_RTL_ascii_isctype>:
8000dde8:	07f00793          	li	a5,127
8000ddec:	00a7ee63          	bltu	a5,a0,8000de08 <.L3>
8000ddf0:	96420793          	add	a5,tp,-1692 # fffff964 <__APB_SRAM_segment_end__+0xbf0d964>
8000ddf4:	953e                	add	a0,a0,a5
8000ddf6:	3ac20793          	add	a5,tp,940 # 3ac <default_isr_48+0x44>
8000ddfa:	95be                	add	a1,a1,a5
8000ddfc:	00054503          	lbu	a0,0(a0)
8000de00:	0005c783          	lbu	a5,0(a1)
8000de04:	8d7d                	and	a0,a0,a5
8000de06:	8082                	ret

8000de08 <.L3>:
8000de08:	4501                	li	a0,0
8000de0a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

8000de0c <__SEGGER_RTL_ascii_tolower>:
8000de0c:	fbf50713          	add	a4,a0,-65
8000de10:	47e5                	li	a5,25
8000de12:	00e7e463          	bltu	a5,a4,8000de1a <.L7>
8000de16:	02050513          	add	a0,a0,32

8000de1a <.L7>:
8000de1a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

8000de1c <__SEGGER_RTL_ascii_iswctype>:
8000de1c:	07f00793          	li	a5,127
8000de20:	00a7ee63          	bltu	a5,a0,8000de3c <.L10>
8000de24:	96420793          	add	a5,tp,-1692 # fffff964 <__APB_SRAM_segment_end__+0xbf0d964>
8000de28:	953e                	add	a0,a0,a5
8000de2a:	3ac20793          	add	a5,tp,940 # 3ac <default_isr_48+0x44>
8000de2e:	95be                	add	a1,a1,a5
8000de30:	00054503          	lbu	a0,0(a0)
8000de34:	0005c783          	lbu	a5,0(a1)
8000de38:	8d7d                	and	a0,a0,a5
8000de3a:	8082                	ret

8000de3c <.L10>:
8000de3c:	4501                	li	a0,0
8000de3e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

8000de40 <__SEGGER_RTL_ascii_towlower>:
8000de40:	fbf50713          	add	a4,a0,-65
8000de44:	47e5                	li	a5,25
8000de46:	00e7e463          	bltu	a5,a4,8000de4e <.L14>
8000de4a:	02050513          	add	a0,a0,32

8000de4e <.L14>:
8000de4e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

8000de50 <__SEGGER_RTL_ascii_wctomb>:
8000de50:	07f00793          	li	a5,127
8000de54:	00b7e663          	bltu	a5,a1,8000de60 <.L66>
8000de58:	00b50023          	sb	a1,0(a0)
8000de5c:	4505                	li	a0,1
8000de5e:	8082                	ret

8000de60 <.L66>:
8000de60:	5579                	li	a0,-2
8000de62:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

8000de64 <__SEGGER_RTL_current_locale>:
8000de64:	010807b7          	lui	a5,0x1080
8000de68:	3407a503          	lw	a0,832(a5) # 1080340 <__SEGGER_RTL_locale_ptr>
8000de6c:	e509                	bnez	a0,8000de76 <.L155>
8000de6e:	01080537          	lui	a0,0x1080
8000de72:	00050513          	mv	a0,a0

8000de76 <.L155>:
8000de76:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_lzss:

8000fba8 <__SEGGER_init_lzss>:
8000fba8:	4008                	lw	a0,0(s0)
8000fbaa:	404c                	lw	a1,4(s0)
8000fbac:	0421                	add	s0,s0,8
8000fbae:	08000793          	li	a5,128

8000fbb2 <.L__SEGGER_init_lzss_NextByte>:
8000fbb2:	0005c603          	lbu	a2,0(a1)
8000fbb6:	0585                	add	a1,a1,1
8000fbb8:	c631                	beqz	a2,8000fc04 <.L__SEGGER_init_lzss_Done>
8000fbba:	02f66c63          	bltu	a2,a5,8000fbf2 <.L__SEGGER_init_lzss_LoopLiteral>
8000fbbe:	f8060613          	add	a2,a2,-128
8000fbc2:	c231                	beqz	a2,8000fc06 <.L__SEGGER_init_lzss_Error>
8000fbc4:	0005c683          	lbu	a3,0(a1)
8000fbc8:	0585                	add	a1,a1,1
8000fbca:	00f6e963          	bltu	a3,a5,8000fbdc <.L__SEGGER_init_lzss_ShortRun>
8000fbce:	f8068693          	add	a3,a3,-128
8000fbd2:	06a2                	sll	a3,a3,0x8
8000fbd4:	0005c703          	lbu	a4,0(a1)
8000fbd8:	0585                	add	a1,a1,1
8000fbda:	96ba                	add	a3,a3,a4

8000fbdc <.L__SEGGER_init_lzss_ShortRun>:
8000fbdc:	40d50733          	sub	a4,a0,a3

8000fbe0 <.L__SEGGER_init_lzss_LoopShort>:
8000fbe0:	00074683          	lbu	a3,0(a4) # 2000 <__APB_SRAM_segment_size__>
8000fbe4:	00d50023          	sb	a3,0(a0) # 1080000 <__RAL_global_locale>
8000fbe8:	0705                	add	a4,a4,1
8000fbea:	0505                	add	a0,a0,1
8000fbec:	167d                	add	a2,a2,-1
8000fbee:	fa6d                	bnez	a2,8000fbe0 <.L__SEGGER_init_lzss_LoopShort>
8000fbf0:	b7c9                	j	8000fbb2 <.L__SEGGER_init_lzss_NextByte>

8000fbf2 <.L__SEGGER_init_lzss_LoopLiteral>:
8000fbf2:	0005c683          	lbu	a3,0(a1)
8000fbf6:	0585                	add	a1,a1,1
8000fbf8:	00d50023          	sb	a3,0(a0)
8000fbfc:	0505                	add	a0,a0,1
8000fbfe:	167d                	add	a2,a2,-1
8000fc00:	fa6d                	bnez	a2,8000fbf2 <.L__SEGGER_init_lzss_LoopLiteral>
8000fc02:	bf45                	j	8000fbb2 <.L__SEGGER_init_lzss_NextByte>

8000fc04 <.L__SEGGER_init_lzss_Done>:
8000fc04:	8082                	ret

8000fc06 <.L__SEGGER_init_lzss_Error>:
8000fc06:	a001                	j	8000fc06 <.L__SEGGER_init_lzss_Error>

Disassembly of section .segger.init.__SEGGER_init_zero:

8000fc08 <__SEGGER_init_zero>:
8000fc08:	4008                	lw	a0,0(s0)
8000fc0a:	404c                	lw	a1,4(s0)
8000fc0c:	0421                	add	s0,s0,8
8000fc0e:	c591                	beqz	a1,8000fc1a <.L__SEGGER_init_zero_Done>

8000fc10 <.L__SEGGER_init_zero_Loop>:
8000fc10:	00050023          	sb	zero,0(a0)
8000fc14:	0505                	add	a0,a0,1
8000fc16:	15fd                	add	a1,a1,-1
8000fc18:	fde5                	bnez	a1,8000fc10 <.L__SEGGER_init_zero_Loop>

8000fc1a <.L__SEGGER_init_zero_Done>:
8000fc1a:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

8000fc1c <__SEGGER_init_copy>:
8000fc1c:	4008                	lw	a0,0(s0)
8000fc1e:	404c                	lw	a1,4(s0)
8000fc20:	4410                	lw	a2,8(s0)
8000fc22:	0431                	add	s0,s0,12
8000fc24:	ca09                	beqz	a2,8000fc36 <.L__SEGGER_init_copy_Done>

8000fc26 <.L__SEGGER_init_copy_Loop>:
8000fc26:	00058683          	lb	a3,0(a1)
8000fc2a:	00d50023          	sb	a3,0(a0)
8000fc2e:	0505                	add	a0,a0,1
8000fc30:	0585                	add	a1,a1,1
8000fc32:	167d                	add	a2,a2,-1
8000fc34:	fa6d                	bnez	a2,8000fc26 <.L__SEGGER_init_copy_Loop>

8000fc36 <.L__SEGGER_init_copy_Done>:
8000fc36:	8082                	ret
