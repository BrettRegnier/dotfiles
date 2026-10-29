import QtQuick
import qs.Services

Rectangle {
    color: "red"
    Text { 
        anchors.centerIn: parent
        text: Time.time
        color: "#CDD6F4"
    }
}
