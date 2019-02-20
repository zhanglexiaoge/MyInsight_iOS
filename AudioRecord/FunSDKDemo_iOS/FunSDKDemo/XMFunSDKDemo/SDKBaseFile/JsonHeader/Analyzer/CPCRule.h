#pragma once
#import "FunSDK/JObject.h"

#define JK_CPCRule "CPCRule" //暂时不需要设置这个类型
class CPCRule : public JObject
{
public:
	JIntObj		Countmax;
	JIntObj		EnterDirection;
	JStrObj		Flag;
	JObjArray<JObject>		Points;
	JIntObj		Sensitivity;
	JIntObj		Sizemax;
	JIntObj		Sizemin;

public:
    CPCRule(JObject *pParent = NULL, const char *szName = JK_CPCRule):
    JObject(pParent,szName),
	Countmax(this, "Countmax"),
	EnterDirection(this, "EnterDirection"),
	Flag(this, "Flag"),
	Points(this, "Points"),
	Sensitivity(this, "Sensitivity"),
	Sizemax(this, "Sizemax"),
	Sizemin(this, "Sizemin"){
	};

    ~CPCRule(void){};
};
