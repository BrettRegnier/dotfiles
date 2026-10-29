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
                screen: modelData

                anchors {
                    top: true
                    left: true 
                    right: true 
                }

                implicitHeight: 30
                height: 30
                implicitWidth: 100

                Workspaces {
                    num_workspaces: 5
                    monitor_num: root.monitor_id
                    width: parent.width * (3/8)
                    height: parent.height
                }

                ClockWidget {
                    x: parent.width * (3/8)
                    width: parent.width * (2/8)
                    height: parent.height
                }

                InfoIconsWidget {
                    x: parent.width * (5/8)
                    width: parent.width * (3/8)
                    height: parent.height
                }
            }
        }
    }
}

