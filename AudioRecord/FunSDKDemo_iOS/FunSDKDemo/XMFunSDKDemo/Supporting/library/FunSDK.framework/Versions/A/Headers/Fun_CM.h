/*********************************************************************************
*Author:	Yongjun Zhao
*Description:  
*History:  
Date:	2017.11.03/Yongjun Zhao
Action:Create
**********************************************************************************/
#pragma once
#include "XTypes.h"
#define N_MAX_DOWNLOAD_QUEUE_SIZE 32

//EMSG_MC_SearchMediaByMoth = 6202
// < 0 failed  >= 0 success
//日历功能(可同时查看视频节点 和 报警消息节点)
int MC_SearchMediaByMoth(UI_HANDLE hUser, const char *devId, int nChannel, const char *szStreamType, int nDate, int nSeq = 0);

//EMSG_MC_SearchMediaByTime = 6203,
//查询时间段内的视频片段
int MC_SearchMediaByTime(UI_HANDLE hUser, const char *devId, int nChannel, const char *szStreamType, int nStartTime, int nEndTime, int nSeq = 0);


// 下载录像等媒体的缩略图
// EMSG_MC_DownloadMediaThumbnail = 6204,
// nWidth,nHeight可以指定宽和高，等于0时默认为原始大小
int MC_DownloadThumbnail(UI_HANDLE hUser, const char *devId, const char *szJson, const char *szFileName, int nWidth = 0, int nHeight = 0, int nSeq = 0);

// MC_DownloadThumbnail异步返回，此函数可设置下载列表中的任务数量；默认为N_MAX_DOWNLOAD_QUEUE_SIZE
int MC_SetDownloadThumbnailMaxQueue(int nMaxQueueSize);

// 取消全部缩略图下载任务
void MC_StopDownloadThumbnail();

