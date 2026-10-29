// pragma Singleton 
//
// import Quickshell
// import Quickshell.Io 
// import QtQuick 
//
// Singleton {
//     id: root 
//     readonly property string file: /proc/stat; 
//
//     FileView {
//
//     }
//
//     Timer {
//         interval: 1000
//         running: true 
//         repeat: true 
//         onTriggered: date_process.running = true
//     }
//
//     // Process {
//     //     id: date_process
//     //     command: ["date"]
//     //     running: true 
//     //
//     //     stdout: StdioCollector {
//     //         onStreamFinished: root.time = this.text 
//     //     }
//     // }
//
//     
// }
