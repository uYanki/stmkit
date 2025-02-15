#include "api.h"

static int lapi_led_on(lua_State* L)
{
    HAL_GPIO_WritePin(LED1_GPIO_Port, LED1_Pin, GPIO_PIN_SET);
    return 1;
}
static int lapi_led_off(lua_State* L)
{
    HAL_GPIO_WritePin(LED1_GPIO_Port, LED1_Pin, GPIO_PIN_RESET);
    return 1;
}

static int lapi_sleep(lua_State* L)
{
    HAL_Delay(lua_tointeger(L, 1));
    return 1;
}

luaL_Reg luaLib[] = {
    {"sleep",   lapi_sleep  },
    {"led_on",  lapi_led_on },
    {"led_off", lapi_led_off},
    {NULL,      NULL        }
};

#if 0

/*
** these libs are loaded by lua.c and are readily available to any Lua
** program
*/
static const luaL_Reg loadedlibs[] = 
{
  {"_G", luaopen_base},
  {LUA_LOADLIBNAME, luaopen_package},
  {LUA_COLIBNAME, luaopen_coroutine},
  {LUA_TABLIBNAME, luaopen_table},
  //{LUA_IOLIBNAME, luaopen_io},
  //{LUA_OSLIBNAME, luaopen_os},
  {LUA_STRLIBNAME, luaopen_string},
  {LUA_MATHLIBNAME, luaopen_math},
  {LUA_UTF8LIBNAME, luaopen_utf8},
  {LUA_DBLIBNAME, luaopen_debug},
#if defined(LUA_COMPAT_BITLIB)
  {LUA_BITLIBNAME, luaopen_bit32},
#endif
  {NULL, NULL}
};
 
// luaL_openlibs(L);  // 注册各种库函数
LUALIB_API void luaL_openlibs (lua_State *L) 
{
  const luaL_Reg *lib;
  /* "require" functions from 'loadedlibs' and set results to global table */
  for (lib = loadedlibs; lib->func; lib++) 
  {
    luaL_requiref(L, lib->name, lib->func, 1);
    lua_pop(L, 1);  /* remove lib */
  }
}

// 注册函数
// luaL_requiref(L,"mylib",luaopen_mylib,1);
// lua_pop(L,1);
// 也可以在linit.c的loadedlibs数组中添加{"mylib",luaopen_mylib}

static int func1(lua_State *L)
{
    //luaL_checknumber检测参数是否为数字
    float  val=sin(luaL_checknumber(L, 1));
    //压入结果
    lua_pushnumber(L,val ); 
 
    return 1; //结果的个数，这里为1
}

//如无需返回值，则更加简单
static int func2(lua_State *L)
{
    //luaL_checkstring检测参数是否为字符串并返回地址
      printf(luaL_checkstring(L,1));
      LCD_ShowString(30,60+20,200,16,16,"LUA:show");
 
    return 1; //结果的个数，这里为1
}

#endif

#if 0

	HAL_SD_CardInfoTypeDef my_info;		//读取卡信息
	HAL_SD_GetCardInfo(&hsd,&my_info);
	printf( "CardType is :%d\r\n", hsd.SdCard.CardType);
	printf( "CardCapacity is :%d\r\n", hsd.SdCard.BlockNbr);
	printf( "CardBlockSize is :%d\r\n", hsd.SdCard.BlockSize);

	for(int i = 0; i < 512; i++) txbuf[i] = i%100;	//txbuf装填数据
	
	HAL_SD_WriteBlocks_DMA(&hsd,txbuf,100,1);		//txbuf写入
	while(HAL_SD_GetCardState(&hsd) != HAL_SD_CARD_TRANSFER);//等待传输完成
	printf("HAL_SD_WriteBlocks_DMA success\r\n");

	HAL_SD_ReadBlocks_DMA(&hsd,rxbuf,100,1);		//rxbuf读出
	while(HAL_SD_GetCardState(&hsd) != HAL_SD_CARD_TRANSFER);
	printf("HAL_SD_ReadBlocks_DMA success\r\n");
	
	for(int i = 0; i < 512; i++) printf("	%d", rxbuf[i]);	//打印rxbuf

#endif
