.section .text
.global _start

_start:
    cli                     # Disable interrupts

    # Setup stack pointer (adjust as needed)
    lea stack_top(%rip), %rsp

    # Load Global Descriptor Table (GDT)
    lgdt gdt_descriptor

    # Enable protected mode by setting PE bit in CR0
    mov %cr0, %rax
    orq $0x1, %rax           # Set PE (Protection Enable)
    mov %rax, %cr0

    # Load segment registers with 64-bit code/data selectors
    mov $0x10, %ax          # Code/Data segment selector
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss
    mov %ax, %fs
    mov %ax, %gs

    # Enable PAE (Physical Address Extension)
    mov %cr4, %rax
    orq $0x20, %rax          # Set PAE bit
    mov %rax, %cr4

    # Load PML4 address into CR3
    mov $pml4_table, %rax
    mov %rax, %cr3

    # Enable paging by setting PG bit in CR0 (use 32-bit op to avoid invalid immediate)
    mov %cr0, %rax
    orl $0x80000000, %eax    # Set PG (Paging) bit
    mov %rax, %cr0

    # Enable Long Mode (LME) in EFER MSR
    mov $0xC0000080, %ecx    # MSR EFER
    rdmsr
    or $0x100, %eax          # Set LME bit
    wrmsr

    # Far jump to clear prefetch and enter 64-bit long mode via lretq
    pushq $0x08              # Code segment selector
    lea long_mode_entry(%rip), %rax
    pushq %rax               # Offset
    lretq                    # Far return to load CS:IP

# Data section
.section .data
.align 8

pml4_table:
    .quad pdpt_table + 3       # Present + RW flags
    .zero 511*8

pdpt_table:
    .quad pd_table + 3         # Present + RW flags
    .zero 511*8

pd_table:
    .quad 0x00000000800083     # 2MB page + present + RW + PS
    .zero 511*8

# GDT for 64-bit code and data
.section .rodata
.align 16
gdt:
    .quad 0x0000000000000000  # Null descriptor
    .quad 0x00AF9A000000FFFF  # 64-bit code segment
    .quad 0x00AF92000000FFFF  # 64-bit data segment

gdt_descriptor:
    .word 23                  # Size of GDT minus 1
    .quad gdt

.section .bss
.align 16
stack_bottom:
    .skip 16384               # 16 KiB stack
stack_top: