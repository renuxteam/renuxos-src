# Root Makefile for RenuxOS (C version)

CC = zig cc
LD = zig ld.lld
JOBS = $(shell nproc)

TARGET = kernel.elf
ISO = renuxos.iso
BUILD_DIR = obj
LIMINE_DIR = /tmp/limine
ISO_DIR = /tmp/renuxos_iso

LDFLAGS = -T linker/linker.ld -LTO -nostdlib -static -z max-page-size=0x1000

.PHONY: all build iso clean run drivers kernel tools libc

all: build

# Build drivers + kernel + link
build: kernel drivers libc tools
	$(LD) $(LDFLAGS) $(shell find kernel/obj -name '*.o') $(shell find drivers/obj -name '*.o')  $(shell find libc/obj -name '*.o')  $(shell find tools/obj -name '*.o') -o $(TARGET)

# Build all drivers
drivers:
	$(MAKE) -C drivers -j$(JOBS)

# Build kernel
kernel:
	$(MAKE) -C kernel -j$(JOBS)

# Build tools
tools:
	$(MAKE) -C tools -j$(JOBS)

# Build libc
libc:
	$(MAKE) -C libc -j$(JOBS)

# Create ISO using Limine
iso: build
	@echo "==> Cloning Limine..."
	@git clone --branch v9.x-binary --depth 1 \
		https://codeberg.org/Limine/Limine.git $(LIMINE_DIR) >/dev/null 2>&1 || true

	@echo "==> Preparing ISO structure..."
	@mkdir -pv $(ISO_DIR)/EFI/BOOT $(ISO_DIR)/boot

	@echo "==> Copying Limine files..."
	@cp -f $(LIMINE_DIR)/BOOTX64.EFI $(LIMINE_DIR)/limine-*-cd.bin \
		$(LIMINE_DIR)/limine-bios.sys $(ISO_DIR)/
	@mv $(ISO_DIR)/BOOTX64.EFI $(ISO_DIR)/EFI/BOOT/

	@cp -v limine.conf $(ISO_DIR)/boot/
	@cp -v $(TARGET) $(ISO_DIR)/boot/

	@echo "==> Creating ISO..."
	@xorriso -as mkisofs -b limine-bios-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-uefi-cd.bin -efi-boot-part \
		--efi-boot-image --protective-msdos-label \
		$(ISO_DIR) -o $(ISO) >/dev/null 2>&1

	@echo "==> Installing Limine..."
	@$(MAKE) -C $(LIMINE_DIR) >/dev/null 2>&1 || \
		($(CC) $(LIMINE_DIR)/limine.c -o $(LIMINE_DIR)/limine && \
		$(LIMINE_DIR)/limine bios-install $(ISO))

# Clean everything
clean:
	@echo "==> Cleaning Project"
	@ rm -rf $(LIMINE_DIR) $(ISO_DIR) $(BUILD_DIR) $(ISO) $(TARGET)
	@ $(MAKE) -s -C drivers clean
	@ $(MAKE) -s -C kernel clean
	@ $(MAKE) -s -C libc clean
	@ $(MAKE) -s -C tools clean
	@echo "==> Done"

# Run in QEMU
run: iso
	@echo "==> Running QEMU..."
	qemu-system-x86_64 -cdrom $(ISO) -smp 2 -cpu host \
		--enable-kvm -serial stdio
