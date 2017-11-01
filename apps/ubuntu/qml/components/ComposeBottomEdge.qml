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

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Pickers 1.3
import QtQuick.Layouts 1.1
import GuitarTools 1.0

Item {
    id: root
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: units.gu(2)
    z: 3

    property real progress: 0

    property real scaleValue: Core.composeTool.scaleValue * 100

    Rectangle {
        anchors {fill: parent; topMargin: -units.gu(200) }
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
            if (root.progress == 0 && mouseY < height - units.gu(2)) {
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

            anchors {
                left: parent.left
                right: parent.right
                top: parent.bottom
                topMargin: -units.gu(2) - root.progress * (height - units.gu(2))
            }

            height: contentColumn.height + units.gu(4)

            Behavior on anchors.topMargin {
                UbuntuNumberAnimation {}
            }

            color: theme.palette.normal.overlay

            Rectangle {
                id: borderRectangle
                anchors { left: contentRect.left; top: contentRect.top; right: contentRect.right }
                height: units.gu(2)

                UbuntuShape {
                    anchors.centerIn: parent
                    height: units.gu(1)
                    width: units.gu(5)
                    radius: "medium"
                    color: UbuntuColors.inkstone
                }

                color: theme.palette.normal.overlaySecondaryText
            }

            ColumnLayout {
                id: contentColumn
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: units.gu(2)
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: units.gu(10)

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "zoom-out"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: scaleSlider.value = scaleSlider.minimumValue
                            }
                        }

                        Slider {
                            id: scaleSlider
                            Layout.fillWidth: true
                            minimumValue: 0
                            maximumValue: 200
                            stepSize: 1
                            onValueChanged: {
                                Core.composeTool.scaleValue = value / 100
                                Core.composeTool.save()
                            }
                            Component.onCompleted: scaleSlider.value = scaleValue
                        }

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "zoom-in"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: scaleSlider.value = scaleSlider.maximumValue
                            }
                        }
                    }
                }

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: units.gu(5)

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "audio-speakers-muted-symbolic"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: guitarPlayerVolumeSlider.value = guitarPlayerVolumeSlider.minimumValue
                            }
                        }

                        Slider {
                            id: guitarPlayerVolumeSlider
                            Layout.fillWidth: true
                            minimumValue: 0
                            maximumValue: 100
                            onValueChanged: Core.settings.guitarPlayerVolume = Math.round(value)
                            Component.onCompleted: guitarPlayerVolumeSlider.value = Core.settings.guitarPlayerVolume
                        }


                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "audio-speakers-symbolic"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: guitarPlayerVolumeSlider.value = guitarPlayerVolumeSlider.maximumValue
                            }
                        }
                    }
                }

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: units.gu(5)

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: disableFretboardNotesCheckbox.verticalCenter
                        // TRANSLATORS: In the scales view, indicates if the notes on the fretboard should be displayed or not
                        text: i18n.tr("Show notes")
                    }

                    Switch {
                        id: disableFretboardNotesCheckbox
                        anchors.right: parent.right
                        onCheckedChanged: {
                            Core.settings.displayFretboardNotes = disableFretboardNotesCheckbox.checked
                        }

                        Component.onCompleted: checked = Core.settings.displayFretboardNotes
                    }
                }
            }
        }
    }
}

