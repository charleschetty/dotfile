// config.rs — edit this file to change appearance and module layout.
//
// To add a custom module, add it to LEFT / CENTER / RIGHT below.

use std::ffi::CStr;

use crate::modules::Module;

// ── font & sizes ──

pub const FONT: &CStr = c"JetBrainsMono NF";
pub const FONT_SIZE_MAIN: f64 = 15.0;
pub const FONT_SIZE_ICON: f64 = 14.0;
pub const BAR_HEIGHT: i32 = 36;

// ── spacing ──

pub const GAP: f64 = 12.0;
pub const WS_PAD: f64 = 12.0;
pub const WS_GAP: f64 = 4.0;

// ── colours ──

pub const BG_R: f64 = 0x2e as f64 / 255.0;
pub const BG_G: f64 = 0x34 as f64 / 255.0;
pub const BG_B: f64 = 0x40 as f64 / 255.0;
pub const FG_R: f64 = 1.0;
pub const FG_G: f64 = 1.0;
pub const FG_B: f64 = 1.0;

// ── features ──

/// Set to `false` to disable system tray.
pub const TRAY: bool = true;

/// Set to `false` to disable workspace display and IPC entirely.
pub const WORKSPACE: bool = true;

/// Window manager type.  Supported: `"i3"`, `"sway"`.
pub const WORKSPACE_TYPE: &str = "i3";

// ── module layout ──

pub static LEFT: &[Module] = &[
    crate::modules::arch::MODULE,
    crate::modules::workspace::MODULE,
];

pub static CENTER: &[Module] = &[
    crate::modules::clock::MODULE,
];

pub static RIGHT: &[Module] = &[
    crate::modules::network::MODULE,
    crate::modules::cpu::MODULE,
    crate::modules::memory::MODULE,
    crate::modules::brightness::MODULE,
    crate::modules::cpu_temp::MODULE,
    crate::modules::volume::MODULE,
    crate::modules::nvidia::MODULE,
    crate::modules::battery::MODULE,
];
