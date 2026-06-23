#![allow(non_upper_case_globals)]

mod config;
mod draw;
mod icons;
mod modules;
mod tray;
mod util;

use std::os::fd::{AsRawFd, BorrowedFd, RawFd};

use nix::sys::select::{FdSet, select};
use nix::sys::time::TimeVal;

use x11rb::connection::Connection;
use x11rb::protocol::Event;
use x11rb::protocol::xproto::*;
use x11rb::wrapper::ConnectionExt as _;
use x11rb::xcb_ffi::XCBConnection;

use crate::modules::UpdateFn;

#[repr(C)]
struct XcbVisualtype {
    visual_id: u32,
    class: u8,
    bits_per_rgb_value: u8,
    colormap_entries: u16,
    red_mask: u32,
    green_mask: u32,
    blue_mask: u32,
    pad0: [u8; 4],
}

impl From<x11rb::protocol::xproto::Visualtype> for XcbVisualtype {
    fn from(v: x11rb::protocol::xproto::Visualtype) -> Self {
        XcbVisualtype {
            visual_id: v.visual_id,
            class: u8::from(v.class),
            bits_per_rgb_value: v.bits_per_rgb_value,
            colormap_entries: v.colormap_entries,
            red_mask: v.red_mask,
            green_mask: v.green_mask,
            blue_mask: v.blue_mask,
            pad0: [0; 4],
        }
    }
}

x11rb::atom_manager! {
    pub AtomCollection: AtomCollectionCookie {
        WM_PROTOCOLS,
        WM_DELETE_WINDOW,
        _NET_WM_WINDOW_TYPE,
        _NET_WM_WINDOW_TYPE_DOCK,
        _NET_WM_STRUT_PARTIAL,
        _NET_WM_DESKTOP,
        _NET_WM_STATE,
        _NET_WM_STATE_STICKY,
    }
}

fn borrow_fd(fd: RawFd) -> BorrowedFd<'static> {
    unsafe { BorrowedFd::borrow_raw(fd) }
}

fn get_root_visual(screen: &x11rb::protocol::xproto::Screen) -> Option<XcbVisualtype> {
    let root_visual = screen.root_visual;
    for depth in &screen.allowed_depths {
        for visual in &depth.visuals {
            if visual.visual_id == root_visual {
                return Some(XcbVisualtype::from(*visual));
            }
        }
    }
    None
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let (conn, screen_num) = XCBConnection::connect(None)?;
    let setup = conn.setup();
    let screen = &setup.roots[screen_num];

    let atoms = AtomCollection::new(&conn)?.reply()?;

    let sw = screen.width_in_pixels as i32;
    let bh = config::BAR_HEIGHT;

    let win_id = conn.generate_id()?;

    let win_aux = CreateWindowAux::new()
        .background_pixel(0x2e3440)
        .event_mask(
            EventMask::EXPOSURE
                | EventMask::KEY_PRESS
                | EventMask::BUTTON_PRESS
                | EventMask::STRUCTURE_NOTIFY
                | EventMask::SUBSTRUCTURE_NOTIFY,
        );

    conn.create_window(
        x11rb::COPY_DEPTH_FROM_PARENT,
        win_id,
        screen.root,
        0,
        0,
        sw as u16,
        bh as u16,
        0,
        WindowClass::INPUT_OUTPUT,
        x11rb::COPY_FROM_PARENT,
        &win_aux,
    )?;

    conn.change_property32(
        PropMode::REPLACE,
        win_id,
        atoms._NET_WM_WINDOW_TYPE,
        AtomEnum::ATOM,
        &[atoms._NET_WM_WINDOW_TYPE_DOCK],
    )?;
    let mut str_val: [u32; 12] = [0; 12];
    str_val[2] = bh as u32;
    str_val[9] = sw as u32;
    conn.change_property32(
        PropMode::REPLACE,
        win_id,
        atoms._NET_WM_STRUT_PARTIAL,
        AtomEnum::CARDINAL,
        &str_val,
    )?;
    conn.change_property32(
        PropMode::REPLACE,
        win_id,
        atoms._NET_WM_DESKTOP,
        AtomEnum::CARDINAL,
        &[0xFFFFFFFF],
    )?;
    conn.change_property32(
        PropMode::REPLACE,
        win_id,
        atoms._NET_WM_STATE,
        AtomEnum::ATOM,
        &[atoms._NET_WM_STATE_STICKY],
    )?;
    conn.change_property32(
        PropMode::REPLACE,
        win_id,
        atoms.WM_PROTOCOLS,
        AtomEnum::ATOM,
        &[atoms.WM_DELETE_WINDOW],
    )?;

    conn.map_window(win_id)?;
    conn.flush()?;

    let mut tray = tray::TrayState::new();
    if config::TRAY {
        tray.init(&conn, win_id, screen_num)?;
    }

    let mut state = modules::AppState::new();

    let mut ws_conn = if config::WORKSPACE {
        modules::workspace::init(&mut state)
    } else {
        None
    };

    let mut visual_raw = get_root_visual(screen).unwrap();
    let sfc = unsafe {
        cairo::XCBSurface::create(
            &cairo::XCBConnection::from_raw_none(conn.get_raw_xcb_connection().cast()),
            &cairo::XCBDrawable(win_id),
            &cairo::XCBVisualType::from_raw_none(std::ptr::from_mut(&mut visual_raw).cast()),
            sw,
            bh,
        )?
    };
    let cr = cairo::Context::new(&sfc)?;

    let mut right_margin: i32 = 6;

    let mut updaters: Vec<UpdateFn> = Vec::new();
    for m in config::LEFT
        .iter()
        .chain(config::CENTER)
        .chain(config::RIGHT)
    {
        if let Some(u) = m.update {
            updaters.push(u);
        }
    }

    for u in &updaters {
        u(&mut state);
    }

    draw::draw_all(
        &conn,
        &cr,
        sw,
        bh,
        &state,
        config::LEFT,
        config::CENTER,
        config::RIGHT,
        right_margin,
    );

    let mut tick = 0i32;
    let mut running = true;

    while running {
        let mut readfds = FdSet::new();
        let xfd = conn.as_raw_fd();
        readfds.insert(borrow_fd(xfd));
        let mut mfd = xfd;

        if let Some((ws_fd, _)) = &ws_conn {
            readfds.insert(borrow_fd(*ws_fd));
            mfd = std::cmp::max(mfd, *ws_fd);
        }

        let tv = TimeVal::new(0, 100_000);
        let mut timeout = Some(tv);

        if select(Some(mfd + 1), &mut readfds, None, None, &mut timeout).is_ok_and(|n| n > 0) {
            if readfds.contains(borrow_fd(xfd)) {
                loop {
                    match conn.poll_for_event()? {
                        Some(Event::Expose(ev)) => {
                            if ev.count == 0 && ev.window != 0 {
                                let ok = if config::TRAY {
                                    tray.find(ev.window).is_none()
                                } else {
                                    true
                                };
                                if ok {
                                    draw::draw_all(
                                        &conn,
                                        &cr,
                                        sw,
                                        bh,
                                        &state,
                                        config::LEFT,
                                        config::CENTER,
                                        config::RIGHT,
                                        right_margin,
                                    );
                                }
                            }
                        }
                        Some(Event::ClientMessage(ev)) => {
                            let is_wm_delete = if ev.format == 32 {
                                let data = ev.data.as_data32();
                                data[0] == atoms.WM_DELETE_WINDOW
                            } else {
                                false
                            };
                            if config::TRAY {
                                tray.handle_event(&conn, &Event::ClientMessage(ev))?;
                            }
                            if is_wm_delete {
                                running = false;
                            }
                        }
                        Some(Event::KeyPress(_)) => running = false,
                        Some(ev) => {
                            if config::TRAY {
                                tray.handle_event(&conn, &ev)?;
                            }
                        }
                        None => break,
                    }
                }
            }
            if let Some(ref mut ws) = ws_conn
                && readfds.contains(borrow_fd(ws.0))
            {
                modules::workspace::handle_event(ws, &mut state);
            }
        }

        if config::TRAY && tray.active && tray.dirty {
            tray.dirty = false;
            tray.layout(&conn, sw, bh, &mut right_margin)?;
        }

        tick += 1;
        if tick >= 10 {
            tick = 0;
            for u in &updaters {
                u(&mut state);
            }
        }

        draw::draw_all(
            &conn,
            &cr,
            sw,
            bh,
            &state,
            config::LEFT,
            config::CENTER,
            config::RIGHT,
            right_margin,
        );
    }

    conn.destroy_window(win_id)?;
    Ok(())
}
