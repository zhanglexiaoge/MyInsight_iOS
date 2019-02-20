#pragma once

//错误返回
#define SUCCESS	              0   
#define FALSE_RECV            -1   //接收包失败
#define ERROR_STARTUP         -2	//初始化socket环境失败
#define ERROR_SOCKET          -3	//创建socket失败
#define ERROR_SET_SERVER      -4	//设置服务器地址失败
#define FALSE_SEND            -5	//发送失败
#define ERROR_UNKNOW          -6	//未知错误
#define ERROR_CONNECT         -9	//sock连接失败
#define ERROR_SELECT          -10	//select失败
#define ERROR_SOCKET_DOMAIN          -11	//解析域名失败
#define ERROR_TIME_OUT				-12//超时

//命令
#define COMMAND_REGISTER			5050
#define COMMAND_BY_USERNAME			5030
#define COMMAND_BY_DEVICEID			5040
#define COMMAND_CHANGE_PSW			5060
#define COMMAND_ADD_DEVICE			5070
#define COMMAND_GET_DEVCOUNT        5080
#define COMMAND_CHANGE_DEVINFO		5090
#define COMMAND_DELETE_DEV			5100
#define COMMAND_UPDATE				5110
#define COMMAND_RESTORE_PSW			5120
#define COMMAND_CHECK_USER_VALID	5130

//buf长度
#define MAX_DEVICE_COUNT			 100
#define SENDBUFLEN					 1024
#define XMLLEN						2048
#define RECVBUFLEN					100*1024

//端口及ip
#define PORT_LOCAL					10001
#define IP_LOCAL					"192.168.53.200"

#ifndef WIN32
#define WORD	unsigned short
#define DWORD	unsigned long
#define LPDWORD	DWORD*
#define BOOL	int
#define TRUE	1
#define FALSE	0
#define BYTE	unsigned char
#define LONG	long
#define UINT	unsigned int
#define HDC		void*
#define HWND	void*
#define LPVOID	void*
#define LPCSTR  char*
#define LPCTSTR  const char*
#endif

//包头
struct PacketHead
{
	int HeadFlag;				//包的标识
	int command;				//命令
	int extlen;					//包头之后的信息长度
	int reserve;				//保留字节，或作为服务器返回包的信息；
};
#define PACKETHEADLEN 16

