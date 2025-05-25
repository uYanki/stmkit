#ifndef MYMAINWINDOW_H
#define MYMAINWINDOW_H

#include <QMainWindow>
#include <QMap>
#include <QTimer>

#include <inttypes.h>
#include "ethercat.h"
QT_BEGIN_NAMESPACE
namespace Ui { class myMainWindow; }
QT_END_NAMESPACE

class myMainWindow : public QMainWindow
{
    Q_OBJECT

public:
    myMainWindow(QWidget *parent = nullptr);
    ~myMainWindow();
    void getEthInfo(void);  /* 获取网卡信息 */
private slots:
    void connectToSlavers(void);   /* 配置Ethercat从站 */
    void pdoTaskTimout(void);    /* 定时器槽函数，用于过程数据通信 */
    void on_pushButton_clicked();

private:
    Ui::myMainWindow *ui;
    QTimer *pdotimer;
    QMap<QString,QString> ethinfo;  /* 存放网卡信息 */
    QString ifname;                 /* 网卡名字 */
    char IOmap[256];                /* PDO映射的数组 */
    bool ConnectFlag;      /* 成功初始化标志位 */
public:

};
#endif // MYMAINWINDOW_H
