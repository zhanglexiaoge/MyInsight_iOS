/*********************************************************************************
*Author:	Yongjun Zhao
*Description:  
*History:  
Date: 2014.12.11/Yongjun Zhao
Action:Create
**********************************************************************************/
#pragma once
#include "XTypes.h"

typedef enum EMP4_EDIT_MSG
{
    EMSG_MF_ON_SUB_FILE = FUN_USER_MSG_BEGIN_1 + 1900,
    EMSG_MF_ON_EDIT_FILE = 5901,
}EMP4_EDIT_MSG;

// szSrcFile:源文件(mp4文件格式)
// szDesFile:目标文件
// nTimeBegin, nTimeEnd:开始结束时间,单位毫秒
// 相关消息ID EMSG_MF_ON_SUB_FILE_PROGRESS:进度及结果 0~100:进度 200:成功 <0:失败
int MP4_SubFile(UI_HANDLE hUser, const char *szSrcFile, const char *szDesFile, int nTimeBegin, int nTimeEnd, int nSeq = 0);

// Mp4 File Formate
int EMP4_CreateFormatFile(UI_HANDLE hUser, const char *szDesFile);
int EMP4_StartFormate(int hFileObj);
int EMP4_CancelFormate(int hFileObj);
int EMP4_DestoryFormate(int hFileObj);

// MP4文件操作
// 返回操作nFileIndex
int EMP4_InsertSrcFile(int hFileObj, const char *szSrcFile, int nIndex);
int EMP4_RemoveSrcFile(int hFileObj, const char *szSrcFile);
int EMP4_SetSrcFileIndex(int hFileObj, const char *szSrcFile, int nIndex);

// 设置背景音乐(要求MP3格式)
int EMP4_SetAudioFile(int hFileObj, const char *szAudioFile);

// nSpeed:1:Normal Speed
//int EMP4_SetSrcFileSpeed(int hFileObj, const char *szSrcFile, float nSpeed);

