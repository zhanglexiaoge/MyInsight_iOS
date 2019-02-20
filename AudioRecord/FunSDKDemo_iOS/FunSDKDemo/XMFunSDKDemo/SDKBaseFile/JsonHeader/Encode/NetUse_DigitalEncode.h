#pragma once
#include "FunSDK/JObject.h"
#include "ExtraFormat.h"
#include "MainFormat.h"
//数字通道编码配置
#define JK_NetUse_DigitalEncode "NetUse.DigitalEncode" 
class NetUse_DigitalEncode : public JObject
{
public:
	ExtraFormat		mExtraFormat;
	MainFormat		mMainFormat;

public:
    NetUse_DigitalEncode(JObject *pParent = NULL, const char *szName = JK_NetUse_DigitalEncode):
    JObject(pParent,szName),
	mExtraFormat(this, "ExtraFormat"),
	mMainFormat(this, "MainFormat"){
	};

    ~NetUse_DigitalEncode(void){};
};
