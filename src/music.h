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

#ifndef MUSIC_H
#define MUSIC_H

#include <QObject>

class Music
{
    Q_GADGET
    Q_ENUMS(Note)
    Q_ENUMS(NoteKey)
    Q_ENUMS(GuitarString)

public:
    enum Note {
        NoteNone = -1,
        NoteC = 0,
        NoteCSharp = 1,
        NoteD = 2,
        NoteDSharp = 3,
        NoteE = 4,
        NoteF = 5,
        NoteFSharp = 6,
        NoteG = 7,
        NoteGSharp = 8,
        NoteA = 9,
        NoteASharp = 10,
        NoteB = 11
    };

    enum NoteKey {
        NoteKeyNone,
        NoteKeyMinor,
        NoteKeyMajor
    };

    enum GuitarString {
        GuitarStringNone = -1,
        GuitarStringE2 = 0,
        GuitarStringA = 1,
        GuitarStringD = 2,
        GuitarStringG = 3,
        GuitarStringB = 4,
        GuitarStringE4 = 5
    };

    inline static QString noteToString(const Music::Note &note) {
        switch (note) {
        case Music::NoteNone:
            return "-";
            break;
        case Music::NoteC:
            return "C";
            break;
        case Music::NoteCSharp:
            return "C#";
            break;
        case Music::NoteD:
            return "D";
            break;
        case Music::NoteDSharp:
            return "D#";
            break;
        case Music::NoteE:
            return "E";
            break;
        case Music::NoteF:
            return "F";
            break;
        case Music::NoteFSharp:
            return "F#";
            break;
        case Music::NoteG:
            return "G";
            break;
        case Music::NoteGSharp:
            return "G#";
            break;
        case Music::NoteA:
            return "A";
            break;
        case Music::NoteASharp:
            return "A#";
            break;
        case Music::NoteB:
            return "B";
            break;
        default:
            return QString();
            break;
        }
    }

    inline static Music::GuitarString stringToGuitarString(const QString &string)
    {
        if (string == "E4") {
            return Music::GuitarStringE4;
        } else if (string == "B") {
            return Music::GuitarStringB;
        } else if (string == "G") {
            return Music::GuitarStringG;
        } else if (string == "D") {
            return Music::GuitarStringD;
        } else if (string == "A") {
            return Music::GuitarStringA;
        } else if (string == "E2") {
            return Music::GuitarStringE2;
        } else {
            return Music::GuitarStringNone;
        }
    }

    inline static Music::NoteKey stringToNoteKey(const QString &noteKey)
    {
        if (noteKey == "minor") {
            return Music::NoteKeyMinor;
        } else if (noteKey == "major") {
            return Music::NoteKeyMajor;
        } else{
            return Music::NoteKeyNone;
        }
    }

    inline static Music::Note stringToNote(const QString &noteName)
    {
        if (noteName == "A") {
            return Music::NoteA;
        } else if (noteName == "A#") {
            return Music::NoteASharp;
        } else if (noteName == "B") {
            return Music::NoteB;
        } else if (noteName == "C") {
            return Music::NoteC;
        } else if (noteName == "C#") {
            return Music::NoteCSharp;
        } else if (noteName == "D") {
            return Music::NoteD;
        } else if (noteName == "D#") {
            return Music::NoteDSharp;
        } else if (noteName == "E") {
            return Music::NoteE;
        } else if (noteName == "F") {
            return Music::NoteF;
        } else if (noteName == "F#") {
            return Music::NoteFSharp;
        } else if (noteName == "G") {
            return Music::NoteG;
        } else if (noteName == "G#") {
            return Music::NoteGSharp;
        } else {
            return Music::NoteNone;
        }
    }

    inline static Music::Note noteFromGuitarPosition(const Music::GuitarString &guitarString, const int &fretNumber)
    {
        switch (guitarString) {
        case GuitarStringE2: {
            switch (fretNumber) {
            case 0:
                return NoteE;
                break;
            case 1:
                return NoteF;
                break;
            case 2:
                return NoteFSharp;
                break;
            case 3:
                return NoteG;
                break;
            case 4:
                return NoteGSharp;
                break;
            case 5:
                return NoteA;
                break;
            case 6:
                return NoteASharp;
                break;
            case 7:
                return NoteB;
                break;
            case 8:
                return NoteC;
                break;
            case 9:
                return NoteCSharp;
                break;
            case 10:
                return NoteD;
                break;
            case 11:
                return NoteDSharp;
                break;
            case 12:
                return NoteE;
                break;
            default:
                return NoteNone;
                break;
            }
            break;
        }
        case GuitarStringA: {
            switch (fretNumber) {
            case 0:
                return NoteA;
                break;
            case 1:
                return NoteASharp;
                break;
            case 2:
                return NoteB;
                break;
            case 3:
                return NoteC;
                break;
            case 4:
                return NoteCSharp;
                break;
            case 5:
                return NoteD;
                break;
            case 6:
                return NoteDSharp;
                break;
            case 7:
                return NoteE;
                break;
            case 8:
                return NoteF;
                break;
            case 9:
                return NoteFSharp;
                break;
            case 10:
                return NoteG;
                break;
            case 11:
                return NoteGSharp;
                break;
            case 12:
                return NoteA;
                break;
            default:
                return NoteNone;
                break;
            }
            break;
        }
        case GuitarStringD: {
            switch (fretNumber) {
            case 0:
                return NoteD;
                break;
            case 1:
                return NoteDSharp;
                break;
            case 2:
                return NoteE;
                break;
            case 3:
                return NoteF;
                break;
            case 4:
                return NoteFSharp;
                break;
            case 5:
                return NoteG;
                break;
            case 6:
                return NoteGSharp;
                break;
            case 7:
                return NoteA;
                break;
            case 8:
                return NoteASharp;
                break;
            case 9:
                return NoteB;
                break;
            case 10:
                return NoteC;
                break;
            case 11:
                return NoteCSharp;
                break;
            case 12:
                return NoteD;
                break;
            default:
                return NoteNone;
                break;
            }
            break;
        }
        case GuitarStringG: {
            switch (fretNumber) {
            case 0:
                return NoteG;
                break;
            case 1:
                return NoteGSharp;
                break;
            case 2:
                return NoteA;
                break;
            case 3:
                return NoteASharp;
                break;
            case 4:
                return NoteB;
                break;
            case 5:
                return NoteC;
                break;
            case 6:
                return NoteCSharp;
                break;
            case 7:
                return NoteD;
                break;
            case 8:
                return NoteDSharp;
                break;
            case 9:
                return NoteE;
                break;
            case 10:
                return NoteF;
                break;
            case 11:
                return NoteFSharp;
                break;
            case 12:
                return NoteG;
                break;
            default:
                return NoteNone;
                break;
            }
            break;
        }
        case GuitarStringB: {
            switch (fretNumber) {
            case 0:
                return NoteB;
                break;
            case 1:
                return NoteC;
                break;
            case 2:
                return NoteCSharp;
                break;
            case 3:
                return NoteD;
                break;
            case 4:
                return NoteDSharp;
                break;
            case 5:
                return NoteE;
                break;
            case 6:
                return NoteF;
                break;
            case 7:
                return NoteFSharp;
                break;
            case 8:
                return NoteG;
                break;
            case 9:
                return NoteGSharp;
                break;
            case 10:
                return NoteA;
                break;
            case 11:
                return NoteASharp;
                break;
            case 12:
                return NoteB;
                break;
            default:
                return NoteNone;
                break;
            }
            break;
        }
        case GuitarStringE4: {
            switch (fretNumber) {
            case 0:
                return NoteE;
                break;
            case 1:
                return NoteF;
                break;
            case 2:
                return NoteFSharp;
                break;
            case 3:
                return NoteG;
                break;
            case 4:
                return NoteGSharp;
                break;
            case 5:
                return NoteA;
                break;
            case 6:
                return NoteASharp;
                break;
            case 7:
                return NoteB;
                break;
            case 8:
                return NoteC;
                break;
            case 9:
                return NoteCSharp;
                break;
            case 10:
                return NoteD;
                break;
            case 11:
                return NoteDSharp;
                break;
            case 12:
                return NoteE;
                break;
            default:
                return NoteNone;
                break;
            }
        }
        default:
            return NoteNone;
            break;
        }
    }
};

Q_DECLARE_METATYPE(Music)

#endif // MUSIC_H
