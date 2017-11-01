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
import GuitarTools 1.0


Item {
    property string source
    function play() {
        Core.notePlayer.play(source)
    }
}

//Loader {
//    id: root
//    property string source
//    property int loops: 1

//    function loadSource(source) {
//        root.active = false;
//        root.source = source;
//        root.active = true;
//    }

//    function play() { root.item.play() }
//    function stop() { root.item.stop() }

//    sourceComponent: SoundEffect {
//        volume: Core.settings.guitarPlayerVolume / 100
//    }

//    Binding {
//        target: root.item
//        property: "source"
//        value: root.source
//    }
//}
