// CleanupPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Dialogs

Item {
    ColumnLayout {
        anchors.fill: parent

        //This column allows for the 'Layout.alignment' properties to work since the StackLayout class stretches the items to max so layout
        //is not taken into account
        ColumnLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.leftMargin: 20
            spacing: 0

            Label {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                text: "Cleanup Settings:"
                color: "#000000"
                font.bold: true
                font.underline: true
                font.pixelSize: 48
            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredWidth: 700
                Layout.preferredHeight: 250

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    ColumnLayout {
                        spacing: 10

                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 250
                            Layout.preferredHeight: 60
                            onClicked: Tools.FindNodes()

                            Text {
                                text: "Find Nodes"
                                font.pixelSize: 34
                                color: "#000000"
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 250
                            Layout.preferredHeight: 150
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
                                        font.pixelSize: 18
                                        width: parent.width
                                        padding: 10
                                        wrapMode: Text.Wrap
                                        text: Tools.NodeUpdate
                                        color: "#ffffff"
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        spacing: 10

                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 250
                            Layout.preferredHeight: 60
                            onClicked: Tools.DeleteCameras()

                            Text {
                                text: "Delete Cameras"
                                font.pixelSize: 34
                                color: "#000000"
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 250
                            Layout.preferredHeight: 150
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
                                        font.pixelSize: 18
                                        width: parent.width
                                        padding: 10
                                        wrapMode: Text.Wrap
                                        text: Tools.CameraUpdate
                                        color: "#ffffff"
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        spacing: 10

                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 250
                            Layout.preferredHeight: 60
                            onClicked: Tools.DeleteULMarkers()

                            Text {
                                text: "Delete Markers"
                                font.pixelSize: 34
                                color: "#000000"
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 250
                            Layout.preferredHeight: 150
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
                                        font.pixelSize: 18
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

            Rectangle {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredWidth: 700
                Layout.preferredHeight: 250

                ColumnLayout {
                    anchors.fill: parent

                    Text {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        text: "Cleanup Info:"
                        font.pixelSize: 34
                        color: "#000000"
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Rectangle {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.preferredWidth: 350
                            Layout.preferredHeight: 120
                            color: '#9c9c9c'
                            border.color: "#000000"
                            border.width: 5
                            radius: 10

                            Text {
                                padding: 12
                                color: "#000000"
                                font.pixelSize: 24
                                text: "Original:\n- Cameras: " + Tools.FileCameraCount + "\n- Un-labelled Markers: " + Tools.FileULMarkerCount
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.preferredWidth: 350
                            Layout.preferredHeight: 120
                            color: '#9c9c9c'
                            border.color: "#000000"
                            border.width: 5
                            radius: 10

                            Text {
                                padding: 12
                                color: "#000000"
                                font.pixelSize: 24
                                text: "Modified:\n- Cameras: " + Tools.FileNewCamCount + "\n- Un-labelled Markers: " + Tools.FileNewULMarkCount
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.topMargin: -10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredWidth: 700
                Layout.preferredHeight: 250

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 5

                    Text {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        text: "Meta Data:"
                        font.pixelSize: 34
                        color: "#000000"
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 700
                        Layout.preferredHeight: 215
                        color: '#9c9c9c'
                        border.color: "#000000"
                        border.width: 5
                        radius: 10

                        Text {
                            padding: 12
                            color: "#000000"
                            font.pixelSize: 28
                            text: "• File Name: " + Tools.FbxFileName + "\n• Date Authored: " + Tools.FileDateAuthored + "\n• Last Accessed: " + Tools.FileLastAccessed + "\n• Last Modified: " + Tools.FileLastModified + "\n• File Size: " + Tools.FbxFileSize + "Mb"
                        }
                    }
                }
            }
        }
    }
}
