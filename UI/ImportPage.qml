// ImportPage.qml
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
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            spacing: 15

            Label {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                text: "Select File:"
                color: "#000000"
                font.bold: true
                font.pixelSize: 48
            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredWidth: 700
                Layout.preferredHeight: 250

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Button {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 180
                        Layout.preferredHeight: 60
                        onClicked: Tools.ImportFile()

                        Text {
                            text: "Find File"
                            font.pixelSize: 34
                            color: "#000000"
                            anchors.centerIn: parent
                        }
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 325
                        Layout.preferredHeight: 125
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
                                    text: Tools.ImportUpdate
                                    color: "#ffffff"
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
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

            Rectangle {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredWidth: 700
                Layout.preferredHeight: 250

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Button {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.preferredWidth: 180
                        Layout.preferredHeight: 60
                        onClicked: Tools.ExportScene()

                        Text {
                            text: "Export File"
                            font.pixelSize: 34
                            color: "#000000"
                            anchors.centerIn: parent
                        }
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 325
                        Layout.preferredHeight: 100
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
                                    text: Tools.ExportUpdate
                                    color: "#ffffff"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
