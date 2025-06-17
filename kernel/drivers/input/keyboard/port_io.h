#pragma once
#include <stdint.h>   // Standard integer types

// Read a byte from the specified I/O port
static inline uint8_t inb(uint8_t port) {
    uint8_t ret;
    __asm__ __volatile__(
        "inb %1, %0"     // assembly: read from port into ret
        : "=a"(ret)      // output operand: store in AL register (ret)
        : "Nd"(port)     // input operand: port number, immediate or DX
    );
    return ret;
}

// Write a byte to the specified I/O port
static inline void outb(uint16_t port, uint8_t val) {
    __asm__ __volatile__(
        "outb %0, %1"    // assembly: write val to port
        :                // no outputs
        : "a"(val),      // input operand: AL register holds val
          "Nd"(port)     // input operand: port number, immediate or DX
    );
}
