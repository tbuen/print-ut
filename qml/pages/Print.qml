/*
 * Copyright (C) 2025  Thomas Büning
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import Lomiri.Content 1.3 as ContentHub
import "../components"

Page {
    id: printPage
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: "SimplePrint"
        trailingActionBar {
            actions: [
                Action {
                    iconName: "info"
                    text: "About"
                    onTriggered: pageStack.push(Qt.resolvedUrl("About.qml"))
                }
            ]
            numberOfSlots: 2
        }
    }

    WaitingBar {
        anchors.top: header.bottom
        waiting: go.printing
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
                subtitle.text: go.printer ? go.printer : "<none>"
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
                        onTriggered: go.selectPrinter(0)
                    }
                ]
            }
        }

        ListItem {
            height: fileItem.height + (divider.visible ? divider.height : 0)
            ListItemLayout {
                id: fileItem
                title.text: i18n.tr("File")
                subtitle.text: go.filename ? go.filename : "<none>"
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
            onClicked: {
                Qt.inputMethod.hide()
                mediaImporter.contentType = ContentHub.ContentType.All
                mediaImporter.requestMedia()
            }
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "edit-clear"
                        onTriggered: go.setFile("")
                    }
                ]
            }
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
                    enabled: go.printer && go.filename && !go.printing
                    onClicked: go.print()
                }
            }
        }
    }

    MediaImport {
        id: mediaImporter

        onMediaReceived: {
            var fileNames = []
            for (var i = 0; i < importedFiles.length; i++) {
                var filePath = String(importedFiles[i].url).replace('file://', '')
                fileNames.push(filePath)
            }
            if (fileNames.length > 0) {
                go.setFile(fileNames[0])
            }
        }
    }
}
