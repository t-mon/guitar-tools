/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                                                         *
 *  Copyright (C) 2016-2017 Simon Stuerz <stuerz.simon@gmail.com>          *
 *                                                                         *
 *  This file is part of guitar tools.                                     *
 *                                                                         *
 *  Guitar tools is free software: you can redistribute it and/or modify   *
 *  it under the terms of the GNU General Public License as published by   *
 *  the Free Software Foundation, version 3 of the License.                *
 *                                                                         *
 *  Guitar tools is distributed in the hope that it will be useful,        *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the           *
 *  GNU General Public License for more details.                           *
 *                                                                         *
 *  You should have received a copy of the GNU General Public License      *
 *  along with guitar tools. If not, see <http://www.gnu.org/licenses/>.   *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

import QtQuick 2.7
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Pickers 1.3
import "components"
import GuitarTools 1.0

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the note selection page of the compose tool
        title: qsTr("Select note")
    }

    property int selectionIndex: -1

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.topMargin: pageHeader.height

        Item {
            Layout.fillWidth: true
            Layout.maximumWidth: units.gu(50)
            Layout.preferredHeight: units.gu(7)
            Layout.alignment: Qt.AlignHCenter

            Button {
                id: modeButton
                anchors.fill: parent
                anchors.margins: units.gu(1)
                // TRANSLATORS: Button in the note selection page of the compose tool (play mode -> click on note plays note, select mode -> click on note selects note)
                text: scale.selectMode ? qsTr("Play mode") : qsTr("Select mode")
                color: scale.selectMode ? UbuntuColors.green : UbuntuColors.graphite
                Behavior on color { ColorAnimation { duration: 400 ; easing.type: scale.selectMode ? Easing.OutQuad : Easing.InQuad} }
                onClicked: scale.selectMode = !scale.selectMode
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScaleItem {
                id: scale
                anchors.fill: parent
                scale: Core.fretBoardScale
                displayNotes: bottomEdge.displayFretboardNotes
                currentIndex: selectionIndex
                colorfull: true
                selectMode: true
                onSelected: pageLayout.removePages(root)
            }

            Component.onCompleted: scale.flickable.clip = true
        }
    }

    FretBoardBottomEdge { id: bottomEdge }
}
