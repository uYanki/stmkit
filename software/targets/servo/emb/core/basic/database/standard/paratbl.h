#ifndef __PARA_TABLE_H__
#define __PARA_TABLE_H__

#include "common.h"
#include "paraattr.h"

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
 * @note typedef struct __packed  {} info_t;
 *
 * __packed 鐨勪綔鐢ㄦ槸鍙栨秷瀛楄妭瀵归綈銆
 *
 * @note M0/M0+/M1 涓嶆敮鎸2浣64浣嶇殑闈炲榻愯闂紙鐩存帴璁块棶浼氳Е鍙戠‖浠跺紓甯革級锛孧3/M4/M7 鍙互鐩存帴璁块棶闈炲榻愬湴鍧€銆
 *
 */

typedef __packed struct
{
    u32 u32DrvScheme;          // P0000 驱动器方案
    u16 _Resv2;                // P0002
    u16 _Resv3;                // P0003
    u32 u32McuSwBuildDate;     // P0004 软件构建日期
    u32 u32McuSwBuildTime;     // P0006 软件构建时间
    u16 _Resv8;                // P0008
    u16 u16CurSampType;        // P0009 电流采样类型
    u16 _Resv10;               // P0010
    u16 u16AxisNum;            // P0011 轴数量
    u16 u16LedNum;             // P0012 指示灯个数
    u16 u16KeyNum;             // P0013 按键个数
    u16 u16ExtDiNum;           // P0014 外部数字量输入个数
    u16 u16ExtDoNum;           // P0015 外部数字量输出个数
    u16 u16ExtHDiNum;          // P0016 外部高速数字量输入个数
    u16 u16ExtHDoNum;          // P0017 外部高速数字量输出个数
    u16 u16ExtAiNum;           // P0018 外部模拟量输入个数
    u16 u16ExtAoNum;           // P0019 外部模拟量输出个数
    u16 u16TsNum;              // P0020 温度采样个数
    u16 _Resv21;               // P0021
    u16 _Resv22;               // P0022
    u16 _Resv23;               // P0023
    u16 _Resv24;               // P0024
    u16 _Resv25;               // P0025
    u16 _Resv26;               // P0026
    u16 _Resv27;               // P0027
    u16 _Resv28;               // P0028
    u16 _Resv29;               // P0029
    u16 _Resv30;               // P0030
    u16 u16SysPwd;             // P0031 系统密码
    u16 u16SysAccess;          // P0032 当前系统权限
    u16 bSwRstCmd;             // P0033 软件复位
    u16 _Resv34;               // P0034
    u16 u16UmdcHwCoeff;        // P0035 主回路电压采样系数
    u16 u16UcdcHwCoeff;        // P0036 控制电电压采样系数
    u16 u16Uai0HwCoeff;        // P0037 模拟量输入AI0采样系数
    u16 u16Uai1HwCoeff;        // P0038 模拟量输入AI1采样系数
    u16 u16Uai2HwCoeff;        // P0039 模拟量输入AI2采样系数
    u16 u16InvtTempHwCoeff;    // P0040 逆变桥温度采样系数
    u16 _Resv41;               // P0041
    u16 u16UmdcZoom;           // P0042 主回路电压采样缩放系数
    s16 s16UmdcOffset;         // P0043 主回路电压采样偏置
    u16 u16UcdcZoom;           // P0044 控制电电压采样缩放系数
    s16 s16UcdcOffset;         // P0045 控制电电压采样偏置
    u16 _Resv46;               // P0046
    u16 u16Uai0Zoom;           // P0047 模拟量输入AI0采样缩放系数
    s16 s16Uai0Offset;         // P0048 模拟量输入AI0采样偏置
    u16 u16Uai0DeadZone;       // P0049 模拟量输入AI0输入死区
    u16 u16Uai1Zoom;           // P0050 模拟量输入AI1采样缩放系数
    s16 s16Uai1Offset;         // P0051 模拟量输入AI1采样偏置
    u16 u16Uai1DeadZone;       // P0052 模拟量输入AI1输入死区
    u16 u16Uai2Zoom;           // P0053 模拟量输入AI2采样缩放系数
    s16 s16Uai2Offset;         // P0054 模拟量输入AI2采样偏置
    u16 u16Uai2DeadZone;       // P0055 模拟量输入AI2输入死区
    u16 _Resv56;               // P0056
    u16 u16TempInvtZoom;       // P0057 逆变桥温度采样缩放系数
    s16 s16TempInvtOffset;     // P0058 逆变桥温度采样偏置
    u16 _Resv59;               // P0059
    u16 u16DrvCurRate;         // P0060 驱动器额定电流
    u16 _Resv61;               // P0061
    u16 u16UmdcErrOVSi;        // P0062 直流母线过压故障值
    u16 u16UmdcErrUVSi;        // P0063 直流母线欠压故障值
    u16 u16UmdcWrnUVSi;        // P0064 直流母线欠压警告值
    u16 u16UmdcRlyOnSi;        // P0065 直流母线缓起继电器吸合值
    u16 u16UmdcRgOnSi;         // P0066 直流母线再生电阻放电电压值
    u16 _Resv67;               // P0067
    u16 u16CarryFreq;          // P0068 载波频率
    u16 u16PosLoopFreq;        // P0069 位置环频率
    u16 u16SpdLoopFreq;        // P0070 速度环频率
    u16 u16CurLoopFreq;        // P0071 电流环频率
    u16 _Resv72;               // P0072
    u16 _Resv73;               // P0073
    u16 _Resv74;               // P0074
    u16 u16MbSlvId;            // P0075 Modbus-从站节点ID
    u32 u32MbBaudrate;         // P0076 Modbus-从站波特率
    u16 u16MbParity;           // P0078 Modbus-从站检验位
    u16 u16MbMstEndian;        // P0079 Modbus-主站大小端
    u16 u16MbDisconnTime;      // P0080 Modbus-通讯断开检测时间
    u16 u16MbResponseDelay;    // P0081 Modbus-命令响应延时
    u16 _Resv82;               // P0082
    u16 u16CopNodeId;          // P0083 CANopen-节点ID
    u16 u16CopBitrate;         // P0084 CANopen-比特率
    u16 u16PdoInhTime;         // P0085 CANopen-PDO禁止时间
    u16 u16CopState;           // P0086 CANopen-通信状态
    u16 _Resv87;               // P0087
    u16 u16EcatScanPrd;        // P0088 EtherCAT-通信状态
    u16 u16EcatState;          // P0089 EtherCAT-Port0错误统计
    u16 u16EcatPort0ErrCnt;    // P0090 EtherCAT-Port1错误统计
    u16 u16EcatPort1ErrCnt;    // P0091 EtherCAT-接收错误统计
    u16 u16EcatRxErrCnt;       // P0092 EtherCAT-处理单元错误统计
    u16 u16EcatPdiErrCnt;      // P0093
    u16 _Resv94;               // P0094
    u16 _Resv95;               // P0095
    u16 u16PanelDispPage;      // P0096 面板默认显示页面
    u16 u16PanelKeyVaule;      // P0097 面板按键键值
    u16 _Resv98;               // P0098
    u16 _Resv99;               // P0099
    u16 _Resv100;              // P0100
    u16 _Resv101;              // P0101
    u16 _Resv102;              // P0102
    u16 _Resv103;              // P0103
    u16 _Resv104;              // P0104
    u16 _Resv105;              // P0105
    u16 _Resv106;              // P0106
    u16 u16ScopeSampPrd;       // P0107 数据采样周期
    u16 u16ScopeSampPts;       // P0108 数据采样点数
    u16 u16ScopeSampSrc1;      // P0109 数据记录通道来源1 (数据源)
    u16 u16ScopeSampSrc2;      // P0110 数据记录通道来源2 (数据源)
    u16 u16ScopeSampSrc3;      // P0111 数据记录通道来源3 (数据源)
    u16 u16ScopeSampSrc4;      // P0112 数据记录通道来源4 (数据源)
    u16 u16ScopeSampAddr1;     // P0113 数据记录通道地址1
    u16 u16ScopeSampAddr2;     // P0114 数据记录通道地址2
    u16 u16ScopeSampAddr3;     // P0115 数据记录通道地址3
    u16 u16ScopeSampAddr4;     // P0116 数据记录通道地址4
    u16 u16ScopeTrigSrc1;      // P0117 数据触发通道来源1
    u16 u16ScopeTrigSrc2;      // P0118 数据触发通道来源2
    u16 u16ScopeTrigAddr1;     // P0119 数据触发通道地址1
    u16 u16ScopeTrigAddr2;     // P0120 数据触发通道地址2
    u64 u64ScopeTrigThold1;    // P0121 数据触发阈值1
    u64 u64ScopeTrigThold2;    // P0125 数据触发阈值2
    u16 u16ScopeTrigMode;      // P0129 数据触发模式
    u16 u16ScopeTrigCond1;     // P0130 数据触发通道条件1 (触发源)
    u16 u16ScopeTrigCond2;     // P0131 数据触发通道条件2 (触发源)
    u16 u16ScopeTrigPreset;    // P0132 数据预触发百分比
    u16 u16ScopeSampEndIdx;    // P0133 数据记录结束点索引
    u16 u16ScopeSampSts;       // P0134 数据记录状态
    u16 u16ScopeUploadSts;     // P0135 数据上传状态
    u16 _Resv136;              // P0136
    s16 s16DbgBuf1;            // P0137 调试数据缓冲
    s16 s16DbgBuf2;            // P0138 调试数据缓冲
    s16 s16DbgBuf3;            // P0139 调试数据缓冲
    s16 s16DbgBuf4;            // P0140 调试数据缓冲
    u16 u16DbgBuf1;            // P0141 调试数据缓冲
    u16 u16DbgBuf2;            // P0142 调试数据缓冲
    u16 u16DbgBuf3;            // P0143 调试数据缓冲
    u16 u16DbgBuf4;            // P0144 调试数据缓冲
    s32 s32DbgBuf1;            // P0145 调试数据缓冲
    s32 s32DbgBuf2;            // P0147 调试数据缓冲
    s32 s32DbgBuf3;            // P0149 调试数据缓冲
    s32 s32DbgBuf4;            // P0151 调试数据缓冲
    u32 u32DbgBuf1;            // P0153 调试数据缓冲
    u32 u32DbgBuf2;            // P0155 调试数据缓冲
    u32 u32DbgBuf3;            // P0157 调试数据缓冲
    u32 u32DbgBuf4;            // P0159 调试数据缓冲
    s64 s64DbgBuf1;            // P0161 调试数据缓冲
    s64 s64DbgBuf2;            // P0165 调试数据缓冲
    s64 s64DbgBuf3;            // P0169 调试数据缓冲
    s64 s64DbgBuf4;            // P0173 调试数据缓冲
    u64 u64DbgBuf1;            // P0177 调试数据缓冲
    u64 u64DbgBuf2;            // P0181 调试数据缓冲
    u64 u64DbgBuf3;            // P0185 调试数据缓冲
    u64 u64DbgBuf4;            // P0189 调试数据缓冲
    u16 _Resv193;              // P0193
    u16 u16TunerBuff01;        // P0194
    u16 u16TunerBuff02;        // P0195
    u16 u16TunerBuff03;        // P0196
    u16 u16TunerBuff04;        // P0197
    u16 u16TunerBuff05;        // P0198
    u16 u16TunerBuff06;        // P0199
    u16 u16TunerBuff07;        // P0200
    u16 u16TunerBuff08;        // P0201
    u16 u16TunerBuff09;        // P0202
    u16 u16TunerBuff10;        // P0203
    u16 u16TunerBuff11;        // P0204
    u16 u16TunerBuff12;        // P0205
    u16 u16TunerBuff13;        // P0206
    u16 u16TunerBuff14;        // P0207
    u16 u16TunerBuff15;        // P0208
    u16 u16TunerBuff16;        // P0209
    u16 u16TunerBuff17;        // P0210
    u16 u16TunerBuff18;        // P0211
    u16 u16TunerBuff19;        // P0212
    u16 u16TunerBuff20;        // P0213
    u16 u16TunerBuff21;        // P0214
    u16 u16TunerBuff22;        // P0215
    u16 u16TunerBuff23;        // P0216
    u16 u16TunerBuff24;        // P0217
    u16 u16TunerBuff25;        // P0218
    u16 _Resv219;              // P0219
    u16 _Resv220;              // P0220
    u16 _Resv221;              // P0221
    u16 u16AlmCodeSeq;         // P0222 当前所有报警代码轮巡
    u16 u16LastAlmCode;        // P0223 最新报警代码
    u16 u16HisAlmCode01;       // P0224 历史报警代码01
    u16 u16HisAlmCode02;       // P0225 历史报警代码02
    u16 u16HisAlmCode03;       // P0226 历史报警代码03
    u16 u16HisAlmCode04;       // P0227 历史报警代码04
    u16 u16HisAlmCode05;       // P0228 历史报警代码05
    u16 u16HisAlmCode06;       // P0229 历史报警代码06
    u16 u16HisAlmCode07;       // P0230 历史报警代码07
    u16 u16HisAlmCode08;       // P0231 历史报警代码08
    u16 u16HisAlmCode09;       // P0232 历史报警代码09
    u16 u16HisAlmCode10;       // P0233 历史报警代码10
    u16 u16HisAlmCode11;       // P0234 历史报警代码11
    u16 u16HisAlmCode12;       // P0235 历史报警代码12
    u16 u16HisAlmCode13;       // P0236 历史报警代码13
    u16 u16HisAlmCode14;       // P0237 历史报警代码14
    u16 u16HisAlmCode15;       // P0238 历史报警代码15
    u32 u32HisAlmTime01;       // P0239 历史报警时间戳01
    u32 u32HisAlmTime02;       // P0241 历史报警时间戳02
    u32 u32HisAlmTime03;       // P0243 历史报警时间戳03
    u32 u32HisAlmTime04;       // P0245 历史报警时间戳04
    u32 u32HisAlmTime05;       // P0247 历史报警时间戳05
    u32 u32HisAlmTime06;       // P0249 历史报警时间戳06
    u32 u32HisAlmTime07;       // P0251 历史报警时间戳07
    u32 u32HisAlmTime08;       // P0253 历史报警时间戳08
    u32 u32HisAlmTime09;       // P0255 历史报警时间戳09
    u32 u32HisAlmTime10;       // P0257 历史报警时间戳10
    u32 u32HisAlmTime11;       // P0259 历史报警时间戳11
    u32 u32HisAlmTime12;       // P0261 历史报警时间戳12
    u32 u32HisAlmTime13;       // P0263 历史报警时间戳13
    u32 u32HisAlmTime14;       // P0265 历史报警时间戳14
    u32 u32HisAlmTime15;       // P0267 历史报警时间戳15
    u16 _Resv269;              // P0269
    u16 _Resv270;              // P0270
    u16 _Resv271;              // P0271
    u16 _Resv272;              // P0272
    u16 _Resv273;              // P0273
    u16 _Resv274;              // P0274
    u16 _Resv275;              // P0275
    u16 _Resv276;              // P0276
    u16 _Resv277;              // P0277
    u16 _Resv278;              // P0278
    u16 _Resv279;              // P0279
    u16 _Resv280;              // P0280
    u16 _Resv281;              // P0281
    u16 _Resv282;              // P0282
    u16 _Resv283;              // P0283
    u16 _Resv284;              // P0284
    u16 eSysState;             // P0285 系统状态
    u32 u32SysRunTime;         // P0286 运行时间
    u16 _Resv288;              // P0288
    u16 _Resv289;              // P0289
    u16 u16DiState;            // P0290 DI输入端子电平状态
    u16 u16DoState;            // P0291 DO输出端子电平状态
    u16 _Resv292;              // P0292
    u16 u16UmdcSi;             // P0293 主回路母线电压物理值
    u16 u16UcdcSi;             // P0294 控制母线电压物理值
    s16 s16UaiSi0;             // P0295 AI0输入电压物理值
    s16 s16UaiSi1;             // P0296 AI1输入电压物理值
    s16 s16UaiSi2;             // P0297 AI2输入电压物理值
    u16 u16UaoSi0;             // P0298 AO0输出电压物理值
    u16 u16UaoSi1;             // P0299 AO1输出电压物理值
    s16 s16TempInvtSi;         // P0300 逆变桥温度物理值
    s16 s16TempRectSi;         // P0301 整流桥温度物理值
    s16 s16TempCtrlBrdSi;      // P0302 控制板温度物理值
    u16 _Resv303;              // P0303
    u16 _Resv304;              // P0304
    u16 u16UmdcPu;             // P0305 主回路母线电压数字量
    u16 u16UcdcPu;             // P0306 控制母线电压数字量
    s16 s16UaiPu0;             // P0307 AI0输入电压数字量
    s16 s16UaiPu1;             // P0308 AI1输入电压数字量
    s16 s16UaiPu2;             // P0309 AI2输入电压数字量
    s16 s16TempInvtPu;         // P0310 逆变桥温度数字量
    s16 s16TempRectPu;         // P0311 整流桥温度数字量
    s16 s16TempCtrlBrdtPu;     // P0312 控制板温度数字量
    u16 _Resv313;              // P0313
    u16 _Resv314;              // P0314
    u16 u16ProbeStatus;        // P0315 探针状态
    s64 s64ProbePosEdgePos00;  // P0316 探针1上升沿锁存位置
    s64 s64ProbeNegEdgePos00;  // P0320 探针1下降沿锁存位置
    s64 s64ProbePosEdgePos01;  // P0324 探针2上升沿锁存位置
    s64 s64ProbeNegEdgePos01;  // P0328 探针2下降沿锁存位置
    s64 s64ProbePosEdgePos02;  // P0332 探针3上升沿锁存位置
    s64 s64ProbeNegEdgePos02;  // P0336 探针3下降沿锁存位置
    s64 s64ProbePosEdgePos03;  // P0340 探针4上升沿锁存位置
    s64 s64ProbeNegEdgePos03;  // P0344 探针4下降沿锁存位置
    u16 _Resv348;              // P0348
    u16 _Resv349;              // P0349
    u16 _Resv350;              // P0350
    u16 _Resv351;              // P0351
    u16 u16HrTimerSel;         // P0352 程序段运行计时选择
    u16 u16CycleScanTime;      // P0353 主循环程序Scan运行时间
    u16 u16IsrScanATime;       // P0354 中断程序ScanA运行时间
    u16 u16IsrScanBTime;       // P0355 中断程序ScanB运行时间
    u16 u16IsrPosLoopTime;     // P0356 中断程序位置环运行时间
    u16 u16IsrSpdLoopTime;     // P0357 中断程序速度环运行时间
    u16 u16IsrCurLoopTime;     // P0358 中断程序电流环运行时间
    u16 u16CustomTime0;        // P0359 缺省程序运行时间0
    u16 u16CustomTime1;        // P0360 缺省程序运行时间1
    u16 _Resv361;              // P0361
    u16 _Resv362;              // P0362
    u16 _Resv363;              // P0363
    u16 _Resv364;              // P0364
    u16 _Resv365;              // P0365
    u16 _Resv366;              // P0366
    u16 _Resv367;              // P0367
    u16 _Resv368;              // P0368
    u16 _Resv369;              // P0369
    u16 _Resv370;              // P0370
    u16 _Resv371;              // P0371
    u16 _Resv372;              // P0372
    u16 _Resv373;              // P0373
    u16 _Resv374;              // P0374
    u16 _Resv375;              // P0375
    u16 _Resv376;              // P0376
    u16 _Resv377;              // P0377
    u16 _Resv378;              // P0378
    u16 _Resv379;              // P0379
    u16 _Resv380;              // P0380
    u16 _Resv381;              // P0381
    u16 _Resv382;              // P0382
    u16 _Resv383;              // P0383
    u16 _Resv384;              // P0384
}
device_para_t;

typedef __packed struct
{
    u16 u16AxisNo;                       // P0400 轴号
    u16 _Resv401;                        // P0401
    u16 u16MotEncSel;                    // P0402 电机选择
    u16 u16MotPolePairs;                 // P0403 电机极对数
    u32 u32MotInertia;                   // P0404 电机转动惯量
    u16 u16MotStatorRes;                 // P0406 电机定子电阻
    u16 u16MotStatorLd;                  // P0407 电机定子D轴电感
    u16 u16MotStatorLq;                  // P0408 电机定子Q轴电感
    u16 u16MotEmfCoeff;                  // P0409 电机反电动势常数
    u16 u16MotTrqCoeff;                  // P0410 电机转矩系数
    u16 u16MotTm;                        // P0411 电机机械时间常数
    u16 u16MotVoltInRate;                // P0412 电机额定输入电压
    u16 u16MotPowerRate;                 // P0413 电机额定功率
    u16 u16MotCurRate;                   // P0414 电机额定电流
    u16 u16MotCurMax;                    // P0415 电机最大电流
    u16 u16MotTrqRate;                   // P0416 电机额定转矩
    u16 u16MotTrqMax;                    // P0417 电机最大转矩
    u16 u16MotSpdRate;                   // P0418 电机额定转速
    u16 u16MotSpdMax;                    // P0419 电机最大转速
    u16 u16MotAccMax;                    // P0420 电机最大加速度
    u16 u16EncSN;                        // P0421 编码器序列号
    u16 u16EncMethod;                    // P0422 编码器原理
    u16 u16EncType;                      // P0423 编码器类型
    u32 u32EncRes;                       // P0424 编码器分辨率
    u32 u32EncPosOffset;                 // P0426 电角度偏置
    u32 u32EncPosInit;                   // P0428 编码器初始位置
    u32 u32EncPos;                       // P0430 编码器单圈位置
    s32 s32EncTurns;                     // P0432 编码器圈数
    s64 s64EncMultPos;                   // P0434 编码器多圈位置
    u16 u16EncHallState;                 // P0438 编码器霍尔真值状态
    u16 _Resv439;                        // P0439
    u16 u16AbsEncWorkMode;               // P0440 轴配置.绝对值编码器工作模式
    u16 _Resv441;                        // P0441
    u16 _Resv442;                        // P0442
    u16 u16PwmFreq;                      // P0443 PWM载波频率
    u16 u16PwmDutyMax;                   // P0444 PWM最大占空比
    u16 u16PwmDeadband;                  // P0445 PWM死区时间
    u16 _Resv446;                        // P0446
    u16 _Resv447;                        // P0447
    u16 _Resv448;                        // P0448
    u16 u16PosLoopKp;                    // P0449 轴配置.位置环增益系数
    u16 u16PosLoopKi;                    // P0450 轴配置.位置环积分系数
    u16 u16SpdLoopKp;                    // P0451 轴配置.速度环增益系数
    u16 u16SpdLoopKi;                    // P0452 轴配置.速度环积分系数
    u16 u16CurLoopIqKp;                  // P0453 轴配置.电流环转矩增益系数
    u16 u16CurLoopIqKi;                  // P0454 轴配置.电流环转矩积分系数
    u16 u16CurLoopIdKp;                  // P0455 轴配置.电流环磁链增益系数
    u16 u16CurLoopIdKi;                  // P0456 轴配置.电流环磁链积分系数
    u16 _Resv457;                        // P0457
    u16 u16SpdRefFltrTc;                 // P0458 轴配置.速度指令滤波常数
    u16 u16SpdFbFltrTc;                  // P0459 轴配置.速度反馈滤波常数
    u16 u16IdRefFltrTc;                  // P0460 轴配置.转矩指令滤波常数
    u16 u16IdFbFltrTc;                   // P0461 轴配置.转矩反馈滤波常数
    u16 u16IqRefFltrTc;                  // P0462 轴配置.磁链指令滤波常数
    u16 u16IqFbFltrTc;                   // P0463 轴配置.磁链反馈滤波常数
    u16 _Resv464;                        // P0464
    u16 u16CurSampDir;                   // P0465 轴配置.电流采样方向
    u16 u16IphHwCoeff;                   // P0466 轴配置.电流硬件采样系数
    u16 u16IphZoom;                      // P0467 轴配置.电流缩放系数
    s16 s16IaOffset;                     // P0468 轴配置.U相电流偏置标幺值
    s16 s16IbOffset;                     // P0469 轴配置.V相电流偏置标幺值
    s16 s16IcOffset;                     // P0470 轴配置.W相电流偏置标幺值
    u16 _Resv471;                        // P0471
    u16 u16SpdMaxGain;                   // P0472 轴配置.最大速度增益
    u16 _Resv473;                        // P0473
    u16 u16CurRateDigMot;                // P0474 轴配置.额定电流数字量
    u16 _Resv475;                        // P0475
    u16 _Resv476;                        // P0476
    u16 u16OverCurrTh;                   // P0477 轴配置.软件过流阈值
    u16 u16OverSpdTh;                    // P0478 轴配置.过速阈值
    u16 u16OverTempTh;                   // P0479 轴配置.过热阈值
    u16 u16OverLoadCoeff;                // P0480 轴配置.过载倍数
    u16 _Resv481;                        // P0481
    u16 _Resv482;                        // P0482
    u16 _Resv483;                        // P0483
    u16 _Resv484;                        // P0484
    u16 _Resv485;                        // P0485
    u16 _Resv486;                        // P0486
    u16 _Resv487;                        // P0487
    u16 _Resv488;                        // P0488
    u16 _Resv489;                        // P0489
    u16 _Resv490;                        // P0490
    u16 _Resv491;                        // P0491
    u16 _Resv492;                        // P0492
    u16 _Resv493;                        // P0493
    u16 _Resv494;                        // P0494
    u16 _Resv495;                        // P0495
    u16 _Resv496;                        // P0496
    u16 _Resv497;                        // P0497
    u16 _Resv498;                        // P0498
    u16 _Resv499;                        // P0499
    u16 _Resv500;                        // P0500
    u16 _Resv501;                        // P0501
    u16 _Resv502;                        // P0502
    u16 _Resv503;                        // P0503
    u16 _Resv504;                        // P0504
    u16 _Resv505;                        // P0505
    u16 _Resv506;                        // P0506
    u16 _Resv507;                        // P0507
    u16 _Resv508;                        // P0508
    u16 _Resv509;                        // P0509
    u16 _Resv510;                        // P0510
    u16 _Resv511;                        // P0511
    u16 eCtrlMethod;                     // P0512 用户层.控制方法
    u16 eAppSel;                         // P0513 用户层.应用选择
    u16 eCtrlMode;                       // P0514 用户层.控制模式
    u16 eCtrlCmdSrc;                     // P0515 用户层.控制命令来源
    u16 eDiSrc;                          // P0516 用户层.外部或虚拟DI选择
    u16 eDoSrc;                          // P0517 用户层.外部或虚拟DO选择
    u32 u32CommCmd;                      // P0518 用户层.通信命令字
    u32 u32DiCmd;                        // P0520 用户层.DI命令字
    u16 u16PwrOnConf;                    // P0522 用户层.上电配置
    u16 _Resv523;                        // P0523
    u16 _Resv524;                        // P0524
    u16 _Resv525;                        // P0525
    u16 _Resv526;                        // P0526
    u16 _Resv527;                        // P0527
    u16 _Resv528;                        // P0528
    u16 _Resv529;                        // P0529
    u16 _Resv530;                        // P0530
    u16 _Resv531;                        // P0531
    u16 _Resv532;                        // P0532
    u16 _Resv533;                        // P0533
    u16 _Resv534;                        // P0534
    u16 _Resv535;                        // P0535
    u16 _Resv536;                        // P0536
    u16 _Resv537;                        // P0537
    u16 _Resv538;                        // P0538
    u16 _Resv539;                        // P0539
    u16 _Resv540;                        // P0540
    u16 _Resv541;                        // P0541
    u16 _Resv542;                        // P0542
    u16 _Resv543;                        // P0543
    u16 _Resv544;                        // P0544
    u16 _Resv545;                        // P0545
    u16 _Resv546;                        // P0546
    u16 _Resv547;                        // P0547
    u16 u16OpenLoopEn;                   // P0548 应用层.开环测试使能
    u16 u16OpenPeriod;                   // P0549 应用层.开环测试.运行周期
    s16 u16OpenElecAngLock;              // P0550 应用层.开环测试.电角度锁定位置
    s16 s16OpenElecAngInc;               // P0551 应用层.开环测试.电角度自增量
    s16 s16OpenUqRef;                    // P0552 应用层.开环测试.Q轴指令
    s16 s16OpenUdRef;                    // P0553 应用层.开环测试.D轴指令
    u16 _Resv554;                        // P0554
    u16 u16MotEncIdentEn;                // P0555 应用层.电机编码器辨识使能
    u16 u16MotEncIdentDirMatched;        // P0556 应用层.电机编码器辨识.方向匹配状态
    u16 u16MotEncIdentPolePairs;         // P0557 应用层.电机编码器辨识.电机极对数
    u32 u32MotEncIdentOffset;            // P0558 应用层.电机编码器辨识.编码器安装偏置角
    u32 u32MotEncIdentRes;               // P0560 应用层.电机编码器辨识.编码器分辨率
    u16 u16MotEncIdentState;             // P0562 应用层.电机编码器辨识.运行状态
    u16 u16MotEncIdentErr;               // P0563 应用层.电机编码器辨识.错误类型
    u16 _Resv564;                        // P0564
    u16 u16MotParaIdentEn;               // P0565 应用层.电机参数辨识使能
    u16 u16MotParaIdentRs;               // P0566 应用层.电机参数辨识.电机相电阻
    u16 u16MotParaIdentLd;               // P0567 应用层.电机参数辨识.电机D轴电感
    u16 u16MotParaIdentLq;               // P0568 应用层.电机参数辨识.电机Q轴电感
    u16 u16MotParaIdentFluxLk;           // P0569 应用层.电机参数辨识.电机磁链
    u16 _Resv570;                        // P0570
    u16 u16MainDcCapEn;                  // P0571 应用层.主回路母线电容辨识使能
    u32 u32MainDcCapValue;               // P0572 应用层.主回路母线电容辨识.电容容量
    u16 _Resv574;                        // P0574
    u16 _Resv575;                        // P0575
    u16 eLoopRspModeSel;                 // P0576 应用层.响应测试.环路选择
    s64 s64LoopRspStep;                  // P0577 应用层.响应测试.环路阶跃值
    u16 eLoopRspState;                   // P0581 应用层.响应测试.运行状态
    u16 _Resv582;                        // P0582
    u16 _Resv583;                        // P0583
    u16 _Resv584;                        // P0584
    u16 _Resv585;                        // P0585
    u16 _Resv586;                        // P0586
    u16 _Resv587;                        // P0587
    u16 _Resv588;                        // P0588
    u16 _Resv589;                        // P0589
    u16 _Resv590;                        // P0590
    u16 _Resv591;                        // P0591
    u16 _Resv592;                        // P0592
    u16 u16EncCmd;                       // P0593 编码器指令
    u16 u16EncErrCode;                   // P0594 编码器错误代码
    u16 u16EncComErrSum;                 // P0595 编码器通信错误次数
    u16 _Resv596;                        // P0596
    u16 eAxisFSM;                        // P0597 轴状态机
    u16 bPwmSwSts;                       // P0598 PWM状态
    u16 _Resv599;                        // P0599
    s64 s64UserPosRef;                   // P0600 用户层.用户位置指令
    s64 s64UserPosFb;                    // P0604 用户层.用户位置反馈
    s32 s32UserPosErr;                   // P0608 用户层.用户速度误差
    s32 s32UserSpdRef;                   // P0610 用户层.用户速度指令
    s32 s32UserSpdFb;                    // P0612 用户层.用户速度反馈
    s16 s16UserTrqRef;                   // P0614 用户层.用户转矩指令千分比
    s16 s16UserTrqFb;                    // P0615 用户层.用户转矩反馈千分比
    u16 _Resv616;                        // P0616
    s16 s16IaFbSi;                       // P0617 A相反馈电流物理值
    s16 s16IbFbSi;                       // P0618 B相反馈电流物理值
    s16 s16IcFbSi;                       // P0619 C相反馈电流物理值
    u16 _Resv620;                        // P0620
    u16 _Resv621;                        // P0621
    u16 _Resv622;                        // P0622
    u16 _Resv623;                        // P0623
    u16 eLogicCtrlMethod;                // P0624 逻辑层.控制方式
    u16 eLogicCtrlMode;                  // P0625 逻辑层.控制模式
    u16 _Resv626;                        // P0626
    u16 bLogicDrvEnCmd;                  // P0627 逻辑层.伺服使能
    u16 bLogicJogFwdCmd;                 // P0628 逻辑层.正向点动
    u16 bLogicJogRevCmd;                 // P0629 逻辑层.反向点动
    u16 bLogicStopCmd;                   // P0630 逻辑层.停机指令
    u16 bLogicHomingCmd;                 // P0631 逻辑层.回原使能
    u16 bLogicPosRevokeCmd;              // P0632 逻辑层.位置指令中断
    u16 bLogicMultMotionEn;              // P0633 逻辑层.多段启动使能
    u16 bLogicPosLimFwd;                 // P0634 逻辑层.正向限位使能
    u16 bLogicPosLimRev;                 // P0635 逻辑层.反向限位使能
    u16 bLogicAlmRst;                    // P0636 逻辑层.报警复位
    u16 bLogicEncTurnClr;                // P0637 逻辑层.多圈复位
    u16 bLogicHomeSig;                   // P0638 逻辑层.原点信号
    u16 bLogicRotDirSel;                 // P0639 逻辑层.旋转方向
    u16 _Resv640;                        // P0640
    s64 s64LogicPosRef;                  // P0641 逻辑层.位置指令
    s64 s64LogicPosRefGear;              // P0645 逻辑层.位置指令(齿轮比缩放后)
    s64 s64LogicPosDigLimFwdGear;        // P0649 逻辑层.正向数字限位(齿轮比缩放后)
    s64 s64LogicPosDigLimRevGear;        // P0653 逻辑层.反向数字限位(齿轮比缩放后)
    u16 eLogicPosPlanMode;               // P0657 逻辑层.位置规划模式
    u16 _Resv658;                        // P0658
    s32 s32LogicSpdRef;                  // P0659 逻辑层.速度指令
    u16 u16LogicSpdAccTime;              // P0661 逻辑层.加速度时间
    u16 u16LogicSpdDecTime;              // P0662 逻辑层.减速度时间
    u16 eLogicSpdPlanMode;               // P0663 逻辑层.速度规划模式
    s32 s32LogicSpdLimFwd;               // P0664 逻辑层.正向速度限制
    s32 s32LogicSpdLimRev;               // P0666 逻辑层.反向速度限制
    u16 _Resv668;                        // P0668
    s16 s16LogicFluxRef;                 // P0669 逻辑层.磁通指令
    s16 s16LogicTrqRef;                  // P0670 逻辑层.转矩指令
    s16 s16LogicTrqLimFwd;               // P0671 逻辑层.正向转矩限制
    s16 s16LogicTrqLimRev;               // P0672 逻辑层.反向转矩限制
    u16 _Resv673;                        // P0673
    u16 _Resv674;                        // P0674
    s64 s64PlanPosRef;                   // P0675 规划层.位置指令
    s32 s32PlanSpdRef;                   // P0679 规划层.速度指令
    s16 s16PlanIqRef;                    // P0681 规划层.转矩指令
    s16 s16PlanIdRef;                    // P0682 规划层.磁通指令
    s32 s32PosPlanSpdRef;                // P0683 规划层.位置规划速度指令
    u16 _Resv685;                        // P0685
    u16 _Resv686;                        // P0686
    u16 _Resv687;                        // P0687
    s32 s32DrvPosErr;                    // P0688 驱动层.位置误差
    s32 s32DrvPosPropGain;               // P0690 驱动层.位置环PI比例增益
    s32 s32DrvPosInteGain;               // P0692 驱动层.位置环PI积分增益
    u16 _Resv694;                        // P0694
    s32 s32DrvSpdErr;                    // P0695 驱动层.速度偏差
    s32 s32DrvSpdPropGain;               // P0697 驱动层.速度环PI比例增益
    s32 s32DrvSpdInteGain;               // P0699 驱动层.速度环PI积分增益
    s32 s32SpdLoopProp;                  // P0701 驱动层.速度环PI比例项
    s32 s32SpdLoopInte;                  // P0703 驱动层.速度环PI积分项
    s32 s32SpdLoopOut;                   // P0705 驱动层.速度环PI输出
    u16 _Resv707;                        // P0707
    s16 s16DrvIqErr;                     // P0708 驱动层.转矩误差数字量
    s16 s16DrvIqPropGain;                // P0709 驱动层.电流环Q轴PI比例增益
    s16 s16DrvIqInteGain;                // P0710 驱动层.电流环Q轴PI积分增益
    s32 s32CurLoopIqProp;                // P0711 驱动层.电流环Q轴PI比例项
    s32 s32CurLoopIqInte;                // P0713 驱动层.电流环Q轴PI积分项
    s16 s16CurLoopIqOut;                 // P0715 驱动层.电流环Q轴PI输出
    s16 _Resv716;                        // P0716
    s16 s16DrvIdErr;                     // P0717 驱动层.磁通误差数字量
    s16 s16DrvIdPropGain;                // P0718 驱动层.电流环D轴PI比例增益
    s16 s16DrvIdInteGain;                // P0719 驱动层.电流环D轴PI积分增益
    s32 s32CurLoopIdProp;                // P0720 驱动层.电流环D轴PI比例项
    s32 s32CurLoopIdInte;                // P0722 驱动层.电流环D轴PI积分项
    s16 s16CurLoopIdOut;                 // P0724 驱动层.电流环D轴PI输出
    u16 _Resv725;                        // P0725
    s16 s16IaZeroPu;                     // P0726 驱动层.U相电流零漂标幺值
    s16 s16IbZeroPu;                     // P0727 驱动层.V相电流零漂标幺值
    s16 s16IcZeroPu;                     // P0728 驱动层.W相电流零漂标幺值
    s16 s16IaFbPu;                       // P0729 驱动层.U相电流反馈标幺值
    s16 s16IbFbPu;                       // P0730 驱动层.V相电流反馈标幺值
    s16 s16IcFbPu;                       // P0731 驱动层.W相电流反馈标幺值
    s16 s16IalphaFb;                     // P0732 驱动层.Alpha轴反馈
    s16 s16IbetaFb;                      // P0733 驱动层.Beta轴反馈
    s16 s16IqFb;                         // P0734 驱动层.Q轴反馈(滤波前)
    s16 s16IdFb;                         // P0735 驱动层.D轴反馈(滤波前)
    u16 u16ElecAngFb;                    // P0736 驱动层.电角度反馈
    u16 _Resv737;                        // P0737
    u16 u16ElecAngRef;                   // P0738 驱动层.电角度指令
    s16 s16IdRef;                        // P0739 驱动层.D轴电压输出(限幅后)
    s16 s16IqRef;                        // P0740 驱动层.Q轴电压输出(限幅后)
    s16 s16IalphaRef;                    // P0741 驱动层.Alpha轴电压输出
    s16 s16IbetaRef;                     // P0742 驱动层.Beta轴电压输出
    u16 eSvpwmSector;                    // P0743 驱动层.SVPWM矢量扇区
    u16 u16PwmaComp;                     // P0744 驱动层.A相PWM比较值
    u16 u16PwmbComp;                     // P0745 驱动层.B相PWM比较值
    u16 u16PwmcComp;                     // P0746 驱动层.C相PWM比较值
    u16 _Resv747;                        // P0747
    s32 s32DrvSpdRef;                    // P0748 驱动层.速度指令(限幅后)
    s32 s32DrvSpdFb;                     // P0750 驱动层.速度反馈(滤波后)
    s64 s64DrvPosRef;                    // P0752 驱动层.位置指令
    s64 s64DrvPosFb;                     // P0756 驱动层.位置反馈
    s16 s16DrvIqFb;                      // P0760 驱动层.Q轴反馈(滤波后)
    s16 s16DrvIdFb;                      // P0761 驱动层.D轴反馈(滤波后)
    u16 _Resv762;                        // P0762
    u16 _Resv763;                        // P0763
    u16 _Resv764;                        // P0764
    u16 _Resv765;                        // P0765
    u16 _Resv766;                        // P0766
    u16 _Resv767;                        // P0767
    u16 _Resv768;                        // P0768
    u16 _Resv769;                        // P0769
    u16 eStopMode;                       // P0770 用户层.停机模式
    u16 eStopPlanMode;                   // P0771 用户层.停机规划模式
    s32 s32StopPosRef;                   // P0772
    u16 _Resv774;                        // P0774
    u16 _Resv775;                        // P0775
    u16 _Resv776;                        // P0776
    u16 ePosRefSrc;                      // P0777 用户层.位置指令来源
    s64 s64PosDigRef;                    // P0778 用户层.数字位置指令
    u16 u16PosPlanSpdMax;                // P0782 用户层.位置规划速度上限
    u16 _Resv783;                        // P0783
    u16 ePosDigRefType;                  // P0784
    u16 ePosRefSet;                      // P0785
    u16 u16PosMulRefSel;                 // P0786
    u16 _Resv787;                        // P0787
    u16 _Resv788;                        // P0788
    u16 _Resv789;                        // P0789
    u16 _Resv790;                        // P0790
    u16 ePosPlanMode;                    // P0791 用户层.位置规划模式
    u16 ePosLimSrc;                      // P0792 用户层.位置指令来源
    s64 s64PosLimFwd;                    // P0793 用户层.数字位置指令
    s64 s64PosLimRev;                    // P0797 用户层.位置规划模式
    u16 ePosLimSts;                      // P0801 位置限制状态
    u16 _Resv802;                        // P0802
    u32 u32ElecGearNum;                  // P0803 用户层.电子齿轮比分子
    u32 u32ElecGearDeno;                 // P0805 用户层.电子齿轮比分母
    u16 _Resv807;                        // P0807
    u16 u16EncFreqDivDir;                // P0808 用户层.编码器分频输出脉冲方向
    u16 u16EncFreqDivNum;                // P0809 用户层.编码器分频输出分子
    u16 u16EncFreqDivDeno;               // P0810 用户层.编码器分频输出分母
    u16 _Resv811;                        // P0811
    s64 s64PosDigRef01;                  // P0812 用户层.多段数字位置指令01
    s64 s64PosDigRef02;                  // P0816 用户层.多段数字位置指令02
    s64 s64PosDigRef03;                  // P0820 用户层.多段数字位置指令03
    s64 s64PosDigRef04;                  // P0824 用户层.多段数字位置指令04
    s64 s64PosDigRef05;                  // P0828 用户层.多段数字位置指令05
    s64 s64PosDigRef06;                  // P0832 用户层.多段数字位置指令06
    s64 s64PosDigRef07;                  // P0836 用户层.多段数字位置指令07
    s64 s64PosDigRef08;                  // P0840 用户层.多段数字位置指令08
    s64 s64PosDigRef09;                  // P0844 用户层.多段数字位置指令09
    s64 s64PosDigRef10;                  // P0848 用户层.多段数字位置指令10
    s64 s64PosDigRef11;                  // P0852 用户层.多段数字位置指令11
    s64 s64PosDigRef12;                  // P0856 用户层.多段数字位置指令12
    s64 s64PosDigRef13;                  // P0860 用户层.多段数字位置指令13
    s64 s64PosDigRef14;                  // P0864 用户层.多段数字位置指令14
    s64 s64PosDigRef15;                  // P0868 用户层.多段数字位置指令15
    s64 s64PosDigRef16;                  // P0872 用户层.多段数字位置指令16
    u16 _Resv876;                        // P0876
    u16 _Resv877;                        // P0877
    u16 _Resv878;                        // P0878
    u16 _Resv879;                        // P0879
    u16 _Resv880;                        // P0880
    u16 _Resv881;                        // P0881
    u16 _Resv882;                        // P0882
    u16 _Resv883;                        // P0883
    u16 _Resv884;                        // P0884
    u16 _Resv885;                        // P0885
    u16 _Resv886;                        // P0886
    u16 _Resv887;                        // P0887
    u16 _Resv888;                        // P0888
    u16 _Resv889;                        // P0889
    u16 _Resv890;                        // P0890
    u16 _Resv891;                        // P0891
    u16 _Resv892;                        // P0892
    u16 _Resv893;                        // P0893
    u16 _Resv894;                        // P0894
    u16 _Resv895;                        // P0895
    u16 _Resv896;                        // P0896
    u16 _Resv897;                        // P0897
    u16 _Resv898;                        // P0898
    u16 _Resv899;                        // P0899
    u16 _Resv900;                        // P0900
    u16 _Resv901;                        // P0901
    u16 _Resv902;                        // P0902
    u16 _Resv903;                        // P0903
    u16 eSpdRefSrc;                      // P0904 用户层.速度指令来源
    s16 s16SpdDigRef;                    // P0905 用户层.数字速度指令
    u16 _Resv906;                        // P0906
    u16 eSpdPlanMode;                    // P0907 用户层.速度规划模式
    u16 u16JogSpdDigRef;                 // P0908 用户层.点动速度指令
    u16 u16JogAccDecTime;                // P0909 用户层.点动加减速时间
    u16 _Resv910;                        // P0910
    u16 eSpdLimSrc;                      // P0911 用户层.速度限制来源
    u16 u16SpdLimFwd;                    // P0912 用户层.速度限制0
    u16 u16SpdLimRev;                    // P0913 用户层.速度限制1
    u16 eSpdLimSts;                      // P0914 速度限制状态
    u16 _Resv915;                        // P0915
    u16 u16AiSpdCoeff0;                  // P0916
    u16 u16AiSpdCoeff1;                  // P0917
    u16 u16AiSpdCoeff2;                  // P0918
    u16 _Resv919;                        // P0919
    u16 u16AccTime0;                     // P0920 用户层.加速时间0
    u16 u16DecTime0;                     // P0921 用户层.减速时间0
    u16 u16AccTime1;                     // P0922 用户层.加速时间1
    u16 u16DecTime1;                     // P0923 用户层.减速时间1
    u16 _Resv924;                        // P0924
    u16 _Resv925;                        // P0925
    u16 u16SpdMulRefSel;                 // P0926 用户层.多段速度选择
    s16 s16SpdDigRef01;                  // P0927 用户层.多段数字速度指令01
    s16 s16SpdDigRef02;                  // P0928 用户层.多段数字速度指令02
    s16 s16SpdDigRef03;                  // P0929 用户层.多段数字速度指令03
    s16 s16SpdDigRef04;                  // P0930 用户层.多段数字速度指令04
    s16 s16SpdDigRef05;                  // P0931 用户层.多段数字速度指令05
    s16 s16SpdDigRef06;                  // P0932 用户层.多段数字速度指令06
    s16 s16SpdDigRef07;                  // P0933 用户层.多段数字速度指令07
    s16 s16SpdDigRef08;                  // P0934 用户层.多段数字速度指令08
    s16 s16SpdDigRef09;                  // P0935 用户层.多段数字速度指令09
    s16 s16SpdDigRef10;                  // P0936 用户层.多段数字速度指令10
    s16 s16SpdDigRef11;                  // P0937 用户层.多段数字速度指令11
    s16 s16SpdDigRef12;                  // P0938 用户层.多段数字速度指令12
    s16 s16SpdDigRef13;                  // P0939 用户层.多段数字速度指令13
    s16 s16SpdDigRef14;                  // P0940 用户层.多段数字速度指令14
    s16 s16SpdDigRef15;                  // P0941 用户层.多段数字速度指令15
    s16 s16SpdDigRef16;                  // P0942 用户层.多段数字速度指令16
    u16 _Resv943;                        // P0943
    u16 _Resv944;                        // P0944
    u16 _Resv945;                        // P0945
    u16 u16HomingSpd;                    // P0946 用户层.回原速度
    u16 _Resv947;                        // P0947
    u16 _Resv948;                        // P0948
    u16 _Resv949;                        // P0949
    u16 _Resv950;                        // P0950
    u16 _Resv951;                        // P0951
    u16 _Resv952;                        // P0952
    u16 _Resv953;                        // P0953
    u16 _Resv954;                        // P0954
    u16 _Resv955;                        // P0955
    u16 _Resv956;                        // P0956
    u16 _Resv957;                        // P0957
    u16 _Resv958;                        // P0958
    u16 _Resv959;                        // P0959
    u16 _Resv960;                        // P0960
    u16 _Resv961;                        // P0961
    u16 _Resv962;                        // P0962
    u16 _Resv963;                        // P0963
    u16 _Resv964;                        // P0964
    u16 _Resv965;                        // P0965
    u16 eTrqRefSrc;                      // P0966 用户层.转矩指令来源
    s16 s16TrqDigRef;                    // P0967 用户层.数字转矩指令千分比
    s16 s16FluxDigRef;                   // P0968 用户层.数字磁链指令千分比
    u16 u16EmStopTrqDigRef;              // P0969 用户层.紧急停机转矩
    u16 u16TrqSlopeLim;                  // P0970 用户层.转矩斜率限制
    u16 eTrqLimSrc;                      // P0971 用户层.转矩限制来源
    u16 u16TrqLimFwd;                    // P0972 用户层.转矩限制0
    u16 u16TrqLimRev;                    // P0973 用户层.转矩限制1
    u16 eTrqLimSts;                      // P0974 转矩限制状态
    u16 eTrqSpdLimSts;                   // P0975 转矩模式速度限制状态
    u16 eTrqPosLimSts;                   // P0976 转矩模式位置限制状态
    u16 _Resv977;                        // P0977
    u16 u16TrqArriveTh;                  // P0978 用户层.转矩到达阈值
    u16 _Resv979;                        // P0979
    u16 _Resv980;                        // P0980
    u16 _Resv981;                        // P0981
    u16 u16AiTrqCoeff0;                  // P0982 用户层.模拟量AI0转矩系数
    u16 u16AiTrqCoeff1;                  // P0983 用户层.模拟量AI1转矩系数
    u16 _Resv984;                        // P0984
    u16 u16TrqMulRefSel;                 // P0985 用户层.多段转矩指令选择
    s16 s16TrqDigRef01;                  // P0986 用户层.多段数字转矩指令01
    s16 s16TrqDigRef02;                  // P0987 用户层.多段数字转矩指令02
    s16 s16TrqDigRef03;                  // P0988 用户层.多段数字转矩指令03
    s16 s16TrqDigRef04;                  // P0989 用户层.多段数字转矩指令04
    s16 s16TrqDigRef05;                  // P0990 用户层.多段数字转矩指令05
    s16 s16TrqDigRef06;                  // P0991 用户层.多段数字转矩指令06
    s16 s16TrqDigRef07;                  // P0992 用户层.多段数字转矩指令07
    s16 s16TrqDigRef08;                  // P0993 用户层.多段数字转矩指令08
    s16 s16TrqDigRef09;                  // P0994 用户层.多段数字转矩指令09
    s16 s16TrqDigRef10;                  // P0995 用户层.多段数字转矩指令10
    s16 s16TrqDigRef11;                  // P0996 用户层.多段数字转矩指令11
    s16 s16TrqDigRef12;                  // P0997 用户层.多段数字转矩指令12
    s16 s16TrqDigRef13;                  // P0998 用户层.多段数字转矩指令13
    s16 s16TrqDigRef14;                  // P0999 用户层.多段数字转矩指令14
    s16 s16TrqDigRef15;                  // P1000 用户层.多段数字转矩指令15
    s16 s16TrqDigRef16;                  // P1001 用户层.多段数字转矩指令16
    u16 _Resv1002;                       // P1002
    u16 _Resv1003;                       // P1003
    u16 uwErrorCode_603F;                // P1004
    u16 uwControlword_6040;              // P1005
    u16 uwStatusWord_6041;               // P1006
    s16 swQuickStopOptionCode_605A;      // P1007
    s16 swShutdownOptionCode_605B;       // P1008
    s16 swDisableOperaOptionCode_605C;   // P1009
    s16 swHaltOptionCode_605D;           // P1010
    s16 swFaultReactionCode_605E;        // P1011
    s16 sbModesOpera_6060;               // P1012
    s16 sbModesOperaDisp_6061;           // P1013
    s32 slPosDemandValue_6062;           // P1014
    s32 slPosActualInternalValue_6063;   // P1016
    s32 slUserPosActualValue_6064;       // P1018
    u32 ulFollowErrorWindow_6065;        // P1020
    u32 ulFollowErrorTimeOut_6066;       // P1022
    u32 ulPositionWindow_6067;           // P1024
    u16 uwPositionWindowTime_6068;       // P1026
    u32 ulVelocityDemandValue_606B;      // P1027
    u32 ulVelocityActualValue_606C;      // P1029
    u16 uwVelocityWindow_606D;           // P1031
    u16 uwVelocityWindowTime_606E;       // P1032
    u16 uwVelocityThreshold_606F;        // P1033
    u16 uwVelocityThresholdTime_6070;    // P1034
    s16 swTargetTorque_6071;             // P1035
    u16 uwMaxTorque_6072;                // P1036
    u16 uwMaxCurrent_6073;               // P1037
    s16 swTorqueDemand_6074;             // P1038
    u32 ulMotorRatedCurrent_6075;        // P1039
    u32 ulMotorRatedTorque_6076;         // P1041
    s16 swTorqueActualValue_6077;        // P1043
    s16 swCurrentActualValue_6078;       // P1044
    u32 ulDCLinkCircuitVoltage_6079;     // P1045
    s32 slTargetPosition_607A;           // P1047
    s32 slHomeOffset_607C;               // P1049
    s32 slSoftPositionLimit_607D_0;      // P1051
    s32 slSoftPositionLimit_607D_1;      // P1053
    u16 ubPolarity_607E;                 // P1055
    u32 ulMaxProfileVelocity_607F;       // P1056
    u32 ulMaxMotorSpeed_6080;            // P1058
    u32 ulProfileVelocity_6081;          // P1060
    u32 ulProfileAcceleration_6083;      // P1062
    u32 ulProfileDeceleration_6084;      // P1064
    u32 ulQuickStopDeceleration_6085;    // P1066
    s16 swMotionProfileType_6086;        // P1068
    s16 swTargetSlope_6087;              // P1069
    s16 swTorqueProfileType_6088;        // P1070
    s16 sbHomingMethod_6098;             // P1071
    u16 uwHomingSpeeds_6099_0;           // P1072
    u16 uwHomingSpeeds_6099_1;           // P1073
    u32 ulHomingAcceleration_609A;       // P1074
    s32 slPostionOffset_60B0;            // P1076
    s32 slVelocityOffset_60B1;           // P1078
    s32 slTorqueOffset_60B2;             // P1080
    u16 uwTouchProbeFunction_60B8;       // P1082
    u16 uwTouchProbeStatus_60B9;         // P1083
    s32 slTouchProbe1Pos1PosValue_60BA;  // P1084
    s32 slTouchProbe1Neg1PosValue_60BB;  // P1086
    s32 slTouchProbe2Pos1PosValue_60BC;  // P1088
    s32 slTouchProbe2Neg1PosValue_60BD;  // P1090
    u16 ubInterpTimePeriod_60C2_0;       // P1092
    u16 ubInterpTimePeriod_60C2_1;       // P1093
    u32 ulMaxProfileAcceleration_60C5;   // P1094
    u32 ulMaxProfileDeceleration_60C6;   // P1096
    s32 slFollowErrorActualValue_60F4;   // P1098
    s32 slPositionDemandValue_60FC;      // P1100
    u32 ulDigitalInput_60FD;             // P1102
    u16 uwDigitalOutput_60FE_0;          // P1104
    u16 uwDigitalOutput_60FE_1;          // P1105
    s32 slTargetVelocity_60FF;           // P1106
    u32 ulSupportedDriveModes_6502;      // P1108
    u16 _Resv1110;                       // P1110
    u16 _Resv1111;                       // P1111
    u16 _Resv1112;                       // P1112
    u16 _Resv1113;                       // P1113
    u16 _Resv1114;                       // P1114
    u16 _Resv1115;                       // P1115
    u16 _Resv1116;                       // P1116
    u16 _Resv1117;                       // P1117
    u16 _Resv1118;                       // P1118
}
axis_para_t;

// clang-format on

extern const para_attr_t sDeviceAttr[];
extern const para_attr_t sAxisAttr[];

extern device_para_t sDevicePara;
extern axis_para_t   sAxisPara[CONFIG_AXIS_NUM];

#define D                       sDevicePara
#define P(u16AxisInd)           sAxisPara[u16AxisInd]  // @note: u16AxisNo = u16AxisInd + 1

#define AXIS_NO2IND(u16AxisNo)  ((u16AxisNo) - 1)
#define AXIS_IND2NO(u16AxisInd) ((u16AxisInd) + 1)

#endif
