#[repr(C)]
pub struct MicrokernelInfo {
    pub version_major: u8,
    pub version_minor: u8,
    pub build_id: u32,
    pub name_ptr: *const u8,
}

#[unsafe(no_mangle)]
pub extern "C" fn get_microkernel_info() -> MicrokernelInfo {
    MicrokernelInfo {
        version_major: 0,
        version_minor: 1,
        build_id: 1337,
        name_ptr: b"RenuxMicroKernel\0".as_ptr(),
    }
}
