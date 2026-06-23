// util.rs — small helpers available everywhere

pub fn read_int(path: &str) -> Option<i32> {
    std::fs::read_to_string(path)
        .ok()
        .and_then(|s| s.trim().parse().ok())
}

pub unsafe fn pulse_read_volume(vol: *mut i32, muted: *mut i32) {
    unsafe extern "C" {
        fn read_volume_both(vol: *mut i32, muted: *mut i32);
    }
    unsafe {
        read_volume_both(vol, muted);
    }
}
