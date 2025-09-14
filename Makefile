# Root Makefile for RenuxOS

CC = clang
LD = ld.lld
ZIG = zig

TARGET = kernel.elf
ISO = renuxos.iso
BUILD_DIR = obj
LIMINE_DIR = /tmp/limine
ISO_DIR = /tmp/renuxos_iso
KERNEL_SRC = kernel

LDFLAGS = -T linker/linker.ld -nostdlib -static -z max-page-size=0x1000

.PHONY: all build iso clean run drivers

# Main target: build drivers + kernel + link
all: build

build: drivers $(BUILD_DIR)/kernel.o $(TARGET)

# Compile kernel (Zig)
$(BUILD_DIR)/kernel.o:
	@mkdir -p $(BUILD_DIR)
	cd $(KERNEL_SRC) && $(ZIG) build

# Link kernel + drivers
$(TARGET): $(BUILD_DIR)/kernel.o
	$(LD) $(LDFLAGS) $(BUILD_DIR)/kernel.o $(shell find drivers/obj -name '*.o') -o $@

# Build all drivers
drivers:
	$(MAKE) -C drivers

# Create ISO using Limine
iso: build
	@echo "==> Cloning Limine..."
	git clone --branch v9.x-binary --depth 1 \
		https://codeberg.org/Limine/Limine.git $(LIMINE_DIR) >/dev/null 2>&1 || true
	
	mkdir -v -p $(ISO_DIR)/EFI/BOOT
	mkdir -v -p $(ISO_DIR)/boot
	
	cp -f $(LIMINE_DIR)/BOOTX64.EFI $(LIMINE_DIR)/limine-*-cd.bin \
		$(LIMINE_DIR)/limine-bios.sys $(ISO_DIR)/
	mv $(ISO_DIR)/BOOTX64.EFI $(ISO_DIR)/EFI/BOOT/
	
	cp -v limine.conf $(ISO_DIR)/boot/
	cp -v $(TARGET) $(ISO_DIR)/boot/
	
	xorriso -as mkisofs -b limine-bios-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-uefi-cd.bin -efi-boot-part \
		--efi-boot-image --protective-msdos-label \
		$(ISO_DIR) -o $(ISO) >/dev/null 2>&1
	
	$(MAKE) -C $(LIMINE_DIR) >/dev/null 2>&1 || \
		($(ZIG) cc $(LIMINE_DIR)/limine.c -o $(LIMINE_DIR)/limine && \
		$(LIMINE_DIR)/limine bios-install $(ISO))

# Clean everything
clean:
	rm -rf $(KERNEL_SRC)/.zig-cache
	rm -rf $(LIMINE_DIR)
	rm -rf $(ISO)
	rm -rf $(ISO_DIR)
	rm -f $(TARGET)
	rm -rf $(BUILD_DIR)
	$(MAKE) -C drivers clean

# Run in QEMU
run: iso
	qemu-system-x86_64 -cdrom $(ISO) -smp 2 -cpu host \
		--enable-kvm -serial stdio
