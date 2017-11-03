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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import GuitarTools 1.0

Item {
    id: chordItem
    width: chordsGridView.cellWidth
    height: chordsGridView.cellHeight

    property var chord: Core.guitarPlayerChords.get(index)

    Rectangle {
        id: chrodShape
        anchors.fill: chordItem
        anchors.margins: 4
        x: chordItem.x
        y: chordItem.y
        color: index === root.selectedIndex ? Material.color(Material.Green) : Material.primary

        radius: height / 4

        Label {
            anchors.centerIn: parent
            text: chord ? noteToString(chord.note) + chord.name : ""
        }

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        states: [
            State {
                name: "moving"
                when: editActive && chordsGridMouseArea.mousePressed && chordItem.chord.fullName === chordsGridMouseArea.fullName && !chordsGridMouseArea.removePressed
                PropertyChanges {
                    target: chrodShape
                    visible: false
                }
            },
            State {
                name: "notSelected"
                when: editActive && chordsGridMouseArea.mousePressed && chordItem.chord.fullName !== chordsGridMouseArea.fullName
                PropertyChanges {
                    target: chrodShape
                    opacity: 0.6
                }
            }
        ]

        RotationAnimation {
            target: chrodShape
            running: !editActive
            loops: 1
            property: "rotation"
            to: 0
            duration: 100
        }

        SequentialAnimation {
            id: movingAnimation
            running: editActive
            loops: Animation.Infinite

            RotationAnimation {
                target: chrodShape
                property: "rotation"
                to: 3
                duration: 60
            }
            RotationAnimation {
                target: chrodShape
                property: "rotation"
                to: 0
                duration: 60
            }
            RotationAnimation {
                target: chrodShape
                property: "rotation"
                to: -3
                duration: 60
            }
            RotationAnimation {
                target: chrodShape
                property: "rotation"
                to: 0
                duration: 60
            }
        }
    }

    Rectangle {
        id: removeShape
        anchors.left: chordItem.left
        anchors.top: chordItem.top
        width: chordsGridMouseArea.removeAreaWidth
        height: width
        z: 2
        color: Material.color(Material.Red)
        opacity: editActive && (chord.note !== -1) ? 1 : 0
        radius: height / 4

        Image {
            id: removeIcon
            anchors.fill: parent
            anchors.margins: parent.width / 4
            source: dataDirectory + "/icons/delete.svg"
        }

        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }

        states: [
            State {
                name: "moving"
                when: editActive && chordsGridMouseArea.mousePressed && chordItem.chord.fullName === chordsGridMouseArea.fullName
                PropertyChanges {
                    target: removeShape
                    visible: false
                }
            },
            State {
                name: "default"
                when: !editActive
                PropertyChanges {
                    target: removeShape
                    opacity: 0
                }
            }
        ]
    }
}
