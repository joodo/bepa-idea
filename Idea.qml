import QtQuick 2.6

Item {
    id: idea

    property var styleSchemes: mainWindow.defaultStyleSchemes
    property Item canvas

    signal nodeCountChanged(int count)

    Item {
        id: canvasContainer
        anchors.left: parent.horizontalCenter; anchors.top: parent.verticalCenter
        z: 100
    }

    Text {
        id: emptyHint
        anchors.centerIn: parent
        text: qsTr("Double Click To Create Node")
        color: "gray"
    }

    StyleSelector {
        id: styleSelector
        visible: false
        z: 200
    }

    ScaleIndicator {
        id: scaleIndicator
        anchors.bottom: parent.bottom; anchors.right: parent.right
        z: 300
    }

    CanvasMoveMouseArea {
        anchors.fill: parent
        onCanvasMoved: scaleIndicator.show()
    }

    CanvasSelectMouseArea {
        anchors.fill: parent
    }

    CanvasMultiSelectMouseArea {
        anchors.fill: parent
    }

    onNodeCountChanged: {
        emptyHint.visible = count===0;
    }

    function onSelectedNodesCountChanged(count) {
        if (count !== 0) {
            styleSelector.visible = true;
            var si = canvas.selectedNodes[0].styleIndex;
            for (var i in canvas.selectedNodes) {
                if (canvas.selectedNodes[i].styleIndex !== si) {
                    si = -1;
                    break;
                }
            }
            styleSelector.selectedStyleIndex = si;

            var rightmostNode = canvas.selectedNodes[0];
            var topmostNode = canvas.selectedNodes[0];
            for (var i in canvas.selectedNodes) {
                var currentNode = canvas.selectedNodes[i];
                if (currentNode.x + currentNode.width >
                        rightmostNode.x+rightmostNode.width) {
                    rightmostNode = currentNode;
                }
                if (currentNode.y < topmostNode.y) {
                    topmostNode = currentNode;
                }
            }
            var rightmostRect = idea.mapFromItem(rightmostNode.parent, rightmostNode.x, rightmostNode.y,
                                                 rightmostNode.width, rightmostNode.height);
            styleSelector.x = rightmostRect.x + rightmostRect.width + 25;
            if (styleSelector.x > idea.width - styleSelector.width) {
                styleSelector.x = idea.width - styleSelector.width;
            }
            var topmostY = idea.mapFromItem(topmostNode.parent, 0, topmostNode.y).y;
            styleSelector.y = topmostY - styleSelector.selectedStyleY();
            if (styleSelector.y > idea.height - styleSelector.height) {
                styleSelector.y = idea.height - styleSelector.height;
            }
            if (styleSelector.y < 50) {
                styleSelector.y = 50;
            }
        } else {
            styleSelector.visible = false;
        }
    }

    function save(filePath) {
        Utils.saveJsonToFile(canvas.exportData(), filePath);
    }

    function load(filePath) {
        if (canvas !== null) {
            canvas.destroy();
        }

        var component = Qt.createComponent("MindMapCanvas.qml");
        canvas = component.createObject(canvasContainer);
        canvas.selectedNodesCountChanged.connect(onSelectedNodesCountChanged);
        canvas.nodeCountChanged.connect(nodeCountChanged);

        if (filePath) {
            canvas.loadData(Utils.loadJsonFromFile(filePath));
        }
        nodeCountChanged(canvas.nodes.length);
    }

    Keys.onDeletePressed: {
        canvas.deleteSelectedNodes();
        event.accepted = true;
    }
    Keys.onPressed: {
        if (event.modifiers & Qt.ControlModifier) {
            if (event.key === Qt.Key_A) {
                canvas.selectAll();
                mainWindow.alert(qsTr("Select All"), "information");
            }
            event.accepted = true;
        } else {
            event.accepted = false;
        }
    }
}
