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
    void dragEnterEvent(QDragEnterEvent* event);
    void dropEvent(QDropEvent* event);
    bool eventFilter(QObject *obj, QEvent *event) Q_DECL_OVERRIDE;

private:
    void updataConnStatusLabel();

    uint32_t   start_address     = 0;
    uint32_t   current_pos       = 0;
    uint32_t   data_total_txsize = 0;
    uint32_t   earse_size = 0;
    QByteArray txdata;

    void startDownload();
    void doDownlaod(uint8_t* rxdata, uint16_t length);

    void startUpload();
    void doUpload(uint8_t* rxdata, uint16_t length);

private slots:
    void onUsbConnected();
    void onUsbDisconnected();
    void onUsbDataReady(uint8_t* data, uint16_t length);
    void on_btnExecute_clicked();

    void on_btnSavePath_clicked();

private:
    Ui::MainWindow* ui;

    UsbHidThread* m_UsbThread = nullptr;

    QLabel* m_lblConnStatus = nullptr;

    QVector<uint32_t>   m_TransferAddr;
    QVector<uint32_t>   m_TransferSize;
    QVector<QByteArray> m_TransferData;

    uint16_t m_successDownloadCount = 0;
    uint16_t m_totalDownloadCount   = 0;
};
#endif  // MAINWINDOW_H
