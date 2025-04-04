#ifndef __CANDRV_H__
#define __CANDRV_H__

#include <stdbool.h>

#include "stm32f4xx_hal.h"
#include "can.h"

/* ----------------------------------------------------------------------- */

/* ----------------------------------------------------------------------- */

/**
 * @brief CAN_BTR_ is @arg of CAN_SetBtr
 */
#define CAN_BTR_1000K 0x004E0001  // SJW = 1, BS1 = 15, BS2 = 5, PSC = 2,   Sample Point = 76.2%
#define CAN_BTR_500K  0x0004000B  // SJW = 1, BS1 = 5,  BS2 = 1, PSC = 12,  Sample Point = 85.7%
#define CAN_BTR_250K  0x00040017  // SJW = 1, BS1 = 5,  BS2 = 1, PSC = 24,  Sample Point = 85.7%
#define CAN_BTR_125K  0x00050029  // SJW = 1, BS1 = 6,  BS2 = 1, PSC = 42,  Sample Point = 87.5%
#define CAN_BTR_100K  0x0004003B  // SJW = 1, BS1 = 5,  BS2 = 1, PSC = 60,  Sample Point = 85.7%
#define CAN_BTR_50K   0x00050068  // SJW = 1, BS1 = 6,  BS2 = 1, PSC = 105, Sample Point = 87.5%
#define CAN_BTR_20K
#define CAN_BTR_10K  0x0005020C  // SJW = 1, BS1 = 6,  BS2 = 1, PSC = 525, Sample Point = 87.5%
#define CAN_BTR_800K 0x0001000C  // SJW = 1, BS1 = 2,  BS2 = 1, PSC = 13,  Sample Point = 75.0%, bitrate = 807692bps, err = 0.96%

/* ----------------------------------------------------------------------- */

typedef struct {
    uint32_t id;  //!< ID der Nachricht (11 oder 29 Bit)
    struct {
        int rtr      : 1;  //!< Remote-Transmit-Request-Frame?
        int extended : 1;  //!< extended ID?
    } flags;
    uint8_t  length;   //!< Anzahl der Datenbytes
    uint8_t  data[8];  //!< Die Daten der CAN Nachricht
    uint16_t timestamp;
} can_msg_t;

typedef struct
{
    uint32_t id;    //!< ID der Nachricht (11 oder 29 Bit)
    uint32_t mask;  //!< Maske
    struct {
        uint8_t rtr      : 2;  //!< Remote Request Frame
        uint8_t extended : 2;  //!< extended ID
    } flags;
} can_filter_t;

typedef enum {
    CAN_DIR_RX,
    CAN_DIR_TX,
} can_dir_e;

/* ----------------------------------------------------------------------- */

void CAN_Open(CAN_HandleTypeDef* hcan);
void CAN_Close(CAN_HandleTypeDef* hcan);
void CAN_SetBtr(CAN_HandleTypeDef* hcan, uint32_t btr);
void CAN_SetMode(CAN_HandleTypeDef* hcan, uint32_t mode);
bool CAN_TxMsg(CAN_HandleTypeDef* hcan, can_msg_t* msg);
bool CAN_RxMsg(CAN_HandleTypeDef* hcan, uint32_t fifo, can_msg_t* msg);

#endif  // !__CANDRV_H__
