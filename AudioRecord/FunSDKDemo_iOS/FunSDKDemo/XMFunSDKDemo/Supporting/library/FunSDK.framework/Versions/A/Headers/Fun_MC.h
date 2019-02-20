/*********************************************************************************
*Author:	Yongjun Zhao(赵永军)
*Description:  
*History:  
Date:	2014.01.01/Yongjun Zhao
Action：Create
**********************************************************************************/
#pragma once
#include "XTypes.h"

#ifndef SystemTime
/// 系统时间结构,需要和SYSTEM_TIME保持一致
struct SystemTime
{
    int  year;		///< 年。
    int  month;		///< 月，January = 1, February = 2, and so on.
    int  day;		///< 日。
    int  wday;		///< 星期，Sunday = 0, Monday = 1, and so on
    int  hour;		///< 时。
    int  minute;	///< 分。
    int  second;	///< 秒。
    int  isdst;		///< 夏令时标识。
};
#endif

typedef struct Xpms_Search_AlarmInfo_Req
{
    char Uuid[100];
    SystemTime StarTime;	//报警信息查询起始时间(MC_SearchAlarmInfoByTime接口使用)
    SystemTime EndTime;     //报警信息查询结束时间(MC_SearchAlarmInfoByTime接口使用)
    int Channel;			//Channel < 0 表示全部查询，通道号是从0开始的
    int AlarmType;          //报警类型(暂时无用)
    int Number;             //请求要查的报警条数 ，Number <= 0 表示查全部
    int Index;				//需要从查询的结果中哪一条开始取
    char Res[32];
}XPMS_SEARCH_ALARMINFO_REQ;


typedef struct Xpms_Search_AlarmPic_Req
{
    char Uuid[64];
    uint64 ID;		//报警信息ID号
    char Res[32];	//缩略图格式如下："_wxh.jpeg"  如："_176x144.jpeg" [0]==1时默认为_176x144.jpeg
                    //空时为报警原图
}XPMS_SEARCH_ALARMPIC_REQ;

typedef enum EMSGLANGUAGE
{
	ELG_AUTO = 0,
    ELG_ENGLISH = 1,
    ELG_CHINESE = 2,
}EMSGLANGUAGE;

typedef enum EAPPTYPE
{
    EXMFamily = 1,
    EFamilyCenter = 2,
    EXMEye = 3,
    EFamily_BaiAn = 4,
}EAPPTYPE;

typedef struct SMCInitInfo
{
    char user[512];
    char password[512];
    char token[256];	// Google报警需要256， 多个报警订阅用&&连接
    int language;       // EMSGLANGUAGE
    int appType;        // EAPPTYPE
    char szAppType[256];	// XXXXXX 第三方订阅报警URL
}SMCInitInfo;

// 初始化
int MC_Init(UI_HANDLE hUser, SMCInitInfo *pInfo, int nSeq);
// 定阅报警
int MC_LinkDev(UI_HANDLE hUser, const char *uuid, const char *devUsername, const char *devPwd, int nSeq = 0, const char *strDevName = NULL, const char *strVoice = NULL);
// 取消订阅报警
int MC_UnlinkDev(UI_HANDLE hUser, const char *uuid, int nSeq = 0);
int MC_UnlinkDevV2(UI_HANDLE hUser, const char *uuid, int flag, int nSeq = 0);
// 取消设备下所有账号报警订阅
int MC_UnlinkAllAccountsOfDev(UI_HANDLE hUser, const char *uuid, int nSeq = 0);

/*********************************************
* 方法名: 取消异常报警订阅
* 描  述: 上层收到异常的报警订阅消息，比如不在设备列表中的设备报警，进行取消订阅
* 返回值:
* 			无
* 参  数:
*      输入(in)
*          [szFilePath:文件绝对路径]
*      输出(out)
*          [无]
* 结果消息：
*       消息ID：EMSG_MC_UnlinkDev = 6001
*       arg1>=0成功; <0 失败，详见错误码
****************************************************/
int MC_UnlinkDevAbnormal(UI_HANDLE hUser, const char *uuid, const char *apptoken, int nSeq = 0);

// 删除报警信息，此接口使用需谨慎。alrmaID，报警id, 为NULL或空字符串，表示清空;若有多个,以；分割
int MC_Delete(UI_HANDLE hUser, const char *uuid,const char *deleteType, const char *alarmID, int nSeq = 0);

//接口废弃-zyj-161029
//int MC_DevConnect(UI_HANDLE hUser, const char *uuid, int nSeq = 0);
//int MC_DevDisConnect(UI_HANDLE hUser, const char *uuid, int nSeq = 0);

//接口废弃-zyj-161029
//int MC_SendControlData(UI_HANDLE hUser, const char *uuid, const char *buf, int nSeq = 0);

// 返回0:Unlinked  1:Linked(会很快返回,存在本地了)
int MC_GetLinkState(const char *uuid);

//下面2个查询函数，是短连接，查询完了就关闭TCP连接。
//成功返回查询符合搜索条件的报警条数，失败返回-1
int MC_SearchAlarmInfo(UI_HANDLE hUser, XPMS_SEARCH_ALARMINFO_REQ *pXPMS_SEARCH_ALARMINFO_REQ, int nSeq = 0);

// 以开始，结束时间为条件查询报警
int MC_SearchAlarmInfoByTime(UI_HANDLE hUser, XPMS_SEARCH_ALARMINFO_REQ *pXPMS_SEARCH_ALARMINFO_REQ, int nSeq = 0);

//成功返回0，失败返回-1
//pXPMS_SEARCH_ALARMPIC_REQ==NULL时,只是查询缓存数据有没有,不从服务器获取
int MC_SearchAlarmPic(UI_HANDLE hUser, const char *fileName, XPMS_SEARCH_ALARMPIC_REQ *pXPMS_SEARCH_ALARMPIC_REQ, int nSeq = 0);

// nWidth = 0 && nHeight == 0 表示原始图片，否则表示缩略图的宽和高
int MC_DownloadAlarmImage(UI_HANDLE hUser, const char *szDevSN, const char *szSaveFileName, const char *szAlaramJson, int nWidth = 0, int nHeight = 0, int nSeq = 0);

// szSaveFileNames多个
int MC_DownloadAlarmImages(UI_HANDLE hUser, const char *szDevSN, const char *szSaveFileNames, const char *szAlaramJsons, int nWidth = 0, int nHeight = 0, int nSeq = 0);

//取消队列中所有未下载的图片下载  *MC_SearchAlarmPic和MC_DownloadAlarmImage都可以取消
int MC_StopDownloadAlarmImages(UI_HANDLE hUser, int nSeq);

// 获取域名转IP后的报警图片URL 接口废弃-zyj-161029
// char *MC_GetAlarmPicURL(char *strDNSPicURL, char strPicURL[512]);

// Get alarm record url
// szAlarmTime:formate 2017-10-19 15:07:44
// msgId:EMSG_MC_GetAlarmRecordUrl
// 废弃此接口
int MC_GetAlarmRecordUrl(UI_HANDLE hUser, const char *szDevSN, const char *szAlarmTime, int nSeq = 0);

// EMSG_MC_SearchAlarmByMoth = 6014
//按月查询   如果按天查询(暂时未支持)则Data对应的value为json数组，例："Date": [{"Time": "2017-11-01"},{"Time": "2017-11-02"}]
int MC_SearchAlarmByMoth(UI_HANDLE hUser, const char *devId, int nChannel, const char *szStreamType, int nDate, int nSeq = 0);

/*********************************************
* 方法名: 按类型查询最后一条消息的时间
* 描  述: 按类型查询最后一条消息的时间 Date：Last
* 返回值:
* 			无
* 参  数:
*      输入(in)
*          [szStreamType:码流类型"Main",为了兼容老版本]
*          [szAlramType:报警类型  --VIDEO：查询视频日历节点     MSG：查询报警消息日历节点 ]
*          [nChannel:通道号]
*      输出(out)
*          [无]
* 结果消息：
*       消息EMSG_MC_SearchAlarmLastTimeByType = 6017
*       arg1>=0成功; <0 失败，详见错误码
****************************************************/
int MC_SearchAlarmLastTimeByType(UI_HANDLE hUser, const char *devId, const char *szStreamType, const char *szAlramType, int nChannel, int nSeq = 0);

// 第三方报警服务器报警数据入口
int MC_OnRecvAlarmJsonData(UI_HANDLE hUser, const char *szJson, int nSeq = 0);
