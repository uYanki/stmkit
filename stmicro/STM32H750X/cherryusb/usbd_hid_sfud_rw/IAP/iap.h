#ifndef __IAP_H__
#define __IAP_H__

#include <stdint.h>

#include "gconf.h"

// typedef enum {
//     IAP_NONE,
//     IAP_UART_RS232,
//     IAP_UART_RS485,
//     IAP_USBD_HID,
//     IAP_USBD_VCP,
//     IAP_USBD_MSC,
//     IAP_USBD_RNDIS_LWIP_HTTPD,
// } iap_mode_e;

typedef struct {
    uint8_t pid;  // Packet identifier
    uint8_t data[62];
} iap_packet_t;

typedef struct {
    uint8_t header;
    union {
        uint8_t      buffer[sizeof(iap_packet_t)];
        iap_packet_t packet;
    };
    // uint8_t tail;
} iap_frame_t;

// void iap_init();
// void iap_goto_app();
// void iap_cycle(iap_mode_e iap_mode);

void iap_execute(iap_packet_t* packet);
void iap_response(iap_packet_t* response, uint16_t len);

#endif