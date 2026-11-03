// Animations/SnowExplosion.qml
import QtQuick

Item {
    id: root
    required property bool active
    required property int num_flakes

    Canvas {
        id: flakes
        anchors.centerIn: parent
        // extra room around the pill for the flakes to fly into
        property real reach: 70
        width: root.width + reach * 2
        height: root.height + reach * 2

        property real progress: 1   // 0 -> 1 over one burst
        property var items: []

        onProgressChanged: requestPaint()

        // Roll a fresh set of snowflakes, starting on the pill's edge.
        function spawn() {
            var cx = width / 2, cy = height / 2;
            var hw = root.width / 2, hh = root.height / 2;
            var count = root.num_flakes + Math.floor(Math.random() * 8);
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
                    dist: 20 + Math.random() * 40,           // how far it flies
                    size: 3 + Math.random() * 4,             // arm length
                    rot0: Math.random() * Math.PI * 2,
                    spin: (Math.random() - 0.5) * 3,         // slow, gentle rotation
                    swayAmp: 3 + Math.random() * 7,
                    swayFreq: 2 + Math.random() * 4,
                    swayPhase: Math.random() * Math.PI * 2,
                    gravity: 15 + Math.random() * 20,        // snow drifts downward
                    delay: Math.random() * 0.15,             // staggered launch
                    hue: 0.52 + Math.random() * 0.08,        // icy cyan to light blue
                    sat: 0.3 + Math.random() * 0.5,
                    light: 0.82 + Math.random() * 0.13
                });
            }
            items = list;
        }

        // Six-armed snowflake with a pair of branches on each arm.
        function flakeShape(ctx, s) {
            var branchPos = s * 0.55;
            var branchLen = s * 0.38;
            var a = Math.PI / 3;   // 60 degrees between arms

            ctx.beginPath();
            for (var k = 0; k < 6; k++) {
                ctx.save();
                ctx.rotate(k * a);

                // main arm
                ctx.moveTo(0, 0);
                ctx.lineTo(0, -s);

                // branches
                ctx.moveTo(0, -branchPos);
                ctx.lineTo(Math.sin(a) * branchLen, -branchPos - Math.cos(a) * branchLen);
                ctx.moveTo(0, -branchPos);
                ctx.lineTo(-Math.sin(a) * branchLen, -branchPos - Math.cos(a) * branchLen);

                ctx.restore();
            }
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
                var scale = pop * (1 - 0.3 * p);
                var alpha = p < 0.55 ? 1 : 1 - (p - 0.55) / 0.45;

                ctx.save();
                ctx.translate(x, y);
                ctx.rotate(it.rot0 + it.spin * e);

                flakeShape(ctx, it.size * scale);
                ctx.lineWidth = Math.max(0.8, it.size * scale * 0.16);
                ctx.strokeStyle = Qt.hsla(it.hue, it.sat, it.light, alpha);
                ctx.stroke();

                // bright center dot
                ctx.beginPath();
                ctx.arc(0, 0, Math.max(0.6, it.size * scale * 0.12), 0, Math.PI * 2);
                ctx.fillStyle = Qt.hsla(it.hue, it.sat, Math.min(1, it.light + 0.1), alpha);
                ctx.fill();

                ctx.restore();
            }
        }
    }

    // One burst: flakes fly out, drift and fade
    NumberAnimation {
        id: burst
        target: flakes
        property: "progress"
        from: 0
        to: 1
        duration: 1200
        easing.type: Easing.Linear
    }

    // Trigger a burst when activated
    Timer {
        running: root.active
        repeat: false
        interval: 1
        triggeredOnStart: false
        onTriggered: {
            flakes.spawn();
            burst.restart();
        }
    }
}
