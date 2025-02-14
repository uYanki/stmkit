#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

#include <QSettings>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_btnParaTblSel_clicked();
    void on_btnTunerDBSel_clicked();
    void on_btnTunerExeSel_clicked();
    void on_btnGenerate_clicked();
    void on_btnParaTblGo_clicked();
    void on_btnTunerDBGo_clicked();
    void on_btnTunerExeGo_clicked();

private:
    Ui::MainWindow *ui;

    QSettings *m_IniCfg;
};
#endif // MAINWINDOW_H
