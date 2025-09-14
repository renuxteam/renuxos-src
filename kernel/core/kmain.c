#include <stdint.h>
#include "../console/include/console.h"
#include "../../drivers/video/include/color.h"
#include "../../drivers/video/include/framebuffer.h"


void kmain(void) {
    fb_init();
    console_init();
    console_clear();
    fb_clear(COLOR_GRAY);
    console_write("Hello RenuxOS");
}