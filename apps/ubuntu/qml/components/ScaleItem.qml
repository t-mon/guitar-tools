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
import QtMultimedia 5.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3
import GuitarTools 1.0

Item {
    id: root

    property QtObject scale
    property bool colorfull: false
    property bool displayNotes
    property var flickable: fretBoardFlickable
    property bool selectMode: false
    property int currentIndex: -1

    signal selected()

    Flickable {
        id: fretBoardFlickable
        anchors.fill: parent
        contentHeight: fretBoardImage.paintedHeight + units.gu(12)

        flickableDirection: Flickable.VerticalFlick

        Image {
            id: fretBoardImage
            anchors.top: parent.top
            anchors.topMargin: units.gu(8)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width > units.gu(50) ? units.gu(50) * 0.65 : parent.width * 0.65
            fillMode: Image.PreserveAspectFit
            source: "file://" + dataDirectory + "images/fingerboard-full.png"

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
                            border.width: radius / 4
                            border.color: {
                                if (!colorfull && !root.selectMode && fretPositionItem.note === root.scale.note) {
                                    return UbuntuColors.blue
                                } else if (!colorfull && !root.selectMode) {
                                    return UbuntuColors.green
                                } else if (colorfull && !root.selectMode) {
                                    return Core.getColorForNote(fretPositionItem.fretPosition.noteFileName)
                                } else {
                                    return theme.palette.normal.baseText
                                }
                            }

                            Behavior on border.color { ColorAnimation { duration: 400 ; easing.type: selectMode ? Easing.InQuad : Easing.OutQuad } }

                            color: theme.palette.normal.base

                            ColorAnimation {
                                id: pluckAnimation
                                target: positionRectangle
                                property: "color"
                                from: positionRectangle.border.color
                                to: theme.palette.normal.base
                                easing.type: Easing.InQuad
                                duration: 1000
                            }

                            Label {
                                anchors.centerIn: parent
                                opacity: displayNotes ? 1 : 0
                                Behavior on opacity { NumberAnimation { duration: 500 } }
                                text: noteToString(fretPositionItem.note)
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: if (selectMode) positionRectangle.border.color = UbuntuColors.blue
                                onReleased: if (selectMode) positionRectangle.border.color = theme.palette.normal.base
                                onClicked: {
                                    if (selectMode) {
                                        print("Selected " + currentIndex + " " + noteToString(fretPositionItem.note) + " " + fretPositionItem.fretPosition.noteFileName)
                                        Core.composeTool.addNote(currentIndex, fretPositionItem.note, fretPositionItem.fretPosition.noteFileName)
                                        selected()
                                    } else {
                                        pluckAnimation.restart()
                                        Core.notePlayer.play("file://" + dataDirectory + "sounds/guitar/" + fretPositionItem.fretPosition.noteFileName)
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
            anchors.rightMargin: units.gu(2)
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
                        color: theme.palette.normal.baseText
                    }
                }
            }
        }
    }
}

