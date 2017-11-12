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

#include "recorder.h"
#include "analyzer.h"

#include <QDateTime>

Recorder::Recorder(QObject *parent) :
    QObject(parent),
    m_filePath(QStandardPaths::writableLocation(QStandardPaths::DataLocation) + "/records"),
    m_recordTime("00:00:00"),
    m_volumeLevel(0)
{
    m_audioRecorder = new QAudioRecorder(this);

    qDebug() << "Supported audio codecs:";
    foreach (const QString &codecName, m_audioRecorder->supportedAudioCodecs()) {
        qDebug() << "  ->" << codecName;
    }

    qDebug() << "Supported devices:";
    foreach (const QString &audioInput, m_audioRecorder->audioInputs()) {
        qDebug() << "  ->" << audioInput;
    }

    QAudioEncoderSettings audioSettings;
    // Prefere vobis
    if (m_audioRecorder->supportedAudioCodecs().contains("audio/x-vorbis")) {
        audioSettings.setCodec("audio/x-vorbis");
    } else if (m_audioRecorder->supportedAudioCodecs().contains("audio/vorbis")) {
        audioSettings.setCodec("audio/vorbis");
    } else if (m_audioRecorder->supportedAudioCodecs().contains("aac")) {
        audioSettings.setCodec("aac");
    } else {
        audioSettings.setCodec(m_audioRecorder->supportedAudioCodecs().first());
    }
    audioSettings.setQuality(QMultimedia::HighQuality);

    m_audioRecorder->setAudioSettings(audioSettings);

    m_audioProbe = new QAudioProbe(this);
    m_audioProbe->setSource(m_audioRecorder);

    connect(m_audioProbe, SIGNAL(audioBufferProbed(QAudioBuffer)), this, SLOT(onAudioBufferProbed(QAudioBuffer)));
    connect(m_audioRecorder, SIGNAL(stateChanged(QMediaRecorder::State)), this, SLOT(onStateChanged(QMediaRecorder::State)));
    connect(m_audioRecorder, SIGNAL(durationChanged(qint64)), this, SLOT(onDurationChanged(qint64)));



    QDir dir(m_filePath);
    if (!dir.exists()) {
        dir.mkpath(m_filePath);
    }
}

void Recorder::startRecording()
{
    setRecordTime("00:00:00");
    QString fileName = m_filePath + "/" + QDateTime::currentDateTime().toString("yyyyMMdd-hh-mm-ss-zzz") + ".ogg";
    qDebug() << "Start recording" << fileName;
    m_audioRecorder->setOutputLocation(QUrl(fileName));
    m_audioRecorder->record();
}

void Recorder::stopRecording()
{
    m_audioRecorder->stop();
}

void Recorder::pauseRecording()
{
    m_audioRecorder->pause();
}

void Recorder::resumeRecording()
{
    m_audioRecorder->record();
}

bool Recorder::deleteRecordFile(const QString &fileName)
{
    qDebug() << "Delete record file" << fileName;
    return QFile(fileName).remove();
}

bool Recorder::renameRecordFile(const QString &fileName, const QString &newFileName)
{
    if (newFileName.isEmpty())
        return false;

    qDebug() << "Rename record file" << fileName << "to" << newFileName;
    if (newFileName.endsWith(".ogg")) {
        return QFile(fileName).rename(m_filePath + "/" + newFileName);
    } else {
        return QFile(fileName).rename(m_filePath + "/" + QString(newFileName).append(".ogg"));
    }

}

void Recorder::setMicrophoneVolume(const double &microphoneVolume)
{
    m_audioRecorder->setVolume(microphoneVolume / 100);
    qDebug() << "Recorder volume" << m_audioRecorder->volume();
}

void Recorder::setInputDevice(const QString audioInput)
{
    m_audioRecorder->setAudioInput(audioInput);
}

QString Recorder::filePath() const
{
    return m_filePath;
}

QString Recorder::recordTime() const
{
    return m_recordTime;
}

bool Recorder::running() const
{
    return m_audioRecorder->state() == QAudioRecorder::RecordingState;
}

double Recorder::volumeLevel() const
{
    return m_volumeLevel;
}

void Recorder::setRecordTime(const QString &recordTime)
{
    m_recordTime = recordTime;
    emit recordTimeChanged();
}

void Recorder::setVolumeLevel(const double &volumeLevel)
{
    m_volumeLevel = volumeLevel;
    emit volumeLevelChanged();
}

void Recorder::onAudioBufferProbed(const QAudioBuffer &audioBuffer)
{
    const float *data = audioBuffer.constData<float>();
    double maxValue = 0;
    for(int i = 0; i < audioBuffer.sampleCount(); i++) {
        float value = qAbs(data[i]);
        if (maxValue < value) {
            maxValue = value;
        }
    }

    setVolumeLevel(100.0 * maxValue / Analyzer::getPeakValue(audioBuffer.format()));
}

void Recorder::onDurationChanged(const qint64 &duration)
{
    setRecordTime(QTime::fromMSecsSinceStartOfDay(duration).toString("hh:mm:ss"));
}

void Recorder::onStateChanged(const QMediaRecorder::State &state)
{
    switch (state) {
    case QMediaRecorder::RecordingState:
        qDebug() << "Recorder: Recording";
        emit runningChanged();
        break;
    case QMediaRecorder::PausedState:
        qDebug() << "Recorder: Paused";
        emit runningChanged();
        break;
    case QMediaRecorder::StoppedState:
        qDebug() << "Recorder: Stopped";
        emit runningChanged();
        break;
    default:
        break;
    }
}


