// ----------------------------------------------------------------
// ASCII art logo
// ----------------------------------------------------------------
// Stored as a pointer to a fixed-size, null-terminated byte array.
// The leading "\\" escapes each backslash so that the art is
// embedded exactly as written.
pub const logo_ascii: *const [300:0]u8 = (
    \\
    \\ _____                             ____    _____ 
    \\|  __ \                           / __ \  / ____|
    \\| |__) | ___  _ __   _   _ __  __| |  | || (___  
    \\|  _  / / _ \| '_ \ | | | |\ \/ /| |  | | \___ \ 
    \\| | \ \|  __/| | | || |_| | >  < | |__| | ____) |
    \\|_|  \_\\___||_| |_| \__,_|/_/\_\ \____/ |_____/ 
);
