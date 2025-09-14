# Kernel Makefile 

# Compiler and flags configuration
CC = clang
CFLAGS = -ffreestanding -fno-stack-protector -fno-PIC -m64 -march=x86-64 -mno-red-zone -Wall -Wextra -mcmodel=kernel
BUILD_DIR = obj
INCLUDE_DIR = include

# Source files and object files
# Find all .c files recursively in the current directory and subdirectories
C_SOURCES := $(shell find . -name '*.c')
# Convert .c source files to .o object files in the build directory
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES))

# Declare phony targets (targets that don't correspond to files)
.PHONY: all clean

# Default target - builds all object files
all: $(OBJS)

# Rule to compile C source files to object files
# For each .c file, create the corresponding .o file in the build directory
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)  # Create directory structure if it doesn't exist
	@ $(CC) $(CFLAGS) -I$(dir $<)/include -I$(INCLUDE_DIR) -c $< -o $@

# Clean target - removes all build artifacts
clean:
	@echo "CLEAN   $(BUILD_DIR)"
	@ rm -rf $(BUILD_DIR)