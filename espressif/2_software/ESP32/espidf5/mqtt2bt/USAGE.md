# CONFIG

配置  wifi ssid & pwd，配置 mqtt 服务器地址

![image-20250330171316095](.assets/USAGE/image-20250330171316095.png)

# MQTTX

![image-20250330171353553](.assets/USAGE/image-20250330171353553.png)

ESP 通过蓝牙发送数据到 /topic/publish，主机订阅该地址即可接收到 ESP 发送的数据。

主机往 /topic/subscribe 发送数据，订阅了该地址的 ESP 就会接收到数据。



