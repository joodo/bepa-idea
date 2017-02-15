import QtQuick.Controls 2.1
import QtQuick 2.5

Button {
    id: ideaMenu
    text: qsTr("Save Idea As")
    onClicked: saveFile()

    signal saveFile()
    signal discardModification()
    signal rename(string newName)

    Rectangle {
        id: renameRect
        anchors.fill: parent
        color: "white"
        border.width: 3
        border.color: "steelblue"
        radius: 3
        visible: false

        TextInput {
            id: textInput
            anchors.fill: parent
            font.pointSize: ideaMenu.font.pointSize
            horizontalAlignment: TextInput.AlignHCenter; verticalAlignment: TextInput.AlignVCenter
            selectByMouse: true

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.IBeamCursor
            }

            onTextChanged: ideaMenu.text = text
            onEditingFinished: {
                renameRect.visible = false;

                var oldName = Utils.url2Name(mainWindow.currentUrl);
                if (oldName === text) {
                    return;
                }

                if (Utils.renameFile(mainWindow.currentUrl, text)) {
                    ideaMenu.rename(text);
                } else {
                    mainWindow.alert(qsTr("Fail to rename idea. Maybe idea \"%1\" is already exist.").arg(text), "error");
                    ideaMenu.text = oldName;
                }
            }
        }
    }

    Menu {
        id: menu
        y: parent.height

        MenuItem {
            text: qsTr("Rename")
            onTriggered: {
                renameRect.visible = true;
                textInput.text = ideaMenu.text;
                textInput.focus = true;
                textInput.selectAll();
            }
        }
        MenuItem {
            text: qsTr("Discard Modifications!")
            onTriggered: ideaMenu.discardModification()

            Rectangle {
                anchors.fill: parent; anchors.margins: 1
                z: -1
                color: "#FFAAAA"
            }
        }

    }

    states: [
        State {
            name: "fileLoaded"
            PropertyChanges {
                target: ideaMenu
                text: Utils.url2Name(mainWindow.currentUrl)
                onClicked: menu.open()
                visible: true
            }
        }
    ]
}
