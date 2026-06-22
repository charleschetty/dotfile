// modules/brightness.rs — screen brightness %
//
// All its logic is here — nothing in mod.rs.

use super::*;

pub struct BrightState { pub pct: Option<i32> }

fn read_pct() -> Option<i32> {
    let cur = super::read_int("/sys/class/backlight/intel_backlight/actual_brightness")?;
    let max = super::read_int("/sys/class/backlight/intel_backlight/max_brightness")?;
    if max <= 0 { None } else { Some(cur * 100 / max) }
}

pub fn update(state: &mut AppState) { state.bright.pct = read_pct(); }

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let text = state.bright.pct.map(|bp| format!("{} {}%", ICON_SUN.to_str().unwrap(), bp)).unwrap_or_default();
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module { draw, update: Some(update) };
