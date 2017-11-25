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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtMultimedia 5.9
import QtQuick.Controls.Material 2.2

import GuitarTools 1.0
import "components"

Page {
    id: root
    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            IconToolButton {
                iconSource: dataDirectory + "/icons/back.svg"
                onClicked: pageStack.pop()
            }

            Label {
                // TRANSLATORS: Chord help page title
                text: qsTr("Help")
                elide: Label.ElideRight
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/info.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }

    Flickable {
        id: helpFlickable
        anchors.fill: parent
        contentHeight: helpColumn.height

        Column {
            id: helpColumn
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5

            spacing: 5

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                // TRANSLATORS: Chord help page: description of the hand
                text: qsTr("Tap on the guitar fret board to listen how the chords sounds like. You can change the speed in the settings.")
                wrapMode: Text.WordWrap
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10
                Rectangle {
                    id: dontPluckRectangle
                    width: 30
                    height: width
                    radius: width / 2
                    border.width: radius / 4
                    border.color: Material.color(Material.Red)
                    color: Material.background
                }

                Label {
                    // TRANSLATORS: Chord help page: symbol for not playing the string
                    text: qsTr("Don't play this string")
                    anchors.verticalCenter: dontPluckRectangle.verticalCenter
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 5
                Rectangle {
                    id: pluckRectangle
                    width: 30
                    height: width
                    radius: width / 2
                    border.width: radius / 4
                    border.color: Material.color(Material.Green)
                    color: Material.background
                }

                Label {
                    // TRANSLATORS: Chord help page: symbol for playing the string
                    text: qsTr("Play this string")
                    anchors.verticalCenter: pluckRectangle.verticalCenter
                }
            }

            MenuSeparator { anchors.left: parent.left; anchors.right: parent.right }

            Label {
                // TRANSLATORS: Chord help page: description of the hand
                text: qsTr("Finger numbers")
                font.bold: true
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Image {
                id: handImage

                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width > 250 ? 250 : parent.width

                fillMode: Image.PreserveAspectFit
                source: dataDirectory + "/images/hand.svg"
            }
        }
    }
}

