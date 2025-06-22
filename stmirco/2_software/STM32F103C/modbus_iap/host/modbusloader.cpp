#include "modbusloader.h"

ModbusLoader::ModbusLoader(QObject *parent) : modbusClient{ new ModbusCustomClient{ parent } }
{
    connect(modbusClient, &ModbusCustomClient::finished, this, [this](bool success) {
        if (!success) {
            errorStr = modbusClient->getErrorString();
            emit finished(false);
        } else {
            executeStateMachine();
        }
    });
}

bool ModbusLoader::connectDevice()
{
    if (!modbusClient->connectDevice()) {
        errorStr = QString("Connect: ") + modbusClient->errorString();
        return false;
    }

    return true;
}

void ModbusLoader::program(const QString &fileName)
{
    fileFirmware.setFileName(fileName);
    if (!fileFirmware.open(QIODevice::ReadOnly)) {
        errorStr = fileFirmware.errorString();
        emit finished(false);
        return;
    }

    state = State::Idle;
    executeStateMachine();
}

void ModbusLoader::executeStateMachine()
{
    switch (state) {
    case State::Idle:
        errorStr.clear();
        checksumFirmware = 0;
        state = State::EraseFlash;
        break;

    case State::EraseFlash:
        if (modbusClient->getResult().front() == 0) {
            state = State::ProgramFlash;
            emit newMessageAvailable(QString("Erased flash"));
        } else {
            errorStr = QString("Erasing flash failed");
            emit finished(false);
        }
        break;

    case State::ProgramFlash:
        if (modbusClient->getResult().front() != 0) {
            errorStr = QString("Programming flash failed");
            emit finished(false);
        } else if (fileFirmware.atEnd()) {
            emit newMessageAvailable(
                    QString("Flash programmed (fw size = %1 bytes)").arg(fileFirmware.size()));
            state = State::VerifyFlash;
        }
        break;

    case State::VerifyFlash:
        if (checksumFirmware == modbusClient->getResult().at(0)) {
            emit newMessageAvailable(
                    QString("Flash verified (checksum = 0x%1)").arg(checksumFirmware, 0, 16));
            state = State::ResetDevice;
        } else {
            errorStr = QString("Verifying flash failed");
            emit finished(false);
        }
        break;

    case State::ResetDevice:
        if (modbusClient->getResult().front() == 0) {
            state = State::Finished;
            emit newMessageAvailable(QString("Reset device"));
        } else {
            errorStr = QString("Resetting device failed");
            emit finished(false);
        }
        break;

    case State::Finished:
        break;
    }

    switch (state) {
    case State::Idle:
        break;

    case State::EraseFlash:
        emit newMessageAvailable(QString("Erasing flash..."));
        modbusClient->modbusCustomFunction(ModbusCustomClient::Subfunctions::EraseFlash);
        break;

    case State::ProgramFlash: {
        emit newMessageAvailable(QString("Programming flash... (%1%)").arg(
                qRound(100.0 * fileFirmware.pos() / fileFirmware.size())));

        // 256 - server address (1 byte) - CRC (2 bytes) - function code (1 byte) -
        // subfunction code (1 byte) - flash offset address (4 bytes) = 247
        // rounding down to 246
        char offsetTemp[4];
        auto pos{ static_cast<quint32>(fileFirmware.pos() & 0xFFFFFFFF) };
        for (int i{ 0 }; i < 4; ++i)
            offsetTemp[i] = (pos >> 8 * i) & 0xFF;

        char firmwareTemp[246];

        QByteArray byteArray;
        QDataStream dataStream{ &byteArray, QIODevice::WriteOnly };

        auto readCount{ fileFirmware.read(firmwareTemp, sizeof(firmwareTemp)) };
        if (readCount == -1) {
            errorStr = fileFirmware.errorString();
            emit finished(false);
            return;
        } else if (readCount == 0) {
            return;
        }

        for (int i{ 0 }; i < readCount; ++i)
            checksumFirmware += firmwareTemp[i];

        dataStream.writeRawData(offsetTemp, 4);
        dataStream.writeRawData(firmwareTemp, readCount);

        modbusClient->modbusCustomFunction(ModbusCustomClient::Subfunctions::ProgramFlash,
                                           std::move(byteArray));
        break;
    }

    case State::VerifyFlash:
        emit newMessageAvailable(QString("Verifying flash..."));
        modbusClient->modbusCustomFunction(ModbusCustomClient::Subfunctions::GetChecksumFlash);
        break;

    case State::ResetDevice:
        emit newMessageAvailable(QString("Resetting flash..."));
        modbusClient->modbusCustomFunction(ModbusCustomClient::Subfunctions::ResetDevice);
        break;

    case State::Finished:
        emit finished(true);
        break;
    }
}
