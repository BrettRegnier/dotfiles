import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Particles
import qs.Constants
import Quickshell.Hyprland

Item {
    width: 400
    height: 100

    Row {
        spacing: 0 
        Repeater {
            model: 5


            delegate: Rectangle {
                id: workspace_button
                property bool hovered: false
                property var workspace: Hyprland.workspaces.values[index]
                property bool is_active: workspace != null && workspace.active
                property int pad: 26           // room around the pill for bolts to reach into

                width: 45
                height: 30 
                radius: 5
                z: 1

                color: hovered ? "steelblue" : is_active ? "#FF89b4fa" : "#00000000"
                // ---- lightning layer (drawn behind the pill) ----
                Canvas {
                    id: bolts
                    anchors.centerIn: parent
                    width: workspace_button.width + workspace_button.pad * 2
                    height: workspace_button.height + workspace_button.pad * 2
                    opacity: 0

                    // Jagged line between two points using midpoint displacement.
                    function jag(x1, y1, x2, y2, disp, depth) {
                        var pts = [[x1, y1], [x2, y2]];
                        for (var d = 0; d < depth; d++) {
                            var next = [pts[0]];
                            for (var i = 0; i < pts.length - 1; i++) {
                                var a = pts[i], b = pts[i + 1];
                                var dx = b[0] - a[0], dy = b[1] - a[1];
                                var len = Math.sqrt(dx * dx + dy * dy) || 1;
                                var off = (Math.random() - 0.5) * 2 * disp;
                                next.push([(a[0] + b[0]) / 2 - dy / len * off,
                                           (a[1] + b[1]) / 2 + dx / len * off]);
                                next.push(b);
                            }
                            pts = next;
                            disp /= 2;
                        }
                        return pts;
                    }

                    function stroke(ctx, pts, w, color) {
                        ctx.beginPath();
                        ctx.moveTo(pts[0][0], pts[0][1]);
                        for (var i = 1; i < pts.length; i++)
                            ctx.lineTo(pts[i][0], pts[i][1]);
                        ctx.lineWidth = w;
                        ctx.strokeStyle = color;
                        ctx.stroke();
                    }

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";

                        var cx = width / 2, cy = height / 2;
                        var hw = workspace_button.width / 2, hh = workspace_button.height / 2;
                        var count = 2 + Math.floor(Math.random() * 3);

                        for (var n = 0; n < count; n++) {
                            // pick a random direction and start on the pill's edge
                            var ang = Math.random() * Math.PI * 2;
                            var ca = Math.cos(ang), sa = Math.sin(ang);
                            var edge = Math.min(hw / Math.max(Math.abs(ca), 0.001),
                                                hh / Math.max(Math.abs(sa), 0.001));
                            var sx = cx + ca * edge * 0.9, sy = cy + sa * edge * 0.9;

                            var len = 14 + Math.random() * 14;
                            var jitter = (Math.random() - 0.5) * 0.8;
                            var ex = sx + Math.cos(ang + jitter) * len;
                            var ey = sy + Math.sin(ang + jitter) * len;

                            var main = jag(sx, sy, ex, ey, len * 0.35, 4);

                            // glow pass, then bright core
                            stroke(ctx, main, 5, "rgba(70, 150, 255, 0.25)");
                            stroke(ctx, main, 2.5, "rgba(120, 190, 255, 0.5)");
                            stroke(ctx, main, 1, "rgba(235, 248, 255, 1.0)");

                            // occasional fork off the middle of the bolt
                            if (Math.random() < 0.5) {
                                var mid = main[Math.floor(main.length / 2)];
                                var fa = ang + (Math.random() - 0.5) * 1.6;
                                var fl = len * (0.4 + Math.random() * 0.3);
                                var fork = jag(mid[0], mid[1],
                                               mid[0] + Math.cos(fa) * fl,
                                               mid[1] + Math.sin(fa) * fl, fl * 0.3, 3);
                                stroke(ctx, fork, 3, "rgba(70, 150, 255, 0.25)");
                                stroke(ctx, fork, 0.9, "rgba(220, 240, 255, 0.9)");
                            }
                        }
                    }
                }

                // Fast flash: snap on, quick fade (with a little stutter, like real lightning)
                SequentialAnimation {
                    id: flash
                    NumberAnimation { target: bolts; property: "opacity"; to: 1; duration: 15 }
                    NumberAnimation { target: bolts; property: "opacity"; to: 0.35; duration: 40 }
                    NumberAnimation { target: bolts; property: "opacity"; to: 0.9; duration: 20 }
                    NumberAnimation { target: bolts; property: "opacity"; to: 0; duration: 110 }
                }

                // New bolt pattern at irregular intervals
                Timer {
                    running: workspace_button.is_active
                    repeat: true
                    interval: 80
                    triggeredOnStart: true
                    onTriggered: {
                        interval = 70 + Math.random() * 230;
                        bolts.requestPaint();
                        flash.restart();
                    }
                }

                Behavior on color {
                    ColorAnimation { duration: 250 }
                }

                Text {
                    text: index+1
                    anchors.centerIn: parent
                    font.pixelSize: 14
                    font.family: "Rubik"
                    font.bold: workspace_button.is_active ? true : false
                    color: workspace_button.hovered ? "black" : workspace_button.is_active ? "black" : "#6c7086"

                    Behavior on color {
                        ColorAnimation { duration: 250 }
                    }
                }

                HoverHandler { 
                    cursorShape: Qt.PointingHandCursor
                    onHoveredChanged: workspace_button.hovered = hovered
                }

                Process {
                    id: change_workspace
                    running: false
                    command: ["hyprctl", "dispatch", `hl.dsp.focus({workspace=${index+1}})`]
                }

                TapHandler {
                    onTapped: change_workspace.running = true 
                }
            }

        }
    }
}
