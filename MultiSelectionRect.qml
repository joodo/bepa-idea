import QtQuick 2.0

Rectangle {
    property var unselectedNodes: []
    property var changedNodes: []
    color: "#BBB0C4DE"
    border.color: "steelblue"

    function onRectChanged(rect) {
        Utils.setItemRect(this, rect);

        var newChangedNodes = [], newUnselectedNodes = [], affectedNodes = [];
        rect = idea.canvas.mapFromItem(parent, rect.x, rect.y, rect.width, rect.height);
        // 检查已选的有没有漏出去
        for (var i in changedNodes) {
            var node = changedNodes[i];
            if (!Utils.rectContains(rect, Utils.itemRect(node))) {
                affectedNodes.push(node);
                newUnselectedNodes.push(node);
            } else {
                newChangedNodes.push(node);
            }
        }

        // 检查未选的有没有包进来
        for (var i in unselectedNodes) {
            var node = unselectedNodes[i];
            if (Utils.rectContains(rect, Utils.itemRect(node))) {
                affectedNodes.push(node);
                newChangedNodes.push(node);
            } else {
                newUnselectedNodes.push(node);
            }
        }

        changedNodes = newChangedNodes;
        unselectedNodes = newUnselectedNodes;
        return affectedNodes;
    }
}
