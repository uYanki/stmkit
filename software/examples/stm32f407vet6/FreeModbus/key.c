
#include <stdbool.h>

// 定义开关信号结构体
typedef struct {
    bool lastState;             // 上次开关信号状态
    bool currentState;          // 当前开关信号状态
    bool validState;            // 有效的开关信号状态
    int  debounceDelayCounter;  // 开关信号消抖计数器
} DebouncedSwitch;

// 初始化开关信号结构体
void initializeSwitch(DebouncedSwitch* switchObj)
{
    switchObj->lastState            = false;
    switchObj->currentState         = false;
    switchObj->validState           = false;
    switchObj->debounceDelayCounter = 0;
}

// 模拟读取开关信号状态的函数
bool readSwitchState()
{
    // 在这里替换为实际的开关信号读取代码
    // 返回开关信号的当前状态（true表示开，false表示关）
    return false;
}

// 处理开关信号消抖的函数
void debounceSwitch(DebouncedSwitch* switchObj, int debounceTime)
{
    // 读取当前开关信号状态
    switchObj->currentState = readSwitchState();

    // 如果当前状态与上次状态不同，重置计数器并更新上次状态
    if (switchObj->currentState != switchObj->lastState)
    {
        switchObj->debounceDelayCounter = 0;
    }
    else
    {
        // 如果状态相同，增加计数器值
        switchObj->debounceDelayCounter++;
    }

    // 如果计数器达到指定的消抖时间，表示开关信号状态稳定
    if (switchObj->debounceDelayCounter >= (debounceTime / 10))
    {
        // 如果当前状态与 validState 不同，表示发生了有效的状态变化
        if (switchObj->currentState != switchObj->validState)
        {
            switchObj->validState = switchObj->currentState;
        }
    }
    // 更新上次状态
    switchObj->lastState = switchObj->currentState;
}

int main()
{
    // 创建一个开关信号的DebouncedSwitch结构体
    DebouncedSwitch switchObj;
    initializeSwitch(&switchObj);

    while (1)
    {
        debounceSwitch(&switchObj, 100);  // 设置消抖时间为100毫秒
        if (switchObj.validState)
        {
            if (switchObj.validState)
            {
                // 执行开关信号为开的操作
                printf("开关信号为开\n");
            }
            else
            {
                // 执行开关信号为关的操作
                printf("开关信号为关\n");
            }
        }

        // 在这里可以添加其他需要执行的代码

        // 模拟延时或等待开关信号状态变化
        // 这里使用usleep函数来模拟10毫秒的延时
        // 实际上，你需要根据你的硬件和操作系统来等待开关信号状态变化
        usleep(10000);  // 10毫秒
    }

    return 0;
}

#if 0


1、函数详解：
debounceSwitch函数该函数用于处理开关信号的消抖，以确保稳定的开关状态。
它接受一个指向 DebouncedSwitch 结构体的指针， 该结构体包含了上次状态、当前状态、有效状态等信息，以及消抖时间的设置。
该函数的被调用周期为10ms（可以与产品程序中其他任务并行执行）。

2、函数的工作流程如下： 
1）读取当前开关信号状态。
2）如果当前状态与上次状态不同，重置计数器并更新上次状态。 
3）如果当前状态与上次状态相同，增加计数器值。 
4）如果计数器达到指定的消抖时间，表示开关信号状态稳定。
5）如果当前状态与 validState 不同，表示发生了有效的状态变化，更新有效状态。 
6）更新上次状态以便下一次比较
3、优点介绍：
1）扩展性：debounceSwitch该函数使用结构体指针的形式，提供了开关量检测的框架，需要多个开关量/按键检测时，实例化对应的按键变量即可。

#endif