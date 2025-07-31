# Makefile for Renux Operating System: build, create ISO, and run in QEMU

.PHONY: all build iso run clean help

# Default target
all: build

# Compile the kernel (and any other artifacts) via Zig using all cores
build:
	zig build

# After building, generate the ISO image
iso: build
	./tools/make_iso.sh

# Build ISO (if needed) and launch QEMU with the resulting CD image
run: iso
	qemu-system-i386 -cdrom renuxos.iso --enable-kvm -vga virtio

# Clean build outputs and ISO
clean:
	rm -f renuxos.iso
	rm -rf .zig-cache
	rm -rf zig-out
	rm -f iso/boot/kernel.elf

# Display help for available targets
help:
	@echo "RenuxOS Makefile Commands:"
	@echo "  make build   - Compile the kernel via Zig"
	@echo "  make iso     - Generate the ISO image after build"
	@echo "  make run     - Build ISO (if needed) and launch QEMU"
	@echo "  make clean   - Remove build outputs and ISO"
	@echo "  make help    - Show this help message"
