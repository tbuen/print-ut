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

Page {
    id: printPage
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: "SimplePrint"
    }

    Column {
        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        ListItem {
            height: printerItem.height + (divider.visible ? divider.height : 0)
            ListItemLayout {
                id: printerItem
                title.text: i18n.tr("Printer")
                subtitle.text: printer.name ? printer.name : "<none>"
                Icon {
                    height: parent.title.font.pixelSize * 2
                    name: "printer-symbolic"
                    SlotsLayout.position: SlotsLayout.Leading
                }
                Icon {
                    height: parent.title.font.pixelSize * 2
                    name: "go-next"
                    SlotsLayout.position: SlotsLayout.Trailing
                }
            }
            onClicked: mainStack.push(Qt.resolvedUrl("PrinterList.qml"))
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "edit-clear"
                        onTriggered: printer.select(0)
                    }
                ]
            }
        }

        ListItem {
            height: fileItem.height + (divider.visible ? divider.height : 0)
            ListItemLayout {
                id: fileItem
                title.text: i18n.tr("File")
                subtitle.text: "<none>"
                Icon {
                    height: parent.title.font.pixelSize * 2
                    name: "stock_document"
                    SlotsLayout.position: SlotsLayout.Leading
                }
                Icon {
                    height: parent.title.font.pixelSize * 2
                    name: "go-next"
                    SlotsLayout.position: SlotsLayout.Trailing
                }
            }
            onClicked: console.log("clicked on File")
        }

        ListItem {
            height: button.height + (divider.visible ? divider.height : 0)
            ListItemLayout {
                id: button
                Button {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: anchors.leftMargin
                    text: i18n.tr("Print")
                    color: theme.palette.normal.positive
                    enabled: printer.name
                    onClicked: console.log("clicked on Print!!")
                }
            }
        }
    }
}
