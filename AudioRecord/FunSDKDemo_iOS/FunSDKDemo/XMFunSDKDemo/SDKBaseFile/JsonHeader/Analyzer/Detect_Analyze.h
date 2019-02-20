#pragma once
#import "FunSDK/JObject.h"
#include "EventHandler.h"
#include "RuleConfig.h"

//智能分析
#define JK_Detect_Analyze "Detect.Analyze"
class Detect_Analyze : public JObject
{
public:
	JBoolObj		Enable; //开关
	EventHandler		mEventHandler;
	JIntObj		ModuleType; //当前使用的算法
	RuleConfig		mRuleConfig; //各种算法规则配置

public:
    Detect_Analyze(JObject *pParent = NULL, const char *szName = JK_Detect_Analyze):
    JObject(pParent,szName),
	Enable(this, "Enable"),
	mEventHandler(this, "EventHandler"),
	ModuleType(this, "ModuleType"),
	mRuleConfig(this, "RuleConfig"){
	};

    ~Detect_Analyze(void){};
};
