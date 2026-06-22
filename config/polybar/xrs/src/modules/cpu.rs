// modules/cpu.rs — CPU usage %
//
// All its logic is here — nothing in mod.rs.

use super::*;

pub struct CpuState {
    prev_total: i64,
    prev_idle: i64,
    pub pct: Option<i32>,
}

impl CpuState {
    pub const fn new() -> Self { CpuState { prev_total: 0, prev_idle: 0, pct: None } }
    fn read(&mut self) {
        let s = match std::fs::read_to_string("/proc/stat") { Ok(s) => s, Err(_) => return };
        let line = match s.lines().next() { Some(l) => l, None => return };
        let parts: Vec<&str> = line.split_whitespace().collect();
        if parts.len() < 9 || parts[0] != "cpu" { return; }
        // user, nice, system, idle, steal  (same fields polybar uses for total)
        let fields: [usize; 5] = [1, 2, 3, 4, 8];
        let vals: Vec<i64> = fields.iter().filter_map(|&i| parts.get(i).and_then(|s| s.parse().ok())).collect();
        if vals.len() < 5 { return; }
        let total: i64 = vals.iter().sum();
        let idle = vals[3];
        if self.prev_total == 0 { self.prev_total = total; self.prev_idle = idle; return; }
        let dtotal = total - self.prev_total; let didle = idle - self.prev_idle;
        self.prev_total = total; self.prev_idle = idle;
        self.pct = if dtotal == 0 { None } else { Some(((dtotal - didle) * 100 / dtotal) as i32) };
    }
}

pub fn update(state: &mut AppState) { state.cpu.read(); }

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let text = state.cpu.pct.map(|cp| format!("{} {}%", ICON_CPU.to_str().unwrap(), cp)).unwrap_or_default();
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module { draw, update: Some(update) };
