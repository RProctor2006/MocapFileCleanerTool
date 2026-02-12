// ImportPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


//Import tab 
        Item {
            id: importTab
            
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
                            Tools.ImportFile()
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Import .fbx File"
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
                                    text: Tools.ImportUpdate
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
                                    text: Tools.ExportUpdate
                                    color: "#ffffff"
                                }
                            }       
                        }
                    }
                }
            }
        }