/*
 * Copyright (c) 2024 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

#ifndef _CDC_ACM_H
#define _CDC_ACM_H

#include "usbd_core.h"
#include "usbd_cdc.h"

typedef struct cdc_device_cfg{
    struct usbd_endpoint cdc_out_ep;
    struct usbd_endpoint cdc_in_ep;
    struct usbd_interface intf0;
    struct usbd_interface intf1;
    struct cdc_line_coding s_line_coding;
    bool is_open;
    bool ep_tx_busy_flag;
} cdc_device_cfg_t;


#define USB_BUS_ID 0

//#define MAX_CDC_COUNT   (((USB_SOC_DCD_MAX_ENDPOINT_COUNT) / 2) - 1)
#define MAX_CDC_COUNT   (1)

/*!< endpoint address */
#define CDC_IN_EP  0x81
#define CDC_OUT_EP 0x01
#define CDC_INT_EP 0x82

#define CDC_IN_EP1  0x83
#define CDC_OUT_EP1 0x03
#define CDC_INT_EP1 0x84

#define CDC_IN_EP3  0x85
#define CDC_OUT_EP3 0x05
#define CDC_INT_EP3 0x86

#define CDC_IN_EP4  0x87
#define CDC_OUT_EP4 0x07
#define CDC_INT_EP4 0x88 // HPM6450 只有8个端点 (0~7)

extern cdc_device_cfg_t cdc_device[MAX_CDC_COUNT];

uint8_t *usbd_get_write_buffer_ptr(uint8_t can_num);
uint8_t *usbd_get_read_buffer_ptr(uint8_t can_num);
bool usbd_is_tx_busy(uint8_t can_num);
void usbd_set_tx_busy(uint8_t can_num);
void cdc_acm_init(uint8_t busid, uint32_t reg_base);
void usbd_init_line_coding(uint8_t can_num, struct cdc_line_coding *line_coding);
bool get_usb_out_char(uint8_t can_num, uint8_t *data);
bool get_usb_out_is_empty(uint8_t can_num);
uint32_t write_usb_data(uint8_t can_num, uint8_t *data, uint32_t len);

#endif
