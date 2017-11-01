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

import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3
import GuitarTools 1.0

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Chord help page title
        title: i18n.tr("Help")
        flickable: helpFlickable
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            }
        ]
    }

    Flickable {
        id: helpFlickable
        anchors.fill: parent
        contentHeight: helpColumn.height

        Column {
            id: helpColumn
            anchors.left: parent.left
            anchors.leftMargin: units.gu(2)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(2)

            spacing: units.gu(1)

            ThinDivider { }

            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                // TRANSLATORS: Chord help page: description of the hand
                text: i18n.tr("Tap on the guitar fret board to listen how the chords sounds like. You can change the speed in the settings.")
                wrapMode: Text.WordWrap
            }

            ThinDivider { }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(3)
                Rectangle {
                    id: dontPluckRectangle
                    width: units.gu(4)
                    height: width
                    radius: width / 2
                    border.width: radius / 4
                    border.color: UbuntuColors.red
                    color: theme.palette.normal.base
                }

                Label {
                    // TRANSLATORS: Chord help page: symbol for not playing the string
                    text: i18n.tr("Don't play this string")
                    anchors.verticalCenter: dontPluckRectangle.verticalCenter
                }
            }

            ThinDivider { }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(3)
                Rectangle {
                    id: pluckRectangle
                    width: units.gu(4)
                    height: width
                    radius: width / 2
                    border.width: radius / 4
                    border.color: UbuntuColors.green
                    color: theme.palette.normal.base
                }

                Label {
                    // TRANSLATORS: Chord help page: symbol for playing the string
                    text: i18n.tr("Play this string")
                    anchors.verticalCenter: pluckRectangle.verticalCenter
                }
            }

            ThinDivider { }

            Label {
                // TRANSLATORS: Chord help page: description of the hand
                text: i18n.tr("Finger numbers")
                font.bold: true
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Image {
                id: handImage

                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width > units.gu(50) ? units.gu(50) : parent.width

                fillMode: Image.PreserveAspectFit
                source: "file://" + dataDirectory + "images/hand.svg"
            }

        }
    }
}

