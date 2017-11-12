/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                                                         *
 *  Copyright (C) 2016-2017 Simon Stuerz <stuerz.simon@gmail.com>          *
 *  Copyright (C) 2016 Michael Zanetti  (KodiMote)                         *
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
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: 20
    z: 3

    property real progress: 0
    property real guitarPlayerVolume: Core.settings.guitarPlayerVolume
    property bool displayFretboardNotes: Core.settings.displayFretboardNotes

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: - root.parent.height
        color: "#88000000"
        opacity: root.progress
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.progress = 0;
                mouse.accepted = true;
            }
            enabled: root.progress > 0
        }
    }

    MouseArea {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: contentRect.height
        property bool ignoring: false

        property var gesturePoints: new Array()

        onPressed: {
            gesturePoints = new Array();
            ignoring = false;
            if (root.progress == 0 && mouseY < height - root.height) {
                mouse.accepted = false;
                ignoring = true;
            }
        }

        onMouseYChanged: {
            if (ignoring) {
                return;
            }
            root.progress = Math.min(1, (height - mouseY) / height)
            gesturePoints.push(mouseY)
        }

        onReleased: {
            var oneWayFlick = true;
            var upwards = gesturePoints[1] < gesturePoints[0];
            for (var i = 1; i < gesturePoints.length; i++) {
                if (upwards && gesturePoints[i] > gesturePoints[i-1]) {
                    oneWayFlick = false;
                    break;
                } else if(!upwards && gesturePoints[i] < gesturePoints[i-1]) {
                    oneWayFlick = false;
                    break;
                }
            }

            if (oneWayFlick && upwards) {
                root.progress = 1;
            } else if (oneWayFlick && !upwards) {
                root.progress = 0;
            } else if (root.progress > .5) {
                root.progress = 1;
            } else {
                root.progress = 0;
            }
        }

        Rectangle {
            id: contentRect
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.bottom
            anchors.topMargin: -root.height - root.progress * (height - root.height)


            height: contentColumn.implicitHeight + root.height
            Behavior on anchors.topMargin { NumberAnimation { } }

            color: Material.primary

            Rectangle {
                id: borderRectangle
                anchors { left: contentRect.left; top: contentRect.top; right: contentRect.right }
                height: root.height

                Rectangle {
                    anchors.centerIn: parent
                    height: 4
                    width: 20
                    radius: height / 2
                    color: Material.background
                }

                color: Material.color(Material.BlueGrey)
            }

            ColumnLayout {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: root.height

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right

                        IconToolButton {
                            iconSource: dataDirectory + "/icons/audio-speakers-muted-symbolic.svg"
                            onClicked: guitarPlayerVolumeSlider.value = guitarPlayerVolumeSlider.from
                        }

                        Slider {
                            id: guitarPlayerVolumeSlider
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            value: guitarPlayerVolume
                            onValueChanged: Core.settings.guitarPlayerVolume = Math.round(value)
                            Component.onCompleted: guitarPlayerVolumeSlider.value = guitarPlayerVolume
                        }

                        IconToolButton {
                            iconSource: dataDirectory + "/icons/audio-speakers-symbolic.svg"
                            onClicked: guitarPlayerVolumeSlider.value = guitarPlayerVolumeSlider.to
                        }
                    }
                }


                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: disableFretboardNotesCheckbox.verticalCenter
                        // TRANSLATORS: In the scales view, indicates if the notes on the fretboard should be displayed or not
                        text: qsTr("Show notes")
                    }

                    Switch {
                        id: disableFretboardNotesCheckbox
                        anchors.right: parent.right
                        onCheckedChanged: Core.settings.displayFretboardNotes = disableFretboardNotesCheckbox.checked
                        Component.onCompleted: checked = displayFretboardNotes
                    }
                }
            }
        }
    }
}
