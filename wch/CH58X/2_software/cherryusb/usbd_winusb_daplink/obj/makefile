################################################################################
# MRS Version: 1.9.2
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include StdPeriphDriver/subdir.mk
-include Startup/subdir.mk
-include RVMSIS/subdir.mk
-include CherryUSB/port/ch32/subdir.mk
-include CherryUSB/core/subdir.mk
-include CherryUSB/class/cdc/subdir.mk
-include CherryDap/src/DAP/Source/subdir.mk
-include CherryDap/src/subdir.mk
-include CherryDap/ring_buffer/subdir.mk
-include CherryDap/port/ch58x/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
SECONDARY_FLASH += \
cherrydap.hex \

SECONDARY_LIST += \
cherrydap.lst \

SECONDARY_SIZE += \
cherrydap.siz \


# All Target
all: cherrydap.elf secondary-outputs

# Tool invocations
cherrydap.elf: $(OBJS) $(USER_OBJS)
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -T "../Ld/Link.ld" -nostartfiles -Xlinker --gc-sections -L"../" -L"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver" -Xlinker --print-memory-usage -Wl,-Map,"cherrydap.map" --specs=nano.specs --specs=nosys.specs -o "cherrydap.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@	@
cherrydap.hex: cherrydap.elf
	@	riscv-none-embed-objcopy -O ihex "cherrydap.elf"  "cherrydap.hex"
	@	@
cherrydap.lst: cherrydap.elf
	@	riscv-none-embed-objdump --source --all-headers --demangle --line-numbers --wide "cherrydap.elf" > "cherrydap.lst"
	@	@
cherrydap.siz: cherrydap.elf
	@	riscv-none-embed-size --format=berkeley "cherrydap.elf"
	@	@
# Other Targets
clean:
	-$(RM) $(ASM_UPPER_DEPS)$(OBJS)$(SECONDARY_FLASH)$(SECONDARY_LIST)$(SECONDARY_SIZE)$(ASM_DEPS)$(S_DEPS)$(S_UPPER_DEPS)$(C_DEPS) cherrydap.elf
	-@
secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_LIST) $(SECONDARY_SIZE)

.PHONY: all clean dependents

-include ../makefile.targets
