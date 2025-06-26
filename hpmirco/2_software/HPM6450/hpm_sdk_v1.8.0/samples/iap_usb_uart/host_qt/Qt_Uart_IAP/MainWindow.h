#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

#include "IAP_Thread.h"

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

private slots:
    void on_actConnectDevice_triggered();
    void on_btnStartToDownload_clicked();
    void on_btnSeleteFile_clicked();
    void on_inputFilePath_textChanged(const QString& arg1);

    void onIapShowDeviceMessage(const QString& message);
    void onIapShowProgress(uint32_t current, uint32_t total);
    void onIapDownloadOver(IAP_Thread::Status status);

protected:
    void dragEnterEvent(QDragEnterEvent* event) Q_DECL_OVERRIDE;
    void dropEvent(QDropEvent* event) Q_DECL_OVERRIDE;

private:
    Ui::MainWindow* ui;

    IAP_Thread* m_IapThread         = Q_NULLPTR;
    uint16_t    m_IapTotalCounter   = 0;
    uint16_t    m_IapSuccessCounter = 0;
};

#endif  // MAINWINDOW_H
