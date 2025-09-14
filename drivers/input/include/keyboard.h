#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <stdint.h>

// Initialize keyboard (stub for now)
void keyboard_init(void);

// Keyboard IRQ / polling handler
void keyboard_handler(void);

#endif // KEYBOARD_H
