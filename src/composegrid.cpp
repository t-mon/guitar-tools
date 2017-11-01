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

#include "composegrid.h"

#include <QPen>
#include <QDebug>

ComposeGrid::ComposeGrid(QQuickItem *parent):
    QQuickPaintedItem(parent),
    m_color(QColor("FF0000"))
{

}

void ComposeGrid::paint(QPainter *painter)
{
    QPen tickPen(m_color);
    tickPen.setWidth(1);

    QPen measurePen(m_color);
    measurePen.setWidth(2);

    int rowCount = m_measureCount * m_rythmTicks;
    for (int x = 1; x < rowCount; x++) {
        if (x % m_rythmTicks == 0) {
            painter->setPen(measurePen);
            painter->drawLine(QPoint(x * width() / rowCount, 0), QPoint(x * width() / rowCount, height()));
        } else {
            painter->setPen(tickPen);
            painter->drawLine(QPoint(x * width() / rowCount, 0), QPoint(x * width() / rowCount, height()));
        }
    }

    for (int y = 1; y < m_trackCount; y++) {
        painter->setPen(tickPen);
        painter->drawLine(QPoint(0, y * height() / trackCount()), QPoint(width(), y * height() / trackCount()));
    }
}

QColor ComposeGrid::color() const
{
    return m_color;
}

void ComposeGrid::setColor(const QColor &color)
{
    m_color = color;
    emit colorChanged();
}

int ComposeGrid::rythmTicks() const
{
    return m_rythmTicks;
}

void ComposeGrid::setRhythmTicks(const int &rythmTicks)
{
    m_rythmTicks = rythmTicks;
    emit rythmTicksChanged();
}

int ComposeGrid::measureCount() const
{
    return m_measureCount;
}

void ComposeGrid::setMeasureCount(const int &measureCount)
{
    m_measureCount = measureCount;
    emit measureCountChanged();
}

int ComposeGrid::trackCount() const
{
    return m_trackCount;
}

void ComposeGrid::setTrackCount(const int &trackCount)
{
    m_trackCount = trackCount;
    emit trackCountChanged();
}
