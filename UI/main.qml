import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 600
    height: 500
    title: "Mocap File Cleaner"
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

    //The layouts for the different tabs
    StackLayout {
        width: parent.width
        currentIndex: bar.currentIndex
        anchors.centerIn: parent

        //Import tab 
        Button {
            id: importTab
            width: 200
            height: 100
            onClicked: {
                ImportTab.ImportFile("CLICKED!")
            }

            Text {
                anchors.centerIn: parent
                text: "Import File"
                color: "#000000"
                font: "24"
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