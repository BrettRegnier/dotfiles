import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root 

    property string time

    Variants {
        model: Quickshell.screens;

        delegate: Component {
            PanelWindow {

                required property var modelData 
                screen: modelData

                anchors {
                    top: true
                    left: true 
                    right: true 
                }

                implicitHeight: 30

                Text {
                    anchors.centerIn: parent
                    text: root.time
                }
            }
        }
    }
    Process {
        id: date_process

        command: ["date"]
        running: true 

        stdout: StdioCollector {
            onStreamFinished: root.time = this.text 
        }
    }

    Timer {
        interval: 1000
        running: true 
        repeat: true 
        onTriggered: date_process.running = true
    }
}

