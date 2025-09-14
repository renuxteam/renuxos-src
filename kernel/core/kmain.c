#include <stdint.h>
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


void kmain(void) {
    fb_init();
    console_init();
    console_clear();
    fb_clear(COLOR_BLACK);
    console_set_text_color(COLOR_RED);
    console_write(ascii_logo);
    console_putchar('\n');
    console_write("RenuxOS v0.1 Aurora \n");
}