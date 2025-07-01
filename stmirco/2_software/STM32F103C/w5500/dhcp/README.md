## Circuit Diagram and connections

Refer below table to connect W5500 pins with STM32 pins:

| W5500 | STM32 | USB2TTL |
| ----- | ----- | ------- |
| GND   | GND   | GND     |
| VCC   | 3.3V  |         |
| RST   | 3.3V  |         |
| INT   |       |         |
| SCS   | PA4   |         |
| CLK   | PA5   |         |
| MISO  | PA6   |         |
| MOSI  | PA7   |         |
|       | PA9   | RX      |
|       | PA10  | TX      |

## Configuration

### MAC, IP, Mask, Gateway and Remote Server IP

Edit in main.c

```c
void Load_Net_Parameters(void)
{
	gWIZNETINFO.gw[0] = 192; //Gateway
	gWIZNETINFO.gw[1] = 168;
	gWIZNETINFO.gw[2] = 1;
	gWIZNETINFO.gw[3] = 1;

	gWIZNETINFO.sn[0]=255; //Mask
	gWIZNETINFO.sn[1]=255;
	gWIZNETINFO.sn[2]=255;
	gWIZNETINFO.sn[3]=0;

	gWIZNETINFO.mac[0]=0x0c; //MAC
	gWIZNETINFO.mac[1]=0x29;
	gWIZNETINFO.mac[2]=0xab;
	gWIZNETINFO.mac[3]=0x7c;
	gWIZNETINFO.mac[4]=0x00;
	gWIZNETINFO.mac[5]=0x01;

	gWIZNETINFO.ip[0]=192; //IP
	gWIZNETINFO.ip[1]=168;
	gWIZNETINFO.ip[2]=1;
	gWIZNETINFO.ip[3]=204;

	gWIZNETINFO.dhcp = NETINFO_STATIC;
}
uint8_t destip[4] = {192, 168, 1, 210};
uint16_t destport = 3333;
```

### Output Logs

Add `_DHCP_DEBUG_` and `_LOOPBACK_DEBUG_` to preprocessor symbols, this will enable the debug log output (in UART1).

## Test

* Ping test: Ping the IP address you defined in main.c
* TCP client test: Run `nc -l 3333` to listen port 3333 on server IP, and restart stm32 board

## Coding

### Receive Data

Use `getSn_RX_RSR(sn)`: Sn_RX_RSR indicates the data size received and saved in Socket n RX Buffer.

Some interesting reading:

```c
uint16_t getSn_RX_RSR(uint8_t sn)
{
   uint16_t val=0,val1=0;
   do {
      val1 = WIZCHIP_READ(Sn_RX_RSR(sn));
      val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
      if (val1 != 0) {
        val = WIZCHIP_READ(Sn_RX_RSR(sn));
        val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
      }
   } while (val != val1);
   return val;
}
```

In this method, RX_RSR was read twice in each iteration till the values are the same. This is to avoid the problem described in [UDP header seems to contain the expected size, but the RX_RSR value is much smaller](https://forum.wiznet.io/t/topic/6736/3)

Read all data if the length exceeds your buffer size:

```c
if((size = getSn_RX_RSR(sn)) > 0) { // Sn_RX_RSR: Socket n Received Size Register, Receiving data length
	if(size > DATA_BUF_SIZE) size = DATA_BUF_SIZE; // DATA_BUF_SIZE means user defined buffer size (array)
	ret = recv(sn, buf, size); // Data Receive process (H/W Rx socket buffer -> User's buffer)
	if(ret <= 0) return ret; // If the received data length <= 0, receive failed and process end
	size = (uint16_t) ret;
	// Add code here to handle the data
}
```

### Send Data

```c
uint16_t sentsize = 0;
while(size != sentsize) {
  ret = send(sn, buf+sentsize, size-sentsize); // Data send process (User's buffer -> Destination through H/W Tx socket buffer)
  if(ret < 0) { // Send Error occurred (sent data length < 0)
    close(sn); // socket close
    return ret;
  }
  sentsize += ret; // Don't care SOCKERR_BUSY, because it is zero.
}
```

