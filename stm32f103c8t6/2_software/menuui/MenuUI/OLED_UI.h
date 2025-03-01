#ifndef __OLED_UI_H
#define __OLED_UI_H
// 检测是否是C++编译器
#ifdef __cplusplus
extern "C" {
#endif
/*如果需要使用OLED_UI库，请不要将此行注释掉 */
#define OLED_UI

#ifdef OLED_UI

#include "OLED_UI_Driver.h"
#include "OLED.h"
#include "stdint.h"
#include "stdbool.h"

// 显存缓存区
extern uint8_t OLED_DisplayBuf[OLED_HEIGHT / 8][OLED_WIDTH];

/*用户可以配置的宏定义*/

// /*关于列表类菜单项开始点相对于菜单区域的位置的宏*/
// #define LIST_STARTPOINT_X				  (4)			//菜单项开始点相对于菜单区域的X坐标
// #define LIST_STARTPOINT_Y				  (2)			//菜单项开始点相对于菜单区域的Y坐标

/*关于磁贴类菜单项开始点相对屏幕顶部位置的宏*/
#define TILES_STARTPOINT_Y (6)  // 磁贴类菜单项开始点相对于屏幕顶部的Y坐标

/*关于磁贴类菜单项的滚动条开始点相对磁贴底部位置的宏*/
#define TILES_SCROLLBAR_Y (5)  // 磁贴类菜单项开始点相对于屏幕顶部的Y坐标

/*关于磁贴类菜单项文字距离屏幕底部的距离的宏*/
#define TILES_BOTTOM_DISTANCE (0)  // 磁贴类菜单项文字距离屏幕底部的距离

/*关于菜单项横向滚动速度的宏*/
// 当菜单项长度超过菜单区域宽度时，本ui框架会自动实现菜单项的横向滚动显示，这是菜单项横向滚动步长（每一帧滚动的像素距离）
#define LINE_SLIP_SPEED (0.5)  // 菜单项横向滚动速度【可以是小数，但是最好是1的整数倍或者1的偶数分之一倍】

/*关于菜单项前缀符号的宏*/

#define FUNCTION_PREFIX     "~"  // 函数前缀符号
#define SUBMENU_PREFIX      ">"  // 菜单前缀符号
#define RADIO_PREFIX        "*"  // 单选框前缀符号
#define NONE_PREFIX         "-"  // 无操作前缀符号

#define LINEPERFIX_DISTANCE (2)  // 行前缀符号与后方文字的距离

/*关于是否等待动画加载完毕再滚动长文本的宏*/

#define IF_WAIT_ANIMATION_FINISH (true)

/*关于长按按键的宏*/
#define IF_START_UP_AND_DOWN_LONG_PRESS (true)  // 是否开启上按键与下按键的长按功能
#define PRESS_TIME                      (0.8)   // 按下按键视为长按的时间（单位秒）
#define CONTINUE_PRESS_TIME             (2)     // 在长按0.8秒之后继续长按的时间（单位秒）
#define PRESS_MOVE_SPEED                (10)    // 长按按键之后选项滚动的速度，1为最快，数字越大越慢。
#define CONTINUE_PRESS_MOVE_SPEED       (1)     // 长按按键之后继续长按CONTINUE_PRESS_TIME秒后选项滚动的速度，1为最快，数字越大越慢。

/*关于窗口文字与数据之间距离的宏*/
#define WINDOW_DATA_TEXT_DISTANCE (4)

/*关于淡出每帧的时间的宏*/
#define FADEOUT_TIME (40)  // 菜单项淡出每帧的时间

/*用户无需配置的宏定义【以下宏定义不要改动】*/

/*有关光标类型的宏*/
#define REVERSE_RECTANGLE      (0)  // 矩形反色
#define REVERSE_ROUNDRECTANGLE (1)  // 圆角矩形反色
#define HOLLOW_RECTANGLE       (2)  // 空心矩形
#define HOLLOW_ROUNDRECTANGLE  (3)  // 空心圆角矩形
#define REVERSE_BLOCK          (4)  // 下划线
#define NOT_SHOW               (5)  // 不显示光标

/*关于UI字体大小的宏*/
#define OLED_UI_FONT_8  (8)
#define OLED_UI_FONT_12 (12)
#define OLED_UI_FONT_16 (16)
#define OLED_UI_FONT_20 (20)

#define CHINESE         (0)  // 中文
#define ASCII           (1)  // ASCII
/*关于显示模式的宏*/
#define DARKMODE  true   // 深色模式
#define LIGHTMODE false  // 浅色模式

/*关于互斥锁或者标志位的宏*/
#define FLAGEND         (0)
#define FLAGSTART       (1)
#define ENTER_FLAGSTART (1)
#define BACK_FLAGSTART  (2)

/*关于菜单结构体当中关于菜单区域的宏*/
#define FULLSCREEN 1, 1, OLED_WIDTH - 2, OLED_HEIGHT - 2

/*关于确认返回的宏* */
#define OLED_UI_BACK  (0)
#define OLED_UI_ENTER (1)

/*关于菜单类型的宏* */
#define MENU_TYPE_LIST  (0)  // 列表类型
#define MENU_TYPE_TILES (1)  // 磁贴类型

/*关于动画类型的宏* */
#define UNLINEAR  (0)
#define PID_CURVE (1)

/*关于窗口类型的宏* */
#define WINDOW_RECTANGLE      (0)  // 矩形窗口
#define WINDOW_ROUNDRECTANGLE (1)  // 圆角矩形窗口

/*关于窗口数据类型的宏* */
#define WINDOW_DATA_STYLE_NONE  (-1)  // 空
#define WINDOW_DATA_STYLE_FLOAT (0)   // 浮点型数据
#define WINDOW_DATA_STYLE_INT   (1)   // 整型数据

/*宏定义*/

/*表示菜单类型的数据结构*/
typedef int8_t MenuStyle;

/*表示菜单ID的数据结构*/
typedef int16_t MenuID;

/*表示菜单ID的数据结构*/
typedef float MenuMovingSpeed;

/*表示菜单ID的数据结构*/
typedef int8_t OLED_Font;

/*表示互斥锁或标志位的数据结构，只有两种状态FLAGSTART与FLAGEND*/
typedef int8_t MutexFlag;

/*菜单id结构体，存储着经过限制的菜单id和不经过限制的菜单id*/
typedef struct MenuID_Type {
    MenuID Safe;
    MenuID Unsafe;
} MenuID_Type;

/*OLED_UI当中有点坐标的结构体*/
typedef struct OLED_Point {
    float X;
    float Y;
} OLED_Point;

/*OLED_UI当中有关位置与大小的结构体*/
typedef struct OLED_Area {
    float X;
    float Y;
    float Width;
    float Height;
} OLED_Area;

/*OLED_UI当中用于存放按键阵列数据的结构体*/
typedef struct OLED_Key {
    uint8_t Enter;  // 确认键
    uint8_t Back;   // 返回键
    uint8_t Up;     // 上
    uint8_t Down;   // 下
} OLED_Key;

/*OLED_UI当中存放光标信息的结构体【用于制造光标移动效果】 */
typedef struct OLED_ChangeArea {
    OLED_Area CurrentArea;  // 当前光标区域
    OLED_Area TargetArea;   // 目标光标区域
    OLED_Area Error;        // 误差值
    OLED_Area LastError;    // 上一次的误差值
    OLED_Area Integral;     // 积分值
    OLED_Area Derivative;   // 微分值

} OLED_ChangeArea;

typedef struct OLED_ChangePoint {
    OLED_Point CurrentPoint;  // 当前点坐标
    OLED_Point TargetPoint;   // 目标点坐标
    OLED_Point Error;         // 误差值
    OLED_Point LastError;     // 上一次的误差值
    OLED_Point Integral;      // 积分值
    OLED_Point Derivative;    // 微分值

} OLED_ChangePoint;

/*
 * @brief 此结构体用于计算动画,需要包含关于非线性，pid等的参数。
 *  @param CurrentDistance 当前值
 *  @param TargetDistance 目标值
 *  @param Error 误差值
 *  @param LastError 上一次的误差值
 *  @param Integral 积分值
 *  @param Derivative 微分值
 *  */
typedef struct OLED_ChangeDistance {
    float CurrentDistance;  // 当前值
    float TargetDistance;   // 目标值
    float Error;            // 误差值
    float LastError;        // 上一次的误差值
    float Integral;         // 积分值
    float Derivative;       // 微分值

} OLED_ChangeDistance;

/*OLED_UI当中存放计数器信息的结构体*/
typedef struct OLED_UI_Counter {
    int16_t count;
    int16_t value;
    int16_t step;
} OLED_UI_Counter;

/*OLED_UI当中用于实现窗口停留的结构体*/
typedef struct OLED_UI_WindowSustainCounter {
    int16_t count;        // 计数器
    bool    SustainFlag;  // 标志位，用于表示是否处于停留状态
} OLED_UI_WindowSustainCounter;

/*OLED_UI当中菜单窗口的结构体*/
typedef struct MenuWindow {
    int16_t General_Width;         //[通用属性]窗口宽度
    int16_t General_Height;        //[通用属性]窗口高度
    float   General_ContinueTime;  //[通用属性]窗口停留时间
    uint8_t General_WindowType;    //[通用属性]窗口类型

    char*     Text_String;            //[文本属性]窗口显示的文字
    OLED_Font Text_FontSize;          //[文本属性]窗口字体大小
    int16_t   Text_FontSideDistance;  //[文本属性]字体距离左侧的距离
    int16_t   Text_FontTopDistance;   //[文本属性]字体距离顶部的距离

    float*   Prob_Data_Float;      //[进度条属性]窗口数据指针(浮点类型)【二选一】
    int16_t* Prob_Data_Int;        //[进度条属性]窗口数据指针(int16_t整型类型)【二选一】
    float    Prob_DataStep;        //[进度条属性]窗口数据步长
    float    Prob_MinData;         //[进度条属性]窗口数据的最小值
    float    Prob_MaxData;         //[进度条属性]窗口数据的最大值
    int16_t  Prob_BottomDistance;  //[进度条属性]进度条底部距离窗口底部的距离
    int16_t  Prob_SideDistance;    //[进度条属性]进度条边缘距离窗口边缘的距离
    int16_t  Prob_LineHeight;      //[进度条属性]进度条线条高度

    float _LineSlip;  //[私有属性]用于滚动显示长文本
} MenuWindow;

/*OLED_UI当中菜单项的结构体，用于存放菜单项的相关信息，
包括名称，字体大小，回调函数，子菜单指针，父菜单指针，开始点，选中区域，是否活跃状态，是否是最后一个菜单项*/
typedef struct MenuPage {
    MenuStyle        General_MenuType;
    MenuMovingSpeed  General_MovingSpeed;
    uint8_t          General_CursorStyle;
    uint8_t          General_MoveStyle;
    OLED_Font        General_FontSize;
    struct MenuPage* General_ParentMenuPage;
    struct MenuItem* General_MenuItems;
    int16_t          General_LineSpace;
    void (*General_ShowAuxiliaryFunction)(void);

    OLED_Area List_MenuArea;
    bool      List_IfDrawFrame;
    bool      List_IfDrawLinePerfix;
    int16_t   List_StartPointX;
    int16_t   List_StartPointY;

    int16_t Tiles_ScreenWidth;
    int16_t Tiles_ScreenHeight;
    int16_t Tiles_TileWidth;
    int16_t Tiles_TileHeight;

    MenuID     _ActiveMenuID;
    MenuID     _Slot;
    OLED_Point _StartPoint;
} MenuPage;

typedef struct MenuItem {
    char* General_item_text;
    void (*General_callback)(void);
    MenuPage* General_SubMenuPage;

    bool*          List_BoolRadioBox;
    const uint8_t* Tiles_Icon;

    float _LineSlip;
} MenuItem;

void        GetFPS(void);
void        OLED_UI_ShowFPS(void);
OLED_Font   GetOLED_Font(OLED_Font fontsize, bool style);
void        ReverseCoordinate(int16_t X, int16_t Y, int16_t Width, int16_t Height, uint8_t Style);
void        OLED_UI_FadeOut_Masking(int16_t x0, int16_t y0, int16_t width, int16_t height, int8_t fadeLevel);
void        OLED_UI_FadeoutCurrentArea(int16_t x, int16_t y, int16_t width, int16_t height);
void        OLED_UI_FadeoutAllArea(void);
MenuID      GetMenuItemNum(MenuItem* items);
void        ChangeFloatNum(float* CurrentNum, float* TargetNum, float* ErrorNum, float* LastErrorNum, float* IntegralNum, float* DerivativeNum);
void        ChangeDistance(OLED_ChangeDistance* distance);
void        ChangePoint(OLED_ChangePoint* point);
void        ChangeArea(OLED_ChangeArea* area);
void        CurrentMenuPageInit(void);
void        CurrentMenuPageBackUp(void);
void        OLED_UI_Init(MenuPage* Page);
bool        GetEnterFlag(void);
bool        GetFadeoutFlag(void);
int16_t     CalcStringWidth(int16_t ChineseFont, int16_t ASCIIFont, const char* format, ...);
int8_t      GetWindowDataStyle(int16_t* int16_tdata, float* float_tdata);
void        OLED_DrawWindow(void);
void        MenuItemsMoveUp(void);
void        MenuItemsMoveDown(void);
void        MenuItemsMoveLeft(void);
void        MenuItemsMoveRight(void);
int16_t     GetCurrentMenuPageMaxSlotNum(void);
void        SetTargetCursor(void);
void        SetTargetMenuFrame(void);
void        SetLineSplitZero(void);
void        SetTargetScrollBarHeight(void);
void        SetTargetProbWidth(void);
void        DrawLinePermix(MenuPage* page, MenuID i, OLED_Point* CursorPoint, OLED_Font ChineseFont, OLED_Font ASCIIFont);
void        PrintMenuElements(void);
MenuID_Type OLED_KeyAndEncoderRecord(void);
void        SetEnterFlag(void);
void        ResetEnterFlag(void);
void        SetFadeOutFlag(MutexFlag action);
void        ResetFadeOutFlag(void);
void        EnterEventMenuItem(void);
void        BackEventMenuItem(void);
void        OLED_UI_Back(void);
void        RunCurrentCallBackFunction(void);
void        SetCursorZero(void);
void        OLED_UI_CreateWindow(MenuWindow* window);
void        RunFadeOut(void);
void        MoveMenuElements(void);
void        OLED_UI_MainLoop(void);
void        OLED_UI_InterruptHandler(void);

// 改变函数
void ChangeDistance(OLED_ChangeDistance* distance);
void ChangePoint(OLED_ChangePoint* point);
void ChangeArea(OLED_ChangeArea* area);

// 将指定区域的元素渐隐
void OLED_UI_FadeoutCurrentArea(int16_t x, int16_t y, int16_t width, int16_t height);

// 全屏渐隐
void OLED_UI_FadeoutAllArea(void);

// 初始化OLED_UI，设置当前页面的结构体指针，并初始化OLED显示屏
void OLED_UI_Init(MenuPage* Page);

// 返回函数
void OLED_UI_Back(void);

// 创建窗口
void OLED_UI_CreateWindow(MenuWindow* window);

// OLED_UI的主循环函数
void OLED_UI_MainLoop(void);

// OLED_UI的中断函数，内部包含需在中断内处理的任务
void OLED_UI_InterruptHandler(void);  // OLED_UI库的中断处理函数,需要放在中断函数内调用，中断函数2需要设置为20ms

#endif

#ifdef __cplusplus
}  // extern "C"
#endif
#endif
