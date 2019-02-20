/*********************************************************************************
 *Author:	Yongjun Zhao(赵永军)
 *Description:
 *History:
Date:	2016.02.17/Yongjun Zhao
 Action：Create
 **********************************************************************************/
#pragma once
#include "XTypes.h"

typedef struct SClientMessageInfo
{
    UI_HANDLE hUser;  // 消息接收者

    //URL = https://app.xmeye.net/advert?app=apptest&advertUse=logo1&imgWidth=1080&imgHeight=1920
    char serverIP[64];      // 默认："app.xmeye.net"
    int  nServerPort;
    char serverUrl[64];     // 比如："/xmfamily/"（前后需要加分隔符'/'，也可以多级目录）
    int  bDownloadVideoAd;
    int  bDownloadImageAd;
    
    // 缓存广告和保存临时文件,比如“/sdcard/myapp/adtemppath/”
    char tempFilePath[512];
    
    //  显示窗口的大小（一般为屏幕的宽、高）
    int  nViewWidth;
    int  nViewHeight;
    
    // 默认为简体中文，；目前支持简体中文、英两种语言；
    // 与本地翻译类型一样
    char language[32];
    char appId[64];     // Android的包名或IOS的Boundle Idtentifier
    char advertUse[64];     // 广告用途，如开机广告（字段在后台app设置广告的时候设值）
    SClientMessageInfo();
}SClientMessageInfo;

// 初始化函数
int CM_Init(const SClientMessageInfo *pInfo);

// 更新广告，自定义消息等（调用后会更新广告等到本地）
void CM_UpdateMessage();

// 获取视频广告路径,本地没有视频时没有返回""
const char *CM_GetVideoPath();

// 获取图片广告路径,本地没有图片时没有返回""
const char *CM_GetPicPath();

// 获取点击图片后跳转的URL
const char *CM_GetADUrl();

// 获取广告播放时长
int CM_GetTimeLong();


// 更新广告 版本2
void CM_UpdateADV2();
const char *CM_GetADContent();

const char *CM_GetValue(const char *szKey, const char *szDefault = "");
int CM_GetIntValue(const char *szKey, int nDelfault = 0);

//////////////////////////系统消息功能接口/////////////////////////////
// 更新当前最新的系统消息
// < 0失败 >=0成功
// 获取当前最新消息,EMSG_CM_ON_GET_SYS_MSG返回结果
int CM_UpdateSysMsg(UI_HANDLE hUser);
int CM_NoShowMsg(uint64 nMsgId);        // 不再显示当前最新消息

// 获取系统
// < 0失败 >=0成功
// 获取当前最新消息,EMSG_CM_ON_GET_SYS_MSG_LIST返回结果
int CM_GetSysMsgList(UI_HANDLE hUser);
/////////////////////////////////////////////////////////////////////



