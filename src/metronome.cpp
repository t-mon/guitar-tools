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

#include "metronome.h"
#include "core.h"

#include <QDebug>

Metronome::Metronome(QObject *parent) :
    QObject(parent),
    m_running(false),
    m_tick(true)
{
    setBpm(120);
    m_period = m_tmpPeriod;

    m_timer = new QTimer(this);
    m_timer->setTimerType(Qt::PreciseTimer);
    m_timer->setInterval(m_period);
    m_timer->setSingleShot(false);

    qDebug() << "BPM:" << m_bpm << " -> dt=" << m_period << m_tempoName;

    connect(m_timer, &QTimer::timeout, this, &Metronome::onTimeout);
}

void Metronome::start()
{
    qDebug() << "----------------------------------";
    qDebug() << "Metronome: start";
    qDebug() << "BPM:" << m_bpm << " -> dt=" << m_period << m_tempoName;

    m_timer->start();
    setRunning(true);
}

void Metronome::stop()
{
    if (running()) {
        qDebug() << "----------------------------------";
        qDebug() << "Metronome: stop";
    }

    m_timer->stop();
    setRunning(false);
}

bool Metronome::running() const
{
    return m_running;
}

int Metronome::bpm() const
{
    return m_bpm;
}

void Metronome::setBpm(const int &bpm)
{
    m_bpm = bpm;
    emit bpmChanged();

    if (m_bpm <= 40) {
        setTempoName("Grave");
    } else if (m_bpm > 40 && m_bpm < 60) {
        setTempoName("Largo");
    } else if (m_bpm >= 60 && m_bpm <= 65) {
        setTempoName("Larghetto");
    } else if (m_bpm > 65 && m_bpm <= 75) {
        setTempoName("Adagio");
    } else if (m_bpm > 75 && m_bpm <= 108) {
        setTempoName("Andante");
    } else if (m_bpm > 108 && m_bpm <= 120) {
        setTempoName("Moderato");
    } else if (m_bpm > 120 && m_bpm <= 168) {
        setTempoName("Allegro");
    } else if (m_bpm > 168 && m_bpm <= 175) {
        setTempoName("Presto");
    } else if (m_bpm > 175) {
        setTempoName("Prestissimo");
    }

    setPeriod(qRound(60000.0 / m_bpm));

}

int Metronome::period() const
{
    return m_period;
}

void Metronome::setPeriod(const int &period)
{
    m_tmpPeriod = period;
}

QString Metronome::tempoName() const
{
    return m_tempoName;
}

void Metronome::setRunning(const bool &running)
{
    if (m_running != running) {
        m_running = running;
        emit runningChanged();
    }
}

void Metronome::setTempoName(const QString &tempoName)
{
    m_tempoName = tempoName;
    emit tempoNameChanged();
}

void Metronome::onTimeout()
{
    if (m_tmpPeriod != m_period) {
        qDebug() << "Change speed" << m_tmpPeriod;
        m_period = m_tmpPeriod;
        emit periodChanged();
        m_timer->setInterval(m_period);
    }

    if (m_tick) {
        qDebug() << "Tick  -->";
        emit tick();
        m_tick = false;
    } else {
        qDebug() << "Tock  <--";
        emit tock();
        m_tick = true;
    }
}

