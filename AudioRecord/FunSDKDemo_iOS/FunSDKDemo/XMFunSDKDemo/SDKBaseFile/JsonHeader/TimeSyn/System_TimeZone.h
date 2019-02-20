#pragma once
#include "FunSDK/JObject.h"

#define JK_System_TimeZone "System.TimeZone"  //设备时区
class System_TimeZone : public JObject
{
public:
	JIntObj		FirstUserTimeZone;
	JIntObj		timeMin; //距离0时区相差分钟数，可以小于零

public:
    System_TimeZone(JObject *pParent = NULL, const char *szName = JK_System_TimeZone):
    JObject(pParent,szName),
	FirstUserTimeZone(this, "FirstUserTimeZone"),
	timeMin(this, "timeMin"){
	};

    ~System_TimeZone(void){};
};
