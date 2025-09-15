# Drivers Makefile 

# Compiler and assembler configuration
CC = zig cc
AS = zig cc             # We'll use clang for assembly too
TARGET = x86_64-freestanding-none
CFLAGS = -fno-stack-protector -fno-PIC -m64 \
         -mabi=sysv -mno-80387 -mno-mmx -mno-sse -mno-sse2 -mno-red-zone \
         -Wall -Wextra -mcmodel=kernel -fno-sanitize=undefined
BUILD_DIR = obj
INCLUDE_DIR = include

# Source files and object files
C_SOURCES := $(shell find . -name '*.c')
ASM_SOURCES := $(shell find . -name '*.S')
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES)) \
        $(patsubst %.S,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

.PHONY: all clean

# Default target - builds all object files
all: $(OBJS)

# Rule to compile C source files to object files
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -target $(TARGET) $(CFLAGS) -I$(dir $<)/include -I$(INCLUDE_DIR) -c $< -o $@

# Rule to compile assembly source files to object files
$(BUILD_DIR)/%.o: %.S
	@mkdir -p $(dir $@)
	$(AS) -c $< -o $@

# Clean target - removes all build artifacts
clean:
	rm -rf $(BUILD_DIR)
