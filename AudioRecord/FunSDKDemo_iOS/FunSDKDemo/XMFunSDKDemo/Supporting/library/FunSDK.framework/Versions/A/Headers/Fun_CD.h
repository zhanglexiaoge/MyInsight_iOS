/*********************************************************************************
*Author:	Yongjun Zhao
*Description:  
*History:  
Date:	2014.01.01/Yongjun Zhao
Action:Create
**********************************************************************************/
#pragma once
#include "XTypes.h"

typedef enum ERECODE_TYPE
{
    RECODE_NORMAL = 0,   // 正常录像
    RECODE_MARK = 1,     // 关键录像
}ERECODE_TYPE;

typedef enum ESTREAM_TYPE
{
    ESTREAM_TYPE_MAIN = 0,
    ESTREAM_TYPE_SUB = 1,
    ESTREAM_TYPE_ALL = 2,
}ESTREAM_TYPE;

typedef struct MediaTimeSect_T
{
    unsigned int begin;
    unsigned int end;
    int nRecType;    // ERECODE_TYPE
    int nStreamType; // ESTREAM_TYPE
}MediaTimeSect_T;

typedef struct SDateType
{
    char date[12];  // 2015-01-01
    int  type;     // 1:namal 1:mark
}SDateType;
typedef struct MediaDates
{
    char devId[32];
    int  nChnId;
    int  nStreamType;
    int  nItemCount;
    SDateType date[128]; // 20150101
}MediaDates;

// API废弃，不再使用
int CD_MediaRecordDates(UI_HANDLE hUser, const char *devId, int nChnId, int nStreamType, int nSeq = 0);

// API废弃，不再使用
int CD_MediaTimeSect(UI_HANDLE hUser, const char *devId, int nChnId, int nStreamType, int date, int nSeq = 0);


//int CD_CloudDowonLoadRecord(UI_HANDLE hUser, const SMediaFileInfo *media, int nBeign, int nEnd, const char *szFileName, int nSeq = 0);

