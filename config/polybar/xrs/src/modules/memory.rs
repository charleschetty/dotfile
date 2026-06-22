// modules/memory.rs — RAM usage %
//
// All its logic is here — nothing in mod.rs.

use super::*;

pub struct MemState { pub pct: Option<i32> }

fn read_pct() -> Option<i32> {
    let s = std::fs::read_to_string("/proc/meminfo").ok()?;
    let mut total = 0i64; let mut avail = 0i64;
    for line in s.lines() {
        if line.starts_with("MemTotal:") { total = line.split_whitespace().nth(1)?.parse().ok()?; }
        else if line.starts_with("MemAvailable:") { avail = line.split_whitespace().nth(1)?.parse().ok()?; }
    }
    if total == 0 { None } else { Some(((total - avail) * 100 / total) as i32) }
}

pub fn update(state: &mut AppState) { state.mem.pct = read_pct(); }

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let text = state.mem.pct.map(|mp| format!("{} {}%", ICON_MEM.to_str().unwrap(), mp)).unwrap_or_default();
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module { draw, update: Some(update) };
