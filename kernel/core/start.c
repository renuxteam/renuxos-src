#include <stdint.h>

extern void kmain(void);

void _start(void) {
    kmain();
    
    while (1) {
        asm volatile ("hlt");
    }
}