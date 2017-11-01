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

#include "scale.h"
#include "core.h"

#include <QDebug>

Scale::Scale(QObject *parent) :
    QObject(parent),
    m_note(Music::NoteNone),
    m_key(Music::NoteKeyNone),
    m_positions(NULL)
{

}

void Scale::fill()
{
    if (m_positions)
        delete m_positions;

    m_positions = new FretPositions(this);

    for (int string = 0; string < 6; string++) {
        for (int fret = 0; fret <= 12; fret++) {
            FretPosition *position = new FretPosition(m_positions);
            position->setGuitarString((Music::GuitarString)string);
            position->setFret(fret);
            position->setNote(Music::noteFromGuitarPosition(position->guitarString(), position->fret()));
            position->setNoteFileName(Core::getNoteFileName(position->guitarString(), position->fret()));
            m_positions->addFretPosition(position);
        }
    }
}

QString Scale::name() const
{
    return m_name;
}

void Scale::setName(const QString &name)
{
    m_name = name;
}

QString Scale::fullName() const
{
    return Music::noteToString(m_note) + m_name;
}

Music::Note Scale::note() const
{
    return m_note;
}

void Scale::setNote(const Music::Note &note)
{
    m_note = note;
}

Music::NoteKey Scale::key() const
{
    return m_key;
}

void Scale::setKey(const Music::NoteKey &key)
{
    m_key = key;
}

FretPositions *Scale::positions()
{
    return m_positions;
}

void Scale::setPositions(FretPositions *positions)
{
    m_positions = positions;
}

