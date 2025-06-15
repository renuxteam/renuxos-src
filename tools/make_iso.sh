#!/usr/bin/bash
# This script creates an ISO image from the specified directory.
set -e

# Variabels
ISO_DIR="iso"
ISO_IMG="renuxos.iso"
BOOT_DIR="$ISO_DIR/boot"
GRUB_DIR="$BOOT_DIR/grub"

# Clean up previous ISO directory and create necessary directories
rm -rf $ISO_DIR
mkdir -p $GRUB_DIR

# Copy kernel and other necessary files
cp zig-out/bin/kernel $BOOT_DIR/kernel

# Create GRUB configuration
cat > $GRUB_DIR/grub.cfg << EOF
set timeout=5
set default=0

menuentry "RenuxOS" {
    multiboot2 /boot/kernel
    set gfxpayload=text
    boot
}
EOF

# Generate the ISO image
grub-mkrescue -o $ISO_IMG $ISO_DIR

echo "ISO generated successfully: $ISO_IMG"
