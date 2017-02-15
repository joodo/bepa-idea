import QtQuick 2.0
import QtQuick.Dialogs 1.2

Item {
    id: fileSelector

    FileDialog {
        id: fileDialog
        title: qsTr("Please choose a file")
        folder: Utils.settingValue("recent/folder", shortcuts.home)
        nameFilters: ["BepaIdea file (*.bpi)"]
        selectFolder: false
        selectMultiple: false

        onAccepted: {
            // 更新目录
            Utils.setSettingValue("recent/folder", Utils.fileFolderUrl(fileDialog.fileUrl));

            // 判断是读是写
            if (selectExisting) {
                fileSelector.openFileSelected(fileDialog.fileUrl)
            } else {
                fileSelector.saveFileSelected(fileDialog.fileUrl)
            }

        }
    }

    function openFile() {
        fileDialog.selectExisting = true;
        fileDialog.open();
    }

    function saveFile() {
        fileDialog.selectExisting = false;
        fileDialog.open();
    }

    signal openFileSelected(url fileUrl)
    signal saveFileSelected(url fileUrl)
}
