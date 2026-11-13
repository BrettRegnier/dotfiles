import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Rectangle {
    width: row.implicitWidth + 20
    height: parent.height
    color: "#0dffffff"
    radius: 5

    Row {
        x: 10
        height: parent.height
        id: row
        spacing: 8

        Repeater {
            model: SystemTray.items   // ObjectModel of SystemTrayItem

            delegate: MouseArea {
                anchors.verticalCenter: parent.verticalCenter
                id: trayItem
                required property SystemTrayItem modelData

                implicitWidth: 20
                implicitHeight: 20
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                QsMenuAnchor {
                    id: menuAnchor
                    menu: trayItem.modelData.menu
                    anchor.window: trayItem.QsWindow.window
                    anchor.adjustment: PopupAdjustment.Flip
                    anchor.onAnchoring: {
                        const win = trayItem.QsWindow.window;
                        anchor.rect = win.contentItem.mapFromItem(trayItem, 0, trayItem.height, trayItem.width, 0);
                    }
                }

                onClicked: mouse => {
                    console.log("clicked", modelData.id, "onlyMenu:", modelData.onlyMenu, "hasMenu:", modelData.hasMenu);
                    if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate();
                    } else if (mouse.button === Qt.LeftButton && modelData.hasMenu) {
                        menuAnchor.open();
                    } else if (modelData.onlyMenu) {
                        modelData.activate();
                    }
                }

                IconImage {
                    anchors.fill: parent
                    source: trayItem.modelData.icon
                }
            }
        }
    }
}
