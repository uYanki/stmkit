#ifndef __PARA_TABLE_H__
#define __PARA_TABLE_H__

#include "paraattr.h"
#include "axis_defs.h"
#include "arm_math.h"

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

#define ARM_CORTEX_M0   0
#define ARM_CORTEX_M0P  1
#define ARM_CORTEX_M1P  2

#define ARM_CORTEX_M3   3
#define ARM_CORTEX_M4   4
#define ARM_CORTEX_M7   5

#define ARM_CORTEX      ARM_CORTEX_M0P

#define __ALIGNED_BYTE  1
#define __ALIGNED_WORD  2
#define __ALIGNED_DWORD 4
#define __ALIGNED_QWORD 8

#if (ARM_CORTEX == ARM_CORTEX_M0 || ARM_CORTEX == ARM_CORTEX_M0P || ARM_CORTEX == ARM_CORTEX_M1P)
// #define __PARATBL_MEMBER_ALIGNED __ALIGNED_DWORD  // 4瀛楄妭瀵归綈
#elif (ARM_CORTEX == ARM_CORTEX_M3 || ARM_CORTEX == ARM_CORTEX_M4 || ARM_CORTEX == ARM_CORTEX_M7)
// #define __PARATBL_MEMBER_ALIGNED __ALIGNED_WORD
#endif

#if 0

(((s|u)\d\d)\w+_i)\(eAxisNo\)  =>  __get_$2(pSpdCtrl->p$1)
(((s|u)\d\d)\w+_o)\(eAxisNo\) +?=(.*?);   =>   __set_$2(pSpdCtrl->p$1,$4);

#endif

// clang-format off

static inline s64 __get_s64(s64* p) { return (s64)he64((const u8*)p); }
static inline u64 __get_u64(u64* p) { return (u64)he64((const u8*)p); }

static inline void __set_s64(s64* p, s64 x) { memcpy((u8*)p, &x, sizeof(x)); }
static inline void __set_u64(u64* p, u64 x) { memcpy((u8*)p, &x, sizeof(x)); }

// clang-format on
__packed typedef struct {
    u32 u32DevScheme;                  // P0000 设备方案
    u16 _Resv2;                        // P0002 
    u16 _Resv3;                        // P0003 
    u32 u32McuSwBuildDate;             // P0004 软件构建日期
    u32 u32McuSwBuildTime;             // P0006 软件构建时间
    u16 _Resv8;                        // P0008 
    u16 _Resv9;                        // P0009 
    u16 u16LedNum;                     // P0010 指示灯个数
    u16 u16ExtDiNum;                   // P0011 外部数字量输入个数
    u16 u16ExtDoNum;                   // P0012 外部数字量输出个数
    u16 u16ExtHDiNum;                  // P0013 外部高速数字量输入个数
    u16 u16ExtHDoNum;                  // P0014 外部高速数字量输出个数
    u16 u16ExtAiNum;                   // P0015 外部模拟量输入个数
    u16 u16ExtAoNum;                   // P0016 外部模拟量输出个数
    u16 _Resv17;                       // P0017 
    u16 u16UaiHwCoeff;                 // P0018 模拟量输入AI采样系数
    u16 _Resv19;                       // P0019 
    u16 _Resv20;                       // P0020 
    u16 _Resv21;                       // P0021 
    u16 u16SysPwd;                     // P0022 系统密码
    u16 u16SysAccess;                  // P0023 当前系统权限
    u16 bSwRstCmd;                     // P0024 软件复位
    u16 _Resv25;                       // P0025 
    u16 _Resv26;                       // P0026 
    u16 _Resv27;                       // P0027 
    u16 _Resv28;                       // P0028 
    u16 u16DiState;                    // P0029 DI输入端子电平状态
    u16 u16DoState;                    // P0030 DO输出端子电平状态
    u16 _Resv31;                       // P0031 
    s16 s16Uai0Si;                     // P0032 AI0输入电压物理值
    s16 s16Uai1Si;                     // P0033 AI1输入电压物理值
    s16 s16Uai2Si;                     // P0034 AI2输入电压物理值
    s16 s16Uai3Si;                     // P0035 AI3输入电压物理值
    u16 _Resv36;                       // P0036 
    u16 u16Uai0FltrTime;               // P0037 AI0滤波时间常数
    u16 u16Uai0Zoom;                   // P0038 AI0采样缩放系数
    s16 s16Uai0Offset;                 // P0039 AI0采样偏置
    u16 u16Uai0DeadZone;               // P0040 AI0输入死区
    u16 u16Uai1FltrTime;               // P0041 AI1滤波时间常数
    u16 u16Uai1Zoom;                   // P0042 AI1采样缩放系数
    s16 s16Uai1Offset;                 // P0043 AI1采样偏置
    u16 u16Uai1DeadZone;               // P0044 AI1输入死区
    u16 u16Uai2FltrTime;               // P0045 AI2滤波时间常数
    u16 u16Uai2Zoom;                   // P0046 AI2采样缩放系数
    s16 s16Uai2Offset;                 // P0047 AI2采样偏置
    u16 u16Uai2DeadZone;               // P0048 AI2输入死区
    u16 u16Uai3FltrTime;               // P0049 AI3滤波时间常数
    u16 u16Uai3Zoom;                   // P0050 AI3采样缩放系数
    s16 s16Uai3Offset;                 // P0051 AI3采样偏置
    u16 u16Uai3DeadZone;               // P0052 AI3输入死区
    u16 _Resv53;                       // P0053 
    u16 _Resv54;                       // P0054 
    u16 bPulOutEn;                     // P0055 高速脉冲输出使能
    u32 u32PulOutCnt;                  // P0056 高速脉冲输出个数
    u32 u32PulOutFreq;                 // P0058 高速脉冲输出频率
    u16 u16PulOutDuty;                 // P0060 高速脉冲输出占空比
    u16 _Resv61;                       // P0061 
    u16 bPulInEn;                      // P0062 高速脉冲输入使能
    u16 u16PulInMode;                  // P0063 高速脉冲输入模式
    s64 s64PulInCnt;                   // P0064 高速脉冲输入计数
    u32 u32EncRes;                     // P0068 编码器分辨率
    u32 u32EncPos;                     // P0070 编码器单圈位置
    s32 s32EncTurns;                   // P0072 编码器圈数
    u16 _Resv74;                       // P0074 
    u16 bFlexPulOutEn;                 // P0075 可编程脉冲输出使能
    u32 u32FlexPulOutFreq;             // P0076 可编程脉冲输出更新频率
    u16 u16FlexPulOutStartIndex;       // P0078 可编程脉冲数据点起始索引
    u16 u16FlexPulOutStopIndex;        // P0079 可编程脉冲数据点结束索引
    u16 _Resv80;                       // P0080 
    u16 u16FlexPulOutData00;           // P0081 可编程脉冲数据点00
    u16 u16FlexPulOutData01;           // P0082 可编程脉冲数据点01
    u16 u16FlexPulOutData02;           // P0083 可编程脉冲数据点02
    u16 u16FlexPulOutData03;           // P0084 可编程脉冲数据点03
    u16 u16FlexPulOutData04;           // P0085 可编程脉冲数据点04
    u16 u16FlexPulOutData05;           // P0086 可编程脉冲数据点05
    u16 u16FlexPulOutData06;           // P0087 可编程脉冲数据点06
    u16 u16FlexPulOutData07;           // P0088 可编程脉冲数据点07
    u16 u16FlexPulOutData08;           // P0089 可编程脉冲数据点08
    u16 u16FlexPulOutData09;           // P0090 可编程脉冲数据点09
    u16 u16FlexPulOutData10;           // P0091 可编程脉冲数据点10
    u16 u16FlexPulOutData11;           // P0092 可编程脉冲数据点11
    u16 u16FlexPulOutData12;           // P0093 可编程脉冲数据点12
    u16 u16FlexPulOutData13;           // P0094 可编程脉冲数据点13
    u16 u16FlexPulOutData14;           // P0095 可编程脉冲数据点14
    u16 u16FlexPulOutData15;           // P0096 可编程脉冲数据点15
    u16 u16FlexPulOutData16;           // P0097 可编程脉冲数据点16
    u16 u16FlexPulOutData17;           // P0098 可编程脉冲数据点17
    u16 u16FlexPulOutData18;           // P0099 可编程脉冲数据点18
    u16 u16FlexPulOutData19;           // P0100 可编程脉冲数据点19
    u16 u16FlexPulOutData20;           // P0101 可编程脉冲数据点20
    u16 u16FlexPulOutData21;           // P0102 可编程脉冲数据点21
    u16 u16FlexPulOutData22;           // P0103 可编程脉冲数据点22
    u16 u16FlexPulOutData23;           // P0104 可编程脉冲数据点23
    u16 u16FlexPulOutData24;           // P0105 可编程脉冲数据点24
    u16 u16FlexPulOutData25;           // P0106 可编程脉冲数据点25
    u16 u16FlexPulOutData26;           // P0107 可编程脉冲数据点26
    u16 u16FlexPulOutData27;           // P0108 可编程脉冲数据点27
    u16 u16FlexPulOutData28;           // P0109 可编程脉冲数据点28
    u16 u16FlexPulOutData29;           // P0110 可编程脉冲数据点29
    u16 u16FlexPulOutData30;           // P0111 可编程脉冲数据点30
    u16 u16FlexPulOutData31;           // P0112 可编程脉冲数据点31
    u16 u16FlexPulOutData32;           // P0113 可编程脉冲数据点32
    u16 u16FlexPulOutData33;           // P0114 可编程脉冲数据点33
    u16 u16FlexPulOutData34;           // P0115 可编程脉冲数据点34
    u16 u16FlexPulOutData35;           // P0116 可编程脉冲数据点35
    u16 u16FlexPulOutData36;           // P0117 可编程脉冲数据点36
    u16 u16FlexPulOutData37;           // P0118 可编程脉冲数据点37
    u16 u16FlexPulOutData38;           // P0119 可编程脉冲数据点38
    u16 u16FlexPulOutData39;           // P0120 可编程脉冲数据点39
    u16 u16FlexPulOutData40;           // P0121 可编程脉冲数据点40
    u16 u16FlexPulOutData41;           // P0122 可编程脉冲数据点41
    u16 u16FlexPulOutData42;           // P0123 可编程脉冲数据点42
    u16 u16FlexPulOutData43;           // P0124 可编程脉冲数据点43
    u16 u16FlexPulOutData44;           // P0125 可编程脉冲数据点44
    u16 u16FlexPulOutData45;           // P0126 可编程脉冲数据点45
    u16 u16FlexPulOutData46;           // P0127 可编程脉冲数据点46
    u16 u16FlexPulOutData47;           // P0128 可编程脉冲数据点47
    u16 u16FlexPulOutData48;           // P0129 可编程脉冲数据点48
    u16 u16FlexPulOutData49;           // P0130 可编程脉冲数据点49
    u16 u16FlexPulOutData50;           // P0131 可编程脉冲数据点50
    u16 u16FlexPulOutData51;           // P0132 可编程脉冲数据点51
    u16 u16FlexPulOutData52;           // P0133 可编程脉冲数据点52
    u16 u16FlexPulOutData53;           // P0134 可编程脉冲数据点53
    u16 u16FlexPulOutData54;           // P0135 可编程脉冲数据点54
    u16 u16FlexPulOutData55;           // P0136 可编程脉冲数据点55
    u16 u16FlexPulOutData56;           // P0137 可编程脉冲数据点56
    u16 u16FlexPulOutData57;           // P0138 可编程脉冲数据点57
    u16 u16FlexPulOutData58;           // P0139 可编程脉冲数据点58
    u16 u16FlexPulOutData59;           // P0140 可编程脉冲数据点59
    u16 u16FlexPulOutData60;           // P0141 可编程脉冲数据点60
    u16 u16FlexPulOutData61;           // P0142 可编程脉冲数据点61
    u16 u16FlexPulOutData62;           // P0143 可编程脉冲数据点62
    u16 u16FlexPulOutData63;           // P0144 可编程脉冲数据点63
    u16 _Resv145;                      // P0145 
    u16 _Resv146;                      // P0146 
    u16 eDi0FuncSel;                   // P0147 DI0功能选择
    u16 u16Di0FltrTime;                // P0148 DI0滤波时间
    u16 eDi0LogicLvl;                  // P0149 DI0逻辑电平
    u16 eDi1FuncSel;                   // P0150 DI1功能选择
    u16 u16Di1FltrTime;                // P0151 DI1滤波时间
    u16 eDi1LogicLvl;                  // P0152 DI1逻辑电平
    u16 eDi2FuncSel;                   // P0153 DI2功能选择
    u16 u16Di2FltrTime;                // P0154 DI2滤波时间
    u16 eDi2LogicLvl;                  // P0155 DI2逻辑电平
    u16 eDi3FuncSel;                   // P0156 DI3功能选择
    u16 u16Di3FltrTime;                // P0157 DI3滤波时间
    u16 eDi3LogicLvl;                  // P0158 DI3逻辑电平
    u16 eDi4FuncSel;                   // P0159 DI4功能选择
    u16 u16Di4FltrTime;                // P0160 DI4滤波时间
    u16 eDi4LogicLvl;                  // P0161 DI4逻辑电平
    u16 eDi5FuncSel;                   // P0162 DI5功能选择
    u16 u16Di5FltrTime;                // P0163 DI5滤波时间
    u16 eDi5LogicLvl;                  // P0164 DI5逻辑电平
    u16 eDi6FuncSel;                   // P0165 DI6功能选择
    u16 u16Di6FltrTime;                // P0166 DI6滤波时间
    u16 eDi6LogicLvl;                  // P0167 DI6逻辑电平
    u16 _Resv168;                      // P0168 
    u16 u16DoStateSet;                 // P0169 DO输出设置
    u16 eDo0FuncSel;                   // P0170 DO0功能选择
    u16 eDo0LogicLvl;                  // P0171 DO0逻辑电平
    u16 eDo1FuncSel;                   // P0172 DO1功能选择
    u16 eDo1LogicLvl;                  // P0173 DO1逻辑电平
    u16 _Resv174;                      // P0174 
    s16 s16TempMcuSi;                  // P0175 主控温度物理量
    u16 _Resv176;                      // P0176 
    u16 u16MbSlvId;                    // P0177 Modbus-从站节点ID
    u32 u32MbBaudrate;                 // P0178 Modbus-从站波特率
    u16 u16MbParity;                   // P0180 Modbus-从站检验位
    u16 u16MbMstEndian;                // P0181 Modbus-主站大小端
    u16 u16MbDisconnTime;              // P0182 Modbus-通讯断开检测时间
    u16 u16MbResponseDelay;            // P0183 Modbus-命令响应延时 
    u16 _Resv184;                      // P0184 
    u16 _Resv185;                      // P0185 
    u16 u16TunerBuff01;                // P0186 
    u16 u16TunerBuff02;                // P0187 
    u16 u16TunerBuff03;                // P0188 
    u16 u16TunerBuff04;                // P0189 
    u16 u16TunerBuff05;                // P0190 
    u16 u16TunerBuff06;                // P0191 
    u16 u16TunerBuff07;                // P0192 
    u16 u16TunerBuff08;                // P0193 
    u16 u16TunerBuff09;                // P0194 
    u16 u16TunerBuff10;                // P0195 
    u16 u16TunerBuff11;                // P0196 
    u16 u16TunerBuff12;                // P0197 
    u16 u16TunerBuff13;                // P0198 
    u16 u16TunerBuff14;                // P0199 
    u16 u16TunerBuff15;                // P0200 
    u16 u16TunerBuff16;                // P0201 
    u16 u16TunerBuff17;                // P0202 
    u16 u16TunerBuff18;                // P0203 
    u16 u16TunerBuff19;                // P0204 
    u16 u16TunerBuff20;                // P0205 
    u16 u16TunerBuff21;                // P0206 
    u16 u16TunerBuff22;                // P0207 
    u16 u16TunerBuff23;                // P0208 
    u16 u16TunerBuff24;                // P0209 
    u16 u16TunerBuff25;                // P0210 
    u16 _Resv211;                      // P0211 
    u16 _Resv212;                      // P0212 
    u16 _Resv213;                      // P0213 
    u16 u16AlmCodeSeq;                 // P0214 当前所有报警代码轮巡
    u16 u16LastAlmCode;                // P0215 最新报警代码
    u16 u16HisAlmCode01;               // P0216 历史报警代码01
    u16 u16HisAlmCode02;               // P0217 历史报警代码02
    u16 u16HisAlmCode03;               // P0218 历史报警代码03
    u16 u16HisAlmCode04;               // P0219 历史报警代码04
    u16 u16HisAlmCode05;               // P0220 历史报警代码05
    u32 u32HisAlmTime01;               // P0221 历史报警时间戳01
    u32 u32HisAlmTime02;               // P0223 历史报警时间戳02
    u32 u32HisAlmTime03;               // P0225 历史报警时间戳03
    u32 u32HisAlmTime04;               // P0227 历史报警时间戳04
    u32 u32HisAlmTime05;               // P0229 历史报警时间戳05
    u16 _Resv231;                      // P0231 
    u16 _Resv232;                      // P0232 
    u16 eSysState;                     // P0233 系统状态
    u32 u32SysRunTime;                 // P0234 运行时间
    u16 _Resv236;                      // P0236 
    u16 _Resv237;                      // P0237 
    u16 u16HrTimerSel;                 // P0238 程序段运行计时选择
    u16 u16CycleScanTime;              // P0239 主循环程序Scan运行时间
    u16 u16IsrScanTime;                // P0240 中断程序Scan运行时间
    u16 u16CustomTime0;                // P0241 缺省程序运行时间0
    u16 u16CustomTime1;                // P0242 缺省程序运行时间1
    u16 _Resv243;                      // P0243 
    s16 s16Uai0Pu;                     // P0244 AI0输入电压数字量
    s16 s16Uai1Pu;                     // P0245 AI1输入电压数字量
    s16 s16Uai2Pu;                     // P0246 AI2输入电压数字量
    s16 s16Uai3Pu;                     // P0247 AI3输入电压数字量
    u16 u16TempMcuPu;                  // P0248 主控温度电压数字量
    u16 _Resv249;                      // P0249 
    u16 _Resv250;                      // P0250 
} device_para_t;

// clang-format on

// 后续该生成工具时再去掉
#define aDeviceAttr sDeviceAttr

extern const para_attr_t sDeviceAttr[];

extern device_para_t sDevicePara;

#define D          sDevicePara

#endif
