#include "./include/keyboard.h"
#include "./include/idt.h"
#include "./include/pic.h"
#include "../video/include/framebuffer.h"
#include <stdint.h>

#define KBD_DATA_PORT 0x60

// Simple scancode map (alfa minúscula + números)
char scancode_to_ascii[128] = {
    0, 27, '1','2','3','4','5','6','7','8','9','0','-','=','\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',
    0,'a','s','d','f','g','h','j','k','l',';','\'','`',
    0,'\\','z','x','c','v','b','n','m',',','.','/',0,
    '*',0,' ',0
};

static inline unsigned char inb(uint16_t port) {
    unsigned char ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}


void keyboard_init() {
    idt_init();
    pic_init();
    idt_register_interrupt_handler(0x21, keyboard_handler);
    pic_enable_irq(1);
}

void keyboard_handler() {
    unsigned char scancode = inb(KBD_DATA_PORT);

    if (scancode & 0x80) return; // key release

    char c = scancode_to_ascii[scancode];
    if (c) {
        fb_put_char_cursor(c, 0xFFFFFFFF); // white
    }
}
