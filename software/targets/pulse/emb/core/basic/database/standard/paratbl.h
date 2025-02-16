#ifndef __PARA_TABLE_H__
#define __PARA_TABLE_H__

#include "common.h"
#include "paraattr.h"
#include "paraidx.h"

#include "paratbl/storage.h"

#define PARATBL_SIZE (sizeof(device_para_t) / 2)

// https://www.armbbs.cn/forum.php?mod=viewthread
// https://www.cnblogs.com/CodeWorkerLiMing/p/12076701.html

/**
 * @note #pragma pack(x)
 *
 * GCC鎵嬪唽: 6.62.11 Structure-Layout Pragmas
 * For compatibility with Microsoft Windows compilers, GCC supports a set of #pragma directives that change the maximum alignment of members of structures (other than zero-width
 * bit-fields), unions, and classes subsequently defined. The n value below always is required
 * to be a small power of two and specifies the new alignment in bytes.
 *
 * 璇ユ寚浠ゆ敼鍙樼粨鏋勬垚鍛樼殑鏈€澶у榻愭柟寮
 *
 * @note __packed typedef struct {} info_t;
 *
 * __packed 鐨勪綔鐢ㄦ槸鍙栨秷瀛楄妭瀵归綈銆
 *
 * @note M0/M0+/M1 涓嶆敮鎸2浣64浣嶇殑闈炲榻愯闂紙鐩存帴璁块棶浼氳Е鍙戠‖浠跺紓甯革級锛孧3/M4/M7 鍙互鐩存帴璁块棶闈炲榻愬湴鍧€銆
 *
 */

__packed typedef struct {
    u32 u32DevScheme;                  // P0000 设备方案
    u16 u16McuSwVer0;                  // P0002 MCU软件主版本号
    u16 u16McuSwVer1;                  // P0003 MCU软件子版本号
    u32 u32McuSwBuildDate;             // P0004 MCU软件构建日期
    u32 u32McuSwBuildTime;             // P0006 MCU软件构建时间
    u16 u16FpgaSwVer0;                 // P0008 FPGA软件主版本号
    u16 u16FpgaSwVer1;                 // P0009 FPGA软件子版本号
    u16 _Resv10;                       // P0010 
    u16 u16LedNum;                     // P0011 指示灯个数
    u16 u16ExtDiNum;                   // P0012 外部数字量输入个数
    u16 u16ExtDoNum;                   // P0013 外部数字量输出个数
    u16 u16ExtHDiNum;                  // P0014 外部高速数字量输入个数
    u16 u16ExtHDoNum;                  // P0015 外部高速数字量输出个数
    u16 u16ExtAiNum;                   // P0016 外部模拟量输入个数
    u16 u16ExtAoNum;                   // P0017 外部模拟量输出个数
    u16 _Resv18;                       // P0018 
    u16 u16UaiHwCoeff;                 // P0019 模拟量输入AI采样系数
    u16 _Resv20;                       // P0020 
    u16 u16SysPwd;                     // P0021 系统密码
    u16 u16SysAccess;                  // P0022 当前系统权限
    u16 bSwRstCmd;                     // P0023 软件复位
    u16 _Resv24;                       // P0024 
    u16 eParaTblCmd;                   // P0025 参数表操作命令字
    u16 eParaTblSts;                   // P0026 参数表操作状态
    u16 _Resv27;                       // P0027 
    u16 u16DiState;                    // P0028 DI输入端子电平状态
    u16 u16DoState;                    // P0029 DO输出端子电平状态
    u16 _Resv30;                       // P0030 
    s16 s16Uai0Si;                     // P0031 AI0输入电压物理值
    s16 s16Uai1Si;                     // P0032 AI1输入电压物理值
    s16 s16Uai2Si;                     // P0033 AI2输入电压物理值
    s16 s16Uai3Si;                     // P0034 AI3输入电压物理值
    u16 _Resv35;                       // P0035 
    u16 u16Uai0FltrTime;               // P0036 AI0滤波时间常数
    u16 u16Uai0Zoom;                   // P0037 AI0采样缩放系数
    s16 s16Uai0Offset;                 // P0038 AI0采样偏置
    u16 u16Uai0DeadZone;               // P0039 AI0输入死区
    u16 u16Uai1FltrTime;               // P0040 AI1滤波时间常数
    u16 u16Uai1Zoom;                   // P0041 AI1采样缩放系数
    s16 s16Uai1Offset;                 // P0042 AI1采样偏置
    u16 u16Uai1DeadZone;               // P0043 AI1输入死区
    u16 u16Uai2FltrTime;               // P0044 AI2滤波时间常数
    u16 u16Uai2Zoom;                   // P0045 AI2采样缩放系数
    s16 s16Uai2Offset;                 // P0046 AI2采样偏置
    u16 u16Uai2DeadZone;               // P0047 AI2输入死区
    u16 u16Uai3FltrTime;               // P0048 AI3滤波时间常数
    u16 u16Uai3Zoom;                   // P0049 AI3采样缩放系数
    s16 s16Uai3Offset;                 // P0050 AI3采样偏置
    u16 u16Uai3DeadZone;               // P0051 AI3输入死区
    u16 _Resv52;                       // P0052 
    u16 _Resv53;                       // P0053 
    u16 bPulOutEn;                     // P0054 高速脉冲输出使能
    u32 u32PulOutCnt;                  // P0055 高速脉冲输出个数
    u32 u32PulOutFreq;                 // P0057 高速脉冲输出频率
    u16 u16PulOutDuty;                 // P0059 高速脉冲输出占空比
    u16 _Resv60;                       // P0060 
    u16 bPulInEn;                      // P0061 高速脉冲输入使能
    u16 u16PulInMode;                  // P0062 高速脉冲输入模式
    s64 s64PulInCnt;                   // P0063 高速脉冲输入计数
    u32 u32EncRes;                     // P0067 编码器分辨率
    u32 u32EncPos;                     // P0069 编码器单圈位置
    s32 s32EncTurns;                   // P0071 编码器圈数
    u16 _Resv73;                       // P0073 
    u16 bFlexPulOutEn;                 // P0074 可编程脉冲输出使能
    u32 u32FlexPulOutFreq;             // P0075 可编程脉冲输出更新频率
    u16 u16FlexPulStartIndex;          // P0077 可编程脉冲数据点起始索引
    u16 u16FlexPulStopIndex;           // P0078 可编程脉冲数据点结束索引
    u16 u16FlexPulData00;              // P0079 可编程脉冲数据点00
    u16 u16FlexPulData01;              // P0080 可编程脉冲数据点01
    u16 u16FlexPulData02;              // P0081 可编程脉冲数据点02
    u16 u16FlexPulData03;              // P0082 可编程脉冲数据点03
    u16 u16FlexPulData04;              // P0083 可编程脉冲数据点04
    u16 u16FlexPulData05;              // P0084 可编程脉冲数据点05
    u16 u16FlexPulData06;              // P0085 可编程脉冲数据点06
    u16 u16FlexPulData07;              // P0086 可编程脉冲数据点07
    u16 u16FlexPulData08;              // P0087 可编程脉冲数据点08
    u16 u16FlexPulData09;              // P0088 可编程脉冲数据点09
    u16 u16FlexPulData10;              // P0089 可编程脉冲数据点10
    u16 u16FlexPulData11;              // P0090 可编程脉冲数据点11
    u16 u16FlexPulData12;              // P0091 可编程脉冲数据点12
    u16 u16FlexPulData13;              // P0092 可编程脉冲数据点13
    u16 u16FlexPulData14;              // P0093 可编程脉冲数据点14
    u16 u16FlexPulData15;              // P0094 可编程脉冲数据点15
    u16 u16FlexPulData16;              // P0095 可编程脉冲数据点16
    u16 u16FlexPulData17;              // P0096 可编程脉冲数据点17
    u16 u16FlexPulData18;              // P0097 可编程脉冲数据点18
    u16 u16FlexPulData19;              // P0098 可编程脉冲数据点19
    u16 u16FlexPulData20;              // P0099 可编程脉冲数据点20
    u16 u16FlexPulData21;              // P0100 可编程脉冲数据点21
    u16 u16FlexPulData22;              // P0101 可编程脉冲数据点22
    u16 u16FlexPulData23;              // P0102 可编程脉冲数据点23
    u16 u16FlexPulData24;              // P0103 可编程脉冲数据点24
    u16 u16FlexPulData25;              // P0104 可编程脉冲数据点25
    u16 u16FlexPulData26;              // P0105 可编程脉冲数据点26
    u16 u16FlexPulData27;              // P0106 可编程脉冲数据点27
    u16 u16FlexPulData28;              // P0107 可编程脉冲数据点28
    u16 u16FlexPulData29;              // P0108 可编程脉冲数据点29
    u16 u16FlexPulData30;              // P0109 可编程脉冲数据点30
    u16 u16FlexPulData31;              // P0110 可编程脉冲数据点31
    u16 u16FlexPulData32;              // P0111 可编程脉冲数据点32
    u16 u16FlexPulData33;              // P0112 可编程脉冲数据点33
    u16 u16FlexPulData34;              // P0113 可编程脉冲数据点34
    u16 u16FlexPulData35;              // P0114 可编程脉冲数据点35
    u16 u16FlexPulData36;              // P0115 可编程脉冲数据点36
    u16 u16FlexPulData37;              // P0116 可编程脉冲数据点37
    u16 u16FlexPulData38;              // P0117 可编程脉冲数据点38
    u16 u16FlexPulData39;              // P0118 可编程脉冲数据点39
    u16 u16FlexPulData40;              // P0119 可编程脉冲数据点40
    u16 u16FlexPulData41;              // P0120 可编程脉冲数据点41
    u16 u16FlexPulData42;              // P0121 可编程脉冲数据点42
    u16 u16FlexPulData43;              // P0122 可编程脉冲数据点43
    u16 u16FlexPulData44;              // P0123 可编程脉冲数据点44
    u16 u16FlexPulData45;              // P0124 可编程脉冲数据点45
    u16 u16FlexPulData46;              // P0125 可编程脉冲数据点46
    u16 u16FlexPulData47;              // P0126 可编程脉冲数据点47
    u16 u16FlexPulData48;              // P0127 可编程脉冲数据点48
    u16 u16FlexPulData49;              // P0128 可编程脉冲数据点49
    u16 u16FlexPulData50;              // P0129 可编程脉冲数据点50
    u16 u16FlexPulData51;              // P0130 可编程脉冲数据点51
    u16 u16FlexPulData52;              // P0131 可编程脉冲数据点52
    u16 u16FlexPulData53;              // P0132 可编程脉冲数据点53
    u16 u16FlexPulData54;              // P0133 可编程脉冲数据点54
    u16 u16FlexPulData55;              // P0134 可编程脉冲数据点55
    u16 u16FlexPulData56;              // P0135 可编程脉冲数据点56
    u16 u16FlexPulData57;              // P0136 可编程脉冲数据点57
    u16 u16FlexPulData58;              // P0137 可编程脉冲数据点58
    u16 u16FlexPulData59;              // P0138 可编程脉冲数据点59
    u16 u16FlexPulData60;              // P0139 可编程脉冲数据点60
    u16 u16FlexPulData61;              // P0140 可编程脉冲数据点61
    u16 u16FlexPulData62;              // P0141 可编程脉冲数据点62
    u16 u16FlexPulData63;              // P0142 可编程脉冲数据点63
    u16 _Resv143;                      // P0143 
    u16 _Resv144;                      // P0144 
    u16 eDi0FuncSel;                   // P0145 DI0功能选择
    u16 u16Di0FltrTime;                // P0146 DI0滤波时间
    u16 eDi0LogicLvl;                  // P0147 DI0逻辑电平
    u16 eDi1FuncSel;                   // P0148 DI1功能选择
    u16 u16Di1FltrTime;                // P0149 DI1滤波时间
    u16 eDi1LogicLvl;                  // P0150 DI1逻辑电平
    u16 eDi2FuncSel;                   // P0151 DI2功能选择
    u16 u16Di2FltrTime;                // P0152 DI2滤波时间
    u16 eDi2LogicLvl;                  // P0153 DI2逻辑电平
    u16 eDi3FuncSel;                   // P0154 DI3功能选择
    u16 u16Di3FltrTime;                // P0155 DI3滤波时间
    u16 eDi3LogicLvl;                  // P0156 DI3逻辑电平
    u16 eDi4FuncSel;                   // P0157 DI4功能选择
    u16 u16Di4FltrTime;                // P0158 DI4滤波时间
    u16 eDi4LogicLvl;                  // P0159 DI4逻辑电平
    u16 eDi5FuncSel;                   // P0160 DI5功能选择
    u16 u16Di5FltrTime;                // P0161 DI5滤波时间
    u16 eDi5LogicLvl;                  // P0162 DI5逻辑电平
    u16 eDi6FuncSel;                   // P0163 DI6功能选择
    u16 u16Di6FltrTime;                // P0164 DI6滤波时间
    u16 eDi6LogicLvl;                  // P0165 DI6逻辑电平
    u16 _Resv166;                      // P0166 
    u16 u16DoStateSet;                 // P0167 DO输出设置
    u16 eDo0FuncSel;                   // P0168 DO0功能选择
    u16 eDo0LogicLvl;                  // P0169 DO0逻辑电平
    u16 eDo1FuncSel;                   // P0170 DO1功能选择
    u16 eDo1LogicLvl;                  // P0171 DO1逻辑电平
    u16 _Resv172;                      // P0172 
    s16 s16TempMcuSi;                  // P0173 主控温度物理量
    u16 _Resv174;                      // P0174 
    u16 u16MbSlvId;                    // P0175 Modbus-从站节点ID
    u32 u32MbBaudrate;                 // P0176 Modbus-从站波特率
    u16 u16MbParity;                   // P0178 Modbus-从站检验位
    u16 u16MbMstEndian;                // P0179 Modbus-主站大小端
    u16 u16MbDisconnTime;              // P0180 Modbus-通讯断开检测时间
    u16 u16MbResponseDelay;            // P0181 Modbus-命令响应延时 
    u16 _Resv182;                      // P0182 
    u16 _Resv183;                      // P0183 
    u16 u16TunerBuff01;                // P0184 
    u16 u16TunerBuff02;                // P0185 
    u16 u16TunerBuff03;                // P0186 
    u16 u16TunerBuff04;                // P0187 
    u16 u16TunerBuff05;                // P0188 
    u16 u16TunerBuff06;                // P0189 
    u16 u16TunerBuff07;                // P0190 
    u16 u16TunerBuff08;                // P0191 
    u16 u16TunerBuff09;                // P0192 
    u16 u16TunerBuff10;                // P0193 
    u16 u16TunerBuff11;                // P0194 
    u16 u16TunerBuff12;                // P0195 
    u16 u16TunerBuff13;                // P0196 
    u16 u16TunerBuff14;                // P0197 
    u16 u16TunerBuff15;                // P0198 
    u16 u16TunerBuff16;                // P0199 
    u16 u16TunerBuff17;                // P0200 
    u16 u16TunerBuff18;                // P0201 
    u16 u16TunerBuff19;                // P0202 
    u16 u16TunerBuff20;                // P0203 
    u16 u16TunerBuff21;                // P0204 
    u16 u16TunerBuff22;                // P0205 
    u16 u16TunerBuff23;                // P0206 
    u16 u16TunerBuff24;                // P0207 
    u16 u16TunerBuff25;                // P0208 
    u16 _Resv209;                      // P0209 
    u16 _Resv210;                      // P0210 
    u16 _Resv211;                      // P0211 
    u16 u16AlmCodeSeq;                 // P0212 当前所有报警代码轮巡
    u16 u16LastAlmCode;                // P0213 最新报警代码
    u16 u16HisAlmCode01;               // P0214 历史报警代码01
    u16 u16HisAlmCode02;               // P0215 历史报警代码02
    u16 u16HisAlmCode03;               // P0216 历史报警代码03
    u16 u16HisAlmCode04;               // P0217 历史报警代码04
    u16 u16HisAlmCode05;               // P0218 历史报警代码05
    u32 u32HisAlmTime01;               // P0219 历史报警时间戳01
    u32 u32HisAlmTime02;               // P0221 历史报警时间戳02
    u32 u32HisAlmTime03;               // P0223 历史报警时间戳03
    u32 u32HisAlmTime04;               // P0225 历史报警时间戳04
    u32 u32HisAlmTime05;               // P0227 历史报警时间戳05
    u16 _Resv229;                      // P0229 
    u16 _Resv230;                      // P0230 
    u16 eSysState;                     // P0231 系统状态
    u32 u32SysRunTime;                 // P0232 运行时间
    u16 _Resv234;                      // P0234 
    u16 _Resv235;                      // P0235 
    u16 u16CycleScanTime;              // P0236 主循环程序Scan运行时间
    u16 u16IsrScanTime;                // P0237 中断程序Scan运行时间
    u16 u16CustomTime0;                // P0238 缺省程序运行时间0
    u16 u16CustomTime1;                // P0239 缺省程序运行时间1
    u16 _Resv240;                      // P0240 
    s16 s16Uai0Pu;                     // P0241 AI0输入电压数字量
    s16 s16Uai1Pu;                     // P0242 AI1输入电压数字量
    s16 s16Uai2Pu;                     // P0243 AI2输入电压数字量
    s16 s16Uai3Pu;                     // P0244 AI3输入电压数字量
    u16 u16TempMcuPu;                  // P0245 主控温度电压数字量
    u16 _Resv246;                      // P0246 
    u16 _Resv247;                      // P0247 
} device_para_t;
// clang-format on

extern const para_attr_t aDeviceAttr[];

extern u16 au16ParaTbl[];

#define D (*(device_para_t*)&au16ParaTbl[0])

u16 ParaSubAttr_Sync(u16 u16Index);
u16 ParaSubAttr_Relate(u16 u16Index);
u16 ParaSubAttr_Mode(u16 u16Index);
u16 ParaSubAttr_Sign(u16 u16Index);
u16 ParaSubAttr_Length(u16 u16Index);
u16 ParaSubAttr_Access(u16 u16Index);

u16 ParaAttr16_GetInitVal(u16 u16Index);
u16 ParaAttr16_GetMinVal(u16 u16Index);
u16 ParaAttr16_GetMaxVal(u16 u16Index);
u32 ParaAttr32_GetInitVal(u16 u16Index);
u32 ParaAttr32_GetMinVal(u16 u16Index);
u32 ParaAttr32_GetMaxVal(u16 u16Index);
u64 ParaAttr64_GetInitVal(u16 u16Index);
u64 ParaAttr64_GetMinVal(u16 u16Index);
u64 ParaAttr64_GetMaxVal(u16 u16Index);

bool ParaStoreWr(u16 u16Index, u16* pu16Buff);
bool ParaStoreRd(u16 u16Index, u16* pu16Buff);

void ParaTblCreat(void);
void ParaTblInit(void);
void ParaTblCycle(void);

#endif
