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
import utils 1.0

Item {
    id: calendarContainer
    property string appointment
    property var currentDate
    property string date
    property string time
    opacity: 0.5
    property int defaultXPos: 0
    x: defaultXPos

    Image {
        id: image
        width: 100
        height: 100
        source: Style.symbol("calendar")
        x: 50
    }

    Text {
        id: dateText
        anchors.top: image.bottom
        anchors.topMargin: 10
        text: date
        color: "gray"
        font.pixelSize: 16
    }

    Text {
        id: timeText
        anchors.top: dateText.bottom
        anchors.horizontalCenter: dateText.horizontalCenter
        text: time
        color: "gray"
        font.pixelSize: 36
    }

    Text {
        anchors.top: timeText.bottom
        anchors.horizontalCenter: dateText.horizontalCenter
        text: appointment
        color: "lightGray"
        font.pixelSize: 20
    }

    Timer {
        id: fadeOutTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: {
            fadeOut.start()
        }
    }

    PropertyAnimation on opacity {
        id: fadeIn
        to: 1.0
        duration: 500
    }

    PropertyAnimation on opacity {
        id: fadeOut
        to: 0.5
        duration: 500
    }

    // TODO: Find out why these commented-out animations cause flashing on HW, and fix it
//    PropertyAnimation on x {
//        id: startupAnimation
//        to: 0
//        duration: 500
//        easing.type: Easing.InCubic
//    }

    Component.onCompleted: {
        currentDate = new Date()
        date = currentDate.toLocaleDateString(Qt.locale("en_GB"))
        time = currentDate.toLocaleTimeString(Qt.locale("en_GB"), "hh:mm")
//        startupAnimation.start()
//        fadeIn.start()
//        fadeOutTimer.start()
    }

    onVisibleChanged: {
        if (visible) {
            currentDate = new Date()
            date = currentDate.toLocaleDateString(Qt.locale("en_GB"))
            time = currentDate.toLocaleTimeString(Qt.locale("en_GB"), "hh:mm")
//            x = defaultXPos
//            startupAnimation.start()
            fadeIn.start()
            fadeOutTimer.restart()
        }
    }
}

