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

#include "composenotes.h"

#include <QDebug>

ComposeNotes::ComposeNotes(QObject *parent) :
    QAbstractListModel(parent)
{

}

QList<ComposeNote *> ComposeNotes::composeNotes() const
{
    return m_notes;
}

int ComposeNotes::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_notes.count();
}

QVariant ComposeNotes::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_notes.count())
         return QVariant();

     ComposeNote *note = m_notes.at(index.row());
     if (role == ComposeNoteRoleSource) {
         return note->source();
     } else if (role == ComposeNoteRoleNote) {
         return note->note();
     } else if (role == ComposeNoteRoleCoordinate) {
         return note->coordinate();
     }

     return QVariant();
}

ComposeNote *ComposeNotes::get(const QPoint &coordinate)
{
    foreach (ComposeNote *note, m_notes) {
        if (note->coordinate() == coordinate)
            return note;
    }

    return NULL;
}

int ComposeNotes::count() const
{
    return m_notes.count();
}

void ComposeNotes::addComposeNote(ComposeNote *note)
{
    beginInsertRows(QModelIndex(), m_notes.count(), m_notes.count());
    m_notes.append(note);
    qDebug() << "ComposeNote: add note" << Music::noteToString(note->note()) << note->coordinate();
    endInsertRows();
}

void ComposeNotes::removeComposeNote(const QPoint &coordinate)
{
    ComposeNote *note = get(coordinate);
    if (!note)
        return;

    int modelIndex = m_notes.indexOf(note);
    if (modelIndex < 0)
        return;

    beginRemoveRows(QModelIndex(), modelIndex, modelIndex);
    qDebug() << "ComposeNote: remove note" << Music::noteToString(note->note()) << note->coordinate();
    m_notes.removeAt(modelIndex);
    note->deleteLater();
    endRemoveRows();
}

void ComposeNotes::move(const QPoint &oldCoordinate, const QPoint &newCoordinate)
{
    // Nothing to do?
    if (oldCoordinate == newCoordinate)
        return;

    qDebug() << "ComposeNote: move chord" << oldCoordinate << "-->" << newCoordinate;
    foreach (ComposeNote *composeNote, m_notes) {
        if (composeNote->coordinate() == oldCoordinate) {
            composeNote->setCoordinate(newCoordinate);
            QModelIndex modelIndex = this->index(m_notes.indexOf(composeNote));
            emit dataChanged(modelIndex, modelIndex, QVector<int>() << ComposeNoteRoleCoordinate);
        }
    }
}

void ComposeNotes::clearModel()
{
    qDebug() << "Reset model";
    beginResetModel();
    foreach (ComposeNote *note, m_notes) {
        delete note;
    }

    m_notes.clear();
    endResetModel();
}


QHash<int, QByteArray> ComposeNotes::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ComposeNoteRoleSource] = "source";
    roles[ComposeNoteRoleNote] = "note";
    roles[ComposeNoteRoleCoordinate] = "coordinate";
    return roles;
}
