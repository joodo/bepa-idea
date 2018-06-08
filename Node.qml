import QtQuick 2.7
import BepaIdea 1.0

ReadonlyNode {
    id: node

    width: Math.max(editItem.contentWidth+40, 200)
    height: editItem.contentHeight + 20
    text: defaultText
    radius: idea.styleSchemes[styleIndex].radius

    property bool selected: false

    Rectangle {
        id: selectedBorder
        visible: false
        anchors.fill: parent
        anchors.margins: -10
        radius: 3
        border.width: 6
        border.color: "steelblue"
        color: "transparent"
        z: -1
    }

    TextEdit {
        id: editItem
        visible: false
        anchors.centerIn: parent
        verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
        selectByMouse: true
        color: "darkgreen"
        text: parent.text
        font.pointSize: idea.styleSchemes[styleIndex].fontSize

        Rectangle {
            anchors.fill: parent
            anchors.margins: -10
            color: "#E6FFFFFF"
            z: -1
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.IBeamCursor
        }

        onVisibleChanged: {
            if (visible) {
                selectAll();
            }
        }
        onEditingFinished: {
            displayItem.text = text;
            adaptSize();
            node.state = node.selected? "selected":""
        }
        Keys.onReturnPressed: {
            if (event.modifiers === Qt.NoModifier) {
                node.state = "selected";
                event.accepted = true;
            } else {
                event.accepted = false;
            }
        }
    }

    TextInput {
        id: hiddenInput
        clip: true
        width: 0; height: 0
        x: 20; y: 0;

        onTextChanged: {
            if (text!=="") {
                node.state = "edit";
                editItem.text = text;
                editItem.focus = true;
                editItem.cursorPosition = text.length;
            }
        }
        onFocusChanged: {
            if (focus) {
                this.clear();
            }
        }
        Keys.forwardTo: [idea, this]
    }

    states: [
        State {
            name: "edit"
            PropertyChanges {
                target: displayItem
                visible: false
            }
            PropertyChanges {
                target: editItem
                visible: true
                focus: true
            }
            PropertyChanges {
                target: node
                z: 100
            }
        },
        State {
            name: "selected"
            PropertyChanges {
                target: selectedBorder
                visible: true
            }
            PropertyChanges {
                target: hiddenInput
                focus: true
            }
        }
    ]

    function adaptSize() {
        if (text === "") {
            //text = defaultText;
        }

        displayItem.wrapMode = Text.NoWrap;
        var singleLineWidth = displayItem.contentWidth;
        var fontSize = idea.styleSchemes[styleIndex].fontSize;
        var hMargin = 20;
        var maxWidth = fontSize * 20;
        var minWidth = fontSize * 3;
        displayItem.wrapMode = Text.Wrap;

        if (singleLineWidth > maxWidth) {
            node.width = maxWidth + hMargin*2;
            node.height = displayItem.contentHeight + 20
        } else if (singleLineWidth < minWidth) {
            node.width = minWidth + hMargin*2;
            node.height = displayItem.contentHeight + 20
        } else {
            node.width = singleLineWidth + hMargin*2;
            node.height = displayItem.contentHeight + 20
        }

        Engine.itemsChanged([node]);
    }

    onSelectedChanged: {
        if (!selected) {
            state = "";
        } else if (selected && state==="") {
            state = "selected";
        }
    }
}
