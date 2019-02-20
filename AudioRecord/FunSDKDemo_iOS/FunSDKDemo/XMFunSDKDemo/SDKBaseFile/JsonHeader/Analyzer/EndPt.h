#pragma once
#import "FunSDK/JObject.h"

#define JK_EndPt "EndPt" 
class EndPt : public JObject
{
public:
	JIntObj		x;
	JIntObj		y;

public:
    EndPt(JObject *pParent = NULL, const char *szName = JK_EndPt):
    JObject(pParent,szName),
	x(this, "x"),
	y(this, "y"){
	};

    ~EndPt(void){};
};
