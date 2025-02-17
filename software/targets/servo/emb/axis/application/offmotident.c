#include "offmotident.h"
#include "mclib.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG           "encident"
#define LOG_LOCAL_LEVEL         LOG_LEVEL_INFO

#define CUR_LOCK_TIME_100MS     2     // 单位0.1s
#define HIGH_FREQ_INJE_TIME     6000  // 单位0.1us
#define FLUX_LINKAGE_IDENT_FREQ 10    // 单位Hz

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void OffMotIdentCreat(off_mot_ident_t* pMotParaIdent, axis_para_t* pAxisPara)
{
    pMotParaIdent->pAxisPara = pAxisPara;
}

void OffMotIdentInit(off_mot_ident_t* pMotParaIdent)
{
   
}

void OffMotIdentEnter(off_mot_ident_t* pMotParaIdent)
{
    ctrlword_u* puCtrlCmd = &pMotParaIdent->uCtrlCmd;

    puCtrlCmd->u32Bit.Enable = false;
}

void OffMotIdentExit(off_mot_ident_t* pMotParaIdent)
{
    ctrlword_u* puCtrlCmd = &pMotParaIdent->uCtrlCmd;

    puCtrlCmd->u32Bit.Enable = false;
}

void OffMotIdentCycle(off_mot_ident_t* pMotParaIdent)
{
}

void OffMotIdentIsr(off_mot_ident_t* pMotParaIdent)
{
    
}
