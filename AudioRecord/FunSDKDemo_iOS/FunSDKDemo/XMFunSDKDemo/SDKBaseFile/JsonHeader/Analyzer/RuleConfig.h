#pragma once
#import "FunSDK/JObject.h"
#include "AVDRule.h"
#include "CPCRule.h"
#include "OSCRule.h"
#include "PEARule.h"

#define JK_RuleConfig "RuleConfig" 
class RuleConfig : public JObject
{
public:
	AVDRule		mAVDRule;
	CPCRule		mCPCRule;
	OSCRule		mOSCRule;
	PEARule		mPEARule;

public:
    RuleConfig(JObject *pParent = NULL, const char *szName = JK_RuleConfig):
    JObject(pParent,szName),
	mAVDRule(this, "AVDRule"),
	mCPCRule(this, "CPCRule"),
	mOSCRule(this, "OSCRule"),
	mPEARule(this, "PEARule"){
	};

    ~RuleConfig(void){};
};
