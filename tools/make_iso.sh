#!/usr/bin/env bash

# Variables
ISO_DIR="iso"
OUT_ISO="renuxos.iso"

KERNEL="build/renuxos.elf"

# Copy kernel to ISO directory
cp "$KERNEL" "$ISO_DIR/boot/"

# Generate ISO using GRUB
grub-mkrescue -o "$OUT_ISO" "$ISO_DIR"
