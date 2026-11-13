import QtQuick
import qs.Services

Rectangle {
    color: "#00000000"

    readonly property var margin: 10
    SysTray {
        id: sys_tray
        anchors.right: parent.right
    }

    Network {
        id: network
        anchors.right: sys_tray.left 
        anchors.rightMargin: margin
    }

    Battery {
        id: battery
        anchors.right: network.left 
        anchors.rightMargin: margin
    }

    Sound {
        id: sound
        anchors.right: battery.left 
        anchors.rightMargin: margin
    }
}
