#include "drivers/video/vga/vga.hpp"



void loop() {
    while (true) {
        asm("hlt");
    }
}

extern "C" void kmain(void) {
    VGA vga;
    vga.clear();
    vga.fill(' ', VGA::Color::Red,VGA::Color::Blue);
    vga.write("RenuxOS in C++");

    loop();
}

