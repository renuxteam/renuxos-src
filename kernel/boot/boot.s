.section .multiboot_header
.align 8
header_start:
    .long 0xe85250d6                # Multiboot 2 magic number
    .long 0                         # Architecture 0 (i386 protected mode)
    .long header_end - header_start # Header length
    
    # Checksum
    .long -(0xe85250d6 + 0 + (header_end - header_start))
    
    # Required end tag
    .word 0    # Type
    .word 0    # Flags
    .long 8    # Size
header_end:

.section .text
.global _start
.extern _zig_start

_start:
    mov $stack_top, %esp
    
    # Verify Multiboot 2 magic number
    cmpl $0x36d76289, %eax
    jne no_multiboot
    
    push %ebx    # Pass Multiboot info structure pointer
    call _zig_start
    
1:
    cli
    hlt
    jmp 1b

no_multiboot:    # Added label definition
    # Handle case where we weren't loaded by a Multiboot2-compliant bootloader
    movl $0x4f524f45, 0xb8000  # Display 'ERR' in red on white
    movl $0x4f3a4f52, 0xb8004
    movl $0x4f204f20, 0xb8008
    cli
1:  hlt
    jmp 1b
.section .bss
.align 16
stack_bottom:
    .skip 16384
stack_top: