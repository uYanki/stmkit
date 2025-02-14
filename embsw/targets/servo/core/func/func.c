#include "func.h"

#include "analog/analog.h"
#include "analog/pwrmgr.h"
#include "comm/modbus/modbus.h"

#include "alarm.h"

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "func"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

pwr_mgr_t PwrMgr;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void FuncCreat(void)
{
    AlmCreat();
    ModbusCreat(&ModbusSlave);
    AnalogCreat(&Analog);
    PwrMgrCreat(&PwrMgr, &D);
}

void FuncInit(void)
{
    AlmInit();
    ModbusInit(&ModbusSlave);
    AnalogInit(&Analog);
    PwrMgrInit(&PwrMgr);
}

void FuncCycle(void)
{
    // 模拟量输入
#if CONFIG_EXT_AI_NUM > 0
    AnalogUaiSamp(&Analog);
    AnalogUaiSi(&Analog);
#endif

    // 温度采样
#if CONFIG_TEMP_SAMP_NUM > 0
    PeriodicTask(10 * UNIT_MS, {
        AnalogTempSamp(&Analog);
        AnalogTempSi(&Analog);
    });
#endif

    AlmCycle();
    ModbusCycle(&ModbusSlave);
    PwrMgrCycle(&PwrMgr);
}

//
// 主中断
//

void FuncInputIsr(void)
{
    AnalogUmdcSamp(&Analog);
    AnalogUmdcSi(&Analog);
}

void FuncOutputIsr(void)
{
}

//
// 辅助中断
//

void FuncIsr(void)
{
#if CONFIG_UCDC_SAMP_SW
    AnalogUcdcSamp(&Analog);
    AnalogUcdcSi(&Analog);
#endif

    ModbusIsr(&ModbusSlave);
    PwrMgrIsr(&PwrMgr);
}
