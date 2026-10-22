import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Particles
import qs.Constants
import Quickshell.Hyprland
import qs.Animations

Item {
    id: root

    required property int monitor_num
    required property int num_workspaces

    Row {
        spacing: 0 
        Repeater {
            model: root.num_workspaces


            delegate: Rectangle {
                id: workspace_button
                property bool hovered: false
                property int workspace_id: index + root.monitor_num * root.num_workspaces + 1
                property var workspace: Hyprland.workspaces.values.find(ws => ws.id === workspace_id)
                property bool is_active: workspace != null && workspace.active
                property int pad: 26           // room around the pill for bolts to reach into

                width: 45
                height: 30 
                radius: 5
                z: 1

                color: hovered ? "#cc93C572" : is_active ? "#ccD0F0C0" : "#00000000"

                LeafExplosion {
                    width: workspace_button.width
                    height: workspace_button.width
                    active: workspace_button.is_active
                    num_leaves: 50
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
                    command: ["hyprctl", "dispatch", `hl.dsp.focus({workspace=${workspace_button.workspace_id}})`]
                }

                TapHandler {
                    onTapped: change_workspace.running = true 
                }
            }

        }
    }
}
