#include "usbhid.h"

#include <exception>
#include <QDebug>
#include <QDateTime>

#define USBD_HID_REPORT_ID 0x01

UsbHidThread::UsbHidThread(QObject* parent)
    : QThread(parent)
{
}

UsbHidThread::~UsbHidThread()
{
    stop();
}

void UsbHidThread::stop()
{
    if (m_bConnect)
    {
        hid_close(m_HidDevice);
        m_HidDevice = nullptr;
        m_bConnect  = false;
    }
}

bool UsbHidThread::isConnected()
{
    return m_bConnect;
}

bool UsbHidThread::sendData(const QByteArray& data)
{
    if (m_bConnect == false)
    {
        return false;
    }

    if (data.length() > (USBD_HID_OUT_REPORT_MAXSIZE - 1))
    {
        return false;
    }

    uint8_t rawbuff[USBD_HID_OUT_REPORT_MAXSIZE] = {0};

    // make hid frame
    rawbuff[0] = USBD_HID_REPORT_ID;
    memcpy(&rawbuff[1], data.constData(), data.length());

    uint16_t len = hid_write(m_HidDevice, rawbuff, sizeof(rawbuff));

    if (len < sizeof(rawbuff))
    {
        return false;
    }

    return true;
}

void UsbHidThread::pause()
{
    m_bPause = true;
}

void UsbHidThread::resume()
{
    m_bPause = false;
}

void UsbHidThread::run()
{
    uint8_t rxdata[USBD_HID_IN_REPORT_MAXSIZE];

    while (!m_bStop)
    {
        if (m_bPause)
        {
            continue;
        }

        if (m_bConnect)  // connected
        {
            // has data
            if (hid_read(m_HidDevice, rxdata, USBD_HID_IN_REPORT_MAXSIZE) >= USBD_HID_IN_REPORT_MAXSIZE)
            {
                emit dataReady(rxdata, USBD_HID_IN_REPORT_MAXSIZE);
            }

            // check if disconnect
            if ((QDateTime::currentMSecsSinceEpoch() - tick) > 100)
            {
                tick = QDateTime::currentMSecsSinceEpoch();

                wchar_t str[16];

                if (hid_get_serial_number_string(m_HidDevice, str, 16) != 0)
                {
                    m_HidDevice = hid_open(m_VendorID, m_ProductID, NULL);
                    m_bConnect  = false;
                    emit disconnected();
                }
            }

            if (m_TimeDlyUs > 0)
            {
                // release cpu
                usleep(m_TimeDlyUs);
            }
        }
        else  // disconnected
        {
            // try to open hid device
            m_HidDevice = hid_open(m_VendorID, m_ProductID, NULL);

            if (m_HidDevice == nullptr)
            {
                // fali to open
                msleep(10);  // release cpu
            }
            else
            {
                // success to open
                m_bConnect = true;

                hid_set_nonblocking(m_HidDevice, true);

                // wchar_t wchar_str[64];
                // hid_get_product_string(m_HidDevice, wchar_str, 64);
                // hid_get_serial_number_string(m_HidDevice, wchar_str, 64);

                tick = QDateTime::currentMSecsSinceEpoch();

                emit connected();
            }
        }
    }

    quit();
}

void UsbHidThread::scan()
{
    hid_device_info* devs    = hid_enumerate(0x0, 0x0);  // 枚举所有设备
    hid_device_info* cur_dev = devs;

    while (cur_dev)
    {
        qDebug() << "Device Found";
        qDebug() << "  Manufacturer:" << QString::fromWCharArray(cur_dev->manufacturer_string);
        qDebug() << "  Product:" << QString::fromWCharArray(cur_dev->product_string);
        qDebug() << "  Serial No:" << QString::fromWCharArray(cur_dev->serial_number);
        qDebug() << "  Path:" << QString::fromUtf8(cur_dev->path);
        cur_dev = cur_dev->next;
    }

    hid_free_enumeration(devs);
}

void UsbHidThread::enterHighPerformanceMode()
{
    m_TimeDlyUs = 0;
}

void UsbHidThread::exitHighPerformanceMode()
{
    m_TimeDlyUs = 10;
}
