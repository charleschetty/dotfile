// modules/volume.rs — PulseAudio volume
//
// All its logic is here — nothing in mod.rs.

use super::*;

pub struct VolumeState {
    pub pct: Option<i32>,
    pub muted: bool,
}

fn read_volume() -> VolumeState {
    let mut vol: i32 = -1; let mut muted: i32 = 0;
    unsafe { crate::util::pulse_read_volume(&mut vol, &mut muted) };
    if vol < 0 { VolumeState { pct: None, muted: false } }
    else { VolumeState { pct: Some(vol), muted: muted != 0 } }
}

pub fn update(state: &mut AppState) {
    state.vol = read_volume();
}

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let text = state.vol.pct.map(|v| {
        let ico = if state.vol.muted { ICON_MUTE } else { ICON_VOL };
        let vv = if state.vol.muted { 0 } else { v };
        format!("{} {}%", ico.to_str().unwrap(), vv)
    }).unwrap_or_default();
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module { draw, update: Some(update) };
