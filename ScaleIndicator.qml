import QtQuick 2.0

FadeoutRect {
    id: scaleIndicator
    width: 140; height: 24;
    color: "#E6FFFFFF"
    duration: 5000

    Text {
        anchors.centerIn: parent
        text: mouseArea.containsMouse? qsTr("Reset Scale"):canvas.scale.toFixed(1) + " X"
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: canvas.scale = 1
    }
}
