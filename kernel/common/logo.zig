const vga: type = @import("../drivers/video/vga/vga.zig"); // Import VGA text-mode driver
const color: type = vga.Color; // Alias VGA color definitions

// ASCII art logo stored as a pointer to a fixed-size byte array
pub const logo: *const [300:0]u8 = (
    \\
    \\ _____                             ____    _____ 
    \\|  __ \                           / __ \  / ____|
    \\| |__) | ___  _ __   _   _ __  __| |  | || (___  
    \\|  _  / / _ \| '_ \ | | | |\ \/ /| |  | | \___ \ 
    \\| | \ \|  __/| | | || |_| | >  < | |__| | ____) |
    \\|_|  \_\\___||_| |_| \__,_|/_/\_\ \____/ |_____/ 
);

// Sets text colors and prints the ASCII logo to the screen
pub fn print_logo() void {
    vga.setColor(color.Green, color.Black); // Foreground=Green, Background=Black
    vga.write(logo); // Render the logo string via VGA driver
}
