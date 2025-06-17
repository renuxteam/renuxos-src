#include <stdint.h>     // Standard integer types
#include "port_io.h"     // I/O port read/write functions (inb/outb)
#include <sys/types.h>   // System type definitions

// Mapping of PS/2 scancodes to ASCII characters
static const char scancode_table[128] = {
    0,   27, '1','2','3','4','5','6','7','8','9','0','-','=', '\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n', 0,
    'a','s','d','f','g','h','j','k','l',';','\'','`', 0, '\\',
    'z','x','c','v','b','n','m',',','.','/', 0, '*', 0, ' ',
    0,
};

void keyboard_handler() {
    // Read the scancode from the PS/2 data port
    uint8_t scancode = inb(0x60);

    // If highest bit is set, it's a key release event
    if (scancode & 0x80) {
        // Key release detected, currently ignored
    } else {
        // Key press detected, translate scancode to ASCII
        char c = scancode_table[scancode];
        // Here you could call a function to print or buffer 'c'
    }
}
