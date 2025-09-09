# Configuration
CC ?= gcc
LD ?= ld
ZIG ?= zig

TARGET = kernel.elf
ISO = renuxos.iso
BUILD_DIR = out
LIMINE_DIR = /tmp/limine
ISO_DIR = /tmp/renuxos_iso

# Compilation and linking flags
CFLAGS = -ffreestanding -fno-stack-protector -fno-PIC -m64 -march=x86-64 \
         -mabi=sysv -mno-80387 -mno-mmx -mno-sse -mno-sse2 -mno-red-zone \
         -Wall -Wextra

LDFLAGS = -T linker/linker.ld -nostdlib -static -z max-page-size=0x1000

# Sources and objects
KERNEL_SRC = kernel
FRAMEBUFFER_SRC = drivers/video/framebuffer/framebuffer.c
LIMINE_REQUEST_SRC = boot/x86_64/limine_request.c

OBJS = $(BUILD_DIR)/kernel.o \
       $(BUILD_DIR)/framebuffer.o \
       $(BUILD_DIR)/limine_request.o

.PHONY: all build iso clean run

# Main target
all: build

# Build rule
build: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)/kernel.o:
	@mkdir -p $(BUILD_DIR)
	cd $(KERNEL_SRC) && $(ZIG) build -Doutput=../$@

$(BUILD_DIR)/framebuffer.o: $(FRAMEBUFFER_SRC)
	$(CC) $(CFLAGS) -c $< -I$(dir $<)/include -o $@

$(BUILD_DIR)/limine_request.o: $(LIMINE_REQUEST_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to create ISO
iso: $(TARGET)
	@echo "Cloning Limine..."
	@git clone --branch v9.x-binary --depth 1 \
		https://codeberg.org/Limine/Limine.git $(LIMINE_DIR) >/dev/null 2>&1 || true
	
	@echo "Preparing directory structure..."
	@mkdir -p $(ISO_DIR)/EFI/BOOT
	@mkdir -p $(ISO_DIR)/boot
	
	@echo "Copying Limine files..."
	@cp -f $(LIMINE_DIR)/BOOTX64.EFI $(LIMINE_DIR)/limine-*-cd.bin \
		$(LIMINE_DIR)/limine-bios.sys $(ISO_DIR)/
	@mv $(ISO_DIR)/BOOTX64.EFI $(ISO_DIR)/EFI/BOOT/
	
	@echo "Copying configuration and kernel..."
	@cp boot/x86_64/limine.conf $(ISO_DIR)/boot/
	@cp $(TARGET) $(ISO_DIR)/boot/
	
	@echo "Creating ISO..."
	@xorriso -as mkisofs -b limine-bios-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-uefi-cd.bin -efi-boot-part \
		--efi-boot-image --protective-msdos-label \
		$(ISO_DIR) -o $(ISO) >/dev/null 2>&1
	
	@echo "Installing Limine..."
	@$(MAKE) -C $(LIMINE_DIR) >/dev/null 2>&1 || \
		($(ZIG) cc $(LIMINE_DIR)/limine.c -o $(LIMINE_DIR)/limine && \
		$(LIMINE_DIR)/limine bios-install $(ISO))

# Cleanup
clean:
	rm -rf $(KERNEL_SRC)/.zig-cache
	rm -rf $(LIMINE_DIR)
	rm -rf $(ISO)
	rm -rf $(ISO_DIR)
	rm -f $(TARGET)
	rm -rf $(BUILD_DIR)

# Run in QEMU
run: iso
	qemu-system-x86_64 -cdrom $(ISO) -smp 2 -cpu host \
		-enable-kvm -vga virtio -serial stdio
