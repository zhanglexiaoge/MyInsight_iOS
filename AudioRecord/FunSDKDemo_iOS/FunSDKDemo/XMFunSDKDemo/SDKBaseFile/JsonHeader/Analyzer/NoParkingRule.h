#pragma once
#import "FunSDK/JObject.h"
#include "OscPara.h"
#import "SpclRgs.h"
//非法停车使能
#define JK_NoParkingRule "NoParkingRule" 
class NoParkingRule : public JObject
{
public:
	JIntObj		CameraType;
	OscPara		mOscPara;
	JIntObj		SceneType;
	JObjArray<SpclRgs>		SpclRgs; //要处理的区域配置和个数，目前只配置一个区域

public:
    NoParkingRule(JObject *pParent = NULL, const char *szName = JK_NoParkingRule):
    JObject(pParent,szName),
	CameraType(this, "CameraType"),
	mOscPara(this, "OscPara"),
	SceneType(this, "SceneType"),
	SpclRgs(this, "SpclRgs"){
	};

    ~NoParkingRule(void){};
};
