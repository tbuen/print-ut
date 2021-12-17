/*
 * Copyright (C) 2021  Thomas Büning
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * print is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "components"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'print.tbuen'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    PageStack {
        id: mainStack
    }
    Component.onCompleted: mainStack.push(Qt.resolvedUrl("pages/Print.qml"))

    Timer {
        id: refreshTimer
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            var msg = go.refresh()
            if (msg != "") {
                PopupUtils.open(errorMessage, null, {'text': msg})
            }
        }
    }

    Component {
        id: errorMessage
        Message {
        }
    }
}
