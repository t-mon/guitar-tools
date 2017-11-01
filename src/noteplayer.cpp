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

#include "noteplayer.h"

#include <QPointer>

NotePlayer::NotePlayer(qreal volume, QObject *parent) :
    QObject(parent),
    m_volume(volume)
{

}

NotePlayer::~NotePlayer()
{
    qDeleteAll(m_runningEffects);
}

void NotePlayer::play(const QString &source)
{
    // Remove the oldest soundeffect if more than 18 runing (3 fast strikes on guitar)
    if (m_runningEffects.count() > 18) {
        QSoundEffect *effect = m_runningEffects.takeFirst();
        effect->stop();
    }

    QSoundEffect *effect = new QSoundEffect(this);
    effect->setSource(QUrl(source));
    effect->setVolume(m_volume / 100.0);
    effect->setLoopCount(1);
    connect(effect, SIGNAL(playingChanged()), this, SLOT(onPlayingChanged()));

    effect->play();
    m_runningEffects.append(effect);
}

void NotePlayer::setVolume(const qreal &volume)
{
    m_volume = volume;
}

void NotePlayer::onPlayingChanged()
{
    QPointer<QSoundEffect> effect = static_cast<QSoundEffect *>(sender());
    if (!effect.isNull() && !effect->isPlaying()) {
        m_runningEffects.removeOne(effect);
        effect->deleteLater();
    }
}


