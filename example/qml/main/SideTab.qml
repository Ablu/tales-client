import QtQuick 2.0

MouseArea {
    property alias icon: tabIcon.source;
    property alias name: title.text;

    property string alignment;

    state: "closed"

    drag.target: children[0]
    drag.axis: Drag.XAxis
    drag.minimumX: alignment === "left" ? -1 : 1 * statusPanel.width
    drag.maximumX: alignment === "left" ? 0 : parent.width
    drag.filterChildren: true
    onReleased: openOrClose()

    function toggle() {
        state = state === "closed" ? "open" : "closed";
    }

    readonly property bool partlyVisible: x > -width

    function openOrClose() {
        var open = -statusPanel.x < statusPanel.width / 2;
        statusPanel.state = ""  // hack to make sure to trigger transition
        statusPanel.state = open ? "open" : "closed";
    }

    Image {
        id: tab
        source: "images/tab.png"
        y: parent.height / 4
        anchors.left: parent.right
        anchors.leftMargin: -3
        smooth: false
    }

    MouseArea {
        id: handle;

        anchors.fill: tab
        anchors.margins: -5

        drag.target: statusPanel;
        drag.axis: Drag.XAxis;
        drag.minimumX: -statusPanel.width;
        drag.maximumX: 0;

        onClicked: toggle();
        onReleased: openOrClose();
    }

    Image {
        id: tabIcon
        source: "images/tab_icon_character.png"
        anchors.centerIn: tab
        smooth: false
    }

    BorderImage {
        anchors.fill: parent
        anchors.leftMargin: -33;
        anchors.rightMargin: -1

        source: "images/scroll_medium_horizontal.png"
        border.left: 40; border.top: 31
        border.right: 38; border.bottom: 32
        smooth: false
        visible: partlyVisible
    }

    ScrollTitle {
        id: title
        anchors.horizontalCenterOffset: -14
        visible: partlyVisible
    }

    states: [
        State {
            name: "open";

            PropertyChanges {
                target: statusPanel;
                x: 0;
            }
        },
        State {
            name: "closed";
            PropertyChanges {
                target: statusPanel;
                x: -statusPanel.width;
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "x"; easing.type: Easing.OutQuad }
        }
    ]
}
