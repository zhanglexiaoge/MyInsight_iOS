/*********************************************************************************
 *Author:    Yongjun Zhao(赵永军)
 *Description:
 *History:
 Date:    2014.01.01/Yongjun Zhao
 Action：Create
 **********************************************************************************/
#pragma once
#ifndef FUNSDK_H
#define FUNSDK_H

#if defined(TARGET_OS_IOS)
#define OS_IOS 1
#endif

#include "XTypes.h"
#ifndef FUN_ONLY_ALRM_MSG
#include "GetInfor.h"
#include "netsdk.h"
#ifdef SUP_IRCODE
#include "irsdk_c.h"
#endif
#endif
#include "JPGHead.h"

class XMSG;

// 库对象全局变量设置
//产品类型目前是一个int，32位
//4位:版本号----------------------------------默认为0
//// 版本号1解析规则
//4位:产品大类：未知/消费类/传统类------------默认为0
//4位:镜头类型：未知/鱼眼/180/普通------------默认为0
//4位:厂家分类：未知/XM/JF/定制---------------默认为0
//16位：产品序列：（最多65535）
typedef enum EFUN_DEV_TYPE
{
    EE_DEV_NORMAL_MONITOR,                              //传统监控设备
    EE_DEV_INTELLIGENTSOCKET,                           //智能插座
    EE_DEV_SCENELAMP,                                   //情景灯泡
    EE_DEV_LAMPHOLDER,                                  //智能灯座
    EE_DEV_CARMATE,                                     //汽车伴侣
    EE_DEV_BIGEYE,                                      //大眼睛
    EE_DEV_SMALLEYE,                                    //小眼睛/小雨点
    EE_DEV_BOUTIQUEROBOT,                               //精品机器人 雄迈摇头机
    EE_DEV_SPORTCAMERA,                                 //运动摄像机
    EE_DEV_SMALLRAINDROPS_FISHEYE,                      //鱼眼小雨点
    EE_DEV_LAMP_FISHEYE,                                //鱼眼灯泡
    EE_DEV_MINIONS,                                     //小黄人
    EE_DEV_MUSICBOX,                                    //智能音响 wifi音乐盒
    EE_DEV_SPEAKER,                                     //wifi音响
    EE_DEV_LINKCENTERT = 14,                            //智联中心
    EE_DEV_DASH_CAMERA,                                 //勇士行车记录仪
    EE_DEV_POWERSTRIP,                                  //智能排插
    EE_DEV_FISH_FUN,                                    //鱼眼模组
    EE_DEV_DRIVE_BEYE = 18,                             //大眼睛行车记录仪
    EE_DEV_SMARTCENTER  = 19,                           //智能中心
    EE_DEV_UFO = 20,                                    //飞碟
    EE_DEV_IDR = 21,                                    //门铃--xmjp_idr_xxxx
    EE_DEV_BULLET = 22,                                 //E型枪机--XMJP_bullet_xxxx
    EE_DEV_DRUM = 23,                                   //架子鼓--xmjp_drum_xxxx
    EE_DEV_CAMERA = 24,                                 //摄像机--camera_xxxx
    EE_DEV_FEEDER = 25,                                 //喂食器设备--feeder_xxxx
    EE_DEV_PEEPHOLE = 26,                               //猫眼设备--xmjp_peephole
    EE_DEV_DOORLOCK = 0x11110027,                       //门锁设备--xmjp_stl_xxxx
    EE_DEV_DOORLOCK_V2 = 0x11110031, 					//门锁设备支持音频和对讲--xmjp_stl_xxxx
    EE_DEV_SMALL_V = 0x11110032,						//小V设备--camera_xxxx
	EE_DEV_BULLET_EG = 0x11310028,                      //EG型枪机--XMJP_bullet_xxxx
	EE_DEV_BULLET_EC = 0x11310029,                      //EC型枪机--XMJP_bullet_xxxx
	EE_DEV_BULLET_EB = 0x11310030,						//EB型枪机--XMJP_bullet_xxxx
	EE_DEV_CZ_IDR = 0x11130001,                         //定制门铃1--dev_cz_idr_xxxx
	EE_DEV_LOW_POWER = 0x11030002,						//低功耗无线消费类产品
    EE_DEV_NSEYE = 601,                                 //直播小雨点
}EFUN_DEV_TYPE;

typedef struct SDBDeviceInfo
{
    char    Devmac[64];            // DEV_SN / IP / DNS
    char    Devname[128];        // 名称   使用HTML编码中文1个8位（&#12455;）15(汉字） * 8 + 1（英文或数字） = 121
    char    devIP[64];        // 名称
    char    loginName[16];        // 用户名
    char    loginPsw[16];        // 密码
    int     nPort;              // 端口映射端口
    
    int nType;      // --设备类型   EFUN_DEV_TYPE
    int nID;        // --本设备ID,内部使用
}SDBDeviceInfo;

typedef struct STime{
    int dwYear;
    int dwMonth;
    int dwDay;
    int dwHour;
    int dwMinute;
    int dwSecond;
}STime,*LPSTime;

// 库对象全局变量设置
typedef enum EFUN_ATTR
{
    EFUN_ATTR_APP_PATH = 1,
    EFUN_ATTR_CONFIG_PATH = 2,
    EFUN_ATTR_UPDATE_FILE_PATH = 3,     // 升级文件存储目录
    EFUN_ATTR_SAVE_LOGIN_USER_INFO = 4, // 升级文件存储目录
    EFUN_ATTR_AUTO_DL_UPGRADE = 5,      // 是否自动下载升级文件0:NO 1:WIFI下载 2:网络通就下载
    EFUN_ATTR_FUN_MSG_HANDLE = 6,       // 接收FunSDK返回的设备断开等消息
    EFUN_ATTR_SET_NET_TYPE = 7,         // ENET_TYPE(1:WIFI 2:3G(移动网络))
    EFUN_ATTR_GET_IP_FROM_SN = 8,       // 通过序列号获取局域网IP
    EFUN_ATTR_TEMP_FILES_PATH = 9,      // 临时文件目录
    EFUN_ATTR_USER_PWD_DB = 10,          // 用户密码数据保存文件
    EFUN_ATTR_LOGIN_ENC_TYPE = 11,      // 指定登录加密类型，默认为0:MD5&RSA 1:RSA(需要设备支持)
    EFUN_ATTR_LOGIN_USER_ID = 12,       // Login  user id
    EFUN_ATTR_CLEAR_SDK_CACHE_DATA = 13,// Clear sdk cache data
    EFUN_ATTR_DSS_STREAM_ENC_SYN_DEV = 14,   // DSS码流校验规则是否同步设备方式设置（0:通用方式校验，1:跟设备登录密码相同方式校验）
    EFUN_ATTR_CDATACENTER_LANGUAGE = 15,// 设置语言类型,FunSDK初始化结构体参数里面的语言设置，初始化过后，app后续会再次更改语言类型
}EFUN_ATTR;

typedef enum EOOBJECT_ID
{
    EOOBJECT_MEDIA_SYN = 1,
    EOOBJECT_USER_SERVER = 2,
}EOOBJECT_ID;

typedef enum ENET_MOBILE_TYPE
{
    ENET_TYPE_WIFI = 1,     // WIFI
    ENET_TYPE_MOBILE = 2,   // 移动网络
    ENET_TYPE_NET_LINE = 4, // 物理网卡线
}ENET_MOBILE_TYPE;


typedef enum E_FUN_PTZ_COMMAND
{
    EE_PTZ_COMMAND_UP,
    EE_PTZ_COMMAND_DOWN,
    EE_PTZ_COMMAND_LEFT,
    EE_PTZ_COMMAND_RIGHT,
    EE_PTZ_COMMAND_LEFTUP,
    EE_PTZ_COMMAND_LEFTDOWN,
    EE_PTZ_COMMAND_RIGHTUP,
    EE_PTZ_COMMAND_RIGHTDOWN,
    EE_PTZ_COMMAND_ZOOM,
    EE_PTZ_COMMAND_NARROW,
    EE_PTZ_COMMAND_FOCUS_FAR,
    EE_PTZ_COMMAND_FOCUS_NEAR,
    EE_PTZ_COMMAND_IRIS_OPEN,
    EE_PTZ_COMMAND_IRIS_CLOSE
}E_FUN_PTZ_COMMAND;

//DSS通道状态
typedef enum E_DSS_CHANNEL_STATE
{
    DSS_DEC_STATE_NOLOGIN = -3, 	//前端未登录
    DSS_DEC_STATE_NOCONFIG,			//前端未配置
    DSS_DEC_STATE_STREAM_FORBIDDEN, //禁止该路推流
    DSS_DEC_STATE_NOT_PUSH_STRREAM, //未推流状态
    DSS_DEC_STATE_PUSHING_STREAM,	//正在推流
    DSS_DEC_STATE_MULITCODE_STREAM, //混合编码通道
}E_DSS_CHANNEL_STATE;

typedef struct SInitParam
{
    int nAppType;
    char nSource[64]; // "xmshop"：商城（默认）, "kingsun"：勤上
    char sLanguage[32]; //中文（zh）、英文（en）
}SInitParam;

#ifdef SUP_PREDATOR
typedef struct _SPredatorAudioFileInfo
{
	int year;
	int month;
	int day;
	int hour;
	int minute;
	int second;
	int nOperationtype; //文件操作类型 1:发送文件 2:删除文件 3:取消文件传输
	char szFileName[18]; //文件名称
}SPredatorAudioFileInfo;
#endif

typedef struct _SSubDevInfo //子设备信息， 检查更新时，Type可选， 默认“IPC”，其它需赋值； 开始升级时，暂时只需要SN、 SoftWareVer，其它可选
{
    char strSubDevSN[32];
    char strBuildTime[32];
    char strSoftWareVer[64];
    char strDevType[8];   //IPC、DVR and so on
}SSubDevInfo;
#ifndef FUN_ONLY_ALRM_MSG

/*库方法*/
//库初始化1，整个程序只需要调用一次
int FUN_Init(int nParam = 0, SInitParam *pParam = NULL, const int nCustom = 0, const char *pServerAddr = NULL, const int nServerPort = 0);
//特殊定制使用，可使用FUN_InitExV2取代
int FUN_InitEx(int nParam = 0, SInitParam *pParam = NULL, const char* strCustomPWD = "", const char *strCustomServerAddr = NULL, const int nCustomServerPort = 0);
//FUN_InitExV2可完全取代FUN_InitEx
int FUN_InitExV2(int nParam, SInitParam *pParam, int nPWDCustomeType, const char* strCustomPWD, const char *strCustomServerAddr = NULL, const int nCustomServerPort = 0);

void FUN_UnInit(int nType = 0);
//库初始化2  参数pServerAddr、 nServerPort无用，只为兼容以前的版本
int FUN_InitNetSDK(const int nCustom = 0, const char *pServerAddr = NULL, const int nServerPort = 0);
void FUN_UnInitNetSDK();

// 服务器相关的操作
int FUN_SysInit(const char *szIP, int nPort);
int FUN_SysInit(const char *szDBFile);
int FUN_SysInitAsAPModel(const char *szDBFile);

// 如果帐户服务器IP不是默认，使用此接口进行配置
// 通用帐户服务 szKey:"MI_SERVER"
int FUN_SysSetServerIPPort(const char *szKey, const char *szServerIP, int nServerPort);

//初始化app证书
int FUN_XMCloundPlatformInit(const char *uuid, const char *appKey, const char *appSecret, int movedCard);

#define LOG_UI_MSG  1
#define LOG_FILE    2
#define LOG_NET_MSG 4
/*日志功能方法*/
void Fun_Log(char *szLog);
void Fun_LogInit(UI_HANDLE hUser, const char *szServerIP, int nServerPort, const char *szLogFile, int nLogLevel = 0x3);
void Fun_SendLogFile(const char *szFile);
void Fun_Crash(char *crashInfo);

/*******************SDK编译**************************
* 方法名: FunSDK编译版本信息
* 描  述: FunSDK编译版本日期，版本号
* 返回值:
*      compiletime=%s&number=1.0.1  编译日期&FunSDK版本号
*      版本号组成：1.0.0：主版本号.次版本号.修订号
*      		         主版本号：全盘重构时增加；重大功能或方向改变时增加；大范围不兼容之前的接口时增加；
*			         次版本号：增加新的业务功能时增加；
*			         修订号：增加新的接口时增加；在接口不变的情况下，增加接口的非必填属性时增加；增强和扩展接口功能时增加。
* 参  数:
*      输入(in)
*      输出(out)
*          [无]
* 结果消息：
* 		[无]
****************************************************/
char *Fun_GetVersionInfo(char szVersion[512]);

// 后台，前台切换函数
void Fun_SetActive(int nActive);

//About Languae
int Fun_InitLanguage(const char *szLanguaeFileName);
int Fun_InitLanguageByData(const char *szBuffer);
const char *Fun_TS(const char *szKey, const char *szDefault = NULL);

#ifdef OS_IOS
UI_HANDLE FUN_RegWnd(LP_WND_OBJ pWnd);
void FUN_UnRegWnd(UI_HANDLE hWnd);
void FUN_ClearRegWnd();
#endif

/*系统功能方法*/
//---用户注册相关接口---
#ifndef CUSTOM_MNETSDK
int FUN_SysRegUserToXMExtend(UI_HANDLE hUser, const char *UserName, const char *pwd, const char *checkCode, const char *phoneNO, const char *source, const char *country, const char *city, int nSeq = 0);
int FUN_SysRegisteByEmailExtend(UI_HANDLE hUser, const char *userName, const char *password, const char *email, const char *code, const char *source, const char *country, const char *city, int nSeq = 0);

// 接口废弃--请使用FUN_SysRegUserToXM接口
int FUN_SysNoValidatedRegisterExtend(UI_HANDLE hUser, const char *userName, const char *pwd, const char *source, const char *country, const char *city, int nSeq  =0);
//ARSP XMeye用
int FUN_SysUser_Register(UI_HANDLE hUser, const char *UserName,const char *Psw,const char *email, int nSeq = 0);    //注册用户
#endif
//通用注册接口
int FUN_SysRegUserToXM(UI_HANDLE hUser, const char *UserName, const char *pwd, const char *checkCode,const char *phoneNO, int nSeq);
int FUN_SysRegisteByEmail(UI_HANDLE hUser, const char *userName, const char *password, const char *email, const char *code, int nSeq);
// 废弃，使用FUN_SysRegisteByEmail或FUN_SysRegUserToXM(手机)代替，验证码填写为空即可
int FUN_SysNoValidatedRegister(UI_HANDLE hUser, const char *userName, const char *pwd, int nSeq  = 0);
int FUN_SysCancellationAccount(UI_HANDLE hUser, const char *checkCode,int nSeq = 0);

//---用户忘记/修改密码相关接口---
#ifndef CUSTOM_MNETSDK
//修改用户密码
int FUN_SysPsw_Change(UI_HANDLE hUser, const char *UserName,const char *old_Psw,const char *new_Psw, int nSeq = 0);
//通过邮箱找回密码
int Fun_SysGetPWByEmail(UI_HANDLE hUser, const char* UserName, int nSeq = 0);
#endif
int FUN_SysSendEmailCode(UI_HANDLE hUser, const char *email, int nSeq);
int FUN_SysSendEmailCodeEx(UI_HANDLE hUser, const char *email, const char *username, int nSeq);
int FUN_SysSendPhoneMsg(UI_HANDLE hUser, const char *UserName, const char *phoneNO, int nSeq = 0);    //获取验证码
int FUN_SysSendCodeForEmail(UI_HANDLE hUser, const char *email, int nSeq);
int FUN_SysSendCodeForEmailEx(UI_HANDLE hUser, const char *email, const char *username, int nSeq);

//修改用户密码--EMSG_SYS_EDIT_PWD_XM
int FUN_SysEditPwdXM(UI_HANDLE hUser, const char *UserName, const char *oldPwd, const char *newPwd, int nSeq);

//忘记登录密码--EMSG_SYS_FORGET_PWD_XM
int FUN_SysForgetPwdXM(UI_HANDLE hUser, const char *phoneOrEmail, int nSeq);
int FUN_SysChangePwdByEmail(UI_HANDLE hUser, const char *email, const char *newpwd, int nSeq);

//重置登录密码--EMSG_SYS_RESET_PWD_XM
int FUN_ResetPwdXM(UI_HANDLE hUser, const char *phoneOrEmail, const char *newPwd, int nSeq);

//---登入/登出相关接口---
int FUN_SysLoginToXM(UI_HANDLE hUser, const char *UserName, const char *pwd, int nSeq);
int FUN_SysLogout(UI_HANDLE hUser, int nSeq = 0); //同步退出

int FUN_XMVideoLogin(UI_HANDLE hUser, const char *szUser, const char *szPwd, int nSeq);
int FUN_XMVideoLogout(UI_HANDLE hUser, int nSeq);

//---检验用户账号相关接口---

int FUN_SysSendBindingPhoneCode(UI_HANDLE hUser, const char *phone, const char *userName, const char *pwd, int nSeq  =0);
int FUN_SysBindingPhone(UI_HANDLE hUser, const char *userName, const char *pwd, const char *phone, const char *code, int nSeq  =0);
int FUN_SysSendBindingEmailCode(UI_HANDLE hUser, const char *email, const char *userName, const char *pwd, int nSeq);
int FUN_SysBindingEmail(UI_HANDLE hUser, const char *userName, const char *pwd, const char *email, const char *code, int nSeq);

int FUN_SysCheckCodeForEmail(UI_HANDLE hUser, const char *email, const char *code, int nSeq);
//验证修改密码的验证码是否正确--EMSG_SYS_REST_PWD_CHECK_XM
int FUN_CheckResetCodeXM(UI_HANDLE hUser, const char *phoneOrEmail, const char *checkNum, int nSeq);
int FUN_CheckPwdStrength(UI_HANDLE hUser, const char *newPwd, int nSeq);
int FUN_SysCheckUserRegiste(UI_HANDLE hUser, const char *userName, int nSeq =0);
FUN_HANDLE FUN_CheckUserPhone(UI_HANDLE hUser, const char *phone, int nSeq);
FUN_HANDLE FUN_CheckUserMail(UI_HANDLE hUser, const char *mail, int nSeq);

//---用户信息相关接口---
int FUN_SysGetUerInfo(UI_HANDLE hUser, const char *userName, const char *pwd, int nSeq  =0);

//---检查app更新---
int Fun_FirLatest(UI_HANDLE hUser, const char *appId, const char *appToken, int nSeq = 0);

//---其他---
int FUN_SysCheckDeviceReal(UI_HANDLE hUser, const char *twoDimensionCode, int nSeq = 0);//检测产品是否为正品

//---设备列表相关接口---
int Fun_SysAddDevByFile(UI_HANDLE hUser, const char *szPath, int nSeq = 0);
int FUN_SysGetDevList(UI_HANDLE hUser, const char *szUser, const char *szPwd, int nSeq = 0); //获取用户设备信息

// 第三方获取列表接口（微信、QQ、微博、Facebook、Google等）
// unionId:唯一ID
// szType:微信“wx”
int FUN_SysGetDevListEx(UI_HANDLE hUser, const char *unionId, const char *szType, int nApptype, int nSeq = 0);

//szExInfo格式 param1=value1&param2=value2
//其中“ma=true&delOth=true”设置此帐户为此设备的主帐户
//其中“ext=XXXXXXXX”设置设备的用户自定义信息
int FUN_SysAdd_Device(UI_HANDLE hUser, SDBDeviceInfo *pDevInfo, const char *szExInfo = "", const char *szExInfo2 = "", int nSeq = 0);                //增加用户设备

//返回设备是否开启了微信报警推送
int FUN_SysDevWXPMS(const char *szDeviceSN);

//登录帐户是否是主帐户
int FUN_SysDevIsMasterAccount(const char *szDeviceSN);

//获取设备的备注信息
int FUN_SysGetDevComment(const char *szDeviceSN, char comment[512]);

int FUN_SysChangeDevInfo(UI_HANDLE hUser, struct SDBDeviceInfo *ChangeDevInfor,const char *UserName,const char *Psw, int nSeq = 0);    //修改用户设备信息
int FUN_SysDelete_Dev(UI_HANDLE hUser, const char *Delete_DevMac,const char *UserName,const char *Psw, int nSeq = 0);            //删除设备

// --废弃，使用FUN_SysChangeDevInfo接口代替
int FUN_SysChangeDevLoginPWD(UI_HANDLE hUser, const char *uuid, const char *oldpwd, const char *newpwd, const char *repwd, int nSeq = 0);// 修改设备密码(服务器端)

//获取设备状态多个设备间使用";"分隔
int FUN_SysGetDevState(UI_HANDLE hUser, const char *devId, int nSeq = 0);

// 设备状态变化通知
// EMSG_SYS_ON_DEV_STATE
int FUN_SysAddDevStateListener(UI_HANDLE hUser);
int FUN_SysRemoveDevStateListener(UI_HANDLE hUser);

int FUN_SysGetDevLog(UI_HANDLE hUser, const char *ip, int nSeq = 0);

// 用户账号绑定
// name，pwd不为空时，绑定现有的帐户和密码
//          为空时，自动生成一个用户名和密码
int FUN_SysBindingAccount(UI_HANDLE hUser, const char *name, const char *pwd, int nSeq = 0);

// 返回消息ID:EMSG_SYS_WX_ALARM_LISTEN_OPEN = 5064,         // 开启微信报警监听
int FUN_SysOpenWXAlarmListen(UI_HANDLE hUser, const char *szDeviceSN, int nSeq = 0);
// 返回消息ID:EMSG_SYS_WX_ALARM_LISTEN_CLOSE = 5065,        // 关闭微信报警监听
int FUN_SysCloseWXAlarmListen(UI_HANDLE hUser, const char *szDeviceSN, int nSeq = 0);
// 返回消息ID:EMSG_SYS_WX_ALARM_WXPMSCHECK = 5066,        // 微信报警状态查询
int FUN_SysWXAlarmStateCheck(UI_HANDLE hUser, const char *szDeviceSN, int nSeq = 0);

// EMSG_SYS_CHECK_CS_STATUS     = 5067,        // 实时从服务器上查询云存储状态
// szDevices需要查询设备序列号，多个设备用","号分隔
int Fun_SysGetDevsCSStatus(UI_HANDLE hUser, const char *szDevices, int nSeq);

// EMSG_SYS_DULIST     = 5068,
// 获取设备所在的帐户信息
int Fun_SysGetDevUserInfo(UI_HANDLE hUser, const char *szDevice, int nSeq);

// EMSG_SYS_MDSETMA    = 5069
// 指定设备的主帐户
int Fun_SysSetDevMasterAccount(UI_HANDLE hUser, const char *szDevice,  const char *szMAUserId, int nSeq);

// EMSG_SYS_MODIFY_USERNAME    = 5070
// 修改登录用户名（只能修改微信等绑定帐户自动生成）
int Fun_SysModifyUserName(UI_HANDLE hUser, const char *szNewUserName, int nSeq);


// EMSG_SYS_IS_MASTERMA = 5072
// 从服务器端更新当前账号是否为该设备的主账号
int Fun_SysIsDevMasterAccountFromServer(UI_HANDLE hUser, const char *szDevice, int nSeq);
// EMSG_SYS_GET_ABILITY_SET = 5073
// 从服务器获取设备的能力集
int Fun_SysGetDevAbilitySetFromServer(UI_HANDLE hUser,const char *szDevSysInfo, int nSeq);
// EMSG_SYS_CHECK_DEV_VALIDITY = 5074
// 在服务器端验证设备校验码是否合法
int Fun_SysCheckDevValidityFromServer(UI_HANDLE hUser,const char *szDevId,const char *szDevCode, int nSeq);
/*设备功能方法*/
//---获取/设置对象属性---
int FUN_GetIntAttr(FUN_HANDLE hObj, int nId);
int FUN_GetIntAttr(FUN_HANDLE hObj, int nId, int nDefValue);
int FUN_GetStrAttr(FUN_HANDLE hObj, int nId, char *pStr, int nMaxSize);
int FUN_SetIntAttr(FUN_HANDLE hObj, int nId, int nValue);
int FUN_SetStrAttr(FUN_HANDLE hObj, int nId, const char *szValue);
int FUN_GetAttr(FUN_HANDLE hObj, int nId, char *pResult);
int FUN_SetAttr(FUN_HANDLE hObj, int nId, char *pResult);
int FUN_DestoryObj(FUN_HANDLE hObj, Bool bSyn = false);

//#define DSS_SERVER "DSS_SERVER"
//#define SQUARE_SERVER "SQUARE_SERVER"
//#define PMS_SERVER "PMS_SERVER"
//#define MI_XMEYE "MI_SERVER"
//#define KSS_SERVER "KSS_SERVER"
//#define CFS_SERVER "CFS_SERVER"
//#define SQUARE "SQUARE"
//#define XM030 "XM030"
//#define UPGRADE_SERVER "UPGRADE_SERVER"
int FUN_UpdateServerInfo(const char *szServerKey, const char *szIPPort);
// 获取/设置库的全局属性,详见EFUN_ATTR枚举
int FUN_GetFunIntAttr(EFUN_ATTR nId);
int FUN_GetFunStrAttr(EFUN_ATTR nId, char *pStr, int nMaxSize);
int FUN_SetFunIntAttr(EFUN_ATTR nId, int nValue);
int FUN_SetFunStrAttr(EFUN_ATTR nId, const char *szValue);
int FUN_GetAttr(EFUN_ATTR nId, char *pResult);
int FUN_SetAttr(EFUN_ATTR nId, char *pResult);
int Fun_GetObjHandle(EOOBJECT_ID nId);
int Fun_GetDevHandle(const char *szDevId);

//---其他方法    使用GetObjHandle获得对象ID,通过SendMsg完成发送消息处理功能---
int FUN_SendMsg(FUN_HANDLE hObj, UI_HANDLE hUser, int nMsgId, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, const char *szParam = "", const void *pData = 0, int nDataLen = 0, int nSeq = 0);
/////////////////////////////////////////// 设备公开与相关共享操作  ////////////////////////////////////////////////////
FUN_HANDLE FUN_GetPublicDevList(UI_HANDLE hUser, int nSeq);
FUN_HANDLE FUN_GetShareDevList(UI_HANDLE hUser, int nSeq);
//param:title&location&description(标题&地址&描述)
FUN_HANDLE FUN_SetDevPublic(UI_HANDLE hUser, const char *szDevId, const char *param, int nSeq);
//param:title&location&description(标题&地址&描述)
FUN_HANDLE FUN_ShareDevVideo(UI_HANDLE hUser, const char *szDevId, const char *param, int nSeq);
FUN_HANDLE FUN_CancelDevPublic(UI_HANDLE hUser, const char *szDevId, int nSeq);
FUN_HANDLE FUN_CancelShareDevVideo(UI_HANDLE hUser, const char *szDevId, int nSeq);
FUN_HANDLE FUN_SendComment(UI_HANDLE hUser, const char *videoId, const char *context, int nSeq);
FUN_HANDLE FUN_GetCommentList(UI_HANDLE hUser, const char *videoId, int nPage, int nSeq);
FUN_HANDLE FUN_GetVideoInfo(UI_HANDLE hUser, const char *szVideoId, int nSeq);
FUN_HANDLE FUN_GetShortVideoList(UI_HANDLE hUser, int nSeq);
FUN_HANDLE FUN_EditShortVideoInfo(UI_HANDLE hUser, const char *szVideoId, const char *szTitle, const char *szDescription, const char *style, int nSeq);
FUN_HANDLE FUN_DeleteShortVideo(UI_HANDLE hUser, const char *szVideoId, int nSeq);
FUN_HANDLE FUN_GetUserPhotosList(UI_HANDLE hUser, int page,  int nSeq);
FUN_HANDLE FUN_CreateUserPhotos(UI_HANDLE hUser, const char *photosName, const char *szLocation, const char *szDescription, const char *style, int nSeq);
FUN_HANDLE FUN_EditUserPhotos(UI_HANDLE hUser, const char *photosName, const char *szLocation, const char *szDescription, const char *style, const char *photosId, int nSeq);
FUN_HANDLE FUN_UpLoadPhoto(UI_HANDLE hUser, const char *photosId, const char *szTitle, const char *szLocation, const char *szDescription, const char *szPhotoFileName, int nCoverPic, int nSeq);
FUN_HANDLE FUN_EditPhotoInfo(UI_HANDLE hUser, const char *photosId, const char *photoId, const char *szTitle, const char *szLocation, const char *szDescription, int nSeq);
FUN_HANDLE FUN_GetPhotoList(UI_HANDLE hUser, const char *photosId, int nPage, int nSeq);
FUN_HANDLE FUN_DeletePhoto(UI_HANDLE hUser, const char *photoId, int nSeq);
FUN_HANDLE FUN_DeletePhotos(UI_HANDLE hUser, const char * photosId, int nSeq);
FUN_HANDLE FUN_CSSAPICommand(UI_HANDLE hUser, const char *szDevId, const char *cmd, const char *param, int nSeq);
FUN_HANDLE FUN_CSSAPICommandCFS(UI_HANDLE hUser, const char *szDevId, const char *cmd, const char *param, const char *date, int nSeq);
FUN_HANDLE FUN_KSSAPICommand(UI_HANDLE hUser, const char *object, const char *bucket, const char *auth, const char *date, const char *fileName, int nSeq);
FUN_HANDLE FUN_KSSAPIUpLoadVideo(UI_HANDLE hUser, const char *userName, const char *pwd, const char *title, const char *location, const char *description, const char *categroyId, const char *videoFileName, const char *picFileName, const char *style, int nSeq);
FUN_HANDLE FUN_KSSAPIUpLoadPhoto(UI_HANDLE hUser, const char *object, const char *bucket, const char *auth, const char *signature,const char *policy, const char *fileName, int nSeq);

//---设备相关操作接口---
/////////////////////////////////////////// 设备相关操作  ////////////////////////////////////////////////////
// 设备登录，如果本地数据库中没有此设备，则创建
int FUN_DevLogin(UI_HANDLE hUser, const char *szDevId, const char *szUser, const char *szPwd, int nSeq);
//适用于门铃，使设备进入休眠状态--EMSG_DEV_SLEEP
int FUN_DevSleep(UI_HANDLE hUser, const char *szDevId, int nSeq);
//适用于门铃，唤醒设备，使之进入唤醒状态--EMSG_DEV_WAKE_UP
int FUN_DevWakeUp(UI_HANDLE hUser, const char *szDevId, int nSeq);

int FUN_DevGetChnName(UI_HANDLE hUser, const char *szDevId, const char *szUser, const char *szPwd, int nSeq = 0);
// 云台控制
int FUN_DevPTZControl(UI_HANDLE hUser, const char *szDevId, int nChnIndex, int nPTZCommand, bool bStop = false, int nSpeed = 4, int nSeq = 0);
// 设备配置获取与设置
int FUN_DevGetConfig(UI_HANDLE hUser, const char *szDevId, int nCommand, int nOutBufLen, int nChannelNO = -1, int nTimeout = 15000, int nSeq = 0);
int FUN_DevSetConfig(UI_HANDLE hUser, const char *szDevId, int nCommand, const void *pConfig, int nConfigLen, int nChannelNO = -1, int nTimeout = 15000, int nSeq = 0);
// 设备配置获取与设置(Json格式)
int FUN_DevGetConfig_Json(UI_HANDLE hUser, const char *szDevId, const char *szCommand, int nOutBufLen, int nChannelNO = -1, int nTimeout = 15000, int nSeq = 0);
int FUN_DevSetConfig_Json(UI_HANDLE hUser, const char *szDevId, const char *szCommand, const void *pConfig, int nConfigLen, int nChannelNO = -1, int nTimeout = 15000, int nSeq = 0);
int FUN_DevGetConfigJson(UI_HANDLE hUser, const char *szDevId, const char *szCmd, int nChannelNO = -1, int nCmdReq = 0, int nSeq = 0, const char *pInParam = NULL, int nCmdRes = 0, int nTimeout = 0);
int FUN_DevSetConfigJson(UI_HANDLE hUser, const char *szDevId, const char *szCmd, const char *pInParam, int nChannelNO = -1, int nCmdReq = 0, int nSeq = 0, int nCmdRes = 0, int nTimeout = 0);
/*******************配置相关的接口**************************
* 方法名: 设备配置获取、设置
* 描  述: 设备配置获取、设置(Json格式，*不需要登陆设备)
* 返回值:
*      [无]
* 参  数:
*      输入(in)
*          [szCmd:配置命令字]
*          [pInParam:配置对象字节流-json格式]
*          [nCmdReq:命令ID]
*          [nChannelNO:通道号]
*          [nCmdRes:暂时未使用]
*          [nTimeout:超时时间  *<=0库里面默认根据网络类型设置]
*      输出(out)
*          [无]
* 结果消息：
* 		消息id:GET_CONFIG_JSON_DEV_NOT_LOGIN
****************************************************/
int FUN_DevConfigJson_NotLogin(UI_HANDLE hUser, const char *szDevId, const char *szCmd, const char *pInParam, int nCmdReq, int nChannelNO = -1, int nCmdRes = 0, int nTimeout = 15000, int nSeq = 0);

// 设备通用命令交互
// nIsBinary >= 0 || nInParamLen > 0传入的为二进制字节数组
int FUN_DevCmdGeneral(UI_HANDLE hUser, const char *szDevId, int nCmdReq, const char *szCmd, int nIsBinary, int nTimeout, char *pInParam = NULL, int nInParamLen = 0, int nCmdRes = -1, int nSeq = 0);
// 查询设备缩略图
int FUN_DevSearchPic(UI_HANDLE hUser, const char *szDevId, int nCmdReq, int nRetSize, int nTimeout, char *pInParam, int nInParamLen, int nCount, int nCmdRes = -1, const char * szFileName = NULL, int nSeq = 0);
int FUN_StopDevSearchPic(UI_HANDLE hUser, const char *szDevId, int nSeq);
int FUN_DevGetAttr(UI_HANDLE hUser, const char *szDevId, int nCommand, int nOutBufLen, int nChannelNO = -1, int nTimeout = 15000, int nSeq = 0);
int FUN_DevSetAttr(UI_HANDLE hUser, const char *szDevId, int nCommand, const void *pConfig, int nConfigLen, int nChannelNO = -1, int nTimeout = 15000, int nSeq = 0);
int FUN_DevLogout(UI_HANDLE hUser, const char *szDevId);
int FUN_DevReConnect(UI_HANDLE hUser, const char *szDevId);
int FUN_DevReConnectAll(UI_HANDLE hUser);
// 获取DSS支持的能力级--详细见EDEV_STREM_TYPE
uint FUN_GetDSSAbility(const char *szDevId, int nChannel);


/*******************DSS相关的接口**************************
* 方法名: 获取DSS支持混合通道号
* 描  述: 通过dss服务器返回的信息，获取DSS是否支持混合通道和混合通道号(*返回的混合通道号从0开始)
* 返回值:
*      [编解码类型] >=0 支持,第几通道
*      			 <0    不支持
* 参  数:
*      输入(in)
*          [szDevId:设备序列号]
*          [nStreamType:码流类型]
*      输出(out)
*          [无]
* 结果消息：无
****************************************************/
int FUN_GetDSSMixedChannel(const char *szDevId, int nStreamType);

// 更新本地密码数据库指定设备密码
int FUN_DevSetLocalPwd(const char *szDevId, const char *szUser, const char *szPwd);
char *FUN_DevGetLocalPwd(const char *szDevId, char szPwd[64]);
char *FUN_DevGetLocalUserName(const char *szDevId, char szUserName[64]);

// 快速配置接口
// WIFI配置配置接口（WIFI信息特殊方式发送给设备-->接收返回（MSGID->EMSG_DEV_AP_CONFIG））
int FUN_DevStartAPConfig(UI_HANDLE hUser, int nGetRetType, const char *ssid, const char *data, const char *info, const char *ipaddr, int type, int isbroad, const unsigned char wifiMac[6], int nTimeout = 10000);
void FUN_DevStopAPConfig(int nStopType = 0x3);

//录像查询
int FUN_DevFindFile(UI_HANDLE hUser, const char *szDevId, H264_DVR_FINDINFO* lpFindInfo, int nMaxCount, int waittime = 10000, int nSeq = 0);
int FUN_DevFindFileByTime(UI_HANDLE hUser, const char *szDevId, SDK_SearchByTime* lpFindInfo, int waittime = 2000, int nSeq = 0);
FUN_HANDLE FUN_DevDowonLoadByFile(UI_HANDLE hUser, const char *szDevId, H264_DVR_FILE_DATA *pH264_DVR_FILE_DATA, const char *szFileName, int nSeq = 0);
FUN_HANDLE FUN_DevDowonLoadByTime(UI_HANDLE hUser, const char *szDevId, H264_DVR_FINDINFO *pH264_DVR_FINDINFO, const char *szFileName, int nSeq = 0);
FUN_HANDLE FUN_DevImgListDowonLoad(UI_HANDLE hUser, const char *szDevId, H264_DVR_FILE_DATA_IMG_LIST *pH264_DVR_FILE_DATA_IMG_LIST, const char *szFileListMsk, const char *szFileDirName, int nSeq);
int FUN_DevStopDownLoad(FUN_HANDLE hDownload);

// 录像缩略图下载（最新固件才会支持2017.07.19）
// 异步消息EMSG_DOWN_RECODE_BPIC_START、EMSG_DOWN_RECODE_BPIC_FILE、EMSG_DOWN_RECODE_BPIC_COMPLETE
// 返回nDownId：可用于FUN_CancelDownloadRecordImage，取消下载用
int FUN_DownloadRecordBImage(UI_HANDLE hUser, const char *szDevId, int nChannel, int nTime, const char *szFileName, int nTypeMask = -1, int nSeq = 0);
int FUN_DownloadRecordBImages(UI_HANDLE hUser, const char *szDevId, int nChannel, int nStartTime, int nEndTime, const char *szFilePath, int nTypeMask = -1, int nSeq = 0, int nMaxPicCount = 0x7fffffff);

// nDownId:开始的返回值，如果==0表示全部停止
int FUN_CancelDownloadRecordImage(const char *szDevId, int nDownId);

// 设置设备下载队列最多任务数(初始默认为48)（录像缩略图下载SDK中是有个下载队列，排队下载）
// nMaxSize == 0取消限制； nMaxSize > 0：下载最大排队任务数
int FUN_SetDownRBImageQueueSize(const char *szDevId, int nMaxSize);

////////升级相关函数////////////////////
int FUN_DevCheckUpgrade(UI_HANDLE hUser, const char *szDevId, int nSeq = 0); // 返回MSGID:EMSG_DEV_CHECK_UPGRADE
int FUN_DevCheckUpgradeEx(UI_HANDLE hUser, const char *szDevId, const SSubDevInfo *szSubDevInfo = NULL, int nSeq = 0);
// 设备升级
int FUN_DevStartUpgrade(UI_HANDLE hUser, const char *szDevId, int nType, int nSeq = 0);
int FUN_DevStartUpgradeByFile(UI_HANDLE hUser, const char *szDevId, const char *szFileName, int nSeq = 0);
int FUN_DevStopUpgrade(UI_HANDLE hUser, const char *szDevId, int nSeq = 0);
int FUN_DevStartUpgradeEx(UI_HANDLE hUser, const char *szDevId, int nType, const SSubDevInfo *szSubDevInfo = NULL, int nSeq = 0);
int FUN_DevStartUpgradeByFileEx(UI_HANDLE hUser, const char *szDevId, const char *szSubDevId, const char *szFileName, int nSeq = 0);

// 接口废弃，使用FUN_DevStartWifiConfigByAPLogin接口代替
int FUN_DevSetWIFIConfig(UI_HANDLE hUser, const char *pCfg, int nCfgLen, const char *szUser, const char *szPwd, int nTimeout, int nSeq);

// WIFI配置配置接口（这种方式需要可以登录设备，通过协议把SSID和密码发给设备）
// 手机APP通过局域网登录时（过程：调用接口->回调返回结果）（MSGID->EMSG_DEV_SET_WIFI_CFG））
int FUN_DevStartWifiConfig(UI_HANDLE hUser, const char *szDevId, const char *szSSID, const char *szPassword, int nTimeout = 120000);
// 手机APP通过设备热点连接时（过程：手机连接设备热点->调用接口->返回1->切换到家里的WIFI->返回结果）（MSGID->EMSG_DEV_SET_WIFI_CFG））
int FUN_DevStartWifiConfigByAPLogin(UI_HANDLE hUser, const char *szDevId, const char *szSSID, const char *szPassword, int nTimeout = 120000);
void FUN_DevStopWifiConfig();

/*******************对讲相关的接口**************************
* 方法名: 开启对讲
* 描  述: 开启对讲
* 返回值:
*         操作句柄
* 参  数:
*      输入(in)
*          [nSupIpcTalk:是否支持IPC对讲，1支持,其他不支持，能力级获取SupportIPCTalk]
*          [nChannel:-1表示对所有连接的IPC单向广播 ， >=0表示指定某通道进行对讲  *nSupIpcTalk = 0时不需要使用]
*      输出(out)
*          [无]
* 结果消息：
* 		消息ID：EMSG_START_PLAY = 5501
****************************************************/
FUN_HANDLE FUN_DevStarTalk(UI_HANDLE hUser, const char *szDevId, Bool bSupIpcTalk = FALSE, int nChannel = 0, int nSeq = 0);
int FUN_DevSendTalkData(const char *szDevId, const char *pPCMData, int nDataLen);
void FUN_DevStopTalk(FUN_HANDLE hPlayer);
int FUN_DevOption(const char *szDevId, MsgOption *pOpt);
int FUN_DevOption(UI_HANDLE hUser, const char *szDevId, int nOptId, void *pData = NULL, int nDataLen = 0, int param1 = 0, int param2 = 0, int param3 = 0, const char *szStr = "", int seq = 0);
int FUN_DevStartSynRecordImages(UI_HANDLE hUser, const char *szDevId, int nChannel, const char *bufPath, time_t beginTime, time_t endTime, int nSeq);
int FUN_DevStopSynRecordImages(UI_HANDLE hUser, const char *szDevId, int nSeq);
int FUN_DevSearchDevice(UI_HANDLE hUser, int nTimeout, int nSeq);
// 开启上报数据
int FUN_DevStartUploadData(UI_HANDLE hUser, const char *szDevId, int nUploadDataType, int nSeq);
// 关闭上报数据
int FUN_DevStopUploadData(UI_HANDLE hUser, const char *szDevId, int nUploadDataType, int nSeq);
//注意：设置本地报警接受者，不再使用FUN_DevGetAlarmState(此名字含义不明显)， 使用FUN_DevSetAlarmListener
FUN_HANDLE FUN_DevGetAlarmState(UI_HANDLE hUser, int nSeq);
FUN_HANDLE FUN_DevSetAlarmListener(UI_HANDLE hUser, int nSeq);
int FUN_GetDevChannelCount(const char *szDevId);

#ifdef SUP_PREDATOR
//捕食器文件相关操作
int FUN_DevPredatorFileOperation(UI_HANDLE hUser, SPredatorAudioFileInfo *pFileInfo, const char *szDevId, const char *szFilePath, int nSeq);
//捕食器文件保存路径
int Fun_DevPredatorFileSave(UI_HANDLE hUser, const char *szDevId, const char *szFilePath, int nSeq);
#endif

// 获取设备能力级
// 返回 > 0表示有此功能能力  <=0表示无
// 智能录像放回能力 "OtherFunction/SupportIntelligentPlayBack"
// 是否开通云存储 "XXXAbillity/CloudStore": -1：未知；0（不支持）、 1（支持已开通，正常使用）、2（支持已开通，服务到期） 、3（支持未开通）
int FUN_GetDevAbility(const char *szDevId, const char *szAbility);

// 分类型获取设备状态（直接获取缓存中的状态）
// nType: 详细说明见枚举EFunDevStateType
// 返回值见枚举EFunDevState
int FUN_GetDevState(const char *szDevId, int nType);

/*******************设备状态相关接口**************************
* 方法名: 获取缓存中的所有状态
* 描  述: 获取缓存中的所有网络类型在线状态
* 返回值:
*      [编解码类型] <0 错误值，详见错误码
*      			 >=0 网络状态码
* 参  数:
*      输入(in)
*          [szDevId:设备序列号]
*      输出(out)
*          [无]
* 结果消息：无
****************************************************/
int FUN_GetDevAllNetState(const char *szDevId);

//查找是否搜索到该设备 : <=0,未搜到; 1,搜到  同步接口  devInfo 需分配对象空间
int Fun_DevIsSearched(const char *szDevId, SDK_CONFIG_NET_COMMON_V2 *devInfo);
//EMSG_SYS_CLOUDUPGRADE_CHECK
int Fun_SysCloudUpGradeCheck(UI_HANDLE hUser,  const char *szDevId, int nSeq = 0);
//EMSG_SYS_CLOUDUPGRADE_DOWNLOAD
int Fun_SysCloudUpGradeDownLoad(UI_HANDLE hUser, const char *szDevId, int nSeq = 0);
//EMSG_SYS_STOP_CLOUDUPGRADE_DOWNLOAD
int Fun_SysStopCloudUpGradeDownLoad(UI_HANDLE hUser, const char *szDevId, int nSeq = 0);

// 通过SN获取对应的外网IP地址
Bool Fun_DevGetNetIPBySN(char* ip, const char *uuid);

/*************************************************
 描述:跨网段设置设备配置，目前只支持对有线网络配置进行设置
 参数:
 bTempCfg[in]:       1临时保存,其他为永久保存
 pNetCfg[in]:       SNetCFG结构体地址
 szDeviceMac[in]:  设备Mac地址
 szDeviceSN[in]:   设备序列号
 szDevUserName[in]:设备登录用户名
 szDevPassword[in]:设备登录密码
 nTimeout[in]:       等待超时时间,单位毫秒
 异步返回，消息ID:EMSG_DEV_SET_NET_IP_BY_UDP（5143）
 *****************************************************/
int FUN_DevSetNetCfgOverUDP(UI_HANDLE hUser, Bool bTempCfg, SNetCFG *pNetCfg, const char *szDeviceMac, const char *szDeviceSN, const char *szDevUserName, const char *szDevPassword, int nTimeout = 4000, int nSeq = 0);

//---媒体有关的接口---
/////////////////////////////////////////// 媒体通道相关操作  ////////////////////////////////////////////////////
#ifdef OS_ANDROID
#define MEDIA_EX_PARAM void *pParam,
#define P_PARAM ,pParam
#else
#define MEDIA_EX_PARAM
#define P_PARAM
#endif
FUN_HANDLE FUN_MediaRealPlay(UI_HANDLE hUser, const char *szDevId, int nChnIndex, int nStreamType, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);
FUN_HANDLE FUN_MediaNetRecordPlay(UI_HANDLE hUser, const char *szDevId, H264_DVR_FILE_DATA *sPlayBackFile, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);
FUN_HANDLE FUN_MediaNetRecordPlayByTime(UI_HANDLE hUser, const char *szDevId, H264_DVR_FINDINFO *sPlayBackFile, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);
FUN_HANDLE FUN_MediaRecordPlay(UI_HANDLE hUser, const char *szRecord, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);
FUN_HANDLE FUN_MediaLocRecordPlay(UI_HANDLE hUser, const char *szFileName, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);
FUN_HANDLE FUN_MediaCloudRecordPlay(UI_HANDLE hUser, const char *szDevId, int nChannel, const char *szStreamType, int nStartTime, int nEndTime, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);
FUN_HANDLE FUN_MediaCloudRecordDownload(UI_HANDLE hUser, const char *szDeviceId, int nChannel, const char *szStreamType, int nStartTime, int nEndTime, const char *szFileName, int nSeq);

// 废弃接口FUN_MediaRtspPlay--20170805
//FUN_HANDLE FUN_MediaRtspPlay(UI_HANDLE hUser, const char * uuid, int mediaId, const char *szUrl, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq);
FUN_HANDLE FUN_MediaByVideoId(UI_HANDLE hUser, const char *szVideoId, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);
FUN_HANDLE Fun_MediaPlayXMp4(UI_HANDLE hUser, int hMp4File, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);

int FUN_MediaPlay(FUN_HANDLE hPlayer, int nSeq = 0);
int FUN_MediaPause(FUN_HANDLE hPlayer, int bPause, int nSeq = 0);
int FUN_MediaRefresh(FUN_HANDLE hPlayer, int nSeq = 0);
int FUN_MediaStop(FUN_HANDLE hPlayer, void *env = NULL);
int FUN_MediaSetPlaySpeed(FUN_HANDLE hPlayer, int nSpeed, int nSeq = 0);
int FUN_MediaStartRecord(FUN_HANDLE hPlayer, const char *szFileName, int nSeq = 0);
int FUN_MediaStopRecord(FUN_HANDLE hPlayer, int nSeq = 0);
int FUN_MediaSnapImage(FUN_HANDLE hPlayer, const char *szFileName, int nSeq = 0);
int FUN_MediaSeekToPos(FUN_HANDLE hPlayer, int nPos, int nSeq = 0);        // 0~100
// nAddTime:秒值,从开始时间算起
// nAbsTime:绝对时间time_t的值
// 两者二选一，如果nAbsTime不为-1，则使用nAbsTime
// 后面不再支持，替换为FUN_MediaSeekToMSTime
int FUN_MediaSeekToTime(FUN_HANDLE hPlayer, int nAddTime, int nAbsTime, int nSeq);

// nAbsTime:绝对时间跳转到时间，单位毫秒
int FUN_MediaSeekToMSTime(FUN_HANDLE hPlayer, uint64 nMSecond, int nSeq);

int FUN_MediaSetSound(FUN_HANDLE hPlayer, int nSound, int nSeq = 0);    // -1表示静音 0～100表示音量
// EMSG_ON_MEDIA_SET_PLAY_SIZE 0:高清 1:标清 2:高清/标清 3:流畅(实时视频有效)
// 实时播放/云存储播放有效
int FUN_MediaSetPlaySize(FUN_HANDLE hPlayer, int nType, int nSeq = 0);
// 获取当前播放的时间单位毫秒
uint64 FUN_MediaGetCurTime(FUN_HANDLE hPlayer);

// 调整显示的亮度(brightness)\对比度(contrast)\饱合度(saturation)\灰度(gray)(只影响显示，对原始视频数据无影响)
// 范围0~100；默认值为：50；-1表示不做调整，使用上次的配置
int FUN_MediaSetDisplayBCSG(FUN_HANDLE hPlayer, int nBrightness, int nContrast, int nSaturation, int nGray);

// 智能回放
// MSGID:EMSG_SET_INTELL_PLAY
// nTypeMask:EMSSubType
// nSpeed==0:取消智能快放
int Fun_MediaSetIntellPlay(FUN_HANDLE hPlayer, unsigned int nTypeMask, int nSpeed, int nSeq = 0);

// 更改播放显示窗口
int FUN_MediaSetPlayView(FUN_HANDLE hPlayer, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq);
int FUN_MediaSetFluency(FUN_HANDLE hPlayer, int nLevel, int nSeq);  // nLevel : EDECODE_TYPE
int FUN_MediaGetThumbnail(FUN_HANDLE hPlayer, const char *szOutFileName, int nSeq);
int FUN_MediaGetDecParam(const char *szFilePath, unsigned char *pOutBuffer, int nBufMaxSize);
int FUN_MediaGetFishParam(const char * szFilePath, FishEyeFrameParam * pInfo);

/*******************媒体有关的接口**************************
* 方法名: 获取mp4编解码类型
* 描  述: 通过保存在本地的mp4文件，获取mp4打包编解码类型
* 返回值:
*      [编解码类型] <0 错误值，详见错误码
*      			 2:H264 3:H265
* 参  数:
*      输入(in)
*          [szFilePath:文件绝对路径]
*      输出(out)
*          [无]
* 结果消息：无
****************************************************/
int FUN_MediaGetCodecType(const char *szFilePath);

FUN_HANDLE FUN_DevSaveRealTimeStream(UI_HANDLE hUser, const char *szDevId, int nChannel, int nStreamType, const char *szFileName, int nSeq = 0);
int FUN_DevCloseRealTimeStream(FUN_HANDLE hSaveObj);

FUN_HANDLE Fun_MediaPlayByURL(UI_HANDLE hUser, const char* strUrl, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);
FUN_HANDLE Fun_MediaPlayByURLEx(UI_HANDLE hUser, const char *szUrl, int nType, LP_WND_OBJ hWnd, MEDIA_EX_PARAM int nSeq = 0);

// 创建VRSoft句柄
void *Fun_VRSoft_Create();

#endif

/*******************媒体有关的接口**************************
* 方法名: 推送图片数据
* 描  述: 获取人脸图片数据功能
* 返回值:
*      [图片对象句柄，可用来实现数据接收停止等操作]
* 参  数:
*      输入(in)
*          [nChannel:设备通道号]
*		   [nImgType:需要的图片类型    *1：大图  2：小图  3：大小图]
*		   [nIntelType: 图片类型   *1.车牌  2：人脸  255：全部类型]
*      输出(out)
*          [无]
* 结果消息：ID:EMSG_DEV_START_PUSH_PICTURE 开始成功返回结果, EMSG_ON_MEDIA_DATA 数据返回
****************************************************/
FUN_HANDLE FUN_DevStartPushFacePicture(UI_HANDLE hUser, const char *szDevId, int nChannel, int nImgType, int nIntelType, int nSeq = 0);

// ---设备有关公共接口---
// 获取推荐码流值
// 编码方式 分辨率 enum SDK_CAPTURE_COMP_t 7 : h264 8 : H265
// iResolution 分辨率 enum SDK_CAPTURE_SIZE_t
// iQuality    图像质量 1~6
// iGOP        描述两个I帧之间的间隔时间，1-12
// nFrameRate  帧率
// nVideoStd   视频制式 0 : P 1 : N
int DEV_GetDefaultBitRate(int nEncType, int iResolution, int iQuality, int iGOP, int nFrameRate, int nVideoStd = 0, int nDevType = EE_DEV_NORMAL_MONITOR);

// ---其它公共接口---
int GN_DeleteFiles(const char *szDir, long nDaysAgo, const char *szType);

// 获取*.私有码流缩略图
int FUN_GetMediaThumbnail(const char *szInFileName, const char *szOutFileName);

// 通过错误id获取错误提示信息
char* Fun_GetErrorInfoByEId(int nEId, char strError[512]);

// // 创建JPEG转MP4对象 返回操作够本Jpeg2Mp4Add-------EMSG_JPEG_TO_MP4_ON_PROGRESS：进度 arg1/arg2 当前/总大小 Fun_DestoryObj结束
// nBits可以默认写0，由底层自动判断
int FUN_Jpeg2Mp4_Create(UI_HANDLE hUser, const char *szDesFileName, int nFrameRate, int nBits, int nWidth, int nHeight);
int FUN_Jpeg2Mp4_Add(FUN_HANDLE hDecoder, const char *szFileName);
// 全部文件已经放进去了--EMSG_JPEG_TO_MP4_CLOSE,真正结束看EMSG_JPEG_TO_MP4_ON_PROGRESS
int FUN_Jpeg2Mp4_Close(FUN_HANDLE hDecoder);
// 中途取消EMSG_JPEG_TO_MP4_CANCEL
int FUN_Jpeg2Mp4_Cancel(FUN_HANDLE hDecoder);

int FUN_AddRefXMSG(XMSG *pMsg);            // 消息引用计数+1
int FUN_GetXMSG(XMSG *pMsg, MsgContent *pContent);            // 获取消息内容
void FUN_RelRefXMSG(XMSG *pMsg);        // 消息引用计数-1


typedef enum DEV_NET_CNN_TYPE
{
    NET_TYPE_P2P = 0,
    NET_TYPE_SERVER_TRAN = 1,
    NET_TYPE_IP = 2,
    NET_TYPE_DSS = 3,
    NET_TYPE_TUTK = 4,  // Connected type is TUTK
    NET_TYPE_RPS = 5,  //(可靠的代理服务)
    NET_TYPE_RTC_P2P = 6,      // WebRTC-P2P
    NET_TYPE_RTC_PROXY = 7, // WebRTC-Transport
    NET_TYPE_P2P_V2 = 8,      // P2PV2
    NET_TYPE_PROXY_V2 = 9,  // ProxyV2
}DEV_NET_CNN_TYPE;

typedef enum EUIMSG
{
    EMSG_APP_ON_CRASH = 119,
    
    EMSG_SYS_GET_DEV_INFO_BY_USER = FUN_USER_MSG_BEGIN_1, // 获取设备信息
    EMSG_SYS_USER_REGISTER,        // 注册用户
    EMSG_SYS_PSW_CHANGE = FUN_USER_MSG_BEGIN_1 + 3,        // 修改用户密码
    EMSG_SYS_ADD_DEVICE,        // 增加用户设备
    EMSG_SYS_CHANGEDEVINFO,        // 修改用户设备信息
    EMSG_SYS_DELETE_DEV,        // 删除设备
    EMSG_SYS_GET_DEV_STATE = FUN_USER_MSG_BEGIN_1 + 9,        // 获取设备状态
    
    EMSG_SYS_GET_PHONE_CHECK_CODE = 5010, // 获取手机验证码
    EMSG_SYS_REGISER_USER_XM = 5011,      // 用户注册
    EMSG_SYS_GET_DEV_INFO_BY_USER_XM = 5012, // 同步登录
    EMSG_SYS_EDIT_PWD_XM = 5013,      // 忘记用户登录密码
    EMSG_SYS_FORGET_PWD_XM = 5014,      // 忘记用户登录密码
    EMSG_SYS_REST_PWD_CHECK_XM = 5015,  // 验证验证码
    EMSG_SYS_RESET_PWD_XM = 5016,       // 重置用户登录密码
    EMSG_SYS_DEV_GET_PUBLIC = 5017,     // 获取用户公开设备列表
    EMSG_SYS_DEV_GET_SHARE = 5018,      // 获取用户共享设备列表
    EMSG_SYS_DEV_PUBLIC = 5019,         // 公开设备
    EMSG_SYS_DEV_SHARE = 5020,          // 分享设备(分享视频)
    EMSG_SYS_DEV_CANCEL_PUBLIC = 5021,  // 取消公开设备
    EMSG_SYS_DEV_CANCEL_SHARE = 5022,   // 取消分享设备
    EMSG_SYS_DEV_REGISTER = 5023,         // 设备注册
    EMSG_SYS_DEV_COMMENT = 5024,         // 发表评论
    EMSG_SYS_DEV_GET_COMMENT_LIST = 5025,//获取评论列表
    EMSG_SYS_DEV_GET_VIDEO_INFO = 5026,  //获取视频信息
    EMSG_SYS_DEV_UPLOAD_VIDEO = 5027,  // 上传本地视频
    EMSG_SYS_GET_USER_PHOTOS = 5028,   // 获取用户相册列表
    EMSG_SYS_CREATE_USER_PHOTOS = 5029,// 创建用户相册
    EMSG_SYS_UPLOAD_PHOTO = 5030,      // 上传图片
    EMSG_SYS_DEIT_PHOTO = 5031,        // 图片文件编辑
    EMSG_SYS_GET_VIDEO_LIST = 5032,    // 获取短片视频列表
    EMSG_SYS_DEV_EDIT_VIDEO = 5033,    // 短片视频编辑
    EMSG_SYS_GET_PHOTO_LIST = 5034,    // 图片文件列表
    EMSG_SYS_DEV_DELETE_VIDEO = 5035,  // 删除短片视频
    EMSG_SYS_DELETE_PHOTO = 5036,      // 删除图片
    EMSG_SYS_DELETE_PHOTOS = 5037,     // 删除相册
    
    EMSG_SYS_GETPWBYEMAIL = 5038,      // 通过邮箱找回密码
    EMSG_SYS_CHECK_PWD_STRENGTH = 5039, // 检测密码合法性及强度
    EMSG_SYS_CHECK_DEVIDE_REAL = 5040, // 检测产品正品否
    EMSG_SYS_SEND_EMAIL_CODE = 5041,     // 发送邮箱验证码
    EMSG_SYS_REGISTE_BY_EMAIL = 5042,  // 邮箱注册
    EMSG_SYS_SEND_EMAIL_FOR_CODE = 5043, // 发送邮箱验证码（修改密码、重置密码）
    EMSG_SYS_CHECK_CODE_FOR_EMAIL = 5044,// 验证邮箱验证码（修改密码、重置密码）
    EMSG_SYS_PSW_CHANGE_BY_EMAIL = 5045, // 通过邮箱修改密码（重置密码）
    EMSG_SYS_CHECK_USER_REGISTE = 5046, // 检测用户名是否已注册
    EMSG_SYS_LOGOUT = 5047, // 同步退出
    EMSG_SYS_NO_VALIDATED_REGISTER = 5048, // 无需验证注册
    EMSG_SYS_GET_USER_INFO = 5049, // 获取用户信息
    EMSG_SYS_SEND_BINDING_PHONE_CODE = 5050, // 绑定安全手机(1)—发送验证码
    EMSG_SYS_BINDING_PHONE = 5051, // 绑定安全手机(2)—验证code并绑定
    
    EMSG_SYS_CLOUDUPGRADE_CHECK = 5052, //5052  设备是否需要升级查询
    EMSG_SYS_CLOUDUPGRADE_DOWNLOAD = 5053, //5053 设备云升级下载
    EMSG_SYS_SEND_BINDING_EMAIL_CODE = 5054, // 绑定安全邮箱(1)—发送验证码
    EMSG_SYS_BINDING_EMAIL = 5055, // 绑定安全邮箱(2)—验证code并绑定
    EMSG_SYS_REGISER_USER_XM_EXTEND = 5056,      // 用户注册(Extend)
    EMSG_SYS_REGISTE_BY_EMAIL_EXTEND = 5057,  // 邮箱注册(Extend)
    EMSG_SYS_NO_VALIDATED_REGISTER_EXTEND = 5058, // 无需验证注册(Extend)
    
    EMSG_SYS_STOP_CLOUDUPGRADE_DOWNLOAD = 5059, //停止下载
    EMSG_SYS_ADD_DEV_BY_FILE = 5060,            //5060
    EMSG_SYS_GET_DEV_INFO_BY_USER_INSIDE = 5061,  //内部获取设备列表，用于android报警推送
    EMSG_SYS_GET_DEVLOG = 5062,                    // 获取设备端日志，并上传到服务器
    EMSG_SYS_GET_DEVLOG_END = 5063,                // 获取设备端日志，并上传到服务器
    EMSG_SYS_WX_ALARM_LISTEN_OPEN = 5064,         // 开启微信报警监听
    EMSG_SYS_WX_ALARM_LISTEN_CLOSE = 5065,        // 关闭微信报警监听
    EMSG_SYS_WX_ALARM_WXPMSCHECK = 5066,          // 微信报警状态查询
    EMSG_SYS_CHECK_CS_STATUS     = 5067,          // 实时从服务器上查询云存储状态
    EMSG_SYS_DULIST     = 5068,                   // 获取设备所在的帐户信息
    EMSG_SYS_MDSETMA    = 5069,                   // 指定设备的主帐户
    EMSG_SYS_MODIFY_USERNAME = 5070,              // 修改登录用户名（只能修改微信等绑定帐户自动生成）
    EMSG_SYS_ON_DEV_STATE = 5071,                 // 设备状态变化通知
    EMSG_SYS_IS_MASTERMA = 5072,                  // 获取当前账号是否为该设备的主账号
    EMSG_SYS_GET_ABILITY_SET = 5073,              // 从服务器端获取设备能力集
    EMSG_SYS_CHECK_DEV_VALIDITY = 5074,           // 在服务器端验证设备校验码合法性
	EMSG_SYS_CANCELLATION_USER_XM = 5075,		  // 注销用户账号

    EMSG_XM030_VIDEO_LOGIN = 8601,
    EMSG_XM030_VIDEO_LOGOUT = 8602,
    
    EMSG_APP_ON_SEND_LOG_FILE  = 5098,    // 日志信息回调
    EMSG_APP_LOG_OUT  = 5098,    // 日志信息回调
    
    EMSG_DEV_GET_CHN_NAME = FUN_USER_MSG_BEGIN_1 + 100,
    EMSG_DEV_FIND_FILE = 5101,
    EMSG_DEV_FIND_FILE_BY_TIME = 5102,
    EMSG_DEV_ON_DISCONNECT = 5103,
    EMSG_DEV_ON_RECONNECT = 5104,
    EMSG_DEV_PTZ_CONTROL = 5105,
    EMSG_DEV_AP_CONFIG = 5106,
    EMSG_DEV_GET_CONFIG = 5107,
    EMSG_DEV_SET_CONFIG = 5108,
    EMSG_DEV_GET_ATTR = 5109,
    EMSG_DEV_SET_ATTR = 5110,
    EMSG_DEV_START_TALK = 5111,
    EMSG_DEV_SEND_MEDIA_DATA = 5112,
    EMSG_DEV_STOP_TALK = 5113,
    EMSG_ON_DEV_DISCONNECT = 5114,
    EMSG_ON_REC_IMAGE_SYN = 5115, // 录像索引图片同步 param1 == 0：同步进度 总图片\已经同步图片
    // param1 == 1：param2 == 0  同步的数目
    EMSG_ON_FILE_DOWNLOAD = 5116,
    EMSG_ON_FILE_DLD_COMPLETE = 5117,
    EMSG_ON_FILE_DLD_POS = 5118,
    EMSG_DEV_START_UPGRADE = 5119,       // param0表示表示结果
    EMSG_DEV_ON_UPGRADE_PROGRESS = 5120, // param0==EUPGRADE_STEP
    // param1==2表示下载或升级进度或升级结果;
    // 进度0~100; 结果->0：成功  < 0 失败    200:已经是最新的程序
    EMSG_DEV_STOP_UPGRADE = 5121,
    EMSG_DEV_OPTION = 5122,
    EMSG_DEV_START_SYN_IMAGE = 5123,
    EMSG_DEV_STOP_SYN_IMAGE = 5124,
    EMSG_DEV_CHECK_UPGRADE = 5125,     // 检查设备升级状态,parma1<0:失败;==0:当前已经是最新程序;1:服务器上有最新的升级程序;2:支持云升级;
    EMSG_DEV_SEARCH_DEVICES = 5126,
    EMSG_DEV_SET_WIFI_CFG = 5127,
    EMSG_DEV_GET_CONFIG_JSON = 5128,
    EMSG_DEV_SET_CONFIG_JSON = 5129,
    EMSG_DEV_ON_TRANSPORT_COM_DATA = 5130,
    EMSG_DEV_CMD_EN = 5131,
    EMSG_DEV_GET_LAN_ALARM = 5132,
    EMSG_DEV_SEARCH_PIC = 5133,
    EMSG_DEV_SEARCH_PIC_STOP = 5134,
    EMSG_DEV_START_UPLOAD_DATA = 5135,
    EMSG_DEV_STOP_UPLOAD_DATA = 5136,
    EMSG_DEV_ON_UPLOAD_DATA = 5137,
    EMSG_ON_CLOSE_BY_LIB = 5138,
    EMSG_DEV_LOGIN = 5139,
    EMSG_DEV_BACKUP = 5140,
    EMSG_DEV_SLEEP = 5141,
    EMSG_DEV_WAKE_UP = 5142,
    EMSG_DEV_SET_NET_IP_BY_UDP = 5143,
#ifdef SUP_PREDATOR
	EMSG_DEV_PREDATOR_FILES_OPERATION = 5144, //捕食器文件操作
	EMSG_DEV_PREDATOR_SEND_FILE = 5145, //捕食器文件传输
	EMSG_DEV_PREDATOR_FILE_SAVE = 5146, //捕食器文件保存
#endif
	EMSG_DEV_START_PUSH_PICTURE = 5147, //开始推图
	EMSG_DEV_STOP_PUSH_PICTURE = 5148, //停止推图
	EMSG_DEV_MAIN_LINK_KEEP_ALIVE = 5149, //从后台切回app，主链接检测，保活
	EMSG_DEV_CONFIG_JSON_NOT_LOGIN = 5150, //设备配置获取，设置(Json格式，不需要登陆设备)

    EMSG_SET_PLAY_SPEED = FUN_USER_MSG_BEGIN_1 + 500,
    EMSG_START_PLAY = 5501,
    EMSG_STOP_PLAY = 5502,
    EMSG_PAUSE_PLAY = 5503,
    
    EMSG_MEDIA_PLAY_DESTORY = 5504,        // 媒体播放退出,通知播放对象
    EMSG_START_SAVE_MEDIA_FILE = 5505,        // 保存录像,保存格式用后缀区分,.dav私有;.avi:AVI格式;.mp4:MP4格式
    EMSG_STOP_SAVE_MEDIA_FILE = 5506,        // 停止录像
    EMSG_SAVE_IMAGE_FILE = 5507,            // 抓图,保存格式用后缀区分,.bmp或.jpg
    EMSG_ON_PLAY_INFO = 5508,          // 回调播放信息
    EMSG_ON_PLAY_END = 5509,           // 录像播放结束
    EMSG_SEEK_TO_POS = 5510,
    EMSG_SEEK_TO_TIME = 5511,
    EMSG_SET_SOUND = 5512,                 // 打开，关闭声音
    EMSG_ON_MEDIA_NET_DISCONNECT = 5513,   // 媒体通道网络异常断开
    EMSG_ON_MEDIA_REPLAY = 5514,        // 媒体重新播放
    EMSG_START_PLAY_BYTIME = 5515,
    EMSG_ON_PLAY_BUFFER_BEGIN = 5516,   // 正在缓存数据
    EMSG_ON_PLAY_BUFFER_END = 5517,     // 缓存结束,开始播放
    EMSG_ON_PLAY_ERROR = 5518,          // 回调播放异常,长时间没有
    EMSG_ON_SET_PLAY_SPEED = 5519,      // 播放速度
    EMSG_REFRESH_PLAY = 5520,
    EMSG_MEDIA_BUFFER_CHECK = 5521,     // 缓存检查
    EMSG_ON_MEDIA_SET_PLAY_SIZE = 5522, // 设置高清/标清
    EMSG_ON_MEDIA_FRAME_LOSS = 5523,    // 超过4S没有收到数据
    EMSG_ON_YUV_DATA = 5524,             // YUV数据回调
    EMSG_MEDIA_SETPLAYVIEW = 5525,        // 改变显示View
    EMSG_ON_FRAME_USR_DATA = 5526,        // 用户自定义信息帧回调
    EMSG_ON_Media_Thumbnail = 5527,     // 抓取视频缩略图
    EMSG_ON_MediaData_Save = 5528,        // 媒体数据开始保存
    EMSG_MediaData_Save_Process = 5529, // 媒体数据已保存大小
    EMSG_Stop_DownLoad = 5530,            //停止下载
    EMSG_START_IMG_LIST_DOWNLOAD = 5531,//图像列表下载
    EMSG_SET_INTELL_PLAY = 5532,   // 智能播放
    EMSG_ON_MEDIA_DATA = 5533,        //解码前数据回调
    EMSG_DOWN_RECODE_BPIC_START =  5534,    //录像缩略图下载开始
    EMSG_DOWN_RECODE_BPIC_FILE  =  5535,    //录像缩略图下载--文件下载结果返回
    EMSG_DOWN_RECODE_BPIC_COMPLETE =  5536, //录像缩略图下载-下载完成（结束）
    
    EMSG_MC_LinkDev = 6000,
    EMSG_MC_UnlinkDev = 6001,
    EMSG_MC_SendControlData = 6002,
    EMSG_MC_SearchAlarmInfo = 6003,
    EMSG_MC_SearchAlarmPic = 6004,
    EMSG_MC_ON_LinkDisCb= 6005,  //
    EMSG_MC_ON_ControlCb = 6006,
    EMSG_MC_ON_AlarmCb = 6007,
    EMSG_MC_ON_PictureCb = 6008,
    EMSG_MC_ConnectDev = 6009,
    EMSG_MC_DisconnectDev = 6010,
    EMSG_MC_INIT_INFO = 6011,
    EMSG_MC_DeleteAlarm = 6012,
    EMSG_MC_GetAlarmRecordUrl = 6013,    // 废弃
    EMSG_MC_SearchAlarmByMoth = 6014,
    EMSG_MC_OnRecvAlarmJsonData = 6015,  //第三方报警服务器收到报警数据处理回调
	EMSG_MC_StopDownloadAlarmImages = 6016,
	EMSG_MC_SearchAlarmLastTimeByType = 6017, //按类型查询最后一条报警时间

    EMSG_XD_LinkMedia=7001,
    EMSG_XD_UnlinkMedia=7002,
    EMSG_XD_PublicHistoryList=7003,
    EMSG_XD_PublicCurrentList=7004,
    EMSG_XD_PublicDevInfo=7005,
    EMSG_XD_FetchPicture=7006,
    
    EMSG_CD_MediaTimeSect = FUN_USER_MSG_BEGIN_1 + 1200,// 废弃，不再使用
    EMSG_CD_Media_Dates = 6201,                            // 废弃，不再使用
    EMSG_MC_SearchMediaByMoth = 6202,
    EMSG_MC_SearchMediaByTime = 6203,
    EMSG_MC_DownloadMediaThumbnail = 6204,

    EMSG_DL_ON_DOWN_FILE = FUN_USER_MSG_BEGIN_1 + 1500,
    EMSG_DL_ON_INFORMATION,
    
    EMSG_CSS_API_CMD = FUN_USER_MSG_BEGIN_1 + 1600,//CSS API
    EMSG_KSS_API_UP_LOAD_VIDEO, //KSS API POST(VIDEO)
    EMSG_KSS_API_CMD_GET, //KSS API GET
    EMSG_KSS_API_UP_LOAD_PHOTO, //KSS API POST(PHOTO)
    
    EMSG_MC_ON_Alarm_NEW = FUN_USER_MSG_BEGIN_1 + 1700,
    
    EMSG_FIR_IM_CHECK_LATEST = FUN_USER_MSG_BEGIN_1 + 1800,
    
    EMSG_QT_API_INIT = FUN_USER_MSG_BEGIN_1 + 2000, // QintTing API
    EMSG_QT_GET_CATEGORYIES,
    EMSG_QT_GET_CHANNELS,
    EMSG_QT_GET_LIVE_CHANNELS,
    EMSG_QT_GET_PROGRAMS,
    EMSG_QT_GET_LIVE_PROGRAMS,
    EMSG_QT_GET_PROGRAMS_DETAIL,
    EMSG_QT_SEARCH_CONTENT,
    
    EMSG_JPEG_TO_MP4_ON_PROGRESS = FUN_USER_MSG_BEGIN_1 + 3000,
    EMSG_JPEG_TO_MP4_ADD_FILE,
    EMSG_JPEG_TO_MP4_CLOSE,
    EMSG_JPEG_TO_MP4_CANCEL,
    
    //视频广场、雄迈云
    EMSG_SYS_EDIT_USER_PHOTOS = FUN_USER_MSG_BEGIN_1 + 3500,
    EMSG_SYS_CHECK_USER_PHONE,
    EMSG_SYS_CHECK_USER_MAIL,
    EMSG_SYS_CHANGE_DEV_LOGIN_PWD,
    EMSG_SYS_BINDING_ACCOUNT,
    
    // 其它自定义消息
    // 广告更新等消息返回
    EMSG_CM_ON_VALUE_CHANGE = FUN_USER_MSG_BEGIN_1 + 3600,
    EMSG_CM_ON_GET_SYS_MSG = 8603,
    EMSG_CM_ON_GET_SYS_MSG_LIST = 8604,
}EUIMSG;

typedef enum EDEV_ATTR
{
    EDA_STATE_CHN = 1,
    EDA_OPT_ALARM = 2,
    EDA_OPT_RECORD = 3,
    EDA_DEV_INFO = 4,
}EDEV_ATTR;

typedef enum EDEV_GN_COMMAND
{
    DEV_CMD_OPSCalendar = 1446,
}EDEV_GN_COMMAND;

typedef enum EDEV_OPTERATE
{
    EDOPT_STORAGEMANAGE = 1, // 磁盘管理
    EDOPT_DEV_CONTROL = 2,   // Deivce Control
    EDOPT_DEV_GET_IMAGE = 3,  //设备抓图
    EDOPT_DEV_OPEN_TANSPORT_COM = 5,
    EDOPT_DEV_CLOSE_TANSPORT_COM = 6,
    EDOPT_DEV_TANSPORT_COM_READ = 7,
    EDOPT_DEV_TANSPORT_COM_WRITE = 8,
    EDOPT_DEV_BACKUP = 9,        //备份录像到u盘  9
    EDOPT_NET_KEY_CLICK = 10,
}EDEV_OPTERATE;

////////////////////////兼容处理---后期会删除/////////////////////////////////////////
#define  EDA_DEV_OPEN_TANSPORT_COM       EDOPT_DEV_OPEN_TANSPORT_COM
#define  EDA_DEV_CLOSE_TANSPORT_COM     EDOPT_DEV_CLOSE_TANSPORT_COM
#define  EDA_DEV_TANSPORT_COM_READ        EDOPT_DEV_TANSPORT_COM_READ
#define  EDA_DEV_TANSPORT_COM_WRITE        EDOPT_DEV_TANSPORT_COM_WRITE
#define  EDA_NET_KEY_CLICK                EDOPT_NET_KEY_CLICK
#define  EDA_DEV_BACKUP                    EDOPT_DEV_BACKUP
////////////////////////////////////////////////////////////////////////////////

typedef enum EFUN_ERROR
{
    EE_DVR_SDK_NOTVALID            = -10000,            // 非法请求
    EE_DVR_ILLEGAL_PARAM        = -10002,            // 用户参数不合法
    EE_DVR_SDK_TIMEOUT            = -10005,            // 等待超时
    EE_DVR_SDK_UNKNOWNERROR        = -10009,            // 未知错误
    EE_DVR_DEV_VER_NOMATCH        = -11000,            // 收到数据不正确，可能版本不匹配
    EE_DVR_SDK_NOTSUPPORT        = -11001,            // 版本不支持
    
    EE_DVR_OPEN_CHANNEL_ERROR    = -11200,            // 打开通道失败
    EE_DVR_SUB_CONNECT_ERROR    = -11202,            // 建立媒体子连接失败
    EE_DVR_SUB_CONNECT_SEND_ERROR = -11203,            // 媒体子连接通讯失败
    EE_DVR_NATCONNET_REACHED_MAX  = -11204,         // Nat视频链接达到最大，不允许新的Nat视频链接
    
    /// 用户管理部分错误码
    EE_DVR_NOPOWER                    = -11300,            // 无权限
    EE_DVR_PASSWORD_NOT_VALID        = -11301,            // 账号密码不对
    EE_DVR_LOGIN_USER_NOEXIST        = -11302,            // 用户不存在
    EE_DVR_USER_LOCKED                = -11303,            // 该用户被锁定
    EE_DVR_USER_IN_BLACKLIST        = -11304,            // 该用户不允许访问(在黑名单中)
    EE_DVR_USER_HAS_USED            = -11305,            // 该用户以登陆
    EE_DVR_USER_NOT_LOGIN            = -11306,            // 该用户没有登陆
    EE_DVR_CONNECT_DEVICE_ERROR    = -11307,            // 可能设备不在线
    EE_DVR_ACCOUNT_INPUT_NOT_VALID = -11308,            // 用户管理输入不合法
    EE_DVR_ACCOUNT_OVERLAP            = -11309,            // 索引重复
    EE_DVR_ACCOUNT_OBJECT_NONE        = -11310,            // 不存在对象, 用于查询时
    EE_DVR_ACCOUNT_OBJECT_NOT_VALID = -11311,            // 不存在对象
    EE_DVR_ACCOUNT_OBJECT_IN_USE    = -11312,            // 对象正在使用
    EE_DVR_ACCOUNT_SUBSET_OVERLAP    = -11313,            // 子集超范围 (如组的权限超过权限表，用户权限超出组的权限范围等等)
    EE_DVR_ACCOUNT_PWD_NOT_VALID    = -11314,            // 密码不正确
    EE_DVR_ACCOUNT_PWD_NOT_MATCH    = -11315,            // 密码不匹配
    EE_DVR_ACCOUNT_RESERVED            = -11316,            // 保留帐号
    EE_DVR_PASSWORD_ENC_NOT_SUP     = -11317,           // 不支持此种加密方式登录
    EE_DVR_PASSWORD_NOT_VALID2        = -11318,            // 账号密码不对2
    
    /// 配置管理相关错误码
    EE_DVR_OPT_RESTART                = -11400,            // 保存配置后需要重启应用程序
    EE_DVR_OPT_REBOOT                = -11401,            // 需要重启系统
    EE_DVR_OPT_FILE_ERROR            = -11402,            // 写文件出错
    EE_DVR_OPT_CAPS_ERROR            = -11403,            // 配置特性不支持
    EE_DVR_OPT_VALIDATE_ERROR        = -11404,            // 配置校验失败
    EE_DVR_OPT_CONFIG_NOT_EXIST        = -11405,            // 请求或者设置的配置不存在
    EE_DVR_OPT_CONFIG_PARSE_ERROR   = -11406,           // 配置解析出错
    
    
    ///
    EE_DVR_CFG_NOT_ENABLE       = -11502,             // 配置未启用
    EE_DVR_VIDEO_DISABLE        = -11503,             // 视频功能被禁用
    
    //DNS协议解析返回错误码
    EE_DVR_CONNECT_FULL                = -11612,        // 服务器连接数已满
    
    //版权相关
    EE_DVR_PIRATESOFTWARE           =-11700,         // 设备盗版
    
    EE_ILLEGAL_PARAM = -200000,        // 无效参数
    EE_USER_NOEXIST = -200001,        // 用户已经存在
    EE_SQL_ERROR = -200002,            // sql失败
    EE_PASSWORD_NOT_VALID = -200003,    // 密码不正确
    EE_USER_NO_DEV = -200004,            // 相同序列号的设备设备已经存在
    EE_USER_EXSIT = -200007,            // 用户名已经被注册
    
    //公共命令字
    EE_MC_UNKNOWNERROR = -201101,        /// 未知错误
    EE_MC_NOTVALID = -201102,            /// 非法请求
    EE_MC_MSGFORMATERR = -201103,        /// 消息格式错误
    EE_MC_LOGINED = -201104,            /// 该用户已经登录
    EE_MC_UNLOGINED = -201105,            /// 该用户未登录
    EE_MC_USERORPWDERROR = -201106,        /// 用户名密码错误
    EE_MC_NOPOWER = -201107,            /// 无权限
    EE_MC_NOTSUPPORT = -201108,            /// 版本不支持
    EE_MC_TIMEOUT = -201109,            /// 超时
    EE_MC_NOTFOUND = -201110,            /// 查找失败，没有找到对应文件
    EE_MC_FOUND = -201111,                /// 查找成功，返回全部文件
    EE_MC_FOUNDPART = -201112,            /// 查找成功，返回部分文件
    EE_MC_PIRATESOFTWARE = -201113,        /// 盗版软件
    EE_MC_FILE_NOT_FOUND = -201114,        /// 没有查询到文件
    EE_MC_PEER_ONLINE = -201115,           /// 对端在线
    EE_MC_PEER_NOT_ONLINE = -201116,    /// 对端不在线
    EE_MC_PEERCONNET_REACHED_MAX = -201117,    /// 对端连接数已达上限
    EE_MC_LINK_SERVER_ERROR = -201118,    ///连接服务器失败
    EE_MC_APP_TYPE_ERROR = -201119,        ///APP类型错误
    EE_MC_SEND_DATA_ERROR = -201120,    ///发送数据出错
    EE_MC_AUTHCODE_ERROR = -201121,        ///获取AUTHCODE有误
    EE_MC_XPMS_UNINIT = -201122,        ///未初始化
    
    //EE_AS_PHONE_CODE = 10001：发送成功
    EE_AS_PHONE_CODE0 =-210002, //接口验证失败
    EE_AS_PHONE_CODE1 =-210003, //参数错误
    EE_AS_PHONE_CODE2 =-210004, //手机号码已被注册
    EE_AS_PHONE_CODE3 =-210005, //超出短信每天发送次数限制(每个号码发送注册验证信息1天只能发送三次)
    EE_AS_PHONE_CODE4 =-210010, //发送失败
    EE_AS_PHONE_CODE5 =-210017, // 120秒之内只能发送一次，
    
    //此处需当心
    EE_DSS_NOT_SUP_MAIN = -210008,   // DSS不支持高清模式
    EE_TPS_NOT_SUP_MAIN = -210009,   // 转发模式不支持高清模式
    
    EE_AS_REGISTER_CODE0 =-210102, //接口验证失败
    EE_AS_REGISTER_CODE1 =-210103, //参数错误
    EE_AS_REGISTER_CODE2 =-210104, //手机号码已被注册
    EE_AS_REGISTER_CODE3 =-210106, //用户名已被注册
    EE_AS_REGISTER_CODE4 =-210107, //注册码验证错误
    EE_AS_REGISTER_CODE5 =-210110, //注册失败（msg里有失败具体信息）
    
    EE_AS_LOGIN_CODE1 =-210202, //接口验证失败
    EE_AS_LOGIN_CODE2 =-210203, //参数错误
    EE_AS_LOGIN_CODE3 =-210210, //登录失败
    
    EE_AS_EIDIT_PWD_CODE1 =-210302, // 接口验证失败
    EE_AS_EIDIT_PWD_CODE2 =-210303, // 参数错误
    EE_AS_EIDIT_PWD_CODE3 =-210311, // 新密码不符合要求
    EE_AS_EIDIT_PWD_CODE4 =-210313, // 原密码错误
    EE_AS_EIDIT_PWD_CODE5 =-210315, // 请输入与原密码不同的新密码
    
    EE_AS_FORGET_PWD_CODE1 =-210402, // 接口验证失败
    EE_AS_FORGET_PWD_CODE2 =-210403, // 参数错误
    EE_AS_FORGET_PWD_CODE3 =-210405, // 超出短信每天发送次数限制(每个号码发送注册验证信息1天只能发送三次)
    EE_AS_FORGET_PWD_CODE4 =-210410, // 发送失败（msg里有失败具体信息）
    EE_AS_FORGET_PWD_CODE5 =-210414, // 手机号码不存在
    
    EE_AS_RESET_PWD_CODE1 =-210502, //接口验证失败
    EE_AS_RESET_PWD_CODE2 =-210503, //参数错误
    EE_AS_RESET_PWD_CODE3 =-210511, //新密码不符合要求
    EE_AS_RESET_PWD_CODE4 =-210512, //两次输入的新密码不一致
    EE_AS_RESET_PWD_CODE5 =-210514, //手机号码不存在
    
    EE_AS_CHECK_PWD_CODE1 =-210602, //接口验证失败
    EE_AS_CHECK_PWD_CODE2 =-210603, //参数错误
    EE_AS_CHECK_PWD_CODE3 =-210607, //验证码错误
    EE_AS_CHECK_PWD_CODE4 =-210614, //手机号码不存在
    //视频广场相关
    EE_AS_GET_PUBLIC_DEV_LIST_CODE = -210700, // 服务器响应失败
    
    EE_AS_GET_SHARE_DEV_LIST_CODE = -210800, // 服务器响应失败
    
    EE_AS_SET_DEV_PUBLIC_CODE = -210900, // 服务器响应失败
    
    EE_AS_SHARE_DEV_VIDEO_CODE = -211000, // 服务器响应失败
    
    EE_AS_CANCEL_DEV_PUBLIC_CODE = -211100, // 服务器响应失败
    
    EE_AS_CANCEL_SHARE_VIDEO_CODE = -211200, // 服务器响应失败
    
    EE_AS_DEV_REGISTER_CODE = -211300, // 服务器响应失败
    
    EE_AS_SEND_COMMNET_CODE  = -211400, // 服务器响应失败
    
    EE_AS_GET_COMMENT_LIST_CODE = -211500, // 服务器响应失败
    
    EE_AS_GET_VIDEO_INFO_CODE = -211600, // 服务器响应失败
    
    EE_AS_UPLOAD_LOCAL_VIDEO_CODE = -211700, // 服务器响应失败
    EE_AS_UPLOAD_LOCAL_VIDEO_CODE1 = -211703, // 缺少上传文件
    
    EE_AS_GET_SHORT_VIDEO_LIST_CODE = -211800, // 服务响应失败
    
    EE_AS_EDIT_SHORT_VIDEO_INFO_CODE = -211900, // 服务响应失败
    
    EE_AS_DELETE_SHORT_VIDEO_CODE = -212000, // 服务响应失败
    
    EE_AS_SELECT_AUTHCODE_CDOE =  -212100, // 服务响应失败
    EE_AS_SELECT_AUTHCODE_CDOE1 =  -212104, // 服务器查询失败
    
    EE_AS_GET_USER_PHOTOS_LIST_CODE = -212200, // 服务响应失败
    
    EE_AS_CREATE_USER_PHOTOS_CODE = -212300, // 服务响应失败
    
    EE_AS_UPLOAD_PHOTO_CODE = -212400, // 服务响应失败
    EE_AS_UPLOAD_PHOTO_CODE1 = -212402, // 没有接受到上传的文件
    
    EE_AS_EDIT_PHOTO_INFO_CODE = -212500, // 服务响应失败
    
    EE_AS_GET_PHOTO_LIST_CODE = -212600, // 服务响应失败
    
    EE_AS_DELETE_PHOTO_CODE = -212700, // 服务响应失败
    
    EE_AS_DELETE_PHOTOS_CODE = -212800, //服务响应失败
    
    EE_AS_CHECK_PWD_STRENGTH_CODE = -212900, //服务器响应失败
    EE_AS_CHECK_PWD_STRENGTH_CODE1 = -212902, //接口验证失败
    EE_AS_CHECK_PWD_STRENGTH_CODE2 = -212903, //参数错误
    EE_AS_CHECK_PWD_STRENGTH_CODE3 = -212910, //密码不合格
    
    //云服务通过邮箱找回密码返回错误
    EE_HTTP_PWBYEMAIL_UNFINDNAME = -213000,  //无此用户名
    EE_HTTP_PWBYEMAIL_FAILURE = -213001,    //发送失败
    
    EE_AS_SEND_EMAIL_CODE = -213100,    // 服务响应失败
    EE_AS_SEND_EMAIL_CODE1 = -213102,   // 接口验证失败
    EE_AS_SEND_EMAIL_CODE2 = -213103,   //参数错误
    EE_AS_SEND_EMAIL_CODE3 = -213108,   //邮箱已被注册
    EE_AS_SEND_EMAIL_CODE4 = -213110,   //发送失败
    
    EE_AS_REGISTE_BY_EMAIL_CODE = -213200,    // 服务响应失败
    EE_AS_REGISTE_BY_EMAIL_CODE1 = -213202,    // 接口验证失败
    EE_AS_REGISTE_BY_EMAIL_CODE2 = -213203,    // 参数错误
    EE_AS_REGISTE_BY_EMAIL_CODE3 = -213206,    // 用户名已被注册
    EE_AS_REGISTE_BY_EMAIL_CODE4 = -213207,    // 注册码验证错误
    EE_AS_REGISTE_BY_EMAIL_CODE5 = -213208,    // 邮箱已被注册
    EE_AS_REGISTE_BY_EMAIL_CODE6 = -213210,    // 注册失败
    
    EE_AS_SEND_EMAIL_FOR_CODE = -213300,    // 服务响应失败
    EE_AS_SEND_EMAIL_FOR_CODE1 = -213302,    // 接口验证失败
    EE_AS_SEND_EMAIL_FOR_CODE3 = -213303,    // 参数错误
    EE_AS_SEND_EMAIL_FOR_CODE4 = -213310,    // 发送失败
    EE_AS_SEND_EMAIL_FOR_CODE5 = -213314,    // 邮箱不存在
    EE_AS_SEND_EMAIL_FOR_CODE6 = -213316,    // 箱和用户名不匹配
    
    EE_AS_CHECK_CODE_FOR_EMAIL = -213400,    // 服务响应失败
    EE_AS_CHECK_CODE_FOR_EMAIL1 = -213402,    // 接口验证失败
    EE_AS_CHECK_CODE_FOR_EMAIL2 = -213403,    // 参数错误
    EE_AS_CHECK_CODE_FOR_EMAIL3 = -213407,    // 验证码错误
    EE_AS_CHECK_CODE_FOR_EMAIL4 = -213414,    // 邮箱不存在
    
    EE_AS_RESET_PWD_BY_EMAIL = -213500,   // 服务响应失败
    EE_AS_RESET_PWD_BY_EMAIL1 = -213502,   // 接口验证失败
    EE_AS_RESET_PWD_BY_EMAIL2 = -213503,   // 参数错误
    EE_AS_RESET_PWD_BY_EMAIL3 = -213513,   // 重置失败
    EE_AS_RESET_PWD_BY_EMAIL4 = -213514,   //手机号码或邮箱不存在
    
    EE_CLOUD_DEV_MAC_BACKLIST = -213600,   //101://在黑名单中(mac)
    EE_CLOUD_DEV_MAC_EMPTY = -213602,     //104: //mac值为空
    EE_CLOUD_DEV_MAC_INVALID = -213603,     //105: //格式不对(mac地址长度不为16位或者有关键字)
    EE_CLOUD_DEV_MAC_UNREDLIST = -213604,     //107:  //不存在白名单
    EE_CLOUD_DEV_NAME_EMPTY = -213605,     //109: //设备名不能为空
    EE_CLOUD_DEV_USERNAME_INVALID = -213606, //111: //设备用户名格式不正确，含关键字
    EE_CLOUD_DEV_PASSWORD_INVALID = -213607,  //112: //设备密码格式不正确，含关键字
    EE_CLOUD_DEV_NAME_INVALID = -213608,     //113: //设备名称格式不正确，含关键字
    
    EE_CLOUD_PARAM_INVALID = -213610,      //10003: //参数异常（dev.mac传入的参数不对）
    EE_CLOUD_CHANGEDEVINFO = -213612,     //编辑设备信息失败
    
    EE_CLOUD_SERVICE_ACTIVATE = -213620,      //10002://开通失败
    EE_CLOUD_SERVICE_UNAVAILABLE = -213621,    //40001: //没有开通云存储（1、用户不存在；2、用户没有开通 ）
    
    EE_CLOUD_AUTHENTICATION_FAILURE = -213630 ,    //150000: //验证授权失败（用户名或密码错误）
    
    EE_AS_CHECK_USER_REGISTE_CODE = -213700,    // 服务响应失败
    EE_AS_CHECK_USER_REGISTE_CODE1 = -213702,    // 接口验证失败
    EE_AS_CHECK_USER_REGISTE_CODE2 = -213703,    // 参数错误
    EE_AS_CHECK_USER_REGISTE_CODE3 = -213706,    // 用户名已被注册
    
    EE_CLOUD_UPGRADE_UPDATE = -213800, //成功，需要更新
    EE_CLOUD_UPGRADE_LASTEST = -213801, //成功，已是最新，无需更新
    EE_CLOUD_UPGRADE_INVALIDREQ = -213802,//失败，无效请求
    EE_CLOUD_UPGRADE_UNFINDRES = -213803,   //失败，资源未找到
    EE_CLOUD_UPGRADE_SERVER = -213804,     //失败，服务器内部错误
    EE_CLOUD_UPGRADE_SERVER_UNAVAIL = -213805,  //失败，服务器暂时不可用，此时Retry-After指定下次请求的时间
    
    EE_AS_EDIT_USER_PHOTOS_CODE = -213900,// 服务响应失败
    
    EE_AS_SYS_LOGOUT_CODE = -214100, // 服务器向应失败
    EE_AS_SYS_LOGOUT_CODE1 = -214102, // 接口验证失败
    EE_AS_SYS_LOGOUT_CODE2 = -214103, // 参数错误
    
    EE_AS_SYS_NO_VALIDATED_REGISTER_CODE = -214200, // 服务器响应失败
    EE_AS_SYS_NO_VALIDATED_REGISTER_CODE1 = -214202, // 接口验证失败
    EE_AS_SYS_NO_VALIDATED_REGISTER_CODE2 = -214203, // 参数错误
    EE_AS_SYS_NO_VALIDATED_REGISTER_CODE3 = -214206, // 用户名已被注册
    EE_AS_SYS_NO_VALIDATED_REGISTER_CODE4 = -214210, // 注册失败
    
    EE_AS_SYS_GET_USER_INFO_CODE = -214300, // 服务器响应失败
    EE_AS_SYS_GET_USER_INFO_CODE1 = -214302, // 接口验证失败
    EE_AS_SYS_GET_USER_INFO_CODE2 = -214303, // 参数错误
    EE_AS_SYS_GET_USER_INFO_CODE3 = -214306, // 用户名不存在
    EE_AS_SYS_GET_USER_INFO_CODE4 = -214310, // 获取失败
    EE_AS_SYS_GET_USER_INFO_CODE5 = -214313, // 用户密码错误
    
    EE_AS_SYS_SEND_BINDING_PHONE_CODE = -214400, // 服务器响应失败
    EE_AS_SYS_SEND_BINDING_PHONE_CODE1 = -214402, // 接口验证失败
    EE_AS_SYS_SEND_BINDING_PHONE_CODE2 = -214403, // 参数错误
    EE_AS_SYS_SEND_BINDING_PHONE_CODE3 = -214404, // 手机号码已被绑定
    EE_AS_SYS_SEND_BINDING_PHONE_CODE4 = -214405, // 超出短信每天发送次数限制
    EE_AS_SYS_SEND_BINDING_PHONE_CODE5 = -214406, // 用户名不存在
    EE_AS_SYS_SEND_BINDING_PHONE_CODE6 = -214410, // 发送失败
    EE_AS_SYS_SEND_BINDING_PHONE_CODE7 = -214413, // 用户密码错误
    EE_AS_SYS_SEND_BINDING_PHONE_CODE8 = -214417, // 120秒之内只能发送一次
    
    EE_AS_SYS_BINDING_PHONE_CODE = -214500, // 服务器响应失败
    EE_AS_SYS_BINDING_PHONE_CODE1 = -214502, // 接口验证失败
    EE_AS_SYS_BINDING_PHONE_CODE2 = -214503, // 参数错误
    EE_AS_SYS_BINDING_PHONE_CODE3 = -214504, // 手机号码已被绑定
    EE_AS_SYS_BINDING_PHONE_CODE4 = -214506, // 用户名不存在
    EE_AS_SYS_BINDING_PHONE_CODE5 = -214507, // 验证码错误
    EE_AS_SYS_BINDING_PHONE_CODE6 = -214510, // 绑定失败a
    EE_AS_SYS_BINDING_PHONE_CODE7 = -214513, // 用户密码错误
    
    EE_AS_SYS_SEND_BINDING_EMAIL_CODE = -214600, // 服务器响应失败
    EE_AS_SYS_SEND_BINDING_EMAIL_CODE1 = -214602, // 接口验证失败
    EE_AS_SYS_SEND_BINDING_EMAIL_CODE2 = -214606, // 用户名不存在
    EE_AS_SYS_SEND_BINDING_EMAIL_CODE3 = -214608, // 该邮箱已被绑定
    EE_AS_SYS_SEND_BINDING_EMAIL_CODE4 = -214610, // 发送失败
    EE_AS_SYS_SEND_BINDING_EMAIL_CODE5 = -214613, // 用户密码错误
    
    EE_AS_SYS_BINDING_EMAIL_CODE = -214700, // 服务器响应失败
    EE_AS_SYS_BINDING_EMAIL_CODE1 = -214702, // 接口验证失败
    EE_AS_SYS_BINDING_EMAIL_CODE2 = -214703, // 参数错误
    EE_AS_SYS_BINDING_EMAIL_CODE3 = -214706, // 用户名不存在
    EE_AS_SYS_BINDING_EMAIL_CODE4 = -214707, // 验证码错误
    EE_AS_SYS_BINDING_EMAIL_CODE5 = -214708, // 该邮箱已被绑定
    EE_AS_SYS_BINDING_EMAIL_CODE6 = -214710, // 绑定失败
    EE_AS_SYS_BINDING_EMAIL_CODE7 = -214713, // 用户密码错误
    
    EE_AS_REGISTER_EXTEND_CODE0 =-214802, //接口验证失败
    EE_AS_REGISTER_EXTEND_CODE1 =-214803, //参数错误
    EE_AS_REGISTER_EXTEND_CODE2 =-214804, //手机号码已被注册
    EE_AS_REGISTER_EXTEND_CODE3 =-214806, //用户名已被注册
    EE_AS_REGISTER_EXTEND_CODE4 =-214807, //注册码验证错误
    EE_AS_REGISTER_EXTEND_CODE5 =-214810, //注册失败（msg里有失败具体信息）
    
    
    EE_AS_REGISTE_BY_EMAIL_EXTEND_CODE = -214900,    // 服务响应失败
    EE_AS_REGISTE_BY_EMAIL_EXTEND_CODE1 = -214902,    // 接口验证失败
    EE_AS_REGISTE_BY_EMAIL_EXTEND_CODE2 = -214903,    // 参数错误
    EE_AS_REGISTE_BY_EMAIL_EXTEND_CODE3 = -214906,    // 用户名已被注册
    EE_AS_REGISTE_BY_EMAIL_EXTEND_CODE4 = -214907,    // 注册码验证错误
    EE_AS_REGISTE_BY_EMAIL_EXTEND_CODE5 = -214908,    // 邮箱已被注册
    EE_AS_REGISTE_BY_EMAIL_EXTEND_CODE6 = -214910,    // 注册失败
    
    EE_AS_SYS_NO_VALIDATED_REGISTER_EXTEND_CODE = -215000, // 服务器响应失败
    EE_AS_SYS_NO_VALIDATED_REGISTER_EXTEND_CODE1 = -215002, // 接口验证失败
    EE_AS_SYS_NO_VALIDATED_REGISTER_EXTEND_CODE2 = -215003, // 参数错误
    EE_AS_SYS_NO_VALIDATED_REGISTER_EXTEND_CODE3 = -215006, // 用户名已被注册
    EE_AS_SYS_NO_VALIDATED_REGISTER_EXTEND_CODE4 = -215010, // 注册失败
    
    //Dss相关错误
    EE_DSS_XMCloud_InvalidParam = -215100,    //通过XMCloud获取设备DSS信息
    EE_DSS_XMCloud_ConnectHls = -215101,    //DSS连接Hls服务器失败
    EE_DSS_XMCloud_InvalidStream= -215102,    //DSS服务器异常
    EE_DSS_XMCloud_Request = -215103,    //DSS服务器请求失败
    EE_DSS_XMCloud_StreamInterrupt = -215104,    //DSS码流格式解析失败

    EE_DSS_SQUARE_PARSE_URL = -215110,      //解析雄迈云返回的视频广场url失败
    
    EE_DSS_MINOR_STREAM_DISABLE = -215120,   // DSS  服务器禁止此种码流(-1)
    EE_DSS_NO_VIDEO = -215121,               // NVR  前端未连接视频源(-2)
    EE_DSS_DEVICE_NOT_SUPPORT = -215122,     // 前端不支持此种码流(-3)
    EE_DSS_NOT_PUSH_STRREAM = -215123,       // DSS 服务器未推流(0)
    EE_DSS_NOT_OPEN_MIXED_STRREAM = -215124, // DSS 不能使用组合编码通道进行打开，请重新打开
    
    EE_DSS_BAD_REQUEST = -215130,            // 无效请求（http）
    EE_MEDIA_CONNET_REACHED_MAX  = -215131,  // 媒体视频链接达到最大，访问受限
    
    //和Dss Token/AuthCode相关的错误
    EE_DSS_XMClOUD_ERROR_INVALID_TOKEN_FORMAT= -215140, //100001 无效的令牌格式
    EE_DSS_XMClOUD_ERROR_NOT_MATCH_TOKEN_SERINUMBER = -215141, //100002 不匹配令牌序列号
    EE_DSS_XMClOUD_ERROR_REMOTE_IP_NOT_MATCH_TOKEN_IP = -215142, //100003 远程ip不匹配令牌ip
    EE_DSS_XMClOUD_ERROR_TOKNE_EXPIRSE = -215143, //100004 令牌到期
    EE_DSS_XMClOUD_ERROR_GET_SECRET_KEY_FAILED = -215144, //100005 获取秘钥key失败
    EE_DSS_XMClOUD_ERROR_TOKEN_NOT_MATCH_SIGN = -215145, //100006 令牌不符
    EE_DSS_XMClOUD_ERROR_KEY_DATA_INVALIED_FORMAT = -215146, //100007 令牌数据无效格式
    EE_DSS_XMClOUD_ERROR_DECODE_KEY_DATA_FAILED = -215147, //100008 解密秘钥数据失败
    EE_DSS_XMClOUD_ERROR_AUTHCODE_NOT_MATCH = -215148, //100009 authcode不匹配
    EE_DSS_XMClOUD_ERROR_AUTHCODE_CHANGE = -215149, //100010 更改了authcode

    EE_ALARM_CHECK_AUTHCODE_FAILED = -221201, //报警授权码错误
    EE_ALARM_NOT_SUPPORTED = -221202,          //不支持（比较在中国界内不支持Google报警）
    
    EE_ALARM_SELECT_NO_RECORD = -222400, //未查询到报警历史记录
    
    EE_VIDEOPLAY_URL_NULL = -223000,    //url为空
    EE_VIDEOPLAY_URL_Open = -223001,    //打开失败
    EE_VIDEOPLAY_URL_FindStream = -223002, //获取流信息失败
    EE_VIDEOPLAY_URL_FindVideoStream = -223003, //获取视频流信息失败
    EE_VIDEOPLAY_URL_ReadStream = -223010, //无法获取视频流
    
    EE_DEVLOG_OPENTELNET = -223100,//打开telnet失败
    
    EE_SYS_GET_AUTH_CODE = -300000,  // 获取Auth Error
    
    EE_MNETSDK_HEARTBEAT_TIMEOUT = -400000, //The errors between -400000 and -500000 stem from libMNetSDK.so
    EE_MNETSDK_FILE_NOTEXIST = -400001, //文件不存在
    EE_MNETSDK_IS_UPGRADING = -400002, //设备正在升级中
    EE_MNETSDK_SERVER_STATUS_ERROR = -400003,    //服务器初始化失败
    EE_MNETSDK_GETCONNECT_TYPE_ERROR = -400004,    //获取连接类型失败
    EE_MNETSDK_QUERY_SERVER_FAIL = -400005,    //查询服务器失败
    EE_MNETSDK_HAS_CONNECTED = -400006,    //设备已经连接
    EE_MNETSDK_IS_LOGINING = -400007,    //正在登录
    EE_MNETSDK_DEV_IS_OFFLINE = -400008, //设备可能不在线
    EE_MNETSDK_NOTSUPPORT = -400009,    //设备不支持
    EE_MENTSDK_NOFILEFOUND = -400010,  //没有当天图片，请切换日期
    EE_MNETSDK_DISCONNECT_ERROR = -400011,  //断开连接失败
    EE_MNETSDK_TALK_ALAREADY_START = -400012,   //对讲已开启
    EE_MNETSDK_DEV_PTL = -400013,           //DevPTL NULL
    EE_MNETSDK_BACKUP_FAILURE = -400014,    //备份到u盘失败
    EE_MNETSDK_NODEVICE = -400015,           //无存储设备(u盘)或设备没在录像
    EE_MNETSDK_USEREXIST = -400016,          //设备已存在
    EE_MNETSDK_CAPTURE_PIC_FAILURE = -400017,        //抓图失败
    
    EE_MNETSDK_TALK_NOT_START = -400100,   //设备错误码往后写(设备端错误码503:对讲未开启)
    EE_MNETSDK_STORAGE_IS_FULL = -400101,  //设备存储已满
    
    //用户相关
    EE_ACCOUNT_HTTP_USERNAME_PWD_ERROR = -604000,     //4000 : 用户名或密码错误
    
    EE_ACCOUNT_VERIFICATION_CODE_ERROR = -604010,     //4010 : 验证码错误
    EE_ACCOUNT_PASSWORD_NOT_SAME = -604011,           //4011 : 密码不一致
    EE_ACCOUNT_USERNAME_HAS_BEEN_REGISTERED = -604012,//4012 : 用户名已被注册
    EE_ACCOUNT_USERNAME_IS_EMPTY = -604013,           //4013 : 用户名为空
    EE_ACCOUNT_PASSWORD_IS_EMPTY = -604014,                    //4014 : 密码为空
    EE_ACCOUNT_COMFIRMPWD_IS_EMPTY = -604015,                  //4015 : 确认密码为空
    EE_ACCOUNT_PHONE_IS_EMPTY = -604016,                       //4016 : 手机号为空
    EE_ACCOUNT_USERNAME_FORMAT_NOT_CORRECT = -604017,          //4017 : 用户名格式不正确
    EE_ACCOUNT_PASSWORD_FORMAT_NOT_CORRECT = -604018,          //4018 : 密码格式不正确
    EE_ACCOUNT_COMFIRMPWD_FORMAT_NOT_CORRECT = -604019,        //4019 : 确认密码格式不正确
    EE_ACCOUNT_PHONE_FORMAT_NOT_CORRECT = -604020,             //4020 : 手机号格式不正确
    EE_ACCOUNT_PHONE_IS_EXIST = -604021,                       //4021 : 手机号已存在
    EE_ACCOUNT_PHONE_NOT_EXSIT = -604022,                      //4022 : 手机号不存在
    EE_ACCOUNT_EMAIL_IS_EXIST = -604023,                       //4023 : 邮箱已存在
    EE_ACCOUNT_EMAIL_NOT_EXIST = -604024,                      //4024 : 邮箱不存在
    EE_ACCOUNT_OLD_PASSWORD_ERROR = -604026,                   //4026 : 原始密码错误
    EE_ACCOUNT_MODIFY_PASSWORD_ERROR = -604027,                //4027 : 修改密码失败
    EE_ACCOUNT_USERID_IS_EMPTY = -604029,                      //4029 : 用户ID为空
    EE_ACCOUNT_VERIFICATION_CODE_IS_EMPTY = -604030,           //4030 : 验证码为空
    EE_ACCOUNT_EMAIL_IS_EMPTY = -604031,                       //4031 : 邮箱为空
    EE_ACCOUNT_EMAIL_FORMATE_NOT_CORRECT = -604032,            //4032 : 邮箱格式不正确
    EE_ACCOUNT_USER_NOT_WX_BIND = -604034,                       //4034: 用户未绑定(用户名密码错误，标示用户未绑定雄迈账户，应跳转到绑定用户界面)
    EE_ACCOUNT_USER_HAS_WX_BIND = -604035,                       //4035: 用户已绑定
    EE_ACCOUNT_USER_FAIL_WX_BIND = -604036,                       //4036: 用户绑定失败
    EE_ACCOUNT_USER_FAIL_PHONE_BIND = -604037,                   //4037: 手机绑定失败
    EE_ACCOUNT_USER_FAIL_MAIL_BIND = -604038,                   //4037: 邮箱绑定失败
    EE_ACCOUNT_NOT_OPENED = -604600,                           //4600: 功能未开通
    
    //设备相关
    EE_ACCOUNT_DEVICE_ILLEGAL_NOT_ADD = -604100,        //4100 : 设备非法不允许添加
    EE_ACCOUNT_DEVICE_ALREADY_EXSIT = -604101,          //4101 : 设备已经存在（等同EE_USER_NO_DEV）
    EE_ACCOUNT_DEVICE_DELETE_FAIL = -604102,            //4102 : 删除设备失败
    EE_ACCOUNT_DEVICE_CHANGE_IFNO_FAIL = -604103,       //4103 : 设备信息修改失败
    EE_ACCOUNT_DEVICE_UUID_ILLEGAL = -604104,            //4104 : 设备uuid参数异常
    EE_ACCOUNT_DEVICE_USERNAME_ILLEGAL = -604105,        //4105 : 设备用户名参数异常
    EE_ACCOUNT_DEVICE_PASSWORD_ILLEGAL = -604106,        //4106 : 设备密码参数异常
    EE_ACCOUNT_DEVICE_PORT_ILLEGAL = -604107,            //4107 : 设备端口参数异常
    EE_ACCOUNT_DEVICE_EXTEND_ILLEGAL = -604108,            //4108 : 设备扩展字段参数异常
    EE_ACCOUNT_NOT_MASTER_ACCOUNT = -604117,             //当前账户不是当前设备的主账户
    EE_ACCOUNT_DEVICE_NOT_EXSIT = -604118,                  //设备不存在了 已经被移除了
    //授权系统
    EE_ACCOUNT_ADD_OPEN_APP_FAIL = -604200,                //4200 : 添加授权失败
    EE_ACCOUNT_UPDATE_OPEN_APP_FAIL = -604201,            //4201 : 修改授权失败
    EE_ACCOUNT_DELETE_OPEN_APP_FAIL = -604202,            //4202 : 删除授权失败
    EE_ACCOUNT_SYN_TYPE_APP_FAIL = -604203,                //4203 : 单个授权同步失败(原因可能是type参数不对,或者云产品线未返回)
    
    //发送邮件授权码
    EE_ACCOUNT_SEND_CODE_FAIL  = -604300,                      //4300 : 发送失败
    
    //发送手机授权码
    EE_ACCOUNT_MESSAGE_INTERFACE_CHECK_ERROR  = -604400,        //4400 : 短信接口验证失败，请联系我们
    EE_ACCOUNT_MESSAGE_INTERFACE_PARM_ERROR = -604401,         //4401 : 短信接口参数错误，请联系我们
    EE_ACCOUNT_MESSAGE_TIME_MORE_THAN_THREE = -604402,         //4402 : 短信发送超过次数，每个手机号一天只能发送三次
    EE_ACCOUNT_MESSAGE_SEND_ERROR = -604403,                   //4403 : 发送失败，请稍后再试
    EE_ACCOUNT_MESSAGE_SEND_OFTEN = -604404,                   //4404 : 发送太频繁了，请间隔120秒
    EE_ACCOUNT_MESSAGE_NONE_FAIL = -604405,                    //4405 : 未知错误？？
    
    //开放平台接口
    EE_ACCOUNT_OPEN_USER_LIST_NULL = -604500,                   //4500 : 未查到用户列表或用户列表为空
    EE_ACCOUNT_OPEN_DEVICE_LIST_NULL = -604502,                 //4502 : 未查到设备列表或设备列表为空
    EE_ACCOUNT_RESET_OPEN_APP_SECRET_FAIL = -604503,            //4503 : 重置 app secret 失败
    
    //服务器异常错误
    EE_ACCOUNT_HTTP_SERVER_ERROR = -605000 ,                   //5000 : 服务器故障
    EE_ACCOUNT_CERTIFICATE_NOT_EXIST = -605001,                //5001 : 证书不存在
    EE_ACCOUNT_HTTP_HEADER_ERROR = -605002,                    //5002 : 请求头信息错误
    EE_ACCOUNT_CERTIFICATE_FAILURE = -605003,                  //5003 : 证书失效
    EE_ACCOUNT_ENCRYPT_CHECK_FAILURE = -605004,                //5004 : 生成密钥校验错误
    EE_ACCOUNT_PARMA_ABNORMAL = -605005,                       //5005 : 参数异常
    EE_ACCOUNT_CONNECTION_FAILURE = -605006,                   //5006 : 连接失败
    EE_ACCOUNT_NODE_ERROR = -605007,                              //5007 : 未知错误
    EE_ACCOUNT_IP_NOT_ALLOWED = -605008,                       //5008 : ip地址不允许接入
    EE_ACCOUNT_DECRYPT_ERROR = -605009,                        //5009 : 解密错误，说明用户名密码非法
    EE_ACCOUNT_CERTIFICATE_BLACK = -605010,                    //5010 : 证书黑名单
    
    
    EE_ACCOUNT_LOGINTYPE_INVALID = -66000,                       //6000 : 无效登录方式？
    EE_ACCOUNT_NEW_PWD_FORMAT_NOT_CORRECT = -661427,           //1427 : 新密码格式不正确
    EE_ACCOUNT_USER_IS_NOT_EXSIT = -661412,                    //1412 : 用户名不存在
    
    EE_DVR_ERROR_BEGIN = -70000,                              // 透转DVR的错误值
    //设备通用错误
    EE_DVR_USER_NOT_EXIST = -70113,                            //113 : 该用户不存在
    EE_DVR_GROUP_EXIST = -70114,                            //114 : 该用户组已经存在
    EE_DVR_GROUP_NOT_EXIST = -70115,                        //114 : 该用户组不存在
    EE_DVR_NO_PTZ_PROTOCOL= -70118,                            //118 : 未设置云台协议
    EE_DVR_MEDIA_CHN_NOTCONNECT    = -70121,                    //121 : 数字通道未连接
    EE_DVR_TCPCONNET_REACHED_MAX = -70123,                    //123 : Tcp视频链接达到最大，不允许新的Tcp视频链接
    EE_DVR_LOGIN_ARGO_ERROR    = -70124,                        //124 : 用户名和密码的加密算法错误
    EE_DVR_LOGIN_NO_ADMIN = -70125,                            //125 : 创建了其它用户，不能再用admin登陆
    EE_DVR_LOGIN_TOO_FREQUENTLY    = -70126,                    //126 : 登陆太频繁，稍后重试
    EE_DVR_NAS_EXIST = -70130,                                //130 : NAS地址已存在
    EE_DVR_NAS_ALIVE = -70131,                                //131 : 路径正在被使用，无法操作
    EE_DVR_NAS_REACHED_MAX = -70132,                        //132 : NAS已达到支持的最大值,不允许继续添加
    EE_DVR_CONSUMER_OPR_WRONG_KEY = -70140,                    //140 : 消费类产品遥控器绑定按的键错了
    EE_DVR_NEED_REBOOT = -70150,                            //150 : 成功，设备需要重启
    EE_DVR_NO_SD_CARD = -70153,                                 //153 ：没有SD卡或硬盘
    EE_DVR_CONSUMER_OPR_SEARCHING = -70162,                    //162 : 设备正在添加过程中
    EE_DVR_CPPLUS_USR_PSW_ERR = -70162,                        //163 : APS客户特殊的密码错误返回值
    
    EE_DVR_XMSDK_UNKOWN                 = -79001,      // 未知错误
    EE_DVR_XMSDK_INIT_FAILED            = -79002,    // 查询服务器失败
    EE_DVR_XMSDK_INVALID_ARGUMENT        = -79003,     // 参数错误
    EE_DVR_XMSDK_OFFLINE                    = -79004,     // 离线
    EE_DVR_XMSDK_NOT_CONNECT_TO_SERVER        = -79005,     // 无法连接到服务器
    EE_DVR_XMSDK_NOT_REGISTER_TO_SERVER        = -79006,    // 向连接服务器注册失败
    EE_DVR_XMSDK_CONNECT_IS_FULL            = -79007,    // 连接数已满
    EE_DVR_XMSDK_NOT_CONNECTED                = -79008,    // 未连接
    EE_DVR_XMSDK_CONNECT_IS_TIMEOUT         = -79020,    // 连接超时
    EE_DVR_XMSDK_CONNECT_REFUSE                = -79021,    // 连接服务器拒绝连接请求
    EE_DVR_XMSDK_QUERY_STATUS_TIMEOUT        = -79022,    // 查询状态超时
    EE_DVR_XMSDK_QUERY_WANIP_TIMEOUT        = -79023,    // 查询外网信息超时
    EE_DVR_XMSDK_HANDSHAKE_TIMEOUT            = -79024,    // 握手超时
    EE_DVR_XMSDK_QUERY_SERVER_TIMEOUT        = -79025,    // 查询服务器失败
    EE_DVR_XMSDK_HEARTBEAT_IS_TIMEOUT        = -79026,    // 心跳超时
    EE_DVR_XMSDK_MSGSVR_ERRNO_DISCONNECT    = -79027,    // 连接断开
    
    //网络操作错误号
    EE_COMMAND_INVALID = -70501,                             //501 : 命令不合法
    EE_UPGRADE_ALAREADY_START = -70510,                        //510 : 已经开始升级
    EE_UPGRADE_NOT_START = -70511,                            //511 : 未开始升级
    EE_UPGRADE_FAILED = -70513,                                //513 : 升级失败
    EE_UPGRADE_SUCCESS = -70514,                            //514 : 升级成功
    EE_SET_DEFAULT_FAILED = -70520,                            //520 : 还原默认失败
    EE_SET_DEFAULT_REBOOT = -70521,                            //521 : 需要重启设备
    EE_SET_DEFAULT_VALIDATE_ERROR = -70522,                    //522 : 默认配置非法
}EFUN_ERROR;

// 对像属性
typedef enum EOBJ_ATTR
{
    EOA_DEVICE_ID = 10000,
    EOA_CHANNEL_ID = 10001,
    EOA_IP = 10002,
    EOA_PORT = 10003,
    EOA_IP_PORT = 10004,
    EOA_STREAM_TYPE = 10005,
    EOA_NET_MODE = 10006,
    EOA_COM_TYPE = 10007,
    EOA_VIDEO_WIDTH_HEIGHT = 10008,    // 获取视频的宽和高信息
    EOA_VIDEO_FRATE = 10009,          // 获取视频帧率信息
    EOA_VIDEO_BUFFER_SIZE = 10010,    // 获取缓冲的帧数
    EOA_PLAY_INFOR = 10011,
    EOA_PCM_SET_SOUND = 10012,          // -100~100
    EOA_CUR_PLAY_TIME = 10013,       // 获取当前播放的时间,返回uint64单位毫秒
    EOA_MEDIA_YUV_USER = 10014,                // 设置YUV回调
    EOA_SET_MEDIA_VIEW_VISUAL = 10015,        // 是否画视频数据
    EOA_SET_MEDIA_DATA_USER_AND_NO_DEC = 10016, //解码前数据回调，不播放
    EOA_SET_MEDIA_DATA_USER = 10017,    //解码前数据回调，同时播放
    EOA_DISABLE_DSS_FUN = 10018,            // 禁用DSS功能
    EOA_DEV_REAL_PLAY_TYPE = 10019,            // 实时媒体连接方式指定
    EOA_SET_PLAYER_USER = 10020,            // 设置回调消息接收者
    EOA_GET_ON_FRAME_USER_DATA = 10021,     // 重新回调一次信息帧（ON_FRAME_USER_DATA）,如果没有就没有回调
}EOBJ_ATTR;

typedef enum EUPGRADE_STEP
{
    EUPGRADE_STEP_COMPELETE = 10,   // 完成升级
    EUPGRADE_STEP_DOWN = 1,         // 表示下载进度;(从服务器或网络下载文件到手机(云升级是下载到设备))
    EUPGRADE_STEP_UP = 2,           // 表示上传进度;(本地上传文件到设备)
    EUPGRADE_STEP_UPGRADE = 3,      // 升级过程
}EUPGRADE_STEP;

typedef struct Strings
{
    char str[6][512];
}Strings;


typedef enum EFUN_FUNCTIONS
{
    EFUN_ALL = 0,
    EFUN_DEV_REAL_PLAY,
    EFUN_DEV_PLAY_BACK,
    EFUN_DEV_CONFIG,
    EFUN_ALARM,
    EFUN_RECOD_CLOUD,
    EFUN_SHARE,
    EFUN_VIDEO_SQUARE,
    EFUN_UPGRADE,
    EFUN_END,
}EFUN_FUNCTIONS;

typedef enum EDEV_UPGRADE_TYPE
{
    EDUT_NONE,                  // 没有更新
    EDUT_DEV_CLOUD,             // 升级方式1:设备连接升级服务器升级
    EDUT_LOCAL_NEED_DOWN,       // 升级方式2:本地升级,但升级文件还没有下载下来
    EDUT_LOCAL_DOWN_COMPLETE,   // 升级方式3:本地升级,升级文件已经下载下来了
}EDEV_UPGRADE_TYPE;

typedef enum _EDEV_BACKUP_CONTROL  //备份录像到u盘操作
{
    EDEV_BACKUP_START = 1,  //备份开始
    EDEV_BACKUP_PROCESS,    // 进度查询
    EDEV_BACKUP_STOP,       // 停止备份
}EDEV_BACKUP_CONTROL;

// 设备协议常用命令ID
typedef enum EDEV_PTL_CMD
{
    EDEV_PTL_CONFIG_GET_JSON = 1042,
    EDEV_PTL_CONFIG_SET_JSON = 1040,
}EDEV_PTL_CMD;

typedef enum EDEV_STREM_TYPE
{
    EDEV_STREM_TYPE_FD,    //1、    流畅（等级0）：         分辨率＜40W像素
    EDEV_STREM_TYPE_SD,    //2、    标清（等级1）：   40W≤分辨率＜100W像素
    EDEV_STREM_TYPE_HD,    //3、    高清（等级2）   100W≤分辨率＜200W像素
    EDEV_STREM_TYPE_FHD,//4、    全高清（等级3） 200W≤分辨率＜400W
    EDEV_STREM_TYPE_SUD,//5、    超高清（等级4） 400W≤分辨率＜？？？
}EDEV_STREM_TYPE;

#define EDECODE_STREAM_LEVEL 7
typedef enum EDECODE_TYPE
{
    EDECODE_REAL_TIME_STREAM0,      // 最实时--适用于IP\AP模式等网络状态很好的情况
    EDECODE_REAL_TIME_STREAM1,      //
    EDECODE_REAL_TIME_STREAM2,      //
    EDECODE_REAL_TIME_STREAM3,      // 中等
    EDECODE_REAL_TIME_STREAM4,      //
    EDECODE_REAL_TIME_STREAM5,      //
    EDECODE_REAL_TIME_STREAM6,      // 最流畅--适用于网络不好,网络波动大的情况
    EDECODE_FILE_STREAM = 100,        // 文件流
} EDECODE_TYPE;
#define    EDECODE_REAL_TIME_DEFALUT EDECODE_REAL_TIME_STREAM4


typedef enum EFunDevStateType
{
    EFunDevStateType_P2P = 0,        //P2P要用新的状态服务查下
    EFunDevStateType_TPS_V0 = 1,     //老的那种转发，用于老程序（2016年以前的）的插座，新的插座程序使用的是TPS
    EFunDevStateType_TPS = 2,        //透传服务
    EFunDevStateType_DSS = 3,        //媒体直播服务
    EFunDevStateType_CSS = 4,        //云存储服务
    EFunDevStateType_P2P_V0 = 5,     //P2P用老的方式,通过穿透库查询获取到的设备P2P状态
    EFunDevStateType_IP = 6,         //IP方式
    EFunDevStateType_RPS = 7,        //RPS可靠的转发
    EFunDevStateType_IDR = 8,        //门铃状态
    EFunDevStateType_SIZE,           //NUM....
}EFunDevStateType;

#define FUN_CONTROL_NET_STATE ((1 << EFunDevStateType_P2P) | (1 << EFunDevStateType_TPS) | (1 << EFunDevStateType_P2P_V0) | (1 << EFunDevStateType_IP) | (1 << EFunDevStateType_RPS))
#define FUN_CONTROL_NET_STATE_NO_IP ((1 << EFunDevStateType_P2P) | (1 << EFunDevStateType_TPS) | (1 << EFunDevStateType_P2P_V0) | (1 << EFunDevStateType_RPS))

typedef enum EFunDevState
{
    EDevState_UNKOWN = 0,           // 未知
    EDevState_ON_LINE = 1,          // 在线（如果是门铃，同时说明在唤醒状态）
    EDevState_ON_SLEEP = 2,         // 休眠可唤醒状态
    EDevState_ON_SLEEP_UNWEAK = 3,  // 休眠不可唤醒状态
    EDevState_OFF_LINE = -1,        // 不在线
    EDevState_NO_SUPPORT = -2,      // 不支持
    EDevState_NotAllowed = -3,      // 没权限
}EFunDevState;

/***************************************************
 * JPEG 鱼眼信息头处理接口
 */

#include "JPGHead.h"

/**
 * 鱼眼矫正信息写入,同jpghead_write_vrhw_exif和jpghead_write_vrsw_exif
 * return : 0成功, 非0失败
 */
int FUN_JPGHead_Write_Exif(char * srcPath, char * dstPath, FishEyeFrameParam * pFrame);

/**
 * 从文件中读取鱼眼矫正参数
 * return : 0成功, 非0失败(或者是非鱼眼图片)
 */
int FUN_JPGHead_Read_Exif(char * srcPath, FishEyeFrameParam * pFrame);

#ifdef SUP_IRCODE
void InfraRed_IRemoteClient_SetPath(char* strDataPath);
void InfraRed_IRemoteClient_LoadBrands(Brand_c* brands, int& num);
void InfraRed_IRemoteClient_LoadBrands(int type, Brand_c* brands, int& num);
void InfraRed_IRemoteClient_GetBrandNum(int type, int& num);
void InfraRed_IRemoteClient_GetRemoteNum(int& num);
void InfraRed_IRemoteClient_LoadRemotes(Remote_c* remotes, int &num);
void InfraRed_IRemoteClient_ExactMatchRemotes(MatchPage_c* page, Key_c* key, MatchResult_c* results, int& num);
void InfraRed_IRemoteClient_ExactMatchAirRemotes(MatchPage_c* page, Key_c* key, AirRemoteState_c* state, MatchResult_c* results, int& num);

void InfraRed_IRemoteManager_GetAllRooms(Room_c* rooms, int& num);
void InfraRed_IRemoteManager_GetRemoteFromRoom(Room_c room, Remote_c* remotes, int& num);
void InfraRed_IRemoteManager_GetRemoteByID(char* name, char* remote_id, Remote_c* remote);
void InfraRed_IRemoteManager_AddRemoteToRoom(Remote_c* remote, Room_c* room);
void InfraRed_IRemoteManager_DeleteRemoteFromRoom(Remote_c* remote, Room_c* room);
void InfraRed_IRemoteManager_AddRemote(Remote_c* remote);
void InfraRed_IRemoteManager_AddRoom(Room_c* room);
void InfraRed_IRemoteManager_DeleteRoom(Room_c* room);
void InfraRed_IRemoteManager_ChangeRoomName(Room_c* room, char* name);

void InfraRed_IInfraredFetcher_FetchInfrareds(Remote_c* remote, Key_c* key, Infrared_c* infrareds, int& num);
int InfraRed_IInfraredFetcher_GetAirRemoteStatus(Remote_c* remote, AirRemoteState_c* state);
int InfraRed_IInfraredFetcher_SetAirRemoteStatus(char* remote_name, AirRemoteState_c* state);
void InfraRed_IInfraredFetcher_FetchAirTimerInfrared(Remote_c* remote, Key_c* key, AirRemoteState_c* state, int time,  Infrared_c* infrareds, int& num);
void InfraRed_IInfraredFetcher_TranslateInfrared(char* code, unsigned char* data, int& num);
#endif


#ifdef SUP_WEBRTCAUDIO
void Fun_AecEnable(bool bEnable);
void Fun_AecProcess(char *pPCMData, int latency);
void Fun_AgcProcess(char* src, int nSrcLen);
#endif

#endif // FUNSDK_H

