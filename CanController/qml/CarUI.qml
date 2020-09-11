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
import QtQml 2.12

Rectangle {
    width: 1024
    height: 768

    property int carNumber: 2

    Rectangle {
        id: leftBackgroundRect
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        width: 353
        color: "#484950"

        Car {
            id: car
            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }

            electricCar: carNumber === 0
            headLight: clusterDataControl.headLight
            //breakLight: brakeLights.pressed

            leftFrontDoorOpen: clusterDataControl.frontLeftDoorOpen
            leftBackDoorOpen: clusterDataControl.rearLeftDoorOpen
            rightFrontDoorOpen: clusterDataControl.frontRightDoorOpen
            rightBackDoorOpen: clusterDataControl.rearRightDoorOpen
            bootDoorOpen: clusterDataControl.trunkOpen
            hoodDoorOpen: clusterDataControl.hoodOpen
            leftBlink: clusterDataControl.leftTurnLight || clusterDataControl.hazardSignal
            rightBlink: clusterDataControl.rightTurnLight || clusterDataControl.hazardSignal
        }

        Gear {
            id: gearController
            visible: carNumber === 1
            gear: 1
            anchors {
                top: car.bottom
                topMargin: 33
                horizontalCenter: parent.horizontalCenter
            }
            onGearChanged: clusterDataControl.gear = gearController.gear
        }

        GearAutomatic {
            id: gearControllerAutomatic
            visible: carNumber !== 1
            gear: 1
            anchors {
                top: car.bottom
                topMargin: 33
                horizontalCenter: parent.horizontalCenter
            }
            onGearChanged: {
                if (gear !== 0 && brakeLights.pressed)
                    brakeLights.pressed = false
                clusterDataControl.gear = gearControllerAutomatic.gear
            }
        }

        Button {
            id: carID
            visible: true
            anchors {
                top: (carNumber === 1) ? gearController.bottom : gearControllerAutomatic.bottom
                topMargin: 33
                horizontalCenter: parent.horizontalCenter
            }
            width: 240
            height: 70
            radius: 6
            color: "#d6d6d6"
            textColor: "#26282a"
            textBlinkColor: "#26282a"
            blinkColor: "#d6d6d6"
            fontPixelSize: 23
            text: "Sports Car"
            onPressedChanged: {
                if (++carNumber > 2)
                    carNumber = 0
                resetButtonStates()
                clusterDataControl.carId = carNumber
                if (carNumber === 0)
                    text = "Electric Car"
                else if (carNumber === 1)
                    text = "Sports Car"
                else
                    text = "Hybrid Car"
            }
        }

        Button {
            id: demoMode
            anchors {
                top: carID.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            width: 240
            height: 35
            radius: 6
            color: "#d6d6d6"
            textColor: "#26282a"
            textBlinkColor: "#d6d6d6"
            blinkColor: "#26282a"
            fontPixelSize: 14
            text: "Automatic Demo Mode"
            onPressedChanged: {
                clusterDataControl.parkLight = demoMode.pressed
            }
        }
    }

    Rectangle {
        id: rightBackgroundRect
        anchors {
            top: parent.top
            left: leftBackgroundRect.right
            right: parent.right
            bottom: parent.bottom
        }
        width: 353
        color: "#ffffff"

        Grid {
            id: buttonGrid
            anchors {
                top: parent.top
                topMargin: 42
                left: parent.left
                leftMargin: 42
                right: parent.right
                rightMargin: 42
            }
            spacing: 10

            columns: 7
            rows: 3

            // 1st row
            ButtonHolder {
                id: leftSignalButton
                icon: "qrc:/images/Icon_TurnLeft_OFF.png"
                iconPressed: "qrc:/images/Icon_TurnLeft_ON.png"
                text: "Turn Left"
                blinkingEnabled: false
                onPressedChanged: {
                    if (leftSignalButton.pressed && rightSignalButton.pressed) {
                        rightSignalButton.pressed = false
                    }
                }
                mouseEnabled: !hazardButton.pressed

                Component.onCompleted: clusterDataControl.leftTurnLight = Qt.binding(function() {
                    return leftSignalButton.pressed
                })
            }

            ButtonHolder {
                id: rightSignalButton
                icon: "qrc:/images/Icon_TurnRight_OFF.png"
                iconPressed: "qrc:/images/Icon_TurnRight_ON.png"
                text: "Turn Right"
                blinkingEnabled: false
                onPressedChanged:  {
                    if (rightSignalButton.pressed && leftSignalButton.pressed) {
                        leftSignalButton.pressed = false
                    }
                }
                mouseEnabled: !hazardButton.pressed
                Component.onCompleted: clusterDataControl.rightTurnLight = Qt.binding(function() {
                    return rightSignalButton.pressed
                })
            }

            ButtonHolder {
                id: hazardButton
                icon: "qrc:/images/Icon_HazardWarning_OFF.png"
                iconPressed: "qrc:/images/Icon_HazardWarning_ON.png"
                text: "Hazard Warning"
                blinkingEnabled: false
                property bool leftPreviousState: false
                property bool rightPreviousState: false

                Component.onCompleted: clusterDataControl.hazardSignal = Qt.binding(function() {
                    return hazardButton.pressed
                })

                onPressedChanged: {
                    if (hazardButton.pressed) {
                        hazardButton.leftPreviousState = leftSignalButton.pressed
                        hazardButton.rightPreviousState = rightSignalButton.pressed
                    } else {
                        leftSignalButton.pressed = hazardButton.leftPreviousState
                        rightSignalButton.pressed = hazardButton.rightPreviousState
                    }
                }
            }
            /*
            ButtonHolder {
                id: parkLights
                text: "Position Lights"
                 onPressedChanged: clusterDataControl.parkLight = parkLights.pressed
            }
            */
            ButtonHolder {
                id: headLights
                icon: "qrc:/images/Icon_LowBeam_OFF.png"
                iconPressed: "qrc:/images/Icon_LowBeam_ON.png"
                text: "Low Beam"
                onPressedChanged: clusterDataControl.headLight = headLights.pressed
            }
            ButtonHolder {
                id: lampFailureButton
                icon: "qrc:/images/Icon_BulbFailure_OFF.png"
                iconPressed: "qrc:/images/Icon_BulbFailure_ON.png"
                text: "Bulb Failure"
                onPressedChanged: clusterDataControl.lightFailure = pressed
            }
            ButtonHolder {
                id: tireFailureButton
                text: "Tyre Malfunction"
                icon: "qrc:/images/Icon_TyreMalfunction_OFF.png"
                iconPressed: "qrc:/images/Icon_TyreMalfunction_ON.png"
                onPressedChanged: clusterDataControl.flatTire = pressed
            }

            // 2nd row
            /*
            ButtonHolder {
                text: "Seat Belt"
            }
            ButtonHolder {
                text: "Tyre Malfunction"
                icon: "qrc:/images/Icon_TyreMalfunction_OFF.png"
                iconPressed: "qrc:/images/Icon_TyreMalfunction_ON.png"
            }
            ButtonHolder {
                text: "Fuel"
            }
            */
            ButtonHolder {
                id: brakeLights
                icon: "qrc:/images/Icon_ParkingBrake_OFF.png"
                iconPressed: "qrc:/images/Icon_ParkingBrake_ON.png"
                text: "Parking Brake"
                onPressedChanged: {
                    gearController.gear = 0
                    gearControllerAutomatic.gear = 0
                    clusterDataControl.brake = brakeLights.pressed
                }
            }
            /*
            ButtonHolder {
                text: "Coolant Temp."
            }
            ButtonHolder {
                text: "Battery"
            }
            */

            // 3rd row
            Button {
                id: leftFrontDoorButton
                height: 60
                text: (carNumber === 0) ? "Left Door\nFRONT" : "Left Door"
                onPressedChanged: clusterDataControl.frontLeftDoorOpen = pressed
                visible: carNumber !== 2
            }
            Button {
                id: rightFrontDoorButton
                height: 60
                text: (carNumber === 0) ? "Right Door\nFRONT" : "Right Door"
                onPressedChanged: clusterDataControl.frontRightDoorOpen = pressed
                visible: carNumber !== 2
            }
            Button {
                id: hoodDoorButton
                height: 60
                text: "Hood"
                onPressedChanged: clusterDataControl.hoodOpen = pressed
                visible: carNumber !== 2
            }
            Button {
                id: leftBackDoorButton
                height: 60
                visible: (carNumber === 0)
                text: "Left Door\nBACK"
                onPressedChanged: clusterDataControl.rearLeftDoorOpen = pressed
            }
            Button {
                id: rightBackDoorButton
                height: 60
                visible: (carNumber === 0)
                text: "Right Door\nBACK"
                onPressedChanged: clusterDataControl.rearRightDoorOpen = pressed
            }
            Button {
                id: bootDoorButton
                height: 60
                text: "Trunk"
                onPressedChanged: clusterDataControl.trunkOpen = pressed
                visible: carNumber !== 2
            }
        }
        Row {
            id: viewButtons
            spacing: 10
            visible: false // Center view changing is not used with automotivedemo
            anchors {
                top: buttonGrid.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: 42
            }
            ViewChange {
                width: 270
                text: (carNumber === 0) ? "CHANGE LEFT VIEW" : "CHANGE CENTER VIEW"
                optionalIcons: carNumber === 2
            }
            ViewChange {
                visible: carNumber === 0
                text: "CHANGE RIGHT VIEW"
                mainView: false
                width: 270
            }
        }

        Column {
            anchors {
                top: viewButtons.bottom
                topMargin: 42
                left: parent.left
                leftMargin: 42
                right: parent.right
                rightMargin: 42
                bottom: parent.bottom
                bottomMargin: 30
            }
            SlideHolder {
                id: batteryLevel
                text: "BATTERY CHARGE"
                max: 100
                steps: 10
                value: 80
                valueStep: 2.5
                onValueChanged: {
                    // Battery charge vs. battery % level
                    // 12.66 V = 100 %
                    // 12.45 V = 75 %
                    // 12.24 V = 50 %
                    // 12.06 V = 25 %
                    // 11.89 V = 0 %
                    //clusterDataControl.batteryPotential = (11.89 + (0.0077 * batteryLevel.value))
                    clusterDataControl.batteryPotential = batteryLevel.value
                }
                Component.onCompleted: clusterDataControl.batteryPotential = batteryLevel.value

            }
            SlideHolder {
                id: waterTemperature
                text: "COOLANT TEMPERATURE"
                visible: carNumber !== 0
                min: 40
                max: 120
                steps: 8
                value: 60
                valueStep: 5
                enabled: !demoMode.pressed
                onValueChanged: clusterDataControl.engineTemp = waterTemperature.value
                Component.onCompleted: clusterDataControl.engineTemp = waterTemperature.value
            }
            SlideHolder {
                id: gasLevel
                text: "FUEL"
                visible: carNumber !== 0
                max: 100
                steps: 10
                value: 67
                onValueChanged: clusterDataControl.gasLevel = gasLevel.value
                Component.onCompleted: clusterDataControl.gasLevel = gasLevel.value
            }
            SlideHolder {
                id: rpm
                visible: carNumber !== 0
                text: "RPM (x1000)"
                max: 8.0
                steps: 8
                value: 4.0
                valueStep: 0.01
                enabled: !demoMode.pressed
                onValueChanged: clusterDataControl.rpm = rpm.value * 1000
                Component.onCompleted: clusterDataControl.rpm = rpm.value * 1000
            }
        }
    }

    function resetButtonStates() {
        headLights.pressed = false
        brakeLights.pressed = false
        //oilPressureWarning.pressed = false
        leftFrontDoorButton.pressed = false
        rightFrontDoorButton.pressed = false
        leftBackDoorButton.pressed = false
        rightBackDoorButton.pressed = false
        bootDoorButton.pressed = false
        hoodDoorButton.pressed = false
        tireFailureButton.pressed = false
        lampFailureButton.pressed = false
        leftSignalButton.pressed = false
        rightSignalButton.pressed = false
        hazardButton.pressed = false
        gearController.gear = 1
        gearControllerAutomatic.gear = 1
    }
}
