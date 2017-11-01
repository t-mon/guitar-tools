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

#ifndef METRONOME_H
#define METRONOME_H

#include <QObject>
#include <QTimer>
#include <QSoundEffect>

class Metronome : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(int period READ period WRITE setPeriod NOTIFY periodChanged)
    Q_PROPERTY(int bpm READ bpm WRITE setBpm NOTIFY bpmChanged)
    Q_PROPERTY(QString tempoName READ tempoName NOTIFY tempoNameChanged)

public:
    explicit Metronome(QObject *parent = 0);

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();

    bool running() const;

    int bpm() const;
    void setBpm(const int &bpm);

    int period() const;
    void setPeriod(const int &period);

    QString tempoName() const;

private:
    QTimer *m_timer;
    QSoundEffect *m_tickEffect;
    QSoundEffect *m_tockEffect;

    bool m_running;
    bool m_tick;

    int m_bpm;
    int m_period;
    int m_tmpPeriod;
    QString m_tempoName;

    void setRunning(const bool &running);
    void setTempoName(const QString &tempoName);

public slots:
    void onTimeout();

signals:
    void tick();
    void tock();

    void bpmChanged();
    void periodChanged();
    void runningChanged();
    void tempoNameChanged();

};

#endif // METRONOME_H
