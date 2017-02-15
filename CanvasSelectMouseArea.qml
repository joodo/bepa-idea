import QtQuick 2.0

MouseArea {
    drag.threshold: 2;
    drag.target: dragContainer

    property var draggingNodes: idea.canvas.selectedNodes
    property var draggingRects: []

    Item {
        id: dragContainer
        z: 100
    }

    onDoubleClicked: {
        if (mouse.modifiers === Qt.NoModifier) {
            var pos = idea.canvas.mapFromItem(this, mouse.x, mouse.y);
            var target = idea.canvas.nodeAt(pos);
            if (target === null) {  // 双击空位置，新建节点
                var node = idea.canvas.createNode();
                node.x = pos.x - node.width/2; node.y = pos.y - node.height/2;
                node.state = "edit";
                idea.canvas.newSelection(node);
            } else {
                idea.canvas.newSelection(target);
                target.state = "edit";
            }
        }
    }

    onPressed: {
        var pos = idea.canvas.mapFromItem(this, mouse.x, mouse.y);
        var target = idea.canvas.nodeAt(pos);
        if (mouse.modifiers & Qt.ControlModifier) {
            idea.canvas.changeSelection(target);
        } else if (!target.selected) {
            idea.canvas.newSelection(target);
        } else {
            target.selected = false; target.selected = true;  // 触发 selectedChanged 信号，使焦点重回 target
        }
    }

    drag.onActiveChanged: {
        if (drag.active) {
            dragContainer.scale = idea.canvas.scale;
            draggingRects = [];
            for (var i in draggingNodes) {
                var node = draggingNodes[i];
                var pos = dragContainer.mapFromItem(node.parent, node.x, node.y);
                var rn = Qt.createComponent("ReadonlyNode.qml");
                var dr = rn.createObject(dragContainer, {"x": pos.x, "y": pos.y,
                                             "width": node.width, "height": node.height, // TODO: don't need ...
                                             "styleIndex": node.styleIndex, "text": node.text,
                                             "opacity": 0.4});
                draggingRects.push(dr);
            }
        } else {
            for (var i in draggingNodes) {
                var node = draggingNodes[i];
                var dr = draggingRects[i];
                var pos = node.parent.mapFromItem(dragContainer, dr.x, dr.y);
                node.x = pos.x; node.y = pos.y;
                dr.destroy();
            }
            draggingRects.length = 0;
            Engine.itemsChanged(draggingNodes);
        }
    }
}
