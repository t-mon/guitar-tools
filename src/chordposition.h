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

#ifndef CHORDPOSITION_H
#define CHORDPOSITION_H


#include <QObject>

#include "music.h"

class ChordPosition : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Music::GuitarString guitarString READ guitarString CONSTANT)
    Q_PROPERTY(int guitarStringNumber READ guitarStringNumber CONSTANT)
    Q_PROPERTY(int fret READ fret CONSTANT)
    Q_PROPERTY(int finger READ finger CONSTANT)

public:
    ChordPosition(QObject *parent = 0);

    Music::GuitarString guitarString() const;
    void setGuitarString(const Music::GuitarString &guitarString);

    int fret() const;
    void setFret(const int &fret);

    int finger() const;
    void setFinger(const int &finger);

    int guitarStringNumber() const;

private:
    Music::GuitarString m_guitarString;
    int m_fret;
    int m_finger;

};

#endif // CHORDPOSITION_H
