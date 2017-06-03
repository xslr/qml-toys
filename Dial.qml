import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property color attentionPointerColor: Qt.rgba(1,0,0,1)
    property color relaxationPointerColor: Qt.rgba(0,1,0,1)
    property real attention: 0
    property real relaxation: 0
    property real pointerHalfWidthAngle: 3

    onHeightChanged: {
        if (width > height)
            width = height
        else
            height = width
    }

    onWidthChanged: {
        if (width > height)
            width = height
        else
            height = width
    }

    Underlay {
        id: underlay
        anchors.fill: parent
    }

    Canvas {
        id: pointer
        anchors.fill: parent

        onPaint: {
            var ctx = getContext('2d')

            // attention pointer
            ctx.fillStyle = attentionPointerColor
            drawPointer(ctx, 0, 100, 200)

            // relaxation pointer
            ctx.fillStyle = relaxationPointerColor
            drawPointer(ctx, 180, 100, 200)
        }

        function drawPointer(ctx, angle, ri, ro) {
            var cx = width / 2
            var cy = width / 2
            var a1 = deg2rad(angle)
            var a2 = deg2rad(angle + pointerHalfWidthAngle)
            var a3 = deg2rad(angle - pointerHalfWidthAngle)

            var x1 = cx + ro * Math.sin(a1)
            var x2 = cx + ri * Math.sin(a2)
            var x3 = cx + ri * Math.sin(a3)
            var y1 = cy + ro * Math.cos(a1)
            var y2 = cy + ri * Math.cos(a2)
            var y3 = cy + ri * Math.cos(a3)

            ctx.beginPath()

            ctx.moveTo(x1, y1)
            ctx.lineTo(x2, y2)
            ctx.lineTo(x3, y3)

            ctx.closePath()
            ctx.fill()

            // todo: draw reflection
            // todo: draw shadow
        }

        function deg2rad(deg) { return Math.PI * deg/180 }
    }
}
