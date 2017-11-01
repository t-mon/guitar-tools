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

#ifndef GUITARTUNER_H
#define GUITARTUNER_H

#include <QObject>
#include <QTimer>
#include <QFile>
#include <QAudioFormat>
#include <QAudioInput>
#include <QAudioDeviceInfo>
#include <QAudioRecorder>

#include "audioinput.h"
#include "analyzer.h"
#include "music.h"

class GuitarTuner : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double frequency READ frequency NOTIFY frequencyChanged)
    Q_PROPERTY(double targetFrequency READ targetFrequency NOTIFY targetFrequencyChanged)
    Q_PROPERTY(double centValue READ centValue NOTIFY centValueChanged)
    Q_PROPERTY(double volumeLevel READ volumeLevel NOTIFY volumeLevelChanged)
    Q_PROPERTY(Music::Note note READ note NOTIFY noteChanged)
    Q_PROPERTY(int pitchStandard READ pitchStandard WRITE setPitchStandard NOTIFY pitchStandardChanged)
    Q_PROPERTY(bool sound READ sound NOTIFY soundChanged)
    Q_PROPERTY(bool correctFrequency READ correctFrequency NOTIFY correctFrequencyChanged)

public:
    explicit GuitarTuner(QObject *parent = 0);

    double frequency() const;
    double targetFrequency() const;
    double centValue() const;
    double volumeLevel() const;
    Music::Note note() const;
    bool sound() const;
    bool correctFrequency() const;

    int pitchStandard() const;
    void setPitchStandard(const int &pitchStandard);

    Q_INVOKABLE void enable();
    Q_INVOKABLE void disable();

private:
    AudioInput *m_audioInput;
    Analyzer *m_analyzer;

    bool m_sound;
    Music::Note m_note;
    int m_pitchStandard;
    double m_centValue;
    double m_volume;
    double m_frequency;
    double m_targetFrequency;

signals:
    void frequencyChanged();
    void targetFrequencyChanged();
    void centValueChanged();
    void volumeLevelChanged();
    void noteChanged();
    void soundChanged();
    void correctFrequencyChanged();
    void pitchStandardChanged();

private slots:
    void onSoundChanged(const bool &sound);
    void setCentValue(const double &centValue);
    void setFrequency(const double &frequency);
    void setTargetFrequency(const double &frequency);
    void setNote(const Music::Note &note);

public slots:
    void setMicrophoneVolume(const double &volume);
    void setInputDevice(const QString &inputDevice);

};

#endif // GUITARTUNER_H
