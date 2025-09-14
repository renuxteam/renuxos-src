#include <stdint.h>
#include <string.h>
#include "../console/include/console.h"
#include "../../drivers/video/include/color.h"
#include "../../drivers/video/include/framebuffer.h"

const char *ascii_logo = R"(
 _____                        ____   _____ 
|  __ \                      / __ \ / ____|
| |__) |___ _ __  _   ___  _| |  | | (___  
|  _  // _ \ '_ \| | | \ \/ / |  | |\___ \ 
| | \ \  __/ | | | |_| |>  <| |__| |____) |
|_|  \_\___|_| |_|\__,_/_/\_\\____/|_____/ 
)";
void init_drivers(void) {
    fb_init();
    console_init();
}

void init_graphics(void) {
    fb_clear(COLOR_DARK_GRAY);
    console_set_text_color(COLOR_CYAN);
}


void kmain(void) {
    init_drivers();
    init_graphics();
    println(ascii_logo);
    println("RenuxOS v0.1 Aurora");
    println("Welcome to Renux Shell");
}

