#ifndef __COMMON_H__
#define __COMMON_H__

#include "sdkinc.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef enum {
    SYSTEM_STATE_INITIAL,             ///< system initial
    SYSTEM_STATE_READY_TO_SWITCH_ON,  ///< system ready to switch on
    SYSTEM_STATE_SWITCHED_ON,         ///< system switched on, waiting for command
    SYSTEM_STATE_OPERATION_ENABLE,    ///< system operation enabled
    SYSTEM_STATE_FAULT_DIAGNOSE,      ///< fault or warning occured, need to diagnose
} system_state_e;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

#ifdef __cplusplus
}
#endif

#endif  // ! __COMMON_H__
