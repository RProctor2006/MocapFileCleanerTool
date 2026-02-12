// EditPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
                    Tools.EnsureRootBone();
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
                    Tools.RenameSkeleton();
                }

                Text {
                    anchors.centerIn: parent
                    text: "Rename Skeleton to UE Skeleton"
                    wrapMode: Text.Wrap
                    color: "#000000"
                    font: "24"
                }
            }

            Text {
                width: 400
                wrapMode: Text.Wrap
                color: '#ff0000'
                text: "Warning! This operation works for most of the skeleton but not all of it. Some bones will be misnamed. Manual checking is advised.\nAdding a root bone first is recommended."
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
                            text: Tools.SkeletonUpdate
                            color: "#ffffff"
                        }
                    }
                }
            }
        }
    }
}
