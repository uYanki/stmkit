################################################################################
# MRS Version: 1.9.2
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_adc.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_clk.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_flash.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_gpio.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_i2c.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_pwm.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_pwr.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_spi0.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_spi1.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_sys.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_timer0.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_timer1.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_timer2.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_timer3.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_uart0.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_uart1.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_uart2.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_uart3.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usb2dev.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usb2hostBase.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usb2hostClass.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usbdev.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usbhostBase.c \
C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usbhostClass.c 

OBJS += \
./StdPeriphDriver/CH58x_adc.o \
./StdPeriphDriver/CH58x_clk.o \
./StdPeriphDriver/CH58x_flash.o \
./StdPeriphDriver/CH58x_gpio.o \
./StdPeriphDriver/CH58x_i2c.o \
./StdPeriphDriver/CH58x_pwm.o \
./StdPeriphDriver/CH58x_pwr.o \
./StdPeriphDriver/CH58x_spi0.o \
./StdPeriphDriver/CH58x_spi1.o \
./StdPeriphDriver/CH58x_sys.o \
./StdPeriphDriver/CH58x_timer0.o \
./StdPeriphDriver/CH58x_timer1.o \
./StdPeriphDriver/CH58x_timer2.o \
./StdPeriphDriver/CH58x_timer3.o \
./StdPeriphDriver/CH58x_uart0.o \
./StdPeriphDriver/CH58x_uart1.o \
./StdPeriphDriver/CH58x_uart2.o \
./StdPeriphDriver/CH58x_uart3.o \
./StdPeriphDriver/CH58x_usb2dev.o \
./StdPeriphDriver/CH58x_usb2hostBase.o \
./StdPeriphDriver/CH58x_usb2hostClass.o \
./StdPeriphDriver/CH58x_usbdev.o \
./StdPeriphDriver/CH58x_usbhostBase.o \
./StdPeriphDriver/CH58x_usbhostClass.o 

C_DEPS += \
./StdPeriphDriver/CH58x_adc.d \
./StdPeriphDriver/CH58x_clk.d \
./StdPeriphDriver/CH58x_flash.d \
./StdPeriphDriver/CH58x_gpio.d \
./StdPeriphDriver/CH58x_i2c.d \
./StdPeriphDriver/CH58x_pwm.d \
./StdPeriphDriver/CH58x_pwr.d \
./StdPeriphDriver/CH58x_spi0.d \
./StdPeriphDriver/CH58x_spi1.d \
./StdPeriphDriver/CH58x_sys.d \
./StdPeriphDriver/CH58x_timer0.d \
./StdPeriphDriver/CH58x_timer1.d \
./StdPeriphDriver/CH58x_timer2.d \
./StdPeriphDriver/CH58x_timer3.d \
./StdPeriphDriver/CH58x_uart0.d \
./StdPeriphDriver/CH58x_uart1.d \
./StdPeriphDriver/CH58x_uart2.d \
./StdPeriphDriver/CH58x_uart3.d \
./StdPeriphDriver/CH58x_usb2dev.d \
./StdPeriphDriver/CH58x_usb2hostBase.d \
./StdPeriphDriver/CH58x_usb2hostClass.d \
./StdPeriphDriver/CH58x_usbdev.d \
./StdPeriphDriver/CH58x_usbhostBase.d \
./StdPeriphDriver/CH58x_usbhostClass.d 


# Each subdirectory must supply rules for building sources it contributes
StdPeriphDriver/CH58x_adc.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_adc.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_clk.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_clk.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_flash.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_flash.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_gpio.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_gpio.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_i2c.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_i2c.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_pwm.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_pwm.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_pwr.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_pwr.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_spi0.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_spi0.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_spi1.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_spi1.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_sys.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_sys.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_timer0.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_timer0.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_timer1.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_timer1.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_timer2.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_timer2.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_timer3.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_timer3.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_uart0.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_uart0.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_uart1.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_uart1.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_uart2.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_uart2.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_uart3.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_uart3.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_usb2dev.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usb2dev.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_usb2hostBase.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usb2hostBase.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_usb2hostClass.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usb2hostClass.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_usbdev.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usbdev.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_usbhostBase.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usbhostBase.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
StdPeriphDriver/CH58x_usbhostClass.o: C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/CH58x_usbhostClass.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@

