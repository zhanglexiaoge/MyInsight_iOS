#pragma once
#import "FunSDK/JObject.h"
#include "PerimeterRule.h"
#include "TripWireRule.h"

#define JK_PEARule "PEARule" 
class PEARule : public JObject
{
public:
	JIntObj		Level;//警戒级别，2低级，1中级，0高级
	JIntObj		PerimeterEnable;//周界规则使能，0关闭，1开启
	PerimeterRule		mPerimeterRule;//周界规则
	JIntObj		ShowRule; //是否显示规则
	JIntObj		ShowTrace; //是否显示轨迹
	JIntObj		ShowTrack;
	JIntObj		TripWireEnable;//单线规则使能，0关闭，1开启
	TripWireRule		mTripWireRule;//单线规则

public:
    PEARule(JObject *pParent = NULL, const char *szName = JK_PEARule):
    JObject(pParent,szName),
	Level(this, "Level"),
	PerimeterEnable(this, "PerimeterEnable"),
	mPerimeterRule(this, "PerimeterRule"),
	ShowRule(this, "ShowRule"),
	ShowTrace(this, "ShowTrace"),
	ShowTrack(this, "ShowTrack"),
	TripWireEnable(this, "TripWireEnable"),
	mTripWireRule(this, "TripWireRule"){
	};

    ~PEARule(void){};
};
