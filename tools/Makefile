# Drivers Makefile 

# Compiler and assembler configuration
CC = clang
AS = clang             # We'll use clang for assembly too
CFLAGS = -ffreestanding -fno-stack-protector -fno-PIC -m64 -march=x86-64 \
         -mabi=sysv -mno-80387 -mno-mmx -mno-sse -mno-sse2 -mno-red-zone \
         -Wall -Wextra -mcmodel=kernel 
BUILD_DIR = obj
INCLUDE_DIR = include

# Source files and object files
# Find all .c files recursively in the current directory and subdirectories
C_SOURCES := $(shell find . -name '*.c')
# Find all .S files recursively (uppercase S for GNU Assembly files)
ASM_SOURCES := $(shell find . -name '*.S')
# Convert both C and assembly source files to .o object files in the build directory
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES)) \
        $(patsubst %.S,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

# Declare phony targets (targets that don't correspond to files)
.PHONY: all clean

# Default target - builds all object files
all: $(OBJS)

# Rule to compile C source files to object files
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)  # Create directory structure if it doesn't exist
	$(CC) $(CFLAGS) -I$(dir $<)/include -I$(INCLUDE_DIR) -c $< -o $@

# Rule to compile assembly source files to object files
$(BUILD_DIR)/%.o: %.S
	@mkdir -p $(dir $@)  # Create directory structure if it doesn't exist
	$(AS) -c $< -o $@    # Assemble the .S file to object file

# Clean target - removes all build artifacts
clean:
	rm -rf $(BUILD_DIR)