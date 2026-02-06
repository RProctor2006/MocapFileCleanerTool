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
        Item {
            id: importTab

            Column {
                width: 200
                height: 200
                spacing: 20
                anchors.centerIn: parent

                Button {
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
            
                Button {
                    width: 200
                    height: 100
                    onClicked: {
                        Tools.ExportScene()
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Export File"
                        color: "#000000"
                        font: "24"
                    }
                }
            }
        }
        
        Item {
            id: cleanupTab

            Row {
                width: 400
                height: 300
                spacing: 20
                anchors.centerIn: parent

                Column {
                width: 200
                height: 300
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
                Column {
                width: 200
                height: 300
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
        }

        Item {
            id: editTab

            Column {
                width: 200
                height: 200
                spacing: 20
                anchors.centerIn: parent

                Button {
                    width: 200
                    height: 100
                    onClicked: {
                        Tools.EnsureRootBone()
                    }

                    Text {
                    anchors.centerIn: parent
                    text: "Add Root Bone"
                    color: "#000000"
                    font: "24"
                    }
                }
            
                Button {
                    width: 200
                    height: 100
                    onClicked: {
                        Tools.RenameSkeleton()
                    }

                    Text {
                    anchors.centerIn: parent
                    text: "Rename Skeleton to\nDefault UE Skeleton\nWarning! Accurate for %90\nof bones. Manual Inspection\nrecommended."
                    color: "#000000"
                    font: "24"
                    }
                }
            }
        }
    }
}