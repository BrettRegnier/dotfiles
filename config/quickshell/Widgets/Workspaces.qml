import Quickshell
import QtQuick
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
                width: 45
                height: 30 
                radius: 5

                property bool hovered: false
                color: hovered ? "steelblue" : "red"

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Text {
                    text: index
                    anchors.centerIn: parent
                    font.pixelSize: 14
                    font.family: Font.family
                    font.bold: true
                    color: "#FF000000"
                }

                HoverHandler { 
                    cursorShape: Qt.PointingHandCursor
                    onHoveredChanged: workspace_button.hovered = hovered
                }

                TapHandler {
                    onTapped:     Quickshell.exec(["hyprctl", "dispatch", "workspace", "1"])            
                }
            }

        }
    }
}
