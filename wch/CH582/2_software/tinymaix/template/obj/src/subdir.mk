################################################################################
# MRS Version: 1.9.2
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/Main.c 

OBJS += \
./src/Main.o 

C_DEPS += \
./src/Main.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@

