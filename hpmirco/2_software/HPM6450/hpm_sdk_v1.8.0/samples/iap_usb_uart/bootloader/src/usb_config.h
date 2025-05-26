/*
 * Copyright (c) 2022, sakumisu
 * Copyright (c) 2022-2024, HPMicro
 *
 * SPDX-License-Identifier: Apache-2.0
 */
#ifndef CHERRYUSB_CONFIG_H
#define CHERRYUSB_CONFIG_H

#include "hpm_soc_feature.h"

/* ================ USB common Configuration ================ */

#define CONFIG_USB_PRINTF(...) printf(__VA_ARGS__)

#ifndef CONFIG_USB_DBG_LEVEL
#define CONFIG_USB_DBG_LEVEL USB_DBG_INFO
#endif

//#ifdef CONFIG_USB_DEVICE_FS
//#undef CONFIG_USB_HS
//#else
#define CONFIG_USB_HS
//#endif

/* Enable print with color */
//#define CONFIG_USB_PRINTF_COLOR_ENABLE

/* data align size when use dma */
#ifndef CONFIG_USB_ALIGN_SIZE
#define CONFIG_USB_ALIGN_SIZE 4
#endif

/* descriptor common define */
#define CONFIG_USBDEV_ADVANCE_DESC
//#define USBD_VID           0x34B7 /* HPMicro VID */
//#define USBD_PID           0xFFFF
#define USBD_MAX_POWER     300

/* attribute data into no cache ram */
#define USB_NOCACHE_RAM_SECTION __attribute__((section(".noncacheable")))

/* ================= USB Device Stack Configuration ================ */

/* Ep0 in and out transfer buffer */
#ifndef CONFIG_USBDEV_REQUEST_BUFFER_LEN
#define CONFIG_USBDEV_REQUEST_BUFFER_LEN 1024
#endif

/* Setup packet log for debug */
/* #define CONFIG_USBDEV_SETUP_LOG_PRINT */

/* Send ep0 in data from user buffer instead of copying into ep0 reqdata
 * Please note that user buffer must be aligned with CONFIG_USB_ALIGN_SIZE
 */
/* #define CONFIG_USBDEV_EP0_INDATA_NO_COPY */

/* Check if the input descriptor is correct */
/* #define CONFIG_USBDEV_DESC_CHECK */

/* Enable test mode */
//#define CONFIG_USBDEV_TEST_MODE

/* move msc read & write from isr to while(1), you should call usbd_msc_polling in while(1) */
/* #define CONFIG_USBDEV_MSC_POLLING */

/* move msc read & write from isr to thread */
/* #define CONFIG_USBDEV_MSC_THREAD */

/* ================ USB Device Port Configuration ================*/

#define CONFIG_USBDEV_MAX_BUS USB_SOC_MAX_COUNT

#ifndef CONFIG_USBDEV_EP_NUM
#define CONFIG_USBDEV_EP_NUM USB_SOC_DCD_MAX_ENDPOINT_COUNT
#endif

#ifndef CONFIG_HPM_USBD_BASE
#define CONFIG_HPM_USBD_BASE HPM_USB0_BASE
#endif

#ifndef CONFIG_HPM_USBD_IRQn
#define CONFIG_HPM_USBD_IRQn IRQn_USB0
#endif

#endif
