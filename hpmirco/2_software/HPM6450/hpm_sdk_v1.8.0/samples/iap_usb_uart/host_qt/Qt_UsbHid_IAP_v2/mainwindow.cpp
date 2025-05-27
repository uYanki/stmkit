#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QTimer>
#include <QDateTime>
#include <QFile>
#include <QFileInfo>
#include <QSettings>
#include <QFileDialog>
#include <QDebug>

#include <QSettings>

#include "protocol.h"

QSettings Settings("Settings.ini", QSettings::IniFormat);
QSettings DeviceList("DeviceList.ini", QSettings::IniFormat);

uint16_t ModbusCRC16(uint8_t* pucFrame, uint32_t usLen)
{
    static const uint8_t aucCRCHi[] = {
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40};

    static const uint8_t aucCRCLo[] = {
        0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7, 0x05, 0xC5, 0xC4, 0x04, 0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09, 0x08, 0xC8, 0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD, 0x1D, 0x1C, 0xDC, 0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3, 0x11, 0xD1, 0xD0, 0x10, 0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32, 0x36, 0xF6, 0xF7, 0x37, 0xF5, 0x35, 0x34, 0xF4, 0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A, 0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38, 0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE, 0x2E, 0x2F, 0xEF, 0x2D, 0xED, 0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26, 0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0, 0xA0, 0x60, 0x61, 0xA1, 0x63, 0xA3, 0xA2, 0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4, 0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F, 0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68, 0x78, 0xB8, 0xB9, 0x79, 0xBB, 0x7B, 0x7A, 0xBA, 0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5, 0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0, 0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C, 0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98, 0x88, 0x48, 0x49, 0x89, 0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C, 0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80, 0x40};

    uint8_t ucCRCHi = 0xFF;
    uint8_t ucCRCLo = 0xFF;
    int     iIndex;

    while (usLen--)
    {
        iIndex  = ucCRCLo ^ *(pucFrame++);
        ucCRCLo = ucCRCHi ^ aucCRCHi[iIndex];
        ucCRCHi = aucCRCLo[iIndex];
    }

    return ucCRCHi << 8 | ucCRCLo;
}

MainWindow::MainWindow(QWidget* parent)
    : QMainWindow(parent), ui(new Ui::MainWindow)
{
#if 0

    DeviceList.beginGroup("B5S_V0");
    DeviceList.setValue("USBD_VID", 0x33C3);
    DeviceList.setValue("USBD_PID", 0x7788);
    DeviceList.setValue("BIN_Name", "CTSD-B5S_V0-CAN-ABS_TAMAGAWA_GE");
    DeviceList.setValue("BIN_Offset", 0x41000);
    DeviceList.endGroup();

    DeviceList.beginGroup("B5N_V0");
    DeviceList.setValue("USBD_VID", 0x34B7);
    DeviceList.setValue("USBD_PID", 0xFFFF);
    DeviceList.setValue("BIN_Name", "CTSD-B5N_V0-CAN-ABS_TAMAGAWA_GE");
    DeviceList.setValue("BIN_Offset", 0x20000);
    DeviceList.endGroup();

#endif

    m_UsbThread = new UsbHidThread();

    Q_FOREACH( auto groupName,  DeviceList.childGroups() )
    {
        DeviceMacther m;

        DeviceList.beginGroup(groupName);

        m.DeviceName = groupName;
        m.VendorID = DeviceList.value("USBD_VID", 0).toUInt();
        m.ProductID = DeviceList.value("USBD_PID", 0).toUInt();
        m.BinName = DeviceList.value("BIN_Name", 0).toString();
        m.BinOffset = DeviceList.value("BIN_Offset", "").toUInt();

        DeviceList.endGroup();

        qDebug() << m.DeviceName << m.VendorID << m.ProductID << m.BinName << m.BinOffset;

        if( m.BinOffset == 0 || m.BinName.isEmpty() )
        {
            continue;
        }

        m_UsbThread->addDevice(m);
    }


    ui->setupUi(this);

    ui->editFilePath->setFocus();

    setAcceptDrops(true);
    ui->editFilePath->setAcceptDrops(true);
    ui->editLog->setAcceptDrops(false);

    updateConnStatusLabel();

    qRegisterMetaType<uint16_t>("uint16_t");
    qRegisterMetaType<DeviceMacther>("DeviceMacther");
    connect(m_UsbThread, SIGNAL(dataReady(uint8_t*, uint16_t)), this, SLOT(onUsbDataReady(uint8_t*, uint16_t)), Qt::QueuedConnection);
    connect(m_UsbThread, SIGNAL(connected(const DeviceMacther&)), this, SLOT(onUsbConnected(const DeviceMacther&)), Qt::QueuedConnection);
    connect(m_UsbThread, SIGNAL(disconnected(const DeviceMacther&)), this, SLOT(onUsbDisconnected(const DeviceMacther&)), Qt::QueuedConnection);

    connect(ui->editFilePath, &QLineEdit::textChanged, [=](const QString& newstr) {
        QFileInfo fileInfo(newstr);
        ui->editFileSize->setText((fileInfo.isFile() && fileInfo.exists()) ? QString::number(fileInfo.size()) : QString(""));
    });

    // reload path
    Settings.beginGroup("File");
    ui->editFilePath->setText(Settings.value("path", QString("")).toString());
    Settings.endGroup();

    ui->editFilePath->installEventFilter(this);

    m_UsbThread->start();
}

MainWindow::~MainWindow()
{
    // save path
    Settings.beginGroup("File");
    Settings.setValue("path", ui->editFilePath->text());
    Settings.endGroup();

    delete ui;
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
    QString  filePath = event->mimeData()->urls().first().toLocalFile();

    QFileInfo file(filePath);

    if (file.isFile())
    {
        ui->editFilePath->setText(filePath);
    }

    event->accept();
}

bool MainWindow::eventFilter(QObject* obj, QEvent* event)
{
    if (obj == ui->editFilePath)
    {
        if (event->type() == QEvent::MouseButtonDblClick)
        {
            on_btnSelectFile_clicked();
            return true;
        }
    }

    return QMainWindow::eventFilter(obj, event);
}

void MainWindow::updateConnStatusLabel()
{
    if (m_UsbThread->isConnected())
    {
        ui->lblConnStatus->setText(" • Connected ");
        ui->lblConnStatus->setStyleSheet("QLabel { color: green; font-size: 12px; }");
    }
    else
    {
        ui->lblConnStatus->setText(" x Disconnected ");
        ui->lblConnStatus->setStyleSheet("QLabel { color: red; font-size: 12px; }");
    }
}

void MainWindow::updateDownloadCounter()
{
    QString s = QString::asprintf("%d/%d", m_successDownloadCount, m_totalDownloadCount);

    ui->lblDownloadCounter->setText(s);
}

bool MainWindow::isPrepareDownloading()
{
    return ui->btnExecute->isChecked();
}

bool MainWindow::isDownloading()
{
    return ui->btnExecute->isChecked() && (ui->btnExecute->isEnabled() == false);
}

void MainWindow::startDownload()
{
    data_total_txsize = m_TransferData.size();
    start_address     = m_TransferAddr;
    txdata            = m_TransferData;

    m_totalDownloadCount++;
    earse_size = data_total_txsize;

    m_UsbThread->sendData(Protocol::Earse(start_address, earse_size));
}

void MainWindow::doDownlaod(uint8_t* rxdata, uint16_t rxlen)  // USB不会丢帧, 不需要加入重发机制
{
    // USBD_HID_REPORT_MAXSIZE - 1/* report id */ - 1 /* packet id */ - 2 /* length */
    uint32_t data_once_txsize = USBD_HID_OUT_REPORT_MAXSIZE - 4;  // 单次最大发送长度

    bool               err = rxdata[1] & 0x80 ? true : false;
    Protocol::PacketID pid = (Protocol::PacketID)(rxdata[1] & 0x7F);

    if (err)
    {
        // new thread
        QTimer::singleShot(0, [=] {
            log(QtInfoMsg, "下载失败");
            log(QtCriticalMsg, QString("响应错误 %1").arg(Protocol::stringify(pid)));
            ui->btnExecute->setEnabled(true);
            ui->btnExecute->setText("开始下载");
        });
    }
    else
    {
        switch (pid)
        {
            case Protocol::PacketID::IAP_CMD_EARSE:
            {
                m_UsbThread->sendData(Protocol::SetMTA(start_address));

                // 使用QTimer来更新UI, 防止非主线程中操作UI导致奔溃
                QTimer::singleShot(0, [=] {
                    ui->btnExecute->setEnabled(false);
                    updateDownloadCounter();
                    log(QtInfoMsg, QString::asprintf("擦除芯片: %X@%X", earse_size, start_address));
                });

                break;
            }

            case Protocol::PacketID::IAP_CMD_SET_MTA:
            {
                current_pos    = 0;
                uint32_t txlen = std::min(data_total_txsize - current_pos, data_once_txsize);
                m_UsbThread->sendData(Protocol::BlockWrite(txdata.mid(current_pos, txlen)));
                current_pos += txlen;

                // new thread
                QTimer::singleShot(0, [=] {
                    log(QtInfoMsg, "开始下载");
                });

                m_UsbThread->enterHighPerformanceMode();

                break;
            }

            case Protocol::PacketID::IAP_CMD_BLOCK_WRITE:  // 等响应后再发
            {
                uint32_t txlen = std::min(data_total_txsize - current_pos, data_once_txsize);

                if (txlen > 0)
                {
                    m_UsbThread->sendData(Protocol::BlockWrite(txdata.mid(current_pos, txlen)));
                    current_pos += txlen;

                    // new thread
                    QTimer::singleShot(0, [=] {
                        uint16_t progress = 100 * current_pos / data_total_txsize;
                        ui->btnExecute->setText(QString("下载中... %1%").arg(progress));
                    });
                }
                else
                {
                    m_UsbThread->exitHighPerformanceMode();

                     uint16_t crc16 = ModbusCRC16((uint8_t*)txdata.constData(), txdata.length());  // usb有硬件校验,此处不使用
                     m_UsbThread->sendData(Protocol::BlockWriteEnd(crc16));
                }

                break;
            }

            case Protocol::PacketID::IAP_CMD_BLOCK_WRITE_END:
            {
                // new thread
                QTimer::singleShot(0, [=] {
                    m_successDownloadCount++;
                    log(QtInfoMsg, "下载成功");
                    ui->btnExecute->setEnabled(true);
                    ui->btnExecute->setChecked(false);
                    ui->btnExecute->setText("开始下载");
                    updateDownloadCounter();
                });

                break;
            }

            default:
            {
                break;
            }
        }
    }
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
    ui->editLog->appendHtml(html);
}

void MainWindow::onUsbConnected(const DeviceMacther& d)
{
    updateConnStatusLabel();

    if(isPrepareDownloading())
    {
        log(QtInfoMsg, QString("%1 已连接").arg(d.DeviceName));

        //
        // 合法性判断
        //

        if(!ui->editFilePath->text().contains(d.BinName))
        {
            log(QtWarningMsg, "固件不匹配");
            ui->btnExecute->setText("开始下载");
            ui->btnExecute->setChecked(false);
            return;
        }

        //
        // 开始下载
        //

        m_TransferAddr = d.BinOffset;

        startDownload();

    }
}

void MainWindow::onUsbDisconnected(const DeviceMacther &d)
{
    updateConnStatusLabel();

    if( isDownloading() )
    {
        uint16_t progress = 100 * current_pos / data_total_txsize;

        log(QtWarningMsg, QString("%1 已断开").arg(d.DeviceName));
        log(QtCriticalMsg, QString("下载失败：%1%").arg(progress));

        ui->btnExecute->setEnabled(true);
        ui->btnExecute->setChecked(false);
        ui->btnExecute->setText("开始下载");
        updateDownloadCounter();
    }
}

void MainWindow::onUsbDataReady(uint8_t* rxdata, uint16_t rxlen)
{
    doDownlaod(rxdata, rxlen);
}


void MainWindow::on_btnExecute_clicked()
{
    if(ui->btnExecute->isChecked())
    {
        QString filepath = ui->editFilePath->text();
        QFileInfo fileinfo(filepath);

        if(!fileinfo.exists())
        {
            log(QtWarningMsg, "固件不存在");
            ui->btnExecute->setChecked(false);
            return;
        }

        if (fileinfo.size() > 1024 * 1024)  // 1M
        {
            log(QtWarningMsg, "固件过大");
            ui->btnExecute->setChecked(false);
            return;
        }

        QFile file(filepath);
        file.open(QIODevice::ReadOnly);
        m_TransferData = file.readAll();
        file.close();

        ui->btnExecute->setText("取消下载");
        ui->btnExecute->setChecked(true);

        log(QtDebugMsg, QString("准备下载: %1, 共 %2 字节").arg(fileinfo.fileName()).arg(fileinfo.size()));
    }
    else
    {
        ui->btnExecute->setText("开始下载");
        ui->btnExecute->setChecked(false);

        log(QtDebugMsg, "取消下载");
    }
}

void MainWindow::on_btnSelectFile_clicked()
{
    QString filepath = QFileDialog::getOpenFileName(
        nullptr,                          // 父窗口
        "选择文件",                       // 对话框标题
        "",                               // 默认目录
        "二进制文件(*.bin);;所有文件(*.*)"  // 文件过滤器
    );

    if (!filepath.isEmpty())
    {
        ui->editFilePath->setText(filepath);
    }
}
