import QtQuick 2.12
import QtQuick.Controls 2.12

/**
 * A TextField in Mana style
 */
TextField {
    anchors.margins: 5;

    font.pixelSize: (childrenRect.height - 10) * 0.7;

    color: "black"

    background: BorderImage {
        source: "images/lineedit.png"
        border.bottom: 20;
        border.top: 20;
        border.right: 20;
        border.left: 20;
    }
}
