################################################################################
# MRS Version: 1.9.2
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include TinyMaix/model/mbnet/subdir.mk
-include TinyMaix/subdir.mk
-include StdPeriphDriver/subdir.mk
-include Startup/subdir.mk
-include RVMSIS/subdir.mk
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
tinymaix.hex \

SECONDARY_LIST += \
tinymaix.lst \

SECONDARY_SIZE += \
tinymaix.siz \


# All Target
all: tinymaix.elf secondary-outputs

# Tool invocations
tinymaix.elf: $(OBJS) $(USER_OBJS)
	@	@	riscv-none-embed-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common  -g -T "../Ld/Link.ld" -nostartfiles -Xlinker --gc-sections -L"../" -L"C:/emkit/libc/wch/CH582_Lib/StdPeriphDriver" -Xlinker --print-memory-usage -Wl,-Map,"tinymaix.map" --specs=nano.specs -u _printf_float --specs=nosys.specs -o "tinymaix.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@	@
tinymaix.hex: tinymaix.elf
	@	riscv-none-embed-objcopy -O ihex "tinymaix.elf"  "tinymaix.hex"
	@	@
tinymaix.lst: tinymaix.elf
	@	riscv-none-embed-objdump --source --all-headers --demangle --line-numbers --wide "tinymaix.elf" > "tinymaix.lst"
	@	@
tinymaix.siz: tinymaix.elf
	@	riscv-none-embed-size --format=berkeley "tinymaix.elf"
	@	@
# Other Targets
clean:
	-$(RM) $(ASM_UPPER_DEPS)$(OBJS)$(SECONDARY_FLASH)$(SECONDARY_LIST)$(SECONDARY_SIZE)$(ASM_DEPS)$(S_DEPS)$(S_UPPER_DEPS)$(C_DEPS) tinymaix.elf
	-@
secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_LIST) $(SECONDARY_SIZE)

.PHONY: all clean dependents

-include ../makefile.targets
