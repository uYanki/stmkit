#ifndef USBHID_H
#define USBHID_H

#include <QThread>
#include <QByteArray>

#include <hidapi.h>

#define USBD_HID_IN_REPORT_MAXSIZE 64  // mcu2pc
#define USBD_HID_OUT_REPORT_MAXSIZE 64 // pc2mcu

class UsbHidThread : public QThread {
    Q_OBJECT
public:
    UsbHidThread(QObject* parent = nullptr);
    ~UsbHidThread();

    bool sendData(const QByteArray& data);

    void pause();
    void resume();
    void stop();

    bool isConnected();

    static void scan();

protected:
    void run() Q_DECL_OVERRIDE;  // 线程任务

signals:
    void connected();
    void disconnected();
    void dataReady(uint8_t* data, uint16_t length);

public:
    uint16_t m_VendorID;
    uint16_t m_ProductID;

private:
    qint64 tick;

    bool        m_bConnect  = false;
    hid_device* m_HidDevice = nullptr;

    bool m_bPause = false;
    bool m_bStop  = false;
};

#endif  // USBHID_H
