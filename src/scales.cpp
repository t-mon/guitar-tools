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

#include "scales.h"

#include <QDebug>

Scales::Scales(QObject *parent) :
    QAbstractListModel(parent)
{

}

QList<Scale *> Scales::scales()
{
    return m_scales;
}

int Scales::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_scales.count();
}

QVariant Scales::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_scales.count())
        return QVariant();

    Scale *scale = m_scales.at(index.row());
    if (role == ScaleRoleName) {
        return scale->name();
    } else if (role == ScaleRoleNote) {
        return scale->note();
    } else if (role == ScaleRoleKey) {
        return scale->key();
    }

    return QVariant();
}

int Scales::count() const
{
    return m_scales.count();
}

Scale *Scales::get(int index) const
{
    if (index >= m_scales.count() || index < 0)
        return NULL;

    return m_scales.at(index);
}

Scale *Scales::getScale(int note, QString name) const
{
    foreach (Scale *scale, m_scales) {
        if (scale->note() == (Music::Note)note && scale->name() == name) {
            return scale;
        }
    }
    return NULL;
}

QStringList Scales::getNames(int note) const
{
    QStringList names;
    foreach (Scale *scale, m_scales) {
        if (scale->note() == (Music::Note)note) {
            names.append(scale->name());
        }
    }
    return names;
}

void Scales::addScale(Scale *scale)
{
    beginInsertRows(QModelIndex(), m_scales.count(), m_scales.count());
    qDebug() << "Scales: loaded scale" << Music::noteToString(scale->note()) << scale->name();
    m_scales.append(scale);
    endInsertRows();
}

QHash<int, QByteArray> Scales::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ScaleRoleName] = "name";
    roles[ScaleRoleNote] = "note";
    roles[ScaleRoleKey] = "key";
    return roles;
}

