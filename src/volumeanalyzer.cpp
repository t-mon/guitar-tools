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

#include "volumeanalyzer.h"
#include "analyzer.h"

VolumeAnalyzer::VolumeAnalyzer(const QAudioFormat &format, QObject *parent) :
    QIODevice(parent),
    m_format(format)
{

}

qint64 VolumeAnalyzer::readData(char *data, qint64 maxlen)
{
    Q_UNUSED(data);
    Q_UNUSED(maxlen);

    return 0;
}

qint64 VolumeAnalyzer::writeData(const char *data, qint64 maxlen)
{
    int channelBytes = m_format.sampleSize() / 8;
    if (maxlen % channelBytes != 0) {
        qWarning() << "Invalid data size. Rejecting data.";
        return maxlen;
    }

    int maxValue = 0;

    // walk trough the data (16 bit data)
    for(int i = 0; i < maxlen; i += 2) {
        uchar valueArray[2];
        valueArray[0] = (uchar)data[i];
        valueArray[1] = (uchar)data[i+1];
        qint16 value = Analyzer::getValueInt16(m_format, valueArray);
        if (maxValue < qAbs(value)) {
            maxValue = qAbs(value);
        }
    }

    // calculate the average volume for this data package
    m_volumeLevel = 100.0 * maxValue / Analyzer::getPeakValue(m_format);
    emit volumeLevelChanged();

    return maxlen;
}

bool VolumeAnalyzer::start()
{
    return open(QIODevice::WriteOnly);
}

void VolumeAnalyzer::stop()
{
    close();
}

double VolumeAnalyzer::volumeLevel() const
{
    return m_volumeLevel;
}


