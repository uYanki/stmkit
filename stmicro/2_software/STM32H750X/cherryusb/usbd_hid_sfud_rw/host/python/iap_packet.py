# -*- coding: utf-8 -*-

import struct

'''

<: le
>: be

// lower: signed
// upper: unsigned

b/B: byte
h/H: word
i/I: dword
q/Q: qword
f: float
d: double
s: string

'''

IAP_CMD_GET_VERSION = 0x30
IAP_CMD_BRUST_READ = 0x31
IAP_CMD_BRUST_WRITE = 0x32
IAP_CMD_EARSE = 0x33
IAP_CMD_SET_MTA = 0x34
IAP_CMD_BLOCK_READ = 0x35
IAP_CMD_BLOCK_WRITE = 0x36
IAP_CMD_BLOCK_WRITE_END = 0x37
IAP_CMD_JUMP_APP = 0x38
IAP_ERR_MASK = 0x80

IAP_ERR_MASK = 0x80  # 类似 modbus


class iap_packet_encode:

    def get_version():
        return bytearray(struct.pack(">B", IAP_CMD_GET_VERSION))

    def brust_read(address, length):
        return bytearray(struct.pack(">BIH", IAP_CMD_BRUST_READ, address, length))

    def brust_write(address, data):
        return bytearray(struct.pack(">BIH", IAP_CMD_BRUST_WRITE, address, len(data))) + data

    def set_mta(address):
        return bytearray(struct.pack(">BI", IAP_CMD_SET_MTA, address))

    def earse(address, length):
        return bytearray(struct.pack(">BII", IAP_CMD_EARSE, address, length))

    def block_read(length):
        return bytearray(struct.pack(">BH", IAP_CMD_BLOCK_READ, length))

    def block_write(data):
        return bytearray(struct.pack(">BH", IAP_CMD_BLOCK_WRITE, len(data))) + data

    def block_write_end(crc16):
        return bytearray(struct.pack(">BH", IAP_CMD_BLOCK_WRITE_END, crc16))

    def jump_app():
        return bytearray(struct.pack(">B", IAP_CMD_JUMP_APP))


class decode:
    pass
