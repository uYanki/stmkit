# CONFIG

配置好 wifi ssid & pwd，mqtt server ip 

![image-20250331000340327](.assets/USAGE/image-20250331000340327.png)

# MQTTX

订阅 /topic/uart/tx，往串口发送数据时订阅者会收到数据。 

![image-20250331000551952](.assets/USAGE/image-20250331000551952.png)

往 /topic/uart/rx 发送数据，esp 会收到数据（在串口上没数据显示，但在日志上有显示，bug?）

![image-20250331000742352](.assets/USAGE/image-20250331000742352.png)