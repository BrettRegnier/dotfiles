// Animations/LightningExplosion.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Particles
import qs.Constants
import Quickshell.Hyprland


Item {
    id: root
    required property bool active
    required property int num_sparks   // number of lightning balls (a few extra are rolled randomly)

    Canvas {
        id: balls
        anchors.centerIn: parent
        // extra room around the pill for the balls to fly into
        property real reach: 70
        width: root.width + reach * 2
        height: root.height + reach * 2

        property real progress: 1   // 0 -> 1 over one burst
        property var orbs: []
        property var flecks: []

        onProgressChanged: requestPaint()

        // Cheap deterministic noise in [0,1) so crackles can re-roll each "frame".
        function hash(n) {
            var s = Math.sin(n * 12.9898) * 43758.5453;
            return s - Math.floor(s);
        }

        function edgePoint(ca, sa) {
            var cx = width / 2, cy = height / 2;
            var hw = root.width / 2, hh = root.height / 2;
            var edge = Math.min(hw / Math.max(Math.abs(ca), 0.001),
                                hh / Math.max(Math.abs(sa), 0.001));
            return { x: cx + ca * edge * 0.95, y: cy + sa * edge * 0.95 };
        }

        // Roll a fresh set of lightning balls and loose sparks.
        function spawn() {
            var list = [];
            var count = root.num_sparks + Math.floor(Math.random() * 3);
            for (var n = 0; n < count; n++) {
                var ang = Math.random() * Math.PI * 2;
                var ca = Math.cos(ang), sa = Math.sin(ang);
                var p0 = edgePoint(ca, sa);
                list.push({
                    sx: p0.x, sy: p0.y, ca: ca, sa: sa,
                    dist: 22 + Math.random() * 38,            // how far it drifts
                    radius: 4.5 + Math.random() * 4,          // size of the ball
                    arcs: 5 + Math.floor(Math.random() * 4),  // crackles around it
                    wobble: 2 + Math.random() * 4,
                    wobbleFreq: 8 + Math.random() * 8,
                    wobblePhase: Math.random() * Math.PI * 2,
                    delay: Math.random() * 0.15,
                    seed: Math.random() * 1000
                });
            }
            orbs = list;

            var fl = [];
            var fcount = root.num_sparks * 4 + Math.floor(Math.random() * 8);
            for (var k = 0; k < fcount; k++) {
                var a2 = Math.random() * Math.PI * 2;
                var c2 = Math.cos(a2), s2 = Math.sin(a2);
                var q = edgePoint(c2, s2);
                fl.push({
                    sx: q.x, sy: q.y, ca: c2, sa: s2,
                    dist: 15 + Math.random() * 40,
                    size: 0.8 + Math.random() * 1.2,
                    gravity: 4 + Math.random() * 12,
                    delay: Math.random() * 0.25,
                    life: 0.4 + Math.random() * 0.35
                });
            }
            flecks = fl;
        }

        // A short jagged crackle leaping off the ball. Re-rolled every frame index.
        function crackle(ctx, x, y, r, seed, frame, alpha) {
            var ang = hash(seed + frame * 13.7) * Math.PI * 2;
            var len = r * (1.2 + hash(seed + frame * 5.3 + 1) * 1.6);
            var ca = Math.cos(ang), sa = Math.sin(ang);
            var px = -sa, py = ca;
            var segs = 3 + Math.floor(hash(seed + frame * 2.1 + 2) * 2);

            ctx.beginPath();
            ctx.moveTo(x + ca * r * 0.5, y + sa * r * 0.5);
            for (var i = 1; i <= segs; i++) {
                var t = i / segs;
                var off = (hash(seed + frame * 9.1 + i * 3.7) - 0.5) * r * 0.9 * (1 - t * 0.4);
                var d = r * 0.5 + (len - r * 0.5) * t;
                ctx.lineTo(x + ca * d + px * off, y + sa * d + py * off);
            }
            ctx.lineJoin = "round";
            ctx.lineCap = "round";
            ctx.lineWidth = 3;
            ctx.strokeStyle = Qt.rgba(0.35, 0.55, 1.0, alpha * 0.35);
            ctx.stroke();
            ctx.lineWidth = 1.1;
            ctx.strokeStyle = Qt.rgba(0.9, 0.95, 1.0, alpha);
            ctx.stroke();
        }

        // The orb itself: soft blue halo, hot white core.
        function drawBall(ctx, x, y, r, alpha) {
            var g = ctx.createRadialGradient(x, y, 0, x, y, r * 3.4);
            g.addColorStop(0.0, Qt.rgba(1.0, 1.0, 1.0, alpha));
            g.addColorStop(0.18, Qt.rgba(0.75, 0.88, 1.0, alpha * 0.95));
            g.addColorStop(0.45, Qt.rgba(0.35, 0.55, 1.0, alpha * 0.45));
            g.addColorStop(1.0, Qt.rgba(0.15, 0.25, 1.0, 0));
            ctx.fillStyle = g;
            ctx.beginPath();
            ctx.arc(x, y, r * 3.4, 0, Math.PI * 2);
            ctx.fill();

            ctx.fillStyle = Qt.rgba(1.0, 1.0, 1.0, alpha);
            ctx.beginPath();
            ctx.arc(x, y, r * 0.55, 0, Math.PI * 2);
            ctx.fill();
        }

        function roundedRectPath(ctx, x, y, w, h, r) {
            r = Math.min(r, w / 2, h / 2);
            ctx.beginPath();
            ctx.moveTo(x + r, y);
            ctx.lineTo(x + w - r, y);
            ctx.arc(x + w - r, y + r, r, -Math.PI / 2, 0);
            ctx.lineTo(x + w, y + h - r);
            ctx.arc(x + w - r, y + h - r, r, 0, Math.PI / 2);
            ctx.lineTo(x + r, y + h);
            ctx.arc(x + r, y + h - r, r, Math.PI / 2, Math.PI);
            ctx.lineTo(x, y + r);
            ctx.arc(x + r, y + r, r, Math.PI, Math.PI * 1.5);
            ctx.closePath();
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var frame = Math.floor(progress * 30);   // crackles re-roll ~40 times/sec

            // --- electric flash hugging the pill edge
            if (progress < 0.25) {
                var fp = progress / 0.25;
                var fa = (1 - fp) * (0.55 + 0.45 * Math.abs(Math.sin(progress * 90)));
                var rx = (width - root.width) / 2, ry = (height - root.height) / 2;
                roundedRectPath(ctx, rx, ry, root.width, root.height, root.height / 2);
                ctx.lineWidth = 5;
                ctx.strokeStyle = Qt.rgba(0.25, 0.4, 1.0, fa * 0.25);
                ctx.stroke();
                ctx.lineWidth = 2;
                ctx.strokeStyle = Qt.rgba(0.55, 0.75, 1.0, fa * 0.6);
                ctx.stroke();
                ctx.lineWidth = 0.9;
                ctx.strokeStyle = Qt.rgba(0.95, 0.98, 1.0, fa);
                ctx.stroke();
            }

            // --- lightning balls
            for (var i = 0; i < orbs.length; i++) {
                var o = orbs[i];
                var p = (progress - o.delay) / (1 - o.delay);
                if (p <= 0 || p >= 1) continue;

                // quick launch off the pill, then a slow drift
                var e = 1 - Math.pow(1 - p, 3);
                var w = Math.sin(p * o.wobbleFreq + o.wobblePhase) * o.wobble * p;
                var x = o.sx + o.ca * o.dist * e - o.sa * w;
                var y = o.sy + o.sa * o.dist * e + o.ca * w;

                // pop in, pulse, then collapse and fade
                var pop = Math.min(1, p * 7);
                var pulse = 1 + 0.18 * Math.sin(p * 50 + o.seed);
                var shrink = p < 0.6 ? 1 : 1 - (p - 0.6) / 0.4 * 0.7;
                var r = o.radius * pop * pulse * shrink;
                var alpha = p < 0.6 ? 1 : 1 - (p - 0.6) / 0.4;

                drawBall(ctx, x, y, r, alpha);

                for (var c = 0; c < o.arcs; c++) {
                    // each crackle flickers on and off independently
                    var on = hash(o.seed + c * 31.3 + frame * 3.9);
                    if (on < 0.3) continue;
                    crackle(ctx, x, y, r, o.seed + c * 17.1, frame, alpha);
                }
            }

            // --- tiny loose sparks
            for (var k = 0; k < flecks.length; k++) {
                var s = flecks[k];
                var sp = (progress - s.delay) / s.life;
                if (sp <= 0 || sp >= 1) continue;

                var se = 1 - Math.pow(1 - sp, 3);
                var sx = s.sx + s.ca * s.dist * se;
                var sy = s.sy + s.sa * s.dist * se + s.gravity * sp * sp;
                var sa2 = (1 - sp) * (0.6 + 0.4 * Math.abs(Math.sin(progress * 70 + k)));

                ctx.fillStyle = Qt.rgba(0.4, 0.6, 1.0, sa2 * 0.4);
                ctx.beginPath();
                ctx.arc(sx, sy, s.size * 2, 0, Math.PI * 2);
                ctx.fill();
                ctx.fillStyle = Qt.rgba(0.95, 0.98, 1.0, sa2);
                ctx.beginPath();
                ctx.arc(sx, sy, s.size * 0.8, 0, Math.PI * 2);
                ctx.fill();
            }
        }
    }

    // One burst: balls pop out, crackle and fizzle
    NumberAnimation {
        id: burst
        target: balls
        property: "progress"
        from: 0
        to: 1
        duration: 800
        easing.type: Easing.Linear
    }

    // Trigger a burst when activated
    Timer {
        running: root.active
        repeat: false
        interval: 1
        triggeredOnStart: false
        onTriggered: {
            balls.spawn();
            burst.restart();
        }
    }
}
