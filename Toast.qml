import QtQuick 2.0

FadeoutRect {
    id: toast
    visible: false
    radius: 3
    height: 30; width: hint.contentWidth+30;

    readonly property var backgroundColors: {
        "information": "#E6B0C4DE",
                "error": "#E6FFAAAA"
    }

    Text {
        id: hint
        x: 15
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 12
    }

    function alert(text, type) {
        hint.text = text;
        toast.color = toast.backgroundColors[type];
        toast.duration = 30*text.length+500;
        toast.show();
    }
}
