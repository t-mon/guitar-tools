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

#ifndef VOLUMEANALYZER_H
#define VOLUMEANALYZER_H

#include <QObject>
#include <QIODevice>
#include <QAudioFormat>
#include <QtEndian>

class VolumeAnalyzer : public QIODevice
{
    Q_OBJECT
public:
    explicit VolumeAnalyzer(const QAudioFormat &format, QObject *parent = 0);

    qint64 readData(char *data, qint64 maxlen);
    qint64 writeData(const char *data, qint64 maxlen);

    bool start();
    void stop();

    double volumeLevel() const;

private:
    QAudioFormat m_format;
    double m_volumeLevel;

signals:
    void volumeLevelChanged();

};

#endif // VOLUMEANALYZER_H
