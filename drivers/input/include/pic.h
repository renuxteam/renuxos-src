#pragma once
#include <stdint.h>

// Initialize PIC (master + slave)
void pic_init();

// Enable specific IRQ line (0-15)
void pic_enable_irq(uint8_t irq);

// Disable specific IRQ line (0-15)
void pic_disable_irq(uint8_t irq);

// Send End of Interrupt (EOI)
void pic_send_eoi(uint8_t irq);
