import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import qs.Widgets
import qs.Services

Scope {
    Variants {
        model: Quickshell.screens;

        delegate: Component {
            PanelWindow {
                color: "#EB12121C"
                //color: "#00000000"  
                required property var modelData 
                screen: modelData

                anchors {
                    top: true
                    left: true 
                    right: true 
                }

                implicitHeight: 30

                Workspaces {
                    anchors.fill: parent
                }

                ClockWidget {
                    anchors.centerIn: parent
                }

            }
        }
    }
}

