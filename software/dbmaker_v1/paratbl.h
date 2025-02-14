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
    u32 u32DrvScheme;                  // P0000 驱动器方案
    u32 u32McuSwBuildDate;             // P0002 软件构建日期
    u32 u32McuSwBuildTime;             // P0004 软件构建时间
    u16 _Resv6;                        // P0006 
    u16 u16CurSampType;                // P0007 电流采样类型
    u16 _Resv8;                        // P0008 
    u16 u16AxisNum;                    // P0009 轴数量
    u16 u16LedNum;                     // P0010 指示灯个数
    u16 u16KeyNum;                     // P0011 按键个数
    u16 u16ExtDiNum;                   // P0012 外部数字量输入个数
    u16 u16ExtDoNum;                   // P0013 外部数字量输出个数
    u16 u16ExtHDiNum;                  // P0014 外部高速数字量输入个数
    u16 u16ExtHDoNum;                  // P0015 外部高速数字量输出个数
    u16 u16ExtAiNum;                   // P0016 外部模拟量输入个数
    u16 u16ExtAoNum;                   // P0017 外部模拟量输出个数
    u16 u16TsNum;                      // P0018 温度采样个数
    u16 _Resv19;                       // P0019 
    u16 _Resv20;                       // P0020 
    u16 u16SysPwd;                     // P0021 系统密码
    u16 u16SysAccess;                  // P0022 当前系统权限
    u16 bSysRst;                       // P0023 系统软复位
    u16 _Resv24;                       // P0024 
    u16 u16UmdcHwCoeff;                // P0025 主回路电压采样系数
    u16 u16UcdcHwCoeff;                // P0026 控制电电压采样系数
    u16 u16Uai0HwCoeff;                // P0027 模拟量输入AI0采样系数
    u16 u16Uai1HwCoeff;                // P0028 模拟量输入AI1采样系数
    u16 u16Uai2HwCoeff;                // P0029 模拟量输入AI2采样系数
    u16 u16InvtTempHwCoeff;            // P0030 逆变桥温度采样系数
    u16 _Resv31;                       // P0031 
    u16 u16UmdcZoom;                   // P0032 主回路电压采样缩放系数
    s16 s16UmdcOffset;                 // P0033 主回路电压采样偏置
    u16 u16UcdcZoom;                   // P0034 控制电电压采样缩放系数
    s16 s16UcdcOffset;                 // P0035 控制电电压采样偏置
    u16 _Resv36;                       // P0036 
    u16 u16Uai0Zoom;                   // P0037 模拟量输入AI0采样缩放系数
    s16 s16Uai0Offset;                 // P0038 模拟量输入AI0采样偏置
    u16 u16Uai0DeadZone;               // P0039 模拟量输入AI0输入死区
    u16 u16Uai1Zoom;                   // P0040 模拟量输入AI1采样缩放系数
    s16 s16Uai1Offset;                 // P0041 模拟量输入AI1采样偏置
    u16 u16Uai1DeadZone;               // P0042 模拟量输入AI1输入死区
    u16 u16Uai2Zoom;                   // P0043 模拟量输入AI2采样缩放系数
    s16 s16Uai2Offset;                 // P0044 模拟量输入AI2采样偏置
    u16 u16Uai2DeadZone;               // P0045 模拟量输入AI2输入死区
    u16 _Resv46;                       // P0046 
    u16 u16TempInvtZoom;               // P0047 逆变桥温度采样缩放系数
    s16 s16TempInvtOffset;             // P0048 逆变桥温度采样偏置
    u16 _Resv49;                       // P0049 
    u16 u16DrvCurRate;                 // P0050 驱动器额定电流
    u16 _Resv51;                       // P0051 
    u16 u16UmdcErrOVSi;                // P0052 直流母线过压故障值
    u16 u16UmdcErrUVSi;                // P0053 直流母线欠压故障值
    u16 u16UmdcWrnUVSi;                // P0054 直流母线欠压警告值
    u16 u16UmdcRlyOnSi;                // P0055 直流母线缓起继电器吸合值
    u16 u16UmdcRgOnSi;                 // P0056 直流母线再生电阻放电电压值
    u16 _Resv57;                       // P0057 
    u16 u16CarryFreq;                  // P0058 载波频率
    u16 u16PosLoopFreq;                // P0059 位置环频率
    u16 u16SpdLoopFreq;                // P0060 速度环频率
    u16 u16CurLoopFreq;                // P0061 电流环频率
    u16 _Resv62;                       // P0062 
    u16 _Resv63;                       // P0063 
    u16 _Resv64;                       // P0064 
    u16 u16MbSlvId;                    // P0065 Modbus-从站节点ID
    u32 u32MbBaudrate;                 // P0066 Modbus-从站波特率
    u16 u16MbParity;                   // P0068 Modbus-从站检验位
    u16 u16MbMstEndian;                // P0069 Modbus-主站大小端
    u16 u16MbDisconnTime;              // P0070 Modbus-通讯断开检测时间
    u16 u16MbResponseDelay;            // P0071 Modbus-命令响应延时 
    u16 _Resv72;                       // P0072 
    u16 u16CopNodeId;                  // P0073 CANopen-节点ID
    u16 u16CopBitrate;                 // P0074 CANopen-比特率
    u16 u16PdoInhTime;                 // P0075 CANopen-PDO禁止时间
    u16 u16CopState;                   // P0076 CANopen-通信状态
    u16 _Resv77;                       // P0077 
    u16 u16EcatScanPrd;                // P0078 EtherCAT-通信状态
    u16 u16EcatState;                  // P0079 EtherCAT-Port0错误统计
    u16 u16EcatPort0ErrCnt;            // P0080 EtherCAT-Port1错误统计
    u16 u16EcatPort1ErrCnt;            // P0081 EtherCAT-接收错误统计
    u16 u16EcatRxErrCnt;               // P0082 EtherCAT-处理单元错误统计
    u16 u16EcatPdiErrCnt;              // P0083 
    u16 _Resv84;                       // P0084 
    u16 _Resv85;                       // P0085 
    u16 u16PanelDispPage;              // P0086 面板默认显示页面
    u16 u16PanelKeyVaule;              // P0087 面板按键键值
    u16 _Resv88;                       // P0088 
    u16 _Resv89;                       // P0089 
    u16 _Resv90;                       // P0090 
    u16 _Resv91;                       // P0091 
    u16 _Resv92;                       // P0092 
    u16 _Resv93;                       // P0093 
    u16 _Resv94;                       // P0094 
    u16 _Resv95;                       // P0095 
    u16 _Resv96;                       // P0096 
    u16 _Resv97;                       // P0097 
    u16 u16ScopeSampPrd;               // P0098 数据记录采样周期设定
    u16 u16ScopeSampPts;               // P0099 数据记录采样点数设定
    u16 u16ScopeChCnt;                 // P0100 数据记录通道数量设定
    u16 u16ScopeChSrc01;               // P0101 数据记录通道来源设定1 (数据源)
    u16 u16ScopeChSrc02;               // P0102 数据记录通道来源设定2 (数据源)
    u16 u16ScopeChSrc03;               // P0103 数据记录通道来源设定3 (数据源)
    u16 u16ScopeChSrc04;               // P0104 数据记录通道来源设定4 (数据源)
    u16 u16ScopeChAddr01;              // P0105 数据记录通道地址设定
    u16 u16ScopeChAddr02;              // P0106 数据记录通道地址设定
    u16 u16ScopeChAddr03;              // P0107 数据记录通道地址设定
    u16 u16ScopeChAddr04;              // P0108 数据记录通道地址设定
    u16 u16ScopeSampIdx;               // P0109 当前数据记录索引
    u16 u16ScopeSampSts;               // P0110 数据记录状态
    u16 _Resv111;                      // P0111 
    u16 _Resv112;                      // P0112 
    u16 _Resv113;                      // P0113 
    u16 u16AlmCodeSeq;                 // P0114 当前所有报警代码轮巡
    u16 u16LastAlmSrc;                 // P0115 最新报警来源
    u16 u16LastAlmCode;                // P0116 最新报警代码
    u16 u16HisAlmSrc01;                // P0117 历史报警代码来源01
    u16 u16HisAlmCode01;               // P0118 历史报警代码01
    u32 u32HisAlmTime01;               // P0119 历史报警时间戳01
    u16 u16HisAlmSrc02;                // P0121 历史报警代码来源02
    u16 u16HisAlmCode02;               // P0122 历史报警代码02
    u32 u32HisAlmTime02;               // P0123 历史报警时间戳02
    u16 u16HisAlmSrc03;                // P0125 历史报警代码来源03
    u16 u16HisAlmCode03;               // P0126 历史报警代码03
    u32 u32HisAlmTime03;               // P0127 历史报警时间戳03
    u16 u16HisAlmSrc04;                // P0129 历史报警代码来源04
    u16 u16HisAlmCode04;               // P0130 历史报警代码04
    u32 u32HisAlmTime04;               // P0131 历史报警时间戳04
    u16 u16HisAlmSrc05;                // P0133 历史报警代码来源05
    u16 u16HisAlmCode05;               // P0134 历史报警代码05
    u32 u32HisAlmTime05;               // P0135 历史报警时间戳05
    u16 u16HisAlmSrc06;                // P0137 历史报警代码来源06
    u16 u16HisAlmCode06;               // P0138 历史报警代码06
    u32 u32HisAlmTime06;               // P0139 历史报警时间戳06
    u16 u16HisAlmSrc07;                // P0141 历史报警代码来源07
    u16 u16HisAlmCode07;               // P0142 历史报警代码07
    u32 u32HisAlmTime07;               // P0143 历史报警时间戳07
    u16 u16HisAlmSrc08;                // P0145 历史报警代码来源08
    u16 u16HisAlmCode08;               // P0146 历史报警代码08
    u32 u32HisAlmTime08;               // P0147 历史报警时间戳08
    u16 u16HisAlmSrc09;                // P0149 历史报警代码来源09
    u16 u16HisAlmCode09;               // P0150 历史报警代码09
    u32 u32HisAlmTime09;               // P0151 历史报警时间戳09
    u16 u16HisAlmSrc10;                // P0153 历史报警代码来源10
    u16 u16HisAlmCode10;               // P0154 历史报警代码10
    u32 u32HisAlmTime10;               // P0155 历史报警时间戳10
    u16 u16HisAlmSrc11;                // P0157 历史报警代码来源11
    u16 u16HisAlmCode11;               // P0158 历史报警代码11
    u32 u32HisAlmTime11;               // P0159 历史报警时间戳11
    u16 u16HisAlmSrc12;                // P0161 历史报警代码来源12
    u16 u16HisAlmCode12;               // P0162 历史报警代码12
    u32 u32HisAlmTime12;               // P0163 历史报警时间戳12
    u16 u16HisAlmSrc13;                // P0165 历史报警代码来源13
    u16 u16HisAlmCode13;               // P0166 历史报警代码13
    u32 u32HisAlmTime13;               // P0167 历史报警时间戳13
    u16 u16HisAlmSrc14;                // P0169 历史报警代码来源14
    u16 u16HisAlmCode14;               // P0170 历史报警代码14
    u32 u32HisAlmTime14;               // P0171 历史报警时间戳14
    u16 u16HisAlmSrc15;                // P0173 历史报警代码来源15
    u16 u16HisAlmCode15;               // P0174 历史报警代码15
    u32 u32HisAlmTime15;               // P0175 历史报警时间戳15
    u16 _Resv177;                      // P0177 
    u16 _Resv178;                      // P0178 
    u16 _Resv179;                      // P0179 
    u16 u16TunerSoftVer;               // P0180 设备识别码1
    u16 u16TunerDrvType;               // P0181 设备识别码2
    u16 _Resv182;                      // P0182 
    u16 _Resv183;                      // P0183 
    u16 _Resv184;                      // P0184 
    u16 eSysState;                     // P0185 系统状态
    u32 u32SysRunTime;                 // P0186 运行时间
    u16 _Resv188;                      // P0188 
    u16 _Resv189;                      // P0189 
    u16 u16DiState;                    // P0190 DI输入端子电平状态
    u16 u16DoState;                    // P0191 DO输出端子电平状态
    u16 _Resv192;                      // P0192 
    u16 u16UmdcSi;                     // P0193 主回路母线电压物理值
    u16 u16UcdcSi;                     // P0194 控制母线电压物理值
    s16 s16UaiSi0;                     // P0195 AI0输入电压物理值
    s16 s16UaiSi1;                     // P0196 AI1输入电压物理值
    s16 s16UaiSi2;                     // P0197 AI2输入电压物理值
    u16 u16UaoSi0;                     // P0198 AO0输出电压物理值
    u16 u16UaoSi1;                     // P0199 AO1输出电压物理值
    s16 s16TempInvtSi;                 // P0200 逆变桥温度物理值
    s16 s16TempRectSi;                 // P0201 整流桥温度物理值
    s16 s16TempCtrlBrdSi;              // P0202 控制板温度物理值
    u16 _Resv203;                      // P0203 
    u16 _Resv204;                      // P0204 
    u16 u16UmdcPu;                     // P0205 主回路母线电压数字量
    u16 u16UcdcPu;                     // P0206 控制母线电压数字量
    s16 s16UaiPu0;                     // P0207 AI0输入电压数字量
    s16 s16UaiPu1;                     // P0208 AI1输入电压数字量
    s16 s16UaiPu2;                     // P0209 AI2输入电压数字量
    s16 s16TempInvtPu;                 // P0210 逆变桥温度数字量
    s16 s16TempRectPu;                 // P0211 整流桥温度数字量
    s16 s16TempCtrlBrdtPu;             // P0212 控制板温度数字量
    u16 _Resv213;                      // P0213 
    u16 _Resv214;                      // P0214 
    u16 u16ProbeStatus;                // P0215 探针状态
    s64 s64ProbePosEdgePos00;          // P0216 探针1上升沿锁存位置
    s64 s64ProbeNegEdgePos00;          // P0220 探针1下降沿锁存位置
    s64 s64ProbePosEdgePos01;          // P0224 探针2上升沿锁存位置
    s64 s64ProbeNegEdgePos01;          // P0228 探针2下降沿锁存位置
    s64 s64ProbePosEdgePos02;          // P0232 探针3上升沿锁存位置
    s64 s64ProbeNegEdgePos02;          // P0236 探针3下降沿锁存位置
    s64 s64ProbePosEdgePos03;          // P0240 探针4上升沿锁存位置
    s64 s64ProbeNegEdgePos03;          // P0244 探针4下降沿锁存位置
    u16 _Resv248;                      // P0248 
    u16 _Resv249;                      // P0249 
    u16 _Resv250;                      // P0250 
    u16 _Resv251;                      // P0251 
    u16 u16HrTimerSel;                 // P0252 程序段运行计时选择
    u16 u16CycleScanTime;              // P0253 主循环程序Scan运行时间
    u16 u16IsrScanATime;               // P0254 中断程序ScanA运行时间
    u16 u16IsrScanBTime;               // P0255 中断程序ScanB运行时间
    u16 u16IsrPosLoopTime;             // P0256 中断程序位置环运行时间
    u16 u16IsrSpdLoopTime;             // P0257 中断程序速度环运行时间
    u16 u16IsrCurLoopTime;             // P0258 中断程序电流环运行时间
    u16 u16CustomTime0;                // P0259 缺省程序运行时间0
    u16 u16CustomTime1;                // P0260 缺省程序运行时间1
    u16 _Resv261;                      // P0261 
    u16 _Resv262;                      // P0262 
    u16 _Resv263;                      // P0263 
    u16 _Resv264;                      // P0264 
    u16 _Resv265;                      // P0265 
    u16 _Resv266;                      // P0266 
    u16 _Resv267;                      // P0267 
    u16 _Resv268;                      // P0268 
    u16 _Resv269;                      // P0269 
    u16 _Resv270;                      // P0270 270, A4 曲线采样选择
    u16 _Resv271;                      // P0271 
    u16 _Resv272;                      // P0272 272, A4 曲线采样周期
    u16 _Resv273;                      // P0273 
    u16 _Resv274;                      // P0274 
    u16 _Resv275;                      // P0275 
    u16 _Resv276;                      // P0276 
    u16 _Resv277;                      // P0277 277, A4 曲线采样选择
    u16 _Resv278;                      // P0278 278, A4 曲线采样点数
    u16 _Resv279;                      // P0279 
    u16 _Resv280;                      // P0280 
    u16 _Resv281;                      // P0281 
    u16 _Resv282;                      // P0282 
    u16 _Resv283;                      // P0283 
    u16 _Resv284;                      // P0284 
    u16 _Resv285;                      // P0285 
    u16 _Resv286;                      // P0286 
    u16 _Resv287;                      // P0287 
    u16 _Resv288;                      // P0288 
    u16 _Resv289;                      // P0289 
    u16 _Resv290;                      // P0290 
    u16 _Resv291;                      // P0291 
    u16 _Resv292;                      // P0292 
    u16 _Resv293;                      // P0293 
    u16 _Resv294;                      // P0294 
    u16 _Resv295;                      // P0295 
    u16 _Resv296;                      // P0296 
    u16 _Resv297;                      // P0297 
    u16 _Resv298;                      // P0298 
    u16 _Resv299;                      // P0299 
    u16 _Resv300;                      // P0300 
    u16 _Resv301;                      // P0301 
    u16 _Resv302;                      // P0302 
    u16 _Resv303;                      // P0303 
    u16 _Resv304;                      // P0304 
    u16 _Resv305;                      // P0305 
    u16 _Resv306;                      // P0306 
    u16 _Resv307;                      // P0307 
    u16 _Resv308;                      // P0308 
    u16 _Resv309;                      // P0309 
    u16 _Resv310;                      // P0310 
    u16 _Resv311;                      // P0311 
    u16 _Resv312;                      // P0312 
    u16 _Resv313;                      // P0313 
    u16 _Resv314;                      // P0314 
    u16 _Resv315;                      // P0315 
    u16 _Resv316;                      // P0316 
    u16 _Resv317;                      // P0317 
    s16 s16DbgBuf1;                    // P0318 
    s16 s16DbgBuf2;                    // P0319 
    s16 s16DbgBuf3;                    // P0320 
    s16 s16DbgBuf4;                    // P0321 
    u16 u16DbgBuf1;                    // P0322 
    u16 u16DbgBuf2;                    // P0323 
    u16 u16DbgBuf3;                    // P0324 
    u16 u16DbgBuf4;                    // P0325 
    s32 s32DbgBuf1;                    // P0326 
    s32 s32DbgBuf2;                    // P0328 
    s32 s32DbgBuf3;                    // P0330 
    s32 s32DbgBuf4;                    // P0332 
    u32 u32DbgBuf1;                    // P0334 
    u32 u32DbgBuf2;                    // P0336 
    u32 u32DbgBuf3;                    // P0338 
    u32 u32DbgBuf4;                    // P0340 
    u16 _Resv342;                      // P0342 
} device_para_t;

__packed typedef struct {
    u16 eAxisNo;                       // P9000 轴号
    u16 _Resv9001;                     // P9001 
    u16 u16MotEncSel;                  // P9002 电机选择
    u16 u16MotPolePairs;               // P9003 电机极对数
    u32 u32MotInertia;                 // P9004 电机转动惯量
    u16 u16MotStatorRes;               // P9006 电机定子电阻
    u16 u16MotStatorLd;                // P9007 电机定子D轴电感
    u16 u16MotStatorLq;                // P9008 电机定子Q轴电感
    u16 u16MotEmfCoeff;                // P9009 电机反电动势常数
    u16 u16MotTrqCoeff;                // P9010 电机转矩系数
    u16 u16MotTm;                      // P9011 电机机械时间常数
    u16 u16MotVoltInRate;              // P9012 电机额定输入电压
    u16 u16MotPowerRate;               // P9013 电机额定功率
    u16 u16MotCurRate;                 // P9014 电机额定电流
    u16 u16MotCurMax;                  // P9015 电机最大电流
    u16 u16MotTrqRate;                 // P9016 电机额定转矩
    u16 u16MotTrqMax;                  // P9017 电机最大转矩
    u16 u16MotSpdRate;                 // P9018 电机额定转速
    u16 u16MotSpdMax;                  // P9019 电机最大转速
    u16 u16MotAccMax;                  // P9020 电机最大加速度
    u16 u16EncSN;                      // P9021 编码器序列号
    u16 u16EncMethod;                  // P9022 编码器原理
    u16 u16EncType;                    // P9023 编码器类型
    u32 u32EncRes;                     // P9024 编码器分辨率
    u32 u32EncPosOffset;               // P9026 电角度偏置
    u32 u32EncPosInit;                 // P9028 编码器初始位置
    u32 u32EncPos;                     // P9030 编码器单圈位置
    s32 s32EncTurns;                   // P9032 编码器圈数
    s64 s64EncMultPos;                 // P9034 编码器多圈位置
    u16 u16EncHallState;               // P9038 编码器霍尔真值状态
    u16 _Resv9039;                     // P9039 
    u16 u16AbsEncWorkMode;             // P9040 轴配置.绝对值编码器工作模式
    u16 _Resv9041;                     // P9041 
    u16 _Resv9042;                     // P9042 
    u16 u16PwmFreq;                    // P9043 PWM载波频率
    u16 u16PwmDutyMax;                 // P9044 PWM最大占空比
    u16 u16PwmDeadband;                // P9045 PWM死区时间
    u16 _Resv9046;                     // P9046 
    u16 _Resv9047;                     // P9047 
    u16 _Resv9048;                     // P9048 
    u16 u16PosLoopKp;                  // P9049 轴配置.位置环增益系数
    u16 u16PosLoopKi;                  // P9050 轴配置.位置环积分系数
    u16 u16SpdLoopKp;                  // P9051 轴配置.速度环增益系数
    u16 u16SpdLoopKi;                  // P9052 轴配置.速度环积分系数
    u16 u16CurLoopIqKp;                // P9053 轴配置.电流环转矩增益系数
    u16 u16CurLoopIqKi;                // P9054 轴配置.电流环转矩积分系数
    u16 u16CurLoopIdKp;                // P9055 轴配置.电流环磁链增益系数
    u16 u16CurLoopIdKi;                // P9056 轴配置.电流环磁链积分系数
    u16 _Resv9057;                     // P9057 
    u16 u16SpdRefFltrTc;               // P9058 轴配置.速度指令滤波常数
    u16 u16SpdFbFltrTc;                // P9059 轴配置.速度反馈滤波常数
    u16 u16IdRefFltrTc;                // P9060 轴配置.转矩指令滤波常数
    u16 u16IdFbFltrTc;                 // P9061 轴配置.转矩反馈滤波常数
    u16 u16IqRefFltrTc;                // P9062 轴配置.磁链指令滤波常数
    u16 u16IqFbFltrTc;                 // P9063 轴配置.磁链反馈滤波常数
    u16 _Resv9064;                     // P9064 
    u16 u16CurSampDir;                 // P9065 轴配置.电流采样方向
    u16 u16IphHwCoeff;                 // P9066 轴配置.电流硬件采样系数
    u16 u16IphZoom;                    // P9067 轴配置.电流缩放系数
    s16 s16IaOffset;                   // P9068 轴配置.U相电流偏置标幺值
    s16 s16IbOffset;                   // P9069 轴配置.V相电流偏置标幺值
    s16 s16IcOffset;                   // P9070 轴配置.W相电流偏置标幺值
    u16 _Resv9071;                     // P9071 
    u16 u16SpdMaxGain;                 // P9072 轴配置.最大速度增益
    u16 _Resv9073;                     // P9073 
    u16 u16CurRateDigMot;              // P9074 轴配置.额定电流数字量
    u16 _Resv9075;                     // P9075 
    u16 _Resv9076;                     // P9076 
    u16 u16OverCurrTh;                 // P9077 轴配置.软件过流阈值
    u16 u16OverSpdTh;                  // P9078 轴配置.过速阈值
    u16 u16OverTempTh;                 // P9079 轴配置.过热阈值
    u16 u16OverLoadCoeff;              // P9080 轴配置.过载倍数
    u16 _Resv9081;                     // P9081 
    u16 _Resv9082;                     // P9082 
    u16 _Resv9083;                     // P9083 
    u16 _Resv9084;                     // P9084 
    u16 _Resv9085;                     // P9085 
    u16 _Resv9086;                     // P9086 
    u16 _Resv9087;                     // P9087 
    u16 _Resv9088;                     // P9088 
    u16 _Resv9089;                     // P9089 
    u16 _Resv9090;                     // P9090 
    u16 _Resv9091;                     // P9091 
    u16 _Resv9092;                     // P9092 
    u16 _Resv9093;                     // P9093 
    u16 _Resv9094;                     // P9094 
    u16 eCtrlMethod;                   // P9095 用户层.控制方法
    u16 eAppSel;                       // P9096 用户层.应用选择
    u16 eCtrlMode;                     // P9097 用户层.控制模式
    u16 eCtrlCmdSrc;                   // P9098 用户层.控制命令来源
    u16 eDiSrc;                        // P9099 用户层.外部或虚拟DI选择
    u16 eDoSrc;                        // P9100 用户层.外部或虚拟DO选择
    u32 u32CommCmd;                    // P9101 用户层.通信命令字
    u32 u32DiCmd;                      // P9103 用户层.DI命令字
    u16 u16PwrOnConf;                  // P9105 用户层.上电配置
    u16 _Resv9106;                     // P9106 
    u16 _Resv9107;                     // P9107 
    u16 _Resv9108;                     // P9108 
    u16 _Resv9109;                     // P9109 
    u16 _Resv9110;                     // P9110 
    u16 _Resv9111;                     // P9111 
    u16 _Resv9112;                     // P9112 
    u16 _Resv9113;                     // P9113 
    u16 _Resv9114;                     // P9114 
    u16 _Resv9115;                     // P9115 
    u16 _Resv9116;                     // P9116 
    u16 _Resv9117;                     // P9117 
    u16 _Resv9118;                     // P9118 
    u16 _Resv9119;                     // P9119 
    u16 _Resv9120;                     // P9120 
    u16 _Resv9121;                     // P9121 
    u16 _Resv9122;                     // P9122 
    u16 _Resv9123;                     // P9123 
    u16 _Resv9124;                     // P9124 
    u16 _Resv9125;                     // P9125 
    u16 _Resv9126;                     // P9126 
    u16 _Resv9127;                     // P9127 
    u16 _Resv9128;                     // P9128 
    u16 _Resv9129;                     // P9129 
    u16 _Resv9130;                     // P9130 
    u16 u16OpenLoopEn;                 // P9131 应用层.开环测试使能
    u16 u16OpenPeriod;                 // P9132 应用层.开环测试.运行周期
    s16 s16OpenElecAngLock;            // P9133 应用层.开环测试.电角度锁定位置
    s16 s16OpenElecAngInc;             // P9134 应用层.开环测试.电角度自增量
    s16 s16OpenUqRef;                  // P9135 应用层.开环测试.Q轴指令
    s16 s16OpenUdRef;                  // P9136 应用层.开环测试.D轴指令
    u16 _Resv9137;                     // P9137 
    u16 u16MotEncIdentEn;              // P9138 应用层.电机编码器辨识使能
    u16 u16MotEncIdentDirMatched;      // P9139 应用层.电机编码器辨识.方向匹配状态
    u16 u16MotEncIdentPolePairs;       // P9140 应用层.电机编码器辨识.电机极对数
    u32 u32MotEncIdentOffset;          // P9141 应用层.电机编码器辨识.编码器安装偏置角
    u32 u32MotEncIdentRes;             // P9143 应用层.电机编码器辨识.编码器分辨率
    u16 u16MotEncIdentState;           // P9145 应用层.电机编码器辨识.运行状态
    u16 u16MotEncIdentErr;             // P9146 应用层.电机编码器辨识.错误类型
    u16 _Resv9147;                     // P9147 
    u16 u16MotParaIdentEn;             // P9148 应用层.电机参数辨识使能
    u16 u16MotParaIdentRs;             // P9149 应用层.电机参数辨识.电机相电阻
    u16 u16MotParaIdentLd;             // P9150 应用层.电机参数辨识.电机D轴电感
    u16 u16MotParaIdentLq;             // P9151 应用层.电机参数辨识.电机Q轴电感
    u16 u16MotParaIdentFluxLk;         // P9152 应用层.电机参数辨识.电机磁链
    u16 _Resv9153;                     // P9153 
    u16 u16MainDcCapEn;                // P9154 应用层.主回路母线电容辨识使能
    u32 u32MainDcCapValue;             // P9155 应用层.主回路母线电容辨识.电容容量
    u16 _Resv9157;                     // P9157 
    u16 _Resv9158;                     // P9158 
    u16 eLoopRspModeSel;               // P9159 应用层.响应测试.环路选择
    s64 s64LoopRspStep;                // P9160 应用层.响应测试.环路给定值
    u16 _Resv9164;                     // P9164 
    u16 _Resv9165;                     // P9165 
    u16 _Resv9166;                     // P9166 
    u16 _Resv9167;                     // P9167 
    u16 _Resv9168;                     // P9168 
    u16 _Resv9169;                     // P9169 
    u16 _Resv9170;                     // P9170 
    u16 _Resv9171;                     // P9171 
    u16 _Resv9172;                     // P9172 
    u16 _Resv9173;                     // P9173 
    u16 _Resv9174;                     // P9174 
    u16 _Resv9175;                     // P9175 
    u16 u16EncCmd;                     // P9176 编码器指令
    u16 u16EncErrCode;                 // P9177 编码器错误代码
    u16 u16EncComErrSum;               // P9178 编码器通信错误次数
    u16 _Resv9179;                     // P9179 
    u16 eAxisFSM;                      // P9180 轴状态机
    u16 bPwmSwSts;                     // P9181 PWM状态
    u16 _Resv9182;                     // P9182 
    s64 s64UserPosRef;                 // P9183 用户层.用户位置指令
    s64 s64UserPosFb;                  // P9187 用户层.用户位置反馈
    s32 s32UserPosErr;                 // P9191 用户层.用户速度误差
    s32 s32UserSpdRef;                 // P9193 用户层.用户速度指令
    s32 s32UserSpdFb;                  // P9195 用户层.用户速度反馈
    s16 s16UserTrqRef;                 // P9197 用户层.用户转矩指令千分比
    s16 s16UserTrqFb;                  // P9198 用户层.用户转矩反馈千分比
    u16 _Resv9199;                     // P9199 
    s16 s16IaFbSi;                     // P9200 A相反馈电流物理值
    s16 s16IbFbSi;                     // P9201 B相反馈电流物理值
    s16 s16IcFbSi;                     // P9202 C相反馈电流物理值
    u16 _Resv9203;                     // P9203 
    u16 _Resv9204;                     // P9204 
    u16 _Resv9205;                     // P9205 
    u16 _Resv9206;                     // P9206 
    u16 eLogicCtrlMethod;              // P9207 逻辑层.控制方式
    u16 eLogicCtrlMode;                // P9208 逻辑层.控制模式
    u16 _Resv9209;                     // P9209 
    u16 bLogicDrvEnCmd;                // P9210 逻辑层.伺服使能
    u16 bLogicJogFwdCmd;               // P9211 逻辑层.正向点动
    u16 bLogicJogRevCmd;               // P9212 逻辑层.反向点动
    u16 bLogicStopCmd;                 // P9213 逻辑层.停机指令
    u16 bLogicHomingCmd;               // P9214 逻辑层.回原使能
    u16 bLogicPosRevokeCmd;            // P9215 逻辑层.位置指令中断
    u16 bLogicMultMotionEn;            // P9216 逻辑层.多段启动使能
    u16 bLogicPosLimFwd;               // P9217 逻辑层.正向限位使能
    u16 bLogicPosLimRev;               // P9218 逻辑层.反向限位使能
    u16 bLogicAlmRst;                  // P9219 逻辑层.报警复位
    u16 bLogicEncTurnClr;              // P9220 逻辑层.多圈复位
    u16 bLogicHomeSig;                 // P9221 逻辑层.原点信号
    u16 bLogicRotDirSel;               // P9222 逻辑层.旋转方向
    u16 _Resv9223;                     // P9223 
    s64 s64LogicPosRef;                // P9224 逻辑层.位置指令
    s64 s64LogicPosRefGear;            // P9228 逻辑层.位置指令(齿轮比缩放后)
    s64 s64LogicPosDigLimFwdGear;      // P9232 逻辑层.正向数字限位(齿轮比缩放后)
    s64 s64LogicPosDigLimRevGear;      // P9236 逻辑层.反向数字限位(齿轮比缩放后)
    u16 eLogicPosPlanMode;             // P9240 逻辑层.位置规划模式
    u16 _Resv9241;                     // P9241 
    s32 s32LogicSpdRef;                // P9242 逻辑层.速度指令
    u16 u16LogicSpdAccTime;            // P9244 逻辑层.加速度时间
    u16 u16LogicSpdDecTime;            // P9245 逻辑层.减速度时间
    u16 eLogicSpdPlanMode;             // P9246 逻辑层.速度规划模式
    s32 s32LogicSpdLimFwd;             // P9247 逻辑层.正向速度限制
    s32 s32LogicSpdLimRev;             // P9249 逻辑层.反向速度限制
    u16 _Resv9251;                     // P9251 
    s16 s16LogicFluxRef;               // P9252 逻辑层.磁通指令
    s16 s16LogicTrqRef;                // P9253 逻辑层.转矩指令
    s16 s16LogicTrqLimFwd;             // P9254 逻辑层.正向转矩限制
    s16 s16LogicTrqLimRev;             // P9255 逻辑层.反向转矩限制
    u16 _Resv9256;                     // P9256 
    u16 _Resv9257;                     // P9257 
    s64 s64PlanPosRef;                 // P9258 规划层.位置指令
    s32 s32PlanSpdRef;                 // P9262 规划层.速度指令
    s16 s16PlanIqRef;                  // P9264 规划层.转矩指令
    s16 s16PlanIdRef;                  // P9265 规划层.磁通指令
    s32 s32PosPlanSpdRef;              // P9266 规划层.位置规划速度指令
    u16 _Resv9268;                     // P9268 
    u16 _Resv9269;                     // P9269 
    u16 _Resv9270;                     // P9270 
    s32 s32DrvPosErr;                  // P9271 驱动层.位置误差
    s32 s32DrvPosPropGain;             // P9273 驱动层.位置环PI比例增益
    s32 s32DrvPosInteGain;             // P9275 驱动层.位置环PI积分增益
    u16 _Resv9277;                     // P9277 
    s32 s32DrvSpdErr;                  // P9278 驱动层.速度偏差
    s32 s32DrvSpdPropGain;             // P9280 驱动层.速度环PI比例增益
    s32 s32DrvSpdInteGain;             // P9282 驱动层.速度环PI积分增益
    s32 s32SpdLoopProp;                // P9284 驱动层.速度环PI比例项
    s32 s32SpdLoopInte;                // P9286 驱动层.速度环PI积分项
    s32 s32SpdLoopOut;                 // P9288 驱动层.速度环PI输出
    u16 _Resv9290;                     // P9290 
    s16 s16DrvIqErr;                   // P9291 驱动层.转矩误差数字量
    s16 s16DrvIqPropGain;              // P9292 驱动层.电流环Q轴PI比例增益
    s16 s16DrvIqInteGain;              // P9293 驱动层.电流环Q轴PI积分增益
    s32 s32CurLoopIqProp;              // P9294 驱动层.电流环Q轴PI比例项
    s32 s32CurLoopIqInte;              // P9296 驱动层.电流环Q轴PI积分项
    s16 s16CurLoopIqOut;               // P9298 驱动层.电流环Q轴PI输出
    s16 _Resv9299;                     // P9299 
    s16 s16DrvIdErr;                   // P9300 驱动层.磁通误差数字量
    s16 s16DrvIdPropGain;              // P9301 驱动层.电流环D轴PI比例增益
    s16 s16DrvIdInteGain;              // P9302 驱动层.电流环D轴PI积分增益
    s32 s32CurLoopIdProp;              // P9303 驱动层.电流环D轴PI比例项
    s32 s32CurLoopIdInte;              // P9305 驱动层.电流环D轴PI积分项
    s16 s16CurLoopIdOut;               // P9307 驱动层.电流环D轴PI输出
    u16 _Resv9308;                     // P9308 
    s16 s16IaZeroPu;                   // P9309 驱动层.U相电流零漂标幺值
    s16 s16IbZeroPu;                   // P9310 驱动层.V相电流零漂标幺值
    s16 s16IcZeroPu;                   // P9311 驱动层.W相电流零漂标幺值
    s16 s16IaFbPu;                     // P9312 驱动层.U相电流反馈标幺值
    s16 s16IbFbPu;                     // P9313 驱动层.V相电流反馈标幺值
    s16 s16IcFbPu;                     // P9314 驱动层.W相电流反馈标幺值
    s16 s16IalphaFb;                   // P9315 驱动层.Alpha轴反馈
    s16 s16IbetaFb;                    // P9316 驱动层.Beta轴反馈
    s16 s16IqFb;                       // P9317 驱动层.Q轴反馈(滤波前)
    s16 s16IdFb;                       // P9318 驱动层.D轴反馈(滤波前)
    u16 u16ElecAngFb;                  // P9319 驱动层.电角度反馈
    u16 _Resv9320;                     // P9320 
    u16 u16ElecAngRef;                 // P9321 驱动层.电角度指令
    s16 s16IdRef;                      // P9322 驱动层.D轴电压输出(限幅后)
    s16 s16IqRef;                      // P9323 驱动层.Q轴电压输出(限幅后)
    s16 s16IalphaRef;                  // P9324 驱动层.Alpha轴电压输出
    s16 s16IbetaRef;                   // P9325 驱动层.Beta轴电压输出
    u16 eSvpwmSector;                  // P9326 驱动层.SVPWM矢量扇区
    u16 u16PwmaComp;                   // P9327 驱动层.A相PWM比较值
    u16 u16PwmbComp;                   // P9328 驱动层.B相PWM比较值
    u16 u16PwmcComp;                   // P9329 驱动层.C相PWM比较值
    u16 _Resv9330;                     // P9330 
    s32 s32DrvSpdRef;                  // P9331 驱动层.速度指令(限幅后)
    s32 s32DrvSpdFb;                   // P9333 驱动层.速度反馈(滤波后)
    s64 s64DrvPosRef;                  // P9335 驱动层.位置指令
    s64 s64DrvPosFb;                   // P9339 驱动层.位置反馈
    s16 s16DrvIqFb;                    // P9343 驱动层.Q轴反馈(滤波后)
    s16 s16DrvIdFb;                    // P9344 驱动层.D轴反馈(滤波后)
    u16 _Resv9345;                     // P9345 
    u16 _Resv9346;                     // P9346 
    u16 _Resv9347;                     // P9347 
    u16 _Resv9348;                     // P9348 
    u16 _Resv9349;                     // P9349 
    u16 _Resv9350;                     // P9350 
    u16 _Resv9351;                     // P9351 
    u16 _Resv9352;                     // P9352 
    u16 eStopMode;                     // P9353 用户层.停机模式
    u16 eStopPlanMode;                 // P9354 用户层.停机规划模式
    s32 s32StopPosRef;                 // P9355 
    u16 _Resv9357;                     // P9357 
    u16 _Resv9358;                     // P9358 
    u16 _Resv9359;                     // P9359 
    u16 ePosRefSrc;                    // P9360 用户层.位置指令来源
    s64 s64PosDigRef;                  // P9361 用户层.数字位置指令
    u16 u16PosPlanSpdMax;              // P9365 用户层.位置规划速度上限
    u16 _Resv9366;                     // P9366 
    u16 ePosDigRefType;                // P9367 
    u16 ePosRefSet;                    // P9368 
    u16 u16PosMulRefSel;               // P9369 
    u16 _Resv9370;                     // P9370 
    u16 _Resv9371;                     // P9371 
    u16 _Resv9372;                     // P9372 
    u16 _Resv9373;                     // P9373 
    u16 ePosPlanMode;                  // P9374 用户层.位置规划模式
    u16 ePosLimSrc;                    // P9375 用户层.位置指令来源
    s64 s64PosLimFwd;                  // P9376 用户层.数字位置指令
    s64 s64PosLimRev;                  // P9380 用户层.位置规划模式
    u16 ePosLimSts;                    // P9384 位置限制状态
    u16 _Resv9385;                     // P9385 
    u32 u32ElecGearNum;                // P9386 用户层.电子齿轮比分子
    u32 u32ElecGearDeno;               // P9388 用户层.电子齿轮比分母
    u16 _Resv9390;                     // P9390 
    u16 u16EncFreqDivDir;              // P9391 用户层.编码器分频输出脉冲方向
    u16 u16EncFreqDivNum;              // P9392 用户层.编码器分频输出分子
    u16 u16EncFreqDivDeno;             // P9393 用户层.编码器分频输出分母
    u16 _Resv9394;                     // P9394 
    s64 s64PosDigRef01;                // P9395 用户层.多段数字位置指令01
    s64 s64PosDigRef02;                // P9399 用户层.多段数字位置指令02
    s64 s64PosDigRef03;                // P9403 用户层.多段数字位置指令03
    s64 s64PosDigRef04;                // P9407 用户层.多段数字位置指令04
    s64 s64PosDigRef05;                // P9411 用户层.多段数字位置指令05
    s64 s64PosDigRef06;                // P9415 用户层.多段数字位置指令06
    s64 s64PosDigRef07;                // P9419 用户层.多段数字位置指令07
    s64 s64PosDigRef08;                // P9423 用户层.多段数字位置指令08
    s64 s64PosDigRef09;                // P9427 用户层.多段数字位置指令09
    s64 s64PosDigRef10;                // P9431 用户层.多段数字位置指令10
    s64 s64PosDigRef11;                // P9435 用户层.多段数字位置指令11
    s64 s64PosDigRef12;                // P9439 用户层.多段数字位置指令12
    s64 s64PosDigRef13;                // P9443 用户层.多段数字位置指令13
    s64 s64PosDigRef14;                // P9447 用户层.多段数字位置指令14
    s64 s64PosDigRef15;                // P9451 用户层.多段数字位置指令15
    s64 s64PosDigRef16;                // P9455 用户层.多段数字位置指令16
    u16 _Resv9459;                     // P9459 
    u16 _Resv9460;                     // P9460 
    u16 _Resv9461;                     // P9461 
    u16 _Resv9462;                     // P9462 
    u16 _Resv9463;                     // P9463 
    u16 _Resv9464;                     // P9464 
    u16 _Resv9465;                     // P9465 
    u16 _Resv9466;                     // P9466 
    u16 _Resv9467;                     // P9467 
    u16 _Resv9468;                     // P9468 
    u16 _Resv9469;                     // P9469 
    u16 _Resv9470;                     // P9470 
    u16 _Resv9471;                     // P9471 
    u16 _Resv9472;                     // P9472 
    u16 _Resv9473;                     // P9473 
    u16 _Resv9474;                     // P9474 
    u16 _Resv9475;                     // P9475 
    u16 _Resv9476;                     // P9476 
    u16 _Resv9477;                     // P9477 
    u16 _Resv9478;                     // P9478 
    u16 _Resv9479;                     // P9479 
    u16 _Resv9480;                     // P9480 
    u16 _Resv9481;                     // P9481 
    u16 _Resv9482;                     // P9482 
    u16 _Resv9483;                     // P9483 
    u16 _Resv9484;                     // P9484 
    u16 _Resv9485;                     // P9485 
    u16 _Resv9486;                     // P9486 
    u16 eSpdRefSrc;                    // P9487 用户层.速度指令来源
    s16 s16SpdDigRef;                  // P9488 用户层.数字速度指令
    u16 _Resv9489;                     // P9489 
    u16 eSpdPlanMode;                  // P9490 用户层.速度规划模式
    u16 u16JogSpdDigRef;               // P9491 用户层.点动速度指令
    u16 u16JogAccDecTime;              // P9492 用户层.点动加减速时间
    u16 _Resv9493;                     // P9493 
    u16 eSpdLimSrc;                    // P9494 用户层.速度限制来源
    u16 u16SpdLimFwd;                  // P9495 用户层.速度限制0
    u16 u16SpdLimRev;                  // P9496 用户层.速度限制1
    u16 eSpdLimSts;                    // P9497 速度限制状态
    u16 _Resv9498;                     // P9498 
    u16 u16AiSpdCoeff0;                // P9499 
    u16 u16AiSpdCoeff1;                // P9500 
    u16 u16AiSpdCoeff2;                // P9501 
    u16 _Resv9502;                     // P9502 
    u16 u16AccTime0;                   // P9503 用户层.加速时间0
    u16 u16DecTime0;                   // P9504 用户层.减速时间0
    u16 u16AccTime1;                   // P9505 用户层.加速时间1
    u16 u16DecTime1;                   // P9506 用户层.减速时间1
    u16 _Resv9507;                     // P9507 
    u16 _Resv9508;                     // P9508 
    u16 u16SpdMulRefSel;               // P9509 用户层.多段速度选择
    s16 s16SpdDigRef01;                // P9510 用户层.多段数字速度指令01
    s16 s16SpdDigRef02;                // P9511 用户层.多段数字速度指令02
    s16 s16SpdDigRef03;                // P9512 用户层.多段数字速度指令03
    s16 s16SpdDigRef04;                // P9513 用户层.多段数字速度指令04
    s16 s16SpdDigRef05;                // P9514 用户层.多段数字速度指令05
    s16 s16SpdDigRef06;                // P9515 用户层.多段数字速度指令06
    s16 s16SpdDigRef07;                // P9516 用户层.多段数字速度指令07
    s16 s16SpdDigRef08;                // P9517 用户层.多段数字速度指令08
    s16 s16SpdDigRef09;                // P9518 用户层.多段数字速度指令09
    s16 s16SpdDigRef10;                // P9519 用户层.多段数字速度指令10
    s16 s16SpdDigRef11;                // P9520 用户层.多段数字速度指令11
    s16 s16SpdDigRef12;                // P9521 用户层.多段数字速度指令12
    s16 s16SpdDigRef13;                // P9522 用户层.多段数字速度指令13
    s16 s16SpdDigRef14;                // P9523 用户层.多段数字速度指令14
    s16 s16SpdDigRef15;                // P9524 用户层.多段数字速度指令15
    s16 s16SpdDigRef16;                // P9525 用户层.多段数字速度指令16
    u16 _Resv9526;                     // P9526 
    u16 _Resv9527;                     // P9527 
    u16 _Resv9528;                     // P9528 
    u16 u16HomingSpd;                  // P9529 用户层.回原速度
    u16 _Resv9530;                     // P9530 
    u16 _Resv9531;                     // P9531 
    u16 _Resv9532;                     // P9532 
    u16 _Resv9533;                     // P9533 
    u16 _Resv9534;                     // P9534 
    u16 _Resv9535;                     // P9535 
    u16 _Resv9536;                     // P9536 
    u16 _Resv9537;                     // P9537 
    u16 _Resv9538;                     // P9538 
    u16 _Resv9539;                     // P9539 
    u16 _Resv9540;                     // P9540 
    u16 _Resv9541;                     // P9541 
    u16 _Resv9542;                     // P9542 
    u16 _Resv9543;                     // P9543 
    u16 _Resv9544;                     // P9544 
    u16 _Resv9545;                     // P9545 
    u16 _Resv9546;                     // P9546 
    u16 _Resv9547;                     // P9547 
    u16 _Resv9548;                     // P9548 
    u16 eTrqRefSrc;                    // P9549 用户层.转矩指令来源
    s16 s16TrqDigRef;                  // P9550 用户层.数字转矩指令千分比
    s16 s16FluxDigRef;                 // P9551 用户层.数字磁链指令千分比
    u16 u16EmStopTrqDigRef;            // P9552 用户层.紧急停机转矩
    u16 u16TrqSlopeLim;                // P9553 用户层.转矩斜率限制
    u16 eTrqLimSrc;                    // P9554 用户层.转矩限制来源
    u16 u16TrqLimFwd;                  // P9555 用户层.转矩限制0
    u16 u16TrqLimRev;                  // P9556 用户层.转矩限制1
    u16 eTrqLimSts;                    // P9557 转矩限制状态
    u16 eTrqSpdLimSts;                 // P9558 转矩模式速度限制状态
    u16 eTrqPosLimSts;                 // P9559 转矩模式位置限制状态
    u16 _Resv9560;                     // P9560 
    u16 u16TrqArriveTh;                // P9561 用户层.转矩到达阈值
    u16 _Resv9562;                     // P9562 
    u16 _Resv9563;                     // P9563 
    u16 _Resv9564;                     // P9564 
    u16 u16AiTrqCoeff0;                // P9565 用户层.模拟量AI0转矩系数
    u16 u16AiTrqCoeff1;                // P9566 用户层.模拟量AI1转矩系数
    u16 _Resv9567;                     // P9567 
    u16 u16TrqMulRefSel;               // P9568 用户层.多段转矩指令选择
    s16 s16TrqDigRef01;                // P9569 用户层.多段数字转矩指令01
    s16 s16TrqDigRef02;                // P9570 用户层.多段数字转矩指令02
    s16 s16TrqDigRef03;                // P9571 用户层.多段数字转矩指令03
    s16 s16TrqDigRef04;                // P9572 用户层.多段数字转矩指令04
    s16 s16TrqDigRef05;                // P9573 用户层.多段数字转矩指令05
    s16 s16TrqDigRef06;                // P9574 用户层.多段数字转矩指令06
    s16 s16TrqDigRef07;                // P9575 用户层.多段数字转矩指令07
    s16 s16TrqDigRef08;                // P9576 用户层.多段数字转矩指令08
    s16 s16TrqDigRef09;                // P9577 用户层.多段数字转矩指令09
    s16 s16TrqDigRef10;                // P9578 用户层.多段数字转矩指令10
    s16 s16TrqDigRef11;                // P9579 用户层.多段数字转矩指令11
    s16 s16TrqDigRef12;                // P9580 用户层.多段数字转矩指令12
    s16 s16TrqDigRef13;                // P9581 用户层.多段数字转矩指令13
    s16 s16TrqDigRef14;                // P9582 用户层.多段数字转矩指令14
    s16 s16TrqDigRef15;                // P9583 用户层.多段数字转矩指令15
    s16 s16TrqDigRef16;                // P9584 用户层.多段数字转矩指令16
    u16 _Resv9585;                     // P9585 
    u16 _Resv9586;                     // P9586 
    u16 uwErrorCode_603F;              // P9587 
    u16 uwControlword_6040;            // P9588 
    u16 uwStatusWord_6041;             // P9589 
    s16 swQuickStopOptionCode_605A;    // P9590 
    s16 swShutdownOptionCode_605B;     // P9591 
    s16 swDisableOperaOptionCode_605C; // P9592 
    s16 swHaltOptionCode_605D;         // P9593 
    s16 swFaultReactionCode_605E;      // P9594 
    s16 sbModesOpera_6060;             // P9595 
    s16 sbModesOperaDisp_6061;         // P9596 
    s32 slPosDemandValue_6062;         // P9597 
    s32 slPosActualInternalValue_6063; // P9599 
    s32 slUserPosActualValue_6064;     // P9601 
    u32 ulFollowErrorWindow_6065;      // P9603 
    u32 ulFollowErrorTimeOut_6066;     // P9605 
    u32 ulPositionWindow_6067;         // P9607 
    u16 uwPositionWindowTime_6068;     // P9609 
    u32 ulVelocityDemandValue_606B;    // P9610 
    u32 ulVelocityActualValue_606C;    // P9612 
    u16 uwVelocityWindow_606D;         // P9614 
    u16 uwVelocityWindowTime_606E;     // P9615 
    u16 uwVelocityThreshold_606F;      // P9616 
    u16 uwVelocityThresholdTime_6070;  // P9617 
    s16 swTargetTorque_6071;           // P9618 
    u16 uwMaxTorque_6072;              // P9619 
    u16 uwMaxCurrent_6073;             // P9620 
    s16 swTorqueDemand_6074;           // P9621 
    u32 ulMotorRatedCurrent_6075;      // P9622 
    u32 ulMotorRatedTorque_6076;       // P9624 
    s16 swTorqueActualValue_6077;      // P9626 
    s16 swCurrentActualValue_6078;     // P9627 
    u32 ulDCLinkCircuitVoltage_6079;   // P9628 
    s32 slTargetPosition_607A;         // P9630 
    s32 slHomeOffset_607C;             // P9632 
    s32 slSoftPositionLimit_607D_0;    // P9634 
    s32 slSoftPositionLimit_607D_1;    // P9636 
    u16 ubPolarity_607E;               // P9638 
    u32 ulMaxProfileVelocity_607F;     // P9639 
    u32 ulMaxMotorSpeed_6080;          // P9641 
    u32 ulProfileVelocity_6081;        // P9643 
    u32 ulProfileAcceleration_6083;    // P9645 
    u32 ulProfileDeceleration_6084;    // P9647 
    u32 ulQuickStopDeceleration_6085;  // P9649 
    s16 swMotionProfileType_6086;      // P9651 
    s16 swTargetSlope_6087;            // P9652 
    s16 swTorqueProfileType_6088;      // P9653 
    s16 sbHomingMethod_6098;           // P9654 
    u16 uwHomingSpeeds_6099_0;         // P9655 
    u16 uwHomingSpeeds_6099_1;         // P9656 
    u32 ulHomingAcceleration_609A;     // P9657 
    s32 slPostionOffset_60B0;          // P9659 
    s32 slVelocityOffset_60B1;         // P9661 
    s32 slTorqueOffset_60B2;           // P9663 
    u16 uwTouchProbeFunction_60B8;     // P9665 
    u16 uwTouchProbeStatus_60B9;       // P9666 
    s32 slTouchProbe1Pos1PosValue_60BA; // P9667 
    s32 slTouchProbe1Neg1PosValue_60BB; // P9669 
    s32 slTouchProbe2Pos1PosValue_60BC; // P9671 
    s32 slTouchProbe2Neg1PosValue_60BD; // P9673 
    u16 ubInterpTimePeriod_60C2_0;     // P9675 
    u16 ubInterpTimePeriod_60C2_1;     // P9676 
    u32 ulMaxProfileAcceleration_60C5; // P9677 
    u32 ulMaxProfileDeceleration_60C6; // P9679 
    s32 slFollowErrorActualValue_60F4; // P9681 
    s32 slPositionDemandValue_60FC;    // P9683 
    u32 ulDigitalInput_60FD;           // P9685 
    u16 uwDigitalOutput_60FE_0;        // P9687 
    u16 uwDigitalOutput_60FE_1;        // P9688 
    s32 slTargetVelocity_60FF;         // P9689 
    u32 ulSupportedDriveModes_6502;    // P9691 
    u16 _Resv9693;                     // P9693 
    u16 _Resv9694;                     // P9694 
    u16 _Resv9695;                     // P9695 
    u16 _Resv9696;                     // P9696 
    u16 _Resv9697;                     // P9697 
    u16 _Resv9698;                     // P9698 
    u16 _Resv9699;                     // P9699 
    u16 _Resv9700;                     // P9700 
    u16 _Resv9701;                     // P9701 
} axis_para_t;

// clang-format on

// 后续该生成工具时再去掉
#define aDeviceAttr sDeviceAttr
#define aAxisAttr   sAxisAttr

extern const para_attr_t sDeviceAttr[];
extern const para_attr_t sAxisAttr[];

extern device_para_t sDevicePara;
extern axis_para_t   sAxisPara[];

#define D          sDevicePara
#define P(eAxisNo) sAxisPara[eAxisNo]

#endif
