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
    anchors.left: parent.left
    anchors.right: parent.right
    height: 60

    property real indicatorValue
    property real speed: 1
    property real frequency: 300
    property bool running: true
    property color lineColor: Material.foreground

    property real currentTime: 0

    Behavior on opacity {
        NumberAnimation { duration: 500 }
     }

    onIndicatorValueChanged: frequencyCanvas.requestPaint()
    onFrequencyChanged: frequencyCanvas.requestPaint()

    Timer {
        id: paintTimer
        interval: 50
        running: root.running
        repeat: true
        onTriggered: frequencyCanvas.requestPaint()
    }

    Canvas {
        id: frequencyCanvas

        property real dt: speed

        anchors.fill: parent
        smooth: true
        onPaint: {
            currentTime += (speed / 40)//Core.guitarTuner.volumeLevel / 10 + dt;
            if(currentTime > 1000){
                currentTime = 0;
            }

            var dataLine = getContext("2d");
            dataLine.save();
            dataLine.reset();
            dataLine.beginPath();
            dataLine.lineWidth = 1;
            dataLine.lineCap = "round"
            dataLine.strokeStyle = root.lineColor;

            var f = root.frequency;
            var dy = (frequencyCanvas.height / 2) - 1;
            var amplitude = root.indicatorValue * 2 * dy / 100;

            if (amplitude > dy)
                amplitude = dy

            for(var x = 0; x <= frequencyCanvas.width; x++) {
                var phase = (x * f / 2500) + currentTime;
                var y = dy - amplitude * Math.sin(2 * Math.PI * f + phase)
                dataLine.lineTo(x, y);
            }

            dataLine.stroke();
            dataLine.restore();
        }
    }
}
