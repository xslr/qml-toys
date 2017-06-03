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
    property bool showMasks: true


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
        id: glossMask
        anchors.fill: parent
        visible: true

        OpacityMask {
            id: maskR3R2
            anchors.fill: parent
            source: circR3
            maskSource: circR2
            invert: true
            visible: showMasks
        }

        OpacityMask {
            id: maskR1R1
            anchors.fill: parent
            source: circR1
            maskSource: circR1
            visible: showMasks
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
        id: baseCircle
        anchors.fill: parent
        radius: width/2
        color: "brown"
    }

    // gloss
    Item {
        id: gloss
        anchors.fill: parent

        onHeightChanged: {
            console.log("onHeightChanged")
        }

        onWidthChanged: {
            console.log("onWidthChanged")
        }

        RadialGradient {
            id: glossGradient
            anchors.fill: parent
            verticalRadius: height * 0.3
            verticalOffset: -height * 0.25
            visible: false

            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                GradientStop { position: 0.99; color: Qt.rgba(1, 1, 1, 0.45) }
                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0) }
            }
        }

        OpacityMask {
            anchors.fill: parent
            source: glossGradient
            maskSource: glossMask
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
