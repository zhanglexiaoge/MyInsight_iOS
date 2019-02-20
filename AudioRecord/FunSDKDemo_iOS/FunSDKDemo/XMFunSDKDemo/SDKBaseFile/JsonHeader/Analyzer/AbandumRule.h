#pragma once
#import "FunSDK/JObject.h"
#include "OscPara.h"
#import "SpclRgs.h"
#define JK_AbandumRule "AbandumRule" 
class AbandumRule : public JObject
{
public:
	JIntObj		CameraType;
	OscPara		mOscPara; //物品遗留使能的一些约束
	JIntObj		SceneType;
	JObjArray<SpclRgs>		SpclRgs; //要处理的区域配置和个数，目前只配置一个区域

public:
    AbandumRule(JObject *pParent = NULL, const char *szName = JK_AbandumRule):
    JObject(pParent,szName),
	CameraType(this, "CameraType"),
	mOscPara(this, "OscPara"),
	SceneType(this, "SceneType"),
	SpclRgs(this, "SpclRgs"){
	};

    ~AbandumRule(void){};
};
