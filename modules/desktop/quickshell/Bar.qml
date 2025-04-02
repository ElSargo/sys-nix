import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Layouts


Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      exclusionMode: ExclusionMode.Ignore
      property var modelData
      screen: modelData
      color: "#000E0E0D"
      focusable: true

      anchors {
        top: true
      }

      height: cl.implicitHeight
      width: cl.implicitWidth

      Clock {
        id: cl
        anchors.centerIn: parent
      }
    }
  }

  Variants {
    model: Quickshell.screens
      
    PanelWindow {
      id: b
      exclusionMode: ExclusionMode.Ignore
      property var modelData
      screen: modelData
      color: "#000E0E0D"
      focusable: true

      anchors {
        top: true
        right: true
      }

      height: clf.height - 1
      width: clf.width


      Bat {
        id: clf
        anchors.centerIn: parent
      }
    }
    }
  }
