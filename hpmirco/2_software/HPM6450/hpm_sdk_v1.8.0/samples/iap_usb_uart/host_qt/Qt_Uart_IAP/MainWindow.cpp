#include "MainWindow.h"
#include "ui_MainWindow.h"

#include "UART_SettingsDialog.h"

#include <QFileDialog>

#include <QDateTime>
#include <QMimeData>
#include <QDropEvent>

#include <QRegularExpression>

#include <QDebug>

#include "GlobalVariables.h"

extern uint16_t ModbusCrc16(const QByteArray& data);

MainWindow::MainWindow(QWidget* parent)
    : QMainWindow(parent), ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    //
    // 加载历史配置
    //

    gSettings.beginGroup("UartIap");
    QString filePath = gSettings.value("FilePath", "").toString();
    gSettings.endGroup();

    ui->inputFilePath->setText(filePath);

    //
    // 启用文件拖放
    //

    setAcceptDrops(true);
    ui->inputFilePath->setAcceptDrops(true);
    ui->inputLogArea->setAcceptDrops(false);

    //
    // 加载线程
    //

    qRegisterMetaType<IAP_Thread::Status>("Status");

    m_IapThread = new IAP_Thread();
    connect(m_IapThread, &IAP_Thread::downloadOver, this, &MainWindow::onIapDownloadOver, Qt::QueuedConnection);
    connect(m_IapThread, &IAP_Thread::showProgress, this, &MainWindow::onIapShowProgress, Qt::QueuedConnection);
    connect(m_IapThread, &IAP_Thread::showDeviceMessage, this, &MainWindow::onIapShowDeviceMessage, Qt::QueuedConnection);
}

MainWindow::~MainWindow()
{
    m_IapThread->stop();
    delete ui;
}

void MainWindow::log(QtMsgType type, const QString& msg)
{
    QString message;
    QColor  color;

    switch (type)
    {
        case QtDebugMsg:
            message = QString("%1").arg(msg);
            color   = Qt::darkGray;
            break;
        case QtInfoMsg:
            message = QString("%1").arg(msg);
            color   = Qt::darkGreen;
            break;
        case QtWarningMsg:
            message = QString("%1").arg(msg);
            color   = Qt::darkRed;
            break;
        case QtCriticalMsg:
            message = QString("%1").arg(msg);
            color   = Qt::red;
            break;
        case QtFatalMsg:
            message = QString("%1").arg(msg);
            color   = Qt::red;
            break;
        default:
            return;
    }

    QString currentTime = QDateTime::currentDateTime().time().toString("hh:mm:ss");
    QString html        = QString("<font color=\"%1\">[%2] %3</font>").arg(color.name()).arg(currentTime).arg(message);

    ui->inputLogArea->appendHtml(html);
}

void MainWindow::on_actConnectDevice_triggered()
{
    ui->actConnectDevice->setChecked(false);

    UART_SettingsDialog dialog(m_IapThread->m_UartConfig);
    dialog.exec();
}

void MainWindow::on_btnStartToDownload_clicked()
{
    QString filePath = ui->inputFilePath->text();

    //
    // check if serial port is vaild
    //

    QFileInfo fileInfo(filePath);

    QSerialPortInfo portInfo(m_IapThread->m_UartConfig.port);

    if(m_IapThread->m_UartConfig.port.isEmpty())
    {
        log(QtWarningMsg, "no port has been selected");
        return;
    }

    if(portInfo.isValid() == false)
    {
        log(QtWarningMsg, "this port is invaild");
        return;
    }

    if (portInfo.isBusy())
    {
        log(QtWarningMsg, "this port is busy");
        return;
    }

    //
    // check if file is vaild
    //

    if (fileInfo.exists() == false)
    {
        log(QtWarningMsg, "file no exist");
        return;
    }

    if (fileInfo.size() == 0)
    {
        log(QtWarningMsg, "no bytes to be downloaded");
        return;
    }

    if (fileInfo.size() >= 1024 * 1024 * 2)
    {
        log(QtWarningMsg, "file too large");
        return;
    }

    QFile file(filePath);

    if (file.open(QIODevice::ReadOnly) == false)
    {
        log(QtWarningMsg, "fail to open file");
        return;
    }

    QByteArray fileData = file.readAll();

    log(QtDebugMsg, QString("load file: %1 (%2 bytes)").arg(filePath).arg(fileData.size()));

    file.close();

    gSettings.beginGroup("UartIap");
    gSettings.setValue("FilePath", filePath);
    gSettings.endGroup();

    //
    // run iap
    //

    if(m_IapThread->start(fileData))
    {
        m_IapTotalCounter++;
        ui->btnStartToDownload->setEnabled(false);
        log(QtInfoMsg, "start to download");
    }
}

void MainWindow::onIapShowDeviceMessage(const QString& message)
{
    QRegularExpression nonAsciiRegex("[^\\x00-\\x7F]+");
    QString            text = QString(message).trimmed().remove(nonAsciiRegex);

    if (text.isEmpty())
    {
        return;
    }

    QTextCharFormat format;
    format.setForeground(QColor("blue"));  // 设置文本颜色

    ui->inputLogArea->moveCursor(QTextCursor::End);
    QTextCursor cursor = ui->inputLogArea->textCursor();
    cursor.mergeCharFormat(format);

    cursor.insertText("\n");  // new line
    cursor.insertText(text);
}

void MainWindow::onIapShowProgress(uint32_t current, uint32_t total)
{
    ui->progressBar->setMaximum(total);
    ui->progressBar->setValue(current);
}

void MainWindow::onIapDownloadOver(IAP_Thread::Status status)
{
    switch (status) {
        case IAP_Thread::Status::Success: {
            m_IapSuccessCounter++;
            log(QtInfoMsg, "success to download");
            break;
        }
        case IAP_Thread::Status::Failure: {
            log(QtCriticalMsg, "fail to download, device response an error");
            break;
        }
        case IAP_Thread::Status::Timeout: {
            log(QtCriticalMsg, "fail to download, device response timeout");
            break;
        }
        case IAP_Thread::Status::Disconnect:
        {
            log(QtCriticalMsg, "fail to download, serial port is unaccessible");
            break;
        }
        default: {
            break;
        }
    }

    ui->lblDownloadCounter->setText(QString::asprintf("%d/%d", m_IapSuccessCounter, m_IapTotalCounter));
    ui->btnStartToDownload->setEnabled(true);
}

void MainWindow::on_btnSeleteFile_clicked()
{
    QString filepath = QFileDialog::getOpenFileName(
        nullptr,                            // 父窗口
        "选择文件",                         // 对话框标题
        "",                                 // 默认目录
        "二进制文件(*.bin);;所有文件(*.*)"  // 文件过滤器
    );

    if (!filepath.isEmpty())
    {
        ui->inputFilePath->setText(filepath);
    }
}

void MainWindow::dragEnterEvent(QDragEnterEvent* event)
{
    // 检查是否包含文件路径
    if (event->mimeData()->hasUrls())
    {
        // 接受拖拽事件
        event->acceptProposedAction();
    }
}

void MainWindow::dropEvent(QDropEvent* event)
{
    QString filePath = event->mimeData()->urls().first().toLocalFile();

    QFileInfo file(filePath);

    if (file.isFile())
    {
        ui->inputFilePath->setText(filePath);
    }

    event->accept();
}

void MainWindow::on_inputFilePath_textChanged(const QString& filePath)
{
    QFileInfo fileInfo(filePath);
    ui->inputFileSize->setText(QString::asprintf("%lld bytes", fileInfo.size()));
}

