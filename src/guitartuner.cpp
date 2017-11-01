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

#include "guitartuner.h"

GuitarTuner::GuitarTuner(QObject *parent) :
    QObject(parent),
    m_note(Music::NoteNone),
    m_pitchStandard(400),
    m_centValue(0),
    m_frequency(440)
{
    QAudioFormat inputFormat;
    inputFormat.setSampleRate(8000);
    inputFormat.setCodec("audio/pcm");
    inputFormat.setSampleSize(16);
    inputFormat.setChannelCount(1);
    inputFormat.setByteOrder(QAudioFormat::LittleEndian);
    inputFormat.setSampleType(QAudioFormat::SignedInt);

    m_audioInput = new AudioInput(inputFormat, this);
    m_analyzer = new Analyzer(inputFormat, this);

    connect(m_analyzer, SIGNAL(volumeLevelChanged()), this, SIGNAL(volumeLevelChanged()));
    connect(m_analyzer, SIGNAL(frequencyChanged(double)), this, SLOT(setFrequency(double)));
    connect(m_analyzer, SIGNAL(targetFrequencyChanged(double)), this, SLOT(setTargetFrequency(double)));
    connect(m_analyzer, SIGNAL(centValueChanged(double)), this, SLOT(setCentValue(double)));
    connect(m_analyzer, SIGNAL(noteChanged(Music::Note)), this, SLOT(setNote(Music::Note)));
}

double GuitarTuner::frequency() const
{
    return m_frequency;
}

double GuitarTuner::targetFrequency() const
{
    return m_targetFrequency;
}

double GuitarTuner::centValue() const
{
    return m_centValue;
}

double GuitarTuner::volumeLevel() const
{
    return m_analyzer->volumeLevel();
}

Music::Note GuitarTuner::note() const
{
    return m_note;
}

bool GuitarTuner::sound() const
{
    return m_sound;
}

bool GuitarTuner::correctFrequency() const
{
    return false;
}

int GuitarTuner::pitchStandard() const
{
    return m_pitchStandard;
}

void GuitarTuner::setPitchStandard(const int &pitchStandard)
{
    m_pitchStandard = pitchStandard;
    m_analyzer->setPitchStandard(pitchStandard);
    emit pitchStandardChanged();
}

void GuitarTuner::enable()
{
    if (!m_audioInput->isRunning()) {
        qDebug() << "GuitarTuner: Enabled";
        m_analyzer->start();
        m_audioInput->start(m_analyzer);
    }
}

void GuitarTuner::disable()
{
    if (m_audioInput->isRunning()) {
        qDebug() << "GuitarTuner: Disabled";
        m_audioInput->stop();
        m_analyzer->stop();
    }
}

void GuitarTuner::onSoundChanged(const bool &sound)
{
    if (m_sound != sound) {
        qDebug() << "GuitarTuner: Sound changed" << sound;
        m_sound = sound;
        emit soundChanged();
    }
}

void GuitarTuner::setCentValue(const double &centValue)
{
    if (centValue <= -50) {
        m_centValue = -50;
    } else if(centValue >= 50) {
        m_centValue = 50;
    } else {
        m_centValue = centValue;
    }

    emit centValueChanged();
}

void GuitarTuner::setFrequency(const double &frequency)
{
    m_frequency = frequency;
    emit frequencyChanged();
}

void GuitarTuner::setTargetFrequency(const double &frequency)
{
    m_targetFrequency = frequency;
    emit targetFrequencyChanged();
}

void GuitarTuner::setNote(const Music::Note &note)
{
    m_note = note;
    emit noteChanged();
}

void GuitarTuner::setMicrophoneVolume(const double &volume)
{
    m_audioInput->setMicrophoneVolume(volume);
}

void GuitarTuner::setInputDevice(const QString &inputDevice)
{
    m_audioInput->setInputDevices(inputDevice);
}
