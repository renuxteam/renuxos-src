.section .multiboot
.align 4
    .long 0x1BADB002        # Multiboot Magic
    .long 0x00000003        # Flags: memory info + boot device
    .long -(0x1BADB002 + 0x00000003)

.section .text
.global _start
.extern _zig_start

_start:
    mov $stack_top, %esp       # <-- inicializa a stack!
    call _zig_start            # chama o kernel
1:
    cli
    hlt
    jmp 1b

.section .bss
.align 16
stack_bottom:
    .skip 16384                # 16 KiB de pilha (pode aumentar depois)
stack_top:
