
#pragma once

#ifdef WIN32

#define GET_INFOR_API  extern "C" __declspec(dllexport)

#ifndef CALL_METHOD
#define CALL_METHOD	__stdcall  //__cdecl
#endif

#else	//linux
#define GET_INFOR_API	extern "C"
#define CALL_METHOD
#endif
// Error Code
#define  INFOR_OK   1
#define  INFOR_USER_EXIST -20		//用户已经存在
#define  INFOR_USER_NOEXIST  -21  //用户不存在
#define  INFOR_SQL_ERROR    -25  //sql失败
#define  INFOR_PASSWORD_NOT_VALID -22  //密码不正确
#define  INFOR_USER_NO_DEV   -23 //用户没有该设备

#define  INFOR_ILLEGAL_PARAM  -100

//
#define  DEV_MAX_COUNT    100 //最大数量为100

//增加IP,PORT
namespace FUNSDK
{
    
typedef struct DevInfoEx
{
    int             wxpms;
    int             ma;
    char            Comments[512];
}DevInfoEx;
    
typedef struct UserInfo
{
    char			_devId[64];			//设备序列号
    char			_Alias[128];		//别名
    char			_loginName[16];		//设备登陆用户
    char			_loginPsw[16];		//设备登陆密码
    char            Devip[96];
    char            devPort[32];
    char			type[16];			//设备类型
    DevInfoEx       ex;
}UserInfo;

//Name:128->64 IP:32->96
typedef struct DB_DevInfo_t
{
    char	Devmac[64];			//设备序列号
    char	Devname[64];		//别名
    char    Devip[96];
    char    devPort[32];
    char	loginName[16];		//设备登陆用户
    char	loginPsw[16];		//设备登陆密码
    char	type[16];			//设备类型
    
}DB_DevInfo_t;

}
using namespace FUNSDK;
