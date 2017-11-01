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

#ifndef CHORD_H
#define CHORD_H

#include <QObject>
#include <QQmlListProperty>

#include "music.h"
#include "chordpositions.h"

class Chord : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(Music::Note note READ note CONSTANT)
    Q_PROPERTY(Music::NoteKey key READ key CONSTANT)
    Q_PROPERTY(ChordPositions *positions READ positions CONSTANT)
    Q_PROPERTY(QString fullName READ fullName CONSTANT)
    Q_PROPERTY(int startFret READ startFret CONSTANT)

    // Barre members
    Q_PROPERTY(bool barre READ barre CONSTANT)
    Q_PROPERTY(int barreFinger READ barreFinger CONSTANT)
    Q_PROPERTY(int barreFret READ barreFret CONSTANT)
    Q_PROPERTY(int barreStringMin READ barreStringMin CONSTANT)
    Q_PROPERTY(int barreStringMax READ barreStringMax CONSTANT)

public:
    Chord(QObject *parent = 0);

    QString name() const;
    void setName(const QString &name);

    QString fullName() const;

    Music::Note note() const;
    void setNote(const Music::Note &note);

    Music::NoteKey key() const;
    void setKey(const Music::NoteKey &key);

    int startFret() const;
    void setStartFret(const int &startFret);

    // Barre methods
    bool barre() const;
    int barreFinger() const;
    int barreFret() const;
    int barreStringMin() const;
    int barreStringMax() const;

    ChordPositions *positions();
    void setPositions(ChordPositions *positions);

private:
    QString m_name;
    Music::Note m_note;
    Music::NoteKey m_key;
    ChordPositions *m_positions;
    int m_startFret;

    // Barre members
    bool m_barre;
    int m_barreFinger;
    int m_barreFret;
    int m_barreStringMin;
    int m_barreStringMax;

};

QDebug operator<<(QDebug dbg, Chord *chord);

#endif // CHORD_H
