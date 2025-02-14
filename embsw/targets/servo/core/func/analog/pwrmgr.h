#ifndef __PWR_MGR_H__
#define __PWR_MGR_H__

#include "paratbl.h"
#include "alarm.h"

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

typedef struct {
    device_para_t* pDevicePara;
} pwr_mgr_t;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void PwrMgrCreat(pwr_mgr_t* pPwrMgr, device_para_t* pDevicePara);
void PwrMgrInit(pwr_mgr_t* pPwrMgr);
void PwrMgrIsr(pwr_mgr_t* pPwrMgr);
void PwrMgrCycle(pwr_mgr_t* pPwrMgr);

#ifdef __cplusplus
}
#endif

#endif
