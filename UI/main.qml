import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow {

    visible: true
    minimumWidth: 800
    maximumWidth: 800
    minimumHeight: 900
    maximumHeight: 900
    title: "Mocap File Cleaner by Riley Proctor"
    color: '#ffffff'

    ColumnLayout {
        anchors.fill: parent
        spacing: 25

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabButton {
                text: "Import"
            }
            TabButton {
                text: "Cleanup"
            }
            TabButton {
                text: "Edit"
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            ImportPage {}
            CleanupPage {}
            EditPage {}
        }
    }
}