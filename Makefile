CC ?= gcc


build:
	mkdir out;
	cd kernel; \
	zig build;  \
	cd ..
	cd out; \
	${CC} -c ../kernel/drivers/video/framebuffer/framebuffer.c -I../kernel/drivers/video/framebuffer/include/ -o framebuffer.o; \
	${CC} -c ../boot/x86_64/limine_request.c -o limine_request.o; \
	ld -T ../linker/linker.ld kernel.o framebuffer.o limine_request.o -o kernel.elf; \
	cd ..; \
	mv out/kernel.elf .; \
	rm -rf out;

iso: build
	git clone --branch v9.x-binary --depth 1 https://codeberg.org/Limine/Limine.git /tmp/limine 
	mkdir -p /tmp/renuxos_iso/EFI/BOOT
	mkdir -p /tmp/renuxos_iso/boot/
	cp -f /tmp/limine/BOOTX64.EFI /tmp/limine/limine-uefi-cd.bin /tmp/limine/limine-bios-cd.bin /tmp/limine/limine-bios.sys /tmp/renuxos_iso
	mv /tmp/renuxos_iso/BOOTX64.EFI /tmp/renuxos_iso/EFI/BOOT/BOOTX64.EFI
	cp ./boot/x86_64/limine.conf /tmp/renuxos_iso/boot/
	cp ./kernel.elf /tmp/renuxos_iso/boot/

	xorriso -as mkisofs -b limine-bios-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table --efi-boot limine-uefi-cd.bin -efi-boot-part --efi-boot-image --protective-msdos-label /tmp/renuxos_iso -o renuxos.iso
	zig cc /tmp/limine/limine.c -o /tmp/limine/limine
	/tmp/limine/limine bios-install renuxos.iso

	
clean:
	rm -rf kernel/.zig-cache
	rm -rf /tmp/limine
	rm -rf renuxos.iso
	rm -rf /tmp/renuxos_iso
	rm -rf kernel.elf
	rm -rf out

run: iso
	qemu-system-x86_64 -cdrom renuxos.iso -smp 2 -cpu host --enable-kvm -vga virtio

all: build