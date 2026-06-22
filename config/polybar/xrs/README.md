# xrs

A dwm-style status bar for X11.  Configuration is done by editing Rust source files.

> **Note:** This is an X11 program — it uses `Xlib` / `cairo-xlib` directly and will
> not work under Wayland.  Sway workspace support is included in the code path
> (same i3 IPC protocol) but **has not been tested**.

> This program was written primarily by **DeepSeek V4 Pro**.
>
> **Known issues — system tray:** The tray implementation has known
> instability.  Tray icons may not appear until another application triggers a
> refresh (e.g. `fcitx5` does not show until `flameshot` is launched alongside it).
> When a tray client exits between refresh cycles, the tray area may not shrink
> back to the correct width.

## Dependencies

### System

All rendering and hardware access goes through system-installed C libraries.
The Rust crates are bindings on top of them.

| system package    | Rust crate        | needed for          | optional?                     |
|-------------------|-------------------|---------------------|-------------------------------|
| `libx11`          | `x11`             | X11 window creation | no                            |
| `cairo`           | `cairo-sys-rs`    | rendering           | no                            |
| `libpulse`        | — (C FFI)         | volume module       | yes — remove volume module    |
| `nvidia-ml`       | `nvml-wrapper`    | GPU module          | yes — remove nvidia module    |
| `libc`            | `libc`            | `select()` / fd ops | no — every Linux system has it |
| `gcc` / `cc`      | `cc`              | compile pulse FFI helper | no — every Linux system has it |

`nvidia-ml` ships with the NVIDIA driver (`/usr/lib/libnvidia-ml.so`).
If you don't have an NVIDIA GPU or the driver, remove `crate::modules::nvidia::MODULE`
from `src/config.rs` — the crate still compiles because all NVML code lives inside
`nvidia.rs` and is initialised lazily.

## Test environment

| component      | version              |
|----------------|----------------------|
| OS             | Arch Linux           |
| X11            | libX11 1.8.13         |
| cairo          | 1.18.4               |
| NVML           | API v13 (driver 610.43.02) |
| PulseAudio     | libpulse 17.0         |
| Rust           | stable 1.96.0 (edition 2024) |
| gcc            | 16.1.1               |
| glibc          | 2.43                 |
| font           | JetBrainsMono Nerd Font |

## Quick start

```sh
cargo build --release
./target/release/xrs
```

## Configuration

All tunables are in `src/config.rs`:

| constant            | meaning                          |
|---------------------|----------------------------------|
| `FONT`              | font family (must have Nerd Font glyphs) |
| `FONT_SIZE_MAIN`    | workspace button font size       |
| `FONT_SIZE_ICON`    | icon font size                  |
| `BAR_HEIGHT`        | bar height in pixels            |
| `GAP`               | spacing between right modules   |
| `WS_PAD` / `WS_GAP` | workspace button padding / gap  |
| `BG_R/G/B` / `FG_R/G/B` | background / foreground colours |
| `TRAY`              | enable system tray              |
| `WORKSPACE`         | enable i3 workspace display     |
| `WORKSPACE_TYPE`    | window manager — `"i3"` or `"sway"` |

`LEFT`, `CENTER`, `RIGHT` arrays choose which modules appear and in what order.

## Adding a custom module

### Case 1 — stateless module (no data, just display)

The arch icon is a perfect example.  It only needs a `draw` function.

**1.  Create `src/modules/my_module.rs`:**

```rust
use super::*;

pub unsafe fn draw(
    cr: *mut cairo_sys::cairo_t, x: f64, bh: i32,
    _state: &AppState, dry_run: bool,
) -> f64 {
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, "hello", dry_run)
}

pub const MODULE: Module = Module { draw, update: None };
```

**2.  Register it in `src/modules/mod.rs`** — add `pub mod my_module;` to the list at the top.

**3.  Add it to `src/config.rs`** — put `crate::modules::my_module::MODULE` in the `LEFT` / `CENTER` / `RIGHT` array where you want it to appear.

Rebuild with `cargo build` — done.  `AppState` was **not** touched because this module has no data to collect.

### Case 2 — module with data (needs periodic updates)

Most system-monitor modules follow this pattern.  Look at `src/modules/battery.rs` as a reference:

**1.  Create the module file** with three parts:

```rust
use super::*;

// a)  Read data — private to this file
fn read_value() -> Option<i32> { super::read_int("/sys/...") }

// b)  Update AppState — called every tick
pub fn update(state: &mut AppState) {
    state.my_field = read_value();
}

// c)  Draw — called to render
pub unsafe fn draw(
    cr: *mut cairo_sys::cairo_t, x: f64, bh: i32,
    state: &AppState, dry_run: bool,
) -> f64 {
    let text = state.my_field.map(|v| format!("{}", v)).unwrap_or_default();
    super::simple_draw(cr, x, bh, config::FONT_SIZE_ICON, &text, dry_run)
}

pub const MODULE: Module = Module { draw, update: Some(update) };
```

**2.  Add a field to `AppState`** in `src/modules/mod.rs`:

```rust
pub struct AppState {
    pub ws:               Vec<Workspace>,
    pub my_field:         Option<i32>,   // ← add this
    // ... existing fields remain
}
```

**3.  Add its initial value** in `AppState::new()` further down:

```rust
my_field: None,
```

**4.  Register the module** — `pub mod my_module;` in `mod.rs`, then add `crate::modules::my_module::MODULE` to a layout array in `config.rs`.

### When do I need to touch AppState?

| your module does…                    | change AppState? |
|--------------------------------------|:---------------:|
| only draws a static string / icon    |        ✗        |
| reads system data that changes       |        ✓        |

Stateful readers that need internal `prev_*` tracking (like `cpu::CpuState`, `network::NetState`) should wrap their state in a struct and place it in AppState — see `src/modules/cpu.rs` for the pattern.

## File map

```
src/
├── main.rs            event loop, tray, dock (~140 lines)
├── config.rs          all tunables + module layout
├── draw.rs            cairo helpers + draw_all orchestrator
├── tray.rs            system tray implementation
├── icons.rs           Nerd Font codepoints
├── util.rs            read_int, pulse FFI
└── modules/
    ├── mod.rs         AppState, Module type, re-exports
    ├── arch.rs        Arch icon        (stateless)
    ├── clock.rs       HH:MM:SS         (stateless)
    ├── cpu.rs         CPU %            (stateful)
    ├── memory.rs      RAM %            (stateful)
    ├── cpu_temp.rs    CPU temperature  (stateful)
    ├── brightness.rs  brightness %     (stateful)
    ├── battery.rs     battery level    (stateful)
    ├── volume.rs      PulseAudio vol   (stateful)
    ├── nvidia.rs      GPU stats        (stateful)
    ├── network.rs     WiFi speed       (stateful)
    └── workspace/
        ├── mod.rs     WM dispatch
        └── i3.rs      i3/sway IPC + drawing
```
