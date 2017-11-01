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

#include "settings.h"

#include <QSettings>
#include <QDebug>
#include <QFileInfo>

Settings::Settings(QObject *parent) : QObject(parent)
{
    QAudioFormat inputFormat;
    inputFormat.setSampleRate(8000);
    inputFormat.setCodec("audio/pcm");
    inputFormat.setSampleSize(16);
    inputFormat.setChannelCount(1);
    inputFormat.setByteOrder(QAudioFormat::LittleEndian);
    inputFormat.setSampleType(QAudioFormat::SignedInt);

    m_audioInput = new AudioInput(inputFormat, this);
    m_analyzer = new VolumeAnalyzer(inputFormat, this);

    connect(m_analyzer, SIGNAL(volumeLevelChanged()), this, SIGNAL(currentMicrophoneVolumeChanged()));

    QSettings settings;
    qDebug() << "Load settings" << settings.fileName() << endl << "--------------------------------------";

    settings.beginGroup("audio");
    setInputSource(settings.value("inputSource", QAudioDeviceInfo::defaultInputDevice().deviceName()).toString());
    setMicrophoneVolume(settings.value("microphoneVolume", 50).toInt());
    settings.endGroup();

    settings.beginGroup("global");
    setDebugEnabled(settings.value("debug", false).toBool());
    setDarkThemeEnabled(settings.value("darkTheme", true).toBool());
    setDisableScreensaver(settings.value("disableScreensaver", true).toBool());
    setColor1(settings.value("color1", QColor("#ed3146")).value<QColor>());
    setColor2(settings.value("color2", QColor("#e95420")).value<QColor>());
    setColor3(settings.value("color3", QColor("#f0e442")).value<QColor>());
    settings.endGroup();

    settings.beginGroup("guitar");
    setGuitarPlayerVolume(settings.value("volume", 50).toInt());
    setChordPlayerDelay(settings.value("delay", 400).toInt());
    setMarkNotAssociatedStrings(settings.value("markNotAssociatedStrings", true).toBool());
    setDisableNotAssociatedStrings(settings.value("disableNotAssociatedStrings", false).toBool());
    setDisableFretboardNotes(settings.value("displayFretboardNotes", true).toBool());
    settings.endGroup();

    settings.beginGroup("tuningFork");
    setTuningForkVolume(settings.value("volume", 50).toInt());
    setTuningForkFrequency(settings.value("frequency", 440).toInt());
    settings.endGroup();

    settings.beginGroup("drumLoops");
    setDrumLoopsVolume(settings.value("volume", 50).toInt());
    settings.endGroup();

    settings.beginGroup("metronome");
    setMetronomeVolume(settings.value("volume", 50).toInt());
    setMetronomeSpeed(settings.value("speed", 120).toInt());
    settings.endGroup();

    settings.beginGroup("tuner");
    setPitchStandard(settings.value("pitchStandard", 440).toInt());
    settings.endGroup();

    qDebug() << "--------------------------------------";
}

QString Settings::inputSource() const
{
    return m_inputSource;
}

void Settings::setInputSource(const QString &source)
{
    m_inputSource = source;
    qDebug() << "Audio input source = " << source;
    QSettings settings;
    settings.beginGroup("audio");
    settings.setValue("inputSource", source);
    settings.endGroup();
    emit inputSourceChanged();
}

bool Settings::debugEnabled()
{
    return m_debugEnabled;
}

void Settings::setDebugEnabled(const bool &enabled)
{
    m_debugEnabled = enabled;
    qDebug() << "Debug = " << m_debugEnabled;
    QSettings settings;
    settings.beginGroup("global");
    settings.setValue("debug", m_debugEnabled);
    settings.endGroup();
    emit debugEnabledChanged();
}

bool Settings::darkThemeEnabled()
{
    return m_darkThemeEnabled;
}

void Settings::setDarkThemeEnabled(const bool &enabled)
{
    m_darkThemeEnabled = enabled;
    qDebug() << "Dark theme = " << m_darkThemeEnabled;
    QSettings settings;
    settings.beginGroup("global");
    settings.setValue("darkTheme", m_darkThemeEnabled);
    settings.endGroup();
    emit darkThemeEnabledChanged();
}

bool Settings::disableScreensaver() const
{
    return m_disableScreensaver;
}

void Settings::setDisableScreensaver(const bool &disableScreensaver)
{
    m_disableScreensaver = disableScreensaver;
    qDebug() << "Disable Screensaver = " << m_disableScreensaver;
    QSettings settings;
    settings.beginGroup("global");
    settings.setValue("disableScreensaver", m_disableScreensaver);
    settings.endGroup();
    emit disableScreensaverChanged();
}

int Settings::metronomeSpeed() const
{
    return m_metronomeSpeed;
}

void Settings::setMetronomeSpeed(const int &metronomeSpeed)
{
    m_metronomeSpeed = metronomeSpeed;
    qDebug() << "Metronome speed [bpm] = " << metronomeSpeed;
    QSettings settings;
    settings.beginGroup("metronome");
    settings.setValue("speed", metronomeSpeed);
    settings.endGroup();
    emit metronomeSpeedChanged();
}

int Settings::metronomeVolume() const
{
    return m_metronomeVolume;
}

void Settings::setMetronomeVolume(const int &volume)
{
    m_metronomeVolume = volume;
    qDebug() << "Metronome volume = " << volume;
    QSettings settings;
    settings.beginGroup("metronome");
    settings.setValue("volume", volume);
    settings.endGroup();
    emit metronomeVolumeChanged();
}

int Settings::guitarPlayerVolume() const
{
    return m_guitarPlayerVolume;
}

void Settings::setGuitarPlayerVolume(const int &volume)
{
    m_guitarPlayerVolume = volume;
    qDebug() << "Guitar player volume = " << volume;
    QSettings settings;
    settings.beginGroup("guitar");
    settings.setValue("volume", volume);
    settings.endGroup();
    emit guitarPlayerVolumeChanged();
}

bool Settings::markNotAssociatedStrings() const
{
    return m_markNotAssociatedStrings;
}

void Settings::setMarkNotAssociatedStrings(const bool &markNotAssociatedStrings)
{
    m_markNotAssociatedStrings = markNotAssociatedStrings;
    qDebug() << "Show forbidden strings = " << markNotAssociatedStrings;
    QSettings settings;
    settings.beginGroup("guitar");
    settings.setValue("markNotAssociatedStrings", markNotAssociatedStrings);
    settings.endGroup();
    emit markNotAssociatedStringsChanged();
}

bool Settings::disableNotAssociatedStrings() const
{
    return m_disableNotAssociatedStrings;
}

void Settings::setDisableNotAssociatedStrings(const bool &disableNotAssociatedStrings)
{
    m_disableNotAssociatedStrings = disableNotAssociatedStrings;
    qDebug() << "Disable forbidden strings = " << disableNotAssociatedStrings;
    QSettings settings;
    settings.beginGroup("guitar");
    settings.setValue("disableNotAssociatedStrings", disableNotAssociatedStrings);
    settings.endGroup();
    emit disableNotAssociatedStringsChanged();
}

bool Settings::displayFretboardNotes() const
{
    return m_disableFretboardNotes;
}

void Settings::setDisableFretboardNotes(const bool &displayFretboardNotes)
{
    m_disableFretboardNotes = displayFretboardNotes;
    qDebug() << "Display fretboard notes = " << displayFretboardNotes;
    QSettings settings;
    settings.beginGroup("guitar");
    settings.setValue("displayFretboardNotes", displayFretboardNotes);
    settings.endGroup();
    emit disableFretboardNotesChanged();
}

int Settings::tuningForkVolume() const
{
    return m_tuningForkVolume;
}

void Settings::setTuningForkVolume(const int &volume)
{
    m_tuningForkVolume = volume;
    qDebug() << "Tuning fork volume = " << volume;
    QSettings settings;
    settings.beginGroup("tuningFork");
    settings.setValue("volume", volume);
    settings.endGroup();
    emit tuningForkVolume();
}

int Settings::tuningForkFrequency() const
{
    return m_tuningForkFrequency;
}

void Settings::setTuningForkFrequency(const int &frequency)
{
    m_tuningForkFrequency = frequency;
    qDebug() << "Tuning fork frequency = " << frequency;
    QSettings settings;
    settings.beginGroup("tuningFork");
    settings.setValue("frequency", frequency);
    settings.endGroup();
    emit tuningForkFrequencyChanged();
}

int Settings::chordPlayerDelay() const
{
    return m_chordPlayerDelay;
}

void Settings::setChordPlayerDelay(const int &delay)
{
    m_chordPlayerDelay = delay;
    qDebug() << "Chord player delay = " << delay;
    QSettings settings;
    settings.beginGroup("guitar");
    settings.setValue("delay", delay);
    settings.endGroup();
    emit chordPlayerDelayChanged();
}

int Settings::drumLoopsVolume() const
{
    return m_drumLoopsVolume;
}

void Settings::setDrumLoopsVolume(const int &volume)
{
    m_drumLoopsVolume = volume;
    qDebug() << "Drum loops volume = " << volume;
    QSettings settings;
    settings.beginGroup("drumLoops");
    settings.setValue("volume", volume);
    settings.endGroup();
    emit drumLoopsVolumeChanged();
}

int Settings::microphoneVolume() const
{
    return m_microphoneVolume;
}

void Settings::setMicrophoneVolume(const int &volume)
{
    m_microphoneVolume = volume;
    qDebug() << "Microphone volume = " << volume;
    QSettings settings;
    settings.beginGroup("audio");
    settings.setValue("microphoneVolume", volume);
    settings.endGroup();
    emit microphoneVolumeChanged();
    m_audioInput->setMicrophoneVolume(volume);
}

int Settings::pitchStandard() const
{
    return m_pitchStandard;
}

void Settings::setPitchStandard(const int &pitchStandrard)
{
    m_pitchStandard = pitchStandrard;
    qDebug() << "Pitch standard = " << m_pitchStandard << "MHz";
    QSettings settings;
    settings.beginGroup("tuner");
    settings.setValue("pitchStandard", m_pitchStandard);
    settings.endGroup();
    emit pitchStandardChanged();
}

QColor Settings::color1() const
{
    return m_color1;
}

void Settings::setColor1(const QColor &color)
{
    m_color1 = color;
    qDebug() << "Color 1 = " << m_color1.toRgb();
    QSettings settings;
    settings.beginGroup("global");
    settings.setValue("color1", m_color1);
    settings.endGroup();
    emit color1Changed();
}

QColor Settings::color2() const
{
    return m_color2;
}

void Settings::setColor2(const QColor &color)
{
    m_color2 = color;

    qDebug() << "Color 2 = " << m_color2.toRgb();
    QSettings settings;
    settings.beginGroup("global");
    settings.setValue("color2", m_color2);
    settings.endGroup();

    emit color2Changed();
}

QColor Settings::color3() const
{
    return m_color3;
}

void Settings::setColor3(const QColor &color)
{
    m_color3 = color;
    qDebug() << "Color 3 = " << m_color3.toRgb();
    QSettings settings;
    settings.beginGroup("global");
    settings.setValue("color3", m_color3);
    settings.endGroup();
    emit color3Changed();
}

void Settings::loadChords(Chords *chords, Chords *guitarChords)
{
    // Clear the model
    qDebug() << "Load chords";

    guitarChords->clearModel();

    QSettings settings;
    settings.beginGroup("guitar");

    // Load chords
    int size = settings.beginReadArray("chord");
    for (int i = 0; i < size; i++) {
        settings.setArrayIndex(i);
        int note = settings.value("chordNote").toInt();
        if (note == -1) {
            guitarChords->loadChord(chords->emptyChord());
        } else {
            QString name = settings.value("chordName").toString();
            Chord *chord = chords->getChord(note, name);
            guitarChords->loadChord(chord);
        }
    }
    settings.endArray();

    settings.endGroup();

    if (guitarChords->chords().isEmpty())
        guitarChords->addChord(chords->emptyChord());

}

void Settings::saveGuitarChords(Chords *guitarChords)
{
    QSettings settings;
    settings.beginGroup("guitar");

    // Save chords
    settings.beginWriteArray("chord");

    for (int i = 0; i < guitarChords->count(); i++) {
        Chord *chord = guitarChords->get(i);
        settings.setArrayIndex(i);
        settings.setValue("chordNote", chord->note());
        settings.setValue("chordName", chord->name());
        qDebug() << "Save chord" << chord->fullName();
    }

    settings.endArray();
    settings.endGroup();
}

double Settings::currentMicrophoneVolume() const
{
    return m_analyzer->volumeLevel();
}

void Settings::enable()
{
    if (!m_audioInput->isRunning()) {
        qDebug() << "----------------------------------";
        qDebug() << "Settings: Audio enabled";
        m_analyzer->start();
        m_audioInput->start(m_analyzer);
    }
}

void Settings::disable()
{
    if (m_audioInput->isRunning()) {
        qDebug() << "----------------------------------";
        qDebug() << "Settings: Audio disabled";
        m_audioInput->stop();
        m_analyzer->stop();
    }
}
