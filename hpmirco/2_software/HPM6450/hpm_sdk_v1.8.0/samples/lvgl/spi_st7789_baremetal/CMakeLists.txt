# Copyright (c) 2021-2024 HPMicro
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.13)

# ENABLE LVGL
set(CONFIG_LVGL 1)
set(CONFIG_LV_DEMO 1)

set(STACK_SIZE 0x10000)

if("${HPM_BUILD_TYPE}" STREQUAL "")
    SET(HPM_BUILD_TYPE flash_sdram_xip)
endif()

find_package(hpm-sdk REQUIRED HINTS $ENV{HPM_SDK_BASE})

project(lvgl_baremetal)

# LVGL DEMOS
sdk_compile_definitions(-DLV_USE_DEMO_MUSIC=0)
sdk_compile_definitions(-DLV_USE_DEMO_WIDGETS=0)
sdk_compile_definitions(-DLV_USE_DEMO_BENCHMARK=1)
sdk_compile_definitions(-DLV_USE_DEMO_RENDER=0)
sdk_compile_definitions(-DLV_USE_DEMO_STRESS=0)
sdk_compile_definitions(-DLV_USE_DEMO_FLEX_LAYOUT=0)

# LVGL CONF
sdk_compile_definitions(-DLV_USE_SYSMON=1)
sdk_compile_definitions(-DLV_USE_HPM_MODE_DIRECT=0)
sdk_compile_definitions(-DLV_USE_HPM_PDMA_FLUSH=0)
sdk_compile_definitions(-DLV_USE_HPM_PDMA_WAIT_VSYNC=0)

sdk_inc(src)
sdk_app_src(src/main.c)
sdk_app_src(src/board.c)
sdk_app_src(src/hpm_spi.c)
sdk_app_src(src/lv_port_disp.c)

generate_ide_projects()
