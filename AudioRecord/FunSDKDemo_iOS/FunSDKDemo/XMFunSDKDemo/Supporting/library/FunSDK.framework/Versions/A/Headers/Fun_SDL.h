#pragma once
#include "XTypes.h"

typedef enum EDEV_LOC_MSG_ID
{
    EDL_START = 10000,
    EDL_REMOVE = 10001,
    EDL_PAUSE = 10002,
    EDL_ON_SYN_COMPLETE = 1003,
    EDL_STOP = 1004,
}EDEV_LOC_MSG_ID;
int SDL_SendMessage(UI_HANDLE hUser, int nMsgId, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, const char *szParam = "", const void *pData = 0, int nDataLen = 0, int nSeq = 0);

