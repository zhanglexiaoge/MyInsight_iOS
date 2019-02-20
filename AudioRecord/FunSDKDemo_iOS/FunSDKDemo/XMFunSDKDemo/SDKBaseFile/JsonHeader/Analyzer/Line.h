#pragma once
#import "FunSDK/JObject.h"
#include "EndPt.h"
#include "StartPt.h"

#define JK_Line "Line" 
class Line : public JObject
{
public:
	EndPt		mEndPt; //单线结束点
	StartPt		mStartPt; //单线起始点

public:
    Line(JObject *pParent = NULL, const char *szName = JK_Line):
    JObject(pParent,szName),
	mEndPt(this, "EndPt"),
	mStartPt(this, "StartPt"){
	};

    ~Line(void){};
};
