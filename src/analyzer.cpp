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

#include <QtEndian>
#include <math.h>

#include "analyzer.h"

Analyzer::Analyzer(const QAudioFormat &format, QObject *parent) :
    QIODevice(parent),
    m_format(format),
    m_fft(NULL)
{
    m_samples.reserve(FFT_SIZE);
    setPitchStandard(440);

    initFft();
}

Analyzer::~Analyzer()
{
    destroyfft(m_fft);
}

qint64 Analyzer::readData(char *data, qint64 maxlen)
{
    Q_UNUSED(data);
    Q_UNUSED(maxlen);

    return 0;
}

qint64 Analyzer::writeData(const char *data, qint64 maxlen)
{
    int channelBytes = m_format.sampleSize() / 8; // 2
    int sum = 0;

    if (maxlen % channelBytes != 0) {
        qWarning() << "Invalid data size. Rejecting data.";
        return maxlen;
    }

    // walk trough the data (16 bit data)
    for(int i = 0; i < maxlen; i += 2) {
        if (m_samples.size() < FFT_SIZE) {
            uchar valueArray[2];
            valueArray[0] = (uchar)data[i];
            valueArray[1] = (uchar)data[i+1];
            qint16 value = Analyzer::getValueInt16(m_format, valueArray);

            // Normalize the value [-1 < x < 1]
            float valueFloat = 1.0 * value / Analyzer::getPeakValue(m_format);
            m_samples.append(valueFloat);

            // Sum for the volume average
            sum += qAbs(value);
        } else {
            analyze(m_samples);
            m_samples.clear();
            m_samples.reserve(FFT_SIZE);
        }
    }

    // Prevent division / 0
    if (maxlen > 0) {
        // calculate the average volume for this data package
        double volume = (double)sum / maxlen;
        m_volumeLevel = 100.0 * volume / Analyzer::getPeakValue(m_format);
        emit volumeLevelChanged();
    }

    return maxlen;
}

bool Analyzer::start()
{
    bool started = open(QIODevice::WriteOnly);
    qDebug() << "Open analyzer:" << started;
    return started;
}

void Analyzer::stop()
{
    m_samples.clear();
    m_samples.reserve(FFT_SIZE);
    close();
}

void Analyzer::setPitchStandard(const int &pitchStandard)
{
    if (m_pitchStandard == pitchStandard)
        return;

    m_pitchStandard = pitchStandard;

    qDebug() << "Calculate frequency table for" << m_pitchStandard << "Hz";

    // Init
    for (int i = 0; i < FFT_SIZE; ++i) {
        m_samples.append(0.0);

        // init note / pitch table
        m_notePitchTable[i] = -1;
        m_noteTable[i] = Music::NoteNone;

        // init frequency table
        m_freqTable[i] = (m_format.sampleRate() * i) / (float) (FFT_SIZE);
    }

    // Fill pitch, frequency and note table
    for (int i=0; i < 127; ++i) {
        float pitch = (m_pitchStandard / 32.0 ) * pow(2, (i - 9.0) / 12.0) ;
        if (pitch > m_format.sampleRate() / 2.0 )
            break;

        // find closest data
        float min = 1000000000.0;
        int index = -1;
        for (int j = 0; j < FFT_SIZE; ++j) {
            if (qAbs(m_freqTable[j] - pitch) < min) {
                min = qAbs(m_freqTable[j] - pitch);
                index = j;
            }
        }
        m_noteTable[index] = (Music::Note)(i % 12);
        m_notePitchTable[index] = pitch;
        //qDebug() << m_notePitchTable[index] << "       " <<  Music::noteToString(m_noteTable[index]);
    }
}

double Analyzer::volumeLevel() const
{
    return m_volumeLevel;
}

qint16 Analyzer::getValueInt16(const QAudioFormat &format, const uchar *ptr)
{
    qint16 realValue = 0;
    if (format.sampleSize() == 8) {
        const qint16 value = *reinterpret_cast<const quint8*>(ptr);
        if (format.sampleType() == QAudioFormat::UnSignedInt) {
            realValue = value - Analyzer::getPeakValue(format) - 1;
        } else if (format.sampleType() == QAudioFormat::SignedInt) {
            realValue = value;
        }
    } else if (format.sampleSize() == 16) {
        qint16 value = 0;
        if (format.byteOrder() == QAudioFormat::LittleEndian) {
            value = qFromLittleEndian<quint16>(ptr);
        } else {
            value = qFromBigEndian<quint16>(ptr);
        }

        if (format.sampleType() == QAudioFormat::UnSignedInt) {
            realValue = value - Analyzer::getPeakValue(format);
        } else if (format.sampleType() == QAudioFormat::SignedInt) {
            realValue = value;
        }
    }
    return realValue;
}

double Analyzer::getPeakValue(const QAudioFormat &format)
{
    if (!format.isValid())
        return double(0);

    if (format.codec() != "audio/pcm")
        return double(0);

    switch (format.sampleType()) {
    case QAudioFormat::Unknown:
        break;
    case QAudioFormat::Float:
        if (format.sampleSize() != 32)
            return double(0);
        return double(1.00003);
    case QAudioFormat::SignedInt:
        if (format.sampleSize() == 32)
            return double(INT_MAX);
        if (format.sampleSize() == 16)
            return double(SHRT_MAX);
        if (format.sampleSize() == 8)
            return double(CHAR_MAX);
        break;
    case QAudioFormat::UnSignedInt:
        if (format.sampleSize() == 32)
            return double(UINT_MAX);
        if (format.sampleSize() == 16)
            return double(USHRT_MAX);
        if (format.sampleSize() == 8)
            return double(UCHAR_MAX);
        break;
    }

    return double(0);
}

void Analyzer::initFft()
{
    // Copyright (C) 2012 by Bjorn Roche
    buildHanWindow(m_window, FFT_SIZE);
    m_fft = initfft(FFT_EXP_SIZE);

    computeSecondOrderLowPassParameters(m_format.sampleRate(), 330, a, b);
    mem1[0] = 0; mem1[1] = 0; mem1[2] = 0; mem1[3] = 0;
    mem2[0] = 0; mem2[1] = 0; mem2[2] = 0; mem2[3] = 0;
}

void Analyzer::analyze(const QList<float> &data)
{
    // copy new data into fft container
    for (int i = 0; i < FFT_SIZE; ++i)
        m_data[i] = data.at(i);

    // Copyright (C) 2012 by Bjorn Roche
    // Filter the new data
    for (int j = 0; j < FFT_SIZE; ++j) {
        m_data[j] = processSecondOrderFilter( m_data[j], mem1, a, b );
        m_data[j] = processSecondOrderFilter( m_data[j], mem2, a, b );
    }

    // Apply Han Window on data
    applyWindow(m_window, m_data, FFT_SIZE);

    for(int j = 0; j < FFT_SIZE; ++j)
        m_datai[j] = 0;

    // Acalculate FFT data
    applyfft(m_fft, m_data, m_datai, false);

    //find the peak in FFT data
    float maxVal = -1;
    int maxIndex = -1;
    for (int j = 0; j < FFT_SIZE / 2; ++j) {
        float v = m_data[j] * m_data[j] + m_datai[j] * m_datai[j] ;
        if (v > maxVal) {
            maxVal = v;
            maxIndex = j;
        }
    }

    float magnitude = sqrt(maxVal);
    float freq = m_freqTable[maxIndex];

    //find the nearest note:
    int nearestNoteDelta=0;
    while (true) {
        if (nearestNoteDelta < maxIndex && m_noteTable[maxIndex - nearestNoteDelta] != Music::NoteNone) {
            nearestNoteDelta = -nearestNoteDelta;
            break;
        } else if (nearestNoteDelta + maxIndex < FFT_SIZE && m_noteTable[maxIndex + nearestNoteDelta] != Music::NoteNone) {
            break;
        }
        nearestNoteDelta++;
    }

    Music::Note nearestNote = m_noteTable[maxIndex + nearestNoteDelta];
    float nearestNotePitch = m_notePitchTable[maxIndex + nearestNoteDelta];
    float centsSharp = 1200 * log( freq / nearestNotePitch ) / log( 2.0 );

    qDebug() << Music::noteToString(nearestNote) << nearestNotePitch << centsSharp << magnitude;

    emit frequencyChanged(freq);
    emit targetFrequencyChanged(nearestNotePitch);
    emit noteChanged(nearestNote);
    emit centValueChanged(centsSharp);
}


void Analyzer::setVolumeLevel(const double &volumeLevel)
{
    m_volumeLevel = volumeLevel;
    emit volumeLevelChanged();
}

// Copyright (C) 2012 by Bjorn Roche
void Analyzer::buildHammingWindow(float *window, int size)
{
    for( int i=0; i<size; ++i )
        window[i] = .54 - .46 * cos( 2 * M_PI * i / (float) size );
}

// Copyright (C) 2012 by Bjorn Roche
void Analyzer::buildHanWindow(float *window, int size)
{
    for( int i=0; i<size; ++i )
        window[i] = .5 * ( 1 - cos( 2 * M_PI * i / (size-1.0) ) );
}

// Copyright (C) 2012 by Bjorn Roche
void Analyzer::applyWindow(float *window, float *data, int size)
{
    for( int i=0; i<size; ++i )
        data[i] *= window[i] ;
}

// Copyright (C) 2012 by Bjorn Roche
void Analyzer::computeSecondOrderLowPassParameters(float srate, float f, float *a, float *b)
{
    float a0;
    float w0 = 2 * M_PI * f/srate;
    float cosw0 = cos(w0);
    float sinw0 = sin(w0);
    float alpha = sinw0/2 * sqrt(2);

    a0   = 1 + alpha;
    a[0] = (-2 * cosw0) / a0;
    a[1] = (1 - alpha) / a0;
    b[0] = ((1 - cosw0) / 2) / a0;
    b[1] = (1 - cosw0) / a0;
    b[2] = b[0];
}

// Copyright (C) 2012 by Bjorn Roche
float Analyzer::processSecondOrderFilter(float x, float *mem, float *a, float *b)
{
    float ret = b[0] * x + b[1] * mem[0] + b[2] * mem[1] - a[0] * mem[2] - a[1] * mem[3] ;
    mem[1] = mem[0];
    mem[0] = x;
    mem[3] = mem[2];
    mem[2] = ret;
    return ret;
}


