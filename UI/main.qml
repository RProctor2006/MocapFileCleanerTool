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
                Tools.ImportFile()
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

            Column {
                width: 200
                height: 100
                spacing: 20

                Button {
                    width: 200
                    height: 100
                    onClicked: {
                        Tools.FindNodes()
                    }

                    Text {
                    anchors.centerIn: parent
                    text: "Find Nodes"
                    color: "#000000"
                    font: "24"
                    }
                }
            
                Button {
                    width: 200
                    height: 100
                    onClicked: {
                        Tools.DeleteCameras()
                    }

                    Text {
                    anchors.centerIn: parent
                    text: "Delete Cameras."
                    color: "#000000"
                    font: "24"
                    }
                }

                Button {
                    width: 200
                    height: 100
                    onClicked: {
                        Tools.DeleteULMarkers()
                    }

                    Text {
                    anchors.centerIn: parent
                    text: "Delete Un-labelled Markers."
                    color: "#000000"
                    font: "24"
                    }
                }
            }
            
        }
        Item {
            id: editTab
        }
    }
}