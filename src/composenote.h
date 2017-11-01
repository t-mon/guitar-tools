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

#ifndef COMPOSENOTE_H
#define COMPOSENOTE_H

#include <QObject>
#include <QString>
#include <QPoint>

#include "music.h"

class ComposeNote : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(Music::Note note READ note WRITE setNote NOTIFY noteChanged)
    Q_PROPERTY(QPoint coordinate READ coordinate WRITE setCoordinate NOTIFY coordinateChanged)

public:
    explicit ComposeNote(QObject *parent = 0);

    QString source() const;
    void setSource(const QString &source);

    Music::Note note() const;
    void setNote(const Music::Note &note);

    QPoint coordinate() const;
    void setCoordinate(const QPoint &coordinate);

private:
    QString m_source;
    Music::Note m_note;
    QPoint m_coordinate;

signals:
    void sourceChanged();
    void noteChanged();
    void coordinateChanged();

    void plucked();
    void removed();

};

#endif // COMPOSENOTE_H
