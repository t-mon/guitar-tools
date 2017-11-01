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

#ifndef CORE_H
#define CORE_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>
#include <QDir>
#include <QColor>

#include "settings.h"
#include "guitartuner.h"
#include "metronome.h"
#include "recorder.h"
#include "music.h"
#include "chordsproxy.h"
#include "chords.h"
#include "chord.h"
#include "scale.h"
#include "scales.h"
#include "scalesproxy.h"
#include "sinewavegenerator.h"
#include "drumloopplayer.h"
#include "noteplayer.h"
#include "composetool.h"

class Core : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Settings *settings READ settings CONSTANT)
    Q_PROPERTY(GuitarTuner *guitarTuner READ guitarTuner CONSTANT)
    Q_PROPERTY(SineWaveGenerator *sineWaveGenerator READ sineWaveGenerator CONSTANT)
    Q_PROPERTY(Metronome *metronome READ metronome CONSTANT)
    Q_PROPERTY(Recorder *recorder READ recorder CONSTANT)
    Q_PROPERTY(Chords *chords READ chords CONSTANT)
    Q_PROPERTY(Chords *guitarPlayerChords READ guitarPlayerChords CONSTANT)
    Q_PROPERTY(ChordsProxy *chordsProxy READ chordsProxy CONSTANT)
    Q_PROPERTY(DrumLoopPlayer *drumLoopPlayer READ drumLoopPlayer CONSTANT)
    Q_PROPERTY(NotePlayer *notePlayer READ notePlayer CONSTANT)
    Q_PROPERTY(Scale *fretBoardScale READ fretBoardScale CONSTANT)
    Q_PROPERTY(Scales *scales READ scales CONSTANT)
    Q_PROPERTY(ScalesProxy *scalesProxy READ scalesProxy CONSTANT)
    Q_PROPERTY(ComposeTool *composeTool READ composeTool CONSTANT)

    Q_PROPERTY(QStringList inputDevices READ inputDevices CONSTANT)

public:
    static Core* instance();
    static QObject *qmlInstance(QQmlEngine *qmlEngine, QJSEngine *jsEngine);

    QDir dataDir() const;
    void setDataDir(const QDir &dataDir);

    Settings *settings();
    GuitarTuner *guitarTuner();
    Metronome *metronome();
    Recorder *recorder();
    SineWaveGenerator *sineWaveGenerator();
    DrumLoopPlayer *drumLoopPlayer();
    NotePlayer *notePlayer();

    Chords *chords();
    Chords *guitarPlayerChords();
    ChordsProxy *chordsProxy();

    Scale *fretBoardScale();

    Scales *scales();
    ScalesProxy *scalesProxy();

    ComposeTool *composeTool();

    QStringList inputDevices() const;

    Q_INVOKABLE void activateGuitarTuner();
    Q_INVOKABLE void activateGuitarPlayer();
    Q_INVOKABLE void activateMetronome();
    Q_INVOKABLE void activateSettings();
    Q_INVOKABLE void activateRecorder();
    Q_INVOKABLE void activateChord();
    Q_INVOKABLE void activateScales();
    Q_INVOKABLE void activateTuningFork();
    Q_INVOKABLE void activateDrumLoops();

    Q_INVOKABLE void deactivateTools();

    // Gradient colors
    Q_INVOKABLE QColor getColor(const int &index) const;
    Q_INVOKABLE QColor getColorForNote(const QString &noteSource) const;

    Q_INVOKABLE void loadChords();
    Q_INVOKABLE void loadScales();

    Q_INVOKABLE void increaseColor1();
    Q_INVOKABLE void increaseColor2();
    Q_INVOKABLE void increaseColor3();

    Q_INVOKABLE static QString getNoteFileName(const int &guitarString, const int &fret);

private:
    explicit Core(QObject *parent = 0);
    static Core *s_instance;
    QDir m_dataDir;

    QList<QColor> m_colors;
    QList<QColor> m_colorSelection;
    QMap<QString, int> m_colorMap;

    Settings *m_settings;
    GuitarTuner *m_guitarTuner;
    Metronome *m_metronome;
    Recorder *m_recorder;
    SineWaveGenerator *m_sineWaveGenerator;
    DrumLoopPlayer *m_drumLoopPlayer;
    NotePlayer *m_notePlayer;

    Chords *m_chords;
    Chords *m_guitarPlayerChords;
    ChordsProxy *m_chordsProxy;
    bool m_chordsLoaded;

    Scale *m_fretBoardScale;
    Scales *m_scales;
    ScalesProxy *m_scalesProxy;

    ComposeTool *m_composeTool;

    bool m_scalesLoaded;

    void initColorSelection();
    void initColorMap();

private slots:
    void onMicrophoneVolumeChanged();
    void onInputDeviceChanged();
    void onPitchStandardChanged();
    void onGuitarVolumeChanged();
    void onDrumLoopVolumeChanged();

    void onGuitarChordsUpdated();
    void updateColorValues();

};

#endif // CORE_H
