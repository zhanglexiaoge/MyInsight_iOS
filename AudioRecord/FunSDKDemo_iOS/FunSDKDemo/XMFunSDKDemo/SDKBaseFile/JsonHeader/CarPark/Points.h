#pragma once
#include "FunSDK/JObject.h"

#define JK_Points "Points" 
class Points : public JObject
{
public:
	JIntObj		x;
	JIntObj		y;

public:
    Points(JObject *pParent = NULL, const char *szName = JK_Points):
    JObject(pParent,szName),
	x(this, "x"),
	y(this, "y"){
	};

    ~Points(void){};
};
