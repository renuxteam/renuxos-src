#include <stdint.h>
#include "../../drivers/video/include/framebuffer.h"
#include "../../drivers/input/include/keyboard.h"


void kmain(void) {
    fb_init();
    fb_clear(0x00404040);
    fb_draw_string(40, 40, "RenuxOS in C");
    keyboard_init();
}