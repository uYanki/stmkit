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

IAP_EV_CONNECT = 0x20
IAP_EV_DISCONNECT = 0x21

IAP_CMD_GET_VERSION = 0x30
IAP_CMD_ECHO = 0x31
IAP_CMD_BRUST_READ = 0x32
IAP_CMD_BRUST_WRITE = 0x33
IAP_CMD_EARSE = 0x34
IAP_CMD_PROGRAM_START = 0x35
IAP_CMD_PROGRAM_END = 0x36
IAP_CMD_SET_MTA = 0x37
IAP_CMD_GET_MTA = 0x38
IAP_CMD_BLOCK_READ = 0x39
IAP_CMD_BLOCK_WRITE = 0x3A
IAP_CMD_BLOCK_VERIFY = 0x3B
IAP_CMD_JUMP_APP = 0x3C

IAP_ERR_MASK = 0x80  # 类似 modbus


class iap_packet_encode:

    def connect():
        return bytearray(struct.pack(">B", IAP_EV_CONNECT))

    def disconnect():
        return bytearray(struct.pack(">B", IAP_EV_DISCONNECT))

    def get_version():
        return bytearray(struct.pack(">B", IAP_CMD_GET_VERSION))

    def echo(data):
        return bytearray(struct.pack(">BH", IAP_CMD_ECHO, len(data))) + data

    def brust_read(address, length):
        return bytearray(struct.pack(">BIH", IAP_CMD_BRUST_READ, address, length))

    def brust_write(address, data):
        return bytearray(struct.pack(">BIH", IAP_CMD_BRUST_WRITE, address, len(data))) + data

    def program_start():
        return bytearray(struct.pack(">B", IAP_CMD_PROGRAM_START))

    def program_end():
        return bytearray(struct.pack(">B", IAP_CMD_PROGRAM_END))

    def set_mta(address):
        return bytearray(struct.pack(">BI", IAP_CMD_SET_MTA, address))

    def get_mta():
        return bytearray(struct.pack(">B", IAP_CMD_GET_MTA))

    def earse(address, length):
        return bytearray(struct.pack(">BII", IAP_CMD_EARSE, address, length))

    def block_read(length):
        return bytearray(struct.pack(">BH", IAP_CMD_BLOCK_READ, length))

    def block_write(data):
        return bytearray(struct.pack(">BH", IAP_CMD_BLOCK_WRITE, len(data))) + data

    def block_verify(crc16):
        return bytearray(struct.pack(">BH", IAP_CMD_BLOCK_VERIFY, crc16))

    def jump_app():
        return bytearray(struct.pack(">B", IAP_CMD_JUMP_APP))


class decode:
    pass
