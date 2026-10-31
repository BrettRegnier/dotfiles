import QtQuick
import Quickshell.Networking

Rectangle {
    id: root
    implicitHeight: parent.height
    width: inside_text.width + 20
    radius: 5
    color: "#0dffffff"

    // Wired wins, then wifi, else null
    readonly property var activeDevice: {
        const devs = Networking.devices.values;
        const wired = devs.find(d => d.type === DeviceType.Wired && d.connected);
        if (wired) return wired;
        return devs.find(d => d.type === DeviceType.Wifi && d.connected) ?? null;
    }

    // For wifi, find the network you're actually on
    readonly property var activeWifi: {
        if (!activeDevice || activeDevice.type !== DeviceType.Wifi) return null;
        return activeDevice.networks.values.find(n => n.connected) ?? null;
    }

    readonly property string label: {
        if (!activeDevice) return "\uf127  Disconnected";
        if (activeDevice.type === DeviceType.Wired) return "\uEB50 " + activeDevice.name;
        return activeWifi ? "\uf1eb  " + activeWifi.name  : "Wi-Fi";
    }

    Text { 
        id: inside_text
        text: root.label 
        color: "#89b4fa"
        font: "JetBrainsMono Nerd Font" 
        anchors.centerIn: parent
    }
}
