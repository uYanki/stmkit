#ifndef UART_CONFIG_H
#define UART_CONFIG_H

#include <QString>
#include <QSettings>

#include <QSerialPort>

class UART_Config {
public:
    UART_Config(QString port = "");

    bool load();
    bool save();

    QString               port     = "";
    QSerialPort::BaudRate baudrate = QSerialPort::BaudRate::Baud115200;
    QSerialPort::DataBits databits = QSerialPort::DataBits::Data8;
    QSerialPort::Parity   parity   = QSerialPort::Parity::NoParity;
    QSerialPort::StopBits stopbits = QSerialPort::StopBits::OneStop;
};

#endif  // UART_CONFIG_H
