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
