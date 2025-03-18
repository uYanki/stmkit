################################################################################
# MRS Version: 1.9.2
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/emkit/libc/wch/CH582_Lib/RVMSIS/core_riscv.c 

OBJS += \
./RVMSIS/core_riscv.o 

C_DEPS += \
./RVMSIS/core_riscv.d 


# Each subdirectory must supply rules for building sources it contributes
RVMSIS/core_riscv.o: C:/emkit/libc/wch/CH582_Lib/RVMSIS/core_riscv.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc}" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/port/ch58x" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/ring_buffer" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/src/DAP/Include" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/common" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/core" -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:\emkit\wch\CH582\2_software\cherryusb\usbd_winusb_daplink\src" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@

