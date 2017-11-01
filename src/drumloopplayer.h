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

#ifndef DRUMLOOPPLAYER_H
#define DRUMLOOPPLAYER_H

#include <QObject>
#include <QSoundEffect>
#include <QFutureWatcher>

#include "SoundTouch.h"
#include "BPMDetect.h"
#include "wavfile.h"

using namespace soundtouch;

// Processing chunk size (size chosen to be divisible by 2, 4, 6, 8, 10, 12, 14, 16 channels ...)
#define BUFF_SIZE 6720

class DrumLoopPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool playing READ playing NOTIFY playingChanged)
    Q_PROPERTY(int bpm READ bpm WRITE setBpm NOTIFY bpmChanged)
    Q_PROPERTY(int minBpm READ minBpm NOTIFY minBpmChanged)
    Q_PROPERTY(int maxBpm READ maxBpm NOTIFY maxBpmChanged)

public:
    explicit DrumLoopPlayer(const double &volume, QObject *parent = 0);
    ~DrumLoopPlayer();

    bool playing() const;

    int bpm() const;
    void setBpm(const int &bpm);

    int originalBpm() const;
    int minBpm() const;
    int maxBpm() const;

    Q_INVOKABLE void play(const QString &filePath);
    Q_INVOKABLE void stop();

    double volume() const;
    void setVolume(const int &volume);

private:
    QSoundEffect *m_soundEffect;
    QString m_inputFileName;
    QString m_outputFileName;

    QFutureWatcher<void> *m_watcher;

    double m_volume;

    int m_bpm;
    int m_measuredBpm;
    bool m_fileChanged;

    void processFile();

signals:
    void playingChanged();
    void bpmChanged();
    void minBpmChanged();
    void maxBpmChanged();

private slots:
    void processFinished();

};

#endif // DRUMLOOPPLAYER_H
