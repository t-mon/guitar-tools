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

#ifndef AUDIOINPUT_H
#define AUDIOINPUT_H

#include <QDebug>
#include <QObject>
#include <QPointer>
#include <QAudioInput>

class AudioInput : public QObject
{
    Q_OBJECT

public:
    explicit AudioInput(const QAudioFormat &inputFormat, QObject *parent = 0);

    void start(QIODevice *device);
    void stop();

    bool isRunning() const;

    QString inputDevice() const;
    void setInputDevices(const QString &inputDevice);

    Q_INVOKABLE void setMicrophoneVolume(const int &volume);

private:
    QAudioFormat m_inputFormat;
    QString m_inputDevice;
    double m_volume;
    bool m_isRunning;
    QPointer<QAudioInput> m_audioInput;
    QIODevice *m_device;

signals:
    void inputDeviceChanged();

private slots:
    void onAudioInputStateChanged(const QAudio::State &state);

};

#endif // AUDIOINPUT_H
