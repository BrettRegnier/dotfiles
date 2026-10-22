// Animations/LeafExplosion.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Particles
import qs.Constants
import Quickshell.Hyprland


Item {
    id: root
    required property bool active
    required property int num_leaves

    Canvas {
        id: leaves
        anchors.centerIn: parent
        // extra room around the pill for the leaves to fly into
        property real reach: 70
        width: root.width + reach * 2
        height: root.height + reach * 2

        property real progress: 1   // 0 -> 1 over one burst
        property var items: []

        onProgressChanged: requestPaint()

        // Roll a fresh set of leaves, starting on the pill's edge.
        function spawn() {
            var cx = width / 2, cy = height / 2;
            var hw = root.width / 2, hh = root.height / 2;
            var count = root.num_leaves + Math.floor(Math.random() * 8);
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
                    dist: 25 + Math.random() * 45,           // how far it flies
                    size: 4 + Math.random() * 5,             // leaf half-length
                    rot0: Math.random() * Math.PI * 2,
                    spin: (Math.random() - 0.5) * 9,         // total radians of tumble
                    swayAmp: 2 + Math.random() * 6,
                    swayFreq: 3 + Math.random() * 5,
                    swayPhase: Math.random() * Math.PI * 2,
                    gravity: 8 + Math.random() * 14,         // slight downward droop
                    delay: Math.random() * 0.15,             // staggered launch
                    hue: 0.22 + Math.random() * 0.16,        // yellow-green to green
                    sat: 0.55 + Math.random() * 0.3,
                    light: 0.35 + Math.random() * 0.2
                });
            }
            items = list;
        }

        // Pointed leaf along the y axis, with a midrib.
        function leafShape(ctx, s) {
            ctx.beginPath();
            ctx.moveTo(0, -s);
            ctx.quadraticCurveTo(s * 0.9, -s * 0.1, 0, s);
            ctx.quadraticCurveTo(-s * 0.9, -s * 0.1, 0, -s);
            ctx.closePath();
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.lineCap = "round";

            for (var i = 0; i < items.length; i++) {
                var it = items[i];
                var p = (progress - it.delay) / (1 - it.delay);
                if (p <= 0 || p >= 1)
                    continue;

                // fast burst out, then slow drift
                var e = 1 - Math.pow(1 - p, 3);
                var sway = Math.sin(p * it.swayFreq + it.swayPhase) * it.swayAmp * p;

                // sway is applied perpendicular to the travel direction
                var x = it.sx + it.ca * it.dist * e - it.sa * sway;
                var y = it.sy + it.sa * it.dist * e + it.ca * sway
                        + it.gravity * p * p;

                // pop in, then shrink and fade near the end
                var pop = Math.min(1, p * 6);
                var scale = pop * (1 - 0.4 * p);
                var alpha = p < 0.55 ? 1 : 1 - (p - 0.55) / 0.45;

                ctx.save();
                ctx.translate(x, y);
                ctx.rotate(it.rot0 + it.spin * e);

                leafShape(ctx, it.size * scale);
                ctx.fillStyle = Qt.hsla(it.hue, it.sat, it.light, alpha);
                ctx.fill();

                // midrib
                ctx.beginPath();
                ctx.moveTo(0, -it.size * scale * 0.8);
                ctx.lineTo(0, it.size * scale * 0.8);
                ctx.lineWidth = 0.8;
                ctx.strokeStyle = Qt.hsla(it.hue, it.sat, it.light + 0.2, alpha * 0.8);
                ctx.stroke();

                ctx.restore();
            }
        }
    }

    // One burst: leaves fly out and fade
    NumberAnimation {
        id: burst
        target: leaves
        property: "progress"
        from: 0
        to: 1
        duration: 900
        easing.type: Easing.Linear
    }

    // New burst at irregular intervals
    Timer {
        running: root.active
        repeat: false
        interval: 1
        triggeredOnStart: false
        onTriggered: {
            leaves.spawn();
            burst.restart();
        }
    }
}
