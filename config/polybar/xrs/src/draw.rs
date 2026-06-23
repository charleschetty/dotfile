// draw.rs — cairo drawing helpers and the draw_all orchestrator

use crate::config;
use crate::modules::{AppState, Module};
use cairo::Context;
use x11rb::connection::Connection;

pub fn simple_draw(
    cr: &Context,
    x: f64,
    bh: i32,
    font_size: f64,
    text: &str,
    dry_run: bool,
) -> f64 {
    cr.set_font_size(font_size);
    let fe = cr.font_extents().unwrap();
    let baseline = (bh as f64 + fe.ascent() - fe.descent()) / 2.0;
    if text.is_empty() {
        return 0.0;
    }
    let te = cr.text_extents(text).unwrap();
    if !dry_run {
        cr.set_source_rgb(config::FG_R, config::FG_G, config::FG_B);
        cr.move_to(x, baseline);
        let _ = cr.show_text(text);
    }
    te.x_advance()
}

pub fn rrect(cr: &Context, x: f64, y: f64, w: f64, h: f64, r: f64) {
    cr.move_to(x + r, y);
    cr.line_to(x + w - r, y);
    cr.curve_to(x + w, y, x + w, y, x + w, y + r);
    cr.line_to(x + w, y + h - r);
    cr.curve_to(x + w, y + h, x + w, y + h, x + w - r, y + h);
    cr.line_to(x + r, y + h);
    cr.curve_to(x, y + h, x, y + h, x, y + h - r);
    cr.line_to(x, y + r);
    cr.curve_to(x, y, x, y, x + r, y);
    cr.close_path();
}

#[allow(clippy::too_many_arguments)]
pub fn draw_all(
    conn: &impl Connection,
    cr: &Context,
    sw: i32,
    bh: i32,
    state: &AppState,
    left: &[Module],
    center: &[Module],
    right: &[Module],
    right_margin: i32,
) {
    let _ = cr.save();
    cr.set_operator(cairo::Operator::Source);
    cr.set_source_rgb(config::BG_R, config::BG_G, config::BG_B);
    let _ = cr.paint();
    let _ = cr.paint();
    cr.select_font_face(
        config::FONT.to_str().unwrap(),
        cairo::FontSlant::Normal,
        cairo::FontWeight::Normal,
    );

    let mut lx = 6.0;
    for m in left {
        let w = (m.draw)(cr, lx, bh, state, false);
        if w > 0.0 {
            lx += w + config::GAP;
        }
    }

    if !center.is_empty() {
        let widths: Vec<f64> = center
            .iter()
            .map(|m| (m.draw)(cr, 0.0, bh, state, true))
            .collect();
        let total: f64 = widths.iter().sum::<f64>()
            + widths
                .iter()
                .filter(|&&w| w > 0.0)
                .count()
                .saturating_sub(1) as f64
                * config::GAP;
        let mut cx = (sw as f64 - total) / 2.0;
        for (i, m) in center.iter().enumerate() {
            let w = widths[i];
            if w > 0.0 {
                (m.draw)(cr, cx, bh, state, false);
                cx += w + config::GAP;
            }
        }
    }

    if !right.is_empty() {
        let widths: Vec<f64> = right
            .iter()
            .map(|m| (m.draw)(cr, 0.0, bh, state, true))
            .collect();
        let mut rx = sw as f64 - right_margin as f64;
        for (i, m) in right.iter().enumerate().rev() {
            let w = widths[i];
            if w > 0.0 {
                rx -= w;
                (m.draw)(cr, rx, bh, state, false);
                rx -= config::GAP;
            }
        }
    }

    let _ = cr.restore();
    let _ = conn.flush();
}
