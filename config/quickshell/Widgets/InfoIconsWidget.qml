import QtQuick
import qs.Services

Item {
    readonly property var margin: 10
    // color: "blue"
    Sound {
        id: sound
    }

    Network {
        id: network
        x: sound.width + margin
    }

    Battery {
        x: network.x + network.width + margin
    }


    SysTray {
    
    }

}
