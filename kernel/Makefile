# Kernel Makefile 

# Compiler and flags configuration
CC = clang
CFLAGS = -ffreestanding -fno-stack-protector -fno-PIC -m64 -march=x86-64 -mno-red-zone -Wall -Wextra -mcmodel=kernel
BUILD_DIR = obj
INCLUDE_DIR = include

# Source files and object files
C_SOURCES := $(shell find . -name '*.c')
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES))

.PHONY: all clean

# Default target - builds all object files
all: $(OBJS)

# Rule to compile C source files to object files
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)               # Create directory structure if it doesn't exist
	@echo "CC      $<"                 # Print CC like Linux
	@ $(CC) $(CFLAGS) -I$(dir $<)/include -I$(INCLUDE_DIR) -c $< -o $@

# Clean target - removes all build artifacts
clean:
	@echo "CLEAN   $(BUILD_DIR)"
	@ rm -rf $(BUILD_DIR)
