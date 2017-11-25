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
                text: qsTr("Recorder")
                elide: Label.ElideRight
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/media-playlist.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("RecorderPlaylistPage.qml"))
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/info.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: frequency.top

        Image {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width
            Layout.maximumHeight: parent.height


            fillMode: Image.PreserveAspectFit
            source: dataDirectory + "/images/audio-microphone.png"
        }

        Label {
            id: recordTimeLable
            Layout.alignment: Qt.AlignHCenter
            text: Core.recorder.recordTime
            font.bold: true
            font.pixelSize: 30
            opacity: 0
            color: Material.foreground

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

        Rectangle {
            id: recordButton
            Layout.alignment: Qt.AlignHCenter
            width: 100
            height: width / 2
            color: Material.background

            Image {
                source: Core.recorder.running ? dataDirectory + "/icons/media-playback-stop.svg" : dataDirectory + "/icons/media-record.svg"
                anchors.centerIn: parent
                width: height
                height: parent.height * 0.9
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
    }

    Item {
        id: frequency
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomEdge.top
        height: 60

        Canvas {
            id: frequencyCanvas

            property real time: 0
            property real dt: 1.5

            opacity: Core.recorder.running ? 1 : 0
            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }

            anchors.fill: parent
            smooth: true
            onPaint: {

                time += dt //Core.guitarTuner.volumeLevel / 10 + dt;
                if(time > 300){
                    time = 0;
                }

                var dataLine = getContext("2d");
                dataLine.save();
                dataLine.reset();
                dataLine.beginPath();
                dataLine.lineWidth = 1;
                dataLine.lineCap = "round"
                dataLine.strokeStyle = Material.foreground;

                var f = 30;
                var dy = (frequencyCanvas.height / 2) - 1;
                var amplitude = Core.recorder.volumeLevel * 2 * dy / 100;

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

    MicrophoneVolumeBottomEdge { id: bottomEdge }
}
