import QtQuick
import QtQuick.Controls
import QtQuick.Window
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

        Button {
            id: importTab
            width: 200
            height: 100
            onClicked: {
                ImportTab.ImportFile("CLICKED!")
            }
        }
        Item {
            id: cleanupTab
        }
        Item {
            id: editTab
        }
    }
}