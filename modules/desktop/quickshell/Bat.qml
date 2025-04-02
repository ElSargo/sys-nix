import QtQuick
import QtQuick.Shapes
import Quickshell.Services.SystemTray


Item {
    width: 24
    height: 24

    Rectangle {
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.top
        width: 48
        height: 47
        color: "#1D1E1B"
        bottomLeftRadius: 7
        border.width: 2
        border.color: "#F78C5E"

    }

    Text {
        id: txt
        leftPadding: 2
        bottomPadding: 2
        anchors.centerIn: parent
        text: Battery.percent
        color: "#9BC1BB"
        font.pixelSize: 17
        font.weight: Font.DemiBold
        font.family: "JetBrainsMono Nerd Font"
    }

}
