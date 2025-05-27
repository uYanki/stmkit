#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMimeData>

#include <QLabel>
#include <QFile>

#include "usbhid.h"

QT_BEGIN_NAMESPACE
namespace Ui
{
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget* parent = nullptr);
    ~MainWindow();

    void log(QtMsgType type, const QString& msg);

protected:
    void dragEnterEvent(QDragEnterEvent* event) Q_DECL_OVERRIDE;
    void dropEvent(QDropEvent* event) Q_DECL_OVERRIDE;
    bool eventFilter(QObject* obj, QEvent* event) Q_DECL_OVERRIDE;

private:
    void updateConnStatusLabel();
    void updateDownloadCounter();

    bool isPrepareDownloading();
    bool isDownloading();

    uint32_t   start_address     = 0;
    uint32_t   current_pos       = 0;
    uint32_t   data_total_txsize = 0;
    uint32_t   earse_size        = 0;
    QByteArray txdata;

    void startDownload();
    void doDownlaod(uint8_t* rxdata, uint16_t length);

private slots:
    void onUsbConnected(const DeviceMacther& d);
    void onUsbDisconnected(const DeviceMacther& d);
    void onUsbDataReady(uint8_t* data, uint16_t length);

    void on_btnExecute_clicked();
    void on_btnSelectFile_clicked();

private:
    Ui::MainWindow* ui;

    UsbHidThread* m_UsbThread = nullptr;

    uint32_t   m_TransferAddr;
    QByteArray m_TransferData;

    uint16_t m_successDownloadCount = 0;
    uint16_t m_totalDownloadCount   = 0;
};
#endif  // MAINWINDOW_H
