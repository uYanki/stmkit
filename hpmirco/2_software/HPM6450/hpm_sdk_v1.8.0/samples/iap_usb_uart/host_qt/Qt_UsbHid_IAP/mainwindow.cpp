#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QTimer>
#include <QDateTime>
#include <QFile>
#include <QFileInfo>
#include <QSettings>
#include <QFileDialog>
#include <QDebug>

#include "protocol.h"

QSettings settings("settings.ini", QSettings::IniFormat);

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
    ui->setupUi(this);

    ui->editVendorId->setText("0x34B7");
    ui->editProductId->setText("0xFFFF");

    ui->editFilePath1->setFocus();

    setAcceptDrops(true);
    ui->editFilePath1->setAcceptDrops(true);
    ui->editFilePath2->setAcceptDrops(true);
    ui->editFilePath3->setAcceptDrops(true);
    ui->editFilePath4->setAcceptDrops(true);
    ui->editLog->setAcceptDrops(false);

    m_UsbThread              = new UsbHidThread();
    m_UsbThread->m_VendorID  = 0x34B7;
    m_UsbThread->m_ProductID = 0xFFFF;

    m_lblConnStatus = new QLabel("", this);
    ui->statusbar->addWidget(m_lblConnStatus);
    updataConnStatusLabel();

    qRegisterMetaType<uint16_t>("uint16_t");
    connect(m_UsbThread, SIGNAL(dataReady(uint8_t*, uint16_t)), this, SLOT(onUsbDataReady(uint8_t*, uint16_t)), Qt::QueuedConnection);
    connect(m_UsbThread, SIGNAL(connected()), this, SLOT(onUsbConnected()), Qt::QueuedConnection);
    connect(m_UsbThread, SIGNAL(disconnected()), this, SLOT(onUsbDisconnected()), Qt::QueuedConnection);

    connect(ui->editFilePath1, &QLineEdit::textChanged, [=](const QString& newstr) {
        QFileInfo fileInfo(newstr);
        ui->editFileSize1->setText((fileInfo.isFile() && fileInfo.exists()) ? QString::number(fileInfo.size()) : QString(""));
    });

    connect(ui->editFilePath2, &QLineEdit::textChanged, [=](const QString& newstr) {
        QFileInfo fileInfo(newstr);
        ui->editFileSize2->setText((fileInfo.isFile() && fileInfo.exists()) ? QString::number(fileInfo.size()) : QString(""));
    });

    connect(ui->editFilePath3, &QLineEdit::textChanged, [=](const QString& newstr) {
        QFileInfo fileInfo(newstr);
        ui->editFileSize3->setText((fileInfo.isFile() && fileInfo.exists()) ? QString::number(fileInfo.size()) : QString(""));
    });

    connect(ui->editFilePath4, &QLineEdit::textChanged, [=](const QString& newstr) {
        QFileInfo fileInfo(newstr);
        ui->editFileSize4->setText((fileInfo.isFile() && fileInfo.exists()) ? QString::number(fileInfo.size()) : QString(""));
    });

    connect(ui->radioDownloadMode, &QRadioButton::clicked, [&]() {
        ui->editFileSize1->setReadOnly(true);
        ui->editFileSize2->setReadOnly(true);
        ui->editFileSize3->setReadOnly(true);
        ui->editFileSize4->setReadOnly(true);

        settings.beginGroup("Download");
        ui->editFilePath1->setText(settings.value("path1", QString("")).toString());
        ui->editFilePath2->setText(settings.value("path2", QString("")).toString());
        ui->editFilePath3->setText(settings.value("path3", QString("")).toString());
        ui->editFilePath4->setText(settings.value("path4", QString("")).toString());
        ui->editMemAddr1->setText(settings.value("addr1", QString("")).toString());
        ui->editMemAddr2->setText(settings.value("addr2", QString("")).toString());
        ui->editMemAddr3->setText(settings.value("addr3", QString("")).toString());
        ui->editMemAddr4->setText(settings.value("addr4", QString("")).toString());
        ui->chkTranferEn1->setChecked(settings.value("enable1", false).toBool());
        ui->chkTranferEn2->setChecked(settings.value("enable2", false).toBool());
        ui->chkTranferEn3->setChecked(settings.value("enable3", false).toBool());
        ui->chkTranferEn4->setChecked(settings.value("enable4", false).toBool());
        settings.endGroup();
    });

    connect(ui->radioUploadMode, &QRadioButton::clicked, [&]() {
        ui->editFileSize1->setReadOnly(false);
        ui->editFileSize2->setReadOnly(false);
        ui->editFileSize3->setReadOnly(false);
        ui->editFileSize4->setReadOnly(false);

        settings.beginGroup("Upload");
        ui->editFilePath1->setText(settings.value("path1", QString("")).toString());
        ui->editFilePath2->setText(settings.value("path2", QString("")).toString());
        ui->editFilePath3->setText(settings.value("path3", QString("")).toString());
        ui->editFilePath4->setText(settings.value("path4", QString("")).toString());
        ui->editMemAddr1->setText(settings.value("addr1", QString("")).toString());
        ui->editMemAddr2->setText(settings.value("addr2", QString("")).toString());
        ui->editMemAddr3->setText(settings.value("addr3", QString("")).toString());
        ui->editMemAddr4->setText(settings.value("addr4", QString("")).toString());
        ui->editFileSize1->setText(settings.value("size1", QString("")).toString());
        ui->editFileSize2->setText(settings.value("size2", QString("")).toString());
        ui->editFileSize3->setText(settings.value("size3", QString("")).toString());
        ui->editFileSize4->setText(settings.value("size4", QString("")).toString());
        ui->chkTranferEn1->setChecked(settings.value("enable1", false).toBool());
        ui->chkTranferEn2->setChecked(settings.value("enable2", false).toBool());
        ui->chkTranferEn3->setChecked(settings.value("enable3", false).toBool());
        ui->chkTranferEn4->setChecked(settings.value("enable4", false).toBool());
        settings.endGroup();
    });

    ui->radioDownloadMode->click();

    ui->editFilePath1->installEventFilter(this);
    ui->editFilePath2->installEventFilter(this);
    ui->editFilePath3->installEventFilter(this);
    ui->editFilePath4->installEventFilter(this);

    m_UsbThread->start();
}

MainWindow::~MainWindow()
{
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
    QString  filePath     = event->mimeData()->urls().first().toLocalFile();
    QWidget* targetWidget = focusWidget();  // 焦点控件

    if (targetWidget == ui->editFilePath1 ||
        targetWidget == ui->editFilePath2 ||
        targetWidget == ui->editFilePath3 ||
        targetWidget == ui->editFilePath4)
    {
        QFileInfo file(filePath);

        if (file.isFile())
        {
            QLineEdit* edit = static_cast<QLineEdit*>(targetWidget);
            edit->setText(filePath);
        }
    }

    event->accept();
}

bool MainWindow::eventFilter(QObject* obj, QEvent* event)
{
    if (obj == ui->editFilePath1 || obj == ui->editFilePath2 || obj == ui->editFilePath3 || obj == ui->editFilePath4)
    {
        if (event->type() == QEvent::MouseButtonDblClick)
        {
            QString filepath = QFileDialog::getOpenFileName(
                nullptr,                          // 父窗口
                "选择文件",                       // 对话框标题
                "",                               // 默认目录
                "所有文件(*.*);;文本文件(*.bin)"  // 文件过滤器
            );

            if (!filepath.isEmpty())
            {
                QLineEdit* edit = static_cast<QLineEdit*>(obj);
                edit->setText(filepath);
            }

            return true;
        }
    }

    return QMainWindow::eventFilter(obj, event);
}

void MainWindow::updataConnStatusLabel()
{
    if (m_UsbThread->isConnected())
    {
        m_lblConnStatus->setText(" • Connected ");
        m_lblConnStatus->setStyleSheet("QLabel { color: green; font-size: 15px; }");
    }
    else
    {
        m_lblConnStatus->setText(" x Disconnected ");
        m_lblConnStatus->setStyleSheet("QLabel { color: red; font-size: 15px; }");
    }
}

void MainWindow::startDownload()
{
    data_total_txsize = m_TransferData[0].size();
    start_address     = m_TransferAddr[0];
    txdata            = m_TransferData[0];

    m_totalDownloadCount++;

//    if (ui->chkEarseSizeAlignUp->isChecked())
//    {
//        earse_size = (data_total_txsize / 0x1000 + ((data_total_txsize % 0x1000) ? 1 : 0)) * 0x1000;
//    }
//    else
    {
        earse_size = data_total_txsize;
    }

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
            log(QtInfoMsg, "download fail");
            log(QtCriticalMsg, QString("reponse error at %1 when downloading").arg(Protocol::stringify(pid)));
            ui->btnExecute->setEnabled(true);
            ui->btnExecute->setText("Execute");
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
                    log(QtInfoMsg, QString("earse flash at address 0x%1, length %2 bytes").arg(start_address, 8, 16, QLatin1Char('0')).arg(earse_size));
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
                    log(QtInfoMsg, "download begin");
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
                        ui->btnExecute->setText(QString("Downloading... %1%").arg(progress));
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
                m_TransferAddr.pop_front();
                m_TransferData.pop_front();

                if (m_TransferData.length() == 0)
                {
                    // new thread
                    QTimer::singleShot(0, [=] {
                        log(QtInfoMsg, "download end");
                        ui->btnExecute->setEnabled(true);
                        ui->btnExecute->setText("Execute");
                        ui->chkAutoDownload->setChecked(false);
                    });
                }
                else
                {
                    startDownload();
                }

                break;
            }

            default:
            {
                break;
            }
        }
    }
}

void MainWindow::startUpload()
{
    data_total_txsize = m_TransferSize[0];
    start_address     = m_TransferAddr[0];
    m_UsbThread->sendData(Protocol::SetMTA(start_address));
}

void MainWindow::doUpload(uint8_t* rxdata, uint16_t length)
{
    bool               err = rxdata[1] & 0x80 ? true : false;
    Protocol::PacketID pid = (Protocol::PacketID)(rxdata[1] & 0x7F);

    if (err)
    {
        log(QtCriticalMsg, QString("reponse error at %1 when downloading").arg(Protocol::stringify(pid)));
    }
    else
    {
        uint32_t data_once_txsize = USBD_HID_IN_REPORT_MAXSIZE - 1 - 2;

        if (data_once_txsize > 16)
        {
            data_once_txsize = 16;
        }

        switch (pid)
        {
            case Protocol::PacketID::IAP_CMD_SET_MTA:
            {
                current_pos  = 0;
                uint16_t len = std::min(data_total_txsize - current_pos, data_once_txsize);
                m_UsbThread->sendData(Protocol::BlockRead(len));
                current_pos += len;

                // new thread
                QTimer::singleShot(0, [=] {
                    ui->btnExecute->setEnabled(false);
                    log(QtInfoMsg, QString("upload start"));
                    log(QtInfoMsg, QString("starting from address 0x%1, upload %2 bytes of data").arg(start_address, 8, 16, QLatin1Char('0')).arg(data_total_txsize));
                    ui->btnExecute->setText(QString("Uploading... %1%").arg(0));
                });

                m_UsbThread->enterHighPerformanceMode();

                break;
            }

            case Protocol::PacketID::IAP_CMD_BLOCK_READ:
            {
                auto rawlen  = (rxdata[2] << 8) | rxdata[3];
                auto rawdata = QByteArray((const char*)&rxdata[4], rawlen);

                // new thread
                QTimer::singleShot(0, [=] {
                    log(QtDebugMsg, QString("0x%1 ").arg(current_pos, 8, 16, QLatin1Char('0')) + rawdata.toHex(' ') + QString(" | ") + QString::fromLocal8Bit(rawdata));
                });

                uint16_t len = std::min(data_total_txsize - current_pos, data_once_txsize);

                if (len > 0)
                {
                    m_UsbThread->sendData(Protocol::BlockRead(len));
                    current_pos += len;

                    // new thread
                    QTimer::singleShot(0, [=] {
                        uint16_t progress = 100 * current_pos / data_total_txsize;
                        ui->btnExecute->setText(QString("Uploading... %1%").arg(progress));
                    });
                }
                else
                {
                    m_UsbThread->exitHighPerformanceMode();

                    m_TransferAddr.pop_front();
                    m_TransferSize.pop_front();

                    if (m_TransferAddr.length() == 0)
                    {
                        // new thread
                        QTimer::singleShot(0, [=] {
                            log(QtInfoMsg, "upload end");
                            ui->btnExecute->setEnabled(true);
                            ui->btnExecute->setText(QString("Execute"));
                        });
                    }
                    else
                    {
                        startUpload();
                    }
                }

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
            message = QString("Debug: %1").arg(msg);
            color   = Qt::darkGray;
            break;
        case QtInfoMsg:
            message = QString("Info: %1").arg(msg);
            color   = Qt::darkGreen;
            break;
        case QtWarningMsg:
            message = QString("Warning: %1").arg(msg);
            color   = Qt::darkRed;
            break;
        case QtCriticalMsg:
            message = QString("Critical: %1").arg(msg);
            color   = Qt::red;
            break;
        case QtFatalMsg:
            message = QString("Fatal: %1").arg(msg);
            color   = Qt::red;
            break;
        default:
            return;
    }

    QString currentTime = QDateTime::currentDateTime().time().toString("hh:mm:ss");
    QString html        = QString("<font color=\"%1\">[%2] %3</font>").arg(color.name()).arg(currentTime).arg(message);
    ui->editLog->appendHtml(html);
}

void MainWindow::onUsbConnected()
{
    updataConnStatusLabel();
    log(QtInfoMsg, "device connected");

    if (ui->chkAutoDownload->isChecked())
    {
        on_btnExecute_clicked();
    }
}

void MainWindow::onUsbDisconnected()
{
    updataConnStatusLabel();
    log(QtWarningMsg, "device disconnected");
}

void MainWindow::onUsbDataReady(uint8_t* rxdata, uint16_t rxlen)
{
    if (ui->radioDownloadMode->isChecked())
    {
        doDownlaod(rxdata, rxlen);
    }
    else
    {
        doUpload(rxdata, rxlen);
    }
}

void MainWindow::on_btnExecute_clicked()
{
    if (ui->radioDownloadMode->isChecked())
    {
        QStringList filepaths;

        m_TransferAddr.clear();
        m_TransferData.clear();

        if (ui->chkTranferEn1->isChecked())
        {
            filepaths << ui->editFilePath1->text();
            m_TransferAddr.append(ui->editMemAddr1->text().toUInt(nullptr, 16));
        }
        if (ui->chkTranferEn2->isChecked())
        {
            filepaths << ui->editFilePath2->text();
            m_TransferAddr.append(ui->editMemAddr2->text().toUInt(nullptr, 16));
        }
        if (ui->chkTranferEn3->isChecked())
        {
            filepaths << ui->editFilePath3->text();
            m_TransferAddr.append(ui->editMemAddr3->text().toUInt(nullptr, 16));
        }
        if (ui->chkTranferEn4->isChecked())
        {
            filepaths << ui->editFilePath4->text();
            m_TransferAddr.append(ui->editMemAddr4->text().toUInt(nullptr, 16));
        }

        for (int i = 0; i < filepaths.count(); ++i)
        {
            const QString& filepath = filepaths[i];

            QFileInfo fileinfo(filepath);

            if (fileinfo.exists() && fileinfo.isFile())
            {
                if (fileinfo.size() > 1024 * 1024 * 2)  // 2M
                {
                    log(QtFatalMsg, QString("%1 to large").arg(filepath));
                    return;
                }

                QFile file(filepath);
                file.open(QIODevice::ReadOnly);
                m_TransferData.append(file.readAll());
                file.close();
            }
        }

        if (m_TransferData.count() == 0)
        {
            log(QtFatalMsg, QString("no data to download"));
            return;
        }

        startDownload();
    }
    else
    {
        m_TransferAddr.clear();
        m_TransferSize.clear();

        if (ui->chkTranferEn1->isChecked())
        {
            m_TransferAddr.append(ui->editMemAddr1->text().toUInt(nullptr, 16));
            m_TransferSize.append(ui->editFileSize1->text().toUInt(nullptr, 10));
        }
        if (ui->chkTranferEn2->isChecked())
        {
            m_TransferAddr.append(ui->editMemAddr2->text().toUInt(nullptr, 16));
            m_TransferSize.append(ui->editFileSize2->text().toUInt(nullptr, 10));
        }
        if (ui->chkTranferEn3->isChecked())
        {
            m_TransferAddr.append(ui->editMemAddr3->text().toUInt(nullptr, 16));
            m_TransferSize.append(ui->editFileSize3->text().toUInt(nullptr, 10));
        }
        if (ui->chkTranferEn4->isChecked())
        {
            m_TransferAddr.append(ui->editMemAddr4->text().toUInt(nullptr, 16));
            m_TransferSize.append(ui->editFileSize4->text().toUInt(nullptr, 10));
        }

        if (m_TransferAddr.count() == 0)
        {
            log(QtFatalMsg, QString("no data to upload"));
            return;
        }

        startUpload();
    }
}

void MainWindow::on_btnSavePath_clicked()
{
    if (ui->radioDownloadMode->isChecked())
    {
        settings.beginGroup("Download");
    }
    else
    {
        settings.beginGroup("Upload");
    }

    settings.setValue("path1", ui->editFilePath1->text());
    settings.setValue("path2", ui->editFilePath2->text());
    settings.setValue("path3", ui->editFilePath3->text());
    settings.setValue("path4", ui->editFilePath4->text());

    settings.setValue("addr1", ui->editMemAddr1->text());
    settings.setValue("addr2", ui->editMemAddr2->text());
    settings.setValue("addr3", ui->editMemAddr3->text());
    settings.setValue("addr4", ui->editMemAddr4->text());

    settings.setValue("enable1", ui->chkTranferEn1->isChecked());
    settings.setValue("enable2", ui->chkTranferEn2->isChecked());
    settings.setValue("enable3", ui->chkTranferEn3->isChecked());
    settings.setValue("enable4", ui->chkTranferEn4->isChecked());

    if (ui->radioUploadMode->isChecked())
    {
        settings.setValue("size1", ui->editFileSize1->text());
        settings.setValue("size2", ui->editFileSize2->text());
        settings.setValue("size3", ui->editFileSize3->text());
        settings.setValue("size4", ui->editFileSize4->text());
    }

    settings.endGroup();
}

void MainWindow::on_pushButton_2_clicked()
{
    ui->editMemAddr1->setText("0x41000");
}

void MainWindow::on_pushButton_clicked()
{
    ui->editMemAddr1->setText("0x20000");
    ui->editMemAddr2->setText("0x200000");
}
