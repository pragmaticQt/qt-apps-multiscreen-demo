/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt multiscreen demo application.
**
** $QT_BEGIN_LICENSE:GPL-EXCEPT$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "gpssender.h"
#include "nmea.h"

#include <QFile>
#include <QDebug>

GpsSender::GpsSender(QString routeFileName, QObject* parent) :
    QObject(parent),
    m_dataPosition(0),
    m_nmea(Q_NULLPTR),
    m_latitude(0.0),
    m_longitude(0.0),
    m_direction(0.0),
    m_vehicleSpeed(0.0)
{
    parseRouteFile(routeFileName);
    m_timer.setSingleShot(true);
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(nextData()), Qt::QueuedConnection);
    m_nmea = NMEA::parse(m_data.at(m_dataPosition));
    QMetaObject::invokeMethod(this, "nextData", Qt::QueuedConnection);
}

GpsSender::~GpsSender()
{
    delete m_nmea;
}

void GpsSender::parseRouteFile(QString routeFileName)
{
    QFile routeFile(routeFileName);
    if (!routeFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning("GpsSender::parseRouteFile - Error opening route file: %s", qPrintable(routeFileName));
        return;
    }
    while (!routeFile.atEnd()) {
        m_data.append(routeFile.readLine().simplified());
    }
    routeFile.close();
}

void GpsSender::nextData()
{
    if (m_nmea) {
        NMEAType::Type type(m_nmea->type());
        bool convertOk(false);

        if (type != NMEAType::UndefinedType) {
            qreal position(m_nmea->value(NMEAType::Latitude).toDouble(&convertOk));
#ifndef TCPCLUSTERDATACONNECTION
            bool posChanged(false);
#endif
            if (convertOk && m_latitude != position) {
                m_latitude = position;
                emit latitudeChanged(m_latitude);
#ifndef TCPCLUSTERDATACONNECTION
                posChanged = true;
#endif
            }
            position = m_nmea->value(NMEAType::Longitude).toDouble(&convertOk);
            if (convertOk && m_longitude != position) {
                m_longitude = position;
                emit longitudeChanged(m_longitude);
#ifndef TCPCLUSTERDATACONNECTION
                posChanged = true;
#endif
            }
#ifndef TCPCLUSTERDATACONNECTION
//            qDebug("GpsSender::nextData - posChanged: %s, m_timeStamp is valid: %s", (posChanged ? "true" : "false"), (m_timeStamp.isValid() ? "true" : "false"));
            if (posChanged && m_timeStamp.isValid()) {
                emit positionChanged(m_timeStamp);
            }
#endif
        }

        if (type == NMEAType::RMCType) {
            qreal convertedValue(m_nmea->value(NMEAType::RMCAngle).toDouble(&convertOk));
            if (convertOk && m_direction != convertedValue) {
                m_direction = convertedValue;
                emit directionChanged(m_direction);
            }
            convertedValue = m_nmea->value(NMEAType::RMCSpeed).toDouble(&convertOk);
            if (convertOk && m_vehicleSpeed != convertedValue) {
                m_vehicleSpeed = convertedValue;
                emit vehicleSpeedChanged(m_vehicleSpeed);
            }
        }
    }

    delete m_nmea;
    if (++m_dataPosition >= m_data.count()) {
        m_dataPosition = 0;
    }

    m_nmea = NMEA::parse(m_data.at(m_dataPosition));

    if (m_nmea) {
        QTime timeStamp(m_nmea->value(NMEAType::UTCTime).toTime());
        int mseconds(m_timeStamp.msecsTo(timeStamp));
        m_timeStamp = timeStamp;
        if (mseconds > 0) {
            m_timer.start(mseconds);
        }
        else {
            QMetaObject::invokeMethod(this, "nextData", Qt::QueuedConnection);
        }
    }
    else {
        m_timeStamp = QTime();
        qWarning("GpsSender::nextData - Error in NMEA parsing");
    }
}
