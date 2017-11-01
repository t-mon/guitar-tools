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

#include "core.h"
#include "chordpositions.h"

#include <QJsonDocument>
#include <QJsonParseError>
#include <QPixmap>
#include <QPainter>
#include <QLinearGradient>

Core* Core::s_instance = 0;

Core *Core::instance()
{
    if (!s_instance)
        s_instance = new Core();

    return s_instance;
}

QObject *Core::qmlInstance(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)
    return Core::instance();
}

QDir Core::dataDir() const
{
    return m_dataDir;
}

void Core::setDataDir(const QDir &dataDir)
{
    m_dataDir = dataDir;
}

Settings *Core::settings()
{
    return m_settings;
}

GuitarTuner *Core::guitarTuner()
{
    return m_guitarTuner;
}

Metronome *Core::metronome()
{
    return m_metronome;
}

Recorder *Core::recorder()
{
    return m_recorder;
}

SineWaveGenerator *Core::sineWaveGenerator()
{
    return m_sineWaveGenerator;
}

DrumLoopPlayer *Core::drumLoopPlayer()
{
    return m_drumLoopPlayer;
}

NotePlayer *Core::notePlayer()
{
    return m_notePlayer;
}

Chords *Core::chords()
{
    return m_chords;
}

Chords *Core::guitarPlayerChords()
{
    return m_guitarPlayerChords;
}

ChordsProxy *Core::chordsProxy()
{
    return m_chordsProxy;
}

Scale *Core::fretBoardScale()
{
    if (!m_fretBoardScale) {
        m_fretBoardScale = new Scale(this);
        m_fretBoardScale->fill();
    }

    return m_fretBoardScale;
}

Scales *Core::scales()
{
    return m_scales;
}

ScalesProxy *Core::scalesProxy()
{
    return m_scalesProxy;
}

ComposeTool *Core::composeTool()
{
    return m_composeTool;
}

QStringList Core::inputDevices() const
{
    QStringList inputDevices;
    foreach (const QAudioDeviceInfo &deviceInfo, QAudioDeviceInfo::availableDevices(QAudio::AudioInput)) {
        inputDevices.append(deviceInfo.deviceName());
    }

    return inputDevices;
}

void Core::activateGuitarTuner()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate guitar tuner";
    qDebug() << "-----------------------------------";
    m_metronome->stop();
    m_settings->disable();
    m_recorder->stopRecording();
    m_sineWaveGenerator->stop();
    m_drumLoopPlayer->stop();
    m_guitarTuner->enable();
}

void Core::activateGuitarPlayer()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate guitar player";
    qDebug() << "-----------------------------------";
    loadChords();
    m_metronome->stop();
    m_settings->disable();
    m_recorder->stopRecording();
    m_guitarTuner->disable();
    m_sineWaveGenerator->stop();
    m_drumLoopPlayer->stop();
}

void Core::activateMetronome()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate metronome";
    qDebug() << "-----------------------------------";
    m_guitarTuner->disable();
    m_settings->disable();
    m_recorder->stopRecording();
    m_metronome->stop();
    m_sineWaveGenerator->stop();
    m_drumLoopPlayer->stop();
}

void Core::activateSettings()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate settings";
    qDebug() << "-----------------------------------";
    m_recorder->stopRecording();
    m_guitarTuner->disable();
    m_sineWaveGenerator->stop();
    m_metronome->stop();
    m_drumLoopPlayer->stop();
    m_settings->enable();
}

void Core::activateRecorder()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate recorde";
    qDebug() << "-----------------------------------";
    m_metronome->stop();
    m_settings->disable();
    m_recorder->stopRecording();
    m_guitarTuner->disable();
    m_sineWaveGenerator->stop();
    m_drumLoopPlayer->stop();
}

void Core::activateChord()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate chords";
    qDebug() << "-----------------------------------";
    m_metronome->stop();
    m_settings->disable();
    m_recorder->stopRecording();
    m_guitarTuner->disable();
    m_sineWaveGenerator->stop();
    m_drumLoopPlayer->stop();
}

void Core::activateScales()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate scales";
    qDebug() << "-----------------------------------";
    loadScales();
    m_metronome->stop();
    m_settings->disable();
    m_recorder->stopRecording();
    m_guitarTuner->disable();
    m_sineWaveGenerator->stop();
    m_drumLoopPlayer->stop();
}

void Core::activateTuningFork()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate tuning fork";
    qDebug() << "-----------------------------------";
    m_metronome->stop();
    m_settings->disable();
    m_recorder->stopRecording();
    m_guitarTuner->disable();
    m_drumLoopPlayer->stop();
}

void Core::activateDrumLoops()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Activate drum loops";
    qDebug() << "-----------------------------------";
    m_metronome->stop();
    m_settings->disable();
    m_recorder->stopRecording();
    m_guitarTuner->disable();
}

void Core::deactivateTools()
{
    qDebug() << "-----------------------------------";
    qDebug() << "Deactivate all tools";
    qDebug() << "-----------------------------------";
    m_recorder->stopRecording();
    m_guitarTuner->disable();
    m_sineWaveGenerator->stop();
    m_metronome->stop();
    m_drumLoopPlayer->stop();
    m_settings->disable();
}

QColor Core::getColor(const int &index) const
{
    if (index >= 37 || index < 0)
        return QColor();

    return m_colors.at(index);
}

QColor Core::getColorForNote(const QString &noteSource) const
{
    return getColor(m_colorMap.value(noteSource));
}

void Core::loadChords()
{
    if (m_chordsLoaded)
        return;

    QString fileDir = m_dataDir.path() + "/chords/";
    QDir dir(fileDir);
    dir.setFilter(QDir::Files);
    dir.setSorting(QDir::Name);

    QFileInfoList chordFiles = dir.entryInfoList();
    foreach (const QFileInfo &chordFileInfo, chordFiles) {
        if (!chordFileInfo.fileName().endsWith(".json"))
            continue;

        QFile file(chordFileInfo.absoluteFilePath());
        if (!file.exists()) {
            qWarning() << "Could not find" << file.fileName();
            return;
        }

        qDebug() << "Loading chords from" << file.fileName();
        if (!file.open(QFile::ReadOnly)) {
            qDebug() << "Cannot open chords file for reading:" << file.fileName();
            return;
        }

        QJsonParseError error;
        QJsonDocument jsonDoc = QJsonDocument::fromJson(file.readAll(), &error);
        if (error.error != QJsonParseError::NoError) {
            qDebug() << "Cannot parse chords file:" << error.errorString();
            return;
        }

        QVariantList chordVariantList = jsonDoc.toVariant().toMap().value("chords").toList();

        foreach (const QVariant &chordVariant, chordVariantList) {
            QVariantMap chordVariantMap = chordVariant.toMap();
            Chord *chord = new Chord(this);
            chord->setName(chordVariantMap.value("name").toString());
            chord->setNote(Music::stringToNote(chordVariantMap.value("note").toString()));
            chord->setKey(Music::stringToNoteKey(chordVariantMap.value("key").toString()));
            chord->setStartFret(chordVariantMap.value("startFret").toInt());

            ChordPositions *positions = new ChordPositions(chord);
            foreach (const QVariant positionVariant, chordVariantMap.value("positions").toList()) {
                QVariantMap positionVariantMap = positionVariant.toMap();
                ChordPosition *position = new ChordPosition(chord);
                position->setGuitarString(Music::stringToGuitarString(positionVariantMap.value("string").toString()));
                position->setFret(positionVariantMap.value("fret").toInt());
                position->setFinger(positionVariantMap.value("finger").toInt());
                positions->addChordPosition(position);
            }
            chord->setPositions(positions);
            m_chords->addChord(chord);
        }
    }
    m_chordsProxy->setChords(m_chords);
    m_settings->loadChords(m_chords, m_guitarPlayerChords);
    m_chordsLoaded = true;
}

void Core::loadScales()
{
    if (m_scalesLoaded)
        return;

    QString fileDir = m_dataDir.path() + "/scales/";
    QDir dir(fileDir);
    dir.setFilter(QDir::Files);
    dir.setSorting(QDir::Name);

    QFileInfoList chordFiles = dir.entryInfoList();
    foreach (const QFileInfo &chordFileInfo, chordFiles) {
        if (!chordFileInfo.fileName().endsWith(".json"))
            continue;

        QFile file(chordFileInfo.absoluteFilePath());
        if (!file.exists()) {
            qWarning() << "Could not find" << file.fileName();
            return;
        }

        if (QFileInfo(file.fileName()).fileName() == "base-scales.json") {
            qDebug() << "Skipping base-scales.json" << file.fileName();
            continue;
        }

        qDebug() << "Loading scales from" << file.fileName();
        if (!file.open(QFile::ReadOnly)) {
            qDebug() << "Cannot open scales file for reading:" << file.fileName();
            return;
        }

        QJsonParseError error;
        QJsonDocument jsonDoc = QJsonDocument::fromJson(file.readAll(), &error);
        if (error.error != QJsonParseError::NoError) {
            qDebug() << "Cannot parse scales file:" << error.errorString();
            return;
        }

        QVariantList scalesVariantList = jsonDoc.toVariant().toMap().value("scales").toList();
        foreach (const QVariant &scaleVariant, scalesVariantList) {
            QVariantMap scaleVariantMap = scaleVariant.toMap();
            Scale *scale = new Scale(this);
            scale->setName(scaleVariantMap.value("name").toString());
            scale->setNote(Music::stringToNote(scaleVariantMap.value("note").toString()));
            scale->setKey(Music::stringToNoteKey(scaleVariantMap.value("key").toString()));

            FretPositions *positions = new FretPositions(scale);
            QVariantMap positionsMap = scaleVariantMap.value("positions").toMap();
            foreach (const QVariant &stringVariant, positionsMap.keys()) {
                QVariantList frets = positionsMap.value(stringVariant.toString()).toList();
                foreach (const QVariant &fretVariant, frets) {
                    FretPosition *position = new FretPosition(positions);
                    position->setGuitarString(Music::stringToGuitarString(stringVariant.toString()));
                    position->setFret(fretVariant.toInt());
                    position->setNote(Music::noteFromGuitarPosition(position->guitarString(), position->fret()));
                    position->setNoteFileName(getNoteFileName(position->guitarString(), position->fret()));
                    positions->addFretPosition(position);
                }
            }
            scale->setPositions(positions);
            m_scales->addScale(scale);
        }
    }
    m_scalesProxy->setScales(m_scales);
    m_scalesLoaded = true;
}

void Core::increaseColor1()
{
    if (m_colorSelection.isEmpty())
        return;

    int currentIndex = m_colorSelection.indexOf(m_settings->color1());
    if (currentIndex < 0) {
        qDebug() << "Could not find current color in color list";
        m_settings->setColor1(m_colorSelection.first());
        return;
    }

    if (currentIndex + 1 >= m_colorSelection.count()) {
        m_settings->setColor1(m_colorSelection.first());
    } else {
        m_settings->setColor1(m_colorSelection.at(currentIndex + 1));
    }

    updateColorValues();
}

void Core::increaseColor2()
{
    if (m_colorSelection.isEmpty())
        return;

    int currentIndex = m_colorSelection.indexOf(m_settings->color2());
    if (currentIndex < 0) {
        qDebug() << "Could not find current color in color list";
        m_settings->setColor2(m_colorSelection.first());
        return;
    }

    if (currentIndex + 1 >= m_colorSelection.count()) {
        m_settings->setColor2(m_colorSelection.first());
    } else {
        m_settings->setColor2(m_colorSelection.at(currentIndex + 1));
    }

    updateColorValues();
}

void Core::increaseColor3()
{
    if (m_colorSelection.isEmpty())
        return;

    int currentIndex = m_colorSelection.indexOf(m_settings->color3());
    if (currentIndex < 0) {
        qDebug() << "Could not find current color in color list";
        m_settings->setColor3(m_colorSelection.first());
        return;
    }

    if (currentIndex + 1 >= m_colorSelection.count()) {
        m_settings->setColor3(m_colorSelection.first());
    } else {
        m_settings->setColor3(m_colorSelection.at(currentIndex + 1));
    }

    updateColorValues();
}



Core::Core(QObject *parent) :
    QObject(parent),
    m_settings(new Settings(this)),
    m_chords(new Chords(this)),
    m_guitarPlayerChords(new Chords(this)),
    m_chordsProxy(new ChordsProxy(this)),
    m_chordsLoaded(false),
    m_fretBoardScale(NULL),
    m_scales(new Scales(this)),
    m_scalesProxy(new ScalesProxy(this)),
    m_scalesLoaded(false)
{
    initColorSelection();
    initColorMap();

    m_guitarTuner = new GuitarTuner(this);
    m_guitarTuner->setMicrophoneVolume(m_settings->microphoneVolume());
    m_guitarTuner->setInputDevice(m_settings->inputSource());
    m_guitarTuner->setPitchStandard(m_settings->pitchStandard());

    m_sineWaveGenerator = new SineWaveGenerator(this);
    m_sineWaveGenerator->setVolume(m_settings->tuningForkVolume());
    m_sineWaveGenerator->setFrequency(m_settings->tuningForkFrequency());

    m_recorder = new Recorder(this);
    m_recorder->setMicrophoneVolume(m_settings->microphoneVolume());
    m_recorder->setInputDevice(m_settings->inputSource());

    m_metronome = new Metronome(this);
    m_metronome->setBpm(m_settings->metronomeSpeed());

    m_drumLoopPlayer = new DrumLoopPlayer(m_settings->drumLoopsVolume(), this);

    m_notePlayer = new NotePlayer(m_settings->guitarPlayerVolume(), this);

    m_composeTool = new ComposeTool(this);

    connect(m_guitarPlayerChords, SIGNAL(updated()), this, SLOT(onGuitarChordsUpdated()));

    connect(m_settings, SIGNAL(microphoneVolumeChanged()), this, SLOT(onMicrophoneVolumeChanged()));
    connect(m_settings, SIGNAL(pitchStandardChanged()), this, SLOT(onPitchStandardChanged()));
    connect(m_settings, SIGNAL(guitarPlayerVolumeChanged()), this, SLOT(onGuitarVolumeChanged()));
    connect(m_settings, SIGNAL(drumLoopsVolumeChanged()), this, SLOT(onDrumLoopVolumeChanged()));

    updateColorValues();
}

void Core::initColorSelection()
{
    m_colorSelection.clear();
    m_colorSelection.append(QColor("#d55e00"));
    m_colorSelection.append(QColor("#ed3146"));
    m_colorSelection.append(QColor("#e95420"));
    m_colorSelection.append(QColor("#e69f00"));
    m_colorSelection.append(QColor("#f0e442"));
    m_colorSelection.append(QColor("#19b6ee"));
    m_colorSelection.append(QColor("#56b4e9"));
    m_colorSelection.append(QColor("#3eb34f"));
    m_colorSelection.append(QColor("#009e73"));
    m_colorSelection.append(QColor("#cc79a7"));
}

void Core::initColorMap()
{
    m_colorMap.clear();

    // E2
    m_colorMap.insert("E2-0.wav", 0);
    m_colorMap.insert("E2-1.wav", 1);
    m_colorMap.insert("E2-2.wav", 2);
    m_colorMap.insert("E2-3.wav", 3);
    m_colorMap.insert("E2-4.wav", 4);

    // A
    m_colorMap.insert("A-0.wav", 5);
    m_colorMap.insert("A-1.wav", 6);
    m_colorMap.insert("A-2.wav", 7);
    m_colorMap.insert("A-3.wav", 8);
    m_colorMap.insert("A-4.wav", 9);

    // D
    m_colorMap.insert("D-0.wav", 10);
    m_colorMap.insert("D-1.wav", 11);
    m_colorMap.insert("D-2.wav", 12);
    m_colorMap.insert("D-3.wav", 13);
    m_colorMap.insert("D-4.wav", 14);

    // G
    m_colorMap.insert("G-0.wav", 15);
    m_colorMap.insert("G-1.wav", 16);
    m_colorMap.insert("G-2.wav", 17);
    m_colorMap.insert("G-3.wav", 18);

    // B
    m_colorMap.insert("B-0.wav", 19);
    m_colorMap.insert("B-1.wav", 20);
    m_colorMap.insert("B-2.wav", 21);
    m_colorMap.insert("B-3.wav", 22);
    m_colorMap.insert("B-4.wav", 23);

    // E4
    m_colorMap.insert("E4-0.wav", 24);
    m_colorMap.insert("E4-1.wav", 25);
    m_colorMap.insert("E4-2.wav", 26);
    m_colorMap.insert("E4-3.wav", 27);
    m_colorMap.insert("E4-4.wav", 28);
    m_colorMap.insert("E4-5.wav", 29);
    m_colorMap.insert("E4-6.wav", 30);
    m_colorMap.insert("E4-7.wav", 31);
    m_colorMap.insert("E4-8.wav", 32);
    m_colorMap.insert("E4-9.wav", 33);
    m_colorMap.insert("E4-10.wav", 34);
    m_colorMap.insert("E4-11.wav", 35);
    m_colorMap.insert("E4-12.wav", 36);
}

void Core::onMicrophoneVolumeChanged()
{
    m_guitarTuner->setMicrophoneVolume(m_settings->microphoneVolume());
    m_recorder->setMicrophoneVolume(m_settings->microphoneVolume());
}

void Core::onInputDeviceChanged()
{
    m_guitarTuner->setInputDevice(m_settings->inputSource());
    m_recorder->setInputDevice(m_settings->inputSource());
}

void Core::onPitchStandardChanged()
{
    m_guitarTuner->setPitchStandard(m_settings->pitchStandard());
}

void Core::onGuitarVolumeChanged()
{
    m_notePlayer->setVolume(m_settings->guitarPlayerVolume());
}

void Core::onDrumLoopVolumeChanged()
{
    m_drumLoopPlayer->setVolume(m_settings->drumLoopsVolume());
}

void Core::onGuitarChordsUpdated()
{
    m_settings->saveGuitarChords(m_guitarPlayerChords);
}

void Core::updateColorValues()
{
    QSize size(500, 10);
    QPixmap pix(size);
    QRect rectangle(QPoint(0,0), size);
    QPainter *painter = new QPainter(&pix);
    QLinearGradient gradient(QPoint(0, size.height() / 2), QPoint(size.width(), size.height() / 2));
    gradient.setColorAt(0, m_settings->color1());
    gradient.setColorAt(0.5, m_settings->color2());
    gradient.setColorAt(1, m_settings->color3());
    painter->fillRect(rectangle, gradient);
    painter->drawRect(rectangle);
    QImage image = pix.toImage();

    // Calculate colors
    m_colors.clear();

    for (int i = 0; i < m_colorMap.count(); i ++) {
        QColor color;
        if (i == 0) {
            color = m_settings->color1();
        } else if (i == m_colorMap.count() -1) {
            color = m_settings->color3();
        } else {
            color = QColor(image.pixel(i * size.width() / m_colorMap.count(), size.height() / 2));
        }
        m_colors.append(color);
    }

    delete painter;
}

QString Core::getNoteFileName(const int &guitarString, const int &fret)
{
    // Map sound files to guitar strings/frets
    switch (guitarString) {
    case Music::GuitarStringE2: {
        switch (fret) {
        case 0:
            return "E2-0.wav";
        case 1:
            return "E2-1.wav";
        case 2:
            return "E2-2.wav";
        case 3:
            return "E2-3.wav";
        case 4:
            return "E2-4.wav";
        case 5:
            return "A-0.wav";
        case 6:
            return "A-1.wav";
        case 7:
            return "A-2.wav";
        case 8:
            return "A-3.wav";
        case 9:
            return "A-4.wav";
        case 10:
            return "D-0.wav";
        case 11:
            return "D-1.wav";
        case 12:
            return "D-2.wav";
        default:
            return "E2-0.wav";
        }
    }
    case Music::GuitarStringA: {
        switch (fret) {
        case 0:
            return "A-0.wav";
        case 1:
            return "A-1.wav";
        case 2:
            return "A-2.wav";
        case 3:
            return "A-3.wav";
        case 4:
            return "A-4.wav";
        case 5:
            return "D-0.wav";
        case 6:
            return "D-1.wav";
        case 7:
            return "D-2.wav";
        case 8:
            return "D-3.wav";
        case 9:
            return "D-4.wav";
        case 10:
            return "G-0.wav";
        case 11:
            return "G-1.wav";
        case 12:
            return "G-2.wav";
        default:
            return "A-0.wav";
        }
    }
    case Music::GuitarStringD: {
        switch (fret) {
        case 0:
            return "D-0.wav";
        case 1:
            return "D-1.wav";
        case 2:
            return "D-2.wav";
        case 3:
            return "D-3.wav";
        case 4:
            return "D-4.wav";
        case 5:
            return "G-0.wav";
        case 6:
            return "G-1.wav";
        case 7:
            return "G-2.wav";
        case 8:
            return "G-3.wav";
        case 9:
            return "B-0.wav";
        case 10:
            return "B-1.wav";
        case 11:
            return "B-2.wav";
        case 12:
            return "B-3.wav";
        default:
            return "D-0.wav";
        }
    }
    case Music::GuitarStringG: {
        switch (fret) {
        case 0:
            return "G-0.wav";
        case 1:
            return "G-1.wav";
        case 2:
            return "G-2.wav";
        case 3:
            return "G-3.wav";
        case 4:
            return "B-0.wav";
        case 5:
            return "B-1.wav";
        case 6:
            return "B-2.wav";
        case 7:
            return "B-3.wav";
        case 8:
            return "B-4.wav";
        case 9:
            return "E4-0.wav";
        case 10:
            return "E4-1.wav";
        case 11:
            return "E4-2.wav";
        case 12:
            return "E4-3.wav";
        default:
            return "G-0.wav";
        }
    }
    case Music::GuitarStringB: {
        switch (fret) {
        case 0:
            return "B-0.wav";
        case 1:
            return "B-1.wav";
        case 2:
            return "B-2.wav";
        case 3:
            return "B-3.wav";
        case 4:
            return "B-4.wav";
        case 5:
            return "E4-0.wav";
        case 6:
            return "E4-1.wav";
        case 7:
            return "E4-2.wav";
        case 8:
            return "E4-3.wav";
        case 9:
            return "E4-4.wav";
        case 10:
            return "E4-5.wav";
        case 11:
            return "E4-6.wav";
        case 12:
            return "E4-7.wav";
        default:
            return "B-0.wav";
        }
    }
    case Music::GuitarStringE4: {
        switch (fret) {
        case 0:
            return "E4-0.wav";
        case 1:
            return "E4-1.wav";
        case 2:
            return "E4-2.wav";
        case 3:
            return "E4-3.wav";
        case 4:
            return "E4-4.wav";
        case 5:
            return "E4-5.wav";
        case 6:
            return "E4-6.wav";
        case 7:
            return "E4-7.wav";
        case 8:
            return "E4-8.wav";
        case 9:
            return "E4-9.wav";
        case 10:
            return "E4-10.wav";
        case 11:
            return "E4-11.wav";
        case 12:
            return "E4-12.wav";
        default:
            return "E4-0.wav";
        }
    }
    default:
        return "A-0.wav";
    }
    return QString();
}
