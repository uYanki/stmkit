#include "UART_Config.h"
#include "GlobalVariables.h"

#include <QDataStream>

UART_Config::UART_Config(QString portName)
{
    this->port = portName;

    load();
}

bool UART_Config::load()
{
    QByteArray ba;

    if (port.isEmpty())
    {
        return false;
    }

    gSettings.beginGroup("UartConfig");
    ba = gSettings.value(port).toByteArray();
    gSettings.endGroup();

    if (ba.isEmpty())
    {
        return false;
    }

    QDataStream stream(&ba, QIODevice::ReadOnly);

    stream >> baudrate;
    stream >> databits;
    stream >> parity;
    stream >> stopbits;

    return true;
}

bool UART_Config::save()
{
    if (port.isEmpty())
    {
        return false;
    }

    QByteArray  ba;
    QDataStream stream(&ba, QIODevice::WriteOnly);

    stream << baudrate;
    stream << databits;
    stream << parity;
    stream << stopbits;

    gSettings.beginGroup("UartConfig");
    gSettings.setValue(port, ba);
    gSettings.endGroup();

    return true;
}
