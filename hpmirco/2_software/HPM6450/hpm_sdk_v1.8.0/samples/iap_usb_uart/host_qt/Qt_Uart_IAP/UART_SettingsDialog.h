#ifndef UART_SETTINGSDIALOG_H
#define UART_SETTINGSDIALOG_H

#include <QDialog>

#include "UART_Config.h"

namespace Ui
{
class UART_SettingsDialog;
}

class UART_SettingsDialog : public QDialog {
    Q_OBJECT

public:
    explicit UART_SettingsDialog(UART_Config& config, QWidget* parent = nullptr);
    ~UART_SettingsDialog();

private slots:
    void scan();

private slots:
    void on_cmbPortName_currentTextChanged(const QString& arg1);
    void on_buttonBox_accepted();

private:
    Ui::UART_SettingsDialog* ui;

    UART_Config& m_UartConfig;
};

#endif  // UART_SETTINGSDIALOG_H
