# -*- coding: utf-8 -*-

from backend.usbd_hid_backend import usbd_hid_backend

from iap_packet import *
import time

RESPONSE_IDLE = 0
RESPONSE_WAITING = 1
RESPONSE_ERROR_TIMEOUT = 2
RESPONSE_ERROR_ACK = 3
RESPONSE_SUCCESS = 4


class IAP_Comm(usbd_hid_backend):

    __response_state = RESPONSE_IDLE

    def __init__(self):
        pass

    def send_request(self, data):
        self.__response_state = RESPONSE_WAITING
        super().send_request(data)

    def wait_response(self, timeout_ms=1000):

        while self.__response_state == RESPONSE_WAITING:
            if timeout_ms == 0:
                self.__response_state = RESPONSE_ERROR_TIMEOUT
                break
            time.sleep(0.001)
            timeout_ms -= 1

        if self.__response_state != RESPONSE_IDLE and self.__response_state != RESPONSE_SUCCESS:
            raise Exception(
                f"error occurs when waiting response: {self.__response_state}")

        return self.__response_state

    def response_handler(self, data):

        packet = data[1:]  # skip report id

        pid = data[0]  # packet_id

        if pid & IAP_ERR_MASK:
            self.__response_state = RESPONSE_ERROR_ACK
        else:
            self.__response_state = RESPONSE_SUCCESS

        print(data)
        # print([hex(n) for n in data])


if __name__ == '__main__':

    iap = IAP_Comm()

    # if iap.open(0x2E3C,0xAF01) == False:  # arterytek
    if iap.open(0x34B7, 0xFFFF) == False:  # hpmicro
        raise Exception("fail to open usb hid device")

    print("usb connected")

    selected_test = 3

    if selected_test == 1:  # echo

        iap.send_request(iap_packet_encode.echo(
            bytearray("caonima", encoding="utf-8")))
        iap.wait_response()

    elif selected_test == 2:  # brust read write

        address = 0x0000009

        # report_id (1) + packet_id (1) + address(4) + length (2)
        data_maxsize_in_frame = 56

        data = bytearray([(n % 256) for n in range(data_maxsize_in_frame)])

        iap.send_request(iap_packet_encode.brust_read(address, len(data)))
        iap.wait_response()

        iap.send_request(iap_packet_encode.brust_write(address, data))
        iap.wait_response()

        iap.send_request(iap_packet_encode.brust_read(address, len(data)))
        iap.wait_response()

    elif selected_test == 3:  # block read write

        address = 0x00000000
        data = bytearray([(n % 256) for n in range(0x512)])

        # report_id (1) + packet_id (1) + length (2)
        data_maxsize_in_frame = 60

        '''download'''

        iap.send_request(iap_packet_encode.earse(address, len(data)))
        iap.wait_response()

        iap.send_request(iap_packet_encode.program_start())
        iap.wait_response()

        iap.send_request(iap_packet_encode.set_mta(address))
        iap.wait_response()

        xfer_size = 0
        remain_size = len(data)
        offset = 0
        offset_1k = 0

        while remain_size > 0:

            if remain_size > data_maxsize_in_frame:
                xfer_size = data_maxsize_in_frame
            else:
                xfer_size = remain_size

            iap.send_request(iap_packet_encode.block_write(
                data[offset:offset+xfer_size]))
            # iap.wait_response()
            # time.sleep(0.001)

            remain_size -= xfer_size
            offset += xfer_size

            # 断开检测
            if (offset - offset_1k) > 1024:
                iap.send_request(iap_packet_encode.get_mta())
                iap.wait_response()
                offset_1k = offset

        iap.send_request(iap_packet_encode.program_end())
        iap.wait_response()

        #

        '''upload'''

        iap.send_request(iap_packet_encode.set_mta(address))
        iap.wait_response()

        xfer_size = 0
        remain_size = len(data)
        offset = 0
        offset_1k = 0

        while remain_size > 0:

            if remain_size > data_maxsize_in_frame:
                xfer_size = data_maxsize_in_frame
            else:
                xfer_size = remain_size

            iap.send_request(iap_packet_encode.block_read(xfer_size))
            iap.wait_response()

            remain_size -= xfer_size
            offset += xfer_size
