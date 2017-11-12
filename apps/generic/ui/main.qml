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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

import QtQuick.Controls.Material 2.2

import GuitarTools 1.0

ApplicationWindow {
    id: app
    width: 320
    height: 480
    visible: true
    title: qsTr("Guitar Tools")

    property bool landscape: height < width

    property color green: "#3eb34f"
    property color red: "#ed3146"



    Drawer {
        id: drawer
        width: 0.66 * app.width
        height: app.height

    }

//    ScreenSaver {
//        id: screenSaver
//        screenSaverEnabled: !Core.settings.disableScreensaver
//    }

//    Connections {
//        target: Qt.application
//        onActiveChanged: {
//            if (!Qt.application.active) {
//                screenSaver.screenSaverEnabled = false
//            } else {
//                screenSaver.screenSaverEnabled = !Core.settings.disableScreensaver
//            }
//        }
//    }

//    Connections {
//        target: Core.settings
//        onDarkThemeEnabledChanged: Core.settings.darkThemeEnabled ? Theme.name = "Ubuntu.Components.Themes.SuruDark" : Theme.name = "Ubuntu.Components.Themes.Ambiance"
//    }

    onClosing: {
        if(pageStack.depth > 1){
            close.accepted = false
            pageStack.pop();
            console.log("About to close. Pop pagestack.")
        }else{
            return;
        }
    }


    StackView {
        id: pageStack
        anchors.fill: parent
        Component.onCompleted: {
            Core.loadChords()
            Core.loadScales()
            push(Qt.resolvedUrl("MainPage.qml"))
        }
    }

    function guitarStringToString(guitarString) {
        switch(guitarString) {
        case Music.GuitarStringE2:
            // TRANSLATORS: E2 guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("E");
        case Music.GuitarStringA:
            // TRANSLATORS: A guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("A");
        case Music.GuitarStringD:
            // TRANSLATORS: D guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("D");
        case Music.GuitarStringG:
            // TRANSLATORS: G guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("G");
        case Music.GuitarStringB:
            // TRANSLATORS: B guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("B");
        case Music.GuitarStringE4:
            // TRANSLATORS: E4 guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("E");
        }
    }

    function keyToString(key) {
        switch(key) {
        case Music.NoteKeyNone:
            return "";
        case Music.NoteKeyMinor:
            // TRANSLATORS: Type of the chord. See https://en.wikipedia.org/wiki/Major_and_minor
            return qsTr("minor");
        case Music.NoteKeyMajor:
            // TRANSLATORS: Type of the chord. See https://en.wikipedia.org/wiki/Major_and_minor
            return qsTr("major");
        }
    }

    function noteToString(note) {
        switch(note) {
        case Music.NoteC:
            // TRANSLATORS: C: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("C");
        case Music.NoteCSharp:
            // TRANSLATORS: C sharp: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("C#");
        case Music.NoteD:
            // TRANSLATORS: D: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("D");
        case Music.NoteDSharp:
            // TRANSLATORS: D sharp: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("D#");
        case Music.NoteE:
            // TRANSLATORS: E: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("E");
        case Music.NoteF:
            // TRANSLATORS: F: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("F");
        case Music.NoteFSharp:
            // TRANSLATORS: F sharp: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("F#");
        case Music.NoteG:
            // TRANSLATORS: G: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("G");
        case Music.NoteGSharp:
            // TRANSLATORS: G# Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("G#");
        case Music.NoteA:
            // TRANSLATORS: A: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("A");
        case Music.NoteASharp:
            // TRANSLATORS: A sharp: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return qsTr("A#");
        case Music.NoteB:
            // TRANSLATORS: B: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return  qsTr("B");
        case Music.NoteNone:
            return  "-";
        }
    }

}

