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
import "../components"

Page {
    id: printerlistPage
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: i18n.tr("Select Printer")
    }

    WaitingBar {
        id: waitingBar
        anchors.top: header.bottom
        waiting: printer.discovery
    }

    Rectangle {
        anchors {
            top: printer.discovery ? waitingBar.bottom : header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        ListModel {
            id: listModel
            function add(text) {
                const prt = JSON.parse(text)
                listModel.append(prt)
            }
        }

        Component {
            id: listDelegate
            ListItem {
                height: item.height + (divider.visible ? divider.height : 0)
                ListItemLayout {
                    id: item
                    title.text: model
                    subtitle.text: ip
                    Icon {
                        height: parent.title.font.pixelSize * 2
                        name: "printer-symbolic"
                        SlotsLayout.position: SlotsLayout.Leading
                    }
                }
                onClicked: {
                    printer.select(id)
                    mainStack.pop()
                }
            }
        }

        ListView {
            anchors.fill: parent
            model: listModel
            delegate: listDelegate
        }
    }

    onVisibleChanged: {
        if (visible) {
            printer.startDiscovery(listModel)
        } else {
            printer.stopDiscovery()
        }
    }
}
