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
import Lomiri.Components 1.3
import QtQuick.Layouts 1.1
import GuitarTools 1.0
import "components"

Page {
    id: root
    header: PageHeader {
        id: pageHeader
        // TRANSLATORS: Title of the guitar tuner page
        title: i18n.tr("Guitar tuner")
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                onTriggered: pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("AboutPage.qml"))
            },
            Action {
                iconSource: "file://" + dataDirectory + "icons/tuning-fork.svg"
                onTriggered: {
                    Core.activateTuningFork()
                    pageLayout.addPageToCurrentColumn(root, Qt.resolvedUrl("TuningForkPage.qml"))
                }
            }
        ]
    }

    property real angleMax: -60
    property real angleMin: 60
    property real minValue: 50
    property real maxValue: -50

    property int tolerance: 5

    property bool landscape: width > height

    property string note: app.noteToString(Core.guitarTuner.note)
    property real value: Core.guitarTuner.centValue
    property real angle: (((value - minValue) / (maxValue - minValue)) * (angleMax - angleMin)) + angleMin;

    Component.onDestruction: Core.guitarTuner.disable()

    Connections {
        target: Core.guitarTuner
        onVolumeLevelChanged: frequencyCanvas.requestPaint()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: pageHeader.height
        anchors.bottomMargin: frequency.height

        Label {
            id: noteLabel
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: units.gu(8)
            font.bold: true
            font.pixelSize: units.gu(8)
            text: note
            color: value >= -tolerance && value <= tolerance ? LomiriColors.green : theme.palette.normal.baseText
        }

        Label {
            id: frequencyLabel
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: units.gu(2)
            font.bold: true
            font.pixelSize: units.gu(2)
            visible: Core.settings.debugEnabled
            color: theme.palette.normal.baseText
            text: Core.guitarTuner.frequency.toFixed(2) + " [Hz]"
        }

        Image {
            id: scaleImage
            fillMode: Image.PreserveAspectFit
            Layout.fillHeight: landscape
            Layout.fillWidth: !landscape
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: parent.width > units.gu(100) ? units.gu(100) : parent.width
            Layout.maximumHeight: parent.height

            source: "file://" + dataDirectory + "images/tuner-scale.png"

            Image {
                id: needleImage
                fillMode: Image.PreserveAspectFit
                height: scaleImage.paintedHeight
                anchors.top: scaleImage.top
                anchors.topMargin: ( scaleImage.height - scaleImage.paintedHeight ) / 2
                anchors.horizontalCenter: scaleImage.horizontalCenter

                source: "file://" + dataDirectory + "images/tuner-needle.png"

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
        height: units.gu(20)

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
                dataLine.lineWidth = units.gu(0.3);
                dataLine.lineCap = "round"
                dataLine.strokeStyle = theme.palette.normal.baseText;

                var f = 30;
                var dy = (frequencyCanvas.height / 2) - units.gu(0.3);
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


    TunerBottomEdge { id: bottomEdge }
}

