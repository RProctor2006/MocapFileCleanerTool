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


        ImportPage{}
        CleanupPage{}
        EditPage{}
    }
}