// Animations/FireExplosion.qml
import QtQuick

Item {
    id: root
    required property bool active
    required property int num_fireballs

    Canvas {
        id: fire
        anchors.centerIn: parent
        // extra room around the pill for the fireballs to fly into
        property real reach: 80
        width: root.width + reach * 2
        height: root.height + reach * 2

        property real progress: 1   // 0 -> 1 over one burst
        property var items: []

        onProgressChanged: requestPaint()

        // Roll a fresh set of fireballs, starting on the pill's edge.
        function spawn() {
            var cx = width / 2, cy = height / 2;
            var hw = root.width / 2, hh = root.height / 2;
            var count = root.num_fireballs + Math.floor(Math.random() * 8);
            var list = [];

            for (var n = 0; n < count; n++) {
                var ang = Math.random() * Math.PI * 2;
                var ca = Math.cos(ang), sa = Math.sin(ang);
                var edge = Math.min(hw / Math.max(Math.abs(ca), 0.001),
                                    hh / Math.max(Math.abs(sa), 0.001));
                list.push({
                    sx: cx + ca * edge * 0.9,
                    sy: cy + sa * edge * 0.9,
                    ca: ca,
                    sa: sa,
                    dist: 25 + Math.random() * 50,           // how far it flies
                    size: 4 + Math.random() * 6,             // fireball radius
                    swayAmp: 1 + Math.random() * 4,          // flame wobble
                    swayFreq: 5 + Math.random() * 7,
                    swayPhase: Math.random() * Math.PI * 2,
                    rise: 10 + Math.random() * 25,           // heat rises
                    flicker: 8 + Math.random() * 10,
                    delay: Math.random() * 0.12,             // staggered launch
                    hueStart: 0.11 + Math.random() * 0.05,   // yellow-orange core
                    hueEnd: 0.0 + Math.random() * 0.03       // deep red at the end
                });
            }
            items = list;
        }

        // Position of a fireball at normalized life p.
        function posX(it, p) {
            var e = 1 - Math.pow(1 - p, 3);
            var sway = Math.sin(p * it.swayFreq + it.swayPhase) * it.swayAmp * p;
            return it.sx + it.ca * it.dist * e - it.sa * sway;
        }

        function posY(it, p) {
            var e = 1 - Math.pow(1 - p, 3);
            var sway = Math.sin(p * it.swayFreq + it.swayPhase) * it.swayAmp * p;
            return it.sy + it.sa * it.dist * e + it.ca * sway
                   - it.rise * p * p;
        }

        // Soft glowing blob: hot core fading to transparent edge.
        function glow(ctx, x, y, r, hue, light, alpha) {
            var g = ctx.createRadialGradient(x, y, 0, x, y, r);
            g.addColorStop(0.0, Qt.hsla(hue, 1.0, Math.min(1, light + 0.15), alpha));
            g.addColorStop(0.4, Qt.hsla(hue, 1.0, light, alpha * 0.8));
            g.addColorStop(1.0, Qt.hsla(hue, 1.0, light * 0.6, 0));
            ctx.fillStyle = g;
            ctx.beginPath();
            ctx.arc(x, y, r, 0, Math.PI * 2);
            ctx.fill();
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            // overlapping flames add up to a brighter, hotter glow
            ctx.globalCompositeOperation = "lighter";

            for (var i = 0; i < items.length; i++) {
                var it = items[i];
                var p = (progress - it.delay) / (1 - it.delay);
                if (p <= 0 || p >= 1)
                    continue;

                // color cools from yellow-white to orange to red
                var hue = it.hueStart + (it.hueEnd - it.hueStart) * p;
                var light = 0.7 - 0.3 * p;

                // pop in, flicker, then shrink and fade near the end
                var pop = Math.min(1, p * 8);
                var flick = 1 + 0.15 * Math.sin(p * it.flicker + it.swayPhase);
                var scale = pop * (1 - 0.65 * p) * flick;
                var alpha = p < 0.4 ? 1 : 1 - (p - 0.4) / 0.6;

                // short fading trail behind the head
                for (var t = 3; t >= 1; t--) {
                    var tp = p - t * 0.035;
                    if (tp <= 0)
                        continue;
                    var k = 1 - t / 4;
                    glow(ctx, posX(it, tp), posY(it, tp),
                         it.size * scale * (0.5 + 0.4 * k),
                         hue, light - 0.05, alpha * 0.35 * k);
                }

                // head
                glow(ctx, posX(it, p), posY(it, p),
                     it.size * scale, hue, light, alpha);
            }
        }
    }

    // One burst: fireballs fly out, cool and fade
    NumberAnimation {
        id: burst
        target: fire
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
            fire.spawn();
            burst.restart();
        }
    }
}
