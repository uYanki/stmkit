#include "main.h"

const static unsigned char UDPData[] = "udp client!\r\n";

struct udp_pcb* udp_pcb;
struct ip_addr  ipaddr;
struct pbuf*    udp_p;

void UDP_client_init(void)
{
    udp_p          = pbuf_alloc(PBUF_RAW, sizeof(UDPData), PBUF_RAM);
    udp_p->payload = (void*)UDPData;
    Make_IP4_ADDR(&ipaddr, UDP_UDP_REMOTE_IP);  // 远端IP
    udp_pcb = udp_new();
    udp_bind(udp_pcb, IP_ADDR_ANY, UDP_CLIENT_PORT); /* 绑定本地IP地址 */
    udp_connect(udp_pcb, &ipaddr, UDP_REMOTE_PORT);  /* 连接远程主机 */
}

void Make_IP4_ADDR(struct ip_addr* ipaddr, unsigned char a, unsigned char b, unsigned char c, unsigned char d)
{
    ipaddr->addr = htonl(((u32_t)((a) & 0xff) << 24) |
                         ((u32_t)((b) & 0xff) << 16) |
                         ((u32_t)((c) & 0xff) << 8) |
                         (u32_t)((d) & 0xff));
}

void UDP_Send_Data(struct udp_pcb* pcb, struct pbuf* p)
{
    udp_send(pcb, p);
    UDP_Delay(0XFFFFF);  // 延时，不能发送太快
}

static void UDP_Delay(unsigned long ulVal)
{
    while (--ulVal != 0);
}
