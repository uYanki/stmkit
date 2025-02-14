#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QDebug>
#include <QFile>
#include <QString>
#include <QTextStream>

#include <QMap>

#include <QFileDialog>
#include <QMessageBox>

#include <QFileInfo>
#include <QSqlQuery>
#include <QtSql>
#include <qsqldatabase.h>
#include <QMessageBox>

#include "xlsxdocument.h"
#include "xlsxworkbook.h"

#include "QDesktopServices"

#include <QSqlQuery>
#include <QtSql>
#include <qsqldatabase.h>
#include <QMessageBox>

QSqlDatabase db;

#define INICFG_PATH_PARATBL  "/path/paratbl"
#define INICFG_PATH_TUNERDB  "/path/tunerdb"
#define INICFG_PATH_TUNEREXE "/path/tunerexe"
#define INICFG_ERROR_SHEET   "/generator/sheet"
#define INICFG_ERROR_ROWS    "/generator/rows"
#define INICFG_ERROR_INDEX   "/generator/row"

#define DB_FILENAME          "CTSD-A4-GE-V000_00-debug.db"

#define PARA_COLUMN_OFFSET   ('D' - 'A' + 1)

#define PARA_ADDRESS         (PARA_COLUMN_OFFSET + 0)
#define PARA_DATA_TYPE       (PARA_COLUMN_OFFSET + 1)
#define PARA_VAR_NAME        (PARA_COLUMN_OFFSET + 2)
#define PARA_ATTR_INTI_VAL   (PARA_COLUMN_OFFSET + 3)
#define PARA_ATTR_MIN_VAL    (PARA_COLUMN_OFFSET + 4)
#define PARA_ATTR_MAX_VAL    (PARA_COLUMN_OFFSET + 5)
// #define PARA_SUBATTR_UNIT       (PARA_COLUMN_OFFSET + 6)
#define PARA_SUBATTR_MODE       (PARA_COLUMN_OFFSET + 7)
#define PARA_SUBATTR_SYNC_COVER (PARA_COLUMN_OFFSET + 8)
#define PARA_SUBATTR_RELATE     (PARA_COLUMN_OFFSET + 9)
#define PARA_SUBATTR_ACCESS     (PARA_COLUMN_OFFSET + 10)
#define PARA_OBJECT_DICT        (PARA_COLUMN_OFFSET + 11)
#define PARA_NAME_ZH            (PARA_COLUMN_OFFSET + 12)
#define PARA_DESC_ZH            (PARA_COLUMN_OFFSET + 13)

typedef struct {
    bool    bSync;    // db info
    bool    bCover;   // db info
    QString szSync;   // attr table
    QString szCover;  // attr table
} ParaSyncCover_t;

typedef struct {
    uint8_t     u8WordCnt;
    bool        bSign;         // db info
    QString     szSign;        // attr table
    QStringList szWordMarco;   // attr table
    QStringList szWordSuffix;  // attr table
    QStringList szWordIndex;   // attr table
} ParaDataType_t;

typedef struct {
    uint8_t u8RwType;  // db info
    uint8_t u8Mode;    // db info
    QString szMode;    // attr table
} ParaRwMode_t;

typedef struct {
    uint8_t u8Access;  // db info
    QString szAccess;  // attr table
} ParaAccess_t;

typedef struct {
    uint8_t u8Relate;  // db info
    QString szRelate;  // attr table
} ParaLimitRelate_t;

QString UpperStr(const QString &src)
{
    QString name_str;

    for(qint32 i = 0; i < src.count(); i++)
    {
        if( src.at(i).isUpper() )
        {
            name_str += "_";
        }

        name_str += src.at(i).toUpper();
    }

    return  name_str;
}


void MakePara(
    QString      szAddress,
    QString      szDataType,
    QString      szVarName,
    QString      szNameZH,
    QString      szInitVal,
    QString      szMinVal,
    QString      szMaxVal,
    QString      szMode,
    QString      szSynCov,
    QString      szRelate,
    QString      szAccess,
    QString      szParaNameDescZH,
    QTextStream& ParaTable,
    QTextStream& ParaIdx,
    QTextStream& ParaAttr)
{
    // qDebug() << szAddress << szDataType << szVarName << szInitVal << szMinVal << szMaxVal << szMode << szRelate << szSynCov << szAccess << Qt::endl;

    // clang-format off

    static const QMap<QString, ParaRwMode_t> sMapRwMode = {
        {"只读",                   {1, 3, "B_RO"}   },
        {"读写 - 立即更改，立即生效", {2, 0, "B_RW_M0"}},
        {"读写 - 停机更改，立即生效", {2, 1, "B_RW_M1"}},
        {"读写 - 立即更改，重启生效", {2, 2, "B_RW_M2"}},
    };

    static const QMap<QString, ParaAccess_t> sMapAccess = {
        {"Anyone", {0, "B_ANYONE"}},
        {"User",   {1,  "B_USER"}  },
        {"Admin",  {2,  "B_ADMIN"} },
    };

    static const QMap<QString, ParaSyncCover_t> sMapSynCov = {
        {"允许保存，可恢复",     {1, 0, "B_SYNC", "B_COV"}  },
        {"允许保存，不可恢复",   {1, 1, "B_SYNC", "B_NCOV"} },
        {"不允许保存，不可恢复", {0, 1, "B_NSYNC", "B_NCOV"}},
    };

    static const QMap<QString, ParaLimitRelate_t> sMapRelate = {
        {"无关联",      {0, "B_NR"}  },
        {"上限关联",    {1, "B_RL_UP"}},
        {"下限关联",    {2, "B_RL_DN"}},
        {"上下限关联",  {3, "B_RL"   }},
    };

    // clang-format on

    static const QStringList aWordMarco  = QStringList() << "W";
    static const QStringList aDWordMarco = QStringList() << "WL" << "WH";
    static const QStringList aQWordMarco = QStringList() << "W0" << "W1" << "W2" << "W3";

    static const QStringList aWordSuffix  = QStringList() << "";
    static const QStringList aDWordSuffix = QStringList() << "WL" << "WH";
    static const QStringList aQWordSuffix = QStringList() << "W0" << "W1" << "W2" << "W3";

    static const QStringList aWordIndex  = QStringList() << "B_SIG";
    static const QStringList aDWordIndex = QStringList() << "B_DOB0" << "B_DOB1";
    static const QStringList aQWordIndex = QStringList() << "B_QUD0" << "B_QUD1" << "B_QUD2" << "B_QUD3";

    static const QMap<QString, ParaDataType_t> sMapDataType = {
        {"s16", {1, 1, "B_SIGN", aWordMarco, aWordSuffix, aWordIndex}   },
        {"u16", {1, 0, "B_UNSI", aWordMarco, aWordSuffix, aWordIndex}   },
        {"s32", {2, 1, "B_SIGN", aDWordMarco, aDWordSuffix, aDWordIndex}},
        {"u32", {2, 0, "B_UNSI", aDWordMarco, aDWordSuffix, aDWordIndex}},
        {"s64", {4, 1, "B_SIGN", aQWordMarco, aQWordSuffix, aQWordIndex}},
        {"u64", {4, 0, "B_UNSI", aQWordMarco, aQWordSuffix, aQWordIndex}},
        {"f32", {2, 1, "B_SIGN", aDWordMarco, aDWordSuffix, aDWordIndex}},
        {"f64", {4, 0, "B_UNSI", aQWordMarco, aQWordSuffix, aQWordIndex}},
    };

    QString szParaDataType = szDataType;
    QString szParaVarName  = (szVarName == "") ? ("_Resv" + szAddress) : (szVarName);
    QString szParaVarAddr  = QString("%1").arg(szAddress.toUInt(), 4, 10, QLatin1Char('0'));
    QString szParaNameZH   = szNameZH;

    ParaRwMode_t      xParaRwMode      = sMapRwMode.value(szMode);
    ParaAccess_t      xParaAccess      = sMapAccess.value(szAccess);
    ParaSyncCover_t   xParaSynCov      = sMapSynCov.value(szSynCov);
    ParaDataType_t    xParaDataType    = sMapDataType.value(szParaDataType);
    ParaLimitRelate_t xParaLimitRelate = sMapRelate.value(szRelate);

    //
    // para attr table
    //

    QString     szSubAttr;
    QTextStream subStream(&szSubAttr);

    QString styleVar  = "    %1 %2 // P%3 %4";
    QString styleAttr = "    { %1, %2, %3, %4 | %5 | %6 | %7 | %8 | %9 | %10 }, // P%11 %12";

    ParaTable << styleVar
                     .arg(szParaDataType)
                     .arg(szParaVarName + ";", -30)  // <0: 左对齐, >0 右对齐
                     .arg(szParaVarAddr)
                     .arg(szParaNameZH)
              << Qt::endl;

    for (uint8_t i = 0; i < xParaDataType.u8WordCnt; ++i)
    {
        ParaAttr << styleAttr
                        .arg(xParaDataType.szWordMarco[i] + "(" + szInitVal + ")", 15)
                        .arg(xParaDataType.szWordMarco[i] + "(" + szMinVal + ")", 15)
                        .arg(xParaDataType.szWordMarco[i] + "(" + szMaxVal + ")", 15)
                        .arg(xParaRwMode.szMode, 7)
                        .arg(xParaDataType.szSign, 6)
                        .arg(xParaSynCov.szSync, 7)
                        .arg(xParaSynCov.szCover, 6)
                        .arg(xParaDataType.szWordIndex[i], 6)
                        .arg(xParaLimitRelate.szRelate, 7)
                        .arg(xParaAccess.szAccess, 8)
                        .arg(szParaVarAddr)
                        .arg(szParaVarName + xParaDataType.szWordSuffix[i])
                 << Qt::endl;
    }

    //
    // para index declare
    //

    ParaIdx << QString("#define PARA_INDEX_%1 %2 // P%3 %4")
               .arg(UpperStr(szParaVarName), -30)
               .arg(szAddress.toUInt())
               .arg(szParaVarAddr)
               .arg(szParaVarName)
               << Qt::endl;

    //
    // add to db
    //

    QSqlQuery query(db);

    QString cmd = "replace into %1 values(%2,\"%3\",%4,\"%5\",\"%6\",\"%7\",%8,%9,%10,%11,%12,%13,%14,%15,%16,\"%17\",%18);";

    cmd = cmd.arg("Para_New")                             // table name
              .arg(szAddress.toUInt())                    // Address
              .arg(szParaNameZH + " | " + szParaVarName)  // Name_CN
              .arg(xParaDataType.u8WordCnt * 4)           // DataType (half byte count)
              .arg(szInitVal)                             // InitValue
              .arg(szMinVal)                              // MinValue
              .arg(szMaxVal)                              // MaxValue
              .arg(xParaRwMode.u8RwType)                  // ReadWrite
              .arg(0)                                     // Unit
              .arg(0)                                     // Format
              .arg(xParaDataType.bSign)                   // Sign
              .arg(xParaSynCov.bSync)                     // Sync
              .arg(xParaSynCov.bCover)                    // Cover
              .arg(xParaRwMode.u8Mode)                    // Mode
              .arg(xParaLimitRelate.u8Relate)             // Relate
              .arg(xParaAccess.u8Access)                  // Access
              .arg(szParaNameDescZH)                      // Comment_CN
              .arg(0);                                    // Decimal

    query.prepare(cmd);
    query.exec();
}

bool IsProcessExist(const QString& processName)
{
    QProcess process;

    process.start("tasklist");
    process.waitForFinished();

    QByteArray result = process.readAllStandardOutput();
    QString    str    = result;

    return str.contains(processName);
}

MainWindow::MainWindow(QWidget* parent)
    : QMainWindow(parent), ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    m_IniCfg = new QSettings("config.ini", QSettings::IniFormat);

    // 自动加载上次路径
    ui->editParaTblPath->setText(m_IniCfg->value(INICFG_PATH_PARATBL).toString());
    ui->editTunerDBPath->setText(m_IniCfg->value(INICFG_PATH_TUNERDB).toString());
    ui->editTunerExePath->setText(m_IniCfg->value(INICFG_PATH_TUNEREXE).toString());
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_btnParaTblSel_clicked()
{
    QString fileName = QFileDialog::getOpenFileName(
        this,
        tr("select a file."),
        ui->editParaTblPath->text(),
        tr("execl files(*.xlsx *.xlsm);;All files(*.*)"));

    if (fileName.length() > 0)
    {
        ui->editParaTblPath->setText(fileName);
        m_IniCfg->setValue(INICFG_PATH_PARATBL, fileName);
    }
}

void MainWindow::on_btnTunerDBSel_clicked()
{
    QString selectDir = QFileDialog::getExistingDirectory();

    if (selectDir.length() > 0)
    {
        ui->editTunerDBPath->setText(selectDir);
        m_IniCfg->setValue(INICFG_PATH_TUNERDB, selectDir);
    }
}

void MainWindow::on_btnTunerExeSel_clicked()
{
    QString fileName = QFileDialog::getOpenFileName(
        this,
        tr("select a file."),
        ui->editTunerExePath->text(),
        tr("可执行文件 (*.exe);;All files(*.*)"));

    if (fileName.length() > 0)
    {
        ui->editTunerExePath->setText(fileName);
        m_IniCfg->setValue(INICFG_PATH_TUNEREXE, fileName);
    }
}

void MainWindow::on_btnGenerate_clicked()
{
    QString fileName = ui->editParaTblPath->text();

    QFileInfo fileInfo(fileName);

    if (!fileInfo.isFile())
    {
        QMessageBox(QMessageBox::Warning, "Error", "Path of ParaTbl is invaild").exec();
        return;
    }

    ui->btnGenerate->setEnabled(false);

    //
    // time
    //

    QDateTime dateTime  = QDateTime::currentDateTime();              // 获取系统当前的时间
    QString   szCurTime = dateTime.toString("yyyy-MM-dd hh:mm:ss");  // 格式化时间

    do {
        QString fileDir = fileInfo.absoluteDir().path();

        //
        // creat db
        //

        QString szPathTmpDB   = fileDir + "/" + DB_FILENAME;
        QString szPathTunerDB = ui->editTunerDBPath->text() + "/" + DB_FILENAME;

        qDebug() << QSqlDatabase::drivers();

        QFile::remove(szPathTmpDB);
        QFile::remove(szPathTunerDB);

        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(szPathTmpDB);  // create if not exist

        if (db.open())
        {
            QSqlQuery query(db);

            // clang-format off

            QStringList aCreatTableStr = QStringList()
                    <<
                    "CREATE TABLE Para_New \
                    ( \
                    Address         INTERGER PRIMARY KEY, \
                    Name_CN         TEXT, \
                    DataType        INTERGER, \
                    InitValue       TEXT, \
                    MinValue        TEXT, \
                    MaxValue        TEXT, \
                    ReadWrite       INTERGER, \
                    Unit            INTERGER, \
                    Format          INTERGER, \
                    Sign            INTERGER, \
                    Sync            INTERGER, \
                    Cover           INTERGER, \
                    Mode            INTERGER, \
                    Relate          INTERGER, \
                    Access          INTERGER, \
                    Comment_CN      TEXT, \
                    Decimal         TEXT \
                    );"
                    <<
                    "CREATE TABLE Alarm_New \
                    ( \
                    Code             INTERGER PRIMARY KEY, \
                    Comment          TEXT, \
                    Reason           TEXT, \
                    Method           TEXT \
                    );"
                    <<
                    "CREATE TABLE Group_New \
                    ( \
                    Num             TEXT, \
                    Name            TEXT \
                    );"
                    ;

            // clang-format on

            Q_FOREACH (QString creatTableStr, aCreatTableStr)
            {
                query.prepare(creatTableStr);

                if (!query.exec())
                {
                    ui->textEdit->append(szCurTime + ": fail, sql query error :" + query.lastError().text());
                    break;  // fail
                }
            }

            QStringList aMakeGroupCmd = QStringList()
                                        << "replace into Group_New values(\"0\",  \"0\");"
                                        << "replace into Group_New values(\"1\",  \"1\");"
                                        << "replace into Group_New values(\"2\",  \"2\");"
                                        << "replace into Group_New values(\"3\",  \"3\");"
                                        << "replace into Group_New values(\"4\",  \"4\");"
                                        << "replace into Group_New values(\"5\",  \"5\");"
                                        << "replace into Group_New values(\"6\",  \"6\");"
                                        << "replace into Group_New values(\"7\",  \"7\");"
                                        << "replace into Group_New values(\"8\",  \"8\");"
                                        << "replace into Group_New values(\"9\",  \"9\");"
                                        << "replace into Group_New values(\"A\",  \"10\");"
                                        << "replace into Group_New values(\"B\",  \"11\");"
                                        << "replace into Group_New values(\"C\",  \"12\");"
                                        << "replace into Group_New values(\"D\",  \"13\");"
                                        << "replace into Group_New values(\"E\",  \"14\");"
                                        << "replace into Group_New values(\"F\",  \"15\");"
                                        << "replace into Group_New values(\"10\", \"16\");"
                                        << "replace into Group_New values(\"11\", \"17\");"
                                        << "replace into Group_New values(\"12\", \"18\");"
                                        << "replace into Group_New values(\"13\", \"19\");"
                                        << "replace into Group_New values(\"14\", \"20\");"
                                        << "replace into Group_New values(\"15\", \"21\");"
                                        << "replace into Group_New values(\"16\", \"22\");"
                                        << "replace into Group_New values(\"17\", \"23\");"
                                        << "replace into Group_New values(\"18\", \"24\");"
                                        << "replace into Group_New values(\"19\", \"25\");"
                                        << "replace into Group_New values(\"1A\", \"26\");"
                                        << "replace into Group_New values(\"1B\", \"27\");"
                                        << "replace into Group_New values(\"1C\", \"28\");"
                                        << "replace into Group_New values(\"1D\", \"29\");"
                                        << "replace into Group_New values(\"1E\", \"30\");"
                                        << "replace into Group_New values(\"1F\", \"31\");"
                                        << "replace into Group_New values(\"20\", \"32\");";

            Q_FOREACH (QString creatItemStr, aMakeGroupCmd)
            {
                query.prepare(creatItemStr);
                query.exec();
            }
        }
        else
        {
            ui->textEdit->append(szCurTime + ": fail, sql error info :" + db.lastError().text());
            break;  // fail
        }

        //
        // kill tuner
        //

        bool IsTunerRunning = IsProcessExist("MagicWorksTuner.exe");

        if (IsTunerRunning)
        {
            QProcess::execute("taskkill /im MagicWorksTuner.exe /f");  // 关闭进程
        }

        //
        // open files
        //

        QXlsx::Document  xlsx(fileName);
        QXlsx::Workbook* workBook = xlsx.workbook();

        QFile       ParaTblFile(fileDir + "/paratbl.h");
        QTextStream ParaTblStream(&ParaTblFile);

        QFile       ParaIdxFile(fileDir + "/paraidx.h");
        QTextStream ParaIdxStream(&ParaIdxFile);

        QFile       ParaAttrFile(fileDir + "/paraattr.c");
        QTextStream ParaAttrStream(&ParaAttrFile);

        ParaAttrFile.open(QIODevice::WriteOnly);  // 清除文件原内容
        ParaIdxFile.open(QIODevice::WriteOnly);
        ParaTblFile.open(QIODevice::WriteOnly);

        ParaAttrStream.setCodec("UTF-8");
        ParaIdxStream.setCodec("UTF-8");
        ParaTblStream.setCodec("UTF-8");

        //
        // make paratbl
        //

        {
            QFile TmpFile(fileDir + "/paratbl_front.h");
            TmpFile.open(QIODevice::ReadOnly);
            QTextStream TmpStream(&TmpFile);
            ParaTblStream << TmpStream.readAll();
            TmpFile.close();
        }

        {
            QFile TmpFile(fileDir + "/paratbl_idx.h");
            TmpFile.open(QIODevice::ReadOnly);
            QTextStream TmpStream(&TmpFile);
            ParaIdxStream << TmpStream.readAll();
            TmpFile.close();
        }

        {
            QFile TmpFile(fileDir + "/paraattr_front.c");
            TmpFile.open(QIODevice::ReadOnly);
            QTextStream TmpStream(&TmpFile);
            ParaAttrStream << TmpStream.readAll();
            TmpFile.close();
        }

        for (uint8_t i = 0; i < workBook->sheetCount(); ++i)
        {
            QXlsx::Worksheet* workSheet = static_cast<QXlsx::Worksheet*>(workBook->sheet(i));

            QString ParaTblHdr, ParaTblTail;
            QString ParaAttrHdr, ParaAttrTail;

            if (workSheet->sheetName() == "Device" ||
                workSheet->sheetName() == "Axis" ||
                workSheet->sheetName() == "Para" )
            {
            }
            else
            {
                continue;
            }

            ParaTblHdr  = "\n__packed typedef struct {\n";
            ParaTblTail = QString("} %1_para_t;\n").arg(workSheet->sheetName().toLower());

            ParaAttrHdr  = QString("\nconst para_attr_t a%1Attr[] = {\n").arg(workSheet->sheetName());
            ParaAttrTail = "};\n";

            ParaTblStream << ParaTblHdr;
            ParaAttrStream << ParaAttrHdr;

            quint32 rowCnt = workSheet->dimension().rowCount();

            m_IniCfg->setValue(INICFG_ERROR_SHEET, workSheet->sheetName());
            m_IniCfg->setValue(INICFG_ERROR_ROWS, rowCnt);

            qDebug() << workSheet->sheetName() << rowCnt;

            for (quint32 row = 5; row <= rowCnt; row++)
            {
                if (workSheet->cellAt(row, PARA_ADDRESS)->value().isValid() == false ||
                    workSheet->cellAt(row, PARA_ADDRESS)->value().toString().isEmpty())
                {
                    break;
                }

                QString err = workSheet->cellAt(row, PARA_ADDRESS)->value().toString() + " " + workSheet->cellAt(row, PARA_VAR_NAME)->value().toString();
                m_IniCfg->setValue(INICFG_ERROR_INDEX, err);
                qDebug() << err;

                MakePara(workSheet->cellAt(row, PARA_ADDRESS)->value().toString(),
                         workSheet->cellAt(row, PARA_DATA_TYPE)->value().toString(),
                         workSheet->cellAt(row, PARA_VAR_NAME)->value().toString(),
                         !workSheet->cellAt(row, PARA_NAME_ZH)->value().isValid() ? "" : workSheet->cellAt(row, PARA_NAME_ZH)->value().toString(),
                         workSheet->cellAt(row, PARA_ATTR_INTI_VAL)->value().toString(),
                         workSheet->cellAt(row, PARA_ATTR_MIN_VAL)->value().toString(),
                         workSheet->cellAt(row, PARA_ATTR_MAX_VAL)->value().toString(),
                         workSheet->cellAt(row, PARA_SUBATTR_MODE)->value().toString(),
                         workSheet->cellAt(row, PARA_SUBATTR_SYNC_COVER)->value().toString(),
                         workSheet->cellAt(row, PARA_SUBATTR_RELATE)->value().toString(),
                         workSheet->cellAt(row, PARA_SUBATTR_ACCESS)->value().toString(),
                         !workSheet->cellAt(row, PARA_DESC_ZH)->value().isValid() ? "" : workSheet->cellAt(row, PARA_DESC_ZH)->value().toString(),
                         ParaTblStream, ParaIdxStream, ParaAttrStream);
            }

            ParaTblStream << ParaTblTail;
            ParaAttrStream << ParaAttrTail;
        }

        {
            QFile TmpFile(fileDir + "/paratbl_back.h");
            TmpFile.open(QIODevice::ReadOnly);
            ParaTblStream << TmpFile.readAll();
            TmpFile.close();
        }

        {
            QFile TmpFile(fileDir + "/paraidx_back.h");
            TmpFile.open(QIODevice::ReadOnly);
            ParaIdxStream << TmpFile.readAll();
            TmpFile.close();
        }

        {
            QFile TmpFile(fileDir + "/paraattr_back.c");
            TmpFile.open(QIODevice::ReadOnly);
            ParaAttrStream << TmpFile.readAll();
            TmpFile.close();
        }

        //
        // close files
        //

        ParaAttrFile.close();
        ParaTblFile.close();

        db.close();
        QFile::copy(szPathTmpDB, szPathTunerDB);

        m_IniCfg->setValue(INICFG_ERROR_SHEET, "");
        m_IniCfg->setValue(INICFG_ERROR_ROWS, "");
        m_IniCfg->setValue(INICFG_ERROR_INDEX, "");

        ui->textEdit->append(szCurTime + ": success");

    } while (0);

    ui->btnGenerate->setEnabled(true);
}

void MainWindow::on_btnParaTblGo_clicked()
{
    QDesktopServices::openUrl(QUrl::fromLocalFile(ui->editParaTblPath->text()));
}

void MainWindow::on_btnTunerDBGo_clicked()
{
    QDesktopServices::openUrl(QUrl::fromLocalFile(ui->editTunerDBPath->text()));
}

void MainWindow::on_btnTunerExeGo_clicked()
{
    QDesktopServices::openUrl(QUrl::fromLocalFile(ui->editTunerExePath->text()));
}
