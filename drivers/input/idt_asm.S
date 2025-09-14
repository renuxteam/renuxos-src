.global load_idt
load_idt:
    mov %rdi, %rax        
    lidt (%rax)           
    ret
