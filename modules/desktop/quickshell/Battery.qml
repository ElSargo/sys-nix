import QtQuick
import Quickshell
import Quickshell.Services.UPower

pragma Singleton
Singleton {
    property string percent: `${UPower.devices.values[0].percentage * 100}`
}
