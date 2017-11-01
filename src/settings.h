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

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QColor>

#include "chords.h"
#include "audioinput.h"
#include "volumeanalyzer.h"

class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString inputSource READ inputSource WRITE setInputSource NOTIFY inputSourceChanged)
    Q_PROPERTY(bool debugEnabled READ debugEnabled WRITE setDebugEnabled NOTIFY debugEnabledChanged)
    Q_PROPERTY(bool darkThemeEnabled READ darkThemeEnabled WRITE setDarkThemeEnabled NOTIFY darkThemeEnabledChanged)
    Q_PROPERTY(bool disableScreensaver READ disableScreensaver WRITE setDisableScreensaver NOTIFY disableScreensaverChanged)
    Q_PROPERTY(int metronomeSpeed READ metronomeSpeed WRITE setMetronomeSpeed NOTIFY metronomeSpeedChanged)
    Q_PROPERTY(int metronomeVolume READ metronomeVolume WRITE setMetronomeVolume NOTIFY metronomeVolumeChanged)
    Q_PROPERTY(int guitarPlayerVolume READ guitarPlayerVolume WRITE setGuitarPlayerVolume NOTIFY guitarPlayerVolumeChanged)
    Q_PROPERTY(bool markNotAssociatedStrings READ markNotAssociatedStrings WRITE setMarkNotAssociatedStrings NOTIFY markNotAssociatedStringsChanged)
    Q_PROPERTY(bool disableNotAssociatedStrings READ disableNotAssociatedStrings WRITE setDisableNotAssociatedStrings NOTIFY disableNotAssociatedStringsChanged)
    Q_PROPERTY(bool displayFretboardNotes READ displayFretboardNotes WRITE setDisableFretboardNotes NOTIFY disableFretboardNotesChanged)
    Q_PROPERTY(int tuningForkVolume READ tuningForkVolume WRITE setTuningForkVolume NOTIFY tuningForkVolumeChanged)
    Q_PROPERTY(int tuningForkFrequency READ tuningForkFrequency WRITE setTuningForkFrequency NOTIFY tuningForkFrequencyChanged)
    Q_PROPERTY(int chordPlayerDelay READ chordPlayerDelay WRITE setChordPlayerDelay NOTIFY chordPlayerDelayChanged)
    Q_PROPERTY(int drumLoopsVolume READ drumLoopsVolume WRITE setDrumLoopsVolume NOTIFY drumLoopsVolumeChanged)
    Q_PROPERTY(int microphoneVolume READ microphoneVolume WRITE setMicrophoneVolume NOTIFY microphoneVolumeChanged)
    Q_PROPERTY(int pitchStandard READ pitchStandard WRITE setPitchStandard NOTIFY pitchStandardChanged)
    Q_PROPERTY(double currentMicrophoneVolume READ currentMicrophoneVolume NOTIFY currentMicrophoneVolumeChanged)
    Q_PROPERTY(QColor color1 READ color1 WRITE setColor1 NOTIFY color1Changed)
    Q_PROPERTY(QColor color2 READ color2 WRITE setColor2 NOTIFY color2Changed)
    Q_PROPERTY(QColor color3 READ color3 WRITE setColor3 NOTIFY color3Changed)

public:
    explicit Settings(QObject *parent = 0);

    QString inputSource() const;
    void setInputSource(const QString &source);

    bool debugEnabled();
    void setDebugEnabled(const bool &enabled);

    bool darkThemeEnabled();
    void setDarkThemeEnabled(const bool &enabled);

    bool disableScreensaver() const;
    void setDisableScreensaver(const bool &disableScreensaver);

    int metronomeSpeed() const;
    void setMetronomeSpeed(const int &metronomeSpeed);

    int metronomeVolume() const;
    void setMetronomeVolume(const int &volume);

    int guitarPlayerVolume() const;
    void setGuitarPlayerVolume(const int &volume);

    bool markNotAssociatedStrings() const;
    void setMarkNotAssociatedStrings(const bool & markNotAssociatedStrings);

    bool disableNotAssociatedStrings() const;
    void setDisableNotAssociatedStrings(const bool &disableNotAssociatedStrings);

    bool displayFretboardNotes() const;
    void setDisableFretboardNotes(const bool &displayFretboardNotes);

    int tuningForkVolume() const;
    void setTuningForkVolume(const int &volume);

    int tuningForkFrequency() const;
    void setTuningForkFrequency(const int &frequency);

    int chordPlayerDelay() const;
    void setChordPlayerDelay(const int &delay);

    int drumLoopsVolume() const;
    void setDrumLoopsVolume(const int &volume);

    int microphoneVolume() const;
    void setMicrophoneVolume(const int &volume);

    int pitchStandard() const;
    void setPitchStandard(const int &pitchStandrard);

    // Color settings
    QColor color1() const;
    void setColor1(const QColor &color);

    QColor color2() const;
    void setColor2(const QColor &color);

    QColor color3() const;
    void setColor3(const QColor &color);

    void loadChords(Chords *chords, Chords *guitarChords);
    void saveGuitarChords(Chords *guitarChords);

    // Microphone volume
    double currentMicrophoneVolume() const;
    Q_INVOKABLE void enable();
    Q_INVOKABLE void disable();

private:
    AudioInput *m_audioInput;
    VolumeAnalyzer *m_analyzer;

    // Settings
    QString m_inputSource;
    bool m_debugEnabled;
    bool m_darkThemeEnabled;
    bool m_disableScreensaver;

    // Guitar
    bool m_markNotAssociatedStrings;
    bool m_disableNotAssociatedStrings;
    bool m_disableFretboardNotes;
    int m_guitarPlayerVolume;

    // Metronome
    int m_metronomeSpeed;
    int m_metronomeVolume;

    // Tuning Fork
    int m_tuningForkVolume;
    int m_tuningForkFrequency;

    // Chord player
    int m_chordPlayerDelay;

    int m_drumLoopsVolume;
    int m_pitchStandard;
    int m_microphoneVolume;

    // Color settings
    QColor m_color1;
    QColor m_color2;
    QColor m_color3;

signals:
    void currentMicrophoneVolumeChanged();

    void inputSourceChanged();
    void debugEnabledChanged();
    void darkThemeEnabledChanged();
    void disableScreensaverChanged();
    void metronomeSpeedChanged();
    void metronomeVolumeChanged();
    void markNotAssociatedStringsChanged();
    void disableNotAssociatedStringsChanged();
    void disableFretboardNotesChanged();
    void guitarPlayerVolumeChanged();
    void tuningForkVolumeChanged();
    void tuningForkFrequencyChanged();
    void chordPlayerDelayChanged();
    void drumLoopsVolumeChanged();
    void microphoneVolumeChanged();
    void pitchStandardChanged();

    void color1Changed();
    void color2Changed();
    void color3Changed();

};

#endif // SETTINGS_H
