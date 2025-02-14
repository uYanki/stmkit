
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
