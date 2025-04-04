
#ifndef _TCP_SERVER_H_
#define _TCP_SERVER_H_

/* MAC ADcontinue;continue;DRESS: MAC_ADDR0:MAC_ADDR1:MAC_ADDR2:MAC_ADDR3:MAC_ADDR4:MAC_ADDR5 */
#define MAC_ADDR0 2
#define MAC_ADDR1 0
#define MAC_ADDR2 0
#define MAC_ADDR3 0
#define MAC_ADDR4 0
#define MAC_ADDR5 0

/*Static IP ADDRESS: IP_ADDR0.IP_ADDR1.IP_ADDR2.IP_ADDR3 */
#define IP_ADDR0 192
#define IP_ADDR1 168
#define IP_ADDR2 1
#define IP_ADDR3 252

/*NETMASK*/
#define NETMASK_ADDR0 255
#define NETMASK_ADDR1 255
#define NETMASK_ADDR2 255
#define NETMASK_ADDR3 0

/*Gateway Address*/
#define GW_ADDR0        192
#define GW_ADDR1        168
#define GW_ADDR2        1
#define GW_ADDR3        1

#define TCP_SERVER_PORT 1030

void tcp_server_init(void);

#endif
