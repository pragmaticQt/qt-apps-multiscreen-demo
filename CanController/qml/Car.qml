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
    id: carFrame

    width: electricCar ? carShapeElectric.width : carShape.width
    height: electricCar ? carShapeElectric.height : carShape.height

    property bool electricCar: false

    property bool headLight: false
    property bool leftBlink: false
    property bool rightBlink: false
    property bool breakLight: false

    property bool leftFrontDoorOpen: false
    property bool leftBackDoorOpen: false
    property bool rightFrontDoorOpen: false
    property bool rightBackDoorOpen: false
    property bool bootDoorOpen: false
    property bool hoodDoorOpen: false

    // Sports Car
    Image {
        id: carShape
        visible: !electricCar
        source: "qrc:/images/S-Car_Shape.png"
    }
    Image {
        visible: !electricCar
        source: breakLight ? "qrc:/images/S-Car_BrakesON.png" : "qrc:/images/S-Car_BrakesOFF.png"
    }
    Image {
        visible: !electricCar
        source: leftFrontDoorOpen ? "qrc:/images/S-Car_DoorLeftON.png" : "qrc:/images/S-Car_DoorLeftOFF.png"
    }
    Image {
        visible: !electricCar
        source: rightFrontDoorOpen ? "qrc:/images/S-Car_DoorRightON.png" : "qrc:/images/S-Car_DoorRightOFF.png"
    }
    Image {
        visible: !electricCar
        source: hoodDoorOpen ? "qrc:/images/S-Car_HoodON.png" : "qrc:/images/S-Car_HoodOFF.png"
    }
    Image {
        visible: !electricCar
        source: headLight ? "qrc:/images/S-Car_LowBeamsON.png" : "qrc:/images/S-Car_LowBeamsOFF.png"
    }
    Image {
        visible: !electricCar
        source: bootDoorOpen ? "qrc:/images/S-Car_TrunkON.png" : "qrc:/images/S-Car_TrunkOFF.png"
    }
    Image {
        visible: !electricCar
        source: leftBlink ? "qrc:/images/S-Car_TurnLeftON.png" : "qrc:/images/S-Car_TurnLeftOFF.png"
    }
    Image {
        visible: !electricCar
        source: rightBlink ? "qrc:/images/S-Car_TurnRightON.png" : "qrc:/images/S-Car_TurnRightOFF.png"
    }

    // Electric Car
    Image {
        id: carShapeElectric
        visible: electricCar
        source: "qrc:/images/E-Car_Shape.png"
    }
    Image {
        visible: electricCar
        source: breakLight ? "qrc:/images/E-Car_BrakesON.png" : "qrc:/images/E-Car_BrakesOFF.png"
    }
    Image {
        visible: electricCar
        source: leftFrontDoorOpen ? "qrc:/images/E-Car_FrontDoorLeftON.png"
                                  : "qrc:/images/E-Car_FrontDoorLeftOFF.png"
    }
    Image {
        visible: electricCar
        source: rightFrontDoorOpen ? "qrc:/images/E-Car_FrontDoorRightON.png"
                                   : "qrc:/images/E-Car_FrontDoorRightOFF.png"
    }
    Image {
        visible: electricCar
        source: leftBackDoorOpen ? "qrc:/images/E-Car_BackDoorLeftON.png"
                                 : "qrc:/images/E-Car_BackDoorLeftOFF.png"
    }
    Image {
        visible: electricCar
        source: rightBackDoorOpen ? "qrc:/images/E-Car_BackDoorRightON.png"
                                  : "qrc:/images/E-Car_BackDoorRightOFF.png"
    }
    Image {
        visible: electricCar
        source: hoodDoorOpen ? "qrc:/images/E-Car_HoodON.png" : "qrc:/images/E-Car_HoodOFF.png"
    }
    Image {
        visible: electricCar
        source: headLight ? "qrc:/images/E-Car_LowBeamsON.png" : "qrc:/images/E-Car_LowBeamsOFF.png"
    }
    Image {
        visible: electricCar
        source: bootDoorOpen ? "qrc:/images/E-Car_TrunkON.png" : "qrc:/images/E-Car_TrunkOFF.png"
    }
    Image {
        visible: electricCar
        source: leftBlink ? "qrc:/images/E-Car_TurnLeftON.png" : "qrc:/images/E-Car_TurnLeftOFF.png"
    }
    Image {
        visible: electricCar
        source: rightBlink ? "qrc:/images/E-Car_TurnRightON.png" : "qrc:/images/E-Car_TurnRightOFF.png"
    }
}
