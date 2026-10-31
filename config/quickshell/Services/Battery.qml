import Quickshell
import Quickshell.Services.UPower
import QtQuick

Rectangle {
    id: root
    implicitHeight: parent.height
    width: inside_text.width + 20
    radius: 5
    color: "#0dffffff"

    Text {
        id: inside_text
        anchors.centerIn: parent
        color: "#a6e3a1"
        font: "JetBrainsMono Nerd Font" 

        text: {
            const bat = UPower.displayDevice
            if (!bat || !bat.isLaptopBattery)
                return "No battery"
            return Math.round(bat.percentage * 100) + "%"
                + (bat.state === UPowerDeviceState.Charging ? " (charging)" : "")
        }
    }
}
