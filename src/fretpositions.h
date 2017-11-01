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

#ifndef FRETPOSITIONS_H
#define FRETPOSITIONS_H

#include <QObject>
#include <QAbstractListModel>

#include "fretposition.h"

class FretPositions : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit FretPositions(QObject *parent = 0);

    enum FretPositionRole {
        FretPositionRoleStringNumber,
        FretPositionRoleFret,
        FretPositionRoleNote
    };

    QList<FretPosition *> fretPositions() const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    Q_INVOKABLE int count() const;
    Q_INVOKABLE FretPosition *get(int index);

    void addFretPosition(FretPosition *fretPosition);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<FretPosition *> m_fretPositions;

};

#endif // FRETPOSITIONS_H
