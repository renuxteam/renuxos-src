#!/usr/bin/bash

# Variabels
ISO_BUILD="iso"
KERNEL="zig-out/bin/kernel.elf"
OUT_ISO="renuxos.iso"

cp $KERNEL $ISO_BUILD

xorriso -as mkisofs   -b limine-bios-cd.bin   -no-emul-boot -boot-load-size 4 -boot-info-table   --efi-boot limine-uefi-cd.bin   -efi-boot-part --efi-boot-image --protective-msdos-label   $ISO_BUILD -o $OUT_ISO