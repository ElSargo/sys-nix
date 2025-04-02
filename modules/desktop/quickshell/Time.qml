pragma Singleton

import Quickshell
import QtQuick

Singleton {
  property var date: new Date();
  property string hour: `${date.getHours()}`
  property string minute: `${date.getMinutes()}`

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: date = new Date()
  }
}
