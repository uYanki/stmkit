# esp-idf-mqtt-file
ESP-IDF example for sending and receiving files using MQTT.   
I found [this](http://www.steves-internet-guide.com/send-file-mqtt/) article.   
It's great to be able to exchange files using MQTT.   
Since the python code was publicly available, I ported it to esp-idf.   

# Software requirements
ESP-IDF V4.4/V5.x.   
ESP-IDF V5.0 is required when using ESP32-C2.   
ESP-IDF V5.1 is required when using ESP32-C6.   

# Installation

```Shell
git clone https://github.com/nopnop2002/esp-idf-mqtt-file
cd esp-idf-mqtt-file
idf.py set-target {esp32/esp32s2/esp32s3/esp32c2/esp32c3/esp32c6}
idf.py menuconfig
idf.py flash
```

# Configuration   

![config-top](.assets/README/aea9bf86-d953-4cd2-bbb6-0d75081ef4e8)
![config-app](.assets/README/d39d17ec-e6be-462b-95fb-1d69256fd4f0)

## WiFi Setting
Set the information of your access point.   
![config-wifi](.assets/README/16363fe8-728d-45a9-b106-56c806dee257)

## Broker Setting

MQTT broker is specified by one of the following.
- IP address   
 ```192.168.10.20```   
- mDNS host name   
 ```mqtt-broker.local```   
- Fully Qualified Domain Name   
 ```broker.emqx.io```

You can download the MQTT broker from [here](https://github.com/nopnop2002/esp-idf-mqtt-broker).   

![config-broker-1](.assets/README/5a603ac6-44e2-4efc-a8c5-ce12e94eb684)

Specifies the username and password if the server requires a password when connecting.   
[Here's](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-the-mosquitto-mqtt-messaging-broker-on-debian-10) how to install and secure the Mosquitto MQTT messaging broker on Debian 10.   

![config-broker-2](.assets/README/7d9708d0-0127-4b18-bc7d-fd4cce81a5bb)

# How to use   

Run the following python script on the host side.
```
$ python3 -m pip install paho-mqtt

$ vi mqtt-file.py
Set the broker you will use.

$ python3 mqtt-file.py
usage python3 mqtt-file.py put path_to_host
usage python3 mqtt-file.py get path_to_spiffs
usage python3 mqtt-file.py list
usage python3 mqtt-file.py delete path_to_spiffs
```

Example of use.   
```
# Put README.md to SPIFFS
$ python3 mqtt-file.py put README.md

# SPIFFS file list
$ python3 mqtt-file.py list

$ mv README.md README.md.md

# Get README.md from SPIFFS
$ python3 mqtt-file.py get README.md

# Compare two files
$ diff README.md README.md.md

# Delete README.md from SPIFFS
$ python3 mqtt-file.py delete README.md
```

# MQTT Topic
This project uses the following topics:
```
MQTT_PUT_REQUEST="/mqtt/files/put/req"
MQTT_GET_REQUEST="/mqtt/files/get/req"
MQTT_LIST_REQUEST="/mqtt/files/list/req"
MQTT_DELETE_REQUEST="/mqtt/files/delete/req"

MQTT_PUT_RESPONSE="/mqtt/files/put/res"
MQTT_GET_RESPONSE="/mqtt/files/get/res"
MQTT_LIST_RESPONSE="/mqtt/files/list/res"
MQTT_DELETE_RESPONSE="/mqtt/files/delete/res"
```

When using public brokers, these topics may be used for other purposes.   
If you want to change the topic to your own, you will need to change both the ESP32 side and the python side.   
You can use [this](https://github.com/nopnop2002/esp-idf-mqtt-broker) as your personal Broker.   
