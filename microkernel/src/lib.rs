#![no_std]
#![no_main]

#[unsafe(no_mangle)]
pub extern "C" fn microkernel_hello() {
    // Just a placeholder function
    // Later you can expand this into process manager, IPC etc.
}

#[panic_handler]
fn panic(_: &core::panic::PanicInfo) -> ! {
    loop {}
}
