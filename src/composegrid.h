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

#ifndef COMPOSEGRID_H
#define COMPOSEGRID_H

#include <QColor>
#include <QObject>
#include <QPainter>
#include <QQuickPaintedItem>

class ComposeGrid : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(int measureCount READ measureCount WRITE setMeasureCount NOTIFY measureCountChanged)
    Q_PROPERTY(int trackCount READ trackCount WRITE setTrackCount NOTIFY trackCountChanged)
    Q_PROPERTY(int rythmTicks READ rythmTicks WRITE setRhythmTicks NOTIFY rythmTicksChanged)

public:
    ComposeGrid(QQuickItem *parent = 0);
    void paint(QPainter *painter);

    QColor color() const;
    void setColor(const QColor &color);

    int rythmTicks() const;
    void setRhythmTicks(const int &rythmTicks);

    int measureCount() const;
    void setMeasureCount(const int &measureCount);

    int trackCount() const;
    void setTrackCount(const int &trackCount);

private:
    QColor m_color;
    int m_rythmTicks;
    int m_measureCount;
    int m_trackCount;

signals:
    void colorChanged();
    void measureCountChanged();
    void trackCountChanged();
    void rythmTicksChanged();

};

#endif // COMPOSEGRID_H
