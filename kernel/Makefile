# Kernel Makefile 

CC = clang
CFLAGS = -ffreestanding -fno-stack-protector -fno-PIC -m64 -march=x86-64 -mno-red-zone -Wall -Wextra
BUILD_DIR = obj
INCLUDE_DIR = include

# Sources
C_SOURCES := $(shell find . -name '*.c')
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES))

.PHONY: all clean

all: $(OBJS)

# Compile C
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -I$(dir $<)/include -I$(INCLUDE_DIR) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)
