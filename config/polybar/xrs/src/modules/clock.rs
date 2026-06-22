// modules/clock.rs — HH:MM:SS

use super::*;

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, _state: &AppState, dry_run: bool) -> f64 {
    let text = chrono::Local::now().format("%H:%M:%S").to_string();
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module { draw, update: None };
