/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/

pragma Singleton
import QtQuick 2.0
import QtApplicationManager.SystemUI 2.0
import service.music 1.0
import utils 1.0
import com.pelagicore.ScreenManager 1.0

QtObject {
    id: root

    property string activeAppId

    property variant blackListItems: []
    property Item windowItem
    property Item mapWidget

    signal applicationSurfaceReady(Item item)
    signal releaseApplicationSurface()

    // Cluster signals
    signal clusterWidgetReady(string category, Item item)
    signal clusterWidgetActivated(string category, Item item)

    signal passengerWidgetReady(string category, Item item)

    Component.onCompleted: {
        WindowManager.windowReady.connect(windowReadyHandler)
        WindowManager.windowClosing.connect(windowClosingHandler)
        ApplicationManager.applicationWasActivated.connect(applicationActivated)
        WindowManager.windowLost.connect(windowLostHandler)
        WindowManager.windowPropertyChanged.connect(windowPropertyChanged)
    }

    function windowReadyHandler(index, item) {
        print(":::LaunchController::: WindowManager:windowReadyHandler", index, item)
        var isInWidgetState = (WindowManager.windowProperty(item, "windowType") === "widgetMap")
        print(":::LaunchController:::isWidget", isInWidgetState)
        var isClusterWidget = (WindowManager.windowProperty(item, "windowType") === "clusterWidget")
        print(":::LaunchController:::isClusterWidget", isClusterWidget)
        var isPassengerWidget = (WindowManager.windowProperty(item, "windowType") === "passengerWidget")
        print(":::LaunchController:::isPassengerWidget", isPassengerWidget)

        var acceptWindow = true;
        var appID = WindowManager.get(index).applicationId;

        if (isInWidgetState) {
            acceptWindow = false
        }
        else if (isClusterWidget) {
            if (ApplicationManager.systemProperties.showCluster && (WindowManager.runningOnDesktop || ScreenManager.screenCount() > 1)) {
                if (ApplicationManager.get(appID).categories[0] === "media") {
                    root.clusterWidgetReady("media", item)
                } else if (ApplicationManager.get(appID).categories[0] === "app") {
                    root.clusterWidgetReady(ApplicationManager.get(appID).categories[1], item)
                }
                acceptWindow = false
            } else {
                acceptWindow = false
                item.parent = null
            }
        }
        else if (isPassengerWidget) {
            if (!Style.withPassengerView) {
                acceptWindow = false
                item.parent = null
            } else {
                if (ApplicationManager.get(appID).categories[0] === "app") {
                    root.passengerWidgetReady(ApplicationManager.get(appID).categories[1], item)
                }
                acceptWindow = false
            }
        }
        else {

            for (var i = 0; i < root.blackListItems.length; ++i) {
                if (appID === root.blackListItems[i])
                    acceptWindow = false;
            }

        }

        if (acceptWindow) {
            root.windowItem = item
            WindowManager.setWindowProperty(item, "visibility", true)

            root.applicationSurfaceReady(item)
        } else {
            if (!item.parent) {
                item.parent = root.windowItem
                item.visible = false
                item.paintingEnabled = false
            }
        }
    }

    function windowPropertyChanged(window, name, value) {
        print(":::LaunchController::: WindowManager:windowPropertyChanged", window, name, value)
        if (name === "visibility" && value === false) {
            root.releaseApplicationSurface()
        }
    }

    function windowClosingHandler(index, item) {
        if (item === root.windowItem) {           // start close animation
            root.releaseApplicationSurface()
        }
    }

    function windowLostHandler(index, item) {
        WindowManager.releaseWindow(item)   // immediately close anything which is not handled by this container
    }

    function applicationActivated(appId, appAliasId) {
        print(":::LaunchController::: WindowManager:raiseApplicationWindow" + appId + " " + WindowManager.count)
        root.activeAppId = appId
        for (var i = 0; i < WindowManager.count; i++) {
            if (WindowManager.get(i).applicationId === appId) {
                var item = WindowManager.get(i).windowItem
                print(":::LaunchController::: App found. Running the app " + appId + " Item: " + item)
                var isWidget = (WindowManager.windowProperty(item, "windowType") === "widget")
                var isMapWidget = (WindowManager.windowProperty(item, "windowType") === "widgetMap")
                var isClusterWidget = (WindowManager.windowProperty(item, "windowType") === "clusterWidget")
                var isPassengerWidget = (WindowManager.windowProperty(item, "windowType") === "passengerWidget")
                print(":::LaunchController:::isClusterWidget", isClusterWidget)
                print(":::LaunchController:::isPassengerWidget", isPassengerWidget)
                print(":::LaunchController:::isWidget", isWidget, isMapWidget)

                if (isClusterWidget) {
                    if (ApplicationManager.get(appId).categories[0] === "app") {
                        root.clusterWidgetActivated(ApplicationManager.get(appId).categories[1], item)
                    }
                    break
                }

                if (!isMapWidget && !isClusterWidget && !isPassengerWidget) {
                    WindowManager.setWindowProperty(item, "visibility", true)
                    root.windowItem = item
                    root.applicationSurfaceReady(item)
                }
            }
        }
    }
}
