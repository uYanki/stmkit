# Copyright (c) 2021 HPMicro
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.13)

set(CONFIG_CHERRYUSB 1)
set(CONFIG_USB_DEVICE 1)
set(CONFIG_USB_DEVICE_HID 1)

find_package(hpm-sdk REQUIRED HINTS $ENV{HPM_SDK_BASE})
project(cherryusb_device_hid_custom_inout)

sdk_inc(src)
sdk_app_src(src/board.c)
sdk_app_src(src/delay.c)
sdk_app_src(src/flash_if.c)
sdk_app_src(src/hexdump.c)
sdk_app_src(src/hpm_platform.c)
sdk_app_src(src/iap.c)
sdk_app_src(src/iap_uart_rs485_backend.c)
sdk_app_src(src/iap_usbd_hid_backend.c)
sdk_app_src(src/main.c)
sdk_app_src(src/printf.c)

generate_ide_projects()
