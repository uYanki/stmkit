

# response state
from abc import abstractmethod
import copy
import time
import pywinusb.hid as hid

RESPONSE_IDLE = 0
RESPONSE_WAITING = 1
RESPONSE_ERROR_TIMEOUT = 2
RESPONSE_ERROR_ACK = 3
RESPONSE_SUCCESS = 4


IAP_EV_CONNECT = 0xA0
IAP_EV_DISCONNECT = 0xA1

IAP_CMD_GET_ID = 0xB1

IAP_CMD_SHORT_READ = 0xD0
IAP_CMD_SHORT_WRITE = 0xD1

IAP_CMD_SET_MTA = 0xC0
IAP_CMD_PROGRAM_START = 0xC1
IAP_CMD_PROGRAM_END = 0xC2
IAP_CMD_EARSE = 0xC3
IAP_CMD_UPLOAD = 0xC4
IAP_CMD_DOWNLOAD = 0xC5
IAP_CMD_VERIFY = 0xC6


class FrameBuffer:
    buffer = [0x00]*64
    alloffset = 0

    def __init__(self) -> None:
        self.clear()

    def clear(self):
        self.buffer = [0x00]*64

    def set_byte(self, offset, byte):
        offset += self.alloffset
        if (offset + 1) >= len(self.buffer):
            raise Exception("out of memory")
        self.buffer[offset + 0] = (byte & 0xFF)

    def set_word_be(self, offset, word):
        offset += self.alloffset
        if (offset + 2) >= len(self.buffer):
            raise Exception("out of memory")
        self.buffer[offset + 0] = (word & 0xFF00) >> 8
        self.buffer[offset + 1] = (word & 0x00FF) >> 0

    def set_dword_be(self, offset, dword):
        offset += self.alloffset
        if (offset + 4) >= len(self.buffer):
            raise Exception("out of memory")
        self.buffer[offset + 0] = (dword & 0xFF000000) >> 24
        self.buffer[offset + 1] = (dword & 0x00FF0000) >> 16
        self.buffer[offset + 2] = (dword & 0x0000FF00) >> 8
        self.buffer[offset + 3] = (dword & 0x000000FF) >> 0

    def copy_from(self, offset, buffer):
        offset += self.alloffset
        if (offset + len(buffer)) >= len(self.buffer):
            raise Exception("out of memory")
        self.buffer[offset:offset+len(buffer)] = buffer

    def get_byte(self, offset):
        offset += self.alloffset
        if (offset + 1) >= len(self.buffer):
            raise Exception("out of memory")
        byte = self.buffer[offset + 0]
        return byte

    def get_word_be(self, offset):
        offset += self.alloffset
        if (offset + 2) >= len(self.buffer):
            raise Exception("out of memory")
        word = self.buffer[offset+0] << 8
        word |= self.buffer[offset+1] << 0
        return word

    def get_dword_be(self, offset):
        offset += self.alloffset
        if (offset + 4) >= len(self.buffer):
            raise Exception("out of memory")
        dword = self.buffer[offset+0] << 24
        dword |= self.buffer[offset+1] << 16
        dword |= self.buffer[offset+2] << 8
        dword |= self.buffer[offset+3] << 0
        return dword


class USB_Backend():

    __device = None
    __output_reports = None

    REQUEST_HEADER_SIZE = 1

    def open(self, VID, PID):
        filter = hid.HidDeviceFilter(vendor_id=VID, product_id=PID)
        hid_devices = filter.get_devices()

        if len(hid_devices) == 0:
            return False

        self.__device = hid_devices[0]
        self.__device.set_raw_data_handler(self.response_handler)
        self.__device.open()
        self.__output_reports = self.__device.find_output_reports()

        return True

    def close(self):
        self.__device.close()

    def send_request(self, buffer):
        buffer[0] = self.__output_reports[0].report_id
        self.__output_reports[0].set_raw_data(buffer)
        self.__output_reports[0].send()

    @abstractmethod  # 虚函数
    def response_handler(self, data):
        pass


class IAP_Comm(FrameBuffer, USB_Backend):

    __response_state = RESPONSE_IDLE

    def __init__(self) -> None:
        self.alloffset = self.REQUEST_HEADER_SIZE

    def send_request(self):
        self.__response_state = RESPONSE_WAITING
        super().send_request(self.buffer)

    #

    def start(self):
        self.clear()
        self.set_byte(0, IAP_CMD_PROGRAM_START)
        self.send_request()

    def stop(self):
        self.clear()
        self.set_word_be(0, IAP_CMD_PROGRAM_END)
        self.send_request()

    def earse(self, address, length):
        self.clear()
        self.set_byte(0, IAP_CMD_EARSE)
        self.set_dword_be(1, address)
        self.set_dword_be(5, length)
        self.send_request()

    def set_addr(self, address):
        self.clear()
        self.set_byte(0, IAP_CMD_SET_MTA)
        self.set_dword_be(1, address)
        self.send_request()

    def download(self, data):
        self.clear()

        self.set_byte(0, IAP_CMD_DOWNLOAD)

        size = len(data)
        offset = 0

        max_data_size = 63 - 2 - 1 - self.REQUEST_HEADER_SIZE
        self.set_word_be(1, max_data_size)

        while size > max_data_size:
            self.copy_from(4, data[offset: offset + max_data_size])
            self.send_request()
            size -= max_data_size
            offset += max_data_size

        self.set_byte(0, size)
        self.copy_from(4, data[offset:])
        self.send_request()

    def verify(self):
        self.clear()
        self.set_byte(0, IAP_CMD_VERIFY)
        self.send_request()

    def wait_response(self, timeout_ms=1000):

        while self.__response_state == RESPONSE_WAITING:
            if timeout_ms == 0:
                self.__response_state = RESPONSE_ERROR_TIMEOUT
                break
            time.sleep(0.002)
            timeout_ms -= 2

        if self.__response_state != RESPONSE_IDLE and self.__response_state != RESPONSE_SUCCESS:
            raise Exception(
                f"error occurs when waiting response: {self.__response_state}")

        return self.__response_state

    def response_handler(self, data):
        rxframe = FrameBuffer()
        rxframe.buffer = data

        rxframe.alloffset = self.REQUEST_HEADER_SIZE
        iap_cmd = rxframe.get_byte(0)

        # self.__response_state = RESPONSE_SUCCESS

        print(data)

        if iap_cmd in [IAP_CMD_EARSE, IAP_EV_CONNECT, IAP_CMD_PROGRAM_START, IAP_CMD_PROGRAM_END, IAP_CMD_SET_MTA]:
            self.__response_state = RESPONSE_SUCCESS
        # elif iap_cmd in [IAP_CMD_VERIFY]:
        #     self.__response_state = RESPONSE_SUCCESS
        #     rxlen = rxframe.get_dword_be(2)
        #     print("len", rxlen)


if __name__ == '__main__':

    iap = IAP_Comm()

    if iap.open(0x34B7, 0xFFFF) == False:  # hpmicro
        # if iap.open(0x2E3C,0xAF01) == False:  # arterytek
        raise Exception("fail to open usb hid device")

    print("usb connected")
    iap.earse(0, 0)
    iap.wait_response()

    iap.data([0x11]*100*1024)

    iap.verify()
    iap.wait_response()
