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

#ifndef SCALES_H
#define SCALES_H

#include <QObject>
#include <QAbstractListModel>

#include "scale.h"

class Scales : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ScaleRole {
        ScaleRoleName = Qt::DisplayRole,
        ScaleRoleNote,
        ScaleRoleKey
    };

    explicit Scales(QObject *parent = 0);

    QList<Scale *> scales();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    Q_INVOKABLE int count() const;
    Q_INVOKABLE Scale *get(int index) const;
    Q_INVOKABLE Scale *getScale(int note, QString name) const;
    Q_INVOKABLE QStringList getNames(int note) const;

    Q_INVOKABLE void addScale(Scale *scale);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<Scale *> m_scales;

};

#endif // SCALES_H
