/* generated vector source file - do not edit */
#include "bsp_api.h"
/* Do not build these data structures if no interrupts are currently allocated because IAR will have build errors. */
#if VECTOR_DATA_IRQ_COUNT > 0
        BSP_DONT_REMOVE const fsp_vector_t g_vector_table[BSP_ICU_VECTOR_MAX_ENTRIES] BSP_PLACE_IN_SECTION(BSP_SECTION_APPLICATION_VECTORS) =
        {
                        [0] = r_icu_isr, /* ICU IRQ0 (External pin interrupt 0) */
            [1] = usbfs_interrupt_handler, /* USBFS INT (USBFS interrupt) */
            [2] = usbfs_resume_handler, /* USBFS RESUME (USBFS resume interrupt) */
            [3] = usbfs_d0fifo_handler, /* USBFS FIFO 0 (DMA/DTC transfer request 0) */
            [4] = usbfs_d1fifo_handler, /* USBFS FIFO 1 (DMA/DTC transfer request 1) */
        };
        #if BSP_FEATURE_ICU_HAS_IELSR
        const bsp_interrupt_event_t g_interrupt_event_link_select[BSP_ICU_VECTOR_MAX_ENTRIES] =
        {
            [0] = BSP_PRV_VECT_ENUM(EVENT_ICU_IRQ0,GROUP0), /* ICU IRQ0 (External pin interrupt 0) */
            [1] = BSP_PRV_VECT_ENUM(EVENT_USBFS_INT,GROUP1), /* USBFS INT (USBFS interrupt) */
            [2] = BSP_PRV_VECT_ENUM(EVENT_USBFS_RESUME,GROUP2), /* USBFS RESUME (USBFS resume interrupt) */
            [3] = BSP_PRV_VECT_ENUM(EVENT_USBFS_FIFO_0,GROUP3), /* USBFS FIFO 0 (DMA/DTC transfer request 0) */
            [4] = BSP_PRV_VECT_ENUM(EVENT_USBFS_FIFO_1,GROUP4), /* USBFS FIFO 1 (DMA/DTC transfer request 1) */
        };
        #endif
        #endif
