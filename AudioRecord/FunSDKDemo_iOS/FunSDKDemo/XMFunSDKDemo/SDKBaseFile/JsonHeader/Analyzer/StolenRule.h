#pragma once
#import "FunSDK/JObject.h"
#include "OscPara.h"
#import "SpclRgs.h"
#define JK_StolenRule "StolenRule" 
class StolenRule : public JObject
{
public:
	JIntObj		CameraType;
	OscPara		mOscPara;
	JIntObj		SceneType;
	JObjArray<SpclRgs>		SpclRgs; //要处理的区域配置和个数，目前只配置一个区域

public:
    StolenRule(JObject *pParent = NULL, const char *szName = JK_StolenRule):
    JObject(pParent,szName),
	CameraType(this, "CameraType"),
	mOscPara(this, "OscPara"),
	SceneType(this, "SceneType"),
	SpclRgs(this, "SpclRgs"){
	};

    ~StolenRule(void){};
};
