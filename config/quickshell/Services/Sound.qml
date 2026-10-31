//pragma Singleton 

import Quickshell
import QtQuick 
import Quickshell.Io
import Quickshell.Services.Pipewire

Rectangle {
    color: "#0dffffff"
    radius: 5
    height: parent.height
    width: 60

    PwObjectTracker { 
        objects: [ 
            Pipewire.defaultAudioSink 
        ] 
    }

    Text {
        id: inside_text
        anchors.centerIn: parent
        color: "#ffd700"
        font: "JetBrainsMono Nerd Font" 

        
        text: {
            const audio = Pipewire.defaultAudioSink?.audio

            if (!audio)
            {
                return "No device"
            }

            console.log(audio.volume)
            const vol = Math.round(audio.volume * 100)
            console.log(vol)
            var icon = "\uf026"


            console.log("here")
            if (vol == 0)
            {
            console.log("here1")
                icon = "\uf026"
            }
            else if (vol < 50)
            {
            console.log("here2")
                icon = "\uf027"
            }
            else 
            {
            console.log("here3")
                icon = "\uf028"
            }

            return `${icon}\u202F${vol}%`
        }
    }
}
