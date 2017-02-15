import QtQuick 2.7

Rectangle {
    id: readonlyNode

    property int styleIndex: 0
    property alias text: displayItem.text
    readonly property string defaultText: qsTr("New Node")

    property alias displayItem: displayItem // for Node

    width: displayItem.contentWidth + 40
    height: displayItem.contentHeight + 20
    border.width: idea.styleSchemes[styleIndex].underline? 0:idea.styleSchemes[styleIndex].borderWidth
    border.color: idea.styleSchemes[styleIndex].borderColor
    color: idea.styleSchemes[styleIndex].backgroundColor

    Text {
        id:displayItem
        text: readonlyNode.defaultText
        anchors.fill: parent
        anchors.topMargin: 10; anchors.bottomMargin: 10; anchors.leftMargin: 20; anchors.rightMargin: 20
        verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
        font.pointSize: idea.styleSchemes[styleIndex].fontSize
        wrapMode: Text.Wrap
    }

    Rectangle {
        anchors.left: parent.left; anchors.right: parent.right; anchors.verticalCenter: parent.bottom
        height: idea.styleSchemes[styleIndex].borderWidth
        color: idea.styleSchemes[styleIndex].borderColor
        radius: 1000
        visible: idea.styleSchemes[styleIndex].underline
        z: 100
    }
}
