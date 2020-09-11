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


import QtQuick 2.0

Item {
    id: mainSlide
    width: 500
    height: 80

    property real min: 0
    property real value: min
    property real max: 100
    property int steps: 10
    property real valueStep: 5
    property color sliderColor: enabled ? "#b6181e" : "lightGray"

    Rectangle {
        id: slideRail
        anchors {
            top: parent.top
            topMargin: 40
            left: parent.left
            leftMargin: 5
            right: parent.right
            rightMargin: 5
        }
        height: 4
        color: "#d6d6d6"
        property int railStep: ((mainSlide.max - mainSlide.min) / mainSlide.steps)
        Repeater {
            model: (mainSlide.steps + 1)
            anchors.bottom: parent.bottom
            Item {
                x: index * width - 0.5 * width
                y: -6
                width: (slideRail.width / mainSlide.steps)
                height: 30
                Rectangle {
                    id: slideIndex
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 3
                    height: 10
                    //radius: 3
                    color: (mainSlide.value >= (mainSlide.min + (index * slideRail.railStep))
                            ? sliderColor : "#d6d6d6")
                }
                Text {
                    anchors {
                        bottom: slideIndex.bottom
                        bottomMargin: 25
                        horizontalCenter: parent.horizontalCenter
                    }
                    color: (mainSlide.value >= (mainSlide.min + (index * slideRail.railStep))
                            ? sliderColor : "#d6d6d6")
                    font.pixelSize: 12
                    text: mainSlide.min + (index * slideRail.railStep)
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            slideMouse.changeX = true
            if (mouse.x <= slideRail.x)
                hiddenSlider.x = (slideRail.x - (0.5 * hiddenSlider.width))
            else if (mouse.x >= slideRail.x + slideRail.width)
                hiddenSlider.x = (slideRail.x + slideRail.width - (0.5 * hiddenSlider.width))
            else
                hiddenSlider.x = (mouse.x - (0.5 * hiddenSlider.width))
            slideMouse.changeX = false
        }
    }
    Rectangle {
        id: slideValue
        anchors {
            top: slideRail.top
            left: slideRail.left
            right: slider.right
            rightMargin: 1
        }
        radius: 5
        height: 4
        color: sliderColor
    }

    function calculateSliderPosition() {
        slider.x = (slideRail.x - (0.5 * slider.width)
                    + (((Math.min(Math.max(mainSlide.value, mainSlide.min), mainSlide.max)
                         - mainSlide.min) / (mainSlide.max - mainSlide.min)) * slideRail.width))
    }

    onValueChanged: {
        mainSlide.calculateSliderPosition()
    }

    Item {
        id: hiddenSlider
        width: 60
        height: parent.height
        onXChanged: {
            var tempValue = (mainSlide.min + (((hiddenSlider.x - slideRail.x
                                                + (0.5 * hiddenSlider.width)) / slideRail.width)
                                              * (mainSlide.max - mainSlide.min)))
            var tempStep = (tempValue % mainSlide.valueStep)
            mainSlide.value = tempValue - tempStep
                    + (tempStep < (0.5 * mainSlide.valueStep) ? 0 : mainSlide.valueStep)
        }
        MouseArea {
            id: slideMouse
            anchors.fill: parent
            property bool changeX: false
            drag {
                target: hiddenSlider
                axis: Drag.XAxis
                minimumX : (slideRail.x - (0.5 * hiddenSlider.width))
                maximumX: (slideRail.x + slideRail.width - (0.5 * hiddenSlider.width))
                onActiveChanged: slideMouse.changeX = slideMouse.drag.active
            }
        }
    }

    Rectangle {
        id: slider
        Component.onCompleted: mainSlide.calculateSliderPosition()
        anchors {
            top: parent.top
            topMargin: 22
        }

        width: 16
        height: 40
        radius: 8
        color: sliderColor
    }
}
