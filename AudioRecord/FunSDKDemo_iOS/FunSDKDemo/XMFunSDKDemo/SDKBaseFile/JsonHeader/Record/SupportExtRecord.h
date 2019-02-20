#pragma once
#include "FunSDK/JObject.h"
//主辅码流录像配置能力级
#define JK_SupportExtRecord "SupportExtRecord" 
class SupportExtRecord : public JObject
{
public:
	JStrObj		AbilityPram; //0、只支持主码流。1、只支持辅码流。2、主辅码流都支持

public:
    SupportExtRecord(JObject *pParent = NULL, const char *szName = JK_SupportExtRecord):
    JObject(pParent,szName),
	AbilityPram(this, "AbilityPram"){
	};

    ~SupportExtRecord(void){};
};
