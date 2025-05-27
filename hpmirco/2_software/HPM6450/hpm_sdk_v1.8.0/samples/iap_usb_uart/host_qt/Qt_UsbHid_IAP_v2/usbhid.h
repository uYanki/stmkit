#ifndef USBHID_H
#define USBHID_H

#include <QThread>
#include <QByteArray>
#include <QSet>
#include <hidapi.h>

#define USBD_HID_IN_REPORT_MAXSIZE  64  // mcu2pc
#define USBD_HID_OUT_REPORT_MAXSIZE 64  // pc2mcu

class DeviceMacther {
public:

    DeviceMacther() = default;

#if 0 // for QSet<DeviceMacther>()

    bool operator==(const DeviceMacther& other) const
    {
        return other.VendorID == VendorID && other.ProductID == ProductID;
    }

    friend uint qHash(const DeviceMacther& other)
    {
        return (other.VendorID << 16) |  other.ProductID;
    }

#endif

    QString  DeviceName = "";
    uint16_t VendorID = 0;
    uint16_t ProductID = 0;
    uint32_t BinOffset = 0;
    QString  BinName = 0;
};

class UsbHidThread : public QThread {
    Q_OBJECT
public:
    UsbHidThread(QObject* parent = nullptr);
    ~UsbHidThread();

    bool sendData(const QByteArray& data);

    void stop();

    bool isConnected();

    const DeviceMacther &connectedDevice() const;

    static void scan();

    void enterHighPerformanceMode();
    void exitHighPerformanceMode();

    void addDevice(const DeviceMacther& d);

protected:
    void run() Q_DECL_OVERRIDE;  // 线程任务

signals:
    void connected(const DeviceMacther& d);
    void disconnected(const DeviceMacther& d);
    void dataReady(uint8_t* data, uint16_t length);

public:


private:
    qint64 tick;

    bool        m_bConnect  = false;
    hid_device* m_HidDevice = nullptr;

    bool m_bStop  = false;

    uint16_t m_TimeDlyUs = 10;  // for release cpu when connected

    DeviceMacther m_ConnectedDevice;
    QVector<DeviceMacther> m_DeviceList;
};

#endif  // USBHID_H
