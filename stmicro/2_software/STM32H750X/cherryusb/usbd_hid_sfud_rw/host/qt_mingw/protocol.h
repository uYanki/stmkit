#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <QByteArray>

class Protocol {
public:
    enum PacketID : uint8_t {
        IAP_CMD_GET_VERSION     = 0x30,
        IAP_CMD_BRUST_READ      = 0x31,
        IAP_CMD_BRUST_WRITE     = 0x32,
        IAP_CMD_EARSE           = 0x33,
        IAP_CMD_SET_MTA         = 0x34,
        IAP_CMD_BLOCK_READ      = 0x35,
        IAP_CMD_BLOCK_WRITE     = 0x36,
        IAP_CMD_BLOCK_WRITE_END = 0x37,
        IAP_CMD_JUMP_APP        = 0x38,
        IAP_ERR_MASK            = 0x80,
    };

    Protocol();
    ~Protocol();

    static QByteArray GetVersion();

    static QByteArray BrustRead(uint32_t address, uint16_t length);
    static QByteArray BrustWrite(uint32_t address, QByteArray data);

    static QByteArray Earse(uint32_t address, uint32_t length);

    static QByteArray SetMTA(uint32_t address);

    static QByteArray BlockRead(uint16_t length);
    static QByteArray BlockWrite(QByteArray data);
    static QByteArray BlockWriteEnd(uint16_t checksum);

    static QByteArray JumpApp();

    static QString stringify(PacketID pid);
};

#endif  // PROTOCOL_H
