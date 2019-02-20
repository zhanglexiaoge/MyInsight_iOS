#pragma once
#include "FunSDK/JObject.h"

#define JK_OPStorageManager "OPStorageManager" 
class OPStorageManager : public JObject //存储管理
{
public:
	JStrObj		Action;
	JIntObj		PartNo;
	JIntObj		SerialNo;
	JStrObj		Type;

public:
	OPStorageManager(JObject *pParent = NULL, const char *szName = JK_OPStorageManager):
	JObject(pParent,szName),
	Action(this, "Action"),
	PartNo(this, "PartNo"),
	SerialNo(this, "SerialNo"),
	Type(this, "Type"){
        char szConfig[256] = {0};
        sprintf(szConfig, "{\"Name\":\"%s\", \"%s\":{\"Action\":\"\",\"PartNo\":0,\"SerialNo\":0,\"Type\":\"\"}}", JK_OPStorageManager, JK_OPStorageManager);
        int nRet = Parse(szConfig);
	};

	~OPStorageManager(void){};
};
