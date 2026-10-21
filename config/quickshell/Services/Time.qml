pragma Singleton 

import Quickshell
import Quickshell.Io 
import QtQuick 

Singleton {
    id: root 
    readonly property string time: {
        Qt.formatDateTime(clock.date, "'Day of our Lord', dddd - yyyy/mm/dd hh:mm ap")
    } 

    SystemClock {
        id: clock 
        precision: SystemClock.Seconds
    }


    /*
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
    */
}
