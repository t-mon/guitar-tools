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
import Ubuntu.Components 1.3
import GuitarTools 1.0

Item {
    id: chordItem
    width: chordsGridView.cellWidth
    height: chordsGridView.cellHeight

    property var chord: Core.guitarPlayerChords.get(index)

    UbuntuShape {
        id: chrodShape
        anchors.fill: chordItem
        anchors.margins: units.gu(1)
        x: chordItem.x
        y: chordItem.y
        color: index === root.selectedIndex ? UbuntuColors.green : theme.palette.normal.base

        Label {
            anchors.centerIn: parent
            text: chord? noteToString(chord.note) + chord.name : ""
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

    UbuntuShape {
        id: removeShape
        color: UbuntuColors.lightGrey
        anchors.left: chordItem.left
        anchors.top: chordItem.top
        width: chordsGridMouseArea.removeAreaWidth
        height: width
        z: 2
        backgroundColor: "#CCff4444"
        opacity: editActive && (chord.note !== -1) ? 1 : 0

        Icon {
            anchors.centerIn: parent
            implicitHeight: parent.height * 0.7
            implicitWidth: parent.width * 0.7
            name: "delete"
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
