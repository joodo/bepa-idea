import QtQuick 2.0

MouseArea {
    id: middleButtonArea
    drag.target: idea.canvas
    drag.axis: Drag.XAndYAxis
    acceptedButtons: Qt.MiddleButton

    signal canvasMoved()

    onWheel: {
        if (wheel.modifiers & Qt.ControlModifier) {
            var pos = idea.canvas.mapFromItem(this, wheel.x, wheel.y);

            var dy = wheel.angleDelta.y/1200;
            if (idea.canvas.scale<0.4 && dy<0 ||
                    idea.canvas.scale>2.4 && dy>0)
                return;
            idea.canvas.scale += dy;
            idea.canvas.x -= pos.x*dy; idea.canvas.y -= pos.y*dy;

            canvasMoved();
        } else {
            idea.canvas.x += wheel.angleDelta.x / 3;
            idea.canvas.y += wheel.angleDelta.y / 3;
        }
    }
}
