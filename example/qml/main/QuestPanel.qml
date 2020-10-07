import QtQuick 2.12
import Mana 1.0

ListView {
    id: listView
    anchors.fill: parent
    anchors.leftMargin: 5
    anchors.rightMargin: 5

    clip: true
    topMargin: 10
    bottomMargin: 5

    model: gameClient.questlogListModel

    delegate: Column {
        width: listView.width

        Text {
            text: model.quest.title
            color: model.quest.state === Quest.OPEN ? "green" : "black"
            font.bold: true
            font.pixelSize: 12
        }
        Text {
            text: model.quest.description
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.right
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }
    }
}
