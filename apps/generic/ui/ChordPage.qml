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
import QtMultimedia 5.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Pickers 1.0
import GuitarTools 1.0
import "components"

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        title: noteToString(chord.note) + chord.name
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            },
            Action {
                iconName: "help"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("ChordsHelpPage.qml"))
            }
        ]
    }

    property var chord: bottomEdge.chord
    property real chordPlayerDelay: Core.settings.chordPlayerDelay

    ChordPlayer {
        id: chordPlayer
        chord: root.chord
    }

    Connections {
        target: chordPlayer
        onStringPlucked: {
            indicatorRepeater.itemAt(stringNumber).pluck()
        }
    }

    GridLayout {
        id: mainColumn
        anchors.top: pageHeader.bottom
        anchors.topMargin: units.gu(5)
        anchors.left: parent.left
        anchors.leftMargin: units.gu(2)
        anchors.right: parent.right
        anchors.rightMargin: units.gu(2)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(5)

        rows: 2
        columns: 2

        rowSpacing: units.gu(3)

        Row {
            id: noteRow
            Layout.row: 0
            Layout.column: 1
            Layout.alignment: Qt.AlignHCenter

            Item {
                width: fingerboardImage.gridWidth
                height: width

                Label {
                    id: e2Label
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: parent.height * 0.7
                    text: guitarStringToString(Music.GuitarStringE2)
                    color: theme.palette.normal.baseText
                }
            }

            Item {
                width: fingerboardImage.gridWidth
                height: width

                Label {
                    id: aLabel
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: parent.height * 0.7
                    text: guitarStringToString(Music.GuitarStringA)
                    color: theme.palette.normal.baseText
                }
            }

            Item {
                width: fingerboardImage.gridWidth
                height: width

                Label {
                    id: dLabel
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: parent.height * 0.7
                    text: guitarStringToString(Music.GuitarStringD)
                    color: theme.palette.normal.baseText
                }
            }

            Item {
                width: fingerboardImage.gridWidth
                height: width

                Label {
                    id: gLabel
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: parent.height * 0.7
                    text: guitarStringToString(Music.GuitarStringG)
                    color: theme.palette.normal.baseText
                }
            }

            Item {
                width: fingerboardImage.gridWidth
                height: width

                Label {
                    id: bLabel
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: parent.height * 0.7
                    text: guitarStringToString(Music.GuitarStringB)
                    color: theme.palette.normal.baseText
                }
            }

            Item {
                width: fingerboardImage.gridWidth
                height: width

                Label {
                    id: e4Label
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: parent.height * 0.7
                    text: guitarStringToString(Music.GuitarStringE4)
                    color: theme.palette.normal.baseText
                }
            }
        }

        // Fret numbers
        Column {
            id: fretNumbers
            Layout.row: 1
            Layout.column: 0
            Layout.alignment: Qt.AlignHCenter

            Item {
                width: fingerboardImage.gridWidth
                height: fingerboardImage.gridHeight

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: -fingerboardImage.widthOffset
                    text: chord ? chord.startFret : ""
                    color: theme.palette.normal.baseText
                    font.pixelSize: fingerboardImage.fingerSize * 0.7
                }
            }

            Item {
                width: fingerboardImage.gridWidth
                height: fingerboardImage.gridHeight

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: -fingerboardImage.widthOffset
                    text:  chord ? chord.startFret + 1 : ""
                    color: theme.palette.normal.baseText
                    font.pixelSize: fingerboardImage.fingerSize * 0.7
                }
            }

            Item {
                width: fingerboardImage.gridWidth
                height: fingerboardImage.gridHeight

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: -fingerboardImage.widthOffset
                    text: chord ? chord.startFret + 2 : ""
                    color: theme.palette.normal.baseText
                    font.pixelSize: fingerboardImage.fingerSize * 0.7
                }
            }

            Item {
                width: fingerboardImage.gridWidth
                height: fingerboardImage.gridHeight

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: -fingerboardImage.widthOffset
                    text: chord ? chord.startFret + 3 : ""
                    color: theme.palette.normal.baseText
                    font.pixelSize: fingerboardImage.fingerSize * 0.7
                }
            }
        }

        Image {
            id: fingerboardImage
            Layout.row: 1
            Layout.column: 1
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width - fretNumbers.width
            Layout.maximumHeight: parent.height - noteRow.height

            property real thickness: paintedWidth / 60
            property real gridWidth: paintedWidth / 6
            property real gridHeight: paintedHeight / 4
            property real fingerSize: gridWidth * 0.8

            property real widthOffset: (width - paintedWidth) / 2
            property real heightOffset: (height - paintedHeight) / 2

            fillMode: Image.PreserveAspectFit
            source: "file://" + dataDirectory + "images/fingerboard.png"

            MouseArea {
                anchors.fill: parent
                onClicked: chordPlayer.playChord()
            }

            // Play string indicators
            Row {
                id: indicatorRow
                anchors.top: fingerboardImage.top
                anchors.topMargin: (-fingerboardImage.gridHeight / 2 ) + fingerboardImage.heightOffset
                anchors.horizontalCenter: fingerboardImage.horizontalCenter

                Repeater {
                    id: indicatorRepeater
                    model: 6
                    delegate: Item {
                        width: fingerboardImage.gridWidth
                        height: fingerboardImage.gridHeight

                        function pluck() {
                            pluckAnimation.restart()
                        }

                        Rectangle {
                            id: indicator
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: width
                            radius: width / 2
                            border.width: radius / 4
                            border.color: chord.positions.get(index).fret < 0 ? UbuntuColors.red : UbuntuColors.green
                            color: theme.palette.normal.base

                            ColorAnimation {
                                id: pluckAnimation
                                target: indicator
                                property: "color"
                                from: UbuntuColors.green
                                to: theme.palette.normal.base
                                easing.type: Easing.InQuad
                                duration: 1000
                            }
                        }
                    }
                }
            }

            // Barre item (if there is any)
            Item {
                id: barreItem
                anchors.left: fingerboardImage.left
                anchors.leftMargin: (chord.barreStringMin * fingerboardImage.gridWidth)  + fingerboardImage.widthOffset
                anchors.top: fingerboardImage.top
                anchors.topMargin: ((chord.barreFret - 1) * fingerboardImage.gridHeight) + fingerboardImage.heightOffset

                visible: chord ? chord.barre : false

                property real length: (chord.barreStringMax - chord.barreStringMin + 1) * fingerboardImage.gridWidth

                width: length
                height: fingerboardImage.gridHeight

                Rectangle {
                    id: barreRectangle
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: fingerboardImage.thickness * 1.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: barreItem.length
                    height: fingerboardImage.fingerSize
                    radius: height / 2
                    color: UbuntuColors.blue

                    Label {
                        anchors.centerIn: parent
                        text: chord.barreFinger
                        font.bold: true
                        font.pixelSize: parent.height * 0.5
                    }
                }
            }

            // Finger positions
            Repeater {
                id: fingerPositionRepeater
                anchors.fill: parent
                model: chord.positions

                delegate: Item {
                    anchors.left: fingerboardImage.left
                    anchors.leftMargin: (model.guitarStringNumber * fingerboardImage.gridWidth) + fingerboardImage.widthOffset
                    anchors.top: fingerboardImage.top
                    anchors.topMargin: ((model.fret - 1) *  fingerboardImage.gridHeight) + fingerboardImage.heightOffset
                    width: fingerboardImage.gridWidth
                    height: fingerboardImage.gridHeight

                    visible: !(chord.barre && model.finger === chord.barreFinger) && !(model.fret <= 0)

                    Rectangle {
                        id: fingerCircle
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: fingerboardImage.thickness * 1.5
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.8
                        height: width
                        radius: width / 2
                        color: UbuntuColors.green

                        Label {
                            anchors.centerIn: parent
                            text: model.finger
                            font.bold: true
                            font.pixelSize: parent.height * 0.5
                        }
                    }
                }
            }
        }
    }

    ChordsBottomEdge { id: bottomEdge }
}



