import QtQuick 2.0
import BepaIdea 1.0

Rectangle {
    id: styleSelector
    color: "#E0FFFFFF"
    width: 80; height: styleListView.height+20
    radius: 3
    clip: true
    //border.color: "gray"; border.width: 3

    property int selectedStyleIndex: -1

    Column {
        id: styleListView
        anchors.centerIn: parent
        spacing: 5

        Repeater {
            id: repeater
            model: idea.styleSchemes.length
            delegate: ReadonlyNode {
                anchors.horizontalCenter: parent.horizontalCenter
                scale: 0.6

                styleIndex: model.index
                //text: qsTr("Style ") + (model.index+1)
                //text: "S"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        styleSelector.selectedStyleIndex = styleIndex;

                        for (var i in idea.canvas.selectedNodes) {
                            var node = idea.canvas.selectedNodes[i];
                            if (node.styleIndex !== selectedStyleIndex) {
                                node.styleIndex = selectedStyleIndex;
                                node.adaptSize();
                                Engine.itemsChanged([node]);
                            }
                        }
                    }
                }
                Rectangle {
                    color: "green"
                    width: radius; height: radius; anchors.verticalCenter: parent.verticalCenter; anchors.right: parent.left; anchors.rightMargin: 5;
                    radius: 15;
                    visible: styleSelector.selectedStyleIndex == styleIndex
                }
            }
        }
    }

    function selectedStyleY() {
        if (selectedStyleIndex < 0) {
            return 20;
        }
        var styleNode = repeater.itemAt(selectedStyleIndex);
        return styleSelector.mapFromItem(styleNode.parent, 0, styleNode.y).y;
    }
}
