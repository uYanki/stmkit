/* Windows API 串口函数与结构体

	CreateFile()	//打开串口(打开成功返回串口资源句柄，失败返回-1)
	SetupComm()		//设置串口读写的缓冲区大小的（）
	PurgeComm()		//清空串口缓冲区
	GetCommState()	//获取串口的初始配置
	SetCommState()		//配制串口各参数
	GetCommTimeouts()	//获取串口超时当前的配制
	SetCommTimeouts()	//配制串口超时函数(写入COMMTIMEOUTS结构体的数据)
	ReadFile()		//读串口数据
	COMMTIMEOUTS	//这个结构体是设置关于串口超时方面的(写入后才生效)
	DCB						//这个结构提是设置关于串口各参数方面的(写入后才生效)
	
	
	
*/
/*名词术语表示
	Quaternion = 四元数
	Yaw=偏航
	Pitch=俯仰
	Roll=翻滚
	
*/

#include <stdio.h>
#include <windows.h>
#include <math.h>


int dmpGetQuaternion1(int *data, unsigned char *packet);	//取出DMP四元数原始数据
int dmpGetQuaternion2(float *q,unsigned char* packet); //计算出四元数
void dmpGetyawpitchroll(float *ypr,float *q);	//计算欧拉角 Roll,Pitch,Yaw

int main(int argc, char *agrv[])	//字符最后一位为\0，
{
	int btl;
	char comk[6]="com1";

	if(argc > 1 )
	{
		btl = 0;
		while((agrv[1][btl]!='\0') && (btl<5))
		{
			comk[btl] = agrv[1][btl];
			btl++;
		}
		if(argc > 2)
		{
			sscanf(agrv[2],"%d",&btl);
		}
		else
		{
			btl = 9600;
		}
	}
	else
	{
		btl = 9600;
	}
	
	HANDLE hCom;	//保存串口句柄
	hCom = CreateFile(comk,	//打开的串口名
										GENERIC_READ|GENERIC_WRITE, //允许读和写(单读或单写也可以)
										0, //独占方式(必须的)
										NULL,	//引用安全性属性结构，缺省值为NULL
										OPEN_EXISTING, //打开而不是创建
										0, //同步方式
										NULL);	//对串口而言该参数必须置为NULL

	if (hCom==(HANDLE)-1)
	{
		printf("打开串口失败");
		return -1;
	}
	SetupComm(hCom,1024,1024); //输入缓冲区和输出缓冲区的大小都是1024
	COMMTIMEOUTS TimeOuts;  //这里的只是设定，如果不写入设定那么这个设定就不回生效
	//设定读超时  
	TimeOuts.ReadIntervalTimeout=1000;  
	TimeOuts.ReadTotalTimeoutMultiplier=500;  
	TimeOuts.ReadTotalTimeoutConstant=5000;  
	//设定写超时  
	TimeOuts.WriteTotalTimeoutMultiplier=500;  
	TimeOuts.WriteTotalTimeoutConstant=2000;  
	
	SetCommTimeouts(hCom,&TimeOuts); //设置超时  
	
	DCB dcb;
	GetCommState(hCom,&dcb);	//获取串口的初始配置
	dcb.BaudRate=btl; //波特率为9600  
	dcb.ByteSize=8; //每个字节有8位  
	dcb.Parity=NOPARITY; //无奇偶校验位  
	dcb.StopBits=1; //两个停止位  
	SetCommState(hCom,&dcb);	//配制串口各参数
	
	PurgeComm(hCom,PURGE_TXCLEAR|PURGE_RXCLEAR); //清空串口缓冲区(读与写的一起清空)
	
	
	//读串口
	unsigned char data[8];//
	DWORD wCount;//读取的字节数 (成功的字符数)
	BOOL bReadStat;  //
	bReadStat=ReadFile(hCom,data,8,&wCount,NULL);	//读取字符
	float q[4],ypr[3];


	while(1)	//死循环输出最新欧拉角
	{
	bReadStat=ReadFile(hCom,data,8,&wCount,NULL);	//读取字符
	dmpGetQuaternion2(q,data);	//取出四元数 W X Y Z
	dmpGetyawpitchroll(ypr,q); //计算角度

	//输出 角度
	printf("roll=%f ",ypr[0]);
	printf("pitch=%f ",ypr[1]);
	printf("yaw=%f \n",ypr[2]);
	}
	return 0;
}
void dmpGetyawpitchroll(float *ypr,float *q)	//计算角度
{
  // Roll = Atan2(2 *(Y * Z + W * X) , W * W -X * X -Y * Y + Z * Z) 
 ypr[0] = atan2(2 *(q[2] * q[3] + q[0] * q[1]) , q[0] * q[0] -q[1] * q[1] -q[2] * q[2] + q[3] * q[3])*57.3; 
  // Pitch = asin(-2 * (X * Z - W * Y))  
 ypr[1]=asin(-2*(q[1]*q[3]-q[0]*q[2]))*57.3;
  // Yaw   = atan2(2 * (X * Y + W * Z) ,W * W + X * X - Y * Y - Z * Z) 
 ypr[2]=atan2(2*(q[1] * q[2] + q[0] * q[3]) , q[0] * q[0] +q[1] * q[1] -q[2] * q[2] - q[3] * q[3])*57.3; 
}
int dmpGetQuaternion1(int *data, unsigned char *packet)	//组合DMP四元数原始数据
{
	int i,k;
    data[0] = ((packet[0] << 8) + packet[1]);
    data[1] = ((packet[2] << 8) + packet[3]);
    data[2] = ((packet[4] << 8) + packet[5]);
    data[3] = ((packet[6] << 8) + packet[7]);
    for(i=0;i<4;i++)// 把16位负数的补码，转换成32位的负数补码
    {
		if((data[i]&0x8000) !=0)
		{
			if(data[i]!=0x8000)
			{
				k=data[i];
				data[i]=0xffff;
				data[i]=~data[i];
				data[i]=data[i]|k;
			}
			else
				data[i]=-32768;
			}
			
		}
    return 1;
}
int dmpGetQuaternion2(float *q,unsigned char* packet)	//取出四元数
{	
    int qI[4];
    unsigned char status = dmpGetQuaternion1(qI, packet);
    if (status) {
        q[0] = (float)qI[0] / 16384.0f;
        q[1] = (float)qI[1] / 16384.0f;
        q[2] = (float)qI[2] / 16384.0f;
        q[3] = (float)qI[3] / 16384.0f;
        return 1;
    }
    return status; 
}

