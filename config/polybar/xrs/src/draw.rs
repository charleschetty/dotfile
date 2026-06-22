// draw.rs — cairo drawing helpers and the draw_all orchestrator

use crate::config;
use crate::modules::{AppState, Module};

pub unsafe fn simple_draw(
    cr: *mut cairo_sys::cairo_t, x: f64, bh: i32,
    font_size: f64, text: &str, dry_run: bool,
) -> f64 {
    cairo_sys::cairo_set_font_size(cr, font_size);
    let mut fe: cairo_sys::cairo_font_extents_t = std::mem::zeroed();
    cairo_sys::cairo_font_extents(cr, &mut fe);
    let baseline = (bh as f64 + fe.ascent - fe.descent) / 2.0;
    if text.is_empty() { return 0.0; }
    let c = std::ffi::CString::new(text).unwrap();
    let mut te: cairo_sys::cairo_text_extents_t = std::mem::zeroed();
    cairo_sys::cairo_text_extents(cr, c.as_ptr(), &mut te);
    if !dry_run {
        cairo_sys::cairo_set_source_rgb(cr, config::FG_R, config::FG_G, config::FG_B);
        cairo_sys::cairo_move_to(cr, x, baseline);
        cairo_sys::cairo_show_text(cr, c.as_ptr());
    }
    te.x_advance
}

pub unsafe fn rrect(cr: *mut cairo_sys::cairo_t, x: f64, y: f64, w: f64, h: f64, r: f64) {
    cairo_sys::cairo_move_to(cr, x + r, y);
    cairo_sys::cairo_line_to(cr, x + w - r, y);
    cairo_sys::cairo_curve_to(cr, x + w, y, x + w, y, x + w, y + r);
    cairo_sys::cairo_line_to(cr, x + w, y + h - r);
    cairo_sys::cairo_curve_to(cr, x + w, y + h, x + w, y + h, x + w - r, y + h);
    cairo_sys::cairo_line_to(cr, x + r, y + h);
    cairo_sys::cairo_curve_to(cr, x, y + h, x, y + h, x, y + h - r);
    cairo_sys::cairo_line_to(cr, x, y + r);
    cairo_sys::cairo_curve_to(cr, x, y, x, y, x + r, y);
    cairo_sys::cairo_close_path(cr);
}

pub unsafe fn draw_all(
    dpy: *mut x11::xlib::Display, cr: *mut cairo_sys::cairo_t,
    sw: i32, bh: i32, state: &AppState,
    left: &[Module], center: &[Module], right: &[Module],
    right_margin: i32,
) {
    cairo_sys::cairo_save(cr);
    cairo_sys::cairo_set_operator(cr, cairo_sys::OPERATOR_SOURCE);
    cairo_sys::cairo_set_source_rgb(cr, config::BG_R, config::BG_G, config::BG_B);
    cairo_sys::cairo_paint(cr);
    cairo_sys::cairo_paint(cr);
    cairo_sys::cairo_select_font_face(cr, config::FONT.as_ptr(),
        cairo_sys::FONT_SLANT_NORMAL, cairo_sys::FONT_WEIGHT_NORMAL);

    let mut lx = 6.0;
    for m in left {
        let w = (m.draw)(cr, lx, bh, state, false);
        if w > 0.0 { lx += w + config::GAP; }
    }

    if !center.is_empty() {
        let widths: Vec<f64> = center.iter().map(|m| (m.draw)(cr, 0.0, bh, state, true)).collect();
        let total: f64 = widths.iter().sum::<f64>()
            + widths.iter().filter(|&&w| w > 0.0).count().saturating_sub(1) as f64 * config::GAP;
        let mut cx = (sw as f64 - total) / 2.0;
        for (i, m) in center.iter().enumerate() {
            let w = widths[i];
            if w > 0.0 { (m.draw)(cr, cx, bh, state, false); cx += w + config::GAP; }
        }
    }

    if !right.is_empty() {
        let widths: Vec<f64> = right.iter().map(|m| (m.draw)(cr, 0.0, bh, state, true)).collect();
        let mut rx = sw as f64 - right_margin as f64;
        for (i, m) in right.iter().enumerate().rev() {
            let w = widths[i];
            if w > 0.0 { rx -= w; (m.draw)(cr, rx, bh, state, false); rx -= config::GAP; }
        }
    }

    cairo_sys::cairo_restore(cr);
    x11::xlib::XFlush(dpy);
}
