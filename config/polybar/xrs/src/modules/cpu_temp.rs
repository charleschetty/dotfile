// modules/cpu_temp.rs — CPU temperature
//
// All its logic is here — nothing in mod.rs.

use super::*;

pub struct TempState { pub value: Option<i32> }

fn read_temp(zone: &str) -> Option<i32> {
    super::read_int(&format!("/sys/class/thermal/{}/temp", zone)).map(|v| v / 1000)
}

pub fn update(state: &mut AppState) { state.temp.value = read_temp("thermal_zone8"); }

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let text = state.temp.value.map(|t| format!("{} {}\u{00B0}C", ICON_TEMP.to_str().unwrap(), t)).unwrap_or_default();
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module { draw, update: Some(update) };
