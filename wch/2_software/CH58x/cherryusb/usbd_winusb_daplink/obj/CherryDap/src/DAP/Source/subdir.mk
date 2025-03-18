################################################################################
# MRS Version: 1.9.2
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/DAP.c \
F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/DAP_vendor.c \
F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/JTAG_DP.c \
F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/SWO.c \
F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/SW_DP.c \
F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/UART.c 

OBJS += \
./CherryDap/src/DAP/Source/DAP.o \
./CherryDap/src/DAP/Source/DAP_vendor.o \
./CherryDap/src/DAP/Source/JTAG_DP.o \
./CherryDap/src/DAP/Source/SWO.o \
./CherryDap/src/DAP/Source/SW_DP.o \
./CherryDap/src/DAP/Source/UART.o 

C_DEPS += \
./CherryDap/src/DAP/Source/DAP.d \
./CherryDap/src/DAP/Source/DAP_vendor.d \
./CherryDap/src/DAP/Source/JTAG_DP.d \
./CherryDap/src/DAP/Source/SWO.d \
./CherryDap/src/DAP/Source/SW_DP.d \
./CherryDap/src/DAP/Source/UART.d 


# Each subdirectory must supply rules for building sources it contributes
CherryDap/src/DAP/Source/DAP.o: F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/DAP.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc}" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/port/ch58x" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/ring_buffer" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/src/DAP/Include" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/common" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/core" -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:\emkit\wch\CH582\2_software\cherryusb\usbd_winusb_daplink\src" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
CherryDap/src/DAP/Source/DAP_vendor.o: F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/DAP_vendor.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc}" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/port/ch58x" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/ring_buffer" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/src/DAP/Include" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/common" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/core" -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:\emkit\wch\CH582\2_software\cherryusb\usbd_winusb_daplink\src" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
CherryDap/src/DAP/Source/JTAG_DP.o: F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/JTAG_DP.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc}" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/port/ch58x" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/ring_buffer" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/src/DAP/Include" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/common" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/core" -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:\emkit\wch\CH582\2_software\cherryusb\usbd_winusb_daplink\src" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
CherryDap/src/DAP/Source/SWO.o: F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/SWO.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc}" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/port/ch58x" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/ring_buffer" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/src/DAP/Include" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/common" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/core" -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:\emkit\wch\CH582\2_software\cherryusb\usbd_winusb_daplink\src" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
CherryDap/src/DAP/Source/SW_DP.o: F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/SW_DP.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc}" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/port/ch58x" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/ring_buffer" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/src/DAP/Include" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/common" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/core" -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:\emkit\wch\CH582\2_software\cherryusb\usbd_winusb_daplink\src" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
CherryDap/src/DAP/Source/UART.o: F:/emkit/wch/CH582/2_software/cherryusb/common/CherryDap/src/DAP/Source/UART.c
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -DDEBUG=1 -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc}" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/port/ch58x" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/ring_buffer" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherrydap/src/DAP/Include" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/common" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/class/cdc" -I"F:/emkit/wch/CH582/2_software/cherryusb/usbd_winusb_daplink/../common/cherryusb/core" -I"C:/emkit/libc/wch/CH582_Lib/RVMSIS" -I"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver/inc" -I"F:\emkit\wch\CH582\2_software\cherryusb\usbd_winusb_daplink\src" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@

