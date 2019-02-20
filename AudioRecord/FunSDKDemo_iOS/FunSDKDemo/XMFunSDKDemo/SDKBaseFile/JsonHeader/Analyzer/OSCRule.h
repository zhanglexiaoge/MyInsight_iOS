#pragma once
#import "FunSDK/JObject.h"
#include "AbandumRule.h"
#include "NoParkingRule.h"
#include "StolenRule.h"

#define JK_OSCRule "OSCRule" 
class OSCRule : public JObject
{
public:
	JIntObj		AbandumEnable;//物品遗留使能,0关闭，1开启
	AbandumRule		mAbandumRule;//物品遗留参数
	JIntObj		Level;//警戒级别，2低级，1中级，0高级
	JIntObj		NoParkingEnable;//非法停车使能
	NoParkingRule		mNoParkingRule;
	JIntObj		ShowRule;//显示规则
	JIntObj		ShowTrace;//显示轨迹
	JIntObj		ShowTrack;
	JIntObj		StolenEnable;//物品被盗使能
	StolenRule		mStolenRule; //规则参数

public:
    OSCRule(JObject *pParent = NULL, const char *szName = JK_OSCRule):
    JObject(pParent,szName),
	AbandumEnable(this, "AbandumEnable"),
	mAbandumRule(this, "AbandumRule"),
	Level(this, "Level"),
	NoParkingEnable(this, "NoParkingEnable"),
	mNoParkingRule(this, "NoParkingRule"),
	ShowRule(this, "ShowRule"),
	ShowTrace(this, "ShowTrace"),
	ShowTrack(this, "ShowTrack"),
	StolenEnable(this, "StolenEnable"),
	mStolenRule(this, "StolenRule"){
	};

    ~OSCRule(void){};
};
