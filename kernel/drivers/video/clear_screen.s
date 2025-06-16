# void clear_screen();
.global clear_screen
.type clear_screen, @function
clear_screen:
    push %di
    push %ax
    push %cx

    mov $0xB8000, %di        # DI = VGA memory
    mov $0x1F20, %ax         # AX = ' ' (0x20) com atributo 0x1F (fundo azul, texto branco)
    mov $2000, %cx           # 80x25 = 2000 caracteres

clear_loop:
    stosw                    # Armazena AX em [DI], DI += 2
    loop clear_loop

    pop %cx
    pop %ax
    pop %di
    ret
