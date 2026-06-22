// modules/battery.rs — battery level
//
// All its logic is here — nothing in mod.rs.

use super::*;

pub struct BatteryState {
    pub pct: Option<i32>,
    pub status: String,
}

fn read_pct() -> Option<i32> { super::read_int("/sys/class/power_supply/BAT0/capacity") }

fn read_status() -> String {
    std::fs::read_to_string("/sys/class/power_supply/BAT0/status")
        .map(|s| s.trim().to_string()).unwrap_or_default()
}

pub fn update(state: &mut AppState) {
    state.bat.pct    = read_pct();
    state.bat.status = read_status();
}

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let text = state.bat.pct.map(|bp| {
        let ico = if bp > 20 { ICON_BAT.to_str().unwrap() } else { ICON_BATL.to_str().unwrap() };
        format!("{} {}%", ico, bp)
    }).unwrap_or_default();
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module { draw, update: Some(update) };
