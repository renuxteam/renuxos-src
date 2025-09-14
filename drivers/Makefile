# Drivers Makefile with ASM support
CC = clang
AS = clang             # We'll use clang for assembly too
CFLAGS = -ffreestanding -fno-stack-protector -fno-PIC -m64 -march=x86-64 \
         -mabi=sysv -mno-80387 -mno-mmx -mno-sse -mno-sse2 -mno-red-zone \
         -Wall -Wextra
BUILD_DIR = obj
INCLUDE_DIR = include

# Sources
C_SOURCES := $(shell find . -name '*.c')
ASM_SOURCES := $(shell find . -name '*.S')   # uppercase S for GAS files
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES)) \
        $(patsubst %.S,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

.PHONY: all clean

all: $(OBJS)

# Compile C
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -I$(dir $<)/include -I$(INCLUDE_DIR) -c $< -o $@

# Compile ASM
$(BUILD_DIR)/%.o: %.S
	@mkdir -p $(dir $@)
	$(AS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)
