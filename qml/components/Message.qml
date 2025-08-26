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

import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

Dialog {
    id: dialogue
    objectName: "dialogPopup"

    property var buttonText: i18n.tr("Okay")
    property var buttonColor: Suru.theme == Suru.Dark ? LomiriColors.ash : LomiriColors.graphite

    default property alias content: top_col.data

    text: dialogue.text

    Column {
        id: top_col
        spacing: Suru.units.gu(2)
    }

    Button {
        text: dialogue.buttonText
        color: dialogue.buttonColor
        onClicked: {
            Qt.inputMethod.commit();
            PopupUtils.close(dialogue)
        }
    }
}
