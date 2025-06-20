#!/usr/bin/env bash

# Variables
ISO_DIR="iso"
KERNEL="zig-out/bin/kernel.elf"
OUT_ISO="renuxos.iso"

# Copy kernel to ISO directory
cp "$KERNEL" "$ISO_DIR/boot/"

# Generate ISO using GRUB
grub-mkrescue -o "$OUT_ISO" "$ISO_DIR"
