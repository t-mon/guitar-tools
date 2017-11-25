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
import QtQuick.Controls.Material 2.2

import GuitarTools 1.0

Item {
    id: root

    property QtObject scale
    property bool colorfull: false
    property bool displayNotes: Core.settings.displayFretboardNotes
    property var flickable: fretBoardFlickable
    property bool selectMode: false
    property int currentIndex: -1

    signal selected()

    Flickable {
        id: fretBoardFlickable
        anchors.fill: parent
        contentHeight: fretBoardImage.paintedHeight + 50

        flickableDirection: Flickable.VerticalFlick

        Image {
            id: fretBoardImage
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width > 350 ? 350 * 0.65 : parent.width * 0.65
            fillMode: Image.PreserveAspectFit
            source: dataDirectory + "/images/fingerboard-full.svg"

            Item {
                id: positionsItem
                width: fretBoardImage.paintedWidth + fretBoardImage.paintedWidth / 5
                height: fretBoardImage.paintedHeight
                anchors.top: parent.top
                anchors.topMargin: -cellHeight * 0.5
                anchors.horizontalCenter: parent.horizontalCenter

                property real cellWidth: width / 6
                property real cellHeight: height / 12

                Repeater {
                    id: scalePositionsRepeater
                    anchors.fill: parent
                    model: root.scale.positions
                    delegate: Item {
                        id: fretPositionItem

                        property var fretPosition: root.scale.positions.get(index)
                        property var note: fretPosition.note

                        x: fretPosition.guitarStringNumber * positionsItem.cellWidth
                        y: fretPosition.fret * positionsItem.cellHeight

                        width: positionsItem.cellWidth
                        height: width

                        Rectangle {
                            id: positionRectangle
                            anchors.centerIn: parent
                            width: parent.width * 0.9
                            height: width
                            radius: width / 2
                            border.width: radius / 8
                            border.color: {
                                if (!colorfull && !root.selectMode && fretPositionItem.note === root.scale.note) {
                                    return Material.color(Material.Blue)
                                } else if (!colorfull && !root.selectMode) {
                                    return Material.color(Material.Green)
                                } else if (colorfull && !root.selectMode) {
                                    return Core.getColorForNote(fretPositionItem.fretPosition.noteFileName)
                                } else {
                                    return Material.foreground
                                }
                            }

                            Behavior on border.color { ColorAnimation { duration: 400 ; easing.type: selectMode ? Easing.InQuad : Easing.OutQuad } }

                            color: Material.background

                            ColorAnimation {
                                id: pluckAnimation
                                target: positionRectangle
                                property: "color"
                                from: positionRectangle.border.color
                                to: Material.background
                                easing.type: Easing.InQuad
                                duration: 1000
                            }

                            Label {
                                anchors.centerIn: parent
                                opacity: displayNotes ? 1 : 0
                                font.pixelSize: parent.height * 0.4
                                Behavior on opacity { NumberAnimation { duration: 500 } }
                                text: noteToString(fretPositionItem.note)
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: if (selectMode) positionRectangle.border.color = Material.color(Material.Blue)
                                onReleased: if (selectMode) positionRectangle.border.color = Material.background
                                onClicked: {
                                    if (selectMode) {
                                        print("Selected " + currentIndex + " " + noteToString(fretPositionItem.note) + " " + fretPositionItem.fretPosition.noteFileName)
                                        Core.composeTool.addNote(currentIndex, fretPositionItem.note, fretPositionItem.fretPosition.noteFileName)
                                        selected()
                                    } else {
                                        pluckAnimation.restart()
                                        Core.notePlayer.play(dataDirectory + "/sounds/guitar/" + fretPositionItem.fretPosition.noteFileName)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Column {
            id: fretNumberColumn
            anchors.right: fretBoardImage.left
            anchors.rightMargin: 12
            anchors.top: fretBoardImage.top

            Repeater {
                id: fretNumberRepeater
                model: 12
                delegate: Item {
                    height: fretBoardImage.paintedHeight / 12
                    width: fretBoardImage.paintedWidth / 6

                    Label {
                        anchors.centerIn: parent
                        text: modelData + 1
                        font.pixelSize: parent.width * 0.7
                        color: Material.foreground
                    }
                }
            }
        }
    }
}

