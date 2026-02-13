// EditPage.qml
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
            spacing: 0

            Label {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                text: "Edit Options:"
                color: "#000000"
                font.bold: true
                font.underline: true
                font.pixelSize: 48
            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredWidth: 700
                Layout.preferredHeight: 290

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    ColumnLayout {
                        spacing: 10

                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 275
                            Layout.preferredHeight: 60
                            onClicked: Tools.EnsureRootBone()

                            Text {
                                text: "Add Root Bone"
                                font.pixelSize: 34
                                color: "#000000"
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.preferredWidth: 350
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
                                        text: Tools.RootBoneUpdate
                                        color: "#ffffff"
                                    }
                                }
                            }
                        }

                        Text {
                            color: '#ffffff'
                            text: "Warning! This operation renames the skeleton to\nmatch the Unreal Engine default skeleton.\nIt has a ~85% accuracy, manual review is advised."
                            font.pixelSize: 16
                        }
                    }

                    ColumnLayout {
                        spacing: 10

                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 275
                            Layout.preferredHeight: 60
                            onClicked: Tools.RenameSkeleton()

                            Text {
                                text: "Rename Skeleton"
                                font.pixelSize: 34
                                color: "#000000"
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 350
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
                                        text: Tools.SkeletonUpdate
                                        color: "#ffffff"
                                    }
                                }
                            }
                        }

                        Text {
                            color: '#ff0000'
                            text: "Warning! This operation renames the skeleton to\nmatch the Unreal Engine default skeleton.\nIt has a ~85% accuracy, manual review is advised."
                            font.pixelSize: 16
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
                        text: "Skeleton Info:"
                        font.pixelSize: 34
                        color: "#000000"
                    }

                    ColumnLayout {
                        Text {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            text: "Original:"
                            font.pixelSize: 22
                            color: "#000000"
                        }

                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 700
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
                                        text: Tools.OriginalSkeleton
                                        color: "#ffffff"
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Text {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            text: "Modified:"
                            font.pixelSize: 22
                            color: "#000000"
                        }

                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.preferredWidth: 700
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
                                        text: Tools.ModifiedSkeleton
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
}
