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
import Qt.labs.folderlistmodel 1.0
import GuitarTools 1.0
import "components"

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the drum loops page
        title: qsTr("Recorder")
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            },
            Action {
                iconName: "media-playlist"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("RecorderPlaylistPage.qml"))
            }
        ]
    }

    Column {
        anchors.top: pageHeader.bottom
        anchors.topMargin: units.gu(5)
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: units.gu(2)

        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: units.gu(20)
            height: width

            Icon {
                name: "audio-input-microphone-symbolic"
                anchors.fill: parent
                implicitWidth: width
                implicitHeight: height
            }
        }

        Label {
            id: recordTimeLable
            anchors.horizontalCenter: parent.horizontalCenter
            text: Core.recorder.recordTime
            font.bold: true
            font.pixelSize: units.gu(4)
            opacity: 0
            color: theme.palette.normal.baseText

            SequentialAnimation {
                id: stopAnimation
                PropertyAnimation {
                    target: recordTimeLable
                    property: "scale"
                    to: 1.2
                    duration: 200
                }

                ParallelAnimation {

                    PropertyAnimation {
                        target: recordTimeLable
                        property: "scale"
                        to: 0
                        duration: 1000
                    }

                    PropertyAnimation {
                        target: recordTimeLable
                        property: "opacity"
                        to: 0
                        duration: 700
                    }
                }

            }

            Behavior on opacity { NumberAnimation { duration: 500 } }
        }

        UbuntuShape {
            id: recordButton
            anchors.horizontalCenter: parent.horizontalCenter
            width: units.gu(15)
            height: width / 2
            color: theme.palette.normal.base

            Icon {
                name: Core.recorder.running ? "media-playback-stop" : "media-record"
                anchors.centerIn: parent
                width: height
                height: parent.height * 0.9
                implicitWidth: width
                implicitHeight: height
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (Core.recorder.running) {
                        Core.recorder.stopRecording()
                        stopAnimation.start()
                    } else {
                        Core.recorder.startRecording()
                        recordTimeLable.opacity = 1
                        recordTimeLable.scale = 1
                    }
                }
            }
        }

        Connections {
            target: Core.recorder
            onVolumeLevelChanged: frequencyCanvas.requestPaint()
        }

        Item {
            id: sineWave
            anchors.left: parent.left
            anchors.right: parent.right
            height: units.gu(10)
            opacity: Core.recorder.running ? 1 : 0
            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }

            Canvas {
                id: frequencyCanvas

                property real time: 0
                property real dt: 0.5

                anchors.fill: parent
                smooth: true
                onPaint: {

                    time += dt
                    if(time > 300)
                        time = 0;

                    var dataLine = getContext("2d");
                    dataLine.save();
                    dataLine.reset();
                    dataLine.beginPath();
                    dataLine.lineWidth = units.gu(0.3);
                    dataLine.lineCap = "round"
                    dataLine.strokeStyle = theme.palette.normal.baseText;

                    var f = 30;
                    var dy = (frequencyCanvas.height / 2) - units.gu(0.3);
                    var amplitude = Core.recorder.volumeLevel * dy / 100;

                    if (amplitude > dy)
                        amplitude = dy

                    for(var x = 0; x <= frequencyCanvas.width; x++) {
                        var phase = x * 0.05 + time;
                        var y = dy - amplitude * Math.sin(2 * Math.PI * f + phase)
                        dataLine.lineTo(x, y);
                    }

                    dataLine.stroke();
                    dataLine.restore();
                }
            }
        }
    }

    MicrophoneVolumeBottomEdge { id: bottomEdge }
}
