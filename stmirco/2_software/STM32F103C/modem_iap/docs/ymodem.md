![ymodem](.assets/Ymodem/ymodem.png)

发送文件名时，应同时发送文件的大小，上图没有标出，但是程序中是有实现的，格式为 ``` SOH  00 FF foo.c 3232 NUL[118] CRCH CRCL ```