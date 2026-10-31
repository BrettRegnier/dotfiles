import QtQuick
import Quickshell.Networking

Item {
    id: root
    height: parent.height

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
        text: root.label 
        color: "#CDD6F4"
        font: "JetBrainsMono Nerd Font" 
        anchors.centerIn: parent
    }
}
