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

#include "chordposition.h"

ChordPosition::ChordPosition(QObject *parent):
    QObject(parent),
    m_guitarString(Music::GuitarStringNone),
    m_fret(0),
    m_finger(0)
{

}

Music::GuitarString ChordPosition::guitarString() const
{
    return m_guitarString;
}

void ChordPosition::setGuitarString(const Music::GuitarString &guitarString)
{
    m_guitarString = guitarString;
}

int ChordPosition::guitarStringNumber() const
{
    return (int)m_guitarString;
}

int ChordPosition::fret() const
{
    return m_fret;
}

void ChordPosition::setFret(const int &fret)
{
    m_fret = fret;
}

int ChordPosition::finger() const
{
    return m_finger;
}

void ChordPosition::setFinger(const int &finger)
{
    m_finger = finger;
}

