.section .bss
    .align 16
    .global cpu_vendor
cpu_vendor:
    .space 12

    .global cpu_name
cpu_name:
    .space 48

.section .text
    .global detect_cpu
detect_cpu:
    xor    %eax, %eax
    cpuid
    mov    %ebx, cpu_vendor
    mov    %edx, cpu_vendor+4
    mov    %ecx, cpu_vendor+8

    mov    $0x80000002, %eax
    cpuid
    mov    %eax, cpu_name
    mov    %ebx, cpu_name+4
    mov    %ecx, cpu_name+8
    mov    %edx, cpu_name+12

    mov    $0x80000003, %eax
    cpuid
    mov    %eax, cpu_name+16
    mov    %ebx, cpu_name+20
    mov    %ecx, cpu_name+24
    mov    %edx, cpu_name+28

    mov    $0x80000004, %eax
    cpuid
    mov    %eax, cpu_name+32
    mov    %ebx, cpu_name+36
    mov    %ecx, cpu_name+40
    mov    %edx, cpu_name+44

    ret
