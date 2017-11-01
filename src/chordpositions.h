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

#ifndef CHORDPOSITIONS_H
#define CHORDPOSITIONS_H

#include <QObject>
#include <QAbstractListModel>

#include "chordposition.h"

class ChordPositions : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ChordPositionRole {
        ChordPositionRoleStringNumber,
        ChordPositionRoleFret,
        ChordPositionRoleFinger
    };

    ChordPositions(QObject *parent = 0);

    QList<ChordPosition *> chordPositions() const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    Q_INVOKABLE ChordPosition *get(const int &stringNumber);

    Q_INVOKABLE int count() const;

    void addChordPosition(ChordPosition *chordPosition);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<ChordPosition *> m_chordPositions;

};

#endif // CHORDPOSITIONS_H
