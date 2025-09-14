#include "./include/idt.h"

typedef struct {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t ist;
    uint8_t type_attr;
    uint16_t offset_mid;
    uint32_t offset_high;
    uint32_t zero;
} __attribute__((packed)) idt_entry_t;

typedef struct {
    uint16_t limit;
    uint64_t base;
} __attribute__((packed)) idt_ptr_t;

#define IDT_SIZE 256
static idt_entry_t idt[IDT_SIZE];
static idt_ptr_t idt_ptr;

extern void load_idt(uint64_t);

static void set_idt_gate(int n, void (*handler)()) {
    uint64_t addr = (uint64_t)handler;
    idt[n].offset_low = addr & 0xFFFF;
    idt[n].selector = 0x08; // kernel code segment
    idt[n].ist = 0;
    idt[n].type_attr = 0x8E; // interrupt gate
    idt[n].offset_mid = (addr >> 16) & 0xFFFF;
    idt[n].offset_high = (addr >> 32) & 0xFFFFFFFF;
    idt[n].zero = 0;
}

void idt_register_interrupt_handler(uint8_t n, void (*handler)()) {
    set_idt_gate(n, handler);
}

void idt_init() {
    idt_ptr.limit = sizeof(idt_entry_t) * IDT_SIZE - 1;
    idt_ptr.base = (uint64_t)&idt;
    // zero out IDT
    for (int i = 0; i < IDT_SIZE; i++) idt_register_interrupt_handler(i, 0);
    load_idt((uint64_t)&idt_ptr);
}
