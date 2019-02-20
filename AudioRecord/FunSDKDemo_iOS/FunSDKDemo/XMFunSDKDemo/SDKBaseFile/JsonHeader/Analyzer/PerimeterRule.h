#pragma once
#import "FunSDK/JObject.h"
#include "LimitPara.h"

#define JK_PerimeterRule "PerimeterRule" 
class PerimeterRule : public JObject
{
public:
	LimitPara		mLimitPara;
	JIntObj		Mode; //周界模式
	JIntObj		TypeHuman;
	JIntObj		TypeLimit;
	JIntObj		TypeVehicle;

public:
    PerimeterRule(JObject *pParent = NULL, const char *szName = JK_PerimeterRule):
    JObject(pParent,szName),
	mLimitPara(this, "LimitPara"),
	Mode(this, "Mode"),
	TypeHuman(this, "TypeHuman"),
	TypeLimit(this, "TypeLimit"),
	TypeVehicle(this, "TypeVehicle"){
	};

    ~PerimeterRule(void){};
};
