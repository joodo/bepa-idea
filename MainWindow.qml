import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick 2.5
import BepaIdea 1.0

Window {
    id: mainWindow
    visible: true
    title: qsTr("BepaIdea")
    color: "Cornsilk"

    property list<NodeStyle> defaultStyleSchemes: [
        NodeStyle {
            name: qsTr("Default")
            backgroundColor: "lightblue"
            borderWidth: 3
            borderColor: "gray"
            radius: 3
            fontSize: 14
            underline: false
        },
        NodeStyle {
            name: qsTr("Title")
            backgroundColor: "transparent"
            borderWidth: 3
            borderColor: "gray"
            radius: 0
            fontSize: 18
            underline: true
        },
        NodeStyle {
            name: qsTr("Done")
            backgroundColor: "lightgreen"
            borderWidth: 3
            borderColor: "gray"
            radius: 3
            fontSize: 14
            underline: false
        },
        NodeStyle {
            name: qsTr("Problem")
            backgroundColor: "#FF7777"
            borderWidth: 3
            borderColor: "gray"
            radius: 3
            fontSize: 14
            underline: false
        }
    ]
    property url currentUrl
    onCurrentUrlChanged: {
        if (currentUrl.toString().length !== 0) {
            title = qsTr("BepaIdea") + " - " + Utils.url2Name(currentUrl);
        } else {
            title = qsTr("BepaIdea");
        }
    }

    signal alert(string text, string type)

    Idea {
        id: idea
        anchors.fill: parent

        onNodeCountChanged: {
            if (count===0 && ideaMenu.state!=="fileLoaded") {
                ideaMenu.visible = false;
            } else {
                ideaMenu.visible = true;
            }
        }
    }

    OpenMenu {
        id: openMenu
        anchors.right: mainWindow.contentItem.right;

        onOpenFile: fileSelector.openFile()
        onSelectFile: fileSelector.openFileSelected(fileUrl)
        onNewFile: {
            idea.save(Utils.url2Path(mainWindow.currentUrl));
            mainWindow.currentUrl = "";
            idea.load();
            ideaMenu.state = "";
            ideaMenu.visible = false;
        }
    }
    IdeaMenu {
        id: ideaMenu
        visible: false
        anchors.right: openMenu.left; anchors.rightMargin: 3
        onSaveFile: fileSelector.saveFile()
        onDiscardModification: {
            idea.load(Utils.url2Path(mainWindow.currentUrl));
            mainWindow.alert(qsTr("Discard Modifications"), "information");
        }
        onRename: {
            var newUrl = Utils.changeUrlFileName(mainWindow.currentUrl, newName);
            openMenu.changeRecentFileUrls(mainWindow.currentUrl, newUrl);
            mainWindow.currentUrl = newUrl;
        }
    }

    FileSelector {
        id: fileSelector
        onOpenFileSelected: {
            idea.save(Utils.url2Path(mainWindow.currentUrl));
            try {
                idea.load(Utils.url2Path(fileUrl));
                fileLoaded(fileUrl);
            } catch(err) {
                openMenu.removeRecentFileUrls(fileUrl);
                mainWindow.alert(qsTr("Fail to open idea. Maybe idea \"%1\" is already moved, deleted or broken.").arg(text), "error");
            }
        }
        onSaveFileSelected: {
            idea.save(Utils.url2Path(fileUrl));
            fileLoaded(fileUrl);
        }
    }

    Toast {
        id: toast
        anchors.horizontalCenter: mainWindow.contentItem.horizontalCenter; anchors.bottom: mainWindow.contentItem.bottom; anchors.bottomMargin: 50
    }

    Item {
        Component.onCompleted: {
            // 读取窗口状态
            var rect = Utils.settingValue("window/rect", Qt.rect(300, 300, 1024, 768));
            mainWindow.x = rect.x; mainWindow.y = rect.y; mainWindow.width = rect.width; mainWindow.height = rect.height;
            if (Utils.settingValue("window/maximized").toString() === "true") {
                visibility = Window.Maximized;
            }

            // 读取临时文件
            if (Utils.settingValue("recent/hasTempFile").toString() === "true") {
                idea.load("tmp.bpi");
            } else {
                idea.load();
            }
        }
    }

    onAlert: {
        toast.alert(text, type);
    }

    onClosing: {
        // 保存窗口状态
        if (visibility === Window.Windowed) {
            Utils.setSettingValue("window/rect", Qt.rect(x, y, width, height));
            Utils.setSettingValue("window/maximized", false);
        } else {
            Utils.setSettingValue("window/maximized", true);
        }

        // 保存最近文件
        Utils.setSettingValue("recent/files", openMenu.recentFileUrls);

        // 保存文件
        if (mainWindow.currentUrl.toString().length > 0) {
            idea.save(Utils.url2Path(mainWindow.currentUrl));
            Utils.setSettingValue("recent/hasTempFile", false);
        } else {
            idea.save("tmp.bpi")
            Utils.setSettingValue("recent/hasTempFile", true);
        }
    }

    function fileLoaded(fileUrl) {
        mainWindow.currentUrl = fileUrl;
        openMenu.addRecentFileUrls(fileUrl);
        ideaMenu.state = ""; ideaMenu.state = "fileLoaded";  // 触发 stateChanged 信号，使 text 改变
    }
}
