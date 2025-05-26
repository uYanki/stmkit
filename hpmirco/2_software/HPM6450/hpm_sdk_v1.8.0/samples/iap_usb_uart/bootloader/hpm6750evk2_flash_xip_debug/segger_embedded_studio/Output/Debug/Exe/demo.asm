
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
80003004:	41018193          	add	gp,gp,1040 # 1105410 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	01082237          	lui	tp,0x1082
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	95020213          	add	tp,tp,-1712 # 1081950 <__thread_pointer$>
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
80003034:	145040ef          	jal	80007978 <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003038:	10b040ef          	jal	80007942 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
8000303c:	223080ef          	jal	8000ba5e <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
80003040:	6e6080ef          	jal	8000b726 <_init>

80003044 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003044:	8000d437          	lui	s0,0x8000d
80003048:	6fc40413          	add	s0,s0,1788 # 8000d6fc <.L155+0x4>

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
80003054:	60a080ef          	jal	8000b65e <_clean_up>

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
80003068:	6a2080ef          	jal	8000b70a <reset_handler>
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
80003074:	696080ef          	jal	8000b70a <reset_handler>
        tail    exit
80003078:	bfdd                	j	8000306e <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>:
8000307a:	8082                	ret

Disassembly of section .text.usb_get_port_ccs:

800040a2 <usb_get_port_ccs>:
 *
 * @param[in] ptr A USB peripheral base address
 * @retval The USB controller reset status
 */
static inline bool usb_get_port_ccs(USB_Type *ptr)
{
800040a2:	1141                	add	sp,sp,-16
800040a4:	c62a                	sw	a0,12(sp)
    return USB_PORTSC1_CCS_GET(ptr->PORTSC1);
800040a6:	47b2                	lw	a5,12(sp)
800040a8:	1847a783          	lw	a5,388(a5)
800040ac:	8b85                	and	a5,a5,1
800040ae:	00f037b3          	snez	a5,a5
800040b2:	0ff7f793          	zext.b	a5,a5
}
800040b6:	853e                	mv	a0,a5
800040b8:	0141                	add	sp,sp,16
800040ba:	8082                	ret

Disassembly of section .text.usb_dcd_get_device_addr:

80004296 <usb_dcd_get_device_addr>:
 *
 * @param[in] ptr A USB peripheral base address
 * @retval The endpoint address
 */
static inline uint8_t usb_dcd_get_device_addr(USB_Type *ptr)
{
80004296:	1141                	add	sp,sp,-16
80004298:	c62a                	sw	a0,12(sp)
    return USB_DEVICEADDR_USBADR_GET(ptr->DEVICEADDR);
8000429a:	47b2                	lw	a5,12(sp)
8000429c:	1547a783          	lw	a5,340(a5)
800042a0:	83e5                	srl	a5,a5,0x19
800042a2:	0ff7f793          	zext.b	a5,a5
800042a6:	07f7f793          	and	a5,a5,127
800042aa:	0ff7f793          	zext.b	a5,a5
}
800042ae:	853e                	mv	a0,a5
800042b0:	0141                	add	sp,sp,16
800042b2:	8082                	ret

Disassembly of section .text.usb_qtd_init:

800042c6 <usb_qtd_init>:
#include "hpm_misc.h"
#include "hpm_common.h"

/* Initialize qtd */
static void usb_qtd_init(dcd_qtd_t *p_qtd, void *data_ptr, uint16_t total_bytes)
{
800042c6:	7179                	add	sp,sp,-48
800042c8:	d606                	sw	ra,44(sp)
800042ca:	c62a                	sw	a0,12(sp)
800042cc:	c42e                	sw	a1,8(sp)
800042ce:	87b2                	mv	a5,a2
800042d0:	00f11323          	sh	a5,6(sp)
    memset(p_qtd, 0, sizeof(dcd_qtd_t));
800042d4:	02000613          	li	a2,32
800042d8:	4581                	li	a1,0
800042da:	4532                	lw	a0,12(sp)
800042dc:	436080ef          	jal	8000c712 <memset>

    p_qtd->next        = USB_SOC_DCD_QTD_NEXT_INVALID;
800042e0:	47b2                	lw	a5,12(sp)
800042e2:	4705                	li	a4,1
800042e4:	c398                	sw	a4,0(a5)
    p_qtd->active      = 1;
800042e6:	47b2                	lw	a5,12(sp)
800042e8:	43d8                	lw	a4,4(a5)
800042ea:	08076713          	or	a4,a4,128
800042ee:	c3d8                	sw	a4,4(a5)
    p_qtd->total_bytes = p_qtd->expected_bytes = total_bytes;
800042f0:	00615783          	lhu	a5,6(sp)
800042f4:	4732                	lw	a4,12(sp)
800042f6:	00f71e23          	sh	a5,28(a4)
800042fa:	873e                	mv	a4,a5
800042fc:	67a1                	lui	a5,0x8
800042fe:	17fd                	add	a5,a5,-1 # 7fff <__NONCACHEABLE_RAM_segment_used_size__+0x28f7>
80004300:	8ff9                	and	a5,a5,a4
80004302:	01079693          	sll	a3,a5,0x10
80004306:	82c1                	srl	a3,a3,0x10
80004308:	47b2                	lw	a5,12(sp)
8000430a:	6721                	lui	a4,0x8
8000430c:	177d                	add	a4,a4,-1 # 7fff <__NONCACHEABLE_RAM_segment_used_size__+0x28f7>
8000430e:	8f75                	and	a4,a4,a3
80004310:	0742                	sll	a4,a4,0x10
80004312:	43d0                	lw	a2,4(a5)
80004314:	800106b7          	lui	a3,0x80010
80004318:	16fd                	add	a3,a3,-1 # 8000ffff <__SEGGER_init_data__+0x2893>
8000431a:	8ef1                	and	a3,a3,a2
8000431c:	8f55                	or	a4,a4,a3
8000431e:	c3d8                	sw	a4,4(a5)

    if (data_ptr != NULL) {
80004320:	47a2                	lw	a5,8(sp)
80004322:	cbb9                	beqz	a5,80004378 <.L35>
        p_qtd->buffer[0]   = (uint32_t)data_ptr;
80004324:	4722                	lw	a4,8(sp)
80004326:	47b2                	lw	a5,12(sp)
80004328:	c798                	sw	a4,8(a5)

8000432a <.LBB2>:
        for (uint8_t i = 1; i < USB_SOC_DCD_QHD_BUFFER_COUNT; i++) {
8000432a:	4785                	li	a5,1
8000432c:	00f10fa3          	sb	a5,31(sp)
80004330:	a83d                	j	8000436e <.L33>

80004332 <.L34>:
            p_qtd->buffer[i] |= ((p_qtd->buffer[i-1]) & 0xFFFFF000UL) + 4096U;
80004332:	01f14783          	lbu	a5,31(sp)
80004336:	17fd                	add	a5,a5,-1
80004338:	4732                	lw	a4,12(sp)
8000433a:	078a                	sll	a5,a5,0x2
8000433c:	97ba                	add	a5,a5,a4
8000433e:	4798                	lw	a4,8(a5)
80004340:	77fd                	lui	a5,0xfffff
80004342:	8f7d                	and	a4,a4,a5
80004344:	6785                	lui	a5,0x1
80004346:	00f706b3          	add	a3,a4,a5
8000434a:	01f14783          	lbu	a5,31(sp)
8000434e:	4732                	lw	a4,12(sp)
80004350:	078a                	sll	a5,a5,0x2
80004352:	97ba                	add	a5,a5,a4
80004354:	4798                	lw	a4,8(a5)
80004356:	01f14783          	lbu	a5,31(sp)
8000435a:	8f55                	or	a4,a4,a3
8000435c:	46b2                	lw	a3,12(sp)
8000435e:	078a                	sll	a5,a5,0x2
80004360:	97b6                	add	a5,a5,a3
80004362:	c798                	sw	a4,8(a5)
        for (uint8_t i = 1; i < USB_SOC_DCD_QHD_BUFFER_COUNT; i++) {
80004364:	01f14783          	lbu	a5,31(sp)
80004368:	0785                	add	a5,a5,1 # 1001 <__fw_size__+0x1>
8000436a:	00f10fa3          	sb	a5,31(sp)

8000436e <.L33>:
8000436e:	01f14703          	lbu	a4,31(sp)
80004372:	4791                	li	a5,4
80004374:	fae7ffe3          	bgeu	a5,a4,80004332 <.L34>

80004378 <.L35>:
        }
    }
}
80004378:	0001                	nop
8000437a:	50b2                	lw	ra,44(sp)
8000437c:	6145                	add	sp,sp,48
8000437e:	8082                	ret

Disassembly of section .text.usb_device_qtd_get:

8000447e <usb_device_qtd_get>:
{
    return &handle->dcd_data->qhd[ep_idx];
}

dcd_qtd_t *usb_device_qtd_get(usb_device_handle_t *handle, uint8_t ep_idx)
{
8000447e:	1141                	add	sp,sp,-16
80004480:	c62a                	sw	a0,12(sp)
80004482:	87ae                	mv	a5,a1
80004484:	00f105a3          	sb	a5,11(sp)
    return &handle->dcd_data->qtd[ep_idx * USB_SOC_DCD_QTD_COUNT_EACH_ENDPOINT];
80004488:	47b2                	lw	a5,12(sp)
8000448a:	43d8                	lw	a4,4(a5)
8000448c:	00b14783          	lbu	a5,11(sp)
80004490:	078e                	sll	a5,a5,0x3
80004492:	02078793          	add	a5,a5,32
80004496:	0796                	sll	a5,a5,0x5
80004498:	97ba                	add	a5,a5,a4
}
8000449a:	853e                	mv	a0,a5
8000449c:	0141                	add	sp,sp,16
8000449e:	8082                	ret

Disassembly of section .text.usb_device_bus_reset:

800044b2 <usb_device_bus_reset>:

void usb_device_bus_reset(usb_device_handle_t *handle, uint16_t ep0_max_packet_size)
{
800044b2:	7179                	add	sp,sp,-48
800044b4:	d606                	sw	ra,44(sp)
800044b6:	c62a                	sw	a0,12(sp)
800044b8:	87ae                	mv	a5,a1
800044ba:	00f11523          	sh	a5,10(sp)
    dcd_data_t *dcd_data = handle->dcd_data;
800044be:	47b2                	lw	a5,12(sp)
800044c0:	43dc                	lw	a5,4(a5)
800044c2:	ce3e                	sw	a5,28(sp)

    usb_dcd_bus_reset(handle->regs, ep0_max_packet_size);
800044c4:	47b2                	lw	a5,12(sp)
800044c6:	439c                	lw	a5,0(a5)
800044c8:	00a15703          	lhu	a4,10(sp)
800044cc:	85ba                	mv	a1,a4
800044ce:	853e                	mv	a0,a5
800044d0:	003050ef          	jal	80009cd2 <usb_dcd_bus_reset>

     /* Queue Head & Queue TD */
    memset(dcd_data, 0, sizeof(dcd_data_t));
800044d4:	6785                	lui	a5,0x1
800044d6:	40078613          	add	a2,a5,1024 # 1400 <.L160>
800044da:	4581                	li	a1,0
800044dc:	4572                	lw	a0,28(sp)
800044de:	234080ef          	jal	8000c712 <memset>

    /* Set up Control Endpoints (0 OUT, 1 IN) */
    dcd_data->qhd[0].zero_length_termination = dcd_data->qhd[1].zero_length_termination = 1;
800044e2:	4705                	li	a4,1
800044e4:	47f2                	lw	a5,28(sp)
800044e6:	00177693          	and	a3,a4,1
800044ea:	06f6                	sll	a3,a3,0x1d
800044ec:	43ac                	lw	a1,64(a5)
800044ee:	e0000637          	lui	a2,0xe0000
800044f2:	167d                	add	a2,a2,-1 # dfffffff <__XPI0_segment_end__+0x5effffff>
800044f4:	8e6d                	and	a2,a2,a1
800044f6:	8ed1                	or	a3,a3,a2
800044f8:	c3b4                	sw	a3,64(a5)
800044fa:	47f2                	lw	a5,28(sp)
800044fc:	8b05                	and	a4,a4,1
800044fe:	0776                	sll	a4,a4,0x1d
80004500:	4390                	lw	a2,0(a5)
80004502:	e00006b7          	lui	a3,0xe0000
80004506:	16fd                	add	a3,a3,-1 # dfffffff <__XPI0_segment_end__+0x5effffff>
80004508:	8ef1                	and	a3,a3,a2
8000450a:	8f55                	or	a4,a4,a3
8000450c:	c398                	sw	a4,0(a5)
    dcd_data->qhd[0].max_packet_size         = dcd_data->qhd[1].max_packet_size         = ep0_max_packet_size;
8000450e:	00a15783          	lhu	a5,10(sp)
80004512:	7ff7f793          	and	a5,a5,2047
80004516:	01079713          	sll	a4,a5,0x10
8000451a:	8341                	srl	a4,a4,0x10
8000451c:	47f2                	lw	a5,28(sp)
8000451e:	7ff77693          	and	a3,a4,2047
80004522:	06c2                	sll	a3,a3,0x10
80004524:	43ac                	lw	a1,64(a5)
80004526:	f8010637          	lui	a2,0xf8010
8000452a:	167d                	add	a2,a2,-1 # f800ffff <__APB_SRAM_segment_end__+0x3f1dfff>
8000452c:	8e6d                	and	a2,a2,a1
8000452e:	8ed1                	or	a3,a3,a2
80004530:	c3b4                	sw	a3,64(a5)
80004532:	47f2                	lw	a5,28(sp)
80004534:	7ff77713          	and	a4,a4,2047
80004538:	0742                	sll	a4,a4,0x10
8000453a:	4390                	lw	a2,0(a5)
8000453c:	f80106b7          	lui	a3,0xf8010
80004540:	16fd                	add	a3,a3,-1 # f800ffff <__APB_SRAM_segment_end__+0x3f1dfff>
80004542:	8ef1                	and	a3,a3,a2
80004544:	8f55                	or	a4,a4,a3
80004546:	c398                	sw	a4,0(a5)
    dcd_data->qhd[0].qtd_overlay.next        = dcd_data->qhd[1].qtd_overlay.next        = USB_SOC_DCD_QTD_NEXT_INVALID;
80004548:	4785                	li	a5,1
8000454a:	4772                	lw	a4,28(sp)
8000454c:	c73c                	sw	a5,72(a4)
8000454e:	4772                	lw	a4,28(sp)
80004550:	c71c                	sw	a5,8(a4)

    /* OUT only */
    dcd_data->qhd[0].int_on_setup = 1;
80004552:	47f2                	lw	a5,28(sp)
80004554:	4394                	lw	a3,0(a5)
80004556:	6721                	lui	a4,0x8
80004558:	8f55                	or	a4,a4,a3
8000455a:	c398                	sw	a4,0(a5)
}
8000455c:	0001                	nop
8000455e:	50b2                	lw	ra,44(sp)
80004560:	6145                	add	sp,sp,48
80004562:	8082                	ret

Disassembly of section .text.usb_device_status_flags:

8000456e <usb_device_status_flags>:

    memset(handle->dcd_data, 0, sizeof(dcd_data_t));
}

uint32_t usb_device_status_flags(usb_device_handle_t *handle)
{
8000456e:	1101                	add	sp,sp,-32
80004570:	ce06                	sw	ra,28(sp)
80004572:	c62a                	sw	a0,12(sp)
    return usb_get_status_flags(handle->regs);
80004574:	47b2                	lw	a5,12(sp)
80004576:	439c                	lw	a5,0(a5)
80004578:	853e                	mv	a0,a5
8000457a:	16b040ef          	jal	80008ee4 <usb_get_status_flags>
8000457e:	87aa                	mv	a5,a0
}
80004580:	853e                	mv	a0,a5
80004582:	40f2                	lw	ra,28(sp)
80004584:	6105                	add	sp,sp,32
80004586:	8082                	ret

Disassembly of section .text.usb_device_interrupts:

8000458a <usb_device_interrupts>:
{
    usb_clear_status_flags(handle->regs, mask);
}

uint32_t usb_device_interrupts(usb_device_handle_t *handle)
{
8000458a:	1101                	add	sp,sp,-32
8000458c:	ce06                	sw	ra,28(sp)
8000458e:	c62a                	sw	a0,12(sp)
    return usb_get_interrupts(handle->regs);
80004590:	47b2                	lw	a5,12(sp)
80004592:	439c                	lw	a5,0(a5)
80004594:	853e                	mv	a0,a5
80004596:	123040ef          	jal	80008eb8 <usb_get_interrupts>
8000459a:	87aa                	mv	a5,a0
}
8000459c:	853e                	mv	a0,a5
8000459e:	40f2                	lw	ra,28(sp)
800045a0:	6105                	add	sp,sp,32
800045a2:	8082                	ret

Disassembly of section .text.usb_device_get_suspend_status:

800045ca <usb_device_get_suspend_status>:
{
    return usb_get_port_speed(handle->regs);
}

uint8_t usb_device_get_suspend_status(usb_device_handle_t *handle)
{
800045ca:	1101                	add	sp,sp,-32
800045cc:	ce06                	sw	ra,28(sp)
800045ce:	c62a                	sw	a0,12(sp)
    return usb_get_suspend_status(handle->regs);
800045d0:	47b2                	lw	a5,12(sp)
800045d2:	439c                	lw	a5,0(a5)
800045d4:	853e                	mv	a0,a5
800045d6:	133040ef          	jal	80008f08 <usb_get_suspend_status>
800045da:	87aa                	mv	a5,a0
}
800045dc:	853e                	mv	a0,a5
800045de:	40f2                	lw	ra,28(sp)
800045e0:	6105                	add	sp,sp,32
800045e2:	8082                	ret

Disassembly of section .text.usb_device_get_address:

80004606 <usb_device_get_address>:

    usb_dcd_set_address(handle->regs, dev_addr);
}

uint8_t usb_device_get_address(usb_device_handle_t *handle)
{
80004606:	1101                	add	sp,sp,-32
80004608:	ce06                	sw	ra,28(sp)
8000460a:	c62a                	sw	a0,12(sp)
    return usb_dcd_get_device_addr(handle->regs);
8000460c:	47b2                	lw	a5,12(sp)
8000460e:	439c                	lw	a5,0(a5)
80004610:	853e                	mv	a0,a5
80004612:	3151                	jal	80004296 <usb_dcd_get_device_addr>
80004614:	87aa                	mv	a5,a0
}
80004616:	853e                	mv	a0,a5
80004618:	40f2                	lw	ra,28(sp)
8000461a:	6105                	add	sp,sp,32
8000461c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

8000461e <__SEGGER_RTL_SIGNAL_SIG_IGN>:
8000461e:	8082                	ret

Disassembly of section .text.usb_device_get_port_ccs:

8000463e <usb_device_get_port_ccs>:
{
    usb_dcd_disconnect(handle->regs);
}

bool usb_device_get_port_ccs(usb_device_handle_t *handle)
{
8000463e:	1101                	add	sp,sp,-32
80004640:	ce06                	sw	ra,28(sp)
80004642:	c62a                	sw	a0,12(sp)
    return usb_get_port_ccs(handle->regs);
80004644:	47b2                	lw	a5,12(sp)
80004646:	439c                	lw	a5,0(a5)
80004648:	853e                	mv	a0,a5
8000464a:	3ca1                	jal	800040a2 <usb_get_port_ccs>
8000464c:	87aa                	mv	a5,a0
}
8000464e:	853e                	mv	a0,a5
80004650:	40f2                	lw	ra,28(sp)
80004652:	6105                	add	sp,sp,32
80004654:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

80004656 <__SEGGER_RTL_SIGNAL_SIG_ERR>:
80004656:	8082                	ret

Disassembly of section .text.usb_device_get_edpt_complete_status:

80004662 <usb_device_get_edpt_complete_status>:
{
    return usb_get_port_reset_status(handle->regs);
}

uint32_t usb_device_get_edpt_complete_status(usb_device_handle_t *handle)
{
80004662:	1101                	add	sp,sp,-32
80004664:	ce06                	sw	ra,28(sp)
80004666:	c62a                	sw	a0,12(sp)
    return usb_dcd_get_edpt_complete_status(handle->regs);
80004668:	47b2                	lw	a5,12(sp)
8000466a:	439c                	lw	a5,0(a5)
8000466c:	853e                	mv	a0,a5
8000466e:	0f3040ef          	jal	80008f60 <usb_dcd_get_edpt_complete_status>
80004672:	87aa                	mv	a5,a0
}
80004674:	853e                	mv	a0,a5
80004676:	40f2                	lw	ra,28(sp)
80004678:	6105                	add	sp,sp,32
8000467a:	8082                	ret

Disassembly of section .text.usb_device_get_setup_status:

8000467e <usb_device_get_setup_status>:
{
    usb_dcd_clear_edpt_complete_status(handle->regs, mask);
}

uint32_t usb_device_get_setup_status(usb_device_handle_t *handle)
{
8000467e:	1101                	add	sp,sp,-32
80004680:	ce06                	sw	ra,28(sp)
80004682:	c62a                	sw	a0,12(sp)
    return usb_dcd_get_edpt_setup_status(handle->regs);
80004684:	47b2                	lw	a5,12(sp)
80004686:	439c                	lw	a5,0(a5)
80004688:	853e                	mv	a0,a5
8000468a:	09b040ef          	jal	80008f24 <usb_dcd_get_edpt_setup_status>
8000468e:	87aa                	mv	a5,a0
}
80004690:	853e                	mv	a0,a5
80004692:	40f2                	lw	ra,28(sp)
80004694:	6105                	add	sp,sp,32
80004696:	8082                	ret

Disassembly of section .text.usb_device_edpt_open:

800046d2 <usb_device_edpt_open>:
/*---------------------------------------------------------------------
 * Endpoint API
 *---------------------------------------------------------------------
 */
bool usb_device_edpt_open(usb_device_handle_t *handle, usb_endpoint_config_t *config)
{
800046d2:	7179                	add	sp,sp,-48
800046d4:	d606                	sw	ra,44(sp)
800046d6:	c62a                	sw	a0,12(sp)
800046d8:	c42e                	sw	a1,8(sp)
    uint8_t const epnum  = config->ep_addr & 0x0f;
800046da:	47a2                	lw	a5,8(sp)
800046dc:	0017c783          	lbu	a5,1(a5)
800046e0:	8bbd                	and	a5,a5,15
800046e2:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir = (config->ep_addr & 0x80) >> 7;
800046e6:	47a2                	lw	a5,8(sp)
800046e8:	0017c783          	lbu	a5,1(a5)
800046ec:	839d                	srl	a5,a5,0x7
800046ee:	00f10f23          	sb	a5,30(sp)
    uint8_t const ep_idx = 2 * epnum + dir;
800046f2:	01f14783          	lbu	a5,31(sp)
800046f6:	0786                	sll	a5,a5,0x1
800046f8:	0ff7f793          	zext.b	a5,a5
800046fc:	01e14703          	lbu	a4,30(sp)
80004700:	97ba                	add	a5,a5,a4
80004702:	00f10ea3          	sb	a5,29(sp)

    dcd_qhd_t *p_qhd;

    /* Must not exceed max endpoint number */
    if (epnum >= USB_SOC_DCD_MAX_ENDPOINT_COUNT) {
80004706:	01f14703          	lbu	a4,31(sp)
8000470a:	479d                	li	a5,7
8000470c:	00e7f463          	bgeu	a5,a4,80004714 <.L73>
        return false;
80004710:	4781                	li	a5,0
80004712:	a04d                	j	800047b4 <.L74>

80004714 <.L73>:
    }

    /* Prepare Queue Head */
    p_qhd = &handle->dcd_data->qhd[ep_idx];
80004714:	47b2                	lw	a5,12(sp)
80004716:	43d8                	lw	a4,4(a5)
80004718:	01d14783          	lbu	a5,29(sp)
8000471c:	079a                	sll	a5,a5,0x6
8000471e:	97ba                	add	a5,a5,a4
80004720:	cc3e                	sw	a5,24(sp)
    memset(p_qhd, 0, sizeof(dcd_qhd_t));
80004722:	04000613          	li	a2,64
80004726:	4581                	li	a1,0
80004728:	4562                	lw	a0,24(sp)
8000472a:	7e9070ef          	jal	8000c712 <memset>

    p_qhd->zero_length_termination = 1;
8000472e:	47e2                	lw	a5,24(sp)
80004730:	4394                	lw	a3,0(a5)
80004732:	20000737          	lui	a4,0x20000
80004736:	8f55                	or	a4,a4,a3
80004738:	c398                	sw	a4,0(a5)
    p_qhd->max_packet_size         = config->max_packet_size & 0x7FFu;
8000473a:	47a2                	lw	a5,8(sp)
8000473c:	0027d783          	lhu	a5,2(a5)
80004740:	7ff7f793          	and	a5,a5,2047
80004744:	01079713          	sll	a4,a5,0x10
80004748:	8341                	srl	a4,a4,0x10
8000474a:	47e2                	lw	a5,24(sp)
8000474c:	7ff77713          	and	a4,a4,2047
80004750:	0742                	sll	a4,a4,0x10
80004752:	4390                	lw	a2,0(a5)
80004754:	f80106b7          	lui	a3,0xf8010
80004758:	16fd                	add	a3,a3,-1 # f800ffff <__APB_SRAM_segment_end__+0x3f1dfff>
8000475a:	8ef1                	and	a3,a3,a2
8000475c:	8f55                	or	a4,a4,a3
8000475e:	c398                	sw	a4,0(a5)
    p_qhd->qtd_overlay.next        = USB_SOC_DCD_QTD_NEXT_INVALID;
80004760:	47e2                	lw	a5,24(sp)
80004762:	4705                	li	a4,1
80004764:	c798                	sw	a4,8(a5)
    if (config->xfer == usb_xfer_isochronous) {
80004766:	47a2                	lw	a5,8(sp)
80004768:	0007c703          	lbu	a4,0(a5)
8000476c:	4785                	li	a5,1
8000476e:	02f71c63          	bne	a4,a5,800047a6 <.L75>
        p_qhd->iso_mult = ((config->max_packet_size >> 11u) & 0x3u) + 1u;
80004772:	47a2                	lw	a5,8(sp)
80004774:	0027d783          	lhu	a5,2(a5)
80004778:	83ad                	srl	a5,a5,0xb
8000477a:	07c2                	sll	a5,a5,0x10
8000477c:	83c1                	srl	a5,a5,0x10
8000477e:	0ff7f793          	zext.b	a5,a5
80004782:	8b8d                	and	a5,a5,3
80004784:	0ff7f793          	zext.b	a5,a5
80004788:	0785                	add	a5,a5,1
8000478a:	0ff7f793          	zext.b	a5,a5
8000478e:	8b8d                	and	a5,a5,3
80004790:	0ff7f713          	zext.b	a4,a5
80004794:	47e2                	lw	a5,24(sp)
80004796:	077a                	sll	a4,a4,0x1e
80004798:	4390                	lw	a2,0(a5)
8000479a:	400006b7          	lui	a3,0x40000
8000479e:	16fd                	add	a3,a3,-1 # 3fffffff <_extram_size+0x3dffffff>
800047a0:	8ef1                	and	a3,a3,a2
800047a2:	8f55                	or	a4,a4,a3
800047a4:	c398                	sw	a4,0(a5)

800047a6 <.L75>:
    }

    usb_dcd_edpt_open(handle->regs, config);
800047a6:	47b2                	lw	a5,12(sp)
800047a8:	439c                	lw	a5,0(a5)
800047aa:	45a2                	lw	a1,8(sp)
800047ac:	853e                	mv	a0,a5
800047ae:	503000ef          	jal	800054b0 <usb_dcd_edpt_open>

    return true;
800047b2:	4785                	li	a5,1

800047b4 <.L74>:
}
800047b4:	853e                	mv	a0,a5
800047b6:	50b2                	lw	ra,44(sp)
800047b8:	6145                	add	sp,sp,48
800047ba:	8082                	ret

Disassembly of section .text.usb_device_edpt_xfer:

800047e6 <usb_device_edpt_xfer>:

bool usb_device_edpt_xfer(usb_device_handle_t *handle, uint8_t ep_addr, uint8_t *buffer, uint32_t total_bytes)
{
800047e6:	7139                	add	sp,sp,-64
800047e8:	de06                	sw	ra,60(sp)
800047ea:	c62a                	sw	a0,12(sp)
800047ec:	87ae                	mv	a5,a1
800047ee:	c232                	sw	a2,4(sp)
800047f0:	c036                	sw	a3,0(sp)
800047f2:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
800047f6:	00b14783          	lbu	a5,11(sp)
800047fa:	8bbd                	and	a5,a5,15
800047fc:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
80004800:	00b14783          	lbu	a5,11(sp)
80004804:	839d                	srl	a5,a5,0x7
80004806:	00f10f23          	sb	a5,30(sp)
    uint8_t const ep_idx = 2 * epnum + dir;
8000480a:	01f14783          	lbu	a5,31(sp)
8000480e:	0786                	sll	a5,a5,0x1
80004810:	0ff7f793          	zext.b	a5,a5
80004814:	01e14703          	lbu	a4,30(sp)
80004818:	97ba                	add	a5,a5,a4
8000481a:	00f10ea3          	sb	a5,29(sp)
    uint8_t qtd_num;
    uint8_t i;
    uint32_t xfer_len;
    dcd_qhd_t *p_qhd;
    dcd_qtd_t *p_qtd;
    dcd_qtd_t *first_p_qtd = NULL;
8000481e:	d202                	sw	zero,36(sp)
    dcd_qtd_t *prev_p_qtd = NULL;
80004820:	d002                	sw	zero,32(sp)

    if (epnum == 0) {
80004822:	01f14783          	lbu	a5,31(sp)
80004826:	eb91                	bnez	a5,8000483a <.L77>
        /* follows UM Setup packet handling using setup lockout mechanism
         * wait until ENDPTSETUPSTAT before priming data/status in response TODO add time out
         */
        while (usb_dcd_get_edpt_setup_status(handle->regs) & HPM_BITSMASK(1, 0)) {
80004828:	0001                	nop

8000482a <.L78>:
8000482a:	47b2                	lw	a5,12(sp)
8000482c:	439c                	lw	a5,0(a5)
8000482e:	853e                	mv	a0,a5
80004830:	6f4040ef          	jal	80008f24 <usb_dcd_get_edpt_setup_status>
80004834:	87aa                	mv	a5,a0
80004836:	8b85                	and	a5,a5,1
80004838:	fbed                	bnez	a5,8000482a <.L78>

8000483a <.L77>:
        }
    }

    qtd_num = (total_bytes + 0x3fff) / 0x4000;
8000483a:	4702                	lw	a4,0(sp)
8000483c:	6791                	lui	a5,0x4
8000483e:	17fd                	add	a5,a5,-1 # 3fff <__ILM_segment_used_end__+0x5>
80004840:	97ba                	add	a5,a5,a4
80004842:	83b9                	srl	a5,a5,0xe
80004844:	00f10e23          	sb	a5,28(sp)
    if (qtd_num > USB_SOC_DCD_QTD_COUNT_EACH_ENDPOINT) {
80004848:	01c14703          	lbu	a4,28(sp)
8000484c:	47a1                	li	a5,8
8000484e:	00e7f463          	bgeu	a5,a4,80004856 <.L79>
        return false;
80004852:	4781                	li	a5,0
80004854:	a0d9                	j	8000491a <.L80>

80004856 <.L79>:
    }

    if (buffer != NULL) {
80004856:	4792                	lw	a5,4(sp)
80004858:	cb81                	beqz	a5,80004868 <.L81>
        buffer = (uint8_t *)core_local_mem_to_sys_address(0, (uint32_t)buffer);
8000485a:	4792                	lw	a5,4(sp)
8000485c:	85be                	mv	a1,a5
8000485e:	4501                	li	a0,0
80004860:	5f8040ef          	jal	80008e58 <core_local_mem_to_sys_address>
80004864:	87aa                	mv	a5,a0
80004866:	c23e                	sw	a5,4(sp)

80004868 <.L81>:
    }
    p_qhd = &handle->dcd_data->qhd[ep_idx];
80004868:	47b2                	lw	a5,12(sp)
8000486a:	43d8                	lw	a4,4(a5)
8000486c:	01d14783          	lbu	a5,29(sp)
80004870:	079a                	sll	a5,a5,0x6
80004872:	97ba                	add	a5,a5,a4
80004874:	cc3e                	sw	a5,24(sp)
    i = 0;
80004876:	020107a3          	sb	zero,47(sp)

8000487a <.L87>:
    do {
        p_qtd = &handle->dcd_data->qtd[ep_idx * USB_SOC_DCD_QTD_COUNT_EACH_ENDPOINT + i];
8000487a:	47b2                	lw	a5,12(sp)
8000487c:	43d8                	lw	a4,4(a5)
8000487e:	01d14783          	lbu	a5,29(sp)
80004882:	00379693          	sll	a3,a5,0x3
80004886:	02f14783          	lbu	a5,47(sp)
8000488a:	97b6                	add	a5,a5,a3
8000488c:	02078793          	add	a5,a5,32
80004890:	0796                	sll	a5,a5,0x5
80004892:	97ba                	add	a5,a5,a4
80004894:	ca3e                	sw	a5,20(sp)
        i++;
80004896:	02f14783          	lbu	a5,47(sp)
8000489a:	0785                	add	a5,a5,1
8000489c:	02f107a3          	sb	a5,47(sp)

        if (total_bytes > 0x4000) {
800048a0:	4702                	lw	a4,0(sp)
800048a2:	6791                	lui	a5,0x4
800048a4:	00e7f963          	bgeu	a5,a4,800048b6 <.L82>
            xfer_len = 0x4000;
800048a8:	6791                	lui	a5,0x4
800048aa:	d43e                	sw	a5,40(sp)
            total_bytes -= 0x4000;
800048ac:	4702                	lw	a4,0(sp)
800048ae:	77f1                	lui	a5,0xffffc
800048b0:	97ba                	add	a5,a5,a4
800048b2:	c03e                	sw	a5,0(sp)
800048b4:	a021                	j	800048bc <.L83>

800048b6 <.L82>:
        } else {
            xfer_len = total_bytes;
800048b6:	4782                	lw	a5,0(sp)
800048b8:	d43e                	sw	a5,40(sp)
            total_bytes = 0;
800048ba:	c002                	sw	zero,0(sp)

800048bc <.L83>:
        }

        usb_qtd_init(p_qtd, (void *)buffer, xfer_len);
800048bc:	57a2                	lw	a5,40(sp)
800048be:	07c2                	sll	a5,a5,0x10
800048c0:	83c1                	srl	a5,a5,0x10
800048c2:	863e                	mv	a2,a5
800048c4:	4592                	lw	a1,4(sp)
800048c6:	4552                	lw	a0,20(sp)
800048c8:	3afd                	jal	800042c6 <usb_qtd_init>
        if (total_bytes == 0) {
800048ca:	4782                	lw	a5,0(sp)
800048cc:	e791                	bnez	a5,800048d8 <.L84>
            p_qtd->int_on_complete = true;
800048ce:	47d2                	lw	a5,20(sp)
800048d0:	43d4                	lw	a3,4(a5)
800048d2:	6721                	lui	a4,0x8
800048d4:	8f55                	or	a4,a4,a3
800048d6:	c3d8                	sw	a4,4(a5)

800048d8 <.L84>:
        }
        buffer += xfer_len;
800048d8:	4712                	lw	a4,4(sp)
800048da:	57a2                	lw	a5,40(sp)
800048dc:	97ba                	add	a5,a5,a4
800048de:	c23e                	sw	a5,4(sp)

        if (prev_p_qtd) {
800048e0:	5782                	lw	a5,32(sp)
800048e2:	c789                	beqz	a5,800048ec <.L85>
            prev_p_qtd->next = (uint32_t)p_qtd;
800048e4:	4752                	lw	a4,20(sp)
800048e6:	5782                	lw	a5,32(sp)
800048e8:	c398                	sw	a4,0(a5)
800048ea:	a019                	j	800048f0 <.L86>

800048ec <.L85>:
        } else {
            first_p_qtd = p_qtd;
800048ec:	47d2                	lw	a5,20(sp)
800048ee:	d23e                	sw	a5,36(sp)

800048f0 <.L86>:
        }
        prev_p_qtd = p_qtd;
800048f0:	47d2                	lw	a5,20(sp)
800048f2:	d03e                	sw	a5,32(sp)
    } while (total_bytes > 0);
800048f4:	4782                	lw	a5,0(sp)
800048f6:	f3d1                	bnez	a5,8000487a <.L87>

    p_qhd->qtd_overlay.next = core_local_mem_to_sys_address(0, (uint32_t) first_p_qtd); /* link qtd to qhd */
800048f8:	5792                	lw	a5,36(sp)
800048fa:	85be                	mv	a1,a5
800048fc:	4501                	li	a0,0
800048fe:	55a040ef          	jal	80008e58 <core_local_mem_to_sys_address>
80004902:	872a                	mv	a4,a0
80004904:	47e2                	lw	a5,24(sp)
80004906:	c798                	sw	a4,8(a5)

    usb_dcd_edpt_xfer(handle->regs, ep_idx);
80004908:	47b2                	lw	a5,12(sp)
8000490a:	439c                	lw	a5,0(a5)
8000490c:	01d14703          	lbu	a4,29(sp)
80004910:	85ba                	mv	a1,a4
80004912:	853e                	mv	a0,a5
80004914:	572050ef          	jal	80009e86 <usb_dcd_edpt_xfer>

    return true;
80004918:	4785                	li	a5,1

8000491a <.L80>:
}
8000491a:	853e                	mv	a0,a5
8000491c:	50f2                	lw	ra,60(sp)
8000491e:	6121                	add	sp,sp,64
80004920:	8082                	ret

Disassembly of section .text.usb_device_edpt_check_stall:

8000494e <usb_device_edpt_check_stall>:
{
    usb_dcd_edpt_clear_stall(handle->regs, ep_addr);
}

bool usb_device_edpt_check_stall(usb_device_handle_t *handle, uint8_t ep_addr)
{
8000494e:	1101                	add	sp,sp,-32
80004950:	ce06                	sw	ra,28(sp)
80004952:	c62a                	sw	a0,12(sp)
80004954:	87ae                	mv	a5,a1
80004956:	00f105a3          	sb	a5,11(sp)
    return usb_dcd_edpt_check_stall(handle->regs, ep_addr);
8000495a:	47b2                	lw	a5,12(sp)
8000495c:	439c                	lw	a5,0(a5)
8000495e:	00b14703          	lbu	a4,11(sp)
80004962:	85ba                	mv	a1,a4
80004964:	853e                	mv	a0,a5
80004966:	4a5000ef          	jal	8000560a <usb_dcd_edpt_check_stall>
8000496a:	87aa                	mv	a5,a0
}
8000496c:	853e                	mv	a0,a5
8000496e:	40f2                	lw	ra,28(sp)
80004970:	6105                	add	sp,sp,32
80004972:	8082                	ret

Disassembly of section .text.gptmr_channel_get_default_config:

8000499e <gptmr_channel_get_default_config>:
 */

#include "hpm_gptmr_drv.h"

void gptmr_channel_get_default_config(GPTMR_Type *ptr, gptmr_channel_config_t *config)
{
8000499e:	1101                	add	sp,sp,-32
800049a0:	c62a                	sw	a0,12(sp)
800049a2:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->mode = gptmr_work_mode_no_capture;
800049a4:	47a2                	lw	a5,8(sp)
800049a6:	00078023          	sb	zero,0(a5) # ffffc000 <__APB_SRAM_segment_end__+0xbf0a000>
    config->dma_request_event = gptmr_dma_request_disabled;
800049aa:	47a2                	lw	a5,8(sp)
800049ac:	577d                	li	a4,-1
800049ae:	00e780a3          	sb	a4,1(a5)
    config->synci_edge = gptmr_synci_edge_none;
800049b2:	47a2                	lw	a5,8(sp)
800049b4:	00079123          	sh	zero,2(a5)

800049b8 <.LBB2>:
    for (uint8_t i = 0; i < GPTMR_CH_CMP_COUNT; i++) {
800049b8:	00010fa3          	sb	zero,31(sp)
800049bc:	a829                	j	800049d6 <.L2>

800049be <.L3>:
        config->cmp[i] = 0xFFFFFFFEUL;
800049be:	01f14783          	lbu	a5,31(sp)
800049c2:	4722                	lw	a4,8(sp)
800049c4:	078a                	sll	a5,a5,0x2
800049c6:	97ba                	add	a5,a5,a4
800049c8:	5779                	li	a4,-2
800049ca:	c3d8                	sw	a4,4(a5)
    for (uint8_t i = 0; i < GPTMR_CH_CMP_COUNT; i++) {
800049cc:	01f14783          	lbu	a5,31(sp)
800049d0:	0785                	add	a5,a5,1
800049d2:	00f10fa3          	sb	a5,31(sp)

800049d6 <.L2>:
800049d6:	01f14703          	lbu	a4,31(sp)
800049da:	4785                	li	a5,1
800049dc:	fee7f1e3          	bgeu	a5,a4,800049be <.L3>

800049e0 <.LBE2>:
    }
    config->reload = 0xFFFFFFFEUL;
800049e0:	47a2                	lw	a5,8(sp)
800049e2:	5779                	li	a4,-2
800049e4:	c7d8                	sw	a4,12(a5)
    config->cmp_initial_polarity_high = true;
800049e6:	47a2                	lw	a5,8(sp)
800049e8:	4705                	li	a4,1
800049ea:	00e78823          	sb	a4,16(a5)
    config->enable_cmp_output = true;
800049ee:	47a2                	lw	a5,8(sp)
800049f0:	4705                	li	a4,1
800049f2:	00e788a3          	sb	a4,17(a5)
    config->enable_sync_follow_previous_channel = false;
800049f6:	47a2                	lw	a5,8(sp)
800049f8:	00078923          	sb	zero,18(a5)
    config->enable_software_sync = false;
800049fc:	47a2                	lw	a5,8(sp)
800049fe:	000789a3          	sb	zero,19(a5)
    config->debug_mode = true;
80004a02:	47a2                	lw	a5,8(sp)
80004a04:	4705                	li	a4,1
80004a06:	00e78a23          	sb	a4,20(a5)

#if defined(HPM_IP_FEATURE_GPTMR_MONITOR) && (HPM_IP_FEATURE_GPTMR_MONITOR  == 1)
    config->enable_monitor = false;
    gptmr_channel_get_default_monitor_config(ptr, &config->monitor_config);
#endif
}
80004a0a:	0001                	nop
80004a0c:	6105                	add	sp,sp,32
80004a0e:	8082                	ret

Disassembly of section .text.gptmr_channel_config:

80004a3a <gptmr_channel_config>:

hpm_stat_t gptmr_channel_config(GPTMR_Type *ptr,
                         uint8_t ch_index,
                         gptmr_channel_config_t *config,
                         bool enable)
{
80004a3a:	1101                	add	sp,sp,-32
80004a3c:	c62a                	sw	a0,12(sp)
80004a3e:	87ae                	mv	a5,a1
80004a40:	c232                	sw	a2,4(sp)
80004a42:	8736                	mv	a4,a3
80004a44:	00f105a3          	sb	a5,11(sp)
80004a48:	87ba                	mv	a5,a4
80004a4a:	00f10523          	sb	a5,10(sp)
    uint32_t v = 0;
80004a4e:	ce02                	sw	zero,28(sp)
    uint32_t tmp_value;

    if (config->enable_sync_follow_previous_channel && !ch_index) {
80004a50:	4792                	lw	a5,4(sp)
80004a52:	0127c783          	lbu	a5,18(a5)
80004a56:	c791                	beqz	a5,80004a62 <.L5>
80004a58:	00b14783          	lbu	a5,11(sp)
80004a5c:	e399                	bnez	a5,80004a62 <.L5>
        return status_invalid_argument;
80004a5e:	4789                	li	a5,2
80004a60:	aa19                	j	80004b76 <.L6>

80004a62 <.L5>:
    }

    if (config->dma_request_event != gptmr_dma_request_disabled) {
80004a62:	4792                	lw	a5,4(sp)
80004a64:	0017c703          	lbu	a4,1(a5)
80004a68:	0ff00793          	li	a5,255
80004a6c:	00f70d63          	beq	a4,a5,80004a86 <.L7>
        v |= GPTMR_CHANNEL_CR_DMAEN_MASK
            | GPTMR_CHANNEL_CR_DMASEL_SET(config->dma_request_event);
80004a70:	4792                	lw	a5,4(sp)
80004a72:	0017c783          	lbu	a5,1(a5)
80004a76:	079a                	sll	a5,a5,0x6
80004a78:	0ff7f713          	zext.b	a4,a5
        v |= GPTMR_CHANNEL_CR_DMAEN_MASK
80004a7c:	47f2                	lw	a5,28(sp)
80004a7e:	8fd9                	or	a5,a5,a4
80004a80:	0207e793          	or	a5,a5,32
80004a84:	ce3e                	sw	a5,28(sp)

80004a86 <.L7>:
    }
    v |= GPTMR_CHANNEL_CR_CAPMODE_SET(config->mode)
80004a86:	4792                	lw	a5,4(sp)
80004a88:	0007c783          	lbu	a5,0(a5)
80004a8c:	0077f713          	and	a4,a5,7
        | GPTMR_CHANNEL_CR_DBGPAUSE_SET(config->debug_mode)
80004a90:	4792                	lw	a5,4(sp)
80004a92:	0147c783          	lbu	a5,20(a5)
80004a96:	078e                	sll	a5,a5,0x3
80004a98:	8ba1                	and	a5,a5,8
80004a9a:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_SWSYNCIEN_SET(config->enable_software_sync)
80004a9c:	4792                	lw	a5,4(sp)
80004a9e:	0137c783          	lbu	a5,19(a5)
80004aa2:	0792                	sll	a5,a5,0x4
80004aa4:	8bc1                	and	a5,a5,16
80004aa6:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_CMPINIT_SET(config->cmp_initial_polarity_high)
80004aa8:	4792                	lw	a5,4(sp)
80004aaa:	0107c783          	lbu	a5,16(a5)
80004aae:	07a6                	sll	a5,a5,0x9
80004ab0:	2007f793          	and	a5,a5,512
80004ab4:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_SYNCFLW_SET(config->enable_sync_follow_previous_channel)
80004ab6:	4792                	lw	a5,4(sp)
80004ab8:	0127c783          	lbu	a5,18(a5)
80004abc:	00d79693          	sll	a3,a5,0xd
80004ac0:	6789                	lui	a5,0x2
80004ac2:	8ff5                	and	a5,a5,a3
80004ac4:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_CMPEN_SET(config->enable_cmp_output)
80004ac6:	4792                	lw	a5,4(sp)
80004ac8:	0117c783          	lbu	a5,17(a5) # 2011 <__APB_SRAM_segment_size__+0x11>
80004acc:	07a2                	sll	a5,a5,0x8
80004ace:	1007f793          	and	a5,a5,256
80004ad2:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_CEN_SET(enable)
80004ad4:	00a14783          	lbu	a5,10(sp)
80004ad8:	07aa                	sll	a5,a5,0xa
80004ada:	4007f793          	and	a5,a5,1024
80004ade:	8fd9                	or	a5,a5,a4
        | config->synci_edge;
80004ae0:	4712                	lw	a4,4(sp)
80004ae2:	00275703          	lhu	a4,2(a4) # 8002 <__AHB_SRAM_segment_size__+0x2>
80004ae6:	8fd9                	or	a5,a5,a4
    v |= GPTMR_CHANNEL_CR_CAPMODE_SET(config->mode)
80004ae8:	4772                	lw	a4,28(sp)
80004aea:	8fd9                	or	a5,a5,a4
80004aec:	ce3e                	sw	a5,28(sp)

80004aee <.LBB3>:
    v |= GPTMR_CHANNEL_CR_CNT_MODE_SET(config->counter_mode);
#endif
#if defined(HPM_IP_FEATURE_GPTMR_OP_MODE) && (HPM_IP_FEATURE_GPTMR_OP_MODE  == 1)
    v |= GPTMR_CHANNEL_CR_OPMODE_SET(config->enable_opmode);
#endif
    for (uint8_t i = GPTMR_CH_CMP_COUNT; i > 0; i--) {
80004aee:	4789                	li	a5,2
80004af0:	00f10ba3          	sb	a5,23(sp)
80004af4:	a099                	j	80004b3a <.L8>

80004af6 <.L10>:
        tmp_value = config->cmp[i - 1];
80004af6:	01714783          	lbu	a5,23(sp)
80004afa:	17fd                	add	a5,a5,-1
80004afc:	4712                	lw	a4,4(sp)
80004afe:	078a                	sll	a5,a5,0x2
80004b00:	97ba                	add	a5,a5,a4
80004b02:	43dc                	lw	a5,4(a5)
80004b04:	cc3e                	sw	a5,24(sp)
        if ((tmp_value > 0)  && (tmp_value != 0xFFFFFFFFu)) {
80004b06:	47e2                	lw	a5,24(sp)
80004b08:	cb81                	beqz	a5,80004b18 <.L9>
80004b0a:	4762                	lw	a4,24(sp)
80004b0c:	57fd                	li	a5,-1
80004b0e:	00f70563          	beq	a4,a5,80004b18 <.L9>
            tmp_value--;
80004b12:	47e2                	lw	a5,24(sp)
80004b14:	17fd                	add	a5,a5,-1
80004b16:	cc3e                	sw	a5,24(sp)

80004b18 <.L9>:
        }
        ptr->CHANNEL[ch_index].CMP[i - 1] = GPTMR_CHANNEL_CMP_CMP_SET(tmp_value);
80004b18:	00b14683          	lbu	a3,11(sp)
80004b1c:	01714783          	lbu	a5,23(sp)
80004b20:	17fd                	add	a5,a5,-1
80004b22:	4732                	lw	a4,12(sp)
80004b24:	0692                	sll	a3,a3,0x4
80004b26:	97b6                	add	a5,a5,a3
80004b28:	078a                	sll	a5,a5,0x2
80004b2a:	97ba                	add	a5,a5,a4
80004b2c:	4762                	lw	a4,24(sp)
80004b2e:	c3d8                	sw	a4,4(a5)
    for (uint8_t i = GPTMR_CH_CMP_COUNT; i > 0; i--) {
80004b30:	01714783          	lbu	a5,23(sp)
80004b34:	17fd                	add	a5,a5,-1
80004b36:	00f10ba3          	sb	a5,23(sp)

80004b3a <.L8>:
80004b3a:	01714783          	lbu	a5,23(sp)
80004b3e:	ffc5                	bnez	a5,80004af6 <.L10>

80004b40 <.LBE3>:
    }
    tmp_value = config->reload;
80004b40:	4792                	lw	a5,4(sp)
80004b42:	47dc                	lw	a5,12(a5)
80004b44:	cc3e                	sw	a5,24(sp)
    if ((tmp_value > 0) && (tmp_value != 0xFFFFFFFFu)) {
80004b46:	47e2                	lw	a5,24(sp)
80004b48:	cb81                	beqz	a5,80004b58 <.L11>
80004b4a:	4762                	lw	a4,24(sp)
80004b4c:	57fd                	li	a5,-1
80004b4e:	00f70563          	beq	a4,a5,80004b58 <.L11>
        tmp_value--;
80004b52:	47e2                	lw	a5,24(sp)
80004b54:	17fd                	add	a5,a5,-1
80004b56:	cc3e                	sw	a5,24(sp)

80004b58 <.L11>:
    }
    ptr->CHANNEL[ch_index].RLD = GPTMR_CHANNEL_RLD_RLD_SET(tmp_value);
80004b58:	00b14783          	lbu	a5,11(sp)
80004b5c:	4732                	lw	a4,12(sp)
80004b5e:	079a                	sll	a5,a5,0x6
80004b60:	97ba                	add	a5,a5,a4
80004b62:	4762                	lw	a4,24(sp)
80004b64:	c7d8                	sw	a4,12(a5)
    ptr->CHANNEL[ch_index].CR = v;
80004b66:	00b14783          	lbu	a5,11(sp)
80004b6a:	4732                	lw	a4,12(sp)
80004b6c:	079a                	sll	a5,a5,0x6
80004b6e:	97ba                	add	a5,a5,a4
80004b70:	4772                	lw	a4,28(sp)
80004b72:	c398                	sw	a4,0(a5)
#if defined(HPM_IP_FEATURE_GPTMR_MONITOR) && (HPM_IP_FEATURE_GPTMR_MONITOR  == 1)
    gptmr_channel_monitor_config(ptr, ch_index, &config->monitor_config, config->enable_monitor);
#endif

    return status_success;
80004b74:	4781                	li	a5,0

80004b76 <.L6>:
}
80004b76:	853e                	mv	a0,a5
80004b78:	6105                	add	sp,sp,32
80004b7a:	8082                	ret

Disassembly of section .text.pllctl_pll_poweron:

80004b7e <pllctl_pll_poweron>:
 * @param[in] pll Target PLL index
 *
 * @return status_success if everything is okay
 */
static inline hpm_stat_t pllctl_pll_poweron(PLLCTL_Type *ptr, uint8_t pll)
{
80004b7e:	1101                	add	sp,sp,-32
80004b80:	c62a                	sw	a0,12(sp)
80004b82:	87ae                	mv	a5,a1
80004b84:	00f105a3          	sb	a5,11(sp)
    uint32_t cfg;
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
80004b88:	00b14703          	lbu	a4,11(sp)
80004b8c:	4791                	li	a5,4
80004b8e:	00e7f463          	bgeu	a5,a4,80004b96 <.L8>
        return status_invalid_argument;
80004b92:	4789                	li	a5,2
80004b94:	a849                	j	80004c26 <.L9>

80004b96 <.L8>:
    }

    cfg = ptr->PLL[pll].CFG1;
80004b96:	00b14783          	lbu	a5,11(sp)
80004b9a:	4732                	lw	a4,12(sp)
80004b9c:	0785                	add	a5,a5,1
80004b9e:	079e                	sll	a5,a5,0x7
80004ba0:	97ba                	add	a5,a5,a4
80004ba2:	43dc                	lw	a5,4(a5)
80004ba4:	ce3e                	sw	a5,28(sp)
    if (!(cfg & PLLCTL_PLL_CFG1_PLLPD_SW_MASK)) {
80004ba6:	4772                	lw	a4,28(sp)
80004ba8:	020007b7          	lui	a5,0x2000
80004bac:	8ff9                	and	a5,a5,a4
80004bae:	e399                	bnez	a5,80004bb4 <.L10>
        return status_success;
80004bb0:	4781                	li	a5,0
80004bb2:	a895                	j	80004c26 <.L9>

80004bb4 <.L10>:
    }

    if (cfg & PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK) {
80004bb4:	47f2                	lw	a5,28(sp)
80004bb6:	0207d463          	bgez	a5,80004bde <.L11>
        ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
80004bba:	00b14783          	lbu	a5,11(sp)
80004bbe:	4732                	lw	a4,12(sp)
80004bc0:	0785                	add	a5,a5,1 # 2000001 <_extram_size+0x1>
80004bc2:	079e                	sll	a5,a5,0x7
80004bc4:	97ba                	add	a5,a5,a4
80004bc6:	43d4                	lw	a3,4(a5)
80004bc8:	00b14783          	lbu	a5,11(sp)
80004bcc:	80000737          	lui	a4,0x80000
80004bd0:	177d                	add	a4,a4,-1 # 7fffffff <_extram_size+0x7dffffff>
80004bd2:	8f75                	and	a4,a4,a3
80004bd4:	46b2                	lw	a3,12(sp)
80004bd6:	0785                	add	a5,a5,1
80004bd8:	079e                	sll	a5,a5,0x7
80004bda:	97b6                	add	a5,a5,a3
80004bdc:	c3d8                	sw	a4,4(a5)

80004bde <.L11>:
    }

    ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
80004bde:	00b14783          	lbu	a5,11(sp)
80004be2:	4732                	lw	a4,12(sp)
80004be4:	0785                	add	a5,a5,1
80004be6:	079e                	sll	a5,a5,0x7
80004be8:	97ba                	add	a5,a5,a4
80004bea:	43d4                	lw	a3,4(a5)
80004bec:	00b14783          	lbu	a5,11(sp)
80004bf0:	fe000737          	lui	a4,0xfe000
80004bf4:	177d                	add	a4,a4,-1 # fdffffff <__APB_SRAM_segment_end__+0x9f0dfff>
80004bf6:	8f75                	and	a4,a4,a3
80004bf8:	46b2                	lw	a3,12(sp)
80004bfa:	0785                	add	a5,a5,1
80004bfc:	079e                	sll	a5,a5,0x7
80004bfe:	97b6                	add	a5,a5,a3
80004c00:	c3d8                	sw	a4,4(a5)

    /*
     * put back to hardware mode
     */
    ptr->PLL[pll].CFG1 |= PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
80004c02:	00b14783          	lbu	a5,11(sp)
80004c06:	4732                	lw	a4,12(sp)
80004c08:	0785                	add	a5,a5,1
80004c0a:	079e                	sll	a5,a5,0x7
80004c0c:	97ba                	add	a5,a5,a4
80004c0e:	43d4                	lw	a3,4(a5)
80004c10:	00b14783          	lbu	a5,11(sp)
80004c14:	80000737          	lui	a4,0x80000
80004c18:	8f55                	or	a4,a4,a3
80004c1a:	46b2                	lw	a3,12(sp)
80004c1c:	0785                	add	a5,a5,1
80004c1e:	079e                	sll	a5,a5,0x7
80004c20:	97b6                	add	a5,a5,a3
80004c22:	c3d8                	sw	a4,4(a5)
    return status_success;
80004c24:	4781                	li	a5,0

80004c26 <.L9>:
}
80004c26:	853e                	mv	a0,a5
80004c28:	6105                	add	sp,sp,32
80004c2a:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

80004c5e <read_pmp_cfg>:
 */
#include "hpm_pmp_drv.h"
#include "hpm_csr_drv.h"

uint32_t read_pmp_cfg(uint32_t idx)
{
80004c5e:	7179                	add	sp,sp,-48
80004c60:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
80004c62:	d602                	sw	zero,44(sp)
    switch (idx) {
80004c64:	4732                	lw	a4,12(sp)
80004c66:	478d                	li	a5,3
80004c68:	04f70763          	beq	a4,a5,80004cb6 <.L2>
80004c6c:	4732                	lw	a4,12(sp)
80004c6e:	478d                	li	a5,3
80004c70:	04e7e963          	bltu	a5,a4,80004cc2 <.L9>
80004c74:	4732                	lw	a4,12(sp)
80004c76:	4789                	li	a5,2
80004c78:	02f70963          	beq	a4,a5,80004caa <.L4>
80004c7c:	4732                	lw	a4,12(sp)
80004c7e:	4789                	li	a5,2
80004c80:	04e7e163          	bltu	a5,a4,80004cc2 <.L9>
80004c84:	47b2                	lw	a5,12(sp)
80004c86:	c791                	beqz	a5,80004c92 <.L5>
80004c88:	4732                	lw	a4,12(sp)
80004c8a:	4785                	li	a5,1
80004c8c:	00f70963          	beq	a4,a5,80004c9e <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
80004c90:	a80d                	j	80004cc2 <.L9>

80004c92 <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
80004c92:	3a0027f3          	csrr	a5,pmpcfg0
80004c96:	ce3e                	sw	a5,28(sp)
80004c98:	47f2                	lw	a5,28(sp)

80004c9a <.LBE2>:
80004c9a:	d63e                	sw	a5,44(sp)
        break;
80004c9c:	a025                	j	80004cc4 <.L7>

80004c9e <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
80004c9e:	3a1027f3          	csrr	a5,pmpcfg1
80004ca2:	d03e                	sw	a5,32(sp)
80004ca4:	5782                	lw	a5,32(sp)

80004ca6 <.LBE3>:
80004ca6:	d63e                	sw	a5,44(sp)
        break;
80004ca8:	a831                	j	80004cc4 <.L7>

80004caa <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
80004caa:	3a2027f3          	csrr	a5,pmpcfg2
80004cae:	d23e                	sw	a5,36(sp)
80004cb0:	5792                	lw	a5,36(sp)

80004cb2 <.LBE4>:
80004cb2:	d63e                	sw	a5,44(sp)
        break;
80004cb4:	a801                	j	80004cc4 <.L7>

80004cb6 <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
80004cb6:	3a3027f3          	csrr	a5,pmpcfg3
80004cba:	d43e                	sw	a5,40(sp)
80004cbc:	57a2                	lw	a5,40(sp)

80004cbe <.LBE5>:
80004cbe:	d63e                	sw	a5,44(sp)
        break;
80004cc0:	a011                	j	80004cc4 <.L7>

80004cc2 <.L9>:
        break;
80004cc2:	0001                	nop

80004cc4 <.L7>:
    }
    return pmp_cfg;
80004cc4:	57b2                	lw	a5,44(sp)
}
80004cc6:	853e                	mv	a0,a5
80004cc8:	6145                	add	sp,sp,48
80004cca:	8082                	ret

Disassembly of section .text.write_pmp_addr:

80004cea <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
80004cea:	1141                	add	sp,sp,-16
80004cec:	c62a                	sw	a0,12(sp)
80004cee:	c42e                	sw	a1,8(sp)
    switch (idx) {
80004cf0:	4722                	lw	a4,8(sp)
80004cf2:	47bd                	li	a5,15
80004cf4:	08e7ec63          	bltu	a5,a4,80004d8c <.L38>
80004cf8:	47a2                	lw	a5,8(sp)
80004cfa:	00279713          	sll	a4,a5,0x2
80004cfe:	800037b7          	lui	a5,0x80003
80004d02:	3d878793          	add	a5,a5,984 # 800033d8 <.L21>
80004d06:	97ba                	add	a5,a5,a4
80004d08:	439c                	lw	a5,0(a5)
80004d0a:	8782                	jr	a5

80004d0c <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
80004d0c:	47b2                	lw	a5,12(sp)
80004d0e:	3b079073          	csrw	pmpaddr0,a5
        break;
80004d12:	a8b5                	j	80004d8e <.L37>

80004d14 <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
80004d14:	47b2                	lw	a5,12(sp)
80004d16:	3b179073          	csrw	pmpaddr1,a5
        break;
80004d1a:	a895                	j	80004d8e <.L37>

80004d1c <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
80004d1c:	47b2                	lw	a5,12(sp)
80004d1e:	3b279073          	csrw	pmpaddr2,a5
        break;
80004d22:	a0b5                	j	80004d8e <.L37>

80004d24 <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
80004d24:	47b2                	lw	a5,12(sp)
80004d26:	3b379073          	csrw	pmpaddr3,a5
        break;
80004d2a:	a095                	j	80004d8e <.L37>

80004d2c <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
80004d2c:	47b2                	lw	a5,12(sp)
80004d2e:	3b479073          	csrw	pmpaddr4,a5
        break;
80004d32:	a8b1                	j	80004d8e <.L37>

80004d34 <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
80004d34:	47b2                	lw	a5,12(sp)
80004d36:	3b579073          	csrw	pmpaddr5,a5
        break;
80004d3a:	a891                	j	80004d8e <.L37>

80004d3c <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
80004d3c:	47b2                	lw	a5,12(sp)
80004d3e:	3b679073          	csrw	pmpaddr6,a5
        break;
80004d42:	a0b1                	j	80004d8e <.L37>

80004d44 <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
80004d44:	47b2                	lw	a5,12(sp)
80004d46:	3b779073          	csrw	pmpaddr7,a5
        break;
80004d4a:	a091                	j	80004d8e <.L37>

80004d4c <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
80004d4c:	47b2                	lw	a5,12(sp)
80004d4e:	3b879073          	csrw	pmpaddr8,a5
        break;
80004d52:	a835                	j	80004d8e <.L37>

80004d54 <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
80004d54:	47b2                	lw	a5,12(sp)
80004d56:	3b979073          	csrw	pmpaddr9,a5
        break;
80004d5a:	a815                	j	80004d8e <.L37>

80004d5c <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
80004d5c:	47b2                	lw	a5,12(sp)
80004d5e:	3ba79073          	csrw	pmpaddr10,a5
        break;
80004d62:	a035                	j	80004d8e <.L37>

80004d64 <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
80004d64:	47b2                	lw	a5,12(sp)
80004d66:	3bb79073          	csrw	pmpaddr11,a5
        break;
80004d6a:	a015                	j	80004d8e <.L37>

80004d6c <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
80004d6c:	47b2                	lw	a5,12(sp)
80004d6e:	3bc79073          	csrw	pmpaddr12,a5
        break;
80004d72:	a831                	j	80004d8e <.L37>

80004d74 <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
80004d74:	47b2                	lw	a5,12(sp)
80004d76:	3bd79073          	csrw	pmpaddr13,a5
        break;
80004d7a:	a811                	j	80004d8e <.L37>

80004d7c <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
80004d7c:	47b2                	lw	a5,12(sp)
80004d7e:	3be79073          	csrw	pmpaddr14,a5
        break;
80004d82:	a031                	j	80004d8e <.L37>

80004d84 <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
80004d84:	47b2                	lw	a5,12(sp)
80004d86:	3bf79073          	csrw	pmpaddr15,a5
        break;
80004d8a:	a011                	j	80004d8e <.L37>

80004d8c <.L38>:
    default:
        /* Do nothing */
        break;
80004d8c:	0001                	nop

80004d8e <.L37>:
    }
}
80004d8e:	0001                	nop
80004d90:	0141                	add	sp,sp,16
80004d92:	8082                	ret

Disassembly of section .text.read_pma_cfg:

80004da2 <read_pma_cfg>:
    return ret_val;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
80004da2:	7179                	add	sp,sp,-48
80004da4:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
80004da6:	d602                	sw	zero,44(sp)
    switch (idx) {
80004da8:	4732                	lw	a4,12(sp)
80004daa:	478d                	li	a5,3
80004dac:	04f70763          	beq	a4,a5,80004dfa <.L62>
80004db0:	4732                	lw	a4,12(sp)
80004db2:	478d                	li	a5,3
80004db4:	04e7e963          	bltu	a5,a4,80004e06 <.L69>
80004db8:	4732                	lw	a4,12(sp)
80004dba:	4789                	li	a5,2
80004dbc:	02f70963          	beq	a4,a5,80004dee <.L64>
80004dc0:	4732                	lw	a4,12(sp)
80004dc2:	4789                	li	a5,2
80004dc4:	04e7e163          	bltu	a5,a4,80004e06 <.L69>
80004dc8:	47b2                	lw	a5,12(sp)
80004dca:	c791                	beqz	a5,80004dd6 <.L65>
80004dcc:	4732                	lw	a4,12(sp)
80004dce:	4785                	li	a5,1
80004dd0:	00f70963          	beq	a4,a5,80004de2 <.L66>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
80004dd4:	a80d                	j	80004e06 <.L69>

80004dd6 <.L65>:
        pma_cfg = read_csr(CSR_PMACFG0);
80004dd6:	bc0027f3          	csrr	a5,0xbc0
80004dda:	ce3e                	sw	a5,28(sp)
80004ddc:	47f2                	lw	a5,28(sp)

80004dde <.LBE22>:
80004dde:	d63e                	sw	a5,44(sp)
        break;
80004de0:	a025                	j	80004e08 <.L67>

80004de2 <.L66>:
        pma_cfg = read_csr(CSR_PMACFG1);
80004de2:	bc1027f3          	csrr	a5,0xbc1
80004de6:	d03e                	sw	a5,32(sp)
80004de8:	5782                	lw	a5,32(sp)

80004dea <.LBE23>:
80004dea:	d63e                	sw	a5,44(sp)
        break;
80004dec:	a831                	j	80004e08 <.L67>

80004dee <.L64>:
        pma_cfg = read_csr(CSR_PMACFG2);
80004dee:	bc2027f3          	csrr	a5,0xbc2
80004df2:	d23e                	sw	a5,36(sp)
80004df4:	5792                	lw	a5,36(sp)

80004df6 <.LBE24>:
80004df6:	d63e                	sw	a5,44(sp)
        break;
80004df8:	a801                	j	80004e08 <.L67>

80004dfa <.L62>:
        pma_cfg = read_csr(CSR_PMACFG3);
80004dfa:	bc3027f3          	csrr	a5,0xbc3
80004dfe:	d43e                	sw	a5,40(sp)
80004e00:	57a2                	lw	a5,40(sp)

80004e02 <.LBE25>:
80004e02:	d63e                	sw	a5,44(sp)
        break;
80004e04:	a011                	j	80004e08 <.L67>

80004e06 <.L69>:
        break;
80004e06:	0001                	nop

80004e08 <.L67>:
    }
    return pma_cfg;
80004e08:	57b2                	lw	a5,44(sp)
}
80004e0a:	853e                	mv	a0,a5
80004e0c:	6145                	add	sp,sp,48
80004e0e:	8082                	ret

Disassembly of section .text.write_pma_addr:

80004e1a <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
80004e1a:	1141                	add	sp,sp,-16
80004e1c:	c62a                	sw	a0,12(sp)
80004e1e:	c42e                	sw	a1,8(sp)
    switch (idx) {
80004e20:	4722                	lw	a4,8(sp)
80004e22:	47bd                	li	a5,15
80004e24:	08e7ec63          	bltu	a5,a4,80004ebc <.L98>
80004e28:	47a2                	lw	a5,8(sp)
80004e2a:	00279713          	sll	a4,a5,0x2
80004e2e:	800037b7          	lui	a5,0x80003
80004e32:	41878793          	add	a5,a5,1048 # 80003418 <.L81>
80004e36:	97ba                	add	a5,a5,a4
80004e38:	439c                	lw	a5,0(a5)
80004e3a:	8782                	jr	a5

80004e3c <.L96>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
80004e3c:	47b2                	lw	a5,12(sp)
80004e3e:	bd079073          	csrw	0xbd0,a5
        break;
80004e42:	a8b5                	j	80004ebe <.L97>

80004e44 <.L95>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
80004e44:	47b2                	lw	a5,12(sp)
80004e46:	bd179073          	csrw	0xbd1,a5
        break;
80004e4a:	a895                	j	80004ebe <.L97>

80004e4c <.L94>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
80004e4c:	47b2                	lw	a5,12(sp)
80004e4e:	bd279073          	csrw	0xbd2,a5
        break;
80004e52:	a0b5                	j	80004ebe <.L97>

80004e54 <.L93>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
80004e54:	47b2                	lw	a5,12(sp)
80004e56:	bd379073          	csrw	0xbd3,a5
        break;
80004e5a:	a095                	j	80004ebe <.L97>

80004e5c <.L92>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
80004e5c:	47b2                	lw	a5,12(sp)
80004e5e:	bd479073          	csrw	0xbd4,a5
        break;
80004e62:	a8b1                	j	80004ebe <.L97>

80004e64 <.L91>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
80004e64:	47b2                	lw	a5,12(sp)
80004e66:	bd579073          	csrw	0xbd5,a5
        break;
80004e6a:	a891                	j	80004ebe <.L97>

80004e6c <.L90>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
80004e6c:	47b2                	lw	a5,12(sp)
80004e6e:	bd679073          	csrw	0xbd6,a5
        break;
80004e72:	a0b1                	j	80004ebe <.L97>

80004e74 <.L89>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
80004e74:	47b2                	lw	a5,12(sp)
80004e76:	bd779073          	csrw	0xbd7,a5
        break;
80004e7a:	a091                	j	80004ebe <.L97>

80004e7c <.L88>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
80004e7c:	47b2                	lw	a5,12(sp)
80004e7e:	bd879073          	csrw	0xbd8,a5
        break;
80004e82:	a835                	j	80004ebe <.L97>

80004e84 <.L87>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
80004e84:	47b2                	lw	a5,12(sp)
80004e86:	bd979073          	csrw	0xbd9,a5
        break;
80004e8a:	a815                	j	80004ebe <.L97>

80004e8c <.L86>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
80004e8c:	47b2                	lw	a5,12(sp)
80004e8e:	bda79073          	csrw	0xbda,a5
        break;
80004e92:	a035                	j	80004ebe <.L97>

80004e94 <.L85>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
80004e94:	47b2                	lw	a5,12(sp)
80004e96:	bdb79073          	csrw	0xbdb,a5
        break;
80004e9a:	a015                	j	80004ebe <.L97>

80004e9c <.L84>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
80004e9c:	47b2                	lw	a5,12(sp)
80004e9e:	bdc79073          	csrw	0xbdc,a5
        break;
80004ea2:	a831                	j	80004ebe <.L97>

80004ea4 <.L83>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
80004ea4:	47b2                	lw	a5,12(sp)
80004ea6:	bdd79073          	csrw	0xbdd,a5
        break;
80004eaa:	a811                	j	80004ebe <.L97>

80004eac <.L82>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
80004eac:	47b2                	lw	a5,12(sp)
80004eae:	bde79073          	csrw	0xbde,a5
        break;
80004eb2:	a031                	j	80004ebe <.L97>

80004eb4 <.L80>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
80004eb4:	47b2                	lw	a5,12(sp)
80004eb6:	bdf79073          	csrw	0xbdf,a5
        break;
80004eba:	a011                	j	80004ebe <.L97>

80004ebc <.L98>:
    default:
        /* Do nothing */
        break;
80004ebc:	0001                	nop

80004ebe <.L97>:
    }
}
80004ebe:	0001                	nop
80004ec0:	0141                	add	sp,sp,16
80004ec2:	8082                	ret

Disassembly of section .text.pmp_config:

80004ece <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
80004ece:	7139                	add	sp,sp,-64
80004ed0:	de06                	sw	ra,60(sp)
80004ed2:	c62a                	sw	a0,12(sp)
80004ed4:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
80004ed6:	4789                	li	a5,2
80004ed8:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > 15U));
80004eda:	47b2                	lw	a5,12(sp)
80004edc:	cfcd                	beqz	a5,80004f96 <.L125>
80004ede:	47a2                	lw	a5,8(sp)
80004ee0:	cbdd                	beqz	a5,80004f96 <.L125>
80004ee2:	4722                	lw	a4,8(sp)
80004ee4:	47bd                	li	a5,15
80004ee6:	0ae7e863          	bltu	a5,a4,80004f96 <.L125>

80004eea <.LBB43>:

        for (uint32_t i = 0; i < num_of_entries; i++) {
80004eea:	d402                	sw	zero,40(sp)
80004eec:	a871                	j	80004f88 <.L126>

80004eee <.L127>:
            uint32_t idx = i / 4;
80004eee:	57a2                	lw	a5,40(sp)
80004ef0:	8389                	srl	a5,a5,0x2
80004ef2:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
80004ef4:	57a2                	lw	a5,40(sp)
80004ef6:	078e                	sll	a5,a5,0x3
80004ef8:	8be1                	and	a5,a5,24
80004efa:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
80004efc:	5512                	lw	a0,36(sp)
80004efe:	3385                	jal	80004c5e <read_pmp_cfg>
80004f00:	ce2a                	sw	a0,28(sp)
            pmp_cfg &= ~(0xFFUL << offset);
80004f02:	5782                	lw	a5,32(sp)
80004f04:	0ff00713          	li	a4,255
80004f08:	00f717b3          	sll	a5,a4,a5
80004f0c:	fff7c793          	not	a5,a5
80004f10:	4772                	lw	a4,28(sp)
80004f12:	8ff9                	and	a5,a5,a4
80004f14:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t) entry->pmp_cfg.val) << offset;
80004f16:	47b2                	lw	a5,12(sp)
80004f18:	0007c783          	lbu	a5,0(a5)
80004f1c:	873e                	mv	a4,a5
80004f1e:	5782                	lw	a5,32(sp)
80004f20:	00f717b3          	sll	a5,a4,a5
80004f24:	4772                	lw	a4,28(sp)
80004f26:	8fd9                	or	a5,a5,a4
80004f28:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
80004f2a:	47b2                	lw	a5,12(sp)
80004f2c:	43dc                	lw	a5,4(a5)
80004f2e:	55a2                	lw	a1,40(sp)
80004f30:	853e                	mv	a0,a5
80004f32:	3b65                	jal	80004cea <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
80004f34:	5592                	lw	a1,36(sp)
80004f36:	4572                	lw	a0,28(sp)
80004f38:	151040ef          	jal	80009888 <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
80004f3c:	5512                	lw	a0,36(sp)
80004f3e:	3595                	jal	80004da2 <read_pma_cfg>
80004f40:	cc2a                	sw	a0,24(sp)
            pma_cfg &= ~(0xFFUL << offset);
80004f42:	5782                	lw	a5,32(sp)
80004f44:	0ff00713          	li	a4,255
80004f48:	00f717b3          	sll	a5,a4,a5
80004f4c:	fff7c793          	not	a5,a5
80004f50:	4762                	lw	a4,24(sp)
80004f52:	8ff9                	and	a5,a5,a4
80004f54:	cc3e                	sw	a5,24(sp)
            pma_cfg |= ((uint32_t) entry->pma_cfg.val) << offset;
80004f56:	47b2                	lw	a5,12(sp)
80004f58:	0087c783          	lbu	a5,8(a5)
80004f5c:	873e                	mv	a4,a5
80004f5e:	5782                	lw	a5,32(sp)
80004f60:	00f717b3          	sll	a5,a4,a5
80004f64:	4762                	lw	a4,24(sp)
80004f66:	8fd9                	or	a5,a5,a4
80004f68:	cc3e                	sw	a5,24(sp)
            write_pma_cfg(pma_cfg, idx);
80004f6a:	5592                	lw	a1,36(sp)
80004f6c:	4562                	lw	a0,24(sp)
80004f6e:	177040ef          	jal	800098e4 <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
80004f72:	47b2                	lw	a5,12(sp)
80004f74:	47dc                	lw	a5,12(a5)
80004f76:	55a2                	lw	a1,40(sp)
80004f78:	853e                	mv	a0,a5
80004f7a:	3545                	jal	80004e1a <write_pma_addr>
#endif
            ++entry;
80004f7c:	47b2                	lw	a5,12(sp)
80004f7e:	07c1                	add	a5,a5,16
80004f80:	c63e                	sw	a5,12(sp)

80004f82 <.LBE44>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
80004f82:	57a2                	lw	a5,40(sp)
80004f84:	0785                	add	a5,a5,1
80004f86:	d43e                	sw	a5,40(sp)

80004f88 <.L126>:
80004f88:	5722                	lw	a4,40(sp)
80004f8a:	47a2                	lw	a5,8(sp)
80004f8c:	f6f761e3          	bltu	a4,a5,80004eee <.L127>

80004f90 <.LBE43>:
        }
        fencei();
80004f90:	0000100f          	fence.i

        status = status_success;
80004f94:	d602                	sw	zero,44(sp)

80004f96 <.L125>:

    } while (false);

    return status;
80004f96:	57b2                	lw	a5,44(sp)
}
80004f98:	853e                	mv	a0,a5
80004f9a:	50f2                	lw	ra,60(sp)
80004f9c:	6121                	add	sp,sp,64
80004f9e:	8082                	ret

Disassembly of section .text.uart_default_config:

80005234 <uart_default_config>:
#ifndef UART_SOC_OVERSAMPLE_MAX
#define UART_SOC_OVERSAMPLE_MAX HPM_UART_OSC_MAX
#endif

void uart_default_config(UART_Type *ptr, uart_config_t *config)
{
80005234:	1141                	add	sp,sp,-16
80005236:	c62a                	sw	a0,12(sp)
80005238:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->baudrate = 115200;
8000523a:	47a2                	lw	a5,8(sp)
8000523c:	6771                	lui	a4,0x1c
8000523e:	20070713          	add	a4,a4,512 # 1c200 <__XPI0_segment_used_size__+0xee48>
80005242:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80005244:	47a2                	lw	a5,8(sp)
80005246:	470d                	li	a4,3
80005248:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
8000524c:	47a2                	lw	a5,8(sp)
8000524e:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80005252:	47a2                	lw	a5,8(sp)
80005254:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
80005258:	47a2                	lw	a5,8(sp)
8000525a:	4705                	li	a4,1
8000525c:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
80005260:	47a2                	lw	a5,8(sp)
80005262:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
80005266:	47a2                	lw	a5,8(sp)
80005268:	000785a3          	sb	zero,11(a5)
    config->dma_enable = false;
8000526c:	47a2                	lw	a5,8(sp)
8000526e:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
80005272:	47a2                	lw	a5,8(sp)
80005274:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
80005278:	47a2                	lw	a5,8(sp)
8000527a:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
8000527e:	47a2                	lw	a5,8(sp)
80005280:	000788a3          	sb	zero,17(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
#endif
#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    config->rx_enable = true;
#endif
}
80005284:	0001                	nop
80005286:	0141                	add	sp,sp,16
80005288:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

8000528a <uart_calculate_baudrate>:

static bool uart_calculate_baudrate(uint32_t freq, uint32_t baudrate, uint16_t *div_out, uint8_t *osc_out)
{
8000528a:	7179                	add	sp,sp,-48
8000528c:	d606                	sw	ra,44(sp)
8000528e:	d422                	sw	s0,40(sp)
80005290:	c62a                	sw	a0,12(sp)
80005292:	c42e                	sw	a1,8(sp)
80005294:	c232                	sw	a2,4(sp)
80005296:	c036                	sw	a3,0(sp)
    uint16_t div, osc, delta;
    float tmp;
    if ((div_out == NULL) || (!freq) || (!baudrate)
80005298:	4792                	lw	a5,4(sp)
8000529a:	cb85                	beqz	a5,800052ca <.L4>
8000529c:	47b2                	lw	a5,12(sp)
8000529e:	c795                	beqz	a5,800052ca <.L4>
800052a0:	47a2                	lw	a5,8(sp)
800052a2:	c785                	beqz	a5,800052ca <.L4>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
800052a4:	4722                	lw	a4,8(sp)
800052a6:	0c700793          	li	a5,199
800052aa:	02e7f063          	bgeu	a5,a4,800052ca <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
800052ae:	47a2                	lw	a5,8(sp)
800052b0:	078e                	sll	a5,a5,0x3
800052b2:	4732                	lw	a4,12(sp)
800052b4:	00f76b63          	bltu	a4,a5,800052ca <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
800052b8:	4732                	lw	a4,12(sp)
800052ba:	67c1                	lui	a5,0x10
800052bc:	17fd                	add	a5,a5,-1 # ffff <__XPI0_segment_used_size__+0x2c47>
800052be:	02f75733          	divu	a4,a4,a5
800052c2:	47a2                	lw	a5,8(sp)
800052c4:	0796                	sll	a5,a5,0x5
800052c6:	00e7f463          	bgeu	a5,a4,800052ce <.L5>

800052ca <.L4>:
        return 0;
800052ca:	4781                	li	a5,0
800052cc:	aa8d                	j	8000543e <.L6>

800052ce <.L5>:
    }

    tmp = (float) freq / baudrate;
800052ce:	4532                	lw	a0,12(sp)
800052d0:	581020ef          	jal	80008050 <__floatunsisf>
800052d4:	842a                	mv	s0,a0
800052d6:	4522                	lw	a0,8(sp)
800052d8:	579020ef          	jal	80008050 <__floatunsisf>
800052dc:	87aa                	mv	a5,a0
800052de:	85be                	mv	a1,a5
800052e0:	8522                	mv	a0,s0
800052e2:	679060ef          	jal	8000c15a <__divsf3>
800052e6:	87aa                	mv	a5,a0
800052e8:	cc3e                	sw	a5,24(sp)

    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
800052ea:	47a1                	li	a5,8
800052ec:	00f11f23          	sh	a5,30(sp)
800052f0:	a281                	j	80005430 <.L7>

800052f2 <.L18>:
        /* osc range: HPM_UART_OSC_MIN - UART_SOC_OVERSAMPLE_MAX, even number */
        delta = 0;
800052f2:	00011e23          	sh	zero,28(sp)
        div = (uint16_t)(tmp / osc);
800052f6:	01e15783          	lhu	a5,30(sp)
800052fa:	853e                	mv	a0,a5
800052fc:	4a1020ef          	jal	80007f9c <__floatsisf>
80005300:	87aa                	mv	a5,a0
80005302:	85be                	mv	a1,a5
80005304:	4562                	lw	a0,24(sp)
80005306:	655060ef          	jal	8000c15a <__divsf3>
8000530a:	87aa                	mv	a5,a0
8000530c:	853e                	mv	a0,a5
8000530e:	42b020ef          	jal	80007f38 <__fixunssfsi>
80005312:	87aa                	mv	a5,a0
80005314:	00f11b23          	sh	a5,22(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN) {
80005318:	01615783          	lhu	a5,22(sp)
8000531c:	10078263          	beqz	a5,80005420 <.L22>
            /* invalid div */
            continue;
        }
        if (div * osc > tmp) {
80005320:	01615703          	lhu	a4,22(sp)
80005324:	01e15783          	lhu	a5,30(sp)
80005328:	02f707b3          	mul	a5,a4,a5
8000532c:	853e                	mv	a0,a5
8000532e:	46f020ef          	jal	80007f9c <__floatsisf>
80005332:	87aa                	mv	a5,a0
80005334:	85be                	mv	a1,a5
80005336:	4562                	lw	a0,24(sp)
80005338:	24f020ef          	jal	80007d86 <__ltsf2>
8000533c:	87aa                	mv	a5,a0
8000533e:	0207d863          	bgez	a5,8000536e <.L21>
            delta = (uint16_t)(div * osc - tmp);
80005342:	01615703          	lhu	a4,22(sp)
80005346:	01e15783          	lhu	a5,30(sp)
8000534a:	02f707b3          	mul	a5,a4,a5
8000534e:	853e                	mv	a0,a5
80005350:	44d020ef          	jal	80007f9c <__floatsisf>
80005354:	87aa                	mv	a5,a0
80005356:	45e2                	lw	a1,24(sp)
80005358:	853e                	mv	a0,a5
8000535a:	06d020ef          	jal	80007bc6 <__subsf3>
8000535e:	87aa                	mv	a5,a0
80005360:	853e                	mv	a0,a5
80005362:	3d7020ef          	jal	80007f38 <__fixunssfsi>
80005366:	87aa                	mv	a5,a0
80005368:	00f11e23          	sh	a5,28(sp)
8000536c:	a0b9                	j	800053ba <.L12>

8000536e <.L21>:
        } else if (div * osc < tmp) {
8000536e:	01615703          	lhu	a4,22(sp)
80005372:	01e15783          	lhu	a5,30(sp)
80005376:	02f707b3          	mul	a5,a4,a5
8000537a:	853e                	mv	a0,a5
8000537c:	421020ef          	jal	80007f9c <__floatsisf>
80005380:	87aa                	mv	a5,a0
80005382:	85be                	mv	a1,a5
80005384:	4562                	lw	a0,24(sp)
80005386:	2b7020ef          	jal	80007e3c <__gtsf2>
8000538a:	87aa                	mv	a5,a0
8000538c:	02f05763          	blez	a5,800053ba <.L12>
            delta = (uint16_t)(tmp - div * osc);
80005390:	01615703          	lhu	a4,22(sp)
80005394:	01e15783          	lhu	a5,30(sp)
80005398:	02f707b3          	mul	a5,a4,a5
8000539c:	853e                	mv	a0,a5
8000539e:	3ff020ef          	jal	80007f9c <__floatsisf>
800053a2:	87aa                	mv	a5,a0
800053a4:	85be                	mv	a1,a5
800053a6:	4562                	lw	a0,24(sp)
800053a8:	01f020ef          	jal	80007bc6 <__subsf3>
800053ac:	87aa                	mv	a5,a0
800053ae:	853e                	mv	a0,a5
800053b0:	389020ef          	jal	80007f38 <__fixunssfsi>
800053b4:	87aa                	mv	a5,a0
800053b6:	00f11e23          	sh	a5,28(sp)

800053ba <.L12>:
        }
        if (delta && ((delta * 100 / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
800053ba:	01c15783          	lhu	a5,28(sp)
800053be:	cb9d                	beqz	a5,800053f4 <.L14>
800053c0:	01c15703          	lhu	a4,28(sp)
800053c4:	06400793          	li	a5,100
800053c8:	02f707b3          	mul	a5,a4,a5
800053cc:	853e                	mv	a0,a5
800053ce:	3cf020ef          	jal	80007f9c <__floatsisf>
800053d2:	87aa                	mv	a5,a0
800053d4:	45e2                	lw	a1,24(sp)
800053d6:	853e                	mv	a0,a5
800053d8:	583060ef          	jal	8000c15a <__divsf3>
800053dc:	87aa                	mv	a5,a0
800053de:	873e                	mv	a4,a5
800053e0:	800037b7          	lui	a5,0x80003
800053e4:	07c7a583          	lw	a1,124(a5) # 8000307c <.LC0>
800053e8:	853a                	mv	a0,a4
800053ea:	253020ef          	jal	80007e3c <__gtsf2>
800053ee:	87aa                	mv	a5,a0
800053f0:	02f04a63          	bgtz	a5,80005424 <.L23>

800053f4 <.L14>:
            continue;
        } else {
            *div_out = div;
800053f4:	4792                	lw	a5,4(sp)
800053f6:	01615703          	lhu	a4,22(sp)
800053fa:	00e79023          	sh	a4,0(a5)
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
800053fe:	01e15703          	lhu	a4,30(sp)
80005402:	02000793          	li	a5,32
80005406:	00f70763          	beq	a4,a5,80005414 <.L16>
8000540a:	01e15783          	lhu	a5,30(sp)
8000540e:	0ff7f793          	zext.b	a5,a5
80005412:	a011                	j	80005416 <.L17>

80005414 <.L16>:
80005414:	4781                	li	a5,0

80005416 <.L17>:
80005416:	4702                	lw	a4,0(sp)
80005418:	00f70023          	sb	a5,0(a4)
            return true;
8000541c:	4785                	li	a5,1
8000541e:	a005                	j	8000543e <.L6>

80005420 <.L22>:
            continue;
80005420:	0001                	nop
80005422:	a011                	j	80005426 <.L9>

80005424 <.L23>:
            continue;
80005424:	0001                	nop

80005426 <.L9>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80005426:	01e15783          	lhu	a5,30(sp)
8000542a:	0789                	add	a5,a5,2
8000542c:	00f11f23          	sh	a5,30(sp)

80005430 <.L7>:
80005430:	01e15703          	lhu	a4,30(sp)
80005434:	02000793          	li	a5,32
80005438:	eae7fde3          	bgeu	a5,a4,800052f2 <.L18>
        }
    }
    return false;
8000543c:	4781                	li	a5,0

8000543e <.L6>:
}
8000543e:	853e                	mv	a0,a5
80005440:	50b2                	lw	ra,44(sp)
80005442:	5422                	lw	s0,40(sp)
80005444:	6145                	add	sp,sp,48
80005446:	8082                	ret

Disassembly of section .text.uart_send_byte:

80005448 <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
80005448:	1101                	add	sp,sp,-32
8000544a:	c62a                	sw	a0,12(sp)
8000544c:	87ae                	mv	a5,a1
8000544e:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
80005452:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
80005454:	a811                	j	80005468 <.L49>

80005456 <.L52>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
80005456:	4772                	lw	a4,28(sp)
80005458:	6785                	lui	a5,0x1
8000545a:	38878793          	add	a5,a5,904 # 1388 <.L154+0xa>
8000545e:	00e7eb63          	bltu	a5,a4,80005474 <.L55>
            break;
        }
        retry++;
80005462:	47f2                	lw	a5,28(sp)
80005464:	0785                	add	a5,a5,1
80005466:	ce3e                	sw	a5,28(sp)

80005468 <.L49>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
80005468:	47b2                	lw	a5,12(sp)
8000546a:	5bdc                	lw	a5,52(a5)
8000546c:	0207f793          	and	a5,a5,32
80005470:	d3fd                	beqz	a5,80005456 <.L52>
80005472:	a011                	j	80005476 <.L51>

80005474 <.L55>:
            break;
80005474:	0001                	nop

80005476 <.L51>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
80005476:	4772                	lw	a4,28(sp)
80005478:	6785                	lui	a5,0x1
8000547a:	38878793          	add	a5,a5,904 # 1388 <.L154+0xa>
8000547e:	00e7f463          	bgeu	a5,a4,80005486 <.L53>
        return status_timeout;
80005482:	478d                	li	a5,3
80005484:	a031                	j	80005490 <.L54>

80005486 <.L53>:
    }

    ptr->THR = UART_THR_THR_SET(c);
80005486:	00b14703          	lbu	a4,11(sp)
8000548a:	47b2                	lw	a5,12(sp)
8000548c:	d398                	sw	a4,32(a5)
    return status_success;
8000548e:	4781                	li	a5,0

80005490 <.L54>:
}
80005490:	853e                	mv	a0,a5
80005492:	6105                	add	sp,sp,32
80005494:	8082                	ret

Disassembly of section .text.usb_dcd_connect:

80005496 <usb_dcd_connect>:
    ptr->USBINTR = 0;
}

/* Connect by enabling internal pull-up resistor on D+/D- */
void usb_dcd_connect(USB_Type *ptr)
{
80005496:	1141                	add	sp,sp,-16
80005498:	c62a                	sw	a0,12(sp)
    ptr->USBCMD |= USB_USBCMD_RS_MASK;
8000549a:	47b2                	lw	a5,12(sp)
8000549c:	1407a783          	lw	a5,320(a5)
800054a0:	0017e713          	or	a4,a5,1
800054a4:	47b2                	lw	a5,12(sp)
800054a6:	14e7a023          	sw	a4,320(a5)
}
800054aa:	0001                	nop
800054ac:	0141                	add	sp,sp,16
800054ae:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_open:

800054b0 <usb_dcd_edpt_open>:
/*---------------------------------------------------------------------
 * Endpoint API
 *---------------------------------------------------------------------
 */
void usb_dcd_edpt_open(USB_Type *ptr, usb_endpoint_config_t *config)
{
800054b0:	1101                	add	sp,sp,-32
800054b2:	c62a                	sw	a0,12(sp)
800054b4:	c42e                	sw	a1,8(sp)
    uint8_t const epnum  = config->ep_addr & 0x0f;
800054b6:	47a2                	lw	a5,8(sp)
800054b8:	0017c783          	lbu	a5,1(a5)
800054bc:	8bbd                	and	a5,a5,15
800054be:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir = (config->ep_addr & 0x80) >> 7;
800054c2:	47a2                	lw	a5,8(sp)
800054c4:	0017c783          	lbu	a5,1(a5)
800054c8:	839d                	srl	a5,a5,0x7
800054ca:	00f10f23          	sb	a5,30(sp)

    /* Enable EP Control */
    uint32_t temp = ptr->ENDPTCTRL[epnum];
800054ce:	01f14783          	lbu	a5,31(sp)
800054d2:	4732                	lw	a4,12(sp)
800054d4:	07078793          	add	a5,a5,112
800054d8:	078a                	sll	a5,a5,0x2
800054da:	97ba                	add	a5,a5,a4
800054dc:	439c                	lw	a5,0(a5)
800054de:	cc3e                	sw	a5,24(sp)
    temp &= ~((0x03 << 2) << (dir ? 16 : 0));
800054e0:	01e14783          	lbu	a5,30(sp)
800054e4:	c789                	beqz	a5,800054ee <.L35>
800054e6:	fff407b7          	lui	a5,0xfff40
800054ea:	17fd                	add	a5,a5,-1 # fff3ffff <__APB_SRAM_segment_end__+0xbe4dfff>
800054ec:	a011                	j	800054f0 <.L36>

800054ee <.L35>:
800054ee:	57cd                	li	a5,-13

800054f0 <.L36>:
800054f0:	4762                	lw	a4,24(sp)
800054f2:	8ff9                	and	a5,a5,a4
800054f4:	cc3e                	sw	a5,24(sp)
    temp |= ((config->xfer << 2) | ENDPTCTRL_ENABLE | ENDPTCTRL_TOGGLE_RESET) << (dir ? 16 : 0);
800054f6:	47a2                	lw	a5,8(sp)
800054f8:	0007c783          	lbu	a5,0(a5)
800054fc:	078a                	sll	a5,a5,0x2
800054fe:	0c07e713          	or	a4,a5,192
80005502:	01e14783          	lbu	a5,30(sp)
80005506:	c399                	beqz	a5,8000550c <.L37>
80005508:	47c1                	li	a5,16
8000550a:	a011                	j	8000550e <.L38>

8000550c <.L37>:
8000550c:	4781                	li	a5,0

8000550e <.L38>:
8000550e:	00f717b3          	sll	a5,a4,a5
80005512:	873e                	mv	a4,a5
80005514:	47e2                	lw	a5,24(sp)
80005516:	8fd9                	or	a5,a5,a4
80005518:	cc3e                	sw	a5,24(sp)
    ptr->ENDPTCTRL[epnum] = temp;
8000551a:	01f14783          	lbu	a5,31(sp)
8000551e:	4732                	lw	a4,12(sp)
80005520:	07078793          	add	a5,a5,112
80005524:	078a                	sll	a5,a5,0x2
80005526:	97ba                	add	a5,a5,a4
80005528:	4762                	lw	a4,24(sp)
8000552a:	c398                	sw	a4,0(a5)
}
8000552c:	0001                	nop
8000552e:	6105                	add	sp,sp,32
80005530:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_stall:

80005532 <usb_dcd_edpt_stall>:
    /* Start transfer */
    ptr->ENDPTPRIME = 1 << offset;
}

void usb_dcd_edpt_stall(USB_Type *ptr, uint8_t ep_addr)
{
80005532:	1101                	add	sp,sp,-32
80005534:	c62a                	sw	a0,12(sp)
80005536:	87ae                	mv	a5,a1
80005538:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
8000553c:	00b14783          	lbu	a5,11(sp)
80005540:	8bbd                	and	a5,a5,15
80005542:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
80005546:	00b14783          	lbu	a5,11(sp)
8000554a:	839d                	srl	a5,a5,0x7
8000554c:	00f10f23          	sb	a5,30(sp)

    ptr->ENDPTCTRL[epnum] |= ENDPTCTRL_STALL << (dir ? 16 : 0);
80005550:	01f14783          	lbu	a5,31(sp)
80005554:	4732                	lw	a4,12(sp)
80005556:	07078793          	add	a5,a5,112
8000555a:	078a                	sll	a5,a5,0x2
8000555c:	97ba                	add	a5,a5,a4
8000555e:	4398                	lw	a4,0(a5)
80005560:	01e14783          	lbu	a5,30(sp)
80005564:	c399                	beqz	a5,8000556a <.L45>
80005566:	67c1                	lui	a5,0x10
80005568:	a011                	j	8000556c <.L46>

8000556a <.L45>:
8000556a:	4785                	li	a5,1

8000556c <.L46>:
8000556c:	01f14603          	lbu	a2,31(sp)
80005570:	8f5d                	or	a4,a4,a5
80005572:	46b2                	lw	a3,12(sp)
80005574:	07060793          	add	a5,a2,112
80005578:	078a                	sll	a5,a5,0x2
8000557a:	97b6                	add	a5,a5,a3
8000557c:	c398                	sw	a4,0(a5)
}
8000557e:	0001                	nop
80005580:	6105                	add	sp,sp,32
80005582:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_clear_stall:

80005584 <usb_dcd_edpt_clear_stall>:

void usb_dcd_edpt_clear_stall(USB_Type *ptr, uint8_t ep_addr)
{
80005584:	1101                	add	sp,sp,-32
80005586:	c62a                	sw	a0,12(sp)
80005588:	87ae                	mv	a5,a1
8000558a:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
8000558e:	00b14783          	lbu	a5,11(sp)
80005592:	8bbd                	and	a5,a5,15
80005594:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
80005598:	00b14783          	lbu	a5,11(sp)
8000559c:	839d                	srl	a5,a5,0x7
8000559e:	00f10f23          	sb	a5,30(sp)

    /* data toggle also need to be reset */
    ptr->ENDPTCTRL[epnum] |= ENDPTCTRL_TOGGLE_RESET << (dir ? 16 : 0);
800055a2:	01f14783          	lbu	a5,31(sp)
800055a6:	4732                	lw	a4,12(sp)
800055a8:	07078793          	add	a5,a5,112 # 10070 <__XPI0_segment_used_size__+0x2cb8>
800055ac:	078a                	sll	a5,a5,0x2
800055ae:	97ba                	add	a5,a5,a4
800055b0:	4398                	lw	a4,0(a5)
800055b2:	01e14783          	lbu	a5,30(sp)
800055b6:	c781                	beqz	a5,800055be <.L48>
800055b8:	004007b7          	lui	a5,0x400
800055bc:	a019                	j	800055c2 <.L49>

800055be <.L48>:
800055be:	04000793          	li	a5,64

800055c2 <.L49>:
800055c2:	01f14603          	lbu	a2,31(sp)
800055c6:	8f5d                	or	a4,a4,a5
800055c8:	46b2                	lw	a3,12(sp)
800055ca:	07060793          	add	a5,a2,112
800055ce:	078a                	sll	a5,a5,0x2
800055d0:	97b6                	add	a5,a5,a3
800055d2:	c398                	sw	a4,0(a5)
    ptr->ENDPTCTRL[epnum] &= ~(ENDPTCTRL_STALL << (dir  ? 16 : 0));
800055d4:	01f14783          	lbu	a5,31(sp)
800055d8:	4732                	lw	a4,12(sp)
800055da:	07078793          	add	a5,a5,112 # 400070 <__DLM_segment_end__+0x340070>
800055de:	078a                	sll	a5,a5,0x2
800055e0:	97ba                	add	a5,a5,a4
800055e2:	4398                	lw	a4,0(a5)
800055e4:	01e14783          	lbu	a5,30(sp)
800055e8:	c781                	beqz	a5,800055f0 <.L50>
800055ea:	77c1                	lui	a5,0xffff0
800055ec:	17fd                	add	a5,a5,-1 # fffeffff <__APB_SRAM_segment_end__+0xbefdfff>
800055ee:	a011                	j	800055f2 <.L51>

800055f0 <.L50>:
800055f0:	57f9                	li	a5,-2

800055f2 <.L51>:
800055f2:	01f14603          	lbu	a2,31(sp)
800055f6:	8f7d                	and	a4,a4,a5
800055f8:	46b2                	lw	a3,12(sp)
800055fa:	07060793          	add	a5,a2,112
800055fe:	078a                	sll	a5,a5,0x2
80005600:	97b6                	add	a5,a5,a3
80005602:	c398                	sw	a4,0(a5)
}
80005604:	0001                	nop
80005606:	6105                	add	sp,sp,32
80005608:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_check_stall:

8000560a <usb_dcd_edpt_check_stall>:

bool usb_dcd_edpt_check_stall(USB_Type *ptr, uint8_t ep_addr)
{
8000560a:	1101                	add	sp,sp,-32
8000560c:	c62a                	sw	a0,12(sp)
8000560e:	87ae                	mv	a5,a1
80005610:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
80005614:	00b14783          	lbu	a5,11(sp)
80005618:	8bbd                	and	a5,a5,15
8000561a:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
8000561e:	00b14783          	lbu	a5,11(sp)
80005622:	839d                	srl	a5,a5,0x7
80005624:	00f10f23          	sb	a5,30(sp)

    return (ptr->ENDPTCTRL[epnum] & (ENDPTCTRL_STALL << (dir ? 16 : 0))) ? true : false;
80005628:	01f14783          	lbu	a5,31(sp)
8000562c:	4732                	lw	a4,12(sp)
8000562e:	07078793          	add	a5,a5,112
80005632:	078a                	sll	a5,a5,0x2
80005634:	97ba                	add	a5,a5,a4
80005636:	4398                	lw	a4,0(a5)
80005638:	01e14783          	lbu	a5,30(sp)
8000563c:	c399                	beqz	a5,80005642 <.L53>
8000563e:	67c1                	lui	a5,0x10
80005640:	a011                	j	80005644 <.L54>

80005642 <.L53>:
80005642:	4785                	li	a5,1

80005644 <.L54>:
80005644:	8ff9                	and	a5,a5,a4
80005646:	00f037b3          	snez	a5,a5
8000564a:	0ff7f793          	zext.b	a5,a5
}
8000564e:	853e                	mv	a0,a5
80005650:	6105                	add	sp,sp,32
80005652:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_close:

80005654 <usb_dcd_edpt_close>:

void usb_dcd_edpt_close(USB_Type *ptr, uint8_t ep_addr)
{
80005654:	1101                	add	sp,sp,-32
80005656:	c62a                	sw	a0,12(sp)
80005658:	87ae                	mv	a5,a1
8000565a:	00f105a3          	sb	a5,11(sp)
    uint8_t const epnum = ep_addr & 0x0f;
8000565e:	00b14783          	lbu	a5,11(sp)
80005662:	8bbd                	and	a5,a5,15
80005664:	00f10fa3          	sb	a5,31(sp)
    uint8_t const dir   = (ep_addr & 0x80) >> 7;
80005668:	00b14783          	lbu	a5,11(sp)
8000566c:	839d                	srl	a5,a5,0x7
8000566e:	00f10f23          	sb	a5,30(sp)

    uint32_t primebit = HPM_BITSMASK(1, epnum) << (dir ? 16 : 0);
80005672:	01f14783          	lbu	a5,31(sp)
80005676:	4705                	li	a4,1
80005678:	00f71733          	sll	a4,a4,a5
8000567c:	01e14783          	lbu	a5,30(sp)
80005680:	c399                	beqz	a5,80005686 <.L57>
80005682:	47c1                	li	a5,16
80005684:	a011                	j	80005688 <.L58>

80005686 <.L57>:
80005686:	4781                	li	a5,0

80005688 <.L58>:
80005688:	00f717b3          	sll	a5,a4,a5
8000568c:	cc3e                	sw	a5,24(sp)

8000568e <.L60>:

    /* Flush the endpoint to stop a transfer. */
    do {
        /* Set the corresponding bit(s) in the ENDPTFLUSH register */
        ptr->ENDPTFLUSH |= primebit;
8000568e:	47b2                	lw	a5,12(sp)
80005690:	1b47a703          	lw	a4,436(a5) # 101b4 <__XPI0_segment_used_size__+0x2dfc>
80005694:	47e2                	lw	a5,24(sp)
80005696:	8f5d                	or	a4,a4,a5
80005698:	47b2                	lw	a5,12(sp)
8000569a:	1ae7aa23          	sw	a4,436(a5)

        /* Wait until all bits in the ENDPTFLUSH register are cleared. */
        while (0U != (ptr->ENDPTFLUSH & primebit)) {
8000569e:	0001                	nop

800056a0 <.L59>:
800056a0:	47b2                	lw	a5,12(sp)
800056a2:	1b47a703          	lw	a4,436(a5)
800056a6:	47e2                	lw	a5,24(sp)
800056a8:	8ff9                	and	a5,a5,a4
800056aa:	fbfd                	bnez	a5,800056a0 <.L59>
        /*
         * Read the ENDPTSTAT register to ensure that for all endpoints
         * commanded to be flushed, that the corresponding bits
         * are now cleared.
         */
    } while (0U != (ptr->ENDPTSTAT & primebit));
800056ac:	47b2                	lw	a5,12(sp)
800056ae:	1b87a703          	lw	a4,440(a5)
800056b2:	47e2                	lw	a5,24(sp)
800056b4:	8ff9                	and	a5,a5,a4
800056b6:	ffe1                	bnez	a5,8000568e <.L60>

    /* Disable the endpoint */
    ptr->ENDPTCTRL[epnum] &= ~((ENDPTCTRL_TYPE | ENDPTCTRL_ENABLE | ENDPTCTRL_STALL) << (dir ? 16 : 0));
800056b8:	01f14783          	lbu	a5,31(sp)
800056bc:	4732                	lw	a4,12(sp)
800056be:	07078793          	add	a5,a5,112
800056c2:	078a                	sll	a5,a5,0x2
800056c4:	97ba                	add	a5,a5,a4
800056c6:	4398                	lw	a4,0(a5)
800056c8:	01e14783          	lbu	a5,30(sp)
800056cc:	c789                	beqz	a5,800056d6 <.L61>
800056ce:	ff7307b7          	lui	a5,0xff730
800056d2:	17fd                	add	a5,a5,-1 # ff72ffff <__APB_SRAM_segment_end__+0xb63dfff>
800056d4:	a019                	j	800056da <.L62>

800056d6 <.L61>:
800056d6:	f7200793          	li	a5,-142

800056da <.L62>:
800056da:	01f14603          	lbu	a2,31(sp)
800056de:	8f7d                	and	a4,a4,a5
800056e0:	46b2                	lw	a3,12(sp)
800056e2:	07060793          	add	a5,a2,112
800056e6:	078a                	sll	a5,a5,0x2
800056e8:	97b6                	add	a5,a5,a3
800056ea:	c398                	sw	a4,0(a5)
    ptr->ENDPTCTRL[epnum] |= (usb_xfer_bulk << 2) << (dir ? 16 : 0);
800056ec:	01f14783          	lbu	a5,31(sp)
800056f0:	4732                	lw	a4,12(sp)
800056f2:	07078793          	add	a5,a5,112
800056f6:	078a                	sll	a5,a5,0x2
800056f8:	97ba                	add	a5,a5,a4
800056fa:	4398                	lw	a4,0(a5)
800056fc:	01e14783          	lbu	a5,30(sp)
80005700:	c781                	beqz	a5,80005708 <.L63>
80005702:	000807b7          	lui	a5,0x80
80005706:	a011                	j	8000570a <.L64>

80005708 <.L63>:
80005708:	47a1                	li	a5,8

8000570a <.L64>:
8000570a:	01f14603          	lbu	a2,31(sp)
8000570e:	8f5d                	or	a4,a4,a5
80005710:	46b2                	lw	a3,12(sp)
80005712:	07060793          	add	a5,a2,112
80005716:	078a                	sll	a5,a5,0x2
80005718:	97b6                	add	a5,a5,a3
8000571a:	c398                	sw	a4,0(a5)
}
8000571c:	0001                	nop
8000571e:	6105                	add	sp,sp,32
80005720:	8082                	ret

Disassembly of section .text.usbd_hid_get_report:

80005722 <usbd_hid_get_report>:
 * Non-Boot Keybrd Required    Optional    Required    Required    Optional    Optional
 * Other Device    Required    Optional    Optional    Optional    Optional    Optional
 */

__WEAK void usbd_hid_get_report(uint8_t busid, uint8_t intf, uint8_t report_id, uint8_t report_type, uint8_t **data, uint32_t *len)
{
80005722:	1141                	add	sp,sp,-16
80005724:	c43a                	sw	a4,8(sp)
80005726:	c23e                	sw	a5,4(sp)
80005728:	87aa                	mv	a5,a0
8000572a:	00f107a3          	sb	a5,15(sp)
8000572e:	87ae                	mv	a5,a1
80005730:	00f10723          	sb	a5,14(sp)
80005734:	87b2                	mv	a5,a2
80005736:	00f106a3          	sb	a5,13(sp)
8000573a:	87b6                	mv	a5,a3
8000573c:	00f10623          	sb	a5,12(sp)
    (void)busid;
    (void)intf;
    (void)report_id;
    (void)report_type;
    (*data[0]) = 0;
80005740:	47a2                	lw	a5,8(sp)
80005742:	439c                	lw	a5,0(a5)
80005744:	00078023          	sb	zero,0(a5) # 80000 <__AXI_SRAM_segment_size__>
    *len = 1;
80005748:	4792                	lw	a5,4(sp)
8000574a:	4705                	li	a4,1
8000574c:	c398                	sw	a4,0(a5)
}
8000574e:	0001                	nop
80005750:	0141                	add	sp,sp,16
80005752:	8082                	ret

Disassembly of section .text.usbd_hid_set_idle:

80005754 <usbd_hid_set_idle>:
    (void)report;
    (void)report_len;
}

__WEAK void usbd_hid_set_idle(uint8_t busid, uint8_t intf, uint8_t report_id, uint8_t duration)
{
80005754:	1141                	add	sp,sp,-16
80005756:	87aa                	mv	a5,a0
80005758:	8736                	mv	a4,a3
8000575a:	00f107a3          	sb	a5,15(sp)
8000575e:	87ae                	mv	a5,a1
80005760:	00f10723          	sb	a5,14(sp)
80005764:	87b2                	mv	a5,a2
80005766:	00f106a3          	sb	a5,13(sp)
8000576a:	87ba                	mv	a5,a4
8000576c:	00f10623          	sb	a5,12(sp)
    (void)busid;
    (void)intf;
    (void)report_id;
    (void)duration;
}
80005770:	0001                	nop
80005772:	0141                	add	sp,sp,16
80005774:	8082                	ret

Disassembly of section .text.usbd_hid_set_protocol:

80005776 <usbd_hid_set_protocol>:

__WEAK void usbd_hid_set_protocol(uint8_t busid, uint8_t intf, uint8_t protocol)
{
80005776:	1141                	add	sp,sp,-16
80005778:	87aa                	mv	a5,a0
8000577a:	86ae                	mv	a3,a1
8000577c:	8732                	mv	a4,a2
8000577e:	00f107a3          	sb	a5,15(sp)
80005782:	87b6                	mv	a5,a3
80005784:	00f10723          	sb	a5,14(sp)
80005788:	87ba                	mv	a5,a4
8000578a:	00f106a3          	sb	a5,13(sp)
    (void)busid;
    (void)intf;
    (void)protocol;
8000578e:	0001                	nop
80005790:	0141                	add	sp,sp,16
80005792:	8082                	ret

Disassembly of section .text.dword2array:

80005794 <dword2array>:
#include <stddef.h>

#define ALIGN_UP_DWORD(x) ((uint32_t)(uintptr_t)(x) & (sizeof(uint32_t) - 1))

static inline void dword2array(char *addr, uint32_t w)
{
80005794:	1141                	add	sp,sp,-16
80005796:	c62a                	sw	a0,12(sp)
80005798:	c42e                	sw	a1,8(sp)
    addr[0] = w;
8000579a:	47a2                	lw	a5,8(sp)
8000579c:	0ff7f713          	zext.b	a4,a5
800057a0:	47b2                	lw	a5,12(sp)
800057a2:	00e78023          	sb	a4,0(a5)
    addr[1] = w >> 8;
800057a6:	47a2                	lw	a5,8(sp)
800057a8:	0087d713          	srl	a4,a5,0x8
800057ac:	47b2                	lw	a5,12(sp)
800057ae:	0785                	add	a5,a5,1
800057b0:	0ff77713          	zext.b	a4,a4
800057b4:	00e78023          	sb	a4,0(a5)
    addr[2] = w >> 16;
800057b8:	47a2                	lw	a5,8(sp)
800057ba:	0107d713          	srl	a4,a5,0x10
800057be:	47b2                	lw	a5,12(sp)
800057c0:	0789                	add	a5,a5,2
800057c2:	0ff77713          	zext.b	a4,a4
800057c6:	00e78023          	sb	a4,0(a5)
    addr[3] = w >> 24;
800057ca:	47a2                	lw	a5,8(sp)
800057cc:	0187d713          	srl	a4,a5,0x18
800057d0:	47b2                	lw	a5,12(sp)
800057d2:	078d                	add	a5,a5,3
800057d4:	0ff77713          	zext.b	a4,a4
800057d8:	00e78023          	sb	a4,0(a5)
}
800057dc:	0001                	nop
800057de:	0141                	add	sp,sp,16
800057e0:	8082                	ret

Disassembly of section .text.usbd_print_setup:

800057e2 <usbd_print_setup>:
struct usbd_bus g_usbdev_bus[CONFIG_USBDEV_MAX_BUS];

static void usbd_class_event_notify_handler(uint8_t busid, uint8_t event, void *arg);

static void usbd_print_setup(struct usb_setup_packet *setup)
{
800057e2:	1101                	add	sp,sp,-32
800057e4:	ce06                	sw	ra,28(sp)
800057e6:	c62a                	sw	a0,12(sp)
    USB_LOG_INFO("Setup: "
800057e8:	800057b7          	lui	a5,0x80005
800057ec:	fa078513          	add	a0,a5,-96 # 80004fa0 <.LC0>
800057f0:	4ec030ef          	jal	80008cdc <printf>
800057f4:	47b2                	lw	a5,12(sp)
800057f6:	0007c783          	lbu	a5,0(a5)
800057fa:	85be                	mv	a1,a5
800057fc:	47b2                	lw	a5,12(sp)
800057fe:	0017c783          	lbu	a5,1(a5)
80005802:	863e                	mv	a2,a5
80005804:	47b2                	lw	a5,12(sp)
80005806:	0027c703          	lbu	a4,2(a5)
8000580a:	0037c783          	lbu	a5,3(a5)
8000580e:	07a2                	sll	a5,a5,0x8
80005810:	8fd9                	or	a5,a5,a4
80005812:	07c2                	sll	a5,a5,0x10
80005814:	83c1                	srl	a5,a5,0x10
80005816:	86be                	mv	a3,a5
80005818:	47b2                	lw	a5,12(sp)
8000581a:	0047c703          	lbu	a4,4(a5)
8000581e:	0057c783          	lbu	a5,5(a5)
80005822:	07a2                	sll	a5,a5,0x8
80005824:	8fd9                	or	a5,a5,a4
80005826:	07c2                	sll	a5,a5,0x10
80005828:	83c1                	srl	a5,a5,0x10
8000582a:	853e                	mv	a0,a5
8000582c:	47b2                	lw	a5,12(sp)
8000582e:	0067c703          	lbu	a4,6(a5)
80005832:	0077c783          	lbu	a5,7(a5)
80005836:	07a2                	sll	a5,a5,0x8
80005838:	8fd9                	or	a5,a5,a4
8000583a:	07c2                	sll	a5,a5,0x10
8000583c:	83c1                	srl	a5,a5,0x10
8000583e:	872a                	mv	a4,a0
80005840:	80005537          	lui	a0,0x80005
80005844:	fac50513          	add	a0,a0,-84 # 80004fac <.LC1>
80005848:	494030ef          	jal	80008cdc <printf>
                 setup->bmRequestType,
                 setup->bRequest,
                 setup->wValue,
                 setup->wIndex,
                 setup->wLength);
}
8000584c:	0001                	nop
8000584e:	40f2                	lw	ra,28(sp)
80005850:	6105                	add	sp,sp,32
80005852:	8082                	ret

Disassembly of section .text.usbd_set_endpoint:

80005854 <usbd_set_endpoint>:
 * @param [in]  ep Endpoint descriptor byte array
 *
 * @return true if successfully configured and enabled
 */
static bool usbd_set_endpoint(uint8_t busid, const struct usb_endpoint_descriptor *ep)
{
80005854:	1101                	add	sp,sp,-32
80005856:	ce06                	sw	ra,28(sp)
80005858:	87aa                	mv	a5,a0
8000585a:	c42e                	sw	a1,8(sp)
8000585c:	00f107a3          	sb	a5,15(sp)
    USB_LOG_DBG("Open ep:0x%02x type:%u mps:%u\r\n",
                ep->bEndpointAddress,
                USB_GET_ENDPOINT_TYPE(ep->bmAttributes),
                USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize));

    if (ep->bEndpointAddress & 0x80) {
80005860:	47a2                	lw	a5,8(sp)
80005862:	0027c783          	lbu	a5,2(a5)
80005866:	07e2                	sll	a5,a5,0x18
80005868:	87e1                	sra	a5,a5,0x18
8000586a:	0807da63          	bgez	a5,800058fe <.L28>
        g_usbd_core[busid].tx_msg[ep->bEndpointAddress & 0x7f].ep_mps = USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize);
8000586e:	47a2                	lw	a5,8(sp)
80005870:	0047c703          	lbu	a4,4(a5)
80005874:	0057c783          	lbu	a5,5(a5)
80005878:	07a2                	sll	a5,a5,0x8
8000587a:	8fd9                	or	a5,a5,a4
8000587c:	07c2                	sll	a5,a5,0x10
8000587e:	83c1                	srl	a5,a5,0x10
80005880:	00f14583          	lbu	a1,15(sp)
80005884:	4722                	lw	a4,8(sp)
80005886:	00274703          	lbu	a4,2(a4)
8000588a:	07f77713          	and	a4,a4,127
8000588e:	7ff7f793          	and	a5,a5,2047
80005892:	01079693          	sll	a3,a5,0x10
80005896:	82c1                	srl	a3,a3,0x10
80005898:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
8000589c:	87ba                	mv	a5,a4
8000589e:	0786                	sll	a5,a5,0x1
800058a0:	97ba                	add	a5,a5,a4
800058a2:	078a                	sll	a5,a5,0x2
800058a4:	53c00713          	li	a4,1340
800058a8:	02e58733          	mul	a4,a1,a4
800058ac:	97ba                	add	a5,a5,a4
800058ae:	97b2                	add	a5,a5,a2
800058b0:	46d79d23          	sh	a3,1146(a5)
        g_usbd_core[busid].tx_msg[ep->bEndpointAddress & 0x7f].ep_mult = USB_GET_MULT(ep->wMaxPacketSize);
800058b4:	47a2                	lw	a5,8(sp)
800058b6:	0047c703          	lbu	a4,4(a5)
800058ba:	0057c783          	lbu	a5,5(a5)
800058be:	07a2                	sll	a5,a5,0x8
800058c0:	8fd9                	or	a5,a5,a4
800058c2:	07c2                	sll	a5,a5,0x10
800058c4:	83c1                	srl	a5,a5,0x10
800058c6:	87ad                	sra	a5,a5,0xb
800058c8:	0ff7f793          	zext.b	a5,a5
800058cc:	00f14583          	lbu	a1,15(sp)
800058d0:	4722                	lw	a4,8(sp)
800058d2:	00274703          	lbu	a4,2(a4)
800058d6:	07f77713          	and	a4,a4,127
800058da:	8b8d                	and	a5,a5,3
800058dc:	0ff7f693          	zext.b	a3,a5
800058e0:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
800058e4:	87ba                	mv	a5,a4
800058e6:	0786                	sll	a5,a5,0x1
800058e8:	97ba                	add	a5,a5,a4
800058ea:	078a                	sll	a5,a5,0x2
800058ec:	53c00713          	li	a4,1340
800058f0:	02e58733          	mul	a4,a1,a4
800058f4:	97ba                	add	a5,a5,a4
800058f6:	97b2                	add	a5,a5,a2
800058f8:	46d78ca3          	sb	a3,1145(a5)
800058fc:	a841                	j	8000598c <.L29>

800058fe <.L28>:
    } else {
        g_usbd_core[busid].rx_msg[ep->bEndpointAddress & 0x7f].ep_mps = USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize);
800058fe:	47a2                	lw	a5,8(sp)
80005900:	0047c703          	lbu	a4,4(a5)
80005904:	0057c783          	lbu	a5,5(a5)
80005908:	07a2                	sll	a5,a5,0x8
8000590a:	8fd9                	or	a5,a5,a4
8000590c:	07c2                	sll	a5,a5,0x10
8000590e:	83c1                	srl	a5,a5,0x10
80005910:	00f14583          	lbu	a1,15(sp)
80005914:	4722                	lw	a4,8(sp)
80005916:	00274703          	lbu	a4,2(a4)
8000591a:	07f77713          	and	a4,a4,127
8000591e:	7ff7f793          	and	a5,a5,2047
80005922:	01079693          	sll	a3,a5,0x10
80005926:	82c1                	srl	a3,a3,0x10
80005928:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
8000592c:	87ba                	mv	a5,a4
8000592e:	0786                	sll	a5,a5,0x1
80005930:	97ba                	add	a5,a5,a4
80005932:	078a                	sll	a5,a5,0x2
80005934:	53c00713          	li	a4,1340
80005938:	02e58733          	mul	a4,a1,a4
8000593c:	97ba                	add	a5,a5,a4
8000593e:	97b2                	add	a5,a5,a2
80005940:	4cd79d23          	sh	a3,1242(a5)
        g_usbd_core[busid].rx_msg[ep->bEndpointAddress & 0x7f].ep_mult = USB_GET_MULT(ep->wMaxPacketSize);
80005944:	47a2                	lw	a5,8(sp)
80005946:	0047c703          	lbu	a4,4(a5)
8000594a:	0057c783          	lbu	a5,5(a5)
8000594e:	07a2                	sll	a5,a5,0x8
80005950:	8fd9                	or	a5,a5,a4
80005952:	07c2                	sll	a5,a5,0x10
80005954:	83c1                	srl	a5,a5,0x10
80005956:	87ad                	sra	a5,a5,0xb
80005958:	0ff7f793          	zext.b	a5,a5
8000595c:	00f14583          	lbu	a1,15(sp)
80005960:	4722                	lw	a4,8(sp)
80005962:	00274703          	lbu	a4,2(a4)
80005966:	07f77713          	and	a4,a4,127
8000596a:	8b8d                	and	a5,a5,3
8000596c:	0ff7f693          	zext.b	a3,a5
80005970:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
80005974:	87ba                	mv	a5,a4
80005976:	0786                	sll	a5,a5,0x1
80005978:	97ba                	add	a5,a5,a4
8000597a:	078a                	sll	a5,a5,0x2
8000597c:	53c00713          	li	a4,1340
80005980:	02e58733          	mul	a4,a1,a4
80005984:	97ba                	add	a5,a5,a4
80005986:	97b2                	add	a5,a5,a2
80005988:	4cd78ca3          	sb	a3,1241(a5)

8000598c <.L29>:
    }

    return usbd_ep_open(busid, ep) == 0 ? true : false;
8000598c:	00f14783          	lbu	a5,15(sp)
80005990:	45a2                	lw	a1,8(sp)
80005992:	853e                	mv	a0,a5
80005994:	586050ef          	jal	8000af1a <usbd_ep_open>
80005998:	87aa                	mv	a5,a0
8000599a:	0017b793          	seqz	a5,a5
8000599e:	0ff7f793          	zext.b	a5,a5
}
800059a2:	853e                	mv	a0,a5
800059a4:	40f2                	lw	ra,28(sp)
800059a6:	6105                	add	sp,sp,32
800059a8:	8082                	ret

Disassembly of section .text.usbd_get_descriptor:

800059aa <usbd_get_descriptor>:
 *
 * @return true if the descriptor was found, false otherwise
 */
#ifdef CONFIG_USBDEV_ADVANCE_DESC
static bool usbd_get_descriptor(uint8_t busid, uint16_t type_index, uint8_t **data, uint32_t *len)
{
800059aa:	7139                	add	sp,sp,-64
800059ac:	de06                	sw	ra,60(sp)
800059ae:	dc22                	sw	s0,56(sp)
800059b0:	87aa                	mv	a5,a0
800059b2:	872e                	mv	a4,a1
800059b4:	c432                	sw	a2,8(sp)
800059b6:	c236                	sw	a3,4(sp)
800059b8:	00f107a3          	sb	a5,15(sp)
800059bc:	87ba                	mv	a5,a4
800059be:	00f11623          	sh	a5,12(sp)
    uint8_t type = 0U;
800059c2:	020100a3          	sb	zero,33(sp)
    uint8_t index = 0U;
800059c6:	02010023          	sb	zero,32(sp)
    bool found = true;
800059ca:	4785                	li	a5,1
800059cc:	02f107a3          	sb	a5,47(sp)
    uint32_t desc_len = 0;
800059d0:	d402                	sw	zero,40(sp)
    const char *string = NULL;
800059d2:	ce02                	sw	zero,28(sp)
    const uint8_t *desc = NULL;
800059d4:	d202                	sw	zero,36(sp)

    type = HI_BYTE(type_index);
800059d6:	00c15783          	lhu	a5,12(sp)
800059da:	83a1                	srl	a5,a5,0x8
800059dc:	07c2                	sll	a5,a5,0x10
800059de:	83c1                	srl	a5,a5,0x10
800059e0:	02f100a3          	sb	a5,33(sp)
    index = LO_BYTE(type_index);
800059e4:	00c15783          	lhu	a5,12(sp)
800059e8:	02f10023          	sb	a5,32(sp)

    switch (type) {
800059ec:	02114783          	lbu	a5,33(sp)
800059f0:	473d                	li	a4,15
800059f2:	3cf76163          	bltu	a4,a5,80005db4 <.L34>
800059f6:	00279713          	sll	a4,a5,0x2
800059fa:	800037b7          	lui	a5,0x80003
800059fe:	49c78793          	add	a5,a5,1180 # 8000349c <.L36>
80005a02:	97ba                	add	a5,a5,a4
80005a04:	439c                	lw	a5,0(a5)
80005a06:	8782                	jr	a5

80005a08 <.L41>:
        case USB_DESCRIPTOR_TYPE_DEVICE:
            g_usbd_core[busid].speed = usbd_get_port_speed(busid); /* before we get device descriptor, we have known steady port speed */
80005a08:	00f14403          	lbu	s0,15(sp)
80005a0c:	00f14783          	lbu	a5,15(sp)
80005a10:	853e                	mv	a0,a5
80005a12:	4ae050ef          	jal	8000aec0 <usbd_get_port_speed>
80005a16:	87aa                	mv	a5,a0
80005a18:	86be                	mv	a3,a5
80005a1a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005a1e:	53c00793          	li	a5,1340
80005a22:	02f407b3          	mul	a5,s0,a5
80005a26:	97ba                	add	a5,a5,a4
80005a28:	42d78123          	sb	a3,1058(a5)
            desc = g_usbd_core[busid].descriptors->device_descriptor_callback(g_usbd_core[busid].speed);
80005a2c:	00f14683          	lbu	a3,15(sp)
80005a30:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005a34:	53c00793          	li	a5,1340
80005a38:	02f687b3          	mul	a5,a3,a5
80005a3c:	97ba                	add	a5,a5,a4
80005a3e:	4f9c                	lw	a5,24(a5)
80005a40:	4398                	lw	a4,0(a5)
80005a42:	00f14603          	lbu	a2,15(sp)
80005a46:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005a4a:	53c00793          	li	a5,1340
80005a4e:	02f607b3          	mul	a5,a2,a5
80005a52:	97b6                	add	a5,a5,a3
80005a54:	4227c783          	lbu	a5,1058(a5)
80005a58:	853e                	mv	a0,a5
80005a5a:	9702                	jalr	a4
80005a5c:	d22a                	sw	a0,36(sp)
            if (desc == NULL) {
80005a5e:	5792                	lw	a5,36(sp)
80005a60:	e781                	bnez	a5,80005a68 <.L42>
                found = false;
80005a62:	020107a3          	sb	zero,47(sp)
                break;
80005a66:	ae91                	j	80005dba <.L43>

80005a68 <.L42>:
            }
            desc_len = desc[0];
80005a68:	5792                	lw	a5,36(sp)
80005a6a:	0007c783          	lbu	a5,0(a5)
80005a6e:	d43e                	sw	a5,40(sp)
            break;
80005a70:	a6a9                	j	80005dba <.L43>

80005a72 <.L40>:
        case USB_DESCRIPTOR_TYPE_CONFIGURATION:
            desc = g_usbd_core[busid].descriptors->config_descriptor_callback(g_usbd_core[busid].speed);
80005a72:	00f14683          	lbu	a3,15(sp)
80005a76:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005a7a:	53c00793          	li	a5,1340
80005a7e:	02f687b3          	mul	a5,a3,a5
80005a82:	97ba                	add	a5,a5,a4
80005a84:	4f9c                	lw	a5,24(a5)
80005a86:	43d8                	lw	a4,4(a5)
80005a88:	00f14603          	lbu	a2,15(sp)
80005a8c:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005a90:	53c00793          	li	a5,1340
80005a94:	02f607b3          	mul	a5,a2,a5
80005a98:	97b6                	add	a5,a5,a3
80005a9a:	4227c783          	lbu	a5,1058(a5)
80005a9e:	853e                	mv	a0,a5
80005aa0:	9702                	jalr	a4
80005aa2:	d22a                	sw	a0,36(sp)
            if (desc == NULL) {
80005aa4:	5792                	lw	a5,36(sp)
80005aa6:	e781                	bnez	a5,80005aae <.L44>
                found = false;
80005aa8:	020107a3          	sb	zero,47(sp)
                break;
80005aac:	a639                	j	80005dba <.L43>

80005aae <.L44>:
            }
            desc_len = ((desc[CONF_DESC_wTotalLength]) | (desc[CONF_DESC_wTotalLength + 1] << 8));
80005aae:	5792                	lw	a5,36(sp)
80005ab0:	0789                	add	a5,a5,2
80005ab2:	0007c783          	lbu	a5,0(a5)
80005ab6:	873e                	mv	a4,a5
80005ab8:	5792                	lw	a5,36(sp)
80005aba:	078d                	add	a5,a5,3
80005abc:	0007c783          	lbu	a5,0(a5)
80005ac0:	07a2                	sll	a5,a5,0x8
80005ac2:	8fd9                	or	a5,a5,a4
80005ac4:	d43e                	sw	a5,40(sp)

            g_usbd_core[busid].self_powered = (desc[7] & USB_CONFIG_POWERED_MASK) ? true : false;
80005ac6:	5792                	lw	a5,36(sp)
80005ac8:	079d                	add	a5,a5,7
80005aca:	0007c783          	lbu	a5,0(a5)
80005ace:	8799                	sra	a5,a5,0x6
80005ad0:	8b85                	and	a5,a5,1
80005ad2:	00f14603          	lbu	a2,15(sp)
80005ad6:	00f037b3          	snez	a5,a5
80005ada:	0ff7f713          	zext.b	a4,a5
80005ade:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005ae2:	53c00793          	li	a5,1340
80005ae6:	02f607b3          	mul	a5,a2,a5
80005aea:	97b6                	add	a5,a5,a3
80005aec:	40e78f23          	sb	a4,1054(a5)
            g_usbd_core[busid].remote_wakeup_support = (desc[7] & USB_CONFIG_REMOTE_WAKEUP) ? true : false;
80005af0:	5792                	lw	a5,36(sp)
80005af2:	079d                	add	a5,a5,7
80005af4:	0007c783          	lbu	a5,0(a5)
80005af8:	8795                	sra	a5,a5,0x5
80005afa:	8b85                	and	a5,a5,1
80005afc:	00f14603          	lbu	a2,15(sp)
80005b00:	00f037b3          	snez	a5,a5
80005b04:	0ff7f713          	zext.b	a4,a5
80005b08:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005b0c:	53c00793          	li	a5,1340
80005b10:	02f607b3          	mul	a5,a2,a5
80005b14:	97b6                	add	a5,a5,a3
80005b16:	40e78fa3          	sb	a4,1055(a5)
            break;
80005b1a:	a445                	j	80005dba <.L43>

80005b1c <.L39>:
        case USB_DESCRIPTOR_TYPE_STRING:
            if (index == USB_OSDESC_STRING_DESC_INDEX) {
80005b1c:	02014703          	lbu	a4,32(sp)
80005b20:	0ee00793          	li	a5,238
80005b24:	04f71e63          	bne	a4,a5,80005b80 <.L45>
                if (!g_usbd_core[busid].descriptors->msosv1_descriptor) {
80005b28:	00f14683          	lbu	a3,15(sp)
80005b2c:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005b30:	53c00793          	li	a5,1340
80005b34:	02f687b3          	mul	a5,a3,a5
80005b38:	97ba                	add	a5,a5,a4
80005b3a:	4f9c                	lw	a5,24(a5)
80005b3c:	4bdc                	lw	a5,20(a5)
80005b3e:	e781                	bnez	a5,80005b46 <.L46>
                    found = false;
80005b40:	020107a3          	sb	zero,47(sp)
                    break;
80005b44:	ac9d                	j	80005dba <.L43>

80005b46 <.L46>:
                }

                desc = (uint8_t *)g_usbd_core[busid].descriptors->msosv1_descriptor->string;
80005b46:	00f14683          	lbu	a3,15(sp)
80005b4a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005b4e:	53c00793          	li	a5,1340
80005b52:	02f687b3          	mul	a5,a3,a5
80005b56:	97ba                	add	a5,a5,a4
80005b58:	4f9c                	lw	a5,24(a5)
80005b5a:	4bdc                	lw	a5,20(a5)
80005b5c:	439c                	lw	a5,0(a5)
80005b5e:	d23e                	sw	a5,36(sp)
                desc_len = g_usbd_core[busid].descriptors->msosv1_descriptor->string[0];
80005b60:	00f14683          	lbu	a3,15(sp)
80005b64:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005b68:	53c00793          	li	a5,1340
80005b6c:	02f687b3          	mul	a5,a3,a5
80005b70:	97ba                	add	a5,a5,a4
80005b72:	4f9c                	lw	a5,24(a5)
80005b74:	4bdc                	lw	a5,20(a5)
80005b76:	439c                	lw	a5,0(a5)
80005b78:	0007c783          	lbu	a5,0(a5)
80005b7c:	d43e                	sw	a5,40(sp)
                }

                *len = total_size;
                return true;
            }
            break;
80005b7e:	ac35                	j	80005dba <.L43>

80005b80 <.L45>:
                string = g_usbd_core[busid].descriptors->string_descriptor_callback(g_usbd_core[busid].speed, index);
80005b80:	00f14683          	lbu	a3,15(sp)
80005b84:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005b88:	53c00793          	li	a5,1340
80005b8c:	02f687b3          	mul	a5,a3,a5
80005b90:	97ba                	add	a5,a5,a4
80005b92:	4f9c                	lw	a5,24(a5)
80005b94:	4b98                	lw	a4,16(a5)
80005b96:	00f14603          	lbu	a2,15(sp)
80005b9a:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005b9e:	53c00793          	li	a5,1340
80005ba2:	02f607b3          	mul	a5,a2,a5
80005ba6:	97b6                	add	a5,a5,a3
80005ba8:	4227c783          	lbu	a5,1058(a5)
80005bac:	02014683          	lbu	a3,32(sp)
80005bb0:	85b6                	mv	a1,a3
80005bb2:	853e                	mv	a0,a5
80005bb4:	9702                	jalr	a4
80005bb6:	ce2a                	sw	a0,28(sp)
                if (string == NULL) {
80005bb8:	47f2                	lw	a5,28(sp)
80005bba:	e781                	bnez	a5,80005bc2 <.L48>
                    found = false;
80005bbc:	020107a3          	sb	zero,47(sp)
                    break;
80005bc0:	aaed                	j	80005dba <.L43>

80005bc2 <.L48>:
                if (index == USB_STRING_LANGID_INDEX) {
80005bc2:	02014783          	lbu	a5,32(sp)
80005bc6:	e3b9                	bnez	a5,80005c0c <.L49>
                    (*data)[0] = 4;
80005bc8:	47a2                	lw	a5,8(sp)
80005bca:	439c                	lw	a5,0(a5)
80005bcc:	4711                	li	a4,4
80005bce:	00e78023          	sb	a4,0(a5)
                    (*data)[1] = USB_DESCRIPTOR_TYPE_STRING;
80005bd2:	47a2                	lw	a5,8(sp)
80005bd4:	439c                	lw	a5,0(a5)
80005bd6:	0785                	add	a5,a5,1
80005bd8:	470d                	li	a4,3
80005bda:	00e78023          	sb	a4,0(a5)
                    (*data)[2] = string[0];
80005bde:	47a2                	lw	a5,8(sp)
80005be0:	439c                	lw	a5,0(a5)
80005be2:	0789                	add	a5,a5,2
80005be4:	4772                	lw	a4,28(sp)
80005be6:	00074703          	lbu	a4,0(a4)
80005bea:	00e78023          	sb	a4,0(a5)
                    (*data)[3] = string[1];
80005bee:	47f2                	lw	a5,28(sp)
80005bf0:	00178713          	add	a4,a5,1
80005bf4:	47a2                	lw	a5,8(sp)
80005bf6:	439c                	lw	a5,0(a5)
80005bf8:	078d                	add	a5,a5,3
80005bfa:	00074703          	lbu	a4,0(a4)
80005bfe:	00e78023          	sb	a4,0(a5)
                    *len = 4;
80005c02:	4792                	lw	a5,4(sp)
80005c04:	4711                	li	a4,4
80005c06:	c398                	sw	a4,0(a5)
                    return true;
80005c08:	4785                	li	a5,1
80005c0a:	aad5                	j	80005dfe <.L50>

80005c0c <.L49>:
                uint16_t str_size = strlen(string);
80005c0c:	4572                	lw	a0,28(sp)
80005c0e:	36d060ef          	jal	8000c77a <strlen>
80005c12:	87aa                	mv	a5,a0
80005c14:	00f11d23          	sh	a5,26(sp)
                uint16_t total_size = 2 * str_size + 2;
80005c18:	01a15783          	lhu	a5,26(sp)
80005c1c:	0785                	add	a5,a5,1
80005c1e:	07c2                	sll	a5,a5,0x10
80005c20:	83c1                	srl	a5,a5,0x10
80005c22:	0786                	sll	a5,a5,0x1
80005c24:	00f11c23          	sh	a5,24(sp)
                if (total_size > CONFIG_USBDEV_REQUEST_BUFFER_LEN) {
80005c28:	01815703          	lhu	a4,24(sp)
80005c2c:	40000793          	li	a5,1024
80005c30:	02e7f063          	bgeu	a5,a4,80005c50 <.L51>
                    USB_LOG_ERR("string size overflow\r\n");
80005c34:	800057b7          	lui	a5,0x80005
80005c38:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
80005c3c:	0a0030ef          	jal	80008cdc <printf>
80005c40:	800057b7          	lui	a5,0x80005
80005c44:	01878513          	add	a0,a5,24 # 80005018 <.LC3>
80005c48:	094030ef          	jal	80008cdc <printf>
                    return false;
80005c4c:	4781                	li	a5,0
80005c4e:	aa45                	j	80005dfe <.L50>

80005c50 <.L51>:
                (*data)[0] = total_size;
80005c50:	47a2                	lw	a5,8(sp)
80005c52:	439c                	lw	a5,0(a5)
80005c54:	01815703          	lhu	a4,24(sp)
80005c58:	0ff77713          	zext.b	a4,a4
80005c5c:	00e78023          	sb	a4,0(a5)
                (*data)[1] = USB_DESCRIPTOR_TYPE_STRING;
80005c60:	47a2                	lw	a5,8(sp)
80005c62:	439c                	lw	a5,0(a5)
80005c64:	0785                	add	a5,a5,1
80005c66:	470d                	li	a4,3
80005c68:	00e78023          	sb	a4,0(a5)

80005c6c <.LBB3>:
                for (uint16_t i = 0; i < str_size; i++) {
80005c6c:	02011123          	sh	zero,34(sp)
80005c70:	a835                	j	80005cac <.L52>

80005c72 <.L53>:
                    (*data)[2 * i + 2] = string[i];
80005c72:	02215783          	lhu	a5,34(sp)
80005c76:	4772                	lw	a4,28(sp)
80005c78:	973e                	add	a4,a4,a5
80005c7a:	47a2                	lw	a5,8(sp)
80005c7c:	4394                	lw	a3,0(a5)
80005c7e:	02215783          	lhu	a5,34(sp)
80005c82:	0786                	sll	a5,a5,0x1
80005c84:	0789                	add	a5,a5,2
80005c86:	97b6                	add	a5,a5,a3
80005c88:	00074703          	lbu	a4,0(a4)
80005c8c:	00e78023          	sb	a4,0(a5)
                    (*data)[2 * i + 3] = 0x00;
80005c90:	47a2                	lw	a5,8(sp)
80005c92:	4398                	lw	a4,0(a5)
80005c94:	02215783          	lhu	a5,34(sp)
80005c98:	0786                	sll	a5,a5,0x1
80005c9a:	078d                	add	a5,a5,3
80005c9c:	97ba                	add	a5,a5,a4
80005c9e:	00078023          	sb	zero,0(a5)
                for (uint16_t i = 0; i < str_size; i++) {
80005ca2:	02215783          	lhu	a5,34(sp)
80005ca6:	0785                	add	a5,a5,1
80005ca8:	02f11123          	sh	a5,34(sp)

80005cac <.L52>:
80005cac:	02215703          	lhu	a4,34(sp)
80005cb0:	01a15783          	lhu	a5,26(sp)
80005cb4:	faf76fe3          	bltu	a4,a5,80005c72 <.L53>

80005cb8 <.LBE3>:
                *len = total_size;
80005cb8:	01815703          	lhu	a4,24(sp)
80005cbc:	4792                	lw	a5,4(sp)
80005cbe:	c398                	sw	a4,0(a5)
                return true;
80005cc0:	4785                	li	a5,1
80005cc2:	aa35                	j	80005dfe <.L50>

80005cc4 <.L38>:
        case USB_DESCRIPTOR_TYPE_DEVICE_QUALIFIER:
#ifndef CONFIG_USB_HS
            return false;
#else
            desc = g_usbd_core[busid].descriptors->device_quality_descriptor_callback(g_usbd_core[busid].speed);
80005cc4:	00f14683          	lbu	a3,15(sp)
80005cc8:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005ccc:	53c00793          	li	a5,1340
80005cd0:	02f687b3          	mul	a5,a3,a5
80005cd4:	97ba                	add	a5,a5,a4
80005cd6:	4f9c                	lw	a5,24(a5)
80005cd8:	4798                	lw	a4,8(a5)
80005cda:	00f14603          	lbu	a2,15(sp)
80005cde:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005ce2:	53c00793          	li	a5,1340
80005ce6:	02f607b3          	mul	a5,a2,a5
80005cea:	97b6                	add	a5,a5,a3
80005cec:	4227c783          	lbu	a5,1058(a5)
80005cf0:	853e                	mv	a0,a5
80005cf2:	9702                	jalr	a4
80005cf4:	d22a                	sw	a0,36(sp)
            if (desc == NULL) {
80005cf6:	5792                	lw	a5,36(sp)
80005cf8:	e781                	bnez	a5,80005d00 <.L54>
                found = false;
80005cfa:	020107a3          	sb	zero,47(sp)
                break;
80005cfe:	a875                	j	80005dba <.L43>

80005d00 <.L54>:
            }
            desc_len = desc[0];
80005d00:	5792                	lw	a5,36(sp)
80005d02:	0007c783          	lbu	a5,0(a5)
80005d06:	d43e                	sw	a5,40(sp)
            break;
80005d08:	a84d                	j	80005dba <.L43>

80005d0a <.L37>:
#endif
        case USB_DESCRIPTOR_TYPE_OTHER_SPEED:
            desc = g_usbd_core[busid].descriptors->other_speed_descriptor_callback(g_usbd_core[busid].speed);
80005d0a:	00f14683          	lbu	a3,15(sp)
80005d0e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005d12:	53c00793          	li	a5,1340
80005d16:	02f687b3          	mul	a5,a3,a5
80005d1a:	97ba                	add	a5,a5,a4
80005d1c:	4f9c                	lw	a5,24(a5)
80005d1e:	47d8                	lw	a4,12(a5)
80005d20:	00f14603          	lbu	a2,15(sp)
80005d24:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005d28:	53c00793          	li	a5,1340
80005d2c:	02f607b3          	mul	a5,a2,a5
80005d30:	97b6                	add	a5,a5,a3
80005d32:	4227c783          	lbu	a5,1058(a5)
80005d36:	853e                	mv	a0,a5
80005d38:	9702                	jalr	a4
80005d3a:	d22a                	sw	a0,36(sp)
            if (desc == NULL) {
80005d3c:	5792                	lw	a5,36(sp)
80005d3e:	e781                	bnez	a5,80005d46 <.L55>
                found = false;
80005d40:	020107a3          	sb	zero,47(sp)
                break;
80005d44:	a89d                	j	80005dba <.L43>

80005d46 <.L55>:
            }
            desc_len = ((desc[CONF_DESC_wTotalLength]) | (desc[CONF_DESC_wTotalLength + 1] << 8));
80005d46:	5792                	lw	a5,36(sp)
80005d48:	0789                	add	a5,a5,2
80005d4a:	0007c783          	lbu	a5,0(a5)
80005d4e:	873e                	mv	a4,a5
80005d50:	5792                	lw	a5,36(sp)
80005d52:	078d                	add	a5,a5,3
80005d54:	0007c783          	lbu	a5,0(a5)
80005d58:	07a2                	sll	a5,a5,0x8
80005d5a:	8fd9                	or	a5,a5,a4
80005d5c:	d43e                	sw	a5,40(sp)
            break;
80005d5e:	a8b1                	j	80005dba <.L43>

80005d60 <.L35>:

        case USB_DESCRIPTOR_TYPE_BINARY_OBJECT_STORE:
            if (!g_usbd_core[busid].descriptors->bos_descriptor) {
80005d60:	00f14683          	lbu	a3,15(sp)
80005d64:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005d68:	53c00793          	li	a5,1340
80005d6c:	02f687b3          	mul	a5,a3,a5
80005d70:	97ba                	add	a5,a5,a4
80005d72:	4f9c                	lw	a5,24(a5)
80005d74:	539c                	lw	a5,32(a5)
80005d76:	e781                	bnez	a5,80005d7e <.L56>
                found = false;
80005d78:	020107a3          	sb	zero,47(sp)
                break;
80005d7c:	a83d                	j	80005dba <.L43>

80005d7e <.L56>:
            }

            desc = (uint8_t *)g_usbd_core[busid].descriptors->bos_descriptor->string;
80005d7e:	00f14683          	lbu	a3,15(sp)
80005d82:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005d86:	53c00793          	li	a5,1340
80005d8a:	02f687b3          	mul	a5,a3,a5
80005d8e:	97ba                	add	a5,a5,a4
80005d90:	4f9c                	lw	a5,24(a5)
80005d92:	539c                	lw	a5,32(a5)
80005d94:	439c                	lw	a5,0(a5)
80005d96:	d23e                	sw	a5,36(sp)
            desc_len = g_usbd_core[busid].descriptors->bos_descriptor->string_len;
80005d98:	00f14683          	lbu	a3,15(sp)
80005d9c:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005da0:	53c00793          	li	a5,1340
80005da4:	02f687b3          	mul	a5,a3,a5
80005da8:	97ba                	add	a5,a5,a4
80005daa:	4f9c                	lw	a5,24(a5)
80005dac:	539c                	lw	a5,32(a5)
80005dae:	43dc                	lw	a5,4(a5)
80005db0:	d43e                	sw	a5,40(sp)
            break;
80005db2:	a021                	j	80005dba <.L43>

80005db4 <.L34>:

        default:
            found = false;
80005db4:	020107a3          	sb	zero,47(sp)
            break;
80005db8:	0001                	nop

80005dba <.L43>:
    }

    if (found == false) {
80005dba:	02f14783          	lbu	a5,47(sp)
80005dbe:	0017c793          	xor	a5,a5,1
80005dc2:	0ff7f793          	zext.b	a5,a5
80005dc6:	c785                	beqz	a5,80005dee <.L57>
        /* nothing found */
        USB_LOG_ERR("descriptor <type:%x,index:%x> not found!\r\n", type, index);
80005dc8:	800057b7          	lui	a5,0x80005
80005dcc:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
80005dd0:	70d020ef          	jal	80008cdc <printf>
80005dd4:	02114783          	lbu	a5,33(sp)
80005dd8:	02014703          	lbu	a4,32(sp)
80005ddc:	863a                	mv	a2,a4
80005dde:	85be                	mv	a1,a5
80005de0:	800057b7          	lui	a5,0x80005
80005de4:	03078513          	add	a0,a5,48 # 80005030 <.LC4>
80005de8:	6f5020ef          	jal	80008cdc <printf>
80005dec:	a039                	j	80005dfa <.L58>

80005dee <.L57>:
    } else {
        *data = (uint8_t *)desc;
80005dee:	47a2                	lw	a5,8(sp)
80005df0:	5712                	lw	a4,36(sp)
80005df2:	c398                	sw	a4,0(a5)
        //memcpy(*data, desc, desc_len);
        *len = desc_len;
80005df4:	4792                	lw	a5,4(sp)
80005df6:	5722                	lw	a4,40(sp)
80005df8:	c398                	sw	a4,0(a5)

80005dfa <.L58>:
    }
    return found;
80005dfa:	02f14783          	lbu	a5,47(sp)

80005dfe <.L50>:
}
80005dfe:	853e                	mv	a0,a5
80005e00:	50f2                	lw	ra,60(sp)
80005e02:	5462                	lw	s0,56(sp)
80005e04:	6121                	add	sp,sp,64
80005e06:	8082                	ret

Disassembly of section .text.usbd_set_configuration:

80005e08 <usbd_set_configuration>:
 * @param [in] alt_setting  Alternate setting number
 *
 * @return true if successfully configured false if error or unconfigured
 */
static bool usbd_set_configuration(uint8_t busid, uint8_t config_index, uint8_t alt_setting)
{
80005e08:	7179                	add	sp,sp,-48
80005e0a:	d606                	sw	ra,44(sp)
80005e0c:	87aa                	mv	a5,a0
80005e0e:	86ae                	mv	a3,a1
80005e10:	8732                	mv	a4,a2
80005e12:	00f107a3          	sb	a5,15(sp)
80005e16:	87b6                	mv	a5,a3
80005e18:	00f10723          	sb	a5,14(sp)
80005e1c:	87ba                	mv	a5,a4
80005e1e:	00f106a3          	sb	a5,13(sp)
    uint8_t cur_alt_setting = 0xFF;
80005e22:	57fd                	li	a5,-1
80005e24:	00f10fa3          	sb	a5,31(sp)
    uint8_t cur_config = 0xFF;
80005e28:	57fd                	li	a5,-1
80005e2a:	00f10f23          	sb	a5,30(sp)
    bool found = false;
80005e2e:	00010ea3          	sb	zero,29(sp)
    const uint8_t *p;
    uint32_t desc_len = 0;
80005e32:	ca02                	sw	zero,20(sp)
    uint32_t current_desc_len = 0;
80005e34:	c802                	sw	zero,16(sp)

#ifdef CONFIG_USBDEV_ADVANCE_DESC
    p = g_usbd_core[busid].descriptors->config_descriptor_callback(g_usbd_core[busid].speed);
80005e36:	00f14683          	lbu	a3,15(sp)
80005e3a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005e3e:	53c00793          	li	a5,1340
80005e42:	02f687b3          	mul	a5,a3,a5
80005e46:	97ba                	add	a5,a5,a4
80005e48:	4f9c                	lw	a5,24(a5)
80005e4a:	43d8                	lw	a4,4(a5)
80005e4c:	00f14603          	lbu	a2,15(sp)
80005e50:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005e54:	53c00793          	li	a5,1340
80005e58:	02f607b3          	mul	a5,a2,a5
80005e5c:	97b6                	add	a5,a5,a3
80005e5e:	4227c783          	lbu	a5,1058(a5)
80005e62:	853e                	mv	a0,a5
80005e64:	9702                	jalr	a4
80005e66:	cc2a                	sw	a0,24(sp)
#else
    p = (uint8_t *)g_usbd_core[busid].descriptors;
#endif
    /* configure endpoints for this configuration/altsetting */
    while (p[DESC_bLength] != 0U) {
80005e68:	a0d1                	j	80005f2c <.L60>

80005e6a <.L68>:
        switch (p[DESC_bDescriptorType]) {
80005e6a:	47e2                	lw	a5,24(sp)
80005e6c:	0785                	add	a5,a5,1
80005e6e:	0007c783          	lbu	a5,0(a5)
80005e72:	4715                	li	a4,5
80005e74:	06e78063          	beq	a5,a4,80005ed4 <.L61>
80005e78:	4715                	li	a4,5
80005e7a:	08f74263          	blt	a4,a5,80005efe <.L70>
80005e7e:	4709                	li	a4,2
80005e80:	00e78663          	beq	a5,a4,80005e8c <.L63>
80005e84:	4711                	li	a4,4
80005e86:	04e78063          	beq	a5,a4,80005ec6 <.L64>

                found = usbd_set_endpoint(busid, (struct usb_endpoint_descriptor *)p);
                break;

            default:
                break;
80005e8a:	a895                	j	80005efe <.L70>

80005e8c <.L63>:
                cur_config = p[CONF_DESC_bConfigurationValue];
80005e8c:	47e2                	lw	a5,24(sp)
80005e8e:	0795                	add	a5,a5,5
80005e90:	0007c783          	lbu	a5,0(a5)
80005e94:	00f10f23          	sb	a5,30(sp)
                if (cur_config == config_index) {
80005e98:	01e14703          	lbu	a4,30(sp)
80005e9c:	00e14783          	lbu	a5,14(sp)
80005ea0:	06f71163          	bne	a4,a5,80005f02 <.L71>
                    found = true;
80005ea4:	4785                	li	a5,1
80005ea6:	00f10ea3          	sb	a5,29(sp)
                    current_desc_len = 0;
80005eaa:	c802                	sw	zero,16(sp)
                    desc_len = (p[CONF_DESC_wTotalLength]) |
80005eac:	47e2                	lw	a5,24(sp)
80005eae:	0789                	add	a5,a5,2
80005eb0:	0007c783          	lbu	a5,0(a5)
80005eb4:	873e                	mv	a4,a5
                               (p[CONF_DESC_wTotalLength + 1] << 8);
80005eb6:	47e2                	lw	a5,24(sp)
80005eb8:	078d                	add	a5,a5,3
80005eba:	0007c783          	lbu	a5,0(a5)
80005ebe:	07a2                	sll	a5,a5,0x8
                    desc_len = (p[CONF_DESC_wTotalLength]) |
80005ec0:	8fd9                	or	a5,a5,a4
80005ec2:	ca3e                	sw	a5,20(sp)
                break;
80005ec4:	a83d                	j	80005f02 <.L71>

80005ec6 <.L64>:
                    p[INTF_DESC_bAlternateSetting];
80005ec6:	47e2                	lw	a5,24(sp)
80005ec8:	078d                	add	a5,a5,3
                cur_alt_setting =
80005eca:	0007c783          	lbu	a5,0(a5)
80005ece:	00f10fa3          	sb	a5,31(sp)
                break;
80005ed2:	a80d                	j	80005f04 <.L66>

80005ed4 <.L61>:
                if ((cur_config != config_index) ||
80005ed4:	01e14703          	lbu	a4,30(sp)
80005ed8:	00e14783          	lbu	a5,14(sp)
80005edc:	02f71463          	bne	a4,a5,80005f04 <.L66>
80005ee0:	01f14703          	lbu	a4,31(sp)
80005ee4:	00d14783          	lbu	a5,13(sp)
80005ee8:	00f71e63          	bne	a4,a5,80005f04 <.L66>
                found = usbd_set_endpoint(busid, (struct usb_endpoint_descriptor *)p);
80005eec:	00f14783          	lbu	a5,15(sp)
80005ef0:	45e2                	lw	a1,24(sp)
80005ef2:	853e                	mv	a0,a5
80005ef4:	3285                	jal	80005854 <usbd_set_endpoint>
80005ef6:	87aa                	mv	a5,a0
80005ef8:	00f10ea3          	sb	a5,29(sp)
                break;
80005efc:	a021                	j	80005f04 <.L66>

80005efe <.L70>:
                break;
80005efe:	0001                	nop
80005f00:	a011                	j	80005f04 <.L66>

80005f02 <.L71>:
                break;
80005f02:	0001                	nop

80005f04 <.L66>:
        }

        /* skip to next descriptor */
        p += p[DESC_bLength];
80005f04:	47e2                	lw	a5,24(sp)
80005f06:	0007c783          	lbu	a5,0(a5)
80005f0a:	873e                	mv	a4,a5
80005f0c:	47e2                	lw	a5,24(sp)
80005f0e:	97ba                	add	a5,a5,a4
80005f10:	cc3e                	sw	a5,24(sp)
        current_desc_len += p[DESC_bLength];
80005f12:	47e2                	lw	a5,24(sp)
80005f14:	0007c783          	lbu	a5,0(a5)
80005f18:	873e                	mv	a4,a5
80005f1a:	47c2                	lw	a5,16(sp)
80005f1c:	97ba                	add	a5,a5,a4
80005f1e:	c83e                	sw	a5,16(sp)
        if (current_desc_len >= desc_len && desc_len) {
80005f20:	4742                	lw	a4,16(sp)
80005f22:	47d2                	lw	a5,20(sp)
80005f24:	00f76463          	bltu	a4,a5,80005f2c <.L60>
80005f28:	47d2                	lw	a5,20(sp)
80005f2a:	e791                	bnez	a5,80005f36 <.L72>

80005f2c <.L60>:
    while (p[DESC_bLength] != 0U) {
80005f2c:	47e2                	lw	a5,24(sp)
80005f2e:	0007c783          	lbu	a5,0(a5)
80005f32:	ff85                	bnez	a5,80005e6a <.L68>
80005f34:	a011                	j	80005f38 <.L67>

80005f36 <.L72>:
            break;
80005f36:	0001                	nop

80005f38 <.L67>:
        }
    }

    return found;
80005f38:	01d14783          	lbu	a5,29(sp)
}
80005f3c:	853e                	mv	a0,a5
80005f3e:	50b2                	lw	ra,44(sp)
80005f40:	6145                	add	sp,sp,48
80005f42:	8082                	ret

Disassembly of section .text.usbd_set_interface:

80005f44 <usbd_set_interface>:
 * @param [in] alt_setting  Alternate setting number
 *
 * @return true if successfully configured false if error or unconfigured
 */
static bool usbd_set_interface(uint8_t busid, uint8_t iface, uint8_t alt_setting)
{
80005f44:	7139                	add	sp,sp,-64
80005f46:	de06                	sw	ra,60(sp)
80005f48:	87aa                	mv	a5,a0
80005f4a:	86ae                	mv	a3,a1
80005f4c:	8732                	mv	a4,a2
80005f4e:	00f107a3          	sb	a5,15(sp)
80005f52:	87b6                	mv	a5,a3
80005f54:	00f10723          	sb	a5,14(sp)
80005f58:	87ba                	mv	a5,a4
80005f5a:	00f106a3          	sb	a5,13(sp)
    const uint8_t *if_desc = NULL;
80005f5e:	d602                	sw	zero,44(sp)
    struct usb_endpoint_descriptor *ep_desc;
    uint8_t cur_alt_setting = 0xFF;
80005f60:	57fd                	li	a5,-1
80005f62:	02f105a3          	sb	a5,43(sp)
    uint8_t cur_iface = 0xFF;
80005f66:	57fd                	li	a5,-1
80005f68:	02f10523          	sb	a5,42(sp)
    bool ret = false;
80005f6c:	020104a3          	sb	zero,41(sp)
    const uint8_t *p;
    uint32_t desc_len = 0;
80005f70:	d002                	sw	zero,32(sp)
    uint32_t current_desc_len = 0;
80005f72:	ce02                	sw	zero,28(sp)

#ifdef CONFIG_USBDEV_ADVANCE_DESC
    p = g_usbd_core[busid].descriptors->config_descriptor_callback(g_usbd_core[busid].speed);
80005f74:	00f14683          	lbu	a3,15(sp)
80005f78:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80005f7c:	53c00793          	li	a5,1340
80005f80:	02f687b3          	mul	a5,a3,a5
80005f84:	97ba                	add	a5,a5,a4
80005f86:	4f9c                	lw	a5,24(a5)
80005f88:	43d8                	lw	a4,4(a5)
80005f8a:	00f14603          	lbu	a2,15(sp)
80005f8e:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80005f92:	53c00793          	li	a5,1340
80005f96:	02f607b3          	mul	a5,a2,a5
80005f9a:	97b6                	add	a5,a5,a3
80005f9c:	4227c783          	lbu	a5,1058(a5)
80005fa0:	853e                	mv	a0,a5
80005fa2:	9702                	jalr	a4
80005fa4:	d22a                	sw	a0,36(sp)
#else
    p = (uint8_t *)g_usbd_core[busid].descriptors;
#endif
    USB_LOG_DBG("iface %u alt_setting %u\r\n", iface, alt_setting);

    while (p[DESC_bLength] != 0U) {
80005fa6:	a8cd                	j	80006098 <.L74>

80005fa8 <.L84>:
        switch (p[DESC_bDescriptorType]) {
80005fa8:	5792                	lw	a5,36(sp)
80005faa:	0785                	add	a5,a5,1
80005fac:	0007c783          	lbu	a5,0(a5)
80005fb0:	4715                	li	a4,5
80005fb2:	06e78563          	beq	a5,a4,8000601c <.L75>
80005fb6:	4715                	li	a4,5
80005fb8:	0af74763          	blt	a4,a5,80006066 <.L86>
80005fbc:	4709                	li	a4,2
80005fbe:	00e78663          	beq	a5,a4,80005fca <.L77>
80005fc2:	4711                	li	a4,4
80005fc4:	02e78163          	beq	a5,a4,80005fe6 <.L78>
                }

                break;

            default:
                break;
80005fc8:	a879                	j	80006066 <.L86>

80005fca <.L77>:
                current_desc_len = 0;
80005fca:	ce02                	sw	zero,28(sp)
                desc_len = (p[CONF_DESC_wTotalLength]) |
80005fcc:	5792                	lw	a5,36(sp)
80005fce:	0789                	add	a5,a5,2
80005fd0:	0007c783          	lbu	a5,0(a5)
80005fd4:	873e                	mv	a4,a5
                           (p[CONF_DESC_wTotalLength + 1] << 8);
80005fd6:	5792                	lw	a5,36(sp)
80005fd8:	078d                	add	a5,a5,3
80005fda:	0007c783          	lbu	a5,0(a5)
80005fde:	07a2                	sll	a5,a5,0x8
                desc_len = (p[CONF_DESC_wTotalLength]) |
80005fe0:	8fd9                	or	a5,a5,a4
80005fe2:	d03e                	sw	a5,32(sp)
                break;
80005fe4:	a071                	j	80006070 <.L79>

80005fe6 <.L78>:
                cur_alt_setting = p[INTF_DESC_bAlternateSetting];
80005fe6:	5792                	lw	a5,36(sp)
80005fe8:	078d                	add	a5,a5,3
80005fea:	0007c783          	lbu	a5,0(a5)
80005fee:	02f105a3          	sb	a5,43(sp)
                cur_iface = p[INTF_DESC_bInterfaceNumber];
80005ff2:	5792                	lw	a5,36(sp)
80005ff4:	0789                	add	a5,a5,2
80005ff6:	0007c783          	lbu	a5,0(a5)
80005ffa:	02f10523          	sb	a5,42(sp)
                if (cur_iface == iface &&
80005ffe:	02a14703          	lbu	a4,42(sp)
80006002:	00e14783          	lbu	a5,14(sp)
80006006:	06f71263          	bne	a4,a5,8000606a <.L87>
8000600a:	02b14703          	lbu	a4,43(sp)
8000600e:	00d14783          	lbu	a5,13(sp)
80006012:	04f71c63          	bne	a4,a5,8000606a <.L87>
                    if_desc = (void *)p;
80006016:	5792                	lw	a5,36(sp)
80006018:	d63e                	sw	a5,44(sp)
                break;
8000601a:	a881                	j	8000606a <.L87>

8000601c <.L75>:
                if (cur_iface == iface) {
8000601c:	02a14703          	lbu	a4,42(sp)
80006020:	00e14783          	lbu	a5,14(sp)
80006024:	04f71563          	bne	a4,a5,8000606e <.L88>
                    ep_desc = (struct usb_endpoint_descriptor *)p;
80006028:	5792                	lw	a5,36(sp)
8000602a:	cc3e                	sw	a5,24(sp)
                    if (alt_setting == 0) {
8000602c:	00d14783          	lbu	a5,13(sp)
80006030:	eb99                	bnez	a5,80006046 <.L82>
                        ret = usbd_reset_endpoint(busid, ep_desc);
80006032:	00f14783          	lbu	a5,15(sp)
80006036:	45e2                	lw	a1,24(sp)
80006038:	853e                	mv	a0,a5
8000603a:	30a040ef          	jal	8000a344 <usbd_reset_endpoint>
8000603e:	87aa                	mv	a5,a0
80006040:	02f104a3          	sb	a5,41(sp)
                        goto find_end;
80006044:	a085                	j	800060a4 <.L83>

80006046 <.L82>:
                    } else if (cur_alt_setting == alt_setting) {
80006046:	02b14703          	lbu	a4,43(sp)
8000604a:	00d14783          	lbu	a5,13(sp)
8000604e:	02f71063          	bne	a4,a5,8000606e <.L88>
                        ret = usbd_set_endpoint(busid, ep_desc);
80006052:	00f14783          	lbu	a5,15(sp)
80006056:	45e2                	lw	a1,24(sp)
80006058:	853e                	mv	a0,a5
8000605a:	ffaff0ef          	jal	80005854 <usbd_set_endpoint>
8000605e:	87aa                	mv	a5,a0
80006060:	02f104a3          	sb	a5,41(sp)
                        goto find_end;
80006064:	a081                	j	800060a4 <.L83>

80006066 <.L86>:
                break;
80006066:	0001                	nop
80006068:	a021                	j	80006070 <.L79>

8000606a <.L87>:
                break;
8000606a:	0001                	nop
8000606c:	a011                	j	80006070 <.L79>

8000606e <.L88>:
                break;
8000606e:	0001                	nop

80006070 <.L79>:
        }

        /* skip to next descriptor */
        p += p[DESC_bLength];
80006070:	5792                	lw	a5,36(sp)
80006072:	0007c783          	lbu	a5,0(a5)
80006076:	873e                	mv	a4,a5
80006078:	5792                	lw	a5,36(sp)
8000607a:	97ba                	add	a5,a5,a4
8000607c:	d23e                	sw	a5,36(sp)
        current_desc_len += p[DESC_bLength];
8000607e:	5792                	lw	a5,36(sp)
80006080:	0007c783          	lbu	a5,0(a5)
80006084:	873e                	mv	a4,a5
80006086:	47f2                	lw	a5,28(sp)
80006088:	97ba                	add	a5,a5,a4
8000608a:	ce3e                	sw	a5,28(sp)
        if (current_desc_len >= desc_len && desc_len) {
8000608c:	4772                	lw	a4,28(sp)
8000608e:	5782                	lw	a5,32(sp)
80006090:	00f76463          	bltu	a4,a5,80006098 <.L74>
80006094:	5782                	lw	a5,32(sp)
80006096:	e791                	bnez	a5,800060a2 <.L89>

80006098 <.L74>:
    while (p[DESC_bLength] != 0U) {
80006098:	5792                	lw	a5,36(sp)
8000609a:	0007c783          	lbu	a5,0(a5)
8000609e:	f789                	bnez	a5,80005fa8 <.L84>
            break;
        }
    }

find_end:
800060a0:	a011                	j	800060a4 <.L83>

800060a2 <.L89>:
            break;
800060a2:	0001                	nop

800060a4 <.L83>:
    usbd_class_event_notify_handler(busid, USBD_EVENT_SET_INTERFACE, (void *)if_desc);
800060a4:	00f14783          	lbu	a5,15(sp)
800060a8:	5632                	lw	a2,44(sp)
800060aa:	45a1                	li	a1,8
800060ac:	853e                	mv	a0,a5
800060ae:	77a040ef          	jal	8000a828 <usbd_class_event_notify_handler>

    return ret;
800060b2:	02914783          	lbu	a5,41(sp)
}
800060b6:	853e                	mv	a0,a5
800060b8:	50f2                	lw	ra,60(sp)
800060ba:	6121                	add	sp,sp,64
800060bc:	8082                	ret

Disassembly of section .text.usbd_std_interface_req_handler:

800060be <usbd_std_interface_req_handler>:
 * @param [in,out] len      Pointer to data length
 *
 * @return true if the request was handled successfully
 */
static bool usbd_std_interface_req_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
800060be:	7139                	add	sp,sp,-64
800060c0:	de06                	sw	ra,60(sp)
800060c2:	87aa                	mv	a5,a0
800060c4:	c42e                	sw	a1,8(sp)
800060c6:	c232                	sw	a2,4(sp)
800060c8:	c036                	sw	a3,0(sp)
800060ca:	00f107a3          	sb	a5,15(sp)
    uint8_t type = HI_BYTE(setup->wValue);
800060ce:	47a2                	lw	a5,8(sp)
800060d0:	0027c703          	lbu	a4,2(a5)
800060d4:	0037c783          	lbu	a5,3(a5)
800060d8:	07a2                	sll	a5,a5,0x8
800060da:	8fd9                	or	a5,a5,a4
800060dc:	07c2                	sll	a5,a5,0x10
800060de:	83c1                	srl	a5,a5,0x10
800060e0:	83a1                	srl	a5,a5,0x8
800060e2:	07c2                	sll	a5,a5,0x10
800060e4:	83c1                	srl	a5,a5,0x10
800060e6:	00f10ea3          	sb	a5,29(sp)
    uint8_t intf_num = LO_BYTE(setup->wIndex);
800060ea:	47a2                	lw	a5,8(sp)
800060ec:	0047c703          	lbu	a4,4(a5)
800060f0:	0057c783          	lbu	a5,5(a5)
800060f4:	07a2                	sll	a5,a5,0x8
800060f6:	8fd9                	or	a5,a5,a4
800060f8:	07c2                	sll	a5,a5,0x10
800060fa:	83c1                	srl	a5,a5,0x10
800060fc:	00f10e23          	sb	a5,28(sp)
    bool ret = true;
80006100:	4785                	li	a5,1
80006102:	02f107a3          	sb	a5,47(sp)
    const uint8_t *p;
    uint32_t desc_len = 0;
80006106:	d202                	sw	zero,36(sp)
    uint32_t current_desc_len = 0;
80006108:	d002                	sw	zero,32(sp)
    uint8_t cur_iface = 0xFF;
8000610a:	57fd                	li	a5,-1
8000610c:	00f10fa3          	sb	a5,31(sp)

#ifdef CONFIG_USBDEV_ADVANCE_DESC
    p = g_usbd_core[busid].descriptors->config_descriptor_callback(g_usbd_core[busid].speed);
80006110:	00f14683          	lbu	a3,15(sp)
80006114:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006118:	53c00793          	li	a5,1340
8000611c:	02f687b3          	mul	a5,a3,a5
80006120:	97ba                	add	a5,a5,a4
80006122:	4f9c                	lw	a5,24(a5)
80006124:	43d8                	lw	a4,4(a5)
80006126:	00f14603          	lbu	a2,15(sp)
8000612a:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000612e:	53c00793          	li	a5,1340
80006132:	02f607b3          	mul	a5,a2,a5
80006136:	97b6                	add	a5,a5,a3
80006138:	4227c783          	lbu	a5,1058(a5)
8000613c:	853e                	mv	a0,a5
8000613e:	9702                	jalr	a4
80006140:	d42a                	sw	a0,40(sp)
#else
    p = (uint8_t *)g_usbd_core[busid].descriptors;
#endif

    /* Only when device is configured, then interface requests can be valid. */
    if (!is_device_configured(busid)) {
80006142:	00f14783          	lbu	a5,15(sp)
80006146:	853e                	mv	a0,a5
80006148:	1d0040ef          	jal	8000a318 <is_device_configured>
8000614c:	87aa                	mv	a5,a0
8000614e:	0017c793          	xor	a5,a5,1
80006152:	0ff7f793          	zext.b	a5,a5
80006156:	c399                	beqz	a5,8000615c <.L111>
        return false;
80006158:	4781                	li	a5,0
8000615a:	a435                	j	80006386 <.L112>

8000615c <.L111>:
    }

    switch (setup->bRequest) {
8000615c:	47a2                	lw	a5,8(sp)
8000615e:	0017c783          	lbu	a5,1(a5)
80006162:	472d                	li	a4,11
80006164:	20f76c63          	bltu	a4,a5,8000637c <.L113>
80006168:	00279713          	sll	a4,a5,0x2
8000616c:	800037b7          	lui	a5,0x80003
80006170:	50c78793          	add	a5,a5,1292 # 8000350c <.L115>
80006174:	97ba                	add	a5,a5,a4
80006176:	439c                	lw	a5,0(a5)
80006178:	8782                	jr	a5

8000617a <.L119>:
        case USB_REQUEST_GET_STATUS:
            (*data)[0] = 0x00;
8000617a:	4792                	lw	a5,4(sp)
8000617c:	439c                	lw	a5,0(a5)
8000617e:	00078023          	sb	zero,0(a5)
            (*data)[1] = 0x00;
80006182:	4792                	lw	a5,4(sp)
80006184:	439c                	lw	a5,0(a5)
80006186:	0785                	add	a5,a5,1
80006188:	00078023          	sb	zero,0(a5)
            *len = 2;
8000618c:	4782                	lw	a5,0(sp)
8000618e:	4709                	li	a4,2
80006190:	c398                	sw	a4,0(a5)
            break;
80006192:	aac5                	j	80006382 <.L120>

80006194 <.L117>:

        case USB_REQUEST_GET_DESCRIPTOR:
            if (type == 0x21) { /* HID_DESCRIPTOR_TYPE_HID */
80006194:	01d14703          	lbu	a4,29(sp)
80006198:	02100793          	li	a5,33
8000619c:	0af71863          	bne	a4,a5,8000624c <.L121>
                while (p[DESC_bLength] != 0U) {
800061a0:	a04d                	j	80006242 <.L122>

800061a2 <.L130>:
                    switch (p[DESC_bDescriptorType]) {
800061a2:	57a2                	lw	a5,40(sp)
800061a4:	0785                	add	a5,a5,1
800061a6:	0007c783          	lbu	a5,0(a5)
800061aa:	02100713          	li	a4,33
800061ae:	04e78263          	beq	a5,a4,800061f2 <.L123>
800061b2:	02100713          	li	a4,33
800061b6:	04f74f63          	blt	a4,a5,80006214 <.L135>
800061ba:	4709                	li	a4,2
800061bc:	00e78663          	beq	a5,a4,800061c8 <.L125>
800061c0:	4711                	li	a4,4
800061c2:	02e78163          	beq	a5,a4,800061e4 <.L126>
                                *len = p[DESC_bLength];
                                return true;
                            }
                            break;
                        default:
                            break;
800061c6:	a0b9                	j	80006214 <.L135>

800061c8 <.L125>:
                            current_desc_len = 0;
800061c8:	d002                	sw	zero,32(sp)
                            desc_len = (p[CONF_DESC_wTotalLength]) |
800061ca:	57a2                	lw	a5,40(sp)
800061cc:	0789                	add	a5,a5,2
800061ce:	0007c783          	lbu	a5,0(a5)
800061d2:	873e                	mv	a4,a5
                                       (p[CONF_DESC_wTotalLength + 1] << 8);
800061d4:	57a2                	lw	a5,40(sp)
800061d6:	078d                	add	a5,a5,3
800061d8:	0007c783          	lbu	a5,0(a5)
800061dc:	07a2                	sll	a5,a5,0x8
                            desc_len = (p[CONF_DESC_wTotalLength]) |
800061de:	8fd9                	or	a5,a5,a4
800061e0:	d23e                	sw	a5,36(sp)
                            break;
800061e2:	a825                	j	8000621a <.L127>

800061e4 <.L126>:
                            cur_iface = p[INTF_DESC_bInterfaceNumber];
800061e4:	57a2                	lw	a5,40(sp)
800061e6:	0789                	add	a5,a5,2
800061e8:	0007c783          	lbu	a5,0(a5)
800061ec:	00f10fa3          	sb	a5,31(sp)
                            break;
800061f0:	a02d                	j	8000621a <.L127>

800061f2 <.L123>:
                            if (cur_iface == intf_num) {
800061f2:	01f14703          	lbu	a4,31(sp)
800061f6:	01c14783          	lbu	a5,28(sp)
800061fa:	00f71f63          	bne	a4,a5,80006218 <.L136>
                                *data = (uint8_t *)p;
800061fe:	4792                	lw	a5,4(sp)
80006200:	5722                	lw	a4,40(sp)
80006202:	c398                	sw	a4,0(a5)
                                *len = p[DESC_bLength];
80006204:	57a2                	lw	a5,40(sp)
80006206:	0007c783          	lbu	a5,0(a5)
8000620a:	873e                	mv	a4,a5
8000620c:	4782                	lw	a5,0(sp)
8000620e:	c398                	sw	a4,0(a5)
                                return true;
80006210:	4785                	li	a5,1
80006212:	aa95                	j	80006386 <.L112>

80006214 <.L135>:
                            break;
80006214:	0001                	nop
80006216:	a011                	j	8000621a <.L127>

80006218 <.L136>:
                            break;
80006218:	0001                	nop

8000621a <.L127>:
                    }

                    /* skip to next descriptor */
                    p += p[DESC_bLength];
8000621a:	57a2                	lw	a5,40(sp)
8000621c:	0007c783          	lbu	a5,0(a5)
80006220:	873e                	mv	a4,a5
80006222:	57a2                	lw	a5,40(sp)
80006224:	97ba                	add	a5,a5,a4
80006226:	d43e                	sw	a5,40(sp)
                    current_desc_len += p[DESC_bLength];
80006228:	57a2                	lw	a5,40(sp)
8000622a:	0007c783          	lbu	a5,0(a5)
8000622e:	873e                	mv	a4,a5
80006230:	5782                	lw	a5,32(sp)
80006232:	97ba                	add	a5,a5,a4
80006234:	d03e                	sw	a5,32(sp)
                    if (current_desc_len >= desc_len && desc_len) {
80006236:	5702                	lw	a4,32(sp)
80006238:	5792                	lw	a5,36(sp)
8000623a:	00f76463          	bltu	a4,a5,80006242 <.L122>
8000623e:	5792                	lw	a5,36(sp)
80006240:	ebc1                	bnez	a5,800062d0 <.L137>

80006242 <.L122>:
                while (p[DESC_bLength] != 0U) {
80006242:	57a2                	lw	a5,40(sp)
80006244:	0007c783          	lbu	a5,0(a5)
80006248:	ffa9                	bnez	a5,800061a2 <.L130>
8000624a:	a061                	j	800062d2 <.L131>

8000624c <.L121>:
                        break;
                    }
                }
            } else if (type == 0x22) { /* HID_DESCRIPTOR_TYPE_HID_REPORT */
8000624c:	01d14703          	lbu	a4,29(sp)
80006250:	02200793          	li	a5,34
80006254:	06f71f63          	bne	a4,a5,800062d2 <.L131>

80006258 <.LBB4>:
                for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
80006258:	00010f23          	sb	zero,30(sp)
8000625c:	a891                	j	800062b0 <.L132>

8000625e <.L134>:
                    struct usbd_interface *intf = g_usbd_core[busid].intf[i];
8000625e:	00f14603          	lbu	a2,15(sp)
80006262:	01e14783          	lbu	a5,30(sp)
80006266:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000626a:	14f00693          	li	a3,335
8000626e:	02d606b3          	mul	a3,a2,a3
80006272:	97b6                	add	a5,a5,a3
80006274:	10878793          	add	a5,a5,264
80006278:	078a                	sll	a5,a5,0x2
8000627a:	97ba                	add	a5,a5,a4
8000627c:	43dc                	lw	a5,4(a5)
8000627e:	cc3e                	sw	a5,24(sp)

                    if (intf && (intf->intf_num == intf_num)) {
80006280:	47e2                	lw	a5,24(sp)
80006282:	c395                	beqz	a5,800062a6 <.L133>
80006284:	47e2                	lw	a5,24(sp)
80006286:	0187c783          	lbu	a5,24(a5)
8000628a:	01c14703          	lbu	a4,28(sp)
8000628e:	00f71c63          	bne	a4,a5,800062a6 <.L133>
                        *data = (uint8_t *)intf->hid_report_descriptor;
80006292:	47e2                	lw	a5,24(sp)
80006294:	4b98                	lw	a4,16(a5)
80006296:	4792                	lw	a5,4(sp)
80006298:	c398                	sw	a4,0(a5)
                        //memcpy(*data, intf->hid_report_descriptor, intf->hid_report_descriptor_len);
                        *len = intf->hid_report_descriptor_len;
8000629a:	47e2                	lw	a5,24(sp)
8000629c:	4bd8                	lw	a4,20(a5)
8000629e:	4782                	lw	a5,0(sp)
800062a0:	c398                	sw	a4,0(a5)
                        return true;
800062a2:	4785                	li	a5,1
800062a4:	a0cd                	j	80006386 <.L112>

800062a6 <.L133>:
                for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
800062a6:	01e14783          	lbu	a5,30(sp)
800062aa:	0785                	add	a5,a5,1
800062ac:	00f10f23          	sb	a5,30(sp)

800062b0 <.L132>:
800062b0:	00f14683          	lbu	a3,15(sp)
800062b4:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800062b8:	53c00793          	li	a5,1340
800062bc:	02f687b3          	mul	a5,a3,a5
800062c0:	97ba                	add	a5,a5,a4
800062c2:	4747c783          	lbu	a5,1140(a5)
800062c6:	01e14703          	lbu	a4,30(sp)
800062ca:	f8f76ae3          	bltu	a4,a5,8000625e <.L134>
800062ce:	a011                	j	800062d2 <.L131>

800062d0 <.L137>:
                        break;
800062d0:	0001                	nop

800062d2 <.L131>:
                    }
                }
            }
            ret = false;
800062d2:	020107a3          	sb	zero,47(sp)
            break;
800062d6:	a075                	j	80006382 <.L120>

800062d8 <.L118>:
        case USB_REQUEST_CLEAR_FEATURE:
        case USB_REQUEST_SET_FEATURE:
            ret = false;
800062d8:	020107a3          	sb	zero,47(sp)
            break;
800062dc:	a05d                	j	80006382 <.L120>

800062de <.L116>:
        case USB_REQUEST_GET_INTERFACE:
            (*data)[0] = g_usbd_core[busid].intf_altsetting[intf_num];
800062de:	00f14583          	lbu	a1,15(sp)
800062e2:	01c14683          	lbu	a3,28(sp)
800062e6:	4792                	lw	a5,4(sp)
800062e8:	4398                	lw	a4,0(a5)
800062ea:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
800062ee:	53c00793          	li	a5,1340
800062f2:	02f587b3          	mul	a5,a1,a5
800062f6:	97b2                	add	a5,a5,a2
800062f8:	97b6                	add	a5,a5,a3
800062fa:	4647c783          	lbu	a5,1124(a5)
800062fe:	00f70023          	sb	a5,0(a4)
            *len = 1;
80006302:	4782                	lw	a5,0(sp)
80006304:	4705                	li	a4,1
80006306:	c398                	sw	a4,0(a5)
            break;
80006308:	a8ad                	j	80006382 <.L120>

8000630a <.L114>:

        case USB_REQUEST_SET_INTERFACE:
            g_usbd_core[busid].intf_altsetting[intf_num] = LO_BYTE(setup->wValue);
8000630a:	47a2                	lw	a5,8(sp)
8000630c:	0027c703          	lbu	a4,2(a5)
80006310:	0037c783          	lbu	a5,3(a5)
80006314:	07a2                	sll	a5,a5,0x8
80006316:	8fd9                	or	a5,a5,a4
80006318:	07c2                	sll	a5,a5,0x10
8000631a:	83c1                	srl	a5,a5,0x10
8000631c:	00f14583          	lbu	a1,15(sp)
80006320:	01c14683          	lbu	a3,28(sp)
80006324:	0ff7f713          	zext.b	a4,a5
80006328:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
8000632c:	53c00793          	li	a5,1340
80006330:	02f587b3          	mul	a5,a1,a5
80006334:	97b2                	add	a5,a5,a2
80006336:	97b6                	add	a5,a5,a3
80006338:	46e78223          	sb	a4,1124(a5)
            usbd_set_interface(busid, setup->wIndex, setup->wValue);
8000633c:	47a2                	lw	a5,8(sp)
8000633e:	0047c703          	lbu	a4,4(a5)
80006342:	0057c783          	lbu	a5,5(a5)
80006346:	07a2                	sll	a5,a5,0x8
80006348:	8fd9                	or	a5,a5,a4
8000634a:	07c2                	sll	a5,a5,0x10
8000634c:	83c1                	srl	a5,a5,0x10
8000634e:	0ff7f693          	zext.b	a3,a5
80006352:	47a2                	lw	a5,8(sp)
80006354:	0027c703          	lbu	a4,2(a5)
80006358:	0037c783          	lbu	a5,3(a5)
8000635c:	07a2                	sll	a5,a5,0x8
8000635e:	8fd9                	or	a5,a5,a4
80006360:	07c2                	sll	a5,a5,0x10
80006362:	83c1                	srl	a5,a5,0x10
80006364:	0ff7f713          	zext.b	a4,a5
80006368:	00f14783          	lbu	a5,15(sp)
8000636c:	863a                	mv	a2,a4
8000636e:	85b6                	mv	a1,a3
80006370:	853e                	mv	a0,a5
80006372:	3ec9                	jal	80005f44 <usbd_set_interface>
            *len = 0;
80006374:	4782                	lw	a5,0(sp)
80006376:	0007a023          	sw	zero,0(a5)
            break;
8000637a:	a021                	j	80006382 <.L120>

8000637c <.L113>:

        default:
            ret = false;
8000637c:	020107a3          	sb	zero,47(sp)
            break;
80006380:	0001                	nop

80006382 <.L120>:
    }

    return ret;
80006382:	02f14783          	lbu	a5,47(sp)

80006386 <.L112>:
}
80006386:	853e                	mv	a0,a5
80006388:	50f2                	lw	ra,60(sp)
8000638a:	6121                	add	sp,sp,64
8000638c:	8082                	ret

Disassembly of section .text.usbd_class_request_handler:

8000638e <usbd_class_request_handler>:
 * @param [in,out] len      Pointer to data length
 *
 * @return true if the request was handled successfully
 */
static int usbd_class_request_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
8000638e:	7179                	add	sp,sp,-48
80006390:	d606                	sw	ra,44(sp)
80006392:	87aa                	mv	a5,a0
80006394:	c42e                	sw	a1,8(sp)
80006396:	c232                	sw	a2,4(sp)
80006398:	c036                	sw	a3,0(sp)
8000639a:	00f107a3          	sb	a5,15(sp)
    if ((setup->bmRequestType & USB_REQUEST_RECIPIENT_MASK) == USB_REQUEST_RECIPIENT_INTERFACE) {
8000639e:	47a2                	lw	a5,8(sp)
800063a0:	0007c783          	lbu	a5,0(a5)
800063a4:	0037f713          	and	a4,a5,3
800063a8:	4785                	li	a5,1
800063aa:	08f71c63          	bne	a4,a5,80006442 <.L167>

800063ae <.LBB6>:
        for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
800063ae:	00010fa3          	sb	zero,31(sp)
800063b2:	a885                	j	80006422 <.L168>

800063b4 <.L171>:
            struct usbd_interface *intf = g_usbd_core[busid].intf[i];
800063b4:	00f14603          	lbu	a2,15(sp)
800063b8:	01f14783          	lbu	a5,31(sp)
800063bc:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800063c0:	14f00693          	li	a3,335
800063c4:	02d606b3          	mul	a3,a2,a3
800063c8:	97b6                	add	a5,a5,a3
800063ca:	10878793          	add	a5,a5,264
800063ce:	078a                	sll	a5,a5,0x2
800063d0:	97ba                	add	a5,a5,a4
800063d2:	43dc                	lw	a5,4(a5)
800063d4:	ca3e                	sw	a5,20(sp)

            if (intf && intf->class_interface_handler && (intf->intf_num == (setup->wIndex & 0xFF))) {
800063d6:	47d2                	lw	a5,20(sp)
800063d8:	c3a1                	beqz	a5,80006418 <.L169>
800063da:	47d2                	lw	a5,20(sp)
800063dc:	439c                	lw	a5,0(a5)
800063de:	cf8d                	beqz	a5,80006418 <.L169>
800063e0:	47d2                	lw	a5,20(sp)
800063e2:	0187c783          	lbu	a5,24(a5)
800063e6:	86be                	mv	a3,a5
800063e8:	47a2                	lw	a5,8(sp)
800063ea:	0047c703          	lbu	a4,4(a5)
800063ee:	0057c783          	lbu	a5,5(a5)
800063f2:	07a2                	sll	a5,a5,0x8
800063f4:	8fd9                	or	a5,a5,a4
800063f6:	07c2                	sll	a5,a5,0x10
800063f8:	83c1                	srl	a5,a5,0x10
800063fa:	0ff7f793          	zext.b	a5,a5
800063fe:	00f69d63          	bne	a3,a5,80006418 <.L169>
                return intf->class_interface_handler(busid, setup, data, len);
80006402:	47d2                	lw	a5,20(sp)
80006404:	439c                	lw	a5,0(a5)
80006406:	00f14703          	lbu	a4,15(sp)
8000640a:	4682                	lw	a3,0(sp)
8000640c:	4612                	lw	a2,4(sp)
8000640e:	45a2                	lw	a1,8(sp)
80006410:	853a                	mv	a0,a4
80006412:	9782                	jalr	a5
80006414:	87aa                	mv	a5,a0
80006416:	a07d                	j	800064c4 <.L170>

80006418 <.L169>:
        for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
80006418:	01f14783          	lbu	a5,31(sp)
8000641c:	0785                	add	a5,a5,1
8000641e:	00f10fa3          	sb	a5,31(sp)

80006422 <.L168>:
80006422:	00f14683          	lbu	a3,15(sp)
80006426:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000642a:	53c00793          	li	a5,1340
8000642e:	02f687b3          	mul	a5,a3,a5
80006432:	97ba                	add	a5,a5,a4
80006434:	4747c783          	lbu	a5,1140(a5)
80006438:	01f14703          	lbu	a4,31(sp)
8000643c:	f6f76ce3          	bltu	a4,a5,800063b4 <.L171>
80006440:	a049                	j	800064c2 <.L172>

80006442 <.L167>:
            }
        }
    } else if ((setup->bmRequestType & USB_REQUEST_RECIPIENT_MASK) == USB_REQUEST_RECIPIENT_ENDPOINT) {
80006442:	47a2                	lw	a5,8(sp)
80006444:	0007c783          	lbu	a5,0(a5)
80006448:	0037f713          	and	a4,a5,3
8000644c:	4789                	li	a5,2
8000644e:	06f71a63          	bne	a4,a5,800064c2 <.L172>

80006452 <.LBB8>:
        for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
80006452:	00010f23          	sb	zero,30(sp)
80006456:	a0b9                	j	800064a4 <.L173>

80006458 <.L175>:
            struct usbd_interface *intf = g_usbd_core[busid].intf[i];
80006458:	00f14603          	lbu	a2,15(sp)
8000645c:	01e14783          	lbu	a5,30(sp)
80006460:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006464:	14f00693          	li	a3,335
80006468:	02d606b3          	mul	a3,a2,a3
8000646c:	97b6                	add	a5,a5,a3
8000646e:	10878793          	add	a5,a5,264
80006472:	078a                	sll	a5,a5,0x2
80006474:	97ba                	add	a5,a5,a4
80006476:	43dc                	lw	a5,4(a5)
80006478:	cc3e                	sw	a5,24(sp)

            if (intf && intf->class_endpoint_handler) {
8000647a:	47e2                	lw	a5,24(sp)
8000647c:	cf99                	beqz	a5,8000649a <.L174>
8000647e:	47e2                	lw	a5,24(sp)
80006480:	43dc                	lw	a5,4(a5)
80006482:	cf81                	beqz	a5,8000649a <.L174>
                return intf->class_endpoint_handler(busid, setup, data, len);
80006484:	47e2                	lw	a5,24(sp)
80006486:	43dc                	lw	a5,4(a5)
80006488:	00f14703          	lbu	a4,15(sp)
8000648c:	4682                	lw	a3,0(sp)
8000648e:	4612                	lw	a2,4(sp)
80006490:	45a2                	lw	a1,8(sp)
80006492:	853a                	mv	a0,a4
80006494:	9782                	jalr	a5
80006496:	87aa                	mv	a5,a0
80006498:	a035                	j	800064c4 <.L170>

8000649a <.L174>:
        for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
8000649a:	01e14783          	lbu	a5,30(sp)
8000649e:	0785                	add	a5,a5,1
800064a0:	00f10f23          	sb	a5,30(sp)

800064a4 <.L173>:
800064a4:	00f14683          	lbu	a3,15(sp)
800064a8:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800064ac:	53c00793          	li	a5,1340
800064b0:	02f687b3          	mul	a5,a3,a5
800064b4:	97ba                	add	a5,a5,a4
800064b6:	4747c783          	lbu	a5,1140(a5)
800064ba:	01e14703          	lbu	a4,30(sp)
800064be:	f8f76de3          	bltu	a4,a5,80006458 <.L175>

800064c2 <.L172>:
            }
        }
    }
    return -1;
800064c2:	57fd                	li	a5,-1

800064c4 <.L170>:
}
800064c4:	853e                	mv	a0,a5
800064c6:	50b2                	lw	ra,44(sp)
800064c8:	6145                	add	sp,sp,48
800064ca:	8082                	ret

Disassembly of section .text.usbd_vendor_request_handler:

800064cc <usbd_vendor_request_handler>:
 * @param [in,out] len      Pointer to data length
 *
 * @return true if the request was handled successfully
 */
static int usbd_vendor_request_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
800064cc:	7179                	add	sp,sp,-48
800064ce:	d606                	sw	ra,44(sp)
800064d0:	87aa                	mv	a5,a0
800064d2:	c42e                	sw	a1,8(sp)
800064d4:	c232                	sw	a2,4(sp)
800064d6:	c036                	sw	a3,0(sp)
800064d8:	00f107a3          	sb	a5,15(sp)
    uint32_t desclen;
#ifdef CONFIG_USBDEV_ADVANCE_DESC
    if (g_usbd_core[busid].descriptors->msosv1_descriptor) {
800064dc:	00f14683          	lbu	a3,15(sp)
800064e0:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800064e4:	53c00793          	li	a5,1340
800064e8:	02f687b3          	mul	a5,a3,a5
800064ec:	97ba                	add	a5,a5,a4
800064ee:	4f9c                	lw	a5,24(a5)
800064f0:	4bdc                	lw	a5,20(a5)
800064f2:	22078c63          	beqz	a5,8000672a <.L177>
        if (setup->bRequest == g_usbd_core[busid].descriptors->msosv1_descriptor->vendor_code) {
800064f6:	47a2                	lw	a5,8(sp)
800064f8:	0017c703          	lbu	a4,1(a5)
800064fc:	00f14603          	lbu	a2,15(sp)
80006500:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006504:	53c00793          	li	a5,1340
80006508:	02f607b3          	mul	a5,a2,a5
8000650c:	97b6                	add	a5,a5,a3
8000650e:	4f9c                	lw	a5,24(a5)
80006510:	4bdc                	lw	a5,20(a5)
80006512:	0047c783          	lbu	a5,4(a5)
80006516:	2ef71163          	bne	a4,a5,800067f8 <.L178>
            switch (setup->wIndex) {
8000651a:	47a2                	lw	a5,8(sp)
8000651c:	0047c703          	lbu	a4,4(a5)
80006520:	0057c783          	lbu	a5,5(a5)
80006524:	07a2                	sll	a5,a5,0x8
80006526:	8fd9                	or	a5,a5,a4
80006528:	07c2                	sll	a5,a5,0x10
8000652a:	83c1                	srl	a5,a5,0x10
8000652c:	4711                	li	a4,4
8000652e:	00e78663          	beq	a5,a4,8000653a <.L179>
80006532:	4715                	li	a4,5
80006534:	0ae78a63          	beq	a5,a4,800065e8 <.L180>
80006538:	aad9                	j	8000670e <.L189>

8000653a <.L179>:
                case 0x04:
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[0] +
8000653a:	00f14683          	lbu	a3,15(sp)
8000653e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006542:	53c00793          	li	a5,1340
80006546:	02f687b3          	mul	a5,a3,a5
8000654a:	97ba                	add	a5,a5,a4
8000654c:	4f9c                	lw	a5,24(a5)
8000654e:	4bdc                	lw	a5,20(a5)
80006550:	479c                	lw	a5,8(a5)
80006552:	0007c783          	lbu	a5,0(a5)
80006556:	863e                	mv	a2,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[1] << 8) +
80006558:	00f14683          	lbu	a3,15(sp)
8000655c:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006560:	53c00793          	li	a5,1340
80006564:	02f687b3          	mul	a5,a3,a5
80006568:	97ba                	add	a5,a5,a4
8000656a:	4f9c                	lw	a5,24(a5)
8000656c:	4bdc                	lw	a5,20(a5)
8000656e:	479c                	lw	a5,8(a5)
80006570:	0785                	add	a5,a5,1
80006572:	0007c783          	lbu	a5,0(a5)
80006576:	07a2                	sll	a5,a5,0x8
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[0] +
80006578:	00f60733          	add	a4,a2,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[2] << 16) +
8000657c:	00f14603          	lbu	a2,15(sp)
80006580:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006584:	53c00793          	li	a5,1340
80006588:	02f607b3          	mul	a5,a2,a5
8000658c:	97b6                	add	a5,a5,a3
8000658e:	4f9c                	lw	a5,24(a5)
80006590:	4bdc                	lw	a5,20(a5)
80006592:	479c                	lw	a5,8(a5)
80006594:	0789                	add	a5,a5,2
80006596:	0007c783          	lbu	a5,0(a5)
8000659a:	07c2                	sll	a5,a5,0x10
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[1] << 8) +
8000659c:	973e                	add	a4,a4,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[3] << 24);
8000659e:	00f14603          	lbu	a2,15(sp)
800065a2:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
800065a6:	53c00793          	li	a5,1340
800065aa:	02f607b3          	mul	a5,a2,a5
800065ae:	97b6                	add	a5,a5,a3
800065b0:	4f9c                	lw	a5,24(a5)
800065b2:	4bdc                	lw	a5,20(a5)
800065b4:	479c                	lw	a5,8(a5)
800065b6:	078d                	add	a5,a5,3
800065b8:	0007c783          	lbu	a5,0(a5)
800065bc:	07e2                	sll	a5,a5,0x18
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[2] << 16) +
800065be:	97ba                	add	a5,a5,a4
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id[0] +
800065c0:	cc3e                	sw	a5,24(sp)

                    *data = (uint8_t *)g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id;
800065c2:	00f14683          	lbu	a3,15(sp)
800065c6:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800065ca:	53c00793          	li	a5,1340
800065ce:	02f687b3          	mul	a5,a3,a5
800065d2:	97ba                	add	a5,a5,a4
800065d4:	4f9c                	lw	a5,24(a5)
800065d6:	4bdc                	lw	a5,20(a5)
800065d8:	4798                	lw	a4,8(a5)
800065da:	4792                	lw	a5,4(sp)
800065dc:	c398                	sw	a4,0(a5)
                    //memcpy(*data, g_usbd_core[busid].descriptors->msosv1_descriptor->compat_id, desclen);
                    *len = desclen;
800065de:	4782                	lw	a5,0(sp)
800065e0:	4762                	lw	a4,24(sp)
800065e2:	c398                	sw	a4,0(a5)
                    return 0;
800065e4:	4781                	li	a5,0
800065e6:	ae85                	j	80006956 <.L182>

800065e8 <.L180>:
                case 0x05:
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][0] +
800065e8:	00f14683          	lbu	a3,15(sp)
800065ec:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800065f0:	53c00793          	li	a5,1340
800065f4:	02f687b3          	mul	a5,a3,a5
800065f8:	97ba                	add	a5,a5,a4
800065fa:	4f9c                	lw	a5,24(a5)
800065fc:	4bdc                	lw	a5,20(a5)
800065fe:	47d8                	lw	a4,12(a5)
80006600:	47a2                	lw	a5,8(sp)
80006602:	0027c683          	lbu	a3,2(a5)
80006606:	0037c783          	lbu	a5,3(a5)
8000660a:	07a2                	sll	a5,a5,0x8
8000660c:	8fd5                	or	a5,a5,a3
8000660e:	07c2                	sll	a5,a5,0x10
80006610:	83c1                	srl	a5,a5,0x10
80006612:	078a                	sll	a5,a5,0x2
80006614:	97ba                	add	a5,a5,a4
80006616:	439c                	lw	a5,0(a5)
80006618:	0007c783          	lbu	a5,0(a5)
8000661c:	863e                	mv	a2,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][1] << 8) +
8000661e:	00f14683          	lbu	a3,15(sp)
80006622:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006626:	53c00793          	li	a5,1340
8000662a:	02f687b3          	mul	a5,a3,a5
8000662e:	97ba                	add	a5,a5,a4
80006630:	4f9c                	lw	a5,24(a5)
80006632:	4bdc                	lw	a5,20(a5)
80006634:	47d8                	lw	a4,12(a5)
80006636:	47a2                	lw	a5,8(sp)
80006638:	0027c683          	lbu	a3,2(a5)
8000663c:	0037c783          	lbu	a5,3(a5)
80006640:	07a2                	sll	a5,a5,0x8
80006642:	8fd5                	or	a5,a5,a3
80006644:	07c2                	sll	a5,a5,0x10
80006646:	83c1                	srl	a5,a5,0x10
80006648:	078a                	sll	a5,a5,0x2
8000664a:	97ba                	add	a5,a5,a4
8000664c:	439c                	lw	a5,0(a5)
8000664e:	0785                	add	a5,a5,1
80006650:	0007c783          	lbu	a5,0(a5)
80006654:	07a2                	sll	a5,a5,0x8
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][0] +
80006656:	00f60733          	add	a4,a2,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][2] << 16) +
8000665a:	00f14603          	lbu	a2,15(sp)
8000665e:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006662:	53c00793          	li	a5,1340
80006666:	02f607b3          	mul	a5,a2,a5
8000666a:	97b6                	add	a5,a5,a3
8000666c:	4f9c                	lw	a5,24(a5)
8000666e:	4bdc                	lw	a5,20(a5)
80006670:	47d4                	lw	a3,12(a5)
80006672:	47a2                	lw	a5,8(sp)
80006674:	0027c603          	lbu	a2,2(a5)
80006678:	0037c783          	lbu	a5,3(a5)
8000667c:	07a2                	sll	a5,a5,0x8
8000667e:	8fd1                	or	a5,a5,a2
80006680:	07c2                	sll	a5,a5,0x10
80006682:	83c1                	srl	a5,a5,0x10
80006684:	078a                	sll	a5,a5,0x2
80006686:	97b6                	add	a5,a5,a3
80006688:	439c                	lw	a5,0(a5)
8000668a:	0789                	add	a5,a5,2
8000668c:	0007c783          	lbu	a5,0(a5)
80006690:	07c2                	sll	a5,a5,0x10
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][1] << 8) +
80006692:	973e                	add	a4,a4,a5
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][3] << 24);
80006694:	00f14603          	lbu	a2,15(sp)
80006698:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000669c:	53c00793          	li	a5,1340
800066a0:	02f607b3          	mul	a5,a2,a5
800066a4:	97b6                	add	a5,a5,a3
800066a6:	4f9c                	lw	a5,24(a5)
800066a8:	4bdc                	lw	a5,20(a5)
800066aa:	47d4                	lw	a3,12(a5)
800066ac:	47a2                	lw	a5,8(sp)
800066ae:	0027c603          	lbu	a2,2(a5)
800066b2:	0037c783          	lbu	a5,3(a5)
800066b6:	07a2                	sll	a5,a5,0x8
800066b8:	8fd1                	or	a5,a5,a2
800066ba:	07c2                	sll	a5,a5,0x10
800066bc:	83c1                	srl	a5,a5,0x10
800066be:	078a                	sll	a5,a5,0x2
800066c0:	97b6                	add	a5,a5,a3
800066c2:	439c                	lw	a5,0(a5)
800066c4:	078d                	add	a5,a5,3
800066c6:	0007c783          	lbu	a5,0(a5)
800066ca:	07e2                	sll	a5,a5,0x18
                              (g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][2] << 16) +
800066cc:	97ba                	add	a5,a5,a4
                    desclen = g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue][0] +
800066ce:	cc3e                	sw	a5,24(sp)

                    *data = (uint8_t *)g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue];
800066d0:	00f14683          	lbu	a3,15(sp)
800066d4:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800066d8:	53c00793          	li	a5,1340
800066dc:	02f687b3          	mul	a5,a3,a5
800066e0:	97ba                	add	a5,a5,a4
800066e2:	4f9c                	lw	a5,24(a5)
800066e4:	4bdc                	lw	a5,20(a5)
800066e6:	47d8                	lw	a4,12(a5)
800066e8:	47a2                	lw	a5,8(sp)
800066ea:	0027c683          	lbu	a3,2(a5)
800066ee:	0037c783          	lbu	a5,3(a5)
800066f2:	07a2                	sll	a5,a5,0x8
800066f4:	8fd5                	or	a5,a5,a3
800066f6:	07c2                	sll	a5,a5,0x10
800066f8:	83c1                	srl	a5,a5,0x10
800066fa:	078a                	sll	a5,a5,0x2
800066fc:	97ba                	add	a5,a5,a4
800066fe:	4398                	lw	a4,0(a5)
80006700:	4792                	lw	a5,4(sp)
80006702:	c398                	sw	a4,0(a5)
                    //memcpy(*data, g_usbd_core[busid].descriptors->msosv1_descriptor->comp_id_property[setup->wValue], desclen);
                    *len = desclen;
80006704:	4782                	lw	a5,0(sp)
80006706:	4762                	lw	a4,24(sp)
80006708:	c398                	sw	a4,0(a5)
                    return 0;
8000670a:	4781                	li	a5,0
8000670c:	a4a9                	j	80006956 <.L182>

8000670e <.L189>:
                default:
                    USB_LOG_ERR("unknown vendor code\r\n");
8000670e:	800057b7          	lui	a5,0x80005
80006712:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
80006716:	5c6020ef          	jal	80008cdc <printf>
8000671a:	800057b7          	lui	a5,0x80005
8000671e:	08878513          	add	a0,a5,136 # 80005088 <.LC7>
80006722:	5ba020ef          	jal	80008cdc <printf>
                    return -1;
80006726:	57fd                	li	a5,-1
80006728:	a43d                	j	80006956 <.L182>

8000672a <.L177>:
            }
        }
    } else if (g_usbd_core[busid].descriptors->msosv2_descriptor) {
8000672a:	00f14683          	lbu	a3,15(sp)
8000672e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006732:	53c00793          	li	a5,1340
80006736:	02f687b3          	mul	a5,a3,a5
8000673a:	97ba                	add	a5,a5,a4
8000673c:	4f9c                	lw	a5,24(a5)
8000673e:	4f9c                	lw	a5,24(a5)
80006740:	cfc5                	beqz	a5,800067f8 <.L178>
        if (setup->bRequest == g_usbd_core[busid].descriptors->msosv2_descriptor->vendor_code) {
80006742:	47a2                	lw	a5,8(sp)
80006744:	0017c703          	lbu	a4,1(a5)
80006748:	00f14603          	lbu	a2,15(sp)
8000674c:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006750:	53c00793          	li	a5,1340
80006754:	02f607b3          	mul	a5,a2,a5
80006758:	97b6                	add	a5,a5,a3
8000675a:	4f9c                	lw	a5,24(a5)
8000675c:	4f9c                	lw	a5,24(a5)
8000675e:	0067c783          	lbu	a5,6(a5)
80006762:	08f71b63          	bne	a4,a5,800067f8 <.L178>
            switch (setup->wIndex) {
80006766:	47a2                	lw	a5,8(sp)
80006768:	0047c703          	lbu	a4,4(a5)
8000676c:	0057c783          	lbu	a5,5(a5)
80006770:	07a2                	sll	a5,a5,0x8
80006772:	8fd9                	or	a5,a5,a4
80006774:	07c2                	sll	a5,a5,0x10
80006776:	83c1                	srl	a5,a5,0x10
80006778:	873e                	mv	a4,a5
8000677a:	479d                	li	a5,7
8000677c:	06f71063          	bne	a4,a5,800067dc <.L183>
                case WINUSB_REQUEST_GET_DESCRIPTOR_SET:
                    desclen = g_usbd_core[busid].descriptors->msosv2_descriptor->compat_id_len;
80006780:	00f14683          	lbu	a3,15(sp)
80006784:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006788:	53c00793          	li	a5,1340
8000678c:	02f687b3          	mul	a5,a3,a5
80006790:	97ba                	add	a5,a5,a4
80006792:	4f9c                	lw	a5,24(a5)
80006794:	4f9c                	lw	a5,24(a5)
80006796:	0047d783          	lhu	a5,4(a5)
8000679a:	cc3e                	sw	a5,24(sp)
                    *data = (uint8_t *)g_usbd_core[busid].descriptors->msosv2_descriptor->compat_id;
8000679c:	00f14683          	lbu	a3,15(sp)
800067a0:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800067a4:	53c00793          	li	a5,1340
800067a8:	02f687b3          	mul	a5,a3,a5
800067ac:	97ba                	add	a5,a5,a4
800067ae:	4f9c                	lw	a5,24(a5)
800067b0:	4f9c                	lw	a5,24(a5)
800067b2:	4398                	lw	a4,0(a5)
800067b4:	4792                	lw	a5,4(sp)
800067b6:	c398                	sw	a4,0(a5)
                    //memcpy(*data, g_usbd_core[busid].descriptors->msosv2_descriptor->compat_id, desclen);
                    *len = g_usbd_core[busid].descriptors->msosv2_descriptor->compat_id_len;
800067b8:	00f14683          	lbu	a3,15(sp)
800067bc:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800067c0:	53c00793          	li	a5,1340
800067c4:	02f687b3          	mul	a5,a3,a5
800067c8:	97ba                	add	a5,a5,a4
800067ca:	4f9c                	lw	a5,24(a5)
800067cc:	4f9c                	lw	a5,24(a5)
800067ce:	0047d783          	lhu	a5,4(a5)
800067d2:	873e                	mv	a4,a5
800067d4:	4782                	lw	a5,0(sp)
800067d6:	c398                	sw	a4,0(a5)
                    return 0;
800067d8:	4781                	li	a5,0
800067da:	aab5                	j	80006956 <.L182>

800067dc <.L183>:
                default:
                    USB_LOG_ERR("unknown vendor code\r\n");
800067dc:	800057b7          	lui	a5,0x80005
800067e0:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
800067e4:	4f8020ef          	jal	80008cdc <printf>
800067e8:	800057b7          	lui	a5,0x80005
800067ec:	08878513          	add	a0,a5,136 # 80005088 <.LC7>
800067f0:	4ec020ef          	jal	80008cdc <printf>
                    return -1;
800067f4:	57fd                	li	a5,-1
800067f6:	a285                	j	80006956 <.L182>

800067f8 <.L178>:
            }
        }
    }

    if (g_usbd_core[busid].descriptors->webusb_url_descriptor) {
800067f8:	00f14683          	lbu	a3,15(sp)
800067fc:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006800:	53c00793          	li	a5,1340
80006804:	02f687b3          	mul	a5,a3,a5
80006808:	97ba                	add	a5,a5,a4
8000680a:	4f9c                	lw	a5,24(a5)
8000680c:	4fdc                	lw	a5,28(a5)
8000680e:	cbe9                	beqz	a5,800068e0 <.L184>
        if (setup->bRequest == g_usbd_core[busid].descriptors->webusb_url_descriptor->vendor_code) {
80006810:	47a2                	lw	a5,8(sp)
80006812:	0017c703          	lbu	a4,1(a5)
80006816:	00f14603          	lbu	a2,15(sp)
8000681a:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000681e:	53c00793          	li	a5,1340
80006822:	02f607b3          	mul	a5,a2,a5
80006826:	97b6                	add	a5,a5,a3
80006828:	4f9c                	lw	a5,24(a5)
8000682a:	4fdc                	lw	a5,28(a5)
8000682c:	0007c783          	lbu	a5,0(a5)
80006830:	0af71863          	bne	a4,a5,800068e0 <.L184>
            switch (setup->wIndex) {
80006834:	47a2                	lw	a5,8(sp)
80006836:	0047c703          	lbu	a4,4(a5)
8000683a:	0057c783          	lbu	a5,5(a5)
8000683e:	07a2                	sll	a5,a5,0x8
80006840:	8fd9                	or	a5,a5,a4
80006842:	07c2                	sll	a5,a5,0x10
80006844:	83c1                	srl	a5,a5,0x10
80006846:	873e                	mv	a4,a5
80006848:	4789                	li	a5,2
8000684a:	06f71d63          	bne	a4,a5,800068c4 <.L185>
                case WEBUSB_REQUEST_GET_URL:
                    desclen = g_usbd_core[busid].descriptors->webusb_url_descriptor->string_len;
8000684e:	00f14683          	lbu	a3,15(sp)
80006852:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006856:	53c00793          	li	a5,1340
8000685a:	02f687b3          	mul	a5,a3,a5
8000685e:	97ba                	add	a5,a5,a4
80006860:	4f9c                	lw	a5,24(a5)
80006862:	4fdc                	lw	a5,28(a5)
80006864:	0057c703          	lbu	a4,5(a5)
80006868:	0067c683          	lbu	a3,6(a5)
8000686c:	06a2                	sll	a3,a3,0x8
8000686e:	8f55                	or	a4,a4,a3
80006870:	0077c683          	lbu	a3,7(a5)
80006874:	06c2                	sll	a3,a3,0x10
80006876:	8f55                	or	a4,a4,a3
80006878:	0087c783          	lbu	a5,8(a5)
8000687c:	07e2                	sll	a5,a5,0x18
8000687e:	8fd9                	or	a5,a5,a4
80006880:	cc3e                	sw	a5,24(sp)
                    *data = (uint8_t *)g_usbd_core[busid].descriptors->webusb_url_descriptor->string;
80006882:	00f14683          	lbu	a3,15(sp)
80006886:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000688a:	53c00793          	li	a5,1340
8000688e:	02f687b3          	mul	a5,a3,a5
80006892:	97ba                	add	a5,a5,a4
80006894:	4f9c                	lw	a5,24(a5)
80006896:	4fdc                	lw	a5,28(a5)
80006898:	0017c703          	lbu	a4,1(a5)
8000689c:	0027c683          	lbu	a3,2(a5)
800068a0:	06a2                	sll	a3,a3,0x8
800068a2:	8f55                	or	a4,a4,a3
800068a4:	0037c683          	lbu	a3,3(a5)
800068a8:	06c2                	sll	a3,a3,0x10
800068aa:	8f55                	or	a4,a4,a3
800068ac:	0047c783          	lbu	a5,4(a5)
800068b0:	07e2                	sll	a5,a5,0x18
800068b2:	8fd9                	or	a5,a5,a4
800068b4:	873e                	mv	a4,a5
800068b6:	4792                	lw	a5,4(sp)
800068b8:	c398                	sw	a4,0(a5)
                    //memcpy(*data, g_usbd_core[busid].descriptors->webusb_url_descriptor->string, desclen);
                    *len = desclen;
800068ba:	4782                	lw	a5,0(sp)
800068bc:	4762                	lw	a4,24(sp)
800068be:	c398                	sw	a4,0(a5)
                    return 0;
800068c0:	4781                	li	a5,0
800068c2:	a851                	j	80006956 <.L182>

800068c4 <.L185>:
                default:
                    USB_LOG_ERR("unknown vendor code\r\n");
800068c4:	800057b7          	lui	a5,0x80005
800068c8:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
800068cc:	410020ef          	jal	80008cdc <printf>
800068d0:	800057b7          	lui	a5,0x80005
800068d4:	08878513          	add	a0,a5,136 # 80005088 <.LC7>
800068d8:	404020ef          	jal	80008cdc <printf>
                    return -1;
800068dc:	57fd                	li	a5,-1
800068de:	a8a5                	j	80006956 <.L182>

800068e0 <.L184>:
                    return -1;
            }
        }
    }
#endif
    for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
800068e0:	00010fa3          	sb	zero,31(sp)
800068e4:	a889                	j	80006936 <.L186>

800068e6 <.L188>:
        struct usbd_interface *intf = g_usbd_core[busid].intf[i];
800068e6:	00f14603          	lbu	a2,15(sp)
800068ea:	01f14783          	lbu	a5,31(sp)
800068ee:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800068f2:	14f00693          	li	a3,335
800068f6:	02d606b3          	mul	a3,a2,a3
800068fa:	97b6                	add	a5,a5,a3
800068fc:	10878793          	add	a5,a5,264
80006900:	078a                	sll	a5,a5,0x2
80006902:	97ba                	add	a5,a5,a4
80006904:	43dc                	lw	a5,4(a5)
80006906:	ca3e                	sw	a5,20(sp)

        if (intf && intf->vendor_handler && (intf->vendor_handler(busid, setup, data, len) == 0)) {
80006908:	47d2                	lw	a5,20(sp)
8000690a:	c38d                	beqz	a5,8000692c <.L187>
8000690c:	47d2                	lw	a5,20(sp)
8000690e:	479c                	lw	a5,8(a5)
80006910:	cf91                	beqz	a5,8000692c <.L187>
80006912:	47d2                	lw	a5,20(sp)
80006914:	479c                	lw	a5,8(a5)
80006916:	00f14703          	lbu	a4,15(sp)
8000691a:	4682                	lw	a3,0(sp)
8000691c:	4612                	lw	a2,4(sp)
8000691e:	45a2                	lw	a1,8(sp)
80006920:	853a                	mv	a0,a4
80006922:	9782                	jalr	a5
80006924:	87aa                	mv	a5,a0
80006926:	e399                	bnez	a5,8000692c <.L187>
            return 0;
80006928:	4781                	li	a5,0
8000692a:	a035                	j	80006956 <.L182>

8000692c <.L187>:
    for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
8000692c:	01f14783          	lbu	a5,31(sp)
80006930:	0785                	add	a5,a5,1
80006932:	00f10fa3          	sb	a5,31(sp)

80006936 <.L186>:
80006936:	00f14683          	lbu	a3,15(sp)
8000693a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000693e:	53c00793          	li	a5,1340
80006942:	02f687b3          	mul	a5,a3,a5
80006946:	97ba                	add	a5,a5,a4
80006948:	4747c783          	lbu	a5,1140(a5)
8000694c:	01f14703          	lbu	a4,31(sp)
80006950:	f8f76be3          	bltu	a4,a5,800068e6 <.L188>

80006954 <.LBE10>:
        }
    }

    return -1;
80006954:	57fd                	li	a5,-1

80006956 <.L182>:
}
80006956:	853e                	mv	a0,a5
80006958:	50b2                	lw	ra,44(sp)
8000695a:	6145                	add	sp,sp,48
8000695c:	8082                	ret

Disassembly of section .text.usbd_setup_request_handler:

8000695e <usbd_setup_request_handler>:
 * @param [in,out] len   Pointer to data length
 *
 * @return true if the request was handles successfully
 */
static bool usbd_setup_request_handler(uint8_t busid, struct usb_setup_packet *setup, uint8_t **data, uint32_t *len)
{
8000695e:	1101                	add	sp,sp,-32
80006960:	ce06                	sw	ra,28(sp)
80006962:	87aa                	mv	a5,a0
80006964:	c42e                	sw	a1,8(sp)
80006966:	c232                	sw	a2,4(sp)
80006968:	c036                	sw	a3,0(sp)
8000696a:	00f107a3          	sb	a5,15(sp)
    switch (setup->bmRequestType & USB_REQUEST_TYPE_MASK) {
8000696e:	47a2                	lw	a5,8(sp)
80006970:	0007c783          	lbu	a5,0(a5)
80006974:	0607f793          	and	a5,a5,96
80006978:	04000713          	li	a4,64
8000697c:	0ae78963          	beq	a5,a4,80006a2e <.L191>
80006980:	04000713          	li	a4,64
80006984:	0ef76063          	bltu	a4,a5,80006a64 <.L192>
80006988:	c791                	beqz	a5,80006994 <.L193>
8000698a:	02000713          	li	a4,32
8000698e:	06e78563          	beq	a5,a4,800069f8 <.L194>
80006992:	a8c9                	j	80006a64 <.L192>

80006994 <.L193>:
        case USB_REQUEST_STANDARD:
            if (usbd_standard_request_handler(busid, setup, data, len) < 0) {
80006994:	00f14783          	lbu	a5,15(sp)
80006998:	4682                	lw	a3,0(sp)
8000699a:	4612                	lw	a2,4(sp)
8000699c:	45a2                	lw	a1,8(sp)
8000699e:	853e                	mv	a0,a5
800069a0:	5dd030ef          	jal	8000a77c <usbd_standard_request_handler>
800069a4:	87aa                	mv	a5,a0
800069a6:	0c07d163          	bgez	a5,80006a68 <.L201>
                /* Ignore error log for getting Device Qualifier Descriptor request */
                if ((setup->bRequest == 0x06) && (setup->wValue == 0x0600)) {
800069aa:	47a2                	lw	a5,8(sp)
800069ac:	0017c703          	lbu	a4,1(a5)
800069b0:	4799                	li	a5,6
800069b2:	02f71263          	bne	a4,a5,800069d6 <.L196>
800069b6:	47a2                	lw	a5,8(sp)
800069b8:	0027c703          	lbu	a4,2(a5)
800069bc:	0037c783          	lbu	a5,3(a5)
800069c0:	07a2                	sll	a5,a5,0x8
800069c2:	8fd9                	or	a5,a5,a4
800069c4:	01079713          	sll	a4,a5,0x10
800069c8:	8341                	srl	a4,a4,0x10
800069ca:	60000793          	li	a5,1536
800069ce:	00f71463          	bne	a4,a5,800069d6 <.L196>
                    //USB_LOG_DBG("Ignore DQD in fs\r\n");
                    return false;
800069d2:	4781                	li	a5,0
800069d4:	a045                	j	80006a74 <.L197>

800069d6 <.L196>:
                }
                USB_LOG_ERR("standard request error\r\n");
800069d6:	800057b7          	lui	a5,0x80005
800069da:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
800069de:	2fe020ef          	jal	80008cdc <printf>
800069e2:	800057b7          	lui	a5,0x80005
800069e6:	0a078513          	add	a0,a5,160 # 800050a0 <.LC8>
800069ea:	2f2020ef          	jal	80008cdc <printf>
                usbd_print_setup(setup);
800069ee:	4522                	lw	a0,8(sp)
800069f0:	df3fe0ef          	jal	800057e2 <usbd_print_setup>
                return false;
800069f4:	4781                	li	a5,0
800069f6:	a8bd                	j	80006a74 <.L197>

800069f8 <.L194>:
            }
            break;
        case USB_REQUEST_CLASS:
            if (usbd_class_request_handler(busid, setup, data, len) < 0) {
800069f8:	00f14783          	lbu	a5,15(sp)
800069fc:	4682                	lw	a3,0(sp)
800069fe:	4612                	lw	a2,4(sp)
80006a00:	45a2                	lw	a1,8(sp)
80006a02:	853e                	mv	a0,a5
80006a04:	3269                	jal	8000638e <usbd_class_request_handler>
80006a06:	87aa                	mv	a5,a0
80006a08:	0607d263          	bgez	a5,80006a6c <.L202>
                USB_LOG_ERR("class request error\r\n");
80006a0c:	800057b7          	lui	a5,0x80005
80006a10:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
80006a14:	2c8020ef          	jal	80008cdc <printf>
80006a18:	800057b7          	lui	a5,0x80005
80006a1c:	0bc78513          	add	a0,a5,188 # 800050bc <.LC9>
80006a20:	2bc020ef          	jal	80008cdc <printf>
                usbd_print_setup(setup);
80006a24:	4522                	lw	a0,8(sp)
80006a26:	dbdfe0ef          	jal	800057e2 <usbd_print_setup>
                return false;
80006a2a:	4781                	li	a5,0
80006a2c:	a0a1                	j	80006a74 <.L197>

80006a2e <.L191>:
            }
            break;
        case USB_REQUEST_VENDOR:
            if (usbd_vendor_request_handler(busid, setup, data, len) < 0) {
80006a2e:	00f14783          	lbu	a5,15(sp)
80006a32:	4682                	lw	a3,0(sp)
80006a34:	4612                	lw	a2,4(sp)
80006a36:	45a2                	lw	a1,8(sp)
80006a38:	853e                	mv	a0,a5
80006a3a:	3c49                	jal	800064cc <usbd_vendor_request_handler>
80006a3c:	87aa                	mv	a5,a0
80006a3e:	0207d963          	bgez	a5,80006a70 <.L203>
                USB_LOG_ERR("vendor request error\r\n");
80006a42:	800057b7          	lui	a5,0x80005
80006a46:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
80006a4a:	292020ef          	jal	80008cdc <printf>
80006a4e:	800057b7          	lui	a5,0x80005
80006a52:	0d478513          	add	a0,a5,212 # 800050d4 <.LC10>
80006a56:	286020ef          	jal	80008cdc <printf>
                usbd_print_setup(setup);
80006a5a:	4522                	lw	a0,8(sp)
80006a5c:	d87fe0ef          	jal	800057e2 <usbd_print_setup>
                return false;
80006a60:	4781                	li	a5,0
80006a62:	a809                	j	80006a74 <.L197>

80006a64 <.L192>:
            }
            break;

        default:
            return false;
80006a64:	4781                	li	a5,0
80006a66:	a039                	j	80006a74 <.L197>

80006a68 <.L201>:
            break;
80006a68:	0001                	nop
80006a6a:	a021                	j	80006a72 <.L198>

80006a6c <.L202>:
            break;
80006a6c:	0001                	nop
80006a6e:	a011                	j	80006a72 <.L198>

80006a70 <.L203>:
            break;
80006a70:	0001                	nop

80006a72 <.L198>:
    }

    return true;
80006a72:	4785                	li	a5,1

80006a74 <.L197>:
}
80006a74:	853e                	mv	a0,a5
80006a76:	40f2                	lw	ra,28(sp)
80006a78:	6105                	add	sp,sp,32
80006a7a:	8082                	ret

Disassembly of section .text.usbd_event_connect_handler:

80006a7c <usbd_event_connect_handler>:
        }
    }
}

void usbd_event_connect_handler(uint8_t busid)
{
80006a7c:	1101                	add	sp,sp,-32
80006a7e:	ce06                	sw	ra,28(sp)
80006a80:	87aa                	mv	a5,a0
80006a82:	00f107a3          	sb	a5,15(sp)
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_CONNECTED);
80006a86:	00f14683          	lbu	a3,15(sp)
80006a8a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006a8e:	53c00793          	li	a5,1340
80006a92:	02f687b3          	mul	a5,a3,a5
80006a96:	97ba                	add	a5,a5,a4
80006a98:	5387a783          	lw	a5,1336(a5)
80006a9c:	00f14703          	lbu	a4,15(sp)
80006aa0:	458d                	li	a1,3
80006aa2:	853a                	mv	a0,a4
80006aa4:	9782                	jalr	a5
}
80006aa6:	0001                	nop
80006aa8:	40f2                	lw	ra,28(sp)
80006aaa:	6105                	add	sp,sp,32
80006aac:	8082                	ret

Disassembly of section .text.usbd_event_disconnect_handler:

80006aae <usbd_event_disconnect_handler>:

void usbd_event_disconnect_handler(uint8_t busid)
{
80006aae:	1101                	add	sp,sp,-32
80006ab0:	ce06                	sw	ra,28(sp)
80006ab2:	87aa                	mv	a5,a0
80006ab4:	00f107a3          	sb	a5,15(sp)
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_DISCONNECTED);
80006ab8:	00f14683          	lbu	a3,15(sp)
80006abc:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006ac0:	53c00793          	li	a5,1340
80006ac4:	02f687b3          	mul	a5,a3,a5
80006ac8:	97ba                	add	a5,a5,a4
80006aca:	5387a783          	lw	a5,1336(a5)
80006ace:	00f14703          	lbu	a4,15(sp)
80006ad2:	4591                	li	a1,4
80006ad4:	853a                	mv	a0,a4
80006ad6:	9782                	jalr	a5
}
80006ad8:	0001                	nop
80006ada:	40f2                	lw	ra,28(sp)
80006adc:	6105                	add	sp,sp,32
80006ade:	8082                	ret

Disassembly of section .text.usbd_event_suspend_handler:

80006ae0 <usbd_event_suspend_handler>:
    g_usbd_core[busid].is_suspend = false;
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_RESUME);
}

void usbd_event_suspend_handler(uint8_t busid)
{
80006ae0:	1101                	add	sp,sp,-32
80006ae2:	ce06                	sw	ra,28(sp)
80006ae4:	87aa                	mv	a5,a0
80006ae6:	00f107a3          	sb	a5,15(sp)
    if (g_usbd_core[busid].device_address > 0) {
80006aea:	00f14683          	lbu	a3,15(sp)
80006aee:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006af2:	53c00793          	li	a5,1340
80006af6:	02f687b3          	mul	a5,a3,a5
80006afa:	97ba                	add	a5,a5,a4
80006afc:	41d7c783          	lbu	a5,1053(a5)
80006b00:	cf8d                	beqz	a5,80006b3a <.L214>
        g_usbd_core[busid].is_suspend = true;
80006b02:	00f14683          	lbu	a3,15(sp)
80006b06:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006b0a:	53c00793          	li	a5,1340
80006b0e:	02f687b3          	mul	a5,a3,a5
80006b12:	97ba                	add	a5,a5,a4
80006b14:	4705                	li	a4,1
80006b16:	42e780a3          	sb	a4,1057(a5)
        g_usbd_core[busid].event_handler(busid, USBD_EVENT_SUSPEND);
80006b1a:	00f14683          	lbu	a3,15(sp)
80006b1e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006b22:	53c00793          	li	a5,1340
80006b26:	02f687b3          	mul	a5,a3,a5
80006b2a:	97ba                	add	a5,a5,a4
80006b2c:	5387a783          	lw	a5,1336(a5)
80006b30:	00f14703          	lbu	a4,15(sp)
80006b34:	4595                	li	a1,5
80006b36:	853a                	mv	a0,a4
80006b38:	9782                	jalr	a5

80006b3a <.L214>:
    }
}
80006b3a:	0001                	nop
80006b3c:	40f2                	lw	ra,28(sp)
80006b3e:	6105                	add	sp,sp,32
80006b40:	8082                	ret

Disassembly of section .text.usbd_event_reset_handler:

80006b42 <usbd_event_reset_handler>:

void usbd_event_reset_handler(uint8_t busid)
{
80006b42:	7179                	add	sp,sp,-48
80006b44:	d606                	sw	ra,44(sp)
80006b46:	87aa                	mv	a5,a0
80006b48:	00f107a3          	sb	a5,15(sp)
    usbd_set_address(busid, 0);
80006b4c:	00f14783          	lbu	a5,15(sp)
80006b50:	4581                	li	a1,0
80006b52:	853e                	mv	a0,a5
80006b54:	013000ef          	jal	80007366 <usbd_set_address>
    g_usbd_core[busid].device_address = 0;
80006b58:	00f14683          	lbu	a3,15(sp)
80006b5c:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006b60:	53c00793          	li	a5,1340
80006b64:	02f687b3          	mul	a5,a3,a5
80006b68:	97ba                	add	a5,a5,a4
80006b6a:	40078ea3          	sb	zero,1053(a5)
    g_usbd_core[busid].configuration = 0;
80006b6e:	00f14683          	lbu	a3,15(sp)
80006b72:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006b76:	53c00793          	li	a5,1340
80006b7a:	02f687b3          	mul	a5,a3,a5
80006b7e:	97ba                	add	a5,a5,a4
80006b80:	40078e23          	sb	zero,1052(a5)
#ifdef CONFIG_USBDEV_ADVANCE_DESC
    g_usbd_core[busid].speed = USB_SPEED_UNKNOWN;
80006b84:	00f14683          	lbu	a3,15(sp)
80006b88:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006b8c:	53c00793          	li	a5,1340
80006b90:	02f687b3          	mul	a5,a3,a5
80006b94:	97ba                	add	a5,a5,a4
80006b96:	42078123          	sb	zero,1058(a5)
#endif
    struct usb_endpoint_descriptor ep0;

    ep0.bLength = 7;
80006b9a:	479d                	li	a5,7
80006b9c:	00f10c23          	sb	a5,24(sp)
    ep0.bDescriptorType = USB_DESCRIPTOR_TYPE_ENDPOINT;
80006ba0:	4795                	li	a5,5
80006ba2:	00f10ca3          	sb	a5,25(sp)
    ep0.wMaxPacketSize = USB_CTRL_EP_MPS;
80006ba6:	04000793          	li	a5,64
80006baa:	00f11e23          	sh	a5,28(sp)
    ep0.bmAttributes = USB_ENDPOINT_TYPE_CONTROL;
80006bae:	00010da3          	sb	zero,27(sp)
    ep0.bEndpointAddress = USB_CONTROL_IN_EP0;
80006bb2:	f8000793          	li	a5,-128
80006bb6:	00f10d23          	sb	a5,26(sp)
    ep0.bInterval = 0;
80006bba:	00010f23          	sb	zero,30(sp)
    usbd_ep_open(busid, &ep0);
80006bbe:	0838                	add	a4,sp,24
80006bc0:	00f14783          	lbu	a5,15(sp)
80006bc4:	85ba                	mv	a1,a4
80006bc6:	853e                	mv	a0,a5
80006bc8:	352040ef          	jal	8000af1a <usbd_ep_open>

    ep0.bEndpointAddress = USB_CONTROL_OUT_EP0;
80006bcc:	00010d23          	sb	zero,26(sp)
    usbd_ep_open(busid, &ep0);
80006bd0:	0838                	add	a4,sp,24
80006bd2:	00f14783          	lbu	a5,15(sp)
80006bd6:	85ba                	mv	a1,a4
80006bd8:	853e                	mv	a0,a5
80006bda:	340040ef          	jal	8000af1a <usbd_ep_open>

    usbd_class_event_notify_handler(busid, USBD_EVENT_RESET, NULL);
80006bde:	00f14783          	lbu	a5,15(sp)
80006be2:	4601                	li	a2,0
80006be4:	4585                	li	a1,1
80006be6:	853e                	mv	a0,a5
80006be8:	441030ef          	jal	8000a828 <usbd_class_event_notify_handler>
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_RESET);
80006bec:	00f14683          	lbu	a3,15(sp)
80006bf0:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006bf4:	53c00793          	li	a5,1340
80006bf8:	02f687b3          	mul	a5,a3,a5
80006bfc:	97ba                	add	a5,a5,a4
80006bfe:	5387a783          	lw	a5,1336(a5)
80006c02:	00f14703          	lbu	a4,15(sp)
80006c06:	4585                	li	a1,1
80006c08:	853a                	mv	a0,a4
80006c0a:	9782                	jalr	a5
}
80006c0c:	0001                	nop
80006c0e:	50b2                	lw	ra,44(sp)
80006c10:	6145                	add	sp,sp,48
80006c12:	8082                	ret

Disassembly of section .text.usbd_event_ep0_setup_complete_handler:

80006c14 <usbd_event_ep0_setup_complete_handler>:

void usbd_event_ep0_setup_complete_handler(uint8_t busid, uint8_t *psetup)
{
80006c14:	7179                	add	sp,sp,-48
80006c16:	d606                	sw	ra,44(sp)
80006c18:	87aa                	mv	a5,a0
80006c1a:	c42e                	sw	a1,8(sp)
80006c1c:	00f107a3          	sb	a5,15(sp)
    struct usb_setup_packet *setup = &g_usbd_core[busid].setup;
80006c20:	00f14703          	lbu	a4,15(sp)
80006c24:	53c00793          	li	a5,1340
80006c28:	02f70733          	mul	a4,a4,a5
80006c2c:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
80006c30:	97ba                	add	a5,a5,a4
80006c32:	ce3e                	sw	a5,28(sp)
    uint8_t *buf;

    memcpy(setup, psetup, 8);
80006c34:	4621                	li	a2,8
80006c36:	45a2                	lw	a1,8(sp)
80006c38:	4572                	lw	a0,28(sp)
80006c3a:	73f010ef          	jal	80008b78 <memcpy>
#ifdef CONFIG_USBDEV_SETUP_LOG_PRINT
    usbd_print_setup(setup);
#endif
    if (setup->wLength > CONFIG_USBDEV_REQUEST_BUFFER_LEN) {
80006c3e:	47f2                	lw	a5,28(sp)
80006c40:	0067c703          	lbu	a4,6(a5)
80006c44:	0077c783          	lbu	a5,7(a5)
80006c48:	07a2                	sll	a5,a5,0x8
80006c4a:	8fd9                	or	a5,a5,a4
80006c4c:	01079713          	sll	a4,a5,0x10
80006c50:	8341                	srl	a4,a4,0x10
80006c52:	40000793          	li	a5,1024
80006c56:	02e7fc63          	bgeu	a5,a4,80006c8e <.L217>
        if ((setup->bmRequestType & USB_REQUEST_DIR_MASK) == USB_REQUEST_DIR_OUT) {
80006c5a:	47f2                	lw	a5,28(sp)
80006c5c:	0007c783          	lbu	a5,0(a5)
80006c60:	07e2                	sll	a5,a5,0x18
80006c62:	87e1                	sra	a5,a5,0x18
80006c64:	0207c563          	bltz	a5,80006c8e <.L217>
            USB_LOG_ERR("Request buffer too small\r\n");
80006c68:	800057b7          	lui	a5,0x80005
80006c6c:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
80006c70:	06c020ef          	jal	80008cdc <printf>
80006c74:	800057b7          	lui	a5,0x80005
80006c78:	0ec78513          	add	a0,a5,236 # 800050ec <.LC11>
80006c7c:	060020ef          	jal	80008cdc <printf>
            usbd_ep_set_stall(busid, USB_CONTROL_IN_EP0);
80006c80:	00f14783          	lbu	a5,15(sp)
80006c84:	08000593          	li	a1,128
80006c88:	853e                	mv	a0,a5
80006c8a:	2f39                	jal	800073a8 <usbd_ep_set_stall>
            return;
80006c8c:	a475                	j	80006f38 <.L216>

80006c8e <.L217>:
        }
    }

    g_usbd_core[busid].ep0_data_buf = g_usbd_core[busid].req_data;
80006c8e:	00f14703          	lbu	a4,15(sp)
80006c92:	00f14603          	lbu	a2,15(sp)
80006c96:	53c00793          	li	a5,1340
80006c9a:	02f707b3          	mul	a5,a4,a5
80006c9e:	01078713          	add	a4,a5,16
80006ca2:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
80006ca6:	97ba                	add	a5,a5,a4
80006ca8:	00c78713          	add	a4,a5,12
80006cac:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006cb0:	53c00793          	li	a5,1340
80006cb4:	02f607b3          	mul	a5,a2,a5
80006cb8:	97b6                	add	a5,a5,a3
80006cba:	c798                	sw	a4,8(a5)
    g_usbd_core[busid].ep0_data_buf_residue = setup->wLength;
80006cbc:	47f2                	lw	a5,28(sp)
80006cbe:	0067c703          	lbu	a4,6(a5)
80006cc2:	0077c783          	lbu	a5,7(a5)
80006cc6:	07a2                	sll	a5,a5,0x8
80006cc8:	8fd9                	or	a5,a5,a4
80006cca:	07c2                	sll	a5,a5,0x10
80006ccc:	83c1                	srl	a5,a5,0x10
80006cce:	00f14683          	lbu	a3,15(sp)
80006cd2:	863e                	mv	a2,a5
80006cd4:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006cd8:	53c00793          	li	a5,1340
80006cdc:	02f687b3          	mul	a5,a3,a5
80006ce0:	97ba                	add	a5,a5,a4
80006ce2:	c7d0                	sw	a2,12(a5)
    g_usbd_core[busid].ep0_data_buf_len = setup->wLength;
80006ce4:	47f2                	lw	a5,28(sp)
80006ce6:	0067c703          	lbu	a4,6(a5)
80006cea:	0077c783          	lbu	a5,7(a5)
80006cee:	07a2                	sll	a5,a5,0x8
80006cf0:	8fd9                	or	a5,a5,a4
80006cf2:	07c2                	sll	a5,a5,0x10
80006cf4:	83c1                	srl	a5,a5,0x10
80006cf6:	00f14683          	lbu	a3,15(sp)
80006cfa:	863e                	mv	a2,a5
80006cfc:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006d00:	53c00793          	li	a5,1340
80006d04:	02f687b3          	mul	a5,a3,a5
80006d08:	97ba                	add	a5,a5,a4
80006d0a:	cb90                	sw	a2,16(a5)
    g_usbd_core[busid].zlp_flag = false;
80006d0c:	00f14683          	lbu	a3,15(sp)
80006d10:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006d14:	53c00793          	li	a5,1340
80006d18:	02f687b3          	mul	a5,a3,a5
80006d1c:	97ba                	add	a5,a5,a4
80006d1e:	00078a23          	sb	zero,20(a5)
    buf = g_usbd_core[busid].ep0_data_buf;
80006d22:	00f14683          	lbu	a3,15(sp)
80006d26:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006d2a:	53c00793          	li	a5,1340
80006d2e:	02f687b3          	mul	a5,a3,a5
80006d32:	97ba                	add	a5,a5,a4
80006d34:	479c                	lw	a5,8(a5)
80006d36:	cc3e                	sw	a5,24(sp)

    /* handle class request when all the data is received */
    if (setup->wLength && ((setup->bmRequestType & USB_REQUEST_DIR_MASK) == USB_REQUEST_DIR_OUT)) {
80006d38:	47f2                	lw	a5,28(sp)
80006d3a:	0067c703          	lbu	a4,6(a5)
80006d3e:	0077c783          	lbu	a5,7(a5)
80006d42:	07a2                	sll	a5,a5,0x8
80006d44:	8fd9                	or	a5,a5,a4
80006d46:	07c2                	sll	a5,a5,0x10
80006d48:	83c1                	srl	a5,a5,0x10
80006d4a:	c7a1                	beqz	a5,80006d92 <.L219>
80006d4c:	47f2                	lw	a5,28(sp)
80006d4e:	0007c783          	lbu	a5,0(a5)
80006d52:	07e2                	sll	a5,a5,0x18
80006d54:	87e1                	sra	a5,a5,0x18
80006d56:	0207ce63          	bltz	a5,80006d92 <.L219>
        USB_LOG_DBG("Start reading %d bytes from ep0\r\n", setup->wLength);
        usbd_ep_start_read(busid, USB_CONTROL_OUT_EP0, g_usbd_core[busid].ep0_data_buf, setup->wLength);
80006d5a:	00f14683          	lbu	a3,15(sp)
80006d5e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006d62:	53c00793          	li	a5,1340
80006d66:	02f687b3          	mul	a5,a3,a5
80006d6a:	97ba                	add	a5,a5,a4
80006d6c:	4790                	lw	a2,8(a5)
80006d6e:	47f2                	lw	a5,28(sp)
80006d70:	0067c703          	lbu	a4,6(a5)
80006d74:	0077c783          	lbu	a5,7(a5)
80006d78:	07a2                	sll	a5,a5,0x8
80006d7a:	8fd9                	or	a5,a5,a4
80006d7c:	07c2                	sll	a5,a5,0x10
80006d7e:	83c1                	srl	a5,a5,0x10
80006d80:	873e                	mv	a4,a5
80006d82:	00f14783          	lbu	a5,15(sp)
80006d86:	86ba                	mv	a3,a4
80006d88:	4581                	li	a1,0
80006d8a:	853e                	mv	a0,a5
80006d8c:	4ce040ef          	jal	8000b25a <usbd_ep_start_read>
        return;
80006d90:	a265                	j	80006f38 <.L216>

80006d92 <.L219>:
    }

    /* Ask installed handler to process request */
    if (!usbd_setup_request_handler(busid, setup, &buf, &g_usbd_core[busid].ep0_data_buf_len)) {
80006d92:	00f14703          	lbu	a4,15(sp)
80006d96:	53c00793          	li	a5,1340
80006d9a:	02f707b3          	mul	a5,a4,a5
80006d9e:	01078713          	add	a4,a5,16
80006da2:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
80006da6:	00f706b3          	add	a3,a4,a5
80006daa:	0838                	add	a4,sp,24
80006dac:	00f14783          	lbu	a5,15(sp)
80006db0:	863a                	mv	a2,a4
80006db2:	45f2                	lw	a1,28(sp)
80006db4:	853e                	mv	a0,a5
80006db6:	3665                	jal	8000695e <usbd_setup_request_handler>
80006db8:	87aa                	mv	a5,a0
80006dba:	0017c793          	xor	a5,a5,1
80006dbe:	0ff7f793          	zext.b	a5,a5
80006dc2:	cb81                	beqz	a5,80006dd2 <.L220>
        usbd_ep_set_stall(busid, USB_CONTROL_IN_EP0);
80006dc4:	00f14783          	lbu	a5,15(sp)
80006dc8:	08000593          	li	a1,128
80006dcc:	853e                	mv	a0,a5
80006dce:	2be9                	jal	800073a8 <usbd_ep_set_stall>
        return;
80006dd0:	a2a5                	j	80006f38 <.L216>

80006dd2 <.L220>:
    }

    /* Send smallest of requested and offered length */
    g_usbd_core[busid].ep0_data_buf_residue = MIN(g_usbd_core[busid].ep0_data_buf_len, setup->wLength);
80006dd2:	47f2                	lw	a5,28(sp)
80006dd4:	0067c703          	lbu	a4,6(a5)
80006dd8:	0077c783          	lbu	a5,7(a5)
80006ddc:	07a2                	sll	a5,a5,0x8
80006dde:	8fd9                	or	a5,a5,a4
80006de0:	07c2                	sll	a5,a5,0x10
80006de2:	83c1                	srl	a5,a5,0x10
80006de4:	85be                	mv	a1,a5
80006de6:	00f14683          	lbu	a3,15(sp)
80006dea:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006dee:	53c00793          	li	a5,1340
80006df2:	02f687b3          	mul	a5,a3,a5
80006df6:	97ba                	add	a5,a5,a4
80006df8:	4b9c                	lw	a5,16(a5)
80006dfa:	00f14603          	lbu	a2,15(sp)
80006dfe:	872e                	mv	a4,a1
80006e00:	00e7f363          	bgeu	a5,a4,80006e06 <.L221>
80006e04:	873e                	mv	a4,a5

80006e06 <.L221>:
80006e06:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006e0a:	53c00793          	li	a5,1340
80006e0e:	02f607b3          	mul	a5,a2,a5
80006e12:	97b6                	add	a5,a5,a3
80006e14:	c7d8                	sw	a4,12(a5)
    if (g_usbd_core[busid].ep0_data_buf_residue > CONFIG_USBDEV_REQUEST_BUFFER_LEN) {
80006e16:	00f14683          	lbu	a3,15(sp)
80006e1a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006e1e:	53c00793          	li	a5,1340
80006e22:	02f687b3          	mul	a5,a3,a5
80006e26:	97ba                	add	a5,a5,a4
80006e28:	47d8                	lw	a4,12(a5)
80006e2a:	40000793          	li	a5,1024
80006e2e:	02e7f563          	bgeu	a5,a4,80006e58 <.L222>
        USB_LOG_ERR("Request buffer too small\r\n");
80006e32:	800057b7          	lui	a5,0x80005
80006e36:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
80006e3a:	6a3010ef          	jal	80008cdc <printf>
80006e3e:	800057b7          	lui	a5,0x80005
80006e42:	0ec78513          	add	a0,a5,236 # 800050ec <.LC11>
80006e46:	697010ef          	jal	80008cdc <printf>
        usbd_ep_set_stall(busid, USB_CONTROL_IN_EP0);
80006e4a:	00f14783          	lbu	a5,15(sp)
80006e4e:	08000593          	li	a1,128
80006e52:	853e                	mv	a0,a5
80006e54:	2b91                	jal	800073a8 <usbd_ep_set_stall>
        return;
80006e56:	a0cd                	j	80006f38 <.L216>

80006e58 <.L222>:
    }

    /* use *data = xxx; g_usbd_core[busid].ep0_data_buf records real data address, we should copy data into ep0 buffer.
     * Why we should copy once? because some chips are not access to flash with dma if real data address is in flash address(such as ch32).
     */
    if (buf != g_usbd_core[busid].ep0_data_buf) {
80006e58:	00f14683          	lbu	a3,15(sp)
80006e5c:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006e60:	53c00793          	li	a5,1340
80006e64:	02f687b3          	mul	a5,a3,a5
80006e68:	97ba                	add	a5,a5,a4
80006e6a:	4798                	lw	a4,8(a5)
80006e6c:	47e2                	lw	a5,24(sp)
80006e6e:	02f70a63          	beq	a4,a5,80006ea2 <.L223>
#ifdef CONFIG_USBDEV_EP0_INDATA_NO_COPY
        g_usbd_core[busid].ep0_data_buf = buf;
#else
        usb_memcpy(g_usbd_core[busid].ep0_data_buf, buf, g_usbd_core[busid].ep0_data_buf_residue);
80006e72:	00f14683          	lbu	a3,15(sp)
80006e76:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006e7a:	53c00793          	li	a5,1340
80006e7e:	02f687b3          	mul	a5,a3,a5
80006e82:	97ba                	add	a5,a5,a4
80006e84:	4788                	lw	a0,8(a5)
80006e86:	45e2                	lw	a1,24(sp)
80006e88:	00f14683          	lbu	a3,15(sp)
80006e8c:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006e90:	53c00793          	li	a5,1340
80006e94:	02f687b3          	mul	a5,a3,a5
80006e98:	97ba                	add	a5,a5,a4
80006e9a:	47dc                	lw	a5,12(a5)
80006e9c:	863e                	mv	a2,a5
80006e9e:	282030ef          	jal	8000a120 <usb_memcpy>

80006ea2 <.L223>:
    } else {
        /* use memcpy(*data, xxx, len); has copied into ep0 buffer, we do nothing */
    }

    /* Send data or status to host */
    usbd_ep_start_write(busid, USB_CONTROL_IN_EP0, g_usbd_core[busid].ep0_data_buf, g_usbd_core[busid].ep0_data_buf_residue);
80006ea2:	00f14683          	lbu	a3,15(sp)
80006ea6:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006eaa:	53c00793          	li	a5,1340
80006eae:	02f687b3          	mul	a5,a3,a5
80006eb2:	97ba                	add	a5,a5,a4
80006eb4:	4790                	lw	a2,8(a5)
80006eb6:	00f14683          	lbu	a3,15(sp)
80006eba:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006ebe:	53c00793          	li	a5,1340
80006ec2:	02f687b3          	mul	a5,a3,a5
80006ec6:	97ba                	add	a5,a5,a4
80006ec8:	47d8                	lw	a4,12(a5)
80006eca:	00f14783          	lbu	a5,15(sp)
80006ece:	86ba                	mv	a3,a4
80006ed0:	08000593          	li	a1,128
80006ed4:	853e                	mv	a0,a5
80006ed6:	290040ef          	jal	8000b166 <usbd_ep_start_write>
    /*
    * Set ZLP flag when host asks for a bigger length and the data size is
    * multiplier of USB_CTRL_EP_MPS, to indicate the transfer done after zlp
    * sent.
    */
    if ((setup->wLength > g_usbd_core[busid].ep0_data_buf_len) && (!(g_usbd_core[busid].ep0_data_buf_len % USB_CTRL_EP_MPS))) {
80006eda:	47f2                	lw	a5,28(sp)
80006edc:	0067c703          	lbu	a4,6(a5)
80006ee0:	0077c783          	lbu	a5,7(a5)
80006ee4:	07a2                	sll	a5,a5,0x8
80006ee6:	8fd9                	or	a5,a5,a4
80006ee8:	07c2                	sll	a5,a5,0x10
80006eea:	83c1                	srl	a5,a5,0x10
80006eec:	863e                	mv	a2,a5
80006eee:	00f14683          	lbu	a3,15(sp)
80006ef2:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006ef6:	53c00793          	li	a5,1340
80006efa:	02f687b3          	mul	a5,a3,a5
80006efe:	97ba                	add	a5,a5,a4
80006f00:	4b9c                	lw	a5,16(a5)
80006f02:	02c7fb63          	bgeu	a5,a2,80006f38 <.L216>
80006f06:	00f14683          	lbu	a3,15(sp)
80006f0a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006f0e:	53c00793          	li	a5,1340
80006f12:	02f687b3          	mul	a5,a3,a5
80006f16:	97ba                	add	a5,a5,a4
80006f18:	4b9c                	lw	a5,16(a5)
80006f1a:	03f7f793          	and	a5,a5,63
80006f1e:	ef89                	bnez	a5,80006f38 <.L216>
        g_usbd_core[busid].zlp_flag = true;
80006f20:	00f14683          	lbu	a3,15(sp)
80006f24:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80006f28:	53c00793          	li	a5,1340
80006f2c:	02f687b3          	mul	a5,a3,a5
80006f30:	97ba                	add	a5,a5,a4
80006f32:	4705                	li	a4,1
80006f34:	00e78a23          	sb	a4,20(a5)

80006f38 <.L216>:
        USB_LOG_DBG("EP0 Set zlp\r\n");
    }
}
80006f38:	50b2                	lw	ra,44(sp)
80006f3a:	6145                	add	sp,sp,48
80006f3c:	8082                	ret

Disassembly of section .text.usbd_event_ep_in_complete_handler:

80006f3e <usbd_event_ep_in_complete_handler>:
        USB_LOG_DBG("EP0 recv out status\r\n");
    }
}

void usbd_event_ep_in_complete_handler(uint8_t busid, uint8_t ep, uint32_t nbytes)
{
80006f3e:	1101                	add	sp,sp,-32
80006f40:	ce06                	sw	ra,28(sp)
80006f42:	87aa                	mv	a5,a0
80006f44:	872e                	mv	a4,a1
80006f46:	c432                	sw	a2,8(sp)
80006f48:	00f107a3          	sb	a5,15(sp)
80006f4c:	87ba                	mv	a5,a4
80006f4e:	00f10723          	sb	a5,14(sp)
    if (g_usbd_core[busid].tx_msg[ep & 0x7f].cb) {
80006f52:	00f14603          	lbu	a2,15(sp)
80006f56:	00e14783          	lbu	a5,14(sp)
80006f5a:	07f7f713          	and	a4,a5,127
80006f5e:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006f62:	87ba                	mv	a5,a4
80006f64:	0786                	sll	a5,a5,0x1
80006f66:	97ba                	add	a5,a5,a4
80006f68:	078a                	sll	a5,a5,0x2
80006f6a:	53c00713          	li	a4,1340
80006f6e:	02e60733          	mul	a4,a2,a4
80006f72:	97ba                	add	a5,a5,a4
80006f74:	97b6                	add	a5,a5,a3
80006f76:	4807a783          	lw	a5,1152(a5)
80006f7a:	cf8d                	beqz	a5,80006fb4 <.L237>
        g_usbd_core[busid].tx_msg[ep & 0x7f].cb(busid, ep, nbytes);
80006f7c:	00f14603          	lbu	a2,15(sp)
80006f80:	00e14783          	lbu	a5,14(sp)
80006f84:	07f7f713          	and	a4,a5,127
80006f88:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006f8c:	87ba                	mv	a5,a4
80006f8e:	0786                	sll	a5,a5,0x1
80006f90:	97ba                	add	a5,a5,a4
80006f92:	078a                	sll	a5,a5,0x2
80006f94:	53c00713          	li	a4,1340
80006f98:	02e60733          	mul	a4,a2,a4
80006f9c:	97ba                	add	a5,a5,a4
80006f9e:	97b6                	add	a5,a5,a3
80006fa0:	4807a783          	lw	a5,1152(a5)
80006fa4:	00e14683          	lbu	a3,14(sp)
80006fa8:	00f14703          	lbu	a4,15(sp)
80006fac:	4622                	lw	a2,8(sp)
80006fae:	85b6                	mv	a1,a3
80006fb0:	853a                	mv	a0,a4
80006fb2:	9782                	jalr	a5

80006fb4 <.L237>:
    }
}
80006fb4:	0001                	nop
80006fb6:	40f2                	lw	ra,28(sp)
80006fb8:	6105                	add	sp,sp,32
80006fba:	8082                	ret

Disassembly of section .text.usbd_event_ep_out_complete_handler:

80006fbc <usbd_event_ep_out_complete_handler>:

void usbd_event_ep_out_complete_handler(uint8_t busid, uint8_t ep, uint32_t nbytes)
{
80006fbc:	1101                	add	sp,sp,-32
80006fbe:	ce06                	sw	ra,28(sp)
80006fc0:	87aa                	mv	a5,a0
80006fc2:	872e                	mv	a4,a1
80006fc4:	c432                	sw	a2,8(sp)
80006fc6:	00f107a3          	sb	a5,15(sp)
80006fca:	87ba                	mv	a5,a4
80006fcc:	00f10723          	sb	a5,14(sp)
    if (g_usbd_core[busid].rx_msg[ep & 0x7f].cb) {
80006fd0:	00f14603          	lbu	a2,15(sp)
80006fd4:	00e14783          	lbu	a5,14(sp)
80006fd8:	07f7f713          	and	a4,a5,127
80006fdc:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
80006fe0:	87ba                	mv	a5,a4
80006fe2:	0786                	sll	a5,a5,0x1
80006fe4:	97ba                	add	a5,a5,a4
80006fe6:	078a                	sll	a5,a5,0x2
80006fe8:	53c00713          	li	a4,1340
80006fec:	02e60733          	mul	a4,a2,a4
80006ff0:	97ba                	add	a5,a5,a4
80006ff2:	97b6                	add	a5,a5,a3
80006ff4:	4e07a783          	lw	a5,1248(a5)
80006ff8:	cf8d                	beqz	a5,80007032 <.L240>
        g_usbd_core[busid].rx_msg[ep & 0x7f].cb(busid, ep, nbytes);
80006ffa:	00f14603          	lbu	a2,15(sp)
80006ffe:	00e14783          	lbu	a5,14(sp)
80007002:	07f7f713          	and	a4,a5,127
80007006:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000700a:	87ba                	mv	a5,a4
8000700c:	0786                	sll	a5,a5,0x1
8000700e:	97ba                	add	a5,a5,a4
80007010:	078a                	sll	a5,a5,0x2
80007012:	53c00713          	li	a4,1340
80007016:	02e60733          	mul	a4,a2,a4
8000701a:	97ba                	add	a5,a5,a4
8000701c:	97b6                	add	a5,a5,a3
8000701e:	4e07a783          	lw	a5,1248(a5)
80007022:	00e14683          	lbu	a3,14(sp)
80007026:	00f14703          	lbu	a4,15(sp)
8000702a:	4622                	lw	a2,8(sp)
8000702c:	85b6                	mv	a1,a3
8000702e:	853a                	mv	a0,a4
80007030:	9782                	jalr	a5

80007032 <.L240>:
    }
}
80007032:	0001                	nop
80007034:	40f2                	lw	ra,28(sp)
80007036:	6105                	add	sp,sp,32
80007038:	8082                	ret

Disassembly of section .text.usbd_desc_register:

8000703a <usbd_desc_register>:

#ifdef CONFIG_USBDEV_ADVANCE_DESC
void usbd_desc_register(uint8_t busid, const struct usb_descriptor *desc)
{
8000703a:	1101                	add	sp,sp,-32
8000703c:	ce06                	sw	ra,28(sp)
8000703e:	87aa                	mv	a5,a0
80007040:	c42e                	sw	a1,8(sp)
80007042:	00f107a3          	sb	a5,15(sp)
    memset(&g_usbd_core[busid], 0, sizeof(struct usbd_core_priv));
80007046:	00f14703          	lbu	a4,15(sp)
8000704a:	53c00793          	li	a5,1340
8000704e:	02f70733          	mul	a4,a4,a5
80007052:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
80007056:	97ba                	add	a5,a5,a4
80007058:	53c00613          	li	a2,1340
8000705c:	4581                	li	a1,0
8000705e:	853e                	mv	a0,a5
80007060:	6b2050ef          	jal	8000c712 <memset>

    g_usbd_core[busid].descriptors = desc;
80007064:	00f14683          	lbu	a3,15(sp)
80007068:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000706c:	53c00793          	li	a5,1340
80007070:	02f687b3          	mul	a5,a3,a5
80007074:	97ba                	add	a5,a5,a4
80007076:	4722                	lw	a4,8(sp)
80007078:	cf98                	sw	a4,24(a5)
    g_usbd_core[busid].intf_offset = 0;
8000707a:	00f14683          	lbu	a3,15(sp)
8000707e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80007082:	53c00793          	li	a5,1340
80007086:	02f687b3          	mul	a5,a3,a5
8000708a:	97ba                	add	a5,a5,a4
8000708c:	46078a23          	sb	zero,1140(a5)

    g_usbd_core[busid].tx_msg[0].ep = 0x80;
80007090:	00f14683          	lbu	a3,15(sp)
80007094:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80007098:	53c00793          	li	a5,1340
8000709c:	02f687b3          	mul	a5,a3,a5
800070a0:	97ba                	add	a5,a5,a4
800070a2:	f8000713          	li	a4,-128
800070a6:	46e78c23          	sb	a4,1144(a5)
    g_usbd_core[busid].tx_msg[0].cb = usbd_event_ep0_in_complete_handler;
800070aa:	00f14683          	lbu	a3,15(sp)
800070ae:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800070b2:	53c00793          	li	a5,1340
800070b6:	02f687b3          	mul	a5,a3,a5
800070ba:	97ba                	add	a5,a5,a4
800070bc:	8000b737          	lui	a4,0x8000b
800070c0:	93470713          	add	a4,a4,-1740 # 8000a934 <usbd_event_ep0_in_complete_handler>
800070c4:	48e7a023          	sw	a4,1152(a5)
    g_usbd_core[busid].rx_msg[0].ep = 0x00;
800070c8:	00f14683          	lbu	a3,15(sp)
800070cc:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800070d0:	53c00793          	li	a5,1340
800070d4:	02f687b3          	mul	a5,a3,a5
800070d8:	97ba                	add	a5,a5,a4
800070da:	4c078c23          	sb	zero,1240(a5)
    g_usbd_core[busid].rx_msg[0].cb = usbd_event_ep0_out_complete_handler;
800070de:	00f14683          	lbu	a3,15(sp)
800070e2:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
800070e6:	53c00793          	li	a5,1340
800070ea:	02f687b3          	mul	a5,a3,a5
800070ee:	97ba                	add	a5,a5,a4
800070f0:	8000b737          	lui	a4,0x8000b
800070f4:	a7a70713          	add	a4,a4,-1414 # 8000aa7a <usbd_event_ep0_out_complete_handler>
800070f8:	4ee7a023          	sw	a4,1248(a5)
}
800070fc:	0001                	nop
800070fe:	40f2                	lw	ra,28(sp)
80007100:	6105                	add	sp,sp,32
80007102:	8082                	ret

Disassembly of section .text.usbd_deinitialize:

80007104 <usbd_deinitialize>:
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_INIT);
    return ret;
}

int usbd_deinitialize(uint8_t busid)
{
80007104:	1101                	add	sp,sp,-32
80007106:	ce06                	sw	ra,28(sp)
80007108:	87aa                	mv	a5,a0
8000710a:	00f107a3          	sb	a5,15(sp)
    if (busid >= CONFIG_USBDEV_MAX_BUS) {
8000710e:	00f14703          	lbu	a4,15(sp)
80007112:	4785                	li	a5,1
80007114:	00e7ff63          	bgeu	a5,a4,80007132 <.L268>
        USB_LOG_ERR("bus overflow\r\n");
80007118:	800057b7          	lui	a5,0x80005
8000711c:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
80007120:	3bd010ef          	jal	80008cdc <printf>
80007124:	800057b7          	lui	a5,0x80005
80007128:	17c78513          	add	a0,a5,380 # 8000517c <.LC15>
8000712c:	3b1010ef          	jal	80008cdc <printf>

80007130 <.L269>:
        while (1) {
80007130:	a001                	j	80007130 <.L269>

80007132 <.L268>:
        }
    }

    g_usbd_core[busid].event_handler(busid, USBD_EVENT_DEINIT);
80007132:	00f14683          	lbu	a3,15(sp)
80007136:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000713a:	53c00793          	li	a5,1340
8000713e:	02f687b3          	mul	a5,a3,a5
80007142:	97ba                	add	a5,a5,a4
80007144:	5387a783          	lw	a5,1336(a5)
80007148:	00f14703          	lbu	a4,15(sp)
8000714c:	45b1                	li	a1,12
8000714e:	853a                	mv	a0,a4
80007150:	9782                	jalr	a5
    usbd_class_event_notify_handler(busid, USBD_EVENT_DEINIT, NULL);
80007152:	00f14783          	lbu	a5,15(sp)
80007156:	4601                	li	a2,0
80007158:	45b1                	li	a1,12
8000715a:	853e                	mv	a0,a5
8000715c:	6cc030ef          	jal	8000a828 <usbd_class_event_notify_handler>
    usb_dc_deinit(busid);
80007160:	00f14783          	lbu	a5,15(sp)
80007164:	853e                	mv	a0,a5
80007166:	4cf030ef          	jal	8000ae34 <usb_dc_deinit>
    g_usbd_core[busid].intf_offset = 0;
8000716a:	00f14683          	lbu	a3,15(sp)
8000716e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
80007172:	53c00793          	li	a5,1340
80007176:	02f687b3          	mul	a5,a3,a5
8000717a:	97ba                	add	a5,a5,a4
8000717c:	46078a23          	sb	zero,1140(a5)
    return 0;
80007180:	4781                	li	a5,0
}
80007182:	853e                	mv	a0,a5
80007184:	40f2                	lw	ra,28(sp)
80007186:	6105                	add	sp,sp,32
80007188:	8082                	ret

Disassembly of section .text.ep_idx2bit:

8000718a <ep_idx2bit>:
static uint32_t _dcd_irqnum[CONFIG_USBDEV_MAX_BUS];
static uint8_t _dcd_busid[CONFIG_USBDEV_MAX_BUS];

/* Index to bit position in register */
static inline uint8_t ep_idx2bit(uint8_t ep_idx)
{
8000718a:	1141                	add	sp,sp,-16
8000718c:	87aa                	mv	a5,a0
8000718e:	00f107a3          	sb	a5,15(sp)
    return ep_idx / 2 + ((ep_idx % 2) ? 16 : 0);
80007192:	00f14783          	lbu	a5,15(sp)
80007196:	8385                	srl	a5,a5,0x1
80007198:	0ff7f713          	zext.b	a4,a5
8000719c:	00f14783          	lbu	a5,15(sp)
800071a0:	0792                	sll	a5,a5,0x4
800071a2:	0ff7f793          	zext.b	a5,a5
800071a6:	8bc1                	and	a5,a5,16
800071a8:	0ff7f793          	zext.b	a5,a5
800071ac:	97ba                	add	a5,a5,a4
800071ae:	0ff7f793          	zext.b	a5,a5
}
800071b2:	853e                	mv	a0,a5
800071b4:	0141                	add	sp,sp,16
800071b6:	8082                	ret

Disassembly of section .text.usb_dc_init:

800071b8 <usb_dc_init>:
{
    usb_set_port_test_mode(g_hpm_udc[busid].handle->regs, test_mode);
}

int usb_dc_init(uint8_t busid)
{
800071b8:	7139                	add	sp,sp,-64
800071ba:	de06                	sw	ra,60(sp)
800071bc:	87aa                	mv	a5,a0
800071be:	00f107a3          	sb	a5,15(sp)
    memset(&g_hpm_udc[busid], 0, sizeof(struct hpm_udc));
800071c2:	00f14703          	lbu	a4,15(sp)
800071c6:	14800793          	li	a5,328
800071ca:	02f70733          	mul	a4,a4,a5
800071ce:	80020793          	add	a5,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
800071d2:	97ba                	add	a5,a5,a4
800071d4:	14800613          	li	a2,328
800071d8:	4581                	li	a1,0
800071da:	853e                	mv	a0,a5
800071dc:	536050ef          	jal	8000c712 <memset>
    g_hpm_udc[busid].handle = &usb_device_handle[busid];
800071e0:	00f14783          	lbu	a5,15(sp)
800071e4:	00f14603          	lbu	a2,15(sp)
800071e8:	00379713          	sll	a4,a5,0x3
800071ec:	011037b7          	lui	a5,0x1103
800071f0:	c0078793          	add	a5,a5,-1024 # 1102c00 <usb_device_handle>
800071f4:	973e                	add	a4,a4,a5
800071f6:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
800071fa:	14800793          	li	a5,328
800071fe:	02f607b3          	mul	a5,a2,a5
80007202:	97b6                	add	a5,a5,a3
80007204:	c398                	sw	a4,0(a5)
    g_hpm_udc[busid].handle->regs = (USB_Type *)g_usbdev_bus[busid].reg_base;
80007206:	00f14783          	lbu	a5,15(sp)
8000720a:	bc420713          	add	a4,tp,-1084 # fffffbc4 <__APB_SRAM_segment_end__+0xbf0dbc4>
8000720e:	078e                	sll	a5,a5,0x3
80007210:	97ba                	add	a5,a5,a4
80007212:	43d0                	lw	a2,4(a5)
80007214:	00f14683          	lbu	a3,15(sp)
80007218:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000721c:	14800793          	li	a5,328
80007220:	02f687b3          	mul	a5,a3,a5
80007224:	97ba                	add	a5,a5,a4
80007226:	439c                	lw	a5,0(a5)
80007228:	8732                	mv	a4,a2
8000722a:	c398                	sw	a4,0(a5)

    if (g_usbdev_bus[busid].reg_base == HPM_USB0_BASE) {
8000722c:	00f14783          	lbu	a5,15(sp)
80007230:	bc420713          	add	a4,tp,-1084 # fffffbc4 <__APB_SRAM_segment_end__+0xbf0dbc4>
80007234:	078e                	sll	a5,a5,0x3
80007236:	97ba                	add	a5,a5,a4
80007238:	43d8                	lw	a4,4(a5)
8000723a:	f20207b7          	lui	a5,0xf2020
8000723e:	02f71063          	bne	a4,a5,8000725e <.L13>
        _dcd_irqnum[busid] = IRQn_USB0;
80007242:	00f14783          	lbu	a5,15(sp)
80007246:	bd420713          	add	a4,tp,-1068 # fffffbd4 <__APB_SRAM_segment_end__+0xbf0dbd4>
8000724a:	078a                	sll	a5,a5,0x2
8000724c:	97ba                	add	a5,a5,a4
8000724e:	06a00713          	li	a4,106
80007252:	c398                	sw	a4,0(a5)
        _dcd_busid[0] = busid;
80007254:	00f14703          	lbu	a4,15(sp)
80007258:	c0e20223          	sb	a4,-1020(tp) # fffffc04 <__APB_SRAM_segment_end__+0xbf0dc04>
8000725c:	a81d                	j	80007292 <.L14>

8000725e <.L13>:
    } else {
#ifdef HPM_USB1_BASE
        if (g_usbdev_bus[busid].reg_base == HPM_USB1_BASE) {
8000725e:	00f14783          	lbu	a5,15(sp)
80007262:	bc420713          	add	a4,tp,-1084 # fffffbc4 <__APB_SRAM_segment_end__+0xbf0dbc4>
80007266:	078e                	sll	a5,a5,0x3
80007268:	97ba                	add	a5,a5,a4
8000726a:	43d8                	lw	a4,4(a5)
8000726c:	f20247b7          	lui	a5,0xf2024
80007270:	02f71163          	bne	a4,a5,80007292 <.L14>
            _dcd_irqnum[busid] = IRQn_USB1;
80007274:	00f14783          	lbu	a5,15(sp)
80007278:	bd420713          	add	a4,tp,-1068 # fffffbd4 <__APB_SRAM_segment_end__+0xbf0dbd4>
8000727c:	078a                	sll	a5,a5,0x2
8000727e:	97ba                	add	a5,a5,a4
80007280:	06b00713          	li	a4,107
80007284:	c398                	sw	a4,0(a5)
            _dcd_busid[1] = busid;
80007286:	c0420793          	add	a5,tp,-1020 # fffffc04 <__APB_SRAM_segment_end__+0xbf0dc04>
8000728a:	00f14703          	lbu	a4,15(sp)
8000728e:	00e780a3          	sb	a4,1(a5) # f2024001 <__AHB_SRAM_segment_end__+0x1d1c001>

80007292 <.L14>:
        }
#endif
    }

    if (busid == 0) {
80007292:	00f14783          	lbu	a5,15(sp)
80007296:	e38d                	bnez	a5,800072b8 <.L15>
        g_hpm_udc[busid].handle->dcd_data = &_dcd_data0;
80007298:	00f14683          	lbu	a3,15(sp)
8000729c:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
800072a0:	14800793          	li	a5,328
800072a4:	02f687b3          	mul	a5,a3,a5
800072a8:	97ba                	add	a5,a5,a4
800072aa:	439c                	lw	a5,0(a5)
800072ac:	01100737          	lui	a4,0x1100
800072b0:	00070713          	mv	a4,a4
800072b4:	c3d8                	sw	a4,4(a5)
800072b6:	a02d                	j	800072e0 <.L16>

800072b8 <.L15>:
    } else if (busid == 1) {
800072b8:	00f14703          	lbu	a4,15(sp)
800072bc:	4785                	li	a5,1
800072be:	02f71163          	bne	a4,a5,800072e0 <.L16>
#ifdef HPM_USB1_BASE
        g_hpm_udc[busid].handle->dcd_data = &_dcd_data1;
800072c2:	00f14683          	lbu	a3,15(sp)
800072c6:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
800072ca:	14800793          	li	a5,328
800072ce:	02f687b3          	mul	a5,a3,a5
800072d2:	97ba                	add	a5,a5,a4
800072d4:	439c                	lw	a5,0(a5)
800072d6:	01102737          	lui	a4,0x1102
800072da:	80070713          	add	a4,a4,-2048 # 1101800 <_dcd_data1>
800072de:	c3d8                	sw	a4,4(a5)

800072e0 <.L16>:
    } else {
        ;
    }

    uint32_t int_mask;
    int_mask = (USB_USBINTR_UE_MASK | USB_USBINTR_UEE_MASK | USB_USBINTR_SLE_MASK |
800072e0:	14700793          	li	a5,327
800072e4:	d63e                	sw	a5,44(sp)
                USB_USBINTR_PCE_MASK | USB_USBINTR_URE_MASK);

    usb_device_init(g_hpm_udc[busid].handle, int_mask);
800072e6:	00f14683          	lbu	a3,15(sp)
800072ea:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
800072ee:	14800793          	li	a5,328
800072f2:	02f687b3          	mul	a5,a3,a5
800072f6:	97ba                	add	a5,a5,a4
800072f8:	439c                	lw	a5,0(a5)
800072fa:	55b2                	lw	a1,44(sp)
800072fc:	853e                	mv	a0,a5
800072fe:	4a3010ef          	jal	80008fa0 <usb_device_init>

    intc_m_enable_irq(_dcd_irqnum[busid]);
80007302:	00f14783          	lbu	a5,15(sp)
80007306:	bd420713          	add	a4,tp,-1068 # fffffbd4 <__APB_SRAM_segment_end__+0xbf0dbd4>
8000730a:	078a                	sll	a5,a5,0x2
8000730c:	97ba                	add	a5,a5,a4
8000730e:	439c                	lw	a5,0(a5)
80007310:	d402                	sw	zero,40(sp)
80007312:	d23e                	sw	a5,36(sp)
80007314:	e40007b7          	lui	a5,0xe4000
80007318:	d03e                	sw	a5,32(sp)
8000731a:	57a2                	lw	a5,40(sp)
8000731c:	ce3e                	sw	a5,28(sp)
8000731e:	5792                	lw	a5,36(sp)
80007320:	cc3e                	sw	a5,24(sp)

80007322 <.LBB14>:
                                                        uint32_t target,
                                                        uint32_t irq)
{
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_ENABLE_OFFSET +
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80007322:	47f2                	lw	a5,28(sp)
80007324:	00779713          	sll	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
80007328:	5782                	lw	a5,32(sp)
8000732a:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
8000732c:	47e2                	lw	a5,24(sp)
8000732e:	8395                	srl	a5,a5,0x5
80007330:	078a                	sll	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80007332:	973e                	add	a4,a4,a5
80007334:	6789                	lui	a5,0x2
80007336:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
80007338:	ca3e                	sw	a5,20(sp)
    uint32_t current = *current_ptr;
8000733a:	47d2                	lw	a5,20(sp)
8000733c:	439c                	lw	a5,0(a5)
8000733e:	c83e                	sw	a5,16(sp)
    current = current | (1 << (irq & 0x1F));
80007340:	47e2                	lw	a5,24(sp)
80007342:	8bfd                	and	a5,a5,31
80007344:	4705                	li	a4,1
80007346:	00f717b3          	sll	a5,a4,a5
8000734a:	873e                	mv	a4,a5
8000734c:	47c2                	lw	a5,16(sp)
8000734e:	8fd9                	or	a5,a5,a4
80007350:	c83e                	sw	a5,16(sp)
    *current_ptr = current;
80007352:	47d2                	lw	a5,20(sp)
80007354:	4742                	lw	a4,16(sp)
80007356:	c398                	sw	a4,0(a5)
}
80007358:	0001                	nop

8000735a <.LBE16>:
 * @param[in] irq Interrupt number
 */
ATTR_ALWAYS_INLINE static inline void intc_enable_irq(uint32_t target, uint32_t irq)
{
    __plic_enable_irq(HPM_PLIC_BASE, target, irq);
}
8000735a:	0001                	nop

8000735c <.LBE14>:
    return 0;
8000735c:	4781                	li	a5,0
}
8000735e:	853e                	mv	a0,a5
80007360:	50f2                	lw	ra,60(sp)
80007362:	6121                	add	sp,sp,64
80007364:	8082                	ret

Disassembly of section .text.usbd_set_address:

80007366 <usbd_set_address>:

    return 0;
}

int usbd_set_address(uint8_t busid, const uint8_t addr)
{
80007366:	7179                	add	sp,sp,-48
80007368:	d606                	sw	ra,44(sp)
8000736a:	87aa                	mv	a5,a0
8000736c:	872e                	mv	a4,a1
8000736e:	00f107a3          	sb	a5,15(sp)
80007372:	87ba                	mv	a5,a4
80007374:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
80007378:	00f14683          	lbu	a3,15(sp)
8000737c:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
80007380:	14800793          	li	a5,328
80007384:	02f687b3          	mul	a5,a3,a5
80007388:	97ba                	add	a5,a5,a4
8000738a:	439c                	lw	a5,0(a5)
8000738c:	ce3e                	sw	a5,28(sp)
    usb_dcd_set_address(handle->regs, addr);
8000738e:	47f2                	lw	a5,28(sp)
80007390:	439c                	lw	a5,0(a5)
80007392:	00e14703          	lbu	a4,14(sp)
80007396:	85ba                	mv	a1,a4
80007398:	853e                	mv	a0,a5
8000739a:	277030ef          	jal	8000ae10 <usb_dcd_set_address>
    return 0;
8000739e:	4781                	li	a5,0
}
800073a0:	853e                	mv	a0,a5
800073a2:	50b2                	lw	ra,44(sp)
800073a4:	6145                	add	sp,sp,48
800073a6:	8082                	ret

Disassembly of section .text.usbd_ep_set_stall:

800073a8 <usbd_ep_set_stall>:

    return 0;
}

int usbd_ep_set_stall(uint8_t busid, const uint8_t ep)
{
800073a8:	7179                	add	sp,sp,-48
800073aa:	d606                	sw	ra,44(sp)
800073ac:	87aa                	mv	a5,a0
800073ae:	872e                	mv	a4,a1
800073b0:	00f107a3          	sb	a5,15(sp)
800073b4:	87ba                	mv	a5,a4
800073b6:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
800073ba:	00f14683          	lbu	a3,15(sp)
800073be:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
800073c2:	14800793          	li	a5,328
800073c6:	02f687b3          	mul	a5,a3,a5
800073ca:	97ba                	add	a5,a5,a4
800073cc:	439c                	lw	a5,0(a5)
800073ce:	ce3e                	sw	a5,28(sp)

    usb_device_edpt_stall(handle, ep);
800073d0:	00e14783          	lbu	a5,14(sp)
800073d4:	85be                	mv	a1,a5
800073d6:	4572                	lw	a0,28(sp)
800073d8:	4f9010ef          	jal	800090d0 <usb_device_edpt_stall>
    return 0;
800073dc:	4781                	li	a5,0
}
800073de:	853e                	mv	a0,a5
800073e0:	50b2                	lw	ra,44(sp)
800073e2:	6145                	add	sp,sp,48
800073e4:	8082                	ret

Disassembly of section .text.usbd_ep_clear_stall:

800073e6 <usbd_ep_clear_stall>:

int usbd_ep_clear_stall(uint8_t busid, const uint8_t ep)
{
800073e6:	7179                	add	sp,sp,-48
800073e8:	d606                	sw	ra,44(sp)
800073ea:	87aa                	mv	a5,a0
800073ec:	872e                	mv	a4,a1
800073ee:	00f107a3          	sb	a5,15(sp)
800073f2:	87ba                	mv	a5,a4
800073f4:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
800073f8:	00f14683          	lbu	a3,15(sp)
800073fc:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
80007400:	14800793          	li	a5,328
80007404:	02f687b3          	mul	a5,a3,a5
80007408:	97ba                	add	a5,a5,a4
8000740a:	439c                	lw	a5,0(a5)
8000740c:	ce3e                	sw	a5,28(sp)

    usb_device_edpt_clear_stall(handle, ep);
8000740e:	00e14783          	lbu	a5,14(sp)
80007412:	85be                	mv	a1,a5
80007414:	4572                	lw	a0,28(sp)
80007416:	4df010ef          	jal	800090f4 <usb_device_edpt_clear_stall>
    return 0;
8000741a:	4781                	li	a5,0
}
8000741c:	853e                	mv	a0,a5
8000741e:	50b2                	lw	ra,44(sp)
80007420:	6145                	add	sp,sp,48
80007422:	8082                	ret

Disassembly of section .text.usbd_ep_is_stalled:

80007424 <usbd_ep_is_stalled>:

int usbd_ep_is_stalled(uint8_t busid, const uint8_t ep, uint8_t *stalled)
{
80007424:	7179                	add	sp,sp,-48
80007426:	d606                	sw	ra,44(sp)
80007428:	87aa                	mv	a5,a0
8000742a:	872e                	mv	a4,a1
8000742c:	c432                	sw	a2,8(sp)
8000742e:	00f107a3          	sb	a5,15(sp)
80007432:	87ba                	mv	a5,a4
80007434:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
80007438:	00f14683          	lbu	a3,15(sp)
8000743c:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
80007440:	14800793          	li	a5,328
80007444:	02f687b3          	mul	a5,a3,a5
80007448:	97ba                	add	a5,a5,a4
8000744a:	439c                	lw	a5,0(a5)
8000744c:	ce3e                	sw	a5,28(sp)

    *stalled = usb_device_edpt_check_stall(handle, ep);
8000744e:	00e14783          	lbu	a5,14(sp)
80007452:	85be                	mv	a1,a5
80007454:	4572                	lw	a0,28(sp)
80007456:	cf8fd0ef          	jal	8000494e <usb_device_edpt_check_stall>
8000745a:	87aa                	mv	a5,a0
8000745c:	873e                	mv	a4,a5
8000745e:	47a2                	lw	a5,8(sp)
80007460:	00e78023          	sb	a4,0(a5) # 2000 <__APB_SRAM_segment_size__>
    return 0;
80007464:	4781                	li	a5,0
}
80007466:	853e                	mv	a0,a5
80007468:	50b2                	lw	ra,44(sp)
8000746a:	6145                	add	sp,sp,48
8000746c:	8082                	ret

Disassembly of section .text.syscall_handler:

8000746e <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
8000746e:	1101                	add	sp,sp,-32
80007470:	ce2a                	sw	a0,28(sp)
80007472:	cc2e                	sw	a1,24(sp)
80007474:	ca32                	sw	a2,20(sp)
80007476:	c836                	sw	a3,16(sp)
80007478:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
8000747a:	0001                	nop
8000747c:	6105                	add	sp,sp,32
8000747e:	8082                	ret

Disassembly of section .text.hpm_csr_get_core_cycle:

80007480 <hpm_csr_get_core_cycle>:
 *          - in user mode if the device supports M/U mode
 *
 * @return CSR cycle value in 64-bit
 */
static inline uint64_t hpm_csr_get_core_cycle(void)
{
80007480:	7179                	add	sp,sp,-48

80007482 <.LBB2>:
    uint64_t result;
    uint32_t resultl_first = read_csr(CSR_CYCLE);
80007482:	c0002f73          	rdcycle	t5
80007486:	d27a                	sw	t5,36(sp)
80007488:	5f12                	lw	t5,36(sp)

8000748a <.LBE2>:
8000748a:	d07a                	sw	t5,32(sp)

8000748c <.LBB3>:
    uint32_t resulth = read_csr(CSR_CYCLEH);
8000748c:	c8002f73          	rdcycleh	t5
80007490:	ce7a                	sw	t5,28(sp)
80007492:	4f72                	lw	t5,28(sp)

80007494 <.LBE3>:
80007494:	cc7a                	sw	t5,24(sp)

80007496 <.LBB4>:
    uint32_t resultl_second = read_csr(CSR_CYCLE);
80007496:	c0002f73          	rdcycle	t5
8000749a:	ca7a                	sw	t5,20(sp)
8000749c:	4f52                	lw	t5,20(sp)

8000749e <.LBE4>:
8000749e:	c87a                	sw	t5,16(sp)
    if (resultl_first < resultl_second) {
800074a0:	5f82                	lw	t6,32(sp)
800074a2:	4f42                	lw	t5,16(sp)
800074a4:	03eff263          	bgeu	t6,t5,800074c8 <.L2>
        result = ((uint64_t)resulth << 32) | resultl_first; /* if CYCLE didn't roll over, return the value directly */
800074a8:	47e2                	lw	a5,24(sp)
800074aa:	8e3e                	mv	t3,a5
800074ac:	4e81                	li	t4,0
800074ae:	000e1693          	sll	a3,t3,0x0
800074b2:	4601                	li	a2,0
800074b4:	5782                	lw	a5,32(sp)
800074b6:	883e                	mv	a6,a5
800074b8:	4881                	li	a7,0
800074ba:	010667b3          	or	a5,a2,a6
800074be:	d43e                	sw	a5,40(sp)
800074c0:	0116e7b3          	or	a5,a3,a7
800074c4:	d63e                	sw	a5,44(sp)
800074c6:	a025                	j	800074ee <.L3>

800074c8 <.L2>:
    } else {
        resulth = read_csr(CSR_CYCLEH);
800074c8:	c80026f3          	rdcycleh	a3
800074cc:	c636                	sw	a3,12(sp)
800074ce:	46b2                	lw	a3,12(sp)

800074d0 <.LBE5>:
800074d0:	cc36                	sw	a3,24(sp)
        result = ((uint64_t)resulth << 32) | resultl_second; /* if CYCLE rolled over, need to get the CYCLEH again */
800074d2:	46e2                	lw	a3,24(sp)
800074d4:	8336                	mv	t1,a3
800074d6:	4381                	li	t2,0
800074d8:	00031793          	sll	a5,t1,0x0
800074dc:	4701                	li	a4,0
800074de:	46c2                	lw	a3,16(sp)
800074e0:	8536                	mv	a0,a3
800074e2:	4581                	li	a1,0
800074e4:	00a766b3          	or	a3,a4,a0
800074e8:	d436                	sw	a3,40(sp)
800074ea:	8fcd                	or	a5,a5,a1
800074ec:	d63e                	sw	a5,44(sp)

800074ee <.L3>:
    }
    return result;
800074ee:	5722                	lw	a4,40(sp)
800074f0:	57b2                	lw	a5,44(sp)
 }
800074f2:	853a                	mv	a0,a4
800074f4:	85be                	mv	a1,a5
800074f6:	6145                	add	sp,sp,48
800074f8:	8082                	ret

Disassembly of section .text.pllctl_get_div:

800074fa <pllctl_get_div>:
 * @param[in] div_index Target DIV to query
 *
 * @return Divider value of target DIV
 */
static inline hpm_stat_t pllctl_get_div(PLLCTL_Type *ptr, uint8_t pll, uint8_t div_index)
{
800074fa:	1141                	add	sp,sp,-16
800074fc:	c62a                	sw	a0,12(sp)
800074fe:	87ae                	mv	a5,a1
80007500:	8732                	mv	a4,a2
80007502:	00f105a3          	sb	a5,11(sp)
80007506:	87ba                	mv	a5,a4
80007508:	00f10523          	sb	a5,10(sp)
    if ((pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1))
8000750c:	00b14703          	lbu	a4,11(sp)
80007510:	4791                	li	a5,4
80007512:	00e7ec63          	bltu	a5,a4,8000752a <.L6>
            || !(PLLCTL_SOC_PLL_HAS_DIV0(pll))) {
80007516:	00b14703          	lbu	a4,11(sp)
8000751a:	4785                	li	a5,1
8000751c:	00f70963          	beq	a4,a5,8000752e <.L7>
80007520:	00b14703          	lbu	a4,11(sp)
80007524:	4789                	li	a5,2
80007526:	00f70463          	beq	a4,a5,8000752e <.L7>

8000752a <.L6>:
        return status_invalid_argument;
8000752a:	4789                	li	a5,2
8000752c:	a80d                	j	8000755e <.L8>

8000752e <.L7>:
    }
    if (div_index) {
8000752e:	00a14783          	lbu	a5,10(sp)
80007532:	cf81                	beqz	a5,8000754a <.L9>
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV1) + 1;
80007534:	00b14783          	lbu	a5,11(sp)
80007538:	4732                	lw	a4,12(sp)
8000753a:	079e                	sll	a5,a5,0x7
8000753c:	97ba                	add	a5,a5,a4
8000753e:	0c47a783          	lw	a5,196(a5)
80007542:	0ff7f793          	zext.b	a5,a5
80007546:	0785                	add	a5,a5,1
80007548:	a819                	j	8000755e <.L8>

8000754a <.L9>:
    } else {
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV0) + 1;
8000754a:	00b14783          	lbu	a5,11(sp)
8000754e:	4732                	lw	a4,12(sp)
80007550:	079e                	sll	a5,a5,0x7
80007552:	97ba                	add	a5,a5,a4
80007554:	0c07a783          	lw	a5,192(a5)
80007558:	0ff7f793          	zext.b	a5,a5
8000755c:	0785                	add	a5,a5,1

8000755e <.L8>:
    }
}
8000755e:	853e                	mv	a0,a5
80007560:	0141                	add	sp,sp,16
80007562:	8082                	ret

Disassembly of section .text.clock_get_frequency:

80007564 <clock_get_frequency>:

/***********************************************************************************************************************
 * Codes
 **********************************************************************************************************************/
uint32_t clock_get_frequency(clock_name_t clock_name)
{
80007564:	7179                	add	sp,sp,-48
80007566:	d606                	sw	ra,44(sp)
80007568:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
8000756a:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
8000756c:	47b2                	lw	a5,12(sp)
8000756e:	83a1                	srl	a5,a5,0x8
80007570:	0ff7f793          	zext.b	a5,a5
80007574:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80007576:	47b2                	lw	a5,12(sp)
80007578:	0ff7f793          	zext.b	a5,a5
8000757c:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
8000757e:	4762                	lw	a4,24(sp)
80007580:	47b1                	li	a5,12
80007582:	08e7ee63          	bltu	a5,a4,8000761e <.L18>
80007586:	47e2                	lw	a5,24(sp)
80007588:	00279713          	sll	a4,a5,0x2
8000758c:	800047b7          	lui	a5,0x80004
80007590:	89878793          	add	a5,a5,-1896 # 80003898 <.L20>
80007594:	97ba                	add	a5,a5,a4
80007596:	439c                	lw	a5,0(a5)
80007598:	8782                	jr	a5

8000759a <.L32>:
    case CLK_SRC_GROUP_COMMON:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
8000759a:	47d2                	lw	a5,20(sp)
8000759c:	0ff7f793          	zext.b	a5,a5
800075a0:	853e                	mv	a0,a5
800075a2:	2069                	jal	8000762c <.LFE130>
800075a4:	ce2a                	sw	a0,28(sp)
        break;
800075a6:	a8b5                	j	80007622 <.L33>

800075a8 <.L31>:
    case CLK_SRC_GROUP_ADC:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_ADC, node_or_instance);
800075a8:	45d2                	lw	a1,20(sp)
800075aa:	4505                	li	a0,1
800075ac:	2b2040ef          	jal	8000b85e <get_frequency_for_i2s_or_adc>
800075b0:	ce2a                	sw	a0,28(sp)
        break;
800075b2:	a885                	j	80007622 <.L33>

800075b4 <.L30>:
    case CLK_SRC_GROUP_I2S:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_I2S, node_or_instance);
800075b4:	45d2                	lw	a1,20(sp)
800075b6:	4509                	li	a0,2
800075b8:	2a6040ef          	jal	8000b85e <get_frequency_for_i2s_or_adc>
800075bc:	ce2a                	sw	a0,28(sp)
        break;
800075be:	a095                	j	80007622 <.L33>

800075c0 <.L29>:
    case CLK_SRC_GROUP_WDG:
        clk_freq = get_frequency_for_wdg(node_or_instance);
800075c0:	4552                	lw	a0,20(sp)
800075c2:	374040ef          	jal	8000b936 <get_frequency_for_wdg>
800075c6:	ce2a                	sw	a0,28(sp)
        break;
800075c8:	a8a9                	j	80007622 <.L33>

800075ca <.L19>:
    case CLK_SRC_GROUP_PWDG:
        clk_freq = get_frequency_for_pwdg();
800075ca:	3a0040ef          	jal	8000b96a <get_frequency_for_pwdg>
800075ce:	ce2a                	sw	a0,28(sp)
        break;
800075d0:	a889                	j	80007622 <.L33>

800075d2 <.L28>:
    case CLK_SRC_GROUP_PMIC:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
800075d2:	016e37b7          	lui	a5,0x16e3
800075d6:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
800075da:	ce3e                	sw	a5,28(sp)
        break;
800075dc:	a099                	j	80007622 <.L33>

800075de <.L27>:
    case CLK_SRC_GROUP_AHB:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
800075de:	451d                	li	a0,7
800075e0:	20b1                	jal	8000762c <.LFE130>
800075e2:	ce2a                	sw	a0,28(sp)
        break;
800075e4:	a83d                	j	80007622 <.L33>

800075e6 <.L26>:
    case CLK_SRC_GROUP_AXI0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi0);
800075e6:	4511                	li	a0,4
800075e8:	2091                	jal	8000762c <.LFE130>
800075ea:	ce2a                	sw	a0,28(sp)
        break;
800075ec:	a81d                	j	80007622 <.L33>

800075ee <.L25>:
    case CLK_SRC_GROUP_AXI1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi1);
800075ee:	4515                	li	a0,5
800075f0:	2835                	jal	8000762c <.LFE130>
800075f2:	ce2a                	sw	a0,28(sp)
        break;
800075f4:	a03d                	j	80007622 <.L33>

800075f6 <.L24>:
    case CLK_SRC_GROUP_AXI2:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi2);
800075f6:	4519                	li	a0,6
800075f8:	2815                	jal	8000762c <.LFE130>
800075fa:	ce2a                	sw	a0,28(sp)
        break;
800075fc:	a01d                	j	80007622 <.L33>

800075fe <.L23>:
    case CLK_SRC_GROUP_CPU0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
800075fe:	4501                	li	a0,0
80007600:	2035                	jal	8000762c <.LFE130>
80007602:	ce2a                	sw	a0,28(sp)
        break;
80007604:	a839                	j	80007622 <.L33>

80007606 <.L22>:
    case CLK_SRC_GROUP_CPU1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu1);
80007606:	4509                	li	a0,2
80007608:	2015                	jal	8000762c <.LFE130>
8000760a:	ce2a                	sw	a0,28(sp)
        break;
8000760c:	a819                	j	80007622 <.L33>

8000760e <.L21>:
    case CLK_SRC_GROUP_SRC:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
8000760e:	47d2                	lw	a5,20(sp)
80007610:	0ff7f793          	zext.b	a5,a5
80007614:	853e                	mv	a0,a5
80007616:	148040ef          	jal	8000b75e <get_frequency_for_source>
8000761a:	ce2a                	sw	a0,28(sp)
        break;
8000761c:	a019                	j	80007622 <.L33>

8000761e <.L18>:
    default:
        clk_freq = 0UL;
8000761e:	ce02                	sw	zero,28(sp)
        break;
80007620:	0001                	nop

80007622 <.L33>:
    }
    return clk_freq;
80007622:	47f2                	lw	a5,28(sp)
}
80007624:	853e                	mv	a0,a5
80007626:	50b2                	lw	ra,44(sp)
80007628:	6145                	add	sp,sp,48
8000762a:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

8000762c <get_frequency_for_ip_in_common_group>:

    return clk_freq;
}

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
8000762c:	7139                	add	sp,sp,-64
8000762e:	de06                	sw	ra,60(sp)
80007630:	87aa                	mv	a5,a0
80007632:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80007636:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
80007638:	00f14783          	lbu	a5,15(sp)
8000763c:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
8000763e:	5722                	lw	a4,40(sp)
80007640:	04a00793          	li	a5,74
80007644:	04e7e663          	bltu	a5,a4,80007690 <.L49>

80007648 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
80007648:	57a2                	lw	a5,40(sp)
8000764a:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
8000764c:	f4000737          	lui	a4,0xf4000
80007650:	5792                	lw	a5,36(sp)
80007652:	60078793          	add	a5,a5,1536
80007656:	078a                	sll	a5,a5,0x2
80007658:	97ba                	add	a5,a5,a4
8000765a:	439c                	lw	a5,0(a5)
8000765c:	0ff7f793          	zext.b	a5,a5
80007660:	0785                	add	a5,a5,1
80007662:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
80007664:	f4000737          	lui	a4,0xf4000
80007668:	5792                	lw	a5,36(sp)
8000766a:	60078793          	add	a5,a5,1536
8000766e:	078a                	sll	a5,a5,0x2
80007670:	97ba                	add	a5,a5,a4
80007672:	439c                	lw	a5,0(a5)
80007674:	83a1                	srl	a5,a5,0x8
80007676:	8bbd                	and	a5,a5,15
80007678:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
8000767c:	01f14783          	lbu	a5,31(sp)
80007680:	853e                	mv	a0,a5
80007682:	0dc040ef          	jal	8000b75e <get_frequency_for_source>
80007686:	872a                	mv	a4,a0
80007688:	5782                	lw	a5,32(sp)
8000768a:	02f757b3          	divu	a5,a4,a5
8000768e:	d63e                	sw	a5,44(sp)

80007690 <.L49>:
    }
    return clk_freq;
80007690:	57b2                	lw	a5,44(sp)
}
80007692:	853e                	mv	a0,a5
80007694:	50f2                	lw	ra,60(sp)
80007696:	6121                	add	sp,sp,64
80007698:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

8000769a <clock_set_source_divider>:
    }
    return status_success;
}

hpm_stat_t clock_set_source_divider(clock_name_t clock_name, clk_src_t src, uint32_t div)
{
8000769a:	7179                	add	sp,sp,-48
8000769c:	d606                	sw	ra,44(sp)
8000769e:	c62a                	sw	a0,12(sp)
800076a0:	87ae                	mv	a5,a1
800076a2:	c232                	sw	a2,4(sp)
800076a4:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
800076a8:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
800076aa:	47b2                	lw	a5,12(sp)
800076ac:	83a1                	srl	a5,a5,0x8
800076ae:	0ff7f793          	zext.b	a5,a5
800076b2:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
800076b4:	47b2                	lw	a5,12(sp)
800076b6:	0ff7f793          	zext.b	a5,a5
800076ba:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
800076bc:	4762                	lw	a4,24(sp)
800076be:	47b1                	li	a5,12
800076c0:	0ae7e163          	bltu	a5,a4,80007762 <.L140>
800076c4:	47e2                	lw	a5,24(sp)
800076c6:	00279713          	sll	a4,a5,0x2
800076ca:	800047b7          	lui	a5,0x80004
800076ce:	8ec78793          	add	a5,a5,-1812 # 800038ec <.L142>
800076d2:	97ba                	add	a5,a5,a4
800076d4:	439c                	lw	a5,0(a5)
800076d6:	8782                	jr	a5

800076d8 <.L150>:
    case CLK_SRC_GROUP_COMMON:
        if ((div < 1U) || (div > 256U)) {
800076d8:	4792                	lw	a5,4(sp)
800076da:	c791                	beqz	a5,800076e6 <.L151>
800076dc:	4712                	lw	a4,4(sp)
800076de:	10000793          	li	a5,256
800076e2:	00e7f763          	bgeu	a5,a4,800076f0 <.L152>

800076e6 <.L151>:
            status = status_clk_div_invalid;
800076e6:	6795                	lui	a5,0x5
800076e8:	5f078793          	add	a5,a5,1520 # 55f0 <__HEAPSIZE__+0x15f0>
800076ec:	ce3e                	sw	a5,28(sp)
        } else {
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
        }
        break;
800076ee:	a8bd                	j	8000776c <.L154>

800076f0 <.L152>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
800076f0:	00b14783          	lbu	a5,11(sp)
800076f4:	8bbd                	and	a5,a5,15
800076f6:	00f109a3          	sb	a5,19(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
800076fa:	47d2                	lw	a5,20(sp)
800076fc:	0ff7f793          	zext.b	a5,a5
80007700:	01314703          	lbu	a4,19(sp)
80007704:	4692                	lw	a3,4(sp)
80007706:	863a                	mv	a2,a4
80007708:	85be                	mv	a1,a5
8000770a:	f4000537          	lui	a0,0xf4000
8000770e:	2cc5                	jal	800079fe <sysctl_config_clock>

80007710 <.LBE14>:
        break;
80007710:	a8b1                	j	8000776c <.L154>

80007712 <.L141>:
    case CLK_SRC_GROUP_ADC:
    case CLK_SRC_GROUP_I2S:
    case CLK_SRC_GROUP_WDG:
    case CLK_SRC_GROUP_PWDG:
    case CLK_SRC_GROUP_SRC:
        status = status_clk_operation_unsupported;
80007712:	6795                	lui	a5,0x5
80007714:	5f378793          	add	a5,a5,1523 # 55f3 <__HEAPSIZE__+0x15f3>
80007718:	ce3e                	sw	a5,28(sp)
        break;
8000771a:	a889                	j	8000776c <.L154>

8000771c <.L149>:
    case CLK_SRC_GROUP_PMIC:
        status = status_clk_fixed;
8000771c:	6795                	lui	a5,0x5
8000771e:	5fa78793          	add	a5,a5,1530 # 55fa <__HEAPSIZE__+0x15fa>
80007722:	ce3e                	sw	a5,28(sp)
        break;
80007724:	a0a1                	j	8000776c <.L154>

80007726 <.L148>:
    case CLK_SRC_GROUP_AHB:
        status = status_clk_shared_ahb;
80007726:	6795                	lui	a5,0x5
80007728:	5f478793          	add	a5,a5,1524 # 55f4 <__HEAPSIZE__+0x15f4>
8000772c:	ce3e                	sw	a5,28(sp)
        break;
8000772e:	a83d                	j	8000776c <.L154>

80007730 <.L147>:
    case CLK_SRC_GROUP_AXI0:
        status = status_clk_shared_axi0;
80007730:	6795                	lui	a5,0x5
80007732:	5f578793          	add	a5,a5,1525 # 55f5 <__HEAPSIZE__+0x15f5>
80007736:	ce3e                	sw	a5,28(sp)
        break;
80007738:	a815                	j	8000776c <.L154>

8000773a <.L146>:
    case CLK_SRC_GROUP_AXI1:
        status = status_clk_shared_axi1;
8000773a:	6795                	lui	a5,0x5
8000773c:	5f678793          	add	a5,a5,1526 # 55f6 <__HEAPSIZE__+0x15f6>
80007740:	ce3e                	sw	a5,28(sp)
        break;
80007742:	a02d                	j	8000776c <.L154>

80007744 <.L145>:
    case CLK_SRC_GROUP_AXI2:
        status = status_clk_shared_axi2;
80007744:	6795                	lui	a5,0x5
80007746:	5f778793          	add	a5,a5,1527 # 55f7 <__HEAPSIZE__+0x15f7>
8000774a:	ce3e                	sw	a5,28(sp)
        break;
8000774c:	a005                	j	8000776c <.L154>

8000774e <.L144>:
    case CLK_SRC_GROUP_CPU0:
        status = status_clk_shared_cpu0;
8000774e:	6795                	lui	a5,0x5
80007750:	5f878793          	add	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
80007754:	ce3e                	sw	a5,28(sp)
        break;
80007756:	a819                	j	8000776c <.L154>

80007758 <.L143>:
    case CLK_SRC_GROUP_CPU1:
        status = status_clk_shared_cpu1;
80007758:	6795                	lui	a5,0x5
8000775a:	5f978793          	add	a5,a5,1529 # 55f9 <__HEAPSIZE__+0x15f9>
8000775e:	ce3e                	sw	a5,28(sp)
        break;
80007760:	a031                	j	8000776c <.L154>

80007762 <.L140>:
    default:
        status = status_clk_src_invalid;
80007762:	6795                	lui	a5,0x5
80007764:	5f178793          	add	a5,a5,1521 # 55f1 <__HEAPSIZE__+0x15f1>
80007768:	ce3e                	sw	a5,28(sp)
        break;
8000776a:	0001                	nop

8000776c <.L154>:
    }

    return status;
8000776c:	47f2                	lw	a5,28(sp)
}
8000776e:	853e                	mv	a0,a5
80007770:	50b2                	lw	ra,44(sp)
80007772:	6145                	add	sp,sp,48
80007774:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80007776 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80007776:	7179                	add	sp,sp,-48
80007778:	d606                	sw	ra,44(sp)
8000777a:	c62a                	sw	a0,12(sp)
8000777c:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
8000777e:	47b2                	lw	a5,12(sp)
80007780:	83c1                	srl	a5,a5,0x10
80007782:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80007784:	4772                	lw	a4,28(sp)
80007786:	15d00793          	li	a5,349
8000778a:	00e7ef63          	bltu	a5,a4,800077a8 <.L165>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
8000778e:	47a2                	lw	a5,8(sp)
80007790:	0ff7f793          	zext.b	a5,a5
80007794:	4772                	lw	a4,28(sp)
80007796:	0742                	sll	a4,a4,0x10
80007798:	8341                	srl	a4,a4,0x10
8000779a:	4685                	li	a3,1
8000779c:	863a                	mv	a2,a4
8000779e:	85be                	mv	a1,a5
800077a0:	f4000537          	lui	a0,0xf4000
800077a4:	2d2040ef          	jal	8000ba76 <sysctl_enable_group_resource>

800077a8 <.L165>:
    }
}
800077a8:	0001                	nop
800077aa:	50b2                	lw	ra,44(sp)
800077ac:	6145                	add	sp,sp,48
800077ae:	8082                	ret

Disassembly of section .text.clock_remove_from_group:

800077b0 <clock_remove_from_group>:

void clock_remove_from_group(clock_name_t clock_name, uint32_t group)
{
800077b0:	7179                	add	sp,sp,-48
800077b2:	d606                	sw	ra,44(sp)
800077b4:	c62a                	sw	a0,12(sp)
800077b6:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
800077b8:	47b2                	lw	a5,12(sp)
800077ba:	83c1                	srl	a5,a5,0x10
800077bc:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
800077be:	4772                	lw	a4,28(sp)
800077c0:	15d00793          	li	a5,349
800077c4:	00e7ef63          	bltu	a5,a4,800077e2 <.L168>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, false);
800077c8:	47a2                	lw	a5,8(sp)
800077ca:	0ff7f793          	zext.b	a5,a5
800077ce:	4772                	lw	a4,28(sp)
800077d0:	0742                	sll	a4,a4,0x10
800077d2:	8341                	srl	a4,a4,0x10
800077d4:	4681                	li	a3,0
800077d6:	863a                	mv	a2,a4
800077d8:	85be                	mv	a1,a5
800077da:	f4000537          	lui	a0,0xf4000
800077de:	298040ef          	jal	8000ba76 <sysctl_enable_group_resource>

800077e2 <.L168>:
    }
}
800077e2:	0001                	nop
800077e4:	50b2                	lw	ra,44(sp)
800077e6:	6145                	add	sp,sp,48
800077e8:	8082                	ret

Disassembly of section .text.clock_cpu_delay_us:

800077ea <clock_cpu_delay_us>:
    }
    return (hpm_core_clock + FREQ_1MHz - 1U) / 1000;
}

void clock_cpu_delay_us(uint32_t us)
{
800077ea:	715d                	add	sp,sp,-80
800077ec:	c686                	sw	ra,76(sp)
800077ee:	c4a2                	sw	s0,72(sp)
800077f0:	c2a6                	sw	s1,68(sp)
800077f2:	c0ca                	sw	s2,64(sp)
800077f4:	de4e                	sw	s3,60(sp)
800077f6:	dc52                	sw	s4,56(sp)
800077f8:	da56                	sw	s5,52(sp)
800077fa:	d85a                	sw	s6,48(sp)
800077fc:	d65e                	sw	s7,44(sp)
800077fe:	c62a                	sw	a0,12(sp)
    uint64_t expected_ticks = hpm_csr_get_core_cycle() + (uint64_t)clock_get_core_clock_ticks_per_us() * (uint64_t)us;
80007800:	3141                	jal	80007480 <hpm_csr_get_core_cycle>
80007802:	8b2a                	mv	s6,a0
80007804:	8bae                	mv	s7,a1
80007806:	1b4040ef          	jal	8000b9ba <clock_get_core_clock_ticks_per_us>
8000780a:	87aa                	mv	a5,a0
8000780c:	8a3e                	mv	s4,a5
8000780e:	4a81                	li	s5,0
80007810:	47b2                	lw	a5,12(sp)
80007812:	893e                	mv	s2,a5
80007814:	4981                	li	s3,0
80007816:	032a8733          	mul	a4,s5,s2
8000781a:	034987b3          	mul	a5,s3,s4
8000781e:	97ba                	add	a5,a5,a4
80007820:	032a0733          	mul	a4,s4,s2
80007824:	032a34b3          	mulhu	s1,s4,s2
80007828:	843a                	mv	s0,a4
8000782a:	97a6                	add	a5,a5,s1
8000782c:	84be                	mv	s1,a5
8000782e:	008b0733          	add	a4,s6,s0
80007832:	86ba                	mv	a3,a4
80007834:	0166b6b3          	sltu	a3,a3,s6
80007838:	009b87b3          	add	a5,s7,s1
8000783c:	96be                	add	a3,a3,a5
8000783e:	87b6                	mv	a5,a3
80007840:	cc3a                	sw	a4,24(sp)
80007842:	ce3e                	sw	a5,28(sp)
    while (hpm_csr_get_core_cycle() < expected_ticks) {
80007844:	0001                	nop

80007846 <.L184>:
80007846:	392d                	jal	80007480 <hpm_csr_get_core_cycle>
80007848:	872a                	mv	a4,a0
8000784a:	87ae                	mv	a5,a1
8000784c:	46f2                	lw	a3,28(sp)
8000784e:	863e                	mv	a2,a5
80007850:	fed66be3          	bltu	a2,a3,80007846 <.L184>
80007854:	46f2                	lw	a3,28(sp)
80007856:	863e                	mv	a2,a5
80007858:	00c69663          	bne	a3,a2,80007864 <.L186>
8000785c:	46e2                	lw	a3,24(sp)
8000785e:	87ba                	mv	a5,a4
80007860:	fed7e3e3          	bltu	a5,a3,80007846 <.L184>

80007864 <.L186>:
    }
}
80007864:	0001                	nop
80007866:	40b6                	lw	ra,76(sp)
80007868:	4426                	lw	s0,72(sp)
8000786a:	4496                	lw	s1,68(sp)
8000786c:	4906                	lw	s2,64(sp)
8000786e:	59f2                	lw	s3,60(sp)
80007870:	5a62                	lw	s4,56(sp)
80007872:	5ad2                	lw	s5,52(sp)
80007874:	5b42                	lw	s6,48(sp)
80007876:	5bb2                	lw	s7,44(sp)
80007878:	6161                	add	sp,sp,80
8000787a:	8082                	ret

Disassembly of section .text.clock_cpu_delay_ms:

8000787c <clock_cpu_delay_ms>:

void clock_cpu_delay_ms(uint32_t ms)
{
8000787c:	715d                	add	sp,sp,-80
8000787e:	c686                	sw	ra,76(sp)
80007880:	c4a2                	sw	s0,72(sp)
80007882:	c2a6                	sw	s1,68(sp)
80007884:	c0ca                	sw	s2,64(sp)
80007886:	de4e                	sw	s3,60(sp)
80007888:	dc52                	sw	s4,56(sp)
8000788a:	da56                	sw	s5,52(sp)
8000788c:	d85a                	sw	s6,48(sp)
8000788e:	d65e                	sw	s7,44(sp)
80007890:	c62a                	sw	a0,12(sp)
    uint64_t expected_ticks = hpm_csr_get_core_cycle() + (uint64_t)clock_get_core_clock_ticks_per_ms() * (uint64_t)ms;
80007892:	36fd                	jal	80007480 <hpm_csr_get_core_cycle>
80007894:	8b2a                	mv	s6,a0
80007896:	8bae                	mv	s7,a1
80007898:	152040ef          	jal	8000b9ea <clock_get_core_clock_ticks_per_ms>
8000789c:	87aa                	mv	a5,a0
8000789e:	8a3e                	mv	s4,a5
800078a0:	4a81                	li	s5,0
800078a2:	47b2                	lw	a5,12(sp)
800078a4:	893e                	mv	s2,a5
800078a6:	4981                	li	s3,0
800078a8:	032a8733          	mul	a4,s5,s2
800078ac:	034987b3          	mul	a5,s3,s4
800078b0:	97ba                	add	a5,a5,a4
800078b2:	032a0733          	mul	a4,s4,s2
800078b6:	032a34b3          	mulhu	s1,s4,s2
800078ba:	843a                	mv	s0,a4
800078bc:	97a6                	add	a5,a5,s1
800078be:	84be                	mv	s1,a5
800078c0:	008b0733          	add	a4,s6,s0
800078c4:	86ba                	mv	a3,a4
800078c6:	0166b6b3          	sltu	a3,a3,s6
800078ca:	009b87b3          	add	a5,s7,s1
800078ce:	96be                	add	a3,a3,a5
800078d0:	87b6                	mv	a5,a3
800078d2:	cc3a                	sw	a4,24(sp)
800078d4:	ce3e                	sw	a5,28(sp)
    while (hpm_csr_get_core_cycle() < expected_ticks) {
800078d6:	0001                	nop

800078d8 <.L188>:
800078d8:	3665                	jal	80007480 <hpm_csr_get_core_cycle>
800078da:	872a                	mv	a4,a0
800078dc:	87ae                	mv	a5,a1
800078de:	46f2                	lw	a3,28(sp)
800078e0:	863e                	mv	a2,a5
800078e2:	fed66be3          	bltu	a2,a3,800078d8 <.L188>
800078e6:	46f2                	lw	a3,28(sp)
800078e8:	863e                	mv	a2,a5
800078ea:	00c69663          	bne	a3,a2,800078f6 <.L190>
800078ee:	46e2                	lw	a3,24(sp)
800078f0:	87ba                	mv	a5,a4
800078f2:	fed7e3e3          	bltu	a5,a3,800078d8 <.L188>

800078f6 <.L190>:
    }
}
800078f6:	0001                	nop
800078f8:	40b6                	lw	ra,76(sp)
800078fa:	4426                	lw	s0,72(sp)
800078fc:	4496                	lw	s1,68(sp)
800078fe:	4906                	lw	s2,64(sp)
80007900:	59f2                	lw	s3,60(sp)
80007902:	5a62                	lw	s4,56(sp)
80007904:	5ad2                	lw	s5,52(sp)
80007906:	5b42                	lw	s6,48(sp)
80007908:	5bb2                	lw	s7,44(sp)
8000790a:	6161                	add	sp,sp,80
8000790c:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

8000790e <clock_update_core_clock>:

void clock_update_core_clock(void)
{
8000790e:	1101                	add	sp,sp,-32
80007910:	ce06                	sw	ra,28(sp)

80007912 <.LBB16>:
    uint32_t hart_id = read_csr(CSR_MHARTID);
80007912:	f14027f3          	csrr	a5,mhartid
80007916:	c63e                	sw	a5,12(sp)
80007918:	47b2                	lw	a5,12(sp)

8000791a <.LBE16>:
8000791a:	c43e                	sw	a5,8(sp)
    clock_name_t cpu_clk_name = (hart_id == 1U) ? clock_cpu1 : clock_cpu0;
8000791c:	4722                	lw	a4,8(sp)
8000791e:	4785                	li	a5,1
80007920:	00f71663          	bne	a4,a5,8000792c <.L192>
80007924:	000807b7          	lui	a5,0x80
80007928:	0789                	add	a5,a5,2 # 80002 <__AXI_SRAM_segment_size__+0x2>
8000792a:	a011                	j	8000792e <.L193>

8000792c <.L192>:
8000792c:	4781                	li	a5,0

8000792e <.L193>:
8000792e:	c23e                	sw	a5,4(sp)
    hpm_core_clock = clock_get_frequency(cpu_clk_name);
80007930:	4512                	lw	a0,4(sp)
80007932:	390d                	jal	80007564 <clock_get_frequency>
80007934:	872a                	mv	a4,a0
80007936:	bee22223          	sw	a4,-1052(tp) # fffffbe4 <__APB_SRAM_segment_end__+0xbf0dbe4>
8000793a:	0001                	nop
8000793c:	40f2                	lw	ra,28(sp)
8000793e:	6105                	add	sp,sp,32
80007940:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80007942 <l1c_dc_enable>:

    write_csr(CSR_MSTATUS, csr);
}

void l1c_dc_enable(void)
{
80007942:	1141                	add	sp,sp,-16

80007944 <.LBB56>:
extern "C" {
#endif
/* get cache control register value */
__attribute__((always_inline)) static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80007944:	7ca027f3          	csrr	a5,0x7ca
80007948:	c63e                	sw	a5,12(sp)
8000794a:	47b2                	lw	a5,12(sp)

8000794c <.LBE60>:
8000794c:	0001                	nop

8000794e <.LBE58>:
}

__attribute__((always_inline)) static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
8000794e:	8b89                	and	a5,a5,2
80007950:	00f037b3          	snez	a5,a5
80007954:	0ff7f793          	zext.b	a5,a5

80007958 <.LBE56>:
    if (!l1c_dc_is_enabled()) {
80007958:	0017c793          	xor	a5,a5,1
8000795c:	0ff7f793          	zext.b	a5,a5
80007960:	cb89                	beqz	a5,80007972 <.L13>
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
80007962:	001807b7          	lui	a5,0x180
80007966:	7ca7b073          	csrc	0x7ca,a5
        set_csr(CSR_MCACHE_CTL,
8000796a:	67c1                	lui	a5,0x10
8000796c:	0789                	add	a5,a5,2 # 10002 <__XPI0_segment_used_size__+0x2c4a>
8000796e:	7ca7a073          	csrs	0x7ca,a5

80007972 <.L13>:
                HPM_MCACHE_CTL_DC_WAROUND(L1C_DC_WAROUND_VALUE) |
#endif
                                HPM_MCACHE_CTL_DPREF_EN_MASK
                              | HPM_MCACHE_CTL_DC_EN_MASK);
    }
}
80007972:	0001                	nop
80007974:	0141                	add	sp,sp,16
80007976:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

80007978 <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
80007978:	1141                	add	sp,sp,-16

8000797a <.LBB66>:
    return read_csr(CSR_MCACHE_CTL);
8000797a:	7ca027f3          	csrr	a5,0x7ca
8000797e:	c63e                	sw	a5,12(sp)
80007980:	47b2                	lw	a5,12(sp)

80007982 <.LBE70>:
80007982:	0001                	nop

80007984 <.LBE68>:
}

__attribute__((always_inline)) static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
80007984:	8b85                	and	a5,a5,1
80007986:	00f037b3          	snez	a5,a5
8000798a:	0ff7f793          	zext.b	a5,a5

8000798e <.LBE66>:
    if (!l1c_ic_is_enabled()) {
8000798e:	0017c793          	xor	a5,a5,1
80007992:	0ff7f793          	zext.b	a5,a5
80007996:	c789                	beqz	a5,800079a0 <.L23>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
80007998:	30100793          	li	a5,769
8000799c:	7ca7a073          	csrs	0x7ca,a5

800079a0 <.L23>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
800079a0:	0001                	nop
800079a2:	0141                	add	sp,sp,16
800079a4:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

800079a6 <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
800079a6:	1141                	add	sp,sp,-16
800079a8:	c62a                	sw	a0,12(sp)
800079aa:	87ae                	mv	a5,a1
800079ac:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
800079b0:	00a15783          	lhu	a5,10(sp)
800079b4:	4732                	lw	a4,12(sp)
800079b6:	078a                	sll	a5,a5,0x2
800079b8:	97ba                	add	a5,a5,a4
800079ba:	4398                	lw	a4,0(a5)
800079bc:	400007b7          	lui	a5,0x40000
800079c0:	8ff9                	and	a5,a5,a4
800079c2:	00f037b3          	snez	a5,a5
800079c6:	0ff7f793          	zext.b	a5,a5
}
800079ca:	853e                	mv	a0,a5
800079cc:	0141                	add	sp,sp,16
800079ce:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

800079d0 <sysctl_clock_target_is_busy>:
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr,
                                               clock_node_t clock)
{
800079d0:	1141                	add	sp,sp,-16
800079d2:	c62a                	sw	a0,12(sp)
800079d4:	87ae                	mv	a5,a1
800079d6:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
800079da:	00b14783          	lbu	a5,11(sp)
800079de:	4732                	lw	a4,12(sp)
800079e0:	60078793          	add	a5,a5,1536 # 40000600 <_extram_size+0x3e000600>
800079e4:	078a                	sll	a5,a5,0x2
800079e6:	97ba                	add	a5,a5,a4
800079e8:	4398                	lw	a4,0(a5)
800079ea:	400007b7          	lui	a5,0x40000
800079ee:	8ff9                	and	a5,a5,a4
800079f0:	00f037b3          	snez	a5,a5
800079f4:	0ff7f793          	zext.b	a5,a5
}
800079f8:	853e                	mv	a0,a5
800079fa:	0141                	add	sp,sp,16
800079fc:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

800079fe <sysctl_config_clock>:
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node,
                                clock_source_t source, uint32_t divide_by)
{
800079fe:	1101                	add	sp,sp,-32
80007a00:	ce06                	sw	ra,28(sp)
80007a02:	c62a                	sw	a0,12(sp)
80007a04:	87ae                	mv	a5,a1
80007a06:	8732                	mv	a4,a2
80007a08:	c236                	sw	a3,4(sp)
80007a0a:	00f105a3          	sb	a5,11(sp)
80007a0e:	87ba                	mv	a5,a4
80007a10:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_i2s_start) {
80007a14:	00b14703          	lbu	a4,11(sp)
80007a18:	04200793          	li	a5,66
80007a1c:	00e7f463          	bgeu	a5,a4,80007a24 <.L114>
        return status_invalid_argument;
80007a20:	4789                	li	a5,2
80007a22:	a89d                	j	80007a98 <.L115>

80007a24 <.L114>:
    }

    if (source >= clock_source_general_source_end) {
80007a24:	00a14703          	lbu	a4,10(sp)
80007a28:	479d                	li	a5,7
80007a2a:	00e7f463          	bgeu	a5,a4,80007a32 <.L116>
        return status_invalid_argument;
80007a2e:	4789                	li	a5,2
80007a30:	a0a5                	j	80007a98 <.L115>

80007a32 <.L116>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80007a32:	00b14783          	lbu	a5,11(sp)
80007a36:	4732                	lw	a4,12(sp)
80007a38:	60078793          	add	a5,a5,1536 # 40000600 <_extram_size+0x3e000600>
80007a3c:	078a                	sll	a5,a5,0x2
80007a3e:	97ba                	add	a5,a5,a4
80007a40:	4398                	lw	a4,0(a5)
80007a42:	77fd                	lui	a5,0xfffff
80007a44:	00f776b3          	and	a3,a4,a5
            ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK))
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80007a48:	00a14783          	lbu	a5,10(sp)
80007a4c:	00879713          	sll	a4,a5,0x8
80007a50:	6785                	lui	a5,0x1
80007a52:	f0078793          	add	a5,a5,-256 # f00 <_etoa+0x18>
80007a56:	8f7d                	and	a4,a4,a5
80007a58:	4792                	lw	a5,4(sp)
80007a5a:	17fd                	add	a5,a5,-1
80007a5c:	0ff7f793          	zext.b	a5,a5
80007a60:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80007a62:	00b14783          	lbu	a5,11(sp)
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80007a66:	8f55                	or	a4,a4,a3
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
80007a68:	46b2                	lw	a3,12(sp)
80007a6a:	60078793          	add	a5,a5,1536
80007a6e:	078a                	sll	a5,a5,0x2
80007a70:	97b6                	add	a5,a5,a3
80007a72:	c398                	sw	a4,0(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
80007a74:	0001                	nop

80007a76 <.L117>:
80007a76:	00b14783          	lbu	a5,11(sp)
80007a7a:	85be                	mv	a1,a5
80007a7c:	4532                	lw	a0,12(sp)
80007a7e:	3f89                	jal	800079d0 <sysctl_clock_target_is_busy>
80007a80:	87aa                	mv	a5,a0
80007a82:	fbf5                	bnez	a5,80007a76 <.L117>
    }

    if ((node == clock_node_cpu0) || (node == clock_node_cpu1)) {
80007a84:	00b14783          	lbu	a5,11(sp)
80007a88:	c791                	beqz	a5,80007a94 <.L118>
80007a8a:	00b14703          	lbu	a4,11(sp)
80007a8e:	4789                	li	a5,2
80007a90:	00f71363          	bne	a4,a5,80007a96 <.L119>

80007a94 <.L118>:
        clock_update_core_clock();
80007a94:	3dad                	jal	8000790e <clock_update_core_clock>

80007a96 <.L119>:
    }
    return status_success;
80007a96:	4781                	li	a5,0

80007a98 <.L115>:
}
80007a98:	853e                	mv	a0,a5
80007a9a:	40f2                	lw	ra,28(sp)
80007a9c:	6105                	add	sp,sp,32
80007a9e:	8082                	ret

Disassembly of section .text.system_init:

80007aa0 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80007aa0:	7179                	add	sp,sp,-48
80007aa2:	d606                	sw	ra,44(sp)
80007aa4:	47a1                	li	a5,8
80007aa6:	c83e                	sw	a5,16(sp)

80007aa8 <.LBB16>:
 * @param[in] mask interrupt mask to be disabled
 * @retval current mstatus value before irq mask is disabled
 */
ATTR_ALWAYS_INLINE static inline uint32_t disable_global_irq(uint32_t mask)
{
    return read_clear_csr(CSR_MSTATUS, mask);
80007aa8:	c602                	sw	zero,12(sp)
80007aaa:	47c2                	lw	a5,16(sp)
80007aac:	3007b7f3          	csrrc	a5,mstatus,a5
80007ab0:	c63e                	sw	a5,12(sp)
80007ab2:	47b2                	lw	a5,12(sp)

80007ab4 <.LBE18>:
80007ab4:	0001                	nop

80007ab6 <.LBB19>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80007ab6:	6785                	lui	a5,0x1
80007ab8:	80078793          	add	a5,a5,-2048 # 800 <.L195+0xa>
80007abc:	3047b073          	csrc	mie,a5
}
80007ac0:	0001                	nop

80007ac2 <.LBE19>:
    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();
    enable_plic_feature();
80007ac2:	0dc040ef          	jal	8000bb9e <enable_plic_feature>

80007ac6 <.LBB21>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80007ac6:	6785                	lui	a5,0x1
80007ac8:	80078793          	add	a5,a5,-2048 # 800 <.L195+0xa>
80007acc:	3047a073          	csrs	mie,a5
}
80007ad0:	0001                	nop
80007ad2:	47a1                	li	a5,8
80007ad4:	ca3e                	sw	a5,20(sp)

80007ad6 <.LBB23>:
    set_csr(CSR_MSTATUS, mask);
80007ad6:	47d2                	lw	a5,20(sp)
80007ad8:	3007a073          	csrs	mstatus,a5
}
80007adc:	0001                	nop

80007ade <.LBB25>:
#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif

#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
80007ade:	306027f3          	csrr	a5,mcounteren
80007ae2:	ce3e                	sw	a5,28(sp)
80007ae4:	47f2                	lw	a5,28(sp)

80007ae6 <.LBE25>:
80007ae6:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80007ae8:	47e2                	lw	a5,24(sp)
80007aea:	0017e793          	or	a5,a5,1
80007aee:	30679073          	csrw	mcounteren,a5
#endif

#if defined(CONFIG_ENABLE_BPOR_RETENTION) && CONFIG_ENABLE_BPOR_RETENTION
    bpor_enable_reg_value_retention(HPM_BPOR);
#endif
}
80007af2:	0001                	nop
80007af4:	50b2                	lw	ra,44(sp)
80007af6:	6145                	add	sp,sp,48
80007af8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80007afa <__SEGGER_RTL_xltoa>:
80007afa:	882a                	mv	a6,a0
80007afc:	88ae                	mv	a7,a1
80007afe:	852e                	mv	a0,a1
80007b00:	ca89                	beqz	a3,80007b12 <.L2>
80007b02:	02d00793          	li	a5,45
80007b06:	00158893          	add	a7,a1,1
80007b0a:	00f58023          	sb	a5,0(a1)
80007b0e:	41000833          	neg	a6,a6

80007b12 <.L2>:
80007b12:	8746                	mv	a4,a7
80007b14:	4325                	li	t1,9

80007b16 <.L5>:
80007b16:	02c876b3          	remu	a3,a6,a2
80007b1a:	85c2                	mv	a1,a6
80007b1c:	0ff6f793          	zext.b	a5,a3
80007b20:	02c85833          	divu	a6,a6,a2
80007b24:	02d37d63          	bgeu	t1,a3,80007b5e <.L3>
80007b28:	05778793          	add	a5,a5,87

80007b2c <.L11>:
80007b2c:	0ff7f793          	zext.b	a5,a5
80007b30:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3cf8000>
80007b34:	00170693          	add	a3,a4,1
80007b38:	02c5f163          	bgeu	a1,a2,80007b5a <.L8>
80007b3c:	000700a3          	sb	zero,1(a4)

80007b40 <.L6>:
80007b40:	0008c683          	lbu	a3,0(a7)
80007b44:	00074783          	lbu	a5,0(a4)
80007b48:	0885                	add	a7,a7,1
80007b4a:	177d                	add	a4,a4,-1
80007b4c:	00d700a3          	sb	a3,1(a4)
80007b50:	fef88fa3          	sb	a5,-1(a7)
80007b54:	fee8e6e3          	bltu	a7,a4,80007b40 <.L6>
80007b58:	8082                	ret

80007b5a <.L8>:
80007b5a:	8736                	mv	a4,a3
80007b5c:	bf6d                	j	80007b16 <.L5>

80007b5e <.L3>:
80007b5e:	03078793          	add	a5,a5,48
80007b62:	b7e9                	j	80007b2c <.L11>

Disassembly of section .text.libc.itoa:

80007b64 <itoa>:
80007b64:	46a9                	li	a3,10
80007b66:	87aa                	mv	a5,a0
80007b68:	882e                	mv	a6,a1
80007b6a:	8732                	mv	a4,a2
80007b6c:	00d61563          	bne	a2,a3,80007b76 <.L301>
80007b70:	4685                	li	a3,1
80007b72:	00054663          	bltz	a0,80007b7e <.L302>

80007b76 <.L301>:
80007b76:	4681                	li	a3,0
80007b78:	863a                	mv	a2,a4
80007b7a:	85c2                	mv	a1,a6
80007b7c:	853e                	mv	a0,a5

80007b7e <.L302>:
80007b7e:	bfb5                	j	80007afa <__SEGGER_RTL_xltoa>

Disassembly of section .text.libc.fwrite:

80007b80 <fwrite>:
80007b80:	1101                	add	sp,sp,-32
80007b82:	c64e                	sw	s3,12(sp)
80007b84:	89aa                	mv	s3,a0
80007b86:	8536                	mv	a0,a3
80007b88:	cc22                	sw	s0,24(sp)
80007b8a:	ca26                	sw	s1,20(sp)
80007b8c:	c84a                	sw	s2,16(sp)
80007b8e:	ce06                	sw	ra,28(sp)
80007b90:	84ae                	mv	s1,a1
80007b92:	8432                	mv	s0,a2
80007b94:	8936                	mv	s2,a3
80007b96:	2aa010ef          	jal	80008e40 <__SEGGER_RTL_X_file_stat>
80007b9a:	02054463          	bltz	a0,80007bc2 <.L43>
80007b9e:	02848633          	mul	a2,s1,s0
80007ba2:	4501                	li	a0,0
80007ba4:	00966863          	bltu	a2,s1,80007bb4 <.L41>
80007ba8:	85ce                	mv	a1,s3
80007baa:	854a                	mv	a0,s2
80007bac:	220010ef          	jal	80008dcc <__SEGGER_RTL_X_file_write>
80007bb0:	02955533          	divu	a0,a0,s1

80007bb4 <.L41>:
80007bb4:	40f2                	lw	ra,28(sp)
80007bb6:	4462                	lw	s0,24(sp)
80007bb8:	44d2                	lw	s1,20(sp)
80007bba:	4942                	lw	s2,16(sp)
80007bbc:	49b2                	lw	s3,12(sp)
80007bbe:	6105                	add	sp,sp,32
80007bc0:	8082                	ret

80007bc2 <.L43>:
80007bc2:	4501                	li	a0,0
80007bc4:	bfc5                	j	80007bb4 <.L41>

Disassembly of section .text.libc.__subsf3:

80007bc6 <__subsf3>:
80007bc6:	80000637          	lui	a2,0x80000
80007bca:	8db1                	xor	a1,a1,a2
80007bcc:	a031                	j	80007bd8 <__addsf3>

Disassembly of section .text.libc.__subdf3:

80007bce <__subdf3>:
80007bce:	80000737          	lui	a4,0x80000
80007bd2:	8eb9                	xor	a3,a3,a4
80007bd4:	0ee0406f          	j	8000bcc2 <__adddf3>

Disassembly of section .text.libc.__addsf3:

80007bd8 <__addsf3>:
80007bd8:	80000637          	lui	a2,0x80000
80007bdc:	00b546b3          	xor	a3,a0,a1
80007be0:	0806ca63          	bltz	a3,80007c74 <.L__addsf3_subtract>
80007be4:	00b57563          	bgeu	a0,a1,80007bee <.L__addsf3_add_already_ordered>
80007be8:	86aa                	mv	a3,a0
80007bea:	852e                	mv	a0,a1
80007bec:	85b6                	mv	a1,a3

80007bee <.L__addsf3_add_already_ordered>:
80007bee:	00151713          	sll	a4,a0,0x1
80007bf2:	8361                	srl	a4,a4,0x18
80007bf4:	00159693          	sll	a3,a1,0x1
80007bf8:	82e1                	srl	a3,a3,0x18
80007bfa:	0ff00293          	li	t0,255
80007bfe:	06570563          	beq	a4,t0,80007c68 <.L__addsf3_add_inf_or_nan>
80007c02:	c325                	beqz	a4,80007c62 <.L__addsf3_zero>
80007c04:	ceb1                	beqz	a3,80007c60 <.L__addsf3_add_done>
80007c06:	40d706b3          	sub	a3,a4,a3
80007c0a:	42e1                	li	t0,24
80007c0c:	04d2ca63          	blt	t0,a3,80007c60 <.L__addsf3_add_done>
80007c10:	05a2                	sll	a1,a1,0x8
80007c12:	8dd1                	or	a1,a1,a2
80007c14:	01755713          	srl	a4,a0,0x17
80007c18:	0522                	sll	a0,a0,0x8
80007c1a:	8d51                	or	a0,a0,a2
80007c1c:	47e5                	li	a5,25
80007c1e:	8f95                	sub	a5,a5,a3
80007c20:	00f59633          	sll	a2,a1,a5
80007c24:	821d                	srl	a2,a2,0x7
80007c26:	00d5d5b3          	srl	a1,a1,a3
80007c2a:	00b507b3          	add	a5,a0,a1
80007c2e:	00a7f463          	bgeu	a5,a0,80007c36 <.L__addsf3_add_no_normalization>
80007c32:	8385                	srl	a5,a5,0x1
80007c34:	0709                	add	a4,a4,2 # 80000002 <_extram_size+0x7e000002>

80007c36 <.L__addsf3_add_no_normalization>:
80007c36:	177d                	add	a4,a4,-1
80007c38:	0ff77593          	zext.b	a1,a4
80007c3c:	f0158593          	add	a1,a1,-255
80007c40:	cd91                	beqz	a1,80007c5c <.L__addsf3_inf>
80007c42:	075e                	sll	a4,a4,0x17
80007c44:	0087d513          	srl	a0,a5,0x8
80007c48:	07e2                	sll	a5,a5,0x18
80007c4a:	8fd1                	or	a5,a5,a2
80007c4c:	0007d663          	bgez	a5,80007c58 <.L__addsf3_no_tie>
80007c50:	0786                	sll	a5,a5,0x1
80007c52:	0505                	add	a0,a0,1 # f4000001 <__AHB_SRAM_segment_end__+0x3cf8001>
80007c54:	e391                	bnez	a5,80007c58 <.L__addsf3_no_tie>
80007c56:	9979                	and	a0,a0,-2

80007c58 <.L__addsf3_no_tie>:
80007c58:	953a                	add	a0,a0,a4
80007c5a:	8082                	ret

80007c5c <.L__addsf3_inf>:
80007c5c:	01771513          	sll	a0,a4,0x17

80007c60 <.L__addsf3_add_done>:
80007c60:	8082                	ret

80007c62 <.L__addsf3_zero>:
80007c62:	817d                	srl	a0,a0,0x1f
80007c64:	057e                	sll	a0,a0,0x1f
80007c66:	8082                	ret

80007c68 <.L__addsf3_add_inf_or_nan>:
80007c68:	00951613          	sll	a2,a0,0x9
80007c6c:	da75                	beqz	a2,80007c60 <.L__addsf3_add_done>

80007c6e <.L__addsf3_return_nan>:
80007c6e:	7fc00537          	lui	a0,0x7fc00
80007c72:	8082                	ret

80007c74 <.L__addsf3_subtract>:
80007c74:	8db1                	xor	a1,a1,a2
80007c76:	40b506b3          	sub	a3,a0,a1
80007c7a:	00b57563          	bgeu	a0,a1,80007c84 <.L__addsf3_sub_already_ordered>
80007c7e:	8eb1                	xor	a3,a3,a2
80007c80:	8d15                	sub	a0,a0,a3
80007c82:	95b6                	add	a1,a1,a3

80007c84 <.L__addsf3_sub_already_ordered>:
80007c84:	00159693          	sll	a3,a1,0x1
80007c88:	82e1                	srl	a3,a3,0x18
80007c8a:	00151713          	sll	a4,a0,0x1
80007c8e:	8361                	srl	a4,a4,0x18
80007c90:	05a2                	sll	a1,a1,0x8
80007c92:	8dd1                	or	a1,a1,a2
80007c94:	0ff00293          	li	t0,255
80007c98:	0c570c63          	beq	a4,t0,80007d70 <.L__addsf3_sub_inf_or_nan>
80007c9c:	c2f5                	beqz	a3,80007d80 <.L__addsf3_sub_zero>
80007c9e:	40d706b3          	sub	a3,a4,a3
80007ca2:	c695                	beqz	a3,80007cce <.L__addsf3_exponents_equal>
80007ca4:	4285                	li	t0,1
80007ca6:	08569063          	bne	a3,t0,80007d26 <.L__addsf3_exponents_differ_by_more_than_1>
80007caa:	01755693          	srl	a3,a0,0x17
80007cae:	0526                	sll	a0,a0,0x9
80007cb0:	00b532b3          	sltu	t0,a0,a1
80007cb4:	8d0d                	sub	a0,a0,a1
80007cb6:	02029263          	bnez	t0,80007cda <.L__addsf3_normalization_steps>
80007cba:	06de                	sll	a3,a3,0x17
80007cbc:	01751593          	sll	a1,a0,0x17
80007cc0:	8125                	srl	a0,a0,0x9
80007cc2:	0005d463          	bgez	a1,80007cca <.L__addsf3_sub_no_tie_single>
80007cc6:	0505                	add	a0,a0,1 # 7fc00001 <_extram_size+0x7dc00001>
80007cc8:	9979                	and	a0,a0,-2

80007cca <.L__addsf3_sub_no_tie_single>:
80007cca:	9536                	add	a0,a0,a3

80007ccc <.L__addsf3_sub_done>:
80007ccc:	8082                	ret

80007cce <.L__addsf3_exponents_equal>:
80007cce:	01755693          	srl	a3,a0,0x17
80007cd2:	0526                	sll	a0,a0,0x9
80007cd4:	0586                	sll	a1,a1,0x1
80007cd6:	8d0d                	sub	a0,a0,a1
80007cd8:	d975                	beqz	a0,80007ccc <.L__addsf3_sub_done>

80007cda <.L__addsf3_normalization_steps>:
80007cda:	4581                	li	a1,0
80007cdc:	01055793          	srl	a5,a0,0x10
80007ce0:	e399                	bnez	a5,80007ce6 <.L1^B1>
80007ce2:	0542                	sll	a0,a0,0x10
80007ce4:	05c1                	add	a1,a1,16

80007ce6 <.L1^B1>:
80007ce6:	01855793          	srl	a5,a0,0x18
80007cea:	e399                	bnez	a5,80007cf0 <.L2^B1>
80007cec:	0522                	sll	a0,a0,0x8
80007cee:	05a1                	add	a1,a1,8

80007cf0 <.L2^B1>:
80007cf0:	01c55793          	srl	a5,a0,0x1c
80007cf4:	e399                	bnez	a5,80007cfa <.L3^B1>
80007cf6:	0512                	sll	a0,a0,0x4
80007cf8:	0591                	add	a1,a1,4

80007cfa <.L3^B1>:
80007cfa:	01e55793          	srl	a5,a0,0x1e
80007cfe:	e399                	bnez	a5,80007d04 <.L4^B1>
80007d00:	050a                	sll	a0,a0,0x2
80007d02:	0589                	add	a1,a1,2

80007d04 <.L4^B1>:
80007d04:	00054463          	bltz	a0,80007d0c <.L5^B1>
80007d08:	0506                	sll	a0,a0,0x1
80007d0a:	0585                	add	a1,a1,1

80007d0c <.L5^B1>:
80007d0c:	0585                	add	a1,a1,1
80007d0e:	0506                	sll	a0,a0,0x1
80007d10:	00e5f763          	bgeu	a1,a4,80007d1e <.L__addsf3_underflow>
80007d14:	8e8d                	sub	a3,a3,a1
80007d16:	06de                	sll	a3,a3,0x17
80007d18:	8125                	srl	a0,a0,0x9
80007d1a:	9536                	add	a0,a0,a3
80007d1c:	8082                	ret

80007d1e <.L__addsf3_underflow>:
80007d1e:	0086d513          	srl	a0,a3,0x8
80007d22:	057e                	sll	a0,a0,0x1f
80007d24:	8082                	ret

80007d26 <.L__addsf3_exponents_differ_by_more_than_1>:
80007d26:	42e5                	li	t0,25
80007d28:	fad2e2e3          	bltu	t0,a3,80007ccc <.L__addsf3_sub_done>
80007d2c:	0685                	add	a3,a3,1
80007d2e:	40d00733          	neg	a4,a3
80007d32:	00e59733          	sll	a4,a1,a4
80007d36:	00d5d5b3          	srl	a1,a1,a3
80007d3a:	00e03733          	snez	a4,a4
80007d3e:	95ae                	add	a1,a1,a1
80007d40:	95ba                	add	a1,a1,a4
80007d42:	01755693          	srl	a3,a0,0x17
80007d46:	0522                	sll	a0,a0,0x8
80007d48:	8d51                	or	a0,a0,a2
80007d4a:	40b50733          	sub	a4,a0,a1
80007d4e:	00074463          	bltz	a4,80007d56 <.L__addsf3_sub_already_normalized>
80007d52:	070a                	sll	a4,a4,0x2
80007d54:	8305                	srl	a4,a4,0x1

80007d56 <.L__addsf3_sub_already_normalized>:
80007d56:	16fd                	add	a3,a3,-1
80007d58:	06de                	sll	a3,a3,0x17
80007d5a:	00875513          	srl	a0,a4,0x8
80007d5e:	0762                	sll	a4,a4,0x18
80007d60:	00075663          	bgez	a4,80007d6c <.L__addsf3_sub_no_tie>
80007d64:	0706                	sll	a4,a4,0x1
80007d66:	0505                	add	a0,a0,1
80007d68:	e311                	bnez	a4,80007d6c <.L__addsf3_sub_no_tie>
80007d6a:	9979                	and	a0,a0,-2

80007d6c <.L__addsf3_sub_no_tie>:
80007d6c:	9536                	add	a0,a0,a3
80007d6e:	8082                	ret

80007d70 <.L__addsf3_sub_inf_or_nan>:
80007d70:	0ff00293          	li	t0,255
80007d74:	ee568de3          	beq	a3,t0,80007c6e <.L__addsf3_return_nan>
80007d78:	00951593          	sll	a1,a0,0x9
80007d7c:	d9a1                	beqz	a1,80007ccc <.L__addsf3_sub_done>
80007d7e:	bdc5                	j	80007c6e <.L__addsf3_return_nan>

80007d80 <.L__addsf3_sub_zero>:
80007d80:	f731                	bnez	a4,80007ccc <.L__addsf3_sub_done>
80007d82:	4501                	li	a0,0
80007d84:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

80007d86 <__ltsf2>:
80007d86:	ff000637          	lui	a2,0xff000
80007d8a:	00151693          	sll	a3,a0,0x1
80007d8e:	02d66763          	bltu	a2,a3,80007dbc <.L__ltsf2_zero>
80007d92:	00159693          	sll	a3,a1,0x1
80007d96:	02d66363          	bltu	a2,a3,80007dbc <.L__ltsf2_zero>
80007d9a:	00b56633          	or	a2,a0,a1
80007d9e:	00161693          	sll	a3,a2,0x1
80007da2:	ce89                	beqz	a3,80007dbc <.L__ltsf2_zero>
80007da4:	00064763          	bltz	a2,80007db2 <.L__ltsf2_negative>
80007da8:	00b53533          	sltu	a0,a0,a1
80007dac:	40a00533          	neg	a0,a0
80007db0:	8082                	ret

80007db2 <.L__ltsf2_negative>:
80007db2:	00a5b533          	sltu	a0,a1,a0
80007db6:	40a00533          	neg	a0,a0
80007dba:	8082                	ret

80007dbc <.L__ltsf2_zero>:
80007dbc:	4501                	li	a0,0
80007dbe:	8082                	ret

Disassembly of section .text.libc.__ltdf2:

80007dc0 <__ltdf2>:
80007dc0:	ffe007b7          	lui	a5,0xffe00
80007dc4:	00159713          	sll	a4,a1,0x1
80007dc8:	02e7e563          	bltu	a5,a4,80007df2 <.L__ltdf2_not_less>
80007dcc:	00169713          	sll	a4,a3,0x1
80007dd0:	02e7e163          	bltu	a5,a4,80007df2 <.L__ltdf2_not_less>
80007dd4:	00d5e733          	or	a4,a1,a3
80007dd8:	00171793          	sll	a5,a4,0x1
80007ddc:	8fc9                	or	a5,a5,a0
80007dde:	8fd1                	or	a5,a5,a2
80007de0:	cb89                	beqz	a5,80007df2 <.L__ltdf2_not_less>
80007de2:	00074a63          	bltz	a4,80007df6 <.L__ltdf2_negative>
80007de6:	00d5ee63          	bltu	a1,a3,80007e02 <.L__ltdf2_less>
80007dea:	00d59463          	bne	a1,a3,80007df2 <.L__ltdf2_not_less>
80007dee:	00c56a63          	bltu	a0,a2,80007e02 <.L__ltdf2_less>

80007df2 <.L__ltdf2_not_less>:
80007df2:	4501                	li	a0,0
80007df4:	8082                	ret

80007df6 <.L__ltdf2_negative>:
80007df6:	00b6e663          	bltu	a3,a1,80007e02 <.L__ltdf2_less>
80007dfa:	feb69ce3          	bne	a3,a1,80007df2 <.L__ltdf2_not_less>
80007dfe:	fea67ae3          	bgeu	a2,a0,80007df2 <.L__ltdf2_not_less>

80007e02 <.L__ltdf2_less>:
80007e02:	557d                	li	a0,-1
80007e04:	8082                	ret

Disassembly of section .text.libc.__lesf2:

80007e06 <__lesf2>:
80007e06:	ff000637          	lui	a2,0xff000
80007e0a:	00151693          	sll	a3,a0,0x1
80007e0e:	02d66363          	bltu	a2,a3,80007e34 <.L__lesf2_nan>
80007e12:	00159693          	sll	a3,a1,0x1
80007e16:	00d66f63          	bltu	a2,a3,80007e34 <.L__lesf2_nan>
80007e1a:	00b56633          	or	a2,a0,a1
80007e1e:	00161693          	sll	a3,a2,0x1
80007e22:	ca99                	beqz	a3,80007e38 <.L__lesf2_zero>
80007e24:	00064563          	bltz	a2,80007e2e <.L__lesf2_negative>
80007e28:	00a5b533          	sltu	a0,a1,a0
80007e2c:	8082                	ret

80007e2e <.L__lesf2_negative>:
80007e2e:	00b53533          	sltu	a0,a0,a1
80007e32:	8082                	ret

80007e34 <.L__lesf2_nan>:
80007e34:	4505                	li	a0,1
80007e36:	8082                	ret

80007e38 <.L__lesf2_zero>:
80007e38:	4501                	li	a0,0
80007e3a:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

80007e3c <__gtsf2>:
80007e3c:	ff000637          	lui	a2,0xff000
80007e40:	00151693          	sll	a3,a0,0x1
80007e44:	02d66363          	bltu	a2,a3,80007e6a <.L__gtsf2_zero>
80007e48:	00159693          	sll	a3,a1,0x1
80007e4c:	00d66f63          	bltu	a2,a3,80007e6a <.L__gtsf2_zero>
80007e50:	00b56633          	or	a2,a0,a1
80007e54:	00161693          	sll	a3,a2,0x1
80007e58:	ca89                	beqz	a3,80007e6a <.L__gtsf2_zero>
80007e5a:	00064563          	bltz	a2,80007e64 <.L__gtsf2_negative>
80007e5e:	00a5b533          	sltu	a0,a1,a0
80007e62:	8082                	ret

80007e64 <.L__gtsf2_negative>:
80007e64:	00b53533          	sltu	a0,a0,a1
80007e68:	8082                	ret

80007e6a <.L__gtsf2_zero>:
80007e6a:	4501                	li	a0,0
80007e6c:	8082                	ret

Disassembly of section .text.libc.__gtdf2:

80007e6e <__gtdf2>:
80007e6e:	ffe007b7          	lui	a5,0xffe00
80007e72:	00159713          	sll	a4,a1,0x1
80007e76:	02e7e563          	bltu	a5,a4,80007ea0 <.L__gtdf2_not_greater>
80007e7a:	00169713          	sll	a4,a3,0x1
80007e7e:	02e7e163          	bltu	a5,a4,80007ea0 <.L__gtdf2_not_greater>
80007e82:	00d5e733          	or	a4,a1,a3
80007e86:	00171793          	sll	a5,a4,0x1
80007e8a:	8fc9                	or	a5,a5,a0
80007e8c:	8fd1                	or	a5,a5,a2
80007e8e:	cb89                	beqz	a5,80007ea0 <.L__gtdf2_not_greater>
80007e90:	00074a63          	bltz	a4,80007ea4 <.L__gtdf2_negative>
80007e94:	00b6ee63          	bltu	a3,a1,80007eb0 <.L__gtdf2_greater>
80007e98:	00d59463          	bne	a1,a3,80007ea0 <.L__gtdf2_not_greater>
80007e9c:	00a66a63          	bltu	a2,a0,80007eb0 <.L__gtdf2_greater>

80007ea0 <.L__gtdf2_not_greater>:
80007ea0:	4501                	li	a0,0
80007ea2:	8082                	ret

80007ea4 <.L__gtdf2_negative>:
80007ea4:	00d5e663          	bltu	a1,a3,80007eb0 <.L__gtdf2_greater>
80007ea8:	feb69ce3          	bne	a3,a1,80007ea0 <.L__gtdf2_not_greater>
80007eac:	fec57ae3          	bgeu	a0,a2,80007ea0 <.L__gtdf2_not_greater>

80007eb0 <.L__gtdf2_greater>:
80007eb0:	4505                	li	a0,1
80007eb2:	8082                	ret

Disassembly of section .text.libc.__gesf2:

80007eb4 <__gesf2>:
80007eb4:	ff000637          	lui	a2,0xff000
80007eb8:	00151693          	sll	a3,a0,0x1
80007ebc:	02d66763          	bltu	a2,a3,80007eea <.L__gesf2_nan>
80007ec0:	00159693          	sll	a3,a1,0x1
80007ec4:	02d66363          	bltu	a2,a3,80007eea <.L__gesf2_nan>
80007ec8:	00b56633          	or	a2,a0,a1
80007ecc:	00161693          	sll	a3,a2,0x1
80007ed0:	ce99                	beqz	a3,80007eee <.L__gesf2_zero>
80007ed2:	00064763          	bltz	a2,80007ee0 <.L__gesf2_negative>
80007ed6:	00b53533          	sltu	a0,a0,a1
80007eda:	40a00533          	neg	a0,a0
80007ede:	8082                	ret

80007ee0 <.L__gesf2_negative>:
80007ee0:	00a5b533          	sltu	a0,a1,a0
80007ee4:	40a00533          	neg	a0,a0
80007ee8:	8082                	ret

80007eea <.L__gesf2_nan>:
80007eea:	557d                	li	a0,-1
80007eec:	8082                	ret

80007eee <.L__gesf2_zero>:
80007eee:	4501                	li	a0,0
80007ef0:	8082                	ret

Disassembly of section .text.libc.__gedf2:

80007ef2 <__gedf2>:
80007ef2:	ffe007b7          	lui	a5,0xffe00
80007ef6:	00159713          	sll	a4,a1,0x1
80007efa:	02e7e563          	bltu	a5,a4,80007f24 <.L__gedf2_not_greater_equal>
80007efe:	00169713          	sll	a4,a3,0x1
80007f02:	02e7e163          	bltu	a5,a4,80007f24 <.L__gedf2_not_greater_equal>
80007f06:	00d5e733          	or	a4,a1,a3
80007f0a:	00171793          	sll	a5,a4,0x1
80007f0e:	8fc9                	or	a5,a5,a0
80007f10:	8fd1                	or	a5,a5,a2
80007f12:	c38d                	beqz	a5,80007f34 <.L__gedf2_greater_equal>
80007f14:	00074a63          	bltz	a4,80007f28 <.L__gedf2_negative>
80007f18:	00b6ee63          	bltu	a3,a1,80007f34 <.L__gedf2_greater_equal>
80007f1c:	00d59463          	bne	a1,a3,80007f24 <.L__gedf2_not_greater_equal>
80007f20:	00c57a63          	bgeu	a0,a2,80007f34 <.L__gedf2_greater_equal>

80007f24 <.L__gedf2_not_greater_equal>:
80007f24:	557d                	li	a0,-1
80007f26:	8082                	ret

80007f28 <.L__gedf2_negative>:
80007f28:	00d5e663          	bltu	a1,a3,80007f34 <.L__gedf2_greater_equal>
80007f2c:	feb69ce3          	bne	a3,a1,80007f24 <.L__gedf2_not_greater_equal>
80007f30:	fea66ae3          	bltu	a2,a0,80007f24 <.L__gedf2_not_greater_equal>

80007f34 <.L__gedf2_greater_equal>:
80007f34:	4505                	li	a0,1
80007f36:	8082                	ret

Disassembly of section .text.libc.__fixunssfsi:

80007f38 <__fixunssfsi>:
80007f38:	02a05763          	blez	a0,80007f66 <.L__fixunssfsi_zero_result>
80007f3c:	00151593          	sll	a1,a0,0x1
80007f40:	81e1                	srl	a1,a1,0x18
80007f42:	f8158593          	add	a1,a1,-127
80007f46:	0205c063          	bltz	a1,80007f66 <.L__fixunssfsi_zero_result>
80007f4a:	40b005b3          	neg	a1,a1
80007f4e:	05fd                	add	a1,a1,31
80007f50:	0005c963          	bltz	a1,80007f62 <.L__fixunssfsi_max_result>
80007f54:	0522                	sll	a0,a0,0x8
80007f56:	800006b7          	lui	a3,0x80000
80007f5a:	8d55                	or	a0,a0,a3
80007f5c:	00b55533          	srl	a0,a0,a1
80007f60:	8082                	ret

80007f62 <.L__fixunssfsi_max_result>:
80007f62:	557d                	li	a0,-1
80007f64:	8082                	ret

80007f66 <.L__fixunssfsi_zero_result>:
80007f66:	4501                	li	a0,0
80007f68:	8082                	ret

Disassembly of section .text.libc.__fixunsdfsi:

80007f6a <__fixunsdfsi>:
80007f6a:	0205c563          	bltz	a1,80007f94 <.L__fixunsdfsi_zero_result>
80007f6e:	0145d613          	srl	a2,a1,0x14
80007f72:	c0160613          	add	a2,a2,-1023 # fefffc01 <__APB_SRAM_segment_end__+0xaf0dc01>
80007f76:	00064f63          	bltz	a2,80007f94 <.L__fixunsdfsi_zero_result>
80007f7a:	477d                	li	a4,31
80007f7c:	8f11                	sub	a4,a4,a2
80007f7e:	00074d63          	bltz	a4,80007f98 <.L__fixunsdfsi_overflow_result>
80007f82:	8155                	srl	a0,a0,0x15
80007f84:	05ae                	sll	a1,a1,0xb
80007f86:	8d4d                	or	a0,a0,a1
80007f88:	800006b7          	lui	a3,0x80000
80007f8c:	8d55                	or	a0,a0,a3
80007f8e:	00e55533          	srl	a0,a0,a4
80007f92:	8082                	ret

80007f94 <.L__fixunsdfsi_zero_result>:
80007f94:	4501                	li	a0,0
80007f96:	8082                	ret

80007f98 <.L__fixunsdfsi_overflow_result>:
80007f98:	557d                	li	a0,-1
80007f9a:	8082                	ret

Disassembly of section .text.libc.__floatsisf:

80007f9c <__floatsisf>:
80007f9c:	01f55613          	srl	a2,a0,0x1f
80007fa0:	0622                	sll	a2,a2,0x8
80007fa2:	09d60613          	add	a2,a2,157
80007fa6:	cd29                	beqz	a0,80008000 <.L__floatsisf_done>
80007fa8:	41f55693          	sra	a3,a0,0x1f
80007fac:	00d545b3          	xor	a1,a0,a3
80007fb0:	8d95                	sub	a1,a1,a3
80007fb2:	0105d693          	srl	a3,a1,0x10
80007fb6:	e299                	bnez	a3,80007fbc <.L1^B2>
80007fb8:	05c2                	sll	a1,a1,0x10
80007fba:	1641                	add	a2,a2,-16

80007fbc <.L1^B2>:
80007fbc:	0185d693          	srl	a3,a1,0x18
80007fc0:	e299                	bnez	a3,80007fc6 <.L2^B2>
80007fc2:	05a2                	sll	a1,a1,0x8
80007fc4:	1661                	add	a2,a2,-8

80007fc6 <.L2^B2>:
80007fc6:	01c5d693          	srl	a3,a1,0x1c
80007fca:	e299                	bnez	a3,80007fd0 <.L3^B2>
80007fcc:	0592                	sll	a1,a1,0x4
80007fce:	1671                	add	a2,a2,-4

80007fd0 <.L3^B2>:
80007fd0:	01e5d693          	srl	a3,a1,0x1e
80007fd4:	e299                	bnez	a3,80007fda <.L4^B2>
80007fd6:	058a                	sll	a1,a1,0x2
80007fd8:	1679                	add	a2,a2,-2

80007fda <.L4^B2>:
80007fda:	0005c463          	bltz	a1,80007fe2 <.L5^B2>
80007fde:	0586                	sll	a1,a1,0x1
80007fe0:	167d                	add	a2,a2,-1

80007fe2 <.L5^B2>:
80007fe2:	065e                	sll	a2,a2,0x17
80007fe4:	0085d513          	srl	a0,a1,0x8
80007fe8:	05de                	sll	a1,a1,0x17
80007fea:	0005a333          	sltz	t1,a1
80007fee:	95ae                	add	a1,a1,a1
80007ff0:	959a                	add	a1,a1,t1
80007ff2:	0005d663          	bgez	a1,80007ffe <.L__floatsisf_round_down>
80007ff6:	95ae                	add	a1,a1,a1
80007ff8:	00b035b3          	snez	a1,a1
80007ffc:	952e                	add	a0,a0,a1

80007ffe <.L__floatsisf_round_down>:
80007ffe:	9532                	add	a0,a0,a2

80008000 <.L__floatsisf_done>:
80008000:	8082                	ret

Disassembly of section .text.libc.__floatsidf:

80008002 <__floatsidf>:
80008002:	41f55593          	sra	a1,a0,0x1f
80008006:	c521                	beqz	a0,8000804e <.L__floatsidf_zero>
80008008:	8d2d                	xor	a0,a0,a1
8000800a:	8d0d                	sub	a0,a0,a1
8000800c:	41d00613          	li	a2,1053
80008010:	01055693          	srl	a3,a0,0x10
80008014:	e299                	bnez	a3,8000801a <.L1^B3>
80008016:	0542                	sll	a0,a0,0x10
80008018:	1641                	add	a2,a2,-16

8000801a <.L1^B3>:
8000801a:	01855693          	srl	a3,a0,0x18
8000801e:	e299                	bnez	a3,80008024 <.L2^B3>
80008020:	0522                	sll	a0,a0,0x8
80008022:	1661                	add	a2,a2,-8

80008024 <.L2^B3>:
80008024:	01c55693          	srl	a3,a0,0x1c
80008028:	e299                	bnez	a3,8000802e <.L3^B3>
8000802a:	0512                	sll	a0,a0,0x4
8000802c:	1671                	add	a2,a2,-4

8000802e <.L3^B3>:
8000802e:	01e55693          	srl	a3,a0,0x1e
80008032:	e299                	bnez	a3,80008038 <.L4^B3>
80008034:	050a                	sll	a0,a0,0x2
80008036:	1679                	add	a2,a2,-2

80008038 <.L4^B3>:
80008038:	00054463          	bltz	a0,80008040 <.L5^B3>
8000803c:	0506                	sll	a0,a0,0x1
8000803e:	167d                	add	a2,a2,-1

80008040 <.L5^B3>:
80008040:	0652                	sll	a2,a2,0x14
80008042:	00b55693          	srl	a3,a0,0xb
80008046:	0556                	sll	a0,a0,0x15
80008048:	05fe                	sll	a1,a1,0x1f
8000804a:	9636                	add	a2,a2,a3
8000804c:	95b2                	add	a1,a1,a2

8000804e <.L__floatsidf_zero>:
8000804e:	8082                	ret

Disassembly of section .text.libc.__floatunsisf:

80008050 <__floatunsisf>:
80008050:	c931                	beqz	a0,800080a4 <.L__floatunsisf_done>
80008052:	09d00613          	li	a2,157
80008056:	01055693          	srl	a3,a0,0x10
8000805a:	e299                	bnez	a3,80008060 <.L1^B8>
8000805c:	0542                	sll	a0,a0,0x10
8000805e:	1641                	add	a2,a2,-16

80008060 <.L1^B8>:
80008060:	01855693          	srl	a3,a0,0x18
80008064:	e299                	bnez	a3,8000806a <.L2^B8>
80008066:	0522                	sll	a0,a0,0x8
80008068:	1661                	add	a2,a2,-8

8000806a <.L2^B8>:
8000806a:	01c55693          	srl	a3,a0,0x1c
8000806e:	e299                	bnez	a3,80008074 <.L3^B6>
80008070:	0512                	sll	a0,a0,0x4
80008072:	1671                	add	a2,a2,-4

80008074 <.L3^B6>:
80008074:	01e55693          	srl	a3,a0,0x1e
80008078:	e299                	bnez	a3,8000807e <.L4^B8>
8000807a:	050a                	sll	a0,a0,0x2
8000807c:	1679                	add	a2,a2,-2

8000807e <.L4^B8>:
8000807e:	00054463          	bltz	a0,80008086 <.L5^B6>
80008082:	0506                	sll	a0,a0,0x1
80008084:	167d                	add	a2,a2,-1

80008086 <.L5^B6>:
80008086:	065e                	sll	a2,a2,0x17
80008088:	01751593          	sll	a1,a0,0x17
8000808c:	8121                	srl	a0,a0,0x8
8000808e:	0005a333          	sltz	t1,a1
80008092:	95ae                	add	a1,a1,a1
80008094:	959a                	add	a1,a1,t1
80008096:	0005d663          	bgez	a1,800080a2 <.L__floatunsisf_round_down>
8000809a:	95ae                	add	a1,a1,a1
8000809c:	00b035b3          	snez	a1,a1
800080a0:	952e                	add	a0,a0,a1

800080a2 <.L__floatunsisf_round_down>:
800080a2:	9532                	add	a0,a0,a2

800080a4 <.L__floatunsisf_done>:
800080a4:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

800080a6 <__floatundisf>:
800080a6:	c5bd                	beqz	a1,80008114 <.L__floatundisf_high_word_zero>
800080a8:	4701                	li	a4,0
800080aa:	0105d693          	srl	a3,a1,0x10
800080ae:	e299                	bnez	a3,800080b4 <.L8^B3>
800080b0:	0741                	add	a4,a4,16
800080b2:	05c2                	sll	a1,a1,0x10

800080b4 <.L8^B3>:
800080b4:	0185d693          	srl	a3,a1,0x18
800080b8:	e299                	bnez	a3,800080be <.L4^B10>
800080ba:	0721                	add	a4,a4,8
800080bc:	05a2                	sll	a1,a1,0x8

800080be <.L4^B10>:
800080be:	01c5d693          	srl	a3,a1,0x1c
800080c2:	e299                	bnez	a3,800080c8 <.L2^B10>
800080c4:	0711                	add	a4,a4,4
800080c6:	0592                	sll	a1,a1,0x4

800080c8 <.L2^B10>:
800080c8:	01e5d693          	srl	a3,a1,0x1e
800080cc:	e299                	bnez	a3,800080d2 <.L1^B10>
800080ce:	0709                	add	a4,a4,2
800080d0:	058a                	sll	a1,a1,0x2

800080d2 <.L1^B10>:
800080d2:	0005c463          	bltz	a1,800080da <.L0^B3>
800080d6:	0705                	add	a4,a4,1
800080d8:	0586                	sll	a1,a1,0x1

800080da <.L0^B3>:
800080da:	fff74613          	not	a2,a4
800080de:	00c556b3          	srl	a3,a0,a2
800080e2:	8285                	srl	a3,a3,0x1
800080e4:	8dd5                	or	a1,a1,a3
800080e6:	00e51533          	sll	a0,a0,a4
800080ea:	0be60613          	add	a2,a2,190
800080ee:	00a03533          	snez	a0,a0
800080f2:	8dc9                	or	a1,a1,a0

800080f4 <.L__floatundisf_round_and_pack>:
800080f4:	065e                	sll	a2,a2,0x17
800080f6:	0085d513          	srl	a0,a1,0x8
800080fa:	05de                	sll	a1,a1,0x17
800080fc:	0005a333          	sltz	t1,a1
80008100:	95ae                	add	a1,a1,a1
80008102:	959a                	add	a1,a1,t1
80008104:	0005d663          	bgez	a1,80008110 <.L__floatundisf_round_down>
80008108:	95ae                	add	a1,a1,a1
8000810a:	00b035b3          	snez	a1,a1
8000810e:	952e                	add	a0,a0,a1

80008110 <.L__floatundisf_round_down>:
80008110:	9532                	add	a0,a0,a2

80008112 <.L__floatundisf_done>:
80008112:	8082                	ret

80008114 <.L__floatundisf_high_word_zero>:
80008114:	dd7d                	beqz	a0,80008112 <.L__floatundisf_done>
80008116:	09d00613          	li	a2,157
8000811a:	01055693          	srl	a3,a0,0x10
8000811e:	e299                	bnez	a3,80008124 <.L1^B11>
80008120:	0542                	sll	a0,a0,0x10
80008122:	1641                	add	a2,a2,-16

80008124 <.L1^B11>:
80008124:	01855693          	srl	a3,a0,0x18
80008128:	e299                	bnez	a3,8000812e <.L2^B11>
8000812a:	0522                	sll	a0,a0,0x8
8000812c:	1661                	add	a2,a2,-8

8000812e <.L2^B11>:
8000812e:	01c55693          	srl	a3,a0,0x1c
80008132:	e299                	bnez	a3,80008138 <.L3^B8>
80008134:	0512                	sll	a0,a0,0x4
80008136:	1671                	add	a2,a2,-4

80008138 <.L3^B8>:
80008138:	01e55693          	srl	a3,a0,0x1e
8000813c:	e299                	bnez	a3,80008142 <.L4^B11>
8000813e:	050a                	sll	a0,a0,0x2
80008140:	1679                	add	a2,a2,-2

80008142 <.L4^B11>:
80008142:	00054463          	bltz	a0,8000814a <.L5^B8>
80008146:	0506                	sll	a0,a0,0x1
80008148:	167d                	add	a2,a2,-1

8000814a <.L5^B8>:
8000814a:	85aa                	mv	a1,a0
8000814c:	4501                	li	a0,0
8000814e:	b75d                	j	800080f4 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

80008150 <__truncdfsf2>:
80008150:	00159693          	sll	a3,a1,0x1
80008154:	82d5                	srl	a3,a3,0x15
80008156:	7ff00613          	li	a2,2047
8000815a:	04c68663          	beq	a3,a2,800081a6 <.L__truncdfsf2_inf_nan>
8000815e:	c8068693          	add	a3,a3,-896 # 7ffffc80 <_extram_size+0x7dfffc80>
80008162:	02d05e63          	blez	a3,8000819e <.L__truncdfsf2_underflow>
80008166:	0ff00613          	li	a2,255
8000816a:	04c6f263          	bgeu	a3,a2,800081ae <.L__truncdfsf2_inf>
8000816e:	06de                	sll	a3,a3,0x17
80008170:	01f5d613          	srl	a2,a1,0x1f
80008174:	067e                	sll	a2,a2,0x1f
80008176:	8ed1                	or	a3,a3,a2
80008178:	05b2                	sll	a1,a1,0xc
8000817a:	01455613          	srl	a2,a0,0x14
8000817e:	8dd1                	or	a1,a1,a2
80008180:	81a5                	srl	a1,a1,0x9
80008182:	00251613          	sll	a2,a0,0x2
80008186:	00062733          	sltz	a4,a2
8000818a:	9632                	add	a2,a2,a2
8000818c:	000627b3          	sltz	a5,a2
80008190:	9632                	add	a2,a2,a2
80008192:	963a                	add	a2,a2,a4
80008194:	c211                	beqz	a2,80008198 <.L__truncdfsf2_no_round_tie>
80008196:	95be                	add	a1,a1,a5

80008198 <.L__truncdfsf2_no_round_tie>:
80008198:	00d58533          	add	a0,a1,a3
8000819c:	8082                	ret

8000819e <.L__truncdfsf2_underflow>:
8000819e:	01f5d513          	srl	a0,a1,0x1f
800081a2:	057e                	sll	a0,a0,0x1f
800081a4:	8082                	ret

800081a6 <.L__truncdfsf2_inf_nan>:
800081a6:	00c59693          	sll	a3,a1,0xc
800081aa:	8ec9                	or	a3,a3,a0
800081ac:	ea81                	bnez	a3,800081bc <.L__truncdfsf2_nan>

800081ae <.L__truncdfsf2_inf>:
800081ae:	81fd                	srl	a1,a1,0x1f
800081b0:	05fe                	sll	a1,a1,0x1f
800081b2:	7f800537          	lui	a0,0x7f800
800081b6:	8d4d                	or	a0,a0,a1
800081b8:	4581                	li	a1,0
800081ba:	8082                	ret

800081bc <.L__truncdfsf2_nan>:
800081bc:	800006b7          	lui	a3,0x80000
800081c0:	00d5f633          	and	a2,a1,a3
800081c4:	058e                	sll	a1,a1,0x3
800081c6:	8175                	srl	a0,a0,0x1d
800081c8:	8d4d                	or	a0,a0,a1
800081ca:	0506                	sll	a0,a0,0x1
800081cc:	8105                	srl	a0,a0,0x1
800081ce:	8d51                	or	a0,a0,a2
800081d0:	82a5                	srl	a3,a3,0x9
800081d2:	8d55                	or	a0,a0,a3
800081d4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

800081d6 <__SEGGER_RTL_ldouble_to_double>:
800081d6:	4158                	lw	a4,4(a0)
800081d8:	451c                	lw	a5,8(a0)
800081da:	4554                	lw	a3,12(a0)
800081dc:	1141                	add	sp,sp,-16
800081de:	c23a                	sw	a4,4(sp)
800081e0:	c43e                	sw	a5,8(sp)
800081e2:	7771                	lui	a4,0xffffc
800081e4:	00169793          	sll	a5,a3,0x1
800081e8:	83c5                	srl	a5,a5,0x11
800081ea:	40070713          	add	a4,a4,1024 # ffffc400 <__APB_SRAM_segment_end__+0xbf0a400>
800081ee:	c636                	sw	a3,12(sp)
800081f0:	97ba                	add	a5,a5,a4
800081f2:	00f04a63          	bgtz	a5,80008206 <.L27>
800081f6:	800007b7          	lui	a5,0x80000
800081fa:	4701                	li	a4,0
800081fc:	8ff5                	and	a5,a5,a3

800081fe <.L28>:
800081fe:	853a                	mv	a0,a4
80008200:	85be                	mv	a1,a5
80008202:	0141                	add	sp,sp,16
80008204:	8082                	ret

80008206 <.L27>:
80008206:	6711                	lui	a4,0x4
80008208:	3ff70713          	add	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
8000820c:	00e78c63          	beq	a5,a4,80008224 <.L29>
80008210:	7ff00713          	li	a4,2047
80008214:	00f75a63          	bge	a4,a5,80008228 <.L30>
80008218:	4781                	li	a5,0
8000821a:	4801                	li	a6,0
8000821c:	c43e                	sw	a5,8(sp)
8000821e:	c642                	sw	a6,12(sp)
80008220:	c03e                	sw	a5,0(sp)
80008222:	c242                	sw	a6,4(sp)

80008224 <.L29>:
80008224:	7ff00793          	li	a5,2047

80008228 <.L30>:
80008228:	45a2                	lw	a1,8(sp)
8000822a:	4732                	lw	a4,12(sp)
8000822c:	80000637          	lui	a2,0x80000
80008230:	01c5d513          	srl	a0,a1,0x1c
80008234:	8e79                	and	a2,a2,a4
80008236:	0712                	sll	a4,a4,0x4
80008238:	4692                	lw	a3,4(sp)
8000823a:	8f49                	or	a4,a4,a0
8000823c:	0732                	sll	a4,a4,0xc
8000823e:	8331                	srl	a4,a4,0xc
80008240:	8e59                	or	a2,a2,a4
80008242:	82f1                	srl	a3,a3,0x1c
80008244:	0592                	sll	a1,a1,0x4
80008246:	07d2                	sll	a5,a5,0x14
80008248:	00b6e733          	or	a4,a3,a1
8000824c:	8fd1                	or	a5,a5,a2
8000824e:	bf45                	j	800081fe <.L28>

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

80008250 <__SEGGER_RTL_float32_isnan>:
80008250:	ff0007b7          	lui	a5,0xff000
80008254:	0785                	add	a5,a5,1 # ff000001 <__APB_SRAM_segment_end__+0xaf0e001>
80008256:	0506                	sll	a0,a0,0x1
80008258:	00f53533          	sltu	a0,a0,a5
8000825c:	00154513          	xor	a0,a0,1
80008260:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

80008262 <__SEGGER_RTL_float32_isinf>:
80008262:	010007b7          	lui	a5,0x1000
80008266:	0506                	sll	a0,a0,0x1
80008268:	953e                	add	a0,a0,a5
8000826a:	00153513          	seqz	a0,a0
8000826e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

80008270 <__SEGGER_RTL_float32_isnormal>:
80008270:	ff0007b7          	lui	a5,0xff000
80008274:	0506                	sll	a0,a0,0x1
80008276:	953e                	add	a0,a0,a5
80008278:	fe0007b7          	lui	a5,0xfe000
8000827c:	00f53533          	sltu	a0,a0,a5
80008280:	8082                	ret

Disassembly of section .text.libc.floorf:

80008282 <floorf>:
80008282:	00151693          	sll	a3,a0,0x1
80008286:	82e1                	srl	a3,a3,0x18
80008288:	01755793          	srl	a5,a0,0x17
8000828c:	16fd                	add	a3,a3,-1 # 7fffffff <_extram_size+0x7dffffff>
8000828e:	0fd00613          	li	a2,253
80008292:	872a                	mv	a4,a0
80008294:	0ff7f793          	zext.b	a5,a5
80008298:	00d67963          	bgeu	a2,a3,800082aa <.L1240>
8000829c:	e789                	bnez	a5,800082a6 <.L1241>
8000829e:	800007b7          	lui	a5,0x80000
800082a2:	00f57733          	and	a4,a0,a5

800082a6 <.L1241>:
800082a6:	853a                	mv	a0,a4
800082a8:	8082                	ret

800082aa <.L1240>:
800082aa:	f8178793          	add	a5,a5,-127 # 7fffff81 <_extram_size+0x7dffff81>
800082ae:	0007db63          	bgez	a5,800082c4 <.L1243>
800082b2:	00000513          	li	a0,0
800082b6:	02075a63          	bgez	a4,800082ea <.L1242>
800082ba:	800047b7          	lui	a5,0x80004
800082be:	06c7a503          	lw	a0,108(a5) # 8000406c <.Lmerged_single+0x18>
800082c2:	8082                	ret

800082c4 <.L1243>:
800082c4:	46d9                	li	a3,22
800082c6:	02f6c263          	blt	a3,a5,800082ea <.L1242>
800082ca:	008006b7          	lui	a3,0x800
800082ce:	fff68613          	add	a2,a3,-1 # 7fffff <__DLM_segment_end__+0x73ffff>
800082d2:	00f65633          	srl	a2,a2,a5
800082d6:	fff64513          	not	a0,a2
800082da:	8d79                	and	a0,a0,a4
800082dc:	8f71                	and	a4,a4,a2
800082de:	c711                	beqz	a4,800082ea <.L1242>
800082e0:	00055563          	bgez	a0,800082ea <.L1242>
800082e4:	00f6d6b3          	srl	a3,a3,a5
800082e8:	9536                	add	a0,a0,a3

800082ea <.L1242>:
800082ea:	8082                	ret

Disassembly of section .text.libc.__ashldi3:

800082ec <__ashldi3>:
800082ec:	02067793          	and	a5,a2,32
800082f0:	ef89                	bnez	a5,8000830a <.L__ashldi3LongShift>
800082f2:	00155793          	srl	a5,a0,0x1
800082f6:	fff64713          	not	a4,a2
800082fa:	00e7d7b3          	srl	a5,a5,a4
800082fe:	00c595b3          	sll	a1,a1,a2
80008302:	8ddd                	or	a1,a1,a5
80008304:	00c51533          	sll	a0,a0,a2
80008308:	8082                	ret

8000830a <.L__ashldi3LongShift>:
8000830a:	00c515b3          	sll	a1,a0,a2
8000830e:	4501                	li	a0,0
80008310:	8082                	ret

Disassembly of section .text.libc.__udivdi3:

80008312 <__udivdi3>:
80008312:	1101                	add	sp,sp,-32
80008314:	cc22                	sw	s0,24(sp)
80008316:	ca26                	sw	s1,20(sp)
80008318:	c84a                	sw	s2,16(sp)
8000831a:	c64e                	sw	s3,12(sp)
8000831c:	ce06                	sw	ra,28(sp)
8000831e:	c452                	sw	s4,8(sp)
80008320:	c256                	sw	s5,4(sp)
80008322:	c05a                	sw	s6,0(sp)
80008324:	842a                	mv	s0,a0
80008326:	892e                	mv	s2,a1
80008328:	89b2                	mv	s3,a2
8000832a:	84b6                	mv	s1,a3
8000832c:	2e069263          	bnez	a3,80008610 <.L47>
80008330:	ed99                	bnez	a1,8000834e <.L48>
80008332:	02c55433          	divu	s0,a0,a2

80008336 <.L49>:
80008336:	40f2                	lw	ra,28(sp)
80008338:	8522                	mv	a0,s0
8000833a:	4462                	lw	s0,24(sp)
8000833c:	44d2                	lw	s1,20(sp)
8000833e:	49b2                	lw	s3,12(sp)
80008340:	4a22                	lw	s4,8(sp)
80008342:	4a92                	lw	s5,4(sp)
80008344:	4b02                	lw	s6,0(sp)
80008346:	85ca                	mv	a1,s2
80008348:	4942                	lw	s2,16(sp)
8000834a:	6105                	add	sp,sp,32
8000834c:	8082                	ret

8000834e <.L48>:
8000834e:	010007b7          	lui	a5,0x1000
80008352:	12f67863          	bgeu	a2,a5,80008482 <.L50>
80008356:	4791                	li	a5,4
80008358:	08c7e763          	bltu	a5,a2,800083e6 <.L52>
8000835c:	470d                	li	a4,3
8000835e:	02e60263          	beq	a2,a4,80008382 <.L54>
80008362:	06f60a63          	beq	a2,a5,800083d6 <.L55>
80008366:	4785                	li	a5,1
80008368:	fcf607e3          	beq	a2,a5,80008336 <.L49>
8000836c:	4789                	li	a5,2
8000836e:	3cf61063          	bne	a2,a5,8000872e <.L88>
80008372:	01f59793          	sll	a5,a1,0x1f
80008376:	00155413          	srl	s0,a0,0x1
8000837a:	8c5d                	or	s0,s0,a5
8000837c:	0015d913          	srl	s2,a1,0x1
80008380:	bf5d                	j	80008336 <.L49>

80008382 <.L54>:
80008382:	555557b7          	lui	a5,0x55555
80008386:	55578793          	add	a5,a5,1365 # 55555555 <_extram_size+0x53555555>
8000838a:	02b7b6b3          	mulhu	a3,a5,a1
8000838e:	02a7b633          	mulhu	a2,a5,a0
80008392:	02a78733          	mul	a4,a5,a0
80008396:	02b787b3          	mul	a5,a5,a1
8000839a:	97b2                	add	a5,a5,a2
8000839c:	00c7b633          	sltu	a2,a5,a2
800083a0:	9636                	add	a2,a2,a3
800083a2:	00f706b3          	add	a3,a4,a5
800083a6:	00e6b733          	sltu	a4,a3,a4
800083aa:	9732                	add	a4,a4,a2
800083ac:	97ba                	add	a5,a5,a4
800083ae:	00e7b5b3          	sltu	a1,a5,a4
800083b2:	9736                	add	a4,a4,a3
800083b4:	00d736b3          	sltu	a3,a4,a3
800083b8:	0705                	add	a4,a4,1
800083ba:	97b6                	add	a5,a5,a3
800083bc:	00173713          	seqz	a4,a4
800083c0:	00d7b6b3          	sltu	a3,a5,a3
800083c4:	962e                	add	a2,a2,a1
800083c6:	97ba                	add	a5,a5,a4
800083c8:	00c68933          	add	s2,a3,a2
800083cc:	00e7b733          	sltu	a4,a5,a4
800083d0:	843e                	mv	s0,a5
800083d2:	993a                	add	s2,s2,a4
800083d4:	b78d                	j	80008336 <.L49>

800083d6 <.L55>:
800083d6:	01e59793          	sll	a5,a1,0x1e
800083da:	00255413          	srl	s0,a0,0x2
800083de:	8c5d                	or	s0,s0,a5
800083e0:	0025d913          	srl	s2,a1,0x2
800083e4:	bf89                	j	80008336 <.L49>

800083e6 <.L52>:
800083e6:	67c1                	lui	a5,0x10
800083e8:	02c5d6b3          	divu	a3,a1,a2
800083ec:	01055713          	srl	a4,a0,0x10
800083f0:	02f67a63          	bgeu	a2,a5,80008424 <.L62>
800083f4:	01051413          	sll	s0,a0,0x10
800083f8:	8041                	srl	s0,s0,0x10
800083fa:	02c687b3          	mul	a5,a3,a2
800083fe:	40f587b3          	sub	a5,a1,a5
80008402:	07c2                	sll	a5,a5,0x10
80008404:	97ba                	add	a5,a5,a4
80008406:	02c7d933          	divu	s2,a5,a2
8000840a:	02c90733          	mul	a4,s2,a2
8000840e:	0942                	sll	s2,s2,0x10
80008410:	8f99                	sub	a5,a5,a4
80008412:	07c2                	sll	a5,a5,0x10
80008414:	943e                	add	s0,s0,a5
80008416:	02c45433          	divu	s0,s0,a2
8000841a:	944a                	add	s0,s0,s2
8000841c:	01243933          	sltu	s2,s0,s2
80008420:	9936                	add	s2,s2,a3
80008422:	bf11                	j	80008336 <.L49>

80008424 <.L62>:
80008424:	02c687b3          	mul	a5,a3,a2
80008428:	01855613          	srl	a2,a0,0x18
8000842c:	0ff77713          	zext.b	a4,a4
80008430:	0ff47413          	zext.b	s0,s0
80008434:	8936                	mv	s2,a3
80008436:	40f587b3          	sub	a5,a1,a5
8000843a:	07a2                	sll	a5,a5,0x8
8000843c:	963e                	add	a2,a2,a5
8000843e:	033657b3          	divu	a5,a2,s3
80008442:	033785b3          	mul	a1,a5,s3
80008446:	07a2                	sll	a5,a5,0x8
80008448:	8e0d                	sub	a2,a2,a1
8000844a:	0622                	sll	a2,a2,0x8
8000844c:	9732                	add	a4,a4,a2
8000844e:	033755b3          	divu	a1,a4,s3
80008452:	97ae                	add	a5,a5,a1
80008454:	07a2                	sll	a5,a5,0x8
80008456:	03358633          	mul	a2,a1,s3
8000845a:	8f11                	sub	a4,a4,a2
8000845c:	00855613          	srl	a2,a0,0x8
80008460:	0ff67613          	zext.b	a2,a2
80008464:	0722                	sll	a4,a4,0x8
80008466:	9732                	add	a4,a4,a2
80008468:	03375633          	divu	a2,a4,s3
8000846c:	97b2                	add	a5,a5,a2
8000846e:	07a2                	sll	a5,a5,0x8
80008470:	03360533          	mul	a0,a2,s3
80008474:	8f09                	sub	a4,a4,a0
80008476:	0722                	sll	a4,a4,0x8
80008478:	943a                	add	s0,s0,a4
8000847a:	03345433          	divu	s0,s0,s3
8000847e:	943e                	add	s0,s0,a5
80008480:	bd5d                	j	80008336 <.L49>

80008482 <.L50>:
80008482:	80004ab7          	lui	s5,0x80004
80008486:	a20a8a93          	add	s5,s5,-1504 # 80003a20 <__SEGGER_RTL_Moeller_inverse_lut>
8000848a:	0cc5f063          	bgeu	a1,a2,8000854a <.L64>
8000848e:	10000737          	lui	a4,0x10000
80008492:	87b2                	mv	a5,a2
80008494:	00e67563          	bgeu	a2,a4,8000849e <.L65>
80008498:	00461793          	sll	a5,a2,0x4
8000849c:	4491                	li	s1,4

8000849e <.L65>:
8000849e:	40000737          	lui	a4,0x40000
800084a2:	00e7f463          	bgeu	a5,a4,800084aa <.L66>
800084a6:	0489                	add	s1,s1,2
800084a8:	078a                	sll	a5,a5,0x2

800084aa <.L66>:
800084aa:	0007c363          	bltz	a5,800084b0 <.L67>
800084ae:	0485                	add	s1,s1,1

800084b0 <.L67>:
800084b0:	8626                	mv	a2,s1
800084b2:	8522                	mv	a0,s0
800084b4:	85ca                	mv	a1,s2
800084b6:	3d1d                	jal	800082ec <__ashldi3>
800084b8:	009994b3          	sll	s1,s3,s1
800084bc:	0164d793          	srl	a5,s1,0x16
800084c0:	e0078793          	add	a5,a5,-512 # fe00 <__XPI0_segment_used_size__+0x2a48>
800084c4:	0786                	sll	a5,a5,0x1
800084c6:	97d6                	add	a5,a5,s5
800084c8:	0007d783          	lhu	a5,0(a5)
800084cc:	00b4d813          	srl	a6,s1,0xb
800084d0:	0014f713          	and	a4,s1,1
800084d4:	02f78633          	mul	a2,a5,a5
800084d8:	0792                	sll	a5,a5,0x4
800084da:	0014d693          	srl	a3,s1,0x1
800084de:	0805                	add	a6,a6,1
800084e0:	03063633          	mulhu	a2,a2,a6
800084e4:	8f91                	sub	a5,a5,a2
800084e6:	96ba                	add	a3,a3,a4
800084e8:	17fd                	add	a5,a5,-1
800084ea:	c319                	beqz	a4,800084f0 <.L68>
800084ec:	0017d713          	srl	a4,a5,0x1

800084f0 <.L68>:
800084f0:	02f686b3          	mul	a3,a3,a5
800084f4:	8f15                	sub	a4,a4,a3
800084f6:	02e7b733          	mulhu	a4,a5,a4
800084fa:	07be                	sll	a5,a5,0xf
800084fc:	8305                	srl	a4,a4,0x1
800084fe:	97ba                	add	a5,a5,a4
80008500:	8726                	mv	a4,s1
80008502:	029786b3          	mul	a3,a5,s1
80008506:	9736                	add	a4,a4,a3
80008508:	00d736b3          	sltu	a3,a4,a3
8000850c:	8726                	mv	a4,s1
8000850e:	9736                	add	a4,a4,a3
80008510:	0297b6b3          	mulhu	a3,a5,s1
80008514:	9736                	add	a4,a4,a3
80008516:	8f99                	sub	a5,a5,a4
80008518:	02b7b733          	mulhu	a4,a5,a1
8000851c:	02b787b3          	mul	a5,a5,a1
80008520:	00a786b3          	add	a3,a5,a0
80008524:	00f6b7b3          	sltu	a5,a3,a5
80008528:	95be                	add	a1,a1,a5
8000852a:	00b707b3          	add	a5,a4,a1
8000852e:	00178413          	add	s0,a5,1
80008532:	02848733          	mul	a4,s1,s0
80008536:	8d19                	sub	a0,a0,a4
80008538:	00a6f463          	bgeu	a3,a0,80008540 <.L69>
8000853c:	9526                	add	a0,a0,s1
8000853e:	843e                	mv	s0,a5

80008540 <.L69>:
80008540:	00956363          	bltu	a0,s1,80008546 <.L109>
80008544:	0405                	add	s0,s0,1

80008546 <.L109>:
80008546:	4901                	li	s2,0
80008548:	b3fd                	j	80008336 <.L49>

8000854a <.L64>:
8000854a:	02c5da33          	divu	s4,a1,a2
8000854e:	10000737          	lui	a4,0x10000
80008552:	87b2                	mv	a5,a2
80008554:	02ca05b3          	mul	a1,s4,a2
80008558:	40b905b3          	sub	a1,s2,a1
8000855c:	00e67563          	bgeu	a2,a4,80008566 <.L71>
80008560:	00461793          	sll	a5,a2,0x4
80008564:	4491                	li	s1,4

80008566 <.L71>:
80008566:	40000737          	lui	a4,0x40000
8000856a:	00e7f463          	bgeu	a5,a4,80008572 <.L72>
8000856e:	0489                	add	s1,s1,2
80008570:	078a                	sll	a5,a5,0x2

80008572 <.L72>:
80008572:	0007c363          	bltz	a5,80008578 <.L73>
80008576:	0485                	add	s1,s1,1

80008578 <.L73>:
80008578:	8626                	mv	a2,s1
8000857a:	8522                	mv	a0,s0
8000857c:	3b85                	jal	800082ec <__ashldi3>
8000857e:	009994b3          	sll	s1,s3,s1
80008582:	0164d793          	srl	a5,s1,0x16
80008586:	e0078793          	add	a5,a5,-512
8000858a:	0786                	sll	a5,a5,0x1
8000858c:	9abe                	add	s5,s5,a5
8000858e:	000ad783          	lhu	a5,0(s5)
80008592:	00b4d813          	srl	a6,s1,0xb
80008596:	0014f713          	and	a4,s1,1
8000859a:	02f78633          	mul	a2,a5,a5
8000859e:	0792                	sll	a5,a5,0x4
800085a0:	0014d693          	srl	a3,s1,0x1
800085a4:	0805                	add	a6,a6,1
800085a6:	03063633          	mulhu	a2,a2,a6
800085aa:	8f91                	sub	a5,a5,a2
800085ac:	96ba                	add	a3,a3,a4
800085ae:	17fd                	add	a5,a5,-1
800085b0:	c319                	beqz	a4,800085b6 <.L74>
800085b2:	0017d713          	srl	a4,a5,0x1

800085b6 <.L74>:
800085b6:	02f686b3          	mul	a3,a3,a5
800085ba:	8f15                	sub	a4,a4,a3
800085bc:	02e7b733          	mulhu	a4,a5,a4
800085c0:	07be                	sll	a5,a5,0xf
800085c2:	8305                	srl	a4,a4,0x1
800085c4:	97ba                	add	a5,a5,a4
800085c6:	8726                	mv	a4,s1
800085c8:	029786b3          	mul	a3,a5,s1
800085cc:	9736                	add	a4,a4,a3
800085ce:	00d736b3          	sltu	a3,a4,a3
800085d2:	8726                	mv	a4,s1
800085d4:	9736                	add	a4,a4,a3
800085d6:	0297b6b3          	mulhu	a3,a5,s1
800085da:	9736                	add	a4,a4,a3
800085dc:	8f99                	sub	a5,a5,a4
800085de:	02b7b733          	mulhu	a4,a5,a1
800085e2:	02b787b3          	mul	a5,a5,a1
800085e6:	00a786b3          	add	a3,a5,a0
800085ea:	00f6b7b3          	sltu	a5,a3,a5
800085ee:	95be                	add	a1,a1,a5
800085f0:	00b707b3          	add	a5,a4,a1
800085f4:	00178413          	add	s0,a5,1
800085f8:	02848733          	mul	a4,s1,s0
800085fc:	8d19                	sub	a0,a0,a4
800085fe:	00a6f463          	bgeu	a3,a0,80008606 <.L75>
80008602:	9526                	add	a0,a0,s1
80008604:	843e                	mv	s0,a5

80008606 <.L75>:
80008606:	00956363          	bltu	a0,s1,8000860c <.L76>
8000860a:	0405                	add	s0,s0,1

8000860c <.L76>:
8000860c:	8952                	mv	s2,s4
8000860e:	b325                	j	80008336 <.L49>

80008610 <.L47>:
80008610:	67c1                	lui	a5,0x10
80008612:	8ab6                	mv	s5,a3
80008614:	4a01                	li	s4,0
80008616:	00f6f563          	bgeu	a3,a5,80008620 <.L77>
8000861a:	01069493          	sll	s1,a3,0x10
8000861e:	4a41                	li	s4,16

80008620 <.L77>:
80008620:	010007b7          	lui	a5,0x1000
80008624:	00f4f463          	bgeu	s1,a5,8000862c <.L78>
80008628:	0a21                	add	s4,s4,8
8000862a:	04a2                	sll	s1,s1,0x8

8000862c <.L78>:
8000862c:	100007b7          	lui	a5,0x10000
80008630:	00f4f463          	bgeu	s1,a5,80008638 <.L79>
80008634:	0a11                	add	s4,s4,4
80008636:	0492                	sll	s1,s1,0x4

80008638 <.L79>:
80008638:	400007b7          	lui	a5,0x40000
8000863c:	00f4f463          	bgeu	s1,a5,80008644 <.L80>
80008640:	0a09                	add	s4,s4,2
80008642:	048a                	sll	s1,s1,0x2

80008644 <.L80>:
80008644:	0004c363          	bltz	s1,8000864a <.L81>
80008648:	0a05                	add	s4,s4,1

8000864a <.L81>:
8000864a:	01f91793          	sll	a5,s2,0x1f
8000864e:	8652                	mv	a2,s4
80008650:	00145493          	srl	s1,s0,0x1
80008654:	854e                	mv	a0,s3
80008656:	85d6                	mv	a1,s5
80008658:	8cdd                	or	s1,s1,a5
8000865a:	3949                	jal	800082ec <__ashldi3>
8000865c:	0165d613          	srl	a2,a1,0x16
80008660:	800047b7          	lui	a5,0x80004
80008664:	e0060613          	add	a2,a2,-512 # 7ffffe00 <_extram_size+0x7dfffe00>
80008668:	0606                	sll	a2,a2,0x1
8000866a:	a2078793          	add	a5,a5,-1504 # 80003a20 <__SEGGER_RTL_Moeller_inverse_lut>
8000866e:	97b2                	add	a5,a5,a2
80008670:	0007d783          	lhu	a5,0(a5)
80008674:	00b5d513          	srl	a0,a1,0xb
80008678:	0015f713          	and	a4,a1,1
8000867c:	02f78633          	mul	a2,a5,a5
80008680:	0792                	sll	a5,a5,0x4
80008682:	0015d693          	srl	a3,a1,0x1
80008686:	0505                	add	a0,a0,1 # 7f800001 <_extram_size+0x7d800001>
80008688:	02a63633          	mulhu	a2,a2,a0
8000868c:	8f91                	sub	a5,a5,a2
8000868e:	00195b13          	srl	s6,s2,0x1
80008692:	96ba                	add	a3,a3,a4
80008694:	17fd                	add	a5,a5,-1
80008696:	c319                	beqz	a4,8000869c <.L82>
80008698:	0017d713          	srl	a4,a5,0x1

8000869c <.L82>:
8000869c:	02f686b3          	mul	a3,a3,a5
800086a0:	8f15                	sub	a4,a4,a3
800086a2:	02e7b733          	mulhu	a4,a5,a4
800086a6:	07be                	sll	a5,a5,0xf
800086a8:	8305                	srl	a4,a4,0x1
800086aa:	97ba                	add	a5,a5,a4
800086ac:	872e                	mv	a4,a1
800086ae:	02b786b3          	mul	a3,a5,a1
800086b2:	9736                	add	a4,a4,a3
800086b4:	00d736b3          	sltu	a3,a4,a3
800086b8:	872e                	mv	a4,a1
800086ba:	9736                	add	a4,a4,a3
800086bc:	02b7b6b3          	mulhu	a3,a5,a1
800086c0:	9736                	add	a4,a4,a3
800086c2:	8f99                	sub	a5,a5,a4
800086c4:	0367b733          	mulhu	a4,a5,s6
800086c8:	036787b3          	mul	a5,a5,s6
800086cc:	009786b3          	add	a3,a5,s1
800086d0:	00f6b7b3          	sltu	a5,a3,a5
800086d4:	97da                	add	a5,a5,s6
800086d6:	973e                	add	a4,a4,a5
800086d8:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
800086dc:	02f58633          	mul	a2,a1,a5
800086e0:	8c91                	sub	s1,s1,a2
800086e2:	0096f463          	bgeu	a3,s1,800086ea <.L83>
800086e6:	94ae                	add	s1,s1,a1
800086e8:	87ba                	mv	a5,a4

800086ea <.L83>:
800086ea:	00b4e363          	bltu	s1,a1,800086f0 <.L84>
800086ee:	0785                	add	a5,a5,1

800086f0 <.L84>:
800086f0:	477d                	li	a4,31
800086f2:	41470733          	sub	a4,a4,s4
800086f6:	00e7d633          	srl	a2,a5,a4
800086fa:	c211                	beqz	a2,800086fe <.L85>
800086fc:	167d                	add	a2,a2,-1

800086fe <.L85>:
800086fe:	02ca87b3          	mul	a5,s5,a2
80008702:	03360733          	mul	a4,a2,s3
80008706:	033636b3          	mulhu	a3,a2,s3
8000870a:	40e40733          	sub	a4,s0,a4
8000870e:	00e43433          	sltu	s0,s0,a4
80008712:	97b6                	add	a5,a5,a3
80008714:	40f907b3          	sub	a5,s2,a5
80008718:	40878433          	sub	s0,a5,s0
8000871c:	01546763          	bltu	s0,s5,8000872a <.L86>
80008720:	008a9463          	bne	s5,s0,80008728 <.L95>
80008724:	01376363          	bltu	a4,s3,8000872a <.L86>

80008728 <.L95>:
80008728:	0605                	add	a2,a2,1

8000872a <.L86>:
8000872a:	8432                	mv	s0,a2
8000872c:	bd29                	j	80008546 <.L109>

8000872e <.L88>:
8000872e:	4401                	li	s0,0
80008730:	bd19                	j	80008546 <.L109>

Disassembly of section .text.libc.__umoddi3:

80008732 <__umoddi3>:
80008732:	1101                	add	sp,sp,-32
80008734:	cc22                	sw	s0,24(sp)
80008736:	ca26                	sw	s1,20(sp)
80008738:	c84a                	sw	s2,16(sp)
8000873a:	c64e                	sw	s3,12(sp)
8000873c:	c452                	sw	s4,8(sp)
8000873e:	ce06                	sw	ra,28(sp)
80008740:	c256                	sw	s5,4(sp)
80008742:	c05a                	sw	s6,0(sp)
80008744:	892a                	mv	s2,a0
80008746:	84ae                	mv	s1,a1
80008748:	8432                	mv	s0,a2
8000874a:	89b6                	mv	s3,a3
8000874c:	8a36                	mv	s4,a3
8000874e:	2e069e63          	bnez	a3,80008a4a <.L111>
80008752:	e589                	bnez	a1,8000875c <.L112>
80008754:	02c557b3          	divu	a5,a0,a2

80008758 <.L174>:
80008758:	4701                	li	a4,0
8000875a:	a815                	j	8000878e <.L113>

8000875c <.L112>:
8000875c:	010007b7          	lui	a5,0x1000
80008760:	16f67163          	bgeu	a2,a5,800088c2 <.L114>
80008764:	4791                	li	a5,4
80008766:	0cc7e063          	bltu	a5,a2,80008826 <.L116>
8000876a:	470d                	li	a4,3
8000876c:	04e60d63          	beq	a2,a4,800087c6 <.L118>
80008770:	0af60363          	beq	a2,a5,80008816 <.L119>
80008774:	4785                	li	a5,1
80008776:	3ef60763          	beq	a2,a5,80008b64 <.L152>
8000877a:	4789                	li	a5,2
8000877c:	3ef61763          	bne	a2,a5,80008b6a <.L153>
80008780:	01f59713          	sll	a4,a1,0x1f
80008784:	00155793          	srl	a5,a0,0x1
80008788:	8fd9                	or	a5,a5,a4
8000878a:	0015d713          	srl	a4,a1,0x1

8000878e <.L113>:
8000878e:	02870733          	mul	a4,a4,s0
80008792:	40f2                	lw	ra,28(sp)
80008794:	4a22                	lw	s4,8(sp)
80008796:	4a92                	lw	s5,4(sp)
80008798:	4b02                	lw	s6,0(sp)
8000879a:	02f989b3          	mul	s3,s3,a5
8000879e:	02f40533          	mul	a0,s0,a5
800087a2:	99ba                	add	s3,s3,a4
800087a4:	02f43433          	mulhu	s0,s0,a5
800087a8:	40a90533          	sub	a0,s2,a0
800087ac:	00a935b3          	sltu	a1,s2,a0
800087b0:	4942                	lw	s2,16(sp)
800087b2:	99a2                	add	s3,s3,s0
800087b4:	4462                	lw	s0,24(sp)
800087b6:	413484b3          	sub	s1,s1,s3
800087ba:	40b485b3          	sub	a1,s1,a1
800087be:	49b2                	lw	s3,12(sp)
800087c0:	44d2                	lw	s1,20(sp)
800087c2:	6105                	add	sp,sp,32
800087c4:	8082                	ret

800087c6 <.L118>:
800087c6:	555557b7          	lui	a5,0x55555
800087ca:	55578793          	add	a5,a5,1365 # 55555555 <_extram_size+0x53555555>
800087ce:	02b7b6b3          	mulhu	a3,a5,a1
800087d2:	02a7b633          	mulhu	a2,a5,a0
800087d6:	02a78733          	mul	a4,a5,a0
800087da:	02b787b3          	mul	a5,a5,a1
800087de:	97b2                	add	a5,a5,a2
800087e0:	00c7b633          	sltu	a2,a5,a2
800087e4:	9636                	add	a2,a2,a3
800087e6:	00f706b3          	add	a3,a4,a5
800087ea:	00e6b733          	sltu	a4,a3,a4
800087ee:	9732                	add	a4,a4,a2
800087f0:	97ba                	add	a5,a5,a4
800087f2:	00e7b5b3          	sltu	a1,a5,a4
800087f6:	9736                	add	a4,a4,a3
800087f8:	00d736b3          	sltu	a3,a4,a3
800087fc:	0705                	add	a4,a4,1
800087fe:	97b6                	add	a5,a5,a3
80008800:	00173713          	seqz	a4,a4
80008804:	00d7b6b3          	sltu	a3,a5,a3
80008808:	962e                	add	a2,a2,a1
8000880a:	97ba                	add	a5,a5,a4
8000880c:	96b2                	add	a3,a3,a2
8000880e:	00e7b733          	sltu	a4,a5,a4
80008812:	9736                	add	a4,a4,a3
80008814:	bfad                	j	8000878e <.L113>

80008816 <.L119>:
80008816:	01e59713          	sll	a4,a1,0x1e
8000881a:	00255793          	srl	a5,a0,0x2
8000881e:	8fd9                	or	a5,a5,a4
80008820:	0025d713          	srl	a4,a1,0x2
80008824:	b7ad                	j	8000878e <.L113>

80008826 <.L116>:
80008826:	67c1                	lui	a5,0x10
80008828:	02c5d733          	divu	a4,a1,a2
8000882c:	01055693          	srl	a3,a0,0x10
80008830:	02f67b63          	bgeu	a2,a5,80008866 <.L126>
80008834:	02c707b3          	mul	a5,a4,a2
80008838:	40f587b3          	sub	a5,a1,a5
8000883c:	07c2                	sll	a5,a5,0x10
8000883e:	97b6                	add	a5,a5,a3
80008840:	02c7d633          	divu	a2,a5,a2
80008844:	028606b3          	mul	a3,a2,s0
80008848:	0642                	sll	a2,a2,0x10
8000884a:	8f95                	sub	a5,a5,a3
8000884c:	01079693          	sll	a3,a5,0x10
80008850:	01051793          	sll	a5,a0,0x10
80008854:	83c1                	srl	a5,a5,0x10
80008856:	97b6                	add	a5,a5,a3
80008858:	0287d7b3          	divu	a5,a5,s0
8000885c:	97b2                	add	a5,a5,a2
8000885e:	00c7b633          	sltu	a2,a5,a2
80008862:	9732                	add	a4,a4,a2
80008864:	b72d                	j	8000878e <.L113>

80008866 <.L126>:
80008866:	02c707b3          	mul	a5,a4,a2
8000886a:	01855613          	srl	a2,a0,0x18
8000886e:	0ff6f693          	zext.b	a3,a3
80008872:	40f587b3          	sub	a5,a1,a5
80008876:	07a2                	sll	a5,a5,0x8
80008878:	963e                	add	a2,a2,a5
8000887a:	028657b3          	divu	a5,a2,s0
8000887e:	028785b3          	mul	a1,a5,s0
80008882:	07a2                	sll	a5,a5,0x8
80008884:	8e0d                	sub	a2,a2,a1
80008886:	0622                	sll	a2,a2,0x8
80008888:	96b2                	add	a3,a3,a2
8000888a:	0286d5b3          	divu	a1,a3,s0
8000888e:	97ae                	add	a5,a5,a1
80008890:	07a2                	sll	a5,a5,0x8
80008892:	02858633          	mul	a2,a1,s0
80008896:	8e91                	sub	a3,a3,a2
80008898:	00855613          	srl	a2,a0,0x8
8000889c:	0ff67613          	zext.b	a2,a2
800088a0:	06a2                	sll	a3,a3,0x8
800088a2:	96b2                	add	a3,a3,a2
800088a4:	0286d633          	divu	a2,a3,s0
800088a8:	97b2                	add	a5,a5,a2
800088aa:	07a2                	sll	a5,a5,0x8
800088ac:	02860533          	mul	a0,a2,s0
800088b0:	0ff97613          	zext.b	a2,s2
800088b4:	8e89                	sub	a3,a3,a0
800088b6:	06a2                	sll	a3,a3,0x8
800088b8:	96b2                	add	a3,a3,a2
800088ba:	0286d6b3          	divu	a3,a3,s0
800088be:	97b6                	add	a5,a5,a3
800088c0:	b5f9                	j	8000878e <.L113>

800088c2 <.L114>:
800088c2:	80004b37          	lui	s6,0x80004
800088c6:	a20b0b13          	add	s6,s6,-1504 # 80003a20 <__SEGGER_RTL_Moeller_inverse_lut>
800088ca:	0ac5fe63          	bgeu	a1,a2,80008986 <.L128>
800088ce:	10000737          	lui	a4,0x10000
800088d2:	87b2                	mv	a5,a2
800088d4:	00e67563          	bgeu	a2,a4,800088de <.L129>
800088d8:	00461793          	sll	a5,a2,0x4
800088dc:	4a11                	li	s4,4

800088de <.L129>:
800088de:	40000737          	lui	a4,0x40000
800088e2:	00e7f463          	bgeu	a5,a4,800088ea <.L130>
800088e6:	0a09                	add	s4,s4,2
800088e8:	078a                	sll	a5,a5,0x2

800088ea <.L130>:
800088ea:	0007c363          	bltz	a5,800088f0 <.L131>
800088ee:	0a05                	add	s4,s4,1

800088f0 <.L131>:
800088f0:	8652                	mv	a2,s4
800088f2:	854a                	mv	a0,s2
800088f4:	85a6                	mv	a1,s1
800088f6:	3add                	jal	800082ec <__ashldi3>
800088f8:	01441a33          	sll	s4,s0,s4
800088fc:	016a5793          	srl	a5,s4,0x16
80008900:	e0078793          	add	a5,a5,-512 # fe00 <__XPI0_segment_used_size__+0x2a48>
80008904:	0786                	sll	a5,a5,0x1
80008906:	97da                	add	a5,a5,s6
80008908:	0007d783          	lhu	a5,0(a5)
8000890c:	00ba5813          	srl	a6,s4,0xb
80008910:	001a7713          	and	a4,s4,1
80008914:	02f78633          	mul	a2,a5,a5
80008918:	0792                	sll	a5,a5,0x4
8000891a:	001a5693          	srl	a3,s4,0x1
8000891e:	0805                	add	a6,a6,1
80008920:	03063633          	mulhu	a2,a2,a6
80008924:	8f91                	sub	a5,a5,a2
80008926:	96ba                	add	a3,a3,a4
80008928:	17fd                	add	a5,a5,-1
8000892a:	c319                	beqz	a4,80008930 <.L132>
8000892c:	0017d713          	srl	a4,a5,0x1

80008930 <.L132>:
80008930:	02f686b3          	mul	a3,a3,a5
80008934:	8f15                	sub	a4,a4,a3
80008936:	02e7b733          	mulhu	a4,a5,a4
8000893a:	07be                	sll	a5,a5,0xf
8000893c:	8305                	srl	a4,a4,0x1
8000893e:	97ba                	add	a5,a5,a4
80008940:	8752                	mv	a4,s4
80008942:	034786b3          	mul	a3,a5,s4
80008946:	9736                	add	a4,a4,a3
80008948:	00d736b3          	sltu	a3,a4,a3
8000894c:	8752                	mv	a4,s4
8000894e:	9736                	add	a4,a4,a3
80008950:	0347b6b3          	mulhu	a3,a5,s4
80008954:	9736                	add	a4,a4,a3
80008956:	8f99                	sub	a5,a5,a4
80008958:	02b7b733          	mulhu	a4,a5,a1
8000895c:	02b787b3          	mul	a5,a5,a1
80008960:	00a786b3          	add	a3,a5,a0
80008964:	00f6b7b3          	sltu	a5,a3,a5
80008968:	95be                	add	a1,a1,a5
8000896a:	972e                	add	a4,a4,a1
8000896c:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
80008970:	02fa0633          	mul	a2,s4,a5
80008974:	8d11                	sub	a0,a0,a2
80008976:	00a6f463          	bgeu	a3,a0,8000897e <.L133>
8000897a:	9552                	add	a0,a0,s4
8000897c:	87ba                	mv	a5,a4

8000897e <.L133>:
8000897e:	dd456de3          	bltu	a0,s4,80008758 <.L174>

80008982 <.L160>:
80008982:	0785                	add	a5,a5,1
80008984:	bbd1                	j	80008758 <.L174>

80008986 <.L128>:
80008986:	02c5dab3          	divu	s5,a1,a2
8000898a:	10000737          	lui	a4,0x10000
8000898e:	87b2                	mv	a5,a2
80008990:	02ca85b3          	mul	a1,s5,a2
80008994:	40b485b3          	sub	a1,s1,a1
80008998:	00e67563          	bgeu	a2,a4,800089a2 <.L135>
8000899c:	00461793          	sll	a5,a2,0x4
800089a0:	4a11                	li	s4,4

800089a2 <.L135>:
800089a2:	40000737          	lui	a4,0x40000
800089a6:	00e7f463          	bgeu	a5,a4,800089ae <.L136>
800089aa:	0a09                	add	s4,s4,2
800089ac:	078a                	sll	a5,a5,0x2

800089ae <.L136>:
800089ae:	0007c363          	bltz	a5,800089b4 <.L137>
800089b2:	0a05                	add	s4,s4,1

800089b4 <.L137>:
800089b4:	8652                	mv	a2,s4
800089b6:	854a                	mv	a0,s2
800089b8:	3a15                	jal	800082ec <__ashldi3>
800089ba:	01441a33          	sll	s4,s0,s4
800089be:	016a5793          	srl	a5,s4,0x16
800089c2:	e0078793          	add	a5,a5,-512
800089c6:	0786                	sll	a5,a5,0x1
800089c8:	9b3e                	add	s6,s6,a5
800089ca:	000b5783          	lhu	a5,0(s6)
800089ce:	00ba5813          	srl	a6,s4,0xb
800089d2:	001a7713          	and	a4,s4,1
800089d6:	02f78633          	mul	a2,a5,a5
800089da:	0792                	sll	a5,a5,0x4
800089dc:	001a5693          	srl	a3,s4,0x1
800089e0:	0805                	add	a6,a6,1
800089e2:	03063633          	mulhu	a2,a2,a6
800089e6:	8f91                	sub	a5,a5,a2
800089e8:	96ba                	add	a3,a3,a4
800089ea:	17fd                	add	a5,a5,-1
800089ec:	c319                	beqz	a4,800089f2 <.L138>
800089ee:	0017d713          	srl	a4,a5,0x1

800089f2 <.L138>:
800089f2:	02f686b3          	mul	a3,a3,a5
800089f6:	8f15                	sub	a4,a4,a3
800089f8:	02e7b733          	mulhu	a4,a5,a4
800089fc:	07be                	sll	a5,a5,0xf
800089fe:	8305                	srl	a4,a4,0x1
80008a00:	97ba                	add	a5,a5,a4
80008a02:	8752                	mv	a4,s4
80008a04:	034786b3          	mul	a3,a5,s4
80008a08:	9736                	add	a4,a4,a3
80008a0a:	00d736b3          	sltu	a3,a4,a3
80008a0e:	8752                	mv	a4,s4
80008a10:	9736                	add	a4,a4,a3
80008a12:	0347b6b3          	mulhu	a3,a5,s4
80008a16:	9736                	add	a4,a4,a3
80008a18:	8f99                	sub	a5,a5,a4
80008a1a:	02b7b733          	mulhu	a4,a5,a1
80008a1e:	02b787b3          	mul	a5,a5,a1
80008a22:	00a786b3          	add	a3,a5,a0
80008a26:	00f6b7b3          	sltu	a5,a3,a5
80008a2a:	95be                	add	a1,a1,a5
80008a2c:	972e                	add	a4,a4,a1
80008a2e:	00170793          	add	a5,a4,1 # 40000001 <_extram_size+0x3e000001>
80008a32:	02fa0633          	mul	a2,s4,a5
80008a36:	8d11                	sub	a0,a0,a2
80008a38:	00a6f463          	bgeu	a3,a0,80008a40 <.L139>
80008a3c:	9552                	add	a0,a0,s4
80008a3e:	87ba                	mv	a5,a4

80008a40 <.L139>:
80008a40:	01456363          	bltu	a0,s4,80008a46 <.L140>
80008a44:	0785                	add	a5,a5,1

80008a46 <.L140>:
80008a46:	8756                	mv	a4,s5
80008a48:	b399                	j	8000878e <.L113>

80008a4a <.L111>:
80008a4a:	67c1                	lui	a5,0x10
80008a4c:	4a81                	li	s5,0
80008a4e:	00f6f563          	bgeu	a3,a5,80008a58 <.L141>
80008a52:	01069a13          	sll	s4,a3,0x10
80008a56:	4ac1                	li	s5,16

80008a58 <.L141>:
80008a58:	010007b7          	lui	a5,0x1000
80008a5c:	00fa7463          	bgeu	s4,a5,80008a64 <.L142>
80008a60:	0aa1                	add	s5,s5,8
80008a62:	0a22                	sll	s4,s4,0x8

80008a64 <.L142>:
80008a64:	100007b7          	lui	a5,0x10000
80008a68:	00fa7463          	bgeu	s4,a5,80008a70 <.L143>
80008a6c:	0a91                	add	s5,s5,4
80008a6e:	0a12                	sll	s4,s4,0x4

80008a70 <.L143>:
80008a70:	400007b7          	lui	a5,0x40000
80008a74:	00fa7463          	bgeu	s4,a5,80008a7c <.L144>
80008a78:	0a89                	add	s5,s5,2
80008a7a:	0a0a                	sll	s4,s4,0x2

80008a7c <.L144>:
80008a7c:	000a4363          	bltz	s4,80008a82 <.L145>
80008a80:	0a85                	add	s5,s5,1

80008a82 <.L145>:
80008a82:	01f49793          	sll	a5,s1,0x1f
80008a86:	8656                	mv	a2,s5
80008a88:	00195a13          	srl	s4,s2,0x1
80008a8c:	8522                	mv	a0,s0
80008a8e:	85ce                	mv	a1,s3
80008a90:	0147ea33          	or	s4,a5,s4
80008a94:	38a1                	jal	800082ec <__ashldi3>
80008a96:	0165d613          	srl	a2,a1,0x16
80008a9a:	800047b7          	lui	a5,0x80004
80008a9e:	e0060613          	add	a2,a2,-512
80008aa2:	0606                	sll	a2,a2,0x1
80008aa4:	a2078793          	add	a5,a5,-1504 # 80003a20 <__SEGGER_RTL_Moeller_inverse_lut>
80008aa8:	97b2                	add	a5,a5,a2
80008aaa:	0007d783          	lhu	a5,0(a5)
80008aae:	00b5d513          	srl	a0,a1,0xb
80008ab2:	0015f713          	and	a4,a1,1
80008ab6:	02f78633          	mul	a2,a5,a5
80008aba:	0792                	sll	a5,a5,0x4
80008abc:	0015d693          	srl	a3,a1,0x1
80008ac0:	0505                	add	a0,a0,1
80008ac2:	02a63633          	mulhu	a2,a2,a0
80008ac6:	8f91                	sub	a5,a5,a2
80008ac8:	0014db13          	srl	s6,s1,0x1
80008acc:	96ba                	add	a3,a3,a4
80008ace:	17fd                	add	a5,a5,-1
80008ad0:	c319                	beqz	a4,80008ad6 <.L146>
80008ad2:	0017d713          	srl	a4,a5,0x1

80008ad6 <.L146>:
80008ad6:	02f686b3          	mul	a3,a3,a5
80008ada:	8f15                	sub	a4,a4,a3
80008adc:	02e7b733          	mulhu	a4,a5,a4
80008ae0:	07be                	sll	a5,a5,0xf
80008ae2:	8305                	srl	a4,a4,0x1
80008ae4:	97ba                	add	a5,a5,a4
80008ae6:	872e                	mv	a4,a1
80008ae8:	02b786b3          	mul	a3,a5,a1
80008aec:	9736                	add	a4,a4,a3
80008aee:	00d736b3          	sltu	a3,a4,a3
80008af2:	872e                	mv	a4,a1
80008af4:	9736                	add	a4,a4,a3
80008af6:	02b7b6b3          	mulhu	a3,a5,a1
80008afa:	9736                	add	a4,a4,a3
80008afc:	8f99                	sub	a5,a5,a4
80008afe:	0367b733          	mulhu	a4,a5,s6
80008b02:	036787b3          	mul	a5,a5,s6
80008b06:	014786b3          	add	a3,a5,s4
80008b0a:	00f6b7b3          	sltu	a5,a3,a5
80008b0e:	97da                	add	a5,a5,s6
80008b10:	973e                	add	a4,a4,a5
80008b12:	00170793          	add	a5,a4,1
80008b16:	02f58633          	mul	a2,a1,a5
80008b1a:	40ca0a33          	sub	s4,s4,a2
80008b1e:	0146f463          	bgeu	a3,s4,80008b26 <.L147>
80008b22:	9a2e                	add	s4,s4,a1
80008b24:	87ba                	mv	a5,a4

80008b26 <.L147>:
80008b26:	00ba6363          	bltu	s4,a1,80008b2c <.L148>
80008b2a:	0785                	add	a5,a5,1

80008b2c <.L148>:
80008b2c:	477d                	li	a4,31
80008b2e:	41570733          	sub	a4,a4,s5
80008b32:	00e7d7b3          	srl	a5,a5,a4
80008b36:	c391                	beqz	a5,80008b3a <.L149>
80008b38:	17fd                	add	a5,a5,-1

80008b3a <.L149>:
80008b3a:	0287b633          	mulhu	a2,a5,s0
80008b3e:	02f98733          	mul	a4,s3,a5
80008b42:	028786b3          	mul	a3,a5,s0
80008b46:	9732                	add	a4,a4,a2
80008b48:	40e48733          	sub	a4,s1,a4
80008b4c:	40d906b3          	sub	a3,s2,a3
80008b50:	00d93633          	sltu	a2,s2,a3
80008b54:	8f11                	sub	a4,a4,a2
80008b56:	c13761e3          	bltu	a4,s3,80008758 <.L174>
80008b5a:	e2e994e3          	bne	s3,a4,80008982 <.L160>
80008b5e:	be86ede3          	bltu	a3,s0,80008758 <.L174>
80008b62:	b505                	j	80008982 <.L160>

80008b64 <.L152>:
80008b64:	87aa                	mv	a5,a0
80008b66:	872e                	mv	a4,a1
80008b68:	b11d                	j	8000878e <.L113>

80008b6a <.L153>:
80008b6a:	4781                	li	a5,0
80008b6c:	b6f5                	j	80008758 <.L174>

Disassembly of section .text.libc.abs:

80008b6e <abs>:
80008b6e:	41f55793          	sra	a5,a0,0x1f
80008b72:	8d3d                	xor	a0,a0,a5
80008b74:	8d1d                	sub	a0,a0,a5
80008b76:	8082                	ret

Disassembly of section .text.libc.memcpy:

80008b78 <memcpy>:
80008b78:	c251                	beqz	a2,80008bfc <.Lmemcpy_done>
80008b7a:	87aa                	mv	a5,a0
80008b7c:	00b546b3          	xor	a3,a0,a1
80008b80:	06fa                	sll	a3,a3,0x1e
80008b82:	e2bd                	bnez	a3,80008be8 <.Lmemcpy_byte_copy>
80008b84:	01e51693          	sll	a3,a0,0x1e
80008b88:	ce81                	beqz	a3,80008ba0 <.Lmemcpy_aligned>

80008b8a <.Lmemcpy_word_align>:
80008b8a:	00058683          	lb	a3,0(a1)
80008b8e:	00d50023          	sb	a3,0(a0)
80008b92:	0585                	add	a1,a1,1
80008b94:	0505                	add	a0,a0,1
80008b96:	167d                	add	a2,a2,-1
80008b98:	c22d                	beqz	a2,80008bfa <.Lmemcpy_memcpy_end>
80008b9a:	01e51693          	sll	a3,a0,0x1e
80008b9e:	f6f5                	bnez	a3,80008b8a <.Lmemcpy_word_align>

80008ba0 <.Lmemcpy_aligned>:
80008ba0:	02000693          	li	a3,32
80008ba4:	02d66763          	bltu	a2,a3,80008bd2 <.Lmemcpy_word_copy>

80008ba8 <.Lmemcpy_aligned_block_copy_loop>:
80008ba8:	4198                	lw	a4,0(a1)
80008baa:	c118                	sw	a4,0(a0)
80008bac:	41d8                	lw	a4,4(a1)
80008bae:	c158                	sw	a4,4(a0)
80008bb0:	4598                	lw	a4,8(a1)
80008bb2:	c518                	sw	a4,8(a0)
80008bb4:	45d8                	lw	a4,12(a1)
80008bb6:	c558                	sw	a4,12(a0)
80008bb8:	4998                	lw	a4,16(a1)
80008bba:	c918                	sw	a4,16(a0)
80008bbc:	49d8                	lw	a4,20(a1)
80008bbe:	c958                	sw	a4,20(a0)
80008bc0:	4d98                	lw	a4,24(a1)
80008bc2:	cd18                	sw	a4,24(a0)
80008bc4:	4dd8                	lw	a4,28(a1)
80008bc6:	cd58                	sw	a4,28(a0)
80008bc8:	9536                	add	a0,a0,a3
80008bca:	95b6                	add	a1,a1,a3
80008bcc:	8e15                	sub	a2,a2,a3
80008bce:	fcd67de3          	bgeu	a2,a3,80008ba8 <.Lmemcpy_aligned_block_copy_loop>

80008bd2 <.Lmemcpy_word_copy>:
80008bd2:	c605                	beqz	a2,80008bfa <.Lmemcpy_memcpy_end>
80008bd4:	4691                	li	a3,4
80008bd6:	00d66963          	bltu	a2,a3,80008be8 <.Lmemcpy_byte_copy>

80008bda <.Lmemcpy_word_copy_loop>:
80008bda:	4198                	lw	a4,0(a1)
80008bdc:	c118                	sw	a4,0(a0)
80008bde:	9536                	add	a0,a0,a3
80008be0:	95b6                	add	a1,a1,a3
80008be2:	8e15                	sub	a2,a2,a3
80008be4:	fed67be3          	bgeu	a2,a3,80008bda <.Lmemcpy_word_copy_loop>

80008be8 <.Lmemcpy_byte_copy>:
80008be8:	ca09                	beqz	a2,80008bfa <.Lmemcpy_memcpy_end>

80008bea <.Lmemcpy_byte_copy_loop>:
80008bea:	00058703          	lb	a4,0(a1)
80008bee:	00e50023          	sb	a4,0(a0)
80008bf2:	0585                	add	a1,a1,1
80008bf4:	0505                	add	a0,a0,1
80008bf6:	167d                	add	a2,a2,-1
80008bf8:	fa6d                	bnez	a2,80008bea <.Lmemcpy_byte_copy_loop>

80008bfa <.Lmemcpy_memcpy_end>:
80008bfa:	853e                	mv	a0,a5

80008bfc <.Lmemcpy_done>:
80008bfc:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

80008bfe <__SEGGER_RTL_pow10f>:
80008bfe:	1101                	add	sp,sp,-32
80008c00:	cc22                	sw	s0,24(sp)
80008c02:	c64e                	sw	s3,12(sp)
80008c04:	ce06                	sw	ra,28(sp)
80008c06:	ca26                	sw	s1,20(sp)
80008c08:	c84a                	sw	s2,16(sp)
80008c0a:	842a                	mv	s0,a0
80008c0c:	4981                	li	s3,0
80008c0e:	00055563          	bgez	a0,80008c18 <.L17>
80008c12:	40a00433          	neg	s0,a0
80008c16:	4985                	li	s3,1

80008c18 <.L17>:
80008c18:	80004937          	lui	s2,0x80004
80008c1c:	05892503          	lw	a0,88(s2) # 80004058 <.Lmerged_single+0x4>
80008c20:	800044b7          	lui	s1,0x80004
80008c24:	e2048493          	add	s1,s1,-480 # 80003e20 <__SEGGER_RTL_aPower2f>

80008c28 <.L18>:
80008c28:	ec19                	bnez	s0,80008c46 <.L20>
80008c2a:	00098763          	beqz	s3,80008c38 <.L16>
80008c2e:	85aa                	mv	a1,a0
80008c30:	05892503          	lw	a0,88(s2)
80008c34:	526030ef          	jal	8000c15a <__divsf3>

80008c38 <.L16>:
80008c38:	40f2                	lw	ra,28(sp)
80008c3a:	4462                	lw	s0,24(sp)
80008c3c:	44d2                	lw	s1,20(sp)
80008c3e:	4942                	lw	s2,16(sp)
80008c40:	49b2                	lw	s3,12(sp)
80008c42:	6105                	add	sp,sp,32
80008c44:	8082                	ret

80008c46 <.L20>:
80008c46:	00147793          	and	a5,s0,1
80008c4a:	c781                	beqz	a5,80008c52 <.L19>
80008c4c:	408c                	lw	a1,0(s1)
80008c4e:	34c030ef          	jal	8000bf9a <__mulsf3>

80008c52 <.L19>:
80008c52:	8405                	sra	s0,s0,0x1
80008c54:	0491                	add	s1,s1,4
80008c56:	bfc9                	j	80008c28 <.L18>

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80008c58 <__SEGGER_RTL_prin_flush>:
80008c58:	4950                	lw	a2,20(a0)
80008c5a:	ce19                	beqz	a2,80008c78 <.L20>
80008c5c:	511c                	lw	a5,32(a0)
80008c5e:	1141                	add	sp,sp,-16
80008c60:	c422                	sw	s0,8(sp)
80008c62:	c606                	sw	ra,12(sp)
80008c64:	842a                	mv	s0,a0
80008c66:	c399                	beqz	a5,80008c6c <.L12>
80008c68:	490c                	lw	a1,16(a0)
80008c6a:	9782                	jalr	a5

80008c6c <.L12>:
80008c6c:	40b2                	lw	ra,12(sp)
80008c6e:	00042a23          	sw	zero,20(s0)
80008c72:	4422                	lw	s0,8(sp)
80008c74:	0141                	add	sp,sp,16
80008c76:	8082                	ret

80008c78 <.L20>:
80008c78:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80008c7a <__SEGGER_RTL_pre_padding>:
80008c7a:	0105f793          	and	a5,a1,16
80008c7e:	eb91                	bnez	a5,80008c92 <.L40>
80008c80:	2005f793          	and	a5,a1,512
80008c84:	02000593          	li	a1,32
80008c88:	c399                	beqz	a5,80008c8e <.L42>
80008c8a:	03000593          	li	a1,48

80008c8e <.L42>:
80008c8e:	4950306f          	j	8000c922 <__SEGGER_RTL_print_padding>

80008c92 <.L40>:
80008c92:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin_l:

80008c94 <__SEGGER_RTL_init_prin_l>:
80008c94:	1141                	add	sp,sp,-16
80008c96:	c226                	sw	s1,4(sp)
80008c98:	02400613          	li	a2,36
80008c9c:	84ae                	mv	s1,a1
80008c9e:	4581                	li	a1,0
80008ca0:	c422                	sw	s0,8(sp)
80008ca2:	c606                	sw	ra,12(sp)
80008ca4:	842a                	mv	s0,a0
80008ca6:	26d030ef          	jal	8000c712 <memset>
80008caa:	40b2                	lw	ra,12(sp)
80008cac:	cc44                	sw	s1,28(s0)
80008cae:	4422                	lw	s0,8(sp)
80008cb0:	4492                	lw	s1,4(sp)
80008cb2:	0141                	add	sp,sp,16
80008cb4:	8082                	ret

Disassembly of section .text.libc.vfprintf:

80008cb6 <vfprintf>:
80008cb6:	1101                	add	sp,sp,-32
80008cb8:	cc22                	sw	s0,24(sp)
80008cba:	ca26                	sw	s1,20(sp)
80008cbc:	ce06                	sw	ra,28(sp)
80008cbe:	84ae                	mv	s1,a1
80008cc0:	842a                	mv	s0,a0
80008cc2:	c632                	sw	a2,12(sp)
80008cc4:	227040ef          	jal	8000d6ea <__SEGGER_RTL_current_locale>
80008cc8:	85aa                	mv	a1,a0
80008cca:	8522                	mv	a0,s0
80008ccc:	4462                	lw	s0,24(sp)
80008cce:	46b2                	lw	a3,12(sp)
80008cd0:	40f2                	lw	ra,28(sp)
80008cd2:	8626                	mv	a2,s1
80008cd4:	44d2                	lw	s1,20(sp)
80008cd6:	6105                	add	sp,sp,32
80008cd8:	4750306f          	j	8000c94c <vfprintf_l>

Disassembly of section .text.libc.printf:

80008cdc <printf>:
80008cdc:	7139                	add	sp,sp,-64
80008cde:	da3e                	sw	a5,52(sp)
80008ce0:	d22e                	sw	a1,36(sp)
80008ce2:	85aa                	mv	a1,a0
80008ce4:	c0c22503          	lw	a0,-1012(tp) # fffffc0c <__APB_SRAM_segment_end__+0xbf0dc0c>
80008ce8:	d432                	sw	a2,40(sp)
80008cea:	1050                	add	a2,sp,36
80008cec:	ce06                	sw	ra,28(sp)
80008cee:	d636                	sw	a3,44(sp)
80008cf0:	d83a                	sw	a4,48(sp)
80008cf2:	dc42                	sw	a6,56(sp)
80008cf4:	de46                	sw	a7,60(sp)
80008cf6:	c632                	sw	a2,12(sp)
80008cf8:	3f7d                	jal	80008cb6 <vfprintf>
80008cfa:	40f2                	lw	ra,28(sp)
80008cfc:	6121                	add	sp,sp,64
80008cfe:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

80008d00 <__SEGGER_init_heap>:
80008d00:	00080537          	lui	a0,0x80
80008d04:	00050513          	mv	a0,a0
80008d08:	000845b7          	lui	a1,0x84
80008d0c:	00058593          	mv	a1,a1
80008d10:	8d89                	sub	a1,a1,a0
80008d12:	a009                	j	80008d14 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

80008d14 <__SEGGER_RTL_init_heap>:
80008d14:	479d                	li	a5,7
80008d16:	00b7f763          	bgeu	a5,a1,80008d24 <.L68>
80008d1a:	c0a22023          	sw	a0,-1024(tp) # fffffc00 <__APB_SRAM_segment_end__+0xbf0dc00>
80008d1e:	00052023          	sw	zero,0(a0) # 80000 <__AXI_SRAM_segment_size__>
80008d22:	c14c                	sw	a1,4(a0)

80008d24 <.L68>:
80008d24:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

80008d26 <__SEGGER_RTL_ascii_toupper>:
80008d26:	f9f50713          	add	a4,a0,-97
80008d2a:	47e5                	li	a5,25
80008d2c:	00e7e363          	bltu	a5,a4,80008d32 <.L5>
80008d30:	1501                	add	a0,a0,-32

80008d32 <.L5>:
80008d32:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

80008d34 <__SEGGER_RTL_ascii_towupper>:
80008d34:	f9f50713          	add	a4,a0,-97
80008d38:	47e5                	li	a5,25
80008d3a:	00e7e363          	bltu	a5,a4,80008d40 <.L12>
80008d3e:	1501                	add	a0,a0,-32

80008d40 <.L12>:
80008d40:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

80008d42 <__SEGGER_RTL_ascii_mbtowc>:
80008d42:	87aa                	mv	a5,a0
80008d44:	4501                	li	a0,0
80008d46:	c195                	beqz	a1,80008d6a <.L55>
80008d48:	c20d                	beqz	a2,80008d6a <.L55>
80008d4a:	0005c703          	lbu	a4,0(a1) # 84000 <__heap_end__>
80008d4e:	07f00613          	li	a2,127
80008d52:	5579                	li	a0,-2
80008d54:	00e66b63          	bltu	a2,a4,80008d6a <.L55>
80008d58:	c391                	beqz	a5,80008d5c <.L57>
80008d5a:	c398                	sw	a4,0(a5)

80008d5c <.L57>:
80008d5c:	0006a023          	sw	zero,0(a3)
80008d60:	0006a223          	sw	zero,4(a3)
80008d64:	00e03533          	snez	a0,a4
80008d68:	8082                	ret

80008d6a <.L55>:
80008d6a:	8082                	ret

Disassembly of section .text.console_init:

80008d6c <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
80008d6c:	7139                	add	sp,sp,-64
80008d6e:	de06                	sw	ra,60(sp)
80008d70:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
80008d72:	4785                	li	a5,1
80008d74:	d63e                	sw	a5,44(sp)

    if (cfg->type == CONSOLE_TYPE_UART) {
80008d76:	47b2                	lw	a5,12(sp)
80008d78:	439c                	lw	a5,0(a5)
80008d7a:	e7a1                	bnez	a5,80008dc2 <.L2>

80008d7c <.LBB2>:
        uart_config_t config = {0};
80008d7c:	cc02                	sw	zero,24(sp)
80008d7e:	ce02                	sw	zero,28(sp)
80008d80:	d002                	sw	zero,32(sp)
80008d82:	d202                	sw	zero,36(sp)
80008d84:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
80008d86:	47b2                	lw	a5,12(sp)
80008d88:	43dc                	lw	a5,4(a5)
80008d8a:	873e                	mv	a4,a5
80008d8c:	083c                	add	a5,sp,24
80008d8e:	85be                	mv	a1,a5
80008d90:	853a                	mv	a0,a4
80008d92:	ca2fc0ef          	jal	80005234 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
80008d96:	47b2                	lw	a5,12(sp)
80008d98:	479c                	lw	a5,8(a5)
80008d9a:	cc3e                	sw	a5,24(sp)
        config.baudrate = cfg->baudrate;
80008d9c:	47b2                	lw	a5,12(sp)
80008d9e:	47dc                	lw	a5,12(a5)
80008da0:	ce3e                	sw	a5,28(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
80008da2:	47b2                	lw	a5,12(sp)
80008da4:	43dc                	lw	a5,4(a5)
80008da6:	873e                	mv	a4,a5
80008da8:	083c                	add	a5,sp,24
80008daa:	85be                	mv	a1,a5
80008dac:	853a                	mv	a0,a4
80008dae:	3cf000ef          	jal	8000997c <uart_init>
80008db2:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
80008db4:	57b2                	lw	a5,44(sp)
80008db6:	e791                	bnez	a5,80008dc2 <.L2>
            g_console_uart = (UART_Type *)cfg->base;
80008db8:	47b2                	lw	a5,12(sp)
80008dba:	43dc                	lw	a5,4(a5)
80008dbc:	873e                	mv	a4,a5
80008dbe:	bee22423          	sw	a4,-1048(tp) # fffffbe8 <__APB_SRAM_segment_end__+0xbf0dbe8>

80008dc2 <.L2>:
        }
    }

    return stat;
80008dc2:	57b2                	lw	a5,44(sp)
}
80008dc4:	853e                	mv	a0,a5
80008dc6:	50f2                	lw	ra,60(sp)
80008dc8:	6121                	add	sp,sp,64
80008dca:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

80008dcc <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
80008dcc:	7179                	add	sp,sp,-48
80008dce:	d606                	sw	ra,44(sp)
80008dd0:	c62a                	sw	a0,12(sp)
80008dd2:	c42e                	sw	a1,8(sp)
80008dd4:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
80008dd6:	ce02                	sw	zero,28(sp)
80008dd8:	a099                	j	80008e1e <.L13>

80008dda <.L17>:
        if (data[count] == '\n') {
80008dda:	4722                	lw	a4,8(sp)
80008ddc:	47f2                	lw	a5,28(sp)
80008dde:	97ba                	add	a5,a5,a4
80008de0:	0007c703          	lbu	a4,0(a5)
80008de4:	47a9                	li	a5,10
80008de6:	00f71b63          	bne	a4,a5,80008dfc <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
80008dea:	0001                	nop

80008dec <.L15>:
80008dec:	be822783          	lw	a5,-1048(tp) # fffffbe8 <__APB_SRAM_segment_end__+0xbf0dbe8>
80008df0:	45b5                	li	a1,13
80008df2:	853e                	mv	a0,a5
80008df4:	e54fc0ef          	jal	80005448 <uart_send_byte>
80008df8:	87aa                	mv	a5,a0
80008dfa:	fbed                	bnez	a5,80008dec <.L15>

80008dfc <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
80008dfc:	0001                	nop

80008dfe <.L16>:
80008dfe:	be822683          	lw	a3,-1048(tp) # fffffbe8 <__APB_SRAM_segment_end__+0xbf0dbe8>
80008e02:	4722                	lw	a4,8(sp)
80008e04:	47f2                	lw	a5,28(sp)
80008e06:	97ba                	add	a5,a5,a4
80008e08:	0007c783          	lbu	a5,0(a5)
80008e0c:	85be                	mv	a1,a5
80008e0e:	8536                	mv	a0,a3
80008e10:	e38fc0ef          	jal	80005448 <uart_send_byte>
80008e14:	87aa                	mv	a5,a0
80008e16:	f7e5                	bnez	a5,80008dfe <.L16>
    for (count = 0; count < size; count++) {
80008e18:	47f2                	lw	a5,28(sp)
80008e1a:	0785                	add	a5,a5,1
80008e1c:	ce3e                	sw	a5,28(sp)

80008e1e <.L13>:
80008e1e:	4772                	lw	a4,28(sp)
80008e20:	4792                	lw	a5,4(sp)
80008e22:	faf76ce3          	bltu	a4,a5,80008dda <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
80008e26:	0001                	nop

80008e28 <.L18>:
80008e28:	be822783          	lw	a5,-1048(tp) # fffffbe8 <__APB_SRAM_segment_end__+0xbf0dbe8>
80008e2c:	853e                	mv	a0,a5
80008e2e:	4d1000ef          	jal	80009afe <uart_flush>
80008e32:	87aa                	mv	a5,a0
80008e34:	fbf5                	bnez	a5,80008e28 <.L18>
    }
    return count;
80008e36:	47f2                	lw	a5,28(sp)

}
80008e38:	853e                	mv	a0,a5
80008e3a:	50b2                	lw	ra,44(sp)
80008e3c:	6145                	add	sp,sp,48
80008e3e:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

80008e40 <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
80008e40:	1141                	add	sp,sp,-16
80008e42:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
80008e44:	4781                	li	a5,0
}
80008e46:	853e                	mv	a0,a5
80008e48:	0141                	add	sp,sp,16
80008e4a:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

80008e4c <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
80008e4c:	1141                	add	sp,sp,-16
80008e4e:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
80008e50:	4785                	li	a5,1
}
80008e52:	853e                	mv	a0,a5
80008e54:	0141                	add	sp,sp,16
80008e56:	8082                	ret

Disassembly of section .text.core_local_mem_to_sys_address:

80008e58 <core_local_mem_to_sys_address>:
#define HPM_CORE0 (0U)
#define HPM_CORE1 (1U)

/* map core local memory(DLM/ILM) to system address */
static inline uint32_t core_local_mem_to_sys_address(uint8_t core_id, uint32_t addr)
{
80008e58:	1101                	add	sp,sp,-32
80008e5a:	87aa                	mv	a5,a0
80008e5c:	c42e                	sw	a1,8(sp)
80008e5e:	00f107a3          	sb	a5,15(sp)
    uint32_t sys_addr;
    if (ADDRESS_IN_ILM(addr)) {
80008e62:	4722                	lw	a4,8(sp)
80008e64:	000407b7          	lui	a5,0x40
80008e68:	00f77863          	bgeu	a4,a5,80008e78 <.L2>
        sys_addr = ILM_TO_SYSTEM(addr);
80008e6c:	4722                	lw	a4,8(sp)
80008e6e:	010007b7          	lui	a5,0x1000
80008e72:	97ba                	add	a5,a5,a4
80008e74:	ce3e                	sw	a5,28(sp)
80008e76:	a01d                	j	80008e9c <.L3>

80008e78 <.L2>:
    } else if (ADDRESS_IN_DLM(addr)) {
80008e78:	4722                	lw	a4,8(sp)
80008e7a:	000807b7          	lui	a5,0x80
80008e7e:	00f76d63          	bltu	a4,a5,80008e98 <.L4>
80008e82:	4722                	lw	a4,8(sp)
80008e84:	000c07b7          	lui	a5,0xc0
80008e88:	00f77863          	bgeu	a4,a5,80008e98 <.L4>
        sys_addr = DLM_TO_SYSTEM(addr);
80008e8c:	4722                	lw	a4,8(sp)
80008e8e:	00fc07b7          	lui	a5,0xfc0
80008e92:	97ba                	add	a5,a5,a4
80008e94:	ce3e                	sw	a5,28(sp)
80008e96:	a019                	j	80008e9c <.L3>

80008e98 <.L4>:
    } else {
        return addr;
80008e98:	47a2                	lw	a5,8(sp)
80008e9a:	a821                	j	80008eb2 <.L5>

80008e9c <.L3>:
    }
    if (core_id == HPM_CORE1) {
80008e9c:	00f14703          	lbu	a4,15(sp)
80008ea0:	4785                	li	a5,1
80008ea2:	00f71763          	bne	a4,a5,80008eb0 <.L6>
        sys_addr += CORE1_ILM_SYSTEM_BASE - CORE0_ILM_SYSTEM_BASE;
80008ea6:	4772                	lw	a4,28(sp)
80008ea8:	001807b7          	lui	a5,0x180
80008eac:	97ba                	add	a5,a5,a4
80008eae:	ce3e                	sw	a5,28(sp)

80008eb0 <.L6>:
    }

    return sys_addr;
80008eb0:	47f2                	lw	a5,28(sp)

80008eb2 <.L5>:
}
80008eb2:	853e                	mv	a0,a5
80008eb4:	6105                	add	sp,sp,32
80008eb6:	8082                	ret

Disassembly of section .text.usb_get_interrupts:

80008eb8 <usb_get_interrupts>:
{
80008eb8:	1141                	add	sp,sp,-16
80008eba:	c62a                	sw	a0,12(sp)
    return ptr->USBINTR;
80008ebc:	47b2                	lw	a5,12(sp)
80008ebe:	1487a783          	lw	a5,328(a5) # 180148 <__DLM_segment_end__+0xc0148>
}
80008ec2:	853e                	mv	a0,a5
80008ec4:	0141                	add	sp,sp,16
80008ec6:	8082                	ret

Disassembly of section .text.usb_enable_interrupts:

80008ec8 <usb_enable_interrupts>:
{
80008ec8:	1141                	add	sp,sp,-16
80008eca:	c62a                	sw	a0,12(sp)
80008ecc:	c42e                	sw	a1,8(sp)
    ptr->USBINTR |= mask;
80008ece:	47b2                	lw	a5,12(sp)
80008ed0:	1487a703          	lw	a4,328(a5)
80008ed4:	47a2                	lw	a5,8(sp)
80008ed6:	8f5d                	or	a4,a4,a5
80008ed8:	47b2                	lw	a5,12(sp)
80008eda:	14e7a423          	sw	a4,328(a5)
}
80008ede:	0001                	nop
80008ee0:	0141                	add	sp,sp,16
80008ee2:	8082                	ret

Disassembly of section .text.usb_get_status_flags:

80008ee4 <usb_get_status_flags>:
{
80008ee4:	1141                	add	sp,sp,-16
80008ee6:	c62a                	sw	a0,12(sp)
    return ptr->USBSTS;
80008ee8:	47b2                	lw	a5,12(sp)
80008eea:	1447a783          	lw	a5,324(a5)
}
80008eee:	853e                	mv	a0,a5
80008ef0:	0141                	add	sp,sp,16
80008ef2:	8082                	ret

Disassembly of section .text.usb_clear_status_flags:

80008ef4 <usb_clear_status_flags>:
{
80008ef4:	1141                	add	sp,sp,-16
80008ef6:	c62a                	sw	a0,12(sp)
80008ef8:	c42e                	sw	a1,8(sp)
    ptr->USBSTS = mask;
80008efa:	47b2                	lw	a5,12(sp)
80008efc:	4722                	lw	a4,8(sp)
80008efe:	14e7a223          	sw	a4,324(a5)
}
80008f02:	0001                	nop
80008f04:	0141                	add	sp,sp,16
80008f06:	8082                	ret

Disassembly of section .text.usb_get_suspend_status:

80008f08 <usb_get_suspend_status>:
{
80008f08:	1141                	add	sp,sp,-16
80008f0a:	c62a                	sw	a0,12(sp)
    return USB_PORTSC1_SUSP_GET(ptr->PORTSC1);
80008f0c:	47b2                	lw	a5,12(sp)
80008f0e:	1847a783          	lw	a5,388(a5)
80008f12:	839d                	srl	a5,a5,0x7
80008f14:	0ff7f793          	zext.b	a5,a5
80008f18:	8b85                	and	a5,a5,1
80008f1a:	0ff7f793          	zext.b	a5,a5
}
80008f1e:	853e                	mv	a0,a5
80008f20:	0141                	add	sp,sp,16
80008f22:	8082                	ret

Disassembly of section .text.usb_dcd_get_edpt_setup_status:

80008f24 <usb_dcd_get_edpt_setup_status>:
{
80008f24:	1141                	add	sp,sp,-16
80008f26:	c62a                	sw	a0,12(sp)
    return ptr->ENDPTSETUPSTAT;
80008f28:	47b2                	lw	a5,12(sp)
80008f2a:	1ac7a783          	lw	a5,428(a5)
}
80008f2e:	853e                	mv	a0,a5
80008f30:	0141                	add	sp,sp,16
80008f32:	8082                	ret

Disassembly of section .text.usb_dcd_clear_edpt_setup_status:

80008f34 <usb_dcd_clear_edpt_setup_status>:
{
80008f34:	1141                	add	sp,sp,-16
80008f36:	c62a                	sw	a0,12(sp)
80008f38:	c42e                	sw	a1,8(sp)
    ptr->ENDPTSETUPSTAT = mask;
80008f3a:	47b2                	lw	a5,12(sp)
80008f3c:	4722                	lw	a4,8(sp)
80008f3e:	1ae7a623          	sw	a4,428(a5)
}
80008f42:	0001                	nop
80008f44:	0141                	add	sp,sp,16
80008f46:	8082                	ret

Disassembly of section .text.usb_dcd_set_edpt_list_addr:

80008f48 <usb_dcd_set_edpt_list_addr>:
{
80008f48:	1141                	add	sp,sp,-16
80008f4a:	c62a                	sw	a0,12(sp)
80008f4c:	c42e                	sw	a1,8(sp)
    ptr->ENDPTLISTADDR = addr & USB_ENDPTLISTADDR_EPBASE_MASK;
80008f4e:	47a2                	lw	a5,8(sp)
80008f50:	8007f713          	and	a4,a5,-2048
80008f54:	47b2                	lw	a5,12(sp)
80008f56:	14e7ac23          	sw	a4,344(a5)
}
80008f5a:	0001                	nop
80008f5c:	0141                	add	sp,sp,16
80008f5e:	8082                	ret

Disassembly of section .text.usb_dcd_get_edpt_complete_status:

80008f60 <usb_dcd_get_edpt_complete_status>:
 *
 * @param[in] ptr A USB peripheral base address
 * @retval The complete status od endpoint
 */
static inline uint32_t usb_dcd_get_edpt_complete_status(USB_Type *ptr)
{
80008f60:	1141                	add	sp,sp,-16
80008f62:	c62a                	sw	a0,12(sp)
    return ptr->ENDPTCOMPLETE;
80008f64:	47b2                	lw	a5,12(sp)
80008f66:	1bc7a783          	lw	a5,444(a5)
}
80008f6a:	853e                	mv	a0,a5
80008f6c:	0141                	add	sp,sp,16
80008f6e:	8082                	ret

Disassembly of section .text.usb_dcd_clear_edpt_complete_status:

80008f70 <usb_dcd_clear_edpt_complete_status>:
 *
 * @param[in] ptr A USB peripheral base address
 * @param[in] mask A mask of the specified endpoints
 */
static inline void usb_dcd_clear_edpt_complete_status(USB_Type *ptr, uint32_t mask)
{
80008f70:	1141                	add	sp,sp,-16
80008f72:	c62a                	sw	a0,12(sp)
80008f74:	c42e                	sw	a1,8(sp)
    ptr->ENDPTCOMPLETE = mask;
80008f76:	47b2                	lw	a5,12(sp)
80008f78:	4722                	lw	a4,8(sp)
80008f7a:	1ae7ae23          	sw	a4,444(a5)
}
80008f7e:	0001                	nop
80008f80:	0141                	add	sp,sp,16
80008f82:	8082                	ret

Disassembly of section .text.usb_device_qhd_get:

80008f84 <usb_device_qhd_get>:
{
80008f84:	1141                	add	sp,sp,-16
80008f86:	c62a                	sw	a0,12(sp)
80008f88:	87ae                	mv	a5,a1
80008f8a:	00f105a3          	sb	a5,11(sp)
    return &handle->dcd_data->qhd[ep_idx];
80008f8e:	47b2                	lw	a5,12(sp)
80008f90:	43d8                	lw	a4,4(a5)
80008f92:	00b14783          	lbu	a5,11(sp)
80008f96:	079a                	sll	a5,a5,0x6
80008f98:	97ba                	add	a5,a5,a4
}
80008f9a:	853e                	mv	a0,a5
80008f9c:	0141                	add	sp,sp,16
80008f9e:	8082                	ret

Disassembly of section .text.usb_device_init:

80008fa0 <usb_device_init>:
{
80008fa0:	1101                	add	sp,sp,-32
80008fa2:	ce06                	sw	ra,28(sp)
80008fa4:	cc22                	sw	s0,24(sp)
80008fa6:	c62a                	sw	a0,12(sp)
80008fa8:	c42e                	sw	a1,8(sp)
    if (handle->dcd_data == NULL) {
80008faa:	47b2                	lw	a5,12(sp)
80008fac:	43dc                	lw	a5,4(a5)
80008fae:	e399                	bnez	a5,80008fb4 <.L42>
        return false;
80008fb0:	4781                	li	a5,0
80008fb2:	a8b9                	j	80009010 <.L43>

80008fb4 <.L42>:
    memset(handle->dcd_data, 0, sizeof(dcd_data_t));
80008fb4:	47b2                	lw	a5,12(sp)
80008fb6:	43d8                	lw	a4,4(a5)
80008fb8:	6785                	lui	a5,0x1
80008fba:	40078613          	add	a2,a5,1024 # 1400 <.L160>
80008fbe:	4581                	li	a1,0
80008fc0:	853a                	mv	a0,a4
80008fc2:	750030ef          	jal	8000c712 <memset>
    usb_dcd_init(handle->regs);
80008fc6:	47b2                	lw	a5,12(sp)
80008fc8:	439c                	lw	a5,0(a5)
80008fca:	853e                	mv	a0,a5
80008fcc:	593000ef          	jal	80009d5e <usb_dcd_init>
    usb_dcd_set_edpt_list_addr(handle->regs, core_local_mem_to_sys_address(0,  (uint32_t)handle->dcd_data->qhd));
80008fd0:	47b2                	lw	a5,12(sp)
80008fd2:	4380                	lw	s0,0(a5)
80008fd4:	47b2                	lw	a5,12(sp)
80008fd6:	43dc                	lw	a5,4(a5)
80008fd8:	85be                	mv	a1,a5
80008fda:	4501                	li	a0,0
80008fdc:	3db5                	jal	80008e58 <core_local_mem_to_sys_address>
80008fde:	87aa                	mv	a5,a0
80008fe0:	85be                	mv	a1,a5
80008fe2:	8522                	mv	a0,s0
80008fe4:	3795                	jal	80008f48 <usb_dcd_set_edpt_list_addr>
    usb_clear_status_flags(handle->regs, usb_get_status_flags(handle->regs));
80008fe6:	47b2                	lw	a5,12(sp)
80008fe8:	4380                	lw	s0,0(a5)
80008fea:	47b2                	lw	a5,12(sp)
80008fec:	439c                	lw	a5,0(a5)
80008fee:	853e                	mv	a0,a5
80008ff0:	3dd5                	jal	80008ee4 <usb_get_status_flags>
80008ff2:	87aa                	mv	a5,a0
80008ff4:	85be                	mv	a1,a5
80008ff6:	8522                	mv	a0,s0
80008ff8:	3df5                	jal	80008ef4 <usb_clear_status_flags>
    usb_enable_interrupts(handle->regs, int_mask);
80008ffa:	47b2                	lw	a5,12(sp)
80008ffc:	439c                	lw	a5,0(a5)
80008ffe:	45a2                	lw	a1,8(sp)
80009000:	853e                	mv	a0,a5
80009002:	35d9                	jal	80008ec8 <usb_enable_interrupts>
    usb_dcd_connect(handle->regs);
80009004:	47b2                	lw	a5,12(sp)
80009006:	439c                	lw	a5,0(a5)
80009008:	853e                	mv	a0,a5
8000900a:	c8cfc0ef          	jal	80005496 <usb_dcd_connect>
    return true;
8000900e:	4785                	li	a5,1

80009010 <.L43>:
}
80009010:	853e                	mv	a0,a5
80009012:	40f2                	lw	ra,28(sp)
80009014:	4462                	lw	s0,24(sp)
80009016:	6105                	add	sp,sp,32
80009018:	8082                	ret

Disassembly of section .text.usb_device_deinit:

8000901a <usb_device_deinit>:
{
8000901a:	7179                	add	sp,sp,-48
8000901c:	d606                	sw	ra,44(sp)
8000901e:	c62a                	sw	a0,12(sp)

80009020 <.LBB3>:
    for (uint32_t i = 0; i < USB_SOC_DCD_MAX_ENDPOINT_COUNT; i++) {
80009020:	ce02                	sw	zero,28(sp)
80009022:	a815                	j	80009056 <.L45>

80009024 <.L46>:
        usb_dcd_edpt_close(handle->regs, (i | (usb_dir_in  << 0x07)));
80009024:	47b2                	lw	a5,12(sp)
80009026:	4398                	lw	a4,0(a5)
80009028:	47f2                	lw	a5,28(sp)
8000902a:	0ff7f793          	zext.b	a5,a5
8000902e:	f807e793          	or	a5,a5,-128
80009032:	0ff7f793          	zext.b	a5,a5
80009036:	85be                	mv	a1,a5
80009038:	853a                	mv	a0,a4
8000903a:	e1afc0ef          	jal	80005654 <usb_dcd_edpt_close>
        usb_dcd_edpt_close(handle->regs, (i | (usb_dir_out << 0x07)));
8000903e:	47b2                	lw	a5,12(sp)
80009040:	439c                	lw	a5,0(a5)
80009042:	4772                	lw	a4,28(sp)
80009044:	0ff77713          	zext.b	a4,a4
80009048:	85ba                	mv	a1,a4
8000904a:	853e                	mv	a0,a5
8000904c:	e08fc0ef          	jal	80005654 <usb_dcd_edpt_close>
    for (uint32_t i = 0; i < USB_SOC_DCD_MAX_ENDPOINT_COUNT; i++) {
80009050:	47f2                	lw	a5,28(sp)
80009052:	0785                	add	a5,a5,1
80009054:	ce3e                	sw	a5,28(sp)

80009056 <.L45>:
80009056:	4772                	lw	a4,28(sp)
80009058:	479d                	li	a5,7
8000905a:	fce7f5e3          	bgeu	a5,a4,80009024 <.L46>

8000905e <.LBE3>:
    usb_dcd_deinit(handle->regs);
8000905e:	47b2                	lw	a5,12(sp)
80009060:	439c                	lw	a5,0(a5)
80009062:	853e                	mv	a0,a5
80009064:	5cd000ef          	jal	80009e30 <usb_dcd_deinit>
    memset(handle->dcd_data, 0, sizeof(dcd_data_t));
80009068:	47b2                	lw	a5,12(sp)
8000906a:	43d8                	lw	a4,4(a5)
8000906c:	6785                	lui	a5,0x1
8000906e:	40078613          	add	a2,a5,1024 # 1400 <.L160>
80009072:	4581                	li	a1,0
80009074:	853a                	mv	a0,a4
80009076:	69c030ef          	jal	8000c712 <memset>
}
8000907a:	0001                	nop
8000907c:	50b2                	lw	ra,44(sp)
8000907e:	6145                	add	sp,sp,48
80009080:	8082                	ret

Disassembly of section .text.usb_device_clear_status_flags:

80009082 <usb_device_clear_status_flags>:
{
80009082:	1101                	add	sp,sp,-32
80009084:	ce06                	sw	ra,28(sp)
80009086:	c62a                	sw	a0,12(sp)
80009088:	c42e                	sw	a1,8(sp)
    usb_clear_status_flags(handle->regs, mask);
8000908a:	47b2                	lw	a5,12(sp)
8000908c:	439c                	lw	a5,0(a5)
8000908e:	45a2                	lw	a1,8(sp)
80009090:	853e                	mv	a0,a5
80009092:	358d                	jal	80008ef4 <usb_clear_status_flags>
}
80009094:	0001                	nop
80009096:	40f2                	lw	ra,28(sp)
80009098:	6105                	add	sp,sp,32
8000909a:	8082                	ret

Disassembly of section .text.usb_device_clear_edpt_complete_status:

8000909c <usb_device_clear_edpt_complete_status>:
{
8000909c:	1101                	add	sp,sp,-32
8000909e:	ce06                	sw	ra,28(sp)
800090a0:	c62a                	sw	a0,12(sp)
800090a2:	c42e                	sw	a1,8(sp)
    usb_dcd_clear_edpt_complete_status(handle->regs, mask);
800090a4:	47b2                	lw	a5,12(sp)
800090a6:	439c                	lw	a5,0(a5)
800090a8:	45a2                	lw	a1,8(sp)
800090aa:	853e                	mv	a0,a5
800090ac:	35d1                	jal	80008f70 <usb_dcd_clear_edpt_complete_status>
}
800090ae:	0001                	nop
800090b0:	40f2                	lw	ra,28(sp)
800090b2:	6105                	add	sp,sp,32
800090b4:	8082                	ret

Disassembly of section .text.usb_device_clear_setup_status:

800090b6 <usb_device_clear_setup_status>:
{
800090b6:	1101                	add	sp,sp,-32
800090b8:	ce06                	sw	ra,28(sp)
800090ba:	c62a                	sw	a0,12(sp)
800090bc:	c42e                	sw	a1,8(sp)
    usb_dcd_clear_edpt_setup_status(handle->regs, mask);
800090be:	47b2                	lw	a5,12(sp)
800090c0:	439c                	lw	a5,0(a5)
800090c2:	45a2                	lw	a1,8(sp)
800090c4:	853e                	mv	a0,a5
800090c6:	35bd                	jal	80008f34 <usb_dcd_clear_edpt_setup_status>
}
800090c8:	0001                	nop
800090ca:	40f2                	lw	ra,28(sp)
800090cc:	6105                	add	sp,sp,32
800090ce:	8082                	ret

Disassembly of section .text.usb_device_edpt_stall:

800090d0 <usb_device_edpt_stall>:
{
800090d0:	1101                	add	sp,sp,-32
800090d2:	ce06                	sw	ra,28(sp)
800090d4:	c62a                	sw	a0,12(sp)
800090d6:	87ae                	mv	a5,a1
800090d8:	00f105a3          	sb	a5,11(sp)
    usb_dcd_edpt_stall(handle->regs, ep_addr);
800090dc:	47b2                	lw	a5,12(sp)
800090de:	439c                	lw	a5,0(a5)
800090e0:	00b14703          	lbu	a4,11(sp)
800090e4:	85ba                	mv	a1,a4
800090e6:	853e                	mv	a0,a5
800090e8:	c4afc0ef          	jal	80005532 <usb_dcd_edpt_stall>
}
800090ec:	0001                	nop
800090ee:	40f2                	lw	ra,28(sp)
800090f0:	6105                	add	sp,sp,32
800090f2:	8082                	ret

Disassembly of section .text.usb_device_edpt_clear_stall:

800090f4 <usb_device_edpt_clear_stall>:
{
800090f4:	1101                	add	sp,sp,-32
800090f6:	ce06                	sw	ra,28(sp)
800090f8:	c62a                	sw	a0,12(sp)
800090fa:	87ae                	mv	a5,a1
800090fc:	00f105a3          	sb	a5,11(sp)
    usb_dcd_edpt_clear_stall(handle->regs, ep_addr);
80009100:	47b2                	lw	a5,12(sp)
80009102:	439c                	lw	a5,0(a5)
80009104:	00b14703          	lbu	a4,11(sp)
80009108:	85ba                	mv	a1,a4
8000910a:	853e                	mv	a0,a5
8000910c:	c78fc0ef          	jal	80005584 <usb_dcd_edpt_clear_stall>
}
80009110:	0001                	nop
80009112:	40f2                	lw	ra,28(sp)
80009114:	6105                	add	sp,sp,32
80009116:	8082                	ret

Disassembly of section .text.usb_device_edpt_close:

80009118 <usb_device_edpt_close>:

void usb_device_edpt_close(usb_device_handle_t *handle, uint8_t ep_addr)
{
80009118:	1101                	add	sp,sp,-32
8000911a:	ce06                	sw	ra,28(sp)
8000911c:	c62a                	sw	a0,12(sp)
8000911e:	87ae                	mv	a5,a1
80009120:	00f105a3          	sb	a5,11(sp)
    usb_dcd_edpt_close(handle->regs, ep_addr);
80009124:	47b2                	lw	a5,12(sp)
80009126:	439c                	lw	a5,0(a5)
80009128:	00b14703          	lbu	a4,11(sp)
8000912c:	85ba                	mv	a1,a4
8000912e:	853e                	mv	a0,a5
80009130:	d24fc0ef          	jal	80005654 <usb_dcd_edpt_close>
}
80009134:	0001                	nop
80009136:	40f2                	lw	ra,28(sp)
80009138:	6105                	add	sp,sp,32
8000913a:	8082                	ret

Disassembly of section .text.dma_setup_channel:

8000913c <dma_setup_channel>:
 */

#include "hpm_dma_drv.h"

hpm_stat_t dma_setup_channel(DMA_Type *ptr, uint8_t ch_num, dma_channel_config_t *ch, bool start_transfer)
{
8000913c:	1101                	add	sp,sp,-32
8000913e:	c62a                	sw	a0,12(sp)
80009140:	87ae                	mv	a5,a1
80009142:	c232                	sw	a2,4(sp)
80009144:	8736                	mv	a4,a3
80009146:	00f105a3          	sb	a5,11(sp)
8000914a:	87ba                	mv	a5,a4
8000914c:	00f10523          	sb	a5,10(sp)
    uint32_t tmp;

    if ((ch->dst_width > DMA_SOC_TRANSFER_WIDTH_MAX(ptr))
80009150:	4792                	lw	a5,4(sp)
80009152:	0057c783          	lbu	a5,5(a5)
80009156:	86be                	mv	a3,a5
80009158:	4732                	lw	a4,12(sp)
8000915a:	f30487b7          	lui	a5,0xf3048
8000915e:	00f71463          	bne	a4,a5,80009166 <.L11>
80009162:	478d                	li	a5,3
80009164:	a011                	j	80009168 <.L12>

80009166 <.L11>:
80009166:	4789                	li	a5,2

80009168 <.L12>:
80009168:	04d7e163          	bltu	a5,a3,800091aa <.L13>
       || (ch->src_width > DMA_SOC_TRANSFER_WIDTH_MAX(ptr))
8000916c:	4792                	lw	a5,4(sp)
8000916e:	0047c783          	lbu	a5,4(a5) # f3048004 <__AHB_SRAM_segment_end__+0x2d40004>
80009172:	86be                	mv	a3,a5
80009174:	4732                	lw	a4,12(sp)
80009176:	f30487b7          	lui	a5,0xf3048
8000917a:	00f71463          	bne	a4,a5,80009182 <.L14>
8000917e:	478d                	li	a5,3
80009180:	a011                	j	80009184 <.L15>

80009182 <.L14>:
80009182:	4789                	li	a5,2

80009184 <.L15>:
80009184:	02d7e363          	bltu	a5,a3,800091aa <.L13>
       || (ch_num >= DMA_SOC_CHANNEL_NUM)
80009188:	00b14703          	lbu	a4,11(sp)
8000918c:	479d                	li	a5,7
8000918e:	00e7ee63          	bltu	a5,a4,800091aa <.L13>
       || ((ch->dst_mode == DMA_HANDSHAKE_MODE_HANDSHAKE) && (ch->src_mode == DMA_HANDSHAKE_MODE_HANDSHAKE))) {
80009192:	4792                	lw	a5,4(sp)
80009194:	0037c703          	lbu	a4,3(a5) # f3048003 <__AHB_SRAM_segment_end__+0x2d40003>
80009198:	4785                	li	a5,1
8000919a:	00f71a63          	bne	a4,a5,800091ae <.L16>
8000919e:	4792                	lw	a5,4(sp)
800091a0:	0027c703          	lbu	a4,2(a5)
800091a4:	4785                	li	a5,1
800091a6:	00f71463          	bne	a4,a5,800091ae <.L16>

800091aa <.L13>:
        return status_invalid_argument;
800091aa:	4789                	li	a5,2
800091ac:	a27d                	j	8000935a <.L17>

800091ae <.L16>:
    }
    if ((ch->size_in_byte & ((1 << ch->dst_width) - 1))
800091ae:	4792                	lw	a5,4(sp)
800091b0:	4f9c                	lw	a5,24(a5)
800091b2:	4712                	lw	a4,4(sp)
800091b4:	00574703          	lbu	a4,5(a4)
800091b8:	86ba                	mv	a3,a4
800091ba:	4705                	li	a4,1
800091bc:	00d71733          	sll	a4,a4,a3
800091c0:	177d                	add	a4,a4,-1
800091c2:	8ff9                	and	a5,a5,a4
800091c4:	efa1                	bnez	a5,8000921c <.L18>
     || (ch->src_addr & ((1 << ch->src_width) - 1))
800091c6:	4792                	lw	a5,4(sp)
800091c8:	47dc                	lw	a5,12(a5)
800091ca:	4712                	lw	a4,4(sp)
800091cc:	00474703          	lbu	a4,4(a4)
800091d0:	86ba                	mv	a3,a4
800091d2:	4705                	li	a4,1
800091d4:	00d71733          	sll	a4,a4,a3
800091d8:	177d                	add	a4,a4,-1
800091da:	8ff9                	and	a5,a5,a4
800091dc:	e3a1                	bnez	a5,8000921c <.L18>
     || (ch->dst_addr & ((1 << ch->dst_width) - 1))
800091de:	4792                	lw	a5,4(sp)
800091e0:	4b9c                	lw	a5,16(a5)
800091e2:	4712                	lw	a4,4(sp)
800091e4:	00574703          	lbu	a4,5(a4)
800091e8:	86ba                	mv	a3,a4
800091ea:	4705                	li	a4,1
800091ec:	00d71733          	sll	a4,a4,a3
800091f0:	177d                	add	a4,a4,-1
800091f2:	8ff9                	and	a5,a5,a4
800091f4:	e785                	bnez	a5,8000921c <.L18>
     || ((1 << ch->src_width) & ((1 << ch->dst_width) - 1))
800091f6:	4792                	lw	a5,4(sp)
800091f8:	0057c783          	lbu	a5,5(a5)
800091fc:	873e                	mv	a4,a5
800091fe:	4785                	li	a5,1
80009200:	00e797b3          	sll	a5,a5,a4
80009204:	17fd                	add	a5,a5,-1
80009206:	4712                	lw	a4,4(sp)
80009208:	00474703          	lbu	a4,4(a4)
8000920c:	40e7d7b3          	sra	a5,a5,a4
80009210:	8b85                	and	a5,a5,1
80009212:	e789                	bnez	a5,8000921c <.L18>
     || ((ch->linked_ptr & 0x7))) {
80009214:	4792                	lw	a5,4(sp)
80009216:	4bdc                	lw	a5,20(a5)
80009218:	8b9d                	and	a5,a5,7
8000921a:	c789                	beqz	a5,80009224 <.L19>

8000921c <.L18>:
        return status_dma_alignment_error;
8000921c:	6789                	lui	a5,0x2
8000921e:	f4478793          	add	a5,a5,-188 # 1f44 <.L73+0xe>
80009222:	aa25                	j	8000935a <.L17>

80009224 <.L19>:
    }
    ptr->CHCTRL[ch_num].SRCADDR = DMA_CHCTRL_SRCADDR_SRCADDRL_SET(ch->src_addr);
80009224:	00b14783          	lbu	a5,11(sp)
80009228:	4712                	lw	a4,4(sp)
8000922a:	4758                	lw	a4,12(a4)
8000922c:	46b2                	lw	a3,12(sp)
8000922e:	0789                	add	a5,a5,2
80009230:	0796                	sll	a5,a5,0x5
80009232:	97b6                	add	a5,a5,a3
80009234:	c798                	sw	a4,8(a5)
    ptr->CHCTRL[ch_num].DSTADDR = DMA_CHCTRL_DSTADDR_DSTADDRL_SET(ch->dst_addr);
80009236:	00b14783          	lbu	a5,11(sp)
8000923a:	4712                	lw	a4,4(sp)
8000923c:	4b18                	lw	a4,16(a4)
8000923e:	46b2                	lw	a3,12(sp)
80009240:	0796                	sll	a5,a5,0x5
80009242:	97b6                	add	a5,a5,a3
80009244:	cbb8                	sw	a4,80(a5)
    ptr->CHCTRL[ch_num].TRANSIZE = DMA_CHCTRL_TRANSIZE_TRANSIZE_SET(ch->size_in_byte >> ch->src_width);
80009246:	4792                	lw	a5,4(sp)
80009248:	4f98                	lw	a4,24(a5)
8000924a:	4792                	lw	a5,4(sp)
8000924c:	0047c783          	lbu	a5,4(a5)
80009250:	86be                	mv	a3,a5
80009252:	00b14783          	lbu	a5,11(sp)
80009256:	00d75733          	srl	a4,a4,a3
8000925a:	46b2                	lw	a3,12(sp)
8000925c:	0789                	add	a5,a5,2
8000925e:	0796                	sll	a5,a5,0x5
80009260:	97b6                	add	a5,a5,a3
80009262:	c3d8                	sw	a4,4(a5)
    ptr->CHCTRL[ch_num].LLPOINTER = DMA_CHCTRL_LLPOINTER_LLPOINTERL_SET(ch->linked_ptr >> DMA_CHCTRL_LLPOINTER_LLPOINTERL_SHIFT);
80009264:	4792                	lw	a5,4(sp)
80009266:	4bd8                	lw	a4,20(a5)
80009268:	00b14783          	lbu	a5,11(sp)
8000926c:	9b61                	and	a4,a4,-8
8000926e:	46b2                	lw	a3,12(sp)
80009270:	0796                	sll	a5,a5,0x5
80009272:	97b6                	add	a5,a5,a3
80009274:	cfb8                	sw	a4,88(a5)
    ptr->CHCTRL[ch_num].SRCADDRH = DMA_CHCTRL_SRCADDRH_SRCADDRH_SET(ch->src_addr_high);
    ptr->CHCTRL[ch_num].DSTADDRH = DMA_CHCTRL_DSTADDRH_DSTADDRH_SET(ch->dst_addr_high);
    ptr->CHCTRL[ch_num].LLPOINTERH = DMA_CHCTRL_LLPOINTERH_LLPOINTERH_SET(ch->linked_ptr_high);
#endif

    ptr->INTSTATUS = (DMA_INTSTATUS_TC_SET(1) | DMA_INTSTATUS_ABORT_SET(1) | DMA_INTSTATUS_ERROR_SET(1)) << ch_num;
80009276:	00b14783          	lbu	a5,11(sp)
8000927a:	6741                	lui	a4,0x10
8000927c:	10170713          	add	a4,a4,257 # 10101 <__XPI0_segment_used_size__+0x2d49>
80009280:	00f71733          	sll	a4,a4,a5
80009284:	47b2                	lw	a5,12(sp)
80009286:	db98                	sw	a4,48(a5)
    tmp = DMA_CHCTRL_CTRL_SRCBUSINFIDX_SET(0)
        | DMA_CHCTRL_CTRL_DSTBUSINFIDX_SET(0)
        | DMA_CHCTRL_CTRL_PRIORITY_SET(ch->priority)
80009288:	4792                	lw	a5,4(sp)
8000928a:	0007c783          	lbu	a5,0(a5)
8000928e:	01d79713          	sll	a4,a5,0x1d
80009292:	200007b7          	lui	a5,0x20000
80009296:	8f7d                	and	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCBURSTSIZE_SET(ch->src_burst_size)
80009298:	4792                	lw	a5,4(sp)
8000929a:	0017c783          	lbu	a5,1(a5) # 20000001 <_extram_size+0x1e000001>
8000929e:	01879693          	sll	a3,a5,0x18
800092a2:	0f0007b7          	lui	a5,0xf000
800092a6:	8ff5                	and	a5,a5,a3
800092a8:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCWIDTH_SET(ch->src_width)
800092aa:	4792                	lw	a5,4(sp)
800092ac:	0047c783          	lbu	a5,4(a5) # f000004 <_extram_size+0xd000004>
800092b0:	01579693          	sll	a3,a5,0x15
800092b4:	00e007b7          	lui	a5,0xe00
800092b8:	8ff5                	and	a5,a5,a3
800092ba:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_DSTWIDTH_SET(ch->dst_width)
800092bc:	4792                	lw	a5,4(sp)
800092be:	0057c783          	lbu	a5,5(a5) # e00005 <__DLM_segment_end__+0xd40005>
800092c2:	01279693          	sll	a3,a5,0x12
800092c6:	001c07b7          	lui	a5,0x1c0
800092ca:	8ff5                	and	a5,a5,a3
800092cc:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCMODE_SET(ch->src_mode)
800092ce:	4792                	lw	a5,4(sp)
800092d0:	0027c783          	lbu	a5,2(a5) # 1c0002 <__DLM_segment_end__+0x100002>
800092d4:	01179693          	sll	a3,a5,0x11
800092d8:	000207b7          	lui	a5,0x20
800092dc:	8ff5                	and	a5,a5,a3
800092de:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_DSTMODE_SET(ch->dst_mode)
800092e0:	4792                	lw	a5,4(sp)
800092e2:	0037c783          	lbu	a5,3(a5) # 20003 <__XPI0_segment_used_size__+0x12c4b>
800092e6:	01079693          	sll	a3,a5,0x10
800092ea:	67c1                	lui	a5,0x10
800092ec:	8ff5                	and	a5,a5,a3
800092ee:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCADDRCTRL_SET(ch->src_addr_ctrl)
800092f0:	4792                	lw	a5,4(sp)
800092f2:	0067c783          	lbu	a5,6(a5) # 10006 <__XPI0_segment_used_size__+0x2c4e>
800092f6:	00e79693          	sll	a3,a5,0xe
800092fa:	67c1                	lui	a5,0x10
800092fc:	17fd                	add	a5,a5,-1 # ffff <__XPI0_segment_used_size__+0x2c47>
800092fe:	8ff5                	and	a5,a5,a3
80009300:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_DSTADDRCTRL_SET(ch->dst_addr_ctrl)
80009302:	4792                	lw	a5,4(sp)
80009304:	0077c783          	lbu	a5,7(a5)
80009308:	00c79693          	sll	a3,a5,0xc
8000930c:	678d                	lui	a5,0x3
8000930e:	8ff5                	and	a5,a5,a3
80009310:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_SRCREQSEL_SET(ch_num)
80009312:	00b14783          	lbu	a5,11(sp)
80009316:	00879693          	sll	a3,a5,0x8
8000931a:	6785                	lui	a5,0x1
8000931c:	f0078793          	add	a5,a5,-256 # f00 <_etoa+0x18>
80009320:	8ff5                	and	a5,a5,a3
80009322:	8f5d                	or	a4,a4,a5
        | DMA_CHCTRL_CTRL_DSTREQSEL_SET(ch_num)
80009324:	00b14783          	lbu	a5,11(sp)
80009328:	0792                	sll	a5,a5,0x4
8000932a:	0ff7f793          	zext.b	a5,a5
8000932e:	8fd9                	or	a5,a5,a4
        | ch->interrupt_mask;
80009330:	4712                	lw	a4,4(sp)
80009332:	00875703          	lhu	a4,8(a4)
    tmp = DMA_CHCTRL_CTRL_SRCBUSINFIDX_SET(0)
80009336:	8fd9                	or	a5,a5,a4
80009338:	ce3e                	sw	a5,28(sp)

    if (start_transfer) {
8000933a:	00a14783          	lbu	a5,10(sp)
8000933e:	c789                	beqz	a5,80009348 <.L20>
        tmp |= DMA_CHCTRL_CTRL_ENABLE_MASK;
80009340:	47f2                	lw	a5,28(sp)
80009342:	0017e793          	or	a5,a5,1
80009346:	ce3e                	sw	a5,28(sp)

80009348 <.L20>:
    }
    ptr->CHCTRL[ch_num].CTRL = tmp;
80009348:	00b14783          	lbu	a5,11(sp)
8000934c:	4732                	lw	a4,12(sp)
8000934e:	0789                	add	a5,a5,2
80009350:	0796                	sll	a5,a5,0x5
80009352:	97ba                	add	a5,a5,a4
80009354:	4772                	lw	a4,28(sp)
80009356:	c398                	sw	a4,0(a5)

    return status_success;
80009358:	4781                	li	a5,0

8000935a <.L17>:
}
8000935a:	853e                	mv	a0,a5
8000935c:	6105                	add	sp,sp,32
8000935e:	8082                	ret

Disassembly of section .text.dma_default_channel_config:

80009360 <dma_default_channel_config>:


void dma_default_channel_config(DMA_Type *ptr, dma_channel_config_t *ch)
{
80009360:	1141                	add	sp,sp,-16
80009362:	c62a                	sw	a0,12(sp)
80009364:	c42e                	sw	a1,8(sp)
    (void) ptr;
    ch->priority = DMA_CHANNEL_PRIORITY_LOW;
80009366:	47a2                	lw	a5,8(sp)
80009368:	00078023          	sb	zero,0(a5)
    ch->src_mode = DMA_HANDSHAKE_MODE_NORMAL;
8000936c:	47a2                	lw	a5,8(sp)
8000936e:	00078123          	sb	zero,2(a5)
    ch->dst_mode = DMA_HANDSHAKE_MODE_NORMAL;
80009372:	47a2                	lw	a5,8(sp)
80009374:	000781a3          	sb	zero,3(a5)
    ch->src_burst_size = DMA_NUM_TRANSFER_PER_BURST_1T;
80009378:	47a2                	lw	a5,8(sp)
8000937a:	000780a3          	sb	zero,1(a5)
    ch->src_addr_ctrl = DMA_ADDRESS_CONTROL_INCREMENT;
8000937e:	47a2                	lw	a5,8(sp)
80009380:	00078323          	sb	zero,6(a5)
    ch->dst_addr_ctrl = DMA_ADDRESS_CONTROL_INCREMENT;
80009384:	47a2                	lw	a5,8(sp)
80009386:	000783a3          	sb	zero,7(a5)
    ch->interrupt_mask = DMA_INTERRUPT_MASK_NONE;
8000938a:	47a2                	lw	a5,8(sp)
8000938c:	00079423          	sh	zero,8(a5)
    ch->linked_ptr = 0;
80009390:	47a2                	lw	a5,8(sp)
80009392:	0007aa23          	sw	zero,20(a5)
#if DMA_SUPPORT_64BIT_ADDR
    ch->linked_ptr_high = 0;
#endif
}
80009396:	0001                	nop
80009398:	0141                	add	sp,sp,16
8000939a:	8082                	ret

Disassembly of section .text.dma_setup_handshake:

8000939c <dma_setup_handshake>:
    (void) ptr;
    memset(config, 0, sizeof(dma_handshake_config_t));
}

hpm_stat_t dma_setup_handshake(DMA_Type *ptr,  dma_handshake_config_t *pconfig, bool start_transfer)
{
8000939c:	7139                	add	sp,sp,-64
8000939e:	de06                	sw	ra,60(sp)
800093a0:	c62a                	sw	a0,12(sp)
800093a2:	c42e                	sw	a1,8(sp)
800093a4:	87b2                	mv	a5,a2
800093a6:	00f103a3          	sb	a5,7(sp)
    hpm_stat_t stat = status_success;
800093aa:	d602                	sw	zero,44(sp)
    dma_channel_config_t config = {0};
800093ac:	c802                	sw	zero,16(sp)
800093ae:	ca02                	sw	zero,20(sp)
800093b0:	cc02                	sw	zero,24(sp)
800093b2:	ce02                	sw	zero,28(sp)
800093b4:	d002                	sw	zero,32(sp)
800093b6:	d202                	sw	zero,36(sp)
800093b8:	d402                	sw	zero,40(sp)
    dma_default_channel_config(ptr, &config);
800093ba:	081c                	add	a5,sp,16
800093bc:	85be                	mv	a1,a5
800093be:	4532                	lw	a0,12(sp)
800093c0:	3745                	jal	80009360 <dma_default_channel_config>

    if (true == pconfig->dst_fixed) {
800093c2:	47a2                	lw	a5,8(sp)
800093c4:	00e7c783          	lbu	a5,14(a5)
800093c8:	c799                	beqz	a5,800093d6 <.L57>
        config.dst_addr_ctrl = DMA_ADDRESS_CONTROL_FIXED;
800093ca:	4789                	li	a5,2
800093cc:	00f10ba3          	sb	a5,23(sp)
        config.dst_mode = DMA_HANDSHAKE_MODE_HANDSHAKE;
800093d0:	4785                	li	a5,1
800093d2:	00f109a3          	sb	a5,19(sp)

800093d6 <.L57>:
    }
    if (true == pconfig->src_fixed) {
800093d6:	47a2                	lw	a5,8(sp)
800093d8:	00f7c783          	lbu	a5,15(a5)
800093dc:	c799                	beqz	a5,800093ea <.L58>
        config.src_addr_ctrl = DMA_ADDRESS_CONTROL_FIXED;
800093de:	4789                	li	a5,2
800093e0:	00f10b23          	sb	a5,22(sp)
        config.src_mode = DMA_HANDSHAKE_MODE_HANDSHAKE;
800093e4:	4785                	li	a5,1
800093e6:	00f10923          	sb	a5,18(sp)

800093ea <.L58>:
    }

    if (pconfig->ch_index >= DMA_SOC_CHANNEL_NUM) {
800093ea:	47a2                	lw	a5,8(sp)
800093ec:	00d7c703          	lbu	a4,13(a5)
800093f0:	479d                	li	a5,7
800093f2:	00e7f463          	bgeu	a5,a4,800093fa <.L59>
        return status_invalid_argument;
800093f6:	4789                	li	a5,2
800093f8:	a0b1                	j	80009444 <.L62>

800093fa <.L59>:
    }

    config.src_width = pconfig->data_width;
800093fa:	47a2                	lw	a5,8(sp)
800093fc:	00c7c783          	lbu	a5,12(a5)
80009400:	00f10a23          	sb	a5,20(sp)
    config.dst_width = pconfig->data_width;
80009404:	47a2                	lw	a5,8(sp)
80009406:	00c7c783          	lbu	a5,12(a5)
8000940a:	00f10aa3          	sb	a5,21(sp)
    config.src_addr = pconfig->src;
8000940e:	47a2                	lw	a5,8(sp)
80009410:	43dc                	lw	a5,4(a5)
80009412:	ce3e                	sw	a5,28(sp)
    config.dst_addr = pconfig->dst;
80009414:	47a2                	lw	a5,8(sp)
80009416:	439c                	lw	a5,0(a5)
80009418:	d03e                	sw	a5,32(sp)
    config.size_in_byte = pconfig->size_in_byte;
8000941a:	47a2                	lw	a5,8(sp)
8000941c:	479c                	lw	a5,8(a5)
8000941e:	d43e                	sw	a5,40(sp)
    /*  In DMA handshake case, source burst size must be 1 transfer, that is 0. */
    config.src_burst_size = 0;
80009420:	000108a3          	sb	zero,17(sp)
    stat = dma_setup_channel(ptr, pconfig->ch_index, &config, start_transfer);
80009424:	47a2                	lw	a5,8(sp)
80009426:	00d7c783          	lbu	a5,13(a5)
8000942a:	00714683          	lbu	a3,7(sp)
8000942e:	0818                	add	a4,sp,16
80009430:	863a                	mv	a2,a4
80009432:	85be                	mv	a1,a5
80009434:	4532                	lw	a0,12(sp)
80009436:	3319                	jal	8000913c <dma_setup_channel>
80009438:	d62a                	sw	a0,44(sp)
    if (stat != status_success) {
8000943a:	57b2                	lw	a5,44(sp)
8000943c:	c399                	beqz	a5,80009442 <.L61>
        return stat;
8000943e:	57b2                	lw	a5,44(sp)
80009440:	a011                	j	80009444 <.L62>

80009442 <.L61>:
    }
    return stat;
80009442:	57b2                	lw	a5,44(sp)

80009444 <.L62>:
}
80009444:	853e                	mv	a0,a5
80009446:	50f2                	lw	ra,60(sp)
80009448:	6121                	add	sp,sp,64
8000944a:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

8000944c <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
8000944c:	1101                	add	sp,sp,-32
8000944e:	c62a                	sw	a0,12(sp)
80009450:	87ae                	mv	a5,a1
80009452:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80009456:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
80009458:	00a15703          	lhu	a4,10(sp)
8000945c:	25700793          	li	a5,599
80009460:	00e7f863          	bgeu	a5,a4,80009470 <.L26>
80009464:	00a15703          	lhu	a4,10(sp)
80009468:	55f00793          	li	a5,1375
8000946c:	00e7f463          	bgeu	a5,a4,80009474 <.L27>

80009470 <.L26>:
        return status_invalid_argument;
80009470:	4789                	li	a5,2
80009472:	a831                	j	8000948e <.L28>

80009474 <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80009474:	47b2                	lw	a5,12(sp)
80009476:	4b98                	lw	a4,16(a5)
80009478:	77fd                	lui	a5,0xfffff
8000947a:	8f7d                	and	a4,a4,a5
8000947c:	00a15683          	lhu	a3,10(sp)
80009480:	6785                	lui	a5,0x1
80009482:	17fd                	add	a5,a5,-1 # fff <.L144+0x37>
80009484:	8ff5                	and	a5,a5,a3
80009486:	8f5d                	or	a4,a4,a5
80009488:	47b2                	lw	a5,12(sp)
8000948a:	cb98                	sw	a4,16(a5)
    return stat;
8000948c:	47f2                	lw	a5,28(sp)

8000948e <.L28>:
}
8000948e:	853e                	mv	a0,a5
80009490:	6105                	add	sp,sp,32
80009492:	8082                	ret

Disassembly of section .text.pllctl_pll_powerdown:

80009494 <pllctl_pll_powerdown>:
{
80009494:	1141                	add	sp,sp,-16
80009496:	c62a                	sw	a0,12(sp)
80009498:	87ae                	mv	a5,a1
8000949a:	00f105a3          	sb	a5,11(sp)
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
8000949e:	00b14703          	lbu	a4,11(sp)
800094a2:	4791                	li	a5,4
800094a4:	00e7f463          	bgeu	a5,a4,800094ac <.L5>
        return status_invalid_argument;
800094a8:	4789                	li	a5,2
800094aa:	a805                	j	800094da <.L6>

800094ac <.L5>:
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
800094ac:	00b14783          	lbu	a5,11(sp)
800094b0:	4732                	lw	a4,12(sp)
800094b2:	0785                	add	a5,a5,1
800094b4:	079e                	sll	a5,a5,0x7
800094b6:	97ba                	add	a5,a5,a4
800094b8:	43d8                	lw	a4,4(a5)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
800094ba:	7a0007b7          	lui	a5,0x7a000
800094be:	17fd                	add	a5,a5,-1 # 79ffffff <_extram_size+0x77ffffff>
800094c0:	00f776b3          	and	a3,a4,a5
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
800094c4:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
800094c8:	02000737          	lui	a4,0x2000
800094cc:	8f55                	or	a4,a4,a3
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
800094ce:	46b2                	lw	a3,12(sp)
800094d0:	0785                	add	a5,a5,1
800094d2:	079e                	sll	a5,a5,0x7
800094d4:	97b6                	add	a5,a5,a3
800094d6:	c3d8                	sw	a4,4(a5)
    return status_success;
800094d8:	4781                	li	a5,0

800094da <.L6>:
}
800094da:	853e                	mv	a0,a5
800094dc:	0141                	add	sp,sp,16
800094de:	8082                	ret

Disassembly of section .text.pllctl_init_int_pll_with_freq:

800094e0 <pllctl_init_int_pll_with_freq>:
    return status_success;
}

hpm_stat_t pllctl_init_int_pll_with_freq(PLLCTL_Type *ptr, uint8_t pll,
                                    uint32_t freq_in_hz)
{
800094e0:	7179                	add	sp,sp,-48
800094e2:	d606                	sw	ra,44(sp)
800094e4:	c62a                	sw	a0,12(sp)
800094e6:	87ae                	mv	a5,a1
800094e8:	c232                	sw	a2,4(sp)
800094ea:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
800094ee:	47b2                	lw	a5,12(sp)
800094f0:	c791                	beqz	a5,800094fc <.L27>
800094f2:	00b14703          	lbu	a4,11(sp)
800094f6:	4791                	li	a5,4
800094f8:	00e7f463          	bgeu	a5,a4,80009500 <.L28>

800094fc <.L27>:
        return status_invalid_argument;
800094fc:	4789                	li	a5,2
800094fe:	ac09                	j	80009710 <.L29>

80009500 <.L28>:
    }
    uint32_t freq, fbdiv, refdiv, postdiv;
    if ((freq_in_hz < PLLCTL_PLL_VCO_FREQ_MIN)
80009500:	4712                	lw	a4,4(sp)
80009502:	165a17b7          	lui	a5,0x165a1
80009506:	bbf78793          	add	a5,a5,-1089 # 165a0bbf <_extram_size+0x145a0bbf>
8000950a:	00e7f963          	bgeu	a5,a4,8000951c <.L30>
            || (freq_in_hz > PLLCTL_PLL_VCO_FREQ_MAX)) {
8000950e:	4712                	lw	a4,4(sp)
80009510:	832157b7          	lui	a5,0x83215
80009514:	60078793          	add	a5,a5,1536 # 83215600 <__XPI0_segment_end__+0x2215600>
80009518:	00e7f463          	bgeu	a5,a4,80009520 <.L31>

8000951c <.L30>:
        return status_invalid_argument;
8000951c:	4789                	li	a5,2
8000951e:	aacd                	j	80009710 <.L29>

80009520 <.L31>:
    }

    freq = freq_in_hz;
80009520:	4792                	lw	a5,4(sp)
80009522:	ca3e                	sw	a5,20(sp)
    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
80009524:	00b14783          	lbu	a5,11(sp)
80009528:	4732                	lw	a4,12(sp)
8000952a:	0785                	add	a5,a5,1
8000952c:	079e                	sll	a5,a5,0x7
8000952e:	97ba                	add	a5,a5,a4
80009530:	439c                	lw	a5,0(a5)
80009532:	83e1                	srl	a5,a5,0x18
80009534:	03f7f793          	and	a5,a5,63
80009538:	cc3e                	sw	a5,24(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
8000953a:	00b14783          	lbu	a5,11(sp)
8000953e:	4732                	lw	a4,12(sp)
80009540:	0785                	add	a5,a5,1
80009542:	079e                	sll	a5,a5,0x7
80009544:	97ba                	add	a5,a5,a4
80009546:	439c                	lw	a5,0(a5)
80009548:	83d1                	srl	a5,a5,0x14
8000954a:	8b9d                	and	a5,a5,7
8000954c:	c83e                	sw	a5,16(sp)
    fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000954e:	4762                	lw	a4,24(sp)
80009550:	47c2                	lw	a5,16(sp)
80009552:	02f707b3          	mul	a5,a4,a5
80009556:	016e3737          	lui	a4,0x16e3
8000955a:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000955e:	02f757b3          	divu	a5,a4,a5
80009562:	4752                	lw	a4,20(sp)
80009564:	02f757b3          	divu	a5,a4,a5
80009568:	ce3e                	sw	a5,28(sp)
    if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
8000956a:	4772                	lw	a4,28(sp)
8000956c:	6785                	lui	a5,0x1
8000956e:	96078793          	add	a5,a5,-1696 # 960 <.L217+0x8>
80009572:	04e7f163          	bgeu	a5,a4,800095b4 <.L32>
        /* current refdiv can't be used for the given frequency */
        refdiv--;
80009576:	47e2                	lw	a5,24(sp)
80009578:	17fd                	add	a5,a5,-1
8000957a:	cc3e                	sw	a5,24(sp)

8000957c <.L36>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000957c:	4762                	lw	a4,24(sp)
8000957e:	47c2                	lw	a5,16(sp)
80009580:	02f707b3          	mul	a5,a4,a5
80009584:	016e3737          	lui	a4,0x16e3
80009588:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000958c:	02f757b3          	divu	a5,a4,a5
80009590:	4752                	lw	a4,20(sp)
80009592:	02f757b3          	divu	a5,a4,a5
80009596:	ce3e                	sw	a5,28(sp)
            if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
80009598:	4772                	lw	a4,28(sp)
8000959a:	6785                	lui	a5,0x1
8000959c:	96078793          	add	a5,a5,-1696 # 960 <.L217+0x8>
800095a0:	04e7fc63          	bgeu	a5,a4,800095f8 <.L45>
                refdiv--;
800095a4:	47e2                	lw	a5,24(sp)
800095a6:	17fd                	add	a5,a5,-1
800095a8:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv > PLLCTL_PLL_MIN_REFDIV);
800095aa:	4762                	lw	a4,24(sp)
800095ac:	4785                	li	a5,1
800095ae:	fce7e7e3          	bltu	a5,a4,8000957c <.L36>
800095b2:	a0b1                	j	800095fe <.L37>

800095b4 <.L32>:
    } else if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
800095b4:	4772                	lw	a4,28(sp)
800095b6:	47bd                	li	a5,15
800095b8:	04e7e363          	bltu	a5,a4,800095fe <.L37>
        /* current refdiv can't be used for the given frequency */
        refdiv++;
800095bc:	47e2                	lw	a5,24(sp)
800095be:	0785                	add	a5,a5,1
800095c0:	cc3e                	sw	a5,24(sp)

800095c2 <.L40>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
800095c2:	4762                	lw	a4,24(sp)
800095c4:	47c2                	lw	a5,16(sp)
800095c6:	02f707b3          	mul	a5,a4,a5
800095ca:	016e3737          	lui	a4,0x16e3
800095ce:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
800095d2:	02f757b3          	divu	a5,a4,a5
800095d6:	4752                	lw	a4,20(sp)
800095d8:	02f757b3          	divu	a5,a4,a5
800095dc:	ce3e                	sw	a5,28(sp)
            if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
800095de:	4772                	lw	a4,28(sp)
800095e0:	47bd                	li	a5,15
800095e2:	00e7ed63          	bltu	a5,a4,800095fc <.L46>
                refdiv++;
800095e6:	47e2                	lw	a5,24(sp)
800095e8:	0785                	add	a5,a5,1
800095ea:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv < PLLCTL_PLL_MAX_REFDIV);
800095ec:	4762                	lw	a4,24(sp)
800095ee:	03e00793          	li	a5,62
800095f2:	fce7f8e3          	bgeu	a5,a4,800095c2 <.L40>
800095f6:	a021                	j	800095fe <.L37>

800095f8 <.L45>:
                break;
800095f8:	0001                	nop
800095fa:	a011                	j	800095fe <.L37>

800095fc <.L46>:
                break;
800095fc:	0001                	nop

800095fe <.L37>:
    }

    if ((refdiv > PLLCTL_PLL_MAX_REFDIV)
800095fe:	4762                	lw	a4,24(sp)
80009600:	03f00793          	li	a5,63
80009604:	02e7eb63          	bltu	a5,a4,8000963a <.L41>
            || (refdiv < PLLCTL_PLL_MIN_REFDIV)
80009608:	47e2                	lw	a5,24(sp)
8000960a:	cb85                	beqz	a5,8000963a <.L41>
            || (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV)
8000960c:	4772                	lw	a4,28(sp)
8000960e:	6785                	lui	a5,0x1
80009610:	96078793          	add	a5,a5,-1696 # 960 <.L217+0x8>
80009614:	02e7e363          	bltu	a5,a4,8000963a <.L41>
            || (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV)
80009618:	4772                	lw	a4,28(sp)
8000961a:	47bd                	li	a5,15
8000961c:	00e7ff63          	bgeu	a5,a4,8000963a <.L41>
            || (((PLLCTL_SOC_PLL_REFCLK_FREQ / refdiv) < PLLCTL_INT_PLL_MIN_REF))) {
80009620:	016e37b7          	lui	a5,0x16e3
80009624:	60078713          	add	a4,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80009628:	47e2                	lw	a5,24(sp)
8000962a:	02f75733          	divu	a4,a4,a5
8000962e:	000f47b7          	lui	a5,0xf4
80009632:	23f78793          	add	a5,a5,575 # f423f <__DLM_segment_end__+0x3423f>
80009636:	00e7e663          	bltu	a5,a4,80009642 <.L42>

8000963a <.L41>:
        return status_pllctl_out_of_range;
8000963a:	6799                	lui	a5,0x6
8000963c:	9da78793          	add	a5,a5,-1574 # 59da <__NONCACHEABLE_RAM_segment_used_size__+0x2d2>
80009640:	a8c1                	j	80009710 <.L29>

80009642 <.L42>:
    }

    if (!(ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK)) {
80009642:	00b14783          	lbu	a5,11(sp)
80009646:	4732                	lw	a4,12(sp)
80009648:	0785                	add	a5,a5,1
8000964a:	079e                	sll	a5,a5,0x7
8000964c:	97ba                	add	a5,a5,a4
8000964e:	439c                	lw	a5,0(a5)
80009650:	8ba1                	and	a5,a5,8
80009652:	e795                	bnez	a5,8000967e <.L43>
        /* it was at frac mode, then it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
80009654:	00b14783          	lbu	a5,11(sp)
80009658:	85be                	mv	a1,a5
8000965a:	4532                	lw	a0,12(sp)
8000965c:	3d25                	jal	80009494 <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 |= PLLCTL_PLL_CFG0_DSMPD_MASK;
8000965e:	00b14783          	lbu	a5,11(sp)
80009662:	4732                	lw	a4,12(sp)
80009664:	0785                	add	a5,a5,1
80009666:	079e                	sll	a5,a5,0x7
80009668:	97ba                	add	a5,a5,a4
8000966a:	4398                	lw	a4,0(a5)
8000966c:	00b14783          	lbu	a5,11(sp)
80009670:	00876713          	or	a4,a4,8
80009674:	46b2                	lw	a3,12(sp)
80009676:	0785                	add	a5,a5,1
80009678:	079e                	sll	a5,a5,0x7
8000967a:	97b6                	add	a5,a5,a3
8000967c:	c398                	sw	a4,0(a5)

8000967e <.L43>:
    }

    if (PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0) != refdiv) {
8000967e:	00b14783          	lbu	a5,11(sp)
80009682:	4732                	lw	a4,12(sp)
80009684:	0785                	add	a5,a5,1
80009686:	079e                	sll	a5,a5,0x7
80009688:	97ba                	add	a5,a5,a4
8000968a:	439c                	lw	a5,0(a5)
8000968c:	83e1                	srl	a5,a5,0x18
8000968e:	03f7f793          	and	a5,a5,63
80009692:	4762                	lw	a4,24(sp)
80009694:	04f70163          	beq	a4,a5,800096d6 <.L44>
        /* if refdiv is different, it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
80009698:	00b14783          	lbu	a5,11(sp)
8000969c:	85be                	mv	a1,a5
8000969e:	4532                	lw	a0,12(sp)
800096a0:	3bd5                	jal	80009494 <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
800096a2:	00b14783          	lbu	a5,11(sp)
800096a6:	4732                	lw	a4,12(sp)
800096a8:	0785                	add	a5,a5,1
800096aa:	079e                	sll	a5,a5,0x7
800096ac:	97ba                	add	a5,a5,a4
800096ae:	4398                	lw	a4,0(a5)
800096b0:	c10007b7          	lui	a5,0xc1000
800096b4:	17fd                	add	a5,a5,-1 # c0ffffff <__XPI0_segment_end__+0x3fffffff>
800096b6:	00f776b3          	and	a3,a4,a5
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
800096ba:	47e2                	lw	a5,24(sp)
800096bc:	01879713          	sll	a4,a5,0x18
800096c0:	3f0007b7          	lui	a5,0x3f000
800096c4:	8f7d                	and	a4,a4,a5
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
800096c6:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
800096ca:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
800096cc:	46b2                	lw	a3,12(sp)
800096ce:	0785                	add	a5,a5,1 # 3f000001 <_extram_size+0x3d000001>
800096d0:	079e                	sll	a5,a5,0x7
800096d2:	97b6                	add	a5,a5,a3
800096d4:	c398                	sw	a4,0(a5)

800096d6 <.L44>:
    }

    ptr->PLL[pll].CFG2 = (ptr->PLL[pll].CFG2 & ~(PLLCTL_PLL_CFG2_FBDIV_INT_MASK)) | PLLCTL_PLL_CFG2_FBDIV_INT_SET(fbdiv);
800096d6:	00b14783          	lbu	a5,11(sp)
800096da:	4732                	lw	a4,12(sp)
800096dc:	0785                	add	a5,a5,1
800096de:	079e                	sll	a5,a5,0x7
800096e0:	97ba                	add	a5,a5,a4
800096e2:	4798                	lw	a4,8(a5)
800096e4:	77fd                	lui	a5,0xfffff
800096e6:	00f776b3          	and	a3,a4,a5
800096ea:	4772                	lw	a4,28(sp)
800096ec:	6785                	lui	a5,0x1
800096ee:	17fd                	add	a5,a5,-1 # fff <.L144+0x37>
800096f0:	8f7d                	and	a4,a4,a5
800096f2:	00b14783          	lbu	a5,11(sp)
800096f6:	8f55                	or	a4,a4,a3
800096f8:	46b2                	lw	a3,12(sp)
800096fa:	0785                	add	a5,a5,1
800096fc:	079e                	sll	a5,a5,0x7
800096fe:	97b6                	add	a5,a5,a3
80009700:	c798                	sw	a4,8(a5)

    pllctl_pll_poweron(ptr, pll);
80009702:	00b14783          	lbu	a5,11(sp)
80009706:	85be                	mv	a1,a5
80009708:	4532                	lw	a0,12(sp)
8000970a:	c74fb0ef          	jal	80004b7e <pllctl_pll_poweron>
    return status_success;
8000970e:	4781                	li	a5,0

80009710 <.L29>:
}
80009710:	853e                	mv	a0,a5
80009712:	50b2                	lw	ra,44(sp)
80009714:	6145                	add	sp,sp,48
80009716:	8082                	ret

Disassembly of section .text.pllctl_get_pll_freq_in_hz:

80009718 <pllctl_get_pll_freq_in_hz>:
    pllctl_pll_poweron(ptr, pll);
    return status_success;
}

uint32_t pllctl_get_pll_freq_in_hz(PLLCTL_Type *ptr, uint8_t pll)
{
80009718:	715d                	add	sp,sp,-80
8000971a:	c686                	sw	ra,76(sp)
8000971c:	c4a2                	sw	s0,72(sp)
8000971e:	c2a6                	sw	s1,68(sp)
80009720:	c0ca                	sw	s2,64(sp)
80009722:	de4e                	sw	s3,60(sp)
80009724:	c62a                	sw	a0,12(sp)
80009726:	87ae                	mv	a5,a1
80009728:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
8000972c:	47b2                	lw	a5,12(sp)
8000972e:	c791                	beqz	a5,8000973a <.L67>
80009730:	00b14703          	lbu	a4,11(sp)
80009734:	4791                	li	a5,4
80009736:	00e7f463          	bgeu	a5,a4,8000973e <.L68>

8000973a <.L67>:
        return status_invalid_argument;
8000973a:	4789                	li	a5,2
8000973c:	aa35                	j	80009878 <.L69>

8000973e <.L68>:
    }
    uint32_t fbdiv, frac, refdiv, postdiv, refclk, freq;
    if (ptr->PLL[pll].CFG1 & PLLCTL_PLL_CFG1_PLLPD_SW_MASK) {
8000973e:	00b14783          	lbu	a5,11(sp)
80009742:	4732                	lw	a4,12(sp)
80009744:	0785                	add	a5,a5,1
80009746:	079e                	sll	a5,a5,0x7
80009748:	97ba                	add	a5,a5,a4
8000974a:	43d8                	lw	a4,4(a5)
8000974c:	020007b7          	lui	a5,0x2000
80009750:	8ff9                	and	a5,a5,a4
80009752:	c399                	beqz	a5,80009758 <.L70>
        /* pll is powered down */
        return 0;
80009754:	4781                	li	a5,0
80009756:	a20d                	j	80009878 <.L69>

80009758 <.L70>:
    }

    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
80009758:	00b14783          	lbu	a5,11(sp)
8000975c:	4732                	lw	a4,12(sp)
8000975e:	0785                	add	a5,a5,1 # 2000001 <_extram_size+0x1>
80009760:	079e                	sll	a5,a5,0x7
80009762:	97ba                	add	a5,a5,a4
80009764:	439c                	lw	a5,0(a5)
80009766:	83e1                	srl	a5,a5,0x18
80009768:	03f7f793          	and	a5,a5,63
8000976c:	d43e                	sw	a5,40(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
8000976e:	00b14783          	lbu	a5,11(sp)
80009772:	4732                	lw	a4,12(sp)
80009774:	0785                	add	a5,a5,1
80009776:	079e                	sll	a5,a5,0x7
80009778:	97ba                	add	a5,a5,a4
8000977a:	439c                	lw	a5,0(a5)
8000977c:	83d1                	srl	a5,a5,0x14
8000977e:	8b9d                	and	a5,a5,7
80009780:	d23e                	sw	a5,36(sp)
    refclk = PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv);
80009782:	5722                	lw	a4,40(sp)
80009784:	5792                	lw	a5,36(sp)
80009786:	02f707b3          	mul	a5,a4,a5
8000978a:	016e3737          	lui	a4,0x16e3
8000978e:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
80009792:	02f757b3          	divu	a5,a4,a5
80009796:	d03e                	sw	a5,32(sp)

    if (ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK) {
80009798:	00b14783          	lbu	a5,11(sp)
8000979c:	4732                	lw	a4,12(sp)
8000979e:	0785                	add	a5,a5,1
800097a0:	079e                	sll	a5,a5,0x7
800097a2:	97ba                	add	a5,a5,a4
800097a4:	439c                	lw	a5,0(a5)
800097a6:	8ba1                	and	a5,a5,8
800097a8:	c395                	beqz	a5,800097cc <.L71>
        /* pll int mode */
        fbdiv = PLLCTL_PLL_CFG2_FBDIV_INT_GET(ptr->PLL[pll].CFG2);
800097aa:	00b14783          	lbu	a5,11(sp)
800097ae:	4732                	lw	a4,12(sp)
800097b0:	0785                	add	a5,a5,1
800097b2:	079e                	sll	a5,a5,0x7
800097b4:	97ba                	add	a5,a5,a4
800097b6:	4798                	lw	a4,8(a5)
800097b8:	6785                	lui	a5,0x1
800097ba:	17fd                	add	a5,a5,-1 # fff <.L144+0x37>
800097bc:	8ff9                	and	a5,a5,a4
800097be:	ce3e                	sw	a5,28(sp)
        freq = refclk * fbdiv;
800097c0:	5702                	lw	a4,32(sp)
800097c2:	47f2                	lw	a5,28(sp)
800097c4:	02f707b3          	mul	a5,a4,a5
800097c8:	d63e                	sw	a5,44(sp)
800097ca:	a075                	j	80009876 <.L72>

800097cc <.L71>:
    } else {
        /* pll frac mode */
        fbdiv = PLLCTL_PLL_FREQ_FBDIV_FRAC_GET(ptr->PLL[pll].FREQ);
800097cc:	00b14783          	lbu	a5,11(sp)
800097d0:	4732                	lw	a4,12(sp)
800097d2:	0785                	add	a5,a5,1
800097d4:	079e                	sll	a5,a5,0x7
800097d6:	97ba                	add	a5,a5,a4
800097d8:	47dc                	lw	a5,12(a5)
800097da:	0ff7f793          	zext.b	a5,a5
800097de:	ce3e                	sw	a5,28(sp)
        frac = PLLCTL_PLL_FREQ_FRAC_GET(ptr->PLL[pll].FREQ);
800097e0:	00b14783          	lbu	a5,11(sp)
800097e4:	4732                	lw	a4,12(sp)
800097e6:	0785                	add	a5,a5,1
800097e8:	079e                	sll	a5,a5,0x7
800097ea:	97ba                	add	a5,a5,a4
800097ec:	47dc                	lw	a5,12(a5)
800097ee:	0087d713          	srl	a4,a5,0x8
800097f2:	010007b7          	lui	a5,0x1000
800097f6:	17fd                	add	a5,a5,-1 # ffffff <__XPI0_segment_size__+0x2fff>
800097f8:	8ff9                	and	a5,a5,a4
800097fa:	cc3e                	sw	a5,24(sp)
        freq = (uint32_t)((refclk * (fbdiv + ((double) frac / (1 << 24)))) + 0.5);
800097fc:	5502                	lw	a0,32(sp)
800097fe:	531020ef          	jal	8000c52e <__floatunsidf>
80009802:	842a                	mv	s0,a0
80009804:	84ae                	mv	s1,a1
80009806:	4572                	lw	a0,28(sp)
80009808:	527020ef          	jal	8000c52e <__floatunsidf>
8000980c:	892a                	mv	s2,a0
8000980e:	89ae                	mv	s3,a1
80009810:	4562                	lw	a0,24(sp)
80009812:	51d020ef          	jal	8000c52e <__floatunsidf>
80009816:	872a                	mv	a4,a0
80009818:	87ae                	mv	a5,a1
8000981a:	800036b7          	lui	a3,0x80003
8000981e:	0886a603          	lw	a2,136(a3) # 80003088 <.LC1>
80009822:	08c6a683          	lw	a3,140(a3)
80009826:	853a                	mv	a0,a4
80009828:	85be                	mv	a1,a5
8000982a:	235020ef          	jal	8000c25e <__divdf3>
8000982e:	872a                	mv	a4,a0
80009830:	87ae                	mv	a5,a1
80009832:	863a                	mv	a2,a4
80009834:	86be                	mv	a3,a5
80009836:	854a                	mv	a0,s2
80009838:	85ce                	mv	a1,s3
8000983a:	488020ef          	jal	8000bcc2 <__adddf3>
8000983e:	872a                	mv	a4,a0
80009840:	87ae                	mv	a5,a1
80009842:	863a                	mv	a2,a4
80009844:	86be                	mv	a3,a5
80009846:	8522                	mv	a0,s0
80009848:	85a6                	mv	a1,s1
8000984a:	001020ef          	jal	8000c04a <__muldf3>
8000984e:	872a                	mv	a4,a0
80009850:	87ae                	mv	a5,a1
80009852:	853a                	mv	a0,a4
80009854:	85be                	mv	a1,a5
80009856:	800037b7          	lui	a5,0x80003
8000985a:	0907a603          	lw	a2,144(a5) # 80003090 <.LC2>
8000985e:	0947a683          	lw	a3,148(a5)
80009862:	460020ef          	jal	8000bcc2 <__adddf3>
80009866:	872a                	mv	a4,a0
80009868:	87ae                	mv	a5,a1
8000986a:	853a                	mv	a0,a4
8000986c:	85be                	mv	a1,a5
8000986e:	efcfe0ef          	jal	80007f6a <__fixunsdfsi>
80009872:	87aa                	mv	a5,a0
80009874:	d63e                	sw	a5,44(sp)

80009876 <.L72>:
    }
    return freq;
80009876:	57b2                	lw	a5,44(sp)

80009878 <.L69>:
}
80009878:	853e                	mv	a0,a5
8000987a:	40b6                	lw	ra,76(sp)
8000987c:	4426                	lw	s0,72(sp)
8000987e:	4496                	lw	s1,68(sp)
80009880:	4906                	lw	s2,64(sp)
80009882:	59f2                	lw	s3,60(sp)
80009884:	6161                	add	sp,sp,80
80009886:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

80009888 <write_pmp_cfg>:
{
80009888:	1141                	add	sp,sp,-16
8000988a:	c62a                	sw	a0,12(sp)
8000988c:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000988e:	4722                	lw	a4,8(sp)
80009890:	478d                	li	a5,3
80009892:	04f70163          	beq	a4,a5,800098d4 <.L11>
80009896:	4722                	lw	a4,8(sp)
80009898:	478d                	li	a5,3
8000989a:	04e7e163          	bltu	a5,a4,800098dc <.L17>
8000989e:	4722                	lw	a4,8(sp)
800098a0:	4789                	li	a5,2
800098a2:	02f70563          	beq	a4,a5,800098cc <.L13>
800098a6:	4722                	lw	a4,8(sp)
800098a8:	4789                	li	a5,2
800098aa:	02e7e963          	bltu	a5,a4,800098dc <.L17>
800098ae:	47a2                	lw	a5,8(sp)
800098b0:	c791                	beqz	a5,800098bc <.L14>
800098b2:	4722                	lw	a4,8(sp)
800098b4:	4785                	li	a5,1
800098b6:	00f70763          	beq	a4,a5,800098c4 <.L15>
        break;
800098ba:	a00d                	j	800098dc <.L17>

800098bc <.L14>:
        write_csr(CSR_PMPCFG0, value);
800098bc:	47b2                	lw	a5,12(sp)
800098be:	3a079073          	csrw	pmpcfg0,a5
        break;
800098c2:	a831                	j	800098de <.L16>

800098c4 <.L15>:
        write_csr(CSR_PMPCFG1, value);
800098c4:	47b2                	lw	a5,12(sp)
800098c6:	3a179073          	csrw	pmpcfg1,a5
        break;
800098ca:	a811                	j	800098de <.L16>

800098cc <.L13>:
        write_csr(CSR_PMPCFG2, value);
800098cc:	47b2                	lw	a5,12(sp)
800098ce:	3a279073          	csrw	pmpcfg2,a5
        break;
800098d2:	a031                	j	800098de <.L16>

800098d4 <.L11>:
        write_csr(CSR_PMPCFG3, value);
800098d4:	47b2                	lw	a5,12(sp)
800098d6:	3a379073          	csrw	pmpcfg3,a5
        break;
800098da:	a011                	j	800098de <.L16>

800098dc <.L17>:
        break;
800098dc:	0001                	nop

800098de <.L16>:
}
800098de:	0001                	nop
800098e0:	0141                	add	sp,sp,16
800098e2:	8082                	ret

Disassembly of section .text.write_pma_cfg:

800098e4 <write_pma_cfg>:
{
800098e4:	1141                	add	sp,sp,-16
800098e6:	c62a                	sw	a0,12(sp)
800098e8:	c42e                	sw	a1,8(sp)
    switch (idx) {
800098ea:	4722                	lw	a4,8(sp)
800098ec:	478d                	li	a5,3
800098ee:	04f70163          	beq	a4,a5,80009930 <.L71>
800098f2:	4722                	lw	a4,8(sp)
800098f4:	478d                	li	a5,3
800098f6:	04e7e163          	bltu	a5,a4,80009938 <.L77>
800098fa:	4722                	lw	a4,8(sp)
800098fc:	4789                	li	a5,2
800098fe:	02f70563          	beq	a4,a5,80009928 <.L73>
80009902:	4722                	lw	a4,8(sp)
80009904:	4789                	li	a5,2
80009906:	02e7e963          	bltu	a5,a4,80009938 <.L77>
8000990a:	47a2                	lw	a5,8(sp)
8000990c:	c791                	beqz	a5,80009918 <.L74>
8000990e:	4722                	lw	a4,8(sp)
80009910:	4785                	li	a5,1
80009912:	00f70763          	beq	a4,a5,80009920 <.L75>
        break;
80009916:	a00d                	j	80009938 <.L77>

80009918 <.L74>:
        write_csr(CSR_PMACFG0, value);
80009918:	47b2                	lw	a5,12(sp)
8000991a:	bc079073          	csrw	0xbc0,a5
        break;
8000991e:	a831                	j	8000993a <.L76>

80009920 <.L75>:
        write_csr(CSR_PMACFG1, value);
80009920:	47b2                	lw	a5,12(sp)
80009922:	bc179073          	csrw	0xbc1,a5
        break;
80009926:	a811                	j	8000993a <.L76>

80009928 <.L73>:
        write_csr(CSR_PMACFG2, value);
80009928:	47b2                	lw	a5,12(sp)
8000992a:	bc279073          	csrw	0xbc2,a5
        break;
8000992e:	a031                	j	8000993a <.L76>

80009930 <.L71>:
        write_csr(CSR_PMACFG3, value);
80009930:	47b2                	lw	a5,12(sp)
80009932:	bc379073          	csrw	0xbc3,a5
        break;
80009936:	a011                	j	8000993a <.L76>

80009938 <.L77>:
        break;
80009938:	0001                	nop

8000993a <.L76>:
}
8000993a:	0001                	nop
8000993c:	0141                	add	sp,sp,16
8000993e:	8082                	ret

Disassembly of section .text.uart_modem_config:

80009940 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
80009940:	1141                	add	sp,sp,-16
80009942:	c62a                	sw	a0,12(sp)
80009944:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80009946:	47a2                	lw	a5,8(sp)
80009948:	0007c783          	lbu	a5,0(a5)
8000994c:	0796                	sll	a5,a5,0x5
8000994e:	0207f713          	and	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
80009952:	47a2                	lw	a5,8(sp)
80009954:	0017c783          	lbu	a5,1(a5)
80009958:	0792                	sll	a5,a5,0x4
8000995a:	8bc1                	and	a5,a5,16
8000995c:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
8000995e:	47a2                	lw	a5,8(sp)
80009960:	0027c783          	lbu	a5,2(a5)
80009964:	0017c793          	xor	a5,a5,1
80009968:	0ff7f793          	zext.b	a5,a5
8000996c:	0786                	sll	a5,a5,0x1
8000996e:	8b89                	and	a5,a5,2
80009970:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80009972:	47b2                	lw	a5,12(sp)
80009974:	db98                	sw	a4,48(a5)
}
80009976:	0001                	nop
80009978:	0141                	add	sp,sp,16
8000997a:	8082                	ret

Disassembly of section .text.uart_init:

8000997c <uart_init>:
{
8000997c:	7179                	add	sp,sp,-48
8000997e:	d606                	sw	ra,44(sp)
80009980:	c62a                	sw	a0,12(sp)
80009982:	c42e                	sw	a1,8(sp)
    ptr->IER = 0;
80009984:	47b2                	lw	a5,12(sp)
80009986:	0207a223          	sw	zero,36(a5)
    ptr->LCR |= UART_LCR_DLAB_MASK;
8000998a:	47b2                	lw	a5,12(sp)
8000998c:	57dc                	lw	a5,44(a5)
8000998e:	0807e713          	or	a4,a5,128
80009992:	47b2                	lw	a5,12(sp)
80009994:	d7d8                	sw	a4,44(a5)
    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
80009996:	47a2                	lw	a5,8(sp)
80009998:	4398                	lw	a4,0(a5)
8000999a:	47a2                	lw	a5,8(sp)
8000999c:	43dc                	lw	a5,4(a5)
8000999e:	01b10693          	add	a3,sp,27
800099a2:	0830                	add	a2,sp,24
800099a4:	85be                	mv	a1,a5
800099a6:	853a                	mv	a0,a4
800099a8:	8e3fb0ef          	jal	8000528a <uart_calculate_baudrate>
800099ac:	87aa                	mv	a5,a0
800099ae:	0017c793          	xor	a5,a5,1
800099b2:	0ff7f793          	zext.b	a5,a5
800099b6:	c781                	beqz	a5,800099be <.L25>
        return status_uart_no_suitable_baudrate_parameter_found;
800099b8:	3e900793          	li	a5,1001
800099bc:	aa2d                	j	80009af6 <.L41>

800099be <.L25>:
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
800099be:	47b2                	lw	a5,12(sp)
800099c0:	4bdc                	lw	a5,20(a5)
800099c2:	fe07f713          	and	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
800099c6:	01b14783          	lbu	a5,27(sp)
800099ca:	8bfd                	and	a5,a5,31
800099cc:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
800099ce:	47b2                	lw	a5,12(sp)
800099d0:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
800099d2:	01815783          	lhu	a5,24(sp)
800099d6:	0ff7f713          	zext.b	a4,a5
800099da:	47b2                	lw	a5,12(sp)
800099dc:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
800099de:	01815783          	lhu	a5,24(sp)
800099e2:	83a1                	srl	a5,a5,0x8
800099e4:	07c2                	sll	a5,a5,0x10
800099e6:	83c1                	srl	a5,a5,0x10
800099e8:	0ff7f713          	zext.b	a4,a5
800099ec:	47b2                	lw	a5,12(sp)
800099ee:	d3d8                	sw	a4,36(a5)
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
800099f0:	47b2                	lw	a5,12(sp)
800099f2:	57dc                	lw	a5,44(a5)
800099f4:	f7f7f793          	and	a5,a5,-129
800099f8:	ce3e                	sw	a5,28(sp)
    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
800099fa:	47f2                	lw	a5,28(sp)
800099fc:	fc77f793          	and	a5,a5,-57
80009a00:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
80009a02:	47a2                	lw	a5,8(sp)
80009a04:	00a7c783          	lbu	a5,10(a5)
80009a08:	4711                	li	a4,4
80009a0a:	02f76f63          	bltu	a4,a5,80009a48 <.L27>
80009a0e:	00279713          	sll	a4,a5,0x2
80009a12:	800037b7          	lui	a5,0x80003
80009a16:	45878793          	add	a5,a5,1112 # 80003458 <.L29>
80009a1a:	97ba                	add	a5,a5,a4
80009a1c:	439c                	lw	a5,0(a5)
80009a1e:	8782                	jr	a5

80009a20 <.L32>:
        tmp |= UART_LCR_PEN_MASK;
80009a20:	47f2                	lw	a5,28(sp)
80009a22:	0087e793          	or	a5,a5,8
80009a26:	ce3e                	sw	a5,28(sp)
        break;
80009a28:	a01d                	j	80009a4e <.L34>

80009a2a <.L31>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
80009a2a:	47f2                	lw	a5,28(sp)
80009a2c:	0187e793          	or	a5,a5,24
80009a30:	ce3e                	sw	a5,28(sp)
        break;
80009a32:	a831                	j	80009a4e <.L34>

80009a34 <.L30>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
80009a34:	47f2                	lw	a5,28(sp)
80009a36:	0287e793          	or	a5,a5,40
80009a3a:	ce3e                	sw	a5,28(sp)
        break;
80009a3c:	a809                	j	80009a4e <.L34>

80009a3e <.L28>:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
80009a3e:	47f2                	lw	a5,28(sp)
80009a40:	0387e793          	or	a5,a5,56
80009a44:	ce3e                	sw	a5,28(sp)
        break;
80009a46:	a021                	j	80009a4e <.L34>

80009a48 <.L27>:
        return status_invalid_argument;
80009a48:	4789                	li	a5,2
80009a4a:	a075                	j	80009af6 <.L41>

80009a4c <.L42>:
        break;
80009a4c:	0001                	nop

80009a4e <.L34>:
    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
80009a4e:	47f2                	lw	a5,28(sp)
80009a50:	9be1                	and	a5,a5,-8
80009a52:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
80009a54:	47a2                	lw	a5,8(sp)
80009a56:	0087c783          	lbu	a5,8(a5)
80009a5a:	4709                	li	a4,2
80009a5c:	00e78e63          	beq	a5,a4,80009a78 <.L35>
80009a60:	4709                	li	a4,2
80009a62:	02f74663          	blt	a4,a5,80009a8e <.L36>
80009a66:	c795                	beqz	a5,80009a92 <.L43>
80009a68:	4705                	li	a4,1
80009a6a:	02e79263          	bne	a5,a4,80009a8e <.L36>
        tmp |= UART_LCR_STB_MASK;
80009a6e:	47f2                	lw	a5,28(sp)
80009a70:	0047e793          	or	a5,a5,4
80009a74:	ce3e                	sw	a5,28(sp)
        break;
80009a76:	a839                	j	80009a94 <.L39>

80009a78 <.L35>:
        if (config->word_length < word_length_6_bits) {
80009a78:	47a2                	lw	a5,8(sp)
80009a7a:	0097c783          	lbu	a5,9(a5)
80009a7e:	e399                	bnez	a5,80009a84 <.L40>
            return status_invalid_argument;
80009a80:	4789                	li	a5,2
80009a82:	a895                	j	80009af6 <.L41>

80009a84 <.L40>:
        tmp |= UART_LCR_STB_MASK;
80009a84:	47f2                	lw	a5,28(sp)
80009a86:	0047e793          	or	a5,a5,4
80009a8a:	ce3e                	sw	a5,28(sp)
        break;
80009a8c:	a021                	j	80009a94 <.L39>

80009a8e <.L36>:
        return status_invalid_argument;
80009a8e:	4789                	li	a5,2
80009a90:	a09d                	j	80009af6 <.L41>

80009a92 <.L43>:
        break;
80009a92:	0001                	nop

80009a94 <.L39>:
    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
80009a94:	47a2                	lw	a5,8(sp)
80009a96:	0097c783          	lbu	a5,9(a5)
80009a9a:	0037f713          	and	a4,a5,3
80009a9e:	47f2                	lw	a5,28(sp)
80009aa0:	8f5d                	or	a4,a4,a5
80009aa2:	47b2                	lw	a5,12(sp)
80009aa4:	d7d8                	sw	a4,44(a5)
    ptr->FCR = UART_FCR_TFIFORST_MASK | UART_FCR_RFIFORST_MASK;
80009aa6:	47b2                	lw	a5,12(sp)
80009aa8:	4719                	li	a4,6
80009aaa:	d798                	sw	a4,40(a5)
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
80009aac:	47a2                	lw	a5,8(sp)
80009aae:	00e7c783          	lbu	a5,14(a5)
80009ab2:	873e                	mv	a4,a5
        | UART_FCR_TFIFOT_SET(config->tx_fifo_level)
80009ab4:	47a2                	lw	a5,8(sp)
80009ab6:	00b7c783          	lbu	a5,11(a5)
80009aba:	0792                	sll	a5,a5,0x4
80009abc:	0307f793          	and	a5,a5,48
80009ac0:	8f5d                	or	a4,a4,a5
        | UART_FCR_RFIFOT_SET(config->rx_fifo_level)
80009ac2:	47a2                	lw	a5,8(sp)
80009ac4:	00c7c783          	lbu	a5,12(a5)
80009ac8:	079a                	sll	a5,a5,0x6
80009aca:	0ff7f793          	zext.b	a5,a5
80009ace:	8f5d                	or	a4,a4,a5
        | UART_FCR_DMAE_SET(config->dma_enable);
80009ad0:	47a2                	lw	a5,8(sp)
80009ad2:	00d7c783          	lbu	a5,13(a5)
80009ad6:	078e                	sll	a5,a5,0x3
80009ad8:	8ba1                	and	a5,a5,8
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
80009ada:	8fd9                	or	a5,a5,a4
80009adc:	ce3e                	sw	a5,28(sp)
    ptr->FCR = tmp;
80009ade:	47b2                	lw	a5,12(sp)
80009ae0:	4772                	lw	a4,28(sp)
80009ae2:	d798                	sw	a4,40(a5)
    ptr->GPR = tmp;
80009ae4:	47b2                	lw	a5,12(sp)
80009ae6:	4772                	lw	a4,28(sp)
80009ae8:	dfd8                	sw	a4,60(a5)
    uart_modem_config(ptr, &config->modem_config);
80009aea:	47a2                	lw	a5,8(sp)
80009aec:	07bd                	add	a5,a5,15
80009aee:	85be                	mv	a1,a5
80009af0:	4532                	lw	a0,12(sp)
80009af2:	35b9                	jal	80009940 <uart_modem_config>
    return status_success;
80009af4:	4781                	li	a5,0

80009af6 <.L41>:
}
80009af6:	853e                	mv	a0,a5
80009af8:	50b2                	lw	ra,44(sp)
80009afa:	6145                	add	sp,sp,48
80009afc:	8082                	ret

Disassembly of section .text.uart_flush:

80009afe <uart_flush>:

hpm_stat_t uart_flush(UART_Type *ptr)
{
80009afe:	1101                	add	sp,sp,-32
80009b00:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
80009b02:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80009b04:	a811                	j	80009b18 <.L57>

80009b06 <.L60>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
80009b06:	4772                	lw	a4,28(sp)
80009b08:	6785                	lui	a5,0x1
80009b0a:	38878793          	add	a5,a5,904 # 1388 <.L154+0xa>
80009b0e:	00e7eb63          	bltu	a5,a4,80009b24 <.L63>
            break;
        }
        retry++;
80009b12:	47f2                	lw	a5,28(sp)
80009b14:	0785                	add	a5,a5,1
80009b16:	ce3e                	sw	a5,28(sp)

80009b18 <.L57>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80009b18:	47b2                	lw	a5,12(sp)
80009b1a:	5bdc                	lw	a5,52(a5)
80009b1c:	0407f793          	and	a5,a5,64
80009b20:	d3fd                	beqz	a5,80009b06 <.L60>
80009b22:	a011                	j	80009b26 <.L59>

80009b24 <.L63>:
            break;
80009b24:	0001                	nop

80009b26 <.L59>:
    }
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
80009b26:	4772                	lw	a4,28(sp)
80009b28:	6785                	lui	a5,0x1
80009b2a:	38878793          	add	a5,a5,904 # 1388 <.L154+0xa>
80009b2e:	00e7f463          	bgeu	a5,a4,80009b36 <.L61>
        return status_timeout;
80009b32:	478d                	li	a5,3
80009b34:	a011                	j	80009b38 <.L62>

80009b36 <.L61>:
    }

    return status_success;
80009b36:	4781                	li	a5,0

80009b38 <.L62>:
}
80009b38:	853e                	mv	a0,a5
80009b3a:	6105                	add	sp,sp,32
80009b3c:	8082                	ret

Disassembly of section .text.uart_try_receive_byte:

80009b3e <uart_try_receive_byte>:
    *byte = ptr->RBR & UART_RBR_RBR_MASK;
    return status_success;
}

hpm_stat_t uart_try_receive_byte(UART_Type *ptr, uint8_t *byte)
{
80009b3e:	1141                	add	sp,sp,-16
80009b40:	c62a                	sw	a0,12(sp)
80009b42:	c42e                	sw	a1,8(sp)
    if (!(ptr->LSR & UART_LSR_DR_MASK)) {
80009b44:	47b2                	lw	a5,12(sp)
80009b46:	5bdc                	lw	a5,52(a5)
80009b48:	8b85                	and	a5,a5,1
80009b4a:	e399                	bnez	a5,80009b50 <.L73>
        return status_fail;
80009b4c:	4785                	li	a5,1
80009b4e:	a809                	j	80009b60 <.L74>

80009b50 <.L73>:
    } else {
        *byte = ptr->RBR & UART_RBR_RBR_MASK;
80009b50:	47b2                	lw	a5,12(sp)
80009b52:	539c                	lw	a5,32(a5)
80009b54:	0ff7f713          	zext.b	a4,a5
80009b58:	47a2                	lw	a5,8(sp)
80009b5a:	00e78023          	sb	a4,0(a5)
        return status_success;
80009b5e:	4781                	li	a5,0

80009b60 <.L74>:
    }
}
80009b60:	853e                	mv	a0,a5
80009b62:	0141                	add	sp,sp,16
80009b64:	8082                	ret

Disassembly of section .text.usb_phy_enable_dp_dm_pulldown:

80009b66 <usb_phy_enable_dp_dm_pulldown>:
{
80009b66:	1141                	add	sp,sp,-16
80009b68:	c62a                	sw	a0,12(sp)
    ptr->PHY_CTRL0 &= ~0x001000E0u;
80009b6a:	47b2                	lw	a5,12(sp)
80009b6c:	2107a703          	lw	a4,528(a5)
80009b70:	fff007b7          	lui	a5,0xfff00
80009b74:	f1f78793          	add	a5,a5,-225 # ffefff1f <__APB_SRAM_segment_end__+0xbe0df1f>
80009b78:	8f7d                	and	a4,a4,a5
80009b7a:	47b2                	lw	a5,12(sp)
80009b7c:	20e7a823          	sw	a4,528(a5)
}
80009b80:	0001                	nop
80009b82:	0141                	add	sp,sp,16
80009b84:	8082                	ret

Disassembly of section .text.usb_phy_deinit:

80009b86 <usb_phy_deinit>:
{
80009b86:	1101                	add	sp,sp,-32
80009b88:	c62a                	sw	a0,12(sp)
    ptr->PHY_CTRL1 &= ~USB_PHY_CTRL1_UTMI_OTG_SUSPENDM_MASK;       /* clear otg_suspendm */
80009b8a:	47b2                	lw	a5,12(sp)
80009b8c:	2147a783          	lw	a5,532(a5)
80009b90:	ffd7f713          	and	a4,a5,-3
80009b94:	47b2                	lw	a5,12(sp)
80009b96:	20e7aa23          	sw	a4,532(a5)
    ptr->PHY_CTRL1 &= ~USB_PHY_CTRL1_UTMI_CFG_RST_N_MASK;          /* clear cfg_rst_n */
80009b9a:	47b2                	lw	a5,12(sp)
80009b9c:	2147a703          	lw	a4,532(a5)
80009ba0:	fff007b7          	lui	a5,0xfff00
80009ba4:	17fd                	add	a5,a5,-1 # ffefffff <__APB_SRAM_segment_end__+0xbe0dfff>
80009ba6:	8f7d                	and	a4,a4,a5
80009ba8:	47b2                	lw	a5,12(sp)
80009baa:	20e7aa23          	sw	a4,532(a5)
    ptr->OTG_CTRL0 |= USB_OTG_CTRL0_OTG_UTMI_RESET_SW_MASK;        /* set otg_utmi_reset_sw for naneng usbphy */
80009bae:	47b2                	lw	a5,12(sp)
80009bb0:	2007a703          	lw	a4,512(a5)
80009bb4:	6785                	lui	a5,0x1
80009bb6:	80078793          	add	a5,a5,-2048 # 800 <.L195+0xa>
80009bba:	8f5d                	or	a4,a4,a5
80009bbc:	47b2                	lw	a5,12(sp)
80009bbe:	20e7a023          	sw	a4,512(a5)

80009bc2 <.LBB2>:
    for (volatile uint32_t i = 0; i < USB_PHY_INIT_DELAY_COUNT; i++) {
80009bc2:	cc02                	sw	zero,24(sp)
80009bc4:	a039                	j	80009bd2 <.L13>

80009bc6 <.L14>:
        (void)ptr->PHY_CTRL1;                                      /* used for delay, at least 1us */
80009bc6:	47b2                	lw	a5,12(sp)
80009bc8:	2147a783          	lw	a5,532(a5)
    for (volatile uint32_t i = 0; i < USB_PHY_INIT_DELAY_COUNT; i++) {
80009bcc:	47e2                	lw	a5,24(sp)
80009bce:	0785                	add	a5,a5,1
80009bd0:	cc3e                	sw	a5,24(sp)

80009bd2 <.L13>:
80009bd2:	4762                	lw	a4,24(sp)
80009bd4:	06300793          	li	a5,99
80009bd8:	fee7f7e3          	bgeu	a5,a4,80009bc6 <.L14>

80009bdc <.LBE2>:
    ptr->OTG_CTRL0 &= ~USB_OTG_CTRL0_OTG_UTMI_SUSPENDM_SW_MASK;     /* clear otg_utmi_suspend_m for naneng usbphy */
80009bdc:	47b2                	lw	a5,12(sp)
80009bde:	2007a703          	lw	a4,512(a5)
80009be2:	77fd                	lui	a5,0xfffff
80009be4:	17fd                	add	a5,a5,-1 # ffffefff <__APB_SRAM_segment_end__+0xbf0cfff>
80009be6:	8f7d                	and	a4,a4,a5
80009be8:	47b2                	lw	a5,12(sp)
80009bea:	20e7a023          	sw	a4,512(a5)

80009bee <.L15>:
        status = USB_OTG_CTRL0_OTG_UTMI_RESET_SW_GET(ptr->OTG_CTRL0); /* wait for reset status */
80009bee:	47b2                	lw	a5,12(sp)
80009bf0:	2007a783          	lw	a5,512(a5)
80009bf4:	83ad                	srl	a5,a5,0xb
80009bf6:	8b85                	and	a5,a5,1
80009bf8:	ce3e                	sw	a5,28(sp)
    } while (status == 0);
80009bfa:	47f2                	lw	a5,28(sp)
80009bfc:	dbed                	beqz	a5,80009bee <.L15>
}
80009bfe:	0001                	nop
80009c00:	0001                	nop
80009c02:	6105                	add	sp,sp,32
80009c04:	8082                	ret

Disassembly of section .text.usb_phy_init:

80009c06 <usb_phy_init>:
{
80009c06:	7179                	add	sp,sp,-48
80009c08:	d606                	sw	ra,44(sp)
80009c0a:	c62a                	sw	a0,12(sp)
80009c0c:	87ae                	mv	a5,a1
80009c0e:	00f105a3          	sb	a5,11(sp)
    usb_phy_deinit(ptr);
80009c12:	4532                	lw	a0,12(sp)
80009c14:	3f8d                	jal	80009b86 <usb_phy_deinit>
    usb_phy_enable_dp_dm_pulldown(ptr);
80009c16:	4532                	lw	a0,12(sp)
80009c18:	37b9                	jal	80009b66 <usb_phy_enable_dp_dm_pulldown>
    ptr->OTG_CTRL0 |= USB_OTG_CTRL0_OTG_UTMI_SUSPENDM_SW_MASK;        /* set otg_utmi_suspend_m for naneng usbphy */
80009c1a:	47b2                	lw	a5,12(sp)
80009c1c:	2007a703          	lw	a4,512(a5)
80009c20:	6785                	lui	a5,0x1
80009c22:	8f5d                	or	a4,a4,a5
80009c24:	47b2                	lw	a5,12(sp)
80009c26:	20e7a023          	sw	a4,512(a5) # 1200 <__fw_size__+0x200>

80009c2a <.LBB3>:
    for (volatile uint32_t i = 0; i < USB_PHY_INIT_DELAY_COUNT; i++) {
80009c2a:	cc02                	sw	zero,24(sp)
80009c2c:	a039                	j	80009c3a <.L17>

80009c2e <.L18>:
        (void)ptr->PHY_CTRL1;                                         /* used for delay, at least 1us */
80009c2e:	47b2                	lw	a5,12(sp)
80009c30:	2147a783          	lw	a5,532(a5)
    for (volatile uint32_t i = 0; i < USB_PHY_INIT_DELAY_COUNT; i++) {
80009c34:	47e2                	lw	a5,24(sp)
80009c36:	0785                	add	a5,a5,1
80009c38:	cc3e                	sw	a5,24(sp)

80009c3a <.L17>:
80009c3a:	4762                	lw	a4,24(sp)
80009c3c:	06300793          	li	a5,99
80009c40:	fee7f7e3          	bgeu	a5,a4,80009c2e <.L18>

80009c44 <.LBE3>:
    ptr->OTG_CTRL0 &= ~USB_OTG_CTRL0_OTG_UTMI_RESET_SW_MASK;          /* clear otg_utmi_reset_sw for naneng usbphy */
80009c44:	47b2                	lw	a5,12(sp)
80009c46:	2007a703          	lw	a4,512(a5)
80009c4a:	77fd                	lui	a5,0xfffff
80009c4c:	7ff78793          	add	a5,a5,2047 # fffff7ff <__APB_SRAM_segment_end__+0xbf0d7ff>
80009c50:	8f7d                	and	a4,a4,a5
80009c52:	47b2                	lw	a5,12(sp)
80009c54:	20e7a023          	sw	a4,512(a5)
    ptr->OTG_CTRL0 &= ~USB_OTG_CTRL0_OTG_WKDPDMCHG_EN_MASK;           /* Disable dp/dm wakeup */
80009c58:	47b2                	lw	a5,12(sp)
80009c5a:	2007a703          	lw	a4,512(a5)
80009c5e:	fe0007b7          	lui	a5,0xfe000
80009c62:	17fd                	add	a5,a5,-1 # fdffffff <__APB_SRAM_segment_end__+0x9f0dfff>
80009c64:	8f7d                	and	a4,a4,a5
80009c66:	47b2                	lw	a5,12(sp)
80009c68:	20e7a023          	sw	a4,512(a5)
    ptr->PHY_STATUS |= USB_PHY_STATUS_UTMI_CLK_VALID_MASK;            /* write 1 to clear valid status */
80009c6c:	47b2                	lw	a5,12(sp)
80009c6e:	2247a703          	lw	a4,548(a5)
80009c72:	800007b7          	lui	a5,0x80000
80009c76:	8f5d                	or	a4,a4,a5
80009c78:	47b2                	lw	a5,12(sp)
80009c7a:	22e7a223          	sw	a4,548(a5) # 80000224 <_extram_size+0x7e000224>

80009c7e <.L19>:
        status = USB_PHY_STATUS_UTMI_CLK_VALID_GET(ptr->PHY_STATUS);  /* get utmi clock status */
80009c7e:	47b2                	lw	a5,12(sp)
80009c80:	2247a783          	lw	a5,548(a5)
80009c84:	83fd                	srl	a5,a5,0x1f
80009c86:	8b85                	and	a5,a5,1
80009c88:	ce3e                	sw	a5,28(sp)
    } while (status == 0);
80009c8a:	47f2                	lw	a5,28(sp)
80009c8c:	dbed                	beqz	a5,80009c7e <.L19>
    ptr->PHY_CTRL0 |= USB_PHY_CTRL0_OP_MODE_SUSPENDM_ENJ_MASK;        /* set suspendm_enj */
80009c8e:	47b2                	lw	a5,12(sp)
80009c90:	2107a703          	lw	a4,528(a5)
80009c94:	6785                	lui	a5,0x1
80009c96:	80078793          	add	a5,a5,-2048 # 800 <.L195+0xa>
80009c9a:	8f5d                	or	a4,a4,a5
80009c9c:	47b2                	lw	a5,12(sp)
80009c9e:	20e7a823          	sw	a4,528(a5)
    ptr->PHY_CTRL1 |= USB_PHY_CTRL1_UTMI_CFG_RST_N_MASK;              /* set cfg_rst_n */
80009ca2:	47b2                	lw	a5,12(sp)
80009ca4:	2147a703          	lw	a4,532(a5)
80009ca8:	001007b7          	lui	a5,0x100
80009cac:	8f5d                	or	a4,a4,a5
80009cae:	47b2                	lw	a5,12(sp)
80009cb0:	20e7aa23          	sw	a4,532(a5) # 100214 <__DLM_segment_end__+0x40214>
    if (host) {
80009cb4:	00b14783          	lbu	a5,11(sp)
80009cb8:	cb89                	beqz	a5,80009cca <.L21>
        ptr->PHY_CTRL1 |= USB_PHY_CTRL1_UTMI_OTG_SUSPENDM_MASK;       /* set otg_suspendm, enable high speed device disconect detect */
80009cba:	47b2                	lw	a5,12(sp)
80009cbc:	2147a783          	lw	a5,532(a5)
80009cc0:	0027e713          	or	a4,a5,2
80009cc4:	47b2                	lw	a5,12(sp)
80009cc6:	20e7aa23          	sw	a4,532(a5)

80009cca <.L21>:
}
80009cca:	0001                	nop
80009ccc:	50b2                	lw	ra,44(sp)
80009cce:	6145                	add	sp,sp,48
80009cd0:	8082                	ret

Disassembly of section .text.usb_dcd_bus_reset:

80009cd2 <usb_dcd_bus_reset>:
{
80009cd2:	1101                	add	sp,sp,-32
80009cd4:	c62a                	sw	a0,12(sp)
80009cd6:	87ae                	mv	a5,a1
80009cd8:	00f11523          	sh	a5,10(sp)

80009cdc <.LBB4>:
    for (uint32_t i = 1; i < USB_SOC_DCD_MAX_ENDPOINT_COUNT; i++) {
80009cdc:	4785                	li	a5,1
80009cde:	ce3e                	sw	a5,28(sp)
80009ce0:	a831                	j	80009cfc <.L23>

80009ce2 <.L24>:
        ptr->ENDPTCTRL[i] = USB_ENDPTCTRL_TXT_SET(usb_xfer_bulk) | USB_ENDPTCTRL_RXT_SET(usb_xfer_bulk);
80009ce2:	4732                	lw	a4,12(sp)
80009ce4:	47f2                	lw	a5,28(sp)
80009ce6:	07078793          	add	a5,a5,112
80009cea:	078a                	sll	a5,a5,0x2
80009cec:	97ba                	add	a5,a5,a4
80009cee:	00080737          	lui	a4,0x80
80009cf2:	0721                	add	a4,a4,8 # 80008 <__AXI_SRAM_segment_size__+0x8>
80009cf4:	c398                	sw	a4,0(a5)
    for (uint32_t i = 1; i < USB_SOC_DCD_MAX_ENDPOINT_COUNT; i++) {
80009cf6:	47f2                	lw	a5,28(sp)
80009cf8:	0785                	add	a5,a5,1
80009cfa:	ce3e                	sw	a5,28(sp)

80009cfc <.L23>:
80009cfc:	4772                	lw	a4,28(sp)
80009cfe:	479d                	li	a5,7
80009d00:	fee7f1e3          	bgeu	a5,a4,80009ce2 <.L24>

80009d04 <.LBE4>:
    ptr->ENDPTNAK       = ptr->ENDPTNAK;
80009d04:	47b2                	lw	a5,12(sp)
80009d06:	1787a703          	lw	a4,376(a5)
80009d0a:	47b2                	lw	a5,12(sp)
80009d0c:	16e7ac23          	sw	a4,376(a5)
    ptr->ENDPTNAKEN     = 0;
80009d10:	47b2                	lw	a5,12(sp)
80009d12:	1607ae23          	sw	zero,380(a5)
    ptr->USBSTS         = ptr->USBSTS;
80009d16:	47b2                	lw	a5,12(sp)
80009d18:	1447a703          	lw	a4,324(a5)
80009d1c:	47b2                	lw	a5,12(sp)
80009d1e:	14e7a223          	sw	a4,324(a5)
    ptr->ENDPTSETUPSTAT = ptr->ENDPTSETUPSTAT;
80009d22:	47b2                	lw	a5,12(sp)
80009d24:	1ac7a703          	lw	a4,428(a5)
80009d28:	47b2                	lw	a5,12(sp)
80009d2a:	1ae7a623          	sw	a4,428(a5)
    ptr->ENDPTCOMPLETE  = ptr->ENDPTCOMPLETE;
80009d2e:	47b2                	lw	a5,12(sp)
80009d30:	1bc7a703          	lw	a4,444(a5)
80009d34:	47b2                	lw	a5,12(sp)
80009d36:	1ae7ae23          	sw	a4,444(a5)
    while (ptr->ENDPTPRIME) {
80009d3a:	0001                	nop

80009d3c <.L25>:
80009d3c:	47b2                	lw	a5,12(sp)
80009d3e:	1b07a783          	lw	a5,432(a5)
80009d42:	ffed                	bnez	a5,80009d3c <.L25>
    ptr->ENDPTFLUSH = 0xFFFFFFFF;
80009d44:	47b2                	lw	a5,12(sp)
80009d46:	577d                	li	a4,-1
80009d48:	1ae7aa23          	sw	a4,436(a5)
    while (ptr->ENDPTFLUSH) {
80009d4c:	0001                	nop

80009d4e <.L26>:
80009d4e:	47b2                	lw	a5,12(sp)
80009d50:	1b47a783          	lw	a5,436(a5)
80009d54:	ffed                	bnez	a5,80009d4e <.L26>
}
80009d56:	0001                	nop
80009d58:	0001                	nop
80009d5a:	6105                	add	sp,sp,32
80009d5c:	8082                	ret

Disassembly of section .text.usb_dcd_init:

80009d5e <usb_dcd_init>:
{
80009d5e:	1101                	add	sp,sp,-32
80009d60:	ce06                	sw	ra,28(sp)
80009d62:	c62a                	sw	a0,12(sp)
    usb_phy_init(ptr, false);
80009d64:	4581                	li	a1,0
80009d66:	4532                	lw	a0,12(sp)
80009d68:	3d79                	jal	80009c06 <usb_phy_init>
    ptr->USBCMD &= ~USB_USBCMD_RS_MASK;
80009d6a:	47b2                	lw	a5,12(sp)
80009d6c:	1407a783          	lw	a5,320(a5)
80009d70:	ffe7f713          	and	a4,a5,-2
80009d74:	47b2                	lw	a5,12(sp)
80009d76:	14e7a023          	sw	a4,320(a5)
    ptr->USBCMD |= USB_USBCMD_RST_MASK;
80009d7a:	47b2                	lw	a5,12(sp)
80009d7c:	1407a783          	lw	a5,320(a5)
80009d80:	0027e713          	or	a4,a5,2
80009d84:	47b2                	lw	a5,12(sp)
80009d86:	14e7a023          	sw	a4,320(a5)
    while (USB_USBCMD_RST_GET(ptr->USBCMD)) {
80009d8a:	0001                	nop

80009d8c <.L28>:
80009d8c:	47b2                	lw	a5,12(sp)
80009d8e:	1407a783          	lw	a5,320(a5)
80009d92:	8b89                	and	a5,a5,2
80009d94:	ffe5                	bnez	a5,80009d8c <.L28>
    ptr->USBMODE &= ~USB_USBMODE_CM_MASK;
80009d96:	47b2                	lw	a5,12(sp)
80009d98:	1a87a783          	lw	a5,424(a5)
80009d9c:	ffc7f713          	and	a4,a5,-4
80009da0:	47b2                	lw	a5,12(sp)
80009da2:	1ae7a423          	sw	a4,424(a5)
    ptr->USBMODE |= USB_USBMODE_CM_SET(2);
80009da6:	47b2                	lw	a5,12(sp)
80009da8:	1a87a783          	lw	a5,424(a5)
80009dac:	0027e713          	or	a4,a5,2
80009db0:	47b2                	lw	a5,12(sp)
80009db2:	1ae7a423          	sw	a4,424(a5)
    ptr->USBMODE &= ~USB_USBMODE_SLOM_MASK;
80009db6:	47b2                	lw	a5,12(sp)
80009db8:	1a87a783          	lw	a5,424(a5)
80009dbc:	ff77f713          	and	a4,a5,-9
80009dc0:	47b2                	lw	a5,12(sp)
80009dc2:	1ae7a423          	sw	a4,424(a5)
    ptr->USBMODE &= ~USB_USBMODE_ES_MASK;
80009dc6:	47b2                	lw	a5,12(sp)
80009dc8:	1a87a783          	lw	a5,424(a5)
80009dcc:	ffb7f713          	and	a4,a5,-5
80009dd0:	47b2                	lw	a5,12(sp)
80009dd2:	1ae7a423          	sw	a4,424(a5)
    ptr->PORTSC1 &= ~USB_PORTSC1_STS_MASK;
80009dd6:	47b2                	lw	a5,12(sp)
80009dd8:	1847a703          	lw	a4,388(a5)
80009ddc:	e00007b7          	lui	a5,0xe0000
80009de0:	17fd                	add	a5,a5,-1 # dfffffff <__XPI0_segment_end__+0x5effffff>
80009de2:	8f7d                	and	a4,a4,a5
80009de4:	47b2                	lw	a5,12(sp)
80009de6:	18e7a223          	sw	a4,388(a5)
    ptr->PORTSC1 &= ~USB_PORTSC1_PTW_MASK;
80009dea:	47b2                	lw	a5,12(sp)
80009dec:	1847a703          	lw	a4,388(a5)
80009df0:	f00007b7          	lui	a5,0xf0000
80009df4:	17fd                	add	a5,a5,-1 # efffffff <__XPI0_segment_end__+0x6effffff>
80009df6:	8f7d                	and	a4,a4,a5
80009df8:	47b2                	lw	a5,12(sp)
80009dfa:	18e7a223          	sw	a4,388(a5)
    ptr->USBCMD &= ~USB_USBCMD_ITC_MASK;
80009dfe:	47b2                	lw	a5,12(sp)
80009e00:	1407a703          	lw	a4,320(a5)
80009e04:	ff0107b7          	lui	a5,0xff010
80009e08:	17fd                	add	a5,a5,-1 # ff00ffff <__APB_SRAM_segment_end__+0xaf1dfff>
80009e0a:	8f7d                	and	a4,a4,a5
80009e0c:	47b2                	lw	a5,12(sp)
80009e0e:	14e7a023          	sw	a4,320(a5)
    ptr->OTGSC |= USB_OTGSC_VD_MASK;
80009e12:	47b2                	lw	a5,12(sp)
80009e14:	1a47a783          	lw	a5,420(a5)
80009e18:	0017e713          	or	a4,a5,1
80009e1c:	47b2                	lw	a5,12(sp)
80009e1e:	1ae7a223          	sw	a4,420(a5)
    ptr->USBINTR = 0;
80009e22:	47b2                	lw	a5,12(sp)
80009e24:	1407a423          	sw	zero,328(a5)
}
80009e28:	0001                	nop
80009e2a:	40f2                	lw	ra,28(sp)
80009e2c:	6105                	add	sp,sp,32
80009e2e:	8082                	ret

Disassembly of section .text.usb_dcd_deinit:

80009e30 <usb_dcd_deinit>:
{
80009e30:	1101                	add	sp,sp,-32
80009e32:	ce06                	sw	ra,28(sp)
80009e34:	c62a                	sw	a0,12(sp)
    ptr->USBCMD &= ~USB_USBCMD_RS_MASK;
80009e36:	47b2                	lw	a5,12(sp)
80009e38:	1407a783          	lw	a5,320(a5)
80009e3c:	ffe7f713          	and	a4,a5,-2
80009e40:	47b2                	lw	a5,12(sp)
80009e42:	14e7a023          	sw	a4,320(a5)
    ptr->USBCMD |= USB_USBCMD_RST_MASK;
80009e46:	47b2                	lw	a5,12(sp)
80009e48:	1407a783          	lw	a5,320(a5)
80009e4c:	0027e713          	or	a4,a5,2
80009e50:	47b2                	lw	a5,12(sp)
80009e52:	14e7a023          	sw	a4,320(a5)
    while (USB_USBCMD_RST_GET(ptr->USBCMD)) {
80009e56:	0001                	nop

80009e58 <.L30>:
80009e58:	47b2                	lw	a5,12(sp)
80009e5a:	1407a783          	lw	a5,320(a5)
80009e5e:	8b89                	and	a5,a5,2
80009e60:	ffe5                	bnez	a5,80009e58 <.L30>
    usb_phy_deinit(ptr);
80009e62:	4532                	lw	a0,12(sp)
80009e64:	330d                	jal	80009b86 <usb_phy_deinit>
    ptr->ENDPTLISTADDR = 0;
80009e66:	47b2                	lw	a5,12(sp)
80009e68:	1407ac23          	sw	zero,344(a5)
    ptr->USBSTS = ptr->USBSTS;
80009e6c:	47b2                	lw	a5,12(sp)
80009e6e:	1447a703          	lw	a4,324(a5)
80009e72:	47b2                	lw	a5,12(sp)
80009e74:	14e7a223          	sw	a4,324(a5)
    ptr->USBINTR = 0;
80009e78:	47b2                	lw	a5,12(sp)
80009e7a:	1407a423          	sw	zero,328(a5)
}
80009e7e:	0001                	nop
80009e80:	40f2                	lw	ra,28(sp)
80009e82:	6105                	add	sp,sp,32
80009e84:	8082                	ret

Disassembly of section .text.usb_dcd_edpt_xfer:

80009e86 <usb_dcd_edpt_xfer>:
{
80009e86:	1101                	add	sp,sp,-32
80009e88:	c62a                	sw	a0,12(sp)
80009e8a:	87ae                	mv	a5,a1
80009e8c:	00f105a3          	sb	a5,11(sp)
    uint32_t offset = ep_idx / 2 + ((ep_idx % 2) ? 16 : 0);
80009e90:	00b14783          	lbu	a5,11(sp)
80009e94:	8385                	srl	a5,a5,0x1
80009e96:	0ff7f793          	zext.b	a5,a5
80009e9a:	873e                	mv	a4,a5
80009e9c:	00b14783          	lbu	a5,11(sp)
80009ea0:	0792                	sll	a5,a5,0x4
80009ea2:	8bc1                	and	a5,a5,16
80009ea4:	97ba                	add	a5,a5,a4
80009ea6:	ce3e                	sw	a5,28(sp)
    ptr->ENDPTPRIME = 1 << offset;
80009ea8:	47f2                	lw	a5,28(sp)
80009eaa:	4705                	li	a4,1
80009eac:	00f717b3          	sll	a5,a4,a5
80009eb0:	873e                	mv	a4,a5
80009eb2:	47b2                	lw	a5,12(sp)
80009eb4:	1ae7a823          	sw	a4,432(a5)
}
80009eb8:	0001                	nop
80009eba:	6105                	add	sp,sp,32
80009ebc:	8082                	ret

Disassembly of section .text.hid_class_interface_request_handler:

80009ebe <hid_class_interface_request_handler>:
{
80009ebe:	7179                	add	sp,sp,-48
80009ec0:	d606                	sw	ra,44(sp)
80009ec2:	d422                	sw	s0,40(sp)
80009ec4:	87aa                	mv	a5,a0
80009ec6:	c42e                	sw	a1,8(sp)
80009ec8:	c232                	sw	a2,4(sp)
80009eca:	c036                	sw	a3,0(sp)
80009ecc:	00f107a3          	sb	a5,15(sp)
    uint8_t intf_num = LO_BYTE(setup->wIndex);
80009ed0:	47a2                	lw	a5,8(sp)
80009ed2:	0047c703          	lbu	a4,4(a5)
80009ed6:	0057c783          	lbu	a5,5(a5)
80009eda:	07a2                	sll	a5,a5,0x8
80009edc:	8fd9                	or	a5,a5,a4
80009ede:	07c2                	sll	a5,a5,0x10
80009ee0:	83c1                	srl	a5,a5,0x10
80009ee2:	00f10fa3          	sb	a5,31(sp)
    switch (setup->bRequest) {
80009ee6:	47a2                	lw	a5,8(sp)
80009ee8:	0017c783          	lbu	a5,1(a5)
80009eec:	472d                	li	a4,11
80009eee:	16f76363          	bltu	a4,a5,8000a054 <.L2>
80009ef2:	00279713          	sll	a4,a5,0x2
80009ef6:	800037b7          	lui	a5,0x80003
80009efa:	46c78793          	add	a5,a5,1132 # 8000346c <.L4>
80009efe:	97ba                	add	a5,a5,a4
80009f00:	439c                	lw	a5,0(a5)
80009f02:	8782                	jr	a5

80009f04 <.L9>:
            usbd_hid_get_report(busid, intf_num, LO_BYTE(setup->wValue), HI_BYTE(setup->wValue), data, len);
80009f04:	47a2                	lw	a5,8(sp)
80009f06:	0027c703          	lbu	a4,2(a5)
80009f0a:	0037c783          	lbu	a5,3(a5)
80009f0e:	07a2                	sll	a5,a5,0x8
80009f10:	8fd9                	or	a5,a5,a4
80009f12:	07c2                	sll	a5,a5,0x10
80009f14:	83c1                	srl	a5,a5,0x10
80009f16:	0ff7f613          	zext.b	a2,a5
80009f1a:	47a2                	lw	a5,8(sp)
80009f1c:	0027c703          	lbu	a4,2(a5)
80009f20:	0037c783          	lbu	a5,3(a5)
80009f24:	07a2                	sll	a5,a5,0x8
80009f26:	8fd9                	or	a5,a5,a4
80009f28:	07c2                	sll	a5,a5,0x10
80009f2a:	83c1                	srl	a5,a5,0x10
80009f2c:	83a1                	srl	a5,a5,0x8
80009f2e:	07c2                	sll	a5,a5,0x10
80009f30:	83c1                	srl	a5,a5,0x10
80009f32:	0ff7f693          	zext.b	a3,a5
80009f36:	01f14583          	lbu	a1,31(sp)
80009f3a:	00f14503          	lbu	a0,15(sp)
80009f3e:	4782                	lw	a5,0(sp)
80009f40:	4712                	lw	a4,4(sp)
80009f42:	fe0fb0ef          	jal	80005722 <usbd_hid_get_report>
            break;
80009f46:	aa0d                	j	8000a078 <.L10>

80009f48 <.L8>:
            (*data)[0] = usbd_hid_get_idle(busid, intf_num, LO_BYTE(setup->wValue));
80009f48:	47a2                	lw	a5,8(sp)
80009f4a:	0027c703          	lbu	a4,2(a5)
80009f4e:	0037c783          	lbu	a5,3(a5)
80009f52:	07a2                	sll	a5,a5,0x8
80009f54:	8fd9                	or	a5,a5,a4
80009f56:	07c2                	sll	a5,a5,0x10
80009f58:	83c1                	srl	a5,a5,0x10
80009f5a:	0ff7f693          	zext.b	a3,a5
80009f5e:	4792                	lw	a5,4(sp)
80009f60:	4380                	lw	s0,0(a5)
80009f62:	01f14703          	lbu	a4,31(sp)
80009f66:	00f14783          	lbu	a5,15(sp)
80009f6a:	8636                	mv	a2,a3
80009f6c:	85ba                	mv	a1,a4
80009f6e:	853e                	mv	a0,a5
80009f70:	2a91                	jal	8000a0c4 <usbd_hid_get_idle>
80009f72:	87aa                	mv	a5,a0
80009f74:	00f40023          	sb	a5,0(s0)
            *len = 1;
80009f78:	4782                	lw	a5,0(sp)
80009f7a:	4705                	li	a4,1
80009f7c:	c398                	sw	a4,0(a5)
            break;
80009f7e:	a8ed                	j	8000a078 <.L10>

80009f80 <.L7>:
            (*data)[0] = usbd_hid_get_protocol(busid, intf_num);
80009f80:	4792                	lw	a5,4(sp)
80009f82:	4380                	lw	s0,0(a5)
80009f84:	01f14703          	lbu	a4,31(sp)
80009f88:	00f14783          	lbu	a5,15(sp)
80009f8c:	85ba                	mv	a1,a4
80009f8e:	853e                	mv	a0,a5
80009f90:	2a91                	jal	8000a0e4 <usbd_hid_get_protocol>
80009f92:	87aa                	mv	a5,a0
80009f94:	00f40023          	sb	a5,0(s0)
            *len = 1;
80009f98:	4782                	lw	a5,0(sp)
80009f9a:	4705                	li	a4,1
80009f9c:	c398                	sw	a4,0(a5)
            break;
80009f9e:	a8e9                	j	8000a078 <.L10>

80009fa0 <.L6>:
            usbd_hid_set_report(busid, intf_num, LO_BYTE(setup->wValue), HI_BYTE(setup->wValue), *data, *len);
80009fa0:	47a2                	lw	a5,8(sp)
80009fa2:	0027c703          	lbu	a4,2(a5)
80009fa6:	0037c783          	lbu	a5,3(a5)
80009faa:	07a2                	sll	a5,a5,0x8
80009fac:	8fd9                	or	a5,a5,a4
80009fae:	07c2                	sll	a5,a5,0x10
80009fb0:	83c1                	srl	a5,a5,0x10
80009fb2:	0ff7f613          	zext.b	a2,a5
80009fb6:	47a2                	lw	a5,8(sp)
80009fb8:	0027c703          	lbu	a4,2(a5)
80009fbc:	0037c783          	lbu	a5,3(a5)
80009fc0:	07a2                	sll	a5,a5,0x8
80009fc2:	8fd9                	or	a5,a5,a4
80009fc4:	07c2                	sll	a5,a5,0x10
80009fc6:	83c1                	srl	a5,a5,0x10
80009fc8:	83a1                	srl	a5,a5,0x8
80009fca:	07c2                	sll	a5,a5,0x10
80009fcc:	83c1                	srl	a5,a5,0x10
80009fce:	0ff7f693          	zext.b	a3,a5
80009fd2:	4792                	lw	a5,4(sp)
80009fd4:	4398                	lw	a4,0(a5)
80009fd6:	4782                	lw	a5,0(sp)
80009fd8:	439c                	lw	a5,0(a5)
80009fda:	01f14583          	lbu	a1,31(sp)
80009fde:	00f14503          	lbu	a0,15(sp)
80009fe2:	2a29                	jal	8000a0fc <usbd_hid_set_report>
            break;
80009fe4:	a851                	j	8000a078 <.L10>

80009fe6 <.L5>:
            usbd_hid_set_idle(busid, intf_num, LO_BYTE(setup->wValue), HI_BYTE(setup->wValue));
80009fe6:	47a2                	lw	a5,8(sp)
80009fe8:	0027c703          	lbu	a4,2(a5)
80009fec:	0037c783          	lbu	a5,3(a5)
80009ff0:	07a2                	sll	a5,a5,0x8
80009ff2:	8fd9                	or	a5,a5,a4
80009ff4:	07c2                	sll	a5,a5,0x10
80009ff6:	83c1                	srl	a5,a5,0x10
80009ff8:	0ff7f613          	zext.b	a2,a5
80009ffc:	47a2                	lw	a5,8(sp)
80009ffe:	0027c703          	lbu	a4,2(a5)
8000a002:	0037c783          	lbu	a5,3(a5)
8000a006:	07a2                	sll	a5,a5,0x8
8000a008:	8fd9                	or	a5,a5,a4
8000a00a:	07c2                	sll	a5,a5,0x10
8000a00c:	83c1                	srl	a5,a5,0x10
8000a00e:	83a1                	srl	a5,a5,0x8
8000a010:	07c2                	sll	a5,a5,0x10
8000a012:	83c1                	srl	a5,a5,0x10
8000a014:	0ff7f693          	zext.b	a3,a5
8000a018:	01f14703          	lbu	a4,31(sp)
8000a01c:	00f14783          	lbu	a5,15(sp)
8000a020:	85ba                	mv	a1,a4
8000a022:	853e                	mv	a0,a5
8000a024:	f30fb0ef          	jal	80005754 <usbd_hid_set_idle>
            break;
8000a028:	a881                	j	8000a078 <.L10>

8000a02a <.L3>:
            usbd_hid_set_protocol(busid, intf_num, LO_BYTE(setup->wValue));
8000a02a:	47a2                	lw	a5,8(sp)
8000a02c:	0027c703          	lbu	a4,2(a5)
8000a030:	0037c783          	lbu	a5,3(a5)
8000a034:	07a2                	sll	a5,a5,0x8
8000a036:	8fd9                	or	a5,a5,a4
8000a038:	07c2                	sll	a5,a5,0x10
8000a03a:	83c1                	srl	a5,a5,0x10
8000a03c:	0ff7f693          	zext.b	a3,a5
8000a040:	01f14703          	lbu	a4,31(sp)
8000a044:	00f14783          	lbu	a5,15(sp)
8000a048:	8636                	mv	a2,a3
8000a04a:	85ba                	mv	a1,a4
8000a04c:	853e                	mv	a0,a5
8000a04e:	f28fb0ef          	jal	80005776 <usbd_hid_set_protocol>
            break;
8000a052:	a01d                	j	8000a078 <.L10>

8000a054 <.L2>:
            USB_LOG_WRN("Unhandled HID Class bRequest 0x%02x\r\n", setup->bRequest);
8000a054:	800047b7          	lui	a5,0x80004
8000a058:	07078513          	add	a0,a5,112 # 80004070 <.LC0>
8000a05c:	c81fe0ef          	jal	80008cdc <printf>
8000a060:	47a2                	lw	a5,8(sp)
8000a062:	0017c783          	lbu	a5,1(a5)
8000a066:	85be                	mv	a1,a5
8000a068:	800047b7          	lui	a5,0x80004
8000a06c:	07c78513          	add	a0,a5,124 # 8000407c <.LC1>
8000a070:	c6dfe0ef          	jal	80008cdc <printf>
            return -1;
8000a074:	57fd                	li	a5,-1
8000a076:	a011                	j	8000a07a <.L11>

8000a078 <.L10>:
    return 0;
8000a078:	4781                	li	a5,0

8000a07a <.L11>:
}
8000a07a:	853e                	mv	a0,a5
8000a07c:	50b2                	lw	ra,44(sp)
8000a07e:	5422                	lw	s0,40(sp)
8000a080:	6145                	add	sp,sp,48
8000a082:	8082                	ret

Disassembly of section .text.usbd_hid_init_intf:

8000a084 <usbd_hid_init_intf>:
{
8000a084:	1141                	add	sp,sp,-16
8000a086:	87aa                	mv	a5,a0
8000a088:	c42e                	sw	a1,8(sp)
8000a08a:	c232                	sw	a2,4(sp)
8000a08c:	c036                	sw	a3,0(sp)
8000a08e:	00f107a3          	sb	a5,15(sp)
    intf->class_interface_handler = hid_class_interface_request_handler;
8000a092:	47a2                	lw	a5,8(sp)
8000a094:	8000a737          	lui	a4,0x8000a
8000a098:	ebe70713          	add	a4,a4,-322 # 80009ebe <hid_class_interface_request_handler>
8000a09c:	c398                	sw	a4,0(a5)
    intf->class_endpoint_handler = NULL;
8000a09e:	47a2                	lw	a5,8(sp)
8000a0a0:	0007a223          	sw	zero,4(a5)
    intf->vendor_handler = NULL;
8000a0a4:	47a2                	lw	a5,8(sp)
8000a0a6:	0007a423          	sw	zero,8(a5)
    intf->notify_handler = NULL;
8000a0aa:	47a2                	lw	a5,8(sp)
8000a0ac:	0007a623          	sw	zero,12(a5)
    intf->hid_report_descriptor = desc;
8000a0b0:	47a2                	lw	a5,8(sp)
8000a0b2:	4712                	lw	a4,4(sp)
8000a0b4:	cb98                	sw	a4,16(a5)
    intf->hid_report_descriptor_len = desc_len;
8000a0b6:	47a2                	lw	a5,8(sp)
8000a0b8:	4702                	lw	a4,0(sp)
8000a0ba:	cbd8                	sw	a4,20(a5)
    return intf;
8000a0bc:	47a2                	lw	a5,8(sp)
}
8000a0be:	853e                	mv	a0,a5
8000a0c0:	0141                	add	sp,sp,16
8000a0c2:	8082                	ret

Disassembly of section .text.usbd_hid_get_idle:

8000a0c4 <usbd_hid_get_idle>:
{
8000a0c4:	1141                	add	sp,sp,-16
8000a0c6:	87aa                	mv	a5,a0
8000a0c8:	86ae                	mv	a3,a1
8000a0ca:	8732                	mv	a4,a2
8000a0cc:	00f107a3          	sb	a5,15(sp)
8000a0d0:	87b6                	mv	a5,a3
8000a0d2:	00f10723          	sb	a5,14(sp)
8000a0d6:	87ba                	mv	a5,a4
8000a0d8:	00f106a3          	sb	a5,13(sp)
    return 0;
8000a0dc:	4781                	li	a5,0
}
8000a0de:	853e                	mv	a0,a5
8000a0e0:	0141                	add	sp,sp,16
8000a0e2:	8082                	ret

Disassembly of section .text.usbd_hid_get_protocol:

8000a0e4 <usbd_hid_get_protocol>:
{
8000a0e4:	1141                	add	sp,sp,-16
8000a0e6:	87aa                	mv	a5,a0
8000a0e8:	872e                	mv	a4,a1
8000a0ea:	00f107a3          	sb	a5,15(sp)
8000a0ee:	87ba                	mv	a5,a4
8000a0f0:	00f10723          	sb	a5,14(sp)
    return 0;
8000a0f4:	4781                	li	a5,0
}
8000a0f6:	853e                	mv	a0,a5
8000a0f8:	0141                	add	sp,sp,16
8000a0fa:	8082                	ret

Disassembly of section .text.usbd_hid_set_report:

8000a0fc <usbd_hid_set_report>:
{
8000a0fc:	1141                	add	sp,sp,-16
8000a0fe:	c43a                	sw	a4,8(sp)
8000a100:	c23e                	sw	a5,4(sp)
8000a102:	87aa                	mv	a5,a0
8000a104:	00f107a3          	sb	a5,15(sp)
8000a108:	87ae                	mv	a5,a1
8000a10a:	00f10723          	sb	a5,14(sp)
8000a10e:	87b2                	mv	a5,a2
8000a110:	00f106a3          	sb	a5,13(sp)
8000a114:	87b6                	mv	a5,a3
8000a116:	00f10623          	sb	a5,12(sp)
}
8000a11a:	0001                	nop
8000a11c:	0141                	add	sp,sp,16
8000a11e:	8082                	ret

Disassembly of section .text.usb_memcpy:

8000a120 <usb_memcpy>:

static inline void *usb_memcpy(void *s1, const void *s2, size_t n)
{
8000a120:	7179                	add	sp,sp,-48
8000a122:	d606                	sw	ra,44(sp)
8000a124:	c62a                	sw	a0,12(sp)
8000a126:	c42e                	sw	a1,8(sp)
8000a128:	c232                	sw	a2,4(sp)
    char *b1 = (char *)s1;
8000a12a:	47b2                	lw	a5,12(sp)
8000a12c:	ce3e                	sw	a5,28(sp)
    const char *b2 = (const char *)s2;
8000a12e:	47a2                	lw	a5,8(sp)
8000a130:	cc3e                	sw	a5,24(sp)
    uint32_t *w1;
    const uint32_t *w2;

    if (ALIGN_UP_DWORD(b1) == ALIGN_UP_DWORD(b2)) {
8000a132:	4772                	lw	a4,28(sp)
8000a134:	47e2                	lw	a5,24(sp)
8000a136:	8fb9                	xor	a5,a5,a4
8000a138:	8b8d                	and	a5,a5,3
8000a13a:	10079363          	bnez	a5,8000a240 <.L14>
        while (ALIGN_UP_DWORD(b1) != 0 && n > 0) {
8000a13e:	a005                	j	8000a15e <.L4>

8000a140 <.L6>:
            *b1++ = *b2++;
8000a140:	4762                	lw	a4,24(sp)
8000a142:	00170793          	add	a5,a4,1
8000a146:	cc3e                	sw	a5,24(sp)
8000a148:	47f2                	lw	a5,28(sp)
8000a14a:	00178693          	add	a3,a5,1
8000a14e:	ce36                	sw	a3,28(sp)
8000a150:	00074703          	lbu	a4,0(a4)
8000a154:	00e78023          	sb	a4,0(a5)
            --n;
8000a158:	4792                	lw	a5,4(sp)
8000a15a:	17fd                	add	a5,a5,-1
8000a15c:	c23e                	sw	a5,4(sp)

8000a15e <.L4>:
        while (ALIGN_UP_DWORD(b1) != 0 && n > 0) {
8000a15e:	47f2                	lw	a5,28(sp)
8000a160:	8b8d                	and	a5,a5,3
8000a162:	c399                	beqz	a5,8000a168 <.L5>
8000a164:	4792                	lw	a5,4(sp)
8000a166:	ffe9                	bnez	a5,8000a140 <.L6>

8000a168 <.L5>:
        }

        w1 = (uint32_t *)b1;
8000a168:	47f2                	lw	a5,28(sp)
8000a16a:	ca3e                	sw	a5,20(sp)
        w2 = (const uint32_t *)b2;
8000a16c:	47e2                	lw	a5,24(sp)
8000a16e:	c83e                	sw	a5,16(sp)

        while (n >= 4 * sizeof(uint32_t)) {
8000a170:	a8a1                	j	8000a1c8 <.L7>

8000a172 <.L8>:
            *w1++ = *w2++;
8000a172:	4742                	lw	a4,16(sp)
8000a174:	00470793          	add	a5,a4,4
8000a178:	c83e                	sw	a5,16(sp)
8000a17a:	47d2                	lw	a5,20(sp)
8000a17c:	00478693          	add	a3,a5,4
8000a180:	ca36                	sw	a3,20(sp)
8000a182:	4318                	lw	a4,0(a4)
8000a184:	c398                	sw	a4,0(a5)
            *w1++ = *w2++;
8000a186:	4742                	lw	a4,16(sp)
8000a188:	00470793          	add	a5,a4,4
8000a18c:	c83e                	sw	a5,16(sp)
8000a18e:	47d2                	lw	a5,20(sp)
8000a190:	00478693          	add	a3,a5,4
8000a194:	ca36                	sw	a3,20(sp)
8000a196:	4318                	lw	a4,0(a4)
8000a198:	c398                	sw	a4,0(a5)
            *w1++ = *w2++;
8000a19a:	4742                	lw	a4,16(sp)
8000a19c:	00470793          	add	a5,a4,4
8000a1a0:	c83e                	sw	a5,16(sp)
8000a1a2:	47d2                	lw	a5,20(sp)
8000a1a4:	00478693          	add	a3,a5,4
8000a1a8:	ca36                	sw	a3,20(sp)
8000a1aa:	4318                	lw	a4,0(a4)
8000a1ac:	c398                	sw	a4,0(a5)
            *w1++ = *w2++;
8000a1ae:	4742                	lw	a4,16(sp)
8000a1b0:	00470793          	add	a5,a4,4
8000a1b4:	c83e                	sw	a5,16(sp)
8000a1b6:	47d2                	lw	a5,20(sp)
8000a1b8:	00478693          	add	a3,a5,4
8000a1bc:	ca36                	sw	a3,20(sp)
8000a1be:	4318                	lw	a4,0(a4)
8000a1c0:	c398                	sw	a4,0(a5)
            n -= 4 * sizeof(uint32_t);
8000a1c2:	4792                	lw	a5,4(sp)
8000a1c4:	17c1                	add	a5,a5,-16
8000a1c6:	c23e                	sw	a5,4(sp)

8000a1c8 <.L7>:
        while (n >= 4 * sizeof(uint32_t)) {
8000a1c8:	4712                	lw	a4,4(sp)
8000a1ca:	47bd                	li	a5,15
8000a1cc:	fae7e3e3          	bltu	a5,a4,8000a172 <.L8>
        }

        while (n >= sizeof(uint32_t)) {
8000a1d0:	a831                	j	8000a1ec <.L9>

8000a1d2 <.L10>:
            *w1++ = *w2++;
8000a1d2:	4742                	lw	a4,16(sp)
8000a1d4:	00470793          	add	a5,a4,4
8000a1d8:	c83e                	sw	a5,16(sp)
8000a1da:	47d2                	lw	a5,20(sp)
8000a1dc:	00478693          	add	a3,a5,4
8000a1e0:	ca36                	sw	a3,20(sp)
8000a1e2:	4318                	lw	a4,0(a4)
8000a1e4:	c398                	sw	a4,0(a5)
            n -= sizeof(uint32_t);
8000a1e6:	4792                	lw	a5,4(sp)
8000a1e8:	17f1                	add	a5,a5,-4
8000a1ea:	c23e                	sw	a5,4(sp)

8000a1ec <.L9>:
        while (n >= sizeof(uint32_t)) {
8000a1ec:	4712                	lw	a4,4(sp)
8000a1ee:	478d                	li	a5,3
8000a1f0:	fee7e1e3          	bltu	a5,a4,8000a1d2 <.L10>
        }

        b1 = (char *)w1;
8000a1f4:	47d2                	lw	a5,20(sp)
8000a1f6:	ce3e                	sw	a5,28(sp)
        b2 = (const char *)w2;
8000a1f8:	47c2                	lw	a5,16(sp)
8000a1fa:	cc3e                	sw	a5,24(sp)

        while (n--) {
8000a1fc:	a829                	j	8000a216 <.L11>

8000a1fe <.L12>:
            *b1++ = *b2++;
8000a1fe:	4762                	lw	a4,24(sp)
8000a200:	00170793          	add	a5,a4,1
8000a204:	cc3e                	sw	a5,24(sp)
8000a206:	47f2                	lw	a5,28(sp)
8000a208:	00178693          	add	a3,a5,1
8000a20c:	ce36                	sw	a3,28(sp)
8000a20e:	00074703          	lbu	a4,0(a4)
8000a212:	00e78023          	sb	a4,0(a5)

8000a216 <.L11>:
        while (n--) {
8000a216:	4792                	lw	a5,4(sp)
8000a218:	fff78713          	add	a4,a5,-1
8000a21c:	c23a                	sw	a4,4(sp)
8000a21e:	f3e5                	bnez	a5,8000a1fe <.L12>
8000a220:	a0fd                	j	8000a30e <.L13>

8000a222 <.L16>:
        }
    } else {
        while (n > 0 && ALIGN_UP_DWORD(b2) != 0) {
            *b1++ = *b2++;
8000a222:	4762                	lw	a4,24(sp)
8000a224:	00170793          	add	a5,a4,1
8000a228:	cc3e                	sw	a5,24(sp)
8000a22a:	47f2                	lw	a5,28(sp)
8000a22c:	00178693          	add	a3,a5,1
8000a230:	ce36                	sw	a3,28(sp)
8000a232:	00074703          	lbu	a4,0(a4)
8000a236:	00e78023          	sb	a4,0(a5)
            --n;
8000a23a:	4792                	lw	a5,4(sp)
8000a23c:	17fd                	add	a5,a5,-1
8000a23e:	c23e                	sw	a5,4(sp)

8000a240 <.L14>:
        while (n > 0 && ALIGN_UP_DWORD(b2) != 0) {
8000a240:	4792                	lw	a5,4(sp)
8000a242:	c781                	beqz	a5,8000a24a <.L15>
8000a244:	47e2                	lw	a5,24(sp)
8000a246:	8b8d                	and	a5,a5,3
8000a248:	ffe9                	bnez	a5,8000a222 <.L16>

8000a24a <.L15>:
        }

        w2 = (const uint32_t *)b2;
8000a24a:	47e2                	lw	a5,24(sp)
8000a24c:	c83e                	sw	a5,16(sp)

        while (n >= 4 * sizeof(uint32_t)) {
8000a24e:	a0a5                	j	8000a2b6 <.L17>

8000a250 <.L18>:
         dword2array(b1, *w2++);
8000a250:	47c2                	lw	a5,16(sp)
8000a252:	00478713          	add	a4,a5,4
8000a256:	c83a                	sw	a4,16(sp)
8000a258:	439c                	lw	a5,0(a5)
8000a25a:	85be                	mv	a1,a5
8000a25c:	4572                	lw	a0,28(sp)
8000a25e:	d36fb0ef          	jal	80005794 <dword2array>
            b1 += sizeof(uint32_t);
8000a262:	47f2                	lw	a5,28(sp)
8000a264:	0791                	add	a5,a5,4
8000a266:	ce3e                	sw	a5,28(sp)
         dword2array(b1, *w2++);
8000a268:	47c2                	lw	a5,16(sp)
8000a26a:	00478713          	add	a4,a5,4
8000a26e:	c83a                	sw	a4,16(sp)
8000a270:	439c                	lw	a5,0(a5)
8000a272:	85be                	mv	a1,a5
8000a274:	4572                	lw	a0,28(sp)
8000a276:	d1efb0ef          	jal	80005794 <dword2array>
            b1 += sizeof(uint32_t);
8000a27a:	47f2                	lw	a5,28(sp)
8000a27c:	0791                	add	a5,a5,4
8000a27e:	ce3e                	sw	a5,28(sp)
         dword2array(b1, *w2++);
8000a280:	47c2                	lw	a5,16(sp)
8000a282:	00478713          	add	a4,a5,4
8000a286:	c83a                	sw	a4,16(sp)
8000a288:	439c                	lw	a5,0(a5)
8000a28a:	85be                	mv	a1,a5
8000a28c:	4572                	lw	a0,28(sp)
8000a28e:	d06fb0ef          	jal	80005794 <dword2array>
            b1 += sizeof(uint32_t);
8000a292:	47f2                	lw	a5,28(sp)
8000a294:	0791                	add	a5,a5,4
8000a296:	ce3e                	sw	a5,28(sp)
         dword2array(b1, *w2++);
8000a298:	47c2                	lw	a5,16(sp)
8000a29a:	00478713          	add	a4,a5,4
8000a29e:	c83a                	sw	a4,16(sp)
8000a2a0:	439c                	lw	a5,0(a5)
8000a2a2:	85be                	mv	a1,a5
8000a2a4:	4572                	lw	a0,28(sp)
8000a2a6:	ceefb0ef          	jal	80005794 <dword2array>
            b1 += sizeof(uint32_t);
8000a2aa:	47f2                	lw	a5,28(sp)
8000a2ac:	0791                	add	a5,a5,4
8000a2ae:	ce3e                	sw	a5,28(sp)
            n -= 4 * sizeof(uint32_t);
8000a2b0:	4792                	lw	a5,4(sp)
8000a2b2:	17c1                	add	a5,a5,-16
8000a2b4:	c23e                	sw	a5,4(sp)

8000a2b6 <.L17>:
        while (n >= 4 * sizeof(uint32_t)) {
8000a2b6:	4712                	lw	a4,4(sp)
8000a2b8:	47bd                	li	a5,15
8000a2ba:	f8e7ebe3          	bltu	a5,a4,8000a250 <.L18>
        }

        while (n >= sizeof(uint32_t)) {
8000a2be:	a005                	j	8000a2de <.L19>

8000a2c0 <.L20>:
         dword2array(b1, *w2++);
8000a2c0:	47c2                	lw	a5,16(sp)
8000a2c2:	00478713          	add	a4,a5,4
8000a2c6:	c83a                	sw	a4,16(sp)
8000a2c8:	439c                	lw	a5,0(a5)
8000a2ca:	85be                	mv	a1,a5
8000a2cc:	4572                	lw	a0,28(sp)
8000a2ce:	cc6fb0ef          	jal	80005794 <dword2array>
            b1 += sizeof(uint32_t);
8000a2d2:	47f2                	lw	a5,28(sp)
8000a2d4:	0791                	add	a5,a5,4
8000a2d6:	ce3e                	sw	a5,28(sp)
            n -= sizeof(uint32_t);
8000a2d8:	4792                	lw	a5,4(sp)
8000a2da:	17f1                	add	a5,a5,-4
8000a2dc:	c23e                	sw	a5,4(sp)

8000a2de <.L19>:
        while (n >= sizeof(uint32_t)) {
8000a2de:	4712                	lw	a4,4(sp)
8000a2e0:	478d                	li	a5,3
8000a2e2:	fce7efe3          	bltu	a5,a4,8000a2c0 <.L20>
        }

        b2 = (const char *)w2;
8000a2e6:	47c2                	lw	a5,16(sp)
8000a2e8:	cc3e                	sw	a5,24(sp)

        while (n--) {
8000a2ea:	a829                	j	8000a304 <.L21>

8000a2ec <.L22>:
            *b1++ = *b2++;
8000a2ec:	4762                	lw	a4,24(sp)
8000a2ee:	00170793          	add	a5,a4,1
8000a2f2:	cc3e                	sw	a5,24(sp)
8000a2f4:	47f2                	lw	a5,28(sp)
8000a2f6:	00178693          	add	a3,a5,1
8000a2fa:	ce36                	sw	a3,28(sp)
8000a2fc:	00074703          	lbu	a4,0(a4)
8000a300:	00e78023          	sb	a4,0(a5)

8000a304 <.L21>:
        while (n--) {
8000a304:	4792                	lw	a5,4(sp)
8000a306:	fff78713          	add	a4,a5,-1
8000a30a:	c23a                	sw	a4,4(sp)
8000a30c:	f3e5                	bnez	a5,8000a2ec <.L22>

8000a30e <.L13>:
        }
    }
    return s1;
8000a30e:	47b2                	lw	a5,12(sp)
}
8000a310:	853e                	mv	a0,a5
8000a312:	50b2                	lw	ra,44(sp)
8000a314:	6145                	add	sp,sp,48
8000a316:	8082                	ret

Disassembly of section .text.is_device_configured:

8000a318 <is_device_configured>:
{
8000a318:	1141                	add	sp,sp,-16
8000a31a:	87aa                	mv	a5,a0
8000a31c:	00f107a3          	sb	a5,15(sp)
    return (g_usbd_core[busid].configuration != 0);
8000a320:	00f14683          	lbu	a3,15(sp)
8000a324:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a328:	53c00793          	li	a5,1340
8000a32c:	02f687b3          	mul	a5,a3,a5
8000a330:	97ba                	add	a5,a5,a4
8000a332:	41c7c783          	lbu	a5,1052(a5)
8000a336:	00f037b3          	snez	a5,a5
8000a33a:	0ff7f793          	zext.b	a5,a5
}
8000a33e:	853e                	mv	a0,a5
8000a340:	0141                	add	sp,sp,16
8000a342:	8082                	ret

Disassembly of section .text.usbd_reset_endpoint:

8000a344 <usbd_reset_endpoint>:
{
8000a344:	1101                	add	sp,sp,-32
8000a346:	ce06                	sw	ra,28(sp)
8000a348:	87aa                	mv	a5,a0
8000a34a:	c42e                	sw	a1,8(sp)
8000a34c:	00f107a3          	sb	a5,15(sp)
    return usbd_ep_close(busid, ep->bEndpointAddress) == 0 ? true : false;
8000a350:	47a2                	lw	a5,8(sp)
8000a352:	0027c703          	lbu	a4,2(a5)
8000a356:	00f14783          	lbu	a5,15(sp)
8000a35a:	85ba                	mv	a1,a4
8000a35c:	853e                	mv	a0,a5
8000a35e:	56d000ef          	jal	8000b0ca <usbd_ep_close>
8000a362:	87aa                	mv	a5,a0
8000a364:	0017b793          	seqz	a5,a5
8000a368:	0ff7f793          	zext.b	a5,a5
}
8000a36c:	853e                	mv	a0,a5
8000a36e:	40f2                	lw	ra,28(sp)
8000a370:	6105                	add	sp,sp,32
8000a372:	8082                	ret

Disassembly of section .text.usbd_std_device_req_handler:

8000a374 <usbd_std_device_req_handler>:
{
8000a374:	7179                	add	sp,sp,-48
8000a376:	d606                	sw	ra,44(sp)
8000a378:	87aa                	mv	a5,a0
8000a37a:	c42e                	sw	a1,8(sp)
8000a37c:	c232                	sw	a2,4(sp)
8000a37e:	c036                	sw	a3,0(sp)
8000a380:	00f107a3          	sb	a5,15(sp)
    uint16_t value = setup->wValue;
8000a384:	47a2                	lw	a5,8(sp)
8000a386:	0027c703          	lbu	a4,2(a5)
8000a38a:	0037c783          	lbu	a5,3(a5)
8000a38e:	07a2                	sll	a5,a5,0x8
8000a390:	8fd9                	or	a5,a5,a4
8000a392:	00f11e23          	sh	a5,28(sp)
    bool ret = true;
8000a396:	4785                	li	a5,1
8000a398:	00f10fa3          	sb	a5,31(sp)
    switch (setup->bRequest) {
8000a39c:	47a2                	lw	a5,8(sp)
8000a39e:	0017c783          	lbu	a5,1(a5)
8000a3a2:	472d                	li	a4,11
8000a3a4:	26f76063          	bltu	a4,a5,8000a604 <.L91>
8000a3a8:	00279713          	sll	a4,a5,0x2
8000a3ac:	800037b7          	lui	a5,0x80003
8000a3b0:	4dc78793          	add	a5,a5,1244 # 800034dc <.L93>
8000a3b4:	97ba                	add	a5,a5,a4
8000a3b6:	439c                	lw	a5,0(a5)
8000a3b8:	8782                	jr	a5

8000a3ba <.L100>:
            (*data)[0] = 0x00;
8000a3ba:	4792                	lw	a5,4(sp)
8000a3bc:	439c                	lw	a5,0(a5)
8000a3be:	00078023          	sb	zero,0(a5)
            if (g_usbd_core[busid].self_powered) {
8000a3c2:	00f14683          	lbu	a3,15(sp)
8000a3c6:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a3ca:	53c00793          	li	a5,1340
8000a3ce:	02f687b3          	mul	a5,a3,a5
8000a3d2:	97ba                	add	a5,a5,a4
8000a3d4:	41e7c783          	lbu	a5,1054(a5)
8000a3d8:	cf89                	beqz	a5,8000a3f2 <.L101>
                (*data)[0] |= USB_GETSTATUS_SELF_POWERED;
8000a3da:	4792                	lw	a5,4(sp)
8000a3dc:	439c                	lw	a5,0(a5)
8000a3de:	0007c703          	lbu	a4,0(a5)
8000a3e2:	4792                	lw	a5,4(sp)
8000a3e4:	439c                	lw	a5,0(a5)
8000a3e6:	00176713          	or	a4,a4,1
8000a3ea:	0ff77713          	zext.b	a4,a4
8000a3ee:	00e78023          	sb	a4,0(a5)

8000a3f2 <.L101>:
            if (g_usbd_core[busid].remote_wakeup_enabled) {
8000a3f2:	00f14683          	lbu	a3,15(sp)
8000a3f6:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a3fa:	53c00793          	li	a5,1340
8000a3fe:	02f687b3          	mul	a5,a3,a5
8000a402:	97ba                	add	a5,a5,a4
8000a404:	4207c783          	lbu	a5,1056(a5)
8000a408:	cf89                	beqz	a5,8000a422 <.L102>
                (*data)[0] |= USB_GETSTATUS_REMOTE_WAKEUP;
8000a40a:	4792                	lw	a5,4(sp)
8000a40c:	439c                	lw	a5,0(a5)
8000a40e:	0007c703          	lbu	a4,0(a5)
8000a412:	4792                	lw	a5,4(sp)
8000a414:	439c                	lw	a5,0(a5)
8000a416:	00276713          	or	a4,a4,2
8000a41a:	0ff77713          	zext.b	a4,a4
8000a41e:	00e78023          	sb	a4,0(a5)

8000a422 <.L102>:
            (*data)[1] = 0x00;
8000a422:	4792                	lw	a5,4(sp)
8000a424:	439c                	lw	a5,0(a5)
8000a426:	0785                	add	a5,a5,1
8000a428:	00078023          	sb	zero,0(a5)
            *len = 2;
8000a42c:	4782                	lw	a5,0(sp)
8000a42e:	4709                	li	a4,2
8000a430:	c398                	sw	a4,0(a5)
            break;
8000a432:	aae1                	j	8000a60a <.L103>

8000a434 <.L99>:
            if (value == USB_FEATURE_REMOTE_WAKEUP) {
8000a434:	01c15703          	lhu	a4,28(sp)
8000a438:	4785                	li	a5,1
8000a43a:	08f71063          	bne	a4,a5,8000a4ba <.L104>
                if (setup->bRequest == USB_REQUEST_SET_FEATURE) {
8000a43e:	47a2                	lw	a5,8(sp)
8000a440:	0017c703          	lbu	a4,1(a5)
8000a444:	478d                	li	a5,3
8000a446:	02f71f63          	bne	a4,a5,8000a484 <.L105>
                    g_usbd_core[busid].remote_wakeup_enabled = true;
8000a44a:	00f14683          	lbu	a3,15(sp)
8000a44e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a452:	53c00793          	li	a5,1340
8000a456:	02f687b3          	mul	a5,a3,a5
8000a45a:	97ba                	add	a5,a5,a4
8000a45c:	4705                	li	a4,1
8000a45e:	42e78023          	sb	a4,1056(a5)
                    g_usbd_core[busid].event_handler(busid, USBD_EVENT_SET_REMOTE_WAKEUP);
8000a462:	00f14683          	lbu	a3,15(sp)
8000a466:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a46a:	53c00793          	li	a5,1340
8000a46e:	02f687b3          	mul	a5,a3,a5
8000a472:	97ba                	add	a5,a5,a4
8000a474:	5387a783          	lw	a5,1336(a5)
8000a478:	00f14703          	lbu	a4,15(sp)
8000a47c:	45a5                	li	a1,9
8000a47e:	853a                	mv	a0,a4
8000a480:	9782                	jalr	a5
8000a482:	a825                	j	8000a4ba <.L104>

8000a484 <.L105>:
                    g_usbd_core[busid].remote_wakeup_enabled = false;
8000a484:	00f14683          	lbu	a3,15(sp)
8000a488:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a48c:	53c00793          	li	a5,1340
8000a490:	02f687b3          	mul	a5,a3,a5
8000a494:	97ba                	add	a5,a5,a4
8000a496:	42078023          	sb	zero,1056(a5)
                    g_usbd_core[busid].event_handler(busid, USBD_EVENT_CLR_REMOTE_WAKEUP);
8000a49a:	00f14683          	lbu	a3,15(sp)
8000a49e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a4a2:	53c00793          	li	a5,1340
8000a4a6:	02f687b3          	mul	a5,a3,a5
8000a4aa:	97ba                	add	a5,a5,a4
8000a4ac:	5387a783          	lw	a5,1336(a5)
8000a4b0:	00f14703          	lbu	a4,15(sp)
8000a4b4:	45a9                	li	a1,10
8000a4b6:	853a                	mv	a0,a4
8000a4b8:	9782                	jalr	a5

8000a4ba <.L104>:
            *len = 0;
8000a4ba:	4782                	lw	a5,0(sp)
8000a4bc:	0007a023          	sw	zero,0(a5)
            break;
8000a4c0:	a2a9                	j	8000a60a <.L103>

8000a4c2 <.L98>:
            g_usbd_core[busid].device_address = value;
8000a4c2:	00f14603          	lbu	a2,15(sp)
8000a4c6:	01c15783          	lhu	a5,28(sp)
8000a4ca:	0ff7f713          	zext.b	a4,a5
8000a4ce:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000a4d2:	53c00793          	li	a5,1340
8000a4d6:	02f607b3          	mul	a5,a2,a5
8000a4da:	97b6                	add	a5,a5,a3
8000a4dc:	40e78ea3          	sb	a4,1053(a5)
            usbd_set_address(busid, value);
8000a4e0:	01c15783          	lhu	a5,28(sp)
8000a4e4:	0ff7f713          	zext.b	a4,a5
8000a4e8:	00f14783          	lbu	a5,15(sp)
8000a4ec:	85ba                	mv	a1,a4
8000a4ee:	853e                	mv	a0,a5
8000a4f0:	e77fc0ef          	jal	80007366 <usbd_set_address>
            *len = 0;
8000a4f4:	4782                	lw	a5,0(sp)
8000a4f6:	0007a023          	sw	zero,0(a5)
            break;
8000a4fa:	aa01                	j	8000a60a <.L103>

8000a4fc <.L97>:
            ret = usbd_get_descriptor(busid, value, data, len);
8000a4fc:	01c15703          	lhu	a4,28(sp)
8000a500:	00f14783          	lbu	a5,15(sp)
8000a504:	4682                	lw	a3,0(sp)
8000a506:	4612                	lw	a2,4(sp)
8000a508:	85ba                	mv	a1,a4
8000a50a:	853e                	mv	a0,a5
8000a50c:	c9efb0ef          	jal	800059aa <usbd_get_descriptor>
8000a510:	87aa                	mv	a5,a0
8000a512:	00f10fa3          	sb	a5,31(sp)
            break;
8000a516:	a8d5                	j	8000a60a <.L103>

8000a518 <.L96>:
            ret = false;
8000a518:	00010fa3          	sb	zero,31(sp)
            break;
8000a51c:	a0fd                	j	8000a60a <.L103>

8000a51e <.L95>:
            (*data)[0] = g_usbd_core[busid].configuration;
8000a51e:	00f14603          	lbu	a2,15(sp)
8000a522:	4792                	lw	a5,4(sp)
8000a524:	4398                	lw	a4,0(a5)
8000a526:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000a52a:	53c00793          	li	a5,1340
8000a52e:	02f607b3          	mul	a5,a2,a5
8000a532:	97b6                	add	a5,a5,a3
8000a534:	41c7c783          	lbu	a5,1052(a5)
8000a538:	00f70023          	sb	a5,0(a4)
            *len = 1;
8000a53c:	4782                	lw	a5,0(sp)
8000a53e:	4705                	li	a4,1
8000a540:	c398                	sw	a4,0(a5)
            break;
8000a542:	a0e1                	j	8000a60a <.L103>

8000a544 <.L94>:
            value &= 0xFF;
8000a544:	01c15783          	lhu	a5,28(sp)
8000a548:	0ff7f793          	zext.b	a5,a5
8000a54c:	00f11e23          	sh	a5,28(sp)
            if (value == 0) {
8000a550:	01c15783          	lhu	a5,28(sp)
8000a554:	ef89                	bnez	a5,8000a56e <.L106>
                g_usbd_core[busid].configuration = 0;
8000a556:	00f14683          	lbu	a3,15(sp)
8000a55a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a55e:	53c00793          	li	a5,1340
8000a562:	02f687b3          	mul	a5,a3,a5
8000a566:	97ba                	add	a5,a5,a4
8000a568:	40078e23          	sb	zero,1052(a5)
8000a56c:	a069                	j	8000a5f6 <.L107>

8000a56e <.L106>:
            } else if (!usbd_set_configuration(busid, value, 0)) {
8000a56e:	01c15783          	lhu	a5,28(sp)
8000a572:	0ff7f713          	zext.b	a4,a5
8000a576:	00f14783          	lbu	a5,15(sp)
8000a57a:	4601                	li	a2,0
8000a57c:	85ba                	mv	a1,a4
8000a57e:	853e                	mv	a0,a5
8000a580:	889fb0ef          	jal	80005e08 <usbd_set_configuration>
8000a584:	87aa                	mv	a5,a0
8000a586:	0017c793          	xor	a5,a5,1
8000a58a:	0ff7f793          	zext.b	a5,a5
8000a58e:	c781                	beqz	a5,8000a596 <.L108>
                ret = false;
8000a590:	00010fa3          	sb	zero,31(sp)
8000a594:	a08d                	j	8000a5f6 <.L107>

8000a596 <.L108>:
                g_usbd_core[busid].configuration = value;
8000a596:	00f14603          	lbu	a2,15(sp)
8000a59a:	01c15783          	lhu	a5,28(sp)
8000a59e:	0ff7f713          	zext.b	a4,a5
8000a5a2:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000a5a6:	53c00793          	li	a5,1340
8000a5aa:	02f607b3          	mul	a5,a2,a5
8000a5ae:	97b6                	add	a5,a5,a3
8000a5b0:	40e78e23          	sb	a4,1052(a5)
                g_usbd_core[busid].is_suspend = false;
8000a5b4:	00f14683          	lbu	a3,15(sp)
8000a5b8:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a5bc:	53c00793          	li	a5,1340
8000a5c0:	02f687b3          	mul	a5,a3,a5
8000a5c4:	97ba                	add	a5,a5,a4
8000a5c6:	420780a3          	sb	zero,1057(a5)
                usbd_class_event_notify_handler(busid, USBD_EVENT_CONFIGURED, NULL);
8000a5ca:	00f14783          	lbu	a5,15(sp)
8000a5ce:	4601                	li	a2,0
8000a5d0:	459d                	li	a1,7
8000a5d2:	853e                	mv	a0,a5
8000a5d4:	2c91                	jal	8000a828 <usbd_class_event_notify_handler>
                g_usbd_core[busid].event_handler(busid, USBD_EVENT_CONFIGURED);
8000a5d6:	00f14683          	lbu	a3,15(sp)
8000a5da:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a5de:	53c00793          	li	a5,1340
8000a5e2:	02f687b3          	mul	a5,a3,a5
8000a5e6:	97ba                	add	a5,a5,a4
8000a5e8:	5387a783          	lw	a5,1336(a5)
8000a5ec:	00f14703          	lbu	a4,15(sp)
8000a5f0:	459d                	li	a1,7
8000a5f2:	853a                	mv	a0,a4
8000a5f4:	9782                	jalr	a5

8000a5f6 <.L107>:
            *len = 0;
8000a5f6:	4782                	lw	a5,0(sp)
8000a5f8:	0007a023          	sw	zero,0(a5)
            break;
8000a5fc:	a039                	j	8000a60a <.L103>

8000a5fe <.L92>:
            ret = false;
8000a5fe:	00010fa3          	sb	zero,31(sp)
            break;
8000a602:	a021                	j	8000a60a <.L103>

8000a604 <.L91>:
            ret = false;
8000a604:	00010fa3          	sb	zero,31(sp)
            break;
8000a608:	0001                	nop

8000a60a <.L103>:
    return ret;
8000a60a:	01f14783          	lbu	a5,31(sp)
}
8000a60e:	853e                	mv	a0,a5
8000a610:	50b2                	lw	ra,44(sp)
8000a612:	6145                	add	sp,sp,48
8000a614:	8082                	ret

Disassembly of section .text.usbd_std_endpoint_req_handler:

8000a616 <usbd_std_endpoint_req_handler>:
{
8000a616:	7179                	add	sp,sp,-48
8000a618:	d606                	sw	ra,44(sp)
8000a61a:	87aa                	mv	a5,a0
8000a61c:	c42e                	sw	a1,8(sp)
8000a61e:	c232                	sw	a2,4(sp)
8000a620:	c036                	sw	a3,0(sp)
8000a622:	00f107a3          	sb	a5,15(sp)
    uint8_t ep = (uint8_t)setup->wIndex;
8000a626:	47a2                	lw	a5,8(sp)
8000a628:	0047c703          	lbu	a4,4(a5)
8000a62c:	0057c783          	lbu	a5,5(a5)
8000a630:	07a2                	sll	a5,a5,0x8
8000a632:	8fd9                	or	a5,a5,a4
8000a634:	07c2                	sll	a5,a5,0x10
8000a636:	83c1                	srl	a5,a5,0x10
8000a638:	00f10f23          	sb	a5,30(sp)
    bool ret = true;
8000a63c:	4785                	li	a5,1
8000a63e:	00f10fa3          	sb	a5,31(sp)
    if (!is_device_configured(busid)) {
8000a642:	00f14783          	lbu	a5,15(sp)
8000a646:	853e                	mv	a0,a5
8000a648:	39c1                	jal	8000a318 <is_device_configured>
8000a64a:	87aa                	mv	a5,a0
8000a64c:	0017c793          	xor	a5,a5,1
8000a650:	0ff7f793          	zext.b	a5,a5
8000a654:	c399                	beqz	a5,8000a65a <.L139>
        return false;
8000a656:	4781                	li	a5,0
8000a658:	aa31                	j	8000a774 <.L152>

8000a65a <.L139>:
    switch (setup->bRequest) {
8000a65a:	47a2                	lw	a5,8(sp)
8000a65c:	0017c783          	lbu	a5,1(a5)
8000a660:	4731                	li	a4,12
8000a662:	10e78163          	beq	a5,a4,8000a764 <.L141>
8000a666:	4731                	li	a4,12
8000a668:	10f74163          	blt	a4,a5,8000a76a <.L142>
8000a66c:	470d                	li	a4,3
8000a66e:	0ae78363          	beq	a5,a4,8000a714 <.L143>
8000a672:	470d                	li	a4,3
8000a674:	0ef74b63          	blt	a4,a5,8000a76a <.L142>
8000a678:	c789                	beqz	a5,8000a682 <.L144>
8000a67a:	4705                	li	a4,1
8000a67c:	04e78463          	beq	a5,a4,8000a6c4 <.L145>
8000a680:	a0ed                	j	8000a76a <.L142>

8000a682 <.L144>:
            usbd_ep_is_stalled(busid, ep, &stalled);
8000a682:	01d10693          	add	a3,sp,29
8000a686:	01e14703          	lbu	a4,30(sp)
8000a68a:	00f14783          	lbu	a5,15(sp)
8000a68e:	8636                	mv	a2,a3
8000a690:	85ba                	mv	a1,a4
8000a692:	853e                	mv	a0,a5
8000a694:	d91fc0ef          	jal	80007424 <usbd_ep_is_stalled>
            if (stalled) {
8000a698:	01d14783          	lbu	a5,29(sp)
8000a69c:	c799                	beqz	a5,8000a6aa <.L146>
                (*data)[0] = 0x01;
8000a69e:	4792                	lw	a5,4(sp)
8000a6a0:	439c                	lw	a5,0(a5)
8000a6a2:	4705                	li	a4,1
8000a6a4:	00e78023          	sb	a4,0(a5)
8000a6a8:	a029                	j	8000a6b2 <.L147>

8000a6aa <.L146>:
                (*data)[0] = 0x00;
8000a6aa:	4792                	lw	a5,4(sp)
8000a6ac:	439c                	lw	a5,0(a5)
8000a6ae:	00078023          	sb	zero,0(a5)

8000a6b2 <.L147>:
            (*data)[1] = 0x00;
8000a6b2:	4792                	lw	a5,4(sp)
8000a6b4:	439c                	lw	a5,0(a5)
8000a6b6:	0785                	add	a5,a5,1
8000a6b8:	00078023          	sb	zero,0(a5)
            *len = 2;
8000a6bc:	4782                	lw	a5,0(sp)
8000a6be:	4709                	li	a4,2
8000a6c0:	c398                	sw	a4,0(a5)
            break;
8000a6c2:	a07d                	j	8000a770 <.L148>

8000a6c4 <.L145>:
            if (setup->wValue == USB_FEATURE_ENDPOINT_HALT) {
8000a6c4:	47a2                	lw	a5,8(sp)
8000a6c6:	0027c703          	lbu	a4,2(a5)
8000a6ca:	0037c783          	lbu	a5,3(a5)
8000a6ce:	07a2                	sll	a5,a5,0x8
8000a6d0:	8fd9                	or	a5,a5,a4
8000a6d2:	07c2                	sll	a5,a5,0x10
8000a6d4:	83c1                	srl	a5,a5,0x10
8000a6d6:	eb8d                	bnez	a5,8000a708 <.L149>
                USB_LOG_ERR("ep:%02x clear halt\r\n", ep);
8000a6d8:	800057b7          	lui	a5,0x80005
8000a6dc:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
8000a6e0:	dfcfe0ef          	jal	80008cdc <printf>
8000a6e4:	01e14783          	lbu	a5,30(sp)
8000a6e8:	85be                	mv	a1,a5
8000a6ea:	800057b7          	lui	a5,0x80005
8000a6ee:	05c78513          	add	a0,a5,92 # 8000505c <.LC5>
8000a6f2:	deafe0ef          	jal	80008cdc <printf>
                usbd_ep_clear_stall(busid, ep);
8000a6f6:	01e14703          	lbu	a4,30(sp)
8000a6fa:	00f14783          	lbu	a5,15(sp)
8000a6fe:	85ba                	mv	a1,a4
8000a700:	853e                	mv	a0,a5
8000a702:	ce5fc0ef          	jal	800073e6 <usbd_ep_clear_stall>
                break;
8000a706:	a0ad                	j	8000a770 <.L148>

8000a708 <.L149>:
                ret = false;
8000a708:	00010fa3          	sb	zero,31(sp)
            *len = 0;
8000a70c:	4782                	lw	a5,0(sp)
8000a70e:	0007a023          	sw	zero,0(a5)
            break;
8000a712:	a8b9                	j	8000a770 <.L148>

8000a714 <.L143>:
            if (setup->wValue == USB_FEATURE_ENDPOINT_HALT) {
8000a714:	47a2                	lw	a5,8(sp)
8000a716:	0027c703          	lbu	a4,2(a5)
8000a71a:	0037c783          	lbu	a5,3(a5)
8000a71e:	07a2                	sll	a5,a5,0x8
8000a720:	8fd9                	or	a5,a5,a4
8000a722:	07c2                	sll	a5,a5,0x10
8000a724:	83c1                	srl	a5,a5,0x10
8000a726:	eb8d                	bnez	a5,8000a758 <.L150>
                USB_LOG_ERR("ep:%02x set halt\r\n", ep);
8000a728:	800057b7          	lui	a5,0x80005
8000a72c:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
8000a730:	dacfe0ef          	jal	80008cdc <printf>
8000a734:	01e14783          	lbu	a5,30(sp)
8000a738:	85be                	mv	a1,a5
8000a73a:	800057b7          	lui	a5,0x80005
8000a73e:	07478513          	add	a0,a5,116 # 80005074 <.LC6>
8000a742:	d9afe0ef          	jal	80008cdc <printf>
                usbd_ep_set_stall(busid, ep);
8000a746:	01e14703          	lbu	a4,30(sp)
8000a74a:	00f14783          	lbu	a5,15(sp)
8000a74e:	85ba                	mv	a1,a4
8000a750:	853e                	mv	a0,a5
8000a752:	c57fc0ef          	jal	800073a8 <usbd_ep_set_stall>
8000a756:	a019                	j	8000a75c <.L151>

8000a758 <.L150>:
                ret = false;
8000a758:	00010fa3          	sb	zero,31(sp)

8000a75c <.L151>:
            *len = 0;
8000a75c:	4782                	lw	a5,0(sp)
8000a75e:	0007a023          	sw	zero,0(a5)
            break;
8000a762:	a039                	j	8000a770 <.L148>

8000a764 <.L141>:
            ret = false;
8000a764:	00010fa3          	sb	zero,31(sp)
            break;
8000a768:	a021                	j	8000a770 <.L148>

8000a76a <.L142>:
            ret = false;
8000a76a:	00010fa3          	sb	zero,31(sp)
            break;
8000a76e:	0001                	nop

8000a770 <.L148>:
    return ret;
8000a770:	01f14783          	lbu	a5,31(sp)

8000a774 <.L152>:
}
8000a774:	853e                	mv	a0,a5
8000a776:	50b2                	lw	ra,44(sp)
8000a778:	6145                	add	sp,sp,48
8000a77a:	8082                	ret

Disassembly of section .text.usbd_standard_request_handler:

8000a77c <usbd_standard_request_handler>:
{
8000a77c:	7179                	add	sp,sp,-48
8000a77e:	d606                	sw	ra,44(sp)
8000a780:	87aa                	mv	a5,a0
8000a782:	c42e                	sw	a1,8(sp)
8000a784:	c232                	sw	a2,4(sp)
8000a786:	c036                	sw	a3,0(sp)
8000a788:	00f107a3          	sb	a5,15(sp)
    int rc = 0;
8000a78c:	ce02                	sw	zero,28(sp)
    switch (setup->bmRequestType & USB_REQUEST_RECIPIENT_MASK) {
8000a78e:	47a2                	lw	a5,8(sp)
8000a790:	0007c783          	lbu	a5,0(a5)
8000a794:	8b8d                	and	a5,a5,3
8000a796:	4709                	li	a4,2
8000a798:	04e78b63          	beq	a5,a4,8000a7ee <.L154>
8000a79c:	4709                	li	a4,2
8000a79e:	06f76863          	bltu	a4,a5,8000a80e <.L155>
8000a7a2:	c789                	beqz	a5,8000a7ac <.L156>
8000a7a4:	4705                	li	a4,1
8000a7a6:	02e78363          	beq	a5,a4,8000a7cc <.L157>
8000a7aa:	a095                	j	8000a80e <.L155>

8000a7ac <.L156>:
            if (usbd_std_device_req_handler(busid, setup, data, len) == false) {
8000a7ac:	00f14783          	lbu	a5,15(sp)
8000a7b0:	4682                	lw	a3,0(sp)
8000a7b2:	4612                	lw	a2,4(sp)
8000a7b4:	45a2                	lw	a1,8(sp)
8000a7b6:	853e                	mv	a0,a5
8000a7b8:	3e75                	jal	8000a374 <usbd_std_device_req_handler>
8000a7ba:	87aa                	mv	a5,a0
8000a7bc:	0017c793          	xor	a5,a5,1
8000a7c0:	0ff7f793          	zext.b	a5,a5
8000a7c4:	cba1                	beqz	a5,8000a814 <.L163>
                rc = -1;
8000a7c6:	57fd                	li	a5,-1
8000a7c8:	ce3e                	sw	a5,28(sp)
            break;
8000a7ca:	a0a9                	j	8000a814 <.L163>

8000a7cc <.L157>:
            if (usbd_std_interface_req_handler(busid, setup, data, len) == false) {
8000a7cc:	00f14783          	lbu	a5,15(sp)
8000a7d0:	4682                	lw	a3,0(sp)
8000a7d2:	4612                	lw	a2,4(sp)
8000a7d4:	45a2                	lw	a1,8(sp)
8000a7d6:	853e                	mv	a0,a5
8000a7d8:	8e7fb0ef          	jal	800060be <usbd_std_interface_req_handler>
8000a7dc:	87aa                	mv	a5,a0
8000a7de:	0017c793          	xor	a5,a5,1
8000a7e2:	0ff7f793          	zext.b	a5,a5
8000a7e6:	cb8d                	beqz	a5,8000a818 <.L164>
                rc = -1;
8000a7e8:	57fd                	li	a5,-1
8000a7ea:	ce3e                	sw	a5,28(sp)
            break;
8000a7ec:	a035                	j	8000a818 <.L164>

8000a7ee <.L154>:
            if (usbd_std_endpoint_req_handler(busid, setup, data, len) == false) {
8000a7ee:	00f14783          	lbu	a5,15(sp)
8000a7f2:	4682                	lw	a3,0(sp)
8000a7f4:	4612                	lw	a2,4(sp)
8000a7f6:	45a2                	lw	a1,8(sp)
8000a7f8:	853e                	mv	a0,a5
8000a7fa:	3d31                	jal	8000a616 <usbd_std_endpoint_req_handler>
8000a7fc:	87aa                	mv	a5,a0
8000a7fe:	0017c793          	xor	a5,a5,1
8000a802:	0ff7f793          	zext.b	a5,a5
8000a806:	cb99                	beqz	a5,8000a81c <.L165>
                rc = -1;
8000a808:	57fd                	li	a5,-1
8000a80a:	ce3e                	sw	a5,28(sp)
            break;
8000a80c:	a801                	j	8000a81c <.L165>

8000a80e <.L155>:
            rc = -1;
8000a80e:	57fd                	li	a5,-1
8000a810:	ce3e                	sw	a5,28(sp)
            break;
8000a812:	a031                	j	8000a81e <.L159>

8000a814 <.L163>:
            break;
8000a814:	0001                	nop
8000a816:	a021                	j	8000a81e <.L159>

8000a818 <.L164>:
            break;
8000a818:	0001                	nop
8000a81a:	a011                	j	8000a81e <.L159>

8000a81c <.L165>:
            break;
8000a81c:	0001                	nop

8000a81e <.L159>:
    return rc;
8000a81e:	47f2                	lw	a5,28(sp)
}
8000a820:	853e                	mv	a0,a5
8000a822:	50b2                	lw	ra,44(sp)
8000a824:	6145                	add	sp,sp,48
8000a826:	8082                	ret

Disassembly of section .text.usbd_class_event_notify_handler:

8000a828 <usbd_class_event_notify_handler>:
{
8000a828:	7179                	add	sp,sp,-48
8000a82a:	d606                	sw	ra,44(sp)
8000a82c:	87aa                	mv	a5,a0
8000a82e:	872e                	mv	a4,a1
8000a830:	c432                	sw	a2,8(sp)
8000a832:	00f107a3          	sb	a5,15(sp)
8000a836:	87ba                	mv	a5,a4
8000a838:	00f10723          	sb	a5,14(sp)

8000a83c <.LBB12>:
    for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
8000a83c:	00010fa3          	sb	zero,31(sp)
8000a840:	a051                	j	8000a8c4 <.L205>

8000a842 <.L208>:
        struct usbd_interface *intf = g_usbd_core[busid].intf[i];
8000a842:	00f14603          	lbu	a2,15(sp)
8000a846:	01f14783          	lbu	a5,31(sp)
8000a84a:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a84e:	14f00693          	li	a3,335
8000a852:	02d606b3          	mul	a3,a2,a3
8000a856:	97b6                	add	a5,a5,a3
8000a858:	10878793          	add	a5,a5,264
8000a85c:	078a                	sll	a5,a5,0x2
8000a85e:	97ba                	add	a5,a5,a4
8000a860:	43dc                	lw	a5,4(a5)
8000a862:	cc3e                	sw	a5,24(sp)
        if (arg) {
8000a864:	47a2                	lw	a5,8(sp)
8000a866:	cb9d                	beqz	a5,8000a89c <.L206>

8000a868 <.LBB14>:
            struct usb_interface_descriptor *desc = (struct usb_interface_descriptor *)arg;
8000a868:	47a2                	lw	a5,8(sp)
8000a86a:	ca3e                	sw	a5,20(sp)
            if (intf && intf->notify_handler && (desc->bInterfaceNumber == (intf->intf_num))) {
8000a86c:	47e2                	lw	a5,24(sp)
8000a86e:	c7b1                	beqz	a5,8000a8ba <.L207>
8000a870:	47e2                	lw	a5,24(sp)
8000a872:	47dc                	lw	a5,12(a5)
8000a874:	c3b9                	beqz	a5,8000a8ba <.L207>
8000a876:	47d2                	lw	a5,20(sp)
8000a878:	0027c703          	lbu	a4,2(a5)
8000a87c:	47e2                	lw	a5,24(sp)
8000a87e:	0187c783          	lbu	a5,24(a5)
8000a882:	02f71c63          	bne	a4,a5,8000a8ba <.L207>
                intf->notify_handler(busid, event, arg);
8000a886:	47e2                	lw	a5,24(sp)
8000a888:	47dc                	lw	a5,12(a5)
8000a88a:	00e14683          	lbu	a3,14(sp)
8000a88e:	00f14703          	lbu	a4,15(sp)
8000a892:	4622                	lw	a2,8(sp)
8000a894:	85b6                	mv	a1,a3
8000a896:	853a                	mv	a0,a4
8000a898:	9782                	jalr	a5
8000a89a:	a005                	j	8000a8ba <.L207>

8000a89c <.L206>:
            if (intf && intf->notify_handler) {
8000a89c:	47e2                	lw	a5,24(sp)
8000a89e:	cf91                	beqz	a5,8000a8ba <.L207>
8000a8a0:	47e2                	lw	a5,24(sp)
8000a8a2:	47dc                	lw	a5,12(a5)
8000a8a4:	cb99                	beqz	a5,8000a8ba <.L207>
                intf->notify_handler(busid, event, arg);
8000a8a6:	47e2                	lw	a5,24(sp)
8000a8a8:	47dc                	lw	a5,12(a5)
8000a8aa:	00e14683          	lbu	a3,14(sp)
8000a8ae:	00f14703          	lbu	a4,15(sp)
8000a8b2:	4622                	lw	a2,8(sp)
8000a8b4:	85b6                	mv	a1,a3
8000a8b6:	853a                	mv	a0,a4
8000a8b8:	9782                	jalr	a5

8000a8ba <.L207>:
    for (uint8_t i = 0; i < g_usbd_core[busid].intf_offset; i++) {
8000a8ba:	01f14783          	lbu	a5,31(sp)
8000a8be:	0785                	add	a5,a5,1
8000a8c0:	00f10fa3          	sb	a5,31(sp)

8000a8c4 <.L205>:
8000a8c4:	00f14683          	lbu	a3,15(sp)
8000a8c8:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a8cc:	53c00793          	li	a5,1340
8000a8d0:	02f687b3          	mul	a5,a3,a5
8000a8d4:	97ba                	add	a5,a5,a4
8000a8d6:	4747c783          	lbu	a5,1140(a5)
8000a8da:	01f14703          	lbu	a4,31(sp)
8000a8de:	f6f762e3          	bltu	a4,a5,8000a842 <.L208>

8000a8e2 <.LBE12>:
}
8000a8e2:	0001                	nop
8000a8e4:	0001                	nop
8000a8e6:	50b2                	lw	ra,44(sp)
8000a8e8:	6145                	add	sp,sp,48
8000a8ea:	8082                	ret

Disassembly of section .text.usbd_event_resume_handler:

8000a8ec <usbd_event_resume_handler>:
{
8000a8ec:	1101                	add	sp,sp,-32
8000a8ee:	ce06                	sw	ra,28(sp)
8000a8f0:	87aa                	mv	a5,a0
8000a8f2:	00f107a3          	sb	a5,15(sp)
    g_usbd_core[busid].is_suspend = false;
8000a8f6:	00f14683          	lbu	a3,15(sp)
8000a8fa:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a8fe:	53c00793          	li	a5,1340
8000a902:	02f687b3          	mul	a5,a3,a5
8000a906:	97ba                	add	a5,a5,a4
8000a908:	420780a3          	sb	zero,1057(a5)
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_RESUME);
8000a90c:	00f14683          	lbu	a3,15(sp)
8000a910:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a914:	53c00793          	li	a5,1340
8000a918:	02f687b3          	mul	a5,a3,a5
8000a91c:	97ba                	add	a5,a5,a4
8000a91e:	5387a783          	lw	a5,1336(a5)
8000a922:	00f14703          	lbu	a4,15(sp)
8000a926:	4599                	li	a1,6
8000a928:	853a                	mv	a0,a4
8000a92a:	9782                	jalr	a5
}
8000a92c:	0001                	nop
8000a92e:	40f2                	lw	ra,28(sp)
8000a930:	6105                	add	sp,sp,32
8000a932:	8082                	ret

Disassembly of section .text.usbd_event_ep0_in_complete_handler:

8000a934 <usbd_event_ep0_in_complete_handler>:
{
8000a934:	7179                	add	sp,sp,-48
8000a936:	d606                	sw	ra,44(sp)
8000a938:	87aa                	mv	a5,a0
8000a93a:	872e                	mv	a4,a1
8000a93c:	c432                	sw	a2,8(sp)
8000a93e:	00f107a3          	sb	a5,15(sp)
8000a942:	87ba                	mv	a5,a4
8000a944:	00f10723          	sb	a5,14(sp)
    struct usb_setup_packet *setup = &g_usbd_core[busid].setup;
8000a948:	00f14703          	lbu	a4,15(sp)
8000a94c:	53c00793          	li	a5,1340
8000a950:	02f70733          	mul	a4,a4,a5
8000a954:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
8000a958:	97ba                	add	a5,a5,a4
8000a95a:	ce3e                	sw	a5,28(sp)
    g_usbd_core[busid].ep0_data_buf += nbytes;
8000a95c:	00f14683          	lbu	a3,15(sp)
8000a960:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a964:	53c00793          	li	a5,1340
8000a968:	02f687b3          	mul	a5,a3,a5
8000a96c:	97ba                	add	a5,a5,a4
8000a96e:	4798                	lw	a4,8(a5)
8000a970:	00f14603          	lbu	a2,15(sp)
8000a974:	47a2                	lw	a5,8(sp)
8000a976:	973e                	add	a4,a4,a5
8000a978:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000a97c:	53c00793          	li	a5,1340
8000a980:	02f607b3          	mul	a5,a2,a5
8000a984:	97b6                	add	a5,a5,a3
8000a986:	c798                	sw	a4,8(a5)
    g_usbd_core[busid].ep0_data_buf_residue -= nbytes;
8000a988:	00f14683          	lbu	a3,15(sp)
8000a98c:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a990:	53c00793          	li	a5,1340
8000a994:	02f687b3          	mul	a5,a3,a5
8000a998:	97ba                	add	a5,a5,a4
8000a99a:	47d8                	lw	a4,12(a5)
8000a99c:	00f14603          	lbu	a2,15(sp)
8000a9a0:	47a2                	lw	a5,8(sp)
8000a9a2:	8f1d                	sub	a4,a4,a5
8000a9a4:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000a9a8:	53c00793          	li	a5,1340
8000a9ac:	02f607b3          	mul	a5,a2,a5
8000a9b0:	97b6                	add	a5,a5,a3
8000a9b2:	c7d8                	sw	a4,12(a5)
    if (g_usbd_core[busid].ep0_data_buf_residue != 0) {
8000a9b4:	00f14683          	lbu	a3,15(sp)
8000a9b8:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a9bc:	53c00793          	li	a5,1340
8000a9c0:	02f687b3          	mul	a5,a3,a5
8000a9c4:	97ba                	add	a5,a5,a4
8000a9c6:	47dc                	lw	a5,12(a5)
8000a9c8:	cf8d                	beqz	a5,8000aa02 <.L227>
        usbd_ep_start_write(busid, USB_CONTROL_IN_EP0, g_usbd_core[busid].ep0_data_buf, g_usbd_core[busid].ep0_data_buf_residue);
8000a9ca:	00f14683          	lbu	a3,15(sp)
8000a9ce:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a9d2:	53c00793          	li	a5,1340
8000a9d6:	02f687b3          	mul	a5,a3,a5
8000a9da:	97ba                	add	a5,a5,a4
8000a9dc:	4790                	lw	a2,8(a5)
8000a9de:	00f14683          	lbu	a3,15(sp)
8000a9e2:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000a9e6:	53c00793          	li	a5,1340
8000a9ea:	02f687b3          	mul	a5,a3,a5
8000a9ee:	97ba                	add	a5,a5,a4
8000a9f0:	47d8                	lw	a4,12(a5)
8000a9f2:	00f14783          	lbu	a5,15(sp)
8000a9f6:	86ba                	mv	a3,a4
8000a9f8:	08000593          	li	a1,128
8000a9fc:	853e                	mv	a0,a5
8000a9fe:	27a5                	jal	8000b166 <usbd_ep_start_write>
}
8000aa00:	a88d                	j	8000aa72 <.L230>

8000aa02 <.L227>:
        if (g_usbd_core[busid].zlp_flag == true) {
8000aa02:	00f14683          	lbu	a3,15(sp)
8000aa06:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000aa0a:	53c00793          	li	a5,1340
8000aa0e:	02f687b3          	mul	a5,a3,a5
8000aa12:	97ba                	add	a5,a5,a4
8000aa14:	0147c783          	lbu	a5,20(a5)
8000aa18:	c78d                	beqz	a5,8000aa42 <.L229>
            g_usbd_core[busid].zlp_flag = false;
8000aa1a:	00f14683          	lbu	a3,15(sp)
8000aa1e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000aa22:	53c00793          	li	a5,1340
8000aa26:	02f687b3          	mul	a5,a3,a5
8000aa2a:	97ba                	add	a5,a5,a4
8000aa2c:	00078a23          	sb	zero,20(a5)
            usbd_ep_start_write(busid, USB_CONTROL_IN_EP0, NULL, 0);
8000aa30:	00f14783          	lbu	a5,15(sp)
8000aa34:	4681                	li	a3,0
8000aa36:	4601                	li	a2,0
8000aa38:	08000593          	li	a1,128
8000aa3c:	853e                	mv	a0,a5
8000aa3e:	2725                	jal	8000b166 <usbd_ep_start_write>
}
8000aa40:	a80d                	j	8000aa72 <.L230>

8000aa42 <.L229>:
            if (setup->wLength && ((setup->bmRequestType & USB_REQUEST_DIR_MASK) == USB_REQUEST_DIR_IN)) {
8000aa42:	47f2                	lw	a5,28(sp)
8000aa44:	0067c703          	lbu	a4,6(a5)
8000aa48:	0077c783          	lbu	a5,7(a5)
8000aa4c:	07a2                	sll	a5,a5,0x8
8000aa4e:	8fd9                	or	a5,a5,a4
8000aa50:	07c2                	sll	a5,a5,0x10
8000aa52:	83c1                	srl	a5,a5,0x10
8000aa54:	cf99                	beqz	a5,8000aa72 <.L230>
8000aa56:	47f2                	lw	a5,28(sp)
8000aa58:	0007c783          	lbu	a5,0(a5)
8000aa5c:	07e2                	sll	a5,a5,0x18
8000aa5e:	87e1                	sra	a5,a5,0x18
8000aa60:	0007d963          	bgez	a5,8000aa72 <.L230>
                usbd_ep_start_read(busid, USB_CONTROL_OUT_EP0, NULL, 0);
8000aa64:	00f14783          	lbu	a5,15(sp)
8000aa68:	4681                	li	a3,0
8000aa6a:	4601                	li	a2,0
8000aa6c:	4581                	li	a1,0
8000aa6e:	853e                	mv	a0,a5
8000aa70:	27ed                	jal	8000b25a <usbd_ep_start_read>

8000aa72 <.L230>:
}
8000aa72:	0001                	nop
8000aa74:	50b2                	lw	ra,44(sp)
8000aa76:	6145                	add	sp,sp,48
8000aa78:	8082                	ret

Disassembly of section .text.usbd_event_ep0_out_complete_handler:

8000aa7a <usbd_event_ep0_out_complete_handler>:
{
8000aa7a:	7179                	add	sp,sp,-48
8000aa7c:	d606                	sw	ra,44(sp)
8000aa7e:	87aa                	mv	a5,a0
8000aa80:	872e                	mv	a4,a1
8000aa82:	c432                	sw	a2,8(sp)
8000aa84:	00f107a3          	sb	a5,15(sp)
8000aa88:	87ba                	mv	a5,a4
8000aa8a:	00f10723          	sb	a5,14(sp)
    struct usb_setup_packet *setup = &g_usbd_core[busid].setup;
8000aa8e:	00f14703          	lbu	a4,15(sp)
8000aa92:	53c00793          	li	a5,1340
8000aa96:	02f70733          	mul	a4,a4,a5
8000aa9a:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
8000aa9e:	97ba                	add	a5,a5,a4
8000aaa0:	ce3e                	sw	a5,28(sp)
    if (nbytes > 0) {
8000aaa2:	47a2                	lw	a5,8(sp)
8000aaa4:	12078e63          	beqz	a5,8000abe0 <.L231>
        g_usbd_core[busid].ep0_data_buf += nbytes;
8000aaa8:	00f14683          	lbu	a3,15(sp)
8000aaac:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000aab0:	53c00793          	li	a5,1340
8000aab4:	02f687b3          	mul	a5,a3,a5
8000aab8:	97ba                	add	a5,a5,a4
8000aaba:	4798                	lw	a4,8(a5)
8000aabc:	00f14603          	lbu	a2,15(sp)
8000aac0:	47a2                	lw	a5,8(sp)
8000aac2:	973e                	add	a4,a4,a5
8000aac4:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000aac8:	53c00793          	li	a5,1340
8000aacc:	02f607b3          	mul	a5,a2,a5
8000aad0:	97b6                	add	a5,a5,a3
8000aad2:	c798                	sw	a4,8(a5)
        g_usbd_core[busid].ep0_data_buf_residue -= nbytes;
8000aad4:	00f14683          	lbu	a3,15(sp)
8000aad8:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000aadc:	53c00793          	li	a5,1340
8000aae0:	02f687b3          	mul	a5,a3,a5
8000aae4:	97ba                	add	a5,a5,a4
8000aae6:	47d8                	lw	a4,12(a5)
8000aae8:	00f14603          	lbu	a2,15(sp)
8000aaec:	47a2                	lw	a5,8(sp)
8000aaee:	8f1d                	sub	a4,a4,a5
8000aaf0:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000aaf4:	53c00793          	li	a5,1340
8000aaf8:	02f607b3          	mul	a5,a2,a5
8000aafc:	97b6                	add	a5,a5,a3
8000aafe:	c7d8                	sw	a4,12(a5)
        if (g_usbd_core[busid].ep0_data_buf_residue == 0) {
8000ab00:	00f14683          	lbu	a3,15(sp)
8000ab04:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000ab08:	53c00793          	li	a5,1340
8000ab0c:	02f687b3          	mul	a5,a3,a5
8000ab10:	97ba                	add	a5,a5,a4
8000ab12:	47dc                	lw	a5,12(a5)
8000ab14:	efc1                	bnez	a5,8000abac <.L233>
            g_usbd_core[busid].ep0_data_buf = g_usbd_core[busid].req_data;
8000ab16:	00f14703          	lbu	a4,15(sp)
8000ab1a:	00f14603          	lbu	a2,15(sp)
8000ab1e:	53c00793          	li	a5,1340
8000ab22:	02f707b3          	mul	a5,a4,a5
8000ab26:	01078713          	add	a4,a5,16
8000ab2a:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
8000ab2e:	97ba                	add	a5,a5,a4
8000ab30:	00c78713          	add	a4,a5,12
8000ab34:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000ab38:	53c00793          	li	a5,1340
8000ab3c:	02f607b3          	mul	a5,a2,a5
8000ab40:	97b6                	add	a5,a5,a3
8000ab42:	c798                	sw	a4,8(a5)
            if (!usbd_setup_request_handler(busid, setup, &g_usbd_core[busid].ep0_data_buf, &g_usbd_core[busid].ep0_data_buf_len)) {
8000ab44:	00f14703          	lbu	a4,15(sp)
8000ab48:	53c00793          	li	a5,1340
8000ab4c:	02f70733          	mul	a4,a4,a5
8000ab50:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
8000ab54:	97ba                	add	a5,a5,a4
8000ab56:	00878613          	add	a2,a5,8
8000ab5a:	00f14703          	lbu	a4,15(sp)
8000ab5e:	53c00793          	li	a5,1340
8000ab62:	02f707b3          	mul	a5,a4,a5
8000ab66:	01078713          	add	a4,a5,16
8000ab6a:	80018793          	add	a5,gp,-2048 # 1104c10 <g_usbd_core>
8000ab6e:	973e                	add	a4,a4,a5
8000ab70:	00f14783          	lbu	a5,15(sp)
8000ab74:	86ba                	mv	a3,a4
8000ab76:	45f2                	lw	a1,28(sp)
8000ab78:	853e                	mv	a0,a5
8000ab7a:	de5fb0ef          	jal	8000695e <usbd_setup_request_handler>
8000ab7e:	87aa                	mv	a5,a0
8000ab80:	0017c793          	xor	a5,a5,1
8000ab84:	0ff7f793          	zext.b	a5,a5
8000ab88:	cb89                	beqz	a5,8000ab9a <.L234>
                usbd_ep_set_stall(busid, USB_CONTROL_IN_EP0);
8000ab8a:	00f14783          	lbu	a5,15(sp)
8000ab8e:	08000593          	li	a1,128
8000ab92:	853e                	mv	a0,a5
8000ab94:	815fc0ef          	jal	800073a8 <usbd_ep_set_stall>
                return;
8000ab98:	a0a1                	j	8000abe0 <.L231>

8000ab9a <.L234>:
            usbd_ep_start_write(busid, USB_CONTROL_IN_EP0, NULL, 0);
8000ab9a:	00f14783          	lbu	a5,15(sp)
8000ab9e:	4681                	li	a3,0
8000aba0:	4601                	li	a2,0
8000aba2:	08000593          	li	a1,128
8000aba6:	853e                	mv	a0,a5
8000aba8:	2b7d                	jal	8000b166 <usbd_ep_start_write>
8000abaa:	a81d                	j	8000abe0 <.L231>

8000abac <.L233>:
            usbd_ep_start_read(busid, USB_CONTROL_OUT_EP0, g_usbd_core[busid].ep0_data_buf, g_usbd_core[busid].ep0_data_buf_residue);
8000abac:	00f14683          	lbu	a3,15(sp)
8000abb0:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000abb4:	53c00793          	li	a5,1340
8000abb8:	02f687b3          	mul	a5,a3,a5
8000abbc:	97ba                	add	a5,a5,a4
8000abbe:	4790                	lw	a2,8(a5)
8000abc0:	00f14683          	lbu	a3,15(sp)
8000abc4:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000abc8:	53c00793          	li	a5,1340
8000abcc:	02f687b3          	mul	a5,a3,a5
8000abd0:	97ba                	add	a5,a5,a4
8000abd2:	47d8                	lw	a4,12(a5)
8000abd4:	00f14783          	lbu	a5,15(sp)
8000abd8:	86ba                	mv	a3,a4
8000abda:	4581                	li	a1,0
8000abdc:	853e                	mv	a0,a5
8000abde:	2db5                	jal	8000b25a <usbd_ep_start_read>

8000abe0 <.L231>:
}
8000abe0:	50b2                	lw	ra,44(sp)
8000abe2:	6145                	add	sp,sp,48
8000abe4:	8082                	ret

Disassembly of section .text.usbd_add_interface:

8000abe6 <usbd_add_interface>:
{
8000abe6:	1141                	add	sp,sp,-16
8000abe8:	87aa                	mv	a5,a0
8000abea:	c42e                	sw	a1,8(sp)
8000abec:	00f107a3          	sb	a5,15(sp)
    intf->intf_num = g_usbd_core[busid].intf_offset;
8000abf0:	00f14683          	lbu	a3,15(sp)
8000abf4:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000abf8:	53c00793          	li	a5,1340
8000abfc:	02f687b3          	mul	a5,a3,a5
8000ac00:	97ba                	add	a5,a5,a4
8000ac02:	4747c703          	lbu	a4,1140(a5)
8000ac06:	47a2                	lw	a5,8(sp)
8000ac08:	00e78c23          	sb	a4,24(a5)
    g_usbd_core[busid].intf[g_usbd_core[busid].intf_offset] = intf;
8000ac0c:	00f14683          	lbu	a3,15(sp)
8000ac10:	00f14603          	lbu	a2,15(sp)
8000ac14:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000ac18:	53c00793          	li	a5,1340
8000ac1c:	02f607b3          	mul	a5,a2,a5
8000ac20:	97ba                	add	a5,a5,a4
8000ac22:	4747c783          	lbu	a5,1140(a5)
8000ac26:	863e                	mv	a2,a5
8000ac28:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000ac2c:	14f00793          	li	a5,335
8000ac30:	02f687b3          	mul	a5,a3,a5
8000ac34:	97b2                	add	a5,a5,a2
8000ac36:	10878793          	add	a5,a5,264
8000ac3a:	078a                	sll	a5,a5,0x2
8000ac3c:	97ba                	add	a5,a5,a4
8000ac3e:	4722                	lw	a4,8(sp)
8000ac40:	c3d8                	sw	a4,4(a5)
    g_usbd_core[busid].intf_offset++;
8000ac42:	00f14703          	lbu	a4,15(sp)
8000ac46:	80018693          	add	a3,gp,-2048 # 1104c10 <g_usbd_core>
8000ac4a:	53c00793          	li	a5,1340
8000ac4e:	02f707b3          	mul	a5,a4,a5
8000ac52:	97b6                	add	a5,a5,a3
8000ac54:	4747c783          	lbu	a5,1140(a5)
8000ac58:	0785                	add	a5,a5,1
8000ac5a:	0ff7f693          	zext.b	a3,a5
8000ac5e:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
8000ac62:	53c00793          	li	a5,1340
8000ac66:	02f707b3          	mul	a5,a4,a5
8000ac6a:	97b2                	add	a5,a5,a2
8000ac6c:	46d78a23          	sb	a3,1140(a5)
}
8000ac70:	0001                	nop
8000ac72:	0141                	add	sp,sp,16
8000ac74:	8082                	ret

Disassembly of section .text.usbd_add_endpoint:

8000ac76 <usbd_add_endpoint>:
{
8000ac76:	1141                	add	sp,sp,-16
8000ac78:	87aa                	mv	a5,a0
8000ac7a:	c42e                	sw	a1,8(sp)
8000ac7c:	00f107a3          	sb	a5,15(sp)
    if (ep->ep_addr & 0x80) {
8000ac80:	47a2                	lw	a5,8(sp)
8000ac82:	0007c783          	lbu	a5,0(a5)
8000ac86:	07e2                	sll	a5,a5,0x18
8000ac88:	87e1                	sra	a5,a5,0x18
8000ac8a:	0607d263          	bgez	a5,8000acee <.L244>
        g_usbd_core[busid].tx_msg[ep->ep_addr & 0x7f].ep = ep->ep_addr;
8000ac8e:	00f14583          	lbu	a1,15(sp)
8000ac92:	47a2                	lw	a5,8(sp)
8000ac94:	0007c783          	lbu	a5,0(a5)
8000ac98:	07f7f713          	and	a4,a5,127
8000ac9c:	47a2                	lw	a5,8(sp)
8000ac9e:	0007c683          	lbu	a3,0(a5)
8000aca2:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
8000aca6:	87ba                	mv	a5,a4
8000aca8:	0786                	sll	a5,a5,0x1
8000acaa:	97ba                	add	a5,a5,a4
8000acac:	078a                	sll	a5,a5,0x2
8000acae:	53c00713          	li	a4,1340
8000acb2:	02e58733          	mul	a4,a1,a4
8000acb6:	97ba                	add	a5,a5,a4
8000acb8:	97b2                	add	a5,a5,a2
8000acba:	46d78c23          	sb	a3,1144(a5)
        g_usbd_core[busid].tx_msg[ep->ep_addr & 0x7f].cb = ep->ep_cb;
8000acbe:	00f14583          	lbu	a1,15(sp)
8000acc2:	47a2                	lw	a5,8(sp)
8000acc4:	0007c783          	lbu	a5,0(a5)
8000acc8:	07f7f713          	and	a4,a5,127
8000accc:	47a2                	lw	a5,8(sp)
8000acce:	43d4                	lw	a3,4(a5)
8000acd0:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
8000acd4:	87ba                	mv	a5,a4
8000acd6:	0786                	sll	a5,a5,0x1
8000acd8:	97ba                	add	a5,a5,a4
8000acda:	078a                	sll	a5,a5,0x2
8000acdc:	53c00713          	li	a4,1340
8000ace0:	02e58733          	mul	a4,a1,a4
8000ace4:	97ba                	add	a5,a5,a4
8000ace6:	97b2                	add	a5,a5,a2
8000ace8:	48d7a023          	sw	a3,1152(a5)
}
8000acec:	a085                	j	8000ad4c <.L246>

8000acee <.L244>:
        g_usbd_core[busid].rx_msg[ep->ep_addr & 0x7f].ep = ep->ep_addr;
8000acee:	00f14583          	lbu	a1,15(sp)
8000acf2:	47a2                	lw	a5,8(sp)
8000acf4:	0007c783          	lbu	a5,0(a5)
8000acf8:	07f7f713          	and	a4,a5,127
8000acfc:	47a2                	lw	a5,8(sp)
8000acfe:	0007c683          	lbu	a3,0(a5)
8000ad02:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
8000ad06:	87ba                	mv	a5,a4
8000ad08:	0786                	sll	a5,a5,0x1
8000ad0a:	97ba                	add	a5,a5,a4
8000ad0c:	078a                	sll	a5,a5,0x2
8000ad0e:	53c00713          	li	a4,1340
8000ad12:	02e58733          	mul	a4,a1,a4
8000ad16:	97ba                	add	a5,a5,a4
8000ad18:	97b2                	add	a5,a5,a2
8000ad1a:	4cd78c23          	sb	a3,1240(a5)
        g_usbd_core[busid].rx_msg[ep->ep_addr & 0x7f].cb = ep->ep_cb;
8000ad1e:	00f14583          	lbu	a1,15(sp)
8000ad22:	47a2                	lw	a5,8(sp)
8000ad24:	0007c783          	lbu	a5,0(a5)
8000ad28:	07f7f713          	and	a4,a5,127
8000ad2c:	47a2                	lw	a5,8(sp)
8000ad2e:	43d4                	lw	a3,4(a5)
8000ad30:	80018613          	add	a2,gp,-2048 # 1104c10 <g_usbd_core>
8000ad34:	87ba                	mv	a5,a4
8000ad36:	0786                	sll	a5,a5,0x1
8000ad38:	97ba                	add	a5,a5,a4
8000ad3a:	078a                	sll	a5,a5,0x2
8000ad3c:	53c00713          	li	a4,1340
8000ad40:	02e58733          	mul	a4,a1,a4
8000ad44:	97ba                	add	a5,a5,a4
8000ad46:	97b2                	add	a5,a5,a2
8000ad48:	4ed7a023          	sw	a3,1248(a5)

8000ad4c <.L246>:
}
8000ad4c:	0001                	nop
8000ad4e:	0141                	add	sp,sp,16
8000ad50:	8082                	ret

Disassembly of section .text.usbd_initialize:

8000ad52 <usbd_initialize>:
{
8000ad52:	7179                	add	sp,sp,-48
8000ad54:	d606                	sw	ra,44(sp)
8000ad56:	87aa                	mv	a5,a0
8000ad58:	c42e                	sw	a1,8(sp)
8000ad5a:	c232                	sw	a2,4(sp)
8000ad5c:	00f107a3          	sb	a5,15(sp)
    if (busid >= CONFIG_USBDEV_MAX_BUS) {
8000ad60:	00f14703          	lbu	a4,15(sp)
8000ad64:	4785                	li	a5,1
8000ad66:	00e7ff63          	bgeu	a5,a4,8000ad84 <.L264>
        USB_LOG_ERR("bus overflow\r\n");
8000ad6a:	800057b7          	lui	a5,0x80005
8000ad6e:	00c78513          	add	a0,a5,12 # 8000500c <.LC2>
8000ad72:	f6bfd0ef          	jal	80008cdc <printf>
8000ad76:	800057b7          	lui	a5,0x80005
8000ad7a:	17c78513          	add	a0,a5,380 # 8000517c <.LC15>
8000ad7e:	f5ffd0ef          	jal	80008cdc <printf>

8000ad82 <.L265>:
        while (1) {
8000ad82:	a001                	j	8000ad82 <.L265>

8000ad84 <.L264>:
    bus = &g_usbdev_bus[busid];
8000ad84:	00f14783          	lbu	a5,15(sp)
8000ad88:	00379713          	sll	a4,a5,0x3
8000ad8c:	bc420793          	add	a5,tp,-1084 # fffffbc4 <__APB_SRAM_segment_end__+0xbf0dbc4>
8000ad90:	97ba                	add	a5,a5,a4
8000ad92:	ce3e                	sw	a5,28(sp)
    bus->reg_base = reg_base;
8000ad94:	47f2                	lw	a5,28(sp)
8000ad96:	4722                	lw	a4,8(sp)
8000ad98:	c3d8                	sw	a4,4(a5)
    g_usbd_core[busid].event_handler = event_handler;
8000ad9a:	00f14683          	lbu	a3,15(sp)
8000ad9e:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000ada2:	53c00793          	li	a5,1340
8000ada6:	02f687b3          	mul	a5,a3,a5
8000adaa:	97ba                	add	a5,a5,a4
8000adac:	4712                	lw	a4,4(sp)
8000adae:	52e7ac23          	sw	a4,1336(a5)
    ret = usb_dc_init(busid);
8000adb2:	00f14783          	lbu	a5,15(sp)
8000adb6:	853e                	mv	a0,a5
8000adb8:	c00fc0ef          	jal	800071b8 <usb_dc_init>
8000adbc:	cc2a                	sw	a0,24(sp)
    usbd_class_event_notify_handler(busid, USBD_EVENT_INIT, NULL);
8000adbe:	00f14783          	lbu	a5,15(sp)
8000adc2:	4601                	li	a2,0
8000adc4:	45ad                	li	a1,11
8000adc6:	853e                	mv	a0,a5
8000adc8:	3485                	jal	8000a828 <usbd_class_event_notify_handler>
    g_usbd_core[busid].event_handler(busid, USBD_EVENT_INIT);
8000adca:	00f14683          	lbu	a3,15(sp)
8000adce:	80018713          	add	a4,gp,-2048 # 1104c10 <g_usbd_core>
8000add2:	53c00793          	li	a5,1340
8000add6:	02f687b3          	mul	a5,a3,a5
8000adda:	97ba                	add	a5,a5,a4
8000addc:	5387a783          	lw	a5,1336(a5)
8000ade0:	00f14703          	lbu	a4,15(sp)
8000ade4:	45ad                	li	a1,11
8000ade6:	853a                	mv	a0,a4
8000ade8:	9782                	jalr	a5
    return ret;
8000adea:	47e2                	lw	a5,24(sp)
}
8000adec:	853e                	mv	a0,a5
8000adee:	50b2                	lw	ra,44(sp)
8000adf0:	6145                	add	sp,sp,48
8000adf2:	8082                	ret

Disassembly of section .text.usb_get_port_speed:

8000adf4 <usb_get_port_speed>:
{
8000adf4:	1141                	add	sp,sp,-16
8000adf6:	c62a                	sw	a0,12(sp)
    return USB_PORTSC1_PSPD_GET(ptr->PORTSC1);
8000adf8:	47b2                	lw	a5,12(sp)
8000adfa:	1847a783          	lw	a5,388(a5)
8000adfe:	83e9                	srl	a5,a5,0x1a
8000ae00:	0ff7f793          	zext.b	a5,a5
8000ae04:	8b8d                	and	a5,a5,3
8000ae06:	0ff7f793          	zext.b	a5,a5
}
8000ae0a:	853e                	mv	a0,a5
8000ae0c:	0141                	add	sp,sp,16
8000ae0e:	8082                	ret

Disassembly of section .text.usb_dcd_set_address:

8000ae10 <usb_dcd_set_address>:
{
8000ae10:	1141                	add	sp,sp,-16
8000ae12:	c62a                	sw	a0,12(sp)
8000ae14:	87ae                	mv	a5,a1
8000ae16:	00f105a3          	sb	a5,11(sp)
    ptr->DEVICEADDR = USB_DEVICEADDR_USBADR_SET(dev_addr) | USB_DEVICEADDR_USBADRA_MASK;
8000ae1a:	00b14783          	lbu	a5,11(sp)
8000ae1e:	01979713          	sll	a4,a5,0x19
8000ae22:	010007b7          	lui	a5,0x1000
8000ae26:	8f5d                	or	a4,a4,a5
8000ae28:	47b2                	lw	a5,12(sp)
8000ae2a:	14e7aa23          	sw	a4,340(a5) # 1000154 <_flash_size+0x154>
}
8000ae2e:	0001                	nop
8000ae30:	0141                	add	sp,sp,16
8000ae32:	8082                	ret

Disassembly of section .text.usb_dc_deinit:

8000ae34 <usb_dc_deinit>:
{
8000ae34:	7139                	add	sp,sp,-64
8000ae36:	de06                	sw	ra,60(sp)
8000ae38:	87aa                	mv	a5,a0
8000ae3a:	00f107a3          	sb	a5,15(sp)
    intc_m_disable_irq(_dcd_irqnum[busid]);
8000ae3e:	00f14783          	lbu	a5,15(sp)
8000ae42:	bd420713          	add	a4,tp,-1068 # fffffbd4 <__APB_SRAM_segment_end__+0xbf0dbd4>
8000ae46:	078a                	sll	a5,a5,0x2
8000ae48:	97ba                	add	a5,a5,a4
8000ae4a:	439c                	lw	a5,0(a5)
8000ae4c:	d602                	sw	zero,44(sp)
8000ae4e:	d43e                	sw	a5,40(sp)
8000ae50:	e40007b7          	lui	a5,0xe4000
8000ae54:	d23e                	sw	a5,36(sp)
8000ae56:	57b2                	lw	a5,44(sp)
8000ae58:	d03e                	sw	a5,32(sp)
8000ae5a:	57a2                	lw	a5,40(sp)
8000ae5c:	ce3e                	sw	a5,28(sp)

8000ae5e <.LBB18>:
                                                         uint32_t target,
                                                         uint32_t irq)
{
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_ENABLE_OFFSET +
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
8000ae5e:	5782                	lw	a5,32(sp)
8000ae60:	00779713          	sll	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
8000ae64:	5792                	lw	a5,36(sp)
8000ae66:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
8000ae68:	47f2                	lw	a5,28(sp)
8000ae6a:	8395                	srl	a5,a5,0x5
8000ae6c:	078a                	sll	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
8000ae6e:	973e                	add	a4,a4,a5
8000ae70:	6789                	lui	a5,0x2
8000ae72:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
8000ae74:	cc3e                	sw	a5,24(sp)
    uint32_t current = *current_ptr;
8000ae76:	47e2                	lw	a5,24(sp)
8000ae78:	439c                	lw	a5,0(a5)
8000ae7a:	ca3e                	sw	a5,20(sp)
    current = current & ~((1 << (irq & 0x1F)));
8000ae7c:	47f2                	lw	a5,28(sp)
8000ae7e:	8bfd                	and	a5,a5,31
8000ae80:	4705                	li	a4,1
8000ae82:	00f717b3          	sll	a5,a4,a5
8000ae86:	fff7c793          	not	a5,a5
8000ae8a:	873e                	mv	a4,a5
8000ae8c:	47d2                	lw	a5,20(sp)
8000ae8e:	8ff9                	and	a5,a5,a4
8000ae90:	ca3e                	sw	a5,20(sp)
    *current_ptr = current;
8000ae92:	47e2                	lw	a5,24(sp)
8000ae94:	4752                	lw	a4,20(sp)
8000ae96:	c398                	sw	a4,0(a5)
}
8000ae98:	0001                	nop

8000ae9a <.LBE20>:
 * @param[in] irq Interrupt number
 */
ATTR_ALWAYS_INLINE static inline void intc_disable_irq(uint32_t target, uint32_t irq)
{
    __plic_disable_irq(HPM_PLIC_BASE, target, irq);
}
8000ae9a:	0001                	nop

8000ae9c <.LBE18>:
    usb_device_deinit(g_hpm_udc[busid].handle);
8000ae9c:	00f14683          	lbu	a3,15(sp)
8000aea0:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000aea4:	14800793          	li	a5,328
8000aea8:	02f687b3          	mul	a5,a3,a5
8000aeac:	97ba                	add	a5,a5,a4
8000aeae:	439c                	lw	a5,0(a5)
8000aeb0:	853e                	mv	a0,a5
8000aeb2:	968fe0ef          	jal	8000901a <usb_device_deinit>
    return 0;
8000aeb6:	4781                	li	a5,0
}
8000aeb8:	853e                	mv	a0,a5
8000aeba:	50f2                	lw	ra,60(sp)
8000aebc:	6121                	add	sp,sp,64
8000aebe:	8082                	ret

Disassembly of section .text.usbd_get_port_speed:

8000aec0 <usbd_get_port_speed>:
{
8000aec0:	7179                	add	sp,sp,-48
8000aec2:	d606                	sw	ra,44(sp)
8000aec4:	87aa                	mv	a5,a0
8000aec6:	00f107a3          	sb	a5,15(sp)
    speed = usb_get_port_speed(g_hpm_udc[busid].handle->regs);
8000aeca:	00f14683          	lbu	a3,15(sp)
8000aece:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000aed2:	14800793          	li	a5,328
8000aed6:	02f687b3          	mul	a5,a3,a5
8000aeda:	97ba                	add	a5,a5,a4
8000aedc:	439c                	lw	a5,0(a5)
8000aede:	439c                	lw	a5,0(a5)
8000aee0:	853e                	mv	a0,a5
8000aee2:	3f09                	jal	8000adf4 <usb_get_port_speed>
8000aee4:	87aa                	mv	a5,a0
8000aee6:	00f10fa3          	sb	a5,31(sp)
    if (speed == 0x00) {
8000aeea:	01f14783          	lbu	a5,31(sp)
8000aeee:	e399                	bnez	a5,8000aef4 <.L26>
        return USB_SPEED_FULL;
8000aef0:	4789                	li	a5,2
8000aef2:	a005                	j	8000af12 <.L27>

8000aef4 <.L26>:
    if (speed == 0x01) {
8000aef4:	01f14703          	lbu	a4,31(sp)
8000aef8:	4785                	li	a5,1
8000aefa:	00f71463          	bne	a4,a5,8000af02 <.L28>
        return USB_SPEED_LOW;
8000aefe:	4785                	li	a5,1
8000af00:	a809                	j	8000af12 <.L27>

8000af02 <.L28>:
    if (speed == 0x02) {
8000af02:	01f14703          	lbu	a4,31(sp)
8000af06:	4789                	li	a5,2
8000af08:	00f71463          	bne	a4,a5,8000af10 <.L29>
        return USB_SPEED_HIGH;
8000af0c:	478d                	li	a5,3
8000af0e:	a011                	j	8000af12 <.L27>

8000af10 <.L29>:
    return 0;
8000af10:	4781                	li	a5,0

8000af12 <.L27>:
}
8000af12:	853e                	mv	a0,a5
8000af14:	50b2                	lw	ra,44(sp)
8000af16:	6145                	add	sp,sp,48
8000af18:	8082                	ret

Disassembly of section .text.usbd_ep_open:

8000af1a <usbd_ep_open>:
{
8000af1a:	7179                	add	sp,sp,-48
8000af1c:	d606                	sw	ra,44(sp)
8000af1e:	87aa                	mv	a5,a0
8000af20:	c42e                	sw	a1,8(sp)
8000af22:	00f107a3          	sb	a5,15(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000af26:	00f14683          	lbu	a3,15(sp)
8000af2a:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000af2e:	14800793          	li	a5,328
8000af32:	02f687b3          	mul	a5,a3,a5
8000af36:	97ba                	add	a5,a5,a4
8000af38:	439c                	lw	a5,0(a5)
8000af3a:	ce3e                	sw	a5,28(sp)
    uint8_t ep_idx = USB_EP_GET_IDX(ep->bEndpointAddress);
8000af3c:	47a2                	lw	a5,8(sp)
8000af3e:	0027c783          	lbu	a5,2(a5) # 2002 <__APB_SRAM_segment_size__+0x2>
8000af42:	07f7f793          	and	a5,a5,127
8000af46:	00f10da3          	sb	a5,27(sp)
    tmp_ep_cfg.xfer = USB_GET_ENDPOINT_TYPE(ep->bmAttributes);
8000af4a:	47a2                	lw	a5,8(sp)
8000af4c:	0037c783          	lbu	a5,3(a5)
8000af50:	8b8d                	and	a5,a5,3
8000af52:	0ff7f793          	zext.b	a5,a5
8000af56:	00f10a23          	sb	a5,20(sp)
    tmp_ep_cfg.ep_addr = ep->bEndpointAddress;
8000af5a:	47a2                	lw	a5,8(sp)
8000af5c:	0027c783          	lbu	a5,2(a5)
8000af60:	00f10aa3          	sb	a5,21(sp)
    tmp_ep_cfg.max_packet_size = ep->wMaxPacketSize;
8000af64:	47a2                	lw	a5,8(sp)
8000af66:	0047c703          	lbu	a4,4(a5)
8000af6a:	0057c783          	lbu	a5,5(a5)
8000af6e:	07a2                	sll	a5,a5,0x8
8000af70:	8fd9                	or	a5,a5,a4
8000af72:	07c2                	sll	a5,a5,0x10
8000af74:	83c1                	srl	a5,a5,0x10
8000af76:	00f11b23          	sh	a5,22(sp)
    usb_device_edpt_open(handle, &tmp_ep_cfg);
8000af7a:	085c                	add	a5,sp,20
8000af7c:	85be                	mv	a1,a5
8000af7e:	4572                	lw	a0,28(sp)
8000af80:	f52f90ef          	jal	800046d2 <usb_device_edpt_open>
    if (USB_EP_DIR_IS_OUT(ep->bEndpointAddress)) {
8000af84:	47a2                	lw	a5,8(sp)
8000af86:	0027c783          	lbu	a5,2(a5)
8000af8a:	07e2                	sll	a5,a5,0x18
8000af8c:	87e1                	sra	a5,a5,0x18
8000af8e:	0807ce63          	bltz	a5,8000b02a <.L31>
        g_hpm_udc[busid].out_ep[ep_idx].ep_mps = USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize);
8000af92:	47a2                	lw	a5,8(sp)
8000af94:	0047c703          	lbu	a4,4(a5)
8000af98:	0057c783          	lbu	a5,5(a5)
8000af9c:	07a2                	sll	a5,a5,0x8
8000af9e:	8fd9                	or	a5,a5,a4
8000afa0:	07c2                	sll	a5,a5,0x10
8000afa2:	83c1                	srl	a5,a5,0x10
8000afa4:	00f14583          	lbu	a1,15(sp)
8000afa8:	01b14703          	lbu	a4,27(sp)
8000afac:	7ff7f793          	and	a5,a5,2047
8000afb0:	01079693          	sll	a3,a5,0x10
8000afb4:	82c1                	srl	a3,a3,0x10
8000afb6:	80020613          	add	a2,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000afba:	87ba                	mv	a5,a4
8000afbc:	078a                	sll	a5,a5,0x2
8000afbe:	97ba                	add	a5,a5,a4
8000afc0:	078a                	sll	a5,a5,0x2
8000afc2:	14800713          	li	a4,328
8000afc6:	02e58733          	mul	a4,a1,a4
8000afca:	97ba                	add	a5,a5,a4
8000afcc:	97b2                	add	a5,a5,a2
8000afce:	0ad79423          	sh	a3,168(a5)
        g_hpm_udc[busid].out_ep[ep_idx].ep_type = USB_GET_ENDPOINT_TYPE(ep->bmAttributes);
8000afd2:	47a2                	lw	a5,8(sp)
8000afd4:	0037c783          	lbu	a5,3(a5)
8000afd8:	00f14583          	lbu	a1,15(sp)
8000afdc:	01b14703          	lbu	a4,27(sp)
8000afe0:	8b8d                	and	a5,a5,3
8000afe2:	0ff7f693          	zext.b	a3,a5
8000afe6:	80020613          	add	a2,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000afea:	87ba                	mv	a5,a4
8000afec:	078a                	sll	a5,a5,0x2
8000afee:	97ba                	add	a5,a5,a4
8000aff0:	078a                	sll	a5,a5,0x2
8000aff2:	14800713          	li	a4,328
8000aff6:	02e58733          	mul	a4,a1,a4
8000affa:	97ba                	add	a5,a5,a4
8000affc:	97b2                	add	a5,a5,a2
8000affe:	0ad78523          	sb	a3,170(a5)
        g_hpm_udc[busid].out_ep[ep_idx].ep_enable = true;
8000b002:	00f14603          	lbu	a2,15(sp)
8000b006:	01b14703          	lbu	a4,27(sp)
8000b00a:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b00e:	87ba                	mv	a5,a4
8000b010:	078a                	sll	a5,a5,0x2
8000b012:	97ba                	add	a5,a5,a4
8000b014:	078a                	sll	a5,a5,0x2
8000b016:	14800713          	li	a4,328
8000b01a:	02e60733          	mul	a4,a2,a4
8000b01e:	97ba                	add	a5,a5,a4
8000b020:	97b6                	add	a5,a5,a3
8000b022:	4705                	li	a4,1
8000b024:	0ae78623          	sb	a4,172(a5)
8000b028:	a861                	j	8000b0c0 <.L32>

8000b02a <.L31>:
        g_hpm_udc[busid].in_ep[ep_idx].ep_mps = USB_GET_MAXPACKETSIZE(ep->wMaxPacketSize);
8000b02a:	47a2                	lw	a5,8(sp)
8000b02c:	0047c703          	lbu	a4,4(a5)
8000b030:	0057c783          	lbu	a5,5(a5)
8000b034:	07a2                	sll	a5,a5,0x8
8000b036:	8fd9                	or	a5,a5,a4
8000b038:	07c2                	sll	a5,a5,0x10
8000b03a:	83c1                	srl	a5,a5,0x10
8000b03c:	00f14583          	lbu	a1,15(sp)
8000b040:	01b14703          	lbu	a4,27(sp)
8000b044:	7ff7f793          	and	a5,a5,2047
8000b048:	01079693          	sll	a3,a5,0x10
8000b04c:	82c1                	srl	a3,a3,0x10
8000b04e:	80020613          	add	a2,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b052:	87ba                	mv	a5,a4
8000b054:	078a                	sll	a5,a5,0x2
8000b056:	97ba                	add	a5,a5,a4
8000b058:	078a                	sll	a5,a5,0x2
8000b05a:	14800713          	li	a4,328
8000b05e:	02e58733          	mul	a4,a1,a4
8000b062:	97ba                	add	a5,a5,a4
8000b064:	97b2                	add	a5,a5,a2
8000b066:	00d79423          	sh	a3,8(a5)
        g_hpm_udc[busid].in_ep[ep_idx].ep_type = USB_GET_ENDPOINT_TYPE(ep->bmAttributes);
8000b06a:	47a2                	lw	a5,8(sp)
8000b06c:	0037c783          	lbu	a5,3(a5)
8000b070:	00f14583          	lbu	a1,15(sp)
8000b074:	01b14703          	lbu	a4,27(sp)
8000b078:	8b8d                	and	a5,a5,3
8000b07a:	0ff7f693          	zext.b	a3,a5
8000b07e:	80020613          	add	a2,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b082:	87ba                	mv	a5,a4
8000b084:	078a                	sll	a5,a5,0x2
8000b086:	97ba                	add	a5,a5,a4
8000b088:	078a                	sll	a5,a5,0x2
8000b08a:	14800713          	li	a4,328
8000b08e:	02e58733          	mul	a4,a1,a4
8000b092:	97ba                	add	a5,a5,a4
8000b094:	97b2                	add	a5,a5,a2
8000b096:	00d78523          	sb	a3,10(a5)
        g_hpm_udc[busid].in_ep[ep_idx].ep_enable = true;
8000b09a:	00f14603          	lbu	a2,15(sp)
8000b09e:	01b14703          	lbu	a4,27(sp)
8000b0a2:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b0a6:	87ba                	mv	a5,a4
8000b0a8:	078a                	sll	a5,a5,0x2
8000b0aa:	97ba                	add	a5,a5,a4
8000b0ac:	078a                	sll	a5,a5,0x2
8000b0ae:	14800713          	li	a4,328
8000b0b2:	02e60733          	mul	a4,a2,a4
8000b0b6:	97ba                	add	a5,a5,a4
8000b0b8:	97b6                	add	a5,a5,a3
8000b0ba:	4705                	li	a4,1
8000b0bc:	00e78623          	sb	a4,12(a5)

8000b0c0 <.L32>:
    return 0;
8000b0c0:	4781                	li	a5,0
}
8000b0c2:	853e                	mv	a0,a5
8000b0c4:	50b2                	lw	ra,44(sp)
8000b0c6:	6145                	add	sp,sp,48
8000b0c8:	8082                	ret

Disassembly of section .text.usbd_ep_close:

8000b0ca <usbd_ep_close>:
{
8000b0ca:	7179                	add	sp,sp,-48
8000b0cc:	d606                	sw	ra,44(sp)
8000b0ce:	87aa                	mv	a5,a0
8000b0d0:	872e                	mv	a4,a1
8000b0d2:	00f107a3          	sb	a5,15(sp)
8000b0d6:	87ba                	mv	a5,a4
8000b0d8:	00f10723          	sb	a5,14(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000b0dc:	00f14683          	lbu	a3,15(sp)
8000b0e0:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b0e4:	14800793          	li	a5,328
8000b0e8:	02f687b3          	mul	a5,a3,a5
8000b0ec:	97ba                	add	a5,a5,a4
8000b0ee:	439c                	lw	a5,0(a5)
8000b0f0:	ce3e                	sw	a5,28(sp)
    uint8_t ep_idx = USB_EP_GET_IDX(ep);
8000b0f2:	00e14783          	lbu	a5,14(sp)
8000b0f6:	07f7f793          	and	a5,a5,127
8000b0fa:	00f10da3          	sb	a5,27(sp)
    if (USB_EP_DIR_IS_OUT(ep)) {
8000b0fe:	00e10783          	lb	a5,14(sp)
8000b102:	0207c563          	bltz	a5,8000b12c <.L35>
        g_hpm_udc[busid].out_ep[ep_idx].ep_enable = false;
8000b106:	00f14603          	lbu	a2,15(sp)
8000b10a:	01b14703          	lbu	a4,27(sp)
8000b10e:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b112:	87ba                	mv	a5,a4
8000b114:	078a                	sll	a5,a5,0x2
8000b116:	97ba                	add	a5,a5,a4
8000b118:	078a                	sll	a5,a5,0x2
8000b11a:	14800713          	li	a4,328
8000b11e:	02e60733          	mul	a4,a2,a4
8000b122:	97ba                	add	a5,a5,a4
8000b124:	97b6                	add	a5,a5,a3
8000b126:	0a078623          	sb	zero,172(a5)
8000b12a:	a01d                	j	8000b150 <.L36>

8000b12c <.L35>:
        g_hpm_udc[busid].in_ep[ep_idx].ep_enable = false;
8000b12c:	00f14603          	lbu	a2,15(sp)
8000b130:	01b14703          	lbu	a4,27(sp)
8000b134:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b138:	87ba                	mv	a5,a4
8000b13a:	078a                	sll	a5,a5,0x2
8000b13c:	97ba                	add	a5,a5,a4
8000b13e:	078a                	sll	a5,a5,0x2
8000b140:	14800713          	li	a4,328
8000b144:	02e60733          	mul	a4,a2,a4
8000b148:	97ba                	add	a5,a5,a4
8000b14a:	97b6                	add	a5,a5,a3
8000b14c:	00078623          	sb	zero,12(a5)

8000b150 <.L36>:
    usb_device_edpt_close(handle, ep);
8000b150:	00e14783          	lbu	a5,14(sp)
8000b154:	85be                	mv	a1,a5
8000b156:	4572                	lw	a0,28(sp)
8000b158:	fc1fd0ef          	jal	80009118 <usb_device_edpt_close>
    return 0;
8000b15c:	4781                	li	a5,0
}
8000b15e:	853e                	mv	a0,a5
8000b160:	50b2                	lw	ra,44(sp)
8000b162:	6145                	add	sp,sp,48
8000b164:	8082                	ret

Disassembly of section .text.usbd_ep_start_write:

8000b166 <usbd_ep_start_write>:

int usbd_ep_start_write(uint8_t busid, const uint8_t ep, const uint8_t *data, uint32_t data_len)
{
8000b166:	7179                	add	sp,sp,-48
8000b168:	d606                	sw	ra,44(sp)
8000b16a:	87aa                	mv	a5,a0
8000b16c:	872e                	mv	a4,a1
8000b16e:	c432                	sw	a2,8(sp)
8000b170:	c236                	sw	a3,4(sp)
8000b172:	00f107a3          	sb	a5,15(sp)
8000b176:	87ba                	mv	a5,a4
8000b178:	00f10723          	sb	a5,14(sp)
    uint8_t ep_idx = USB_EP_GET_IDX(ep);
8000b17c:	00e14783          	lbu	a5,14(sp)
8000b180:	07f7f793          	and	a5,a5,127
8000b184:	00f10fa3          	sb	a5,31(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000b188:	00f14683          	lbu	a3,15(sp)
8000b18c:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b190:	14800793          	li	a5,328
8000b194:	02f687b3          	mul	a5,a3,a5
8000b198:	97ba                	add	a5,a5,a4
8000b19a:	439c                	lw	a5,0(a5)
8000b19c:	cc3e                	sw	a5,24(sp)

    if (!data && data_len) {
8000b19e:	47a2                	lw	a5,8(sp)
8000b1a0:	e789                	bnez	a5,8000b1aa <.L45>
8000b1a2:	4792                	lw	a5,4(sp)
8000b1a4:	c399                	beqz	a5,8000b1aa <.L45>
        return -1;
8000b1a6:	57fd                	li	a5,-1
8000b1a8:	a06d                	j	8000b252 <.L46>

8000b1aa <.L45>:
    }
    if (!g_hpm_udc[busid].in_ep[ep_idx].ep_enable) {
8000b1aa:	00f14603          	lbu	a2,15(sp)
8000b1ae:	01f14703          	lbu	a4,31(sp)
8000b1b2:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b1b6:	87ba                	mv	a5,a4
8000b1b8:	078a                	sll	a5,a5,0x2
8000b1ba:	97ba                	add	a5,a5,a4
8000b1bc:	078a                	sll	a5,a5,0x2
8000b1be:	14800713          	li	a4,328
8000b1c2:	02e60733          	mul	a4,a2,a4
8000b1c6:	97ba                	add	a5,a5,a4
8000b1c8:	97b6                	add	a5,a5,a3
8000b1ca:	00c7c783          	lbu	a5,12(a5)
8000b1ce:	e399                	bnez	a5,8000b1d4 <.L47>
        return -2;
8000b1d0:	57f9                	li	a5,-2
8000b1d2:	a041                	j	8000b252 <.L46>

8000b1d4 <.L47>:
    }

    g_hpm_udc[busid].in_ep[ep_idx].xfer_buf = (uint8_t *)data;
8000b1d4:	00f14603          	lbu	a2,15(sp)
8000b1d8:	01f14703          	lbu	a4,31(sp)
8000b1dc:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b1e0:	87ba                	mv	a5,a4
8000b1e2:	078a                	sll	a5,a5,0x2
8000b1e4:	97ba                	add	a5,a5,a4
8000b1e6:	078a                	sll	a5,a5,0x2
8000b1e8:	14800713          	li	a4,328
8000b1ec:	02e60733          	mul	a4,a2,a4
8000b1f0:	97ba                	add	a5,a5,a4
8000b1f2:	97b6                	add	a5,a5,a3
8000b1f4:	4722                	lw	a4,8(sp)
8000b1f6:	cb98                	sw	a4,16(a5)
    g_hpm_udc[busid].in_ep[ep_idx].xfer_len = data_len;
8000b1f8:	00f14603          	lbu	a2,15(sp)
8000b1fc:	01f14703          	lbu	a4,31(sp)
8000b200:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b204:	87ba                	mv	a5,a4
8000b206:	078a                	sll	a5,a5,0x2
8000b208:	97ba                	add	a5,a5,a4
8000b20a:	078a                	sll	a5,a5,0x2
8000b20c:	14800713          	li	a4,328
8000b210:	02e60733          	mul	a4,a2,a4
8000b214:	97ba                	add	a5,a5,a4
8000b216:	97b6                	add	a5,a5,a3
8000b218:	4712                	lw	a4,4(sp)
8000b21a:	cbd8                	sw	a4,20(a5)
    g_hpm_udc[busid].in_ep[ep_idx].actual_xfer_len = 0;
8000b21c:	00f14603          	lbu	a2,15(sp)
8000b220:	01f14703          	lbu	a4,31(sp)
8000b224:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b228:	87ba                	mv	a5,a4
8000b22a:	078a                	sll	a5,a5,0x2
8000b22c:	97ba                	add	a5,a5,a4
8000b22e:	078a                	sll	a5,a5,0x2
8000b230:	14800713          	li	a4,328
8000b234:	02e60733          	mul	a4,a2,a4
8000b238:	97ba                	add	a5,a5,a4
8000b23a:	97b6                	add	a5,a5,a3
8000b23c:	0007ac23          	sw	zero,24(a5)

    usb_device_edpt_xfer(handle, ep, (uint8_t *)data, data_len);
8000b240:	00e14783          	lbu	a5,14(sp)
8000b244:	4692                	lw	a3,4(sp)
8000b246:	4622                	lw	a2,8(sp)
8000b248:	85be                	mv	a1,a5
8000b24a:	4562                	lw	a0,24(sp)
8000b24c:	d9af90ef          	jal	800047e6 <usb_device_edpt_xfer>

    return 0;
8000b250:	4781                	li	a5,0

8000b252 <.L46>:
}
8000b252:	853e                	mv	a0,a5
8000b254:	50b2                	lw	ra,44(sp)
8000b256:	6145                	add	sp,sp,48
8000b258:	8082                	ret

Disassembly of section .text.usbd_ep_start_read:

8000b25a <usbd_ep_start_read>:

int usbd_ep_start_read(uint8_t busid, const uint8_t ep, uint8_t *data, uint32_t data_len)
{
8000b25a:	7179                	add	sp,sp,-48
8000b25c:	d606                	sw	ra,44(sp)
8000b25e:	87aa                	mv	a5,a0
8000b260:	872e                	mv	a4,a1
8000b262:	c432                	sw	a2,8(sp)
8000b264:	c236                	sw	a3,4(sp)
8000b266:	00f107a3          	sb	a5,15(sp)
8000b26a:	87ba                	mv	a5,a4
8000b26c:	00f10723          	sb	a5,14(sp)
    uint8_t ep_idx = USB_EP_GET_IDX(ep);
8000b270:	00e14783          	lbu	a5,14(sp)
8000b274:	07f7f793          	and	a5,a5,127
8000b278:	00f10fa3          	sb	a5,31(sp)
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000b27c:	00f14683          	lbu	a3,15(sp)
8000b280:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b284:	14800793          	li	a5,328
8000b288:	02f687b3          	mul	a5,a3,a5
8000b28c:	97ba                	add	a5,a5,a4
8000b28e:	439c                	lw	a5,0(a5)
8000b290:	cc3e                	sw	a5,24(sp)

    if (!data && data_len) {
8000b292:	47a2                	lw	a5,8(sp)
8000b294:	e789                	bnez	a5,8000b29e <.L49>
8000b296:	4792                	lw	a5,4(sp)
8000b298:	c399                	beqz	a5,8000b29e <.L49>
        return -1;
8000b29a:	57fd                	li	a5,-1
8000b29c:	a07d                	j	8000b34a <.L50>

8000b29e <.L49>:
    }
    if (!g_hpm_udc[busid].out_ep[ep_idx].ep_enable) {
8000b29e:	00f14603          	lbu	a2,15(sp)
8000b2a2:	01f14703          	lbu	a4,31(sp)
8000b2a6:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b2aa:	87ba                	mv	a5,a4
8000b2ac:	078a                	sll	a5,a5,0x2
8000b2ae:	97ba                	add	a5,a5,a4
8000b2b0:	078a                	sll	a5,a5,0x2
8000b2b2:	14800713          	li	a4,328
8000b2b6:	02e60733          	mul	a4,a2,a4
8000b2ba:	97ba                	add	a5,a5,a4
8000b2bc:	97b6                	add	a5,a5,a3
8000b2be:	0ac7c783          	lbu	a5,172(a5)
8000b2c2:	e399                	bnez	a5,8000b2c8 <.L51>
        return -2;
8000b2c4:	57f9                	li	a5,-2
8000b2c6:	a051                	j	8000b34a <.L50>

8000b2c8 <.L51>:
    }

    g_hpm_udc[busid].out_ep[ep_idx].xfer_buf = (uint8_t *)data;
8000b2c8:	00f14603          	lbu	a2,15(sp)
8000b2cc:	01f14703          	lbu	a4,31(sp)
8000b2d0:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b2d4:	87ba                	mv	a5,a4
8000b2d6:	078a                	sll	a5,a5,0x2
8000b2d8:	97ba                	add	a5,a5,a4
8000b2da:	078a                	sll	a5,a5,0x2
8000b2dc:	14800713          	li	a4,328
8000b2e0:	02e60733          	mul	a4,a2,a4
8000b2e4:	97ba                	add	a5,a5,a4
8000b2e6:	97b6                	add	a5,a5,a3
8000b2e8:	4722                	lw	a4,8(sp)
8000b2ea:	0ae7a823          	sw	a4,176(a5)
    g_hpm_udc[busid].out_ep[ep_idx].xfer_len = data_len;
8000b2ee:	00f14603          	lbu	a2,15(sp)
8000b2f2:	01f14703          	lbu	a4,31(sp)
8000b2f6:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b2fa:	87ba                	mv	a5,a4
8000b2fc:	078a                	sll	a5,a5,0x2
8000b2fe:	97ba                	add	a5,a5,a4
8000b300:	078a                	sll	a5,a5,0x2
8000b302:	14800713          	li	a4,328
8000b306:	02e60733          	mul	a4,a2,a4
8000b30a:	97ba                	add	a5,a5,a4
8000b30c:	97b6                	add	a5,a5,a3
8000b30e:	4712                	lw	a4,4(sp)
8000b310:	0ae7aa23          	sw	a4,180(a5)
    g_hpm_udc[busid].out_ep[ep_idx].actual_xfer_len = 0;
8000b314:	00f14603          	lbu	a2,15(sp)
8000b318:	01f14703          	lbu	a4,31(sp)
8000b31c:	80020693          	add	a3,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b320:	87ba                	mv	a5,a4
8000b322:	078a                	sll	a5,a5,0x2
8000b324:	97ba                	add	a5,a5,a4
8000b326:	078a                	sll	a5,a5,0x2
8000b328:	14800713          	li	a4,328
8000b32c:	02e60733          	mul	a4,a2,a4
8000b330:	97ba                	add	a5,a5,a4
8000b332:	97b6                	add	a5,a5,a3
8000b334:	0a07ac23          	sw	zero,184(a5)

    usb_device_edpt_xfer(handle, ep, data, data_len);
8000b338:	00e14783          	lbu	a5,14(sp)
8000b33c:	4692                	lw	a3,4(sp)
8000b33e:	4622                	lw	a2,8(sp)
8000b340:	85be                	mv	a1,a5
8000b342:	4562                	lw	a0,24(sp)
8000b344:	ca2f90ef          	jal	800047e6 <usb_device_edpt_xfer>

    return 0;
8000b348:	4781                	li	a5,0

8000b34a <.L50>:
}
8000b34a:	853e                	mv	a0,a5
8000b34c:	50b2                	lw	ra,44(sp)
8000b34e:	6145                	add	sp,sp,48
8000b350:	8082                	ret

Disassembly of section .text.USBD_IRQHandler:

8000b352 <USBD_IRQHandler>:

void USBD_IRQHandler(uint8_t busid)
{
8000b352:	715d                	add	sp,sp,-80
8000b354:	c686                	sw	ra,76(sp)
8000b356:	87aa                	mv	a5,a0
8000b358:	00f107a3          	sb	a5,15(sp)
    uint32_t int_status;
    usb_device_handle_t *handle = g_hpm_udc[busid].handle;
8000b35c:	00f14683          	lbu	a3,15(sp)
8000b360:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b364:	14800793          	li	a5,328
8000b368:	02f687b3          	mul	a5,a3,a5
8000b36c:	97ba                	add	a5,a5,a4
8000b36e:	439c                	lw	a5,0(a5)
8000b370:	d83e                	sw	a5,48(sp)
    uint32_t transfer_len;
    bool ep_cb_req;

    /* Acknowledge handled interrupt */
    int_status = usb_device_status_flags(handle);
8000b372:	5542                	lw	a0,48(sp)
8000b374:	9faf90ef          	jal	8000456e <usb_device_status_flags>
8000b378:	d62a                	sw	a0,44(sp)
    int_status &= usb_device_interrupts(handle);
8000b37a:	5542                	lw	a0,48(sp)
8000b37c:	a0ef90ef          	jal	8000458a <usb_device_interrupts>
8000b380:	872a                	mv	a4,a0
8000b382:	57b2                	lw	a5,44(sp)
8000b384:	8ff9                	and	a5,a5,a4
8000b386:	d63e                	sw	a5,44(sp)
    usb_device_clear_status_flags(handle, int_status);
8000b388:	55b2                	lw	a1,44(sp)
8000b38a:	5542                	lw	a0,48(sp)
8000b38c:	cf7fd0ef          	jal	80009082 <usb_device_clear_status_flags>

    if (int_status & intr_error) {
8000b390:	57b2                	lw	a5,44(sp)
8000b392:	8b89                	and	a5,a5,2
8000b394:	cf89                	beqz	a5,8000b3ae <.L53>
        USB_LOG_ERR("usbd intr error!\r\n");
8000b396:	800057b7          	lui	a5,0x80005
8000b39a:	18c78513          	add	a0,a5,396 # 8000518c <.LC0>
8000b39e:	93ffd0ef          	jal	80008cdc <printf>
8000b3a2:	800057b7          	lui	a5,0x80005
8000b3a6:	19878513          	add	a0,a5,408 # 80005198 <.LC1>
8000b3aa:	933fd0ef          	jal	80008cdc <printf>

8000b3ae <.L53>:
    }

    if (int_status & intr_reset) {
8000b3ae:	57b2                	lw	a5,44(sp)
8000b3b0:	0407f793          	and	a5,a5,64
8000b3b4:	cba5                	beqz	a5,8000b424 <.L54>
        g_hpm_udc[busid].is_suspend = false;
8000b3b6:	00f14683          	lbu	a3,15(sp)
8000b3ba:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b3be:	14800793          	li	a5,328
8000b3c2:	02f687b3          	mul	a5,a3,a5
8000b3c6:	97ba                	add	a5,a5,a4
8000b3c8:	00078223          	sb	zero,4(a5)
        memset(g_hpm_udc[busid].in_ep, 0, sizeof(struct hpm_ep_state) * USB_NUM_BIDIR_ENDPOINTS);
8000b3cc:	00f14703          	lbu	a4,15(sp)
8000b3d0:	14800793          	li	a5,328
8000b3d4:	02f70733          	mul	a4,a4,a5
8000b3d8:	80020793          	add	a5,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b3dc:	97ba                	add	a5,a5,a4
8000b3de:	07a1                	add	a5,a5,8
8000b3e0:	0a000613          	li	a2,160
8000b3e4:	4581                	li	a1,0
8000b3e6:	853e                	mv	a0,a5
8000b3e8:	32a010ef          	jal	8000c712 <memset>
        memset(g_hpm_udc[busid].out_ep, 0, sizeof(struct hpm_ep_state) * USB_NUM_BIDIR_ENDPOINTS);
8000b3ec:	00f14703          	lbu	a4,15(sp)
8000b3f0:	14800793          	li	a5,328
8000b3f4:	02f707b3          	mul	a5,a4,a5
8000b3f8:	0a078713          	add	a4,a5,160
8000b3fc:	80020793          	add	a5,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b400:	97ba                	add	a5,a5,a4
8000b402:	07a1                	add	a5,a5,8
8000b404:	0a000613          	li	a2,160
8000b408:	4581                	li	a1,0
8000b40a:	853e                	mv	a0,a5
8000b40c:	306010ef          	jal	8000c712 <memset>
        usbd_event_reset_handler(busid);
8000b410:	00f14783          	lbu	a5,15(sp)
8000b414:	853e                	mv	a0,a5
8000b416:	f2cfb0ef          	jal	80006b42 <usbd_event_reset_handler>
        usb_device_bus_reset(handle, 64);
8000b41a:	04000593          	li	a1,64
8000b41e:	5542                	lw	a0,48(sp)
8000b420:	892f90ef          	jal	800044b2 <usb_device_bus_reset>

8000b424 <.L54>:
    }

    if (int_status & intr_suspend) {
8000b424:	57b2                	lw	a5,44(sp)
8000b426:	1007f793          	and	a5,a5,256
8000b42a:	cf85                	beqz	a5,8000b462 <.L55>
        if (usb_device_get_suspend_status(handle)) {
8000b42c:	5542                	lw	a0,48(sp)
8000b42e:	99cf90ef          	jal	800045ca <usb_device_get_suspend_status>
8000b432:	87aa                	mv	a5,a0
8000b434:	c79d                	beqz	a5,8000b462 <.L55>
            /* Note: Host may delay more than 3 ms before and/or after bus reset before doing enumeration. */
            if (usb_device_get_address(handle)) {
8000b436:	5542                	lw	a0,48(sp)
8000b438:	9cef90ef          	jal	80004606 <usb_device_get_address>
8000b43c:	87aa                	mv	a5,a0
8000b43e:	c395                	beqz	a5,8000b462 <.L55>
                g_hpm_udc[busid].is_suspend = true;
8000b440:	00f14683          	lbu	a3,15(sp)
8000b444:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b448:	14800793          	li	a5,328
8000b44c:	02f687b3          	mul	a5,a3,a5
8000b450:	97ba                	add	a5,a5,a4
8000b452:	4705                	li	a4,1
8000b454:	00e78223          	sb	a4,4(a5)
                usbd_event_suspend_handler(busid);
8000b458:	00f14783          	lbu	a5,15(sp)
8000b45c:	853e                	mv	a0,a5
8000b45e:	e82fb0ef          	jal	80006ae0 <usbd_event_suspend_handler>

8000b462 <.L55>:
            }
        } else {
        }
    }

    if (int_status & intr_port_change) {
8000b462:	57b2                	lw	a5,44(sp)
8000b464:	8b91                	and	a5,a5,4
8000b466:	c3ad                	beqz	a5,8000b4c8 <.L56>
        if (!usb_device_get_port_ccs(handle)) {
8000b468:	5542                	lw	a0,48(sp)
8000b46a:	9d4f90ef          	jal	8000463e <usb_device_get_port_ccs>
8000b46e:	87aa                	mv	a5,a0
8000b470:	0017c793          	xor	a5,a5,1
8000b474:	0ff7f793          	zext.b	a5,a5
8000b478:	c799                	beqz	a5,8000b486 <.L57>
            usbd_event_disconnect_handler(busid);
8000b47a:	00f14783          	lbu	a5,15(sp)
8000b47e:	853e                	mv	a0,a5
8000b480:	e2efb0ef          	jal	80006aae <usbd_event_disconnect_handler>
8000b484:	a091                	j	8000b4c8 <.L56>

8000b486 <.L57>:
        } else {
            if (g_hpm_udc[busid].is_suspend) {
8000b486:	00f14683          	lbu	a3,15(sp)
8000b48a:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b48e:	14800793          	li	a5,328
8000b492:	02f687b3          	mul	a5,a3,a5
8000b496:	97ba                	add	a5,a5,a4
8000b498:	0047c783          	lbu	a5,4(a5)
8000b49c:	c38d                	beqz	a5,8000b4be <.L58>
                g_hpm_udc[busid].is_suspend = false;
8000b49e:	00f14683          	lbu	a3,15(sp)
8000b4a2:	80020713          	add	a4,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>
8000b4a6:	14800793          	li	a5,328
8000b4aa:	02f687b3          	mul	a5,a3,a5
8000b4ae:	97ba                	add	a5,a5,a4
8000b4b0:	00078223          	sb	zero,4(a5)
                usbd_event_resume_handler(busid);
8000b4b4:	00f14783          	lbu	a5,15(sp)
8000b4b8:	853e                	mv	a0,a5
8000b4ba:	c32ff0ef          	jal	8000a8ec <usbd_event_resume_handler>

8000b4be <.L58>:
            }
            usbd_event_connect_handler(busid);
8000b4be:	00f14783          	lbu	a5,15(sp)
8000b4c2:	853e                	mv	a0,a5
8000b4c4:	db8fb0ef          	jal	80006a7c <usbd_event_connect_handler>

8000b4c8 <.L56>:
        }
    }

    if (int_status & intr_usb) {
8000b4c8:	57b2                	lw	a5,44(sp)
8000b4ca:	8b85                	and	a5,a5,1
8000b4cc:	18078563          	beqz	a5,8000b656 <.L71>

8000b4d0 <.LBB22>:
        uint32_t const edpt_complete = usb_device_get_edpt_complete_status(handle);
8000b4d0:	5542                	lw	a0,48(sp)
8000b4d2:	990f90ef          	jal	80004662 <usb_device_get_edpt_complete_status>
8000b4d6:	d42a                	sw	a0,40(sp)
        usb_device_clear_edpt_complete_status(handle, edpt_complete);
8000b4d8:	55a2                	lw	a1,40(sp)
8000b4da:	5542                	lw	a0,48(sp)
8000b4dc:	bc1fd0ef          	jal	8000909c <usb_device_clear_edpt_complete_status>
        uint32_t edpt_setup_status = usb_device_get_setup_status(handle);
8000b4e0:	5542                	lw	a0,48(sp)
8000b4e2:	99cf90ef          	jal	8000467e <usb_device_get_setup_status>
8000b4e6:	d22a                	sw	a0,36(sp)

        if (edpt_setup_status) {
8000b4e8:	5792                	lw	a5,36(sp)
8000b4ea:	c39d                	beqz	a5,8000b510 <.L60>

8000b4ec <.LBB23>:
            /*------------- Set up Received -------------*/
            usb_device_clear_setup_status(handle, edpt_setup_status);
8000b4ec:	5592                	lw	a1,36(sp)
8000b4ee:	5542                	lw	a0,48(sp)
8000b4f0:	bc7fd0ef          	jal	800090b6 <usb_device_clear_setup_status>
            dcd_qhd_t *qhd0 = usb_device_qhd_get(handle, 0);
8000b4f4:	4581                	li	a1,0
8000b4f6:	5542                	lw	a0,48(sp)
8000b4f8:	a8dfd0ef          	jal	80008f84 <usb_device_qhd_get>
8000b4fc:	d02a                	sw	a0,32(sp)
            usbd_event_ep0_setup_complete_handler(busid, (uint8_t *)&qhd0->setup_request);
8000b4fe:	5782                	lw	a5,32(sp)
8000b500:	02878713          	add	a4,a5,40
8000b504:	00f14783          	lbu	a5,15(sp)
8000b508:	85ba                	mv	a1,a4
8000b50a:	853e                	mv	a0,a5
8000b50c:	f08fb0ef          	jal	80006c14 <usbd_event_ep0_setup_complete_handler>

8000b510 <.L60>:
        }

        if (edpt_complete) {
8000b510:	57a2                	lw	a5,40(sp)
8000b512:	14078263          	beqz	a5,8000b656 <.L71>

8000b516 <.LBB24>:
            for (uint8_t ep_idx = 0; ep_idx < USB_SOS_DCD_MAX_QHD_COUNT; ep_idx++) {
8000b516:	02010d23          	sb	zero,58(sp)
8000b51a:	aa0d                	j	8000b64c <.L61>

8000b51c <.L70>:
                if (edpt_complete & (1 << ep_idx2bit(ep_idx))) {
8000b51c:	03a14783          	lbu	a5,58(sp)
8000b520:	853e                	mv	a0,a5
8000b522:	c69fb0ef          	jal	8000718a <ep_idx2bit>
8000b526:	87aa                	mv	a5,a0
8000b528:	873e                	mv	a4,a5
8000b52a:	4785                	li	a5,1
8000b52c:	00e797b3          	sll	a5,a5,a4
8000b530:	873e                	mv	a4,a5
8000b532:	57a2                	lw	a5,40(sp)
8000b534:	8ff9                	and	a5,a5,a4
8000b536:	10078663          	beqz	a5,8000b642 <.L62>

8000b53a <.LBB25>:
                    transfer_len = 0;
8000b53a:	de02                	sw	zero,60(sp)
                    ep_cb_req = true;
8000b53c:	4785                	li	a5,1
8000b53e:	02f10da3          	sb	a5,59(sp)

                    /* Failed QTD also get ENDPTCOMPLETE set */
                    dcd_qtd_t *p_qtd = usb_device_qtd_get(handle, ep_idx);
8000b542:	03a14783          	lbu	a5,58(sp)
8000b546:	85be                	mv	a1,a5
8000b548:	5542                	lw	a0,48(sp)
8000b54a:	f35f80ef          	jal	8000447e <usb_device_qtd_get>
8000b54e:	da2a                	sw	a0,52(sp)

8000b550 <.L68>:
                    while (1) {
                        if (p_qtd->halted || p_qtd->xact_err || p_qtd->buffer_err) {
8000b550:	57d2                	lw	a5,52(sp)
8000b552:	43dc                	lw	a5,4(a5)
8000b554:	8399                	srl	a5,a5,0x6
8000b556:	8b85                	and	a5,a5,1
8000b558:	0ff7f793          	zext.b	a5,a5
8000b55c:	ef99                	bnez	a5,8000b57a <.L63>
8000b55e:	57d2                	lw	a5,52(sp)
8000b560:	43dc                	lw	a5,4(a5)
8000b562:	838d                	srl	a5,a5,0x3
8000b564:	8b85                	and	a5,a5,1
8000b566:	0ff7f793          	zext.b	a5,a5
8000b56a:	eb81                	bnez	a5,8000b57a <.L63>
8000b56c:	57d2                	lw	a5,52(sp)
8000b56e:	43dc                	lw	a5,4(a5)
8000b570:	8395                	srl	a5,a5,0x5
8000b572:	8b85                	and	a5,a5,1
8000b574:	0ff7f793          	zext.b	a5,a5
8000b578:	c385                	beqz	a5,8000b598 <.L64>

8000b57a <.L63>:
                            USB_LOG_ERR("usbd transfer error!\r\n");
8000b57a:	800057b7          	lui	a5,0x80005
8000b57e:	18c78513          	add	a0,a5,396 # 8000518c <.LC0>
8000b582:	f5afd0ef          	jal	80008cdc <printf>
8000b586:	800057b7          	lui	a5,0x80005
8000b58a:	1ac78513          	add	a0,a5,428 # 800051ac <.LC2>
8000b58e:	f4efd0ef          	jal	80008cdc <printf>
                            ep_cb_req = false;
8000b592:	02010da3          	sb	zero,59(sp)
                            break;
8000b596:	a891                	j	8000b5ea <.L65>

8000b598 <.L64>:
                        } else if (p_qtd->active) {
8000b598:	57d2                	lw	a5,52(sp)
8000b59a:	43dc                	lw	a5,4(a5)
8000b59c:	839d                	srl	a5,a5,0x7
8000b59e:	8b85                	and	a5,a5,1
8000b5a0:	0ff7f793          	zext.b	a5,a5
8000b5a4:	c781                	beqz	a5,8000b5ac <.L66>
                            ep_cb_req = false;
8000b5a6:	02010da3          	sb	zero,59(sp)
                            break;
8000b5aa:	a081                	j	8000b5ea <.L65>

8000b5ac <.L66>:
                        } else {
                            transfer_len += p_qtd->expected_bytes - p_qtd->total_bytes;
8000b5ac:	57d2                	lw	a5,52(sp)
8000b5ae:	01c7d783          	lhu	a5,28(a5)
8000b5b2:	07c2                	sll	a5,a5,0x10
8000b5b4:	83c1                	srl	a5,a5,0x10
8000b5b6:	873e                	mv	a4,a5
8000b5b8:	57d2                	lw	a5,52(sp)
8000b5ba:	43dc                	lw	a5,4(a5)
8000b5bc:	83c1                	srl	a5,a5,0x10
8000b5be:	86be                	mv	a3,a5
8000b5c0:	67a1                	lui	a5,0x8
8000b5c2:	17fd                	add	a5,a5,-1 # 7fff <__NONCACHEABLE_RAM_segment_used_size__+0x28f7>
8000b5c4:	8ff5                	and	a5,a5,a3
8000b5c6:	07c2                	sll	a5,a5,0x10
8000b5c8:	83c1                	srl	a5,a5,0x10
8000b5ca:	40f707b3          	sub	a5,a4,a5
8000b5ce:	873e                	mv	a4,a5
8000b5d0:	57f2                	lw	a5,60(sp)
8000b5d2:	97ba                	add	a5,a5,a4
8000b5d4:	de3e                	sw	a5,60(sp)
                        }

                        if (p_qtd->next == USB_SOC_DCD_QTD_NEXT_INVALID) {
8000b5d6:	57d2                	lw	a5,52(sp)
8000b5d8:	4398                	lw	a4,0(a5)
8000b5da:	4785                	li	a5,1
8000b5dc:	00f70663          	beq	a4,a5,8000b5e8 <.L72>
                            break;
                        } else {
                            p_qtd = (dcd_qtd_t *)p_qtd->next;
8000b5e0:	57d2                	lw	a5,52(sp)
8000b5e2:	439c                	lw	a5,0(a5)
8000b5e4:	da3e                	sw	a5,52(sp)
                        if (p_qtd->halted || p_qtd->xact_err || p_qtd->buffer_err) {
8000b5e6:	b7ad                	j	8000b550 <.L68>

8000b5e8 <.L72>:
                            break;
8000b5e8:	0001                	nop

8000b5ea <.L65>:
                        }
                    }

                    if (ep_cb_req) {
8000b5ea:	03b14783          	lbu	a5,59(sp)
8000b5ee:	cbb1                	beqz	a5,8000b642 <.L62>

8000b5f0 <.LBB26>:
                        uint8_t const ep_addr = (ep_idx / 2) | ((ep_idx & 0x01) ? 0x80 : 0);
8000b5f0:	03a14783          	lbu	a5,58(sp)
8000b5f4:	8385                	srl	a5,a5,0x1
8000b5f6:	0ff7f793          	zext.b	a5,a5
8000b5fa:	01879713          	sll	a4,a5,0x18
8000b5fe:	8761                	sra	a4,a4,0x18
8000b600:	03a10783          	lb	a5,58(sp)
8000b604:	079e                	sll	a5,a5,0x7
8000b606:	07e2                	sll	a5,a5,0x18
8000b608:	87e1                	sra	a5,a5,0x18
8000b60a:	8fd9                	or	a5,a5,a4
8000b60c:	07e2                	sll	a5,a5,0x18
8000b60e:	87e1                	sra	a5,a5,0x18
8000b610:	00f10fa3          	sb	a5,31(sp)
                        if (ep_addr & 0x80) {
8000b614:	01f10783          	lb	a5,31(sp)
8000b618:	0007dc63          	bgez	a5,8000b630 <.L69>
                            usbd_event_ep_in_complete_handler(busid, ep_addr, transfer_len);
8000b61c:	01f14703          	lbu	a4,31(sp)
8000b620:	00f14783          	lbu	a5,15(sp)
8000b624:	5672                	lw	a2,60(sp)
8000b626:	85ba                	mv	a1,a4
8000b628:	853e                	mv	a0,a5
8000b62a:	915fb0ef          	jal	80006f3e <usbd_event_ep_in_complete_handler>
8000b62e:	a811                	j	8000b642 <.L62>

8000b630 <.L69>:
                        } else {
                            usbd_event_ep_out_complete_handler(busid, ep_addr, transfer_len);
8000b630:	01f14703          	lbu	a4,31(sp)
8000b634:	00f14783          	lbu	a5,15(sp)
8000b638:	5672                	lw	a2,60(sp)
8000b63a:	85ba                	mv	a1,a4
8000b63c:	853e                	mv	a0,a5
8000b63e:	97ffb0ef          	jal	80006fbc <usbd_event_ep_out_complete_handler>

8000b642 <.L62>:
            for (uint8_t ep_idx = 0; ep_idx < USB_SOS_DCD_MAX_QHD_COUNT; ep_idx++) {
8000b642:	03a14783          	lbu	a5,58(sp)
8000b646:	0785                	add	a5,a5,1
8000b648:	02f10d23          	sb	a5,58(sp)

8000b64c <.L61>:
8000b64c:	03a14703          	lbu	a4,58(sp)
8000b650:	47bd                	li	a5,15
8000b652:	ece7f5e3          	bgeu	a5,a4,8000b51c <.L70>

8000b656 <.L71>:
                    }
                }
            }
        }
    }
}
8000b656:	0001                	nop
8000b658:	40b6                	lw	ra,76(sp)
8000b65a:	6161                	add	sp,sp,80
8000b65c:	8082                	ret

Disassembly of section .text._clean_up:

8000b65e <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
8000b65e:	7139                	add	sp,sp,-64

8000b660 <.LBB18>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000b660:	6785                	lui	a5,0x1
8000b662:	80078793          	add	a5,a5,-2048 # 800 <.L195+0xa>
8000b666:	3047b073          	csrc	mie,a5
}
8000b66a:	0001                	nop
8000b66c:	da02                	sw	zero,52(sp)
8000b66e:	d802                	sw	zero,48(sp)
8000b670:	e40007b7          	lui	a5,0xe4000
8000b674:	d63e                	sw	a5,44(sp)
8000b676:	57d2                	lw	a5,52(sp)
8000b678:	d43e                	sw	a5,40(sp)
8000b67a:	57c2                	lw	a5,48(sp)
8000b67c:	d23e                	sw	a5,36(sp)

8000b67e <.LBB20>:
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
8000b67e:	57a2                	lw	a5,40(sp)
8000b680:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
8000b684:	57b2                	lw	a5,44(sp)
8000b686:	973e                	add	a4,a4,a5
8000b688:	002007b7          	lui	a5,0x200
8000b68c:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
8000b68e:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
8000b690:	5782                	lw	a5,32(sp)
8000b692:	5712                	lw	a4,36(sp)
8000b694:	c398                	sw	a4,0(a5)
}
8000b696:	0001                	nop

8000b698 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
8000b698:	0001                	nop

8000b69a <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
8000b69a:	de02                	sw	zero,60(sp)
8000b69c:	a82d                	j	8000b6d6 <.L2>

8000b69e <.L3>:
8000b69e:	ce02                	sw	zero,28(sp)
8000b6a0:	57f2                	lw	a5,60(sp)
8000b6a2:	cc3e                	sw	a5,24(sp)
8000b6a4:	e40007b7          	lui	a5,0xe4000
8000b6a8:	ca3e                	sw	a5,20(sp)
8000b6aa:	47f2                	lw	a5,28(sp)
8000b6ac:	c83e                	sw	a5,16(sp)
8000b6ae:	47e2                	lw	a5,24(sp)
8000b6b0:	c63e                	sw	a5,12(sp)

8000b6b2 <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
8000b6b2:	47c2                	lw	a5,16(sp)
8000b6b4:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
8000b6b8:	47d2                	lw	a5,20(sp)
8000b6ba:	973e                	add	a4,a4,a5
8000b6bc:	002007b7          	lui	a5,0x200
8000b6c0:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_end__+0x140004>
8000b6c2:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
8000b6c4:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
8000b6c6:	47a2                	lw	a5,8(sp)
8000b6c8:	4732                	lw	a4,12(sp)
8000b6ca:	c398                	sw	a4,0(a5)
}
8000b6cc:	0001                	nop

8000b6ce <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
8000b6ce:	0001                	nop

8000b6d0 <.LBE25>:
8000b6d0:	57f2                	lw	a5,60(sp)
8000b6d2:	0785                	add	a5,a5,1
8000b6d4:	de3e                	sw	a5,60(sp)

8000b6d6 <.L2>:
8000b6d6:	5772                	lw	a4,60(sp)
8000b6d8:	07f00793          	li	a5,127
8000b6dc:	fce7f1e3          	bgeu	a5,a4,8000b69e <.L3>

8000b6e0 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
8000b6e0:	dc02                	sw	zero,56(sp)
8000b6e2:	a821                	j	8000b6fa <.L4>

8000b6e4 <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
8000b6e4:	57e2                	lw	a5,56(sp)
8000b6e6:	00279713          	sll	a4,a5,0x2
8000b6ea:	e40027b7          	lui	a5,0xe4002
8000b6ee:	97ba                	add	a5,a5,a4
8000b6f0:	0007a023          	sw	zero,0(a5) # e4002000 <__XPI0_segment_end__+0x63002000>
    for (uint32_t i = 0; i < 4; i++) {
8000b6f4:	57e2                	lw	a5,56(sp)
8000b6f6:	0785                	add	a5,a5,1
8000b6f8:	dc3e                	sw	a5,56(sp)

8000b6fa <.L4>:
8000b6fa:	5762                	lw	a4,56(sp)
8000b6fc:	478d                	li	a5,3
8000b6fe:	fee7f3e3          	bgeu	a5,a4,8000b6e4 <.L5>

8000b702 <.LBE29>:
    }
}
8000b702:	0001                	nop
8000b704:	0001                	nop
8000b706:	6121                	add	sp,sp,64
8000b708:	8082                	ret

Disassembly of section .text.reset_handler:

8000b70a <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
8000b70a:	1141                	add	sp,sp,-16
8000b70c:	c606                	sw	ra,12(sp)
    fencei();
8000b70e:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
8000b712:	b8efc0ef          	jal	80007aa0 <system_init>

    /* Entry function */
    MAIN_ENTRY();
8000b716:	7fff7097          	auipc	ra,0x7fff7
8000b71a:	2d2080e7          	jalr	722(ra) # 29e8 <main>
}
8000b71e:	0001                	nop
8000b720:	40b2                	lw	ra,12(sp)
8000b722:	0141                	add	sp,sp,16
8000b724:	8082                	ret

Disassembly of section .text._init:

8000b726 <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
8000b726:	0001                	nop
8000b728:	8082                	ret

Disassembly of section .text.mchtmr_isr:

8000b72a <mchtmr_isr>:
}
8000b72a:	0001                	nop
8000b72c:	8082                	ret

Disassembly of section .text.swi_isr:

8000b72e <swi_isr>:
}
8000b72e:	0001                	nop
8000b730:	8082                	ret

Disassembly of section .text.exception_handler:

8000b732 <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
8000b732:	1141                	add	sp,sp,-16
8000b734:	c62a                	sw	a0,12(sp)
8000b736:	c42e                	sw	a1,8(sp)
    switch (cause) {
8000b738:	4732                	lw	a4,12(sp)
8000b73a:	47bd                	li	a5,15
8000b73c:	00e7ec63          	bltu	a5,a4,8000b754 <.L23>
8000b740:	47b2                	lw	a5,12(sp)
8000b742:	00279713          	sll	a4,a5,0x2
8000b746:	800047b7          	lui	a5,0x80004
8000b74a:	84078793          	add	a5,a5,-1984 # 80003840 <.L7>
8000b74e:	97ba                	add	a5,a5,a4
8000b750:	439c                	lw	a5,0(a5)
8000b752:	8782                	jr	a5

8000b754 <.L23>:
        case MCAUSE_LOAD_PAGE_FAULT:
            break;
        case MCAUSE_STORE_AMO_PAGE_FAULT:
            break;
        default:
            break;
8000b754:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
8000b756:	47a2                	lw	a5,8(sp)
}
8000b758:	853e                	mv	a0,a5
8000b75a:	0141                	add	sp,sp,16
8000b75c:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

8000b75e <get_frequency_for_source>:
{
8000b75e:	7179                	add	sp,sp,-48
8000b760:	d606                	sw	ra,44(sp)
8000b762:	87aa                	mv	a5,a0
8000b764:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
8000b768:	ce02                	sw	zero,28(sp)
    uint32_t div = 1;
8000b76a:	4785                	li	a5,1
8000b76c:	cc3e                	sw	a5,24(sp)
    switch (source) {
8000b76e:	00f14783          	lbu	a5,15(sp)
8000b772:	471d                	li	a4,7
8000b774:	0cf76e63          	bltu	a4,a5,8000b850 <.L36>
8000b778:	00279713          	sll	a4,a5,0x2
8000b77c:	800047b7          	lui	a5,0x80004
8000b780:	8cc78793          	add	a5,a5,-1844 # 800038cc <.L38>
8000b784:	97ba                	add	a5,a5,a4
8000b786:	439c                	lw	a5,0(a5)
8000b788:	8782                	jr	a5

8000b78a <.L45>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
8000b78a:	016e37b7          	lui	a5,0x16e3
8000b78e:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000b792:	ce3e                	sw	a5,28(sp)
        break;
8000b794:	a0c1                	j	8000b854 <.L46>

8000b796 <.L44>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 0U);
8000b796:	4581                	li	a1,0
8000b798:	f4100537          	lui	a0,0xf4100
8000b79c:	f7dfd0ef          	jal	80009718 <pllctl_get_pll_freq_in_hz>
8000b7a0:	ce2a                	sw	a0,28(sp)
        break;
8000b7a2:	a84d                	j	8000b854 <.L46>

8000b7a4 <.L43>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 0);
8000b7a4:	4601                	li	a2,0
8000b7a6:	4585                	li	a1,1
8000b7a8:	f4100537          	lui	a0,0xf4100
8000b7ac:	d4ffb0ef          	jal	800074fa <pllctl_get_div>
8000b7b0:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
8000b7b2:	4585                	li	a1,1
8000b7b4:	f4100537          	lui	a0,0xf4100
8000b7b8:	f61fd0ef          	jal	80009718 <pllctl_get_pll_freq_in_hz>
8000b7bc:	872a                	mv	a4,a0
8000b7be:	47e2                	lw	a5,24(sp)
8000b7c0:	02f757b3          	divu	a5,a4,a5
8000b7c4:	ce3e                	sw	a5,28(sp)
        break;
8000b7c6:	a079                	j	8000b854 <.L46>

8000b7c8 <.L42>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 1);
8000b7c8:	4605                	li	a2,1
8000b7ca:	4585                	li	a1,1
8000b7cc:	f4100537          	lui	a0,0xf4100
8000b7d0:	d2bfb0ef          	jal	800074fa <pllctl_get_div>
8000b7d4:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
8000b7d6:	4585                	li	a1,1
8000b7d8:	f4100537          	lui	a0,0xf4100
8000b7dc:	f3dfd0ef          	jal	80009718 <pllctl_get_pll_freq_in_hz>
8000b7e0:	872a                	mv	a4,a0
8000b7e2:	47e2                	lw	a5,24(sp)
8000b7e4:	02f757b3          	divu	a5,a4,a5
8000b7e8:	ce3e                	sw	a5,28(sp)
        break;
8000b7ea:	a0ad                	j	8000b854 <.L46>

8000b7ec <.L41>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 0);
8000b7ec:	4601                	li	a2,0
8000b7ee:	4589                	li	a1,2
8000b7f0:	f4100537          	lui	a0,0xf4100
8000b7f4:	d07fb0ef          	jal	800074fa <pllctl_get_div>
8000b7f8:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
8000b7fa:	4589                	li	a1,2
8000b7fc:	f4100537          	lui	a0,0xf4100
8000b800:	f19fd0ef          	jal	80009718 <pllctl_get_pll_freq_in_hz>
8000b804:	872a                	mv	a4,a0
8000b806:	47e2                	lw	a5,24(sp)
8000b808:	02f757b3          	divu	a5,a4,a5
8000b80c:	ce3e                	sw	a5,28(sp)
        break;
8000b80e:	a099                	j	8000b854 <.L46>

8000b810 <.L40>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 1);
8000b810:	4605                	li	a2,1
8000b812:	4589                	li	a1,2
8000b814:	f4100537          	lui	a0,0xf4100
8000b818:	ce3fb0ef          	jal	800074fa <pllctl_get_div>
8000b81c:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
8000b81e:	4589                	li	a1,2
8000b820:	f4100537          	lui	a0,0xf4100
8000b824:	ef5fd0ef          	jal	80009718 <pllctl_get_pll_freq_in_hz>
8000b828:	872a                	mv	a4,a0
8000b82a:	47e2                	lw	a5,24(sp)
8000b82c:	02f757b3          	divu	a5,a4,a5
8000b830:	ce3e                	sw	a5,28(sp)
        break;
8000b832:	a00d                	j	8000b854 <.L46>

8000b834 <.L39>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 3U);
8000b834:	458d                	li	a1,3
8000b836:	f4100537          	lui	a0,0xf4100
8000b83a:	edffd0ef          	jal	80009718 <pllctl_get_pll_freq_in_hz>
8000b83e:	ce2a                	sw	a0,28(sp)
        break;
8000b840:	a811                	j	8000b854 <.L46>

8000b842 <.L37>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 4U);
8000b842:	4591                	li	a1,4
8000b844:	f4100537          	lui	a0,0xf4100
8000b848:	ed1fd0ef          	jal	80009718 <pllctl_get_pll_freq_in_hz>
8000b84c:	ce2a                	sw	a0,28(sp)
        break;
8000b84e:	a019                	j	8000b854 <.L46>

8000b850 <.L36>:
        clk_freq = 0UL;
8000b850:	ce02                	sw	zero,28(sp)
        break;
8000b852:	0001                	nop

8000b854 <.L46>:
    return clk_freq;
8000b854:	47f2                	lw	a5,28(sp)
}
8000b856:	853e                	mv	a0,a5
8000b858:	50b2                	lw	ra,44(sp)
8000b85a:	6145                	add	sp,sp,48
8000b85c:	8082                	ret

Disassembly of section .text.get_frequency_for_i2s_or_adc:

8000b85e <get_frequency_for_i2s_or_adc>:
{
8000b85e:	7139                	add	sp,sp,-64
8000b860:	de06                	sw	ra,60(sp)
8000b862:	c62a                	sw	a0,12(sp)
8000b864:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
8000b866:	d602                	sw	zero,44(sp)
    bool is_mux_valid = false;
8000b868:	020105a3          	sb	zero,43(sp)
    clock_node_t node = clock_node_end;
8000b86c:	04b00793          	li	a5,75
8000b870:	02f10523          	sb	a5,42(sp)
    if (clk_src_type == CLK_SRC_GROUP_ADC) {
8000b874:	4732                	lw	a4,12(sp)
8000b876:	4785                	li	a5,1
8000b878:	04f71563          	bne	a4,a5,8000b8c2 <.L52>

8000b87c <.LBB7>:
        uint32_t adc_index = instance;
8000b87c:	47a2                	lw	a5,8(sp)
8000b87e:	ce3e                	sw	a5,28(sp)
        if (adc_index < ADC_INSTANCE_NUM) {
8000b880:	4772                	lw	a4,28(sp)
8000b882:	478d                	li	a5,3
8000b884:	08e7e163          	bltu	a5,a4,8000b906 <.L53>

8000b888 <.LBB8>:
            uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
8000b888:	f4000737          	lui	a4,0xf4000
8000b88c:	47f2                	lw	a5,28(sp)
8000b88e:	70078793          	add	a5,a5,1792
8000b892:	078a                	sll	a5,a5,0x2
8000b894:	97ba                	add	a5,a5,a4
8000b896:	439c                	lw	a5,0(a5)
8000b898:	83a1                	srl	a5,a5,0x8
8000b89a:	8b9d                	and	a5,a5,7
8000b89c:	cc3e                	sw	a5,24(sp)
            if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
8000b89e:	4762                	lw	a4,24(sp)
8000b8a0:	478d                	li	a5,3
8000b8a2:	06e7e263          	bltu	a5,a4,8000b906 <.L53>
                node = s_adc_clk_mux_node[mux_in_reg];
8000b8a6:	800047b7          	lui	a5,0x80004
8000b8aa:	88078713          	add	a4,a5,-1920 # 80003880 <s_adc_clk_mux_node>
8000b8ae:	47e2                	lw	a5,24(sp)
8000b8b0:	97ba                	add	a5,a5,a4
8000b8b2:	0007c783          	lbu	a5,0(a5)
8000b8b6:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
8000b8ba:	4785                	li	a5,1
8000b8bc:	02f105a3          	sb	a5,43(sp)
8000b8c0:	a099                	j	8000b906 <.L53>

8000b8c2 <.L52>:
        uint32_t i2s_index = instance;
8000b8c2:	47a2                	lw	a5,8(sp)
8000b8c4:	d23e                	sw	a5,36(sp)
        if (i2s_index < I2S_INSTANCE_NUM) {
8000b8c6:	5712                	lw	a4,36(sp)
8000b8c8:	478d                	li	a5,3
8000b8ca:	02e7ee63          	bltu	a5,a4,8000b906 <.L53>

8000b8ce <.LBB10>:
            uint32_t mux_in_reg = SYSCTL_I2SCLK_MUX_GET(HPM_SYSCTL->I2SCLK[i2s_index]);
8000b8ce:	f4000737          	lui	a4,0xf4000
8000b8d2:	5792                	lw	a5,36(sp)
8000b8d4:	70478793          	add	a5,a5,1796
8000b8d8:	078a                	sll	a5,a5,0x2
8000b8da:	97ba                	add	a5,a5,a4
8000b8dc:	439c                	lw	a5,0(a5)
8000b8de:	83a1                	srl	a5,a5,0x8
8000b8e0:	8b9d                	and	a5,a5,7
8000b8e2:	d03e                	sw	a5,32(sp)
            if (mux_in_reg < ARRAY_SIZE(s_i2s_clk_mux_node)) {
8000b8e4:	5702                	lw	a4,32(sp)
8000b8e6:	478d                	li	a5,3
8000b8e8:	00e7ef63          	bltu	a5,a4,8000b906 <.L53>
                node = s_i2s_clk_mux_node[mux_in_reg];
8000b8ec:	800047b7          	lui	a5,0x80004
8000b8f0:	88478713          	add	a4,a5,-1916 # 80003884 <s_i2s_clk_mux_node>
8000b8f4:	5782                	lw	a5,32(sp)
8000b8f6:	97ba                	add	a5,a5,a4
8000b8f8:	0007c783          	lbu	a5,0(a5)
8000b8fc:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
8000b900:	4785                	li	a5,1
8000b902:	02f105a3          	sb	a5,43(sp)

8000b906 <.L53>:
    if (is_mux_valid) {
8000b906:	02b14783          	lbu	a5,43(sp)
8000b90a:	c38d                	beqz	a5,8000b92c <.L54>
        if (node == clock_node_ahb0) {
8000b90c:	02a14703          	lbu	a4,42(sp)
8000b910:	479d                	li	a5,7
8000b912:	00f71763          	bne	a4,a5,8000b920 <.L55>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000b916:	451d                	li	a0,7
8000b918:	d15fb0ef          	jal	8000762c <get_frequency_for_ip_in_common_group>
8000b91c:	d62a                	sw	a0,44(sp)
8000b91e:	a039                	j	8000b92c <.L54>

8000b920 <.L55>:
            clk_freq = get_frequency_for_ip_in_common_group(node);
8000b920:	02a14783          	lbu	a5,42(sp)
8000b924:	853e                	mv	a0,a5
8000b926:	d07fb0ef          	jal	8000762c <get_frequency_for_ip_in_common_group>
8000b92a:	d62a                	sw	a0,44(sp)

8000b92c <.L54>:
    return clk_freq;
8000b92c:	57b2                	lw	a5,44(sp)
}
8000b92e:	853e                	mv	a0,a5
8000b930:	50f2                	lw	ra,60(sp)
8000b932:	6121                	add	sp,sp,64
8000b934:	8082                	ret

Disassembly of section .text.get_frequency_for_wdg:

8000b936 <get_frequency_for_wdg>:
{
8000b936:	7179                	add	sp,sp,-48
8000b938:	d606                	sw	ra,44(sp)
8000b93a:	c62a                	sw	a0,12(sp)
    if (WDG_CTRL_CLKSEL_GET(s_wdgs[instance]->CTRL) == 0) {
8000b93c:	800047b7          	lui	a5,0x80004
8000b940:	88878713          	add	a4,a5,-1912 # 80003888 <s_wdgs>
8000b944:	47b2                	lw	a5,12(sp)
8000b946:	078a                	sll	a5,a5,0x2
8000b948:	97ba                	add	a5,a5,a4
8000b94a:	439c                	lw	a5,0(a5)
8000b94c:	4b9c                	lw	a5,16(a5)
8000b94e:	8b89                	and	a5,a5,2
8000b950:	e791                	bnez	a5,8000b95c <.L58>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000b952:	451d                	li	a0,7
8000b954:	cd9fb0ef          	jal	8000762c <get_frequency_for_ip_in_common_group>
8000b958:	ce2a                	sw	a0,28(sp)
8000b95a:	a019                	j	8000b960 <.L59>

8000b95c <.L58>:
        freq_in_hz = FREQ_32KHz;
8000b95c:	67a1                	lui	a5,0x8
8000b95e:	ce3e                	sw	a5,28(sp)

8000b960 <.L59>:
    return freq_in_hz;
8000b960:	47f2                	lw	a5,28(sp)
}
8000b962:	853e                	mv	a0,a5
8000b964:	50b2                	lw	ra,44(sp)
8000b966:	6145                	add	sp,sp,48
8000b968:	8082                	ret

Disassembly of section .text.get_frequency_for_pwdg:

8000b96a <get_frequency_for_pwdg>:
{
8000b96a:	1141                	add	sp,sp,-16
    if (WDG_CTRL_CLKSEL_GET(HPM_PWDG->CTRL) == 0) {
8000b96c:	f40e87b7          	lui	a5,0xf40e8
8000b970:	4b9c                	lw	a5,16(a5)
8000b972:	8b89                	and	a5,a5,2
8000b974:	e799                	bnez	a5,8000b982 <.L62>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
8000b976:	016e37b7          	lui	a5,0x16e3
8000b97a:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000b97e:	c63e                	sw	a5,12(sp)
8000b980:	a019                	j	8000b986 <.L63>

8000b982 <.L62>:
        freq_in_hz = FREQ_32KHz;
8000b982:	67a1                	lui	a5,0x8
8000b984:	c63e                	sw	a5,12(sp)

8000b986 <.L63>:
    return freq_in_hz;
8000b986:	47b2                	lw	a5,12(sp)
}
8000b988:	853e                	mv	a0,a5
8000b98a:	0141                	add	sp,sp,16
8000b98c:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

8000b98e <clock_connect_group_to_cpu>:
{
8000b98e:	1141                	add	sp,sp,-16
8000b990:	c62a                	sw	a0,12(sp)
8000b992:	c42e                	sw	a1,8(sp)
    if (cpu < 2U) {
8000b994:	4722                	lw	a4,8(sp)
8000b996:	4785                	li	a5,1
8000b998:	00e7ee63          	bltu	a5,a4,8000b9b4 <.L173>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
8000b99c:	f40006b7          	lui	a3,0xf4000
8000b9a0:	47b2                	lw	a5,12(sp)
8000b9a2:	4705                	li	a4,1
8000b9a4:	00f71733          	sll	a4,a4,a5
8000b9a8:	47a2                	lw	a5,8(sp)
8000b9aa:	09078793          	add	a5,a5,144 # 8090 <__AHB_SRAM_segment_size__+0x90>
8000b9ae:	0792                	sll	a5,a5,0x4
8000b9b0:	97b6                	add	a5,a5,a3
8000b9b2:	c3d8                	sw	a4,4(a5)

8000b9b4 <.L173>:
}
8000b9b4:	0001                	nop
8000b9b6:	0141                	add	sp,sp,16
8000b9b8:	8082                	ret

Disassembly of section .text.clock_get_core_clock_ticks_per_us:

8000b9ba <clock_get_core_clock_ticks_per_us>:
{
8000b9ba:	1141                	add	sp,sp,-16
8000b9bc:	c606                	sw	ra,12(sp)
    if (hpm_core_clock == 0U) {
8000b9be:	be422783          	lw	a5,-1052(tp) # fffffbe4 <__APB_SRAM_segment_end__+0xbf0dbe4>
8000b9c2:	e399                	bnez	a5,8000b9c8 <.L178>
        clock_update_core_clock();
8000b9c4:	f4bfb0ef          	jal	8000790e <clock_update_core_clock>

8000b9c8 <.L178>:
    return (hpm_core_clock + FREQ_1MHz - 1U) / FREQ_1MHz;
8000b9c8:	be422703          	lw	a4,-1052(tp) # fffffbe4 <__APB_SRAM_segment_end__+0xbf0dbe4>
8000b9cc:	000f47b7          	lui	a5,0xf4
8000b9d0:	23f78793          	add	a5,a5,575 # f423f <__DLM_segment_end__+0x3423f>
8000b9d4:	973e                	add	a4,a4,a5
8000b9d6:	000f47b7          	lui	a5,0xf4
8000b9da:	24078793          	add	a5,a5,576 # f4240 <__DLM_segment_end__+0x34240>
8000b9de:	02f757b3          	divu	a5,a4,a5
}
8000b9e2:	853e                	mv	a0,a5
8000b9e4:	40b2                	lw	ra,12(sp)
8000b9e6:	0141                	add	sp,sp,16
8000b9e8:	8082                	ret

Disassembly of section .text.clock_get_core_clock_ticks_per_ms:

8000b9ea <clock_get_core_clock_ticks_per_ms>:
{
8000b9ea:	1141                	add	sp,sp,-16
8000b9ec:	c606                	sw	ra,12(sp)
    if (hpm_core_clock == 0U) {
8000b9ee:	be422783          	lw	a5,-1052(tp) # fffffbe4 <__APB_SRAM_segment_end__+0xbf0dbe4>
8000b9f2:	e399                	bnez	a5,8000b9f8 <.L181>
        clock_update_core_clock();
8000b9f4:	f1bfb0ef          	jal	8000790e <clock_update_core_clock>

8000b9f8 <.L181>:
    return (hpm_core_clock + FREQ_1MHz - 1U) / 1000;
8000b9f8:	be422703          	lw	a4,-1052(tp) # fffffbe4 <__APB_SRAM_segment_end__+0xbf0dbe4>
8000b9fc:	000f47b7          	lui	a5,0xf4
8000ba00:	23f78793          	add	a5,a5,575 # f423f <__DLM_segment_end__+0x3423f>
8000ba04:	973e                	add	a4,a4,a5
8000ba06:	3e800793          	li	a5,1000
8000ba0a:	02f757b3          	divu	a5,a4,a5
}
8000ba0e:	853e                	mv	a0,a5
8000ba10:	40b2                	lw	ra,12(sp)
8000ba12:	0141                	add	sp,sp,16
8000ba14:	8082                	ret

Disassembly of section .text.l1c_dc_disable:

8000ba16 <l1c_dc_disable>:
{
8000ba16:	1141                	add	sp,sp,-16

8000ba18 <.LBB61>:
    return read_csr(CSR_MCACHE_CTL);
8000ba18:	7ca027f3          	csrr	a5,0x7ca
8000ba1c:	c63e                	sw	a5,12(sp)
8000ba1e:	47b2                	lw	a5,12(sp)

8000ba20 <.LBE65>:
8000ba20:	0001                	nop

8000ba22 <.LBE63>:
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
8000ba22:	8b89                	and	a5,a5,2
8000ba24:	00f037b3          	snez	a5,a5
8000ba28:	0ff7f793          	zext.b	a5,a5

8000ba2c <.LBE61>:
    if (l1c_dc_is_enabled()) {
8000ba2c:	c781                	beqz	a5,8000ba34 <.L18>
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
8000ba2e:	4789                	li	a5,2
8000ba30:	7ca7b073          	csrc	0x7ca,a5

8000ba34 <.L18>:
}
8000ba34:	0001                	nop
8000ba36:	0141                	add	sp,sp,16
8000ba38:	8082                	ret

Disassembly of section .text.l1c_ic_disable:

8000ba3a <l1c_ic_disable>:

void l1c_ic_disable(void)
{
8000ba3a:	1141                	add	sp,sp,-16

8000ba3c <.LBB71>:
    return read_csr(CSR_MCACHE_CTL);
8000ba3c:	7ca027f3          	csrr	a5,0x7ca
8000ba40:	c63e                	sw	a5,12(sp)
8000ba42:	47b2                	lw	a5,12(sp)

8000ba44 <.LBE75>:
8000ba44:	0001                	nop

8000ba46 <.LBE73>:
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
8000ba46:	8b85                	and	a5,a5,1
8000ba48:	00f037b3          	snez	a5,a5
8000ba4c:	0ff7f793          	zext.b	a5,a5

8000ba50 <.LBE71>:
    if (l1c_ic_is_enabled()) {
8000ba50:	c781                	beqz	a5,8000ba58 <.L28>
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IC_EN_MASK);
8000ba52:	4785                	li	a5,1
8000ba54:	7ca7b073          	csrc	0x7ca,a5

8000ba58 <.L28>:
    }
}
8000ba58:	0001                	nop
8000ba5a:	0141                	add	sp,sp,16
8000ba5c:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

8000ba5e <l1c_dc_invalidate_all>:
{
    __asm("fence.i");
}

void l1c_dc_invalidate_all(void)
{
8000ba5e:	1141                	add	sp,sp,-16
8000ba60:	47dd                	li	a5,23
8000ba62:	00f107a3          	sb	a5,15(sp)

8000ba66 <.LBB76>:
}

/* send command */
__attribute__((always_inline)) static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
8000ba66:	00f14783          	lbu	a5,15(sp)
8000ba6a:	7cc79073          	csrw	0x7cc,a5
}
8000ba6e:	0001                	nop

8000ba70 <.LBE76>:
    l1c_cctl_cmd(HPM_L1C_CCTL_CMD_L1D_INVAL_ALL);
}
8000ba70:	0001                	nop
8000ba72:	0141                	add	sp,sp,16
8000ba74:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

8000ba76 <sysctl_enable_group_resource>:
{
8000ba76:	7179                	add	sp,sp,-48
8000ba78:	d606                	sw	ra,44(sp)
8000ba7a:	c62a                	sw	a0,12(sp)
8000ba7c:	87ae                	mv	a5,a1
8000ba7e:	8736                	mv	a4,a3
8000ba80:	00f105a3          	sb	a5,11(sp)
8000ba84:	87b2                	mv	a5,a2
8000ba86:	00f11423          	sh	a5,8(sp)
8000ba8a:	87ba                	mv	a5,a4
8000ba8c:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
8000ba90:	00815703          	lhu	a4,8(sp)
8000ba94:	0ff00793          	li	a5,255
8000ba98:	00e7e463          	bltu	a5,a4,8000baa0 <.L60>
        return status_invalid_argument;
8000ba9c:	4789                	li	a5,2
8000ba9e:	a8e5                	j	8000bb96 <.L61>

8000baa0 <.L60>:
    index = (resource - sysctl_resource_linkable_start) / 32;
8000baa0:	00815783          	lhu	a5,8(sp)
8000baa4:	f0078793          	add	a5,a5,-256
8000baa8:	41f7d713          	sra	a4,a5,0x1f
8000baac:	8b7d                	and	a4,a4,31
8000baae:	97ba                	add	a5,a5,a4
8000bab0:	8795                	sra	a5,a5,0x5
8000bab2:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
8000bab4:	00815783          	lhu	a5,8(sp)
8000bab8:	f0078713          	add	a4,a5,-256
8000babc:	41f75793          	sra	a5,a4,0x1f
8000bac0:	83ed                	srl	a5,a5,0x1b
8000bac2:	973e                	add	a4,a4,a5
8000bac4:	8b7d                	and	a4,a4,31
8000bac6:	40f707b3          	sub	a5,a4,a5
8000baca:	cc3e                	sw	a5,24(sp)
    switch (group) {
8000bacc:	00b14783          	lbu	a5,11(sp)
8000bad0:	c789                	beqz	a5,8000bada <.L62>
8000bad2:	4705                	li	a4,1
8000bad4:	04e78f63          	beq	a5,a4,8000bb32 <.L63>
8000bad8:	a84d                	j	8000bb8a <.L74>

8000bada <.L62>:
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
8000bada:	4732                	lw	a4,12(sp)
8000badc:	47f2                	lw	a5,28(sp)
8000bade:	08078793          	add	a5,a5,128
8000bae2:	0792                	sll	a5,a5,0x4
8000bae4:	97ba                	add	a5,a5,a4
8000bae6:	4398                	lw	a4,0(a5)
8000bae8:	47e2                	lw	a5,24(sp)
8000baea:	4685                	li	a3,1
8000baec:	00f697b3          	sll	a5,a3,a5
8000baf0:	fff7c793          	not	a5,a5
8000baf4:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
8000baf6:	00a14783          	lbu	a5,10(sp)
8000bafa:	c791                	beqz	a5,8000bb06 <.L65>
8000bafc:	47e2                	lw	a5,24(sp)
8000bafe:	4685                	li	a3,1
8000bb00:	00f697b3          	sll	a5,a3,a5
8000bb04:	a011                	j	8000bb08 <.L66>

8000bb06 <.L65>:
8000bb06:	4781                	li	a5,0

8000bb08 <.L66>:
8000bb08:	8f5d                	or	a4,a4,a5
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
8000bb0a:	46b2                	lw	a3,12(sp)
8000bb0c:	47f2                	lw	a5,28(sp)
8000bb0e:	08078793          	add	a5,a5,128
8000bb12:	0792                	sll	a5,a5,0x4
8000bb14:	97b6                	add	a5,a5,a3
8000bb16:	c398                	sw	a4,0(a5)
        if (enable) {
8000bb18:	00a14783          	lbu	a5,10(sp)
8000bb1c:	cbad                	beqz	a5,8000bb8e <.L75>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
8000bb1e:	0001                	nop

8000bb20 <.L68>:
8000bb20:	00815783          	lhu	a5,8(sp)
8000bb24:	85be                	mv	a1,a5
8000bb26:	4532                	lw	a0,12(sp)
8000bb28:	e7ffb0ef          	jal	800079a6 <sysctl_resource_target_is_busy>
8000bb2c:	87aa                	mv	a5,a0
8000bb2e:	fbed                	bnez	a5,8000bb20 <.L68>
        break;
8000bb30:	a8b9                	j	8000bb8e <.L75>

8000bb32 <.L63>:
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
8000bb32:	4732                	lw	a4,12(sp)
8000bb34:	47f2                	lw	a5,28(sp)
8000bb36:	08478793          	add	a5,a5,132
8000bb3a:	0792                	sll	a5,a5,0x4
8000bb3c:	97ba                	add	a5,a5,a4
8000bb3e:	4398                	lw	a4,0(a5)
8000bb40:	47e2                	lw	a5,24(sp)
8000bb42:	4685                	li	a3,1
8000bb44:	00f697b3          	sll	a5,a3,a5
8000bb48:	fff7c793          	not	a5,a5
8000bb4c:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
8000bb4e:	00a14783          	lbu	a5,10(sp)
8000bb52:	c791                	beqz	a5,8000bb5e <.L70>
8000bb54:	47e2                	lw	a5,24(sp)
8000bb56:	4685                	li	a3,1
8000bb58:	00f697b3          	sll	a5,a3,a5
8000bb5c:	a011                	j	8000bb60 <.L71>

8000bb5e <.L70>:
8000bb5e:	4781                	li	a5,0

8000bb60 <.L71>:
8000bb60:	8f5d                	or	a4,a4,a5
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
8000bb62:	46b2                	lw	a3,12(sp)
8000bb64:	47f2                	lw	a5,28(sp)
8000bb66:	08478793          	add	a5,a5,132
8000bb6a:	0792                	sll	a5,a5,0x4
8000bb6c:	97b6                	add	a5,a5,a3
8000bb6e:	c398                	sw	a4,0(a5)
        if (enable) {
8000bb70:	00a14783          	lbu	a5,10(sp)
8000bb74:	cf99                	beqz	a5,8000bb92 <.L76>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
8000bb76:	0001                	nop

8000bb78 <.L73>:
8000bb78:	00815783          	lhu	a5,8(sp)
8000bb7c:	85be                	mv	a1,a5
8000bb7e:	4532                	lw	a0,12(sp)
8000bb80:	e27fb0ef          	jal	800079a6 <sysctl_resource_target_is_busy>
8000bb84:	87aa                	mv	a5,a0
8000bb86:	fbed                	bnez	a5,8000bb78 <.L73>
        break;
8000bb88:	a029                	j	8000bb92 <.L76>

8000bb8a <.L74>:
        return status_invalid_argument;
8000bb8a:	4789                	li	a5,2
8000bb8c:	a029                	j	8000bb96 <.L61>

8000bb8e <.L75>:
        break;
8000bb8e:	0001                	nop
8000bb90:	a011                	j	8000bb94 <.L69>

8000bb92 <.L76>:
        break;
8000bb92:	0001                	nop

8000bb94 <.L69>:
    return status_success;
8000bb94:	4781                	li	a5,0

8000bb96 <.L61>:
}
8000bb96:	853e                	mv	a0,a5
8000bb98:	50b2                	lw	ra,44(sp)
8000bb9a:	6145                	add	sp,sp,48
8000bb9c:	8082                	ret

Disassembly of section .text.enable_plic_feature:

8000bb9e <enable_plic_feature>:
{
8000bb9e:	1141                	add	sp,sp,-16
    uint32_t plic_feature = 0;
8000bba0:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
8000bba2:	47b2                	lw	a5,12(sp)
8000bba4:	0027e793          	or	a5,a5,2
8000bba8:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
8000bbaa:	47b2                	lw	a5,12(sp)
8000bbac:	0017e793          	or	a5,a5,1
8000bbb0:	c63e                	sw	a5,12(sp)
8000bbb2:	e40007b7          	lui	a5,0xe4000
8000bbb6:	c43e                	sw	a5,8(sp)
8000bbb8:	47b2                	lw	a5,12(sp)
8000bbba:	c23e                	sw	a5,4(sp)

8000bbbc <.LBB14>:
 * @param[in] feature Specific feature to be set
 *
 */
ATTR_ALWAYS_INLINE static inline void __plic_set_feature(uint32_t base, uint32_t feature)
{
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
8000bbbc:	47a2                	lw	a5,8(sp)
8000bbbe:	4712                	lw	a4,4(sp)
8000bbc0:	c398                	sw	a4,0(a5)
}
8000bbc2:	0001                	nop

8000bbc4 <.LBE14>:
}
8000bbc4:	0001                	nop
8000bbc6:	0141                	add	sp,sp,16
8000bbc8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

8000bbca <__SEGGER_RTL_puts_no_nl>:
8000bbca:	1101                	add	sp,sp,-32
8000bbcc:	cc22                	sw	s0,24(sp)
8000bbce:	c0c22403          	lw	s0,-1012(tp) # fffffc0c <__APB_SRAM_segment_end__+0xbf0dc0c>
8000bbd2:	ce06                	sw	ra,28(sp)
8000bbd4:	c62a                	sw	a0,12(sp)
8000bbd6:	3a5000ef          	jal	8000c77a <strlen>
8000bbda:	862a                	mv	a2,a0
8000bbdc:	8522                	mv	a0,s0
8000bbde:	4462                	lw	s0,24(sp)
8000bbe0:	45b2                	lw	a1,12(sp)
8000bbe2:	40f2                	lw	ra,28(sp)
8000bbe4:	6105                	add	sp,sp,32
8000bbe6:	9e6fd06f          	j	80008dcc <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.signal:

8000bbea <signal>:
8000bbea:	4795                	li	a5,5
8000bbec:	02a7e263          	bltu	a5,a0,8000bc10 <.L18>
8000bbf0:	bac20693          	add	a3,tp,-1108 # fffffbac <__APB_SRAM_segment_end__+0xbf0dbac>
8000bbf4:	00251793          	sll	a5,a0,0x2
8000bbf8:	96be                	add	a3,a3,a5
8000bbfa:	4288                	lw	a0,0(a3)
8000bbfc:	bac20713          	add	a4,tp,-1108 # fffffbac <__APB_SRAM_segment_end__+0xbf0dbac>
8000bc00:	e509                	bnez	a0,8000bc0a <.L17>
8000bc02:	80003537          	lui	a0,0x80003
8000bc06:	07a50513          	add	a0,a0,122 # 8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>

8000bc0a <.L17>:
8000bc0a:	973e                	add	a4,a4,a5
8000bc0c:	c30c                	sw	a1,0(a4)
8000bc0e:	8082                	ret

8000bc10 <.L18>:
8000bc10:	80004537          	lui	a0,0x80004
8000bc14:	65650513          	add	a0,a0,1622 # 80004656 <__SEGGER_RTL_SIGNAL_SIG_ERR>
8000bc18:	8082                	ret

Disassembly of section .text.libc.raise:

8000bc1a <raise>:
8000bc1a:	1141                	add	sp,sp,-16
8000bc1c:	c04a                	sw	s2,0(sp)
8000bc1e:	80004937          	lui	s2,0x80004
8000bc22:	61e90593          	add	a1,s2,1566 # 8000461e <__SEGGER_RTL_SIGNAL_SIG_IGN>
8000bc26:	c226                	sw	s1,4(sp)
8000bc28:	c606                	sw	ra,12(sp)
8000bc2a:	c422                	sw	s0,8(sp)
8000bc2c:	84aa                	mv	s1,a0
8000bc2e:	3f75                	jal	8000bbea <signal>
8000bc30:	800047b7          	lui	a5,0x80004
8000bc34:	65678793          	add	a5,a5,1622 # 80004656 <__SEGGER_RTL_SIGNAL_SIG_ERR>
8000bc38:	02f50d63          	beq	a0,a5,8000bc72 <.L24>
8000bc3c:	61e90913          	add	s2,s2,1566
8000bc40:	842a                	mv	s0,a0
8000bc42:	03250163          	beq	a0,s2,8000bc64 <.L22>
8000bc46:	800035b7          	lui	a1,0x80003
8000bc4a:	07a58793          	add	a5,a1,122 # 8000307a <__SEGGER_RTL_SIGNAL_SIG_DFL>
8000bc4e:	00f51563          	bne	a0,a5,8000bc58 <.L23>
8000bc52:	4505                	li	a0,1
8000bc54:	c1af70ef          	jal	8000306e <exit>

8000bc58 <.L23>:
8000bc58:	07a58593          	add	a1,a1,122
8000bc5c:	8526                	mv	a0,s1
8000bc5e:	3771                	jal	8000bbea <signal>
8000bc60:	8526                	mv	a0,s1
8000bc62:	9402                	jalr	s0

8000bc64 <.L22>:
8000bc64:	4501                	li	a0,0

8000bc66 <.L20>:
8000bc66:	40b2                	lw	ra,12(sp)
8000bc68:	4422                	lw	s0,8(sp)
8000bc6a:	4492                	lw	s1,4(sp)
8000bc6c:	4902                	lw	s2,0(sp)
8000bc6e:	0141                	add	sp,sp,16
8000bc70:	8082                	ret

8000bc72 <.L24>:
8000bc72:	557d                	li	a0,-1
8000bc74:	bfcd                	j	8000bc66 <.L20>

Disassembly of section .text.libc.abort:

8000bc76 <abort>:
8000bc76:	1141                	add	sp,sp,-16
8000bc78:	c606                	sw	ra,12(sp)

8000bc7a <.L27>:
8000bc7a:	4501                	li	a0,0
8000bc7c:	3f79                	jal	8000bc1a <raise>
8000bc7e:	bff5                	j	8000bc7a <.L27>

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

8000bc80 <__SEGGER_RTL_X_assert>:
8000bc80:	1101                	add	sp,sp,-32
8000bc82:	cc22                	sw	s0,24(sp)
8000bc84:	ca26                	sw	s1,20(sp)
8000bc86:	842a                	mv	s0,a0
8000bc88:	84ae                	mv	s1,a1
8000bc8a:	8532                	mv	a0,a2
8000bc8c:	858a                	mv	a1,sp
8000bc8e:	4629                	li	a2,10
8000bc90:	ce06                	sw	ra,28(sp)
8000bc92:	ed3fb0ef          	jal	80007b64 <itoa>
8000bc96:	8526                	mv	a0,s1
8000bc98:	3f0d                	jal	8000bbca <__SEGGER_RTL_puts_no_nl>
8000bc9a:	80004537          	lui	a0,0x80004
8000bc9e:	62050513          	add	a0,a0,1568 # 80004620 <.LC0>
8000bca2:	3725                	jal	8000bbca <__SEGGER_RTL_puts_no_nl>
8000bca4:	850a                	mv	a0,sp
8000bca6:	3715                	jal	8000bbca <__SEGGER_RTL_puts_no_nl>
8000bca8:	80004537          	lui	a0,0x80004
8000bcac:	62450513          	add	a0,a0,1572 # 80004624 <.LC1>
8000bcb0:	3f29                	jal	8000bbca <__SEGGER_RTL_puts_no_nl>
8000bcb2:	8522                	mv	a0,s0
8000bcb4:	3f19                	jal	8000bbca <__SEGGER_RTL_puts_no_nl>
8000bcb6:	80004537          	lui	a0,0x80004
8000bcba:	63c50513          	add	a0,a0,1596 # 8000463c <.LC2>
8000bcbe:	3731                	jal	8000bbca <__SEGGER_RTL_puts_no_nl>
8000bcc0:	3f5d                	jal	8000bc76 <abort>

Disassembly of section .text.libc.__adddf3:

8000bcc2 <__adddf3>:
8000bcc2:	800007b7          	lui	a5,0x80000
8000bcc6:	00d5c8b3          	xor	a7,a1,a3
8000bcca:	1008c263          	bltz	a7,8000bdce <.L__adddf3_subtract>
8000bcce:	00b6e863          	bltu	a3,a1,8000bcde <.L__adddf3_add_already_ordered>
8000bcd2:	8d31                	xor	a0,a0,a2
8000bcd4:	8e29                	xor	a2,a2,a0
8000bcd6:	8d31                	xor	a0,a0,a2
8000bcd8:	8db5                	xor	a1,a1,a3
8000bcda:	8ead                	xor	a3,a3,a1
8000bcdc:	8db5                	xor	a1,a1,a3

8000bcde <.L__adddf3_add_already_ordered>:
8000bcde:	00159813          	sll	a6,a1,0x1
8000bce2:	01585813          	srl	a6,a6,0x15
8000bce6:	00169893          	sll	a7,a3,0x1
8000bcea:	0158d893          	srl	a7,a7,0x15
8000bcee:	0c088063          	beqz	a7,8000bdae <.L__adddf3_add_zero>
8000bcf2:	00180713          	add	a4,a6,1
8000bcf6:	0756                	sll	a4,a4,0x15
8000bcf8:	c759                	beqz	a4,8000bd86 <.L__adddf3_done>
8000bcfa:	41180733          	sub	a4,a6,a7
8000bcfe:	03500293          	li	t0,53
8000bd02:	08e2e263          	bltu	t0,a4,8000bd86 <.L__adddf3_done>
8000bd06:	0145d813          	srl	a6,a1,0x14
8000bd0a:	06ae                	sll	a3,a3,0xb
8000bd0c:	8edd                	or	a3,a3,a5
8000bd0e:	82ad                	srl	a3,a3,0xb
8000bd10:	05ae                	sll	a1,a1,0xb
8000bd12:	8ddd                	or	a1,a1,a5
8000bd14:	85ad                	sra	a1,a1,0xb
8000bd16:	02000293          	li	t0,32
8000bd1a:	06577763          	bgeu	a4,t0,8000bd88 <.L__adddf3_add_shifted_word>
8000bd1e:	4881                	li	a7,0
8000bd20:	cf01                	beqz	a4,8000bd38 <.L__adddf3_add_no_shift>
8000bd22:	40e002b3          	neg	t0,a4
8000bd26:	005618b3          	sll	a7,a2,t0
8000bd2a:	00e65633          	srl	a2,a2,a4
8000bd2e:	005692b3          	sll	t0,a3,t0
8000bd32:	9616                	add	a2,a2,t0
8000bd34:	00e6d6b3          	srl	a3,a3,a4

8000bd38 <.L__adddf3_add_no_shift>:
8000bd38:	9532                	add	a0,a0,a2
8000bd3a:	00c532b3          	sltu	t0,a0,a2
8000bd3e:	95b6                	add	a1,a1,a3
8000bd40:	00d5b333          	sltu	t1,a1,a3
8000bd44:	9596                	add	a1,a1,t0
8000bd46:	00031463          	bnez	t1,8000bd4e <.L__adddf3_normalization_required>
8000bd4a:	0255f163          	bgeu	a1,t0,8000bd6c <.L__adddf3_already_normalized>

8000bd4e <.L__adddf3_normalization_required>:
8000bd4e:	00280613          	add	a2,a6,2
8000bd52:	0656                	sll	a2,a2,0x15
8000bd54:	c235                	beqz	a2,8000bdb8 <.L__adddf3_inf>
8000bd56:	01f51613          	sll	a2,a0,0x1f
8000bd5a:	011032b3          	snez	t0,a7
8000bd5e:	005608b3          	add	a7,a2,t0
8000bd62:	8105                	srl	a0,a0,0x1
8000bd64:	01f59693          	sll	a3,a1,0x1f
8000bd68:	8d55                	or	a0,a0,a3
8000bd6a:	8185                	srl	a1,a1,0x1

8000bd6c <.L__adddf3_already_normalized>:
8000bd6c:	0805                	add	a6,a6,1
8000bd6e:	0852                	sll	a6,a6,0x14

8000bd70 <.L__adddf3_perform_rounding>:
8000bd70:	0008da63          	bgez	a7,8000bd84 <.L__adddf3_add_no_tie>
8000bd74:	0505                	add	a0,a0,1
8000bd76:	00153293          	seqz	t0,a0
8000bd7a:	9596                	add	a1,a1,t0
8000bd7c:	0886                	sll	a7,a7,0x1
8000bd7e:	00089363          	bnez	a7,8000bd84 <.L__adddf3_add_no_tie>
8000bd82:	9979                	and	a0,a0,-2

8000bd84 <.L__adddf3_add_no_tie>:
8000bd84:	95c2                	add	a1,a1,a6

8000bd86 <.L__adddf3_done>:
8000bd86:	8082                	ret

8000bd88 <.L__adddf3_add_shifted_word>:
8000bd88:	88b2                	mv	a7,a2
8000bd8a:	1701                	add	a4,a4,-32 # f3ffffe0 <__AHB_SRAM_segment_end__+0x3cf7fe0>
8000bd8c:	cb11                	beqz	a4,8000bda0 <.L__adddf3_already_aligned>
8000bd8e:	40e008b3          	neg	a7,a4
8000bd92:	011698b3          	sll	a7,a3,a7
8000bd96:	00e6d6b3          	srl	a3,a3,a4
8000bd9a:	00c03733          	snez	a4,a2
8000bd9e:	98ba                	add	a7,a7,a4

8000bda0 <.L__adddf3_already_aligned>:
8000bda0:	9536                	add	a0,a0,a3
8000bda2:	00d532b3          	sltu	t0,a0,a3
8000bda6:	9596                	add	a1,a1,t0
8000bda8:	fc55f2e3          	bgeu	a1,t0,8000bd6c <.L__adddf3_already_normalized>
8000bdac:	b74d                	j	8000bd4e <.L__adddf3_normalization_required>

8000bdae <.L__adddf3_add_zero>:
8000bdae:	fc081ce3          	bnez	a6,8000bd86 <.L__adddf3_done>
8000bdb2:	8dfd                	and	a1,a1,a5
8000bdb4:	4501                	li	a0,0
8000bdb6:	bfc1                	j	8000bd86 <.L__adddf3_done>

8000bdb8 <.L__adddf3_inf>:
8000bdb8:	0805                	add	a6,a6,1
8000bdba:	01481593          	sll	a1,a6,0x14
8000bdbe:	4501                	li	a0,0
8000bdc0:	b7d9                	j	8000bd86 <.L__adddf3_done>

8000bdc2 <.L__adddf3_sub_inf_nan>:
8000bdc2:	fce892e3          	bne	a7,a4,8000bd86 <.L__adddf3_done>
8000bdc6:	7ff805b7          	lui	a1,0x7ff80
8000bdca:	4501                	li	a0,0
8000bdcc:	bf6d                	j	8000bd86 <.L__adddf3_done>

8000bdce <.L__adddf3_subtract>:
8000bdce:	8ebd                	xor	a3,a3,a5
8000bdd0:	00b6ed63          	bltu	a3,a1,8000bdea <.L__adddf3_sub_already_ordered>
8000bdd4:	00b69463          	bne	a3,a1,8000bddc <.L__adddf3_sub_must_exchange>
8000bdd8:	00a66963          	bltu	a2,a0,8000bdea <.L__adddf3_sub_already_ordered>

8000bddc <.L__adddf3_sub_must_exchange>:
8000bddc:	8ebd                	xor	a3,a3,a5
8000bdde:	8d31                	xor	a0,a0,a2
8000bde0:	8e29                	xor	a2,a2,a0
8000bde2:	8d31                	xor	a0,a0,a2
8000bde4:	8db5                	xor	a1,a1,a3
8000bde6:	8ead                	xor	a3,a3,a1
8000bde8:	8db5                	xor	a1,a1,a3

8000bdea <.L__adddf3_sub_already_ordered>:
8000bdea:	00b58833          	add	a6,a1,a1
8000bdee:	00d688b3          	add	a7,a3,a3
8000bdf2:	ffe00737          	lui	a4,0xffe00
8000bdf6:	fce876e3          	bgeu	a6,a4,8000bdc2 <.L__adddf3_sub_inf_nan>
8000bdfa:	01585813          	srl	a6,a6,0x15
8000bdfe:	0158d893          	srl	a7,a7,0x15
8000be02:	0a088f63          	beqz	a7,8000bec0 <.L__adddf3_subtracting_zero>
8000be06:	41180733          	sub	a4,a6,a7
8000be0a:	03600293          	li	t0,54
8000be0e:	f6e2ece3          	bltu	t0,a4,8000bd86 <.L__adddf3_done>
8000be12:	83c2                	mv	t2,a6
8000be14:	0145d813          	srl	a6,a1,0x14
8000be18:	06ae                	sll	a3,a3,0xb
8000be1a:	8edd                	or	a3,a3,a5
8000be1c:	82ad                	srl	a3,a3,0xb
8000be1e:	05ae                	sll	a1,a1,0xb
8000be20:	8ddd                	or	a1,a1,a5
8000be22:	81ad                	srl	a1,a1,0xb
8000be24:	4285                	li	t0,1
8000be26:	0ae2ef63          	bltu	t0,a4,8000bee4 <.L__adddf3_sub_align_far>
8000be2a:	00571a63          	bne	a4,t0,8000be3e <.L__adddf3_sub_already_aligned>
8000be2e:	01f61713          	sll	a4,a2,0x1f
8000be32:	8205                	srl	a2,a2,0x1
8000be34:	01f69893          	sll	a7,a3,0x1f
8000be38:	01166633          	or	a2,a2,a7
8000be3c:	8285                	srl	a3,a3,0x1

8000be3e <.L__adddf3_sub_already_aligned>:
8000be3e:	82aa                	mv	t0,a0
8000be40:	8d11                	sub	a0,a0,a2
8000be42:	00a2b2b3          	sltu	t0,t0,a0
8000be46:	8d95                	sub	a1,a1,a3
8000be48:	405585b3          	sub	a1,a1,t0
8000be4c:	c711                	beqz	a4,8000be58 <.L__adddf3_sub_single_done>
8000be4e:	00153293          	seqz	t0,a0
8000be52:	157d                	add	a0,a0,-1
8000be54:	405585b3          	sub	a1,a1,t0

8000be58 <.L__adddf3_sub_single_done>:
8000be58:	c9ad                	beqz	a1,8000beca <.L__adddf3_high_word_cancelled>
8000be5a:	00b59293          	sll	t0,a1,0xb
8000be5e:	1202ca63          	bltz	t0,8000bf92 <.L__adddf3_sub_normalized>

8000be62 <.L__adddf3_first_normalization_step>:
8000be62:	000522b3          	sltz	t0,a0
8000be66:	952a                	add	a0,a0,a0
8000be68:	95ae                	add	a1,a1,a1
8000be6a:	9596                	add	a1,a1,t0
8000be6c:	837d                	srl	a4,a4,0x1f
8000be6e:	953a                	add	a0,a0,a4
8000be70:	4705                	li	a4,1

8000be72 <.L__adddf3_try_shift_4>:
8000be72:	0115d293          	srl	t0,a1,0x11
8000be76:	00029963          	bnez	t0,8000be88 <.L__adddf3_cant_shift_4>
8000be7a:	0711                	add	a4,a4,4 # ffe00004 <__APB_SRAM_segment_end__+0xbd0e004>
8000be7c:	0592                	sll	a1,a1,0x4
8000be7e:	01c55293          	srl	t0,a0,0x1c
8000be82:	0512                	sll	a0,a0,0x4
8000be84:	9596                	add	a1,a1,t0
8000be86:	b7f5                	j	8000be72 <.L__adddf3_try_shift_4>

8000be88 <.L__adddf3_cant_shift_4>:
8000be88:	00b59293          	sll	t0,a1,0xb
8000be8c:	0002cc63          	bltz	t0,8000bea4 <.L__adddf3_normalized>

8000be90 <.L__adddf3_normalize>:
8000be90:	0705                	add	a4,a4,1
8000be92:	000522b3          	sltz	t0,a0
8000be96:	952a                	add	a0,a0,a0
8000be98:	95ae                	add	a1,a1,a1
8000be9a:	9596                	add	a1,a1,t0

8000be9c <.L__adddf3_pre_normalize>:
8000be9c:	00b59293          	sll	t0,a1,0xb
8000bea0:	fe02d8e3          	bgez	t0,8000be90 <.L__adddf3_normalize>

8000bea4 <.L__adddf3_normalized>:
8000bea4:	861e                	mv	a2,t2
8000bea6:	00c77863          	bgeu	a4,a2,8000beb6 <.L__adddf3_signed_zero>
8000beaa:	40e80833          	sub	a6,a6,a4
8000beae:	187d                	add	a6,a6,-1
8000beb0:	0852                	sll	a6,a6,0x14
8000beb2:	95c2                	add	a1,a1,a6
8000beb4:	bdc9                	j	8000bd86 <.L__adddf3_done>

8000beb6 <.L__adddf3_signed_zero>:
8000beb6:	00b85593          	srl	a1,a6,0xb
8000beba:	05fe                	sll	a1,a1,0x1f
8000bebc:	4501                	li	a0,0
8000bebe:	b5e1                	j	8000bd86 <.L__adddf3_done>

8000bec0 <.L__adddf3_subtracting_zero>:
8000bec0:	ec0813e3          	bnez	a6,8000bd86 <.L__adddf3_done>
8000bec4:	4501                	li	a0,0
8000bec6:	4581                	li	a1,0
8000bec8:	bd7d                	j	8000bd86 <.L__adddf3_done>

8000beca <.L__adddf3_high_word_cancelled>:
8000beca:	00e56633          	or	a2,a0,a4
8000bece:	ea060ce3          	beqz	a2,8000bd86 <.L__adddf3_done>
8000bed2:	001008b7          	lui	a7,0x100
8000bed6:	f91576e3          	bgeu	a0,a7,8000be62 <.L__adddf3_first_normalization_step>
8000beda:	85aa                	mv	a1,a0
8000bedc:	853a                	mv	a0,a4
8000bede:	02000713          	li	a4,32
8000bee2:	bf6d                	j	8000be9c <.L__adddf3_pre_normalize>

8000bee4 <.L__adddf3_sub_align_far>:
8000bee4:	02000293          	li	t0,32
8000bee8:	04574863          	blt	a4,t0,8000bf38 <.L__adddf3_aligned_on_top>
8000beec:	04570263          	beq	a4,t0,8000bf30 <.L__adddf3_word_aligned_on_top>
8000bef0:	1701                	add	a4,a4,-32
8000bef2:	40e002b3          	neg	t0,a4
8000bef6:	00e65333          	srl	t1,a2,a4
8000befa:	005618b3          	sll	a7,a2,t0
8000befe:	00569633          	sll	a2,a3,t0
8000bf02:	961a                	add	a2,a2,t1
8000bf04:	00e6d6b3          	srl	a3,a3,a4
8000bf08:	011038b3          	snez	a7,a7
8000bf0c:	00c8e8b3          	or	a7,a7,a2
8000bf10:	4601                	li	a2,0
8000bf12:	82aa                	mv	t0,a0
8000bf14:	8d15                	sub	a0,a0,a3
8000bf16:	00a2b2b3          	sltu	t0,t0,a0
8000bf1a:	405585b3          	sub	a1,a1,t0
8000bf1e:	41100733          	neg	a4,a7
8000bf22:	c729                	beqz	a4,8000bf6c <.L__adddf3_sub_normalize>
8000bf24:	00153293          	seqz	t0,a0
8000bf28:	157d                	add	a0,a0,-1
8000bf2a:	405585b3          	sub	a1,a1,t0
8000bf2e:	a83d                	j	8000bf6c <.L__adddf3_sub_normalize>

8000bf30 <.L__adddf3_word_aligned_on_top>:
8000bf30:	88b2                	mv	a7,a2
8000bf32:	8636                	mv	a2,a3
8000bf34:	4681                	li	a3,0
8000bf36:	a821                	j	8000bf4e <.L__adddf3_aligned_subtract>

8000bf38 <.L__adddf3_aligned_on_top>:
8000bf38:	40e002b3          	neg	t0,a4
8000bf3c:	00e65333          	srl	t1,a2,a4
8000bf40:	005618b3          	sll	a7,a2,t0
8000bf44:	00569633          	sll	a2,a3,t0
8000bf48:	961a                	add	a2,a2,t1
8000bf4a:	00e6d6b3          	srl	a3,a3,a4

8000bf4e <.L__adddf3_aligned_subtract>:
8000bf4e:	82aa                	mv	t0,a0
8000bf50:	8d11                	sub	a0,a0,a2
8000bf52:	00a2b2b3          	sltu	t0,t0,a0
8000bf56:	8d95                	sub	a1,a1,a3
8000bf58:	405585b3          	sub	a1,a1,t0
8000bf5c:	41100733          	neg	a4,a7
8000bf60:	c711                	beqz	a4,8000bf6c <.L__adddf3_sub_normalize>
8000bf62:	00153293          	seqz	t0,a0
8000bf66:	157d                	add	a0,a0,-1
8000bf68:	405585b3          	sub	a1,a1,t0

8000bf6c <.L__adddf3_sub_normalize>:
8000bf6c:	00c59893          	sll	a7,a1,0xc
8000bf70:	00b59293          	sll	t0,a1,0xb
8000bf74:	0002cf63          	bltz	t0,8000bf92 <.L__adddf3_sub_normalized>
8000bf78:	187d                	add	a6,a6,-1
8000bf7a:	000522b3          	sltz	t0,a0
8000bf7e:	952a                	add	a0,a0,a0
8000bf80:	95ae                	add	a1,a1,a1
8000bf82:	9596                	add	a1,a1,t0
8000bf84:	000722b3          	sltz	t0,a4
8000bf88:	973a                	add	a4,a4,a4
8000bf8a:	9516                	add	a0,a0,t0
8000bf8c:	005532b3          	sltu	t0,a0,t0
8000bf90:	9596                	add	a1,a1,t0

8000bf92 <.L__adddf3_sub_normalized>:
8000bf92:	187d                	add	a6,a6,-1
8000bf94:	0852                	sll	a6,a6,0x14
8000bf96:	88ba                	mv	a7,a4
8000bf98:	bbe1                	j	8000bd70 <.L__adddf3_perform_rounding>

Disassembly of section .text.libc.__mulsf3:

8000bf9a <__mulsf3>:
8000bf9a:	80000737          	lui	a4,0x80000
8000bf9e:	0ff00293          	li	t0,255
8000bfa2:	00b547b3          	xor	a5,a0,a1
8000bfa6:	8ff9                	and	a5,a5,a4
8000bfa8:	00151613          	sll	a2,a0,0x1
8000bfac:	8261                	srl	a2,a2,0x18
8000bfae:	00159693          	sll	a3,a1,0x1
8000bfb2:	82e1                	srl	a3,a3,0x18
8000bfb4:	ce29                	beqz	a2,8000c00e <.L__mulsf3_lhs_zero_or_subnormal>
8000bfb6:	c6bd                	beqz	a3,8000c024 <.L__mulsf3_rhs_zero_or_subnormal>
8000bfb8:	04560f63          	beq	a2,t0,8000c016 <.L__mulsf3_lhs_inf_or_nan>
8000bfbc:	06568963          	beq	a3,t0,8000c02e <.L__mulsf3_rhs_inf_or_nan>
8000bfc0:	9636                	add	a2,a2,a3
8000bfc2:	0522                	sll	a0,a0,0x8
8000bfc4:	8d59                	or	a0,a0,a4
8000bfc6:	05a2                	sll	a1,a1,0x8
8000bfc8:	8dd9                	or	a1,a1,a4
8000bfca:	02b506b3          	mul	a3,a0,a1
8000bfce:	02b53533          	mulhu	a0,a0,a1
8000bfd2:	00d036b3          	snez	a3,a3
8000bfd6:	8d55                	or	a0,a0,a3
8000bfd8:	00054463          	bltz	a0,8000bfe0 <.L__mulsf3_normalized>
8000bfdc:	0506                	sll	a0,a0,0x1
8000bfde:	167d                	add	a2,a2,-1

8000bfe0 <.L__mulsf3_normalized>:
8000bfe0:	f8160613          	add	a2,a2,-127
8000bfe4:	04064863          	bltz	a2,8000c034 <.L__mulsf3_zero_or_underflow>
8000bfe8:	12fd                	add	t0,t0,-1 # ffffffff <__APB_SRAM_segment_end__+0xbf0dfff>
8000bfea:	00565f63          	bge	a2,t0,8000c008 <.L__mulsf3_inf>
8000bfee:	01851693          	sll	a3,a0,0x18
8000bff2:	8121                	srl	a0,a0,0x8
8000bff4:	065e                	sll	a2,a2,0x17
8000bff6:	9532                	add	a0,a0,a2
8000bff8:	0006d663          	bgez	a3,8000c004 <.L__mulsf3_apply_sign>
8000bffc:	0505                	add	a0,a0,1
8000bffe:	0686                	sll	a3,a3,0x1
8000c000:	e291                	bnez	a3,8000c004 <.L__mulsf3_apply_sign>
8000c002:	9979                	and	a0,a0,-2

8000c004 <.L__mulsf3_apply_sign>:
8000c004:	8d5d                	or	a0,a0,a5
8000c006:	8082                	ret

8000c008 <.L__mulsf3_inf>:
8000c008:	7f800537          	lui	a0,0x7f800
8000c00c:	bfe5                	j	8000c004 <.L__mulsf3_apply_sign>

8000c00e <.L__mulsf3_lhs_zero_or_subnormal>:
8000c00e:	00568d63          	beq	a3,t0,8000c028 <.L__mulsf3_nan>

8000c012 <.L__mulsf3_signed_zero>:
8000c012:	853e                	mv	a0,a5
8000c014:	8082                	ret

8000c016 <.L__mulsf3_lhs_inf_or_nan>:
8000c016:	0526                	sll	a0,a0,0x9
8000c018:	e901                	bnez	a0,8000c028 <.L__mulsf3_nan>
8000c01a:	fe5697e3          	bne	a3,t0,8000c008 <.L__mulsf3_inf>
8000c01e:	05a6                	sll	a1,a1,0x9
8000c020:	e581                	bnez	a1,8000c028 <.L__mulsf3_nan>
8000c022:	b7dd                	j	8000c008 <.L__mulsf3_inf>

8000c024 <.L__mulsf3_rhs_zero_or_subnormal>:
8000c024:	fe5617e3          	bne	a2,t0,8000c012 <.L__mulsf3_signed_zero>

8000c028 <.L__mulsf3_nan>:
8000c028:	7fc00537          	lui	a0,0x7fc00
8000c02c:	8082                	ret

8000c02e <.L__mulsf3_rhs_inf_or_nan>:
8000c02e:	05a6                	sll	a1,a1,0x9
8000c030:	fde5                	bnez	a1,8000c028 <.L__mulsf3_nan>
8000c032:	bfd9                	j	8000c008 <.L__mulsf3_inf>

8000c034 <.L__mulsf3_zero_or_underflow>:
8000c034:	0605                	add	a2,a2,1
8000c036:	fe71                	bnez	a2,8000c012 <.L__mulsf3_signed_zero>
8000c038:	8521                	sra	a0,a0,0x8
8000c03a:	00150293          	add	t0,a0,1 # 7fc00001 <_extram_size+0x7dc00001>
8000c03e:	0509                	add	a0,a0,2
8000c040:	fc0299e3          	bnez	t0,8000c012 <.L__mulsf3_signed_zero>
8000c044:	00800537          	lui	a0,0x800
8000c048:	bf75                	j	8000c004 <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__muldf3:

8000c04a <__muldf3>:
8000c04a:	800008b7          	lui	a7,0x80000
8000c04e:	00d5c833          	xor	a6,a1,a3
8000c052:	01187eb3          	and	t4,a6,a7
8000c056:	00b58733          	add	a4,a1,a1
8000c05a:	00d687b3          	add	a5,a3,a3
8000c05e:	ffe00837          	lui	a6,0xffe00
8000c062:	0d077363          	bgeu	a4,a6,8000c128 <.L__muldf3_lhs_nan_or_inf>
8000c066:	0d07ff63          	bgeu	a5,a6,8000c144 <.L__muldf3_rhs_nan_or_inf>
8000c06a:	8355                	srl	a4,a4,0x15
8000c06c:	c76d                	beqz	a4,8000c156 <.L__muldf3_signed_zero>
8000c06e:	83d5                	srl	a5,a5,0x15
8000c070:	c3fd                	beqz	a5,8000c156 <.L__muldf3_signed_zero>
8000c072:	06ae                	sll	a3,a3,0xb
8000c074:	0116e6b3          	or	a3,a3,a7
8000c078:	82ad                	srl	a3,a3,0xb
8000c07a:	05ae                	sll	a1,a1,0xb
8000c07c:	0115e5b3          	or	a1,a1,a7
8000c080:	01555813          	srl	a6,a0,0x15
8000c084:	052e                	sll	a0,a0,0xb
8000c086:	010582b3          	add	t0,a1,a6
8000c08a:	00f70333          	add	t1,a4,a5
8000c08e:	02c50733          	mul	a4,a0,a2
8000c092:	02c537b3          	mulhu	a5,a0,a2
8000c096:	02d50833          	mul	a6,a0,a3
8000c09a:	02d538b3          	mulhu	a7,a0,a3
8000c09e:	983e                	add	a6,a6,a5
8000c0a0:	00f837b3          	sltu	a5,a6,a5
8000c0a4:	98be                	add	a7,a7,a5
8000c0a6:	02c28533          	mul	a0,t0,a2
8000c0aa:	02c2b5b3          	mulhu	a1,t0,a2
8000c0ae:	982a                	add	a6,a6,a0
8000c0b0:	00a83533          	sltu	a0,a6,a0
8000c0b4:	98ae                	add	a7,a7,a1
8000c0b6:	00b8b5b3          	sltu	a1,a7,a1
8000c0ba:	98aa                	add	a7,a7,a0
8000c0bc:	00a8b533          	sltu	a0,a7,a0
8000c0c0:	00b50633          	add	a2,a0,a1
8000c0c4:	02d28533          	mul	a0,t0,a3
8000c0c8:	02d2b5b3          	mulhu	a1,t0,a3
8000c0cc:	9546                	add	a0,a0,a7
8000c0ce:	011538b3          	sltu	a7,a0,a7
8000c0d2:	95c6                	add	a1,a1,a7
8000c0d4:	95b2                	add	a1,a1,a2
8000c0d6:	00e03733          	snez	a4,a4
8000c0da:	00e86833          	or	a6,a6,a4
8000c0de:	871a                	mv	a4,t1
8000c0e0:	00b59293          	sll	t0,a1,0xb
8000c0e4:	0002cc63          	bltz	t0,8000c0fc <.L__muldf3_normalized>
8000c0e8:	000822b3          	sltz	t0,a6
8000c0ec:	9842                	add	a6,a6,a6
8000c0ee:	00052333          	sltz	t1,a0
8000c0f2:	952a                	add	a0,a0,a0
8000c0f4:	9516                	add	a0,a0,t0
8000c0f6:	95ae                	add	a1,a1,a1
8000c0f8:	959a                	add	a1,a1,t1
8000c0fa:	177d                	add	a4,a4,-1 # 7fffffff <_extram_size+0x7dffffff>

8000c0fc <.L__muldf3_normalized>:
8000c0fc:	3ff00793          	li	a5,1023
8000c100:	8f1d                	sub	a4,a4,a5
8000c102:	04074a63          	bltz	a4,8000c156 <.L__muldf3_signed_zero>
8000c106:	0786                	sll	a5,a5,0x1
8000c108:	04f75363          	bge	a4,a5,8000c14e <.L__muldf3_inf>
8000c10c:	0752                	sll	a4,a4,0x14
8000c10e:	95ba                	add	a1,a1,a4
8000c110:	00085a63          	bgez	a6,8000c124 <.L__muldf3_apply_sign>
8000c114:	0505                	add	a0,a0,1 # 800001 <__DLM_segment_end__+0x740001>
8000c116:	00153613          	seqz	a2,a0
8000c11a:	95b2                	add	a1,a1,a2
8000c11c:	0806                	sll	a6,a6,0x1
8000c11e:	00081363          	bnez	a6,8000c124 <.L__muldf3_apply_sign>
8000c122:	9979                	and	a0,a0,-2

8000c124 <.L__muldf3_apply_sign>:
8000c124:	95f6                	add	a1,a1,t4
8000c126:	8082                	ret

8000c128 <.L__muldf3_lhs_nan_or_inf>:
8000c128:	01071a63          	bne	a4,a6,8000c13c <.L__muldf3_nan>
8000c12c:	e901                	bnez	a0,8000c13c <.L__muldf3_nan>
8000c12e:	00f86763          	bltu	a6,a5,8000c13c <.L__muldf3_nan>
8000c132:	0107e363          	bltu	a5,a6,8000c138 <.L__muldf3_rhs_could_be_zero>
8000c136:	e219                	bnez	a2,8000c13c <.L__muldf3_nan>

8000c138 <.L__muldf3_rhs_could_be_zero>:
8000c138:	83d5                	srl	a5,a5,0x15
8000c13a:	eb91                	bnez	a5,8000c14e <.L__muldf3_inf>

8000c13c <.L__muldf3_nan>:
8000c13c:	7ff805b7          	lui	a1,0x7ff80

8000c140 <.L__muldf3_load_zero_lo>:
8000c140:	4501                	li	a0,0
8000c142:	8082                	ret

8000c144 <.L__muldf3_rhs_nan_or_inf>:
8000c144:	ff079ce3          	bne	a5,a6,8000c13c <.L__muldf3_nan>
8000c148:	fa75                	bnez	a2,8000c13c <.L__muldf3_nan>
8000c14a:	8355                	srl	a4,a4,0x15
8000c14c:	db65                	beqz	a4,8000c13c <.L__muldf3_nan>

8000c14e <.L__muldf3_inf>:
8000c14e:	7ff005b7          	lui	a1,0x7ff00
8000c152:	4501                	li	a0,0
8000c154:	bfc1                	j	8000c124 <.L__muldf3_apply_sign>

8000c156 <.L__muldf3_signed_zero>:
8000c156:	85f6                	mv	a1,t4
8000c158:	b7e5                	j	8000c140 <.L__muldf3_load_zero_lo>

Disassembly of section .text.libc.__divsf3:

8000c15a <__divsf3>:
8000c15a:	0ff00293          	li	t0,255
8000c15e:	00151713          	sll	a4,a0,0x1
8000c162:	8361                	srl	a4,a4,0x18
8000c164:	00159793          	sll	a5,a1,0x1
8000c168:	83e1                	srl	a5,a5,0x18
8000c16a:	00b54333          	xor	t1,a0,a1
8000c16e:	01f35313          	srl	t1,t1,0x1f
8000c172:	037e                	sll	t1,t1,0x1f
8000c174:	cf5d                	beqz	a4,8000c232 <.L__divsf3_lhs_zero_or_subnormal>
8000c176:	cbf9                	beqz	a5,8000c24c <.L__divsf3_rhs_zero_or_subnormal>
8000c178:	0c570563          	beq	a4,t0,8000c242 <.L__divsf3_lhs_inf_or_nan>
8000c17c:	0c578d63          	beq	a5,t0,8000c256 <.L__divsf3_rhs_inf_or_nan>
8000c180:	8f1d                	sub	a4,a4,a5
8000c182:	800042b7          	lui	t0,0x80004
8000c186:	92028293          	add	t0,t0,-1760 # 80003920 <__SEGGER_RTL_fdiv_reciprocal_table>
8000c18a:	00f5d693          	srl	a3,a1,0xf
8000c18e:	0fc6f693          	and	a3,a3,252
8000c192:	9696                	add	a3,a3,t0
8000c194:	429c                	lw	a5,0(a3)
8000c196:	4187d613          	sra	a2,a5,0x18
8000c19a:	00f59693          	sll	a3,a1,0xf
8000c19e:	82e1                	srl	a3,a3,0x18
8000c1a0:	0016f293          	and	t0,a3,1
8000c1a4:	8285                	srl	a3,a3,0x1
8000c1a6:	fc068693          	add	a3,a3,-64 # f3ffffc0 <__AHB_SRAM_segment_end__+0x3cf7fc0>
8000c1aa:	9696                	add	a3,a3,t0
8000c1ac:	02d60633          	mul	a2,a2,a3
8000c1b0:	07a2                	sll	a5,a5,0x8
8000c1b2:	83a1                	srl	a5,a5,0x8
8000c1b4:	963e                	add	a2,a2,a5
8000c1b6:	05a2                	sll	a1,a1,0x8
8000c1b8:	81a1                	srl	a1,a1,0x8
8000c1ba:	008007b7          	lui	a5,0x800
8000c1be:	8ddd                	or	a1,a1,a5
8000c1c0:	02c586b3          	mul	a3,a1,a2
8000c1c4:	0522                	sll	a0,a0,0x8
8000c1c6:	8121                	srl	a0,a0,0x8
8000c1c8:	8d5d                	or	a0,a0,a5
8000c1ca:	02c697b3          	mulh	a5,a3,a2
8000c1ce:	00b532b3          	sltu	t0,a0,a1
8000c1d2:	00551533          	sll	a0,a0,t0
8000c1d6:	40570733          	sub	a4,a4,t0
8000c1da:	01465693          	srl	a3,a2,0x14
8000c1de:	8a85                	and	a3,a3,1
8000c1e0:	0016c693          	xor	a3,a3,1
8000c1e4:	062e                	sll	a2,a2,0xb
8000c1e6:	8e1d                	sub	a2,a2,a5
8000c1e8:	8e15                	sub	a2,a2,a3
8000c1ea:	050a                	sll	a0,a0,0x2
8000c1ec:	02a617b3          	mulh	a5,a2,a0
8000c1f0:	07e70613          	add	a2,a4,126
8000c1f4:	055a                	sll	a0,a0,0x16
8000c1f6:	8d0d                	sub	a0,a0,a1
8000c1f8:	02b786b3          	mul	a3,a5,a1
8000c1fc:	0fe00293          	li	t0,254
8000c200:	00567f63          	bgeu	a2,t0,8000c21e <.L__divsf3_underflow_or_overflow>
8000c204:	40a68533          	sub	a0,a3,a0
8000c208:	000522b3          	sltz	t0,a0
8000c20c:	9796                	add	a5,a5,t0
8000c20e:	0017f513          	and	a0,a5,1
8000c212:	8385                	srl	a5,a5,0x1
8000c214:	953e                	add	a0,a0,a5
8000c216:	065e                	sll	a2,a2,0x17
8000c218:	9532                	add	a0,a0,a2
8000c21a:	951a                	add	a0,a0,t1
8000c21c:	8082                	ret

8000c21e <.L__divsf3_underflow_or_overflow>:
8000c21e:	851a                	mv	a0,t1
8000c220:	00564563          	blt	a2,t0,8000c22a <.L__divsf3_done>
8000c224:	7f800337          	lui	t1,0x7f800

8000c228 <.L__divsf3_apply_sign>:
8000c228:	951a                	add	a0,a0,t1

8000c22a <.L__divsf3_done>:
8000c22a:	8082                	ret

8000c22c <.L__divsf3_inf>:
8000c22c:	7f800537          	lui	a0,0x7f800
8000c230:	bfe5                	j	8000c228 <.L__divsf3_apply_sign>

8000c232 <.L__divsf3_lhs_zero_or_subnormal>:
8000c232:	c789                	beqz	a5,8000c23c <.L__divsf3_nan>
8000c234:	02579363          	bne	a5,t0,8000c25a <.L__divsf3_signed_zero>
8000c238:	05a6                	sll	a1,a1,0x9
8000c23a:	c185                	beqz	a1,8000c25a <.L__divsf3_signed_zero>

8000c23c <.L__divsf3_nan>:
8000c23c:	7fc00537          	lui	a0,0x7fc00
8000c240:	8082                	ret

8000c242 <.L__divsf3_lhs_inf_or_nan>:
8000c242:	0526                	sll	a0,a0,0x9
8000c244:	fd65                	bnez	a0,8000c23c <.L__divsf3_nan>
8000c246:	fe5793e3          	bne	a5,t0,8000c22c <.L__divsf3_inf>
8000c24a:	bfcd                	j	8000c23c <.L__divsf3_nan>

8000c24c <.L__divsf3_rhs_zero_or_subnormal>:
8000c24c:	fe5710e3          	bne	a4,t0,8000c22c <.L__divsf3_inf>
8000c250:	0526                	sll	a0,a0,0x9
8000c252:	f56d                	bnez	a0,8000c23c <.L__divsf3_nan>
8000c254:	bfe1                	j	8000c22c <.L__divsf3_inf>

8000c256 <.L__divsf3_rhs_inf_or_nan>:
8000c256:	05a6                	sll	a1,a1,0x9
8000c258:	f1f5                	bnez	a1,8000c23c <.L__divsf3_nan>

8000c25a <.L__divsf3_signed_zero>:
8000c25a:	851a                	mv	a0,t1
8000c25c:	8082                	ret

Disassembly of section .text.libc.__divdf3:

8000c25e <__divdf3>:
8000c25e:	00169813          	sll	a6,a3,0x1
8000c262:	01585813          	srl	a6,a6,0x15
8000c266:	00159893          	sll	a7,a1,0x1
8000c26a:	0158d893          	srl	a7,a7,0x15
8000c26e:	00d5c3b3          	xor	t2,a1,a3
8000c272:	01f3d393          	srl	t2,t2,0x1f
8000c276:	03fe                	sll	t2,t2,0x1f
8000c278:	7ff00293          	li	t0,2047
8000c27c:	16588e63          	beq	a7,t0,8000c3f8 <.L__divdf3_inf_nan_over>
8000c280:	18080a63          	beqz	a6,8000c414 <.L__divdf3_div_zero>
8000c284:	18580263          	beq	a6,t0,8000c408 <.L__divdf3_div_inf_nan>
8000c288:	18088263          	beqz	a7,8000c40c <.L__divdf3_signed_zero>
8000c28c:	410888b3          	sub	a7,a7,a6
8000c290:	3ff88893          	add	a7,a7,1023 # 800003ff <_extram_size+0x7e0003ff>
8000c294:	05b2                	sll	a1,a1,0xc
8000c296:	81b1                	srl	a1,a1,0xc
8000c298:	06b2                	sll	a3,a3,0xc
8000c29a:	82b1                	srl	a3,a3,0xc
8000c29c:	00100737          	lui	a4,0x100
8000c2a0:	8dd9                	or	a1,a1,a4
8000c2a2:	8ed9                	or	a3,a3,a4
8000c2a4:	00c53733          	sltu	a4,a0,a2
8000c2a8:	9736                	add	a4,a4,a3
8000c2aa:	8d99                	sub	a1,a1,a4
8000c2ac:	8d11                	sub	a0,a0,a2
8000c2ae:	0005dd63          	bgez	a1,8000c2c8 <.L__divdf3_can_subtract>
8000c2b2:	00052733          	sltz	a4,a0
8000c2b6:	95ae                	add	a1,a1,a1
8000c2b8:	95ba                	add	a1,a1,a4
8000c2ba:	95b6                	add	a1,a1,a3
8000c2bc:	952a                	add	a0,a0,a0
8000c2be:	9532                	add	a0,a0,a2
8000c2c0:	00c53733          	sltu	a4,a0,a2
8000c2c4:	95ba                	add	a1,a1,a4
8000c2c6:	18fd                	add	a7,a7,-1

8000c2c8 <.L__divdf3_can_subtract>:
8000c2c8:	1258dd63          	bge	a7,t0,8000c402 <.L__divdf3_signed_inf>
8000c2cc:	15105063          	blez	a7,8000c40c <.L__divdf3_signed_zero>
8000c2d0:	05aa                	sll	a1,a1,0xa
8000c2d2:	01655713          	srl	a4,a0,0x16
8000c2d6:	8dd9                	or	a1,a1,a4
8000c2d8:	052a                	sll	a0,a0,0xa
8000c2da:	02d5d833          	divu	a6,a1,a3
8000c2de:	02d80e33          	mul	t3,a6,a3
8000c2e2:	41c585b3          	sub	a1,a1,t3
8000c2e6:	02c80733          	mul	a4,a6,a2
8000c2ea:	02c837b3          	mulhu	a5,a6,a2
8000c2ee:	00e53e33          	sltu	t3,a0,a4
8000c2f2:	97f2                	add	a5,a5,t3
8000c2f4:	8d19                	sub	a0,a0,a4
8000c2f6:	8d9d                	sub	a1,a1,a5
8000c2f8:	0005d863          	bgez	a1,8000c308 <.L__divdf3_qdash_correct_1>
8000c2fc:	187d                	add	a6,a6,-1 # ffdfffff <__APB_SRAM_segment_end__+0xbd0dfff>
8000c2fe:	9532                	add	a0,a0,a2
8000c300:	95b6                	add	a1,a1,a3
8000c302:	00c532b3          	sltu	t0,a0,a2
8000c306:	9596                	add	a1,a1,t0

8000c308 <.L__divdf3_qdash_correct_1>:
8000c308:	05aa                	sll	a1,a1,0xa
8000c30a:	01655293          	srl	t0,a0,0x16
8000c30e:	9596                	add	a1,a1,t0
8000c310:	052a                	sll	a0,a0,0xa
8000c312:	02d5d2b3          	divu	t0,a1,a3
8000c316:	02d28733          	mul	a4,t0,a3
8000c31a:	8d99                	sub	a1,a1,a4
8000c31c:	02c28733          	mul	a4,t0,a2
8000c320:	02c2b7b3          	mulhu	a5,t0,a2
8000c324:	00e53e33          	sltu	t3,a0,a4
8000c328:	97f2                	add	a5,a5,t3
8000c32a:	8d19                	sub	a0,a0,a4
8000c32c:	8d9d                	sub	a1,a1,a5
8000c32e:	0005d863          	bgez	a1,8000c33e <.L__divdf3_qdash_correct_2>
8000c332:	12fd                	add	t0,t0,-1
8000c334:	9532                	add	a0,a0,a2
8000c336:	95b6                	add	a1,a1,a3
8000c338:	00c53e33          	sltu	t3,a0,a2
8000c33c:	95f2                	add	a1,a1,t3

8000c33e <.L__divdf3_qdash_correct_2>:
8000c33e:	082a                	sll	a6,a6,0xa
8000c340:	9816                	add	a6,a6,t0
8000c342:	05ae                	sll	a1,a1,0xb
8000c344:	01555e13          	srl	t3,a0,0x15
8000c348:	95f2                	add	a1,a1,t3
8000c34a:	052e                	sll	a0,a0,0xb
8000c34c:	02d5d2b3          	divu	t0,a1,a3
8000c350:	02d28733          	mul	a4,t0,a3
8000c354:	8d99                	sub	a1,a1,a4
8000c356:	02c28733          	mul	a4,t0,a2
8000c35a:	02c2b7b3          	mulhu	a5,t0,a2
8000c35e:	00e53e33          	sltu	t3,a0,a4
8000c362:	97f2                	add	a5,a5,t3
8000c364:	8d19                	sub	a0,a0,a4
8000c366:	8d9d                	sub	a1,a1,a5
8000c368:	0005d863          	bgez	a1,8000c378 <.L__divdf3_qdash_correct_3>
8000c36c:	12fd                	add	t0,t0,-1
8000c36e:	9532                	add	a0,a0,a2
8000c370:	95b6                	add	a1,a1,a3
8000c372:	00c53e33          	sltu	t3,a0,a2
8000c376:	95f2                	add	a1,a1,t3

8000c378 <.L__divdf3_qdash_correct_3>:
8000c378:	05ae                	sll	a1,a1,0xb
8000c37a:	01555e13          	srl	t3,a0,0x15
8000c37e:	95f2                	add	a1,a1,t3
8000c380:	052e                	sll	a0,a0,0xb
8000c382:	02d5d333          	divu	t1,a1,a3
8000c386:	02d30733          	mul	a4,t1,a3
8000c38a:	8d99                	sub	a1,a1,a4
8000c38c:	02c30733          	mul	a4,t1,a2
8000c390:	02c337b3          	mulhu	a5,t1,a2
8000c394:	00e53e33          	sltu	t3,a0,a4
8000c398:	97f2                	add	a5,a5,t3
8000c39a:	8d19                	sub	a0,a0,a4
8000c39c:	8d9d                	sub	a1,a1,a5
8000c39e:	0005d863          	bgez	a1,8000c3ae <.L__divdf3_qdash_correct_4>
8000c3a2:	137d                	add	t1,t1,-1 # 7f7fffff <_extram_size+0x7d7fffff>
8000c3a4:	9532                	add	a0,a0,a2
8000c3a6:	95b6                	add	a1,a1,a3
8000c3a8:	00c53e33          	sltu	t3,a0,a2
8000c3ac:	95f2                	add	a1,a1,t3

8000c3ae <.L__divdf3_qdash_correct_4>:
8000c3ae:	02d6                	sll	t0,t0,0x15
8000c3b0:	032a                	sll	t1,t1,0xa
8000c3b2:	929a                	add	t0,t0,t1
8000c3b4:	05ae                	sll	a1,a1,0xb
8000c3b6:	01555e13          	srl	t3,a0,0x15
8000c3ba:	95f2                	add	a1,a1,t3
8000c3bc:	052e                	sll	a0,a0,0xb
8000c3be:	02d5d333          	divu	t1,a1,a3
8000c3c2:	02d30733          	mul	a4,t1,a3
8000c3c6:	8d99                	sub	a1,a1,a4
8000c3c8:	02c30733          	mul	a4,t1,a2
8000c3cc:	02c337b3          	mulhu	a5,t1,a2
8000c3d0:	00e53e33          	sltu	t3,a0,a4
8000c3d4:	97f2                	add	a5,a5,t3
8000c3d6:	8d9d                	sub	a1,a1,a5
8000c3d8:	85fd                	sra	a1,a1,0x1f
8000c3da:	932e                	add	t1,t1,a1
8000c3dc:	08d2                	sll	a7,a7,0x14
8000c3de:	011805b3          	add	a1,a6,a7
8000c3e2:	00135513          	srl	a0,t1,0x1
8000c3e6:	9516                	add	a0,a0,t0
8000c3e8:	00137313          	and	t1,t1,1
8000c3ec:	951a                	add	a0,a0,t1
8000c3ee:	00653733          	sltu	a4,a0,t1
8000c3f2:	95ba                	add	a1,a1,a4
8000c3f4:	959e                	add	a1,a1,t2
8000c3f6:	8082                	ret

8000c3f8 <.L__divdf3_inf_nan_over>:
8000c3f8:	05b2                	sll	a1,a1,0xc
8000c3fa:	00580f63          	beq	a6,t0,8000c418 <.L__divdf3_return_nan>
8000c3fe:	8dc9                	or	a1,a1,a0
8000c400:	ed81                	bnez	a1,8000c418 <.L__divdf3_return_nan>

8000c402 <.L__divdf3_signed_inf>:
8000c402:	7ff005b7          	lui	a1,0x7ff00
8000c406:	a021                	j	8000c40e <.L__divdf3_apply_sign>

8000c408 <.L__divdf3_div_inf_nan>:
8000c408:	06b2                	sll	a3,a3,0xc
8000c40a:	e699                	bnez	a3,8000c418 <.L__divdf3_return_nan>

8000c40c <.L__divdf3_signed_zero>:
8000c40c:	4581                	li	a1,0

8000c40e <.L__divdf3_apply_sign>:
8000c40e:	959e                	add	a1,a1,t2

8000c410 <.L__divdf3_clr_low_ret>:
8000c410:	4501                	li	a0,0
8000c412:	8082                	ret

8000c414 <.L__divdf3_div_zero>:
8000c414:	fe0897e3          	bnez	a7,8000c402 <.L__divdf3_signed_inf>

8000c418 <.L__divdf3_return_nan>:
8000c418:	7ff805b7          	lui	a1,0x7ff80
8000c41c:	bfd5                	j	8000c410 <.L__divdf3_clr_low_ret>

Disassembly of section .text.libc.__eqsf2:

8000c41e <__eqsf2>:
8000c41e:	ff000637          	lui	a2,0xff000
8000c422:	00151693          	sll	a3,a0,0x1
8000c426:	02d66063          	bltu	a2,a3,8000c446 <.L__eqsf2_one>
8000c42a:	00159693          	sll	a3,a1,0x1
8000c42e:	00d66c63          	bltu	a2,a3,8000c446 <.L__eqsf2_one>
8000c432:	00b56633          	or	a2,a0,a1
8000c436:	0606                	sll	a2,a2,0x1
8000c438:	c609                	beqz	a2,8000c442 <.L__eqsf2_zero>
8000c43a:	8d0d                	sub	a0,a0,a1
8000c43c:	00a03533          	snez	a0,a0
8000c440:	8082                	ret

8000c442 <.L__eqsf2_zero>:
8000c442:	4501                	li	a0,0
8000c444:	8082                	ret

8000c446 <.L__eqsf2_one>:
8000c446:	4505                	li	a0,1
8000c448:	8082                	ret

Disassembly of section .text.libc.__eqdf2:

8000c44a <__eqdf2>:
8000c44a:	ffe007b7          	lui	a5,0xffe00
8000c44e:	00159713          	sll	a4,a1,0x1
8000c452:	02e7e463          	bltu	a5,a4,8000c47a <.L__eqdf2_not_equal>
8000c456:	00169713          	sll	a4,a3,0x1
8000c45a:	02e7e063          	bltu	a5,a4,8000c47a <.L__eqdf2_not_equal>
8000c45e:	00d5e733          	or	a4,a1,a3
8000c462:	0706                	sll	a4,a4,0x1
8000c464:	8f49                	or	a4,a4,a0
8000c466:	8f51                	or	a4,a4,a2
8000c468:	c719                	beqz	a4,8000c476 <.L__eqdf2_equal>
8000c46a:	8d31                	xor	a0,a0,a2
8000c46c:	8db5                	xor	a1,a1,a3
8000c46e:	8d4d                	or	a0,a0,a1
8000c470:	00a03533          	snez	a0,a0
8000c474:	8082                	ret

8000c476 <.L__eqdf2_equal>:
8000c476:	4501                	li	a0,0
8000c478:	8082                	ret

8000c47a <.L__eqdf2_not_equal>:
8000c47a:	4505                	li	a0,1
8000c47c:	8082                	ret

Disassembly of section .text.libc.__fixdfsi:

8000c47e <__fixdfsi>:
8000c47e:	41f5d693          	sra	a3,a1,0x1f
8000c482:	00159613          	sll	a2,a1,0x1
8000c486:	8255                	srl	a2,a2,0x15
8000c488:	c0160613          	add	a2,a2,-1023 # fefffc01 <__APB_SRAM_segment_end__+0xaf0dc01>
8000c48c:	02064163          	bltz	a2,8000c4ae <.L__fixdfsi_zero_result>
8000c490:	477d                	li	a4,31
8000c492:	8f11                	sub	a4,a4,a2
8000c494:	00e05f63          	blez	a4,8000c4b2 <.L__fixdfsi_overflow_result>
8000c498:	8155                	srl	a0,a0,0x15
8000c49a:	05ae                	sll	a1,a1,0xb
8000c49c:	8d4d                	or	a0,a0,a1
8000c49e:	800005b7          	lui	a1,0x80000
8000c4a2:	8d4d                	or	a0,a0,a1
8000c4a4:	00e55533          	srl	a0,a0,a4
8000c4a8:	8d35                	xor	a0,a0,a3
8000c4aa:	8d15                	sub	a0,a0,a3
8000c4ac:	8082                	ret

8000c4ae <.L__fixdfsi_zero_result>:
8000c4ae:	4501                	li	a0,0
8000c4b0:	8082                	ret

8000c4b2 <.L__fixdfsi_overflow_result>:
8000c4b2:	00a03533          	snez	a0,a0
8000c4b6:	8dc9                	or	a1,a1,a0
8000c4b8:	0586                	sll	a1,a1,0x1
8000c4ba:	ffe00537          	lui	a0,0xffe00
8000c4be:	00b57363          	bgeu	a0,a1,8000c4c4 <.L__fixdfsi_not_nan>
8000c4c2:	4681                	li	a3,0

8000c4c4 <.L__fixdfsi_not_nan>:
8000c4c4:	80000537          	lui	a0,0x80000
8000c4c8:	157d                	add	a0,a0,-1 # 7fffffff <_extram_size+0x7dffffff>
8000c4ca:	8d35                	xor	a0,a0,a3
8000c4cc:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

8000c4ce <__fixunssfdi>:
8000c4ce:	04054a63          	bltz	a0,8000c522 <.L__fixunssfdi_zero_result>
8000c4d2:	00151613          	sll	a2,a0,0x1
8000c4d6:	8261                	srl	a2,a2,0x18
8000c4d8:	f8160613          	add	a2,a2,-127
8000c4dc:	04064363          	bltz	a2,8000c522 <.L__fixunssfdi_zero_result>
8000c4e0:	800006b7          	lui	a3,0x80000
8000c4e4:	02000293          	li	t0,32
8000c4e8:	00565b63          	bge	a2,t0,8000c4fe <.L__fixunssfdi_long_shift>
8000c4ec:	40c00633          	neg	a2,a2
8000c4f0:	067d                	add	a2,a2,31
8000c4f2:	0522                	sll	a0,a0,0x8
8000c4f4:	8d55                	or	a0,a0,a3
8000c4f6:	00c55533          	srl	a0,a0,a2
8000c4fa:	4581                	li	a1,0
8000c4fc:	8082                	ret

8000c4fe <.L__fixunssfdi_long_shift>:
8000c4fe:	40c00633          	neg	a2,a2
8000c502:	03f60613          	add	a2,a2,63
8000c506:	02064163          	bltz	a2,8000c528 <.L__fixunssfdi_overflow_result>
8000c50a:	00851593          	sll	a1,a0,0x8
8000c50e:	8dd5                	or	a1,a1,a3
8000c510:	4501                	li	a0,0
8000c512:	c619                	beqz	a2,8000c520 <.L__fixunssfdi_shift_32>
8000c514:	40c006b3          	neg	a3,a2
8000c518:	00d59533          	sll	a0,a1,a3
8000c51c:	00c5d5b3          	srl	a1,a1,a2

8000c520 <.L__fixunssfdi_shift_32>:
8000c520:	8082                	ret

8000c522 <.L__fixunssfdi_zero_result>:
8000c522:	4501                	li	a0,0
8000c524:	4581                	li	a1,0
8000c526:	8082                	ret

8000c528 <.L__fixunssfdi_overflow_result>:
8000c528:	557d                	li	a0,-1
8000c52a:	55fd                	li	a1,-1
8000c52c:	8082                	ret

Disassembly of section .text.libc.__floatunsidf:

8000c52e <__floatunsidf>:
8000c52e:	c131                	beqz	a0,8000c572 <.L__floatunsidf_zero>
8000c530:	41d00613          	li	a2,1053
8000c534:	01055693          	srl	a3,a0,0x10
8000c538:	e299                	bnez	a3,8000c53e <.L1^B9>
8000c53a:	0542                	sll	a0,a0,0x10
8000c53c:	1641                	add	a2,a2,-16

8000c53e <.L1^B9>:
8000c53e:	01855693          	srl	a3,a0,0x18
8000c542:	e299                	bnez	a3,8000c548 <.L2^B9>
8000c544:	0522                	sll	a0,a0,0x8
8000c546:	1661                	add	a2,a2,-8

8000c548 <.L2^B9>:
8000c548:	01c55693          	srl	a3,a0,0x1c
8000c54c:	e299                	bnez	a3,8000c552 <.L3^B7>
8000c54e:	0512                	sll	a0,a0,0x4
8000c550:	1671                	add	a2,a2,-4

8000c552 <.L3^B7>:
8000c552:	01e55693          	srl	a3,a0,0x1e
8000c556:	e299                	bnez	a3,8000c55c <.L4^B9>
8000c558:	050a                	sll	a0,a0,0x2
8000c55a:	1679                	add	a2,a2,-2

8000c55c <.L4^B9>:
8000c55c:	00054463          	bltz	a0,8000c564 <.L5^B7>
8000c560:	0506                	sll	a0,a0,0x1
8000c562:	167d                	add	a2,a2,-1

8000c564 <.L5^B7>:
8000c564:	0652                	sll	a2,a2,0x14
8000c566:	00b55693          	srl	a3,a0,0xb
8000c56a:	0556                	sll	a0,a0,0x15
8000c56c:	00c685b3          	add	a1,a3,a2
8000c570:	8082                	ret

8000c572 <.L__floatunsidf_zero>:
8000c572:	85aa                	mv	a1,a0
8000c574:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

8000c576 <__trunctfsf2>:
8000c576:	4110                	lw	a2,0(a0)
8000c578:	4154                	lw	a3,4(a0)
8000c57a:	4518                	lw	a4,8(a0)
8000c57c:	455c                	lw	a5,12(a0)
8000c57e:	1101                	add	sp,sp,-32
8000c580:	850a                	mv	a0,sp
8000c582:	ce06                	sw	ra,28(sp)
8000c584:	c032                	sw	a2,0(sp)
8000c586:	c236                	sw	a3,4(sp)
8000c588:	c43a                	sw	a4,8(sp)
8000c58a:	c63e                	sw	a5,12(sp)
8000c58c:	c4bfb0ef          	jal	800081d6 <__SEGGER_RTL_ldouble_to_double>
8000c590:	bc1fb0ef          	jal	80008150 <__truncdfsf2>
8000c594:	40f2                	lw	ra,28(sp)
8000c596:	6105                	add	sp,sp,32
8000c598:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

8000c59a <__SEGGER_RTL_float32_signbit>:
8000c59a:	817d                	srl	a0,a0,0x1f
8000c59c:	8082                	ret

Disassembly of section .text.libc.ldexpf:

8000c59e <ldexpf>:
8000c59e:	01755713          	srl	a4,a0,0x17
8000c5a2:	0ff77713          	zext.b	a4,a4
8000c5a6:	fff70613          	add	a2,a4,-1 # fffff <__DLM_segment_end__+0x3ffff>
8000c5aa:	0fd00693          	li	a3,253
8000c5ae:	87aa                	mv	a5,a0
8000c5b0:	02c6e863          	bltu	a3,a2,8000c5e0 <.L780>
8000c5b4:	95ba                	add	a1,a1,a4
8000c5b6:	fff58713          	add	a4,a1,-1 # 7fffffff <_extram_size+0x7dffffff>
8000c5ba:	00e6eb63          	bltu	a3,a4,8000c5d0 <.L781>
8000c5be:	80800737          	lui	a4,0x80800
8000c5c2:	177d                	add	a4,a4,-1 # 807fffff <__XPI0_segment_used_end__+0x7efc47>
8000c5c4:	00e577b3          	and	a5,a0,a4
8000c5c8:	05de                	sll	a1,a1,0x17
8000c5ca:	00f5e533          	or	a0,a1,a5
8000c5ce:	8082                	ret

8000c5d0 <.L781>:
8000c5d0:	80000537          	lui	a0,0x80000
8000c5d4:	8d7d                	and	a0,a0,a5
8000c5d6:	00b05563          	blez	a1,8000c5e0 <.L780>
8000c5da:	7f8007b7          	lui	a5,0x7f800
8000c5de:	8d5d                	or	a0,a0,a5

8000c5e0 <.L780>:
8000c5e0:	8082                	ret

Disassembly of section .text.libc.frexpf:

8000c5e2 <frexpf>:
8000c5e2:	01755793          	srl	a5,a0,0x17
8000c5e6:	0ff7f793          	zext.b	a5,a5
8000c5ea:	4701                	li	a4,0
8000c5ec:	cf99                	beqz	a5,8000c60a <.L959>
8000c5ee:	0ff00613          	li	a2,255
8000c5f2:	00c78c63          	beq	a5,a2,8000c60a <.L959>
8000c5f6:	f8278713          	add	a4,a5,-126 # 7f7fff82 <_extram_size+0x7d7fff82>
8000c5fa:	808007b7          	lui	a5,0x80800
8000c5fe:	17fd                	add	a5,a5,-1 # 807fffff <__XPI0_segment_used_end__+0x7efc47>
8000c600:	00f576b3          	and	a3,a0,a5
8000c604:	3f000537          	lui	a0,0x3f000
8000c608:	8d55                	or	a0,a0,a3

8000c60a <.L959>:
8000c60a:	c198                	sw	a4,0(a1)
8000c60c:	8082                	ret

Disassembly of section .text.libc.fmodf:

8000c60e <fmodf>:
8000c60e:	01755793          	srl	a5,a0,0x17
8000c612:	80000837          	lui	a6,0x80000
8000c616:	17fd                	add	a5,a5,-1
8000c618:	0fd00713          	li	a4,253
8000c61c:	86aa                	mv	a3,a0
8000c61e:	862e                	mv	a2,a1
8000c620:	00a87833          	and	a6,a6,a0
8000c624:	02f76663          	bltu	a4,a5,8000c650 <.L991>
8000c628:	0175d793          	srl	a5,a1,0x17
8000c62c:	17fd                	add	a5,a5,-1
8000c62e:	04f77063          	bgeu	a4,a5,8000c66e <.L992>
8000c632:	00151713          	sll	a4,a0,0x1

8000c636 <.L993>:
8000c636:	00159793          	sll	a5,a1,0x1
8000c63a:	ff000637          	lui	a2,0xff000
8000c63e:	0cf66863          	bltu	a2,a5,8000c70e <.L1009>
8000c642:	ef11                	bnez	a4,8000c65e <.L995>
8000c644:	ef81                	bnez	a5,8000c65c <.L994>

8000c646 <.L1011>:
8000c646:	800047b7          	lui	a5,0x80004
8000c64a:	0687a503          	lw	a0,104(a5) # 80004068 <.Lmerged_single+0x14>
8000c64e:	8082                	ret

8000c650 <.L991>:
8000c650:	00151713          	sll	a4,a0,0x1
8000c654:	ff0007b7          	lui	a5,0xff000
8000c658:	fce7ffe3          	bgeu	a5,a4,8000c636 <.L993>

8000c65c <.L994>:
8000c65c:	8082                	ret

8000c65e <.L995>:
8000c65e:	fec704e3          	beq	a4,a2,8000c646 <.L1011>
8000c662:	fec78de3          	beq	a5,a2,8000c65c <.L994>
8000c666:	d3e5                	beqz	a5,8000c646 <.L1011>
8000c668:	0586                	sll	a1,a1,0x1
8000c66a:	0015d613          	srl	a2,a1,0x1

8000c66e <.L992>:
8000c66e:	00169793          	sll	a5,a3,0x1
8000c672:	8385                	srl	a5,a5,0x1
8000c674:	00f66663          	bltu	a2,a5,8000c680 <.L996>
8000c678:	fec792e3          	bne	a5,a2,8000c65c <.L994>

8000c67c <.L1018>:
8000c67c:	8542                	mv	a0,a6
8000c67e:	8082                	ret

8000c680 <.L996>:
8000c680:	0177d713          	srl	a4,a5,0x17
8000c684:	cb0d                	beqz	a4,8000c6b6 <.L1012>
8000c686:	008007b7          	lui	a5,0x800
8000c68a:	fff78593          	add	a1,a5,-1 # 7fffff <__DLM_segment_end__+0x73ffff>
8000c68e:	8eed                	and	a3,a3,a1
8000c690:	8fd5                	or	a5,a5,a3

8000c692 <.L998>:
8000c692:	01765593          	srl	a1,a2,0x17
8000c696:	c985                	beqz	a1,8000c6c6 <.L1013>
8000c698:	008006b7          	lui	a3,0x800
8000c69c:	fff68513          	add	a0,a3,-1 # 7fffff <__DLM_segment_end__+0x73ffff>
8000c6a0:	8e69                	and	a2,a2,a0
8000c6a2:	8e55                	or	a2,a2,a3

8000c6a4 <.L1002>:
8000c6a4:	40c786b3          	sub	a3,a5,a2
8000c6a8:	02e5c763          	blt	a1,a4,8000c6d6 <.L1003>
8000c6ac:	0206cc63          	bltz	a3,8000c6e4 <.L1015>
8000c6b0:	8542                	mv	a0,a6
8000c6b2:	ea95                	bnez	a3,8000c6e6 <.L1004>
8000c6b4:	8082                	ret

8000c6b6 <.L1012>:
8000c6b6:	4701                	li	a4,0
8000c6b8:	008006b7          	lui	a3,0x800

8000c6bc <.L997>:
8000c6bc:	0786                	sll	a5,a5,0x1
8000c6be:	177d                	add	a4,a4,-1
8000c6c0:	fed7eee3          	bltu	a5,a3,8000c6bc <.L997>
8000c6c4:	b7f9                	j	8000c692 <.L998>

8000c6c6 <.L1013>:
8000c6c6:	4581                	li	a1,0
8000c6c8:	008006b7          	lui	a3,0x800

8000c6cc <.L999>:
8000c6cc:	0606                	sll	a2,a2,0x1
8000c6ce:	15fd                	add	a1,a1,-1
8000c6d0:	fed66ee3          	bltu	a2,a3,8000c6cc <.L999>
8000c6d4:	bfc1                	j	8000c6a4 <.L1002>

8000c6d6 <.L1003>:
8000c6d6:	0006c463          	bltz	a3,8000c6de <.L1001>
8000c6da:	d2cd                	beqz	a3,8000c67c <.L1018>
8000c6dc:	87b6                	mv	a5,a3

8000c6de <.L1001>:
8000c6de:	0786                	sll	a5,a5,0x1
8000c6e0:	177d                	add	a4,a4,-1
8000c6e2:	b7c9                	j	8000c6a4 <.L1002>

8000c6e4 <.L1015>:
8000c6e4:	86be                	mv	a3,a5

8000c6e6 <.L1004>:
8000c6e6:	008007b7          	lui	a5,0x800

8000c6ea <.L1006>:
8000c6ea:	fff70513          	add	a0,a4,-1
8000c6ee:	00f6ed63          	bltu	a3,a5,8000c708 <.L1007>
8000c6f2:	00e04763          	bgtz	a4,8000c700 <.L1008>
8000c6f6:	4785                	li	a5,1
8000c6f8:	8f99                	sub	a5,a5,a4
8000c6fa:	00f6d6b3          	srl	a3,a3,a5
8000c6fe:	4501                	li	a0,0

8000c700 <.L1008>:
8000c700:	9836                	add	a6,a6,a3
8000c702:	055e                	sll	a0,a0,0x17
8000c704:	9542                	add	a0,a0,a6
8000c706:	8082                	ret

8000c708 <.L1007>:
8000c708:	0686                	sll	a3,a3,0x1
8000c70a:	872a                	mv	a4,a0
8000c70c:	bff9                	j	8000c6ea <.L1006>

8000c70e <.L1009>:
8000c70e:	852e                	mv	a0,a1
8000c710:	8082                	ret

Disassembly of section .text.libc.memset:

8000c712 <memset>:
8000c712:	872a                	mv	a4,a0
8000c714:	c22d                	beqz	a2,8000c776 <.Lmemset_memset_end>

8000c716 <.Lmemset_unaligned_byte_set_loop>:
8000c716:	01e51693          	sll	a3,a0,0x1e
8000c71a:	c699                	beqz	a3,8000c728 <.Lmemset_fast_set>
8000c71c:	00b50023          	sb	a1,0(a0) # 3f000000 <_extram_size+0x3d000000>
8000c720:	0505                	add	a0,a0,1
8000c722:	167d                	add	a2,a2,-1 # feffffff <__APB_SRAM_segment_end__+0xaf0dfff>
8000c724:	fa6d                	bnez	a2,8000c716 <.Lmemset_unaligned_byte_set_loop>
8000c726:	a881                	j	8000c776 <.Lmemset_memset_end>

8000c728 <.Lmemset_fast_set>:
8000c728:	0ff5f593          	zext.b	a1,a1
8000c72c:	00859693          	sll	a3,a1,0x8
8000c730:	8dd5                	or	a1,a1,a3
8000c732:	01059693          	sll	a3,a1,0x10
8000c736:	8dd5                	or	a1,a1,a3
8000c738:	02000693          	li	a3,32
8000c73c:	00d66f63          	bltu	a2,a3,8000c75a <.Lmemset_word_set>

8000c740 <.Lmemset_fast_set_loop>:
8000c740:	c10c                	sw	a1,0(a0)
8000c742:	c14c                	sw	a1,4(a0)
8000c744:	c50c                	sw	a1,8(a0)
8000c746:	c54c                	sw	a1,12(a0)
8000c748:	c90c                	sw	a1,16(a0)
8000c74a:	c94c                	sw	a1,20(a0)
8000c74c:	cd0c                	sw	a1,24(a0)
8000c74e:	cd4c                	sw	a1,28(a0)
8000c750:	9536                	add	a0,a0,a3
8000c752:	8e15                	sub	a2,a2,a3
8000c754:	fed676e3          	bgeu	a2,a3,8000c740 <.Lmemset_fast_set_loop>
8000c758:	ce19                	beqz	a2,8000c776 <.Lmemset_memset_end>

8000c75a <.Lmemset_word_set>:
8000c75a:	4691                	li	a3,4
8000c75c:	00d66863          	bltu	a2,a3,8000c76c <.Lmemset_byte_set_loop>

8000c760 <.Lmemset_word_set_loop>:
8000c760:	c10c                	sw	a1,0(a0)
8000c762:	9536                	add	a0,a0,a3
8000c764:	8e15                	sub	a2,a2,a3
8000c766:	fed67de3          	bgeu	a2,a3,8000c760 <.Lmemset_word_set_loop>
8000c76a:	c611                	beqz	a2,8000c776 <.Lmemset_memset_end>

8000c76c <.Lmemset_byte_set_loop>:
8000c76c:	00b50023          	sb	a1,0(a0)
8000c770:	0505                	add	a0,a0,1
8000c772:	167d                	add	a2,a2,-1
8000c774:	fe65                	bnez	a2,8000c76c <.Lmemset_byte_set_loop>

8000c776 <.Lmemset_memset_end>:
8000c776:	853a                	mv	a0,a4
8000c778:	8082                	ret

Disassembly of section .text.libc.strlen:

8000c77a <strlen>:
8000c77a:	85aa                	mv	a1,a0
8000c77c:	00357693          	and	a3,a0,3
8000c780:	c29d                	beqz	a3,8000c7a6 <.Lstrlen_aligned>
8000c782:	00054603          	lbu	a2,0(a0)
8000c786:	ce21                	beqz	a2,8000c7de <.Lstrlen_done>
8000c788:	0505                	add	a0,a0,1
8000c78a:	00357693          	and	a3,a0,3
8000c78e:	ce81                	beqz	a3,8000c7a6 <.Lstrlen_aligned>
8000c790:	00054603          	lbu	a2,0(a0)
8000c794:	c629                	beqz	a2,8000c7de <.Lstrlen_done>
8000c796:	0505                	add	a0,a0,1
8000c798:	00357693          	and	a3,a0,3
8000c79c:	c689                	beqz	a3,8000c7a6 <.Lstrlen_aligned>
8000c79e:	00054603          	lbu	a2,0(a0)
8000c7a2:	ce15                	beqz	a2,8000c7de <.Lstrlen_done>
8000c7a4:	0505                	add	a0,a0,1

8000c7a6 <.Lstrlen_aligned>:
8000c7a6:	01010637          	lui	a2,0x1010
8000c7aa:	10160613          	add	a2,a2,257 # 1010101 <_flash_size+0x10101>
8000c7ae:	00761693          	sll	a3,a2,0x7

8000c7b2 <.Lstrlen_wordstrlen>:
8000c7b2:	4118                	lw	a4,0(a0)
8000c7b4:	0511                	add	a0,a0,4
8000c7b6:	40c707b3          	sub	a5,a4,a2
8000c7ba:	fff74713          	not	a4,a4
8000c7be:	8ff9                	and	a5,a5,a4
8000c7c0:	8ff5                	and	a5,a5,a3
8000c7c2:	dbe5                	beqz	a5,8000c7b2 <.Lstrlen_wordstrlen>
8000c7c4:	1571                	add	a0,a0,-4
8000c7c6:	01879713          	sll	a4,a5,0x18
8000c7ca:	eb11                	bnez	a4,8000c7de <.Lstrlen_done>
8000c7cc:	0505                	add	a0,a0,1
8000c7ce:	01079713          	sll	a4,a5,0x10
8000c7d2:	e711                	bnez	a4,8000c7de <.Lstrlen_done>
8000c7d4:	0505                	add	a0,a0,1
8000c7d6:	00879713          	sll	a4,a5,0x8
8000c7da:	e311                	bnez	a4,8000c7de <.Lstrlen_done>
8000c7dc:	0505                	add	a0,a0,1

8000c7de <.Lstrlen_done>:
8000c7de:	8d0d                	sub	a0,a0,a1
8000c7e0:	8082                	ret

Disassembly of section .text.libc.strnlen:

8000c7e2 <strnlen>:
8000c7e2:	862a                	mv	a2,a0
8000c7e4:	852e                	mv	a0,a1
8000c7e6:	c9c9                	beqz	a1,8000c878 <.L528>
8000c7e8:	00064783          	lbu	a5,0(a2)
8000c7ec:	c7c9                	beqz	a5,8000c876 <.L534>
8000c7ee:	00367793          	and	a5,a2,3
8000c7f2:	00379693          	sll	a3,a5,0x3
8000c7f6:	00f58533          	add	a0,a1,a5
8000c7fa:	ffc67713          	and	a4,a2,-4
8000c7fe:	57fd                	li	a5,-1
8000c800:	00d797b3          	sll	a5,a5,a3
8000c804:	4314                	lw	a3,0(a4)
8000c806:	fff7c793          	not	a5,a5
8000c80a:	feff05b7          	lui	a1,0xfeff0
8000c80e:	80808837          	lui	a6,0x80808
8000c812:	8fd5                	or	a5,a5,a3
8000c814:	488d                	li	a7,3
8000c816:	eff58593          	add	a1,a1,-257 # fefefeff <__APB_SRAM_segment_end__+0xaefdeff>
8000c81a:	08080813          	add	a6,a6,128 # 80808080 <__XPI0_segment_used_end__+0x7f7cc8>

8000c81e <.L530>:
8000c81e:	00a8ff63          	bgeu	a7,a0,8000c83c <.L529>
8000c822:	00b786b3          	add	a3,a5,a1
8000c826:	fff7c313          	not	t1,a5
8000c82a:	0066f6b3          	and	a3,a3,t1
8000c82e:	0106f6b3          	and	a3,a3,a6
8000c832:	e689                	bnez	a3,8000c83c <.L529>
8000c834:	0711                	add	a4,a4,4
8000c836:	1571                	add	a0,a0,-4
8000c838:	431c                	lw	a5,0(a4)
8000c83a:	b7d5                	j	8000c81e <.L530>

8000c83c <.L529>:
8000c83c:	0ff7f593          	zext.b	a1,a5
8000c840:	c59d                	beqz	a1,8000c86e <.L531>
8000c842:	0087d593          	srl	a1,a5,0x8
8000c846:	0ff5f593          	zext.b	a1,a1
8000c84a:	4685                	li	a3,1
8000c84c:	cd89                	beqz	a1,8000c866 <.L532>
8000c84e:	0107d593          	srl	a1,a5,0x10
8000c852:	0ff5f593          	zext.b	a1,a1
8000c856:	4689                	li	a3,2
8000c858:	c599                	beqz	a1,8000c866 <.L532>
8000c85a:	010005b7          	lui	a1,0x1000
8000c85e:	468d                	li	a3,3
8000c860:	00b7e363          	bltu	a5,a1,8000c866 <.L532>
8000c864:	4691                	li	a3,4

8000c866 <.L532>:
8000c866:	85aa                	mv	a1,a0
8000c868:	00a6f363          	bgeu	a3,a0,8000c86e <.L531>
8000c86c:	85b6                	mv	a1,a3

8000c86e <.L531>:
8000c86e:	8f11                	sub	a4,a4,a2
8000c870:	00b70533          	add	a0,a4,a1
8000c874:	8082                	ret

8000c876 <.L534>:
8000c876:	4501                	li	a0,0

8000c878 <.L528>:
8000c878:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

8000c87a <__SEGGER_RTL_stream_write>:
8000c87a:	5154                	lw	a3,36(a0)
8000c87c:	87ae                	mv	a5,a1
8000c87e:	853e                	mv	a0,a5
8000c880:	4585                	li	a1,1
8000c882:	afefb06f          	j	80007b80 <fwrite>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

8000c886 <__SEGGER_RTL_putc>:
8000c886:	4918                	lw	a4,16(a0)
8000c888:	1101                	add	sp,sp,-32
8000c88a:	0ff5f593          	zext.b	a1,a1
8000c88e:	cc22                	sw	s0,24(sp)
8000c890:	ce06                	sw	ra,28(sp)
8000c892:	00b107a3          	sb	a1,15(sp)
8000c896:	411c                	lw	a5,0(a0)
8000c898:	842a                	mv	s0,a0
8000c89a:	cb05                	beqz	a4,8000c8ca <.L24>
8000c89c:	4154                	lw	a3,4(a0)
8000c89e:	00d7ff63          	bgeu	a5,a3,8000c8bc <.L26>
8000c8a2:	495c                	lw	a5,20(a0)
8000c8a4:	00178693          	add	a3,a5,1 # 800001 <__DLM_segment_end__+0x740001>
8000c8a8:	973e                	add	a4,a4,a5
8000c8aa:	c954                	sw	a3,20(a0)
8000c8ac:	00b70023          	sb	a1,0(a4)
8000c8b0:	4958                	lw	a4,20(a0)
8000c8b2:	4d1c                	lw	a5,24(a0)
8000c8b4:	00f71463          	bne	a4,a5,8000c8bc <.L26>
8000c8b8:	ba0fc0ef          	jal	80008c58 <__SEGGER_RTL_prin_flush>

8000c8bc <.L26>:
8000c8bc:	401c                	lw	a5,0(s0)
8000c8be:	40f2                	lw	ra,28(sp)
8000c8c0:	0785                	add	a5,a5,1
8000c8c2:	c01c                	sw	a5,0(s0)
8000c8c4:	4462                	lw	s0,24(sp)
8000c8c6:	6105                	add	sp,sp,32
8000c8c8:	8082                	ret

8000c8ca <.L24>:
8000c8ca:	4558                	lw	a4,12(a0)
8000c8cc:	c305                	beqz	a4,8000c8ec <.L28>
8000c8ce:	4154                	lw	a3,4(a0)
8000c8d0:	00178613          	add	a2,a5,1
8000c8d4:	00d61463          	bne	a2,a3,8000c8dc <.L29>
8000c8d8:	000107a3          	sb	zero,15(sp)

8000c8dc <.L29>:
8000c8dc:	fed7f0e3          	bgeu	a5,a3,8000c8bc <.L26>
8000c8e0:	00f14683          	lbu	a3,15(sp)
8000c8e4:	973e                	add	a4,a4,a5
8000c8e6:	00d70023          	sb	a3,0(a4)
8000c8ea:	bfc9                	j	8000c8bc <.L26>

8000c8ec <.L28>:
8000c8ec:	4518                	lw	a4,8(a0)
8000c8ee:	c305                	beqz	a4,8000c90e <.L30>
8000c8f0:	4154                	lw	a3,4(a0)
8000c8f2:	00178613          	add	a2,a5,1
8000c8f6:	00d61463          	bne	a2,a3,8000c8fe <.L31>
8000c8fa:	000107a3          	sb	zero,15(sp)

8000c8fe <.L31>:
8000c8fe:	fad7ffe3          	bgeu	a5,a3,8000c8bc <.L26>
8000c902:	078a                	sll	a5,a5,0x2
8000c904:	973e                	add	a4,a4,a5
8000c906:	00f14783          	lbu	a5,15(sp)
8000c90a:	c31c                	sw	a5,0(a4)
8000c90c:	bf45                	j	8000c8bc <.L26>

8000c90e <.L30>:
8000c90e:	5118                	lw	a4,32(a0)
8000c910:	d755                	beqz	a4,8000c8bc <.L26>
8000c912:	4154                	lw	a3,4(a0)
8000c914:	fad7f4e3          	bgeu	a5,a3,8000c8bc <.L26>
8000c918:	4605                	li	a2,1
8000c91a:	00f10593          	add	a1,sp,15
8000c91e:	9702                	jalr	a4
8000c920:	bf71                	j	8000c8bc <.L26>

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

8000c922 <__SEGGER_RTL_print_padding>:
8000c922:	1141                	add	sp,sp,-16
8000c924:	c422                	sw	s0,8(sp)
8000c926:	c226                	sw	s1,4(sp)
8000c928:	c04a                	sw	s2,0(sp)
8000c92a:	c606                	sw	ra,12(sp)
8000c92c:	84aa                	mv	s1,a0
8000c92e:	892e                	mv	s2,a1
8000c930:	8432                	mv	s0,a2

8000c932 <.L37>:
8000c932:	147d                	add	s0,s0,-1
8000c934:	00045863          	bgez	s0,8000c944 <.L38>
8000c938:	40b2                	lw	ra,12(sp)
8000c93a:	4422                	lw	s0,8(sp)
8000c93c:	4492                	lw	s1,4(sp)
8000c93e:	4902                	lw	s2,0(sp)
8000c940:	0141                	add	sp,sp,16
8000c942:	8082                	ret

8000c944 <.L38>:
8000c944:	85ca                	mv	a1,s2
8000c946:	8526                	mv	a0,s1
8000c948:	3f3d                	jal	8000c886 <__SEGGER_RTL_putc>
8000c94a:	b7e5                	j	8000c932 <.L37>

Disassembly of section .text.libc.vfprintf_l:

8000c94c <vfprintf_l>:
8000c94c:	711d                	add	sp,sp,-96
8000c94e:	ce86                	sw	ra,92(sp)
8000c950:	cca2                	sw	s0,88(sp)
8000c952:	caa6                	sw	s1,84(sp)
8000c954:	1080                	add	s0,sp,96
8000c956:	c8ca                	sw	s2,80(sp)
8000c958:	c6ce                	sw	s3,76(sp)
8000c95a:	8932                	mv	s2,a2
8000c95c:	fad42623          	sw	a3,-84(s0)
8000c960:	89aa                	mv	s3,a0
8000c962:	fab42423          	sw	a1,-88(s0)
8000c966:	ce6fc0ef          	jal	80008e4c <__SEGGER_RTL_X_file_bufsize>
8000c96a:	fa842583          	lw	a1,-88(s0)
8000c96e:	00f50793          	add	a5,a0,15
8000c972:	9bc1                	and	a5,a5,-16
8000c974:	40f10133          	sub	sp,sp,a5
8000c978:	84aa                	mv	s1,a0
8000c97a:	fb840513          	add	a0,s0,-72
8000c97e:	b16fc0ef          	jal	80008c94 <__SEGGER_RTL_init_prin_l>
8000c982:	800007b7          	lui	a5,0x80000
8000c986:	fac42603          	lw	a2,-84(s0)
8000c98a:	17fd                	add	a5,a5,-1 # 7fffffff <_extram_size+0x7dffffff>
8000c98c:	faf42e23          	sw	a5,-68(s0)
8000c990:	8000d7b7          	lui	a5,0x8000d
8000c994:	87a78793          	add	a5,a5,-1926 # 8000c87a <__SEGGER_RTL_stream_write>
8000c998:	85ca                	mv	a1,s2
8000c99a:	fb840513          	add	a0,s0,-72
8000c99e:	fc242423          	sw	sp,-56(s0)
8000c9a2:	fc942823          	sw	s1,-48(s0)
8000c9a6:	fd342e23          	sw	s3,-36(s0)
8000c9aa:	fcf42c23          	sw	a5,-40(s0)
8000c9ae:	2811                	jal	8000c9c2 <__SEGGER_RTL_vfprintf>
8000c9b0:	fa040113          	add	sp,s0,-96
8000c9b4:	40f6                	lw	ra,92(sp)
8000c9b6:	4466                	lw	s0,88(sp)
8000c9b8:	44d6                	lw	s1,84(sp)
8000c9ba:	4946                	lw	s2,80(sp)
8000c9bc:	49b6                	lw	s3,76(sp)
8000c9be:	6125                	add	sp,sp,96
8000c9c0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

8000c9c2 <__SEGGER_RTL_vfprintf>:
8000c9c2:	800047b7          	lui	a5,0x80004
8000c9c6:	7175                	add	sp,sp,-144
8000c9c8:	e8878793          	add	a5,a5,-376 # 80003e88 <.L9>
8000c9cc:	c83e                	sw	a5,16(sp)
8000c9ce:	800047b7          	lui	a5,0x80004
8000c9d2:	dece                	sw	s3,124(sp)
8000c9d4:	dad6                	sw	s5,116(sp)
8000c9d6:	ceee                	sw	s11,92(sp)
8000c9d8:	c706                	sw	ra,140(sp)
8000c9da:	c522                	sw	s0,136(sp)
8000c9dc:	c326                	sw	s1,132(sp)
8000c9de:	c14a                	sw	s2,128(sp)
8000c9e0:	dcd2                	sw	s4,120(sp)
8000c9e2:	d8da                	sw	s6,112(sp)
8000c9e4:	d6de                	sw	s7,108(sp)
8000c9e6:	d4e2                	sw	s8,104(sp)
8000c9e8:	d2e6                	sw	s9,100(sp)
8000c9ea:	d0ea                	sw	s10,96(sp)
8000c9ec:	ecc78793          	add	a5,a5,-308 # 80003ecc <.L45>
8000c9f0:	00020db7          	lui	s11,0x20
8000c9f4:	89aa                	mv	s3,a0
8000c9f6:	8ab2                	mv	s5,a2
8000c9f8:	00052023          	sw	zero,0(a0)
8000c9fc:	ca3e                	sw	a5,20(sp)
8000c9fe:	021d8d93          	add	s11,s11,33 # 20021 <__XPI0_segment_used_size__+0x12c69>

8000ca02 <.L2>:
8000ca02:	00158a13          	add	s4,a1,1 # 1000001 <_flash_size+0x1>
8000ca06:	0005c583          	lbu	a1,0(a1)
8000ca0a:	e19d                	bnez	a1,8000ca30 <.L229>
8000ca0c:	00c9a783          	lw	a5,12(s3)
8000ca10:	cb91                	beqz	a5,8000ca24 <.L230>
8000ca12:	0009a703          	lw	a4,0(s3)
8000ca16:	0049a683          	lw	a3,4(s3)
8000ca1a:	00d77563          	bgeu	a4,a3,8000ca24 <.L230>
8000ca1e:	97ba                	add	a5,a5,a4
8000ca20:	00078023          	sb	zero,0(a5)

8000ca24 <.L230>:
8000ca24:	854e                	mv	a0,s3
8000ca26:	a32fc0ef          	jal	80008c58 <__SEGGER_RTL_prin_flush>
8000ca2a:	0009a503          	lw	a0,0(s3)
8000ca2e:	a2f9                	j	8000cbfc <.L338>

8000ca30 <.L229>:
8000ca30:	02500793          	li	a5,37
8000ca34:	00f58563          	beq	a1,a5,8000ca3e <.L231>

8000ca38 <.L362>:
8000ca38:	854e                	mv	a0,s3
8000ca3a:	35b1                	jal	8000c886 <__SEGGER_RTL_putc>
8000ca3c:	aab9                	j	8000cb9a <.L4>

8000ca3e <.L231>:
8000ca3e:	4b81                	li	s7,0
8000ca40:	03000613          	li	a2,48
8000ca44:	05e00593          	li	a1,94
8000ca48:	6505                	lui	a0,0x1
8000ca4a:	487d                	li	a6,31
8000ca4c:	48c1                	li	a7,16
8000ca4e:	6321                	lui	t1,0x8
8000ca50:	a03d                	j	8000ca7e <.L3>

8000ca52 <.L5>:
8000ca52:	04b78f63          	beq	a5,a1,8000cab0 <.L15>

8000ca56 <.L232>:
8000ca56:	8a36                	mv	s4,a3
8000ca58:	4b01                	li	s6,0
8000ca5a:	46a5                	li	a3,9
8000ca5c:	45a9                	li	a1,10

8000ca5e <.L18>:
8000ca5e:	fd078713          	add	a4,a5,-48
8000ca62:	0ff77613          	zext.b	a2,a4
8000ca66:	08c6e363          	bltu	a3,a2,8000caec <.L20>
8000ca6a:	02bb0b33          	mul	s6,s6,a1
8000ca6e:	0a05                	add	s4,s4,1
8000ca70:	fffa4783          	lbu	a5,-1(s4)
8000ca74:	9b3a                	add	s6,s6,a4
8000ca76:	b7e5                	j	8000ca5e <.L18>

8000ca78 <.L14>:
8000ca78:	040beb93          	or	s7,s7,64

8000ca7c <.L16>:
8000ca7c:	8a36                	mv	s4,a3

8000ca7e <.L3>:
8000ca7e:	000a4783          	lbu	a5,0(s4)
8000ca82:	001a0693          	add	a3,s4,1
8000ca86:	fcf666e3          	bltu	a2,a5,8000ca52 <.L5>
8000ca8a:	fcf876e3          	bgeu	a6,a5,8000ca56 <.L232>
8000ca8e:	fe078713          	add	a4,a5,-32
8000ca92:	0ff77713          	zext.b	a4,a4
8000ca96:	02e8e963          	bltu	a7,a4,8000cac8 <.L7>
8000ca9a:	4442                	lw	s0,16(sp)
8000ca9c:	070a                	sll	a4,a4,0x2
8000ca9e:	9722                	add	a4,a4,s0
8000caa0:	4318                	lw	a4,0(a4)
8000caa2:	8702                	jr	a4

8000caa4 <.L13>:
8000caa4:	080beb93          	or	s7,s7,128
8000caa8:	bfd1                	j	8000ca7c <.L16>

8000caaa <.L12>:
8000caaa:	006bebb3          	or	s7,s7,t1
8000caae:	b7f9                	j	8000ca7c <.L16>

8000cab0 <.L15>:
8000cab0:	00abebb3          	or	s7,s7,a0
8000cab4:	b7e1                	j	8000ca7c <.L16>

8000cab6 <.L11>:
8000cab6:	020beb93          	or	s7,s7,32
8000caba:	b7c9                	j	8000ca7c <.L16>

8000cabc <.L10>:
8000cabc:	010beb93          	or	s7,s7,16
8000cac0:	bf75                	j	8000ca7c <.L16>

8000cac2 <.L8>:
8000cac2:	200beb93          	or	s7,s7,512
8000cac6:	bf5d                	j	8000ca7c <.L16>

8000cac8 <.L7>:
8000cac8:	02a00713          	li	a4,42
8000cacc:	f8e795e3          	bne	a5,a4,8000ca56 <.L232>
8000cad0:	000aab03          	lw	s6,0(s5)
8000cad4:	004a8713          	add	a4,s5,4
8000cad8:	000b5663          	bgez	s6,8000cae4 <.L19>
8000cadc:	41600b33          	neg	s6,s6
8000cae0:	010beb93          	or	s7,s7,16

8000cae4 <.L19>:
8000cae4:	0006c783          	lbu	a5,0(a3) # 800000 <__DLM_segment_end__+0x740000>
8000cae8:	0a09                	add	s4,s4,2
8000caea:	8aba                	mv	s5,a4

8000caec <.L20>:
8000caec:	000b5363          	bgez	s6,8000caf2 <.L22>
8000caf0:	4b01                	li	s6,0

8000caf2 <.L22>:
8000caf2:	02e00713          	li	a4,46
8000caf6:	4481                	li	s1,0
8000caf8:	04e79263          	bne	a5,a4,8000cb3c <.L23>
8000cafc:	000a4783          	lbu	a5,0(s4)
8000cb00:	02a00713          	li	a4,42
8000cb04:	02e78263          	beq	a5,a4,8000cb28 <.L24>
8000cb08:	0a05                	add	s4,s4,1
8000cb0a:	46a5                	li	a3,9
8000cb0c:	45a9                	li	a1,10

8000cb0e <.L25>:
8000cb0e:	fd078713          	add	a4,a5,-48
8000cb12:	0ff77613          	zext.b	a2,a4
8000cb16:	00c6ef63          	bltu	a3,a2,8000cb34 <.L26>
8000cb1a:	02b484b3          	mul	s1,s1,a1
8000cb1e:	0a05                	add	s4,s4,1
8000cb20:	fffa4783          	lbu	a5,-1(s4)
8000cb24:	94ba                	add	s1,s1,a4
8000cb26:	b7e5                	j	8000cb0e <.L25>

8000cb28 <.L24>:
8000cb28:	000aa483          	lw	s1,0(s5)
8000cb2c:	001a4783          	lbu	a5,1(s4)
8000cb30:	0a91                	add	s5,s5,4
8000cb32:	0a09                	add	s4,s4,2

8000cb34 <.L26>:
8000cb34:	0004c463          	bltz	s1,8000cb3c <.L23>
8000cb38:	100beb93          	or	s7,s7,256

8000cb3c <.L23>:
8000cb3c:	06c00713          	li	a4,108
8000cb40:	06e78263          	beq	a5,a4,8000cba4 <.L28>
8000cb44:	02f76c63          	bltu	a4,a5,8000cb7c <.L29>
8000cb48:	06800713          	li	a4,104
8000cb4c:	06e78a63          	beq	a5,a4,8000cbc0 <.L30>
8000cb50:	06a00713          	li	a4,106
8000cb54:	04e78563          	beq	a5,a4,8000cb9e <.L31>

8000cb58 <.L32>:
8000cb58:	05700713          	li	a4,87
8000cb5c:	2ef764e3          	bltu	a4,a5,8000d644 <.L38>
8000cb60:	04500713          	li	a4,69
8000cb64:	2ce78763          	beq	a5,a4,8000ce32 <.L39>
8000cb68:	06f76763          	bltu	a4,a5,8000cbd6 <.L40>
8000cb6c:	c7c1                	beqz	a5,8000cbf4 <.L41>
8000cb6e:	02500713          	li	a4,37
8000cb72:	02500593          	li	a1,37
8000cb76:	ece781e3          	beq	a5,a4,8000ca38 <.L362>
8000cb7a:	a005                	j	8000cb9a <.L4>

8000cb7c <.L29>:
8000cb7c:	07400713          	li	a4,116
8000cb80:	00e78663          	beq	a5,a4,8000cb8c <.L346>
8000cb84:	07a00713          	li	a4,122
8000cb88:	2ae79ae3          	bne	a5,a4,8000d63c <.L34>

8000cb8c <.L346>:
8000cb8c:	000a4783          	lbu	a5,0(s4)
8000cb90:	0a05                	add	s4,s4,1

8000cb92 <.L35>:
8000cb92:	07800713          	li	a4,120
8000cb96:	fcf771e3          	bgeu	a4,a5,8000cb58 <.L32>

8000cb9a <.L4>:
8000cb9a:	85d2                	mv	a1,s4
8000cb9c:	b59d                	j	8000ca02 <.L2>

8000cb9e <.L31>:
8000cb9e:	002beb93          	or	s7,s7,2
8000cba2:	b7ed                	j	8000cb8c <.L346>

8000cba4 <.L28>:
8000cba4:	000a4783          	lbu	a5,0(s4)
8000cba8:	00e79863          	bne	a5,a4,8000cbb8 <.L36>
8000cbac:	002beb93          	or	s7,s7,2

8000cbb0 <.L347>:
8000cbb0:	001a4783          	lbu	a5,1(s4)
8000cbb4:	0a09                	add	s4,s4,2
8000cbb6:	bff1                	j	8000cb92 <.L35>

8000cbb8 <.L36>:
8000cbb8:	0a05                	add	s4,s4,1
8000cbba:	001beb93          	or	s7,s7,1
8000cbbe:	bfd1                	j	8000cb92 <.L35>

8000cbc0 <.L30>:
8000cbc0:	000a4783          	lbu	a5,0(s4)
8000cbc4:	00e79563          	bne	a5,a4,8000cbce <.L37>
8000cbc8:	008beb93          	or	s7,s7,8
8000cbcc:	b7d5                	j	8000cbb0 <.L347>

8000cbce <.L37>:
8000cbce:	0a05                	add	s4,s4,1
8000cbd0:	004beb93          	or	s7,s7,4
8000cbd4:	bf7d                	j	8000cb92 <.L35>

8000cbd6 <.L40>:
8000cbd6:	04600713          	li	a4,70
8000cbda:	2ce78663          	beq	a5,a4,8000cea6 <.L57>
8000cbde:	04700713          	li	a4,71
8000cbe2:	fae79ce3          	bne	a5,a4,8000cb9a <.L4>
8000cbe6:	6789                	lui	a5,0x2
8000cbe8:	00fbebb3          	or	s7,s7,a5

8000cbec <.L52>:
8000cbec:	6905                	lui	s2,0x1
8000cbee:	c0090913          	add	s2,s2,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000cbf2:	a4c1                	j	8000ceb2 <.L353>

8000cbf4 <.L41>:
8000cbf4:	854e                	mv	a0,s3
8000cbf6:	862fc0ef          	jal	80008c58 <__SEGGER_RTL_prin_flush>
8000cbfa:	557d                	li	a0,-1

8000cbfc <.L338>:
8000cbfc:	40ba                	lw	ra,140(sp)
8000cbfe:	442a                	lw	s0,136(sp)
8000cc00:	449a                	lw	s1,132(sp)
8000cc02:	490a                	lw	s2,128(sp)
8000cc04:	59f6                	lw	s3,124(sp)
8000cc06:	5a66                	lw	s4,120(sp)
8000cc08:	5ad6                	lw	s5,116(sp)
8000cc0a:	5b46                	lw	s6,112(sp)
8000cc0c:	5bb6                	lw	s7,108(sp)
8000cc0e:	5c26                	lw	s8,104(sp)
8000cc10:	5c96                	lw	s9,100(sp)
8000cc12:	5d06                	lw	s10,96(sp)
8000cc14:	4df6                	lw	s11,92(sp)
8000cc16:	6149                	add	sp,sp,144
8000cc18:	8082                	ret

8000cc1a <.L55>:
8000cc1a:	000aa483          	lw	s1,0(s5)
8000cc1e:	1b7d                	add	s6,s6,-1
8000cc20:	865a                	mv	a2,s6
8000cc22:	85de                	mv	a1,s7
8000cc24:	854e                	mv	a0,s3
8000cc26:	854fc0ef          	jal	80008c7a <__SEGGER_RTL_pre_padding>
8000cc2a:	004a8413          	add	s0,s5,4
8000cc2e:	0ff4f593          	zext.b	a1,s1
8000cc32:	854e                	mv	a0,s3
8000cc34:	3989                	jal	8000c886 <__SEGGER_RTL_putc>
8000cc36:	8aa2                	mv	s5,s0

8000cc38 <.L371>:
8000cc38:	010bfb93          	and	s7,s7,16
8000cc3c:	f40b8fe3          	beqz	s7,8000cb9a <.L4>
8000cc40:	865a                	mv	a2,s6
8000cc42:	02000593          	li	a1,32
8000cc46:	854e                	mv	a0,s3
8000cc48:	39e9                	jal	8000c922 <__SEGGER_RTL_print_padding>
8000cc4a:	bf81                	j	8000cb9a <.L4>

8000cc4c <.L50>:
8000cc4c:	008bf693          	and	a3,s7,8
8000cc50:	000aa783          	lw	a5,0(s5)
8000cc54:	0009a703          	lw	a4,0(s3)
8000cc58:	0a91                	add	s5,s5,4
8000cc5a:	c681                	beqz	a3,8000cc62 <.L62>
8000cc5c:	00e78023          	sb	a4,0(a5) # 2000 <__APB_SRAM_segment_size__>
8000cc60:	bf2d                	j	8000cb9a <.L4>

8000cc62 <.L62>:
8000cc62:	002bfb93          	and	s7,s7,2
8000cc66:	c398                	sw	a4,0(a5)
8000cc68:	f20b89e3          	beqz	s7,8000cb9a <.L4>
8000cc6c:	0007a223          	sw	zero,4(a5)
8000cc70:	b72d                	j	8000cb9a <.L4>

8000cc72 <.L47>:
8000cc72:	000aa403          	lw	s0,0(s5)
8000cc76:	895e                	mv	s2,s7
8000cc78:	0a91                	add	s5,s5,4

8000cc7a <.L65>:
8000cc7a:	e409                	bnez	s0,8000cc84 <.L66>
8000cc7c:	80004437          	lui	s0,0x80004
8000cc80:	e5840413          	add	s0,s0,-424 # 80003e58 <.LC0>

8000cc84 <.L66>:
8000cc84:	dff97b93          	and	s7,s2,-513
8000cc88:	10097913          	and	s2,s2,256
8000cc8c:	02090563          	beqz	s2,8000ccb6 <.L67>
8000cc90:	85a6                	mv	a1,s1
8000cc92:	8522                	mv	a0,s0
8000cc94:	36b9                	jal	8000c7e2 <strnlen>

8000cc96 <.L348>:
8000cc96:	40ab0b33          	sub	s6,s6,a0
8000cc9a:	84aa                	mv	s1,a0
8000cc9c:	865a                	mv	a2,s6
8000cc9e:	85de                	mv	a1,s7
8000cca0:	854e                	mv	a0,s3
8000cca2:	fd9fb0ef          	jal	80008c7a <__SEGGER_RTL_pre_padding>

8000cca6 <.L69>:
8000cca6:	d8c9                	beqz	s1,8000cc38 <.L371>
8000cca8:	00044583          	lbu	a1,0(s0)
8000ccac:	854e                	mv	a0,s3
8000ccae:	0405                	add	s0,s0,1
8000ccb0:	3ed9                	jal	8000c886 <__SEGGER_RTL_putc>
8000ccb2:	14fd                	add	s1,s1,-1
8000ccb4:	bfcd                	j	8000cca6 <.L69>

8000ccb6 <.L67>:
8000ccb6:	8522                	mv	a0,s0
8000ccb8:	34c9                	jal	8000c77a <strlen>
8000ccba:	bff1                	j	8000cc96 <.L348>

8000ccbc <.L48>:
8000ccbc:	080bf713          	and	a4,s7,128
8000ccc0:	000aa403          	lw	s0,0(s5)
8000ccc4:	004a8693          	add	a3,s5,4
8000ccc8:	4581                	li	a1,0
8000ccca:	02300c93          	li	s9,35
8000ccce:	e311                	bnez	a4,8000ccd2 <.L71>
8000ccd0:	4c81                	li	s9,0

8000ccd2 <.L71>:
8000ccd2:	100beb93          	or	s7,s7,256
8000ccd6:	8ab6                	mv	s5,a3
8000ccd8:	44a1                	li	s1,8

8000ccda <.L72>:
8000ccda:	100bf713          	and	a4,s7,256
8000ccde:	e311                	bnez	a4,8000cce2 <.L203>
8000cce0:	4485                	li	s1,1

8000cce2 <.L203>:
8000cce2:	05800713          	li	a4,88
8000cce6:	08e788e3          	beq	a5,a4,8000d576 <.L204>
8000ccea:	f9c78693          	add	a3,a5,-100
8000ccee:	4705                	li	a4,1
8000ccf0:	00d71733          	sll	a4,a4,a3
8000ccf4:	01b776b3          	and	a3,a4,s11
8000ccf8:	00069ae3          	bnez	a3,8000d50c <.L205>
8000ccfc:	00c75693          	srl	a3,a4,0xc
8000cd00:	1016f693          	and	a3,a3,257
8000cd04:	060699e3          	bnez	a3,8000d576 <.L204>
8000cd08:	06f00713          	li	a4,111
8000cd0c:	4c01                	li	s8,0
8000cd0e:	08e793e3          	bne	a5,a4,8000d594 <.L206>

8000cd12 <.L207>:
8000cd12:	00b467b3          	or	a5,s0,a1
8000cd16:	06078fe3          	beqz	a5,8000d594 <.L206>
8000cd1a:	183c                	add	a5,sp,56
8000cd1c:	01878733          	add	a4,a5,s8
8000cd20:	00747793          	and	a5,s0,7
8000cd24:	03078793          	add	a5,a5,48
8000cd28:	00f70023          	sb	a5,0(a4)
8000cd2c:	800d                	srl	s0,s0,0x3
8000cd2e:	01d59793          	sll	a5,a1,0x1d
8000cd32:	0c05                	add	s8,s8,1
8000cd34:	8c5d                	or	s0,s0,a5
8000cd36:	818d                	srl	a1,a1,0x3
8000cd38:	bfe9                	j	8000cd12 <.L207>

8000cd3a <.L56>:
8000cd3a:	6709                	lui	a4,0x2
8000cd3c:	00ebebb3          	or	s7,s7,a4

8000cd40 <.L44>:
8000cd40:	080bf713          	and	a4,s7,128
8000cd44:	4c81                	li	s9,0
8000cd46:	cb19                	beqz	a4,8000cd5c <.L75>
8000cd48:	6c8d                	lui	s9,0x3
8000cd4a:	07800713          	li	a4,120
8000cd4e:	058c8c93          	add	s9,s9,88 # 3058 <pcfg_dcdc_switch_to_dcm_mode+0xb6>
8000cd52:	00e79563          	bne	a5,a4,8000cd5c <.L75>
8000cd56:	6c8d                	lui	s9,0x3
8000cd58:	078c8c93          	add	s9,s9,120 # 3078 <_ntoa_long+0x4>

8000cd5c <.L75>:
8000cd5c:	100bf713          	and	a4,s7,256

8000cd60 <.L365>:
8000cd60:	c319                	beqz	a4,8000cd66 <.L74>
8000cd62:	dffbfb93          	and	s7,s7,-513

8000cd66 <.L74>:
8000cd66:	011b9613          	sll	a2,s7,0x11
8000cd6a:	002bf713          	and	a4,s7,2
8000cd6e:	004bf693          	and	a3,s7,4
8000cd72:	08065563          	bgez	a2,8000cdfc <.L76>
8000cd76:	cf31                	beqz	a4,8000cdd2 <.L77>
8000cd78:	007a8713          	add	a4,s5,7
8000cd7c:	9b61                	and	a4,a4,-8
8000cd7e:	4300                	lw	s0,0(a4)
8000cd80:	434c                	lw	a1,4(a4)
8000cd82:	00870a93          	add	s5,a4,8 # 2008 <__APB_SRAM_segment_size__+0x8>

8000cd86 <.L78>:
8000cd86:	cea1                	beqz	a3,8000cdde <.L79>
8000cd88:	0442                	sll	s0,s0,0x10
8000cd8a:	8441                	sra	s0,s0,0x10

8000cd8c <.L351>:
8000cd8c:	41f45593          	sra	a1,s0,0x1f

8000cd90 <.L80>:
8000cd90:	0405dd63          	bgez	a1,8000cdea <.L82>
8000cd94:	00803733          	snez	a4,s0
8000cd98:	40b005b3          	neg	a1,a1
8000cd9c:	8d99                	sub	a1,a1,a4
8000cd9e:	40800433          	neg	s0,s0
8000cda2:	02d00c93          	li	s9,45

8000cda6 <.L84>:
8000cda6:	100bf713          	and	a4,s7,256
8000cdaa:	db05                	beqz	a4,8000ccda <.L72>
8000cdac:	dffbfb93          	and	s7,s7,-513
8000cdb0:	b72d                	j	8000ccda <.L72>

8000cdb2 <.L49>:
8000cdb2:	080bf713          	and	a4,s7,128
8000cdb6:	03000c93          	li	s9,48
8000cdba:	f34d                	bnez	a4,8000cd5c <.L75>
8000cdbc:	4c81                	li	s9,0
8000cdbe:	bf79                	j	8000cd5c <.L75>

8000cdc0 <.L46>:
8000cdc0:	100bf713          	and	a4,s7,256
8000cdc4:	4c81                	li	s9,0
8000cdc6:	bf69                	j	8000cd60 <.L365>

8000cdc8 <.L51>:
8000cdc8:	6711                	lui	a4,0x4
8000cdca:	00ebebb3          	or	s7,s7,a4
8000cdce:	4c81                	li	s9,0
8000cdd0:	bf59                	j	8000cd66 <.L74>

8000cdd2 <.L77>:
8000cdd2:	000aa403          	lw	s0,0(s5)
8000cdd6:	0a91                	add	s5,s5,4
8000cdd8:	41f45593          	sra	a1,s0,0x1f
8000cddc:	b76d                	j	8000cd86 <.L78>

8000cdde <.L79>:
8000cdde:	008bf713          	and	a4,s7,8
8000cde2:	d75d                	beqz	a4,8000cd90 <.L80>
8000cde4:	0462                	sll	s0,s0,0x18
8000cde6:	8461                	sra	s0,s0,0x18
8000cde8:	b755                	j	8000cd8c <.L351>

8000cdea <.L82>:
8000cdea:	020bf713          	and	a4,s7,32
8000cdee:	ef1d                	bnez	a4,8000ce2c <.L239>
8000cdf0:	040bf713          	and	a4,s7,64
8000cdf4:	db4d                	beqz	a4,8000cda6 <.L84>
8000cdf6:	02000c93          	li	s9,32
8000cdfa:	b775                	j	8000cda6 <.L84>

8000cdfc <.L76>:
8000cdfc:	cf09                	beqz	a4,8000ce16 <.L85>
8000cdfe:	007a8713          	add	a4,s5,7
8000ce02:	9b61                	and	a4,a4,-8
8000ce04:	4300                	lw	s0,0(a4)
8000ce06:	434c                	lw	a1,4(a4)
8000ce08:	00870a93          	add	s5,a4,8 # 4008 <__HEAPSIZE__+0x8>

8000ce0c <.L86>:
8000ce0c:	ca91                	beqz	a3,8000ce20 <.L87>
8000ce0e:	0442                	sll	s0,s0,0x10
8000ce10:	8041                	srl	s0,s0,0x10

8000ce12 <.L352>:
8000ce12:	4581                	li	a1,0
8000ce14:	bf49                	j	8000cda6 <.L84>

8000ce16 <.L85>:
8000ce16:	000aa403          	lw	s0,0(s5)
8000ce1a:	4581                	li	a1,0
8000ce1c:	0a91                	add	s5,s5,4
8000ce1e:	b7fd                	j	8000ce0c <.L86>

8000ce20 <.L87>:
8000ce20:	008bf713          	and	a4,s7,8
8000ce24:	d349                	beqz	a4,8000cda6 <.L84>
8000ce26:	0ff47413          	zext.b	s0,s0
8000ce2a:	b7e5                	j	8000ce12 <.L352>

8000ce2c <.L239>:
8000ce2c:	02b00c93          	li	s9,43
8000ce30:	bf9d                	j	8000cda6 <.L84>

8000ce32 <.L39>:
8000ce32:	6789                	lui	a5,0x2
8000ce34:	00fbebb3          	or	s7,s7,a5

8000ce38 <.L54>:
8000ce38:	400be913          	or	s2,s7,1024

8000ce3c <.L91>:
8000ce3c:	00297793          	and	a5,s2,2
8000ce40:	cfa5                	beqz	a5,8000ceb8 <.L92>
8000ce42:	000aa783          	lw	a5,0(s5)
8000ce46:	1008                	add	a0,sp,32
8000ce48:	004a8413          	add	s0,s5,4
8000ce4c:	4398                	lw	a4,0(a5)
8000ce4e:	8aa2                	mv	s5,s0
8000ce50:	d03a                	sw	a4,32(sp)
8000ce52:	43d8                	lw	a4,4(a5)
8000ce54:	d23a                	sw	a4,36(sp)
8000ce56:	4798                	lw	a4,8(a5)
8000ce58:	d43a                	sw	a4,40(sp)
8000ce5a:	47dc                	lw	a5,12(a5)
8000ce5c:	d63e                	sw	a5,44(sp)
8000ce5e:	f18ff0ef          	jal	8000c576 <__trunctfsf2>
8000ce62:	8baa                	mv	s7,a0

8000ce64 <.L93>:
8000ce64:	10097793          	and	a5,s2,256
8000ce68:	c3bd                	beqz	a5,8000cece <.L240>
8000ce6a:	e889                	bnez	s1,8000ce7c <.L94>
8000ce6c:	6785                	lui	a5,0x1
8000ce6e:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000ce72:	00f974b3          	and	s1,s2,a5
8000ce76:	8c9d                	sub	s1,s1,a5
8000ce78:	0014b493          	seqz	s1,s1

8000ce7c <.L94>:
8000ce7c:	855e                	mv	a0,s7
8000ce7e:	be4fb0ef          	jal	80008262 <__SEGGER_RTL_float32_isinf>
8000ce82:	c921                	beqz	a0,8000ced2 <.L95>

8000ce84 <.L117>:
8000ce84:	6409                	lui	s0,0x2
8000ce86:	00000593          	li	a1,0
8000ce8a:	855e                	mv	a0,s7
8000ce8c:	00897433          	and	s0,s2,s0
8000ce90:	ef7fa0ef          	jal	80007d86 <__ltsf2>
8000ce94:	40055b63          	bgez	a0,8000d2aa <.L341>
8000ce98:	40040463          	beqz	s0,8000d2a0 <.L244>
8000ce9c:	80004437          	lui	s0,0x80004
8000cea0:	e6040413          	add	s0,s0,-416 # 80003e60 <.LC1>
8000cea4:	a099                	j	8000ceea <.L122>

8000cea6 <.L57>:
8000cea6:	6789                	lui	a5,0x2
8000cea8:	00fbebb3          	or	s7,s7,a5

8000ceac <.L53>:
8000ceac:	6905                	lui	s2,0x1
8000ceae:	80090913          	add	s2,s2,-2048 # 800 <.L195+0xa>

8000ceb2 <.L353>:
8000ceb2:	012be933          	or	s2,s7,s2
8000ceb6:	b759                	j	8000ce3c <.L91>

8000ceb8 <.L92>:
8000ceb8:	007a8793          	add	a5,s5,7
8000cebc:	9be1                	and	a5,a5,-8
8000cebe:	4388                	lw	a0,0(a5)
8000cec0:	43cc                	lw	a1,4(a5)
8000cec2:	00878a93          	add	s5,a5,8 # 2008 <__APB_SRAM_segment_size__+0x8>
8000cec6:	a8afb0ef          	jal	80008150 <__truncdfsf2>
8000ceca:	8baa                	mv	s7,a0
8000cecc:	bf61                	j	8000ce64 <.L93>

8000cece <.L240>:
8000cece:	4499                	li	s1,6
8000ced0:	b775                	j	8000ce7c <.L94>

8000ced2 <.L95>:
8000ced2:	855e                	mv	a0,s7
8000ced4:	b7cfb0ef          	jal	80008250 <__SEGGER_RTL_float32_isnan>
8000ced8:	c10d                	beqz	a0,8000cefa <.L101>
8000ceda:	01291793          	sll	a5,s2,0x12
8000cede:	0007d963          	bgez	a5,8000cef0 <.L243>
8000cee2:	80004437          	lui	s0,0x80004
8000cee6:	e8040413          	add	s0,s0,-384 # 80003e80 <.LC5>

8000ceea <.L122>:
8000ceea:	eff97913          	and	s2,s2,-257
8000ceee:	b371                	j	8000cc7a <.L65>

8000cef0 <.L243>:
8000cef0:	80004437          	lui	s0,0x80004
8000cef4:	e8440413          	add	s0,s0,-380 # 80003e84 <.LC6>
8000cef8:	bfcd                	j	8000ceea <.L122>

8000cefa <.L101>:
8000cefa:	855e                	mv	a0,s7
8000cefc:	b74fb0ef          	jal	80008270 <__SEGGER_RTL_float32_isnormal>
8000cf00:	e119                	bnez	a0,8000cf06 <.L103>
8000cf02:	00000b93          	li	s7,0

8000cf06 <.L103>:
8000cf06:	855e                	mv	a0,s7
8000cf08:	845e                	mv	s0,s7
8000cf0a:	e90ff0ef          	jal	8000c59a <__SEGGER_RTL_float32_signbit>
8000cf0e:	c519                	beqz	a0,8000cf1c <.L104>
8000cf10:	80000437          	lui	s0,0x80000
8000cf14:	06096913          	or	s2,s2,96
8000cf18:	01744433          	xor	s0,s0,s7

8000cf1c <.L104>:
8000cf1c:	184c                	add	a1,sp,52
8000cf1e:	8522                	mv	a0,s0
8000cf20:	ec2ff0ef          	jal	8000c5e2 <frexpf>
8000cf24:	5752                	lw	a4,52(sp)
8000cf26:	478d                	li	a5,3
8000cf28:	00000593          	li	a1,0
8000cf2c:	02e787b3          	mul	a5,a5,a4
8000cf30:	4729                	li	a4,10
8000cf32:	8522                	mv	a0,s0
8000cf34:	8ba2                	mv	s7,s0
8000cf36:	02e7c7b3          	div	a5,a5,a4
8000cf3a:	da3e                	sw	a5,52(sp)
8000cf3c:	ce2ff0ef          	jal	8000c41e <__eqsf2>
8000cf40:	24051a63          	bnez	a0,8000d194 <.L105>

8000cf44 <.L111>:
8000cf44:	6785                	lui	a5,0x1
8000cf46:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000cf4a:	00f97c33          	and	s8,s2,a5
8000cf4e:	40000713          	li	a4,1024
8000cf52:	5552                	lw	a0,52(sp)
8000cf54:	26ec1763          	bne	s8,a4,8000d1c2 <.L340>

8000cf58 <.L106>:
8000cf58:	02600793          	li	a5,38
8000cf5c:	32f51963          	bne	a0,a5,8000d28e <.L113>
8000cf60:	800047b7          	lui	a5,0x80004
8000cf64:	0647a583          	lw	a1,100(a5) # 80004064 <.Lmerged_single+0x10>
8000cf68:	855e                	mv	a0,s7
8000cf6a:	9f0ff0ef          	jal	8000c15a <__divsf3>

8000cf6e <.L354>:
8000cf6e:	00000593          	li	a1,0
8000cf72:	8baa                	mv	s7,a0
8000cf74:	842a                	mv	s0,a0
8000cf76:	ca8ff0ef          	jal	8000c41e <__eqsf2>
8000cf7a:	c52d                	beqz	a0,8000cfe4 <.L116>
8000cf7c:	855e                	mv	a0,s7
8000cf7e:	ae4fb0ef          	jal	80008262 <__SEGGER_RTL_float32_isinf>
8000cf82:	f00511e3          	bnez	a0,8000ce84 <.L117>
8000cf86:	57d2                	lw	a5,52(sp)
8000cf88:	4701                	li	a4,0

8000cf8a <.L118>:
8000cf8a:	80004cb7          	lui	s9,0x80004
8000cf8e:	c63e                	sw	a5,12(sp)
8000cf90:	00178d13          	add	s10,a5,1
8000cf94:	800047b7          	lui	a5,0x80004
8000cf98:	05c7a583          	lw	a1,92(a5) # 8000405c <.Lmerged_single+0x8>
8000cf9c:	855e                	mv	a0,s7
8000cf9e:	cc3a                	sw	a4,24(sp)
8000cfa0:	f15fa0ef          	jal	80007eb4 <__gesf2>
8000cfa4:	47b2                	lw	a5,12(sp)
8000cfa6:	4762                	lw	a4,24(sp)
8000cfa8:	32055163          	bgez	a0,8000d2ca <.L124>
8000cfac:	c319                	beqz	a4,8000cfb2 <.L125>
8000cfae:	845e                	mv	s0,s7
8000cfb0:	da3e                	sw	a5,52(sp)

8000cfb2 <.L125>:
8000cfb2:	80004637          	lui	a2,0x80004
8000cfb6:	05862703          	lw	a4,88(a2) # 80004058 <.Lmerged_single+0x4>
8000cfba:	5d52                	lw	s10,52(sp)
8000cfbc:	05ccac83          	lw	s9,92(s9) # 8000405c <.Lmerged_single+0x8>
8000cfc0:	87a2                	mv	a5,s0
8000cfc2:	4681                	li	a3,0
8000cfc4:	c63a                	sw	a4,12(sp)

8000cfc6 <.L126>:
8000cfc6:	45b2                	lw	a1,12(sp)
8000cfc8:	853e                	mv	a0,a5
8000cfca:	ce36                	sw	a3,28(sp)
8000cfcc:	cc3e                	sw	a5,24(sp)
8000cfce:	db9fa0ef          	jal	80007d86 <__ltsf2>
8000cfd2:	47e2                	lw	a5,24(sp)
8000cfd4:	46f2                	lw	a3,28(sp)
8000cfd6:	fffd0b93          	add	s7,s10,-1
8000cfda:	30054363          	bltz	a0,8000d2e0 <.L127>
8000cfde:	c299                	beqz	a3,8000cfe4 <.L116>
8000cfe0:	843e                	mv	s0,a5
8000cfe2:	da6a                	sw	s10,52(sp)

8000cfe4 <.L116>:
8000cfe4:	c499                	beqz	s1,8000cff2 <.L129>
8000cfe6:	6785                	lui	a5,0x1
8000cfe8:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000cfec:	00fc1363          	bne	s8,a5,8000cff2 <.L129>
8000cff0:	14fd                	add	s1,s1,-1

8000cff2 <.L129>:
8000cff2:	40900533          	neg	a0,s1
8000cff6:	c09fb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000cffa:	55fd                	li	a1,-1
8000cffc:	da2ff0ef          	jal	8000c59e <ldexpf>
8000d000:	85a2                	mv	a1,s0
8000d002:	bd7fa0ef          	jal	80007bd8 <__addsf3>
8000d006:	80004cb7          	lui	s9,0x80004
8000d00a:	05cca583          	lw	a1,92(s9) # 8000405c <.Lmerged_single+0x8>
8000d00e:	8baa                	mv	s7,a0
8000d010:	842a                	mv	s0,a0
8000d012:	ea3fa0ef          	jal	80007eb4 <__gesf2>
8000d016:	00054b63          	bltz	a0,8000d02c <.L130>
8000d01a:	57d2                	lw	a5,52(sp)
8000d01c:	05cca583          	lw	a1,92(s9)
8000d020:	855e                	mv	a0,s7
8000d022:	0785                	add	a5,a5,1
8000d024:	da3e                	sw	a5,52(sp)
8000d026:	934ff0ef          	jal	8000c15a <__divsf3>
8000d02a:	842a                	mv	s0,a0

8000d02c <.L130>:
8000d02c:	c622                	sw	s0,12(sp)
8000d02e:	2c049163          	bnez	s1,8000d2f0 <.L132>

8000d032 <.L135>:
8000d032:	4481                	li	s1,0

8000d034 <.L133>:
8000d034:	00548793          	add	a5,s1,5
8000d038:	7c7d                	lui	s8,0xfffff
8000d03a:	40fb0b33          	sub	s6,s6,a5
8000d03e:	08097793          	and	a5,s2,128
8000d042:	7ffc0c13          	add	s8,s8,2047 # fffff7ff <__APB_SRAM_segment_end__+0xbf0d7ff>
8000d046:	8fc5                	or	a5,a5,s1
8000d048:	01897c33          	and	s8,s2,s8
8000d04c:	c391                	beqz	a5,8000d050 <.L139>
8000d04e:	1b7d                	add	s6,s6,-1

8000d050 <.L139>:
8000d050:	01391793          	sll	a5,s2,0x13
8000d054:	4d05                	li	s10,1
8000d056:	0207dc63          	bgez	a5,8000d08e <.L140>
8000d05a:	5bd2                	lw	s7,52(sp)
8000d05c:	470d                	li	a4,3
8000d05e:	02ebe733          	rem	a4,s7,a4
8000d062:	c31d                	beqz	a4,8000d088 <.L141>
8000d064:	0709                	add	a4,a4,2
8000d066:	56b5                	li	a3,-19
8000d068:	40e6d733          	sra	a4,a3,a4
8000d06c:	8b05                	and	a4,a4,1
8000d06e:	2c070e63          	beqz	a4,8000d34a <.L142>
8000d072:	05cca583          	lw	a1,92(s9)
8000d076:	4532                	lw	a0,12(sp)
8000d078:	1b7d                	add	s6,s6,-1
8000d07a:	4d09                	li	s10,2
8000d07c:	f1ffe0ef          	jal	8000bf9a <__mulsf3>
8000d080:	fffb8793          	add	a5,s7,-1
8000d084:	842a                	mv	s0,a0
8000d086:	da3e                	sw	a5,52(sp)

8000d088 <.L141>:
8000d088:	0004d363          	bgez	s1,8000d08e <.L140>
8000d08c:	4481                	li	s1,0

8000d08e <.L140>:
8000d08e:	06097913          	and	s2,s2,96
8000d092:	00090363          	beqz	s2,8000d098 <.L144>
8000d096:	1b7d                	add	s6,s6,-1

8000d098 <.L144>:
8000d098:	5552                	lw	a0,52(sp)
8000d09a:	ad5fb0ef          	jal	80008b6e <abs>
8000d09e:	06300793          	li	a5,99
8000d0a2:	00a7d363          	bge	a5,a0,8000d0a8 <.L145>
8000d0a6:	1b7d                	add	s6,s6,-1

8000d0a8 <.L145>:
8000d0a8:	8522                	mv	a0,s0
8000d0aa:	c24ff0ef          	jal	8000c4ce <__fixunssfdi>
8000d0ae:	8bae                	mv	s7,a1
8000d0b0:	8caa                	mv	s9,a0
8000d0b2:	ff5fa0ef          	jal	800080a6 <__floatundisf>
8000d0b6:	85aa                	mv	a1,a0
8000d0b8:	8522                	mv	a0,s0
8000d0ba:	b0dfa0ef          	jal	80007bc6 <__subsf3>
8000d0be:	842a                	mv	s0,a0

8000d0c0 <.L146>:
8000d0c0:	895a                	mv	s2,s6
8000d0c2:	000b5363          	bgez	s6,8000d0c8 <.L165>
8000d0c6:	4901                	li	s2,0

8000d0c8 <.L165>:
8000d0c8:	210c7793          	and	a5,s8,528
8000d0cc:	e399                	bnez	a5,8000d0d2 <.L167>

8000d0ce <.L166>:
8000d0ce:	30091b63          	bnez	s2,8000d3e4 <.L168>

8000d0d2 <.L167>:
8000d0d2:	020c7713          	and	a4,s8,32
8000d0d6:	040c7793          	and	a5,s8,64
8000d0da:	30070c63          	beqz	a4,8000d3f2 <.L169>
8000d0de:	02b00593          	li	a1,43
8000d0e2:	c399                	beqz	a5,8000d0e8 <.L358>
8000d0e4:	02d00593          	li	a1,45

8000d0e8 <.L358>:
8000d0e8:	854e                	mv	a0,s3
8000d0ea:	f9cff0ef          	jal	8000c886 <__SEGGER_RTL_putc>

8000d0ee <.L171>:
8000d0ee:	010c7793          	and	a5,s8,16
8000d0f2:	e399                	bnez	a5,8000d0f8 <.L173>

8000d0f4 <.L172>:
8000d0f4:	30091463          	bnez	s2,8000d3fc <.L174>

8000d0f8 <.L173>:
8000d0f8:	80003b37          	lui	s6,0x80003
8000d0fc:	338b0b13          	add	s6,s6,824 # 80003338 <__SEGGER_RTL_ipow10>

8000d100 <.L178>:
8000d100:	1d7d                	add	s10,s10,-1
8000d102:	003d1793          	sll	a5,s10,0x3
8000d106:	97da                	add	a5,a5,s6
8000d108:	4398                	lw	a4,0(a5)
8000d10a:	43dc                	lw	a5,4(a5)
8000d10c:	03000593          	li	a1,48

8000d110 <.L175>:
8000d110:	00fbe663          	bltu	s7,a5,8000d11c <.L258>
8000d114:	2f779b63          	bne	a5,s7,8000d40a <.L176>
8000d118:	2eecf963          	bgeu	s9,a4,8000d40a <.L176>

8000d11c <.L258>:
8000d11c:	854e                	mv	a0,s3
8000d11e:	f68ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d122:	fc0d1fe3          	bnez	s10,8000d100 <.L178>
8000d126:	6b85                	lui	s7,0x1
8000d128:	800b8b93          	add	s7,s7,-2048 # 800 <.L195+0xa>
8000d12c:	017c7bb3          	and	s7,s8,s7
8000d130:	300b9163          	bnez	s7,8000d432 <.L179>

8000d134 <.L183>:
8000d134:	080c7793          	and	a5,s8,128
8000d138:	8fc5                	or	a5,a5,s1
8000d13a:	c3a1                	beqz	a5,8000d17a <.L181>
8000d13c:	02e00593          	li	a1,46
8000d140:	854e                	mv	a0,s3
8000d142:	f44ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d146:	47c1                	li	a5,16
8000d148:	8ca6                	mv	s9,s1
8000d14a:	2e97d863          	bge	a5,s1,8000d43a <.L186>
8000d14e:	4cc1                	li	s9,16

8000d150 <.L187>:
8000d150:	419484b3          	sub	s1,s1,s9
8000d154:	8566                	mv	a0,s9
8000d156:	000b8563          	beqz	s7,8000d160 <.L359>
8000d15a:	5552                	lw	a0,52(sp)
8000d15c:	40ac8533          	sub	a0,s9,a0

8000d160 <.L359>:
8000d160:	a9ffb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d164:	85a2                	mv	a1,s0
8000d166:	e35fe0ef          	jal	8000bf9a <__mulsf3>
8000d16a:	b64ff0ef          	jal	8000c4ce <__fixunssfdi>
8000d16e:	8baa                	mv	s7,a0
8000d170:	842e                	mv	s0,a1

8000d172 <.L193>:
8000d172:	2c0c9863          	bnez	s9,8000d442 <.L194>

8000d176 <.L195>:
8000d176:	30049363          	bnez	s1,8000d47c <.L196>

8000d17a <.L181>:
8000d17a:	400c7793          	and	a5,s8,1024
8000d17e:	30079663          	bnez	a5,8000d48a <.L184>

8000d182 <.L201>:
8000d182:	a0090ce3          	beqz	s2,8000cb9a <.L4>
8000d186:	197d                	add	s2,s2,-1
8000d188:	02000593          	li	a1,32
8000d18c:	a6b5                	j	8000d4f8 <.L360>

8000d18e <.L108>:
8000d18e:	57d2                	lw	a5,52(sp)
8000d190:	0785                	add	a5,a5,1
8000d192:	da3e                	sw	a5,52(sp)

8000d194 <.L105>:
8000d194:	5552                	lw	a0,52(sp)
8000d196:	0505                	add	a0,a0,1 # 1001 <__fw_size__+0x1>
8000d198:	a67fb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d19c:	85aa                	mv	a1,a0
8000d19e:	855e                	mv	a0,s7
8000d1a0:	c9dfa0ef          	jal	80007e3c <__gtsf2>
8000d1a4:	fea045e3          	bgtz	a0,8000d18e <.L108>

8000d1a8 <.L109>:
8000d1a8:	5552                	lw	a0,52(sp)
8000d1aa:	a55fb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d1ae:	85aa                	mv	a1,a0
8000d1b0:	855e                	mv	a0,s7
8000d1b2:	bd5fa0ef          	jal	80007d86 <__ltsf2>
8000d1b6:	d80557e3          	bgez	a0,8000cf44 <.L111>
8000d1ba:	57d2                	lw	a5,52(sp)
8000d1bc:	17fd                	add	a5,a5,-1
8000d1be:	da3e                	sw	a5,52(sp)
8000d1c0:	b7e5                	j	8000d1a8 <.L109>

8000d1c2 <.L340>:
8000d1c2:	00fc1763          	bne	s8,a5,8000d1d0 <.L112>
8000d1c6:	d89559e3          	bge	a0,s1,8000cf58 <.L106>
8000d1ca:	57f1                	li	a5,-4
8000d1cc:	0cf54163          	blt	a0,a5,8000d28e <.L113>

8000d1d0 <.L112>:
8000d1d0:	08097793          	and	a5,s2,128
8000d1d4:	c63e                	sw	a5,12(sp)
8000d1d6:	40097793          	and	a5,s2,1024
8000d1da:	c789                	beqz	a5,8000d1e4 <.L147>
8000d1dc:	47b9                	li	a5,14
8000d1de:	18a7d463          	bge	a5,a0,8000d366 <.L148>

8000d1e2 <.L153>:
8000d1e2:	4481                	li	s1,0

8000d1e4 <.L147>:
8000d1e4:	57d2                	lw	a5,52(sp)
8000d1e6:	40900533          	neg	a0,s1
8000d1ea:	bff97c13          	and	s8,s2,-1025
8000d1ee:	ff178713          	add	a4,a5,-15
8000d1f2:	00e55463          	bge	a0,a4,8000d1fa <.L154>
8000d1f6:	ff078513          	add	a0,a5,-16

8000d1fa <.L154>:
8000d1fa:	a05fb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d1fe:	55fd                	li	a1,-1
8000d200:	b9eff0ef          	jal	8000c59e <ldexpf>
8000d204:	85aa                	mv	a1,a0
8000d206:	855e                	mv	a0,s7
8000d208:	9d1fa0ef          	jal	80007bd8 <__addsf3>
8000d20c:	8d2a                	mv	s10,a0
8000d20e:	842a                	mv	s0,a0
8000d210:	5552                	lw	a0,52(sp)
8000d212:	0505                	add	a0,a0,1
8000d214:	9ebfb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d218:	85ea                	mv	a1,s10
8000d21a:	bedfa0ef          	jal	80007e06 <__lesf2>
8000d21e:	00a04563          	bgtz	a0,8000d228 <.L156>
8000d222:	57d2                	lw	a5,52(sp)
8000d224:	0785                	add	a5,a5,1
8000d226:	da3e                	sw	a5,52(sp)

8000d228 <.L156>:
8000d228:	57d2                	lw	a5,52(sp)
8000d22a:	1a07c763          	bltz	a5,8000d3d8 <.L158>
8000d22e:	4541                	li	a0,16
8000d230:	18f55663          	bge	a0,a5,8000d3bc <.L159>
8000d234:	ff078713          	add	a4,a5,-16
8000d238:	8d1d                	sub	a0,a0,a5
8000d23a:	da3a                	sw	a4,52(sp)
8000d23c:	9c3fb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d240:	85ea                	mv	a1,s10
8000d242:	d59fe0ef          	jal	8000bf9a <__mulsf3>
8000d246:	a88ff0ef          	jal	8000c4ce <__fixunssfdi>
8000d24a:	8caa                	mv	s9,a0
8000d24c:	8bae                	mv	s7,a1
8000d24e:	00000413          	li	s0,0

8000d252 <.L160>:
8000d252:	800037b7          	lui	a5,0x80003
8000d256:	33878793          	add	a5,a5,824 # 80003338 <__SEGGER_RTL_ipow10>
8000d25a:	4d05                	li	s10,1

8000d25c <.L161>:
8000d25c:	47d8                	lw	a4,12(a5)
8000d25e:	07a1                	add	a5,a5,8
8000d260:	00ebe763          	bltu	s7,a4,8000d26e <.L257>
8000d264:	17771e63          	bne	a4,s7,8000d3e0 <.L162>
8000d268:	4398                	lw	a4,0(a5)
8000d26a:	16ecfb63          	bgeu	s9,a4,8000d3e0 <.L162>

8000d26e <.L257>:
8000d26e:	5752                	lw	a4,52(sp)
8000d270:	009d07b3          	add	a5,s10,s1
8000d274:	97ba                	add	a5,a5,a4
8000d276:	40fb0b33          	sub	s6,s6,a5
8000d27a:	47b2                	lw	a5,12(sp)
8000d27c:	8fc5                	or	a5,a5,s1
8000d27e:	c391                	beqz	a5,8000d282 <.L164>
8000d280:	1b7d                	add	s6,s6,-1

8000d282 <.L164>:
8000d282:	06097793          	and	a5,s2,96
8000d286:	e2078de3          	beqz	a5,8000d0c0 <.L146>
8000d28a:	1b7d                	add	s6,s6,-1
8000d28c:	bd15                	j	8000d0c0 <.L146>

8000d28e <.L113>:
8000d28e:	40a00533          	neg	a0,a0
8000d292:	96dfb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d296:	85aa                	mv	a1,a0
8000d298:	855e                	mv	a0,s7
8000d29a:	d01fe0ef          	jal	8000bf9a <__mulsf3>
8000d29e:	b9c1                	j	8000cf6e <.L354>

8000d2a0 <.L244>:
8000d2a0:	80004437          	lui	s0,0x80004
8000d2a4:	e6840413          	add	s0,s0,-408 # 80003e68 <.LC2>
8000d2a8:	b189                	j	8000ceea <.L122>

8000d2aa <.L341>:
8000d2aa:	c819                	beqz	s0,8000d2c0 <.L245>
8000d2ac:	80004437          	lui	s0,0x80004
8000d2b0:	e7040413          	add	s0,s0,-400 # 80003e70 <.LC3>

8000d2b4 <.L123>:
8000d2b4:	02097793          	and	a5,s2,32
8000d2b8:	c20799e3          	bnez	a5,8000ceea <.L122>
8000d2bc:	0405                	add	s0,s0,1
8000d2be:	b135                	j	8000ceea <.L122>

8000d2c0 <.L245>:
8000d2c0:	80004437          	lui	s0,0x80004
8000d2c4:	e7840413          	add	s0,s0,-392 # 80003e78 <.LC4>
8000d2c8:	b7f5                	j	8000d2b4 <.L123>

8000d2ca <.L124>:
8000d2ca:	800047b7          	lui	a5,0x80004
8000d2ce:	05c7a583          	lw	a1,92(a5) # 8000405c <.Lmerged_single+0x8>
8000d2d2:	855e                	mv	a0,s7
8000d2d4:	e87fe0ef          	jal	8000c15a <__divsf3>
8000d2d8:	8baa                	mv	s7,a0
8000d2da:	87ea                	mv	a5,s10
8000d2dc:	4705                	li	a4,1
8000d2de:	b175                	j	8000cf8a <.L118>

8000d2e0 <.L127>:
8000d2e0:	853e                	mv	a0,a5
8000d2e2:	85e6                	mv	a1,s9
8000d2e4:	cb7fe0ef          	jal	8000bf9a <__mulsf3>
8000d2e8:	87aa                	mv	a5,a0
8000d2ea:	8d5e                	mv	s10,s7
8000d2ec:	4685                	li	a3,1
8000d2ee:	b9e1                	j	8000cfc6 <.L126>

8000d2f0 <.L132>:
8000d2f0:	6785                	lui	a5,0x1
8000d2f2:	88078793          	add	a5,a5,-1920 # 880 <.L267+0x2>
8000d2f6:	00f977b3          	and	a5,s2,a5
8000d2fa:	80078793          	add	a5,a5,-2048
8000d2fe:	d2079be3          	bnez	a5,8000d034 <.L133>
8000d302:	47c1                	li	a5,16
8000d304:	0097d363          	bge	a5,s1,8000d30a <.L134>
8000d308:	44c1                	li	s1,16

8000d30a <.L134>:
8000d30a:	8526                	mv	a0,s1
8000d30c:	8f3fb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d310:	85a2                	mv	a1,s0
8000d312:	c89fe0ef          	jal	8000bf9a <__mulsf3>
8000d316:	9b8ff0ef          	jal	8000c4ce <__fixunssfdi>
8000d31a:	00a5e7b3          	or	a5,a1,a0
8000d31e:	8c2a                	mv	s8,a0
8000d320:	8d2e                	mv	s10,a1
8000d322:	d00788e3          	beqz	a5,8000d032 <.L135>

8000d326 <.L357>:
8000d326:	4629                	li	a2,10
8000d328:	4681                	li	a3,0
8000d32a:	c08fb0ef          	jal	80008732 <__umoddi3>
8000d32e:	8d4d                	or	a0,a0,a1
8000d330:	d00512e3          	bnez	a0,8000d034 <.L133>
8000d334:	8562                	mv	a0,s8
8000d336:	85ea                	mv	a1,s10
8000d338:	4629                	li	a2,10
8000d33a:	4681                	li	a3,0
8000d33c:	fd7fa0ef          	jal	80008312 <__udivdi3>
8000d340:	14fd                	add	s1,s1,-1
8000d342:	8c2a                	mv	s8,a0
8000d344:	8d2e                	mv	s10,a1
8000d346:	f0e5                	bnez	s1,8000d326 <.L357>
8000d348:	b1ed                	j	8000d032 <.L135>

8000d34a <.L142>:
8000d34a:	80004737          	lui	a4,0x80004
8000d34e:	06072583          	lw	a1,96(a4) # 80004060 <.Lmerged_single+0xc>
8000d352:	4532                	lw	a0,12(sp)
8000d354:	1b79                	add	s6,s6,-2
8000d356:	4d0d                	li	s10,3
8000d358:	c43fe0ef          	jal	8000bf9a <__mulsf3>
8000d35c:	ffeb8793          	add	a5,s7,-2
8000d360:	842a                	mv	s0,a0
8000d362:	da3e                	sw	a5,52(sp)
8000d364:	b315                	j	8000d088 <.L141>

8000d366 <.L148>:
8000d366:	0505                	add	a0,a0,1
8000d368:	8c89                	sub	s1,s1,a0
8000d36a:	47c1                	li	a5,16
8000d36c:	0097d363          	bge	a5,s1,8000d372 <.L149>
8000d370:	44c1                	li	s1,16

8000d372 <.L149>:
8000d372:	08097793          	and	a5,s2,128
8000d376:	e60797e3          	bnez	a5,8000d1e4 <.L147>
8000d37a:	800047b7          	lui	a5,0x80004
8000d37e:	0547ac03          	lw	s8,84(a5) # 80004054 <.Lmerged_single>
8000d382:	800047b7          	lui	a5,0x80004
8000d386:	05c7a403          	lw	s0,92(a5) # 8000405c <.Lmerged_single+0x8>

8000d38a <.L150>:
8000d38a:	e4048ce3          	beqz	s1,8000d1e2 <.L153>
8000d38e:	8526                	mv	a0,s1
8000d390:	86ffb0ef          	jal	80008bfe <__SEGGER_RTL_pow10f>
8000d394:	85aa                	mv	a1,a0
8000d396:	855e                	mv	a0,s7
8000d398:	c03fe0ef          	jal	8000bf9a <__mulsf3>
8000d39c:	85e2                	mv	a1,s8
8000d39e:	83bfa0ef          	jal	80007bd8 <__addsf3>
8000d3a2:	ee1fa0ef          	jal	80008282 <floorf>
8000d3a6:	85a2                	mv	a1,s0
8000d3a8:	a66ff0ef          	jal	8000c60e <fmodf>
8000d3ac:	00000593          	li	a1,0
8000d3b0:	86eff0ef          	jal	8000c41e <__eqsf2>
8000d3b4:	e20518e3          	bnez	a0,8000d1e4 <.L147>
8000d3b8:	14fd                	add	s1,s1,-1
8000d3ba:	bfc1                	j	8000d38a <.L150>

8000d3bc <.L159>:
8000d3bc:	856a                	mv	a0,s10
8000d3be:	da02                	sw	zero,52(sp)
8000d3c0:	90eff0ef          	jal	8000c4ce <__fixunssfdi>
8000d3c4:	8bae                	mv	s7,a1
8000d3c6:	8caa                	mv	s9,a0
8000d3c8:	cdffa0ef          	jal	800080a6 <__floatundisf>
8000d3cc:	85aa                	mv	a1,a0
8000d3ce:	856a                	mv	a0,s10
8000d3d0:	ff6fa0ef          	jal	80007bc6 <__subsf3>
8000d3d4:	842a                	mv	s0,a0
8000d3d6:	bdb5                	j	8000d252 <.L160>

8000d3d8 <.L158>:
8000d3d8:	da02                	sw	zero,52(sp)
8000d3da:	4c81                	li	s9,0
8000d3dc:	4b81                	li	s7,0
8000d3de:	bd95                	j	8000d252 <.L160>

8000d3e0 <.L162>:
8000d3e0:	0d05                	add	s10,s10,1
8000d3e2:	bdad                	j	8000d25c <.L161>

8000d3e4 <.L168>:
8000d3e4:	02000593          	li	a1,32
8000d3e8:	854e                	mv	a0,s3
8000d3ea:	197d                	add	s2,s2,-1
8000d3ec:	c9aff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d3f0:	b9f9                	j	8000d0ce <.L166>

8000d3f2 <.L169>:
8000d3f2:	ce078ee3          	beqz	a5,8000d0ee <.L171>
8000d3f6:	02000593          	li	a1,32
8000d3fa:	b1fd                	j	8000d0e8 <.L358>

8000d3fc <.L174>:
8000d3fc:	03000593          	li	a1,48
8000d400:	854e                	mv	a0,s3
8000d402:	197d                	add	s2,s2,-1
8000d404:	c82ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d408:	b1f5                	j	8000d0f4 <.L172>

8000d40a <.L176>:
8000d40a:	40ec86b3          	sub	a3,s9,a4
8000d40e:	00dcb633          	sltu	a2,s9,a3
8000d412:	0585                	add	a1,a1,1
8000d414:	40fb8bb3          	sub	s7,s7,a5
8000d418:	0ff5f593          	zext.b	a1,a1
8000d41c:	8cb6                	mv	s9,a3
8000d41e:	40cb8bb3          	sub	s7,s7,a2
8000d422:	b1fd                	j	8000d110 <.L175>

8000d424 <.L182>:
8000d424:	17fd                	add	a5,a5,-1
8000d426:	03000593          	li	a1,48
8000d42a:	854e                	mv	a0,s3
8000d42c:	da3e                	sw	a5,52(sp)
8000d42e:	c58ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>

8000d432 <.L179>:
8000d432:	57d2                	lw	a5,52(sp)
8000d434:	fef048e3          	bgtz	a5,8000d424 <.L182>
8000d438:	b9f5                	j	8000d134 <.L183>

8000d43a <.L186>:
8000d43a:	d004dbe3          	bgez	s1,8000d150 <.L187>
8000d43e:	4c81                	li	s9,0
8000d440:	bb01                	j	8000d150 <.L187>

8000d442 <.L194>:
8000d442:	1cfd                	add	s9,s9,-1
8000d444:	003c9793          	sll	a5,s9,0x3
8000d448:	97da                	add	a5,a5,s6
8000d44a:	4398                	lw	a4,0(a5)
8000d44c:	43dc                	lw	a5,4(a5)
8000d44e:	03000593          	li	a1,48

8000d452 <.L190>:
8000d452:	00f46663          	bltu	s0,a5,8000d45e <.L259>
8000d456:	00879863          	bne	a5,s0,8000d466 <.L191>
8000d45a:	00ebf663          	bgeu	s7,a4,8000d466 <.L191>

8000d45e <.L259>:
8000d45e:	854e                	mv	a0,s3
8000d460:	c26ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d464:	b339                	j	8000d172 <.L193>

8000d466 <.L191>:
8000d466:	40eb86b3          	sub	a3,s7,a4
8000d46a:	00dbb633          	sltu	a2,s7,a3
8000d46e:	0585                	add	a1,a1,1
8000d470:	8c1d                	sub	s0,s0,a5
8000d472:	0ff5f593          	zext.b	a1,a1
8000d476:	8bb6                	mv	s7,a3
8000d478:	8c11                	sub	s0,s0,a2
8000d47a:	bfe1                	j	8000d452 <.L190>

8000d47c <.L196>:
8000d47c:	03000593          	li	a1,48
8000d480:	854e                	mv	a0,s3
8000d482:	14fd                	add	s1,s1,-1
8000d484:	c02ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d488:	b1fd                	j	8000d176 <.L195>

8000d48a <.L184>:
8000d48a:	012c1793          	sll	a5,s8,0x12
8000d48e:	06500593          	li	a1,101
8000d492:	0007d463          	bgez	a5,8000d49a <.L197>
8000d496:	04500593          	li	a1,69

8000d49a <.L197>:
8000d49a:	854e                	mv	a0,s3
8000d49c:	beaff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d4a0:	57d2                	lw	a5,52(sp)
8000d4a2:	0407df63          	bgez	a5,8000d500 <.L198>
8000d4a6:	02d00593          	li	a1,45
8000d4aa:	854e                	mv	a0,s3
8000d4ac:	bdaff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d4b0:	57d2                	lw	a5,52(sp)
8000d4b2:	40f007b3          	neg	a5,a5
8000d4b6:	da3e                	sw	a5,52(sp)

8000d4b8 <.L199>:
8000d4b8:	55d2                	lw	a1,52(sp)
8000d4ba:	06300793          	li	a5,99
8000d4be:	00b7df63          	bge	a5,a1,8000d4dc <.L200>
8000d4c2:	06400413          	li	s0,100
8000d4c6:	0285c5b3          	div	a1,a1,s0
8000d4ca:	854e                	mv	a0,s3
8000d4cc:	03058593          	add	a1,a1,48
8000d4d0:	bb6ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d4d4:	57d2                	lw	a5,52(sp)
8000d4d6:	0287e7b3          	rem	a5,a5,s0
8000d4da:	da3e                	sw	a5,52(sp)

8000d4dc <.L200>:
8000d4dc:	55d2                	lw	a1,52(sp)
8000d4de:	4429                	li	s0,10
8000d4e0:	854e                	mv	a0,s3
8000d4e2:	0285c5b3          	div	a1,a1,s0
8000d4e6:	03058593          	add	a1,a1,48
8000d4ea:	b9cff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d4ee:	55d2                	lw	a1,52(sp)
8000d4f0:	0285e5b3          	rem	a1,a1,s0
8000d4f4:	03058593          	add	a1,a1,48

8000d4f8 <.L360>:
8000d4f8:	854e                	mv	a0,s3
8000d4fa:	b8cff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d4fe:	b151                	j	8000d182 <.L201>

8000d500 <.L198>:
8000d500:	02b00593          	li	a1,43
8000d504:	854e                	mv	a0,s3
8000d506:	b80ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d50a:	b77d                	j	8000d4b8 <.L199>

8000d50c <.L205>:
8000d50c:	6d21                	lui	s10,0x8
8000d50e:	892e                	mv	s2,a1
8000d510:	4c01                	li	s8,0
8000d512:	01abfd33          	and	s10,s7,s10
8000d516:	470d                	li	a4,3
8000d518:	02c00813          	li	a6,44

8000d51c <.L208>:
8000d51c:	012467b3          	or	a5,s0,s2
8000d520:	cbb5                	beqz	a5,8000d594 <.L206>
8000d522:	000d0d63          	beqz	s10,8000d53c <.L214>
8000d526:	003c7793          	and	a5,s8,3
8000d52a:	00e79963          	bne	a5,a4,8000d53c <.L214>
8000d52e:	030c0793          	add	a5,s8,48
8000d532:	1018                	add	a4,sp,32
8000d534:	97ba                	add	a5,a5,a4
8000d536:	ff078423          	sb	a6,-24(a5)
8000d53a:	0c05                	add	s8,s8,1

8000d53c <.L214>:
8000d53c:	1018                	add	a4,sp,32
8000d53e:	030c0793          	add	a5,s8,48
8000d542:	97ba                	add	a5,a5,a4
8000d544:	4629                	li	a2,10
8000d546:	4681                	li	a3,0
8000d548:	8522                	mv	a0,s0
8000d54a:	85ca                	mv	a1,s2
8000d54c:	c63e                	sw	a5,12(sp)
8000d54e:	9e4fb0ef          	jal	80008732 <__umoddi3>
8000d552:	47b2                	lw	a5,12(sp)
8000d554:	03050513          	add	a0,a0,48
8000d558:	85ca                	mv	a1,s2
8000d55a:	fea78423          	sb	a0,-24(a5)
8000d55e:	4629                	li	a2,10
8000d560:	8522                	mv	a0,s0
8000d562:	4681                	li	a3,0
8000d564:	daffa0ef          	jal	80008312 <__udivdi3>
8000d568:	0c05                	add	s8,s8,1
8000d56a:	842a                	mv	s0,a0
8000d56c:	892e                	mv	s2,a1
8000d56e:	02c00813          	li	a6,44
8000d572:	470d                	li	a4,3
8000d574:	b765                	j	8000d51c <.L208>

8000d576 <.L204>:
8000d576:	6709                	lui	a4,0x2
8000d578:	800046b7          	lui	a3,0x80004
8000d57c:	80004637          	lui	a2,0x80004
8000d580:	4c01                	li	s8,0
8000d582:	00ebf733          	and	a4,s7,a4
8000d586:	e3868693          	add	a3,a3,-456 # 80003e38 <__SEGGER_RTL_hex_lc>
8000d58a:	e4860613          	add	a2,a2,-440 # 80003e48 <__SEGGER_RTL_hex_uc>

8000d58e <.L209>:
8000d58e:	00b467b3          	or	a5,s0,a1
8000d592:	e38d                	bnez	a5,8000d5b4 <.L212>

8000d594 <.L206>:
8000d594:	418484b3          	sub	s1,s1,s8
8000d598:	0004d363          	bgez	s1,8000d59e <.L216>
8000d59c:	4481                	li	s1,0

8000d59e <.L216>:
8000d59e:	409b0b33          	sub	s6,s6,s1
8000d5a2:	0ff00793          	li	a5,255
8000d5a6:	418b0b33          	sub	s6,s6,s8
8000d5aa:	0397f863          	bgeu	a5,s9,8000d5da <.L217>
8000d5ae:	1b7d                	add	s6,s6,-1

8000d5b0 <.L218>:
8000d5b0:	1b7d                	add	s6,s6,-1
8000d5b2:	a035                	j	8000d5de <.L219>

8000d5b4 <.L212>:
8000d5b4:	00f47793          	and	a5,s0,15
8000d5b8:	cf19                	beqz	a4,8000d5d6 <.L210>
8000d5ba:	97b2                	add	a5,a5,a2

8000d5bc <.L361>:
8000d5bc:	0007c783          	lbu	a5,0(a5)
8000d5c0:	1828                	add	a0,sp,56
8000d5c2:	9562                	add	a0,a0,s8
8000d5c4:	00f50023          	sb	a5,0(a0)
8000d5c8:	8011                	srl	s0,s0,0x4
8000d5ca:	01c59793          	sll	a5,a1,0x1c
8000d5ce:	0c05                	add	s8,s8,1
8000d5d0:	8c5d                	or	s0,s0,a5
8000d5d2:	8191                	srl	a1,a1,0x4
8000d5d4:	bf6d                	j	8000d58e <.L209>

8000d5d6 <.L210>:
8000d5d6:	97b6                	add	a5,a5,a3
8000d5d8:	b7d5                	j	8000d5bc <.L361>

8000d5da <.L217>:
8000d5da:	fc0c9be3          	bnez	s9,8000d5b0 <.L218>

8000d5de <.L219>:
8000d5de:	200bf793          	and	a5,s7,512
8000d5e2:	e799                	bnez	a5,8000d5f0 <.L220>
8000d5e4:	865a                	mv	a2,s6
8000d5e6:	85de                	mv	a1,s7
8000d5e8:	854e                	mv	a0,s3
8000d5ea:	e90fb0ef          	jal	80008c7a <__SEGGER_RTL_pre_padding>
8000d5ee:	4b01                	li	s6,0

8000d5f0 <.L220>:
8000d5f0:	0ff00793          	li	a5,255
8000d5f4:	0197fc63          	bgeu	a5,s9,8000d60c <.L221>
8000d5f8:	03000593          	li	a1,48
8000d5fc:	854e                	mv	a0,s3
8000d5fe:	a88ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>

8000d602 <.L222>:
8000d602:	85e6                	mv	a1,s9
8000d604:	854e                	mv	a0,s3
8000d606:	a80ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d60a:	a019                	j	8000d610 <.L223>

8000d60c <.L221>:
8000d60c:	fe0c9be3          	bnez	s9,8000d602 <.L222>

8000d610 <.L223>:
8000d610:	865a                	mv	a2,s6
8000d612:	85de                	mv	a1,s7
8000d614:	854e                	mv	a0,s3
8000d616:	e64fb0ef          	jal	80008c7a <__SEGGER_RTL_pre_padding>
8000d61a:	8626                	mv	a2,s1
8000d61c:	03000593          	li	a1,48
8000d620:	854e                	mv	a0,s3
8000d622:	b00ff0ef          	jal	8000c922 <__SEGGER_RTL_print_padding>

8000d626 <.L224>:
8000d626:	1c7d                	add	s8,s8,-1
8000d628:	e00c4863          	bltz	s8,8000cc38 <.L371>
8000d62c:	183c                	add	a5,sp,56
8000d62e:	97e2                	add	a5,a5,s8
8000d630:	0007c583          	lbu	a1,0(a5)
8000d634:	854e                	mv	a0,s3
8000d636:	a50ff0ef          	jal	8000c886 <__SEGGER_RTL_putc>
8000d63a:	b7f5                	j	8000d626 <.L224>

8000d63c <.L34>:
8000d63c:	07800713          	li	a4,120
8000d640:	d4f76d63          	bltu	a4,a5,8000cb9a <.L4>

8000d644 <.L38>:
8000d644:	fa878713          	add	a4,a5,-88
8000d648:	0ff77713          	zext.b	a4,a4
8000d64c:	02000693          	li	a3,32
8000d650:	d4e6e563          	bltu	a3,a4,8000cb9a <.L4>
8000d654:	46d2                	lw	a3,20(sp)
8000d656:	070a                	sll	a4,a4,0x2
8000d658:	9736                	add	a4,a4,a3
8000d65a:	4318                	lw	a4,0(a4)
8000d65c:	8702                	jr	a4

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

8000d65e <__SEGGER_RTL_ascii_isctype>:
8000d65e:	07f00793          	li	a5,127
8000d662:	02a7e263          	bltu	a5,a0,8000d686 <.L3>
8000d666:	800047b7          	lui	a5,0x80004
8000d66a:	fd478793          	add	a5,a5,-44 # 80003fd4 <__SEGGER_RTL_ascii_ctype_map>
8000d66e:	953e                	add	a0,a0,a5
8000d670:	800057b7          	lui	a5,0x80005
8000d674:	d9478793          	add	a5,a5,-620 # 80004d94 <__SEGGER_RTL_ascii_ctype_mask>
8000d678:	95be                	add	a1,a1,a5
8000d67a:	00054503          	lbu	a0,0(a0)
8000d67e:	0005c783          	lbu	a5,0(a1)
8000d682:	8d7d                	and	a0,a0,a5
8000d684:	8082                	ret

8000d686 <.L3>:
8000d686:	4501                	li	a0,0
8000d688:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

8000d68a <__SEGGER_RTL_ascii_tolower>:
8000d68a:	fbf50713          	add	a4,a0,-65
8000d68e:	47e5                	li	a5,25
8000d690:	00e7e463          	bltu	a5,a4,8000d698 <.L7>
8000d694:	02050513          	add	a0,a0,32

8000d698 <.L7>:
8000d698:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

8000d69a <__SEGGER_RTL_ascii_iswctype>:
8000d69a:	07f00793          	li	a5,127
8000d69e:	02a7e263          	bltu	a5,a0,8000d6c2 <.L10>
8000d6a2:	800047b7          	lui	a5,0x80004
8000d6a6:	fd478793          	add	a5,a5,-44 # 80003fd4 <__SEGGER_RTL_ascii_ctype_map>
8000d6aa:	953e                	add	a0,a0,a5
8000d6ac:	800057b7          	lui	a5,0x80005
8000d6b0:	d9478793          	add	a5,a5,-620 # 80004d94 <__SEGGER_RTL_ascii_ctype_mask>
8000d6b4:	95be                	add	a1,a1,a5
8000d6b6:	00054503          	lbu	a0,0(a0)
8000d6ba:	0005c783          	lbu	a5,0(a1)
8000d6be:	8d7d                	and	a0,a0,a5
8000d6c0:	8082                	ret

8000d6c2 <.L10>:
8000d6c2:	4501                	li	a0,0
8000d6c4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

8000d6c6 <__SEGGER_RTL_ascii_towlower>:
8000d6c6:	fbf50713          	add	a4,a0,-65
8000d6ca:	47e5                	li	a5,25
8000d6cc:	00e7e463          	bltu	a5,a4,8000d6d4 <.L14>
8000d6d0:	02050513          	add	a0,a0,32

8000d6d4 <.L14>:
8000d6d4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

8000d6d6 <__SEGGER_RTL_ascii_wctomb>:
8000d6d6:	07f00793          	li	a5,127
8000d6da:	00b7e663          	bltu	a5,a1,8000d6e6 <.L66>
8000d6de:	00b50023          	sb	a1,0(a0)
8000d6e2:	4505                	li	a0,1
8000d6e4:	8082                	ret

8000d6e6 <.L66>:
8000d6e6:	5579                	li	a0,-2
8000d6e8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

8000d6ea <__SEGGER_RTL_current_locale>:
8000d6ea:	bfc22503          	lw	a0,-1028(tp) # fffffbfc <__APB_SRAM_segment_end__+0xbf0dbfc>
8000d6ee:	e509                	bnez	a0,8000d6f8 <.L155>
8000d6f0:	01080537          	lui	a0,0x1080
8000d6f4:	00050513          	mv	a0,a0

8000d6f8 <.L155>:
8000d6f8:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_lzss:

80010328 <__SEGGER_init_lzss>:
80010328:	4008                	lw	a0,0(s0)
8001032a:	404c                	lw	a1,4(s0)
8001032c:	0421                	add	s0,s0,8
8001032e:	08000793          	li	a5,128

80010332 <.L__SEGGER_init_lzss_NextByte>:
80010332:	0005c603          	lbu	a2,0(a1)
80010336:	0585                	add	a1,a1,1
80010338:	c631                	beqz	a2,80010384 <.L__SEGGER_init_lzss_Done>
8001033a:	02f66c63          	bltu	a2,a5,80010372 <.L__SEGGER_init_lzss_LoopLiteral>
8001033e:	f8060613          	add	a2,a2,-128
80010342:	c231                	beqz	a2,80010386 <.L__SEGGER_init_lzss_Error>
80010344:	0005c683          	lbu	a3,0(a1)
80010348:	0585                	add	a1,a1,1
8001034a:	00f6e963          	bltu	a3,a5,8001035c <.L__SEGGER_init_lzss_ShortRun>
8001034e:	f8068693          	add	a3,a3,-128
80010352:	06a2                	sll	a3,a3,0x8
80010354:	0005c703          	lbu	a4,0(a1)
80010358:	0585                	add	a1,a1,1
8001035a:	96ba                	add	a3,a3,a4

8001035c <.L__SEGGER_init_lzss_ShortRun>:
8001035c:	40d50733          	sub	a4,a0,a3

80010360 <.L__SEGGER_init_lzss_LoopShort>:
80010360:	00074683          	lbu	a3,0(a4) # 2000 <__APB_SRAM_segment_size__>
80010364:	00d50023          	sb	a3,0(a0) # 1080000 <__RAL_global_locale>
80010368:	0705                	add	a4,a4,1
8001036a:	0505                	add	a0,a0,1
8001036c:	167d                	add	a2,a2,-1
8001036e:	fa6d                	bnez	a2,80010360 <.L__SEGGER_init_lzss_LoopShort>
80010370:	b7c9                	j	80010332 <.L__SEGGER_init_lzss_NextByte>

80010372 <.L__SEGGER_init_lzss_LoopLiteral>:
80010372:	0005c683          	lbu	a3,0(a1)
80010376:	0585                	add	a1,a1,1
80010378:	00d50023          	sb	a3,0(a0)
8001037c:	0505                	add	a0,a0,1
8001037e:	167d                	add	a2,a2,-1
80010380:	fa6d                	bnez	a2,80010372 <.L__SEGGER_init_lzss_LoopLiteral>
80010382:	bf45                	j	80010332 <.L__SEGGER_init_lzss_NextByte>

80010384 <.L__SEGGER_init_lzss_Done>:
80010384:	8082                	ret

80010386 <.L__SEGGER_init_lzss_Error>:
80010386:	a001                	j	80010386 <.L__SEGGER_init_lzss_Error>

Disassembly of section .segger.init.__SEGGER_init_zero:

80010388 <__SEGGER_init_zero>:
80010388:	4008                	lw	a0,0(s0)
8001038a:	404c                	lw	a1,4(s0)
8001038c:	0421                	add	s0,s0,8
8001038e:	c591                	beqz	a1,8001039a <.L__SEGGER_init_zero_Done>

80010390 <.L__SEGGER_init_zero_Loop>:
80010390:	00050023          	sb	zero,0(a0)
80010394:	0505                	add	a0,a0,1
80010396:	15fd                	add	a1,a1,-1
80010398:	fde5                	bnez	a1,80010390 <.L__SEGGER_init_zero_Loop>

8001039a <.L__SEGGER_init_zero_Done>:
8001039a:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

8001039c <__SEGGER_init_copy>:
8001039c:	4008                	lw	a0,0(s0)
8001039e:	404c                	lw	a1,4(s0)
800103a0:	4410                	lw	a2,8(s0)
800103a2:	0431                	add	s0,s0,12
800103a4:	ca09                	beqz	a2,800103b6 <.L__SEGGER_init_copy_Done>

800103a6 <.L__SEGGER_init_copy_Loop>:
800103a6:	00058683          	lb	a3,0(a1)
800103aa:	00d50023          	sb	a3,0(a0)
800103ae:	0505                	add	a0,a0,1
800103b0:	0585                	add	a1,a1,1
800103b2:	167d                	add	a2,a2,-1
800103b4:	fa6d                	bnez	a2,800103a6 <.L__SEGGER_init_copy_Loop>

800103b6 <.L__SEGGER_init_copy_Done>:
800103b6:	8082                	ret
