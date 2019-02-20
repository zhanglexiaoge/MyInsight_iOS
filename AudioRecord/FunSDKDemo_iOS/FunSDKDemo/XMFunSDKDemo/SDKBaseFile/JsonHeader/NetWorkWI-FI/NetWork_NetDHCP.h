#pragma once
#include "FunSDK/JObject.h"

#define JK_NetWork_NetDHCP "NetWork.NetDHCP" 
class NetWork_NetDHCP : public JObject
{
public:
	JBoolObj		Enable;
	JStrObj		Interface;

public:
    NetWork_NetDHCP(JObject *pParent = NULL, const char *szName = JK_NetWork_NetDHCP):
    JObject(pParent,szName),
	Enable(this, "Enable"),
	Interface(this, "Interface"){
	};

    ~NetWork_NetDHCP(void){};
};
