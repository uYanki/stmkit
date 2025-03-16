#ifndef __IAP_H__
#define __IAP_H__

#include <stdint.h>

#include "gconf.h"

typedef enum {
    IAP_NONE,
    IAP_UART_RS232,
    IAP_UART_RS485,
    IAP_USBD_HID,
    IAP_USBD_VCP,
    IAP_USBD_MSC,
    IAP_USBD_RNDIS_LWIP_HTTPD,
} iap_mode_e;

void iap_init();
bool iap_verfiy();
void iap_goto_app();
void iap_cycle(iap_mode_e iap_mode);

#endif