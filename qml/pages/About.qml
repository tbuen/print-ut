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

Page {
    id: aboutPage
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: "About"
    }

    Item {
        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Column {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: units.gu(3)
            }

            LomiriShape {
                anchors.horizontalCenter: parent.horizontalCenter
                radius: "large"
                image: Image {
                    source: Qt.resolvedUrl("../../assets/icon.svg")
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text: "<br><b>SimplePrint</b><br>Version 0.2.0<br>"
            }

            ListItem {
                height: divider.height
                divider.visible: true
            }

            ListItem {
                height: sourcecodeItem.height + (divider.visible ? divider.height : 0)

                ListItemLayout {
                    id: sourcecodeItem
                    title.text: i18n.tr("Source Code")

                    Icon {
                        height: parent.title.font.pixelSize * 2
                        name: "go-next"
                        SlotsLayout.position: SlotsLayout.Trailing
                    }
                }

                onClicked: Qt.openUrlExternally("https://github.com/tbuen/print-ut")
            }
        }
    }
}
