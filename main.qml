import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 640
    title: qsTr("Hello World")
    color: "orange"


    Dial {
        id: dial
        anchors.fill: parent
        valueLeft: 0.5
        valueRight: 0.5
        pointerHalfWidthAngle: 3
        markingAngularWidth: 60
        pointerAnimationDuration: 500
        baseColor: Qt.rgba(12/255, 26/255, 39/255, 1)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log(qsTr('Clicked on background. Text: "' + textEdit.text + '"'))
        }
    }

    TextEdit {
        id: textEdit
        text: qsTr("Enter some text...")
        verticalAlignment: Text.AlignVCenter
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        Rectangle {
            anchors.fill: parent
            anchors.margins: -10
            color: "transparent"
            border.width: 1
        }

        onTextChanged: {
            if (!isNaN(parseFloat(text)))
            {
                dial.valueLeft = parseFloat(text)
                dial.valueRight = parseFloat(text)
            }
        }
    }
}
