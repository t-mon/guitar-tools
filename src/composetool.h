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

#ifndef COMPOSETOOL_H
#define COMPOSETOOL_H

#include <QDir>
#include <QObject>
#include <QTimeLine>
#include <QSoundEffect>

#include "composenotes.h"

class ComposeTool : public QTimeLine
{
    Q_OBJECT
    Q_PROPERTY(QString songName READ songName WRITE setSongName NOTIFY songNameChanged)
    Q_PROPERTY(QString compositore READ compositore WRITE setCompositore NOTIFY compositoreChanged)
    Q_PROPERTY(QStringList songs READ songs NOTIFY songsChanged)
    Q_PROPERTY(int measureCount READ measureCount WRITE setMeasureCount NOTIFY measureCountChanged)
    Q_PROPERTY(int rowCount READ rowCount NOTIFY measureCountChanged)
    Q_PROPERTY(int trackCount READ trackCount WRITE setTrackCount NOTIFY trackCountChanged)
    Q_PROPERTY(int columnCount READ columnCount NOTIFY trackCountChanged)
    Q_PROPERTY(int songDuration READ songDuration NOTIFY songDurationChanged)
    Q_PROPERTY(QString songDurationString READ songDurationString NOTIFY songDurationChanged)
    Q_PROPERTY(int bpm READ bpm WRITE setBpm NOTIFY bpmChanged)
    Q_PROPERTY(int rythmTicks READ rythmTicks WRITE setRhythmTicks NOTIFY rythmTicksChanged)
    Q_PROPERTY(int rythmBeats READ rythmBeats WRITE setRhythmBeats NOTIFY rythmBeatsChanged)
    Q_PROPERTY(int tickIntervall READ tickIntervall NOTIFY tickIntervallChanged)
    Q_PROPERTY(int measureIntervall READ measureIntervall NOTIFY measureIntervallChanged)
    Q_PROPERTY(bool playing READ playing NOTIFY playingChanged)
    Q_PROPERTY(qreal positionPercentage READ positionPercentage NOTIFY positionPercentageChanged)
    Q_PROPERTY(QString currentTimeString READ currentTimeString NOTIFY currentTimeStringChanged)
    Q_PROPERTY(bool enableMetronome READ enableMetronome WRITE setEnableMetronome NOTIFY enableMetronomeChanged)
    Q_PROPERTY(qreal scaleValue READ scaleValue WRITE setScaleValue NOTIFY scaleValueChanged)
    Q_PROPERTY(ComposeNotes *notes READ notes CONSTANT)

public:
    explicit ComposeTool(QObject *parent = 0);

    // Song properties
    QString songName() const;
    void setSongName(const QString &songName);

    QString compositore() const;
    void setCompositore(const QString &compositore);

    QStringList songs();
    Q_INVOKABLE QStringList exampleSongs();

    int measureCount() const;
    int rowCount() const;
    void setMeasureCount(const int &measureCount);

    int trackCount() const;
    int columnCount() const;
    void setTrackCount(const int &trackCount);

    int songDuration() const;
    QString songDurationString() const;

    int bpm() const;
    void setBpm(const int &bpm);

    int rythmTicks() const;
    void setRhythmTicks(const int &rythmTicks);

    int rythmBeats() const;
    void setRhythmBeats(const int &rythmBeats);

    int tickIntervall() const;
    int measureIntervall() const;
    QString currentTimeString() const;

    qreal scaleValue() const;
    void setScaleValue(const qreal &scaleValue);

    // Metronome
    bool enableMetronome() const;
    void setEnableMetronome(const bool &enableMetronome);

    // TimeLine methods
    bool playing() const;
    qreal positionPercentage() const;

    ComposeNotes *notes();

    Q_INVOKABLE void togglePlayPause();

    Q_INVOKABLE void addNote(const int &index, const int &note, const QString &source);
    Q_INVOKABLE void removeNote(const int &index);
    Q_INVOKABLE void moveNote(const int &oldIndex, const int &newIndex);
    Q_INVOKABLE QPoint calculateCoordinate(const int &index) const;

    Q_INVOKABLE ComposeNote *getComposeNote(const int &index);
    Q_INVOKABLE bool hasComposeNote(const int &index) const;
    Q_INVOKABLE void clearNotes();

    Q_INVOKABLE void newSong(const QString &songName);
    Q_INVOKABLE void save();
    Q_INVOKABLE void saveAs(const QString &songName);
    Q_INVOKABLE void load(const QString &songName);
    Q_INVOKABLE void loadExample(const QString &songName);
    Q_INVOKABLE void renameSong(const QString &songName);
    Q_INVOKABLE void deleteSong(const QString &songName);


private:
    ComposeNotes *m_notes;
    bool m_playing;

    QString m_songName;
    QString m_compositore;
    int m_measureCount;
    int m_trackCount;
    int m_songDuration;
    int m_bpm;
    int m_rythmTicks;
    int m_rythmBeats;
    int m_tickIntervall;
    int m_measureIntervall;

    bool m_enableMetronome;
    qreal m_positionPercentage;
    qreal m_scaleValue;

    QSoundEffect *m_tickSound;
    QSoundEffect *m_tockSound;

    QDir m_outputDir;

    // Song time properties
    void setCurrentSong(const QString &songName);
    void setSongDuration(const int &songDuration);
    void setTickIntervall(const int &tickIntervall);
    void setMeasureIntervall(const int &measureIntervall);

    // TimeLine properties
    void setPlaying(const bool &playing);
    void setPositionPercentage(const qreal &positionPercentage);

    void calculateTimings();

    void loadCurrentSettings();

    void playTickNotes(const int &tick);

    void loadSong(const QString &songFileName);

signals:
    void songNameChanged();
    void compositoreChanged();
    void songsChanged();
    void measureCountChanged();
    void trackCountChanged();
    void songDurationChanged();
    void bpmChanged();
    void rythmTicksChanged();
    void rythmBeatsChanged();
    void tickIntervallChanged();
    void measureIntervallChanged();

    void enableMetronomeChanged();
    void playingChanged();
    void positionPercentageChanged();
    void currentTimeStringChanged();
    void notesChanged();

    void scaleValueChanged();
    void timingsChanged();

    void songLoaded();

private slots:
    void setup();

    void onFrameChanged(const int &frame);
    void onValueChanged(const qreal& value);
    void onStateChanged(const QTimeLine::State &state);
};

#endif // COMPOSETOOL_H
