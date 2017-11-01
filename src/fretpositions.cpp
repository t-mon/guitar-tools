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

#include "fretpositions.h"

FretPositions::FretPositions(QObject *parent) :
    QAbstractListModel(parent)
{

}

QList<FretPosition *> FretPositions::fretPositions() const
{
    return m_fretPositions;
}

int FretPositions::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_fretPositions.count();
}

QVariant FretPositions::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_fretPositions.count())
         return QVariant();

     FretPosition *position = m_fretPositions.at(index.row());
     if (role == FretPositionRoleStringNumber) {
         return position->guitarStringNumber();
     } else if (role == FretPositionRoleFret) {
         return position->fret();
     } else if (role == FretPositionRoleNote) {
         return (int)position->note();
     }

     return QVariant();
}

int FretPositions::count() const
{
    return m_fretPositions.count();
}

FretPosition *FretPositions::get(int index)
{
    if (index >= m_fretPositions.count() || index < 0)
        return NULL;

    return m_fretPositions.at(index);
}

void FretPositions::addFretPosition(FretPosition *fretPosition)
{
    beginInsertRows(QModelIndex(), m_fretPositions.count(), m_fretPositions.count());
    m_fretPositions.append(fretPosition);
    endInsertRows();
}

QHash<int, QByteArray> FretPositions::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FretPositionRoleNote] = "note";
    roles[FretPositionRoleFret] = "fret";
    roles[FretPositionRoleStringNumber] = "guitarStringNumber";
    return roles;
}

