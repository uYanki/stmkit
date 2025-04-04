
# -*- coding: utf-8 -*-

from abc import abstractmethod
import pywinusb.hid as hid


class usbd_hid_backend():

    __device = None
    __output_reports = None

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

    def send_request(self, data):

        buffer = bytearray(self.__output_reports[0].report_id)
        buffer += data
        
        if len(buffer) < 64:
            buffer += bytes(64 - len(buffer))

        self.__output_reports[0].set_raw_data(buffer)
        self.__output_reports[0].send()

    @abstractmethod  # 虚函数
    def response_handler(self, data):
        pass
