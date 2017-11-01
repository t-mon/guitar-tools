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

#include "sinewavegenerator.h"
#include "analyzer.h"

#include <QDebug>
#include <QtEndian>

AudioBuffer::AudioBuffer(QAudioFormat format, double frequency, QObject *parent):
    QIODevice(parent),
    m_format(format),
    m_frequency(frequency),
    m_phasePosition(0)
{

}

void AudioBuffer::start()
{
    m_phasePosition = 0;
    open(QIODevice::ReadOnly);
}

void AudioBuffer::stop()
{
    close();
}

void AudioBuffer::setFrequency(const double &frequency)
{
    m_phasePosition = 0;
    m_frequency = frequency;
}

qint64 AudioBuffer::readData(char *data, qint64 maxlen)
{
    int channelBytes = m_format.sampleSize() / 8;

    // Prepare buffer
    QByteArray buffer;
    buffer.resize(maxlen);
    unsigned char *ptr = reinterpret_cast<unsigned char *>(buffer.data());

    // Calculate sine values for maxlen (and phase position to get a continuous stream)
    for (int i = 0; i < maxlen; i += channelBytes){
        double phase = double(m_phasePosition % m_format.sampleRate()) / m_format.sampleRate();
        double value = sin(2 * M_PI * m_frequency * phase);
        // Scale amplitude
        qint16 valueInt = static_cast<qint16>(value * Analyzer::getPeakValue(m_format));
        qToLittleEndian<qint16>(valueInt, ptr);
        ptr += channelBytes;
        m_phasePosition++;
    }

    // Copy buffer data for AudioOutput
    memcpy(data, buffer.constData(), maxlen);
    return maxlen;
}

qint64 AudioBuffer::writeData(const char *data, qint64 maxlen)
{
    Q_UNUSED(data)
    return maxlen;
}





SineWaveGenerator::SineWaveGenerator(QObject *parent) :
    QObject(parent),
    m_frequency(440),
    m_running(false)
{
    m_format.setSampleRate(44100);
    m_format.setChannelCount(1);
    m_format.setSampleSize(16);
    m_format.setCodec("audio/pcm");
    m_format.setByteOrder(QAudioFormat::LittleEndian);
    m_format.setSampleType(QAudioFormat::SignedInt);

    m_buffer = new AudioBuffer(m_format, m_frequency, this);
    m_audioOutput = new QAudioOutput(m_format, this);

    connect(m_audioOutput, SIGNAL(stateChanged(QAudio::State)), this, SLOT(onAudioOutputStateChanged(QAudio::State)));
}

bool SineWaveGenerator::running() const
{
    return m_running;
}

double SineWaveGenerator::frequency() const
{
    return m_frequency;
}

void SineWaveGenerator::setFrequency(const double &frequency)
{
    m_frequency = frequency;
    m_buffer->setFrequency(frequency);
    emit frequencyChanged();
}

double SineWaveGenerator::volume() const
{
    return m_audioOutput->volume();
}

void SineWaveGenerator::setVolume(const double &volume)
{
    m_audioOutput->setVolume(volume);
    emit volumeChanged();
}

void SineWaveGenerator::play()
{
    qDebug() << "Start sine wave generator" << m_frequency << "Hz";
    m_buffer->start();
    m_audioOutput->start(m_buffer);
}

void SineWaveGenerator::stop()
{
    m_audioOutput->stop();
    m_buffer->stop();
}

void SineWaveGenerator::onAudioOutputStateChanged(const QAudio::State &state)
{
    switch (state) {
    case QAudio::ActiveState:
        qDebug() << "Tuning fork stream started";
        m_running = true;
        emit runningChanged();
        break;
    default:
        m_running = false;
        qDebug() << "Tuning fork stream stopped";
        emit runningChanged();
        break;
    }
}


