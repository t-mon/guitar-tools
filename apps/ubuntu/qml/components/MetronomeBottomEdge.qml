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
    property real metronomeVolume: Core.settings.metronomeVolume

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
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: units.gu(10)

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: units.gu(10)

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            anchors.verticalCenter: parent.verticalCenter
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "audio-speakers-muted-symbolic"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: metronomeVolumeSlider.value = metronomeVolumeSlider.minimumValue
                            }
                        }

                        Slider {
                            id: metronomeVolumeSlider
                            Layout.fillWidth: true
                            anchors.verticalCenter: parent.verticalCenter
                            minimumValue: 0
                            maximumValue: 100
                            value: metronomeVolume
                            onValueChanged: Core.settings.metronomeVolume = Math.round(value)
                        }

                        Icon {
                            Layout.minimumWidth: units.gu(3)
                            anchors.verticalCenter: parent.verticalCenter
                            implicitHeight: units.gu(3)
                            implicitWidth: width
                            name: "audio-speakers-symbolic"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: metronomeVolumeSlider.value = metronomeVolumeSlider.maximumValue
                            }
                        }

                    }
                }
            }
        }
    }
}

