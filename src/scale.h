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

#ifndef SCALE_H
#define SCALE_H

#include <QObject>

#include "music.h"
#include "fretpositions.h"

class Scale : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(Music::Note note READ note CONSTANT)
    Q_PROPERTY(Music::NoteKey key READ key CONSTANT)
    Q_PROPERTY(FretPositions *positions READ positions CONSTANT)

public:
    explicit Scale(QObject *parent = 0);

    void fill();

    QString name() const;
    void setName(const QString &name);

   Q_INVOKABLE QString fullName() const;

    Music::Note note() const;
    void setNote(const Music::Note &note);

    Music::NoteKey key() const;
    void setKey(const Music::NoteKey &key);

    FretPositions *positions();
    void setPositions(FretPositions *positions);

private:
    QString m_name;
    Music::Note m_note;
    Music::NoteKey m_key;
    FretPositions *m_positions;

};

#endif // SCALE_H
