#include "main.h"

void udp_server_recv(void* arg, struct udp_pcb* pcb, struct pbuf* p, struct ip_addr* addr, u16_t port)
{
    struct ip_addr destAddr = *addr; /* 获取远程主机 IP地址 */
    struct pbuf*   p_temp   = p;

    // while(p_temp != NULL)
    {
        // loopback
        udp_sendto(pcb, p_temp, &destAddr, port);
        p_temp = p_temp->next;
    }

    pbuf_free(p); /* 释放该UDP段 */
}

void UDP_server_init(void)
{
    struct udp_pcb* pcb;
    pcb = udp_new();                            // 申请udp控制块
    udp_bind(pcb, IP_ADDR_ANY, UDP_LOCAL_PORT); /* 绑定本地IP地址和端口号（作为udp服务器） */
    udp_recv(pcb, udp_server_recv, NULL);       /* 设置UDP段到时的回调函数 */
}
