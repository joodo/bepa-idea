import QtQuick 2.0

MouseArea {
    drag.threshold: 2;
    drag.target: Item{}
    propagateComposedEvents: true

    property Item multiSelectionRect
    property var dragStartPoint

    onPressed: {
        var pos = idea.canvas.mapFromItem(this, mouse.x, mouse.y);
        var target = idea.canvas.nodeAt(pos);
        if (target === null) {
            idea.canvas.clearSelection();
            mouse.accepted = true;
        } else {
            mouse.accepted = false;  // 如果点到了 node，就把事件漏给下面
        }
    }

    drag.onActiveChanged: {
        if (drag.active) {
            var unselectedNodes = [];
            for (var i in idea.canvas.nodes) {
                var node = idea.canvas.nodes[i];
                if (!node.selected) {
                    unselectedNodes.push(node);
                }
            }

            dragStartPoint = Qt.point(mouseX, mouseY);

            var component = Qt.createComponent("MultiSelectionRect.qml");
            multiSelectionRect = component.createObject(this,
                                                        {"unselectedNodes": unselectedNodes});
        } else {
            multiSelectionRect.destroy();
        }
    }

    onPositionChanged: {
        if (!drag.active) return;

        var blueRect = Qt.rect(Math.min(dragStartPoint.x, mouse.x),
                               Math.min(dragStartPoint.y, mouse.y),
                               0,
                               0);
        blueRect.width = Math.max(dragStartPoint.x, mouse.x) - blueRect.x;
        blueRect.height = Math.max(dragStartPoint.y, mouse.y) - blueRect.y;

        var affectedNodes = multiSelectionRect.onRectChanged(blueRect);
        for (var i in affectedNodes) {
            idea.canvas.changeSelection(affectedNodes[i]);
        }
    }
}
