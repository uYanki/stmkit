#include "UART_SettingsDialog.h"
#include "ui_UART_SettingsDialog.h"

#include <QThread>
#include <QDateTime>
#include <QModbusRtuSerialMaster>

#include <QSerialPort>
#include <QSerialPortInfo>

#include "GlobalVariables.h"

UART_SettingsDialog::UART_SettingsDialog(UART_Config& config, QWidget* parent)
    : QDialog(parent),
      ui(new Ui::UART_SettingsDialog),
      m_UartConfig(config)
{
    ui->setupUi(this);

    // 移除帮助按钮标志
    setWindowFlags(windowFlags() & ~Qt::WindowContextHelpButtonHint);

    // 端口描述 description

    ui->lblPortDesc->setVisible(false);

    // 波特率 baudrate

    ui->cmbBaudrate->addItems(QStringList() << "4800"
                                            << "9600"
                                            << "19200"
                                            << "38400"
                                            << "57600"
                                            << "115200"
                                            << "460800"
                                            << "921600"
                                            << "1000000");

    // 数据位 databits

    ui->cmbDatabits->addItem("8", QSerialPort::DataBits::Data8);
    ui->cmbDatabits->addItem("7", QSerialPort::DataBits::Data7);
    ui->cmbDatabits->addItem("6", QSerialPort::DataBits::Data6);
    ui->cmbDatabits->addItem("5", QSerialPort::DataBits::Data5);

    // 停止位 stopbits

    ui->cmbStopbits->addItem("1", QSerialPort::StopBits::OneStop);
    ui->cmbStopbits->addItem("1.5", QSerialPort::StopBits::OneAndHalfStop);
    ui->cmbStopbits->addItem("2", QSerialPort::StopBits::TwoStop);

    // 奇偶校验位 parity

    ui->cmbParity->addItem("No", QSerialPort::Parity::NoParity);
    ui->cmbParity->addItem("Even", QSerialPort::Parity::EvenParity);
    ui->cmbParity->addItem("Odd", QSerialPort::Parity::OddParity);
    ui->cmbParity->addItem("Space", QSerialPort::Parity::SpaceParity);
    ui->cmbParity->addItem("Mark", QSerialPort::Parity::MarkParity);

    scan();
}

UART_SettingsDialog::~UART_SettingsDialog()
{
    delete ui;
}

void UART_SettingsDialog::scan()
{
    ui->cmbPortName->clear();

    Q_FOREACH (const QSerialPortInfo& info, QSerialPortInfo::availablePorts())
    {
        if (info.isBusy())
        {
            // 忽略被占用的端口
            continue;
        }

        ui->cmbPortName->addItem(info.portName(), info.description());
    }

    if (ui->cmbPortName->count() > 0)
    {
        if (m_UartConfig.port.isEmpty() == false)
        {
            int index = ui->cmbPortName->findText(m_UartConfig.port);
            ui->cmbPortName->setCurrentIndex(qMax(index, 0));
        }

        // ui->lblPortDesc->setVisible(true);
    }
    else
    {
        ui->lblPortDesc->setVisible(false);
    }
}

void UART_SettingsDialog::on_buttonBox_accepted()
{
    QString port = ui->cmbPortName->currentText();

    if (port.isEmpty() == false)
    {
        // 应用当前配置
        m_UartConfig.port     = port;
        m_UartConfig.baudrate = (QSerialPort::BaudRate)(ui->cmbBaudrate->currentText().toInt());
        m_UartConfig.databits = ui->cmbDatabits->currentData().value<QSerialPort::DataBits>();
        m_UartConfig.parity   = ui->cmbParity->currentData().value<QSerialPort::Parity>();
        m_UartConfig.stopbits = ui->cmbStopbits->currentData().value<QSerialPort::StopBits>();
        m_UartConfig.save();
    }
}

void UART_SettingsDialog::on_cmbPortName_currentTextChanged(const QString& port)
{
    QString desc = ui->cmbPortName->currentData().toString();
    ui->lblPortDesc->setText(desc);
    ui->lblPortDesc->setToolTip(desc);
    ui->lblPortDesc->setVisible(desc.isEmpty() == false);

    if (port.isEmpty() == false)
    {
        // 加载历史配置
        UART_Config config(port);
        ui->cmbBaudrate->setCurrentIndex(ui->cmbBaudrate->findText(QString::number(config.baudrate)));
        ui->cmbDatabits->setCurrentIndex(ui->cmbDatabits->findData(config.databits));
        ui->cmbParity->setCurrentIndex(ui->cmbParity->findData(config.parity));
        ui->cmbStopbits->setCurrentIndex(ui->cmbStopbits->findData(config.stopbits));
    }
}
