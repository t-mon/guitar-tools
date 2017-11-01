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
import GuitarTools 1.0

Item {
    id: root

    property var chord: null
    property int currentString: 0
    property real volume: Core.settings.guitarPlayerVolume / 100

    signal stringPlucked(int stringNumber)

    onChordChanged: {
        loadStringFiles()
        console.log("ChordPlayer: " + app.noteToString(chord.note) + chord.name)
    }

    function playChord() {
        stop()
        pluckNextString()
    }

    function loadStringFiles() {
        if (!root.chord)
            return

        // set source files for sound effects
        console.log("Load chord string notes")
        for (var i = 0; i < 6; i++) {
            var chordPosition = root.chord.positions.get(i)
            var absolutFret = root.chord.startFret + chordPosition.fret - 1
            if (i === 0) {
                e2Effect.source = "file://" + dataDirectory + "sounds/guitar/" + Core.getNoteFileName(i, absolutFret)
                console.log("E2 = " + Core.getNoteFileName(i, absolutFret))
            } else if (i === 1) {
                aEffect.source = "file://" + dataDirectory + "sounds/guitar/" + Core.getNoteFileName(i, absolutFret)
                console.log("A = " + Core.getNoteFileName(i, absolutFret))
            } else if (i === 2) {
                dEffect.source = "file://" + dataDirectory + "sounds/guitar/" + Core.getNoteFileName(i, absolutFret)
                console.log("D = " + Core.getNoteFileName(i, absolutFret))
            } else if (i === 3) {
                gEffect.source = "file://" + dataDirectory + "sounds/guitar/" + Core.getNoteFileName(i, absolutFret)
                console.log("G = " + Core.getNoteFileName(i, absolutFret))
            } else if (i === 4) {
                bEffect.source = "file://" + dataDirectory + "sounds/guitar/" + Core.getNoteFileName(i, absolutFret)
                console.log("B = " + Core.getNoteFileName(i, absolutFret))
            } else if (i === 5) {
                e4Effect.source = "file://" + dataDirectory + "sounds/guitar/" + Core.getNoteFileName(i, absolutFret)
                console.log("E4 = " + Core.getNoteFileName(i, absolutFret))
            }
        }
    }

    function stop() {
        pluckTimer.stop()
        root.currentString = 0
    }

    function pluckNextString() {
        if (!root.chord)
            return

        for (var i = 0; i < 6; i++) {
            if (i != root.currentString)
                continue

            var chordPosition = chord.positions.get(i)
            if (chordPosition.fret < 0) {
                root.currentString += 1
                continue
            }

            var absolutFret = chord.startFret + chordPosition.fret
            if (i === 0) {
                e2Effect.play()
            } else if (i === 1) {
                aEffect.play()
            } else if (i === 2) {
                dEffect.play()
            } else if (i === 3) {
                gEffect.play()
            } else if (i === 4) {
                bEffect.play()
            } else if (i === 5) {
                e4Effect.play()
            }

            console.log(app.guitarStringToString(currentString) + " - " + chordPosition.fret)
            stringPlucked(i)
            root.currentString += 1
            pluckTimer.restart()
            return
        }
    }

    Timer {
        id: pluckTimer
        repeat: false
        interval: Core.settings.chordPlayerDelay
        running: false
        onTriggered: pluckNextString()
    }

    GuitarSoundEffect {
        id: e2Effect
        source: "file://" + dataDirectory + "sounds/guitar/E2-0.wav"
    }

    GuitarSoundEffect {
        id: aEffect
        source: "file://" + dataDirectory + "sounds/guitar/A-0.wav"
    }

    GuitarSoundEffect {
        id: dEffect
        source: "file://" + dataDirectory + "sounds/guitar/D-0.wav"
    }

    GuitarSoundEffect {
        id: gEffect
        source: "file://" + dataDirectory + "sounds/guitar/G-0.wav"
    }

    GuitarSoundEffect {
        id: bEffect
        source: "file://" + dataDirectory + "sounds/guitar/B-0.wav"
    }

    GuitarSoundEffect {
        id: e4Effect
        source: "file://" + dataDirectory + "sounds/guitar/E4-0.wav"
    }
}

