# Build with Qt5.12.2

## Inspired by
 - Multi-Screen demo using Qt Automotive Suite
 
[![Multi-Screen demo using Qt Automotive Suite](http://img.youtube.com/vi/JAsxxeHCUSE/0.jpg)](http://www.youtube.com/watch?v=JAsxxeHCUSE "Multi-Screen demo using Qt Automotive Suite")
 
 - QtWS17 - Automotive navigation with Mapbox GL and QtLocation, Bruno de Oliveira Abinader, Mapbox
 
[![Automotive navigation with Mapbox GL and QtLocation](http://img.youtube.com/vi/rkgPvXWjSpI/0.jpg)](http://www.youtube.com/watch?v=rkgPvXWjSpI "Automotive navigation with Mapbox GL and QtLocation")

# Build instruction

## Overview
    * The Multiscreen Demo is based on the Neptune UI code which is provided as a part of the Qt Automotive Suite (https://doc.qt.io/QtAutomotiveSuite/).
    In its implementation, the Multiscreen Demo provides an alternative implementation for a few selected use cases in automotive UIs, e.g.,
    the use of 3D content, integration of the CAN-bus interfaces or a use of multiple screens. Please be aware that in the future this
    repository's functionality might get merged into the Neptune UI and this repository would be deleted.

    *  Multiscreen Demo implements the ability to use simulated events to 'drive' along a hardcoded route and also ability to control
    events sent to cluster through CanController. By default, demo runs in fully automatic mode and events are simulated.
    If you want to control the events, you can use CanController. The CanController synthesizes events and can deliver them via CAN or TCP.
    TCP is strongly recommended (unless you know better) as the CAN interface can produce 8-bit overflow issues and other unnoted problems,
    which should be investigated later. If you have want to use the CanController, it can be activated by setting the "fullDemo" property
    to false in ValueSource.qml:

    //
    // ENABLE FOR FULLY AUTOMATIC DEMO MODE (in case there is no CanController)
    //
    property bool fullDemo: true//false

    You can find the ValueSource.qml file under /opt/automotivedemo/imports/shared/service/valuesource
    in HW, or automotivedemo\imports\shared\service\valuesource in project hierarchy.

    The CanController (client) synthesizes CAN events, while the automotivedemo (server) responds to said events.

    If you really want to use CAN, you will probably want to use the SocketCAN driver, which can be set up on a Linux system using the following
    commands:

        sudo modprobe vcan
        sudo ip link add dev can0 type vcan
        sudo ip link set up can0

    * At least Qt 5.8 is required to build automotivedemo. Currently only TCP is supported in this automotivedemo.

## Walkthrough

    * OPTIONAL: Chose your data sources (using TCP, or create your CAN devices as necessary).

    * Build plugins from automotivedemo repository

            qmake -r INSTALL_PREFIX=/opt
            make & make install

    * Run apps

            OPTIONAL:
                If TCP connection is used, get the IP address from the device where automotivedemo is installed.
                Then use the IP address in CanController on runtime by defining QT_CLUSTER_SIMU env variable
                e.g. QT_CLUSTER_SIMU=192.168.0.1 by default it is localhost 127.0.0.1.

            In device set the following environment variable. If there are two screens available, application will
            automatically show both cluster center console views:
            export QT_QPA_EGLFS_KMS_CONFIG=<deployed kms_config.json file from automotivedemo git>

            Run in desktop
            appman.exe -r -c am-config.yaml --dbus none

            In device:
            chmod +x /opt/automotivedemo/start.sh
            ./start.sh

## Making it run automatically in HW

    Disable neptune-ui and enable automotive demo to startup during device boot:
        adb shell
        systemctl disable neptune
        systemctl enable automotivedemo
        systemctl start automotivedemo

Typical errors:
    * If you are not seeing the route in the map after you have selected destination, make sure that openssl libraries are found. Route feature is available
      only from Qt5.8 onwards.
    * "QtQuick.VirtualKeyboard is not installed" -> set environmentvariable QT_IM_MODULE=qtvirtualkeyboard
    * In Qt5.8.0 maps are not working offline, bug in https://bugreports.qt.io/browse/QTBUG-57011
      In case offline maps are needed, checkout following commit from qtlocation and recompile mapbox plugin:
          https://codereview.qt-project.org/#/c/176591/
