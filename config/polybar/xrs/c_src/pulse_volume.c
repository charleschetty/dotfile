#include <pulse/pulseaudio.h>
#include <stdint.h>

static pa_mainloop *pa_ml = NULL;
static pa_context *pa_ctx = NULL;
static int pa_ok = 0;

struct pa_data { int vol; int muted; int done; };

static void pa_sink_cb(pa_context *c, const pa_sink_info *i, int eol, void *ud)
{
    (void)c;
    struct pa_data *d = ud;
    if (eol || !i) { d->done = 1; return; }
    if (i->mute) d->muted = 1;
    if (i->volume.channels > 0) {
        pa_volume_t avg = 0;
        for (uint8_t ch = 0; ch < i->volume.channels; ch++)
            avg += i->volume.values[ch];
        avg /= i->volume.channels;
        d->vol = (int)(avg * 100 / PA_VOLUME_NORM);
    }
    d->done = 1;
}

static void pa_server_cb(pa_context *c, const pa_server_info *i, void *ud)
{
    if (i) {
        pa_operation *op = pa_context_get_sink_info_by_name(c, i->default_sink_name, pa_sink_cb, ud);
        if (op) pa_operation_unref(op);
    } else
        ((struct pa_data*)ud)->done = 1;
}

static void pa_state_cb(pa_context *c, void *ud)
{
    pa_context_state_t s = pa_context_get_state(c);
    if (s == PA_CONTEXT_READY) {
        pa_ok = 1;
        pa_operation *op = pa_context_get_server_info(c, pa_server_cb, ud);
        if (op) pa_operation_unref(op);
    } else if (s == PA_CONTEXT_FAILED || s == PA_CONTEXT_TERMINATED) {
        pa_ok = 0;
        ((struct pa_data*)ud)->done = 1;
    }
}

void read_volume_both(int *vol, int *muted)
{
    *vol = -1; *muted = 0;
    struct pa_data d = {0};

    if (!pa_ml) {
        pa_ml = pa_mainloop_new();
        if (!pa_ml) return;
    }

    if (!pa_ctx) {
        pa_ctx = pa_context_new(pa_mainloop_get_api(pa_ml), "xrs");
        if (!pa_ctx) return;
        pa_context_set_state_callback(pa_ctx, pa_state_cb, &d);
        if (pa_context_connect(pa_ctx, NULL, PA_CONTEXT_NOFLAGS, NULL) < 0) {
            pa_context_unref(pa_ctx); pa_ctx = NULL; return;
        }
        int timeout = 300;
        while (!d.done && timeout-- > 0)
            pa_mainloop_iterate(pa_ml, 1, NULL);
        if (d.done && pa_ok) { *vol = d.vol; *muted = d.muted; }
        return;
    }

    if (!pa_ok) {
        pa_context_unref(pa_ctx); pa_ctx = NULL;
        return;
    }

    for (int i = 0; i < 5; i++)
        pa_mainloop_iterate(pa_ml, 0, NULL);

    if (!pa_ok) { pa_context_unref(pa_ctx); pa_ctx = NULL; return; }

    pa_operation *op = pa_context_get_server_info(pa_ctx, pa_server_cb, &d);
    if (op) pa_operation_unref(op);
    int timeout = 50;
    while (!d.done && timeout-- > 0)
        pa_mainloop_iterate(pa_ml, 1, NULL);

    if (d.done) { *vol = d.vol; *muted = d.muted; }
}
