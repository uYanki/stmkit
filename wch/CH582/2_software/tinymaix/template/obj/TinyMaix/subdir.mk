################################################################################
# MRS Version: 1.9.2
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
F:/emkit/wch/CH582/2_software/tinymaix/common/TinyMaix/tm_layers.c \
F:/emkit/wch/CH582/2_software/tinymaix/common/TinyMaix/tm_layers_O1.c \
F:/emkit/wch/CH582/2_software/tinymaix/common/TinyMaix/tm_model.c \
F:/emkit/wch/CH582/2_software/tinymaix/common/TinyMaix/tm_stat.c 

OBJS += \
./TinyMaix/tm_layers.o \
./TinyMaix/tm_layers_O1.o \
./TinyMaix/tm_model.o \
./TinyMaix/tm_stat.o 

C_DEPS += \
./TinyMaix/tm_layers.d \
./TinyMaix/tm_layers_O1.d \
./TinyMaix/tm_model.d \
./TinyMaix/tm_stat.d 


# Each subdirectory must supply rules for building sources it contributes
TinyMaix/tm_layers.o: F:/emkit/wch/CH582/2_software/tinymaix/common/TinyMaix/tm_layers.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
TinyMaix/tm_layers_O1.o: F:/emkit/wch/CH582/2_software/tinymaix/common/TinyMaix/tm_layers_O1.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
TinyMaix/tm_model.o: F:/emkit/wch/CH582/2_software/tinymaix/common/TinyMaix/tm_model.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
TinyMaix/tm_stat.o: F:/emkit/wch/CH582/2_software/tinymaix/common/TinyMaix/tm_stat.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/include" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/cifar" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mbnet" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/mnist" -I"F:/emkit/wch/CH582/2_software/tinymaix/template/../common/TinyMaix/model/vww96" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@

