.global get_scancode

get_scancode:
    inb $0x60, %al
    movzbl %al, %eax
    ret