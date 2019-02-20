#pragma once
#include "FunSDK/JObject.h"

#define JK_TimeTitleAttribute "TimeTitleAttribute" 
class TimeTitleAttribute : public JObject
{
public:
	JStrObj		BackColor;
	JBoolObj		EncodeBlend;
	JStrObj		FrontColor;
	JBoolObj		PreviewBlend;
	JObjArray<JIntObj>		RelativePos;

public:
    TimeTitleAttribute(JObject *pParent = NULL, const char *szName = JK_TimeTitleAttribute):
    JObject(pParent,szName),
	BackColor(this, "BackColor"),
	EncodeBlend(this, "EncodeBlend"),
	FrontColor(this, "FrontColor"),
	PreviewBlend(this, "PreviewBlend"),
	RelativePos(this, "RelativePos"){
	};

    ~TimeTitleAttribute(void){};
};
