#include "main.h"

static void NVIC_Configuration(void);

#define TASK_STARTUP_STK_SIZE    400
#define TASK_TEST_LED_STK_SIZE   400
#define TASK_TCP_CLIENT_STK_SIZE 4000

OS_STK Stk_TaskStartUp[TASK_STARTUP_STK_SIZE];
OS_STK Stk_Task_LED[TASK_TEST_LED_STK_SIZE];
OS_STK Stk_Task_TCP_Client[TASK_TCP_CLIENT_STK_SIZE];

void Task_StartUp(void* pdata);
void Task_LED(void* pdata);
void Task_TCP_Client(void* pdata);

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

    OSTaskCreate(Task_TCP_Client, (void*)0, &Stk_Task_TCP_Client[TASK_TCP_CLIENT_STK_SIZE - 1], OS_USER_PRIO_GET(5));
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

// tcp客户端收发任务
void Task_TCP_Client(void* pdata)
{
    __IO uint32_t   LocalTime  = 0; /* this variable is used to create a time reference incremented by 10ms */
    unsigned char   tcp_data[] = "tcp client !\r\n";
    struct tcp_pcb* pcb;

    /* configure ethernet (GPIOs, clocks, MAC, DMA) */
    ETH_BSP_Config();
    LwIP_Init();

    /* TCP_Client Init */
    TCP_Client_Init(TCP_LOCAL_PORT, TCP_SERVER_PORT, TCP_SERVER_IP);

    while (1)
    {
        pcb = Check_TCP_Connect();

        if (pcb != 0)
        {
            // 主动向服务器发送函数
            TCP_Client_Send_Data(pcb, tcp_data, sizeof(tcp_data));
        }

        LocalTime += 100;
        LwIP_Periodic_Handle(LocalTime);

        // 挂起100ms，以便其他线程运行
        OSTimeDlyHMSM(0, 0, 0, 100);
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
