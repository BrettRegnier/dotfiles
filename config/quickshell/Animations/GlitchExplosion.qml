// Animations/GlitchExplosion.qml
import QtQuick

Item {
    id: root
    required property bool active
    required property int num_pixels

    Canvas {
        id: glitch
        anchors.centerIn: parent
        // extra room around the pill for the pixels to fly into
        property real reach: 70
        width: root.width + reach * 2
        height: root.height + reach * 2

        property real progress: 1   // 0 -> 1 over one burst
        property var items: []
        property var slices: []

        // number of discrete "frames" per burst; motion snaps between them
        readonly property int steps: 14

        onProgressChanged: requestPaint()

        // Deterministic pseudo-random in [0, 1) so each step is stable per pixel.
        function rnd(a, b) {
            var s = Math.sin(a * 12.9898 + b * 78.233) * 43758.5453;
            return s - Math.floor(s);
        }

        // Roll a fresh set of glitch pixels, starting on the pill's edge.
        function spawn() {
            var cx = width / 2, cy = height / 2;
            var hw = root.width / 2, hh = root.height / 2;
            var count = root.num_pixels + Math.floor(Math.random() * 8);
            var list = [];

            for (var n = 0; n < count; n++) {
                var ang = Math.random() * Math.PI * 2;
                var ca = Math.cos(ang), sa = Math.sin(ang);
                var edge = Math.min(hw / Math.max(Math.abs(ca), 0.001),
                                    hh / Math.max(Math.abs(sa), 0.001));
                list.push({
                    sx: cx + ca * edge * 0.95,
                    sy: cy + sa * edge * 0.95,
                    ca: ca,
                    sa: sa,
                    dist: 20 + Math.random() * 45,           // how far it flies
                    grid: 2 + Math.floor(Math.random() * 4), // pixel block size (2-5)
                    stretch: Math.random() < 0.2 ? 2 + Math.floor(Math.random() * 3) : 1,
                    jitter: 3 + Math.random() * 10,          // per-step random shake
                    split: 1 + Math.random() * 3,            // RGB channel offset
                    delay: Math.random() * 0.15,             // staggered launch
                    seed: Math.random() * 100
                });
            }
            items = list;

            // A few wide scanline slices that flash near the pill
            var sl = [];
            var sliceCount = 3 + Math.floor(Math.random() * 3);
            for (var m = 0; m < sliceCount; m++) {
                sl.push({
                    x: cx + (Math.random() - 0.5) * hw * 1.6,
                    y: cy + (Math.random() - 0.5) * hh * 2.4,
                    w: 14 + Math.random() * 40,
                    h: 1 + Math.floor(Math.random() * 3),
                    shift: (Math.random() - 0.5) * 16,
                    delay: Math.random() * 0.5,
                    life: 0.08 + Math.random() * 0.12,
                    seed: Math.random() * 100
                });
            }
            slices = sl;
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            // overlapping magenta + cyan + white sum toward bright white
            ctx.globalCompositeOperation = "lighter";

            // ---- pixels ----
            for (var i = 0; i < items.length; i++) {
                var it = items[i];
                var p = (progress - it.delay) / (1 - it.delay);
                if (p <= 0 || p >= 1)
                    continue;

                // quantize time so motion snaps between frames
                var step = Math.floor(p * steps);
                var sp = step / steps;

                // random dropout, getting more frequent as it ages
                if (rnd(it.seed + 2, step) < p * 0.55)
                    continue;

                var e = 1 - Math.pow(1 - sp, 3);
                var x = it.sx + it.ca * it.dist * e
                        + (rnd(it.seed, step) - 0.5) * it.jitter * (0.3 + p);
                var y = it.sy + it.sa * it.dist * e
                        + (rnd(it.seed + 1, step) - 0.5) * it.jitter * (0.3 + p);

                // snap to the pixel grid
                var g = it.grid;
                x = Math.round(x / g) * g;
                y = Math.round(y / g) * g;

                var w = g * it.stretch;
                var h = g;
                var alpha = p < 0.6 ? 1 : 1 - (p - 0.6) / 0.4;

                // chromatic split that changes every frame
                var off = it.split * (0.5 + rnd(it.seed + 3, step));

                ctx.fillStyle = Qt.rgba(1, 0, 0.8, alpha * 0.9);   // magenta
                ctx.fillRect(x - w / 2 - off, y - h / 2, w, h);

                ctx.fillStyle = Qt.rgba(0, 0.9, 1, alpha * 0.9);   // cyan
                ctx.fillRect(x - w / 2 + off, y - h / 2, w, h);

                ctx.fillStyle = Qt.rgba(1, 1, 1, alpha * 0.7);     // white core
                ctx.fillRect(x - w / 2, y - h / 2, w, h);
            }

            // ---- scanline slices ----
            for (var j = 0; j < slices.length; j++) {
                var s = slices[j];
                var q = (progress - s.delay) / s.life;
                if (q <= 0 || q >= 1)
                    continue;

                // flicker on and off within its short life
                var fstep = Math.floor(q * 4);
                if (rnd(s.seed, fstep) < 0.3)
                    continue;

                var a = 1 - q;
                var sx = s.x + (rnd(s.seed + 1, fstep) - 0.5) * s.shift;

                ctx.fillStyle = Qt.rgba(1, 0, 0.8, a * 0.8);
                ctx.fillRect(sx - s.w / 2 - 2, s.y, s.w, s.h);
                ctx.fillStyle = Qt.rgba(0, 0.9, 1, a * 0.8);
                ctx.fillRect(sx - s.w / 2 + 2, s.y, s.w, s.h);
            }
        }
    }

    // One burst: pixels snap outward, flicker and drop out
    NumberAnimation {
        id: burst
        target: glitch
        property: "progress"
        from: 0
        to: 1
        duration: 700
        easing.type: Easing.Linear
    }

    // Trigger a burst when activated
    Timer {
        running: root.active
        repeat: false
        interval: 1
        triggeredOnStart: false
        onTriggered: {
            glitch.spawn();
            burst.restart();
        }
    }
}
