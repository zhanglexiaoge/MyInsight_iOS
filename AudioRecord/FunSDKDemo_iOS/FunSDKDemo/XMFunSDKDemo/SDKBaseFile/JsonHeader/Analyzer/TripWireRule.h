#pragma once
#import "FunSDK/JObject.h"
#include "Limit.h"
#import "TripWire.h"
#define JK_TripWireRule "TripWireRule" 
class TripWireRule : public JObject
{
public:
	Limit		mLimit;   //单线限制参数
	JObjArray<TripWire>		TripWire; //单线位置
	JIntObj		TypeHuman;
	JIntObj		TypeLimit;
	JIntObj		TypeVehicle;

public:
    TripWireRule(JObject *pParent = NULL, const char *szName = JK_TripWireRule):
    JObject(pParent,szName),
	mLimit(this, "Limit"),
	TripWire(this, "TripWire"),
	TypeHuman(this, "TypeHuman"),
	TypeLimit(this, "TypeLimit"),
	TypeVehicle(this, "TypeVehicle"){
	};

    ~TripWireRule(void){};
};
