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

#ifndef COMPOSENOTES_H
#define COMPOSENOTES_H

#include <QObject>
#include <QAbstractListModel>

#include "composenote.h"

class ComposeNotes : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ComposeNoteRole {
        ComposeNoteRoleSource,
        ComposeNoteRoleNote,
        ComposeNoteRoleCoordinate
    };

    explicit ComposeNotes(QObject *parent = 0);

    QList<ComposeNote *> composeNotes() const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    // Note: grid index != model index
    Q_INVOKABLE ComposeNote *get(const QPoint &coordinate);

    Q_INVOKABLE int count() const;

    void addComposeNote(ComposeNote *note);
    void removeComposeNote(const QPoint &coordinate);
    void move(const QPoint &oldCoordinate, const QPoint &newCoordinate);
    void clearModel();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<ComposeNote *> m_notes;

};

#endif // COMPOSENOTES_H
