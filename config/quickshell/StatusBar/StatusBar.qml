import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import qs.Widgets
import qs.Services
import Quickshell.Hyprland

Scope {
    Variants {
        model: Quickshell.screens;

        delegate: Component {
            PanelWindow {
                id: root
                color: "#EB12121C"
                //color: "#00000000"  
                required property var modelData 
                property var monitor: Hyprland.monitorFor(modelData)
                property int monitor_id: monitor ? monitor.id : 0
                readonly property var step_size: 1/13
                screen: modelData

                anchors {
                    top: true
                    left: true 
                    right: true 
                }

                implicitHeight: 30
                implicitWidth: 100

                Workspaces {
                    id: workspaces
                    num_workspaces: 5
                    monitor_num: root.monitor_id
                    width: parent.width * 5 * root.step_size
                    height: parent.height
                }

                ClockWidget {
                    id: clock_widget
                    x: workspaces.width
                    width: parent.width * 3 * root.step_size
                    height: parent.height
                }

                InfoIconsWidget {
                    x: workspaces.width + clock_widget.width
                    width: parent.width * 5 * root.step_size
                    height: parent.height
                }
            }
        }
    }
}

