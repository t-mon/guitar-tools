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

#include "audioinput.h"

AudioInput::AudioInput(const QAudioFormat &inputFormat, QObject *parent) :
    QObject(parent),
    m_inputFormat(inputFormat),
    m_isRunning(false)
{
    m_audioInput = new QAudioInput(inputFormat, this);
}

void AudioInput::start(QIODevice *device)
{
    qDebug() << "Start audio input";
    m_device = device;
    m_audioInput->start(device);
}

void AudioInput::stop()
{
    m_audioInput->stop();
}

bool AudioInput::isRunning() const
{
    return m_isRunning;
}

QString AudioInput::inputDevice() const
{
    return m_inputDevice;
}

void AudioInput::setInputDevices(const QString &inputDevice)
{
    // stop if running
    if (m_audioInput) {
        QAudio::State currentState = m_audioInput->state();
        if (currentState == QAudio::ActiveState)
            stop();
    }

    // Get the audiodevice with the given name
    QAudioDeviceInfo audioDeviceInfo;
    foreach (const QAudioDeviceInfo &deviceInfo, QAudioDeviceInfo::availableDevices(QAudio::AudioInput)) {
        if (inputDevice == deviceInfo.deviceName()) {
            qDebug() << "Change AudioInput device to" << deviceInfo.deviceName();
            audioDeviceInfo = deviceInfo;
            break;
        }
    }

    // Use default if not found
    if (audioDeviceInfo.isNull()) {
        qWarning() << "AudioInput device" << inputDevice << "could not be found";
        audioDeviceInfo = QAudioDeviceInfo::defaultInputDevice();
        qDebug() << "Using default audio input device" << audioDeviceInfo.deviceName();
        m_inputDevice = audioDeviceInfo.deviceName();
        emit inputDeviceChanged();
    }

    // delete if we already have an audio input
    if (m_audioInput)
        delete m_audioInput;

    m_audioInput = new QAudioInput(audioDeviceInfo, m_inputFormat, this);
    connect(m_audioInput, SIGNAL(stateChanged(QAudio::State)), this, SLOT(onAudioInputStateChanged(QAudio::State)));
}

void AudioInput::setMicrophoneVolume(const int &volume)
{
    m_volume = volume / 100.0;
    qDebug() << "AudioInput: Volume" << m_volume;
    m_audioInput->setVolume(m_volume);
}

void AudioInput::onAudioInputStateChanged(const QAudio::State &state)
{
    switch (state) {
    case QAudio::StoppedState:
        if (m_audioInput->error() != QAudio::NoError) {
            qWarning() << "AudioInput: error" << m_audioInput->error();
        }
        m_isRunning = false;
        qDebug() << "AudioInput: Stopped recording";
        break;
    case QAudio::ActiveState:
        qDebug() << "AudioInput: Started recording";
        m_isRunning = true;
        break;
    default:
        break;
    }
}

