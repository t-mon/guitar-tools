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

#include "chordpositions.h"

#include <QDebug>

ChordPositions::ChordPositions(QObject *parent) :
    QAbstractListModel(parent)
{
}

QList<ChordPosition *> ChordPositions::chordPositions() const
{
    return m_chordPositions;
}

int ChordPositions::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_chordPositions.count();
}

QVariant ChordPositions::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_chordPositions.count())
         return QVariant();

     ChordPosition *position = m_chordPositions.at(index.row());
     if (role == ChordPositionRoleStringNumber) {
         return position->guitarStringNumber();
     } else if (role == ChordPositionRoleFret) {
         return position->fret();
     } else if (role == ChordPositionRoleFinger) {
         return position->finger();
     }

     return QVariant();
}

ChordPosition *ChordPositions::get(const int &stringNumber)
{
    foreach (ChordPosition *position, m_chordPositions) {
        if (position->guitarStringNumber() == stringNumber)
            return position;
    }

    return NULL;
}

int ChordPositions::count() const
{
    return m_chordPositions.count();
}

void ChordPositions::addChordPosition(ChordPosition *chordPosition)
{
    beginInsertRows(QModelIndex(), m_chordPositions.count(), m_chordPositions.count());
    m_chordPositions.append(chordPosition);
    endInsertRows();
}

QHash<int, QByteArray> ChordPositions::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ChordPositionRoleStringNumber] = "guitarStringNumber";
    roles[ChordPositionRoleFret] = "fret";
    roles[ChordPositionRoleFinger] = "finger";
    return roles;
}

