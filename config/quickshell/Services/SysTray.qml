import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Row {
    height: parent.height
    width: 100
    id: row
    anchors.centerIn: parent
    spacing: 8

    Repeater {
        model: SystemTray.items   // ObjectModel of SystemTrayItem

        delegate: MouseArea {
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
                } else if (mouse.button === Qt.LeftButton && !modelData.onlyMenu) {
                    modelData.activate();
                } else if (modelData.hasMenu) {
                    menuAnchor.open();
                }
            }

            IconImage {
                anchors.fill: parent
                source: trayItem.modelData.icon
            }
        }
    }
}
