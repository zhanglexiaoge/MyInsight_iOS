#pragma once
#import "FunSDK/JObject.h"
#include "Boundary.h"

#define JK_LimitPara "LimitPara" 
class LimitPara : public JObject
{
public:
	Boundary		mBoundary; //边界点数据
	JIntObj		DirectionLimit;//方向限制，0双向，1进入，2离开
	JIntObj		ForbiddenDirection;
	JIntObj		MinDist; //最小像素
	JIntObj		MinTime; //最小时间

public:
    LimitPara(JObject *pParent = NULL, const char *szName = JK_LimitPara):
    JObject(pParent,szName),
	mBoundary(this, "Boundary"),
	DirectionLimit(this, "DirectionLimit"),
	ForbiddenDirection(this, "ForbiddenDirection"),
	MinDist(this, "MinDist"),
	MinTime(this, "MinTime"){
	};

    ~LimitPara(void){};
};
