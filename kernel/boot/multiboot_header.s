.section .multiboot_header
.align 4
.long 0x1BADB002       # magic number
.long 0x0              # flags
.long -(0x1BADB002 + 0x0) # checksum
