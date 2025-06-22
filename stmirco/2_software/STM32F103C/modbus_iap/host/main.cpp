#include "modbusloader.h"

#include <QCoreApplication>
#include <QCommandLineParser>
#include <QVariant>
#include <QTimer>
#include <QMetaEnum>
#include <QTextStream>

template<typename EnumType>
static bool validateEnum(EnumType enumValue);
static bool validateClientSettings(ModbusCustomClient::Settings &settings);

static bool validateClientSettings(ModbusCustomClient::Settings &settings)
{
    if (!validateEnum(settings.baudRate))
        return false;
    if (!validateEnum(settings.dataBits))
        return false;
    if (!validateEnum(settings.parity))
        return false;
    if (!validateEnum(settings.stopBits))
        return false;

    if (settings.name.isEmpty())
        return false;

    if (settings.serverAddress < 1 || settings.serverAddress > 255)
        return false;

    return true;
}

template<typename EnumType>
static bool validateEnum(EnumType enumValue)
{
    const auto metaEnum{ QMetaEnum::fromType<EnumType>() };
    for (int i{ 0 }; i < metaEnum.keyCount(); ++i) {
        if (enumValue == metaEnum.value(i))
            return true;
    }
    return false;
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    QTextStream cout(stdout);
    QTextStream cerr(stderr);

    QCommandLineParser parser;
    parser.setApplicationDescription(QString("Modbus loader"));
    parser.addHelpOption();
    parser.addPositionalArgument(QString("firmware"), QString("A bin file to load."));

    parser.addOptions({ { QString("n"), QString("Port name."), QString("port") },
                        { QString("b"), QString("Baud rate. (115200)"), QString("baud rate"), QString("115200") },
                        { QString("d"), QString("Data bits. (8)"), QString("data bits"), QString("8") },
                        { QString("p"), QString("Parity. (N)"), QString("parity"), QString("N") },
                        { QString("s"), QString("Stop bits. (1)"), QString("stop bits"), QString("1") },
                        { QString("a"), QString("Server address."), QString("address") } });

    parser.process(app);

    if (!parser.isSet(QString("n"))) {
        cerr << QString("Specify port name\n") << Qt::endl;
        parser.showHelp(1);
    }
    if (!parser.isSet(QString("a"))) {
        cerr << QString("Specify server address\n") << Qt::endl;
        parser.showHelp(1);
    }
    auto positionalArguments{ parser.positionalArguments() };
    if (positionalArguments.isEmpty()) {
        cerr << QString("Specify firmware file (bin)\n") << Qt::endl;
        parser.showHelp(1);
    } else if (positionalArguments.size() > 1) {
        cerr << QString("Several firmware files specified\n") << Qt::endl;
        parser.showHelp(1);
    }

    auto firmwareFile{ positionalArguments.first() };

    if (!firmwareFile.endsWith(QString(".bin"))) {
        cerr << QString("Firmware file must be in bin format\n") << Qt::endl;
        parser.showHelp(1);
    }

    QSerialPort::Parity parity;
    switch (parser.value(QString("p")).at(0).unicode()) {
    case 'N':
        parity = QSerialPort::NoParity;
        break;
    case 'E':
        parity = QSerialPort::EvenParity;
        break;
    case 'O':
        parity = QSerialPort::OddParity;
        break;
    case 'M':
        parity = QSerialPort::MarkParity;
        break;
    case 'S':
        parity = QSerialPort::SpaceParity;
        break;
    default:
        parity = QSerialPort::NoParity;
        break;
    }

    ModbusCustomClient::Settings settings{
        parser.value(QString("n")),
        static_cast<QSerialPort::BaudRate>(parser.value(QString("b")).toInt()),
        static_cast<QSerialPort::DataBits>(parser.value(QString("d")).toInt()),
        parity,
        static_cast<QSerialPort::StopBits>(parser.value(QString("s")).toInt()),
        parser.value(QString("a")).toInt(),
    };

    cout << QString("Connection parameters:\n") << QString("Port name: %1\n").arg(settings.name)
         << QString("Baud rate: %1\n").arg(QVariant::fromValue(settings.baudRate).toString())
         << QString("Data bits: %1\n").arg(QVariant::fromValue(settings.dataBits).toString())
         << QString("Parity: %1\n").arg(QVariant::fromValue(settings.parity).toString())
         << QString("Stop bits: %1\n").arg(QVariant::fromValue(settings.stopBits).toString())
         << QString("Server address: %1\n").arg(settings.serverAddress) << Qt::endl;

    if (!validateClientSettings(settings)) {
        cerr << "Modbus client settings are incorrect" << Qt::endl;
        return 1;
    }

    ModbusLoader modbusLoader{ &app };

    modbusLoader.setDeviceSettings(settings);

    if (!modbusLoader.connectDevice()) {
        cerr << modbusLoader.getErrorString() << Qt::endl;
        return 1;
    }

    QObject::connect(&modbusLoader, &ModbusLoader::finished, [&](bool success) {
        if (!success)
            cerr << modbusLoader.getErrorString() << Qt::endl;
        QCoreApplication::exit(!success);
    });

    QObject::connect(&modbusLoader, &ModbusLoader::newMessageAvailable,
                     [&](const QString &msg) { cout << msg << Qt::endl; });

    QTimer::singleShot(0, &modbusLoader, [&]() { modbusLoader.program(firmwareFile); });

    return app.exec();
}
