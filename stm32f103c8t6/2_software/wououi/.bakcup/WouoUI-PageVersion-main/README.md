# WouoUI-PageVersion1.0.0
## 写在前面

### 简介&致谢

- 这是一个灵感源自WouoUI的**纯C语言(C99标准)**，**无依赖库(只需要C的标准库)**，适用于**多种不同大小屏幕**，**极易部署的代码框架**，可以快速构建、开发一个丝滑、Q弹的单色屏UI。
- 本项目最新的源码使用基于EasyX的PC仿真(该仿真模拟器由[叻叻菌](https://space.bilibili.com/86391945)移植实现的)实现，之后会适配本项目的最开始的硬件版本(Air001上)，目前Air001硬件版本工程中使用的还是0.10版本，**其余工程都是最新的1.0.0（Stm32的工程已更新到最新的1.0.0版本）。**
- 在此十分感谢WouoUI(Arduino单文件版本)作者开源WouoUI的源码🙏🙏(是本项目的灵感来源)，这是[WouoUI的Github链接](https://github.com/RQNG/WouoUI )和[作者的b站链接](https://space.bilibili.com/9182439)。
- 同时感谢[叻叻菌](https://space.bilibili.com/86391945)移植实现的基于EasyX的PC仿真版本🙏🙏，并为本项目引入 指示器连贯动画，使用渐进整形的动画参数代替浮点运算的神来之笔(👍)等很多新的特性。

### 版本声明和视频演示链接

- 1.0.0版本基于EasyX在PC上仿真的演示效果([极易部署，支持多种尺寸屏幕，支持二次开发的丝滑UI框架——WouoUIPage1.0.0演示视频_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1fANreSE8h/?vd_source=9168c6e8f345501e2daaa866a1f91d5d))。
- Air001的TestUI(0.1.0版本)例子的[b站的演示视频](https://www.bilibili.com/video/BV19K421r76m/?share_source=copy_web&vd_source=d55bdbc2322bca2e7e5f953886166b1e)
- Air001的LittleClock例子(0.1.0版本)的b站演示视频: https://www.bilibili.com/video/BV1J6421g7H1/
- Stm32的TestUI例子(0.1.0版本)的b站演示视频:  https://www.bilibili.com/video/BV1mS421P7CZ/
- 具体版本更新的说明和未来更新的进度查看最底部的[项目维护](#项目维护)

### 最新版本的新特性（1.0.0）

1.  **适配多尺寸屏幕**，可以通过WouoUI_conf.h中的宽长的宏定义更改屏幕宽长，所有页面的元素都会自动居中
2. **字体自适应**，同样在WouoUI_conf.h中的修改页面使用的字体，页面会自适应字体的宽高
3. **长文本自动滚动**，长文本在选中时会自动滚动，同时滚动模式、速度和起始延时都有参数可以调整
4. **基于anim、slide动画监视的软件动态刷新**，相比硬件buff对比动态刷新：

- 软件刷新：基于动画监视，静止时完全停止状态机，只会轮询msg输入，通用性不如硬件动态刷新。
- 硬件刷新：基于buff对比，通用性强，但需要多一个buff作为对比，同时静止时，内部buff的clear和重新写入一直在运行，只是没有将buff发送
5. 主状态机优化，将弹窗抽象为页面(弹窗状态机和页面状态机融合)，支**持任意页面的弹窗调用和弹窗自身的嵌套调用**
6. 修改了回调函数类型，回调函数会将该页面msg传入，方便使用者进行更灵活的开发，且所有页面回调函数调用机制统一——**只要有该页面有msg输入就会调用**.
7. 宏参数检查和LOG提示

### 内存占用

运行`WouoUI_user.c/h` 中自带的例程(包含7个弹窗页面，5个列表页面，1个磁贴页面和1个波形页面的Flash和RAM占用如下表所示)，测试环境使用KeilV5编译器，所有WouoUIPage相关文件使用O3优化等级，对比移植前后的`Program Size` 变化

| Program Size   | Code段 | Ro-Data段 | Rw-data段 | ZI-data段 |
| -------------- | ------ | --------- | --------- | --------- |
| 移植前后的增量 | 23276  | 6452      | 3464      | 522       |

所以，移植WouoUIPage版并使用如上的例程的UI，至少需要Flash约33KB, RAM约4KB。注意其中包括TitlePage的图片(占720B)和提供的五种大小的字库(使用统一的字体大小，如stm32工程中将SpinWin的字体统一为6*8，减少Ro-data段的大小，大约能较少大概1.3KB)。增加一个页面需要的Flash和RAM是很少的(除了需要自带数据buff的波形页面，其余页面对象基本都是由基本数据组成的)，下次更新时会加上每增加一个xx类型的页面大概需要多少Flash和RAM的消耗。

## 移植说明

### 本项目的文件说明

```markdown
|---Csource(这个文件夹是WouoUIPage最主要的源代码文件，移植时主要用这里面的几个文件)
	其中WouoUI_user.c/h是用户使用接口编写的UI文件，目前里面编写了一个简单的例子，开发自己的界面是可以用这个例子做更改
|---HardwareTestingDevice(这个文件夹存在着我所用来测试WouoUI Page版的相关硬件资料)
	|---HardWare1.0_air001(用于测试WouoUIPage的第一版的硬件以air001作为主控，不过内存比较小之后会考虑更换，与第一版相关的硬件资料就都放在这个文件夹下，之后版本的文件夹也会遵从这样的命名方式HardWarex.0_主控)
|---ProjectExamples  (这个文件夹内放着使用WouoUIPage的工程的参考，按主控的类型划分，为移植时提供一些参考)
	|---Air001(0.1.0版本)
	|---Stm32(1.0.0版本)
	|---PCSimulate(一直都会是最新版本)
|---Image (存放一些展示用的图片)
|---SoftWare(取模软件和说明)
```
### 源文件组(CSource文件夹)

WouoUIPage版源代码非常简单(CSource文件夹下)，按功能可以划分为以下几部分

| 代码文件 | 作用 |
| :------: | :--: |
| WouoUI_conf.h/WouoUI_common.h | 配置文件，定义屏幕宽高、字体等参数/内部通用的一些函数和宏 |
| WouoUI_font.c/h | 字体文件和数组 |
| WouoUI_anim.c/h | 非线性动画实现 |
| WouoUI_msg.c/h | 输入消息队列的实现 |
| WouoUI_graph.c/h | 图形层，提供基本的图形和字符绘制函数 |
| **WouoUI_page.c/h** | **提供了Title\List\Wave三个基本的全页面** |
| **WouoUI_win.c/h** | **提供了Msg\Conf\Val\Spin\ListWin五种基本的弹窗页面** |
|**WouoUI.c/h** | **核心状态机和UI调度的代码** |
| WouoUI_user.c/h | 用户UI文件，内实现了一个使用WouoUIPage版提供接口实现的一个UI的样例 |

### 快速上手

直接使用提供的UI用例放在128*64屏幕单色屏上的话，只需要下面四步

1. 准备一个测试无误的OLED屏幕的读写工程，将CSource下的文件添加进自己的工程，并在主函数中include `WouoUI.h` `WouoUI_user.h` 。
2. 在OLED硬件初始化完成后使用  `WouoUI_AttachSendBuffFun` 函数绑定自己的OLED屏幕刷新函数，自己刷新函数需要接收一个`uint8_t [8][128]`的数组 ,并将这个数组发送至OLED内部的显存中。
3. 在主循环前调用 `TestUI_Init()` ，在主循环中（间隔一段时间或者）直接循环调用`TestUI_Proc()`函数即可。
4. 根据自己的输入设备，调用 `WOUOUI_MSG_QUE_SEND` 向UI发送对应的消息。

### 移植大致流程

移植时，可以参考ProjectExamples文件夹下的工程(注意最新版本请参考PC_Simulate和stm32版本的工程例子)

1. 将上述说明的WouoUIPage的源文件包含在工程中。

2. 在WouoUI_conf.h中自己屏幕的尺寸修改对应的宏`WOUOUI_BUFF_WIDTH` 、 `WOUOUI_BUFF_HEIGHT`。

   >这两个宏确定了使用的屏幕缓存的大小，在代码中定义为：
   >
   >`#define UINT_DIVISION_CELL(a,b)  ((a + b - 1) / b)`
   >
   >`#define WOUOUI_BUFF_HEIGHT_BYTE_NUM UINT_DIVISION_CELL(WOUOUI_BUFF_HEIGHT,8) `
   >
   >`typedef uint8_t ScreenBuff[WOUOUI_BUFF_HEIGHT_BYTE_NUM][WOUOUI_BUFF_WIDTH];`
   >
   >即内部使用的缓存数组，是一个`[高度/8+1][宽度]` 的二维数组，即字节是竖着存放在buff中(这和一般的OLED的芯片内部的字节排布是一致的)，同时高度所需的字节数是`高度/8` 再向上取整得到的，字节序可以参考下图。

   ![buff字节排布](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/buff%E5%AD%97%E8%8A%82%E6%8E%92%E5%B8%83.png)

3. 根据自己使用的单色屏和自己使用的MCU完成一个缓存的刷新函数，函数原型如下 

   > `void FunSendScreenBuff(uint8_t array[WOUOUI_BUFF_HEIGHT_BYTE_NUM][WOUOUI_BUFF_WIDTH]);`
   >
   > **在指定UI后(如果没有指定，就是使用内部的默认UI对象)，使用 `WouoUI_AttachSendBuffFun` 函数，将上面实现的缓存到屏幕的刷新函数绑定到对应的UI上。**
   >
   > 这个函数需要实现将参数传入的数组的数据更新到单色屏上，数组的大小为 
   >
   > (这里建议硬件上使用SPI或者至少是硬件IIC，软件IIC刷新速率可能太慢，对动画效果有影响)


4. **在主循环或者每隔固定时间间隔调用`WouoUI_Proc` 这个函数。** **1.0.0版使用软件动态刷新后，在没有动画需要绘制时是会自动退出主状态机，只轮询消息输入的，不会浪费CPU的资源一直进行重绘**😉。

   ```c
   #define SOFTWARE_DYNAMIC_REFRESH    1   //使能软件动态刷新
   #define HARDWARE_DYNAMIC_REFRESH    0   //使能硬件动态刷新
   ```
   
4. 根据自己的需要实现`WouoUI_LOG` 这个日志打印接口，不实现也可以，主要用于打印提示一些可能的报错。

   基于EasyX的PC仿真中，使用的是printf，单片机上建议使用串口直接打印输出就可以了。

   ```C
   #define WOUOUI_LOG_ENABLE   
   #ifdef  WOUOUI_LOG_ENABLE
   #define WOUOUI_LOG(fmt,...)     printf(fmt,##__VA_ARGS__)
   #else
   #define WOUOUI_LOG(fmt,...)     
   #endif
   ```

OK ，到这里的话，就算移植结束了(基本上只要提供好接口函数就行了，因为基本没有改啥🤣)，可以开始使用WouoUIPage提供的接口了。

## 整体框架说明和配置文件WouoUI_conf.h

### 整体框架说明

如下图所示，**WouoUIPage版1.0.0版提供了三个全页面、五个弹窗页面类型用于构建UI，内部有一个消息队列用于接收外界的消息，每个页面都有一个回调函数，会将当前页面地址和页面当前收到的Msg传入，用户的操作可以在回调函数中判断Msg选择执行。**

![WouoUI整体框架](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/WouoUI%E6%95%B4%E4%BD%93%E6%A1%86%E6%9E%B6.png)

### 配置文件WouoUI_conf.h

具体的宏的如果修改，可以直接看代码注释。

```c
#ifndef __WOUOUI_CONF_H__
#define __WOUOUI_CONF_H__

//---------------------与调试相关的参数

#define WOUOUI_LOG_ENABLE   //是否使能WouoUI_Log的打印，使能的话需要实现下面的LOG打印函数
#ifdef  WOUOUI_LOG_ENABLE
#define WOUOUI_LOG(fmt,...)     printf(fmt,##__VA_ARGS__)
#else
#define WOUOUI_LOG(fmt,...)     
#endif

//---------------------与UI相关的参数
#define WOUOUI_BUFF_WIDTH           128 // 屏幕宽
#define WOUOUI_BUFF_HEIGHT          64  // 屏幕高
#define WOUOUI_INPUT_MSG_QUNEE_SIZE 4 // ui内部消息对列的大小(至少需要是2)
#define WOUOUI_WIN_TXT_DEFAULT      "NO SET TEXT!!!" //当弹窗没有设置自动获取且没有设置文本时的默认文本

#define SOFTWARE_DYNAMIC_REFRESH    1   //使能软件动态刷新
#define HARDWARE_DYNAMIC_REFRESH    0   //使能硬件动态刷新

#define WOUOUI_STR_LINE_SPACING     1   // 绘制字符串时行间距
#define WOUOUI_SLIDESTR_START_DELAY  20  //slidestr开始滑动的延迟大小(最大255)


//------------------与title页面相关的默认参数
#define DEFAULT_TILE_B_TITLE_FNOT           Font_12_24  // 磁贴大标题字体
#define DEFAULT_TILE_ICON_W                 30         // 磁贴图标宽度
#define DEFAULT_TILE_ICON_H                 30         // 磁贴图标高度
#define DEFAULT_TILE_ICON_IND_U             3          //磁贴指示器与磁贴的上边距
#define DEFAULT_TILE_ICON_IND_D             3         //磁贴指示器与磁贴的下边距
#define DEFAULT_TILE_ICON_IND_L             3         //磁贴指示器与磁贴的左边距
#define DEFAULT_TILE_ICON_IND_R             3        //磁贴指示器与磁贴的右边距
#define DEFAULT_TILE_ICON_IND_SL            5        //磁贴指示器边长SideLength
#define DEFAULT_TILE_ICON_S                 6       //磁贴图标间距(图标边和边的距离)
#define DEFAULT_TILE_BAR_D                  2       //磁贴装饰条下边距
#define DEFAULT_TILE_BAR_W                  8       //磁贴装饰条宽度
#define DEFAULT_TILE_BAR_H                  24      //磁贴装饰条高度
#define DEFAULT_TILE_SLIDESTR_MODE          2       //磁贴标题文本的滚动模式
//------------------与list页面相关的默认参数
#define DEFAULT_LIST_TEXT_FONT              Font_6_8   //列表文字的字体
#define DEFAULT_LIST_TEXT_U_S               3          //列表文字的上边距
#define DEFAULT_LIST_TEXT_D_S               2          //列表文字的下边距
#define DEFAULT_LIST_TEXT_L_S               3          //列表文字的左边距
#define DEFAULT_LIST_TEXT_R_S               3          //列表文字的右边距(到侧边进度条的距离)
#define DEFAULT_LIST_IND_VAL_S              1          //指示器和val文本的间距
#define DEFAULT_LIST_BAR_W                  3          //列表进度条宽度，需要是奇数，因为正中间有1像素宽度的线
#define DEFAULT_LIST_IND_BOX_R              2          //列表指示器选择框倒角
#define DEFAULT_LIST_CHECK_BOX_R            2          //列表确认选择框倒角
#define DEFAULT_LIST_CHECK_BOX_D_R          2          //列表确认选择框内点的倒角
#define DEFAULT_LIST_CHECK_BOX_D_S          1          //列表确认选择框内点到宽的边距
#define DEFAULT_LIST_TEXT_LEN_PER_MAX       62         //这个是百分占比即列表文字最大长度占宽度的比例
#define DEFAULT_LIST_VAL_BUFF_SIZE          16         //列表值文本缓冲区的大小
#define DEFAULT_LIST_TXT_SLIDESTR_MODE      2          //list文本的滚动模式
#define DEFAULT_LIST_VAL_SLIDESTR_MODE      2          //list数值文本的滚动模式
    //以下四个字符串不能有重复，重复会按单选框显示，
    //个人习惯是'-'一般选项；'~'数值弹窗；'='数值显示;'>'列表弹窗；'@'二值选项；'#'确认弹窗；'$'Spin弹窗
#define DEFAULT_LIST_LINETAIL_VAL_PREFIX    "~"       //listtext中使用这些字符其中一个，行尾会把val显示出来
#define DEFAULT_LIST_LINETAIL_TXT_PREFIX    "><"        //listtext中使用这些字符其中一个，行尾会把content显示出来
#define DEFAULT_LIST_LINETAIL_SPIN_PREFIX   "%$="        //listtext中使用这些字符其中一个，行尾会把val按照decimal显示为定点数
#define DEFAULT_LIST_LINETAIL_CONF_PREFIX   "@#"        //listtext中使用这些字符其中一个，行尾会显示一个单选框(其中第一个作为二值选项框会自动处理,如果开启自动处理的话)
//------------------与Wave页面相关的默认参数
#define DEFAULT_WAVE_FONT                   Font_6_8   // 波形字体
#define DEFAULT_WAVE_Y_AXIS_LABEL_WIDTH     20      //y轴标签的宽度
#define DEFAULT_WAVE_D_CUR_VAL_WIDTH        20  //底部数值的显示宽度
#define DEFAULT_WAVE_BOX_L_S                0   // 波形边框左边距
#define DEFAULT_WAVE_BOX_R_S                0   // 波形边框右边距
#define DEFAULT_WAVE_BOX_U_S                0   // 波形边框上边距
#define DEFAULT_WAVE_BOX_D_S                1   // 波形边框下边距
#define DEFAULT_WAVE_D_TXT_VAL_S            3   //底部文本和数值和显示标志的间隔
#define DEFAULT_WAVE_TEXT_D_S               1   //文本行到底边的边距
#define DEFAULT_WAVE_TEXT_W                 60  //文本行的宽度
#define DEFAULT_WAVE_DEPTH                  (WOUOUI_BUFF_WIDTH-DEFAULT_WAVE_Y_AXIS_LABEL_WIDTH+100)   //默认波形的储存深度
#define DEFAULT_WAVE_TXT_SLIDESTR_MODE      2   //WAVE文本的滚动模式
#define DEFAULT_WAVE_VAL_SLIDESTR_MODE      2   //WAVE数值文本的滚动模式

//---------------与MsgWin页面相关的默认参数
#define DEFAULT_MSG_WIN_FONT                Font_6_8 // Msg弹窗字体
#define DEFAULT_MSG_WIN_W                   100  //MSG弹窗的宽度
#define DEFAULT_MSG_WIN_V_S_MIN             12  //MSG弹窗到屏幕两侧的上下边距的最小值
#define DEFAULT_MSG_WIN_R                   2   //MSG弹窗的倒角大小
#define DEFAULT_MSG_WIN_FONT_MARGIN         4   //MSG弹窗文本到边框来的边距

//---------------与ConfWin页面相关的默认参数
#define DEFAULT_CONF_WIN_FONT               Font_6_8  // CONF弹窗字体
#define DEFAULT_CONF_WIN_W                  100  //CONF弹窗的宽度
#define DEFAULT_CONF_WIN_V_S_MIN            12  //CONF弹窗到屏幕两侧的上下边距的最小值
#define DEFAULT_CONF_WIN_R                  2   //CONF弹窗的倒角大小
#define DEFAULT_CONF_WIN_FONT_MARGIN        4   //CONF弹窗文本到边框来的边距
#define DEFAULT_CONF_WIN_IND_BTN_S          2   //按键内文本和指示器的竖直间距
#define DEFAULT_CONF_WIN_BTN_R              2   // 按键倒角
#define DEFAULT_CONF_WIN_TEXT_BTN_S         2   //文本和按键的竖直间距
#define DEFAULT_CONF_BTN_SLIDESTR_MODE      2   //WAVE文本的滚动模式

//--------------与ValWin页面相关的默认参数
#define DEFAULT_VAL_WIN_FONT                Font_6_8  // Val弹窗字体
#define DEFAULT_VAL_WIN_STR_BUFF_SIZE       16        //临时buff的大小
#define DEFAULT_VAL_WIN_W                   120  //Val弹窗的宽度
#define DEFAULT_VAL_WIN_R                   2    //Val弹窗的倒角大小
#define DEFAULT_VAL_WIN_TXT_W_MAX           78   //val弹窗内文本可显示宽度的最大值
#define DEFAULT_VAL_WIN_TXTVAL_S            8    //弹窗内文本和val间的间距
#define DEFAULT_VAL_WIN_BAR_W               66   // 进度条宽度
#define DEFAULT_VAL_WIN_BAR_H               7    // 进度条高度
#define DEFAULT_VAL_WIN_BAR_R               1    // 进度条倒角
#define DEFAULT_VAL_MMVAL_BAR_S             2    // 进度条与MIN MAX VAL间的边距
#define DEFAULT_VAL_TEXT_BAR_S              8    // 下方进度条和上方文本的间距
#define DEFAULT_VAL_WIN_FONT_MARGIN         4    // 弹窗内部元素到边框的边距
#define DEFAULT_VAL_WIN_TXT_SLISTRMODE      3    // Val弹窗文本的滚动模式
#define DEFAULT_VAL_WIN_VAL_SLISTRMODE      3    // Val弹窗数值文本的滚动模式

//--------------与SpinWin页面相关的默认参数
#define DEFAULT_SPIN_WIN_FONT               Font_7_12    // 弹窗字体
#define DEFAULT_SPIN_WIN_NUM_FONT           Font_7_12   // 数字字体
#define DEFAULT_VAL_WIN_STR_BUFF_SIZE       16   //临时buff的大小
#define DEFAULT_SPIN_WIN_W                  100  // Spin弹窗的宽度
#define DEFAULT_SPIN_WIN_NUM_S              2    // spin内数字之间横向间隔(必须是偶数，为了显示好看)
#define DEFAULT_SPIN_WIN_FONT_MARGIN        4    // Spin弹窗内元素到边框的边距
#define DEFAULT_SPIN_WIN_V_S                2    // Spin弹窗内元素间上下边距
#define DEFAULT_SPIN_WIN_BOX_R              1    // Spin弹窗的指示器倒角大小
#define DEFAULT_SPIN_WIN_BOX_H              3    // Spin弹窗的指示器高度
#define DEFAULT_SPIN_WIN_R                  2    // Spin弹窗的倒角大小
#define DEFAULT_SPIN_WIN_MMVAL_S            1    // Spin弹窗的最小最大值间距
#define DEFAULT_SPIN_WIN_SLI_TXT_MODE       2    // Spin弹窗文本的滚动模式
#define DEFAULT_SPIN_WIN_SLI_VAL_MODE       2    // Spin弹窗数值文本的滚动模式

//---------------与ListWin页面相关的默认参数
#define DEFAULT_LIST_WIN_FONT               Font_6_8   // 弹窗字体
#define DEFAULT_LIST_WIN_W                  50         // 弹窗宽度
#define DEFAULT_LIST_WIN_R                  3          // 弹窗倒角
#define DEFAULT_LIST_WIN_BOX_R              2          // 列表选择框倒角
#define DEFAULT_LIST_WIN_L_S                6          // 列表文字左边距
#define DEFAULT_LIST_WIN_R_S                0          // 列表文字的右边距(到侧边进度条的距离)
#define DEFAULT_LIST_WIN_BAR_W              3          // 必须是单数，因为需要中间为1的进度条
#define DEFAULT_LIST_WIN_TEXT_U_S           3          // 列表每行文字的上边距
#define DEFAULT_LIST_WIN_TEXT_D_S           3          // 列表每行文字的上边距

#endif

```

## 接口函数的使用

这个部分会说明一部分构建UI可能用到的结构体类型(类)和一些函数。构建的时候也参考WouoUI_user.c/.h的实现。

### 类(结构体类型)

#### 总体介绍

一共有8种页面类型，包括三个全页面类型和五个弹窗页面类型 ： 

- 磁贴页面`TitlePage` 

- 列表页面`ListPage` 

- 波形页面`WavePage` 

- 消息弹窗`MsgWin` 

- 确认弹窗`ConfWin` 

- 用于整数调节的数值条弹窗`ValWin`

- 用于浮点数(实际是定点数)调节的微调弹窗`SpinWin` 

- 用于字符串选择的列表弹窗`ListWin`   

  另外还有3个比较重要的类 `InputMsg` 、 `Option`  和 `CallBackFunc` 。其他的一些枚举类型一些只有个别函数才会用到的结构体就不一一说明了，根据函数说明填入对应类型即可。

#### 枚举输入消息

- `InputMsg` : 输入信息枚举类型，作为`void WOUOUI_MSG_QUE_SEND(InputMsg msg);` 的参数类型，用于给UI输入一个外界动作的消息，枚举的消息共有以下几种：

  ```C
  //---------输入消息枚举类型(标准的五向按键位样本)
  typedef enum {
      msg_up = 0x00,   // 上，或者last消息，表上一个
      msg_down,        // 下，或者next消息，表下一个
      msg_left,        // 左，混合模式时表示上一个
      msg_right,       // 右，混合模式时表示下一个
      msg_click,       // 点击消息，表确认，确认某一选项，回调用一次回调
      msg_return,      // 返回消息，表示返回，从一个页面退出
      msg_home,        // home消息，表回主界面(尚未设计，目前还没有设计对应的功能，默认以page_id为0的页面为主页面)
      msg_none = 0xFF, // none表示没有操作
  } InputMsg;          // 输入消息类型，
  ```

#### 选项类

- `Option` ：选项类，其结构体成员如下：

  ```c
  //-------页面成员类型
  typedef struct Option {
      String text;
      // 这个列表项显示的字符串,
      // 无效果(-)/数值显示(=)/
      // 弹窗类:滑动数值弹窗(~)/微调数字弹窗($)/提示弹窗(!)/二值确认弹窗(#)/侧边列表(>)
      // 列表内:二值选框(@)
      // 跳转:跳转页面(+)/跳转波形页面($)/跳转文本页面({)
      String content;        // 文本内容
      int32_t val;           // 这个列表项关联的显示的值(可以用于设置初值) 
      uint8_t order;         // 该选项在列表/磁贴中的排序(0-255)
      DecimalNum decimalNum; // 小数位数
  } Option; // 通用选项类型
  ```

  >Option变量的初始化需要注意：
  >
  >**注意这个字符串前两个字符作为列表中行尾显示的判断，个人比较喜欢叻叻菌提供的习惯(如上注释所示)，具体什么字符开头对应列表行尾显示Option的什么成员可以在Conf文件中自己设定**，如下所示。
  >
  >```C
  >//以下四个字符串不能有重复，重复会按单选框显示，
  >//个人习惯是'-'一般选项；'~'数值弹窗；'='数值显示;'>'列表弹窗；'@'二值选项；'#'确认弹窗；'$'Spin弹窗
  >#define DEFAULT_LIST_LINETAIL_VAL_PREFIX    "~"       //listtext中使用这些字符其中一个，行尾会把val显示出来
  >#define DEFAULT_LIST_LINETAIL_TXT_PREFIX    "><"        //listtext中使用这些字符其中一个，行尾会把content显示出来
  >#define DEFAULT_LIST_LINETAIL_SPIN_PREFIX   "%$="        //listtext中使用这些字符其中一个，行尾会把val按照decimal显示为定点数
  >#define DEFAULT_LIST_LINETAIL_CONF_PREFIX   "@#"        //listtext中使用这些字符其中一个，行尾会显示一个单选框(其中第一个作为二值选项框会自动处理,如果开启自动处理的话)
  >```

#### 回调函数

- `CallBackFunc` : 回调函数类型，每个页面都需要一个回调函数(如果没有回调函数，在对应初始化函数中置NULL即可)。

  通常需要定义一个形如`bool MainPage_CallBack(const Page *cur_page_addr, InputMsg msg) `的函数(其中，MainPage_CallBack是由我们定义的回调函数名(地址))，并该函数地址作为参数给对应的页面初始化函数。

  > **在页面中有msg输入时，就会调用该页面的回调函数**
  >
  > 传入回调函数的参数`self_page` 为当前页面的地址(以Page*指针的形式传入，可以强转为任何页面类型)；
  >
  > 传入回调函数的参数`msg`为当前页面输入的msg。

  需要注意的是每个页面都有成员`Page.auto_deal_with_msg`，用于控制页面是否会自动处理Msg，默认是使能的，页面会根据输入的Msg自动进行UI的操作，像切换选项等。

  ```c
  /**
   * @brief 设置页面是否自动处理消息
   * @param page 目标页面结构体指针
   * @param open true开启自动处理,false关闭自动处理
   */
  void WouoUI_SetPageAutoDealWithMsg(Page* page, bool open);
  ```

  如果使用上面这个接口函数失能自动处理的话，用户在回调函数中，除了要处理数据之外，还需要调用对应页面的接口函数，控制UI的动作(就是提供了一个更灵活的接口)。

下面会分成8个基础页面类型来介绍对应的页面类型，同时说明接口函数的使用(其实，大部分接口函数直接看注释都能明白的🤣)。

### UI通用的接口函数和参数

#### 常用的UI接口函数：

```c
/**
 * @brief 发送消息到消息队列
 * @param msg 要发送的消息
 */
#define WOUOUI_MSG_QUE_SEND(msg) WouoUI_MsgQueSend(&(p_cur_ui->msg_queue), msg)
/**
 * @brief 选择默认UI
 */
void WouoUI_SelectDefaultUI(void);
/**
 * @brief 设置当前UI
 * @param ui 要设置的UI指针
 */
void WouoUI_SetCurrentUI(WouoUI *ui);
/**
 * @brief 附加发送缓冲区函数
 * @param fun 发送缓冲区的函数指针
 */
void WouoUI_AttachSendBuffFun(FunSendScreenBuff fun);
/**
 * @brief 处理UI逻辑
 * @param time 时间参数
 */
void WouoUI_Proc(uint16_t time);
/**
 * @brief 跳转到指定页面
 * @param self_page 当前页面地址
 * @param terminate_page 目标页面地址
 */
void WouoUI_JumpToPage(PageAddr self_page, PageAddr terminate_page);
/**
 * @brief 获取当前页面
 * @return 当前页面指针
 */
Page *WouoUI_GetCurrentPage(void);
```

没有通过`WouoUI_SetCurrentUI` 改变通常操作的UI对象的话，默认就是使用内置的ui对象(WouiUI.c内的全局变量)`default_ui` ，目前多UI对象只是留下了接口，相关代码还没有完善(因为一般也不会用到多个UI对象😂)。

#### WouoUI的参数

UI的参数，默认UI参数使用内置的默认UI参数对象(WouoUI.c内的全局变量`g_default_ui_para`)，内容如下：

```c
//===================================全局变量==================================
// 全局UI参数集合对象(同时初始化)，这个UI的相关参数都在这个集合中定义
UiPara g_default_ui_para = {
    .ani_param = {
        [IND_ANI] = 120,  // 指示器动画速度
        [TILE_ANI] = 100, // 磁贴动画速度
        [TAG_ANI] = 100,  // 标签动画速度
        [LIST_ANI] = 100, // 列表动画速度
        [WAVE_ANI] = 100, // 波形动画速度
        [WIN_ANI] = 100,  // 弹窗动画速度
        [FADE_ANI] = 20,  // 页面渐变退出速度
    },
    .ufd_param = {
        [TILE_UFD] = false, // 磁贴图标从头展开开关
        [LIST_UFD] = false, // 菜单列表从头展开开关
    },
    .loop_param = {
        [TILE_LOOP] = true, // 磁贴图标循环模式开关
        [LIST_LOOP] = true, // 菜单列表循环模式开关
        [LIST_WIN_LOOP] = true, // 菜单弹窗循环模式开关
        },
    .slidestrstep_param ={
        [TILE_SSS] = 2,    // 磁贴字符串滚动步进
        [LIST_TEXT_SSS] = 1, // 列表文本滚动步进
        [LIST_VAL_SSS] = 1,  // 列表数值滚动步进
        [WAVE_TEXT_SSS] = 1, // 波形文本滚动步进
        [WAVE_VAL_SSS] = 1,  // 波形数值滚动步进 
        [WIN_TXT_SSS] = 1,   // 弹窗文本滚动步进
        [WIN_VAL_SSS] = 1,   // 弹窗数值滚动步进
    },
    .slidestrmode_param = {
        [TILE_SSS] = (SlideStrMode)2,      // 磁贴字符串滚动模式
        [LIST_TEXT_SSS] = (SlideStrMode)2,  // 列表文本滚动模式
        [LIST_VAL_SSS] = (SlideStrMode)2,   // 列表数值滚动模式
        [WAVE_TEXT_SSS] = (SlideStrMode)2,  // 波形文本滚动模式
        [WAVE_VAL_SSS] = (SlideStrMode)2,   // 波形数值滚动模式
        [WIN_TXT_SSS] = (SlideStrMode)2,    // 弹窗文本滚动模式
        [WIN_VAL_SSS] = (SlideStrMode)2,    // 弹窗数值滚动模式
    },
    .winbgblur_param = {
        [MGS_WBB] = (BLUR_DEGREE)2,    // 消息弹窗背景模糊程度
        [CONF_WBB] = (BLUR_DEGREE)2,   // 确认弹窗背景模糊程度
        [VAL_WBB] = (BLUR_DEGREE)2,    // 数值弹窗背景模糊程度
        [SPIN_WBB] = (BLUR_DEGREE)2,   // 微调弹窗背景模糊程度
        [LIST_WBB] = (BLUR_DEGREE)0,   // 列表弹窗背景模糊程度
    },
};
```

其中的滚动模式和模糊程度参数如下所示：(也可以自己多玩玩WouoUI_user.c提供的例子调整Setting页面下的选项就懂了😉)

```C
typedef enum
{
    SSM_HEAD_RESTART = 0x00, //到头后重新开始
    SSM_TIAL_RESTART,        //到尾后重新开始
    SSM_TAIL_STOP,           //到尾后停止
    SSM_STOP,                //完全停止不滚动的模式
}SlideStrMode;
typedef enum {
    BLUR_0_4 = 0x00, //完全显示
    BLUR_1_4,
    BLUR_2_4,
    BLUR_3_4,
    BLUR_4_4, //完全虚化
} BLUR_DEGREE;
```

### TitlePage类和接口函数

#### TiltlePage页面的演示效果：

![TitlePage](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/TitlePage.gif)

#### TitlePage接口函数

- 查看函数的注释基本就知道怎么用啦🤣(注意有些接口函数只建议在回调函数中使用，因为这部分函数一般只在`Page.auto_deal_with_msg` 失能时使用)。

  ```c
  //TitlePage的接口函数
  /**
   * @brief 初始化标题页面
   * @param title_page 标题页面结构体指针
   * @param item_num 选项数量(需要确保与下面两个数组大小一致)
   * @param option_array 选项数组指针
   * @param icon_array 图标数组指针
   * @param call_back 回调函数指针
   * @attention 数组大小需要使用者传入，确保传入的数组大小正确
   */
  void WouoUI_TitlePageInit(TitlePage *title_page, uint8_t item_num, Option *option_array, Icon *icon_array, CallBackFunc call_back);
  /**
   * @brief 切换到上一个选项
   * @param tp 标题页面结构体指针
   * @attention 此函数只建议在回调函数中使用 
   */
  void WouoUI_TitlePageLastItem(TitlePage *tp);
  /**
   * @brief 切换到下一个选项
   * @param tp 标题页面结构体指针
   * @attention 此函数只建议在回调函数中使用 
   */
  void WouoUI_TItlePageNextItem(TitlePage *tp);
  ```

  还有一个是TitlePage和ListPage共用的 ，用于在回调函数中获取选中项。

  ```c
  /**
   * @brief 获取标题列表页当前选中的选项
   * 
   * @param cur_page_addr 当前页面地址
   * @return Option* 返回选中的选项指针，如果没有选中项则返回NULL
   * 
   * @note 此函数用于获取标题列表页中用户当前选中的选项(该函数TitlePage和ListPage都可以作为参数传入)
   */
  Option* WouoUI_ListTitlePageGetSelectOpt(const Page* cur_page_addr);
  ```

#### TitlePage中的Icon的取模

TitlePage中Icon的是会自动居中的，Icon的本质上是使用数组存放的图片，取模方式按照如下的方式进行：

同理字体的取模也可以使用一样的方式进行。这里取模软件使用的是LCD2002(放在仓库的SoftWare下，SoftWare下的docx文档源自中景园电子，我购买OLED的tb商家，如有侵权，请联系我删除)。取模设置如下：

![image-20250210235613103](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/image-20250210235613103.png)

主要需要注意，使用**列行式** 和**逆向** 的取模走向即可。

### ListPage类和接口函数

#### ListPage页面的演示效果：

![ListPage](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/ListPage.gif)

#### ListPage接口函数

- 查看函数的注释基本就知道怎么用啦🤣(注意有些接口函数只建议在回调函数中使用，因为这部分函数一般只在`Page.auto_deal_with_msg` 失能时使用)。

  ```c  
  // ListPage的接口函数
  /**
   * @brief 初始化列表页面
   * @param lp 列表页面指针
   * @param item_num 列表项目数量
   * @param option_array 选项数组指针
   * @param page_setting 页面设置
   * @param call_back 回调函数
   * @note 用于创建和初始化一个新的列表页面
   */
  void WouoUI_ListPageInit(ListPage *lp, uint8_t item_num, Option *option_array, PageSetting page_setting, CallBackFunc call_back);
  /**
   * @brief 移动到列表的上一个项目
   * @param lp 列表页面指针
   * @attention 此函数只建议在回调函数中使用 
   */
  void WouoUI_ListPageLastItem(ListPage *lp);
  /**
   * @brief 移动到列表的下一个项目
   * @param lp 列表页面指针
   * @attention 此函数只建议在回调函数中使用 
   */
  void WouoUI_ListPageNextItem(ListPage* lp);
  
  /**
   * @brief 获取标题列表页当前选中的选项
   * 
   * @param cur_page_addr 当前页面地址
   * @return Option* 返回选中的选项指针，如果没有选中项则返回NULL
   * 
   * @note 此函数用于获取标题列表页中用户当前选中的选项(该函数TitlePage和ListPage都可以作为参数传入)
   */
  Option* WouoUI_ListTitlePageGetSelectOpt(const Page* cur_page_addr);
  ```

- **需要注意，ListPage初始化函数中有个`page_setting` 如果设置为 `Setting_radio` 的话，则会将页面内`@`或 者 `#`开头的字符串(这个可以在conf.h中设置)作为单选项来处理。**效果如下：

  ![RadioPage](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/RadioPage.gif)

### WavePage类和接口函数

#### WavePage页面的演示效果

![WavePage](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/WavePage.gif)

#### WavePage页面的接口函数

```c
// ------波形页面接口函数
/**
 * @brief 初始化波形页面
 * @param wp 波形页面控制器指针
 * @param wave_num 波形数量
 * @param wave_data_array 波形数据数组
 * @param call_back 回调函数
 */
void WouoUI_WavePageInit(WavePage *wp, uint8_t wave_num, WaveData * wave_data_array, CallBackFunc call_back); 
/**
 * @brief 更新指定波形的数据值
 * @param wp 波形页面控制器指针
 * @param wave_num 波形编号
 * @param new_data 新的波形数据
 */
void WouoUI_WavePageUpdateVal(WavePage* wp, uint8_t wave_num, int16_t new_data);
/**
 * @brief 显示波形数组中上一组波形数据
 * @param wp 波形页面控制器指针
 */
void WouoUI_WavePageShowLastWaveData(WavePage* wp);
/**
 * @brief 显示波形数组中下一组波形数据
 * @param wp 波形页面控制器指针
 * @attention 此函数只建议在回调函数中使用
 */
void WouoUI_WavePageShowNextWaveData(WavePage* wp);
/**
 * @brief 检查指定波形是否可以向左或向右移动
 * @param wp 波形页面控制器指针
 * @param wave_num 波形编号
 * @param left0ORright1 移动方向(0:左移, 1:右移)
 * @return true 可以移动
 * @return false 不能移动
 * @attention 此函数只建议在回调函数中使用
 */
bool WouoUI_WavePageCanShiftWave(WavePage * wp, uint8_t wave_num, uint8_t left0ORright1);//返回true,表示能够移动
/**
 * @brief 波形左移操作
 * @param wp 波形页面控制器指针
 * @param wave_num 波形编号
 * @return true 移动成功
 * @return false 已到最左端
 * @attention 此函数只建议在回调函数中使用
 */
bool WouoUI_WavePageLeftShiftWave(WavePage* wp, uint8_t wave_num); //返回值表示是否已经到头了(即有没有成功shift波形)
/**
 * @brief 波形右移操作
 * @param wp 波形页面控制器指针
 * @param wave_num 波形编号
 * @return true 移动成功
 * @return false 已到最右端
 * @attention 此函数只建议在回调函数中使用
 */
bool WouoUI_WavePageRightShiftWave(WavePage* wp, uint8_t wave_num);
/**
 * @brief 停止或重启波形显示
 * @param wp 波形页面控制器指针
 * @param wave_num 波形编号
 * @param stop 停止标志(true:停止, false:重启)
 * @attention 此函数只建议在回调函数中使用
 */
void WouoUI_WavePageStopRestartWave(WavePage* wp, uint8_t wave_num, bool stop);
/**
 * @brief 检查波形是否处于停止状态
 * @param wd 波形数据指针
 * @return true 已停止
 * @return false 正在运行
 * @attention 此函数只建议在回调函数中使用
 */
#define WouoUI_WaveDataIsStop(wd) ((wd)->stop_flag)
```

- **如果使能`auto_deal_with_msg` (默认是使能的)，页面的处理逻辑是，在波形运动时，上下(或者左右)切换不同波形数据；在波形停止时，上下(或者左右)查看历史波形(像示波器一样)。最大能查看多少波形，取决于conf.h中设置的波形深度（这里使用的深度是比波形宽度大100个点，前面那部分用于计算波形显示宽度，因为波形页面会进行字体自适应）**。

  ```c
  #define DEFAULT_WAVE_DEPTH                  (WOUOUI_BUFF_WIDTH-DEFAULT_WAVE_Y_AXIS_LABEL_WIDTH+100)   //默认波形的储存深度
  ```

#### 波形数据结构体

关于波形数据结构体，初始化时建议赋值的成员如下：

以下是WouoUI_User.c的使用用例，使用者可以多参考这个文件的使用方式。

```c
//波形数据
WaveData wave_data_array[] = {
    [0] = {
        .text = (char *)"sin wave",
        .waveType = WaveType_Solid,
        .data = {0},
        .decimal_num = DecimalNum_2,
    },
    [1] = {
        .text = (char *)"cos wave",
        .waveType = WaveType_Dash,
        .data = {0},
        .decimal_num = DecimalNum_1,
    },
};
```

### MsgWin类和接口函数

#### MsgWin页面的演示效果

![MsgWin](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/MsgWin.gif)

#### MsgWin的接口函数

```c
void WouoUI_MsgWinPageInit(MsgWin* mw, char* content, bool auto_get_bg_opt, uint16_t move_step, CallBackFunc cb);
/**
 * @brief 设置消息窗口的显示内容
 * 
 * @param mw 指向消息窗口的指针
 * @param content 要显示的消息内容
 * @return true 设置成功
 * @return false 设置失败
 * 
 * @attention 确保消息窗口页面初始化过(建议只在回调函数中调用此函数)
 */
bool WouoUI_MsgWinPageSetContent(MsgWin *mw, char* content);
/**
 * @brief 向上滑动消息窗口文本
 * 
 * @param mw 指向消息窗口的指针
 * @return true 如果成功滑动
 * @return false 如果无法滑动
 * 
 * @attention 确保消息窗口页面初始化过(建议只在回调函数中调用此函数)
 */
bool WouoUI_MsgWinPageSlideUpTxt(MsgWin *mw); //返回值表示能否成功滑动
/**
 * @brief 向下滑动消息窗口文本
 * 
 * @param mw 指向消息窗口的指针
 * @return true 如果成功滑动
 * @return false 如果无法滑动
 * 
 * @attention 确保消息窗口页面初始化过(建议只在回调函数中调用此函数)
 */
bool WouoUI_MsgWinPageSlideDownTxt(MsgWin * mw);
```

为了节省空间，可以使用接口函数不断更换同一个MsgWin对象的content内容，再使用`WouoUI_JumpToPage` 函数进行跳转，参考WouoUI_user.c/.h的做法。

- 默认在MsgWin消息页面中使用上下，可以滚动MsgWin内的消息文本。**所有页面都必须使用对应的初始化函数初始化过，才会绑定对应的方法**。详细可以看看[二次开发](##二次开发(开发自己的页面)) 。

### ConfWin类和接口函数

#### ConfWin页面演示效果

![ValWin_ConfWin](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/ValWin_ConfWin.gif)

这个演示效果也可以看出，**1.0.0版本相比之前更加灵活，支持弹窗的嵌套和跳转**(而且保持了接口一致 也是使用`WouoUI_JumpToPage` 函数就可以😉)

#### ConfWin页面的接口函数

```c
/**
 * @brief 初始化配置窗口页面
 * 
 * @param cw 配置窗口对象指针
 * @param content 页面内容
 * @param str_left 左侧按钮文本(NULl指针输入默认为Yes)
 * @param str_right 右侧按钮文本(NULl指针输入默认为No)
 * @param conf_ret 配置返回值
 * @param auto_get_bg_opt 自动获取背景选项
 * @param auto_set_bg_opt 自动设置背景选项
 * @param move_step 移动步长
 * @param cb 回调函数
 * @attention auto_get_bg_opt 为true,会自动获取背景页面选中项的val和content覆盖conf_ret和content。auto_set_bg_opt同理
 */
void WouoUI_ConfWinPageInit(ConfWin* cw, char* content, char* str_left, char* str_right, bool conf_ret, bool auto_get_bg_opt, bool auto_set_bg_opt, uint16_t move_step, CallBackFunc cb);
/**
 * @brief 向上滑动配置窗口页面文本
 * 
 * @param cw 配置窗口对象指针
 * @return true 成功滑动
 * @return false 失败
 * @attention 确保消息窗口页面初始化过(建议只在回调函数中调用此函数)
 */
bool WouoUI_ConfWinPageSlideUpTxt(ConfWin *cw);

/**
 * @brief 向下滑动配置窗口页面文本
 * 
 * @param cw 配置窗口对象指针
 * @return true 成功滑动
 * @return false 失败
 * @attention 确保消息窗口页面初始化过(建议只在回调函数中调用此函数)
 */
bool WouoUI_ConfWinPageSlideDownTxt(ConfWin *cw);

/**
 * @brief 切换配置窗口页面按钮
 * 
 * @param cw 配置窗口对象指针
 * @attention 确保消息窗口页面初始化过(建议只在回调函数中调用此函数)
 */
void WouoUI_ConfWinPageToggleBtn(ConfWin *cw);
```

- 在ConfWin页面内，默认上下滚动内容文本，左右切换确认按钮。

### ValWin类和接口函数

#### 用于整形数值调整的ValWin页面的演示效果

![ValWin_ConfWin](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/ValWin_ConfWin.gif)

#### ValWin页面的接口函数

```c
/**
 * @brief Valwin页面初始化
 * @param vw Valwin实例指针
 * @param text 显示的文本
 * @param init_val 初始值
 * @param min 最小值
 * @param max 最大值
 * @param step 步进值
 * @param auto_get_bg_opt 自动获取背景选项
 * @param auto_set_bg_opt 自动设置背景选项
 * @param cb 回调函数
 * @attention auto_get_bg_opt 为true会自动获取背景页面选中项的text作为文本，获取val作为init_val, auto_set_bg_opt同理
 */
void WouoUI_ValWinPageInit(ValWin* vw, char* text, int32_t init_val, int32_t min, int32_t max, int32_t step, bool auto_get_bg_opt, bool auto_set_bg_opt, CallBackFunc cb);
/**
 * @brief 设置Valwin页面的最小值、步进值和最大值
 * @param vw Valwin实例指针
 * @param min 最小值
 * @param step 步进值
 * @param max 最大值
 * @attention 确保min<= step <= max，
 */
void WouoUI_ValWinPageSetMinStepMax(ValWin* vw, int32_t min, int32_t step, int32_t max);
/**
 * @brief 增加Valwin页面的当前值
 * @param vw Valwin实例指针
 * @return 增加是否成功
 * @attention 当前值到达最大值时返回false(建议只在回调函数中使用此函数)
 */
bool WouoUI_ValWinPageValIncrease(ValWin *vw);
/**
 * @brief 减少Valwin页面的当前值
 * @param vw Valwin实例指针
 * @return 减少是否成功
 * @attention 当前值到达最小值时返回false(建议只在回调函数中使用此函数)
 */
bool WouoUI_ValWinPageValDecrease(ValWin *vw);
```

- 跟MsgWin一样，如果使用同一个ValWin弹窗用于多个选项的数值调整，记得在跳转弹窗前使用`WouoUI_ValWinPageSetMinStepMax` 设置弹窗页面内能够设置的最小值、最大值和调整步长。0.0版本的时候这三个值是在选项中，现在分离出来了。

### SpinWin类和接口函数

#### 用于浮点数的调整的微调弹窗的演示效果

![SPinWin](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/SPinWin.gif)

#### SpinWin页面的接口函数

```c
/**
 * @brief 设置数值选择窗口的最小值、最大值和小数位数
 * @param spw 指向SpinWin结构体的指针
 * @param min 最小值
 * @param max 最大值
 * @param decnum 小数位数
 * @attention 如果该页面使能自动获取背景页面opt的话，小数位数建议与opt的位数保持一致
 */
void WouoUI_SpinWinPageSetMinMaxDecimalnum(SpinWin *spw, int32_t min, int32_t max, DecimalNum decnum);
/**
 * @brief 初始化数值选择窗口
 * @param spw 指向SpinWin结构体的指针
 * @param text 显示文本
 * @param init_val 初始值
 * @param dec_num 小数位数
 * @param min 最小值
 * @param max 最大值
 * @param auto_get_bg_opt 自动获取背景选项
 * @param auto_set_bg_opt 自动设置背景选项
 * @param cb 回调函数
 * @attention auto_get_bg_opt 为true会自动获取背景页面选中项的text作为文本，获取val作为init_val, 获取opt的小数位数作为dec_num, auto_set_bg_opt同理
 */
void WouoUI_SpinWinPageInit(SpinWin* spw, char* text, int32_t init_val, DecimalNum dec_num, int32_t min, int32_t max, bool auto_get_bg_opt, bool auto_set_bg_opt, CallBackFunc cb);
/**
 * @brief 移动数值选择窗口的选择位
 * @param spw 指向SpinWin结构体的指针
 * @param left0ORright1 移动方向(0表示向左,1表示向右)
 * @attention (建议只在回调函数中使用此函数) 
 */
void WouoUI_SpinWinPageShiftSelbit(SpinWin *spw, bool left0ORright1);
/**
 * @brief 切换数值选择窗口的选择状态
 * @param spw 指向SpinWin结构体的指针
 * @attention (建议只在回调函数中使用此函数)
 */
void WouoUI_SpinWinPageToggleSelState(SpinWin* spw);
/**
 * @brief 改变数值选择窗口当前选择位的值
 * @param spw 指向SpinWin结构体的指针
 * @param Inc1OrDec_1 增加或减少(1表示增加,-1表示减少)
 * @return true 改变成功
 * @return false 改变失败
 * @attention (建议只在回调函数中使用此函数)
 */
bool WouoUI_SpinWinPageChangeSelbit(SpinWin* spw, int32_t Inc1OrDec_1);
```

#### SpinWin页面的注意事项

- 因为在实际调整的时候，只能一位一位调整，所以实际调整时使用的是定点数，`DecimalNum decnum` 表示小数位数，其是枚举类型，如下：(顺便一提，这个也是叻叻菌引入的机制👍)。

  ```c
  typedef enum { //定点数的小数点类型
      DecimalNum_0 = 0x00,
      DecimalNum_1 = 0x01,
      DecimalNum_2 = 0x02,
      DecimalNum_3 = 0x03,
  } DecimalNum;
  ```

- 如果想要将所调整的定点数数值转为浮点数，可以使用这个以下这两个接口函数：

  ```c
  /**
   * @brief 将整数转换为浮点数字符串（通用格式）
   * @param num 要转换的整数
   * @param decimalNum 小数位数
   * @param str 存储结果字符串的缓冲区
   * @return 转换后的字符串
   */
  char *ui_ftoa_g_str(int32_t num, DecimalNum decimalNum, char *str);
  /**
   * @brief 获取选项的浮点值
   * @param option 选项指针
   * @return 选项的浮点值
   */
  float WouoUI_GetOptionFloatVal(Option *option);
  ```

- 需要注意，**因为选项中的自身带有`DecimalNum` 这个成员，因此，`WouoUI_SpinWinPageSetMinMaxDecimalnum` 使用这个函数设置时，最后一个参数最好将Option中的`DecimalNum`成员传入，保持一致。**因为即使开启初始化中`auto_set_bg_opt` 这个选项，也不会改变背景页面选中项的`DecimalNum`成员值，或许之后我可以改一下😂。给出代码位置在下面。

  ![image-20250210183610989](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/image-20250210183610989.png)

  ![image-20250210183728762](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/image-20250210183728762.png)

### ListWin类和接口函数

#### ListWin页面的演示效果

![ListWin](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/ListWin.gif)

#### ListWin页面的接口函数

```c
/**
 * @brief 初始化列表窗口页面
 * @param lw 列表窗口指针
 * @param array_num 字符串数组的数量
 * @param str_array 字符串数组指针 
 * @param auto_set_bg_opt 是否自动设置背景选项
 * @param cb 回调函数指针
 * @attention auto_set_bg_opt 为true会自动将选中项的内容设置到背景页面选中选项的content中，注意，数组大小需要正确传入
 */
void WouoUI_ListWinPageInit(ListWin* lw, uint8_t array_num, String * str_array, bool auto_set_bg_opt, CallBackFunc cb);

/**
 * @brief 移动到列表窗口的上一个项目
 * @param lw 列表窗口指针
 * @attention 确保列表窗口页面初始化过(建议只在回调函数中调用此函数)
 */
void WouoUI_ListWinPageLastItem(ListWin *lw);

/**
 * @brief 移动到列表窗口的下一个项目
 * @param lw 列表窗口指针
 * @attention 确保列表窗口页面初始化过(建议只在回调函数中调用此函数)
 */
void WouoUI_ListWinPageNextItem(ListWin *lw);

```

- ListWin页面需要注意的是，它相比其他弹窗没有`auto_get_bg_opt` 的参数，因为这个页面更多是将选中文本赋值背景页面选中项的Content文本，所以就没有设置`auto_get_bg_opt` 的参数。

## 二次开发(开发自己的页面)

这部分是针对想要二次开发WouoUIPage的人写的，也就是想使用WouoUIPage这个框架做出自己的页面的人准备的，方便理解整体的代码逻辑，如果是单纯使用的话，参考例子和上面的接口说明应该就够了。**(WouoUIPage虽然是基于C开发的，但用的都是面向对象的思想哦🤣)**

**二次开发，建议使用基于EasyX的PC仿真开发，因为支持GDB的断点调试而且环境搭建相当方便简单**(之后出个视频说下这个（留个坑），再次感谢搭建该环境的叻叻菌🙏)

### 关于图形层(WouoUI_graph)

- 图形层中有一个`Canvas` 类，这个类几乎在每个图形层的函数中都是作为第一个参数输入的。**这个`Canvas` 用于控制绘制的边界，绘图函数绘制的点如果超过传入的`Canvas` 的大小，就不会绘制到缓冲区中。**

  ```c
  typedef struct
  {
      int16_t start_x;   // 画布起始点x坐标
      int16_t start_y;   // 画布起始点y坐标
      int16_t w;         // 画布宽度
      int16_t h;         // 画布高度
  } Canvas;
  ```

  可以看到默认的UI对象中就有一个全局的画布。

- 图形层中还维护了两个全局变量(实际上是两个指针，定义和类型如下所示)

  ```c
  #define PEN_COLOR_BLACK  0x00               //写1的点显示为黑色(灭)
  #define PEN_COLOR_WHITE (!PEN_COLOR_BLACK)  //写1的点显示为白色(亮)
  typedef struct
  {
      bool color_mode:1; //颜色模式，正常(|//&)还是异或 normal=0;xor=1;
      bool color:1; //画笔颜色(指前景色，背景色默认与前景色反色)(1白色，0黑色)
      bool rev_color_flag:1; //是否反色绘制标志，0不反色，1反色。
  } Pen;
  
  typedef uint8_t ScreenBuff[WOUOUI_BUFF_HEIGHT_BYTE_NUM][WOUOUI_BUFF_WIDTH];
  typedef void FunSendScreenBuff(ScreenBuff);
  typedef struct 
  {
      ScreenBuff* p_buff; //主缓冲区
  #if HARDWARE_DYNAMIC_REFRESH
      ScreenBuff* p_buff_dynamic; //用于动态刷新的对比缓冲区
  #endif
      FunSendScreenBuff* p_fun_send_buff; //将缓冲区刷新到屏幕上的函数指针
  } Screen;
  static Screen cur_screen; //当前操作的屏幕对象，是个指针集合(所以没有必要使用指针)
  static Pen* p_cur_pen; //当前画笔的指针
  ```
  
  `Pen` 保存着当前绘制的方式(字节以什么方式写入缓冲区&、|还是^)；
  
  `Screen` 本身就是三个指针组成的，缓冲区数组的指针，硬件动态刷新用于对比的缓冲区数组的指针(如果使能硬件动态刷新的话)，还有屏幕刷新函数的指针。

### 关于UI层

- `PageAddr` 页面地址变量，其实是一个 `void*` 类型，为了用于实现 `OLED_UIJumpToPage` 函数的 "伪多态"。(其实内部所有页面的方法都使用这样的**伪多态**) 。

  在获取页面地址后，直接强转为 `Page` 类，这是一个所有页面类型都必须包含的结构体成员(且必须是第一个，为了方便转换类型)。`Page` 类中包含了所有页面必须有的一些成员，如下：

  ```c
  // 每个页面基本方法的定义
  typedef bool (*PageIn)(PageAddr);  // 进入页面的过度动画函数(返回值为True表示这个状态已经可以结束了，切换下一个状态)
  typedef void (*PageInParaInit)(PageAddr);  // 进入页面过度动画参数初始化函数
  typedef void (*PageShow)(PageAddr); // 页面的展示函数
  typedef bool (*PageReact)(PageAddr); // 页面的响应函数(返回值为True表示这个状态已经可以结束了，切换下一个状态)
  typedef void (*PageIndicatorCtrl)(PageAddr); // 页面与UI指示器交互的控制函数
  typedef void (*PageScrollBarCtrl)(PageAddr); // 页面与UI滚动条交互的控制函数
  typedef struct
  {
      PageIn in; // 进入页面的过度动画函数
      PageInParaInit in_para_init; // 进入页面过度动画参数初始化函数
      PageShow show; // 页面的展示函数
      PageReact react; // 页面的响应函数
      PageIndicatorCtrl indicator_ctrl; // 页面与UI指示器交互的控制函数
      PageScrollBarCtrl scrollbar_ctrl; // 页面与UI滚动条交互的控制函数
  } PageMethods; // 方法集合
  struct _page {
      PageType page_type; // 页面类型，以便在处理时调用不同函数绘制
      PageAddr last_page; // 上级页面的地址
      CallBackFunc cb;    // 页面的回调函数
      PageMethods* methods; // 页面方法集合的指针，其实例在UI对象上
      bool auto_deal_with_msg ; //页面是否会自动处理消息,默认会,如果置False,需要自己在回调函数中调用提供的接口进行页面操作
  }; // 最基本的页面类型(所有页面类型的基类和结构体的**第一个成员**)
  ```

- WouoUI中维护了三个全局变量

  >`g_default_ui_para` 默认UI参数
  >
  >`default_ui` **默认UI对象(包含所有页面的类变量、方法实例和指示器、进度条、输入消息队列等等的实例)**
  >
  >`p_cur_ui` **当前UI的指针，在page和win页面中需要引用到类变量的，都是通过该指针。**
  
- WouoUIPage的状态机(最新版本1.0.0版将页面状态机和弹窗状态机做了融合，支持任意页面的弹窗调用，毕竟弹窗只是作为特殊的页面存在😀)。

  ![WouoUI状态机](https://sheep-photo.oss-cn-shenzhen.aliyuncs.com/img/WouoUI%E7%8A%B6%E6%80%81%E6%9C%BA.png)

### 全页面开发

打开`WouoUI_page.c/.h` 可以看到，每个全页面的开发都遵循着一样的流程。

#### WouoUI_page.h头文件

首先是`WouoUI_page.h` 中会定义每个页面需要的宏定义、类型声明和接口函数声明，这三部分需要有以下的注意事项。

1. 类型声明至少需要两个类型声明，

   - 一个是页面的类型(结构体)主要存放每个页面独有的数据，个人的命名习惯是`xxPage`(驼峰法)
   - 另一个是页面的类变量的结构体，存在这个页面共用的变量，像滑动字符串，非线性运动的坐标等等，个人的命名习惯是`xxPageVar`(驼峰法)。类变量的使用主要是为了减轻拓展大量页面时的内存占用。
   - 类变量的实例在WouoUI这个对象中实现，所以，声明了页面的类变量后记得在WouoUI对象中加入该成员。

2. 页面类型声明中必须包含一个类型为`Page` 的成员，而且该成员必须是这个结构体的第一个成员。以ListPage举例如下：

   ```c
   //ListPage页面类
   typedef struct ListPage {     // 列表页面
       Page page;                // 基础页面信息
       PageSetting page_setting; // 页面设置
       uint8_t item_num;         // 页面选项个数，title和icon个数需与此一致
       uint8_t select_item;      // 选中选项
       Option *option_array;     // 选项类型的数组(由于数组大小不确定，使用指针代替)
       uint8_t line_n;           // = DISP_H / LIST_LINE_H; 屏幕内有多少行选
       int16_t ind_y_tgt;        // 存储指示器y目标坐标
   } ListPage;                   // 列表页面类型(所有类型页面，类型成员为第一个，方便查看)
   ```

   `Page` 这个基类的成员请看上面的[关于UI层](### 关于UI层)

   需要注意到的是，`Page` 这个基类中绑定了一个结构体指针，结构体内有6个函数指针，是页面对应的处理方法(具体每个方法需要实现什么内容，在下面说明)

3. 每个页面的方法，即对应的PageMethods同样是实例化在WouoUI对象中的，以ListPage举例，可以看到WouoUI声明中，有

   ```c
   // WouoUI类型，整个UI类型
   typedef struct WouoUI {
   ......//省略了一部分
       struct TitlePageVar tp_var; // TitlePage共用变量集合
       PageMethods tp_mth;         // TitlePage的方法集合
       struct ListPageVar lp_var;  // List页面的共用变量集合
       PageMethods lp_mth;         // List页面的方法集合
       struct WavePageVar wt_var;  // 波形显示区域的共用变量集合
       PageMethods wt_mth;         // 波形显示区域的方法集合
       struct MsgWinVar mw_var;    // 消息弹窗共用变量集合
       PageMethods mw_mth;         // 消息弹窗方法集合
       struct ConfWinVar cw_var;   //确认弹窗的共用变量集合
       PageMethods cw_mth;         //确认弹窗的方法集合
   ..... //省略了一部分                                                                         //可以在这儿声明自己页面的类变量和对应方法   
   } WouoUI;
   ```

   可以看到，每种页面都有自己的类变量和方法结构体在WouoUI这个类中，当定义WouoUI对象时，就完成了这些类变量和方法的实例化(这些方法当然需要绑定函数，下方有说明)。

#### WouoUI_Page.c实现文件

一个全页面的实现，也需要遵从以下的注意事项

1. 6个方法的实现，自己的命名习惯是 `WouoUI_xxPageIn`  、`WouoUI_xxPageInParaInit` ......6个方法分别要实现的内容如下：

   >`In` ：进入页面的过度动画的绘制(对全页面来说，这个方法会在ui_page_in这个状态中循环执行，直至这个方法返回true,表示进入动画完成)。
   >
   >`InParaInit` : 进入动画的参数的初始化，像非线性动画的起始位置赋值就是在这个函数完成（对全页面来说，这个方法在ui_page_out这个状态中，判断页面渐隐完成后会执行一次，执行完就会切换为ui_page_in状态）。
   >
   >`Show`：主要的展示动画，和页面内对msg的响应动画
   >
   >`React`：页面对输入消息msg的处理，并调用回调函数。这个会判断每个的`auto_deal_with_msg` 标志，决定处理方式，不过二次开发可以不用管这个，如果兼容WouoUIPage的开发方式的，请参考其他页面那样根据标志位处理就可以。
   >
   >上面`show` 和`React` 函数都是ui_page_proc这个状态中循环执行的，直至`React`函数返回true表示页面退出，或者回调函数中调用了`WouoUI_JumpToPage` 函数切换页面。
   >
   >`IndicatorCtrl` : 指示器处理函数，用于处理ui对象中在不同页面中连贯的指示器，就是一直在页面上飘的那个小方块，这个方法是独立在状态机外运行的(可以近似是并行)。以`ListPage` 的指示器交互方法为例：(通过p_cur_ui当前ui指针，修改指示器运动位置，然后进行指示器的绘制)。
   >
   >```c
   >void WouoUI_ListPageIndicatorCtrl(PageAddr page_addr)
   >{
   >    ListPage *lp = (ListPage *)page_addr;
   >    // indicator
   >    p_cur_ui->indicator.x.pos_tgt = 0;
   >    p_cur_ui->indicator.y.pos_tgt = lp->ind_y_tgt;
   >    p_cur_ui->indicator.w.pos_tgt = p_cur_ui->lp_var.indicator_w_temp;
   >    p_cur_ui->indicator.h.pos_tgt = LIST_LINE_H;
   >    WouoUI_GraphSetPenColor(2); // 反色绘制
   >    WouoUI_CanvasDrawRBox(&(p_cur_ui->w_all), p_cur_ui->indicator.x.pos_cur, p_cur_ui->indicator.y.pos_cur,
   >                             p_cur_ui->indicator.w.pos_cur, p_cur_ui->indicator.h.pos_cur, LIST_IND_BOX_R);
   >    WouoUI_GraphSetPenColor(1); // 恢复实色绘制
   >}
   >```
   >
   >`ScrollBarCtrl` : 这个主要是针对有进度条的函数做页面间的进度条连贯，与指示器处理一致，可以认为是和主状态机并行的。不需要的页面可以不实现。

2.  这些方法函数的声明，建议声明在`WouoUI_page.c` 最上面的位置，因为这些方法只需要在WouoUI对象初始化时赋值给WouoUI中对应页面的方法集合即可，不需要也尽量不要让使用者调用。这里以TitlePage为例，在`WouoUI.c`中有(不以ListPage为例是因为，TitlePage没有`ScrollBarCtrl`的方法，可以说明特殊情况)

   ```c
   // 静态函数声明(方便全局变量初始化函数指针)
   //从page文件引入函数的声明，以保证这些函数不会被外部使用
   // TitlePage 的类方法
   void WouoUI_TitlePageInParaInit(PageAddr page_addr);
   bool WouoUI_TitlePageIn(PageAddr page_addr);
   void WouoUI_TitlePageShow(PageAddr page_addr);
   void WouoUI_TitlePageIndicatorCtrl(PageAddr page_addr);
   bool WouoUI_TitlePageReact(PageAddr page_addr);
   ....//省略一部分代码
   // 默认UI对象（同时进行初始化）
   WouoUI default_ui = {
   ....//省略一部分代码
       //注意每个方法都需要初始化，因为调用前没有NULL检查
       .tp_var = {
           .title_ss = {
               .slide_mode = (SlideStrMode)TILE_SLIDESTR_MODE,
               .canvas = {.w = WOUOUI_BUFF_WIDTH - TILE_BAR_W,},
           },
       },
       .tp_mth = {
           .in = WouoUI_TitlePageIn,
           .in_para_init = WouoUI_TitlePageInParaInit,
           .show = WouoUI_TitlePageShow,
           .react = WouoUI_TitlePageReact,
           .indicator_ctrl = WouoUI_TitlePageIndicatorCtrl,
           .scrollbar_ctrl = WouoUI_FuncDoNothing,
       },
       .lp_var = {
           .radio_click_flag = false,
           .opt_text_ss = {.slide_mode = (SlideStrMode)LIST_TXT_SLIDESTR_MODE,},
           .opt_val_ss = {.slide_mode = (SlideStrMode)LIST_VAL_SLIDESTR_MODE,},
       },
       .lp_mth = {
           .in = WouoUI_ListPageIn,
           .in_para_init = WouoUI_ListPageInParaInit,
           .show = WouoUI_ListPageShow,
           .react = WouoUI_ListPageReact,
           .indicator_ctrl = WouoUI_ListPageIndicatorCtrl,
           .scrollbar_ctrl = WouoUI_ListPageScrollBarCtrl,
       },
   ..... //省略一部分代码
   };
   ```

   可以看到，这里将对应的方法函数赋值给了WouoUI对象中对应的方法集合结构体中，如果没有对应的方法，可以使用下面两个函数进入赋值。

   ```c
   //空函数用于赋值一些页面不需要的方法，防止调用到NULL,这样调用时可以不用考虑NULL指针检查
   void WouoUI_FuncDoNothing(PageAddr page_addr){UNUSED_PARAMETER(page_addr);}
   bool WouoUI_FuncDoNothingRetTrue(PageAddr page_addr){UNUSED_PARAMETER(page_addr);return true;}
   ```

3. 实现一个页面的初始化方法，个人的命名习惯是 `WouoUI_xxPageInit()` 

   这个方法内必须要有的部分是

   - 页面类型的赋值
   - 通用页面的初始化
   - 页面类方法的绑定

   同样以`ListPage` 页面为例

   ```c
   void WouoUI_ListPageInit(    
       ListPage *lp,             // 列表页面对象
       uint8_t item_num,         // 选项个数，
       Option *option_array,     // 整个页面的选项数组(数组大小需与item_num一致)
       PageSetting page_setting, // 页面设置
       CallBackFunc call_back    // 回调函数，参数为确认选中项index（1-256）0表示未确认哪个选项)
   ){
   ...//省略一部分代码
       lp->page.page_type = type_list;  //赋值页面类型
       WouoUI_PageInit((PageAddr)lp, call_back); //基本页面的初始化，完成回调函数的绑定
       lp->page.methods = &(p_cur_ui->lp_mth); //绑定该页面的方法集合
   ...//省略一部分代码
   }
   ```

   其中，`page_type`是`page` 的一个枚举类型的成员，如果实现自己的一个页面，也需要添加一个新的枚举成员，该类型是0.0版本中留下来的，现在这个版本中用于判断页面是否经初始化和是全页面类型还是弹窗页面类型。在`WouoUI_Page.h` 中有如下代码：

   ```c
   //--------页面类型枚举
   typedef enum {
       type_none = 0x00,   //非页面类型,用于在jump函数判断一个页面是否经过初始化,如果没有,则没有绑定过方法,避免状态机访问方法报错
       type_title,         // 磁贴类
       type_list,         // 列表类
       type_wave,         // 波形类
       type_sep,         // 类型分割线，以上是全页面类型，以下是弹窗页面类型
       type_slidevalwin, // 滑动数值弹窗
       type_msgwin,      // 消息弹窗
       type_confwin,      // 确认弹窗
       type_spinwin,      // 微调数值弹窗
       type_listwin,      // 列表弹窗
   } PageType;            // 页面类型，用于标志传入的每个页面类型，方便调用对应的proc函数
   .......//省略了一部分代码
   #define WouoUI_CheckPageType(page_addr) (((Page *)page_addr)->page_type)
   #define WouoUI_CheckPageTypeisWin(page_addr) ((uint8_t)WouoUI_CheckPageType(page_addr) > type_sep)
   #define WouoUI_CheckPageIsInit(page_addr) (type_none != WouoUI_CheckPageType(page_addr))
   ```

### 弹窗页面开发

#### 弹窗页面开发与全页面开发的异同

弹窗页面也是一种特殊的页面，因此，**需要实现的方法和注意事项和全页面基本一致**

需要注意的弹窗页面在状态机中运行时与全页面不同。因此需要注意，在`show` 方法函数中，需要多一个背景页面的绘制。以下以`MsgWin` 为例：

```c
void WouoUI_MsgWinPageShow(PageAddr page_addr) // 页面的展示函数
{
    MsgWin * mw = (MsgWin*)page_addr;
    Page * bg = (Page*)(((Page*)page_addr)->last_page);
    //绘制背景和清出弹窗需要的白色窗口都是每个弹窗页面需要的，不过清空白色窗口背景的大小各个弹窗并不相同
    bg->methods->show(bg); //先绘制背景
    WouoUI_GraphSetPenColor(PEN_COLOR_BLACK);
    WouoUI_BuffAllBlur(p_cur_ui->win_bg_blur); //背景虚化
    WouoUI_CanvasDrawRBox(&(p_cur_ui->w_all), p_cur_ui->indicator.x.pos_cur, p_cur_ui->indicator.y.pos_cur,
                              p_cur_ui->indicator.w.pos_cur, p_cur_ui->indicator.h.pos_cur, MSG_WIN_R); //清空出白色窗口背景
    WouoUI_GraphSetPenColor(PEN_COLOR_WHITE);
    //MsgWin自己的动画设置和页面元素绘制
    p_cur_ui->mw_var.canvas.start_x = p_cur_ui->indicator.x.pos_cur + MSG_WIN_FONT_MARGIN;
    p_cur_ui->mw_var.canvas.start_y = p_cur_ui->indicator.y.pos_cur + MSG_WIN_FONT_MARGIN;
    p_cur_ui->mw_var.canvas.h = p_cur_ui->indicator.h.pos_cur - 2*MSG_WIN_FONT_MARGIN;
    p_cur_ui->mw_var.canvas.w = p_cur_ui->indicator.w.pos_cur - 2*MSG_WIN_FONT_MARGIN;
    if(NULL != mw->content)
        WouoUI_CanvasDrawStrAutoNewline(&(p_cur_ui->mw_var.canvas),0,mw->str_start_y,MSG_WIN_FONT,(uint8_t*)mw->content);
}
```

除此以外，弹窗页面类型的枚举变量需要大于`type_sep` 因为是以这个枚举类型的大小判断是否为弹窗页面类型的。

### 关于页面跳转

在WouoUIPage中不同页面间的链接，类似链表，链表的连接在`WouoUI_JumpToPage` 中实现。如下：

```c
/**
 * @brief 跳转到指定页面(用于关联确认上下级页面关系)
 *
 * @param self_page 当前页面对象的地址 
 * @param terminate_page 目标页面地址
  */
void WouoUI_JumpToPage(PageAddr self_page_addr, PageAddr terminate_page) {
    // 关联上级页面并跳转页面
    if (terminate_page != NULL) {
        if(WouoUI_CheckPageIsInit(terminate_page)){ //检查页面是否初始化过
            Page *p_ter = (Page *)terminate_page;
            p_ter->last_page = self_page_addr; //给要跳转的页面绑定上级页面
            p_cur_ui->in_page = terminate_page;// 暂存要跳转的页面，等待渐隐结束赋值给cur_page跳转
            if(WouoUI_CheckPageTypeisWin(terminate_page)){ //如果要跳转的页面是弹窗的话
                PAGE_USE_METHOD(p_cur_ui->in_page, in_para_init); //弹窗in动画目标参数初始化
                WouoUI_BlurParaInit(p_cur_ui->win_bg_blur,p_cur_ui->upara->ani_param[FADE_ANI]); //渐隐参数初始化(是弹窗的话上一个页面只消失一半)
                p_cur_ui->state = ui_page_in;     // 弹窗页面在in渐隐中同时做in动画
            }
            else {
                WouoUI_BlurParaInit(4,p_cur_ui->upara->ani_param[FADE_ANI]); //渐隐参数初始化(不是弹窗的话上一个页面完全消失)
                p_cur_ui->state = ui_page_out;     // 改变页面，启动渐隐
            }
        }else {
            WOUOUI_LOG_E("The Page will jump is not inited!!");
        }
    }
}
```

其中涉及p_cur_ui中的三个页面指针，在这里做个简单说明：

>`home_page` 主页面指针，默认第一个页面初始化页面的地址会赋值给这个指针，没有使用Jump函数确认页面上下级关系时，使用`WouoUI_PageInit`初始化后的页面默认的上级页面就是这个页面。
>
>`current_page` 当前页面指针，指向当前正在展示的页面，在状态机处于ui_proc_in和ui_proc_out 过程中指向切换前的页面
>
>`in_page` 要进入的页面指针，在状态机处于ui_proc_in和ui_proc_out 过程中指向将要切换的页面

## 项目维护

### 项目版本更新的说明
- 0.1.0版 稳定的版本有在两个硬件上移植测试过的版本；

- 0.1.1版 
  - 将全局数组去掉，改为指针连接上级页面，支持理论上无限多个页面，不再受数组大小的限制。
  - UI文件中的变量整理归类，使代码体积占用更小(会在下一个大版本中给出具体的代码内存占用数据)。
  - 修复在弹窗时页面跳转的bug。

- 1.0.0版

  - **适配多尺寸屏幕**，可以通过WouoUI_conf.h中的宽长的宏定义更改屏幕宽长，所有页面的元素都会自动居中
  - **字体自适应**，同样在WouoUI_conf.h中的修改页面使用的字体，页面会自适应字体的宽高
  - **长文本自动滚动**，长文本在选中时会自动滚动，同时滚动模式、速度和起始延时都有参数可以调整
  - **基于anim、slide动画监视的软件动态刷新**，相比硬件buff对比动态刷新：

  - 软件刷新：基于动画监视，静止时完全停止状态机，只会轮询msg输入，通用性不如硬件动态刷新。
  - 硬件刷新：基于buff对比，通用性强，但需要多一个buff作为对比，同时静止时，内部buff的clear和重新写入一直在运行，只是没有将buff发送

  - 主状态机优化，将弹窗抽象为页面(弹窗状态机和页面状态机融合)，支**持任意页面的弹窗调用和弹窗自身的嵌套调用**
  - 修改了回调函数类型，回调函数会将该页面msg传入，方便使用者进行更灵活的开发，且所有页面回调函数调用机制统一——**只要有该页面有msg输入就会调用**.
  - 宏参数检查和LOG提示

### 项目长期的改进需求

目前项目有以下的改进需求，会逐步展开😶。

- [x] ~~PC电脑端的测试环境，方便编写UI进行代码测试。（已完成，在ProjectExamples下有使用例子）~~
- [x] ~~添加sleep的运行状态，在没有消息传入时不会一直刷新页面占用CPU。~~
- [x] ~~适配多种大小的单色屏小屏幕（200*200px以上的大屏幕不在我想支持的范围内，因为对于这类屏幕有更合适的UI），支持文字过长时的自适应滚动。~~
- [ ] 支持中文，能够以方便的方式设置UI的字体，同时不会产生太大的内存占用（这个其实只要简单改下`WouoUI_graph.c`中的`WouoUI_CanvasDrawStr` 函数就可以了，叻叻菌也留下了中文字体结构体的接口在`WouoUI_font.c/h` 中，不过我在考虑的是如何处理中文字体的接口不产生太大的内存占用）。
- [ ] 编写C++的版本(毕竟都面向对象编程了😆)，可以用于Arduino。

### 其他
- 如果这个项目对你有帮助的话，别忘了给这个仓库点一个⭐，并推荐给他人😉
- 如果通过二次开发了自己的页面，可以提交一个PR到这个仓库🧐
- 如果将WouoUIPage移植到除了仓库中提及的其他硬件平台上，也可以将对应的工程压缩包上传至这个仓库中的`HardwareTestingDevice` 并提交一个PR嘞🧐