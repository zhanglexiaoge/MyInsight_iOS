#pragma once
#include "FunSDK/JObject.h"

#define JK_CarInfo "CarInfo" 
class CarInfo : public JObject
{
public:
	JIntObj		CanvasL;
	JIntObj		Canvas_l;
	JIntObj		CarH;
	JIntObj		CarW;

public:
    CarInfo(JObject *pParent = NULL, const char *szName = JK_CarInfo):
    JObject(pParent,szName),
	CanvasL(this, "CanvasL"),
	Canvas_l(this, "Canvas_l"),
	CarH(this, "CarH"),
	CarW(this, "CarW"){
	};

    ~CarInfo(void){};
};
