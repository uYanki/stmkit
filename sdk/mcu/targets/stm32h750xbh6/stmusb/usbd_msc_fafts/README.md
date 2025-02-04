[TOC]

# 大容量储存设备

## CubeMx

### 设备模式

![usb_mode](.assets/README/usb_mode.png)



### USB 时钟源

![usb_clock_sel](.assets/README/usb_clock_sel.png)



### Keil



#### 优化等级

不同编译器，不同编译优化等级下，电脑能否识别到 U盘

> `-` 未测试，`√` 可以识别，`×` 无法识别

|      | AC5  | AC6  |
| ---- | ---- | ---- |
| O0   | √    | √    |
| O1   | √    | ×    |
| O2   | √    | ×    |
| O3   | √    | ×    |



#### fafts 

> 至少 512 个扇区，每隔扇区大小至少 512 字节



