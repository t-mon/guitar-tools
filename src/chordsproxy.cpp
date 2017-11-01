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

#include "chordsproxy.h"

ChordsProxy::ChordsProxy(QObject *parent):
    QSortFilterProxyModel(parent),
    m_noteFilter(Music::NoteNone)
{

}

Chords *ChordsProxy::chords()
{
    return m_chords;
}

void ChordsProxy::setChords(Chords *chords)
{
    m_chords = chords;
    setSourceModel(chords);
    sort(0);
    emit chordsChanged();

}

void ChordsProxy::setFilter(const int &note)
{
    m_noteFilter = (Music::Note)note;
    invalidateFilter();
    sort(0);
}

void ChordsProxy::resetFilter()
{
    m_noteFilter = Music::NoteNone;
}

bool ChordsProxy::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    Q_UNUSED(sourceParent)
    Chord *chord = m_chords->get(sourceRow);
    if (chord->note() == m_noteFilter)
        return true;

    return false;
}

bool ChordsProxy::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    QVariant leftName = sourceModel()->data(left);
    QVariant rightName = sourceModel()->data(right);

    return QString::localeAwareCompare(leftName.toString(), rightName.toString()) < 0;
}

