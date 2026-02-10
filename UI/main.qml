import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Dialogs

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
                anchors.centerIn: parent

                width: 400
                height: 300
                spacing: 20

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
                    spacing: 20
                    width: 400
                    height: 300

                    Rectangle {
                        width: 200
                        height: 100
                        color: "#000000"
                        border.color: '#4d4d4d'
                        border.width: 3
                        radius: 10
 
                        ScrollView {
                            anchors.fill: parent

                            //Disables scroll bar visual
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                            Column {
                                width: parent.width

                                Text {
                                    width: parent.width
                                    padding: 10
                                    wrapMode: Text.Wrap
                                    text: Tools.NodeUpdate
                                    color: "#ffffff"
                                }
                            }       
                        }
                    }
            
                    Rectangle {
                        width: 200
                        height: 100
                        color: "#000000"
                        border.color: '#4d4d4d'
                        border.width: 3
                        radius: 10

                        ScrollView {
                            anchors.fill: parent

                            //Disables scroll bar visual
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                            Column {
                                width: parent.width

                                Text {
                                    width: parent.width
                                    padding: 10
                                    wrapMode: Text.Wrap
                                    text: Tools.CameraUpdate
                                    color: "#ffffff"
                                }
                            }       
                        }
                    }

                    Rectangle {
                        width: 200
                        height: 100
                        color: "#000000"
                        border.color: '#4d4d4d'
                        border.width: 3
                        radius: 10

                        ScrollView {
                            anchors.fill: parent

                            //Disables scroll bar visual
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                            Column {
                                width: parent.width

                                Text {
                                    width: parent.width
                                    padding: 10
                                    wrapMode: Text.Wrap
                                    text: Tools.MarkerUpdate
                                    color: "#ffffff"
                                }
                            }       
                        }
                    }
                }
            }  
        }
        Item {
            id: editTab

            Row {
                anchors.centerIn: parent

                width: 400
                height: 200
                spacing: 20

                Column {
                    width: 200
                    height: 200
                    spacing: 20

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
                        text: "Rename Skeleton"
                        color: "#000000"
                        font: "24"
                        }
                    }
                }

                Column {
                    width: 200
                    height: 200
                    spacing: 20

                    Rectangle {
                        width: 200
                        height: 100
                        color: "#000000"
                        border.color: '#4d4d4d'
                        border.width: 3
                        radius: 10

                        ScrollView {
                            anchors.fill: parent

                            //Disables scroll bar visual
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                            Column {
                                width: parent.width

                                Text {
                                    width: parent.width
                                    padding: 10
                                    wrapMode: Text.Wrap
                                    text: Tools.RootBoneUpdate
                                    color: "#ffffff"
                                }
                            }       
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
                        text: "Rename Skeleton"
                        color: "#000000"
                        font: "24"
                        }
                    }
                }
            }
            
        }
    }
}