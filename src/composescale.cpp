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

#include "composescale.h"

#include <QRect>
#include <QPen>
#include <QDebug>

ComposeScale::ComposeScale(QQuickItem *parent):
    QQuickPaintedItem(parent),
    m_color(QColor("FF0000"))
{

}

void ComposeScale::paint(QPainter *painter)
{
    QPen tickPen(m_color);
    tickPen.setWidth(1);

    QPen measurePen(m_color);
    measurePen.setWidth(2);

    int rowCount = m_measureCount * m_rythmTicks;

    for (int x = 0; x < rowCount; x++) {
        if (x % m_rythmTicks == 0) {
            painter->setPen(measurePen);
            painter->drawLine(QPoint(x * width() / rowCount, height()), QPoint(x * width() / rowCount, height() * 3 / 5));
        } else {
            painter->setPen(tickPen);
            painter->drawLine(QPoint(x * width() / rowCount, height()), QPoint(x * width() / rowCount, height() * 2 / 5));
        }
    }
}

QColor ComposeScale::color() const
{
    return m_color;
}

void ComposeScale::setColor(const QColor &color)
{
    m_color = color;
    emit colorChanged();
}

QColor ComposeScale::textColor() const
{
    return m_textColor;
}

void ComposeScale::setTextColor(const QColor &textColor)
{
    m_textColor = textColor;
    emit textColorChanged();
}

int ComposeScale::rythmTicks() const
{
    return m_rythmTicks;
}

void ComposeScale::setRhythmTicks(const int &rythmTicks)
{
    m_rythmTicks = rythmTicks;
    emit rythmTicksChanged();
}

int ComposeScale::measureCount() const
{
    return m_measureCount;
}

void ComposeScale::setMeasureCount(const int &measureCount)
{
    m_measureCount = measureCount;
    emit measureCountChanged();
}

int ComposeScale::trackCount() const
{
    return m_trackCount;
}

void ComposeScale::setTrackCount(const int &trackCount)
{
    m_trackCount = trackCount;
    emit trackCountChanged();
}
