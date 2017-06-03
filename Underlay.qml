import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property color baseColor: Qt.rgba(12/255, 26/255, 39/255, 1)

    property real r1Stop: 0.7
    property real r2Stop: 0.92
    property real r3Stop: 1

    property color r1Color: 'gray'
    property color r2Color: 'darkgray'
    property color r3Color: 'lightgray'

    property bool showMaskCircles: false
    property bool showMasks: false
    property bool showGloss: true
    property bool showShadow: false
    property bool showGlow: true

    property real gloss1Intensity: 0.3
    property real gloss3Intensity: 0.5

    property real c1ShadowIntensity: 0.3
    property real c1ShadowWidth: 0.5

    property color c2GlowColor: Qt.rgba(0.8,0.9,1,c2GlowIntensity)
    property real c2GlowIntensity: 0.3
    property real c2GlowWidth: 0.7

    property color markingMajorColor: Qt.rgba(0.8, 0.8, 0.8, 1)
    property color markingMinorColor: Qt.rgba(0.7, 0.7, 0.7, 1)
    property int markingMinorDivs: 5
    property int markingMajorDivs: 6
    property real markingMinorWidth: 2
    property real markingMajorWidth: 2
    property real markingMinorLength: 8
    property real markingMajorLength: 15
    property real markingAngularWidth: 60


    // invisible ------------------------------------------

    // circles
    Item {
        id: circR3
        anchors.fill: parent
        visible: showMaskCircles
        Rectangle {
            anchors.centerIn: parent
            color: r3Color
            radius: r3()
            width: r3()*2
            height: width
        }
    }

    Item {
        id: circR2
        anchors.fill: parent
        visible: showMaskCircles
        Rectangle {
            anchors.centerIn: parent
            color: r2Color
            radius: r2()
            width: r2()*2
            height: width
        }
    }

    Item {
        id: circR1
        anchors.fill: parent
        visible: showMaskCircles
        Rectangle {
            anchors.centerIn: parent
            color: r1Color
            radius: r1()
            width: r1()*2
            height: width
        }
    }

    // masks
    Item {
        id: gloss1Mask
        anchors.fill: parent
        visible: showMasks

        OpacityMask {
            id: maskR1R1
            anchors.fill: parent
            source: circR1
            maskSource: circR1
        }
    }

    Item {
        id: gloss3Mask
        anchors.fill: parent
        visible: showMasks

        OpacityMask {
            id: maskR3R2
            anchors.fill: parent
            source: circR3
            maskSource: circR2
            invert: true
        }
    }

    Item {
        id: pointerMask
        anchors.fill: parent
        visible: showMasks

        OpacityMask {
            id: maskR2R1
            anchors.fill: parent
            source: circR2
            maskSource: circR1
            invert: true
        }
    }


    // visible  -------------------------------------------

    // base circle
    Rectangle {
        id: baseCircle
        anchors.fill: parent
        radius: width/2
        color: baseColor
    }

    // gloss
    Item {
        id: gloss1
        anchors.fill: parent
        visible: showGloss

        Item {
            id: gloss1Gradient
            anchors.fill: parent
            visible: false

            onHeightChanged: { _gloss1Gradient.height = height*2 }

            onWidthChanged: { _gloss1Gradient.width = width*2 }

            RadialGradient {
                id: _gloss1Gradient
                anchors.centerIn: parent
                verticalRadius: height * 0.35
                verticalOffset: -height * 0.305

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                    GradientStop { position: 0.99; color: Qt.rgba(1, 1, 1, gloss1Intensity) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0) }
                }
            }
        }

        OpacityMask {
            anchors.fill: parent
            source: gloss1Gradient
            maskSource: gloss1Mask
        }
    }

    Item {
        id: gloss3
        anchors.fill: parent
        visible: showGloss

        Item {
            id: gloss3Gradient
            anchors.fill: parent
            visible: false

            onHeightChanged: { _gloss3Gradient.height = height*2 }

            onWidthChanged: { _gloss3Gradient.width = width*2 }

            RadialGradient {
                id: _gloss3Gradient
                anchors.centerIn: parent
                verticalRadius: height * 0.35
                verticalOffset: -height * 0.33

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                    GradientStop { position: 0.99; color: Qt.rgba(1, 1, 1, gloss3Intensity) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0) }
                }
            }
        }

        OpacityMask {
            anchors.fill: parent
            source: gloss3Gradient
            maskSource: gloss3Mask
        }
    }

    // shadow
    Item {
        id: dropShadowC1
        anchors.fill: parent
        visible: showShadow

        RadialGradient {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop { position: c1ShadowStop1InsideEdge(); color: Qt.rgba(0,0,0,0) }
                GradientStop { position: c1ShadowStop1(); color: Qt.rgba(0,0,0,c1ShadowIntensity) }
                GradientStop { position: c1ShadowStop2(); color: Qt.rgba(0,0,0,0) }
            }
        }
    }

    // glow
    Item {
        id: c2IG        // IG -> inner glow
        anchors.fill: parent
        visible: showGlow

        RadialGradient {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop { position: c2IGStop1(); color: Qt.rgba(c2GlowColor.r, c2GlowColor.g, c2GlowColor.b, 0) }
                GradientStop { position: c2IGStop2(); color: c2GlowColor }
                GradientStop { position: c2IGStop2OutEdge(); color: Qt.rgba(c2GlowColor.r, c2GlowColor.g, c2GlowColor.b, 0) }
            }
        }
    }

    // marking
    Item {
        id: markings
        anchors.fill: parent

        function requestPaint() { canvas.requestPaint() }

        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext('2d');

                // left
                drawMarkingSet(ctx, 270, markingMajorColor, markingMinorColor)

                // right
                drawMarkingSet(ctx, 90, markingMajorColor, markingMinorColor)
            }

            function drawMarkingSet(ctx, centerAngle, majorColor, minorColor)
            {
                var cx = width / 2
                var cy = height / 2
                var startAngle
                var numTicks
                var majorTickStep = markingAngularWidth / markingMajorDivs
                var minorTickStep = markingAngularWidth / (markingMajorDivs * markingMinorDivs)

                // minor markings
                ctx.beginPath()
                ctx.strokeStyle = minorColor
                startAngle = centerAngle - markingAngularWidth / 2
                for (var i = 0; i < markingMajorDivs; ++i)
                {
                    numTicks = markingMinorDivs + 1
                    drawTicks(ctx, markingMinorWidth, cx, cy, r2() - markingMinorLength, r2(),
                              numTicks, startAngle+(i*majorTickStep), minorTickStep)
                }
                ctx.stroke()

                // major markings
                ctx.beginPath()
                ctx.strokeStyle = majorColor
                numTicks = markingMajorDivs + 1
                drawTicks(ctx, markingMajorWidth, cx, cy, r2() - markingMajorLength, r2(), numTicks, startAngle, majorTickStep)
                ctx.stroke()
            }

            function drawTicks(ctx, sw, cx, cy, ri, ro, nticks, offset, step)
            {
                ctx.lineWidth = sw

                for (var i = 0; i < nticks; ++i)
                {
                    var angle = deg2rad(offset) + i * deg2rad(step)

                    var x1 = cx + (ri * Math.sin(angle))
                    var x2 = cx + (ro * Math.sin(angle))
                    var y1 = cy + (ri * Math.cos(angle))
                    var y2 = cy + (ro * Math.cos(angle))
                    ctx.moveTo(x1, y1)
                    ctx.lineTo(x2, y2)
                }
            }

            function deg2rad(deg) { return Math.PI * deg/180 }
        }
    }


    // helper functions -----------------------------------

    function r1() {
        return width * r1Stop/2
    }

    function r2() {
        return width * r2Stop/2
    }

    function r3() {
        return width * r3Stop/2
    }

    // for c1 drop shadow
    function c1ShadowStop1() { return 0.5*r1Stop }  // x 0.5 because circumference of circle is at stop position 0.5
    function c1ShadowStop2() { return 0.5*(r1Stop + (r2Stop-r1Stop)*c1ShadowWidth) }
    function c1ShadowStop1InsideEdge() { return c1ShadowStop1() * 0.999999 }

    // for c2 inner glow
    function c2IGStop1() { return 0.5*(r2Stop - (r2Stop-r1Stop)*c2GlowWidth) }
    function c2IGStop2() { return 0.5*r2Stop }
    function c2IGStop2OutEdge() { return c2IGStop2() * 1.000001 }
}



/*
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    width: 300
    height: 300

    Rectangle {
        id: bug
        anchors.fill: parent
        visible: false
        color: "red"
    }

    Item {
        id: mask
        anchors.fill: parent
        Rectangle {
            anchors.centerIn: parent
            radius: 50
            width: 200
            height: 200
            visible: true
            color: "black"
        }
    }

    OpacityMask {
        anchors.fill: bug
        source: bug
        maskSource: mask
    }
}
*/
