/*********************************************************************************
*Author:	Zhihu Zhang (张志虎)
*Description:  
*History:  
Date:	2015.12.11/Zhihu Zhang
Action create
**********************************************************************************/
#pragma once
#include "XTypes.h"
// 初始化蜻蜓库
// appid:   [in] 蜻蜓app_id
// 返回值：0 成功；非0 失败
int QT_QingTingInit(UI_HANDLE hUser, const char *szAppId, int nSeq = 0);

// 获取目录
// categoryid:  根目录id
// response:    [out] 目录信息
int QT_QingTingGetCategoryies(UI_HANDLE hUser, const char *szCategoryId, int nSeq = 0);

// 获取点播电台
// categoryid:  根目录id
// response:    [out] 电台信息
int QT_QingTingGetChannels(UI_HANDLE hUser, const char *szCategoryId, int nCurpage, int nPagesize, int nSeq = 0);

// 获取直播电台
// categoryid:  根目录id
// curpage : 当前页数
// pagesize : 每页大小
// response:    [out] 电台信息
int QT_QingTingGetLiveChannels(UI_HANDLE hUser, const char *szCategoryId, int nCurpage, int nPagesize, int nSeq = 0);

// 获取指定节目信息
// channelid:  channe id
// curpage : 当前页数
// pagesize : 每页大小
// response:    [out] 节目信息
int QT_QingTingGetPrograms(UI_HANDLE hUser, const char *szChannelId, int nCurpage, int nPagesize, int nSeq = 0);

// 获取直播电台的节目单（直播）
// channelid :  [in] channe id
// 周几 1 = sunday, 2 = monday, ... , saturday = 7; day = 1 获取周日的节目; day = 1, 2, 3 获取周日,周一,周二的节目
// response:    [out] 节目信息
int QT_QingTingGetLivePrograms(UI_HANDLE hUser, const char *szChannelId, const char *szDayOfWeek, int nSeq = 0);

//  获取指定节目信息（点播）
// programid :  [in] program id
// response:    [out] 节目信息
int QT_QingTingGetProgramsDetail(UI_HANDLE hUser, const char *szProgramId, int nSeq = 0);

// 检索内容
// szKeyWord: [in] 关键字
// nCurpage: 当前页数
// nPagesize: 每页大小
// szContentType: 选择搜索内容： all：所有内容； channel：直播电台； virtualchannel：点播电台；virtualprogram：直播节目
// response: [out]检索出的内容
int QT_QingTingSearchContent(UI_HANDLE hUser, const char *szKeyWord, int nCurpage, int nPagesize, const char *szContentType, int nSeq = 0);





