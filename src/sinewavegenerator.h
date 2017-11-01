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

#ifndef SINEWAVEGENERATOR_H
#define SINEWAVEGENERATOR_H

#include <QObject>
#include <QAudioOutput>
#include <QIODevice>

class AudioBuffer: public QIODevice
{
    Q_OBJECT
public:
    explicit AudioBuffer(QAudioFormat format, double frequency, QObject *parent = 0);

    void start();
    void stop();

    void setFrequency(const double &frequency);

    qint64 readData(char *data, qint64 maxlen);
    qint64 writeData(const char *data, qint64 maxlen);

private:
    QAudioFormat m_format;
    double m_frequency;
    qint64 m_phasePosition;

};

class SineWaveGenerator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double frequency READ frequency WRITE setFrequency NOTIFY frequencyChanged)
    Q_PROPERTY(double volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)

public:
    explicit SineWaveGenerator(QObject *parent = 0);

    bool running() const;

    double frequency() const;
    void setFrequency(const double &frequency);

    double volume() const;
    void setVolume(const double &volume);

    Q_INVOKABLE void play();
    Q_INVOKABLE void stop();

private:
    QAudioFormat m_format;
    AudioBuffer *m_buffer;
    QAudioOutput *m_audioOutput;

    double m_frequency;
    bool m_running;

signals:
    void frequencyChanged();
    void volumeChanged();
    void runningChanged();

private slots:
    void onAudioOutputStateChanged(const QAudio::State &state);

};



#endif // SINEWAVEGENERATOR_H
