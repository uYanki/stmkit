/*******************************************************************************
*                                 AWorks
*                       ----------------------------
*                       innovating embedded platform
*
* Copyright (c) 2001-present Guangzhou ZHIYUAN Electronics Co., Ltd.
* ALL rights reserved.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
*
* The License of this software follows LGPL v2.1, See the LICENSE for more details:
* https://opensource.org/licenses/LGPL-2.1
*
* Contact information:
* web site:    http://www.zlg.cn/
*******************************************************************************/


#include "aworks.h"
#include "hpm_bootheader.h"

#define FLASH_XIP
#if defined(FLASH_XIP)
__attribute__ ((section(".nor_cfg_option"))) const uint32_t option[4] = {0xfcf90002, 0x00000007, 0x100, 0x0};
#endif


/* symbol exported from startup.S */
void rtk_riscv_reset_handler(void);

/* following symbols exported from linker script */
extern uint32_t __app_load_addr__[];
extern uint32_t __app_offset__[];
extern uint32_t __fw_size__[];

#define FW_SIZE (32768)
__attribute__ ((section(".fw_info_table"))) const fw_info_table_t fw_info = {
    (uint32_t)__app_offset__,             /* offset */
    (uint32_t)__fw_size__,                /* size */
    0,                                    /* flags */
    0,                                    /* reserved0 */
    (uint32_t) &__app_load_addr__,        /* load_addr */
    0,                                    /* reserved1 */
    (uint32_t) rtk_riscv_reset_handler,   /* entry_point */
    0,                                    /* reserved2 */
    {0},                                  /* hash */
    {0},                                  /* iv */
};

__attribute__ ((section(".boot_header"))) const boot_header_t header = {
    HPM_BOOTHEADER_TAG,                         /* tag */
    0x10,                                       /* version*/
    sizeof(header) + sizeof(fw_info),
    0,                                          /* flags */
    0,                                          /* sw_version */
    0,                                          /* fuse_version */
    1,                                          /* fw_count */
    0,
    0,                                          /* sig_block_offset */
};
