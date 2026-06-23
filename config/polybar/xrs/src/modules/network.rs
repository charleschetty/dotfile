// modules/network.rs — WiFi icon + download speed
//
// All its logic is here — nothing in mod.rs.

use super::*;
use std::path::Path;

pub struct NetState {
    prev_rx: i64,
    prev_sec: i64,
    prev_nsec: i64,
    pub speed: Option<f64>,
}

impl NetState {
    pub const fn new() -> Self {
        NetState {
            prev_rx: -1,
            prev_sec: 0,
            prev_nsec: 0,
            speed: None,
        }
    }
    fn read(&mut self) {
        let s = match std::fs::read_to_string("/sys/class/net/wlan0/statistics/rx_bytes") {
            Ok(s) => s,
            Err(_) => return,
        };
        let rx: i64 = match s.trim().parse() {
            Ok(v) => v,
            Err(_) => return,
        };
        let now = match std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH) {
            Ok(d) => d,
            Err(_) => return,
        };
        let sec = now.as_secs() as i64;
        let nsec = now.subsec_nanos() as i64;
        if self.prev_rx < 0 {
            self.prev_rx = rx;
            self.prev_sec = sec;
            self.prev_nsec = nsec;
            return;
        }
        let dt = (sec - self.prev_sec) as f64 + (nsec - self.prev_nsec) as f64 / 1e9;
        if dt <= 0.0 {
            self.prev_rx = rx;
            self.prev_sec = sec;
            self.prev_nsec = nsec;
            return;
        }
        let speed = (rx - self.prev_rx) as f64 / dt;
        self.prev_rx = rx;
        self.prev_sec = sec;
        self.prev_nsec = nsec;
        self.speed = Some(if speed > 0.0 { speed } else { 0.0 });
    }
}

fn network_up() -> bool {
    let net_dir = Path::new("/sys/class/net");
    if let Ok(dir) = std::fs::read_dir(net_dir) {
        dir.flatten().any(|entry| {
            let name = entry.file_name();
            let name_str = name.to_string_lossy();
            if name_str.starts_with('.') || name_str == "lo" {
                return false;
            }
            let state_path = format!("/sys/class/net/{}/operstate", name_str);
            std::fs::read_to_string(state_path)
                .map(|s| s.trim() == "up")
                .unwrap_or(false)
        })
    } else {
        false
    }
}

pub fn update(state: &mut AppState) {
    state.net.read();
}

pub fn draw(cr: &cairo::Context, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let text = match (network_up(), state.net.speed) {
        (true, Some(s)) if s >= 0.0 => {
            if s < 1024.0 {
                format!("{} {:.0}B/s", ICON_WIFI.to_str().unwrap(), s)
            } else if s < 1024.0 * 1024.0 {
                format!("{} {:.0}K/s", ICON_WIFI.to_str().unwrap(), s / 1024.0)
            } else {
                format!(
                    "{} {:.1}M/s",
                    ICON_WIFI.to_str().unwrap(),
                    s / (1024.0 * 1024.0)
                )
            }
        }
        _ => "\u{2717}".to_string(),
    };
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module {
    draw,
    update: Some(update),
};
