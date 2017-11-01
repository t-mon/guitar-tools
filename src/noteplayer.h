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

#ifndef NOTEPLAYER_H
#define NOTEPLAYER_H

#include <QObject>
#include <QSoundEffect>

#include "fretposition.h"

class NotePlayer : public QObject
{
    Q_OBJECT
public:
    explicit NotePlayer(qreal volume, QObject *parent = 0);
    ~NotePlayer();

    Q_INVOKABLE void play(const QString &source);

    void setVolume(const qreal &volume);

private:
    qreal m_volume;
    QList<QSoundEffect *> m_runningEffects;

private slots:
    void onPlayingChanged();

};

#endif // NOTEPLAYER_H
