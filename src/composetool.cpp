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

#include "composetool.h"
#include "core.h"

#include <QDebug>
#include <QTime>
#include <QSettings>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonParseError>

ComposeTool::ComposeTool(QObject *parent) :
    QTimeLine(1000, parent),
    m_notes(new ComposeNotes(this)),
    m_playing(false),
    m_songName(tr("New song")),
    m_measureCount(10),
    m_trackCount(4),
    m_bpm(120),
    m_rythmTicks(4),
    m_rythmBeats(4),
    m_enableMetronome(false),
    m_scaleValue(1.0),
    m_outputDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation) + "/songs/")
{
    if (!m_outputDir.exists()) {
        qDebug() << "Create song dir" << m_outputDir.canonicalPath();
        m_outputDir.mkpath(".");
    }

    loadCurrentSettings();
    calculateTimings();

    // Configure TimeLine
    setUpdateInterval(16);
    setCurveShape(QTimeLine::LinearCurve);

    connect(this, SIGNAL(frameChanged(int)), this, SLOT(onFrameChanged(int)));
    connect(this, SIGNAL(valueChanged(qreal)), this, SLOT(onValueChanged(qreal)));
    connect(this, SIGNAL(stateChanged(QTimeLine::State)), this, SLOT(onStateChanged(QTimeLine::State)));

    QMetaObject::invokeMethod(this, "setup", Qt::QueuedConnection);
}

QString ComposeTool::songName() const
{
    return m_songName;
}

void ComposeTool::setSongName(const QString &songName)
{
    m_songName = songName;
    emit songNameChanged();
}

QString ComposeTool::compositore() const
{
    return m_compositore;
}

void ComposeTool::setCompositore(const QString &compositore)
{
    // TODO: add compositor to songs
    m_compositore = compositore;
    emit compositoreChanged();
}

QStringList ComposeTool::songs()
{
    QStringList songs;
    qDebug() << "Load json song names from" << m_outputDir.canonicalPath();
    m_outputDir.setFilter(QDir::Files);
    m_outputDir.setSorting(QDir::Name);
    foreach (const QFileInfo &fileInfo, m_outputDir.entryInfoList()) {
        if (!fileInfo.fileName().endsWith(".json"))
            continue;

        QString songName = fileInfo.fileName().split(".").first();
        songs.append(songName);
    }

    return songs;
}

QStringList ComposeTool::exampleSongs()
{
    QStringList songs;
    QDir exampleDir(Core::instance()->dataDir().canonicalPath() + "/examples/");
    qDebug() << "Load example song names from" << exampleDir.canonicalPath();
    exampleDir.setFilter(QDir::Files);
    exampleDir.setSorting(QDir::Name);
    foreach (const QFileInfo &fileInfo, exampleDir.entryInfoList()) {
        if (!fileInfo.fileName().endsWith(".json"))
            continue;

        QString songName = fileInfo.fileName().split(".").first();
        songs.append(songName);
    }

    return songs;
}

int ComposeTool::measureCount() const
{
    return m_measureCount;
}

int ComposeTool::rowCount() const
{
    return m_trackCount;
}

void ComposeTool::setMeasureCount(const int &measureCount)
{
    m_measureCount = measureCount;
    emit measureCountChanged();
    calculateTimings();
}

int ComposeTool::trackCount() const
{
    return m_trackCount;
}

int ComposeTool::columnCount() const
{
    return m_measureCount * m_rythmTicks;
}

void ComposeTool::setTrackCount(const int &trackCount)
{
    m_trackCount = trackCount;
    emit trackCountChanged();
    calculateTimings();
}

int ComposeTool::songDuration() const
{
    return m_songDuration;
}

QString ComposeTool::songDurationString() const
{
    return QTime::fromMSecsSinceStartOfDay(m_songDuration).toString("mm:ss.zzz");
}

int ComposeTool::bpm() const
{
    return m_bpm;
}

void ComposeTool::setBpm(const int &bpm)
{
    m_bpm = bpm;
    emit bpmChanged();
    calculateTimings();
}

int ComposeTool::rythmTicks() const
{
    return m_rythmTicks;
}

void ComposeTool::setRhythmTicks(const int &rythmTicks)
{
    m_rythmTicks = rythmTicks;
    emit rythmTicksChanged();
    calculateTimings();
}

int ComposeTool::rythmBeats() const
{
    return m_rythmBeats;
}

void ComposeTool::setRhythmBeats(const int &rythmBeats)
{
    m_rythmBeats = rythmBeats;
    emit rythmBeatsChanged();
    calculateTimings();
}

int ComposeTool::tickIntervall() const
{
    return m_tickIntervall;
}

int ComposeTool::measureIntervall() const
{
    return m_measureIntervall;
}

bool ComposeTool::enableMetronome() const
{
    return m_enableMetronome;
}

void ComposeTool::setEnableMetronome(const bool &enableMetronome)
{
    m_enableMetronome = enableMetronome;
    emit enableMetronomeChanged();
}

bool ComposeTool::playing() const
{
    return m_playing;
}

qreal ComposeTool::positionPercentage() const
{
    return m_positionPercentage;
}

QString ComposeTool::currentTimeString() const
{
    return QTime::fromMSecsSinceStartOfDay(currentTime()).toString("mm:ss.zzz");
}

qreal ComposeTool::scaleValue() const
{
    return m_scaleValue;
}

void ComposeTool::setScaleValue(const qreal &scaleValue)
{
    m_scaleValue = scaleValue;
    emit scaleValueChanged();
}

ComposeNotes *ComposeTool::notes()
{
    return m_notes;
}

void ComposeTool::togglePlayPause()
{
    switch (this->state()) {
    case NotRunning:
        if (currentTime() != 0 && currentTime() != duration()) {
            resume();
        } else if (currentTime() == duration()) {
            stop();
            setCurrentTime(0);
            start();
        } else {
            if (currentTime() == 0) {
                playTickNotes(0);
                if (m_enableMetronome)
                    m_tickSound->play();
            }

            start();
        }
        break;
    case Paused:
        setPaused(false);
        break;
    case Running:
        setPaused(true);
    default:
        break;
    }
}

ComposeNote *ComposeTool::getComposeNote(const int &index)
{
    return m_notes->get(calculateCoordinate(index));
}

bool ComposeTool::hasComposeNote(const int &index) const
{
    foreach (ComposeNote *note, m_notes->composeNotes()) {
        if (note->coordinate() == calculateCoordinate(index))
            return true;
    }

    return false;
}

void ComposeTool::clearNotes()
{
    m_notes->clearModel();
}

void ComposeTool::newSong(const QString &songName)
{
    if (songs().contains(songName)) {
        qWarning() << "Song name already exists";
        return;
    }

    if (songName.isEmpty()) {
        qWarning() << "Empty song name. Do nothing";
        return;
    }

    qDebug() << "New song:" << songName;
    m_notes->clearModel();

    setCurrentSong(songName);

    setSongName(songName);
    setMeasureCount(10);
    setTrackCount(4);
    setBpm(120);
    setRhythmTicks(4);
    setRhythmBeats(4);
    setEnableMetronome(false);
    setScaleValue(1.0);

    save();
}

void ComposeTool::save()
{
    QString fileName = m_outputDir.canonicalPath() + "/" + m_songName + ".json";
    qDebug() << "Save song" << fileName;
    QFile songFile(fileName);
    if (!songFile.exists())
        qDebug() << "Create new song file" << fileName;

    if (!songFile.open(QFile::WriteOnly)) {
        qWarning() << "Could not open song file" << fileName;
        return;
    }

    // Clear old content
    songFile.resize(0);

    QVariantMap songMap;
    songMap.insert("songName", m_songName);
    songMap.insert("measureCount", m_measureCount);
    songMap.insert("trackCount", m_trackCount);
    songMap.insert("bpm", m_bpm);
    songMap.insert("rythmTicks", m_rythmTicks);
    songMap.insert("rythmBeats", m_rythmBeats);
    songMap.insert("enableMetronome", m_enableMetronome);
    songMap.insert("scaleValue", m_scaleValue);
    QVariantList noteList;
    for (int i = 0; i < notes()->count(); i++) {
        ComposeNote *note = m_notes->composeNotes().at(i);
        QVariantMap noteMap;
        noteMap.insert("note", note->note());
        noteMap.insert("source", note->source());
        noteMap.insert("x", note->coordinate().x());
        noteMap.insert("y", note->coordinate().y());
        noteList.append(noteMap);
    }
    songMap.insert("notes", noteList);

    songFile.write(QJsonDocument::fromVariant(songMap).toJson(QJsonDocument::Indented));
    songFile.close();
}

void ComposeTool::saveAs(const QString &songName)
{
    setSongName(songName);
    setCurrentSong(songName);
    save();
}

void ComposeTool::load(const QString &songName)
{
    if (!songs().contains(songName))
        return;

    qDebug() << "Load saved song" << songName << "from" << m_outputDir.canonicalPath();

    m_notes->clearModel();
    setCurrentSong(songName);

    m_outputDir.setFilter(QDir::Files);
    m_outputDir.setSorting(QDir::Name);
    foreach (const QFileInfo &fileInfo, m_outputDir.entryInfoList()) {
        if (!fileInfo.fileName().endsWith(".json"))
            continue;


        if (fileInfo.fileName().split(".").first() == songName) {
            loadSong(fileInfo.canonicalFilePath());
            return;
        }
    }
    qWarning() << "Could not find a song file for" << songName;
}

void ComposeTool::loadExample(const QString &songName)
{
    if (!exampleSongs().contains(songName))
        return;

    QDir exampleDir(Core::instance()->dataDir().canonicalPath() + "/examples/");
    qDebug() << "Load example song" << songName << "from" << exampleDir.canonicalPath();

    m_notes->clearModel();
    setCurrentSong(songName);

    exampleDir.setFilter(QDir::Files);
    exampleDir.setSorting(QDir::Name);
    foreach (const QFileInfo &fileInfo, exampleDir.entryInfoList()) {
        if (!fileInfo.fileName().endsWith(".json"))
            continue;

        if (fileInfo.fileName().split(".").first() == songName) {
            loadSong(fileInfo.canonicalFilePath());
            return;
        }
    }

    qWarning() << "Could not find example song for" << songName;
}

void ComposeTool::renameSong(const QString &songName)
{
    qDebug() << "Rename song:" << m_songName << "-->" << songName;

    if (songName.isEmpty()) {
        qWarning() << "Empty song name: keep ols song name.";
        return;
    }

    if (m_songName == songName) {
        qDebug() << "Song name unchanged: nothing to do";
        return;
    }

    if (songs().contains(songName)) {
        qDebug() << "Song name unchanged: nothing to do";
        return;
    }

    QString currentSongName = m_songName;
    setSongName(songName);
    setCurrentSong(songName);
    save();
    loadCurrentSettings();
    deleteSong(currentSongName);
}

void ComposeTool::deleteSong(const QString &songName)
{
    qDebug() << "Delete song" << songName;
    m_outputDir.setFilter(QDir::Files);
    m_outputDir.setSorting(QDir::Name);

    foreach (const QFileInfo &fileInfo, m_outputDir.entryInfoList()) {
        if (!fileInfo.fileName().endsWith(".json"))
            continue;

        if (fileInfo.fileName().split(".").first() == songName) {
            if (!QFile::remove(fileInfo.canonicalFilePath())) {
                qWarning() << "Could not delete" << fileInfo.canonicalFilePath();
                return;
            }
        }
    }

    if (songs().isEmpty()) {
        newSong(tr("New song"));
    } else {
        load(songs().first());
    }

}

void ComposeTool::setCurrentSong(const QString &songName)
{
    QSettings settings;
    settings.beginGroup("composeTool");
    settings.setValue("currentSong", songName);
    settings.endGroup();
}

void ComposeTool::addNote(const int &index, const int &note, const QString &source)
{
    QPoint coordinate = calculateCoordinate(index);
    if (coordinate.x() < 0 || coordinate.y() < 0)
        return;

    ComposeNote *composeNote = new ComposeNote(this);
    composeNote->setNote((Music::Note)note);
    composeNote->setSource(source);
    composeNote->setCoordinate(coordinate);

    qDebug() << index << "-->" << calculateCoordinate(index);
    m_notes->addComposeNote(composeNote);
    save();
}

void ComposeTool::removeNote(const int &index)
{
    m_notes->removeComposeNote(calculateCoordinate(index));
    save();
}

void ComposeTool::moveNote(const int &oldIndex, const int &newIndex)
{
    if (!hasComposeNote(oldIndex))
        return;

    m_notes->move(calculateCoordinate(oldIndex), calculateCoordinate(newIndex));
    save();
}

void ComposeTool::setup()
{
    m_tickSound = new QSoundEffect(this);
    m_tickSound->setSource(QUrl::fromLocalFile(Core::instance()->dataDir().path() + "/sounds/metronome/tick.wav"));

    m_tockSound = new QSoundEffect(this);
    m_tockSound->setSource(QUrl::fromLocalFile(Core::instance()->dataDir().path() + "/sounds/metronome/tock.wav"));
}

void ComposeTool::onFrameChanged(const int &frame)
{
    setPositionPercentage(currentTime() * 1.0 / m_songDuration);
    qDebug() << "Frame" << frame << currentTime() << positionPercentage();

    if (m_playing)
        playTickNotes(frame);

    if (!m_enableMetronome || !m_playing)
        return;

    if (frame % m_rythmTicks != 0) {
        qDebug() << "Tock";
        m_tockSound->play();
    } else {
        qDebug() << "Tick";
        m_tickSound->play();
    }
}

void ComposeTool::setPlaying(const bool &playing)
{
    m_playing = playing;
    emit playingChanged();
}

void ComposeTool::setPositionPercentage(const qreal &positionPercentage)
{
    m_positionPercentage = positionPercentage;
    emit positionPercentageChanged();
}

void ComposeTool::setSongDuration(const int &songDuration)
{
    m_songDuration = songDuration;
    setDuration(m_songDuration);
    emit songDurationChanged();
}

void ComposeTool::setTickIntervall(const int &tickIntervall)
{
    m_tickIntervall = tickIntervall;
    emit tickIntervallChanged();
}

void ComposeTool::setMeasureIntervall(const int &measureIntervall)
{
    m_measureIntervall = measureIntervall;
    emit measureIntervallChanged();
}

void ComposeTool::calculateTimings()
{
    // Calculate one time slot
    setTickIntervall(qRound(60000.0 / m_bpm));

    // Calculate how long is one measure
    setMeasureIntervall(m_rythmTicks * m_tickIntervall);

    // Calculate how long the song is
    setSongDuration(m_measureCount * m_measureIntervall);

    // Reconfigure TimeLine
    setFrameRange(0, m_songDuration / m_tickIntervall);
    qDebug() << "BPM:" << m_bpm << " dt:" << m_tickIntervall << "measure dt:" << m_measureIntervall << " measures:" << m_measureCount << " duration:" << songDurationString();

    // Remove notes which are out of range
    foreach (ComposeNote *note, m_notes->composeNotes()) {
        if (note->coordinate().x() >= columnCount() || note->coordinate().y() >= rowCount()) {
            m_notes->removeComposeNote(note->coordinate());
        }
    }

    emit trackCountChanged();
    emit measureCountChanged();
    emit rythmTicksChanged();
    emit timingsChanged();
}

void ComposeTool::loadCurrentSettings()
{
    QSettings settings;
    settings.beginGroup("composeTool");
    QString currentSongName = settings.value("currentSong").toString();
    settings.endGroup();

    if (currentSongName.isEmpty()) {
        if (!songs().isEmpty()) {
            currentSongName = songs().first();
        } else {
            currentSongName = tr("New song");
        }
    }

    load(currentSongName);

    calculateTimings();
    emit songLoaded();
    emit songsChanged();
}


void ComposeTool::playTickNotes(const int &tick)
{
    foreach (ComposeNote *note, m_notes->composeNotes()) {
        if (note->coordinate().x() == tick) {
            qDebug() << "Play" << note->source();
            Core::instance()->notePlayer()->play(QUrl::fromLocalFile(Core::instance()->dataDir().path() + "/sounds/guitar/" + note->source()).toString());
            note->plucked();
        }
    }
}

void ComposeTool::loadSong(const QString &songFileName)
{
    qDebug() << "Loading" << songFileName;
    QFile songFile(songFileName);
    if (!songFile.open(QFile::ReadOnly)) {
        qWarning() << "Could not open song file" << songFileName;
        return;
    }

    QByteArray songData = songFile.readAll();
    qDebug() << qUtf8Printable(songData);

    QJsonParseError error;
    QVariantMap songMap = QJsonDocument::fromJson(songData, &error).toVariant().toMap();
    if (error.error != QJsonParseError::NoError) {
        qWarning() << "Json error in song file" << songFileName << error.errorString();
        return;
    }

    setSongName(songMap.value("songName", tr("New song")).toString());
    setMeasureCount(songMap.value("measureCount", 10).toInt());
    setTrackCount(songMap.value("trackCount", 4).toInt());
    setBpm(songMap.value("bpm", 120).toInt());
    setRhythmTicks(songMap.value("rythmTicks", 4).toInt());
    setRhythmBeats(songMap.value("rythmBeats", 4).toInt());
    setEnableMetronome(songMap.value("enableMetronome", false).toBool());
    setScaleValue(songMap.value("scaleValue", 1.0).toDouble());

    foreach (const QVariant &noteVariant, songMap.value("notes").toList()) {
        QVariantMap noteMape = noteVariant.toMap();
        ComposeNote *composeNote = new ComposeNote(this);
        composeNote->setNote((Music::Note)noteMape.value("note").toInt());
        composeNote->setSource(noteMape.value("source").toString());
        composeNote->setCoordinate(QPoint(noteMape.value("x").toInt(), noteMape.value("y").toInt()));
        m_notes->addComposeNote(composeNote);
    }

    calculateTimings();
    emit songLoaded();
}

QPoint ComposeTool::calculateCoordinate(const int &index) const
{
    return QPoint(index % columnCount(), index / columnCount());
}

void ComposeTool::onValueChanged(const qreal &value)
{
    Q_UNUSED(value)
    setPositionPercentage(currentTime() * 1.0 / m_songDuration);
    emit currentTimeStringChanged();
}

void ComposeTool::onStateChanged(const QTimeLine::State &state)
{
    switch (state) {
    case NotRunning:
        setPlaying(false);
        qDebug() << "Compose tool stop";
        break;
    case Paused:
        setPlaying(false);
        qDebug() << "Compose tool paused";
        break;
    case Running:
        setPlaying(true);
        qDebug() << "Compose tool running";
    default:
        break;
    }
}
