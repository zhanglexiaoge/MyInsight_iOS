/*********************************************************************************
*Author:	Zhihu Zhang(张志虎)
*Description:
*History:
Date:	2015.05.11/Zhihu Zhang
Action：Create
**********************************************************************************/
#pragma once
#include "XTypes.h"

int XD_LinkMedia(UI_HANDLE hUser, const char * uuid, int mediaId ,int nSeq = 0);

int XD_UnlinkMedia(UI_HANDLE hUser, const char * uuid, int mediaId ,int nSeq = 0);

//查询历史点击数前num  的设备
int XD_PublicHistoryList(UI_HANDLE hUser, const int num, int nSeq = 0);
//查询当前在线数前num  的设备
int XD_PublicCurrentList(UI_HANDLE hUser, const int num, int nSeq = 0);
//查询设备的点击量跟在线数
int XD_PublicDevInfo(UI_HANDLE hUser, const char * uuid, int nSeq = 0);
//获取设备的缩略图，注意:buf的内存需要在外面delete
int XD_FetchPicture(UI_HANDLE hUser, const char *ip, const char *uuid,const char *szFileName,int nSeq = 0);

