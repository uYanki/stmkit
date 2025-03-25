#include "protocol.h"
#include <QDataStream>

Protocol::Protocol()
{
}

QByteArray Protocol::GetVersion()
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_GET_VERSION;

    return buffer;
}

QByteArray Protocol::BrustRead(uint32_t address, uint16_t length)
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_BRUST_READ << address << length;

    return buffer;
}

QByteArray Protocol::BrustWrite(uint32_t address, QByteArray data)
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_BRUST_WRITE << address << (uint16_t)data.length() << data;

    return buffer;
}

QByteArray Protocol::Earse(uint32_t address, uint32_t length)
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_EARSE << address << length;

    return buffer;
}

QByteArray Protocol::SetMTA(uint32_t address)
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_SET_MTA << address;

    return buffer;
}

QByteArray Protocol::BlockRead(uint16_t length)
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_BLOCK_READ << length;

    return buffer;
}

QByteArray Protocol::BlockWrite(QByteArray data)
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_BLOCK_WRITE << (qint16)data.length();
    stream.writeRawData(data.constData(), data.length());

    return buffer;
}

QByteArray Protocol::BlockWriteEnd(uint16_t checksum)
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_BLOCK_WRITE_END << checksum;

    return buffer;
}

QByteArray Protocol::JumpApp()
{
    QByteArray  buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);

    stream << PacketID::IAP_CMD_JUMP_APP;

    return buffer;
}

QString Protocol::stringify(Protocol::PacketID pid)
{
#define _stringify(x) #x

    switch (pid)
    {
        case IAP_CMD_GET_VERSION: return _stringify(IAP_CMD_GET_VERSION);
        case IAP_CMD_BRUST_READ: return _stringify(IAP_CMD_BRUST_READ);
        case IAP_CMD_BRUST_WRITE: return _stringify(IAP_CMD_BRUST_WRITE);
        case IAP_CMD_EARSE: return _stringify(IAP_CMD_EARSE);
        case IAP_CMD_SET_MTA: return _stringify(IAP_CMD_SET_MTA);
        case IAP_CMD_BLOCK_READ: return _stringify(IAP_CMD_BLOCK_READ);
        case IAP_CMD_BLOCK_WRITE: return _stringify(IAP_CMD_BLOCK_WRITE);
        case IAP_CMD_BLOCK_WRITE_END: return _stringify(IAP_CMD_BLOCK_WRITE_END);
        case IAP_CMD_JUMP_APP: return _stringify(IAP_CMD_JUMP_APP);
        case IAP_ERR_MASK: return _stringify(IAP_ERR_MASK);
        default: QString("");
    }

#undef _stringify
}
