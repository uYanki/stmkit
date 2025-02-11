import pywinusb.hid as hid
import time

# VID and PID customization changes here...

VID = 0x34B7
PID = 0xFFFF

# Send buffer
buffer = [0xff]*64

# Const
TIMEOUT = -1
PASS = 0
FAIL = 1

# Result
result = TIMEOUT

I2C_FUNC_TX = 0
I2C_FUNC_RX = 1
I2C_FUNC_WR = 2
I2C_FUNC_RD = 3
I2C_FUNC_SCAN = 4

I2C_FLAG_ADDR_10BIT = 1 << 2
I2C_FLAG_NO_START = 1 << 4
I2C_FLAG_NO_STOP = 1 << 7

I2C_FLAG_DEV_ADDR_10BIT = 1 << 2
I2C_FLAG_MEM_ADDR_16BIT = 1 << 15
I2C_FLAG_NO_START = 1 << 4
I2C_FLAG_NO_STOP = 1 << 7
I2C_FLAG_NO_RD_ACK = 1 << 6
I2C_FLAG_CHK_WR_ACK = 1 << 8


def search_dev():
    filter = hid.HidDeviceFilter(vendor_id=VID, product_id=PID)
    hid_device = filter.get_devices()
    return hid_device


def recv_data(data):
    print(data)
    return None


def send_report(report):
    buffer[0] = report[0].report_id
    report[0].set_raw_data(buffer)
    report[0].send()


def i2c_tx(report, address, xferdata, flags):

    xfersize = 0

    buffer[1] = I2C_FUNC_TX
    buffer[2] = (address & 0x00FF) >> 0
    buffer[3] = (address & 0xFF00) >> 8

    if xferdata != None:
        xfersize = len(xferdata)

    buffer[4] = (xfersize & 0x00FF) >> 0
    buffer[5] = (xfersize & 0xFF00) >> 8

    for i in range(xfersize):
        buffer[6+i] = xferdata[i]

    buffer[6+xfersize] = (flags & 0x00FF) >> 0
    buffer[7+xfersize] = (flags & 0xFF00) >> 8

    send_report(report)


def i2c_rx(report, address, xfersize, flags):

    buffer[1] = I2C_FUNC_RX
    buffer[2] = (address & 0x00FF) >> 0
    buffer[3] = (address & 0xFF00) >> 8
    buffer[4] = (xfersize & 0x00FF) >> 0
    buffer[5] = (xfersize & 0xFF00) >> 8
    buffer[6] = (flags & 0x00FF) >> 0
    buffer[7] = (flags & 0xFF00) >> 8

    send_report(report)


def i2c_write_mem(report, devaddr, memaddr, xferdata, flags):

    xfersize = 0

    buffer[1] = I2C_FUNC_WR
    buffer[2] = (devaddr & 0x00FF) >> 0
    buffer[3] = (devaddr & 0xFF00) >> 8
    buffer[4] = (memaddr & 0x00FF) >> 0
    buffer[5] = (memaddr & 0xFF00) >> 8

    if xferdata != None:
        xfersize = len(xferdata)

    buffer[6] = (xfersize & 0x00FF) >> 0
    buffer[7] = (xfersize & 0xFF00) >> 8

    for i in range(xfersize):
        buffer[8+i] = xferdata[i]

    buffer[8+xfersize] = (flags & 0x00FF) >> 0
    buffer[9+xfersize] = (flags & 0xFF00) >> 8

    send_report(report)


def i2c_read_mem(report, devaddr, memaddr, xfersize, flags):
    buffer[1] = I2C_FUNC_RD
    buffer[2] = (devaddr & 0x00FF) >> 0
    buffer[3] = (devaddr & 0xFF00) >> 8
    buffer[4] = (memaddr & 0x00FF) >> 0
    buffer[5] = (memaddr & 0xFF00) >> 8
    buffer[6] = (xfersize & 0x00FF) >> 0
    buffer[7] = (xfersize & 0xFF00) >> 8
    buffer[8] = (flags & 0x00FF) >> 0
    buffer[9] = (flags & 0xFF00) >> 8

    send_report(report)


def i2c_scan(report):
    buffer[1] = I2C_FUNC_SCAN
    send_report(report)


if __name__ == '__main__':

    devaddr = 0x50

    device = search_dev()[0]
    device.open()
    device.set_raw_data_handler(recv_data)
    report = device.find_output_reports()

    i2c_scan(report)
    time.sleep(0.5)

    i2c_read_mem(report, devaddr, 0, 30, I2C_FLAG_MEM_ADDR_16BIT)
    time.sleep(0.5)

    txdat = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
    i2c_write_mem(report, devaddr, 0, txdat, I2C_FLAG_MEM_ADDR_16BIT)
    time.sleep(0.5)
