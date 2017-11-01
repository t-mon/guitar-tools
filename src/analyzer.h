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

#ifndef ANALYZER_H
#define ANALYZER_H

#include <QObject>
#include <QIODevice>
#include <QAudioFormat>
#include <QStringList>
#include <QDebug>

#include "music.h"
#include "libfft.h"

#define FFT_SIZE (8192)
#define FFT_EXP_SIZE (13)

class Analyzer : public QIODevice
{
    Q_OBJECT

public:
    explicit Analyzer(const QAudioFormat &format, QObject *parent = 0);
    ~Analyzer();

    qint64 readData(char *data, qint64 maxlen);
    qint64 writeData(const char *data, qint64 maxlen);

    bool start();
    void stop();

    void setPitchStandard(const int &pitchStandard);

    static qint16 getValueInt16(const QAudioFormat &format, const uchar *ptr);
    static double getPeakValue(const QAudioFormat &format);

    double volumeLevel() const;

private:
    QAudioFormat m_format;

    QList<float> m_samples;
    double m_frequency;
    double m_currentFrequency;
    double m_value;
    double m_volumeLevel;
    bool m_correctFrequency;
    int m_pitchStandard;

    // FFT variables
    void * m_fft;
    float a[2], b[3], mem1[4], mem2[4];
    float m_data[FFT_SIZE];
    float m_datai[FFT_SIZE];
    float m_window[FFT_SIZE];
    float m_freqTable[FFT_SIZE];
    float m_notePitchTable[FFT_SIZE];
    Music::Note m_noteTable[FFT_SIZE];

    void initFft();
    void analyze(const QList<float> &data);

    void setVolumeLevel(const double &volumeLevel);

    // data windowing
    void buildHammingWindow(float *window, int size);
    void buildHanWindow(float *window, int size);
    void applyWindow(float *window, float *data, int size);

    // filters
    void computeSecondOrderLowPassParameters(float srate, float f, float *a, float *b);
    float processSecondOrderFilter(float x, float *mem, float *a, float *b);

signals:
    void volumeLevelChanged();
    void frequencyChanged(const double &frequency);
    void targetFrequencyChanged(const double &targetFrequency);
    void noteChanged(const Music::Note &note);
    void centValueChanged(const double &centValue);

};

#endif // ANALYZER_H
