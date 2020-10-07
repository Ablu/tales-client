/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

/**
 * A brown button suitable for use on scrolls.
 */
T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(sizeLabel.height + 2 * 5, 20)

    property bool keepPressed: false

    padding: 6
    horizontalPadding: padding + 2
    spacing: 6

    icon.width: 24
    icon.height: 24
    icon.color: control.checked || control.highlighted ? control.palette.brightText :
                control.flat && !control.down ? (control.visualFocus ? control.palette.highlight : control.palette.windowText) : control.palette.buttonText

    contentItem: Item {
        Text {
            id: label
            text: control.text
            color: "#3f2b25"
            font.pixelSize: 14
            wrapMode: Text.WordWrap

            anchors.right: parent.right
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 7
            anchors.leftMargin: 7
        }

        Image {
            id: icon
            source: control.icon.source
            anchors.centerIn: parent
            smooth: false
        }

        states: [
            State {
                name: "pressed"
                when: control.pressed || control.keepPressed
                PropertyChanges {
                    target: label
                    anchors.verticalCenterOffset: 1
                }
                PropertyChanges {
                    target: icon
                    anchors.verticalCenterOffset: 1
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: label
                    opacity: 0.7
                }
            }
        ]
    }

    background: BorderImage {
        source: {
            if (control.pressed || control.keepPressed)
                "images/scroll_button_pressed.png"
            else if (control.focus)
                "images/scroll_button_focused.png"
            else
                "images/scroll_button.png"
        }

        smooth: false

        border.bottom: 5
        border.top: 5
        border.right: 5
        border.left: 5
    }

    Text {
        id: sizeLabel
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 7
        anchors.leftMargin: 7
        visible: false
        text: control.text
        font.pixelSize: 14
        wrapMode: Text.WordWrap
    }
}
