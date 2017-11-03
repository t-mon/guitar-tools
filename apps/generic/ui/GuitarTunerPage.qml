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
    title: qsTr("Guitar tuner")
    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            IconToolButton {
                iconSource: dataDirectory + "/icons/back.svg"
                onClicked: pageStack.pop()
            }

            Label {
                text: qsTr("Guitar tuner")
                elide: Label.ElideRight
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/tuning-fork.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("TuningForkPage.qml"))
            }

            IconToolButton {
                iconSource: dataDirectory + "/icons/info.svg"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }

    Component.onDestruction: Core.guitarTuner.disable()

    property real angleMax: -60
    property real angleMin: 60
    property real minValue: 50
    property real maxValue: -50

    property int tolerance: 5

    property bool landscape: width > height

    property string note: app.noteToString(Core.guitarTuner.note)
    property real value: Core.guitarTuner.centValue
    property real angle: (((value - minValue) / (maxValue - minValue)) * (angleMax - angleMin)) + angleMin;


    Connections {
        target: Core.guitarTuner
        onVolumeLevelChanged: frequencyCanvas.requestPaint()
    }

    Item {
        anchors.fill: parent
        anchors.margins: 5


        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: root.header.height
            anchors.bottomMargin: frequency.height

            Label {
                id: noteLabel
                Layout.alignment: Qt.AlignCenter
                Layout.minimumHeight: 30
                font.bold: true
                font.pixelSize: 30
                text: note
                color: value >= -tolerance && value <= tolerance ? app.green : Material.foreground
            }

            Label {
                id: frequencyLabel
                Layout.alignment: Qt.AlignCenter
                Layout.minimumHeight: 20
                font.bold: true
                font.pixelSize: 20
                visible: Core.settings.debugEnabled
                color: Material.foreground
                text: Core.guitarTuner.frequency.toFixed(2) + " [Hz]"
            }

            Image {
                id: scaleImage
                fillMode: Image.PreserveAspectFit
                Layout.fillHeight: landscape
                Layout.fillWidth: !landscape
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: parent.width
                Layout.maximumHeight: parent.height

                source: dataDirectory + "/images/tuner-scale.svg"

                Image {
                    id: needleImage
                    fillMode: Image.PreserveAspectFit
                    height: scaleImage.paintedHeight
                    anchors.top: scaleImage.top
                    anchors.topMargin: ( scaleImage.height - scaleImage.paintedHeight ) / 2
                    anchors.horizontalCenter: scaleImage.horizontalCenter

                    source: dataDirectory + "/images/tuner-needle.svg"

                    transform: Rotation {
                        origin {
                            x: needleImage.width / 2
                            y: needleImage.height
                        }
                        axis { x: 0; y: 0; z: 1 }
                        angle: root.angle

                        Behavior on angle {
                            SpringAnimation {
                                spring: 1.4
                                damping: 0.15
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: frequency
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40

            color: "transparent"

            Canvas {
                id: frequencyCanvas

                property real time: 0
                property real dt: 1.5

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
                    var amplitude = Core.guitarTuner.volumeLevel * 2 * dy / 100;

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

    //TunerBottomEdge { id: bottomEdge }
}

