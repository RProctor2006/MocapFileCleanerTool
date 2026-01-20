import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 600
    height: 500
    title: "Hello App"
    color: "#ffffff"

    TabBar {
        id: bar 
        width: parent.width

        TabButton {
            text: qsTr("Import")
        }
        TabButton  {
            text: qsTr("Clean-up")
        }
        TabButton {
            text: qsTr("Edit")
        }
    }

    StackLayout {
        width: parent.width
        currentIndex: bar.currentIndex
        anchors.centerIn: parent

        Rectangle {
            id: importTab
            width: 200
            height: 100
            color: '#ff0000'
        }
        Item {
            id: cleanupTab
        }
        Item {
            id: editTab
        }
    }
}