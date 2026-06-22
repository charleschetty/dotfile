#![allow(unsafe_op_in_unsafe_fn)]

mod config;
mod draw;
mod icons;
mod modules;
mod tray;
mod util;

use std::ptr;

use crate::modules::UpdateFn;

unsafe fn set_dock(dpy: *mut x11::xlib::Display, win: x11::xlib::Window, h: i32, sw: i32) {
    let a = x11::xlib::XInternAtom(dpy, c"_NET_WM_WINDOW_TYPE".as_ptr(), x11::xlib::False);
    let v = x11::xlib::XInternAtom(dpy, c"_NET_WM_WINDOW_TYPE_DOCK".as_ptr(), x11::xlib::False);
    x11::xlib::XChangeProperty(dpy, win, a, x11::xlib::XA_ATOM, 32, x11::xlib::PropModeReplace, &v as *const _ as *const u8, 1);
    let mut str_val = [0i64; 12]; str_val[2] = h as i64; str_val[9] = sw as i64;
    x11::xlib::XChangeProperty(dpy, win, x11::xlib::XInternAtom(dpy, c"_NET_WM_STRUT_PARTIAL".as_ptr(), x11::xlib::False), x11::xlib::XA_CARDINAL, 32, x11::xlib::PropModeReplace, str_val.as_ptr() as *const u8, 12);
    let d: u32 = 0xFFFFFFFF;
    x11::xlib::XChangeProperty(dpy, win, x11::xlib::XInternAtom(dpy, c"_NET_WM_DESKTOP".as_ptr(), x11::xlib::False), x11::xlib::XA_CARDINAL, 32, x11::xlib::PropModeReplace, &d as *const _ as *const u8, 1);
    let s = x11::xlib::XInternAtom(dpy, c"_NET_WM_STATE_STICKY".as_ptr(), x11::xlib::False);
    x11::xlib::XChangeProperty(dpy, win, x11::xlib::XInternAtom(dpy, c"_NET_WM_STATE".as_ptr(), x11::xlib::False), x11::xlib::XA_ATOM, 32, x11::xlib::PropModeReplace, &s as *const _ as *const u8, 1);
}

fn main() {
    unsafe {
        let dpy = x11::xlib::XOpenDisplay(ptr::null());
        if dpy.is_null() { eprintln!("Cannot open display"); std::process::exit(1); }

        let screen = x11::xlib::XDefaultScreen(dpy);
        let sw = x11::xlib::XDisplayWidth(dpy, screen);
        let bh = config::BAR_HEIGHT;

        let win = x11::xlib::XCreateSimpleWindow(dpy, x11::xlib::XRootWindow(dpy, screen),
            0, 0, sw as u32, bh as u32, 0, x11::xlib::XBlackPixel(dpy, screen), 0x2e3440);
        set_dock(dpy, win, bh, sw);
        x11::xlib::XSelectInput(dpy, win, x11::xlib::ExposureMask | x11::xlib::KeyPressMask | x11::xlib::ButtonPressMask
            | x11::xlib::StructureNotifyMask | x11::xlib::SubstructureNotifyMask);
        x11::xlib::XMapWindow(dpy, win);
        let wm_delete = x11::xlib::XInternAtom(dpy, c"WM_DELETE_WINDOW".as_ptr(), x11::xlib::False);
        x11::xlib::XSetWMProtocols(dpy, win, &wm_delete as *const _ as *mut x11::xlib::Atom, 1);

        let mut tray = tray::TrayState::new();
        if config::TRAY {
            tray.init(dpy, win, screen, sw, bh);
            x11::xlib::XSetErrorHandler(Some(tray::tray_err_handler as unsafe extern "C" fn(_, _) -> i32));
        }

        let mut state = modules::AppState::new();

        let mut ws_conn = if config::WORKSPACE { modules::workspace::init(&mut state) } else { None };

        let sfc = cairo_sys::cairo_xlib_surface_create(dpy as *mut _, win,
            x11::xlib::XDefaultVisual(dpy, screen) as *mut _, sw, bh);
        let cr = cairo_sys::cairo_create(sfc);

        let mut right_margin: i32 = 6;

        let mut updaters: Vec<UpdateFn> = Vec::new();
        for m in config::LEFT.iter().chain(config::CENTER).chain(config::RIGHT) {
            if let Some(u) = m.update { updaters.push(u); }
        }

        for u in &updaters { u(&mut state); }

        draw::draw_all(dpy, cr, sw, bh, &state,
            config::LEFT, config::CENTER, config::RIGHT, right_margin);

        let mut tick = 0i32;
        let mut running = true;

        while running {
            let mut fds: libc::fd_set = std::mem::zeroed(); libc::FD_ZERO(&mut fds);
            let xfd = x11::xlib::XConnectionNumber(dpy); libc::FD_SET(xfd, &mut fds);
            let mut mfd = xfd;

            if let Some((ws_fd, _)) = &ws_conn {
                libc::FD_SET(*ws_fd, &mut fds);
                mfd = std::cmp::max(mfd, *ws_fd);
            }

            let tv = libc::timeval { tv_sec: 0, tv_usec: 100_000 };

            if libc::select(mfd + 1, &mut fds, ptr::null_mut(), ptr::null_mut(), &tv as *const _ as *mut _) > 0 {
                if libc::FD_ISSET(xfd, &fds) {
                    while x11::xlib::XPending(dpy) > 0 {
                        let mut ev: x11::xlib::XEvent = std::mem::zeroed();
                        x11::xlib::XNextEvent(dpy, &mut ev);
                        match ev.get_type() {
                            t if t == x11::xlib::Expose => {
                                if ev.expose.count == 0 && ev.expose.window != 0 {
                                    let ok = if config::TRAY { tray.find(ev.expose.window).is_none() } else { true };
                                    if ok {
                                        draw::draw_all(dpy, cr, sw, bh, &state,
                                            config::LEFT, config::CENTER, config::RIGHT, right_margin);
                                    }
                                }
                            }
                            t if t == x11::xlib::ClientMessage => {
                                if config::TRAY { tray.handle_event(dpy, &ev); }
                                if ev.client_message.data.get_long(0) as x11::xlib::Atom == wm_delete { running = false; }
                            }
                            t if t == x11::xlib::KeyPress || t == x11::xlib::ButtonPress => running = false,
                            _ => { if config::TRAY { tray.handle_event(dpy, &ev); } }
                        }
                    }
                }
                if let Some(ref mut conn) = ws_conn {
                    if libc::FD_ISSET(conn.0, &fds) {
                        modules::workspace::handle_event(conn, &mut state);
                    }
                }
            }

            if config::TRAY && tray.active && tray.dirty {
                tray.dirty = false;
                tray.layout(dpy, sw, bh, &mut right_margin);
            }

            tick += 1;
            if tick >= 10 {
                tick = 0;
                for u in &updaters { u(&mut state); }
            }

            draw::draw_all(dpy, cr, sw, bh, &state,
                config::LEFT, config::CENTER, config::RIGHT, right_margin);
        }

        cairo_sys::cairo_destroy(cr);
        cairo_sys::cairo_surface_destroy(sfc);
        x11::xlib::XDestroyWindow(dpy, win);
        x11::xlib::XCloseDisplay(dpy);
    }
}
