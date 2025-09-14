#pragma once
#include <stdint.h>

void idt_init();
void idt_register_interrupt_handler(uint8_t n, void (*handler)());
