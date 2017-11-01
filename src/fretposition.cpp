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

#include "fretposition.h"

FretPosition::FretPosition(QObject *parent) :
    QObject(parent)
{

}

Music::GuitarString FretPosition::guitarString() const
{
    return m_guitarString;
}

void FretPosition::setGuitarString(const Music::GuitarString &guitarString)
{
    m_guitarString = guitarString;
}

int FretPosition::fret() const
{
    return m_fret;
}

void FretPosition::setFret(const int &fret)
{
    m_fret = fret;
}

Music::Note FretPosition::note() const
{
    return m_note;
}

void FretPosition::setNote(const Music::Note &note)
{
    m_note = note;
}

QString FretPosition::noteFileName() const
{
    return m_noteFileName;
}

void FretPosition::setNoteFileName(const QString &noteFileName)
{
    m_noteFileName = noteFileName;
}

int FretPosition::guitarStringNumber() const
{
    return (int)m_guitarString;
}

