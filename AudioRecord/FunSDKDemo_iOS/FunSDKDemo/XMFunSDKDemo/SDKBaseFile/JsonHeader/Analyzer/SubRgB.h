#pragma once
#import "FunSDK/JObject.h"
#import "Points.h"
#define JK_SubRgB "SubRgB" 
class SubRgB : public JObject
{
public:
	JIntObj		PointNu;
	JObjArray<Points>		Points;
	JIntObj		Valid;

public:
    SubRgB(JObject *pParent = NULL, const char *szName = JK_SubRgB):
    JObject(pParent,szName),
	PointNu(this, "PointNu"),
	Points(this, "Points"),
	Valid(this, "Valid"){
	};

    ~SubRgB(void){};
};
