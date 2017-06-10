import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property color borderColor: 'white'
    property real vShrinkRatio: 0.4
    property real vOffsetRatio: -0.4
    property real vFillRatio: 0.8
    property real hContentRatio: 0.8
    property real l1Radius: 75
    property real l2Radius: 75
    property color fillColor: Qt.rgba(1,1,1,0.05)
    property real shineWidthLeft: 0.08
    property real shineWidthRight: 0.06
    property real shineBrightness: 0.15
    property real borderShineBrightness: 0.8

    onWidthChanged: { repaint() }
    onHeightChanged: { repaint() }

    function repaint()
    {
        panelBorder.requestPaint()
        fillGradient.update()
        panelBorderGradient.update()
        fillMask.requestPaint()
    }

    Canvas {
        id: panelBorder
        anchors.fill: parent
        visible: false

        onPaint: {
            var ctx = getContext('2d')

            ctx.clearRect(0, 0, width, height)
            ctx.lineWidth = 2
            ctx.strokeStyle = borderColor
            drawPanel(ctx, false)
        }
    }

    LinearGradient {
        id: panelBorderGradient
        anchors.fill: parent
        start: Qt.point(width, 0)
        end: Qt.point(0, 0)
        visible: false

        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(1,1,1,0.0) }
            GradientStop { position: stop1(); color: Qt.rgba(1,1,1,borderShineBrightness) }
            GradientStop { position: 1; color: Qt.rgba(1,1,1,0.0) }
        }
    }

    LinearGradient {
        id: fillGradient
        anchors.fill: parent
        start: Qt.point(width, 0)
        end: Qt.point(0, 0)
        visible: false

        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(fillColor.r,fillColor.g,fillColor.b,0) }
            GradientStop { position: 0.4; color: fillColor }
            GradientStop { position: 0.9; color: fillColor }
            GradientStop { position: 1; color: Qt.rgba(fillColor.r,fillColor.g,fillColor.b,0) }
        }
    }

    Canvas {
        id: fillMask
        anchors.fill: parent
        visible: false

        onPaint: {
            var ctx = getContext('2d')
            ctx.fillStyle = Qt.rgba(1,1,1,1)
            drawPanel(ctx, true)
        }
    }

    LinearGradient {
        id: fillShineGradient
        anchors.fill: parent
        start: Qt.point(width, 0)
        end: Qt.point(0, 0)
        visible: false

        gradient: Gradient {
            GradientStop { position: stop0(); color: Qt.rgba(1,1,1,0) }
            GradientStop { position: stop1(); color: Qt.rgba(1,1,1,shineBrightness) }
            GradientStop { position: stop2(); color: Qt.rgba(1,1,1,0) }
        }
    }

    OpacityMask {
        id: fillShine
        anchors.fill: parent
        source: fillShineGradient
        maskSource: fillMask
    }

    OpacityMask {
        id: fill
        anchors.fill: parent
        source: fillGradient
        maskSource: fillMask
    }

    OpacityMask {
        id: panelBorderMasked
        anchors.fill: parent
        source: panelBorderGradient
        maskSource: panelBorder
    }

    function endPoint(pStart, pEnd, d)
    {
        var x1 = pStart.x
        var y1 = pStart.y
        var x2 = pEnd.x
        var y2 = pEnd.y

        var v = Qt.point(x2 - x1, y2 - y1)
        var vlen = Math.sqrt(v.x*v.x + v.y*v.y)
        var u = Qt.point(v.x/vlen, v.y/vlen)

        var len = vlen - d

        return Qt.point(pStart.x + u.x * len, pStart.y + u.y * len)
    }

    function drawPanel(ctx, fill)
    {
        var eh = height * vFillRatio        // expand height
        var sh = vShrinkRatio * eh          // shrink height
        var h = height

        var p1 = Qt.point(0, (h - eh + ((eh-sh) * (1 - vOffsetRatio)))/2)
        var px = Qt.point(0 + width * (1 - hContentRatio), h * (1 - vFillRatio)/2)
        var p4 = Qt.point(0 + width, (height - eh)/2)

        // calc p2, p3
        var p2 = endPoint(p1, px, l1Radius)
        var p3 = endPoint(p4, px, l2Radius)

        // bottom line
        var pd1 = Qt.point(p1.x, p1.y+sh)
        var pdx = Qt.point(px.x, h-px.y)
        var pd3 = Qt.point(p3.x, h-p3.y)
        var pd4 = Qt.point(p4.x, h-p4.y)

        var pd2 = endPoint(pd1, pdx, l1Radius)

        ctx.beginPath()
        ctx.moveTo(p1.x, p1.y)
        ctx.lineTo(p2.x, p2.y)
        ctx.bezierCurveTo(px.x, px.y, px.x, px.y, p3.x, p3.y)
        ctx.lineTo(p4.x, p4.y)

        if (fill) ctx.lineTo(pd4.x, pd4.y)
        else ctx.moveTo(pd4.x, pd4.y)

        ctx.lineTo(pd3.x, pd3.y)
        ctx.bezierCurveTo(pdx.x, pdx.y, pdx.x, pdx.y, pd2.x, pd2.y)
        ctx.lineTo(pd1.x, pd1.y)

        if (fill)
        {
            ctx.closePath()
            ctx.fill()
        }
        else
        {
            ctx.stroke()
        }
    }

    function stop1() { return hContentRatio * 1.005 }
    function stop0() { return stop1() - shineWidthRight }
    function stop2() { return stop1() + shineWidthLeft }
}
