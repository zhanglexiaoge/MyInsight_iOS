#pragma once
#import "FunSDK/JObject.h"
#import "Points.h"
#define JK_SubRgA "SubRgA" 
class SubRgA : public JObject
{
public:
	JIntObj		PointNu;
	JObjArray<Points>		Points;
	JIntObj		Valid;

public:
    SubRgA(JObject *pParent = NULL, const char *szName = JK_SubRgA):
    JObject(pParent,szName),
	PointNu(this, "PointNu"),
	Points(this, "Points"),
	Valid(this, "Valid"){
	};

    ~SubRgA(void){};
};
