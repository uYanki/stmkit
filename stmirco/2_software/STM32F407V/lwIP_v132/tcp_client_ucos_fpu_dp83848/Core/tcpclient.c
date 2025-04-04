#include "main.h"

struct tcp_pcb* tcp_client_pcb;
unsigned char   connect_flag = 0;

// 发送数据函数
err_t TCP_Client_Send_Data(struct tcp_pcb* cpcb, unsigned char* buff, unsigned int length)
{
    err_t err;

    // 发送数据
    err = tcp_write(cpcb, buff, length, TCP_WRITE_FLAG_COPY);
    tcp_output(cpcb);

    // 发送完数据关闭连接,根据具体情况选择使用
    //  tcp_close(tcp_client_pcb);

    return err;
}

// 检查连接函数
struct tcp_pcb* Check_TCP_Connect(void)
{
    struct tcp_pcb* cpcb = 0;
    connect_flag         = 0;

    for (cpcb = tcp_active_pcbs; cpcb != NULL; cpcb = cpcb->next)
    {
        // 如果TCP_LOCAL_PORT端口指定的连接没有断开
        //	if(cpcb->local_port == TCP_LOCAL_PORT && cpcb->remote_port == TCP_SERVER_PORT)

        // 如果得到应答，则证明已经连接上
        if (cpcb->state == ESTABLISHED)
        {
            connect_flag = 1;  // 连接标志
            break;
        }
    }

    if (connect_flag == 0)  // TCP_LOCAL_PORT指定的端口未连接或已断开
    {
        TCP_Client_Init(TCP_LOCAL_PORT, TCP_SERVER_PORT, TCP_SERVER_IP);  // 重新连接
        cpcb = 0;
    }

    return cpcb;
}
// TCP客户端请求连接函数
err_t TCP_Connected(void* arg, struct tcp_pcb* pcb, err_t err)
{
    // tcp_client_pcb = pcb;
    return ERR_OK;
}

// TCP客户端数据接函数
err_t TCP_Client_Recv(void* arg, struct tcp_pcb* pcb, struct pbuf* p, err_t err)
{
    struct pbuf* p_temp = p;

    if (p_temp != NULL)
    {
        tcp_recved(pcb, p_temp->tot_len);  // 获取数据长度 tot_len：tcp数据块的长度
        while (p_temp != NULL)
        {
            // loopback
            tcp_write(pcb, p_temp->payload, p_temp->len, TCP_WRITE_FLAG_COPY);  // payload为TCP数据块的起始位置
            tcp_output(pcb);
            p_temp = p_temp->next;
        }
    }
    else
    {
        tcp_close(pcb); /* 作为TCP服务器不应主动关闭这个连接？ */
    }

    /* 释放该TCP段 */
    pbuf_free(p);
    err = ERR_OK;
    return err;
}

// tcp客户端初始化
void TCP_Client_Init(uint16_t local_port, uint16_t remote_port, unsigned char a, unsigned char b, unsigned char c, unsigned char d)
{
    struct ip_addr ipaddr;
    err_t          err;

    // 服务器IP地址
    IP4_ADDR(&ipaddr, a, b, c, d);

    /* 建立通信的TCP控制块 */
    tcp_client_pcb = tcp_new();

    if (!tcp_client_pcb)
    {
        return;
    }

    /* 绑定本地IP地址和端口号 ，本地ip地址在L wIP_Init() 中已经初始化 */
    err = tcp_bind(tcp_client_pcb, IP_ADDR_ANY, local_port);

    if (err != ERR_OK)
    {
        return;
    }

    /* 注册回调函数 */
    tcp_connect(tcp_client_pcb, &ipaddr, remote_port, TCP_Connected);

    /* 设置tcp接收回调函数 */
    tcp_recv(tcp_client_pcb, TCP_Client_Recv);
}
