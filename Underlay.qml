import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property real r1Stop: 0.7
    property real r2Stop: 0.9
    property real r3Stop: 1

    property color r1Color: 'gray'
    property color r2Color: 'darkgray'
    property color r3Color: 'lightgray'

    property bool showMaskCircles: false
    property bool showMasks: false
    property bool showGloss: true
    property bool showShadow: true

    property real r1ShadowIntensity: 0.7
    property real r1ShadowWidth: 1.0


    // invisible -------------------------------

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


    // visible  ---------------------------------

    // base color
    Rectangle {
        id: baseColor
        anchors.fill: parent
        radius: width/2
        color: "brown"
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

            onHeightChanged: {
                console.log("onHeightChanged")
                _gloss1Gradient.height = height*2
            }

            onWidthChanged: {
                console.log("onWidthChanged")
                _gloss1Gradient.width = width*2
            }

            RadialGradient {
                id: _gloss1Gradient
                anchors.centerIn: parent
                verticalRadius: height * 0.35
                verticalOffset: -height * 0.33

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                    GradientStop { position: 0.99; color: Qt.rgba(1, 1, 1, 0.45) }
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

            onHeightChanged: {
                console.log("onHeightChanged")
                _gloss3Gradient.height = height*2
            }

            onWidthChanged: {
                console.log("onWidthChanged")
                _gloss3Gradient.width = width*2
            }

            RadialGradient {
                id: _gloss3Gradient
                anchors.centerIn: parent
                verticalRadius: height * 0.35
                verticalOffset: -height * 0.33

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                    GradientStop { position: 0.99; color: Qt.rgba(1, 1, 1, 0.45) }
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

    Item {
        id: shadowC1
        anchors.fill: parent
        visible: showShadow

        RadialGradient {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(0,0,0,0) }
                GradientStop { position: stop1InsideEdge(); color: Qt.rgba(0,0,0,0) }
                GradientStop { position: stop1(); color: Qt.rgba(0,0,0,r1ShadowIntensity) }
                GradientStop { position: stop2(); color: Qt.rgba(0,0,0,0) }
                GradientStop { position: 1; color: Qt.rgba(0,0,0,0) }
            }
        }
    }

    // helper functions ---------------------------

    function r1() {
        return width * r1Stop/2
    }

    function r2() {
        return width * r2Stop/2
    }

    function r3() {
        return width * r3Stop/2
    }

    // for shadow
    function stop1() { return 0.5*r1Stop*0.999999 }
    function stop2() { return 0.5*(r1Stop + (r2Stop-r1Stop)*r1ShadowWidth) }
    function stop1InsideEdge() { return stop1() * 0.999999 }
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
