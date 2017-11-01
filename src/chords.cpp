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

#include "chords.h"

#include <QDebug>

Chords::Chords(QObject *parent) :
    QAbstractListModel(parent)
{
    m_emptyChord = new Chord(this);
    ChordPositions *emptyPositions = new ChordPositions(m_emptyChord);
    for(int i = 0; i < 6; i++) {
        ChordPosition *position = new ChordPosition(emptyPositions);
        position->setFinger(0);
        position->setFret(0);
        position->setGuitarString((Music::GuitarString)i);
        emptyPositions->addChordPosition(position);
    }
    m_emptyChord->setPositions(emptyPositions);
}

QList<Chord *> Chords::chords()
{
    return m_chords;
}

int Chords::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_chords.count();
}

QVariant Chords::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_chords.count())
         return QVariant();

     Chord *chord = m_chords.at(index.row());
     if (role == ChordRoleName) {
         return chord->name();
     } else if (role == ChordRoleNote) {
         return chord->note();
     } else if (role == ChordRoleKey) {
         return chord->key();
     } else if (role == ChordRoleFullName) {
         return chord->fullName();
     }

     return QVariant();
}

int Chords::count() const
{
    return m_chords.count();
}

Chord *Chords::get(int index) const
{
    if (index >= m_chords.count() || index < 0)
        return NULL;

    return m_chords.at(index);
}

Chord *Chords::getChord(int note, QString name) const
{
    foreach (Chord *chord, m_chords) {
        if (chord->note() == (Music::Note)note && chord->name() == name) {
            return chord;
        }
    }
    return NULL;
}

QStringList Chords::getNames(int note) const
{
    QStringList names;
    foreach (Chord *chord, m_chords) {
        if (chord->note() == (Music::Note)note) {
            names.append(chord->name());
        }
    }
    return names;
}

Chord *Chords::emptyChord() const
{
    return m_emptyChord;
}

void Chords::loadChord(Chord *chord)
{
    beginInsertRows(QModelIndex(), m_chords.count(), m_chords.count());
    qDebug() << "Chords: loaded chord" << Music::noteToString(chord->note()) << chord->name();
    m_chords.append(chord);
    endInsertRows();
}

void Chords::addChord(Chord *chord)
{
    if (m_chords.contains(chord))
        return;

    beginInsertRows(QModelIndex(), m_chords.count(), m_chords.count());
    qDebug() << "Chords: loaded chord" << Music::noteToString(chord->note()) << chord->name();
    m_chords.append(chord);
    endInsertRows();

    emit updated();
}

void Chords::removeChord(Chord *chord)
{
    int index = m_chords.indexOf(chord);
    if (index < 0)
        return;

    beginRemoveRows(QModelIndex(), index, index);
    qDebug() << "Chords: remove chord" << index << chord->fullName();
    m_chords.removeAt(index);
    endRemoveRows();

    emit updated();
}

void Chords::move(int oldIndex, int newIndex)
{
    // Make sure its not moved outside the lists
    if (newIndex < 0)
        newIndex = 0;

    if (newIndex >= m_chords.count())
        newIndex = m_chords.count() - 1;


    // Nothing to do?
    if (oldIndex == newIndex)
        return;

    int newModelIndex = newIndex > oldIndex ? newIndex + 1 : newIndex;

    qDebug() << "Chords: move chord" << oldIndex << "-->" << newIndex;
    emit updated();

    beginMoveRows(QModelIndex(), oldIndex, oldIndex, QModelIndex(), newModelIndex);
    m_chords.move(oldIndex, newIndex);
    endMoveRows();
}

void Chords::clearModel()
{
    beginResetModel();
    m_chords.clear();
    endResetModel();
}

QHash<int, QByteArray> Chords::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ChordRoleName] = "name";
    roles[ChordRoleNote] = "note";
    roles[ChordRoleKey] = "key";
    roles[ChordRoleFullName] = "fullName";
    return roles;
}

