#ifndef __IAP_H__
#define __IAP_H__

#include <stdint.h>
#include <stdbool.h>

#define CHKMSK(DAT, MSK)               (((DAT) & (MSK)) == (MSK))
#define BV(n)                          (1UL << (n))

typedef struct {
    uint8_t pid;  // Packet identifier
    uint8_t data[62];
} iap_packet_t;

typedef struct {
    uint8_t report_id;
    union {
        uint8_t      buffer[sizeof(iap_packet_t)];
        iap_packet_t packet;
    };
} iap_usbd_frame_t;

typedef struct {
    bool (*lowlevel_init)(void);
    bool (*lowlevel_deinit)(void);
    bool (*transfer)(void);
    bool (*try_shakehand)(void);
} iap_if_t;

void iap_execute(iap_packet_t* packet);
void iap_response(iap_packet_t* packet, uint16_t len);

bool iap_is_connected(void);

extern void (*app_entry)(void);

#endif
