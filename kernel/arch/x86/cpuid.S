.section .bss
    # ----------------------------------------------------------------
    # Uninitialized data: CPU vendor and brand name buffers
    # ----------------------------------------------------------------
    .align 16
    .global cpu_vendor
cpu_vendor:
    .space 12                # reserve 12 bytes for the vendor ID string

    .global cpu_name
cpu_name:
    .space 48                # reserve 48 bytes for the full brand name string

.section .text
    # ----------------------------------------------------------------
    # detect_cpu: populate cpu_vendor and cpu_name via CPUID
    # ----------------------------------------------------------------
    .global detect_cpu
detect_cpu:
    # Leaf 0: CPU vendor ID
    xor    %eax, %eax        # EAX = 0
    cpuid                    # call CPUID
    mov    %ebx, cpu_vendor  # store EBX into vendor[0..4]
    mov    %edx, cpu_vendor+4# store EDX into vendor[4..8]
    mov    %ecx, cpu_vendor+8# store ECX into vendor[8..12]

    # Leaf 0x80000002: first 16 bytes of brand string
    mov    $0x80000002, %eax # EAX = 0x80000002
    cpuid                    # call CPUID
    mov    %eax, cpu_name    # name[0..4]
    mov    %ebx, cpu_name+4  # name[4..8]
    mov    %ecx, cpu_name+8  # name[8..12]
    mov    %edx, cpu_name+12 # name[12..16]

    # Leaf 0x80000003: next 16 bytes of brand string
    mov    $0x80000003, %eax
    cpuid
    mov    %eax, cpu_name+16 # name[16..20]
    mov    %ebx, cpu_name+20 # name[20..24]
    mov    %ecx, cpu_name+24 # name[24..28]
    mov    %edx, cpu_name+28 # name[28..32]

    # Leaf 0x80000004: final 16 bytes of brand string
    mov    $0x80000004, %eax
    cpuid
    mov    %eax, cpu_name+32 # name[32..36]
    mov    %ebx, cpu_name+36 # name[36..40]
    mov    %ecx, cpu_name+40 # name[40..44]
    mov    %edx, cpu_name+44 # name[44..48]

    ret                      # return to caller
