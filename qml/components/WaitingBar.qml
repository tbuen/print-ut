import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    property bool waiting: false
    id: waitingBar
    anchors {
        top: parent.top
        right: parent.right
        left: parent.left
    }
    height: units.dp(3)

    states: [
        State {
            name: "idle"
            PropertyChanges { target: animation; running: false }
            PropertyChanges { target: waitingBar; visible: false }
        },
        State {
            name: "running"
            PropertyChanges { target: animation; running: true }
            PropertyChanges { target: waitingBar; visible: true }
        }
    ]

    state: waiting ? "running" : "idle"

    Rectangle {
        id: flyer
        width: parent.width / 4
        height: parent.height
        color: theme.palette.normal.activity

        property var xStart: 0
        property var xEnd: parent.width - width

        SequentialAnimation on x {
            id: animation
            // loops: Animation.Infinite
            onStopped: start() // Workaround for animation length to be updated on screen rotation (width change)

            XAnimator {
                from: flyer.xStart; to: flyer.xEnd
                easing.type: Easing.InOutCubic; duration: 1000
            }
            XAnimator {
                from: flyer.xEnd; to: flyer.xStart
                easing.type: Easing.InOutCubic; duration: 1400
            }
        }
    }
}
