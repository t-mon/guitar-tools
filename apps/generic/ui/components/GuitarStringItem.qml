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
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3
import GuitarTools 1.0

Item {
    id: root

    // String properties
    property string noteName
    property real thickness
    property string stringColor: theme.palette.normal.baseText
    property int fret: 0

    // Animation properties
    property int swingDuration: 20
    property int swingLoops: 50
    property int currentSwingLoops: swingLoops
    property real amplitude: root.height / 12
    property real currentAmplitude: amplitude

    property string source: ""

    function pluck() {
        if (fret < 0 && Core.settings.disableNotAssociatedStrings)
            return

        currentSwingLoops = swingLoops
        currentAmplitude = amplitude
        stringAnimation.restart()
        Core.notePlayer.play(root.source)
    }

    Rectangle {
        id: stringRectangle
        anchors.left: parent.left
        anchors.right: parent.right
        y: root.height / 2
        x: 0
        height: thickness
        color: {
            if (fret < 0 && Core.settings.markNotAssociatedStrings) {
                return UbuntuColors.red
            } else {
                return theme.palette.normal.baseText
            }
        }

        SequentialAnimation {
            id: stringAnimation
            running: false
            loops: 1
            NumberAnimation {
                target: stringRectangle
                property: "y"
                from: root.height / 2
                to: root.height / 2 + root.currentAmplitude
                duration: root.swingDuration / 2
            }

            NumberAnimation {
                target: stringRectangle
                property: "y"
                from: root.height / 2 + root.currentAmplitude
                to: root.height / 2 - root.currentAmplitude
                duration: root.swingDuration
            }

            NumberAnimation {
                target: stringRectangle
                property: "y"
                from: root.height / 2 - root.currentAmplitude
                to: root.height / 2
                duration: root.swingDuration / 2
            }

            onRunningChanged: {
                if (!running && root.currentSwingLoops > 0) {
                    root.currentSwingLoops -= 1
                    root.currentAmplitude -= root.amplitude / root.swingLoops
                    stringAnimation.start()
                }
            }
        }
    }

    MouseArea {
        id: clickArea
        anchors.fill: parent
        onClicked: pluck()
    }
}

