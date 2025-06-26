#ifndef IAP_THREAD_H
#define IAP_THREAD_H

#include <QThread>

#include <QFile>
#include <QFileInfo>

#include <QSerialPort>
#include <QSerialPortInfo>

#include "UART_Config.h"

class IAP_Thread : public QThread
{
    Q_OBJECT

public:
    enum Status {
        Success, // 设备响应成功
        Failure, // 设备响应失败
        Timeout, // 设备未响应
        Disconnect, // 串口断开
    };

public:
    IAP_Thread(QObject* parent = Q_NULLPTR);
    ~IAP_Thread();

    bool start(const QByteArray& fileData);
    void stop();

signals:
    // void showHostMessage(const QString& message);
    void showDeviceMessage(const QString& message);
    void showProgress(uint32_t current, uint32_t total); // 下载进度
    void downloadOver(Status status); // 下载线程结束

private slots:
    void onSerialErrorOccurred(QSerialPort::SerialPortError error);

protected:
    void run() Q_DECL_OVERRIDE;

private:
    QSerialPort* SerialPort = Q_NULLPTR;
    QByteArray m_TransferData;

public:
    UART_Config m_UartConfig;
};

#endif // IAP_THREAD_H
