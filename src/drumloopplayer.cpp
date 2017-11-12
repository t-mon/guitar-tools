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

#include "drumloopplayer.h"

#include <QFile>
#include <QDebug>
#include <QStandardPaths>
#include <QtConcurrent/QtConcurrent>

#ifdef SOUNDTOUCH
using namespace soundtouch;
#endif

DrumLoopPlayer::DrumLoopPlayer(const double &volume, QObject *parent) :
    QObject(parent),
    m_soundEffect(0),
    m_inputFileName(QString()),
    m_outputFileName(QStandardPaths::writableLocation(QStandardPaths::DataLocation) + "/transformed-loop.wav"),
    m_watcher(new QFutureWatcher<void>(this)),
    m_volume(volume),
    m_bpm(100),
    m_measuredBpm(100),
    m_fileChanged(false)
{
#ifdef SOUNDTOUCH
    qDebug() << "SoundTouch library version" << SoundTouch::getVersionString();
#endif
    connect(m_watcher, SIGNAL(finished()), this, SLOT(processFinished()));
}

DrumLoopPlayer::~DrumLoopPlayer()
{

}

int DrumLoopPlayer::bpm() const
{
    return m_bpm;
}

void DrumLoopPlayer::setBpm(const int &bpm)
{
    m_bpm = bpm;
    emit bpmChanged();

    if (!m_soundEffect)
        return;

    stop();
    play(m_inputFileName);
}

int DrumLoopPlayer::originalBpm() const
{
    return m_measuredBpm;
}

int DrumLoopPlayer::minBpm() const
{
    return m_measuredBpm - 11;
}

int DrumLoopPlayer::maxBpm() const
{
    return m_measuredBpm + 9;
}

void DrumLoopPlayer::stop()
{
    if (!m_soundEffect)
        return;

    qDebug() << "Stop playing drum loops";
    m_soundEffect->stop();
    delete m_soundEffect;
    m_soundEffect = 0;
}

double DrumLoopPlayer::volume() const
{
    return m_volume;
}

void DrumLoopPlayer::setVolume(const int &volume)
{
    m_volume = volume / 100.0;
    if (m_soundEffect)
        m_soundEffect->setVolume(m_volume);

}

bool DrumLoopPlayer::playing() const
{
    if (m_soundEffect)
        return m_soundEffect->isPlaying();

    return false;
}

void DrumLoopPlayer::play(const QString &filePath)
{
    qDebug() << "Play" << filePath;
    if (m_inputFileName != filePath) {
        m_inputFileName = filePath;
        m_fileChanged = true;
    } else {
        m_fileChanged = false;
    }
     m_watcher->setFuture(QtConcurrent::run(this, &DrumLoopPlayer::processFile));
}

void DrumLoopPlayer::processFile()
{
#ifdef SOUNDTOUCH
    qDebug() << "Start processing" << m_inputFileName;
    WavInFile *inputFile = new WavInFile(m_inputFileName.toStdString().c_str());

    int bits = (int)inputFile->getNumBits();
    int sampleRate = (int)inputFile->getSampleRate();
    int channels = (int)inputFile->getNumChannels();

    QFile outFile(m_outputFileName);
    if (outFile.exists())
        outFile.remove();

    WavOutFile *outputFile = new WavOutFile(m_outputFileName.toStdString().c_str(), sampleRate, bits, channels);

    float measuredBpm = 0;
    BPMDetect bpm(inputFile->getNumChannels(), inputFile->getSampleRate());
    SAMPLETYPE sampleBuffer[BUFF_SIZE];

    while (inputFile->eof() == 0) {
        int num, samples;

        // Read sample data from input file
        num = inputFile->read(sampleBuffer, BUFF_SIZE);

        // Enter the new samples to the bpm analyzer class
        samples = num / channels;
        bpm.inputSamples(sampleBuffer, samples);
    }

    // Now the whole song data has been analyzed. Read the resulting bpm.
    measuredBpm = bpm.getBpm();

    // rewind the file after bpm detection
    inputFile->rewind();

    if (measuredBpm < 0) {
        qWarning() << "Couldn't detect BPM rate.";
        return;
    }
    qDebug() << "Detected BPM rate" << measuredBpm;

    m_measuredBpm = qRound(measuredBpm);
    emit minBpmChanged();
    emit maxBpmChanged();

    if (m_fileChanged) {
        m_bpm = m_measuredBpm;
        emit bpmChanged();
    }

    SoundTouch *soundTouch = new SoundTouch;
    soundTouch->setSampleRate(sampleRate);
    soundTouch->setChannels(channels);

    soundTouch->setTempoChange((m_bpm / measuredBpm - 1.0f) * 100.0f);
    soundTouch->setPitchSemiTones(0);
    soundTouch->setRateChange(0);

    soundTouch->setSetting(SETTING_USE_QUICKSEEK, 0);
    soundTouch->setSetting(SETTING_USE_AA_FILTER, 0);

    int nSamples;
    int buffSizeSamples = BUFF_SIZE / channels;
    // Process samples read from the input file
    while (inputFile->eof() == 0) {

        // Read a chunk of samples from the input file
        int num = inputFile->read(sampleBuffer, BUFF_SIZE);
        nSamples = num / (int)inputFile->getNumChannels();

        // Feed the samples into SoundTouch processor
        soundTouch->putSamples(sampleBuffer, nSamples);

        do {
            nSamples = soundTouch->receiveSamples(sampleBuffer, buffSizeSamples);
            outputFile->write(sampleBuffer, nSamples * channels);
        } while (nSamples != 0);
    }

    // Now the input file is processed, yet 'flush' few last samples that are
    // hiding in the SoundTouch's internal processing pipeline.
    soundTouch->flush();
    do {
        nSamples = soundTouch->receiveSamples(sampleBuffer, buffSizeSamples);
        outputFile->write(sampleBuffer, nSamples * channels);
    } while (nSamples != 0);

    delete outputFile;
    outputFile = 0;
    delete inputFile;
    inputFile = 0;
    delete soundTouch;
    soundTouch = 0;
#else
    QFile::copy(m_inputFileName, m_outputFileName);
#endif
}

void DrumLoopPlayer::processFinished()
{
    qDebug() << "File processing finished.";

    if (m_soundEffect)
        delete m_soundEffect;

    m_soundEffect = new QSoundEffect(this);

    connect(m_soundEffect, SIGNAL(playingChanged()), this, SIGNAL(playingChanged()));

    m_soundEffect->setLoopCount(QSoundEffect::Infinite);
    m_soundEffect->setVolume(m_volume);
    m_soundEffect->setSource(QUrl::fromLocalFile(m_outputFileName));
    m_soundEffect->play();
}

