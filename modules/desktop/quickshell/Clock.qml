import QtQuick
import QtQuick.Controls.Basic
import Quickshell.Io

Button {
    id: but
    implicitHeight: clock.implicitHeight 
    implicitWidth: clock.implicitWidth
    background:     Rectangle {
        bottomLeftRadius: 7
        bottomRightRadius: 7
        anchors.centerIn: parent
        color: "#1D1E1B"
        anchors.fill: clock
        border.width: 2
        border.color: but.down ? "#D85C60" : "#F78C5E"
        z:1
    }

    
    onClicked: a => {
        cal.running = true
    }
    
    Rectangle {
        bottomLeftRadius: 7
        bottomRightRadius: 7
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#1D1E1B"
        anchors.top: parent.top
        width: parent.width - 4
        height: 2
        z:2
    }

    Row {
        leftPadding: 5
        rightPadding: 5
        anchors.centerIn: parent
        id: clock
        spacing: 4
        z:2
        height: hour.implicitHeight

        function pad(s) {
            if (s.length == 1) {
                return "0" + s;
            } else {
                return s;
            }
        }

        Text {
            id: hour
            text: clock.pad(Time.hour)
            font.pixelSize: 17
            font.weight: Font.DemiBold
            font.family: "JetBrainsMono Nerd Font"
            color: "#B5C5C5"
        }
        
        Rectangle {
           anchors.verticalCenter: parent.verticalCenter 
           width: 5
           height: 5
           color: "#6f0E0E0D"
           radius: 180
        }

        Text {
            text: clock.pad(Time.minute)
            font.pixelSize: 17
            font.weight: Font.DemiBold
            font.family: "JetBrainsMono Nerd Font"
            color: "#B5C5C5"
        }
    }

    Process {
        id: cal
        command: ["gnome-calendar"]
        running: false
    }

}
