#ifndef __SW_MDIO_H__
#define __SW_MDIO_H__

#include "hpm_common.h"

void     mdio_init(void);
void     mdio_scan_phy(void);
void     mdio_write_byte(uint16_t phy_addr, uint16_t reg_addr, uint16_t reg_data);
uint16_t mdio_read_byte(uint16_t phy_addr, uint16_t reg_addr);

#endif