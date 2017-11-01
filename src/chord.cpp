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

#include "chord.h"

#include <QDebug>

Chord::Chord(QObject *parent) :
    QObject(parent),
    m_name("-"),
    m_note(Music::NoteNone),
    m_key(Music::NoteKeyNone),
    m_barre(false),
    m_barreFinger(0),
    m_barreStringMin(0),
    m_barreStringMax(0)
{

}

QString Chord::name() const
{
    return m_name;
}

void Chord::setName(const QString &name)
{
    m_name = name;
}

QString Chord::fullName() const
{
    return Music::noteToString(m_note) + m_name;
}

Music::Note Chord::note() const
{
    return m_note;
}

void Chord::setNote(const Music::Note &note)
{
    m_note = note;
}

Music::NoteKey Chord::key() const
{
    return m_key;
}

void Chord::setKey(const Music::NoteKey &key)
{
    m_key = key;
}

int Chord::startFret() const
{
    return m_startFret;
}

void Chord::setStartFret(const int &startFret)
{
    m_startFret = startFret;
}

bool Chord::barre() const
{
    return m_barre;
}

int Chord::barreFinger() const
{
    return m_barreFinger;
}

int Chord::barreFret() const
{
    return m_barreFret;
}

int Chord::barreStringMin() const
{
    return m_barreStringMin;
}

int Chord::barreStringMax() const
{
    return m_barreStringMax;
}

ChordPositions *Chord::positions()
{
    return m_positions;
}

void Chord::setPositions(ChordPositions *positions)
{
    m_positions = positions;

    QHash<int, int> fingerHash;
    fingerHash.insert(1,0);
    fingerHash.insert(2,0);
    fingerHash.insert(3,0);
    fingerHash.insert(4,0);

    // Check barre
    foreach (ChordPosition *position, m_positions->chordPositions()) {
        if (position->finger() > 0)
            fingerHash[position->finger()] += 1;
    }

    // Get baret finger and count
    m_barreFinger = 0;
    int barreFingerCount = 0;

    foreach (const int &barreFinger, fingerHash.keys()) {
        if (fingerHash.value(barreFinger) > barreFingerCount) {
            m_barreFinger = barreFinger;
            barreFingerCount = fingerHash.value(barreFinger);
        }
    }

    if (barreFingerCount <= 1)
        return;

    // This is a barre chord
    m_barre = true;

    // Get the min/max position for UI
    m_barreStringMin = 5;
    m_barreStringMax = 0;
    m_barreFret = 0;
    foreach (ChordPosition *position, m_positions->chordPositions()) {
        if (position->finger() == m_barreFinger) {
            // TODO: check if this is realy a barre (all positions on the same fret)
            m_barreFret = position->fret();
            if (m_barreStringMin >= position->guitarStringNumber()) {
                m_barreStringMin = position->guitarStringNumber();
            }
            if (m_barreStringMax <= position->guitarStringNumber()) {
                m_barreStringMax = position->guitarStringNumber();
            }
        }
    }
}



QDebug operator<<(QDebug dbg, Chord *chord)
{
    return dbg.nospace() << "Chord(" << Music::noteToString(chord->note()) << " | " << chord->name() << ") ";
}
