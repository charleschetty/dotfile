fn main() {
    cc::Build::new()
        .file("c_src/pulse_volume.c")
        .compile("pulse_volume");
    println!("cargo:rustc-link-lib=pulse");
}
