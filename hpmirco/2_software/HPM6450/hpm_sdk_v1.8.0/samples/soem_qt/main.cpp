#include "mymainwindow.h"

#include <QApplication>

#pragma comment( lib, "Winmm" )
#pragma comment(lib,"ws2_32.lib")

int main(int argc, char *argv[])
{
    /* 解决高分辨率屏幕中应用显示问题 */
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication a(argc, argv);
    /* 为了使printf函数 实时输出 */
    setbuf(stdout,NULL);
    myMainWindow w;
    w.show();
    return a.exec();
}
