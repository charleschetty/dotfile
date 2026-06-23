// modules/workspace/mod.rs — workspace module, dispatches to the active WM.
//
// To add a new window manager:
//   1. Create a file like hyprland.rs next to i3.rs
//   2. Add `pub mod hyprland;` below
//   3. Add a match arm in init() and handle_event()

pub mod i3;

use std::os::unix::net::UnixStream;

use crate::config;
use crate::modules::AppState;

pub type Connection = (i32, UnixStream);

pub fn init(state: &mut AppState) -> Option<Connection> {
    match config::WORKSPACE_TYPE {
        "i3" | "sway" => i3::init(state),
        _ => {
            eprintln!("unsupported WORKSPACE_TYPE: {}", config::WORKSPACE_TYPE);
            None
        }
    }
}

pub fn handle_event(conn: &mut Connection, state: &mut AppState) {
    match config::WORKSPACE_TYPE {
        "i3" | "sway" => i3::handle_event(conn, state),
        _ => {}
    }
}

pub use i3::MODULE;
