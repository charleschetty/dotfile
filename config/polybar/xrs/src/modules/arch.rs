// modules/arch.rs — Arch Linux icon

use super::*;

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, _state: &AppState, dry_run: bool) -> f64 {
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, ICON_ARCH.to_str().unwrap(), dry_run)
}

pub const MODULE: Module = Module { draw, update: None };
