import QtQuick 2.0
import QtQuick.Layouts 1.0

SideTab {
    id: statusPanel;

    function limitPrecision(number, precision) {
        var p = Math.pow(10, precision);
        return Math.round(number * p) / p;
    }

    Item {
        id: contents

        anchors.fill: parent
        anchors.topMargin: 22
        anchors.rightMargin: 28
        anchors.bottomMargin: 7

        clip: flickable.interactive
        visible: partlyVisible

        Item {
            id: flickable

            anchors.top: headerOrnamental.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 8

            //interactive: contentHeight > height
            //contentHeight: grid.height

            GridLayout {
                id: grid

                anchors.left: parent.left
                anchors.right: parent.right

                columns: 2
                rowSpacing: 5
                columnSpacing: 5

                AttributeLabel {
                    name: qsTr("Strength")
                    value: playerAttributes.strength
                    Layout.row: 0
                    Layout.column: 0
                    Layout.fillWidth: true
                }
                AttributeLabel {
                    name: qsTr("Damage")
                    value: {
                        var base = playerAttributes.damage;
                        var min = Math.round(base);
                        var max = Math.round(base + playerAttributes.damageDelta);
                        return min + "-" + max;
                    }
                    Layout.row: 0
                    Layout.column: 1
                    Layout.fillWidth: true
                }

                AttributeLabel {
                    name: qsTr("Agility")
                    value: playerAttributes.agility
                    Layout.row: 1
                    Layout.column: 0
                    Layout.fillWidth: true
                }
                AttributeLabel {
                    name: qsTr("Movement speed")
                    value: limitPrecision(playerAttributes.movementSpeed, 1)
                    Layout.row: 1
                    Layout.column: 1
                    Layout.fillWidth: true
                }
                AttributeLabel {
                    name: qsTr("Dodge")
                    value: limitPrecision(playerAttributes.dodge, 1)
                    Layout.row: 2
                    Layout.column: 1
                    Layout.fillWidth: true
                }

                AttributeLabel {
                    name: qsTr("Dexterity")
                    value: playerAttributes.dexterity
                    Layout.row: 3
                    Layout.column: 0
                    Layout.fillWidth: true
                }
                AttributeLabel {
                    name: qsTr("Hit chance")
                    value: limitPrecision(playerAttributes.hitChance, 1)
                    Layout.row: 3
                    Layout.column: 1
                    Layout.fillWidth: true
                }

                AttributeLabel {
                    name: qsTr("Vitality")
                    value: playerAttributes.vitality
                    Layout.row: 4
                    Layout.column: 0
                    Layout.fillWidth: true
                }
                AttributeLabel {
                    name: qsTr("Health")
                    value: playerAttributes.maxHealth
                    Layout.row: 4
                    Layout.column: 1
                    Layout.fillWidth: true
                }
                AttributeLabel {
                    name: qsTr("Regeneration")
                    value: limitPrecision(playerAttributes.healthRegeneration / 10, 2) + "/s"
                    Layout.row: 5
                    Layout.column: 1
                    Layout.fillWidth: true
                }
                AttributeLabel {
                    name: qsTr("Defense")
                    value: limitPrecision(playerAttributes.defense, 1)
                    Layout.row: 6
                    Layout.column: 1
                    Layout.fillWidth: true
                }

                AttributeLabel {
                    name: qsTr("Intelligence")
                    value: playerAttributes.intelligence
                    Layout.row: 7
                    Layout.column: 0
                    Layout.fillWidth: true
                }

                AttributeLabel {
                    name: qsTr("Willpower")
                    value: playerAttributes.willpower
                    Layout.row: 8
                    Layout.column: 0
                    Layout.fillWidth: true
                }
            }
        }

        Image {
            id: headerOrnamental
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            source: "images/header_ornamental.png"
            fillMode: Image.TileHorizontally
            horizontalAlignment: Image.AlignLeft
            smooth: false
        }

        Text {
            id: nameLabel
            text: gameClient.playerName
            font.pixelSize: 12
            font.bold: true
            anchors.left: parent.left
            anchors.baseline: levelLabel.baseline
            anchors.leftMargin: 8
            color: "#3F2B25"
        }

        Text {
            id: levelLabel
            anchors.bottom: headerOrnamental.bottom
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.bottomMargin: 1
            text: 'Level ' + Math.floor(playerAttributes.level)
            font.pixelSize: 12
            color: "#3F2B25"
        }
    }
}
