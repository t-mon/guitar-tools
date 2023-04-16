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
import QtSystemInfo 5.0
import GuitarTools 1.0

MainView {
    id: app
    objectName: "app"
    applicationName: "guitar-tools.t-mon"

    property bool landscape: height < width

    height: units.gu(71)
    width: units.gu(40)

    Component.onCompleted: {
        i18n.domain = "guitar-tools.t-mon"
        Theme.name = Core.settings.darkThemeEnabled ? "Lomiri.Components.Themes.SuruDark" : "Lomiri.Components.Themes.Ambiance"
    }

    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: !Core.settings.disableScreensaver
    }

    Connections {
        target: Qt.application
        onActiveChanged: {
            if (!Qt.application.active) {
                screenSaver.screenSaverEnabled = false
            } else {
                screenSaver.screenSaverEnabled = !Core.settings.disableScreensaver
            }
        }
    }

    Connections {
        target: Core.settings
        onDarkThemeEnabledChanged: Core.settings.darkThemeEnabled ? Theme.name = "Lomiri.Components.Themes.SuruDark" : Theme.name = "Lomiri.Components.Themes.Ambiance"
    }

    AdaptivePageLayout {
        id: pageLayout
        anchors.fill: parent
        asynchronous: false
        primaryPage: MainPage {
            id: mainPage
        }

        Component.onCompleted: {
            Core.loadChords()
            Core.loadScales()

            // Show tuner if there are more than one column
            if (columns > 1) {
                Core.activateGuitarTuner()
                pageLayout.addPageToNextColumn(pageLayout.primaryPage, Qt.resolvedUrl("GuitarTunerPage.qml"))
            }
        }
    }

    function guitarStringToString(guitarString) {
        switch(guitarString) {
        case Music.GuitarStringE2:
            // TRANSLATORS: E2 guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("E");
        case Music.GuitarStringA:
            // TRANSLATORS: A guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("A");
        case Music.GuitarStringD:
            // TRANSLATORS: D guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("D");
        case Music.GuitarStringG:
            // TRANSLATORS: G guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("G");
        case Music.GuitarStringB:
            // TRANSLATORS: B guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("B");
        case Music.GuitarStringE4:
            // TRANSLATORS: E4 guitar string: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("E");
        }
    }

    function keyToString(key) {
        switch(key) {
        case Music.NoteKeyNone:
            return "";
        case Music.NoteKeyMinor:
            // TRANSLATORS: Type of the chord. See https://en.wikipedia.org/wiki/Major_and_minor
            return i18n.tr("minor");
        case Music.NoteKeyMajor:
            // TRANSLATORS: Type of the chord. See https://en.wikipedia.org/wiki/Major_and_minor
            return i18n.tr("major");
        }
    }

    function noteToString(note) {
        switch(note) {
        case Music.NoteC:
            // TRANSLATORS: C: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("C");
        case Music.NoteCSharp:
            // TRANSLATORS: C sharp: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("C#");
        case Music.NoteD:
            // TRANSLATORS: D: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("D");
        case Music.NoteDSharp:
            // TRANSLATORS: D sharp: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("D#");
        case Music.NoteE:
            // TRANSLATORS: E: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("E");
        case Music.NoteF:
            // TRANSLATORS: F: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("F");
        case Music.NoteFSharp:
            // TRANSLATORS: F sharp: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("F#");
        case Music.NoteG:
            // TRANSLATORS: G: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("G");
        case Music.NoteGSharp:
            // TRANSLATORS: G# Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("G#");
        case Music.NoteA:
            // TRANSLATORS: A: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("A");
        case Music.NoteASharp:
            // TRANSLATORS: A sharp: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return i18n.tr("A#");
        case Music.NoteB:
            // TRANSLATORS: B: Please check out https://en.wikipedia.org/wiki/Musical_note (12-tone chromatic scale) for the correct note name in your country.
            return  i18n.tr("B");
        case Music.NoteNone:
            return  "-";
        }
    }

}

