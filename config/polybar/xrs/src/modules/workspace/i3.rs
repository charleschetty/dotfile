// workspace/i3.rs — i3 / sway IPC + workspace button drawing

use std::fs;
use std::io::{Read, Write};
use std::os::unix::io::AsRawFd;
use std::os::unix::net::UnixStream;

use serde::Deserialize;

use super::super::*;

// ── types ──

const I3_MAGIC: &[u8; 6] = b"i3-ipc";

#[repr(u32)]
#[allow(dead_code)]
enum MsgType { RunCommand = 0, GetWorkspaces = 1, Subscribe = 2 }

#[derive(Deserialize, Debug, Clone)]
pub struct Workspace {
    pub name: String,
    #[serde(default)] pub focused: bool,
    #[serde(default)] pub visible: bool,
    #[serde(default)] pub urgent: bool,
}

// ── IPC init / event (called from workspace/mod.rs) ──

pub fn init(state: &mut AppState) -> Option<super::Connection> {
    let sp = find_socket()?;
    let mut stream = UnixStream::connect(sp).ok()?;
    send(&mut stream, MsgType::Subscribe, Some(r#"["workspace"]"#)).ok()?;
    send(&mut stream, MsgType::GetWorkspaces, None).ok()?;
    if let Ok((_, reply)) = recv(&mut stream) {
        state.i3workspace = Some(serde_json::from_str(&reply).unwrap_or_default());
    }
    let fd = stream.as_raw_fd();
    Some((fd, stream))
}

pub fn handle_event(conn: &mut super::Connection, state: &mut AppState) {
    let (_fd, stream) = conn;
    match recv(stream) {
        Ok((_, _body)) => {
            let _ = send(stream, MsgType::GetWorkspaces, None);
            if let Ok((_, reply)) = recv(stream) {
                state.i3workspace = Some(serde_json::from_str(&reply).unwrap_or_default());
            }
        }
        Err(_) => {}
    }
}

fn find_socket() -> Option<String> {
    if let Ok(env) = std::env::var("I3SOCK") { return Some(env); }
    if let Ok(env) = std::env::var("SWAYSOCK") { return Some(env); }
    if let Ok(rt) = std::env::var("XDG_RUNTIME_DIR") {
        let p = format!("{}/i3", rt);
        if let Ok(dir) = fs::read_dir(&p) {
            for entry in dir.flatten() {
                let name = entry.file_name();
                if name.to_string_lossy().starts_with("ipc-socket.") {
                    return Some(format!("{}/i3/{}", rt, name.to_string_lossy()));
                }
            }
        }
    }
    None
}

fn send(stream: &mut UnixStream, msg_type: MsgType, payload: Option<&str>) -> std::io::Result<()> {
    let len = payload.map_or(0, |s| s.len() as u32);
    let type_val = msg_type as u32;
    let mut hdr = [0u8; 14];
    hdr[..6].copy_from_slice(I3_MAGIC);
    hdr[6..10].copy_from_slice(&len.to_le_bytes());
    hdr[10..14].copy_from_slice(&type_val.to_le_bytes());
    stream.write_all(&hdr)?;
    if let Some(p) = payload && !p.is_empty() { stream.write_all(p.as_bytes())?; }
    Ok(())
}

fn recv(stream: &mut UnixStream) -> std::io::Result<(u32, String)> {
    let mut hdr = [0u8; 14];
    stream.read_exact(&mut hdr)?;
    let len = u32::from_le_bytes(hdr[6..10].try_into().unwrap());
    let type_val = u32::from_le_bytes(hdr[10..14].try_into().unwrap());
    let mut buf = vec![0u8; len as usize];
    stream.read_exact(&mut buf)?;
    String::from_utf8(buf)
        .map(|s| (type_val, s))
        .map_err(|_| std::io::Error::new(std::io::ErrorKind::InvalidData, "invalid UTF-8"))
}

// ── draw ──

pub unsafe fn draw(cr: *mut cairo_sys::cairo_t, x: f64, bh: i32, state: &AppState, dry_run: bool) -> f64 {
    let ws = match &state.i3workspace { Some(w) => w, None => return 0.0 };
    let pad = config::WS_PAD; let gap = config::WS_GAP;
    cairo_sys::cairo_set_font_size(cr, config::FONT_SIZE_MAIN);
    let mut fe: cairo_sys::cairo_font_extents_t = std::mem::zeroed();
    cairo_sys::cairo_font_extents(cr, &mut fe);
    let baseline = (bh as f64 + fe.ascent - fe.descent) / 2.0;

    let mut lx = x;
    for w in ws {
        let name_c = std::ffi::CString::new(w.name.clone()).unwrap();
        let mut te: cairo_sys::cairo_text_extents_t = std::mem::zeroed();
        cairo_sys::cairo_text_extents(cr, name_c.as_ptr(), &mut te);
        let bw = te.x_advance + pad * 2.0; let by = 4.0;

        if !dry_run {
            if w.focused {
                cairo_sys::cairo_set_source_rgb(cr, 0x4c as f64/255., 0x56 as f64/255., 0x6a as f64/255.);
                rrect(cr, lx, by, bw, bh as f64 - by*2.0, 3.0); cairo_sys::cairo_fill(cr);
                cairo_sys::cairo_set_source_rgb(cr, 0xd8 as f64/255., 0xde as f64/255., 0xe9 as f64/255.);
            } else if w.urgent {
                cairo_sys::cairo_set_source_rgb(cr, 0xbd as f64/255., 0x2c as f64/255., 0x40 as f64/255.);
                rrect(cr, lx, by, bw, bh as f64 - by*2.0, 3.0); cairo_sys::cairo_fill(cr);
                cairo_sys::cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
            } else if w.visible {
                cairo_sys::cairo_set_source_rgb(cr, 0x55 as f64/255., 0x55 as f64/255., 0x55 as f64/255.);
                cairo_sys::cairo_rectangle(cr, lx, bh as f64 - 2.0, bw, 2.0); cairo_sys::cairo_fill(cr);
                cairo_sys::cairo_set_source_rgb(cr, 0.8, 0.8, 0.8);
            } else { cairo_sys::cairo_set_source_rgb(cr, 0.6, 0.6, 0.6); }
            cairo_sys::cairo_move_to(cr, lx + pad, baseline);
            cairo_sys::cairo_show_text(cr, name_c.as_ptr());
        }
        lx += bw + gap;
    }
    lx - x - gap
}

pub const MODULE: Module = Module { draw, update: None };
