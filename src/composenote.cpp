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

#include "composenote.h"

ComposeNote::ComposeNote(QObject *parent) : QObject(parent)
{

}

QString ComposeNote::source() const
{
    return m_source;
}

void ComposeNote::setSource(const QString &source)
{
    m_source = source;
    emit sourceChanged();
}

Music::Note ComposeNote::note() const
{
    return m_note;
}

void ComposeNote::setNote(const Music::Note &note)
{
    m_note = note;
    emit noteChanged();
}

QPoint ComposeNote::coordinate() const
{
    return m_coordinate;
}

void ComposeNote::setCoordinate(const QPoint &coordinate)
{
    m_coordinate = coordinate;
    emit coordinateChanged();
}
