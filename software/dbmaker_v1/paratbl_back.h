
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
