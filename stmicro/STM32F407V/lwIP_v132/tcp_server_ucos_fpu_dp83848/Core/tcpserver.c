#include "main.h"

static err_t tcp_server_recv(void* arg, struct tcp_pcb* pcb, struct pbuf* p, err_t err)
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

static err_t tcp_server_accept(void* arg, struct tcp_pcb* pcb, err_t err)
{
    tcp_setprio(pcb, TCP_PRIO_MIN); /* 设置回调函数优先级，当存在几个连接时特别重要,此函数必须调用*/
    tcp_recv(pcb, tcp_server_recv); /* 设置TCP段到时的回调函数 */
    err = ERR_OK;
    return err;
}

void tcp_server_init(void)
{
    struct tcp_pcb* pcb;

    pcb = tcp_new();                             /* 建立通信的TCP控制块(pcb) */
    tcp_bind(pcb, IP_ADDR_ANY, TCP_SERVER_PORT); /* 绑定本地IP地址和端口号（作为tcp服务器） */
    pcb = tcp_listen(pcb);                       /* 进入监听状态 */
    tcp_accept(pcb, tcp_server_accept);          /* 设置有连接请求时的回调函数 */
}
