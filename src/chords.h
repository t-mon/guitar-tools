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

#ifndef CHORDS_H
#define CHORDS_H

#include <QObject>
#include <QAbstractListModel>

#include "chord.h"

class Chords : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ChordRole {
        ChordRoleName = Qt::DisplayRole,
        ChordRoleNote,
        ChordRoleKey,
        ChordRoleFullName
    };

    Chords(QObject *parent = 0);

    QList<Chord *> chords();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    Q_INVOKABLE int count() const;
    Q_INVOKABLE Chord *get(int index) const;
    Q_INVOKABLE Chord *getChord(int note, QString name) const;
    Q_INVOKABLE QStringList getNames(int note) const;

    Q_INVOKABLE Chord *emptyChord() const;

    Q_INVOKABLE void loadChord(Chord *chord);
    Q_INVOKABLE void addChord(Chord *chord);
    Q_INVOKABLE void removeChord(Chord *chord);
    Q_INVOKABLE void move(int oldIndex, int newIndex);
    Q_INVOKABLE void clearModel();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<Chord *> m_chords;
    Chord *m_emptyChord;

signals:
    void updated();

};

#endif // CHORDS_H
