import QtQuick.Controls 2.1
import QtQuick 2.5

Button {
    id: openMenu
    //width: height
    text: qsTr("Open")
    onClicked: menu.open()

    property var recentFileUrls: Utils.settingValue("recent/files", [])

    signal openFile()
    signal newFile()
    signal selectFile(url fileUrl)

    /*Image {
        source: "qrc:/imgs/open.png"
        anchors.fill: parent; anchors.margins: 5
        fillMode: Image.PreserveAspectFit
    }*/

    Menu {
        id: menu
        y: parent.height

        MenuItem {
            text: qsTr("New Idea")
            onTriggered: openMenu.newFile()
        }
        MenuSeparator {}

        Column {
            width: parent.width
            height: recentFileUrls.length===0? 0:undefined
            clip: true
            MenuSeparator {
                width: parent.width
                contentItem: Text {
                    text: qsTr("Recent")
                    Button {
                        flat: true
                        height: parent.height; width: height;
                        anchors.right: parent.right;
                        text: "X"
                        onClicked: openMenu.recentFileUrls = []
                    }
                }
            }
            Repeater {
                model: openMenu.recentFileUrls
                delegate: MenuItem {
                    font.italic: true
                    text: Utils.url2Name(modelData)
                    onTriggered: openMenu.selectFile(modelData)
                }
            }
            MenuSeparator {
                width: parent.width
            }
        }

        MenuItem {
            text: qsTr("Other Idea...")
            onTriggered: openMenu.openFile()
        }
    }

    onSelectFile: menu.close()

    function addRecentFileUrls(url) {
        removeRecentFileUrls(url);
        openMenu.recentFileUrls.unshift(url);
        if (openMenu.recentFileUrls.length > 5) {
            openMenu.recentFileUrls.length = 5;
        }
        openMenu.recentFileUrlsChanged();
    }

    function removeRecentFileUrls(url) {
        var index = openMenu.recentFileUrls.indexOf(url);
        if (index >= 0) {
            openMenu.recentFileUrls.splice(index, 1);
        }
        openMenu.recentFileUrlsChanged();
    }

    function changeRecentFileUrls(oldUrl, newUrl) {
        var index = recentFileUrls.indexOf(oldUrl);
        if (index >= 0) {
            recentFileUrls.splice(index, 1, newUrl);
            openMenu.recentFileUrlsChanged();
        }
    }
}
