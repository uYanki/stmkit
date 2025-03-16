#include "main.h"

static void NVIC_Configuration(void);

#define TASK_STARTUP_STK_SIZE    400
#define TASK_TEST_LED_STK_SIZE   400
#define TASK_UDP_CLIENT_STK_SIZE 4000

OS_STK Stk_TaskStartUp[TASK_STARTUP_STK_SIZE];
OS_STK Stk_Task_LED[TASK_TEST_LED_STK_SIZE];
OS_STK Stk_Task_UDP_Client[TASK_UDP_CLIENT_STK_SIZE];

void Task_StartUp(void* pdata);
void Task_LED(void* pdata);
void Task_UDP_Client(void* pdata);

int main(void)
{
    LED_Configuration();
    NVIC_Configuration();

    OSInit();

    OSTaskCreate(Task_StartUp,                                          // 指向任务代码的指针
                 (void*)0,                                              // 任务开始执行时，传递给任务的参数的指针
                 (OS_STK*)&Stk_TaskStartUp[TASK_STARTUP_STK_SIZE - 1],  // 分配给任务的堆栈的栈顶指针 从顶向下递减
                 (INT8U)OS_USER_PRIO_LOWEST);                           // 分配给任务的优先级

    // 节拍计数器清0
    OSTimeSet(0);

    // 启动UCOS-II内核
    OSStart();

    return 0;
}

void Task_StartUp(void* pdata)
{
    // 初始化UCOS时钟
    // OS_TICKS_PER_SEC 为 UCOS-II 每秒嘀嗒数
    SysTick_Config(SystemCoreClock / OS_TICKS_PER_SEC);

    // 优先级说明，使用OS_USER_PRIO_GET(n)宏来获取
    // OS_USER_PRIO_GET(0)最高,OS_USER_PRIO_GET(1)次之，依次类推
    // OS_USER_PRIO_GET(0)：最高的优先级，主要用于在处理紧急事务，需要将优先处理的任务设置为最高这个优先级

    OSTaskCreate(Task_UDP_Client, (void*)0, &Stk_Task_UDP_Client[TASK_UDP_CLIENT_STK_SIZE - 1], OS_USER_PRIO_GET(5));
    OSTaskCreate(Task_LED, (void*)0, &Stk_Task_LED[TASK_TEST_LED_STK_SIZE - 1], OS_USER_PRIO_GET(6));

    while (1)
    {
        OSTimeDlyHMSM(0, 0, 1, 0);  // 1000ms
    }
}

// LED闪烁任务
void Task_LED(void* pdata)
{
    while (1)
    {
        OSTimeDlyHMSM(0, 0, 0, 1000);
        GPIO_ToggleBits(LED1);
    }
}
// UDP服务器收发任务
void Task_UDP_Client(void* pdata)
{
    __IO uint32_t LocalTime = 0; /* this variable is used to create a time reference incremented by 10ms */

    /* configure ethernet (GPIOs, clocks, MAC, DMA) */
    ETH_BSP_Config();
    LwIP_Init();

    /* UDP_client Init */
    UDP_client_init();
    while (1)
    {
        udp_send(udp_pcb, udp_p);  // 发送数据
        LocalTime += 10;
        LwIP_Periodic_Handle(LocalTime);
        OSTimeDlyHMSM(0, 0, 0, 10);  // 挂起10ms，以便其他线程运行
    }
}

static void NVIC_Configuration(void)
{
    NVIC_InitTypeDef NVIC_InitStructure;

    /* Set the Vector Table base location at 0x08000000 */
    NVIC_SetVectorTable(NVIC_VectTab_FLASH, 0x0);

    /* 2 bit for pre-emption priority, 2 bits for subpriority */
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_4);

    /* Enable the Ethernet global Interrupt */
    NVIC_InitStructure.NVIC_IRQChannel                   = ETH_IRQn;
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
    NVIC_InitStructure.NVIC_IRQChannelSubPriority        = 0;
    NVIC_InitStructure.NVIC_IRQChannelCmd                = ENABLE;
    NVIC_Init(&NVIC_InitStructure);
}
