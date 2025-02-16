#include "func.h"
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

mbslave_t ModbusSlave = {0};
analog_t  Analog      = {0};
pulse_t   Pulse       = {0};
dido_t    DiDo        = {0};

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void FuncCreat(void)
{
    AlmCreat();
    ModbusCreat(&ModbusSlave);
    AnalogCreat(&Analog);
    PulseCreat(&Pulse);
    DiDoCreat(&DiDo);
}

void FuncInit(void)
{
    AlmInit();
    ModbusInit(&ModbusSlave);
    AnalogInit(&Analog);
    PulseInit(&Pulse);
    DiDoInit(&DiDo);
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
    PeriodicTaskMs(10, {
        AnalogTempSamp(&Analog);
        AnalogTempSi(&Analog);
    });
#endif

    PulseCycle(&Pulse);
    DiDoCycle(&DiDo);

    AlmCycle();
    ModbusCycle(&ModbusSlave);
}

void FuncIsr(void)
{
    PulseIsr(&Pulse);
    DiDoIsr(&DiDo);

    ModbusIsr(&ModbusSlave);
}
