/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt multiscreen demo application.
**
** $QT_BEGIN_LICENSE:GPL-EXCEPT$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.7
import service.valuesource 1.0
import com.qtcompany.clustergaugefiller 1.0

Item {
    property real consumptionValue: 2.0 + ValueSource.rpm / 444.45
    property real minValueAngle: 378
    property real maxValueAngle: 291
    property real minimumValue: 0
    property real maximumValue: 20

    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: 365
    anchors.rightMargin: 413

    GaugeFiller {
        id: consumptionFiller
        value: consumptionValue
        anchors.fill: parent
        numVertices: 64
        radius: 233
        fillWidth: 30
        color: "#EF2973"
        opacity: 0.3
        minAngle: minValueAngle
        maxAngle: maxValueAngle
        minValue: minimumValue
        maxValue: maximumValue
    }

    Item {
        width: 465
        height: 10
        rotation: consumptionFiller.angle - 72
        anchors.centerIn: parent

        Image {
            width: 144
            height: 5
            //opacity: 0.75
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            source: "../../images/SpeedometerNeedle.png"
        }
    }
}
