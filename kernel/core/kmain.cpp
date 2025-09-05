#include "../drivers/video/vga/vga.hpp"

static const char klogo[] = R"(
.------------------------------------------------.
|    ____                             ____  _____|
|   / __ \___  _  ______  __  ___  __/ __ \/ ___/|
|  / /_/ / _ \| |/_/ __ \/ / / / |/_/ / / /\__ \ |
| / _, _/  __/>  </ / / / /_/ />  </ /_/ /___/ / |
|/_/ |_|\___/_/|_/_/ /_/\__,_/_/|_|\____//____/  |
'------------------------------------------------'
)";




void loop() {
    while (true) {
        asm("hlt");
    }
}

extern "C" void kmain(void) {
    VGA vga;
    vga.clear();
    vga.fill(' ', VGA::Color::Yellow,VGA::Color::Black);
    vga.print(klogo);
    vga.print("RenuxOS kernel in C++");

    loop();
}

