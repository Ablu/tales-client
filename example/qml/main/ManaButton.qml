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

T.Button {
    id: control

    implicitWidth: Math.max(sizeLabel.width + 20 + 20, 200);
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 6
    horizontalPadding: padding + 2
    spacing: 6

    icon.width: 24
    icon.height: 24
    icon.color: control.checked || control.highlighted ? control.palette.brightText :
                control.flat && !control.down ? (control.visualFocus ? control.palette.highlight : control.palette.windowText) : control.palette.buttonText

    contentItem: Item {
        TextShadow {
            target: label;
            color: "white";
            opacity: 0.7;
        }
        Text {
            id: label
            text: control.text
            anchors.centerIn: parent
            font.pixelSize: (control.height - 10) * 0.7;
            opacity: 0.8;
        }

        states: [
            State {
                name: "pressed"
                when: control.pressed
                PropertyChanges {
                    target: label
                    anchors.horizontalCenterOffset: 1
                    anchors.verticalCenterOffset: 1
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: label;
                    opacity: 0.7;
                }
            }
        ]
    }

    background: BorderImage {
        source: {
            const baseName = "images/bigbutton";
            if (control.pressed)
                baseName + "_pressed.png";
            else if (!control.enabled)
                baseName + "_disabled.png";
            else if (control.hovered || control.activeFocus)
                baseName + "_hovered.png";
            else
                baseName + ".png";
        }

        border.bottom: 20;
        border.top: 26;
        border.right: 100;
        border.left: 100;
    }

    Text {
        id: sizeLabel
        visible: false
        text: control.text
        font.pixelSize: (control.height - 10) * 0.7;
    }
}
