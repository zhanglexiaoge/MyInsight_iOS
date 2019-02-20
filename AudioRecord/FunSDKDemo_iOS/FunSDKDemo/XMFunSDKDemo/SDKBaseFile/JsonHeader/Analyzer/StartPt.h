#pragma once
#import "FunSDK/JObject.h"

#define JK_StartPt "StartPt" 
class StartPt : public JObject
{
public:
	JIntObj		x;
	JIntObj		y;

public:
    StartPt(JObject *pParent = NULL, const char *szName = JK_StartPt):
    JObject(pParent,szName),
	x(this, "x"),
	y(this, "y"){
	};

    ~StartPt(void){};
};
