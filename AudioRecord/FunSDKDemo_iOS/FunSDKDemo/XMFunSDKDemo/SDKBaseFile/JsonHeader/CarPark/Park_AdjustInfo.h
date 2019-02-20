#pragma once
#include "FunSDK/JObject.h"
#include "CarInfo.h"
#import "Points.h"

#define JK_Park_AdjustInfo "Park.AdjustInfo" 
class Park_AdjustInfo : public JObject
{
public:
	CarInfo		mCarInfo;
	JBoolObj		Enable;
    JObjArray<JObjArray<Points> >        Points;

public:
    Park_AdjustInfo(JObject *pParent = NULL, const char *szName = JK_Park_AdjustInfo):
    JObject(pParent,szName),
	mCarInfo(this, "CarInfo"),
	Enable(this, "Enable"),
	Points(this, "Points"){
	};

    ~Park_AdjustInfo(void){};
};
