#ifndef MODBUSCUSTOMCLIENT_H
#define MODBUSCUSTOMCLIENT_H

#include <QSerialPort>
#include <QModbusRtuSerialMaster>

#include <QList>
#include <QVector>

#include <qiterator.h>

class ModbusCustomClient : public QModbusRtuSerialMaster
{
    Q_OBJECT

public:
    explicit ModbusCustomClient(QObject *parent = nullptr);

    enum class Subfunctions : quint8 { EraseFlash, ProgramFlash, GetChecksumFlash, ResetDevice };

    struct Settings
    {
        QString name;
        QSerialPort::BaudRate baudRate;
        QSerialPort::DataBits dataBits;
        QSerialPort::Parity parity;
        QSerialPort::StopBits stopBits;
        int serverAddress;
    };

    void setSettings(const Settings &settings);
    void setServerAddress(int serverAddress) { this->serverAddress = serverAddress; };
    [[nodiscard]] auto &getErrorString() const { return errorStr; };
    [[nodiscard]] auto &getResult() const { return result; };
    void modbusCustomFunction(Subfunctions subcommand, QByteArray &&data = {});

protected:
    virtual bool processPrivateResponse(const QModbusResponse &response,
                                        QModbusDataUnit *data) override;

private:
    static constexpr QModbusPdu::FunctionCode customFunctionCode{ QModbusPdu::FunctionCode(0x6c) };

    QString errorStr;
    int serverAddress{ -1 };
    QVector<quint16> result;

signals:
    void finished(bool success);
};

#endif // MODBUSCUSTOMCLIENT_H
