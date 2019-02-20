#pragma once
#include "FunSDK/JObject.h"
#include "ability.h"
//数字通道编码配置能力级
#define JK_NetUse_DigitalAbility "NetUse.DigitalAbility" 
class NetUse_DigitalAbility : public JObject
{
public:
	ability		mability;
	JBoolObj		enable;
	JIntObj		nAudio;
	JIntObj		nCapture;
	JIntObj		videoFormat;

public:
    NetUse_DigitalAbility(JObject *pParent = NULL, const char *szName = JK_NetUse_DigitalAbility):
    JObject(pParent,szName),
	mability(this, "ability"),
	enable(this, "enable"),
	nAudio(this, "nAudio"),
	nCapture(this, "nCapture"),
	videoFormat(this, "videoFormat"){
	};

    ~NetUse_DigitalAbility(void){};
};
