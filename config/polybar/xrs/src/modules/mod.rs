// modules/mod.rs — framework core
//
// To add a custom module:
//   1. Add its state struct to AppState below and AppState::new()
//   2. Create a file like modules/my_thing.rs (see battery.rs for template)
//   3. Add `pub mod my_thing;` below

pub mod arch;
pub mod battery;
pub mod brightness;
pub mod clock;
pub mod cpu;
pub mod cpu_temp;
pub mod memory;
pub mod network;
pub mod nvidia;
pub mod volume;
pub mod workspace;

use crate::config;
use crate::modules::workspace::i3::Workspace;

// re-export framework helpers so module files can `use super::*`
pub use crate::draw::{rrect, simple_draw};
pub use crate::icons::*;
pub use crate::util::read_int;

pub struct AppState {
    pub i3workspace: Option<Vec<Workspace>>,

    pub gpu: nvidia::GpuStats,
    pub cpu: cpu::CpuState,
    pub mem: memory::MemState,
    pub temp: cpu_temp::TempState,
    pub bright: brightness::BrightState,
    pub bat: battery::BatteryState,
    pub vol: volume::VolumeState,
    pub net: network::NetState,
}

impl AppState {
    pub fn new() -> Self {
        AppState {
            i3workspace: None,
            gpu: nvidia::GpuStats {
                gpu: 0,
                mem: 0,
                vram: 0,
                temp: 0,
                valid: false,
            },
            cpu: cpu::CpuState::new(),
            mem: memory::MemState { pct: None },
            temp: cpu_temp::TempState { value: None },
            bright: brightness::BrightState { pct: None },
            bat: battery::BatteryState {
                pct: None,
                status: String::new(),
            },
            vol: volume::VolumeState {
                pct: None,
                muted: false,
            },
            net: network::NetState::new(),
        }
    }
}

pub type DrawFn = fn(cr: &cairo::Context, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64;

pub type UpdateFn = fn(&mut AppState);

#[derive(Copy, Clone)]
pub struct Module {
    pub draw: DrawFn,
    pub update: Option<UpdateFn>,
}
