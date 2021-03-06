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

import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0
import controls 1.0
import utils 1.0

StackView {
    id: stack

    delegate: StackViewDelegate {
        function transitionFinished(properties)
        {
        }

        pushTransition: StackViewTransition {
            id: pushTransition
            property int duration: 400


            PropertyAnimation {
                target: exitItem
                property: "x"
                to: -(2*exitItem.width)
                duration: pushTransition.duration
            }

            PropertyAnimation {
                target: enterItem
                property: "x"
                from: 2*enterItem.width
                to: 0
                duration: pushTransition.duration
            }
        }
        popTransition: StackViewTransition {
            id: popTransition
            property int duration: 250

            PropertyAnimation {
                target: exitItem
                property: "x"
                to: 2*exitItem.width
                duration: popTransition.duration
            }

            PropertyAnimation {
                target: enterItem
                property: "x"
                from: -(2*enterItem.width)
                to: 0
                duration: popTransition.duration
            }
        }
    }
    Tracer{}
}
