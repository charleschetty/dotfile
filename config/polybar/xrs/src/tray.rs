use crate::config;
use std::error::Error;
use x11rb::COPY_DEPTH_FROM_PARENT;
use x11rb::connection::Connection;
use x11rb::protocol::Event;
use x11rb::protocol::xproto::*;
use x11rb::wrapper::ConnectionExt as _;

const MAX_TRAY: usize = 16;
const TRAY_SIZE: i32 = 20;

x11rb::atom_manager! {
    pub TrayAtoms: TrayAtomsCookie {
        _NET_SYSTEM_TRAY_OPCODE,
        _XEMBED,
        _XEMBED_INFO,
        MANAGER,
        _NET_SYSTEM_TRAY_ORIENTATION,
        WM_NORMAL_HINTS,
    }
}

pub struct TrayState {
    pub active: bool,
    pub dirty: bool,
    win: u32,
    ticons: [u32; MAX_TRAY],
    tray_atom: u32,
    atoms: Option<TrayAtoms>,
}

impl TrayState {
    pub fn new() -> Self {
        TrayState {
            active: false,
            dirty: false,
            win: 0,
            ticons: [0; MAX_TRAY],
            tray_atom: 0,
            atoms: None,
        }
    }

    pub fn find(&self, w: u32) -> Option<usize> {
        self.ticons.iter().position(|&c| c == w)
    }

    fn remove(&mut self, idx: usize) {
        if idx < MAX_TRAY && self.ticons[idx] != 0 {
            self.ticons[idx] = 0;
            self.dirty = true;
        }
    }

    fn count(&self) -> usize {
        self.ticons.iter().filter(|&&c| c != 0).count()
    }

    fn atoms(&self) -> &TrayAtoms {
        self.atoms.as_ref().unwrap()
    }

    fn is_mapped<C: Connection>(conn: &C, win: u32, xembed_info: u32) -> bool {
        let cookie = conn.get_property(false, win, xembed_info, AtomEnum::CARDINAL, 0, 2);
        let reply = match cookie {
            Ok(c) => match c.reply() {
                Ok(r) => r,
                Err(_) => return true,
            },
            Err(_) => return true,
        };
        if reply.value.len() < 8 {
            return true;
        }
        let data = unsafe {
            std::slice::from_raw_parts(reply.value.as_ptr() as *const u32, reply.value.len() / 4)
        };
        data.len() >= 2 && (data[1] & 1) != 0
    }

    pub fn layout<C: Connection>(
        &mut self,
        conn: &C,
        sw: i32,
        bh: i32,
        right_margin: &mut i32,
    ) -> Result<(), Box<dyn Error>> {
        if self.win == 0 {
            return Ok(());
        }
        let n = self.count();
        if n == 0 {
            conn.configure_window(
                self.win,
                &ConfigureWindowAux::new()
                    .x(sw)
                    .y(0)
                    .width(1)
                    .height(bh as u32),
            )?;
            conn.unmap_window(self.win)?;
            conn.flush()?;
            *right_margin = 12;
            return Ok(());
        }
        let icon_sz = config::FONT_SIZE_ICON as i32 + 6;
        let pad = 6;
        let mut x = 0i32;
        for i in 0..MAX_TRAY {
            let c = self.ticons[i];
            if c == 0 {
                continue;
            }
            if conn.get_window_attributes(c)?.reply().is_err() {
                self.ticons[i] = 0;
                continue;
            }
            if !Self::is_mapped(conn, c, self.atoms()._XEMBED_INFO) {
                conn.unmap_window(c)?;
                continue;
            }
            conn.change_window_attributes(
                c,
                &ChangeWindowAttributesAux::new().background_pixel(0x2e3440),
            )?;
            conn.map_window(c)?;
            conn.configure_window(
                c,
                &ConfigureWindowAux::new()
                    .x(x)
                    .y((bh - icon_sz) / 2)
                    .width(icon_sz as u32)
                    .height(icon_sz as u32),
            )?;
            conn.clear_area(false, c, 0, 0, 0, 0)?;
            x += icon_sz + pad;
        }
        let tw = x - pad + pad * 2;
        let tx = sw - tw;
        conn.configure_window(
            self.win,
            &ConfigureWindowAux::new()
                .x(tx)
                .y(0)
                .width(tw as u32)
                .height(bh as u32),
        )?;
        conn.map_window(self.win)?;
        conn.map_subwindows(self.win)?;
        conn.configure_window(
            self.win,
            &ConfigureWindowAux::new().stack_mode(StackMode::ABOVE),
        )?;
        conn.flush()?;
        *right_margin = tw + 12;
        Ok(())
    }

    pub fn init<C: Connection>(
        &mut self,
        conn: &C,
        bar: u32,
        screen_num: usize,
    ) -> Result<(), Box<dyn Error>> {
        let screen = &conn.setup().roots[screen_num];
        let bh = config::BAR_HEIGHT;

        let suffix = format!("_NET_SYSTEM_TRAY_S{screen_num}");
        let cookie = conn.intern_atom(false, suffix.as_bytes())?;
        self.tray_atom = cookie.reply()?.atom;
        if self.tray_atom == 0 {
            eprintln!("tray: intern failed");
            return Ok(());
        }

        self.atoms = Some(TrayAtoms::new(conn)?.reply()?);

        let tw = conn.generate_id()?;
        conn.create_window(
            COPY_DEPTH_FROM_PARENT,
            tw,
            bar,
            0,
            0,
            1,
            bh as u16,
            0,
            WindowClass::INPUT_OUTPUT,
            x11rb::COPY_FROM_PARENT,
            &CreateWindowAux::new()
                .background_pixel(0x2e3440)
                .override_redirect(1u32)
                .event_mask(
                    EventMask::SUBSTRUCTURE_REDIRECT
                        | EventMask::SUBSTRUCTURE_NOTIFY
                        | EventMask::EXPOSURE,
                ),
        )?;
        conn.map_window(tw)?;
        conn.configure_window(tw, &ConfigureWindowAux::new().stack_mode(StackMode::ABOVE))?;
        conn.set_selection_owner(tw, self.tray_atom, x11rb::CURRENT_TIME)?;
        conn.flush()?;

        let sel_reply = conn.get_selection_owner(self.tray_atom)?.reply()?;
        if sel_reply.owner != tw {
            eprintln!("tray: cannot acquire selection");
            conn.destroy_window(tw)?;
            conn.flush()?;
            return Ok(());
        }

        conn.change_property32(
            PropMode::REPLACE,
            screen.root,
            self.tray_atom,
            AtomEnum::WINDOW,
            &[tw],
        )?;
        conn.flush()?;

        conn.change_property32(
            PropMode::REPLACE,
            tw,
            self.atoms()._NET_SYSTEM_TRAY_ORIENTATION,
            AtomEnum::CARDINAL,
            &[0],
        )?;

        let mev = ClientMessageEvent::new(
            32,
            screen.root,
            self.atoms().MANAGER,
            [x11rb::CURRENT_TIME, self.tray_atom, tw, 0u32, 0u32],
        );
        conn.send_event(false, screen.root, EventMask::STRUCTURE_NOTIFY, mev)?;
        conn.flush()?;
        self.win = tw;
        self.active = true;
        self.dirty = true;
        Ok(())
    }

    fn dock<C: Connection>(&mut self, conn: &C, client: u32) -> Result<(), Box<dyn Error>> {
        if self.find(client).is_some() {
            return Ok(());
        }
        let idx = match self.ticons.iter().position(|&c| c == 0) {
            Some(i) => i,
            None => return Ok(()),
        };
        if conn.get_window_attributes(client)?.reply().is_err() {
            return Ok(());
        }

        conn.change_save_set(SetMode::INSERT, client)?;
        conn.change_window_attributes(
            client,
            &ChangeWindowAttributesAux::new().event_mask(
                EventMask::STRUCTURE_NOTIFY
                    | EventMask::PROPERTY_CHANGE
                    | EventMask::RESIZE_REDIRECT,
            ),
        )?;
        conn.reparent_window(client, self.win, 0, 0)?;
        conn.change_window_attributes(
            client,
            &ChangeWindowAttributesAux::new().background_pixel(0x2e3440),
        )?;

        let size_hints: [u32; 18] = [
            3,
            0,
            0,
            0,
            0,
            TRAY_SIZE as u32,
            TRAY_SIZE as u32,
            TRAY_SIZE as u32,
            TRAY_SIZE as u32,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        ];
        conn.change_property32(
            PropMode::REPLACE,
            client,
            self.atoms().WM_NORMAL_HINTS,
            AtomEnum::WM_SIZE_HINTS,
            &size_hints,
        )?;

        self.ticons[idx] = client;

        let xe = ClientMessageEvent::new(
            32,
            client,
            self.atoms()._XEMBED,
            [0u32, 0u32, self.win, 0u32, 0u32],
        );
        conn.send_event(false, client, EventMask::NO_EVENT, xe)?;
        conn.flush()?;
        self.dirty = true;
        Ok(())
    }

    pub fn handle_event<C: Connection>(
        &mut self,
        conn: &C,
        ev: &Event,
    ) -> Result<(), Box<dyn Error>> {
        if !self.active {
            return Ok(());
        }
        match ev {
            Event::ClientMessage(cm_ev) if cm_ev.type_ == self.atoms()._NET_SYSTEM_TRAY_OPCODE => {
                let data = cm_ev.data.as_data32();
                if data[1] == 0 {
                    self.dock(conn, data[2])?;
                }
            }
            Event::DestroyNotify(ev) => {
                if let Some(i) = self.find(ev.window) {
                    self.remove(i);
                }
            }
            Event::MapNotify(ev) => {
                if self.find(ev.window).is_some() {
                    self.dirty = true;
                }
            }
            Event::UnmapNotify(ev) if ev.event == self.win => {
                if let Some(i) = self.find(ev.window) {
                    self.remove(i);
                }
            }
            Event::ConfigureRequest(ev) => {
                if self.find(ev.window).is_some() {
                    conn.configure_window(
                        ev.window,
                        &ConfigureWindowAux::new()
                            .width(TRAY_SIZE as u32)
                            .height(TRAY_SIZE as u32),
                    )?;
                    conn.flush()?;
                }
            }
            Event::ReparentNotify(ev) => {
                if let Some(i) = self.find(ev.window)
                    && ev.parent != self.win
                {
                    self.remove(i);
                }
            }
            Event::PropertyNotify(ev) if ev.atom == self.atoms()._XEMBED_INFO => {
                if self.find(ev.window).is_some() {
                    self.dirty = true;
                }
            }
            Event::SelectionClear(ev) if ev.selection == self.tray_atom => {
                eprintln!("tray: lost selection, cleaning up");
                self.active = false;
                for i in 0..MAX_TRAY {
                    self.ticons[i] = 0;
                }
                conn.destroy_window(self.win)?;
                self.win = 0;
                conn.flush()?;
            }
            _ => {}
        }
        Ok(())
    }
}
