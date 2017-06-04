import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property real valueLeft: 0.5
    property real valueRight: 0.5
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

    onValueLeftChanged: {
        if (NaN == valueLeft) valueLeft = 0
        pointer.requestPaint()
    }
    onValueRightChanged: {
        if (NaN == valueRight) valueRight = 0
        pointer.requestPaint()
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

            var ri = underlay.r1() * 1.05
            var ro = underlay.r2() * 0.9

            ctx.clearRect(0,0,width,height)
            // attention pointer
            drawPointer(ctx, 60, 60, 1, ri, ro, attentionPointerColor, valueRight)

            // relaxation pointer
            drawPointer(ctx, 300, 60, -1, ri, ro, relaxationPointerColor, valueLeft)
        }

        function drawPointer(ctx, startAngle, angularWidth, incDir, ri, ro, pointerColor, value) {
            var angle = startAngle + (incDir * value * angularWidth)
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

            ctx.fillStyle = pointerColor
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
