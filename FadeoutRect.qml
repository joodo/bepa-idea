import QtQuick 2.0

Rectangle {
    id: fadeoutRect
    visible: false

    property alias duration: hideTimer.interval
    property alias hideTimer: hideTimer
    default property alias children: mouseArea.data

    Timer {
        id: hideTimer
        onTriggered: {
            hideAnimation.start();
        }
    }

    PropertyAnimation {
        id: hideAnimation
        target: fadeoutRect
        property: "opacity"
        to: 0
        duration: 300
        onStopped: {
            if (fadeoutRect.opacity === 0) {
                fadeoutRect.visible = false;
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        z: 9999
        acceptedButtons: Qt.NoButton
        hoverEnabled: true

        onEntered: {
            hideTimer.stop();
        }
        onExited: {
            hideTimer.interval = 1000;
            hideTimer.restart();
        }
    }

    function show() {
        opacity = 1;
        visible = true;
        hideTimer.start();
    }
}
