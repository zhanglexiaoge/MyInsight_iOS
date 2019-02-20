#pragma once
#import "FunSDK/JObject.h"
#include "OscRg.h"
#include "SubRgA.h"
#include "SubRgB.h"
#include "SubRgC.h"

#define JK_SpclRgs "SpclRgs" 
class SpclRgs : public JObject
{
public:
	JStrObj		Name;
	OscRg		mOscRg; //具体的区域定义，包括点的数量和点坐标数组
	SubRgA		mSubRgA;
	SubRgB		mSubRgB;
	SubRgC		mSubRgC;
	JIntObj		Valid; //是否有效

public:
    SpclRgs(JObject *pParent = NULL, const char *szName = JK_SpclRgs):
    JObject(pParent,szName),
	Name(this, "Name"),
	mOscRg(this, "OscRg"),
	mSubRgA(this, "SubRgA"),
	mSubRgB(this, "SubRgB"),
	mSubRgC(this, "SubRgC"),
	Valid(this, "Valid"){
	};

    ~SpclRgs(void){};
};
