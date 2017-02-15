import QtQuick 2.7


Item {
    id: canvas
    property alias dragContainer: dragContainer
    property alias nodesContainer: nodesContainer

    property alias nodes: nodesContainer.children
    property var selectedNodes: []

    signal nodeCountChanged(int count)
    signal selectedNodesCountChanged(int count)

    Component.onCompleted: {
        Engine.setNodesContainer(nodesContainer);
    }

    Item {
        id: nodesContainer
        anchors.fill: parent
        onChildrenChanged: canvas.nodeCountChanged(children.length)
    }
    Item {
        id: dragContainer
        z: 100
    }

    function nodeAt(pos) {
        return nodesContainer.childAt(pos.x, pos.y);
    }

    function createNode(text, x, y, styleIndex) {
        var component = Qt.createComponent("Node.qml");
        var node = component.createObject(nodesContainer, {
                                              "text": text,
                                              "x": x,
                                              "y": y,
                                              "styleIndex": styleIndex});
        node.adaptSize(); //TODO: don't need...
        return node;
    }

    function exportData() {
        var data = {};
        data["version"] = App.applicationVersion;
        data["canvas"] = {
            "x": x,
            "y": y,
            "scale": scale
        }
        data["nodes"] = [];
        for (var i in nodesContainer.children) {
            var node = nodesContainer.children[i];
            var nodeData = {
                "x": node.x,
                "y": node.y,
                "text": node.text,
                "styleIndex": node.styleIndex
            }
            data["nodes"].push(nodeData);
        }

        return data;
    }

    function loadData(data) {
        if (data["version"] !== App.applicationVersion) {
            throw "version not compatible"
        }

        x = data["canvas"]["x"]; y = data["canvas"]["y"]; scale = data["canvas"]["scale"];
        for (var i in data["nodes"]) {
            var nd = data["nodes"][i];
            createNode(nd["text"], nd["x"], nd["y"], nd["styleIndex"]);
        }
        selectedNodesCountChanged(selectedNodes.length);
        canvas.nodeCountChanged(nodes.length);
    }

    function clearSelection() {
        for (var i in selectedNodes) {
            selectedNodes[i].selected = false;
        }
        selectedNodes.length = 0;
        selectedNodesCountChanged(0);
    }

    function changeSelection(node) {
        if (node === null) return;

        if (node.selected) {
            node.selected = false;
            var i = selectedNodes.indexOf(node);
            selectedNodes.splice(i, 1);
        } else {
            node.selected = true;
            selectedNodes.push(node);
        }
        selectedNodesCountChanged(selectedNodes.length);
    }

    function newSelection(node) {
        clearSelection();
        if (node === null) return;
        changeSelection(node);
    }

    function selectAll() {
        for (var i in nodes) {
            var node = nodes[i];
            if (!node.selected) {
                node.selected = true;
                selectedNodes.push(node);
            }
        }
        selectedNodesCountChanged(selectedNodes.length);
    }

    function deleteSelectedNodes() {
        for (var i in selectedNodes) {
            selectedNodes[i].destroy();
        }
        clearSelection();
    }
}
