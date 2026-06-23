// modules/nvidia.rs — GPU usage / memory / VRAM / temperature
//
// All its logic is here — nothing in mod.rs.  NVML is initialised lazily on first use.

use super::*;
use std::sync::Mutex;

static NVML: Mutex<Option<nvml_wrapper::Nvml>> = Mutex::new(None);

#[derive(Clone)]
pub struct GpuStats {
    pub gpu: i32,
    pub mem: i32,
    pub vram: i32,
    pub temp: i32,
    pub valid: bool,
}

fn query_gpu(nvml: &nvml_wrapper::Nvml) -> GpuStats {
    let mut s = GpuStats {
        gpu: 0,
        mem: 0,
        vram: 0,
        temp: 0,
        valid: false,
    };
    if let Ok(device) = nvml.device_by_index(0) {
        if let Ok(util) = device.utilization_rates() {
            s.gpu = util.gpu as i32;
            s.mem = util.memory as i32;
        }
        if let Ok(mem) = device.memory_info()
            && mem.total > 0
        {
            s.vram = (mem.used * 100 / mem.total) as i32;
        }
        if let Ok(temp) =
            device.temperature(nvml_wrapper::enum_wrappers::device::TemperatureSensor::Gpu)
        {
            s.temp = temp as i32;
        }
        s.valid = true;
    }
    s
}

pub fn update(state: &mut AppState) {
    let mut guard = NVML.lock().unwrap();
    if guard.is_none() {
        *guard = nvml_wrapper::Nvml::init().ok();
    }
    if let Some(ref nv) = *guard {
        state.gpu = query_gpu(nv);
    }
}

pub fn draw(cr: &cairo::Context, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let text = if state.gpu.valid {
        format!(
            "{} {}%  {} {}%  {} {}%  {} {}\u{00B0}C",
            ICON_NVG.to_str().unwrap(),
            state.gpu.gpu,
            ICON_NVM.to_str().unwrap(),
            state.gpu.mem,
            ICON_NVV.to_str().unwrap(),
            state.gpu.vram,
            ICON_NVT.to_str().unwrap(),
            state.gpu.temp
        )
    } else {
        String::new()
    };
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module {
    draw,
    update: Some(update),
};
