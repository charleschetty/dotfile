use crate::config;
use x11::xlib;

const MAX_TRAY: usize = 16;
const TRAY_SIZE: i32 = 20;

pub struct TrayState {
    pub active: bool,
    pub dirty: bool,
    win: xlib::Window,
    ticons: [xlib::Window; MAX_TRAY],
    tray_atom: xlib::Atom,
    opcode_atom: xlib::Atom,
    xembed_atom: xlib::Atom,
    _xembed_info_atom: xlib::Atom,
    manager_atom: xlib::Atom,
}

impl TrayState {
    pub const fn new() -> Self {
        TrayState {
            active: false, dirty: false, win: 0,
            ticons: [0; MAX_TRAY],
            tray_atom: 0, opcode_atom: 0, xembed_atom: 0,
            _xembed_info_atom: 0, manager_atom: 0,
        }
    }

    pub fn find(&self, w: xlib::Window) -> Option<usize> {
        self.ticons.iter().position(|&c| c == w)
    }

    fn remove(&mut self, idx: usize) {
        if idx < MAX_TRAY && self.ticons[idx] != 0 { self.ticons[idx] = 0; self.dirty = true; }
    }

    fn count(&self) -> usize { self.ticons.iter().filter(|&&c| c != 0).count() }

    unsafe fn configure(&self, dpy: *mut xlib::Display, w: xlib::Window, wd: i32, ht: i32) {
        let mut ce: xlib::XEvent = std::mem::zeroed();
        ce.configure.type_ = xlib::ConfigureNotify; ce.configure.display = dpy; ce.configure.window = w;
        ce.configure.x = 0; ce.configure.y = 0; ce.configure.width = wd; ce.configure.height = ht;
        ce.configure.border_width = 0; ce.configure.above = 0; ce.configure.override_redirect = xlib::False;
        xlib::XSendEvent(dpy, w, xlib::False, xlib::StructureNotifyMask, &mut ce);
    }

    pub unsafe fn layout(&mut self, dpy: *mut xlib::Display, sw: i32, bh: i32, right_margin: &mut i32) {
        if self.win == 0 { return; }
        let n = self.count();
        if n == 0 {
            xlib::XMoveResizeWindow(dpy, self.win, sw, 0, 1, bh as u32);
            xlib::XUnmapWindow(dpy, self.win);
            *right_margin = 12;
            return;
        }
        let icon_sz = config::FONT_SIZE_ICON as i32 + 6;
        let pad = 6;
        let mut x = 0i32;
        for i in 0..MAX_TRAY {
            let c = self.ticons[i]; if c == 0 { continue; }
            let mut swa: xlib::XSetWindowAttributes = std::mem::zeroed(); swa.background_pixel = 0x2e3440;
            xlib::XChangeWindowAttributes(dpy, c, xlib::CWBackPixel, &mut swa);
            xlib::XMapRaised(dpy, c);
            xlib::XMoveResizeWindow(dpy, c, x, (bh - icon_sz) / 2, icon_sz as u32, icon_sz as u32);
            x += icon_sz + pad;
        }
        let tw = x - pad + pad * 2; let tx = sw - tw;
        xlib::XMoveResizeWindow(dpy, self.win, tx, 0, tw as u32, bh as u32);
        xlib::XMapRaised(dpy, self.win); xlib::XMapSubwindows(dpy, self.win);
        *right_margin = tw + 12;
    }

    pub unsafe fn init(&mut self, dpy: *mut xlib::Display, _bar: xlib::Window, sc: i32, sw: i32, bh: i32) {
        let name = format!("_NET_SYSTEM_TRAY_S{}\0", sc);
        let name_c = std::ffi::CString::from_vec_with_nul(name.into_bytes()).unwrap();
        self.tray_atom = xlib::XInternAtom(dpy, name_c.as_ptr(), xlib::False);
        self.opcode_atom = xlib::XInternAtom(dpy, c"_NET_SYSTEM_TRAY_OPCODE".as_ptr(), xlib::False);
        self.xembed_atom = xlib::XInternAtom(dpy, c"_XEMBED".as_ptr(), xlib::False);
        self._xembed_info_atom = xlib::XInternAtom(dpy, c"_XEMBED_INFO".as_ptr(), xlib::False);
        self.manager_atom = xlib::XInternAtom(dpy, c"MANAGER".as_ptr(), xlib::False);

        let t = xlib::XCreateSimpleWindow(dpy, xlib::XDefaultRootWindow(dpy), sw, 0, 1, bh as u32, 0, 0, 0x2e3440);
        let mut wa: xlib::XSetWindowAttributes = std::mem::zeroed(); wa.override_redirect = xlib::True; wa.background_pixel = 0x2e3440;
        xlib::XChangeWindowAttributes(dpy, t, xlib::CWOverrideRedirect | xlib::CWBackPixel, &mut wa);
        xlib::XSelectInput(dpy, t, xlib::SubstructureRedirectMask | xlib::SubstructureNotifyMask | xlib::ExposureMask);
        xlib::XMapRaised(dpy, t);
        xlib::XSetSelectionOwner(dpy, self.tray_atom, t, 0); xlib::XFlush(dpy);
        if xlib::XGetSelectionOwner(dpy, self.tray_atom) != t { eprintln!("tray: cannot acquire selection"); xlib::XDestroyWindow(dpy, t); return; }
        xlib::XChangeProperty(dpy, xlib::XDefaultRootWindow(dpy), self.tray_atom, xlib::XA_WINDOW, 32, xlib::PropModeReplace, &t as *const _ as *const u8, 1);
        let orient: i64 = 0;
        xlib::XChangeProperty(dpy, t, xlib::XInternAtom(dpy, c"_NET_SYSTEM_TRAY_ORIENTATION".as_ptr(), xlib::False), xlib::XA_CARDINAL, 32, xlib::PropModeReplace, &orient as *const _ as *const u8, 1);
        let mut mev: xlib::XEvent = std::mem::zeroed();
        mev.client_message.type_ = xlib::ClientMessage; mev.client_message.window = xlib::XDefaultRootWindow(dpy);
        mev.client_message.message_type = self.manager_atom; mev.client_message.format = 32;
        mev.client_message.data.set_long(0, 0); mev.client_message.data.set_long(1, self.tray_atom as i64); mev.client_message.data.set_long(2, t as i64);
        xlib::XSendEvent(dpy, xlib::XDefaultRootWindow(dpy), xlib::False, xlib::StructureNotifyMask, &mut mev); xlib::XFlush(dpy);
        self.win = t; self.active = true; self.dirty = true;
    }

    unsafe fn dock(&mut self, dpy: *mut xlib::Display, client: xlib::Window) {
        if self.find(client).is_some() { return; }
        let idx = match self.ticons.iter().position(|&c| c == 0) { Some(i) => i, None => return };
        let mut wa: xlib::XWindowAttributes = std::mem::zeroed();
        if xlib::XGetWindowAttributes(dpy, client, &mut wa) == 0 || wa.root != xlib::XDefaultRootWindow(dpy) { return; }
        xlib::XAddToSaveSet(dpy, client);
        xlib::XSelectInput(dpy, client, xlib::StructureNotifyMask | xlib::PropertyChangeMask | xlib::ResizeRedirectMask);
        xlib::XReparentWindow(dpy, client, self.win, 0, 0);
        let mut swa: xlib::XSetWindowAttributes = std::mem::zeroed(); swa.background_pixel = 0x2e3440;
        xlib::XChangeWindowAttributes(dpy, client, xlib::CWBackPixel, &mut swa); xlib::XMapRaised(dpy, client);
        let mut hints: xlib::XSizeHints = std::mem::zeroed(); hints.flags = xlib::PMinSize | xlib::PMaxSize;
        hints.min_width = TRAY_SIZE; hints.max_width = TRAY_SIZE; hints.min_height = TRAY_SIZE; hints.max_height = TRAY_SIZE;
        xlib::XSetWMNormalHints(dpy, client, &mut hints);
        self.ticons[idx] = client;
        let mut xe: xlib::XEvent = std::mem::zeroed();
        xe.client_message.type_ = xlib::ClientMessage; xe.client_message.window = client;
        xe.client_message.message_type = self.xembed_atom; xe.client_message.format = 32;
        xe.client_message.data.set_long(0, 0); xe.client_message.data.set_long(1, 0); xe.client_message.data.set_long(2, self.win as i64); xe.client_message.data.set_long(3, 0);
        xlib::XSendEvent(dpy, client, xlib::False, xlib::NoEventMask, &mut xe);
        self.dirty = true;
    }

    pub unsafe fn handle_event(&mut self, dpy: *mut xlib::Display, ev: &xlib::XEvent) {
        if !self.active { return; }
        if ev.get_type() == xlib::ClientMessage && ev.client_message.message_type == self.opcode_atom && ev.client_message.data.get_long(1) == 0 { self.dock(dpy, ev.client_message.data.get_long(2) as xlib::Window); return; }
        if ev.get_type() == xlib::DestroyNotify { if let Some(i) = self.find(ev.destroy_window.window) { self.remove(i); } return; }
        if ev.get_type() == xlib::UnmapNotify { if ev.unmap.event == self.win { if let Some(i) = self.find(ev.unmap.window) { self.remove(i); } } return; }
        if ev.get_type() == xlib::ConfigureRequest { if self.find(ev.configure_request.window).is_some() { self.configure(dpy, ev.configure_request.window, TRAY_SIZE, TRAY_SIZE); } return; }
        if ev.get_type() == xlib::ReparentNotify { if let Some(i) = self.find(ev.reparent.window) && ev.reparent.parent != self.win { self.remove(i); } return; }
        if ev.get_type() == xlib::SelectionClear && ev.selection_clear.selection == self.tray_atom {
            eprintln!("tray: lost selection, cleaning up"); self.active = false;
            for i in 0..MAX_TRAY { self.ticons[i] = 0; }
            xlib::XDestroyWindow(dpy, self.win); self.win = 0;
        }
    }
}

pub unsafe extern "C" fn tray_err_handler(_dpy: *mut xlib::Display, _ev: *mut xlib::XErrorEvent) -> i32 { 0 }
