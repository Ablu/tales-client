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
 * A blue button suitable for use on frames.
 */
T.Button {
    id: control

    property bool keepPressed: false

    implicitHeight: Math.max(sizeLabel.height + 10, 30)
    implicitWidth: Math.max(sizeLabel.width + 20, 30)

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
            color: "white"
            anchors.centerIn: parent
            font.pixelSize: 14
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
                when: control.pressed
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
                "images/frame_button_pressed.png"
            else
                "images/frame_button.png"
        }

        smooth: false

        border.bottom: 5
        border.top: 5
        border.right: 5
        border.left: 5
    }

    Text {
        id: sizeLabel
        visible: false
        text: control.text
        font.pixelSize: 14
    }
}
