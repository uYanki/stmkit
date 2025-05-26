#ifndef __HPM_FLASHMAP_H
#define __HPM_FLASHMAP_H

#define FLASH_SECTOR_SIZE        (0x1000) // 4KB 2^n
#define FLASH_MAX_SIZE           (0x400000)

#define FLASH_ADDR_BASE          (0x80000000)

#define APP_MAX_SIZE             (128*FLASH_SECTOR_SIZE)   // 升级包大小限制 512KB

// APP存放位置不能和ECAT的模拟EEPROM地址有冲突
#define FLASH_APP_ADDRESS       (FLASH_ADDR_BASE + 0x20000)  // 内存映射模式下的起始地址 (若更改,需同步更改app的.icf)

#endif
