/*
 * Copyright (c) 2022, Egahp
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef SHELL_H
#define SHELL_H

#include <stdbool.h>
#include "stm32h7xx_hal.h"
#include "csh.h"

extern int  shell_init(UART_HandleTypeDef* uart, bool need_login);
extern int  shell_cycle(void);
extern void shell_lock(void);
extern void shell_unlock(void);

#endif
